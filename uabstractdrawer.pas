unit uAbstractDrawer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ComCtrls, ExtCtrls, uBlockColection,
  MMSystem, uControlConfig;

type
    TMode = (modePut, modePick);

  { TAbstractDrawer }

  CanNotDrawBlockNoSelectedException = class(Exception);

  CanNotDrawAreadyExistABlockException = class(Exception);

  TAbstractDrawer = class
  private
    FnZoom: integer;
  protected
    procedure SetZoom(AValue: integer); virtual;

  public
    FnCurrentPlaceOffsetX: integer;
    FnCurrentPlaceOffsetY: integer;
    FnCurrentPlaceOffsetZ: integer;
    FnCurrentPlacePositionXMax: integer;
    FnCurrentPlacePositionYMax: integer;
    FnCurrentPlacePositionZMax: integer;

    FnCurrentPlacePositionX: integer;
    FnCurrentPlacePositionY: integer;
    FnCurrentPlacePositionZ: integer;
    FControlPlace1: TControlConfig;
    FnSelectedBlockIndex: integer;
    FoBlockImages: TImageList;
    FoCurrentPlaceTabSeet: TTabSheet;
    FoCurrentPlaceImageBackgroung: TImage;
    FoCurrentPlaceImageTarget: TImage;
    FBlockSourceFilenames: Array of string;
    FoMode: TMode;
    FoCurrentPlaceBlockCollection: TBlockColection;

    FoNextDrawer: TAbstractDrawer;
    FoPrevDrawer: TAbstractDrawer;

    procedure updateTargetImagePosition; virtual;

    procedure setSelectedBlockIndex(const SelectedBlockIndex: integer);

    procedure loadBlockSourceFileNamesFrom(const arrInput: array of string); virtual;

    function putNewBlock(imageTargetPlace1hand: TImage): TBlock; virtual;
    procedure pickBlock; virtual;

    procedure moveBlock(block: TBlock; const effect: string); virtual;

    procedure moveBlockToWithoutCursor(block: TBlock; const x, y, z: integer;
      const effect: string); virtual;

    procedure setNextDrawer(drawer: TAbstractDrawer);

    procedure SetCurrentPlacePositionX(const value: integer); virtual;
    procedure SetCurrentPlacePositionY(const value: integer); virtual;
    procedure SetCurrentPlacePositionZ(const value: integer); virtual;


    property CurrentPlacePositionX: integer read FnCurrentPlacePositionX
      write SetCurrentPlacePositionX;

    property CurrentPlacePositionY: integer read FnCurrentPlacePositionY
      write SetCurrentPlacePositionY;

    property CurrentPlacePositionZ: integer read FnCurrentPlacePositionZ
      write SetCurrentPlacePositionZ;

    property Zoom: integer read FnZoom write SetZoom;


  end;

implementation

const
  C_OFFSET_Z = 3;

{ TAbstractDrawer }

procedure TAbstractDrawer.updateTargetImagePosition;
begin
    FoCurrentPlaceImageTarget.Top := FnCurrentPlaceOffsetY +
    (FoCurrentPlaceImageBackgroung.Height -
    ((FnCurrentPlacePositionY + 1)  * FoCurrentPlaceImageTarget.Height));

  //FoCurrentPlaceImageTarget.Top := FoCurrentPlaceImageTarget.Top +
  //  (FnCurrentPlacePositionZ * C_OFFSET_Z);

  FoCurrentPlaceImageTarget.Left := FnCurrentPlaceOffsetX +
    (FnCurrentPlacePositionX * FoCurrentPlaceImageTarget.Width);

  //FoCurrentPlaceImageTarget.Left := FoCurrentPlaceImageTarget.Left -
  //  (FnCurrentPlacePositionZ * C_OFFSET_Z);

  if Assigned(FoNextDrawer) then
    FoNextDrawer.updateTargetImagePosition;

end;

procedure TAbstractDrawer.SetZoom(AValue: integer);
begin
  if FnZoom = AValue then Exit;
  FnZoom := AValue;

  if Assigned(FoNextDrawer) then
    FoNextDrawer.SetZoom(AValue);
end;

procedure TAbstractDrawer.setSelectedBlockIndex(
  const SelectedBlockIndex: integer);
begin
  FnSelectedBlockIndex := SelectedBlockIndex;
  if Assigned(FoNextDrawer) then
    FoNextDrawer.setSelectedBlockIndex(SelectedBlockIndex);

end;

procedure TAbstractDrawer.loadBlockSourceFileNamesFrom(
  const arrInput: array of string);
var
  i: integer;
begin
  SetLength(FBlockSourceFilenames, Length(arrInput));
  for i := 0 to High(arrInput) do
    FBlockSourceFilenames[i] := arrInput[i];

end;

function TAbstractDrawer.putNewBlock(imageTargetPlace1hand: TImage): TBlock;
var
  newImage: TImage;

begin
  if (FnSelectedBlockIndex < 0) or (FnSelectedBlockIndex > High(FBlockSourceFilenames)) then
  begin
    raise Exception.Create('Select a block first');
    exit;
  end;

  if FoCurrentPlaceBlockCollection.find(FnCurrentPlacePositionX, FnCurrentPlacePositionY,
      FnCurrentPlacePositionZ) <> nil then
  begin
   raise Exception.Create('Aready exist a block on this position. Pick or move...');
  end;

  newImage := TImage.Create(FoCurrentPlaceTabSeet);
  newImage.Top := imageTargetPlace1hand.Top + (FnCurrentPlacePositionZ * C_OFFSET_Z);
  newImage.Left := imageTargetPlace1hand.Left - (FnCurrentPlacePositionZ * C_OFFSET_Z);
  newImage.Height := imageTargetPlace1hand.Height;
  newImage.Width := imageTargetPlace1hand.Width;
  newImage.Stretch := true;

  FoCurrentPlaceTabSeet.InsertControl(newImage);

  imageTargetPlace1hand.BringToFront;
  FoCurrentPlaceImageBackgroung.SendToBack;

  newImage.Picture.LoadFromFile(FBlockSourceFilenames[FnSelectedBlockIndex]);
  newImage.Update;

  result :=
    TBlock.create(FnCurrentPlacePositionX, FnCurrentPlacePositionY,
      FnCurrentPlacePositionZ, FnSelectedBlockIndex, newImage,
      FBlockSourceFilenames[FnSelectedBlockIndex]);

  FoCurrentPlaceBlockCollection.add(result);

  Inc(FnCurrentPlacePositionZ);

  if Assigned(FoNextDrawer) then
    FoNextDrawer.putNewBlock(imageTargetPlace1hand);

  PlaySound('C:\git\BbuildwithBlocksGame\sounds\newblock.wav', 0, SND_ASYNC);

end;

procedure TAbstractDrawer.pickBlock;
var
  block: TBlock;
  maxZ: integer;
begin

  block := FoCurrentPlaceBlockCollection.find(FnCurrentPlacePositionX,
    FnCurrentPlacePositionY, FnCurrentPlacePositionZ);
  if block <> nil then
  begin
    if block.FoImage <> nil then
    begin
      FoCurrentPlaceTabSeet.RemoveControl(block.FoImage);
      block.FoImage.Free;
    end;
    FoCurrentPlaceBlockCollection.remove(block);

    maxZ := FoCurrentPlaceBlockCollection.findMaxZ(
      FnCurrentPlacePositionX, FnCurrentPlacePositionY, 0).FnZ;
    if maxZ > FnCurrentPlacePositionZ then
      FnCurrentPlacePositionZ := FnCurrentPlacePositionZ - 1
    else
      FnCurrentPlacePositionZ := maxZ;

    if FnCurrentPlacePositionZ < 0 then
      FnCurrentPlacePositionZ := 0;

     block.Free;
  end;

  if Assigned(FoNextDrawer) then
    FoNextDrawer.pickBlock;

  PlaySound('C:\git\BbuildwithBlocksGame\sounds\pickblock.wav', 0, SND_ASYNC);

end;


procedure TAbstractDrawer.moveBlock(block: TBlock; const effect: string);
begin

  block.FoImage.Top :=  FoCurrentPlaceImageTarget.Top + (FnCurrentPlacePositionZ * C_OFFSET_Z);
  block.FoImage.Left := FoCurrentPlaceImageTarget.Left - (FnCurrentPlacePositionZ * C_OFFSET_Z);
  block.FoImage.Height := FoCurrentPlaceImageTarget.Height;
  block.FoImage.Width := FoCurrentPlaceImageTarget.Width;


  if Assigned(FoNextDrawer) then
    FoNextDrawer.moveBlock(block, effect);

end;

procedure TAbstractDrawer.moveBlockToWithoutCursor(block: TBlock; const x, y,
  z: integer; const effect: string);
var
  t, l: integer;
begin
  t := FnCurrentPlaceOffsetY + (FoCurrentPlaceImageBackgroung.Height -
  ((y + 1)  * FoCurrentPlaceImageTarget.Height));

  l := FnCurrentPlaceOffsetX + (x * FoCurrentPlaceImageTarget.Width);

  block.FoImage.Top :=  t + (z * C_OFFSET_Z);
  block.FoImage.Left := l - (z * C_OFFSET_Z);

  block.FoImage.Height := FoCurrentPlaceImageTarget.Height;
  block.FoImage.Width := FoCurrentPlaceImageTarget.Width;

  FoCurrentPlaceBlockCollection.remove(block);

  block.FnX := x;
  block.FnY := y;
  block.FnZ := z;

  FoCurrentPlaceBlockCollection.add(block);

  if Assigned(FoNextDrawer) then
    FoNextDrawer.moveBlockToWithoutCursor(block, x, y, z, effect);
end;

procedure TAbstractDrawer.setNextDrawer(drawer: TAbstractDrawer);
begin
  FoNextDrawer := drawer;
  FoNextDrawer.FoPrevDrawer := self;
end;

procedure TAbstractDrawer.SetCurrentPlacePositionX(const value: integer);
begin
  FnCurrentPlacePositionX := value;
  if Assigned(FoNextDrawer) then
    FoNextDrawer.SetCurrentPlacePositionX(value);
end;

procedure TAbstractDrawer.SetCurrentPlacePositionY(const value: integer);
begin
  FnCurrentPlacePositionY := value;
  if Assigned(FoNextDrawer) then
    FoNextDrawer.SetCurrentPlacePositionY(value);
end;

procedure TAbstractDrawer.SetCurrentPlacePositionZ(const value: integer);
begin
  FnCurrentPlacePositionZ := value;
  if Assigned(FoNextDrawer) then
    FoNextDrawer.SetCurrentPlacePositionZ(value);

end;

end.


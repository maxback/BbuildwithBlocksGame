unit uAbstractDrawer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ComCtrls, ExtCtrls, uBlockColection,
  MMSystem, uControlConfig;

type
    TMode = (modePut, modePick);

  { TAbstractDrawer }

  TAbstractDrawer = class
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

    function putNewBlock(imageTargetPlace1hand: TImage): TBlock; virtual;
    procedure pickBlock; virtual;

    procedure moveBlock(block: TBlock; const effect: string); virtual;


    procedure setNextDrawer(drawer: TAbstractDrawer);

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

procedure TAbstractDrawer.setNextDrawer(drawer: TAbstractDrawer);
begin
  FoNextDrawer := drawer;
  FoNextDrawer.FoPrevDrawer := self;
end;

end.


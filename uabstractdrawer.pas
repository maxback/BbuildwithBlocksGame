unit uAbstractDrawer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ComCtrls, ExtCtrls, uBlockColection,
  uControlConfig;

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

    procedure putNewBlock(imageTargetPlace1hand: TImage); virtual;
    procedure pickBlock; virtual;


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

procedure TAbstractDrawer.putNewBlock(imageTargetPlace1hand: TImage);
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

  FoCurrentPlaceBlockCollection.add(
    TBlock.create(FnCurrentPlacePositionX, FnCurrentPlacePositionY,
      FnCurrentPlacePositionZ, newImage,
      FBlockSourceFilenames[FnSelectedBlockIndex]));

  Inc(FnCurrentPlacePositionZ);

  if Assigned(FoNextDrawer) then
    FoNextDrawer.putNewBlock(imageTargetPlace1hand);

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

end;

procedure TAbstractDrawer.setNextDrawer(drawer: TAbstractDrawer);
begin
  FoNextDrawer := drawer;
  FoNextDrawer.FoPrevDrawer := self;
end;

end.


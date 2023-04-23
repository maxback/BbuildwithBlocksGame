unit uCanvasDrawer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics, uBlockColection, uAbstractDrawer;

const
  C_MAX_BLOCK_CACHE_COUNT = 30;
type

  { TCanvasDrawer }

  TCanvasDrawer = class(TAbstractDrawer)
  private
    FnMaxW: integer;
    x, y: integer;
    Canvas: TCanvas;
    FoBlockImageCache: TStringList;
    procedure dl(const s: string);
  protected
    FnZoom: integer;
    ZoomChanged: boolean;
    FnOldBlockWidth, FnCurrentBlockWidth: integer;
    FnOldBlockHeight, FnCurrentBlockHeight: integer;
    procedure RepaintAllArea;
    procedure SetZoom(AValue: integer); override;
    procedure AdjustZoom(imageTargetPlace1hand: TImage);

  public

    procedure updateTargetImagePosition; override;

    function putNewBlock(imageTargetPlace1hand: TImage): TBlock; override;
    procedure pickBlock; override;
	procedure moveBlock(block: TBlock; const effect: string); override;

    constructor Create(oCanvas: TCanvas);
    destructor Destroy; override;

    procedure setCanvas(oCanvas: TCanvas);
  end;

implementation

{ TCanvasDrawer }

procedure TCanvasDrawer.dl(const s: string);
begin
  {
  if not Assigned(Canvas) then
    exit;

  Canvas.TextOut(x, y, s);

  if Canvas.TextWidth(s) > FnMaxW then
    FnMaxW := Canvas.TextWidth(s);

  y := y + Canvas.TextHeight(s) + 3;
  if y > 659 then
  begin
    Y := 1;
    x := x + FnMaxW + 3;
    FnMaxW := 30;
  end;
  }
end;

procedure TCanvasDrawer.RepaintAllArea;

begin
  //
end;

procedure TCanvasDrawer.SetZoom(AValue: integer);
begin
  if FnZoom = AValue then Exit;
  FnZoom := AValue;
  dl('Zoom changed to ' + IntToStr(FnZoom) + '%');

  ZoomChanged := true;

  //here I need to redraw the entiry canvas area acording then zoon
  RepaintAllArea;
end;

procedure TCanvasDrawer.AdjustZoom(imageTargetPlace1hand: TImage);
begin
  if ZoomChanged then
  begin
    ZoomChanged := false;
    FnOldBlockWidth := FnCurrentBlockWidth;
    FnOldBlockHeight := FnCurrentBlockHeight;

    FnCurrentBlockWidth := ((imageTargetPlace1hand.Width * 1000 div 100) * FnZoom) div 1000;
    FnCurrentBlockHeight := ((imageTargetPlace1hand.Height * 1000div 100) * FnZoom) div 1000;

    dl('Block Width changed to ' + IntToStr(FnCurrentBlockWidth)
      + ' and Width Height to ' + IntToStr(FnCurrentBlockHeight));
  end;
end;

procedure TCanvasDrawer.updateTargetImagePosition;
begin
  dl('updateTargetImagePosition()');

  if Assigned(FoNextDrawer) then
    FoNextDrawer.updateTargetImagePosition;
end;

function TCanvasDrawer.putNewBlock(imageTargetPlace1hand: TImage): TBlock;
 var
   newImage: TImage;
   objIndex: integer;
   freeNewImage: boolean;
   l,t,r,b: integer;
 begin
   freeNewImage := false;
   dl('putNewBlock(' + IntToStr(integer(pointer(imageTargetPlace1hand))) + ')');
   if (FnSelectedBlockIndex < 0) or (FnSelectedBlockIndex > High(FBlockSourceFilenames)) then
   begin
     raise CanNotDrawBlockNoSelectedException.Create('Select a block first');
     exit;
   end;

   if (FoPrevDrawer = nil) and (FoCurrentPlaceBlockCollection.find(FnCurrentPlacePositionX, FnCurrentPlacePositionY,
       FnCurrentPlacePositionZ) <> nil) then
   begin
    raise CanNotDrawAreadyExistABlockException.Create('Aready exist a block on this position. Pick or move...');
   end;


   AdjustZoom(imageTargetPlace1hand);

   objIndex := FoBlockImageCache.IndexOf(IntToStr(FnSelectedBlockIndex));
   if objIndex < 0 then
   begin
     newImage := TImage.Create(nil);
     //newImage.Height := imageTargetPlace1hand.Height;
     //newImage.Width := imageTargetPlace1hand.Width;
     //newImage.Stretch := true;
     if FoBlockImageCache.Count < C_MAX_BLOCK_CACHE_COUNT then
       FoBlockImageCache.AddObject(IntToStr(FnSelectedBlockIndex), newImage)
     else
       freeNewImage := true;
   end
   else
   begin
     newImage := TImage(FoBlockImageCache.Objects[objIndex]);
   end;

   l := FnCurrentBlockWidth * FnCurrentPlacePositionX;
   b := FnCurrentBlockHeight * FnCurrentPlacePositionY;
   b := Self.Canvas.Height - b;
   r := l + FnCurrentBlockWidth;
   t := b - FnCurrentBlockHeight;

   newImage.Top := t;
   newImage.Left := l;

   newImage.Picture.LoadFromFile(FBlockSourceFilenames[FnSelectedBlockIndex]);
   //?? here a image has puts aways on this original size
   //how streatch like TImage?
   //on canvas?
   //use FnZoomHere now

   Self.Canvas.StretchDraw(Rect(l, t, r, b), newImage.Picture.Graphic);

   //Self.Canvas.Draw(FnCurrentPlacePositionX * imageTargetPlace1hand.Width,
   //  FnCurrentPlacePositionY * imageTargetPlace1hand.Height,
   //  newImage.Picture.Graphic);

   result :=
     TBlock.create(FnCurrentPlacePositionX, FnCurrentPlacePositionY,
       FnCurrentPlacePositionZ, FnSelectedBlockIndex, newImage,
       FBlockSourceFilenames[FnSelectedBlockIndex]);

   if FoPrevDrawer = nil then
   begin
     FoCurrentPlaceBlockCollection.add(result);

     Inc(FnCurrentPlacePositionZ);
   end;

   if freeNewImage then
     newImage.Free;

  Result:= nil;

  if Assigned(FoNextDrawer) then
    FoNextDrawer.putNewBlock(imageTargetPlace1hand);
end;

procedure TCanvasDrawer.pickBlock;
begin
  dl('pickBlock()');

  if Assigned(FoNextDrawer) then
    FoNextDrawer.pickBlock;
end;

procedure TCanvasDrawer.moveBlock(block: TBlock; const effect: string);
begin
  dl('moveBlock(' + IntToStr(integer(pointer(block))) + ', ' + effect + ')');
  if Assigned(FoNextDrawer) then
    FoNextDrawer.moveBlock(block, effect);

end;

constructor TCanvasDrawer.Create(oCanvas: TCanvas);
begin
  FnMaxW := 30;
  FoBlockImageCache := TStringList.Create;
  FnZoom := 100;
  FnOldBlockWidth := 10;
  FnOldBlockHeight := 10;

  FnCurrentBlockWidth := 60;
  FnCurrentBlockHeight := 60;


  ZoomChanged := true;
  setCanvas(oCanvas);
end;

destructor TCanvasDrawer.Destroy;
var
  image: TImage;
  i: integer;
begin
  for i := 0 to FoBlockImageCache.Count - 1 do
  begin
    image := TImage(FoBlockImageCache.Objects[i]);
    image.free;
  end;
  FoBlockImageCache.Free;


  inherited Destroy;
end;

procedure TCanvasDrawer.setCanvas(oCanvas: TCanvas);
begin
  Canvas := oCanvas;
  x := 1;
  y := 30;

  dl('Canvas assigned');
end;

end.


unit uLoggerOfDrawer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ComCtrls, ExtCtrls, uBlockColection,
  StdCtrls, uControlConfig, uAbstractDrawer;

type
    { TLoggerOfDrawer }

  TLoggerOfDrawer = class(TAbstractDrawer)
  public
    FoLogger: TMemo;

    procedure updateTargetImagePosition; override;

    function putNewBlock(imageTargetPlace1hand: TImage): TBlock; override;
    procedure pickBlock; override;
	procedure moveBlock(block: TBlock; const effect: string); override;

    procedure moveBlockToWithoutCursor(block: TBlock; const x, y, z: integer;
      const effect: string); override;


  end;

implementation

{ TLoggerOfDrawer }

procedure TLoggerOfDrawer.updateTargetImagePosition;
begin
  //FoLogger.Lines.Add('updateTargetImagePosition');
end;

function TLoggerOfDrawer.putNewBlock(imageTargetPlace1hand: TImage): TBlock;
begin
  FoLogger.Lines.Add(Format('putNewBlock at (%d,%d,%d)', [
    FoPrevDrawer.FnCurrentPlacePositionX, FoPrevDrawer.FnCurrentPlacePositionY,
    FoPrevDrawer.FnCurrentPlacePositionZ -1 ]));
end;

procedure TLoggerOfDrawer.pickBlock;
begin
  FoLogger.Lines.Add(Format('pickBlock at (%d,%d,%d)', [
    FoPrevDrawer.FnCurrentPlacePositionX, FoPrevDrawer.FnCurrentPlacePositionY,
    FoPrevDrawer.FnCurrentPlacePositionZ + 1 ]));
end;

procedure TLoggerOfDrawer.moveBlock(block: TBlock; const effect: string);
begin
  FoLogger.Lines.Add(Format('moveBlock %d at (%d,%d,%d) with effect %s', [
    block.FnImageIndex,
    FoPrevDrawer.FnCurrentPlacePositionX, FoPrevDrawer.FnCurrentPlacePositionY,
    FoPrevDrawer.FnCurrentPlacePositionZ, effect]));

end;

procedure TLoggerOfDrawer.moveBlockToWithoutCursor(block: TBlock; const x, y,
  z: integer; const effect: string);
begin
  FoLogger.Lines.Add(Format('moveBlockToWithoutCursor %d at (%d,%d,%d) with effect %s', [
    block.FnImageIndex,
    FoPrevDrawer.FnCurrentPlacePositionX, FoPrevDrawer.FnCurrentPlacePositionY,
    FoPrevDrawer.FnCurrentPlacePositionZ, effect]));
end;

end.



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

    procedure putNewBlock(imageTargetPlace1hand: TImage); override;
    procedure pickBlock; override;

  end;

implementation

{ TLoggerOfDrawer }

procedure TLoggerOfDrawer.updateTargetImagePosition;
begin
  //FoLogger.Lines.Add('updateTargetImagePosition');
end;

procedure TLoggerOfDrawer.putNewBlock(imageTargetPlace1hand: TImage);
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

end.



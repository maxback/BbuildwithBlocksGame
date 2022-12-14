program BuildWithBlocksGame;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, umain, uInventory, utypes, uAbstractDrawer, uControlConfig, 
  uBlockColection, uloggerofdrawer, uBlockMotionEngine, pascalscript
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmGame, frmGame);
  Application.Run;
end.


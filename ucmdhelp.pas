unit ucmdhelp;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmCmdHelp }

  TfrmCmdHelp = class(TForm)
    Memo1: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private

  public

  end;

var
  frmCmdHelp: TfrmCmdHelp;

implementation

{$R *.lfm}

{ TfrmCmdHelp }

procedure TfrmCmdHelp.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Visible:=false;
  CanClose:=false;
end;

end.


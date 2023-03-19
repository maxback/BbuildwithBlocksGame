unit uloadworls;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Buttons,
  dos, LCLType;

type

  { TfrmLoadWorld }

  TfrmLoadWorld = class(TForm)
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    lvWorlds: TListView;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvWorldsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private

  public
    FsName: string;
    class function Execute(var sName: string): boolean;
  end;

var
  frmLoadWorld: TfrmLoadWorld;

implementation

{$R *.lfm}

{ TfrmLoadWorld }

procedure TfrmLoadWorld.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then
  begin
    btnCancel.Click;
  end;

  if Key = VK_RETURN then
  begin
    btnOk.Click;
  end;

end;

procedure TfrmLoadWorld.lvWorldsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  FsName := '';
  if not Assigned(lvWorlds.Selected) then
    exit;

  FsName := lvWorlds.Selected.Caption;
end;

procedure TfrmLoadWorld.btnOkClick(Sender: TObject);
begin
end;

procedure TfrmLoadWorld.FormCreate(Sender: TObject);
var
  folder: string;
  SearchResult  : SearchRec;
  Attribute     : Word;
begin

  folder := ExtractFilePath(Application.ExeName) + '\data\users\default\worlds\';

  Attribute := archive;

  FindFirst (folder + '*.World.ini', Attribute, SearchResult);
  while (DosError = 0) do
  begin
    lvWorlds.AddItem(SearchResult.Name, nil);
    FindNext(SearchResult);
  end;
  FindClose(SearchResult);
end;

procedure TfrmLoadWorld.btnCancelClick(Sender: TObject);
begin
end;

class function TfrmLoadWorld.Execute(var sName: string): boolean;
begin
  Application.CreateForm(TfrmLoadWorld, frmLoadWorld);
  frmLoadWorld.ShowModal;
  Result := frmLoadWorld.ModalResult = mrOK;
  if result then
    sName := frmLoadWorld.FsName;

  frmLoadWorld.Free;
end;

end.


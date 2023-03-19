unit uInventory;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, utypes, LCLType;

type

  { TfrmInventory }

  TfrmInventory = class(TForm)
    btnBlock20: TSpeedButton;
    btnBlock29: TSpeedButton;
    btnBlock28: TSpeedButton;
    btnBlock27: TSpeedButton;
    btnBlock26: TSpeedButton;
    btnBlock25: TSpeedButton;
    btnBlock24: TSpeedButton;
    btnBlock23: TSpeedButton;
    btnBlock22: TSpeedButton;
    btnBlock21: TSpeedButton;
    btnBlock30: TSpeedButton;
    btnBlock31: TSpeedButton;
    btnBlock32: TSpeedButton;
    btnBlock33: TSpeedButton;
    btnBlock34: TSpeedButton;
    btnBlock35: TSpeedButton;
    btnBlock36: TSpeedButton;
    btnBlock37: TSpeedButton;
    btnBlock38: TSpeedButton;
    btnBlock39: TSpeedButton;
    btnBlock40: TSpeedButton;
    btnBlock41: TSpeedButton;
    btnBlock42: TSpeedButton;
    btnBlock43: TSpeedButton;
    btnBlock44: TSpeedButton;
    btnBlock45: TSpeedButton;
    btnBlock46: TSpeedButton;
    btnBlock47: TSpeedButton;
    btnBlock48: TSpeedButton;
    btnBlock49: TSpeedButton;
    imageSel: TSpeedButton;
    btnMenuBlock0: TSpeedButton;
    btnMenuBlock9: TSpeedButton;
    btnBlock0: TSpeedButton;
    btnBlock9: TSpeedButton;
    btnBlock8: TSpeedButton;
    btnBlock7: TSpeedButton;
    btnBlock6: TSpeedButton;
    btnBlock5: TSpeedButton;
    btnBlock4: TSpeedButton;
    btnBlock3: TSpeedButton;
    btnBlock2: TSpeedButton;
    btnBlock1: TSpeedButton;
    btnMenuBlock8: TSpeedButton;
    btnMenuBlock7: TSpeedButton;
    btnMenuBlock6: TSpeedButton;
    btnMenuBlock5: TSpeedButton;
    btnMenuBlock4: TSpeedButton;
    btnMenuBlock3: TSpeedButton;
    btnMenuBlock2: TSpeedButton;
    btnBlock10: TSpeedButton;
    btnBlock19: TSpeedButton;
    btnBlock18: TSpeedButton;
    btnBlock17: TSpeedButton;
    btnBlock16: TSpeedButton;
    btnBlock15: TSpeedButton;
    btnBlock14: TSpeedButton;
    btnBlock13: TSpeedButton;
    btnBlock12: TSpeedButton;
    btnBlock11: TSpeedButton;
    btnMenuBlock1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    panelTools1: TPanel;
    panelTools10: TPanel;
    panelTools100: TPanel;
    panelTools101: TPanel;
    panelTools102: TPanel;
    panelTools103: TPanel;
    panelTools104: TPanel;
    panelTools105: TPanel;
    panelTools106: TPanel;
    panelTools107: TPanel;
    panelTools108: TPanel;
    panelTools109: TPanel;
    panelTools11: TPanel;
    panelTools110: TPanel;
    panelTools111: TPanel;
    panelTools112: TPanel;
    panelTools113: TPanel;
    panelTools114: TPanel;
    panelTools115: TPanel;
    panelTools116: TPanel;
    panelTools117: TPanel;
    panelTools118: TPanel;
    panelTools119: TPanel;
    panelTools12: TPanel;
    panelTools120: TPanel;
    panelTools13: TPanel;
    panelTools14: TPanel;
    panelTools15: TPanel;
    panelTools16: TPanel;
    panelTools17: TPanel;
    panelTools18: TPanel;
    panelTools19: TPanel;
    panelTools2: TPanel;
    panelTools20: TPanel;
    panelTools3: TPanel;
    panelTools4: TPanel;
    panelTools5: TPanel;
    panelTools6: TPanel;
    panelTools7: TPanel;
    panelTools8: TPanel;
    panelTools81: TPanel;
    panelTools82: TPanel;
    panelTools83: TPanel;
    panelTools84: TPanel;
    panelTools85: TPanel;
    panelTools86: TPanel;
    panelTools87: TPanel;
    panelTools88: TPanel;
    panelTools89: TPanel;
    panelTools9: TPanel;
    panelTools90: TPanel;
    panelTools91: TPanel;
    panelTools92: TPanel;
    panelTools93: TPanel;
    panelTools94: TPanel;
    panelTools95: TPanel;
    panelTools96: TPanel;
    panelTools97: TPanel;
    panelTools98: TPanel;
    panelTools99: TPanel;
    PanelTop: TPanel;
    PanelTop1: TPanel;
    PanelTop10: TPanel;
    PanelTop11: TPanel;
    PanelTop8: TPanel;
    PanelTop9: TPanel;
    ScrollBox1: TScrollBox;
    shArrowPart1: TShape;
    shArrowPart2: TShape;
    shArrowPart3: TShape;
    TimerAniShowArrow: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScrollBox1Click(Sender: TObject);
    procedure SelectDestinationClick(Sender: TObject);
    procedure SelecteSourceBlockClick(Sender: TObject);
    procedure TimerAniShowArrowTimer(Sender: TObject);
  private
    FoMenuImageList: TImageList;
    FoInventoryImageList: TImageList;
    FoMenuButtonsList : TArrayOfSpeedButton;
    FoSelectedSpeedButton: TSpeedButton;
    procedure createImagesToSelect;

  public
    class procedure execute(menuImageList, inventoryImageList: TImageList;
  menuButtonsList: TArrayOfSpeedButton);
  end;

var
  frmInventory: TfrmInventory;

implementation

{$R *.lfm}

{ TfrmInventory }

procedure TfrmInventory.ScrollBox1Click(Sender: TObject);
begin

end;

procedure TfrmInventory.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then
    Close;

end;

procedure TfrmInventory.SelectDestinationClick(Sender: TObject);
var
  destButton: TSpeedButton;
  i: integer;
begin

  if not Assigned(FoSelectedSpeedButton) then
    exit;

  destButton := Sender as TSpeedButton;

  for i := 0 to High(FoMenuButtonsList) do
  begin
    if FoMenuButtonsList[i].ImageIndex = destButton.ImageIndex then
    begin
      caption := 'found index ' + IntToStr(destButton.ImageIndex);
      FoMenuButtonsList[i].ImageIndex := FoSelectedSpeedButton.ImageIndex;
      destButton.ImageIndex := FoSelectedSpeedButton.ImageIndex;
      caption := caption +
        ' and changes to index ' + IntToStr(FoSelectedSpeedButton.ImageIndex);

      imageSel.imageIndex := -1;

      break;
    end;
  end;

  TimerAniShowArrow.Enabled := false;

  shArrowPart1.Visible := false;
  shArrowPart2.Visible := false;
  shArrowPart3.Visible := false;
end;

procedure TfrmInventory.SelecteSourceBlockClick(Sender: TObject);
begin
  FoSelectedSpeedButton := Sender as TSpeedButton;
  imageSel.ImageIndex := FoSelectedSpeedButton.ImageIndex;
  TimerAniShowArrow.Enabled := true;
end;

procedure TfrmInventory.TimerAniShowArrowTimer(Sender: TObject);
begin
  if not shArrowPart1.Visible then
  begin
    shArrowPart1.Visible := true;
  end
  else if not shArrowPart2.Visible then
  begin
    shArrowPart2.Visible := true;
  end
  else if not shArrowPart3.Visible then
  begin
    shArrowPart3.Visible := true;
  end
  else
    TimerAniShowArrow.Enabled := false;

end;

procedure TfrmInventory.createImagesToSelect;
begin
  //
end;

class procedure TfrmInventory.execute(menuImageList, inventoryImageList: TImageList;
  menuButtonsList: TArrayOfSpeedButton);
var
  i: integer;
  s, d: string;
  found: boolean;
  button: TComponent;
  invCount: integer;
  menuCount: integer;

begin
  Application.CreateForm(TfrmInventory, frmInventory);

  frmInventory.imageSel.images := inventoryImageList;
  frmInventory.imageSel.imageIndex := -1;
  i := 0;
  invCount := 0;
  repeat
    s := 'btnBlock' + IntToStr(i);
    button := frmInventory.FindComponent(s);
    found := button <> nil;
    if found then
    begin
      with button as TSpeedButton do
      begin
        Images := inventoryImageList;
        ImageIndex := i;
        Inc(invCount);
      end;
    end;
    inc(i);
  until not found;

  i := 0;
  menuCount := 0;
  repeat
    s := 'btnMenuBlock' + IntToStr(i);
    button := frmInventory.FindComponent(s);
    found := button <> nil;
    if found then
    begin
      with button as TSpeedButton do
      begin
        Images := menuImageList;
        ImageIndex := i;
        Inc(menuCount);
      end;
    end;
    inc(i);
  until not found;

  frmInventory.Caption := 'There is ' + IntToStr(invCount)
    + ' blocks into the inventory to configure in ' + IntToStr(menuCount)
    + ' positions of menu.';

  frmInventory.FoMenuImageList := menuImageList;
  frmInventory.FoInventoryImageList := inventoryImageList;
  frmInventory.FoMenuButtonsList := menuButtonsList;

  //createImagesToSelect();

  frmInventory.ShowModal;
end;

end.


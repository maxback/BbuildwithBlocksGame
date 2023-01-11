unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Buttons, StdCtrls, IniFiles, LCLType, Menus, Dos, utypes, uBlockColection,
  uBlockMotionEngine, uControlConfig, uAbstractDrawer, uLoggerOfDrawer,
  uPSComponent;

const
  STATUSBAR_POSITION_INDEX = 0;
  STATUSBAR_ZOOM_INDEX = 1;
  STATUSBAR_SELECTED_BLOCK_INDEX = 2;
  STATUSBAR_MESSAGES_INDEX = 3;


type


  { TfrmGame }
  TMoveActionKind = (makMove, makMoveAfterInsert, makMoveAfterPick);

  TfrmGame = class(TForm)
    btnBlock9: TSpeedButton;
    btnBlock8: TSpeedButton;
    btnBlock7: TSpeedButton;
    btnBlock6: TSpeedButton;
    btnBlock5: TSpeedButton;
    btnBlock4: TSpeedButton;
    btnBlock3: TSpeedButton;
    btnBlock2: TSpeedButton;
    btnBlock1: TSpeedButton;
    btnInsert: TSpeedButton;
    btnBlock0: TSpeedButton;
    btnPick: TSpeedButton;
    btnSelectedBlock: TSpeedButton;
    edtCmd: TEdit;
    imageTargetPlace1Pick1: TImage;
    inventoryImageList: TImageList;
    imageTargetPlace1hand: TImage;
    ImageListBlocksMenu: TImageList;
    imageBackgroungPlace1: TImage;
    ImageList: TImageList;
    imageTargetPlace1Pick: TImage;
    ImageToLoad: TImage;
    lblShortCuts: TLabel;
    miSelectBlock9: TMenuItem;
    miSelectBlock8: TMenuItem;
    miSelectBlock7: TMenuItem;
    miSelectBlock6: TMenuItem;
    miSelectBlock5: TMenuItem;
    miSelectBlock4: TMenuItem;
    miSelectBlock3: TMenuItem;
    miSelectBlock2: TMenuItem;
    miSelectBlock1: TMenuItem;
    miSelectBlock0: TMenuItem;
    mmCmd: TMemo;
    MemoDataPlace1: TMemo;
    pnlSelectedBlock: TPanel;
    panelTools: TPanel;
    panelTools1: TPanel;
    panelTools10: TPanel;
    panelTools11: TPanel;
    panelTools2: TPanel;
    panelTools3: TPanel;
    panelTools4: TPanel;
    panelTools5: TPanel;
    panelTools6: TPanel;
    panelTools7: TPanel;
    panelTools8: TPanel;
    panelTools9: TPanel;
    PanelTop: TPanel;
    pgPlaces: TPageControl;
    pmSelectedBlock: TPopupMenu;
    PSScript1: TPSScript;
    StatusBar: TStatusBar;
    TabSheet1: TTabSheet;
    tbZoom: TTrackBar;
    Timer1: TTimer;
    TimerLimit: TTimer;
    procedure btnInsertClick(Sender: TObject);
    procedure btnPickClick(Sender: TObject);
    procedure btnSelectBlockClick(Sender: TObject);
    procedure btnSelectedBlockClick(Sender: TObject);
    procedure edtCmdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imageBackgroungPlace1Click(Sender: TObject);
    procedure imageBackgroungPlace1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblShortCutsClick(Sender: TObject);
    procedure mmCmdChange(Sender: TObject);
    procedure PSScript1Compile(Sender: TPSScript);
    procedure TabSheet1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbZoomChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerLimitTimer(Sender: TObject);
  private
    FoLastMoveKind: TMoveActionKind;
    FbBlocked: Boolean;

    FoDrawer: TAbstractDrawer;
    FoLoggerOfDrawer: TLoggerOfDrawer;

    FnTimeRemail: integer;
    FMenuButtonsList: TArrayOfSpeedButton;

    procedure goHome;
    procedure BlockMotionEngineMove(Sender: TMotionBlockControl; const x,y,z: integer);
    procedure BlockMotionEnginePut(Sender: TMotionBlockControl; const index: integer);
    procedure BlockMotionEngineLog(Sender: TMotionBlockControl; const msg: string);
    procedure BlockMotionEngineMoveBlock(Sender: TMotionBlockControl;
      const x,y,z: integer; const effect: String);


    procedure updateTargetImagePosition;
    procedure loadTexts;
    procedure loadPictures;
    procedure FormKeyDownPlace1(var Key: Word; Shift: TShiftState);
    procedure updateSelectedBlock(const index: integer; blocksImageList: TImageList);
    procedure initMotion(b: Tblock);
    procedure putNewBlock(const alowMotion: boolean);
    procedure pickBlock;
    procedure InitTimeLimit;
    procedure UpdateTimeLimit;
    procedure handleBlockSelection(key: Word);
    procedure addImageBlockToImageList(filepath: string; aList:TImageList);
    procedure callInventory;
    procedure BlockColectionVisitEventSalveToFile(sender: TObject; block: TBlock);
    procedure BlockColectionVisitEventLoadFromFile(sender: TObject; block: TBlock);
  protected
    function getMessage(const messageId, messageDefault: String): String;
    procedure handleNewZomm(const newZomm: integer);
    procedure statusMessage(const messageId, messageDefault: String);
    function handleNewCommand(const cmd : string) : string;
    procedure handleUpdate;
  public

  end;

var
  frmGame: TfrmGame;

implementation

{$R *.lfm}

uses
  uInventory;


{ TfrmGame }


procedure TfrmGame.loadTexts;
var
  inifile: TIniFile;
begin
  inifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\text\controls.ini');
  try
    btnInsert.hint := inifile.ReadString('buttons', 'btnInsert_hint', btnInsert.hint);
  finally
    inifile.Free;
  end;
end;


procedure TfrmGame.loadPictures;
var
  folder, blocksFolder: string;
  SearchResult  : SearchRec;
  Attribute     : Word;
  i: integer;
  mImage:   TPicture;
  mBitmap:  TBitmap;
begin

  folder := ExtractFilePath(Application.ExeName) + 'images\';

  setLength(FoDrawer.FBlockSourceFileNames, 0);

  blocksFolder := folder + 'blocks\';

  Attribute := archive;

  ImageListBlocksMenu.Clear;

  FindFirst (blocksFolder + '*.png', Attribute, SearchResult);
  while (DosError = 0) do
  begin
    SetLength(FoDrawer.FBlockSourceFileNames, Length(FoDrawer.FBlockSourceFileNames) + 1);
    i := High(FoDrawer.FBlockSourceFileNames);
    FoDrawer.FBlockSourceFileNames[i] := blocksFolder + SearchResult.Name;
    addImageBlockToImageList(FoDrawer.FBlockSourceFileNames[i], ImageListBlocksMenu);
    addImageBlockToImageList(FoDrawer.FBlockSourceFileNames[i], inventoryImageList);

    mmCmd.Lines.Add('log: block filie loaded: ' + FoDrawer.FBlockSourceFileNames[i] + ' in index ' + IntToStr(i));
    FindNext(SearchResult);
  end;
  FindClose(SearchResult);

  //ImageList.Clear;
  //ImageToLoad.Picture.LoadFromFile(folder + 'hand.png');
  //btnInsert.ImageIndex := ImageList.Add(ImageToLoad.Picture.Bitmap, nil);

  imageBackgroungPlace1.Picture.LoadFromFile(folder + 'bgp1.jpg');
  imageTargetPlace1Hand.Picture.LoadFromFile(folder + 'hand.png');
  imageTargetPlace1Pick.Picture.LoadFromFile(folder + 'pick.png');
end;




procedure TfrmGame.FormKeyDownPlace1(var Key: Word; Shift: TShiftState);
var
  direction: TDirection;
  CtrlPressed: boolean;
  initZ: integer;
begin
  initZ := FoDrawer.FnCurrentPlacePositionZ;

  CtrlPressed := ssCtrl in Shift;
  direction := FoDrawer.FControlPlace1.decodeDirectionByKey(true, Key);

  if direction = dirNone then
     exit;

  case direction of
    dirThirdPlanUp: begin
      if CtrlPressed then
      begin
        statusMessage('moveThirdPlanUp', 'Moving target to Third Plan Up (-)');
        FoDrawer.FnCurrentPlacePositionZ := FoDrawer.FnCurrentPlacePositionZ - 1;
      end
      else
      begin
        statusMessage('moveThirdPlanUp', 'Moving target to Third Plan Up (+)');
        FoDrawer.FnCurrentPlacePositionZ := FoDrawer.FnCurrentPlacePositionZ + 1;
      end;
    end;

    dirUp: begin
      statusMessage('moveUp', 'Moving target to Up');
      FoDrawer.FnCurrentPlacePositionY := FoDrawer.FnCurrentPlacePositionY + 1;
    end;
    dirDown: begin
      if FoDrawer.FnCurrentPlacePositionY <= 0 then
        exit;
      statusMessage('moveDown', 'Moving target to Down');
      FoDrawer.FnCurrentPlacePositionY := FoDrawer.FnCurrentPlacePositionY - 1;
    end;
    dirLeft: begin
      if FoDrawer.FnCurrentPlacePositionX <= 0 then
        exit;
      statusMessage('moveLeft', 'Moving target to Left');
      FoDrawer.FnCurrentPlacePositionX := FoDrawer.FnCurrentPlacePositionX - 1;
      //FoCurrentPlaceImageTarget.Left := FoCurrentPlaceImageTarget.Left
      //  - FoCurrentPlaceImageTarget.Width;
    end;
    dirRight: begin
      statusMessage('moveRight', 'Moving target to Right');
      FoDrawer.FnCurrentPlacePositionX := FoDrawer.FnCurrentPlacePositionX + 1;
      //FoCurrentPlaceImageTarget.Left := FoCurrentPlaceImageTarget.Left
      //  + FoCurrentPlaceImageTarget.Width;
    end;
  end;

  if FoDrawer.FnCurrentPlacePositionZ < 0 then
  begin
    statusMessage('moveThirdPlanUp', 'Moving target to Third Plan Up in z = 0');
    FoDrawer.FnCurrentPlacePositionZ := 0;
  end;

  if direction <> dirThirdPlanUp then
  begin
    if CtrlPressed then
    begin

      if FoDrawer.FoMode = modePut then
        if FoLastMoveKind = makMoveAfterInsert then
          FoDrawer.FnCurrentPlacePositionZ := initZ - 1
        else
          FoDrawer.FnCurrentPlacePositionZ := initZ


    end
    else
    begin

      if FoDrawer.FoMode = modePut then
        FoDrawer.FnCurrentPlacePositionZ := FoDrawer.FoCurrentPlaceBlockCollection.findMaxZ(
          FoDrawer.FnCurrentPlacePositionX, FoDrawer.FnCurrentPlacePositionY, -1).FnZ + 1
      else
        FoDrawer.FnCurrentPlacePositionZ := FoDrawer.FoCurrentPlaceBlockCollection.findMaxZ(
          FoDrawer.FnCurrentPlacePositionX, FoDrawer.FnCurrentPlacePositionY, 0).FnZ;

    end;

  end;

  FoLastMoveKind := makMove;
  updateTargetImagePosition;


end;

procedure TfrmGame.updateSelectedBlock(const index: integer;
  blocksImageList: TImageList);
begin
  btnSelectedBlock.ImageIndex := index;

  FoDrawer.FnSelectedBlockIndex := index;
  FoDrawer.FoBlockImages := blocksImageList;
  StatusBar.Panels.Items[STATUSBAR_SELECTED_BLOCK_INDEX].Text :=
    'Selected block: ' + IntToStr(index);
end;

procedure TfrmGame.initMotion(b: Tblock);
var
  s: string;
begin
  try
    s := b.FsFileName + '.pas';
    if FileExists(s) then
    begin
      TBlockMotionEngine.insert(b, s, @BlockMotionEngineMove, @BlockMotionEnginePut,
        @BlockMotionEngineMoveBlock);
    end;
  except
    on e:Exception do
      mmCmd.Lines.Add('log: Error inserting motion block: ' + E.message);
  end;
end;

procedure TfrmGame.putNewBlock(const alowMotion: boolean);
var
  b: Tblock;
  index: integer;
begin

  if FbBlocked then
  begin
    ShowMessage('You have no time!!!!! Only basic commands are avilable!');
    exit;
  end;

  index := FoDrawer.FnSelectedBlockIndex;
  try
    b := FoDrawer.putNewBlock(imageTargetPlace1hand);

    FoLastMoveKind := makMoveAfterInsert;
    updateTargetImagePosition;

    if alowMotion then
      initMotion(b);
  finally
    updateSelectedBlock(index,
      ImageListBlocksMenu as TImageList);
  end;

end;

procedure TfrmGame.pickBlock;
begin
  if FbBlocked then
  begin
    ShowMessage('You have no time!!!!! Only basic commands are avilable!');
    exit;
  end;

 FoDrawer.pickBlock;
 FoLastMoveKind := makMoveAfterPick;
 updateTargetImagePosition;


end;

procedure TfrmGame.updateTargetImagePosition;
begin

 FoDrawer.updateTargetImagePosition;

  StatusBar.Panels.Items[STATUSBAR_POSITION_INDEX].Text :=
    Format('(x: %d, y: %d, z: %d)(Left: %d, Top: %d)',
      [FoDrawer.FnCurrentPlacePositionX, FoDrawer.FnCurrentPlacePositionY,
      FoDrawer.FnCurrentPlacePositionZ, FoDrawer.FoCurrentPlaceImageTarget.Left,
      FoDrawer.FoCurrentPlaceImageTarget.Top]);
end;

procedure TfrmGame.InitTimeLimit;
var
  oIni: TIniFile;
  limit: String;
begin
  oIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'data\TimeLimit.ini');
  try
    limit := oIni.ReadString('TotalByDate', DateToStr(Date), '');

    if (limit <> '') or
      InputQuery('Time limit', 'please enter the time limit (in minutes) for the game',
      limit) then
    begin
      FnTimeRemail := StrToInt(limit) * 60;
    end
    else
    begin
      FnTimeRemail := 60 * 60; //60 minutoes by default (fix this lather)
    end;
    TimerLimit.Interval := 1000;
    TimerLimit.Enabled := true;
  finally
    oIni.Free;
  end;
  UpdateTimeLimit;
end;

procedure TfrmGame.UpdateTimeLimit;
var
  oIni: TIniFile;
  limit, path: String;
begin
  path := ExtractFilePath(Application.ExeName) + 'data\TimeLimit.ini';
  oIni := TIniFile.Create(path);
  try
    limit := IntToStr(FnTimeRemail div 60);
    oIni.WriteString('TotalByDate', DateToStr(Date), limit);
  finally
    oIni.Free;
  end;
end;

procedure TfrmGame.handleBlockSelection(key: Word);
var
  componentName: string;
  oComponent: TComponent;
  charKey: char;
begin
  charKey := #0;
  case key of
    VK_0: charKey := '0';
    VK_1: charKey := '1';
    VK_2: charKey := '2';
    VK_3: charKey := '3';
    VK_4: charKey := '4';
    VK_5: charKey := '5';
    VK_6: charKey := '6';
    VK_7: charKey := '7';
    VK_8: charKey := '8';
    VK_9: charKey := '9';
  else
    exit;
  end;
  componentName := 'btnBlock' + charKey;
  oComponent := FindComponent(componentName);
  if oComponent <> nil then
    btnSelectBlockClick(oComponent);
    //(oComponent as TSpeedButton).Click;
end;

procedure TfrmGame.addImageBlockToImageList(filepath: string;
  aList:TImageList);
var
  mImage:   TPicture;
  mBitmap:  TBitmap;
Begin
  if aList<>NIl then
  begin
    if FileExists(filepath,true) then
    begin
      mImage:=TPicture.Create;
      try

        (* Attempt to load image file *)
        try
          mImage.LoadFromFile(filepath);
        except
          on exception do;
        end;

        (* image successfully loaded? *)
        if (mImage.Width>0)
        and (mImage.Height>0) then
        begin
          (* Draw image to a bitmap *)
          mBitmap:=TBitmap.Create;
          try
            (* copy pixels + transparency info to bitmap *)
            mBitmap.Assign(mImage.Graphic);
            aList.add(mBitmap,NIL);
          finally
            mBitmap.Free;
          end;
        end;
      finally
        mImage.Free;
      end;
    end;
  end;
end;

procedure TfrmGame.callInventory;
begin

  TfrmInventory.execute(ImageListBlocksMenu, inventoryImageList,
    FMenuButtonsList);
end;

procedure TfrmGame.BlockColectionVisitEventSalveToFile(sender: TObject;
  block: TBlock);
begin
  //
end;

procedure TfrmGame.BlockColectionVisitEventLoadFromFile(sender: TObject;
  block: TBlock);
begin
  //
end;


function TfrmGame.getMessage(const messageId, messageDefault: String): String;
begin
  //get from cache or inifile or default
  Result := messageDefault;
end;

procedure TfrmGame.handleNewZomm(const newZomm: integer);
begin
  //
end;

procedure TfrmGame.statusMessage(const messageId, messageDefault: String);
begin
  StatusBar.Panels.Items[STATUSBAR_MESSAGES_INDEX].Text := getMessage(
    messageId, messageDefault);
end;

function TfrmGame.handleNewCommand(const cmd : string) : string;
var
  output: string;
begin
  output := cmd;
  if cmd = 'textmode' then
  begin
    MemoDataPlace1.visible := true;
    MemoDataPlace1.left := 10;
    MemoDataPlace1.Width := Width - 22;
    MemoDataPlace1.top := 10;

  end
  else if cmd = 'exittextmode' then
    MemoDataPlace1.visible := false
  else if cmd = 'update' then
    handleUpdate
  else if cmd = 'help' then
  begin
    output := output + ': textmode, exittextmode, update';
  end;


  result := output;

end;

procedure TfrmGame.handleUpdate;
begin
  //desenha com base apenas na entrada de texto
end;


procedure TfrmGame.FormCreate(Sender: TObject);
var
  i: integer;
begin
  FoDrawer := TAbstractDrawer.Create;
  FoLoggerOfDrawer := TLoggerOfDrawer.Create;
  FoLoggerOfDrawer.FoLogger := mmCmd;
  FoDrawer.setNextDrawer(FoLoggerOfDrawer);

  TBlockMotionEngine.setEventLog(@BlockMotionEngineLog);

  with FoDrawer do
  begin
    FoCurrentPlaceBlockCollection := TBlockColection.create;
    SetLength(FMenuButtonsList, 10);
    for i := 0 to 9 do
      FMenuButtonsList[i] := TSpeedButton(FindComponent('btnBlock' + IntToStr(i)));

    TBlockMotionEngine.setCurrentPlaceBlockCollection(FoCurrentPlaceBlockCollection);

    FnSelectedBlockIndex := -1;
    FoCurrentPlaceTabSeet := pgPlaces.ActivePage;
    FoCurrentPlaceImageBackgroung := imageBackgroungPlace1;
    FoCurrentPlaceImageTarget := imageTargetPlace1hand;
    FControlPlace1 := TControlConfig.Create;
    FnCurrentPlacePositionX := 0;
    FnCurrentPlacePositionY := 0;
    FnCurrentPlacePositionZ := 0;
    FnCurrentPlacePositionXMax := 0;
    FnCurrentPlacePositionYMax := 0;

    FnCurrentPlacePositionXMax := FoCurrentPlaceTabSeet.Width div 40;

    FnCurrentPlacePositionYMax := FoCurrentPlaceTabSeet.Height div 40;

    FnCurrentPlaceOffsetX := 0; //FoCurrentPlaceTabSeet.Width -
  //    (FnCurrentPlacePositionXMax * 40);

    FnCurrentPlaceOffsetY := 0; //FoCurrentPlaceTabSeet.Height -
  //    (FnCurrentPlacePositionYMax * 40);

    FnCurrentPlacePositionXMax := FnCurrentPlacePositionXMax - 1;
    FnCurrentPlacePositionYMax := FnCurrentPlacePositionYMax - 1;

    FoMode := modePut;
    loadTexts;
    loadPictures;

    btnInsertClick(self);
    btnSelectBlockClick(btnBlock0);
    goHome;

  end;
end;

procedure TfrmGame.FormDestroy(Sender: TObject);
begin
  FoDrawer.setNextDrawer(nil);
  FoLoggerOfDrawer.Free;
  FoDrawer.FoCurrentPlaceBlockCollection.Free;
  FoDrawer.FControlPlace1.Free;
  FoDrawer.Free;
end;

procedure TfrmGame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FormKeyDownPlace1(Key, Shift);

  //enter
  if (key = VK_RETURN) or (key = VK_SPACE) then
  begin
    case FoDrawer.FoMode of
      modePut: putNewBlock(true);
      modePick: pickBlock;
    end;
  end
  //home
  else if (key = VK_HOME) then
  begin
    goHome;
  end
  else if key = VK_H then
  begin
    btnInsert.Click;
  end
  else if key = VK_P then
  begin
    btnPick.Click;
  end
  else if key = VK_I then
  begin
    callInventory;
  end
  else if key = 190 {VK_POINT} then
  begin
    btnSelectedBlockClick(self);
  end
  else
    handleBlockSelection(key);


end;

procedure TfrmGame.imageBackgroungPlace1Click(Sender: TObject);
begin

end;

procedure TfrmGame.imageBackgroungPlace1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  putNewBlock(true);
end;

procedure TfrmGame.lblShortCutsClick(Sender: TObject);
begin

end;

procedure TfrmGame.mmCmdChange(Sender: TObject);
begin
  if mmCmd.Lines.Count = 0 then
    exit;

  StatusBar.Panels.Items[STATUSBAR_MESSAGES_INDEX].Text :=
    mmCmd.Lines.Strings[mmCmd.Lines.Count - 1];
end;

procedure TfrmGame.PSScript1Compile(Sender: TPSScript);
begin

end;

procedure TfrmGame.TabSheet1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  putNewBlock(true);
end;

procedure TfrmGame.btnInsertClick(Sender: TObject);
begin
  statusMessage('btnInsertClick', 'Block insert mode select');
  FoDrawer.FoMode := modePut;
  imageTargetPlace1Hand.Transparent := false;
  imageTargetPlace1Hand.Top := FoDrawer.FoCurrentPlaceImageTarget.Top;
  imageTargetPlace1Hand.Left := FoDrawer.FoCurrentPlaceImageTarget.Left;
  imageTargetPlace1Hand.Visible := true;
  imageTargetPlace1Hand.BringToFront;
  imageTargetPlace1Hand.Transparent := true;
  imageTargetPlace1Pick.Visible := false;
  FoDrawer.FoCurrentPlaceImageTarget := imageTargetPlace1Hand;

end;

procedure TfrmGame.btnPickClick(Sender: TObject);
begin
  statusMessage('btnPickClick', 'Block pick mode select');
  FoDrawer.FoMode := modePick;
  imageTargetPlace1Pick.Transparent := false;
  imageTargetPlace1Pick.Top := FoDrawer.FoCurrentPlaceImageTarget.Top;
  imageTargetPlace1Pick.Left := FoDrawer.FoCurrentPlaceImageTarget.Left;
  imageTargetPlace1Pick.Visible := true;
  imageTargetPlace1Pick.BringToFront;
  imageTargetPlace1Pick.Transparent := true;
  imageTargetPlace1Hand.Visible := false;
  FoDrawer.FoCurrentPlaceImageTarget := imageTargetPlace1Pick;

end;

procedure TfrmGame.btnSelectBlockClick(Sender: TObject);
var
  index: integer;
  il: TImageList;
begin
  if Sender is TSpeedButton then
  begin
    if (Sender as TSpeedButton).images = nil then
      exit;
    index := (Sender as TSpeedButton).imageIndex;
    il := (Sender as TSpeedButton).images as TImageList;
    (Sender as TSpeedButton).Down := true;
  end
  else if Sender is TMenuItem then
  begin
    index := (Sender as TMenuItem).imageIndex;
    il := ImageListBlocksMenu;
  end
  else
    exit;

  updateSelectedBlock(index, il);
end;

procedure TfrmGame.btnSelectedBlockClick(Sender: TObject);
begin
  pmSelectedBlock.PopUp;
end;

procedure TfrmGame.edtCmdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = ord('c') then
  begin
    mmCmd.lines.add(handleNewCommand(edtCmd.text));
    edtCmd.Clear;
  end;
  mmCmd.SelStart := Length(mmCmd.Text);
end;

procedure TfrmGame.tbZoomChange(Sender: TObject);
begin
  StatusBar.Panels.Items[STATUSBAR_ZOOM_INDEX].Text := tbZoom.Position.ToString + '%';
  handleNewZomm(tbZoom.Position);
end;

procedure TfrmGame.Timer1Timer(Sender: TObject);
var
  limit: string;
begin
  Timer1.Enabled := false;
  ShowMessage('Welcome to build blocks game!'+#13#10+
    'Use the arrow key to move and Enter to put blocks');
  updateTargetImagePosition;
  InitTimeLimit;
end;

procedure TfrmGame.TimerLimitTimer(Sender: TObject);
begin
  if FnTimeRemail > 0 then
  begin
    FnTimeRemail := FnTimeRemail - 1;
    Caption := Format('Time remain: %d seconds !!!!!!!!!!!!!!!!!!!!!!!!!', [FnTimeRemail]);
    if FnTimeRemail = 0 then
    begin
      UpdateTimeLimit;
      TimerLimit.Enabled := false;
      ShowMessage('You have no time!!!!!');
      FbBlocked := true;
    end
    else if (FnTimeRemail mod 30) = 0 then
      UpdateTimeLimit;
  end;
end;

procedure TfrmGame.goHome;
begin
  FoDrawer.FnCurrentPlacePositionX := 0;
  FoDrawer.FnCurrentPlacePositionY := 0;
  FoDrawer.FnCurrentPlacePositionZ := 0;
  updateTargetImagePosition;
  FoLastMoveKind := makMove;
end;

procedure TfrmGame.BlockMotionEngineMove(Sender: TMotionBlockControl; const x,
  y, z: integer);
begin
  FoDrawer.FnCurrentPlacePositionX := x;
  FoDrawer.FnCurrentPlacePositionY := y;
  FoDrawer.FnCurrentPlacePositionZ := z;
  updateTargetImagePosition;
  FoLastMoveKind := makMove;
end;

procedure TfrmGame.BlockMotionEnginePut(Sender: TMotionBlockControl;
  const index: integer);
begin
  try
    case index of
      -1: pickBlock;
      else
      begin
        updateSelectedBlock(index,
          ImageListBlocksMenu);

        putNewBlock(false);
      end;
    end;

  except
    //
  end;
end;

procedure TfrmGame.BlockMotionEngineLog(Sender: TMotionBlockControl;
  const msg: string);
begin
  mmCmd.Lines.Add('log: from motion block ID ' + IntToStr(Sender.FnId)
    + ' => ' + msg);
end;

procedure TfrmGame.BlockMotionEngineMoveBlock(Sender: TMotionBlockControl;
  const x, y, z: integer; const effect: String);
begin
  FoDrawer.FnCurrentPlacePositionX := x;
  FoDrawer.FnCurrentPlacePositionY := y;
  FoDrawer.FnCurrentPlacePositionZ := Z;

  updateTargetImagePosition;

  FoDrawer.moveBlock(Sender.FoBlock, effect);
end;

end.


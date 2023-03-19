unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Buttons, StdCtrls, IniFiles, LCLType, Menus, Dos, utypes, uBlockColection,
  uBlockMotionEngine, uControlConfig, uAbstractDrawer, uLoggerOfDrawer,
  uPSComponent, ucmdhelp;

const
  STATUSBAR_POSITION_INDEX = 0;
  STATUSBAR_ZOOM_INDEX = 1;
  STATUSBAR_SELECTED_BLOCK_INDEX = 2;
  STATUSBAR_MESSAGES_INDEX = 3;

  C_SUBFOLDER_WORLDS = '\data\users\default\worlds\';
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
    lblOptions: TLabel;
    lblShortCuts: TLabel;
    miLoadWorldAtCursor: TMenuItem;
    Separator1: TMenuItem;
    miClearAll: TMenuItem;
    miLoadWorld: TMenuItem;
    miSaveWorld: TMenuItem;
    miMoveByMouse: TMenuItem;
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
    pmOptions: TPopupMenu;
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
    procedure imageBackgroungPlace1MouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblOptionsClick(Sender: TObject);
    procedure lblShortCutsClick(Sender: TObject);
    procedure miClearAllClick(Sender: TObject);
    procedure miLoadWorldAtCursorClick(Sender: TObject);
    procedure miLoadWorldClick(Sender: TObject);
    procedure miMoveByMouseClick(Sender: TObject);
    procedure miSaveWorldClick(Sender: TObject);
    procedure mmCmdChange(Sender: TObject);
    procedure PSScript1Compile(Sender: TPSScript);
    procedure TabSheet1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbZoomChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerLimitTimer(Sender: TObject);
  private
    MouseNav: record
      LastX, LastY: Integer;
    end;
    FoLastMoveKind: TMoveActionKind;
    FbBlocked: Boolean;

    FoDrawer: TAbstractDrawer;
    FoLoggerOfDrawer: TLoggerOfDrawer;

    FnTimeRemail: integer;
    FMenuButtonsList: TArrayOfSpeedButton;

    FoCurrentLoadingFile: TIniFile;
    FoCurrentSavingFile: TIniFile;
    FoCurrentBlockNameDictionary: TStringList;
    FoCurrentSavingObjectCount: integer;

    procedure goHome;
    procedure loadWorldAtCursor(const xini, yini, zini: integer);
    procedure goToPosition(const x, y, z: integer);
    procedure BlockMotionEngineMove(Sender: TMotionBlockControl; const x,y,z: integer);
    procedure BlockMotionEnginePut(Sender: TMotionBlockControl; const index: integer);
    procedure BlockMotionEngineLog(Sender: TMotionBlockControl; const msg: string);
    procedure BlockMotionEngineMoveBlock(Sender: TMotionBlockControl;
      const x,y,z: integer; const effect: String);
    procedure BlockMotionEngineMoveBlockWithOutCursor(Sender: TMotionBlockControl;
      const x,y,z: integer; const effect: String);


    procedure updateTargetImagePosition;
    procedure loadTexts;
    procedure loadPictures;
    function addPicture(const sFileName: string; testDuplication: boolean): integer;
    procedure FormKeyDownPlace1(var Key: Word; Shift: TShiftState);
    procedure FormDirectionPlace1(direction: TDirection; Shift: TShiftState);
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
    procedure BlockColectionVisitDeleteAll(sender: TObject; block: TBlock);
    function CalculateFullFileNameToSavedWorls(const sName: string): string;

    procedure ExecCmd(const cmd: string);
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
  uInventory, uLoadWorls;


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

function TfrmGame.addPicture(const sFileName: string; testDuplication: boolean): integer;
var
  i: integer;
begin
  if testDuplication then
  begin
    for i := Low(FoDrawer.FBlockSourceFileNames) to High(FoDrawer.FBlockSourceFileNames) do
    begin
      if FoDrawer.FBlockSourceFileNames[i] = sFileName then
        exit(i);
    end;
  end;
  SetLength(FoDrawer.FBlockSourceFileNames, Length(FoDrawer.FBlockSourceFileNames) + 1);
  i := High(FoDrawer.FBlockSourceFileNames);
  FoDrawer.FBlockSourceFileNames[i] := sFileName;
  addImageBlockToImageList(FoDrawer.FBlockSourceFileNames[i], ImageListBlocksMenu);
  addImageBlockToImageList(FoDrawer.FBlockSourceFileNames[i], inventoryImageList);

  mmCmd.Lines.Add('log: block filie loaded: ' + FoDrawer.FBlockSourceFileNames[i] + ' in index ' + IntToStr(i));

  exit(i);
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
    addPicture(blocksFolder + SearchResult.Name, false);
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
  initZ: integer;
begin
  direction := FoDrawer.FControlPlace1.decodeDirectionByKey(true, Key);

  FormDirectionPlace1(direction, Shift);
end;



procedure TfrmGame.FormDirectionPlace1(direction: TDirection; Shift: TShiftState);
var
  CtrlPressed: boolean;
  initZ: integer;
begin
  initZ := FoDrawer.FnCurrentPlacePositionZ;

  CtrlPressed := ssCtrl in Shift;

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
  events: TMotionBlockControlEventsParam;

begin
  try
    s := b.FsFileName + '.pas';
    if FileExists(s) then
    begin

      events.oEventMove := @BlockMotionEngineMove;
      events.oEventPut := @BlockMotionEnginePut;
      events.oEventMoveBlock := @BlockMotionEngineMoveBlock;
      events.oEventMoveBlockWithOutCursor := @BlockMotionEngineMoveBlockWithOutCursor;


      TBlockMotionEngine.insertWithThread(b, s, events);
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

  MouseNav.LastX := -1;
  MouseNav.LastY := -1;

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
var
  cmd: string;
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
  else if key = VK_C then
  begin
    if InputQuery('Command', 'Type a comand ou h por help', cmd) then
      ExecCmd(cmd);

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
  else if key = 79 {'o'} then
  begin
    lblOptionsClick(self);
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

procedure TfrmGame.imageBackgroungPlace1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  dX, dY: integer;
  dirX, dirY: TDirection;
begin
  //to move the position
  if not miMoveByMouse.Checked then
    exit;

  //compare with last mouse position to indicate the direction

  if (MouseNav.LastX >= 0) and (MouseNav.LastY >= 0) then
  begin
    dX := X - MouseNav.LastX;
    dY := Y - MouseNav.LastY;

    dirX := dirRight;
    if dX < 0 then
      dirX := dirLeft;

    dirY := dirDown;
    if dY < 0 then
      dirY := dirUp;

    dX := Abs(dX div FoDrawer.FoCurrentPlaceImageTarget.Width);
    dY := Abs(dY div FoDrawer.FoCurrentPlaceImageTarget.Width);

    while dX > 0 do
    begin
      MouseNav.LastX := X;
      FormDirectionPlace1(dirX, Shift);
      Dec(dX);
    end;

    while dY > 0 do
    begin
      MouseNav.LastY := Y;
      FormDirectionPlace1(dirY, Shift);
      Dec(dY);
    end;
  end
  else
  begin
    MouseNav.LastX := X;
    MouseNav.LastY := Y;
  end;

end;

procedure TfrmGame.lblOptionsClick(Sender: TObject);
begin
  pmOptions.PopUp;
end;

procedure TfrmGame.lblShortCutsClick(Sender: TObject);
begin

end;

procedure TfrmGame.miClearAllClick(Sender: TObject);
begin
  FoDrawer.FoCurrentPlaceBlockCollection.deleteAll(@BlockColectionVisitDeleteAll);
end;

procedure TfrmGame.miLoadWorldAtCursorClick(Sender: TObject);
begin
  loadWorldAtCursor(FoDrawer.FnCurrentPlacePositionX,
    FoDrawer.FnCurrentPlacePositionY,
    FoDrawer.FnCurrentPlacePositionZ);
end;

procedure TfrmGame.miLoadWorldClick(Sender: TObject);
begin
  loadWorldAtCursor(0, 0, 0);
end;

procedure TfrmGame.miMoveByMouseClick(Sender: TObject);
begin
  miMoveByMouse.Checked := not miMoveByMouse.Checked;
  if miMoveByMouse.Checked then
  begin
    MouseNav.LastX := -1;
    MouseNav.LastY := -1;
  end;
end;


procedure TfrmGame.BlockColectionVisitEventSalveToFile(sender: TObject;
  block: TBlock);
var
  blockImageIndex: integer;

begin
  blockImageIndex := FoCurrentBlockNameDictionary.IndexOf(block.FsFileName);
  if blockImageIndex < 0 then
  begin
    blockImageIndex := FoCurrentBlockNameDictionary.Add(block.FsFileName);
    FoCurrentSavingFile.WriteString('block', IntToStr(blockImageIndex), block.FsFileName);
    FoCurrentSavingFile.WriteInteger('count', 'block', FoCurrentBlockNameDictionary.Count);
  end;

  FoCurrentSavingFile.WriteString('object', IntToStr(FoCurrentSavingObjectCount),
    Format('v0,%d,%d,%d,%d', [block.FnX, block.FnY, block.FnZ, blockImageIndex]));

  FoCurrentSavingObjectCount := FoCurrentSavingObjectCount + 1;
end;

procedure TfrmGame.BlockColectionVisitDeleteAll(sender: TObject;
  block: TBlock);
begin
  goToPosition(block.FnX, block.FnY, block.FnZ);
  pickBlock;
  block.Free;
end;

 function TfrmGame.CalculateFullFileNameToSavedWorls(const sName: string): string;
begin
  Result := ExtractFilePath(Application.ExeName) + C_SUBFOLDER_WORLDS
    + sName + '.World.ini';
end;


 procedure TfrmGame.ExecCmd(const cmd: string);
 var
   c: string;
   sl: TStringList;
   val, dir, x, y, z, i, col, row: integer;

   procedure posxy(px, py: integer);
   begin
     FoDrawer.FnCurrentPlacePositionX := px;
     FoDrawer.FnCurrentPlacePositionY := py;
     FoDrawer.FnCurrentPlacePositionZ := z;

     updateTargetImagePosition;
     FoLastMoveKind := makMove;

   end;

   procedure cmdc(lenght: integer);
   begin
     dir := 1;
     val := lenght;
     if val < 0 then
     begin
       dir := -1;
       val := val * -1;
     end;

     i := 0;
     while ((dir = 1) and (i < val)) or ((dir = -1) and (i > (val * -1))) do
     begin
       posxy(x, y + i);
       try
       //initMotion(
       FoDrawer.putNewBlock(imageTargetPlace1hand);
       //);


       except
         on e: exception do
           mmCmd.Lines.Add('Error executing command: ' + e.message);
       end;
       i := i + dir;
     end;
     posxy(x, y + i);

   end;

   procedure cmdr(lenght: integer);
   begin
     dir := 1;
     val := lenght;
     if val < 0 then
     begin
       dir := -1;
       val := val * -1;
     end;

     i := 0;
     while ((dir = 1) and (i < val)) or ((dir = -1) and (i > (val * -1))) do
     begin
       posxy(x + i, y);
       try
       //initMotion(
       FoDrawer.putNewBlock(imageTargetPlace1hand);
       //);
       except
         on e: exception do
           mmCmd.Lines.Add('Error executing command: ' + e.message);
       end;
       i := i + dir;
     end;
     posxy(x + i, y);

   end;


 begin
   if cmd = 'h' then
   begin
     frmCmdHelp.Visible := true;
     frmCmdHelp.Show;
     if not InputQuery('Comamnd', 'enter a new command', c) then
       exit;
   end
   else
     c := cmd;

   sl := TStringList.Create;
   sl.Delimiter := ' ';
   try
      while true do
      begin
        sl.DelimitedText := c;

        x := FoDrawer.FnCurrentPlacePositionX;
        y := FoDrawer.FnCurrentPlacePositionY;
        z := FoDrawer.FnCurrentPlacePositionZ;

        if sl[0] = 'r' then
        begin
          cmdr(StrToIntDef(sl[1], 0));
        end


        else if sl[0] = 'c' then
        begin
          cmdc(StrToIntDef(sl[1], 0));
        end
        else if (sl[0] = 'rec') and (sl.Count > 3) and (sl[3] = 'fill') then
        begin
          for col := 0 to StrToIntDef(sl[1], 0) - 1 do //columns
          begin
            try
              for row := 0 to StrToIntDef(sl[2], 0) - 1 do //rows
              begin
                posxy(x + col, y + row);
                try
                  //initMotion(
                  FoDrawer.putNewBlock(imageTargetPlace1hand);
                  //);
                except
                  on e: exception do
                    mmCmd.Lines.Add('Error executing command: ' + e.message);
                end;

              end;
            except
              on e: exception do
                mmCmd.Lines.Add('Error executing command: ' + e.message);
            end;

            posxy(x + col + 1, y);
          end;
        end
        else if (sl[0] = 'rec') and (sl.Count < 4) then
        begin
          col := StrToIntDef(sl[1], 0); //columns
          row := StrToIntDef(sl[2], 0); //rows

          cmdr(col);

          posxy(x + col - 1, y + 1);
          x := x + col - 1;
          y := y + 1;

          cmdc(row - 1);

          posxy(x - 1, y + row - 2);
          x := x - 1;
          y := y + row - 2;

          cmdr((col - 1) * -1);

          posxy(x - col + 2, y - 1);
          x := x - col + 2;
          y := y - 1;

          cmdc((row - 2) * -1);

          posxy(x + col, y - row + 2);

        end
        else
          ShowMessage('Invalid Command.');

        if not InputQuery('Comamnd', 'enter a new command', c) then
          exit;
      end;
   finally
     sl.Free;
   end;

 end;


procedure TfrmGame.miSaveWorldClick(Sender: TObject);
var
  sName: String;
begin
  if not inputQuery('Save world', 'Enter the world name:', sName) then
    exit;
  FoCurrentSavingObjectCount := 0;
  FoCurrentSavingFile := TIniFile.Create(CalculateFullFileNameToSavedWorls(sName));
  FoCurrentBlockNameDictionary := TStringList.Create;
  try
    FoDrawer.FoCurrentPlaceBlockCollection.visitAll(@BlockColectionVisitEventSalveToFile);
    FoCurrentSavingFile.WriteInteger('count', 'object', FoCurrentSavingObjectCount);

  finally
    FoCurrentBlockNameDictionary.Free;
    FoCurrentSavingFile.Free;
  end;


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
  goToPosition(0, 0, 0);
end;

procedure TfrmGame.loadWorldAtCursor(const xini, yini, zini: integer);
var
  sName, sImageName, sObject: string;
  i, x, y, z, index, imageIndex, blockCount, objectCount: integer;
  sl: TStringList;
begin
  if not TfrmLoadWorld.Execute(sName) then
    exit;

  sName := ExtractFilePath(Application.ExeName) + C_SUBFOLDER_WORLDS + sName;

  if not FileExists(sName) then
    raise Exception.CreateFmt('File not exists: %s', [sName]);

  FoCurrentLoadingFile := TIniFile.Create(sName);
  FoCurrentBlockNameDictionary := TStringList.Create;
  sl := TStringList.Create;
  mmCmd.Lines.BeginUpdate;
  try
    blockCount :=
      FoCurrentLoadingFile.ReadInteger('count', 'block',
        FoCurrentBlockNameDictionary.Count);

    for i := 0 to blockCount - 1 do
    begin
      sImageName := FoCurrentLoadingFile.ReadString('block', IntToStr(i), '');
      if sImageName = '' then
        continue;
      imageIndex := addPicture(sImageName, true);
      FoCurrentBlockNameDictionary.Values[IntToStr(i)] := IntToStr(imageIndex);
    end;

    objectCount := FoCurrentLoadingFile.ReadInteger('count', 'object', 0);
    for i := 0 to objectCount - 1 do
    begin

      sObject := FoCurrentLoadingFile.ReadString('object', IntToStr(i), '');
      if sObject = '' then
        continue;
      sl.CommaText := sObject;
      if (sl[0] = 'v0') and (sl.Count >= 5) then
      begin
        x := StrToIntDef(sl[1], 0);
        y := StrToIntDef(sl[2], 0);
        z := StrToIntDef(sl[3], 0);
        index := StrToIntDef(sl[4], 0);

        imageIndex := StrToIntDef(FoCurrentBlockNameDictionary.Values[IntToStr(index)], 0);
        FoDrawer.FnSelectedBlockIndex := imageIndex;
        try
          goToPosition(xini + x, yini + y, zini + z);
          FoDrawer.putNewBlock(imageTargetPlace1hand);
        except
          on E:Exception do
            mmCmd.Lines.Add('log: Error putting new block on load world context: '
              + E.Message);
        end;
      end;

    end;
  finally
    mmCmd.Lines.EndUpdate;
    sl.Free;
    FoCurrentBlockNameDictionary.Free;
    FoCurrentLoadingFile.Free;
  end;

end;

procedure TfrmGame.goToPosition(const x, y, z: integer);
begin
  FoDrawer.FnCurrentPlacePositionX := x;
  FoDrawer.FnCurrentPlacePositionY := y;
  FoDrawer.FnCurrentPlacePositionZ := z;
  updateTargetImagePosition;
  FoLastMoveKind := makMove;
end;

procedure TfrmGame.BlockMotionEngineMove(Sender: TMotionBlockControl; const x,
  y, z: integer);
begin
  FoDrawer.FnCurrentPlacePositionX := x;
  FoDrawer.FnCurrentPlacePositionY := y;
  FoDrawer.FnCurrentPlacePositionZ := z;

  if Sender <> nil then
  begin
    Sender.FnCurrentX:= FoDrawer.FnCurrentPlacePositionX;
    Sender.FnCurrentY:= FoDrawer.FnCurrentPlacePositionY;
    Sender.FnCurrentZ:= FoDrawer.FnCurrentPlacePositionZ;
  end;
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

        Sender.FnCurrentX:= FoDrawer.FnCurrentPlacePositionX;
        Sender.FnCurrentY:= FoDrawer.FnCurrentPlacePositionY;
        Sender.FnCurrentZ:= FoDrawer.FnCurrentPlacePositionZ;

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
  if sender = nil then
    mmCmd.Lines.Add('log: ' + msg)
  else
    mmCmd.Lines.Add('log: from motion block ID ' + IntToStr(Sender.FnId)
      + ' at (' + IntToStr(sender.FnCurrentX) + ',' + IntToStr(sender.FnCurrentY)
      + ',' + IntToStr(sender.FnCurrentZ) + ') => ' + msg);
end;

procedure TfrmGame.BlockMotionEngineMoveBlock(Sender: TMotionBlockControl;
  const x, y, z: integer; const effect: String);
begin

  FoDrawer.FnCurrentPlacePositionX := x;
  FoDrawer.FnCurrentPlacePositionY := y;
  FoDrawer.FnCurrentPlacePositionZ := Z;

  updateTargetImagePosition;

  Sender.FnCurrentX:= FoDrawer.FnCurrentPlacePositionX;
  Sender.FnCurrentY:= FoDrawer.FnCurrentPlacePositionY;
  Sender.FnCurrentZ:= FoDrawer.FnCurrentPlacePositionZ;

  FoDrawer.moveBlock(Sender.FoBlock, effect);
end;

procedure TfrmGame.BlockMotionEngineMoveBlockWithOutCursor(
  Sender: TMotionBlockControl; const x, y, z: integer; const effect: String);
begin
  updateTargetImagePosition;

  FoDrawer.moveBlockToWithoutCursor(Sender.FoBlock, x, y, z, effect);

  Sender.FnCurrentX:= x;
  Sender.FnCurrentY:= y;
  Sender.FnCurrentZ:= z;

end;

end.


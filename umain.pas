unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Buttons, StdCtrls, IniFiles, LCLType, Menus, Dos, utypes, uBlockColection,
  uBlockMotionEngine, uControlConfig, uAbstractDrawer, uLoggerOfDrawer,
  uPSComponent, ucmdhelp, Math, uPreviewOpenFile, fileutil, ShellApi;

const
  STATUSBAR_POSITION_INDEX = 0;
  STATUSBAR_ZOOM_INDEX = 1;
  STATUSBAR_SELECTED_BLOCK_INDEX = 2;
  STATUSBAR_MESSAGES_INDEX = 3;

  C_SUBFOLDER_WORLDS = '\data\users\default\worlds\';
  C_SUBFOLDER_IMAGES = '\images\';

  C_EXT_METADATA_FILE = '.Metadata.ini';
  C_EXT_WORLD_FILE = '.World.ini';

  C_BLOCK_MODEL_NAME = 'block_model.PNG';
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
    lblSavedPoints: TLabel;
    lblOptions: TLabel;
    lblShortCuts: TLabel;
    miSaveAsBlock: TMenuItem;
    midiv: TMenuItem;
    miEnableLogsAnimatedBlocks: TMenuItem;
    miShowLastErrorsFromMotionBlock: TMenuItem;
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
    TimerAutoSave: TTimer;
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
    procedure miEnableLogsAnimatedBlocksClick(Sender: TObject);
    procedure miLoadWorldAtCursorClick(Sender: TObject);
    procedure miLoadWorldClick(Sender: TObject);
    procedure miMoveByMouseClick(Sender: TObject);
    procedure miSaveAsBlockClick(Sender: TObject);
    procedure miSaveWorldClick(Sender: TObject);
    procedure miShowLastErrorsFromMotionBlockClick(Sender: TObject);
    procedure mmCmdChange(Sender: TObject);
    procedure PSScript1Compile(Sender: TPSScript);
    procedure TabSheet1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbZoomChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerAutoSaveTimer(Sender: TObject);
    procedure TimerLimitTimer(Sender: TObject);
  private
    FsAutoSaveName: string;
    MouseNav: record
      LastX, LastY: Integer;
    end;
    FoLastMoveKind: TMoveActionKind;
    FbBlocked: Boolean;
    FoLastBlock: Tblock;

    FoDrawer: TAbstractDrawer;
    FoLoggerOfDrawer: TLoggerOfDrawer;

    FnTimeRemail: integer;
    FMenuButtonsList: TArrayOfSpeedButton;

    FoCurrentLoadingFile: TIniFile;
    FoCurrentSavingFile: TIniFile;
    FoCurrentBlockNameDictionary: TStringList;
    FoCurrentSavingObjectCount: integer;

    FslSavedPoints: TStringList;

    function handleDirectKeysOnPlace(Sender: TObject; var Key: Word; Shift: TShiftState): boolean;

    procedure goHome;
    procedure loadMetadata(b: Tblock);
    procedure loadWorldAtCursor(const xini, yini, zini: integer);
    procedure loadWorldFromFileAtCursor(const sName: string; const xini, yini, zini: integer);
    procedure goToPosition(const x, y, z: integer); overload;
    procedure goToPosition(const pointStr: string);

    procedure DefineSavedPointsTextValue(const key, value: string);

    procedure BlockMotionEngineMove(Sender: TMotionBlockControl; const x,y,z: integer);
    procedure BlockMotionEnginePut(Sender: TMotionBlockControl; const index: integer);
    procedure BlockMotionEngineLog(Sender: TMotionBlockControl; const msg: string);
    procedure BlockMotionEngineMoveBlock(Sender: TMotionBlockControl;
      const x,y,z: integer; const effect: String);
    procedure BlockMotionEngineMoveBlockWithOutCursor(Sender: TMotionBlockControl;
      const x,y,z: integer; const effect: String);

    procedure executeCommandBuildUp(const offset: integer; const p0, p1: string;
      const updateSavedPoints: boolean);

    procedure updateTargetImagePosition;
    procedure loadTexts;
    procedure loadPictures;
    function addPicture(const sFileName: string; testDuplication: boolean): integer;
    procedure FormKeyDownPlace1(var Key: Word; Shift: TShiftState);
    procedure FormDirectionPlace1(direction: TDirection; Shift: TShiftState);
    procedure updateSelectedBlock(const index: integer; blocksImageList: TImageList);
    procedure initMotion(b: Tblock);
    procedure openLastErrorLastBlock;
    procedure putNewBlock(const alowMotion: boolean);
    procedure pickBlock;
    procedure InitTimeLimit;
    procedure UpdateTimeLimit;
    function handleBlockSelection(key: Word): boolean;
    procedure addImageBlockToImageList(filepath: string; aList:TImageList);
    procedure callInventory;
    procedure BlockColectionVisitEventSalveToFile(sender: TObject; block: TBlock);
    procedure BlockColectionVisitDeleteAll(sender: TObject; block: TBlock);
    function CalculateFullFileNameToSavedWorls(const sName: string; const block: boolean): string;

    procedure ExecCmd(const cmd: string);
    procedure SaveWorld(const sName: string; const block: boolean = false);
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
  initZ := FoDrawer.CurrentPlacePositionZ;

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
      FoDrawer.CurrentPlacePositionY := FoDrawer.FnCurrentPlacePositionY + 1;
    end;
    dirDown: begin
      if FoDrawer.FnCurrentPlacePositionY <= 0 then
        exit;
      statusMessage('moveDown', 'Moving target to Down');
      FoDrawer.FnCurrentPlacePositionY := FoDrawer.FnCurrentPlacePositionY - 1;
    end;
    dirLeft: begin
      if FoDrawer.CurrentPlacePositionX <= 0 then
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
      mmCmd.Lines.Add('log: Error inserting motion in block: ' + E.message);
  end;
end;


procedure TfrmGame.loadMetadata(b: Tblock);
var
  sName: string;
begin
  try
    sName := b.FsFileName + C_EXT_METADATA_FILE;
    if FileExists(sName) then
    begin

      loadWorldFromFileAtCursor(sName, FoDrawer.FnCurrentPlacePositionX,
          FoDrawer.FnCurrentPlacePositionY,
              FoDrawer.FnCurrentPlacePositionZ);
    end;
  except
    on e:Exception do
      mmCmd.Lines.Add('log: Error inserting mtadata in block: ' + E.message);
  end;
end;


procedure TfrmGame.openLastErrorLastBlock;
var
  s: string;
begin
  if FoLastBlock = nil then
    exit;
  try
    s := FoLastBlock.FsFileName + '.pas.ErrorList.txt';
    if FileExists(s) then
    begin
      mmCmd.Lines.LoadFromFile(s);
      DeleteFile(s);
    end
    else
      ShowMessage('Error List File now exists.');
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

    FoLastBlock := b;

    loadMetadata(b);

    if alowMotion then
      initMotion(b);

    TBlockMotionEngine.notifyBlockMove(b, b.FnX, b.FnY, b.FnZ, b.FnX, b.FnY, b.FnZ);
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

 TBlockMotionEngine.notifyBlockKill(
   FoDrawer.FoCurrentPlaceBlockCollection.find(FoDrawer.FnCurrentPlacePositionX,
    FoDrawer.FnCurrentPlacePositionY, FoDrawer.FnCurrentPlacePositionZ),
    FoDrawer.FnCurrentPlacePositionX, FoDrawer.FnCurrentPlacePositionY,
    FoDrawer.FnCurrentPlacePositionZ);

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
function TfrmGame.handleBlockSelection(key: Word): boolean;
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
    exit(false);
  end;
  componentName := 'btnBlock' + charKey;
  oComponent := FindComponent(componentName);
  if oComponent <> nil then
  begin
    btnSelectBlockClick(oComponent);
    exit(true);
  end;

  exit(false);
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
  lblShortCuts.Hint := lblShortCuts.Caption;
  FslSavedPoints := TStringList.Create;
  DefineSavedPointsTextValue('home', '0 0 0');
  MouseNav.LastX := -1;
  MouseNav.LastY := -1;

  FoDrawer := TAbstractDrawer.Create;
  FoLoggerOfDrawer := TLoggerOfDrawer.Create;
  FoLoggerOfDrawer.FoLogger := mmCmd;
  FoDrawer.setNextDrawer(FoLoggerOfDrawer);

  if miEnableLogsAnimatedBlocks.Checked then
    TBlockMotionEngine.setEventLog(@BlockMotionEngineLog)
  else
    TBlockMotionEngine.setEventLog(nil);

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
  FslSavedPoints.Free;
  FoDrawer.setNextDrawer(nil);
  FoLoggerOfDrawer.Free;
  FoDrawer.FoCurrentPlaceBlockCollection.Free;
  FoDrawer.FControlPlace1.Free;
  FoDrawer.Free;
end;



function TfrmGame.handleDirectKeysOnPlace(Sender: TObject; var Key: Word;
  Shift: TShiftState): boolean;
var
  keyStr, cmd: string;
  i: integer;
begin

  //save points to use in commands as p0 .. p9
  if (ssCtrl in Shift) and ((Key >= $30) and (Key <= $39)) then
  begin
    keyStr := 'p' + char(key);
    DefineSavedPointsTextValue(keyStr, Format('%d %d %d',
      [FoDrawer.FnCurrentPlacePositionX, FoDrawer.FnCurrentPlacePositionY,
      FoDrawer.FnCurrentPlacePositionZ]));

    mmCmd.Lines.Add('Saved positon ' + keyStr + ' => ' +
      FslSavedPoints.Values[keyStr] + ' (use this in commands like goto...');

    exit;
  end;

  //go to saved points
  if (ssShift in Shift) and ((Key >= $30) and (Key <= $39)) then
  begin
    keyStr := 'p' + char(key);
    goToPosition(FslSavedPoints.Values[keyStr]);
    exit;
  end;


  FormKeyDownPlace1(Key, Shift);

  result := true;
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
  else if key = 79 {'o'} then
  begin
    lblOptionsClick(self);
  end
  else if not handleBlockSelection(key) then
    result := false;

end;


procedure TfrmGame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cmd: string;
begin
  if key = VK_C then
  begin
    if InputQuery('Command', 'Type a comand ou h por help', cmd) then
      ExecCmd(cmd);
  end
  else
  begin
    handleDirectKeysOnPlace(Sender, Key, Shift);
  end;
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
  FoDrawer.FoCurrentPlaceBlockCollection.deleteAll(@BlockColectionVisitDeleteAll, false);
end;

procedure TfrmGame.miEnableLogsAnimatedBlocksClick(Sender: TObject);
begin
  miEnableLogsAnimatedBlocks.Checked := not miEnableLogsAnimatedBlocks.Checked;

  if miEnableLogsAnimatedBlocks.Checked then
    TBlockMotionEngine.setEventLog(@BlockMotionEngineLog)
  else
    TBlockMotionEngine.setEventLog(nil);

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

procedure TfrmGame.miSaveAsBlockClick(Sender: TObject);
var
  sName: String;
begin
  if not inputQuery('Save world as Block', 'Enter the block name:', sName) then
    exit;

  SaveWorld(sName, true);

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

 function TfrmGame.CalculateFullFileNameToSavedWorls(const sName: string; const block: boolean): string;
begin
  if block then
  begin
    Result := ExtractFilePath(Application.ExeName) + 'images\blocks\'
      + sName + ExtractFileExt(C_BLOCK_MODEL_NAME) + C_EXT_METADATA_FILE;
    exit;
  end;
  Result := ExtractFilePath(Application.ExeName) + C_SUBFOLDER_WORLDS
    + sName + C_EXT_WORLD_FILE;
end;


 procedure TfrmGame.ExecCmd(const cmd: string);
 var
   c: string;
   sl, slSub: TStringList;
   val, dir, x, y, z, i, col, row: integer;
   ss: TShiftState;
   key: Word;
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
       initMotion(
         FoDrawer.putNewBlock(imageTargetPlace1hand)
       );


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
       initMotion(
         FoDrawer.putNewBlock(imageTargetPlace1hand)
       );
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
   slSub := TStringList.Create;
   try
      while true do
      begin
        sl.DelimitedText := c;

        x := FoDrawer.FnCurrentPlacePositionX;
        y := FoDrawer.FnCurrentPlacePositionY;
        z := FoDrawer.FnCurrentPlacePositionZ;

        key := 0;
        if Length(sl[0]) = 1 then
          key := Ord(Copy(sl[0], 1, 1)[1]);
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


        else if (sl[0] = 'goto') and (sl.Count >= 3 ) then
        begin
          if sl.Count >= 4  then
            z := StrToIntDef(sl[3], z);

          goToPosition(format('%s %s %d', [sl[1], sl[2], z]));
        end

        else if (sl[0] = 'goto') and (sl.Count >= 2 )
          and ((sl[1] = 'home') or (pos('p', sl[1]) = 1)) then
        begin
          slSub.Delimiter := ' ';
          slSub.DelimitedText := FslSavedPoints.Values[sl[1]];
          if slSub.Count >= 2 then
          begin
            x := StrToIntDef(slSub[0], x);
            y := StrToIntDef(slSub[1], y);
            if slSub.Count >= 3  then
              z := StrToIntDef(slSub[2], z);
            goToPosition(x, y, z);
          end;
        end

        else if ((sl[0] = 'buildup') or (sl[0] = 'bu')) and (sl.Count = 1 ) then
        begin
          //up the block at same x and y, but z - 1
          x := FoDrawer.FnCurrentPlacePositionX;
          y := FoDrawer.FnCurrentPlacePositionY;
          z := FoDrawer.FnCurrentPlacePositionZ - 1;
          executeCommandBuildUp(1, format('%d %d %d', [x, y, z]),
            format('%d %d %d', [x, y + 50, z]), false);
        end


        else if ((sl[0] = 'buildup') or (sl[0] = 'bu')) and (sl.Count >= 3 )
          and ((sl[1] = 'home') or (pos('p', sl[1]) = 1))
          and (pos('p', sl[2]) = 1) then
        begin

          if (sl.Count >= 4) and (sl[3] = 'noupdate') then
            executeCommandBuildUp(1, sl[1], sl[2], false)
          else
            executeCommandBuildUp(1, sl[1], sl[2], true);
        end

        else if ( (sl.Count <> 1) or (key = 0) or (not handleDirectKeysOnPlace(self, key, ss)) ) then
          ShowMessage('Invalid Command.');

        if not InputQuery('Comamnd', 'enter a new command', c) then
          exit;
      end;
   finally
     slSub.Free;
     sl.Free;
   end;

 end;


procedure TfrmGame.SaveWorld(const sName: string; const block: boolean);
var
  s, img: string;
begin

    FoCurrentSavingObjectCount := 0;
  s := CalculateFullFileNameToSavedWorls(sName, block);
  FoCurrentSavingFile := TIniFile.Create(s);
  FoCurrentBlockNameDictionary := TStringList.Create;
  try
    FoDrawer.FoCurrentPlaceBlockCollection.visitAll(@BlockColectionVisitEventSalveToFile);
    FoCurrentSavingFile.WriteInteger('count', 'object', FoCurrentSavingObjectCount);
    FsAutoSaveName := sName;

    if not  block then
      exit;

    img := ExtractFileExt(C_BLOCK_MODEL_NAME);
    img := StringReplace(s, C_EXT_METADATA_FILE, '', []);

    s := ExtractFilePath(Application.ExeName) + C_SUBFOLDER_IMAGES + C_BLOCK_MODEL_NAME;
    CopyFile(s, img);

    ShellExecute(0,nil, PChar('cmd'),PChar('/c "C:\Windows\system32\mspaint.exe" "' + img + '"'),nil,0);
  finally
    FoCurrentBlockNameDictionary.Free;
    FoCurrentSavingFile.Free;
  end;

end;

procedure TfrmGame.miSaveWorldClick(Sender: TObject);
var
  sName: String;
begin
  if not inputQuery('Save world', 'Enter the world name:', sName) then
    exit;

  SaveWorld(sName);
end;

procedure TfrmGame.miShowLastErrorsFromMotionBlockClick(Sender: TObject);
begin
  openLastErrorLastBlock;
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

procedure TfrmGame.TimerAutoSaveTimer(Sender: TObject);
begin
  if FsAutoSaveName = '' then
    FsAutoSaveName := 'AutoSavedLastWorls' + C_EXT_WORLD_FILE;
  statusMessage('autoSaveStart', 'Auto saving world...');
  DeleteFile(FsAutoSaveName);
  try
    SaveWorld(FsAutoSaveName);
  finally
    statusMessage('autoSaveStart', 'Auto saving world...Done');
  end;
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

procedure TfrmGame.loadWorldFromFileAtCursor(const sName: string; const xini, yini, zini: integer);
var
  sImageName, sObject: string;
  i, x, y, z, index, imageIndex, blockCount, objectCount: integer;
  sl: TStringList;
begin

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
            mmCmd.Lines.Add('log: Error putting new block on load world or metadata context: '
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


procedure TfrmGame.loadWorldAtCursor(const xini, yini, zini: integer);
var
  sName: string;
begin
  if not TfrmPreviewOpenFile.Execute(FoDrawer, sName) then
    exit;

  sName := ExtractFilePath(Application.ExeName) + C_SUBFOLDER_WORLDS + sName;

  loadWorldFromFileAtCursor(sName, xini, yini, zini);


end;

procedure TfrmGame.goToPosition(const x, y, z: integer);
begin
  FoDrawer.FnCurrentPlacePositionX := x;
  FoDrawer.FnCurrentPlacePositionY := y;
  FoDrawer.FnCurrentPlacePositionZ := z;
  updateTargetImagePosition;
  FoLastMoveKind := makMove;
end;

procedure TfrmGame.goToPosition(const pointStr: string);
var
  sl: TStringList;
  x, y, z: integer;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := ' ';
    sl.DelimitedText := pointStr;
    if sl.Count >= 2 then
    begin
      x := StrToIntDef(sl[0], FoDrawer.FnCurrentPlacePositionX);
      y := StrToIntDef(sl[1], FoDrawer.FnCurrentPlacePositionY);
      if sl.Count >= 3  then
        z := StrToIntDef(sl[2], FoDrawer.FnCurrentPlacePositionZ);
      goToPosition(x, y, z);

    end;
  finally
    sl.Free;
  end
end;

procedure TfrmGame.DefineSavedPointsTextValue(const key, value: string);
var
  i: integer;
begin
  FslSavedPoints.Values[key] := value;

  lblSavedPoints.Caption := 'Saved points: ' + #13;
  for i := 0 to FslSavedPoints.Count - 1 do
    lblSavedPoints.Caption := lblSavedPoints.Caption + ' - ' + FslSavedPoints[i] + #13;

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
var
  prevX, prevY, prevZ: integer;
begin
  prevX := FoDrawer.FnCurrentPlacePositionX;
  prevY := FoDrawer.FnCurrentPlacePositionY;
  prevZ := FoDrawer.FnCurrentPlacePositionZ;

  FoDrawer.FnCurrentPlacePositionX := x;
  FoDrawer.FnCurrentPlacePositionY := y;
  FoDrawer.FnCurrentPlacePositionZ := Z;

  updateTargetImagePosition;

  Sender.FnCurrentX:= FoDrawer.FnCurrentPlacePositionX;
  Sender.FnCurrentY:= FoDrawer.FnCurrentPlacePositionY;
  Sender.FnCurrentZ:= FoDrawer.FnCurrentPlacePositionZ;

  FoDrawer.moveBlock(Sender.FoBlock, effect);

  TBlockMotionEngine.notifyBlockMove(Sender.FoBlock, Sender.FnCurrentX, Sender.FnCurrentY,
    Sender.FnCurrentZ, prevX, prevY, prevZ);
end;

procedure TfrmGame.BlockMotionEngineMoveBlockWithOutCursor(
  Sender: TMotionBlockControl; const x, y, z: integer; const effect: String);
begin
  updateTargetImagePosition;

  FoDrawer.moveBlockToWithoutCursor(Sender.FoBlock, x, y, z, effect);

  //the animated block have your own control of position. Is this a good idea?
  Sender.FnCurrentX:= x;
  Sender.FnCurrentY:= y;
  Sender.FnCurrentZ:= z;

end;

procedure TfrmGame.executeCommandBuildUp(const offset: integer; const p0,
  p1: string; const updateSavedPoints: boolean);
var
  sl0, sl1: TStringList;
  x, y, z, minX, maxX, minY, maxY, minZ, maxZ: integer;
  block: TBlock;
begin
  sl0 := TStringList.Create;
  sl0.Delimiter := ' ';
  sl1 := TStringList.Create;
  sl1.Delimiter := ' ';
  try
    try
      if Pos(' ', p0) > 1 then
        sl0.DelimitedText := p0
      else
      begin
        sl0.DelimitedText := FslSavedPoints.Values[p0];
        if (sl0.count = 3) and updateSavedPoints then
          DefineSavedPointsTextValue(p0, Format('%s %d %s', [sl0[0],
            StrToInt(sl0[1])+ offset, sl0[2]]));

      end;

      if Pos(' ', p1) > 1 then
        sl1.DelimitedText := p1
      else
      begin
        sl1.DelimitedText := FslSavedPoints.Values[p1];
        if (sl1.count = 3) and updateSavedPoints then
          DefineSavedPointsTextValue(p1, Format('%s %d %s', [sl1[0],
            StrToInt(sl1[1])+ offset, sl1[2]]));


    end;


      if (sl0.Count + sl1.Count) < 6 then
        exit;

      minX := min(StrToInt(sl0[0]), StrToInt(sl1[0]));
      maxX := max(StrToInt(sl0[0]), StrToInt(sl1[0]));

      minY := min(StrToInt(sl0[1]), StrToInt(sl1[1]));
      maxY := max(StrToInt(sl0[1]), StrToInt(sl1[1]));

      minZ := min(StrToInt(sl0[2]), StrToInt(sl1[2]));
      maxZ := max(StrToInt(sl0[2]), StrToInt(sl1[2]));

      for z := maxZ downto minZ do
        for y := maxY downto minY do
          for x := minX to maxX do
          begin
            //move block offset up (without check if exist a block, for simplicity efect)

            block := FoDrawer.FoCurrentPlaceBlockCollection.find(x, y, z);
            if block <> nil then
            begin
              FoDrawer.moveBlockToWithoutCursor(block, x, y + offset, z, '');

              //if this is a animated block?


            end;
          end;
    except
      on E: Exception do
        mmCmd.Lines.Add('Erro on build up command: ' + e.Message);
    end;
  finally
    sl0.Free;
    sl1.Free;
  end;
end;

end.


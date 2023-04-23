unit uBlockMotionEngine;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, forms, MMSystem, uPSComponent, uBlockColection;

type

  { TMotionBlockControl }
  TMotionBlockControl = class;

  TBlockMotionEngineLog = procedure (Sender: TMotionBlockControl; const msg: string) of object;
  TBlockMotionEngineMove = procedure (Sender: TMotionBlockControl; const x,y,z: integer) of object;
  TBlockMotionEnginePut = procedure (Sender: TMotionBlockControl; const index: integer) of object;
  TBlockMotionEngineMoveBlock = procedure (Sender: TMotionBlockControl;
    const x,y,z: integer; const effect: String) of object;

  TNotifyBlockPosition = procedure (Sender: TComponent;
    const oBlock: TBlock; const x,y,z: integer) of object;


  TBlockMotionEngineExecutionThread = class;


  TMotionBlockControlEventsParam = record
    oEventMove: TBlockMotionEngineMove;
    oEventPut: TBlockMotionEnginePut;
    oEventMoveBlock: TBlockMotionEngineMoveBlock;
    oEventMoveBlockWithOutCursor: TBlockMotionEngineMoveBlock;
  end;

  TMotionBlockStriptMessage = class
    msg: string;
    iparam0, iparam1, iparam2, iparam3: integer;
    sparam: string;
  end;




  TMotionBlockStriptEventControl = class
    FnId: integer;
    FnBlockId: integer;
    FsName: string;
    FslParams: TStringList;
  end;

  TMotionBlockControl = class
  public
    FnId: integer;
    FoBlock: TBlock;
    FsScriptFileName: string;
    FoEventMove: TBlockMotionEngineMove;
    FoEventPut: TBlockMotionEnginePut;
    FoEventMoveBlock: TBlockMotionEngineMoveBlock;
    FoEventMoveBlockWithOutCursor: TBlockMotionEngineMoveBlock;

    SleepTime: integer;
    thread: TBlockMotionEngineExecutionThread;

    FnCurrentX: integer;
    FnCurrentY: integer;
    FnCurrentZ: integer;

    FarrEvents: array of TMotionBlockStriptEventControl;

    FslMessageObjects: TStringList;

    procedure DoSleep;
    constructor Create(block: TBlock; const scriptFileName: string;
      events: TMotionBlockControlEventsParam);
    destructor Destroy; override;
  end;

  { TBlockMotionEngine }
  TBlockMotionEngine = class;

  { TBlockMotionEngineExecutionThread }

  TBlockMotionEngineExecutionThread = class(TThread)
  private
    FoEngine: TBlockMotionEngine;
    FoPSScript: TPSScript;
    FsScriptFileName: string;
    FnSleepTime: integer;
  protected
    procedure Execute; override;
  public
    procedure DoSleep;
    procedure DoSleep(SleepTime: integer);
    Constructor Create(CreateSuspended : boolean; PSScript1: TPSScript;
      Engine: TBlockMotionEngine; ScriptFileName: String);
  end;

  TBlockMotionEngine = class
  public
    procedure PSScript1Compile(Sender: TPSScript);

    class procedure insert(block: TBlock; const scriptFileName: string;
       events: TMotionBlockControlEventsParam);

    class procedure insertWithThread(block: TBlock; const scriptFileName: string;
       const events: TMotionBlockControlEventsParam);

    class procedure notifyBlockMove(block: TBlock; const x, y, z, prevX, prevY, prevZ: integer);
    class procedure notifGenericEvent(block: TBlock; const x, y, z: integer; const event_name: string);
    class procedure notifyBlockKill(block: TBlock; const x, y, z: integer);

    class function testFenceAlarm(slFenceParams: TStringList; const x, y, z: integer): boolean;


    class procedure setCurrentPlaceBlockCollection(value: TBlockColection);
    class procedure setEventLog(value: TBlockMotionEngineLog);
  end;

  function SRead(const blockId: integer; const prop: string): integer;
  procedure SSleep(const blockId: integer; const time: integer);
  procedure SMove(const blockId: integer; const x, y, z: integer);
  function SReadBlock(const blockId: integer; const x, y, z: integer): integer;
  procedure SPutBlock(const blockId: integer; const blockIndex: integer);
  procedure SPickBlock(const blockId: integer);
  procedure SMoveBlock(const blockId: integer; const x, y, z: integer; effect: String);
  procedure SSoundBlock(const blockId: integer; n: integer);
  procedure SMoveThisBlock(const blockId: integer; const x, y, z: integer; effect: String);

  function SRegisterEvent(const blockId: integer; const eventName: string; const eventParamKeyValue: string): integer;
  function SCheckMessage(const blockId: integer; out msg: string; out iparam0, iparam1, iparam2, iparam3: integer; out sparam: string): boolean;



var
  gslBlocks: TStringList;
  goCurrentPlaceBlockCollection: TBlockColection;
  goEventLog: TBlockMotionEngineLog;
  goLastMotionBlockCreated: TMotionBlockControl;

implementation

function SBorn: integer;
begin
  result := -1;
  if goLastMotionBlockCreated <> nil then
  begin
    result := gslBlocks.Count;
    goLastMotionBlockCreated.FnId := result;
    gslBlocks.AddObject(IntToStr(result), goLastMotionBlockCreated);
    goLastMotionBlockCreated := nil;
  end;

end;

function GetMotionBlockControlById(const blockId: integer): TMotionBlockControl;
var
  i: integer;
begin

  i := gslBlocks.IndexOf(IntToStr(blockId));
  if i < 0 then
    exit(nil);

  result := TMotionBlockControl(gslBlocks.Objects[i]);
end;


function GetMotionBlockControlByPosition(const x, y, z: integer): TMotionBlockControl;
var
  i: integer;
begin

  for i := 0 to gslBlocks.Count - 1 do
  begin
    result := TMotionBlockControl(gslBlocks.Objects[i]);
    if result.FnCurrentX <> x then continue;
    if result.FnCurrentY <> y then continue;
    if result.FnCurrentZ <> z then continue;
    exit;
  end;
  result := nil;
end;


function SRead(const blockId: integer; const prop: string): integer;
var
  blockcontrol: TMotionBlockControl;
begin
  Result := 0;
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;

  if prop = 'x' then
    exit(blockcontrol.FoBlock.FnX);
  if prop = 'y' then
    exit(blockcontrol.FoBlock.FnY);
  if prop = 'z' then
    exit(blockcontrol.FoBlock.FnZ);
  if prop = 'blockid' then
    exit(blockcontrol.FoBlock.FnImageIndex);
end;

procedure SSleep(const blockId: integer; const time: integer);
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;
  blockcontrol.SleepTime := time;
  blockcontrol.DoSleep;

end;

procedure SMove(const blockId: integer; const x, y, z: integer);
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;
  if not Assigned(blockcontrol.FoEventMove) then
    exit;
  blockcontrol.FoEventMove(blockcontrol, x, y, z);
end;

function SReadBlock(const blockId: integer; const x, y, z: integer): integer;
var
  b: TBlock;
begin
  result := -1;
  if not Assigned(goCurrentPlaceBlockCollection) then
    exit;

  b := goCurrentPlaceBlockCollection.find(x,y,z);
  if not Assigned(b) then
    exit;

  result := b.FnImageIndex;

end;


procedure SPutBlock(const blockId: integer; const blockIndex: integer);
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;
  if not Assigned(blockcontrol.FoEventMove) then
    exit;
  blockcontrol.FoEventPut(blockcontrol, blockIndex);
end;

procedure SPickBlock(const blockId: integer);
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;
  if not Assigned(blockcontrol.FoEventMove) then
    exit;
  blockcontrol.FoEventPut(blockcontrol, -1);
end;

procedure SMoveBlock(const blockId: integer; const x, y, z: integer; effect: String);
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;
  if not Assigned(blockcontrol.FoEventMoveBlock) then
    exit;
  blockcontrol.FoEventMoveBlock(blockcontrol, x, y, z, effect);
end;

procedure SMoveThisBlock(const blockId: integer; const x, y, z: integer; effect: String);
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;
  if not Assigned(blockcontrol.FoEventMoveBlockWithOutCursor) then
    exit;
  blockcontrol.FoEventMoveBlockWithOutCursor(blockcontrol, x, y, z, effect);
end;

function SRegisterEvent(const blockId: integer; const eventName: string; const eventParamKeyValue: string): integer;
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;

  if not Assigned(blockcontrol.FoEventMoveBlock) then
    exit;

  Result := Length(blockcontrol.FarrEvents);

  SetLength(blockcontrol.FarrEvents, Result + 1);

  blockcontrol.FarrEvents[Result] :=  TMotionBlockStriptEventControl.Create;

  with blockcontrol.FarrEvents[Result] do
  begin
    FsName := eventName;
    FnBlockId := blockId;
    FnId := Result;
    FslParams := TStringList.Create;
    FslParams.Text := eventParamKeyValue;
  end;

end;

function SCheckMessage(
   const blockId: integer; out msg: string;
   out iparam0, iparam1, iparam2, iparam3: integer; out sparam: string): boolean;
var
  blockcontrol: TMotionBlockControl;
  m: TMotionBlockStriptMessage;
begin
  msg := '';
  iparam0 := 0;
  iparam1 := 0;
  iparam2 := 0;
  iparam3 := 0;
  sparam := '';
  result := false;

  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;

  if not Assigned(blockcontrol.FoEventMoveBlock) then
    exit;

  Result := blockcontrol.FslMessageObjects.Count > 0;

  if not result then
    exit;

  m := TMotionBlockStriptMessage(blockcontrol.FslMessageObjects.Objects[0]);

  msg := m.msg;
  iparam0 := m.iparam0;
  iparam1 := m.iparam1;
  iparam2 := m.iparam2;
  iparam3 := m.iparam3;
  sparam := m.sparam;

  m.Free;
  blockcontrol.FslMessageObjects.Delete(0);

end;



procedure SSoundBlock(const blockId: integer; n: integer);
var
  blockcontrol: TMotionBlockControl;
  s: string;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;

    s := blockcontrol.FoBlock.FsFileName + Format('.%d.wav', [n]);
    PlaySound(PChar(s), 0, SND_ASYNC);
end;

{ TBlockMotionEngineExecutionThread }

procedure TBlockMotionEngineExecutionThread.Execute;
var
   i: Integer;
   result: boolean;
   sl, slError: TStringList;
   //based on https://wiki.freepascal.org/Pascal_Script_Examples
   sErrorFileName, sError: String;
begin
  sErrorFileName := FsScriptFileName + '.ErrorList.txt';
  sl := TStringList.Create;
  slError := TStringList.Create;
  try
    DeleteFile(sErrorFileName);
    try

      if not FileExists(FsScriptFileName) then
        raise Exception.Create('Error inserting motion block with script ' + FsScriptFileName + ': File not found');


      FoPSScript.OnCompile := @FoEngine.PSScript1Compile;

      Result:= False;
      sl.LoadFromFile(FsScriptFileName);
      FoPSScript.Script.Text:= sl.Text;
      result:= FoPSScript.Compile;

      if (not result) or (FoPSScript.CompilerMessageCount > 0) then
      begin
        sError := 'Error inserting motion block with script ' + FsScriptFileName + '. count: ' + IntToStr(FoPSScript.CompilerMessageCount);
        slError.Add(sError);
        for i:= 0 to FoPSScript.CompilerMessageCount - 1 do
          slError.Add(FoPSScript.CompilerMessages[i].MessageToString);
      end;

      if result then
      begin
        try
            Result := FoPSScript.Execute;
        except
          on E: Exception do
          begin
            raise Exception.Create('Error inserting motion block with script ' + FsScriptFileName
              + ': Run-time error:'+ e.Message);
          end;
        end;

        if not Result then
         raise Exception.Create('Error inserting motion block with script ' + FsScriptFileName
           + ': Run-time error:'+ FoPSScript.ExecErrorToString);
      end;

    except
      on E: Exception do
      begin
        slError.Add(e.Message);
      end;
    end;
  finally
    if slError.Count > 0 then
      slError.SaveToFile(sErrorFileName);

    FoPSScript.Free;
    FoEngine.Free;
    sl.Free;
    slError.Free;
  end;
end;

procedure TBlockMotionEngineExecutionThread.DoSleep;
begin
  Sleep(FnSleepTime);
end;

procedure TBlockMotionEngineExecutionThread.DoSleep(SleepTime: integer);
begin
  FnSleepTime := SleepTime;
  Sleep(FnSleepTime);
end;

constructor TBlockMotionEngineExecutionThread.Create(CreateSuspended: boolean;
  PSScript1: TPSScript; Engine: TBlockMotionEngine; ScriptFileName: String);
begin
  FoPSScript := PSScript1;
  FoEngine := Engine;
  FsScriptFileName := ScriptFileName;
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
end;


{ TMotionBlockControl }

procedure TMotionBlockControl.DoSleep;
begin
  if thread <> nil then
    thread.DoSleep(SleepTime)
  else
    Sleep(SleepTime);
end;


constructor TMotionBlockControl.Create(block: TBlock; const scriptFileName: string;
  events: TMotionBlockControlEventsParam);
begin
  FnId := -1;
  FoBlock := block;
  FsScriptFileName := scriptFileName;
  FoEventMove := events.oEventMove;
  FoEventPut := events.oEventPut;
  FoEventMoveBlock := events.oEventMoveBlock;
  FoEventMoveBlockWithOutCursor := events.oEventMoveBlockWithOutCursor;
  SetLength(FarrEvents, 0);
  FslMessageObjects := TStringList.Create;
end;

destructor TMotionBlockControl.Destroy;
var
   i: integer;
begin
  for i := Low(FarrEvents) to High(FarrEvents) do
  begin
    TMotionBlockStriptEventControl(FarrEvents[i]).FslParams.Free;
    TMotionBlockStriptEventControl(FarrEvents[i]).Free;
  end;
  SetLength(FarrEvents, 0);

  for i := 0 to FslMessageObjects.Count - 1 do
  begin
    TMotionBlockStriptMessage(FslMessageObjects[I]).Free;
  end;
  FslMessageObjects.Free;

  inherited Destroy;
end;



procedure SLog(const blockId: integer; const msg: string);
var
  blockcontrol: TMotionBlockControl;
begin
  blockcontrol := GetMotionBlockControlById(blockId);
  if not Assigned(blockcontrol) then
    exit;
  if not Assigned(goEventLog) then
    exit;
  goEventLog(blockcontrol, msg);
end;



{ TBlockMotionEngine }

procedure TBlockMotionEngine.PSScript1Compile(Sender: TPSScript);
begin
  Sender.AddFunction(@SBorn, 'function born: integer');
  Sender.AddFunction(@SLog, 'procedure log(const blockId: integer; const msg: string)');
  Sender.AddFunction(@SRead, 'function read(const blockId: integer; const prop: string): integer');
  Sender.AddFunction(@SSleep, 'procedure sleep(const blockId: integer; const time: integer)');
  Sender.AddFunction(@SMove, 'procedure move(const blockId: integer; const x, y, z: integer)');
  Sender.AddFunction(@SReadBlock, 'function readBlock(const blockId: integer; const x, y, z: integer): integer');
  Sender.AddFunction(@SPutBlock, 'procedure putBlock(const blockId: integer; const blockIndex: integer)');
  Sender.AddFunction(@SPickBlock, 'procedure pickBlock(const blockId: integer)');

  Sender.AddFunction(@SMoveThisBlock, 'procedure moveBlock(const blockId: integer; const x, y, z: integer; effect: String)');
  Sender.AddFunction(@SSoundBlock, 'procedure soundBlock(const blockId: integer; n: integer)');

  Sender.AddFunction(@Randomize, 'procedure Randomize');
  Sender.AddFunction(@Random, 'Function Random(l:longint):longint');

  Sender.AddFunction(@SRegisterEvent, 'function RegisterEvent(const blockId: integer; const eventName: string; const eventParamKeyValue: string): integer');
  Sender.AddFunction(@SCheckMessage, 'function CheckMessage(const blockId: integer; out msg: string; out iparam0, iparam1, iparam2, iparam3: integer; out sparam: string): boolean');
end;

class procedure TBlockMotionEngine.insert(block: TBlock; const scriptFileName: string;
     events: TMotionBlockControlEventsParam);
var
  PSScript1: TPSScript;
  engine: TBlockMotionEngine;
  i: Integer;
  result: boolean;
  sl: TStringList;
  //based on https://wiki.freepascal.org/Pascal_Script_Examples
  sError: String;
begin
  if not FileExists(scriptFileName) then
    raise Exception.Create('Error inserting motion block with script ' + scriptFileName + ': File not found');

  engine := TBlockMotionEngine.Create;
  PSScript1 := TPSScript.Create(nil);
  sl := TStringList.Create;
  try

    PSScript1.OnCompile := @engine.PSScript1Compile;

    goLastMotionBlockCreated := TMotionBlockControl.Create(block, scriptFileName,
      events);

    Result:= False;
    sl.LoadFromFile(scriptFileName);
    PSScript1.Script.Text:= sl.Text;
    result:= Psscript1.Compile;
    sError := 'Error inserting motion block with script ' + scriptFileName + '. count: ' + IntToStr(Psscript1.CompilerMessageCount);
    for i:= 0 to Psscript1.CompilerMessageCount - 1 do
      sError := sError + #13#10 + Psscript1.CompilerMessages[i].MessageToString;
    if not Result then
      if Psscript1.CompilerMessageCount > 0 then
        raise Exception.Create(sError);

    Result := PSScript1.Execute;
    if not Result then
     raise Exception.Create('Error inserting motion block with script ' + scriptFileName
       + ': Run-time error:'+ PSScript1.ExecErrorToString);

  finally
    PSScript1.Free;
    engine.Free;
    sl.Free;
  end;

end;

class procedure TBlockMotionEngine.insertWithThread(block: TBlock;
  const scriptFileName: string; const events: TMotionBlockControlEventsParam);
var
  PSScript1: TPSScript;
  engine: TBlockMotionEngine;
  //based on https://wiki.freepascal.org/Pascal_Script_Examples
  //t: TBlockMotionEngineExecutionThread;
begin
   if not FileExists(scriptFileName) then
    raise Exception.Create('Error inserting motion block with script ' + scriptFileName + ': File not found');

  engine := TBlockMotionEngine.Create;
  PSScript1 := TPSScript.Create(nil);

  PSScript1.OnCompile := @engine.PSScript1Compile;

  goLastMotionBlockCreated := TMotionBlockControl.Create(block, scriptFileName,
    events);

  //t :=
  goLastMotionBlockCreated.thread := TBlockMotionEngineExecutionThread.Create(false, PSScript1, engine, scriptFileName);
end;

class function TBlockMotionEngine.testFenceAlarm(slFenceParams: TStringList; const x,
  y, z: integer): boolean;
var
  vmin, vmax: integer;
begin
  vmin := StrToIntDef(slFenceParams.Values['xmin'], x);
  vmax := StrToIntDef(slFenceParams.Values['xmax'], x);
  if (x < vmin) or (x > vmax) then
    exit(false);

  vmin := StrToIntDef(slFenceParams.Values['ymin'], y);
  vmax := StrToIntDef(slFenceParams.Values['ymax'], y);
  if (y < vmin) or (y > vmax) then
    exit(false);


  vmin := StrToIntDef(slFenceParams.Values['zmin'], z);
  vmax := StrToIntDef(slFenceParams.Values['zmax'], z);
  if (z < vmin) or (z > vmax) then
    exit(false);

  exit(true);

end;


class procedure TBlockMotionEngine.notifyBlockMove(block: TBlock;
  const x, y, z, prevX, prevY, prevZ: integer);
var
  blockIndex, eventIndex: integer;
  b: TMotionBlockControl;
  e: TMotionBlockStriptEventControl;
  m: TMotionBlockStriptMessage;
begin
  //if the block moved is a animnated block, update your position controls
  b := GetMotionBlockControlByPosition(prevX, prevY, prevZ);
  if Assigned(b) then
  begin
    b.FnCurrentX := x;
    b.FnCurrentY := y;
    b.FnCurrentZ := z;
  end;

  for blockIndex := 0 to gslBlocks.Count - 1 do
  begin
    b := TMotionBlockControl(gslBlocks.Objects[blockIndex]);
    for eventIndex := Low(b.FarrEvents) to High(b.FarrEvents) do
    begin
      e := b.FarrEvents[eventIndex];

      if e.FsName = 'onEnterFence' then
      begin
        try
          if testFenceAlarm(e.FslParams,  x, y, z) then
          begin
            m := TMotionBlockStriptMessage.Create;
            m.msg := 'enter_fence';
            m.iparam0 := b.FnId;
            m.iparam1 := x;
            m.iparam2 := y;
            m.iparam3 := z;
            M.sparam := '';
            b.FslMessageObjects.AddObject(e.FsName + '_' + DateTimeToStr(now), m);
          end;
        except
          on ex: Exception do
          begin
            //SLog(-1, 'Erro em notifyBlockMove: ' + ex.Message);
          end;
        end;
      end;
    end;
  end;
end;

class procedure TBlockMotionEngine.notifyBlockKill(block: TBlock; const x, y,
  z: integer);
begin
  notifGenericEvent(block, x, y, z, 'kill');
end;

class procedure TBlockMotionEngine.notifGenericEvent(block: TBlock; const x, y, z: integer; const event_name: string);
var
  blockIndex, eventIndex: integer;
  b: TMotionBlockControl;
  e: TMotionBlockStriptEventControl;
  m: TMotionBlockStriptMessage;
begin
  if block =  nil then
    exit;

  for blockIndex := 0 to gslBlocks.Count - 1 do
  begin
    b := TMotionBlockControl(gslBlocks.Objects[blockIndex]);
    for eventIndex := Low(b.FarrEvents) to High(b.FarrEvents) do
    begin
      e := b.FarrEvents[eventIndex];

      if e.FsName = 'on' + event_name then
      begin
        try
          m := TMotionBlockStriptMessage.Create;
          m.msg := event_name;
          m.iparam0 := b.FnId;
          m.iparam1 := b.FoBlock.FnX;
          m.iparam2 := b.FoBlock.FnY;
          m.iparam3 := b.FoBlock.FnZ;
          M.sparam := '';
          b.FslMessageObjects.AddObject(e.FsName + '_' + DateTimeToStr(now), m);
        except
          on ex: Exception do
          begin
            //SLog(-1, 'Erro em notifyBlockMove: ' + ex.Message);
          end;
        end;
      end;
    end;
  end;
end;

class procedure TBlockMotionEngine.setCurrentPlaceBlockCollection(
  value: TBlockColection);
begin
  goCurrentPlaceBlockCollection := value;
end;

class procedure TBlockMotionEngine.setEventLog(value: TBlockMotionEngineLog);
begin
  goEventLog := value;
end;


initialization
  gslBlocks := TStringList.Create;
  goCurrentPlaceBlockCollection := nil;
  goEventLog := nil;
  goLastMotionBlockCreated := nil;

finalization
  gslBlocks.Free;

end.


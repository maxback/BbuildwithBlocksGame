unit uBlockMotionEngine;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, forms, uPSComponent, uBlockColection;

type

  { TMotionBlockControl }
  TMotionBlockControl = class;

  TBlockMotionEngineLog = procedure (Sender: TMotionBlockControl; const msg: string) of object;
  TBlockMotionEngineMove = procedure (Sender: TMotionBlockControl; const x,y,z: integer) of object;
  TBlockMotionEnginePut = procedure (Sender: TMotionBlockControl; const index: integer) of object;

  TMotionBlockControl = class
  public
    FnId: integer;
    FoBlock: TBlock;
    FsScriptFileName: string;
    FoEventMove: TBlockMotionEngineMove;
    FoEventPut: TBlockMotionEnginePut;

    constructor Create(block: TBlock; const scriptFileName: string;
     oEventMove: TBlockMotionEngineMove; oEventPut: TBlockMotionEnginePut);
  end;

  { TBlockMotionEngine }


  TBlockMotionEngine = class
  public
    procedure PSScript1Compile(Sender: TPSScript);

    class procedure insert(block: TBlock; const scriptFileName: string;
       oEventMove: TBlockMotionEngineMove; oEventPut: TBlockMotionEnginePut);
    class procedure setCurrentPlaceBlockCollection(value: TBlockColection);
    class procedure setEventLog(value: TBlockMotionEngineLog);
  end;

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
begin
  Sleep(time);
Application.ProcessMessages;

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
  result := 0;
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

{ TMotionBlockControl }

constructor TMotionBlockControl.Create(block: TBlock; const scriptFileName: string;
     oEventMove: TBlockMotionEngineMove; oEventPut: TBlockMotionEnginePut);
begin
  FnId := -1;
  FoBlock := block;
  FsScriptFileName := scriptFileName;
  FoEventMove := oEventMove;
  FoEventPut := oEventPut;
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
end;

class procedure TBlockMotionEngine.insert(block: TBlock; const scriptFileName: string;
     oEventMove: TBlockMotionEngineMove; oEventPut: TBlockMotionEnginePut);
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
      oEventMove, oEventPut);

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


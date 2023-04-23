unit uBlockColection;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Controls, SysUtils, ComCtrls, ExtCtrls;

type
  TBlock = class;

  { TBlockColection }

  TBlockColectionVisitEvent = procedure(sender: TObject; block: TBlock) of object;
  TBlockColection = class
    private
      FBlockList: TStringList;
    public
      procedure add(block: TBlock);
      procedure remove(block: TBlock);
      function find(x, y, z: integer): TBlock;
      function findMaxZ(x, y, defaultZ: integer): TBlock;
      procedure visitAll(visitCallback: TBlockColectionVisitEvent);
      procedure deleteAll(visitCallback: TBlockColectionVisitEvent; const freeBlock: boolean);
      constructor create;
      destructor destroy; override;

  end;

  { TBlock }

  TBlock = class
    public
      FnX: integer;
      FnY: integer;
      FnZ: integer;
      FoImage: TImage;
      FsFileName: string;
      FnImageIndex: integer;
      function ToString: string;
      constructor create(fromString: string; image: TImage);
      constructor create(x, y, z: integer; imageIndex: integer; image: TImage; fileName: string);
  end;



implementation


{ TBlockColection }

procedure TBlockColection.add(block: TBlock);
begin
  FBlockList.AddObject(Format('%d,%d,%d', [block.FnX, block.FnY, block.FnZ]), block);
end;

procedure TBlockColection.remove(block: TBlock);
var
  i: integer;
begin
  i := FBlockList.IndexOfObject(block);
  if i >= 0 then
    FBlockList.Delete(i);
end;

function TBlockColection.find(x, y, z: integer): TBlock;
var
  i: integer;
begin
  i := FBlockList.IndexOf(Format('%d,%d,%d', [x, y, z]));
  if i >= 0 then
    exit(FBlockList.Objects[i] As TBlock);
  exit(nil);
end;

function TBlockColection.findMaxZ(x, y, defaultZ: integer): TBlock;
var
  z: integer;
begin
  z := 1000;
  repeat
    Result := find(x, y, z);
    Dec(z);
  until (Result <> nil) or (z = -1);

  if Result = nil then
    Result := TBlock.Create(x, y, defaultZ, -1, nil, 'dummy object to return in findMaxZ');

end;

procedure TBlockColection.visitAll(visitCallback: TBlockColectionVisitEvent);
var
  i: integer;
begin
  for i := 0 to FBlockList.Count - 1 do
  begin
    if Assigned(visitCallback) then
      visitCallback(self, FBlockList.Objects[i] as TBlock);
  end;
end;

procedure TBlockColection.deleteAll(visitCallback: TBlockColectionVisitEvent; const freeBlock: boolean);
var
  block: TBlock;
begin
  if not Assigned(FBlockList) then
    exit;

  while FBlockList.Count > 0 do
  begin
    if Assigned(visitCallback) then
      visitCallback(self, FBlockList.Objects[0] as TBlock)
    else if freeBlock then
    begin
      block := TBlock(FBlockList.Objects[0]);
      block.Free;
    end;

    FBlockList.Delete(0);
  end;
end;

constructor TBlockColection.create;
begin
  FBlockList := TStringList.Create;
end;

destructor TBlockColection.destroy;
begin
  FBlockList.Free;
end;


{ TBlock }

function TBlock.ToString: string;
begin
  Result := Format('%d,%d,%d,TImage,%s', [FnX, FnY, FnZ, FsFileName]);
end;

constructor TBlock.create(fromString: string; image: TImage);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.CommaText := fromString;
    FnX := StrToIntDef(sl.Strings[0], 0);
    FnY := StrToIntDef(sl.Strings[1], 0);
    FnZ := StrToIntDef(sl.Strings[2], 0);
    FoImage := image;
    FsFileName := sl.Strings[3];
  finally
    sl.Free;
  end;
end;

constructor TBlock.create(x, y, z: integer; imageIndex: integer; image: TImage; fileName: string);
begin
  FnX := x;
  FnY := y;
  FnZ := z;
  FoImage := image;
  FsFileName := fileName;
  FnImageIndex := imageIndex;
end;



end.


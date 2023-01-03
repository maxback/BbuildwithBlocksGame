unit uControlConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLType;

type

  TDirection = (dirNone, dirUp, dirDown, dirLeft, dirRight, dirThirdPlanUp);


  TKeyMapEntry = record
    specialKey: boolean;
    key: Word;
  end;


  TArrayOfKeyMapEntry = array of TKeyMapEntry;

  { TControlConfig }
  TControlConfig = class
    private
      function testKeyMatch(const options: TArrayOfKeyMapEntry;
        const specialKey: boolean; const Key: Word): boolean;
    public
      FKUpOptions: TArrayOfKeyMapEntry;
      FKDownOptions: TArrayOfKeyMapEntry;
      FKLeftOptions: TArrayOfKeyMapEntry;
      FKRightOptions: TArrayOfKeyMapEntry;
      FKThirdPlanUpOptions: TArrayOfKeyMapEntry;

      function decodeDirectionByKey(const specialKey: boolean;
        const Key: Word): TDirection;

      constructor Create;
  end;


implementation

{ TControlConfig }

function TControlConfig.testKeyMatch(const options: TArrayOfKeyMapEntry;
  const specialKey: boolean; const Key: Word): boolean;
var
  i: integer;
begin
  for i := Low(options) to High(options) do
  begin
    if (options[i].specialKey = specialKey) and (options[i].key = Key) then
       exit(true);
  end;

  exit(false);

end;

function TControlConfig.decodeDirectionByKey(const specialKey: boolean;
    const Key: Word): TDirection;
begin
  result := dirNone;

  if testKeyMatch(FKUpOptions, specialKey, Key) then
     exit(dirUp);

  if testKeyMatch(FKDownOptions, specialKey, Key) then
     exit(dirDown);

  if testKeyMatch(FKLeftOptions, specialKey, Key) then
     exit(dirLeft);

  if testKeyMatch(FKRightOptions, specialKey, Key) then
     exit(dirRight);
  if testKeyMatch(FKThirdPlanUpOptions, specialKey, Key) then
     exit(dirThirdPlanUp);

end;

constructor TControlConfig.Create;
begin
  SetLength(FKUpOptions, 1);
  SetLength(FKDownOptions, 1);
  SetLength(FKLeftOptions, 1);
  SetLength(FKRightOptions, 1);
  SetLength(FKThirdPlanUpOptions, 1);

  //use direction keys of keyboartd
  FKUpOptions[0].specialKey := true;
  FKUpOptions[0].key := 38;

  FKDownOptions[0].specialKey := true;
  FKDownOptions[0].key := 40;

  FKLeftOptions[0].specialKey := true;
  FKLeftOptions[0].key := 37;

  FKRightOptions[0].specialKey := true;
  FKRightOptions[0].key := 39;

  FKThirdPlanUpOptions[0].specialKey := true;
  FKThirdPlanUpOptions[0].key := VK_Z;


end;


end.


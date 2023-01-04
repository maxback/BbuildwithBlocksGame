program arrayExample;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes
  { you can add units after this };
{
const
  house: array[0..19, 0..13] of integer = (
    (-1,1,2,2,2,2,2,2,2,2,2,2,1,-1),
    (-1,1,1,1,1,1,1,3,3,3,1,1,1,-1),
    (-1,1,1,1,1,1,1,3,3,3,1,1,1,-1),
    (-1,1,1,1,1,1,1,3,3,3,1,1,1,-1),
    (-1,1,1,1,1,1,1,3,3,3,1,1,1,-1),
    (-1,1,1,1,1,1,1,3,3,3,1,1,1,-1),
    (-1,1,1,1,1,1,1,3,3,3,1,1,1,-1),
    (-1,1,0,0,0,0,1,3,3,3,1,1,1,-1),
    (-1,1,0,0,0,0,1,3,3,3,1,1,1,-1),
    (-1,1,0,0,0,0,1,3,3,3,1,1,1,-1),
    (-1,1,0,0,0,0,1,3,3,3,1,1,1,-1),
    (-1,1,0,0,0,0,1,3,3,3,1,1,1,-1),
    (-1,1,1,1,1,1,1,1,1,1,1,1,1,-1),
    (5,5,5,5,5,5,5,5,5,5,5,5,5,5),
    (-1,5,5,5,5,5,5,5,5,5,5,5,5,-1),
    (-1,-1,5,5,5,5,5,5,5,5,5,5,-1,-1),
    (-1,-1,-1,5,5,5,5,5,5,5,5,-1,-1,-1),
    (-1,-1,-1,-1,5,5,5,5,5,5,-1,-1,-1,-1),
    (-1,-1,-1,-1,-1,5,5,5,5,-1,-1,-1,-1,-1),
    (-1,-1,-1,-1,-1,-1,5,5,-1,-1,-1,-1,-1,-1)
   );

var
  line, column: integer;
begin
  for line := 0 to 19 do
    begin
      for column := 0 to 13 do
        if house[line,column] = -1 then
          Write(' ')
        else
          Write(house[line,column]);
      WriteLn;
    end;

  ReadLn;
}


const
  C_LINES = 20;
  C_ROWS  = 14;
type
  TIntArrayArray = array[1..C_LINES-1] of array[0..C_ROWS-1] of integer;
  PIntArrayArray = ^TIntArrayArray;

procedure setAll(const lines, rows: integer; a: PIntArrayArray; b: array of integer);
var
  i, line, column: Integer;
  house: TIntArrayArray;
begin
  i := 0;
  for line := 0 to lines - 1 do
  begin
      for column := 0 to rows - 1 do
        house[line][column] := b[i];
      i := i + 1;
  end;
end;



var
  house: TIntArrayArray;
  id, line, column: integer;
  x0, x, y, z: integer;

begin
  setAll(C_LINES, C_ROWS, @house,
    [-1,1,2,2,2,2,2,2,2,2,2,2,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,1,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,1,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,1,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,1,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,1,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,1,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,1,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,1,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,1,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,1,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,1,1,-1,
    -1,1,1,1,1,1,1,1,1,1,1,1,1,-1,
    5,5,5,5,5,5,5,5,5,5,5,5,5,5,
    -1,5,5,5,5,5,5,5,5,5,5,5,5,-1,
    -1,-1,5,5,5,5,5,5,5,5,5,5,-1,-1,
    -1,-1,-1,5,5,5,5,5,5,5,5,-1,-1,-1,
    -1,-1,-1,-1,5,5,5,5,5,5,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,5,5,5,5,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,5,5,-1,-1,-1,-1,-1,-1]);

   {
  id := born;

  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');

  x0 := x;

  for line := 0 to C_LINES - 1 do
    begin

      for column := 0 to C_ROWS - 1 do
      begin
        if house[line,column] <> -1 then
          put(id, house[line,column]);
        x := x + 1;
        move(id, x, y, z);
        sleep(1);
      end;

      sleep(1);

      y := y = 1;
      move(id, x0, y, z);
    end;
}
end.

end.


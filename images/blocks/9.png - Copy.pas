program j;

const
  C_LINES = 16;
  C_ROWS  = 14;

type
  TIntArrayRows = array[0..C_ROWS-1] of integer;
  TIntArrayArray = array[0..C_LINES-1] of TIntArrayRows;

procedure setAll(id: integer; var a: TIntArrayArray; b: array of integer);
var
  i, line, column: Integer;
  arrRow: TIntArrayRows;
begin
  i := 0;
  for line := low(a) to high(a) do
  begin
      arrRow := a[line];
      for column := low(arrRow) to high(arrRow) do
	  begin
	     log(id, 'setall -> line ' + IntToStr(line) + ', columns ' + IntToStr(column) + ' with value: ' + IntToStr(b[i]));
        arrRow[column] := b[i];
        i := i + 1;
	  end;	
	  a[line] := arrRow;
  end;
end;      



var
  house: TIntArrayArray;
  id, line, column: integer;
  x0, x, y0, y, z0, z: integer;
  
begin
  id := born;

  setAll(id, house, 
    [-1,1,1,1,1,1,1,3,3,3,1,1,1,-1,
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
	
  
  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');
  
  log(id, 'Hello!! A born today!! at x: ' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z));

  x0 := x;
  y0 := y;
  z0 := z;

  for line := 0 to C_LINES - 1 do
	begin
	  //log(id, 'Work at line : ' + IntToStr(line) + ', column : ' + IntToStr(column));
	  for column := 0 to C_ROWS - 1 do
	  begin 
		
		if house[line][column] <> -1 then
		begin
          log(id, 'Putting block ' + IntToStr(house[line][column]) + ' at line : ' + IntToStr(line) + ', column : ' + IntToStr(column));
		  putBlock(id, house[line][column]);
		end;  
		x := x + 1;
		move(id, x, y, z);
	  end;

	  sleep(id, 200);

	  y := y + 1;
	  x := x0;
	  move(id, x, y, z);
	end;

    move(id, x0, y0, z0);
	log(id, '*** I am Done! My presure!!');

end.

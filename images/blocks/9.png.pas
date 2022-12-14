program j;

const
  C_COLUMNS = 13;
  C_ROWS  = 12;

type
  TIntArrayRows = array[0..C_ROWS-1] of integer;
  TIntArrayArray = array[0..C_COLUMNS-1] of TIntArrayRows;

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
  houseFront: TIntArrayArray;
  houseBack: TIntArrayArray;
  houseSide: TIntArrayArray;
  id, line, column, layer: integer;
  x0, x, y0, y, z0, z: integer;
  
begin
  id := born;

 
  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');
  
  log(id, 'Hello!! A born today!! at x: ' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z));

  setAll(id, houseBack, 
    [-1,1,1,1,1,1,1,1,1,1,1,-1,
    -1,1,1,1,1,1,1,1,1,1,1,-1,
    -1,1,1,1,1,1,1,1,1,1,1,-1,
    -1,1,1,1,1,1,1,1,1,1,1,-1,
    -1,1,0,0,1,1,1,1,0,0,1,-1,
    -1,1,0,0,1,1,1,1,0,0,1,-1,
    -1,1,1,1,1,1,1,1,1,1,1,-1,
    5,5,5,5,5,5,5,5,5,5,5,5,
    -1,5,5,5,5,5,5,5,5,5,5,-1,
    -1,-1,5,5,5,5,5,5,5,5,-1,-1,
    -1,-1,-1,5,5,5,5,5,5,-1,-1,-1,
    -1,-1,-1,-1,5,5,5,5,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,5,5,-1,-1,-1,-1,-1]);
	
  setAll(id, houseSide, 
    [-1,1,-1,-1,-1,-1,-1,-1,-1,-1,1,-1,
    -1,1,-1,-1,-1,-1,-1,-1,-1,-1,1,-1,
    -1,1,-1,-1,-1,-1,-1,-1,-1,-1,1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,1,-1,-1,-1,-1,-1,-1,-1,-1,1,-1,
    -1,1,1,1,1,1,1,1,1,1,1,-1,
    5,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,5,
    -1,5,-1,-1,-1,-1,-1,-1,-1,-1,5,-1,
    -1,-1,5,-1,-1,-1,-1,-1,-1,5,-1,-1,
    -1,-1,-1,5,-1,-1,-1,-1,5,1,-1,-1,
    -1,-1,-1,-1,5,-1,-1,5,-1,1,-1,-1,
    -1,-1,-1,-1,-1,5,5,-1,-1,-1,-1,-1]);
  
  setAll(id, houseFront, 
    [-1,1,1,1,1,1,1,3,3,3,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,-1,
    -1,1,1,1,1,1,1,3,3,3,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,-1,
    -1,1,0,0,0,0,1,3,3,3,1,-1,
    -1,1,1,1,1,1,1,1,1,1,1,-1,
    5,5,5,5,5,5,5,5,5,5,5,5,
    -1,5,5,5,5,5,5,5,5,5,5,-1,
    -1,-1,5,5,5,5,5,5,5,5,-1,-1,
    -1,-1,-1,5,5,5,5,5,5,-1,-1,-1,
    -1,-1,-1,-1,5,5,5,5,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,5,5,-1,-1,-1,-1,-1]);


  x0 := x;
  y0 := y;
  z0 := z;

  for layer := 0 to 5 do
  begin
    case layer of
      0: house := houseBack;
	  5: house := houseFront;
      else
        house := houseSide;
	  end;	

      move(id, x0, y0, z0 + layer);
	  
	  x := x0;
	  y := y0;
	  z := z0 + layer;
		
	  for line := 0 to C_COLUMNS - 1 do
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

		  sleep(id, 20);

		  y := y + 1;
		  x := x0;
		  move(id, x, y, z);
		end;
   end;
    move(id, x0, y0, z0);
	pickBlock(id);
    move(id, x0, y0, z0);

	log(id, '*** I am Done! My presure!!');

end.

program l;

const
  C_COUNT = 100;




var
  i, id, x0, x, y0, y, z0, z, blockid, anotherBlockId: integer;
  xb, yb, zb: integer;
begin
  id := born;
  
  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');
  blockid := read(id, 'blockid');
  
  x0 := x;
  y0 := y;
  z0 := z;
  
  log(id, 'Hello!! A born today and a will fall while not have a black!! Init at x: ' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z));

  
  for i := 0 to C_COUNT - 1 do
	begin
	
      if y = 0 then
	    break;
	  y := y - 1;
	  
      anotherBlockId := readBlock(id, x, y, z);
	  log(id, 'After less my y by 1 (y: ' + IntToStr(y) + ') the id of the block in this place(' +
	    + IntToStr(x) + ',' + IntToStr(y) + ',' + IntToStr(z) + ') is: ' + IntToStr(anotherBlockId)); 
	  if anotherBlockId < 0 then
	  begin
        move(id, x, y + 1, z);
	    pickBlock(id);
		
		sleep(id, 5);
		
        move(id, x, y, z);
        putBlock(id, blockid);
		
		move(id, x0, y0, z0);
	  end
	  else
	    break;
	end;

    move(id, x0, y0, z0); 
	log(id, '*** I am Done! My presure!!');

end.

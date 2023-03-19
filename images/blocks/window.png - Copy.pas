program window;

const
  C_MAX_X = 7;
  C_MAX_Y = 7;

var
  maxX, maxY, i, id, x0, x, y0, y, z0, blockid: integer;
begin
  id := born;
  
  x0 := read(id, 'x');
  y0 := read(id, 'y');
  z0 := read(id, 'z');
  blockid := read(id, 'blockid');
  
  log(id, 'Hello Thomas!! A window will be maked!! at x: ' + IntToStr(x0) + ', y: ' + IntToStr(y0) + ', z: ' + IntToStr(z0));

  maxX := C_MAX_X;
  for x := 1 to C_MAX_X do
  begin
    log(id, 'testing maxX in x:' + IntToStr(x0 + x) + ', y: ' + IntToStr(y0) + ', z: ' + IntToStr(z0));
    if readBlock(id, x0 + x, y0, z0) <> -1 then
	begin
      maxX := x0 + x - 1;
      break;	  
	end;
  end;	
	
  maxY := C_MAX_Y;
  for y := 1 to C_MAX_Y do
  begin
    log(id, 'testing maxY in x:' + IntToStr(x0) + ', y: ' + IntToStr(y0 + y) + ', z: ' + IntToStr(z0));
    if readBlock(id, x0, y0 + y, z0) <> -1 then
	begin
      maxY := y0 + y - 1;
      break;	  
	end;
  end;	
  
  log(id, 'maxX = ' + IntToStr(maxX) + ', maxY = ' + IntToStr(maxY));
  
	for x := x0 to maxX do
	begin
	  for y := y0 to maxY do
	  begin
		log(id, 'testing in x:' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z0));
		
		if readBlock(id, x, y, z0) = -1 then
		begin
		  log(id, 'found!!!');
		  move(id, x, y, z0); 
		  putBlock(id, blockid);
		end;
	  end;
	end;	  
	
	move(id, x0, y0, z0); 

	log(id, '*** I am Done! Happy to help!!');

end.

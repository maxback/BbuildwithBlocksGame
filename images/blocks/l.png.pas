program l;

var
  i, id, x0, x, y0, y, z0, blockid: integer;
  
begin
  id := born;
  
  x0 := read(id, 'x');
  y0 := read(id, 'y');
  z0 := read(id, 'z');
  blockid := read(id, 'blockid');
  
  log(id, 'Hello Thomas!! A fence will be maked!! at x: ' + IntToStr(x0) + ', y: ' + IntToStr(y0) + ', z: ' + IntToStr(z0));


    for x := 1 to 100 do
  	  begin
	    move(id, x0 + x, y0, z0); 
		log(id, 'testing in ' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z)));
	    if readBlock(id) = -1 then
        begin
		  putBlock(id, blockid);
		end
        else
		  break;
		
	  end;

	log(id, '*** I am Done! Happy to help!!');

end.

program l;

const
  C_COUNT = 5;

var
  i, id, x, y, z, blockid: integer;
  
begin
  id := born;
  
  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');
  blockid := read(id, 'blockid');
  
  log(id, 'Hello Thomas!! A born today!! at x: ' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z));


  for i := 0 to C_COUNT - 1 do
	begin
      putBlock(id, blockid);
	  x := x + 1;
      move(id, x, y, z);
	end;

	log(id, '*** I am Done! My presure!!');

end.

program fornuce;

const
  C_ACT_RADIO = 1;

var
  x0, y0, z0, blockid: integer;
  
  
  procedure handle_message(const msg: string; iparam0, iparam1, iparam2: integer; sparam: string);
  begin
    //
  end;
  
begin
  id := born;
  
  x0 := read(id, 'x');
  y0 := read(id, 'y');
  z0 := read(id, 'z');
  blockid := read(id, 'blockid');
  
  log(id, 'Hello Daniel!! This is a fornuce. If you put a block beside of me it is burn. I am at x: ' + IntToStr(x0) + ', y: ' + IntToStr(y0) + ', z: ' + IntToStr(z0));


  event(blockid, 'onNewBlock', 
    'xmin='+IntToStr(x0 - C_ACT_RADIO) + #13#10 +
    'xmax='+IntToStr(x0 + C_ACT_RADIO) + #13#10 +
    'ymin='+IntToStr(y0 - C_ACT_RADIO) + #13#10 +
    'ymax='+IntToStr(y0 + C_ACT_RADIO) + #13#10 +
    'zmin='+IntToStr(z0 + C_ACT_RADIO) + #13#10 +
    'zmax='+IntToStr(z0 + C_ACT_RADIO) + #13#10);
	

end.

program fornuce;

const
  C_ACT_RADIO = 1;
  C_MAX_BUNR_TIMES = 20;

var
  id, x, x0, xmin, xmax, y, y0, ymin, ymax, z, z0, zmin, zmax, eventId: integer;
  iburnTimesRemain, iparam0, iparam1, iparam2, iparam3, idtype0, idtype: integer;
  eparam, msg, sparam: string;


  procedure HandleMessage(const id: integer; const msg: string; iparam0, iparam1, iparam2, iparam3: integer; sparam: string);
  begin
    log(id, 'Message received: ' + msg + ' -> at ' +
      'x: ' + IntToStr(iparam1) + ', y: ' + IntToStr(iparam2) + ', z: ' + IntToStr(iparam3) + '...');

    if msg = 'enter_fence' then
    begin
      if (iparam1 = x0) and (iparam2 = y0) and (iparam3 = z0) then
        exit;

      idtype := readBlock(id, x, y, z);

      if idtype = idtype0 then
        exit;

      if iburnTimesRemain <= 0 then
        exit;

      iburnTimesRemain := iburnTimesRemain - 1;

      log(id, ' *** Burn block at ' +
        'x: ' + IntToStr(iparam1) + ', y: ' + IntToStr(iparam2) + ', z: ' + IntToStr(iparam3) + '...');
      move(id,iparam1, iparam2, iparam3);
      pickBlock(id);

    end;
  end;







begin
  id := born;
  
  x0 := read(id, 'x');
  y0 := read(id, 'y');
  z0 := read(id, 'z');

  idtype0 := readBlock(id, x0, y0, z0);

  iburnTimesRemain := C_MAX_BUNR_TIMES;

  log(id, 'Hello Daniel!! This is a fornuce(idtype0 = ' + IntToStr(idtype0) + '). If you put a block beside of me it will burn. I am at x: ' + IntToStr(x0) + ', y: ' + IntToStr(y0) + ', z: ' + IntToStr(z0));

  xmin := x0 - C_ACT_RADIO;
  xmax := x0 + C_ACT_RADIO;
  ymin := y0;
  ymax := y0 + C_ACT_RADIO;
  zmin := z0;
  zmax := z0 + C_ACT_RADIO;



  //simulate fences alarms on init behide a block
  for x := xmin to xmax do
    for y := ymin to ymax do
      for z := zmin to zmax do
      begin
        idtype := readBlock(id, x, y, z);
        log(id, 'Test return idtype = ' + IntToStr(idtype) + ' at x: ' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z));

        if (x <> x0) and (y <> y0) and (z <> z0) and (idtype = idtype0) then
        begin
          if (y = y0) and (x <> x0) then
          begin
            xmin := xmin - 2;
            xmax := xmax + 2;
            log(id, 'Another fornuce detected, maximizing radio of burn action to x = x +- 2');
          end
          else if (x = x0) and (y <> y0) then
          begin
            xmin := xmin - 2;
            xmax := xmax + 2;
            log(id, 'Another fornuce detected, maximizing radio of burn action to y = y +- 2');
          end;

        end
        else
        if (idtype >= 0) and (idtype <> idtype0) then
        begin
          log(id, 'fence detected to bun by block ALGORITM');
          HandleMessage(id, 'enter_fence', 0, x, y, z, '');
        end;
      end;

  eparam := 'xmin=' + IntToStr(xmin) + #13#10;
  eparam := eparam + 'xmax=' + IntToStr(xmax) + #13#10;
  eparam := eparam + 'ymin=' + IntToStr(ymin) + #13#10;
  eparam := eparam + 'ymax=' + IntToStr(ymax) + #13#10;
  eparam := eparam + 'zmin=' + IntToStr(zmin) + #13#10;
  eparam := eparam + 'zmax=' + IntToStr(zmax);

  eventId := RegisterEvent(id, 'onEnterFence', eparam);
  log(id, 'event onEnterFence register => ' + eparam);
  eventId := RegisterEvent(id, 'onKill', '');

  while true do
  begin
    if CheckMessage(id, msg, iparam0, iparam1, iparam2, iparam3, sparam) then
    begin
      if msg = 'kill' then
        break
      else
        HandleMessage(id, msg, iparam0, iparam1, iparam2, iparam3, sparam);
    end
    else
      sleep(id, 2000);

  end;

  log(id, 'By Daniel and thaks for the fishes. I am at x: ' + IntToStr(x0) + ', y: ' + IntToStr(y0) + ', z: ' + IntToStr(z0));


end.

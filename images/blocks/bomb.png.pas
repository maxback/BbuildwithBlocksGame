program bomb;

 
//this uses and dummy functions emulate the engile 
//Comment in real engine env.
{Uses sysutils;

function born: integer; begin WriteLn('born!'); exit(0); end;
procedure log(const blockId: integer; const msg: string); begin WriteLn(msg); end;
function read(const blockId: integer; const prop: string): integer; begin WriteLn('read ', prop); exit(0); end;
procedure sleep(const blockId: integer; const time: integer); begin WriteLn('sleep ', time); end;
procedure move(const blockId: integer; const x, y, z: integer); begin WriteLn('move ', x, ',', y, ',', z); end;
function readBlock(const blockId: integer; const x, y, z: integer): integer; begin WriteLn('read block return 2', x, ',', y, ',', z); exit(2); end;
procedure putBlock(const blockId: integer; const blockIndex: integer); begin WriteLn('put block ', blockIndex); end;
procedure pickBlock(const blockId: integer); begin; WriteLn('pick block'); end;
procedure moveBlock(const blockId: integer; const x, y, z: integer; const efect: string); begin WriteLn('move block to ', x, ',', y, ',', z, ' with the efect [', efect, ']'); end;
procedure soundBlock(const blockId: integer; const n: integer); begin WriteLn('sound block with n = ', n); end;
}//end of dummy  

const
  C_MIN_COUNT = 3;
  C_MAX_COUNT = 7;
  C_MIN_RADIO = 2;
  C_MAX_RADIO = 4;

  C_SOUND = 0;


var
  i, r, id, cx, x, cy, y, cz, z, blockid: integer;
  count, radio: integer;
begin
  id := born;
  
  Randomize;
  
  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');

  cx := x;
  cy := y;
  cz := z;
  
  log(id, 'Hello!! I am a bomb and... Tic Tac...');

  count := C_MIN_COUNT + Random(C_MAX_COUNT - C_MIN_COUNT + 1);

  for i := 0 to count - 1 do
	begin
	  if (i mod 2) = 0 then
	    log(id, 'tic')
	  else
	    log(id, 'TAC!');
	
	  case i mod 6 of
    	  0:  moveBlock(id, x - 1, y, z, 'jump');
    	  1:  moveBlock(id, x + 1, y, z, 'jump');
    	  2:  moveBlock(id, x, y - 1, z, 'jump');
    	  3:  moveBlock(id, x, y + 1, z, 'jump');
    	  4:  moveBlock(id, x, y, z - 1, 'jump');
    	  5:  moveBlock(id, x, y, z + 1, 'jump');
	  end;

      //if not the last...
      if i <> (count - 1) then
      begin
        sleep(id, 100);
      end;
	end;
    
    log(id, 'BOOOOOOMM!');
    soundBlock(id, C_SOUND);

    radio := C_MIN_RADIO + Random(C_MAX_RADIO - C_MIN_RADIO + 1);
    
    for r := C_MIN_RADIO to radio do
    begin
      for x := cx to (cx + r) do
        for y := cy to (cy + r) do
          for z := cz to (cz + r) do
		  begin
              //if Random(2) = 0 Then
                //begin
                  move(id, x, y, z);
                  pickBlock(id);
            //end;  
		  end;		
    end;
    soundBlock(id, C_SOUND);
	sleep(id,1000);
    
	log(id, '*** I am Done! Happy to explode some blocks!!');

end.
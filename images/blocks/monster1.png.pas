program monster1;

 
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

  C_SOUND = 0;

function haveBlock(id, x, y, z: integer): boolean;
var
  blockId: integer;
begin
  blockId := readBlock(id, x, y, z);
    Result := blockId >= 0;  
end;

function haveEspecificBlock(id, x, y, z, testBlock: integer): boolean;
var
  blockId: integer;
begin
  blockId := readBlock(id, x, y, z);
  Result := blockId = testBlock
end;


var
  i, r, id, cx, x, cy, y, cz, z, blockid: integer;
  count, radio: integer;
  decide: boolean;
  direction: integer;
  maxSteps: integer;
begin
  id := born;
  
  Randomize;
  
  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');

  cx := x;
  cy := y;
  cz := z;
  
  log(id, 'Hello!! I am a moster (1)...');

  maxSteps := 40;
  decide := true;
  while true do
  begin
	  
	if decide then
	begin
		decide := false;
		direction := Random(4);
		maxSteps := Random(10);
	end;

	case direction of
		0:  //esquerda
		  if not haveBlock(id, cx - 1, cy, cz) then 
		  begin
		    log(id, 'moving to left');  
			
			cx := cx - 1; 
			moveBlock(id, cx, cy, cz, 'jump'); 
			Dec(maxSteps); 
		  end else begin 
		    log(id, 'obstacle at left');
		    decide := true; 
		  end;
		1:  //direita
		  if not haveBlock(id, cx + 1, cy, cz) then 
		  begin 
		    log(id, 'moving to Right'); 
			
			cx := cx + 1; 
			moveBlock(id, cx, cy, cz, 'jump'); 
			Dec(maxSteps);  
		  end else begin 
		    log(id, 'obstacle at RIGNT');
		    decide := true; 
		  end;
		2: // baixo  
		  if not haveBlock(id, cx, cy - 1, cz) then 
		  begin 
		    log(id, 'moving to down');  
			
			cy := cy - 1; 
			moveBlock(id, cx, cy, cz, 'jump'); 
			Dec(maxSteps);  
		  end else begin 
		    log(id, 'obstacle at down');
		  
		    decide := true; 
		  end;
		3: //cima  
		  if not haveBlock(id, cx, cy + 1, cz) then 
		  begin 
		    log(id, 'moving to up');    
			
			cy := cy + 1; 
			moveBlock(id, cx, cy, cz, 'jump'); 
			Dec(maxSteps);  
		  end else begin 
 		    log(id, 'obstacle at up');

		    decide := true; 
		  end;
	end;
	
	if maxSteps <= 0 then
	  decide := true;

	if decide then
		sleep(id, 20)
	else
		sleep(id, 1000);
  end;  
end.
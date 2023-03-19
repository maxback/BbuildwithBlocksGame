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

  while true do
  begin
	  
	  case Random(3) of
    	  0:  if not haveBlock(id, cx - 1, cy, cz) then begin log(id, 'moving to left');  cx := cx - 1; moveBlock(id, cx, cy, cz, 'jump'); end;
    	  1:  if not haveBlock(id, cx + 1, cy, cz) then begin log(id, 'moving to Right'); cx := cx + 1; moveBlock(id, cx, cy, cz, 'jump'); end;
    	  2:  if not haveBlock(id, cx, cy - 1, cz) then begin log(id, 'moving to down');  cy := cy - 1; moveBlock(id, cx, cy, cz, 'jump'); end;
    	  3:  if not haveBlock(id, cx, cy + 1, cz) then begin log(id, 'moving to up');    cy := cy - 1; moveBlock(id, cx, cy, cz, 'jump'); end;
	  end;
	
        sleep(id, 1000);
  end;  
end.
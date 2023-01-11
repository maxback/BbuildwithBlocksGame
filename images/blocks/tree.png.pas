program tree;

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
}//end of dummy

const
  C_MIN_H = 5;
  C_MAX_H = 10;
  C_MIN_LC = 3;
  C_MAX_LC = 5;
  
  C_SOIL = 2;
  C_WOOD = 3;
  C_LEAF = 6;
  
  C_NOT_FOUND = -1;

function haveSoil(id, x, y, z: integer): boolean;
var
  blockId: integer;
begin
  blockId := readBlock(id, x, y, z);
  Result := blockId = C_SOIL;
end;



var
  i, id, cx0, x0, x, cy0, y0, y, cz0, z0, z, blockid: integer;
  h, maxH, leafCubeSide: integer;
begin
  Randomize;
  
  id := born;
  
  x := read(id, 'x');
  y := read(id, 'y');
  z := read(id, 'z');
  blockid := read(id, 'blockid');
  
  //Teste if have soil on coordinate or one of adjacent blocks
  if (haveSoil(id, x, y, z) or haveSoil(id, x - 1, y, z) or haveSoil(id, x + 1, y, z) or
    haveSoil(id, x, y - 1, z) or haveSoil(id, x - 1, y - 1, z) or haveSoil(id, x + 1, y - 1, z)) then
  begin
  
      maxH := C_MIN_H + Random(C_MAX_H - C_MIN_H + 1);
      leafCubeSide := C_MIN_LC + Random(C_MAX_LC - C_MIN_LC + 1); 
    
      log(id, 'Hello!! I am a random tree with height ' + IntToStr(maxH) 
        + ' and leaf Cube Side ' + IntToStr(leafCubeSide) 
        + '!! at x: ' + IntToStr(x) + ', y: ' + IntToStr(y) + ', z: ' + IntToStr(z));
    
      for i := 0 to maxH - 1 do
	    if readBlock(id, x, y + i, z) = C_NOT_FOUND then
        begin
          move(id, x, y + i, z);
		
          putBlock(id, C_WOOD);
        end;
    
      cx0 := x - (leafCubeSide div 2);
      cy0 := y + maxH - (leafCubeSide div 2);
      cz0 := z - (leafCubeSide div 2);
    
      
      for x := cx0 to (cx0 + leafCubeSide - 1) do
        for y := cy0 to (cy0 + leafCubeSide - 1) do
          for z := cz0 to (cz0 + leafCubeSide - 1) do
            if (Random(2) = 0) and (readBlock(id, x, y, z) = C_NOT_FOUND) Then
            begin
              log(id, 'NEW leafs BLOCK in (' + IntToStr(x) + ',' + IntToStr(y) + ',' + IntToStr(z) + ')');
              move(id, x, y, z);
              putBlock(id, C_LEAF);
            end
            else
              log(id, 'NO leafs in (' + IntToStr(x) + ',' + IntToStr(y) + ',' + IntToStr(z) + ')');
    
      move(id, x0 + leafCubeSide , y0, z0);
    
      log(id, '*** I am Done! Happy to help!!');
  
  
  end
  else
  begin
	move(id, x0 + 1, y0, z0);
    pickBlock(id);
    log(id, '*** I need soil to grow! Select a good soil for me next time! Happy to help!!');
  end;
  

end.
unit mouse;

interface

Procedure Putmouse(x,y:integer);
Procedure MouseRange(xmin,ymin,xmax,ymax:integer);
Procedure GetPosBut(var x,y,butval:integer);
Procedure Cursor(status:boolean);
Procedure HideMouse;
Procedure ShowMouse;
Procedure InitMouse;
function Mouse_Driver_Installed:boolean;

implementation

Uses dos;

Procedure Putmouse(x,y:integer);
begin
     asm
        mov ax,04
        mov cx,x
        mov dx,y
        int $33
     end;
end;

function Mouse_Driver_Installed:boolean;
var
   regs:registers;
   mofs:integer;
   mseg:integer;
   mhandler:byte;

begin
     regs.ax:=$3533;
     Intr($21,regs);
     mseg:=regs.es;
     mofs:=regs.bx;
     mhandler:=mem[mseg:mofs];
     Mouse_driver_installed:=(mseg<>0) and (mhandler<>$cf);
end;

Procedure MouseRange(xmin,ymin,xmax,ymax:integer);
begin
     asm
        mov ax,07
        mov cx,xmin
        mov dx,xmax
        int $33
        mov ax,08
        mov cx,ymin
        mov dx,ymax
        int $33
     end;
end;

Procedure GetPosBut(var x,y,butval:integer);
var i,j,b:integer;
begin
     asm
        mov ax,03
        int $33
        mov i,cx
        mov j,dx
        mov b,bx
     end;
     x:=i;
     y:=j;
     butval:=b;
end;

Procedure Cursor(status:boolean);
var
   x:integer;
begin
     if status=False then
     begin
          asm
             mov ah,1
             mov ch,$20
             int $10
          end;
     end
     else
     begin
          asm
             mov ah,$0f
             int $10
             mov x,ax
          end;
          if x=7 then
          begin
               asm
                  mov ch,11
                  mov cl,12
               end;
          end
          else
          begin
               asm
                  mov ch,06
                  mov cl,07
               end;
          end;
          asm
             mov ah,01
             int $10
          end;
     end;
end;

Procedure HideMouse;
begin
     asm
        mov ax,02
        int $33
     end;
end;

Procedure ShowMouse;
begin
     asm
        mov ax,01
        int $33
     end;
end;

Procedure InitMouse;
begin
     asm
        mov ax,00
        int $33
     end;
end;

end.
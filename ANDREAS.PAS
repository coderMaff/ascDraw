{$O+,F+}
unit Andreas;

interface
procedure hide_cursor;
Procedure Intxy(a,b,c:integer);
Procedure Reverse(var Word:string);
Procedure SlowWrite(A,B:integer;Word:string);
Procedure TeleType(A,B,C,D:integer;Word:string);
Procedure BlankScreen;
Procedure DrawTopBar(A,B,C:integer;Title:string);
Procedure DrawBottomBar(a:integer;Title:string);
Procedure DrawScreen(A,B,C,D,E:integer;Title:string;F,G:integer;Btitle:string);
Procedure Writexy(a,b:Integer;w:String);
procedure realxy(a,b:integer;w:real);
Procedure Charxy(a,b:Integer;w:Char);
Procedure reset_cursor;
Procedure Blip;
Procedure DrawWindow(A:integer);
Procedure Readchar(a,b,c,d,e,f:Integer);
Procedure SingleBox(a,b,c,d,e,f:Integer);
Procedure DoubleBox(a,b,c,d,e,f:Integer);
Function DeCoder(a:string):string;
Function Coder(a:string):string;
function change(w:word):string;
Function Getnum(x1,y:integer):Integer;
Function GDate(x,y:integer):string;
Function Date_Correct(Date:string):Boolean;
Function Getreal(x1,y:integer):real;
function UpString(S: string): string;
function date:string;
function DownString(S: string): string;
Function DownCase(S: char): char;
Function Edit_real(x,y:integer;num:real):real;
Function Getword(l:integer):string;
Function RepWord(l:integer;w:string):string;
Function Sure:Boolean;
Function Screenchar:Char;
function FileExists(FileName: String): Boolean;
Function Edit_word(x,y,l:integer;st:string):string;
Function menu(var pos:integer;maxpos:integer;ch:char):char;
implementation

uses dos,crt;
var
   f:text;

procedure hide_cursor;
var
   regs:registers;

begin
     regs.ah:=1;
     regs.ch:=$20;
     intr($10,regs);
end;

Procedure reset_cursor;
var
   regs:registers;

begin
     regs.ah:=$0f;
     intr($10,regs);
     if regs.al=07 then
        begin
                regs.ch:=11;
                regs.cl:=12;
        end
     else
        begin
                regs.ch:=6;
                regs.cl:=7;
        end;
     regs.ah:=1;
     intr($10,regs);
end;

Procedure DrawWindow(A:integer);
Var w,x,y,z:Integer;

Begin
     ClrScr;
     TextColor(A);
     TextBackground(A);
     w:=40;
     x:=13;
     y:=40;
     z:=13;
     Repeat
           Window(w,x,y,z);
           w:=w-1;
           If (w<1) Then w:=1;
           Delay(7);
           x:=x-1;
           If (x<1) Then x:=1;
           Delay(7);
           y:=y+1;
           If (y>81) Then y:=81;
           Delay(7);
           z:=z+1;
           If (z>25) Then z:=25;
           Delay(7);
           ClrScr;
      Until (w=1) And (x=1) And (y=81) And (z=25);
      Exit;
End;
Procedure Blip;
begin
     sound(600);
     delay(20);
     nosound;
end;

Procedure BlankScreen;
Begin
     Window(1,1,80,25);
     TextColor(7);
     TextBackground(5);
     ClrScr;
End;

procedure realxy(a,b:integer;w:real);
begin
     gotoxy(a,b);
     write(w:2:2);
end;

Procedure Writexy(a,b:Integer;w:String);
Begin
     Gotoxy(a,b);
     Write(w);
End;

Procedure Charxy(a,b:Integer;w:Char);
Begin
     Gotoxy(a,b);
     Write(w);
End;

Procedure Intxy(a,b,c:integer);
begin
     gotoxy(a,b);
     write(c);
end;

Procedure DrawTopBar(A,B,C:integer;Title:string);
Var dd,mm,yy,day:word;
    Tail : String;
    Month : String;
Begin
     GetDate(yy,mm,dd,day);
     Case DD Of
          1,21,31 : Tail := 'st';
          2,22 : Tail := 'nd';
          3,23 : Tail := 'rd';
          4..20,24..30 : Tail := 'th';
     End;
     Case MM Of
          1 : Month := 'January';
          2 : Month := 'February';
          3 : Month := 'March';
          4 : Month := 'April';
          5 : Month := 'May';
          6 : Month := 'June';
          7 : Month := 'July';
          8 : Month := 'August';
          9 : Month := 'September';
         10 : Month := 'October';
         11 : Month := 'November';
         12 : Month := 'December';
     End;

     Window(1,1,80,1);
     TextColor(A);
     TextBackground(B);
     ClrScr;
     Gotoxy(2,1);
     Write(dd,tail,' ',Month,' ',yy);
     Writexy(C,1,Title);
     Window(1,1,80,25);
End;

function change(w:word):string;
var
   s:string;
begin
     str(w:0,s);
     change:=s;
end;

function date:string;
Var dd,mm,yy,day:word;
    Tail : String;
    s,Month : String;
Begin
     GetDate(yy,mm,dd,day);
     Case DD Of
          1,21,31 : Tail := 'st';
          2,22 : Tail := 'nd';
          3,23 : Tail := 'rd';
          4..20,24..30 : Tail := 'th';
     End;
     Case MM Of
          1 : Month := 'January';
          2 : Month := 'February';
          3 : Month := 'March';
          4 : Month := 'April';
          5 : Month := 'May';
          6 : Month := 'June';
          7 : Month := 'July';
          8 : Month := 'August';
          9 : Month := 'September';
         10 : Month := 'October';
         11 : Month := 'November';
         12 : Month := 'December';
     End;

     date:=change(dd)+tail+' '+Month+' '+change(yy);
End;


Function Sure:Boolean;
var
   CHR:char;
begin
     writexy(30,2,'Are you sure (Y/N)?');
     CHR:=readkey;
     Blip;
     CHR:=Upcase(CHR);
     if CHR <>'Y' then
        begin
             Sure:=false;
        end
     else
         begin
              Sure:=true;
         end;
end;

Procedure DrawBottomBar(A:integer;Title:string);
Begin
     Window(1,25,80,25);
     TextColor(15);     TextBackground(1);
     writexy(1,1,'                                        ');
     writexy(41,1,'                                        ');
     writexy(A,1,Title);
End;

Function Screenchar:Char;
Var Regs:Registers;
Begin
     Regs.AH := 8;
     Regs.BH := 0;
     Intr($10,regs);
     Screenchar := Chr(Regs.AL);
End;

Procedure Readchar(a,b,c,d,e,f:Integer);
Var i : Integer;
Begin
     Window(1,1,80,25);
     TextColor(8);
     TextBackground(0);
     For i:=(a+1) To (c+1) Do Begin
         Gotoxy(i,d+1);
         Write(Screenchar);
     End;
     For i:=(b+1) To (d+1) Do Begin
         Gotoxy(c+1,i);
         Write(Screenchar);
     End;
     TextColor(e);
     TextBackground(f);
End;

Procedure SingleBox(a,b,c,d,e,f:Integer);
Var k:Integer;
Begin
     Window(a,b,c,d);
     TextBackground(f);
     TextColor(e);
     ClrScr;
     Window(a,b,c+1,d+1);
     Charxy(1,1,#218);
     Charxy((c+1-a),1,#191);
     Charxy(1,(d+1)-b,#192);
     Charxy((c+1)-a,(d+1)-b,#217);
     For k:=2 To c-a Do Begin
         Charxy(k,1,#196);
         Charxy(k,d-(b-1),#196);
     End;
     For k:=2 To d-b Do Begin
         Charxy(1,k,#179);
         Charxy(c-(a-1),k,#179);
     End;
     ReadChar(a,b,c,d,e,f);
     Window(a+1,b+1,c-1,d-1);
End;

Procedure DoubleBox(a,b,c,d,e,f:Integer);
Var k:Integer;
Begin
     Window(a,b,c,d);
     TextBackground(f);
     TextColor(e);
     ClrScr;
     Window(a,b,c+1,d+1);
     Charxy(1,1,#201);
     Charxy(((c+1)-a),1,#187);
     Charxy(1,(d+1)-b,#200);
     Charxy((c+1)-a,(d+1)-b,#188);
     For k:=2 To c-a Do Begin
         Charxy(k,1,#205);
         Charxy(k,d-(b-1),#205);
     End;
     For k:=2 To d-b Do Begin
         Charxy(1,k,#186);
         Charxy(c-(a-1),k,#186);
     End;
     ReadChar(a,b,c,d,e,f);
     Window(a+1,b+1,c-1,d-1);
End;
function FileExists(FileName: String): Boolean;
{ Boolean function that returns True if the file exists;otherwise,
 it returns False. Closes the file if it exists. }
var
 F: file;
begin
     {$I-}
     Assign(F, FileName);
     FileMode := 0;  { Set file access to read only }
     Reset(F);
     Close(F);
     {$I+}
     FileExists := (IOResult = 0) and (FileName <> '');
     FileMode:=2;
end;  { FileExists }

Function Getnum(x1,y:integer):Integer;
var
   word:string;
   minus,Done:Boolean;
   x,num:integer;
   Ch:CHAR;
begin
     word:='';
     minus:=false;
     Done:=False;
     gotoxy(x1,y);
     repeat
           ch:=readkey;
           ch:=upcase(ch);
           if ord(ch)=8 then
              begin
                   x:=length(Word);
                   if x>0 then
                      begin
                           if word[x]='-' then minus:=false;
                           delete(Word,x,1);
                           write(ch,' ',ch);
                      end;
              end;
           if (ord(ch)>47) and (ord(ch)<58) then
           begin
                write(ch);
                word:=word+ch;
           end;
           if (ch='-') and (minus=false) and (length(word)=0) then
           begin
                minus:=true;
                write(ch);
                word:=word+ch;
           end;
           if ord(ch)=13 then done:=true;
     until Done;
     val(word,num,x);
     getnum:=num;
end;

Function Getreal(x1,y:integer):real;
var
   word:string;
   fstop,Done:Boolean;
   x:integer;
   num:real;
   Ch:CHAR;
   c:char;
begin
     word:='';
     Done:=False;
     fstop:=false;
     gotoxy(x1,y);
     writeln('------');
     gotoxy(x1,y);
     repeat
           ch:=readkey;
           ch:=upcase(ch);
           if ord(ch)=8 then
              begin
                   x:=length(Word);
                   if x>0 then
                      begin
                           c:=word[x];
                           if c='.' then fstop:=false;
                           delete(Word,x,1);
                           write(ch,'-',ch);
                      end
                      else
                          blip;
              end;
           if ch='.' then
           begin
                if not(fstop=true) then
                begin
                     write(ch);
                     word:=word+ch;
                     fstop:=true;
                end;
           end;
           if (ord(ch)>47) and (ord(ch)<58) then
           begin
                x:=length(word);
                if x<6 then
                begin
                     write(ch);
                     word:=word+ch;
                end
                else
                    blip;
           end;
           if ord(ch)=13 then done:=true;
     until Done;
     val(word,num,x);
     getreal:=num;
end;

procedure Reverse(var Word:string);
var
   letter:string;
begin
     if length(word)>0 then
     begin
          letter:=copy(word,1,1);
          word:=copy(word,2,length(word)-1);
          reverse(word);
          word:=concat(word,letter);
     end;
end;

Function GDate(x,y:integer):string;
var
   word:string;
   ch:char;
   a,v,w,z:integer;
   done:boolean;
   count:integer;
begin
     word:='';
     gotoxy(x,y);
     write('--/--/--');
     repeat
           count:=0;
           word:='';
           gotoxy(x,y);
           write('--/--/--');
           gotoxy(x,y);
           done:=false;
           repeat
                 ch:=readkey;
                 if ord(ch)=8 then
                 begin
                      a:=length(word);
                      if a>0 then
                      if count=3 then
                      begin
                           delete(word,a,1);
                           write(ch,ch,'-',ch);
                           count:=count-2;
                      end
                      else
                      if count=6 then
                      begin
                           delete(word,a,1);
                           write(ch,ch,'-',ch);
                           count:=count-2;
                      end
                      else
                      begin
                           delete(word,a,1);
                           write(ch,'-',ch);
                           count:=count-1;
                      end;
                 end
                 else
                 if (ord(ch)>47) and (ord(ch)<58) then
                 begin
                      a:=length(word);
                      if a=6 then done:=true
                      else
                      if a=2 then
                      begin
                           write('/',ch);
                           word:=word+ch;
                           count:=count+2;
                      end
                      else
                      if a=4 then
                      begin
                           write('/',ch);
                           word:=word+ch;
                           count:=count+2;
                      end
                      else
                      begin
                           write(ch);
                           word:=word+ch;
                           count:=count+1;
                      end;
                 end
                 else
                 begin
                      a:=length(word);
                      if a=6 then done:=true;
                 end;
                 a:=length(word);
                 if a=6 then done :=true;
           until done;
     until Date_Correct(word);

     GDate:=word;
end;


Function Getword(l:integer):string;
var
   word:string;
   y,x:integer;
   c,ch:char;
   quit:boolean;
begin
     quit:=false;
     Word:='';
     for y := 1 to l do write('-');
     for y:= 1 to l do write(chr(8));
     repeat
           ch:=readkey;
           ch:=upcase(ch);
           if ord(ch)=8 then
              begin
                   x:=length(Word);
                   if x>0 then
                      begin
                           delete(Word,x,1);
                           write(ch,'-',ch);
                      end;
              end
           else
           begin
                if ord(ch)<>13 then
                begin
                     x:=length(word);
                     if x=l then blip
                     else
                     begin
                          Word:=Word+ch;
                          write(ch);
                     end;
                end
                else
                begin
                     quit:=true;
                end;
           end;
           if ord(ch)=27 then
           begin
                word:='esc';
                quit:=true;
           end;
     until quit;
     writeln;
     getword:=word;
end;

Procedure DrawScreen(A,B,C,D,E:integer;Title:string;F,G:integer;Btitle:string);
begin
     DrawWindow(E);
     DrawBottomBar(F,Btitle);
     DrawTopBar(A,B,C,Title);
end;

Procedure TeleType(A,B,C,D:integer;Word:string);
var
x,y:integer;
begin
     x:=length(Word);
     gotoxy(A,B);
     TextColor(C);
     TextBackground(D);
     for y:=1 to x do
     begin
          write(copy(Word,y,1));
          blip;
          delay(100);
     end;
end;

Procedure SlowWrite(A,B:integer;Word:string);
var x,y:integer;
begin
     gotoxy(A,B);
     x:=length(Word);
     for y:=1 to x do
     begin
          write(copy(Word,y,1));
          delay(100);
     end;
end;

Function RepWord(l:integer;w:string):string;
var
   word:string;
   y,x:integer;
   c,ch:char;
   quit:boolean;
begin
     quit:=false;
     word:='';
     for y:=1 to l do
     begin
          write('-');
          write(chr(8));
     end;
     write(w);
     for y:=1 to length(w) do
     write(chr(8));
     repeat
           ch:=readkey;
           ch:=upcase(ch);
           if ord(ch)=8 then
           begin
                x:=length(Word);
                if x>0 then
                begin
                     delete(Word,x,1);
                     write(ch);
                     write('-');
                     write(ch);
                end;
           end
           else
           begin
                if ord(ch)<>13 then
                begin
                     x:=length(word);
                     if x=l then
                     begin
                          blip;
                     end
                     else
                     begin
                          Word:=Word+ch;
                          write(ch);
                     end;
                end
                else
                begin
                     quit:=true;
                end;
           end;
     until quit;
     writeln;
     repword:=word;
end;

function DownString(S: string): string;
var
  I: Integer;
begin
     for I := 1 to Length(S) do
     if (S[I] >= 'A') and (S[I] <= 'Z') then
     Inc(S[I], 32);
     DownString:= S;
end;

function UpString(S: string): string;
var
  I: Integer;
begin
     for I := 1 to Length(S) do
     if (S[I] >= 'a') and (S[I] <= 'z') then
     Dec(S[I], 32);
     Upstring:= S;
end;

function DownCase(S: char): char;
begin
     if (S >= 'A') and (S <= 'Z') then
     Inc(S, 32);
     DownCase:= S;
end;

Function Date_Correct(Date:string):Boolean;
var
   Y,Day,Month,Year:string;
   m:integer;
   ch:char;
begin
     Y:='94';
     Date_Correct:=true;
     Day:=copy(Date,1,2);
     Month:=copy(Date,3,2);
     Year:=copy(Date,5,2);
     ch:=year[1];
     if ch<>'9' then
     Date_Correct:=False;
     if Day>'31' then Date_Correct:=False;
     if Day<'01' then Date_Correct:=False;
     if Month>'12' then Date_Correct:=False;
     if Month<'01' then Date_Correct:=False;
     if Month='02' then
     if Day>'28' then Date_Correct:=False;
     if Month='04' then m:=1;
     if Month='06' then m:=1;
     if Month='09' then m:=1;
     if Month='11' then m:=1;
     if m=1 then
     if Day>'30' then Date_Correct:=False;
end;

Function Coder(a:string):string;
var
   b,i,l:integer;
   ch:char;
   st:string;
begin
     l:=length(a);
     st:='';
     for i:=1 to l do
     begin
          ch:=a[i];
          b:=(ord(ch) *2) -40;
          st:=st+chr(b);
     end;
     Coder:=st;
end;

Function DeCoder(a:string):string;
var
   b,i,l:integer;
   ch:char;
   st:string;
begin
     l:=length(a);
     st:='';
     for i:=1 to l do
     begin
          ch:=a[i];
          b:=(ord(ch) +40) div 2;
          st:=st+chr(b);
     end;
     DeCoder:=st;
end;

Function Edit_real(x,y:integer;num:real):real;
var
   n,l:integer;
   done:boolean;
   ch,c:char;
   st:string;
   fstop:boolean;
   r1,r2:real;
begin
     fstop:=false;
     str(num:5:2,st);
     for n:= 1 to length(st) do
     begin
          if st[n]='.' then fstop:=true;
     end;
     done:=false;
     gotoxy(x,y);
     write(st);
     reset_cursor;
     repeat
           ch:=readkey;
           ch:=upcase(ch);
           if ord(ch)=8 then
              begin
                   l:=length(st);
                   if l>0 then
                      begin
                           c:=st[l];
                           if c='.' then fstop:=false;
                           delete(st,l,1);
                           write(ch,' ',ch);
                      end
                      else
                          blip;
              end;
           if ch='.' then
           begin
                if not(fstop=true) then
                begin
                     st:=st+ch;
                     fstop:=true;
                     write(ch);
                end;
           end;
           if (ord(ch)>47) and (ord(ch)<58) then
           begin
                l:=length(st);
                if l<6 then
                begin
                     st:=st+ch;
                     write(ch);
                end
                else
                    blip;
           end;
           if ord(ch)=13 then done:=true;
     until Done;
     val(st,r1,l);
     Edit_real:=r1;
     hide_cursor;
end;

Function Edit_word(x,y,l:integer;st:string):string;
var
   n:integer;
   quit:boolean;
   ch:char;
begin
     gotoxy(x,y);
     for n:=1 to l do
     write('-');
     gotoxy(x,y);
     write(st);
     quit:=false;
     reset_cursor;
     repeat
           ch:=readkey;
           ch:=upcase(ch);
           if ord(ch)=8 then
           begin
                n:=length(st);
                if n>0 then
                begin
                     delete(st,n,1);
                     write(ch,'-',ch);
                end
                else
                    blip;
           end;
           if (ord(ch)>31) and (ord(ch)<127) then
           begin
                n:=length(st);
                if n<l then
                begin
                     st:=st+ch;
                     write(ch);
                end
                else
                    blip;
           end;
           if (ord(ch)=13) then quit:=true;
     until quit;
     Edit_word:=st;
     hide_cursor;
end;

Function menu(var pos:integer;maxpos:integer;ch:char):char;
begin
     if ch=#13 then menu:='C';
     if (ch=#72) and (pos>1) then
     begin
          pos:=pos-1;
          menu:='U';
     end;
     if (ch=#80) and (pos<maxpos) then
     begin
          pos:=pos+1;
          menu:='D';
     end;
     if (ch=#75) and (pos>1) then
     begin
          pos:=pos-1;
          Menu:='L';
     end;
     if (ch=#77) and (pos<maxpos) then
     begin
          pos:=pos+1;
          menu:='R';
     end;
end;

end.
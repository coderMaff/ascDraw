{$m 40000,0,0}
{ Simple Ascii Drawing Proggy }
{ By : Maffia / Nerve Axis '95}

Program AscDraw;

Uses crt,mouse,andreas;

Type scr=array[0..4000] of Word;
     GFiles = file of scr;           {The Disk file is defined}

Var
   n,x,y,butval:integer;
   quit:boolean;
   Screen:Scr;
   ch:char;
   GFile:GFiles;
   Name:String[8];
   TFile:Text;
   Font1:Integer;
   Font2:Integer;
   Col1:Integer;
   Col2:Integer;

Procedure SaveScr(var scr:scr);
var                                         { Saves an image of the basic }
   i:integer;                               { screen, to save having to    }
begin                                       { redraw the screen when a     }
     HideMouse;                             { window is closed }
     for i:=0 to 4000 do
     begin
          scr[i]:=Memw[$b800:i];
     end;
     ShowMouse;
end;

Function Getchar(x,y:integer):char;

Var i,j:integer;

Begin
     j:=((y*80)+x)*2;
     i:=Memw[$b800:j];
     GetChar:=Chr(i);
end;

Procedure PutChar(x,y,font:integer);

Var j:integer;

Begin
     hidemouse;
     j:=((y*80)+x)*2;
     Memw[$b800:j]:=font;
     showmouse;
end;

Procedure RestoreScr(scr:scr);              { Restore partner of above }
var
   i:integer;
begin
     for i:=0 to 4000 do
     begin
          Memw[$b800:i]:=scr[i];
     end;
{    ShowMouse;}
end;

Procedure Save_it(screen:scr);

Var n:integer;
    Lines:integer;
Begin
     TextColor(white);
     TextBackGround(Black);
     SaveScr(screen);
     WriteXY(10,20,'FileName:');
     Readln(Name);
     WriteXY(30,10,'SAVING ASCII PIC! ');
     Assign(Gfile,Name+'.Maf');
     Rewrite(GFile);
     Reset(GFile);
     Write(GFile,Screen);
     Close(GFile);
     Assign(TFile,Name+'.TxT');
     Rewrite(Tfile);
     RestoreScr(screen);
     For Lines:=0 TO 24 do
     Begin
         For n:=0 TO 79 do
         Begin
              Write(TFile,GetChar(n,lines));
         end;
         IF Lines<>24 THEN Write(Tfile,Char(13));
         {Write(Tfile,Char(11));}
     End;
     Close(TFile);
     Delay(1000);
     RestoreScr(screen);
end;

Procedure Show_em;

Var
   n:integer;

Begin
     SaveScr(screen);
     TextColor(white);
     TextBackGround(Black);
     ClrScr;
     WriteXy(20,1,' COMPLETE CHARACTER SET 1-79 x 4 ');
     TextColor(Black);
     TextBackGround(White);
     WriteXy(1,2,'    1234567890123456789012345678901234567890123456789012345678901234567890    ');
     WriteXy(1,3,'000                                                                        000');
     WriteXy(1,4,'070                                                                        070');
     WriteXy(1,5,'140                                                                        140');
     WriteXy(1,6,'210                                                                        210');
     WriteXy(1,7,'    1234567890123456789012345678901234567890123456789012345678901234567890    ');

     TextColor(White);
     TextBackGround(Black);
     WriteXy(20,9,'     Press Return To Continue');
     For n:=1 To 70 do Writexy(n+4,3,Char(n));
     For n:=1 To 70 do Writexy(n+4,4,Char(n+70));
     For n:=1 To 70 do Writexy(n+4,5,Char(n+70+70));
     For n:=1 To 46 do Writexy(n+4,6,Char(n+70+70+70));
     Repeat
           GetPosBut(x,y,butval);
           x:=x div 8;
           y:=y div 8;
           If (Butval=1) And (x>3) And (y=2) And (x<74) Then font1:=x-3;
           If (Butval=2) And (x>3) And (y=2) And (x<74) Then font2:=x-3;
           If (Butval=1) And (x>3) And (y=3) And (x<74) Then font1:=x-3+70;
           If (Butval=2) And (x>3) And (y=3) And (x<74) Then font2:=x-3+70;
           If (Butval=1) And (x>3) And (y=4) And (x<74) Then font1:=x-3+70+70;
           If (Butval=2) And (x>3) And (y=4) And (x<74) Then font2:=x-3+70+70;
           If (Butval=1) And (x>3) And (y=5) And (x<50) Then font1:=x-3+70+70+70;
           If (Butval=2) And (x>3) And (y=5) And (x<50) Then font2:=x-3+70+70+70;
           Writexy(10,20,'LMB:');
           Writexy(14,20,Char(font1));
           Writexy(10,21,'RMB:');
           Writexy(14,21,Char(font2));
     Until Keypressed;
     RestoreScr(Screen);
End;

Procedure Load_it;
Begin
     SaveScr(screen);
     TextColor(white);
     TextBackGround(Black);
     WriteXY(10,20,'fILEnAME:');
     Readln(Name);
     IF fileExists(name+'.MaF') THEN
     Begin
          WriteXY(30,10,' lOADING aSCII pIC! ');
          Assign(Gfile,Name+'.Maf');
          Reset(GFile);
          Read(GFile,Screen);
          Close(GFile);
     End
     Else WriteXY(30,10,' fILE dOES nOT eXIST! ');
     Delay(500);
     RestoreScr(screen);
end;


Procedure Put_text;

Var
   Text:String[50];

Begin
     Hidemouse;
     TextColor(white);
     TextBackGround(Black);
     SaveScr(screen);
     Writexy(1,20,'                                                                               ');
     Writexy(10,21,'tHEN pOSITION mOUSE aND cLICK lMB tO pASTE tEXT!');
     Writexy(10,20,'eNTER tEXT:');

     Readln(text);
     RestoreScr(screen);
     ShowMouse;
     Repeat
           SaveScr(screen);
           Getposbut(x,y,butval);
           Writexy(x div 8+1,y div 8+1,text);
           RestoreScr(screen);
     Until butval=1;
     Writexy(x div 8+1,y div 8+1,text);
     Delay(200);
     butval:=0;
end;

function LeadingZero(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then
    s := '0' + s;
  LeadingZero := s;
end;

Procedure Palette;

Var n:integer;

Begin
     TextColor(white);
     TextBackGround(Black);
     SaveScr(screen);
     Clrscr;
     For n:=0 To 15 do WriteXY(25+(n*2),3,LeadingZero(n));
     Writexy(10,5,'RMB Colors:');
     For n:=0 To 15 do
     Begin
          TextBackGround(n);
          WriteXY(25+(n*2),5,'  ');
     End;
     TextBackGround(0);
     TextColor(15);
     Writexy(10,4,'LMB Colors:');
     For n:=0 To 15 do
     Begin
          TextColor(n);
          WriteXY(25+(n*2),4,'лл');
     End;
     TextColor(1);
     TextBackGround(0);
     WriteXY(10,10,'Use Mouse To Select Color!');
     WriteXY(10,20,'Press RETURN to exit!');
     TextColor(col1);
     TextBackground(col2);
     Writexy(20,16,'  ');
     WriteXY(20,15,'лл');
     WriteXY(20,18,Char(font1));
     WriteXY(20,19,Char(font2));
     TextColor(2);
     TextBackground(0);
     WriteXY(23,15,' ForGround  Color');
     WriteXY(23,16,' Background Color');
     WriteXY(23,18,' Font 1  (LMB)');
     WriteXY(23,19,' Font 2  (RMB)');
     Repeat
           getposbut(x,y,butval);
           x:=x div 8;
           y:=y div 8;
           IF butval=1 THEN
           Begin
                IF (x=24) OR (x=25) THEN col1:=0;
                IF (x=26) OR (x=27) THEN col1:=1;
                IF (x=28) OR (x=29) THEN col1:=2;
                IF (x=30) OR (x=31) THEN col1:=3;
                IF (x=32) OR (x=33) THEN col1:=4;
                IF (x=34) OR (x=35) THEN col1:=5;
                IF (x=36) OR (x=37) THEN col1:=6;
                IF (x=38) OR (x=39) THEN col1:=7;
                IF (x=40) OR (x=41) THEN col1:=8;
                IF (x=42) OR (x=43) THEN col1:=9;
                IF (x=44) OR (x=45) THEN col1:=10;
                IF (x=46) OR (x=47) THEN col1:=11;
                IF (x=48) OR (x=49) THEN col1:=12;
                IF (x=50) OR (x=51) THEN col1:=13;
                IF (x=52) OR (x=53) THEN col1:=14;
                IF (x=54) OR (x=55) THEN col1:=15;
                TextColor(col1);
                WriteXY(20,15,'лл');
                TextBackground(col2);
                Writexy(20,16,'  ');
                WriteXY(20,18,Char(font1));
                Writexy(20,19,Char(font2));
           end;
           IF butval=2 THEN
           Begin
                IF (x=24) OR (x=25) THEN col2:=0;
                IF (x=26) OR (x=27) THEN col2:=1;
                IF (x=28) OR (x=29) THEN col2:=2;
                IF (x=30) OR (x=31) THEN col2:=3;
                IF (x=32) OR (x=33) THEN col2:=4;
                IF (x=34) OR (x=35) THEN col2:=5;
                IF (x=36) OR (x=37) THEN col2:=6;
                IF (x=38) OR (x=39) THEN col2:=7;
                IF (x=40) OR (x=41) THEN col2:=8;
                IF (x=42) OR (x=43) THEN col2:=9;
                IF (x=44) OR (x=45) THEN col2:=10;
                IF (x=46) OR (x=47) THEN col2:=11;
                IF (x=48) OR (x=49) THEN col2:=12;
                IF (x=50) OR (x=51) THEN col2:=13;
                IF (x=52) OR (x=53) THEN col2:=14;
                IF (x=54) OR (x=55) THEN col2:=15;
                TextColor(col1);
                WriteXY(20,15,'лл');
                TextBackground(col2);
                Writexy(20,16,'  ');
                WriteXY(20,18,Char(font1));
                WriteXY(20,19,Char(font2));
           end;
     Until Keypressed;
     RestoreScr(screen);
end;


Procedure Help;

Var n:integer;

Begin
     TextBackGround(Black);
     SaveScr(Screen);
     Clrscr;
     TextColor(White);
     TextBackGround(Black);
     For n:=1 to 6 do Writeln;
     TextBackGround(red);
     Write('- -- ------ --- -- - --[ AscDraw v1.o1 By Maff / NvX ]---- -- - ---- -- - -- ---');
     TextBackGround(Blue);
     Write('                                                                                ');
     Write('        kEYBOARD cONTROLS                       kEYBOARD dIRECTIONS             ');
     Write('         c - cHARACTER                               4 - lEFT                   ');
     Write('         q - qUIT!                                   6 - rIGHT                  ');
     Write('         s - sAVE                                    8 - uP                     ');
     Write('         l - lOAD                               5 or 2 - dOWN                   ');
     Write('         t - pLACE tEXT                              , - lMB                    ');
     Write('         h - hELP!                                   . - rMB                    ');
     Write('         p - pALETTE           wHAM rETURN!                                     ');
     Write('                                                                                ');
     TextBackGround(red);
     Write('- -- ------ --- -- - --[ fREEWARE! (c)nERVEaXIS 1995 ]---- -- - ---- -- - -- - -');
     TextBackGround(Black);
     readln;
     RestoreScr(screen);
end;

begin
     if paramcount >=1 then
     begin
          ClrScr;
          IF fileExists(paramstr(1)+'.MaF') THEN
          Begin
               WriteXY(30,10,' lOADING aSCII pIC! ');
               Assign(Gfile,paramstr(1)+'.Maf');
               Reset(GFile);
               Read(GFile,Screen);
               Close(GFile);
               RestoreScr(screen);
               Writexy(1,1,'Press Any Key To Continue!');
               Readln;
               ClrScr
          end
          Else  Writeln('File '+paramstr(1)+' does not exist!');
          Cursor(TRUE);
          hidemouse;
          halt(0);
     end;

     Col1:=7;
     Col2:=5;
     Clrscr;
     Cursor(false);
     Help;
     Clrscr;
     Initmouse;
     showmouse;
     font1:=219;
     font2:=32;
     repeat
           getposbut(x,y,butval);
           x:=x div 8;
           y:=y div 8;
           if keypressed then
           Begin

                ch:=readkey;
                If (ch='c') or (ch='C') then Show_em
                Else
                If (ch='q') or (ch='Q') then
                Begin
                     SaveScr(Screen);
                     TextColor(white);
                     TextBackGround(Black);
                     WriteXY(30,10,'sURE tO qUIT? [Y/N]');
                     ch:=readkey;
                     IF (ch='y') or (ch='Y') THEN quit:=true
                     Else RestoreScr(Screen);
                end
                Else
                If (ch='s') or (ch='S') then Save_it(screen)
                Else
                If (ch='l') or (ch='L') then Load_it
                Else
                If (ch='t') or (ch='T') then put_text
                Else
                If (ch='h') or (ch='H') then help
                Else
                If (ch='p') or (ch='P') then palette
                Else
                IF (ch='5') OR (ch='2') then
                Begin
                     y:=y+1;
                     putmouse(x*8,y*8);
                end
                Else
                IF ch='8' then
                Begin
                     y:=y-1;
                     putmouse(x*8,y*8);
                end
                Else
                IF ch='6' then
                Begin
                     x:=x+1;
                     putmouse(x*8,y*8);
                end
                Else
                IF ch='4' then
                Begin
                     x:=x-1;
                     putmouse(x*8,y*8);
                end
                Else
                IF ch=',' Then butval:=1
                ELSE IF ch='.' Then butval:=2
           end;
           IF (butval=1) or (butval=2) Then
           Begin
                TextColor(col1);
                TextBackground(col2);
           end;

           if butval=1 then
           Begin

                IF (x=79) AND (y=24) THEN PutChar(x,y,font1)
                ELSE
                Begin
                     HideMouse;
                     WriteXy(x+1,y+1,Char(font1));
                     ShowMouse;
                End;
           end;
           if butval=2 then
           Begin
                IF (x=79) AND (y=24) THEN PutChar(x,y,font2)
                ELSE
                Begin
                     HideMouse;
                     WriteXy(x+1,y+1,Char(font2));
                     ShowMouse;
                End;
           end;
           If butval=3 Then quit:=true;
     until quit;
     nosound;
     hidemouse;
     Cursor(TRUE);
end.

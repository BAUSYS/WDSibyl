UNIT fastcrt;

{***************************************************************************
 *  Speed-Pascal/2 V 2.0                                                   *
 *                                                                         *
 *  CRT Standard Unit                                                      *
 *                                                                         *
 *  (C) 1995 SpeedSoft. All rights reserved.                               *
 *                                                                         *
 *  Note: Some constants/variables moved to SYSTEM                         *
 *                                                                         *
 ***************************************************************************}


{
  by: Martin Vieregg www.hypermake.de

  This unit is a substitute for crt.pas, if you want to program text-based
  Windows programs with user interface. fastcrt DOES NOT WRITE TO STDOUT.
  Instead, it uses the Win32 API commands for textual output to a text window
  (DOS prompt window). If you want to write a simple text-io utility,
  do not use this unit.

  There are some minor differences to the normal CRT.PAS unit:

  - use dwrite and dwriteln instead of write and writeln
  - the cursor doesn't get moved if output is written (because of performance).
    If the output is finished for a while, use "AcutalizeCursorPosition".
  - do not use fastcrt together with crt!

  The OS/2 part of fastcrt.pas is identical with crt.pas.
  I've only implemented the functionality which I needed for a specific application.


  *****   german  ******

  Diese Unit ist ein Erstatz fÅr crt.pas, wenn Sie textbasierte Windows-
  Programme (die im Eingabeaufforderungs-Fenster ablaufen) mit Benutzer-
  interface programmieren wollen. Fastcrt SCHREIBT NICHT IN STDOUT.
  Stattdessen werden die Win32 API Befehle fÅr textuelle Ausgabe in ein
  Textfenster genutzt (Eingabeaufforderungsfenster). Wenn Sie ein einfaches
  Kommandozeilen-Utility schreiben wollen, benutzen Sie diese Unit nicht.

  Es gibt einige kleine Differenzen zum normalen CRT.PAS:
  - statt write und writeln wird dwrite und dwriteln verwendet
  - der Cursor wird nicht mit dem Output mitgezogen (PerformancegrÅnde).
    Wenn der Output vorlÑufig zum Abschlu· gekommen ist, mu·
    "AcutalizeCursorPosition" verwendet werden.
  - verwenden Sie nie fastcrt zusammen mit crt.pas.

  Der OS/2-Teil von fastcrt.pas ist identisch mit dem in crt.pas.
  Ich habe nur die Funktionen implementiert, die ich fÅr eine konkrete Applikation
  benîtigte.



  ausfÅhrlich:

  Der ganze Win95-Teil ist neu geschrieben. Da sich hier OS2 und Win95 so
  stark unterscheiden, sind es es nun getrennte Implementation-Blîcke.

  Es gibt einen Fehler in WINCON.PAS bei Type INPUT_RECORD,
  KeyEvent.not_documented_variable kommt hinzu. Dadurch haben sich alle
  nachfolgenden Variablen um 2 Byte verschoben und nichts hat mehr
  funktioniert. Dieser Fehler ist auch in der Win32 Doku und in C header files.
  Um nicht WINCON neu compilieren zu mÅssen, habe ich relativ umstÑndlich
  zwischen zwei Variablen ir_corrupt und ir unterschieden, die an der gleichen
  Speicheradresse sich befinden (sowohl bei readkey als auch bei keypressed).

  Bei der Implementierung der Win95-Bildschirmpuffer-Routinen habe ich zur
  Einsparung von Laufzeit darauf verzichtet, nach jedem Schreiben den
  Cursor "nachzuziehen". Stattdessen mu· Åberall dort, wo das Programm
  wartet, das Setzen der aktuellen Cursorposition mit
  ActualizeCursorPosition "nachgeholt" werden. Das
  halte ich fÅr einen sinnvollen Ansatz. Im wesentlichen ist das readkey
  und keypressed evtl. noch read Funktionen in system.pas. Mit Hilfe der
  Variablen dCursorpositionChanged wird erreicht, da· AcutalizeCursorPosition
  nur dann die Cursorposition aktualisiert, wenn sie sich seit dem letzten
  Aufrufen der Cursorposition auch wirklich verÑndert hat.
  Komischerweise gibt es merkwÅrdige Effekte, wenn ActualizeCursorPosition
  in delay steht, bei keypressed gibt es dagegen keine Probleme.

  Statt write in System.pas zu verÑndern, habe ich neue Funktionen
  dwrite, dwriteln eingefÅhrt, die durch eine entsprechende System.pas
  Implementation von write/writeln ersetzt werden mÅssen.

  Die IO-Umleitung mit PROGRAMM >DATEINAME funktioniert jetzt natÅrlich dann
  nicht mehr. Ich halte es fÅr sinnvoll, bei der Verwendung von Uses Crt
  die standardmÑ·ige write stdout Routine durch die Bildschirmpuffer-Routinen
  von CRT zu ersetzen. Farben sind bei Stdout dann immer zu unterdrÅcken, da
  es ohnehin nicht funktioniert. Win NT unterstÅtzt ohnehin keine ESC-Sequenzen!!!!

  Damit die Unterscheidung CRT / nicht CRT funktioniert, sollte allerdings
  DELAY auch noch in System.pas verlagert werden.

  Es gibt noch eine unschîne Definition aller Funktionen, die die Variable COORD
  verwenden; diese stehen in Wincon.pas fÑlschlicherweise immer mit der gleich
  gro·en Variable longword. Deshalb habe ich hier wieder diese Variablen zweimal
  Åber Absolute definieren mÅssen.

  Einige weniger wichtige Funktionen sind noch nicht implementiert, z. B.
  DelLine, HighVideo.

  Readkey funktioniert noch nicht einwandfrei, es lÑuft nur mit einem Åblen Hack
  (Abfrage der Systemzeit). Hier scheint ein ganz Åbler Bug sowohl in Win95 als auch
  in NT vorzuliegen, der sich auf unterschiedlichen Maschinen unterschiedlich auswirkt.
  Das Problem ist, da· hin und wieder eine Tasteneingabe zweimal eingelesen wird. Auf
  meinem 95 Rechner passiert das so jede 10. bis 20. Tasteneingabe, auf einem NT Rechner
  fast Åberhaupt nicht und auf einem anderen NT Rechner grundsÑtzlich zu 100% immer.

  Der Hack vergleicht den letzten eingegebenen Buchstaben mit dem neuen Buchstaben;
  wenn es derselbe ist, wird er nur ausgegeben, wenn mindestens 130 Millisekunden
  seit der letzten Eingabe vergangen ist. Wenn man nun sehr schnell eine Wortverdoppelung
  schreibt, wird dann leider aus "Messer" "Meser".

  Ich habe leider keine Ahnung, wie man hier weiterkommen kînnte. Leider verwenden nur
  wenige Programmierer die Funktion ReadConsoleInput. Es gibt noch eine Funktion ReadConsole,
  die funktioniert zwar, nutzt aber nichts, weil sie keine Sondertasten abfrÑgt.

}



INTERFACE

CONST
  {Foreground and background color constants}
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

  {Foreground color constants}
  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

  {Add-in for blinking}
  Blink         = 128;

VAR
  CheckBreak: BOOLEAN;          { Ctrl-Break check }
  CheckEOF: BOOLEAN;            { Ctrl-Z for EOF?  }
  NormAttr:WORD;                { Normal text attribute}


  {provisorisch}
const
  AvoidEchoTime : word  = 130;

PROCEDURE ClrScr;
PROCEDURE GotoXY(X : byte; Y:word);
PROCEDURE Window(X1 : byte; Y1 : word; X2 : byte; Y2:word);
PROCEDURE TextColor(Color:byte);
PROCEDURE TextBackground(Color:byte);
FUNCTION WhereX: byte;
FUNCTION WhereY: word;
PROCEDURE ClrEol;
PROCEDURE InsLine;
PROCEDURE DelLine;
PROCEDURE LowVideo;
PROCEDURE NormVideo;
PROCEDURE HighVideo;
FUNCTION KeyPressed: BOOLEAN;
FUNCTION ReadKey: CHAR;
PROCEDURE TextMode(Mode: Integer);
PROCEDURE Delay(ms:LONGWORD);
procedure TextwindowTitlebar (TitlebarString : string);
{Sound/NoSound are not implemented, they are replaced by beep in SYSTEM}

procedure ActualizeCursorPosition;

{das ist nur provisorisch, bis write/writeln in system.pas angepa·t ist}

procedure dwrite (St : string);
procedure dwriteln (St : string);

IMPLEMENTATION

{$IFDEF OS2}
USES PmWin, BSEVIO;
{$ENDIF}

{$IFDEF Win95}
USES WinNT,WinDef,WinCon,WinBase,WinUser;
{$ENDIF}

PROCEDURE CrtError;
VAR
   cs:CSTRING;
   cTitle:CSTRING;
BEGIN
     ctitle:='Wrong linker target';
     cs:='If in the project settings notebook "GUI" (graphical user interface) is chosen,' +
         'it is not allowed to use normal text IO.';
     {$IFDEF OS2}
     WinMessageBox(1,1,cs,ctitle,0,$4000 OR $0010);
     {$ENDIF}
     {$IFDEF Win95}
     MessageBox(0,cs,ctitle,0);
     {$ENDIF}
     Halt(0);
END;


{----------------------------OS/2 implementation------------------------}

{$IFDEF OS2}
{Internal structures from BSESUB}
TYPE
    VIOMODEINFO=RECORD {pack 1}
                     cb:WORD;
                     fbType:BYTE;
                     color:BYTE;
                     col:WORD;
                     row:WORD;
                     hres:WORD;
                     vres:WORD;
                     fmt_ID:BYTE;
                     attrib:BYTE;
                     buf_addr:LONGWORD;
                     buf_length:LONGWORD;
                     full_length:LONGWORD;
                     partial_length:LONGWORD;
                     ext_data_addr:POINTER;
                END;

    VIOCONFIGINFO=RECORD {pack 2}
                      cb:WORD;
                      adapter:WORD;
                      display:WORD;
                      cbMemory:LONGWORD;
                      Configuration:WORD;
                      VDHVersion:WORD;
                      Flags:WORD;
                      HWBufferSize:LONGWORD;
                      FullSaveSize:LONGWORD;
                      PartSaveSize:LONGWORD;
                      EMAdaptersOFF:WORD;
                      EMDisplaysOFF:WORD;
                 END;


Function VIOWhereX : Word;

var Row, Col : Word;

Begin
  VioGetCurPos(Row, Col, 0);
  Result:=Col + 1;
End;

Function VIOWhereY : Word;

var Row, Col : Word;

Begin
  VioGetCurPos(Row, Col, 0);
  Result:=Row + 1
End;

procedure ActualizeCursorPosition;
  begin
      {not necessary in OS/2}
  end;

{Define a text window}
PROCEDURE Window(X1 : byte; Y1 : word; X2 : byte; Y2:word);
VAR MWindMax:WORD;
begin
  ASM
     MOV AX,SYSTEM.MaxWindMax
     MOV MWindMax,AX
  END;
  IF X1<=X2 THEN IF Y1<=Y2 THEN
  BEGIN
      Dec(X1);
      Dec(Y1);
      IF X1>=0 THEN IF Y1>=0 THEN
      BEGIN
           Dec(Y2);
           Dec(X2);
           IF X2<lo(MWindMax)+1 THEN IF Y2<Hi(MWindMax)+1 THEN
           BEGIN
               WindMin := X1 + WORD(Y1) SHL 8;
               WindMax := X2 + WORD(Y2) SHL 8;
               GotoXY(1,1);
           END;
      END;
  END;
END;

{Set cursor location}
PROCEDURE GotoXY(X : byte; Y: word);
BEGIN
     ScreenInOut.GotoXY(X,Y);
END;

{internal ANSI color set routine}
PROCEDURE SetColors;
VAR ColorString:STRING;
    Tmp:BYTE;
    Actual:LONGWORD;
    Handle:LONGWORD;
    ff:^FileRec;
    redirected:BOOLEAN;
BEGIN
     ASM
        MOV AL,SYSTEM.Redirect
        MOV redirected,AL
     END;

     IF Redirected THEN exit;

     ff:=@Output;
     Handle:=ff^.Handle;

     Colorstring:=#27+'[0';    {Reset colors and attributes to black/white}
     IF TextAttr>127 THEN      {IF bit 7 set (blink}
         Colorstring:=ColorString+';5'; {blink}

     {Set background colors}
     Tmp:=TextAttr AND 112 ;   {Clear bits 7,0 to 3 }
     Tmp:=Tmp SHR 4;           {Adjust position to reflect bgcolor}
     Tmp:=Tmp AND 7;
     CASE Tmp OF
        Black    : Tmp:=40;       {Values differ from CLR_ constants!}
        Blue     : Tmp:=44;
        Green    : Tmp:=42;
        Cyan     : Tmp:=46;
        Red      : Tmp:=41;
        Magenta  : Tmp:=45;
        Brown    : Tmp:=43;       {Yellow with in lower set!}
        Lightgray: Tmp:=47;
     END;
     Colorstring:=Colorstring+';'+tostr(Tmp);

     {Now set forefround...}
     Tmp:=TextAttr AND 15 ;    {Clear bits 4 to 7 }
     IF Tmp>7 THEN             {Is bold character}
     BEGIN
          Colorstring:=Colorstring+';1';  {High colors}
          DEC(Tmp,8);
     END;

     Tmp:=Tmp AND 7;
     CASE Tmp OF
         Black    : Tmp:=30;
         Blue     : Tmp:=34;
         Green    : Tmp:=32;
         Cyan     : Tmp:=36;
         Red      : Tmp:=31;
         Magenta  : Tmp:=35;
         Brown    : Tmp:=33; {yellow with in lower set!}
         Lightgray: Tmp:=37;
     END;

     Colorstring:=Colorstring+';'+tostr(Tmp)+'m';

     ASM
        LEA EAX,Actual
        PUSH EAX                //pcbActual
        LEA EDI,ColorString
        MOVZXB EAX,[EDI]
        PUSH EAX               //cbWrite
        INC EDI
        PUSH EDI               //pBuffer
        PUSH DWORD PTR Handle  //FileHandle
        MOV AL,4
        CALLDLL DosCalls,282   //DosWrite
        ADD ESP,16
     END;
END;

{Set foreground color}
PROCEDURE TextColor(Color:BYTE);
BEGIN
  IF ApplicationType=1 THEN CrtError;

  IF Color > White THEN Color := (Color AND 15) OR 128; {Blink}
  TextAttr := (TextAttr AND 112) OR Color;
  SetColors;
END;

{Set background color}
PROCEDURE TextBackground(Color:BYTE);
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := (TextAttr AND $8F) OR ((Color AND $07) SHL 4);
  SetColors;
END;

{Clear screen or window}
PROCEDURE ClrScr;
VAR
  Fill: Word;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  Fill:= 32 + WORD(TextAttr) SHL 8;
  VioScrollUp(Hi(WindMin),Lo(WindMin),
              Hi(WindMax),Lo(WindMax),
              Hi(WindMax)-Hi(WindMin)+1,Fill,0);
  GotoXY(1,1);
END;

{returns current cursor X position}
FUNCTION WhereX: byte;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  WhereX := VioWhereX - Lo(WindMin);
END;

{returns current cursor Y position}
FUNCTION WhereY: word;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  WhereY:= VioWhereY - Hi(WindMin);
END;

{Deletes til end of line}
PROCEDURE ClrEol;
VAR
  Value:WORD;
  Y: BYTE;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  Value := Ord(' ') + WORD(TextAttr) SHL 8;
  Y:=VioWhereY-1;
  VioScrollUp(Y,VioWhereX-1,Y,Lo(WindMax),1,Value,0);
END;

{Insert empty line}
PROCEDURE InsLine;
VAR
   value:WORD;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  value := Ord(' ') + WORD(TextAttr) SHL 8;
  VioScrollDn(VioWhereY-1,Lo(WindMin),Hi(WindMax),Lo(WindMax),1,Value,0);
END;

{Delete the current line}
PROCEDURE DelLine;
VAR
   value:WORD;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  Value := Ord(' ') + WORD(TextAttr) SHL 8;
  VioScrollUp(VioWhereY-1,Lo(WindMin),Hi(WindMax),Lo(WindMax),1,Value,0);
END;

{sets low intensity}
PROCEDURE LowVideo;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := TextAttr AND $F7;
  SetColors;
END;

{sets normal intensity}
PROCEDURE NormVideo;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := NormAttr;
  SetColors;
END;

{sets high intensity}
PROCEDURE HighVideo;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := TextAttr OR $08;
  SetColors;
END;


PROCEDURE InitCrt;
VAR Size:WORD;
    Value:WORD;
BEGIN
     Size := 2;
     VioReadCellStr(Value, Size, WhereY-1, WhereX-1, 0);
     NormAttr := Hi(Value) AND $7F;
     TextAttr:=NormAttr;
     {NormVideo;}
     CheckBreak:=TRUE;
     CheckEOF:=TRUE;
END;

{checks if a key was pressed}
FUNCTION KeyPressed: BOOLEAN;
BEGIN
     IF ApplicationType=1 THEN CrtError;
     KeyPressed:=KeyPressed;
END;

{Reads a character}
FUNCTION ReadKey: CHAR;
BEGIN
     IF ApplicationType=1 THEN CrtError;
     ReadKey:=ReadKey;
END;

{ Set a text mode. (BW40,CO40,BW80,CO80,Mono,Font8x8}
PROCEDURE TextMode(Mode: Integer);
VAR
   Bios: BYTE;
   Value: Word;
   VioMode:VIOMODEINFO;
   VioConfig:VIOCONFIGINFO;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  {Get current video mode}
  VioMode.cb := SizeOf(VioModeInfo);
  VioGetMode(VioMode, 0);

  {update LastMode}
  WITH VioMode DO
  BEGIN
       IF Col = 40 THEN LastMode := BW40
       ELSE LastMode := BW80;
       IF (fbType AND 4) = 0 THEN
          IF LastMode = BW40 THEN LastMode := CO40
       ELSE LastMode := CO80;
       IF Color = 0 THEN LastMode := Mono;
       IF Row > 25 THEN Inc(LastMode,Font8x8);
  END;

  TextAttr := LightGray;
  Bios := Lo(Mode);
  VioConfig.cb := SizeOf(VioConfigInfo);

  {Get adapter info}
  VioGetConfig(0, VioConfig, 0);

  WITH VioMode DO
  BEGIN
      VRes := 400;
      HRes := 720;
      cb := SizeOf(VioModeInfo);
      Row := 25;
      Col := 80;
      fbType := 1;
      Color := 4;      { 16 Colors }

      IF ((Bios=BW40)OR(Bios=CO40)) THEN
      BEGIN
           Col := 40;
           HRes := 360;
      END;
  END;

  IF (Mode AND Font8x8) <> 0 THEN
  BEGIN
       IF VioConfig.Adapter<3 THEN {Mono, CGA, EGA}
       BEGIN
            VioMode.VRes := 350;
            VioMode.HRes := 640;
            VioMode.Row := 43;
       END
       ELSE
       BEGIN
            VioMode.VRes := 400;
            VioMode.HRes := 720;
            VioMode.Row := 50;
       END;
  END;

  CASE Bios of
      BW40,BW80: VioMode.fbType := 5;
      MONO:
      BEGIN
           VioMode.HRes := 720;
           VioMode.VRes := 350;
           VioMode.Color := 0;
           VioMode.fbType := 0;  {no colors}
      END;
  END; {case}

  {try to set mode}
  VioSetMode(VioMode, 0);
  {See what mode is set}
  VioGetMode(VioMode, 0);
  NormVideo;

  {Set window dimensions}
  WindMin := 0;
  WindMax := VioMode.Col - 1 + (VioMode.Row - 1) SHL 8;

  {Clear screen}
  Value := 32 + WORD(TextAttr) SHL 8;    { Clear screen }
  VioScrollUp(0,0,65535,65535,65535,Value,0);
END;

PROCEDURE Delay(ms:LONGWORD);
BEGIN
     IF ApplicationType<>1 THEN
     ASM
        PUSH DWORD PTR ms
        MOV AL,1
        CALLDLL DosCalls,229  //DosSleep
        ADD ESP,4
     END;
END;

procedure TextwindowTitlebar (TitlebarString : string);
  begin
    {not supported by OS/2}
  end;


procedure dwrite (St : string);
  begin
    write (St);
  end;

procedure dwriteln (St : string);
  begin
    writeln (St);
  end;

{$ENDIF}

{------------------------Win95 implementation-----------------------}

{$IFDEF Win95}


var
  dConsoleHandle : HANDLE;
  dCoordBuf : COORD;
  dCoordBuf_longword : longword absolute dCoordBuf; 
  ff:^FileRec;
  dConsoleInfo : CONSOLE_SCREEN_BUFFER_INFO;
  dAttribute : array[1..255] of word;
  dScreensizeX : byte; dScreensizeY : word;
  dWindowsizeX : byte; dWindowsizeY : word;
  dOriginX : byte; dOriginY : word;
  dSpaceLine : cstring;
  dForegroundcolor, dBackgroundcolor : byte;
  dCursorpositionChanged : boolean;
  dActualAttribute : CHAR_INFO;
  dOldTextAttr : byte;

procedure dLoadAttributes;
  var
    I : byte;
  begin
    for I := 1 to dScreensizeX do dAttribute[I] := TextAttr;
    dActualAttribute.Char.AsciiChar := ' ';
    dActualAttribute.Attributes := TextAttr;
    dOldTextAttr := TextAttr;
  end;

procedure dCheckAttributes;
  begin
    if TextAttr <> dOldTextAttr then dLoadAttributes;
  end;

PROCEDURE TextColor(Color:byte);
  begin
    dForegroundcolor := Color;
    TextAttr := dBackgroundColor*16 + dForegroundColor;
    dLoadAttributes;
  end;

PROCEDURE TextBackground(Color:byte);
  begin
    dBackgroundcolor := Color;
    TextAttr := dBackgroundColor*16 + dForegroundColor;
    dLoadAttributes;
  end;

procedure gotoxy (X : byte; Y:word);
  begin
    dCoordBuf.X := X-1+dOriginX; dCoordBuf.Y := Y-1+dOriginY;
    dCursorpositionChanged := true;
  end;

function WhereX : byte;
  begin
    WhereX := dCoordBuf.X+1-dOriginX;
  end;

function WhereY : word;
  begin
    WhereY := dCoordBuf.Y+1-dOriginY;
  end;

PROCEDURE Window(X1 : byte; Y1 : word; X2 : byte; Y2:word);
  begin
    dOriginX := X1-1; dOriginY := Y1-1; dWindowSizeX := X2-X1+1; dWindowSizeY := Y2-Y1+1;
    gotoxy (1, 1);
  end;

procedure ActualizeCursorPosition;
{
  To save time, the cursor position is not actualized after writing.
  This procedure has to be placed on all positions of the program where the program stops,
  e.g. readkey, read console and so on.
}
  begin
    IF ApplicationType=1 THEN CrtError;
    if dCursorpositionChanged then begin
      SetConsoleCursorPosition (dConsoleHandle, dCoordBuf_longword);
      dCursorpositionChanged := false;
    end;
  end;

procedure clreol;
  var
    charswritten : DWORD;
  begin
    IF ApplicationType=1 THEN CrtError;
    dCheckAttributes;
    WriteConsoleOutputCharacter (dConsoleHandle, dSpaceLine, dWindowsizeX-whereX+1, dcoordbuf_longword, charswritten);
    WriteConsoleOutputAttribute (dConsoleHandle, dAttribute[1], dWindowsizeX-whereX+1, dcoordbuf_longword, charswritten);
  end;

procedure dNewLine;
  var
    ScrollRectangle : SMALL_RECT;
    DestinationOrigin : COORD;
    DestinationOrigin_longword : longword absolute DestinationOrigin;
  begin
    if WhereY = dWindowsizeY then begin
      {scroll screen}
      ScrollRectangle.Left := dOriginX;
      ScrollRectangle.Right := dOriginX+dWindowsizeX-1;
      ScrollRectangle.Top := 1+dOriginY;
      ScrollRectangle.Bottom := dOriginY+dWindowsizeY-1;
      DestinationOrigin.X := ScrollRectangle.Left;
      DestinationOrigin.Y := ScrollRectangle.Top-1;
      ScrollConsoleScreenBuffer (dConsoleHandle, ScrollRectangle, nil, DestinationOrigin_longword, dActualAttribute);
      gotoxy (1, wherey);
     end
    else begin
      dcoordbuf.X := dOriginX; inc (dcoordbuf.y);
    end;
  end;

procedure dwrite (st : string);
  var
    charswritten : DWORD;
  begin
    IF ApplicationType=1 THEN CrtError;
    dCheckAttributes;
    WriteConsoleOutputCharacter (dConsoleHandle, st, length(st), dcoordbuf_longword, charswritten);
    WriteConsoleOutputAttribute (dConsoleHandle, dAttribute[1], length(st), dcoordbuf_longword, charswritten);
    dcoordbuf.x := dcoordbuf.x + charswritten;
    if dcoordbuf.x+1 > dWindowsizeX then begin
      dcoordbuf.x := dcoordbuf.x - dWindowsizeX;
      dNewLine;
    end;
    dCursorpositionChanged := true;
  end;

procedure dwriteln (st : string);
  begin
    dwrite (st); dNewLine; dCursorpositionChanged := true;
  end;

procedure clrscr;
  var
     I : word;
  begin
    for I := 1 to dWindowsizeY do begin
      gotoxy (1, I); clreol;
    end;
    gotoxy (1, 1);
  end;

var
  OldTime, NewTime : SYSTEMTIME;
  OldKey : char;

procedure InitCrt;
  var
    I : byte;
  begin
    {creating a 254 char string with spaces}
    dSpaceLine := '    ';
    for I := 1 to 25 do dSpaceLine := dSpaceLine + '          ';
    ff:=@Output;
    dConsoleHandle := ff^.Handle;
    GetConsoleScreenBufferInfo (dConsoleHandle, dConsoleInfo);
    dScreensizeX := dConsoleInfo.srWindow.Right+1;
    dScreensizeY := dConsoleInfo.srWindow.Bottom+1;
    dcoordbuf.X := dConsoleInfo.dwCursorPosition.X;
    dcoordbuf.Y := dConsoleInfo.dwCursorPosition.Y;
    dCursorpositionChanged := false;
    dForegroundcolor := LightGray; dBackgroundcolor := Black; dLoadAttributes;
    dWindowSizeX := dScreensizeX; dWindowSizeY := dScreensizeY; dOriginX := 0; dOriginY := 0;
    //SetConsoleCtrlHandler (nil, true); {Ctrl-Break abschalten funktioniert nicht}
    CheckBreak:=TRUE;
    CheckEOF:=TRUE;
    OldKey := #0;
 end;


const
  LastEnhancedKey : byte = 0;

type
    INPUT_RECORD_OK=RECORD
                       EventType:WORD;
                       Event:RECORD KeyEvent:record
                           bKeyDown:BOOL;
                           not_documentated_variable : WORD;
                           wRepeatCount:WORD;
                           wVirtualKeyCode:WORD;
                           wVirtualScanCode:WORD;
                           uChar:RECORD
                                    CASE Integer OF
                                      1:(UnicodeChar:WORD);
                                      2:(AsciiChar:CHAR);
                                 END;
                           dwControlKeyState:LONGWORD;
                       end END;
    END;

{checks if a key was pressed}
FUNCTION KeyPressed: BOOLEAN;
  type
    tir_corrupt = array [1..100] of INPUT_RECORD;
    tir = array [1..100] of INPUT_RECORD_OK;
    pir_corrupt = ^tir_corrupt;
    pir = ^tir;
  VAR ff:^FileRec;
    ir_corrupt: pir_corrupt;
    ir : pir;
    Chars_in_Buffer,  ConsoleEvent :DWORD;
    Actual:LONGWORD;
    keyPress, EnhancedKey, functionKey : boolean;
  BEGIN
    IF ApplicationType=1 THEN CrtError;
    ActualizeCursorPosition;
    ff:=@Input;
    KeyPress := false;
    GetNumberOfConsoleInputEvents(ff^.Handle, Chars_in_Buffer);
    getmem (ir, sizeof(INPUT_RECORD_OK)*Chars_in_Buffer);
    ir_corrupt := pir_corrupt(ir);
    PeekConsoleInput(ff^.Handle,ir_corrupt^[1],Chars_in_Buffer,Actual);
    for ConsoleEvent := 1 to Chars_in_Buffer do begin
      IF ir^[ConsoleEvent].EventType=KEY_EVENT then with ir^[ConsoleEvent].Event.KeyEvent do begin
        if bKeyDown then begin
          EnhancedKey := 0 <> (dwControlKeyState and ENHANCED_KEY);
          functionKey := (wVirtualScanCode >= 58+1) and (wVirtualScanCode <= 58+10);
          if not ((EnhancedKey and (wVirtualScanCode = 42) or (wVirtualScanCode = 29))
          or ((not EnhancedKey) and ((uChar.AsciiChar = #0) and (not functionKey)))) then
          KeyPress := true;
        end;
      end;
    end;
    freemem (ir, sizeof(INPUT_RECORD_OK)*Chars_in_Buffer);
    KeyPressed := KeyPress;
  END;

{Reads a character}
FUNCTION ReadKey: CHAR;
  VAR
    ff:^FileRec;
    ir_corrupt:INPUT_RECORD;
    ir : INPUT_RECORD_OK absolute ir_corrupt;
    Actual:LONGWORD;
    functionKey, ctrlPressed, altPressed, shiftPressed : BOOLEAN;
    TimeDiff : longint;
    LABEL Label_1, Label_2;
  BEGIN
    IF ApplicationType=1 THEN CrtError;
    ActualizeCursorPosition;
    if LastEnhancedKey <> 0 then begin
      Readkey := char(LastEnhancedKey);
      LastEnhancedKey := 0;
    end
    else begin
      ff:=@Input;
      Label_2:
      REPEAT
        ReadConsoleInput(ff^.Handle,ir_corrupt,1,Actual);
          IF ir.EventType=KEY_EVENT THEN
            IF ir.Event.KeyEvent.bKeyDown THEN goto Label_1;
      UNTIL FALSE;
      Label_1:
      functionKey := (ir.Event.KeyEvent.wVirtualScanCode >= 58+1)
          and (ir.Event.KeyEvent.wVirtualScanCode <= 58+10);
      ctrlPressed := (0 <> (ir.Event.KeyEvent.dwControlKeyState and RIGHT_CTRL_PRESSED))
        or (0 <> (ir.Event.KeyEvent.dwControlKeyState and LEFT_CTRL_PRESSED));
      altPressed := (0 <> (ir.Event.KeyEvent.dwControlKeyState and RIGHT_ALT_PRESSED))
        or (0 <> (ir.Event.KeyEvent.dwControlKeyState and LEFT_ALT_PRESSED));
      shiftPressed := 0 <> (ir.Event.KeyEvent.dwControlKeyState and $0010{SHIFT_PRESSED});
      if 0 <> (ir.Event.KeyEvent.dwControlKeyState and ENHANCED_KEY) then begin
        if (ir.Event.KeyEvent.wVirtualScanCode = 42) or (ir.Event.KeyEvent.wVirtualScanCode = 29) then goto Label_2;
        {a enhanced key was pressed like End or Cursor left}
        LastEnhancedKey := ir.Event.KeyEvent.wVirtualScanCode;
        if ctrlPressed then case LastEnhancedKey of
          77: LastEnhancedKey := 116;
          75: LastEnhancedKey := 115;
          71: LastEnhancedKey := 119;
          79: LastEnhancedKey := 117;
          73: LastEnhancedKey := 132;
          81: LastEnhancedKey := 118;
        end; {if ,case}
        ReadKey := #0;
        {read the next keyboard input, that's not interesting}
        ReadConsoleInput(ff^.Handle,ir_corrupt,1,Actual);
      end
      else if (ir.Event.KeyEvent.uChar.AsciiChar = #0) and (not functionKey) then
        goto Label_2 {only CTRL or SHIFT without another key was pressed}
      else if functionKey then begin
        {a function key was pressed}
        LastEnhancedKey := ir.Event.KeyEvent.wVirtualScanCode;
        if ctrlPressed then LastEnhancedKey := LastEnhancedKey + 35
        else if shiftPressed then LastEnhancedKey := LastEnhancedKey + 25
        else if altPressed then LastEnhancedKey := LastEnhancedKey + 45;
        ReadKey := #0;
      end
      else begin
        {a normal character was pressed}
        OldTime := NewTime;
        GetSystemTime (NewTime);
        if (OldKey = ir.Event.KeyEvent.uChar.AsciiChar) and not (OldKey < #32) then begin
          TimeDiff := NewTime.wSecond*1000+NewTime.wMilliseconds -
              OldTime.wSecond*1000-OldTime.wMilliseconds;
          if (TimeDiff > 0) and (TimeDiff < AvoidEchoTime) then
            goto Label_2;
        end;
        OldKey := ir.Event.KeyEvent.uChar.AsciiChar;
        ReadKey:=ir.Event.KeyEvent.uChar.AsciiChar;
      end;
    end;
  END;


  {Win32 erlaubt es, sogar ganz neue Textfenster beliebiger Grî·e zu erzeugen.
   Das wÑre eine sinnvolle Erweiterung, falls OS/2 so etwas auch unterstÅtzt.
   Bei OS/2 sollte das ignoriert werden, ich glaube es gibt da nichts
   vergleichbares.}

procedure TextwindowTitlebar (TitlebarString : string);
  begin
    SetConsoleTitle (TitlebarString);
  end;


{fÅr InsLine und DelLine kann eine verallgemeinerte Form der
 Prozedur dNewLine verwendet werden}
PROCEDURE InsLine;
  begin
  end;

PROCEDURE DelLine;
  begin
  end;

{fÅr die Farben einfach die funktionierenden
 TextBackground und TextColor verwenden !}

PROCEDURE LowVideo;
  begin
  end;

PROCEDURE NormVideo;
  begin
  end;

PROCEDURE HighVideo;
  begin
  end;

{wei· nicht, wie das sinnvoll implementiert wird}

PROCEDURE TextMode(Mode: Integer);
  begin
  end;


PROCEDURE Delay(ms:LONGWORD);
BEGIN
     ASM
        PUSH DWORD PTR ms
        CALLDLL Kernel32,'Sleep'
     END;
END;


{$ENDIF}
{--------------------------------------------------------------------------}



BEGIN
     IF ApplicationType<>1 THEN InitCrt;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  07-Aug-04  MV/WD      Die Unit zu WDSibyl/TP70 hinzugefÅgt
}

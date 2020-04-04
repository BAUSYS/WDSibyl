
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library                                                 บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit CRT;

Interface

Const
   DirectVideo: BOOLEAN = False; { Enable direct video addressing }
   CheckSnow: BOOLEAN   = True;  { Enable snow filtering }

Const
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

Var
  CheckBreak: BOOLEAN;          { Ctrl-Break check }
  CheckEOF: BOOLEAN;            { Ctrl-Z for EOF?  }
  NormAttr:WORD;                { Normal text attribute}

Procedure ClrScr;
Procedure GotoXY(X,Y:BYTE);
Procedure Window(X1,Y1,X2,Y2:BYTE);
Procedure TextColor(Color:BYTE);
Procedure TextBackground(Color:BYTE);
Function WhereX: Byte;
Function WhereY: WORD;
Procedure ClrEol;
Procedure InsLine;
Procedure DelLine;
Procedure LowVideo;
Procedure NormVideo;
Procedure HighVideo;
Function KeyPressed: BOOLEAN;
Function ReadKey: CHAR;
Procedure TextMode(Mode: Integer);
Procedure Delay(ms:LONGWORD);

Implementation

{$IFDEF OS2}
Uses PmWin, BseSub, BseVio, BseKbd;
{$ENDIF}

{$IFDEF Win32}
Uses WinCon,WinBase,WinUser;
{$ENDIF}
                     
Uses SysUtils;

Var ReadKeyScanCode : Char;

Procedure CrtError;
Var
   cs:Cstring;
   cTitle:Cstring;
Begin
     ctitle:='Wrong linker target';
     cs:='PM Linker mode does not support text screen IO.'+#13+
         'Use the unit WinCrt if you wish to use text'+#13+
         'screen IO inside PM applications.';
     {$IFDEF OS2}
     WinMessageBox(1,1,cs,ctitle,0,$4000 Or $0010);
     {$ENDIF}
     {$IFDEF Win32}
     MessageBox(0,cs,ctitle,0);
     {$ENDIF}
     Halt(0);
End;


{$IFDEF OS2}
{Internal structures from BSESUB}
Type
    VIOMODEINFO=Record {pack 1}
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
                End;

    VIOCONFIGINFO=Record {pack 2}
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
                 End;
{$ENDIF}

{Define a text window}
Procedure Window(X1,Y1,X2,Y2: BYTE);
Var MWindMax:WORD;
Begin
  Asm
     MOV AX,SYSTEM.MaxWindMax
     MOV MWindMax,AX
  End;
  If X1<=X2 Then If Y1<=Y2 Then
  Begin
      Dec(X1);
      Dec(Y1);
      If X1>=0 Then If Y1>=0 Then
      Begin
           Dec(Y2);
           Dec(X2);
           If X2<lo(MWindMax)+1 Then If Y2<Hi(MWindMax)+1 Then
           Begin
               WindMin := X1 + WORD(Y1) Shl 8;
               WindMax := X2 + WORD(Y2) Shl 8;
               GotoXY(1,1);
           End;
      End;
  End;
End;

{Set cursor location}
Procedure GotoXY(X,Y: BYTE);
Begin
     ScreenInOut.GotoXY(X,Y);
End;

{internal ANSI color set routine}
Procedure SetColors;
Var ColorString:String;
    Tmp:BYTE;
    Actual:LONGWORD;
    Handle:LONGWORD;
    ff:^FileRec;
    redirected:BOOLEAN;
Begin
     Asm
        MOV AL,SYSTEM.Redirect
        MOV redirected,AL
     End;

     If Redirected Then exit;

     ff:=@Output;
     Handle:=ff^.Handle;

     Colorstring:=#27+'[0';    {Reset colors and attributes to black/white}
     If TextAttr>127 Then      {IF bit 7 set (blink}
         Colorstring:=ColorString+';5'; {blink}

     {Set background colors}
     Tmp:=TextAttr And 112 ;   {Clear bits 7,0 to 3 }
     Tmp:=Tmp Shr 4;           {Adjust position to reflect bgcolor}
     Tmp:=Tmp And 7;
     Case Tmp Of
        Black    : Tmp:=40;       {Values differ from CLR_ constants!}
        Blue     : Tmp:=44;
        Green    : Tmp:=42;
        Cyan     : Tmp:=46;
        Red      : Tmp:=41;
        Magenta  : Tmp:=45;
        Brown    : Tmp:=43;       {Yellow with in lower set!}
        Lightgray: Tmp:=47;
     End;
     Colorstring:=Colorstring+';'+tostr(Tmp);

     {Now set forefround...}
     Tmp:=TextAttr And 15 ;    {Clear bits 4 to 7 }
     If Tmp>7 Then             {Is bold character}
     Begin
          Colorstring:=Colorstring+';1';  {High colors}
          DEC(Tmp,8);
     End;

     Tmp:=Tmp And 7;
     Case Tmp Of
         Black    : Tmp:=30;
         Blue     : Tmp:=34;
         Green    : Tmp:=32;
         Cyan     : Tmp:=36;
         Red      : Tmp:=31;
         Magenta  : Tmp:=35;
         Brown    : Tmp:=33; {yellow with in lower set!}
         Lightgray: Tmp:=37;
     End;

     Colorstring:=Colorstring+';'+tostr(Tmp)+'m';

     {$IFDEF OS2}
     Asm
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
     End;
     {$ENDIF}
     {$IFDEF Win32}
     WriteFile(ff^.Handle,ColorString[1],length(ColorString),actual,Nil);
     {$ENDIF}
End;

{Set foreground color}
Procedure TextColor(Color:BYTE);
Begin
  If ApplicationType=cApplicationType_GUI Then CrtError;
  If Color > White Then Color := (Color And 15) Or 128; {Blink}
  TextAttr := (TextAttr And 112) Or Color;
  SetColors;
End;

{Set background color}
Procedure TextBackground(Color:BYTE);
Begin
  If ApplicationType=cApplicationType_GUI Then CrtError;
  TextAttr := (TextAttr And $8F) Or ((Color And $07) Shl 4);
  SetColors;
End;

{Clear screen or window}
Procedure ClrScr;
Var
  Fill: Word;
  {$IFDEF Win32}
  ff:^FileRec;
  co:COORD;
  Actual:LONGWORD;
  {$ENDIF}
Begin
  If ApplicationType=cApplicationType_GUI Then CrtError;
  {$IFDEF OS2}
  Fill:= 32 + WORD(TextAttr) Shl 8;
  VioScrollUp(Hi(WindMin),Lo(WindMin),
              Hi(WindMax),Lo(WindMax),
              Hi(WindMax)-Hi(WindMin)+1,Fill,0);
  {$ENDIF}
  {$IFDEF Win32}
  Fill:= TextAttr;
  ff:=@Output;
  co.x:=Lo(WindMin);
  co.y:=Hi(WindMin);
  FillConsoleOutputAttribute(ff^.Handle,Fill,
                             (Hi(WindMax)-Hi(WindMin))*(Lo(WindMax)-Lo(WindMin)),
                             LONGWORD(co),Actual);
  FillConsoleOutputCharacter(ff^.Handle,' ',
                             (Hi(WindMax)-Hi(WindMin))*(Lo(WindMax)-Lo(WindMin)),
                             LONGWORD(co),Actual);
  {$ENDIF}
  GotoXY(1,1);
End;

{returns current cursor X position}
Function WhereX: Byte;

{$IFDEF OS2}
var Row, Col : Word;
{$ENDIF}
{$IFDEF Win32}
Var csbi:CONSOLE_SCREEN_BUFFER_INFO;
    ff:^FileRec;
{$ENDIF}
Begin
  If ApplicationType=cApplicationType_GUI Then CrtError;
  {$IFDEF OS2}
  VioGetCurPos(Row, Col, 0);
  WhereX := Col + 1 - Lo(WindMin);   // VioWhereXProc
  {$ENDIF}
  {$IFDEF Win32}
  ff:=@Output;
  GetConsoleScreenBufferInfo(ff^.Handle,csbi);
  WhereX:=csbi.dwCursorPosition.X+1-Lo(WindMin);
  {$ENDIF}
End;

{returns current cursor Y position}
Function WhereY: WORD;

{$IFDEF OS2}
var Row, Col : Word;
{$ENDIF}
{$IFDEF Win32}
Var csbi:CONSOLE_SCREEN_BUFFER_INFO;
    ff:^FileRec;
{$ENDIF}

Begin
  If ApplicationType=cApplicationType_GUI Then CrtError;
  {$IFDEF OS2}
  VioGetCurPos(Row, Col, 0);
  WhereY:= Row + 1 - Hi(WindMin);   // VioWhereYProc
  {$ENDIF}
  {$IFDEF Win32}
  ff:=@Output;
  GetConsoleScreenBufferInfo(ff^.Handle,csbi);
  WhereY:=csbi.dwCursorPosition.Y+1-Hi(WindMin);
  {$ENDIF}
End;

{Deletes til end of line}
Procedure ClrEol;
Var Value   :WORD;
    {$IFDEF OS2}
    Row, Col: Word;
    {$ENDIF}

Begin
  If ApplicationType=cApplicationType_GUI Then CrtError;
  Value := Ord(' ') + WORD(TextAttr) Shl 8;
  {$IFDEF OS2}
  VioGetCurPos(Row, Col, 0);
  VioScrollUp(Row,Col,Row,Lo(WindMax),1,Value,0);
  {$ENDIF}
END;

{Insert empty line}
PROCEDURE InsLine;
VAR value:WORD;
    {$IFDEF OS2}
    Row, Col: Word;
    {$ENDIF}

BEGIN
  IF ApplicationType=cApplicationType_GUI THEN CrtError;
  value := Ord(' ') + WORD(TextAttr) SHL 8;
  {$IFDEF OS2}
  VioGetCurPos(Row, Col, 0);
  VioScrollDn(row, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Value, 0);
  {$ENDIF}
END;

{Delete the current line}
PROCEDURE DelLine;
VAR  value:WORD;
    {$IFDEF OS2}
    Row, Col: Word;
    {$ENDIF}

BEGIN
  IF ApplicationType=cApplicationType_GUI THEN CrtError;
  Value := Ord(' ') + WORD(TextAttr) SHL 8;
  {$IFDEF OS2}
  VioGetCurPos(Row, Col, 0);
  VioScrollUp(Row, Lo(WindMin), Hi(WindMax), Lo(WindMax), 1, Value, 0);
  {$ENDIF}
END;

{sets low intensity}
PROCEDURE LowVideo;
BEGIN
  IF ApplicationType=cApplicationType_GUI THEN CrtError;
  TextAttr := TextAttr AND $F7;
  SetColors;
END;

{sets normal intensity}
PROCEDURE NormVideo;
BEGIN
  IF ApplicationType=cApplicationType_GUI THEN CrtError;
  TextAttr := NormAttr;
  SetColors;
END;

{sets high intensity}
PROCEDURE HighVideo;
BEGIN
  IF ApplicationType=cApplicationType_GUI THEN CrtError;
  TextAttr := TextAttr OR $08;
  SetColors;
END;


PROCEDURE InitCrt;
VAR Size:WORD;
    Value:WORD;
    {$IFDEF Win32}
    co:COORD;
    ff:^FileRec;
    Actual:LONGWORD;
    {$ENDIF}
BEGIN
     Size := 2;
     {$IFDEF OS2}
     VioReadCellStr(Value, Size, WhereY-1, WhereX-1, 0);
     {$ENDIF}
     {$IFDEF Win32}
     co.X:=1;
     co.Y:=1;
     ff:=@Output;
     ReadConsoleOutputAttribute(ff^.Handle,Value,2,LONGWORD(co),Actual);
     {$ENDIF}
     NormAttr := Hi(Value) AND $7F;
     TextAttr:=NormAttr;
     {NormVideo;}
     CheckBreak:=TRUE;
     CheckEOF:=TRUE;
END;

{checks if a key was pressed}
FUNCTION KeyPressed: BOOLEAN;

{$IFDEF OS2}
var pkbci:KBDKEYINFO;
{$ENDIF}

{$IFDEF Win32}
VAR ff:^FileRec;
    ir:INPUT_RECORD;
    Actual:LONGWORD;
{$ENDIF}
BEGIN
     IF ApplicationType=cApplicationType_GUI THEN CrtError;
     {$IFDEF OS2}
     KbdPeek(pkbci, 0);
     Result:=pkbci.chScan <> 0;
     {$ENDIF}
     {$IFDEF Win32}
     ff:=@Input;

     SetConsoleMode(ff^.Handle,ENABLE_WINDOW_INPUT);

     result:=FALSE;
     PeekConsoleInput(ff^.Handle,ir,1,Actual);
     IF ir.EventType=KEY_EVENT THEN
        IF ir.Event.KeyEvent.bKeyDown THEN result:=TRUE;

     SetConsoleMode(ff^.Handle,ENABLE_PROCESSED_INPUT OR ENABLE_LINE_INPUT OR
       ENABLE_ECHO_INPUT OR ENABLE_WINDOW_INPUT OR ENABLE_MOUSE_INPUT OR
       ENABLE_PROCESSED_OUTPUT OR ENABLE_WRAP_AT_EOL_OUTPUT);
     {$ENDIF}
END;

{Reads a character}
FUNCTION ReadKey: CHAR;

{$IFDEF OS2}
var pkbci:KBDKEYINFO;
{$ENDIF}

{$IFDEF Win32}
VAR ff:^FileRec;
    ir:INPUT_RECORD;
    Actual:LONGWORD;
LABEL l;
{$ENDIF}
BEGIN
  IF ApplicationType=cApplicationType_GUI THEN CrtError;
  {$IFDEF OS2}
  if ReadKeyScanCode=#0
    then
      Begin
        KbdCharIn(pkbci, IO_WAIT, 0); { Aufruf von KbdCharIn }
        if(pkbci.fbStatus and KBDTRF_SCAN_CODE)=KBDTRF_SCAN_CODE
          then
            Begin
              Result:=#0;
              ReadKeyScanCode:=chr(pkbci.chScan);
            End
          else
            Begin
              Result:=pkbci.chChar;
              ReadKeyScanCode:=#0;
            End;
      End
    else    { Sonderzeichen }
      Begin
        Result:=ReadKeyScanCode;
        ReadKeyScanCode:=#0;
      End;
  {$ENDIF}
  {$IFDEF Win32}
  ff:=@Input;
  SetConsoleMode(ff^.Handle,ENABLE_WINDOW_INPUT);
  REPEAT
    ReadConsoleInput(ff^.Handle,ir,1,Actual);
    IF ir.EventType=KEY_EVENT THEN
      IF ir.Event.KeyEvent.bKeyDown THEN goto l;
  UNTIL FALSE;
l:
  ReadKey:=ir.Event.KeyEvent.uChar.AsciiChar;
  SetConsoleMode(ff^.Handle,ENABLE_PROCESSED_INPUT OR ENABLE_LINE_INPUT OR
       ENABLE_ECHO_INPUT OR ENABLE_WINDOW_INPUT OR ENABLE_MOUSE_INPUT OR
       ENABLE_PROCESSED_OUTPUT OR ENABLE_WRAP_AT_EOL_OUTPUT);
  {$ENDIF}
END;

{ Set a text mode. (BW40,CO40,BW80,CO80,Mono,Font8x8}
PROCEDURE TextMode(Mode: Integer);

{$IFDEF OS2}
VAR Bios: BYTE;
    Value: Word;
    VioMode:VIOMODEINFO;
    VioConfig:VIOCONFIGINFO;
{$ENDIF}

BEGIN
  IF ApplicationType=cApplicationType_GUI THEN CrtError;
  {$IFDEF OS2}
  {Get current video mode}
  VioMode.cb := SizeOf(VioModeInfo);
  VioGetMode(VioMode, 0);

  {update LastMode}
  WITH VioMode DO
    BEGIN
      IF Col = 40
        THEN LastMode := BW40
        ELSE LastMode := BW80;
      IF (fbType AND 4) = 0 THEN
        IF LastMode = BW40
          THEN LastMode := CO40
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
    MONO: BEGIN
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
  {$ENDIF}
END;

PROCEDURE Delay(ms:LONGWORD);
BEGIN
  SysSleep(ms);
END;

BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN InitCrt;
  ReadKeyScanCode:=#0;
END.


{ -- date -- -- from -- -- changes ----------------------------------------------
  03-Okt-03  WD         Konstanten DirectVideo, CheckSnow eingefuegt
  26-Nov-03  WD         Delay umgebaut
  19-Jun-04  WD         Ausbau von KBDVIO32.DLL
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
}
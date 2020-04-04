
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library                                               บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

    
UNIT WinCrt;

INTERFACE

{$H-}
                       
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

PROCEDURE ClrScr;
PROCEDURE GotoXY(X,Y:BYTE);
PROCEDURE Window(X1,Y1,X2,Y2:BYTE);
PROCEDURE TextColor(Color:BYTE);
PROCEDURE TextBackground(Color:BYTE);
FUNCTION WhereX: Byte;
FUNCTION WhereY: WORD;
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

IMPLEMENTATION

Uses Color, SysUtils, uSysInfo;

{$IFDEF OS2}
USES Os2Def,PmWin,PmGpi,BseDos,BseTib;
{$ENDIF}
{$IFDEF Win32}
USES WinUser,WinGdi,WinBase,WinDef;
{$ENDIF}

TYPE
  PScreenBuffer=^TScreenBuffer;
  TScreenBuffer=ARRAY[1..50,1..80] OF CHAR;

  PColorBuffer=^TColorBuffer;
  TColorBuffer=ARRAY[1..51,1..81] OF BYTE;

TYPE
  TWinCrtScreenInOutClass=CLASS
    PRIVATE
      ScreenBuffer:PScreenBuffer;
      ColorBuffer:PColorBuffer;
      BufferSize:WORD;
      xPos,yPos:WORD;
      MaxX,MaxY:WORD;
      Handle,FrameHandle:HWND;
{$IFDEF Win32}
      cxChar,cyChar:LONGINT;
{$ENDIF}
    PUBLIC
      PROCEDURE WriteStr(s:STRING);VIRTUAL;
      PROCEDURE WriteCStr(CONST s:CSTRING);VIRTUAL;
      PROCEDURE WriteLF;VIRTUAL;
      PROCEDURE ReadLF(VAR s:STRING);VIRTUAL;
      PROCEDURE GotoXY(x,y:BYTE);VIRTUAL;
      CONSTRUCTOR Create;

      PROCEDURE SetupScreenBuffer(x,y:WORD);
      PROCEDURE CreateWindow;
      PROCEDURE RedrawAll;
{$IFDEF OS2}
      PROCEDURE Redraw(_hps:HPS;rc:RECTL);
      PROCEDURE DrawLine(_hps:HPS;y:BYTE;createfont:BOOLEAN);
{$ENDIF}
{$IFDEF Win32}
      PROCEDURE Redraw(_hps:HDC;rc:RECTL);
      PROCEDURE DrawLine(_hps:HDC;y:BYTE;createfont:BOOLEAN);
{$ENDIF}
      PROCEDURE SetCursor(x,y:BYTE);
  END;


PROCEDURE WinCrtError;
BEGIN
  Writeln('Textmode Linker mode does not support PM screen IO.');
  Writeln('Use the unit Crt if you wish to use text');
  Writeln('screen IO inside textmode applications.');
  Halt(0);
END;

FUNCTION ConvertColor(c:BYTE):LONGINT;

BEGIN
  CASE c OF
    Black         : ConvertColor:= CLR_BLACK;
    Blue          : ConvertColor:= CLR_DARKBLUE;
    Green         : ConvertColor:= CLR_DARKGREEN;
    Cyan          : ConvertColor:= CLR_DARKCYAN;
    Red           : ConvertColor:= CLR_DARKRED;
    Magenta       : ConvertColor:= CLR_DARKPINK;
    Brown         : ConvertColor:= CLR_BROWN;
    LightGray     : ConvertColor:= CLR_PALEGRAY;
    DarkGray      : ConvertColor:= CLR_DARKGRAY;
    LightBlue     : ConvertColor:= CLR_BLUE;
    LightGreen    : ConvertColor:= CLR_GREEN;
    LightCyan     : ConvertColor:= CLR_CYAN;
    LightRed      : ConvertColor:= CLR_RED;
    LightMagenta  : ConvertColor:= CLR_PINK;
    Yellow        : ConvertColor:= CLR_YELLOW;
    White         : ConvertColor:= CLR_WHITE;
  END; {case}
END;

PROCEDURE ClrScr;
VAR Win:TWinCrtScreenInOutClass;
    {$IFDEF OS2}
    Color:LONGINT;
    {$ENDIF}

BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  {$IFDEF OS2}
  Color:=ConvertColor(TextAttr AND 15);
  WinSetPresParam(Win.Handle,PP_FOREGROUNDCOLORINDEX,4,Color);
  Color:=ConvertColor((TextAttr SHR 4) AND 15);
  WinSetPresParam(Win.Handle,PP_BACKGROUNDCOLORINDEX,4,Color);
  {$ENDIF}

  FillChar(Win.ScreenBuffer^,Win.BufferSize,32);
  FillChar(Win.ColorBuffer^,Win.BufferSize,TextAttr);
  Win.RedrawAll;
END;

PROCEDURE GotoXY(X,Y:BYTE);
VAR Win:TWinCrtScreenInOutClass;
BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  Win.SetCursor(X,Y);
END;

{Define a text window}
PROCEDURE Window(X1,Y1,X2,Y2: BYTE);
VAR MWindMax:WORD;
begin

  {$IFDEF OS2}
  ASM
     MOV AX,SYSTEM.MaxWindMax
     MOV MWindMax,AX
  END;
  {$ENDIF}

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


PROCEDURE TextColor(Color:BYTE);
BEGIN
  TextAttr := (TextAttr AND 240) OR Color;
END;

PROCEDURE TextBackground(Color:BYTE);
BEGIN
  TextAttr := (TextAttr AND 7) OR ((Color AND 15) SHL 4);
END;

FUNCTION WhereX: Byte;
VAR Win:TWinCrtScreenInOutClass;
BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  WhereX:=Win.xPos-lo(WindMin);
END;

FUNCTION WhereY: WORD;
VAR Win:TWinCrtScreenInOutClass;
BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  WhereY:=Win.yPos-hi(WindMin);
END;

PROCEDURE ClrEol;
VAR Win:TWinCrtScreenInOutClass;
BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  {$IFDEF OS2}
  WinShowCursor(Win.Handle,FALSE);
  {$ENDIF}
  {$IFDEF Win32}
  HideCaret(Win.Handle);
  {$ENDIF}

  fillchar(Win.ScreenBuffer^[Win.yPos][Win.xPos],(lo(WindMax)-Win.xPos)+2,32);
  fillchar(Win.ColorBuffer^[Win.yPos,Win.xPos],(lo(WindMax)-Win.xpos)+2,textattr);
  Win.DrawLine(0,Win.yPos,TRUE);

  {$IFDEF OS2}
  WinShowCursor(Win.Handle,TRUE);
  {$ENDIF}
  {$IFDEF Win32}
  ShowCaret(Win.Handle);
  {$ENDIF}
END;

PROCEDURE InsLine;

VAR t:BYTE;
    Win:TWinCrtScreenInOutClass;

BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  FOR t:=hi(WindMax)+1 DOWNTO Win.yPos+1 DO
    BEGIN
      move(Win.ScreenBuffer^[t-1][lo(WindMin)],
               Win.ScreenBuffer^[t][lo(WindMin)],
               (lo(WindMax)-lo(WindMin))+2);
      move(Win.ColorBuffer^[t-1][lo(WindMin)],
               Win.ColorBuffer^[t][lo(WindMin)],
               (lo(WindMax)-lo(WindMin))+2);
    END;
  fillchar(Win.ScreenBuffer^[Win.yPos][lo(WindMin)],(lo(WindMax)-lo(WindMin))+2,32);
  fillchar(Win.ColorBuffer^[Win.yPos][lo(WindMin)],(lo(WindMax)-lo(WindMin))+2,TextAttr);
  Win.RedrawAll;
END;

PROCEDURE DelLine;
VAR t:BYTE;
    Win:TWinCrtScreenInOutClass;
BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  FOR t:=Win.yPos TO hi(WindMax) DO
    BEGIN
      move(Win.ScreenBuffer^[t+1][lo(WindMin)],
               Win.ScreenBuffer^[t][lo(WindMin)],
               (lo(WindMax)-lo(WindMin))+2);
      move(Win.ColorBuffer^[t+1][lo(WindMin)],
               Win.ColorBuffer^[t][lo(WindMin)],
               (lo(WindMax)-lo(WindMin))+2);
    END;
  fillchar(Win.ScreenBuffer^[hi(WindMax)+1][lo(WindMin)],(lo(WindMax)-lo(WindMin))+2,32);
  fillchar(Win.ColorBuffer^[hi(WindMax)+1][lo(WindMin)],(lo(WindMax)-lo(WindMin))+2,TextAttr);
  Win.RedrawAll;
END;

PROCEDURE LowVideo;
BEGIN
  TextAttr := TextAttr AND $F7;
END;

PROCEDURE NormVideo;
BEGIN
  TextAttr := NormAttr;
END;

PROCEDURE HighVideo;
BEGIN
  TextAttr := TextAttr OR $08;
END;

CONST CrtKeyCount:BYTE=0;

VAR CrtKeyBuffer:ARRAY[0..40] OF BYTE;

FUNCTION KeyPressed: BOOLEAN;
VAR Win:TWinCrtScreenInOutClass;
    {$IFDEF OS2}
    _qmsg:QMSG;
    {$ENDIF}
    {$IFDEF Win32}
    aMsg:MSG;
    {$ENDIF}

BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  IF Win.Handle=0 THEN Win.CreateWindow;

  IF CrtKeyCount=0 THEN
    BEGIN
      {$IFDEF OS2}
      IF WinPeekMsg(AppHandle,_qmsg,0,0,0,PM_NOREMOVE) THEN
        BEGIN
          IF not WinGetMsg(AppHandle,_qmsg,0,0,0) THEN Halt; {WM_QUIT}
          WinDispatchMsg(AppHandle,_qmsg);
        END;
      {$ENDIF}
      {$IFDEF Win32}
      IF PeekMessage(aMsg,0,0,0,PM_NOREMOVE) THEN
        BEGIN
          IF not GetMessage (amsg, 0, 0, 0) THEN Halt; {WM_QUIT}
          TranslateMessage(amsg);
          DispatchMessage (amsg);
        END;
      {$ENDIF}
    END;
    IF CrtKeyCount>0
      THEN KeyPressed:=TRUE
      ELSE KeyPressed:=FALSE;
  SysSleep(10);
END;

FUNCTION ReadKey: CHAR;
VAR t:BYTE;

BEGIN
  IF ApplicationType<>cApplicationType_GUI THEN WinCrtError;

  REPEAT
    SysSleep(20);
  UNTIL KeyPressed;
  {$ifdef win32}
  ReadKey:=AnsiToOEMTable[CHAR(CrtKeyBuffer[0])];
  {$else}
  ReadKey:=CHAR(CrtKeyBuffer[0]);
  {$endif}
  Dec(CrtKeyCount);
  FOR t:=0 to CrtKeyCount do
    CrtKeyBuffer[t]:=CrtKeybuffer[t+1];
END;

PROCEDURE TextMode(Mode: Integer);
BEGIN
END;

PROCEDURE Delay(ms:LONGWORD);

Begin
  SysSleep(ms);
END;

PROCEDURE TWinCrtScreenInOutClass.WriteStr(s:STRING);
VAR ps:^STRING;
    by,by1:BYTE;
LABEL l;

BEGIN
  IF Handle=0 THEN CreateWindow;
  {$IFDEF OS2}
  WinShowCursor(Handle,FALSE);
  {$ENDIF}
  {$IFDEF Win32}
  HideCaret(Handle);
  StrOemToAnsi(s); // added PE
  {$ENDIF}
  ps:=@s;

  IF length(ps^)>(Lo(WindMax)-Lo(WindMin)-WhereX)+1 THEN
    BEGIN
      by:=(Lo(WindMax)-Lo(WindMin)-WhereX)+2;
      by1:=length(s)-by;
l:
      move(ps^[1],ScreenBuffer^[yPos][xPos],by);
      fillchar(ColorBuffer^[yPos,xPos],by,textattr);
      DrawLine(0,yPos,TRUE);

      inc(ps,by);

      WriteLF;
      {$IFDEF OS2}
      WinShowCursor(Handle,FALSE);
      {$ENDIF}
      {$IFDEF Win32}
      HideCaret(Handle);
      {$ENDIF}
      IF by1>by THEN
        BEGIN
          by:=(Lo(WindMax)-Lo(WindMin)-WhereX)+2;
          dec(by1,by);
          goto l;
        END;

      move(ps^[1],ScreenBuffer^[yPos][xPos],by1);
      fillchar(ColorBuffer^[yPos,xPos],by1,textattr);
      DrawLine(0,yPos,TRUE);

      {$IFDEF OS2}
      WinShowCursor(Handle,TRUE);
      {$ENDIF}
      {$IFDEF Win32}
      ShowCaret(HANDLE);
      {$ENDIF}
      GotoXY(WhereX+by1,WhereY);

      exit;
    END;

  move(ps^[1],ScreenBuffer^[yPos][xPos],length(ps^));
  fillchar(ColorBuffer^[yPos,xPos],length(ps^),textattr);
  DrawLine(0,yPos,TRUE);
  {$IFDEF OS2}
  WinShowCursor(Handle,TRUE);
  {$ENDIF}
  {$IFDEF Win32}
  ShowCaret(HANDLE);
  {$ENDIF}
  GotoXY(WhereX+length(s),WhereY);
END;

PROCEDURE TWinCrtScreenInOutClass.WriteCStr(CONST s:CSTRING);
VAR s1:STRING;
BEGIN
  IF Handle=0 THEN CreateWindow;
  s1:=s;
  WriteStr(s1);
END;

PROCEDURE TWinCrtScreenInOutClass.WriteLF;
VAR t,Start:BYTE;
BEGIN
  IF Handle=0 THEN CreateWindow;
  IF ypos>hi(WindMax)
    THEN
      BEGIN
        Start:=hi(WindMin)+1;
        FOR t:=Start TO hi(WindMax) DO
          BEGIN
            Move(ScreenBuffer^[t+1,lo(WindMin)],
                    ScreenBuffer^[t,lo(WindMin)],(lo(WindMax)-lo(WindMin))+2);
            Move(ColorBuffer^[t+1,lo(WindMin)],
                    ColorBuffer^[t,lo(WindMin)],(lo(WindMax)-lo(WindMin))+2);
          END;
        FillChar(ScreenBuffer^[hi(WindMax)+1,lo(WindMin)],
                   (lo(WindMax)-lo(WindMin))+2,32);
        FillChar(ColorBuffer^[hi(WindMax)+1,lo(WindMin)],
                   (lo(WindMax)-lo(WindMin))+2,TextAttr);
        GotoXY(1,WhereY);
        RedrawAll;
     END
   ELSE GotoXY(1,WhereY+1);
END;

PROCEDURE TWinCrtScreenInOutClass.ReadLF(VAR s:STRING);
VAR ch:CHAR;
BEGIN
  IF Handle=0 THEN CreateWindow;

  ch:=Readkey;
  s:='';
  WHILE ch<>#13 DO
    BEGIN
      case ch of
        #0 : IF CrtKeyCount>0 THEN dec(CrtKeyCount);
        #8 : BEGIN
               IF length(s)>0 THEN
                 BEGIN
                   dec(s[0]);
                   IF WhereX=1
                     THEN GotoXY(lo(WindMax)-lo(WindMin)+1,WhereY-1)
                     ELSE GotoXY(WhereX-1,WhereY);
                   WriteStr(' ');
                   IF WhereX=1
                     THEN GotoXY(lo(WindMax)-lo(WindMin)+1,WhereY-1)
                     ELSE GotoXY(WhereX-1,WhereY);
                 END;
             END;
        ELSE BEGIN
               IF length(s)<255 THEN s:=s+ch;
               WriteStr(ch);
             END;
      END;
      ch:=readkey;
    END;
  WriteLF;
END;

PROCEDURE TWinCrtScreenInOutClass.GotoXY(x,y:BYTE);
BEGIN
  IF Handle=0 THEN CreateWindow;
  SetCursor(x,y);
END;

{$IFDEF OS2}
PROCEDURE CreateLogFont(_HPS:HPS;CONST facename:CSTRING;hei,len,
                        SelAttr:LONGWORD);
VAR fat:FATTRS;

BEGIN
  fat.szFaceName:=facename;
  fat.usRecordLength:=sizeof(FATTRS);
  fat.fsSelection:=SelAttr;
  fat.lMatch:=1;
  fat.idRegistry:=0;
  fat.usCodePage:=0; {default}
  fat.lMaxbaseLineExt:=hei;
  fat.lAveCharWidth:=len;
  fat.fsType:=0;
  fat.fsFontUse:=0;
  GpiCreateLogFont(_hps,@facename,1,fat);
  GpiSetCharSet(_hps,1);
END;
{$ENDIF}

{$IFDEF Win32}
FUNCTION CreateLogFont(_HPS:HDC):HFONT;
BEGIN
  Result:=SelectObject(_HPS,GetStockObject(SYSTEM_FIXED_FONT));
END;
{$ENDIF}

{$IFDEF Win32}
FUNCTION WndProc(ahwnd:HWND;amsg:ULONG;awParam:WPARAM;alParam:LPARAM):LRESULT;APIENTRY;

VAR Win:TWinCrtScreenInOutClass;
    ScanCode:BYTE;

BEGIN
  Win:=TWinCrtScreenInOutClass(ScreenInOut);
  CASE amsg OF
    WM_DESTROY:
      BEGIN
        PostQuitMessage(0);
        WndProc:=0;
      END;
    WM_SETFOCUS:  //Window is getting focus
      BEGIN
        CreateCaret(Win.Handle,0,8,3);
        Win.SetCursor(Win.xPos,Win.yPos);
        WndProc:=0;
      END;
    WM_KEYUP:
      BEGIN
        IF CrtKeyCount<32 THEN
          BEGIN
            CASE awParam OF
              VK_CLEAR,VK_PAUSE,VK_CAPITAL,VK_END,VK_HOME,
              VK_LEFT,VK_UP,VK_RIGHT,VK_DOWN,VK_INSERT,VK_DELETE,
              VK_PRIOR,VK_NEXT,VK_F1,VK_F2,VK_F3,VK_F4,VK_F5,
              VK_F6,VK_F7,VK_F8,VK_F9,VK_F10,VK_F11,VK_F12,VK_F13,
              VK_F14,VK_F15,VK_F16,VK_F17,VK_F18,VK_F19,VK_F20,
              VK_F21,VK_F22,VK_F23,VK_F24:
              BEGIN
                ScanCode:=alParam SHR 16;
                CrtKeyBuffer[CrtKeyCount]:=0;
                CrtKeyBuffer[CrtKeyCount+1]:=ScanCode;
                inc(CrtKeyCount,2);
              END;
            END; {case}
          END;
        WndProc:=0;
      END;
    WM_CHAR:
      BEGIN
        if CrtKeyCount < 33 then
          begin
            CrtKeyBuffer[CrtKeyCount]:=awParam;
            inc(CrtKeyCount);
          end;
        WndProc:=0;
      END;
    WM_KILLFOCUS: //Window is loosing focus
      BEGIN
        DestroyCaret;
        WndProc:=0;
      END;
    ELSE WndProc:=DefWindowProc(ahwnd,amsg,awParam,alParam);
  END; {case}
END;
{$ENDIF}

{$IFDEF OS2}
FUNCTION WinCrtHandler(Win:HWND;msg,para1,para2:ULONG):ULONG;CDECL;
VAR _hps:HPS;
    rc:RECTL;
    Objekt:TWinCrtScreenInOutClass;
    Color:LONGINT;
BEGIN
     Objekt:=TWinCrtScreenInOutClass(ScreenInOut);
     CASE Msg OF
          WM_CLOSE:
          BEGIN
               Halt;
          END;
          WM_PAINT:
          BEGIN
               _hps:=WinBeginPaint(Win,0,rc);
               Objekt.Redraw(_hps,rc);
               WinEndPaint(_hps);
          END;
          WM_SETFOCUS:  {EingabeFocus neu setzen}
          BEGIN
               IF para2=0 THEN
               BEGIN  //Window is loosing focus
                    WinDestroyCursor(Win);
               END
               ELSE  //Window is getting focus
               BEGIN
                    WinCreateCursor(Win,40,40,8,3,CURSOR_SOLID OR CURSOR_FLASH,NIL);
                    Objekt.SetCursor(Objekt.xPos,Objekt.yPos);
               END;
          END;
          WM_ERASEBACKGROUND:
          BEGIN
               _hps:=HPS(para1);
               rc:=PRECTL(Para2)^;
               Color:=ConvertColor((TextAttr SHR 4) AND 15);
               WinFillRect(_hps,rc,Color);
               WinCrtHandler:=0;
          END;
          WM_CHAR:
          BEGIN
              if CrtKeyCount < 33 then
              begin
                   IF lo(Para1) AND KC_KEYUP=KC_KEYUP THEN
                   BEGIN
                        IF lo(lo(para2))=224 THEN
                        BEGIN
                             CrtKeyBuffer[CrtKeyCount]:=0;
                             CrtKeyBuffer[CrtKeyCount+1]:=hi(lo(para2));
                             inc(CrtKeyCount,2);    {RANGE ERROR?}
                        END
                        ELSE
                        BEGIN
                             CrtKeyBuffer[CrtKeyCount]:=lo(para2);
                             inc(CrtKeyCount);
                        END;
                   END;
              end;
              WinCrtHandler:=0;
          END;
          ELSE WinCrtHandler:=WinDefWindowProc(Win,msg,para1,para2);
     END; {case}
END;
{$ENDIF}

{$IFDEF Win32}
FUNCTION WinCrtHandler(Win:HWND;amsg:ULONG;awParam:WPARAM;alParam:LPARAM):LRESULT;APIENTRY;

VAR _hps:HDC;
    rc:RECTL;
    Objekt:TWinCrtScreenInOutClass;
    ps:PAINTSTRUCT;
    ahFont:HFONT;
    tm:TEXTMETRIC;

BEGIN
     Objekt:=TWinCrtScreenInOutClass(ScreenInOut);
     CASE aMsg OF
          WM_CREATE:
          BEGIN
               _hps:=GetDC(Win);

               ahFont:=CreateLogFont(_hps);
               GetTextMetrics(_hps,tm);
               Objekt.cxChar:=tm.tmAveCharWidth;
               Objekt.cyChar:=tm.tmHeight+tm.tmExternalLeading;

               DeleteObject(SelectObject(_hps,ahFont));

               ReleaseDC(Win,_hps);

               WinCrtHandler:=0;
          END;
          WM_PAINT:
          BEGIN
               IF GetUpdateRect(Win,NIL,FALSE) THEN
               BEGIN
                   _hps:=BeginPaint(Win,ps);
                   GetUpdateRect(Win,rc,FALSE);
                   Objekt.Redraw(_hps,rc);
                   EndPaint(Win,ps);
               END;
               WinCrtHandler:=0;
          END;
          WM_ERASEBKGND:
          BEGIN
               WinCrtHandler:=1;
          END;
          ELSE WinCrtHandler:=DefWindowProc(Win,amsg,awParam,alParam);
     END; {case}
END;
{$ENDIF}

{$IFDEF OS2}
PROCEDURE TWinCrtScreenInOutClass.CreateWindow;
VAR ClassName:CSTRING;
    ClassStyle:LONGWORD;
    FrameFlags:LONGWORD;
    Title:CSTRING;
    ScreenCX,ScreenCY:LONGWORD;
    WX,WY:LONGINT;
    Color:LONGINT;

BEGIN
  IF Handle<>0 THEN exit;

  Title:=goSysInfo.ProgramInfo.ExeName;  // ParamStr(0);
  ClassName:='SP/2 WinCrt Window';

  InitPM;
  ClassStyle:=CS_SIZEREDRAW OR CS_MOVENOTIFY;
  FrameFlags:=FCF_TASKLIST OR FCF_DLGBORDER OR FCF_TITLEBAR
                 OR FCF_SYSMENU;
  WinRegisterClass(AppHandle,ClassName,@WinCrtHandler,ClassStyle,0);
  FrameHandle:=WinCreateStdWindow(HWND_DESKTOP,0,FrameFlags,
                                     ClassName,Title,
                                     0,0,0,Handle);
  ScreenCX:=WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
  ScreenCY:=WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);
  WX:=((ScreenCX-80*8) DIV 2);
  WY:=((ScreenCY-25*16) DIV 2);

  Color:=ConvertColor(TextAttr AND 15);
  WinSetPresParam(Handle,PP_FOREGROUNDCOLORINDEX,4,Color);
  Color:=ConvertColor((TextAttr SHR 4) AND 15);
  WinSetPresParam(Handle,PP_BACKGROUNDCOLORINDEX,4,Color);
  WinSetWindowPos(FrameHandle,0,WX,WY,80*8,((25+2)*16)-4,
                     SWP_SHOW OR SWP_SIZE OR SWP_MOVE OR SWP_ACTIVATE OR
                     SWP_FOCUSACTIVATE);
  ClrScr;
END;
{$ENDIF}
{$IFDEF Win32}
PROCEDURE TWinCrtScreenInOutClass.CreateWindow;

VAR ClassName,ChildClassName:CSTRING;
    Title:CSTRING;
    ScreenCX,ScreenCY:LONGWORD;
    WX,WY:LONGINT;
    windowclass:WNDCLASS;
    rc : RECT;

BEGIN
     IF Handle<>0 THEN exit;

     ClassName:='SP/2 WinCrt Window';
     windowclass.style         := CS_HREDRAW OR CS_VREDRAW OR CS_SAVEBITS;
     windowclass.lpfnWndProc   := @WndProc;
     windowclass.cbClsExtra    := 0;
     windowclass.cbWndExtra    := 0;
     windowclass.hInstance     := DllModule;
     windowclass.hIcon         := 0;
     windowclass.hCursor       := LoadCursor(0,IDC_ARROW);
     windowclass.hbrBackground := COLOR_APPWORKSPACE+1;
     windowclass.lpszMenuName  := NIL;
     windowclass.lpszClassName := @ClassName;

     RegisterClass(windowclass);

     ChildClassName:='SP/2 WinCrt Child Window';
     windowclass.lpfnWndProc   := @WinCrtHandler;
     windowclass.hbrBackground := COLOR_WINDOW+1;
     windowclass.lpszMenuName  := NIL;
     windowclass.lpszClassName := @ChildClassName;

     RegisterClass(windowclass);

     Title:=ParamStr(0);
     ScreenCX:=GetSystemMetrics(SM_CXSCREEN);
     ScreenCY:=GetSystemMetrics(SM_CYSCREEN);
     WX:=((ScreenCX-80*8) DIV 2);
     WY:=((ScreenCY-25*12) DIV 2);
     FrameHandle:= WinUser.CreateWindow (ClassName, Title,
                  WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR
                  WS_CLIPCHILDREN OR WS_DLGFRAME,
                  WX, WY,80*8,(25)*16,
                  0, 0, DllModule, NIL);
     GetClientRect(FrameHandle,rc);
     Handle:= WinUser.CreateWindow (ChildClassName,ChildClassName,
                  WS_CHILD OR WS_CLIPSIBLINGS OR WS_VISIBLE,
                  0,0,rc.Right-rc.Left,rc.Bottom-rc.Top,
                  FrameHandle,0, DllModule , NIL);

     ShowWindow (FrameHandle,10);
     ShowWindow (Handle,10);
     UpdateWindow(FrameHandle);
     UpdateWindow(Handle);

     ClrScr;
END;
{$ENDIF}


PROCEDURE InitWinCrt;
VAR ScreenInOutPM:TWinCrtScreenInOutClass;
BEGIN
  ScreenInOutPM.Create;
  ScreenInOut:=TScreenInOutClass(ScreenInOutPM);
END;


{$IFDEF OS2}
PROCEDURE TWinCrtScreenInOutClass.Redraw(_hps:HPS;rc:RECTL);
VAR rc1:RECTL;
    loy,hiy:WORD;
    t:BYTE;
BEGIN
  CreateLogFont(_hps,'System VIO',16,8,0);
  WinQueryWindowRect(Handle,rc1);
  loy:=rc1.yTop-rc.yTop;
  loy:=loy DIV 16;
  hiy:=rc1.yTop-rc.yBottom;
  hiy:=hiy DIV 16;
  IF loy=0 THEN loy:=1;
  WinShowCursor(Handle,FALSE);
  FOR t:=loy-1 TO hiy+1 DO
    DrawLine(_hps,t,false);
  WinShowCursor(Handle,TRUE);
END;
{$ENDIF}
{$IFDEF Win32}
PROCEDURE TWinCrtScreenInOutClass.Redraw(_hps:HDC;rc:RECTL);
VAR
    loy,hiy:WORD;
    t:BYTE;
    ahFont:HFONT;
BEGIN
     ahFont:=CreateLogFont(_hps);
     loy:=rc.Bottom;
     loy:=1{loy DIV cyChar};
     hiy:=rc.Top;
     hiy:=25{hiy DIV cyChar};
     IF loy=0 THEN loy:=1;
     HideCaret(Handle);
     FOR t:=loy-1 TO hiy+1 DO DrawLine(_hps,t,false);
     DeleteObject(SelectObject(_hps,ahFont));
     ShowCaret(Handle);
END;
{$ENDIF}


{$IFDEF OS2}
PROCEDURE TWinCrtScreenInOutClass.DrawLine(_hps:HPS;y:BYTE;createfont:BOOLEAN);
VAR PSCreated:BOOLEAN;
    Color:LONGINT;
    pt:POINTL;
    rc,rc1:RECTL;
    Actual,Start:LONGWORD;
    xpos:LONGWORD;
    Len:LONGWORD;

BEGIN
  WinQueryWindowRect(Handle,rc);
  IF _hps=0
    THEN
      BEGIN
        PSCreated:=TRUE;
        _hps:=WinGetPS(Handle);
      END
    ELSE PSCreated:=FALSE;

  IF CreateFont THEN CreateLogFont(_hps,'System VIO',16,8,0);

  IF ((y=0)OR(y>MaxY)) THEN exit;


  IF y=MaxY THEN
    BEGIN
      Color:=ConvertColor((TextAttr SHR 4) AND 15);
      rc1.xleft:=0;
      rc1.xright:=MaxX*8;
      rc1.yBottom:=0;
      rc1.yTop:=10;
      WinFillRect(_hps,rc1,Color);
    END;

  pt.y:=(rc.yTop-(y*16))+4;
  Actual:=1;
  xPos:=0;
  GpiSetBackMix(_hps,BM_OVERPAINT);
  Color:=ColorBuffer^[y][Actual];
  Len:=0;
  Start:=1;
  WHILE Actual<=MaxX DO
    BEGIN
      IF ((Color<>ColorBuffer^[y][Actual])OR(Actual=MaxX))
        THEN
          BEGIN
            GpiSetColor(_hps,ConvertColor(Color AND 15));
            GpiSetBackColor(_hps,ConvertColor((Color SHR 4) AND 15));
            pt.x:=xpos;
            GpiCharStringAt(_hps,pt,len,ScreenBuffer^[y][Start]);
            Color:=ColorBuffer^[y][Actual];
            inc(xpos,len*8);
            Len:=0;
            Start:=Actual;
            IF Actual=MaxX THEN inc(Actual); //terminate
          END
        ELSE
          BEGIN
            inc(Len);
            inc(Actual);
          END;
    END;

    IF PSCreated THEN WinReleasePS(_hps);
END;
{$ENDIF}
{$IFDEF Win32}
PROCEDURE TWinCrtScreenInOutClass.DrawLine(_hps:HDC;y:BYTE;createfont:BOOLEAN);
VAR rc:RECT;
    PSCreated:BOOLEAN;
    Color:LONGINT;
    pt:POINT;
    Actual,Start,xPos:LONGINT;
    Len:LONGINT;
    ahFont:HFONT;
    ahBrush:HBRUSH;

{$IFDEF OS2}
    s:STRING;
    c:CSTRING;
{$ENDIF}

BEGIN
     IF ((y=0)OR(y>MaxY)) THEN exit;

     GetWindowRect(Handle,rc);
     IF _hps=0 THEN
     BEGIN
          PSCreated:=TRUE;
          _hps:=GetDC(Handle);
     END
     ELSE PSCreated:=FALSE;

     IF CreateFont THEN ahFont:=CreateLogFont(_hps);

     IF y=MaxY THEN
     BEGIN
          Color:=ConvertColor((TextAttr SHR 4) AND 15);
          ahBrush:=CreateSolidBrush(Color);
          SelectObject(_hps,ahBrush);
          SetBkMode(_hps,OPAQUE);
          Rectangle(_hps,0,(rc.Bottom-rc.Top)-12,MaxX*cxChar,
                    rc.Bottom-rc.Top);
          DeleteObject(SelectObject(_hps,ahBrush));
     END;

     pt.y:=(y-1)*cyChar;
     Actual:=1;
     xPos:=0;
     SetBkMode(_hps,OPAQUE);
     Color:=ColorBuffer^[y][Actual];
     Len:=0;
     Start:=1;
     WHILE Actual<=MaxX DO
     BEGIN
          IF ((Color<>ColorBuffer^[y][Actual])OR(Actual=MaxX)) THEN
          BEGIN
               SetTextColor(_hps,ConvertColor(Color AND 15));
               SetBkColor(_hps,ConvertColor((Color SHR 4) AND 15));
               pt.x:=xpos;
               TextOut(_hps,pt.x,pt.y,CSTRING(ScreenBuffer^[y][Start]),len+1);
               SetTextAlign(_hps,TA_LEFT OR TA_TOP);
               Color:=ColorBuffer^[y][Actual];
               inc(xpos,len*cxChar);
               Len:=0;
               Start:=Actual;
               IF Actual=MaxX THEN inc(Actual); //terminate
          END
          ELSE
          BEGIN
               inc(Len);
               inc(Actual);
          END;
     END;

  IF PSCreated THEN ReleaseDC(Handle,_hps);
  IF CreateFont THEN DeleteObject(SelectObject(_hps,ahFont));
END;
{$ENDIF}


PROCEDURE TWinCrtScreenInOutClass.RedrawAll;
VAR t:BYTE;
{$IFDEF OS2}
    _hps:HPS;
{$ENDIF}
{$IFDEF Win32}
    _hps:HDC;
    ahfont:HFONT;
{$ENDIF}

BEGIN
  {$IFDEF OS2}
  WinShowCursor(Handle,FALSE);
  _hps:=WinGetPS(Handle);
  CreateLogFont(_hps,'System VIO',16,8,0);
  FOR t:=1 TO Hi(WindMax)+1 DO
    DrawLine(_hps,t,false);
  WinReleasePS(_hps);
  WinShowCursor(Handle,TRUE);
  {$ENDIF}
  {$IFDEF Win32}
  HideCaret(Handle);
  _hps:=GetDC(Handle);
  ahFont:=CreateLogFont(_hps);
  FOR t:=1 TO Hi(WindMax)+1 DO
    DrawLine(_hps,t,false);
  DeleteObject(SelectObject(_hps,ahFont));
  ReleaseDC(Handle,_hps);
  ShowCaret(Handle);
  {$ENDIF}
END;

PROCEDURE TWinCrtScreenInOutClass.SetCursor(X,Y:BYTE);
VAR tx,ty:LONGWORD;
    rc:RECTL;
BEGIN
  IF Handle=0 THEN CreateWindow;

  inc(X,lo(WindMin));
  inc(Y,hi(WindMin));
  IF X>lo(WindMax)+1 THEN X:=1;
  IF Y>hi(WindMax)+1 THEN Y:=hi(WindMax)+1;
  IF X<lo(WindMin)+1 THEN X:=lo(WindMin)+1;
  IF Y<hi(WindMin)+1 THEN Y:=hi(WindMin)+1;
  xPos:=X;
  yPos:=Y;
  {$IFDEF OS2}
  WinQueryWindowRect(Handle,rc);
  tx:=(xPos-1)*8;
  ty:=rc.yTop-yPos*16;
  WinCreateCursor(Handle,tx,ty-2,8,3,CURSOR_SETPOS OR CURSOR_FLASH,NIL);
  WinShowCursor(Handle,TRUE);
  {$ENDIF}

  {$IFDEF Win32}
  GetWindowRect(Handle,rc);
  tx:=(xPos-1)*cxChar;
  ty:=yPos*cyChar;
  CreateCaret(Handle,0,8,3);
  SetCaretPos(tx,ty-2);
  ShowCaret(Handle);
  {$ENDIF}
END;


PROCEDURE TWinCrtScreenInOutClass.SetupScreenBuffer(x,y:WORD);
BEGIN
  TextAttr:=(White SHL 4)+Black;  {Black on White}
  NormAttr:=TextAttr;
  CheckBreak:=FALSE;
  xPos:=1;
  yPos:=1;

  IF BufferSize<>0 THEN
    BEGIN
      FreeMem(ScreenBuffer,BufferSize);
      FreeMem(ColorBuffer,BufferSize);
    END;

  BufferSize:=(x+1)*(y+1);
  GetMem(ScreenBuffer,BufferSize);
  GetMem(ColorBuffer,BufferSize);
  FillChar(ScreenBuffer^,x*y,32);      {Space}
  FillChar(ColorBuffer^,x*y,TextAttr); {LightGray on black}

  WindMin:=0;
  WindMax:=x+y SHL 8;
  MaxX:=x;
  MaxY:=y;
END;

CONSTRUCTOR TWinCrtScreenInOutClass.Create;
BEGIN
  Inherited Create;

  ScreenInOut:=TScreenInOutClass(SELF);

  LastMode:=CO80;
  WindMin:=0;
  WindMax:=80+WORD(25) SHL 8;
  MaxX:=80;
  MaxY:=25;
  ScreenBuffer:=NIL;
  ColorBuffer:=NIL;
  Handle:=0;
  BufferSize:=0;
  {$IFDEF Win32}
  cxChar:=8;
  cyChar:=12;
  {$ENDIF}
  SetupScreenBuffer(lo(WindMax),hi(WindMax));
  SetCursor(xpos,yPos);
END;

BEGIN
  IF ApplicationType=cApplicationType_GUI THEN  {nur fr PM Modus}
    BEGIN
      ScreenInOut.Destroy;  {delete old}
      InitWinCrt;
    END;                    
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  09-Mar-06  WD         Paramstr(0) durch goSysInfo ersetzt.
  15-Mar-09  PE         Einbau von StrOemToAnsi usw.
}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT WinDef;

{****************************************************************************
 *                                                                          *
 * 32 Bit Windows constants and types for use with Win32 and DAX            *
 *                                                                          *
 ****************************************************************************}


INTERFACE

USES WinNT;

TYPE PBOOL=^BOOL;
     BOOL=LONGBOOL;
     PDWORD=^DWORD;
     DWORD=LONGWORD;
     LPDWORD=PDWORD;
     WCHAR=CHAR; {??}
     LPBYTE=^BYTE;
     LPSTR=PCHAR;
     LPCSTR=PChar;
     LPTSTR=PChar; {??}
     LPCTSTR=PChar; {??}
     PSZ=PChar;
     PFLOAT=^FLOAT;
     FLOAT=EXTENDED;
     {Martin}LARGE_INTEGER=record LowPart : longword; HighPart : longint; end;
     {Martin}ULARGE_INTEGER=record LowPart : longword; HighPart : longword; end;

     WPARAM=ULONG;
     LPARAM=LONG;
     LRESULT=LONG;
     HWND=LONGWORD;
     HHOOK=LONGWORD;
     ATOM=WORD;
     SPHANDLE=^HANDLE;
     LPHANDLE=^HANDLE;
     HGLOBAL=HANDLE;
     HLOCAL=HANDLE;
     {GLOBALHANDLE=HANDLE;
     LOCALHANDLE=HANDLE;}
     HGDIOBJ=HANDLE;
     HACCEL=HANDLE;
     HBITMAP=HANDLE;
     HBRUSH=HANDLE;
     HDC=HANDLE;
     HGLRC=HANDLE;
     HDESK=HANDLE;
     HENHMETAFILE=HANDLE;
     HFONT=HANDLE;
     HICON=HANDLE;
     HMENU=HANDLE;
     HMETAFILE=HANDLE;
     HINSTANCE=HANDLE;
     HMODULE=HINSTANCE;
     HPALETTE=HANDLE;
     HPEN=HANDLE;
     HRGN=HANDLE;
     HRSRC=HANDLE;
     HSTR=HANDLE;
     HTASK=HANDLE;
     HWINSTA=HANDLE;
     HKL=HANDLE;
     HFILE=LONGINT;
     HCURSOR=HICON;
     LPCOLORREF=^COLORREF;
     COLORREF=ULONG;
     PCOLORREF=LPCOLORREF;

CONST
     MAX_PATH          = 260;
     NULL              = 0;
     HFILE_ERROR       =-1;

TYPE
    PRECT=^RECT;
    RECT=RECORD
               left:LONG;
               top:LONG;
               right:LONG;
               bottom:LONG;
         END;
    NPRECT=PRECT;
    LPRECT=PRECT;

    PRECTL=^RECTL;
    RECTL=RECORD
                left:LONG;
                top:LONG;
                right:LONG;
                bottom:LONG;
          END;
    LPRECTL=PRECTL;

    PPOINT=^POINT;
    POINT=RECORD
                x:LONG;
                y:LONG;
          END;
    NPPOINT=PPOINT;
    LPPOINT=PPOINT;

    PPOINTL=^POINTL;
    POINTL=RECORD
                 x:LONG;
                 y:LONG;
           END;

    PSIZE=^SIZE;
    SIZE=RECORD
               cx:LONG;
               cy:LONG;
         END;
    LPSIZE=PSIZE;
    SIZEL=SIZE;
    PSIZEL=^SIZE;
    LPSIZEL=^SIZE;

    PPOINTS=^POINTS;
    POINTS=RECORD
                 x:SHORT;
                 y:SHORT;
           END;
    LPPOINTS=PPOINTS;

CONST
     DM_UPDATE           =1;
     DM_COPY             =2;
     DM_PROMPT           =4;
     DM_MODIFY           =8;
     DM_IN_BUFFER        =DM_MODIFY;
     DM_IN_PROMPT        =DM_PROMPT;
     DM_OUT_BUFFER       =DM_COPY;
     DM_OUT_DEFAULT      =DM_UPDATE;

     DC_FIELDS           =1;
     DC_PAPERS           =2;
     DC_PAPERSIZE        =3;
     DC_MINEXTENT        =4;
     DC_MAXEXTENT        =5;
     DC_BINS             =6;
     DC_DUPLEX           =7;
     DC_SIZE             =8;
     DC_EXTRA            =9;
     DC_VERSION          =10;
     DC_DRIVER           =11;
     DC_BINNAMES         =12;
     DC_ENUMRESOLUTIONS  =13;
     DC_FILEDEPENDENCIES =14;
     DC_TRUETYPE         =15;
     DC_PAPERNAMES       =16;
     DC_ORIENTATION      =17;
     DC_COPIES           =18;

{ Diverse Funktionen }

FUNCTION max(a,b:LONGINT):LONGINT;
FUNCTION min(a,b:LONGINT):LONGINT;
FUNCTION MAKEWORD(a,b:BYTE):WORD;
FUNCTION MAKELONG(a,b:INTEGER):LONG;
FUNCTION LOWORD(l:LONGINT):WORD;
FUNCTION HIWORD(l:LONGINT):WORD;
FUNCTION LOBYTE(w:WORD):BYTE;
FUNCTION HIBYTE(w:WORD):BYTE;

IMPLEMENTATION

FUNCTION max(a,b:LONGINT):LONGINT;
BEGIN
  IF a>b
    THEN max:=a
    ELSE max:=b;
END;

FUNCTION min(a,b:LONGINT):LONGINT;
BEGIN
  IF a<b
    THEN min:=a
    ELSE min:=b;
END;

FUNCTION MAKEWORD(a,b:BYTE):WORD;
BEGIN
  MAKEWORD:=a OR (b SHL 8);
END;

FUNCTION MAKELONG(a,b:INTEGER):LONG;
BEGIN
  MAKELONG:=a OR (b SHL 16);
END;

FUNCTION LOWORD(l:LONGINT):WORD;
BEGIN
  LOWORD:=lo(l);
END;

FUNCTION HIWORD(l:LONGINT):WORD;
BEGIN
  HIWORD:=hi(l);
END;

FUNCTION LOBYTE(w:WORD):BYTE;
BEGIN
  LOBYTE:=lo(w);
END;

FUNCTION HIBYTE(w:WORD):BYTE;
BEGIN
  HIBYTE:=hi(w);
END;

BEGIN
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  06-Aug-04   MV        Ein- bzw. Umbau von den Typen: LARGE_INTEGER, ULARGE_INTEGER
}


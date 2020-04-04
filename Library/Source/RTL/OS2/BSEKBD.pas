Unit BSEKBD;

Interface

Uses Os2Def, BseSub;

Imports
  Function KbdSetCustXt(VAR usCodePage:WORD;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 201;
  Function KbdGetCp(ulReserved:ULONG;VAR pidCP:WORD;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 203;
  Function KbdCharIn(VAR pkbci:KBDKEYINFO;fWait:ULONG;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 204;
  Function KbdSetCp (usReserved,pidCP:ULONG;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 205;
  Function KbdSynch(fsWait:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 207;
  Function KbdRegister(pszModName,pszEntryPt:PSZ;FunMask:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 208;
  Function KbdStringIn(VAR apch;VAR pchIn:STRINGINBUF;fsWait:ULONG;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 209;
  Function KbdGetStatus(VAR apkbdinfo:KBDINFO;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 210;
  Function KbdSetStatus(VAR apkbdinfo:KBDINFO;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 211;
  Function KbdGetFocus(fWait:ULONG;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 212;
  Function KbdFlushBuffer(ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 213;
  Function KbdXlate(VAR apkbdtrans:KBDTRANS;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 214;
  Function KbdClose(ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 217;
  Function KbdFreeFocus (ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 218;
  Function KbdDeRegister:WORD;
                         APIENTRY;             'EMXWRAP' index 220;
  Function KbdSetFgnd:WORD;
                         APIENTRY;             'EMXWRAP' index 221;
  Function KbdPeek(VAR pkbci:KBDKEYINFO;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 222;
  Function KbdOpen(VAR aphkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 223;
  Function KbdGetHWID(VAR apkbdhwid:KBDHWID;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 224;
  Function KbdSetHWID(VAR apkbdhwid:KBDHWID;ahkbd:HKBD):WORD;
                         APIENTRY;             'EMXWRAP' index 225;
End;

Implementation

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  18-Jun-04  WD         Erstellung der Datei
}
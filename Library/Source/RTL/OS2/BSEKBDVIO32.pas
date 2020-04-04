Unit BSEKBDVIO32;

Interface

Uses Os2Def, BSESub;

IMPORTS
       FUNCTION KbdRegister(pszModName,pszEntryPt:PSZ;FunMask:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 5;
       FUNCTION KbdDeRegister:WORD;
                         APIENTRY;             'KBDVIO32' index 6;
       FUNCTION KbdCharIn(VAR pkbci:KBDKEYINFO;fWait:ULONG;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 7;
       FUNCTION KbdPeek(VAR pkbci:KBDKEYINFO;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 8;
       FUNCTION KbdStringIn(VAR apch;VAR pchIn:STRINGINBUF;fsWait:ULONG;
                         ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 9;
       FUNCTION KbdFlushBuffer(ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 10;
       FUNCTION KbdSetStatus(VAR apkbdinfo:KBDINFO;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 11;
       FUNCTION KbdGetStatus(VAR apkbdinfo:KBDINFO;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 12;
       FUNCTION KbdSetCp (usReserved,pidCP:ULONG;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 13;
       FUNCTION KbdGetCp (ulReserved:ULONG;VAR pidCP:WORD;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 14;
       FUNCTION KbdOpen (VAR aphkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 15;
       FUNCTION KbdClose (ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 16;
       FUNCTION KbdGetFocus (fWait:ULONG;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 17;
       FUNCTION KbdFreeFocus (ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 18;
       FUNCTION KbdSynch (fsWait:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 19;
       FUNCTION KbdSetFgnd:WORD;
                         APIENTRY;             'KBDVIO32' index 20;
       FUNCTION KbdGetHWID(VAR apkbdhwid:KBDHWID;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 21;
       FUNCTION KbdSetHWID(VAR apkbdhwid:KBDHWID;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 22;
       FUNCTION KbdXlate (VAR apkbdtrans:KBDTRANS;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 23;
       FUNCTION KbdSetCustXt(VAR usCodePage:WORD;ahkbd:HKBD):WORD;
                         APIENTRY;             'KBDVIO32' index 24;
       FUNCTION VioRegister(pszModName,pszEntryName:PSZ;flFun1,
                        flFun2:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 25;
       {FUNCTION VioGlobalReg(pszModName,pszEntryName:PSZ;
                              flFun1,flFun2:ULONG;usReturn:WORD):WORD;
                         APIENTRY;             'KBDVIO32' index 26;
        unresolved external in 'KBDVIO32'.C ??? }
       FUNCTION VioDeRegister:WORD;
                         APIENTRY;             'KBDVIO32' index 27;
       FUNCTION VioGetBuf (VAR pLVB:POINTER;VAR pcbLVB:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 28;
       FUNCTION VioGetCurPos(VAR pusRow,pusColumn:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 29;
       FUNCTION VioSetCurPos (usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 30;
       FUNCTION VioGetCurType (VAR apvioCursorInfo:VIOCURSORINFO;
                           ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 31;
       FUNCTION VioSetCurType (VAR apvioCursorInfo:VIOCURSORINFO;
                           ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 32;
       FUNCTION VioGetMode (VAR apvioModeInfo:VIOMODEINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 33;
       FUNCTION VioSetMode (VAR apvioModeInfo:VIOMODEINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 34;
       FUNCTION VioGetPhysBuf (VAR apvioPhysBuf:VIOPHYSBUF;
                           usReserved:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 35;
       FUNCTION VioReadCellStr (VAR pchCellStr;VAR pcb:USHORT;usRow,
                            usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 36;
       FUNCTION VioReadCharStr(VAR pchCellStr;VAR pcb:USHORT;usRow,
                           usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 37;
       FUNCTION VioWrtCellStr(VAR pchCellStr;cb,usRow,usColumn:ULONG;
                          ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 38;
       FUNCTION VioWrtCharStr(VAR pchStr;cb,usRow,usColumn:ULONG;
                          ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 39;
       FUNCTION VioScrollDn(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbLines:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 40;
       FUNCTION VioScrollUp(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbLines:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 41;
       FUNCTION VioScrollLf(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbCol:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 42;
       FUNCTION VioScrollRt(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbCol:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 43;
       FUNCTION VioWrtNAttr(VAR pAttr;cb,usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 44;
       FUNCTION VioWrtNCell(VAR pCell;cb,usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 45;
       FUNCTION VioWrtNChar(VAR pchChar;cb,usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 46;
       FUNCTION VioWrtTTY(VAR apch;cb:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 47;
       FUNCTION VioWrtCharStrAtt(VAR apch;cb,usRow,usColumn:ULONG;
                             VAR pAttr;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 48;
       FUNCTION VioCheckCharType(VAR pType:WORD;usRow,usColumn:ULONG;
                             ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 49;
       FUNCTION VioShowBuf(offLVB,cb:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 50;
       FUNCTION VioSetAnsi(fAnsi:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 51;
       FUNCTION VioGetAnsi(VAR pfAnsi:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 52;
       FUNCTION VioPrtSc(ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 53;
       FUNCTION VioPrtScToggle(ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 54;
       {FUNCTION VioRedrawSize(VAR pcbRedraw:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 55;
        unresolved external in 'KBDVIO32'.C ???}
       FUNCTION VioSavRedrawWait(usRedrawInd:ULONG;VAR pNotifyType:WORD;
                             usReserved:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 56;
       FUNCTION VioSavRedrawUndo(usOwnerInd,usKillInd,usReserved:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 57;
       FUNCTION VioModeWait(usReqType:ULONG;VAR pNotifyType:WORD;
                        usReserved:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 58;
       FUNCTION VioModeUndo(usOwnerInd,usKillInd,usReserved:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 59;
       FUNCTION VioScrLock(fWait:ULONG;VAR pfNotLocked:BYTE;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 60;
       FUNCTION VioScrUnLock(ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 61;
       FUNCTION VioPopUp (VAR pfWait:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 62;
       FUNCTION VioEndPopUp(ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 63;
       FUNCTION VioGetConfig(usConfigId:LONGWORD;VAR pvioin:VIOCONFIGINFO;
                             ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 64;
       FUNCTION VioGetFont(VAR pviofi:VIOFONTINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 65;
       FUNCTION VioSetFont(VAR pviofi:VIOFONTINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 66;
       FUNCTION VioGetCp(usReserved:ULONG;VAR pIdCodePage:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 67;
       FUNCTION VioSetCp(usReserved,idCodePage:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 68;
       FUNCTION VioGetState(VAR pState;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 69;
       FUNCTION VioSetState(VAR pState;ahvio:HVIO):WORD;
                         APIENTRY;             'KBDVIO32' index 70;
       FUNCTION MouRegister(pszModName,pszEntryName:PSZ;flFuns:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 71;
       FUNCTION MouDeRegister:WORD;
                         APIENTRY;             'KBDVIO32' index 72;
       FUNCTION MouFlushQue(ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 73;
       FUNCTION MouGetPtrPos(VAR pmouLoc:PTRLOC;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 74;
       FUNCTION MouSetPtrPos(VAR pmouLoc:PTRLOC;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 75;
       FUNCTION MouSetPtrShape(VAR pBuf;VAR pmoupsInfo:PTRSHAPE;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 76;
       FUNCTION MouGetPtrShape(VAR pBuf;VAR pmoupsInfo:PTRSHAPE;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 77;
       FUNCTION MouGetDevStatus(VAR pfsDevStatus:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 78;
       FUNCTION MouGetNumButtons(VAR pcButtons:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 79;
       FUNCTION MouGetNumMickeys(VAR pcMickeys:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 80;
       FUNCTION MouReadEventQue(VAR pmouevEvent:MOUEVENTINFO;VAR pfWait:WORD;
                            ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 81;
       FUNCTION MouGetNumQueEl(VAR qmouqi:MOUQUEINFO;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 82;
       FUNCTION MouGetEventMask(VAR pfsEvents:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 83;
       FUNCTION MouSetEventMask(VAR pfsEvents:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 84;
       FUNCTION MouGetScaleFact(VAR pmouscFactors:SCALEFACT;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 85;
       FUNCTION MouSetScaleFact(VAR pmouscFactors:SCALEFACT;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 86;
       FUNCTION MouOpen(pszDvrName:PSZ;VAR aphmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 87;
       FUNCTION MouClose(ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 88;
       FUNCTION MouRemovePtr(VAR pmourtRect:NOPTRRECT;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 89;
       FUNCTION MouDrawPtr(ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 90;
       FUNCTION MouSetDevStatus(VAR pfsDevStatus:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 91;
       FUNCTION MouInitReal(apsz:PSZ):WORD;
                         APIENTRY;             'KBDVIO32' index 92;
       FUNCTION MouSynch(pszDvrName:ULONG):WORD;
                         APIENTRY;             'KBDVIO32' index 93;
       FUNCTION MouGetThreshold(VAR apthreshold:THRESHOLD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 94;
       FUNCTION MouSetThreshold(VAR apthreshold:THRESHOLD;ahmou:HMOU):WORD;
                         APIENTRY;             'KBDVIO32' index 95;
END;


Implementation

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  18-Jun-04  WD         Erstellung der Datei
}
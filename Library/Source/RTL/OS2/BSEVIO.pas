Unit BSEVIO;

Interface

Uses Os2Def, BseSub;

Imports
  Function VioEndPopUp(ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 101;
  Function VioGetPhysBuf (VAR apvioPhysBuf:VIOPHYSBUF;
                           usReserved:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 102;
  Function VioGetAnsi(VAR pfAnsi:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 103;
  Function VioSetAnsi(fAnsi:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 105;
  Function VioDeRegister:WORD;
                         APIENTRY;             'EMXWRAP' index 106;
  Function VioScrollUp(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbLines:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 107;
  Function VioPrtSc(ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 108;
  Function VioGetCurPos(VAR pusRow,pusColumn:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 109;

  Function VioWrtCellStr(VAR pchCellStr;cb,usRow,usColumn:ULONG;
                          ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 110;
  Function VioPopUp (VAR pfWait:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 111;
  Function VioScrollRt(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbCol:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 112;
  Function VioWrtCharStr(VAR pchStr;cb,usRow,usColumn:ULONG;
                          ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 113;
  Function VioSetCurPos (usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 115;
  Function VioScrUnLock(ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 118;
  Function VioWrtTTY(VAR apch;cb:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 119;
  Function VioGetMode (VAR apvioModeInfo:VIOMODEINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 121;
  Function VioSetMode (VAR apvioModeInfo:VIOMODEINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 122;
  Function VioScrLock(fWait:ULONG;VAR pfNotLocked:BYTE;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 123;
  Function VioReadCellStr (VAR pchCellStr;VAR pcb:USHORT;usRow,
                            usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 124;
  Function VioSavRedrawWait(usRedrawInd:ULONG;VAR pNotifyType:WORD;usReserved:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 125;
  Function VioWrtNAttr(VAR pAttr;cb,usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 126;
  Function VioGetCurType (VAR apvioCursorInfo:VIOCURSORINFO;
                           ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 127;
  Function VioSavRedrawUndo(usOwnerInd,usKillInd,usReserved:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 128;
  Function VioGetFont(VAR pviofi:VIOFONTINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 129;
  Function VioReadCharStr(VAR pchCellStr;VAR pcb:USHORT;usRow,
                           usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 130;
  Function VioGetBuf (VAR pLVB:POINTER;VAR pcbLVB:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 131;
  Function VioSetCurType (VAR apvioCursorInfo:VIOCURSORINFO;
                           ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 132;
  Function VioSetFont(VAR pviofi:VIOFONTINFO;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 133;
  Function VioModeUndo(usOwnerInd,usKillInd,usReserved:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 135;
  Function VioModeWait(usReqType:ULONG;VAR pNotifyType:WORD;usReserved:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 137;
  Function VioGetCp(usReserved:ULONG;VAR pIdCodePage:WORD;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 140;
  Function VioSetCp(usReserved,idCodePage:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 142;
  Function VioShowBuf(offLVB,cb:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 143;
  Function VioScrollLf(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbCol:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 144;
  Function VioRegister(pszModName,pszEntryName:PSZ;flFun1, flFun2:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 145;
  Function VioGetConfig(usConfigId:LONGWORD;VAR pvioin:VIOCONFIGINFO; ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 146;
  Function VioScrollDn(usTopRow,usLeftCol,usBotRow,usRightCol,
                        cbLines:ULONG;VAR pCell;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 147;
  Function VioWrtCharStrAtt(VAR apch;cb,usRow,usColumn:ULONG;
                             VAR pAttr;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 148;
  Function VioGetState(VAR pState;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 149;
  Function VioPrtScToggle(ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 150;
  Function VioSetState(VAR pState;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 151;
  Function VioWrtNCell(VAR pCell;cb,usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 152;
  Function VioWrtNChar(VAR pchChar;cb,usRow,usColumn:ULONG;ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 153;
  Function VioRedrawSize(VAR pcbRedraw:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 169;
  Function VioGlobalReg(pszModName,pszEntryName:PSZ;flFun1,flFun2:ULONG;usReturn:WORD):WORD;
                         APIENTRY;             'EMXWRAP' index 170;

  Function VioCheckCharType(VAR pType:WORD;usRow,usColumn:ULONG;
                             ahvio:HVIO):WORD;
                         APIENTRY;             'EMXWRAP' index 175;

End;


Implementation

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  18-Jun-04  WD         Erstellung der Datei
}
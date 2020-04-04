Unit BSEMOU;

Interface

Uses Os2Def, BseSub;

Imports
  Function MouGetPtrShape(VAR pBuf;VAR pmoupsInfo:PTRSHAPE;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 301;
  Function MouSetPtrShape(VAR pBuf;VAR pmoupsInfo:PTRSHAPE;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 302;
  Function MouGetNumMickeys(VAR pcMickeys:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 303;
  Function MouGetScaleFact(VAR pmouscFactors:SCALEFACT;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 306;
  Function MouFlushQue(ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 307;
  Function MouGetNumButtons(VAR pcButtons:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 308;
  Function MouClose(ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 309;
  Function MouSetScaleFact(VAR pmouscFactors:SCALEFACT;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 311;
  Function MouGetNumQueEl(VAR qmouqi:MOUQUEINFO;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 313;
  Function MouDeRegister:WORD;
                         APIENTRY;             'EMXWRAP' index 314;
  Function MouGetEventMask(VAR pfsEvents:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 315;
  Function MouSetEventMask(VAR pfsEvents:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 316;
  Function MouOpen(pszDvrName:PSZ;VAR aphmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 317;
  Function MouRemovePtr(VAR pmourtRect:NOPTRRECT;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 318;
  Function MouGetPtrPos(VAR pmouLoc:PTRLOC;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 319;
  Function MouReadEventQue(VAR pmouevEvent:MOUEVENTINFO;VAR pfWait:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 320;
  Function MouSetPtrPos(VAR pmouLoc:PTRLOC;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 321;
  Function MouGetDevStatus(VAR pfsDevStatus:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 322;
  Function MouSynch(pszDvrName:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 323;
  Function MouRegister(pszModName,pszEntryName:PSZ;flFuns:ULONG):WORD;
                         APIENTRY;             'EMXWRAP' index 324;
  Function MouSetDevStatus(VAR pfsDevStatus:WORD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 325;
  Function MouDrawPtr(ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 326;
  Function MouInitReal(apsz:PSZ):WORD;
                         APIENTRY;             'EMXWRAP' index 327;
  Function MouGetThreshold(VAR apthreshold:THRESHOLD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 329;
  Function MouSetThreshold(VAR apthreshold:THRESHOLD;ahmou:HMOU):WORD;
                         APIENTRY;             'EMXWRAP' index 330;
END;


Implementation

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  18-Jun-04  WD         Erstellung der Datei
}
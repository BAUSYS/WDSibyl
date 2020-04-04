
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PMSHL;

{****************************************************************************
 *                                                                          *
 * OS/2 Presentation Manager Shell constants, types, messages and           *
 * function declarations include file.                                      *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def;


{ maximum title length }
CONST
     MAXNAMEL =60;

{ program handle }

TYPE
    HPROGRAM=LHANDLE;
    HAPP=LHANDLE;

{ ini file handle }
TYPE
    HINI=LHANDLE;

CONST
   HINI_PROFILE         =0;
   HINI_USERPROFILE     =-1;
   HINI_SYSTEMPROFILE   =-2;
   HINI_USER            =HINI_USERPROFILE;
   HINI_SYSTEM          =HINI_SYSTEMPROFILE;

TYPE
    PRFPROFILE=RECORD
                  cchUserName:ULONG;
                  pszUserName:PChar;
                  cchSysName:ULONG;
                  pszSysName:PChar;
               END;

CONST
     { maximum path length }
     MAXPATHL =128;

     { root group handle }
     SGH_ROOT  =-1;

TYPE
     HPROGARRAY=RECORD
                     ahprog:HPROGRAM;
                END;

     PROGCATEGORY=ULONG;

   { values acceptable for PROGCATEGORY for PM groups }
CONST
      PROG_DEFAULT             =0;
      PROG_FULLSCREEN          =1;
      PROG_WINDOWABLEVIO       =2;
      PROG_PM                  =3;
      PROG_GROUP               =5;
      PROG_REAL                =4;
      PROG_VDM                 =4;
      PROG_WINDOWEDVDM         =7;
      PROG_DLL                 =6;
      PROG_PDD                 =8;
      PROG_VDD                 =9;
      PROG_WINDOW_REAL         =10;
      PROG_WINDOW_PROT         =11;
      PROG_30_STD              =11;
      PROG_WINDOW_AUTO         =12;
      PROG_SEAMLESSVDM         =13;
      PROG_30_STDSEAMLESSVDM   =13;
      PROG_SEAMLESSCOMMON      =14;
      PROG_30_STDSEAMLESSCOMMON=14;
      PROG_31_STDSEAMLESSVDM   =15;
      PROG_31_STDSEAMLESSCOMMON=16;
      PROG_31_ENHSEAMLESSVDM   =17;
      PROG_31_ENHSEAMLESSCOMMON=18;
      PROG_31_ENH              =19;
      PROG_31_STD              =20;
      PROG_RESERVED            =255;

TYPE
      PROGTYPE=RECORD
                    progc:PROGCATEGORY;
                    fbVisible:ULONG;
               END;

      { visibility flag for PROGTYPE structue }
CONST
      SHE_VISIBLE         =$00;
      SHE_INVISIBLE       =$01;
      SHE_RESERVED        =$FF;

      { Protected group flag for PROGTYPE structure }
      SHE_UNPROTECTED     =$00;
      SHE_PROTECTED       =$02;

      { Structures associated with 'Prf' calls }
TYPE
      PROGDETAILS=RECORD
                       Length:ULONG;
                       progt:PROGTYPE;
                       pszTitle:PChar;
                       pszExecutable:PChar;
                       pszParameters:PChar;
                       pszStartupDir:PChar;
                       pszIcon:PChar;
                       pszEnvironment:PChar;
                       swpInitial:SWP;
                  END;

      PROGTITLE=RECORD
                      hprog:HPROGRAM;
                      progt:PROGTYPE;
                      pszTitle:PChar;
                END;
      { bit values for Options parameter }
CONST
      SAF_VALIDFLAGS        =$001F;

      SAF_INSTALLEDCMDLINE  =$0001;     { use installed parameters }
      SAF_STARTCHILDAPP     =$0002;     { related application      }
      SAF_MAXIMIZED         =$0004;     { Start App maximized      }
      SAF_MINIMIZED         =$0008;     { Start App minimized, if !SAF_MAXIMIZED }
      SAF_BACKGROUND        =$0010;     { Start app in the background }



{ switch list section }

TYPE
    HSWITCH=LHANDLE;

    PSWCNTRL=^SWCNTRL;
    SWCNTRL=RECORD
                 hwnd:HWND;
                 hwndIcon:HWND;
                 hprog:HPROGRAM;
                 idProcess:PID;
                 idSession:ULONG;
                 uchVisibility:ULONG;
                 fbJump:ULONG;
                 szSwtitle:CSTRING[MAXNAMEL+3];
                 bProgType:ULONG;
            END;

{ visibility flag for SWCNTRL structure }
CONST
     SWL_VISIBLE     =$04;
     SWL_INVISIBLE   =$01;
     SWL_GRAYED      =$02;

{ jump flag for SWCNTRL structure }
     SWL_JUMPABLE    =$02;
     SWL_NOTJUMPABLE =$01;

TYPE
    PSWENTRY=^SWENTRY;
    SWENTRY=RECORD
                  hswitch:HSWITCH;
                  swctl:SWCNTRL;
            END;

    PSWBLOCK=^SWBLOCK;
    SWBLOCK=RECORD
                  cswentry:ULONG;
                  swentry:Array[0..0] of SWENTRY;
            END;

CONST
     PL_ALTERED =$008E;  { WM_SHELLFIRST + 0E }


IMPORTS

FUNCTION WinAddSwitchEntry(VAR aps:SWCNTRL):HSWITCH;
                    APIENTRY;         'PMSHAPI' index 120;
FUNCTION WinRemoveSwitchEntry(ah:HSWITCH):ULONG;
                    APIENTRY;         'PMSHAPI' index 129;
FUNCTION PrfQueryProgramTitles(ahini:HINI;hprogGroup:HPROGRAM;
                               VAR pTitles:PROGTITLE;cchBufferMax:ULONG;
                               VAR pulCount:ULONG):ULONG;
                    APIENTRY;         'PMSHAPI' index 113;
FUNCTION PrfAddProgram(ahini:HINI;VAR pDetails:PROGDETAILS;
                       hprogGroup:HPROGRAM):HPROGRAM;
                    APIENTRY;         'PMSHAPI' index 109;
FUNCTION PrfChangeProgram(ahini:HINI;hprog:HPROGRAM;
                          VAR pDetails:PROGDETAILS):BOOL;
                    APIENTRY;         'PMSHAPI' index 110;
FUNCTION PrfQueryDefinition(ahini:HINI;hprog:HPROGRAM;
                            VAR pDetails:PROGDETAILS;
                            cchBufferMax:ULONG):ULONG;
                    APIENTRY;         'PMSHAPI' index 111;
FUNCTION PrfRemoveProgram(ahini:HINI;hprog:HPROGRAM):BOOL;
                    APIENTRY;         'PMSHAPI' index 104;
FUNCTION PrfQueryProgramHandle(ahini:HINI;CONST pszExe:CSTRING;
                               aphprogArray:HPROGARRAY;cchBufferMax:ULONG;
                               VAR pulCount:ULONG):BOOL;
                    APIENTRY;         'PMSHAPI' index 58;
FUNCTION PrfCreateGroup(ahini:HINI;CONST pszTitle:CSTRING;
                        chVisibility:UCHAR):HPROGRAM;
                    APIENTRY;         'PMSHAPI' index 55;
FUNCTION PrfDestroyGroup(ahini:HINI;hprogGroup:HPROGRAM):BOOL;
                    APIENTRY;         'PMSHAPI' index 106;
FUNCTION PrfQueryProgramCategory(ahini:HINI;CONST pszExe:CSTRING):PROGCATEGORY;
                    APIENTRY;         'PMSHAPI' index 59;
FUNCTION WinStartApp(hwndNotify:HWND;VAR pDetails:PROGDETAILS;CONST pszParams:CSTRING;
                     Reserved:POINTER;fbOptions:ULONG):HAPP;
                    APIENTRY;         'PMSHAPI' index 119;
FUNCTION WinTerminateApp(ahapp:HAPP):BOOL;
                    APIENTRY;         'PMSHAPI' index 130;
FUNCTION WinChangeSwitchEntry(hswitchSwitch:HSWITCH;
                              VAR pswctlSwitchData:SWCNTRL):ULONG;
                    APIENTRY;         'PMSHAPI' index 123;
FUNCTION WinCreateSwitchEntry(ahab:HAB;VAR pswctlSwitchData:SWCNTRL):HSWITCH;
                    APIENTRY;         'PMSHAPI' index 121;
FUNCTION WinQuerySessionTitle(ahab:HAB;usSession:ULONG;VAR pszTitle:CSTRING;
                              usTitlelen:ULONG):ULONG;
                    APIENTRY;         'PMSHAPI' index 122;
FUNCTION WinQuerySwitchEntry(hswitchSwitch:HSWITCH;
                             VAR pswctlSwitchData:SWCNTRL):ULONG;
                    APIENTRY;         'PMSHAPI' index 124;
FUNCTION WinQuerySwitchHandle(ahwnd:HWND;pidProcess:PID):HSWITCH;
                    APIENTRY;         'PMSHAPI' index 125;
FUNCTION WinQuerySwitchList(ahab:HAB;VAR pswblkSwitchEntries:SWBLOCK;
                            usDataLength:ULONG):ULONG;
                    APIENTRY;         'PMSHAPI' index 126;
FUNCTION WinQueryTaskSizePos(ahab:HAB;usScreenGroup:ULONG;
                             VAR pswpPositionData:SWP):ULONG;
                    APIENTRY;         'PMSHAPI' index 127;
FUNCTION WinQueryTaskTitle(usSession:ULONG;VAR pszTitle:CSTRING;
                           usTitlelen:ULONG):ULONG;
                    APIENTRY;         'PMSHAPI' index 128;
FUNCTION WinSwitchToProgram(hswitchSwHandle:HSWITCH):ULONG;
                    APIENTRY;         'PMSHAPI' index 131;
FUNCTION PrfQueryProfileInt(ahini:HINI;CONST pszApp,pszKey:CSTRING;
                            sDefault:LONG):LONG;
                    APIENTRY;         'PMSHAPI' index 114;
FUNCTION PrfQueryProfileString(ahini:HINI;CONST pszApp,pszKey,pszDefault:CSTRING;
                               VAR pBuffer;cchBufferMax:ULONG):ULONG;
                    APIENTRY;         'PMSHAPI' index 115;
FUNCTION PrfWriteProfileString(ahini:HINI;CONST pszApp,pszKey,pszData:CSTRING):BOOL;
                    APIENTRY;         'PMSHAPI' index 116;
FUNCTION PrfQueryProfileSize(ahini:HINI;CONST pszApp,pszKey:CSTRING;
                             VAR pulReqLen:ULONG):BOOL;
                    APIENTRY;         'PMSHAPI' index 101;
FUNCTION PrfQueryProfileData(ahini:HINI;CONST pszApp,pszKey:CSTRING;VAR pBuffer;
                             VAR pulBuffLen:ULONG):BOOL;
                    APIENTRY;         'PMSHAPI' index 117;
FUNCTION PrfWriteProfileData(ahini:HINI;CONST pszApp,pszKey:CSTRING;VAR pData;
                             cchDataLen:ULONG):BOOL;
                    APIENTRY;         'PMSHAPI' index 118;
FUNCTION PrfOpenProfile(ahab:HAB;CONST pszFileName:CSTRING):HINI;
                    APIENTRY;         'PMSHAPI' index 102;
FUNCTION PrfCloseProfile(ahini:HINI):BOOL;
                    APIENTRY;         'PMSHAPI' index 103;
FUNCTION PrfReset(ahab:HAB;VAR apPrfProfile:PRFPROFILE):BOOL;
                    APIENTRY;         'PMSHAPI' index 108;
FUNCTION PrfQueryProfile(ahab:HAB;VAR apPrfProfile:PRFPROFILE):BOOL;
                    APIENTRY;         'PMSHAPI' index 107;

END;


IMPLEMENTATION

BEGIN
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Sep-06  WD         Korrektur des Typens SWBLOCK
}
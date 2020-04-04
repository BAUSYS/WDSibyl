
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PMWIN;

{****************************************************************************
 *                                                                          *
 * OS/2 Presentation Manager Window Manager unit file.                      *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def;

{Note: An ARRAY [0..x] OF CHAR is equal to a CSTRING[x] !
       CString and PSZ are null terminated strings
       PSZ is changed to PChar (^CString) in records and in
       WinRegisterclass to recognize WC_XXXX values}


CONST
     { size for fields in the font structures }
     FACESIZE                    =32;

TYPE
     FATTRS=RECORD
                  usRecordLength:USHORT;
                  fsSelection:USHORT;
                  lMatch:LONGINT;
                  szFacename:CSTRING[FACESIZE-1];
                  idRegistry:USHORT;
                  usCodePage:USHORT;
                  lMaxBaselineExt:LONGINT;
                  lAveCharWidth:LONG;
                  fsType:USHORT;
                  fsFontUse:USHORT;
           END;

TYPE
     PANOSE=RECORD
                  bFamilyType:BYTE;
                  bSerifStyle:BYTE;
                  bWeight:BYTE;
                  bProportion:BYTE;
                  bContrast:BYTE;
                  bStrokeVariation:BYTE;
                  bArmStyle:BYTE;
                  bLetterform:BYTE;
                  bMidline:BYTE;
                  bXHeight:BYTE;
                  fbPassedISO:BYTE;
                  fbFailedISO:BYTE;
            END;

     PFONTMETRICS=^FONTMETRICS;
     FONTMETRICS=RECORD
                      szFamilyname:CSTRING[FACESIZE-1];
                      szFacename:CSTRING[FACESIZE-1];
                      idRegistry:USHORT;
                      usCodePage:USHORT;
                      lEmHeight:LONG;
                      lXHeight:LONG;
                      lMaxAscender:LONG;
                      lMaxDescender:LONG;
                      lLowerCaseAscent:LONG;
                      lLowerCaseDescent:LONG;
                      lInternalLeading:LONG;
                      lExternalLeading:LONG;
                      lAveCharWidth:LONG;
                      lMaxCharInc:LONG;
                      lEmInc:LONG;
                      lMaxBaselineExt:LONG;
                      sCharSlope:SHORT;
                      sInlineDir:SHORT;
                      sCharRot:SHORT;
                      usWeightClass:USHORT;
                      usWidthClass:USHORT;
                      sXDeviceRes:SHORT;
                      sYDeviceRes:SHORT;
                      sFirstChar:SHORT;
                      sLastChar:SHORT;
                      sDefaultChar:SHORT;
                      sBreakChar:SHORT;
                      sNominalPointSize:SHORT;
                      sMinimumPointSize:SHORT;
                      sMaximumPointSize:SHORT;
                      fsType:USHORT;
                      fsDefn:USHORT;
                      fsSelection:USHORT;
                      fsCapabilities:USHORT;
                      lSubscriptXSize:LONG;
                      lSubscriptYSize:LONG;
                      lSubscriptXOffset:LONG;
                      lSubscriptYOffset:LONG;
                      lSuperscriptXSize:LONG;
                      lSuperscriptYSize:LONG;
                      lSuperscriptXOffset:LONG;
                      lSuperscriptYOffset:LONG;
                      lUnderscoreSize:LONG;
                      lUnderscorePosition:LONG;
                      lStrikeoutSize:LONG;
                      lStrikeoutPosition:LONG;
                      sKerningPairs:SHORT;
                      sFamilyClass:SHORT;
                      lMatch:LONG;
                      FamilyNameAtom:LONG;
                      FaceNameAtom:LONG;
                      _panose:PANOSE;
                 END;


{***************************************************************************
 General Window Management types, constants and macros
 ***************************************************************************}

CONST
     { Standard Window Messages }
     WM_NULL                  =$0000;
     WM_CREATE                =$0001;
     WM_DESTROY               =$0002;
     WM_ENABLE                =$0004;
     WM_SHOW                  =$0005;
     WM_MOVE                  =$0006;
     WM_SIZE                  =$0007;
     WM_ADJUSTWINDOWPOS       =$0008;
     WM_CALCVALIDRECTS        =$0009;
     WM_SETWINDOWPARAMS       =$000a;
     WM_QUERYWINDOWPARAMS     =$000b;
     WM_HITTEST               =$000c;
     WM_ACTIVATE              =$000d;
     WM_SETFOCUS              =$000f;
     WM_SETSELECTION          =$0010;
     WM_PPAINT                =$0011;
     WM_PSETFOCUS             =$0012;
     WM_PSYSCOLORCHANGE       =$0013;
     WM_PSIZE                 =$0014;
     WM_PACTIVATE             =$0015;
     WM_PCONTROL              =$0016;
     WM_COMMAND               =$0020;
     WM_SYSCOMMAND            =$0021;
     WM_HELP                  =$0022;
     WM_PAINT                 =$0023;
     WM_TIMER                 =$0024;
     WM_SEM1                  =$0025;
     WM_SEM2                  =$0026;
     WM_SEM3                  =$0027;
     WM_SEM4                  =$0028;
     WM_CLOSE                 =$0029;
     WM_QUIT                  =$002a;
     WM_SYSCOLORCHANGE        =$002b;
     WM_SYSVALUECHANGED       =$002d;
     WM_APPTERMINATENOTIFY    =$002e;
     WM_PRESPARAMCHANGED      =$002f;

     { Control notification messages }
     WM_CONTROL               =$0030;
     WM_VSCROLL               =$0031;
     WM_HSCROLL               =$0032;
     WM_INITMENU              =$0033;
     WM_MENUSELECT            =$0034;
     WM_MENUEND               =$0035;
     WM_DRAWITEM              =$0036;
     WM_MEASUREITEM           =$0037;
     WM_CONTROLPOINTER        =$0038;
     WM_QUERYDLGCODE          =$003a;
     WM_INITDLG               =$003b;
     WM_SUBSTITUTESTRING      =$003c;
     WM_MATCHMNEMONIC         =$003d;
     WM_SAVEAPPLICATION       =$003e;

     { Frame window related messages }

     WM_FLASHWINDOW           =$0040;
     WM_FORMATFRAME           =$0041;
     WM_UPDATEFRAME           =$0042;
     WM_FOCUSCHANGE           =$0043;

     WM_SETBORDERSIZE         =$0044;
     WM_TRACKFRAME            =$0045;
     WM_MINMAXFRAME           =$0046;
     WM_SETICON               =$0047;
     WM_QUERYICON             =$0048;
     WM_SETACCELTABLE         =$0049;
     WM_QUERYACCELTABLE       =$004a;
     WM_TRANSLATEACCEL        =$004b;
     WM_QUERYTRACKINFO        =$004c;
     WM_QUERYBORDERSIZE       =$004d;
     WM_NEXTMENU              =$004e;
     WM_ERASEBACKGROUND       =$004f;
     WM_QUERYFRAMEINFO        =$0050;
     WM_QUERYFOCUSCHAIN       =$0051;
     WM_OWNERPOSCHANGE        =$0052;
     WM_CALCFRAMERECT         =$0053;
     WM_WINDOWPOSCHANGED      =$0055;
     WM_ADJUSTFRAMEPOS        =$0056;
     WM_QUERYFRAMECTLCOUNT    =$0059;
     WM_QUERYHELPINFO         =$005B;
     WM_SETHELPINFO           =$005C;
     WM_ERROR                 =$005D;
     WM_REALIZEPALETTE        =$005E;

     { Key/Character input messages }
     WM_CHAR                  =$007a;
     WM_VIOCHAR               =$007b;

     { Mouse input messages }
     WM_MOUSEFIRST            =$0070;
     WM_MOUSELAST             =$0079;
     WM_BUTTONCLICKFIRST      =$0071;
     WM_BUTTONCLICKLAST       =$0079;
     WM_MOUSEMOVE             =$0070;
     WM_BUTTON1DOWN           =$0071;
     WM_BUTTON1UP             =$0072;
     WM_BUTTON1DBLCLK         =$0073;
     WM_BUTTON2DOWN           =$0074;
     WM_BUTTON2UP             =$0075;
     WM_BUTTON2DBLCLK         =$0076;
     WM_BUTTON3DOWN           =$0077;
     WM_BUTTON3UP             =$0078;
     WM_BUTTON3DBLCLK         =$0079;
     WM_MOUSEMAP              =$007D;
     WM_EXTMOUSEFIRST         =$0410;
     WM_EXTMOUSELAST          =$0419;
     WM_CHORD                 =$0410;
     WM_BUTTON1MOTIONSTART    =$0411;
     WM_BUTTON1MOTIONEND      =$0412;
     WM_BUTTON1CLICK          =$0413;
     WM_BUTTON2MOTIONSTART    =$0414;
     WM_BUTTON2MOTIONEND      =$0415;
     WM_BUTTON2CLICK          =$0416;
     WM_BUTTON3MOTIONSTART    =$0417;
     WM_BUTTON3MOTIONEND      =$0418;
     WM_BUTTON3CLICK          =$0419;
     WM_MOUSETRANSLATEFIRST   =$0420;
     WM_MOUSETRANSLATELAST    =$0428;
     WM_BEGINDRAG             =$0420;
     WM_ENDDRAG               =$0421;
     WM_SINGLESELECT          =$0422;
     WM_OPEN                  =$0423;
     WM_CONTEXTMENU           =$0424;
     WM_CONTEXTHELP           =$0425;
     WM_TEXTEDIT              =$0426;
     WM_BEGINSELECT           =$0427;
     WM_ENDSELECT             =$0428;
     WM_PENFIRST              =$04C0;
     WM_PENLAST               =$04FF;
     WM_MMPMFIRST             =$0500;
     WM_MMPMLAST              =$05FF;

     WM_HELPBASE              =$0F00;  {Start of msgs for help manager}
     WM_HELPTOP               =$0FFF;  { End of msgs for help manager }

     WM_USER                  =$1000;

     WM_MOUSEDRAG1            =$1001;  {own defined}
     WM_MOUSEDRAG2            =$1002;  {own defined}

     WM_SPEED_USER            =$1003;  {use this entry when working with OPML !}

     WM_VRNDISABLED           =$007E;
     WM_VRNENABLED            =$007F;

{ Predefined window handles }
CONST
     HWND_DESKTOP           =1;
     HWND_OBJECT            =2;
     HWND_TOP               =3;
     HWND_BOTTOM            =4;
     HWND_THREADCAPTURE     =5;

{ Standard Window Styles }
CONST
     WS_VISIBLE             =$80000000;
     WS_DISABLED            =$40000000;
     WS_CLIPCHILDREN        =$20000000;
     WS_CLIPSIBLINGS        =$10000000;
     WS_PARENTCLIP          =$08000000;
     WS_SAVEBITS            =$04000000;
     WS_SYNCPAINT           =$02000000;
     WS_MINIMIZED           =$01000000;
     WS_MAXIMIZED           =$00800000;
     WS_ANIMATE             =$00400000;

{ Dialog manager styles }
CONST
     WS_GROUP               =$00010000;
     WS_TABSTOP             =$00020000;
     WS_MULTISELECT         =$00040000;

{ Class styles }
CONST
     CS_MOVENOTIFY          =$00000001;
     CS_SIZEREDRAW          =$00000004;
     CS_HITTEST             =$00000008;
     CS_PUBLIC              =$00000010;
     CS_FRAME               =$00000020;
     CS_CLIPCHILDREN        =$20000000;
     CS_CLIPSIBLINGS        =$10000000;
     CS_PARENTCLIP          =$08000000;
     CS_SAVEBITS            =$04000000;
     CS_SYNCPAINT           =$02000000;

CONST
     PSF_LOCKWINDOWUPDATE       =$0001;
     PSF_CLIPUPWARDS            =$0002;
     PSF_CLIPDOWNWARDS          =$0004;
     PSF_CLIPSIBLINGS           =$0008;
     PSF_CLIPCHILDREN           =$0010;
     PSF_PARENTCLIP             =$0020;

{ WinScrollWindow() flags }
CONST
     SW_SCROLLCHILDREN          =$0001;
     SW_INVALIDATERGN           =$0002;

{ WinInitialize/WinTerminate Interface declarations }

TYPE
   PQVERSDATA=^QVERSDATA;
   QVERSDATA=RECORD
                  environment:USHORT;
                  version:USHORT;
             END;

CONST
   QV_OS2                     =$0000;
   QV_CMS                     =$0001;
   QV_TSO                     =$0002;
   QV_TSOBATCH                =$0003;
   QV_OS400                   =$0004;

/*** Class info structure returned by WinEnumObjectClasses ***********/
TYPE
    POBJCLASS=^OBJCLASS;
    OBJCLASS=RECORD
              pNext:POBJCLASS;         /* Null for the last structure.. */
              pszClassName:PCHAR;      /* Class name                    */
              pszModName:PCHAR;        /* Module name                   */
             END;

{ WinQueryWindow() codes }
CONST
     QW_NEXT         =0;
     QW_PREV         =1;
     QW_TOP          =2;
     QW_BOTTOM       =3;
     QW_OWNER        =4;
     QW_PARENT       =5;
     QW_NEXTTOP      =6;
     QW_PREVTOP      =7;
     QW_FRAMEOWNER   =8;

{ Values returned from WM_ADJUSTWINDOWPOS and passed to WM_WINDOWPOSCHANGED }

CONST
     AWP_MINIMIZED              =$00010000;
     AWP_MAXIMIZED              =$00020000;
     AWP_RESTORED               =$00040000;
     AWP_ACTIVATE               =$00080000;
     AWP_DEACTIVATE             =$00100000;

{ WinSetWindowPos() flags }

     SWP_SIZE                   =$0001;
     SWP_MOVE                   =$0002;
     SWP_ZORDER                 =$0004;
     SWP_SHOW                   =$0008;
     SWP_HIDE                   =$0010;
     SWP_NOREDRAW               =$0020;
     SWP_NOADJUST               =$0040;
     SWP_ACTIVATE               =$0080;
     SWP_DEACTIVATE             =$0100;
     SWP_EXTSTATECHANGE         =$0200;
     SWP_MINIMIZE               =$0400;
     SWP_MAXIMIZE               =$0800;
     SWP_RESTORE                =$1000;
     SWP_FOCUSACTIVATE          =$2000;
     SWP_FOCUSDEACTIVATE        =$4000;
     SWP_NOAUTOCLOSE            =$8000; { Valid in PROGDETAILS struct only }


{ WinDrawBitmap() flags }

CONST
     DBM_NORMAL                 =$0000;
     DBM_INVERT                 =$0001;
     DBM_HALFTONE               =$0002;
     DBM_STRETCH                =$0004;
     DBM_IMAGEATTRS             =$0008;



{*
* WinDrawText() codes:
* From DT_LEFT to DT_EXTERNALLEADING, the codes are designed to be OR'ed with
* SS_TEXT to create variations of the basic text static item.
*}

CONST
     DT_LEFT                    =$0000;
     DT_QUERYEXTENT             =$0002;
     DT_UNDERSCORE              =$0010;
     DT_STRIKEOUT               =$0020;
     DT_TEXTATTRS               =$0040;
     DT_EXTERNALLEADING         =$0080;
     DT_CENTER                  =$0100;
     DT_RIGHT                   =$0200;
     DT_TOP                     =$0000;
     DT_VCENTER                 =$0400;
     DT_BOTTOM                  =$0800;
     DT_HALFTONE                =$1000;
     DT_MNEMONIC                =$2000;
     DT_WORDBREAK               =$4000;
     DT_ERASERECT               =$8000;

{ WinDrawBorder() flags }

CONST
     DB_PATCOPY                 =$0000;
     DB_PATINVERT               =$0001;
     DB_DESTINVERT              =$0002;
     DB_AREAMIXMODE             =$0003;

     DB_ROP                     =$0007;
     DB_INTERIOR                =$0008;
     DB_AREAATTRS               =$0010;
     DB_STANDARD                =$0100;
     DB_DLGBORDER               =$0200;
     DB_RAISED                  =$0400;
     DB_DEPRESSED               =$0800;

TYPE
    HOBJECT=LONGWORD;

{ WM_CREATE structure }
TYPE
    PCREATESTRUCT=^CREATESTRUCT;
    CREATESTRUCT=RECORD
                     pPresParams:PVOID;
                     pCtlData:PVOID;
                     id:ULONG;
                     hwndInsertBehind:HWND;
                     hwndOwner:HWND;
                     cy:LONG;
                     cx:LONG;
                     y:LONG;
                     x:LONG;
                     flStyle:ULONG;
                     pszText:PChar;
                     pszClass:PChar;
                     hwndParent:HWND;
                END;

   { WinQueryClassInfo() structure }

TYPE
    PCLASSINFO=^CLASSINFO;
    CLASSINFO=RECORD
                   flClassStyle:ULONG;
                   pfnWindowProc:POINTER;
                   cbWindowData:ULONG;
              END;

{ Standard WinQueryWindowUSHORT/ULONG() indices }
CONST
     QWS_USER                   =0;
     QWS_ID                     =-1;
     QWS_MIN                    =-1;

     QWL_USER                   =0;
     QWL_STYLE                  =-2;
     QWP_PFNWP                  =-3;
     QWL_HMQ                    =-4;
     QWL_RESERVED               =-5;

     QWL_PENDATA                =-7;
     QWL_MIN                    =-7;

{ WC_FRAME WinQueryWindowUSHORT/ULONG() indices }

CONST
     QWL_HHEAP                  =$0004;
     QWL_HWNDFOCUSSAVE          =$0018;
     QWL_DEFBUTTON              =$0040;
     QWL_PSSCBLK                =$0048;
     QWL_PFEPBLK                =$004c;
     QWL_PSTATBLK               =$0050;

     QWS_FLAGS                  =$0008;
     QWS_RESULT                 =$000a;
     QWS_XRESTORE               =$000c;
     QWS_YRESTORE               =$000e;
     QWS_CXRESTORE              =$0010;
     QWS_CYRESTORE              =$0012;
     QWS_XMINIMIZE              =$0014;
     QWS_YMINIMIZE              =$0016;


{ Window enumeration }

TYPE
    HENUM=LHANDLE;

{ WM_COMMAND msg source codes }

CONST
     CMDSRC_PUSHBUTTON      =1;
     CMDSRC_MENU            =2;
     CMDSRC_ACCELERATOR     =3;
     CMDSRC_FONTDLG         =4;
     CMDSRC_FILEDLG         =5;
     CMDSRC_PRINTDLG        =6;
     CMDSRC_COLORDLG        =7;
     CMDSRC_OTHER           =0;

TYPE
    PCMDMSG=^CMDMSG;  {#pragma Pack 1}
    CMDMSG=RECORD
                 cmd:USHORT;
                 unused:USHORT;
                 source:USHORT;
                 fMouse:USHORT;
           END;

    PCHRMSG=^CHRMSG;  {#pragma Pack 1}
    CHRMSG=RECORD
                 fs:WORD;
                 cRepeat:BYTE;
                 ScanCode:BYTE;
                 chr:WORD;
                 vkey:WORD;
           END;

    PMSEMSG=^MSEMSG;  {#pragma Pack 1}
    MSEMSG=RECORD
                 x,y:INTEGER;
                 codeHitTest:WORD;
                 fsInp:WORD;
           END;


    PMQINFO=^MQINFO;
    MQINFO=RECORD
                 cb:ULONG;
                 pid:PID;
                 tid:TID;
                 cmsgs:ULONG;
                 pReserved:POINTER;
           END;

{ WinPeekMsg() constants }

CONST
     PM_REMOVE                 =$0001;
     PM_NOREMOVE               =$0000;

{ WinRegisterUserMsg direction codes }

CONST
     RUM_IN                    =1;
     RUM_OUT                   =2;
     RUM_INOUT                 =3;

{ WinSetMsgMode constants }

CONST
     SMD_DELAYED               =$0001;
     SMD_IMMEDIATE             =$0002;

{ WinSetSynchroMode constants }

CONST
     SSM_SYNCHRONOUS           =$0001;
     SSM_ASYNCHRONOUS          =$0002;
     SSM_MIXED                 =$0003;


{ WM_CALCVALIDRECTS return flags }

CONST
     CVR_ALIGNLEFT             =$0001;
     CVR_ALIGNBOTTOM           =$0002;
     CVR_ALIGNRIGHT            =$0004;
     CVR_ALIGNTOP              =$0008;
     CVR_REDRAW                =$0010;

{ WM_HITTEST return codes }

CONST
     HT_NORMAL                 =0;
     HT_TRANSPARENT            =-1;
     HT_DISCARD                =-2;
     HT_ERROR                  =-3;

{ WM_SET/QUERYWINDOWPARAMS structures and flags }

TYPE
    PWNDPARAMS=^WNDPARAMS;
    WNDPARAMS=RECORD
                   fsStatus:ULONG;
                   cchText:ULONG;
                   pszText:PChar;
                   cbPresParams:ULONG;
                   pPresParams:POINTER;
                   cbCtlData:ULONG;
                   pCtlData:POINTER;
              END;

CONST
     WPM_TEXT                   =$0001;
     WPM_CTLDATA                =$0002;
     WPM_PRESPARAMS             =$0004;
     WPM_CCHTEXT                =$0008;
     WPM_CBCTLDATA              =$0010;
     WPM_CBPRESPARAMS           =$0020;


{ WinBroadcastMsg codes }
CONST
     BMSG_POST                  =$0000;
     BMSG_SEND                  =$0001;
     BMSG_POSTQUEUE             =$0002;
     BMSG_DESCENDANTS           =$0004;
     BMSG_FRAMEONLY             =$0008;


{ WinQueryQueueStatus() constants }
CONST
      QS_KEY                     =$0001;
      QS_MOUSEBUTTON             =$0002;
      QS_MOUSEMOVE               =$0004;
      QS_MOUSE                   =$0006;   { QS_MOUSEMOVE|QS_MOUSEBUTTON }
      QS_TIMER                   =$0008;
      QS_PAINT                   =$0010;
      QS_POSTMSG                 =$0020;
      QS_SEM1                    =$0040;
      QS_SEM2                    =$0080;
      QS_SEM3                    =$0100;
      QS_SEM4                    =$0200;
      QS_SENDMSG                 =$0400;
      QS_MSGINPUT                =$0800;



TYPE
    HEV=ULONG;
    HMTX=ULONG;
    HMUX=ULONG;

{ WinSetMsgInterest()/WinSetClassMsgInterest() constants }
CONST
     SMIM_ALL                   =$0EFF;
     SMI_NOINTEREST             =$0001;
     SMI_INTEREST               =$0002;
     SMI_RESET                  =$0004;
     SMI_AUTODISPATCH           =$0008;

CONST
     FC_NOSETFOCUS              =$0001;
     FC_NOBRINGTOTOP            =FC_NOSETFOCUS;
     FC_NOLOSEFOCUS             =$0002;
     FC_NOBRINGTOPFIRSTWINDOW   =FC_NOLOSEFOCUS;
     FC_NOSETACTIVE             =$0004;
     FC_NOLOSEACTIVE            =$0008;
     FC_NOSETSELECTION          =$0010;
     FC_NOLOSESELECTION         =$0020;

     QFC_NEXTINCHAIN            =$0001;
     QFC_ACTIVE                 =$0002;
     QFC_FRAME                  =$0003;
     QFC_SELECTACTIVE           =$0004;
     QFC_PARTOFCHAIN            =$0005;

{ WM_CHAR fs field bits }
CONST
     KC_NONE                 =$0000;     { Reserved }
     KC_CHAR                 =$0001;
     KC_VIRTUALKEY           =$0002;
     KC_SCANCODE             =$0004;

     KC_SHIFT                =$0008;
     KC_CTRL                 =$0010;
     KC_ALT                  =$0020;
     KC_KEYUP                =$0040;
     KC_PREVDOWN             =$0080;
     KC_LONEKEY              =$0100;
     KC_DEADKEY              =$0200;
     KC_COMPOSITE            =$0400;
     KC_INVALIDCOMP          =$0800;

     KC_TOGGLE               =$1000;
     KC_INVALIDCHAR          =$2000;
     KC_DBCSRSRVD1           =$4000;
     KC_DBCSRSRVD2           =$8000;

CONST
     INP_NONE                  =$0000;
     INP_KBD                   =$0001;
     INP_MULT                  =$0002;
     INP_RES2                  =$0004;
     INP_SHIFT                 =$0008;
     INP_CTRL                  =$0010;
     INP_ALT                   =$0020;
     INP_RES3                  =$0040;
     INP_RES4                  =$0080;
     INP_IGNORE                =$FFFF;

{ Virtual key values }
CONST
     VK_BUTTON1                 =$01;
     VK_BUTTON2                 =$02;
     VK_BUTTON3                 =$03;
     VK_BREAK                   =$04;
     VK_BACKSPACE               =$05;
     VK_TAB                     =$06;
     VK_BACKTAB                 =$07;
     VK_NEWLINE                 =$08;
     VK_SHIFT                   =$09;
     VK_CTRL                    =$0A;
     VK_ALT                     =$0B;
     VK_ALTGRAF                 =$0C;
     VK_PAUSE                   =$0D;
     VK_CAPSLOCK                =$0E;
     VK_ESC                     =$0F;
     VK_SPACE                   =$10;
     VK_PAGEUP                  =$11;
     VK_PAGEDOWN                =$12;
     VK_END                     =$13;
     VK_HOME                    =$14;
     VK_LEFT                    =$15;
     VK_UP                      =$16;
     VK_RIGHT                   =$17;
     VK_DOWN                    =$18;
     VK_PRINTSCRN               =$19;
     VK_INSERT                  =$1A;
     VK_DELETE                  =$1B;
     VK_SCRLLOCK                =$1C;
     VK_NUMLOCK                 =$1D;
     VK_ENTER                   =$1E;
     VK_SYSRQ                   =$1F;
     VK_F1                      =$20;
     VK_F2                      =$21;
     VK_F3                      =$22;
     VK_F4                      =$23;
     VK_F5                      =$24;
     VK_F6                      =$25;
     VK_F7                      =$26;
     VK_F8                      =$27;
     VK_F9                      =$28;
     VK_F10                     =$29;
     VK_F11                     =$2A;
     VK_F12                     =$2B;
     VK_F13                     =$2C;
     VK_F14                     =$2D;
     VK_F15                     =$2E;
     VK_F16                     =$2F;
     VK_F17                     =$30;
     VK_F18                     =$31;
     VK_F19                     =$32;
     VK_F20                     =$33;
     VK_F21                     =$34;
     VK_F22                     =$35;
     VK_F23                     =$36;
     VK_F24                     =$37;
     VK_ENDDRAG                 =$38;
     VK_CLEAR                   =$39;
     VK_EREOF                   =$3A;
     VK_PA1                     =$3B;


     VK_MENU                    =VK_F10;
     VK_DBCSFIRST               =$0080;
     VK_DBCSLAST                =$00ff;

     VK_USERFIRST               =$0100;
     VK_USERLAST                =$01ff;

{ Journal Notification messages  }
CONST
     WM_JOURNALNOTIFY           =$007c;

CONST
     JRN_QUEUESTATUS            =$00000001;
     JRN_PHYSKEYSTATE           =$00000002;


{ Special item IDs }
CONST
     DID_OK      =1;
     DID_CANCEL  =2;
     DID_ERROR   =$ffff;

{ WinAlarm Codes }
CONST
     WA_WARNING                 =0;
     WA_NOTE                    =1;
     WA_ERROR                   =2;
     WA_CWINALARMS             =13;


{ Message box types }
CONST
    MB_OK                      =$0000;
    MB_OKCANCEL                =$0001;
    MB_RETRYCANCEL             =$0002;
    MB_ABORTRETRYIGNORE        =$0003;
    MB_YESNO                   =$0004;
    MB_YESNOCANCEL             =$0005;
    MB_CANCEL                  =$0006;
    MB_ENTER                   =$0007;
    MB_ENTERCANCEL             =$0008;

    MB_NOICON                  =$0000;
    MB_CUANOTIFICATION         =$0000;
    MB_ICONQUESTION            =$0010;
    MB_ICONEXCLAMATION         =$0020;
    MB_CUAWARNING              =$0020;
    MB_ICONASTERISK            =$0030;
    MB_ICONHAND                =$0040;
    MB_CUACRITICAL             =$0040;
    MB_QUERY                   =MB_ICONQUESTION;
    MB_WARNING                 =MB_CUAWARNING;
    MB_INFORMATION             =MB_ICONASTERISK;
    MB_CRITICAL                =MB_CUACRITICAL;
    MB_ERROR                   =MB_CRITICAL;

    MB_DEFBUTTON1              =$0000;
    MB_DEFBUTTON2              =$0100;
    MB_DEFBUTTON3              =$0200;

    MB_APPLMODAL               =$0000;
    MB_SYSTEMMODAL             =$1000;
    MB_HELP                    =$2000;
    MB_MOVEABLE                =$4000;


{ Message box return codes }

CONST
    MBID_OK                    =1;
    MBID_CANCEL                =2;
    MBID_ABORT                 =3;
    MBID_RETRY                 =4;
    MBID_IGNORE                =5;
    MBID_YES                   =6;
    MBID_NO                    =7;
    MBID_HELP                  =8;
    MBID_ENTER                 =9;
    MBID_ERROR                 =$ffff;

{ Dialog codes: returned by WM_QUERYDLGCODE msg }

CONST
    DLGC_ENTRYFIELD    =$0001;  { Entry field item understands EM_SETSEL) }
    DLGC_BUTTON        =$0002;  { Button item                             }
    DLGC_RADIOBUTTON   =$0004;  { Radio button                            }
    DLGC_STATIC        =$0008;  { Static item                             }
    DLGC_DEFAULT       =$0010;  { Default push button                     }
    DLGC_PUSHBUTTON    =$0020;  { Normal (Non-default) push button        }
    DLGC_CHECKBOX      =$0040;  { Check box button control                }
    DLGC_SCROLLBAR     =$0080;  { Scroll bar                              }
    DLGC_MENU          =$0100;  { Menu                                    }
    DLGC_TABONCLICK    =$0200;
    DLGC_MLE           =$0400;  { Multiple Line Entry                     }

{ WinEnumDlgItem() constants }
CONST
    EDI_FIRSTTABITEM           =0;
    EDI_LASTTABITEM            =1;
    EDI_NEXTTABITEM            =2;
    EDI_PREVTABITEM            =3;
    EDI_FIRSTGROUPITEM         =4;
    EDI_LASTGROUPITEM          =5;
    EDI_NEXTGROUPITEM          =6;
    EDI_PREVGROUPITEM          =7;

{ Dialog template definitions }

TYPE
    PDLGITEM=^DLGITEM;
    DLGITEM=RECORD  {pack 2}
                  fsItemStatus:USHORT;
                  cChildren:USHORT;
                  cchClassName:USHORT;
                  offClassName:USHORT;
                  cchText:USHORT;
                  offText:USHORT;
                  flStyle:ULONG;
                  x:INTEGER;
                  y:INTEGER;
                  cx:INTEGER;
                  cy:INTEGER;
                  id:USHORT;
                  offPresParams:USHORT;
                  offCtlData:USHORT;
           END;

{ Dialog Template structure }

TYPE
    PDLGTEMPLATE=^DLGTEMPLATE;
    DLGTEMPLATE=RECORD  {pack 2}
                      cbTemplate:USHORT;
                      atype:USHORT;
                      codepage:USHORT;
                      offadlgti:USHORT;
                      fsTemplateStatus:USHORT;
                      iItemFocus:USHORT;
                      coffPresParams:USHORT;
                      adlgti:ARRAY[0..0] OF DLGITEM;
                END;


{ Static Control Manager }

{* Static control styles:***************************************************
 *                                                                         *
 * NOTE: the top 9 bits of the LOUSHORT of the window flStyle are used for   *
 * DT_* flags.  The lower 7 bits are for SS_* styles.  This gives us up    *
 * to 128 distinct static control types (we currently use 11 of them).     *
 ***************************************************************************}

CONST
    SS_TEXT                    =$0001;
    SS_GROUPBOX                =$0002;

    SS_ICON                    =$0003;
    SS_BITMAP                  =$0004;
    SS_FGNDRECT                =$0005;
    SS_HALFTONERECT            =$0006;
    SS_BKGNDRECT               =$0007;
    SS_FGNDFRAME               =$0008;
    SS_HALFTONEFRAME           =$0009;
    SS_BKGNDFRAME              =$000a;
    SS_SYSICON                 =$000b;
    SS_AUTOSIZE                =$0040;


{ Static control messages }

CONST
    SM_SETHANDLE               =$0100;
    SM_QUERYHANDLE             =$0101;

{ Button control styles }

CONST
    BS_PUSHBUTTON              =0;
    BS_CHECKBOX                =1;
    BS_AUTOCHECKBOX            =2;
    BS_RADIOBUTTON             =3;
    BS_AUTORADIOBUTTON         =4;
    BS_3STATE                  =5;
    BS_AUTO3STATE              =6;

    BS_USERBUTTON              =7;
    BS_PRIMARYSTYLES           =$000f;

    BS_BITMAP                  =$0040;
    BS_ICON                    =$0080;
    BS_HELP                    =$0100;
    BS_SYSCOMMAND              =$0200;
    BS_DEFAULT                 =$0400;
    BS_NOPOINTERFOCUS          =$0800;
    BS_NOBORDER                =$1000;
    BS_NOCURSORSELECT          =$2000;
    BS_AUTOSIZE                =$4000;


TYPE
    PBTNCDATA=^BTNCDATA;
    BTNCDATA=RECORD  {pack 2}
                  cb:USHORT;
                  fsCheckState:USHORT;
                  fsHiliteState:USHORT;
                  hImage:LHANDLE;
             END;

{ User button structure (passed in WM_CONTROL msg) }

TYPE
    PUSERBUTTON=^USERBUTTON;
    USERBUTTON=RECORD
                     hwnd:HWND;
                     hps:HPS;
                     fsState:ULONG;
                     fsStateOld:ULONG;
               END;
{ Button control messages }

CONST
    BM_CLICK                   =$0120;
    BM_QUERYCHECKINDEX         =$0121;
    BM_QUERYHILITE             =$0122;
    BM_SETHILITE               =$0123;
    BM_QUERYCHECK              =$0124;
    BM_SETCHECK                =$0125;
    BM_SETDEFAULT              =$0126;

{ Button notification codes }

CONST
    BN_CLICKED                 =1;
    BN_DBLCLICKED              =2;
    BN_PAINT                   =3;

{ BN_PAINT button draw state codes (must be in high byte) }

CONST
    BDS_HILITED                =$0100;
    BDS_DISABLED               =$0200;
    BDS_DEFAULT                =$0400;

{ Entry field  styles }

CONST
     ES_LEFT                    =$00000000;
     ES_CENTER                  =$00000001;
     ES_RIGHT                   =$00000002;
     ES_AUTOSCROLL              =$00000004;

     ES_MARGIN                  =$00000008;
     ES_AUTOTAB                 =$00000010;
     ES_READONLY                =$00000020;
     ES_COMMAND                 =$00000040;
     ES_UNREADABLE              =$00000080;
     ES_AUTOSIZE                =$00000200;

     ES_ANY                     =$00000000;
     ES_SBCS                    =$00001000;
     ES_DBCS                    =$00002000;
     ES_MIXED                   =$00003000;


{ combo box styles }

CONST
    CBS_SIMPLE                 =$0001;
    CBS_DROPDOWN               =$0002;
    CBS_DROPDOWNLIST           =$0004;
    CBS_COMPATIBLE             =$0008;

{ IDs of combobox entry field and listbox. }

CONST
    CBID_LIST                  =$029A;
    CBID_EDIT                  =$029B;

    CBM_SHOWLIST               =$0170;
    CBM_HILITE                 =$0171;
    CBM_ISLISTSHOWING          =$0172;

    CBN_EFCHANGE               =1;
    CBN_EFSCROLL               =2;
    CBN_MEMERROR               =3;
    CBN_LBSELECT               =4;
    CBN_LBSCROLL               =5;
    CBN_SHOWLIST               =6;
    CBN_ENTER                  =7;

TYPE
    PENTRYFDATA=^ENTRYFDATA;
    ENTRYFDATA=RECORD {pack 2}
                     cb:USHORT;
                     cchEditLimit:USHORT;
                     ichMinSel:USHORT;
                     ichMaxSel:USHORT;
               END;

{ Entry Field  messages }

CONST
    EM_QUERYCHANGED            =$0140;
    EM_QUERYSEL                =$0141;
    EM_SETSEL                  =$0142;
    EM_SETTEXTLIMIT            =$0143;

    EM_CUT                     =$0144;
    EM_COPY                    =$0145;
    EM_CLEAR                   =$0146;
    EM_PASTE                   =$0147;
    EM_QUERYFIRSTCHAR          =$0148;
    EM_SETFIRSTCHAR            =$0149;
    EM_QUERYREADONLY           =$014a;
    EM_SETREADONLY             =$014b;
    EM_SETINSERTMODE           =$014c;

{ Entry Field notification messages }

CONST
    EN_SETFOCUS                =$0001;
    EN_KILLFOCUS               =$0002;
    EN_CHANGE                  =$0004;
    EN_SCROLL                  =$0008;
    EN_MEMERROR                =$0010;
    EN_OVERFLOW                =$0020;
    EN_INSERTMODETOGGLE        =$0040;


{ List box styles }

CONST
    LS_MULTIPLESEL             =$00000001;
    LS_OWNERDRAW               =$00000002;
    LS_NOADJUSTPOS             =$00000004;
    LS_HORZSCROLL              =$00000008;
    LS_EXTENDEDSEL             =$00000010;


{ List box notification messages }

CONST
    LN_SELECT                  =1;
    LN_SETFOCUS                =2;
    LN_KILLFOCUS               =3;
    LN_SCROLL                  =4;
    LN_ENTER                   =5;

{ List box messages }

TYPE
   PLBOXINFO=^LBOXINFO;
   LBOXINFO=RECORD
                 lItemIndex:LONGINT;
                 ulItemCount:LONGWORD;
                 reserved:LONGWORD;
                 reserved2:LONGWORD;
   END;

CONST
   LM_QUERYITEMCOUNT          =$0160;
   LM_INSERTITEM              =$0161;
   LM_SETTOPINDEX             =$0162;
   LM_DELETEITEM              =$0163;
   LM_SELECTITEM              =$0164;
   LM_QUERYSELECTION          =$0165;
   LM_SETITEMTEXT             =$0166;
   LM_QUERYITEMTEXTLENGTH     =$0167;
   LM_QUERYITEMTEXT           =$0168;

   LM_SETITEMHANDLE           =$0169;
   LM_QUERYITEMHANDLE         =$016a;
   LM_SEARCHSTRING            =$016b;
   LM_SETITEMHEIGHT           =$016c;
   LM_QUERYTOPINDEX           =$016d;
   LM_DELETEALL               =$016e;
   LM_INSERTMULTITEMS         =$016f;
   LM_SETITEMWIDTH            =$0660;

{ List box constants }

CONST
    LIT_CURSOR                =-4;
    LIT_ERROR                 =-3;
    LIT_MEMERROR              =-2;
    LIT_NONE                  =-1;
    LIT_FIRST                 =-1;

{ For LM_INSERTITEM msg }

CONST
    LIT_END                   =-1;
    LIT_SORTASCENDING         =-2;
    LIT_SORTDESCENDING        =-3;

{ For LM_SEARCHSTRING msg }

    LSS_SUBSTRING             =$0001;
    LSS_PREFIX                =$0002;
    LSS_CASESENSITIVE         =$0004;


{ Menu control styles }

CONST
    MS_ACTIONBAR               =$00000001;
    MS_TITLEBUTTON             =$00000002;
    MS_VERTICALFLIP            =$00000004;

    MS_CONDITIONALCASCADE      =$00000040;



{ Menu control messages }
CONST
    MM_INSERTITEM              =$0180;
    MM_DELETEITEM              =$0181;
    MM_QUERYITEM               =$0182;
    MM_SETITEM                 =$0183;
    MM_QUERYITEMCOUNT          =$0184;
    MM_STARTMENUMODE           =$0185;
    MM_ENDMENUMODE             =$0186;
    MM_REMOVEITEM              =$0188;
    MM_SELECTITEM              =$0189;
    MM_QUERYSELITEMID          =$018a;
    MM_QUERYITEMTEXT           =$018b;
    MM_QUERYITEMTEXTLENGTH     =$018c;
    MM_SETITEMHANDLE           =$018d;
    MM_SETITEMTEXT             =$018e;
    MM_ITEMPOSITIONFROMID      =$018f;
    MM_ITEMIDFROMPOSITION      =$0190;
    MM_QUERYITEMATTR           =$0191;
    MM_SETITEMATTR             =$0192;
    MM_ISITEMVALID             =$0193;
    MM_QUERYITEMRECT           =$0194;
    MM_DELETEITEMBYPOS         =$01f1;  {UNDOCUMENTED}

    MM_QUERYDEFAULTITEMID      =$0431;
    MM_SETDEFAULTITEMID        =$0432;


TYPE
    PMTI=^MTI;
    MTI=RECORD
              afStyle:USHORT;
              pad:USHORT;
              idItem:USHORT;
              c:ARRAY[0..1] OF CHAR;
        END;

    PMT=^MT;
    MT=RECORD
             len:ULONG;
             codepage:USHORT;
             reserved:USHORT;
             cMti:USHORT;
             rgMti:MTI;
       END;

TYPE
    POWNERITEM=^OWNERITEM;
    OWNERITEM=RECORD
                   hwnd:HWND;
                   hps:HPS;
                   fsState:ULONG;
                   fsAttribute:ULONG;
                   fsStateOld:ULONG;
                   fsAttributeOld:ULONG;
                   rclItem:RECTL;
                   idItem:LONG;
                   hItem:ULONG;
              END;

    PMENUITEM=^MENUITEM;
    MENUITEM=RECORD {pack 2}
                  iPosition:INTEGER;
                  afStyle:USHORT;
                  afAttribute:USHORT;
                  id:USHORT;
                  hwndSubMenu:HWND;
                  hItem:ULONG;
             END;

CONST
    MIT_END                    =-1;
    MIT_NONE                   =-1;
    MIT_MEMERROR               =-1;
    MIT_ERROR                  =-1;
    MIT_FIRST                  =-2;
    MIT_LAST                   =-3;
    MID_NONE                   =MIT_NONE;
    MID_ERROR                  =-1;

{ Menu item styles & attributes }

CONST
    MIS_TEXT                   =$0001;

    MIS_BITMAP                 =$0002;
    MIS_SEPARATOR              =$0004;

    MIS_OWNERDRAW              =$0008;

    MIS_SUBMENU                =$0010;
    MIS_MULTMENU               =$0020; { multiple choice submenu     }
    MIS_SYSCOMMAND             =$0040;
    MIS_HELP                   =$0080;
    MIS_STATIC                 =$0100;
    MIS_BUTTONSEPARATOR        =$0200;
    MIS_BREAK                  =$0400;
    MIS_BREAKSEPARATOR         =$0800;
    MIS_GROUP                  =$1000; { multiple choice group start }
    MIS_SINGLE                 =$2000;

    MIA_NODISMISS              =$0020;
    MIA_FRAMED                 =$1000;
    MIA_CHECKED                =$2000;
    MIA_DISABLED               =$4000;
    MIA_HILITED                =$8000;


{ Values of fs in WinPopupMenu call }
CONST
   PU_POSITIONONITEM          =$0001;

   PU_HCONSTRAIN              =$0002;
   PU_VCONSTRAIN              =$0004;

   PU_NONE                    =$0000;
   PU_MOUSEBUTTON1DOWN        =$0008;
   PU_MOUSEBUTTON2DOWN        =$0010;
   PU_MOUSEBUTTON3DOWN        =$0018;

   PU_SELECTITEM              =$0020;

   PU_MOUSEBUTTON1            =$0040;
   PU_MOUSEBUTTON2            =$0080;
   PU_MOUSEBUTTON3            =$0100;
   PU_KEYBOARD                =$0200;

{ Scroll Bar styles }

CONST
    SBS_HORZ                  =0;
    SBS_VERT                  =1;
    SBS_THUMBSIZE             =2;
    SBS_AUTOTRACK             =4;
    SBS_AUTOSIZE              =$2000;

{ Scroll Bar messages }

CONST
   SBM_SETSCROLLBAR           =$01a0;
   SBM_SETPOS                 =$01a1;
   SBM_QUERYPOS               =$01a2;
   SBM_QUERYRANGE             =$01a3;
   SBM_SETTHUMBSIZE           =$01a6;

{ Scroll Bar Commands }

CONST
   SB_LINEUP                  =1;
   SB_LINEDOWN                =2;
   SB_LINELEFT                =1;
   SB_LINERIGHT               =2;
   SB_PAGEUP                  =3;
   SB_PAGEDOWN                =4;
   SB_PAGELEFT                =3;
   SB_PAGERIGHT               =4;
   SB_SLIDERTRACK             =5;
   SB_SLIDERPOSITION          =6;
   SB_ENDSCROLL               =7;


TYPE
    PSBCDATA=^SBCDATA;
    SBCDATA=RECORD {pack 2}
                 cb:USHORT;
                 sHilite:USHORT;
                 posFirst:INTEGER;
                 posLast:INTEGER;
                 posThumb:INTEGER;
                 cVisible:INTEGER;
                 cTotal:INTEGER;
            END;

   PFRAMECDATA=^FRAMECDATA;
   FRAMECDATA=RECORD {pack 2}
                   cb:USHORT;
                   flCreateFlags:ULONG;
                   hmodResources:USHORT;
                   idResources:USHORT;
              END;

{ Frame window styles }

CONST
   FCF_TITLEBAR               =$00000001;
   FCF_SYSMENU                =$00000002;
   FCF_MENU                   =$00000004;
   FCF_SIZEBORDER             =$00000008;
   FCF_MINBUTTON              =$00000010;
   FCF_MAXBUTTON              =$00000020;
   FCF_MINMAX                 =$00000030;
   FCF_VERTSCROLL             =$00000040;
   FCF_HORZSCROLL             =$00000080;
   FCF_DLGBORDER              =$00000100;
   FCF_BORDER                 =$00000200;
   FCF_SHELLPOSITION          =$00000400;
   FCF_TASKLIST               =$00000800;
   FCF_NOBYTEALIGN            =$00001000;
   FCF_NOMOVEWITHOWNER        =$00002000;
   FCF_ICON                   =$00004000;
   FCF_ACCELTABLE             =$00008000;
   FCF_SYSMODAL               =$00010000;
   FCF_SCREENALIGN            =$00020000;
   FCF_MOUSEALIGN             =$00040000;
   FCF_HIDEBUTTON             =$01000000;
   FCF_HIDEMAX                =$01000020;
   FCF_DBE_APPSTAT            =$80000000;
   FCF_AUTOICON               =$40000000;
   FCF_STANDARD               =$0000CC3F;

   FS_ICON                    =$00000001;
   FS_ACCELTABLE              =$00000002;
   FS_SHELLPOSITION           =$00000004;
   FS_TASKLIST                =$00000008;
   FS_NOBYTEALIGN             =$00000010;
   FS_NOMOVEWITHOWNER         =$00000020;
   FS_SYSMODAL                =$00000040;
   FS_DLGBORDER               =$00000080;
   FS_BORDER                  =$00000100;
   FS_SCREENALIGN             =$00000200;
   FS_MOUSEALIGN              =$00000400;
   FS_SIZEBORDER              =$00000800;
   FS_DBE_APPSTAT             =$00008000;
   FS_STANDARD                =$0000000F;


{ Frame Window Flags accessed via WinSet/QueryWindowUSHORT(QWS_FLAGS) }

CONST
     FF_FLASHWINDOW             =$0001;
     FF_ACTIVE                  =$0002;
     FF_FLASHHILITE             =$0004;
     FF_OWNERHIDDEN             =$0008;
     FF_DLGDISMISSED            =$0010;
     FF_OWNERDISABLED           =$0020;
     FF_SELECTED                =$0040;
     FF_NOACTIVATESWP           =$0080;

{ WM_QUERYFRAMEINFO constants }

CONST
     FI_FRAME                =$00000001;
     FI_OWNERHIDE            =$00000002;
     FI_ACTIVATEOK           =$00000004;
     FI_NOMOVEWITHOWNER      =$00000008;

TYPE
    HSAVEWP=LHANDLE;


{ Frame control IDs    }

CONST
   FID_SYSMENU                =$8002;
   FID_TITLEBAR               =$8003;
   FID_MINMAX                 =$8004;
   FID_MENU                   =$8005;
   FID_VERTSCROLL             =$8006;
   FID_HORZSCROLL             =$8007;
   FID_CLIENT                 =$8008;
   { Note =$8009 is reserved }
   FID_DBE_APPSTAT            =$8010;
   FID_DBE_KBDSTAT            =$8011;
   FID_DBE_PECIC              =$8012;
   FID_DBE_KKPOPUP            =$8013;

{ Standard WM_SYSCOMMAND command values }

CONST
   SC_SIZE                    =$8000;
   SC_MOVE                    =$8001;
   SC_MINIMIZE                =$8002;
   SC_MAXIMIZE                =$8003;
   SC_CLOSE                   =$8004;
   SC_NEXT                    =$8005;
   SC_APPMENU                 =$8006;
   SC_SYSMENU                 =$8007;
   SC_RESTORE                 =$8008;
   SC_NEXTFRAME               =$8009;
   SC_NEXTWINDOW              =$8010;
   SC_TASKMANAGER             =$8011;
   SC_HELPKEYS                =$8012;
   SC_HELPINDEX               =$8013;
   SC_HELPEXTENDED            =$8014;
   SC_SWITCHPANELIDS          =$8015;
   SC_DBE_FIRST               =$8018;
   SC_DBE_LAST                =$801F;

   SC_BEGINDRAG               =$8020;
   SC_ENDDRAG                 =$8021;
   SC_SELECT                  =$8022;
   SC_OPEN                    =$8023;
   SC_CONTEXTMENU             =$8024;
   SC_CONTEXTHELP             =$8025;
   SC_TEXTEDIT                =$8026;
   SC_BEGINSELECT             =$8027;
   SC_ENDSELECT               =$8028;
   SC_WINDOW                  =$8029;
   SC_HIDE                    =$802a;


{ Title bar control messages }

CONST
   TBM_SETHILITE              =$01e3;
   TBM_QUERYHILITE            =$01e4;


CONST
    SV_SWAPBUTTON              =0;
    SV_DBLCLKTIME              =1;
    SV_CXDBLCLK                =2;
    SV_CYDBLCLK                =3;
    SV_CXSIZEBORDER            =4;
    SV_CYSIZEBORDER            =5;
    SV_ALARM                   =6;

    SV_RESERVEDFIRST1          =7;
    SV_RESERVEDLAST1           =8;

    SV_CURSORRATE              =9;
    SV_FIRSTSCROLLRATE         =10;
    SV_SCROLLRATE              =11;
    SV_NUMBEREDLISTS           =12;
    SV_WARNINGFREQ             =13;
    SV_NOTEFREQ                =14;
    SV_ERRORFREQ               =15;
    SV_WARNINGDURATION         =16;
    SV_NOTEDURATION            =17;
    SV_ERRORDURATION           =18;

    SV_RESERVEDFIRST           =19;
    SV_RESERVEDLAST            =19;

    SV_CXSCREEN                =20;
    SV_CYSCREEN                =21;
    SV_CXVSCROLL               =22;
    SV_CYHSCROLL               =23;
    SV_CYVSCROLLARROW          =24;
    SV_CXHSCROLLARROW          =25;
    SV_CXBORDER                =26;
    SV_CYBORDER                =27;
    SV_CXDLGFRAME              =28;
    SV_CYDLGFRAME              =29;
    SV_CYTITLEBAR              =30;
    SV_CYVSLIDER               =31;
    SV_CXHSLIDER               =32;
    SV_CXMINMAXBUTTON          =33;
    SV_CYMINMAXBUTTON          =34;
    SV_CYMENU                  =35;
    SV_CXFULLSCREEN            =36;
    SV_CYFULLSCREEN            =37;
    SV_CXICON                  =38;
    SV_CYICON                  =39;
    SV_CXPOINTER               =40;
    SV_CYPOINTER               =41;

    SV_DEBUG                   =42;
    SV_CMOUSEBUTTONS           =43;
    SV_CPOINTERBUTTONS         =43;
    SV_POINTERLEVEL            =44;
    SV_CURSORLEVEL             =45;
    SV_TRACKRECTLEVEL          =46;

    SV_CTIMERS                 =47;

    SV_MOUSEPRESENT            =48;

    SV_CXBYTEALIGN             =49;
    SV_CXALIGN                 =49;
    SV_CYBYTEALIGN             =50;
    SV_CYALIGN                 =50;

    SV_NOTRESERVED             =56;
    SV_EXTRAKEYBEEP            =57;

    SV_SETLIGHTS               =58;
    SV_INSERTMODE              =59;


    SV_MENUROLLDOWNDELAY       =64;
    SV_MENUROLLUPDELAY         =65;
    SV_ALTMNEMONIC             =66;
    SV_TASKLISTMOUSEACCESS     =67;

    SV_CXICONTEXTWIDTH         =68;
    SV_CICONTEXTLINES          =69;

    SV_CHORDTIME               =70;
    SV_CXCHORD                 =71;
    SV_CYCHORD                 =72;
    SV_CXMOTIONSTART           =73;
    SV_CYMOTIONSTART           =74;

    SV_BEGINDRAG               =75;
    SV_ENDDRAG                 =76;
    SV_SINGLESELECT            =77;
    SV_OPEN                    =78;
    SV_CONTEXTMENU             =79;
    SV_CONTEXTHELP             =80;
    SV_TEXTEDIT                =81;
    SV_BEGINSELECT             =82;
    SV_ENDSELECT               =83;

    SV_BEGINDRAGKB             =84;
    SV_ENDDRAGKB               =85;
    SV_SELECTKB                =86;
    SV_OPENKB                  =87;
    SV_CONTEXTMENUKB           =88;
    SV_CONTEXTHELPKB           =89;
    SV_TEXTEDITKB              =90;
    SV_BEGINSELECTKB           =91;
    SV_ENDSELECTKB             =92;

    SV_ANIMATION               =93;
    SV_ANIMATIONSPEED          =94;

    SV_MONOICONS               =95;

    SV_KBDALTERED              =96;

    SV_PRINTSCREEN             =97;

    SV_CSYSVALUES              =98;

{ Presentation parameter structures. }

TYPE
    PPARAM=^PARAM;
    PARAM=RECORD
                id:ULONG;
                cb:ULONG;
                ab:ULONG;
          END;

    PPRESPARAMS=^PRESPARAMS;
    PRESPARAMS=RECORD
                     cb:ULONG;
                     param:ARRAY[0..100] OF PARAM;
               END;




{ Presentation parameter types. }
CONST
   PP_FOREGROUNDCOLOR                      =1;
   PP_FOREGROUNDCOLORINDEX                 =2;
   PP_BACKGROUNDCOLOR                      =3;
   PP_BACKGROUNDCOLORINDEX                 =4;
   PP_HILITEFOREGROUNDCOLOR                =5;
   PP_HILITEFOREGROUNDCOLORINDEX           =6;
   PP_HILITEBACKGROUNDCOLOR                =7;
   PP_HILITEBACKGROUNDCOLORINDEX           =8;
   PP_DISABLEDFOREGROUNDCOLOR              =9;
   PP_DISABLEDFOREGROUNDCOLORINDEX         =10;
   PP_DISABLEDBACKGROUNDCOLOR              =11;
   PP_DISABLEDBACKGROUNDCOLORINDEX         =12;
   PP_BORDERCOLOR                          =13;
   PP_BORDERCOLORINDEX                     =14;
   PP_FONTNAMESIZE                         =15;
   PP_FONTHANDLE                           =16;
   PP_RESERVED                             =17;
   PP_ACTIVECOLOR                          =18;
   PP_ACTIVECOLORINDEX                     =19;
   PP_INACTIVECOLOR                        =20;
   PP_INACTIVECOLORINDEX                   =21;
   PP_ACTIVETEXTFGNDCOLOR                  =22;
   PP_ACTIVETEXTFGNDCOLORINDEX             =23;
   PP_ACTIVETEXTBGNDCOLOR                  =24;
   PP_ACTIVETEXTBGNDCOLORINDEX             =25;
   PP_INACTIVETEXTFGNDCOLOR                =26;
   PP_INACTIVETEXTFGNDCOLORINDEX           =27;
   PP_INACTIVETEXTBGNDCOLOR                =28;
   PP_INACTIVETEXTBGNDCOLORINDEX           =29;
   PP_SHADOW                               =30;
   PP_MENUFOREGROUNDCOLOR                  =31;   // Menu foreground color
   PP_MENUFOREGROUNDCOLORINDEX             =32;
   PP_MENUBACKGROUNDCOLOR                  =33;   // Menu background color
   PP_MENUBACKGROUNDCOLORINDEX             =34;
   PP_MENUHILITEFGNDCOLOR                  =35;   // Menu highlighted foreground color
   PP_MENUHILITEFGNDCOLORINDEX             =36;
   PP_MENUHILITEBGNDCOLOR                  =37;   // Menu highlighted background color
   PP_MENUHILITEBGNDCOLORINDEX             =38;
   PP_MENUDISABLEDFGNDCOLOR                =39;   // Menu disabled foreground color
   PP_MENUDISABLEDFGNDCOLORINDEX           =40;
   PP_MENUDISABLEDBGNDCOLOR                =41;   // Menu disabled background color
   PP_MENUDISABLEDBGNDCOLORINDEX           =42;

   PP_USER                                 =$8000;

{ Flags for WinQueryPresParams() }

CONST
   QPF_NOINHERIT            =$0001;
   QPF_ID1COLORINDEX        =$0002;
   QPF_ID2COLORINDEX        =$0004;
   QPF_PURERGBCOLOR         =$0008;
   QPF_VALIDFLAGS           =$000F;


CONST
   SYSCLR_SHADOWHILITEBGND         =-50;
   SYSCLR_SHADOWHILITEFGND         =-49;
   SYSCLR_SHADOWTEXT               =-48;
   SYSCLR_ENTRYFIELD               =-47;
   SYSCLR_MENUDISABLEDTEXT         =-46;
   SYSCLR_MENUHILITE               =-45;
   SYSCLR_MENUHILITEBGND           =-44;
   SYSCLR_PAGEBACKGROUND           =-43;
   SYSCLR_FIELDBACKGROUND          =-42;
   SYSCLR_BUTTONLIGHT              =-41;
   SYSCLR_BUTTONMIDDLE             =-40;
   SYSCLR_BUTTONDARK               =-39;
   SYSCLR_BUTTONDEFAULT            =-38;
   SYSCLR_TITLEBOTTOM              =-37;
   SYSCLR_SHADOW                   =-36;
   SYSCLR_ICONTEXT                 =-35;
   SYSCLR_DIALOGBACKGROUND         =-34;
   SYSCLR_HILITEFOREGROUND         =-33;
   SYSCLR_HILITEBACKGROUND         =-32;
   SYSCLR_INACTIVETITLETEXTBGND    =-31;
   SYSCLR_ACTIVETITLETEXTBGND      =-30;
   SYSCLR_INACTIVETITLETEXT        =-29;
   SYSCLR_ACTIVETITLETEXT          =-28;
   SYSCLR_OUTPUTTEXT               =-27;
   SYSCLR_WINDOWSTATICTEXT         =-26;
   SYSCLR_SCROLLBAR                =-25;
   SYSCLR_BACKGROUND               =-24;
   SYSCLR_ACTIVETITLE              =-23;
   SYSCLR_INACTIVETITLE            =-22;
   SYSCLR_MENU                     =-21;
   SYSCLR_WINDOW                   =-20;
   SYSCLR_WINDOWFRAME              =-19;
   SYSCLR_MENUTEXT                 =-18;
   SYSCLR_WINDOWTEXT               =-17;
   SYSCLR_TITLETEXT                =-16;
   SYSCLR_ACTIVEBORDER             =-15;
   SYSCLR_INACTIVEBORDER           =-14;
   SYSCLR_APPWORKSPACE             =-13;
   SYSCLR_HELPBACKGROUND           =-12;
   SYSCLR_HELPTEXT                 =-11;
   SYSCLR_HELPHILITE               =-10;

   SYSCLR_CSYSCOLORS               =41;

   { default color table indices }

      CLR_FALSE                =-5;
      CLR_TRUE                 =-4;
      CLR_ERROR                =-255;
      CLR_DEFAULT              =-3;
      CLR_WHITE                =-2;
      CLR_BLACK                =-1;
      CLR_BACKGROUND           = 0;
      CLR_BLUE                 = 1;
      CLR_RED                  = 2;
      CLR_PINK                 = 3;
      CLR_GREEN                = 4;
      CLR_CYAN                 = 5;
      CLR_YELLOW               = 6;
      CLR_NEUTRAL              = 7;
      CLR_DARKGRAY             = 8;
      CLR_DARKBLUE             = 9;
      CLR_DARKRED              = 10;
      CLR_DARKPINK             = 11;
      CLR_DARKGREEN            = 12;
      CLR_DARKCYAN             = 13;
      CLR_BROWN                = 14;
      CLR_PALEGRAY             = 15;

{Jens}
CONST
     TID_CURSOR          =$ffff;
     TID_SCROLL          =$fffe;
     TID_FLASHWINDOW     =$fffd;
     TID_DELAY_END       =$81ff;
     TID_DELAY_START     =$8000;
     TID_USERMAX         =$7fff;

TYPE HACCEL=LHANDLE;

{ ACCEL fs bits }

CONST
     AF_CHAR                    =$0001;
     AF_VIRTUALKEY              =$0002;
     AF_SCANCODE                =$0004;
     AF_SHIFT                   =$0008;
     AF_CONTROL                 =$0010;
     AF_ALT                     =$0020;
     AF_LONEKEY                 =$0040;
     AF_SYSCOMMAND              =$0100;
     AF_HELP                    =$0200;

TYPE
    PACCEL=^ACCEL;
    ACCEL=RECORD {pack 2}
                fs:USHORT;
                key:USHORT;
                cmd:USHORT;
          END;

    PACCELTABLE=^ACCELTABLE;
    ACCELTABLE=RECORD {pack 2}
                    cAccel:USHORT;
                    codepage:USHORT;
                    aaccel:ARRAY[0..0] OF ACCEL;
               END;


{ Extended Attribute Flags (Association Table) }
CONST
     EAF_DEFAULTOWNER           =$0001;
     EAF_UNCHANGEABLE           =$0002;
     EAF_REUSEICON              =$0004;


{ WinTrackRect() tracking information structure }

TYPE
    PTRACKINFO=^TRACKINFO;
    TRACKINFO=RECORD
                   cxBorder:LONG;
                   cyBorder:LONG;
                   cxGrid:LONG;
                   cyGrid:LONG;
                   cxKeyboard:LONG;
                   cyKeyboard:LONG;
                   rclTrack:RECTL;
                   rclBoundary:RECTL;
                   ptlMinTrackSize:POINTL;
                   ptlMaxTrackSize:POINTL;
                   fs:ULONG;
           END;



{ WinTrackRect() flags }
CONST
     TF_LEFT                    =$0001;
     TF_TOP                     =$0002;
     TF_RIGHT                   =$0004;
     TF_BOTTOM                  =$0008;
     TF_MOVE                    =$000F;

     TF_SETPOINTERPOS           =$0010;
     TF_GRID                    =$0020;
     TF_STANDARD                =$0040;
     TF_ALLINBOUNDARY           =$0080;
     TF_VALIDATETRACKRECT       =$0100;
     TF_PARTINBOUNDARY          =$0200;



{ Clipboard messages }

CONST
     WM_RENDERFMT               =$0060;
     WM_RENDERALLFMTS           =$0061;
     WM_DESTROYCLIPBOARD        =$0062;
     WM_PAINTCLIPBOARD          =$0063;
     WM_SIZECLIPBOARD           =$0064;
     WM_HSCROLLCLIPBOARD        =$0065;
     WM_VSCROLLCLIPBOARD        =$0066;
     WM_DRAWCLIPBOARD           =$0067;

{ Standard Clipboard formats }

CONST
     CF_TEXT                    =1;
     CF_BITMAP                  =2;
     CF_DSPTEXT                 =3;
     CF_DSPBITMAP               =4;
     CF_METAFILE                =5;
     CF_DSPMETAFILE             =6;
     CF_PALETTE                 =9;
     CF_MMPMFIRST               =10;
     CF_MMPMLAST                =19;

{ standard DDE and clipboard format stings }

CONST
     SZFMT_TEXT                   ='#1';
     SZFMT_BITMAP                 ='#2';
     SZFMT_DSPTEXT                ='#3';
     SZFMT_DSPBITMAP              ='#4';
     SZFMT_METAFILE               ='#5';
     SZFMT_DSPMETAFILE            ='#6';
     SZFMT_PALETTE                ='#9';
     SZFMT_SYLK                   ='Sylk';
     SZFMT_DIF                    ='Dif';
     SZFMT_TIFF                   ='Tiff';
     SZFMT_OEMTEXT                ='OemText';
     SZFMT_DIB                    ='Dib';
     SZFMT_OWNERDISPLAY           ='OwnerDisplay';
     SZFMT_LINK                   ='Link';
     SZFMT_METAFILEPICT           ='MetaFilePict';
     SZFMT_DSPMETAFILEPICT        ='DspMetaFilePict';
     SZFMT_CPTEXT                 ='Codepage Text';
     SZDDEFMT_RTF                 ='Rich Text Format';
     SZDDEFMT_PTRPICT             ='Printer_Picture';

TYPE
     PMFP=^MFP;
     MFP=RECORD {pack 2}
               sizeBounds:POINTL;
               sizeMM:POINTL;
               cbLength:ULONG;
               mapMode:USHORT;
               reserved:USHORT;
              abData:BYTE;
         END;

     PCPTEXT=^CPTEXT;
     CPTEXT=RECORD {pack 2}
                  idCountry:USHORT;
                  usCodepage:USHORT;
                  usLangID:USHORT;
                  usSubLangID:USHORT;
                  abText:BYTE;
            END;



{ WinSetClipbrdData() flags }
CONST
     CFI_OWNERFREE              =$0001;
     CFI_OWNERDISPLAY           =$0002;
     CFI_POINTER                =$0400;
     CFI_HANDLE                 =$0200;


{ WinCreateCursor() flags }
CONST
   CURSOR_SOLID               =$0000;
   CURSOR_HALFTONE            =$0001;
   CURSOR_FRAME               =$0002;
   CURSOR_FLASH               =$0004;
   CURSOR_SETPOS              =$8000;


TYPE
    PCURSORINFO=^CURSORINFO;
    CURSORINFO=RECORD
                    hwnd:HWND;
                    x:LONG;
                    y:LONG;
                    cx:LONG;
                    cy:LONG;
                    fs:ULONG;
                    rclClip:RECTL
               END;

{ System pointers (NOTE: these are 1-based) }

CONST
   SPTR_ARROW                 =1;
   SPTR_TEXT                  =2;
   SPTR_WAIT                  =3;
   SPTR_SIZE                  =4;
   SPTR_MOVE                  =5;
   SPTR_SIZENWSE              =6;
   SPTR_SIZENESW              =7;
   SPTR_SIZEWE                =8;
   SPTR_SIZENS                =9;
   SPTR_APPICON               =10;

   SPTR_ICONINFORMATION       =11;
   SPTR_ICONQUESTION          =12;
   SPTR_ICONERROR             =13;
   SPTR_ICONWARNING           =14;

   SPTR_ILLEGAL               =18;
   SPTR_FILE                  =19;
   SPTR_FOLDER                =20;
   SPTR_MULTFILE              =21;
   SPTR_PROGRAM               =22;
   SPTR_DISPLAY_PTRS          =22;
   SPTR_PENFIRST              =23;
   SPTR_PENLAST               =39;
   SPTR_CPTR                  =39;

   SPTR_HANDICON              =SPTR_ICONERROR;
   SPTR_QUESICON              =SPTR_ICONQUESTION;
   SPTR_BANGICON              =SPTR_ICONWARNING;
   SPTR_NOTEICON              =SPTR_ICONINFORMATION;


TYPE
   PPOINTERINFO=^POINTERINFO;
   POINTERINFO=RECORD
                     fPointer:ULONG;
                     xHotspot:LONG;
                     yHotspot:LONG;
                     hbmPointer:HBITMAP;
                     hbmColor:HBITMAP;
                     hbmMiniPointer:HBITMAP;
                     hbmMiniColor:HBITMAP;
               END;

{ WinDrawPointer() constants }

CONST
   DP_NORMAL                  =$0000;
   DP_HALFTONED               =$0001;
   DP_INVERTED                =$0002;



{ System bitmaps (NOTE: these are 1-based) }
CONST
   SBMP_OLD_SYSMENU           =1;
   SBMP_OLD_SBUPARROW         =2;
   SBMP_OLD_SBDNARROW         =3;
   SBMP_OLD_SBRGARROW         =4;
   SBMP_OLD_SBLFARROW         =5;
   SBMP_MENUCHECK             =6;
   SBMP_OLD_CHECKBOXES        =7;
   SBMP_BTNCORNERS            =8;
   SBMP_OLD_MINBUTTON         =9;
   SBMP_OLD_MAXBUTTON         =10;
   SBMP_OLD_RESTOREBUTTON     =11;
   SBMP_OLD_CHILDSYSMENU      =12;
   SBMP_DRIVE                 =15;
   SBMP_FILE                  =16;
   SBMP_FOLDER                =17;
   SBMP_TREEPLUS              =18;
   SBMP_TREEMINUS             =19;
   SBMP_PROGRAM               =22;
   SBMP_MENUATTACHED          =23;
   SBMP_SIZEBOX               =24;

   SBMP_SYSMENU               =25;
   SBMP_MINBUTTON             =26;
   SBMP_MAXBUTTON             =27;
   SBMP_RESTOREBUTTON         =28;
   SBMP_CHILDSYSMENU          =29;
   SBMP_SYSMENUDEP            =30;
   SBMP_MINBUTTONDEP          =31;
   SBMP_MAXBUTTONDEP          =32;
   SBMP_RESTOREBUTTONDEP      =33;
   SBMP_CHILDSYSMENUDEP       =34;
   SBMP_SBUPARROW             =35;
   SBMP_SBDNARROW             =36;
   SBMP_SBLFARROW             =37;
   SBMP_SBRGARROW             =38;
   SBMP_SBUPARROWDEP          =39;
   SBMP_SBDNARROWDEP          =40;
   SBMP_SBLFARROWDEP          =41;
   SBMP_SBRGARROWDEP          =42;
   SBMP_SBUPARROWDIS          =43;
   SBMP_SBDNARROWDIS          =44;
   SBMP_SBLFARROWDIS          =45;
   SBMP_SBRGARROWDIS          =46;
   SBMP_COMBODOWN             =47;
   SBMP_CHECKBOXES            =48;


      {**********************************************************************
      * Hook codes
      *
      * Whether the hook receives a (U)SHORT or (U)LONG parameter depends
      * on the memory model that the hook executes in. 32-bit hook will
      * receive long parameters
      *
      **********************************************************************}

CONST
      HK_SENDMSG                 =0;
      {* VOID EXPENTRY SendMsgHook(HAB hab,             ** installer's hab
      *                            PSMHSTRUCT psmh,     ** p send msg struct
      *                            BOOL fInterTask);    ** between threads *}

      HK_INPUT                   =1;
      {* BOOL EXPENTRY InputHook(HAB hab,               ** installer's hab
      *                          PQMSG pQmsg,           ** p qmsg
      *                          ULONG/USHORT fs);      ** remove/noremove *}

      HK_MSGFILTER               =2;
      {* BOOL EXPENTRY MsgFilterHook(HAB hab,           ** installer's hab
      *                              PQMSG pQmsg,       ** p qmsg
      *                              ULONG/USHORT msgf);** filter flag *}

      HK_JOURNALRECORD           =3;
      {* VOID EXPENTRY JournalRecordHook(HAB hab,       ** installer's hab
      *                                  PQMSG pQmsg);  ** p qmsg *}

      HK_JOURNALPLAYBACK         =4;
      {* ULONG EXPENTRY JournalPlaybackHook(HAB hab,    **installer's hab
      *                                     BOOL fSkip, ** skip messages
      *                                     PQMSG pQmsg);** p qmsg *}

      HK_HELP                    =5;
      {* BOOL EXPENTRY HelpHook(HAB hab,                 ** installer's hab
      *                         ULONG/USHORT usMode,     ** mode
      *                         ULONG/USHORT idTopic,    ** main topic
      *                         ULONG/USHORT idSubTopic, ** sub topic
      *                         PRECTL prcPosition);     ** associated position *}

      HK_LOADER                  =6;
      {* BOOL EXPENTRY LoaderHook(HAB hab,               ** installer's hab
      *                           LONG/USHORT idContext, ** who called hook
      *                           CSTRING pszLibname,        ** lib name string
      *                           PHLIB hlib,            ** p to lib handle
      *                           CSTRING pszProcname,       ** procedure name
      *                           PFNWP wndProc);        ** window procedure *}

      HK_REGISTERUSERMSG         =7;
      {* BOOL EXPENTRY RegisterUserHook(HAB hab,         ** installer's hab
      *                                 ULONG cUSHORT,   ** entries in arRMP
      *                                 PULONG/PUSHORT arRMP, ** RMP array
      *                                 PBOOL fRegistered);** msg parms already reg*}

      HK_MSGCONTROL              =8;
      {* BOOL EXPENTRY MsgControlHook(HAB hab,            ** installer's hab
      *                               LONG/SHORT idContext,** who called hook
      *                               HWND hwnd,          ** SEI window handle
      *                               CSTRING pszClassname,   ** window class name
      *                               ULONG/USHORT usMsgclass,** interested msg class **
      *                               LONG/SHORT idControl,** SMI_*
      *                               PBOOL fSuccess);    ** mode already set *}

      HK_PLIST_ENTRY             =9;
      {* BOOL EXPENTRY ProgramListEntryHook(HAB hab,      ** installer's hab
      *                                     PPRFHOOKPARMS pProfileHookParams,** data
      *                                     PBOOL fNoExecute);  ** cease hook processing*}

      HK_PLIST_EXIT              =10;
      {* BOOL EXPENTRY ProgramListExitHook(HAB hab,       ** installer's hab
      *                                    PPRFHOOKPARMS pProfileHookParams);** data*}

      HK_FINDUSHORT                =11;
      {* BOOL EXPENTRY FindWordHook(usCodepage,           ** code page to use
      *                             CSTRING pszText,          ** text to break
      *                             ULONG cb,             ** maximum text size
      *                             ULONG ich,            ** break 'near' here
      *                             PULONG pichStart,     ** where break began
      *                             PULONG pichEnd,       ** where break ended
      *                             PULONG pichNext);     ** where next word begin*}

      HK_CODEPAGECHANGED         =12;
      {* VOID EXPENTRY CodePageChangedHook(HMQ hmq,       ** msg q handle
      *                                    ULONG/USHORT usOldCodepage, ** old code page
      *                                    ULONG/USHORT usNewCodepage);** new code page*}

      HK_WINDOWDC                =15;
      {* BOOL EXPENTRY WindowDCHook(HAB  hab,             ** installer's hab
      *                             HDC  hdc,             ** current hdc
      *                             HWND hwnd,            ** current hwnd
      *                             BOOL);                ** association flag *}

      HK_DESTROYWINDOW           =16;
      {* BOOL EXPENTRY DestroyWindowHook (HAB  hab,       ** installer's hab
      *                                   HWND hwnd,      ** destroyed win hwnd
      *                                   ULONG Reserved);** association flag  *}

      HK_CHECKMSGFILTER          =20;
      {* BOOL EXPENTRY CheckMsgFilteHook (HAB  hab,       ** installer's hab
      *                                   PQMSG pQmsg,    ** p qmsg
      *                                   ULONG/USHORT usFirst,  ** first msg
      *                                   ULONG/USHORT usLast,   ** last msg
      *                                   ULONG/USHORT fOptions);** flags  *}

      HK_MSGINPUT                =21;
      {* BOOL EXPENTRY MsgInputHook (HAB  hab,          ** installer's hab
      *                              PQMSG pQmsg,       ** p qmsg
      *                              BOOL fSkip,        ** skip msg
      *                              PBOOL pfNoRecord); ** journal record event *}

      HK_LOCKUP                  =23;
      {* BOOL EXPENTRY LockupHook (HAB  hab,              ** installer's hab
      *                           HWND hwndLockupFrame); ** hwnd     *}

      HK_FLUSHBUF                =24;
      {* BOOL EXPENTRY FlushBufHook (HAB  hab);           ** installer's hab *}


{ Current message queue constant }

CONST
     HMQ_CURRENT          =1;

{ WH_MSGFILTER context codes }

CONST
     MSGF_DIALOGBOX             =1;
     MSGF_MESSAGEBOX            =2;
     MSGF_TRACK                 =8;
     MSGF_DDEPOSTMSG            =3;

{ HK_HELP Help modes }

CONST
     HLPM_FRAME              =-1;
     HLPM_WINDOW             =-2;
     HLPM_MENU               =-3;

{ HK_SENDMSG structure }

CONST
     PM_MODEL_1X      =0;
     PM_MODEL_2X      =1;

TYPE
     PSMHSTRUCT=^SMHSTRUCT;
     SMHSTRUCT=RECORD
                   mp2:MPARAM;
                   mp1:MPARAM;
                   msg:ULONG;
                   hwnd:HWND;
                   model:ULONG;
                END;

{ HK_LOADER context codes }

CONST
     LHK_DELETEPROC             =1;
     LHK_DELETELIB              =2;
     LHK_LOADPROC               =3;
     LHK_LOADLIB                =4;

{ HK_MSGCONTROL context codes }

CONST
     MCHK_MSGINTEREST           =1;
     MCHK_CLASSMSGINTEREST      =2;
     MCHK_SYNCHRONISATION       =3;
     MCHK_MSGMODE               =4;

{ HK_REGISTERUSERMSG conext codes }

CONST
     RUMHK_DATATYPE             =1;
     RUMHK_MSG                  =2;

CONST
     WCS_ERROR                  =0;
     WCS_EQ                     =1;
     WCS_LT                     =2;
     WCS_GT                     =3;


TYPE
    HATOMTBL=LHANDLE;
    ATOM=ULONG;

{ Error codes for debugging support }
{ =$1001 - =$1021, =$1034, =$1036 - =$1050 are reserved }
CONST
   WINDBG_HWND_NOT_DESTROYED           =$1022;
   WINDBG_HPTR_NOT_DESTROYED           =$1023;
   WINDBG_HACCEL_NOT_DESTROYED         =$1024;
   WINDBG_HENUM_NOT_DESTROYED          =$1025;
   WINDBG_VISRGN_SEM_BUSY              =$1026;
   WINDBG_USER_SEM_BUSY                =$1027;
   WINDBG_DC_CACHE_BUSY                =$1028;
   WINDBG_HOOK_STILL_INSTALLED         =$1029;
   WINDBG_WINDOW_STILL_LOCKED          =$102a;
   WINDBG_UPDATEPS_ASSERTION_FAIL      =$102b;
   WINDBG_SENDMSG_WITHIN_USER_SEM      =$102c;
   WINDBG_USER_SEM_NOT_ENTERED         =$102d;
   WINDBG_PROC_NOT_EXPORTED            =$102e;
   WINDBG_BAD_SENDMSG_HWND             =$102f;
   WINDBG_ABNORMAL_EXIT                =$1030;
   WINDBG_INTERNAL_REVISION            =$1031;
   WINDBG_INITSYSTEM_FAILED            =$1032;
   WINDBG_HATOMTBL_NOT_DESTROYED       =$1033;
   WINDBG_WINDOW_UNLOCK_WAIT           =$1035;

{ Get/Set Error Information Interface declarations }

TYPE
    PERRINFO=^ERRINFO;
    ERRINFO=RECORD
                  cbFixedErrInfo:ULONG;
                  idError:ERRORID;
                  cDetailLevel:ULONG;
                  offaoffszMsg:ULONG;
                  offBinaryData:ULONG;
            END;


{ DDE standard system topic and item strings }
CONST
     SZDDESYS_TOPIC                  ='System';
     SZDDESYS_ITEM_TOPICS            ='Topics';
     SZDDESYS_ITEM_SYSITEMS          ='SysItems';
     SZDDESYS_ITEM_RTNMSG            ='ReturnMessage';
     SZDDESYS_ITEM_STATUS            ='Status';
     SZDDESYS_ITEM_FORMATS           ='Formats';
     SZDDESYS_ITEM_SECURITY          ='Security';
     SZDDESYS_ITEM_ITEMFORMATS       ='ItemFormats';
     SZDDESYS_ITEM_HELP              ='Help';
     SZDDESYS_ITEM_PROTOCOLS         ='Protocols';
     SZDDESYS_ITEM_RESTART           ='Restart';

TYPE
     PCONVCONTEXT=^CONVCONTEXT;
     CONVCONTEXT=RECORD
                      cb:ULONG;
                      fsContext:ULONG;
                      idCountry:ULONG;
                      usCodepage:ULONG;
                      usLangID:ULONG;
                      usSubLangID:ULONG;
                END;

CONST
     DDECTXT_CASESENSITIVE    =$0001;

TYPE
     PDDEINIT=^DDEINIT;
     DDEINIT=RECORD
                  cb:ULONG;
                  pszAppName:PCHAR;
                  pszTopic:PCHAR;
                  offConvContext:ULONG;
             END;

     PDDESTRUCT=^DDESTRUCT;
     DDESTRUCT=RECORD
                    cbData:ULONG;
                    fsStatus:USHORT;
                    usFormat:USHORT;
                    offszItemName:USHORT;
                    offabData:USHORT;
               END;

{ DDE constants for wStatus field }

CONST
     DDE_FACK                   =$0001;
     DDE_FBUSY                  =$0002;
     DDE_FNODATA                =$0004;
     DDE_FACKREQ                =$0008;
     DDE_FRESPONSE              =$0010;
     DDE_NOTPROCESSED           =$0020;
     DDE_FRESERVED              =$00C0;
     DDE_FAPPSTATUS             =$FF00;

     DDEFMT_TEXT                =$0001;


CONST
     DDEPM_RETRY     =$00000001;
     DDEPM_NOFREE    =$00000002;

{ Dynamic Data Exchange (DDE) Messages }

CONST
     WM_DDE_FIRST               =$00A0;
     WM_DDE_INITIATE            =$00A0;
     WM_DDE_REQUEST             =$00A1;
     WM_DDE_ACK                 =$00A2;
     WM_DDE_DATA                =$00A3;
     WM_DDE_ADVISE              =$00A4;
     WM_DDE_UNADVISE            =$00A5;
     WM_DDE_POKE                =$00A6;
     WM_DDE_EXECUTE             =$00A7;
     WM_DDE_TERMINATE           =$00A8;
     WM_DDE_INITIATEACK         =$00A9;
     WM_DDE_LAST                =$00AF;


{ Return values for WM_QUERYCONVERTPOS }

CONST
   QCP_CONVERT                =$0001;
   QCP_NOCONVERT              =$0000;

TYPE
    HLIB=HMODULE;

{ Desktop API definitions }
TYPE
    PDESKTOP=^DESKTOP;
    DESKTOP=RECORD
                  cbSize:ULONG;
                  hbm:HBITMAP;
                  x:LONG;
                  y:LONG;
                  fl:ULONG;
                  lTileCount:LONG;
                  szFile:CSTRING[260];
            END;

CONST
     SDT_DESTROY         =$0001;
     SDT_NOBKGND         =$0002;
     SDT_TILE            =$0004;
     SDT_SCALE           =$0008;
     SDT_PATTERN         =$0010;
     SDT_CENTER          =$0020;
     SDT_RETAIN          =$0040;
     SDT_LOADFILE        =$0080;

CONST
   WM_DBCSFIRST          =$00b0;
   WM_DBCSLAST           =$00cf;
   WM_QUERYCONVERTPOS    =WM_DBCSFIRST;   


{ Standard Window Classes}

CONST
     WC_FRAME            =$ffff0001;
     WC_COMBOBOX         =$ffff0002;
     WC_BUTTON           =$ffff0003;
     WC_MENU             =$ffff0004;
     WC_STATIC           =$ffff0005;
     WC_ENTRYFIELD       =$ffff0006;
     WC_LISTBOX          =$ffff0007;
     WC_SCROLLBAR        =$ffff0008;
     WC_TITLEBAR         =$ffff0009;
     WC_MLE              =$ffff000A;
     { 000B to 000F reserved }
     WC_APPSTAT          =$ffff0010;
     WC_KBDSTAT          =$ffff0011;
     WC_PECIC            =$ffff0012;
     WC_DBE_KKPOPUP      =$ffff0013;
     { 0014 to 001F reserved }
     WC_SPINBUTTON       =$ffff0020;
     { 0021 to 0024 reserved }
     WC_CONTAINER        =$ffff0025;
     WC_SLIDER           =$ffff0026;
     WC_VALUESET         =$ffff0027;
     WC_NOTEBOOK         =$ffff0028;
     { 0029 to 002C used by PEN }
     WC_PENFIRST         =$ffff0029;
     WC_PENLAST          =$ffff002C;
     { 002D to 0030 reserved }
     { 0030 to 003F reserved }
     WC_MMPMFIRST        =$ffff0040;
     WC_MMPMLAST         =$ffff004f;



CONST
     MPVOID:MPARAM=0;

{*************************************************************************
 * MLE Window styles ( in addition to WS_* )
 *************************************************************************}
CONST
    MLS_WORDWRAP               =$00000001;
    MLS_BORDER                 =$00000002;
    MLS_VSCROLL                =$00000004;
    MLS_HSCROLL                =$00000008;
    MLS_READONLY               =$00000010;
    MLS_IGNORETAB              =$00000020;
    MLS_DISABLEUNDO            =$00000040;

{************************************************************************
 * MLE External Data Types
 ************************************************************************}

TYPE
    IPT=LONG;        { insertion point         }
    PIPT=PLONG;      { insertion point         }
    PIX=LONG;        { pixel                   }
    LINE=ULONG;      { Line number             }

    PMLEFORMATRECT=^MLEFORMATRECT;
    MLEFORMATRECT=RECORD
                     cxFormat:LONG;     { format rectangle width  }
                     cyFormat:LONG;     { format rectangle height }
                  END;

    PMLECTLDATA=^MLECTLDATA;
    MLECTLDATA=RECORD
                     cbCtlData:USHORT;  { Length of the MLECTLDATA structure  }
                     afIEFormat:USHORT; { import/export format                }
                     cchText:ULONG;     { text limit                          }
                     iptAnchor:IPT;     { beginning of selection              }
                     iptCursor:IPT;     { ending of selection                 }
                     cxFormat:LONG;     { format rectangle width              }
                     cyFormat:LONG;     { format rectangle height             }
                     afFormatFlags:ULONG;  { formatting rectangle flags          }
               END;

{************************************************************************
 * afFormatFlags mask
 ************************************************************************}
CONST
     MLFFMTRECT_LIMITHORZ       =$00000001;
     MLFFMTRECT_LIMITVERT       =$00000002;
     MLFFMTRECT_MATCHWINDOW     =$00000004;
     MLFFMTRECT_FORMATRECT      =$00000007;

{************************************************************************
 * afIEFormat - Import/Export Format flags
 ************************************************************************}
     MLFIE_CFTEXT               =0;
     MLFIE_NOTRANS              =1;
     MLFIE_WINFMT               =2;
     MLFIE_RTF                  =3;

{************************************************************************
 * MLN_OVERFLOW structure
 ************************************************************************}
TYPE
   PMLEOVERFLOW=^MLEOVERFLOW;
   MLEOVERFLOW=RECORD
                    afErrInd:ULONG;  { see mask below                         }
                    nBytesOver:LONG; { number of bytes overflowed             }
                    pixHorzOver:LONG;{ number of pixels horizontally overflow }
                    pixVertOver:LONG;{ number of pixels vertically overflowed }
               END;

{************************************************************************
 * afErrInd - error format rectangle flags
 ************************************************************************}
CONST
     MLFEFR_RESIZE              =$00000001;
     MLFEFR_TABSTOP             =$00000002;
     MLFEFR_FONT                =$00000004;
     MLFEFR_TEXT                =$00000008;
     MLFEFR_WORDWRAP            =$00000010;
     MLFETL_TEXTBYTES           =$00000020;

{************************************************************************
 * MLN_MARGIN structure
 ************************************************************************}
TYPE
   PMLEMARGSTRUCT=^MLEMARGSTRUCT;
   MLEMARGSTRUCT=RECORD
                  afMargins:USHORT;      { margin indicator     }
                  usMouMsg:USHORT;       { mouse message        }
                  iptNear:IPT;           { the geometrically nearest insertion point }
                 END;

{************************************************************************
 * afFlags - margin notification indicators
 ************************************************************************}
CONST
     MLFMARGIN_LEFT             =$0001;
     MLFMARGIN_BOTTOM           =$0002;
     MLFMARGIN_RIGHT            =$0003;
     MLFMARGIN_TOP              =$0004;

{************************************************************************
 * MLM_QUERYSELECTION flags
 ************************************************************************}
     MLFQS_MINMAXSEL            =0;
     MLFQS_MINSEL               =1;
     MLFQS_MAXSEL               =2;
     MLFQS_ANCHORSEL            =3;
     MLFQS_CURSORSEL            =4;

{************************************************************************
 * MLN_CLPBDFAIL flags
 ************************************************************************}
     MLFCLPBD_TOOMUCHTEXT       =$00000001;
     MLFCLPBD_ERROR             =$00000002;

{************************************************************************
 * MLM_SEARCH structure
 ************************************************************************}
TYPE
   PMLE_SEARCHDATA=^MLE_SEARCHDATA;
   MLE_SEARCHDATA=RECORD
                    cb:ULONG; {USHORT ?} { size of search spec structure    }
                    pchFind:PCHAR;    { string to search for                }
                    pchReplace:PCHAR; { string to replace with              }
                    cchFind:SHORT;    { length of pchFindString             }
                    cchReplace:SHORT; { length of replace string            }
                    iptStart:IPT;     { point at which to start search      }
                    iptStop:IPT;      { point at which to stop search       }
                    cchFound:USHORT;  { Length of found string at iptStart  }
                  END;

{************************************************************************
 * MLM_SEARCH style flags
 ************************************************************************}
CONST
     MLFSEARCH_CASESENSITIVE    =$00000001;
     MLFSEARCH_SELECTMATCH      =$00000002;
     MLFSEARCH_CHANGEALL        =$00000004;

{************************************************************************
 * MLE messages - MLM from =$01b0 to =$01de; MLN from =$0001 to =$000f
 ************************************************************************}
   { formatting messages }
     MLM_SETTEXTLIMIT           =$01b0;
     MLM_QUERYTEXTLIMIT         =$01b1;
     MLM_SETFORMATRECT          =$01b2;
     MLM_QUERYFORMATRECT        =$01b3;
     MLM_SETWRAP                =$01b4;
     MLM_QUERYWRAP              =$01b5;
     MLM_SETTABSTOP             =$01b6;
     MLM_QUERYTABSTOP           =$01b7;
     MLM_SETREADONLY            =$01b8;
     MLM_QUERYREADONLY          =$01b9;

   { text content manipulation and queries messages }
     MLM_QUERYCHANGED           =$01ba;
     MLM_SETCHANGED             =$01bb;
     MLM_QUERYLINECOUNT         =$01bc;
     MLM_CHARFROMLINE           =$01bd;
     MLM_LINEFROMCHAR           =$01be;
     MLM_QUERYLINELENGTH        =$01bf;
     MLM_QUERYTEXTLENGTH        =$01c0;

   { text import and export messages }
     MLM_FORMAT                 =$01c1;
     MLM_SETIMPORTEXPORT        =$01c2;
     MLM_IMPORT                 =$01c3;
     MLM_EXPORT                 =$01c4;
     MLM_DELETE                 =$01c6;
     MLM_QUERYFORMATLINELENGTH  =$01c7;
     MLM_QUERYFORMATTEXTLENGTH  =$01c8;
     MLM_INSERT                 =$01c9;

   { selection messages }
     MLM_SETSEL                 =$01ca;
     MLM_QUERYSEL               =$01cb;
     MLM_QUERYSELTEXT           =$01cc;

   { undo and redo messages }
     MLM_QUERYUNDO              =$01cd;
     MLM_UNDO                   =$01ce;
     MLM_RESETUNDO              =$01cf;

   { text attributes messages }
     MLM_QUERYFONT              =$01d0;
     MLM_SETFONT                =$01d1;
     MLM_SETTEXTCOLOR           =$01d2;
     MLM_QUERYTEXTCOLOR         =$01d3;
     MLM_SETBACKCOLOR           =$01d4;
     MLM_QUERYBACKCOLOR         =$01d5;

   { scrolling messages }
     MLM_QUERYFIRSTCHAR         =$01d6;
     MLM_SETFIRSTCHAR           =$01d7;

   { clipboard messages }
     MLM_CUT                    =$01d8;
     MLM_COPY                   =$01d9;
     MLM_PASTE                  =$01da;
     MLM_CLEAR                  =$01db;

   { display manipulation messages }
     MLM_ENABLEREFRESH          =$01dc;
     MLM_DISABLEREFRESH         =$01dd;

   { search message }
     MLM_SEARCH                 =$01de;
     MLM_QUERYIMPORTEXPORT      =$01df;

   { notification messages }
     MLN_OVERFLOW               =$0001;
     MLN_PIXHORZOVERFLOW        =$0002;
     MLN_PIXVERTOVERFLOW        =$0003;
     MLN_TEXTOVERFLOW           =$0004;
     MLN_VSCROLL                =$0005;
     MLN_HSCROLL                =$0006;
     MLN_CHANGE                 =$0007;
     MLN_SETFOCUS               =$0008;
     MLN_KILLFOCUS              =$0009;
     MLN_MARGIN                 =$000a;
     MLN_SEARCHPAUSE            =$000b;
     MLN_MEMERROR               =$000c;
     MLN_UNDOOVERFLOW           =$000d;
     MLN_CLPBDFAIL              =$000f;

IMPORTS

FUNCTION WinRegisterClass(ahab:HAB;pszClassName:CSTRING;pfnWndProc:POINTER;
                          flStyle,cbWindowData:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 926;
FUNCTION WinDefWindowProc(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM):ULONG;
                          APIENTRY;             'PMWIN' index 911;
FUNCTION WinDestroyWindow(ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 728;
FUNCTION WinShowWindow(ahwnd:HWND;fShow:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 883;
FUNCTION WinQueryWindowRect(ahwnd:HWND;VAR prclDest:RECTL):BOOL;
                          APIENTRY;             'PMWIN' index 840;
FUNCTION WinIsWindowShowing(ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 774;


FUNCTION WinQueryVersion(ahab:HAB):ULONG;
                          APIENTRY;             'PMWIN' index 833;
FUNCTION WinQueryAnchorBlock(ahwnd:HWND):HAB;
                          APIENTRY;             'PMWIN' index 800;
FUNCTION WinCreateWindow(hwndParent:HWND;pszClass:CSTRING;pszName:CSTRING;
                         flStyle:ULONG;x,y,cx,cy:LONG;hwndOwner,
                         hwndInsertBehind:HWND;id:ULONG;pCtlData,
                         pPresParams:POINTER):HWND;
                          APIENTRY;             'PMWIN' index 909;
FUNCTION WinCreateWCWindow(hwndParent:HWND;pszClass:ULONG;pszName:CSTRING;
                           flStyle:ULONG;x,y,cx,cy:LONG;hwndOwner,
                           hwndInsertBehind:HWND;id:ULONG;pCtlData,
                           pPresParams:PVOID):HWND;
                              APIENTRY;             'PMWIN' index 909;
FUNCTION WinEnableWindow(ahwnd:HWND;fEnable:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 735;
FUNCTION WinIsWindowEnabled(ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 773;
FUNCTION WinEnableWindowUpdate(ahwnd:HWND;fEnable:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 736;
FUNCTION WinIsWindowVisible(ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 775;
FUNCTION WinQueryWindowText(ahwnd:HWND;cchBufferMax:LONG;VAR pchBuffer):LONG;
                          APIENTRY;             'PMWIN' index 841;
FUNCTION WinSetWindowText(ahwnd:HWND;pszText:CSTRING):BOOL;
                          APIENTRY;             'PMWIN' index 877;
FUNCTION WinQueryWindowTextLength(ahwnd:HWND):LONG;
                          APIENTRY;             'PMWIN' index 842;
FUNCTION WinWindowFromID(hwndParent:HWND;id:ULONG):HWND;
                          APIENTRY;             'PMWIN' index 899;
FUNCTION WinIsWindow(ahab:HAB;ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 772;
FUNCTION WinQueryWindow(ahwnd:HWND;cmd:LONG):HWND;
                          APIENTRY;             'PMWIN' index 834;
FUNCTION WinMultWindowFromIDs(hwndParent:HWND;VAR prghwnd:HWND;
                              idFirst,idLast:ULONG):LONG;
                          APIENTRY;             'PMWIN' index 917;
FUNCTION WinSetParent(ahwnd,hwndNewParent:HWND;fRedraw:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 865;
FUNCTION WinIsChild(ahwnd,hwndParent:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 768;
FUNCTION WinSetOwner(ahwnd,hwndNewOwner:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 864;
FUNCTION WinQueryWindowProcess(ahwnd:HWND;VAR ppid:PID;VAR ptid:TID):BOOL;
                          APIENTRY;             'PMWIN' index 838;
FUNCTION WinQueryObjectWindow(hwndDesktop:HWND):HWND;
                          APIENTRY;             'PMWIN' index 820;
FUNCTION WinQueryDesktopWindow(ahab:HAB;ahdc:HDC):HWND;
                          APIENTRY;             'PMWIN' index 813;
FUNCTION WinSetWindowPos(ahwnd,hwndInsertBehind:HWND;x,y,cx,cy:LONG;
                         fl:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 875;
FUNCTION WinSetMultWindowPos(ahab:HAB;VAR pswp:SWP;cswp:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 863;
FUNCTION WinQueryWindowPos(ahwnd:HWND;VAR pswp:SWP):BOOL;
                          APIENTRY;             'PMWIN' index 837;
FUNCTION WinUpdateWindow(ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 892;
FUNCTION WinInvalidateRect(ahwnd:HWND;CONST pwrc:RECTL;
                           fIncludeChildren:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 765;
FUNCTION WinInvalidateRegion(ahwnd:HWND;ahrgn:HRGN;
                             fIncludeChildren:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 766;



FUNCTION WinSetActiveWindow(hwndDesktop,ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 851;
FUNCTION WinSubclassWindow(ahwnd:HWND;pfnwp:POINTER):POINTER;
                          APIENTRY;             'PMWIN' index 929;
FUNCTION WinQueryClassName(ahwnd:HWND;cchMax:LONG;VAR apch):LONG;
                          APIENTRY;             'PMWIN' index 805;
FUNCTION WinQueryClassInfo(ahab:HAB;pszClassName:CSTRING;
                           VAR pClassInfo:CLASSINFO):BOOL;
                          APIENTRY;             'PMWIN' index 925;
FUNCTION WinQueryActiveWindow(hwndDesktop:HWND):HWND;
                          APIENTRY;             'PMWIN' index 799;
FUNCTION WinIsThreadActive(ahab:HAB):BOOL;
                          APIENTRY;             'PMWIN' index 771;
FUNCTION WinQuerySysModalWindow(hwndDesktop:HWND):HWND;
                          APIENTRY;             'PMWIN' index 827;
FUNCTION WinSetSysModalWindow(hwndDesktop:HWND;ahwnd:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 872;
FUNCTION WinQueryWindowUShort(ahwnd:HWND;index:LONG):USHORT;
                          APIENTRY;             'PMWIN' index 844;
FUNCTION WinSetWindowUShort(ahwnd:HWND;index:LONG;us:USHORT):BOOL;
                          APIENTRY;             'PMWIN' index 879;
FUNCTION WinQueryWindowUlong(ahwnd:HWND;index:LONG):ULONG;
                          APIENTRY;             'PMWIN' index 843;
FUNCTION WinSetWindowULong(ahwnd:HWND;index:LONG;ul:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 878;
FUNCTION WinQueryWindowPtr(ahwnd:HWND;index:LONG):POINTER;
                          APIENTRY;             'PMWIN' index 839;
FUNCTION WinSetWindowPtr(ahwnd:HWND;index:LONG;p:POINTER):BOOL;
                          APIENTRY;             'PMWIN' index 876;
FUNCTION WinSetWindowBits(ahwnd:HWND;index:LONG;flData,
                          flMask:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 874;
FUNCTION WinBeginEnumWindows(ahwnd:HWND):HENUM;
                          APIENTRY;             'PMWIN' index 702;
FUNCTION WinGetNextWindow(ahenum:HENUM):HWND;
                          APIENTRY;             'PMWIN' index 756;
FUNCTION WinEndEnumWindows(ahenum:HENUM):BOOL;
                          APIENTRY;             'PMWIN' index 737;
FUNCTION WinWindowFromPoint(ahwnd:HWND;VAR pptl:POINTL;
                            fChildren:BOOL):HWND;
                          APIENTRY;             'PMWIN' index 900;
FUNCTION WinMapWindowPoints(hwndFrom,hwndTo:HWND;VAR prgptl;
                            cwpt:LONG):BOOL;
                          APIENTRY;             'PMWIN' index 788;
FUNCTION WinValidateRect(ahwnd:HWND;CONST prcl:RECTL;
                         fIncludeChildren:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 895;
FUNCTION WinValidateRegion(ahwnd:HWND;ahrgn:HRGN;
                           fIncludeChildren:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 896;

FUNCTION WinLockWindowUpdate(hwndDesktop,hwndLockUpdate:HWND):BOOL;
                          APIENTRY;             'PMWIN' index 784;
FUNCTION WinLockVisRegions(hwndDesktop:HWND;fLock:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 782;
FUNCTION WinQueryUpdateRect(ahwnd:HWND;VAR prcl:RECTL):BOOL;
                          APIENTRY;             'PMWIN' index 831;
FUNCTION WinQueryUpdateRegion(ahwnd:HWND;ahrgn:HRGN):LONG;
                          APIENTRY;             'PMWIN' index 832;
FUNCTION WinExcludeUpdateRegion(ahps:HPS;ahwnd:HWND):LONG;
                          APIENTRY;             'PMWIN' index 742;
FUNCTION WinQueryQueueInfo(ahmq:HMQ;VAR pmqi:MQINFO;cbCopy:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 824;
FUNCTION WinCancelShutdown(ahmq:HMQ;fCancelAlways:BOOL):BOOL;
                          APIENTRY;             'PMWIN' index 705;
FUNCTION WinSetFocus(hwndDesktop,hwndSetFocus:HWND):BOOL;
                    APIENTRY;             'PMWIN' index 860;
FUNCTION WinFocusChange(hwndDesktop,hwndSetFocus:HWND;
                        flFocusChange:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 746;
{FUNCTION WinLockupSystem(ahab:HAB):BOOL;
                    APIENTRY;             'PMWIN' index ???
FUNCTION WinUnlockSystem(ahab:HAB;VAR pszPassword:CSTRING):BOOL
                    APIENTRY;             'PMWIN' index ???}
FUNCTION WinSetCapture(hwndDesktop,ahwnd:HWND):BOOL;
                    APIENTRY;             'PMWIN' index 852;
FUNCTION WinQueryCapture(hwndDesktop:HWND):HWND;
                    APIENTRY;             'PMWIN' index 804;
FUNCTION WinQueryFocus(hwndDesktop:HWND):HWND;
                    APIENTRY;             'PMWIN' index 817;
FUNCTION WinGetKeyState(hwndDesktop:HWND;vkey:LONG):LONG;
                    APIENTRY;             'PMWIN' index 752;
FUNCTION WinGetPhysKeyState(hwndDesktop:HWND;sc:LONG):LONG;
                    APIENTRY;             'PMWIN' index 758;
FUNCTION WinEnablePhysInput(hwndDesktop:HWND;fEnable:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 734;
FUNCTION WinIsPhysInputEnabled(hwndDesktop:HWND):BOOL;
                    APIENTRY;             'PMWIN' index 769;
FUNCTION WinSetKeyboardStateTable(hwndDesktop:HWND;VAR pKeyStateTable;
                                  fSet:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 921;

FUNCTION WinAlarm(hwndDesktop:HWND;rgfType:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 701;
FUNCTION WinMessageBox(hwndParent,hwndOwner:HWND;pszText,pszCaption:CSTRING;
                       idWindow,flStyle:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 789;
FUNCTION WinSubstituteStrings(ahwnd:HWND;VAR pszSrc:CSTRING;cchDstMax:LONG;
                              VAR pszDst:CSTRING):LONG;
                    APIENTRY;             'PMWIN' index 886;




FUNCTION WinSetDesktopBkgnd(hwndDesktop:HWND;VAR pdskNew:DESKTOP):HBITMAP;
                    APIENTRY;             'PMWIN' index 935;
FUNCTION WinQueryDesktopBkgnd(hwndDesktop:HWND;VAR pdsk:DESKTOP):BOOL;
                    APIENTRY;             'PMWIN' index 936;
FUNCTION WinCreateStdWindow(hwndParent:HWND;flStyle:ULONG;
                            VAR pflCreateFlags:ULONG;
                            pszClientClass:CSTRING;pszTitle:CSTRING;
                            styleClient:ULONG;hmod:HMODULE;
                            idResources:ULONG;VAR phwndClient:HWND):HWND;
                    APIENTRY;             'PMWIN' index 908;
FUNCTION WinCreateWCStdWindow( hwndParent:HWND;flStyle:ULONG;
                               VAR pflCreateFlags:ULONG;
                               pszClientClass:ULONG;pszTitle:CSTRING;
                               styleClient:ULONG;hmod:HMODULE;
                               idResources:ULONG;VAR phwndClient:HWND):HWND;
                               APIENTRY; 'PMWIN' index 908;
FUNCTION WinFlashWindow(hwndFrame:HWND;fFlash:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 745;
FUNCTION WinCreateFrameControls(hwndFrame:HWND;VAR pfcdata:FRAMECDATA;
                                pszTitle:CSTRING):BOOL;
                    APIENTRY;             'PMWIN' index 906;
FUNCTION WinCalcFrameRect(hwndFrame:HWND;VAR prcl:RECTL;fClient:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 704;
FUNCTION WinGetMinPosition(ahwnd:HWND;VAR pswp:SWP;VAR pptl:POINTL):BOOL;
                    APIENTRY;             'PMWIN' index 755;
FUNCTION WinGetMaxPosition(ahwnd:HWND;VAR pswp:SWP):BOOL;
                    APIENTRY;             'PMWIN' index 754;
FUNCTION WinSaveWindowPos(hsvwp:HSAVEWP;VAR pswp:SWP;cswp:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 943;
FUNCTION WinQuerySysValue(hwndDesktop:HWND;iSysValue:LONG):LONG;
                    APIENTRY;             'PMWIN' index 829;
FUNCTION WinSetSysValue(hwndDesktop:HWND;iSysValue,lValue:LONG):BOOL;
                    APIENTRY;             'PMWIN' index 873;
FUNCTION WinSetPresParam(ahwnd:HWND;id,cbParam:ULONG;VAR pbParam):BOOL;
                    APIENTRY;             'PMWIN' index 938;
FUNCTION WinQueryPresParam(ahwnd:HWND;id1,id2:ULONG;VAR pulId:ULONG;
                           cbBuf:ULONG;VAR pbBuf;fs:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 939;
FUNCTION WinRemovePresParam(ahwnd:HWND;id:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 940;
FUNCTION WinQuerySysColor(hwndDesktop:HWND;clr,lReserved:LONG):LONG;
                    APIENTRY;             'PMWIN' index 826;
FUNCTION WinSetSysColors(hwndDesktop:HWND;flOptions,flFormat:ULONG;
                         clrFirst:LONG;cclr:ULONG;VAR alTable):BOOL;
                    APIENTRY;             'PMWIN' index 871;
FUNCTION WinGetCurrentTime(ahab:HAB):ULONG;
                    APIENTRY;             'PMWIN' index 750;
FUNCTION WinDestroyCursor(ahwnd:HWND):BOOL;
                    APIENTRY;             'PMWIN' index 725;
FUNCTION WinShowCursor(ahwnd:HWND;fShow:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 880;
FUNCTION WinCreateCursor(ahwnd:HWND;x,y,cx,cy:LONG;fs:ULONG;
                         VAR prclClip):BOOL;
                    APIENTRY;             'PMWIN' index 715;
FUNCTION WinQueryCursorInfo(hwndDesktop:HWND;
                            VAR pCursorInfo:CURSORINFO):BOOL;
                    APIENTRY;             'PMWIN' index 812;
FUNCTION WinGetSysBitmap(hwndDesktop:HWND;ibm:ULONG):HBITMAP;
                    APIENTRY;             'PMWIN' index 760;
FUNCTION WinSetClassThunkProc(VAR pszClassname:CSTRING;pfnThunkProc:POINTER):BOOL;
                    APIENTRY;             'PMWIN' index 930;
FUNCTION WinQueryClassThunkProc(pszClassname:CSTRING):POINTER;
                    APIENTRY;             'PMWIN' index 931;
FUNCTION WinSetWindowThunkProc(ahwnd:HWND;pfnThunkProc:POINTER):BOOL;
                    APIENTRY;             'PMWIN' index 932;
FUNCTION WinQueryWindowThunkProc(ahwnd:HWND):POINTER;
                    APIENTRY;             'PMWIN' index 933;
FUNCTION WinQueryWindowModel(ahwnd:HWND):LONG;
                    APIENTRY;             'PMWIN' index 934;
FUNCTION WinLockInput(ahmq:HMQ;fLock:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 995;
FUNCTION WinQuerySendMsg(ahab:HAB;Sender:HMQ;Receiver:HMQ;VAR pqmsg:QMSG;
                         ahmq:HMQ):HMQ;
                    APIENTRY;             'PMWIN' index 990;
FUNCTION WinQueueFromId(ahab:HAB;idPid:PID;idTid:TID):HMQ;
                    APIENTRY;             'PMWIN' index 993;
FUNCTION WinReplyMsg(ahab:HAB;hmqSender,hmqReceiver:HMQ;mresReply:MRESULT):BOOL;
                    APIENTRY;             'PMWIN' index 991;
FUNCTION WinThreadAssocQueue(ahab:HAB;ahmq:HMQ):BOOL;
                    APIENTRY;             'PMWIN' index 994;
FUNCTION WinWakeThread(ahmq:HMQ):BOOL;
                    APIENTRY;             'PMWIN' index 992;

// ----------

// Atom Functions
FUNCTION WinAddAtom(ahAtomTbl:HATOMTBL;pszAtomName:CSTRING):ATOM;
                    APIENTRY;             'PMWIN' index 700;
FUNCTION WinCreateAtomTable(cbInitial,cBuckets:ULONG):HATOMTBL;
                    APIENTRY;             'PMWIN' index 714;
FUNCTION WinDeleteAtom(ahAtomTbl:HATOMTBL;aatom:ATOM):ATOM;
                    APIENTRY;             'PMWIN' index 721;
FUNCTION WinDestroyAtomTable(ahAtomTbl:HATOMTBL):HATOMTBL;
                    APIENTRY;             'PMWIN' index 724;
FUNCTION WinFindAtom(ahAtomTbl:HATOMTBL;pszAtomName:CSTRING):ATOM;
                    APIENTRY;             'PMWIN' index 744;
FUNCTION WinQueryAtomLength(ahAtomTbl:HATOMTBL;aatom:ATOM):ULONG;
                    APIENTRY;             'PMWIN' index 801;
FUNCTION WinQueryAtomName(ahAtomTbl:HATOMTBL;aatom:ATOM;VAR pszBuffer:CSTRING;
                          cchBufferMax:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 802;
FUNCTION WinQueryAtomUsage(ahAtomTbl:HATOMTBL;aatom:ATOM):ULONG;
                    APIENTRY;             'PMWIN' index 803;
FUNCTION WinQuerySystemAtomTable:HATOMTBL;
                    APIENTRY;             'PMWIN' index 830;


// Clipboard
FUNCTION WinCloseClipbrd(ahab:HAB):BOOL;
                    APIENTRY;             'PMWIN' index 707;
FUNCTION WinDdeInitiate(hwndClient:HWND;pszAppName,pszTopicName:CSTRING;
                        VAR pcctxt:CONVCONTEXT):BOOL;
                    APIENTRY;             'PMWIN' index 718;
FUNCTION WinDdePostMsg(hwndTo,hwndFrom:HWND;wm:ULONG;VAR pddest:DDESTRUCT;
                       flOptions:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 719;
FUNCTION WinDdeRespond(hwndClient,hwndServer:HWND;pszAppName,pszTopicName:CSTRING;
                       VAR pcctxt:CONVCONTEXT):ULONG;
                    APIENTRY;             'PMWIN' index 720;
FUNCTION WinEmptyClipbrd(ahab:HAB):BOOL;
                    APIENTRY;             'PMWIN' index 733;
FUNCTION WinEnumClipbrdFmts(ahab:HAB;fmt:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 739;
FUNCTION WinOpenClipbrd(ahab:HAB):BOOL;
                    APIENTRY;             'PMWIN' index 793;
FUNCTION WinQueryClipbrdData(ahab:HAB;fmt:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 806;
FUNCTION WinQueryClipbrdFmtInfo(ahab:HAB;fmt:ULONG;
                                VAR prgfFmtInfo:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 807;
FUNCTION WinQueryClipbrdOwner(ahab:HAB):HWND;
                    APIENTRY;             'PMWIN' index 808;
FUNCTION WinQueryClipbrdViewer(ahab:HAB):HWND;
                    APIENTRY;             'PMWIN' index 809;
FUNCTION WinSetClipbrdData(ahab:HAB;ulData,fmt,rgfFmtInfo:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 854;
FUNCTION WinSetClipbrdOwner(ahab:HAB;ahwnd:HWND):BOOL;
                    APIENTRY;             'PMWIN' index 855;
FUNCTION WinSetClipbrdViewer(ahab:HAB;hwndNewClipViewer:HWND):BOOL;
                    APIENTRY;             'PMWIN' index 856;


// Device Context/Presentation Space
FUNCTION WinBeginPaint(ahwnd:HWND;ahps:HPS;VAR prclPaint:RECTL):HPS;
                          APIENTRY;             'PMWIN' index 703;
FUNCTION WinEndPaint(ahps:HPS):BOOL;
                          APIENTRY;             'PMWIN' index 738;
FUNCTION WinGetClipPS(ahwnd,hwndClip:HWND;fl:ULONG):HPS;
                          APIENTRY;             'PMWIN' index 749;
FUNCTION WinGetPS(ahwnd:HWND):HPS;
                          APIENTRY;             'PMWIN' index 757;
FUNCTION WinGetScreenPS(hwndDesktop:HWND):HPS;
                          APIENTRY;             'PMWIN' index 759;
FUNCTION WinQueryWindowDC(ahwnd:HWND):HDC;
                          APIENTRY;             'PMWIN' index 835;
FUNCTION WinOpenWindowDC(ahwnd:HWND):HDC;
                          APIENTRY;             'PMWIN' index 794;
FUNCTION WinReleasePS(ahps:HPS):BOOL;
                          APIENTRY;             'PMWIN' index 848;
FUNCTION WinWindowFromDC(ahdc:HDC):HWND;
                          APIENTRY;             'PMWIN' index 898;


// Dialogs
// WinCheckButton
FUNCTION WinCreateDlg(hwndParent,hwndOwner:HWND;pfnDlgProc:POINTER;
                      VAR pdlgt:DLGTEMPLATE;pCreateParams:POINTER):HWND;
                    APIENTRY;             'PMWIN' index 922;
FUNCTION WinDefDlgProc(hwndDlg:HWND;msg:ULONG;mp1,mp2:MPARAM):MRESULT;
                    APIENTRY;             'PMWIN' index 910;
// WinDefFileDlgProc
// WinDefFontDlgProc
// WinDeleteLboxItem
FUNCTION WinDismissDlg(hwndDlg:HWND;usResult:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 729;
FUNCTION WinDlgBox(hwndParent,hwndOwner:HWND;pfnDlgProc:POINTER;
                   hmod:HMODULE;idDlg:ULONG;pCreateParams:POINTER):ULONG;
                    APIENTRY;             'PMWIN' index 923;
// WinEnableControl
FUNCTION WinEnumDlgItem(hwndDlg,ahwnd:HWND;code:ULONG):HWND;
                    APIENTRY;             'PMWIN' index 740;
FUNCTION WinGetDlgMsg(hwndDlg:HWND;VAR pqmsg:QMSG):BOOL;
                    APIENTRY;             'PMWIN' index 914;

FUNCTION WinQueryDlgItemShort(hwndDlg:HWND;idItem:ULONG;VAR pResult:INTEGER;
                              fSigned:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 814;
FUNCTION WinQueryDlgItemText(hwndDlg:HWND;idItem:ULONG;cchBufferMax:LONG;
                             VAR pszText:CSTRING):ULONG;
                    APIENTRY;             'PMWIN' index 815;
FUNCTION WinQueryDlgItemTextLength(hwndDlg:HWND;idItem:ULONG):LONG;
                    APIENTRY;             'PMWIN' index 816;

FUNCTION WinSetDlgItemShort(hwndDlg:HWND;idItem:ULONG;usValue:USHORT;
                            fSigned:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 858;
FUNCTION WinSetDlgItemText(hwndDlg:HWND;idItem:ULONG;pszText:CSTRING):BOOL;
                    APIENTRY;             'PMWIN' index 859;

FUNCTION WinSendDlgItemMsg(hwndDlg:HWND;idItem:ULONG;msg:ULONG;
                           mp1,mp2:MPARAM):ULONG;
                    APIENTRY;             'PMWIN' index 903;


FUNCTION WinLoadDlg(hwndParent,hwndOwner:HWND;pfnDlgProc:POINTER;
                    hmod:HMODULE;idDlg:ULONG;pCreateParams:POINTER):HWND;
                    APIENTRY;             'PMWIN' index 924;
FUNCTION WinMapDlgPoints(hwndDlg:HWND;VAR prgwptl:POINTL;cwpt:ULONG;
                         fCalcWindowCoords:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 787;

FUNCTION WinProcessDlg(hwndDlg:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 796;



// Drawing functions
FUNCTION WinDrawBitmap(hpsDst:HPS;hbm:HBITMAP;VAR pwrcSrc;
                       VAR pptlDst;clrFore,clrBack:LONG;
                       fl:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 730;
FUNCTION WinDrawBorder(ahps:HPS;CONST prcl:RECTL;cx,cy,clrFore,clrBack:LONG;
                       flCmd:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 731;
FUNCTION WinDrawPointer(ahps:HPS;x,y:LONG;hptr:HPOINTER;fs:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 732;
FUNCTION WinDrawText(ahps:HPS;cchText:LONG;VAR lpchText;VAR prcl:RECTL;
                     clrFore,clrBack:LONG;flCmd:ULONG):LONG;
                          APIENTRY;             'PMWIN' index 913;
FUNCTION WinFillRect(ahps:HPS;CONST prcl:RECTL;lColor:LONG):BOOL;
                          APIENTRY;             'PMWIN' index 743;
FUNCTION WinInvertRect(ahps:HPS;CONST prcl:RECTL):BOOL;
                          APIENTRY;             'PMWIN' index 767;
FUNCTION WinMakePoints(ahab:HAB;VAR pwpt:WPOINT;cwpt:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 785;
FUNCTION WinRealizePalette(ahwnd:HWND;ahps:HPS;VAR pcclr:ULONG):LONG;
                    APIENTRY;             'PMWIN' index 941;
FUNCTION WinScrollWindow(ahwnd:HWND;dx,dy:LONG;CONST prclScroll,prclClip:RECTL;
                         hrgnUpdate:HRGN;VAR prclUpdate:RECTL;
                         rgfsw:ULONG):LONG;
                          APIENTRY;             'PMWIN' index 849;
FUNCTION WinShowTrackRect(ahwnd:HWND;fShow:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 882;
FUNCTION WinTrackRect(ahwnd:HWND;ahps:HPS;VAR pti:TRACKINFO):BOOL;
                    APIENTRY;             'PMWIN' index 890;



// Dynamic Link Library
FUNCTION WinDeleteLibrary(ahab:HAB;libhandle:HLIB):BOOL;
                    APIENTRY;             'PMWIN' index 722;
FUNCTION WinDeleteProcedure(ahab:HAB;wndproc:POINTER):BOOL;
                    APIENTRY;             'PMWIN' index 604;
FUNCTION WinLoadLibrary(ahab:HAB;VAR libname:CSTRING):HLIB;
                    APIENTRY;             'PMWIN' index 777;
FUNCTION WinLoadProcedure(ahab:HAB;libhandle:HLIB;VAR procname:CSTRING):POINTER;
                    APIENTRY;             'PMWIN' index 603;

// Error handling
FUNCTION WinGetErrorInfo(ahab:HAB):PERRINFO;
                    APIENTRY;             'PMWIN' index 751;
FUNCTION WinGetLastError(ahab:HAB):ERRORID;
                    APIENTRY;             'PMWIN' index 753;
FUNCTION WinFreeErrorInfo(VAR perrinfo:ERRINFO):BOOL;
                    APIENTRY;             'PMWIN' index 748;


// Focus

// Menuing
// WomCheckMenuItem
FUNCTION WinCreateMenu(hwndParent:HWND;VAR lpmt):HWND;
                    APIENTRY;             'PMWIN' index 907;
// WinEnableMenuItem
// WinIsMenuItemChecked
// WinIsMenuItemEnabled
// WinIsMenuItemValid
FUNCTION WinLoadMenu(hwndFrame:HWND;hmod:HMODULE;idMenu:ULONG):HWND;
                    APIENTRY;             'PMWIN' index 778;
FUNCTION WinPopupMenu(hwndParent,hwndOwner,hwndMenu:HWND;x,y,idItem:LONG;
                      fs:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 937;
// WinSetMenuItemText

// Messaging
FUNCTION WinBroadcastMsg(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM;rgf:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 901;
FUNCTION WinCallMsgFilter(ahab:HAB;VAR pqmsg:QMSG;msgf:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 905;
FUNCTION WinCheckInput(ahab:HAB):BOOL;
                    APIENTRY;             'PMWIN' index 998;
// WinCreateMsgQueue
// WinDestroyMsgQueue
FUNCTION WinDispatchMsg(ahab:HAB;VAR pqmsg:QMSG):ULONG;
                          APIENTRY;             'PMWIN' index 912;
FUNCTION WinGetMsg(ahab:HAB;VAR pqmsg:QMSG;hwndFilter:HWND;
                   msgFilterFirst,msgFilterLast:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 915;
FUNCTION WinInSendMsg(ahab:HAB):BOOL;
                          APIENTRY;             'PMWIN' index 761;
FUNCTION WinPeekMsg(ahab:HAB;VAR pqmsg:QMSG;hwndFilter:HWND;
                    msgFilterFirst,msgFilterLast:ULONG;fl:ULONG):BOOL;
                          APIENTRY;             'PMWIN' index 918;
FUNCTION WinPostMsg(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM):BOOL;
                          APIENTRY;             'PMWIN' index 919;
FUNCTION WinPostQueueMsg(ahmq:HMQ;msg:ULONG;mp1,mp2:MPARAM):BOOL;
                    APIENTRY;             'PMWIN' index 902;
FUNCTION WinQueryMsgPos(ahab:HAB;VAR pptl:POINTL):BOOL;
                    APIENTRY;             'PMWIN' index 818;
FUNCTION WinQueryMsgTime(ahab:HAB):ULONG;
                    APIENTRY;             'PMWIN' index 819;
FUNCTION WinQueryQueueStatus(hwndDesktop:HWND):ULONG;
                    APIENTRY;             'PMWIN' index 825;
FUNCTION WinRegisterUserDatatype(ahab:HAB;datatype,count:LONG;
                                 VAR astypes):BOOL;
                          APIENTRY;             'PMWIN' index 845;
FUNCTION WinRegisterUserMsg(ahab:HAB;msgid:ULONG;
                            datatype1,dir1,datatype2,dir2,
                            datatyper:LONG):BOOL;
                          APIENTRY;             'PMWIN' index 846;
FUNCTION WinReleaseHook(ahab:HAB;ahmq:HMQ;iHook:LONG;pfnHook:POINTER;
                        hmod:HMODULE):BOOL;
                    APIENTRY;             'PMWIN' index 927;
FUNCTION WinRequestMutexSem(ahmtx:HMTX;ulTimeout:ULONG):APIRET;
                    APIENTRY;             'PMWIN' index 979;
FUNCTION WinSendMsg(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM):ULONG;
                          APIENTRY;             'PMWIN' index 920;
FUNCTION WinSetClassMsgInterest(ahab:HAB;VAR pszClassName:CSTRING;msg_class:ULONG;
                                control:LONG):BOOL;
                    APIENTRY;             'PMWIN' index 853;
FUNCTION WinSetHook(ahab:HAB;ahmq:HMQ;iHook:LONG;pfnHook:POINTER;
                    hmod:HMODULE):BOOL;
                    APIENTRY;             'PMWIN' index 928;
FUNCTION WinSetMsgInterest(ahwnd:HWND;msg_class:ULONG;control:LONG):BOOL;
                    APIENTRY;             'PMWIN' index 861;
FUNCTION WinSetMsgMode(ahab:HAB;classname:CSTRING;control:LONG):BOOL;
                          APIENTRY;             'PMWIN' index 862;
FUNCTION WinSetSynchroMode(ahab:HAB;mode:LONG):BOOL;
                          APIENTRY;             'PMWIN' index 870;
FUNCTION WinWaitEventSem(ahev:HEV;ulTimeout:ULONG):APIRET;
                    APIENTRY;             'PMWIN' index 978;
FUNCTION WinWaitMsg(ahab:HAB;msgFirst,msgLast:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 897;
FUNCTION WinWaitMuxWaitSem(ahmux:HMUX;ulTimeout:ULONG;
                           VAR pulUser:ULONG):APIRET;
                    APIENTRY;             'PMWIN' index 980;

// National Language/Code Page
FUNCTION WinCompareStrings(ahab:HAB;idcp,idcc:ULONG;psz1,psz2:CSTRING;
                           reserved:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 708;
FUNCTION WinCpTranslateChar(ahab:HAB;cpSrc:ULONG;chSrc:UCHAR;
                            cpDst:ULONG):UCHAR;
                    APIENTRY;             'PMWIN' index 711;
FUNCTION WinCpTranslateString(ahab:HAB;cpSrc:ULONG;pszSrc:CSTRING;
                              cpDst,cchDestMax:ULONG;
                              VAR pchDest:CSTRING):BOOL;
                    APIENTRY;             'PMWIN' index 712;
FUNCTION WinNextChar(ahab:HAB;idcp,idcc:ULONG;VAR apsz:CSTRING):PChar;
                    APIENTRY;             'PMWIN' index 791;
FUNCTION WinPrevChar(ahab:HAB;idcp,idcc:ULONG;pszStart,apsz:CSTRING):PChar;
                    APIENTRY;             'PMWIN' index 795;
FUNCTION WinQueryCp(ahmq:HMQ):ULONG;
                    APIENTRY;             'PMWIN' index 810;
FUNCTION WinQueryCpList(ahab:HAB;ccpMax:ULONG;VAR prgcp):ULONG;
                    APIENTRY;             'PMWIN' index 811;
FUNCTION WinSetCp(ahmq:HMQ;idCodePage:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 857;
FUNCTION WinUpper(ahab:HAB;idcp,idcc:ULONG;VAR apsz:CSTRING):ULONG;
                    APIENTRY;             'PMWIN' index 893;
FUNCTION WinUpperChar(ahab:HAB;idcp,idcc,c:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 894;

// Rectangle functions
FUNCTION WinCopyRect(ahab:HAB;VAR prclDst,prclSrc:RECTL):BOOL;
                    APIENTRY;             'PMWIN' index 710;
FUNCTION WinEqualRect(ahab:HAB;CONST prcl1,prcl2:RECTL):BOOL;
                    APIENTRY;             'PMWIN' index 741;
FUNCTION WinInflateRect(ahab:HAB;VAR prcl:RECTL;cx,cy:LONG):BOOL;
                    APIENTRY;             'PMWIN' index 762;
FUNCTION WinIntersectRect(ahab:HAB;VAR prclDst:RECTL;CONST prclSrc1,prclSrc2:RECTL):BOOL;
                    APIENTRY;             'PMWIN' index 764;
FUNCTION WinIsRectEmpty(ahab:HAB;CONST prcl:RECTL):BOOL;
                    APIENTRY;             'PMWIN' index 770;
FUNCTION WinMakeRect(ahab:HAB;VAR pwrc:WRECT):BOOL;
                    APIENTRY;             'PMWIN' index 786;
FUNCTION WinOffsetRect(ahab:HAB;VAR prcl:RECTL;cx,cy:LONG):BOOL;
                    APIENTRY;             'PMWIN' index 792;
FUNCTION WinPtInRect(ahab:HAB;CONST prcl:RECTL;CONST pptl:POINTL):BOOL;
                    APIENTRY;             'PMWIN' index 797;
FUNCTION WinSetRect(ahab:HAB;VAR prcl:RECTL;xLeft,yBottom,xRight,
                    yTop:LONG):BOOL;
                    APIENTRY;             'PMWIN' index 868;
FUNCTION WinSetRectEmpty(ahab:HAB;VAR prcl:RECTL):BOOL;
                    APIENTRY;             'PMWIN' index 869;
FUNCTION WinSubtractRect(ahab:HAB;VAR prclDst:RECTL;CONST prclSrc1,prclSrc2:RECTL):BOOL;
                    APIENTRY;             'PMWIN' index 887;
FUNCTION WinUnionRect(ahab:HAB;VAR prclDst:RECTL;CONST prclSrc1,prclSrc2:RECTL):BOOL;
                    APIENTRY;             'PMWIN' index 891;

// Regions/Clipping
/*    * WinExcludeUpdateRegion
    * WinInvalidateRect
    * WinInvalidateRegion
    * WinLockVisRegions
    * WinLockWindowUpdate
    * WinQueryUpdateRect
    * WinQueryUpdateRegion
    * WinQueryVisibleRegion
    * WinSetVisibleRegionNotify
    * WinUpdateWindow
    * WinValidateRect
    * WinValidateRegion */
FUNCTION WinQueryVisibleRegion(ahwnd: HWND; ahrgn: HRGN): ULONG;
                    APIENTRY;             'PMWIN' index 1000;
FUNCTION WinSetVisibleRegionNotify(ahwnd: HWND; fEnable: BOOL): BOOL;
                    APIENTRY;             'PMWIN' index 1001;

// Resource Management
FUNCTION WinLoadString(ahab:HAB;hmod:HMODULE;id:ULONG;cchMax:LONG;
                       VAR pchBuffer:CSTRING):LONGINT;
                          APIENTRY;             'PMWIN' index 781;
FUNCTION WinLoadMessage(ahab:HAB;hmod:HMODULE;id:ULONG;cchMax:LONG;
                        VAR pchBuffer):LONG;
                          APIENTRY;             'PMWIN' index 779;

// Accel Table
FUNCTION WinCopyAccelTable(ahaccel:HACCEL;VAR pAccelTable:ACCELTABLE;
                           cbCopyMax:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 709;
FUNCTION WinCreateAccelTable(ahab:HAB;VAR pAccelTable:ACCELTABLE):HACCEL;
                    APIENTRY;             'PMWIN' index 713;
FUNCTION WinDestroyAccelTable(ahaccel:HACCEL):BOOL;
                    APIENTRY;             'PMWIN' index 723;
FUNCTION WinLoadAccelTable(ahab:HAB;hmod:HMODULE;idAccelTable:ULONG):HACCEL;
                    APIENTRY;             'PMWIN' index 776;
FUNCTION WinQueryAccelTable(ahab:HAB;hwndFrame:HWND):HACCEL;
                    APIENTRY;             'PMWIN' index 798;
FUNCTION WinSetAccelTable(ahab:HAB;ahaccel:HACCEL;hwndFrame:HWND):BOOL;
                    APIENTRY;             'PMWIN' index 850;
FUNCTION WinTranslateAccel(ahab:HAB;ahwnd:HWND;ahaccel:HACCEL;
                           VAR pqmsg:QMSG):BOOL;
                    APIENTRY;             'PMWIN' index 904;


// Pointers
FUNCTION WinCreatePointer(hwndDesktop:HWND;hbmPointer:HBITMAP;
                          fPointer:BOOL;xHotspot,yHotspot:LONG):HPOINTER;
                    APIENTRY;             'PMWIN' index 717;
FUNCTION WinCreatePointerIndirect(hwndDesktop:HWND;
                                  VAR pptri:POINTERINFO):HPOINTER;
                    APIENTRY;             'PMWIN' index 942;
FUNCTION WinDestroyPointer(hptr:HPOINTER):BOOL;
                    APIENTRY;             'PMWIN' index 727;
FUNCTION WinLoadPointer(hwndDesktop:HWND;hmod:HMODULE;idres:ULONG):HPOINTER;
                    APIENTRY;             'PMWIN' index 780;
FUNCTION WinLockPointerUpdate(hwndDesktop:HWND;hptrNew:HPOINTER;
                              ulTimeInterval:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 639;
FUNCTION WinQueryPointer(hwndDesktop:HWND):HPOINTER;
                    APIENTRY;             'PMWIN' index 821;
FUNCTION WinQueryPointerInfo(hptr:HPOINTER;
                             VAR pPointerInfo:POINTERINFO):BOOL;
                    APIENTRY;             'PMWIN' index 822;
FUNCTION WinQueryPointerPos(hwndDesktop:HWND;VAR pptl:POINTL):BOOL;
                    APIENTRY;             'PMWIN' index 823;
FUNCTION WinSetPointer(hwndDesktop:HWND;hptrNew:HPOINTER):BOOL;
                    APIENTRY;             'PMWIN' index 866;
FUNCTION WinSetPointerOwner(hptr:HPOINTER;apid:PID;fDestroy:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 971;
FUNCTION WinSetPointerPos(hwndDesktop:HWND;x,y:LONG):BOOL;
                    APIENTRY;             'PMWIN' index 867;
FUNCTION WinShowPointer(hwndDesktop:HWND;fShow:BOOL):BOOL;
                    APIENTRY;             'PMWIN' index 881;

FUNCTION WinQuerySysPointer(hwndDesktop:HWND;iptr:LONG;fLoad:BOOL):HPOINTER;
                    APIENTRY;             'PMWIN' index 828;
{FUNCTION WinQuerySysPointerData(hwndDesktop:HWND;iptr:ULONG;
                                VAR pIconInfo:ICONINFO):BOOL;
                    APIENTRY;             'PMWIN' index ???}
{FUNCTION WinSetSysPointerData(hwndDesktop:HWND;iptr:ULONG;
                              VAR pIconInfo:ICONINFO):BOOL;
                    APIENTRY;             'PMWIN' index ???}


// Timers
FUNCTION WinStartTimer(ahab:HAB;ahwnd:HWND;idTimer,dtTimeout:ULONG):ULONG;
                    APIENTRY;             'PMWIN' index 884;
FUNCTION WinStopTimer(ahab:HAB;ahwnd:HWND;idTimer:ULONG):BOOL;
                    APIENTRY;             'PMWIN' index 885;

END;  {IMPORTS}

FUNCTION MPFROMP(p:POINTER):MPARAM;
FUNCTION MPFROMHWND(ahwnd:HWND):MPARAM;
FUNCTION MPFROMCHAR(ch:USHORT):MPARAM;
FUNCTION MPFROM2CH(s:USHORT;uch1,uch2:BYTE):MPARAM;
FUNCTION MPFROMLONG(l:ULONG):MPARAM;
FUNCTION SHORT1FROMMP(p:MPARAM):WORD;ASSEMBLER;
FUNCTION SHORT2FROMMP(p:MPARAM):WORD;ASSEMBLER;
FUNCTION MPFrom2Short(s1,s2:WORD):MPARAM;ASSEMBLER;
FUNCTION MPFromShort(s:Word):MPARAM;ASSEMBLER;

FUNCTION PVOIDFROMMP(mp:MPARAM):POINTER;
FUNCTION HWNDFROMMP(mp:MPARAM):HWND;
FUNCTION CHAR1FROMMP(mp:MPARAM):BYTE;
FUNCTION CHAR2FROMMP(mp:MPARAM):BYTE;
FUNCTION CHAR3FROMMP(mp:MPARAM):BYTE;
FUNCTION CHAR4FROMMP(mp:MPARAM):BYTE;
FUNCTION LONGFROMMP(mp:MPARAM):ULONG;

FUNCTION MRFROMP(p:MPARAM):ULONG;
FUNCTION MRFROMSHORT(s:USHORT):ULONG;
FUNCTION MRFROM2SHORT(s1,s2:USHORT):ULONG;
FUNCTION MRFROMLONG(l:ULONG):ULONG;

FUNCTION PVOIDFROMMR(mr:MRESULT):POINTER;
FUNCTION SHORT1FROMMR(mr:MRESULT):USHORT;
FUNCTION SHORT2FROMMR(mr:MRESULT):USHORT;
FUNCTION LONGFROMMR(mr:MRESULT):ULONG;

FUNCTION WinCheckButton(hwndDlg:HWND;id,uscheckState:USHORT):ULONG;
FUNCTION WinQueryButtonCheckState(hwndDlg:HWND;id:USHORT):ULONG;
FUNCTION WinEnableControl(hwndDlg:HWND;id:USHORT;fEnable:BOOL):BOOL;
FUNCTION WinIsControlEnabled(hwndDlg:HWND;id:USHORT):BOOL;

FUNCTION WinDeleteLBoxItem(hwndLBox:HWND;index:LONG):LONG;
FUNCTION WinInsertLBoxItem(hwndLBox:HWND;index:LONG;apsz:CSTRING):LONG;
FUNCTION WinQueryLBoxCount(hwndLBox:HWND):LONG;
FUNCTION WinQueryLBoxItemText(hwndLBox:HWND;index:LONG;VAR apsz:CSTRING;
                              cchMax:SHORT):LONG;
FUNCTION WinQueryLboxItemTextLength(hwndLbox:HWND;index:LONG):LONG;

FUNCTION WinSetLboxItemText(hwndLbox:HWND;index:LONG;apsz:CSTRING):BOOL;
FUNCTION WinQueryLboxSelectedItem(hwndLbox:HWND):LONG;

FUNCTION WinCheckMenuItem(hwndMenu:HWND;id:ULONG;fcheck:BOOL):BOOL;
FUNCTION WinIsMenuItemChecked(hwndMenu:HWND;id:ULONG):BOOL;
FUNCTION WinEnableMenuItem(hwndMenu:HWND;id:ULONG;fenable:BOOL):BOOL;
FUNCTION WinIsMenuItemEnabled(hwndMenu:HWND;id:ULONG):BOOL;
FUNCTION WinSetMenuItemText(hwndMenu:HWND;id:ULONG;apsz:CSTRING):BOOL;
FUNCTION WinIsMenuItemValid(hwndMenu:HWND;id:ULONG):BOOL;

FUNCTION DDES_PSZITEMNAME(pddes:PDDESTRUCT):PChar;
FUNCTION DDES_PABDATA(pddes:PDDESTRUCT):PBYTE;
FUNCTION DDEI_PCONVCONTEXT(pddei:PDDEINIT):PCONVCONTEXT;



IMPLEMENTATION



{ Macros to make an MPARAM from standard type.}

FUNCTION SHORT1FROMMP(p:MPARAM):WORD;ASSEMBLER;
     ASM
        MOV AX,p
        MOV Result,AX
     END;

FUNCTION SHORT2FROMMP(p:MPARAM):WORD;ASSEMBLER;
     ASM
        MOV AX,p+2
        MOV Result,AX
     END;

FUNCTION MPFrom2Short(s1,s2:WORD):MPARAM;ASSEMBLER;
     ASM
        MOV AX,s2
        PUSH AX
        MOV AX,s1
        PUSH AX
        POP EAX
        MOV Result,EAX
     END;

FUNCTION MPFromShort(s:Word):MPARAM;ASSEMBLER;
     ASM
        MOV AX,s
        MOVZX EAX,AX
        MOV result,EAX
     END;

FUNCTION MPFROMP(p:POINTER):MPARAM;
BEGIN
     MPFROMP:=MPARAM(p);
END;

FUNCTION MPFROMHWND(ahwnd:HWND):MPARAM;
BEGIN
     MPFROMHWND:=ahwnd;
END;

FUNCTION MPFROMCHAR(ch:USHORT):MPARAM;
BEGIN
     MPFROMCHAR:=ch;
END;


FUNCTION MPFROM2CH(s:USHORT;uch1,uch2:BYTE):MPARAM;
VAR w:USHORT;
BEGIN
     w:=MAKESHORT(uch1,uch2);
     MPFROM2CH:=MAKELONG(s,w);
END;


FUNCTION MPFROMLONG(l:ULONG):MPARAM;
BEGIN
     MPFROMLONG:=l;
END;


{ Macros to extract standard types from an MPARAM }


FUNCTION PVOIDFROMMP(mp:MPARAM):POINTER;
BEGIN
     PVOIDFROMMP:=POINTER(mp);
END;

FUNCTION HWNDFROMMP(mp:MPARAM):HWND;
BEGIN
     HWNDFROMMP:=HWND(mp);
END;

FUNCTION CHAR1FROMMP(mp:MPARAM):BYTE;
BEGIN
     CHAR1FROMMP:=ULONG(mp);
END;

FUNCTION CHAR2FROMMP(mp:MPARAM):BYTE;
BEGIN
     CHAR2FROMMP:=ULONG(mp) SHR 8;
END;

FUNCTION CHAR3FROMMP(mp:MPARAM):BYTE;
BEGIN
     CHAR3FROMMP:=ULONG(mp) SHR 16;
END;

FUNCTION CHAR4FROMMP(mp:MPARAM):BYTE;
BEGIN
     CHAR4FROMMP:=ULONG(mp) SHR 24;
END;


FUNCTION LONGFROMMP(mp:MPARAM):ULONG;
BEGIN
     LONGFROMMP:=ULONG(mp);
END;


{ Macros to make an MRESULT from standard types. }

FUNCTION MRFROMP(p:MPARAM):ULONG;
BEGIN
     MRFROMP:=ULONG(p);
END;

FUNCTION MRFROMSHORT(s:USHORT):ULONG;
BEGIN
     MRFROMSHORT:=s;
END;

FUNCTION MRFROM2SHORT(s1,s2:USHORT):ULONG;
BEGIN
     MRFROM2SHORT:=MAKELONG(s1,s2);
END;

FUNCTION MRFROMLONG(l:ULONG):ULONG;
BEGIN
     MRFROMLONG:=l;
END;


{ Macros to extract standard types from an MRESULT }


FUNCTION PVOIDFROMMR(mr:MRESULT):POINTER;
BEGIN
     PVOIDFROMMR:=POINTER(mr);
END;

FUNCTION SHORT1FROMMR(mr:MRESULT):USHORT;
BEGIN
     SHORT1FROMMR:=ULONG(mr);
END;

FUNCTION SHORT2FROMMR(mr:MRESULT):USHORT;
BEGIN
     SHORT2FROMMR:=ULONG(mr) SHR 16;
END;

FUNCTION LONGFROMMR(mr:MRESULT):ULONG;
BEGIN
     LONGFROMMR:=ULONG(mr);
END;

{ Useful macros }


{ sets the check state of button #id.
  returns the previous check state.}
FUNCTION WinCheckButton(hwndDlg:HWND;id,usCheckState:USHORT):ULONG;
BEGIN
     WinCheckButton:=WinSendDlgItemMsg(hwndDlg,id,BM_SETCHECK,
                                  MPFROMSHORT(usCheckState),0);
END;


{ returns the check state of buttin #id. }
FUNCTION WinQueryButtonCheckState(hwndDlg:HWND;id:USHORT):ULONG;
BEGIN
     WinQueryButtonCheckState:=WinSendDlgItemMsg(hwndDlg,id,BM_QUERYCHECK,
                                                 0,0);
END;

{ sets the enable state of button #id.
  returns fSuccess. }
FUNCTION WinEnableControl(hwndDlg:HWND;id:USHORT;fEnable:BOOL):BOOL;
VAR Win:HWND;
BEGIN
     Win:=WinWindowFromID(hwndDlg,id);
     WinEnableControl:=WinEnableWindow(Win,fEnable);
END;

{ returns the enable state of control #id. }
FUNCTION WinIsControlEnabled(hwndDlg:HWND;id:USHORT):BOOL;
BEGIN
     WinIsControlEnabled:=WinIsWindowEnabled(WinWindowFromID(hwndDlg,id));
END;


{ Dialog Manager COMMON subsection }


{ deletes item index from the listbox.
  returns the number of items left. }
FUNCTION WinDeleteLBoxItem(hwndLBox:HWND;index:LONG):LONG;
BEGIN
     WinDeleteLBoxItem:=WinSendMsg(hwndLBox,LM_DELETEITEM,MPFROMLONG(index),
                                   0);
END;

{ inserts psz into a listbox at index.  Index may be an LIT_ constant.
  returns the actual index where it was inserted. }
FUNCTION WinInsertLBoxItem(hwndLBox:HWND;index:LONG;apsz:CSTRING):LONG;
BEGIN
     WinInsertLBoxItem:=WinSendMsg(hwndLBox,LM_INSERTITEM,MPFROMLONG(index),
                                   ULONG(@apsz));
END;

{ returns the number of items in the listbox. }
FUNCTION WinQueryLBoxCount(hwndLBox:HWND):LONG;
BEGIN
     WinQueryLBoxCount:=WinSendMsg(hwndLBox,LM_QUERYITEMCOUNT,0,0);
END;


FUNCTION WinQueryLBoxItemText(hwndLBox:HWND;index:LONG;VAR apsz:CSTRING;
                              cchMax:SHORT):LONG;
BEGIN
     WinQueryLBoxItemText:=WinSendMsg(hwndLBox,LM_QUERYITEMTEXT,
                             MPFROM2SHORT(index,cchMax),ULONG(@apsz));
END;

{ returns the length of item index. }
FUNCTION WinQueryLboxItemTextLength(hwndLbox:HWND;index:LONG):LONG;
BEGIN
     WinQueryLBoxItemTextLength:=WinSendMsg(hwndLBox,LM_QUERYITEMTEXTLENGTH,
                                            MPFROMSHORT(index),0);
END;


{ sets the text of item index to psz.
  returns fSuccess. }
FUNCTION WinSetLboxItemText(hwndLbox:HWND;index:LONG;apsz:CSTRING):BOOL;
BEGIN
     WinSetLBoxItemText:=BOOL(WinSendMsg(hwndLBox,LM_SETITEMTEXT,
                           MPFROMLONG(index),ULONG(@apsz)));
END;

{ returns the item index selected. (for single selection only) }
FUNCTION WinQueryLboxSelectedItem(hwndLbox:HWND):LONG;
BEGIN
     WinQueryLBoxSelectedItem:=WinSendMsg(hwndLBox,LM_QUERYSELECTION,
                                 MPFROMLONG(LIT_FIRST),0);
END;

{ Useful macros }


{ Sets the check state of menuitem #id to fcheck.
  returns fSuccess. }
FUNCTION WinCheckMenuItem(hwndMenu:HWND;id:ULONG;fcheck:BOOL):BOOL;
VAR w:USHORT;
BEGIN
     IF fCheck THEN w:=MIA_CHECKED
     ELSE w:=0;
     WinCheckMenuItem:=BOOL(WinSendMsg(hwndMenu,MM_SETITEMATTR,
                       MPFROM2SHORT(id,1),MPFROM2SHORT(MIA_CHECKED,w)));
END;

FUNCTION WinIsMenuItemChecked(hwndMenu:HWND;id:ULONG):BOOL;
BEGIN
     WinIsMenuItemChecked:=BOOL(WinSendMsg(hwndMenu,MM_QUERYITEMATTR,
                             MPFROM2SHORT(id,1),MPFROMLONG(MIA_CHECKED)));
END;

{ sets the enable state of menuitem #id to fenable.
  returns fSuccess. }
FUNCTION WinEnableMenuItem(hwndMenu:HWND;id:ULONG;fenable:BOOL):BOOL;
VAR w:USHORT;
BEGIN
     IF fEnable THEN w:=0
     ELSE w:=MIA_DISABLED;
     WinEnableMenuItem:=BOOL(WinSendMsg(hwndMenu,MM_SETITEMATTR,
                         MPFROM2SHORT(id,1),MPFROM2SHORT(MIA_DISABLED,w)));
END;

{ returns the enable state of menuitem #id. }
FUNCTION WinIsMenuItemEnabled(hwndMenu:HWND;id:ULONG):BOOL;
VAR l:ULONG;
BEGIN
     l:=WinSendMsg(hwndMenu,MM_QUERYITEMATTR,MPFROM2SHORT(id,1),
                   MPFROMLONG(MIA_DISABLED));
     IF l<>0 THEN WinIsMenuItemEnabled:=FALSE
     ELSE WinIsMenuItemEnabled:=TRUE;
END;


{ sets the text of menuitem #id.
  returns fSuccess.  }
FUNCTION WinSetMenuItemText(hwndMenu:HWND;id:ULONG;apsz:CSTRING):BOOL;
BEGIN
     WinSetMenuItemText:=BOOLEAN(WinSendMsg(hwndMenu,MM_SETITEMTEXT,
                           MPFROMLONG(id),ULONG(@apsz)));
END;

{ Returns TRUE if the specified item is a valid choice. }
FUNCTION WinIsMenuItemValid(hwndMenu:HWND;id:ULONG):BOOL;
BEGIN
     WinIsMenuItemValid:=BOOLEAN(WinSendMsg(hwndMenu,MM_ISITEMVALID,
                            MPFROM2SHORT(id,1),MPFROMLONG(0)));
END;


{ DDE helper macros }


FUNCTION DDES_PSZITEMNAME(pddes:PDDESTRUCT):PChar;
BEGIN
     inc(pddes,pddes^.offszItemName);
     DDES_PSZITEMNAME:=POINTER(pddes);
END;


FUNCTION DDES_PABDATA(pddes:PDDESTRUCT):PBYTE;
BEGIN
     inc(pddes,pddes^.offabData);
     DDES_PABDATA:=POINTER(pddes);
END;

FUNCTION DDEI_PCONVCONTEXT(pddei:PDDEINIT):PCONVCONTEXT;
BEGIN
     inc(pddei,pddei^.offConvContext);
     DDEI_PCONVCONTEXT:=POINTER(pddei);
END;

BEGIN
END.



{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PmHelp;

{****************************************************************************
 *                                                                          *
 * OS/2 Presentation Manager Information Presentation Facility,             *
 * Help Manager declarations.                                               *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def,PmBitmap,PmWin;

{**********************************************************************
 HelpSubTable entry structure
 **********************************************************************}
TYPE
    HELPSUBTABLE=USHORT;
    PHELPSUBTABLE=^HELPSUBTABLE;

    PHELPTABLE=^HELPTABLE;
    HELPTABLE=RECORD {pack 2}
                   idAppWindow:USHORT;
                   phstHelpSubTable:PHELPSUBTABLE;
                   idExtPanel:USHORT;
              END;

{**********************************************************************}
{ IPF Initialization Structure used on the                             }
{ WinCreateHelpInstance() call.                                        }
{**********************************************************************}
TYPE
   PHELPINIT=^HELPINIT;
   HELPINIT=RECORD
                 cb:ULONG;
                 ulReturnCode:ULONG;
                 pszTutorialName:PCHAR;
                 phtHelpTable:PHELPTABLE;
                 hmodHelpTableModule:HMODULE;
                 hmodAccelActionBarModule:HMODULE;
                 idAccelTable:ULONG;
                 idActionBar:ULONG;
                 pszHelpWindowTitle:PChar;
                 fShowPanelId:ULONG;
                 pszHelpLibraryName:PChar;
           END;


{**********************************************************************}
{ Search parent chain indicator for HM_SET_ACTIVE_WINDOW message.      }
{**********************************************************************}
CONST
     HWND_PARENT               =0;

{**********************************************************************}
{ Constants used to define whether user wants to display panel using   }
{ panel number or panel name.                                          }
{**********************************************************************}
     HM_RESOURCEID             =0;
     HM_PANELNAME              =1;

     HMPANELTYPE_NUMBER        =0;
     HMPANELTYPE_NAME          =1;

{**********************************************************************}
{ Constants used to define how the panel IDs are displayed on          }
{ help panels.                                                         }
{**********************************************************************}
     CMIC_HIDE_PANEL_ID        =$0000;
     CMIC_SHOW_PANEL_ID        =$0001;
     CMIC_TOGGLE_PANEL_ID      =$0002;


{**********************************************************************}
{ IPF message base.                                                    }
{**********************************************************************}
     HM_MSG_BASE               =$0220;

   {**********************************************************************}
   { Messages applications can send to the IPF.                           }
   {**********************************************************************}
     HM_DISMISS_WINDOW              =HM_MSG_BASE+$0001;
     HM_DISPLAY_HELP                =HM_MSG_BASE+$0002;
     HM_EXT_HELP                    =HM_MSG_BASE+$0003;
     HM_GENERAL_HELP                =HM_EXT_HELP;
     HM_SET_ACTIVE_WINDOW           =HM_MSG_BASE+$0004;
     HM_LOAD_HELP_TABLE             =HM_MSG_BASE+$0005;
     HM_CREATE_HELP_TABLE           =HM_MSG_BASE+$0006;
     HM_SET_HELP_WINDOW_TITLE       =HM_MSG_BASE+$0007;
     HM_SET_SHOW_PANEL_ID           =HM_MSG_BASE+$0008;
     HM_REPLACE_HELP_FOR_HELP       =HM_MSG_BASE+$0009;
     HM_REPLACE_USING_HELP          =HM_REPLACE_HELP_FOR_HELP;
     HM_HELP_INDEX                  =HM_MSG_BASE+$000a;
     HM_HELP_CONTENTS               =HM_MSG_BASE+$000b;
     HM_KEYS_HELP                   =HM_MSG_BASE+$000c;
     HM_SET_HELP_LIBRARY_NAME       =HM_MSG_BASE+$000d;

     HM_SET_OBJCOM_WINDOW           =HM_MSG_BASE+$0018;
     HM_UPDATE_OBJCOM_WINDOW_CHAIN  =HM_MSG_BASE+$0019;
     HM_QUERY_DDF_DATA              =HM_MSG_BASE+$001a;
     HM_INVALIDATE_DDF_DATA         =HM_MSG_BASE+$001b;
     HM_QUERY                       =HM_MSG_BASE+$001c;
     HM_SET_COVERPAGE_SIZE          =HM_MSG_BASE+$001d;

   {**********************************************************************}
   { Constants used to query the info from IPF in HM_QUERY message        }
   {**********************************************************************}

   { Hi word in lParam 1 }
     HMQW_COVERPAGE           =$0001;
     HMQW_INDEX               =$0002;
     HMQW_TOC                 =$0003;
     HMQW_SEARCH              =$0004;
     HMQW_VIEWPAGES           =$0005;
     HMQW_LIBRARY             =$0006;
     HMQW_VIEWPORT            =$0007;
     HMQW_OBJCOM_WINDOW       =$0008;
     HMQW_INSTANCE            =$0009;
     HMQW_ACTIVEVIEWPORT      =$000a;
     CONTROL_SELECTED         =$000b;

     HMQW_GROUP_VIEWPORT      =$00f1;
     HMQW_RES_VIEWPORT        =$00f2;
     USERDATA                 =$00f3;

   { Lo word in lParam1 of HMQW_VIEWPORT }
     HMQVP_NUMBER             =$0001;
     HMQVP_NAME               =$0002;
     HMQVP_GROUP              =$0003;

   {**********************************************************************}
   { Predefined Control IDs                                               }
   {**********************************************************************}
     CTRL_PREVIOUS_ID             =$0001;
     CTRL_SEARCH_ID               =$0002;
     CTRL_PRINT_ID                =$0003;
     CTRL_INDEX_ID                =$0004;
     CTRL_CONTENTS_ID             =$0005;
     CTRL_BACK_ID                 =$0006;
     CTRL_FORWARD_ID              =$0007;
     CTRL_TUTORIAL_ID             =$00FF;

     CTRL_USER_ID_BASE            =257;

   {**********************************************************************}
   { Messages the IPF sends to the applications active window             }
   { as defined by the IPF.                                               }
   {**********************************************************************}

     HM_ERROR                       =HM_MSG_BASE+$000e;
     HM_HELPSUBITEM_NOT_FOUND       =HM_MSG_BASE+$000f;
     HM_QUERY_KEYS_HELP             =HM_MSG_BASE+$0010;
     HM_TUTORIAL                    =HM_MSG_BASE+$0011;
     HM_EXT_HELP_UNDEFINED          =HM_MSG_BASE+$0012;
     HM_GENERAL_HELP_UNDEFINED      =HM_EXT_HELP_UNDEFINED;
     HM_ACTIONBAR_COMMAND           =HM_MSG_BASE+$0013;
     HM_INFORM                      =HM_MSG_BASE+$0014;
     HM_NOTIFY                      =HM_MSG_BASE+$0022;
     HM_SET_USERDATA                =HM_MSG_BASE+$0023;
     HM_CONTROL                     =HM_MSG_BASE+$0024;

   {**********************************************************************}
   { notify information for HM_NOTIFY                                     }
   {**********************************************************************}
     OPEN_COVERPAGE        =$0001;
     OPEN_PAGE             =$0002;
     SWAP_PAGE             =$0003;
     OPEN_TOC              =$0004;
     OPEN_INDEX            =$0005;
     OPEN_HISTORY          =$0006;
     OPEN_SEARCH_HIT_LIST  =$0007;
     OPEN_LIBRARY          =$0008;
     HELP_REQUESTED        =$0009;

   {**********************************************************************}
   { HMERR_NO_FRAME_WND_IN_CHAIN - There is no frame window in the        }
   { window chain from which to find or set the associated help           }
   { instance.                                                            }
   {**********************************************************************}
      HMERR_NO_FRAME_WND_IN_CHAIN                =$00001001;

   {*********************************************************************}
   { HMERR_INVALID_ASSOC_APP_WND - The application window handle         }
   { specified on the WinAssociateHelpInstance() call is not a valid     }
   { window handle.                                                      }
   {*********************************************************************}
      HMERR_INVALID_ASSOC_APP_WND                =$00001002;

   {*********************************************************************}
   { HMERR_INVALID_ASSOC_HELP_INST - The help instance handle specified  }
   { on the WinAssociateHelpInstance() call is not a valid               }
   { window handle.                                                      }
   {*********************************************************************}
      HMERR_INVALID_ASSOC_HELP_INST              =$00001003;

   {*********************************************************************}
   { HMERR_INVALID_DESTROY_HELP_INST - The window handle specified       }
   { as the help instance to destroy is not of the help instance class.  }
   {*********************************************************************}
      HMERR_INVALID_DESTROY_HELP_INST            =$00001004;

   {*********************************************************************}
   { HMERR_NO_HELP_INST_IN_CHAIN - The parent or owner chain of the      }
   { application window specified does not have a help instance          }
   { associated with it.                                                 }
   {*********************************************************************}
      HMERR_NO_HELP_INST_IN_CHAIN                =$00001005;

   {*********************************************************************}
   { HMERR_INVALID_HELP_INSTANCE_HDL - The handle specified to be a      }
   { help instance does not have the class name of a IPF                 }
   { help instance.                                                      }
   {*********************************************************************}
      HMERR_INVALID_HELP_INSTANCE_HDL            =$00001006;

   {*********************************************************************}
   { HMERR_INVALID_QUERY_APP_WND - The application window specified on   }
   { a WinQueryHelpInstance() call is not a valid window handle.         }
   {*********************************************************************}
      HMERR_INVALID_QUERY_APP_WND                =$00001007;

   {*********************************************************************}
   { HMERR_HELP_INST_CALLED_INVALID -  The handle of the help instance   }
   { specified on an API call to the IPF does not have the               }
   { class name of an IPF help instance.                                 }
   {*********************************************************************}
      HMERR_HELP_INST_CALLED_INVALID             =$00001008;

      HMERR_HELPTABLE_UNDEFINE                   =$00001009;
      HMERR_HELP_INSTANCE_UNDEFINE               =$0000100a;
      HMERR_HELPITEM_NOT_FOUND                   =$0000100b;
      HMERR_INVALID_HELPSUBITEM_SIZE             =$0000100c;
      HMERR_HELPSUBITEM_NOT_FOUND                =$0000100d;

   {*********************************************************************}
   { HMERR_INDEX_NOT_FOUND - No index in library file.                   }
   {*********************************************************************}
      HMERR_INDEX_NOT_FOUND                      =$00002001;

   {*********************************************************************}
   { HMERR_CONTENT_NOT_FOUND - Library file does not have any contents.  }
   {*********************************************************************}
      HMERR_CONTENT_NOT_FOUND                    =$00002002;

   {*********************************************************************}
   { HMERR_OPEN_LIB_FILE     - Cannot open library file                  }
   {*********************************************************************}
      HMERR_OPEN_LIB_FILE                        =$00002003;

   {*********************************************************************}
   { HMERR_READ_LIB_FILE     - Cannot read library file                  }
   {*********************************************************************}
      HMERR_READ_LIB_FILE                        =$00002004;

   {*********************************************************************}
   { HMERR_CLOSE_LIB_FILE    - Cannot close library file                 }
   {*********************************************************************}
      HMERR_CLOSE_LIB_FILE                       =$00002005;

   {*********************************************************************}
   { HMERR_INVALID_LIB_FILE  - Improper library file provided            }
   {*********************************************************************}
      HMERR_INVALID_LIB_FILE                     =$00002006;

   {*********************************************************************}
   { HMERR_NO_MEMORY - Unable to allocate the requested amount of memory.}
   {*********************************************************************}
      HMERR_NO_MEMORY                            =$00002007;

   {*********************************************************************}
   { HMERR_ALLOCATE_SEGMENT - Unable                                     }
   { to allocate a segment of memory for memory allocation requested     }
   { from the IPF.                                                       }
   {*********************************************************************}
      HMERR_ALLOCATE_SEGMENT                     =$00002008;

   {*********************************************************************}
   { HMERR_FREE_MEMORY - Unable to free allocated  memory                }
   {*********************************************************************}
      HMERR_FREE_MEMORY                          =$00002009;

   {*********************************************************************}
   { HMERR_PANEL_NOT_FOUND  - Unable                                     }
   { to find a help panel requested to help manager                      }
   {*********************************************************************}
      HMERR_PANEL_NOT_FOUND                      =$00002010;

   {*********************************************************************}
   { HMERR_DATABASE_NOT_OPEN - Unable to read the unopened database      }
   {*********************************************************************}
      HMERR_DATABASE_NOT_OPEN                    =$00002011;

   {*********************************************************************}
   { HMERR_DDL_ERROR - Unable to load resource dll                       }
   {*********************************************************************}
      HMERR_LOAD_DLL                              =$00002013;

{*********************************************************************}
{ AC Viewport stucture definitions                                    }
{*********************************************************************}
TYPE
   PACVP=^ACVP;
   ACVP=RECORD
             cb:ULONG;
             hAB:HAB;
             hmq:HMQ;
             ObjectID:ULONG;            { object identifier }
             hWndParent:HWND;           { IPF viewport client handle }
             hWndOwner:HWND;            { IPF viewport client handle }
             hWndACVP:HWND;             { applications frame window hwnd }
        END;

{*******************************************************************}
{ Define Handle to DDF                                              }
{*******************************************************************}
TYPE
    HDDF=POINTER;

{ DdfHyperText Flags }
CONST
        REFERENCE_BY_ID     =0;
        REFERENCE_BY_RES    =1;

{ DdfBeginList formatting flags }
        HMBT_NONE           =1;
        HMBT_ALL            =2;
        HMBT_FIT            =3;

        HMLS_SINGLELINE     =1;
        HMLS_DOUBLELINE     =2;

{ DdfBitmap alignment flags }
        ART_RUNIN           =$10;
        ART_LEFT            =$01;
        ART_RIGHT           =$02;
        ART_CENTER          =$04;

{ DdfSetColor Color Flag }
        CLR_UNCHANGED       =-6;

{*******************************************************************}
{ error codes returned by DDF API functions                         }
{*******************************************************************}
CONST
        HMERR_DDF_MEMORY                  =$3001;
        HMERR_DDF_ALIGN_TYPE              =$3002;
        HMERR_DDF_BACKCOLOR               =$3003;
        HMERR_DDF_FORECOLOR               =$3004;
        HMERR_DDF_FONTSTYLE               =$3005;
        HMERR_DDF_REFTYPE                 =$3006;
        HMERR_DDF_LIST_UNCLOSED           =$3007;
        HMERR_DDF_LIST_UNINITIALIZED      =$3008;
        HMERR_DDF_LIST_BREAKTYPE          =$3009;
        HMERR_DDF_LIST_SPACING            =$300A;
        HMERR_DDF_HINSTANCE               =$300B;
        HMERR_DDF_EXCEED_MAX_LENGTH       =$300C;
        HMERR_DDF_EXCEED_MAX_INC          =$300D;
        HMERR_DDF_INVALID_DDF             =$300E;
        HMERR_DDF_FORMAT_TYPE             =$300F;
        HMERR_DDF_INVALID_PARM            =$3010;
        HMERR_DDF_INVALID_FONT            =$3011;
        HMERR_DDF_SEVERE                  =$3012;

IMPORTS

FUNCTION WinDestroyHelpInstance(hwndHelpInstance:HWND):BOOL;
               APIENTRY;                    'HELPMGR' index 52;
FUNCTION WinCreateHelpInstance(ahab:HAB;
                               VAR phinitHMInitStructure:HELPINIT):HWND;
               APIENTRY;                    'HELPMGR' index 51;
FUNCTION WinAssociateHelpInstance(hwndHelpInstance,hwndApp:HWND):BOOL;
               APIENTRY;                    'HELPMGR' index 54;
FUNCTION WinQueryHelpInstance(hwndApp:HWND):HWND;
               APIENTRY;                    'HELPMGR' index 53;
FUNCTION WinLoadHelpTable(hwndHelpInstance:HWND;idHelpTable:ULONG;
                          Module:HMODULE):BOOL;
               APIENTRY;                    'HELPMGR' index 55;
FUNCTION WinCreateHelpTable(hwndHelpInstance:HWND;
                            VAR phtHelpTable:HELPTABLE):BOOL;
               APIENTRY;                    'HELPMGR' index 56;
FUNCTION DdfInitialize(hwndHelpInstance:HWND;cbBuffer,
                       ulIncrement:ULONG):HDDF;
               APIENTRY;                    'HELPMGR' index 74;
FUNCTION DdfPara (ahddf:HDDF):BOOL;
               APIENTRY;                    'HELPMGR' index 75;
FUNCTION DdfSetFormat(ahddf:HDDF;fFormatType:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 76;
FUNCTION DdfSetTextAlign (ahddf:HDDF;fAlign:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 77;
FUNCTION DdfSetColor(ahddf:HDDF;fBackColor,fForColor:COLOR):BOOL;
               APIENTRY;                    'HELPMGR' index 78;
FUNCTION DdfInform(ahddf:HDDF;VAR pszText:PSZ;resInformNumber:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 79;
FUNCTION DdfSetFontStyle(ahddf:HDDF;fFontStyle:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 80;
FUNCTION DdfHyperText(ahddf:HDDF;VAR pszText,pszReference:PSZ;
                       fReferenceType:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 81;
FUNCTION DdfBeginList(ahddf:HDDF;ulWidthDT,fBreakType,
                      fSpacing:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 82;
FUNCTION DdfListItem(ahddf:HDDF;VAR pszTerm,pszDescription:PSZ):BOOL;
               APIENTRY;                    'HELPMGR' index 83;
FUNCTION DdfEndList(ahddf:HDDF):BOOL;
               APIENTRY;                    'HELPMGR' index 84;
FUNCTION DdfMetafile(ahddf:HDDF;ahmf:HMF;VAR prclRect:RECTL):BOOL;
               APIENTRY;                    'HELPMGR' index 86;
FUNCTION DdfText(ahddf:HDDF;VAR pszText:PSZ):BOOL;
               APIENTRY;                    'HELPMGR' index 85;
FUNCTION DdfSetFont(ahddf:HDDF;VAR pszFaceName:PSZ;ulWidth,
                    ulHeight:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 87;
FUNCTION DdfBitmap(ahddf:HDDF;hbm:HBITMAP;fAlign:ULONG):BOOL;
               APIENTRY;                    'HELPMGR' index 88;

END; {IMPORTS}

{Help manager helpers}
CONST HelpFilename:CSTRING='FILENAME.HLP';
      HelpWindowTitle:CSTRING='berschrift des Hypertext-Fensters';

      fHelpEnabled:BOOL=FALSE;
      hwndHelpInstance:HWND=0;
      HELP_TABLE:LONGINT=0;

FUNCTION InfoBox(st:STRING):LONGINT;
PROCEDURE InitHelp (hwndClientFrame:HWND);
PROCEDURE DestroyHelp;
PROCEDURE SendHelpMessage (HelpMessage:LONG);
PROCEDURE DisplayHelpPanel (PanelID:LONG);

IMPLEMENTATION

{Help manager helpers}

FUNCTION InfoBox(st:STRING):LONGINT;
BEGIN
     result:=WinMessageBox (HWND_DESKTOP, HWND_DESKTOP, st,'', 0, MB_OK | MB_ERROR);
END;

/*wird vor die Hauptprogramm-Message-Schleife (while WinGetMsg...) gesetzt*/
PROCEDURE InitHelp (hwndClientFrame:HWND);
VAR
   hini:HELPINIT;
   /* If we return because of an error, Help will be disabled */
BEGIN
     fHelpEnabled := FALSE;
     /* Initialize help init structure */
     hini.cb := sizeof(HELPINIT);
     hini.ulReturnCode := 0;
     /* If tutorial added, add name here */
     hini.pszTutorialName := NIL;
     hini.phtHelpTable := PHELPTABLE(MAKELONG(HELP_TABLE, $FFFF));
     hini.hmodHelpTableModule := 0;
     hini.hmodAccelActionBarModule := 0;
     hini.idAccelTable := 0;
     hini.idActionBar := 0;
     hini.pszHelpWindowTitle := @HelpWindowTitle;
     hini.fShowPanelId := CMIC_HIDE_PANEL_ID;
     hini.pszHelpLibraryName := @HelpFilename;
     /* Creating help instance */
     hwndHelpInstance := WinCreateHelpInstance(AppHandle,hini);
     if ((hwndHelpInstance = 0 )OR(hini.ulReturnCode<>0)) THEN
     BEGIN
          InfoBox('Failed to load help manager.');
          exit;
     END;

     /* Associate help instance with main frame */
     if not WinAssociateHelpInstance(hwndHelpInstance, hwndClientFrame) THEN
     BEGIN
          InfoBox('Failed to load help manager.');
          exit;
     END;

     /* Help manager is successfully initialized so set flag to TRUE */
     fHelpEnabled := TRUE;
END;

/*wird hinter die Hauptprogramm-Message-Schleife gesetzt*/
PROCEDURE DestroyHelp;
BEGIN
     IF hwndHelpInstance <> 0 THEN WinDestroyHelpInstance(hwndHelpInstance);
END;

 /*
   einige m”gliche Parameter fr SendHelpMessage
   HM_HELP_INDEX     zeigt Index
   HM_HELP_CONTENTS, zeigt Inhalt
   HM_DISPLAY_HELP   zeigt Hilfe fr Hilfefunktion (help for help)
 */
PROCEDURE SendHelpMessage (HelpMessage:LONG);
BEGIN
     if fHelpEnabled THEN
      if WinSendMsg(hwndHelpInstance, HelpMessage, 0, 0)<>0
        then InfoBox ('Failed to display help panel.');
END;

 /*
   Parameter sind die Panel ID's, definiert ber die ID Punktbefehle
   im MAKEIPF Quelltext
 */
PROCEDURE DisplayHelpPanel (PanelID:LONG);
BEGIN
     if fHelpEnabled then
       if WinSendMsg(hwndHelpInstance, HM_DISPLAY_HELP,
          MPFROMLONG(MAKELONG(PanelID, 0)),
          MPFROMSHORT(HM_RESOURCEID))<>0
           then InfoBox ('Failed to display help panel.');
END;


BEGIN
END.

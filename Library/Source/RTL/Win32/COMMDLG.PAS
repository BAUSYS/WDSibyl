
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT CommDlg;

INTERFACE

USES WinDef,WinNT,WinGDI,WinUser;

TYPE
    LPOPENFILENAME=^OPENFILENAME;
    OPENFILENAME=RECORD
                       lStructSize:LONGWORD;
                       hwndOwner:HWND;
                       hInstance:HINSTANCE;
                       lpstrFilter:PChar;
                       lpstrCustomFilter:PChar;
                       nMaxCustFilter:LONGWORD;
                       nFilterIndex:LONGWORD;
                       lpstrFile:PChar;
                       nMaxFile:LONGWORD;
                       lpstrFileTitle:PChar;
                       nMaxFileTitle:LONGWORD;
                       lpstrInitialDir:PChar;
                       lpstrTitle:PChar;
                       Flags:LONGWORD;
                       nFileOffset:WORD;
                       nFileExtension:WORD;
                       lpstrDefExt:PChar;
                       lCustData:LPARAM;
                       lpfnHook:FUNCTION(ahwnd:HWND;msg:LONGWORD;
                                   awParam:WPARAM;aLParam:LPARAM):LONGWORD;APIENTRY;
                       lpTemplateName:PChar;
    END;

CONST
        OFN_READONLY               = $00000001;
        OFN_OVERWRITEPROMPT        = $00000002;
        OFN_HIDEREADONLY           = $00000004;
        OFN_NOCHANGEDIR            = $00000008;
        OFN_SHOWHELP               = $00000010;
        OFN_ENABLEHOOK             = $00000020;
        OFN_ENABLETEMPLATE         = $00000040;
        OFN_ENABLETEMPLATEHANDLE   = $00000080;
        OFN_NOVALIDATE             = $00000100;
        OFN_ALLOWMULTISELECT       = $00000200;
        OFN_EXTENSIONDIFFERENT     = $00000400;
        OFN_PATHMUSTEXIST          = $00000800;
        OFN_FILEMUSTEXIST          = $00001000;
        OFN_CREATEPROMPT           = $00002000;
        OFN_SHAREAWARE             = $00004000;
        OFN_NOREADONLYRETURN       = $00008000;
        OFN_NOTESTFILECREATE       = $00010000;

        OFN_SHAREFALLTHROUGH       = 2;
        OFN_SHARENOWARN            = 1;
        OFN_SHAREWARN              = 0;

TYPE
    LPCHOOSECOLOR=^TCHOOSECOLOR;
    TCHOOSECOLOR=RECORD
                      lStructSize:LONGWORD;
                      hwndOwner:HWND;
                      hInstance:HWND;
                      rgbResult:COLORREF;
                      lpCustColors:^COLORREF;
                      Flags:LONGWORD;
                      lCustData:LPARAM;
                      lpfnHook:FUNCTION(ahwnd:HWND;msg:LONGWORD;
                                        aWParam:WPARAM;aLParam:LPARAM):LONGWORD;APIENTRY;
                      lpTemplateName:PChar;
    END;

CONST
        CC_RGBINIT              = $00000001;
        CC_FULLOPEN             = $00000002;
        CC_PREVENTFULLOPEN      = $00000004;
        CC_SHOWHELP             = $00000008;
        CC_ENABLEHOOK           = $00000010;
        CC_ENABLETEMPLATE       = $00000020;
        CC_ENABLETEMPLATEHANDLE = $00000040;

TYPE
    LPFINDREPLACE=^FINDREPLACE;
    FINDREPLACE=RECORD
                      lStructSize:LONGWORD;
                      hwndOwner:HWND;
                      hInstance:HINSTANCE;
                      Flags:LONGWORD;
                      lpstrFindWhat:PChar;
                      lpstrReplaceWith:PChar;
                      wFindWhatLen:LONGWORD;
                      wReplaceWithLen:LONGWORD;
                      lCustData:LPARAM;
                      lpfnHook:FUNCTION(ahwnd:HWND;msg:LONGWORD;
                                        aWParam:WPARAM;aLParam:LPARAM):LONGWORD;APIENTRY;
                      lpTemplateName:PChar;
    END;

CONST
        FR_DOWN                       = $00000001;
        FR_WHOLEWORD                  = $00000002;
        FR_MATCHCASE                  = $00000004;
        FR_FINDNEXT                   = $00000008;
        FR_REPLACE                    = $00000010;
        FR_REPLACEALL                 = $00000020;
        FR_DIALOGTERM                 = $00000040;
        FR_SHOWHELP                   = $00000080;
        FR_ENABLEHOOK                 = $00000100;
        FR_ENABLETEMPLATE             = $00000200;
        FR_NOUPDOWN                   = $00000400;
        FR_NOMATCHCASE                = $00000800;
        FR_NOWHOLEWORD                = $00001000;
        FR_ENABLETEMPLATEHANDLE       = $00002000;
        FR_HIDEUPDOWN                 = $00004000;
        FR_HIDEMATCHCASE              = $00008000;
        FR_HIDEWHOLEWORD              = $00010000;

TYPE
    LPCHOOSEFONT=^CHOOSEFONT;
    CHOOSEFONT=RECORD
                     lStructSize:LONGWORD;
                     hwndOwner:HWND;
                     hDC:HDC;
                     lpLogFont:^LOGFONT;
                     iPointSize:LONGINT;
                     Flags:LONGWORD;
                     rgbColors:COLORREF;
                     lCustData:LPARAM;
                     lpfnHook:FUNCTION(ahwnd:HWND;msg:LONGWORD;
                                       aWParam:WPARAM;aLParam:LPARAM):LONGWORD;APIENTRY;
                     lpTemplateName:PChar;
                     hInstance:HINSTANCE;
                     lpszStyle:PChar;
                     nFontType:LONGWORD;
                     nSizeMin:LONGINT;
                     nSizeMax:LONGINT;
     END;

CONST
        CF_SCREENFONTS             = $00000001;
        CF_PRINTERFONTS            = $00000002;
        CF_BOTH                    = CF_SCREENFONTS OR CF_PRINTERFONTS;
        CF_SHOWHELP                = $00000004;
        CF_ENABLEHOOK              = $00000008;
        CF_ENABLETEMPLATE          = $00000010;
        CF_ENABLETEMPLATEHANDLE    = $00000020;
        CF_INITTOLOGFONTSTRUCT     = $00000040;
        CF_USESTYLE                = $00000080;
        CF_EFFECTS                 = $00000100;
        CF_APPLY                   = $00000200;
        CF_ANSIONLY                = $00000400;
        CF_NOVECTORFONTS           = $00000800;
        CF_NOOEMFONTS              = CF_NOVECTORFONTS;
        CF_NOSIMULATIONS           = $00001000;
        CF_LIMITSIZE               = $00002000;
        CF_FIXEDPITCHONLY          = $00004000;
        CF_WYSIWYG                 = $00008000;
        CF_FORCEFONTEXIST          = $00010000;
        CF_SCALABLEONLY            = $00020000;
        CF_TTONLY                  = $00040000;
        CF_NOFACESEL               = $00080000;
        CF_NOSTYLESEL              = $00100000;
        CF_NOSIZESEL               = $00200000;

        SIMULATED_FONTTYPE    = $8000;
        PRINTER_FONTTYPE      = $4000;
        SCREEN_FONTTYPE       = $2000;
        BOLD_FONTTYPE         = $0100;
        ITALIC_FONTTYPE       = $0200;
        REGULAR_FONTTYPE      = $0400;

        WM_CHOOSEFONT_GETLOGFONT      = WM_USER + 1;

        LBSELCHSTRING  ='commdlg_LBSelChangedNotify';
        SHAREVISTRING  ='commdlg_ShareViolation';
        FILEOKSTRING   ='commdlg_FileNameOK';
        COLOROKSTRING  ='commdlg_ColorOK';
        SETRGBSTRING   ='commdlg_SetRGBColor';
        FINDMSGSTRING  ='commdlg_FindReplace';
        HELPMSGSTRING  ='commdlg_help';

        CD_LBSELNOITEMS =-1;
        CD_LBSELCHANGE  = 0;
        CD_LBSELSUB     = 1;
        CD_LBSELADD     = 2;

TYPE
    LPPRINTDLG=^TPRINTDLG;
    TPRINTDLG=RECORD
                   lStructSize:LONGWORD;
                   hwndOwner:HWND;
                   hDevMode:HGLOBAL;
                   hDevNames:HGLOBAL;
                   hDC:HDC;
                   Flags:LONGWORD;
                   nFromPage:LONGWORD;
                   nToPage:LONGWORD;
                   nMinPage:LONGWORD;
                   nMaxPage:LONGWORD;
                   nCopies:LONGWORD;
                   hInstance:HINSTANCE;
                   lCustData:LPARAM;
                   lpfnPrintHook:FUNCTION(ahwnd:HWND;msg:LONGWORD;
                                          aWParam:WPARAM;aLParam:LPARAM):LONGWORD;APIENTRY;
                   lpfnSetupHook:FUNCTION(ahwnd:HWND;msg:LONGWORD;
                                          aWParam:WPARAM;aLParam:LPARAM):LONGWORD;APIENTRY;
                   lpPrintTemplateName:PChar;
                   lpSetupTemplateName:PChar;
                   hPrintTemplate:HGLOBAL;
                   hSetupTemplate:HGLOBAL;
    END;

CONST
        PD_ALLPAGES               =  $00000000;
        PD_SELECTION              =  $00000001;
        PD_PAGENUMS               =  $00000002;
        PD_NOSELECTION            =  $00000004;
        PD_NOPAGENUMS             =  $00000008;
        PD_COLLATE                =  $00000010;
        PD_PRINTTOFILE            =  $00000020;
        PD_PRINTSETUP             =  $00000040;
        PD_NOWARNING              =  $00000080;
        PD_RETURNDC               =  $00000100;
        PD_RETURNIC               =  $00000200;
        PD_RETURNDEFAULT          =  $00000400;
        PD_SHOWHELP               =  $00000800;
        PD_ENABLEPRINTHOOK        =  $00001000;
        PD_ENABLESETUPHOOK        =  $00002000;
        PD_ENABLEPRINTTEMPLATE    =  $00004000;
        PD_ENABLESETUPTEMPLATE    =  $00008000;
        PD_ENABLEPRINTTEMPLATEHANDLE=$00010000;
        PD_ENABLESETUPTEMPLATEHANDLE=$00020000;
        PD_USEDEVMODECOPIES       =  $00040000;
        PD_DISABLEPRINTTOFILE     =  $00080000;
        PD_HIDEPRINTTOFILE        =  $00100000;

TYPE
    LPDEVNAMES=^DEVNAMES;
    DEVNAMES=RECORD
                   wDriverOffset:LONGWORD;
                   wDeviceOffset:LONGWORD;
                   wOutputOffset:LONGWORD;
                   wDefault:LONGWORD;
    END;

CONST
        DN_DEFAULTPRN      =$0001;


IMPORTS
       {$IFDEF Win32}
       FUNCTION GetOpenFileName(VAR o:OPENFILENAME):BOOL;
                         APIENTRY;  'COMDLG32' name 'GetOpenFileNameA';
       FUNCTION GetSaveFileName(VAR o:OPENFILENAME):BOOL;
                         APIENTRY;  'COMDLG32' name 'GetSaveFileNameA';
       FUNCTION GetFileTitle(CONST c:CSTRING;VAR c1:CSTRING;l:LONGWORD):LONGINT;
                         APIENTRY;  'COMDLG32' name 'GetFileTitleA';
       FUNCTION ChooseColor(VAR c:TCHOOSECOLOR):BOOL;
                         APIENTRY;  'COMDLG32' name 'ChooseColorA';
       FUNCTION FindText(VAR f:FINDREPLACE):HWND;
                         APIENTRY;  'COMDLG32' name 'FindTextA';
       FUNCTION ReplaceText(VAR f:FINDREPLACE):HWND;
                         APIENTRY;  'COMDLG32' name 'ReplaceTextA';
       FUNCTION PrintDlg(VAR p:TPRINTDLG):BOOL;
                         APIENTRY;  'COMDLG32' name 'PrintDlgA';
       FUNCTION CommDlgExtendedError:LONGWORD;
                         APIENTRY;  'COMDLG32' name 'CommDlgExtendedError';
       {$ENDIF}
       {$IFDEF OS2}
       FUNCTION GetOpenFileName(VAR o:OPENFILENAME):BOOL;
                         APIENTRY;  'PMWINX' index 329;
       FUNCTION GetSaveFileName(VAR o:OPENFILENAME):BOOL;
                         APIENTRY;  'PMWINX' index 350;
       FUNCTION GetFileTitle(CONST c:CSTRING;VAR c1:CSTRING;l:LONGWORD):LONGINT;
                         APIENTRY;  'PMWINX' index 288;
       FUNCTION ChooseColor(VAR c:TCHOOSECOLOR):BOOL;
                         APIENTRY;  'PMWINX' index 36;
       FUNCTION FindText(VAR f:FINDREPLACE):HWND;
                         APIENTRY;  'PMWINX' index 214;
       FUNCTION ReplaceText(VAR f:FINDREPLACE):HWND;
                         APIENTRY;  'PMWINX' index 567;
       FUNCTION PrintDlg(VAR p:TPRINTDLG):BOOL;
                         APIENTRY;  'PMWINX' index 530;
       FUNCTION CommDlgExtendedError:LONGWORD;
                         APIENTRY;  'PMWINX' index 48;
       {$ENDIF}
END;

IMPLEMENTATION

BEGIN
END.

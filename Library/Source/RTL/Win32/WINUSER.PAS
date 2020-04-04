
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT WinUser;

{****************************************************************************
 *                                                                          *
 * Win32 USER, Win32 and DAX                                                *
 *                                                                          *
 ****************************************************************************}


INTERFACE

USES WinNt,WinDef,WinBase;

TYPE
    HDWP=HANDLE;
    MENUTEMPLATE=POINTER;
    LPMENUTEMPLATE=POINTER;

TYPE
    WndProc=FUNCTION(ahwnd:HWND;msg:ULONG;para1:WPARAM;para2:LPARAM):LRESULT;APIENTRY;
    DlgProc=FUNCTION(ahwnd:HWND;msg:ULONG;para1:WPARAM;para2:LPARAM):BOOL;APIENTRY;
    TimerProc=PROCEDURE(ahwnd:HWND;msg:ULONG;para1,para2:ULONG);APIENTRY;
    GrayStringProc=FUNCTION(ahdc:HDC;para1:LPARAM;para2:LONGINT):BOOL;APIENTRY;
    WndEnumProc=FUNCTION(ahwnd:HWND;para:LPARAM):BOOL;APIENTRY;
    HookProc=FUNCTION(code:LONGINT;para1:WPARAM;para2:LPARAM):LRESULT;APIENTRY;
    SendAsyncProc=PROCEDURE(ahwnd:HWND;msg:ULONG;para1:ULONG;result:LRESULT);APIENTRY;
    PropEnumProc=FUNCTION(ahwnd:HWND;CONST str:CSTRING;ahandle:HANDLE):BOOL;APIENTRY;
    PropEnumProcEx=FUNCTION(ahwnd:HWND;CONST str:CSTRING;ahandle:HANDLE;para:ULONG):BOOL;APIENTRY;
    EditWordBreakProc=FUNCTION(VAR lpch:CSTRING;ichCurrent,cch,code:LONGINT):LONGINT;APIENTRY;


CONST
     {Predefined Resource Types}
     RT_CURSOR           =1;
     RT_BITMAP           =2;
     RT_ICON             =3;
     RT_MENU             =4;
     RT_DIALOG           =5;
     RT_STRING           =6;
     RT_FONTDIR          =7;
     RT_FONT             =8;
     RT_ACCELERATOR      =9;
     RT_RCDATA           =10;
     RT_MESSAGETABLE     =11;
     DIFFERENCE          =11;
     RT_GROUP_CURSOR     =RT_CURSOR + DIFFERENCE;
     RT_GROUP_ICON       =RT_ICON + DIFFERENCE;
     RT_VERSION          =16;
     RT_DLGINCLUDE       =17;

CONST
     SB_HORZ             =0;
     SB_VERT             =1;
     SB_CTL              =2;
     SB_BOTH             =3;
     SB_LINEUP           =0;
     SB_LINELEFT         =0;
     SB_LINEDOWN         =1;
     SB_LINERIGHT        =1;
     SB_PAGEUP           =2;
     SB_PAGELEFT         =2;
     SB_PAGEDOWN         =3;
     SB_PAGERIGHT        =3;
     SB_THUMBPOSITION    =4;
     SB_THUMBTRACK       =5;
     SB_TOP              =6;
     SB_LEFT             =6;
     SB_BOTTOM           =7;
     SB_RIGHT            =7;
     SB_ENDSCROLL        =8;

CONST
     SW_HIDE             =0;
     SW_SHOWNORMAL       =1;
     SW_NORMAL           =1;
     SW_SHOWMINIMIZED    =2;
     SW_SHOWMAXIMIZED    =3;
     SW_MAXIMIZE         =3;
     SW_SHOWNOACTIVATE   =4;
     SW_SHOW             =5;
     SW_MINIMIZE         =6;
     SW_SHOWMINNOACTIVE  =7;
     SW_SHOWNA           =8;
     SW_RESTORE          =9;
     SW_SHOWDEFAULT      =10;
     SW_MAX              =10;

CONST
     HIDE_WINDOW         =0;
     SHOW_OPENWINDOW     =1;
     SHOW_ICONWINDOW     =2;
     SHOW_FULLSCREEN     =3;
     SHOW_OPENNOACTIVATE =4;

CONST
     SW_PARENTCLOSING    =1;
     SW_OTHERZOOM        =2;
     SW_PARENTOPENING    =3;
     SW_OTHERUNZOOM      =4;

CONST
     KF_EXTENDED         =$0100;
     KF_DLGMODE          =$0800;
     KF_MENUMODE         =$1000;
     KF_ALTDOWN          =$2000;
     KF_REPEAT           =$4000;
     KF_UP               =$8000;

CONST
     VK_LBUTTON        =$01;
     VK_RBUTTON        =$02;
     VK_CANCEL         =$03;
     VK_MBUTTON        =$04;
     VK_BACK           =$08;
     VK_TAB            =$09;
     VK_CLEAR          =$0C;
     VK_RETURN         =$0D;
     VK_SHIFT          =$10;
     VK_CONTROL        =$11;
     VK_MENU           =$12;
     VK_PAUSE          =$13;
     VK_CAPITAL        =$14;
     VK_ESCAPE         =$1B;
     VK_SPACE          =$20;
     VK_PRIOR          =$21;
     VK_NEXT           =$22;
     VK_END            =$23;
     VK_HOME           =$24;
     VK_LEFT           =$25;
     VK_UP             =$26;
     VK_RIGHT          =$27;
     VK_DOWN           =$28;
     VK_SELECT         =$29;
     VK_PRINT          =$2A;
     VK_EXECUTE        =$2B;
     VK_SNAPSHOT       =$2C;
     VK_INSERT         =$2D;
     VK_DELETE         =$2E;
     VK_HELP           =$2F;
     VK_LWIN           =$5B;
     VK_RWIN           =$5C;
     VK_APPS           =$5D;
     VK_NUMPAD0        =$60;
     VK_NUMPAD1        =$61;
     VK_NUMPAD2        =$62;
     VK_NUMPAD3        =$63;
     VK_NUMPAD4        =$64;
     VK_NUMPAD5        =$65;
     VK_NUMPAD6        =$66;
     VK_NUMPAD7        =$67;
     VK_NUMPAD8        =$68;
     VK_NUMPAD9        =$69;
     VK_MULTIPLY       =$6A;
     VK_ADD            =$6B;
     VK_SEPARATOR      =$6C;
     VK_SUBTRACT       =$6D;
     VK_DECIMAL        =$6E;
     VK_DIVIDE         =$6F;
     VK_F1             =$70;
     VK_F2             =$71;
     VK_F3             =$72;
     VK_F4             =$73;
     VK_F5             =$74;
     VK_F6             =$75;
     VK_F7             =$76;
     VK_F8             =$77;
     VK_F9             =$78;
     VK_F10            =$79;
     VK_F11            =$7A;
     VK_F12            =$7B;
     VK_F13            =$7C;
     VK_F14            =$7D;
     VK_F15            =$7E;
     VK_F16            =$7F;
     VK_F17            =$80;
     VK_F18            =$81;
     VK_F19            =$82;
     VK_F20            =$83;
     VK_F21            =$84;
     VK_F22            =$85;
     VK_F23            =$86;
     VK_F24            =$87;
     VK_NUMLOCK        =$90;
     VK_SCROLL         =$91;
     VK_LSHIFT         =$A0;
     VK_RSHIFT         =$A1;
     VK_LCONTROL       =$A2;
     VK_RCONTROL       =$A3;
     VK_LMENU          =$A4;
     VK_RMENU          =$A5;
     VK_ATTN           =$F6;
     VK_CRSEL          =$F7;
     VK_EXSEL          =$F8;
     VK_EREOF          =$F9;
     VK_PLAY           =$FA;
     VK_ZOOM           =$FB;
     VK_NONAME         =$FC;
     VK_PA1            =$FD;
     VK_OEM_CLEAR      =$FE;

CONST
     WH_MIN              =-1;
     WH_MSGFILTER        =-1;
     WH_JOURNALRECORD    =0;
     WH_JOURNALPLAYBACK  =1;
     WH_KEYBOARD         =2;
     WH_GETMESSAGE       =3;
     WH_CALLWNDPROC      =4;
     WH_CBT              =5;
     WH_SYSMSGFILTER     =6;
     WH_MOUSE            =7;
     WH_HARDWARE         =8;
     WH_DEBUG            =9;
     WH_SHELL            =10;
     WH_FOREGROUNDIDLE   =11;
     WH_MAX              =11;

CONST
     HC_ACTION           =0;
     HC_GETNEXT          =1;
     HC_SKIP             =2;
     HC_NOREMOVE         =3;
     HC_NOREM            =HC_NOREMOVE;
     HC_SYSMODALON       =4;
     HC_SYSMODALOFF      =5;

CONST
     HCBT_MOVESIZE       =0;
     HCBT_MINMAX         =1;
     HCBT_QS             =2;
     HCBT_CREATEWND      =3;
     HCBT_DESTROYWND     =4;
     HCBT_ACTIVATE       =5;
     HCBT_CLICKSKIPPED   =6;
     HCBT_KEYSKIPPED     =7;
     HCBT_SYSCOMMAND     =8;
     HCBT_SETFOCUS       =9;


TYPE
    PCREATESTRUCT=^CREATESTRUCT;
    CREATESTRUCT=RECORD
                       lpCreateParams:POINTER;
                       hInstance:HINSTANCE;
                       hMenu:HMENU;
                       hwndParent:HWND;
                       cy:LONGINT;
                       cx:LONGINT;
                       y:LONGINT;
                       x:LONGINT;
                       style:LONG;
                       lpszName:PChar;
                       lpszClass:PChar;
                       dwExStyle:ULONG;
    END;
    LPCREATESTRUCT=PCREATESTRUCT;

TYPE
    PCBT_CREATEWND=^CBT_CREATEWND;
    CBT_CREATEWND=RECORD
                        lpcs:PCREATESTRUCT;
                        hwndInsertAfter:HWND;
                  END;
    LPCBT_CREATEWND=PCBT_CREATEWND;

    LPCBTACTIVATESTRUCT=^CBTACTIVATESTRUCT;
    CBTACTIVATESTRUCT=RECORD
                            fMouse:BOOL;
                            hWndActive:HWND;
                      END;

CONST
     MSGF_DIALOGBOX      =0;
     MSGF_MESSAGEBOX     =1;
     MSGF_MENU           =2;
     MSGF_MOVE           =3;
     MSGF_SIZE           =4;
     MSGF_SCROLLBAR      =5;
     MSGF_NEXTWINDOW     =6;
     MSGF_MAINLOOP       =8;
     MSGF_MAX            =8;
     MSGF_USER           =4096;

CONST
     HSHELL_WINDOWCREATED        =1;
     HSHELL_WINDOWDESTROYED      =2;
     HSHELL_ACTIVATESHELLWINDOW  =3;

TYPE
    PEVENTMSG=^EVENTMSG;
    EVENTMSG=RECORD
                   message:ULONG;
                   paramL:ULONG;
                   paramH:ULONG;
                   time:ULONG;
                   hwnd:HWND;
             END;
    PEVENTMSGMSG=PEVENTMSG;
    NPEVENTMSGMSG=PEVENTMSG;
    LPEVENTMSGMSG=PEVENTMSG;
    NPEVENTMSG=PEVENTMSG;
    LPEVENTMSG=PEVENTMSG;

    PCWPSTRUCT=^CWPSTRUCT;
    CWPSTRUCT=RECORD
                    lParam:LPARAM;
                    wParam:WPARAM;
                    message:ULONG;
                    hwnd:HWND;
              END;
    NPCWPSTRUCT=PCWPSTRUCT;
    LPCWPSTRUCT=PCWPSTRUCT;

    PDEBUGHOOKINFO=^DEBUGHOOKINFO;
    DEBUGHOOKINFO=RECORD
                        idThread:ULONG;
                        idThreadInstaller:ULONG;
                        lParam:LPARAM;
                        wParam:WPARAM;
                        code:LONGINT;
                  END;
    NPDEBUGHOOKINFO=PDEBUGHOOKINFO;
    LPDEBUGHOOKINFO=PDEBUGHOOKINFO;

    PMOUSEHOOKSTRUCT=^MOUSEHOOKSTRUCT;
    MOUSEHOOKSTRUCT=RECORD
                          pt:POINT;
                          hwnd:HWND;
                          wHitTestCode:ULONG;
                          dwExtraInfo:ULONG;
                    END;
    LPMOUSEHOOKSTRUCT=PMOUSEHOOKSTRUCT;

CONST
     HKL_PREV            =0;
     HKL_NEXT            =1;

     KLF_ACTIVATE        =$00000001;
     KLF_SUBSTITUTE_OK   =$00000002;
     KLF_UNLOADPREVIOUS  =$00000004;
     KLF_REORDER         =$00000008;

     KL_NAMELENGTH       =9;

CONST
     DESKTOP_READOBJECTS         =$0001;
     DESKTOP_CREATEWINDOW        =$0002;
     DESKTOP_CREATEMENU          =$0004;
     DESKTOP_HOOKCONTROL         =$0008;
     DESKTOP_JOURNALRECORD       =$0010;
     DESKTOP_JOURNALPLAYBACK     =$0020;
     DESKTOP_ENUMERATE           =$0040;
     DESKTOP_WRITEOBJECTS        =$0080;

CONST
     WINSTA_ENUMDESKTOPS         =$0001;
     WINSTA_READATTRIBUTES       =$0002;
     WINSTA_ACCESSCLIPBOARD      =$0004;
     WINSTA_CREATEDESKTOP        =$0008;
     WINSTA_WRITEATTRIBUTES      =$0010;
     WINSTA_ACCESSGLOBALATOMS    =$0020;
     WINSTA_EXITWINDOWS          =$0040;
     WINSTA_ENUMERATE            =$0100;
     WINSTA_READSCREEN           =$0200;

TYPE
     PWNDCLASS=^WNDCLASS;
     WNDCLASS=RECORD
                    style:ULONG;
                    lpfnWndProc:WNDPROC;
                    cbClsExtra:LONGINT;
                    cbWndExtra:LONGINT;
                    hInstance:HINSTANCE;
                    hIcon:HICON;
                    hCursor:HCURSOR;
                    hbrBackground:HBRUSH;
                    lpszMenuName:PChar;
                    lpszClassName:PChar;
     END;
     NPWNDCLASS=PWNDCLASS;
     LPWNDCLASSA=PWNDCLASS;

TYPE
    PMSG=^MSG;
    MSG=RECORD
              hwnd:HWND;
              message:ULONG;
              wParam:WPARAM;
              lParam:LPARAM;
              time:ULONG;
              pt:POINT;
    END;
    NPMSG=PMSG;
    LPMSG=PMSG;

CONST
     GWL_WNDPROC        = -4;
     GWL_HINSTANCE      = -6;
     GWL_HWNDPARENT     = -8;
     GWL_STYLE          = -16;
     GWL_EXSTYLE        = -20;
     GWL_USERDATA       = -21;
     GWL_ID             = -12;

     GCL_MENUNAME       = -8;
     GCL_HBRBACKGROUND  = -10;
     GCL_HCURSOR        = -12;
     GCL_HICON          = -14;
     GCL_HMODULE        = -16;
     GCL_CBWNDEXTRA     = -18;
     GCL_CBCLSEXTRA     = -20;
     GCL_WNDPROC        = -24;
     GCL_STYLE          = -26;
     GCW_ATOM           = -32;

CONST
     //ICON_BIG           = ?;
     ICON_SMALL         = 1;

CONST
     WM_NULL                         =$0000;
     WM_CREATE                       =$0001;
     WM_DESTROY                      =$0002;
     WM_MOVE                         =$0003;
     WM_SIZE                         =$0005;
     WM_ACTIVATE                     =$0006;
     WM_SETFOCUS                     =$0007;
     WM_KILLFOCUS                    =$0008;
     WM_ENABLE                       =$000A;
     WM_SETREDRAW                    =$000B;
     WM_SETTEXT                      =$000C;
     WM_GETTEXT                      =$000D;
     WM_GETTEXTLENGTH                =$000E;
     WM_PAINT                        =$000F;
     WM_CLOSE                        =$0010;
     WM_QUERYENDSESSION              =$0011;
     WM_QUIT                         =$0012;
     WM_QUERYOPEN                    =$0013;
     WM_ERASEBKGND                   =$0014;
     WM_SYSCOLORCHANGE               =$0015;
     WM_ENDSESSION                   =$0016;
     WM_SHOWWINDOW                   =$0018;
     WM_WININICHANGE                 =$001A;
     WM_DEVMODECHANGE                =$001B;
     WM_ACTIVATEAPP                  =$001C;
     WM_FONTCHANGE                   =$001D;
     WM_TIMECHANGE                   =$001E;
     WM_CANCELMODE                   =$001F;
     WM_SETCURSOR                    =$0020;
     WM_MOUSEACTIVATE                =$0021;
     WM_CHILDACTIVATE                =$0022;
     WM_QUEUESYNC                    =$0023;
     WM_GETMINMAXINFO                =$0024;
     WM_PAINTICON                    =$0026;
     WM_ICONERASEBKGND               =$0027;
     WM_NEXTDLGCTL                   =$0028;
     WM_SPOOLERSTATUS                =$002A;
     WM_DRAWITEM                     =$002B;
     WM_MEASUREITEM                  =$002C;
     WM_DELETEITEM                   =$002D;
     WM_VKEYTOITEM                   =$002E;
     WM_CHARTOITEM                   =$002F;
     WM_SETFONT                      =$0030;
     WM_GETFONT                      =$0031;
     WM_SETHOTKEY                    =$0032;
     WM_GETHOTKEY                    =$0033;
     WM_QUERYDRAGICON                =$0037;
     WM_COMPAREITEM                  =$0039;
     WM_COMPACTING                   =$0041;
     WM_COMMNOTIFY                   =$0044;
     WM_WINDOWPOSCHANGING            =$0046;
     WM_WINDOWPOSCHANGED             =$0047;
     WM_POWER                        =$0048;
     WM_COPYDATA                     =$004A;
     WM_CANCELJOURNAL                =$004B;
     WM_GETICON                      =$007F;
     WM_SETICON                      =$0080;
     WM_NCCREATE                     =$0081;
     WM_NCDESTROY                    =$0082;
     WM_NCCALCSIZE                   =$0083;
     WM_NCHITTEST                    =$0084;
     WM_NCPAINT                      =$0085;
     WM_NCACTIVATE                   =$0086;
     WM_GETDLGCODE                   =$0087;
     WM_NCMOUSEMOVE                  =$00A0;
     WM_NCLBUTTONDOWN                =$00A1;
     WM_NCLBUTTONUP                  =$00A2;
     WM_NCLBUTTONDBLCLK              =$00A3;
     WM_NCRBUTTONDOWN                =$00A4;
     WM_NCRBUTTONUP                  =$00A5;
     WM_NCRBUTTONDBLCLK              =$00A6;
     WM_NCMBUTTONDOWN                =$00A7;
     WM_NCMBUTTONUP                  =$00A8;
     WM_NCMBUTTONDBLCLK              =$00A9;
     WM_KEYFIRST                     =$0100;
     WM_KEYDOWN                      =$0100;
     WM_KEYUP                        =$0101;
     WM_CHAR                         =$0102;
     WM_DEADCHAR                     =$0103;
     WM_SYSKEYDOWN                   =$0104;
     WM_SYSKEYUP                     =$0105;
     WM_SYSCHAR                      =$0106;
     WM_SYSDEADCHAR                  =$0107;
     WM_KEYLAST                      =$0108;
     WM_INITDIALOG                   =$0110;
     WM_COMMAND                      =$0111;
     WM_SYSCOMMAND                   =$0112;
     WM_TIMER                        =$0113;
     WM_HSCROLL                      =$0114;
     WM_VSCROLL                      =$0115;
     WM_INITMENU                     =$0116;
     WM_INITMENUPOPUP                =$0117;
     WM_MENUSELECT                   =$011F;
     WM_MENUCHAR                     =$0120;
     WM_ENTERIDLE                    =$0121;
     WM_CTLCOLORMSGBOX               =$0132;
     WM_CTLCOLOREDIT                 =$0133;
     WM_CTLCOLORLISTBOX              =$0134;
     WM_CTLCOLORBTN                  =$0135;
     WM_CTLCOLORDLG                  =$0136;
     WM_CTLCOLORSCROLLBAR            =$0137;
     WM_CTLCOLORSTATIC               =$0138;
     WM_MOUSEFIRST                   =$0200;
     WM_MOUSEMOVE                    =$0200;
     WM_LBUTTONDOWN                  =$0201;
     WM_LBUTTONUP                    =$0202;
     WM_LBUTTONDBLCLK                =$0203;
     WM_RBUTTONDOWN                  =$0204;
     WM_RBUTTONUP                    =$0205;
     WM_RBUTTONDBLCLK                =$0206;
     WM_MBUTTONDOWN                  =$0207;
     WM_MBUTTONUP                    =$0208;
     WM_MBUTTONDBLCLK                =$0209;
     WM_MOUSELAST                    =$0209;
     WM_PARENTNOTIFY                 =$0210;
     WM_ENTERMENULOOP                =$0211;
     WM_EXITMENULOOP                 =$0212;
     WM_MDICREATE                    =$0220;
     WM_MDIDESTROY                   =$0221;
     WM_MDIACTIVATE                  =$0222;
     WM_MDIRESTORE                   =$0223;
     WM_MDINEXT                      =$0224;
     WM_MDIMAXIMIZE                  =$0225;
     WM_MDITILE                      =$0226;
     WM_MDICASCADE                   =$0227;
     WM_MDIICONARRANGE               =$0228;
     WM_MDIGETACTIVE                 =$0229;
     WM_MDISETMENU                   =$0230;
     WM_DROPFILES                    =$0233;
     WM_MDIREFRESHMENU               =$0234;
     WM_CUT                          =$0300;
     WM_COPY                         =$0301;
     WM_PASTE                        =$0302;
     WM_CLEAR                        =$0303;
     WM_UNDO                         =$0304;
     WM_RENDERFORMAT                 =$0305;
     WM_RENDERALLFORMATS             =$0306;
     WM_DESTROYCLIPBOARD             =$0307;
     WM_DRAWCLIPBOARD                =$0308;
     WM_PAINTCLIPBOARD               =$0309;
     WM_VSCROLLCLIPBOARD             =$030A;
     WM_SIZECLIPBOARD                =$030B;
     WM_ASKCBFORMATNAME              =$030C;
     WM_CHANGECBCHAIN                =$030D;
     WM_HSCROLLCLIPBOARD             =$030E;
     WM_QUERYNEWPALETTE              =$030F;
     WM_PALETTEISCHANGING            =$0310;
     WM_PALETTECHANGED               =$0311;
     WM_HOTKEY                       =$0312;
     WM_PENWINFIRST                  =$0380;
     WM_PENWINLAST                   =$038F;
     WM_USER                         =$0400;

     WM_MOUSEDRAG1                   =$0401;  {own defined}
     WM_MOUSEDRAG2                   =$0402;  {own defined}
     WM_SEM1                         =$0403;  {own defined}

     WM_SPEED_USER                   =$0404;  {use this entry when working with OPML !}


TYPE
    PCOPYDATASTRUCT=^COPYDATASTRUCT;
    COPYDATASTRUCT=RECORD
                         dwData:ULONG;
                         cbData:ULONG;
                         lpData:POINTER;
    END;

CONST
     PWR_OK              =1;
     PWR_FAIL            =-1;
     PWR_SUSPENDREQUEST  =1;
     PWR_SUSPENDRESUME   =2;
     PWR_CRITICALRESUME  =3;

TYPE
    PMINMAXINFO=^MINMAXINFO;
    MINMAXINFO=RECORD
                     ptReserved:POINT;
                     ptMaxSize:POINT;
                     ptMaxPosition:POINT;
                     ptMinTrackSize:POINT;
                     ptMaxTrackSize:POINT;
    END;
    LPMINMAXINFO=PMINMAXINFO;


CONST
     WA_INACTIVE     =0;
     WA_ACTIVE       =1;
     WA_CLICKACTIVE  =2;

     ST_BEGINSWP         =0;
     ST_ENDSWP           =1;

CONST
     HTERROR             =-2;
     HTTRANSPARENT       =-1;
     HTNOWHERE           =0;
     HTCLIENT            =1;
     HTCAPTION           =2;
     HTSYSMENU           =3;
     HTGROWBOX           =4;
     HTSIZE              =HTGROWBOX;
     HTMENU              =5;
     HTHSCROLL           =6;
     HTVSCROLL           =7;
     HTMINBUTTON         =8;
     HTMAXBUTTON         =9;
     HTLEFT              =10;
     HTRIGHT             =11;
     HTTOP               =12;
     HTTOPLEFT           =13;
     HTTOPRIGHT          =14;
     HTBOTTOM            =15;
     HTBOTTOMLEFT        =16;
     HTBOTTOMRIGHT       =17;
     HTBORDER            =18;
     HTREDUCE            =HTMINBUTTON;
     HTZOOM              =HTMAXBUTTON;
     HTSIZEFIRST         =HTLEFT;
     HTSIZELAST          =HTBOTTOMRIGHT;

     SMTO_NORMAL         =$0000;
     SMTO_BLOCK          =$0001;
     SMTO_ABORTIFHUNG    =$0002;

     MA_ACTIVATE         =1;
     MA_ACTIVATEANDEAT   =2;
     MA_NOACTIVATE       =3;
     MA_NOACTIVATEANDEAT =4;

CONST
     SIZE_RESTORED       =0;
     SIZE_MINIMIZED      =1;
     SIZE_MAXIMIZED      =2;
     SIZE_MAXSHOW        =3;
     SIZE_MAXHIDE        =4;

     SIZENORMAL          =SIZE_RESTORED;
     SIZEICONIC          =SIZE_MINIMIZED;
     SIZEFULLSCREEN      =SIZE_MAXIMIZED;
     SIZEZOOMSHOW        =SIZE_MAXSHOW;
     SIZEZOOMHIDE        =SIZE_MAXHIDE;

TYPE
    PWINDOWPOS=^WINDOWPOS;
    WINDOWPOS=RECORD
                    hwnd:HWND;
                    hwndInsertAfter:HWND;
                    x:LONGINT;
                    y:LONGINT;
                    cx:LONGINT;
                    cy:LONGINT;
                    flags:ULONG;
     END;
     LPWINDOWPOS=PWINDOWPOS;

     PNCCALCSIZE_PARAMS=^NCCALCSIZE_PARAMS;
     NCCALCSIZE_PARAMS=RECORD
                             rgrc:ARRAY[0..2] OF RECT;
                             lppos:PWINDOWPOS;
     END;
     LPNCCALCSIZE_PARAMS=PNCCALCSIZE_PARAMS;

CONST
     WVR_ALIGNTOP        =$0010;
     WVR_ALIGNLEFT       =$0020;
     WVR_ALIGNBOTTOM     =$0040;
     WVR_ALIGNRIGHT      =$0080;
     WVR_HREDRAW         =$0100;
     WVR_VREDRAW         =$0200;
     WVR_REDRAW          =WVR_HREDRAW OR WVR_VREDRAW;
     WVR_VALIDRECTS      =$0400;

CONST
     MK_LBUTTON          =$0001;
     MK_RBUTTON          =$0002;
     MK_SHIFT            =$0004;
     MK_CONTROL          =$0008;
     MK_MBUTTON          =$0010;

CONST
     WS_OVERLAPPED       =$00000000;
     WS_POPUP            =$80000000;
     WS_CHILD            =$40000000;
     WS_MINIMIZE         =$20000000;
     WS_VISIBLE          =$10000000;
     WS_DISABLED         =$08000000;
     WS_CLIPSIBLINGS     =$04000000;
     WS_CLIPCHILDREN     =$02000000;
     WS_MAXIMIZE         =$01000000;
     WS_CAPTION          =$00C00000;
     WS_BORDER           =$00800000;
     WS_DLGFRAME         =$00400000;
     WS_VSCROLL          =$00200000;
     WS_HSCROLL          =$00100000;
     WS_SYSMENU          =$00080000;
     WS_THICKFRAME       =$00040000;
     WS_GROUP            =$00020000;
     WS_TABSTOP          =$00010000;
     WS_MINIMIZEBOX      =$00020000;
     WS_MAXIMIZEBOX      =$00010000;
     WS_TILED            =WS_OVERLAPPED;
     WS_ICONIC           =WS_MINIMIZE;
     WS_SIZEBOX          =WS_THICKFRAME;
     WS_OVERLAPPEDWINDOW =WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR
                          WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX;
     WS_TILEDWINDOW      =WS_OVERLAPPEDWINDOW;
     WS_POPUPWINDOW      =WS_POPUP OR WS_BORDER OR WS_SYSMENU;
     WS_CHILDWINDOW      =WS_CHILD;
     WS_EX_DLGMODALFRAME =$00000001;
     WS_EX_NOPARENTNOTIFY=$00000004;
     WS_EX_TOPMOST       =$00000008;
     WS_EX_ACCEPTFILES   =$00000010;
     WS_EX_TRANSPARENT   =$00000020;
     WS_EX_MDICHILD      =$00000040;
     WS_EX_TOOLWINDOW    =$00000080;
     WS_EX_WINDOWEDGE    =$00000100;
     WS_EX_CLIENTEDGE    =$00000200;
     WS_EX_CONTEXTHELP   =$00000400;
     WS_EX_RIGHT         =$00001000;
     WS_EX_LEFT          =0;
     WS_EX_RTLREADING    =$00002000;
     WS_EX_LTRREADING    =0;
     WS_EX_LEFTSCROLLBAR =$00004000;
     WS_EX_RIGHTSCROLLBAR=0;
     WS_EX_CONTROLPARENT =$00010000;
     WS_EX_STATICEDGE    =$00020000;
     WS_EX_APPWINDOW     =$00040000;
     WS_EX_OVERLAPPEDWINDOW =WS_EX_WINDOWEDGE OR WS_EX_CLIENTEDGE;
     WS_EX_PALETTEWINDOW =WS_EX_WINDOWEDGE OR WS_EX_TOOLWINDOW OR WS_EX_TOPMOST;

CONST
     CS_VREDRAW          =$0001;
     CS_HREDRAW          =$0002;
     CS_KEYCVTWINDOW     =$0004;
     CS_DBLCLKS          =$0008;
     CS_OWNDC            =$0020;
     CS_CLASSDC          =$0040;
     CS_PARENTDC         =$0080;
     CS_NOKEYCVT         =$0100;
     CS_NOCLOSE          =$0200;
     CS_SAVEBITS         =$0800;
     CS_BYTEALIGNCLIENT  =$1000;
     CS_BYTEALIGNWINDOW  =$2000;
     CS_GLOBALCLASS      =$4000;

CONST
     CF_TEXT             =1;
     CF_BITMAP           =2;
     CF_METAFILEPICT     =3;
     CF_SYLK             =4;
     CF_DIF              =5;
     CF_TIFF             =6;
     CF_OEMTEXT          =7;
     CF_DIB              =8;
     CF_PALETTE          =9;
     CF_PENDATA          =10;
     CF_RIFF             =11;
     CF_WAVE             =12;
     CF_UNICODETEXT      =13;
     CF_ENHMETAFILE      =14;
     CF_OWNERDISPLAY     =$0080;
     CF_DSPTEXT          =$0081;
     CF_DSPBITMAP        =$0082;
     CF_DSPMETAFILEPICT  =$0083;
     CF_DSPENHMETAFILE   =$008E;
     CF_PRIVATEFIRST     =$0200;
     CF_PRIVATELAST      =$02FF;
     CF_GDIOBJFIRST      =$0300;
     CF_GDIOBJLAST       =$03FF;

CONST
     FVIRTKEY  =$01;
     FNOINVERT =$02;
     FSHIFT    =$04;
     FCONTROL  =$08;
     FALT      =$10;

TYPE
    PACCEL=^ACCEL;
    ACCEL=RECORD
                fVirt:WORD;               /* Also called the flags field */
                key:WORD;
                cmd:WORD;
    END;
    LPACCEL=PACCEL;

    PPAINTSTRUCT=^PAINTSTRUCT;
    PAINTSTRUCT=RECORD
                      hdc:HDC;
                      fErase:BOOL;
                      rcPaint:RECT;
                      fRestore:BOOL;
                      fIncUpdate:BOOL;
                      rgbReserved:ARRAY[0..31] OF BYTE;
     END;
     NPPAINTSTRUCT=PPAINTSTRUCT;
     LPPAINTSTRUCT=PPAINTSTRUCT;

     PWINDOWPLACEMENT=^WINDOWPLACEMENT;
     WINDOWPLACEMENT=RECORD
                           length:ULONG;
                           flags:ULONG;
                           showCmd:ULONG;
                           ptMinPosition:POINT;
                           ptMaxPosition:POINT;
                           rcNormalPosition:RECT;
      END;
      LPWINDOWPLACEMENT=PWINDOWPLACEMENT;

CONST
     WPF_SETMINPOSITION      =$0001;
     WPF_RESTORETOMAXIMIZED  =$0002;

     ODT_MENU        =1;
     ODT_LISTBOX     =2;
     ODT_COMBOBOX    =3;
     ODT_BUTTON      =4;

     ODA_DRAWENTIRE  =$0001;
     ODA_SELECT      =$0002;
     ODA_FOCUS       =$0004;

     ODS_SELECTED    =$0001;
     ODS_GRAYED      =$0002;
     ODS_DISABLED    =$0004;
     ODS_CHECKED     =$0008;
     ODS_FOCUS       =$0010;

TYPE
    PMEASUREITEMSTRUCT=^MEASUREITEMSTRUCT;
    MEASUREITEMSTRUCT=RECORD
                            CtlType:ULONG;
                            CtlID:ULONG;
                            itemID:ULONG;
                            itemWidth:ULONG;
                            itemHeight:ULONG;
                            itemData:ULONG;
    END;
    LPMEASUREITEMSTRUCT=PMEASUREITEMSTRUCT;

    PDRAWITEMSTRUCT=^DRAWITEMSTRUCT;
    DRAWITEMSTRUCT=RECORD
                         CtlType:ULONG;
                         CtlID:ULONG;
                         itemID:ULONG;
                         itemAction:ULONG;
                         itemState:ULONG;
                         hwndItem:HWND;
                         hDC:HDC;
                         rcItem:RECT;
                         itemData:ULONG;
    END;
    LPDRAWITEMSTRUCT=PDRAWITEMSTRUCT;

    PDELETEITEMSTRUCT=^DELETEITEMSTRUCT;
    DELETEITEMSTRUCT=RECORD
                           CtlType:ULONG;
                           CtlID:ULONG;
                           itemID:ULONG;
                           hwndItem:HWND;
                           itemData:ULONG;
    END;
    LPDELETEITEMSTRUCT=PDELETEITEMSTRUCT;

    PCOMPAREITEMSTRUCT=^COMPAREITEMSTRUCT;
    COMPAREITEMSTRUCT=RECORD
                            CtlType:ULONG;
                            CtlID:ULONG;
                            hwndItem:HWND;
                            itemID1:ULONG;
                            itemData1:ULONG;
                            itemID2:ULONG;
                            itemData2:ULONG;
                            dwLocaleId:ULONG;
    END;
    LPCOMPAREITEMSTRUCT=PCOMPAREITEMSTRUCT;

CONST
     PM_NOREMOVE         =$0000;
     PM_REMOVE           =$0001;
     PM_NOYIELD          =$0002;

CONST
     MOD_ALT         =$0001;
     MOD_CONTROL     =$0002;
     MOD_SHIFT       =$0004;

     IDHOT_SNAPWINDOW        =-1;    {SHIFT+PRINTSCRN}
     IDHOT_SNAPDESKTOP       =-2;    {PRINTSCRN}

     EWX_LOGOFF   =0;
     EWX_SHUTDOWN =1;
     EWX_REBOOT   =2;
     EWX_FORCE    =4;
     EWX_POWEROFF =8;

CONST
     HWND_BROADCAST  =$ffff;

     CW_USEDEFAULT   =$80000000;

     HWND_DESKTOP    =0;
     HWND_TOP        =0;
     HWND_BOTTOM     =1;
     HWND_TOPMOST    =-1;
     HWND_NOTOPMOST  =-2;

CONST
     SWP_NOSIZE          =$0001;
     SWP_NOMOVE          =$0002;
     SWP_NOZORDER        =$0004;
     SWP_NOREDRAW        =$0008;
     SWP_NOACTIVATE      =$0010;
     SWP_FRAMECHANGED    =$0020;
     SWP_SHOWWINDOW      =$0040;
     SWP_HIDEWINDOW      =$0080;
     SWP_NOCOPYBITS      =$0100;
     SWP_NOOWNERZORDER   =$0200;
     SWP_DRAWFRAME       =SWP_FRAMECHANGED;
     SWP_NOREPOSITION    =SWP_NOOWNERZORDER;

TYPE
    PDLGTEMPLATE=^DLGTEMPLATE;
    DLGTEMPLATE=RECORD
                      style:ULONG;
                      dwExtendedStyle:ULONG;
                      cdit:WORD;
                      x:SHORT;
                      y:SHORT;
                      cx:SHORT;
                      cy:SHORT;
    END;
    LPDLGTEMPLATE=PDLGTEMPLATE;

    PDLGITEMTEMPLATE=^DLGITEMTEMPLATE;
    DLGITEMTEMPLATE=RECORD
                          style:ULONG;
                          dwExtendedStyle:ULONG;
                          x:SHORT;
                          y:SHORT;
                          cx:SHORT;
                          cy:SHORT;
                          id:WORD;
    END;
    LPDLGITEMTEMPLATE=PDLGITEMTEMPLATE;

CONST
     DLGWINDOWEXTRA =30;

CONST
     KEYEVENTF_EXTENDEDKEY =$0001;
     KEYEVENTF_KEYUP       =$0002;

CONST
     MOUSEEVENTF_MOVE        =$0001;
     MOUSEEVENTF_LEFTDOWN    =$0002;
     MOUSEEVENTF_LEFTUP      =$0004;
     MOUSEEVENTF_RIGHTDOWN   =$0008;
     MOUSEEVENTF_RIGHTUP     =$0010;
     MOUSEEVENTF_MIDDLEDOWN  =$0020;
     MOUSEEVENTF_MIDDLEUP    =$0040;
     MOUSEEVENTF_ABSOLUTE    =$8000;

CONST
     QS_KEY           =$01;
     QS_MOUSEMOVE     =$02;
     QS_MOUSEBUTTON   =$04;
     QS_POSTMESSAGE   =$08;
     QS_TIMER         =$10;
     QS_PAINT         =$20;
     QS_SENDMESSAGE   =$40;
     QS_HOTKEY        =$80;
     QS_MOUSE         =QS_MOUSEMOVE OR QS_MOUSEBUTTON;
     QS_INPUT         =QS_MOUSE OR QS_KEY;
     QS_ALLEVENTS     =QS_INPUT OR QS_POSTMESSAGE OR QS_TIMER OR QS_PAINT OR QS_HOTKEY;
     QS_ALLINPUT      =QS_SENDMESSAGE OR QS_PAINT OR QS_TIMER OR QS_POSTMESSAGE OR
                       QS_MOUSEBUTTON OR QS_MOUSEMOVE OR QS_HOTKEY OR QS_KEY;

CONST
     SM_CXSCREEN             = 0;
     SM_CYSCREEN             = 1;
     SM_CXVSCROLL            = 2;
     SM_CYHSCROLL            = 3;
     SM_CYCAPTION            = 4;
     SM_CXBORDER             = 5;
     SM_CYBORDER             = 6;
     SM_CXDLGFRAME           = 7;
     SM_CYDLGFRAME           = 8;
     SM_CYVTHUMB             = 9;
     SM_CXHTHUMB             = 10;
     SM_CXICON               = 11;
     SM_CYICON               = 12;
     SM_CXCURSOR             = 13;
     SM_CYCURSOR             = 14;
     SM_CYMENU               = 15;
     SM_CXFULLSCREEN         = 16;
     SM_CYFULLSCREEN         = 17;
     SM_CYKANJIWINDOW        = 18;
     SM_MOUSEPRESENT         = 19;
     SM_CYVSCROLL            = 20;
     SM_CXHSCROLL            = 21;
     SM_DEBUG                = 22;
     SM_SWAPBUTTON           = 23;
     SM_RESERVED1            = 24;
     SM_RESERVED2            = 25;
     SM_RESERVED3            = 26;
     SM_RESERVED4            = 27;
     SM_CXMIN                = 28;
     SM_CYMIN                = 29;
     SM_CXSIZE               = 30;
     SM_CYSIZE               = 31;
     SM_CXFRAME              = 32;
     SM_CYFRAME              = 33;
     SM_CXMINTRACK           = 34;
     SM_CYMINTRACK           = 35;
     SM_CXDOUBLECLK          = 36;
     SM_CYDOUBLECLK          = 37;
     SM_CXICONSPACING        = 38;
     SM_CYICONSPACING        = 39;
     SM_MENUDROPALIGNMENT    = 40;
     SM_PENWINDOWS           = 41;
     SM_DBCSENABLED          = 42;
     SM_CMOUSEBUTTONS        = 43;
     SM_SHOWSOUNDS           = 70;
     SM_CMETRICS             = 71;

CONST
     TPM_LEFTBUTTON  =$0000;
     TPM_RIGHTBUTTON =$0002;
     TPM_LEFTALIGN   =$0000;
     TPM_CENTERALIGN =$0004;
     TPM_RIGHTALIGN  =$0008;

CONST
     DT_TOP              =$00000000;
     DT_LEFT             =$00000000;
     DT_CENTER           =$00000001;
     DT_RIGHT            =$00000002;
     DT_VCENTER          =$00000004;
     DT_BOTTOM           =$00000008;
     DT_WORDBREAK        =$00000010;
     DT_SINGLELINE       =$00000020;
     DT_EXPANDTABS       =$00000040;
     DT_TABSTOP          =$00000080;
     DT_NOCLIP           =$00000100;
     DT_EXTERNALLEADING  =$00000200;
     DT_CALCRECT         =$00000400;
     DT_NOPREFIX         =$00000800;
     DT_INTERNAL         =$00001000;

CONST
     DCX_WINDOW           =$00000001;
     DCX_CACHE            =$00000002;
     DCX_NORESETATTRS     =$00000004;
     DCX_CLIPCHILDREN     =$00000008;
     DCX_CLIPSIBLINGS     =$00000010;
     DCX_PARENTCLIP       =$00000020;
     DCX_EXCLUDERGN       =$00000040;
     DCX_INTERSECTRGN     =$00000080;
     DCX_EXCLUDEUPDATE    =$00000100;
     DCX_INTERSECTUPDATE  =$00000200;
     DCX_LOCKWINDOWUPDATE =$00000400;
     DCX_NORECOMPUTE      =$00100000;
     DCX_VALIDATE         =$00200000;

CONST
     RDW_INVALIDATE          =$0001;
     RDW_INTERNALPAINT       =$0002;
     RDW_ERASE               =$0004;
     RDW_VALIDATE            =$0008;
     RDW_NOINTERNALPAINT     =$0010;
     RDW_NOERASE             =$0020;
     RDW_NOCHILDREN          =$0040;
     RDW_ALLCHILDREN         =$0080;
     RDW_UPDATENOW           =$0100;
     RDW_ERASENOW            =$0200;
     RDW_FRAME               =$0400;
     RDW_NOFRAME             =$0800;

     SW_SCROLLCHILDREN       =$0001;
     SW_INVALIDATE           =$0002;
     SW_ERASE                =$0004;

CONST
     ESB_ENABLE_BOTH     =$0000;
     ESB_DISABLE_BOTH    =$0003;
     ESB_DISABLE_LEFT    =$0001;
     ESB_DISABLE_RIGHT   =$0002;
     ESB_DISABLE_UP      =$0001;
     ESB_DISABLE_DOWN    =$0002;
     ESB_DISABLE_LTUP    =ESB_DISABLE_LEFT;
     ESB_DISABLE_RTDN    =ESB_DISABLE_RIGHT;

CONST
     MB_OK                       =$00000000;
     MB_OKCANCEL                 =$00000001;
     MB_ABORTRETRYIGNORE         =$00000002;
     MB_YESNOCANCEL              =$00000003;
     MB_YESNO                    =$00000004;
     MB_RETRYCANCEL              =$00000005;
     MB_ICONHAND                 =$00000010;
     MB_ICONQUESTION             =$00000020;
     MB_ICONEXCLAMATION          =$00000030;
     MB_ICONASTERISK             =$00000040;
     MB_ICONINFORMATION          =MB_ICONASTERISK;
     MB_ICONSTOP                 =MB_ICONHAND;
     MB_DEFBUTTON1               =$00000000;
     MB_DEFBUTTON2               =$00000100;
     MB_DEFBUTTON3               =$00000200;
     MB_APPLMODAL                =$00000000;
     MB_SYSTEMMODAL              =$00001000;
     MB_TASKMODAL                =$00002000;
     MB_NOFOCUS                  =$00008000;
     MB_SETFOREGROUND            =$00010000;
     MB_DEFAULT_DESKTOP_ONLY     =$00020000;
     MB_SERVICE_NOTIFICATION     =$00040000;
     MB_TYPEMASK                 =$0000000F;
     MB_ICONMASK                 =$000000F0;
     MB_DEFMASK                  =$00000F00;
     MB_MODEMASK                 =$00003000;
     MB_MISCMASK                 =$0000C000;

CONST
     CTLCOLOR_MSGBOX             =0;
     CTLCOLOR_EDIT               =1;
     CTLCOLOR_LISTBOX            =2;
     CTLCOLOR_BTN                =3;
     CTLCOLOR_DLG                =4;
     CTLCOLOR_SCROLLBAR          =5;
     CTLCOLOR_STATIC             =6;
     CTLCOLOR_MAX                =7;

     COLOR_SCROLLBAR             =0;
     COLOR_BACKGROUND            =1;
     COLOR_ACTIVECAPTION         =2;
     COLOR_INACTIVECAPTION       =3;
     COLOR_MENU                  =4;
     COLOR_WINDOW                =5;
     COLOR_WINDOWFRAME           =6;
     COLOR_MENUTEXT              =7;
     COLOR_WINDOWTEXT            =8;
     COLOR_CAPTIONTEXT           =9;
     COLOR_ACTIVEBORDER          =10;
     COLOR_INACTIVEBORDER        =11;
     COLOR_APPWORKSPACE          =12;
     COLOR_HIGHLIGHT             =13;
     COLOR_HIGHLIGHTTEXT         =14;
     COLOR_BTNFACE               =15;
     COLOR_BTNSHADOW             =16;
     COLOR_GRAYTEXT              =17;
     COLOR_BTNTEXT               =18;
     COLOR_INACTIVECAPTIONTEXT   =19;
     COLOR_BTNHIGHLIGHT          =20;
     COLOR_3DDKSHADOW            =21;
     COLOR_3DLIGHT               =22;
     COLOR_INFOTEXT              =23;
     COLOR_INFOBK                =24;
     COLOR_ENDCOLORS             =COLOR_INFOBK;
     COLOR_DESKTOP               =COLOR_BACKGROUND;
     COLOR_3DFACE                =COLOR_BTNFACE;
     COLOR_3DSHADOW              =COLOR_BTNSHADOW;
     COLOR_3DHIGHLIGHT           =COLOR_BTNHIGHLIGHT;
     COLOR_3DHILIGHT             =COLOR_BTNHIGHLIGHT;
     COLOR_BTNHILIGHT            =COLOR_BTNHIGHLIGHT;

CONST
     GW_HWNDFIRST        =0;
     GW_HWNDLAST         =1;
     GW_HWNDNEXT         =2;
     GW_HWNDPREV         =3;
     GW_OWNER            =4;
     GW_CHILD            =5;
     GW_MAX              =5;

CONST
     MF_INSERT           =$00000000;
     MF_CHANGE           =$00000080;
     MF_APPEND           =$00000100;
     MF_DELETE           =$00000200;
     MF_REMOVE           =$00001000;
     MF_BYCOMMAND        =$00000000;
     MF_BYPOSITION       =$00000400;
     MF_SEPARATOR        =$00000800;
     MF_ENABLED          =$00000000;
     MF_GRAYED           =$00000001;
     MF_DISABLED         =$00000002;
     MF_UNCHECKED        =$00000000;
     MF_CHECKED          =$00000008;
     MF_USECHECKBITMAPS  =$00000200;
     MF_STRING           =$00000000;
     MF_BITMAP           =$00000004;
     MF_OWNERDRAW        =$00000100;
     MF_POPUP            =$00000010;
     MF_MENUBARBREAK     =$00000020;
     MF_MENUBREAK        =$00000040;
     MF_UNHILITE         =$00000000;
     MF_HILITE           =$00000080;
     MF_SYSMENU          =$00002000;
     MF_HELP             =$00004000;
     MF_MOUSESELECT      =$00008000;

TYPE
    PMENUITEMTEMPLATEHEADER=^MENUITEMTEMPLATEHEADER;
    MENUITEMTEMPLATEHEADER=RECORD
                                 versionNumber:WORD;
                                 offset:WORD;
    END;

    PMENUITEMTEMPLATE=^MENUITEMTEMPLATE;
    MENUITEMTEMPLATE=RECORD
                           mtOption:WORD;
                           mtID:WORD;
                           mtString:ARRAY[0..0] OF WCHAR;
    END;

CONST
     MF_END             =$00000080;

CONST
     SC_SIZE         =$F000;
     SC_MOVE         =$F010;
     SC_MINIMIZE     =$F020;
     SC_MAXIMIZE     =$F030;
     SC_NEXTWINDOW   =$F040;
     SC_PREVWINDOW   =$F050;
     SC_CLOSE        =$F060;
     SC_VSCROLL      =$F070;
     SC_HSCROLL      =$F080;
     SC_MOUSEMENU    =$F090;
     SC_KEYMENU      =$F100;
     SC_ARRANGE      =$F110;
     SC_RESTORE      =$F120;
     SC_TASKLIST     =$F130;
     SC_SCREENSAVE   =$F140;
     SC_HOTKEY       =$F150;
     SC_ICON         =SC_MINIMIZE;
     SC_ZOOM         =SC_MAXIMIZE;

CONST
     IDC_ARROW           =PChar(32512);
     IDC_IBEAM           =PChar(32513);
     IDC_WAIT            =PChar(32514);
     IDC_CROSS           =PChar(32515);
     IDC_UPARROW         =PChar(32516);
     IDC_SIZE            =PChar(32640);
     IDC_ICON            =PChar(32641);
     IDC_SIZENWSE        =PChar(32642);
     IDC_SIZENESW        =PChar(32643);
     IDC_SIZEWE          =PChar(32644);
     IDC_SIZENS          =PChar(32645);
     IDC_SIZEALL         =PChar(32646);
     IDC_NO              =PChar(32648);
     IDC_HAND            =PChar(32649);
     IDC_APPSTARTING     =PChar(32650);
     IDC_HELP            =PChar(32651);


     IDC_NODROP          =PChar(32767);
     IDC_DRAG            =PChar(32766);
     IDC_HSPLIT          =PChar(14{32765});
     IDC_VSPLIT          =PChar(15{32764});
     IDC_MULTIDRAG       =PChar(32763);
     IDC_SQLWAIT         =PChar(32762);


TYPE
    PICONINFO=^ICONINFO;
    ICONINFO=RECORD
                   fIcon:BOOL;
                   xHotspot:ULONG;
                   yHotspot:ULONG;
                   hbmMask:HBITMAP;
                   hbmColor:HBITMAP;
    END;

CONST
     OBM_CLOSE           =32754;
     OBM_UPARROW         =32753;
     OBM_DNARROW         =32752;
     OBM_RGARROW         =32751;
     OBM_LFARROW         =32750;
     OBM_REDUCE          =32749;
     OBM_ZOOM            =32748;
     OBM_RESTORE         =32747;
     OBM_REDUCED         =32746;
     OBM_ZOOMD           =32745;
     OBM_RESTORED        =32744;
     OBM_UPARROWD        =32743;
     OBM_DNARROWD        =32742;
     OBM_RGARROWD        =32741;
     OBM_LFARROWD        =32740;
     OBM_MNARROW         =32739;
     OBM_COMBO           =32738;
     OBM_UPARROWI        =32737;
     OBM_DNARROWI        =32736;
     OBM_RGARROWI        =32735;
     OBM_LFARROWI        =32734;
     OBM_OLD_CLOSE       =32767;
     OBM_SIZE            =32766;
     OBM_OLD_UPARROW     =32765;
     OBM_OLD_DNARROW     =32764;
     OBM_OLD_RGARROW     =32763;
     OBM_OLD_LFARROW     =32762;
     OBM_BTSIZE          =32761;
     OBM_CHECK           =32760;
     OBM_CHECKBOXES      =32759;
     OBM_BTNCORNERS      =32758;
     OBM_OLD_REDUCE      =32757;
     OBM_OLD_ZOOM        =32756;
     OBM_OLD_RESTORE     =32755;
     OCR_NORMAL          =32512;
     OCR_IBEAM           =32513;
     OCR_WAIT            =32514;
     OCR_CROSS           =32515;
     OCR_UP              =32516;
     OCR_SIZE            =32640;
     OCR_ICON            =32641;
     OCR_SIZENWSE        =32642;
     OCR_SIZENESW        =32643;
     OCR_SIZEWE          =32644;
     OCR_SIZENS          =32645;
     OCR_SIZEALL         =32646;
     OCR_ICOCUR          =32647;
     OCR_NO              =32648;
     OIC_SAMPLE          =32512;
     OIC_HAND            =32513;
     OIC_QUES            =32514;
     OIC_BANG            =32515;
     OIC_NOTE            =32516;
     ORD_LANGDRIVER      =1;

CONST
     IDI_APPLICATION     =32512;
     IDI_HAND            =32513;
     IDI_QUESTION        =32514;
     IDI_EXCLAMATION     =32515;
     IDI_ASTERISK        =32516;

CONST
     IDOK                =1;
     IDCANCEL            =2;
     IDABORT             =3;
     IDRETRY             =4;
     IDIGNORE            =5;
     IDYES               =6;
     IDNO                =7;

CONST
     ES_LEFT             =$0000;
     ES_CENTER           =$0001;
     ES_RIGHT            =$0002;
     ES_MULTILINE        =$0004;
     ES_UPPERCASE        =$0008;
     ES_LOWERCASE        =$0010;
     ES_PASSWORD         =$0020;
     ES_AUTOVSCROLL      =$0040;
     ES_AUTOHSCROLL      =$0080;
     ES_NOHIDESEL        =$0100;
     ES_OEMCONVERT       =$0400;
     ES_READONLY         =$0800;
     ES_WANTRETURN       =$1000;

     EN_SETFOCUS         =$0100;
     EN_KILLFOCUS        =$0200;
     EN_CHANGE           =$0300;
     EN_UPDATE           =$0400;
     EN_ERRSPACE         =$0500;
     EN_MAXTEXT          =$0501;
     EN_HSCROLL          =$0601;
     EN_VSCROLL          =$0602;

     EM_GETSEL               =$00B0;
     EM_SETSEL               =$00B1;
     EM_GETRECT              =$00B2;
     EM_SETRECT              =$00B3;
     EM_SETRECTNP            =$00B4;
     EM_SCROLL               =$00B5;
     EM_LINESCROLL           =$00B6;
     EM_SCROLLCARET          =$00B7;
     EM_GETMODIFY            =$00B8;
     EM_SETMODIFY            =$00B9;
     EM_GETLINECOUNT         =$00BA;
     EM_LINEINDEX            =$00BB;
     EM_SETHANDLE            =$00BC;
     EM_GETHANDLE            =$00BD;
     EM_GETTHUMB             =$00BE;
     EM_LINELENGTH           =$00C1;
     EM_REPLACESEL           =$00C2;
     EM_GETLINE              =$00C4;
     EM_LIMITTEXT            =$00C5;
     EM_CANUNDO              =$00C6;
     EM_UNDO                 =$00C7;
     EM_FMTLINES             =$00C8;
     EM_LINEFROMCHAR         =$00C9;
     EM_SETTABSTOPS          =$00CB;
     EM_SETPASSWORDCHAR      =$00CC;
     EM_EMPTYUNDOBUFFER      =$00CD;
     EM_GETFIRSTVISIBLELINE  =$00CE;
     EM_SETREADONLY          =$00CF;
     EM_SETWORDBREAKPROC     =$00D0;
     EM_GETWORDBREAKPROC     =$00D1;
     EM_GETPASSWORDCHAR      =$00D2;

     WB_LEFT            =0;
     WB_RIGHT           =1;
     WB_ISDELIMITER     =2;

     BS_PUSHBUTTON       =$00000000;
     BS_DEFPUSHBUTTON    =$00000001;
     BS_CHECKBOX         =$00000002;
     BS_AUTOCHECKBOX     =$00000003;
     BS_RADIOBUTTON      =$00000004;
     BS_3STATE           =$00000005;
     BS_AUTO3STATE       =$00000006;
     BS_GROUPBOX         =$00000007;
     BS_USERBUTTON       =$00000008;
     BS_AUTORADIOBUTTON  =$00000009;
     BS_OWNERDRAW        =$0000000B;
     BS_LEFTTEXT         =$00000020;

     BN_CLICKED          =0;
     BN_PAINT            =1;
     BN_HILITE           =2;
     BN_UNHILITE         =3;
     BN_DISABLE          =4;
     BN_DOUBLECLICKED    =5;

     BM_GETCHECK        =$00F0;
     BM_SETCHECK        =$00F1;
     BM_GETSTATE        =$00F2;
     BM_SETSTATE        =$00F3;
     BM_SETSTYLE        =$00F4;

     SS_LEFT             =$00000000;
     SS_CENTER           =$00000001;
     SS_RIGHT            =$00000002;
     SS_ICON             =$00000003;
     SS_BLACKRECT        =$00000004;
     SS_GRAYRECT         =$00000005;
     SS_WHITERECT        =$00000006;
     SS_BLACKFRAME       =$00000007;
     SS_GRAYFRAME        =$00000008;
     SS_WHITEFRAME       =$00000009;
     SS_USERITEM         =$0000000A;
     SS_SIMPLE           =$0000000B;
     SS_LEFTNOWORDWRAP   =$0000000C;
     SS_NOPREFIX         =$00000080;

     STM_SETICON         =$0170;
     STM_GETICON         =$0171;
     STM_MSGMAX          =$0172;

     WC_DIALOG           =$8002;

     DWL_MSGRESULT   =0;
     DWL_DLGPROC     =4;
     DWL_USER        =8;

CONST
     DDL_READWRITE       =$0000;
     DDL_READONLY        =$0001;
     DDL_HIDDEN          =$0002;
     DDL_SYSTEM          =$0004;
     DDL_DIRECTORY       =$0010;
     DDL_ARCHIVE         =$0020;
     DDL_POSTMSGS        =$2000;
     DDL_DRIVES          =$4000;
     DDL_EXCLUSIVE       =$8000;

CONST
     DS_ABSALIGN         =$01;
     DS_SYSMODAL         =$02;
     DS_LOCALEDIT        =$20;
     DS_SETFONT          =$40;
     DS_MODALFRAME       =$80;
     DS_NOIDLEMSG        =$100;
     DS_SETFOREGROUND    =$200;
     DM_GETDEFID         =WM_USER+0;
     DM_SETDEFID         =WM_USER+1;
     DC_HASDEFID         =$534B;

     DLGC_WANTARROWS     =$0001;
     DLGC_WANTTAB        =$0002;
     DLGC_WANTALLKEYS    =$0004;
     DLGC_WANTMESSAGE    =$0004;
     DLGC_HASSETSEL      =$0008;
     DLGC_DEFPUSHBUTTON  =$0010;
     DLGC_UNDEFPUSHBUTTON=$0020;
     DLGC_RADIOBUTTON    =$0040;
     DLGC_WANTCHARS      =$0080;
     DLGC_STATIC         =$0100;
     DLGC_BUTTON         =$2000;
     LB_CTLCODE          =0;

     LB_OKAY             =0;
     LB_ERR              =-1;
     LB_ERRSPACE         =-2;

     LBN_ERRSPACE        =-2;
     LBN_SELCHANGE       =1;
     LBN_DBLCLK          =2;
     LBN_SELCANCEL       =3;
     LBN_SETFOCUS        =4;
     LBN_KILLFOCUS       =5;

     LB_ADDSTRING            =$0180;
     LB_INSERTSTRING         =$0181;
     LB_DELETESTRING         =$0182;
     LB_SELITEMRANGEEX       =$0183;
     LB_RESETCONTENT         =$0184;
     LB_SETSEL               =$0185;
     LB_SETCURSEL            =$0186;
     LB_GETSEL               =$0187;
     LB_GETCURSEL            =$0188;
     LB_GETTEXT              =$0189;
     LB_GETTEXTLEN           =$018A;
     LB_GETCOUNT             =$018B;
     LB_SELECTSTRING         =$018C;
     LB_DIR                  =$018D;
     LB_GETTOPINDEX          =$018E;
     LB_FINDSTRING           =$018F;
     LB_GETSELCOUNT          =$0190;
     LB_GETSELITEMS          =$0191;
     LB_SETTABSTOPS          =$0192;
     LB_GETHORIZONTALEXTENT  =$0193;
     LB_SETHORIZONTALEXTENT  =$0194;
     LB_SETCOLUMNWIDTH       =$0195;
     LB_ADDFILE              =$0196;
     LB_SETTOPINDEX          =$0197;
     LB_GETITEMRECT          =$0198;
     LB_GETITEMDATA          =$0199;
     LB_SETITEMDATA          =$019A;
     LB_SELITEMRANGE         =$019B;
     LB_SETANCHORINDEX       =$019C;
     LB_GETANCHORINDEX       =$019D;
     LB_SETCARETINDEX        =$019E;
     LB_GETCARETINDEX        =$019F;
     LB_SETITEMHEIGHT        =$01A0;
     LB_GETITEMHEIGHT        =$01A1;
     LB_FINDSTRINGEXACT      =$01A2;
     LB_SETLOCALE            =$01A5;
     LB_GETLOCALE            =$01A6;
     LB_SETCOUNT             =$01A7;
     LB_MSGMAX               =$01A8;

     LBS_NOTIFY            =$0001;
     LBS_SORT              =$0002;
     LBS_NOREDRAW          =$0004;
     LBS_MULTIPLESEL       =$0008;
     LBS_OWNERDRAWFIXED    =$0010;
     LBS_OWNERDRAWVARIABLE =$0020;
     LBS_HASSTRINGS        =$0040;
     LBS_USETABSTOPS       =$0080;
     LBS_NOINTEGRALHEIGHT  =$0100;
     LBS_MULTICOLUMN       =$0200;
     LBS_WANTKEYBOARDINPUT =$0400;
     LBS_EXTENDEDSEL       =$0800;
     LBS_DISABLENOSCROLL   =$1000;
     LBS_NODATA            =$2000;
     LBS_STANDARD          =LBS_NOTIFY OR LBS_SORT OR WS_VSCROLL OR WS_BORDER;

     CB_OKAY             =0;
     CB_ERR              =-1;
     CB_ERRSPACE         =-2;

     CBN_ERRSPACE        =-1;
     CBN_SELCHANGE       =1;
     CBN_DBLCLK          =2;
     CBN_SETFOCUS        =3;
     CBN_KILLFOCUS       =4;
     CBN_EDITCHANGE      =5;
     CBN_EDITUPDATE      =6;
     CBN_DROPDOWN        =7;
     CBN_CLOSEUP         =8;
     CBN_SELENDOK        =9;
     CBN_SELENDCANCEL    =10;

     CBS_SIMPLE            =$0001;
     CBS_DROPDOWN          =$0002;
     CBS_DROPDOWNLIST      =$0003;
     CBS_OWNERDRAWFIXED    =$0010;
     CBS_OWNERDRAWVARIABLE =$0020;
     CBS_AUTOHSCROLL       =$0040;
     CBS_OEMCONVERT        =$0080;
     CBS_SORT              =$0100;
     CBS_HASSTRINGS        =$0200;
     CBS_NOINTEGRALHEIGHT  =$0400;
     CBS_DISABLENOSCROLL   =$0800;

     CB_GETEDITSEL               =$0140;
     CB_LIMITTEXT                =$0141;
     CB_SETEDITSEL               =$0142;
     CB_ADDSTRING                =$0143;
     CB_DELETESTRING             =$0144;
     CB_DIR                      =$0145;
     CB_GETCOUNT                 =$0146;
     CB_GETCURSEL                =$0147;
     CB_GETLBTEXT                =$0148;
     CB_GETLBTEXTLEN             =$0149;
     CB_INSERTSTRING             =$014A;
     CB_RESETCONTENT             =$014B;
     CB_FINDSTRING               =$014C;
     CB_SELECTSTRING             =$014D;
     CB_SETCURSEL                =$014E;
     CB_SHOWDROPDOWN             =$014F;
     CB_GETITEMDATA              =$0150;
     CB_SETITEMDATA              =$0151;
     CB_GETDROPPEDCONTROLRECT    =$0152;
     CB_SETITEMHEIGHT            =$0153;
     CB_GETITEMHEIGHT            =$0154;
     CB_SETEXTENDEDUI            =$0155;
     CB_GETEXTENDEDUI            =$0156;
     CB_GETDROPPEDSTATE          =$0157;
     CB_FINDSTRINGEXACT          =$0158;
     CB_SETLOCALE                =$0159;
     CB_GETLOCALE                =$015A;
     CB_MSGMAX                   =$015B;

     SBS_HORZ                    =$0000;
     SBS_VERT                    =$0001;
     SBS_TOPALIGN                =$0002;
     SBS_LEFTALIGN               =$0002;
     SBS_BOTTOMALIGN             =$0004;
     SBS_RIGHTALIGN              =$0004;
     SBS_SIZEBOXTOPLEFTALIGN     =$0002;
     SBS_SIZEBOXBOTTOMRIGHTALIGN =$0004;
     SBS_SIZEBOX                 =$0008;

     SBM_SETPOS                  =$00E0;
     SBM_GETPOS                  =$00E1;
     SBM_SETRANGE                =$00E2;
     SBM_GETRANGE                =$00E3;
     SBM_ENABLE_ARROWS           =$00E4;
     SBM_SETRANGEREDRAW          =$00E6;
     SBM_SETSCROLLINFO           =$00E9;
     SBM_GETSCROLLINFO           =$00EA;

     SIF_RANGE                   =$0001;
     SIF_PAGE                    =$0002;
     SIF_POS                     =$0004;
     SIF_DISABLENOSCROLL         =$0008;
     SIF_TRACKPOS                =$0010;
     SIF_ALL                     =$0017;

     MDIS_ALLCHILDSTYLES         =$0001;

     MDITILE_VERTICAL            =$0000;
     MDITILE_HORIZONTAL          =$0001;
     MDITILE_SKIPDISABLED        =$0002;


TYPE
    TScrollInfo=RECORD
                      cbSize:LONGINT;
                      fMask:LONGINT;
                      nMin:LONGINT;
                      nMax:LONGINT;
                      nPage:LONGINT;
                      nPos:LONGINT;
                      nTrackPos:LONGINT;
    END;


    PMDICREATESTRUCT=^MDICREATESTRUCT;
    MDICREATESTRUCT=RECORD
                          szClass:PChar;
                          szTitle:PChar;
                          hOwner:HANDLE;
                          x:LONGINT;
                          y:LONGINT;
                          cx:LONGINT;
                          cy:LONGINT;
                          style:ULONG;
                          lParam:LPARAM;
    END;
    LPMDICREATESTRUCT=PMDICREATESTRUCT;

    PCLIENTCREATESTRUCT=^CLIENTCREATESTRUCT;
    CLIENTCREATESTRUCT=RECORD
                             hWindowMenu:HANDLE;
                             idFirstChild:ULONG;
    END;
    LPCLIENTCREATESTRUCT=PCLIENTCREATESTRUCT;


    HELPPOLY=ULONG;
    PMULTIKEYHELP=^MULTIKEYHELP;
    MULTIKEYHELP=RECORD
                       mkSize:ULONG;
                       mkKeylist:CHAR;
                       szKeyphrase:ARRAY[0..0] OF CHAR;
    END;
    LPMULTIKEYHELP=PMULTIKEYHELP;

    PHELPWININFO=^HELPWININFO;
    HELPWININFO=RECORD
                      wStructSize:LONGINT;
                      x:LONGINT;
                      y:LONGINT;
                      dx:LONGINT;
                      dy:LONGINT;
                      wMax:LONGINT;
                      rgchMember:ARRAY[0..1] OF CHAR;
    END;
    LPHELPWININFO=PHELPWININFO;

CONST
     HELP_CONTEXT      =$0001;
     HELP_QUIT         =$0002;
     HELP_INDEX        =$0003;
     HELP_CONTENTS     =$0003;
     HELP_HELPONHELP   =$0004;
     HELP_SETINDEX     =$0005;
     HELP_SETCONTENTS  =$0005;
     HELP_CONTEXTPOPUP =$0008;
     HELP_FORCEFILE    =$0009;
     HELP_FINDER       =$000b;
     HELP_KEY          =$0101;
     HELP_COMMAND      =$0102;
     HELP_PARTIALKEY   =$0105;
     HELP_MULTIKEY     =$0201;
     HELP_SETWINPOS    =$0203;

{Martin MS HTMLHelp}
     HH_HELP_FINDER        =  $0000;
     HH_DISPLAY_TOPIC      =  $0000;
     HH_DISPLAY_TOC        =  $0001;
     HH_DISPLAY_INDEX      =  $0002;
     HH_DISPLAY_SEARCH     =  $0003;
     HH_INITIALIZE         =  $001C;  // Initializes the help system.
     HH_UNINITIALIZE       =  $001D;  // Uninitializes the help system.
     HH_CLOSE_ALL          =  $0012;  // close all windows opened directly or indirectly by the caller

CONST
     SPI_GETBEEP                 =1;
     SPI_SETBEEP                 =2;
     SPI_GETMOUSE                =3;
     SPI_SETMOUSE                =4;
     SPI_GETBORDER               =5;
     SPI_SETBORDER               =6;
     SPI_GETKEYBOARDSPEED       =10;
     SPI_SETKEYBOARDSPEED       =11;
     SPI_LANGDRIVER             =12;
     SPI_ICONHORIZONTALSPACING  =13;
     SPI_GETSCREENSAVETIMEOUT   =14;
     SPI_SETSCREENSAVETIMEOUT   =15;
     SPI_GETSCREENSAVEACTIVE    =16;
     SPI_SETSCREENSAVEACTIVE    =17;
     SPI_GETGRIDGRANULARITY     =18;
     SPI_SETGRIDGRANULARITY     =19;
     SPI_SETDESKWALLPAPER       =20;
     SPI_SETDESKPATTERN         =21;
     SPI_GETKEYBOARDDELAY       =22;
     SPI_SETKEYBOARDDELAY       =23;
     SPI_ICONVERTICALSPACING    =24;
     SPI_GETICONTITLEWRAP       =25;
     SPI_SETICONTITLEWRAP       =26;
     SPI_GETMENUDROPALIGNMENT   =27;
     SPI_SETMENUDROPALIGNMENT   =28;
     SPI_SETDOUBLECLKWIDTH      =29;
     SPI_SETDOUBLECLKHEIGHT     =30;
     SPI_GETICONTITLELOGFONT    =31;
     SPI_SETDOUBLECLICKTIME     =32;
     SPI_SETMOUSEBUTTONSWAP     =33;
     SPI_SETICONTITLELOGFONT    =34;
     SPI_GETFASTTASKSWITCH      =35;
     SPI_SETFASTTASKSWITCH      =36;
     SPI_GETFILTERKEYS          =50;
     SPI_SETFILTERKEYS          =51;
     SPI_GETTOGGLEKEYS          =52;
     SPI_SETTOGGLEKEYS          =53;
     SPI_GETMOUSEKEYS           =54;
     SPI_SETMOUSEKEYS           =55;
     SPI_GETSHOWSOUNDS          =56;
     SPI_SETSHOWSOUNDS          =57;
     SPI_GETSTICKYKEYS          =58;
     SPI_SETSTICKYKEYS          =59;
     SPI_GETACCESSTIMEOUT       =60;
     SPI_SETACCESSTIMEOUT       =61;
     SPI_GETSOUNDSENTRY         =64;
     SPI_SETSOUNDSENTRY         =65;

     SPIF_UPDATEINIFILE    =$0001;
     SPIF_SENDWININICHANGE =$0002;
     SPIF_SENDCHANGE       =SPIF_SENDWININICHANGE;

     SSWF_NONE       =0;
     SSWF_TITLE      =1;
     SSWF_WINDOW     =2;
     SSWF_DISPLAY    =3;
     SSWF_CUSTOM     =4;

     SSGF_NONE       =0;
     SSGF_DISPLAY    =3;

     SSTF_NONE       =0;
     SSTF_CHARS      =1;
     SSTF_BORDER     =2;
     SSTF_DISPLAY    =3;

TYPE
    PFILTERKEYS=^FILTERKEYS;
    FILTERKEYS=RECORD
                     cbSize:ULONG;
                     dwFlags:ULONG;
                     iWaitMSec:ULONG;
                     iDelayMSec:ULONG;
                     iRepeatMSec:ULONG;
                     iBounceMSec:ULONG;
    END;
    LPFILTERKEYS=PFILTERKEYS;

CONST
     FKF_FILTERKEYSON    =$00000001;
     FKF_AVAILABLE       =$00000002;
     FKF_HOTKEYACTIVE    =$00000004;
     FKF_CONFIRMHOTKEY   =$00000008;
     FKF_HOTKEYSOUND     =$00000010;
     FKF_INDICATOR       =$00000020;
     FKF_CLICKON         =$00000040;

TYPE
    PSTICKYKEYS=^STICKYKEYS;
    STICKYKEYS=RECORD
                     cbSize:ULONG;
                     dwFlags:ULONG;
    END;
    LPSTICKYKEYS=PSTICKYKEYS;

CONST
     SKF_STICKYKEYSON    =$00000001;
     SKF_AVAILABLE       =$00000002;
     SKF_HOTKEYACTIVE    =$00000004;
     SKF_CONFIRMHOTKEY   =$00000008;
     SKF_HOTKEYSOUND     =$00000010;
     SKF_INDICATOR       =$00000020;
     SKF_AUDIBLEFEEDBACK =$00000040;
     SKF_TRISTATE        =$00000080;
     SKF_TWOKEYSOFF      =$00000100;

TYPE
    PMOUSEKEYS=^MOUSEKEYS;
    MOUSEKEYS=RECORD
                    cbSize:ULONG;
                    dwFlags:ULONG;
                    iMaxSpeed:ULONG;
                    iTimeToMaxSpeed:ULONG;
                    iCtrlSpeed:ULONG;
                    dwReserved1:ULONG;
                    dwReserved2:ULONG;
    END;
    LPMOUSEKEYS=PMOUSEKEYS;

CONST
     MKF_MOUSEKEYSON     =$00000001;
     MKF_AVAILABLE       =$00000002;
     MKF_HOTKEYACTIVE    =$00000004;
     MKF_CONFIRMHOTKEY   =$00000008;
     MKF_HOTKEYSOUND     =$00000010;
     MKF_INDICATOR       =$00000020;
     MKF_MODIFIERS       =$00000040;
     MKF_REPLACENUMBERS  =$00000080;

TYPE
    PACCESSTIMEOUT=^ACCESSTIMEOUT;
    ACCESSTIMEOUT=RECORD
                        cbSize:ULONG;
                        dwFlags:ULONG;
                        iTimeOutMSec:ULONG;
    END;
    LPACCESSTIMEOUT=PACCESSTIMEOUT;

CONST
     ATF_TIMEOUTON       =$00000001;
     ATF_ONOFFFEEDBACK   =$00000002;

TYPE
    PSOUNDSENTRY=^SOUNDSENTRY;
    SOUNDSENTRY=RECORD
                      cbSize:ULONG;
                      dwFlags:ULONG;
                      iFSTextEffect:ULONG;
                      iFSTextEffectMSec:ULONG;
                      iFSTextEffectColorBits:ULONG;
                      iFSGrafEffect:ULONG;
                      iFSGrafEffectMSec:ULONG;
                      iFSGrafEffectColor:ULONG;
                      iWindowsEffect:ULONG;
                      iWindowsEffectMSec:ULONG;
                      lpszWindowsEffectDLL:PChar;
                      iWindowsEffectOrdinal:ULONG;
    END;
    LPSOUNDSENTRY=PSOUNDSENTRY;

CONST
     SSF_SOUNDSENTRYON   =$00000001;
     SSF_AVAILABLE       =$00000002;
     SSF_INDICATOR       =$00000004;

TYPE
    PTOGGLEKEYS=^TOGGLEKEYS;
    TOGGLEKEYS=RECORD
                     cbSize:ULONG;
                     dwFlags:ULONG;
    END;

CONST
     TKF_TOGGLEKEYSON    =$00000001;
     TKF_AVAILABLE       =$00000002;
     TKF_HOTKEYACTIVE    =$00000004;
     TKF_CONFIRMHOTKEY   =$00000008;
     TKF_HOTKEYSOUND     =$00000010;
     TKF_INDICATOR       =$00000020;

CONST
     SLE_ERROR          =$00000001;
     SLE_MINORERROR     =$00000002;
     SLE_WARNING        =$00000003;

TYPE
    NMHDR=RECORD
                hwndFrom:HWND;
                idFrom:LONGWORD;
                code:LONGWORD;
    END;

CONST
    IMAGE_BITMAP        =0;
    IMAGE_ICON          =1;
    IMAGE_CURSOR        =2;
    IMAGE_ENHMETAFILE   =3;

    LR_DEFAULTCOLOR     =$0000;
    LR_MONOCHROME       =$0001;
    LR_COLOR            =$0002;
    LR_COPYRETURNORG    =$0004;
    LR_COPYDELETEORG    =$0008;
    LR_LOADFROMFILE     =$0010;
    LR_LOADTRANSPARENT  =$0020;
    LR_DEFAULTSIZE      =$0040;
    LR_LOADMAP3DCOLORS  =$1000;
    LR_CREATEDIBSECTION =$2000;
    LR_COPYFROMRESOURCE =$4000;
    LR_SHARED           =$8000;

CONST
  CWP_ALL             = 0;
  CWP_SKIPINVISIBLE   = 1;
  CWP_SKIPDISABLED    = 2;
  CWP_SKIPTRANSPARENT = 4;

IMPORTS
      FUNCTION wvsprintf(VAR str1:CSTRING;CONST str2:CSTRING;arglist:POINTER):LONGINT;
                      APIENTRY; 'USER32' name 'wvsprintfA';
      FUNCTION LoadKeyboardLayout(CONST pwstKLID:CSTRING;Flags:ULONG):HKL;
                      APIENTRY; 'USER32' name 'LoadKeyboardLayoutA';
      FUNCTION ActivateKeyboardLayout(ahkl:HKL;Flags:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'ActivateKeyboardLayout';
      FUNCTION UnloadKeyboardLayout(ahkl:HKL):BOOL;
                      APIENTRY; 'USER32' name 'UnloadKeyboardLayout';
      FUNCTION GetKeyboardLayoutName(VAR pwszKLID:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'GetKeyboardLayoutNameA';
      FUNCTION GetThreadDesktop(para:ULONG):HDESK;
                      APIENTRY; 'USER32' name 'GetThreadDesktop';
      FUNCTION GetProcessWindowStation:HWINSTA;
                      APIENTRY; 'USER32' name 'GetProcessWindowStation';
      {FUNCTION SetUserObjectSecurity(hObj:HANDLE;VAR pSIRequested:SECURITY_INFORMATION;
                                     VAR pSID:SECURITY_DESCRIPTOR):BOOL;
                      APIENTRY; 'USER32' name 'SetUserObjectSecurity';
      FUNCTION GetUserObjectSecurity(hObj:HANDLE;VAR pSIRequested:SECURITY_INFORMATION;
                                     VAR pSID:SECURITY_DESCRIPTOR;nLength:ULONG;
                                     VAR lpnLengthNeeded:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'GetUserObjectSecurity';}
      FUNCTION RegisterWindowMessage(CONST lpString:CSTRING):ULONG;
                      APIENTRY; 'USER32' name 'RegisterWindowMessageA';
      FUNCTION GetMessage(VAR lpMsg:MSG;ahwnd:HWND;wMsgFilterMin,wMsgFilterMax:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'GetMessageA';
      FUNCTION TranslateMessage(VAR lpMsg:MSG):BOOL;
                      APIENTRY; 'USER32' name 'TranslateMessage';
      FUNCTION DispatchMessage(VAR lpMsg:MSG):LONG;
                      APIENTRY; 'USER32' name 'DispatchMessageA';
      FUNCTION SetMessageQueue(cMessagesMax:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'SetMessageQueue';
      FUNCTION PeekMessage(VAR lpMsg:MSG;ahWnd:HWND;wMsgFilterMin,wMsgFilterMax:ULONG;
                           wRemoveMsg:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'PeekMessageA';
      FUNCTION RegisterHotKey(aHwnd:HWND;id:LONGINT;fsModifiers,vk:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'RegisterHotKey';
      FUNCTION UnregisterHotKey(aHwnd:HWND;id:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'UnregisterHotKey';
      FUNCTION ExitWindowsEx(uFlags:ULONG;dwReserved:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'ExitWindowsEx';
      FUNCTION SwapMouseButton(fSwap:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'SwapMouseButton';
      FUNCTION GetMessagePos:ULONG;
                      APIENTRY; 'USER32' name 'GetMessagePos';
      FUNCTION GetMessageTime:LONG;
                      APIENTRY; 'USER32' name 'GetMessageTime';
      FUNCTION GetMessageExtraInfo:LONG;
                      APIENTRY; 'USER32' name 'GetMessageExtraInfo';
      FUNCTION SendMessage(ahWnd:HWND;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):LRESULT;
                      APIENTRY; 'USER32' name 'SendMessageA';
      FUNCTION SendMessageTimeout(ahwnd:HWND;Msg:ULONG;awParam:WPARAM;alParam:LPARAM;
                                  fuFlags:ULONG;uTimeout:ULONG;
                                  VAR lpdwResult:ULONG):LRESULT;
                      APIENTRY; 'USER32' name 'SendMessageTimeoutA';
      FUNCTION SendNotifyMessage(ahWnd:HWND;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):BOOL;
                      APIENTRY; 'USER32' name 'SendNotifyMessageA';
      FUNCTION SendMessageCallback(ahWnd:HWND;Msg:ULONG;awParam:WPARAM;alParam:LPARAM;
                                   lpResultCallBack:SENDASYNCPROC;dwData:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'SendMessageCallbackA';
      FUNCTION PostMessage(ahWnd:HWND;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):BOOL;
                      APIENTRY; 'USER32' name 'PostMessageA';
      FUNCTION PostThreadMessage(idThread:ULONG;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):BOOL;
                      APIENTRY; 'USER32' name 'PostThreadMessageA';
      FUNCTION AttachThreadInput(idAttach,idAttachTo:ULONG;fAttach:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'AttachThreadInput';
      FUNCTION ReplyMessage(alResult:LRESULT):BOOL;
                      APIENTRY; 'USER32' name 'ReplyMessage';
      FUNCTION WaitMessage:BOOL;
                      APIENTRY; 'USER32' name 'WaitMessage';
      FUNCTION WaitForInputIdle(hProcess:HANDLE;dwMilliseconds:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'WaitForInputIdle';
      FUNCTION DefWindowProc(ahwnd:HWND;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):LRESULT;
                      APIENTRY; 'USER32' name 'DefWindowProcA';
      PROCEDURE PostQuitMessage(nExitCode:LONGINT);
                      APIENTRY; 'USER32' name 'PostQuitMessage';
      FUNCTION CallWindowProc(lpPrevWndFunc:WNDPROC;ahwnd:HWND;Msg:ULONG;
                              awParam:WPARAM;alParam:LPARAM):LRESULT;
                      APIENTRY; 'USER32' name 'CallWindowProcA';
      FUNCTION InSendMessage:BOOL;
                      APIENTRY; 'USER32' name 'InSendMessage';
      FUNCTION GetDoubleClickTime:ULONG;
                      APIENTRY; 'USER32' name 'GetDoubleClickTime';
      FUNCTION SetDoubleClickTime(Value:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'SetDoubleClickTime';
      FUNCTION RegisterClass(lpWndClass:WNDCLASS):ATOM;
                      APIENTRY; 'USER32' name 'RegisterClassA';
      FUNCTION UnregisterClass(CONST lpClassName:CSTRING;Instance:HINSTANCE):BOOL;
                      APIENTRY; 'USER32' name 'UnregisterClassA';
      FUNCTION GetClassInfo(ahInstance:HINSTANCE;CONST lpClassName:CSTRING;
                            VAR lpWndClass:WNDCLASS):BOOL;
                      APIENTRY; 'USER32' name 'GetClassInfoA';
      FUNCTION CreateWindowEx(dwExStyle:ULONG;CONST lpClassName,lpWindowName:CSTRING;
                              dwStyle:ULONG;X,Y,nWidth,nHeight:LONGINT;
                              hwndParent:HWND;ahMenu:HMENU;ahInstance:HINSTANCE;
                              VAR lpParam):HWND;
                      APIENTRY; 'USER32' name 'CreateWindowExA';
      FUNCTION IsWindow(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'IsWindow';
      FUNCTION IsMenu(ahMenu:HMENU):BOOL;
                      APIENTRY; 'USER32' name 'IsMenu';
      FUNCTION IsChild(hWndParent,ahWnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'IsChild';
      FUNCTION DestroyWindow(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'DestroyWindow';
      FUNCTION ShowWindow(ahwnd:HWND;nCmdShow:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'ShowWindow';
      FUNCTION FlashWindow(ahwnd:HWND;bInvert:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'FlashWindow';
      FUNCTION ShowOwnedPopups(ahwnd:HWND;fShow:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'ShowOwnedPopups';
      FUNCTION OpenIcon(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'OpenIcon';
      FUNCTION CloseWindow(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'CloseWindow';
      FUNCTION MoveWindow(ahwnd:HWND;X,Y,nWidth,nHeight:LONGINT;bRepaint:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'MoveWindow';
      FUNCTION SetWindowPos(ahwnd:HWND;hwndInsertAfter:HWND;X,Y,cx,cy:LONGINT;
                            uFlags:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'SetWindowPos';
      FUNCTION GetWindowPlacement(ahwnd:HWND;VAR lpwndpl:WINDOWPLACEMENT):BOOL;
                      APIENTRY; 'USER32' name 'GetWindowPlacement';
      FUNCTION SetWindowPlacement(ahwnd:HWND;VAR lpwndpl:WINDOWPLACEMENT):BOOL;
                      APIENTRY; 'USER32' name 'SetWindowPlacement';
      FUNCTION BeginDeferWindowPos(nNumWindows:LONGINT):HDWP;
                      APIENTRY; 'USER32' name 'BeginDeferWindowPos';
      FUNCTION DeferWindowPos(hWinPosInfo:HDWP;ahwnd,hwndInsertAfter:HWND;
                              x,y,cx,cy:LONGINT;uFlags:ULONG):HDWP;
                      APIENTRY; 'USER32' name 'DeferWindowPos';
      FUNCTION EndDeferWindowPos(hWinPosInfo:HDWP):BOOL;
                      APIENTRY; 'USER32' name 'EndDeferWindowPos';
      FUNCTION IsWindowVisible(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'IsWindowVisible';
      FUNCTION IsIconic(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'IsIconic';
      FUNCTION AnyPopup:BOOL;
                      APIENTRY; 'USER32' name 'AnyPopup';
      FUNCTION BringWindowToTop(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'BringWindowToTop';
      FUNCTION IsZoomed(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'IsZoomed';
      FUNCTION CreateDialogParam(ahInstance:HINSTANCE;CONST lpTemplateName:CSTRING;
                                 hwndParent:HWND;lpDialogFunc:DLGPROC;
                                 dwInitParam:LPARAM):HWND;
                      APIENTRY; 'USER32' name 'CreateDialogParamA';
      FUNCTION CreateDialogIndirectParam(ahInstance:HINSTANCE;VAR lpTemplate:DLGTEMPLATE;
                                         hwndParent:HWND;lpDialogFunc:DLGPROC;
                                         dwInitParam:LPARAM):HWND;
                      APIENTRY; 'USER32' name 'CreateDialogIndirectParamA';
      FUNCTION DialogBoxParam(ahInstance:HINSTANCE;CONST lpTemplateName:CSTRING;
                              hwndParent:HWND;lpDialogFunc:DLGPROC;
                              dwInitParam:LPARAM):LONGINT;
                      APIENTRY; 'USER32' name 'DialogBoxParamA';
      FUNCTION DialogBoxIndirectParam(ahInstance:HINSTANCE;VAR hDialogTemplate:DLGTEMPLATE;
                                      hwndParent:HWND;lpDialogFunc:DLGPROC;
                                      dwInitParam:LPARAM):LONGINT;
                      APIENTRY; 'USER32' name 'DialogBoxIndirectParamA';
      FUNCTION EndDialog(hDlg:HWND;nResult:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'EndDialog';
      FUNCTION GetDlgItem(hDlg:HWND;nIDDlgItem:LONGINT):HWND;
                      APIENTRY; 'USER32' name 'GetDlgItem';
      FUNCTION SetDlgItemInt(hDlg:HWND;nIDDlgItem:LONGINT;uValue:ULONG;
                             bSigned:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'SetDlgItemInt';
      FUNCTION GetDlgItemInt(hDlg:HWND;nIDDlgItem:LONGINT;VAR lpTranslated:BOOL;
                             bSigned:BOOL):ULONG;
                      APIENTRY; 'USER32' name 'GetDlgItemInt';
      FUNCTION SetDlgItemText(hDlg:HWND;nIDDlgItem:LONGINT;CONST lpString:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'SetDlgItemTextA';
      FUNCTION GetDlgItemText(hDlg:HWND;nIDDlgItem:LONGINT;VAR lpString:CSTRING;
                              nMaxCount:LONGINT):ULONG;
                      APIENTRY; 'USER32' name 'GetDlgItemTextA';
      FUNCTION CheckDlgButton(hDlg:HWND;nIDButton:LONGINT;uCheck:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'CheckDlgButton';
      FUNCTION CheckRadioButton(hDlg:HWND;nIDFirstButton,nIDLastButton:LONGINT;
                                nIDCheckButton:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'CheckRadioButton';
      FUNCTION IsDlgButtonChecked(hDlg:HWND;nIDButton:LONGINT):ULONG;
                      APIENTRY; 'USER32' name 'IsDlgButtonChecked';
      FUNCTION SendDlgItemMessage(hDlg:HWND;nIDDlgItem:LONGINT;Msg:ULONG;
                                  awParam:WPARAM;alparam:LPARAM):LONG;
                      APIENTRY; 'USER32' name 'SendDlgItemMessageA';
      FUNCTION GetNextDlgGroupItem(hDlg:HWND;hCtl:HWND;bPrevious:BOOL):HWND;
                      APIENTRY; 'USER32' name 'GetNextDlgGroupItem';
      FUNCTION GetNextDlgTabItem(hDlg:HWND;hCtl:HWND;bPrevious:BOOL):HWND;
                      APIENTRY; 'USER32' name 'GetNextDlgTabItem';
      FUNCTION GetDlgCtrlID(ahwnd:HWND):LONGINT;
                      APIENTRY; 'USER32' name 'GetDlgCtrlID';
      FUNCTION GetDialogBaseUnits:LONGINT;
                      APIENTRY; 'USER32' name 'GetDialogBaseUnits';
      FUNCTION DefDlgProc(hDlg:HWND;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):LRESULT;
                      APIENTRY; 'USER32' name 'DefDlgProcA';
      FUNCTION CallMsgFilter(VAR lpMsg:MSG;nCode:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'CallMsgFilterA';
      FUNCTION OpenClipboard(hwndNewOwner:HWND):BOOL;
                      APIENTRY; 'USER32' name 'OpenClipboard';
      FUNCTION CloseClipboard:BOOL;
                      APIENTRY; 'USER32' name 'CloseClipboard';
      FUNCTION GetClipboardOwner:HWND;
                      APIENTRY; 'USER32' name 'GetClipboardOwner';
      FUNCTION SetClipboardViewer(hwndNewViewer:HWND):HWND;
                      APIENTRY; 'USER32' name 'SetClipboardViewer';
      FUNCTION GetClipboardViewer:HWND;
                      APIENTRY; 'USER32' name 'GetClipboardViewer';
      FUNCTION ChangeClipboardChain(hwndRemove,hwndNewNext:HWND):BOOL;
                      APIENTRY; 'USER32' name 'ChangeClipboardChain';
      FUNCTION SetClipboardData(uFormat:ULONG;hMem:HANDLE):HANDLE;
                      APIENTRY; 'USER32' name 'SetClipboardData';
      FUNCTION GetClipboardData(uFormat:ULONG):HANDLE;
                      APIENTRY; 'USER32' name 'GetClipboardData';
      FUNCTION RegisterClipboardFormat(CONST lpszFormat:CSTRING):ULONG;
                      APIENTRY; 'USER32' name 'RegisterClipboardFormatA';
      FUNCTION CountClipboardFormats:LONGINT;
                      APIENTRY; 'USER32' name 'CountClipboardFormats';
      FUNCTION EnumClipboardFormats(format:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'EnumClipboardFormats';
      FUNCTION GetClipboardFormatName(format:ULONG;VAR lpszFormatName:CSTRING;
                                      cchMaxCount:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetClipboardFormatNameA';
      FUNCTION LoadCursorFromFile(c:CString):LongInt;
                      APIENTRY; 'USER32' name 'LoadCursorFromFileA';
      FUNCTION LoadImage(Instance:LongInt;Name:CString;utype,X,Y,Flags:LongInt):LongInt;
                      APIENTRY; 'USER32' name 'LoadImageA';
      FUNCTION EmptyClipboard:BOOL;
                      APIENTRY; 'USER32' name 'EmptyClipboard';
      FUNCTION IsClipboardFormatAvailable(format:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'IsClipboardFormatAvailable';
      FUNCTION GetPriorityClipboardFormat(VAR paFormatPriorityList:ULONG;
                                          cFormats:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetPriorityClipboardFormat';
      FUNCTION GetOpenClipboardWindow:HWND;
                      APIENTRY; 'USER32' name 'GetOpenClipboardWindow';
      FUNCTION CharToOem(CONST lpszSrc:CSTRING;VAR lpszDst:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'CharToOemA';
      FUNCTION AnsiToOem(CONST lpszSrc:CSTRING;VAR lpszDst:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'CharToOemA';
      FUNCTION OemToChar(CONST lpszSrc:CSTRING;VAR lpstDst:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'OemToCharA';
      FUNCTION OemToAnsi(CONST lpszSrc:CSTRING;VAR lpstDst:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'OemToCharA';
      FUNCTION CharToOemBuff(CONST lpszSrc:CSTRING;VAR lpszDst:CSTRING;
                             cchDstLength:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'CharToOemBuffA';
      FUNCTION AnsiToOemBuff(CONST lpszSrc:CSTRING;VAR lpszDst:CSTRING;
                             cchDstLength:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'CharToOemBuffA';
      FUNCTION OemToCharBuff(CONST lpszSrc:CSTRING;VAR lpszDst:CSTRING;
                             cchDstLength:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'OemToCharBuffA';
      FUNCTION OemToAnsiBuff(CONST lpszSrc:CSTRING;VAR lpszDst:CSTRING;
                             cchDstLength:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'OemToCharBuffA';
      FUNCTION CharUpper(VAR lpsz:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharUpperA';
      FUNCTION AnsiUpper(VAR lpsz:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharUpperA';
      FUNCTION CharUpperBuff(VAR lpsz:CSTRING;cchLength:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'CharUpperBuffA';
      FUNCTION AnsiUpperBuff(VAR lpsz:CSTRING;cchLength:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'CharUpperBuffA';
      FUNCTION CharLower(VAR lpsz:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharLowerA';
      FUNCTION AnsiLower(VAR lpsz:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharLowerA';
      FUNCTION CharLowerBuff(VAR lpsz:CSTRING;cchLength:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'CharLowerBuffA';
      FUNCTION AnsiLowerBuff(VAR lpsz:CSTRING;cchLength:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'CharLowerBuffA';
      FUNCTION CharNext(CONST lpsz:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharNextA';
      FUNCTION AnsiNext(CONST lpsz:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharNextA';
      FUNCTION CharPrev(CONST lpszStart,lpszCurrent:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharPrevA';
      FUNCTION AnsiPrev(CONST lpszStart,lpszCurrent:CSTRING):PChar;
                      APIENTRY; 'USER32' name 'CharPrevA';
      FUNCTION IsCharAlpha(ch:CHAR):BOOL;
                      APIENTRY; 'USER32' name 'IsCharAlphaA';
      FUNCTION IsCharAlphaNumeric(ch:CHAR):BOOL;
                      APIENTRY; 'USER32' name 'IsCharAlphaNumericA';
      FUNCTION IsCharUpper(ch:CHAR):BOOL;
                      APIENTRY; 'USER32' name 'IsCharUpperA';
      FUNCTION IsCharLower(ch:CHAR):BOOL;
                      APIENTRY; 'USER32' name 'IsCharLowerA';
      FUNCTION SetFocus(ahwnd:HWND):HWND;
                      APIENTRY; 'USER32' name 'SetFocus';
      FUNCTION GetActiveWindow:HWND;
                      APIENTRY; 'USER32' name 'GetActiveWindow';
      FUNCTION GetFocus:HWND;
                      APIENTRY; 'USER32' name 'GetFocus';
      FUNCTION GetKBCodePage:ULONG;
                      APIENTRY; 'USER32' name 'GetKBCodePage';
      FUNCTION GetKeyState(nVirtKey:LONGINT):SHORT;
                      APIENTRY; 'USER32' name 'GetKeyState';
      FUNCTION GetAsyncKeyState(vKey:LONGINT):SHORT;
                      APIENTRY; 'USER32' name 'GetAsyncKeyState';
      FUNCTION GetKeyboardState(VAR lpKeyState:BYTE):BOOL;
                      APIENTRY; 'USER32' name 'GetKeyboardState';
      FUNCTION SetKeyboardState(VAR lpKeyState:BYTE):BOOL;
                      APIENTRY; 'USER32' name 'SetKeyboardState';
      FUNCTION GetKeyNameText(lParam:LONG;VAR lpString:CSTRING;nSize:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetKeyNameTextA';
      FUNCTION GetKeyboardType(nTypeFlag:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetKeyboardType';
      FUNCTION ToAscii(uVirtKey,uScanCode:ULONG;VAR lpKeyState:BYTE;VAR lpChar:WORD;
                       uFlags:ULONG):LONGINT;
                      APIENTRY; 'USER32' name 'ToAscii';
      FUNCTION OemKeyScan(wOemChar:WORD):ULONG;
                      APIENTRY; 'USER32' name 'OemKeyScan';
      FUNCTION VkKeyScan(ch:CHAR):SHORT;
                      APIENTRY; 'USER32' name 'VkKeyScanA';
      PROCEDURE keybd_event(bVK:BYTE;bScan:BYTE;dwFlags,dwExtraInfo:ULONG);
                      APIENTRY; 'USER32' name 'keybd_event';
      PROCEDURE mouse_event(dwFlags,dx,dy,cButtons,dwExtraInfo:ULONG);
                      APIENTRY; 'USER32' name 'mouse_event';
      FUNCTION MapVirtualKey(uCode,uMapType:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'MapVirtualKeyA';
      FUNCTION GetInputState:BOOL;
                      APIENTRY; 'USER32' name 'GetInputState';
      FUNCTION GetQueueStatus(flags:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'GetQueueStatus';
      FUNCTION GetCapture:HWND;
                      APIENTRY; 'USER32' name 'GetCapture';
      FUNCTION SetCapture(ahwnd:HWND):HWND;
                      APIENTRY; 'USER32' name 'SetCapture';
      FUNCTION ReleaseCapture:BOOL;
                      APIENTRY; 'USER32' name 'ReleaseCapture';
      FUNCTION MsgWaitForMultipleObjects(nCount:ULONG;VAR pHandles:HANDLE;
                                  fWaitAll:BOOL;dwMilliseconds,dwWakeMask:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'MsgWaitForMultipleObjects';
      FUNCTION SetTimer(ahwnd:HWND;nIDEvent,uElapse:ULONG;lpTimerFunc:TIMERPROC):ULONG;
                      APIENTRY; 'USER32' name 'SetTimer';
      FUNCTION KillTimer(ahwnd:HWND;uIDEvent:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'KillTimer';
      FUNCTION IsWindowUnicode(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'IsWindowUnicode';
      FUNCTION EnableWindow(ahwnd:HWND;bEnable:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'EnableWindow';
      FUNCTION IsWindowEnabled(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'IsWindowEnabled';
      FUNCTION LoadAccelerators(ahInstance:HINSTANCE;CONST lpTableName:CSTRING):HACCEL;
                      APIENTRY; 'USER32' name 'LoadAcceleratorsA';
      FUNCTION CreateAcceleratorTable(VAR acc:ACCEL;para:LONGINT):HACCEL;
                      APIENTRY; 'USER32' name 'CreateAcceleratorTableA';
      FUNCTION DestroyAcceleratorTable(ahAccel:HACCEL):BOOL;
                      APIENTRY; 'USER32' name 'DestroyAcceleratorTable';
      FUNCTION CopyAcceleratorTable(hAccelSrc:HACCEL;VAR lpAccelDst:ACCEL;
                                    cAccelEntries:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'CopyAcceleratorTableA';
      FUNCTION TranslateAccelerator(ahwnd:HWND;hAccTable:HACCEL;VAR lpMsg:MSG):LONGINT;
                      APIENTRY; 'USER32' name 'TranslateAcceleratorA';
      FUNCTION GetSystemMetrics(nIndex:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetSystemMetrics';
      FUNCTION LoadMenu(hInsance:HINSTANCE;CONST lpMenuName:CSTRING):HMENU;
                      APIENTRY; 'USER32' name 'LoadMenuA';
      FUNCTION LoadMenuIndirect(VAR lpMenuTemplate:MENUTEMPLATE):HMENU;
                      APIENTRY; 'USER32' name 'LoadMenuIndirectA';
      FUNCTION GetMenu(ahnd:HWND):HMENU;
                      APIENTRY; 'USER32' name 'GetMenu';
      FUNCTION SetMenu(ahwnd:HWND;ahMenu:HMENU):BOOL;
                      APIENTRY; 'USER32' name 'SetMenu';
      FUNCTION ChangeMenu(ahMenu:HMENU;cmd:ULONG;CONST lpszNewItem:CSTRING;
                          cmdInsert,flags:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'ChangeMenuA';
      FUNCTION HiliteMenuItem(ahwnd:HWND;ahMenu:HMENU;uIDHiliteItem,uHilite:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'HiliteMenuItem';
      FUNCTION GetMenuString(ahMenu:HMENU;uIDItem:ULONG;VAR lpString:CSTRING;
                             nMaxCount:LONGINT;uFlag:ULONG):LONGINT;
                      APIENTRY; 'USER32' name 'GetMenuStringA';
      FUNCTION GetMenuState(ahMenu:HMENU;uId,uFlags:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'GetMenuState';
      FUNCTION DrawMenuBar(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'DrawMenuBar';
      FUNCTION GetSystemMenu(ahwnd:HWND;bRevert:BOOL):HMENU;
                      APIENTRY; 'USER32' name 'GetSystemMenu';
      FUNCTION CreateMenu:HMENU;
                      APIENTRY; 'USER32' name 'CreateMenu';
      FUNCTION CreatePopupMenu:HMENU;
                      APIENTRY; 'USER32' name 'CreatePopupMenu';
      FUNCTION DestroyMenu(ahMenu:HMENU):BOOL;
                      APIENTRY; 'USER32' name 'DestroyMenu';
      FUNCTION CheckMenuItem(ahMenu:HMENU;uidCheckItem,uCheck:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'CheckMenuItem';
      FUNCTION EnableMenuItem(ahMenu:HMENU;uIDEnableItem,uEnable:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'EnableMenuItem';
      FUNCTION GetSubMenu(ahMenu:HMENU;nPos:LONGINT):HMENU;
                      APIENTRY; 'USER32' name 'GetSubMenu';
      FUNCTION GetMenuItemID(ahMenu:HMENU;nPos:LONGINT):ULONG;
                      APIENTRY; 'USER32' name 'GetMenuItemID';
      FUNCTION GetMenuItemCount(ahMenu:HMENU):LONGINT;
                      APIENTRY; 'USER32' name 'GetMenuItemCount';
      FUNCTION GetMenuItemRect(ahwnd:HWND;ahMenu:HMENU;uItem:ULONG;
                               VAR lprc:RECT):BOOL;
                      APIENTRY; 'USER32' name 'GetMenuItemRect';
      FUNCTION InsertMenu(ahMenu:HMENU;uPosition,uFlags,uIdNewItem:ULONG;
                          CONST lpNewItem:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'InsertMenuA';
      FUNCTION AppendMenu(ahMenu:HMENU;uFlags,uIdNewItem:ULONG;
                          CONST lpNewItem:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'AppendMenuA';
      FUNCTION ModifyMenu(ahMenu:HMENU;uPosition,uFlags,uIdNewItem:ULONG;
                          CONST lpNewItem:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'ModifyMenuA';
      FUNCTION RemoveMenu(ahMenu:HMENU;uPosition,uFlags:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'RemoveMenu';
      FUNCTION DeleteMenu(ahMenu:HMENU;uPosition,uFlags:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'DeleteMenu';
      FUNCTION SetMenuItemBitmaps(ahMenu:HMENU;uPositio,uFlags:ULONG;
                                  hBitmapUnchecked,hBitmapChecked:HBITMAP):BOOL;
                      APIENTRY; 'USER32' name 'SetMenuItemBitmaps';
      FUNCTION GetMenuCheckMarkDimensions:LONG;
                      APIENTRY; 'USER32' name 'GetMenuCheckMarkDimensions';
      FUNCTION TrackPopupMenu(ahMenu:HMENU;uFlags:ULONG;x,y,reserved:LONGINT;
                              ahwnd:HWND;VAR prcRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'TrackPopupMenu';
      FUNCTION DrawIcon(ahDC:HDC;x,y:LONGINT;ahIcon:HICON):BOOL;
                      APIENTRY; 'USER32' name 'DrawIcon';
      FUNCTION DrawText(ahDC:HDC;CONST lpString:CSTRING;nCount:LONGINT;
                        VAR lpRect:RECT;uFormat:ULONG):LONGINT;
                      APIENTRY; 'USER32' name 'DrawTextA';
      FUNCTION GrayString(ahDC:HDC;ahBrush:HBRUSH;lpOutFunc:GRAYSTRINGPROC;
                          lpData:LPARAM;nCount,x,y,nWidth,nHeight:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'GrayStringA';
      FUNCTION TabbedTextOut(ahDC:HDC;x,y:LONGINT;CONST lpString:CSTRING;
                             nCount,nTabPositions:LONGINT;VAR lpnTabStopPositions:LONGINT;
                             nTabOrigin:LONGINT):LONG;
                      APIENTRY; 'USER32' name 'TabbedTextOutA';
      FUNCTION GetTabbedTextExtent(ahDC:HDC;CONST lpString:CSTRING;nCount,nTabPositions:LONGINT;
                                   VAR lpnTabStopPositions:LONGINT):ULONG;
                      APIENTRY; 'USER32' name 'GetTabbedTextExtentA';
      FUNCTION UpdateWindow(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'UpdateWindow';
      FUNCTION SetActiveWindow(ahwnd:HWND):HWND;
                      APIENTRY; 'USER32' name 'SetActiveWindow';
      FUNCTION GetForegroundWindow:HWND;
                      APIENTRY; 'USER32' name 'GetForegroundWindow';
      FUNCTION SetForegroundWindow(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'SetForegroundWindow';
      FUNCTION WindowFromDC(ahDC:HDC):HWND;
                      APIENTRY; 'USER32' name 'WindowFromDC';
      FUNCTION GetDC(ahwnd:HWND):HDC;
                      APIENTRY; 'USER32' name 'GetDC';
      FUNCTION GetDCEx(ahwnd:HWND;hrgnClip:HRGN;flags:ULONG):HDC;
                      APIENTRY; 'USER32' name 'GetDCEx';
      FUNCTION GetWindowDC(ahwnd:HWND):HDC;
                      APIENTRY; 'USER32' name 'GetWindowDC';
      FUNCTION ReleaseDC(ahwnd:HWND;ahDC:HDC):LONGINT;
                      APIENTRY; 'USER32' name 'ReleaseDC';
      FUNCTION BeginPaint(ahwnd:HWND;VAR lpPaint:PAINTSTRUCT):HDC;
                      APIENTRY; 'USER32' name 'BeginPaint';
      FUNCTION EndPaint(ahwnd:HWND;VAR lpPaint:PAINTSTRUCT):BOOL;
                      APIENTRY; 'USER32' name 'EndPaint';
      FUNCTION GetUpdateRect(ahwnd:HWND;VAR lpRect:RECT;bErase:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'GetUpdateRect';
      FUNCTION GetUpdateRgn(ahwnd:HWND;ahRgn:HRGN;bErase:BOOL):LONGINT;
                      APIENTRY; 'USER32' name 'GetUpdateRgn';
      FUNCTION ExcludeUpdateRgn(ahDC:HDC;ahWnd:HWND):LONGINT;
                      APIENTRY; 'USER32' name 'ExcludeUpdateRgn';
      FUNCTION InvalidateRect(ahwnd:HWND;VAR lpRect:RECT;bErase:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'InvalidateRect';
      FUNCTION ValidateRect(ahwnd:HWND;VAR lpRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'ValidateRect';
      FUNCTION InvalidateRgn(ahwnd:HWND;ahRgn:HRGN;bErase:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'InvalidateRgn';
      FUNCTION ValidateRgn(ahwnd:HWND;ahRgn:HRGN):BOOL;
                      APIENTRY; 'USER32' name 'ValidateRgn';
      FUNCTION RedrawWindow(ahwnd:HWND;VAR lprcUpdate:RECT;hrgnUpdate:HRGN;
                            flags:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'RedrawWindow';
      FUNCTION LockWindowUpdate(hwndLock:HWND):BOOL;
                      APIENTRY; 'USER32' name 'LockWindowUpdate';
      FUNCTION ScrollWindow(ahwnd:HWND;XAmount,YAmount:LONGINT;
                            VAR lpRect,lpClipRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'ScrollWindow';
      FUNCTION ScrollDC(ahDC:HDC;dx,dy:LONGINT;VAR lprcScroll,lprcClip:RECT;
                        hrgnUpdate:HRGN;VAR lprcUpdate:RECT):BOOL;
                      APIENTRY; 'USER32' name 'ScrollDC';
      FUNCTION ScrollWindowEx(ahwnd:HWND;dx,dy:LONGINT;VAR prcScroll,prcClip:RECT;
                              hrgnUpdate:HRGN;VAR prcUpdate:RECT;Flags:ULONG):LONGINT;
                      APIENTRY; 'USER32' name 'ScrollWindowEx';
      FUNCTION SetScrollPos(ahwnd:HWND;nBar,nPos:LONGINT;bRedraw:BOOL):LONGINT;
                      APIENTRY; 'USER32' name 'SetScrollPos';
      FUNCTION GetScrollPos(ahwnd:HWND;nBar:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetScrollPos';
      FUNCTION SetScrollRange(ahwnd:HWND;nBar,nMinPos,nMaxPos:LONGINT;bRedraw:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'SetScrollRange';
      FUNCTION GetScrollRange(ahwnd:HWND;nBar:LONGINT;VAR lpMinPos,lpMaxPos:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'GetScrollRange';
      FUNCTION SetScrollInfo(ahwnd:HWND;nBar:LONGINT;CONST ScrollInfo:TScrollInfo;bRedraw:BOOL):LONGINT;
                      APIENTRY; 'USER32' name 'SetScrollInfo';
      FUNCTION GetScrollInfo(ahwnd:HWND;nBar:LONGINT;VAR ScrollInfo:TScrollInfo):BOOL;
                      APIENTRY; 'USER32' name 'GetScrollInfo';
      FUNCTION ShowScrollBar(ahwnd:HWND;wBar:LONGINT;bShow:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'ShowScrollBar';
      FUNCTION EnableScrollBar(ahwnd:HWND;wSBflags,wArrows:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'EnableScrollBar';
      FUNCTION SetProp(ahwnd:HWND;CONST lpString:CSTRING;hData:HANDLE):BOOL;
                      APIENTRY; 'USER32' name 'SetPropA';
      FUNCTION GetProp(ahwnd:HWND;CONST lpString:CSTRING):HANDLE;
                      APIENTRY; 'USER32' name 'GetPropA';
      FUNCTION RemoveProp(ahwnd:HWND;CONST lpString:CSTRING):HANDLE;
                      APIENTRY; 'USER32' name 'RemovePropA';
      FUNCTION EnumPropsEx(ahwnd:HWND;lpEnumFunc:PROPENUMPROCEX;alParam:LPARAM):LONGINT;
                      APIENTRY; 'USER32' name 'EnumPropsExA';
      FUNCTION EnumProps(ahwnd:HWND;lpEnumFunc:PROPENUMPROC):LONGINT;
                      APIENTRY; 'USER32' name 'EnumPropsA';
      FUNCTION SetWindowText(ahwnd:HWND;CONST lpString:CSTRING):BOOL;
                      APIENTRY; 'USER32' name 'SetWindowTextA';
      FUNCTION GetWindowText(ahwnd:HWND;VAR lpString:CSTRING;nMaxCount:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetWindowTextA';
      FUNCTION GetWindowTextLength(ahwnd:HWND):LONGINT;
                      APIENTRY; 'USER32' name 'GetWindowTextLengthA';
      FUNCTION GetClientRect(ahwnd:HWND;VAR lpRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'GetClientRect';
      FUNCTION GetWindowRect(ahwnd:HWND;VAR lpRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'GetWindowRect';
      FUNCTION AdjustWindowRect(VAR lpRect:RECT;dwStyle:ULONG;bMenu:BOOL):BOOL;
                      APIENTRY; 'USER32' name 'AdjustWindowRect';
      FUNCTION AdjustWindowRectEx(VAR lpRect:RECT;dwStyle:ULONG;bMenu:BOOL;
                                  dwExStyle:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'AdjustWindowRectEx';
      FUNCTION MessageBox(ahwnd:HWND;CONST lpText,lpCaption:CSTRING;uType:ULONG):LONGINT;
                      APIENTRY; 'USER32' name 'MessageBoxA';
      FUNCTION MessageBoxEx(ahwnd:HWND;CONST lpText,lpCaption:CSTRING;uType:ULONG;
                            wLanguageId:WORD):LONGINT;
                      APIENTRY; 'USER32' name 'MessageBoxExA';
      FUNCTION MessageBeep(uType:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'MessageBeep';
      FUNCTION ShowCursor(bShow:BOOL):LONGINT;
                      APIENTRY; 'USER32' name 'ShowCursor';
      FUNCTION SetCursorPos(X,Y:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'SetCursorPos';
      FUNCTION SetCursor(ahCursor:HCURSOR):HCURSOR;
                      APIENTRY; 'USER32' name 'SetCursor';
      FUNCTION GetCursorPos(VAR lpPoint:POINT):BOOL;
                      APIENTRY; 'USER32' name 'GetCursorPos';
      FUNCTION ClipCursor(VAR lpRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'ClipCursor';
      FUNCTION GetClipCursor(VAR lpRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'GetClipCursor';
      FUNCTION GetCursor:HCURSOR;
                      APIENTRY; 'USER32' name 'GetCursor';
      FUNCTION CreateCaret(ahwnd:HWND;ahBitmap:HBITMAP;nWidth,nHeight:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'CreateCaret';
      FUNCTION GetCaretBlinkTime:ULONG;
                      APIENTRY; 'USER32' name 'GetCaretBlinkTime';
      FUNCTION SetCaretBlinkTime(uMSeconds:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'SetCaretBlinkTime';
      FUNCTION DestroyCaret:BOOL;
                      APIENTRY; 'USER32' name 'DestroyCaret';
      FUNCTION HideCaret(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'HideCaret';
      FUNCTION ShowCaret(ahwnd:HWND):BOOL;
                      APIENTRY; 'USER32' name 'ShowCaret';
      FUNCTION SetCaretPos(X,Y:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'SetCaretPos';
      FUNCTION GetCaretPos(VAR lpPoint:POINT):BOOL;
                      APIENTRY; 'USER32' name 'GetCaretPos';
      FUNCTION ClientToScreen(ahwnd:HWND;VAR lpPoint:POINT):BOOL;
                      APIENTRY; 'USER32' name 'ClientToScreen';
      FUNCTION ScreenToClient(ahwnd:HWND;VAR lpPoint:POINT):BOOL;
                      APIENTRY; 'USER32' name 'ScreenToClient';
      FUNCTION MapWindowPoints(hwndFrom,hwndTo:HWND;VAR lpPoints:POINT;cPoints:ULONG):LONGINT;
                      APIENTRY; 'USER32' name 'MapWindowPoints';
      FUNCTION GetSysColor(nIndex:LONGINT):ULONG;
                      APIENTRY; 'USER32' name 'GetSysColor';
      FUNCTION SetSysColors(cElements:LONGINT;VAR lpaElements:LONGINT;
                            VAR lpaRgbValues:COLORREF):BOOL;
                      APIENTRY; 'USER32' name 'SetSysColors';
      FUNCTION DrawFocusRect(ahDC:HDC;CONST lprc:RECT):BOOL;
                      APIENTRY; 'USER32' name 'DrawFocusRect';
      FUNCTION FillRect(ahDC:HDC;CONST lprc:RECT;hbr:HBRUSH):LONGINT;
                      APIENTRY; 'USER32' name 'FillRect';
      FUNCTION FrameRect(ahDC:HDC;CONST lprc:RECT;hbr:HBRUSH):LONGINT;
                      APIENTRY; 'USER32' name 'FrameRect';
      FUNCTION InvertRect(ahDC:HDC;VAR lprc:RECT):BOOL;
                      APIENTRY; 'USER32' name 'InvertRect';
      FUNCTION SetRect(VAR lprc:RECT;xLeft,yTop,xRight,yBottom:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'SetRect';
      FUNCTION SetRectEmpty(VAR lprc:RECT):BOOL;
                      APIENTRY; 'USER32' name 'SetRectEmpty';
      FUNCTION CopyRect(VAR lprcDst,lprcSrc:RECT):BOOL;
                      APIENTRY; 'USER32' name 'CopyRect';
      FUNCTION InflateRect(VAR lprc:RECT;dx,dy:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'InflateRect';
      FUNCTION IntersectRect(VAR lprcDst:RECT;CONST lprcSrc1,lprcSrc2:RECT):BOOL;
                      APIENTRY; 'USER32' name 'IntersectRect';
      FUNCTION UnionRect(VAR lprcDst,lprcSrc1,lprcSrc2:RECT):BOOL;
                      APIENTRY; 'USER32' name 'UnionRect';
      FUNCTION SubtractRect(VAR lprcDst,lprcSrc1,lprcSrc2:RECT):BOOL;
                      APIENTRY; 'USER32' name 'SubtractRect';
      FUNCTION OffsetRect(VAR lprc:RECT;dx,dy:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'OffsetRect';
      FUNCTION IsRectEmpty(VAR lprc:RECT):BOOL;
                      APIENTRY; 'USER32' name 'IsRectEmpty';
      FUNCTION EqualRect(VAR lprc1,lprc2:RECT):BOOL;
                      APIENTRY; 'USER32' name 'EqualRect';
      FUNCTION PtInRect(CONST lprc:RECT;CONST pt:POINT):BOOL;
                      APIENTRY; 'USER32' name 'PtInRect';
      FUNCTION GetWindowWord(ahwnd:HWND;nIndex:LONGINT):WORD;
                      APIENTRY; 'USER32' name 'GetWindowWord';
      FUNCTION SetWindowWord(ahwnd:HWND;nIndex:LONGINT;nNewWord:WORD):WORD;
                      APIENTRY; 'USER32' name 'SetWindowWord';
      FUNCTION GetWindowLong(ahwnd:HWND;nIndex:LONGINT):LONG;
                      APIENTRY; 'USER32' name 'GetWindowLongA';
      FUNCTION SetWindowLong(ahwnd:HWND;nIndex:LONGINT;dwNewLong:LONG):LONG;
                      APIENTRY; 'USER32' name 'SetWindowLongA';
      FUNCTION GetClassWord(ahwnd:HWND;nIndex:LONGINT):WORD;
                      APIENTRY; 'USER32' name 'GetClassWord';
      FUNCTION SetClassWord(ahwnd:HWND;nIndex:LONGINT;wNewWord:WORD):WORD;
                      APIENTRY; 'USER32' name 'SetClassWord';
      FUNCTION GetClassLong(ahwnd:HWND;nIndex:LONGINT):ULONG;
                      APIENTRY; 'USER32' name 'GetClassLongA';
      FUNCTION SetClassLong(ahwnd:HWND;nIndex:LONGINT;dwNewLong:LONG):ULONG;
                      APIENTRY; 'USER32' name 'SetClassLongA';
      FUNCTION GetDesktopWindow:HWND;
                      APIENTRY; 'USER32' name 'GetDesktopWindow';
      FUNCTION GetParent(ahwnd:HWND):HWND;
                      APIENTRY; 'USER32' name 'GetParent';
      FUNCTION SetParent(hwndChild,hWndNewParent:HWND):HWND;
                      APIENTRY; 'USER32' name 'SetParent';
      FUNCTION EnumChildWindows(hWndParent:HWND;lpEnumFunc:WNDENUMPROC;alParam:LPARAM):BOOL;
                      APIENTRY; 'USER32' name 'EnumChildWindows';
      FUNCTION FindWindow(CONST lpClassName,lpWindowName:CSTRING):HWND;
                      APIENTRY; 'USER32' name 'FindWindowA';
      FUNCTION EnumWindows(lpEnumFunc:WNDENUMPROC;alParam:LPARAM):BOOL;
                      APIENTRY; 'USER32' name 'EnumWindows';
      FUNCTION EnumThreadWindows(dwThreadId:ULONG;lpfn:WNDENUMPROC;alParam:LPARAM):BOOL;
                      APIENTRY; 'USER32' name 'EnumThreadWindows';
      FUNCTION GetClassName(ahwnd:HWND;VAR lpClassName:CSTRING;nMaxCount:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'GetClassNameA';
      FUNCTION GetTopWindow(ahwnd:HWND):HWND;
                      APIENTRY; 'USER32' name 'GetTopWindow';
      FUNCTION GetWindowThreadProcessId(ahwnd:HWND;VAR lpdwProcessId:ULONG):ULONG;
                      APIENTRY; 'USER32' name 'GetWindowThreadProcessId';
      FUNCTION GetLastActivePopup(ahwnd:HWND):HWND;
                      APIENTRY; 'USER32' name 'GetLastActivePopup';
      FUNCTION GetWindow(ahwnd:HWND;uCmd:ULONG):HWND;
                      APIENTRY; 'USER32' name 'GetWindow';
      FUNCTION GetNextWindow(ahwnd:HWND;uCmd:ULONG):HWND;
                      APIENTRY; 'USER32' name 'GetNextWindow';
      FUNCTION SetWindowsHook(nFilterType:LONGINT;pfnFilterProc:HOOKPROC):HOOKPROC;
                      APIENTRY; 'USER32' name 'SetWindowsHookA';
      FUNCTION UnhookWindowsHook(nCode:LONGINT;pfnFilterProc:HOOKPROC):BOOL;
                      APIENTRY; 'USER32' name 'UnhookWindowsHook';
      FUNCTION SetWindowsHookEx(idHook:LONGINT;lpfn:HOOKPROC;hmod:HINSTANCE;
                                dwThreadId:ULONG):HHOOK;
                      APIENTRY; 'USER32' name 'SetWindowsHookExA';
      FUNCTION UnhookWindowsHookEx(hhk:HHOOK):BOOL;
                      APIENTRY; 'USER32' name 'UnhookWindowsHookEx';
      FUNCTION CallNextHookEx(hhk:HHOOK;nCode:LONGINT;awParam:WPARAM;alParam:LPARAM):LRESULT;
                      APIENTRY; 'USER32' name 'CallNextHookEx';
      FUNCTION LoadBitmap(ahInstance:HINSTANCE;CONST lpBitmapName:CSTRING):HBITMAP;
                      APIENTRY; 'USER32' name 'LoadBitmapA';
      FUNCTION LoadCursorAPI(ahInstance:HINSTANCE;lpCursorName:PChar):HCURSOR;
                      APIENTRY; 'USER32' name 'LoadCursorA';
      FUNCTION CreateCursor(hInst:HINSTANCE;xHotSpot,yHotSpot,nWidth,nHeight:LONGINT;
                            VAR pvANDPlane,pvXORPlane):HCURSOR;
                      APIENTRY; 'USER32' name 'CreateCursor';
      FUNCTION DestroyCursor(ahCursor:HCURSOR):BOOL;
                      APIENTRY; 'USER32' name 'DestroyCursor';
      FUNCTION LoadIcon(ahInstance:HINSTANCE;CONST lpIconName:CSTRING):HICON;
                      APIENTRY; 'USER32' name 'LoadIconA';
      FUNCTION CreateIcon(ahInstance:HINSTANCE;nWidth,nHeight:LONGINT;cPlanes,cBitsPixel:BYTE;
                          VAR lpbANDBits,lpbXORBits):HICON;
                      APIENTRY; 'USER32' name 'CreateIcon';
      FUNCTION  DestroyIcon(ahIcon:HICON):BOOL;
                      APIENTRY; 'USER32' name 'DestroyIcon';
      FUNCTION LookupIconIdFromDirectory(VAR presbits;fIcon:BOOL):LONGINT;
                      APIENTRY; 'USER32' name 'LookupIconIdFromDirectory';
      FUNCTION CreateIconFromResource(VAR presbits;dwResSize:ULONG;fIcon:BOOL;
                                      dwVer:ULONG):HICON;
                      APIENTRY; 'USER32' name 'CreateIconFromResource';
      FUNCTION CreateIconFromResourceEx(VAR presbits;dwResSize:ULONG;fIcon:BOOL;
                                      dwVer:ULONG;CX,CY:LongWord;Flags:LongWord):HICON;
                      APIENTRY; 'USER32' name 'CreateIconFromResourceEx';
      FUNCTION CreateIconIndirect(VAR apiconinfo:ICONINFO):HICON;
                      APIENTRY; 'USER32' name 'CreateIconIndirect';
      FUNCTION CopyIcon(ahIcon:HICON):HICON;
                      APIENTRY; 'USER32' name 'CopyIcon';
      FUNCTION GetIconInfo(ahIcon:HICON;VAR apiconinfo:ICONINFO):BOOL;
                      APIENTRY; 'USER32' name 'GetIconInfo';
      FUNCTION LoadString(ahInstance:HINSTANCE;uID:ULONG;VAR lpBuffer;
                          nBufferMax:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'LoadStringA';
      FUNCTION IsDialogMessage(hDlg:HWND;VAR lpMsg:MSG):BOOL;
                      APIENTRY; 'USER32' name 'IsDialogMessageA';
      FUNCTION MapDialogRect(hDlg:HWND;VAR lpRect:RECT):BOOL;
                      APIENTRY; 'USER32' name 'MapDialogRect';
      FUNCTION DlgDirList(hDlg:HWND;VAR lpPathSpec:CSTRING;nIDListBox,nIDStaticPath:LONGINT;
                          uFileType:ULONG):LONGINT;
                      APIENTRY; 'USER32' name 'DlgDirListA';
      FUNCTION DlgDirSelectEx(hDlg:HWND;VAR lpString:CSTRING;nCount,nIDListBox:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'DlgDirSelectExA';
      FUNCTION DlgDirListComboBox(hDlg:HWND;VAR lpPathSpec:CSTRING;
                                  nIDComboBox,nIDStaticPath:LONGINT):LONGINT;
                      APIENTRY; 'USER32' name 'DlgDirListComboBoxA';
      FUNCTION DlgDirSelectComboBoxEx(hDlg:HWND;VAR lpString:CSTRING;
                                      nCount,nIDComboBox:LONGINT):BOOL;
                      APIENTRY; 'USER32' name 'DlgDirSelectComboBoxExA';
      FUNCTION DefFrameProc(ahwnd:HWND;hwndMDIClient:HWND;uMsg:ULONG;
                            awParam:WPARAM;alParam:LPARAM):LRESULT;
                      APIENTRY; 'USER32' name 'DefFrameProcA';
      FUNCTION DefMDIChildProc(ahwnd:HWND;uMsg:ULONG;awParam:WPARAM;alParam:LPARAM):LRESULT;
                      APIENTRY; 'USER32' name 'DefMDIChildProcA';
      FUNCTION TranslateMDISysAccel(hWndClient:HWND;VAR lpMsg:MSG):BOOL;
                      APIENTRY; 'USER32' name 'TranslateMDISysAccel';
      FUNCTION ArrangeIconicWindows(ahwnd:HWND):ULONG;
                      APIENTRY; 'USER32' name 'ArrangeIconicWindows';
      FUNCTION CreateMDIWindow(CONST lpClassName,lpWindowName:CSTRING;dwStyle:ULONG;
                               X,Y,nWidth,nHeight:LONGINT;hwndParent:HWND;
                               ahInstance:HINSTANCE;alParam:LPARAM):HWND;
                      APIENTRY; 'USER32' name 'CreateMDIWindowA';
      FUNCTION WinHelp(hwndMain:HWND;CONST lpszHelp:CSTRING;uCommand:ULONG;
                       dwData:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'WinHelpA';
      FUNCTION SystemParametersInfo(uiAction,uiParam:ULONG;VAR pvParam;
                                    fWinIni:ULONG):BOOL;
                      APIENTRY; 'USER32' name 'SystemParametersInfoA';
      PROCEDURE SetDebugErrorLevel(dwLevel:ULONG);
                      APIENTRY; 'USER32' name 'SetDebugErrorLevel';
      PROCEDURE SetLastErrorEx(dwErrCode,dwType:ULONG);
                      APIENTRY; 'USER32' name 'SetLastErrorEx';
      FUNCTION DragObject(p1,p2:HWND;p3:LONGWORD;p4:LONGWORD;
                          p5:HICON):LONGWORD;
                      APIENTRY; 'USER32' name 'DragObject';
      FUNCTION CopyImage(ahandle:HANDLE;Typ:LONGWORD;cx,cy:LONGINT;Flags:LONGWORD):HICON;
                      APIENTRY; 'USER32' name 'CopyImage';
END;

FUNCTION MAKEWPARAM(l,h:INTEGER):WPARAM;
FUNCTION MAKELPARAM(l,h:INTEGER):LPARAM;
FUNCTION MAKELRESULT(l,h:INTEGER):LRESULT;
FUNCTION ExitWindows(dwReserved:ULONG;Code:ULONG):BOOL;
{$IFDEF VER30}
FUNCTION CreateWindow(CONST lpClassName,lpWindowName:CSTRING;
                      dwStyle:ULONG;X,Y,nWidth,nHeight:LONGINT;
                      hwndParent:HWND;ahMenu:HMENU;ahInstance:HINSTANCE;
                      VAR lpParam):HWND;CDECL;
{$ELSE}
FUNCTION CreateWindow(CONST lpClassName,lpWindowName:CSTRING;
                      dwStyle:ULONG;X,Y,nWidth,nHeight:LONGINT;
                      hwndParent:HWND;ahMenu:HMENU;ahInstance:HINSTANCE;
                      VAR lpParam):HWND;
{$ENDIF}
FUNCTION CreateDialog(ahInstance:HINSTANCE;CONST DialogId:CSTRING;
                      hWndParent:HWND;lpDialogFunc:DLGPROC):HWND;
FUNCTION PostAppMessage(idThread:ULONG;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):BOOL;
FUNCTION CreateDialogIndirect(ahInstance:HINSTANCE;VAR lpTemplate:DLGTEMPLATE;
                              hwndParent:HWND;lpDialogFunc:DLGPROC):HWND;
FUNCTION DialogBoxIndirect(ahInstance:HINSTANCE;VAR hDialogTemplate:DLGTEMPLATE;
                           hwndParent:HWND;lpDialogFunc:DLGPROC):LONGINT;
FUNCTION DialogBox(ahInstance:HINSTANCE;CONST DialogId:CSTRING;hwndParent:HWND;
                   DialogProc:DLGPROC):LONGINT;
FUNCTION EnumTaskWindows(dwTaskId:ULONG;lpfn:WNDENUMPROC;alParam:LPARAM):BOOL;
FUNCTION GetSysModalWindow:HWND;
FUNCTION SetSysModalWindow(ahwnd:HWND):HWND;
FUNCTION GetWindowTask(ahwnd:HWND):ULONG;
FUNCTION DefHookProc(nCode:LONGINT;awParam:WPARAM;alParam:LPARAM;phhk:HHOOK):LRESULT;

FUNCTION CopyCursor(ahCursor:HCURSOR):HCURSOR;

FUNCTION MakeIntResource(i:LONGINT):PChar;
FUNCTION MenuItemFromPoint(ahWnd:HWND;ahMenu:HMENU;CONST ptScreen:POINT):BOOL;
FUNCTION DragDetect(p1:HWND;CONST p2:POINT):BOOL;
FUNCTION WindowFromPoint(CONST aPoint:POINT):HWND;
FUNCTION ChildWindowFromPoint(hwndParent:HWND;CONST aPoint:POINT):HWND;
FUNCTION ChildWindowFromPointEx(ahWnd:HWND;CONST aPoint:POINT;Flags:LONGWORD):HWND;
FUNCTION LoadCursor(Handle:HINSTANCE;Name:PChar):HCURSOR;

{Martin}
  FUNCTION HtmlHelp(hwndMain:HWND;szHelp:CSTRING;uCommand:ULONG;dwData:ULONG):BOOL;
  procedure FreeHtmlHelp;
  var HelpModule_HHCTRL : HModule; dwCookie : longword;

IMPLEMENTATION

{Martin MS HTML Help---------------------------------}
type
  TFNHtmlHelpA = function(hwndMain: HWND; pszFile: LPCSTR; uCommand: word; dwData: DWORD): HWND; APIENTRY;
FUNCTION HtmlHelp(hwndMain:HWND;szHelp:CSTRING;uCommand:ULONG;dwData:ULONG):BOOL;
var
  HtmlHelpA: TFNHtmlHelpA;
  CS : cstring;
begin
  Result := False;
  if HelpModule_HHCTRL = 0 then begin
    HelpModule_HHCTRL := LoadLibrary('HHCTRL.OCX');
  end;
  if HelpModule_HHCTRL <> 0 then begin
    @HtmlHelpA := Pointer(GetProcAddress(HelpModule_HHCTRL,'HtmlHelpA'));
    if @HtmlHelpA <> nil then begin
      if dwCookie = 0 then begin
        HtmlHelpA (0, lpcstr(0), HH_INITIALIZE, longword(@dwCookie));
      end;
      CS := szHelp;
      sleep (100);
      Result := HtmlHelpA(hwndMain, @cs, uCommand, dwData) <> 0;
      if not Result then Messagebox (HWND_DESKTOP, cs, 'running help failed', 0);
    end;
  end;
end;

procedure FreeHTMLHelp;
var
  HtmlHelpA: TFNHtmlHelpA;
  begin
    if dwCookie <> 0 then begin
      @HtmlHelpA := Pointer(GetProcAddress(HelpModule_HHCTRL,'HtmlHelpA'));
      if @HtmlHelpA <> nil then begin
        HtmlHelpA (0, lpcstr(0), HH_CLOSE_ALL, 0);
        HtmlHelpA (0, lpcstr(0), HH_UNINITIALIZE, longword(@dwCookie));
      end;
    end;
  end;

{---end MS HTML Help------------------------------------}

Function LoadCursor(Handle:HINSTANCE;Name:PChar):HCURSOR;
Var c,c1,c2:CString;
    ResHandle:LongWord;
    Size:LongWord;
    pbBuffer:Pointer;
    f:file;
Begin
  If Handle=0 Then
    Begin
      Result:=LoadCursorAPI(Handle,Name);
      exit;
    End;

  Result:=LoadCursorAPI(Handle,Name);
  If Result<>0 Then exit;

  If GetTempPath(255,C1)=0 Then exit;
  C:='#'+tostr(LongWord(Name));
  ResHandle:=FindResource(DllModule,C,MAKEINTRESOURCE(RT_CURSOR)^);
  If ResHandle=0 Then exit;
  pbBuffer:=Pointer(LoadResource(DllModule,ResHandle));
  If pbBuffer=Nil Then exit;
  Size:=SizeOfResource(DllModule,ResHandle);

// Cursor in das Temp-Verzeichnis speichern
  If WinBase.GetTempFileName(C1,'SIB',0,C2)=0 Then exit;
  System.Assign(f,C2);
  {$I-}
  Rewrite(f);
  {$I+}
  If IoResult<>0 Then exit;
  {$I-}
  BlockWrite(f,pbBuffer^,Size);
  System.Close(f);
  {$I+}

// Laden des Cursours vom File
  Result:=LoadCursorFromFile(C2);

// Wieder loeschen der Datei
  System.Assign(f,c2);
  {$I-}
  Erase(f);
  {$I+}
End;

FUNCTION MenuItemFromPoint(ahWnd:HWND;ahMenu:HMENU;CONST ptScreen:POINT):BOOL;
BEGIN
  ASM
    MOV EAX,ptScreen
    PUSH DWORD PTR [EAX+4]
    PUSH DWORD PTR [EAX]
    PUSH DWORD PTR ahMenu
    PUSH DWORD PTR ahWnd
    CALLDLL USER32,'MenuItemFromPoint'
    MOV result,EAX
  END;
END;

FUNCTION DragDetect(p1:HWND;CONST p2:POINT):BOOL;
BEGIN
  ASM
    MOV EAX,p2
    PUSH DWORD PTR [EAX+4]
    PUSH DWORD PTR [EAX]
    PUSH DWORD PTR p1
    CALLDLL USER32,'DragDetect'
    MOV result,EAX
  END;
END;

FUNCTION WindowFromPoint(CONST aPoint:POINT):HWND;
BEGIN
  ASM
    MOV EAX,aPoint
    PUSH DWORD PTR [EAX+4]
    PUSH DWORD PTR [EAX]
    CALLDLL USER32,'WindowFromPoint'
    MOV result,EAX
  END;
END;

FUNCTION ChildWindowFromPoint(hwndParent:HWND;CONST aPoint:POINT):HWND;
BEGIN
  ASM
    MOV EAX,aPoint
    PUSH DWORD PTR [EAX+4]
    PUSH DWORD PTR [EAX]
    PUSH DWORD PTR hwndParent
    CALLDLL USER32,'ChildWindowFromPoint'
    MOV result,EAX
  END
END;

FUNCTION ChildWindowFromPointEx(ahWnd:HWND;CONST aPoint:POINT;Flags:LONGWORD):HWND;
BEGIN
  ASM
    PUSH DWORD PTR Flags
    MOV EAX,aPoint
    PUSH DWORD PTR [EAX+4]
    PUSH DWORD PTR [EAX]
    PUSH DWORD PTR ahwnd
    CALLDLL USER32,'ChildWindowFromPointEx'
    MOV result,EAX
  END
END;

FUNCTION CreateDialog(ahInstance:HINSTANCE;CONST DialogId:CSTRING;
                      hWndParent:HWND;lpDialogFunc:DLGPROC):HWND;
BEGIN
  result:=CreateDialogParam(ahInstance, DialogId,
                             hWndParent, lpDialogFunc, 0);
END;

FUNCTION DialogBox(ahInstance:HINSTANCE;CONST DialogId:CSTRING;hwndParent:HWND;
                   DialogProc:DLGPROC):LONGINT;
BEGIN
  DialogBox:=DialogBoxParam(ahInstance,DialogId,hwndParent,DialogProc,0);
END;

FUNCTION MakeIntResource(i:LONGINT):PChar;
BEGIN
  MakeIntResource:=PChar(i);
END;


FUNCTION MAKEWPARAM(l,h:INTEGER):WPARAM;
BEGIN
  MAKEWPARAM:=MAKELONG(l,h);
END;

FUNCTION MAKELPARAM(l,h:INTEGER):LPARAM;
BEGIN
  MAKELPARAM:=MAKELONG(l,h);
END;

FUNCTION MAKELRESULT(l,h:INTEGER):LRESULT;
BEGIN
  MAKELRESULT:=MAKELONG(l,h);
END;

FUNCTION ExitWindows(dwReserved:ULONG;Code:ULONG):BOOL;
BEGIN
  ExitWindows:=ExitWindowsEx(EWX_LOGOFF,$FFFFFFFF);
END;

FUNCTION CreateWindow(CONST lpClassName,lpWindowName:CSTRING;
                      dwStyle:ULONG;X,Y,nWidth,nHeight:LONGINT;
                      hwndParent:HWND;ahMenu:HMENU;ahInstance:HINSTANCE;
                      VAR lpParam):HWND;

BEGIN
  CreateWindow:=CreateWindowEx(0,lpClassName,lpWindowName,dwStyle,
                                  X,Y,nWidth,nHeight,hwndParent,ahMenu,
                                  ahInstance,lpParam);
END;

FUNCTION PostAppMessage(idThread:ULONG;Msg:ULONG;awParam:WPARAM;alParam:LPARAM):BOOL;
BEGIN
  PostAppMessage:=PostThreadMessage(idThread,Msg,awParam,alParam);
END;

FUNCTION CreateDialogIndirect(ahInstance:HINSTANCE;VAR lpTemplate:DLGTEMPLATE;
                              hwndParent:HWND;lpDialogFunc:DLGPROC):HWND;
BEGIN
  CreateDialogIndirect:=CreateDialogIndirectParam(ahInstance,lpTemplate,
                   hwndParent,lpDialogFunc,0);
END;

FUNCTION DialogBoxIndirect(ahInstance:HINSTANCE;VAR hDialogTemplate:DLGTEMPLATE;
                           hwndParent:HWND;lpDialogFunc:DLGPROC):LONGINT;
BEGIN
  DialogBoxIndirect:=DialogBoxIndirectParam(ahInstance,hDialogTemplate,
                              hwndParent,lpDialogFunc,0);
END;

FUNCTION EnumTaskWindows(dwTaskId:ULONG;lpfn:WNDENUMPROC;alParam:LPARAM):BOOL;
BEGIN
  EnumTaskWindows:=EnumThreadWindows(dwTaskId,lpfn,alParam);
END;

FUNCTION GetSysModalWindow:HWND;
BEGIN
  GetSysModalWindow:=0;
END;

FUNCTION SetSysModalWindow(ahwnd:HWND):HWND;
BEGIN
  SetSysModalWindow:=0;
END;

FUNCTION GetWindowTask(ahwnd:HWND):ULONG;
BEGIN
  GetWindowTask:=GetWindowThreadProcessId(ahwnd,NIL);
END;

FUNCTION DefHookProc(nCode:LONGINT;awParam:WPARAM;alParam:LPARAM;phhk:HHOOK):LRESULT;
BEGIN
  DefHookProc:=CallNextHookEx(phhk,nCode,awParam,alParam);
END;

FUNCTION CopyCursor(ahCursor:HCURSOR):HCURSOR;
BEGIN
  CopyCursor:=CopyIcon(ahCursor);
END;


initialization
  HelpModule_HHCTRL := 0; {Martin}
  dwCookie := 0;          {Martin}
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  06-Aug-04   MV        Def. und Funktionen fuer HTMLHelp eingebaut.
  21-Aug-04   WD        Erweiterung der IDC-Variablen
}



{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit Messages;

Interface

{$IFDEF OS2}
Uses Os2Def;
{$ENDIF}
{$IFDEF Win32}
Uses WinDef,WinNT;
{$ENDIF}

{ Standard Window Messages }

{$IFDEF OS2}
Const
     {Standard messages}
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

     WM_FLASHWND              =$0040;
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
{$ENDIF}

{$IFDEF Win32}
Const
     {Standard Messages}
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

     WM_SPEED_USER                   =$0403;  {use this entry when working with OPML !}
{$ENDIF}

{ Button notification codes }

{$IFDEF OS2}
Const
    BN_CLICKED                 =1;
    BN_DBLCLICKED              =2;
    BN_PAINT                   =3;
{$ENDIF}
{$IFDEF Win32}
Const
    BN_CLICKED          =0;
    BN_PAINT            =1;
    BN_HILITE           =2;
    BN_UNHILITE         =3;
    BN_DISABLE          =4;
    BN_DOUBLECLICKED    =5;
{$ENDIF}

{ Button control messages }

{$IFDEF OS2}
Const
    BM_CLICK                   =$0120;
    BM_QUERYCHECKINDEX         =$0121;
    BM_QUERYHILITE             =$0122;
    BM_SETHILITE               =$0123;
    BM_QUERYCHECK              =$0124;
    BM_SETCHECK                =$0125;
    BM_SETDEFAULT              =$0126;
{$ENDIF}
{$IFDEF Win32}
Const
    BM_GETCHECK        =$00F0;
    BM_SETCHECK        =$00F1;
    BM_GETSTATE        =$00F2;
    BM_SETSTATE        =$00F3;
    BM_SETSTYLE        =$00F4;
{$ENDIF}

{ List box notification messages }

{$IFDEF OS2}
Const
    LN_SELECT                  =1;
    LN_SETFOCUS                =2;
    LN_KILLFOCUS               =3;
    LN_SCROLL                  =4;
    LN_ENTER                   =5;
{$ENDIF}
{$IFDEF Win32}
Const
    LBN_ERRSPACE        =-2;
    LBN_SELCHANGE       =1;
    LBN_DBLCLK          =2;
    LBN_SELCANCEL       =3;
    LBN_SETFOCUS        =4;
    LBN_KILLFOCUS       =5;
{$ENDIF}

{ List box messages }

{$IFDEF OS2}
Const
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
{$ENDIF}
{$IFDEF Win32}
Const
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
{$ENDIF}

{ Combo Box Notification Codes }

{$IFDEF OS2}
Const
    CBN_EFCHANGE               =1;
    CBN_EFSCROLL               =2;
    CBN_MEMERROR               =3;
    CBN_LBSELECT               =4;
    CBN_LBSCROLL               =5;
    CBN_SHOWLIST               =6;
    CBN_ENTER                  =7;
{$ENDIF}
{$IFDEF Win32}
Const
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
{$ENDIF}

{ Combo Box messages }

{$IFDEF OS2}
Const
    CBM_SHOWLIST               =$0170;
    CBM_HILITE                 =$0171;
    CBM_ISLISTSHOWING          =$0172;
{$ENDIF}
{$IFDEF Win32}
Const
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
{$ENDIF}

{ Entry Field notification messages }

{$IFDEF OS2}
Const
    EN_SETFOCUS                =$0001;
    EN_KILLFOCUS               =$0002;
    EN_CHANGE                  =$0004;
    EN_SCROLL                  =$0008;
    EN_MEMERROR                =$0010;
    EN_OVERFLOW                =$0020;
    EN_INSERTMODETOGGLE        =$0040;
{$ENDIF}
{$IFDEF Win32}
Const
     EN_SETFOCUS         =$0100;
     EN_KILLFOCUS        =$0200;
     EN_CHANGE           =$0300;
     EN_UPDATE           =$0400;
     EN_ERRSPACE         =$0500;
     EN_MAXTEXT          =$0501;
     EN_HSCROLL          =$0601;
     EN_VSCROLL          =$0602;
{$ENDIF}

{ Entry Field  messages }

{$IFDEF OS2}
Const
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
{$ENDIF}
{$IFDEF Win32}
Const
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
{$ENDIF}

{ Scroll Bar messages }

{$IFDEF OS2}
Const
   SBM_SETSCROLLBAR           =$01a0;
   SBM_SETPOS                 =$01a1;
   SBM_QUERYPOS               =$01a2;
   SBM_QUERYRANGE             =$01a3;
   SBM_SETTHUMBSIZE           =$01a6;
{$ENDIF}
{$IFDEF Win32}
Const
     SBM_SETPOS                  =$00E0;
     SBM_GETPOS                  =$00E1;
     SBM_SETRANGE                =$00E2;
     SBM_GETRANGE                =$00E3;
     SBM_ENABLE_ARROWS           =$00E4;
     SBM_SETRANGEREDRAW          =$00E6;
     SBM_SETSCROLLINFO           =$00E9;
     SBM_GETSCROLLINFO           =$00EA;
{$ENDIF}

Type
{$M+}
    TCommand           = LongWord;

Const
    {predefined Command Ids}
    cmNull             = TCommand(0);
    cmBase             = $8000;

    cmFile             = TCommand(cmBase+1);
    cmOpen             = TCommand(cmBase+2);
    cmNew              = TCommand(cmBase+3);
    cmSave             = TCommand(cmBase+5);
    cmSaveAs           = TCommand(cmBase+6);
    cmSaveAll          = TCommand(cmBase+7);
    cmPrint            = TCommand(cmBase+8);
    cmExit             = TCommand(cmBase+9);
    cmAbout            = TCommand(cmBase+10);
    cmUndo             = TCommand(cmBase+11);
    cmRedo             = TCommand(cmBase+12);
    cmCut              = TCommand(cmBase+13);
    cmCopy             = TCommand(cmBase+14);
    cmPaste            = TCommand(cmBase+15);
    cmTile             = TCommand(cmBase+16);
    cmCascade          = TCommand(cmBase+17);
    cmCloseAll         = TCommand(cmBase+18);
    cmNext             = TCommand(cmBase+19);
    cmPrevious         = TCommand(cmBase+20);
    cmCloseTop         = TCommand(cmBase+21);
    cmMaximize         = TCommand(cmBase+22);
    cmMinimize         = TCommand(cmBase+23);
    cmRestore          = TCommand(cmBase+24);
    cmFind             = TCommand(cmBase+25);
    cmReplace          = TCommand(cmBase+26);
    cmHelpIndex        = TCommand(cmBase+27);
    cmHelpContents     = TCommand(cmBase+28);
    cmHelpOnHelp       = TCommand(cmBase+29);
    cmKeysHelp         = TCommand(cmBase+30);
    cmTopicSearch      = TCommand(cmBase+31);
    cmChangeDir        = TCommand(cmBase+32);
    cmSearchAgain      = TCommand(cmBase+33);
    cmSelectAll        = TCommand(cmBase+34);
    cmDeselectAll      = TCommand(cmBase+35);
    cmBack             = TCommand(cmBase+36);
    cmForward          = TCommand(cmBase+37);
    cmDelete           = TCommand(cmBase+38);
    cmCreateDir        = TCommand(cmBase+39);
    cmOption           = TCommand(cmBase+40);
    cmEdit             = TCommand(cmBase+41);

    cmOk               = TCommand(cmBase+50);
    cmCancel           = TCommand(cmBase+51);
    cmHelp             = TCommand(cmBase+52);
    cmYes              = TCommand(cmBase+53);
    cmNo               = TCommand(cmBase+54);
    cmClose            = TCommand(cmBase+55);
    cmAbort            = TCommand(cmBase+56);
    cmRetry            = TCommand(cmBase+57);
    cmIgnore           = TCommand(cmBase+58);
    cmAll              = TCommand(cmBase+59);
    cmAccept           = TCommand(cmBase+60);
    cmDiscard          = TCommand(cmBase+61);
    cmDefault          = TCommand(cmBase+62);

    cmUser             = TCommand(cmBase+$1000);
{$M-}

Const
    WM_CAPTUREFOCUS           = WM_USER+1;
    WM_DDE_DESTROY            = WM_USER+2;

    CM_COMMAND                = WM_COMMAND;
    CM_PARENTPENCOLORCHANGED  = cmBase+110;
    CM_PARENTCOLORCHANGED     = cmBase+111;
    CM_PARENTFONTCHANGED      = cmBase+112;
    CM_BUTTONPRESSED          = cmBase+120;
    CM_RELEASE                = cmBase+125;
    CM_TEXTCHANGED            = cmBase+126;
    CM_UPDATEBUTTONS          = cmBase+127;
    CM_ENDMODALSTATE          = cmBase+128;

{ WM_CREATE structure }

{$IFDEF OS2}
Type
    PCREATESTRUCT=^CREATESTRUCT;
    CREATESTRUCT=Record
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
                End;
{$ENDIF}
{$IFDEF Win32}
Type
    PCREATESTRUCT=^CREATESTRUCT;
    CREATESTRUCT=Record
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
    End;
    LPCREATESTRUCT=PCREATESTRUCT;
{$ENDIF}

{ Common message format records }

Type
    {$M+}
    TWMNoParams=Record
    {$M-}
            Msg:LONGWORD;
            ReceiverClass: TObject;
            Receiver: HWND;
            Handled: LONGBOOL;  {True if the message was handled}
            Unused:Array[0..1] Of LONGWORD;
            Result:LONGWORD;
    End;

    {$M+}
    TWMScroll=Record  {WM_HSCROLL,WM_VSCROLL}
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             ScrollBarId:LONGINT;
             Pos:SmallInt;
             ScrollCode:SmallInt;  //SB_xxxx
             {$ENDIF}
             {$IFDEF Win32}
             ScrollCode:SmallInt;  //SB_xxxx
             Pos:SmallInt;
             ScrollBar:HWND;
             {$ENDIF}
             Result: LONGWORD;
    End;

Type
    {$M+}
    TWMActivate=Record  {WM_ACTIVATE}
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             Active:WordBool;
             Unused:WORD;
             ActiveWindow:HWND;
             {$ENDIF}
             {$IFDEF Win32}
             Active:Word;    //WA_INACTIVE, WA_ACTIVE, WA_CLICKACTIVE
             Minimized:WordBool;
             ActiveWindow:HWND;
             {$ENDIF}
             Result: LONGWORD;
    End;

Type
    {$M+}
    TWMCommand=Record  {WM_COMMAND}
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             ItemID:WORD;
             Unused:WORD;
             NotifyCode:WORD;  //CMDSRC_xxx
             Pointer:WordBool;
             {$ENDIF}
             {$IFDEF Win32}
             ItemID:WORD;
             NotifyCode:WORD;
             Ctl:HWND;
             {$ENDIF}
             Result: LONGWORD;
    End;

Type
    {$M+}
    TWMCreate=Record  {WM_CREATE}
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             CtlData:POINTER;
             CreateStruct:PCreateStruct;
             {$ENDIF}
             {$IFDEF Win32}
             Unused:LONGINT;
             CreateStruct:PCreateStruct;
             {$ENDIF}
             Result: LONGWORD;
    End;


Type
    {$M+}
    TWMMouse=Record
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             XPos:SmallInt;
             YPos:SmallInt;
             HitTest:WORD;
             Keys:WORD;
             {$ENDIF}
             {$IFDEF Win32}
             Keys:LONGINT;
             XPos:SmallInt;
             YPos:SmallInt;
             {$ENDIF}
             Result: LONGWORD;
    End;

    TWMLButtonDblClk = TWMMouse;
    TWMLButtonDown   = TWMMouse;
    TWMLButtonUp     = TWMMouse;
    TWMMButtonDblClk = TWMMouse;
    TWMMButtonDown   = TWMMouse;
    TWMMButtonUp     = TWMMouse;
    TWMRButtonDblClk = TWMMouse;
    TWMRButtonDown   = TWMMouse;
    TWMRButtonUp     = TWMMouse;
    TWMButton1Click  = TWMMouse;
    TWMButton1DblClk = TWMMouse;
    TWMButton1Down   = TWMMouse;
    TWMButton1Up     = TWMMouse;
    TWMButton3Click  = TWMMouse;
    TWMButton3DblClk = TWMMouse;
    TWMButton3Down   = TWMMouse;
    TWMButton3Up     = TWMMouse;
    TWMButton2Click  = TWMMouse;
    TWMButton2DblClk = TWMMouse;
    TWMButton2Down   = TWMMouse;
    TWMButton2Up     = TWMMouse;
    TWMMouseMove     = TWMMouse;

Type
    {$M+}
    TWMKey=Record
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             KeyData:WORD;
             RepeatCount:BYTE;
             ScanCode:BYTE;
             CharCode:WORD;
             VirtualKeyCode:WORD;
             {$ENDIF}
             {$IFDEF Win32}
             CharCode:WORD;
             Unused:WORD;
             KeyData:LONGINT;
             {$ENDIF}
             Result: LONGWORD;
    End;

    TWMChar=TWMKey;

    TWMClose   = TWMNoParams;
    TWMDestroy = TWMNoParams;

Type
    {$M+}
    TWMSetFocus=Record
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             FocusedWnd:HWND;
             Focus:WordBool;
             Unused:WORD;
             {$ENDIF}
             {$IFDEF Win32}
             FocusedWnd:HWND;
             Unused:LONGWORD;
             {$ENDIF}
             Result: LONGWORD;
    End;

Type
    {$M+}
    TWMSize=Record
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             OldWidth:SmallInt;
             OldHeight:SmallInt;
             Width:SmallInt;
             Height:SmallInt;
             {$ENDIF}
             {$IFDEF Win32}
             SizeType:LONGINT; { SIZE_MAXIMIZED, SIZE_MINIMIZED, SIZE_RESTORED,
                                 SIZE_MAXHIDE, SIZE_MAXSHOW }
             Width:SmallInt;
             Height:SmallInt;
             {$ENDIF}
             Result: LONGWORD;
    End;

Type
    {$M+}
    TWMMove=Record
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             Unused:Array[0..1] Of LONGWORD;
             {$ENDIF}
             {$IFDEF Win32}
             Unused:LONGINT;
             XPos:SmallInt;
             YPos:SmallInt;
             {$ENDIF}
             Result: LONGWORD;
    End;

Type
    {$M+}
    TWMTimer=Record
    {$M-}
             Msg:LONGWORD;
             ReceiverClass: TObject;
             Receiver: HWND;
             Handled: LONGBOOL;  {True if the message was handled}
             {$IFDEF OS2}
             TimerID:WORD;
             Unused:Array[0..2] Of WORD;
             {$ENDIF}
             {$IFDEF Win32}
             TimerID:LONGINT;
             Unused:LONGWORD;
             {$ENDIF}
             Result: LONGWORD;
    End;

Function ConvertLongFrom2Short(s1,s2:SmallInt):LongInt;
Procedure ConvertShort2FromLong(l:LongInt;Var s1,s2:SmallInt);

Implementation

Function ConvertLongFrom2Short(s1,s2:SmallInt):LongInt;
Begin
     Result:=s1;
     Result:=(Result shl 16)Or(Word(s2) And 65535);
End;

Procedure ConvertShort2FromLong(l:LongInt;Var s1,s2:SmallInt);
Begin
     s1:=l shr 16;
     s2:=LongWord(l) And 65535;
End;

End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-02   WD        Ausbau der LINUX-Teile
  01-Mar-03   WD        Message "cmOption" eingebaut
  05-Mai-08   WD        Message "cmEdit" eingebaut.

}
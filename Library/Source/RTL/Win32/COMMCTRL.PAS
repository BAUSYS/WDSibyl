
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT CommCtrl;

INTERFACE

USES WinBase,WinDef,WinNT,WinUser;

CONST
     WM_NOTIFY              =$004E;


CONST
    ODT_HEADER              =100;
    ODT_TAB                 =101;
    ODT_LISTVIEW            =102;

    LVM_FIRST               =$1000;
    TV_FIRST                =$1100;
    HDM_FIRST               =$1200;

    NM_FIRST                =0;
    NM_OUTOFMEMORY          =NM_FIRST-1;
    NM_CLICK                =NM_FIRST-2;
    NM_DBLCLK               =NM_FIRST-3;
    NM_RETURN               =NM_FIRST-4;
    NM_RCLICK               =NM_FIRST-5;
    NM_RDBLCLK              =NM_FIRST-6;
    NM_SETFOCUS             =NM_FIRST-7;
    NM_KILLFOCUS            =NM_FIRST-8;

    NM_LAST                 =-99;

    LVN_FIRST               =-100;
    LVN_LAST                =-199;

    HDN_FIRST               =-300;
    HDN_LAST                =-399;

    TVN_FIRST               =-400;
    TVN_LAST                =-499;

    TTN_FIRST               =-520;
    TTN_LAST                =-549;

    TCN_FIRST               =-550;
    TCN_LAST                =-580;

    CDN_FIRST               =-601;
    CDN_LAST                =-699;

    TBN_FIRST               =-700;
    TBN_LAST                =-720;

    UDN_FIRST               =-721;
    UDN_LAST                =-740;

CONST
     MSGF_COMMCTRL_BEGINDRAG     =$4200;
     MSGF_COMMCTRL_SIZEHEADER    =$4201;
     MSGF_COMMCTRL_DRAGSELECT    =$4202;
     MSGF_COMMCTRL_TOOLBARCUST   =$4203;

     CLR_NONE                =$FFFFFFFF;
     CLR_DEFAULT             =$FF000000;

TYPE
    HIMAGELIST=^IMAGELIST;
    IMAGELIST=RECORD
              END;

CONST
     ILC_MASK                =$0001;
     ILC_COLOR               =$0000;
     ILC_COLORDDB            =$00FE;
     ILC_COLOR4              =$0004;
     ILC_COLOR8              =$0008;
     ILC_COLOR16             =$0010;
     ILC_COLOR24             =$0018;
     ILC_COLOR32             =$0020;
     ILC_PALETTE             =$0800;

     ILD_NORMAL              =$0000;
     ILD_TRANSPARENT         =$0001;
     ILD_MASK                =$0010;
     ILD_IMAGE               =$0020;
     ILD_BLEND25             =$0002;
     ILD_BLEND50             =$0004;
     ILD_OVERLAYMASK         =$0F00;

     ILD_SELECTED            =ILD_BLEND50;
     ILD_FOCUS               =ILD_BLEND25;
     ILD_BLEND               =ILD_BLEND50;
     CLR_HILIGHT             =CLR_DEFAULT;

TYPE
    IMAGEINFO=RECORD
                    hbmImage:HBITMAP;
                    hbmMask:HBITMAP;
                    Unused1:LONGINT;
                    Unused2:LONGINT;
                    rcImage:RECT;
              END;

CONST
     WC_HEADER    ='SysHeader32';

CONST
     HDS_HORZ                =$00000000;
     HDS_BUTTONS             =$00000002;
     HDS_HIDDEN              =$00000008;

TYPE HD_ITEM=RECORD
                   mask:LONGWORD;
                   cxy:LONGINT;
                   pszText:PChar;
                   hbm:HBITMAP;
                   cchTextMax:LONGINT;
                   fmt:LONGINT;
                   lParam:LPARAM;
             END;

CONST
     HDI_WIDTH               =$0001;
     HDI_HEIGHT              =HDI_WIDTH;
     HDI_TEXT                =$0002;
     HDI_FORMAT              =$0004;
     HDI_LPARAM              =$0008;
     HDI_BITMAP              =$0010;

     HDF_LEFT                =0;
     HDF_RIGHT               =1;
     HDF_CENTER              =2;
     HDF_JUSTIFYMASK         =3;
     HDF_RTLREADING          =4;

     HDF_OWNERDRAW           =$8000;
     HDF_STRING              =$4000;
     HDF_BITMAP              =$2000;

     HDM_GETITEMCOUNT        =HDM_FIRST + 0;
     HDM_INSERTITEM          =HDM_FIRST + 1;
     HDM_GETITEM             =HDM_FIRST + 3;
     HDM_SETITEM             =HDM_FIRST + 4;

TYPE
    HD_LAYOUT=RECORD
                    prc:PRECT;
                    pwpos:PWINDOWPOS;
    END;

CONST
     HDM_LAYOUT              =HDM_FIRST + 5;

     HHT_NOWHERE             =$0001;
     HHT_ONHEADER            =$0002;
     HHT_ONDIVIDER           =$0004;
     HHT_ONDIVOPEN           =$0008;
     HHT_ABOVE               =$0100;
     HHT_BELOW               =$0200;
     HHT_TORIGHT             =$0400;
     HHT_TOLEFT              =$0800;


TYPE
    HD_HITTESTINFO=RECORD
                         pt:POINT;
                         flags:LONGWORD;
                         iItem:LONGINT;
    END;

CONST
     HDM_HITTEST            =HDM_FIRST + 6;

     HDN_ITEMCHANGING       =HDN_FIRST-0;
     HDN_ITEMCHANGED        =HDN_FIRST-1;
     HDN_ITEMCLICK          =HDN_FIRST-2;
     HDN_ITEMDBLCLICK       =HDN_FIRST-3;
     HDN_DIVIDERDBLCLICK    =HDN_FIRST-5;
     HDN_BEGINTRACK         =HDN_FIRST-6;
     HDN_ENDTRACK           =HDN_FIRST-7;
     HDN_TRACK              =HDN_FIRST-8;

TYPE
    HD_NOTIFY=RECORD
                    hrr:NMHDR;
                    iItem:LONGINT;
                    iButton:LONGINT;
                    pitem:^HD_ITEM;
    END;


CONST
     TOOLBARCLASSNAMEA       ='ToolbarWindow32';

TYPE
    PTBBUTTON=^TBBUTTON;
    TBBUTTON=RECORD
                   iBitmap:LONGINT;
                   idCommand:LONGINT;
                   fsState:BYTE;
                   fsStyle:BYTE;
                   bReserved:ARRAY[0..1] OF BYTE;
                   dwData:LONGWORD;
                   iString:LONGINT;
    END;

    PCOLORMAP=^COLORMAP;
    COLORMAP=RECORD
                   from:COLORREF;
                   ato:COLORREF;
    END;

CONST
     CMB_MASKED              =$02;

     TBSTATE_CHECKED         =$01;
     TBSTATE_PRESSED         =$02;
     TBSTATE_ENABLED         =$04;
     TBSTATE_HIDDEN          =$08;
     TBSTATE_INDETERMINATE   =$10;
     TBSTATE_WRAP            =$20;

     TBSTYLE_BUTTON          =$00;
     TBSTYLE_SEP             =$01;
     TBSTYLE_CHECK           =$02;
     TBSTYLE_GROUP           =$04;
     TBSTYLE_CHECKGROUP      =TBSTYLE_GROUP OR TBSTYLE_CHECK;

     TBSTYLE_TOOLTIPS        =$0100;
     TBSTYLE_WRAPABLE        =$0200;
     TBSTYLE_ALTDRAG         =$0400;

     TB_ENABLEBUTTON         =WM_USER + 1;
     TB_CHECKBUTTON          =WM_USER + 2;
     TB_PRESSBUTTON          =WM_USER + 3;
     TB_HIDEBUTTON           =WM_USER + 4;
     TB_INDETERMINATE        =WM_USER + 5;
     TB_ISBUTTONENABLED      =WM_USER + 9;
     TB_ISBUTTONCHECKED      =WM_USER + 10;
     TB_ISBUTTONPRESSED      =WM_USER + 11;
     TB_ISBUTTONHIDDEN       =WM_USER + 12;
     TB_ISBUTTONINDETERMINATE=WM_USER + 13;
     TB_SETSTATE             =WM_USER + 17;
     TB_GETSTATE             =WM_USER + 18;
     TB_ADDBITMAP            =WM_USER + 19;

TYPE
    PTBADDBITMAP=^TBADDBITMAP;
    TBADDBITMAP=RECORD
                      hInst:HINSTANCE;
                      nID:LONGWORD;
    END;

CONST
     IDB_STD_SMALL_COLOR     =0;
     IDB_STD_LARGE_COLOR     =1;
     IDB_VIEW_SMALL_COLOR    =4;
     IDB_VIEW_LARGE_COLOR    =5;

     STD_CUT                 =0;
     STD_COPY                =1;
     STD_PASTE               =2;
     STD_UNDO                =3;
     STD_REDOW               =4;
     STD_DELETE              =5;
     STD_FILENEW             =6;
     STD_FILEOPEN            =7;
     STD_FILESAVE            =8;
     STD_PRINTPRE            =9;
     STD_PROPERTIES          =10;
     STD_HELP                =11;
     STD_FIND                =12;
     STD_REPLACE             =13;
     STD_PRINT               =14;

     VIEW_LARGEICONS         =0;
     VIEW_SMALLICONS         =1;
     VIEW_LIST               =2;
     VIEW_DETAILS            =3;
     VIEW_SORTNAME           =4;
     VIEW_SORTSIZE           =5;
     VIEW_SORTDATE           =6;
     VIEW_SORTTYPE           =7;
     VIEW_PARENTFOLDER       =8;
     VIEW_NETCONNECT         =9;
     VIEW_NETDISCONNECT      =10;
     VIEW_NEWFOLDER          =11;

     TB_ADDBUTTONS           =WM_USER + 20;
     TB_INSERTBUTTON         =WM_USER + 21;
     TB_DELETEBUTTON         =WM_USER + 22;
     TB_GETBUTTON            =WM_USER + 23;
     TB_BUTTONCOUNT          =WM_USER + 24;
     TB_COMMANDTOINDEX       =WM_USER + 25;

TYPE
    HKEY=HANDLE;

TYPE TBSAVEPARAMS=RECORD
                        hkr:HKEY;
                        pszSubKey:PChar;
                        pszValueName:PChar;
                  END;

CONST
     TB_SAVERESTOREA         =WM_USER + 26;
     TB_SAVERESTOREW         =WM_USER + 76;
     TB_CUSTOMIZE            =WM_USER + 27;
     TB_ADDSTRINGA           =WM_USER + 28;
     TB_ADDSTRINGW           =WM_USER + 77;
     TB_GETITEMRECT          =WM_USER + 29;
     TB_BUTTONSTRUCTSIZE     =WM_USER + 30;
     TB_SETBUTTONSIZE        =WM_USER + 31;
     TB_SETBITMAPSIZE        =WM_USER + 32;
     TB_AUTOSIZE             =WM_USER + 33;
     TB_GETTOOLTIPS          =WM_USER + 35;
     TB_SETTOOLTIPS          =WM_USER + 36;
     TB_SETPARENT            =WM_USER + 37;
     TB_SETROWS              =WM_USER + 39;
     TB_GETROWS              =WM_USER + 40;
     TB_SETCMDID             =WM_USER + 42;
     TB_CHANGEBITMAP         =WM_USER + 43;
     TB_GETBITMAP            =WM_USER + 44;
     TB_GETBUTTONTEXTA       =WM_USER + 45;
     TB_GETBUTTONTEXTW       =WM_USER + 75;
     TB_REPLACEBITMAP        =WM_USER + 46;

     TB_GETBUTTONTEXT        =TB_GETBUTTONTEXTA;
     TB_SAVERESTORE          =TB_SAVERESTOREA;
     TB_ADDSTRING            =TB_ADDSTRINGA;

TYPE LPTBREPLACEBITMAP=^TBREPLACEBITMAP;
     TBREPLACEBITMAP=RECORD
                           hInstOld:HINSTANCE;
                           nIDOld:LONGWORD;
                           hInstNew:HINSTANCE;
                           nIDNew:LONGWORD;
                           nButtons:LONGINT;
     END;

CONST
    TBBF_LARGE              =$0001;

    TB_GETBITMAPFLAGS       =(WM_USER + 41);

    TBN_GETBUTTONINFOA      =(TBN_FIRST-0);
    TBN_GETBUTTONINFOW      =(TBN_FIRST-20);
    TBN_BEGINDRAG           =(TBN_FIRST-1);
    TBN_ENDDRAG             =(TBN_FIRST-2);
    TBN_BEGINADJUST         =(TBN_FIRST-3);
    TBN_ENDADJUST           =(TBN_FIRST-4);
    TBN_RESET               =(TBN_FIRST-5);
    TBN_QUERYINSERT         =(TBN_FIRST-6);
    TBN_QUERYDELETE         =(TBN_FIRST-7);
    TBN_TOOLBARCHANGE       =(TBN_FIRST-8);
    TBN_CUSTHELP            =(TBN_FIRST-9);

    TBN_GETBUTTONINFO       =TBN_GETBUTTONINFOA;

TYPE
    LPTBNOTIFYA=^TBNOTIFYA;
    TBNOTIFYA=RECORD
                    hdr:NMHDR;
                    iItem:LONGINT;
                    tbButton:TBBUTTON;
                    cchText:LONGINT;
                    pszText:PChar;
     END;


     TBNOTIFY=TBNOTIFYA;
     LPTBNOTIFY=LPTBNOTIFYA;

CONST
     TOOLTIPS_CLASSW         ='tooltips_class32';
     TOOLTIPS_CLASSA         ='tooltips_class32';

     TOOLTIPS_CLASS          =TOOLTIPS_CLASSA;

TYPE
     PTOOLINFOA=^TOOLINFOA;
     TOOLINFOA=RECORD
                     cbSize:LONGWORD;
                     uFlags:LONGWORD;
                     hwnd:HWND;
                     uId:LONGWORD;
                     rect:RECT;
                     hinst:HINSTANCE;
                     lpszText:PChar;
     END;

     TOOLINFO=TOOLINFOA;
     PTOOLINFO=PTOOLINFOA;

CONST
   TTS_ALWAYSTIP           =$01;
   TTS_NOPREFIX            =$02;

   TTF_IDISHWND            =$01;
   TTF_CENTERTIP           =$02;
   TTF_RTLREADING          =$04;
   TTF_SUBCLASS            =$10;

   TTDT_AUTOMATIC          =0;
   TTDT_RESHOW             =1;
   TTDT_AUTOPOP            =2;
   TTDT_INITIAL            =3;

   TTM_ACTIVATE            =(WM_USER + 1);
   TTM_SETDELAYTIME        =(WM_USER + 3);
   TTM_ADDTOOLA            =(WM_USER + 4);
   TTM_ADDTOOLW            =(WM_USER + 50);
   TTM_DELTOOLA            =(WM_USER + 5);
   TTM_DELTOOLW            =(WM_USER + 51);
   TTM_NEWTOOLRECTA        =(WM_USER + 6);
   TTM_NEWTOOLRECTW        =(WM_USER + 52);
   TTM_RELAYEVENT          =(WM_USER + 7);

   TTM_GETTOOLINFOA        =(WM_USER + 8);
   TTM_GETTOOLINFOW        =(WM_USER + 53);

   TTM_SETTOOLINFOA        =(WM_USER + 9);
   TTM_SETTOOLINFOW        =(WM_USER + 54);

   TTM_HITTESTA            =(WM_USER +10);
   TTM_HITTESTW            =(WM_USER +55);
   TTM_GETTEXTA            =(WM_USER +11);
   TTM_GETTEXTW            =(WM_USER +56);
   TTM_UPDATETIPTEXTA      =(WM_USER +12);
   TTM_UPDATETIPTEXTW      =(WM_USER +57);
   TTM_GETTOOLCOUNT        =(WM_USER +13);
   TTM_ENUMTOOLSA          =(WM_USER +14);
   TTM_ENUMTOOLSW          =(WM_USER +58);
   TTM_GETCURRENTTOOLA     =(WM_USER + 15);
   TTM_GETCURRENTTOOLW     =(WM_USER + 59);
   TTM_WINDOWFROMPOINT     =(WM_USER + 16);

   TTM_ADDTOOL             =TTM_ADDTOOLA;
   TTM_DELTOOL             =TTM_DELTOOLA;
   TTM_NEWTOOLRECT         =TTM_NEWTOOLRECTA;
   TTM_GETTOOLINFO         =TTM_GETTOOLINFOA;
   TTM_SETTOOLINFO         =TTM_SETTOOLINFOA;
   TTM_HITTEST             =TTM_HITTESTA;
   TTM_GETTEXT             =TTM_GETTEXTA;
   TTM_UPDATETIPTEXT       =TTM_UPDATETIPTEXTA;
   TTM_ENUMTOOLS           =TTM_ENUMTOOLSA;
   TTM_GETCURRENTTOOL      =TTM_GETCURRENTTOOLA;

CONST
     CCS_TOP                 =$00000001;
     CCS_NOMOVEY             =$00000002;
     CCS_BOTTOM              =$00000003;
     CCS_NORESIZE            =$00000004;
     CCS_NOPARENTALIGN       =$00000008;
     CCS_ADJUSTABLE          =$00000020;
     CCS_NODIVIDER           =$00000040;

CONST
     WC_LISTVIEW             ='SysListView32';

CONST
     LVS_ICON                =$0000;
     LVS_REPORT              =$0001;
     LVS_SMALLICON           =$0002;
     LVS_LIST                =$0003;
     LVS_TYPEMASK            =$0003;
     LVS_SINGLESEL           =$0004;
     LVS_SHOWSELALWAYS       =$0008;
     LVS_SORTASCENDING       =$0010;
     LVS_SORTDESCENDING      =$0020;
     LVS_SHAREIMAGELISTS     =$0040;
     LVS_NOLABELWRAP         =$0080;
     LVS_AUTOARRANGE         =$0100;
     LVS_EDITLABELS          =$0200;
     LVS_NOSCROLL            =$2000;
     LVS_TYPESTYLEMASK       =$fc00;
     LVS_ALIGNTOP            =$0000;
     LVS_ALIGNLEFT           =$0800;
     LVS_ALIGNMASK           =$0c00;
     LVS_OWNERDRAWFIXED      =$0400;
     LVS_NOCOLUMNHEADER      =$4000;
     LVS_NOSORTHEADER        =$8000;
     LVM_GETBKCOLOR          =LVM_FIRST + 0;
     LVM_GETIMAGELIST        =LVM_FIRST + 2;

     LVSIL_NORMAL            =0;
     LVSIL_SMALL             =1;
     LVSIL_STATE             =2;

     LVM_SETIMAGELIST        =LVM_FIRST + 3;
     LVM_GETITEMCOUNT        =LVM_FIRST + 4;

     LVIF_TEXT               =$0001;
     LVIF_IMAGE              =$0002;
     LVIF_PARAM              =$0004;
     LVIF_STATE              =$0008;

     LVIS_FOCUSED            =$0001;
     LVIS_SELECTED           =$0002;
     LVIS_CUT                =$0004;
     LVIS_DROPHILITED        =$0008;
     LVIS_OVERLAYMASK        =$0F00;
     LVIS_STATEIMAGEMASK     =$F000;


TYPE
    LV_ITEM=RECORD
                  mask:LONGWORD;
                  iItem:LONGINT;
                  iSubItem:LONGINT;
                  state:LONGWORD;
                  stateMask:LONGWORD;
                  pszText:PChar;
                  cchTextMax:LONGINT;
                  iImage:LONGINT;
                  lParam:LPARAM;
    END;


CONST
     I_IMAGECALLBACK         =-1;

     LVM_GETITEM             =LVM_FIRST + 5;
     LVM_SETITEM             =LVM_FIRST + 6;
     LVM_INSERTITEM          =LVM_FIRST + 7;
     LVM_DELETEITEM          =LVM_FIRST + 8;
     LVM_DELETEALLITEMS      =LVM_FIRST + 9;
     LVM_GETCALLBACKMASK     =LVM_FIRST + 10;
     LVM_SETCALLBACKMASK     =LVM_FIRST + 11;
     LVM_GETNEXTITEM         =LVM_FIRST + 12;
     LVM_FINDITEMA           =LVM_FIRST + 13;

     LVNI_ALL                =$0000;
     LVNI_FOCUSED            =$0001;
     LVNI_SELECTED           =$0002;
     LVNI_CUT                =$0004;
     LVNI_DROPHILITED        =$0008;
     LVNI_ABOVE              =$0100;
     LVNI_BELOW              =$0200;
     LVNI_TOLEFT             =$0400;
     LVNI_TORIGHT            =$0800;

     LVFI_PARAM              =$0001;
     LVFI_STRING             =$0002;
     LVFI_PARTIAL            =$0008;
     LVFI_WRAP               =$0020;
     LVFI_NEARESTXY          =$0040;

TYPE LV_FINDINFO=RECORD
                       flags:LONGWORD;
                       psz:PChar;
                       lParam:LPARAM;
                       pt:POINT;
                       vkDirection:LONGWORD;
     END;

CONST
     LVIR_BOUNDS             =0;
     LVIR_ICON               =1;
     LVIR_LABEL              =2;
     LVIR_SELECTBOUNDS       =3;

     LVM_GETITEMRECT         =LVM_FIRST + 14;
     LVM_SETITEMPOSITION     =LVM_FIRST + 15;
     LVM_GETITEMPOSITION     =LVM_FIRST + 16;
     LVM_GETSTRINGWIDTHA     =LVM_FIRST + 17;

CONST
     LVHT_NOWHERE            =$0001;
     LVHT_ONITEMICON         =$0002;
     LVHT_ONITEMLABEL        =$0004;
     LVHT_ONITEMSTATEICON    =$0008;
     LVHT_ONITEM             =LVHT_ONITEMICON OR LVHT_ONITEMLABEL OR LVHT_ONITEMSTATEICON;
     LVHT_ABOVE              =$0008;
     LVHT_BELOW              =$0010;
     LVHT_TORIGHT            =$0020;
     LVHT_TOLEFT             =$0040;

TYPE
    LV_HITTESTINFO=RECORD
                         pt:POINT;
                         flags:LONGWORD;
                         iItem:LONGINT;
    END;

CONST
     LVM_HITTEST             =LVM_FIRST + 18;
     LVM_ENSUREVISIBLE       =LVM_FIRST + 19;
     LVM_SCROLL              =LVM_FIRST + 20;
     LVM_REDRAWITEMS         =LVM_FIRST + 21;
     LVM_ARRANGE             =LVM_FIRST + 22;
     LVM_EDITLABEL           =LVM_FIRST + 23;
     LVM_GETEDITCONTROL      =LVM_FIRST + 24;
     LVM_INSERTCOLUMN        =LVM_FIRST + 27;
     LVM_DELETECOLUMN        =LVM_FIRST + 28;
     LVM_GETCOLUMNWIDTH      =LVM_FIRST + 29;
     LVM_SETCOLUMNWIDTH      =LVM_FIRST + 30;
     LVM_CREATEDRAGIMAGE     =LVM_FIRST + 33;
     LVM_GETVIEWRECT         =LVM_FIRST + 34;
     LVM_GETTEXTCOLOR        =LVM_FIRST + 35;
     LVM_SETTEXTCOLOR        =LVM_FIRST + 36;
     LVM_GETTEXTBKCOLOR      =LVM_FIRST + 37;
     LVM_SETTEXTBKCOLOR      =LVM_FIRST + 38;
     LVM_GETTOPINDEX         =LVM_FIRST + 39;
     LVM_GETCOUNTPERPAGE     =LVM_FIRST + 40;
     LVM_GETORIGIN           =LVM_FIRST + 41;
     LVM_UPDATE              =LVM_FIRST + 42;
     LVM_SETITEMSTATE        =LVM_FIRST + 43;
     LVM_GETITEMSTATE        =LVM_FIRST + 44;

     LVA_DEFAULT             =$0000;
     LVA_ALIGNLEFT           =$0001;
     LVA_ALIGNTOP            =$0002;
     LVA_SNAPTOGRID          =$0005;

TYPE
    LV_COLUMN=RECORD
                    mask:LONGWORD;
                    fmt:LONGINT;
                    cx:LONGINT;
                    pszText:PChar;
                    cchTextMax:LONGINT;
                    iSubItem:LONGINT;
    END;

CONST
     LVCF_FMT                =$0001;
     LVCF_WIDTH              =$0002;
     LVCF_TEXT               =$0004;
     LVCF_SUBITEM            =$0008;

     LVCFMT_LEFT             =$0000;
     LVCFMT_RIGHT            =$0001;
     LVCFMT_CENTER           =$0002;
     LVCFMT_JUSTIFYMASK      =$0003;

CONST
     WC_TREEVIEW                ='SysTreeView32';

CONST
     TVS_HASBUTTONS          =$0001;
     TVS_HASLINES            =$0002;
     TVS_LINESATROOT         =$0004;
     TVS_EDITLABELS          =$0008;
     TVS_DISABLEDRAGDROP     =$0010;
     TVS_SHOWSELALWAYS       =$0020;

TYPE
    HTREEITEM=^TREEITEM;
    TREEITEM=RECORD
    END;

CONST
     TVIF_TEXT               =$0001;
     TVIF_IMAGE              =$0002;
     TVIF_PARAM              =$0004;
     TVIF_STATE              =$0008;
     TVIF_HANDLE             =$0010;
     TVIF_SELECTEDIMAGE      =$0020;
     TVIF_CHILDREN           =$0040;

     TVIS_FOCUSED            =$0001;
     TVIS_SELECTED           =$0002;
     TVIS_CUT                =$0004;
     TVIS_DROPHILITED        =$0008;
     TVIS_BOLD               =$0010;
     TVIS_EXPANDED           =$0020;
     TVIS_EXPANDEDONCE       =$0040;
     TVIS_OVERLAYMASK        =$0F00;
     TVIS_STATEIMAGEMASK     =$F000;
     TVIS_USERMASK           =$F000;

     I_CHILDRENCALLBACK      =-1;

TYPE
    PTV_ITEM=^TV_ITEM;
    TV_ITEM=RECORD
                  mask:LONGWORD;
                  hItem:HTREEITEM;
                  state:LONGWORD;
                  stateMask:LONGWORD;
                  pszText:PChar;
                  cchTextMax:LONGINT;
                  iImage:LONGINT;
                  iSelectedImage:LONGINT;
                  cChildren:LONGINT;
                  lParam:LPARAM;
     END;

CONST
     TVI_ROOT                =HTREEITEM($FFFF0000);
     TVI_FIRST               =HTREEITEM($FFFF0001);
     TVI_LAST                =HTREEITEM($FFFF0002);
     TVI_SORT                =HTREEITEM($FFFF0003);

TYPE
    PTV_INSERTSTRUCT=^TV_INSERTSTRUCT;
    TV_INSERTSTRUCT=RECORD
                          hParent:HTREEITEM;
                          hInsertAfter:HTREEITEM;
                          item:TV_ITEM;
    END;

CONST
     TVM_INSERTITEM       =TV_FIRST + 0;
     TVM_DELETEITEM       =TV_FIRST + 1;
     TVM_EXPAND           =TV_FIRST + 2;
     TVM_GETITEMRECT      =TV_FIRST + 4;
     TVM_GETCOUNT         =TV_FIRST + 5;
     TVM_GETINDENT        =TV_FIRST + 6;
     TVM_SETINDENT        =TV_FIRST + 7;
     TVM_GETIMAGELIST     =TV_FIRST + 8;
     TVM_SETIMAGELIST     =TV_FIRST + 9;
     TVM_GETNEXTITEM      =TV_FIRST + 10;
     TVM_SELECTITEM       =TV_FIRST + 11;
     TVM_GETITEM          =TV_FIRST + 12;
     TVM_SETITEM          =TV_FIRST + 13;
     TVM_EDITLABELA       =TV_FIRST + 14;
     TVM_GETEDITCONTROL   =TV_FIRST + 15;
     TVM_GETVISIBLECOUNT  =TV_FIRST + 16;
     TVM_HITTEST          =TV_FIRST + 17;
     TVM_CREATEDRAGIMAGE  =TV_FIRST + 18;
     TVM_SORTCHILDREN     =TV_FIRST + 19;
     TVM_ENSUREVISIBLE    =TV_FIRST + 20;
     TVM_SORTCHILDRENCB   =TV_FIRST + 21;
     TVM_ENDEDITLABELNOW  =TV_FIRST + 22;
     TVM_GETISEARCHSTRING =TV_FIRST + 23;

     TVE_COLLAPSE            =$0001;
     TVE_EXPAND              =$0002;
     TVE_TOGGLE              =$0003;
     TVE_COLLAPSERESET       =$8000;

     TVSIL_NORMAL            =0;
     TVSIL_STATE             =2;

     TVGN_ROOT               =$0000;
     TVGN_NEXT               =$0001;
     TVGN_PREVIOUS           =$0002;
     TVGN_PARENT             =$0003;
     TVGN_CHILD              =$0004;
     TVGN_FIRSTVISIBLE       =$0005;
     TVGN_NEXTVISIBLE        =$0006;
     TVGN_PREVIOUSVISIBLE    =$0007;
     TVGN_DROPHILITE         =$0008;
     TVGN_CARET              =$0009;

TYPE
    PTV_HITTESTINFO=^TV_HITTESTINFO;
    TV_HITTESTINFO=RECORD
                         pt:POINT;
                         flags:LONGWORD;
                         hItem:HTREEITEM;
    END;

CONST
     TVHT_NOWHERE            =$0001;
     TVHT_ONITEMICON         =$0002;
     TVHT_ONITEMLABEL        =$0004;
     TVHT_ONITEMINDENT       =$0008;
     TVHT_ONITEMBUTTON       =$0010;
     TVHT_ONITEMRIGHT        =$0020;
     TVHT_ONITEMSTATEICON    =$0040;
     TVHT_ABOVE              =$0100;
     TVHT_BELOW              =$0200;
     TVHT_TORIGHT            =$0400;
     TVHT_TOLEFT             =$0800;
     TVHT_ONITEM             =TVHT_ONITEMICON OR TVHT_ONITEMLABEL OR TVHT_ONITEMSTATEICON;

TYPE
    PFNTVCOMPARE=FUNCTION(lParam1,lParam2,lParamSort:LPARAM):LONGINT;APIENTRY;

TYPE
    PTV_SORTCB=^TV_SORTCB;
    TV_SORTCB=RECORD
                    hParent:HTREEITEM;
                    lpfnCompare:PFNTVCOMPARE;
                    lParam:LPARAM;
    END;

    PNM_TREEVIEW=^NM_TREEVIEW;
    NM_TREEVIEW=RECORD
                      hdr:NMHDR;
                      action:LONGWORD;
                      itemOld:TV_ITEM;
                      itemNew:TV_ITEM;
                      ptDrag:POINT;
    END;

CONST
     TVN_SELCHANGING        =TVN_FIRST-1;
     TVN_SELCHANGED         =TVN_FIRST-2;

     TVC_UNKNOWN             =$0000;
     TVC_BYMOUSE             =$0001;
     TVC_BYKEYBOARD          =$0002;

     TVN_GETDISPINFO         =TVN_FIRST-3;
     TVN_SETDISPINFO         =TVN_FIRST-4;

     TVIF_DI_SETITEM         =$1000;

TYPE
    TV_DISPINFO=RECORD
                      hdr:NMHDR;
                      item:TV_ITEM;
    END;

CONST
     TVN_ITEMEXPANDING      =TVN_FIRST-5;
     TVN_ITEMEXPANDED       =TVN_FIRST-6;
     TVN_BEGINDRAG          =TVN_FIRST-7;
     TVN_BEGINRDRAG         =TVN_FIRST-8;
     TVN_DELETEITEM         =TVN_FIRST-9;
     TVN_BEGINLABELEDIT     =TVN_FIRST-10;
     TVN_ENDLABELEDIT       =TVN_FIRST-11;
     TVN_KEYDOWN            =TVN_FIRST-12;

TYPE
    TV_KEYDOWN=RECORD
                     hdr:NMHDR;
                     wVKey:WORD;
                     flags:LONGWORD;
    END;


IMPORTS
       PROCEDURE InitCommonControls;
              APIENTRY;        'COMCTL32' name 'InitCommonControls';
       FUNCTION ImageList_Create(cx,cy:LONGINT;flags:LONGWORD;
                                 cInitial,cGrow:LONGINT):HIMAGELIST;
              APIENTRY;        'COMCTL32' name 'ImageList_Create';
       FUNCTION ImageList_Destroy(himl:HIMAGELIST):BOOL;
              APIENTRY;        'COMCTL32' name 'ImageList_Destroy';
       FUNCTION ImageList_GetImageCount(himl:HIMAGELIST):LONGINT;
              APIENTRY;        'COMCTL32' name 'ImageList_GetImageCount';
       FUNCTION ImageList_Add(himl:HIMAGELIST;hbmImage,hbmMask:HBITMAP):LONGINT;
              APIENTRY;        'COMCTL32' name 'ImageList_Add';
       FUNCTION ImageList_ReplaceIcon(himl:HIMAGELIST;i:LONGINT;ahicon:HICON):LONGINT;
              APIENTRY;        'COMCTL32' name 'ImageList_ReplaceIcon';
       FUNCTION ImageList_Replace(himl:HIMAGELIST;i:LONGINT;
                                  hbmImage,hbmMask:HBITMAP):BOOL;
              APIENTRY;        'COMCTL32' name 'ImageList_Replace';
       FUNCTION ImageList_Remove(himl:HIMAGELIST;i:LONGINT):BOOL;
              APIENTRY;        'COMCTL32' name 'ImageList_Remove';
END;

FUNCTION ImageList_AddIcon(himl:HIMAGELIST;ahicon:HICON):LONGINT;

IMPLEMENTATION


FUNCTION ImageList_AddIcon(himl:HIMAGELIST;ahicon:HICON):LONGINT;
BEGIN
     result:=ImageList_ReplaceIcon(himl, -1, ahicon);
END;

BEGIN
END.

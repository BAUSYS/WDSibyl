
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT BseSub;

{****************************************************************************
 *                                                                          *
 * OS/2 Structures and constants for KBD,VIO and MOU 16 Bit API's           *
 *                                                                          *
 * Important Note: When using this function you need the 'KBDVIO32'.DLL !   *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def;

TYPE
    PHKBD=^HKBD;
    HKBD=LONGWORD;

CONST

    KR_KBDCHARIN               =$00000001;
    KR_KBDPEEK                 =$00000002;
    KR_KBDFLUSHBUFFER          =$00000004;
    KR_KBDGETSTATUS            =$00000008;
    KR_KBDSETSTATUS            =$00000010;
    KR_KBDSTRINGIN             =$00000020;
    KR_KBDOPEN                 =$00000040;
    KR_KBDCLOSE                =$00000080;
    KR_KBDGETFOCUS             =$00000100;
    KR_KBDFREEFOCUS            =$00000200;
    KR_KBDGETCP                =$00000400;
    KR_KBDSETCP                =$00000800;
    KR_KBDXLATE                =$00001000;
    KR_KBDSETCUSTXT            =$00002000;

    IO_WAIT                    =0;
    IO_NOWAIT                  =1;
    IO_PEEK                    =2;
    IO_PEEKWAIT                =3;

   {KBDKEYINFO structure, for KbdCharIn and KbdPeek }
TYPE
    PKBDKEYINFO=^KBDKEYINFO;
    KBDKEYINFO=RECORD {pack 2}
                   chChar:CHAR;
                   chScan:BYTE;
                   fbStatus:BYTE;
                   bNlsShift:BYTE;
                   fsState:WORD;
                   time:ULONG;
               END;


   { structure for KbdStringIn }
TYPE
    PSTRINGINBUF=^STRINGINBUF;
    STRINGINBUF=RECORD
                     cb:WORD;
                     cchIn:WORD;
                END;

CONST
   { KBDINFO.fsMask }
   KEYBOARD_ECHO_ON                =$0001;
   KEYBOARD_ECHO_OFF               =$0002;
   KEYBOARD_BINARY_MODE            =$0004;
   KEYBOARD_ASCII_MODE             =$0008;
   KEYBOARD_MODIFY_STATE           =$0010;
   KEYBOARD_MODIFY_INTERIM         =$0020;
   KEYBOARD_MODIFY_TURNAROUND      =$0040;
   KEYBOARD_2B_TURNAROUND          =$0080;
   KEYBOARD_SHIFT_REPORT           =$0100;

   { KBDINFO.fsState/KBDKEYINFO.fsState/KBDTRANS.fsState }
   KBDSTF_RIGHTSHIFT               =$0001;
   KBDSTF_LEFTSHIFT                =$0002;
   KBDSTF_CONTROL                  =$0004;
   KBDSTF_ALT                      =$0008;
   KBDSTF_SCROLLLOCK_ON            =$0010;
   KBDSTF_NUMLOCK_ON               =$0020;
   KBDSTF_CAPSLOCK_ON              =$0040;
   KBDSTF_INSERT_ON                =$0080;
   KBDSTF_LEFTCONTROL              =$0100;
   KBDSTF_LEFTALT                  =$0200;
   KBDSTF_RIGHTCONTROL             =$0400;
   KBDSTF_RIGHTALT                 =$0800;
   KBDSTF_SCROLLLOCK               =$1000;
   KBDSTF_NUMLOCK                  =$2000;
   KBDSTF_CAPSLOCK                 =$4000;
   KBDSTF_SYSREQ                   =$8000;

   { KBDINFO structure, for KbdSet/GetStatus }
TYPE
   KBDINFO=RECORD
                 cb:WORD;
                 fsMask:WORD;
                 chTurnAround:WORD;
                 fsInterim:WORD;
                 fsState:WORD;
           END;


   { structure for KbdGetHWID }
TYPE
    PKBDHWID=^KBDHWID;
    KBDHWID=RECORD
                  cb:WORD;
                  idKbd:WORD;
                  usReserved1:WORD;
                  usReserved2:WORD;
            END;

CONST
   { KBDTRANS.fbStatus }
   KBDTRF_SHIFT_KEY_IN             =$01;
   KBDTRF_SCAN_CODE                =$02;
   KBDTRF_CONVERSION_REQUEST       =$20;
   KBDTRF_FINAL_CHAR_IN            =$40;
   KBDTRF_INTERIM_CHAR_IN          =$80;

   { structure for KbdXlate }
TYPE
   PKBDTRANS=^KBDTRANS;
   KBDTRANS=RECORD {pack 2}
                 chChar:CHAR;
                 chScan:BYTE;
                 fbStatus:BYTE;
                 bNlsShift:BYTE;
                 fsState:WORD;
                 time:ULONG;
                 fsDD:WORD;
                 fsXlate:WORD;
                 fsShift:WORD;
                 sZero:WORD;
           END;

TYPE
    PHVIO=^HVIO;
    HVIO=LONGWORD;

   { first parameter registration constants }
CONST
   VR_VIOGETCURPOS            =$00000001;
   VR_VIOGETCURTYPE           =$00000002;
   VR_VIOGETMODE              =$00000004;
   VR_VIOGETBUF               =$00000008;
   VR_VIOGETPHYSBUF           =$00000010;
   VR_VIOSETCURPOS            =$00000020;
   VR_VIOSETCURTYPE           =$00000040;
   VR_VIOSETMODE              =$00000080;
   VR_VIOSHOWBUF              =$00000100;
   VR_VIOREADCHARSTR          =$00000200;
   VR_VIOREADCELLSTR          =$00000400;
   VR_VIOWRTNCHAR             =$00000800;
   VR_VIOWRTNATTR             =$00001000;
   VR_VIOWRTNCELL             =$00002000;
   VR_VIOWRTTTY               =$00004000;
   VR_VIOWRTCHARSTR           =$00008000;

   VR_VIOWRTCHARSTRATT        =$00010000;
   VR_VIOWRTCELLSTR           =$00020000;
   VR_VIOSCROLLUP             =$00040000;
   VR_VIOSCROLLDN             =$00080000;
   VR_VIOSCROLLLF             =$00100000;
   VR_VIOSCROLLRT             =$00200000;
   VR_VIOSETANSI              =$00400000;
   VR_VIOGETANSI              =$00800000;
   VR_VIOPRTSC                =$01000000;
   VR_VIOSCRLOCK              =$02000000;
   VR_VIOSCRUNLOCK            =$04000000;
   VR_VIOSAVREDRAWWAIT        =$08000000;
   VR_VIOSAVREDRAWUNDO        =$10000000;
   VR_VIOPOPUP                =$20000000;
   VR_VIOENDPOPUP             =$40000000;
   VR_VIOPRTSCTOGGLE          =$80000000;

   { second parameter registration constants  }
   VR_VIOMODEWAIT             =$00000001;
   VR_VIOMODEUNDO             =$00000002;
   VR_VIOGETFONT              =$00000004;
   VR_VIOGETCONFIG            =$00000008;
   VR_VIOSETCP                =$00000010;
   VR_VIOGETCP                =$00000020;
   VR_VIOSETFONT              =$00000040;
   VR_VIOGETSTATE             =$00000080;
   VR_VIOSETSTATE             =$00000100;


   { structure for VioSet/GetCurType }
TYPE
   PVIOCURSORINFO=^VIOCURSORINFO;
   VIOCURSORINFO=RECORD
                      yStart:WORD;
                      cEnd:WORD;
                      cx:WORD;
                      attr:WORD;
                 END;

   { VIOMODEINFO.color constants }
CONST
    COLORS_2        =$0001;
    COLORS_4        =$0002;
    COLORS_16       =$0004;
    COLORS_256      =$0008;

TYPE
   { structure for VioSet/GetMode }
   PVIOMODEINFO=^VIOMODEINFO;
   VIOMODEINFO=RECORD {pack 1}
                     cb:USHORT;
                     fbType:BYTE;
                     color:BYTE;
                     col:WORD;
                     row:WORD;
                     hres:WORD;
                     vres:WORD;
                     fmt_ID:BYTE;
                     attrib:BYTE;
                     buf_addr:ULONG;
                     buf_length:ULONG;
                     full_length:ULONG;
                     partial_length:ULONG;
                     ext_data_addr:POINTER;
               END;

CONST
    VGMT_OTHER                 =$01;
    VGMT_GRAPHICS              =$02;
    VGMT_DISABLEBURST          =$04;


   { structure for VioGetPhysBuf }
TYPE
   PVIOPHYSBUF=^VIOPHYSBUF;
   VIOPHYSBUF=RECORD
                    pBuf:POINTER;
                    cb:ULONG;
                    asel:SEL;
              END;

CONST
    VCC_SBCSCHAR              =0;
    VCC_DBCSFULLCHAR          =1;
    VCC_DBCS1STHALF           =2;
    VCC_DBCS2NDHALF           =3;

CONST
    ANSI_ON                   =1;
    ANSI_OFF                  =0;

CONST
    VSRWI_SAVEANDREDRAW        =0;
    VSRWI_REDRAW               =1;

    VSRWN_SAVE                 =0;
    VSRWN_REDRAW               =1;

    UNDOI_GETOWNER             =0;
    UNDOI_RELEASEOWNER         =1;

    UNDOK_ERRORCODE            =0;
    UNDOK_TERMINATE            =1;



CONST
    VMWR_POPUP                 =0;
    VMWN_POPUP                 =0;

CONST
    LOCKIO_NOWAIT              =0;
    LOCKIO_WAIT                =1;

    LOCK_SUCCESS               =0;
    LOCK_FAIL                  =1;

CONST
    VP_NOWAIT                  =$0000;
    VP_WAIT                    =$0001;
    VP_OPAQUE                  =$0000;
    VP_TRANSPARENT             =$0002;

   { VIOCONFIGINFO.adapter constants }
CONST
    DISPLAY_MONOCHROME      =$0000;
    DISPLAY_CGA             =$0001;
    DISPLAY_EGA             =$0002;
    DISPLAY_VGA             =$0003;
    DISPLAY_8514A           =$0007;
    DISPLAY_IMAGEADAPTER    =$0008;
    DISPLAY_XGA             =$0009;

   { VIOCONFIGINFO.display constants }

    MONITOR_MONOCHROME      =$0000;
    MONITOR_COLOR           =$0001;
    MONITOR_ENHANCED        =$0002;
    MONITOR_8503            =$0003;
    MONITOR_851X_COLOR      =$0004;
    MONITOR_8514            =$0009;
    MONITOR_FLATPANEL       =$000A;
    MONITOR_8507_8604       =$000B;
    MONITOR_8515            =$000C;
    MONITOR_9515            =$000F;
    MONITOR_9517            =$0011;
    MONITOR_9518            =$0012;

   { structure for VioGetConfig() }
TYPE
   PVIOCONFIGINFO=^VIOCONFIGINFO;
   VIOCONFIGINFO=RECORD {pack 2}
                      cb:WORD;
                      adapter:WORD;
                      display:WORD;
                      cbMemory:ULONG;
                      Configuration:WORD;
                      VDHVersion:WORD;
                      Flags:WORD;
                      HWBufferSize:ULONG;
                      FullSaveSize:ULONG;
                      PartSaveSize:ULONG;
                      EMAdaptersOFF:WORD;
                      EMDisplaysOFF:WORD;
               END;

CONST
    VIO_CONFIG_CURRENT         =0;
    VIO_CONFIG_PRIMARY         =1;
    VIO_CONFIG_SECONDARY       =2;


   { structure for VioGet/SetFont }
TYPE
   PVIOFONTINFO=^VIOFONTINFO;
   VIOFONTINFO=RECORD
                   cb:WORD;
                   atype:WORD;
                   cxCell:WORD;
                   cyCell:WORD;
                   pbData:POINTER;
                   cbData:WORD;
               END;

CONST
    VGFI_GETCURFONT            =0;
    VGFI_GETROMFONT            =1;


TYPE
   PVIOPALSTATE=^VIOPALSTATE;
   VIOPALSTATE=RECORD
                    cb:WORD;
                    atype:WORD;
                    iFirst:WORD;
                    acolor:WORD;
               END;

   PVIOOVERSCAN=^VIOOVERSCAN;
   VIOOVERSCAN=RECORD
                   cb:WORD;
                   atype:WORD;
                   color:WORD;
               END;

   PVIOINTENSITY=^VIOINTENSITY;
   VIOINTENSITY=RECORD
                     cb:WORD;
                     atype:WORD;
                     fs:WORD;
                END;

   PVIOCOLORREG=^VIOCOLORREG;
   VIOCOLORREG=RECORD
                     cb:WORD;
                     atype:WORD;
                     firstcolorreg:WORD;
                     numcolorregs:WORD;
                     colorregaddr:POINTER;
               END;

   PVIOSETULINELOC=^VIOSETULINELOC;
   VIOSETULINELOC=RECORD
                     cb:WORD;
                     atype:WORD;
                     scanline:WORD;
                  END;

   PVIOSETTARGET=^VIOSETTARGET;
   VIOSETTARGET=RECORD
                      cb:WORD;
                      atype:WORD;
                      defaultalgorithm:WORD;
                END;

TYPE
    PHMOU=^HMOU;
    HMOU=LONGWORD;

CONST
    MR_MOUGETNUMBUTTONS        =$00000001;
    MR_MOUGETNUMMICKEYS        =$00000002;
    MR_MOUGETDEVSTATUS         =$00000004;
    MR_MOUGETNUMQUEEL          =$00000008;
    MR_MOUREADEVENTQUE         =$00000010;
    MR_MOUGETSCALEFACT         =$00000020;
    MR_MOUGETEVENTMASK         =$00000040;
    MR_MOUSETSCALEFACT         =$00000080;
    MR_MOUSETEVENTMASK         =$00000100;
    MR_MOUOPEN                 =$00000800;
    MR_MOUCLOSE                =$00001000;
    MR_MOUGETPTRSHAPE          =$00002000;
    MR_MOUSETPTRSHAPE          =$00004000;
    MR_MOUDRAWPTR              =$00008000;
    MR_MOUREMOVEPTR            =$00010000;
    MR_MOUGETPTRPOS            =$00020000;
    MR_MOUSETPTRPOS            =$00040000;
    MR_MOUINITREAL             =$00080000;
    MR_MOUSETDEVSTATUS         =$00100000;


CONST
    MHK_BUTTON1                =$0001;
    MHK_BUTTON2                =$0002;
    MHK_BUTTON3                =$0004;

   { structure for MouGet/SetPtrPos }
TYPE
   PPTRLOC=^PTRLOC;
   PTRLOC=RECORD
              row:WORD;
              col:WORD;
          END;

   { structure for MouGet/SetPtrShape }
TYPE
   PPTRSHAPE=^PTRSHAPE;
   PTRSHAPE=RECORD
                 cb:WORD;
                 col:WORD;
                 row:WORD;
                 colHot:WORD;
                 rowHot:WORD;
            END;

   { MouGetDevStatus/MouSetDevStatus device status constants }
CONST
    MOUSE_QUEUEBUSY        =$0001;
    MOUSE_BLOCKREAD        =$0002;
    MOUSE_FLUSH            =$0004;
    MOUSE_UNSUPPORTED_MODE =$0008;
    MOUSE_DISABLED         =$0100;
    MOUSE_MICKEYS          =$0200;

   { MouReadEventQue }
CONST
    MOU_NOWAIT      =$0000;
    MOU_WAIT        =$0001;

   { structure for MouReadEventQue }
TYPE
   PMOUEVENTINFO=^MOUEVENTINFO;
   MOUEVENTINFO=RECORD {pack 2}
                     fs:WORD;
                     time:ULONG;
                     row:WORD;
                     col:WORD;
                END;

   { structure for MouGetNumQueEl }
TYPE
   PMOUQUEINFO=^MOUQUEINFO;
   MOUQUEINFO=RECORD
                  cEvents:WORD;
                  cmaxEvents:WORD;
              END;

CONST
   { MouGetEventMask/MouSetEventMask events }

    MOUSE_MOTION                 =$0001;
    MOUSE_MOTION_WITH_BN1_DOWN   =$0002;
    MOUSE_BN1_DOWN               =$0004;
    MOUSE_MOTION_WITH_BN2_DOWN   =$0008;
    MOUSE_BN2_DOWN               =$0010;
    MOUSE_MOTION_WITH_BN3_DOWN   =$0020;
    MOUSE_BN3_DOWN               =$0040;

   { structure for MouGet/SetScaleFact }
TYPE
   PSCALEFACT=^SCALEFACT;
   SCALEFACT=RECORD
                   rowScale:WORD;
                   colScale:WORD;
             END;

TYPE
   { structure for MouRemovePtr }
   PNOPTRRECT=^NOPTRRECT;
   NOPTRRECT=RECORD
                  row:WORD;
                  col:WORD;
                  cRow:WORD;
                  cCol:WORD;
             END;

CONST
    MOU_NODRAW                 =$0001;
    MOU_DRAW                   =$0000;
    MOU_MICKEYS                =$0002;
    MOU_PELS                   =$0000;

TYPE
   PTHRESHOLD=^THRESHOLD;
   THRESHOLD=RECORD
                  aLength:WORD;
                  Level1:WORD;
                  Lev1Mult:WORD;
                  Level2:WORD;
                  lev2Mult:WORD;
             END;

IMPLEMENTATION

BEGIN
END.



{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT BSEDEV;

{***************************************************************************
*                                                                          *
* OS/2 Structures and constants for use with DosDevIOCtl                   *
*                                                                          *
****************************************************************************}

INTERFACE

USES Os2Def;

{ Input and Output Control Categories }

CONST

       IOCTL_ASYNC                        =$0001;
       IOCTL_SCR_AND_PTRDRAW              =$0003;
       IOCTL_KEYBOARD                     =$0004;
       IOCTL_PRINTER                      =$0005;
       IOCTL_LIGHTPEN                     =$0006;
       IOCTL_POINTINGDEVICE               =$0007;
       IOCTL_DISK                         =$0008;
       IOCTL_PHYSICALDISK                 =$0009;
       IOCTL_MONITOR                      =$000A;
       IOCTL_GENERAL                      =$000B;
       IOCTL_POWER                        =$000C;
       IOCTL_OEMHLP                       =$0080;
       IOCTL_TESTCFG_SYS                  =$0080;
       IOCTL_CDROMDISK                    =$0080;
       IOCTL_CDROMAUDIO                   =$0081;
       IOCTL_TOUCH_DEVDEP                 =$0081;
       IOCTL_TOUCH_DEVINDEP               =$0081;


{ Serial-Device Control }

       ASYNC_SETBAUDRATE                  =$0041;
       ASYNC_SETLINECTRL                  =$0042;
       ASYNC_EXTSETBAUDRATE               =$0043;
       ASYNC_TRANSMITIMM                  =$0044;
       ASYNC_SETBREAKOFF                  =$0045;
       ASYNC_SETMODEMCTRL                 =$0046;
       ASYNC_SETBREAKON                   =$004B;
       ASYNC_STOPTRANSMIT                 =$0047;
       ASYNC_STARTTRANSMIT                =$0048;
       ASYNC_SETDCBINFO                   =$0053;
       ASYNC_SETENHANCEDMODEPARMS         =$0054;
       ASYNC_GETBAUDRATE                  =$0061;
       ASYNC_GETLINECTRL                  =$0062;
       ASYNC_EXTGETBAUDRATE               =$0063;
       ASYNC_GETCOMMSTATUS                =$0064;
       ASYNC_GETLINESTATUS                =$0065;
       ASYNC_GETMODEMOUTPUT               =$0066;
       ASYNC_GETMODEMINPUT                =$0067;
       ASYNC_GETINQUECOUNT                =$0068;
       ASYNC_GETOUTQUECOUNT               =$0069;
       ASYNC_GETCOMMERROR                 =$006D;
       ASYNC_GETCOMMEVENT                 =$0072;
       ASYNC_GETDCBINFO                   =$0073;
       ASYNC_GETENHANCEDMODEPARMS         =$0074;

{ Screen/Pointer-Draw Control }

       SCR_ALLOCLDT                       =$0070;
       SCR_DEALLOCLDT                     =$0071;
       PTR_GETPTRDRAWADDRESS              =$0072;
       VID_INITCALLVECTOR                 =$0073;
       SCR_ABIOSPASSTHRU                  =$0074;
       SCR_ALLOCLDTOFF                    =$0075;
       SCR_ALLOCLDTBGVAL                  =$0076;
       SCR_ALLOCVIDEOBUFFER               =$007E;
       SCR_GETROMFONTADDR                 =$007F;

{ Keyboard Control }

       KBD_SETTRANSTABLE                  =$0050;
       KBD_SETINPUTMODE                   =$0051;
       KBD_SETINTERIMFLAG                 =$0052;
       KBD_SETSHIFTSTATE                  =$0053;
       KBD_SETTYPAMATICRATE               =$0054;
       KBD_SETFGNDSCREENGRP               =$0055;
       KBD_SETSESMGRHOTKEY                =$0056;
       KBD_SETFOCUS                       =$0057;
       KBD_SETKCB                         =$0058;
       KBD_SETREADNOTIFICATION            =$0059;
       KBD_ALTERKBDLED                    =$005A;
       KBD_SETNLS                         =$005C;
       KBD_CREATE                         =$005D;
       KBD_DESTROY                        =$005E;
       KBD_GETINPUTMODE                   =$0071;
       KBD_GETINTERIMFLAG                 =$0072;
       KBD_GETSHIFTSTATE                  =$0073;
       KBD_READCHAR                       =$0074;
       KBD_PEEKCHAR                       =$0075;
       KBD_GETSESMGRHOTKEY                =$0076;
       KBD_GETKEYBDTYPE                   =$0077;
       KBD_GETCODEPAGEID                  =$0078;
       KBD_XLATESCAN                      =$0079;
       KBD_QUERYKBDHARDWAREID             =$007A;
       KBD_QUERYKBDCODEPAGESUPPORT        =$007B;

{ Printer Control }

       PRT_QUERYJOBHANDLE                 =$0021;
       PRT_SETFRAMECTL                    =$0042;
       PRT_SETINFINITERETRY               =$0044;
       PRT_INITPRINTER                    =$0046;
       PRT_ACTIVATEFONT                   =$0048;
       PRT_SETPRINTJOBTITLE               =$004D;
       PRT_SETIRQTIMEOUT                  =$004E;
       PRT_SETCOMMMODE                    =$0052;
       PRT_SETDATAXFERMODE                =$0053;
       PRT_GETFRAMECTL                    =$0062;
       PRT_GETINFINITERETRY               =$0064;
       PRT_GETPRINTERSTATUS               =$0066;
       PRT_QUERYACTIVEFONT                =$0069;
       PRT_VERIFYFONT                     =$006A;
       PRT_QUERYIRQTIMEOUT                =$006E;
       PRT_QUERYCOMMMODE                  =$0072;
       PRT_QUERYDATAXFERMODE              =$0073;
       PRT_QUERDEVICEID                   =$0074;

{ Pointing-Device (Mouse) Control }

       MOU_ALLOWPTRDRAW                   =$0050;
       MOU_UPDATEDISPLAYMODE              =$0051;
       MOU_SCREENSWITCH                   =$0052;
       MOU_SETSCALEFACTORS                =$0053;
       MOU_SETEVENTMASK                   =$0054;
       MOU_SETHOTKEYBUTTON                =$0055;
       MOU_SETPTRSHAPE                    =$0056;
       MOU_DRAWPTR                        =$0057;
       MOU_REMOVEPTR                      =$0058;
       MOU_MARKCOLLISIONAREA              =$0058;
       MOU_SETPTRPOS                      =$0059;
       MOU_SETPROTDRAWADDRESS             =$005A;
       MOU_SETREALDRAWADDRESS             =$005B;
       MOU_SETMOUSTATUS                   =$005C;
       MOU_DISPLAYMODECHANGE              =$005D;
       MOU_GETBUTTONCOUNT                 =$0060;
       MOU_GETMICKEYCOUNT                 =$0061;
       MOU_GETMOUSTATUS                   =$0062;
       MOU_READEVENTQUE                   =$0063;
       MOU_GETQUESTATUS                   =$0064;
       MOU_GETEVENTMASK                   =$0065;
       MOU_GETSCALEFACTORS                =$0066;
       MOU_GETPTRPOS                      =$0067;
       MOU_GETPTRSHAPE                    =$0068;
       MOU_GETHOTKEYBUTTON                =$0069;
       MOU_QUERYTHRESHOLDVALUES           =$0069;
       MOU_VER                            =$006A;
       MOU_QUERYPOINTERID                 =$006B;

{ Disk/Diskette Control }

       DSK_LOCKDRIVE                      =$0000;
       DSK_UNLOCKDRIVE                    =$0001;
       DSK_REDETERMINEMEDIA               =$0002;
       DSK_SETLOGICALMAP                  =$0003;
       DSK_BEGINFORMAT                    =$0004;
       DSK_BLOCKREMOVABLE                 =$0020;
       DSK_GETLOGICALMAP                  =$0021;
       DSK_UNLOCKEJECTMEDIA               =$0040;
       DSK_SETDEVICEPARAMS                =$0043;
       DSK_WRITETRACK                     =$0044;
       DSK_FORMATVERIFY                   =$0045;
       DSK_DISKETTECONTROL                =$005D;
       DSK_QUERYMEDIASENSE                =$0060;
       DSK_GETDEVICEPARAMS                =$0063;
       DSK_READTRACK                      =$0064;
       DSK_VERIFYTRACK                    =$0065;
       DSK_GETLOCKSTATUS                  =$0066;

{ Physical-Disk Control }

       PDSK_LOCKPHYSDRIVE                 =$0000;
       PDSK_UNLOCKPHYSDRIVE               =$0001;
       PDSK_WRITEPHYSTRACK                =$0044;
       PDSK_GETPHYSDEVICEPARAMS           =$0063;
       PDSK_READPHYSTRACK                 =$0064;
       PDSK_VERIFYPHYSTRACK               =$0065;

{ Character-Monitor Control }

       MON_REGISTERMONITOR                =$0040;

{ General Device Control }

       DEV_FLUSHINPUT                     =$0001;
       DEV_FLUSHOUTPUT                    =$0002;
       DEV_SYSTEMNOTIFYPDD                =$0041;
       DEV_QUERYMONSUPPORT                =$0060;

{ Advanced Power Management }

       POWER_SENDPOWEREVENT               =$0040;
       POWER_SETPOWEREVENTRES             =$0041;
       POWER_GETPOWERSTATUS               =$0060;
       POWER_GETPOWEREVENT                =$0061;
       POWER_GETPOWERINFO                 =$0062;

{ OEMHlp }

       OEMHLP_GETOEMADAPTIONINFO          =$0000;
       OEMHLP_GETMACHINEINFO              =$0001;
       OEMHLP_GETDISPLAYCOMBCODE          =$0002;
       OEMHLP_GETVIDEOFONTS               =$0003;
       OEMHLP_READEISACONFIGINFO          =$0004;
       OEMHLP_GETROMBIOSINFO              =$0005;
       OEMHLP_GETMISCVIDEOINFO            =$0006;
       OEMHLP_GETVIDEOADAPTER             =$0007;
       OEMHLP_GETSVGAINFO                 =$0008;
       OEMHLP_GETMEMINFO                  =$0009;
       OEMHLP_GETDMQSINFO                 =$000A;
       OEMHLP_PCI                         =$000B;
       OEMHLP_QUERYDISKINFO               =$000E;

{ Test System Config }

       TESTCFG_SYS_GETBIOSADAPTER         =$0040;
       TESTCFG_SYS_ISSUEINIOINSTR         =$0041;
       TESTCFG_SYS_ISSUEOUTIOINSTR        =$0042;
       TESTCFG_SYS_GETBUSARCH             =$0060;
       TESTCFG_SYS_GETALLPOSIDS           =$0061;
       TESTCFG_SYS_GETALLEISAIDS          =$0062;

{ CDROM Drive and Disk }

       CDROMDISK_RESETDRIVE               =$0040;
       CDROMDISK_EJECTDISK                =$0044;
       CDROMDISK_LOCKUNLOCKDOOR           =$0046;
       CDROMDISK_SEEK                     =$0050;
       CDROMDISK_DEVICESTATUS             =$0060;
       CDROMDISK_GETDRIVER                =$0061;
       CDROMDISK_GETSECTORSIZE            =$0063;
       CDROMDISK_GETHEADLOC               =$0070;
       CDROMDISK_READLONG                 =$0072;
       CDROMDISK_GETVOLUMESIZE            =$0078;
       CDROMDISK_GETUPC                   =$0079;

{ CDROM Audio }

       CDROMAUDIO_SETCHANNELCTRL          =$0040;
       CDROMAUDIO_PLAYAUDIO               =$0050;
       CDROMAUDIO_STOPAUDIO               =$0051;
       CDROMAUDIO_RESUMEAUDIO             =$0052;
       CDROMAUDIO_GETCHANNEL              =$0060;
       CDROMAUDIO_GETAUDIODISK            =$0061;
       CDROMAUDIO_GETAUDIOTRACK           =$0062;
       CDROMAUDIO_GETSUBCHANNELQ          =$0063;
       CDROMAUDIO_GETAUDIOSTATUS          =$0065;

{ Touch device-dependent IOCtls }

       TOUCH_DEVDEP_SETCALIBCONST         =$0052;
       TOUCH_DEVDEP_READDATA              =$0053;
       TOUCH_DEVDEP_SETDATAMODE           =$0054;
       TOUCH_DEVDEP_SETCLICKLOCK          =$0055;
       TOUCH_DEVDEP_SETTOUCHTHRESHOLD     =$0056;
       TOUCH_DEVDEP_SETEMULXY             =$0057;
       TOUCH_DEVDEP_SETDATAREPORTRATE     =$0058;
       TOUCH_DEVDEP_SETLOWPASSFILTER      =$0059;
       TOUCH_DEVDEP_WRITEMEMLOC           =$005A;
       TOUCH_DEVDEP_GETCALIBCONST         =$0060;
       TOUCH_DEVDEP_GETDATAMODE           =$0061;
       TOUCH_DEVDEP_GETCLICKLOCK          =$0062;
       TOUCH_DEVDEP_GETTOUCHTHRESHOLD     =$0063;
       TOUCH_DEVDEP_GETEMULXY             =$0064;
       TOUCH_DEVDEP_GETDATAREPORTRATE     =$0065;
       TOUCH_DEVDEP_GETLOWPASSFILTER      =$0066;
       TOUCH_DEVDEP_READMEMLOC            =$0067;

{ Touch device-INdependent IOCtls }

       TOUCH_DEVINDEP_SETCOORDSYS         =$0050;
       TOUCH_DEVINDEP_SETSELECTMECH       =$0052;
       TOUCH_DEVINDEP_SETEVENTMASK        =$0053;
       TOUCH_DEVINDEP_SETQUEUESIZE        =$0054;
       TOUCH_DEVINDEP_SETEMULSTATE        =$0055;
       TOUCH_DEVINDEP_GETCOORDSYS         =$0060;
       TOUCH_DEVINDEP_GETSELECTMECH       =$0062;
       TOUCH_DEVINDEP_GETEVENTMASK        =$0063;
       TOUCH_DEVINDEP_GETQUEUESIZE        =$0064;
       TOUCH_DEVINDEP_GETEMULSTATE        =$0065;
       TOUCH_DEVINDEP_GETREADEVENTQUEUE   =$0066;

{ ASYNC_GETCOMMERROR, ASYNC_SETBREAKOFF, ASYNC_SETBREAKON, ASYNC_SETMODEMCTRL }

       RX_QUE_OVERRUN                     =$0001;
       RX_HARDWARE_OVERRUN                =$0002;
       PARITY_ERROR                       =$0004;
       FRAMING_ERROR                      =$0008;

{ ASYNC_GETCOMMEVENT }

       CHAR_RECEIVED                      =$0001;
       LAST_CHAR_SENT                     =$0004;
       CTS_CHANGED                        =$0008;
       DSR_CHANGED                        =$0010;
       DCD_CHANGED                        =$0020;
       BREAK_DETECTED                     =$0040;
       ERROR_OCCURRED                     =$0080;
       RI_DETECTED                        =$0100;

{ ASYNC_GETCOMMSTATUS }

       TX_WAITING_FOR_CTS                 =$0001;
       TX_WAITING_FOR_DSR                 =$0002;
       TX_WAITING_FOR_DCD                 =$0004;
       TX_WAITING_FOR_XON                 =$0008;
       TX_WAITING_TO_SEND_XON             =$0010;
       TX_WAITING_WHILE_BREAK_ON          =$0020;
       TX_WAITING_TO_SEND_IMM             =$0040;
       RX_WAITING_FOR_DSR                 =$0080;

{ ASYNC_GETLINESTATUS }

       WRITE_REQUEST_QUEUED               =$0001;
       DATA_IN_TX_QUE                     =$0002;
       HARDWARE_TRANSMITTING              =$0004;
       CHAR_READY_TO_SEND_IMM             =$0008;
       WAITING_TO_SEND_XON                =$0010;
       WAITING_TO_SEND_XOFF               =$0020;

{ ASYNC_GETMODEMINPUT }

       CTS_ON                             =$10;
       DSR_ON                             =$20;
       RI_ON                              =$40;
       DCD_ON                             =$80;

{ DSK_SETDEVICEPARAMS }

       BUILD_BPB_FROM_MEDIUM              =$00;
       REPLACE_BPB_FOR_DEVICE             =$01;
       REPLACE_BPB_FOR_MEDIUM             =$02;

{ DSK_GETDEVICEPARAMS }

       GET_BPB_FROM_DEVICE                =$00;
       GET_BPB_FROM_MEDIUM                =$01;

{ KBD_GETINPUTMODE, KBD_PEEKCHAR, KBD_SETINPUTMODE}

       ASCII_MODE                         =$00;
       BINARY_MODE                        =$80;

{ KBD_GETINTERIMFLAG }

       CONVERSION_REQUEST                 =$20;
       INTERIM_CHAR                       =$80;

{ KBD_GETSESMGRHOTKEY }

       HOTKEY_MAX_COUNT                   =$0000;
       HOTKEY_CURRENT_COUNT               =$0001;

{ KBD_PEEKCHAR }

       KBD_DATA_RECEIVED                  =$0001;
       KBD_DATA_BINARY                    =$8000;

{ KBD_READCHAR }

       KBD_READ_WAIT                      =$0000;
       KBD_READ_NOWAIT                    =$8000;

{ KBD_SETINPUTMODE }

       SHIFT_REPORT_MODE                  =$01;

       MOUSE_MOTION                       =$0001;
       MOUSE_MOTION_WITH_BN1_DOWN         =$0002;
       MOUSE_BN1_DOWN                     =$0004;
       MOUSE_MOTION_WITH_BN2_DOWN         =$0008;
       MOUSE_BN2_DOWN                     =$0010;
       MOUSE_MOTION_WITH_BN3_DOWN         =$0020;
       MOUSE_BN3_DOWN                     =$0040;

       MHK_BUTTON1                        =$0001;
       MHK_BUTTON2                        =$0002;
       MHK_BUTTON3                        =$0004;

       MOU_NOWAIT                         =$0000;
       MOU_WAIT                           =$0001;


{ MOU_GETHOTKEYBUTTON, MOU_SETHOTKEYBUTTON }

       MHK_NO_HOTKEY                      =$0000;

{ MOU_GETMOUSTATUS }

       MOUSE_QUEUEBUSY                    =$0001;
       MOUSE_BLOCKREAD                    =$0002;
       MOUSE_FLUSH                        =$0004;
       MOUSE_UNSUPPORTED_MODE             =$0008;
       MOUSE_DISABLED                     =$0100;
       MOUSE_MICKEYS                      =$0200;

{ PRT_GETPRINTERSTATUS }

       PRINTER_TIMEOUT                    =$0001;
       PRINTER_IO_ERROR                   =$0008;
       PRINTER_SELECTED                   =$0010;
       PRINTER_OUT_OF_PAPER               =$0020;
       PRINTER_ACKNOWLEDGED               =$0040;
       PRINTER_NOT_BUSY                   =$0080;

{ fbCtlHndShake }

       MODE_DTR_CONTROL                   =$01;
       MODE_DTR_HANDSHAKE                 =$02;
       MODE_CTS_HANDSHAKE                 =$08;
       MODE_DSR_HANDSHAKE                 =$10;
       MODE_DCD_HANDSHAKE                 =$20;
       MODE_DSR_SENSITIVITY               =$40;

{ fbFlowReplace }

       MODE_AUTO_TRANSMIT                 =$01;
       MODE_AUTO_RECEIVE                  =$02;
       MODE_ERROR_CHAR                    =$04;
       MODE_NULL_STRIPPING                =$08;
       MODE_BREAK_CHAR                    =$10;
       MODE_RTS_CONTROL                   =$40;
       MODE_RTS_HANDSHAKE                 =$80;
       MODE_TRANSMIT_TOGGLE               =$C0;

{ fbTimeout }

       MODE_NO_WRITE_TIMEOUT              =$01;
       MODE_READ_TIMEOUT                  =$02;
       MODE_WAIT_READ_TIMEOUT             =$04;
       MODE_NOWAIT_READ_TIMEOUT           =$06;


{ DosExitList }

       EXTLST_ADD                         =$01;
       EXTLST_REMOVE                      =$02;
       EXTLST_EXIT                        =$03;
       EXTLST_ROUTTINE_ORDER              =$0000ee00;

TYPE
    PDCBINFO=^DCBINFO;
    DCBINFO=RECORD
                 usWriteTimeout:USHORT;
                 usReadTimeout:USHORT;
                 fbCtlHndShake:BYTE;
                 fbFlowReplace:BYTE;
                 fbTimeout:BYTE;
                 bErrorReplacementChar:BYTE;
                 bBreakReplacementChar:BYTE;
                 bXONChar:BYTE;
                 bXOFFChar:BYTE;
           END;

    PTRACKLAYOUT=^TRACKLAYOUT;
    TRACKLAYOUT=RECORD {pack 1}
                    bCommand:BYTE;
                    usHead:USHORT;
                    usCylinder:USHORT;
                    usFirstSector:USHORT;
                    cSectors:USHORT;
                    TrackTable:RECORD
                                    usSectorNumber:USHORT;
                                    usSectorSize:USHORT;
                               END;
                END;

CONST
       DEVTYPE_48TPI                      =$0000;
       DEVTYPE_96TPI                      =$0001;
       DEVTYPE_35                         =$0002;
       DEVTYPE_8SD                        =$0003;
       DEVTYPE_8DD                        =$0004;
       DEVTYPE_FIXED                      =$0005;
       DEVTYPE_TAPE                       =$0006;
       DEVTYPE_UNKNOWN                    =$0007;


TYPE
    PBIOSPARAMETERBLOCK=^BIOSPARAMETERBLOCK;
    BIOSPARAMETERBLOCK=RECORD {pack 1}
                            usBytesPerSector:USHORT;
                            bSectorsPerCluster:BYTE;
                            usReservedSectors:USHORT;
                            cFATs:BYTE;
                            cRootEntries:USHORT;
                            cSectors:USHORT;
                            bMedia:BYTE;
                            usSectorsPerFAT:USHORT;
                            usSectorsPerTrack:USHORT;
                            cHeads:USHORT;
                            cHiddenSectors:ULONG;
                            cLargeSectors:ULONG;
                            abReserved:ARRAY[0..5] OF BYTE;
                            cCylinders:USHORT;
                            bDeviceType:BYTE;
                            fsDeviceAttr:USHORT;
                END;

    PSCREEGROUP=^SCREENGROUP;
    SCREENGROUP=RECORD {pack 1}
                      idScreenGrp:USHORT;
                      fTerminate:USHORT;
                END;

    PFRAME=^FRAME;
    FRAME=RECORD {pack 1}
                bCharsPerLine:BYTE;
                bLinesPerInch:BYTE;
          END;

    PKBDTYPE=^KBDTYPE;
    KBDTYPE=RECORD {pack 1}
                  usType:USHORT;
                  reserved1:USHORT;
                  reserved2:USHORT;
            END;

    PLINECONTROL=^LINECONTROL;
    LINECONTROL=RECORD {pack 1}
                     bDataBits:BYTE;
                     bParity:BYTE;
                     bStopBits:BYTE;
                     fTransBreak:BYTE;
                END;

{ MODEMSTATUS.fbModemOn, ASYNC_GETMODEMOUTPUT }

CONST
       DTR_ON                             =$01;
       RTS_ON                             =$02;

{ MODEMSTATUS.fbModemOff }

       DTR_OFF                            =$FE;
       RTS_OFF                            =$FD;

TYPE
    PMODEMSTATUS=^MODEMSTATUS;
    MODEMSTATUS=RECORD {pack 1}
                     fbModemOn:BYTE;
                     fbModemOff:BYTE;
                END;

    PTRACKFROMAT=^TRACKFORMAT;
    TRACKFORMAT=RECORD {pack 1}
                     bCommand:BYTE;
                     usHead:USHORT;
                     usCylinder:USHORT;
                     usReserved:USHORT;
                     cSectors:USHORT;
                     FormatTable:RECORD
                                      bCylinder:BYTE;
                                      bHead:BYTE;
                                      idSector:BYTE;
                                      bBytesSector:BYTE;
                                 END;
               END;

    PRXQUEUE=^RXQUEUE;
    RXQUEUE=RECORD {pack 1}
                  cch:USHORT;
                  cb:USHORT;
            END;

    PDEVICEPARAMETERBLOCK=^DEVICEPARAMETERBLOCK;
    DEVICEPARAMETERBLOCK=RECORD   { pack 1 }
                              reserved1:USHORT;
                              cCylinders:USHORT;
                              cHeads:USHORT;
                              cSectorsPerTrack:USHORT;
                              reserved2:USHORT;
                              reserved3:USHORT;
                              reserved4:USHORT;
                              reserved5:USHORT;
                         END;


   PPTRDRAWFUNCTION=^PTRDRAWFUNCTION;
   PTRDRAWFUNCTION=RECORD {pack 2}
                         usReturnCode:USHORT;
                         pfnDraw:POINTER;
                         pchDataSeg:PCH;
                   END;

   PPTRDRAWADDRESS=^PTRDRAWADDRESS;
   PTRDRAWADDRESS=RECORD {pack 2}
                        reserved:USHORT;
                        ptrdfnc:PTRDRAWFUNCTION;
                  END;

   PSHIFTSTATE=^SHIFTSTATE;
   SHIFTSTATE=RECORD {pack 2}
                  fsState:USHORT;
                  fNLS:BYTE;
              END;



{ HOTKEY.fsHotKey/SHIFTSTATE.fsState }

CONST
       RIGHTSHIFT                         =$0001;
       LEFTSHIFT                          =$0002;
       CONTROL                            =$0004;
       ALT                                =$0008;
       SCROLLLOCK_ON                      =$0010;
       NUMLOCK_ON                         =$0020;
       CAPSLOCK_ON                        =$0040;
       INSERT_ON                          =$0080;
       LEFTCONTROL                        =$0100;
       LEFTALT                            =$0200;
       RIGHTCONTROL                       =$0400;
       RIGHTALT                           =$0800;
       SCROLLLOCK                         =$1000;
       NUMLOCK                            =$2000;
       CAPSLOCK                           =$4000;
       SYSREQ                             =$8000;

TYPE
    PHOTKEY=^HOTKEY;
    HOTKEY=RECORD {pack 2}
                fsHotKey:USHORT;
                uchScancodeMake:UCHAR;
                uchScancodeBreak:UCHAR;
                idHotKey:USHORT;
           END;

   PMONITORPOSITION=^MONITORPOSITION;
   MONITORPOSITION=RECORD { pack 2 }
                        fPosition:USHORT;
                        index:USHORT;
                        pbInBuf:ULONG;
                        offOutBuf:USHORT;
                   END;

    PRATEDELAY=^RATEDELAY;
    RATEDELAY=RECORD {pack 2}
                    usDelay:USHORT;
                    usRate:USHORT;
              END;

    PCODEPAGEINFO=^CODEPAGEINFO;
    CODEPAGEINFO=RECORD { pack 2}
                      pbTransTable:PBYTE;
                      idCodePage:USHORT;
                      idTable:USHORT;
                 END;

    PCPID=^CPID;
    CPID=RECORD { pack 2}
               idCodePage:USHORT;
               Reserved:USHORT;
         END;

    PLDTADDRINFO=^LDTADDRINFO;
    LDTADDRINFO=RECORD { pack 2 }
                     pulPhysAddr:PULONG;
                     cb:USHORT;
                END;

    PPTRDRAWDATA=^PTRDRAWDATA;
    PTRDRAWDATA=RECORD { pack 2 }
                     cb:USHORT;
                     usConfig:USHORT;
                     usFlag:USHORT;
                END;

{ SCREENDD IOCTL definitions }

CONST
    SCREENDD_GETCURRENTBANK         =$00;    /* Get current bank */
    SCREENDD_SETCURRENTBANK         =$01;    /* Set current bank */
    SCREENDD_SVGA_ID                =$08;    /* Get SVGA info IOCTL */
    SCREENDD_SVGA_OEM               =$09;    /* Get OEM info IOCTL */
    SCREENDD_UPDATEMEMORY           =$0A;    /* Update Memory    IOCTl   */
    SCREENDD_GETLINEARACCESS        =$0B;    /* GetLinearAccess  IOCTl   */
    SCREENDD_GETGLOBALACCESS        =$0C;    /* GetGlobalAccess  IOCTl   */
    SCREENDD_FREEGLOBALACCESS       =$0D;    /* FreeGlobalAccess IOCTl   */
    SCREENDD_REGISTER_RING0_CALLER  =$0E;    /* Register VVID as Ring0 PMI caller */
    SCREENDD_WAIT_ON_RING0_CALLER   =$0F;    /* Wait for RING0 caller to register */
    /* this IOCTL is used internally between videopmi & screendd: */
    SCREENDD_SVGA_APM               =$10;    /* Wait 4 APM */
    SCREENDD_GET_CS_ALIAS           =$11;

    SCREENDD_CATEGORY               =$80;
    SCREENDD_NAME                   ='SCREEN$';

    /* APM constants */
    APM_RESUME   = 1;
    APM_SUSPEND  = 2;
    APM_DISABLED = 4;


    GETLINEAR_FLAG_MAPPHYSICAL      =$00000010;
    GETLINEAR_FLAG_MAPPROCESS       =$00000020;
    GETLINEAR_FLAG_MAPSHARED        =$00000400;
    GETLINEAR_FLAG_MAPVERIFY        =$40000000;
    GETLINEAR_FLAG_MAPATTACH        =$80000000;

    EGA_BIT      = 4;                  /* EGA */
    VGA_BIT      = 8;                  /* VGA */
    EGAVGA_BIT   = (EGA_BIT+VGA_BIT);  /* EGA/VGA */

TYPE
    PGETLINIOCTLDATA=^GETLINIOCTLDATA;
    GETLINIOCTLDATA=RECORD
                      PacketLength:ULONG;
                      PhysicalAddress:ULONG;
                      ApertureSize:ULONG;
                      LinearAddress:PBYTE; //Pointer
                      LinearFlags:ULONG;
                    END;

    PBANKINFO=^BANKINFO;
    BANKINFO=RECORD  /* SCREENDD_SETCURRENTBANK/GETCURRENTBANK */
               ulBankLength:ULONG;
               usBank:USHORT;
               usVideoModeType:USHORT;
               usReadWriteMode:USHORT;
             END;

CONST
    READ_BANK    = 0;
    WRITE_BANK   = 1;
    MODE_TEXT    = 0;
    MODE_PLANAR  = 1;
    MODE_LINEAR  = 2;

TYPE
    PGLOBALIOCTLDATA=^GLOBALIOCTLDATA;
    GLOBALIOCTLDATA=RECORD  /* SCREENDD_GETGLOBALACCESS */
                      ProcessAddress:ULONG;
                      AddressLength:ULONG;
                      GlobalAddress:ULONG;
                    END;

    POEMSVGAINFO=^OEMSVGAINFO;
    OEMSVGAINFO=RECORD  /* data packet for SCREENDD_SVGA_ID */
                  AdapterType:USHORT;
                  ChipType:USHORT;
                  Memory:ULONG;
                  //ULONG  aulPCIRangeSize[6];       /* PCI_CFG_BASE_ADDR_COUNT = 6 */
                  //BYTE   abPCIConfiguration [256]; /* PCI_CFG_SPACE_SIZE = 0x0100 = 256 */
                END;

/* data packet for SCREENDD_SVGA_OEM */
/* OEM data packet format must contain total length in bytes as its first word. */
/* The rest of it can be in manufacturer/adapter specific format. */

    POEMINFO=^OEMINFO;
    OEMINFO=RECORD
              OEMLength:ULONG;             /* Represents the combined length of all parameter packet fields. */
              Manufacturer:USHORT;         /* Identifies the name of the manufacturer */
              ManufacturerData:ULONG;      /* Manufacturer specific data */
              ManufacturerModel:USHORT;
            END;

    PGETGLOBALPACKET=^GETGLOBALPACKET;
    GETGLOBALPACKET=RECORD  /* paramter packet for GETGLOBALACCESS */
                      GlobalPktLength:ULONG;
                      GlobalPktData:array[0..0] of GLOBALIOCTLDATA;
                    END;



IMPLEMENTATION

BEGIN
END.

{ -- date ---  -- from -- -- changes ----------------------------------------------
  18-Jun-2010  RG         diverse zustzliche Definitionen
                          (IOCTL_,ASYNC_,VID_,SCR_,KBD_,PRT_,MOU_,DSK_,DEV_,POWER_, ...
}
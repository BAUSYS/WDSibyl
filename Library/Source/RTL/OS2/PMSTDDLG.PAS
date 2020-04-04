
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PmStdDlg;

{****************************************************************************
 *                                                                          *
 * OS/2 Presentation Manager CUA controls and dialogs declarations          *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def,BseDos,PmWin,PmGpi;

   {**********************************************************************
    *                                                                    *
    *                     F I L E    D I A L O G                         *
    *                                                                    *
    **********************************************************************}

   {*--------------------------------------------------------------------*
    * File Dialog Invocation Flag Definitions.                           *
   {*--------------------------------------------------------------------*}
CONST
    FDS_CENTER           =$00000001;
    FDS_CUSTOM           =$00000002; { Use custom user template  }
    FDS_FILTERUNION      =$00000004; { Use union of filters      }
    FDS_HELPBUTTON       =$00000008; { Display Help button       }
    FDS_APPLYBUTTON      =$00000010; { Display Apply button      }
    FDS_PRELOAD_VOLINFO  =$00000020; { Preload volume info       }
    FDS_MODELESS         =$00000040; { Make dialog modeless      }
    FDS_INCLUDE_EAS      =$00000080; { Always load EA info       }
    FDS_OPEN_DIALOG      =$00000100; { Select Open dialog        }
    FDS_SAVEAS_DIALOG    =$00000200; { Select SaveAs dialog      }
    FDS_MULTIPLESEL      =$00000400; { Enable multiple selection }
    FDS_ENABLEFILELB     =$00000800; { Enable SaveAs Listbox     }

   {--------------------------------------------------------------------}
   { File Dialog Selection returned attribute                           }
   {--------------------------------------------------------------------}
     FDS_EFSELECTION    =0;
     FDS_LBSELECTION    =1;

   {--------------------------------------------------------------------}
   { Error Return Codes from dialog (self defining)                     }
   {--------------------------------------------------------------------}
     FDS_SUCCESSFUL                           =0;
     FDS_ERR_DEALLOCATE_MEMORY                =1;
     FDS_ERR_FILTER_TRUNC                     =2;
     FDS_ERR_INVALID_DIALOG                   =3;
     FDS_ERR_INVALID_DRIVE                    =4;
     FDS_ERR_INVALID_FILTER                   =5;
     FDS_ERR_INVALID_PATHFILE                 =6;
     FDS_ERR_OUT_OF_MEMORY                    =7;
     FDS_ERR_PATH_TOO_LONG                    =8;
     FDS_ERR_TOO_MANY_FILE_TYPES              =9;
     FDS_ERR_INVALID_VERSION                  =10;
     FDS_ERR_INVALID_CUSTOM_HANDLE            =11;
     FDS_ERR_DIALOG_LOAD_ERROR                =12;
     FDS_ERR_DRIVE_ERROR                      =13;

   {--------------------------------------------------------------------}
   { File Dialog Messages.                                              }
   {--------------------------------------------------------------------}
    FDM_FILTER       =WM_USER+40;  { mp1 = PSZ pszFileName         }
   {                                      mp2 = PSZ EA .TYPE value      }
   {                                      mr  = TRUE -> keep file.      }
    FDM_VALIDATE     =WM_USER+41;  { mp1 = PSZ pszPathName         }
   {                                      mp2 = USHORT Field name id    }
   {                                      mr  = TRUE -> Valid name      }
    FDM_ERROR        =WM_USER+42;  { mp1 = USHORT Error message id }
   {                                      mp2 = NULL   reserved         }
   {                                      mr  = NULL -> Use default msg }

   {--------------------------------------------------------------------}
   { Define the type that is a pointer to an array of pointers.         }
   {     Hence: pointer to an array of Z string pointers.               }
   {--------------------------------------------------------------------}

TYPE
    PAPSZ=^APSZ;
    APSZ=ARRAY[0..1] OF PChar;

   {--------------------------------------------------------------------}
   { File Dialog application data structure.                            }
   {--------------------------------------------------------------------}
TYPE
   PFILEDLG=^FILEDLG;
   FILEDLG=RECORD
                cbSize:ULONG;     { Size of FILEDLG structure.         }
                fl:ULONG;         { FDS_ flags. Alter behavior of dlg. }
                ulUser:ULONG;     { User defined field.                }
                lReturn:LONG;     { Result code from dialog dismissal. }
                lSRC:LONG;        { System return code.                }
                pszTitle:PChar;   { String to display in title bar.    }
                pszOKButton:PChar;{ String to display in OK button.    }
                pfnDlgProc:POINTER;{ Entry point to custom dialog proc. }
                pszIType:PChar;   { Pointer to string containing       }
                papszITypeList:PAPSZ; { Pointer to table of pointers that
                                        point to null terminated Type
                                        strings. End of table is marked
                                        by a NULL pointer.              }
                pszIDrive:PChar;  { Pointer to string containing       }
                papszIDriveList:PAPSZ; { Pointer to table of pointers that
                                        point to null terminated Drive
                                        strings. End of table is marked
                                        by a NULL pointer.              }
                hMod:HMODULE;     { Custom File Dialog template.       }
                szFullFile:CSTRING[CCHMAXPATH-1]; { Initial or selected fully
                                                    qualified path and file.}
                papszFQFilename:PAPSZ; { Pointer to table of pointers that
                                         point to null terminated FQFname
                                         strings. End of table is marked
                                         by a NULL pointer.            }
                ulFQFCount:ULONG; { Number of files selected           }
                usDlgId:USHORT;   { Custom dialog id.                  }
                x:SHORT;          { X coordinate of the dialog         }
                y:SHORT;          { Y coordinate of the dialog         }
                sEAType:SHORT;    { Selected file's EA Type.           }
       END;


   {--------------------------------------------------------------------}
   { File Dialog - dialog and control ids                               }
   {--------------------------------------------------------------------}
CONST
      DID_FILE_DIALOG            =256;
      DID_FILENAME_TXT           =257;
      DID_FILENAME_ED            =258;
      DID_DRIVE_TXT              =259;
      DID_DRIVE_CB               =260;
      DID_FILTER_TXT             =261;
      DID_FILTER_CB              =262;
      DID_DIRECTORY_TXT          =263;
      DID_DIRECTORY_LB           =264;
      DID_FILES_TXT              =265;
      DID_FILES_LB               =266;
      DID_HELP_PB                =267;
      DID_APPLY_PB               =268;
      DID_OK_PB                  =DID_OK;
      DID_CANCEL_PB              =DID_CANCEL;

      IDS_FILE_ALL_FILES_SELECTOR     =1000;
      IDS_FILE_BACK_CUR_PATH          =1001;
      IDS_FILE_BACK_PREV_PATH         =1002;
      IDS_FILE_BACK_SLASH             =1003;
      IDS_FILE_BASE_FILTER            =1004;
      IDS_FILE_BLANK                  =1005;
      IDS_FILE_COLON                  =1006;
      IDS_FILE_DOT                    =1007;
      IDS_FILE_DRIVE_LETTERS          =1008;
      IDS_FILE_FWD_CUR_PATH           =1009;
      IDS_FILE_FWD_PREV_PATH          =1010;
      IDS_FILE_FORWARD_SLASH          =1011;
      IDS_FILE_PARENT_DIR             =1012;
      IDS_FILE_Q_MARK                 =1013;
      IDS_FILE_SPLAT                  =1014;
      IDS_FILE_SPLAT_DOT              =1015;
      IDS_FILE_SAVEAS_TITLE           =1016;
      IDS_FILE_SAVEAS_FILTER_TXT      =1017;
      IDS_FILE_SAVEAS_FILENM_TXT      =1018;
      IDS_FILE_DUMMY_FILE_NAME        =1019;
      IDS_FILE_DUMMY_FILE_EXT         =1020;
      IDS_FILE_DUMMY_DRIVE            =1021;
      IDS_FILE_DUMMY_ROOT_DIR         =1022;
      IDS_FILE_PATH_PTR               =1023;
      IDS_FILE_VOLUME_PREFIX          =1024;
      IDS_FILE_VOLUME_SUFFIX          =1025;
      IDS_FILE_PATH_PTR2              =1026;
      IDS_FILE_INVALID_CHARS          =1027;

      IDS_FILE_BAD_DRIVE_NAME         =1100;
      IDS_FILE_BAD_DRIVE_OR_PATH_NAME =1101;
      IDS_FILE_BAD_FILE_NAME          =1102;
      IDS_FILE_BAD_FQF                =1103;
      IDS_FILE_BAD_NETWORK_NAME       =1104;
      IDS_FILE_BAD_SUB_DIR_NAME       =1105;
      IDS_FILE_DRIVE_NOT_AVAILABLE    =1106;
      IDS_FILE_FQFNAME_TOO_LONG       =1107;
      IDS_FILE_OPEN_DIALOG_NOTE       =1108;
      IDS_FILE_PATH_TOO_LONG          =1109;
      IDS_FILE_SAVEAS_DIALOG_NOTE     =1110;

      IDS_FILE_DRIVE_DISK_CHANGE      =1120;
      IDS_FILE_DRIVE_NOT_READY        =1122;
      IDS_FILE_DRIVE_LOCKED           =1123;
      IDS_FILE_DRIVE_NO_SECTOR        =1124;
      IDS_FILE_DRIVE_SOME_ERROR       =1125;
      IDS_FILE_DRIVE_INVALID          =1126;
      IDS_FILE_INSERT_DISK_NOTE       =1127;
      IDS_FILE_OK_WHEN_READY          =1128;

   {********************************************************************}
   {                                                                    }
   {                     F O N T    D I A L O G                         }
   {                                                                    }
   {********************************************************************}

   {********************************************************************}
   { Font Dialog Creation Structure                                     }
   {********************************************************************}

TYPE
    PFONTDLG=^FONTDLG;
    FONTDLG=RECORD
                 cbSize:ULONG;       { sizeof(FONTDLG)                 }
                 hpsScreen:HPS;      { Screen presentation space       }
                 hpsPrinter:HPS;     { Printer presentation space      }
                 pszTitle:PChar;     { Application supplied title      }
                 pszPreview:PChar;   { String to print in preview wndw }
                 pszPtSizeList:PChar;{ Application provided size list  }
                 pfnDlgProc:POINTER; { Dialog subclass procedure       }
                 pszFamilyname:PChar;{ Family name of font             }
                 fxPointSize:FIXED;  { Point size the user selected    }
                 fl:ULONG;           { FNTS_* flags - dialog styles    }
                 flFlags:ULONG;      { FNTF_* state flags              }
                 flType:ULONG;       { Font type option bits           }
                 flTypeMask:ULONG;   { Mask of which font types to use }
                 flStyle:ULONG;      { The selected style bits         }
                 flStyleMask:ULONG;  { Mask of which style bits to use }
                 clrFore:LONG;       { Selected foreground color       }
                 clrBack:LONG;       { Selected background color       }
                 ulUser:ULONG;       { Blank field for application     }
                 lReturn:LONG;       { Return Value of the Dialog      }
                 lSRC:LONG;          { System return code.             }
                 lEmHeight:LONG;     { Em height of the current font   }
                 lXHeight:LONG;      { X height of the current font    }
                 lExternalLeading:LONG;{ External Leading of font        }
                 hMod:HMODULE;       { Module to load custom template  }
                 fAttrs:FATTRS;     { Font attribute structure        }
                 sNominalPointSize:SHORT; { Nominal Point Size of font      }
                 usWeight:USHORT;    { The boldness of the font        }
                 usWidth:USHORT;     { The width of the font           }
                 x:SHORT;            { X coordinate of the dialog      }
                 y:SHORT;            { Y coordinate of the dialog      }
                 usDlgId:USHORT;     { ID of a custom dialog template  }
                 usFamilyBufLen:USHORT; { Length of family buffer provided}
                 usReserved:USHORT;  { reserved                        }
         END;

   {********************************************************************}
   { Font Dialog Style Flags                                            }
   {********************************************************************}
CONST
    FNTS_CENTER              =$00000001; { Center in owner dialog}
    FNTS_CUSTOM              =$00000002; { Use custom template   }
    FNTS_OWNERDRAWPREVIEW    =$00000004; { Allow app to draw     }
    FNTS_HELPBUTTON          =$00000008; { Display Help button   }
    FNTS_APPLYBUTTON         =$00000010; { Display Apply button  }
    FNTS_RESETBUTTON         =$00000020; { Display Reset button  }
    FNTS_MODELESS            =$00000040; { Make dialog modeless  }
    FNTS_INITFROMFATTRS      =$00000080; { Initialize from FATTRs}
    FNTS_BITMAPONLY          =$00000100; { Only allow bitmap font}
    FNTS_VECTORONLY          =$00000200; { Only allow vector font}
    FNTS_FIXEDWIDTHONLY      =$00000400; { Only allow monospaced }
    FNTS_PROPORTIONALONLY    =$00000800; { Only proportional font}
    FNTS_NOSYNTHESIZEDFONTS  =$00001000; { Don't synthesize fonts}

   {********************************************************************}
   { Font Dialog Flags                                                  }
   {********************************************************************}
    FNTF_NOVIEWSCREENFONTS     =1;
    FNTF_NOVIEWPRINTERFONTS    =2;
    FNTF_SCREENFONTSELECTED    =4;
    FNTF_PRINTERFONTSELECTED   =8;

   {********************************************************************}
   { Color code definitions                                             }
   {********************************************************************}
    CLRC_FOREGROUND            =1;
    CLRC_BACKGROUND            =2;

   {********************************************************************}
   { Filter List message string identifiers                             }
   {********************************************************************}
    FNTI_BITMAPFONT         =$0001;
    FNTI_VECTORFONT         =$0002;
    FNTI_FIXEDWIDTHFONT     =$0004;
    FNTI_PROPORTIONALFONT   =$0008;
    FNTI_SYNTHESIZED        =$0010;
    FNTI_DEFAULTLIST        =$0020;
    FNTI_FAMILYNAME         =$0100;
    FNTI_STYLENAME          =$0200;
    FNTI_POINTSIZE          =$0400;

   {********************************************************************}
   { Error Return Codes from dialog (self defining)                     }
   {********************************************************************}
     FNTS_SUCCESSFUL                         = 0;
     FNTS_ERR_INVALID_DIALOG                 = 3;
     FNTS_ERR_ALLOC_SHARED_MEM               = 4;
     FNTS_ERR_INVALID_PARM                   = 5;
     FNTS_ERR_OUT_OF_MEMORY                  = 7;
     FNTS_ERR_INVALID_VERSION                =10;
     FNTS_ERR_DIALOG_LOAD_ERROR              =12;

   {********************************************************************}
   { Font Dialog Messages                                               }
   {********************************************************************}
    FNTM_FACENAMECHANGED  =WM_USER+50; { mp1 = PSZ pszFacename   }
    FNTM_POINTSIZECHANGED =WM_USER+51; { mp1 = PSZ pszPointSize, }
   {                                           mp2 = FIXED fxPointSize }
    FNTM_STYLECHANGED     =WM_USER+52; { mp1 = PSTYLECHANGE pstyc}
    FNTM_COLORCHANGED     =WM_USER+53; { mp1 = LONG clr          }
   {                                            mp2 = USHORT codeClr    }
    FNTM_UPDATEPREVIEW    =WM_USER+54; { mp1 = HWND hWndPreview  }
    FNTM_FILTERLIST       =WM_USER+55; { mp1 = PSZ pszFacename   }
   {                                            mp2 = USHORT usStrStyle }
   {                                            mr=TRUE(Add),FALSE(Dont)}

   {********************************************************************}
   { Stylechange message parameter structure                            }
   {********************************************************************}
TYPE
    PSTYLECHANGE=^STYLECHANGE;
    STYLECHANGE=RECORD
                     usWeight:USHORT;
                     usWeightOld:USHORT;
                     usWidth:USHORT;
                     usWidthOld:USHORT;
                     flType:ULONG;
                     flTypeOld:ULONG;
                     flTypeMask:ULONG;
                     flTypeMaskOld:ULONG;
                     flStyle:ULONG;
                     flStyleOld:ULONG;
                     flStyleMask:ULONG;
                     flStyleMaskOld:ULONG;
           END;


   {********************************************************************}
   { font dialog and control id's                                       }
   {********************************************************************}
CONST
    DID_FONT_DIALOG         =300;
    DID_NAME                =301;
    DID_STYLE               =302;
    DID_DISPLAY_FILTER      =303;
    DID_PRINTER_FILTER      =304;
    DID_SIZE                =305;
    DID_SAMPLE              =306;
    DID_OUTLINE             =307;
    DID_UNDERSCORE          =308;
    DID_STRIKEOUT           =309;
    DID_HELP_BUTTON         =310;
    DID_APPLY_BUTTON        =311;
    DID_RESET_BUTTON        =312;
    DID_OK_BUTTON           =DID_OK;
    DID_CANCEL_BUTTON       =DID_CANCEL;
    DID_NAME_PREFIX         =313;
    DID_STYLE_PREFIX        =314;
    DID_SIZE_PREFIX         =315;
    DID_SAMPLE_GROUPBOX     =316;
    DID_EMPHASIS_GROUPBOX   =317;
    DID_FONT_ISO_SUPPORT    =318;
    DID_FONT_ISO_UNTESTED   =319;

   {********************************************************************}
   { Stringtable id's                                                   }
   {********************************************************************}
    IDS_FONT_SAMPLE           =350;
    IDS_FONT_BLANK            =351;
    IDS_FONT_KEY_0            =352;
    IDS_FONT_KEY_9            =353;
    IDS_FONT_KEY_SEP          =354;
    IDS_FONT_DISP_ONLY        =355;
    IDS_FONT_PRINTER_ONLY     =356;
    IDS_FONT_COMBINED         =357;
    IDS_FONT_WEIGHT1          =358;
    IDS_FONT_WEIGHT2          =359;
    IDS_FONT_WEIGHT3          =360;
    IDS_FONT_WEIGHT4          =361;
    IDS_FONT_WEIGHT5          =362;
    IDS_FONT_WEIGHT6          =363;
    IDS_FONT_WEIGHT7          =364;
    IDS_FONT_WEIGHT8          =365;
    IDS_FONT_WEIGHT9          =366;
    IDS_FONT_WIDTH1           =367;
    IDS_FONT_WIDTH2           =368;
    IDS_FONT_WIDTH3           =369;
    IDS_FONT_WIDTH4           =370;
    IDS_FONT_WIDTH5           =371;
    IDS_FONT_WIDTH6           =372;
    IDS_FONT_WIDTH7           =373;
    IDS_FONT_WIDTH8           =374;
    IDS_FONT_WIDTH9           =375;
    IDS_FONT_OPTION0          =376;
    IDS_FONT_OPTION1          =377;
    IDS_FONT_OPTION2          =378;
    IDS_FONT_OPTION3          =379;
    IDS_FONT_POINT_SIZE_LIST  =380;

   {********************************************************************}
   {                                                                    }
   {                          S P I N    B U T T O N                    }
   {                                                                    }
   {********************************************************************}

   {********************************************************************}
   { SPINBUTTON Creation Flags                                          }
   {********************************************************************}

   {********************************************************************}
   { Character Acceptance                                               }
   {********************************************************************}
CONST
    SPBS_ALLCHARACTERS =$00000000; { Default: All chars accepted }
    SPBS_NUMERICONLY   =$00000001; { Only 0 - 9 accepted & VKeys }
    SPBS_READONLY      =$00000002; { No chars allowed in entryfld}

   {********************************************************************}
   { Type of Component                                                  }
   {********************************************************************}
    SPBS_MASTER        =$00000010;
    SPBS_SERVANT       =$00000000; { Default: Servant            }

   {********************************************************************}
   { Type of Justification                                              }
   {********************************************************************}
    SPBS_JUSTDEFAULT  =$00000000; { Default: Same as Left        }
    SPBS_JUSTLEFT     =$00000008;
    SPBS_JUSTRIGHT    =$00000004;
    SPBS_JUSTCENTER   =$0000000C;

   {********************************************************************}
   { Border or not                                                      }
   {********************************************************************}
    SPBS_NOBORDER     =$00000020; { Borderless SpinField         }
   {                                       Default is to have a border. }

   {********************************************************************}
   { Fast spin or not                                                   }
   {********************************************************************}
    SPBS_FASTSPIN     =$00000100; { Allow fast spinning.  Fast   }
   {                                       spinning is performed by     }
   {                                       skipping over numbers        }

   {********************************************************************}
   { Pad numbers on front with 0's                                      }
   {********************************************************************}
    SPBS_PADWITHZEROS =$00000080; { Pad the number with zeroes   }

   {********************************************************************}
   { SPINBUTTON Messages                                                }
   {********************************************************************}

   {********************************************************************}
   { Notification from Spinbutton to the application is sent in a       }
   { WM_CONTROL message.                                                }
   {********************************************************************}
    SPBN_UPARROW       =$20A;     { up arrow button was pressed  }
    SPBN_DOWNARROW     =$20B;     { down arrow button was pressed}
    SPBN_ENDSPIN       =$20C;     { mouse button was released    }
    SPBN_CHANGE        =$20D;     { spinfield text has changed   }
    SPBN_SETFOCUS      =$20E;     { spinfield received focus     }
    SPBN_KILLFOCUS     =$20F;     { spinfield lost focus         }

   {********************************************************************}
   { Messages from application to Spinbutton                            }
   {********************************************************************}
    SPBM_OVERRIDESETLIMITS =$200; { Set spinbutton limits without}
   {                                        resetting the current value }
    SPBM_QUERYLIMITS       =$201; { Query limits set by          }
   {                                        SPBM_SETLIMITS              }
    SPBM_SETTEXTLIMIT      =$202; { Max entryfield characters    }
    SPBM_SPINUP            =$203; { Tell entry field to spin up  }
    SPBM_SPINDOWN          =$204; { Tell entry field to spin down}
    SPBM_QUERYVALUE        =$205; { Tell entry field to send     }
   {                                        current value               }

   {********************************************************************}
   { Query Flags                                                        }
   {********************************************************************}
    SPBQ_UPDATEIFVALID   =0;      { Default                      }
    SPBQ_ALWAYSUPDATE    =1;
    SPBQ_DONOTUPDATE     =3;

   {********************************************************************}
   { Return value for Empty Field.                                      }
   {    If ptr too long, variable sent in query msg                     }
   {********************************************************************}
    SPBM_SETARRAY          =$206; { Change the data to spin      }
    SPBM_SETLIMITS         =$207; { Change the numeric Limits    }
    SPBM_SETCURRENTVALUE   =$208; { Change the current value     }
    SPBM_SETMASTER         =$209; { Tell entryfield who master is}

   {********************************************************************}
   {                                                                    }
   {                D I R E C T   M A N I P U L A T I O N               }
   {                                                                    }
   {********************************************************************}

    PMERR_NOT_DRAGGING     =$1f00;
    PMERR_ALREADY_DRAGGING =$1f01;

    MSGF_DRAG              =$0010;   { message filter identifier }

    WM_DRAGFIRST           =$0310;
    WM_DRAGLAST            =$032f;

    DM_DROP                =$032f;
    DM_DRAGOVER            =$032e;
    DM_DRAGLEAVE           =$032d;
    DM_DROPHELP            =$032c;
    DM_ENDCONVERSATION     =$032b;
    DM_PRINT               =$032a;
    DM_RENDER              =$0329;
    DM_RENDERCOMPLETE      =$0328;
    DM_RENDERPREPARE       =$0327;
    DM_DRAGFILECOMPLETE    =$0326;
    DM_EMPHASIZETARGET     =$0325;
    DM_DRAGERROR           =$0324;
    DM_FILERENDERED        =$0323;
    DM_RENDERFILE          =$0322;
    DM_DRAGOVERNOTIFY      =$0321;
    DM_PRINTOBJECT         =$0320;
    DM_DISCARDOBJECT       =$031f;

    DRT_ASM               ='Assembler Code';  { drag type constants  }
    DRT_BASIC             ='BASIC Code';
    DRT_BINDATA           ='Binary Data';
    DRT_BITMAP            ='Bitmap';
    DRT_C                 ='C Code';
    DRT_COBOL             ='COBOL Code';
    DRT_DLL               ='Dynamic Link Library';
    DRT_DOSCMD            ='DOS Command File';
    DRT_EXE               ='Executable';
    DRT_FORTRAN           ='FORTRAN Code';
    DRT_ICON              ='Icon';
    DRT_LIB               ='Library';
    DRT_METAFILE          ='Metafile';
    DRT_OS2CMD            ='OS/2 Command File';
    DRT_PASCAL            ='Pascal Code';
    DRT_RESOURCE          ='Resource File';
    DRT_TEXT              ='Plain Text';
    DRT_UNKNOWN           ='Unknown';

    DOR_NODROP             =$0000;  { DM_DRAGOVER response codes }
    DOR_DROP               =$0001;
    DOR_NODROPOP           =$0002;
    DOR_NEVERDROP          =$0003;

    DO_COPYABLE            =$0001;  { supported operation flags  }
    DO_MOVEABLE            =$0002;
    DO_LINKABLE            =$0004;

    DC_OPEN                =$0001;  { source control flags       }
    DC_REF                 =$0002;
    DC_GROUP               =$0004;
    DC_CONTAINER           =$0008;
    DC_PREPARE             =$0010;
    DC_REMOVEABLEMEDIA     =$0020;

    DO_DEFAULT             =$BFFE;  { Default operation          }
    DO_UNKNOWN             =$BFFF;  { Unknown operation          }
    DO_COPY                =$0010;
    DO_MOVE                =$0020;
    DO_LINK                =$0018;
    DO_CREATE              =$0040;

    DMFL_TARGETSUCCESSFUL  =$0001;  { transfer reply flags       }
    DMFL_TARGETFAIL        =$0002;
    DMFL_NATIVERENDER      =$0004;
    DMFL_RENDERRETRY       =$0008;
    DMFL_RENDEROK          =$0010;
    DMFL_RENDERFAIL        =$0020;

    DRG_ICON          =$00000001;   { drag image manipulation    }
    DRG_BITMAP        =$00000002;   {   flags                    }
    DRG_POLYGON       =$00000004;
    DRG_STRETCH       =$00000008;
    DRG_TRANSPARENT   =$00000010;
    DRG_CLOSED        =$00000020;

    DME_IGNOREABORT       =1;       { DM_DRAGERROR return values }
    DME_IGNORECONTINUE    =2;
    DME_REPLACE           =3;
    DME_RETRY             =4;

    DF_MOVE                =$0001;   { DM_DRAGFILECOMPLETE flags  }
    DF_SOURCE              =$0002;
    DF_SUCCESSFUL          =$0004;

    DRR_SOURCE           =1;
    DRR_TARGET           =2;
    DRR_ABORT            =3;

    DFF_MOVE              =1;       { DM_DRAGERROR operation IDs }
    DFF_COPY              =2;
    DFF_DELETE            =3;

TYPE
   HSTR=LHANDLE;

   PDRAGITEM=^DRAGITEM;
   DRAGITEM=RECORD
                 hwndItem:HWND;          { conversation partner          }
                 ulItemID:ULONG;         { identifies item being dragged }
                 hstrType:HSTR;          { type of item                  }
                 hstrRMF:HSTR;           { rendering mechanism and format}
                 hstrContainerName:HSTR; { name of source container      }
                 hstrSourceName:HSTR;    { name of item at source        }
                 hstrTargetName:HSTR;    { suggested name of item at dest}
                 cxOffset:SHORT;         { x offset of the origin of the }
                 cyOffset:SHORT;         { y offset of the origin of the }
                 fsControl:USHORT;       { source item control flags     }
                 fsSupportedOps:USHORT;  { ops supported by source       }
            END;

   PDRAGINFO=^DRAGINFO;
   DRAGINFO=RECORD
                 cbDraginfo:ULONG;       { Size of DRAGINFO and DRAGITEMs}
                 cbDragitem:USHORT;      { size of DRAGITEM              }
                 usOperation:USHORT;     { current drag operation        }
                 hwndSource:HWND;        { window handle of source       }
                 xDrop:SHORT;            { x coordinate of drop position }
                 yDrop:SHORT;            { y coordinate of drop position }
                 cditem:USHORT;          { count of DRAGITEMs            }
                 usReserved:USHORT;      { reserved for future use       }
            END;

   PDRAGIMAGE=^DRAGIMAGE;
   DRAGIMAGE=RECORD
                 cb:USHORT;              { size control block            }
                 cptl:USHORT;            { count of pts, if DRG_POLYGON  }
                 hImage:LHANDLE;         { image handle passed to DrgDrag}
                 sizlStretch:SIZEL;      { size to strecth ico or bmp to }
                 fl:ULONG;               { flags passed to DrgDrag       }
                 cxOffset:SHORT;         { x offset of the origin of the }
                 cyOffset:SHORT;         { y offset of the origin of the }
             END;

   PDRAGTRANSFER=^DRAGTRANSFER;
   DRAGTRANSFER=RECORD
                 cb:ULONG;               { size of control block         }
                 hwndClient:HWND;        { handle of target              }
                 pditem:PDRAGITEM;       { DRAGITEM being transferred    }
                 hstrSelectedRMF:HSTR;   { rendering mech & fmt of choice}
                 hstrRenderToName:HSTR;  { name source will use          }
                 ulTargetInfo:ULONG;     { reserved for target's use     }
                 usOperation:USHORT;     { operation being performed     }
                 fsReply:USHORT;         { reply flags                   }
               END;

   PRENDERFILE=^RENDERFILE;
   RENDERFILE=RECORD
                 hwndDragFiles:HWND;     { conversation window           }
                 hstrSource:HSTR;        { handle to source file name    }
                 hstrTarget:HSTR;        { handle to target file name    }
                 fMove:USHORT;           { TRUE - move, FALSE - copy     }
                 usRsvd:USHORT;          { reserved                      }
              END;

   {********************************************************************}
   {                                                                    }
   {                         C O N T A I N E R                          }
   {                                                                    }
   {********************************************************************}

   {********************************************************************}
   { Error constants                                                    }
   {********************************************************************}
CONST
    PMERR_NOFILTERED_ITEMS          =$1f02;
    PMERR_COMPARISON_FAILED         =$1f03;
    PMERR_RECORD_CURRENTLY_INSERTED =$1f04;
    PMERR_FI_CURRENTLY_INSERTED     =$1f05;

   {********************************************************************}
   { Container control styles.                                          }
   {********************************************************************}
    CCS_EXTENDSEL             =$00000001;
    CCS_MULTIPLESEL           =$00000002;
    CCS_SINGLESEL             =$00000004;
    CCS_AUTOPOSITION          =$00000008;
    CCS_VERIFYPOINTERS        =$00000010;
    CCS_READONLY              =$00000020;
    CCS_MINIRECORDCORE        =$00000040;

   {********************************************************************}
   { view identifiers           (flWindowAttr)                          }
   {********************************************************************}
    CV_TEXT                  =$00000001;  { text view            }
    CV_NAME                  =$00000002;  { name view            }
    CV_ICON                  =$00000004;  { icon view            }
    CV_DETAIL                =$00000008;  { detail view          }
    CV_FLOW                  =$00000010;  { flow items           }
    CV_MINI                  =$00000020;  { use mini icon        }
    CV_TREE                  =$00000040;  { tree view            }

   {********************************************************************}
   { Container Attributes        (flWindowAttr)                         }
   {********************************************************************}
    CA_CONTAINERTITLE        =$00000200;
    CA_TITLESEPARATOR        =$00000400;
    CA_TITLELEFT             =$00000800;
    CA_TITLERIGHT            =$00001000;
    CA_TITLECENTER           =$00002000;
    CA_OWNERDRAW             =$00004000;
    CA_DETAILSVIEWTITLES     =$00008000;
    CA_ORDEREDTARGETEMPH     =$00010000;
    CA_DRAWBITMAP            =$00020000;
    CA_DRAWICON              =$00040000;
    CA_TITLEREADONLY         =$00080000;
    CA_OWNERPAINTBACKGROUND  =$00100000;
    CA_MIXEDTARGETEMPH       =$00200000;
    CA_TREELINE              =$00400000;

   {********************************************************************}
   { child window IDs                                                   }
   {********************************************************************}
    CID_LEFTCOLTITLEWND     =$7FF0;  { column title (left)       }
    CID_RIGHTCOLTITLEWND    =$7FF1;  { right column title        }
    CID_BLANKBOX            =$7FF2;  { blank box at bottom right }
    CID_HSCROLL             =$7FF3;  { horizontal scroll bar     }
    CID_RIGHTHSCROLL        =$7FF4;  { right horz scroll bar     }
    CID_CNRTITLEWND         =$7FF5;  { Container title window    }
    CID_LEFTDVWND           =$7FF7;  { Left Details View window  }
    CID_RIGHTDVWND          =$7FF8;  { Right Details View window }
    CID_VSCROLL             =$7FF9;  { vertical scroll bar       }
    CID_MLE                 =$7FFA;  { MLE window for direct edit}

   {********************************************************************}
   { Bitmap descriptor array element.                                   }
   {********************************************************************}
TYPE
   PTREEITEMDESC=^TREEITEMDESC;
   TREEITEMDESC=RECORD
                     hbmExpanded:HBITMAP;
                     hbmCollapsed:HBITMAP;
                     hptrExpanded:HPOINTER;
                     hptrCollapsed:HPOINTER;
                END;

   {********************************************************************}
   { Field Info data structure, attribute and data types, CV_DETAIL     }
   {********************************************************************}
TYPE
   PFIELDINFO=^FIELDINFO;
   FIELDINFO=RECORD
                   cb:ULONG;          { size of FIELDINFO struct       }
                   flData:ULONG;      { attributes of field's data     }
                   flTitle:ULONG;     { attributes of field's title    }
                   pTitleData:POINTER;{ title data (default is string) }
                                      { If CFT_BITMAP, must be HBITMAP }
                   offStruct:ULONG;   { offset from RECORDCORE to data }
                   pUserData:POINTER; { pointer to user data           }
                   pNextFieldInfo:PFIELDINFO; { pointer to next linked }
                   cxWidth:ULONG;     { width of field in pels         }
             END;

   {********************************************************************}
   { RECORDCORE data structure , attribute values                       }
   {********************************************************************}
TYPE
   PRECORDCORE=^RECORDCORE;
   RECORDCORE=RECORD
                    cb:ULONG;
                    flRecordAttr:ULONG;{ record attributes             }
                    ptlIcon:POINTL;    { Position of CV_ICON item      }
                    preccNextRecord:PRECORDCORE; { ptr to next record  }
                    pszIcon:PChar;     { Text for CV_ICON view         }
                    hptrIcon:HPOINTER; { Icon to display for ~CV_MINI  }
                    hptrMiniIcon:HPOINTER; { Icon to display for CV_MINI   }
                    hbmBitmap:HBITMAP; { Bitmap to display for ~CV_MINI}
                    hbmMiniBitmap:HBITMAP; { Bitmap to display for CV_MINI }
                    pTreeItemDesc:PTREEITEMDESC; { Icons for the tree view       }
                    pszText:PChar;     { Text for CV_TEXT view         }
                    pszName:PChar;     { Text for CV_NAME view         }
                    pszTree:PChar;     { Text for CV_TREE view         }
              END;

   {********************************************************************}
   { MINIRECORDCORE data structure, attribute values                    }
   {********************************************************************}
TYPE
    PMINIRECORDCORE=^MINIRECORDCORE;
    MINIRECORDCORE=RECORD
                        cb:ULONG;
                        flRecordAttr:ULONG; { record attributes             }
                        ptlIcon:POINTL;     { Position of CV_ICON item      }
                        preccNextRecord:PmINIRECORDCORE; {ptr to next record }
                        pszIcon:PChar;      { Text for CV_ICON view         }
                        hptrIcon:HPOINTER;  { Icon to display for ~CV_MINI  }
                   END;

   {********************************************************************}
   { CNRINFO data structure, describes the container control.           }
   {********************************************************************}
TYPE
   PCNRINFO=^CNRINFO;
   CNRINFO=RECORD
                 cb:ULONG;             { size of CNRINFO struct        }
                 pSortRecord:POINTER;  { ptr to sort function          }
                 pFieldInfoLast:PFIELDINFO; { pointer to last column in}
                                       {   left pane of a split window.}
                 pFieldInfoObject:PFIELDINFO; { Pointer to a column to
                                                represent an object.
                                                This is the column which
                                                will receive
                                                IN-USE emphasis.       }
                 pszCnrTitle:PChar;    { text for container title. One
                                           string separated by line
                                           separators for multi-lines  }
                 flWindowAttr:ULONG;   { container attrs - CV_*, CA_*  }
                 ptlOrigin:POINTL;     { lower-left origin in virtual
                                         coordinates. CV_ICON view   }
                 cDelta:ULONG;         { Application defined threshold
                                         or number of records from
                                         either end of the list.     }
                 cRecords:ULONG;       { number of records in container}
                 slBitmapOrIcon:SIZEL; { size of bitmap in pels        }
                 slTreeBitmapOrIcon:SIZEL;  { size of tree bitmaps in pels  }
                 hbmExpanded:HBITMAP;  { bitmap  for tree node         }
                 hbmCollapsed:HBITMAP; { bitmap  for tree node         }
                 hptrExpanded:HPOINTER;{ icon    for tree node         }
                 hptrCollapsed:HPOINTER;{ icon    for tree node        }
                 cyLineSpacing:LONG;   { space between two rows        }
                 cxTreeIndent:LONG;    { indent for children           }
                 cxTreeLine:LONG;      { thickness of the Tree Line    }
                 cFields:ULONG;        { number of fields  in container}
                 xVertSplitbar:LONG;   { position relative to the
                                         container (CV_DETAIL); if
                                         =$FFFF then unsplit         }
        END;

   PCDATE=^CDATE;
   CDATE=RECORD
               day:UCHAR;                  { current day               }
               month:UCHAR;                { current month             }
               year:USHORT;                { current year              }
         END;

   PCTIME=^CTIME;
   CTIME=RECORD
               hours:UCHAR;                { current hour              }
               minutes:UCHAR;              { current minute            }
               seconds:UCHAR;              { current second            }
               ucReserved:UCHAR;           { reserved                  }
         END;

   {********************************************************************}
   { attribute and type values for flData and flTitle members of        }
   { FIELDINFO, CFA_ (attributes), CFT_ (types)                         }
   {********************************************************************}
CONST
    CFA_LEFT            =$00000001; { left align text            }
    CFA_RIGHT           =$00000002; { right align text           }
    CFA_CENTER          =$00000004; { center text                }
    CFA_TOP             =$00000008; { top-align text             }
    CFA_VCENTER         =$00000010; { vertically center text     }
    CFA_BOTTOM          =$00000020; { bottom-align text          }
    CFA_INVISIBLE       =$00000040; { Specify invisible column.  }
    CFA_BITMAPORICON    =$00000100; { field title is bitmap      }
    CFA_SEPARATOR       =$00000200; { vert sep, right of fld     }
    CFA_HORZSEPARATOR   =$00000400; { horz sep, bottom of fld    }

    CFA_STRING          =$00000800; { string of characters       }
    CFA_OWNER           =$00001000; { ownerdraw field            }
    CFA_DATE            =$00002000; { date structure             }
    CFA_TIME            =$00004000; { time structure             }
    CFA_FIREADONLY      =$00008000; { Column is read-only.       }
    CFA_FITITLEREADONLY =$00010000; { Column Title is read-only  }
    CFA_ULONG           =$00020000; { Column is number format    }

   {********************************************************************}
   { attribute values for flRecordAttr member of RECORDCORE             }
   {********************************************************************}
    CRA_SELECTED        =$00000001; { record is selected         }
    CRA_TARGET          =$00000002; { record has target emphasis }
    CRA_CURSORED        =$00000004; { cursor is on the record    }
    CRA_INUSE           =$00000008; { record has in-use emphasis }
    CRA_FILTERED        =$00000010; { record has been filtered   }
    CRA_DROPONABLE      =$00000020; { record can be dropped on   }
    CRA_RECORDREADONLY  =$00000040; { record is read-only        }
    CRA_EXPANDED        =$00000080; { record is expanded         }
    CRA_COLLAPSED       =$00000100; { record is collapsed        }
    CRA_SOURCE          =$00040000;

   {********************************************************************}
   { Container messages                                                 }
   {********************************************************************}
    CM_ALLOCDETAILFIELDINFO       =$0330;
    CM_ALLOCRECORD                =$0331;
    CM_ARRANGE                    =$0332;
    CM_ERASERECORD                =$0333;
    CM_FILTER                     =$0334;
    CM_FREEDETAILFIELDINFO        =$0335;
    CM_FREERECORD                 =$0336;
    CM_HORZSCROLLSPLITWINDOW      =$0337;
    CM_INSERTDETAILFIELDINFO      =$0338;
    CM_INSERTRECORD               =$0339;
    CM_INVALIDATEDETAILFIELDINFO  =$033a;
    CM_INVALIDATERECORD           =$033b;
    CM_PAINTBACKGROUND            =$033c;
    CM_QUERYCNRINFO               =$033d;
    CM_QUERYDETAILFIELDINFO       =$033e;
    CM_QUERYDRAGIMAGE             =$033f;
    CM_QUERYRECORD                =$0340;
    CM_QUERYRECORDEMPHASIS        =$0341;
    CM_QUERYRECORDFROMRECT        =$0342;
    CM_QUERYRECORDRECT            =$0343;
    CM_QUERYVIEWPORTRECT          =$0344;
    CM_REMOVEDETAILFIELDINFO      =$0345;
    CM_REMOVERECORD               =$0346;
    CM_SCROLLWINDOW               =$0347;
    CM_SEARCHSTRING               =$0348;
    CM_SETCNRINFO                 =$0349;
    CM_SETRECORDEMPHASIS          =$034a;
    CM_SORTRECORD                 =$034b;
    CM_OPENEDIT                   =$034c;
    CM_CLOSEEDIT                  =$034d;
    CM_COLLAPSETREE               =$034e;
    CM_EXPANDTREE                 =$034f;
    CM_QUERYRECORDINFO            =$0350;

   {********************************************************************}
   { Container notifications                                            }
   {********************************************************************}
    CN_DRAGAFTER                 =101;
    CN_DRAGLEAVE                 =102;
    CN_DRAGOVER                  =103;
    CN_DROP                      =104;
    CN_DROPHELP                  =105;
    CN_ENTER                     =106;
    CN_INITDRAG                  =107;
    CN_EMPHASIS                  =108;
    CN_KILLFOCUS                 =109;
    CN_SCROLL                    =110;
    CN_QUERYDELTA                =111;
    CN_SETFOCUS                  =112;
    CN_REALLOCPSZ                =113;
    CN_BEGINEDIT                 =114;
    CN_ENDEDIT                   =115;
    CN_COLLAPSETREE              =116;
    CN_EXPANDTREE                =117;
    CN_HELP                      =118;
    CN_CONTEXTMENU               =119;

   {********************************************************************}
   {   Data Structures for Message Parameters                           }
   {********************************************************************}

   {********************************************************************}
   { Container Direct Manipulation structures                           }
   {********************************************************************}
TYPE
   PCNDRAGINIT=^CNRDRAGINIT;
   CNRDRAGINIT=RECORD
                    hwndCnr:HWND;          { Container window handle   }
                    pRecord:PRECORDCORE;   { record under mouse ptr    }
                    x:LONG;                { x coordinate of mouse ptr }
                    y:LONG;                { y coordinate of mouse ptr }
                    cx:LONG;               { x offset from record      }
                    cy:LONG;               { y offset from record      }
               END;

   {********************************************************************}
   { Data structure for CM_INSERTDETAILFIELDINFO                        }
   { This structure is used by the application to specify the position  }
   { of the FieldInfo structures they are inserting.                    }
   {********************************************************************}
TYPE
   PFIELDINFOINSERT=^FIELDINFOINSERT;
   FIELDINFOINSERT=RECORD
                        cb:ULONG;      { Size of structure.             }
                        pFieldInfoOrder:PFIELDINFO; { Specifies the order of the
                                                      FieldInfo structures. }
                        fInvalidateFieldInfo:ULONG;{ Invalidate on Insert. }
                        cFieldInfoInsert:ULONG;    { The number of FieldInfo
                                                      structures to insert. }
                   END;

   {********************************************************************}
   { Data structure for CM_INSERTRECORD                                 }
   {********************************************************************}
TYPE
   PRECORDINSERT=^RECORDINSERT;
   RECORDINSERT=RECORD
                     cb:ULONG;
                     pRecordOrder:PRECORDCORE;
                     pRecordParent:PRECORDCORE;
                     fInvalidateRecord:ULONG;
                     zOrder:ULONG;
                     cRecordsInsert:ULONG;
                END;

   {********************************************************************}
   { Data structure for CM_QUERYRECORDFROMRECT                          }
   {********************************************************************}
TYPE
   PQUERYRECFROMRECT=^QUERYRECFROMRECT;
   QUERYRECFROMRECT=RECORD
                         cb:ULONG;
                         rect:RECTL;
                         fsSearch:ULONG;
                    END;

   {********************************************************************}
   { Data structure for CM_QUERYRECORDRECT                              }
   {********************************************************************}
TYPE
   PQUERYRECODRECT=^QUERYRECORDRECT;
   QUERYRECORDRECT=RECORD
                         cb:ULONG;
                         pRecord:PRECORDCORE;
                         fRightSplitWindow:ULONG;
                         fsExtent:ULONG;
                   END;

   {********************************************************************}
   { Data structure for CM_SEARCHSTRING                                 }
   {********************************************************************}
TYPE
   PSEARCHSTRRING=^SEARCHSTRING;
   SEARCHSTRING=RECORD
                     cb:ULONG;
                     pszSearch:PChar;
                     fsPrefix:ULONG;
                     fsCaseSensitive:ULONG;
                     usView:ULONG;
                END;

   {*****************************************************************}
   { Data Structure for CN_DRAGLEAVE,CN_DRAGOVER,CN_DROP,CN_DROPHELP }
   {*****************************************************************}
TYPE
    PCNRDRAGINFO=^CNRDRAGINFO;
    CNRDRAGINFO=RECORD
                      pDragInfo:PDRAGINFO;
                      pRecord:PRECORDCORE;
                END;

   {********************************************************************}
   { Data structure for CN_EMPHASIS                                     }
   {********************************************************************}
TYPE
   PNOTIFYRECORDEMPHASIS=^NOTIFYRECORDEMPHASIS;
   NOTIFYRECORDEMPHASIS=RECORD
                             hwndCnr:HWND;
                             pRecord:PRECORDCORE;
                             fEmphasisMask:ULONG;
                        END;

   {********************************************************************}
   { Data structure for CN_ENTER                                        }
   {********************************************************************}
TYPE
   PNOTIFYRECORDENTER=^NOTIFYRECORDENTER;
   NOTIFYRECORDENTER=RECORD
                           hwndCnr:HWND;
                           fKey:ULONG;
                           pRecord:PRECORDCORE;
                     END;

   {********************************************************************}
   { Data structure for CN_QUERYDELTA                                   }
   {********************************************************************}
TYPE
   PNOTIFYDELTA=^NOTIFYDELTA;
   NOTIFYDELTA=RECORD
                     hwndCnr:HWND;
                     fDelta:ULONG;
               END;

   {********************************************************************}
   { Data structure for CN_SCROLL                                       }
   {********************************************************************}
TYPE
   PNOTIFYSCROLL=^NOTIFYSCROLL;
   NOTIFYSCROLL=RECORD
                      hwndCnr:HWND;
                      lScrollInc:LONG;
                      fScroll:ULONG;
                END;

   {********************************************************************}
   { Data structure for CN_REALLOCPSZ                                   }
   {********************************************************************}
TYPE
   PCNREDITDATA=^CNREDITDATA;
   CNREDITDATA=RECORD
                     cb:ULONG;
                     hwndCnr:HWND;
                     pRecord:PRECORDCORE;
                     pFieldInfo:PFIELDINFO;
                     ppszText:^PChar;          { address of PSZ        }
                     cbText:ULONG;             { size of the new text  }
                     id:ULONG;
               END;

   {********************************************************************}
   { Data structure for CM_PAINTBACKGROUND                              }
   {********************************************************************}
TYPE
   POWNERBACKGROUND=^OWNERBACKGROUND;
   OWNERBACKGROUND=RECORD
                         hwnd:HWND;
                         hps:HPS;
                         rclBackground:RECTL;
                         idWindow:LONG;
                   END;

   {********************************************************************}
   { Data structure used as part of WM_DRAWITEM                         }
   {********************************************************************}
TYPE
   PCNRDRAWITEMINFO=^CNRDRAWITEMINFO;
   CNRDRAWITEMINFO=RECORD
                        pRecord:PRECORDCORE;
                        pFieldInfo:PFIELDINFO;
                   END;

   {********************************************************************}
   { Message parameter flags                                            }
   {********************************************************************}
CONST
    CMA_TOP              =$0001;       { Place at top of zorder   }
    CMA_BOTTOM           =$0002;      { Place at bottom of zorder}
    CMA_LEFT             =$0004;
    CMA_RIGHT            =$0008;

    CMA_FIRST            =$0010;      { Add record as first      }
    CMA_LAST             =$0020;
    CMA_END              =$0040;      { Add record to end of list}
    CMA_PREV             =$0080;
    CMA_NEXT             =$0100;

    CMA_HORIZONTAL       =$0200;
    CMA_VERTICAL         =$0400;
    CMA_ICON             =$0800;
    CMA_TEXT             =$1000;
    CMA_PARTIAL          =$2000;
    CMA_COMPLETE         =$4000;

    CMA_PARENT           =$0001;
    CMA_FIRSTCHILD       =$0002;
    CMA_LASTCHILD        =$0004;

    CMA_CNRTITLE         =$0001;      { Container title          }
    CMA_DELTA            =$0002;      { Application defined      }
    CMA_FLWINDOWATTR     =$0004;      { Container attributes     }
    CMA_LINESPACING      =$0008;
    CMA_PFIELDINFOLAST   =$0010;      { Ptr to last column in    }

    CMA_PSORTRECORD      =$0020;      { Pointer to sort function }
    CMA_PTLORIGIN        =$0040;      { Lower left origin        }
    CMA_SLBITMAPORICON   =$0080;      { Size  of bitmap          }
    CMA_XVERTSPLITBAR    =$0100;      { Splitbar position        }
    CMA_PFIELDINFOOBJECT =$0200;      { Pointer to IN-USE        }
   {                                             emphasis column.       }

    CMA_TREEICON           =$0400;    { Icon for tree node      }
    CMA_TREEBITMAP         =$0800;    { bitmap for tree node    }
    CMA_CXTREEINDENT       =$1000;    { indent for children     }
    CMA_CXTREELINE         =$2000;    { thickness of tree line  }
    CMA_SLTREEBITMAPORICON =$4000;    { size of icon of tree node }

    CMA_ITEMORDER        =$0001;      { QueryRecord search flags }
    CMA_WINDOW           =$0002;
    CMA_WORKSPACE        =$0004;
    CMA_ZORDER           =$0008;

    CMA_DELTATOP         =$0001;      { Industrial - top delta   }
    CMA_DELTABOT         =$0002;      { Industrial - bottom delta}
    CMA_DELTAHOME        =$0004;      { Industrial - top of list }
    CMA_DELTAEND         =$0008;      { Industrial - end of list }

    CMA_NOREPOSITION     =$0001;      { InvalidateRecord flags   }
    CMA_REPOSITION       =$0002;
    CMA_TEXTCHANGED      =$0004;
    CMA_ERASE            =$0008;

    CMA_FREE             =$0001;
    CMA_INVALIDATE       =$0002;

   {********************************************************************}
   {                                                                    }
   {                            S L I D E R                             }
   {                                                                    }
   {********************************************************************}

   {********************************************************************}
   { Define messages for the slider control                             }
   {********************************************************************}
CONST
    SLM_ADDDETENT          =$0369;   { Add detent niche          }
    SLM_QUERYDETENTPOS     =$036a;   { Query position of detent  }
    SLM_QUERYSCALETEXT     =$036b;   { Query text at tick number }
    SLM_QUERYSLIDERINFO    =$036c;   { Query slider information  }
    SLM_QUERYTICKPOS       =$036d;   { Query position of tick    }
    SLM_QUERYTICKSIZE      =$036e;   { Query size of tick        }
    SLM_REMOVEDETENT       =$036f;   { Remove detent niche       }
    SLM_SETSCALETEXT       =$0370;   { Set text above tick       }
    SLM_SETSLIDERINFO      =$0371;   { Set slider parameters     }
    SLM_SETTICKSIZE        =$0372;   { Set size of tick          }
    SLN_CHANGE             =1;       { Slider position changed   }
    SLN_SLIDERTRACK        =2;       { Slider dragged by user    }
    SLN_SETFOCUS           =3;       { Slider gaining focus      }
    SLN_KILLFOCUS          =4;       { Slider losing focus       }

   {********************************************************************}
   { Slider control data structure                                      }
   {********************************************************************}
TYPE
   PSLDCDATA=^SLDCDATA;
   SLDCDATA=RECORD
                 cbSize:ULONG;       { Size of control block             }
                 usScale1Increments:USHORT;    { # of divisions on scale }
                 usScale1Spacing:USHORT;{ Space in pels between increments}
                 usScale2Increments:USHORT;    { # of divisions on scale }
                 usScale2Spacing:USHORT;{ Space in pels between increments}
            END;

   {********************************************************************}
   { Slider control style flag definition                               }
   {********************************************************************}
CONST
    SLS_HORIZONTAL       =$00000000; { Orient slider horizontally}
    SLS_VERTICAL         =$00000001; { Orient slider vertically  }
    SLS_CENTER           =$00000000; { Center shaft in window    }
    SLS_BOTTOM           =$00000002; { Offset shaft to bottom (H)}
    SLS_TOP              =$00000004; { Offset shaft to top (H)   }
    SLS_LEFT             =$00000002; { Offset shaft to left (V)  }
    SLS_RIGHT            =$00000004; { Offset shaft to right (V) }
    SLS_SNAPTOINCREMENT  =$00000008; { Snap to nearest increment }
    SLS_BUTTONSBOTTOM    =$00000010; { Add buttons at shaft bot. }
    SLS_BUTTONSTOP       =$00000020; { Add buttons at shaft top  }
    SLS_BUTTONSLEFT      =$00000010; { Add buttons left of shaft }
    SLS_BUTTONSRIGHT     =$00000020; { Add buttons right of shaft}
    SLS_OWNERDRAW        =$00000040; { Owner draw some fields    }
    SLS_READONLY         =$00000080; { Provide a read only slider}
    SLS_RIBBONSTRIP      =$00000100; { Provide a ribbon strip    }
    SLS_HOMEBOTTOM       =$00000000; { Set home position at bot. }
    SLS_HOMETOP          =$00000200; { Set home position at top  }
    SLS_HOMELEFT         =$00000000; { Set home position at left }
    SLS_HOMERIGHT        =$00000200; { Set home position at right}
    SLS_PRIMARYSCALE1    =$00000000; { Scale 1 is primary scale  }
    SLS_PRIMARYSCALE2    =$00000400; { Scale 2 is primary scale  }

   {********************************************************************}
   { Message attributes for setting and querying slider components      }
   {********************************************************************}
    SMA_SCALE1               =$0001;
    SMA_SCALE2               =$0002;
    SMA_SHAFTDIMENSIONS      =$0000;
    SMA_SHAFTPOSITION        =$0001;
    SMA_SLIDERARMDIMENSIONS  =$0002;
    SMA_SLIDERARMPOSITION    =$0003;
    SMA_RANGEVALUE           =$0000;
    SMA_INCREMENTVALUE       =$0001;
    SMA_SETALLTICKS          =$FFFF;

   {********************************************************************}
   { Ownerdraw flag definitions                                         }
   {********************************************************************}
    SDA_RIBBONSTRIP          =$0001;
    SDA_SLIDERSHAFT          =$0002;
    SDA_BACKGROUND           =$0003;
    SDA_SLIDERARM            =$0004;

   {********************************************************************}
   { Error return codes                                                 }
   {********************************************************************}
    PMERR_UPDATE_IN_PROGRESS     =$1f06;
    SLDERR_INVALID_PARAMETERS    =-1;

   {********************************************************************}
   {                                                                    }
   {                         V A L U E   S E T                          }
   {                                                                    }
   {********************************************************************}

   {********************************************************************}
   { Define messages for the value set control                          }
   {********************************************************************}
CONST
    VM_QUERYITEM           =$0375;   { Query item at location    }
    VM_QUERYITEMATTR       =$0376;   { Query item attributes     }
    VM_QUERYMETRICS        =$0377;   { Query metrics of control  }
    VM_QUERYSELECTEDITEM   =$0378;   { Query selected item       }
    VM_SELECTITEM          =$0379;   { Set selected item         }
    VM_SETITEM             =$037a;   { Set item at location      }
    VM_SETITEMATTR         =$037b;   { Set item attributes       }
    VM_SETMETRICS          =$037c;   { Set metrics of control    }

    VN_SELECT              =120;     { Item selected by user     }
    VN_ENTER               =121;     { Item entered by user      }
    VN_DRAGLEAVE           =122;     { Drag left control         }
    VN_DRAGOVER            =123;     { Drag is over item         }
    VN_DROP                =124;     { Drop occurred on item     }
    VN_DROPHELP            =125;     { Request help for drop     }
    VN_INITDRAG            =126;     { Drag initiated on item    }
    VN_SETFOCUS            =127;     { Value set gaining focus   }
    VN_KILLFOCUS           =128;     { Value set losing focus    }
    VN_HELP                =129;     { Help requested by user    }

   {********************************************************************}
   { Value set control data structure                                   }
   {********************************************************************}
TYPE
   PVSCDATA=^VSCDATA;
   VSCDATA=RECORD
                 cbSize:ULONG;         { Size of control block             }
                 usRowCount:USHORT;    { Number of rows in value set       }
                 usColumnCount:USHORT; { Number of columns in value set    }
           END;

   {********************************************************************}
   { Value set drag initialization structure                            }
   {********************************************************************}
TYPE
   PVSDRAGINIT=^VSDRAGINIT;
   VSDRAGINIT=RECORD
                    hwnd:HWND;      { Window handle of value set control}
                    x:LONG;          { X coordinate of pointer on desktop}
                    y:LONG;          { Y coordinate of pointer on desktop}
                    cx:LONG;         { X offset from pointer hot spot    }
                    cy:LONG;         { Y offset from pointer hot spot    }
                    usRow:USHORT;    { Number of rows in value set       }
                    usColumn:USHORT; { Number of columns in value set    }
              END;

      {*****************************************************************}
      { Value set drag information structure                            }
      {*****************************************************************}
TYPE
      PVSDRAGINFO=^VSDRAGINFO;
      VSDRAGINFO=RECORD
                       pDragInfo:PDRAGINFO; { Pointer to a drag info structure }
                       usRow:USHORT;         { Number of rows in value set      }
                       usColumn:USHORT;      { Number of columns in value set   }
                 END;

   {********************************************************************}
   { Value set query item text structure                                }
   {********************************************************************}
TYPE
   PVSTEXT=^VSTEXT;
   VSTEXT=RECORD
               pszItemText:PChar;   { Pointer to string for item text      }
               ulBufLen:ULONG;      { Length of buffer to copy string into }
          END;

   {********************************************************************}
   { Value set control style flag definition                            }
   {********************************************************************}
CONST
    VS_BITMAP       =$0001;  { Default all items to bitmaps      }
    VS_ICON         =$0002;  { Default all items to icons        }
    VS_TEXT         =$0004;  { Default all items to text strings }
    VS_RGB          =$0008;  { Default all items to color info   }
    VS_COLORINDEX   =$0010;  { Default all items to color indices}
    VS_BORDER       =$0020;  { Add a border around the control   }
    VS_ITEMBORDER   =$0040;  { Add a border around each item     }
    VS_SCALEBITMAPS =$0080;  { Scale bitmaps to cell size        }
    VS_RIGHTTOLEFT  =$0100;  { Support right to left ordering    }
    VS_OWNERDRAW    =$0200;  { Owner draws value set background  }

   {********************************************************************}
   { Value set item attribute definition                                }
   {********************************************************************}
    VIA_BITMAP       =$0001; { If set, item contains a bitmap    }
    VIA_ICON         =$0002; { If set, item contains an icon     }
    VIA_TEXT         =$0004; { If set, item contains text string }
    VIA_RGB          =$0008; { If set, item contains color value }
    VIA_COLORINDEX   =$0010; { If set, item contains color index }
    VIA_OWNERDRAW    =$0020; { If set, item is ownerdraw         }
    VIA_DISABLED     =$0040; { If set, item is unselectable      }
    VIA_DRAGGABLE    =$0080; { If set, item can be source of drag}
    VIA_DROPONABLE   =$0100; { If set, item can be target of drop}

   {********************************************************************}
   { Message parameter attributes for sizing and spacing of items       }
   {********************************************************************}
    VMA_ITEMSIZE             =$0001;
    VMA_ITEMSPACING          =$0002;

   {********************************************************************}
   { Ownerdraw flag definitions                                         }
   {********************************************************************}
    VDA_ITEM                 =$0001;
    VDA_ITEMBACKGROUND       =$0002;
    VDA_SURROUNDING          =$0003;
    VDA_BACKGROUND           =$0004;

   {********************************************************************}
   { Error return codes                                                 }
   {********************************************************************}
    VSERR_INVALID_PARAMETERS    =-1;

   {********************************************************************}
   {                                                                    }
   {                          N O T E B O O K                           }
   {                                                                    }
   {********************************************************************}

   {********************************************************************}
   { Message ids                                                        }
   {********************************************************************}
CONST
    BKM_CALCPAGERECT         =$0353; { Calc book/page rectangle  }
    BKM_DELETEPAGE           =$0354; { Delete page(s)            }
    BKM_INSERTPAGE           =$0355; { Insert page               }
    BKM_INVALIDATETABS       =$0356; { Invalidate tab area       }
    BKM_TURNTOPAGE           =$0357; { Turn to page              }
    BKM_QUERYPAGECOUNT       =$0358; { Query number of pages     }
    BKM_QUERYPAGEID          =$0359; { Query page identifier     }
    BKM_QUERYPAGEDATA        =$035a; { Query page user data      }
    BKM_QUERYPAGEWINDOWHWND  =$035b; { Query page window handle  }
    BKM_QUERYTABBITMAP       =$035c; { Query tab bitmap handle   }
    BKM_QUERYTABTEXT         =$035d; { Query tab text pointer    }
    BKM_SETDIMENSIONS        =$035e; { Set tab/dogear dimensions }
    BKM_SETPAGEDATA          =$035f; { Set page user data        }
    BKM_SETPAGEWINDOWHWND    =$0360; { Set page window handle    }
    BKM_SETSTATUSLINETEXT    =$0361; { Set status line text      }
    BKM_SETTABBITMAP         =$0362; { Set tab bitmap            }
    BKM_SETTABTEXT           =$0363; { Set tab text              }
    BKM_SETNOTEBOOKCOLORS    =$0364; { Set Notebook colors       }
    BKM_QUERYPAGESTYLE       =$0365; { Query page style          }
    BKM_QUERYSTATUSLINETEXT  =$0366; { Query status line text    }

    BKN_PAGESELECTED         =130;   { New page selected by user }
    BKN_NEWPAGESIZE          =131;   { App page size changed     }
    BKN_HELP                 =132;   { Help notification         }
    BKN_PAGEDELETED          =133;   { Page deleted notification }

   {********************************************************************}
   { Page deletion flags (usDeleteFlag)                                 }
   {********************************************************************}
    BKA_ALL                  =$0001; { all pages                 }
    BKA_SINGLE               =$0002; { single page               }
    BKA_TAB                  =$0004; { minor/major section       }

   {********************************************************************}
   { Page insertion/query order (usPageOrder, usQueryOrder)             }
   {********************************************************************}
    BKA_LAST                 =$0002; { Insert/Query last page    }
    BKA_FIRST                =$0004; { Insert/Query first page   }
    BKA_NEXT                 =$0008; { Insert/Query after page   }
    BKA_PREV                 =$0010; { Insert/Query before page  }
    BKA_TOP                  =$0020; { Query topmost page        }

   {********************************************************************}
   { Notebook region types (usBookRegion, usType)                       }
   {********************************************************************}
    BKA_MAJORTAB             =$0001; { Major Tab                 }
    BKA_MINORTAB             =$0002; { Minor Tab                 }
    BKA_PAGEBUTTON           =$0100; { Page Turning Button       }

   {********************************************************************}
   { Page insertion/query styles (usPageStyle,usQueryEnd)               }
   {********************************************************************}
    BKA_STATUSTEXTON         =$0001; { status area text          }
    BKA_MAJOR                =$0040; { Major Tab                 }
    BKA_MINOR                =$0080; { Minor Tab                 }
    BKA_AUTOPAGESIZE         =$0100; { Page window position/size }
    BKA_END                  =$0200; { Query to end of book      }

   {********************************************************************}
   { Tab window contents (usTabDisplay)                                 }
   {********************************************************************}
    BKA_TEXT                 =$0400; { text data                 }
    BKA_BITMAP               =$0800; { bitmap                    }

   {********************************************************************}
   { Notebook window styles (ulNotebookStyles)                          }
   {********************************************************************}

   {********************************************************************}
   { Backpage Orientation                                               }
   {********************************************************************}
    BKS_BACKPAGESBR          =$00000001; { Bottom right          }
    BKS_BACKPAGESBL          =$00000002; { Bottom left           }
    BKS_BACKPAGESTR          =$00000004; { Top right             }
    BKS_BACKPAGESTL          =$00000008; { Top left              }

   {********************************************************************}
   { Major Tab Side                                                     }
   {********************************************************************}
    BKS_MAJORTABRIGHT        =$00000010; { Major tabs right      }
    BKS_MAJORTABLEFT         =$00000020; { Major tabs left       }
    BKS_MAJORTABTOP          =$00000040; { Major tabs top        }
    BKS_MAJORTABBOTTOM       =$00000080; { Major tabs bottom     }

   {********************************************************************}
   { Tab Type                                                           }
   {********************************************************************}
    BKS_SQUARETABS           =$00000000; { Square edged tabs     }
    BKS_ROUNDEDTABS          =$00000100; { Round edged tabs      }
    BKS_POLYGONTABS          =$00000200; { Polygon edged tabs    }

   {********************************************************************}
   { Binding type                                                       }
   {********************************************************************}
    BKS_SOLIDBIND            =$00000000; { Solid binding         }
    BKS_SPIRALBIND           =$00000400; { Spiral binding        }
    BKS_COLORTABS            =$00000800; { Color tabs}

   {********************************************************************}
   { Status line text justification                                     }
   {********************************************************************}
    BKS_STATUSTEXTLEFT       =$00000000; { Left justify text     }
    BKS_STATUSTEXTRIGHT      =$00001000; { Right justify text    }
    BKS_STATUSTEXTCENTER     =$00002000; { Center text           }

   {********************************************************************}
   { Tab text justification                                             }
   {********************************************************************}
    BKS_TABTEXTLEFT          =$00000000; { Left justify tab text }
    BKS_TABTEXTRIGHT         =$00004000; { Right justify tab text}
    BKS_TABTEXTCENTER        =$00008000; { Center tab text       }

   {********************************************************************}
   { Notebook color presentation param attributes                       }
   {********************************************************************}
    BKA_BACKGROUNDPAGECOLORINDEX  =$0001;{ Page Background       }
    BKA_BACKGROUNDPAGECOLOR       =$0002;
    BKA_BACKGROUNDMAJORCOLORINDEX =$0003;{ Major Tab Background  }
    BKA_BACKGROUNDMAJORCOLOR      =$0004;
    BKA_BACKGROUNDMINORCOLORINDEX =$0005;{ Minor Tab Background  }
    BKA_BACKGROUNDMINORCOLOR      =$0006;
    BKA_FOREGROUNDMAJORCOLORINDEX =$0007;{ Major Tab Text        }
    BKA_FOREGROUNDMAJORCOLOR      =$0008;
    BKA_FOREGROUNDMINORCOLORINDEX =$0009;{ Minor Tab Text        }
    BKA_FOREGROUNDMINORCOLOR      =$000A;

   {********************************************************************}
   { Error message ids                                                  }
   {********************************************************************}
    BOOKERR_INVALID_PARAMETERS  =-1; { Invalid parameters        }

   {********************************************************************}
   { BKM_QUERYTABTEXT and BKM_QUERYSTATUSLINETEXT message structure     }
   {********************************************************************}
TYPE
   PBOOKTEXT=^BOOKTEXT;
   BOOKTEXT=RECORD
                 apString:PChar;             { ptr to string buffer      }
                 textLen:ULONG;              { length of string to query }
            END;

   {********************************************************************}
   { BKN_PAGEDELETED notify message structure                           }
   {********************************************************************}
TYPE
   PDELETENOTIFY=^DELETENOTIFY;
   DELETENOTIFY=RECORD
                     hwndBook:HWND;          { Notebook window handle    }
                     hwndPage:HWND;          { App. page window handle   }
                     ulAppPageData:ULONG;    { App. page data            }
                     hbmTab:HBITmAP;         { App. tab bitmap handle    }
                END;

   {********************************************************************}
   { BKN_PAGESELECTED notify message structure                          }
   {********************************************************************}
TYPE
   PPAGESELECTNOTIFY=^PAGESELECTNOTIFY;
   PAGESELECTNOTIFY=RECORD
                         hwndBook:HWND;      { Notebook window handle    }
                         ulPageIdCur:ULONG;  { Previous top page id      }
                         ulPageIdNew:ULONG;  { New top Page id           }
                    END;


IMPORTS

FUNCTION WinFileDlg(hwndP,hwndO:HWND;VAR pfild:FILEDLG):HWND;
                    APIENTRY;                'PMCTLS' index 4;
FUNCTION WinDefFileDlgProc(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM):MRESULT;
                    APIENTRY;                'PMCTLS' index 5;
FUNCTION WinFreeFileDlgList(papszFQFilename:PAPSZ):BOOL;
                    APIENTRY;                'PMCTLS' index 6;
FUNCTION WinFontDlg(hwndP,hwndO:HWND;VAR pfntd:FONTDLG):HWND;
                    APIENTRY;                'PMCTLS' index 2;
FUNCTION WinDefFontDlgProc(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM):MRESULT;
                    APIENTRY;                'PMCTLS' index 3;
FUNCTION DrgAcceptDroppedFiles(ahwnd:HWND;VAR pszPath,pszTypes:PSZ;
                               ulDefaultOp,ulRsvd:ULONG):BOOL;
                    APIENTRY;                'PMDRAG' index 66;
FUNCTION DrgAllocDragInfo(cditem:ULONG):PDRAGINFO;
                    APIENTRY;                'PMDRAG' index 34;
FUNCTION DrgAllocDragtransfer(cdxfer:ULONG):PDRAGTRANSFER;
                    APIENTRY;                'PMDRAG' index 35;
FUNCTION DrgDrag(hwndSource:HWND;VAR pdinfo:DRAGINFO;VAR pdimg:DRAGIMAGE;
                 cdimg:ULONG;vkTerminate:LONG;VAR pRsvd):HWND;
                    APIENTRY;                'PMDRAG' index 38;
FUNCTION DrgDragFiles(ahwnd:HWND;VAR apszFiles,apszTypes,apszTargets:PSZ;
                      cFiles:ULONG;hptrDrag:HPOINTER;vkTerm:ULONG;
                      fSourceRender:BOOL;ulRsvd:ULONG):BOOL;
                    APIENTRY;                'PMDRAG' index 65;
FUNCTION DrgPostTransferMsg(ahwnd:HWND;msg:ULONG;VAR pdxfer:DRAGTRANSFER;
                            fl,ulRsvd:ULONG;fRetry:BOOL):BOOL;
                    APIENTRY;                'PMDRAG' index 42;
FUNCTION DrgQueryDragitem(VAR pdinfo:DRAGINFO;cbBuffer:ULONG;
                          VAR pditem:DRAGITEM;iItem:ULONG):BOOL;
                    APIENTRY;                'PMDRAG' index 44;
FUNCTION DrgQueryDragitemCount(VAR pdinfo:DRAGINFO):ULONG;
                    APIENTRY;                'PMDRAG' index 45;
FUNCTION DrgQueryDragitemPtr(VAR pdinfo:DRAGINFO;i:ULONG):PDRAGITEM;
                    APIENTRY;                'PMDRAG' index 46;
FUNCTION DrgQueryNativeRMF(VAR pditem:DRAGITEM;cbBuffer:ULONG;
                           VAR pBuffer):BOOL;
                    APIENTRY;                'PMDRAG' index 47;
FUNCTION DrgQueryNativeRMFLen(VAR pditem:DRAGITEM):ULONG;
                    APIENTRY;                'PMDRAG' index 48;
FUNCTION DrgQueryStrName(ahstr:HSTR;cbBuffer:ULONG;VAR pBuffer:PSZ):ULONG;
                    APIENTRY;                'PMDRAG' index 49;
FUNCTION DrgQueryStrNameLen(ahstr:HSTR):ULONG;
                    APIENTRY;                'PMDRAG' index 50;
FUNCTION DrgQueryTrueType(VAR pditem:DRAGITEM;cbBuffer:ULONG;
                          VAR pBuffer:PSZ):BOOL;
                    APIENTRY;                'PMDRAG' index 51;
FUNCTION DrgQueryTrueTypeLen(VAR pditem:DRAGITEM):ULONG;
                    APIENTRY;                'PMDRAG' index 52;
FUNCTION DrgSendTransferMsg(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM):MRESULT;
                    APIENTRY;                'PMDRAG' index 54;
FUNCTION DrgSetDragitem(VAR pdinfo:DRAGINFO;VAR pditem:DRAGITEM;
                        cbBuffer,iItem:ULONG):BOOL;
                    APIENTRY;                'PMDRAG' index 57;
FUNCTION DrgSetDragImage(VAR pdinfo:DRAGINFO;VAR pdimg:DRAGIMAGE;
                         cdimg:ULONG;VAR pRsvd):BOOL;
                    APIENTRY;                'PMDRAG' index 56;
FUNCTION DrgVerifyTypeSet(VAR pditem:DRAGITEM;VAR pszType:PSZ;cbMatch:ULONG;
                          VAR pszMatch:PSZ):BOOL;
                    APIENTRY;                'PMDRAG' index 62;
FUNCTION DrgAccessDraginfo(pdinfo:PDRAGINFO):BOOL;
                    APIENTRY;                'PMDRAG' index 32;
FUNCTION DrgAddStrHandle(VAR apsz:PSZ):HSTR;
                    APIENTRY;                'PMDRAG' index 33;
FUNCTION DrgDeleteDraginfoStrHandles(VAR pdinfo:DRAGINFO):BOOL;
                    APIENTRY;                'PMDRAG' index 36;
FUNCTION DrgDeleteStrHandle(ahstr:HSTR):BOOL;
                    APIENTRY;                'PMDRAG' index 37;
FUNCTION DrgFreeDraginfo(pdinfo:PDRAGINFO):BOOL;
                    APIENTRY;                'PMDRAG' index 39;
FUNCTION DrgFreeDragtransfer(VAR pdxfer:DRAGTRANSFER):BOOL;
                    APIENTRY;                'PMDRAG' index 40;
FUNCTION DrgGetPS(ahwnd:HWND):HPS;
                    APIENTRY;                'PMDRAG' index 41;
FUNCTION DrgPushDraginfo(VAR pdinfo:DRAGINFO;hwndDest:HWND):BOOL;
                    APIENTRY;                'PMDRAG' index 43;
FUNCTION DrgReleasePS(ahps:HPS):BOOL;
                    APIENTRY;                'PMDRAG' index 53;
FUNCTION DrgSetDragPointer(VAR pdinfo:DRAGINFO;hptr:HPOINTER):BOOL;
                    APIENTRY;                'PMDRAG' index 55;
FUNCTION DrgVerifyNativeRMF(VAR pditem:DRAGITEM;VAR pszRMF:PSZ):BOOL;
                    APIENTRY;                'PMDRAG' index 58;
FUNCTION DrgVerifyRMF(VAR pditem:DRAGITEM;VAR pszMech,pszFmt:PSZ):BOOL;
                    APIENTRY;                'PMDRAG' index 59;
FUNCTION DrgVerifyTrueType(VAR pditem:DRAGITEM;VAR pszType:PSZ):BOOL;
                    APIENTRY;                'PMDRAG' index 60;
FUNCTION DrgVerifyType(VAR pditem:DRAGITEM;VAR pszType:PSZ):BOOL;
                    APIENTRY;                'PMDRAG' index 61;
END;

IMPLEMENTATION

BEGIN
END.

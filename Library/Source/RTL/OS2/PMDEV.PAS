
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PmDev;

{****************************************************************************
 *                                                                          *
 * OS/2 Presentation Manager Device Context constants, types and            *
 * function declarations                                                    *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def;

{ General DEV return values }
CONST
      DEV_ERROR                       =0;
      DEV_OK                          =1;

   { DC type for DevOpenDC }
      OD_QUEUED                       =2;
      OD_DIRECT                       =5;
      OD_INFO                         =6;
      OD_METAFILE                     =7;
      OD_MEMORY                       =8;
      OD_METAFILE_NOQUERY             =9;

   { codes for DevQueryCaps }
      CAPS_FAMILY                     =0;
      CAPS_IO_CAPS                    =1;
      CAPS_TECHNOLOGY                 =2;
      CAPS_DRIVER_VERSION             =3;
      CAPS_WIDTH                      =4;      { pels            }
      CAPS_HEIGHT                     =5;      { pels            }
      CAPS_WIDTH_IN_CHARS             =6;
      CAPS_HEIGHT_IN_CHARS            =7;
      CAPS_HORIZONTAL_RESOLUTION      =8;      { pels per meter  }
      CAPS_VERTICAL_RESOLUTION        =9;      { pels per meter  }
      CAPS_CHAR_WIDTH                 =10;      { pels            }
      CAPS_CHAR_HEIGHT                =11;      { pels            }
      CAPS_SMALL_CHAR_WIDTH           =12;      { pels            }
      CAPS_SMALL_CHAR_HEIGHT          =13;      { pels            }
      CAPS_COLORS                     =14;
      CAPS_COLOR_PLANES               =15;
      CAPS_COLOR_BITCOUNT             =16;
      CAPS_COLOR_TABLE_SUPPORT        =17;
      CAPS_MOUSE_BUTTONS              =18;
      CAPS_FOREGROUND_MIX_SUPPORT     =19;
      CAPS_BACKGROUND_MIX_SUPPORT     =20;
      CAPS_DEVICE_WINDOWING           =31;
      CAPS_ADDITIONAL_GRAPHICS        =32;
      CAPS_VIO_LOADABLE_FONTS         =21;
      CAPS_WINDOW_BYTE_ALIGNMENT      =22;
      CAPS_BITMAP_FORMATS             =23;
      CAPS_RASTER_CAPS                =24;
      CAPS_MARKER_HEIGHT              =25;      { pels            }
      CAPS_MARKER_WIDTH               =26;      { pels            }
      CAPS_DEVICE_FONTS               =27;
      CAPS_GRAPHICS_SUBSET            =28;
      CAPS_GRAPHICS_VERSION           =29;
      CAPS_GRAPHICS_VECTOR_SUBSET     =30;
      CAPS_PHYS_COLORS                =33;
      CAPS_COLOR_INDEX                =34;
      CAPS_GRAPHICS_CHAR_WIDTH        =35;
      CAPS_GRAPHICS_CHAR_HEIGHT       =36;
      CAPS_HORIZONTAL_FONT_RES        =37;
      CAPS_VERTICAL_FONT_RES          =38;
      CAPS_DEVICE_FONT_SIM            =39;
      CAPS_LINEWIDTH_THICK            =40;
      CAPS_DEVICE_POLYSET_POINTS      =41;

   { Constants for CAPS_IO_CAPS }
      CAPS_IO_DUMMY                   =1;
      CAPS_IO_SUPPORTS_OP             =2;
      CAPS_IO_SUPPORTS_IP             =3;
      CAPS_IO_SUPPORTS_IO             =4;

   { Constants for CAPS_TECHNOLOGY }
      CAPS_TECH_UNKNOWN               =0;
      CAPS_TECH_VECTOR_PLOTTER        =1;
      CAPS_TECH_RASTER_DISPLAY        =2;
      CAPS_TECH_RASTER_PRINTER        =3;
      CAPS_TECH_RASTER_CAMERA         =4;
      CAPS_TECH_POSTSCRIPT            =5;

   { Constants for CAPS_COLOR_TABLE_SUPPORT }
      CAPS_COLTABL_RGB_8              =1;
      CAPS_COLTABL_RGB_8_PLUS         =2;
      CAPS_COLTABL_TRUE_MIX           =4;
      CAPS_COLTABL_REALIZE            =8;

   { Constants for CAPS_FOREGROUND_MIX_SUPPORT }
      CAPS_FM_OR                      =1;
      CAPS_FM_OVERPAINT               =2;
      CAPS_FM_XOR                     =8;
      CAPS_FM_LEAVEALONE             =16;
      CAPS_FM_AND                    =32;
      CAPS_FM_GENERAL_BOOLEAN        =64;

   { Constants for CAPS_BACKGROUND_MIX_SUPPORT }
      CAPS_BM_OR                      =1;
      CAPS_BM_OVERPAINT               =2;
      CAPS_BM_XOR                     =8;
      CAPS_BM_LEAVEALONE             =16;
      CAPS_BM_AND                    =32;
      CAPS_BM_GENERAL_BOOLEAN        =64;
      CAPS_BM_SRCTRANSPARENT        =128;
      CAPS_BM_DESTTRANSPARENT       =256;

   { Constants for CAPS_DEVICE_WINDOWING }
      CAPS_DEV_WINDOWING_SUPPORT      =1;

   { Constants for CAPS_ADDITIONAL_GRAPHICS }
      CAPS_VDD_DDB_TRANSFER            =1;
      CAPS_GRAPHICS_KERNING_SUPPORT    =2;
      CAPS_FONT_OUTLINE_DEFAULT        =4;
      CAPS_FONT_IMAGE_DEFAULT          =8;
   { bits represented by values 16L and 32L are reserved }
      CAPS_SCALED_DEFAULT_MARKERS     =64;
      CAPS_COLOR_CURSOR_SUPPORT      =128;
      CAPS_PALETTE_MANAGER           =256;
      CAPS_COSMETIC_WIDELINE_SUPPORT =512;
      CAPS_DIRECT_FILL              =1024;
      CAPS_REBUILD_FILLS            =2048;
      CAPS_CLIP_FILLS               =$00001000; { 4096L  }
      CAPS_ENHANCED_FONTMETRICS     =$00002000; { 8192L  }
      CAPS_TRANSFORM_SUPPORT        =$00004000; { 16384L }

      { Constants for CAPS_WINDOW_BYTE_ALIGNMENT }
      CAPS_BYTE_ALIGN_REQUIRED        =0;
      CAPS_BYTE_ALIGN_RECOMMENDED     =1;
      CAPS_BYTE_ALIGN_NOT_REQUIRED    =2;

   { Constants for CAPS_RASTER_CAPS }
      CAPS_RASTER_BITBLT              =1;
      CAPS_RASTER_BANDING             =2;
      CAPS_RASTER_BITBLT_SCALING      =4;
      CAPS_RASTER_SET_PEL            =16;
      CAPS_RASTER_FONTS              =32;
      CAPS_RASTER_FLOOD_FILL         =64;

{ structures for DEVESC_QUERYVIOCELLSIZES }

TYPE
    PVIOSIZECOUNT=^VIOSIZECOUNT;
    VIOSIZECOUNT=RECORD
                     maxcount:LONG;
                     count:LONG;
                 END;

    PVIOFONTCELLSIZE=^VIOFONTCELLSIZE;
    VIOFONTCELLSIZE=RECORD
                         cx:LONG;
                         cy:LONG;
                    END;

      { structure for DEVESC_GETSCALINGFACTOR }
    PSFACTORS=^SFACTORS;
    SFACTORS=RECORD
                  x:LONG;
                  y:LONG;
             END;

    { structure for DEVESC_NEXTBAND }
    PBANDRECT=^BANDRECT;
    BANDRECT=RECORD
                   xleft:LONG;
                   ybottom:LONG;
                   xright:LONG;
                   ytop:LONG;
             END;

    { return codes for DevEscape }
CONST
    DEVESC_ERROR                  =-1;
    DEVESC_NOTIMPLEMENTED         =0;

    { codes for DevEscape }
    DEVESC_QUERYESCSUPPORT      =   0;
    DEVESC_GETSCALINGFACTOR     =   1;
    DEVESC_QUERYVIOCELLSIZES    =   2;
    DEVESC_GETCP                =8000;

    DEVESC_STARTDOC             =8150;
    DEVESC_ENDDOC               =8151;
    DEVESC_NEXTBAND             =8152;
    DEVESC_ABORTDOC             =8153;

    DEVESC_NEWFRAME            =16300;
    DEVESC_DRAFTMODE           =16301;
    DEVESC_FLUSHOUTPUT         =16302;
    DEVESC_RAWDATA             =16303;
    DEVESC_SETMODE             =16304;

    DEVESC_DBE_FIRST           =24450;
    DEVESC_DBE_LAST            =24455;

    { DevEscape codes for adding extra space to character strings }
    DEVESC_CHAR_EXTRA          =16998;
    DEVESC_BREAK_EXTRA         =16999;

    { codes for DevEscape PM_Q_ESC spool files }
    DEVESC_STD_JOURNAL         =32600;

    { structure for DEVESC_SETMODE }
TYPE
    PESCMODE=^ESCMODE;
    ESCMODE=RECORD
                 mode:ULONG;
                 modedata:BYTE;
            END;

    { return codes for DevPostDeviceModes }
CONST
     DPDM_ERROR                   =-1;
     DPDM_NONE                    =0;

     { codes for DevPostDeviceModes }
     DPDM_POSTJOBPROP             =0;
     DPDM_CHANGEPROP              =1;
     DPDM_QUERYJOBPROP            =2;

     { string types for DevQueryDeviceNames }
TYPE
     STR8 =CSTRING[7];
     STR16=CSTRING[15];
     STR32=CSTRING[31];
     STR64=CSTRING[63];

     { return code for DevQueryHardcopyCaps }
CONST
     DQHC_ERROR                    =-1;

     { codes for DevQueryHardcopyCaps }
CONST
     HCAPS_CURRENT                 =1;
     HCAPS_SELECTABLE              =2;

     { structure for DevQueryHardcopyCaps }
TYPE
     PHCINFO=^HCINFO;
     HCINFO=RECORD
                  szFormname:CSTRING[31];
                  cx:LONG;
                  cy:LONG;
                  xLeftClip:LONG;
                  yBottomClip:LONG;
                  xRightClip:LONG;
                  yTopClip:LONG;
                  xPels:LONG;
                  yPels:LONG;
                  flAttributes:LONG;
            END;

IMPORTS

FUNCTION DevOpenDC(ahab:HAB;lType:LONG;pszToken:CSTRING;lCount:LONG;
                   VAR pdopData:DEVOPENSTRUC;hdcComp:HDC):HDC;
                   APIENTRY;         'PMGPI' index 610;
FUNCTION DevCloseDC(ahdc:HDC):HMF;
                    APIENTRY;         'PMGPI' index 604;
FUNCTION DevQueryCaps(ahdc:HDC;lStart,lCount:LONG;VAR alArray:LONG):BOOL;
                    APIENTRY;         'PMGPI' index 606;
FUNCTION DevEscape(ahdc:HDC;lCode,lInCount:LONG;VAR pbInData;
                   VAR plOutCount:LONG;VAR pbOutData):LONG;
                    APIENTRY;         'PMGPI' index 605;
FUNCTION DevQueryDeviceNames(ahab:HAB;pszDriverName:CSTRING;VAR pldn:LONG;
                             aDeviceName:STR32;aDeviceDesc:STR64;
                             VAR pldt:LONG;aDataType:STR16):BOOL;
                    APIENTRY;         'PMGPI' index 607;
FUNCTION DevQueryHardcopyCaps(ahdc:HDC;lStartForm,lForms:LONG;
                              VAR phciHcInfo:HCINFO):LONG;
                    APIENTRY;         'PMGPI' index 608;
FUNCTION DevPostDeviceModes(ahab:HAB;VAR pdrivDriverData:DRIVDATA;
                            pszDriverName,pszDeviceName,pszName:CSTRING;
                            flOptions:ULONG):LONG;
                    APIENTRY;         'PMGPI' index 609;
END; {IMPORTS}


IMPLEMENTATION

BEGIN
END.

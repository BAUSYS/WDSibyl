
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT WinGDI;

{****************************************************************************
 *                                                                          *
 * Win32 GDI imports and types                                              *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES WinDef,WinNT;

CONST
       R2_BLACK           = 1;
       R2_NOTMERGEPEN     = 2;
       R2_MASKNOTPEN      = 3;
       R2_NOTCOPYPEN      = 4;
       R2_MASKPENNOT      = 5;
       R2_NOT             = 6;
       R2_XORPEN          = 7;
       R2_NOTMASKPEN      = 8;
       R2_MASKPEN         = 9;
       R2_NOTXORPEN       = 10;
       R2_NOP             = 11;
       R2_MERGENOTPEN     = 12;
       R2_COPYPEN         = 13;
       R2_MERGEPENNOT     = 14;
       R2_MERGEPEN        = 15;
       R2_WHITE           = 16;
       R2_LAST            = 16;

       SRCCOPY            = $00CC0020;
       SRCPAINT           = $00EE0086;
       SRCAND             = $008800C6;
       SRCINVERT          = $00660046;
       SRCERASE           = $00440328;
       NOTSRCCOPY         = $00330008;
       NOTSRCERASE        = $001100A6;
       MERGECOPY          = $00C000CA;
       MERGEPAINT         = $00BB0226;
       PATCOPY            = $00F00021;
       PATPAINT           = $00FB0A09;
       PATINVERT          = $005A0049;
       DSTINVERT          = $00550009;
       BLACKNESS          = $00000042;
       WHITENESS          = $00FF0062;

CONST
       GDI_ERROR          = $FFFFFFFF;
       HGDI_ERROR         = $FFFFFFFF;

CONST
       ERROR              = 0;
       NULLREGION         = 1;
       SIMPLEREGION       = 2;
       COMPLEXREGION      = 3;
       RGN_ERROR          = ERROR;

CONST
       RGN_AND            = 1;
       RGN_OR             = 2;
       RGN_XOR            = 3;
       RGN_DIFF           = 4;
       RGN_COPY           = 5;
       RGN_MIN            = RGN_AND;
       RGN_MAX            = RGN_COPY;

CONST
       BLACKONWHITE               =  1;
       WHITEONBLACK               =  2;
       COLORONCOLOR               =  3;
       HALFTONE                   =  4;
       MAXSTRETCHBLTMODE          =  4;

       ALTERNATE                  =  1;
       WINDING                    =  2;
       POLYFILL_LAST              =  2;

       TA_NOUPDATECP              =  0;
       TA_UPDATECP                =  1;
       TA_LEFT                    =  0;
       TA_RIGHT                   =  2;
       TA_CENTER                  =  6;
       TA_TOP                     =  0;
       TA_BOTTOM                  =  8;
       TA_BASELINE                =  24;
       TA_MASK                    = TA_BASELINE+TA_CENTER+TA_UPDATECP;

       VTA_BASELINE =TA_BASELINE;
       VTA_LEFT     =TA_BOTTOM;
       VTA_RIGHT    =TA_TOP;
       VTA_CENTER   =TA_CENTER;
       VTA_BOTTOM   =TA_RIGHT;
       VTA_TOP      =TA_LEFT;

       ETO_GRAYED                 =  $0001;
       ETO_OPAQUE                 =  $0002;
       ETO_CLIPPED                =  $0004;

       ASPECT_FILTERING           =  $0001;

       DCB_RESET       =$0001;
       DCB_ACCUMULATE  =$0002;
       DCB_DIRTY       =DCB_ACCUMULATE;
       DCB_SET         =DCB_RESET OR DCB_ACCUMULATE;
       DCB_ENABLE      =$0004;
       DCB_DISABLE     =$0008;

CONST
       META_SETBKCOLOR              =$0201;
       META_SETBKMODE               =$0102;
       META_SETMAPMODE              =$0103;
       META_SETROP2                 =$0104;
       META_SETRELABS               =$0105;
       META_SETPOLYFILLMODE         =$0106;
       META_SETSTRETCHBLTMODE       =$0107;
       META_SETTEXTCHAREXTRA        =$0108;
       META_SETTEXTCOLOR            =$0209;
       META_SETTEXTJUSTIFICATION    =$020A;
       META_SETWINDOWORG            =$020B;
       META_SETWINDOWEXT            =$020C;
       META_SETVIEWPORTORG          =$020D;
       META_SETVIEWPORTEXT          =$020E;
       META_OFFSETWINDOWORG         =$020F;
       META_SCALEWINDOWEXT          =$0410;
       META_OFFSETVIEWPORTORG       =$0211;
       META_SCALEVIEWPORTEXT        =$0412;
       META_LINETO                  =$0213;
       META_MOVETO                  =$0214;
       META_EXCLUDECLIPRECT         =$0415;
       META_INTERSECTCLIPRECT       =$0416;
       META_ARC                     =$0817;
       META_ELLIPSE                 =$0418;
       META_FLOODFILL               =$0419;
       META_PIE                     =$081A;
       META_RECTANGLE               =$041B;
       META_ROUNDRECT               =$061C;
       META_PATBLT                  =$061D;
       META_SAVEDC                  =$001E;
       META_SETPIXEL                =$041F;
       META_OFFSETCLIPRGN           =$0220;
       META_TEXTOUT                 =$0521;
       META_BITBLT                  =$0922;
       META_STRETCHBLT              =$0B23;
       META_POLYGON                 =$0324;
       META_POLYLINE                =$0325;
       META_ESCAPE                  =$0626;
       META_RESTOREDC               =$0127;
       META_FILLREGION              =$0228;
       META_FRAMEREGION             =$0429;
       META_INVERTREGION            =$012A;
       META_PAINTREGION             =$012B;
       META_SELECTCLIPREGION        =$012C;
       META_SELECTOBJECT            =$012D;
       META_SETTEXTALIGN            =$012E;
       META_CHORD                   =$0830;
       META_SETMAPPERFLAGS          =$0231;
       META_EXTTEXTOUT              =$0a32;
       META_SETDIBTODEV             =$0d33;
       META_SELECTPALETTE           =$0234;
       META_REALIZEPALETTE          =$0035;
       META_ANIMATEPALETTE          =$0436;
       META_SETPALENTRIES           =$0037;
       META_POLYPOLYGON             =$0538;
       META_RESIZEPALETTE           =$0139;
       META_DIBBITBLT               =$0940;
       META_DIBSTRETCHBLT           =$0b41;
       META_DIBCREATEPATTERNBRUSH   =$0142;
       META_STRETCHDIB              =$0f43;
       META_EXTFLOODFILL            =$0548;
       META_DELETEOBJECT            =$01f0;
       META_CREATEPALETTE           =$00f7;
       META_CREATEPATTERNBRUSH      =$01F9;
       META_CREATEPENINDIRECT       =$02FA;
       META_CREATEFONTINDIRECT      =$02FB;
       META_CREATEBRUSHINDIRECT     =$02FC;
       META_CREATEREGION            =$06FF;

CONST
       NEWFRAME                     =1;
       ABORTDOC                     =2;
       NEXTBAND                     =3;
       SETCOLORTABLE                =4;
       GETCOLORTABLE                =5;
       FLUSHOUTPUT                  =6;
       DRAFTMODE                    =7;
       QUERYESCSUPPORT              =8;
       SETABORTPROC                 =9;
       STARTDOC                     =10;
       ENDDOC                       =11;
       GETPHYSPAGESIZE              =12;
       GETPRINTINGOFFSET            =13;
       GETSCALINGFACTOR             =14;
       MFCOMMENT                    =15;
       GETPENWIDTH                  =16;
       SETCOPYCOUNT                 =17;
       SELECTPAPERSOURCE            =18;
       DEVICEDATA                   =19;
       PASSTHROUGH                  =19;
       GETTECHNOLGY                 =20;
       GETTECHNOLOGY                =20;
       SETLINECAP                   =21;
       SETLINEJOIN                  =22;
       SETMITERLIMIT                =23;
       BANDINFO                     =24;
       DRAWPATTERNRECT              =25;
       GETVECTORPENSIZE             =26;
       GETVECTORBRUSHSIZE           =27;
       ENABLEDUPLEX                 =28;
       GETSETPAPERBINS              =29;
       GETSETPRINTORIENT            =30;
       ENUMPAPERBINS                =31;
       SETDIBSCALING                =32;
       EPSPRINTING                  =33;
       ENUMPAPERMETRICS             =34;
       GETSETPAPERMETRICS           =35;
       POSTSCRIPT_DATA              =37;
       POSTSCRIPT_IGNORE            =38;
       MOUSETRAILS                  =39;
       GETDEVICEUNITS               =42;
       GETEXTENDEDTEXTMETRICS       =256;
       GETEXTENTTABLE               =257;
       GETPAIRKERNTABLE             =258;
       GETTRACKKERNTABLE            =259;
       EXTTEXTOUT                   =512;
       GETFACENAME                  =513;
       DOWNLOADFACE                 =514;
       ENABLERELATIVEWIDTHS         =768;
       ENABLEPAIRKERNING            =769;
       SETKERNTRACK                 =770;
       SETALLJUSTVALUES             =771;
       SETCHARSET                   =772;
       _STRETCHBLT                  =2048;
       GETSETSCREENPARAMS           =3072;
       QUERYDIBSUPPORT              =3073;
       BEGIN_PATH                   =4096;
       CLIP_TO_PATH                 =4097;
       END_PATH                     =4098;
       EXT_DEVICE_CAPS              =4099;
       RESTORE_CTM                  =4100;
       SAVE_CTM                     =4101;
       SET_ARC_DIRECTION            =4102;
       SET_BACKGROUND_COLOR         =4103;
       SET_POLY_MODE                =4104;
       SET_SCREEN_ANGLE             =4105;
       SET_SPREAD                   =4106;
       TRANSFORM_CTM                =4107;
       SET_CLIP_BOX                 =4108;
       SET_BOUNDS                   =4109;
       SET_MIRROR_MODE              =4110;
       OPENCHANNEL                  =4110;
       DOWNLOADHEADER               =4111;
       CLOSECHANNEL                 =4112;
       POSTSCRIPT_PASSTHROUGH       =4115;
       ENCAPSULATED_POSTSCRIPT      =4116;

CONST
       QDI_SETDIBITS                =1;
       QDI_GETDIBITS                =2;
       QDI_DIBTOSCREEN              =4;
       QDI_STRETCHDIB               =8;

       SP_NOTREPORTED               =$4000;
       SP_ERROR                     =-1;
       SP_APPABORT                  =-2;
       SP_USERABORT                 =-3;
       SP_OUTOFDISK                 =-4;
       SP_OUTOFMEMORY               =-5;

       PR_JOBSTATUS                 =$0000;

CONST
       OBJ_PEN             =1;
       OBJ_BRUSH           =2;
       OBJ_DC              =3;
       OBJ_METADC          =4;
       OBJ_PAL             =5;
       OBJ_FONT            =6;
       OBJ_BITMAP          =7;
       OBJ_REGION          =8;
       OBJ_METAFILE        =9;
       OBJ_MEMDC           =10;
       OBJ_EXTPEN          =11;
       OBJ_ENHMETADC       =12;
       OBJ_ENHMETAFILE     =13;

       MWT_IDENTITY        =1;
       MWT_LEFTMULTIPLY    =2;
       MWT_RIGHTMULTIPLY   =3;

       MWT_MIN             =MWT_IDENTITY;
       MWT_MAX             =MWT_RIGHTMULTIPLY;

TYPE
    PXFORM=^XFORM;
    XFORM=RECORD
                eM11:FLOAT;
                eM12:FLOAT;
                eM21:FLOAT;
                eM22:FLOAT;
                eDx:FLOAT;
                eDy:FLOAT;
    END;
    LPXFORM=PXFORM;

    PBITMAP=^BITMAP;
    BITMAP=RECORD
                 bmType:LONG;
                 bmWidth:LONG;
                 bmHeight:LONG;
                 bmWidthBytes:LONG;
                 bmPlanes:WORD;
                 bmBitsPixel:WORD;
                 bmBits:POINTER;
    END;
    LPBITMAP=PBITMAP;
    NPBITMAP=PBITMAP;

    RGBTRIPLE=RECORD
                    rgbtBlue:BYTE;
                    rgbtGreen:BYTE;
                    rgbtRed:BYTE;
    END;

    PRGBQUAD=^RGBQUAD;
    RGBQUAD=RECORD
                  rgbBlue:BYTE;
                  rgbGreen:BYTE;
                  rgbRed:BYTE;
                  rgbReserved:BYTE;
    END;
    LPRGBQUAD=PRGBQUAD;

    PBITMAPCOREHEADER=^BITMAPCOREHEADER;
    BITMAPCOREHEADER=RECORD
                           bcSize:ULONG;
                           bcWidth:WORD;
                           bcHeight:WORD;
                           bcPlanes:WORD;
                           bcBitCount:WORD;
    END;
    LPBITMAPCOREHEADER=PBITMAPCOREHEADER;

    PBITMAPINFOHEADER=^BITMAPINFOHEADER;
    BITMAPINFOHEADER=RECORD
                           biSize:ULONG;
                           biWidth:LONG;
                           biHeight:LONG;
                           biPlanes:WORD;
                           biBitCount:WORD;
                           biCompression:ULONG;
                           biSizeImage:ULONG;
                           biXPelsPerMeter:LONG;
                           biYPelsPerMeter:LONG;
                           biClrUsed:ULONG;
                           biClrImportant:ULONG;
    END;
    LPBITMAPINFOHEADER=PBITMAPINFOHEADER;

CONST
       BI_RGB        =0;
       BI_RLE8       =1;
       BI_RLE4       =2;
       BI_BITFIELDS  =3;

TYPE
    PBITMAPINFO=^BITMAPINFO;
    BITMAPINFO=RECORD
                     bmiHeader:BITMAPINFOHEADER;
                     bmiColors:ARRAY[0..0] OF RGBQUAD;
    END;
    LPBITMAPINFO=PBITMAPINFO;

    PBITMAPCOREINFO=^BITMAPCOREINFO;
    BITMAPCOREINFO=RECORD
                         bmciHeader:BITMAPCOREHEADER;
                         bmciColors:ARRAY[0..0] OF RGBTRIPLE;
    END;
    LPBITMAPCOREINFO=PBITMAPCOREINFO;

    PBITMAPFILEHEADER=^BITMAPFILEHEADER;
    BITMAPFILEHEADER=RECORD
                           bfType:WORD;
                           bfSize:ULONG;
                           bfReserved1:WORD;
                           bfReserved2:WORD;
                           bfOffBits:ULONG;
    END;
    LPBITMAPFILEHEADER=PBITMAPFILEHEADER;

    PHANDLETABLE=^HANDLETABLE;
    HANDLETABLE=RECORD
                      objectHandle:ARRAY[0..0] OF HGDIOBJ;
    END;
    LPHANDLETABLE=PHANDLETABLE;

    PMETARECORD=^METARECORD;
    METARECORD=RECORD
                     rdSize:ULONG;
                     rdFunction:WORD;
                     rdParm:ARRAY[0..0] OF WORD;
    END;
    LPMETARECORD=PMETARECORD;

    PMETAFILEPICT=^METAFILEPICT;
    METAFILEPICT=RECORD
                       mm:LONG;
                       xExt:LONG;
                       yExt:LONG;
                       hMF:HMETAFILE;
    END;
    LPMETAFILEPICT=PMETAFILEPICT;

    PMETAHEADER=^METAHEADER;
    METAHEADER=RECORD
                     mtType:WORD;
                     mtHeaderSize:WORD;
                     mtVersion:WORD;
                     mtSize:ULONG;
                     mtNoObjects:WORD;
                     mtMaxRecord:ULONG;
                     mtNoParameters:WORD;
    END;
    LPMETAHEADER=PMETAHEADER;

    PENHMETARECORD=^ENHMETARECORD;
    ENHMETARECORD=RECORD
                        iType:ULONG;
                        nSize:ULONG;
                        dParm:ARRAY[0..0] OF ULONG;
    END;
    LPENHMETARECORD=PENHMETARECORD;

    PENHMETAHEADER=^ENHMETAHEADER;
    ENHMETAHEADER=RECORD
                        iType:ULONG;
                        nSize:ULONG;
                        rclBounds:RECTL;
                        rclFrame:RECTL;
                        dSignature:ULONG;
                        nVersion:ULONG;
                        nBytes:ULONG;
                        nRecords:ULONG;
                        nHandles:WORD;
                        sReserved:WORD;
                        nDescription:ULONG;
                        offDescription:ULONG;
                        nPalEntries:ULONG;
                        szlDevice:SIZEL;
                        szlMillimeters:SIZEL;
    END;
    LPENHMETAHEADER=PENHMETAHEADER;

CONST
       TMPF_FIXED_PITCH    =$01;
       TMPF_VECTOR         =$02;
       TMPF_DEVICE         =$08;
       TMPF_TRUETYPE       =$04;

TYPE
    PTEXTMETRIC=^TEXTMETRIC;
    TEXTMETRIC=RECORD
                     tmHeight:LONG;
                     tmAscent:LONG;
                     tmDescent:LONG;
                     tmInternalLeading:LONG;
                     tmExternalLeading:LONG;
                     tmAveCharWidth:LONG;
                     tmMaxCharWidth:LONG;
                     tmWeight:LONG;
                     tmOverhang:LONG;
                     tmDigitizedAspectX:LONG;
                     tmDigitizedAspectY:LONG;
                     tmFirstChar:BYTE;
                     tmLastChar:BYTE;
                     tmDefaultChar:BYTE;
                     tmBreakChar:BYTE;
                     tmItalic:BYTE;
                     tmUnderlined:BYTE;
                     tmStruckOut:BYTE;
                     tmPitchAndFamily:BYTE;
                     tmCharSet:BYTE;
    END;
    NPTEXTMETRIC=PTEXTMETRIC;
    LPTEXTMETRIC=PTEXTMETRIC;

CONST
       NTM_REGULAR     =$00000040;
       NTM_BOLD        =$00000020;
       NTM_ITALIC      =$00000001;

TYPE
    PNEWTEXTMETRIC=^NEWTEXTMETRIC;
    NEWTEXTMETRIC=RECORD
                        tmHeight:LONG;
                        tmAscent:LONG;
                        tmDescent:LONG;
                        tmInternalLeading:LONG;
                        tmExternalLeading:LONG;
                        tmAveCharWidth:LONG;
                        tmMaxCharWidth:LONG;
                        tmWeight:LONG;
                        tmOverhang:LONG;
                        tmDigitizedAspectX:LONG;
                        tmDigitizedAspectY:LONG;
                        tmFirstChar:BYTE;
                        tmLastChar:BYTE;
                        tmDefaultChar:BYTE;
                        tmBreakChar:BYTE;
                        tmItalic:BYTE;
                        tmUnderlined:BYTE;
                        tmStruckOut:BYTE;
                        tmPitchAndFamily:BYTE;
                        tmCharSet:BYTE;
                        ntmFlags:ULONG;
                        ntmSizeEM:ULONG;
                        ntmCellHeight:ULONG;
                        ntmAvgWidth:ULONG;
    END;
    NPNEWTEXTMETRIC=PNEWTEXTMETRIC;
    LPNEWTEXTMETRIC=PNEWTEXTMETRIC;

    PPELARRAY=^PELARRAY;
    PELARRAY=RECORD
                   paXCount:LONG;
                   paYCount:LONG;
                   paXExt:LONG;
                   paYExt:LONG;
                   paRGBs:BYTE;
    END;
    NPPELARRAY=PPELARRAY;
    LPPELARRAY=PPELARRAY;

    PLOGBRUSH=^LOGBRUSH;
    LOGBRUSH=RECORD
                   lbStyle:ULONG;
                   lbColor:COLORREF;
                   lbHatch:LONG;
    END;
    NPLOGBRUSH=PLOGBRUSH;
    LPLOGBRUSH=PLOGBRUSH;

    PPATTERN=^PATTERN;
    PATTERN=LOGBRUSH;
    NPPATTERN=PPATTERN;
    LPPATTERN=PPATTERN;

    PLOGPEN=^LOGPEN;
    LOGPEN=RECORD
                 lopnStyle:ULONG;
                 lopnWidth:POINT;
                 lopnColor:COLORREF;
    END;
    NPLOGPEN=PLOGPEN;
    LPLOGPEN=PLOGPEN;

    PEXTLOGPEN=^EXTLOGPEN;
    EXTLOGPEN=RECORD
                    elpPenStyle:ULONG;
                    elpWidth:ULONG;
                    elpBrushStyle:ULONG;
                    elpColor:COLORREF;
                    elpHatch:LONG;
                    elpNumEntries:ULONG;
                    elpStyleEntry:ARRAY[0..0] OF ULONG;
    END;
    NPEXTLOGPEN=PEXTLOGPEN;
    LPEXTLOGPEN=PEXTLOGPEN;

    PPALETTEENTRY=^PALETTEENTRY;
    PALETTEENTRY=RECORD
                       peRed:BYTE;
                       peGreen:BYTE;
                       peBlue:BYTE;
                       peFlags:BYTE;
    END;
    LPPALETTEENTRY=PPALETTEENTRY;

    PLOGPALETTE=^LOGPALETTE;
    LOGPALETTE=RECORD
                     palVersion:WORD;
                     palNumEntries:WORD;
                     palPalEntry:ARRAY[0..0] OF PALETTEENTRY;
    END;
    NPLOGPALETTE=PLOGPALETTE;
    LPLOGPALETTE=PLOGPALETTE;

CONST
     LF_FACESIZE         =32;

TYPE
    PLOGFONT=^LOGFONT;
    LOGFONT=RECORD
                  lfHeight:LONG;
                  lfWidth:LONG;
                  lfEscapement:LONG;
                  lfOrientation:LONG;
                  lfWeight:LONG;
                  lfItalic:BYTE;
                  lfUnderline:BYTE;
                  lfStrikeOut:BYTE;
                  lfCharSet:BYTE;
                  lfOutPrecision:BYTE;
                  lfClipPrecision:BYTE;
                  lfQuality:BYTE;
                  lfPitchAndFamily:BYTE;
                  lfFaceName:CSTRING[LF_FACESIZE-1];
    END;
    NPLOGFONT=PLOGFONT;
    LPLOGFONT=PLOGFONT;

CONST
       LF_FULLFACESIZE     =64;

TYPE
    PENUMLOGFONT=^ENUMLOGFONT;
    ENUMLOGFONT=RECORD
                      elfLogFont:LOGFONT;
                      elfFullName:ARRAY[0..LF_FULLFACESIZE-1] OF BYTE;
                      elfStyle:ARRAY[0..LF_FACESIZE-1] OF BYTE;
    END;
    LPENUMLOGFONT=PENUMLOGFONT;

CONST
       OUT_DEFAULT_PRECIS     = 0;
       OUT_STRING_PRECIS      = 1;
       OUT_CHARACTER_PRECIS   = 2;
       OUT_STROKE_PRECIS      = 3;
       OUT_TT_PRECIS          = 4;
       OUT_DEVICE_PRECIS      = 5;
       OUT_RASTER_PRECIS      = 6;
       OUT_TT_ONLY_PRECIS     = 7;
       OUT_OUTLINE_PRECIS     = 8;
       CLIP_DEFAULT_PRECIS    = 0;
       CLIP_CHARACTER_PRECIS  = 1;
       CLIP_STROKE_PRECIS     = 2;
       CLIP_MASK              = $f;
       CLIP_LH_ANGLES         = 1 SHL 4;
       CLIP_TT_ALWAYS         = 2 SHL 4;
       CLIP_EMBEDDED          = 8 SHL 4;

       DEFAULT_QUALITY        = 0;
       DRAFT_QUALITY          = 1;
       PROOF_QUALITY          = 2;

       DEFAULT_PITCH          = 0;
       FIXED_PITCH            = 1;
       VARIABLE_PITCH         = 2;

       ANSI_CHARSET           = 0;
       DEFAULT_CHARSET        = 1;
       SYMBOL_CHARSET         = 2;
       SHIFTJIS_CHARSET       = 128;
       HANGEUL_CHARSET        = 129;
       GB2312_CHARSET         = 134;
       CHINESEBIG5_CHARSET    = 136;
       JOHAB_CHARSET          = 130;
       HEBREW_CHARSET         = 177;
       ARABIC_CHARSET         = 178;
       GREEK_CHARSET          = 161;
       TURKISH_CHARSET        = 162;
       THAI_CHARSET           = 222;
       EASTEUROPE_CHARSET     = 238;
       RUSSIAN_CHARSET        = 204;
       MAC_CHARSET            = 77;
       BALTIC_CHARSET         = 186;

       OEM_CHARSET            = 255;

CONST
       FF_DONTCARE         =0 SHL 4;
       FF_ROMAN            =1 SHL 4;
       FF_SWISS            =2 SHL 4;
       FF_MODERN           =3 SHL 4;
       FF_SCRIPT           =4 SHL 4;
       FF_DECORATIVE       =5 SHL 4;
       FW_DONTCARE         =0;
       FW_THIN             =100;
       FW_EXTRALIGHT       =200;
       FW_LIGHT            =300;
       FW_NORMAL           =400;
       FW_MEDIUM           =500;
       FW_SEMIBOLD         =600;
       FW_BOLD             =700;
       FW_EXTRABOLD        =800;
       FW_HEAVY            =900;
       FW_ULTRALIGHT       =FW_EXTRALIGHT;
       FW_REGULAR          =FW_NORMAL;
       FW_DEMIBOLD         =FW_SEMIBOLD;
       FW_ULTRABOLD        =FW_EXTRABOLD;
       FW_BLACK            =FW_HEAVY;

       PANOSE_COUNT               =10;
       PAN_FAMILYTYPE_INDEX       = 0;
       PAN_SERIFSTYLE_INDEX       = 1;
       PAN_WEIGHT_INDEX           = 2;
       PAN_PROPORTION_INDEX       = 3;
       PAN_CONTRAST_INDEX         = 4;
       PAN_STROKEVARIATION_INDEX  = 5;
       PAN_ARMSTYLE_INDEX         = 6;
       PAN_LETTERFORM_INDEX       = 7;
       PAN_MIDLINE_INDEX          = 8;
       PAN_XHEIGHT_INDEX          = 9;
       PAN_CULTURE_LATIN          = 0;

TYPE
    PPANOSE=^PANOSE;
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
    END;
    LPPANOSE=PPANOSE;

CONST
       PAN_ANY                        = 0;
       PAN_NO_FIT                     = 1;
       PAN_FAMILY_TEXT_DISPLAY        = 2;
       PAN_FAMILY_SCRIPT              = 3;
       PAN_FAMILY_DECORATIVE          = 4;
       PAN_FAMILY_PICTORIAL           = 5;
       PAN_SERIF_COVE                 = 2;
       PAN_SERIF_OBTUSE_COVE          = 3;
       PAN_SERIF_SQUARE_COVE          = 4;
       PAN_SERIF_OBTUSE_SQUARE_COVE   = 5;
       PAN_SERIF_SQUARE               = 6;
       PAN_SERIF_THIN                 = 7;
       PAN_SERIF_BONE                 = 8;
       PAN_SERIF_EXAGGERATED          = 9;
       PAN_SERIF_TRIANGLE             =10;
       PAN_SERIF_NORMAL_SANS          =11;
       PAN_SERIF_OBTUSE_SANS          =12;
       PAN_SERIF_PERP_SANS            =13;
       PAN_SERIF_FLARED               =14;
       PAN_SERIF_ROUNDED              =15;
       PAN_WEIGHT_VERY_LIGHT          = 2;
       PAN_WEIGHT_LIGHT               = 3;
       PAN_WEIGHT_THIN                = 4;
       PAN_WEIGHT_BOOK                = 5;
       PAN_WEIGHT_MEDIUM              = 6;
       PAN_WEIGHT_DEMI                = 7;
       PAN_WEIGHT_BOLD                = 8;
       PAN_WEIGHT_HEAVY               = 9;
       PAN_WEIGHT_BLACK               =10;
       PAN_WEIGHT_NORD                =11;
       PAN_PROP_OLD_STYLE             = 2;
       PAN_PROP_MODERN                = 3;
       PAN_PROP_EVEN_WIDTH            = 4;
       PAN_PROP_EXPANDED              = 5;
       PAN_PROP_CONDENSED             = 6;
       PAN_PROP_VERY_EXPANDED         = 7;
       PAN_PROP_VERY_CONDENSED        = 8;
       PAN_PROP_MONOSPACED            = 9;
       PAN_CONTRAST_NONE              = 2;
       PAN_CONTRAST_VERY_LOW          = 3;
       PAN_CONTRAST_LOW               = 4;
       PAN_CONTRAST_MEDIUM_LOW        = 5;
       PAN_CONTRAST_MEDIUM            = 6;
       PAN_CONTRAST_MEDIUM_HIGH       = 7;
       PAN_CONTRAST_HIGH              = 8;
       PAN_CONTRAST_VERY_HIGH         = 9;
       PAN_STROKE_GRADUAL_DIAG        = 2;
       PAN_STROKE_GRADUAL_TRAN        = 3;
       PAN_STROKE_GRADUAL_VERT        = 4;
       PAN_STROKE_GRADUAL_HORZ        = 5;
       PAN_STROKE_RAPID_VERT          = 6;
       PAN_STROKE_RAPID_HORZ          = 7;
       PAN_STROKE_INSTANT_VERT        = 8;
       PAN_STRAIGHT_ARMS_HORZ         = 2;
       PAN_STRAIGHT_ARMS_WEDGE        = 3;
       PAN_STRAIGHT_ARMS_VERT         = 4;
       PAN_STRAIGHT_ARMS_SINGLE_SERIF = 5;
       PAN_STRAIGHT_ARMS_DOUBLE_SERIF = 6;
       PAN_BENT_ARMS_HORZ             = 7;
       PAN_BENT_ARMS_WEDGE            = 8;
       PAN_BENT_ARMS_VERT             = 9;
       PAN_BENT_ARMS_SINGLE_SERIF     =10;
       PAN_BENT_ARMS_DOUBLE_SERIF     =11;
       PAN_LETT_NORMAL_CONTACT        = 2;
       PAN_LETT_NORMAL_WEIGHTED       = 3;
       PAN_LETT_NORMAL_BOXED          = 4;
       PAN_LETT_NORMAL_FLATTENED      = 5;
       PAN_LETT_NORMAL_ROUNDED        = 6;
       PAN_LETT_NORMAL_OFF_CENTER     = 7;
       PAN_LETT_NORMAL_SQUARE         = 8;
       PAN_LETT_OBLIQUE_CONTACT       = 9;
       PAN_LETT_OBLIQUE_WEIGHTED      =10;
       PAN_LETT_OBLIQUE_BOXED         =11;
       PAN_LETT_OBLIQUE_FLATTENED     =12;
       PAN_LETT_OBLIQUE_ROUNDED       =13;
       PAN_LETT_OBLIQUE_OFF_CENTER    =14;
       PAN_LETT_OBLIQUE_SQUARE        =15;
       PAN_MIDLINE_STANDARD_TRIMMED   = 2;
       PAN_MIDLINE_STANDARD_POINTED   = 3;
       PAN_MIDLINE_STANDARD_SERIFED   = 4;
       PAN_MIDLINE_HIGH_TRIMMED       = 5;
       PAN_MIDLINE_HIGH_POINTED       = 6;
       PAN_MIDLINE_HIGH_SERIFED       = 7;
       PAN_MIDLINE_CONSTANT_TRIMMED   = 8;
       PAN_MIDLINE_CONSTANT_POINTED   = 9;
       PAN_MIDLINE_CONSTANT_SERIFED   =10;
       PAN_MIDLINE_LOW_TRIMMED        =11;
       PAN_MIDLINE_LOW_POINTED        =12;
       PAN_MIDLINE_LOW_SERIFED        =13;
       PAN_XHEIGHT_CONSTANT_SMALL     = 2;
       PAN_XHEIGHT_CONSTANT_STD       = 3;
       PAN_XHEIGHT_CONSTANT_LARGE     = 4;
       PAN_XHEIGHT_DUCKING_SMALL      = 5;
       PAN_XHEIGHT_DUCKING_STD        = 6;
       PAN_XHEIGHT_DUCKING_LARGE      = 7;
       ELF_VENDOR_SIZE                = 4;

TYPE
    PEXTLOGFONT=^EXTLOGFONT;
    EXTLOGFONT=RECORD
                     elfLogFont:LOGFONT;
                     elfFullName:ARRAY[0..LF_FULLFACESIZE-1] OF BYTE;
                     elfStyle:ARRAY[0..LF_FACESIZE-1] OF BYTE;
                     elfVersion:ULONG;
                     elfStyleSize:ULONG;
                     elfMatch:ULONG;
                     elfReserved:ULONG;
                     elfVendorId:ARRAY[0..ELF_VENDOR_SIZE-1] OF BYTE;
                     elfCulture:ULONG;
                     elfPanose:PANOSE;
    END;
    NPEXTLOGFONT=PEXTLOGFONT;
    LPEXTLOGFONTA=PEXTLOGFONT;

CONST
       ELF_VERSION         =0;
       ELF_CULTURE_LATIN   =0;

       RASTER_FONTTYPE     =$0001;
       DEVICE_FONTTYPE     =$002;
       TRUETYPE_FONTTYPE   =$004;

CONST
       PC_RESERVED     =$01;
       PC_EXPLICIT     =$02;
       PC_NOCOLLAPSE   =$04;

      TRANSPARENT         =1;
      OPAQUE              =2;
      BKMODE_LAST         =2;

      GM_COMPATIBLE       =1;
      GM_ADVANCED         =2;
      GM_LAST             =2;

      PT_CLOSEFIGURE      =$01;
      PT_LINETO           =$02;
      PT_BEZIERTO         =$04;
      PT_MOVETO           =$06;

      MM_TEXT             =1;
      MM_LOMETRIC         =2;
      MM_HIMETRIC         =3;
      MM_LOENGLISH        =4;
      MM_HIENGLISH        =5;
      MM_TWIPS            =6;
      MM_ISOTROPIC        =7;
      MM_ANISOTROPIC      =8;
      MM_MIN              =MM_TEXT;
      MM_MAX              =MM_ANISOTROPIC;
      MM_MAX_FIXEDSCALE   =MM_TWIPS;

      AABSOLUTE           =1;
      RELATIVE            =2;

      WHITE_BRUSH         =0;
      LTGRAY_BRUSH        =1;
      GRAY_BRUSH          =2;
      DKGRAY_BRUSH        =3;
      BLACK_BRUSH         =4;
      NULL_BRUSH          =5;
      HOLLOW_BRUSH        =NULL_BRUSH;
      WHITE_PEN           =6;
      BLACK_PEN           =7;
      NULL_PEN            =8;
      OEM_FIXED_FONT      =10;
      ANSI_FIXED_FONT     =11;
      ANSI_VAR_FONT       =12;
      SYSTEM_FONT         =13;
      DEVICE_DEFAULT_FONT =14;
      DEFAULT_PALETTE     =15;
      SYSTEM_FIXED_FONT   =16;
      STOCK_LAST          =16;

      CLR_INVALID         =$FFFFFFFF;

      BS_SOLID            =0;
      BS_NULL             =1;
      BS_HOLLOW           =BS_NULL;
      BS_HATCHED          =2;
      BS_PATTERN          =3;
      BS_INDEXED          =4;
      BS_DIBPATTERN       =5;
      BS_DIBPATTERNPT     =6;
      BS_PATTERN8X8       =7;
      BS_DIBPATTERN8X8    =8;

      HS_HORIZONTAL       =0;
      HS_VERTICAL         =1;
      HS_FDIAGONAL        =2;
      HS_BDIAGONAL        =3;
      HS_CROSS            =4;
      HS_DIAGCROSS        =5;
      HS_SOLIDCLR         =6;
      HS_DITHEREDCLR      =7;
      HS_SOLIDTEXTCLR     =8;
      HS_DITHEREDTEXTCLR  =9;
      HS_SOLIDBKCLR       =10;
      HS_DITHEREDBKCLR    =11;
      HS_API_MAX          =12;

      PS_SOLID            =0;
      PS_DASH             =1;
      PS_DOT              =2;
      PS_DASHDOT          =3;
      PS_DASHDOTDOT       =4;
      PS_NULL             =5;
      PS_INSIDEFRAME      =6;
      PS_USERSTYLE        =7;
      PS_ALTERNATE        =8;
      PS_STYLE_MASK       =$0000000F;

      PS_ENDCAP_ROUND     =$00000000;
      PS_ENDCAP_SQUARE    =$00000100;
      PS_ENDCAP_FLAT      =$00000200;
      PS_ENDCAP_MASK      =$00000F00;
      PS_JOIN_ROUND       =$00000000;
      PS_JOIN_BEVEL       =$00001000;
      PS_JOIN_MITER       =$00002000;
      PS_JOIN_MASK        =$0000F000;
      PS_COSMETIC         =$00000000;
      PS_GEOMETRIC        =$00010000;
      PS_TYPE_MASK        =$000F0000;

      AD_COUNTERCLOCKWISE =1;
      AD_CLOCKWISE        =2;

      DRIVERVERSION =0;
      TECHNOLOGY    =2;
      HORZSIZE      =4;
      VERTSIZE      =6;
      HORZRES       =8;
      VERTRES       =10;
      BITSPIXEL     =12;
      PLANES        =14;
      NUMBRUSHES    =16;
      NUMPENS       =18;
      NUMMARKERS    =20;
      NUMFONTS      =22;
      NUMCOLORS     =24;
      PDEVICESIZE   =26;
      CURVECAPS     =28;
      LINECAPS      =30;
      POLYGONALCAPS =32;
      TEXTCAPS      =34;
      CLIPCAPS      =36;
      RASTERCAPS    =38;
      ASPECTX       =40;
      ASPECTY       =42;
      ASPECTXY      =44;
      LOGPIXELSX    =88;
      LOGPIXELSY    =90;
      SIZEPALETTE  =104;
      NUMRESERVED  =106;
      COLORRES     =108;

      PHYSICALWIDTH   =110;
      PHYSICALHEIGHT  =111;
      PHYSICALOFFSETX =112;
      PHYSICALOFFSETY =113;
      SCALINGFACTORX  =114;
      SCALINGFACTORY  =115;

      VREFRESH        =116;
      DESKTOPVERTRES  =117;
      DESKTOPHORZRES  =118;
      BLTALIGNMENT    =119;

      DT_PLOTTER          =0;
      DT_RASDISPLAY       =1;
      DT_RASPRINTER       =2;
      DT_RASCAMERA        =3;
      DT_CHARSTREAM       =4;
      DT_METAFILE         =5;
      DT_DISPFILE         =6;

      CC_NONE             =0;
      CC_CIRCLES          =1;
      CC_PIE              =2;
      CC_CHORD            =4;
      CC_ELLIPSES         =8;
      CC_WIDE             =16;
      CC_STYLED           =32;
      CC_WIDESTYLED       =64;
      CC_INTERIORS        =128;
      CC_ROUNDRECT        =256;

      LC_NONE             =0;
      LC_POLYLINE         =2;
      LC_MARKER           =4;
      LC_POLYMARKER       =8;
      LC_WIDE             =16;
      LC_STYLED           =32;
      LC_WIDESTYLED       =64;
      LC_INTERIORS        =128;

      PC_NONE             =0;
      PC_POLYGON          =1;
      PC_RECTANGLE        =2;
      PC_WINDPOLYGON      =4;
      PC_TRAPEZOID        =4;
      PC_SCANLINE         =8;
      PC_WIDE             =16;
      PC_STYLED           =32;
      PC_WIDESTYLED       =64;
      PC_INTERIORS        =128;

      CP_NONE             =0;
      CP_RECTANGLE        =1;
      CP_REGION           =2;

      TC_OP_CHARACTER     =$00000001;
      TC_OP_STROKE        =$00000002;
      TC_CP_STROKE        =$00000004;
      TC_CR_90            =$00000008;
      TC_CR_ANY           =$00000010;
      TC_SF_X_YINDEP      =$00000020;
      TC_SA_DOUBLE        =$00000040;
      TC_SA_INTEGER       =$00000080;
      TC_SA_CONTIN        =$00000100;
      TC_EA_DOUBLE        =$00000200;
      TC_IA_ABLE          =$00000400;
      TC_UA_ABLE          =$00000800;
      TC_SO_ABLE          =$00001000;
      TC_RA_ABLE          =$00002000;
      TC_VA_ABLE          =$00004000;
      TC_RESERVED         =$00008000;
      TC_SCROLLBLT        =$00010000;

      RC_NONE             =0;
      RC_BITBLT           =1;
      RC_BANDING          =2;
      RC_SCALING          =4;
      RC_BITMAP64         =8;
      RC_GDI20_OUTPUT     =$0010;
      RC_GDI20_STATE      =$0020;
      RC_SAVEBITMAP       =$0040;
      RC_DI_BITMAP        =$0080;
      RC_PALETTE          =$0100;
      RC_DIBTODEV         =$0200;
      RC_BIGFONT          =$0400;
      RC_STRETCHBLT       =$0800;
      RC_FLOODFILL        =$1000;
      RC_STRETCHDIB       =$2000;
      RC_OP_DX_OUTPUT     =$4000;
      RC_DEVBITS          =$8000;

      DIB_RGB_COLORS      =0;
      DIB_PAL_COLORS      =1;
      DIB_PAL_INDICES     =2;
      DIB_PAL_PHYSINDICES =2;
      DIB_PAL_LOGINDICES  =4;

      SYSPAL_ERROR    =0;
      SYSPAL_STATIC   =1;
      SYSPAL_NOSTATIC =2;

      CBM_CREATEDIB   =$02;
      CBM_INIT        =$04;

      FLOODFILLBORDER   =0;
      FLOODFILLSURFACE  =1;

      CCHDEVICENAME =32;
      CCHFORMNAME   =32;

TYPE
    PDEVMODE=^DEVMODE;
    DEVMODE=RECORD
                  dmDeviceName:ARRAY[0..CCHDEVICENAME-1] OF BYTE;
                  dmSpecVersion:WORD;
                  dmDriverVersion:WORD;
                  dmSize:WORD;
                  dmDriverExtra:WORD;
                  dmFields:WORD;
                  dmOrientation:SHORT;
                  dmPaperSize:SHORT;
                  dmPaperLength:SHORT;
                  dmPaperWidth:SHORT;
                  dmScale:SHORT;
                  dmCopies:SHORT;
                  dmDefaultSource:SHORT;
                  dmPrintQuality:SHORT;
                  dmColor:SHORT;
                  dmDuplex:SHORT;
                  dmYResolution:SHORT;
                  dmTTOption:SHORT;
                  dmCollate:SHORT;
                  dmFormName:ARRAY[0..CCHFORMNAME-1] OF BYTE;
                  dmLogPixels:WORD;
                  dmBitsPerPel:ULONG;
                  dmPelsWidth:ULONG;
                  dmPelsHeight:ULONG;
                  dmDisplayFlags:ULONG;
                  dmDisplayFrequency:ULONG;
    END;
    NPDEVMODE=PDEVMODE;
    LPDEVMODE=PDEVMODE;

CONST
       DM_SPECVERSION      =$0320;
       DM_ORIENTATION      =$00000001;
       DM_PAPERSIZE        =$00000002;
       DM_PAPERLENGTH      =$00000004;
       DM_PAPERWIDTH       =$00000008;
       DM_SCALE            =$00000010;
       DM_COPIES           =$00000100;
       DM_DEFAULTSOURCE    =$00000200;
       DM_PRINTQUALITY     =$00000400;
       DM_COLOR            =$00000800;
       DM_DUPLEX           =$00001000;
       DM_YRESOLUTION      =$00002000;
       DM_TTOPTION         =$00004000;
       DM_COLLATE          =$00008000;
       DM_FORMNAME         =$00010000;

       DMORIENT_PORTRAIT   =1;
       DMORIENT_LANDSCAPE  =2;
       DMPAPER_LETTER      =1;
       DMPAPER_FIRST       =DMPAPER_LETTER;
       DMPAPER_LETTERSMALL =2;
       DMPAPER_TABLOID     =3;
       DMPAPER_LEDGER      =4;
       DMPAPER_LEGAL       =5;
       DMPAPER_STATEMENT   =6;
       DMPAPER_EXECUTIVE   =7;
       DMPAPER_A3          =8;
       DMPAPER_A4          =9;
       DMPAPER_A4SMALL     =10;
       DMPAPER_A5          =11;
       DMPAPER_B4          =12;
       DMPAPER_B5          =13;
       DMPAPER_FOLIO       =14;
       DMPAPER_QUARTO      =15;
       DMPAPER_10X14       =16;
       DMPAPER_11X17       =17;
       DMPAPER_NOTE        =18;
       DMPAPER_ENV_9       =19;
       DMPAPER_ENV_10      =20;
       DMPAPER_ENV_11      =21;
       DMPAPER_ENV_12      =22;
       DMPAPER_ENV_14      =23;
       DMPAPER_CSHEET      =24;
       DMPAPER_DSHEET      =25;
       DMPAPER_ESHEET      =26;
       DMPAPER_ENV_DL      =27;
       DMPAPER_ENV_C5      =28;
       DMPAPER_ENV_C3      =29;
       DMPAPER_ENV_C4      =30;
       DMPAPER_ENV_C6      =31;
       DMPAPER_ENV_C65     =32;
       DMPAPER_ENV_B4      =33;
       DMPAPER_ENV_B5      =34;
       DMPAPER_ENV_B6      =35;
       DMPAPER_ENV_ITALY   =36;
       DMPAPER_ENV_MONARCH =37;
       DMPAPER_ENV_PERSONAL= 38;
       DMPAPER_FANFOLD_US  =39;
       DMPAPER_FANFOLD_STD_GERMAN  =40;
       DMPAPER_FANFOLD_LGL_GERMAN  =41;
       DMPAPER_LAST        =DMPAPER_FANFOLD_LGL_GERMAN;
       DMPAPER_USER        =256;

       DMBIN_UPPER         =1;
       DMBIN_FIRST         =DMBIN_UPPER;
       DMBIN_ONLYONE       =1;
       DMBIN_LOWER         =2;
       DMBIN_MIDDLE        =3;
       DMBIN_MANUAL        =4;
       DMBIN_ENVELOPE      =5;
       DMBIN_ENVMANUAL     =6;
       DMBIN_AUTO          =7;
       DMBIN_TRACTOR       =8;
       DMBIN_SMALLFMT      =9;
       DMBIN_LARGEFMT      =10;
       DMBIN_LARGECAPACITY =11;
       DMBIN_CASSETTE      =14;
       DMBIN_FORMSOURCE    =15;
       DMBIN_LAST          =DMBIN_FORMSOURCE;
       DMBIN_USER          =256;

       DMRES_DRAFT         =-1;
       DMRES_LOW           =-2;
       DMRES_MEDIUM        =-3;
       DMRES_HIGH          =-4;

       DMCOLOR_MONOCHROME  =1;
       DMCOLOR_COLOR       =2;

       DMDUP_SIMPLEX    =1;
       DMDUP_VERTICAL   =2;
       DMDUP_HORIZONTAL =3;

       DMTT_BITMAP     =1;
       DMTT_DOWNLOAD   =2;
       DMTT_SUBDEV     =3;

       DMCOLLATE_FALSE =0;
       DMCOLLATE_TRUE  =1;

       DM_GRAYSCALE    =$00000001;
       DM_INTERLACED   =$00000002;

       RDH_RECTANGLES  =1;

TYPE
    PRGNDATAHEADER=^RGNDATAHEADER;
    RGNDATAHEADER=RECORD
                        dwSize:ULONG;
                        iType:ULONG;
                        nCount:ULONG;
                        nRgnSize:ULONG;
                        rcBound:RECT;
    END;

    PRGNDATA=^RGNDATA;
    RGNDATA=RECORD
                  rdh:RGNDATAHEADER;
                  Buffer:ARRAY[0..0] OF CHAR;
    END;
    NPRGNDATA=PRGNDATA;
    LPRGNDATA=PRGNDATA;

    PABC=^ABC;
    ABC=RECORD
              abcA:LONGINT;
              abcB:ULONG;
              abcC:LONGINT;
    END;
    NPABC=PABC;
    LPABC=PABC;

    PABCFLOAT=^ABCFLOAT;
    ABCFLOAT=RECORD
                   abcfA:FLOAT;
                   abcfB:FLOAT;
                   abcfC:FLOAT;
    END;
    NPABCFLOAT=PABCFLOAT;
    LPABCFLOAT=PABCFLOAT;

    POUTLINETEXTMETRIC=^OUTLINETEXTMETRIC;
    OUTLINETEXTMETRIC=RECORD
                            otmSize:ULONG;
                            otmTextMetrics:TEXTMETRIC;
                            otmFiller:BYTE;
                            otmPanoseNumber:PANOSE;
                            otmfsSelection:ULONG;
                            otmfsType:ULONG;
                            otmsCharSlopeRise:LONGINT;
                            otmsCharSlopeRun:LONGINT;
                            otmItalicAngle:LONGINT;
                            otmEMSquare:ULONG;
                            otmAscent:LONGINT;
                            otmDescent:LONGINT;
                            otmLineGap:ULONG;
                            otmsCapEmHeight:ULONG;
                            otmsXHeight:ULONG;
                            otmrcFontBox:RECT;
                            otmMacAscent:LONGINT;
                            otmMacDescent:LONGINT;
                            otmMacLineGap:ULONG;
                            otmusMinimumPPEM:ULONG;
                            otmptSubscriptSize:POINT;
                            otmptSubscriptOffset:POINT;
                            otmptSuperscriptSize:POINT;
                            otmptSuperscriptOffset:POINT;
                            otmsStrikeoutSize:ULONG;
                            otmsStrikeoutPosition:LONGINT;
                            otmsUnderscoreSize:LONGINT;
                            otmsUnderscorePosition:LONGINT;
                            otmpFamilyName:PChar;
                            otmpFaceName:PChar;
                            otmpStyleName:PChar;
                            otmpFullName:PChar;
    END;
    NPOUTLINETEXTMETRIC=POUTLINETEXTMETRIC;
    LPOUTLINETEXTMETRIC=POUTLINETEXTMETRIC;

    PPOLYTEXT=^POLYTEXT;
    POLYTEXT=RECORD
                   x:LONGINT;
                   y:LONGINT;
                   n:ULONG;
                   lpstr:PChar;
                   uiFlags:ULONG;
                   rcl:RECT;
                   pdx:^LONGINT;
    END;
    NPPOLYTEXT=PPOLYTEXT;
    LPPOLYTEXT=PPOLYTEXT;

    FIXED=RECORD
                fract:WORD;
                value:SHORT;
    END;

    PMAT2=^MAT2;
    MAT2=RECORD
               eM11:FIXED;
               eM12:FIXED;
               eM21:FIXED;
               eM22:FIXED;
    END;
    LPMAT2=PMAT2;

    PGLYPHMETRICS=^GLYPHMETRICS;
    GLYPHMETRICS=RECORD
                       gmBlackBoxX:ULONG;
                       gmBlackBoxY:ULONG;
                       gmptGlyphOrigin:POINT;
                       gmCellIncX:SHORT;
                       gmCellIncY:SHORT;
    END;
    LPGLYPHMETRICS=PGLYPHMETRICS;

CONST
       GGO_METRICS        =0;
       GGO_BITMAP         =1;
       GGO_NATIVE         =2;


       TT_POLYGON_TYPE   =24;

       TT_PRIM_LINE       =1;
       TT_PRIM_QSPLINE    =2;

TYPE
    PPOINTFX=^POINTFX;
    POINTFX=RECORD
                  x:FIXED;
                  y:FIXED;
    END;
    LPPOINTFX=PPOINTFX;

    PTTPOLYCURVE=^TTPOLYCURVE;
    TTPOLYCURVE=RECORD
                      wType:WORD;
                      cpfx:WORD;
                      apfx:ARRAY[0..0] OF POINTFX;
    END;
    LPTTPOLYCURVE=PTTPOLYCURVE;

    PTTPOLYGONHEADER=^TTPOLYGONHEADER;
    TTPOLYGONHEADER=RECORD
                          cb:ULONG;
                          dwType:ULONG;
                          pfxStart:POINTFX;
    END;
    LPTTPOLYGONHEADER=PTTPOLYGONHEADER;

    PRASTERIZER_STATUS=^RASTERIZER_STATUS;
    RASTERIZER_STATUS=RECORD
                            nSize:SHORT;
                            wFlags:SHORT;
                            nLanguageID:SHORT;
    END;
    LPRASTERIZER_STATUS=PRASTERIZER_STATUS;

CONST
       TT_AVAILABLE    =$0001;
       TT_ENABLED      =$0002;

TYPE
    PPIXELFORMATDESCRIPTOR=^PIXELFORMATDESCRIPTOR;
    PIXELFORMATDESCRIPTOR=RECORD
                                nSize:WORD;
                                nVersion:WORD;
                                dwFlags:ULONG;
                                iPixelType:BYTE;
                                cColorBits:BYTE;
                                cRedBits:BYTE;
                                cRedShift:BYTE;
                                cGreenBits:BYTE;
                                cGreenShift:BYTE;
                                cBlueBits:BYTE;
                                cBlueShift:BYTE;
                                cAlphaBits:BYTE;
                                cAlphaShift:BYTE;
                                cAccumBits:BYTE;
                                cAccumRedBits:BYTE;
                                cAccumGreenBits:BYTE;
                                cAccumBlueBits:BYTE;
                                cAccumAlphaBits:BYTE;
                                cDepthBits:BYTE;
                                cStencilBits:BYTE;
                                cAuxBuffers:BYTE;
                                iLayerType:BYTE;
                                bReserved:BYTE;
                                dwLayerMask:ULONG;
                                dwVisibleMask:ULONG;
                                dwDamageMask:ULONG;
    END;
    LPPIXELFORMATDESCRIPTOR=PPIXELFORMATDESCRIPTOR;

CONST
       PFD_TYPE_RGBA               =0;
       PFD_TYPE_COLORINDEX         =1;
       PFD_MAIN_PLANE              =0;
       PFD_OVERLAY_PLANE           =1;
       PFD_UNDERLAY_PLANE          =-1;
       PFD_DOUBLEBUFFER            =$00000001;
       PFD_STEREO                  =$00000002;
       PFD_DRAW_TO_WINDOW          =$00000004;
       PFD_DRAW_TO_BITMAP          =$00000008;
       PFD_SUPPORT_GDI             =$00000010;
       PFD_SUPPORT_OPENGL          =$00000020;
       PFD_GENERIC_FORMAT          =$00000040;
       PFD_NEED_PALETTE            =$00000080;
       PFD_NEED_SYSTEM_PALETTE     =$00000100;
       PFD_DOUBLEBUFFER_DONTCARE   =$40000000;
       PFD_STEREO_DONTCARE         =$80000000;

TYPE
    OLDFONTENUMPROC=FUNCTION(VAR lf:LOGFONT;VAR tm:TEXTMETRIC;para:ULONG;
                             alParam:LPARAM):LONGINT;APIENTRY;
    GOBJENUMPROC=FUNCTION(VAR Buf;alParam:LPARAM):LONGINT;APIENTRY;
    LINEDDAPROC=PROCEDURE(p1,p2:LONGINT;alParam:LPARAM);
    FONTENUMPROC=OLDFONTENUMPROC;
    LPFNDEVMODE=FUNCTION(ahwnd:HWND;ahModule:HMODULE;VAR dm:DEVMODE;
                         VAR apString1,apString2:CSTRING;
                         VAR dm1:DEVMODE;VAR apString3:CSTRING;ui:ULONG):ULONG;APIENTRY;
    LPFNDEVCAPS=FUNCTION(VAR apString1,apString2:CSTRING;ui:ULONG;
                         VAR apString3:CSTRING;VAR dm:DEVMODE):ULONG;

CONST
       DM_UPDATE           =1;
       DM_COPY             =2;
       DM_PROMPT           =4;
       DM_MODIFY           =8;
       DM_IN_BUFFER        =DM_MODIFY;
       DM_IN_PROMPT        =DM_PROMPT;
       DM_OUT_BUFFER       =DM_COPY;
       DM_OUT_DEFAULT      =DM_UPDATE;

       DC_FIELDS           =1;
       DC_PAPERS           =2;
       DC_PAPERSIZE        =3;
       DC_MINEXTENT        =4;
       DC_MAXEXTENT        =5;
       DC_BINS             =6;
       DC_DUPLEX           =7;
       DC_SIZE             =8;
       DC_EXTRA            =9;
       DC_VERSION          =10;
       DC_DRIVER           =11;
       DC_BINNAMES         =12;
       DC_ENUMRESOLUTIONS  =13;
       DC_FILEDEPENDENCIES =14;
       DC_TRUETYPE         =15;
       DC_PAPERNAMES       =16;
       DC_ORIENTATION      =17;
       DC_COPIES           =18;

       DCTT_BITMAP         =$0000001;
       DCTT_DOWNLOAD       =$0000002;
       DCTT_SUBDEV         =$0000004;

TYPE
    PDIBSECTION=^DIBSECTION;
    DIBSECTION=RECORD
                     dsBm:BITMAP;
                     dsBmih:BITMAPINFOHEADER;
                     dsBitfields:ARRAY[0..2] OF ULONG;
                     dshSection:HANDLE;
                     dsOffset:ULONG;
    END;
    LPDIBSECTION=PDIBSECTION;

CONST
       CA_NEGATIVE                 =$0001;
       CA_LOG_FILTER               =$0002;

       ILLUMINANT_DEVICE_DEFAULT   =0;
       ILLUMINANT_A                =1;
       ILLUMINANT_B                =2;
       ILLUMINANT_C                =3;
       ILLUMINANT_D50              =4;
       ILLUMINANT_D55              =5;
       ILLUMINANT_D65              =6;
       ILLUMINANT_D75              =7;
       ILLUMINANT_F2               =8;
       ILLUMINANT_MAX_INDEX        =ILLUMINANT_F2;

       ILLUMINANT_TUNGSTEN         =ILLUMINANT_A;
       ILLUMINANT_DAYLIGHT         =ILLUMINANT_C;
       ILLUMINANT_FLUORESCENT      =ILLUMINANT_F2;
       ILLUMINANT_NTSC             =ILLUMINANT_C;

       RGB_GAMMA_MIN               =2500;
       RGB_GAMMA_MAX               =65000;

       REFERENCE_WHITE_MIN         =6000;
       REFERENCE_WHITE_MAX         =10000;
       REFERENCE_BLACK_MIN         =0;
       REFERENCE_BLACK_MAX         =4000;

       COLOR_ADJ_MIN               =-100;
       COLOR_ADJ_MAX               =100;

TYPE
    PCOLORADJUSTMENT=^COLORADJUSTMENT;
    COLORADJUSTMENT=RECORD
                          caSize:WORD;
                          caFlags:WORD;
                          caIlluminantIndex:WORD;
                          caRedGamma:WORD;
                          caGreenGamma:WORD;
                          caBlueGamma:WORD;
                          caReferenceBlack:WORD;
                          caReferenceWhite:WORD;
                          caContrast:SHORT;
                          caBrightness:SHORT;
                          caColorfulness:SHORT;
                          caRedGreenTint:SHORT;
    END;
    LPCOLORADJUSTMENT=PCOLORADJUSTMENT;

    ABORTPROC=FUNCTION(ahDC:HDC;i:LONGINT):BOOL;APIENTRY;

    PDOCINFO=^DOCINFO;
    DOCINFO=RECORD
                  cbSize:LONGINT;
                  lpszDocName:PChar;
                  lpszOutput:PChar;
                  lpszDatatype:PChar;
                  fwType:DWORD;
    END;
    LPDOCINFO=PDOCINFO;

CONST
     FONTMAPPER_MAX =10;

TYPE
    PKERNINGPAIR=^KERNINGPAIR;
    KERNINGPAIR=RECORD
                      wFirst:WORD;
                      wSecond:WORD;
                      iKernAmount:LONGINT;
    END;
    LPKERNINGPAIR=PKERNINGPAIR;

CONST
     ENHMETA_SIGNATURE       =$464D4520;
     ENHMETA_STOCK_OBJECT    =$80000000;

     EMR_HEADER                      =1;
     EMR_POLYBEZIER                  =2;
     EMR_POLYGON                     =3;
     EMR_POLYLINE                    =4;
     EMR_POLYBEZIERTO                =5;
     EMR_POLYLINETO                  =6;
     EMR_POLYPOLYLINE                =7;
     EMR_POLYPOLYGON                 =8;
     EMR_SETWINDOWEXTEX              =9;
     EMR_SETWINDOWORGEX              =10;
     EMR_SETVIEWPORTEXTEX            =11;
     EMR_SETVIEWPORTORGEX            =12;
     EMR_SETBRUSHORGEX               =13;
     EMR_EOF                         =14;
     EMR_SETPIXELV                   =15;
     EMR_SETMAPPERFLAGS              =16;
     EMR_SETMAPMODE                  =17;
     EMR_SETBKMODE                   =18;
     EMR_SETPOLYFILLMODE             =19;
     EMR_SETROP2                     =20;
     EMR_SETSTRETCHBLTMODE           =21;
     EMR_SETTEXTALIGN                =22;
     EMR_SETCOLORADJUSTMENT          =23;
     EMR_SETTEXTCOLOR                =24;
     EMR_SETBKCOLOR                  =25;
     EMR_OFFSETCLIPRGN               =26;
     EMR_MOVETOEX                    =27;
     EMR_SETMETARGN                  =28;
     EMR_EXCLUDECLIPRECT             =29;
     EMR_INTERSECTCLIPRECT           =30;
     EMR_SCALEVIEWPORTEXTEX          =31;
     EMR_SCALEWINDOWEXTEX            =32;
     EMR_SAVEDC                      =33;
     EMR_RESTOREDC                   =34;
     EMR_SETWORLDTRANSFORM           =35;
     EMR_MODIFYWORLDTRANSFORM        =36;
     EMR_SELECTOBJECT                =37;
     EMR_CREATEPEN                   =38;
     EMR_CREATEBRUSHINDIRECT         =39;
     EMR_DELETEOBJECT                =40;
     EMR_ANGLEARC                    =41;
     EMR_ELLIPSE                     =42;
     EMR_RECTANGLE                   =43;
     EMR_ROUNDRECT                   =44;
     EMR_ARC                         =45;
     EMR_CHORD                       =46;
     EMR_PIE                         =47;
     EMR_SELECTPALETTE               =48;
     EMR_CREATEPALETTE               =49;
     EMR_SETPALETTEENTRIES           =50;
     EMR_RESIZEPALETTE               =51;
     EMR_REALIZEPALETTE              =52;
     EMR_EXTFLOODFILL                =53;
     EMR_LINETO                      =54;
     EMR_ARCTO                       =55;
     EMR_POLYDRAW                    =56;
     EMR_SETARCDIRECTION             =57;
     EMR_SETMITERLIMIT               =58;
     EMR_BEGINPATH                   =59;
     EMR_ENDPATH                     =60;
     EMR_CLOSEFIGURE                 =61;
     EMR_FILLPATH                    =62;
     EMR_STROKEANDFILLPATH           =63;
     EMR_STROKEPATH                  =64;
     EMR_FLATTENPATH                 =65;
     EMR_WIDENPATH                   =66;
     EMR_SELECTCLIPPATH              =67;
     EMR_ABORTPATH                   =68;
     EMR_GDICOMMENT                  =70;
     EMR_FILLRGN                     =71;
     EMR_FRAMERGN                    =72;
     EMR_INVERTRGN                   =73;
     EMR_PAINTRGN                    =74;
     EMR_EXTSELECTCLIPRGN            =75;
     EMR_BITBLT                      =76;
     EMR_STRETCHBLT                  =77;
     EMR_MASKBLT                     =78;
     EMR_PLGBLT                      =79;
     EMR_SETDIBITSTODEVICE           =80;
     EMR_STRETCHDIBITS               =81;
     EMR_EXTCREATEFONTINDIRECTW      =82;
     EMR_EXTTEXTOUTA                 =83;
     EMR_EXTTEXTOUTW                 =84;
     EMR_POLYBEZIER16                =85;
     EMR_POLYGON16                   =86;
     EMR_POLYLINE16                  =87;
     EMR_POLYBEZIERTO16              =88;
     EMR_POLYLINETO16                =89;
     EMR_POLYPOLYLINE16              =90;
     EMR_POLYPOLYGON16               =91;
     EMR_POLYDRAW16                  =92;
     EMR_CREATEMONOBRUSH             =93;
     EMR_CREATEDIBPATTERNBRUSHPT     =94;
     EMR_EXTCREATEPEN                =95;
     EMR_POLYTEXTOUTA                =96;
     EMR_POLYTEXTOUTW                =97;
     EMR_MIN                         =1;
     EMR_MAX                         =97;

TYPE
    PEMR=^EMR;
    EMR=RECORD
              iType:ULONG;
              nSize:ULONG;
    END;

    PEMRTEXT=^EMRTEXT;
    EMRTEXT=RECORD
                  ptlReference:POINTL;
                  nChars:ULONG;
                  offString:ULONG;
                  fOptions:ULONG;
                  rcl:RECTL;
                  offDx:ULONG;
    END;

    PEMRABORTPATH=^EMRABORTPATH;
    EMRABORTPATH=RECORD
                       emr:EMR;
                 END;
    EMRBEGINPATH=EMRABORTPATH;
    PEMRBEGINPATH=PEMRABORTPATH;
    EMRENDPATH=EMRABORTPATH;
    PEMRENDPATH=PEMRABORTPATH;
    EMRCLOSEFIGURE=EMRABORTPATH;
    PEMRCLOSEFIGURE=PEMRABORTPATH;
    EMRFLATTENPATH=EMRABORTPATH;
    PEMRFLATTENPATH=PEMRABORTPATH;
    EMRWIDENPATH=EMRABORTPATH;
    PEMRWIDENPATH=PEMRABORTPATH;
    EMRSETMETARGN=EMRABORTPATH;
    PEMRSETMETARGN=PEMRABORTPATH;
    EMRSAVEDC=EMRABORTPATH;
    PEMRSAVEDC=PEMRABORTPATH;
    EMRREALIZEPALETTE=EMRABORTPATH;
    PEMRREALIZEPALETTE=PEMRABORTPATH;

TYPE
    PEMRSELECTCLIPPATH=^EMRSELECTCLIPPATH;
    EMRSELECTCLIPPATH=RECORD
                            emr:EMR;
                            iMode:LONGWORD;
                      END;

    PEMRSETBKMODE=^EMRSETBKMODE;
    EMRSETBKMODE=EMRSELECTCLIPPATH;

    PEMRSETMAPMODE=^EMRSETMAPMODE;
    EMRSETMAPMODE=EMRSELECTCLIPPATH;

    PEMRSETPOLYFILLMODE=^EMRSETPOLYFILLMODE;
    EMRSETPOLYFILLMODE=EMRSELECTCLIPPATH;

    PEMRSETROP2=^EMRSETROP2;
    EMRSETROP2=EMRSELECTCLIPPATH;

    PEMRSETSTRETCHBLTMODE=^EMRSETSTRETCHBLTMODE;
    EMRSETSTRETCHBLTMODE=EMRSELECTCLIPPATH;

    PEMRSETTEXTALIGN=^EMRSETTEXTALIGN;
    EMRSETTEXTALIGN=EMRSELECTCLIPPATH;

    PEMRSETMITERLIMIT=^EMRSETMITERLIMIT;
    EMRSETMITERLIMIT=RECORD
                           emr:EMR;
                           eMiterLimit:FLOAT;
                     END;

    PEMRRESTOREDC=^EMRRESTOREDC;
    EMRRESTOREDC=RECORD
                       emr:EMR;
                       iRelative:LONGINT;
                 END;

    PEMRSETARCDIRECTION=^EMRSETARCDIRECTION;
    EMRSETARCDIRECTION=RECORD
                             emr:EMR;
                             iArcDirection:LONGWORD;
                       END;

    PEMRSETMAPPERFLAGS=^EMRSETMAPPERFLAGS;
    EMRSETMAPPERFLAGS=RECORD
                            emr:EMR;
                            dwFlags:LONGWORD;
                      END;

    PEMRSETBKCOLOR=^EMRSETBKCOLOR;
    EMRSETBKCOLOR=RECORD
                        emr:EMR;
                        crColor:COLORREF;
                  END;

    PEMRSETTEXTCOLOR=^EMRSETTEXTCOLOR;
    EMRSETTEXTCOLOR=EMRSETBKCOLOR;

    PEMRSELECTOBJECT=^EMRSELECTOBJECT;
    EMRSELECTOBJECT=RECORD
                          emr:EMR;
                          ihObject:LONGWORD;
                    END;

    PEMRDELETEOBJECT=^EMRDELETEOBJECT;
    EMRDELETEOBJECT=EMRSELECTOBJECT;

    PEMRSELECTPALETTE=^EMRSELECTPALETTE;
    EMRSELECTPALETTE=RECORD
                           emr:EMR;
                           ihPal:LONGWORD;
                     END;

    PEMRRESIZEPALETTE=^EMRRESIZEPALETTE;
    EMRRESIZEPALETTE=RECORD
                           emr:EMR;
                           ihPal:LONGWORD;
                           cEntries:LONGWORD;
                     END;

    PEMRSETPALETTEENTRIES=^EMRSETPALETTEENTRIES;
    EMRSETPALETTEENTRIES=RECORD
                               emr:EMR;
                               ihPal:LONGWORD;
                               iStart:LONGWORD;
                               cEntries:LONGWORD;
                               aPalEntries:ARRAY[0..0] OF PALETTEENTRY;
                         END;

    PEMRSETCOLORADJUSTMENT=^EMRSETCOLORADJUSTMENT;
    EMRSETCOLORADJUSTMENT=RECORD
                                emr:EMR;
                                ColorAdjustment:COLORADJUSTMENT;
                          END;

    PEMRGDICOMMENT=^EMRGDICOMMENT;
    EMRGDICOMMENT=RECORD
                        emr:EMR;
                        cbData:LONGWORD;
                        Data:ARRAY[0..0] OF BYTE;
                  END;

    PEMREOF=^EMREOF;
    EMREOF=RECORD
                 emr:EMR;
                 nPalEntries:LONGWORD;
                 offPalEntries:LONGWORD;
                 nSizeLast:LONGWORD;
           END;

    PEMRLINETO=^EMRLINETO;
    EMRLINETO=RECORD
                    emr:EMR;
                    ptl:POINTL;
              END;

    PEMRMOVETOEX=^EMRMOVETOEX;
    EMRMOVETOEX=EMRLINETO;

    PEMROFFSETCLIPRGN=^EMROFFSETCLIPRGN;
    EMROFFSETCLIPRGN=RECORD
                           emr:EMR;
                           ptlOffset:POINTL;
                     END;

    PEMRFILLPATH=^EMRFILLPATH;
    EMRFILLPATH=RECORD
                      emr:EMR;
                      rclBounds:RECTL;
                END;

    PEMRSTROKEANDFILLPATH=^EMRSTROKEANDFILLPATH;
    EMRSTROKEANDFILLPATH=EMRFILLPATH;

    PEMRSTROKEPATH=^EMRSTROKEPATH;
    EMRSTROKEPATH=EMRFILLPATH;

    PEMREXCLUDECLIPRECT=^EMREXCLUDECLIPRECT;
    EMREXCLUDECLIPRECT=RECORD
                             emr:EMR;
                             rclClip:RECTL;
                       END;

    PEMRINTERSECTCLIPRECT=^EMRINTERSECTCLIPRECT;
    EMRINTERSECTCLIPRECT=EMREXCLUDECLIPRECT;

    PEMRSETVIEWPORTORGEX=^EMRSETVIEWPORTORGEX;
    EMRSETVIEWPORTORGEX=RECORD
                              emr:EMR;
                              ptlOrigin:POINTL;
                        END;

    PEMRSETWINDOWORGEX=^EMRSETWINDOWORGEX;
    EMRSETWINDOWORGEX=EMRSETVIEWPORTORGEX;

    PEMRSETBRUSHORGEX=^EMRSETBRUSHORGEX;
    EMRSETBRUSHORGEX=EMRSETVIEWPORTORGEX;

    PEMRSETVIEWPORTEXTEX=^EMRSETVIEWPORTEXTEX;
    EMRSETVIEWPORTEXTEX=RECORD
                              emr:EMR;
                              szlExtent:SIZEL;
                        END;

    PEMRSETWINDOWEXTEX=^EMRSETWINDOWEXTEX;
    EMRSETWINDOWEXTEX=EMRSETVIEWPORTEXTEX;

    PEMRSCALEVIEWPORTEXTEX=^EMRSCALEVIEWPORTEXTEX;
    EMRSCALEVIEWPORTEXTEX=RECORD
                                emr:EMR;
                                xNum:LONGINT;
                                xDenom:LONGINT;
                                yNum:LONGINT;
                                yDenom:LONGINT;
                          END;

    PEMRSCALEWINDOWEXTEX=^EMRSCALEWINDOWEXTEX;
    EMRSCALEWINDOWEXTEX=EMRSCALEVIEWPORTEXTEX;

    PEMRSETWORLDTRANSFORM=^EMRSETWORLDTRANSFORM;
    EMRSETWORLDTRANSFORM=RECORD
                               emr:EMR;
                               xform:XFORM;
                         END;

    PEMRMODIFYWORLDTRANSFORM=^EMRMODIFYWORLDTRANSFORM;
    EMRMODIFYWORLDTRANSFORM=RECORD
                                  emr:EMR;
                                  xform:XFORM;
                                  iMode:LONGWORD;
                            END;

    PEMRSETPIXELV=^EMRSETPIXELV;
    EMRSETPIXELV=RECORD
                       emr:EMR;
                       ptlPixel:POINTL;
                       crColor:COLORREF;
                 END;

    PEMREXTFLOODFILL=^EMREXTFLOODFILL;
    EMREXTFLOODFILL=RECORD
                          emr:EMR;
                          ptlStart:POINTL;
                          crColor:COLORREF;
                          iMode:LONGWORD;
                    END;

    PEMRELLIPSE=^EMRELLIPSE;
    EMRELLIPSE=RECORD
                     emr:EMR;
                     rclBox:RECTL;
               END;

    PEMRRECTANGLE=^EMRRECTANGLE;
    EMRRECTANGLE=EMRELLIPSE;

    PEMRROUNDRECT=^EMRROUNDRECT;
    EMRROUNDRECT=RECORD
                       emr:EMR;
                       rclBox:RECTL;
                       szlCorner:SIZEL;
                 END;

    PEMRARC=^EMRARC;
    EMRARC=RECORD
                 emr:EMR;
                 rclBox:RECTL;
                 ptlStart:POINTL;
                 ptlEnd:POINTL;
          END;

    PEMRARCTO=^EMRARCTO;
    EMRARCTO=EMRARC;

    PEMRCHORD=^EMRCHORD;
    EMRCHORD=EMRARC;

    PEMRPIE=^EMRPIE;
    EMRPIE=EMRARC;

    PEMRANGLEARC=^EMRANGLEARC;
    EMRANGLEARC=RECORD
                      emr:EMR;
                      ptlCenter:POINTL;
                      nRadius:LONGWORD;
                      eStartAngle:FLOAT;
                      eSweepAngle:FLOAT;
                END;

    PEMRPOLYLINE=^EMRPOLYLINE;
    EMRPOLYLINE=RECORD
                      emr:EMR;
                      rclBounds:RECTL;
                      cptl:LONGWORD;
                      aptl:ARRAY[0..0] OF POINTL;
                END;

    PEMRPOLYBEZIER=^EMRPOLYBEZIER;
    EMRPOLYBEZIER=EMRPOLYLINE;

    PEMRPOLYGON=^EMRPOLYGON;
    EMRPOLYGON=EMRPOLYLINE;

    PEMRPOLYBEZIERTO=^EMRPOLYBEZIERTO;
    EMRPOLYBEZIERTO=EMRPOLYLINE;

    PEMRPOLYLINETO=^EMRPOLYLINETO;
    EMRPOLYLINETO=EMRPOLYLINE;

    PEMRPOLYLINE16=^EMRPOLYLINE16;
    EMRPOLYLINE16=RECORD
                        emr:EMR;
                        rclBounds:RECTL;
                        cpts:LONGWORD;
                        apts:ARRAY[0..0] OF POINTS;
                  END;

    PEMRPOLYBEZIER16=^EMRPOLYBEZIER16;
    EMRPOLYBEZIER16=EMRPOLYLINE16;

    PEMRPOLYGON16=^EMRPOLYGON16;
    EMRPOLYGON16=EMRPOLYLINE16;

    PEMRPOLYBEZIERTO16=^EMRPOLYBEZIERTO16;
    EMRPOLYBEZIERTO16=EMRPOLYLINE16;

    PEMRPOLYLINETO16=^EMRPOLYLINETO16;
    EMRPOLYLINETO16=EMRPOLYLINE16;

    PEMRPOLYDRAW=^EMRPOLYDRAW;
    EMRPOLYDRAW=RECORD
                      emr:EMR;
                      rclBounds:RECTL;
                      cptl:LONGWORD;
                      aptl:ARRAY[0..0] OF POINTL;
                      abTypes:ARRAY[0..0] OF BYTE;
               END;

    PEMRPOLYDRAW16=^EMRPOLYDRAW16;
    EMRPOLYDRAW16=RECORD
                        emr:EMR;
                        rclBounds:RECTL;
                        cpts:LONGWORD;
                        apts:ARRAY[0..0] OF POINTS;
                        abTypes:ARRAY[0..0] OF BYTE;
                  END;

    PEMRPOLYPOLYLINE=^EMRPOLYPOLYLINE;
    EMRPOLYPOLYLINE=RECORD
                          emr:EMR;
                          rclBounds:RECTL;
                          nPolys:LONGWORD;
                          cptl:LONGWORD;
                          aPolyCounts:ARRAY[0..0] OF LONGWORD;
                          aptl:ARRAY[0..0] OF POINTL;
                    END;

    PEMRPOLYPOLYGON=^EMRPOLYPOLYGON;
    EMRPOLYPOLYGON=EMRPOLYPOLYLINE;

    PEMRPOLYPOLYLINE16=^EMRPOLYPOLYLINE16;
    EMRPOLYPOLYLINE16=RECORD
                            emr:EMR;
                            rclBounds:RECTL;
                            nPolys:LONGWORD;
                            cpts:LONGWORD;
                            aPolyCounts:ARRAY[0..0] OF LONGWORD;
                            apts:ARRAY[0..0] OF POINTS;
                       END;

    PEMRPOLYPOLYGON16=^EMRPOLYPOLYGON16;
    EMRPOLYPOLYGON16=EMRPOLYPOLYLINE16;

    PEMRINVERTRGN=^EMRINVERTRGN;
    EMRINVERTRGN=RECORD
                       emr:EMR;
                       rclBounds:RECTL;
                       cbRgnData:LONGWORD;
                       RgnData:ARRAY[0..0] OF BYTE;
                 END;

    PEMRPAINTRGN=^EMRPAINTRGN;
    EMRPAINTRGN=EMRINVERTRGN;

    PEMRFILLRGN=^EMRFILLRGN;
    EMRFILLRGN=RECORD
                     emr:EMR;
                     rclBounds:RECTL;
                     cbRgnData:LONGWORD;
                     ihBrush:LONGWORD;
                     RgnData:ARRAY[0..0] OF BYTE;
               END;

    PEMRFRAMERGN=^EMRFRAMERGN;
    EMRFRAMERGN=RECORD
                      emr:EMR;
                      rclBounds:RECTL;
                      cbRgnData:LONGWORD;
                      ihBrush:LONGWORD;
                      szlStroke:SIZEL;
                      RgnData:ARRAY[0..0] OF BYTE;
                END;

    PEMREXTSELECTCLIPRGN=^EMREXTSELECTCLIPRGN;
    EMREXTSELECTCLIPRGN=RECORD
                              emr:EMR;
                              cbRgnData:LONGWORD;
                              Mode:LONGWORD;
                              RgnData:ARRAY[0..0] OF BYTE;
                        END;

    PEMREXTTEXTOUTA=^EMREXTTEXTOUTA;
    EMREXTTEXTOUTA=RECORD
                         emr:EMR;
                         rclBounds:RECTL;
                         iGraphicsMode:LONGWORD;
                         exScale:FLOAT;
                         eyScale:FLOAT;
                         emrtext:EMRTEXT;
                   END;

    PEMREXTTEXTOUTW=^EMREXTTEXTOUTW;
    EMREXTTEXTOUTW=EMREXTTEXTOUTA;

    PEMRPOLYTEXTOUTA=^EMRPOLYTEXTOUTA;
    EMRPOLYTEXTOUTA=RECORD
                          emr:EMR;
                          rclBounds:RECTL;
                          iGraphicsMode:LONGWORD;
                          exScale:FLOAT;
                          eyScale:FLOAT;
                          cStrings:LONGWORD;
                          aemrtext:ARRAY[0..0] OF EMRTEXT;
                    END;

    PEMRPOLYTEXTOUTW=^EMRPOLYTEXTOUTW;
    EMRPOLYTEXTOUTW=EMRPOLYTEXTOUTA;

    PEMRBITBLT=^EMRBITBLT;
    EMRBITBLT=RECORD
                    emr:EMR;
                    rclBounds:RECTL;
                    xDest:LONGINT;
                    yDest:LONGINT;
                    cxDest:LONGINT;
                    cyDest:LONGINT;
                    dwRop:LONGWORD;
                    xSrc:LONGINT;
                    ySrc:LONGINT;
                    xformSrc:XFORM;
                    crBkColorSrc:COLORREF;
                    iUsageSrc:LONGWORD;
                    offBmiSrc:LONGWORD;
                    cbBmiSrc:LONGWORD;
                    offBitsSrc:LONGWORD;
                    cbBitsSrc:LONGWORD;
              END;

    PEMRSTRETCHBLT=^EMRSTRETCHBLT;
    EMRSTRETCHBLT=RECORD
                        emr:EMR;
                        rclBounds:RECTL;
                        xDest:LONGINT;
                        yDest:LONGINT;
                        cxDest:LONGINT;
                        cyDest:LONGINT;
                        dwRop:LONGWORD;
                        xSrc:LONGINT;
                        ySrc:LONGINT;
                        xformSrc:XFORM;
                        crBkColorSrc:COLORREF;
                        iUsageSrc:LONGWORD;
                        offBmiSrc:LONGWORD;
                        cbBmiSrc:LONGWORD;
                        offBitsSrc:LONGWORD;
                        cbBitsSrc:LONGWORD;
                        cxSrc:LONGINT;
                        cySrc:LONGINT;
                  END;

    PEMRMASKBLT=^EMRMASKBLT;
    EMRMASKBLT=RECORD
                     emr:EMR;
                     rclBounds:RECTL;
                     xDest:LONGINT;
                     yDest:LONGINT;
                     cxDest:LONGINT;
                     cyDest:LONGINT;
                     dwRop:LONGWORD;
                     xSrc:LONGINT;
                     ySrc:LONGINT;
                     xformSrc:XFORM;
                     crBkColorSrc:COLORREF;
                     iUsageSrc:LONGWORD;
                     offBmiSrc:LONGWORD;
                     cbBmiSrc:LONGWORD;
                     offBitsSrc:LONGWORD;
                     cbBitsSrc:LONGWORD;
                     xMask:LONGINT;
                     yMask:LONGINT;
                     iUsageMask:LONGWORD;
                     offBmiMask:LONGWORD;
                     cbBmiMask:LONGWORD;
                     offBitsMask:LONGWORD;
                     cbBitsMask:LONGWORD;
               END;

    PEMRPLGBLT=^EMRPLGBLT;
    EMRPLGBLT=RECORD
                    emr:EMR;
                    rclBounds:RECTL;
                    aptlDest:ARRAY[0..2] OF POINTL;
                    xSrc:LONGINT;
                    ySrc:LONGINT;
                    cxSrc:LONGINT;
                    cySrc:LONGINT;
                    xformSrc:XFORM;
                    crBkColorSrc:COLORREF;
                    iUsageSrc:LONGWORD;
                    offBmiSrc:LONGWORD;
                    cbBmiSrc:LONGWORD;
                    offBitsSrc:LONGWORD;
                    cbBitsSrc:LONGWORD;
                    xMask:LONGINT;
                    yMask:LONGINT;
                    iUsageMask:LONGWORD;
                    offBmiMask:LONGWORD;
                    cbBmiMask:LONGWORD;
                    offBitsMask:LONGWORD;
                    cbBitsMask:LONGWORD;
              END;

    PEMRSETDIBITSTODEVICE=^EMRSETDIBITSTODEVICE;
    EMRSETDIBITSTODEVICE=RECORD
                               emr:EMR;
                               rclBounds:RECTL;
                               xDest:LONGINT;
                               yDest:LONGINT;
                               xSrc:LONGINT;
                               ySrc:LONGINT;
                               cxSrc:LONGINT;
                               cySrc:LONGINT;
                               offBmiSrc:LONGWORD;
                               cbBmiSrc:LONGWORD;
                               offBitsSrc:LONGWORD;
                               cbBitsSrc:LONGWORD;
                               iUsageSrc:LONGWORD;
                               iStartScan:LONGWORD;
                               cScans:LONGWORD;
                         END;

    PEMRSTRETCHDIBITS=^EMRSTRETCHDIBITS;
    EMRSTRETCHDIBITS=RECORD
                           emr:EMR;
                           rclBounds:RECTL;
                           xDest:LONGINT;
                           yDest:LONGINT;
                           xSrc:LONGINT;
                           ySrc:LONGINT;
                           cxSrc:LONGINT;
                           cySrc:LONGINT;
                           offBmiSrc:LONGWORD;
                           cbBmiSrc:LONGWORD;
                           offBitsSrc:LONGWORD;
                           cbBitsSrc:LONGWORD;
                           iUsageSrc:LONGWORD;
                           dwRop:LONGWORD;
                           cxDest:LONGINT;
                           cyDest:LONGINT;
                     END;

    PEMREXTCREATEFONTINDIRECTW=^EMREXTCREATEFONTINDIRECTW;
    EMREXTCREATEFONTINDIRECTW=RECORD
                                    emr:EMR;
                                    ihFont:LONGWORD;
                                    elfw:EXTLOGFONT;
                              END;

    PEMRCREATEPALETTE=^EMRCREATEPALETTE;
    EMRCREATEPALETTE=RECORD
                           emr:EMR;
                           ihPal:LONGWORD;
                           lgpl:LOGPALETTE;
                     END;

    PEMRCREATEPEN=^EMRCREATEPEN;
    EMRCREATEPEN=RECORD
                       emr:EMR;
                       ihPen:LONGWORD;
                       lopn:LOGPEN;
                 END;

    PEMREXTCREATEPEN=^EMREXTCREATEPEN;
    EMREXTCREATEPEN=RECORD
                          emr:EMR;
                          ihPen:LONGWORD;
                          offBmi:LONGWORD;
                          cbBmi:LONGWORD;
                          offBits:LONGWORD;
                          cbBits:LONGWORD;
                          elp:EXTLOGPEN;
                    END;

    PEMRCREATEBRUSHINDIRECT=^EMRCREATEBRUSHINDIRECT;
    EMRCREATEBRUSHINDIRECT=RECORD
                                 emr:EMR;
                                 ihBrush:LONGWORD;
                                 lb:LOGBRUSH;
                           END;

    PEMRCREATEMONOBRUSH=^EMRCREATEMONOBRUSH;
    EMRCREATEMONOBRUSH=RECORD
                             emr:EMR;
                             ihBrush:LONGWORD;
                             iUsage:LONGWORD;
                             offBmi:LONGWORD;
                             cbBmi:LONGWORD;
                             offBits:LONGWORD;
                             cbBits:LONGWORD;
                       END;

    PEMRCREATEDIBPATTERNBRUSHPT=^EMRCREATEDIBPATTERNBRUSHPT;
    EMRCREATEDIBPATTERNBRUSHPT=RECORD
                                     emr:EMR;
                                     ihBrush:LONGWORD;
                                     iUsage:LONGWORD;
                                     offBmi:LONGWORD;
                                     cbBmi:LONGWORD;
                                     offBits:LONGWORD;
                                     cbBits:LONGWORD;
                               END;

    PEMRFORMAT=^EMRFORMAT;
    EMRFORMAT=RECORD
                    dSignature:LONGWORD;
                    nVersion:LONGWORD;
                    cbData:LONGWORD;
                    offData:LONGWORD;
              END;

CONST
       GDICOMMENT_IDENTIFIER           =$43494447;
       GDICOMMENT_WINDOWS_METAFILE     =$80000001;
       GDICOMMENT_BEGINGROUP           =$00000002;
       GDICOMMENT_ENDGROUP             =$00000003;
       GDICOMMENT_MULTIFORMATS         =$40000004;
       EPS_SIGNATURE                   =$46535045;

TYPE
    MFENUMPROC=FUNCTION(ahdc:HDC;VAR t:HANDLETABLE;VAR r:METARECORD;i:LONGINT;p:LPARAM):LONGINT;APIENTRY;
    ENHMFENUMPROC=FUNCTION(ahdc:HDC;VAR t:HANDLETABLE;VAR r:ENHMETARECORD;i:LONGINT;p:LPARAM):LONGINT;APIENTRY;


IMPORTS
       FUNCTION AddFontResource(CONST s:CSTRING):LONGINT;
                     APIENTRY;    'GDI32' name 'AddFontResourceA';
       FUNCTION AnimatePalette(pal:HPALETTE;x,y:LONGWORD;VAR entry:PALETTEENTRY):BOOL;
                     APIENTRY;    'GDI32' name 'AnimatePalette';
       FUNCTION Arc(adc:HDC;i1,i2,i3,i4,i5,i6,i7,i8:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'Arc';
       FUNCTION BitBlt(Dest:HDC;x,y,w,h:LONGINT;Src:HDC;p1,p2:LONGINT;m:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'BitBlt';
       FUNCTION CancelDC(adc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'CancelDC';
       FUNCTION Chord(adc:HDC;i1,i2,i3,i4,i5,i6,i7,i8:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'Chord';
       FUNCTION ChoosePixelFormat(adc:HDC;VAR format:PIXELFORMATDESCRIPTOR):LONGINT;
                     APIENTRY;    'GDI32' name 'ChoosePixelFormat';
       FUNCTION CloseMetaFile(adc:HDC):HMETAFILE;
                     APIENTRY;    'GDI32' name 'CloseMetaFile';
       FUNCTION CombineRgn(rgn1,rgn2,rgn3:HRGN;x:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'CombineRgn';
       FUNCTION CopyMetaFile(meta:HMETAFILE;CONST s:CSTRING):HMETAFILE;
                     APIENTRY;    'GDI32' name 'CopyMetaFileA';
       FUNCTION CreateBitmap(W,H:LONGINT;p,c:LONGWORD;VAR Data):HBITMAP;
                     APIENTRY;    'GDI32' name 'CreateBitmap';
       FUNCTION CreateBitmapIndirect(VAR bm:BITMAP):HBITMAP;
                     APIENTRY;    'GDI32' name 'CreateBitmapIndirect';
       FUNCTION CreateBrushIndirect(VAR lb:LOGBRUSH):HBRUSH;
                     APIENTRY;    'GDI32' name 'CreateBrushIndirect';
       FUNCTION CreateCompatibleBitmap(Src:HDC;W,H:LONGINT):HBITMAP;
                     APIENTRY;    'GDI32' name 'CreateCompatibleBitmap';
       FUNCTION CreateDiscardableBitmap(adc:HDC;x,y:LONGINT):HBITMAP;
                     APIENTRY;    'GDI32' name 'CreateDiscardableBitmap';
       FUNCTION CreateCompatibleDC(ahdc:HDC):HDC;
                     APIENTRY;    'GDI32' name 'CreateCompatibleDC';
       FUNCTION CreateDC(CONST a,b,c:CSTRING;VAR mode:DEVMODE):HDC;
                     APIENTRY;    'GDI32' name 'CreateDCA';
       FUNCTION CreateDIBitmap(ahdc:HDC;VAR bih;
                               Flags:LONGWORD;VAR Buf;
                               VAR bi;Col:LONGWORD):HBITMAP;
                     APIENTRY;    'GDI32' name 'CreateDIBitmap';
       FUNCTION CreateDIBPatternBrush(ahGlobal:HGLOBAL;p:LONGWORD):HBRUSH;
                     APIENTRY;    'GDI32' name 'CreateDIBPatternBrush';
       FUNCTION CreateDIBPatternBrushPt(VAR Buf;p:LONGWORD):HBRUSH;
                     APIENTRY;    'GDI32' name 'CreateDIBPatternBrushPt';
       FUNCTION CreateEllipticRgn(i1,i2,i3,i4:LONGINT):HRGN;
                     APIENTRY;    'GDI32' name 'CreateEllipticRgn';
       FUNCTION CreateEllipticRgnIndirect(CONST rcl:RECT):HRGN;
                     APIENTRY;    'GDI32' name 'CreateEllipticRgnIndirect';
       FUNCTION CreateFontIndirect(VAR lf:LOGFONT):HFONT;
                     APIENTRY;    'GDI32' name 'CreateFontIndirectA';
       FUNCTION CreateFont(i1,i2,i3,i4,i5:LONGINT;dw1,dw2,dw3,dw4,dw5,dw6,
                            dw7,dw8:LONGWORD;CONST s:CSTRING):HFONT;
                     APIENTRY;    'GDI32' name 'CreateFontA';
       FUNCTION CreateHatchBrush(i:LONGINT;color:COLORREF):HBRUSH;
                     APIENTRY;    'GDI32' name 'CreateHatchBrush';
       FUNCTION CreateIC(CONST s1,s2,s3:CSTRING;CONST mode:DEVMODE):HDC;
                     APIENTRY;    'GDI32' name 'CreateICA';
       FUNCTION CreateMetaFile(CONST name:CSTRING):HDC;
                     APIENTRY;    'GDI32' name 'CreateMetaFileA';
       FUNCTION CreatePalette(VAR lp:LOGPALETTE):HPALETTE;
                     APIENTRY;    'GDI32' name 'CreatePalette';
       FUNCTION CreatePen(Style:LONGINT;LineWidth:LONGINT;Color:COLORREF):HPEN;
                     APIENTRY;    'GDI32' name 'CreatePen';
       FUNCTION CreatePenIndirect(VAR lp:LOGPEN):HPEN;
                     APIENTRY;    'GDI32' name 'CreatePenIndirect';
       FUNCTION CreatePolyPolygonRgn(CONST pt:POINT;VAR i:LONGINT;i1,i2:LONGINT):HRGN;
                     APIENTRY;    'GDI32' name 'CreatePolyPolygonRgn';
       FUNCTION CreatePatternBrush(bmp:HBITMAP):HBRUSH;
                     APIENTRY;    'GDI32' name 'CreatePatternBrush';
       FUNCTION CreateRectRgn(xLeft,yTop,xRight,yBottom:LONGINT):HRGN;
                     APIENTRY;    'GDI32' name 'CreateRectRgn';
       FUNCTION CreateRectRgnIndirect(VAR rec:RECT):HRGN;
                     APIENTRY;    'GDI32' name 'CreateRectRgnIndirect';
       FUNCTION CreateRoundRectRgn(i1,i2,i3,i4,i5,i6:LONGINT):HRGN;
                     APIENTRY;    'GDI32' name 'CreateRoundRectRgn';
       FUNCTION CreateScalableFontResource(dw:LONGWORD;CONST s1,s2,s3:CSTRING):BOOL;
                     APIENTRY;    'GDI32' name 'CreateScalableFontResourceA';
       FUNCTION CreateSolidBrush(color:COLORREF):HBRUSH;
                     APIENTRY;    'GDI32' name 'CreateSolidBrush';
       FUNCTION DeleteDC(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'DeleteDC';
       FUNCTION DeleteMetaFile(ahMeta:HMETAFILE):BOOL;
                     APIENTRY;    'GDI32' name 'DeleteMetaFile';
       FUNCTION DeleteObject(obj:HGDIOBJ):BOOL;
                     APIENTRY;    'GDI32' name 'DeleteObject';
       FUNCTION DescribePixelFormat(ahdc:HDC;i:LONGINT;ui:LONGWORD;VAR desc:PIXELFORMATDESCRIPTOR):LONGINT;
                     APIENTRY;    'GDI32' name 'DescribePixelFormat';
       FUNCTION DeviceCapabilities(CONST s1,s2:CSTRING;w:WORD;VAR s:STRING;
                                    VAR mode:DEVMODE):LONGINT;
                     APIENTRY;    'GDI32' name 'DeviceCapabilitiesA';
       FUNCTION DrawEscape(ahdc:HDC;i1,i2:LONGINT;CONST s:CSTRING):LONGINT;
                     APIENTRY;    'GDI32' name 'DrawEscape';
       FUNCTION Ellipse(ahdc:HDC;i1,i2,i3,i4:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'Ellipse';
       FUNCTION EnumFontFamilies(ahdc:HDC;CONST name:CSTRING;proc:FONTENUMPROC;
                                 alParam:LPARAM):LONGINT;
                     APIENTRY;    'GDI32' name 'EnumFontFamiliesA';
       FUNCTION EnumFonts(ahdc:HDC;CONST FaceName:CSTRING;proc:FONTENUMPROC;
                          data:POINTER):LONGINT;
                     APIENTRY;    'GDI32' name 'EnumFontsA';
       FUNCTION EnumObjects(ahdc:HDC;i:LONGINT;proc:GOBJENUMPROC;alParam:LPARAM):LONGINT;
                     APIENTRY;    'GDI32' name 'EnumObjects';
       FUNCTION EqualRgn(ahrgn1,ahrgn2:HRGN):BOOL;
                     APIENTRY;    'GDI32' name 'EqualRgn';
       FUNCTION Escape(ahdc:HDC;i1,i2:LONGINT;CONST s:CSTRING;VAR Buf):LONGINT;
                     APIENTRY;    'GDI32' name 'Escape';
       FUNCTION ExtEscape(ahdc:HDC;i1,i2:LONGINT;CONST s:CSTRING;i3:LONGINT;
                          VAR s1:CSTRING):LONGINT;
                     APIENTRY;    'GDI32' name 'ExtEscape';
       FUNCTION ExcludeClipRect(ahdc:HDC;i1,i2,i3,i4:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'ExcludeClipRect';
       FUNCTION ExtCreateRegion(CONST form:XFORM;dw:LONGWORD;CONST data:RGNDATA):HRGN;
                     APIENTRY;    'GDI32' name 'ExtCreateRegion';
       FUNCTION ExtFloodFill(ahdc:HDC;x,y:LONGINT;color:COLORREF;p:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'ExtFloodFill';
       FUNCTION FillRgn(ahdc:HDC;ahrgn:HRGN;ahBrush:HBRUSH):BOOL;
                     APIENTRY;    'GDI32' name 'FillRgn';
       FUNCTION FloodFill(ahdc:HDC;X,Y:LONGINT;Color:COLORREF):BOOL;
                     APIENTRY;    'GDI32' name 'FloodFill';
       FUNCTION FrameRgn(ahdc:HDC;ahrgn:HRGN;ahbrush:HBRUSH;x,y:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'FrameRgn';
       FUNCTION GetROP2(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetROP2';
       FUNCTION GetAspectRatioFilterEx(ahdc:HDC;VAR asize:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'GetAspectRatioFilterEx';
       FUNCTION GetBkColor(ahdc:HDC):COLORREF;
                     APIENTRY;    'GDI32' name 'GetBkColor';
       FUNCTION GetBkMode(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetBkMode';
       FUNCTION GetBitmapBits(ahBitmap:HBITMAP;count:LONG;VAR Buffer):LONG;
                     APIENTRY;    'GDI32' name 'GetBitmapBits';
       FUNCTION GetBitmapDimensionEx(ahBitmap:HBITMAP;VAR sSize:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'GetBitmapDimensionEx';
       FUNCTION GetBoundsRect(ahdc:HDC;VAR rc:RECT;f:LONGWORD):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetBoundsRect';
       FUNCTION GetBrushOrgEx(ahdc:HDC;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'GetBrushOrgEx';
       FUNCTION GetCharWidth(ahdc:HDC;p1,p2:LONGWORD;VAR r:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'GetCharWidthA';
       FUNCTION GetCharWidth32(ahdc:HDC;p1,p2:LONGWORD;VAR r:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'GetCharWidth32A';
       FUNCTION GetCharWidthFloat(ahdc:HDC;p1,p2:LONGWORD;VAR r:FLOAT):BOOL;
                     APIENTRY;    'GDI32' name 'GetCharWidthFloatA';
       FUNCTION GetCharABCWidths(ahdc:HDC;p1,p2:LONGWORD;VAR r:ABC):BOOL;
                     APIENTRY;    'GDI32' name 'GetCharABCWidthsA';
       FUNCTION GetCharABCWidthsFloat(ahdc:HDC;p1,p2:LONGWORD;VAR r:ABCFLOAT):BOOL;
                     APIENTRY;    'GDI32' name 'GetCharABCWidthsFloatA';
       FUNCTION GetClipBox(ahdc:HDC;VAR rec:RECT):LONGINT;
                     APIENTRY;    'GDI32' name 'GetClipBox';
       FUNCTION GetClipRgn(ahdc:HDC;ahrgn:HRGN):LONGINT;
                     APIENTRY;    'GDI32' name 'GetClipRgn';
       FUNCTION GetMetaRgn(ahdc:HDC;ahrgn:HRGN):LONGINT;
                     APIENTRY;    'GDI32' name 'GetMetaRgn';
       FUNCTION GetCurrentObject(ahdc:HDC;o:LONGWORD):HGDIOBJ;
                     APIENTRY;    'GDI32' name 'GetCurrentObject';
       FUNCTION GetCurrentPositionEx(ahdc:HDC;VAR CurPos:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'GetCurrentPositionEx';
       FUNCTION GetDeviceCaps(ahdc:HDC;t:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'GetDeviceCaps';
       FUNCTION GetDIBits(ahdc:HDC;ahbitmap:HBITMAP;p1,p2:LONGWORD;VAR Buf;VAR pi;l:LONGWORD):LONGINT;
                     APIENTRY;    'GDI32' name 'GetDIBits';
       FUNCTION GetFontData(ahdc:HDC;p1,p2:LONGWORD;VAR Buf;l:LONGWORD):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetFontData';
       FUNCTION GetGlyphOutline(ahdc:HDC;p1,p2:LONGWORD;VAR gm:GLYPHMETRICS;p3:LONGWORD;
                                 VAR Buf;CONST ma2:MAT2):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetGlyphOutlineA';
       FUNCTION GetGraphicsMode(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetGraphicsMode';
       FUNCTION GetMapMode(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetMapMode';
       FUNCTION GetMetaFileBitsEx(ahmeta:HMETAFILE;l:LONGWORD;VAR Buf):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetMetaFileBitsEx';
       FUNCTION GetMetaFile(CONST Name:CSTRING):HMETAFILE;
                     APIENTRY;    'GDI32' name 'GetMetaFileA';
       FUNCTION GetNearestColor(ahdc:HDC;col:COLORREF):COLORREF;
                     APIENTRY;    'GDI32' name 'GetNearestColor';
       FUNCTION GetNearestPaletteIndex(ahpal:HPALETTE;cref:COLORREF):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetNearestPaletteIndex';
       FUNCTION GetObjectType(h:HGDIOBJ):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetObjectType';
       FUNCTION GetOutlineTextMetrics(ahdc:HDC;p1:LONGWORD;VAR tm:OUTLINETEXTMETRIC):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetOutlineTextMetricsA';
       FUNCTION GetPaletteEntries(ahpal:HPALETTE;p1,p2:LONGWORD;VAR pe:PALETTEENTRY):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetPaletteEntries';
       FUNCTION GetPixel(ahdc:HDC;x,y:LONGINT):COLORREF;
                     APIENTRY;    'GDI32' name 'GetPixel';
       FUNCTION GetPixelFormat(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetPixelFormat';
       FUNCTION GetPolyFillMode(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetPolyFillMode';
       FUNCTION GetRasterizerCaps(VAR rs:RASTERIZER_STATUS;p:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'GetRasterizerCaps';
       FUNCTION GetRegionData(ahrgn:HRGN;p:LONGWORD;VAR rgnd:RGNDATA):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetRegionData';
       FUNCTION GetRgnBox(ahrn:HRGN;VAR rec:RECT):LONGINT;
                     APIENTRY;    'GDI32' name 'GetRgnBox';
       FUNCTION GetStockObject(o:LONGINT):HGDIOBJ;
                     APIENTRY;    'GDI32' name 'GetStockObject';
       FUNCTION GetStretchBltMode(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetStretchBltMode';
       FUNCTION GetSystemPaletteEntries(ahdc:HDC;aStart,aEnd:LONGWORD;
                                        VAR Result:PALETTEENTRY):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetSystemPaletteEntries';
       FUNCTION GetSystemPaletteUse(ahdc:HDC):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetSystemPaletteUse';
       FUNCTION GetTextCharacterExtra(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetTextCharacterExtra';
       FUNCTION GetTextAlign(ahdc:HDC):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetTextAlign';
       FUNCTION GetTextColor(ahdc:HDC):COLORREF;
                     APIENTRY;    'GDI32' name 'GetTextColor';
       FUNCTION GetTextExtentPoint(ahdc:HDC;CONST s:CSTRING;i:LONGINT;VAR si:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'GetTextExtentPointA';
       FUNCTION GetTextExtentPoint32(ahdc:HDC;CONST str;strlen:LONGINT;
                                     VAR asize:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'GetTextExtentPoint32A';
       FUNCTION GetTextExtentExPoint(ahdc:HDC;CONST s:CSTRING;i1,i2:LONGINT;VAR r1,r2:LONGINT;VAR si:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'GetTextExtentExPointA';
       FUNCTION GetViewportExtEx(ahdc:HDC;VAR si:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'GetViewportExtEx';
       FUNCTION GetViewportOrgEx(ahdc:HDC;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'GetViewportOrgEx';
       FUNCTION GetWindowExtEx(ahdc:HDC;VAR si:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'GetWindowExtEx';
       FUNCTION GetWindowOrgEx(ahdc:HDC;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'GetWindowOrgEx';
       FUNCTION IntersectClipRect(ahdc:HDC;i1,i2,i3,i4:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'IntersectClipRect';
       FUNCTION InvertRgn(ahdc:HDC;ahrgn:HRGN):BOOL;
                     APIENTRY;    'GDI32' name 'InvertRgn';
       FUNCTION LineDDA(x,y,x1,y1:LONGINT;p:LINEDDAPROC;param:LPARAM):BOOL;
                     APIENTRY;    'GDI32' name 'LineDDA';
       FUNCTION LineTo(ahdc:HDC;X,Y:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'LineTo';
       FUNCTION MaskBlt(ahdc:HDC;i1,i2,i3,i4:LONGINT;ahdc1:HDC;i5,i6:LONGINT;ahbitmap:HBITMAP;
                        i7,i8:LONGINT;m:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'MaskBlt';
       FUNCTION PlgBlt(ahdc:HDC;CONST pt:POINT;ahdc1:HDC;i1,i2,i3,i4:LONGINT;ahbitmap:HBITMAP;
                       i5,i6:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'PlgBlt';
       FUNCTION OffsetClipRgn(ahdc:HDC;x,y:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'OffsetClipRgn';
       FUNCTION OffsetRgn(ahrgn:HRGN;x,y:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'OffsetRgn';
       FUNCTION PatBlt(ahdc:HDC;x,y,w,h:LONGINT;m:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'PatBlt';
       FUNCTION Pie(ahdc:HDC;i1,i2,i3,i4,i5,i6,i7,i8:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'Pie';
       FUNCTION PlayMetaFile(ahdc:HDC;hmeta:HMETAFILE):BOOL;
                     APIENTRY;    'GDI32' name 'PlayMetaFile';
       FUNCTION PaintRgn(ahdc:HDC;ahrgn:HRGN):BOOL;
                     APIENTRY;    'GDI32' name 'PaintRgn';
       FUNCTION PolyPolygon(ahdc:HDC;CONST pt:POINT;VAR i:LONGINT;ii:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'PolyPolygon';
       FUNCTION PtInRegion(ahrgn:HRGN;x,y:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'PtInRegion';
       FUNCTION PtVisible(ahdc:HDC;x,y:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'PtVisible';
       FUNCTION RectInRegion(ahrgn:HRGN;CONST rc:RECT):BOOL;
                     APIENTRY;    'GDI32' name 'RectInRegion';
       FUNCTION RectVisible(ahdc:HDC;CONST rc:RECT):BOOL;
                     APIENTRY;    'GDI32' name 'RectVisible';
       FUNCTION Rectangle(ahdc:HDC;xLeft,yTop,xRight,yBottom:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'Rectangle';
       FUNCTION RestoreDC(ahdc:HDC;m:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'RestoreDC';
       FUNCTION ResetDC(ahdc:HDC;CONST dm:DEVMODE):HDC;
                     APIENTRY;    'GDI32' name 'ResetDCA';
       FUNCTION RealizePalette(ahdc:HDC):ULONG;
                     APIENTRY;    'GDI32' name 'RealizePalette';
       FUNCTION RemoveFontResource(CONST s:CSTRING):BOOL;
                     APIENTRY;    'GDI32' name 'RemoveFontResourceA';
       FUNCTION RoundRect(ahdc:HDC;i1,i2,i3,i4,i5,i6:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'RoundRect';
       FUNCTION ResizePalette(ahpal:HPALETTE;m:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'ResizePalette';
       FUNCTION SaveDC(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'SaveDC';
       FUNCTION SelectClipRgn(ahdc:HDC;ahrgn:HRGN):LONGINT;
                     APIENTRY;    'GDI32' name 'SelectClipRgn';
       FUNCTION ExtSelectClipRgn(ahdc:HDC;ahrgn:HRGN;mode:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'ExtSelectClipRgn';
       FUNCTION SetMetaRgn(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'SetMetaRgn';
       FUNCTION SelectObject(ahdc:HDC;obj:HGDIOBJ):HGDIOBJ;
                     APIENTRY;    'GDI32' name 'SelectObject';
       FUNCTION SelectPalette(ahdc:HDC;ahpal:HPALETTE;b:BOOL):HPALETTE;
                     APIENTRY;    'GDI32' name 'SelectPalette';
       FUNCTION SetBkColor(ahdc:HDC;NewColor:COLORREF):COLORREF;
                     APIENTRY;    'GDI32' name 'SetBkColor';
       FUNCTION SetBkMode(ahdc:HDC;NewMode:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetBkMode';
       FUNCTION SetBitmapBits(ahbitmap:HBITMAP;Len:LONGWORD;CONST Buf):LONGINT;
                     APIENTRY;    'GDI32' name 'SetBitmapBits';
       FUNCTION SetBoundsRect(ahdc:HDC;CONST rc:RECT;m:LONGWORD):LONGWORD;
                     APIENTRY;    'GDI32' name 'SetBoundsRect';
       FUNCTION SetDIBits(ahdc:HDC;ahbit:HBITMAP;u1,u2:LONGWORD;CONST Buf;VAR bi:BITMAPINFO;u3:LONGWORD):LONGINT;
                     APIENTRY;    'GDI32' name 'SetDIBits';
       FUNCTION SetDIBitsToDevice(ahdc:HDC;i1,i2:LONGINT;u1,u2:LONGWORD;i3,i4:LONGINT;u3,u4:LONGWORD;
                                  CONST Buf;VAR bi:BITMAPINFO;m:LONGWORD):LONGINT;
                     APIENTRY;    'GDI32' name 'SetDIBitsToDevice';
       FUNCTION SetMapperFlags(ahdc:HDC;f:LONGWORD):LONGWORD;
                     APIENTRY;    'GDI32' name 'SetMapperFlags';
       FUNCTION SetGraphicsMode(ahdc:HDC;iMode:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetGraphicsMode';
       FUNCTION SetMapMode(ahdc:HDC;mode:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetMapMode';
       FUNCTION SetMetaFileBitsEx(u1:LONGWORD;VAR Buf):HMETAFILE;
                     APIENTRY;    'GDI32' name 'SetMetaFileBitsEx';
       FUNCTION SetPaletteEntries(ahpal:HPALETTE;u1,u2:LONGWORD;VAR e:PALETTEENTRY):LONGWORD;
                     APIENTRY;    'GDI32' name 'SetPaletteEntries';
       FUNCTION SetPixel(ahdc:HDC;x,y:LONGINT;color:COLORREF):COLORREF;
                     APIENTRY;    'GDI32' name 'SetPixel';
       FUNCTION SetPixelV(ahdc:HDC;x,y:LONGINT;color:COLORREF):BOOL;
                     APIENTRY;    'GDI32' name 'SetPixelV';
       FUNCTION SetPixelFormat(ahdc:HDC;i:LONGINT;VAR pf:PIXELFORMATDESCRIPTOR):BOOL;
                     APIENTRY;    'GDI32' name 'SetPixelFormat';
       FUNCTION SetPolyFillMode(ahdc:HDC;mode:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetPolyFillMode';
       FUNCTION StretchBlt(Src:HDC;SrcX,SrcY,SrcW,SrcH:LONGINT;
                           Dest:HDC;DestX,DestY,DestW,DestH:LONGINT;
                           CopyMode:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'StretchBlt';
       FUNCTION SetRectRgn(ahrgn:HRGN;i1,i2,i3,i4:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'SetRectRgn';
       FUNCTION StretchDIBits(ahdc:HDC;i1,i2,i3,i4,i5,i6,i7,i8:LONGINT;CONST Buf;VAR bi:BITMAPINFO;
                              u1,u2:LONGWORD):LONGINT;
                     APIENTRY;    'GDI32' name 'StretchDIBits';
       FUNCTION SetROP2(ahdc:HDC;Mode:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetROP2';
       FUNCTION SetStretchBltMode(ahdc:HDC;Mode:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetStretchBltMode';
       FUNCTION SetSystemPaletteUse(ahdc:HDC;u:LONGWORD):LONGWORD;
                     APIENTRY;    'GDI32' name 'SetSystemPaletteUse';
       FUNCTION SetTextCharacterExtra(ahdc:HDC;v:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetTextCharacterExtra';
       FUNCTION SetTextColor(ahdc:HDC;NewColor:COLORREF):COLORREF;
                     APIENTRY;    'GDI32' name 'SetTextColor';
       FUNCTION SetTextAlign(ahdc:HDC;Align:ULONG):ULONG;
                     APIENTRY;    'GDI32' name 'SetTextAlign';
       FUNCTION SetTextJustification(ahdc:HDC;x,y:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'SetTextJustification';
       FUNCTION UpdateColors(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'UpdateColors';
       FUNCTION PlayMetaFileRecord(ahdc:HDC;VAR t:HANDLETABLE;VAR r:METARECORD;m:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'PlayMetaFileRecord';
       FUNCTION EnumMetaFile(ahdc:HDC;ahmeta:HMETAFILE;proc:MFENUMPROC;param:LPARAM):BOOL;
                     APIENTRY;    'GDI32' name 'EnumMetaFile';
       FUNCTION CloseEnhMetaFile(ahdc:HDC):HENHMETAFILE;
                     APIENTRY;    'GDI32' name 'CloseEnhMetaFile';
       FUNCTION CopyEnhMetaFile(handle:HENHMETAFILE;CONST Name:CSTRING):HENHMETAFILE;
                     APIENTRY;    'GDI32' name 'CopyEnhMetaFileA';
       FUNCTION CreateEnhMetaFile(ahdc:HDC;CONST Name:CSTRING;CONST rc:RECT;CONST n1:CSTRING):HDC;
                     APIENTRY;    'GDI32' name 'CreateEnhMetaFileA';
       FUNCTION DeleteEnhMetaFile(h:HENHMETAFILE):BOOL;
                     APIENTRY;    'GDI32' name 'DeleteEnhMetaFile';
       FUNCTION EnumEnhMetaFile(ahdc:HDC;h:HENHMETAFILE;proc:ENHMFENUMPROC;VAR Buf;CONST rc:RECT):BOOL;
                     APIENTRY;    'GDI32' name 'EnumEnhMetaFile';
       FUNCTION GetEnhMetaFile(CONST Name:CSTRING):HENHMETAFILE;
                     APIENTRY;    'GDI32' name 'GetEnhMetaFileA';
       FUNCTION GetEnhMetaFileBits(h:HENHMETAFILE;u:LONGWORD;VAR Buf):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetEnhMetaFileBits';
       FUNCTION GetEnhMetaFileDescription(h:HENHMETAFILE;u:LONGWORD;VAR Name:CSTRING):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetEnhMetaFileDescriptionA';
       FUNCTION GetEnhMetaFileHeader(h:HENHMETAFILE;u:LONGWORD;VAR header:ENHMETAHEADER ):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetEnhMetaFileHeader';
       FUNCTION GetEnhMetaFilePaletteEntries(h:HENHMETAFILE;u:LONGWORD;VAR e:PALETTEENTRY ):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetEnhMetaFilePaletteEntries';
       FUNCTION GetWinMetaFileBits(h:HENHMETAFILE;u:LONGWORD;VAR Buf;i:LONGINT;ahdc:HDC):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetWinMetaFileBits';
       FUNCTION PlayEnhMetaFile(ahdc:HDC;h:HENHMETAFILE;CONST rc:RECT):BOOL;
                     APIENTRY;    'GDI32' name 'PlayEnhMetaFile';
       FUNCTION PlayEnhMetaFileRecord(ahdc:HDC;VAR t:HANDLETABLE;CONST r:ENHMETARECORD;u:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'PlayEnhMetaFileRecord';
       FUNCTION SetEnhMetaFileBits(u:LONGWORD;CONST Buf):HENHMETAFILE;
                     APIENTRY;    'GDI32' name 'SetEnhMetaFileBits';
       FUNCTION SetWinMetaFileBits(u:LONGWORD;CONST Buf;ahdc:HDC;CONST p:METAFILEPICT):HENHMETAFILE;
                     APIENTRY;    'GDI32' name 'SetWinMetaFileBits';
       FUNCTION GdiComment(ahdc:HDC;u:LONGWORD;CONST Buf):BOOL;
                     APIENTRY;    'GDI32' name 'GdiComment';
       FUNCTION GetTextMetrics(ahdc:HDC;VAR tm:TEXTMETRIC):BOOL;
                     APIENTRY;    'GDI32' name 'GetTextMetricsA';
       FUNCTION PolyPolyline(ahdc:HDC;CONST pt:POINT;CONST Buf;u:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'PolyPolyline';
       FUNCTION GetWorldTransform(ahdc:HDC;VAR f:XFORM):BOOL;
                     APIENTRY;    'GDI32' name 'GetWorldTransform';
       FUNCTION SetWorldTransform(ahdc:HDC;CONST xf:XFORM):BOOL;
                     APIENTRY;    'GDI32' name 'SetWorldTransform';
       FUNCTION ModifyWorldTransform(ahdc:HDC;CONST xf:XFORM;u:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'ModifyWorldTransform';
       FUNCTION CombineTransform(VAR xf:XFORM;CONST xf1,xf2:XFORM):BOOL;
                     APIENTRY;    'GDI32' name 'CombineTransform';
       FUNCTION CreateDIBSection(ahdc:HDC;CONST bi:BITMAPINFO;u:LONGWORD;VAR p:POINTER;h:HANDLE;u1:LONGWORD):HBITMAP;
                     APIENTRY;    'GDI32' name 'CreateDIBSection';
       FUNCTION GetDIBColorTable(ahdc:HDC;u1,u2:LONGWORD;VAR r:RGBQUAD):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetDIBColorTable';
       FUNCTION SetDIBColorTable(ahdc:HDC;u1,u2:LONGWORD;CONST r:RGBQUAD):LONGWORD;
                     APIENTRY;    'GDI32' name 'SetDIBColorTable';
       FUNCTION SetColorAdjustment(ahdc:HDC;CONST a:COLORADJUSTMENT):BOOL;
                     APIENTRY;    'GDI32' name 'SetColorAdjustment';
       FUNCTION GetColorAdjustment(ahdc:HDC;VAR a:COLORADJUSTMENT):BOOL;
                     APIENTRY;    'GDI32' name 'GetColorAdjustment';
       FUNCTION CreateHalftonePalette(ahdc:HDC):HPALETTE;
                     APIENTRY;    'GDI32' name 'CreateHalftonePalette';
       FUNCTION StartDocAPI(ahdc:HDC;CONST i:DOCINFO):LONGINT;
                     APIENTRY;    'GDI32' name 'StartDocA';
       FUNCTION EndDocAPI(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'EndDoc';
       FUNCTION StartPage(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'StartPage';
       FUNCTION EndPage(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'EndPage';
       FUNCTION AbortDocAPI(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'AbortDoc';
       FUNCTION SetAbortProcAPI(ahdc:HDC;proc:ABORTPROC):LONGINT;
                     APIENTRY;    'GDI32' name 'SetAbortProc';
       FUNCTION AbortPath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'AbortPath';
       FUNCTION ArcTo(ahdc:HDC;i1,i2,i3,i4,i5,i6,i7,i8:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'ArcTo';
       FUNCTION BeginPath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'BeginPath';
       FUNCTION CloseFigure(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'CloseFigure';
       FUNCTION EndPath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'EndPath';
       FUNCTION FillPath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'FillPath';
       FUNCTION FlattenPath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'FlattenPath';
       FUNCTION GetPath(ahdc:HDC;VAR pt:POINT;VAR b:BYTE;i:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'GetPath';
       FUNCTION PathToRegion(ahdc:HDC):HRGN;
                     APIENTRY;    'GDI32' name 'PathToRegion';
       FUNCTION PolyDraw(ahdc:HDC;CONST pt:POINT;CONST Buf;i:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'PolyDraw';
       FUNCTION SelectClipPath(ahdc:HDC;i:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'SelectClipPath';
       FUNCTION SetArcDirection(ahdc:HDC;d:LONGINT):LONGINT;
                     APIENTRY;    'GDI32' name 'SetArcDirection';
       FUNCTION SetMiterLimitAPI(ahdc:HDC;f:FLOAT;VAR f1:FLOAT):BOOL;
                     APIENTRY;    'GDI32' name 'SetMiterLimit';
       FUNCTION StrokeAndFillPath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'StrokeAndFillPath';
       FUNCTION StrokePath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'StrokePath';
       FUNCTION WidenPath(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'WidenPath';
       FUNCTION ExtCreatePen(u1,u2:LONGWORD;CONST lb:LOGBRUSH;u3:LONGWORD;CONST Buf):HPEN;
                     APIENTRY;    'GDI32' name 'ExtCreatePen';
       FUNCTION GetMiterLimit(ahdc:HDC;VAR f:FLOAT):BOOL;
                     APIENTRY;    'GDI32' name 'GetMiterLimit';
       FUNCTION GetArcDirection(ahdc:HDC):LONGINT;
                     APIENTRY;    'GDI32' name 'GetArcDirection';
       FUNCTION GetObject(aobj:HGDIOBJ;size:LONGINT;VAR Buffer):LONGINT;
                     APIENTRY;    'GDI32' name 'GetObjectA';
       FUNCTION MoveToEx(ahdc:HDC;NewX,NewY:LONGINT;VAR OldPos:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'MoveToEx';
       FUNCTION TextOut(ahdc:HDC;x,y:LONGINT;CONST apString;len:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'TextOutA';
       FUNCTION ExtTextOutAPI(ahdc:HDC;i1,i2:LONGINT;u:LONGWORD;CONST r:RECT;CONST s:CSTRING;
                           u1:LONGWORD;CONST Buf):BOOL;
                     APIENTRY;    'GDI32' name 'ExtTextOutA';
       FUNCTION PolyTextOut(ahdc:HDC;CONST pt:POLYTEXT;i:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'PolyTextOutA';
       FUNCTION CreatePolygonRgn(CONST pt:POINT;x,y:LONGINT):HRGN;
                     APIENTRY;    'GDI32' name 'CreatePolygonRgn';
       FUNCTION DPtoLP(ahdc:HDC;VAR PointList:POINT;Count:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'DPtoLP';
       FUNCTION LPtoDP(ahdc:HDC;VAR PointList:POINT;Count:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'LPtoDP';
       FUNCTION Polygon(ahdc:HDC;CONST points:POINT;Count:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'Polygon';
       FUNCTION Polyline(ahdc:HDC;CONST points:POINT;count:LONGINT):BOOL;
                     APIENTRY;    'GDI32' name 'Polyline';
       FUNCTION PolyBezier(ahdc:HDC;CONST aptl;count:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'PolyBezier';
       FUNCTION PolyBezierTo(ahdc:HDC;CONST aptl;count:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'PolyBezierTo';
       FUNCTION PolylineTo(ahdc:HDC;CONST aptl;count:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'PolylineTo';
       FUNCTION SetViewportExtEx(ahdc:HDC;NewWidth,NewHeight:LONGINT;VAR OldExt:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'SetViewportExtEx';
       FUNCTION SetViewportOrgEx(ahdc:HDC;NewX,NewY:LONGINT;VAR OldOrg:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'SetViewportOrgEx';
       FUNCTION SetWindowExtEx(ahdc:HDC;NewWidth,NewHeight:LONGINT;VAR OldExt:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'SetWindowExtEx';
       FUNCTION SetWindowOrgEx(ahdc:HDC;NewX,NewY:LONGINT;VAR OldOrg:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'SetWindowOrgEx';
       FUNCTION OffsetViewportOrgEx(ahdc:HDC;i1,i2:LONGINT;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'OffsetViewportOrgEx';
       FUNCTION OffsetWindowOrgEx(ahdc:HDC;i1,i2:LONGINT;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'OffsetWindowOrgEx';
       FUNCTION ScaleViewportExtEx(ahdc:HDC;i1,i2,i3,i4:LONGINT;VAR s:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'ScaleViewportExtEx';
       FUNCTION ScaleWindowExtEx(ahdc:HDC;i1,i2,i3,i4:LONGINT;VAR s:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'ScaleWindowExtEx';
       FUNCTION SetBitmapDimensionEx(ahbitmap:HBITMAP;x,y:LONGINT;VAR s:SIZE):BOOL;
                     APIENTRY;    'GDI32' name 'SetBitmapDimensionEx';
       FUNCTION SetBrushOrgEx(ahdc:HDC;x,y:LONGINT;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'SetBrushOrgEx';
       FUNCTION GetTextFace(ahdc:HDC;i:LONGINT;VAR s:CSTRING):LONGINT;
                     APIENTRY;    'GDI32' name 'GetTextFaceA';
       FUNCTION GetKerningPairs(ahdc:HDC;u:LONGWORD;VAR kp:KERNINGPAIR):LONGWORD;
                     APIENTRY;    'GDI32' name 'GetKerningPairsA';
       FUNCTION GetDCOrgEx(ahdc:HDC;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'GetDCOrgEx';
       FUNCTION FixBrushOrgEx(ahdc:HDC;x,y:LONGINT;VAR pt:POINT):BOOL;
                     APIENTRY;    'GDI32' name 'FixBrushOrgEx';
       FUNCTION UnrealizeObject(o:HGDIOBJ):BOOL;
                     APIENTRY;    'GDI32' name 'UnrealizeObject';
       FUNCTION GdiFlush:BOOL;
                     APIENTRY;    'GDI32' name 'GdiFlush';
       FUNCTION GdiSetBatchLimit(u:LONGWORD):LONGWORD;
                     APIENTRY;    'GDI32' name 'GdiSetBatchLimit';
       FUNCTION GdiGetBatchLimit:LONGWORD;
                     APIENTRY;    'GDI32' name 'GdiGetBatchLimit';
       FUNCTION wglCreateContext(ahdc:HDC):HGLRC;
                     APIENTRY;    'GDI32' name 'wglCreateContext';
       FUNCTION wglDeleteContext(h:HGLRC):BOOL;
                     APIENTRY;    'GDI32' name 'wglDeleteContext';
       FUNCTION wglGetCurrentContext:HGLRC;
                     APIENTRY;    'GDI32' name 'wglGetCurrentContext';
       FUNCTION wglGetCurrentDC:HDC;
                     APIENTRY;    'GDI32' name 'wglGetCurrentDC';
       FUNCTION wglMakeCurrent(ahdc:HDC;h:HGLRC):BOOL;
                     APIENTRY;    'GDI32' name 'wglMakeCurrent';
       FUNCTION wglUseFontBitmaps(ahdc:HDC;u1,u2,u3:LONGWORD):BOOL;
                     APIENTRY;    'GDI32' name 'wglUseFontBitmapsA';
       FUNCTION SwapBuffers(ahdc:HDC):BOOL;
                     APIENTRY;    'GDI32' name 'SwapBuffers';
END;

FUNCTION AngleArc(ahdc:HDC;x,y:LONGINT;Radius:LONGWORD;
                  StartAngle,SweepAngle:SINGLE):BOOL;
FUNCTION MAKEROP4(fore,back:LONGWORD):LONGWORD;
FUNCTION RGB(r,g,b:LONGWORD):COLORREF;
FUNCTION PALETTERGB(r,g,b:LONGWORD):LONGWORD;
FUNCTION PALETTEINDEX(i:LONGWORD):COLORREF;
FUNCTION GetRValue(rgb:LONGWORD):BYTE;
FUNCTION GetGValue(rgb:LONGWORD):BYTE;
FUNCTION GetBValue(rgb:LONGWORD):BYTE;

IMPLEMENTATION

FUNCTION AngleArc(ahdc:HDC;x,y:LONGINT;Radius:LONGWORD;
                  StartAngle,SweepAngle:SINGLE):BOOL;
BEGIN
  {$IFDEF VER30}
  ASM
        LEA EAX,SweepAngle
        PUSH DWORD PTR [EAX]
        LEA EAX,StartAngle
        PUSH DWORD PTR [EAX]
        PUSH DWORD PTR Radius
        PUSH DWORD PTR y
        PUSH DWORD PTR x
        PUSH DWORD PTR ahdc
        CALLDLL GDI32,'AngleArc'
        MOV result,EAX
  END;
  {$ELSE}
  ASM
        LEA EAX,SweepAngle
        PUSH DWORD PTR [EAX]
        LEA EAX,StartAngle
        PUSH DWORD PTR [EAX]
        PUSH DWORD PTR Radius
        PUSH DWORD PTR y
        PUSH DWORD PTR x
        PUSH DWORD PTR ahdc
        CALLDLL GDI32,'AngleArc'
        MOV [EBP-4],EAX
  END;
  {$ENDIF}
END;

FUNCTION MAKEROP4(fore,back:LONGWORD):LONGWORD;
BEGIN
  result:=((back SHL 8)AND $FF000000) OR fore;
END;

FUNCTION RGB(r,g,b:LONGWORD):COLORREF;
BEGIN
  result:=(r AND 255) OR ((g AND 255) SHL 8) OR ((b AND 255) SHL 16);
END;

FUNCTION PALETTERGB(r,g,b:LONGWORD):LONGWORD;
BEGIN
  result:=$02000000 OR RGB(r,g,b);
END;

FUNCTION PALETTEINDEX(i:LONGWORD):COLORREF;
BEGIN
  result:=$01000000 OR i;
END;

FUNCTION GetRValue(rgb:LONGWORD):BYTE;
BEGIN
  result:=rgb AND 255;
END;

FUNCTION GetGValue(rgb:LONGWORD):BYTE;
BEGIN
  result:=(rgb SHR 8) AND 255;
END;

FUNCTION GetBValue(rgb:LONGWORD):BYTE;
BEGIN
  result:=(rgb SHR 16) AND 255;
END;

END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  01-Nov-04  WD        API-Call "GetDefaultPrinter" eingebaut

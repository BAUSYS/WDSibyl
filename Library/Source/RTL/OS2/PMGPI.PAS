
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PMGPI;

{****************************************************************************
 *                                                                          *
 * OS/2 Presentation Manager GPI constants, types and function declarations *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def,PmBitMap,PmWin;

{ General GPI return values }

CONST
     GPI_ERROR                       =0;
     GPI_OK                          =1;
     GPI_ALTERROR                    =-1;


{ fixed point number - implicit binary point between 2 and 3 hex digits }

TYPE
    FIXED=LONG;
    FIXED88=WORD;
    FIXED114=WORD;


{ structure for size parameters e.g. for GpiCreatePS }

TYPE
    PSIZEL=^SIZEL;
    SIZEL=RECORD
               cx:LONG;
               cy:LONG;
          END;

{ return code on GpiQueryLogColorTable,GpiQueryRealColors and GpiQueryPel }

CONST
     CLR_NOINDEX               =-254;

{ units for GpiCreatePS and others }

CONST
    PU_ARBITRARY               =$0004;
    PU_PELS                    =$0008;
    PU_LOMETRIC                =$000C;
    PU_HIMETRIC                =$0010;
    PU_LOENGLISH               =$0014;
    PU_HIENGLISH               =$0018;
    PU_TWIPS                   =$001C;

   { format for GpiCreatePS }
    GPIF_DEFAULT               =0;
    GPIF_SHORT                 =$0100;
    GPIF_LONG                  =$0200;


   { PS type for GpiCreatePS }
    GPIT_NORMAL                =0;
    GPIT_MICRO                 =$1000;


   { implicit associate flag for GpiCreatePS }
    GPIA_NOASSOC               =0;
    GPIA_ASSOC                 =$4000;

   { PS Fill type for GpiCreatePS defect: 61035 RickT Add exclusive fill }
    GPIM_AREAEXCL              =$8000;


   { return error for GpiQueryDevice }
    HDC_ERROR                  =-1;

{ options for GpiResetPS }
CONST
    GRES_ATTRS                 =$0001;
    GRES_SEGMENTS              =$0002;
    GRES_ALL                   =$0004;

   { option masks for PS options used by GpiQueryPs }
    PS_UNITS                   =$00FC;
    PS_FORMAT                  =$0F00;
    PS_TYPE                    =$1000;
    PS_MODE                    =$2000;
    PS_ASSOCIATE               =$4000;
    PS_NORESET                 =$8000;


   { error context returned by GpiErrorSegmentData }
    GPIE_SEGMENT               =0;
    GPIE_ELEMENT               =1;
    GPIE_DATA                  =2;


   { control parameter for GpiSetDrawControl }
    DCTL_ERASE                     =1;
    DCTL_DISPLAY                   =2;
    DCTL_BOUNDARY                  =3;
    DCTL_DYNAMIC                   =4;
    DCTL_CORRELATE                 =5;

   { constants for GpiSet/QueryDrawControl }
    DCTL_ERROR                     =-1;
    DCTL_OFF                       =0;
    DCTL_ON                        =1;

    { constants for GpiSet/QueryStopDraw }
    SDW_ERROR                      =-1;
    SDW_OFF                        =0;
    SDW_ON                         =1;


    { drawing for GpiSet/QueryDrawingMode }
    DM_ERROR                        =0;
    DM_DRAW                         =1;
    DM_RETAIN                       =2;
    DM_DRAWANDRETAIN                =3;


   { options for GpiSetPickApertureSize }
CONST
    PICKAP_DEFAULT                  =0;
    PICKAP_REC                      =2;

   { type of correlation for GpiCorrelateChain }
    PICKSEL_VISIBLE                 =0;
    PICKSEL_ALL                     =1;

   { return code to indicate correlate hit(s) }
    GPI_HITS                        =2;


   { data formats for GpiPutData and GpiGetData }
CONST
    DFORM_NOCONV                    =0;
    DFORM_S370SHORT                 =1;
    DFORM_PCSHORT                   =2;
    DFORM_PCLONG                    =4;


   { segment attributes used by GpiSet/QuerySegmentAttrs and others }
    ATTR_ERROR                      =-1;
    ATTR_DETECTABLE                 =1;
    ATTR_VISIBLE                    =2;
    ATTR_CHAINED                    =6;
    ATTR_DYNAMIC                    =8;
    ATTR_FASTCHAIN                  =9;
    ATTR_PROP_DETECTABLE            =10;
    ATTR_PROP_VISIBLE               =11;
    ATTR_OFF                        =0;
    ATTR_ON                         =1;

   { segment priority used by GpiSetSegmentPriority and others }
    LOWER_PRI                       =-1;
    HIGHER_PRI                      =1;

   { edit modes used by GpiSet/QueryEditMode }
CONST
    SEGEM_ERROR                         =0;
    SEGEM_INSERT                        =1;
    SEGEM_REPLACE                       =2;


   { co-ordinates space for GpiConvert }
CONST
    CVTC_WORLD                      =1;
    CVTC_MODEL                      =2;
    CVTC_DEFAULTPAGE                =3;
    CVTC_PAGE                       =4;
    CVTC_DEVICE                     =5;

   { type of transformation for GpiSetSegmentTransformMatrix }
    TRANSFORM_REPLACE               =0;
    TRANSFORM_ADD                   =1;
    TRANSFORM_PREEMPT               =2;

   { transform matrix }
TYPE
    PMATRIXLF=^MATRIXLF;
    MATRIXLF=RECORD
                  fxM11:FIXED;
                  fxM12:FIXED;
                  lM13:LONG;
                  fxM21:FIXED;
                  fxM22:FIXED;
                  lM23:LONG;
                  lM31:LONG;
                  lM32:LONG;
                  lM33:LONG;
            END;


   { modes for GpiModifyPath }
CONST
    MPATH_STROKE                    =6;

   { modes for GpiFillPath }
    FPATH_ALTERNATE                 =0;
    FPATH_WINDING                   =2;
    FPATH_INCL                      =0;
    FPATH_EXCL                      =8;

   { modes for GpiSetClipPath }
    SCP_ALTERNATE                   =0;
    SCP_WINDING                     =2;
    SCP_AND                         =4;
    SCP_RESET                       =0;
    SCP_INCL                        =0;
    SCP_EXCL                        =8;



   { options for GpiCreateLogColorTable and others }
CONST
    LCOL_RESET                   =$0001;
    LCOL_REALIZABLE              =$0002;
    LCOL_PURECOLOR               =$0004;
    LCOL_OVERRIDE_DEFAULT_COLORS =$0008;
    LCOL_REALIZED                =$0010;

   { format of logical lColor table for GpiCreateLogColorTable and others }
    LCOLF_DEFAULT                =0;
    LCOLF_INDRGB                 =1;
    LCOLF_CONSECRGB              =2;
    LCOLF_RGB                    =3;
    LCOLF_PALETTE                =4;

   { options for GpiQueryRealColors and others }
    LCOLOPT_REALIZED           =$0001;
    LCOLOPT_INDEX              =$0002;

   { return codes from GpiQueryLogColorTable to indicate it is in RGB mode }
    QLCT_ERROR                  =-1;
    QLCT_RGB                    =-2;

   { GpiQueryLogColorTable index returned for colors not explicitly loaded }
    QLCT_NOTLOADED              =-1;

   { return codes for GpiQueryColorData }
    QCD_LCT_FORMAT              =0;
    QCD_LCT_LOINDEX             =1;
    QCD_LCT_HIINDEX             =2;
    QCD_LCT_OPTIONS             =3;

   { Palette manager return values }
    PAL_ERROR                   =-1;

   { color flags for GpiCreatePalette and others }
    PC_RESERVED                   =$01;
    PC_EXPLICIT                   =$02;
    PC_NOCOLLAPSE                 =$04;

   { rgb colors }
CONST
    RGB_ERROR              =-255;
    RGB_BLACK              =$00000000;
    RGB_BLUE               =$000000FF;
    RGB_GREEN              =$0000FF00;
    RGB_CYAN               =$0000FFFF;
    RGB_RED                =$00FF0000;
    RGB_PINK               =$00FF00FF;
    RGB_YELLOW             =$00FFFF00;
    RGB_WHITE              =$00FFFFFF;

   { control flags used by GpiBeginArea }
    BA_NOBOUNDARY              =0;
    BA_BOUNDARY                =$0001;


    BA_ALTERNATE               =0;
    BA_WINDING                 =$0002;

    BA_INCL                    =0;
    BA_EXCL                    =8;


   { fill options for GpiBox/GpiFullArc }
    DRO_FILL                   =1;
    DRO_OUTLINE                =2;
    DRO_OUTLINEFILL            =3;

   { basic pattern symbols }
    PATSYM_ERROR                  =-1;
    PATSYM_DEFAULT                = 0;
    PATSYM_DENSE1                 = 1;
    PATSYM_DENSE2                 = 2;
    PATSYM_DENSE3                 = 3;
    PATSYM_DENSE4                 = 4;
    PATSYM_DENSE5                 = 5;
    PATSYM_DENSE6                 = 6;
    PATSYM_DENSE7                 = 7;
    PATSYM_DENSE8                 = 8;
    PATSYM_VERT                   = 9;
    PATSYM_HORIZ                  =10;
    PATSYM_DIAG1                  =11;
    PATSYM_DIAG2                  =12;
    PATSYM_DIAG3                  =13;
    PATSYM_DIAG4                  =14;
    PATSYM_NOSHADE                =15;
    PATSYM_SOLID                  =16;
    PATSYM_HALFTONE               =17;
    PATSYM_HATCH                  =18;
    PATSYM_DIAGHATCH              =19;
    PATSYM_BLANK                  =64;

   { lcid values for GpiSet/QueryPattern and others }
    LCID_ERROR                    =-1;
    LCID_DEFAULT                  =0;




   { mode for GpiSetAttrMode }
CONST
    AM_ERROR                       =-1;
    AM_PRESERVE                    =0;
    AM_NOPRESERVE                  =1;

   { foreground mixes }
    FM_ERROR                       =-1;
    FM_DEFAULT                     =0;
    FM_OR                          =1;
    FM_OVERPAINT                   =2;
    FM_LEAVEALONE                  =5;

    FM_XOR                         =4;
    FM_AND                         =6;
    FM_SUBTRACT                    =7;
    FM_MASKSRCNOT                  =8;
    FM_ZERO                        =9;
    FM_NOTMERGESRC                 =10;
    FM_NOTXORSRC                   =11;
    FM_INVERT                      =12;
    FM_MERGESRCNOT                 =13;
    FM_NOTCOPYSRC                  =14;
    FM_MERGENOTSRC                 =15;
    FM_NOTMASKSRC                  =16;
    FM_ONE                         =17;


   { background mixes }
    BM_ERROR                       =-1;
    BM_DEFAULT                     =0;
    BM_OR                          =1;
    BM_OVERPAINT                   =2;
    BM_LEAVEALONE                  =5;

    BM_XOR                         =4;
    BM_AND                         =6;
    BM_SUBTRACT                    =7;
    BM_MASKSRCNOT                  =8;
    BM_ZERO                        =9;
    BM_NOTMERGESRC                 =10;
    BM_NOTXORSRC                   =11;
    BM_INVERT                      =12;
    BM_MERGESRCNOT                 =13;
    BM_NOTCOPYSRC                  =14;
    BM_MERGENOTSRC                 =15;
    BM_NOTMASKSRC                  =16;
    BM_ONE                         =17;
    BM_SRCTRANSPARENT              =18;
    BM_DESTTRANSPARENT             =19;



   { basic line type styles }
    LINETYPE_ERROR                 =-1;
    LINETYPE_DEFAULT               =0;
    LINETYPE_DOT                   =1;
    LINETYPE_SHORTDASH             =2;
    LINETYPE_DASHDOT               =3;
    LINETYPE_DOUBLEDOT             =4;
    LINETYPE_LONGDASH              =5;
    LINETYPE_DASHDOUBLEDOT         =6;
    LINETYPE_SOLID                 =7;
    LINETYPE_INVISIBLE             =8;
    LINETYPE_ALTERNATE             =9;

   { cosmetic line widths }
    LINEWIDTH_ERROR                =-1;
    LINEWIDTH_DEFAULT              =0;
    LINEWIDTH_NORMAL               =$00010000;   { MAKEFIXED(1,0) }
    LINEWIDTH_THICK                =$00020000;   { MAKEFIXED(2,0) }

   { actual line widths }
    LINEWIDTHGEOM_ERROR            =-1;

   { line end styles }
    LINEEND_ERROR                  =-1;
    LINEEND_DEFAULT                =0;
    LINEEND_FLAT                   =1;
    LINEEND_SQUARE                 =2;
    LINEEND_ROUND                  =3;

   { line join styles }
    LINEJOIN_ERROR                 =-1;
    LINEJOIN_DEFAULT               =0;
    LINEJOIN_BEVEL                 =1;
    LINEJOIN_ROUND                 =2;
    LINEJOIN_MITRE                 =3;

   { character directions }
    CHDIRN_ERROR                   =-1;
    CHDIRN_DEFAULT                 =0;
    CHDIRN_LEFTRIGHT               =1;
    CHDIRN_TOPBOTTOM               =2;
    CHDIRN_RIGHTLEFT               =3;
    CHDIRN_BOTTOMTOP               =4;

   { character text alignments }
    TA_NORMAL_HORIZ     =$0001;
    TA_LEFT             =$0002;
    TA_CENTER           =$0003;
    TA_RIGHT            =$0004;
    TA_STANDARD_HORIZ   =$0005;
    TA_NORMAL_VERT      =$0100;
    TA_TOP              =$0200;
    TA_HALF             =$0300;
    TA_BASE             =$0400;
    TA_BOTTOM           =$0500;
    TA_STANDARD_VERT    =$0600;

   { character modes }
    CM_ERROR                       =-1;
    CM_DEFAULT                     =0;
    CM_MODE1                       =1;
    CM_MODE2                       =2;
    CM_MODE3                       =3;

   { basic marker symbols }
    MARKSYM_ERROR                  =-1;
    MARKSYM_DEFAULT                =0;
    MARKSYM_CROSS                  =1;
    MARKSYM_PLUS                   =2;
    MARKSYM_DIAMOND                =3;
    MARKSYM_SQUARE                 =4;
    MARKSYM_SIXPOINTSTAR           =5;
    MARKSYM_EIGHTPOINTSTAR         =6;
    MARKSYM_SOLIDDIAMOND           =7;
    MARKSYM_SOLIDSQUARE            =8;
    MARKSYM_DOT                    =9;
    MARKSYM_SMALLCIRCLE            =10;
    MARKSYM_BLANK                  =64;

   { formatting options for GpiCharStringPosAt }
    CHS_OPAQUE                 =$0001;
    CHS_VECTOR                 =$0002;
    CHS_LEAVEPOS               =$0008;
    CHS_CLIP                   =$0010;
    CHS_UNDERSCORE             =$0200;
    CHS_STRIKEOUT              =$0400;

   { bundle codes for GpiSetAttributes and GpiQueryAttributes }
    PRIM_LINE                  =1;
    PRIM_CHAR                  =2;
    PRIM_MARKER                =3;
    PRIM_AREA                  =4;
    PRIM_IMAGE                 =5;

   { line bundle mask bits }
    LBB_COLOR                  =$0001;
    LBB_BACK_COLOR             =$0002;
    LBB_MIX_MODE               =$0004;
    LBB_BACK_MIX_MODE          =$0008;
    LBB_WIDTH                  =$0010;
    LBB_GEOM_WIDTH             =$0020;
    LBB_TYPE                   =$0040;
    LBB_END                    =$0080;
    LBB_JOIN                   =$0100;

   { character bundle mask bits }
    CBB_COLOR                  =$0001;
    CBB_BACK_COLOR             =$0002;
    CBB_MIX_MODE               =$0004;
    CBB_BACK_MIX_MODE          =$0008;
    CBB_SET                    =$0010;
    CBB_MODE                   =$0020;
    CBB_BOX                    =$0040;
    CBB_ANGLE                  =$0080;
    CBB_SHEAR                  =$0100;
    CBB_DIRECTION              =$0200;
    CBB_TEXT_ALIGN             =$0400;
    CBB_EXTRA                  =$0800;
    CBB_BREAK_EXTRA            =$1000;

   { marker bundle mask bits }
    MBB_COLOR                  =$0001;
    MBB_BACK_COLOR             =$0002;
    MBB_MIX_MODE               =$0004;
    MBB_BACK_MIX_MODE          =$0008;
    MBB_SET                    =$0010;
    MBB_SYMBOL                 =$0020;
    MBB_BOX                    =$0040;

   { pattern bundle mask bits }
    ABB_COLOR                  =$0001;
    ABB_BACK_COLOR             =$0002;
    ABB_MIX_MODE               =$0004;
    ABB_BACK_MIX_MODE          =$0008;
    ABB_SET                    =$0010;
    ABB_SYMBOL                 =$0020;
    ABB_REF_POINT              =$0040;

   { image bundle mask bits }
    IBB_COLOR                  =$0001;
    IBB_BACK_COLOR             =$0002;
    IBB_MIX_MODE               =$0004;
    IBB_BACK_MIX_MODE          =$0008;

   { structure for GpiSetArcParams and GpiQueryArcParams }
TYPE
    PARCPARAMS=^ARCPARAMS;
    ARCPARAMS=RECORD
                    lP:LONG;
                    lQ:LONG;
                    lR:LONG;
                    lS:LONG;
              END;

   { variation of SIZE used for FIXEDs }
TYPE
   PSIZEF=^SIZEF;
   SIZEF=RECORD
               cx:FIXED;
               cy:FIXED;
         END;

   { structure for gradient parameters e.g. for GpiSetCharAngle }
TYPE
   PGRADIENTL=^GRADIENTL;
   GRADIENTL=RECORD
                   x:LONG;
                   y:LONG;
             END;

   { line bundle for GpiSetAttributes and GpiQueryAttributes }
TYPE
   PLINEBUNDLE=^LINEBUNDLE;
   LINEBUNDLE=RECORD
                   lColor:LONG;
                   lBackColor:LONG;
                   usMixMode:WORD;
                   usBackMixMode:WORD;
                   fxWidth:FIXED;
                   lGeomWidth:LONG;
                   usType:WORD;
                   usEnd:WORD;
                   usJoin:WORD;
                   usReserved:WORD;
              END;

   { character bundle for GpiSetAttributes and GpiQueryAttributes }
TYPE
   PCHARBUNDLE=^CHARBUNDLE;
   CHARBUNDLE=RECORD
                   lColor:LONG;
                   lBackColor:LONG;
                   usMixMode:WORD;
                   usBackMixMode:WORD;
                   usSet:WORD;
                   usPrecision:WORD;
                   sizfxCell:SIZEF;
                   ptlAngle:POINTL;
                   ptlShear:POINTL;
                   usDirection:WORD;
                   usTextAlign:WORD;
                   fxExtra:FIXED;
                   fxBreakExtra:FIXED;
             END;

   { marker bundle for GpiSetAttributes and GpiQueryAttributes }
TYPE
   PMARKERBUNDLE=^MARKERBUNDLE;
   MARKERBUNDLE=RECORD
                     lColor:LONG;
                     lBackColor:LONG;
                     usMixMode:WORD;
                     usBackMixMode:WORD;
                     usSet:WORD;
                     usSymbol:WORD;
                     sizfxCell:SIZEF;
               END;

   { pattern bundle for GpiSetAttributes and GpiQueryAttributes }
TYPE
   PAREABUNDLE=^AREABUNDLE;
   AREABUNDLE=RECORD
                   lColor:LONG;
                   lBackColor:LONG;
                   usMixMode:WORD;
                   usBackMixMode:WORD;
                   usSet:WORD;
                   usSymbol:WORD;
                   ptlRefPoint:POINTL
              END;

   { image bundle for GpiSetAttributes and GpiQueryAttributes }
TYPE
   PIMAGEBUNDLE=^IMAGEBUNDLE;
   IMAGEBUNDLE=RECORD
                    lColor:LONG;
                    lBackColor:LONG;
                    usMixMode:WORD;
                    usBackMixMode:WORD;
               END;

   { pointer to any bundle used by GpiSet/QueryAttrs }
TYPE PBUNDLE=POINTER;

   { array indices for GpiQueryTextBox }
CONST
    TXTBOX_TOPLEFT                 =0;
    TXTBOX_BOTTOMLEFT              =1;
    TXTBOX_TOPRIGHT                =2;
    TXTBOX_BOTTOMRIGHT             =3;
    TXTBOX_CONCAT                  =4;
   { array count for GpiQueryTextBox }
    TXTBOX_COUNT                   =5;

   { return codes for GpiPtVisible }
    PVIS_ERROR                     =0;
    PVIS_INVISIBLE                 =1;
    PVIS_VISIBLE                   =2;

   { return codes for GpiRectVisible }
    RVIS_ERROR                     =0;
    RVIS_INVISIBLE                 =1;
    RVIS_PARTIAL                   =2;
    RVIS_VISIBLE                   =3;



   { return codes from GpiCreateLogFont }
CONST
    FONT_DEFAULT                    =1;
    FONT_MATCH                      =2;

   { lcid type for GpiQuerySetIds }
    LCIDT_FONT                      =6;

    LCIDT_BITMAP                    =7;

   { constant used to delete all lcids by GpiDeleteSetId }
    LCID_ALL                        =-1;

   { kerning data returned by GpiQueryKerningPairs }
TYPE
   PKERNINGPAIRS=^KERNINGPAIRS;
   KERNINGPAIRS=RECORD
                    sFirstChar:SHORT;
                    sSecondChar:SHORT;
                    lKerningAmount:LONG;
                END;

   { data required by GpiQueryFaceString }
TYPE
   PFACENAMEDESC=^FACENAMEDESC;
   FACENAMEDESC=RECORD
                     usSize:WORD;
                     usWeightClass:WORD;
                     usWidthClass:WORD;
                     usReserved:WORD;
                     flOptions:LONGWORD;
                END;

   { FACENAMEDESC 'WeightClass' options for GpiQueryFaceString }
CONST
    FWEIGHT_DONT_CARE      =0;
    FWEIGHT_ULTRA_LIGHT    =1;
    FWEIGHT_EXTRA_LIGHT    =2;
    FWEIGHT_LIGHT          =3;
    FWEIGHT_SEMI_LIGHT     =4;
    FWEIGHT_NORMAL         =5;
    FWEIGHT_SEMI_BOLD      =6;
    FWEIGHT_BOLD           =7;
    FWEIGHT_EXTRA_BOLD     =8;
    FWEIGHT_ULTRA_BOLD     =9;

   { FACENAMEDESC 'WidthClass' options for GpiQueryFaceString }
    FWIDTH_DONT_CARE       =0;
    FWIDTH_ULTRA_CONDENSED =1;
    FWIDTH_EXTRA_CONDENSED =2;
    FWIDTH_CONDENSED       =3;
    FWIDTH_SEMI_CONDENSED  =4;
    FWIDTH_NORMAL          =5;
    FWIDTH_SEMI_EXPANDED   =6;
    FWIDTH_EXPANDED        =7;
    FWIDTH_EXTRA_EXPANDED  =8;
    FWIDTH_ULTRA_EXPANDED  =9;

   { FACENAMEDESC 'options' for GpiQueryFaceString }
    FTYPE_ITALIC            =$0001;
    FTYPE_ITALIC_DONT_CARE  =$0002;
    FTYPE_OBLIQUE           =$0004;
    FTYPE_OBLIQUE_DONT_CARE =$0008;
    FTYPE_ROUNDED           =$0010;
    FTYPE_ROUNDED_DONT_CARE =$0020;

   { actions for GpiQueryFontAction }
    QFA_PUBLIC              =1;
    QFA_PRIVATE             =2;
    QFA_ERROR               =GPI_ALTERROR;

   { options for GpiQueryFonts }
    QF_PUBLIC               =$0001;
    QF_PRIVATE              =$0002;
    QF_NO_GENERIC           =$0004;
    QF_NO_DEVICE            =$0008;

   { font file descriptions for GpiQueryFontFileDescriptions }
TYPE
    FFDESCS=ARRAY[0..1,0..FACESIZE-1] OF BYTE;

    PFFDESCS2=^FFDESCS2;
    FFDESCS2=RECORD
                   cbLength:LONGWORD;
                   cbFacenameOffset:LONGWORD;
                   abFamilyName:BYTE;
             END;



   { raster operations defined for GpiBitBlt }
CONST
    ROP_SRCCOPY                =$00CC;
    ROP_SRCPAINT               =$00EE;
    ROP_SRCAND                 =$0088;
    ROP_SRCINVERT              =$0066;
    ROP_SRCERASE               =$0044;
    ROP_NOTSRCCOPY             =$0033;
    ROP_NOTSRCERASE            =$0011;
    ROP_MERGECOPY              =$00C0;
    ROP_MERGEPAINT             =$00BB;
    ROP_PATCOPY                =$00F0;
    ROP_PATPAINT               =$00FB;
    ROP_PATINVERT              =$005A;
    ROP_DSTINVERT              =$0055;
    ROP_ZERO                   =$0000;
    ROP_ONE                    =$00FF;

   { Blt options for GpiBitBlt }
    BBO_OR                     =0;
    BBO_AND                    =1;
    BBO_IGNORE                 =2;
    BBO_PAL_COLORS             =4;
    BBO_NO_COLOR_INFO          =8;

   { Fill options for GpiFloodFill }
    FF_BOUNDARY                =0;
    FF_SURFACE                 =1;

   { error return for GpiSetBitmap }
    HBM_ERROR                  =-1;



   { usage flags for GpiCreateBitmap }
CONST
    CBM_INIT        =$0004;

   { error return code for GpiSet/QueryBitmapBits }
    BMB_ERROR       =-1;




   { options for GpiCombineRegion }
CONST
    CRGN_OR                         =1;
    CRGN_COPY                       =2;
    CRGN_XOR                        =4;
    CRGN_AND                        =6;
    CRGN_DIFF                       =7;

   { usDirection of returned region data for GpiQueryRegionRects }
    RECTDIR_LFRT_TOPBOT             =1;
    RECTDIR_RTLF_TOPBOT             =2;
    RECTDIR_LFRT_BOTTOP             =3;
    RECTDIR_RTLF_BOTTOP             =4;

   { control data for GpiQueryRegionRects }
TYPE
    PRGNRECT=^RGNRECT;
    RGNRECT=RECORD
                  ircStart:LONGWORD;
                  crc:LONGWORD;
                  crcReturned:LONGWORD;
                  ulDirection:LONGWORD;
            END;

TYPE
    PStr8=POINTER;

   { return code to indicate type of region for GpiCombineRegion and others }
CONST
    RGN_ERROR                       =0;
    RGN_NULL                        =1;
    RGN_RECT                        =2;
    RGN_COMPLEX                     =3;

   { return codes for GpiPtInRegion }
    PRGN_ERROR                      =0;
    PRGN_OUTSIDE                    =1;
    PRGN_INSIDE                     =2;

   { return codes for GpiRectInRegion }
    RRGN_ERROR                      =0;
    RRGN_OUTSIDE                    =1;
    RRGN_PARTIAL                    =2;
    RRGN_INSIDE                     =3;

   { return codes for GpiEqualRegion }
    EQRGN_ERROR                     =0;
    EQRGN_NOTEQUAL                  =1;
    EQRGN_EQUAL                     =2;

   { error return code for GpiSetRegion }
    HRGN_ERROR                      =-1;



{ constants for index values of options array for GpiPlayMetaFile }
CONST
       PMF_SEGBASE                     =0;
       PMF_LOADTYPE                    =1;
       PMF_RESOLVE                     =2;
       PMF_LCIDS                       =3;
       PMF_RESET                       =4;
       PMF_SUPPRESS                    =5;
       PMF_COLORTABLES                 =6;
       PMF_COLORREALIZABLE             =7;
       PMF_DEFAULTS                    =8;
       PMF_DELETEOBJECTS               =9;

      { options for GpiPlayMetaFile }
       RS_DEFAULT                      =0;
       RS_NODISCARD                    =1;
       LC_DEFAULT                      =0;
       LC_NOLOAD                       =1;
       LC_LOADDISC                     =3;
       LT_DEFAULT                      =0;
       LT_NOMODIFY                     =1;
       LT_ORIGINALVIEW                 =4;
       RES_DEFAULT                     =0;
       RES_NORESET                     =1;
       RES_RESET                       =2;
       SUP_DEFAULT                     =0;
       SUP_NOSUPPRESS                  =1;
       SUP_SUPPRESS                    =2;
       CTAB_DEFAULT                    =0;
       CTAB_NOMODIFY                   =1;
       CTAB_REPLACE                    =3;
       CTAB_REPLACEPALETTE             =4;
       CREA_DEFAULT                    =0;
       CREA_REALIZE                    =1;
       CREA_NOREALIZE                  =2;
       CREA_DOREALIZE                  =3;

       DDEF_DEFAULT                    =0;
       DDEF_IGNORE                     =1;
       DDEF_LOADDISC                   =3;
       DOBJ_DEFAULT                    =0;
       DOBJ_NODELETE                   =1;
       DOBJ_DELETE                     =2;
       RSP_DEFAULT                     =0;
       RSP_NODISCARD                   =1;


TYPE
   PPOLYGON=^POLYGON;
   POLYGON=RECORD
                ulPoints:LONGWORD;
                Pointl:^POINTL;
           END;

   PPOLYSET=^POLYSET;
   POLYSET=RECORD
                ulPolys:LONGWORD;
                Polygon:POLYGON;
           END;

{ control flags used by GpiPolygons }
CONST
    POLYGON_NOBOUNDARY              =0;
    POLYGON_BOUNDARY                =$0001;

    POLYGON_ALTERNATE               =0;
    POLYGON_WINDING                 =$0002;

    POLYGON_INCL                    =0;
    POLYGON_EXCL                    =$0008;

IMPORTS

FUNCTION GpiCreatePS(ahab:HAB;ahdc:HDC;VAR psizlSize:SIZEL;
                     flOptions:LONGWORD):HPS;
                    APIENTRY;                'PMGPI' index 369;
FUNCTION GpiDestroyPS(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 379;
FUNCTION GpiAssociate(ahps:HPS;ahdc:HDC):BOOL;
                    APIENTRY;                'PMGPI' index 351;
FUNCTION GpiRestorePS(ahps:HPS;lPSid:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 499;
FUNCTION GpiSavePS(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 501;
FUNCTION GpiErase(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 389;
FUNCTION GpiQueryDevice(ahps:HPS):HDC;
                    APIENTRY;                'PMGPI' index 444;
FUNCTION GpiResetPS(ahps:HPS;flOptions:LONGWORD):BOOL;
                    APIENTRY;                'PMGPI' index 498;
FUNCTION GpiSetPS(ahps:HPS;VAR psizlsize:SIZEL;flOptions:LONGWORD):BOOL;
                    APIENTRY;                'PMGPI' index 539;
FUNCTION GpiQueryPS(ahps:HPS;VAR psizlSize:SIZEL):LONGWORD;
                    APIENTRY;                'PMGPI' index 471;
FUNCTION GpiErrorSegmentData(ahps:HPS;VAR plSegment,plContext:LONG):LONG;
                    APIENTRY;                'PMGPI' index 390;
FUNCTION GpiQueryDrawControl(ahps:HPS;lControl:LONG):LONG;
                    APIENTRY;                'PMGPI' index 446;
FUNCTION GpiSetDrawControl(ahps:HPS;lControl,lValue:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 521;
FUNCTION GpiQueryDrawingMode(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 447;
FUNCTION GpiSetDrawingMode(ahps:HPS;lMode:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 522;
FUNCTION GpiQueryStopDraw(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 487;
FUNCTION GpiSetStopDraw(ahps:HPS;lValue:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 550;
FUNCTION GpiCorrelateChain(ahps:HPS;lType:LONG;VAR pptlPick:POINTL;
                           lMaxHits,lMaxDepth:LONG;VAR pl2:LONG):LONG;
                    APIENTRY;                'PMGPI' index 366;
FUNCTION GpiQueryTag(ahps:HPS;VAR plTag:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 488;
FUNCTION GpiSetTag(ahps:HPS;lTag:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 551;
FUNCTION GpiQueryPickApertureSize(ahps:HPS;VAR psizlSize:SIZEL):BOOL;
                    APIENTRY;                'PMGPI' index 478;
FUNCTION GpiSetPickApertureSize(ahps:HPS;lOptions:LONG;
                                VAR psizlSize:SIZEL):BOOL;
                    APIENTRY;                'PMGPI' index 589;
FUNCTION GpiQueryPickAperturePosition(ahps:HPS;VAR pptlPoint:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 477;
FUNCTION GpiSetPickAperturePosition(ahps:HPS;VAR pptlPick:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 545;
FUNCTION GpiQueryBoundaryData(ahps:HPS;VAR prclBoundary:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 428;
FUNCTION GpiResetBoundaryData(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 497;
FUNCTION GpiCorrelateFrom(ahps:HPS;lFirstSegment,lLastSegment,lType:LONG;
                          VAR pptlPick:POINTL;lMaxHits,lMaxDepth:LONG;
                          VAR plSegTag:LONG):LONG;
                    APIENTRY;                'PMGPI' index 367;
FUNCTION GpiCorrelateSegment(ahps:HPS;lSegment,lType:LONG;
                             VAR pptlPick:POINTL;lMaxHits,lMaxDepth:LONG;
                             VAR alSegTag:LONG):LONG;
                    APIENTRY;                'PMGPI' index 582;
FUNCTION GpiOpenSegment(ahps:HPS;lSegment:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 408;
FUNCTION GpiCloseSegment(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 361;
FUNCTION GpiDeleteSegment(ahps:HPS;lSegid:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 376;
FUNCTION GpiQueryInitialSegmentAttrs(ahps:HPS;lAttribute:LONG):LONG;
                    APIENTRY;                'PMGPI' index 455;
FUNCTION GpiSetInitialSegmentAttrs(ahps:HPS;lAttribute,lValue:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 527;
FUNCTION GpiQuerySegmentAttrs(ahps:HPS;lSegid,lAttribute:LONG):LONG;
                    APIENTRY;                'PMGPI' index 482;
FUNCTION GpiSetSegmentAttrs(ahps:HPS;lSegid,lAttribute,lValue:LONG):LONG;
                    APIENTRY;                'PMGPI' index 547;
FUNCTION GpiQuerySegmentPriority(ahps:HPS;lRefSegid,lOrder:LONG):LONG;
                    APIENTRY;                'PMGPI' index 484;
FUNCTION GpiSetSegmentPriority(ahps:HPS;lSegid,lRefSegid,lOrder:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 548;
FUNCTION GpiDeleteSegments(ahps:HPS;lFirstSegment,lLastSegment:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 377;
FUNCTION GpiQuerySegmentNames(ahps:HPS;lFirstSegid,lLastSegid,lMax:LONG;
                              VAR alSegids:LONG):LONG;
                    APIENTRY;                'PMGPI' index 483;
FUNCTION GpiGetData(ahps:HPS;lSegid:LONG;VAR plOffset:LONG;lFormat,
                    lLength:LONG;VAR pbData):LONG;
                    APIENTRY;                'PMGPI' index 394;
FUNCTION GpiPutData(ahps:HPS;lFormat:LONG;VAR plCount:LONG;
                    VAR pbData):LONG;
                    APIENTRY;                'PMGPI' index 421;
FUNCTION GpiDrawChain(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 380;
FUNCTION GpiDrawFrom(ahps:HPS;lFirstSegment,lLastSegment:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 382;
FUNCTION GpiDrawSegment(ahps:HPS;lSegment:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 383;
FUNCTION GpiDrawDynamics(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 381;
FUNCTION GpiRemoveDynamics(ahps:HPS;lFirstSegid,lLastSegid:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 496;
FUNCTION GpiBeginElement(ahps:HPS;lType:LONG;VAR pszDesc:PSZ):BOOL;
                    APIENTRY;                'PMGPI' index 353;
FUNCTION GpiEndElement(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 386;
FUNCTION GpiLabel(ahps:HPS;lLabel:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 397;
FUNCTION GpiElement(ahps:HPS;lType:LONG;VAR pszDesc:PSZ;lLength:LONG;
                    VAR pbData):LONG;
                    APIENTRY;                'PMGPI' index 384;
FUNCTION GpiQueryElement(ahps:HPS;lOff,lMaxLength:LONG;
                         VAR pbData):LONG;
                    APIENTRY;                'PMGPI' index 449;
FUNCTION GpiDeleteElement(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 372;
FUNCTION GpiDeleteElementRange(ahps:HPS;lFirstElement,
                               lLastElement:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 373;
FUNCTION GpiDeleteElementsBetweenLabels(ahps:HPS;lFirstLabel,
                                        lLastLabel:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 374;
FUNCTION GpiQueryEditMode(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 448;
FUNCTION GpiSetEditMode(ahps:HPS;lMode:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 523;
FUNCTION GpiQueryElementPointer(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 450;
FUNCTION GpiSetElementPointer(ahps:HPS;lElement:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 524;
FUNCTION GpiOffsetElementPointer(ahps:HPS;loffset:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 406;
FUNCTION GpiQueryElementType(ahps:HPS;VAR plType:LONG;lLength:LONG;
                             VAR pszData:PSZ):LONG;
                    APIENTRY;                'PMGPI' index 451;
FUNCTION GpiSetElementPointerAtLabel(ahps:HPS;lLabel:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 525;
FUNCTION GpiQuerySegmentTransformMatrix(ahps:HPS;lSegid,lCount:LONG;
                                        VAR pmatlfArray:MATRIXLF):BOOL;
                    APIENTRY;                'PMGPI' index 485;
FUNCTION GpiSetSegmentTransformMatrix(ahps:HPS;lSegid,lCount:LONG;
                                      VAR pmatlfarray:MATRIXLF;
                                      lOptions:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 549;
FUNCTION GpiConvert(ahps:HPS;lSrc,lTarg,lCount:LONG;VAR aptlPoints:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 364;
FUNCTION GpiConvertWithMatrix(ahps:HPS;lCountp:LONG;VAR aptlPoints:POINTL;
                              lCount:LONG;VAR pmatlfArray:MATRIXLF):BOOL;
                    APIENTRY;                'PMGPI' index 618;
FUNCTION GpiQueryModelTransformMatrix(ahps:HPS;lCount:LONG;
                                      VAR pmatlfArray:MATRIXLF):BOOL;
                    APIENTRY;                'PMGPI' index 468;
FUNCTION GpiSetModelTransformMatrix(ahps:HPS;lCount:LONG;
                                    VAR pmatlfArray:MATRIXLF;
                                    lOptions:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 538;
FUNCTION GpiCallSegmentMatrix(ahps:HPS;lSegment,lCount:LONG;
                              VAR pmatlfArray:MATRIXLF;
                              lOptions:LONG):LONG;
                    APIENTRY;                'PMGPI' index 357;
FUNCTION GpiQueryDefaultViewMatrix(ahps:HPS;lCount:LONG;
                                   VAR pmatlfArray:MATRIXLF):BOOL;
                    APIENTRY;                'PMGPI' index 443;
FUNCTION GpiSetDefaultViewMatrix(ahps:HPS;lCount:LONG;
                                 VAR pmatlfarray:MATRIXLF;
                                 lOptions:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 520;
FUNCTION GpiQueryPageViewport(ahps:HPS;VAR prclViewport:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 472;
FUNCTION GpiSetPageViewport(ahps:HPS;VAR prclViewport:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 540;
FUNCTION GpiQueryViewingTransformMatrix(ahps:HPS;lCount:LONG;
                                        VAR pmatlfArray:MATRIXLF):BOOL;
                    APIENTRY;                'PMGPI' index 491;
FUNCTION GpiSetViewingTransformMatrix(ahps:HPS;lCount:LONG;
                                      VAR pmatlfArray:MATRIXLF;
                                      lOptions:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 553;
FUNCTION GpiTranslate(ahps:HPS;VAR mat:MATRIXLF;cb:LONG;VAR ptl:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 564;
FUNCTION GpiScale(ahps:HPS;VAR mat:MATRIXLF;cb:LONG;VAR f:FIXED;
                  VAR pt:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 565;
FUNCTION GpiRotate(ahps:HPS;VAR mat:MATRIXLF;cb:LONG;f:FIXED;
                   VAR pt:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 566;
FUNCTION GpiSetGraphicsField(ahps:HPS;VAR prclField:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 526;
FUNCTION GpiQueryGraphicsField(ahps:HPS;VAR prclField:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 454;
FUNCTION GpiSetViewingLimits(ahps:HPS;VAR prclLimits:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 552;
FUNCTION GpiQueryViewingLimits(ahps:HPS;VAR prclLimits:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 490;
FUNCTION GpiBeginPath(ahps:HPS;lPath:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 354;
FUNCTION GpiEndPath(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 387;
FUNCTION GpiCloseFigure(ahps:HPS):BOOL;
                    APIENTRY;                'PMGPI' index 360;
FUNCTION GpiModifyPath(ahps:HPS;lPath,lMode:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 403;
FUNCTION GpiFillPath(ahps:HPS;lPath,lOptions:LONG):LONG;
                    APIENTRY;                'PMGPI' index 392;
FUNCTION GpiSetClipPath(ahps:HPS;lPath,lOptions:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 515;
FUNCTION GpiOutlinePath(ahps:HPS;lPath,lOptions:LONG):LONG;
                    APIENTRY;                'PMGPI' index 563;
FUNCTION GpiPathToRegion(GpiH:HPS;lPath,lOptions:LONG):HRGN;
                    APIENTRY;                'PMGPI' index 559;
FUNCTION GpiStrokePath(ahps:HPS;lPath:LONG;flOptions:LONGWORD):LONG;
                    APIENTRY;                'PMGPI' index 554;
FUNCTION GpiCreateLogColorTable(ahps:HPS;flOptions:LONGWORD;
                                lFormat,lStart,lCount:LONG;
                                VAR alTable):BOOL;
                    APIENTRY;                'PMGPI' index 592;
FUNCTION GpiQueryColorData(ahps:HPS;lCount:LONG;VAR alArray:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 438;
FUNCTION GpiQueryLogColorTable(ahps:HPS;flOptions:LONGWORD;lStart,lCount:LONG;
                               VAR alArray:LONG):LONG;
                    APIENTRY;                'PMGPI' index 593;
FUNCTION GpiQueryRealColors(ahps:HPS;flOptions:LONGWORD;lStart,lCount:LONG;
                            VAR alColors:LONG):LONG;
                    APIENTRY;                'PMGPI' index 480;
FUNCTION GpiQueryNearestColor(ahps:HPS;flOptions:LONGWORD;lRgbIn:LONG):LONG;
                    APIENTRY;                'PMGPI' index 469;
FUNCTION GpiQueryColorIndex(ahps:HPS;flOptions:LONGWORD;lRgbColor:LONG):LONG;
                    APIENTRY;                'PMGPI' index 439;
FUNCTION GpiQueryRGBColor(ahps:HPS;flOptions:LONGWORD;lColorIndex:LONG):LONG;
                    APIENTRY;                'PMGPI' index 479;
FUNCTION GpiCreatePalette(ahab:HAB;flOptions,ulFormat,ulCount:LONGWORD;
                          VAR aulTable):HPAL;
                    APIENTRY;                'PMGPI' index 594;
FUNCTION GpiDeletePalette(ahpal:HPAL):BOOL;
                    APIENTRY;                'PMGPI' index 577;
FUNCTION GpiSelectPalette(ahps:HPS;ahpal:HPAL):HPAL;
                    APIENTRY;                'PMGPI' index 578;
FUNCTION GpiAnimatePalette(ahpal:HPAL;ulFormat,ulStart,ulCount:LONGWORD;
                           VAR aulTable:LONGWORD):LONG;
                    APIENTRY;                'PMGPI' index 595;
FUNCTION GpiSetPaletteEntries(ahpal:HPAL;ulFormat,ulStart,ulCount:LONGWORD;
                              VAR aulTable):BOOL;
                    APIENTRY;                'PMGPI' index 596;
FUNCTION GpiQueryPalette(ahps:HPS):HPAL;
                    APIENTRY;                'PMGPI' index 579;
FUNCTION GpiQueryPaletteInfo(ahpal:HPAL;ahps:HPS;flOptions,ulStart,
                             ulCount:LONGWORD;VAR aulArray):LONG;
                    APIENTRY;                'PMGPI' index 597;
FUNCTION GpiSetColor(ahps:HPS;lColor:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 517;
FUNCTION GpiQueryColor(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 437;
FUNCTION GpiBox(ahps:HPS;lControl:LONG;VAR pptlPoint:POINTL;
                lHRound,lVRound:LONG):LONG;
                    APIENTRY;                'PMGPI' index 356;
FUNCTION GpiMove(ahps:HPS;VAR pptlPoint:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 404;
FUNCTION GpiLine(ahps:HPS;VAR pptlEndPoint:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 398;
FUNCTION GpiPolyLine(ahps:HPS;lCount:LONG;VAR aptlPoints:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 415;
FUNCTION GpiPolyLineDisjoint(ahps:HPS;lCount:LONG;VAR aptlPoints:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 558;
FUNCTION GpiSetPattern(ahps:HPS;lPatternSymbol:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 541;
FUNCTION GpiQueryPattern(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 473;
FUNCTION GpiBeginArea(ahps:HPS;flOptions:LONGWORD):BOOL;
                    APIENTRY;                'PMGPI' index 352;
FUNCTION GpiEndArea(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 385;
FUNCTION GpiCharString(ahps:HPS;lCount:LONG;CONST pchString):LONG;
                    APIENTRY;                'PMGPI' index 358;
FUNCTION GpiCharStringAt(ahps:HPS;VAR pptlPoint:POINTL;lCount:LONG;
                         CONST pchString):LONG;
                    APIENTRY;                'PMGPI' index 359;
FUNCTION GpiSetAttrMode(ahps:HPS;lMode:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 503;
FUNCTION GpiQueryAttrMode(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 423;
FUNCTION GpiSetAttrs(ahps:HPS;lPrimType:LONG;flAttrMask,flDefMask:LONGWORD;
                     VAR ppbunAttrs):BOOL;
                    APIENTRY;                'PMGPI' index 588;
FUNCTION GpiQueryAttrs(ahps:HPS;lPrimType:LONG;flAttrMask:LONGWORD;
                       VAR ppbunAttrs):LONG;
                    APIENTRY;                'PMGPI' index 583;
FUNCTION GpiSetBackColor(ahps:HPS;lColor:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 504;
FUNCTION GpiQueryBackColor(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 424;
FUNCTION GpiSetMix(ahps:HPS;lMixMode:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 537;
FUNCTION GpiQueryMix(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 467;
FUNCTION GpiSetBackMix(ahps:HPS;lMixMode:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 505;
FUNCTION GpiQueryBackMix(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 425;
FUNCTION GpiSetLineType(ahps:HPS;lLineType:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 530;
FUNCTION GpiQueryLineType(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 459;
FUNCTION GpiSetLineWidth(ahps:HPS;fxLineWidth:FIXED):BOOL;
                    APIENTRY;                'PMGPI' index 531;
FUNCTION GpiQueryLineWidth(ahps:HPS):FIXED;
                    APIENTRY;                'PMGPI' index 460;
FUNCTION GpiSetLineWidthGeom(ahps:HPS;lLineWidth:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 532;
FUNCTION GpiQueryLineWidthGeom(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 461;
FUNCTION GpiSetLineEnd(ahps:HPS;lLineEnd:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 528;
FUNCTION GpiQueryLineEnd(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 457;
FUNCTION GpiSetLineJoin(ahps:HPS;lLineJoin:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 529;
FUNCTION GpiQueryLineJoin(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 458;
FUNCTION GpiSetCurrentPosition(ahps:HPS;VAR pptlPoint:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 519;
FUNCTION GpiQueryCurrentPosition(ahps:HPS;VAR pptlPoint:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 441;
FUNCTION GpiSetArcParams(ahps:HPS;VAR parcpArcParams:ARCPARAMS):BOOL;
                    APIENTRY;                'PMGPI' index 502;
FUNCTION GpiQueryArcParams(ahps:HPS;VAR parcpArcParams:ARCPARAMS):BOOL;
                    APIENTRY;                'PMGPI' index 422;
FUNCTION GpiPointArc(ahps:HPS;VAR pptl2:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 412;
FUNCTION GpiFullArc(ahps:HPS;lControl:LONG;fxMultiplier:FIXED):LONG;
                    APIENTRY;                'PMGPI' index 393;
FUNCTION GpiPartialArc(ahps:HPS;VAR pptlCenter:POINTL;fxMultiplier,
                       fxStartAngle,fxSweepAngle:FIXED):LONG;
                    APIENTRY;                'PMGPI' index 612;
FUNCTION GpiPolyFillet(ahps:HPS;lCount:LONG;VAR aptlPoints:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 413;
FUNCTION GpiPolySpline(ahps:HPS;lCount:LONG;VAR aptlPoints:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 417;
FUNCTION GpiPolyFilletSharp(ahps:HPS;lCount:LONG;VAR aptlPoints:POINTL;
                            VAR afxPoints:FIXED):LONG;
                    APIENTRY;                'PMGPI' index 414;
FUNCTION GpiSetPatternSet(ahps:HPS;lSet:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 543;
FUNCTION GpiQueryPatternSet(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 475;
FUNCTION GpiSetPatternRefPoint(ahps:HPS;VAR pptlRefPoint:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 542;
FUNCTION GpiQueryPatternRefPoint(ahps:HPS;VAR pptlRefPoint:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 474;
FUNCTION GpiQueryCharStringPos(ahps:HPS;flOptions:LONGWORD;lCount:LONG;
                               VAR pchString;VAR alXincrements:LONG;
                               VAR aptlPositions:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 584;
FUNCTION GpiQueryCharStringPosAt(ahps:HPS;VAR pptlStart:POINTL;
                                 flOptions:LONGWORD;lCount:LONG;
                                 VAR pchString;VAR alXincrements:LONG;
                                 VAR aptlPositions:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 585;
FUNCTION GpiQueryTextBox(ahps:HPS;lCount1:LONG;VAR pchString;lCount2:LONG;
                         VAR aptlPoints:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 489;
FUNCTION GpiQueryDefCharBox(ahps:HPS;VAR psizlSize:SIZEL):BOOL;
                    APIENTRY;                'PMGPI' index 442;
FUNCTION GpiSetCharSet(ahps:HPS;llcid:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 513;
FUNCTION GpiQueryCharSet(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 433;
FUNCTION GpiSetCharBox(ahps:HPS;VAR psizfxBox:SIZEF):BOOL;
                    APIENTRY;                'PMGPI' index 510;
FUNCTION GpiQueryCharBox(ahps:HPS;VAR psizfxSize:SIZEF):BOOL;
                    APIENTRY;                'PMGPI' index 430;
FUNCTION GpiSetCharAngle(ahps:HPS;VAR pgradlAngle:GRADIENTL):BOOL;
                    APIENTRY;                'PMGPI' index 509;
FUNCTION GpiQueryCharAngle(ahps:HPS;VAR pgradlAngle:GRADIENTL):BOOL;
                    APIENTRY;                'PMGPI' index 429;
FUNCTION GpiSetCharShear(ahps:HPS;VAR pptlAngle:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 514;
FUNCTION GpiQueryCharShear(ahps:HPS;VAR pptlShear:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 434;
FUNCTION GpiSetCharDirection(ahps:HPS;lDirection:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 511;
FUNCTION GpiQueryCharDirection(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 431;
FUNCTION GpiSetCharMode(ahps:HPS;lMode:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 512;
FUNCTION GpiQueryCharMode(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 432;
FUNCTION GpiSetTextAlignment(ahps:HPS;lHoriz,lVert:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 649;
FUNCTION GpiQueryTextAlignment(ahps:HPS;VAR plHoriz,plVert:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 648;
FUNCTION GpiCharStringPos(ahps:HPS;VAR prclRect:RECTL;flOptions:LONGWORD;
                          lCount:LONG;VAR pchString;VAR alAdx:LONG):LONG;
                    APIENTRY;                'PMGPI' index 580;
FUNCTION GpiCharStringPosAt(ahps:HPS;VAR pptlStart:POINTL;VAR prclRect:RECTL;
                            flOptions:LONGWORD;lCount:LONG;VAR pchString;
                            VAR alAdx:LONG):LONG;
                    APIENTRY;                'PMGPI' index 581;
FUNCTION GpiSetCharExtra(ahps:HPS;Extra:FIXED):BOOL;
                    APIENTRY;                'PMGPI' index 614;
FUNCTION GpiSetCharBreakExtra(ahps:HPS;BreakExtra:FIXED):BOOL;
                    APIENTRY;                'PMGPI' index 616;
FUNCTION GpiQueryCharExtra(ahps:HPS;VAR Extra:FIXED):BOOL;
                    APIENTRY;                'PMGPI' index 613;
FUNCTION GpiQueryCharBreakExtra(ahps:HPS;VAR BreakExtra:FIXED):BOOL;
                    APIENTRY;                'PMGPI' index 615;
FUNCTION GpiMarker(ahps:HPS;VAR pptlPoint:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 402;
FUNCTION GpiPolyMarker(ahps:HPS;lCount:LONG;VAR aptlPoints:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 416;
FUNCTION GpiSetMarker(ahps:HPS;lSymbol:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 533;
FUNCTION GpiSetMarkerBox(ahps:HPS;VAR psizfxSize:SIZEF):BOOL;
                    APIENTRY;                'PMGPI' index 534;
FUNCTION GpiSetMarkerSet(ahps:HPS;lSet:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 535;
FUNCTION GpiQueryMarker(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 462;
FUNCTION GpiQueryMarkerBox(ahps:HPS;VAR psizfxSize:SIZEF):BOOL;
                    APIENTRY;                'PMGPI' index 463;
FUNCTION GpiQueryMarkerSet(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 464;
FUNCTION GpiImage(ahps:HPS;lFormat:LONG;VAR psizlImageSize:SIZEL;
                  lLength:LONG;VAR pbData):LONG;
                    APIENTRY;                'PMGPI' index 395;
FUNCTION GpiPop(ahps:HPS;lCount:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 418;
FUNCTION GpiPtVisible(ahps:HPS;VAR pptlPoint:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 420;
FUNCTION GpiRectVisible(ahps:HPS;VAR prclRectangle:RECTL):LONG;
                    APIENTRY;                'PMGPI' index 495;
FUNCTION GpiComment(ahps:HPS;lLength:LONG;VAR pbData):BOOL;
                    APIENTRY;                'PMGPI' index 363;
FUNCTION GpiCreateLogFont(ahps:HPS;pName:PStr8;lLcid:LONG;
                          VAR pfatAttrs:FATTRS):LONG;
                    APIENTRY;                'PMGPI' index 368;
FUNCTION GpiDeleteSetId(ahps:HPS;lLcid:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 378;
FUNCTION GpiLoadFonts(ahab:HAB;VAR pszFilename:PSZ):BOOL;
                    APIENTRY;                'PMGPI' index 400;
FUNCTION GpiUnloadFonts(ahab:HAB;VAR pszFilename:PSZ):BOOL;
                    APIENTRY;                'PMGPI' index 555;
FUNCTION GpiQueryFonts(ahps:HPS;flOptions:LONGWORD;VAR pszFacename:PSZ;
                       VAR plReqFonts:LONG;lMetricsLength:LONG;
                       VAR afmMetrics:FONTMETRICS):LONG;
                    APIENTRY;                'PMGPI' index 586;
FUNCTION GpiQueryFontMetrics(ahps:HPS;lMetricsLength:LONG;
                             VAR pfmMetrics:FONTMETRICS):BOOL;
                    APIENTRY;                'PMGPI' index 453;
FUNCTION GpiQueryKerningPairs(ahps:HPS;lCount:LONG;
                              VAR akrnprData:KERNINGPAIRS):LONG;
                    APIENTRY;                'PMGPI' index 456;
FUNCTION GpiQueryWidthTable(ahps:HPS;lFirstChar,lCount:LONG;
                            VAR alData:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 492;
FUNCTION GpiQueryNumberSetIds(ahps:HPS):LONG;
                    APIENTRY;                'PMGPI' index 470;
FUNCTION GpiQuerySetIds(ahps:HPS;lCount:LONG;VAR alTypes:LONG;
                        aNames:PStr8;VAR allcids:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 486;
FUNCTION GpiQueryFaceString(PS:HPS;VAR FamilyName:PSZ;VAR attrs:FACENAMEDESC;
                            alength:LONG;VAR CompoundFaceName:PSZ):LONGWORD;
                    APIENTRY;                'PMGPI' index 575;
FUNCTION GpiQueryLogicalFont(PS:HPS;lcid:LONG;name:PStr8;VAR attrs:FATTRS;
                             alength:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 574;
FUNCTION GpiQueryFontAction(anchor:HAB;options:LONGWORD):LONGWORD;
                    APIENTRY;                'PMGPI' index 576;
FUNCTION GpiLoadPublicFonts(ahab:HAB;VAR name:PSZ):BOOL;
                    APIENTRY;                'PMGPI' index 622;
FUNCTION GpiUnloadPublicFonts(ahab:HAB;VAR name:PSZ):BOOL;
                    APIENTRY;                'PMGPI' index 623;
FUNCTION GpiSetCp(ahps:HPS;ulCodePage:LONGWORD):BOOL;
                    APIENTRY;                'PMGPI' index 518;
FUNCTION GpiQueryCp(ahps:HPS):LONGWORD;
                    APIENTRY;                'PMGPI' index 440;
{FUNCTION GpiQueryFullFontFileDescs(ahab:HAB;VAR pszFilename:PSZ;
                                   VAR plCount:LONG;pNames:POINTER;
                                   VAR plNamesBuffLength:LONG):LONG;
                    APIENTRY;                'PMGPI' index}
FUNCTION GpiQueryFontFileDescriptions(ahab:HAB;VAR pszFilename:PSZ;
                                      VAR plCount:LONG;
                                      VAR affdescsNames:FFDESCS):LONG;
                    APIENTRY;                'PMGPI' index 452;
FUNCTION GpiBitBlt(hpsTarget,hpsSource:HPS;lCount:LONG;VAR aptlPoints:POINTL;
                   lRop:LONG;flOptions:LONGWORD):LONG;
                    APIENTRY;                'PMGPI' index 355;
FUNCTION GpiDeleteBitmap(hbm:HBITMAP):BOOL;
                    APIENTRY;                'PMGPI' index 371;
FUNCTION GpiLoadBitmap(ahps:HPS;aResource:HMODULE;idBitmap:LONGWORD;
                       lWidth,lHeight:LONG):HBITMAP;
                    APIENTRY;                'PMGPI' index 399;
FUNCTION GpiSetBitmap(ahps:HPS;hbm:HBITMAP):HBITMAP;
                    APIENTRY;                'PMGPI' index 506;
FUNCTION GpiWCBitBlt(hpsTarget:HPS;hbmSource:HBITMAP;lCount:LONG;
                     VAR aptlPoints:POINTL;lRop:LONG;flOptions:LONGWORD):LONG;
                    APIENTRY;                'PMGPI' index 557;
FUNCTION GpiCreateBitmap(ahps:HPS;VAR pbmpNew;
                         flOptions:LONGWORD;VAR pbInitData;
                         VAR pbmiInfoTable):HBITMAP;
                    APIENTRY;                'PMGPI' index 598;
FUNCTION GpiSetBitmapBits(ahps:HPS;lScanStart,lScans:LONG;
                          VAR pbBuffer;
                          VAR pbmiInfoTable):LONG;
                    APIENTRY;                'PMGPI' index 602;
FUNCTION GpiSetBitmapDimension(hbm:HBITMAP;
                               VAR psizlBitmapDimension:SIZEL):BOOL;
                    APIENTRY;                'PMGPI' index 507;
FUNCTION GpiSetBitmapId(ahps:HPS;hbm:HBITMAP;lLcid:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 508;
FUNCTION GpiQueryBitmapBits(ahps:HPS;lScanStart,lScans:LONG;
                            VAR pbBuffer;
                            VAR pbmiInfoTable):LONG;
                    APIENTRY;                'PMGPI' index 599;
FUNCTION GpiQueryBitmapDimension(hbm:HBITMAP;
                                 VAR psizlBitmapDimension:SIZEL):BOOL;
                    APIENTRY;                'PMGPI' index 426;

FUNCTION GpiQueryBitmapHandle(ahps:HPS;lLcid:LONG):HBITMAP;
                    APIENTRY;                'PMGPI' index 427;
FUNCTION GpiQueryBitmapParameters(hbm:HBITMAP;
                                  VAR pbmpData:BITMAPINFOHEADER):BOOL;
                    APIENTRY;                'PMGPI' index 573;
FUNCTION GpiQueryBitmapInfoHeader(hbm:HBITMAP;
                                  VAR pbmpData):BOOL;
                    APIENTRY;                'PMGPI' index 601;
FUNCTION GpiQueryDeviceBitmapFormats(ahps:HPS;lCount:LONG;
                                     VAR alArray:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 445;
FUNCTION GpiSetPel(ahps:HPS;VAR pptlPoint:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 544;
FUNCTION GpiQueryPel(ahps:HPS;VAR pptlPoint:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 476;
FUNCTION GpiFloodFill(ahps:HPS;lOptions,lColor:LONG):LONG;
                    APIENTRY;                'PMGPI' index 560;
FUNCTION GpiDrawBits(ahps:HPS;pBits:POINTER;
                     VAR pbmiInfoTable:BITMAPINFO2;lCount:LONG;
                     VAR aptlPoints:POINTL;lRop:LONG;
                     flOptions:LONGWORD):LONG;
                    APIENTRY;                'PMGPI' index 603;
FUNCTION GpiCombineRegion(ahps:HPS;hrgnDest,hrgnSrc1,hrgnSrc2:HRGN;
                          lMode:LONG):LONG;
                    APIENTRY;                'PMGPI' index 362;
FUNCTION GpiCreateRegion(ahps:HPS;lCount:LONG;
                         CONST arclRectangles:RECTL):HRGN;
                    APIENTRY;                'PMGPI' index 370;
FUNCTION GpiDestroyRegion(ahps:HPS;ahrgn:HRGN):BOOL;
                    APIENTRY;                'PMGPI' index 611;
FUNCTION GpiEqualRegion(ahps:HPS;hrgnSrc1,hrgnSrc2:HRGN):LONG;
                    APIENTRY;                'PMGPI' index 388;
FUNCTION GpiOffsetRegion(ahps:HPS;aHrgn:HRGN;VAR pptlOffset:POINTL):BOOL;
                    APIENTRY;                'PMGPI' index 407;
FUNCTION GpiPaintRegion(ahps:HPS;ahrgn:HRGN):LONG;
                    APIENTRY;                'PMGPI' index 409;
FUNCTION GpiFrameRegion(ahps:HPS;ahrgn:HRGN;VAR thickness:SIZEL):LONG;
                    APIENTRY;                'PMGPI' index 617;
FUNCTION GpiPtInRegion(ahps:HPS;ahrgn:HRGN;VAR pptlPoint:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 419;
FUNCTION GpiQueryRegionBox(ahps:HPS;ahrgn:HRGN;VAR prclBound:RECTL):LONG;
                    APIENTRY;                'PMGPI' index 481;
FUNCTION GpiQueryRegionRects(ahps:HPS;ahrgn:HRGN;VAR prclBound:RECTL;
                             VAR prgnrcControl:RGNRECT;
                             VAR prclRect:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 587;
FUNCTION GpiRectInRegion(ahps:HPS;ahrgn:HRGN;VAR prclRect:RECTL):LONG;
                    APIENTRY;                'PMGPI' index 494;
FUNCTION GpiSetRegion(ahps:HPS;ahrgn:HRGN;lcount:LONG;
                      VAR arclRectangles:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 546;
FUNCTION GpiSetClipRegion(ahps:HPS;ahrgn:HRGN;VAR phrgnOld:HRGN):LONG;
                    APIENTRY;                'PMGPI' index 516;
FUNCTION GpiQueryClipRegion(ahps:HPS):HRGN;
                    APIENTRY;                'PMGPI' index 436;
FUNCTION GpiQueryClipBox(ahps:HPS;VAR prclBound:RECTL):LONG;
                    APIENTRY;                'PMGPI' index 435;
FUNCTION  GpiExcludeClipRectangle(ahps:HPS;CONST prclRectangle:RECTL):LONG;
                    APIENTRY;                'PMGPI' index 391;
FUNCTION GpiIntersectClipRectangle(ahps:HPS;VAR prclRectangle:RECTL):LONG;
                    APIENTRY;                'PMGPI' index 396;
FUNCTION GpiOffsetClipRegion(ahps:HPS;VAR pptlPoint:POINTL):LONG;
                    APIENTRY;                'PMGPI' index 405;
FUNCTION GpiCopyMetaFile(ahmf:HMF):HMF;
                    APIENTRY;                'PMGPI' index 365;
FUNCTION GpiDeleteMetaFile(ahmf:HMF):BOOL;
                    APIENTRY;                'PMGPI' index 375;
FUNCTION GpiLoadMetaFile(ahab:HAB;Const pszFilename:CString):HMF;
                    APIENTRY;                'PMGPI' index 401;
FUNCTION GpiPlayMetaFile(ahps:HPS;ahmf:HMF;lCount1:LONG;
                         VAR alOptarray,plSegCount:LONG;
                         lCount2:LONG;VAR pszDesc:PSZ):LONG;
                    APIENTRY;                'PMGPI' index 411;
FUNCTION GpiQueryMetaFileBits(ahmf:HMF;lOffset,lLength:LONG;
                              VAR pbData):LONG;
                    APIENTRY;                'PMGPI' index 465;
FUNCTION GpiQueryMetaFileLength(ahmf:HMF):LONG;
                    APIENTRY;                'PMGPI' index 466;
FUNCTION GpiSaveMetaFile(ahmf:HMF;Const pszFilename:CString):BOOL;
                    APIENTRY;                'PMGPI' index 500;
FUNCTION GpiSetMetaFileBits(ahmf:HMF;lOffset,lLength:LONG;
                            VAR pbBuffer):BOOL;
                    APIENTRY;                'PMGPI' index 536;
FUNCTION GpiQueryDefArcParams(ahps:HPS;
                              VAR parcpArcParams:ARCPARAMS):BOOL;
                    APIENTRY;                'PMGPI' index 567;
FUNCTION GpiQueryDefAttrs(ahps:HPS;lPrimType:LONG;flAttrMask:LONGWORD;
                          VAR ppbunAttrs):BOOL;
                    APIENTRY;                'PMGPI' index 590;
FUNCTION GpiQueryDefTag(ahps:HPS;VAR plTag:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 568;
FUNCTION GpiQueryDefViewingLimits(ahps:HPS;VAR prclLimits:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 569;
FUNCTION GpiSetDefArcParams(ahps:HPS;VAR parcpArcParams:ARCPARAMS):BOOL;
                    APIENTRY;                'PMGPI' index 570;
FUNCTION GpiSetDefAttrs(ahps:HPS;lPrimType:LONG;flAttrMask:LONGWORD;
                        VAR ppbunAttrs):BOOL;
                    APIENTRY;                'PMGPI' index 591;
FUNCTION GpiSetDefTag(ahps:HPS;lTag:LONG):BOOL;
                    APIENTRY;                'PMGPI' index 571;
FUNCTION GpiSetDefViewingLimits(ahps:HPS;VAR prclLimits:RECTL):BOOL;
                    APIENTRY;                'PMGPI' index 572;
FUNCTION GpiPolygons(ahps:HPS;ulCount:LONGWORD;VAR paplgn:POLYGON;
                     flOptions,flModel:LONGWORD):LONG;
                    APIENTRY;                'PMGPI' index 650;
END; {IMPORTS}



FUNCTION MAKEFIXED(intpart,fractpart:WORD):FIXED;
FUNCTION FIXEDFRAC(fx:FIXED):WORD;
FUNCTION FIXEDINT(fx:FIXED):WORD;

IMPLEMENTATION


{ make FIXED number from SHORT integer part and WORD fractional part }
FUNCTION MAKEFIXED(intpart,fractpart:WORD):FIXED;
BEGIN
     MAKEFIXED:=MAKELONG(fractpart,intpart);
END;


{ extract fractional part from a fixed quantity }
FUNCTION FIXEDFRAC(fx:FIXED):WORD;
BEGIN
     FIXEDFRAC:=LOUSHORT(fx);
END;

{ extract integer part from a fixed quantity }
FUNCTION FIXEDINT(fx:FIXED):WORD;
BEGIN
     FIXEDINT:=HIUSHORT(fx);
END;

BEGIN
END.

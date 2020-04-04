
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PMBitMap;

INTERFACE

USES Os2Def;

{ bitmap parameterization used by GpiCreateBitmap and others }

TYPE
    PBITMAPINFOHEADER=^BITMAPINFOHEADER;
    BITMAPINFOHEADER=RECORD
                         cbFix:ULONG;
                         cx:USHORT;
                         cy:USHORT;
                         cPlanes:USHORT;
                         cBitCount:USHORT;
                     END;

   { RGB data for _BITMAPINFO struct }

TYPE
    PRGB=^RGB;
    RGB=RECORD  {pack 1}
              bBlue:BYTE;
              bGreen:BYTE;
              bRed:BYTE;
        END;

    TRGBArray=ARRAY[0..0] OF RGB;

   { bitmap data used by GpiSetBitmapBits and others }
TYPE
    PBITMAPINFO=^BITMAPINFO;
    BITMAPINFO=RECORD
                    cbFix:ULONG;
                    cx:USHORT;
                    cy:USHORT;
                    cPlanes:USHORT;
                    cBitCount:USHORT;
                    argbColor:ARRAY[0..0] OF RGB;
               END;

   { Constants for compression/decompression command }
CONST
    CBD_COMPRESSION     =1;
    CBD_DECOMPRESSION   =2;
    CBD_BITS            =0;

   { Flags for compression/decompression option }

    CBD_COLOR_CONVERSION=$00000001;

   { Compression scheme in the ulCompression field of the bitmapinfo structure }
CONST
    BCA_UNCOMP          =0;
    BCA_HUFFMAN1D       =3;
    BCA_RLE4            =2;
    BCA_RLE8            =1;
    BCA_RLE24           =4;

    BRU_METRIC          =0;

    BRA_BOTTOMUP        =0;
    BRH_NOTHALFTONED    =0;
    BRH_ERRORDIFFUSION  =1;
    BRH_PANDA           =2;
    BRH_SUPERCIRCLE     =3;

    BCE_PALETTE         =-1;
    BCE_RGB             =0;

TYPE
    PBITMAPINFOHEADER2=^BITMAPINFOHEADER2;
    BITMAPINFOHEADER2=RECORD
                            cbFix:ULONG;  { Length of structure }
                            cx:ULONG;     { Bit-map width in pels }
                            cy:ULONG;     { Bit-map height in pels }
                            cPlanes:USHORT; { Number of bit planes }
                            cBitCount:USHORT;{ Number of bits per pel within
                                               a plane }
                            ulCompression:ULONG;{ Compression scheme used to
                                                  store the bitmap }
                            cbImage:ULONG;  { Length of bit-map storage data
                                              in bytes}
                            cxResolution:ULONG;{x resolution of target device}
                            cyResolution:ULONG;{resolution of target device}
                            cclrUsed:ULONG;     {Number of color indices used}
                            cclrImportant:ULONG;{ Number of important color indices }
                            usUnits:USHORT;     { Units of measure }
                            usReserved:USHORT;
                            usRecording:USHORT; { Recording algorithm}
                            usRendering:USHORT; { Halftoning algorithm}
                            cSize1:ULONG;       { Size value 1}
                            cSize2:ULONG;       { Size value 2}
                            ulColorEncoding:ULONG;  {Color encoding}
                            ulIdentifier:ULONG;  {Reserved for application use}
                    END;

TYPE
    PRGB2=^RGB2;
    RGB2=RECORD
               bBlue:BYTE;
               bGreen:BYTE;
               bRed:BYTE;
               fcOptions:BYTE;  { Reserved, must be zero }
         END;

    TRGB2Array=ARRAY[0..0] OF RGB2;

TYPE
    PBITMAPINFO2=^BITMAPINFO2;
    BITMAPINFO2=RECORD
                      cbFix:ULONG;
                      cx:ULONG;
                      cy:ULONG;
                      cPlanes:USHORT;
                      cBitCount:USHORT;
                      ulCompression:ULONG;
                      cbImage:ULONG;
                      cxResolution:ULONG;
                      cyResolution:ULONG;
                      cclrUsed:ULONG;
                      cclrImportant:ULONG;
                      usUnits:USHORT;
                      usReserved:USHORT;
                      usRecording:USHORT;
                      usRendering:USHORT;
                      cSize1:ULONG;
                      cSize2:ULONG;
                      ulColorEncoding:ULONG;
                      ulIdentifier:ULONG;
                      argbColor:ARRAY[0..0] OF RGB2;
              END;

TYPE
   PBITMAPFILEHEADER=^BITMAPFILEHEADER;
   BITMAPFILEHEADER=RECORD
                         usType:USHORT;
                         cbSize:ULONG;
                         xHotspot:SHORT;
                         yHotspot:SHORT;
                         offBits:ULONG;
                         bmp:BITMAPINFOHEADER;
                    END;

TYPE
    PBITMAPARRAYFILEHEADER=^BITMAPARRAYFILEHEADER;
    BITMAPARRAYFILEHEADER=RECORD
                               usType:USHORT;
                               cbSize:ULONG;
                               offNext:ULONG;
                               cxDisplay:USHORT;
                               cyDisplay:USHORT;
                               bfh:BITMAPFILEHEADER;
                          END;

TYPE
    PBITMAPFILEHEADER2=^BITMAPFILEHEADER2;
    BITMAPFILEHEADER2=RECORD
                            usType:USHORT;
                            cbSize:ULONG;
                            xHotspot:SHORT;
                            yHotspot:SHORT;
                            offBits:ULONG;
                            bmp2:BITMAPINFOHEADER2;
                      END;

TYPE
   PBITMAPARRAYFILEHEADER2=^BITMAPARRAYFILEHEADER2;
   BITMAPARRAYFILEHEADER2=RECORD
                               usType:USHORT;
                               cbSize:ULONG;
                               offNext:ULONG;
                               cxDisplay:USHORT;
                               cyDisplay:USHORT;
                               bfh2:BITMAPFILEHEADER2;
                          END;

{*************************************************************************
 * These are the identifying values that go in the usType field of the   *
 * BITMAPFILEHEADER(2) and BITMAPARRAYFILEHEADER(2).                     *
 * (BFT_ => Bit map File Type)                                           *
 *************************************************************************}
CONST
    BFT_ICON           =$4349;   { 'IC' }
    BFT_BMAP           =$4d42;   { 'BM' }
    BFT_POINTER        =$5450;   { 'PT' }
    BFT_COLORICON      =$4943;   { 'CI' }
    BFT_COLORPOINTER   =$5043;   { 'CP' }

    BFT_BITMAPARRAY    =$4142;   { 'BA' }

{ type of picture to print }
CONST
     PIP_MF       =1;
     PIP_PIF      =2;

{ type of conversion required }
     PIC_PIFTOMET =0;
     PIC_SSTOFONT =2;

IMPORTS

FUNCTION PicPrint(ahab:HAB;VAR pszFilename:PSZ;lType:LONG;VAR pszParams:PSZ):BOOL;
                  APIENTRY;                   'PMPIC' index 11;
FUNCTION PicIchg(ahab:HAB;VAR pszFilename1,pszFilename2:PSZ;lType:LONG):BOOL;
                  APIENTRY;                   'PMPIC' index 12;

END; {IMPORTS}

IMPLEMENTATION


BEGIN
END.

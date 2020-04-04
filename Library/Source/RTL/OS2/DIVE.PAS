
{…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
 ∫                                                                          ∫
 ∫    Sibyl Runtime Library for OS/2                                        ∫
 ∫                                                                          ∫
 ∫    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    ∫
 ∫                                                                          ∫
 »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº}


Unit Dive;

{****************************************************************************
 *                                                                          *
 * OS/2 2.1 Multimedia Extensions Display Engine API data structures        *
 *                                                                          *
 * Copyright (c) International Business Machines Corporation 1993, 1994     *
 *                         All Rights Reserved                              *
 *                                                                          *
 * OS/2 Warp Multimedia Extensions Color space definitions                  *
 *                                                                          *
 * Copyright (c) International Business Machines Corporation 1993, 1995     *
 *                         All Rights Reserved                              *
 *                                                                          *
 ****************************************************************************}


/****************************************************************************\
* 11-Nov-96: (Jîrg) Translation of original C header files from Warp 4.0 
*            Toolkit to Speed-Pascal.
* 19-Aug-97  (Jîrg) Included definitions from FOURCC.H header file to avoid
*            problem with FOURCC being a type and unit identifier at the
*            same time.
\****************************************************************************/

interface

uses OS2Def;

const
  MAX_DIVE_INSTANCES = 64;

type
  FOURCC = ULONG;
  HDIVE  = ULONG;

const
  DIVE_SUCCESS                                   = $00000000;
  DIVE_ERR_INVALID_INSTANCE                      = $00001000;
  DIVE_ERR_SOURCE_FORMAT                         = $00001001;
  DIVE_ERR_DESTINATION_FORMAT                    = $00001002;
  DIVE_ERR_BLITTER_NOT_SETUP                     = $00001003;
  DIVE_ERR_INSUFFICIENT_LENGTH                   = $00001004;
  DIVE_ERR_TOO_MANY_INSTANCES                    = $00001005;
  DIVE_ERR_NO_DIRECT_ACCESS                      = $00001006;
  DIVE_ERR_NOT_BANK_SWITCHED                     = $00001007;
  DIVE_ERR_INVALID_BANK_NUMBER                   = $00001008;
  DIVE_ERR_FB_NOT_ACQUIRED                       = $00001009;
  DIVE_ERR_FB_ALREADY_ACQUIRED                   = $0000100a;
  DIVE_ERR_ACQUIRE_FAILED                        = $0000100b;
  DIVE_ERR_BANK_SWITCH_FAILED                    = $0000100c;
  DIVE_ERR_DEACQUIRE_FAILED                      = $0000100d;
  DIVE_ERR_INVALID_PALETTE                       = $0000100e;
  DIVE_ERR_INVALID_DESTINATION_RECTL             = $0000100f;
  DIVE_ERR_INVALID_BUFFER_NUMBER                 = $00001010;
  DIVE_ERR_SSMDD_NOT_INSTALLED                   = $00001011;
  DIVE_ERR_BUFFER_ALREADY_ACCESSED               = $00001012;
  DIVE_ERR_BUFFER_NOT_ACCESSED                   = $00001013;
  DIVE_ERR_TOO_MANY_BUFFERS                      = $00001014;
  DIVE_ERR_ALLOCATION_ERROR                      = $00001015;
  DIVE_ERR_INVALID_LINESIZE                      = $00001016;
  DIVE_ERR_FATAL_EXCEPTION                       = $00001017;
  DIVE_ERR_INVALID_CONVERSION                    = $00001018;
  DIVE_ERR_VSD_ERROR                             = $00001019;
  DIVE_ERR_COLOR_SUPPORT                         = $0000101a;
  DIVE_ERR_OUT_OF_RANGE                          = $0000101b;
  DIVE_WARN_NO_SIZE                              = $00001100;

  DIVE_BUFFER_SCREEN                             = $00000000;
  DIVE_BUFFER_GRAPHICS_PLANE                     = $00000001;
  DIVE_BUFFER_ALTERNATE_PLANE                    = $00000002;

  DIVE_FULLY_VISIBLE                             = $ffffffff;

/* Use either of the two defines as the pRGB2Entries pointer to have DIVE    */
/* query and set the physical or default palette as source or destination.   */
const
  DIVE_PALETTE_PHYSICAL                    = PBYTE($00000000);
  DIVE_PALETTE_DEFAULT                     = PBYTE($ffffffff);


/* Notes:
      Associated/Allocated memory buffers start at:      $00000010

      Specifing DIVE_BUFFER_GRAPHICS_PLANE results in the image being
            transferred to the graphics plane.
      Specifing DIVE_BUFFER_ALTERNATE_PLANE results in the image being
            transferred to the alternate (e.g. overlay) plane.  If your
            hardware doesn't support such a plane, this is an error.
      Specifing DIVE_BUFFER_SCREEN will result in the image being
            transferred to either the graphics plane buffer or the alternate
            plane buffer based on if an alternate buffer exists and based on
            the suitability the overlay plane to accelerate the scaling of
            the image.  If DIVE chooses to use the alternate buffer, it
            will also paint the overlay "key" color on the graphics plane.
            This automatic painting does not occur if the alternate plane
            is explicitly specified.
*/

type
  DIVE_CAPS = record
    ulStructLen:            ULONG;   /* Set equal to sizeof(DIVE_CAPS)          */
    ulPlaneCount:           ULONG;   /* Number of defined planes.               */

    /* Info returned in the following fields pertains to ulPlaneID.           */
    fScreenDirect:          BOOL;    /* TRUE if can get addressability to vram. */
    fBankSwitched:          BOOL;    /* TRUE if vram is bank-switched.          */
    ulDepth:                ULONG;   /* Number of bits per pixel.               */
    ulHorizontalResolution: ULONG;   /* Screen width in pixels.                 */
    ulVerticalResolution:   ULONG;   /* Screen height in pixels.                */
    ulScanLineBytes:        ULONG;   /* Screen scan line size in bytes.         */
    fccColorEncoding:       FOURCC;  /* Colorspace encoding of the screen.      */
    ulApertureSize:         ULONG;   /* Size of vram aperture in bytes.         */

    ulInputFormats:         ULONG;   /* Number of input color formats.          */
    ulOutputFormats:        ULONG;   /* Number of output color formats.         */
    ulFormatLength:         ULONG;   /* Length of format buffer.                */
    pFormatData:            Pointer; /* Pointer to color format buffer FOURCC's.*/
  end;

  PDIVE_CAPS = ^DIVE_CAPS;

  SETUP_BLITTER = record

     /* Set the ulStructLen field equal to the amount of the structure used. */
     /* allowable: blank lines below mark sizes of 8, 28, 32, 52, 60, or 68. */
   ulStructLen: ULONG;
     /* Set the ulInvert flags based on the following:                       */
     /* b0001 = d01 = h01 = flip the image in the horizontal direction.      */
     /* b0010 = d02 = h02 = flip the image in the vertical direction.        */
     /* All other bits ignored.                                              */
   fInvert: ULONG;

     /* This is the color format of the source data.  See "FOURCC.H"         */
   fccSrcColorFormat: FOURCC;
     /* This is the width of the source image in pixels.                     */
   ulSrcWidth: ULONG;
     /* This is the height of the source image in pixels.                    */
   ulSrcHeight: ULONG;
     /* This is the horizontal offset from which to start displaying for     */
     /* use in displaying a sub-portion of the source image.                 */
   ulSrcPosX: ULONG;
     /* This is the vertical offset from which to start displaying.          */
   ulSrcPosY: ULONG;

     /* This is the dither type to use.  0 defines no dither and 1           */
     /* defines 2x2 dither (all others ignored).  Note: dithering is only    */
     /* supported in direct color to LUT8 conversions.                       */
   ulDitherType: ULONG;

     /* This is the color format of the destinaion data.  See "FOURCC.H"     */
   fccDstColorFormat: FOURCC;
     /* This is the width of the destination image in pixels.                */
   ulDstWidth: ULONG;
     /* This is the height of the destination image in pixels.               */
   ulDstHeight: ULONG;
     /* This is the horizontal offset from which to start displaying for     */
     /* use in displaying to sub-portion of the destination image.           */
   lDstPosX: LONG;
     /* This is the vertical offset from which to start displaying.          */
   lDstPosY: LONG;

     /* This is the world screen horizontal position, where 0 is left.       */
     /* These are ignored if the destination is not the screen.              */
   lScreenPosX: LONG;
     /* This is the world screen vertical position, where 0 is bottom.       */
   lScreenPosY: LONG;

     /* This is the number of visible rectangular regions being passed in.   */
     /* These are ignored if the destination is not the screen.              */
     /* Also, if you application *KNOWS* that the region is fully visible    */
     /* (like not going to the screen), the you can use DIVE_FULLY_VISIBLE   */
     /* instead of making up a bogus visible region structure.               */
   ulNumDstRects: ULONG;
     /* This points to an array of visible regions which defines what        */
     /* portions of the source image are to be displayed.                    */
   pVisDstRects: PRECTL;          /* Pointer to array of visible rectangles. */
  end;

  PSETUP_BLITTER = ^SETUP_BLITTER;

imports

function DiveQueryCaps ( pDiveCaps:     PDIVE_CAPS;
                         ulPlaneBufNum: ULONG       ): ULONG;
         APIENTRY; 'DIVE' NAME 'DiveQueryCaps';

function DiveOpen ( var phDiveInst:         HDIVE;
                        fNonScreenInstance: BOOL;
                        ppFrameBuffer:      Pointer ): ULONG;
         APIENTRY; 'DIVE' name 'DiveOpen';

function DiveSetupBlitter ( hDiveInst:     HDIVE;
                            pSetupBlitter: PSETUP_BLITTER ): ULONG;
         APIENTRY; 'DIVE' name 'DiveSetupBlitter';

function DiveBlitImage ( hDiveInst:      HDIVE;
                         ulSrcBufNumber: ULONG;
                         ulDstBufNumber: ULONG  ): ULONG;
         APIENTRY; 'DIVE' name 'DiveBlitImage';

function DiveClose ( hDiveInst: HDIVE ): ULONG;
         APIENTRY; 'DIVE' name 'DiveClose';

function DiveAcquireFrameBuffer ( hDiveInst: HDIVE;
                                  prectlDst: PRECTL ): ULONG;
         APIENTRY; 'DIVE' name 'DiveAcquireFrameBuffer';

function DiveSwitchBank ( hDiveInst:    HDIVE;
                          ulBankNumber: ULONG  ): ULONG;
         APIENTRY; 'DIVE' name 'DiveSwitchBank';

function DiveDeacquireFrameBuffer ( hDiveInst: HDIVE ): ULONG;
         APIENTRY; 'DIVE' name 'DiveDeacquireFrameBuffer';

function DiveCalcFrameBufferAddress (     hDiveInst:            HDIVE;
                                          prectlDest:           PRECTL;
                                      var ppDestinationAddress: BYTE;
                                          pulBankNumber:        PULONG;
                                          pulRemLinesInBank:    PULONG  ): ULONG;
         APIENTRY; 'DIVE' name 'DiveCalcFrameBufferAddress';

/* Notes on DiveAllocImageBuffer:
      If pbImageBuffer is not NULL, the buffer is associated rather than
      allocated.  If pbImageBuffer is not NULL and the buffer number
      pointed to by pulBufferNumber is non-zero, a new buffer pointer is
      associated with the buffer number.  Even though no memory is
      allocated by DiveAllocImageBuffer when user-allocated buffers are
      associated, DiveFreeImageBuffer should be called to release the
      buffer association to avoid using up available buffer indexes.
      The specified line size will be used if a buffer is allocated in
      system memory, or if a user buffer is associated.  If the
      specified line size is zero, the allocated line size is rounded up
      to the nearest DWORD boundry.
*/
function DiveAllocImageBuffer ( hDiveInst:       HDIVE;
                                pulBufferNumber: PULONG;
                                fccColorSpace:   FOURCC;
                                ulWidth:         ULONG;
                                ulHeight:        ULONG;
                                ulLineSizeBytes: ULONG;
                                pbImageBuffer:   PBYTE   ): ULONG;
         APIENTRY; 'DIVE' name 'DiveAllocImageBuffer';

function DiveFreeImageBuffer ( hDiveInst:      HDIVE;
                               ulBufferNumber: ULONG  ): ULONG;
         APIENTRY; 'DIVE' name 'DiveFreeImageBuffer';

function DiveBeginImageBufferAccess ( hDiveInst:              HDIVE;
                                      ulBufferNumber:         ULONG;
                                      var ppbImageBuffer:     PBYTE;
                                      pulBufferScanLineBytes: PULONG;
                                      pulBufferScanLines:     PULONG  ): ULONG;
         APIENTRY; 'DIVE' name 'DiveBeginImageBufferAccess';

function DiveEndImageBufferAccess ( hDiveInst:      HDIVE;
                                    ulBufferNumber: ULONG  ): ULONG;
         APIENTRY; 'DIVE' name 'DiveEndImageBufferAccess';

/* Notes on palettes:
      Neither DiveSetSourcePalette nor DiveSetDestinationPalette API's will set
      the physical palette.  If your application MUST set the PHYSICAL palette,
      try using no more than 236 entries (the middle 236: 10-245, thus leaving
      the top and bottom 10 entries for the Workplace Shell).  If your
      application MUST use ALL 256 entries, it must do so as a full-screen
      (i.e. maximized) application.  Remember, No WM_REALIZEPALETTE message
      will be sent to other running applications, meaning they will not redraw
      and their colors will be all wrong.  It is not recommended that a
      developer use these commands:

   To set physical palette, do the following:
            hps = WinGetPS ( HWND_DESKTOP );
            hdc = GpiQueryDevice ( hps );
            GpiCreateLogColorTable ( hps, LCOL_PURECOLOR | LCOL_REALIZABLE,
                           LCOLF_CONSECRGB, 0, 256, (PLONG)plRGB2Entries );
            Gre32EntrY3 ( hdc, 0L, $000060C6L );
            WinInvalidateRect ( HWND_DESKTOP, (PRECTL)NULL, TRUE );
            WinReleasePS ( hps );

   To reset physical palette, do the following:
            hps = WinGetPS ( HWND_DESKTOP );
            hdc = GpiQueryDevice ( hps );
            Gre32EntrY3 ( hdc, 0L, $000060C7L );
            WinInvalidateRect ( HWND_DESKTOP, (PRECTL)NULL, TRUE );
            WinReleasePS ( hps );
*/

function DiveSetDestinationPalette ( hDiveInst:     HDIVE;
                                     ulStartIndex:  ULONG;
                                     ulNumEntries:  ULONG;
                                     pbRGB2Entries: PBYTE ): ULONG;
         APIENTRY; 'DIVE' name 'DiveSetDestinationPalette';

function DiveSetSourcePalette ( hDiveInst:     HDIVE;
                                ulStartIndex:  ULONG;
                                ulNumEntries:  ULONG;
                                pbRGB2Entries: PBYTE ): ULONG;
         APIENTRY; 'DIVE' name 'DiveSetSourcePalette';

end;

const
  DIVE_TBM_NONE                             = $00;
/* No transparency, i.e. all pixels are transferred (default)                */

  DIVE_TBM_EXCLUDE_SOURCE_VALUE             = $01;
/* Source pixels with values that exactly match the value specified in       */
/* ulValue1 are not transferred.                                             */

  DIVE_TBM_EXCLUDE_SOURCE_RGB_RANGE         = $02;
/* Source pixels with values that lie within the range specified in RGB      */
/* color space specified by ulValue1 (minimum) and ulValue2 (maximum)        */
/* are not transferred by DiveBlitImage.                                     */

  DIVE_TBM_INCLUDE_SOURCE_RGB_RANGE         = $03;
/* Source pixels with values that lie outside the range specified in RGB     */
/* color space specified by ulValue1 (minimum) and ulValue2 (maximum)        */
/* are not transferred by DiveBlitImage.                                     */

  DIVE_TBM_EXCLUDE_SOURCE_YUV_RANGE          = $04;
/* Source pixels with values that lie within the range specified in RGB      */
/* color space specified by ulValue1 (minimum) and ulValue2 (maximum)        */
/* are not transferred by DiveBlitImage.                                     */

  DIVE_TBM_INCLUDE_SOURCE_YUV_RANGE          = $05;
/* Source pixels with values that lie outside the range specified in RGB     */
/* color space specified by ulValue1 (minimum) and ulValue2 (maximum)        */
/* are not transferred by DiveBlitImage.                                     */

/* Notes on transparent blitting:
   Supported transparent blitting functions are all based on source pixel
   values.  A pixel in the destination image buffer is not modified if the
   corresponding pixel in the source buffer is "transparent".  The color
   values or color value ranges specified in ulValue1 and ulValue2 are
   dependent on the source image color format (fccSrcColorFormat) and the
   color space in which the range comparison is taking place.

   FOURCC_LUT8:
      The color value is specified in the low 8 bits of parameter

   FOURCC_Y888, FOURCC_Y2X2, FOURCC_Y4X4, FOURCC_YUV9, FOURCC_Y644, FOURCC_Y422:
      23:8 - Y, 15:8 - U, 7:8 - V  (bits 31:8 ignored)

   FOURCC_R565, FOURCC_R555, FOURCC_R664, FOURCC_RGB3, FOURCC_BGR3, FOURCC_RGB4,
   FOURCC_BGR4:
      23:8 - R, 15:8 - G, 7:8 - B  (bits 31:8 ignored)
      R, G, and B components are specified with 8 bit significance, regardless
      of significance in the source data.

   Transparent blitting of other source image formats is not supported.

   For range comparisons in RGB or YUV, the three components are compared
   independently against the minimum and maximum values specified by the
   ulValue1 and ulValue2 parameters respectively.  A value is considered to
   within the specified range if all three components satisfy:
   min <= value <= max.

   For EXCLUDE_SOURCE_VALUE tranparent blitting, the specified value in
   ulValue1 is assumed to be in the source color space as described above.
   For range comparisons, the values specified in ulValue1 and ulValue2 are
   assumed to be in the color space in which the range comparison is to be
   performed, either YUV or RGB.

   - For range comparisons in YUV where the source data format is a YUV
     form, the values in ulValue1 and ulValue2 are in the source YUV
     format.

   - For range comparisons in YUV where the source data format is RGB,
     conversion of source data format from RGB to YUV using standard
     CCIR601 equations is assumed (refer to fourcc.h).

   - For range comparisons in RGB where the source data format is an RGB
     form, the values in ulValue1 and ulValue2 specify the RGB range with
     5 bits significance in R, 6 bits in G, and 5 bits in B.

   - For range comparisons in RGB where the source data format is YUV,
     conversion of source data format from YUV to RGB using standard
     CCIR601 equations is assumed (refer to fourcc.h).



*/

const
  FOURCC_SCRN  = 0;

  FOURCC_R565  = Ord('R')
               + Ord('5') shl 8
               + Ord('6') shl 16
               + Ord('5') shl 24; // mmioFOURCC( 'R', '5', '6', '5' )

  FOURCC_R555  = Ord('R')
               + Ord('5') shl 8
               + Ord('5') shl 16
               + Ord('5') shl 24; // mmioFOURCC( 'R', '5', '5', '5' )

  FOURCC_R664  = Ord('R')
               + Ord('6') shl 8
               + Ord('6') shl 16
               + Ord('4') shl 24; // mmioFOURCC( 'R', '6', '6', '4' )

  FOURCC_RGB3  = Ord('R')
               + Ord('G') shl 8
               + Ord('B') shl 16
               + Ord('3') shl 24; // mmioFOURCC( 'R', 'G', 'B', '3' )

  FOURCC_BGR3  = Ord('B')
               + Ord('G') shl 8
               + Ord('R') shl 16
               + Ord('3') shl 24; // mmioFOURCC( 'B', 'G', 'R', '3' )

  FOURCC_RGB4  = Ord('R')
               + Ord('G') shl 8
               + Ord('B') shl 16
               + Ord('4') shl 24; // mmioFOURCC( 'R', 'G', 'B', '4' )

  FOURCC_BGR4  = Ord('B')
               + Ord('G') shl 8
               + Ord('R') shl 16
               + Ord('4') shl 24; // mmioFOURCC( 'B', 'G', 'R', '4' )

  FOURCC_LUT8  = Ord('L')
               + Ord('U') shl 8
               + Ord('T') shl 16
               + Ord('8') shl 24; // mmioFOURCC( 'L', 'U', 'T', '8' )

  FOURCC_LT12  = Ord('L')
               + Ord('T') shl 8
               + Ord('1') shl 16
               + Ord('2') shl 24; // mmioFOURCC( 'L', 'T', '1', '2' )

  FOURCC_GREY  = Ord('G')
               + Ord('R') shl 8
               + Ord('E') shl 16
               + Ord('Y') shl 24; // mmioFOURCC( 'G', 'R', 'E', 'Y' )

  FOURCC_GY16  = Ord('G')
               + Ord('Y') shl 8
               + Ord('1') shl 16
               + Ord('6') shl 24; // mmioFOURCC( 'G', 'Y', '1', '6' )

  FOURCC_Y888  = Ord('Y')
               + Ord('8') shl 8
               + Ord('8') shl 16
               + Ord('8') shl 24; // mmioFOURCC( 'Y', '8', '8', '8' )

  FOURCC_Y2X2  = Ord('Y')
               + Ord('2') shl 8
               + Ord('X') shl 16
               + Ord('2') shl 24; // mmioFOURCC( 'Y', '2', 'X', '2' )

  FOURCC_Y4X4  = Ord('Y')
               + Ord('4') shl 8
               + Ord('X') shl 16
               + Ord('4') shl 24; // mmioFOURCC( 'Y', '4', 'X', '4' )

  FOURCC_YUV9  = Ord('Y')
               + Ord('U') shl 8
               + Ord('V') shl 16
               + Ord('9') shl 24; // mmioFOURCC( 'Y', 'U', 'V', '9' )

  FOURCC_Y644  = Ord('Y')
               + Ord('6') shl 8
               + Ord('4') shl 16
               + Ord('4') shl 24; // mmioFOURCC( 'Y', '6', '4', '4' )

  FOURCC_MONO  = Ord('M')
               + Ord('O') shl 8
               + Ord('N') shl 16
               + Ord('O') shl 24; // mmioFOURCC( 'M', 'O', 'N', 'O' )

  FOURCC_Y422  = Ord('Y')
               + Ord('4') shl 8
               + Ord('2') shl 16
               + Ord('2') shl 24; // mmioFOURCC( 'Y', '4', '2', '2' )

  FOURCC_Y42B  = Ord('Y')
               + Ord('4') shl 8
               + Ord('2') shl 16
               + Ord('B') shl 24; // mmioFOURCC( 'Y', '4', '2', 'B' )

  FOURCC_Y42D  = Ord('Y')
               + Ord('4') shl 8
               + Ord('2') shl 16
               + Ord('D') shl 24; // mmioFOURCC( 'Y', '4', '2', 'D' )

  FOURCC_Y411  = Ord('Y')
               + Ord('4') shl 8
               + Ord('1') shl 16
               + Ord('1') shl 24; // mmioFOURCC( 'Y', '4', '1', '1' )

  FOURCC_VGA   = Ord('V')
               + Ord('G') shl 8
               + Ord('A') shl 16
               + Ord(' ') shl 24; // mmioFOURCC( 'V', 'G', 'A', ' ' )

/******************************************************************************

 DIVE color format definitions:

   FOURCC_SCRN : Use the fourcc of the screen, typically LUT8, R565, or BGR3.

   FOURCC_R565 : This is single plane two byte per pixel format:
                 in USHORT: "rrrr rggg  gggb bbbb"
                            "4321 0543  2104 3210"
                 in memory: "gggb bbbb  rrrr rggg"
                            "2104 3210  4321 0543"

   FOURCC_R555 : This is single plane two byte per pixel format:
                 in USHORT: "xrrr rrgg  gggb bbbb"
                            "-432 1043  2104 3210"
                 in memory: "gggb bbbb  xrrr rrgg"
                            "2104 3210  -432 1043"

   FOURCC_R664 : This is single plane two byte per pixel format:
                 in USHORT: "rrrr rrgg  gggg bbbb"
                            "5432 1054  3210 3210"
                 in memory: "gggg bbbb  rrrr rrgg"
                            "3210 3210  5432 1054"

   FOURCC_RGB3 : This is single plane three byte per pixel format:
                 in ULONG:  "xxxx xxxx  bbbb bbbb  gggg gggg  rrrr rrrr"
                            "---- ----  7654 3210  7654 3210  7654 3210"
                 in memory: "rrrr rrrr  gggg gggg  bbbb bbbb"
                            "7654 3210  7654 3210  7654 3210"

   FOURCC_BGR3 : This is single plane three byte per pixel format:
                 in ULONG:  "xxxx xxxx  rrrr rrrr  gggg gggg  bbbb bbbb"
                            "---- ----  7654 3210  7654 3210  7654 3210"
                 in memory: "bbbb bbbb  gggg gggg  rrrr rrrr"
                            "7654 3210  7654 3210  7654 3210"

   FOURCC_RGB4 : This is single plane four byte per pixel format:
                 in ULONG:  "0000 0000  bbbb bbbb  gggg gggg  rrrr rrrr"
                            "---- ----  7654 3210  7654 3210  7654 3210"
                 in memory: "rrrr rrrr  gggg gggg  bbbb bbbb  0000 0000"
                            "7654 3210  7654 3210  7654 3210  ---- ----"

   FOURCC_BGR4 : This is single plane four byte per pixel format:
                 in ULONG:  "0000 0000  rrrr rrrr  gggg gggg  bbbb bbbb"
                            "---- ----  7654 3210  7654 3210  7654 3210"
                 in memory: "bbbb bbbb  gggg gggg  rrrr rrrr  0000 0000"
                            "7654 3210  7654 3210  7654 3210  ---- ----"

   FOURCC_LUT8 : This is a single plane one byte per pixel format:
                 in BYTE:   "7654 3210"
                 in memory: "7654 3210"
                 An 256 entry BGR4 palette represents the lookup table.

   FOURCC_LT12 : This is a single plane two byte per pixel format:
                 in USHORT: "0000 ba98  7654 3210"
                 in memory: "7654 3210  0000 ba98"
                 An 4096 entry BGR4 palette represents the lookup table.

   FOURCC_Y888 : This is a three plane one byte per component pixel format:
                 ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
                 ≥              ≥     In Y888, each of the three consecutive
                 ≥      Y       ≥     planse are of the same size (i.e. the
                 ≥   [0..255]   ≥     chrominance planes are not subsampled).
                 ≥  7654  3210  ≥
                 ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ     Normal CCIR601 conversions apply:
                 ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒø     R = Y + ( Cr - 128 ) * 1.370
                 ≥      Cr      ≥     G = Y - ( Cb - 128 ) * 0.336
                 ≥   [0..255]   ≥           - ( Cr - 128 ) * 0.698
                 ≥ center = 128 ≥     B = Y + ( Cb - 128 ) * 1.730
                 ≥  7654  3210  ≥
                 ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ     Y = R * 0.299 + G * 0.587 + B * 0.114
                 ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒø         U = ( B - Y ) * 0.492
                 ≥      Cb      ≥         V = ( R - Y ) * 0.877
                 ≥   [0..255]   ≥     Cb = U + 128
                 ≥ center = 128 ≥     Cr = V + 128
                 ≥  7654  3210  ≥
                 ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

   FOURCC_Y2X2 : This is a three plane one byte per component pixel format:
                 ⁄ƒƒƒƒø
                 ≥    ≥   Same as Y888, except that the Cr and Cb planes
                 ≥    ≥   are subsampled 2x2.
                 ¿ƒƒƒƒŸ
                 ⁄ƒƒø
                 ≥  ≥
                 ¿ƒƒŸ
                 ⁄ƒƒø
                 ≥  ≥
                 ¿ƒƒŸ

   FOURCC_Y4X4 : This is a three plane one byte per component pixel format:
                 ⁄ƒƒƒƒø
                 ≥    ≥   Same as Y888, except that the Cr and Cb planes
                 ≥    ≥   are subsampled 4x4.
                 ¿ƒƒƒƒŸ
                 ⁄ø
                 ¿Ÿ
                 ⁄ø
                 ¿Ÿ

   FOURCC_YUV9 : This is a three plane one byte per component pixel format:
                 Same as Y4X4.

   FOURCC_Y644 : This is a two plane one byte per component pixel format:
                 ⁄ƒƒƒƒø
                 ≥    ≥   The first plane is a Y plane: "00YY YYYY" "--54 3210"
                 ≥    ≥   The second plane a UV combined plane, and it
                 ¿ƒƒƒƒŸ      is 4x4 subsampled: "UUUU VVVV" "3210 3210"
                 ⁄ø          To convert from the four-bit chrominance
                 ¿Ÿ          components to normal 8-bit, do:
                                 U = 6.375 * ( U' - 5 )
                                 V = 7.500 * ( V' - 6 )

   FOURCC_MONO : This is a single plane one bit per pixel format:
                 ⁄ƒƒƒƒø
                 ≥    ≥   Each byte is "0123 4567" in pixel order left to
                 ≥    ≥   right where a zero bit corresponds to black and
                 ¿ƒƒƒƒŸ   a one bit corresponds to white.

   FOURCC_Y422 : This is a single plane three component interleaved format:
                 ⁄ƒƒƒƒø
                 ≥    ≥   "yyyy yyyy" "uuuu uuuu" "yyyy yyyy" "vvvv vvvv"
                 ≥    ≥   "7654 3210" "7654 3210" "7654 3210" "7654 3210"
                 ¿ƒƒƒƒŸ   where each of the above repeating groups represent
                          two pixels.  The left Y, the U and the V combine to
                          form the left CCIR601 color, and the right Y, the
                          U and the V combine to form the right.  This is
                          effectively a 2x1 subsampling.

   FOURCC_Y42B : Same as FOURCC_Y422, except byte swapped within words:
                 ⁄ƒƒƒƒø
                 ≥    ≥   "uuuu uuuu" "yyyy yyyy" "vvvv vvvv" "yyyy yyyy"
                 ≥    ≥   "7654 3210" "7654 3210" "7654 3210" "7654 3210"
                 ¿ƒƒƒƒŸ

   FOURCC_Y42D : Same as FOURCC_Y422, except byte swapped within DWORDs:
                 ⁄ƒƒƒƒø
                 ≥    ≥   "vvvv vvvv" "yyyy yyyy" "uuuu uuuu" "yyyy yyyy"
                 ≥    ≥   "7654 3210" "7654 3210" "7654 3210" "7654 3210"
                 ¿ƒƒƒƒŸ

   FOURCC_Y411 : This is a single plane three component interleaved format:
                 ⁄ƒƒƒƒø
                 ≥    ≥   Use four consecutive 2-byte words as four pixels.
                 ≥    ≥   The is effectively a 4x1 subsampling.  Each word
                 ¿ƒƒƒƒŸ   has it's own 7-bit luminance and a chrominance part:

              Cb6:Cb5:Cr6:Cr5:???:???:???:???  Ya6:Ya5:Ya4:Ya3:Ya2:Ya1:Ya0:???
              Cb4:Cb3:Cr4:Cr3:???:???:???:???  Yb6:Yb5:Yb4:Yb3:Yb2:Yb1:Yb0:???
              Cb2:Cb1:Cr2:Cr1:???:???:???:???  Yc6:Yc5:Yc4:Yc3:Yc2:Yc1:Yc0:???
              Cb0:???:Cr0:???:???:???:???:???  Yd6:Yd5:Yd4:Yd3:Yd2:Yd1:Yd0:???
                                              ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
              Therefore, four pixels in a     ≥        Cr         ≥
              row share a chrominace pair     √ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥
              and look like:                  ≥        Cb         ≥
                                              √ƒƒƒƒ¬ƒƒƒƒ¬ƒƒƒƒ¬ƒƒƒƒ¥
                                              ≥ Ya ≥ Yb ≥ Yc ≥ Yd ≥
                                              ¿ƒƒƒƒ¡ƒƒƒƒ¡ƒƒƒƒ¡ƒƒƒƒŸ

   FOURCC_VGA  : This is a single plane 16 color format:
                 ⁄ƒƒƒƒø
                 ≥    ≥   Each byte is "xxxx yyyy" "3210 3210" where 'x'
                 ≥    ≥   is the first pixel and 'y' is the next.  The 16
                 ¿ƒƒƒƒŸ   colors are the standard VGA colors.




 DIVE conversion support matrix:

         R  R  R  R  B  R  B  L  L  G  G  Y  Y  Y  Y  Y  M  Y  Y  V
         5  5  6  G  G  G  G  U  T  R  Y  8  2  4  U  6  O  4  4  G
         6  5  6  B  R  B  R  T  1  E  1  8  X  X  V  4  N  2  1  A
out |in  5  5  4  3  3  4  4  8  2  Y  6  8  2  4  9  4  O  2  1
----|--------------------------------------------------------------
R565|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
R555|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
R664|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
RGB3|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
BGR3|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
RGB4|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
BGR4|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
LUT8|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
LT12|                            X
GREY|                               X
GY16|                                  X
Y888|
Y2X2|
Y4X4|
YUV9|
Y644|
MONO|
Y422|    X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X  X
Y411|
VGA |

******************************************************************************/

implementation

end.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Mai-07  WD         Unit Åberarbeitet.
}

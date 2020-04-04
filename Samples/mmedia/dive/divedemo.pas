/**************************************************************************
* DIVE demo application. Taken from OS/2 Warp Toolkit.
* Translation to Sibyl: 20-Aug-97, Joerg Pleumann
*
* Limitations: - No fullscreen support
*              - No custom bitmaps can be specified.
****************************************************************************/

/**************************************************************************
*
* File Name        : DIVEDEMO.C
*
* Description      : This program provides the sample code of using DIVE APIs.
*
*                    Direct Interface Video Extension is developed for
*                    the entertainment, education, and games software
*                    to give the high-speed perforemance.
*
*
*
* Concepts         :
*
* Entry Points     : DirectMoveMem()
*                    ReadFile()
*                    Main()
*                    MyWindowProc()
*
* DIVE API's       :
*                    DiveSetSourcePalette
*                    DiveBlitImage
*                    DiveAllocImageBuffer
*                    DiveBeginImageBufferAccess
*                    DiveEndImageBufferAccess
*                    DiveOpen
*                    DiveSetDestinationPalette
*                    DiveFreeImageBuffer
*                    DiveClose
*                    DiveSetupBlitter
*
* Copyright        : COPYRIGHT IBM CORPORATION, 1991, 1992, 1993
*
*        DISCLAIMER OF WARRANTIES.  The following [enclosed] code is
*        sample code created by IBM Corporation. This sample code is not
*        part of any standard or IBM product and is provided to you solely
*        for  the purpose of assisting you in the development of your
*        applications.  The code is provided "AS IS", without
*        warranty of any kind.  IBM shall not be liable for any damages
*        arising out of your use of the sample code, even if they have been
*        advised of the possibility of such damages.
*
****************************************************************************/

program DiveDemo;

uses OS2Def, BseDos, PmGpi, PmWin, PmBitmap, Dive,
     uSysInfo, Dos, SysUtils;

{$r DiveDemo.srf}

//   Menu items definitions
const
  ID_MAINWND    = 256;
  ID_OPTIONS    = 257;
  ID_SNAP       = 258;
  ID_EXIT       = 259;
  ID_NEWTEXT    = 260;
  ID_QUERY      = 261;
  ID_DIRECT     = 263;
  ID_USEDIVE    = 264;
  ID_FULLSCR    = 265;

  ID_DIALOG     = 262;
  ID_EF_11      =  11;
  ID_EF_12      =  12;
  ID_EF_13      =  13;
  ID_EF_14      =  14;
  ID_EF_15      =  15;
  ID_EF_16      =  16;
  ID_EF_17      =  17;
  ID_EF_18      =  18;
  ID_EF_19      =  19;
  ID_EF_20      =  20;


  WM_GetVideoModeTable     = $04A2;
  WM_SetVideoMode          = $04A0;
  WM_NotifyVideoModeChange = $04A1;


//   Maximum number of files to support
  MAX_FILE = 14;                    /* Maximum number of bitmap files    */

//   Windoe data structure
type
  WINDATA = record
    fStartBlit: BOOL;
    fVrnDisabled: BOOL;             /* ????  Visual region enable/disable  */
    fChgSrcPalette: BOOL;           /* Flag for change of source palette   */
    fDataInProcess: BOOL;           /* ????  Visual region enable/disable  */
    fDirect: BOOL;                  /* Indicates direct access or blit     */
    hwndFrame: HWND;                /* Frame window handle                 */
    hwndClient: HWND;               /* Client window handle                */
    _hDive: HDIVE;                  /* DIVE handle                         */
    ulnumColor: ULONG;              /* Number of colors in bitmaps         */
    ulWidth: ULONG;                 /* Bitmap width in pels                */
    ulHeight: ULONG;                /* Bitmap Height in pels               */
    fccColorFormat: FOURCC;         /* Bitmap color format                 */
    ulMaxFiles: ULONG;              /* Number of bimap files showing       */
    tidBlitThread: TID;             /* Thread ID for blitting routine      */
    ulSrcLineSizeBytes: ULONG;      /* source linesize                     */
    cxWidthWindow: LONG;            /* Size of width of frame window       */
    cyHeightWindow: LONG;           /* Size of height of frame window      */
    cxWindowPos: LONG;              /* X position of frame window          */
    cyWindowPos: LONG;              /* Y position of frmae window          */

    plWindowPos: POINTL;            /* Position of display window          */
    rcls: array[0..49] of RECTL;    /* Visible region rectangles           */
    ulNumRcls: ULONG;               /* Number of visible region rectangles */
    ulLineSizeBytes: ULONG;         /* Size of scan line bounded by window */
    ulColorSizeBytes: ULONG;        /* Number of bytes per pel             */

    _swp: SWP;                      /* Standard window position structure  */
  end;
  PWINDATA = ^WINDATA;

  PPBYTE = ^PBYTE;

  PFN = procedure;

const
  WS_DesktopDive    = 0;   // Desktop dive window style
  WS_MaxDesktopDive = 1;   // Maximized desktop dive window style
  WS_FullScreenDive = 2;   // Full-screen 320x200x256 dive style


// Function prototypes
function MyWindowProc(_hwnd: HWND; msg: ULONG; mp1, mp2: MPARAM): MRESULT; CDECL; forward;
function MyDlgProc(hwndDlg: HWND; msg: ULONG; mp1, mp2: MPARAM): MRESULT; CDECL; forward;

// Global definitions
const
  pszMyWindow = 'MyWindow';             /* Window class name                 */
  pszTitleText = 'DIVE SAMPLE';         /* Title bar text                    */

var
  _hab: HAB;                                 /* PM anchor block handle            */
  ulImage: array[0..MAX_FILE-1] of ULONG;    /* Image buffer numbers from Dive    */
  pPalette: array[0..MAX_FILE-1] of Pointer; /* Pointer to bitmap palette area    */
  ulToEnd: ULONG = 0;                        /*                                   */
  DiveCaps: DIVE_CAPS;
  fccFormats: array[0..99] of FOURCC;
  ulFramesToTime: ULONG = 8;                 /* Interval of frames to get time    */
  ulNumFrames: ULONG = 0;                    /* Frame counter                     */
  BmpDir : tFileName;

//  Default bitmap file name definitions
//       These files are used only when EXE is called without parameter.

  pszDefFile : array[0..15] of PSZ =
    ('TPG20000.BMP',
     'TPG20001.BMP',
     'TPG20002.BMP',
     'TPG20003.BMP',
     'TPG20004.BMP',
     'TPG20005.BMP',
     'TPG20006.BMP',
     'TPG20007.BMP',
     'TPG20008.BMP',
     'TPG20009.BMP',
     'TPG20010.BMP',
     'TPG20011.BMP',
     'TPG20012.BMP',
     'TPG20013.BMP',
     'TPG20014.BMP',
     'TPG20015.BMP');

//  It is the definition how many time draw each bitmap

  ulDrawCnt: array[0..15] of ULONG =
    (
      1,                                  /* For TPG20000.BMP  */
      1,                                  /* For TPG20001.BMP  */
      1,                                  /* For TPG20002.BMP  */
      1,                                  /* For TPG20003.BMP  */
      1,                                  /* For TPG20004.BMP  */
      1,                                  /* For TPG20005.BMP  */
      1,                                  /* For TPG20006.BMP  */
      1,                                  /* For TPG20007.BMP  */
      1,                                  /* For TPG20008.BMP  */
      1,                                  /* For TPG20009.BMP  */
      1,                                  /* For TPG20010.BMP  */
      1,                                  /* For TPG20011.BMP  */
      1,                                  /* For TPG20012.BMP  */
      1,                                  /* For TPG20013.BMP  */
      1,                                  /* For TPG20014.BMP  */
      1);                                 /* For TPG20015.BMP  */

/****************************************************************************
 *
 * Name          : DirectMoveMem
 *
 * Description   : It is calling DIVE bitblt function periodically.
 *                 And also it calculates how many frames per a second
 *                 is able to be blit to the screen.
 *
 * Concepts      :
 *
 * Parameters    : Pointer to window data
 *
 * Return        : VOID
 *
 ****************************************************************************/

// VOID APIENTRY DirectMoveMem (ULONG parm1)

procedure DirectMoveMem(parm1: ULONG);
var
  ulTime0, ulTime1: ULONG;              /* output buffer for DosQierySysInfo      */
  ulIndexImage: ULONG = 0;              /* Index of bitmap data                   */
  achFrameRate: array[0..47] of CHAR;   /* string buffer for WinSetWindowText     */
  tmpFrameRate: string;                 /* temp string buffer                     */
  ulFirstTime: ULONG = 0;               /* very first time flag for DiveSetSour.. */

  _pwinData: PWINDATA;                  /* pointer to window data                 */
  ulCount: ULONG = 0;                   /* Counter for each bitmap                */
  b: Boolean;

begin
  _pwinData := PWINDATA(parm1);

  while (ulToEnd = 0) do
  begin

    /* Check if it's time to start the blit-time counter.
    */
    if (ulNumFrames = 0) then
      DosQuerySysInfo (QSV_MS_COUNT, QSV_MS_COUNT, ulTime0, 4);

    Inc(ulNumFrames);

    /* Check if need to change the source palette.
    **
    ** In this sample case, this API should be called only once at
    ** very first.  After this, it will not be called, because there is
    ** assumption that all bitmap data have the sample palette.
    */

    b := _pwinData^.fChgSrcPalette;
    b := b or (ulFirstTime = 0) and (_pwinData^.ulnumColor = 256);

    if b then
    begin
      DiveSetSourcePalette (_pwinData^._hDive, 0,
                            _pwinData^.ulnumColor,
                            PBYTE(pPalette[ulIndexImage]));
      ulFirstTime := $FFFF;
    end;

    /* Blit the image.
    */
    DiveBlitImage (_pwinData^._hDive,
                   ulImage[ulIndexImage],
                   DIVE_BUFFER_SCREEN);

    /* Updated the index for the bitmap data to be drawn next.
    */
    Inc(ulCount);
    if (ulCount >=  ulDrawCnt[ulIndexImage]) then
    begin
      Inc(ulIndexImage);
      ulCount := 0;
    end;

    if (ulIndexImage >= _pwinData^.ulMaxFiles) then
      ulIndexImage := 0;

    /* Check to see if we have enough frames for a fairly accurate read.
    */
    if (ulNumFrames >= ulFramesToTime) then
    begin
      DosQuerySysInfo (QSV_MS_COUNT, QSV_MS_COUNT, ulTime1, 4);
      ulTime1 := ulTime1 - ulTime0;
      if (ulTime1 <> 0) then
        FmtStr(tmpFrameRate, '%d: %d: %5.2f frames per second.',
               [_pwinData^._hDive, ulFramesToTime,
                 ulFramesToTime * 1000.0 / ulTime1])
      else
        FmtStr(tmpFrameRate, '%d: %d: Lots of frames per second.',
               [_pwinData^._hDive, ulFramesToTime]);

      StrPCopy(@achFrameRate, tmpFrameRate);

      WinPostMsg (_pwinData^.hwndFrame, WM_COMMAND,
                  ID_NEWTEXT, MPARAM(@achFrameRate));

      ulNumFrames := 0;

      /* Adjust number of frames to time based on last set.
      */
      if (ulTime1 < 250) then
        ulFramesToTime := ulFramesToTime shl 1;
      if (ulTime1 > 3000) then
        ulFramesToTime := ulFramesToTime shr 1;
    end;

    /* Let other threads and processes have some time.
    */
    DosSleep (0);
  end;
end;

/****************************************************************************
 *
 * Name          : ReadFile
 *
 * Description   : It opens the file, and reads bitmap header and bitmap
 *                 palette, and reads image data to the buffer allocated
 *                 by DIVE APIs.
 *
 * Concepts      :
 *
 * Parameters    : Index for the file to open
 *                 Pointer to the file name to open
 *                 Pointer to window data
 *
 * Return        : 0 - succeed
 *                 1 - fail
 *
 ****************************************************************************/


// unsigned long ReadFile (ULONG iFile, unsigned char *pszFile,
//        PWINDATA _pwinData)

function ReadFile(iFile: ULONG; fn : tFileName; _pwinData: PWINDATA): ULONG;
var
  _hFile: HFILE;                        /* file handke                              */
  ulNumBytes: ULONG;                    /* output for number of bytes actually read */
  ulFileLength: ULONG;                  /* file length                              */
  pbBuffer: PBYTE;                      /* pointer to the image/ temp. palette data */
  ulScanLineBytes: ULONG;               /* output for number of bytes a scan line   */
  ulScanLines: ULONG;                   /* output for height of the buffer          */
  pImgHdr: PBITMAPFILEHEADER2;          /* pointer to bitmapheader                  */
  i, j: ULONG;
  pbTmpDst: PBYTE;                      /* temporaly destination pointer            */
  pTmpLoad: Pointer;                    /* temporaly load pointer                   */
  pszFile : cString;

begin
  /* Attempt to open up the passed filename.
  */
  pszFile:=fn;
  if (DosOpen (pszFile, _hFile, ulNumBytes, 0, FILE_NORMAL,
       OPEN_ACTION_OPEN_IF_EXISTS or OPEN_ACTION_FAIL_IF_NEW,
       OPEN_ACCESS_READONLY or OPEN_SHARE_DENYREADWRITE or
       OPEN_FLAGS_SEQUENTIAL or OPEN_FLAGS_NO_CACHE, nil) <> 0) then
  begin
    Result := 1;
    Exit;
  end;

  /* Get the legnth of the file.
  */
  DosSetFilePtr (_hFile, 0, FILE_END, ulFileLength);
  DosSetFilePtr (_hFile, 0, FILE_BEGIN, ulNumBytes);

                                      /* Allocate memory for bitmap file header
  */
  if (DosAllocMem (pImgHdr, SizeOf(BITMAPFILEHEADER2),
       PAG_COMMIT or PAG_READ or PAG_WRITE) <> 0) then
  begin
    DosClose(_hFile);
    Result := 1;
    Exit;
  end;

  /* Read from the beginning of the header to cbFix in BITMAPINFOHEADER
  ** to know the length of the header.
  */
  if (DosRead (_hFile, pImgHdr^,
       SizeOf(BITMAPFILEHEADER2) - SizeOf(BITMAPINFOHEADER2) +
       SizeOf(ULONG),
       ulNumBytes) <> 0) then
  begin
    DosFreeMem(pImgHdr);
    DosClose(_hFile);
    Result := 1;
    Exit;
  end;

  /* Read the rest of the header.
  */
  pTmpLoad := pImgHdr;
  Inc(pTmpLoad, ulNumBytes);

  if (DosRead (_hFile, pTmpLoad^,
       pImgHdr^.bmp2.cbFix - SizeOf(ULONG),
       ulNumBytes) <> 0) then
  begin
    DosFreeMem(pImgHdr);
    DosClose(_hFile);
    Result := 1;
    Exit;
  end;

  _pwinData^.ulnumColor := 1;

  /* Check the bitmap header format --  new or old one.
  */
  if (pImgHdr^.bmp2.cbFix <> SizeOf(BITMAPINFOHEADER)) then
  begin
    /*  Bitmap has new format (BITMAPFILEHEADER2)
    */

    /* Check bitmap header to see if it can support.
    */

    /* Set how many color bitmap data is supporting
    */
    _pwinData^.ulnumColor := _pwinData^.ulnumColor shl pImgHdr^.bmp2.cBitCount;

    /* Set bitmap width and height in pels.
    */
    _pwinData^.ulWidth  := pImgHdr^.bmp2.cx;
    _pwinData^.ulHeight := pImgHdr^.bmp2.cy;

    /* Calculate source line size.  It should be double word boundary.
    */
    _pwinData^.ulSrcLineSizeBytes := (((pImgHdr^.bmp2.cx *
            (pImgHdr^.bmp2.cBitCount shr 3)) + 3) div 4) * 4;

    /* Set bitmap color format.
    */
    case pImgHdr^.bmp2.cBitCount of
      8:
      begin
        _pwinData^.fccColorFormat := FOURCC_LUT8;
        /* Alloate buffer for palette data in bitmap file.
        */
        if (DosAllocMem (pPalette[iFile],
            _pwinData^.ulnumColor * SizeOf(ULONG),
            PAG_COMMIT | PAG_READ | PAG_WRITE) <> 0) then
        begin
          DosFreeMem(pImgHdr);
          DosClose(_hFile);
          Result := 1;
          Exit;
        end;

        /* Read palette data.
        */
        if (DosRead (_hFile, pPalette[iFile]^,
            _pwinData^.ulnumColor * SizeOf(ULONG),
            ulNumBytes) <> 0) then
        begin
          DosFreeMem(pImgHdr);
          DosFreeMem(pPalette[iFile]);
          DosClose(_hFile);
          Result := 1;
          Exit;
        end;
      end;

      16:
      begin
        _pwinData^.fccColorFormat := FOURCC_R565;
      end;

      24:
      begin
        _pwinData^.fccColorFormat := FOURCC_BGR3;
      end;

    else
      DosFreeMem(pImgHdr);
      DosClose(_hFile);
      Result := 1;
      Exit;
    end;                        /* endswitch */
  end

  else

  begin
    /*  Bitmap has old format (BITMAPFILEHEADER)
    */

    /* Set how many color bitmap data is supporting
    */
    _pwinData^.ulnumColor := _pwinData^.ulnumColor shl PBITMAPFILEHEADER(pImgHdr)^.bmp.cBitCount;

    /* Set bitmap width and height in pels.
    */
    _pwinData^.ulWidth  := PBITMAPFILEHEADER(pImgHdr)^.bmp.cx;
    _pwinData^.ulHeight := PBITMAPFILEHEADER(pImgHdr)^.bmp.cy;

    /* Calculate source line size.  It should be double word boundary.
    */
    _pwinData^.ulSrcLineSizeBytes := (((PBITMAPFILEHEADER(pImgHdr)^.bmp.cx *
            PBITMAPFILEHEADER(pImgHdr)^.bmp.cBitCount shr 3) + 3) div 4) * 4;

// Set bitmap coclor format.
    case PBITMAPFILEHEADER(pImgHdr)^.bmp.cBitCount of
      8:
      begin
        _pwinData^.fccColorFormat := FOURCC_LUT8;
// Alloate buffer for temporally palette data in bitmap file
        if (DosAllocMem(pbBuffer,
            _pwinData^.ulnumColor * SizeOf(RGB),
            PAG_COMMIT | PAG_READ | PAG_WRITE) <> 0) then
        begin
          DosFreeMem(pImgHdr);
          DosClose(_hFile);
          Result := 1;
          Exit;
        end;

        if (DosAllocMem (pPalette[iFile],
            _pwinData^.ulnumColor * SizeOf(ULONG),
            PAG_COMMIT | PAG_READ | PAG_WRITE) <> 0) then
        begin
          DosFreeMem(pImgHdr);
          DosFreeMem(pbBuffer);
          DosClose(_hFile);
          Result := 1;
          Exit;
        end;

// Read palette data
        if (DosRead (_hFile, pbBuffer^,
            _pwinData^.ulnumColor * SizeOf(RGB),
            ulNumBytes) <> 0) then
        begin
          DosFreeMem(pImgHdr);
          DosFreeMem(pbBuffer);
          DosFreeMem(pPalette[iFile]);
          DosClose(_hFile);
          Result := 1;
          Exit;
        end;

// Make each color from 3 bytes to 4 bytes.
        pbTmpDst := pPalette[iFile];
        for i := 0 to _pwinData^.ulnumColor - 1 do
        begin
          pbTmpDst^ := pbBuffer^;
          Inc(pbTmpDst);
          Inc(pbBuffer);

          pbTmpDst^ := pbBuffer^;
          Inc(pbTmpDst);
          Inc(pbBuffer);

          pbTmpDst^ := pbBuffer^;
          Inc(pbTmpDst);
          Inc(pbBuffer);

          Inc(pbTmpDst);
          Inc(pbBuffer);
        end;                            /* endfor */

        DosFreeMem(pbBuffer);
      end;

      16:
      begin
        _pwinData^.fccColorFormat := FOURCC_R565;
      end;

      24:
      begin
        _pwinData^.fccColorFormat := FOURCC_BGR3;
      end;

    else
      DosFreeMem(pImgHdr);
      DosClose(_hFile);
      Result := 1;
      Exit;
    end;                        /* endswitch */
  end;

// Allocate a buffer for image data
  if (DiveAllocImageBuffer(_pwinData^._hDive,
      @ulImage[iFile],
      _pwinData^.fccColorFormat,
      _pwinData^.ulWidth,
      _pwinData^.ulHeight,
      0, nil) <> 0) then
  begin
    if (_pwinData^.fccColorFormat = FOURCC_LUT8) then
      DosFreeMem(pPalette[iFile]);
    DosClose(_hFile);
    Result := 1;
    Exit;
  end;

  if (DiveBeginImageBufferAccess(_pwinData^._hDive,
      ulImage[iFile],
      pbBuffer,
      @ulScanLineBytes,
      @ulScanLines) <> 0) then
  begin
    DiveFreeImageBuffer(_pwinData^._hDive, ulImage[iFile]);
    if (_pwinData^.fccColorFormat = FOURCC_LUT8) then
      DosFreeMem(pPalette[iFile]);
    DosClose(_hFile);
    Result := 1;
    Exit;
  end;

// Read image data
  if (DosRead(_hFile, pbBuffer^,
      _pwinData^.ulSrcLineSizeBytes * _pwinData^.ulHeight,
      ulNumBytes) <> 0) then
  begin
    DiveEndImageBufferAccess(_pwinData^._hDive, ulImage[iFile]);
    DiveFreeImageBuffer(_pwinData^._hDive, ulImage[iFile]);
    if (_pwinData^.fccColorFormat = FOURCC_LUT8) then
      DosFreeMem(pPalette[iFile]);
    DosClose(_hFile);
    Result := 1;
    Exit;
  end;

// Close the file and release the access to the image buffer
  DosFreeMem(pImgHdr);
  DosClose(_hFile);

  DiveEndImageBufferAccess (_pwinData^._hDive, ulImage[iFile]);

  Result := 0;
end;

/****************************************************************************
 *
 * Name          : MyWindowProc
 *
 * Description   : It is the window procedure of this program.
 *
 * Concepts      :
 *
 * Parameters    : Message parameter 1
 *                 Message parameter 2
 *
 * Return        : calling WinDefWindowProc
 *
 ****************************************************************************/

// MRESULT EXPENTRY MyWindowProc (HWND _hwnd, ULONG msg, MPARAM mp1, MPARAM mp2)

function MyWindowProc (_hwnd: HWND; msg: ULONG; mp1, mp2: MPARAM): MRESULT; CDECL;
var
  _pointl: POINTL;                    /* Point to offset from Desktop    */
  _swp: SWP;                          /* Window position                 */
  _hrgn: HRGN;                        /* Region handle                   */
  _hps: HPS;                          /* Presentation Space handle       */
  rcls: array[0..49] of RECTL;        /* Rectangle coordinates           */
  rgnCtl: RGNRECT;                    /* Processing control structure    */
  _pwinData: PWINDATA;                /* Pointer to window data          */
  SetupBlitter: SETUP_BLITTER;        /* structure for DiveSetupBlitter  */
  pPal: PLONG;
  hwndDialog: HWND;
begin
  // Get the pointer to window data
  //
  _pwinData := PWINDATA(WinQueryWindowULong (_hwnd, 0));
  if(_pwinData <> nil) then
  begin
    case Msg of
      WM_COMMAND:
      begin
        case SHORT1FROMMP(mp1) of
          ID_SNAP:
          begin
            /* Use the initial width and height of the window such that
            ** the actual video area equals the source width and height.
            */

            /* Set the new size of the window, but don't move it.
            */
            WinSetWindowPos (_pwinData^.hwndFrame, HWND_TOP,
                    100, 100,
                    _pwinData^.cxWidthWindow,
                    _pwinData^.cyHeightWindow,
                    SWP_SIZE | SWP_ACTIVATE | SWP_SHOW);
          end;

          ID_QUERY:
          begin
            // Get the screen capabilities
            // to display in the dialog box.

            DiveCaps.pFormatData := @fccFormats;
            DiveCaps.ulFormatLength := 120;
            DiveCaps.ulStructLen := SizeOf(DIVE_CAPS);

            if (DiveQueryCaps (@DiveCaps, DIVE_BUFFER_SCREEN) <> 0) then
            begin
              WinMessageBox(HWND_DESKTOP, HWND_DESKTOP,
                      'usage: DIVEDEMO failed to get screen capabilities.',
                      'Error!', 0, MB_OK | MB_MOVEABLE);
            end
            else
            begin
              WinDlgBox (HWND_DESKTOP, _pwinData^.hwndClient,
                         @MyDlgProc, 0,
                         ID_DIALOG, _pwinData);
            end;
          end;

          ID_FULLSCR:            // GameSrvr
          begin
            WinSendMsg(_pwinData^.hwndFrame, WM_SetVideoMode, MPARAM(WS_FullScreenDive), 0); // GameSrvr
          end;

          ID_EXIT:               // Post to quit the dispatch message loop.
          begin
            WinSendMsg(_pwinData^.hwndFrame, WM_SetVideoMode, MPARAM(WS_DesktopDive), 0); // GameSrvr
            WinPostMsg (_hwnd, WM_QUIT, 0, 0);
          end;

          ID_NEWTEXT:
          begin
            /* Write new text string to the title bar
            */
            WinSetWindowText (_pwinData^.hwndFrame, PCHAR(mp2)^);
          end;

        else
          Result := WinDefWindowProc (_hwnd, msg, mp1, mp2);
        end; (* case *)
      end; (* begin *)

      WM_VRNDISABLED:
      begin
        DiveSetupBlitter (_pwinData^._hDive, nil);
      end;

      WM_VRNENABLED:
      begin
        _hps := WinGetPS (_hwnd);

        if (_hps <> 0) then
        begin
          _hrgn := GpiCreateRegion (_hps, 0, nil);

          if (_hrgn <> 0) then
          begin
            //      NOTE: If mp1 is zero, then this was just a move message.
            //      Illustrate the visible region on a WM_VRNENABLE.

            WinQueryVisibleRegion (_hwnd, _hrgn);
            rgnCtl.ircStart     := 0;
            rgnCtl.crc          := 50;
            rgnCtl.ulDirection  := 1;

            // Get the all ORed rectangles

            if (GpiQueryRegionRects (_hps, _hrgn, nil, rgnCtl, rcls[0])) then
            begin
              // Now find the window position and size, relative to parent.

              WinQueryWindowPos (_pwinData^.hwndClient, _swp);

              // Convert the point to offset from desktop lower left.

              _pointl.x := _swp.x;
              _pointl.y := _swp.y;

              WinMapWindowPoints (_pwinData^.hwndFrame,
                      HWND_DESKTOP, _pointl, 1);

              // Tell DIVE about the new settings.

              SetupBlitter.ulStructLen       := SizeOf(SETUP_BLITTER);
              SetupBlitter.fccSrcColorFormat := _pwinData^.fccColorFormat;
              SetupBlitter.ulSrcWidth        := _pwinData^.ulWidth;
              SetupBlitter.ulSrcHeight       := _pwinData^.ulHeight;
              SetupBlitter.ulSrcPosX         := 0;
              SetupBlitter.ulSrcPosY         := 0;
              SetupBlitter.fInvert           := ULONG(TRUE);  // ???
              SetupBlitter.ulDitherType      := 1;

              SetupBlitter.fccDstColorFormat := FOURCC_SCRN;
              SetupBlitter.ulDstWidth        := _swp.cx;
              SetupBlitter.ulDstHeight       := _swp.cy;
              SetupBlitter.lDstPosX          := 0;
              SetupBlitter.lDstPosY          := 0;
              SetupBlitter.lScreenPosX       := _pointl.x;
              SetupBlitter.lScreenPosY       := _pointl.y;
              SetupBlitter.ulNumDstRects     := rgnCtl.crcReturned;
              SetupBlitter.pVisDstRects      := @rcls;

              DiveSetupBlitter (_pwinData^._hDive, @SetupBlitter);

              ulFramesToTime := 4;
              ulNumFrames    := 1;
            end

            else

            begin
              DiveSetupBlitter (_pwinData^._hDive, nil);
            end;

            GpiDestroyRegion(_hps, _hrgn);
          end;

          WinReleasePS(_hps);
        end;
      end;

      WM_REALIZEPALETTE:
      begin
        /* This tells DIVE that the physical palette may have changed.
        */
        DiveSetDestinationPalette (_pwinData^._hDive, 0, 0, nil);
      end;

      WM_CLOSE:
      begin
         // Post to quit the dispatch message loop.

        WinPostMsg (_hwnd, WM_QUIT, 0, 0);
      end;

    else
      // Let PM handle this message.

      Result := WinDefWindowProc(_hwnd, msg, mp1, mp2);
      Exit;
    end; (* case *)
  end (* begin *)

  else

  begin
    // Let PM handle this message.

    Result := WinDefWindowProc (_hwnd, msg, mp1, mp2);
    Exit;
  end;

  Result := MRESULT(FALSE);
end;

/****************************************************************************
 *
 * Name          : MyDlgProc
 *
 * Description   : It is the dialog procedure of this program.
 *
 * Concepts      :
 *
 * Parameters    : Message parameter 1
 *                 Message parameter 2
 *
 * Return        : calling WinDefDlgProc
 *
 ****************************************************************************/

// MRESULT EXPENTRY MyDlgProc (HWND hwndDlg, ULONG msg, MPARAM mp1, MPARAM mp2)

function MyDlgProc(hwndDlg: HWND; msg: ULONG; mp1, mp2: MPARAM): MRESULT; CDECL;
var
  s: string;
begin
  case msg of
    WM_INITDLG:
    begin
      if (not DiveCaps.fScreenDirect) then
        WinSetDlgItemText(hwndDlg, ID_EF_11, 'NO')
      else
        WinSetDlgItemText(hwndDlg, ID_EF_11, 'YES');

      if (not DiveCaps.fBankSwitched) then
        WinSetDlgItemText(hwndDlg, ID_EF_12, 'NO')
      else
        WinSetDlgItemText(hwndDlg, ID_EF_12, 'YES');

      s := IntToStr(DiveCaps.ulDepth);
      WinSetDlgItemText(hwndDlg, ID_EF_13, s);

      s := IntToStr(DiveCaps.ulHorizontalResolution);
      WinSetDlgItemText(hwndDlg, ID_EF_14, s);

      s := IntToStr(DiveCaps.ulVerticalResolution);
      WinSetDlgItemText(hwndDlg, ID_EF_15, s);

      s := IntToStr(DiveCaps.ulScanLineBytes);
      WinSetDlgItemText(hwndDlg, ID_EF_16, s);

      case DiveCaps.fccColorEncoding of
        FOURCC_LUT8:
        begin
          WinSetDlgItemText(hwndDlg, ID_EF_17, '256');
        end;

        FOURCC_R565:
        begin
          WinSetDlgItemText(hwndDlg, ID_EF_17, '64K');
        end;

        FOURCC_R555:
        begin
          WinSetDlgItemText(hwndDlg, ID_EF_17, '32K');
        end;

        FOURCC_R664:
        begin
          WinSetDlgItemText(hwndDlg, ID_EF_17, '64K');
        end;

        FOURCC_RGB3,
        FOURCC_BGR3,
        FOURCC_RGB4,
        FOURCC_BGR4:
        begin
          WinSetDlgItemText(hwndDlg, ID_EF_17, '16M');
        end;

      else
        WinSetDlgItemText(hwndDlg, ID_EF_17, '???');
      end;                            /* endswitch */

      s := IntToStr(DiveCaps.ulApertureSize);
      WinSetDlgItemText(hwndDlg, ID_EF_18, s);

      s := IntToStr(DiveCaps.ulInputFormats);
      WinSetDlgItemText(hwndDlg, ID_EF_19, s);

      s := IntToStr(DiveCaps.ulOutputFormats);
      WinSetDlgItemText(hwndDlg, ID_EF_20, s);
    end;

    WM_COMMAND:
    begin
      case SHORT1FROMMP (mp1) of
        DID_OK:
        begin
          WinDismissDlg(hwndDlg, ULONG(TRUE));
        end;
      else
        Result := WinDefDlgProc (hwndDlg, msg, mp1, mp2);
        Exit;
      end;
    end
  else
    Result := WinDefDlgProc (hwndDlg, msg, mp1, mp2);
    Exit;
  end;
  Result := MPARAM(FALSE);
end;

/****************************************************************************
 *
 * Name          : Main
 *
 * Description   : This is main routine of this sample program.
 *
 * Concepts      :
 *
 * Parameters    : At command prompt, when the user start this EXE without
 *                 any parameters, like
 *                    DIVEDEMO
 *                 it shows 16 default bitmaps which has a sequence.
 *                 When the user specifies the names of bitmap file, like
 *                    DIVEDEMO XXXXXX.BMP YYYYYY.BMP
 *                 it shows the bitmaps specified at command line in turn.
 *
 * Return        : 1 - fail
 *                 0 - suceed
 *
 ****************************************************************************/

var
  tidBlitThread: TID;            /* Thread ID for DirectMemMove          */
  _hmq: HMQ;                     /* Message queue handle                 */
  _qmsg: QMSG;                   /* Message from message queue           */
  flCreate: ULONG;               /* Window creation control flags        */
  i: ULONG;                      /* Index for the files to open          */
  _pwinData: PWINDATA;           /* Pointer to window data               */
  pPal: PLONG;                   /* Pointer to system physical palette   */

  cxWindowPos: LONG;             /* X position of frame window           */
  cyWindowPos: LONG;             /* Y position of frmae window           */
  fn         : tFileName;

  szErrorBuf: array[0..255] of UCHAR; // GameSrvr
  hmodGameSrvr: HMODULE;              // GameSrvr
  pfnInitGameFrameProc: PFN;          // GameSrvr

begin
  // Initialize global variables
  FillChar(DiveCaps, SizeOf(DiveCaps), 0);
  FillChar(fccFormats, SizeOf(fccFormats), 0);

  bmpDir := goSysInfo.WDSibylInfo.Path+ '\Samples\dive\';

// Initialize the presentation manager, and create a message queue.
  _hab := WinInitialize (0);
  _hmq := WinCreateMsgQueue (_hab, 0);

// Allocate a buffer for the window data
  New(_pwinData);

// Get the screen capabilities, and if the system support only 16 colors
// the sample should be terminated.
  DiveCaps.pFormatData := @fccFormats;
  DiveCaps.ulFormatLength := 120;
  DiveCaps.ulStructLen := SizeOf(DIVE_CAPS);

  if (DiveQueryCaps (@DiveCaps, DIVE_BUFFER_SCREEN) <> 0) then
  begin
    WinMessageBox(HWND_DESKTOP, HWND_DESKTOP,
            'usage: The sample program can not run on this system environment.',
            'DIVEDEMO.EXE - DIVE Sample', 0, MB_OK or MB_INFORMATION);
    Dispose(_pwinData);
    WinDestroyMsgQueue(_hmq);
    WinTerminate(_hab);
    Halt(1);
  end;

  if (DiveCaps.ulDepth < 8) then
  begin
    WinMessageBox(HWND_DESKTOP, HWND_DESKTOP,
            'usage: The sample program can not run on this system environment.',
            'DIVEDEMO.EXE - DIVE Sample', 0, MB_OK or MB_INFORMATION);
    Dispose(_pwinData);
    WinDestroyMsgQueue(_hmq);
    WinTerminate(_hab);
    Halt(1);
  end;

// Get an instance of DIVE APIs.
  if (DiveOpen(_pwinData^._hDive, FALSE, nil) <> 0) then
  begin
    WinMessageBox(HWND_DESKTOP, HWND_DESKTOP,
            'usage: The sample program can not run on this system environment.',
            'DIVEDEMO.EXE - DIVE Sample', 0, MB_OK or MB_INFORMATION);
    Dispose(_pwinData);
    WinDestroyMsgQueue(_hmq);
    WinTerminate(_hab);
    Halt(1);
  end;

  // Read bitmap files

  // if (argc == 1)      // Default case
  begin
    // Read BMP file

    _pwinData^.ulMaxFiles := 0;
    for i := 0 to MAX_FILE - 1 do
    begin
      fn:=BmpDir+pszDefFile[i];
      if (ReadFile (i, fn, _pwinData) <> 0) then
      begin
        WinMessageBox(HWND_DESKTOP, HWND_DESKTOP,
                      'usage: DIVEDEMO failed to open bitmap file '+ pszDefFile[i],
                      'Error!', 0, MB_OK or MB_MOVEABLE);
        Halt(1);
      end
      else
      begin
        Inc(_pwinData^.ulMaxFiles);
      end;
    end;
  end;

  // Register a window class, and create a standard window.
  WinRegisterClass(_hab, pszMyWindow, @MyWindowProc, 0, SizeOf(ULONG));

  flCreate := FCF_TASKLIST | FCF_SYSMENU  | FCF_TITLEBAR | FCF_ICON |
  FCF_SIZEBORDER | FCF_MINMAX | FCF_MENU | FCF_SHELLPOSITION;

  _pwinData^.hwndFrame := WinCreateStdWindow(HWND_DESKTOP,
          WS_VISIBLE,
          flCreate,
          pszMyWindow,
          pszTitleText,
          WS_SYNCPAINT | WS_VISIBLE,
          0, ID_MAINWND,
          _pwinData^.hwndClient);

  WinSetWindowULong(_pwinData^.hwndClient, 0, ULONG(_pwinData));

  _pwinData^.cxWidthWindow  := _pwinData^.ulWidth +
                    goSysInfo.Screen.SizeBorderSize.CX * 2;
  _pwinData^.cyHeightWindow := _pwinData^.ulHeight +
                   (gosysinfo.screen.SizeBorderSize.CY * 2 +
                    goSysInfo.Screen.TitlebarSize +
                    goSysInfo.Screen.MenuSize);
  cxWindowPos:= (goSysInfo.Screen.Size.CX - _pwinData^.cxWidthWindow) div 2;
  cyWindowPos:= (goSysInfo.Screen.Size.CY - _pwinData^.cyHeightWindow) div 2;

// Set the window position and size.
  WinSetWindowPos (_pwinData^.hwndFrame,
          HWND_TOP,
          cxWindowPos, cyWindowPos,
          _pwinData^.cxWidthWindow, _pwinData^.cyHeightWindow,
          SWP_SIZE | SWP_MOVE | SWP_SHOW | SWP_ACTIVATE);

// Turn on visible region notification.
  WinSetVisibleRegionNotify(_pwinData^.hwndClient, TRUE);

// set the flag for the first time simulation of palette of bitmap data
  _pwinData^.fChgSrcPalette := FALSE;

// Send an invlaidation message to the client.
  WinPostMsg(_pwinData^.hwndFrame, WM_VRNENABLED, 0, 0);

// Start up the blitting thread.
  if (DosCreateThread(_pwinData^.tidBlitThread,
       @DirectMoveMem,
       _pwinData, 0, 8192) <> 0) then
  begin
    WinSetVisibleRegionNotify(_pwinData^.hwndClient, FALSE);

    for i := 0 to _pwinData^.ulMaxFiles - 1 do
    begin
      DiveFreeImageBuffer(_pwinData^._hDive, ulImage[i]);
    end;

    DiveClose(_pwinData^._hDive);
    WinDestroyWindow(_pwinData^.hwndFrame);
    Dispose(_pwinData);
    WinDestroyMsgQueue(_hmq);
    WinTerminate(_hab);
    Halt(1);
  end;

// Set the proiroty of the blitting thread
  DosSetPriority(PRTYS_THREAD, PRTYC_IDLETIME,
          0, _pwinData^.tidBlitThread);

// While there are still messages, dispatch them.
  while (WinGetMsg(_hab, _qmsg, 0, 0, 0)) do
  begin
    WinDispatchMsg(_hab, _qmsg);
  end;

// Set the variable to end the running thread, and wait for it to end.
  ulToEnd := 1;
  DosWaitThread(_pwinData^.tidBlitThread, DCWW_WAIT);

// Turn off visible region notificationm tidy up, and terminate.
  WinSetVisibleRegionNotify(_pwinData^.hwndClient, FALSE);

// Free the buffers allocated by DIVE and close DIVE
  for i := 0 to _pwinData^.ulMaxFiles - 1 do
  begin
    DiveFreeImageBuffer(_pwinData^._hDive, ulImage[i]);
  end;
  DiveClose(_pwinData^._hDive);

  if (_pwinData^.fccColorFormat = FOURCC_LUT8) then
  begin
    for i := 0 to _pwinData^.ulMaxFiles - 1 do
    begin
      DosFreeMem(pPalette[i]);
    end;
  end;

// Process termination
  WinDestroyWindow(_pwinData^.hwndFrame);
  Dispose(_pwinData);
  WinDestroyMsgQueue(_hmq);
  WinTerminate(_hab);
end.
          
{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Apr-07  WD         Programm Åberarbeitet.
}


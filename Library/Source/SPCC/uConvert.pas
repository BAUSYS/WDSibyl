Unit uConvert;

Interface

Uses SysUtils, uStream, uList, uString, Color;

//{$IFDEF OS2}
//Uses PMBitMap;
//{$ENDIF}

Const cCnvInchMeter = 0.0254;

type tIconTyp=(itUnknown, itOS2, itWin32);  // Icon Typ
     tBitmapTyp=(btUnknown, btBitmap,
                 btIconOS2, btIconWin32,
                 btPCXVer25, btPCXVer28mPal, btPCXVer28oPal, btPCXVer30,
                 btGIF87, btGIF89,
                 btMet);
     tBitmapInfo = record
                     BitmapTyp       : tBitmapTyp;
                     StreamSize      : LongInt;
                     TransparentColor: tColor;
                   End;

Function ConvertToBitmap(iStream : tStream; var iSize : LongInt;
             var iMemBuffer : Pointer; var iBitmapInfo : tBitmapInfo) : Boolean;
// Diese Funktion konvertiert ein Stream in ein Bitmap-Stream (OS/2 1.0)
// iStream .... Quell-Stream
// iSize ...... Laenge des Streams.
// iMemStream.. Ergebnis-Stream
// iBitmapInto. Div. Informationen zum Bitmap
// Result...... =true: Das Bitmap wurde korrekt konvertiert

Const
// Bitmaps
      BFT_BITMAP         =$4d42;   { 'BM', Bitmap }

// Icons
      BFT_COLORICON      =$4943;   { 'CI', Color-Icon }
      BFT_ICON           =$4349;   { 'IC', Icon }
      BFT_COLORPOINTER   =$5043;   { 'CP', Color-Pointer}
// IconTyp='BA' ????
      BFT_WINICON        =$0000;   { Windows-Icon }

// PCX-Formate
      BFT_PCX_V25        =$000A;   { PCX, Version 2.5  }
      BFT_PCX_V28mPal    =$020A;
      BFT_PCX_V28oPal    =$030A;
      BFT_PCX_V30        =$050A;   { PCX, Version 3.0  }

// GIF-Format
      BFT_GIF            =$4947;

Implementation

TYPE RGB = RECORD
             bBlue:BYTE;
             bGreen:BYTE;
             bRed:BYTE;
           END;
     RGB2 =RECORD
             bBlue:BYTE;
             bGreen:BYTE;
             bRed:BYTE;
             fcOptions:BYTE;  { Reserved, must be zero }
           END;

type tBMPLine = Array [0..MAXLONGINT] of RGB;
     pBMPLine = ^tBMPLine;

type pBMPHeader = ^tBMPHeader;
     tBMPHeader = Record
        bfType  : Word;      // = "BM"
        bfSize  : LongWord;
        Res1    : Word;      // reserviert (muss 0 sein)
        Res2    : Word;      // reserviert (muss 0 sein)
        bfOffset: LongWord;
     End;

     tBMPOS2HeaderInfo = Record
        bcSize  : LongWord;
        bcWidth : Word;
        bcHeight: Word;
        bcPlanes: Word;
        bcBitCnt: Word;
     End;
     tBMPWin32HeaderInfo = Record
        bcSize   : LongWord;
        bcWidth  : LongWord;
        bcHeight : LongWord;
        bcPlanes : Word;
        bcBitCnt : Word;
        biCompr  : LongWord;
        biSizeIm : LongWord;
        biXPels  : LongWord;
        biYPels  : LongWord;
        biClrUsed: LongWord;
        biClrImp : LongWord;
     End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: Icon-Convert Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

// ----------------------------------------------------------------------------
// File Struktur fuer Win32
// ----------------------------------------------------------------------------

type tWin32_IconHeader = Record
       Reserved1 : Word;                 // muss 0 sein
       ResTyp    : Word;                 // Resource Typ (1 fr Icons)
       IconCount : Word;

       icWidth   : Byte;                 // Icon Breite
       icHeight  : Byte;                 // Icon Hoehe
       ColorCount: Byte;                 // Anzahl der Farben
       Reserved2 : Byte;
       Planes    : Word;                 // Planes (Windows 3.1)
       Bits      : Word;                 // Bits in Icon-Bitmap
       icoDIBSize: LongWord;             // Groesse Pixelarray in Byte
       Offset    : LongWord;
       Reserved3 : Array[0..39] of Byte; // 40 Bytes unbekannt.
     End;



// ----------------------------------------------------------------------------
// File Struktur fuer OS/2
// ----------------------------------------------------------------------------

type tOS2_IconInfoHeader = Record
                             cbFix:ULONG;
                             cx:USHORT;
                             cy:USHORT;
                             cPlanes:USHORT;
                             cBitCount:USHORT;
                           End;

type tOS2_IconHeader = Record            // entspricht: BITMAPFILEHEADER;
                         usType:USHORT;
                         cbSize:ULONG;
                         xHotspot:SHORT;
                         yHotspot:SHORT;
                         offBits:ULONG;
                         bmp:  tOS2_IconInfoHeader
                       End;

// ----------------------------------------------------------------------------
// Konvertierungsfunktionen
// ----------------------------------------------------------------------------

Function ConvIconToOS2(iBitmapTyp : Word; iStream : tStream;
           iMemIcon : tMemoryStream; var iBitmapInfo : tBitmapInfo) : Boolean;

Var OS2_Header1   : tOS2_IconHeader;
    OS2_Header2   : tOS2_IconHeader;
    ClrCnt        : LongWord;
    Win32_Header  : tWin32_IconHeader;
    Win32_RGBQuad : Array[0..255] of RGB2;
    OS2_RGBTrible : Array[0..255] of RGB;
    Color_IconData: pByte; // Array[0..1024] of Byte;
    Color_IconSize: LongWord;

    OS2_IconData  : Array[0..255] of Byte;
    cou           : LongWord;
    IconTyp       : cString[2];

Const RGB_Black: RGB = (bBlue:$00; bGreen:$00; bRed:$00);
      RGB_White: RGB = (bBlue:$ff; bGreen:$ff; bRed:$ff);

Begin
  Result := false;

// Checken des Typs
  iStream.Position:=0;               // Wieder an die 1. Position gehen
  iStream.ReadBuffer(IconTyp,2);
  IconTyp[2]:=#0;
  iStream.Position:=0;               // Wieder an die 1. Position gehen
  if (iBitmapTyp in [BFT_COLORICON, BFT_ICON, BFT_COLORPOINTER]) or
     (IconTyp='BA')
    then   // Kann OS/2 verarbeiten  --> Kopieren der Daten
      Begin
        iMemIcon.CopyFrom(iStream, iStream.Size);
        iBitmapInfo.BitmapTyp:=btIconOS2;
      End

    else  // Win32-Icon
      Begin
// Loeschen der Variablen
        fillChar(OS2_Header1, Sizeof(tOS2_IconHeader), #0);
        fillChar(OS2_Header2, Sizeof(tOS2_IconHeader), #0);

// Lesen der Win32-Icon-Header Informationen
        iStream.ReadBuffer(Win32_Header, sizeof(tWin32_IconHeader));

// Win-Icon checken
        if (Win32_Header.Reserved1  <> 0) or
           (Win32_Header.ResTyp     <> 1)      // Resource-Typ: 1 ist Icons
          then exit;

        ClrCnt:=Win32_Header.ColorCount;
        Color_IconSize:=(Win32_Header.icWidth * Win32_Header.icHeight);
        case Win32_Header.ColorCount of
           0 : ClrCnt := 256;
           2 : Color_IconSize:=Color_IconSize shr 3;
          16 : Color_IconSize:=Color_IconSize shr 1;
         else exit;
        end;

// Farbtabellen einlesen
        iStream.Position:= $3E;
        iStream.ReadBuffer(Win32_RGBQuad, ClrCnt * sizeof(RGB2));

// Bytesequenze mit Color Bitmap (XOR) einlesen
        GetMem(Color_IconData, Color_IconSize);
        iStream.ReadBuffer(Color_IconData^, Color_IconSize);

// Befuellen der Header1-Informationen
        OS2_Header1.usType       := BFT_COLORICON;
        OS2_Header1.cbSize       := sizeof(tOS2_IconHeader);
        OS2_Header1.xHotspot     := $10;                        // Icon-Mitte
        OS2_Header1.yHotspot     := $10;                        // Icon-Mitte
        OS2_Header1.offBits      := sizeof(tOS2_IconHeader) +  // Header1
                                2 * sizeof(RGB) +           // Farben vom Monchrom-Icon
                                sizeof(tOS2_IconHeader) +  // Header2
                                clrCnt * sizeof(RGB);

        OS2_Header1.bmp.cbFix    := sizeof(tOS2_IconInfoHeader);
        OS2_Header1.bmp.cx       := $20;
        OS2_Header1.bmp.cy       := $40;
        OS2_Header1.bmp.cPlanes  := $01;                        // Zur Zeit immer 1
        OS2_Header1.bmp.cBitCount:= $01;                        // 1 Bit pro Pixel; Monochrom-Icon

// Header 2 befuellen
        OS2_Header2              := OS2_Header1;
        OS2_Header2.offBits      := OS2_Header1.offBits + $0100;    // Warum $0100 dazu, keine Ahnung ?
        OS2_Header2.bmp.cx       := Win32_Header.icWidth;
        OS2_Header2.bmp.cy       := Win32_Header.icHeight;
        case ClrCnt of
          2  : OS2_Header2.bmp.cBitCount:= 1;                   // S/W-Icon
          16 : OS2_Header2.bmp.cBitCount:= 4;                   // 16-Farben-Icon
          256: OS2_Header2.bmp.cBitCount:= 8;                   // 256-Farben-Icon
        End;

// Speichern der Daten
        iMemIcon.WriteBuffer(OS2_Header1, Sizeof(tOS2_IconHeader));
        iMemIcon.WriteBuffer(RGB_Black, Sizeof(RGB));
        iMemIcon.WriteBuffer(RGB_White, Sizeof(RGB));
        iMemIcon.WriteBuffer(OS2_Header2, Sizeof(tOS2_IconHeader));

// RGB Trible fuer das Icon
        for Cou:=0 to ClrCnt-1 do
          Begin
            OS2_RGBTrible[cou].bBlue := Win32_RGBQuad[cou].bBlue;
            OS2_RGBTrible[cou].bGreen:= Win32_RGBQuad[cou].bGreen;
            OS2_RGBTrible[cou].bRed  := Win32_RGBQuad[cou].bRed;
          end;
        iMemIcon.WriteBuffer(OS2_RGBTrible, ClrCnt * sizeof(RGB));

// Icon-Daten speichern
        FillChar(OS2_IconData, 256, #0);                   // Datenbereich loeschen
        iMemIcon.WriteBuffer(OS2_IconData, 256);            // Schreiben des Monochrom-Icon
        iMemIcon.WriteBuffer(Color_IconData^, Color_IconSize);  // Schreiben des Icons

// Speicher wieder freigeben
        FreeMem(Color_IconData, Color_IconSize);

        iBitmapInfo.BitmapTyp:=btIconWin32;
     End;    // Win-Icon konvertieren

// Positionen wieder setzen
  iMemIcon.Position:=0;
  iStream.Position:=0;
  Result:=true;

End;

function ConvIconToWin32(iBitmapTyp : Word; iStream : tStream;
           iMemIcon : tMemoryStream; var iBitmapInfo : tBitmapInfo) : Boolean;

var IconTyp       : cString[2];
//    OS2_Header1   : tOS2_IconHeader;
//    OS2_Header2   : tOS2_IconHeader;
//    Win32_Header  : tWin32_IconHeader;
//    Win32_RGBQuad : Array[0..255] of RGB2;
//    OS2_RGBTrible : Array[0..255] of RGB;
//    cou           : LongWord;

Begin
  Result := false;
// Checken des Typs
  iStream.Position:=0;               // Wieder an die 1. Position gehen
  iStream.ReadBuffer(IconTyp,2);
  IconTyp[2]:=#0;
  iStream.Position:=0;               // Wieder an die 1. Position gehen
/*
  if (IconTyp = 'IC') or (IconTyp='CI') // or (IconTyp='BA')
    then
      Begin
        Writeln('ConvIconOS2toWin32');

// Loeschen der Variablen
        fillChar(Win32_Header, Sizeof(tWin32_IconHeader), #0);
        fillChar(OS2_RGBTrible, Sizeof(OS2_RGBTrible), #0);

// S/W-Icon-Daten einlsen
        iStream.ReadBuffer(OS2_Header1, sizeof(tOS2_IconHeader));
        if OS2_Header1.bmp.cBitCount <> 1 then exit;     // kein gueltiges Format
        iStream.Position:=OS2_Header1.cbSize + 2 * sizeof(RGB);

// Icon-Header einlsen --> zu Win32-Icon konvertieren
        iStream.ReadBuffer(OS2_Header2, sizeof(tOS2_IconHeader));

// Befuellen der Header-Informationen
        Win32_Header.ResTyp   := 1;                  // Resource Typ (1 fr Icons)
        Win32_Header.IconCount:= 1;                  // Anzahl der Icons;
        Win32_Header.icWidth  := OS2_Header2.bmp.cx; // Icon Breite
        Win32_Header.icHeight := OS2_Header2.bmp.cy; // Icon Hoehe
        case OS2_Header2.bmp.cBitCount of            // Anzahl der Farben
          1 : Win32_Header.ColorCount:=2;            // S/W-Icon
          4 : Win32_Header.ColorCount:=16;           // 16-Farben-Icon
          8 : Win32_Header.ColorCount:=256;          // 256-Farben-Icon
        End;
        Win32_Header.icoDIBSize:=$02E8;              // Groesse Pixelarray in Byte
        Win32_Header.Offset    :=$FFff;

// Farbtabellen einlesen
        iStream.ReadBuffer(OS2_RGBTrible, OS2_Header2.bmp.cBitCount * sizeof(RGB));

// RGB Trible fuer das Icon
//        for Cou:=0 to Win32_Header.ColorCount-1 do
//          Begin
//            OS2_RGBTrible[cou].bBlue := Win32_RGBQuad[cou].bBlue;
//            OS2_RGBTrible[cou].bGreen:= Win32_RGBQuad[cou].bGreen;
//            OS2_RGBTrible[cou].bRed  := Win32_RGBQuad[cou].bRed;
//          end;




// Icon-Daten speichern
        iMemIcon.WriteBuffer(Win32_Header, Sizeof(tWin32_IconHeader));

        Result:=itOS2;
      End
    else   // Ist ein Win32-Icon --> Kopieren
      Begin */
        iMemIcon.CopyFrom(iStream, iStream.Size);
        iBitmapInfo.BitmapTyp:=btIconWin32;
/*      End; */

// Positionen wieder setzen
  iMemIcon.Position:=0;
  iStream.Position:=0;
  Result:=true;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: OS2-Bitmap Function                                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function BitmapReset(var BmpHeader : tBmpHeader; var BMPHeaderInfo : tBMPOS2HeaderInfo;
         W, H : LongWord) : LongWord;
// Loescht bzw. setzt die Bitmaps-Header-Informationen zurueck.

Begin
  FillChar(BMPHeader, sizeof(tBMPHeader), #0);
  FillChar(BMPHeaderInfo, sizeof(tBMPOS2HeaderInfo), #0);

// Bitmapgroesse berechnen.
  BMPHeaderInfo.bcWidth:=(int((W+3)/4)*4);
  Result:=H*BMPHeaderInfo.bcWidth*3 + sizeof(BMPHeader) + sizeof(BMPHeaderInfo);

// Bitmap-Header erstellen
  BMPHeader.bfType  := BFT_BITMAP;   // = "BM"
  BMPHeader.bfSize  := sizeof(tBMPHeader) + sizeof(tBMPOS2HeaderInfo);  // = $1A;
  BMPHeader.bfOffset:= sizeof(tBMPHeader) + sizeof(tBMPOS2HeaderInfo);  // = $1A;

  BMPHeaderInfo.bcSize  :=sizeof(tBMPOS2HeaderInfo);
  BMPHeaderInfo.bcHeight:=H+1;
  BMPHeaderInfo.bcPlanes:=1;
  BMPHeaderInfo.bcBitCnt:=$18;    // 24 Farben

End;


Function BitmapFromArray(iBMPHeaderInfo: tBMPOS2HeaderInfo;
                          iBMPBuffer   : tcArray2DFix;
                          iMemBitmap   : tMemoryStream;
                          W            : LongInt) : tColor;

Var CouX, CouY : LongInt;
    PixelLW    : LongWord;
    Pixel      : RGB absolute PixelLW;
    W32,WM1    : LongInt;

Begin
  W32:=iBMPHeaderInfo.bcWidth-1;
  WM1:=W-1;
  for CouY:= iBMPHeaderInfo.bcHeight downto 0 do
//  for CouY:= 0 to iBitmapInfo.bcHeight do
    Begin
// Farbdaten speichern
      for CouX:=0 to Wm1 do
        Begin
          PixelLW:=iBMPBuffer.Items[CouX, CouY];
          iMemBitmap.Write(Pixel, Sizeof(RGB));
        End;
// bis zu 32Bit-Grenze mit 0 Bits auffuellen
      PixelLW:=0;
      for CouX:=W to W32 do
        iMemBitmap.Write(Pixel, Sizeof(RGB));
    End;

// Transparent-Color herausfinden
  Result:=iBMPBuffer.Items[1, 1];

/* Logik von Toolbox
   iMemBitmap.Write(Farbe, Sizeof(RGB));
    Inc(x);
    // Bei Bedarf am rechten Bildrand auffuellen
    if (x = GIFImageDescriptor.Width) and
       (GIFImageDescriptor.Width mod 4 <> 0) then
      begin
        for i := 0 to 3 - GIFImageDescriptor.Width mod 4 do
          WritePixel(0);
        x := 0;
      end;
*/
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: Else-Convert Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function ConvElseToBitmap(iBitmapTyp : Word; iStream : tStream;
             iMemBitmap : tMemoryStream; var iBitmapInfo : tBitmapInfo) : Boolean;

Begin
  iBitmapInfo.BitmapTyp:=btBitmap;
  iMemBitmap.Capacity:=iBitMapInfo.StreamSize;
  iMemBitmap.CopyFrom(iStream,iBitMapInfo.StreamSize);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: PCX-Convert Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const cPCXSizeHeader   = 128;
      cPCXSizePaletten = 768;
      cPCXSizeBuffer   = 4096;
      cPCXunkodiert    = 0;
      cPCXkodiert      = 1;
      cPCXFarbe        = 1;
      cPCXGraustufen   = 2;

type tPCXHeader = Record
        ID, Version, Encoding, Bits : Byte;
        xMin, yMin, xMax, yMax, Hres, Vres : Word;
        Colors        : Array [0..15] of RGB;
        VMode, Planes : Byte;
        BytesPerLine, PaletteInfo : Word;
        Unused        : Array [0..57] of Byte;
     End;
     tPCXBuffer = Array[1..3, 0..cPCXSizeBuffer] of Byte;


Function ConvPCXtoBitmap(iBitmapTyp : Word; iStream : tStream;
             iMemBitmap : tMemoryStream; var iBitmapInfo : tBitmapInfo) : Boolean;
// Probleme: Groesse Bilder und Bild mittels WPS umgesetzt.

var PCXHeader    : tPCXHeader;        // Den Header auf die Adresse vom Buffer legen
    PCXBuffer    : tPCXBuffer;        // Zwischenbuffer fuer die einzelnen Farben
    BMPHeader    : tBMPHeader;
    BMPHeaderInfo: tBMPOS2HeaderInfo;
    BMPBuffer    : tcArray2DFix;

    CouY, CouX   : LongInt;
    PixelLW      : LongWord;
    Pixel        : RGB absolute PixelLW;
    W            : LongInt;
    H            : LongInt;

  Procedure ReadPlanes(Const Planes : Byte);
  { --------------------------------------------------------------------------------
    Beschreibung: Entnimmt dem Buffer mit Hilfe von der Funktion "PCXGetFileByte"
    die Daten und expandiert sie in den Klassen-Buffer "clPCXBuffer".
    -------------------------------------------------------------------------------- }

  Var Cou     : LongWord;
      PCXByte : Byte;
      CouBuf  : LongInt; { Byte; }

  Begin
    Cou:=0;
    While Cou<PCXHeader.BytesPerLine do
      Begin
        iStream.ReadBuffer(PCXByte,1);
        if (PCXByte and $C0) = $C0
          then
            Begin   // Die Daten sind komprimiert
              CouBuf:=Cou;
              Cou:=Cou + (PCXByte and $3F);
              iStream.ReadBuffer(PCXByte,1);
              Repeat
                PCXBuffer[Planes, CouBuf]:=PCXByte;
                inc(CouBuf);
              Until CouBuf=Cou;
            End
          else      // Unkomprimiert
            Begin
              PCXBuffer[Planes, Cou]:=PCXByte;
              inc(Cou);
            End;
      End;
  End;


Begin
  Result := false;
  iStream.ReadBuffer(PCXHeader, sizeof(tPCXHeader));

  if (PCXHeader.Encoding <> cPCXkodiert) or
     (PCXHeader.PaletteInfo <> cPCXFarbe) then exit;   // Falsches Format

  iBitmapInfo.BitmapTyp:=btPCXVer30;

// Breite und Hoehe ermitteln
  W:=PCXHeader.xMax - PCXHeader.xMin+1;
  H:=PCXHeader.yMax - PCXHeader.yMin;

  iMemBitmap.Capacity:=BitmapReset(BmpHeader, BMPHeaderInfo,W,H);

// Schreiben der Daten
  iMemBitmap.WriteBuffer(BMPHeader, sizeof(tBmpHeader));
  iMemBitmap.WriteBuffer(BMPHeaderInfo, sizeof(tBmpOS2HeaderInfo));

// BmpBuffer anlegen
  BMPBuffer.Create(BMPHeaderInfo.bcWidth, BMPHeaderInfo.bcHeight, 0);

// BildDaten schreiben
  dec(H);

  for CouY:=0 to H do
    Begin
      ReadPlanes(1);   { fuer Rot }
      ReadPlanes(2);   { fuer Gruen }
      ReadPlanes(3);   { fuer Blau }
      For CouX:=0 to PCXHeader.BytesPerLine do
        Begin
          Pixel.bRed  := PCXBuffer[1, CouX];
          Pixel.bGreen:= PCXBuffer[2, CouX];
          Pixel.bBlue := PCXBuffer[3, CouX];
          BMPBuffer.Items[CouX, CouY]:=PixelLW;
        End;
    end;

// Das Array in den Bitmap-Stream uebertragen
  iBitmapInfo.TransparentColor:=
        BitmapFromArray(BmpHeaderInfo, BMPBuffer,iMemBitmap, W);

// Loeschen des Arrays
  BMPBuffer.Destroy;
  Result := true;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This Section: GIF-Convert Implementation                                  บ
บ From Toolbox: 1997-S1                                                     บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

type tGIFHeader =  Record
       Signatur : tChr2;  // Signatur "GIF"
       Version  : tChr2;  // Version "87a" oder "89a"
     End;

     tGifLogicalScreen = Record
       Width, Height: SmallInt; // Breite und Hoehe des Bildes
       Resolution   : Byte;     // 0-2: Bits per Pixel, 3: Sortierung, 4-6: Farbaufl๖sung, 7: Globale Farbtabelle
       BkgndColor   : Byte;     // Hintergrundfarbe
       AspectRation : Byte;     // Pixel Aspect Ration
     end;

     tGifImageDescriptor = packed record
       Header       : Char;     // Image Separator Header (=";")
       Left, Top    : Word;     // Koordinate linker/oberer Rand
       Width, Height: Word;     // Breite/Hoehe
       Flags        : Byte;     // Flag
     end;

     tGifPalette = array[0..255] of record
       Red, Green, Blue: Byte;
     end;

     pGifLZWTable = ^tGifLZWTable;           // Zeiger auf Tabelle
     tGifLZWTable = array[0..4095] of Word;  // Die Tabelle
     pGIFStack    = ^tGIFStack;
     tGIFStack    = array[0..1280] of Byte;

Function ConvGIFtoBitmap(iBitmapTyp : Word; iStream : tStream;
             iMemBitmap : tMemoryStream; var iBitmapInfo : tBitmapInfo) : Boolean;

Var GIFHeader            : tGIFHeader;
    GIFLogicalScreen     : tGifLogicalScreen;
    GIFImageDescriptor   : tGIFImageDescriptor;
    GIFBitsPerPixel      : LongWord;  // Maximalwert 8
    GIFPaletteSize       : LongWord;
    GIFPalette           : TGifPalette;   // Die Lokale Palette ueberschreibt die Globale
    GIFTail, GIFPrefix   : pGIFLZWTable;
    GIFStack             : pGIFStack;
    GIFCodeSize          : Byte;
    GIFStartCodeSize     : Byte;
    GIFBufferSize        : Integer;
    GIFSrcByte           : Integer;
    GIFSrcBit            : Byte; //Bitposition im aktuellen Byte
    GIFBlockBuffer       : array[0..260] of Char;
    GIFCode, GIFInCode, x: Word;
    GIFExtra, GIFPrevCode: Word;
    GIFClearCode         : Word; // Code fuer Initialisierung der Tabelle
    GIFEoiCode           : Word; // Code fuer Ende der Datei
    GIFMaxCode           : Word; // Hoechster Code bei aktueller CodeSize
    GIFNextTableIndex    : Word; // Naechster zu vergebender Code
    GIFStackPos, i       : Integer;

    BMPHeader    : tBMPHeader;
    BMPHeaderInfo: tBMPOS2HeaderInfo;
    BMPBuffer    : tcArray2DFix;

    PixelLW      : LongWord;
    Pixel        : RGB absolute PixelLW;
    CouX, CouY   : LongWord;

  function GetNextCode: Word;
// Holt die naechsten <CodeSize> Bit aus der GIF-Datei2

  var Buffer: LongInt;
      BlockSize: Byte;
      sh : LongWord;

  begin
    if GIFSrcByte + (GIFSrcBit+GIFCodeSize) div 8 >= GIFBufferSize then
      begin
        // Nachladen, Stream muss auf dem Feld fuer Bytezahl stehen
        Move(GIFBlockBuffer[GIFSrcByte], GIFBlockBuffer[0], GIFBufferSize-GIFSrcByte);
        iStream.Read(BlockSize, sizeof(BlockSize));
        iStream.Read(GIFBlockBuffer[GIFBufferSize-GIFSrcByte], BlockSize);
        GIFBufferSize := GIFBufferSize-GIFSrcByte + BlockSize;
        GIFSrcByte := 0;
      end;
    Move(GIFBlockBuffer[GIFSrcByte], Buffer, 4);
    sh:=32-GIFSrcBit-GIFCodeSize;
    Buffer := Buffer shl (32-GIFSrcBit-GIFCodeSize);
    Buffer := Buffer shr (32-GIFCodeSize);
    Inc(GIFSrcByte, (GIFSrcBit+GIFCodeSize) div 8);
    GIFSrcBit := (GIFSrcBit+GIFCodeSize) mod 8;
    Result := lo(Buffer);
// Writeln('GetNextCode:',Result,' (',GifSrcByte,',',GifSrcBit,')');
//Readln;
  end;

  Procedure WritePixel(b: Byte);
// Schreibt einen Bildpunkt in die Bitmap

  begin
    Pixel.bBlue :=GIFPalette[b].Blue;
    Pixel.bGreen:=GIFPalette[b].Green;
    Pixel.bRed  :=GIFPalette[b].Red;
    BMPBuffer.Items[CouX, CouY]:=PixelLW;
    inc(CouX);
    if CouX = GIFImageDescriptor.Width then
      Begin
        CouX:=0;
        inc(CouY);
      End;
  end;

Begin
  Result:=false;
// Variablen loeschen
// Header einlesen
  iStream.ReadBuffer(GIFHeader, sizeof(tGIFHeader));

// Signatur checken; GI ist schon vorher ueberprueft worden
  if (GIFHeader.Signatur[2] <> 'F') then exit;

// Nur die Version 87a und 89a aktzeptieren
  if (GIFHeader.Version[0] <> '8') or
     (GIFHeader.Version[2] <> 'a') then exit;

  case GIFHeader.Version[1] of
    '7' : Begin
            iBitmapInfo.BitmapTyp:=btGIF87;
          End;
    '9' : Begin
            iBitmapInfo.BitmapTyp:=btGIF89;
          End;
    else exit;
  end;

// Logical Screen Descriptor Block einlesen und verarbeiten
  iStream.ReadBuffer(GIFLogicalScreen, sizeof(tGIFLogicalScreen));
// falls das 7 Bit des Resolution Flags gesetzt ist, wird die
// globale Farbtabelle eingelesen.
   FillChar(GIFPalette, sizeof(TGifPalette), #0);
  if GIFLogicalScreen.Resolution and $80 <> 0 then
    Begin
// in dem Bit 0 - 2 steht die Zahl der Bits pro Pixel.
      GIFBitsPerPixel:= (GIFLogicalScreen.Resolution and $7) + 1;
      GIFPaletteSize := 3*(1 shl GIFBitsPerPixel);
// lesen der globalen Palette einlesen
      iStream.Read(GIFPalette, GIFPaletteSize);
    End;
// Image Descriptor Block lesen
  iStream.Read(GIFImageDescriptor, sizeof(tGIFImageDescriptor));
  if GIFImageDescriptor.Flags and $80 <> 0 then
    begin
      // Lokale Farbtabelle lesen
      FillChar(GIFPalette, sizeof(TGifPalette), #0);
      GIFBitsPerPixel:= (GIFImageDescriptor.Flags and $7) + 1;
      GIFPaletteSize := 3*(1 shl GIFBitsPerPixel);
// Lesen der Lokale Palette und ueberschreibt die Globale Palette
      iStream.Read(GIFPalette, GIFPaletteSize);
    end;

// TransparentColor herausfinden.
  Pixel.bBlue :=GIFPalette[GIFLogicalScreen.BkgndColor].Blue;
  Pixel.bGreen:=GIFPalette[GIFLogicalScreen.BkgndColor].Green;
  Pixel.bRed  :=GIFPalette[GIFLogicalScreen.BkgndColor].Red;
  iBitmapInfo.TransparentColor:=PixelLW;

// Bitmap erstellen
  iMemBitmap.Capacity:=BitmapReset(BmpHeader, BMPHeaderInfo,
     GIFImageDescriptor.Width, GIFImageDescriptor.Height);
  iMemBitmap.WriteBuffer(BMPHeader, sizeof(tBmpHeader));
  iMemBitmap.WriteBuffer(BMPHeaderInfo, sizeof(tBmpOS2HeaderInfo));

// BmpBuffer anlegen
  BMPBuffer.Create(BMPHeaderInfo.bcWidth, BMPHeaderInfo.bcHeight, 0);

// Lesen des Code-Size von dem Raster Data-Block
  iStream.Read(GIFStartCodeSize, 1);
  inc(GIFStartCodeSize);

// Ab hier das tatsaechliche konvertieren der Bilddaten.
  New(GIFTail);
  New(GIFPrefix);
  New(GIFStack);
  X:=0;
  CouX:=0;
  CouY:=0;
  GIFBufferSize := 0;
  GIFSrcByte := 0;
  GIFSrcBit := 0;
  GIFCodeSize := GIFStartCodeSize;
  GIFClearCode:= 1 shl (GIFCodeSize-1);
  GIFEoiCode  := GIFClearCode + 1;
  GIFMaxCode  := (1 shl GIFCodeSize) - 1;
  GIFNextTableIndex := GIFEoiCode + 1;
  GIFStackPos := 0;
  GIFCode := GetNextCode;
  while GIFCode <> GIFEoiCode do
    begin
      if GIFCode = GIFClearCode
        then
          begin // Tabelle zuruecksetzen
            GIFCodeSize := GIFStartCodeSize;
            GIFMaxCode := (1 shl GIFCodeSize) - 1;
            GIFNextTableIndex := GIFEoiCode + 1;
            // Fuer Codes unter ClearCode sind Code und Palettenindex identisch
            GIFCode := GetNextCode;
            if GIFCode >= GIFClearCode then Writeln('Code >= ClearByte');
            WritePixel(GIFCode);
            GIFExtra := GIFCode;
            GIFPrevCode := GIFCode;
          end
        else
          Begin
            GIFInCode := GIFCode;
            if GIFCode >= GIFNextTableIndex then
              begin
// Code ist noch nicht definiert und wird in die Tabelle aufgenommen
                GIFCode := GIFPrevCode;
                GIFStack^[GIFStackPos] := GIFExtra;
                Inc(GIFStackPos);
              end;
// Sequenz aufbauen
            while GIFCode >= GIFClearCode do
              begin
                GIFStack^[GIFStackPos] := GIFTail^[GIFCode];
                Inc(GIFStackPos);
                GIFCode := GIFPrefix^[GIFCode];
              end;
            GIFStack^[GIFStackPos] := GIFCode;
            GIFExtra := GIFCode;
            Inc(GIFStackPos);
            // Sequenz schreiben
            for i := GIFStackPos - 1 downto 0 do
              WritePixel(GIFStack^[i]);
            GIFStackPos := 0;   // Stack leeren
// Neue Sequenz anlegen, Code ist jetzt < ClearCode und damit identisch mit
// dem zugehoerigen Palettenindex
            GIFPrefix^[GIFNextTableIndex]:= GIFPrevCode;
            GIFTail^[GIFNextTableIndex]  := GIFCode;
            Inc(GIFNextTableIndex);
            GIFPrevCode := GIFInCode;
            if (GIFNextTableIndex > GIFMaxCode) and
               (GIFCodeSize < 12) then
              begin
                Inc(GIFCodesize);
                GIFMaxCode := 1 shl GIFCodesize - 1;
            end;
          end;
      GIFCode := GetNextCode;
    End;
  Dispose(GIFTail);
  Dispose(GIFPrefix);
  Dispose(GIFStack);

// Das Array in den Bitmap-Stream uebertragen
  BitmapFromArray(BMPHeaderInfo, BMPBuffer,iMemBitmap, GIFImageDescriptor.Width);

// Loeschen des Arrays
  BMPBuffer.Destroy;
  Result:=true;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This Section: Global Convert Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function ConvOS2Bmp2Win32Bmp(iStream : tMemorystream; var iMemStream : tMemorystream) : Boolean;

var BMPHeader         : tBMPHeader;
    BMPOS2HeaderInfo  : tBMPOS2HeaderInfo;
    BMPWin32HeaderInfo: tBMPWin32HeaderInfo;
    BA                : PByteArray;

Const StartPic =sizeof(tBMPHeader)+Sizeof(tBMPOS2HeaderInfo);

Begin
  iMemStream:=nil;
  fillChar(BMPWin32HeaderInfo, sizeof(tBMPWin32HeaderInfo), #0);
  iStream.ReadBuffer(BMPHeader,sizeof(tBMPHeader));
  iStream.ReadBuffer(BMPOS2HeaderInfo,sizeof(tBMPOS2HeaderInfo));
  if (BMPOS2HeaderInfo.bcSize=Sizeof(tBMPOS2HeaderInfo)) and
     (BMPOS2HeaderInfo.bcBitCnt=24) then
    Begin
      iMemStream.Create;
      iMemStream.WriteBuffer(BMPHeader,sizeof(tBMPHeader));
      BMPWin32HeaderInfo.bcSize   := sizeOf(tBMPWin32HeaderInfo);
      BMPWin32HeaderInfo.bcWidth  := BMPOS2HeaderInfo.bcWidth;
      BMPWin32HeaderInfo.bcHeight := BMPOS2HeaderInfo.bcHeight;
      BMPWin32HeaderInfo.bcPlanes := BMPOS2HeaderInfo.bcPlanes;
      BMPWin32HeaderInfo.bcBitCnt := BMPOS2HeaderInfo.bcBitCnt;

      iMemStream.WriteBuffer(BMPWin32HeaderInfo, SizeOf(tBMPWin32HeaderInfo));
      BA:=iStream.Memory;
      BA:=@BA^[StartPic];
      iMemStream.WriteBuffer(BA^,iStream.Size-StartPic);
      iStream.Destroy;
    End
  else
    Begin
      iMemStream:=iStream;
      exit;   // Die BMP-Datei ist eine Windows-BMP
    End;

End;

Function ConvertToBitmap(iStream : tStream; var iSize : LongInt;
             var iMemBuffer : Pointer; var iBitmapInfo : tBitmapInfo) : Boolean;

Var BitmapTyp : Word;
    MemStream : tMemoryStream;
    BA        : PByteArray;
    IconTyp   : tIconTyp;

Begin
  Result:=false;
  fillChar(iBitmapInfo, sizeof(tBitmapInfo), #0);
  iBitmapInfo.TransparentColor:=clTCNotDefined;
  iStream.Position:=0;               // Wieder an die 1. Position gehen
  iStream.ReadBuffer(BitmapTyp,2);
  iStream.Position:=0;
  iBitmapInfo.StreamSize:=iStream.Size;
  MemStream.Create;  // Memory-Objekt erstellen
  Result:=true;
  case BitmapTyp of
    BFT_WINICON, BFT_COLORICON, BFT_ICON, BFT_COLORPOINTER:
      Begin
        {$IFDEF OS2}
        ConvIconToOS2(BitmapTyp, iStream, MemStream, iBitmapInfo);
        {$ENDIF}
        {$IFDEF Win32}
        ConvIconToWin32(BitmapTyp, iStream, MemStream, iBitmapInfo);
        {$ENDIF}
      End;
    BFT_PCX_V30:
       ConvPCXtoBitmap(BitmapTyp, iStream, MemStream, iBitmapInfo);
    BFT_GIF:
       ConvGIFtoBitmap(BitmapTyp, iStream, MemStream, iBitmapInfo);
    else
       ConvElseToBitmap(BitmapTyp, iStream, MemStream, iBitmapInfo);
  end;

// Bei OS/2 einfach das Bild durchreichen
{$IFDEF OS2}
  iSize:=MemStream.Size;
  BA:=MemStream.Memory;
  GetMem(iMemBuffer, iSize);
  move(BA^, iMemBuffer^, iSize);
  MemStream.Destroy;
{$ENDIF}

// Bei Win32 das Bild auch weiterleiten, aber BMPs in Win32-BMP umwandeln
{$IFDEF Win32}
  MemStream.Position:=0;               // Wieder an die 1. Position gehen
  MemStream.ReadBuffer(BitmapTyp,2);
  MemStream.Position:=0;
  if BitmapTyp=BFT_BITMAP then
    Begin    // Bitmaps in Windows-BMP umwandeln
      ConvOS2Bmp2Win32Bmp(MemStream, MemStream);
    End;
  iSize:=MemStream.Size;
  BA:=MemStream.Memory;
  GetMem(iMemBuffer, iSize);
  move(BA^, iMemBuffer^, iSize);
  MemStream.Destroy;
{$ENDIF}
End;


Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  01-Dec-05  WD         Einbau der Unit
  27-Dec-06  WD         Einbau vom dem PCX, GIF-Format und Strukturaenderung.
  10-Jun-07  WD         Weiter Strukturaenderungen
}

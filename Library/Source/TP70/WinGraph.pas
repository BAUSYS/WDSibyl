Unit WinGraph;

Interface
   
Uses Color, Classes, Graphics, Forms, SysUtils;
               
{$IFDEF OS2}
Uses PMBitMap;
{$ENDIF}

{ Fehlermeldungen }
const MaxColors       = 15;
      grOk            = 0;      { No error; Fehlerfreie AusfÅhrung }
      grNoInitGraph   = -1;      { BGI graphics not installed; Grafiktreiber (.BGI) nicht geladen }
      grNotDetected   = -2;      { Graphics hardware not detected; Kein grafikfÑhiger Adapter vorhanden }
      grFileNotFound  = -3;      { Device driver file not found; Grafiktreiber-Datei nicht gefunden }
      grInvalidDriver = -4;      { Invalid device driver file; Grafiktreiber-Programm defekt }
      grNoLoadMem     = -5;      { Not enough memory to load driver; Nicht genug Platz im Hauptspeicher fÅr den Grafiktreiber }
      grNoScanMem     = -6;      { Out of memory in scan fill; Nicht genug Speicher (Bar, FillPoly, PieSlice, Sector) }
      grNoFloodMem    = -7;      { Out of memory in flood fill; Nicht genug Speicher (FloodFill) }
      grFontNotFound  = -8;      { Font file not found; Schrift-Datei nicht gefunden }
      grNoFontMem     = -8;      { Not enough memory to load font; Nicht genug Platz im Speicher fÅr die Schrift }
      grInvalidMode   = -9;      { Invalid graphics mode for selected driver; Grafikmodus wird vom Treiber nicht unterstÅtzt }
      grError         =-10;      { Graphics error  (generic error); Nicht nÑher klassifizierbarer Fehler }
      grIOerror       =-11;      { Graphics I/O error; Ein-/Ausgabefehler beim Laden von Dateien }
      grInvalidFont   =-12;      { Invalid font file; Schrift-Datei ungÅltig }
      grInvalidFontNum=-13;      { Invalid font number; Kennziffer fÅr Zeichensatz nicht definiert }

{ Vorder- / Hintergrundfarben }
Const Black        = 0;
      Blue         = 1;
      Green        = 2;
      Cyan         = 3;
      Red          = 4;
      Magenta      = 5;
      Brown        = 6;
      LightGray    = 7;
      DarkGray     = 8;
      LightBlue    = 9;
      LightGreen   = 10;
      LightCyan    = 11;
      LightRed     = 12;
      LightMagenta = 13;
      Yellow       = 14;
      White        = 15;

{ Garfiktreiber }
const maxGraphDriver  = 10;
      maxGraphMode    = 5;
      CurrentDriver   = -128;
      Detect          =  0;
      CGA             =  1;
      MCGA            =  2;
      EGA             =  3;
      EGA64           =  4;
      EGAMono         =  5;
      IBM8514         =  6;
      HercMono        =  7;
      ATT400          =  8;
      VGA             =  9;
      PC3270          = 10;

{ Mîgliche Grafikmodi der Treiber }
const CGAC0          = 0; { 320 x 200 }
      CGAC           = 1; { 320 x 200 }
      CGAC2          = 2; { 320 x 200 }
      CGAC3          = 3; { 320 x 200 }
      CGAHi          = 4; { 640 x 200 }

      MCGAC0         = 0; { 320 x 200 }
      MCGAC1         = 1; { 320 x 200 }
      MCGAC2         = 2; { 320 x 200 }
      MCGAC3         = 3; { 320 x 200 }
      MCGAMed        = 4; { 640 x 200 }
      MCGAHi         = 5; { 640 x 480 }

      EGAMonoHi      = 3; { 640 x 350 }
      HercMonoHi     = 0; { 720 x 348 }

      VGALo          = 0; { 640 x 200 }
      VGAMed         = 1; { 640 x 350 }

      EGALo          = 0; { 640 x 200 }
      EGAHi          = 1; { 640 x 350 }

      EGA64Lo        = 0; { 640 x 200 }
      EGA64Hi        = 1; { 640 x 350 }

      ATT400C0       = 0; { 320 x 200 }
      ATT400C1       = 1; { 320 x 200 }
      ATT400C2       = 2; { 320 x 200 }
      ATT400C3       = 3; { 320 x 200 }
      ATT400Med      = 4; { 640 x 200 }
      ATT400Hi       = 5; { 640 x 400 }

      IBM8514Lo      = 0; { 640 x 480 }
      IBM8514Hi      = 1; { 1024 x 768 }

      PC3270Hi       = 0; { 720 x 350 }
      VGAHi          = 2; { 640 x 480 }

type ArcCoordsType = record
       x,y        : Integer;
       xs,ys,
       xEnd, yEnd : Word;
     End;

     PointType = Record
       x,y : Integer;
     End;

     FillPatternType = array[0..7] of byte;

     FillsettingsType = Record
       Patter, Color : Word;
     End;

     TextSettingsType = record
       Font      : Word;
       Direction : Word;
       CharSize  : Word;
       Horiz     : Word;
       Vert      : Word;
     End;

     LineSettingsType = Record
       Font, Direction,
       CharSize,
       Horiz, Vert : Word;
     End;

     PaletteType = record
       Size    : Byte;
       Colors  : array[0..MaxColors] of Shortint;
     end;

     ViewPortType = record
       x1, y1, x2, y2 : integer;
       Clip           : Boolean;
     end;


Procedure Bar(x1,y1,x2,y2 : integer);
Procedure Bar3D(x1,y1,x2,y2 : integer; Depth : Word; Top : Boolean);
Procedure Circle(x,y : Integer; Radius: Word);
Procedure ClearDevice;
Procedure ClearViewport;
Procedure CloseGraph;
Procedure DetectGraph(var GraphDriver, GraphMode : Integer);
Procedure DrawPoly(Numpoints: Word; var Polypoints);
Procedure Ellipse(x,y: Integer; stAngle, EndAngle: Word; XRadius, YRadius :word);
Procedure FillEllipse(x,y: Integer; XRadius, YRadius :word);
Procedure FillPoly(NumPoints: Word; var PolyPoints);
Procedure FloodFill(x,y, Border: Word);
Procedure GetArcCodes(var ArcCoords:ArcCoordsType);
Procedure GetAspectRatio(var Xasp, Yasp : Word);
Function  GetBkColor : Word;
Function  GetColor : Word;
Procedure GetDefaultPalette(var pal : Palettetype);
Procedure GetFillSettings(var FillInfo :  FillsettingsType);
Function  GetGraphMode : Integer;
Procedure GetImage(x1, y1, x2, y2: Integer; var BitMap);
Procedure GetLineSettings(var LineInfo: LineSettingsType);
Function  GetMaxMode : Integer;
Function  GetMaxX : Integer;
Function  GetMaxY : Integer;
Function  GetModeName(ModeNumber : Integer) : String;
Procedure GetPalette(var Palette : PaletteType);
Function  GetPaletteSize : Integer;
Function  GetPixel(x,y : Integer): Word;
Procedure GetTextSettings(var TextInfo : TextSettingsType);
Procedure GetViewSettings(var ViewPort: ViewPortType);
Function  GetX: Integer;
Function  GetY: Integer;
Function  GraphErrorMsg(ErrorCode: Integer): string;
Function  GraphResult: Integer;
Function  ImageSize(x1, y1, x2, y2: Integer): Word;
Procedure InitGraph(var GraphDriver:Integer; var GraphMode: Integer; PathToDriver: string);
Procedure Line(x1,y1,x2,y2 : Integer);
Procedure LineRel(Dx,Dy : Integer);
Procedure LineTo(x,y : Integer);
Procedure MoveRel(Dx,Dy : Integer);
Procedure MoveTo(x,y : Integer);
Procedure OutText(Textstring : String);
Procedure OutTextXY(x,y : Integer; Textstrinf : String);
Procedure PieSlice(x,y: Integer; stAngle, EndAngle, Radius: Word);
Procedure PutImage(X, Y: Integer; var BitMap; BitBlt: Word);
Procedure Rectangle(x1, y1, x2, y2: Integer);
Procedure Sector(x, y: Integer; StAngle,EndAngle, XRadius, YRadius: Word);
Procedure SetActivePage(Page: Word);
Procedure SetAllPalette(var Palette);
Procedure SetBkColor(ColorNum: Byte);
Procedure SetColor(Color: Byte);
Procedure SetFillPattern(Pattern: FillPatternType; Color: Word);
Procedure SetFillStyle(Pattern: Word; Color: Word);
Procedure SetGraphMode(Mode: Integer);
Procedure SetPalette(ColorNum: Word; Color: Byte);
Procedure SetRGBPalette(ColorNum, RedValue, GreenValue, BlueValue: Word);
Procedure SetTextBuf(var F: Text; var Buf; Size:Word);
Procedure SetTextJustify(Horiz, Vert: Word);
procedure SetUserCharSize(MultX, DivX, MultY, DivY: Word);
procedure SetViewPort(x1, y1, x2, y2: Integer; Clip: Boolean);
procedure SetVisualPage(Page: Word);
procedure SetWriteMode(WriteMode: Integer);
function  TextHeight(TextString: string): Word;
function  TextWidth(TextString: string): Word;


{ Eigene Funktionen }
Procedure SetDrawOnForm(iValue : Boolean);

Implementation

Type tWndSize    = Array[1..2] of Word;
     tWndVGASize = Array[0..maxGraphMode] of tWndSize;

     tPolyPoints = Array[0..maxLongInt] of PointType;


Const WndSize : Array[1..maxGraphDriver] of tWndVGASize =
       (((320,200),(320,200),(320,200),(320,200),(640,200),(0,0)),     { CGA }
        ((0,0),(0,0),(640,350),(0,0),(0,0),(0,0)),                     { MCGA }
        ((640,200),(640,350),(0,0),(0,0),(0,0),(0,0)),                 { EGA }
        ((640,200),(640,350),(0,0),(0,0),(0,0),(0,0)),                 { EGA64 }
        ((0,0),(0,0),(640,350),(0,0),(0,0),(0,0)),                     { EGAMONO }
        ((640,480),(1024,768),(0,0),(0,0),(0,0),(0,0)),                { IBM8514 }
        ((720,348),(0,0),(0,0),(0,0),(0,0),(0,0)),                     { HercMono}
        ((320,200),(320,200),(320,200),(320,200),(640,200),(640,400)), { ATT400 }
        ((640,200),(640,350),(640,480),(0,0),(0,0),(0,0)),             { VGA}
        ((720,350),(0,0),(0,0),(0,0),(0,0),(0,0)));                    { PC3270 }

Const MaxX = 1024;
      MaxY = 768;

type tWinGraph = Class (TForm)
       Private
         fBitmap     : tBitmap;
         fFillBitmap : tBitmap;
         fDrawOnForm : Boolean;
         fBkColor    : tColor;
         Procedure SetDrawOnForm(iValue : Boolean);
         Procedure SetBkColor(iColor : tColor);
         Function bezY(Y : LongInt) : LongInt;

       Public
         Constructor Create(W, H : LongInt); Virtual;
         Destructor Destroy; Override;
         Procedure CopyToCanvas(x1,y1,x2,y2 : LongInt);Virtual;
         Procedure Show;Virtual;
         Procedure setFillPattern(iPattern : FillPatternType; iColor : tColor);

         Property Bitmap : tBitmap Read fBitmap;


       Protected
         Procedure Paint(Const rec:TRect); Override;
         Property DrawOnForm : Boolean Read fDrawOnForm Write SetDrawOnForm;
         Property BkColor    : tColor  Read fBkColor    Write SetBkColor;
     End;

Var WinGraph   : tWinGraph;


Procedure tWinGraph.SetFillPattern(iPattern : FillPatternType; iColor : tColor);

Var X,Y  : Byte;
    Wert : Byte;

Begin
{ Writeln('BkCol:',fBkColor, ',', iColor); }
  for Y:=0 to 7 do
    Begin
      Wert:=1;
      For X:=0 to 7 do
        Begin
          if (iPattern[Y] and Wert = Wert)
            then fFillBitmap.Canvas.Pixels[X,Y] := iColor
            else ffillbitmap.Canvas.Pixels[X,Y] := fBkColor;
          Wert:=Wert shl 1;
        End;
    End;
{  fBitmap.Canvas.Brush.Bitmap:=fFillBitmap;
  fBitmap.Canvas.filledCircle(400,400,50); }
End;

Procedure tWinGraph.SetBkColor(iColor : tColor);

Var rec : TRect;

Begin
  Rec.Left:=0;
  Rec.Bottom:=0;
  Rec.Right:=Width;
  Rec.Top:=Height;
  fBkColor:=iColor;
  fBitmap.Canvas.FillRect(rec, iColor);
  Paint(Rec);
End;

Procedure tWinGraph.SetDrawOnForm(iValue : Boolean);

Begin
  fDrawOnForm := iValue;
  if iValue then Repaint;
End;

Function tWinGraph.bezY(Y : LongInt) : LongInt;

Begin
  Result:=ClientHeight-Y;
End;

Procedure tWinGraph.CopyToCanvas(x1,y1,x2,y2 : LongInt);

var Rec : TRect;

Begin
  if fDrawOnForm then
    Begin
      Rec.Left  := minLI(x1,x2);
      Rec.Right := maxLI(x1,x2) + 2;
      Rec.top   := maxLI(y1,y2) + 2;
      Rec.bottom:= minLI(y1,y2);;
      fBitmap.PartialDraw(tWinGraph.Canvas, rec, rec);
    End;
End;

Procedure tWinGraph.Paint(Const rec:TRect);

Begin
  inherited Paint(rec);
  inc(rec.Right,2);
  inc(rec.Top,2);
  fBitmap.PartialDraw(tWinGraph.Canvas, rec, rec);
End;

Procedure tWinGraph.Show;

Begin
  inherited Show;
  CopyToCanvas(0,0, Width, Height);
End;

Constructor tWinGraph.Create(W, H : LongInt);

Begin
  inherited.Create(nil);
  Width:=W;                 
  Height:=H;

{ Fill-Bittmap }
  fFillBitmap.Create;
  fFillBitmap.CreateNew(7,7,16);
  fFillBitmap.CreatePalette:=true;
  fDrawOnForm:=true;

{ Draw-Bitmap }
  fBitmap.Create;
  fBitmap.CreateNew(W,H,16);
  fBitmap.CreatePalette:=true;;

{ Farben }
  fBitmap.Canvas.Palette.Colors[ 0] := clBlack;
  fBitmap.Canvas.Palette.Colors[ 1] := clBlue;
  fBitmap.Canvas.Palette.Colors[ 2] := clGreen;
  fBitmap.Canvas.Palette.Colors[ 3] := clAqua;
  fBitmap.Canvas.Palette.Colors[ 4] := clRed;
  fBitmap.Canvas.Palette.Colors[ 5] := clFuchsia;
  fBitmap.Canvas.Palette.Colors[ 6] := clMaroon;
  fBitmap.Canvas.Palette.Colors[ 7] := clLtGray;
  fBitmap.Canvas.Palette.Colors[ 8] := clDkGray;
  fBitmap.Canvas.Palette.Colors[ 9] := clLtBlue;
  fBitmap.Canvas.Palette.Colors[10] := clLtGreen;
  fBitmap.Canvas.Palette.Colors[11] := clLtCyan;
  fBitmap.Canvas.Palette.Colors[12] := clLtRed;
  fBitmap.Canvas.Palette.Colors[13] := clLtMagenta;
  fBitmap.Canvas.Palette.Colors[14] := clYellow;
  fBitmap.Canvas.Palette.Colors[15] := clWhite;

{ Farben auch fuer das FillBitmap belegen }
  fFillBitmap.Canvas.Palette := fBitmap.Canvas.Palette;
End;

Destructor tWinGraph.Destroy;

Begin
  fFillBitmap.Destroy;
  fBitmap.Destroy;
  inherited.Destroy;
End;


Procedure SetDrawOnForm(iValue : Boolean);

Begin
  WinGraph.DrawOnForm := iValue;
End;


{ Graph: Funktionen
=========================================================================================== }

Procedure Bar(x1,y1,x2,y2 : integer);

Begin
End;

Procedure Bar3D(x1,y1,x2,y2 : integer; Depth : Word; Top : Boolean);

Begin
End;

Procedure Circle(x,y : Integer; Radius: Word);
{ Zeichnen eines Kreises bei den angegebene Position }

Begin
  y:=WinGraph.bezY(Y);
  WinGraph.Bitmap.Canvas.Circle(X,Y,Radius);
  WinGraph.CopyToCanvas(x-Radius,y-Radius,x+Radius,y+Radius);
End;

Procedure ClearDevice;
{ Der Bildschirm wird gelîscht }

Begin
  SetBkColor(Black);
End;


Procedure ClearViewport;

Begin
End;

Procedure CloseGraph;
{ Schliessen der Grafik }

Begin
  WinGraph.Destroy;
  WinGraph:=nil;
End;

Procedure DetectGraph(var GraphDriver, GraphMode : Integer);
{ Erkennen der Grafikkarte.
  Da fast keiner OS/2-User eine Grafikkarte unter der VGA
  verwendet, wird diese vorgestellt }

Begin
  GraphDriver := VGA;
  GraphMode   := VGAHi;
End;

Procedure DrawPoly(Numpoints: Word; var Polypoints);
{ Zeichnet einie Liniefolge }

Var Cou      : Word;
    Points   : tPolyPoints absolute PolyPoints;
    Min, Max : tPoint;

Begin
  Min.X:=Points[0].X;
  Min.Y:=Points[0].Y;
  Max:=Min;
  WinGraph.Bitmap.Canvas.BeginPath;
  WinGraph.Bitmap.Canvas.MoveTo(Points[0].X,WinGraph.bezY(Points[0].Y));
  for Cou:=1 to NumPoints-1 do
    Begin
      WinGraph.Bitmap.Canvas.LineTo(Points[Cou].X,WinGraph.bezY(Points[Cou].Y));
      if Points[Cou].X<Min.X then Min.X:=Points[Cou].X;
      if Points[Cou].Y<Min.Y then Min.Y:=Points[Cou].Y;
      if Points[Cou].X>Max.X then Max.X:=Points[Cou].X;
      if Points[Cou].Y>Max.Y then Max.Y:=Points[Cou].Y;
    End;
  WinGraph.Bitmap.Canvas.EndPath;
  WinGraph.Bitmap.Canvas.StrokePath;
  WinGraph.CopyToCanvas(Min.X, Min.Y, Max.X, Max.Y);
End;

Procedure Ellipse(x,y: Integer; stAngle, EndAngle: Word; XRadius, YRadius :word);
{ Zeichnet eie Ellipse }

Begin
  y:=WinGraph.bezY(Y);
  WinGraph.Bitmap.Canvas.Arc(X,Y,XRadius,YRadius,stAngle, endAngle);
  WinGraph.CopyToCanvas(x-XRadius,y-YRadius,x+XRadius,y+YRadius);
End;

Procedure FillEllipse(x,y: Integer; XRadius, YRadius :word);
{ Zeichnet eine Ellipse und fuellt dieses aus }

Begin
  y:=WinGraph.bezY(Y);
  WinGraph.Bitmap.Canvas.FilledEllipse(X,Y,XRadius,YRadius);
  WinGraph.CopyToCanvas(x-XRadius,y-YRadius,x+XRadius,y+YRadius);
End;

Procedure FillPoly(NumPoints: Word; var PolyPoints);

Var Cou      : Word;
    Points   : tPolyPoints absolute PolyPoints;
    Min, Max : tPoint;

Begin
  Min.X:=Points[0].X;
  Min.Y:=Points[0].Y;
  Max:=Min;
  WinGraph.Bitmap.Canvas.BeginPath;
  WinGraph.Bitmap.Canvas.MoveTo(Points[0].X,WinGraph.bezY(Points[0].Y));
  for Cou:=1 to NumPoints-1 do
    Begin
      WinGraph.Bitmap.Canvas.LineTo(Points[Cou].X,WinGraph.bezY(Points[Cou].Y));
      if Points[Cou].X<Min.X then Min.X:=Points[Cou].X;
      if Points[Cou].Y<Min.Y then Min.Y:=Points[Cou].Y;
      if Points[Cou].X>Max.X then Max.X:=Points[Cou].X;
      if Points[Cou].Y>Max.Y then Max.Y:=Points[Cou].Y;
    End;
  WinGraph.Bitmap.Canvas.EndPath;
  WinGraph.Bitmap.Canvas.FillPath;
  WinGraph.CopyToCanvas(Min.X, Min.Y, Max.X, Max.Y);
End;

Procedure FloodFill(x,y, Border: Word);
{ Fuellt ein geschlossen Bereich (mit Border-Farbe) mit der aktuellen Farbe aus }

Begin
  y:=WinGraph.bezY(Y);
  WinGraph.Bitmap.Canvas.FloodFill(x,y,border,false);
  WinGraph.CopyToCanvas(0,0,WinGraph.Width, WinGraph.Height);
End;

Procedure GetArcCodes(var ArcCoords:ArcCoordsType);

Begin
End;

Procedure GetAspectRatio(var Xasp, Yasp : Word);

Begin
End;

Function  GetBkColor : Word;
{ Leifert die Aktuelle BackgroundColor }

Begin
  Result:=WinGraph.BkColor
End;

Function  GetColor : Word;
{ Liefert die aktuelle Farbe }

Begin
  Result:=WinGraph.Bitmap.Canvas.Pen.Color
End;

Procedure GetDefaultPalette(var pal : Palettetype);

Begin
End;

Procedure GetFillSettings(var FillInfo :  FillsettingsType);

Begin
End;

Function  GetGraphMode : Integer;

Begin
  Result :=0;
End;

Procedure GetImage(x1, y1, x2, y2: Integer; var BitMap);

Begin
End;

Procedure GetLineSettings(var LineInfo: LineSettingsType);

Begin
End;

Function  GetMaxMode : Integer;

Begin
End;

Function  GetMaxX : Integer;
{ Maximale x-Koordinate }

Begin
  Result:=WinGraph.Bitmap.Width;
End;

Function  GetMaxY : Integer;
{ Maximale y-Koordinate }

Begin
  Result:=WinGraph.Bitmap.Height;
End;

Function  GetModeName(ModeNumber : Integer) : String;


Begin
End;

Procedure GetPalette(var Palette : PaletteType);

var cou : Word;

Begin
  Palette.Size:=WinGraph.Bitmap.Canvas.Palette.ColorCount;
  for cou:=1 to Palette.Size do
    Palette.Colors[Cou] := WinGraph.Bitmap.Canvas.Palette.Colors[Cou];
End;

Function  GetPaletteSize : Integer;
{ Liefert die Anzahl der Farben in der aktuellen Palette }

Begin
  Result:=WinGraph.Bitmap.Canvas.Palette.ColorCount;
End;

Function  GetPixel(x,y : Integer): Word;
{ Liefert die Farbe der angegebenen Position }

Begin
  y:=WinGraph.bezY(y);
  Result:=WinGraph.Bitmap.Canvas.Pixels[x,y];
End;

Procedure GetTextSettings(var TextInfo : TextSettingsType);

Begin
End;


Procedure GetViewSettings(var ViewPort: ViewPortType);

Begin
End;

Function  GetX: Integer;

Begin
  Result:=WinGraph.Bitmap.Canvas.PenPos.X;
End;

Function  GetY: Integer;

Begin
  Result:=WinGraph.ClientHeight-WinGraph.Bitmap.Canvas.PenPos.Y;
End;

Function  GraphErrorMsg(ErrorCode: Integer): string;

Begin
  Result:='';
End;

Function  GraphResult: Integer;

Begin
  Result:=0;
End;

Function  ImageSize(x1, y1, x2, y2: Integer): Word;

Begin
  Result :=0;
End;

Procedure InitGraph(var GraphDriver:Integer; var GraphMode: Integer;
                    PathToDriver: string);

Begin
  if (GraphDriver = Detect) or
     (GraphDriver > maxGraphDriver) or
     (GraphMode > maxGraphMode) or
     (WndSize[GraphDriver,GraphMode,1]=0) or
     (WndSize[GraphDriver,GraphMode,2]=0) then
    DetectGraph(GraphDriver, GraphMode);
  WinGraph.Create(WndSize[GraphDriver,GraphMode,1], WndSize[GraphDriver,GraphMode,2]);
  WinGraph.BorderStyle:=bsDialog;
  WinGraph.Show;
  WinGraph.BkColor:=Black;
End;

Procedure Line(x1,y1,x2,y2 : Integer);
{ Linie zeichnen }

Begin
  y1:=WinGraph.bezY(y1);
  y2:=WinGraph.bezY(y2);
  WinGraph.Bitmap.Canvas.Line(x1,y1,x2,y2);
  WinGraph.CopyToCanvas(x1,y1,x2,y2);
End;

Procedure LineRel(Dx,Dy : Integer);

var p1, p2 : tPoint;

Begin
  p1:=WinGraph.Bitmap.Canvas.PenPos;
  p2.X:=p1.X+Dx;
  p2.Y:=p1.Y-Dy;
  WinGraph.Bitmap.Canvas.LineTo(p2.X,p2.Y);
  WinGraph.CopyToCanvas(p1.X,p1.Y,p2.X,p2.Y);
End;

Procedure LineTo(x,y : Integer);

var p1 : tPoint;

Begin
  p1:=WinGraph.Bitmap.Canvas.PenPos;
  y:=WinGraph.bezY(y);
  WinGraph.Bitmap.Canvas.LineTo(x,y);
  WinGraph.CopyToCanvas(p1.x,p1.y,x,y);
End;

Procedure MoveRel(Dx,Dy : Integer);

var p1 : tPoint;

Begin
  p1:=WinGraph.Bitmap.Canvas.PenPos;
  WinGraph.Bitmap.Canvas.LineTo(p1.X+Dx,p1.Y-Dy);
End;

Procedure MoveTo(x,y : Integer);

Begin
  y:=WinGraph.bezY(y);
  WinGraph.Bitmap.Canvas.LineTo(x,y);
End;

Procedure OutText(Textstring : String);

Begin
End;

Procedure OutTextXY(x,y : Integer; Textstrinf : String);

Begin
End;

Procedure PieSlice(x,y: Integer; stAngle, EndAngle, Radius: Word);

Begin
End;

Procedure PutImage(X, Y: Integer; var BitMap; BitBlt: Word);

Begin
End;

Procedure Rectangle(x1, y1, x2, y2: Integer);
{ Zeichnet ein Rechteck }

var rec : tRect;

Begin
  rec.Left  := x1;
  rec.bottom:= WinGraph.bezY(y1);
  rec.right := x2;
  rec.top   := WinGraph.bezY(y2);
  WinGraph.Bitmap.Canvas.Rectangle(rec);
  WinGraph.CopyToCanvas(rec.Left, rec.Bottom, rec.Right, rec.Top);
End;

Procedure Sector(x, y: Integer; StAngle,EndAngle, XRadius, YRadius: Word);

Begin
End;

Procedure SetActivePage(Page: Word);

Begin
End;

Procedure SetAllPalette(var Palette);

Begin
End;

Procedure SetBkColor(ColorNum: Byte);

Begin
  if ColorNum<16
    then WinGraph.BkColor := ColorNum
    else Writeln('Fehler');
End;

Procedure SetColor(Color: Byte);

Begin
  if Color<16
    then
      Begin
        WinGraph.Bitmap.Canvas.Brush.Color:=Color;
        WinGraph.Bitmap.Canvas.Pen.Color:=Color;
      End
    else Writeln('Fehler');
End;

Procedure SetFillPattern(Pattern: FillPatternType; Color: Word);

Begin
  WinGraph.setFillPattern(Pattern, Color);
End;

Procedure SetFillStyle(Pattern: Word; Color: Word);

Begin
End;

Procedure SetGraphMode(Mode: Integer);

Begin
End;

Procedure SetPalette(ColorNum: Word; Color: Byte);

Begin

End;


Procedure SetRGBPalette(ColorNum, RedValue, GreenValue, BlueValue: Word);

{$IFDEF OS2}
var col : RGB;
{$ENDIF}

Begin
  if ColorNum>MaxColors
    then Writeln('Fehler')
    else
      Begin
{$IFDEF OS2}
        col.bBlue := BlueValue;
        col.bGreen:= GreenValue;
        col.bRed  := RedValue;
        WinGraph.Bitmap.Canvas.Palette.Colors[ColorNum]:=LongInt(col);
        Writeln(IntToHex(WinGraph.Bitmap.Canvas.Palette.Colors[ColorNum],8));
{        WinGraph.CopyToCanvas(0,0,WinGraph.Width, WinGraph.Height);}
{$ENDIF}
      End;
End;

Procedure SetTextBuf(var F: Text; var Buf; Size:   Word);

Begin
End;

Procedure SetTextJustify(Horiz, Vert: Word);

Begin
End;

Procedure SetUserCharSize(MultX, DivX, MultY, DivY: Word);

Begin
End;

Procedure SetViewPort(x1, y1, x2, y2: Integer; Clip: Boolean);

Begin
End;

Procedure SetVisualPage(Page: Word);

Begin
End;

Procedure SetWriteMode(WriteMode: Integer);

Begin
End;

Function  TextHeight(TextString: string): Word;

Begin
  Result :=0;
End;

Function  TextWidth(TextString: string): Word;

Begin
  Result :=0;
End;


Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
}
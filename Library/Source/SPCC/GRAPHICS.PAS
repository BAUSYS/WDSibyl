
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2005..     Ing. Wolfgang Draxler, All rights reserved.  บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
                             
                                          
Unit Graphics;
                    
Interface

{$IFDEF OS2}
Uses PmWin,PmGpi,PmBitmap,PmDev,Os2Def,BseDos;
{$ENDIF}

{$IFDEF Win32}
Uses WinNt,WinDef,WinGDI,WinUser,WinBase;
{$ENDIF}

Uses SysUtils,Classes,ClipBrd,Color,
     uList, uSysInfo,
     uStream,
     uConvert;

Type
    EInvalidBitmap=Class(Exception);
    EInvalidIcon=Class(Exception);
    EInvalidCursor=Class(Exception);
    EInvalidPictureFormat=Class(Exception);


Type
    TCanvas=Class;
    TGraphic=Class;

    TPalette=Class(TComponent)
      Private
         FHandle:LongWord;
         FCanvas:TCanvas;
      Private
         Function GetColor(Index:LongWord):TColor;
         Procedure SetColor(Index:LongWord;NewColor:TColor);
         Function GetColorCount:LongWord;
         Function GetHandle:LongWord;
      Protected
         Procedure SetupComponent;Override;
      Public
         Function GetColorArray(StartIndex:LongWord;Var ResultArray:Array Of TCoLor):LongWord;
         Procedure SetColorArray(StartIndex:LongWord;Const SourceArray:Array Of Tcolor);
         Procedure CreateNew(Var Colors:Array Of TColor);
         Procedure RealizePalette;
      Public
         Property ColorCount:LongWord Read GetColorCount;
         Property Handle:LongWord Read GetHandle Write FHandle;
         Property Colors[Index:LongWord]:TColor Read GetColor Write SetColor;
         Property Canvas:TCanvas Read FCanvas;
    End;

    TPathClipMode=(paAdd,paSubtract,paReplace,paDiff,paIntersect);

    TModifyClipMode=(clmAnd,clmOr,clmDiff,clmXor);

    TBitBltMode=(cmSrcCopy, cmSrcPaint, cmSrcAnd, cmSrcInvert,
                 cmSrcErase, cmNotSrcCopy, cmNotSrcErase,
                 cmMergeCopy, cmMergePaint, cmPatCopy, cmPatPaint,
                 cmPatInvert, cmDstInvert, cmBlackness, cmWhiteness);

    TBitBltFlags=(bitfOr,bitfAnd,bitfIgnore);


    {$M+}
    TPenStyle = (psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear,
                 psAlternate);
    TPenMode = (pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot,
                pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge,
                pmMask, pmNotMask, pmXor, pmNotXor);
    {$M-}

    TPen=Class(TComponent)
      Private
         FCanvas:TCanvas;
         FColor:TColor;
         FStyle:TPenStyle;
         FMode:TPenMode;
         FWidth:LongInt;
         Procedure SetColor(NewColor:TColor);
         Procedure SetMode(NewMode:TPenMode);
         Procedure SetStyle(NewStyle:TPenStyle);
         Procedure SetWidth(NewWidth:LongInt);
      Public
         Procedure SetupComponent;Override;
         Procedure Assign(Source:TPersistent);Override;
      Published
         Property Color:TColor Read FColor Write SetColor;
         Property Mode:TPenMode Read FMode Write SetMode;
         Property Style:TPenStyle Read FStyle Write SetStyle;
         Property Width:LongInt Read FWidth Write SetWidth;
    End;

    {$M+}
    TBrushStyle = (bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal,
                   bsBDiagonal, bsCross, bsDiagCross);
    TBrushMode  = (bmTransparent,bmOpaque);
    {$M-}

    TBrush=Class(TComponent)
      Private
         FCanvas:TCanvas;
         FBitmap:TGraphic;
         FColor:TColor;
         FStyle:TBrushStyle;
         FMode:TBrushMode;
         Procedure SetColor(NewColor:TColor);
         Procedure SetStyle(NewStyle:TBrushStyle);
         Procedure SetBitmap(NewBitmap:TGraphic);
         Procedure SetMode(NewMode:TBrushMode);
      Public
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Property Bitmap:TGraphic Read FBitmap Write SetBitmap;
         Procedure Assign(Source:TPersistent);Override;
      Published
         Property Color:TColor Read FColor Write SetColor;
         Property Style:TBrushStyle Read FStyle Write SetStyle;
         Property Mode:TBrushMode Read FMode Write SetMode;
    End;


type
    {Standard Font types}
    TFontType=(ftBitmap,ftOutline);

    {Standard Font Attributes}
    TFontAttributes=Set Of(faItalic,faUnderScore,faOutline,faStrikeOut,faBold);

    {Standard Font pitches}
    TFontPitch=(fpFixed,fpProportional);

    {Standard Font character Set}
    TFontCharSet=(fcsSBCS,fcsDBCS,fcsMBCS);  {Single,Double,mixed Byte}

{$M-}

////////////////////////////////////////////////////////////////////////////
//  Change Font Attributes only If you have created A Font Copy using
//  CreateCompatibleFont Or created A New Font using GetFontFromPointSize
//  Changing predefined Fonts As returned from GetSystemSmallFont Or
//  GetSystemFixedFont will have global effects !
////////////////////////////////////////////////////////////////////////////
type
    TFont=Class(TComponent)
      Private
         FInternalPointSize:LongWord;   {internal Point.Name Value Or Nil}
         {$IFDEF OS2}
         FFontInfo:FONTMETRICS;
         {$ENDIF}
         {$IFDEF Win32}
         FFontInfo:LOGFONT;
         FHandle:LongWord;
         FRefCount:LongWord;
         {$ENDIF}
         FUseCount:LongWord;
         FCustom:Boolean;
         FDefault:Boolean;
         FAutoDestroy:Boolean;
         FFontType:TFontType;
         FAlternateName:PString; //Alternate name for SCU Win<->OS2
         fOS2Codepage : integer; {Martin0206}
         Function GetName:String;
         Function GetFamily:String;
         Function GetPitch:TFontPitch;
         Function GetHeight:LongInt;
         Function GetWidth:LongInt;
         Function GetAttributes:TFontAttributes;
         Function GetWinCodepage : Byte; {Martin0206}
         Procedure SetHeight(NewHeight:LongInt);
         Procedure SetWidth(NewWidth:LongInt);
         Procedure SetAttributes(NewAttr:TFontAttributes);
         Function GetInternalLeading:LongInt;
         Function GetNominalPointSize:LongInt;
         Function GetMinimumPointSize:LongInt;
         Function GetMaximumPointSize:LongInt;
         Function GetCharSet:TFontCharSet;
      Protected
         {$IFDEF OS2}
         Property FontInfo:FONTMETRICS read FFontInfo write FFontInfo;
         {$ENDIF}
         {$IFDEF Win32}
         Property FontInfo:LOGFONT read FFontInfo write FFontInfo;
         Property Handle:LongWord read FHandle write FHandle;
         Property RefCount:LongWord read FRefCount write FRefCount;
         {$ENDIF}
         Property Custom:Boolean read FCustom write FCustom;
         Property InternalPointSize:LongWord read FInternalPointSize write FInternalPointSize;
         Property AlternateName:PString read FAlternateName write FAlternateName;
      Public
         Constructor Create(AOwner:TComponent);Override;
         Destructor Destroy;Override;
         Function WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceName):Boolean;
         //If This Is Set To True, the Font Is automatically freed when the Control that owns
         //the Font Is destroyed And no other Control owns the Font
         //This option Is only Valid For Fonts created With "CreateCompatibleFont"
         Property IsDefault:Boolean Read FDefault; //undocumented !
         Property AutoDestroy:Boolean Read FAutoDestroy Write FAutoDestroy;
         Property FaceName:String Read GetName;
         Property Family:String Read GetFamily;
         Property Height:LongInt Read GetHeight Write SetHeight;
         Property Width:LongInt Read GetWidth Write SetWidth;
         Property InternalLeading:LongInt Read GetInternalLeading;
         Property NominalPointSize:LongInt Read GetNominalPointSize;
         Property MinimumPointSize:LongInt Read GetMinimumPointSize;
         Property MaximumPointSize:LongInt Read GetMaximumPointSize;
         Property Attributes:TFontAttributes Read GetAttributes Write SetAttributes;
         Property Pitch:TFontPitch Read GetPitch;
         Property CharSet:TFontCharSet Read GetCharSet;
         Property FontType:TFontType Read FFontType write FFontType;
         Property PointSize:LongWord Read FInternalPointSize Write FInternalPointSize;
         Property WinCodepage : Byte read GetWinCodepage; {Martin0206}
         Property OS2Codepage : integer read fOS2Codepage write fOS2Codepage; {Martin0206}
    End;


    {$IFDEF OS2}
    {
    Matrix of

    ฺ           ฟ
    ณM11 M12 M13ณ
    ณM21 M22 M23ณ
    ณM31 M32 M33ณ
    ภ           ู

    used for Canvas.Transform.
    }

    TMatrix=Object
       Private
          FMatrix:MATRIXLF;
       Private
          Function GetM11:Extended;
          Procedure SetM11(Const NewValue:Extended);
          Function GetM12:Extended;
          Procedure SetM12(Const NewValue:Extended);
          Function GetM21:Extended;
          Procedure SetM21(Const NewValue:Extended);
          Function GetM22:Extended;
          Procedure SetM22(Const NewValue:Extended);
          Constructor CreateIntern;
       Public
          Constructor CreateEmpty;
          Constructor Create(Const aM11,aM12:Extended;aM13:LongInt;
                             Const aM21,aM22:Extended;aM23:LongInt;
                             Const aM31,aM32,aM33:LongInt);
          Constructor CreateLike(m:TMatrix);
          Constructor CreateTranslation(DeltaX,DeltaY:LongInt);
          Constructor CreateScaling(Const ScalePercentX,ScalePercentY:Extended);
          Constructor CreateVertReflection;
          Constructor CreateHorzReflection;
          Constructor CreateYShear(Const Shear:Extended);
          Constructor CreateXShear(Const Shear:Extended);
          Constructor CreateRotation(Const Degree:Extended);
          Constructor CreateDefault;
          Destructor Destroy;
          Procedure Assign(m:TMatrix);
          Procedure TransformPoint(Var pt:TPoint);
       Public
          Property M11:Extended read GetM11 write SetM11;
          Property M12:Extended read GetM12 write SetM12;
          Property M13:Longint read FMatrix.lM13 write FMatrix.lM13;
          Property M21:Extended read GetM21 write SetM21;
          Property M22:Extended read GetM22 write SetM22;
          Property M23:LongInt read FMatrix.lM23 write FMatrix.lM23;
          Property M31:LongInt read FMatrix.lM31 write FMatrix.lM31;
          Property M32:LongInt read FMatrix.lM32 write FMatrix.lM32;
          Property M33:LongInt read FMatrix.lM33 write FMatrix.lM33;
    End;

    {$M+}
    TTransformMode=(trReplace,trAdd,trPreEmpt);
    TAreaMode=(arNoBoundary,arBoundary,arAlternate,arWinding,
               arNoBoundaryAlternate,arNoBoundaryWinding,
               arBoundaryWinding,arBoundaryAlternate);
    {$M-}
    {$ENDIF}


    TCanvas=Class(TComponent)
      Private
         FControl:TComponent;
         FGraphic:TGraphic;
         fOwnerObject : tObject;
         {$IFDEF OS2}
         FUsePath:Boolean;
         {$ENDIF}
         {$IFDEF Win32}
         FPenHandle:LongWord;
         FBrushHandle:LongWord;
         FInPath:Boolean;
         {$ENDIF}
         FFont:TFont;
         FFontHandle:LongWord;
         FFontWidth,FFontHeight:LongInt;
         FFontAttr:TFontAttributes;
         FLineWidth:LongInt;
         FLineType:TPenStyle;
         FBackMix:TBrushMode;
         FForeMix:TPenMode;
         FClipRGN:LongWord;
         FClipRect:TRect;
         FHandle:LongWord;
         FPalette:TPalette;
         FBrush:TBrush;
         FPen:TPen;
         FCopyMode:TBitBltMode;
         FNonDisplayDevice:Boolean;
         FOwnerDraw:Boolean;
         FNoConvertTextOut : boolean;  // {Martin}
         Function GetPenPosition:TPoint;
         Procedure SetPenPosition(NewPosition:TPoint);
         Procedure CreateFont(NewFont:TFont;ModifyControlFont:Boolean);
         Procedure SetFont(NewFont:TFont);
         Procedure SetFontHeight(NewHeight:LongInt);
         Function GetFontHeight:LongInt;
         Procedure SetFontWidth(NewWidth:LongInt);
         Function GetFontWidth:LongInt;
         Procedure SetFontAttr(NewAttr:TFontAttributes);
         Function GetFontAttr:TFontAttributes;
         Procedure SetClipRect(Const rec:TRect);
         Function GetPixel(X,Y:LongInt):TColor;
         Procedure SetPixel(X,Y:LongInt;Value:TColor);
         Function GetVerticalRes:LongInt;
         Function GetHorizontalRes:LongInt;
         Procedure SetPen(NewPen:TPen);
         Procedure SetBrush(NewBrush:TBrush);
         Procedure SetPalette(NewPalette:TPalette);
         Function GetPageViewPort:TRect;
         Procedure SetPageViewPort(NewValue:TRect);
         {$IFDEF OS2}
         Procedure SetTransformMatrix(Const m:TMatrix);
         Function GetTransformMatrix:TMatrix;
         Function GetLineColor:TColor;
         Function GetCharColor:TColor;
         Function GetAreaColor:TColor;
         Procedure SetLineColor(NewValue:TColor);
         Procedure SetCharColor(NewValue:TColor);
         Procedure SetAreaColor(NewValue:TColor);
         {$ENDIF}
      Protected
         Procedure SetupComponent;Override;
         {$IFDEF WIN32}
         Property PenHandle:LongWord read FPenHandle write FPenHandle;
         Property BrushHandle:LongWord read FBrushHandle write FBrushHandle;
         {$ENDIF}
      Public
         Constructor Create(aOwner : TComponent); Virtual;
         Constructor CreateWithObject(aOwner : tObject); Virtual;
         Destructor Destroy;Override;
         Procedure EraseBackGround;Virtual;
         Procedure Init;Virtual;
         Function GetFontFromPointSize(FaceName:String;PointSize:LongWord):TFont; {Martin!}

         {$IFDEF OS2}
         Procedure Transform(m:TMatrix;Mode:TTransformMode);
         Procedure ResetTransform;
         Procedure BeginArea(Mode:TAreaMode);
         Procedure EndArea;
         Procedure PolySpline(aptl:Array Of TPoint);
         {$ENDIF}
         Procedure CreateHandle;Virtual;
         Procedure DestroyHandle;Virtual;
         Procedure FillRect(Const rec:TRect;FillColor:TColor);Virtual;
         Procedure MoveTo(X,Y:LongInt);Virtual;
         Procedure LineTo(X,Y:LongInt);Virtual;
         Procedure Line(X,Y,X1,y1:LongInt);Virtual;
         Procedure PolyLine(Points:Array Of TPoint);Virtual;
         Procedure Polygon(Points:Array Of TPoint);Virtual;
         Procedure ShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
         Procedure RoundShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
         Procedure DrawFocusRect(Const rec:TRect);
         Procedure Rectangle(Const rec:TRect);
         Procedure RoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
         Procedure FilledRoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
         Procedure DrawInvertRect(Const rec:TRect);
         Procedure Box(Const rec:TRect);
         Procedure OutlineBox(Const rec:TRect);
         Procedure Circle(X,Y:LongInt;Radius:LongInt);
         Procedure Arc(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
         Procedure BrushCopy(Const Dest:TRect;Bitmap:TGraphic;
                             Const Source:TRect;Color:TColor);
         Procedure Chord(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAnglE:Extended);
         Procedure Pie(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
         Procedure CopyRect(Const Dest:TRect;Canvas:TCanvas;Const Source:TRect);
         Procedure BezierSpline(X,Y:LongInt;Points:Array Of TPoint);
         Procedure FilledCircle(X,Y:LongInt;Radius:LongInt);
         Procedure Ellipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
         Procedure FilledEllipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
         Procedure DrawString(Const S:String);
         Procedure TextOut(X,Y:LongInt;Const S:String);
         Procedure MnemoTextOut(X,Y:LongInt;Const S:String);
         Procedure Draw(X,Y:LongInt;Graphic:TGraphic);
         Procedure PartialDraw(X,Y:LongInt;Const SourceRec:TRect;Graphic:TGraphic);
         Procedure StretchDraw(X,Y,Width,Height:LongInt;Graphic:TGraphic);
         Procedure StretchPartialDraw(X,Y,Width,Height:LongInt;Const SourceRec:TRect;Graphic:TGraphic);
         Function TextHeight(Const Text:String):LongInt;
         Function TextWidth(Const Text:String):LongInt;
         Procedure TextRect(Const rc:TRect;X,Y:LongInt;Const Text:String);
         Procedure FloodFill(X,Y:LongInt;BorderColor:TColor;FillSurface:Boolean);
         Procedure GetTextExtent(Const S:String;Var Width,Height:LongInt);
         Procedure SetClipRegion(Rects:Array Of TRect);
         Procedure ModifyClipRegion(Const rec:TRect;Mode:TModifyClipMode);
         Procedure DeleteClipRegion;
         Procedure ExcludeClipRect(Const rec:TRect);
         Procedure BitBlt(DestCanvas:TCanvas;Const Dest,Source:TRect;
                          Mode:TBitBltMode;Flags:TBitBltFlags);
         Procedure BeginPath;
         Procedure EndPath;
         Procedure FillPath;
         Procedure StrokePath;
         Procedure OutlinePath;
         Procedure CloseFigure;
         Procedure PathToClipRegion(Mode:TPathClipMode);
         Procedure ChangeColor(Rec : TRect; SearchColor, ReplaceColor : tColor);

      Public   // Properties
         Property NoConvertTextOut:Boolean read FNoConvertTextOut write FNoConvertTextOut; {Martin}
         Property NonDisplayDevice:Boolean read FNonDisplayDevice write FNonDisplayDevice;
         Property Handle:LongWord Read FHandle Write FHandle;
         Property OwnerDraw:Boolean read FOwnerDraw write FOwnerDraw;
         Property Graphic:TGraphic Read FGraphic;
         Property Control:TComponent Read FControl;
         Property OwnerObject : tObject Read fOwnerObject;
         Property PenPos:TPoint Read GetPenPosition Write SetPenPosition;
         Property Font:TFont Read FFont Write SetFont;
         Property FontHeight:LongInt Read GetFontHeight Write SetFontHeight;
         Property FontWidth:LongInt Read GetFontWidth Write SetFontWidth;
         Property FontAttributes:TFontAttributes Read GetFontAttr Write SetFontAttr;
         Property ClipRect:TRect Read FClipRect Write SetClipRect;
         Property Pixels[X,Y:LongInt]:TColor Read GetPixel Write SetPixel;
         Property Palette:TPalette Read FPalette Write SetPalette;
         Property VerticalResolution:LongInt Read GetVerticalRes;
         Property HorizontalResolution:LongInt Read GetHorizontalRes;
         Property Pen:TPen Read FPen Write SetPen;
         Property Brush:TBrush Read FBrush Write SetBrush;
         Property CopyMode:TBitBltMode Read FCopyMode Write FCopyMode;
         Property PageViewPort:TRect read GetPageViewPort write SetPageViewPort;
         {$IFDEF OS2}
         Property TransformMatrix:TMatrix read GetTransformMatrix write SetTransformMatrix;
         Property LineColor:TColor read GetLineColor write SetLineColor;
         Property AreaColor:TColor read GetAreaColor write SetAreaColor;
         Property CharColor:TColor read GetCharColor write SetCharColor;
         {$ENDIF}
    End;

    {$HINTS OFF}
    TGraphic=Class(TComponent)
      Private
         {Martin}
         FHeight:LongInt;
         FWidth:LongInt;
         FIsLocalCopy:Boolean;
         FOnChangedNotify:TNotifyEvent;
         FOnChange:TNotifyEvent;
         FCreatePalette:Boolean;
      Public
         Procedure Draw(Canvas:TCanvas;Const Dest:TRect);Virtual;Abstract;
         Procedure PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);Virtual;Abstract;
         Procedure LoadFromFile(Const FileName:String);Virtual;
         Procedure SaveToFile(Const FileName:String);Virtual;
         Procedure LoadFromStream(Stream:TStream);Virtual;Abstract;
         Procedure SaveToStream(Stream:TStream);Virtual;Abstract;
         Function CopyGraphic:TGraphic;Virtual;Abstract;
         Procedure Changed;Virtual;
         Function CreateMask(Color:TColor):TGraphic;Virtual;Abstract;
         Constructor Create;Virtual;
         Procedure LoadFromHandle(Handle:LongWord);Virtual;Abstract;
         Procedure LoadFromResourceId(Id:LongWord);Virtual;Abstract;
         Procedure LoadFromResourceName(Const Name:String);Virtual;Abstract;
         Procedure LoadFromMem(Var Buf;Size:LongInt);Virtual;Abstract;
      Protected
         Function GetEmpty:Boolean;Virtual;Abstract;
         {Martin 4x "abstract" deleted}
         Function GetHeight:LongInt;Virtual;
         Procedure SetHeight(Value:LongInt);Virtual;
         Function GetWidth:LongInt;Virtual;
         Procedure SetWidth(Value:LongInt);Virtual;
         Function GetHandle:LongWord;Virtual;Abstract;
         Function GetCanvas:TCanvas;Virtual;Abstract;
         Function GetSize:LongInt;Virtual;Abstract;
         Procedure PaletteChanged;Virtual;Abstract;
         Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Virtual;Abstract;

         Property IsLocalCopy:Boolean read FIsLocalCopy write FIsLocalCopy;
         Property OnChangedNotify:TNotifyEvent read FOnChangedNotify write FOnChangedNotify;
      Public
         Function WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceNAme):Boolean;Virtual;Abstract;
         Property Empty:Boolean Read GetEmpty;
         Property Height:LongInt Read GetHeight Write SetHeight;
         Property Width:LongInt Read GetWidth Write SetWidth;
         Property Handle:LongWord Read GetHandle;
         Property Canvas:TCanvas Read GetCanvas;
         Property Size:LongInt Read GetSize;
         Property CreatePalette:Boolean Read FCreatePalette Write FCreatePalette;
         Property OnChange:TNotifyEvent read FOnChange write FOnChange;
    End;
    {$HINTS ON}
    TGraphicClass=Class Of TGraphic;

    TMetaFile=Class;                       

    TMetafileCanvas=Class(TCanvas)
      Private
         FMetafile:TMetafile;
      Public
         Constructor Create(AMetafile: TMetafile);Virtual;
         Destructor Destroy;Override;
    End;

    TMetafile=Class(TGraphic)
      Private
          //FHeight:LongInt; --> moved to tGraphic. Please delete also in tBitmap.
          //FWidth:LongInt;  --> moved to tGraphic. Please delete also in tBitmap.
          {$ifdef os2}
          rectlMet : RECTL;
          {$endif}
      Protected
          Function GetEmpty: Boolean;Override;
          Function GetHandle:LongWord;Override;
          Function GetCanvas:TCanvas;Override;
          Function GetSize:LongInt;Override;
          Procedure PaletteChanged;Override;
          Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Override;
          procedure CalculateWidthHeight;
      Public
          FDeviceHandle:LongWord;
          FHandle:LongWord;
          FMetaFileCanvas:TMetaFileCanvas;

          Procedure Assign(Source:TPersistent);Override;
          Function CreateMask(Color:TColor):TGraphic;Override;
          Procedure PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);Override;
          Procedure Draw(ACanvas: TCanvas;Const Rect: TRect);Override;
          Procedure SetupComponent;Override;
          Destructor Destroy;Override;
          Procedure LoadFromStream(Stream: TStream);Override;
          Procedure LoadFromFile(Const FileName:String);Override;
          Function LoadFromClipBoard:Boolean;
          Procedure SaveToFile(const Filename: String);Override;
          Procedure SaveToStream(Stream: TStream);Override;
          Function CopyGraphic:TGraphic;Override;
          Procedure LoadFromHandle(Handle:LongWord);Override;
      Public
          Property Device:LongWord read FDeviceHandle write FDeviceHandle;
    End;

    TBitmap=Class;

    TBitmapCanvas=Class(TCanvas)
       Private
            FBitmap:TBitmap;
       Public
            Procedure CreateHandle;Override;
            Procedure DestroyHandle;Override;
    End;

    {$HINTS OFF}
    TBitmap=Class(TGraphic)
      Private
         {Martin: moved to tGraphic}
           //FHeight:LongInt;
           //FWidth:LongInt;
         FEmpty:Boolean;
         FOrigin:TBitmap;
         FBitmapHandle:LongWord;
         FBitmapPS:LongWord;
         FBitmapDC:LongWord;
         FScalX,FScalY:LongWord;
         FBitmapPal:LongWord;
         FColorCount:LongInt;
         FOrigBitCount,FOrigPlanes:LongInt; //original BitCount, also used For Saving
         FOldBitmap:LongWord;
         FOldPalette:LongWord;
         FBitmapMem:Pointer;
         FBitmapMemLength:LongInt;
         FCanvas:TBitmapCanvas;
         FXHotSpot,FYHotSpot:LongInt;
         FIsInvalid : Boolean;
         fBitmapTyp       : tBitmapTyp;
         fTransparentColor: tColor;
      Private
         Procedure NewImage(BitmapData:Pointer;BitmapSize,OffsBits:LongWord;Mask:Boolean);
         Procedure SetupBitmapColors(Header:Pointer;Mask:Boolean);
         Function GetEmpty:Boolean;Override;
         {Martin: moved to tGraphic}
           //Function GetHeight:LongInt;Override;
           //Procedure SetHeight(NewHeight:LongInt);Override;
           //Function GetWidth:LongInt;Override;
           //Procedure SetWidth(NewWidth:LongInt);Override;
         Procedure ReadStream(Stream:TStream;Size:LongInt);Virtual;
         Procedure ReleaseBitmap;Virtual;
         Procedure SetupBitmap;Virtual;
         Function GetHandle:LongWord;Override;
         Function GetCanvas:TCanvas;Override;
         Function GetSize:LongInt;Override;
      Protected
         PermanentHandle:Boolean;
         Procedure SetupComponent;Override;
         Procedure Changed;Override;
         Procedure InvalidImage;Virtual;
         Procedure PaletteChanged;Override;
         Procedure Update;Virtual;
      Public
         Procedure CreateHandle;Virtual;
         Procedure DestroyHandle;Virtual;
         Procedure Assign(Source:TPersistent);Override;
         Procedure CopyToClipboard(Const Src:TRect);
         Function LoadFromClipBoard:Boolean;
         Function CreateMask(Color:TColor):TGraphic;Override;
         Destructor Destroy;Override;
         Procedure LoadFromStream(Stream:TStream);Override;
         Procedure SaveToStream(Stream:TStream);Override;
         Procedure LoadFromResourceId(Id:LongWord);Override;
         Procedure LoadFromResourceName(Const Name:String);Override;
         Procedure LoadFromMem(Var Buf;Size:LongInt);Override;
         Procedure LoadFromBitmap(Bitmap:TBitmap);
         Procedure LoadFromHandle(AHandle:LongWord);Override;
         Function CopyGraphic:TGraphic;Override;
         Function Copy:TBitmap;
         Procedure Draw(Canvas:TCanvas;Const Dest:TRect);Override;
         Procedure DrawBitmapBits(SrcRec: TRect;Canvas: TCanvas;DstRec: TRect);
         Procedure PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);Override;
         Procedure DrawDisabled(Canvas:TCanvas;Const Dest:TRect);Virtual;
         Procedure RealizePalette(Canvas:TCanvas);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Function WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceName):Boolean;Override;
         Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Override;
         Function IsEqual(Bitmap:TBitmap):Boolean;

         Property Device          : LongWord   Read FBitmapDC;
         Property ColorCount      : LongInt    Read FColorCount;
         Property BitmapTyp       : tBitmapTyp Read fBitmapTyp;
         Property TransparentColor: tColor     Read fTransparentColor Write fTransparentColor;
         Property BitmapMem       : Pointer    Read FBitmapMem;
         Property BitmapMemLength : LongInt    Read fBitmapMemLength;

    End;
    {$HINTS ON}

    TBitmapClass=Class Of TBitmap;

    TIcon=Class(TBitmap)
      Private
         FMaskHandle           : LongWord;
         FMaskDC               : LongWord;
         FMaskPS               : LongWord;
         FMaskPal              : LongWord;
         FMaskColorCount       : LongWord;
         FMaskWidth,FMaskHeight: LongWord;
         FIconPointerHandle    : LongWord;
         FMaskCanvas           : TBitmapCanvas;
         FOldMaskBitmap        : LongWord;
         FOldMaskPalette       : LongWord;
         fIconTyp              : tIconTyp;

         Procedure SetupBitmap;Override;
         Function GetHandle:LongWord;Override;
         Procedure ReleaseBitmap;Override;
         Function GetMaskCanvas:TCanvas;
         Procedure ReadStream(Stream:TStream;Size:LongInt);Override;
      Protected
         Procedure InvalidImage;Override;
         Procedure CreateIconPointerHandle;
      Public
         Procedure Draw(Canvas:TCanvas;Const Dest:TRect);Override;
         Procedure CreateHandle;Override;
         Procedure DestroyHandle;Override;
         Procedure Update;Override;
         Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Override;
         Procedure LoadFromResourceName(Const Name:String);Override;
         Property MaskHandle    : LongWord Read FMaskHandle;
         Property ColorHandle   : LongWord Read FBitmapHandle;
         Property MaskPresentationSpaceHandle:LongWord Read FMaskPS;
         Property MaskDevice    : LongWord Read FMaskDC;
         Property MaskWidth     : LongWord Read FMaskWidth;
         Property MaskHeight    : LongWord Read FMaskHeight;
         Property MaskPalette   : LongWord Read FMaskPal;
         Property MaskCanvas    : TCanvas Read GetMaskCanvas;
         Property IconTyp       : tIconTyp Read fIconTyp;
    End;


    TPointer=Class(TIcon)
      Protected
        Procedure InvalidImage;Override;
        Property XHotSpot:LongInt Read FXHotSpot Write FXHotSpot;
        Property YHotSpot:LongInt Read FYHotSpot Write FYHotSpot;
      Public
         Procedure LoadFromResourceName(Const Name:String);Override;
    End;

    TBitmapList=Class(TList)
      Private
         FDuplicates:Boolean; {only For Add}
         FBitmapClass:TBitmapClass;
         Function CopyBitmap(original:TBitmap):TBitmap;
         Function GetBitmap(Index:LongInt):TBitmap;
         Procedure SetBitmap(Index:LongInt;Bitmap:TBitmap);
         Property Items;
      Protected
        Procedure FreeItem(Item:Pointer);Override;
      Public
         Function Add(Item:TBitmap):LongInt;
         Procedure Insert(Index:LongInt;Item:TBitmap);
         Function IndexOfOrigin(Item:TBitmap):LongInt;
         Function AddResourceId(BmpId:LongWord):LongInt;
         Function AddResourceName(Const Name:String):LongInt;
         Property Bitmaps[Index:LongInt]:TBitmap Read GetBitmap Write SetBitmap;
         Property Duplicates:Boolean Read FDuplicates Write FDuplicates;
         Property BitmapClass:TBitmapClass Read FBitmapClass Write FBitmapClass;
    End;

    TResType=(rtBitmap,rtCursor,rtIcon);

    TImageType=(itImage,itMask);

    TOverlay = 0..3;

    TLoadResource=(lrDefaultColor, lrDefaultSize, lrFromFile,
                   lrMap3DColors, lrTransparent, lrMonoChrome);

    TLoadResources=Set Of TLoadResource;

    //Item for BitmapList property of TImageList class
    PImageItem=^TImageItem;
    TImageItem=Record
                     Bitmap:TBitmap;
                     Mask:TBitmap;
                     Icon:TIcon;
    End;

    TImageList=Class;

    TImageItemList=Class(TList)
       ImageList:TImageList;
    END;

    TImageList=Class(TComponent)
        Private
              FMasked:Boolean;
              FImageType:TImageType;
              FOnChange:TNotifyEvent;
              FList:TImageItemList;
        Private
              Function GetCount:LongInt;
              Procedure SetList(Item:TImageItemList);
        Protected
              Procedure Change;Virtual;
              Procedure Initialize;
              Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
              Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
              Function NewItem:PImageItem;Virtual;
              Procedure DisposeItem(Item:PImageItem);Virtual;
        Public
              Procedure SetupComponent;Override;
              Destructor Destroy;Override;
              Function Add(Image,Mask:TBitmap):LongInt;
              Function AddIcon(Image:TIcon):LongInt;
              Procedure AddImages(Value:TImageList);
              Procedure Clear;
              Procedure Delete(Index:LongInt);
              Procedure Draw(Canvas:TCanvas;X,Y,Index:LongInt);
              Procedure GetBitmap(Index:LongInt;Image:TBitmap);
              Procedure GetMask(Index:LongInt;Mask:TBitmap);
              Procedure GetIcon(Index: Integer;Icon:TIcon);
              Procedure Insert(Index:LongInt;Image,Mask:TBitmap);
              Procedure InsertIcon(Index:LongInt;Image:TIcon);
              Procedure Move(CurIndex,NewIndex:LongInt);
              Procedure Replace(Index:LongInt;Image,Mask:TBitmap);
              Procedure ReplaceIcon(Index:LongInt;Image:TIcon);
        Public
              Property Count:LongInt read GetCount;
        Published
              Property ImageType:TImageType read FImageType write FImageType;
              Property Masked:Boolean read FMasked write FMasked;
              Property OnChange: TNotifyEvent read FOnChange write FOnChange;
              Property BitmapList:TImageItemList read FList write SetList;stored False;
    End;

    TPicture=Class(TComponent)
       Private
           FGraphic:TGraphic;
           FOnChange:TNotifyEvent;
       Private
           Function GetBitmap:TBitmap;
           Function GetHeight:LongInt;
           Function GetIcon:TIcon;
           Function GetMetafile:TMetafile;
           Function GetWidth:LongInt;
           Procedure SetBitmap(Value: TBitmap);
           Procedure SetGraphic(Value: TGraphic);
           Procedure SetIcon(Value: TIcon);
           Procedure SetMetafile(Value: TMetafile);
           Function GetEmpty:Boolean;
       Protected
           Procedure Changed(Sender: TObject);
           Procedure AssignTo(Dest:TPersistent);Override;
       Public
           Destructor Destroy;Override;
           Procedure LoadFromFile(Const Filename:string);
           Procedure SaveToFile(Const Filename: string);
           Procedure ForceType(GraphicType:TGraphicClass);
       Public
           Function HasFormat(GraphicClass:TGraphicClass):Boolean;
           Procedure Assign(Source:TPersistent);Override;
       Public
           Property Empty:Boolean read GetEmpty;
           Property Bitmap:TBitmap read GetBitmap write SetBitmap;
           Property Graphic:TGraphic read FGraphic write SetGraphic;
           Property Height:LongInt read GetHeight;
           Property Icon:TIcon read GetIcon write SetIcon;
           Property Metafile:TMetafile read GetMetafile write SetMetafile;
           Property Width:LongInt read GetWidth;
           Property OnChange:TNotifyEvent read FOnChange write FOnChange;
    End;

Procedure DereferenceFont(FFont:TFont;CloseHandle:Boolean);
Procedure ReferenceFont(FFont:TFont);

{$IFDEF WIN32,W32}
Function EnumFontCallBackW32(Var lplf:LOGFONT;Var lptm:TEXTMETRIC;
                             nFontType:LongInt;Data:Pointer):LongInt;APIENTRY;
{$ENDIF}
Procedure SetupScreenCanvas(Canvas:TCanvas);
Procedure CreateControlFont(Canvas:TCanvas;NewFont:TFont);
Function ReadSCUFont(Var Data;DataLen:LongInt):TFont;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;

{$IFDEF OS2}
//operator overloads for TMatrix
Function MulMatrix(Const a,b:TMatrix):TMatrix; operator *;
Function AddMatrix(Const a,b:TMatrix):TMatrix; operator +;
Function SubMatrix(Const a,b:TMatrix):TMatrix; operator -;
Function MulMatrixInt1(Const a:TMatrix;b:LongInt):TMatrix; operator *;
Function MulMatrixExt1(Const a:TMatrix;Const b:Extended):TMatrix; operator *;
Function MulMatrixInt2(b:LongInt;Const a:TMatrix):TMatrix; operator *;
Function MulMatrixExt2(Const b:Extended;Const a:TMatrix):TMatrix; operator *;
{$ENDIF}

Implementation

Uses Forms, ClipBrd;

{$IFDEF OS2}
Function MulMatrix(Const a,b:TMatrix):TMatrix; //operator *;
  Begin
     Result.CreateIntern;
     Result.M11:=a.M11*b.M11+a.M12*b.M21+a.M13*b.M31;
     Result.M21:=a.M21*b.M11+a.M22*b.M21+a.M23*b.M31;
     Result.M31:=Round(a.M31*b.M11+a.M32*b.M21+a.M33*b.M31);

     Result.M12:=a.M11*b.M12+a.M12*b.M22+a.M13*b.M32;
     Result.M22:=a.M21*b.M12+a.M22*b.M22+a.M23*b.M32;
     Result.M32:=Round(a.M31*b.M12+a.M32*b.M22+a.M33*b.M32);

     Result.M13:=Round(a.M11*b.M13+a.M12*b.M23+a.M13*b.M33);
     Result.M23:=Round(a.M21*b.M13+a.M22*b.M23+a.M23*b.M33);
     Result.M33:=Round(a.M31*b.M13+a.M32*b.M23+a.M33*b.M33);
  End;

Function AddMatrix(Const a,b:TMatrix):TMatrix; //operator +;
  Begin
     Result.CreateIntern;
     Result.M11:=a.M11+b.M11;
     Result.M12:=a.M12+b.M12;
     Result.M13:=a.M13+b.M13;
     Result.M21:=a.M21+b.M21;
     Result.M22:=a.M22+b.M22;
     Result.M23:=a.M23+b.M23;
     Result.M31:=a.M31+b.M31;
     Result.M32:=a.M32+b.M32;
     Result.M33:=a.M33+b.M33;
End;

Function SubMatrix(Const a,b:TMatrix):TMatrix; //operator -;
  Begin
     Result.CreateIntern;
     Result.M11:=a.M11-b.M11;
     Result.M12:=a.M12-b.M12;
     Result.M13:=a.M13-b.M13;
     Result.M21:=a.M21-b.M21;
     Result.M22:=a.M22-b.M22;
     Result.M23:=a.M23-b.M23;
     Result.M31:=a.M31-b.M31;
     Result.M32:=a.M32-b.M32;
     Result.M33:=a.M33-b.M33;
  End;

Function MulMatrixInt1(Const a:TMatrix;b:LongInt):TMatrix; //operator *;
  Begin
     Result:=MulMatrixExt1(a,b);
  End;

Function MulMatrixExt1(Const a:TMatrix;Const b:Extended):TMatrix; //operator *;
  Begin
     Result.CreateIntern;
     Result.M11:=a.M11*b;
     Result.M12:=a.M12*b;
     Result.M13:=Round(a.M13*b);
     Result.M21:=a.M21*b;
     Result.M22:=a.M22*b;
     Result.M23:=Round(a.M23*b);
     Result.M31:=Round(a.M31*b);
     Result.M32:=Round(a.M32*b);
     Result.M33:=Round(a.M33*b);
  End;

Function MulMatrixInt2(b:LongInt;Const a:TMatrix):TMatrix; //operator *;
  Begin
     Result:=MulMatrixExt1(a,b);
  End;

Function MulMatrixExt2(Const b:Extended;Const a:TMatrix):TMatrix; //operator *;
  Begin
     Result:=MulMatrixExt1(a,b);
  End;
{$ENDIF}


Procedure CreateControlFont(Canvas:TCanvas;NewFont:TFont);
  Begin
    Canvas.FFontWidth:=0;
    Canvas.FFontHeight:=0;
    Canvas.FFontAttr:=[];
    {!!!! der ControlFont wird verndert !!!}
    Canvas.CreateFont(NewFont,True); //!!
  End;

Procedure SetupScreenCanvas(Canvas:TCanvas);
  Begin
     {$IFDEF OS2}
     GpiCreateLogColorTable(Canvas.Handle,LCOL_RESET,LCOLF_RGB,0,0,Nil);
     {$ENDIF}
     {$IFDEF WIN32}
     Canvas.FPenHandle:=CreatePen(PS_SOLID,0,0);  //Black solid Pen
     Canvas.FBrushHandle:=CreateSolidBrush(0);    //Black Brush
     {$ENDIF}
  End;

Procedure ReferenceFont(FFont:TFont);
  Begin
     inc(FFont.FUseCount);
  End;

Procedure DereferenceFont(FFont:TFont;CloseHandle:Boolean);
  Begin
     If FFont<>Nil Then
     Begin
          If CloseHandle Then
          Begin
              {$IFDEF Win32}
              If FFont.FHandle<>0 Then
              Begin
                   If FFont.FRefCount>1 Then Dec(FFont.FRefCount)
                   Else
                   Begin
                        DeleteObject(FFont.FHandle);
                        FFont.FHandle:=0;
                   End;
              End;
              {$ENDIF}
          End;
          
          If FFont.FUseCount>0 Then Dec(FFont.FUseCount);
          If ((FFont.FCustom)And(FFont.AutoDestroy)And(FFont.FUseCount=0)) Then
            FFont.Destroy;
     End;
  End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TBitmapCanvas Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TBitmapCanvas.CreateHandle;
Begin
    If FBitmap<>Nil Then FBitmap.CreateHandle;
End;

Procedure TBitmapCanvas.DestroyHandle;
Begin
     If FBitmap<>Nil Then FBitmap.DestroyHandle;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TBitmap Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBitmap.CreateHandle;
Begin
     If FIsInvalid Then exit; //don't create handle for invalid objects (loop) !
     fTransparentColor:=clTCNotDefined;

     {$IFDEF WIN32}
     If FBitmapHandle=0 Then If FBitmapMem<>Nil Then
     Begin
          If FBitmapPS<>0 Then DestroyHandle;
          SetupBitmap;
     End;
     If FBitmapHandle=0 Then InvalidImage;
     If FBitmapPS=0 Then
     Begin
         FBitmapPS:=CreateCompatibleDC(0);
         FOldBitmap:=SelectObject(FBitmapPS,FBitmapHandle);
     End;
     If FCanvas = Nil Then
     Begin
          FCanvas.Create(Self);
          FCanvas.FBitmap:=Self;
          Include(FCanvas.ComponentState, csDetail);
     End;
     If FCanvas.Handle<>FBitmapPS Then
     Begin
        FCanvas.Handle:=FBitmapPS;
        FCanvas.Init;
        RealizePalette(Nil);
     End;
     {$ENDIF}
End;

Procedure TBitmap.DestroyHandle;
Begin
     If PermanentHandle Then exit;

     {$IFDEF WIN32}
     If FBitmapPal<>0 Then
       If FBitmapPS<>0 Then SelectObject(FBitmapPS,FOldPalette);
     FOldPalette:=0;
     If FBitmapPS<>0 Then
     Begin
          SelectObject(FBitmapPS,FOldBitmap);
          If not DeleteDC(FBitmapPS) Then InvalidImage;
     End;
     FBitmapPS:=0;
     If FCanvas<>Nil Then FCanvas.Handle:=0;
     FOldBitmap:=0;
     If FBitmapHandle<>0 Then If not DeleteObject(FBitmapHandle) Then InvalidImage;
     FBitmapHandle:=0;
     {$ENDIF}
End;

Procedure TBitmap.DrawBitmapBits(SrcRec: TRect;Canvas: TCanvas;DstRec: TRect);
{$IFDEF OS2}
Var
  DC:     HDC;
  PS:     HPS;
  BM:     HBITMAP;
  Size:   SIZEL;
  Points: array[0..1] of TRect;
{$ENDIF}
Begin
  {$IFDEF OS2}
  If Canvas = nil Then Exit;

  DC := 0;
  PS := 0;

  Try
    DC := DevOpenDC(AppHandle, OD_MEMORY, '*', 0,Nil, GpiQueryDevice(Canvas.Handle));

    Size.CX := 0;
    Size.CY := 0;

    PS := GpiCreatePS(AppHandle, DC, Size,PU_PELS or GPIT_MICRO or GPIA_ASSOC);

    BM := Handle;
    Try
      GpiSetBitmap(Self.Canvas.Handle, 0);
      GpiSetBitmap(PS, BM);

      Points[0] := DstRec;
      Points[1] := SrcRec;

      GpiBitBlt(Canvas.Handle,
                PS,
                4,
                Points[0].LeftBottom,
                ROP_SRCCOPY,
                BBO_IGNORE);

    Finally
      GpiSetBitmap(PS, 0);
      GpiSetBitmap(Self.Canvas.Handle, BM);
    End;

  Finally
    If PS <> 0 Then GpiDestroyPS(PS);
    If DC <> 0 Then DevCloseDC(DC);
  End;
  {$ENDIF}
End;

{$HINTS OFF}
Function TBitmap.CreateMask(Color:TColor):TGraphic;
{$IFDEF OS2}
Var hdcMem,hpsMem:LongWord;
    szlHps:SIZEL;
    PMaskInfoHdr:BITMAPINFOHEADER2;
    PMaskImage:LongWord;
    PointsArray:ARRAY[0..3] OF TPoint;
{$ENDIF}
Begin
     {$IFDEF OS2}
     hdcMem:=DevOpenDC(AppHandle,OD_MEMORY,'*',0,NIL,0);
     IF hdcMem=0 THEN exit;

     szlHps.cx:=1;
     szlHps.cy:=1;
     hpsMem:=GpiCreatePS(AppHandle,hdcMem,szlHps,
                         PU_PELS OR GPIT_MICRO OR GPIA_ASSOC);
     IF hpsMem=0 THEN
     BEGIN
          DevCloseDC(hdcMem);
          exit;
     END;

     GpiSetBitmap(Canvas.Handle,0);
     PMaskInfoHdr.cbFix:=sizeOf(PMaskInfoHdr);
     GpiQueryBitmapInfoHeader(Handle,PMaskInfoHdr);
     PMaskInfoHdr.cPlanes:=1;
     PMaskInfoHdr.cBitCount:=1;

     PMaskImage:=GpiCreateBitmap(hpsMem,PMaskInfoHdr,0,NIL,NIL);
     IF PMaskImage=0 THEN
     BEGIN
         GpiDestroyPS(hpsMem);
         DevCloseDC(hdcMem);
         exit;
     END;

     GpiSetBitmap(hpsMem,PMaskImage);

     {Transform background bitmap to black and white}
     GpiCreateLogColorTable(hpsMem,LCOL_RESET,LCOLF_RGB,0,0,Nil);
     GpiSetColor(hpsMem,clWhite);
     GpiSetBackColor(hpsMem,clBlack);

     PointsArray[0].x:=0;
     PointsArray[0].y:=0;
     PointsArray[1].x:=Width;
     PointsArray[1].y:=Height;
     PointsArray[2].x:=0;
     PointsArray[2].y:=0;

     GpiWCBitBlt(hpsMem,Handle,3,PointsArray[0],ROP_SRCCOPY,BBO_IGNORE);
     GpiSetBitmap(Canvas.Handle,Handle);

     If Self Is TIcon Then result:=TIcon.Create
     Else If Self Is TPointer Then Result:=TPointer.Create
     Else result:=TBitmap.Create;
     TBitmap(result).LoadFromHandle(PMaskImage);

     GpiSetBitmap(hpsMem,0);
     GpiDeleteBitmap(PMaskImage);
     GpiDestroyPS(hpsMem);
     DevCloseDC(hdcMem);
     {$ENDIF}
End;
{$HINTS ON}

Var LastcbInfo:LongWord;

Procedure TBitmap.LoadFromHandle(AHandle:LongWord);
Var
   TheBitmapMem:^LongInt;
   TheBitmapMemLength:LongInt;
{$IFDEF OS2}
Var
   hdcDst:LongInt;
   hpsDst:LongInt;
   bmpTemp:BITMAPINFOHEADER2;
   sizl:SIZEL;
   HPS:LongWord;
   rclTemp:TRect;
   ptlDst:POINTL;
Label ex;
{$ENDIF}
{$IFDEF Win32}
Var
    BI:BitmapCoreInfo;
    pbi:^BitmapCoreInfo;
    P,pp:Pointer;
    cbInfo,cbBuffer:LongWord;
    BI2:BitmapInfo;
    ADC,MemDC:LongWord;
{$ENDIF}
Begin
     FIsInvalid:=False; //reset flag !
     ReleaseBitmap;

     {$IFDEF OS2}
     HPS:=WinGetPS(HWND_DESKTOP);

     bmpTemp.cbFix := SizeOf(BITMAPINFOHEADER2);
     GpiQueryBitmapInfoHeader(AHandle,bmpTemp);
     FBitmapHandle:=GpiCreateBitmap(HPS,bmpTemp,0,Nil,Nil);
     If FBitmapHandle=0 Then Exit;

     rclTemp.Left := 0;
     rclTemp.Right := bmpTemp.CX;
     rclTemp.Bottom := 0;
     rclTemp.Top := bmpTemp.CY;

     hdcDst := DevOpenDC(AppHandle,OD_MEMORY,'*',0,Nil,0);
     If hdcDst=0 Then
     Begin
          GpiDeleteBitmap(FBitmapHandle);
          Goto ex;  //Error
     End;

     sizl.CX := 1{bmpTemp.CX};
     sizl.CY := 1{bmpTemp.CY};
     hpsDst := GpiCreatePS(AppHandle, hdcDst, sizl,
                           PU_PELS Or GPIA_ASSOC Or GPIT_MICRO
                           {PU_PELS Or GPIF_DEFAULT Or GPIT_MICRO Or GPIA_ASSOC});
     If hpsDst=0 Then
     Begin
          GpiDeleteBitmap(FBitmapHandle);
          DevCloseDC(hdcDst);
          Goto ex; //Error
     End;

     //GpiSetBitmap(hpsSrc, hbmSrc);
     GpiSetBitmap(hpsDst, FBitmapHandle);
     FBitmapPS:=hpsDst;

     ptlDst.X:=0;
     ptlDst.Y:=0;
     WinDrawBitmap(hpsDst,AHandle,Nil,ptlDst,0,0,DBM_NORMAL Or DBM_IMAGEATTRS);
     Update;

     GpiSetBitmap(hpsDst,0);
     GpiDestroyPS(hpsDst);
     FBitmapPS:=0;
     DevCloseDC(hdcDst);
     GpiDeleteBitmap(FBitmapHandle);
     FBitmapHandle:=0;

     TheBitmapMem:=FBitmapMem;
     FBitmapMem:=Nil;
     TheBitmapMemLength:=FBitmapMemLength;
     FBitmapMemLength:=0;
     FBitmapHandle:=0;
     FBitmapPS:=0;
     If TheBitmapMemLength>0 Then
     Begin
          LoadFromMem(TheBitmapMem^,TheBitmapMemLength);
          FreeMem(TheBitmapMem,TheBitmapMemLength);
     End;
ex:
     WinReleasePS(HPS);
     {$ENDIF}
     {$IFDEF WIN32}
     ADC:=GetDC(0);
     MemDC:=CreateCompatibleDC(ADC);

     FillChar(BI,SizeOf(BI),0);

     FillChar(BI2,SizeOf(BI2),0);
     BI2.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(ADC,AHandle,0,0,Nil,BI2,0);
     If FOrigBitCount>0 Then BI2.bmiHeader.biBitCount:=FOrigBitCount;
     If FOrigPlanes>0 Then BI2.bmiHeader.biPlanes:=FOrigPlanes;

     cbInfo:=SizeOf(BitmapCoreHeader)+SizeOf(RGBTriple)*(longword(1) Shl BI2.bmiHeader.biBitCount);
     LastcbInfo:=cbInfo;
     GetMem(pbi,cbInfo);
     With pbi^.bmciHeader Do
     Begin
          bcSize:=SizeOf(BitmapCoreHeader);
          bcWidth:=BI2.bmiHeader.biWidth;
          bcHeight:=BI2.bmiHeader.biHeight;
          bcPlanes:=BI2.bmiHeader.biPlanes;
          bcBitCount:=BI2.bmiHeader.biBitCount;
     End;
     cbBuffer:=(((BI2.bmiHeader.biBitCount*BI2.bmiHeader.biWidth)+31) Div 32)
                *4*BI2.bmiHeader.biHeight*BI2.bmiHeader.biPlanes;
     GetMem(P,cbBuffer);
     GetDIBits(ADC,AHandle,0,BI2.bmiHeader.biHeight,P^,pbi^,DIB_RGB_COLORS);

     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=cbInfo+cbBuffer;
     GetMem(FBitmapMem,FBitmapMemLength);
     pp:=FBitmapMem;
     Move(pbi^,pp^,cbInfo);
     Inc(pp,cbInfo);
     Move(P^,pp^,cbBuffer);

     FreeMem(pbi,cbInfo);
     FreeMem(P,cbBuffer);

     If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
     If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;
     {$ENDIF}

     FBitmapHandle:=0;

     TheBitmapMem:=FBitmapMem;
     FBitmapMem:=Nil;
     TheBitmapMemLength:=FBitmapMemLength;
     FBitmapMemLength:=0;
     FBitmapHandle:=0;
     FBitmapPS:=0;
     If TheBitmapMemLength>0 Then
     Begin
          LoadFromMem(TheBitmapMem^,TheBitmapMemLength);
          FreeMem(TheBitmapMem,TheBitmapMemLength);
     End;
End;

Function TBitmap.LoadFromClipBoard:Boolean;
Var hbmClipbrd:LongWord;
Begin
     FIsInvalid:=False; //reset flag !

     Result:=False;
     Clipboard.Open(Handle);
     If Clipboard.IsFormatAvailable(cfBitmap) Then
     Begin
          hbmClipbrd:=Clipboard.GetAsHandle(cfBitmap);
          If hbmClipbrd<>0 Then
          Begin
               LoadFromHandle(hbmClipbrd);
               Result:=Not Empty;
          End;
     End;

     Clipboard.Close;
End;

Procedure TBitmap.Assign(Source:TPersistent);
Begin
     If Source Is TBitmap Then LoadFromBitmap(TBitmap(Source))
     Else Inherited Assign(Source);
End;

Procedure TBitmap.CopyToClipboard(Const Src:TRect);
{$IFDEF OS2}
Var HPS:LongWord;
    bmpClipbrd:BITMAPINFOHEADER2;
    rclClipbrd:TRect;
    hbmClipbrd:HBITMAP;
    hpsDst,hdcDst:LongWord;
    bmp:BITMAPINFOHEADER2;
    sizl:SIZEL;
    aptl:Array[0..3] Of POINTL;
{$ENDIF}
{$IFDEF WIN32}        
Var hbmClipBrd: HBITMAP;
    ScreenDC  : HDC;
    hdcDst    : HDC;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If Handle=0 Then Exit;

     HPS:=WinGetPS(HWND_DESKTOP);

     bmpClipbrd.cbFix := SizeOf(BITMAPINFOHEADER2);
     GpiQueryBitmapInfoHeader(Handle,bmpClipbrd);
     bmpClipbrd.CX:=Src.Right-Src.Left;
     bmpClipbrd.CY:=Src.Top-Src.Bottom;
     hbmClipbrd:=GpiCreateBitmap(HPS,bmpClipbrd,0,Nil,Nil);
     If hbmClipbrd=0 Then Exit;

     rclClipbrd.Left := 0;
     rclClipbrd.Right := bmpClipbrd.CX;
     rclClipbrd.Bottom := 0;
     rclClipbrd.Top := bmpClipbrd.CY;

     hdcDst := DevOpenDC(AppHandle,OD_MEMORY,'*',0,Nil,0);
     If hdcDst=0 Then
     Begin
          GpiDeleteBitmap(hbmClipbrd);
          WinReleasePS(HPS);
          exit;
     End;

     bmp.cbFix := SizeOf(BITMAPINFOHEADER2);
     GpiQueryBitmapInfoHeader(hbmClipbrd, bmp);
     sizl.CX := 1{bmp.CX};
     sizl.CY := 1{bmp.CY};
     hpsDst := GpiCreatePS(AppHandle, hdcDst, sizl,
                           PU_PELS Or GPIA_ASSOC Or GPIT_MICRO
                           {PU_PELS Or GPIF_DEFAULT Or GPIT_MICRO Or GPIA_ASSOC});
     If hpsDst=0 Then
     Begin
          GpiDeleteBitmap(hbmClipbrd);
          DevCloseDC(hdcDst);
          WinReleasePS(HPS);
          exit;
     End;

     //GpiSetBitmap(hpsSrc, hbmSrc);
     GpiSetBitmap(hpsDst, hbmClipbrd);

     aptl[0].X := rclClipbrd.Left;
     aptl[0].Y := rclClipbrd.Bottom;
     aptl[1].X := rclClipbrd.Right;
     aptl[1].Y := rclClipbrd.Top;
     aptl[2].X := Src.Left;
     aptl[2].Y := Src.Bottom;
     aptl[3].X := Src.Right;
     aptl[3].Y := Src.Top;

     If ((aptl[1].X-aptl[0].X=aptl[3].X-aptl[2].X)And
         (aptl[1].Y-aptl[0].Y=aptl[3].Y-aptl[2].Y)) Then
       GpiBitBlt(hpsDst,Canvas.Handle,3,aptl[0],ROP_SRCCOPY,BBO_IGNORE)
     Else
       GpiBitBlt(hpsDst,Canvas.Handle,4,aptl[0],ROP_SRCCOPY,BBO_IGNORE);

     GpiSetBitmap(hpsDst,0);
     GpiDestroyPS(hpsDst);
     DevCloseDC(hdcDst);
     {$ENDIF}
     {$IFDEF Win32}
     CreateHandle;
     ScreenDC:=GetDC(0);
     If ScreenDC=0 Then exit;
     hdcDst:=CreateCompatibleDC(ScreenDC);
     If hdcDst=0 Then
     Begin
         ReleaseDC(0,ScreenDC);
         exit;
     End;
     hbmClipBrd:=CreateCompatibleBitmap(ScreenDC,Width,Height);
     if hbmClipBrd=0 Then
     Begin
         ReleaseDC(0,ScreenDC);
         exit;
     End;
     SelectObject(hdcDst,hbmClipBrd);
     WinGDI.BitBlt(hdcDst,0,0,Width,Height,FBitmapPS,0,0,SRCCOPY);
     DeleteDC(hdcDst);
     ReleaseDC(0,ScreenDC);
     {$ENDIF}

     Clipboard.Open(0);
     Clipboard.Empty;
     Clipboard.SetAsHandle(cfBitmap,hbmClipBrd);
     Clipboard.Close;
End;

Procedure TBitmap.SetupComponent;
Begin
  Inherited SetupComponent;

  FEmpty:=True;
  FBitmapHandle:=0;
  FBitmapPS:=0;
  FBitmapDC:=0;
End;

Procedure TBitmap.changed;
Begin
  Inherited changed;
  If Owner Is TControl Then TControl(Owner).Invalidate;
End;

Procedure TBitmap.PaletteChanged;
Begin
  {$IFDEF OS2}
  If FBitmapPal<>0 Then GpiDeletePalette(FBitmapPal);
  {$ENDIF}
  {$IFDEF Win32}
  If FBitmapPal<>0 Then DeleteObject(FBitmapPal);
  {$ENDIF}

  FBitmapPal:=Canvas.Palette.Handle;
End;

Procedure TBitmap.ReleaseBitmap;
Begin
     FEmpty:=True;

     If FCanvas<>Nil Then
     Begin
          FCanvas.Handle:=0;
          FCanvas.Destroy;
          FCanvas:=Nil;
     End;

     {$IFDEF OS2}
     If FBitmapPal<>0 Then GpiDeletePalette(FBitmapPal);
     If FBitmapHandle<>0 Then
     Begin
        If FBitmapPS<>0 Then GpiSetBitmap(FBitmapPS,0);
        GpiDeleteBitmap(FBitmapHandle);
     End;
     If FBitmapPS<>0 Then GpiDestroyPS(FBitmapPS);
     If FBitmapDC<>0 Then DevCloseDC(FBitmapDC);
     {$ENDIF}
     {$IFDEF Win32}
     If FBitmapPS<>0 Then
     Begin
          If FBitmapHandle<>0 Then SelectObject(FBitmapPS,FOldBitmap);
          If FBitmapPal<>0 Then SelectObject(FBitmapPS,FOldPalette);
     End;
     If FBitmapPS<>0 Then If not DeleteDC(FBitmapPS) Then InvalidImage;
     If FBitmapPal<>0 Then If not DeleteObject(FBitmapPal) Then InvalidImage;
     If FBitmapHandle<>0 Then If not DeleteObject(FBitmapHandle) Then InvalidImage;
     {$ENDIF}

     FBitmapPS:=0;
     FBitmapPal:=0;
     FBitmapHandle:=0;
     FBitmapDC:=0;

     If FBitmapMemLength<>0 Then
       If FBitmapMem<>Nil Then
     Begin
          FreeMem(FBitmapMem,FBitmapMemLength);
          FBitmapMem:=Nil;
          FBitmapMemLength:=0;
     End;
End;


Destructor TBitmap.Destroy;
Begin
  ReleaseBitmap;
  Inherited Destroy;
End;

Function TBitmap.GetHandle:LongWord;
Begin
  If FBitmapHandle=0 Then If FBitmapMem<>Nil Then SetupBitmap;
  Result:=FBitmapHandle;
End;

Function TBitmap.GetSize;
Begin
  Result:=FBitmapMemLength;
End;

Function TBitmap.GetCanvas:TCanvas;
Begin
     If FBitmapPS=0 Then CreateHandle;

     If FCanvas = Nil Then
     Begin
          FCanvas.Create(Self);
          FCanvas.FBitmap:=Self;
          Include(FCanvas.ComponentState, csDetail);
          FCanvas.Handle := FBitmapPS;
          FCanvas.Init;
     End
     Else
     Begin
          If FCanvas.Handle<>FBitmapPS Then
          Begin
               FCanvas.Handle:=FBitmapPS;
               FCanvas.Init;
          End;
     End;
     Result := FCanvas;
End;

Procedure TBitmap.DrawDisabled(Canvas:TCanvas;Const Dest:TRect);
Var  OldLineWidth:LongInt;
     OldLineType:TPenStyle;
     OldBkMode:TBrushMode;
     OldColor:TColor;
     L:LongInt;
     {$IFDEF Win32}
     OldPal:LongWord;
     {$ENDIF}
Begin
     If Empty Then Exit;

     {$IFDEF OS2}
     {OldPal:=GpiQueryPalette(Canvas.Handle);
     If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,FBitmapPal);}
     {$ENDIF}
     {$IFDEF Win32}
     OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);
     {$ENDIF}

     Draw(Canvas,Dest);

     OldLineWidth:=Canvas.Pen.Width;
     OldLineType:=Canvas.Pen.Style;
     OldBkMode:=Canvas.Brush.Mode;
     OldColor:=Canvas.Pen.color;

     If Canvas.Control<>Nil {typecast To have access To BackColor}
     Then Canvas.Pen.color:=TForm(Canvas.Control).Color;
     Canvas.Pen.Width:=1;
     Canvas.Brush.Mode:=bmTransparent;
     {$IFDEF OS2}
     Canvas.Pen.Style:=psDot;
     {$ENDIF}
     {$IFDEF Win32}
     Canvas.Pen.Style:=psDash;
     {$ENDIF}
     For L:=Dest.Left To Dest.Right Do
     Begin
          Canvas.Line(L,Dest.Bottom,L,Dest.Top);
          {$IFDEF Win32}
          Inc(L);
          {$ENDIF}
     End;

     Canvas.Pen.Width:=OldLineWidth;
     Canvas.Pen.Style:=OldLineType;
     Canvas.Brush.Mode:=OldBkMode;
     Canvas.Pen.color:=OldColor;

     {$IFDEF Win32}
     If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);
     {$ENDIF}
     {$IFDEF OS2}
     {If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,OldPal);}
     {$ENDIF}
End;


Procedure TBitmap.Draw(Canvas:TCanvas;Const Dest:TRect);
{$IFDEF Win32}
Var  _Dest:TRect;
    OldPal:LongWord;
    OK : boolean;
    bi : BITMAPINFO;
    bp : Pointer;
    bh : HBITMAP;
{$ENDIF}
{$IFDEF OS2}
Var  Src:TRect;
     ptls:Array[0..3] Of TPoint;
{$ENDIF}

Begin
  Application.Logwriteln ('Bitmap.Draw auf Canvas '+tostr(longword(Canvas)));
  If Empty Then Exit;
  {$IFDEF OS2}
  If Canvas.NonDisplayDevice Then
  Begin
       Src.Left:=0;
       Src.Right:=Width;
       Src.Bottom:=0;
       Src.Top:=Height;
       DrawBitmapBits(Src,Canvas,Dest);
       exit;
  End;

  ptls[0].X:=Dest.Left;
  ptls[0].Y:=Dest.Bottom;
  ptls[1].X:=Dest.Right;
  ptls[1].Y:=Dest.Top;
  ptls[2].X:=0;
  ptls[2].Y:=0;
  ptls[3].X:=FWidth;
  ptls[3].Y:=FHeight;
  {OldPal:=GpiQueryPalette(Canvas.Handle);
  If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,FBitmapPal);}
  GpiBitBlt(Canvas.Handle,FBitmapPS,4,ptls[0],ROP_SRCCOPY,BBO_IGNORE);
  {If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,OldPal);}
  {$ENDIF}
  {$IFDEF Win32}
  CreateHandle;
  OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);

     {Martin0108}
     _Dest := Dest;
     TransformClientRect (_Dest, Canvas.OwnerObject);

     If (_Dest.Right-_Dest.Left+1=FWidth) And (_Dest.Bottom-_Dest.Top+1=FHeight) Then
     Begin
          WinGDI.BitBlt(Canvas.Handle,_Dest.Left,_Dest.Top,
                        FWidth,FHeight,FBitmapPS,0,0,SRCCOPY);
     End
     Else
     Begin

        {Martin0108}
        //korrigiert die Farben des Bitmaps beim Ausdruck, ist sonst zu klecksig, fast weiss erscheint grau
        SetStretchBltMode (Canvas.Handle, (*STRETCH_DELETESCANS*)COLORONCOLOR);

        if not {OK}StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Top,
                     _Dest.Right-_Dest.Left+1,_Dest.Bottom-_Dest.Top+1,
                     FBitmapPS, 0, 0, FWidth, FHeight,SRCCOPY) then begin

            {Martin0108}
              {StretchBlt failed because Postscript Device Context does not support StretchBlt;
               BitBlt works, but shows bitmap in wrong size}
            bi.bmiheader.biSize := sizeof(bi.bmiheader);
            bi.bmiheader.biWidth := FWidth;//_Dest.Right-_Dest.Left+1;
            bi.bmiheader.biHeight := FHeight;//_Dest.Bottom-_Dest.Top+1;
            bi.bmiheader.biPlanes := 1;
            bi.bmiheader.biBitCount := 32;
            bi.bmiheader.biCompression := BI_RGB;
            bi.bmiheader.biSizeImage := 0;
            bi.bmiheader.biXPelsPerMeter := 0;
            bi.bmiheader.biYPelsPerMeter := 0;
            bi.bmiheader.biClrUsed := 0;
            bi.bmiheader.biClrImportant := 0;
            getmem (bp, bi.bmiheader.biWidth*bi.bmiheader.biHeight*4);
            bh := Handle;
            GetDIBits(self.Canvas.Handle, bh, 0, bi.bmiheader.biHeight, bp^, bi, DIB_RGB_COLORS);
            StretchDIBits (Canvas.Handle,
              {destination} _Dest.Left, _Dest.Top, _Dest.Right-_Dest.Left+1,_Dest.Bottom-_Dest.Top+1,
              {source} 0, 0, FWidth, FHeight,
              {bits} bp^,
              {bitsinfo} bi,
              {usage} DIB_RGB_COLORS (*DIB_PAL_COLORS*),
              {rop} SRCCOPY);
            freemem (bp, bi.bmiheader.biWidth*bi.bmiheader.biHeight*4);

        end;
     End;

  If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);
  DestroyHandle;
  {$ENDIF}
  fTransparentColor:=Canvas.Pixels[0,0];
End;

Procedure TBitmap.PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);
{$IFDEF OS2}
Var  ptls:Array[0..3] Of TPoint;
{$ENDIF}
{$IFDEF Win32}
Var  OldPal:LongWord;
     _Src,_Dest:TRect;

  Procedure SourceRectToWin32(Var rec:TRect;OwnerHeight:LongInt);
  Begin
       rec.Bottom:=(OwnerHeight-rec.Bottom);
       rec.Top:=(OwnerHeight-rec.Top);
  End;
{$ENDIF}
Begin
     If Empty Then Exit;
     {$IFDEF OS2}
     If Canvas.NonDisplayDevice Then
     Begin
          DrawBitmapBits(Src,Canvas,Dest);
          exit;
     End;
     ptls[0].X:=Dest.Left;
     ptls[0].Y:=Dest.Bottom;
     ptls[1].X:=Dest.Right;
     ptls[1].Y:=Dest.Top;
     ptls[2].X:=Src.Left;
     ptls[2].Y:=Src.Bottom;
     ptls[3].X:=Src.Right;
     ptls[3].Y:=Src.Top;
     {OldPal:=GpiQueryPalette(Canvas.Handle);
     If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,FBitmapPal);}
     GpiBitBlt(Canvas.Handle,FBitmapPS,4,ptls[0],ROP_SRCCOPY,BBO_IGNORE);
     {If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,OldPal);}
     {$ENDIF}
     {$IFDEF Win32}
     CreateHandle;
     OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);

     _Dest := Dest;
     RectToWin32Rect(_Dest);
     TransformRectToWin32(_Dest,TControl(Canvas.Control),Canvas.Graphic);

     _Src := Src;
     RectToWin32Rect(_Src);
     SourceRectToWin32(_Src,FHeight);
     StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                _Dest.Right-_Dest.Left,_Dest.Top-_Dest.Bottom,
                FBitmapPS,_Src.Left,_Src.Bottom,
                _Src.Right-_Src.Left,_Src.Top-_Src.Bottom,SRCCOPY);

     If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);
     DestroyHandle;
     {$ENDIF}
End;

Function TBitmap.GetEmpty:Boolean;
Begin
  GetEmpty:=FEmpty;
End;

{Martin} {deleted: tBitmap.GetHeight... (4 procedures and functions, moved to tGraphic)}

Procedure TBitmap.LoadFromBitmap(Bitmap:TBitmap);
Begin
     FIsInvalid:=False; //reset flag !

     If Bitmap = Nil Then Exit;
     If Bitmap.FBitmapMem = Nil Then Exit;
     If Bitmap.FBitmapMemLength = 0 Then Exit;
{
evtl wieder ndern (falsch wenn Bitmap modifiziert durch Canvas)
     BitmapStream.Create;
     BitmapStream.SetSize(Bitmap.FBitmapMemLength);
     Bitmap.SaveToStream(BitmapStream);
     BitmapStream.Position := 0;
     LoadFromStream(BitmapStream);
     BitmapStream.Destroy;
     FOrigin := Bitmap;
}
     LoadFromMem(Bitmap.FBitmapMem^,Bitmap.FBitmapMemLength);
End;


Function TBitmap.Copy:TBitmap;
Var  locClass:TBitmapClass;
Begin
     locClass := ClassType;
     Result := locClass.Create;
     If Owner<>Nil Then
     Begin
         Result.Owner:=Owner;
         Owner.InsertComponent(Result);
     End;
     Result.LoadFromBitmap(Self);
End;

Function TBitmap.CopyGraphic:TGraphic;
Begin
     Result:=Self.Copy
End;

{$IFDEF OS2}
{$HINTS OFF}
Procedure TBitmap.RealizePalette(Canvas:TCanvas);
Begin
End;
{$HINTS ON}

Procedure TBitmap.SetupBitmapColors(Header:Pointer;Mask:Boolean);
Type MyPRGB2=^PMyRGB2;
     PMyRGB2=Array[0..0] Of RGB2;
Var
   pbi2:PBITMAPINFO2;
   bIs1xFormat,bIs24BitColor:Boolean;
   pbi:PBITMAPINFO;
   lColorCount:LongInt;
   apRGB2:MyPRGB2;
   aNewRGB:MyPRGB2;
   I:LongInt;
   pal:LongWord;
Begin
     pbi2:=Header;
     bIs1xFormat := pbi2^.cbFix=SizeOf(BITMAPINFOHEADER);

     {Get Colors Of Bitmap}
     If bIs1xFormat Then
     Begin
           pbi := Pointer(pbi2);
           lColorCount:= pbi^.cPlanes * (LongWord(1) Shl pbi^.cBitCount);
           bIs24BitColor:=pbi^.cBitCount=24;
           If Not Mask Then
           Begin
               FOrigPlanes:=pbi^.cPlanes;
               FOrigBitCount:=pbi^.cBitCount;
           End;
     End
     Else
     Begin
           If ((pbi2^.cbFix>64)And(pbi2^.cclrUsed>0)) Then lColorCount:=pbi2^.cclrUsed
           Else lColorCount:=LongWord(pbi2^.cPlanes) * (LongWord(1) Shl pbi2^.cBitCount);
           bIs24BitColor:=pbi2^.cBitCount=24;
           If Not Mask Then
           Begin
              FOrigPlanes:=pbi2^.cPlanes;
              FOrigBitCount:=pbi2^.cBitCount;
           End;
     End;

     If Mask Then TIcon(Self).FMaskColorCount:=lColorCount
     Else FColorCount:=lColorCount;

     (*
     If lColorCount<=16 Then
     Begin
          If Mask Then TIcon(Self).FMaskPal:=0
          Else FBitmapPal:=0;
          Exit; {??} {Create no Palette !}
     End;
     *)

     If Not CreatePalette Then
     Begin
          If Mask Then TIcon(Self).FMaskPal:=0
          Else FBitmapPal:=0;
          Exit;
     End;

     {Convert 1X color Table (RGB) To 2X format (RGB2)}
     If bIs1xFormat Then
     Begin
          GetMem(apRGB2,lColorCount*SizeOf(RGB2));
          pbi:=Pointer(pbi2);
          For I:=0 To lColorCount-1 Do
          Begin
               apRGB2^[I].bRed := pbi^.argbColor[I].bRed ;
               apRGB2^[I].bGreen := pbi^.argbColor[I].bGreen ;
               apRGB2^[I].bBlue := pbi^.argbColor[I].bBlue ;
               apRGB2^[I].fcOptions := 0 ;
          End;
          GetMem(aNewRGB,(lColorCount)*SizeOf(RGB2));
          Move(apRGB2^,aNewRGB^[0],lColorCount*SizeOf(RGB2));
          FreeMem(apRGB2,lColorCount*SizeOf(RGB2));
          apRGB2:=aNewRGB;
     End
     Else
     Begin
         apRGB2:=Pointer(pbi2);
         Inc(apRGB2,pbi2^.cbFix);
         GetMem(aNewRGB,(lColorCount)*SizeOf(RGB2));
         Move(apRGB2^,aNewRGB^[0],lColorCount*SizeOf(RGB2));
         apRGB2:=aNewRGB;
     End;

     {Create A custom color Palette from color Info}
     pal := GpiCreatePalette(AppHandle,
                             0{LCOL_OVERRIDE_DEFAULT_COLORS},
                             LCOLF_CONSECRGB,
                             lColorCount,
                             apRGB2^);

     If Mask Then TIcon(Self).FMaskColorCount:=lColorCount
     Else FColorCount:=lColorCount;

     If Mask Then TIcon(Self).FMaskPal:=pal
     Else FBitmapPal:=pal;

     {Set the Palette into ps before Bitmap creation}
     If Mask Then
     Begin
          If GpiSelectPalette(TIcon(Self).FMaskPS,TIcon(Self).FMaskPal) = PAL_ERROR Then InvalidImage;
     End
     Else
     Begin
          {GpiCreateLogColorTable(FBitmapPS,0,LCOLF_RGB,0,FColorCount,apRGB2^);}
          If GpiSelectPalette(FBitmapPS,FBitmapPal) = PAL_ERROR Then InvalidImage;
          GpiCreateLogColorTable(FBitmapPS,0,LCOLF_RGB,0,0,Nil);
     End;

     FreeMem(apRGB2,lColorCount*SizeOf(RGB2));
End;
{$ENDIF}

{$IFDEF Win32}
Procedure TBitmap.RealizePalette(Canvas:TCanvas);
Begin
     If FBitmapHandle=0 Then CreateHandle;
     If FBitmapPal<>0 Then
     Begin
          If Canvas=Nil Then
          Begin
               FOldPalette:=SelectPalette(FBitmapPS,FBitmapPal,True);
               WinGDI.RealizePalette(FBitmapPS);
          End
          Else
          Begin
               SelectPalette(Canvas.Handle,FBitmapPal,True);
               WinGDI.RealizePalette(Canvas.Handle);
          End;
     End;
End;

Procedure TBitmap.SetupBitmapColors(Header:Pointer;Mask:Boolean);
Var Size,Size0,Size1:LongWord;
    PBC:^BitmapCoreHeader;
    pbi:^BITMAPINFOHEADER;
    BitmapInfo:PBitmapCoreInfo;
    P:^Byte;
    Colors,T:LongInt;
    DestPal:PLogPalette;
    BitmapInfo1:PBITMAPINFO;
    ADC,MemDC:HDC;
    SysPalSize:LongInt;
    I:LongInt;
    FTempBmp,FOldTempBmp:LongWord;

Label Win;
Begin
     If Not (Self Is TIcon) Then
     Begin
          PBC:=Header;
          If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then
          Begin
               {OS2 Bitmap}
               if PBC^.bcBitCount > 16 then
                 Begin   // Bei 24 oder mehr Farben gibt es keine Palette
                   Colors:=longword(1) Shl PBC^.bcBitCount;
                   FColorCount:=Colors;
                   If Not Mask Then
                   Begin
                      FOrigBitCount:=PBC^.bcBitCount;
                      FOrigPlanes:=PBC^.bcPlanes;
                   End;
                   exit;
                 End;
               Size:=(longword(1) Shl PBC^.bcBitCount) * SizeOf(RGBTriple);
               Size0:=Size + SizeOf(BitmapCoreInfo);
               GetMem(BitmapInfo,Size0);
               BitmapInfo^.bmciHeader:=PBC^;
               P:=Header;
               Inc(P,SizeOf(BitmapCoreHeader));
               Move(P^,BitmapInfo^.bmciColors,Size);
               Colors:=longword(1) Shl PBC^.bcBitCount;
               FColorCount:=Colors;
               If Not Mask Then
               Begin
                  FOrigBitCount:=PBC^.bcBitCount;
                  FOrigPlanes:=PBC^.bcPlanes;
               End;

               If Colors<=2 Then
               Begin
                    If Mask Then TIcon(Self).FMaskPal:=0
                    Else FBitmapPal:=0;
                    Exit;
               End;

               Size1 := SizeOf(LogPalette) + ((Colors - 1) * SizeOf(PaletteEntry));
               GetMem(DestPal,Size1);
               FillChar(DestPal^,Size1,0);
               With DestPal^ Do
               Begin
                    palVersion := $300;
                    palNumEntries := Colors;

                    For T:=0 To Colors - 1 Do
                    Begin
                         If BitmapInfo^.bmciColors[T].rgbtRed=204 Then
                           If BitmapInfo^.bmciColors[T].rgbtGreen=204 Then
                            If BitmapInfo^.bmciColors[T].rgbtBlue=204 Then
                            Begin
                                 BitmapInfo^.bmciColors[T].rgbtRed:=192;
                                 BitmapInfo^.bmciColors[T].rgbtGreen:=192;
                                 BitmapInfo^.bmciColors[T].rgbtBlue:=192;
                            End;

                            palPalEntry[T].peRed := BitmapInfo^.bmciColors[T].rgbtRed;
                            palPalEntry[T].peGreen := BitmapInfo^.bmciColors[T].rgbtGreen;
                            palPalEntry[T].peBlue := BitmapInfo^.bmciColors[T].rgbtBlue;
                            palPalEntry[T].peFlags := 0;
                    End;
               End;
               Move(BitmapInfo^.bmciColors,P^,Size);
               If Mask Then TIcon(Self).FMaskPal:=WinGDI.CreatePalette(DestPal^)
               Else FBitmapPal:=WinGDI.CreatePalette(DestPal^);

               FreeMem(DestPal,Size1);
               FreeMem(BitmapInfo,Size0);
          End
          Else If PBC^.bcSize=SizeOf(BITMAPINFOHEADER) Then
          Begin
               {Win Bitmap}
               pbi:=Pointer(PBC);
Win:
               if pbi^.biBitCount > 16 then
                 Begin   // Bei 24 oder mehr Farben gibt es keine Palette
                   Colors:=longword(1) Shl pbi^.biBitCount;
                   FColorCount:=Colors;
                   If Not Mask Then
                   Begin
                      FOrigBitCount:=pbi^.biBitCount;
                      FOrigPlanes:=pbi^.biPlanes;
                   End;
                   exit;
                 end;
               Size:=(longword(1) Shl pbi^.biBitCount) * SizeOf(RGBQuad);
               Size0:=Size+SizeOf(BITMAPINFOHEADER);
               GetMem(BitmapInfo1,Size0);
               BitmapInfo1^.bmiHeader:=pbi^;
               P:=Header;
               Inc(P,SizeOf(BITMAPINFOHEADER));
               Move(P^,BitmapInfo1^.bmiColors,Size);
               Colors:=longword(1) Shl pbi^.biBitCount;
               FColorCount:=Colors;
               If Not Mask Then
               Begin
                   FOrigPlanes:=pbi^.biPlanes;
                   FOrigBitCount:=pbi^.biBitCount;
               End;

               If Colors<=2 Then
               Begin
                    If Mask Then TIcon(Self).FMaskPal:=0
                    Else FBitmapPal:=0;
                    Exit;
               End;

               Size1:=SizeOf(LogPalette)+((Colors-1)*SizeOf(PaletteEntry));
               GetMem(DestPal,Size1);
               FillChar(DestPal^,Size1,0);

               With DestPal^ Do
               Begin
                    palVersion := $300;
                    palNumEntries := Colors;

                    ADC:=GetDC(0);
                    MemDC:=CreateCompatibleDC(ADC);
                    FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
                    FOldTempBmp:=SelectObject(MemDC,FTempBmp);

                    SysPalSize := GetDeviceCaps(MemDC, SIZEPALETTE);
                    If ((Colors=16)And(SysPalSize>=16)) Then
                    Begin
                         GetSystemPaletteEntries(MemDC,0,8,palPalEntry[0]);
                         I := 8;
                         GetSystemPaletteEntries(MemDC,SysPalSize-I,I,palPalEntry[I]);
                         For T:=0 To 7 Do
                         Begin
                              If palPalEntry[T].peRed=204 Then
                              If palPalEntry[T].peGreen=204 Then
                                If palPalEntry[T].peBlue=204 Then
                                Begin
                                     palPalEntry[T].peRed:=192;
                                     palPalEntry[T].peGreen:=192;
                                     palPalEntry[T].peBlue:=192;
                                End;
                         End;
                    End
                    Else
                    Begin
                         For T:=0 To Colors-1 Do
                         Begin
                             If BitmapInfo1^.bmiColors[T].rgbRed=204 Then
                               If BitmapInfo1^.bmiColors[T].rgbGreen=204 Then
                                 If BitmapInfo1^.bmiColors[T].rgbBlue=204 Then
                               Begin
                                    BitmapInfo1^.bmiColors[T].rgbRed:=192;
                                    BitmapInfo1^.bmiColors[T].rgbGreen:=192;
                                    BitmapInfo1^.bmiColors[T].rgbBlue:=192;
                               End;

                               palPalEntry[T].peRed:=BitmapInfo1^.bmiColors[T].rgbRed;
                               palPalEntry[T].peGreen:=BitmapInfo1^.bmiColors[T].rgbGreen;
                               palPalEntry[T].peBlue:=BitmapInfo1^.bmiColors[T].rgbBlue;
                               palPalEntry[T].peFlags := 0;
                         End;
                    End;

                    SelectObject(MemDC,FOldTempBmp);
                    If not DeleteObject(FTempBmp) Then InvalidImage;
                    If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
                    If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;
               End;
               Move(BitmapInfo1^.bmiColors,P^,Size);
               If Mask Then TIcon(Self).FMaskPal:=WinGDI.CreatePalette(DestPal^)
               Else FBitmapPal:= WinGDI.CreatePalette(DestPal^);

               FreeMem(DestPal,Size1);
               FreeMem(BitmapInfo1,Size0);
          End
          Else InvalidImage;
     End
     Else //Icon Or Pointer
     Begin
          pbi:=Header;
          Goto Win;
     End;
End;
{$ENDIF}

{$HINTS OFF}
Procedure TBitmap.NewImage(BitmapData:Pointer;BitmapSize,OffsBits:LongWord;Mask:Boolean);
{$IFDEF OS2}
Var
   pbih:PBITMAPINFOHEADER;
   pbih2:PBITMAPINFOHEADER2;
   bih2:BITMAPINFOHEADER2;
   pbi2:PBITMAPINFO2;
   sizl:SIZEL;
   dop:DEVOPENSTRUC;
   pc:cstring;
   cScans,cScansRet,CX,CY:ULONG;
   Temp:^Byte;
   DC:LongWord;
   ps:LongWord;
   H:LongWord;
{$ENDIF}
{$IFDEF Win32}
Var
   PBC:^BitmapCoreHeader;
   pbi:^BITMAPINFOHEADER;
   BitmapInfo:PBitmapCoreInfo;
   BitmapInfo1:PBITMAPINFO;
   Size,Size0:LongWord;
   P:^Byte;
   Bits:Pointer;
   Focus:HWND;
   ADC,aDC1,MemDC,MemDC1:HDC;
   OldPal:LongWord;
   FTempBmp,FTempBmp1:LongWord;
   FOldTempBmp,FOldTempBmp1:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     DC := DevOpenDC(AppHandle,OD_MEMORY,'*',3,dop,0);
     If DC=0 Then InvalidImage;

     If Mask Then TIcon(Self).FMaskDC:=DC
     Else FBitmapDC:=DC;

     sizl.CX := 1;
     sizl.CY := 1;
     ps := GpiCreatePS(AppHandle,DC,sizl,PU_PELS Or GPIA_ASSOC Or GPIT_MICRO);
     If ps = GPI_ERROR Then InvalidImage;

     If Mask Then TIcon(Self).FMaskPS:=ps
     Else FBitmapPS:=ps;

     {If Not Mask Then} GpiCreateLogColorTable(ps,LCOL_RESET,LCOLF_RGB,0,0,Nil);

     pbih2:=BitmapData;

     If pbih2^.cbFix = SizeOf(BITMAPINFOHEADER) Then
     Begin
          { old format }
          pbih := Pointer(pbih2);
          cScans := pbih^.CY;
          CX := pbih^.CX;
          CY := pbih^.CY;
     End
     Else
     Begin
          { New PM format, windows, Or other }
          cScans := pbih2^.CY;
          CX := pbih2^.CX;
          CY := pbih2^.CY;
     End;

     {If Not Mask Then} SetupBitmapColors(BitmapData,Mask);

     Move(pbih2^, bih2, pbih2^.cbFix);  { Copy Info into global structure }

     H:=GpiCreateBitmap(ps,bih2,0,Nil,Nil);
     If H=0 Then InvalidImage;

     If Mask Then TIcon(Self).FMaskHandle:=H
     Else FBitmapHandle:=H;

     If GpiSetBitmap(ps,H) = BMB_ERROR Then InvalidImage;

     If ((BitmapData<>Nil) And (CX>0) And (CY>0)) Then
     Begin
          pbih:=BitmapData;
          Temp:=Pointer(pbih);
          Inc(Temp,OffsBits);
          pbi2:=Pointer(pbih);
          cScansRet := GpiSetBitmapBits(ps,0,cScans,Temp^,pbi2^);
          If cScansRet <> cScans Then InvalidImage; { original # Of scans? }
          FEmpty:=False;
     End
     Else InvalidImage;
     {$ENDIF}
     {$IFDEF Win32}
     If Not (Self Is TIcon) Then
     Begin
          PBC:=BitmapData;
          If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then
          Begin
               {OS2 Bitmap}
               If PBC^.bcPlanes<>1 Then InvalidImage;
               If FBitmapPal=0 Then
                 SetupBitmapColors(BitmapData,Mask);
               if PBC^.bcBitCount > 16
                 then Size:=0     // Bei 24-Farben (und darueber gibt) es keine Palette
                 else Size:=(longword(1) Shl PBC^.bcBitCount) * SizeOf(RGBTriple);
               Size0:=Size + SizeOf(BitmapCoreInfo);
               GetMem(BitmapInfo,Size0);
               BitmapInfo^.bmciHeader:=PBC^;
               P:=BitmapData;
               Inc(P,SizeOf(BitmapCoreHeader));
               Move(P^,BitmapInfo^.bmciColors,Size);

               P:=BitmapData;
               if PBC^.bcBitCount < 24 then
                 Begin
                   Inc(P,SizeOf(BitmapCoreHeader));
                   Inc(P,FColorCount*SizeOf(RGBTriple));
                 End;
               Size:=((((FWidth*PBC^.bcBitCount)+31) Div 32)*4)*FHeight;
               GetMem(Bits,Size);
               Move(P^,Bits^,Size);

               ADC:=GetDC(0);
               MemDC:=CreateCompatibleDC(ADC);
               FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
               FOldTempBmp:=SelectObject(MemDC,FTempBmp);

               If FBitmapPal<> 0 Then
               Begin
                   OldPal := SelectPalette(MemDC,FBitmapPal,False);
                   WinGDI.RealizePalette(MemDC);
               End
               Else OldPal:=0;

               FBitmapHandle:=CreateDIBitmap(MemDC,PBITMAPINFOHEADER(PBC)^,
                                             CBM_INIT,Bits^,PBITMAPINFO(BitmapInfo)^,
                                             DIB_RGB_COLORS);
               If FBitmapHandle=0 Then InvalidImage;

               If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
               SelectObject(MemDC,FOldTempBmp);
               If not DeleteObject(FTempBmp) Then InvalidImage;
               if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
               If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

               FreeMem(BitmapInfo,Size0);
               FreeMem(Bits,Size);
          End
          Else If PBC^.bcSize=SizeOf(BITMAPINFOHEADER) Then
          Begin
               {Win Bitmap}
               pbi:=BitmapData;
               If pbi^.biPlanes<>1 Then InvalidImage;
               If FBitmapPal=0 Then
                 SetupBitmapColors(BitmapData,Mask);

               if pbi^.biBitCount > 16
                 then Size:=0 // Bei 24-Farben (und darueber gibt es keine Palette
                 else Size:=(longword(1) Shl pbi^.biBitCount) * SizeOf(RGBQuad);
               Size0:=Size+SizeOf(BITMAPINFOHEADER);
               GetMem(BitmapInfo1,Size0);
               BitmapInfo1^.bmiHeader:=pbi^;
               P:=BitmapData;
               Inc(P,SizeOf(BITMAPINFOHEADER));
               Move(P^,BitmapInfo1^.bmiColors,Size);

               P:=BitmapData;
               Inc(P,SizeOf(BITMAPINFOHEADER));
               if pbi^.biBitCount < 24 then
                 Inc(P,FColorCount*SizeOf(RGBQuad));
//             Size:=pbi^.biSizeImage;
               Size:=((((FWidth*pbi^.biBitCount)+31) Div 32)*4)*FHeight;
               GetMem(Bits,Size);
               Move(P^,Bits^,Size);

               ADC:=GetDC(0);
               MemDC:=CreateCompatibleDC(ADC);
               FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
               FOldTempBmp:=SelectObject(MemDC,FTempBmp);

               If FBitmapPal<>0 Then
               Begin
                   OldPal:=SelectPalette(MemDC,FBitmapPal,False);
                   WinGDI.RealizePalette(MemDC);
               End
               Else OldPal := 0;

               FBitmapHandle:=CreateDIBitmap(MemDC,pbi^,CBM_INIT,Bits^,
                                             BitmapInfo1^,DIB_RGB_COLORS);
               If FBitmapHandle=0 Then InvalidImage;

               If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
               SelectObject(MemDC,FOldTempBmp);
               If not DeleteObject(FTempBmp) Then InvalidImage;
               if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
               If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

               FreeMem(BitmapInfo1,Size0);
               FreeMem(Bits,Size);
          End
          Else InvalidImage;

          FEmpty:=False;
     End
     Else //Icon Or Pointer
     Begin
          PBC:=BitmapData;
          If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then //OS2 Icon
          Begin
               If PBC^.bcPlanes<>1 Then InvalidImage;
               {OS2 Icon}
               If Mask Then
               Begin
                    //Create Xor Mask
                    If FBitmapPal=0 Then SetupBitmapColors(BitmapData,Mask);

                    P:=BitmapData;
                    Inc(P,OffsBits);

                    Size:=2 * SizeOf(RGBTriple);
                    Size0:=Size+SizeOf(BitmapCoreInfo);
                    GetMem(BitmapInfo,Size0);
                    BitmapInfo^.bmciHeader:=PBC^;

                    BitmapInfo^.bmciHeader.bcBitCount:=1;
                    BitmapInfo^.bmciHeader.bcPlanes:=1;
                    BitmapInfo^.bmciColors[0].rgbtBlue:=0;
                    BitmapInfo^.bmciColors[0].rgbtGreen:=0;
                    BitmapInfo^.bmciColors[0].rgbtRed:=0;
                    BitmapInfo^.bmciColors[1].rgbtBlue:=255;
                    BitmapInfo^.bmciColors[1].rgbtGreen:=255;
                    BitmapInfo^.bmciColors[1].rgbtRed:=255;

                    ADC:=GetDC(0);
                    MemDC:=CreateCompatibleDC(ADC);
                    FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
                    FOldTempBmp:=SelectObject(MemDC,FTempBmp);

                    If TIcon(Self).FMaskPal<> 0 Then
                    Begin
                        OldPal := SelectPalette(MemDC,TIcon(Self).FMaskPal,False);
                        WinGDI.RealizePalette(MemDC);
                    End
                    Else OldPal:=0;

                    TIcon(Self).FMaskHandle:=CreateDIBitmap(MemDC,PBITMAPINFOHEADER(PBC)^,
                                         CBM_INIT,P^,PBITMAPINFO(BitmapInfo)^,
                                         DIB_RGB_COLORS);
                    If TIcon(Self).FMaskHandle=0 Then InvalidImage;

                    If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
                    SelectObject(MemDC,FOldTempBmp);
                    If not DeleteObject(FTempBmp) Then InvalidImage;
                    if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
                    If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

                    FreeMem(BitmapInfo,Size0);

                    TIcon(Self).FMaskPS:=CreateCompatibleDC(0);
                    TIcon(Self).FOldMaskBitmap:=SelectObject(TIcon(Self).FMaskPS,TIcon(Self).FMaskHandle);
               End
               Else
               Begin
                    If FBitmapPal=0 Then SetupBitmapColors(BitmapData,Mask);

                    Size:=(longword(1) Shl PBC^.bcBitCount) * SizeOf(RGBTriple);
                    Size0:=Size + SizeOf(BitmapCoreInfo);
                    GetMem(BitmapInfo,Size0);
                    BitmapInfo^.bmciHeader:=PBC^;
                    P:=BitmapData;
                    Inc(P,SizeOf(BitmapCoreHeader));
                    Move(P^,BitmapInfo^.bmciColors,Size);

                    P:=BitmapData;
                    Inc(P,OffsBits);
                    Size:=((((FWidth*PBC^.bcBitCount)+31) Div 32)*4)*FHeight;
                    GetMem(Bits,Size);
                    Move(P^,Bits^,Size);

                    ADC:=GetDC(0);
                    MemDC:=CreateCompatibleDC(ADC);
                    FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
                    FOldTempBmp:=SelectObject(MemDC,FTempBmp);

                    If FBitmapPal<> 0 Then
                    Begin
                        OldPal := SelectPalette(MemDC,FBitmapPal,False);
                        WinGDI.RealizePalette(MemDC);
                    End
                    Else OldPal:=0;

                    FBitmapHandle:=CreateDIBitmap(MemDC,PBITMAPINFOHEADER(PBC)^,
                                       CBM_INIT,Bits^,PBITMAPINFO(BitmapInfo)^,
                                       DIB_RGB_COLORS);
                    If FBitmapHandle=0 Then InvalidImage;

                    If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
                    SelectObject(MemDC,FOldTempBmp);
                    If not DeleteObject(FTempBmp) Then InvalidImage;
                    if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
                    If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

                    FreeMem(BitmapInfo,Size0);
                    FreeMem(Bits,Size);

                    FEmpty:=False;
               End;
          End
          Else //Win Icon
          Begin
              pbi:=BitmapData;

              If pbi^.biPlanes<>1 Then InvalidImage;
              If FBitmapPal=0 Then SetupBitmapColors(BitmapData,Mask);

              Size:=(longword(1) Shl pbi^.biBitCount) * SizeOf(RGBQuad);
              Size0:=Size+SizeOf(BITMAPINFOHEADER);
              GetMem(BitmapInfo1,Size0);
              BitmapInfo1^.bmiHeader:=pbi^;

              BitmapInfo1^.bmiHeader.biHeight:=BitmapInfo1^.bmiHeader.biHeight Div 2;
              BitmapInfo1^.bmiHeader.biSizeImage:=
                 (((BitmapInfo1^.bmiHeader.biBitCount*BitmapInfo1^.bmiHeader.biWidth)+31) Div 32)*4*
                    BitmapInfo1^.bmiHeader.biHeight*BitmapInfo1^.bmiHeader.biPlanes;

              P:=BitmapData;
              Inc(P,SizeOf(BITMAPINFOHEADER));
              Move(P^,BitmapInfo1^.bmiColors,Size);

              P:=BitmapData;
              Inc(P,SizeOf(BITMAPINFOHEADER));
              Inc(P,FColorCount*SizeOf(RGBQuad));
              Size:=BitmapInfo1^.bmiHeader.biSizeImage;
              GetMem(Bits,Size);
              Move(P^,Bits^,Size);

              ADC:=GetDC(0);
              MemDC:=CreateCompatibleDC(ADC);
              FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
              FOldTempBmp:=SelectObject(MemDC,FTempBmp);

              If FBitmapPal<>0 Then
              Begin
                   OldPal:=SelectPalette(MemDC,FBitmapPal,False);
                   WinGDI.RealizePalette(MemDC);
              End
              Else OldPal := 0;

              //Create Xor Mask
              FBitmapHandle:=CreateDIBitmap(MemDC,BitmapInfo1^.bmiHeader,CBM_INIT,Bits^,
                                            BitmapInfo1^,DIB_RGB_COLORS);
              If FBitmapHandle=0 Then InvalidImage;

              //Create And Mask
              Inc(P,Size);
              //Move(P^,Bits^,Size);
              BitmapInfo1^.bmiHeader.biBitCount:=1;
              BitmapInfo1^.bmiHeader.biPlanes:=1;
              BitmapInfo1^.bmiHeader.biSizeImage:=
                 (((BitmapInfo1^.bmiHeader.biBitCount*BitmapInfo1^.bmiHeader.biWidth)+31) Div 32)*4*
                    BitmapInfo1^.bmiHeader.biHeight*BitmapInfo1^.bmiHeader.biPlanes;
              BitmapInfo1^.bmiColors[1].rgbBlue:=255;
              BitmapInfo1^.bmiColors[1].rgbGreen:=255;
              BitmapInfo1^.bmiColors[1].rgbRed:=255;
                                     
              ADC1:=GetDC(0);       
              MemDC1:=CreateCompatibleDC(ADC1);
              FTempBmp1:=CreateCompatibleBitmap(ADC1,1,1);
              FOldTempBmp1:=SelectObject(MemDC1,FTempBmp1);

              TIcon(Self).FMaskHandle:=CreateDIBitmap(MemDC1,BitmapInfo1^.bmiHeader,CBM_INIT,P^,
                                       BitmapInfo1^,DIB_RGB_COLORS);
              If TIcon(Self).FMaskHandle=0 Then InvalidImage;

              If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
              SelectObject(MemDC,FOldTempBmp);
              If not DeleteObject(FTempBmp) Then InvalidImage;
              if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
              If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;
                   
              SelectObject(MemDC1,FOldTempBmp1);
              If not DeleteObject(FTempBmp1) Then InvalidImage;
              if MemDC1 <> 0 then If not DeleteDC(MemDC1) Then InvalidImage;
              If ADC1<>0 Then If ReleaseDC(0,ADC1)=0 Then InvalidImage;

              FreeMem(BitmapInfo1,Size0);
              FreeMem(Bits,Size);

              TIcon(Self).FMaskPS:=CreateCompatibleDC(0);
              TIcon(Self).FOldMaskBitmap:=SelectObject(TIcon(Self).FMaskPS,TIcon(Self).FMaskHandle);
          End;
          FEmpty:=False;
     End;
     {$ENDIF}
End;
{$HINTS ON}

Procedure TBitmap.InvalidImage;
Begin
  if Application<>nil then
    Application.LogWriteln('InvalidImage:' + Name);
  FIsInvalid:=True;
  ReleaseBitmap;
  Raise EInvalidBitmap.Create(LoadNLSStr(SInvalidBitmap));
End;

Type
     ICONDIRENTRY=Record
                        bWidth:Byte;
                        bHeight:Byte;
                        bColorCount:Byte;
                        bReserved:Byte;
                        wPlanes:Word;
                        wBitCount:Word;
                        dwBytesInRes:LongWord;
                        dwImageOffset:LongWord;
     End;

Type PICONDIR=^TICONDIR;
     TICONDIR=Record
                    idReserved:Word;
                    idType:Word;
                    idCount:Word;
                    idEntries:ICONDIRENTRY;
     End;

Procedure TBitmap.SetupBitmap;

{$IFDEF OS2}
Var pbBuffer:Pointer;
    pbafh2 : PBITMAPARRAYFILEHEADER2;
    pbfh2  : PBITMAPFILEHEADER2;
    pbih   : PBITMAPINFOHEADER;
    pbih2  : PBITMAPINFOHEADER2;
    I,J,Bitmap2 : Word;
    BitmapOffset:LongWord;
    BitmapData:Pointer;
    BitmapSize,OffsBits:LongWord;
    Size:LongWord;
    MaskHeader:PBITMAPFILEHEADER2;
{$ENDIF}

{$IFDEF Win32}
Var pbBuffer:Pointer;
    PBC:^BitmapCoreHeader;
    pbi:^BITMAPINFOHEADER;
    BitmapOffset,OffsBits,BitmapSize:LongWord;
    BitmapData:Pointer;
    Size:LongWord;
    iDir:PICONDIR;
    bfh:PBITMAPFILEHEADER;
    MaskHeader:PBITMAPFILEHEADER;
    I,J,Bitmap2 : Word;
    WithFileHeader:Boolean;
    FirstCheck:Boolean;

Label check,ProcessIcon;
{$ENDIF}
Begin
  {$IFDEF OS2}
  pbBuffer:=FBitmapMem;
  Size:=FBitmapMemLength;
  MaskHeader:=Nil;

  pbfh2 := pbBuffer;
  pbih2 := Nil;     { only Set This when we validate Type }

  If pbfh2^.usType = BFT_BITMAPARRAY Then
    Begin
      If Not (Self Is TBitmap)
        Then InvalidImage;
      pbafh2 := @pbBuffer^;
      pbfh2 := @pbafh2^.bfh2;
    End;

  FXHotSpot:=pbfh2^.XHotSpot;
  FYHotSpot:=pbfh2^.YHotSpot;

  Case pbfh2^.usType Of
    BFT_BITMAP:
      Begin
        If Not (Self Is TBitmap) Then
          InvalidImage;
        pbih2 := @pbfh2^.bmp2;
      End;

    BFT_COLORICON, BFT_COLORPOINTER:
      Begin
        MaskHeader:=pbfh2;
        If pbfh2^.cbSize = SizeOf(BITMAPFILEHEADER) Then
          Begin
            pbih := @pbfh2^.bmp2;      {only BITMAPINFOHEADER}
            J := 1;
            For I := 1 To (pbih^.cPlanes*pbih^.cBitCount) Do
              J := 2*J;
            Bitmap2 := SizeOf(RGB)*J;  {Size Of color Table}
          End
        Else
          Begin
            pbih2 := @pbfh2^.bmp2;     {BITMAPINFOHEADER2}
            J := 1;
            For I := 1 To (pbih2^.cPlanes*pbih2^.cBitCount) Do
              J := 2*J;
            Bitmap2 := SizeOf(RGB2)*J; {Size Of color Table}
          End;
        Inc(Bitmap2,pbfh2^.cbSize);     {+ Size Of BITMAPFILEHEADER[2]}
        Inc(pbfh2,Bitmap2);             {Select the Second Bitmap}
        pbih2 := @pbfh2^.bmp2;
      End;
  End; {Case}

  If pbih2 = Nil Then
    InvalidImage;

  BitmapOffset:=LongWord(pbih2)-LongWord(@pbBuffer^);
  BitmapSize:=Size-BitmapOffset;

  BitmapData:=pbih2;

  If pbih2^.cbFix=SizeOf(BITMAPINFOHEADER) Then
    Begin
      {old format}
      FWidth:=PBITMAPINFOHEADER(pbih2)^.CX;
      FHeight:=PBITMAPINFOHEADER(pbih2)^.CY;
    End
  Else
    Begin
       {New PM format Or other}
      FWidth:=pbih2^.CX;
      FHeight:=pbih2^.CY;
    End;

  OffsBits:=pbfh2^.offBits-BitmapOffset;

  NewImage(BitmapData,BitmapSize,OffsBits,False);

  If Self Is TIcon Then
    If MaskHeader<>Nil Then
      Begin
        pbfh2:=MaskHeader;
        pbih2:=@pbfh2^.bmp2;

        BitmapOffset:=LongWord(pbih2)-LongWord(@pbBuffer^);
        BitmapSize:=Size-BitmapOffset;

        BitmapData:=pbih2;

        If pbih2^.cbFix=SizeOf(BITMAPINFOHEADER) Then
          Begin
             {old format}
            TIcon(Self).FMaskWidth:=PBITMAPINFOHEADER(pbih2)^.CX;
            TIcon(Self).FMaskHeight:=PBITMAPINFOHEADER(pbih2)^.CY;
          End
        Else
          Begin
            {New PM format Or other}
            TIcon(Self).FMaskWidth:=pbih2^.CX;
            TIcon(Self).FMaskHeight:=pbih2^.CY;
          End;

        OffsBits:=pbfh2^.offBits-BitmapOffset;

        NewImage(BitmapData,BitmapSize,OffsBits,True);
      End;
  {$ENDIF}
  {$IFDEF Win32}
  pbBuffer:=FBitmapMem;

  If (Self Is TIcon) Then
    Begin        // Icons
      bfh:=pbBuffer;

      If ((bfh^.bfType=BFT_COLORICON)Or
          (bfh^.bfType=BFT_COLORPOINTER)) Then //OS/2 Icon
        Begin
          WithFileHeader:=True;
ProcessIcon:
          MaskHeader:=bfh;
          PBC:=pbBuffer;
          If WithFileHeader Then Inc(PBC,SizeOf(BITMAPFILEHEADER));
          If PBC^.bcSize<>SizeOf(BitmapCoreHeader) Then InvalidImage;
          J := 1;
          For I := 1 To (PBC^.bcPlanes*PBC^.bcBitCount) Do J := 2*J;
          Bitmap2 := SizeOf(RGBTriple)*J;          {Size Of color Table}
          Inc(Bitmap2,SizeOf(BITMAPFILEHEADER));   {+ Size Of BITMAPFILEHEADER[2]}
          Inc(Bitmap2,SizeOf(BitmapCoreHeader));

          Inc(bfh,Bitmap2);
          PBC := Pointer(bfh);                     {Select the Second Bitmap}
          If WithFileHeader Then Inc(PBC,SizeOf(BITMAPFILEHEADER));
          If PBC^.bcSize<>SizeOf(BitmapCoreHeader) Then InvalidImage;
          FWidth:=PBC^.bcWidth;
          FHeight:=PBC^.bcHeight;
          TIcon(Self).FMaskWidth:=FWidth;
          TIcon(Self).FMaskHeight:=FHeight;

          //Generate color Bitmap
          Size:=FBitmapMemLength;
          BitmapOffset:=LongWord(PBC)-LongWord(@pbBuffer^);
          BitmapSize:=Size-BitmapOffset;
          //let it Point To BitmapCoreHeader
          BitmapData:=Pointer(PBC);
          OffsBits:=bfh^.bfOffBits-BitmapOffset;
          NewImage(BitmapData,BitmapSize,OffsBits,False);

          //Generate Mask Bitmap
          bfh:=MaskHeader;
          PBC:=Pointer(bfh);
          If WithFileHeader Then Inc(PBC,SizeOf(BITMAPFILEHEADER));
          If PBC^.bcSize<>SizeOf(BitmapCoreHeader) Then InvalidImage;

          BitmapOffset:=LongWord(PBC)-LongWord(@pbBuffer^);
          BitmapSize:=Size-BitmapOffset;
          //let it Point To BitmapCoreHeader
          BitmapData:=Pointer(PBC);
          OffsBits:=bfh^.bfOffBits-BitmapOffset;
          NewImage(BitmapData,BitmapSize,OffsBits,True);
        End
      Else //Win Icon
        Begin
          iDir:=pbBuffer;

          If iDir^.idReserved<>0 Then
            Begin
              pbi:=pbBuffer;
              If pbi^.biSize<>sizeof(BITMAPINFOHEADER) Then
                Begin
                  PBC:=pbBuffer;
                  If PBC^.bcSize<>sizeof(BITMAPCOREHEADER) Then InvalidImage;

                  {
                  FWidth:=PBC^.bcWidth;
                  FHeight:=PBC^.bcHeight;

                  TIcon(Self).FMaskWidth:=FWidth;
                  TIcon(Self).FMaskHeight:=FHeight;

                  BitmapSize:=FBitmapMemLength;
                  OffsBits:=0;
                  BitmapData:=pbBuffer;
                  NewImage(BitmapData,BitmapSize,OffsBits,False);
                  }
                  WithFileHeader:=False;
                  goto ProcessIcon;
                End
              Else
                Begin
                  FWidth:=pbi^.biWidth;
                  FHeight:=pbi^.biHeight;
                  TIcon(Self).FMaskWidth:=FWidth;
                  TIcon(Self).FMaskHeight:=FHeight;

                  BitmapSize:=FBitmapMemLength;
                  OffsBits:=0;
                  BitmapData:=pbBuffer;
                  NewImage(BitmapData,BitmapSize,OffsBits,False);
                End;
            End
          Else
            Begin
              If ((iDir^.idType<>1)And(iDir^.idType<>2)) Then InvalidImage;
              If iDir^.idCount<>1 Then InvalidImage;

              FWidth:=iDir^.idEntries.bWidth;
              FHeight:=iDir^.idEntries.bHeight;
              TIcon(Self).FMaskWidth:=FWidth;
              TIcon(Self).FMaskHeight:=FHeight;

              BitmapSize:=iDir^.idEntries.dwBytesInRes;
              OffsBits:=0;
              BitmapData:=pbBuffer;
              //let it Point To BITMAPINFOHEADER
              Inc(BitmapData,SizeOf(TICONDIR){iDir^.idEntries.dwImageOffset});
              NewImage(BitmapData,BitmapSize,OffsBits,False);
            End;
       End;
    End

  else  // Bitmaps
    Begin
      PBC:=pbBuffer;
      FirstCheck:=True;
 check:
      If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then
        Begin
          FWidth:=PBC^.bcWidth;
          FHeight:=PBC^.bcHeight;
        End
      Else If PBC^.bcSize=SizeOf(BITMAPINFOHEADER) Then
        Begin
          pbi:=Pointer(PBC);
          FWidth:=pbi^.biWidth;
          FHeight:=pbi^.biHeight;
        End
      Else
        Begin
          bfh:=pbBuffer;
          If (bfh^.bfType=BFT_BITMAP) And FirstCheck Then
            Begin
              PBC:=pbBuffer;
              inc(PBC,sizeof(BITMAPFILEHEADER));
              FirstCheck:=False;
              goto check;
            End
          Else InvalidImage;
      End;

      BitmapOffset:=0;
      OffsBits:=0;{PBmf^.bfOffBits-BitmapOffset;} //Not used For Win
      BitmapSize:=FBitmapMemLength;
      BitmapData:=PBC;
      NewImage(BitmapData,BitmapSize,OffsBits,False);
    End;


  If not (Self Is TIcon) Then
    CreateHandle;
  {$ENDIF}
End;

Procedure TBitmap.LoadFromResourceId(Id:LongWord);

Var FN : tFileName;

  Procedure LoadFromOSResourceID(Id:LongWord);

  Var pbBuffer:Pointer;
      Size:LongWord;
      {$IFDEF Win32}
      C:cstring;
      ResHandle:LongWord;
      {$ENDIF}

  Begin
    {$IFDEF OS2}
    If ((Self Is TPointer)Or(Self Is TIcon)) Then
    Begin
       If DosQueryResourceSize(DllModule,RT_POINTER,Id,Size)<>0 Then InvalidImage;
       If DosGetResource(DllModule,RT_POINTER,Id,pbBuffer)<>0 Then InvalidImage;
    End
    Else
    Begin
       If DosQueryResourceSize(DllModule,RT_BITMAP,Id,Size)<>0 Then InvalidImage;
       If DosGetResource(DllModule,RT_BITMAP,Id,pbBuffer)<>0 Then InvalidImage;
    End;
    If pbBuffer=Nil Then InvalidImage;

    ReleaseBitmap;
    FBitmapMemLength:=Size;
    GetMem(FBitmapMem,FBitmapMemLength);
    Move(pbBuffer^,FBitmapMem^,FBitmapMemLength);
    If DosFreeResource(pbBuffer)<>0 Then InvalidImage;
    {$ENDIF}
    {$IFDEF Win32}
    C:='#'+tostr(Id);
    If Self Is TPointer Then ResHandle:=FindResource(DllModule,C,MAKEINTRESOURCE(RT_CURSOR)^)
    Else If Self Is TIcon Then ResHandle:=FindResource(DllModule,C,MAKEINTRESOURCE(RT_GROUP_ICON)^)
    Else ResHandle:=FindResource(DllModule,C,MAKEINTRESOURCE(RT_BITMAP)^);
    If ResHandle=0 Then InvalidImage;
    pbBuffer:=Pointer(LoadResource(DllModule,ResHandle));
    If pbBuffer=Nil Then InvalidImage;
    Size:=SizeOfResource(DllModule,ResHandle);

    ReleaseBitmap;
    FBitmapMemLength:=Size;
    GetMem(FBitmapMem,FBitmapMemLength);
    Move(pbBuffer^,FBitmapMem^,FBitmapMemLength);
    {$ENDIF}
    SetupBitmap;
    Changed;
    {$IFDEF WIN32}
    DestroyHandle;
    {$ENDIF}
  End;

Begin
  FIsInvalid:=False; //reset flag !
  if (Self is tIcon) and (ID=1) then
    Begin
      LoadFromOSResourceID(iD);
      exit;
    End;
  FN:=GenUniqueResName(ID, Self.ClassName);
  LoadFromResourceName(FN);
End;

Procedure TBitmap.LoadFromResourceName(Const Name:String);

Var P  : Pointer;
    len: LongWord;

Begin
  FIsInvalid:=False; //reset flag !
  P:=FindBitmapRes(Name,len);
  If ((P=Nil)Or(Len=0)) Then InvalidImage;

  ReleaseBitmap;
  FBitmapMemLength:=len;
  GetMem(FBitmapMem,FBitmapMemLength);
  Move(P^,FBitmapMem^,FBitmapMemLength);
  SetupBitmap;                          
  Changed;
  {$IFDEF WIN32}
  DestroyHandle;
  {$ENDIF}
End;

Procedure TBitmap.LoadFromMem (Var Buf;Size:LongInt);
Begin
  FIsInvalid:=False; //reset flag !

  If Size>0 Then
  Begin
       ReleaseBitmap;
       FBitmapMemLength:=Size;
       GetMem(FBitmapMem,FBitmapMemLength);
       Move(Buf,FBitmapMem^,FBitmapMemLength);
       SetupBitmap;
       Changed;
       {$IFDEF WIN32}
       DestroyHandle;
       {$ENDIF}
  End
  Else
  Begin
       {Setup Bitmap Info structure pbmp2BitmapFile}
       InvalidImage;
  End;
End;

Procedure TBitmap.ReadStream(Stream:TStream;Size:LongInt);
{$IFDEF Win32}
Var PBmf:^BITMAPFILEHEADER;
    P,p1:Pointer;
{$ENDIF}
Var BitmapInfo : tBitmapInfo;

Begin
  Application.LogWriteln('ReadStream');
  FIsInvalid:=False; //reset flag !
  If Size>0
    Then
      Begin
        ReleaseBitmap;
        FBitmapMemLength:=Size;
        ConvertToBitmap(Stream, FBitmapMemLength, FBitmapMem, BitmapInfo);
        fTransparentColor:= BitmapInfo.TransparentColor;
        fBitmapTyp       := BitmapInfo.BitmapTyp;

        {$IFDEF Win32}
/*WD; Bei Win2000 braucht man diesen Teil nicht. Bei Win98 testen
        PBmf:=Pointer(FBitmapMem);
        If PBmf^.bfType=$4D42 Then //Delete File Header
          Begin
            GetMem(P,Size-SizeOf(BITMAPFILEHEADER));
            p1:=FBitmapMem;
            Inc(p1,SizeOf(BITMAPFILEHEADER));
            Move(p1^,P^,Size-SizeOf(BITMAPFILEHEADER));
            FreeMem(FBitmapMem,Size);
            Dec(FBitmapMemLength,SizeOf(BITMAPFILEHEADER));
            FBitmapMem:=P;
          End; */
        {$ENDIF}
        SetupBitmap;
        Changed;
        {$IFDEF Win32}
        DestroyHandle;
        {$ENDIF}
      End
    Else InvalidImage;

  if fBitmapTyp=btBitmap then
    fTransparentColor:=Canvas.Pixels[0,0];
End;

Procedure TBitmap.LoadFromStream(Stream:TStream);
Begin
  FIsInvalid:=False; //reset flag !
  ReadStream(Stream,Stream.Size-Stream.Position);
  changed;
End;

Procedure TBitmap.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
  FIsInvalid:=False; //reset flag !

  If ResName = rnBitmap Then
  Begin
       If DataLen>0 Then
       Begin
            If FBitmapMem=Nil Then
            Begin
                 FBitmapMemLength:=DataLen;
                 GetMem(FBitmapMem,FBitmapMemLength);
                 Move(Data,FBitmapMem^,FBitmapMemLength);
                 SetupBitmap;
                 changed;
                 {$IFDEF WIN32}
                 DestroyHandle;
                 {$ENDIF}
            End;
       End;
  End
  Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Function TBitmap.WriteSCUResourceName(Stream:TResourceStream;
                                      ResName:TResourceName):Boolean;
Begin
     If (FBitmapMemLength>0) And (FBitmapMem<>Nil) Then
     Begin
          Result:=Stream.NewResourceEntry(ResName,FBitmapMem^,FBitmapMemLength);
     End
     Else Result:=True;
End;

Function TBitmap.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := WriteSCUResourceName(Stream,rnBitmap);
End;

(*
  old code

Procedure TBitmap.Update;
{$IFDEF OS2}
Var
    cbBuffer:LongWord;
    cbInfo:LongWord;
    Buf:Pointer;
    BI:PBITMAPINFO;
    FH:BITMAPFILEHEADER;
    BIH:BITMAPINFOHEADER;
    P:Pointer;
{$ENDIF}
{$IFDEF Win32}
Var
    BI:BitmapCoreInfo;
    pbi:^BitmapCoreInfo;
    P,pp:Pointer;
    cbInfo,cbBuffer:LongWord;

    BI2:BitmapInfo;
{$ENDIF}
Begin
     {$IFDEF OS2}
     //fr PM 2.X format Bitmap*2 statt Bitmap* und RGB2 statt RGB
     BIH.cbFix:=SizeOf(BITMAPINFOHEADER);
     If Not GpiQueryBitmapInfoHeader(FBitmapHandle,BIH) Then Exit;
     cbBuffer:=(((BIH.cBitCount*BIH.CX)+31) Div 32)*4*BIH.CY*BIH.cPlanes;
     GetMem(Buf,cbBuffer);
     cbInfo:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGB)*(longword(1) Shl BIH.cBitCount);
     GetMem(BI,cbInfo);
     Move(BIH,BI^,SizeOf(BITMAPINFOHEADER));
     GpiQueryBitmapBits(FBitmapPS,0,BIH.CY,Buf^,BI^);

     FH.usType:=BFT_BITMAP;
     FH.cbSize:=SizeOf(BITMAPFILEHEADER);
     FH.XHotSpot:=FXHotSpot;
     FH.YHotSpot:=FYHotSpot;
     FH.offBits:=(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfo;

     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER)+cbInfo+cbBuffer;
     GetMem(FBitmapMem,FBitmapMemLength);
     P:=FBitmapMem;
     Move(FH,P^,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Inc(P,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Move(BI^,P^,cbInfo);
     Inc(P,cbInfo);
     Move(Buf^,P^,cbBuffer);

     FreeMem(Buf,cbBuffer);
     FreeMem(BI,cbInfo);
     {$ENDIF}
     {$IFDEF Win32}
     CreateHandle;
     SelectObject(FBitmapPS,FOldBitmap);

     FillChar(BI,SizeOf(BI),0);

     FillChar(BI2,SizeOf(BI2),0);
     BI2.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(FBitmapPS,FBitmapHandle,0,0,Nil,BI2,0);
     If FOrigBitCount>0 Then BI2.bmiHeader.biBitCount:=FOrigBitCount;
     If FOrigPlanes>0 Then BI2.bmiHeader.biPlanes:=FOrigPlanes;

     cbInfo:=SizeOf(BitmapCoreHeader)+SizeOf(RGBTriple)*(longword(1) Shl BI2.bmiHeader.biBitCount);
     LastcbInfo:=cbInfo;
     GetMem(pbi,cbInfo);
     With pbi^.bmciHeader Do
     Begin
          bcSize:=SizeOf(BitmapCoreHeader);
          bcWidth:=BI2.bmiHeader.biWidth;
          bcHeight:=BI2.bmiHeader.biHeight;
          bcPlanes:=BI2.bmiHeader.biPlanes;
          bcBitCount:=BI2.bmiHeader.biBitCount;
     End;
     cbBuffer:=(((BI2.bmiHeader.biBitCount*BI2.bmiHeader.biWidth)+31) Div 32)
                *4*BI2.bmiHeader.biHeight*BI2.bmiHeader.biPlanes;
     GetMem(P,cbBuffer);
     GetDIBits(FBitmapPS,FBitmapHandle,0,BI2.bmiHeader.biHeight,P^,pbi^,DIB_RGB_COLORS);

     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=cbInfo+cbBuffer;
     GetMem(FBitmapMem,FBitmapMemLength);
     pp:=FBitmapMem;
     Move(pbi^,pp^,cbInfo);
     Inc(pp,cbInfo);
     Move(P^,pp^,cbBuffer);

     FreeMem(pbi,cbInfo);
     FreeMem(P,cbBuffer);
     SelectObject(FBitmapPS,FBitmapHandle);
     DestroyHandle;
     {$ENDIF}
End;
*)

{tBitmap.Update rewritten by Aaron Lawrence}

// Retrieves data from OS bitmap into memory,
// laid out as in a BMP file. For OS/2:
// Fileheader
//   InfoHeader
// Palette (if 256 colors or less)
// Bits
Procedure TBitmap.Update;
{$IFDEF OS2}
Var
    PaletteSize: longint;
    BitsSize: longint;
    InfoHeader: BITMAPINFOHEADER;
    pInfoHeader: PBITMAPINFOHEADER;
    pFileHeader: ^BITMAPFILEHEADER;
    pBitmapBits: pbyte;
{$ENDIF}
{$IFDEF Win95}
Var
    BI:BitmapCoreInfo;
    pbi:^BitmapCoreInfo;
    P,pp:Pointer;
    cbInfo,cbBuffer:LongWord;

    BI2:BitmapInfo;
{$ENDIF}
Begin
     {$IFDEF OS2}
     //fr PM 2.X format Bitmap*2 statt Bitmap* und RGB2 statt RGB

     // Get bitmap information header
     InfoHeader.cbFix:=SizeOf(BITMAPINFOHEADER);
     If Not GpiQueryBitmapInfoHeader(FBitmapHandle,InfoHeader) Then Exit;

     // If paletted image (256 colours, 8 bpp, or less) then
     // calculate palette size
     if InfoHeader.cBitCount <= 8 then
       PaletteSize := SizeOf(RGB)*(1 Shl InfoHeader.cBitCount)
     else
       // not a paletted image, no palette
       PaletteSize := 0;

     // Calculate size of bitmap bits
     // Round row size up to nearest 32bit boundary
     BitsSize:= (((InfoHeader.cBitCount*InfoHeader.CX)+31) Div 32)*4
                * InfoHeader.CY
                * InfoHeader.cPlanes;

     // Free up previous memory, if any
     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);

     // calculate total bitmap memory required and allocate
     FBitmapMemLength:= sizeof(BITMAPFILEHEADER)
                        + PaletteSize
                        + BitsSize;
     GetMem(FBitmapMem,FBitmapMemLength);

     // create pointers into memory for the info header and the bits
     pInfoHeader := PBITMAPINFOHEADER( FBitmapMem
                                       + SizeOf(BITMAPFILEHEADER)
                                       - SizeOf(BITMAPINFOHEADER) );
     pBitmapBits := FBitmapMem
                    + SizeOf(BITMAPFILEHEADER)
                    + PaletteSize;

     // Copt info header
     pInfoHeader^ := InfoHeader;

     // Query all bitmap bits & info+palette
     GpiQueryBitmapBits( FBitmapPS,
                         0, // start scanline
                         InfoHeader.CY, // scanline count (all)
                         pBitmapBits^, // bits
                         pInfoHeader^); // info header and palette

     // setup bitmap file header
     pFileHeader := FBitmapMem;
     pFileHeader^.usType:=BFT_BITMAP;
     pFileHeader^.cbSize:=SizeOf(BITMAPFILEHEADER);
     pFileHeader^.XHotSpot:=FXHotSpot;
     pFileHeader^.YHotSpot:=FYHotSpot;
     pFileHeader^.offBits:=SizeOf(BITMAPFILEHEADER)+PaletteSize;

     {$ENDIF}
     {$IFDEF Win95}
     CreateHandle;
     SelectObject(FBitmapPS,FOldBitmap);

     FillChar(BI,SizeOf(BI),0);

     FillChar(BI2,SizeOf(BI2),0);
     BI2.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(FBitmapPS,FBitmapHandle,0,0,Nil,BI2,0);
     If FOrigBitCount>0 Then BI2.bmiHeader.biBitCount:=FOrigBitCount;
     If FOrigPlanes>0 Then BI2.bmiHeader.biPlanes:=FOrigPlanes;

     cbInfo:=SizeOf(BitmapCoreHeader)+SizeOf(RGBTriple)*(1 Shl BI2.bmiHeader.biBitCount);
     LastcbInfo:=cbInfo;
     GetMem(pbi,cbInfo);
     With pbi^.bmciHeader Do
     Begin
          bcSize:=SizeOf(BitmapCoreHeader);
          bcWidth:=BI2.bmiHeader.biWidth;
          bcHeight:=BI2.bmiHeader.biHeight;
          bcPlanes:=BI2.bmiHeader.biPlanes;
          bcBitCount:=BI2.bmiHeader.biBitCount;
     End;
     cbBuffer:=(((BI2.bmiHeader.biBitCount*BI2.bmiHeader.biWidth)+31) Div 32)
                *4*BI2.bmiHeader.biHeight*BI2.bmiHeader.biPlanes;
     GetMem(P,cbBuffer);
     GetDIBits(FBitmapPS,FBitmapHandle,0,BI2.bmiHeader.biHeight,P^,pbi^,DIB_RGB_COLORS);

     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=cbInfo+cbBuffer;
     GetMem(FBitmapMem,FBitmapMemLength);
     pp:=FBitmapMem;
     Move(pbi^,pp^,cbInfo);
     Inc(pp,cbInfo);
     Move(P^,pp^,cbBuffer);

     FreeMem(pbi,cbInfo);
     FreeMem(P,cbBuffer);
     SelectObject(FBitmapPS,FBitmapHandle);
     DestroyHandle;
     {$ENDIF}
End;


Procedure TBitmap.SaveToStream(Stream:TStream);
{$IFDEF Win32}
Var FH:BITMAPFILEHEADER;
{$ENDIF}
Begin
     {$IFDEF WIN32}
     CreateHandle;
     {$ENDIF}

     If ((FBitmapHandle=0)Or(FBitmapMem=Nil)Or(FBitmapMemLength=0)) Then
     Begin
          {$IFDEF WIN32}
          DestroyHandle;
          {$ENDIF}
          Exit;
     End;

     {Die folgende Aktion wandelt mein Windows Bitmap (15478 Byte)
     aus einer Datenbank in etwas anderes (15194 Byte) um, daแ auch noch
     falsche Farben beim Wiedereinlesen aus der DB anzeigt}
     {?????}
     Update;

     If FBitmapMem<>Nil Then
       If FBitmapMemLength>0 Then
     Begin
         {$IFDEF Win32}
         If Not (Self Is TIcon) Then
         Begin
              Update; {2x ???}
              FH.bfType:=BFT_BITMAP;
              FH.bfSize:=SizeOf(BITMAPFILEHEADER)+SizeOf(BitmapCoreHeader);
              FH.bfReserved1:=0;
              FH.bfReserved2:=0;
              FH.bfOffBits:=SizeOf(BITMAPFILEHEADER)+LastcbInfo;
              Stream.WriteBuffer(FH,SizeOf(BITMAPFILEHEADER));
         End
         Else Update; {2x ???}
         {$ENDIF}
         Stream.WriteBuffer(FBitmapMem^,FBitmapMemLength);
     End;

     {$IFDEF Win32}
     DestroyHandle;
     {$ENDIF}
End;

(*
  old code

Procedure TBitmap.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
Var Planes,BitCount,Size,Size0:LongWord;
    P,Bits:Pointer;
    Temp :LongWord;

{$IFDEF Win32}
Var BitmapInfo:PBitmapCoreInfo;
    Focus:HWND;
    ADC,MemDC:LongWord;
    OldPal:LongWord;
    DestPal:PLogPalette;
    cbPal:LongWord;
    T:LongInt;
    FTempBmp,FOldTempBmp:LongWord;
    SysPalSize:LongInt;
    I:LongInt;

    Procedure SetPalEntry(Index:LongInt;Color:TColor);
    Begin
         DestPal^.palPalEntry[Index].peRed:=TRGB(Color).Red;
         DestPal^.palPalEntry[Index].peGreen:=TRGB(Color).Green;
         DestPal^.palPalEntry[Index].peBlue:=TRGB(Color).Blue;
         DestPal^.palPalEntry[Index].peFlags:=0;
    End;

{$ENDIF}
{$IFDEF OS2}
Var
   BI:PBITMAPINFO;
   BIH:BITMAPINFOHEADER;
   dop:DEVOPENSTRUC;
   pc:cstring;
   ps,DC,cbPal:LongWord;
   sizl:SIZEL;
   DestPal:^TRGB2Array;
   T:LongInt;
   FH:BITMAPFILEHEADER;
{$ENDIF}
Begin
     FIsInvalid:=False; //reset flag !

     ReleaseBitmap;

     Planes:=1;
     If Colors<=2 Then BitCount:=1
     Else If Colors<=16 Then BitCount:=4
     Else If Colors<=256 Then BitCount:=8
     Else BitCount:=16;

     FWidth:=NewWidth;
     FHeight:=NewHeight;
     FOrigBitCount:=BitCount;
     FOrigPlanes:=Planes;
     FColorCount:=Colors;

{$IFDEF Win32}
     Size:=(longword(1) Shl BitCount) * SizeOf(RGBTriple);
     Size0:=Size + SizeOf(BitmapCoreInfo);
     GetMem(BitmapInfo,Size0);
     With BitmapInfo^.bmciHeader Do
     Begin
          bcSize:=SizeOf(BitmapCoreHeader);
          bcWidth:=NewWidth;
          bcHeight:=NewHeight;
          bcPlanes:=Planes;
          bcBitCount:=BitCount;
     End;

     //Setup BitmapInfo^.bmciColors
     ADC:=CreateCompatibleDC(0);
     Colors:=longword(1) Shl BitCount;
     If Colors>256 Then Colors:=256;
     cbPal:=SizeOf(LogPalette)+Colors*SizeOf(PaletteEntry);
     GetMem(DestPal,cbPal);
     GetSystemPaletteEntries(ADC,0,Colors,DestPal^.palPalEntry[0]);
     SysPalSize:=GetDeviceCaps(ADC, SIZEPALETTE);
     DestPal^.palVersion := $300;
     DestPal^.palNumEntries := Colors;
     If FColorCount=16 Then //construct default palette
     Begin
          SetPalEntry(0,ValuesToRGB(0,0,0));
          SetPalEntry(1,ValuesToRGB(128,0,0));
          SetPalEntry(2,ValuesToRGB(0,128,0));
          SetPalEntry(3,ValuesToRGB(128,128,0));
          SetPalEntry(4,ValuesToRGB(0,0,128));
          SetPalEntry(5,ValuesToRGB(128,0,128));
          SetPalEntry(6,ValuesToRGB(0,128,128));
          SetPalEntry(7,ValuesToRGB(192,192,192));
          SetPalEntry(8,ValuesToRGB(128,128,128));
          SetPalEntry(9,ValuesToRGB(255,0,0));
          SetPalEntry(10,ValuesToRGB(0,255,0));
          SetPalEntry(11,ValuesToRGB(255,255,0));
          SetPalEntry(12,ValuesToRGB(0,0,255));
          SetPalEntry(13,ValuesToRGB(255,0,255));
          SetPalEntry(14,ValuesToRGB(0,255,255));
          SetPalEntry(15,ValuesToRGB(255,255,0));
     End;
     If Self Is TIcon Then
     Begin
          SetPalEntry(0,ValuesToRGB(0,0,0));
          SetPalEntry(1,ValuesToRGB(255,255,255));
     End;
     DeleteDC(ADC);
     For T:=0 To FColorCount-1 Do
     Begin
          BitmapInfo^.bmciColors[T].rgbtRed:=DestPal^.palPalEntry[T].peRed;
          BitmapInfo^.bmciColors[T].rgbtGreen:=DestPal^.palPalEntry[T].peGreen;
          BitmapInfo^.bmciColors[T].rgbtBlue:=DestPal^.palPalEntry[T].peBlue;
     End;
     FBitmapPal:=WinGDI.CreatePalette(DestPal^);
     FreeMem(DestPal,cbPal);

     Size:=((((NewWidth*BitCount)+31) Div 32)*4)*NewHeight;
     GetMem(Bits,Size);

     ADC:=GetDC(0);
     MemDC:=CreateCompatibleDC(ADC);
     FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
     FOldTempBmp:=SelectObject(MemDC,FTempBmp);

     If FBitmapPal<> 0 Then
     Begin
          OldPal := SelectPalette(MemDC,FBitmapPal,False);
          WinGDI.RealizePalette(MemDC);
     End
     Else OldPal:=0;

     FBitmapHandle:=CreateDIBitmap(MemDC,BitmapInfo^.bmciHeader,
                                   CBM_INIT,Bits^,PBITMAPINFO(BitmapInfo)^,
                                   DIB_RGB_COLORS);
     If FBitmapHandle=0 Then InvalidImage;

     If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
     SelectObject(MemDC,FOldTempBmp);
     If not DeleteObject(FTempBmp) Then InvalidImage;
     If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
     If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

     FBitmapMemLength:=Size0+Size;

     GetMem(FBitmapMem,FBitmapMemLength);
     P:=FBitmapMem;
     Move(BitmapInfo^,P^,Size0);
     Inc(P,Size0);
     Move(Bits^,P^,Size);

     FreeMem(Bits,Size);
     FreeMem(BitmapInfo,Size0);

     FEmpty:=False;
{$ENDIF}
{$IFDEF OS2}
     Size:=(longword(1) Shl BitCount) * SizeOf(RGB);
     Size0:=Size + SizeOf(BITMAPINFOHEADER);
     GetMem(BI,Size0);
     With BI^ Do
     Begin
          cbFix:=SizeOf(BITMAPINFOHEADER);
          CX:=NewWidth;
          CY:=NewHeight;
          cPlanes:=Planes;
          cBitCount:=BitCount;
     End;

     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     DC := DevOpenDC(AppHandle,OD_MEMORY,'*',3,dop,0);
     If DC=0 Then InvalidImage;
     FBitmapDC:=DC;

     sizl.CX := 1;
     sizl.CY := 1;
     ps := GpiCreatePS(AppHandle,DC,sizl,PU_PELS Or GPIA_ASSOC Or GPIT_MICRO);
     If ps = GPI_ERROR Then InvalidImage;
     GpiCreateLogColorTable(ps,LCOL_RESET,LCOLF_RGB,0,0,Nil);

     FBitmapPS:=ps;

     //Setup BitmapInfo^.bmciColors
     Colors:=longword(1) Shl BitCount;
     If Colors>256 Then Colors:=256;
     //Colors are returned As RGB2 values !
     cbPal:=(Colors+1)*SizeOf(RGB2);
     GetMem(DestPal,cbPal);
     //note: This will return 16 Colors even If the Palette has 256 entries
     //the remaining entries are Left 0 (Black)
     {Colors:=}
     Temp := GpiQueryPaletteInfo(0,ps,0,0,Colors,DestPal^);
     FBitmapPal:=GpiCreatePalette(AppHandle,0{LCOL_OVERRIDE_DEFAULT_COLORS},LCOLF_CONSECRGB,Colors,DestPal^);
     If FBitmapPal=0 Then InvalidImage;
     For T:=0 To Colors-1 Do
     Begin
          BI^.argbColor[T].bRed:=DestPal^[T].bRed;
          BI^.argbColor[T].bGreen:=DestPal^[T].bGreen;
          BI^.argbColor[T].bBlue:=DestPal^[T].bBlue;
     End;
     FreeMem(DestPal,cbPal);

     If GpiSelectPalette(ps,FBitmapPal) = PAL_ERROR Then InvalidImage;
     GpiCreateLogColorTable(ps,LCOL_RESET,LCOLF_RGB,0,0,Nil);

     Size:=((((NewWidth*BitCount)+31) Div 32)*4)*NewHeight;
     GetMem(Bits,Size);

     Move(BI^,BIH,SizeOf(BITMAPINFOHEADER));
     BIH.cbFix:=SizeOf(BITMAPINFOHEADER);
     FBitmapHandle:=GpiCreateBitmap(ps,BIH,CBM_INIT,Bits^,BI^);
     //FBitmapHandle:=GpiCreateBitmap(ps,BIH,0,Nil,Nil);
     If FBitmapHandle=0 Then InvalidImage;

     //Fileheader ???
     FBitmapMemLength:=(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+Size0+Size;

     GetMem(FBitmapMem,FBitmapMemLength);

     FH.usType:=BFT_BITMAP
     FH.cbSize:=SizeOf(BITMAPFILEHEADER);
     FH.XHotSpot:=FXHotSpot;
     FH.YHotSpot:=FYHotSpot;
     FH.offBits:=(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+Size0;

     P:=FBitmapMem;
     Move(FH,P^,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Inc(P,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Move(BI^,P^,Size0);
     Inc(P,Size0);
     Move(Bits^,P^,Size);

     FreeMem(BI,Size0);
     FreeMem(Bits,Size);

     FOldBitmap:=GpiSetBitmap(FBitmapPS,FBitmapHandle);
     If FOldBitmap = BMB_ERROR Then InvalidImage;
     FEmpty:=False;
{$ENDIF}
End;
*)

{$IFDEF Win32}
Procedure TBitmap.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
Var Planes,BitCount,Size,Size0:LongWord;
    P,Bits:Pointer;
Var BitmapInfo:PBitmapCoreInfo;
    ADC,MemDC:LongWord;
    OldPal:LongWord;
    DestPal:PLogPalette;
    cbPal:LongWord;
    T:LongInt;
    FTempBmp,FOldTempBmp:LongWord;
    SysPalSize:LongInt;

    Procedure SetPalEntry(Index:LongInt;Color:TColor);
    Begin
         DestPal^.palPalEntry[Index].peRed:=TRGB(Color).Red;
         DestPal^.palPalEntry[Index].peGreen:=TRGB(Color).Green;
         DestPal^.palPalEntry[Index].peBlue:=TRGB(Color).Blue;
         DestPal^.palPalEntry[Index].peFlags:=0;
    End;

Begin
     FIsInvalid:=False; //reset flag !

     ReleaseBitmap;

     Planes:=1;
     If Colors<=2 Then BitCount:=1
     Else If Colors<=16 Then BitCount:=4
     Else If Colors<=256 Then BitCount:=8
     Else BitCount:=16;

     FWidth:=NewWidth;
     FHeight:=NewHeight;
     FOrigBitCount:=BitCount;
     FOrigPlanes:=Planes;
     FColorCount:=Colors;

     Size:=(LongWord(1) shl BitCount) * SizeOf(RGBTriple);
     Size0:=Size + SizeOf(BitmapCoreInfo);
     GetMem(BitmapInfo,Size0);
     With BitmapInfo^.bmciHeader Do
     Begin
          bcSize:=SizeOf(BitmapCoreHeader);
          bcWidth:=NewWidth;
          bcHeight:=NewHeight;
          bcPlanes:=Planes;
          bcBitCount:=BitCount;
     End;

     //Setup BitmapInfo^.bmciColors
     ADC:=CreateCompatibleDC(0);
     Colors:=LongWord(1)  shl BitCount;
     If Colors>256 Then Colors:=256;
     cbPal:=SizeOf(LogPalette)+Colors*SizeOf(PaletteEntry);
     GetMem(DestPal,cbPal);
     GetSystemPaletteEntries(ADC,0,Colors,DestPal^.palPalEntry[0]);
     SysPalSize:=GetDeviceCaps(ADC, SIZEPALETTE);
     DestPal^.palVersion := $300;
     DestPal^.palNumEntries := Colors;
     If FColorCount=16 Then //construct default palette
     Begin
          SetPalEntry(0,ValuesToRGB(0,0,0));
          SetPalEntry(1,ValuesToRGB(128,0,0));
          SetPalEntry(2,ValuesToRGB(0,128,0));
          SetPalEntry(3,ValuesToRGB(128,128,0));
          SetPalEntry(4,ValuesToRGB(0,0,128));
          SetPalEntry(5,ValuesToRGB(128,0,128));
          SetPalEntry(6,ValuesToRGB(0,128,128));
          SetPalEntry(7,ValuesToRGB(192,192,192));
          SetPalEntry(8,ValuesToRGB(128,128,128));
          SetPalEntry(9,ValuesToRGB(255,0,0));
          SetPalEntry(10,ValuesToRGB(0,255,0));
          SetPalEntry(11,ValuesToRGB(255,255,0));
          SetPalEntry(12,ValuesToRGB(0,0,255));
          SetPalEntry(13,ValuesToRGB(255,0,255));
          SetPalEntry(14,ValuesToRGB(0,255,255));
          SetPalEntry(15,ValuesToRGB(255,255,0));
     End;
     If Self Is TIcon Then
     Begin
          SetPalEntry(0,ValuesToRGB(0,0,0));
          SetPalEntry(1,ValuesToRGB(255,255,255));
     End;
     DeleteDC(ADC);
     For T:=0 To FColorCount-1 Do
     Begin
          BitmapInfo^.bmciColors[T].rgbtRed:=DestPal^.palPalEntry[T].peRed;
          BitmapInfo^.bmciColors[T].rgbtGreen:=DestPal^.palPalEntry[T].peGreen;
          BitmapInfo^.bmciColors[T].rgbtBlue:=DestPal^.palPalEntry[T].peBlue;
     End;
     FBitmapPal:=WinGDI.CreatePalette(DestPal^);
     FreeMem(DestPal,cbPal);

     Size:=((((NewWidth*BitCount)+31) Div 32)*4)*NewHeight;
     GetMem(Bits,Size);

     ADC:=GetDC(0);
     MemDC:=CreateCompatibleDC(ADC);
     FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
     FOldTempBmp:=SelectObject(MemDC,FTempBmp);

     If FBitmapPal<> 0 Then
     Begin
          OldPal := SelectPalette(MemDC,FBitmapPal,False);
          WinGDI.RealizePalette(MemDC);
     End
     Else OldPal:=0;

     FBitmapHandle:=CreateDIBitmap(MemDC,BitmapInfo^.bmciHeader,
                                   CBM_INIT,Bits^,PBITMAPINFO(BitmapInfo)^,
                                   DIB_RGB_COLORS);
     If FBitmapHandle=0 Then InvalidImage;

     If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
     SelectObject(MemDC,FOldTempBmp);
     If not DeleteObject(FTempBmp) Then InvalidImage;
     If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
     If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

     FBitmapMemLength:=Size0+Size;

     GetMem(FBitmapMem,FBitmapMemLength);
     P:=FBitmapMem;
     Move(BitmapInfo^,P^,Size0);
     Inc(P,Size0);
     Move(Bits^,P^,Size);

     FreeMem(Bits,Size);
     FreeMem(BitmapInfo,Size0);

     FEmpty:=False;
End;
{$ENDIF}

{$IFDEF OS2}
{Rewritten by Aaron Lawrence}
Procedure TBitmap.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
Var
   BitCount: LongWord;
   DeviceContextData:DEVOPENSTRUC;
   DriverName:cstring;
   PresentationPageSize: SIZEL;
   BitmapInformationHeader: BITMAPINFOHEADER;

   PaletteColors: array[ 0..255 ] of longword;

   OldBitmap: HBITMAP;
   Palette: HPALETTE;
   OldPalette: HPALETTE;
   pDefaultColors: PLONG;
   rc: ERRORID;
Begin
     FIsInvalid:= False; //reset flag !

     ReleaseBitmap;

     If Colors <= 2 Then
       BitCount := 1
     Else If Colors <= 16 Then
       BitCount := 4
     Else If Colors <= 256 Then
       BitCount := 8
     Else If Colors <= 65536 Then
       BitCount := 16
     Else
       BitCount := 32;

     FWidth := NewWidth;
     FHeight := NewHeight;
     FOrigBitCount := BitCount;
     FOrigPlanes := 1;
     FColorCount := Colors;

     // Create a memory device context
     FillChar( DeviceContextData,
               SizeOf( DeviceContextData ),
               0 );

     DriverName:='DISPLAY'; // set to display driver
     DeviceContextData.pszDriverName:= @DriverName;

     FBitmapDC := DevOpenDC( AppHandle, // app anchor block
                             OD_MEMORY, // DC type = memory
                             '*',       // no device information
                             2,         // number of items in dop
                             DeviceContextData, // device open structure
                             0 );       // compatibility with screen
     If FBitmapDC = 0 Then
       InvalidImage;             // failed to create DC

     // Create a presentation space
     PresentationPageSize.CX := 1;
     PresentationPageSize.CY := 1; // huh?

     FBitmapPS := GpiCreatePS( AppHandle,       // app anchor block
                               FBitmapDC,       // device context
                               PresentationPageSize, // size
                               PU_PELS          // use pixels
                               Or GPIA_ASSOC    // associate with DC
                               Or GPIT_MICRO ); // micro PS
     If FBitmapPS = GPI_ERROR Then
       InvalidImage;

     // Create the bitmap

     FillChar( BitmapInformationHeader,
               sizeof( BitmapInformationHeader ),
               0 );
     BitmapInformationHeader.cbFix := sizeof( BitmapInformationHeader );
     BitmapInformationHeader.cx := Width;
     BitmapInformationHeader.cy := Height;
     BitmapInformationHeader.cPlanes := 1;
     BitmapInformationHeader.cBitCount := BitCount;
     FBitmapHandle:= GpiCreateBitmap( FBitmapPS,
                                      BitmapInformationHeader,
                                      0, // don't initialise
                                      nil,
                                      nil );

     // set the bitmap into the presentation space so we can draw on it
     OldBitmap := GpiSetBitmap( FBitmapPS,
                                FBitmapHandle );
     if OldBitmap = HBM_ERROR then
       InvalidImage;

     if BitCount < 16 then
     begin
       // create and initialise the palette

       // blank out palette
       FillChar( PaletteColors, sizeof( PaletteColors ), 0 );

       // retrieve default colors (first 16)
       pDefaultColors := PLONG( @PaletteColors );
       GpiQueryLogColorTable( FBitmapPS,
                              0, // flags
                              0, // first color
                              15, // last color
                              pDefaultColors^ );

       // Create a palette
       Palette := GpiCreatePalette( AppHandle, // application anchor block
                                    0,         // options - none
                                    LCOLF_CONSECRGB, // format (standard)
                                    ColorCount,
                                    PaletteColors );
       if Palette = GPI_ERROR Then
       begin
         rc := WinGetLastError( AppHandle );
         InvalidImage;
       end;

       OldPalette := GpiSelectPalette( FBitmapPS,
                                       Palette );
       if OldPalette = PAL_ERROR Then
         InvalidImage;
     end
     else
     begin
       // set into non-palettised mode (I think?)
       GpiCreateLogColorTable(FBitmapPS,LCOL_RESET,LCOLF_RGB,0,0,NIL);
     end;

     FEmpty:=False;
End;
{$ENDIF}

Function TBitmap.IsEqual(Bitmap:TBitmap):Boolean;
Begin
     Result := False;
     If Bitmap <> Nil Then
       If Bitmap.FBitmapMemLength = FBitmapMemLength Then
       Begin
         If FBitmapMemLength = 0 Then Result := True
         Else If CompareMem(Bitmap.FBitmapMem^,FBitmapMem^,FBitmapMemLength)
              Then Result := True;
       End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TIcon Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TIcon.ReadStream(Stream:TStream;Size:LongInt);

// Var MemIcon : tMemoryStream;

Begin
  inherited ReadStream(Stream, Size);
  Case fBitmapTyp of
    btIconOS2  : fIconTyp:=itOS2;
    btIconWin32: fIconTyp:=itWin32;
    else fIconTyp:=itUnknown;
  End;
End;


Function TIcon.GetMaskCanvas:TCanvas;
Begin
     If FBitmapPS=0 Then CreateHandle;

     If FMaskCanvas = Nil Then
     Begin
          FMaskCanvas.Create(Self);
          FMaskCanvas.FBitmap:=Self;
          Include(FMaskCanvas.ComponentState, csDetail);
          FMaskCanvas.Handle := FMaskPS;
          FMaskCanvas.Init;
     End
     Else
     Begin
          If FMaskCanvas.Handle<>FMaskPS Then
          Begin
               FMaskCanvas.Handle:=FMaskPS;
               FMaskCanvas.Init;
          End;
     End;
     Result := FMaskCanvas;
End;


Procedure TIcon.CreateHandle;
Begin
     Inherited CreateHandle;
     If FIsInvalid Then exit; //don't create handle for invalid objects (loop) !

     {$IFDEF WIN32}
     If FMaskHandle=0 Then InvalidImage;
     If FMaskPS=0 Then
     Begin
          FMaskPS:=CreateCompatibleDC(0);
          FOldMaskBitmap:=SelectObject(FMaskPS,FMaskHandle);
     End;

     If FMaskCanvas = Nil Then
     Begin
          FMaskCanvas.Create(Self);
          FMaskCanvas.FBitmap:=Self;
          Include(FMaskCanvas.ComponentState, csDetail);
     End;

     If FMaskCanvas.Handle<>FMaskPS Then
     Begin
        MaskCanvas.Handle:=FMaskPS;
        MaskCanvas.Init;
     End;
     {$ENDIF}
End;


Procedure TIcon.DestroyHandle;
Begin
     Inherited DestroyHandle;

     If PermanentHandle Then exit;

     {$IFDEF WIN32}
     If FMaskPal<>0 Then
       If FMaskPS<>0 Then SelectObject(FMaskPS,FOldMaskPalette);
     FOldMaskPalette:=0;
     If FMaskPS<>0 Then
     Begin
          SelectObject(FMaskPS,FOldMaskBitmap);
          If not DeleteDC(FMaskPS) Then InvalidImage;
     End;
     FMaskPS:=0;
     If FMaskCanvas<>Nil Then FMaskCanvas.Handle:=0;
     FOldMaskBitmap:=0;
     If FMaskHandle<>0 Then If not DeleteObject(FMaskHandle) Then InvalidImage;
     FMaskHandle:=0;
     //FIconPointerHandle remains !
     {$ENDIF}
End;


Procedure TIcon.InvalidImage;
Begin
     FIsInvalid:=True;   
     ReleaseBitmap;
     Raise EInvalidIcon.Create(LoadNLSStr(SInvalidIcon));
End;

Function TIcon.GetHandle:LongWord;
Begin
     Result:=FIconPointerHandle;
End;

Procedure TIcon.SetupBitmap;
Begin
     Inherited SetupBitmap;

     CreateIconPointerHandle;

     If FMaskCanvas=Nil Then FMaskCanvas.Create(Self);
     FMaskCanvas.Handle:=FMaskPS;
     FMaskCanvas.Init;
     CreateHandle;
End;

Procedure TIcon.Draw(Canvas:TCanvas;Const Dest:TRect);
{$IFDEF OS2}
Var ptls,maskptls:Array[0..3] Of TPoint;
{$ENDIF}
{$IFDEF Win32}
Var _Dest:TRect;
    OldPal:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     //temporary invert Mask
     maskptls[0].X:=0;
     maskptls[0].Y:=FHeight;
     maskptls[1].X:=FWidth;
     maskptls[1].Y:=FHeight*2;
     maskptls[2].X:=0;
     maskptls[2].Y:=FHeight;
     maskptls[3].X:=FWidth;
     maskptls[3].Y:=FHeight*2;
     GpiBitBlt(FMaskPS,FMaskPS,4,maskptls[0],ROP_NOTSRCCOPY,BBO_IGNORE);

     //Copy Mask Bitmap With logical And (TRANSPARENT areas are now White In the Mask, others Black)
     ptls[0].X:=Dest.Left;
     ptls[0].Y:=Dest.Bottom;
     ptls[1].X:=Dest.Right;
     ptls[1].Y:=Dest.Top;
     ptls[2].X:=0;
     ptls[2].Y:=FHeight;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight*2;
     GpiBitBlt(Canvas.Handle,FMaskPS,4,ptls[0],ROP_SRCAND,BBO_IGNORE);

     GpiBitBlt(FMaskPS,FMaskPS,4,maskptls[0],ROP_NOTSRCCOPY,BBO_IGNORE);

     //Copy color Bitmap With logical Or
     ptls[0].X:=Dest.Left;
     ptls[0].Y:=Dest.Bottom;
     ptls[1].X:=Dest.Right;
     ptls[1].Y:=Dest.Top;
     ptls[2].X:=0;
     ptls[2].Y:=0;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight;
     GpiBitBlt(Canvas.Handle,FBitmapPS,4,ptls[0],ROP_SRCPAINT,BBO_IGNORE);
     {$ENDIF}
     {$IFDEF Win32}
     CreateHandle;

     OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);

     _Dest := Dest;
     RectToWin32Rect(_Dest);
     TransformRectToWin32(_Dest,TControl(Canvas.Control),Canvas.Graphic);

     //Copy Mask Bitmap With logical And (TRANSPARENT areas are Black In the Mask, others White)
     If (_Dest.Right-_Dest.Left=FWidth) And (_Dest.Top-_Dest.Bottom=FHeight) Then
     Begin
          WinGDI.BitBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                        FWidth,FHeight,FMaskPS,0,0,SRCAND);
     End
     Else
     Begin
          StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                     _Dest.Right-_Dest.Left,_Dest.Top-_Dest.Bottom,
                     FMaskPS, 0, 0, FWidth, FHeight,SRCAND);
     End;

     //Copy color Bitmap With logical Xor
     If (_Dest.Right-_Dest.Left=FWidth) And (_Dest.Top-_Dest.Bottom=FHeight) Then
     Begin
          WinGDI.BitBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                        FWidth,FHeight,FBitmapPS,0,0,SRCINVERT);
     End
     Else
     Begin
          StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                     _Dest.Right-_Dest.Left,_Dest.Top-_Dest.Bottom,
                     FBitmapPS, 0, 0, FWidth, FHeight,SRCINVERT);
     End;

     If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);

     DestroyHandle;
     {$ENDIF}
End;

Procedure TIcon.ReleaseBitmap;
Begin
     If FMaskCanvas<>Nil Then
     Begin
         FMaskCanvas.Handle:=0;
         FMaskCanvas.Destroy;
     End;

     {$IFDEF OS2}
     If FMaskPal<>0 Then GpiDeletePalette(FMaskPal);
     If FMaskHandle<>0 Then GpiDeleteBitmap(FMaskHandle);
     If FMaskPS<>0 Then GpiDestroyPS(FMaskPS);
     If FMaskDC<>0 Then DevCloseDC(FMaskDC);
     WinDestroyPointer(FIconPointerHandle);
     {$ENDIF}
     {$IFDEF Win32}
     If FMaskPS<>0 Then
     Begin
          If FMaskHandle<>0 Then SelectObject(FMaskPS,FOldMaskBitmap);
          If FMaskPal<>0 Then SelectObject(FMaskPS,FOldMaskPalette);
     End;
     If FMaskPS<>0 Then If not DeleteDC(FMaskPS) Then InvalidImage;
     If FMaskPal<>0 Then If not DeleteObject(FMaskPal) Then InvalidImage;
     If FMaskHandle<>0 Then If not DeleteObject(FMaskHandle) Then InvalidImage;
     If FIconPointerHandle<>0 Then If not DestroyIcon(FIconPointerHandle) Then InvalidImage;
     {$ENDIF}

     FMaskPS:=0;
     FMaskPal:=0;
     FMaskHandle:=0;
     FMaskDC:=0;
     FIconPointerHandle:=0;

     Inherited ReleaseBitmap;
End;

Procedure TIcon.CreateIconPointerHandle;
{$IFDEF OS2}
Var I:POINTERINFO;
{$ENDIF}
{$IFDEF Win32}
Var I:ICONINFO;
    ADC,MemDC:HDC;
    H,OldBmp:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     GpiSetBitmap(FBitmapPS,0);
     GpiSetBitmap(FMaskPS,0);

     If Self Is TPointer Then I.fPointer:=1
     Else I.fPointer:=0;
     I.XHotSpot:=FXHotSpot;
     I.YHotSpot:=FYHotSpot;
     I.hbmPointer:=FMaskHandle;
     I.hbmColor:=FBitmapHandle;
     I.hbmMiniPointer:=0;
     I.hbmMiniColor:=0;
     FIconPointerHandle:=WinCreatePointerIndirect(HWND_DESKTOP,I);

     GpiSetBitmap(FBitmapPS,FBitmapHandle);
     GpiSetBitmap(FMaskPS,FMaskHandle);
     {$ENDIF}
     {$IFDEF Win32}
     If FIconPointerHandle=0 Then
     Begin
       If Self Is TPointer Then I.FIcon:=False
       Else I.FIcon:=True;

       ADC:=GetDC(0);
       MemDC:=CreateCompatibleDC(ADC);

       //supply both And and Xor Mask For pointers
       If I.FIcon Then H:=CreateBitmap(FWidth,FHeight,1,1,Nil)
       Else H:=CreateBitmap(FWidth,FHeight*2,1,1,Nil);
       OldBmp:=SelectObject(MemDC,H);
       If not I.FIcon Then
       Begin
            WinGDI.BitBlt(MemDC,0,0,FWidth,FHeight*2,MemDC,0,0,WHITENESS);
            WinGDI.BitBlt(MemDC,0,0,FWidth,FHeight,FMaskPS,0,0,SRCCOPY);
       End
       Else WinGDI.BitBlt(MemDC,0,0,FWidth,FHeight,FMaskPS,0,0,SRCCOPY);

       I.XHotSpot:=FXHotSpot;
       I.YHotSpot:=FYHotSpot;
       I.hbmMask:=H;
       I.hbmColor:=FBitmapHandle;
       FIconPointerHandle:=CreateIconIndirect(I);

       SelectObject(MemDC,OldBmp);
       If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
       If ReleaseDC(0,ADC)=0 Then InvalidImage;
       If not DeleteObject(H) Then InvalidImage;
     End;
     {$ENDIF}
End;

Procedure TIcon.Update;
{$IFDEF OS2}
Var cbBuffer,cbBufferMask:LongWord;
    cbInfo,cbInfoMask:LongWord;
    Buf,BufMask:Pointer;
    BI,BIMask:PBITMAPINFO;
    FH,FHMask:BITMAPFILEHEADER;
    BIH,BIHMask:BITMAPINFOHEADER;
    P:Pointer;
{$ENDIF}
{$IFDEF Win32}
Var iDir:TICONDIR;
    BI,BIMask:BitmapInfo;
    pbi,PBIMask:^BitmapInfo;
    P,pMask,pp:Pointer;
    cbInfo,cbInfoMask,cbBuffer,cbBufferMask:LongWord;
{$ENDIF}
Begin
     If ((FBitmapMem=Nil)Or(FBitmapMemLength=0)Or(FBitmapHandle=0)) Then Exit;

     {$IFDEF OS2}
     If FIconPointerHandle<>0 Then WinDestroyPointer(FIconPointerHandle);
     CreateIconPointerHandle;
     {$ENDIF}

     {$IFDEF Win32}
     CreateHandle;
     If FIconPointerHandle<>0 Then DestroyIcon(FIconPointerHandle);
     CreateIconPointerHandle;
     {$ENDIF}

     {$IFDEF OS2}
     BIHMask.cbFix:=SizeOf(BITMAPINFOHEADER);
     If Not GpiQueryBitmapInfoHeader(FMaskHandle,BIHMask) Then Exit;
     cbBufferMask:=(((BIHMask.cBitCount*BIHMask.CX)+31) Div 32)*4*BIHMask.CY*BIHMask.cPlanes;
     GetMem(BufMask,cbBufferMask);
     cbInfoMask:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGB)*(longword(1) Shl BIHMask.cBitCount);
     GetMem(BIMask,cbInfoMask);
     Move(BIHMask,BIMask^,SizeOf(BITMAPINFOHEADER));
     GpiQueryBitmapBits(FMaskPS,0,BIHMask.CY,BufMask^,BIMask^);

     If Self Is TPointer Then FHMask.usType:=BFT_COLORPOINTER
     Else FHMask.usType:=BFT_COLORICON;
     FHMask.cbSize:=SizeOf(BITMAPFILEHEADER);
     FHMask.XHotSpot:=FXHotSpot;
     FHMask.YHotSpot:=FYHotSpot;
     FHMask.offBits:=(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfoMask;

     BIH.cbFix:=SizeOf(BITMAPINFOHEADER);
     If Not GpiQueryBitmapInfoHeader(FBitmapHandle,BIH) Then Exit;
     cbBuffer:=(((BIH.cBitCount*BIH.CX)+31) Div 32)*4*BIH.CY*BIH.cPlanes;
     GetMem(Buf,cbBuffer);
     cbInfo:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGB)*(longword(1) Shl BIH.cBitCount);
     GetMem(BI,cbInfo);
     Move(BIH,BI^,SizeOf(BITMAPINFOHEADER));
     GpiQueryBitmapBits(FBitmapPS,0,BIH.CY,Buf^,BI^);

     If Self Is TPointer Then FH.usType:=BFT_COLORPOINTER
     Else FH.usType:=BFT_COLORICON;
     FH.cbSize:=SizeOf(BITMAPFILEHEADER);
     FH.XHotSpot:=FXHotSpot;
     FH.YHotSpot:=FYHotSpot;
     FH.offBits:=(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfo;
     Inc(FH.offBits,(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfoMask+cbBufferMask);

     Inc(FHMask.offBits,(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfo);

     FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER)+cbInfo+cbBuffer;
     Inc(FBitmapMemLength,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER)+cbInfoMask+cbBufferMask);
     GetMem(FBitmapMem,FBitmapMemLength);
     P:=FBitmapMem;
     Move(FHMask,P^,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Inc(P,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Move(BIMask^,P^,cbInfoMask);
     Inc(P,cbInfoMask);
     Move(FH,P^,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Inc(P,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Move(BI^,P^,cbInfo);
     Inc(P,cbInfo);
     Move(BufMask^,P^,cbBufferMask);
     Inc(P,cbBufferMask);
     Move(Buf^,P^,cbBuffer);

     FreeMem(Buf,cbBuffer);
     FreeMem(BI,cbInfo);
     FreeMem(BufMask,cbBufferMask);
     FreeMem(BIMask,cbInfoMask);
     {$ENDIF}
     {$IFDEF Win32}
     CreateHandle;

     SelectObject(FBitmapPS,FOldBitmap);
     SelectObject(FMaskPS,FOldMaskBitmap);

     FillChar(BI,SizeOf(BI),0);
     FillChar(BIMask,SizeOf(BIMask),0);

     BI.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(FBitmapPS,FBitmapHandle,0,0,Nil,BI,0);
     If FOrigBitCount>0 Then BI.bmiHeader.biBitCount:=FOrigBitCount;
     If FOrigPlanes>0 Then BI.bmiHeader.biPlanes:=FOrigPlanes;

     BIMask.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(FMaskPS,FMaskHandle,0,0,Nil,BIMask,0);

     iDir.idReserved:=0;
     If Self Is TPointer Then iDir.idType:=2
     Else iDir.idType:=1;
     iDir.idCount:=1;
     iDir.idEntries.bWidth:=FWidth;
     iDir.idEntries.bHeight:=FHeight;
     iDir.idEntries.bColorCount:=BI.bmiHeader.biPlanes * (LongWord(1) Shl BI.bmiHeader.biBitCount);
     iDir.idEntries.bReserved:=0;
     iDir.idEntries.wPlanes:=0;
     iDir.idEntries.wBitCount:=0;
     iDir.idEntries.dwBytesInRes:=0{Size Of image};
     iDir.idEntries.dwImageOffset:=SizeOf(TICONDIR);

     cbInfo:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGBQuad)*(longword(1) Shl BI.bmiHeader.biBitCount);
     GetMem(pbi,cbInfo);
     pbi^.bmiHeader:=BI.bmiHeader;
     cbBuffer:=(((BI.bmiHeader.biBitCount*BI.bmiHeader.biWidth)+31) Div 32)
                *4*BI.bmiHeader.biHeight*BI.bmiHeader.biPlanes;
     GetMem(P,cbBuffer);
     GetDIBits(FBitmapPS,FBitmapHandle,0,BI.bmiHeader.biHeight,P^,pbi^,DIB_RGB_COLORS);

     cbInfoMask:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGBQuad)*2;
     GetMem(PBIMask,cbInfoMask);
     With PBIMask^.bmiHeader Do
     Begin
          biSize:=SizeOf(BITMAPINFOHEADER);
          biWidth:=FWidth;
          biHeight:=FHeight;
          biPlanes:=1;
          biBitCount:=1;
     End;
     cbBufferMask:=(((1*BI.bmiHeader.biWidth)+31) Div 32)
                      *4*BI.bmiHeader.biHeight*1;
     GetMem(pMask,cbBufferMask);
     GetDIBits(FMaskPS,FMaskHandle,0,BI.bmiHeader.biHeight,pMask^,PBIMask^,DIB_RGB_COLORS);

     iDir.idEntries.dwBytesInRes:=cbInfo+cbBuffer+cbBufferMask;

     FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=SizeOf(TICONDIR)+iDir.idEntries.dwBytesInRes;
     GetMem(FBitmapMem,FBitmapMemLength);
     pp:=FBitmapMem;
     Move(iDir,pp^,SizeOf(TICONDIR));
     Inc(pp,SizeOf(TICONDIR));
     pbi^.bmiHeader.biHeight:=FHeight*2;
     pbi^.bmiHeader.biSizeImage:=cbBuffer+cbBufferMask;
     Move(pbi^,pp^,cbInfo);
     Inc(pp,cbInfo);
     Move(P^,pp^,cbBuffer);
     Inc(pp,cbBuffer);
     Move(pMask^,pp^,cbBufferMask);

     FreeMem(pbi,cbInfo);
     FreeMem(PBIMask,cbInfoMask);
     FreeMem(P,cbBuffer);
     FreeMem(pMask,cbBufferMask);
     SelectObject(FBitmapPS,FBitmapHandle);
     SelectObject(FMaskPS,FMaskHandle);

     DestroyHandle;
     {$ENDIF}
End;


Procedure TIcon.LoadFromResourceName(Const Name:String);
Var P:Pointer;
    len:LongWord;
Begin
  FIsInvalid:=False; //reset flag !

  P:=FindIconRes(Name,len);
  If ((P=Nil)Or(len=0)) Then InvalidImage;

  ReleaseBitmap;
  FBitmapMemLength:=len;
  GetMem(FBitmapMem,FBitmapMemLength);
  Move(P^,FBitmapMem^,FBitmapMemLength);
  SetupBitmap;
  changed;
  {$IFDEF WIN32}
  DestroyHandle;
  {$ENDIF}
End;

Procedure TIcon.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
{$IFDEF OS2}
Var dop:DEVOPENSTRUC;
    pc:cstring;
    sizl:SIZEL;
    BIH:BITMAPINFOHEADER;
    ps,DC:LongWord;
    ptls:Array[0..3] Of TPoint;
{$ENDIF}
Begin
     FIsInvalid:=False; //reset flag !

     If ((Colors<>2)And(Colors<>16)) Then Colors:=16;
     If ((NewWidth<>16)And(NewWidth<>32)And(NewWidth<>64)) Then NewWidth:=32;
     If ((NewHeight<>16)And(NewHeight<>32)And(NewHeight<>64)) Then NewHeight:=32;
     Inherited CreateNew(NewWidth,NewHeight,Colors);

     {$IFDEF Win32}
     fIconTyp:=itWin32;
     FMaskWidth:=FWidth;
     FMaskHeight:=FHeight;
     FMaskHandle:=CreateBitmap(FWidth,FHeight,1,1,Nil);
     If FMaskHandle=0 Then InvalidImage;
     FMaskPS:=CreateCompatibleDC(0);
     FOldMaskPalette:=SelectPalette(FMaskPS,FBitmapPal,True);
     FOldMaskBitmap:=SelectObject(FMaskPS,FMaskHandle);
     WinGDI.BitBlt(FMaskPS,0,0,FWidth,FHeight,FMaskPS,0,0,WHITENESS);
     {$ENDIF}
     {$IFDEF OS2}
     fIconTyp:=itOS2;
     FMaskWidth:=FWidth;
     FMaskHeight:=FHeight*2;

     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     DC := DevOpenDC(AppHandle,OD_MEMORY,'*',3,dop,0);
     If DC=0 Then InvalidImage;
     FMaskDC:=DC;

     sizl.CX := 1;
     sizl.CY := 1;
     ps := GpiCreatePS(AppHandle,DC,sizl,PU_PELS Or GPIA_ASSOC Or GPIT_MICRO);
     If ps = GPI_ERROR Then InvalidImage;
     GpiCreateLogColorTable(ps,LCOL_RESET,LCOLF_RGB,0,0,Nil);
     FMaskPS:=ps;

     With BIH Do
     Begin
          cbFix:=SizeOf(BITMAPINFOHEADER);
          CX:=FMaskWidth;
          CY:=FMaskHeight;
          cPlanes:=1;
          cBitCount:=1;
     End;
     FMaskHandle:=GpiCreateBitmap(FMaskPS,BIH,0,Nil,Nil);
     If FMaskHandle=0 Then InvalidImage;

     FOldMaskBitmap:=GpiSetBitmap(FMaskPS,FMaskHandle);
     If FOldMaskBitmap = HBM_ERROR Then InvalidImage;

     ptls[0].X:=0;
     ptls[0].Y:=0;
     ptls[1].X:=FWidth;
     ptls[1].Y:=FHeight;
     ptls[2].X:=0;
     ptls[2].Y:=0;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight;
     GpiBitBlt(FMaskPS,FMaskPS,4,ptls[0],ROP_ZERO,BBO_IGNORE);

     ptls[0].X:=0;
     ptls[0].Y:=FHeight;
     ptls[1].X:=FWidth;
     ptls[1].Y:=FHeight*2;
     ptls[2].X:=0;
     ptls[2].Y:=FHeight;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight*2;
     GpiBitBlt(FMaskPS,FMaskPS,4,ptls[0],ROP_ONE,BBO_IGNORE);
     {$ENDIF}
     FMaskCanvas.Create(Self);
     FMaskCanvas.Handle:=FMaskPS;
     FMaskCanvas.Init;

     Update;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPointer Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TPointer.InvalidImage;

Begin
  FIsInvalid:=True;
  ReleaseBitmap;
  Raise EInvalidCursor.Create(LoadNLSStr(SInvalidCursor));
End;

Procedure TPointer.LoadFromResourceName(Const Name:String);

Var P:Pointer;
    len:LongWord;

Begin
  FIsInvalid:=False; //reset flag !
  P:=FindPointerRes(Name,len);
  If ((P=Nil)Or(len=0)) Then InvalidImage;
  ReleaseBitmap;
  FBitmapMemLength:=len;
  GetMem(FBitmapMem,FBitmapMemLength);
  Move(P^,FBitmapMem^,FBitmapMemLength);
  SetupBitmap;
  changed;
  {$IFDEF WIN32}
  DestroyHandle;
  {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TBitmapList Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TBitmapList.CopyBitmap(original:TBitmap):TBitmap;
Var  locClass:TBitmapClass;
Begin
     If original Is TBitmap Then
     Begin
          {Create local Bitmap}
          If FBitmapClass <> Nil Then locClass := BitmapClass
          Else locClass := original.ClassType;
          Result := locClass.Create;
          If Original.Owner<>Nil Then
          Begin
              Result.Owner:=Original.Owner;
              Original.Owner.InsertComponent(Result);
          End;
          Result.LoadFromBitmap(original);
     End
     Else Result := Nil;
End;


Function TBitmapList.GetBitmap(Index:LongInt):TBitmap;
Begin
     Result := Items[Index];
End;


Procedure TBitmapList.SetBitmap(Index:LongInt;Bitmap:TBitmap);
Var  Item:TBitmap;
Begin
     Item := Items[Index];
     FreeItem(Item);
     Items[Index] := CopyBitmap(Bitmap);
End;


Procedure TBitmapList.FreeItem(Item:Pointer);
Var  bmp:TBitmap;
Begin
     {Destroy local Bitmap}
     bmp := Item;
     If bmp Is TBitmap Then bmp.Destroy;
End;


Function TBitmapList.Add(Item:TBitmap):LongInt;
Begin
     If Not FDuplicates Then
     Begin
          Result := IndexOfOrigin(Item);
          If Result >= 0 Then Exit;     {original found}
     End;

     Result := TList.Add(CopyBitmap(Item));
End;


Function TBitmapList.AddResourceId(BmpId:LongWord):LongInt;
Var  bmp:TBitmap;
Begin
     bmp.Create;
     bmp.LoadFromResourceId(BmpId);
     Result := Add(bmp);   {creates A local Copy}
     bmp.Destroy; {#}
End;


Function TBitmapList.AddResourceName(Const Name:String):LongInt;
Var  bmp:TBitmap;
Begin
     bmp.Create;
     bmp.LoadFromResourceName(Name);
     Result := Add(bmp);   {creates A local Copy}
     bmp.Destroy; {#}
End;


Procedure TBitmapList.Insert(Index:LongInt;Item:TBitmap);
Begin
     TList.Insert(Index,CopyBitmap(Item));
End;


Function TBitmapList.IndexOfOrigin(Item:TBitmap):LongInt;
Var  locBitmap:TBitmap;
Begin
     For Result := 0 To Count-1 Do
     Begin
          locBitmap := Items[Result];
          If locBitmap <> Nil Then
            If locBitmap.IsEqual(Item) Then Exit;
     End;
     Result := -1;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TImageList Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TImageList.NewItem:PImageItem;
Begin
    New(Result);
End;

Function TImageList.Add(Image,Mask:TBitmap):LongInt;
Var Item:PImageItem;
Begin
    Item:=NewItem;
    Item^.Bitmap:=Image.Copy;
    If Mask<>Nil Then Item^.Mask:=Mask.Copy;
    Result:=FList.Add(Item);
    Change;
End;

Function TImageList.AddIcon(Image:TIcon):LongInt;
Var Item:PImageItem;
Begin
    Item:=NewItem;
    Item^.Icon:=TIcon(Image.Copy);
    Result:=FList.Add(Item);
    Change;
End;

Procedure TImageList.AddImages(Value:TImageList);
Var t:LongInt;
    Item,Item1:PImageItem;
Begin
    If Value<>Nil Then For t:=0 To Value.Count-1 Do
    Begin
        Item:=Value.FList[t];
        Item1:=NewItem;
        If Item^.Bitmap<>Nil Then Item1^.Bitmap:=Item^.Bitmap.Copy;
        If Item^.Mask<>Nil Then Item1^.Mask:=Item^.Mask.Copy;
        If Item^.Icon<>Nil Then Item1^.Icon:=TIcon(Item^.Icon.Copy);

        FList.Add(Item1);
    End;
    Change;
End;

Procedure TImageList.Initialize;
Begin
    FImageType:=itImage;
    FMasked:=False;

    FList.Create;
    FList.ImageList:=Self;
End;

Procedure TImageList.SetupComponent;
Begin
    Inherited SetupComponent;

    Include(ComponentState, csHandleLinks);
    Initialize;
End;

Procedure TImageList.DisposeItem(Item:PImageItem);
Begin
    Dispose(Item);
End;

Procedure TImageList.Clear;
Var t:LongInt;
    Item:PImageItem;
Begin
    For t:=0 To FList.Count-1 Do
    Begin
        Item:=FList[t];
        If Item^.Bitmap<>Nil Then Item^.Bitmap.Destroy;
        If Item^.Mask<>Nil Then Item^.Mask.Destroy;
        If Item^.Icon<>Nil Then Item^.Icon.Destroy;
        DisposeItem(Item);
    End;
    FList.Clear;
    Change;
End;

Destructor TImageList.Destroy;
Begin
    Clear;
    FList.Destroy;
    Inherited Destroy;
End;

Procedure TImageList.Change;
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;

Function TImageList.GetCount:LongInt;
Begin
     Result:=FList.Count;
End;

Procedure TImageList.Delete(Index:LongInt);
Var Item:PImageItem;
Begin
     Item:=FList[Index];
     FList.Delete(Index);
     If Item^.Bitmap<>Nil Then Item^.Bitmap.Destroy;
     If Item^.Mask<>Nil Then Item^.Mask.Destroy;
     If Item^.Icon<>Nil Then Item^.Icon.Destroy;
     DisposeItem(Item);
End;

Procedure TImageList.Replace(Index:LongInt;Image,Mask:TBitmap);
Var Item:PImageItem;
Begin
   Item:=FList[Index];
   If Item^.Bitmap<>Nil Then Item^.Bitmap.Destroy;
   If Item^.Mask<>Nil Then Item^.Mask.Destroy;
   Item^.Bitmap:=Image.Copy;
   If Mask<>Nil Then Item^.Mask:=Mask.Copy
   Else Item^.Mask:=Nil;
End;

Procedure TImageList.ReplaceIcon(Index:LongInt;Image:TIcon);
Var Item:PImageItem;
Begin
    Item:=FList[Index];
    If Item^.Icon<>Nil Then Item^.Icon.Destroy;
    Item^.Icon:=TIcon(Image.Copy);
End;

Procedure TImageList.Insert(Index:LongInt;Image,Mask:TBitmap);
Var Item:PImageItem;
Begin
     Item:=NewItem;
     Item^.Bitmap:=Image.Copy;
     If Mask<>Nil Then Item^.Mask:=Mask.Copy;
     FList.Insert(Index,Item);
End;

Procedure TImageList.InsertIcon(Index:LongInt;Image:TIcon);
Var Item:PImageItem;
Begin
     Item:=NewItem;
     Item^.Icon:=TIcon(Image.Copy);
     FList.Insert(Index,Item);
End;

Procedure TImageList.GetBitmap(Index:LongInt;Image:TBitmap);
Begin
     Image.LoadFromBitmap(PImageItem(FList[Index])^.Bitmap);
End;

Procedure TImageList.GetIcon(Index: Integer;Icon:TIcon);
Begin
     Icon.LoadFromBitmap(PImageItem(FList[Index])^.Icon);
End;

Procedure TImageList.GetMask(Index:LongInt;Mask:TBitmap);
Begin
     Mask.LoadFromBitmap(PImageItem(FList[Index])^.Mask);
End;

Procedure TImageList.Move(CurIndex,NewIndex:LongInt);
Begin
     FList.Move(CurIndex,NewIndex);
End;

Procedure TImageList.Draw(Canvas:TCanvas;X,Y,Index:LongInt);
Var Bitmap,Mask:TBitmap;
    Source,Dest:TRect;
Begin
    Bitmap.Create;
    Try
      If ImageType=itImage Then GetBitmap(Index,Bitmap)
      Else GetMask(Index,Bitmap);
    Except
      Bitmap.Destroy;
      Bitmap:=Nil;
    End;
    If Bitmap=Nil Then exit;
    If Bitmap.Empty Then
    Begin
        Bitmap.Destroy;
        exit;
    End;

    Dest.Left:=X;
    Dest.Bottom:=Y;
    Dest.Right:=Dest.Left+Bitmap.Width;
    Dest.Top:=Dest.Bottom+Bitmap.Height;
    If ImageType=itImage Then
    Begin
         If Masked Then
         Begin
            Mask.Create;
            Try
              GetMask(Index,Mask)
            Except
              Mask.Destroy;
              Mask:=Nil;
            End;
            If Mask=Nil Then
            Begin
                 Bitmap.Destroy;
                 exit;
            End;
            If Mask.Empty Then
            Begin
                Mask.Destroy;
                Bitmap.Draw(Canvas,Dest);
                Bitmap.Destroy;
                exit;
            End;

            Source.Left:=0;
            Source.Right:=Mask.Width;
            Source.Bottom:=0;
            Source.Top:=Mask.Height;
            Mask.Canvas.BitBlt(Canvas,Dest,Source,cmSrcAnd,bitfIgnore);
            Source.Right:=Bitmap.Width;
            Source.Top:=Bitmap.Height;
            Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcPaint,bitfIgnore);
            Mask.Destroy;
         End
         Else Bitmap.Draw(Canvas,Dest);
    End
    Else Bitmap.Draw(Canvas,Dest);
    Bitmap.Destroy;
End;

Procedure TImageList.SetList(Item:TImageItemList);
Begin
    If Item<>Nil Then If FList<>Item Then
    Begin
        FList.Destroy;
        FList:=Item;
    End;
End;

Procedure TImageList.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var Count,t,l:LongInt;
    pl:^LONGINT;
    p:Pointer;
    Item:PImageItem;

    Procedure ReadImage(Var Bitmap:TBitmap;IsIcon:Boolean);
    Begin
         l:=pl^;
         inc(pl,4);
         If l<>0 Then
         Begin
              GetMem(p,l);
              System.Move(pl^,p^,l);
              inc(pl,l);
              If IsIcon Then Bitmap:=TIcon.Create
              Else Bitmap:=TBitmap.Create;
              Bitmap.LoadFromMem(p^,l);
              FreeMem(p,l);
         End;
    End;

Begin
    If ResName=rnBitmapList Then
    Begin
         pl:=@Data;
         Count:=pl^;
         inc(pl,4);
         For t:=0 To Count-1 Do
         Begin
              Item:=NewItem;

              ReadImage(Item^.Bitmap,False);
              ReadImage(Item^.Mask,False);
              ReadImage(Item^.Icon,True);

              FList.Add(Item);
         End;
    End
    Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Function TImageList.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    t:LONGINT;
    Item:PImageItem;

    Procedure WriteImage(Bitmap:TBitmap);
    Var tt:Longint;
        BStream:TMemoryStream;
    Begin
        tt:=0;
        If Bitmap=Nil Then MemStream.Write(tt,4)
        Else
        Begin
            BStream.Create;
            Try
              Bitmap.SaveToStream(BStream);
              tt:=BStream.Size;
              MemStream.Write(tt,4);
              MemStream.Write(BStream.Memory^,BStream.Size);
            Finally
              BStream.Destroy;
            End;
        End;
    End;

Begin
     result:=Inherited WriteSCUResource(Stream);
     If not result Then exit;

     MemStream.Create;

     t:=FList.Count;
     MemStream.Write(t,4);

     For t:=0 To FList.Count-1 Do
     Begin
          Item:=FList[t];
          Try
            WriteImage(Item^.Bitmap);
            WriteImage(Item^.Mask);
            WriteImage(Item^.Icon);
          Except
            MemStream.Destroy;
            MemStream:=Nil;
            t:=FList.Count-1;
          End;
     End;

     If MemStream<>Nil Then
     Begin
       result:=Stream.NewResourceEntry(rnBitmapList,MemStream.Memory^,MemStream.Size);
       MemStream.Destroy;
     End
     Else Result:=False;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TMetaFileCanvas Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TMetaFileCanvas.Create(AMetafile: TMetafile);
{$IFDEF OS2}
Var sizlPage:SIZEL;
{$ENDIF}
Begin
     If ((AMetaFile=Nil)Or(AMetaFile.FMetaFileCanvas<>Nil)) Then Fail;

     Inherited Create(AMetaFile);
     Include(ComponentState, csDetail);
     {$IFDEF OS2}
     sizlPage.CX:=0;
     sizlPage.CY:=0;
     Handle := GpiCreatePS(AppHandle,AMetaFile.FDeviceHandle,sizlPage,
                           PU_PELS OR GPIA_ASSOC);
     GpiCreateLogColorTable(Handle,LCOL_RESET,LCOLF_RGB,0,0,Nil);
     {$ENDIF}
     Init;
     FMetaFile:=AMetaFile;
     FMetaFile.FMetaFileCanvas:=Self;
End;

Destructor TMetaFileCanvas.Destroy;
Begin
     {$IFDEF OS2}
     If Handle<>0 Then
     Begin
          GpiAssociate(Handle,0);
          GpiDestroyPS(Handle);
          Handle:=0;
     End;
     {$ENDIF}
     FMetaFile.FMetaFileCanvas:=Nil;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TMetaFile Class Implementation                              บ
บ                                                                           บ
บ completed by Martin Vieregg www.hypermake.de (5/2004)                     บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TMetaFile.GetEmpty: Boolean;
Begin
     //not implemented yet
     Result:=False;
End;

const
  co : longword = 22;

Procedure TMetaFile.Assign(Source:TPersistent);
Begin
     If Source Is TMetaFile Then
     Begin
          If FMetaFileCanvas<>Nil Then FMetaFileCanvas.Destroy;
          {$IFDEF OS2}
          If FDeviceHandle<>0 Then DevCloseDC(FDeviceHandle);
          FDeviceHandle:=0;
          If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
          FHandle:=0;
          If TMetaFile(Source).FHandle<>0 Then
            FHandle:=GpiCopyMetaFile(TMetaFile(Source).FHandle);
          {$ENDIF}
     End
     Else Inherited Assign(Source);
End;

{$HINTS OFF}
Procedure TMetaFile.Draw(ACanvas: TCanvas;Const Rect: TRect);
{$IFDEF OS2}
Var
  alOpt:Array[0..9] Of LongInt;
  L : Long;
  idps : LONG;
  //Family : LONG;
  matlfXform : MATRIXLF;
  afx : array[0..1] of FIXED;
  fSuccess : boolean;
  ppoint : PPOINTL;
  rct : RECTL;
  ptl : POINTL;
  matlf : MATRIXLF;
  lCXSelection, lCYSelection, lCXBoundary, lCYBoundary : LONG;
const
  Leer : char = ' ';
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FHandle=0 Then
     Begin
          FHandle:=DevCloseDC(FDeviceHandle);
          FDeviceHandle:=0;
     End;

     {if the Metafile fits the whole PS (TImage.Canvas), do not save and restore the PS}
     if (Rect.Left <> 0) and (Rect.Bottom <> 0) then
       idps := GpiSavePS (ACanvas.Handle);
     GpiResetPS (ACanvas.Handle, GRES_ATTRS);

     alOpt[PMF_SEGBASE]:=0;
     alOpt[PMF_LOADTYPE]:=LT_DEFAULT;
     alOpt[PMF_RESOLVE]:=RS_DEFAULT;
     alOpt[PMF_LCIDS]:=LC_DEFAULT;
     alOpt[PMF_COLORTABLES]:=CTAB_REPLACE;
     alOpt[PMF_COLORREALIZABLE]:=CREA_DEFAULT;

     alOpt[PMF_RESET]:=RES_RESET;
     alOpt[PMF_SUPPRESS]:=SUP_SUPPRESS;
     L := GpiPlayMetaFile(ACanvas.Handle,FHandle,8,alOpt[0],Nil,0,Nil);

     rct := RECTL(rect);

     {There are two ways of calculating the right size of the Metafile.
      If it is part of an tImage and not a physical device (a printer), GpiSetPageViewport works.
      Otherwise there's the need of Joel Barnums code}

     //DevQueryCaps (GpiQueryDevice(ACanvas.Handle), CAPS_FAMILY, 1, Family);

     if (Rect.Left <> 0) and (Rect.Bottom <> 0) then begin

       {the following code is based on the sample code of Joel Barnum, 1996,
        published in os2.programmers.misc, and works fine with printer devices }

       GpiSetDefaultViewMatrix(ACanvas.Handle, 0, NIL, TRANSFORM_REPLACE);
       fillchar (matlfXform, sizeof(matlfXform), #0);

       // convert import rectangle to world coordinates
       // for the PS now setup for the metafile
       ppoint := @rct;
       fSuccess := GpiConvert ( ACanvas.Handle, CVTC_DEVICE
                            , CVTC_WORLD
                            , 2, ppoint^);

       // convert boundary rectangle to world coordinates
       // for the PS now setup for the metafile
       ppoint := @rectlMet;
       fSuccess := GpiConvert ( ACanvas.Handle, CVTC_MODEL, CVTC_WORLD, 2, ppoint^);

       // translate the metafile to the import rectangle
       ptl.x := Rct.xLeft - rectlMet.xLeft;
       ptl.y := Rct.yBottom - rectlMet.yBottom;
       fSuccess := GpiTranslate ( ACanvas.Handle, matlf, TRANSFORM_REPLACE , ptl);

       // apply a transform to fit metafile in rectangle
       // user specified for the picture
       // first calculate width and height of rectangles

       lCXSelection := ( Rct.xRight  -
                        Rct.xLeft );
       lCYSelection := ( Rct.yTop    -
                        Rct.yBottom );
       lCXBoundary  := ( rectlMet.xRight -
                        rectlMet.xLeft );
       lCYBoundary  := ( rectlMet.yTop -
                        rectlMet.yBottom );

       // next, calculate a scaling factor from the
       // imported picture to the selection rectangle
       afx[0] := FIXED(( lCXSelection * 65536 ) / lCXBoundary);
       afx[1] := FIXED(( lCYSelection * 65536 ) / lCYBoundary);

       // we scale around the lower left of the
       // import rectangle
       ptl.x := Rct.xLeft;
       ptl.y := Rct.yBottom;

       // use GpiScale helper API to fill in transform
       // matrix to scale and translate imported picture
       fSuccess := GpiScale (ACanvas.Handle, matlf, TRANSFORM_ADD
                           , afx[0], ptl );

       // apply the transform matrix so all subsequent
       // drawing is scaled and translated
       fSuccess := GpiSetDefaultViewMatrix ( ACanvas.Handle
                                   , 9
                                   , matlf
                                   , TRANSFORM_REPLACE );
       {end of Joel Barnums Code}

     end
     else begin
       {Metafile fits the whole PS, that means Metafile is part of tImage}
       GpiSetPageViewport (ACanvas.Handle, Rct);
     end;

     alOpt[PMF_RESET]:=RES_DEFAULT;
     alOpt[PMF_SUPPRESS]:=SUP_DEFAULT;
     L := GpiPlayMetaFile(ACanvas.Handle,FHandle,8,alOpt[0],Nil,0,Nil);
     if (Rect.Left <> 0) and (Rect.Bottom <> 0) then begin
       GpiRestorePS (ACanvas.Handle, idps);
       GpiCharString (ACanvas.Handle, 1, Leer); {otherwise, sometimes the next printed Word has got wrong character spacing}
     end;
     {$ENDIF}
End;
{$HINTS ON}

Procedure TMetaFile.SetupComponent;
{$IFDEF OS2}
Var dop:DEVOPENSTRUC;
    pc:CString;
{$ENDIF}
Begin
     Inherited SetupComponent;

     {$IFDEF OS2}
     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     FDeviceHandle:=DevOpenDC(AppHandle,OD_METAFILE,'*',2,dop,0);
     {$ENDIF}
End;

Destructor TMetaFile.Destroy;
Begin
     If FMetaFileCanvas<>Nil Then FMetaFileCanvas.Destroy;
     {$IFDEF OS2}
     If FDeviceHandle<>0 Then DevCloseDC(FDeviceHandle);
     FDeviceHandle:=0;
     If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
     FHandle:=0;
     {$ENDIF}
End;

Function TMetaFile.GetHandle:LongWord;
Begin
     Result:=FHandle;
End;

Procedure TMetaFile.LoadFromFile(Const FileName:String);
Begin
     {$IFDEF OS2}
     FHandle:=GpiLoadMetaFile(AppHandle,FileName);
     CalculateWidthHeight;
     {$ENDIF}
End;

Procedure TMetaFile.SaveToFile(Const Filename: String);
Begin
     {$IFDEF OS2}
     If FHandle=0 Then
     Begin
         If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
         FHandle:=DevCloseDC(FDeviceHandle);
         FDeviceHandle:=0;
     End;
     GpiSaveMetaFile(FHandle,FileName);
     {$ENDIF}
End;

Procedure TMetaFile.LoadFromStream(Stream: TStream);

{$IFDEF OS2}
Var p:Pointer;
    Len:LongInt;
{$ENDIF}
Begin
    {$IFDEF OS2}
    Len:=Stream.Size-Stream.Position;
    GetMem(p,Len);
    Stream.Read(p^,Stream.Size-Stream.Position);
    If FHandle=0 Then
    Begin
        If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
        FHandle:=DevCloseDC(FDeviceHandle);
        FDeviceHandle:=0;
    End;
    GpiSetMetaFileBits(FHandle,0,Len,p^);
    FreeMem(p,Len);
    {$ENDIF}
    CalculateWidthHeight;
End;

Procedure TMetaFile.SaveToStream(Stream: TStream);

{$IFDEF OS2}
Var p:Pointer;
    Len:LongInt;
{$ENDIF}
Begin
   {$IFDEF OS2}
   If FHandle=0 Then
   Begin
        If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
        FHandle:=DevCloseDC(FDeviceHandle);
        FDeviceHandle:=0;
   End;
   Len:=GpiQueryMetaFileLength(FHandle);
   GetMem(p,Len);
   GpiQueryMetaFileBits(FHandle,0,Len,p^);
   Stream.Write(p^,Len);
   FreeMem(p,Len);
   {$ENDIF}
End;

Function TMetaFile.CopyGraphic:TGraphic;
Begin
     Result:=TMetaFile.Create;
     {$IFDEF OS2}
     If FHandle=0 Then
     Begin
         If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
         FHandle:=DevCloseDC(FDeviceHandle);
         FDeviceHandle:=0;
     End;
     TMetaFile(Result).FHandle:=GpiCopyMetaFile(FHandle);
     {$ENDIF}
End;

Procedure TMetaFile.LoadFromHandle(Handle:LongWord);
Begin
     {$IFDEF OS2}
     If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
     FHandle:=GpiCopyMetaFile(Handle);
     {$ENDIF}
End;

{Martin}
Function TMetaFile.LoadFromClipBoard:Boolean;
Var hbmClipbrd:LongWord;
Begin
     //FIsInvalid:=False; //reset flag !

     Result:=False;
     Clipboard.Open(Handle);
     If Clipboard.IsFormatAvailable(cfMetafile) Then
     Begin
          hbmClipbrd:=Clipboard.GetAsHandle(cfMetafile);
          If hbmClipbrd<>0 Then
          Begin
               LoadFromHandle(hbmClipbrd);
               Result:=Not Empty;
          End;
     End;
     Clipboard.Close;
     CalculateWidthHeight;
End;

procedure tMetafile.CalculateWidthHeight;
{$IFDEF OS2}
Var alOpt:Array[0..9] Of LongInt;
    L : Long;
    Rect : RECTL;
    fSuccess : boolean;
    ahps : HPS;
    ahwnd : HWND;
    szTarget : SIZEL;
    rclTarget : RECTL;
{$ENDIF}
Begin
     {$IFDEF OS2}
     {using an arbitrary valid window handle - drawing is invisible}
     ahwnd := Application.Mainform.Handle;
     WinQueryWindowRect(ahwnd, rclTarget);
     dec(rclTarget.xRight); dec(rclTarget.yTop);
     szTarget.cx := rclTarget.xRight - rclTarget.xLeft;
     szTarget.cy := rclTarget.yTop - rclTarget.yBottom;

     ahps := GpiCreatePS(WinQueryAnchorBlock(ahwnd),
              (*GpiQueryDevice(Application.Mainform.Canvas.Handle)*)HDC(0), szTarget,
              GPIT_NORMAL (*OR GPIA_ASSOC*) OR GPIF_LONG OR PU_ARBITRARY);

     alOpt[PMF_SEGBASE]:=0;
     alOpt[PMF_LOADTYPE]:=LT_DEFAULT;
     alOpt[PMF_RESOLVE]:=RS_DEFAULT;
     alOpt[PMF_LCIDS]:=LC_DEFAULT;
     alOpt[PMF_COLORTABLES]:=CTAB_DEFAULT;
     alOpt[PMF_COLORREALIZABLE]:=CREA_DEFAULT;
     alOpt[PMF_RESET]:=RES_DEFAULT;
     alOpt[PMF_SUPPRESS]:=SUP_DEFAULT;

     fSuccess := GpiResetBoundaryData ( ahps );
     fSuccess := GpiSetDrawControl ( ahps
                                   , DCTL_BOUNDARY
                                   , DCTL_ON );
     fSuccess := GpiSetDrawControl ( ahps
                                   , DCTL_DISPLAY
                                   , DCTL_OFF );

     L := GpiPlayMetaFile(ahps,FHandle,8,alOpt[0],Nil,0,Nil);

     //retrieve the boundary rectangle
     fSuccess := GpiQueryBoundaryData ( ahps, rect );
     //if fSuccess then Beep (2000, 100);
     with rect do begin
       if fSuccess then begin
         FWidth := xRight - xLeft;
         FHeight := yTop - yBottom;
         rectlmet := rect;
       end
       else begin
         {this should not be executed}
         FWidth := 100;
         FHeight := 100;
       end;
     end;
     GpiDestroyPS (ahps);
     {$ENDIF}
end;

Function TMetaFile.GetCanvas:TCanvas;
Begin
     Result:=TCanvas(FMetaFileCanvas);
End;

Function TMetaFile.GetSize:LongInt;
Begin
     {$IFDEF OS2}
     If FHandle<>0 Then Result:=GpiQueryMetaFileLength(FHandle)
     Else Result:=0;
     {$ENDIF}
End;

{$HINTS OFF}
Procedure TMetaFile.PaletteChanged;
Begin
     //not implemented yet
End;
{$HINTS ON}

{$HINTS OFF}
Procedure TMetaFile.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
{$IFDEF OS2}
Var dop:DEVOPENSTRUC;
    pc:CString;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FMetaFileCanvas<>Nil Then FMetaFileCanvas.Destroy;
     If FDeviceHandle<>0 Then DevCloseDC(FDeviceHandle);
     FDeviceHandle:=0;
     If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
     FHandle:=0;
     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     FDeviceHandle:=DevOpenDC(AppHandle,OD_METAFILE,'*',2,dop,0);
     {$ENDIF}
End;
{$HINTS ON}

{$HINTS OFF}
Function TMetaFile.CreateMask(Color:TColor):TGraphic;
Begin
     //not supported yet
     Result:=Nil;
End;
{$HINTS ON}

{$HINTS OFF}
Procedure TMetaFile.PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);
Begin
     //not supported yet
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPicture Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TPicture.GetBitmap:TBitmap;
Begin
     ForceType(TBitmap);
     Result:=TBitmap(FGraphic);
End;

Function TPicture.GetEmpty:Boolean;
Begin
     Result:=FGraphic=Nil;
End;

Function TPicture.HasFormat(GraphicClass:TGraphicClass):Boolean;
Begin
     Result:=FGraphic Is GraphicClass;
End;

Function TPicture.GetHeight:LongInt;
Begin
    If FGraphic<>Nil Then Result:=FGraphic.Height
    Else Result:=0;
End;

Procedure TPicture.AssignTo(Dest:TPersistent);
Begin
     If FGraphic Is Dest.ClassType Then Dest.Assign(FGraphic)
     Else Inherited AssignTo(Dest);
End;

Procedure TPicture.Assign(Source:TPersistent);
Begin
    If Source=Nil then Graphic:=Nil
    Else If Source Is TGraphic Then Graphic:=TGraphic(Source)
    Else If Source Is TPicture Then Graphic:=TPicture(Source).Graphic
    Else Inherited Assign(Source);
End;

Function TPicture.GetIcon:TIcon;
Begin
     ForceType(TIcon);
     Result:=TIcon(FGraphic);
End;

Function TPicture.GetMetafile:TMetafile;
Begin
     ForceType(TMetaFile);
     Result:=TMetaFile(FGraphic);
End;

Function TPicture.GetWidth:LongInt;
Begin
     If FGraphic<>Nil Then Result:=FGraphic.Width
     Else Result:=0;
End;

Procedure TPicture.SetBitmap(Value: TBitmap);
Begin
     SetGraphic(Value);
End;

Procedure TPicture.SetIcon(Value: TIcon);
Begin
     SetGraphic(Value);
End;

Procedure TPicture.SetMetafile(Value: TMetafile);
Begin
     SetGraphic(Value);
End;

Procedure TPicture.SetGraphic(Value: TGraphic);
Var  NewGraphic:TGraphic;
Begin
  // do not destroy the graphic object changed by the inspector
  If FGraphic <> Value Then
    Begin
      If Value <> Nil Then
         Begin
            NewGraphic := Value.CopyGraphic;
            NewGraphic.OnChange := Changed;
         End
      Else NewGraphic := Nil;

      If FGraphic <> Nil Then FGraphic.Destroy;
      FGraphic := NewGraphic;
      Changed(Self);
    End;
End;


{$HINTS OFF}
Procedure TPicture.Changed(Sender: TObject);
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;
{$HINTS ON}


Destructor TPicture.Destroy;
Begin
     If FGraphic<>Nil Then FGraphic.Destroy;
     Inherited Destroy;
End;

Procedure TPicture.LoadFromFile(Const Filename:String);
Var  Ext:String;
     aClass:TGraphicClass;
     NewGraphic:TGraphic;
Begin
     Ext := ExtractFileExt(FileName);
     UpcaseStr(Ext);
     aClass:=Nil;
     If ((Ext=EXT_UC_BITMAP) or (Ext=EXT_UC_PCX) or (Ext=EXT_UC_GIF))
       Then aClass:=TBitmap
     Else If Ext=EXT_UC_ICON
       Then aClass:=TIcon
     Else If Ext=EXT_UC_MET
       Then aClass:=TMetaFile;
     If aClass=Nil
       Then Raise EInvalidPictureFormat.Create('Unknown extension');

     NewGraphic := aClass.Create;
     NewGraphic.LoadFromFile(FileName);

     If FGraphic <> Nil Then FGraphic.Destroy;
     FGraphic := NewGraphic;
     FGraphic.OnChange := Changed;
     Changed(Self);
End;


Procedure TPicture.SaveToFile(Const Filename:String);
Begin
     If FGraphic<>Nil Then FGraphic.SaveToFile(FileName);
End;


Procedure TPicture.ForceType(GraphicType:TGraphicClass);
Begin
     If not (FGraphic Is GraphicType) Then
     Begin
          If FGraphic <> Nil Then FGraphic.Destroy;
          FGraphic := GraphicType.Create;
          FGraphic.OnChange := Changed;
          Changed(Self);
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TFont Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

// Charsets                     
Const ANSI_CHARSET = 0;
      DEFAULT_CHARSET = 1;
      //die anderen dazwischen braucht denke ich kaum einer, die Werte stehen in der Win32 API Help
      OEM_CHARSET = 255;

{$IFDEF Win32 }
{$HINTS OFF}
Function EnumFontCallBackW32(Var lplf:LOGFONT;Var lptm:TEXTMETRIC;
                             nFontType:LongInt;Data:Pointer):LongInt;APIENTRY;
Var Font,Temp:TFont;

Begin
  Font.Create(Screen);
  Font.FFontInfo:=lplf;
  Font.FFontType:=ftBitmap;
  If (nFontType And 4)=4
    Then Font.FFontType:=ftOutline;
  Screen.FontList.Add(Font);

  If Font.FaceName='Times New Roman' Then
    Begin
      Temp:=Screen.CreateCompatibleFont(Font);
      Temp.FCustom:=False;
      FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
      Temp.FFontInfo.lfFaceName:='Times New Roman';
      Temp.FFontInfo.lfHeight:=16;
      Temp.FFontInfo.lfWidth:=6;
      Screen.FontList.Add(Temp);
    End;

  If Font.FaceName='Arial' Then
    Begin
      Temp:=Screen.CreateCompatibleFont(Font);
      Temp.FCustom:=False;
      FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
      Temp.FFontInfo.lfFaceName:='Arial';
      Temp.FFontInfo.lfHeight:=14;
      Temp.FFontInfo.lfWidth:=5;
      Screen.FontList.Add(Temp);

      Temp:=Screen.CreateCompatibleFont(Font);
      Temp.FCustom:=False;
      FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
      Temp.FFontInfo.lfFaceName:='Arial';
      Temp.FFontInfo.lfHeight:=16;
      Temp.FFontInfo.lfWidth:=6;
      Screen.FontList.Add(Temp);
    End;

  If Font.FaceName='MS Sans Serif' Then
    Begin
      Temp:=Screen.CreateCompatibleFont(Font);
      Temp.FCustom:=False;
      FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
      Temp.FFontInfo.lfFaceName:='MS Sans Serif';
      Temp.FFontInfo.lfHeight:=15;
      Temp.FFontInfo.lfWidth:=5;
      Temp.FInternalPointSize:=8;
      Screen.FontList.Add(Temp);

      Temp:=Screen.CreateCompatibleFont(Font);
      Temp.FCustom:=False;
      FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
      Temp.FFontInfo.lfFaceName:='MS Sans Serif';
      Temp.FFontInfo.lfHeight:=16;
      Temp.FFontInfo.lfWidth:=7;
      Temp.FInternalPointSize:=10;
      Screen.FontList.Add(Temp);
    End;
  Result:=1;
End;
{$HINTS ON}
{$ENDIF}

Constructor TFont.Create(AOwner:TComponent);
Begin
     If AOwner<>Screen Then AOwner:=Screen; //!!
     Inherited Create(AOwner);
     fOS2codepage := 0; {Martin0206}
End;

Destructor TFont.Destroy;
Begin
     Inherited Destroy;

     If FAlternateName<>Nil Then DisposeStr(FAlternateName);
     FAlternateName:=Nil;
End;

Procedure TFont.SetHeight(NewHeight:LongInt);
Begin
     {If Font Is changed FInternalPointSize Is no longer Valid}
     FInternalPointSize:=0;
     {$IFDEF OS2}
     FFontInfo.lMaxbaseLineExt:=NewHeight;
     {$ENDIF}
     {$IFDEF Win32}
     FFontInfo.lfHeight:=NewHeight;
     {$ENDIF}
End;

Procedure TFont.SetWidth(NewWidth:LongInt);
Begin
     {If Font Is changed FInternalPointSize Is no longer Valid}
     FInternalPointSize:=0;
     {$IFDEF OS2}
     FFontInfo.LMaxCharInc:=NewWidth;
     {$ENDIF}
     {$IFDEF Win32}
     FFontInfo.lfWidth:=NewWidth;
     {$ENDIF}
End;

Procedure TFont.SetAttributes(NewAttr:TFontAttributes);
Begin
     {$IFDEF OS2}
     FFontInfo.fsSelection:=FFontInfo.fsSelection And Not
                  (FM_SEL_BOLD Or FM_SEL_ITALIC Or FM_SEL_UNDERSCORE Or
                   FM_SEL_STRIKEOUT Or FM_SEL_OUTLINE);
     If NewAttr*[faBold]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_BOLD;
     If NewAttr*[faItalic]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_ITALIC;
     If NewAttr*[faUnderScore]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_UNDERSCORE;
     If NewAttr*[faStrikeOut]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_STRIKEOUT;
     If NewAttr*[faOutline]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_OUTLINE;
     {$ENDIF}
     {$IFDEF Win32}
     If NewAttr*[faBold]<>[] Then FFontInfo.lfWeight:=FW_BOLD
     Else If FFontInfo.lfWeight=FW_BOLD Then FFontInfo.lfWeight:=0;
     If NewAttr*[faItalic]<>[] Then FFontInfo.lfItalic:=1
     Else FFontInfo.lfItalic:=0;
     If NewAttr*[faUnderScore]<>[] Then FFontInfo.lfUnderline:=1
     Else FFontInfo.lfUnderline:=0;
     If NewAttr*[faStrikeOut]<>[] Then FFontInfo.lfStrikeOut:=1
     Else FFontInfo.lfStrikeOut:=0;
     {$ENDIF}
End;

Function TFont.GetAttributes:TFontAttributes;
Begin
     Result:=[];
     {$IFDEF OS2}
     If FFontInfo.fsSelection And longword(FM_SEL_BOLD)<>0 Then Include(Result,faBold);
     If FFontInfo.fsSelection And longword(FM_SEL_ITALIC)<>0 Then Include(Result,faItalic);
     If FFontInfo.fsSelection And longword(FM_SEL_UNDERSCORE)<>0 Then Include(Result,faUnderSCore);
     If FFontInfo.fsSelection And longword(FM_SEL_STRIKEOUT)<>0 Then Include(Result,faStrikeOUt);
     If FFontInfo.fsSelection And longword(FM_SEL_OUTLINE)<>0 Then Include(Result,faOutline);
     {$ENDIF}
     {$IFDEF Win32}
     If FFontInfo.lfWeight=FW_BOLD Then Include(Result,faBold);
     If FFontInfo.lfItalic<>0 Then Include(Result,faItalic);
     If FFontInfo.lfUnderline<>0 Then Include(Result,faUnderScore);
     If FFontInfo.lfStrikeOut<>0 Then Include(Result,faStrikeOut);
     {$ENDIF}
End;

Function TFont.GetMinimumPointSize:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.sMinimumPointSize Div 10;
     {$ENDIF}
     {$IFDEF Win32}
     {.?.}
     Result:=PointSize;
     {$ENDIF}
End;

Function TFont.GetMaximumPointSize:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.sMaximumPointSize Div 10;
     {$ENDIF}
     {$IFDEF Win32}
     {.?.}
     Result:=PointSize;
     {$ENDIF}
End;

Function TFont.GetNominalPointSize:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.sNominalPointSize Div 10;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=PointSize;
     {$ENDIF}
End;

Function TFont.GetInternalLeading:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.lInternalLeading;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=0;
     {$ENDIF}
End;

Function TFont.GetHeight:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.lMaxbaseLineExt;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=FFontInfo.lfHeight;
     {$ENDIF}

End;

Function TFont.GetWidth:LongInt;
Begin
     {$IFDEF OS2}
//     Result:=FFontInfo.LMaxCharInc;
     Result:=FFontInfo.LAveCharWidth;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=FFontInfo.lfWidth;
     {$ENDIF}
End;

Function TFont.GetPitch:TFontPitch;
Begin
     {$IFDEF OS2}
     If boolean(FFontInfo.fsType And longword(FM_TYPE_FIXED<>0)) Then Result:=fpFixed {Martin}
     Else Result:=fpProportional;
     {$ENDIF}
     {$IFDEF Win32}
     If FFontInfo.lfPitchAndFamily And 3=FIXED_PITCH Then Result:=fpFixed
     Else Result:=fpProportional;
     {$ENDIF}
End;

Function TFont.GetCharSet:TFontCharSet;
Begin
     {$IFDEF OS2}
     If boolean(FFontInfo.fsType And longword(FM_TYPE_MBCS <> 0)) Then Result := fcsMBCS {Martin}
     Else If boolean(FFontInfo.fsType And longword(FM_TYPE_DBCS <> 0)) Then Result := fcsDBCS
          Else Result := fcsSBCS;
     {$ENDIF}
     {$IFDEF Win32}
     Result := fcsSBCS;
     {$ENDIF}
End;

Function TFont.GetName:String;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.szFaceName;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=FFontInfo.lfFaceName;
     {$ENDIF}
End;

Function TFont.GetFamily:String;
{$IFDEF Win32}
Var Family:Byte;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.szFamilyName;
     {$ENDIF}
     {$IFDEF Win32}
     If FFontType=ftBitmap Then Result:='Bitmap'
     Else Result:='TrueType';
     Family:=FFontInfo.lfPitchAndFamily And 240;
     If Family=FF_ROMAN Then Result:='Roman';
     If Family=FF_SWISS Then Result:='Swiss';
     If Family=FF_MODERN Then Result:='Modern';
     If Family=FF_SCRIPT Then Result:='Script';
     If Family=FF_DECORATIVE Then Result:='Decorative';
     {$ENDIF}
End;

Function tFont.GetWinCodepage : byte;{Martin0206}
  begin
    {$ifdef OS2}
      result := OEM_Charset;
    {$else}
      result := FFontInfo.lfCharSet;
    {$endif}
  end;

Type
    PFontRes=^TFontRes;
    TFontRes=Array[0..512] Of Char;


Function TFont.WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceName):BOolean;
Var  Data:PFontRes;
     T:Byte;
     S,s1:String;
     Attrs:TFontAttributes;
     t1:LongInt;
Begin
     If FAlternateName=Nil Then
       If ((Self=Screen.DefaultFont)Or(FDefault)) Then {dont Write it}
       Begin
            Result := True;
            Exit;
       End;

     S:=FaceName;
     If FDefault Then S:='System Default Font';

     s1:=S;
     UpcaseStr(s1);
     Attrs:=Attributes;
     If Attrs*[faBold]<>[] Then If Pos(' BOLD',s1)=0 Then S:=S+'!BOLD!';
     If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',s1)=0 Then S:=S+'!ITALIC!';
     If Attrs*[faOutline]<>[] Then S:=S+'!OUTLINE!';
     If Attrs*[faStrikeOut]<>[] Then S:=S+'!STRIKEOUT!';
     If Attrs*[faUnderScore]<>[] Then S:=S+'!UNDERSCORE!';

     GetMem(Data,512);
     For T := 0 To Length(S) Do Data^[T] := S[T];

     T := Length(S)+1;

     If FAlternateName<>Nil Then
     Begin
          //AlternateName starts with #2
          For t1:=1 To length(FAlternateName^) Do
            Data^[(t+t1)-1]:=FAlternateName^[t1];
          inc(t,length(FAlternateName^));
     End;

     If FInternalPointSize <> 0 Then
     Begin
          Data^[T] := #1;
          Data^[T+1] := Chr(FInternalPointSize);
          Data^[T+2] := #0;
     End
     Else
     Begin
          Data^[T] := #0;
          Data^[T+1] := Chr(Width);
          Data^[T+2] := Chr(Height);
     End;

     inc(t,3);
     Result := Stream.NewResourceEntry(ResName,Data^,t);
     FreeMem(Data,512);
End;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;
Begin
  Result:=FontName;
  UpcaseStr(FontName);
  If Attrs*[faItalic]<>[]     Then If Pos(' ITALIC',FontName)=0 Then Result:=Result+'.Italic';
  If Attrs*[faBold]<>[]       Then If Pos(' BOLD',FontName)=0 Then Result:=Result+'.Bold';
  If Attrs*[faOutline]<>[]    Then Result:=Result+'.Outline';
  If Attrs*[faStrikeOut]<>[]  Then Result:=Result+'.Strikeout';
  If Attrs*[faUnderScore]<>[] Then Result:=Result+'.Underscore';
End;

{$HINTS OFF}
Function ReadSCUFont(Var Data;DataLen:LongInt):TFont;
Var  Data1:PFontRes;
     T,T1:Byte;
     PointSize,W,H:Byte;
     Face,FaceName:String;
     Attrs,AlternateAttrs:TFontAttributes;
     AlternateFace,AlternateFaceName:String;
     AlternatePointSize:Byte;
     AlternateW,AlternateH:Byte;
Label go;

var Win95_98_ME : boolean;

  {Martin0806}
  function OS2toWinFont (os2name : string; os2point : integer; winname : string; winpoint : integer; Bold : boolean) : boolean;
    var
      Name : string; {without BOLD ITALIC text attributes}
      Att : tFontAttributes;
      posi : byte;
    begin
      result := false;
      Name := Facename;
      Att := [];
      posi := pos (' Bold', Name);
      if posi > 0 then begin
        Att := Att+[faBold];
        delete (Name, posi, 5);
      end;
      posi := pos (' Italic', Name);
      if posi > 0 then begin
        Att := Att+[faItalic];
        delete (Name, posi, 7);
      end;

      if (Name = os2name) and ((Pointsize = os2point) or (os2point = 0)) then begin
        AlternateFaceName := winname;
        if Win95_98_ME then winpoint := winpoint - 2;
        if os2point = 0 then
          AlternatePointsize := Pointsize + winpoint{delta value}
        else
          AlternatePointSize := winpoint;
        if Bold then Att:=Att+[faBold];
        AlternateAttrs := Att;
        result := true;
      end;
    end;

  function ConvertOS2toWinFont : boolean;
    begin
      {$ifdef os2}
      result := false;
      {$endif}
      {$ifdef win32}
      Win95_98_ME := Winbase.GetVersion >= $80000000{Windows95};
      if Win95_98_ME then result := false
      else result :=
         OS2toWinFont ('Helv', 6, {-->} 'MS Sans Serif', 8, false)
      or OS2toWinFont ('Helv', 7, {-->} 'MS Sans Serif', 9, false)
      or OS2toWinFont ('Helv', 8, {-->} 'MS Sans Serif', 10, false)
      or OS2toWinFont ('Helv', 9, {-->} 'MS Sans Serif', 11, false)
      or OS2toWinFont ('Helv', 0, {-->} 'MS Sans Serif', +2, true)
      or OS2toWinFont ('Helvetica', 0, {-->} 'Arial', +2, true)
      or OS2toWinFont ('System Proportional', 0, {-->} 'MS Sans Serif', +2, true)
      or OS2toWinFont ('System Monospaced', 0, {-->} 'Lucida Console', 0, true)
      or OS2toWinFont ('Courier', 0, {-->} 'Courier New', +2, false)
      or OS2toWinFont ('Courier New', 0, {-->} 'Courier New', +2, false)
      or OS2toWinFont ('System VIO', 8, {-->} 'Lucida Console', 7, false)
      or OS2toWinFont ('System VIO', 9, {-->} 'Lucida Console', 8, false)
      or OS2toWinFont ('System VIO', 10, {-->} 'Lucida Console', 9, false)
      or OS2toWinFont ('System VIO', 0, {-->} 'Lucida Console', -2, true)
      or OS2toWinFont ('WarpSans', 0, {-->} 'MS Sans Serif', +1, false)
      or OS2toWinFont ('Tms Rmn', 10, {-->} 'Times New Roman', 12, true)
      or OS2toWinFont ('Tms Rmn', 0, {-->} 'Times New Roman', +2, false)
      or OS2toWinFont ('Times New Roman', 0, {-->} 'Times New Roman', +2, false)
      or OS2toWinFont ('Monotype Sans WT', 0, {-->} 'Arial', +2, false)
      ;
      {$endif}
    end;

Begin
     AlternateFaceName:='';
     AlternateFace:='';
     AlternatePointSize:=0;
     AlternateW:=0;
     AlternateH:=0;
     PointSize:=0;
     W:=0;
     H:=0;

     Data1 := @Data;
     For T := 0 To Ord(Data1^[0]) Do FaceName[T] := Data1^[T];
     Face:=FaceName;

     Attrs:=[];
     T:=Pos('!',FaceName);
     If T<>0 Then
     Begin
          If Pos('!BOLD!',FaceName)<>0 Then Attrs:=Attrs+[faBold];
          If Pos('!ITALIC!',FaceName)<>0 Then Attrs:=Attrs+[faItalic];
          If Pos('!OUTLINE!',FaceName)<>0 Then Attrs:=Attrs+[faOutline];
          If Pos('!STRIKEOUT!',FaceName)<>0 Then Attrs:=Attrs+[faStrikeOut];
          If Pos('!UNDERSCORE!',FaceName)<>0 Then Attrs:=Attrs+[faUnderScore];
          If Attrs<>[] Then FaceName[0]:=Chr(T-1);
     End;

     If FaceName='System Default Font' Then
     Begin
          Result:=Screen.DefaultFont;
          //ignore alternate facename here, the user wants default fonts !
     End
     Else
     Begin
          T := Ord(Data1^[0])+1;
go:
          If Data1^[T] = #1 Then
          Begin
               PointSize := Ord(Data1^[T+1]);
               if not ConvertOS2toWinFont then {Martin0806} begin
                 FaceName:=ModifyFontName(FaceName,Attrs);
                 Result := Screen.GetFontFromPointSize(FaceName,PointSize);
               end
               else begin
                 AlternateFaceName:=ModifyFontName(AlternateFaceName,AlternateAttrs);
                 Result := Screen.GetFontFromPointSize(AlternateFaceName,AlternatePointSize);
               end;
          End
          Else If Data1^[t] = #2 Then //Alternate Facename follows, new SCU
          Begin
               inc(t);
               For t1:=t To t+Ord(Data1^[t]) Do AlternateFaceName[t1-t]:=Data1^[t1];
               inc(t,ord(Data1^[t])+1);
               AlternateFace:=AlternateFaceName;

               AlternateAttrs:=[];
               T1:=Pos('!',AlternateFaceName);
               If T1<>0 Then
               Begin
                  If Pos('!BOLD!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faBold];
                  If Pos('!ITALIC!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faItalic];
                  If Pos('!OUTLINE!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faOutline];
                  If Pos('!STRIKEOUT!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faStrikeOut];
                  If Pos('!UNDERSCORE!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faUnderScore];
                  If AlternateAttrs<>[] Then AlternateFaceName[0]:=Chr(T1-1);
               End;

               If Data1^[T] = #1 Then
               Begin
                    AlternatePointSize := Ord(Data1^[T+1]);
                    AlternateFaceName:=ModifyFontName(AlternateFaceName,AlternateAttrs);
                    inc(t,3); //skip also dummy #0
                    goto go;
               End
               Else
               Begin
                   AlternateW := Ord(Data1^[T+1]);
                   AlternateH := Ord(Data1^[T+2]);
                   AlternateFaceName:=ModifyFontName(AlternateFaceName,AlternateAttrs);
                   inc(t,3);
                   goto go;
               End;
          End
          Else //old style SCU format
          Begin
               W := Ord(Data1^[T+1]);
               H := Ord(Data1^[T+2]);
               FaceName:=ModifyFontName(FaceName,Attrs);
               Result := Screen.GetFontFromName(FaceName,H,W);
          End;

          If Result=Nil Then //Font could not be created,maybe its OS/2 or Win Font
          Begin
               //Try alternate facename if present
               If AlternateFaceName<>'' Then
               Begin
                    Attrs:=AlternateAttrs;

                    If AlternateFace='System Default Font' Then Result:=Screen.DefaultFont
                    Else
                    Begin
                       If AlternatePointSize<>0 Then
                         Result := Screen.GetFontFromPointSize(AlternateFaceName,AlternatePointSize)
                       Else
                         Result := Screen.GetFontFromName(AlternateFaceName,AlternateH,AlternateW);
                    End;
               End;

               //if neither normal nor alternate font work, set a default
               If Result=Nil Then Result:=Screen.SmallFont;

               //set alternate facename (the one that did not work)
               If Face<>'' Then
               Begin
                   FaceName:=#2+Face[0]+Face;
                   If PointSize<>0 Then
                       FaceName:=FaceName+#1+chr(PointSize)+#0
                   Else
                       FaceName:=FaceName+#0+chr(W)+chr(H);
               End
               Else FaceName:='';

               If FaceName<>'' Then
                If Result<>Nil Then AssignStr(Result.FAlternateName,FaceName);
          End
          Else
          Begin
               //Font is ok, set alternate facename if present
               If AlternateFace<>'' Then
               Begin
                   AlternateFaceName:=#2+AlternateFace[0]+AlternateFace;
                   If AlternatePointSize<>0 Then
                      AlternateFaceName:=AlternateFaceName+#1+chr(AlternatePointSize)+#0
                   Else
                      AlternateFaceName:=AlternateFaceName+#0+chr(AlternateW)+chr(AlternateH);
               End
               Else AlternateFaceName:='';

               If AlternateFaceName<>'' Then
                 If Result<>Nil Then AssignStr(Result.FAlternateName,AlternateFaceName);
          End;

          If Result<>Nil Then If Result.Attributes*Attrs<>Attrs Then
          Begin
               Result:=Screen.CreateCompatibleFont(Result);
               Result.Attributes:=Attrs;
               Result.AutoDestroy:=True;
          End;
     End;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TGraphic Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TGraphic.Create;
Begin
     Inherited Create(Nil);
End;

{Martin}
Function TGraphic.GetHeight:LongInt;
Begin
     GetHeight:=FHeight;
End;

Procedure TGraphic.SetHeight(Value:LongInt);
Begin
     FHeight:=Value;
End;

Function TGraphic.GetWidth:LongInt;
Begin
     GetWidth:=FWidth;
End;

Procedure TGraphic.SetWidth(Value:LongInt);
Begin
     FWidth:=Value;
End;

Procedure TGraphic.LoadFromFile(Const FileName:String);

Var FileStream:TStream;

Begin
  FileStream:=TFileStream.Create(FileName, Stream_OpenRead);
  Try
    LoadFromStream(FileStream);
  Finally
    FileStream.Destroy;
  End;
End;

Procedure TGraphic.SaveToFile(Const FileName:String);
Var
   FileStream:TStream;
Begin
     FileStream:=TFileStream.Create(FileName,Stream_Create);
     Try
         SaveToStream(FileStream);
     Finally
         FileStream.Destroy;
     End;
End;

Procedure TGraphic.changed;
Begin
     If FOnChangedNotify<>Nil Then FOnChangedNotify(Self);
     If FOnChange<>Nil Then FOnChange(Self);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPalette Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF WIN32}
Type PPaletteEntryArray=^TPaletteEntryArray;
     TPaletteEntryArray=Array[0..1] Of PALETTEENTRY;
{$ENDIF}
{$IFDEF OS2}
Type PPaletteEntryArray=^TPaletteEntryArray;
     TPaletteEntryArray=Array[0..1] Of RGB2;
{$ENDIF}

Procedure TPalette.SetupComponent;
Begin
     Inherited SetupComponent;

     If Owner Is TCanvas Then FCanvas:=TCanvas(Owner);
End;

Function TPalette.GetHandle:LongWord;
{$IFDEF WIN32}
Var lp:LOGPALETTE;
    Temp:LongWord;
{$ENDIF}
Begin
     If FHandle<>0 Then Result:=FHandle
     Else If FCanvas<>Nil Then
     Begin
          FCanvas:=TCanvas(Owner);

          {$IFDEF OS2}
          Result:=GpiQueryPalette(FCanvas.Handle);
          {$ENDIF}
          {$IFDEF WIN32}
          lp.palVersion:=$300;
          lp.palNumEntries:=1;
          Temp:=CreatePalette(lp);
          Result:=SelectPalette(FCanvas.Handle,Temp,False);
          SelectPalette(FCanvas.Handle,Result,False);
          DeleteObject(Temp);
          {$ENDIF}

          FHandle:=Result;
     End
End;

Procedure TPalette.CreateNew(Var Colors:Array Of TColor);
Var
    {$IFDEF OS2}
    Entries:PPaletteEntryArray;
    {$ENDIF}
    {$IFDEF WIN32}
    Entries:^LOGPALETTE;
    {$ENDIF}
    Count:LongWord;
    t:LongInt;
Begin
     Count:=High(Colors)+1;
     {$IFDEF OS2}
     GetMem(Entries,Count*sizeof(RGB2));
     For t:=0 To Count-1 Do
     Begin
          Entries^[t].bRed:=TRGB(Colors[t]).Red;
          Entries^[t].bGreen:=TRGB(Colors[t]).Green;
          Entries^[t].bBlue:=TRGB(Colors[t]).Blue;
          Entries^[t].fcOptions:=0;
     End;
     FHandle:=GpiCreatePalette(AppHandle,
                               0{LCOL_OVERRIDE_DEFAULT_COLORS},
                               LCOLF_CONSECRGB,
                               Count,
                               Entries^);
     FreeMem(Entries,Count*sizeof(RGB2));
     {$ENDIF}
     {$IFDEF WIN32}
     GetMem(Entries,sizeof(LOGPALETTE)+Count*sizeof(PALETTEENTRY));
     Entries^.palVersion:=$300;
     Entries^.palNumEntries:=Count;
     For t:=0 To Count-1 Do
     Begin
          Entries^.palPalEntry[t].peRed:=TRGB(Colors[t]).Red;
          Entries^.palPalEntry[t].peGreen:=TRGB(Colors[t]).Green;
          Entries^.palPalEntry[t].peBlue:=TRGB(Colors[t]).Blue;
          Entries^.palPalEntry[t].peFlags:=0;
     End;
     FHandle:=CreatePalette(Entries^);
     GetMem(Entries,sizeof(LOGPALETTE)+Count*sizeof(PALETTEENTRY));
     {$ENDIF}
End;

Procedure TPalette.RealizePalette;
Begin
     If FCanvas=Nil Then exit;

     {$IFDEF OS2}
     GpiSelectPalette(FCanvas.Handle,Handle);
     {$ENDIF}
     {$IFDEF WIN32}
     SelectPalette(FCanvas.Handle,Handle,False);
     WinGDI.RealizePalette(FCanvas.Handle);
     {$ENDIF}
End;

Function TPalette.GetColor(Index:LongWord):TColor;
Var CArray:Array[1..1] Of TColor;
Begin
     GetColorArray(Index,CArray);
     Result:=CArray[1];
End;

Procedure TPalette.SetColor(Index:LongWord;NewColor:TColor);
Var CArray:Array[1..1] Of TColor;
Begin
     CArray[1]:=NewColor;
     SetColorArray(Index,CArray);
End;

Function TPalette.GetColorArray(StartIndex:LongWord;Var ResultArray:Array Of TColor):Longword;
Var Count:LongWord;
    {$IFDEF WIN32}
    Entries:PPaletteEntryArray;
    t:LongInt;
    {$ENDIF}
Begin
     Count:=High(ResultArray)+1;
     {$IFDEF OS2}
     Result:=GpiQueryPaletteInfo(Handle,Canvas.Handle,0,StartIndex,Count,ResultArray);
     {$ENDIF}
     {$IFDEF Win32}
     GetMem(Entries,Count*sizeof(PALETTEENTRY));
     Result:=GetPaletteEntries(Handle,StartIndex,Count,Entries^[0]);
     If Result<>0 Then
     Begin
          For t:=0 To Count-1 Do
            ResultArray[t]:=ValuesToRGB(Entries^[t].peRed,Entries^[t].peGreen,Entries^[t].peBlue);
     End;
     FreeMem(Entries,Count*sizeof(PALETTEENTRY));
     {$ENDIF}
End;

Procedure TPalette.SetColorArray(StartIndex:LongWord;Const SourceArray:Array Of TColor);
Var
   Count:LongInt;
   {$IFDEF WIN32}
   Entries:PPaletteEntryArray;
   t:LongInt;
   {$ENDIF}
Begin
     Count:=High(SourceArray)+1;
     {$IFDEF OS2}
     GpiSetPaletteEntries(Handle,LCOLF_CONSECRGB,StartIndex,Count,SourceARray);
     {$ENDIF}
     {$IFDEF Win32}
     GetMem(Entries,Count*sizeof(PALETTEENTRY));
     For t:=0 To Count-1 Do
     Begin
          Entries^[t].peRed:=TRGB(SourceArray[t]).Red;
          Entries^[t].peGreen:=TRGB(SourceArray[t]).Green;
          Entries^[t].peBlue:=TRGB(SourceArray[t]).Blue;
          Entries^[t].peFlags:=0;
     End;
     SetPaletteEntries(Handle,StartIndex,Count,Entries^[0]);
     FreeMem(Entries,Count*sizeof(PALETTEENTRY));
     {$ENDIF}
End;

Function TPalette.GetColorCount:LongWord;
Begin
     {$IFDEF OS2}
     Result:=GpiQueryPaletteInfo(Handle,Canvas.Handle,0,0,0,Nil);
     {$ENDIF}
     {$IFDEF Win32}
     Result:=0;
     GetObject(Handle,4,Result);
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPen Class Implementation                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPen.SetupComponent;
Begin
     Inherited SetupComponent;

     If Owner Is TCanvas Then
       If not (csWriting IN ComponentState) Then FCanvas:=TCanvas(Owner);
     Include(DesignerState, dsStored);
     Width:=1;
     color:=clBlack;
     Mode:=pmCopy;
     Style:=psSolid;
End;

Procedure TPen.Assign(Source:TPersistent);
Begin
     If not (Source Is TPen) Then Inherited Assign(Source)
     Else
     Begin
          Color:=TPen(Source).Color;
          Mode:=TPen(Source).Mode;
          Style:=TPen(Source).Style;
          Width:=TPen(Source).Width;
     End;
End;

{$IFDEF WIN32}
Procedure CreateWin32Pen(Canvas:TCanvas);
Begin
     If Canvas.FPenHandle<>0 Then exit;
     Canvas.FPenHandle:=GetStockObject(BLACK_PEN); //CreatePen(PS_SOLID,0,0);
     If Canvas.FHandle<>0 Then SelectObject(Canvas.FHandle,Canvas.FPenHandle);
End;

Procedure CreateWin32Brush(Canvas:TCanvas);
Begin
     If Canvas.FBrushHandle<>0 Then exit;
     Canvas.FBrushHandle:=GetStockObject(WHITE_BRUSH); //CreateSolidBrush(0);
     If Canvas.FHandle<>0 Then SelectObject(Canvas.FHandle,Canvas.FBrushHandle);
End;
{$ENDIF}

Procedure TPen.SetColor(NewColor:TColor);
{$IFDEF Win32}
Var lp:LOGPEN;
    lb:LOGBRUSH;
    NewPen:LongWord;
    NewBrush:LongWord;
{$ENDIF}
Begin
     FColor := NewColor;   {Store original Value, Not the Modified one}

     If FCanvas <> Nil Then
     Begin
          {$IFDEF WIN32}
          If not (FCanvas.FOwnerDraw) Then exit; //not ownerdraw
          {$ENDIF}

          NewColor := SysColorToRGB(NewColor);
          {$IFDEF OS2}
          GpiSetColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
          {$IFDEF Win32}
          NewColor := RGBToWinColor(NewColor);

          CreateWin32Pen(FCanvas);
          GetObject(FCanvas.FPenHandle,SizeOf(LOGPEN),lp);
          lp.lopnColor:=NewColor;
          NewPen:=CreatePenIndirect(lp);
          If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewPen);
          If FCanvas.FPenHandle<>0 Then DeleteObject(FCanvas.FPenHandle);
          FCanvas.FPenHandle:=NewPen;

          CreateWin32Brush(FCanvas);
          GetObject(FCanvas.FBrushHandle,SizeOf(LOGBRUSH),lb);
          lb.lbColor:=NewColor;
          NewBrush:=CreateBrushIndirect(lb);
          If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewBrush);
          If FCanvas.FBrushHandle<>0 Then DeleteObject(FCanvas.FBrushHandle);
          FCanvas.FBrushHandle:=NewBrush;
          WinGDI.SetTextColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
     End;
End;


Procedure TPen.SetMode(NewMode:TPenMode);
{$IFDEF OS2}
Const FgModes:Array[pmBlack..pmNotXor] Of LongWord=
                (FM_ZERO,FM_ONE,FM_LEAVEALONE,FM_INVERT,
                 FM_OVERPAINT,FM_NOTCOPYSRC,FM_MERGESRCNOT,FM_MASKSRCNOT,FM_MERGENOTSRC,
                 FM_SUBTRACT,FM_OR,FM_NOTMERGESRC,FM_AND,FM_NOTMASKSRC,
                 FM_XOR,FM_NOTXORSRC);
{$ENDIF}
{$IFDEF Win32}
Const FgModes:Array[pmBlack..pmNotXor] Of LongWord=
                (R2_BLACK,R2_WHITE,R2_NOP,R2_NOT,
                 R2_COPYPEN,R2_NOTCOPYPEN,R2_MERGEPENNOT,R2_MASKPENNOT,R2_MERGENOTPEN,
                 R2_MASKNOTPEN,R2_MERGEPEN,R2_NOTMERGEPEN,R2_MASKPEN,R2_NOTMASKPEN,
                 R2_XORPEN,R2_NOTXORPEN);
{$ENDIF}
Var NewMode1:LongWord;
Begin
     FMode:=NewMode;
     If FCanvas = Nil Then Exit;
     FCanvas.FForeMix:=NewMode;
     NewMode1:=FgModes[NewMode];
     If FCanvas.FHandle=0 Then exit;
     {$IFDEF Win32}
     SetROP2(FCanvas.FHandle,NewMode1);
     {$ENDIF}
     {$IFDEF OS2}
     GpiSetMix(FCanvas.FHandle,NewMode1);
     {$ENDIF}
End;


Procedure TPen.SetStyle(NewStyle:TPenStyle);
{$IFDEF Win32}
Const LineStyles:Array[psSolid..psAlternate] Of LongWord=
                   (PS_SOLID,PS_DASH,PS_DOT,PS_DASHDOT,PS_DASHDOTDOT,
                    PS_NULL,PS_ALTERNATE);
{$ENDIF}
{$IFDEF OS2}
Const LineStyles:Array[psSolid..psAlternate] Of LongWord=
                   (LINETYPE_SOLID,LINETYPE_LONGDASH,LINETYPE_DOT,
                    LINETYPE_DASHDOT,LINETYPE_DASHDOUBLEDOT,
                    LINETYPE_INVISIBLE,LINETYPE_ALTERNATE);
{$ENDIF}
{$IFDEF Win32}
Var PenData:LOGPEN;
    NewPen:LongWord;
{$ENDIF}
Var NewStyle1:LongWord;
Begin
     FStyle:=NewStyle;
     If FCanvas = Nil Then Exit;

     {$IFDEF WIN32}
     If not (FCanvas.FOwnerDraw) Then exit; //not ownerdraw
     {$ENDIF}

     FCanvas.FLineType:=NewStyle;
     NewStyle1:=LineStyles[NewStyle];
     
     {$IFDEF Win32}
     CreateWin32Pen(FCanvas);
     GetObject(FCanvas.FPenHandle,SizeOf(LOGPEN),PenData);
     PenData.lopnStyle:=NewStyle1;
     NewPen:=CreatePenIndirect(PenData);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewPen);
     If FCanvas.FPenHandle<>0 Then DeleteObject(FCanvas.FPenHandle);
     FCanvas.FPenHandle:=NewPen;
     {$ENDIF}
     {$IFDEF OS2}
     GpiSetLineType(FCanvas.FHandle,NewStyle1);
     {$ENDIF}
End;


Procedure TPen.SetWidth(NewWidth:LongInt);
{$IFDEF Win32}
Var PenData:LOGPEN;
    NewPen:LongWord;
{$ENDIF}
Begin
     FWidth:=NewWidth;
     If FCanvas = Nil Then Exit;

     {$IFDEF WIN32}
     If not (FCanvas.FOwnerDraw) Then exit; //not ownerdraw
     {$ENDIF}

     FCanvas.FLineWidth:=NewWidth;
     
     {$IFDEF Win32}
     CreateWin32Pen(FCanvas);
     GetObject(FCanvas.FPenHandle,SizeOf(LOGPEN),PenData);
     PenData.lopnWidth:=Point(NewWidth,0);
     NewPen:=CreatePenIndirect(PenData);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewPen);
     If FCanvas.FPenHandle<>0 Then DeleteObject(FCanvas.FPenHandle);
     FCanvas.FPenHandle:=NewPen;
     {$ENDIF}
     {$IFDEF OS2}
     If NewWidth>2 Then
     Begin
          GpiSetLineWidthGeom(FCanvas.FHandle,NewWidth);
          GpiSetLineWidth(FCanvas.FHandle,MAKEFIXED(1,0));
          FCanvas.FUsePath:=True;
     End
     Else
     Begin
          GpiSetLineWidth(FCanvas.FHandle,MAKEFIXED(NewWidth,0));
          FCanvas.FUsePath:=False;
     End;
     {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TBrush Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBrush.SetupComponent;
Begin
     Inherited SetupComponent;

     If Owner Is TCanvas Then
       If not (csWriting IN ComponentState) Then FCanvas:=TCanvas(Owner);
     Include(DesignerState, dsStored);
     Mode:=bmOpaque;
     Style:=bsSolid;
     color:=clWhite;
End;

Procedure TBrush.Assign(Source:TPersistent);
Begin
     If not (Source Is TBrush) Then Inherited Assign(Source)
     Else
     Begin
          Color:=TBrush(Source).Color;
          Mode:=TBrush(Source).Mode;
          Style:=TBrush(Source).Style;
     End;
End;

Destructor TBrush.Destroy;
Begin
     If FBitmap<>Nil Then
     Begin
          FBitmap.Destroy;
          FBitmap:=Nil;
     End;
     Inherited Destroy;
End;

Procedure TBrush.SetColor(NewColor:TColor);
Begin
     FColor := NewColor; {Store original Value}
     If FCanvas <> Nil Then If FCanvas.FHandle<>0 Then
     Begin
          NewColor := SysColorToRGB(NewColor);
          {$IFDEF OS2}
          GPISetBackColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
          {$IFDEF Win32}
          NewColor := RGBToWinColor(NewColor);
          SetBkColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
     End;
End;

Procedure TBrush.SetStyle(NewStyle:TBrushStyle);
{$IFDEF OS2}
Var  Temp:LongWord;
{$ENDIF}
{$IFDEF Win32}
Var  lb:LOGBRUSH;
     NewBrush:LongWord;
{$ENDIF}
Begin
     If FBitmap<>Nil Then Exit;  //Function illegal If A Bitmap Is Selected As Brush

     FStyle:=NewStyle;
     If FCanvas = Nil Then Exit;
     If FCanvas.FHandle=0 Then Exit;

     If NewStyle=bsClear Then color:=clWhite; {??}

     {$IFDEF OS2}
     Case NewStyle Of
         bsSolid:Temp:=PATSYM_SOLID;
         bsHorizontal:Temp:=PATSYM_HORIZ;
         bsVertical:Temp:=PATSYM_VERT;
         bsFDiagonal:Temp:=PATSYM_DIAG3;
         bsBDiagonal:Temp:=PATSYM_DIAG1;
         bsCross:Temp:=PATSYM_DENSE7;
         bsDiagCross:Temp:=PATSYM_DENSE5;
         bsClear:Temp:=PATSYM_BLANK;
         Else Temp:=PATSYM_SOLID;
     End; {Case}
     GPISetPattern(FCanvas.FHandle,Temp);
     {$ENDIF}
     {$IFDEF Win32}
     If not FCanvas.FOwnerDraw Then exit;

     CreateWin32Brush(FCanvas);
     GetObject(FCanvas.FBrushHandle,SizeOf(LOGBRUSH),lb);

     If NewStyle=bsSolid Then
     Begin
         //WinGDI.SetBkMode(FCanvas.FHandle,OPAQUE);
         lb.lbColor:=RGBToWinColor(SysColorToRGB(color));
     End
     Else
     Begin
          //WinGDI.SetBkMode(FCanvas.FHandle,TRANSPARENT);
          {windows specific: Win32 does Not Draw Brush hatches If bkcolor=Brush color}
          lb.lbColor:=Not RGBToWinColor(SysColorToRGB(color));
     End;

     Case NewStyle Of
         bsSolid:lb.lbStyle:=BS_SOLID;
         bsClear:lb.lbStyle:=BS_HOLLOW;
         bsHorizontal:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_HORIZONTAL;
         End;
         bsVertical:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_VERTICAL;
         End;
         bsFDiagonal:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_FDIAGONAL;
         End;
         bsBDiagonal:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_BDIAGONAL;
         End;
         bsCross:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_CROSS;
         End;
         bsDiagCross:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_DIAGCROSS;
         End;
     End; {Case}
     NewBrush:=CreateBrushIndirect(lb);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewBrush);
     If FCanvas.FBrushHandle<>0 Then DeleteObject(FCanvas.FBrushHandle);
     FCanvas.FBrushHandle:=NewBrush;
     {$ENDIF}
End;


Procedure TBrush.SetMode(NewMode:TBrushMode);
Begin
     FMode:=NewMode;
     If FCanvas = Nil Then Exit;

     FCanvas.FBackMix:=NewMode;
     If FCanvas.FHandle=0 Then Exit;
     {$IFDEF OS2}
     Case NewMode Of
        bmTransparent:GpiSetBackMix(FCanvas.FHandle,BM_LEAVEALONE);
        bmOpaque:GpiSetBackMix(FCanvas.FHandle,BM_OVERPAINT);
     End; {Case}
     {$ENDIF}
     {$IFDEF Win32}
     Case Mode Of
        bmTransparent:WinGDI.SetBkMode(FCanvas.FHandle,TRANSPARENT);
        bmOpaque:WinGDI.SetBkMode(FCanvas.FHandle,OPAQUE);
     End; {Case}
     {$ENDIF}
End;

Procedure TBrush.SetBitmap(NewBitmap:TGraphic);
{$IFDEF Win32}
Var  lb:LOGBRUSH;
     NewBrush:LongWord;
{$ENDIF}
{$IFDEF OS2}
Var  Stream:TMemoryStream;
     BmpClass:Class Of TGraphic;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FBitmap<>Nil Then
     Begin
          GpiSetPatternSet(FCanvas.FHandle,LCID_DEFAULT);
          GpiDeleteSetId(FCanvas.FHandle,2);
          FBitmap.Destroy;
     End;

     If NewBitmap<>Nil Then
     Begin
          BmpClass:=NewBitmap.ClassType;
          FBitmap:=BmpClass.Create;
          Stream.Create;
          NewBitmap.SaveToStream(Stream);
          Stream.Position:=0;
          FBitmap.LoadFromStream(Stream);
          Stream.Destroy;
          GpiSetBitmap(FBitmap.Canvas.Handle,0);
     End
     Else FBitmap:=Nil;
     If FBitmap<>Nil Then
     Begin
          GpiSetBitmapId(FCanvas.FHandle,FBitmap.Handle,2);
          GpiSetPatternSet(FCanvas.FHandle,2);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If FBitmap<>Nil Then FBitmap.Destroy;
     FBitmap:=NewBitmap;
     If not (FCanvas.FOwnerDraw) Then exit;

     CreateWin32Brush(FCanvas);
     GetObject(FCanvas.FBrushHandle,SizeOf(LOGBRUSH),lb);
     If FBitmap<>Nil Then
     Begin
          lb.lbStyle:=BS_PATTERN;
          lb.lbHatch:=FBitmap.Handle;
          {windows specific: Win32 does Not Draw Brush hatches If bkcolor=Brush color}
          lb.lbColor:=Not RGBToWinColor(SysColorToRGB(color));
     End
     Else
     Begin
          lb.lbHatch:=0;
          lb.lbStyle:=BS_SOLID;
     End;
     NewBrush:=CreateBrushIndirect(lb);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewBrush);
     If FCanvas.FBrushHandle<>0 Then DeleteObject(FCanvas.FBrushHandle);
     FCanvas.FBrushHandle:=NewBrush;
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TCanvas Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type TPublicControl=Class(TControl)
        Public
           Property OwnerDraw;
           Property Font;
           Property Color;
           Property FontChangeEnabled;
     End;


Procedure TCanvas.CreateHandle;
Begin
End;

Procedure TCanvas.DestroyHandle;
Begin
End;

{Martin!}
Function tCanvas.GetFontFromPointSize(FaceName:String;PointSize:LongWord):TFont;
  begin
    result := GeneralGetFontFromPointSize (self, FaceName, PointSize);
  end;


{$IFDEF OS2}
Function TCanvas.GetLineColor:TColor;
Begin
     GpiQueryAttrs(Handle,PRIM_LINE,LBB_COLOR,Result);
End;
Function TCanvas.GetCharColor:TColor;
Begin
     GpiQueryAttrs(Handle,PRIM_CHAR,CBB_COLOR,Result);
End;

Function TCanvas.GetAreaColor:TColor;
Begin
     GpiQueryAttrs(Handle,PRIM_AREA,ABB_COLOR,Result);
End;

Procedure TCanvas.SetLineColor(NewValue:TColor);
Begin
     GpiSetAttrs(Handle,PRIM_LINE,LBB_COLOR,0,NewValue);
End;

Procedure TCanvas.SetCharColor(NewValue:TColor);
Begin
     GpiSetAttrs(Handle,PRIM_CHAR,CBB_COLOR,0,NewValue);
End;

Procedure TCanvas.SetAreaColor(NewValue:TColor);
Begin
     GpiSetAttrs(Handle,PRIM_AREA,ABB_COLOR,0,NewValue);
End;

Procedure TCanvas.BeginArea(Mode:TAreaMode);
Var Flag:LongWord;
Begin
     Case Mode Of
       arNoBoundary:Flag:=BA_NOBOUNDARY;
       arBoundary:Flag:=BA_BOUNDARY;
       arAlternate:Flag:=BA_ALTERNATE;
       arNoBoundaryAlternate:Flag:=BA_NOBOUNDARY OR BA_ALTERNATE;
       arNoBoundaryWinding:Flag:=BA_NOBOUNDARY OR BA_WINDING;
       arBoundaryWinding:Flag:=BA_BOUNDARY OR BA_WINDING;
       arBoundaryAlternate:Flag:=BA_BOUNDARY OR BA_ALTERNATE;
       Else Flag:=BA_WINDING;
     End;
     GpiBeginArea(Handle,Flag);
End;

Procedure TCanvas.EndArea;
Begin
     GpiEndArea(Handle);
End;

Procedure TCanvas.PolySpline(aptl:Array Of TPoint);
Begin
     GpiMove(Handle,aptl[0]);
     GpiPolySpline(Handle,High(aptl),aptl[1]);
End;

Procedure TCanvas.Transform(m:TMatrix;Mode:TTransformMode);
Var Flags:LongWord;
Begin
     Case Mode Of
       trReplace:Flags:=TRANSFORM_REPLACE;
       trAdd:Flags:=TRANSFORM_ADD;
       Else Flags:=TRANSFORM_PREEMPT;
     End;

     GpiSetModelTransformMatrix(Handle,9,m.FMatrix,Flags);
End;

Procedure TCanvas.ResetTransform;
Var m:TMatrix;
Begin
     m.CreateDefault;
     Transform(m,trReplace);
     m.Destroy;
End;

Procedure TCanvas.SetTransformMatrix(Const m:TMatrix);
Begin
     Transform(m,trReplace);
End;

Function TCanvas.GetTransformMatrix:TMatrix;
Begin
     Result.CreateIntern;
     GpiQueryModelTransformMatrix(Handle,9,Result.FMatrix);
End;
{$ENDIF}

Procedure TCanvas.SetPalette(NewPalette:TPalette);
Var OldHandle:LongWord;
Begin
     If NewPalette=Nil Then Exit;
     OldHandle:=Palette.Handle;
     Palette.Handle:=NewPalette.Handle;
     {$IFDEF OS2}
     GpiSelectPalette(Handle,Palette.Handle);
     GpiCreateLogColorTable(Handle,0,LCOLF_RGB,0,0,Nil);
     {$ENDIF}
     {$IFDEF Win32}
     SelectPalette(Handle,Palette.Handle,True);
     {$ENDIF}

     If Owner Is TGraphic Then TGraphic(Owner).PaletteChanged
     Else
     Begin
          {$IFDEF OS2}
          GpiDeletePalette(OldHandle);
          {$ENDIF}
          {$IFDEF Win32}
          DeleteObject(OldHandle);
          {$ENDIF}
     End;
End;

Function TCanvas.GetPageViewPort:TRect;
Begin
     {$IFDEF OS2}
     GpiQueryPageViewPort(Handle,RECTL(Result));
     {$ENDIF}
End;

Procedure TCanvas.SetPageViewPort(NewValue:TRect);
Begin
     {$IFDEF OS2}
     GpiSetPageViewPort(Handle,RECTL(NewValue));
     {$ENDIF}
End;

Procedure TCanvas.SetPen(NewPen:TPen);
Begin
     If ((NewPen=Nil)Or(FPen=Nil)) Then Exit;

     FPen.color:=NewPen.color;
     FPen.Style:=NewPen.Style;
     FPen.Mode:=NewPen.Mode;
     FPen.Width:=NewPen.Width;
End;

Procedure TCanvas.SetBrush(NewBrush:TBrush);
Begin
     If ((NewBrush=Nil)Or(FBrush=Nil)) Then Exit;

     FBrush.color:=NewBrush.color;
     FBrush.Mode:=NewBrush.Mode;
     FBrush.Style:=NewBrush.Style;
     FBrush.Bitmap:=NewBrush.Bitmap;
End;

Procedure TCanvas.CopyRect(Const Dest:TRect;Canvas:TCanvas;Const Source:TRect);
Begin
     BitBlt(Canvas,Dest,Source,CopyMode,bitfIgnore);
End;


Procedure TCanvas.BitBlt(DestCanvas:TCanvas;Const Dest,Source:TRect;
                         Mode:TBitBltMode;Flags:TBitBltFlags);
{$IFDEF OS2}
Const BitBltModes:Array[TBitBltMode] Of LongWord=
          (ROP_SRCCOPY,ROP_SRCPAINT,ROP_SRCAND,ROP_SRCINVERT,
           ROP_SRCERASE,ROP_NOTSRCCOPY,ROP_NOTSRCERASE,ROP_MERGECOPY,
           ROP_MERGEPAINT,ROP_PATCOPY,ROP_PATPAINT,ROP_PATINVERT,
           ROP_DSTINVERT,ROP_ZERO,ROP_ONE);
Const BitBltOptions:Array[TBitBltFlags] Of LongWord=
          (BBO_OR,BBO_AND,BBO_IGNORE);
Var  aptl:Array[0..3] Of POINTL;
{$ENDIF}
{$IFDEF Win32}
Const BitBltModes:Array[TBitBltMode] Of LongWord=
          (SRCCOPY,SRCPAINT,SRCAND,SRCINVERT,
           SRCERASE,NOTSRCCOPY,NOTSRCERASE,MERGECOPY,
           MERGEPAINT,PATCOPY,PATPAINT,PATINVERT,
           DSTINVERT,BLACKNESS,WHITENESS);
Var  _Source,_Dest:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     aptl[0].X:=Dest.Left;
     aptl[0].Y:=Dest.Bottom;
     aptl[1].X:=Dest.Right;
     aptl[1].Y:=Dest.Top;
     aptl[2].X:=Source.Left;
     aptl[2].Y:=Source.Bottom;
     aptl[3].X:=Source.Right;
     aptl[3].Y:=Source.Top;
     GpiBitBlt(DestCanvas.Handle,Handle,4,aptl[0],BitBltModes[Mode],BitBltOptions[Flags]);
     {$ENDIF}
     {$IFDEF Win32}
     CreateHandle;
     DestCanvas.CreateHandle;

     _Dest := Dest;
     RectToWin32Rect(_Dest);
     TransformRectToWin32(_Dest,TControl(DestCanvas.Control),DestCanvas.Graphic);
     _Source := Source;
     RectToWin32Rect(_Source);
     TransformRectToWin32(_Source,TControl(FControl),FGraphic);
     StretchBlt(DestCanvas.Handle, _Dest.Left,_Dest.Bottom,
                _Dest.Right-_Dest.Left, _Dest.Top-_Dest.Bottom,
                Handle, _Source.Left, _Source.Bottom,
                _Source.Right-_Source.Left, _Source.Top-_Source.Bottom,
                BitBltModes[Mode]);

     DestCanvas.DestroyHandle;
     DestroyHandle;
     {$ENDIF}
End;

Procedure TCanvas.ModifyClipRegion(Const rec:TRect;Mode:TModifyClipMode);
{$IFDEF WIN32}
Const clModes:Array[clmAnd..clmXor] Of LongInt=
             (RGN_AND,RGN_OR,RGN_DIFF,RGN_XOR);
{$ENDIF}
{$IFDEF WIN32}
Var Rgn:LongInt;
{$ENDIF}
Var rc:TRect;
Begin
     If FHandle=0 Then exit;
     rc:=rec;
     
     {$IFDEF OS2}
     If Mode=clmXor Then ExcludeClipRect(rec)
     Else
     Begin
          //TODO OS/2
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     TransformClientRect(rc,fOwnerObject); // TControl(FControl),FGraphic);
     dec(rc.Bottom); //!!
//rene nochmal verifizieren     
     RGN := CreateRectRgnIndirect(RECTL(rc));
     ExtSelectClipRgn(FHandle,RGN,clModes[Mode]);
     DeleteObject(RGN);
     {$ENDIF}
End;


Procedure TCanvas.SetClipRegion(Rects:Array Of TRect);
Var  T:LongInt;
     {$IFDEF Win32}
     FClip1:LongWord;
     {$ENDIF}
Begin
     If FClipRGN <> 0 Then DeleteClipRegion;
     If FHandle=0 Then exit;

     FClipRect := Rects[0];
     {FClipRect > Rectangle that covers All clip rectangles}
     For T := 1 To High(Rects) Do FClipRect := UnionRect(FClipRect,Rects[T]);

     {$IFDEF OS2}
     For T := 0 To High(Rects) Do
     Begin
          Inc(Rects[T].Right);
          Inc(Rects[T].Top);
     End;

     FClipRGN := GpiCreateRegion(FHandle,High(Rects)+1,RECTL(Rects[0]));
     GpiSetClipRegion(FHandle,FClipRGN,Nil);
     {$ENDIF}
     {$IFDEF Win32}
     For T := 0 To High(Rects) Do
     Begin
          TransformClientRect(Rects[T],fOwnerObject); // TControl(FControl),FGraphic);
          Inc(Rects[T].Right);
          Inc(Rects[T].Bottom);
     End;

     FClipRGN := CreateRectRgnIndirect(RECTL(Rects[0]));
     SelectClipRgn(FHandle,FClipRGN);
     For T := 1 To High(Rects) Do
     Begin
          FClip1 := CreateRectRgnIndirect(RECTL(Rects[T]));
          ExtSelectClipRgn(FHandle,FClip1,RGN_OR);
          DeleteObject(FClip1);
     End;
     {$ENDIF}
End;


Procedure TCanvas.DeleteClipRegion;
Begin
     If FClipRGN = 0 Then Exit;
     {$IFDEF OS2}
     GpiSetClipRegion(FHandle,0,Nil);
     GpiDestroyRegion(FHandle,FClipRGN);
     {$ENDIF}
     {$IFDEF Win32}
     SelectClipRgn(FHandle,0);
     DeleteObject(FClipRGN);
     {$ENDIF}
     FClipRGN := 0;
     FillChar(FClipRect,SizeOf(TRect),0);
End;


Procedure TCanvas.ExcludeClipRect(Const rec:TRect);
{$IFDEF Win32}
Var  FClip1:LongWord;
     rc:TRect;
{$ENDIF}
Begin
     If FClipRGN=0 Then Exit;
     If IsRectEmpty(rec) Then Exit;
     {$IFDEF OS2}
     GpiExcludeClipRectangle(FHandle,RECTL(rec));
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     {??}
     inc(rc.Right);
     //Dec(rc.Right); //!!
     //Dec(rc.Top);   //!!
     dec(rc.Bottom); //!!
     TransformClientRect(rc,fOwnerObject); // TControl(FControl),FGraphic);
     FClip1:=CreateRectRgnIndirect(RECTL(rc));
//     ExtSelectClipRgn(FHandle,FClip1,RGN_XOR);
     ExtSelectClipRgn(FHandle,FClip1,RGN_DIFF);
     DeleteObject(FClip1);
     {$ENDIF}
End;


Procedure TCanvas.SetClipRect(Const rec:TRect);
Begin
  SetClipRegion([rec]);
End;


Function TCanvas.GetPixel(X,Y:LongInt):TColor;
Var  P:TPoint;
Begin
  P := Point(X,Y);
  {$IFDEF OS2}
  Result := GpiQueryPel(FHandle,P);
  {$ENDIF}
  {$IFDEF Win32}
  TransformClientPoint(P,fOwnerObject); // TControl(FControl),FGraphic);
  Result := WinGDI.GetPixel(FHandle, P.X, P.Y);
  Result := WinColorToRGB(Result);
  {$ENDIF}
End;


Procedure TCanvas.SetPixel(X,Y:LongInt;Value:TColor);
Var  P:TPoint;
     {$IFDEF OS2}
     OldColor:TColor;
     {$ENDIF}         
Begin
     P := Point(X,Y);
     {$IFDEF OS2}              
     OldColor := Pen.color;
     Pen.color := Value;
     GpiSetPel(FHandle,P);
     Pen.color := OldColor;
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(P,fOwnerObject);  // TControl(FControl),FGraphic);
     WinGDI.SetPixel(FHandle, P.X, P.Y, RGBToWinColor(SysColorToRGB(Value)));
     {$ENDIF}
End;


Function TCanvas.TextHeight(Const Text:String):LongInt;
Var CX:LongInt;
Begin
     GetTextExtent(Text,CX,Result);
End;


Function TCanvas.TextWidth(Const Text:String):LongInt;
Var CY:LongInt;
Begin
     GetTextExtent(Text,Result,CY);
End;


Procedure TCanvas.TextRect(Const rc:TRect;X,Y:LongInt;Const Text:String);
Var SaveClip:TRect;
Begin
     SaveClip:=ClipRect;
     ClipRect:=rc;
     TextOut(X,Y,Text);
     ClipRect:=SaveClip;
End;


Procedure TCanvas.GetTextExtent(Const S:String;Var Width,Height:LongInt);
Var  aPS:PString;
     {$IFDEF OS2}
     Extent:Array[0..TXTBOX_COUNT] Of POINTL;
     {$ENDIF}
     {$IFDEF Win32}
     Extent:Size;
     s1:String;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     aPS:=@S;
     GpiQueryTextBox(FHandle,Length(aPS^),aPS^[1],TXTBOX_COUNT,Extent[0]);
     Width:=(Extent[TXTBOX_TOPRIGHT].X-Extent[TXTBOX_BOTTOMLEFT].X);
     Height:=(Extent[TXTBOX_TOPLEFT].Y-Extent[TXTBOX_BOTTOMLEFT].Y);
     {$ENDIF}
     {$IFDEF Win32}
     s1:=s;
     {Martin} if not NoConvertTextOut then
       StrOemToAnsi(s1);
     aPS:=@s1;
     GetTextExtentPoint32(FHandle,aPS^[1],Length(aPS^),Extent);
     Width:=Extent.CX;
     Height:=Extent.CY;
     {$ENDIF}
End;

Procedure TCanvas.SetFont(NewFont:TFont);
Var xRes:LongInt;
    S:String;
    TheFont:TFont;
Begin
     If NewFont=FFont Then Exit; //!!!

     xRes:=HorizontalResolution;
     If NewFont<>Nil Then
      If ((Screen<>Nil)And(Screen.Canvas<>Nil)) Then
       If xRes>Screen.Canvas.HorizontalResolution Then //Canvas Is Not A Screen Canvas
     Begin
          //Workaround For Printer Devices
          S:=NewFont.FaceName;
          UpcaseStr(S);
          If Pos(' ITALIC',S)=0 Then
          Begin
               S:=NewFont.FaceName+' Italic';
               If NewFont.PointSize<>0 Then
                 TheFont:=Screen.GetFontFromPointSize(S,NewFont.PointSize)
               Else
                 TheFont:=Screen.GetFontFromName(S,NewFont.Width,NewFont.Height);

               If TheFont=Nil Then
               Begin
                    S:=NewFont.FaceName+'.Italic';
                    If NewFont.PointSize<>0 Then
                      TheFont:=Screen.GetFontFromPointSize(S,NewFont.PointSize)
                    Else
                      TheFont:=Screen.GetFontFromName(S,NewFont.Width,NewFont.Height);
               End;

               If TheFont<>Nil Then
               Begin
                    FFontWidth:=0;
                    FFontHeight:=0;
                    FFontAttr:=[];
                    {der ControlFont darf nicht verndert werden !!!}
                    {Siehe auch TControl.SetFont !!}
                    Self.CreateFont(TheFont,False);
               End;
          End;
     End;

     {Set values To Default}
     FFontWidth:=0;
     FFontHeight:=0;
     FFontAttr:=[];
     {der ControlFont darf nicht verndert werden !!!}
     {Siehe auch TControl.SetFont !!}
     Self.CreateFont(NewFont,False);
End;

Procedure TCanvas.CreateFont(NewFont:TFont;ModifyControlFont:Boolean);
{$IFDEF OS2}
Var fa:FATTRS;
    aSizeF:SIZEF;
    fsSelection:LongInt;
    aptl:Array[0..1] Of POINTL;
    S:String;
    C:Cstring;
    Metrics:FONTMETRICS;
    xRes,yRes:LongInt;
    aHDC:HDC;
    res:LongInt;
    SafeTry,SafeTry1:Boolean;
    f1,f2:String;
Label TryAgain;
{$ENDIF}
{$IFDEF Win32,W32}
Var ahFont:HFONT;
    aFontInfo:LOGFONT;
{$ENDIF}
Var aWidth,aHeight:LongInt;
    aFontAttr:TFontAttributes;
    otherfont:Boolean;
Label L;
Begin
     otherfont:=False;
     If NewFont=Nil Then NewFont:=Screen.DefaultFont; {small}

     If FFontWidth=0 Then aWidth:=NewFont.Width     //Default
     Else
     Begin
          aWidth:=FFontWidth;
          otherfont:=True;
     End;
     If FFontHeight=0 Then aHeight:=NewFont.Height  //Default
     Else
     Begin
          aHeight:=FFontHeight;
          otherfont:=True;
     End;
     If FFontAttr=[] Then aFontAttr:=NewFont.Attributes
     Else
     Begin
          aFontAttr:=FFontAttr;
          otherfont:=True;
     End;

     {$IFDEF Win32}
     ahFont:=0;
L:
     aFontInfo:=NewFont.FFontInfo;
     aFontInfo.lfHeight:=aHeight;
     aFontInfo.lfWidth:=aWidth;
     aFontInfo.lfQuality:=DRAFT_QUALITY;
     If aFontAttr*[faItalic]<>[] Then aFontInfo.lfItalic:=1
     Else aFontInfo.lfItalic:=0;
     If aFontAttr*[faUnderScore]<>[] Then aFontInfo.lfUnderline:=1
     Else aFontInfo.lfUnderline:=0;
     If aFontAttr*[faStrikeOut]<>[] Then aFontInfo.lfStrikeOut:=1
     Else aFontInfo.lfStrikeOut:=0;
     If aFontAttr*[faBold]<>[] Then aFontInfo.lfWeight:=FW_BOLD
     Else aFontInfo.lfWeight:=FW_NORMAL;

     If Not otherfont Then
     Begin
          If NewFont.FHandle<>0 Then
          Begin
               If ahFont<>NewFont.FHandle Then
               Begin
                    ahFont:=NewFont.FHandle;
                    Inc(NewFont.FRefCount);
               End;
          End
          Else
          Begin
               ahFont:=CreateFontIndirect(aFontInfo);
               NewFont.FHandle:=ahFont;
               NewFont.FRefCount:=1;
          End;
     End
     Else ahFont:=CreateFontIndirect(aFontInfo);

     If ahFont<>0 Then
     Begin
          If FHandle<>0 Then SelectObject(FHandle,ahFont);
          If FFontHandle<>0 Then
          Begin
               If FFontHandle=FFont.FHandle Then
               Begin
                    If FFont.FRefCount>1 Then Dec(FFont.FRefCount)
                    Else
                    Begin
                         DeleteObject(FFontHandle);
                         FFont.FRefCount:=0;
                         FFont.FHandle:=0;
                    End;
               End
               Else If FFontHandle<>0 Then DeleteObject(FFontHandle)
          End;

          If FFont<>Nil Then If FFont<>NewFont Then DereferenceFont(FFont,False);

          If FFont<>NewFont Then
          Begin
               FFont:=NewFont;
               ReferenceFont(FFont);
          End;
          FFontHandle:=ahFont;
     End
     Else If FFont<>Nil Then //restore old Font
     Begin
          Beep(10,10);
          NewFont:=FFont;
          Goto L;
     End;
     If FControl<>Nil Then
     Begin
          If ModifyControlFont Then
          Begin
               SendMessage(TControl(FControl).Handle,WM_SETFONT,ahFont,1);
               If TPublicControl(FControl).FontChangeEnabled
               Then TPublicControl(FControl).FontChange;
          End;
     End;
     {$ENDIF}

     {$IFDEF OS2}
L:
     GpiSetCharSet(FHandle,LCID_DEFAULT);
     GpiDeleteSetId(FHandle,1);

     FillChar(fa,SizeOf(FATTRS),0);
     fa.szFaceName:=NewFont.FFontInfo.szFaceName;
     fa.usRecordLength:=SizeOf(FATTRS);

     fsSelection:=0;
     {Martin omit double-italic}
     If aFontAttr*[faItalic]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_ITALIC;
     If aFontAttr*[faUnderScore]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_UNDERSCORE;
     If aFontAttr*[faOutline]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_OUTLINE;
     If aFontAttr*[faStrikeOut]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_STRIKEOUT;
     If aFontAttr*[faBold]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_BOLD;
     fa.fsSelection:=fsSelection;

     fa.lMatch:=0;
     fa.idRegistry:=NewFont.FFontInfo.idRegistry;

     //fa.usCodePage:=NewFont.FFontInfo.usCodePage;
     {Martin0206}
     if NewFont.OS2Codepage = 0 then
       fa.usCodePage:=NewFont.FFontInfo.usCodePage
     else
       fa.usCodePage:= NewFont.OS2Codepage;

     fa.lMaxbaseLineExt:=NewFont.FFontInfo.lMaxbaseLineExt;
     If NewFont.FFontType=ftOutline Then fa.lMaxbaseLineExt:=0;
     fa.lAveCharWidth:=NewFont.FFontInfo.lAveCharWidth;
     If NewFont.FFontType=ftOutline Then fa.lAveCharWidth:=0;

     fa.fsType:=0;
     If NewFont.FFontInfo.fsType And longword(FM_TYPE_KERNING)<>0 Then
       fa.fsType:=fa.fsType Or FATTR_TYPE_KERNING;
     If NewFont.FFontInfo.fsType And longword(FM_TYPE_MBCS)<>0 Then
       fa.fsType:=fa.fsType Or FATTR_TYPE_MBCS;
     If NewFont.FFontInfo.fsType And longword(FM_TYPE_DBCS)<>0 Then
       fa.fsType:=fa.fsType Or FATTR_TYPE_DBCS;

     fa.fsFontUse:=0;

     xRes:=HorizontalResolution;
     If ((Screen<>Nil)And(Screen.Canvas<>Nil)) Then
      If xRes>Screen.Canvas.HorizontalResolution Then //Canvas Is Not A Screen Canvas
         fa.fsFontUse:=FATTR_FONTUSE_TRANSFORMABLE;

     If NewFont.FFontType=ftOutline Then
       fa.fsFontUse:=FATTR_FONTUSE_OUTLINE Or FATTR_FONTUSE_TRANSFORMABLE;

     SafeTry:=False;
     SafeTry1:=False;
TryAgain:
     {the System Default Font results FONT_DEFAULT !!!}
     res:=GpiCreateLogFont(FHandle,Nil,1,fa);
     If res = FONT_DEFAULT Then {Test, If it Is really the Default Font}
     Begin
          If (Screen <> Nil) And (Screen.DefaultFont <> Nil) Then
            If NewFont <> Nil Then
            Begin
              f1 := NewFont.FaceName;
              f2 := Screen.DefaultFont.FaceName;
              UpcaseStr(f1);
              UpcaseStr(f2);
              If f1 = f2 Then res := FONT_MATCH; {Font Is Ok}
            End;
     End;
     If ((res<>GPI_ERROR)And(res<>FONT_DEFAULT)) Then
     Begin
          If FFont<>NewFont Then
          Begin
               DereferenceFont(FFont,True);
               FFont:=NewFont;
               ReferenceFont(FFont);
          End;
          GpiSetCharSet(FHandle,1);
     End
     Else
     Begin
          If res=FONT_DEFAULT Then
          Begin
               If Not SafeTry Then
               Begin
                    //Try If we can Create the Font If we don't Use Special Flags
                    SafeTry:=True;
                    fa.usCodePage:=0;
                    Goto TryAgain;
               End
               Else If Not SafeTry1 Then
               Begin
                    SafeTry1:=True;
                    fa.fsSelection:=0;
                    fa.idRegistry:=0;
                    fa.fsType:=0;
                    Goto TryAgain;
               End;
          End;

          If FFont<>Nil Then //restore old Font
          Begin
               If FFont=NewFont Then FFont:=Screen.DefaultFont;
               NewFont:=FFont;
               Goto L;
          End;
     End;

     If NewFont.FFontType=ftOutline Then
     Begin
          //Set character Box
          If NewFont.FInternalPointSize<>0 Then
          Begin
               aHDC:=GpiQueryDevice(FHandle);
               DevQueryCaps(aHDC,CAPS_HORIZONTAL_FONT_RES,1,xRes);
               DevQueryCaps(aHDC,CAPS_VERTICAL_FONT_RES,1,yRes);

               aSizeF.CX:=65536*xRes*NewFont.FInternalPointSize Div 72;
               aSizeF.CY:=65536*yRes*NewFont.FInternalPointSize Div 72;
          End
          Else
          Begin
               aptl[0].X:=0;
               aptl[0].Y:=0;
               aptl[1].X:=aWidth*13;   {Font Width In Pixels}
               aptl[1].Y:=aHeight*13;  {Font Height In Pixels}
               //Convert To page coordinates
               GpiConvert(FHandle,CVTC_DEVICE,CVTC_PAGE,2,aptl[0]);
               aSizeF.CX:=(aptl[1].X-aptl[0].X) Shl 12;
               aSizeF.CY:=(aptl[1].Y-aptl[0].Y) Shl 12;
          End;

          If aSizeF.CX<aSizeF.CY Then aSizeF.CY:=aSizeF.CX
          Else aSizeF.CX:=aSizeF.CY;

          GpiSetCharBox(FHandle,aSizeF);
     End;

     If FControl <> Nil Then
       If TControl(FControl).Handle <> 0 Then
         If ModifyControlFont Then
     Begin
          If NewFont.FInternalPointSize<>0 Then
          Begin
               S:=tostr(NewFont.FInternalPointSize)+'.';
               C:=NewFont.FaceName;
          End
          Else
          Begin
               GpiQueryFontMetrics(FHandle,SizeOf(FONTMETRICS),Metrics);
               S:=tostr((Metrics.sNominalPointSize) Div 10)+'.';
               C:=Metrics.szFaceName;
          End;

          S:=S+C;
          S:=ModifyFontName(S,aFontAttr);
          TControl(FControl).SetPPFontNameSize(S);
     End;
     {$ENDIF}

End;

Procedure TCanvas.SetFontAttr(NewAttr:TFontAttributes);
Begin
     If GetFontAttr <> NewAttr Then
       Begin
         FFontAttr:=NewAttr;
         {der ControlFont darf nicht verndert werden !!!}
         Self.CreateFont(FFont,False);
       End;
End;

Function TCanvas.GetFontAttr:TFontAttributes;
Begin
     If FFontAttr=[]
       Then Result:=FFont.Attributes
       Else Result:=FFontAttr;
End;

Procedure TCanvas.SetFontHeight(NewHeight:LongInt);
Begin
     If GetFontHeight <> NewHeight Then
       Begin
         FFontHeight:=NewHeight;
         {der ControlFont darf nicht verndert werden !!!}
         Self.CreateFont(FFont,False);
       End;
End;

Function TCanvas.GetFontHeight:LongInt;
Begin
     If (FFontHeight=0) And (FFont<>Nil)  Then Result:=FFont.Height
     Else Result:=FFontHeight;
     If Result=0 Then Result:=TextHeight('yW');
End;

Procedure TCanvas.SetFontWidth(NewWidth:LongInt);
Begin
     If GetFontWidth <> NewWidth Then
       Begin
         FFontWidth:=NewWidth;
         {der ControlFont darf nicht verndert werden !!!}
         Self.CreateFont(FFont,False);
       End;
End;

Function TCanvas.GetFontWidth:LongInt;
Begin
     If (FFontWidth=0) And (FFont<>Nil)
       Then Result:=FFont.Width
       Else Result:=FFontWidth;
     If Result=0 Then Result:=TextWidth('W');
End;


Procedure TCanvas.SetupComponent;
Begin
     Inherited SetupComponent;

     //If Owner = Nil Then Exit;
     Include(ComponentState, csDetail);
     FControl:=Nil;
     FGraphic:=Nil;
     If IsControl(TControl(Owner)) Then FControl := TControl(Owner)
     Else If Owner Is TGraphic Then FGraphic := TGraphic(Owner);

     FPen.Create(Self);
     FBrush.Create(Self);
     FLineWidth:=1;
     FLineType:=psSolid;
     FCopyMode:=cmSrcCopy;
     FFontAttr:=[];
End;

Procedure TCanvas.Init;
Begin
     If (FControl <> Nil) And (TControl(FControl).Handle <> 0) Then
     Begin
          FOwnerDraw:=TPublicControl(FControl).OwnerDraw;

          {$IFDEF OS2}
          FHandle:=WinGetPS(TControl(FControl).Handle);
          GpiCreateLogColorTable(FHandle,LCOL_RESET,LCOLF_RGB,0,0,Nil);
          {$ENDIF}
          {$IFDEF Win32}
          If FOwnerDraw Then
          Begin
               If FHandle=0 Then FHandle:=GetDC(TControl(FControl).Handle);
               SetTextAlign(FHandle,TA_LEFT Or TA_BOTTOM);
               {
               If FPenHandle=0 Then FPenHandle:=CreatePen(PS_SOLID,0,0);  //Black solid Pen
               If FBrushHandle=0 Then FBrushHandle:=CreateSolidBrush(0);  //Black Brush
               }
          End;
          {$ENDIF}
          If TPublicControl(FControl).Font <> Nil Then Font := TPublicControl(FControl).Font
          Else Font := Screen.DefaultFont; {small}
     End
     Else If FGraphic<>Nil Then
     Begin
          FOwnerDraw:=True;
          {$IFDEF Win32}
          {
          FPenHandle:=CreatePen(PS_SOLID,0,0);  //Black solid Pen
          FBrushHandle:=CreateSolidBrush(0);    //Black Brush
          }

          {$ENDIF}
          Font:=Screen.DefaultFont; {small}
     End;

     Pen.Color:=clBlack;
     Brush.Color:=clWhite;
     Brush.Mode:=bmOpaque;
     Brush.Style:=bsSolid;
     Pen.Mode:=pmCopy;
     Pen.Style:=psSolid;

     FPalette.Create(Self);

     {$IFDEF WIN32}
     If FPenHandle<>0 Then
     Begin
         If FHandle<>0 Then
           SelectObject(FHandle,GetStockObject(BLACK_PEN));
         DeleteObject(FPenHandle);
         FPenHandle:=0;
     End;
     If FBrushHandle<>0 Then
     Begin
          If FHandle<>0 Then
            SelectObject(FHandle,GetStockObject(WHITE_BRUSH));
          DeleteObject(FBrushHandle);
          FBrushHandle:=0;
     End;
     {$ENDIF}
End;

Constructor TCanvas.Create(AOwner : TComponent);

Begin
  inherited Create(AOwner);
  fOwnerObject := AOwner;
  FNoConvertTextOut := false;  {Martin}
End;

Constructor TCanvas.CreateWithObject(AOwner : tObject);

Begin
  if AOwner is tComponent
    then inherited Create(tComponent(AOwner))
    else inherited Create(nil);
  fOwnerObject := AOwner;
End;


Destructor TCanvas.Destroy;
Begin
     {$IFDEF OS2}
     If FHandle<>0 Then WinReleasePS(FHandle);
     DereferenceFont(FFont,True);
     {$ENDIF}
     {$IFDEF Win32}
     If FHandle<>0 Then
     Begin
          SelectObject(FHandle,GetStockObject(BLACK_PEN));
          SelectObject(FHandle,GetStockObject(WHITE_BRUSH));
          If FControl <> Nil Then ReleaseDC(TControl(FControl).Handle,FHandle);
          SelectClipRgn(FHandle,0);
          FHandle:=0;
     End;
     If FPenHandle<>0 Then DeleteObject(FPenHandle);
     FPenHandle:=0;
     If FBrushHandle<>0 Then DeleteObject(FBrushHandle);
     FBrushHandle:=0;
     If FFontHandle<>0 Then
     Begin
          If FFontHandle=FFont.FHandle Then
          Begin
              If FFont.RefCount>1 Then FFont.RefCount := FFont.RefCount -1
              Else
              Begin
                   If FFontHandle<>0 Then DeleteObject(FFontHandle);
                   FFont.RefCount:=0;
                   FFont.Handle:=0;
              End;
          End
          Else If FFontHandle<>0 Then DeleteObject(FFontHandle);
     End;
     If FClipRGN<>0 Then DeleteObject(FClipRGN);
     FFontHandle:=0;
     If FFont<>Nil Then DereferenceFont(FFont,False);
     {$ENDIF}

     If FPalette <> Nil Then FPalette.Destroy;   {DragCanvas has no Palette}
     FPalette := Nil;
     If FPen <> Nil Then FPen.Destroy;
     FPen := Nil;
     If FBrush <> Nil Then FBrush.Destroy;
     FBrush := Nil;

     Inherited Destroy;   {erst hier weil Palette In ComponentListe steht}
End;


Function TCanvas.GetPenPosition:TPoint;
Begin
     {$IFDEF OS2}
     GPIQueryCurrentPosition(FHandle,Result);
     {$ENDIF}
     {$IFDEF Win32}
     GetCurrentPositionEx(FHandle,Result);
     TransformClientPoint(Result,fOwnerObject);  // TControl(FControl),FGraphic);
     {$ENDIF}
End;

Procedure TCanvas.SetPenPosition(NewPosition:TPoint);
Begin
     {$IFDEF OS2}
     GPIMove(FHandle,NewPosition);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(NewPosition,fOwnerObject);  // TControl(FControl),FGraphic);
     MoveToEx(FHandle,NewPosition.X,NewPosition.Y,NewPosition);
     {$ENDIF}
End;

Procedure TCanvas.EraseBackGround;
Begin
     If FControl = Nil Then Exit;
     FillRect(TControl(FControl).ClientRect,TPublicControl(FControl).Color);
End;


{wenn Systemfarbe eingestellt ist, dann versuchen Die Standardfarbtabelle
  verwenden und nicht RGB}
Procedure TCanvas.FillRect(Const rec:TRect; FillColor:TColor);
Var  rc:TRect;
     {$IFDEF Win32}
     TempBrush:HBRUSH;
     {$ENDIF}
Begin
  rc := rec;
  Inc(rc.Top);
  Inc(rc.Right);

  FillColor := SysColorToRGB(FillColor);
  {$IFDEF OS2}
  WinFillRect(FHandle,RECTL(rc),FillColor);
  {$ENDIF}
  {$IFDEF Win32}
  TransformClientRect(rc,fOwnerObject); // TControl(FControl),FGraphic);
  Inc(rc.Bottom,2);
  Inc(rc.Top);
  Inc(rc.Right);

  FillColor:=RGBToWinColor(FillColor);
  TempBrush:=CreateSolidBrush(FillColor);
  If FHandle<>0
    Then SelectObject(FHandle,TempBrush);
  WinUser.FillRect(FHandle,RECTL(rc),TempBrush);
  If FBrushHandle<>0
    Then SelectObject(FHandle,FBrushHandle)
    Else SelectObject(FHandle,GetStockObject(WHITE_BRUSH));
  If TempBrush<>0
    Then DeleteObject(TempBrush);
  {$ENDIF}
End;


{$IFDEF WIN32}
Function ExtendLastPoint(Src,Dest:TPoint):TPoint;
Var  X,Y,DX,dy:LongInt;
Begin
     Result := Dest;
     DX := Dest.X - Src.X;
     dy := Dest.Y - Src.Y;
     If (DX = 0) And (dy = 0) Then Exit;
     If Abs(DX) >= Abs(dy) Then
     Begin
          If Dest.X > Src.X Then Result.X := Dest.X + 1
          Else Result.X := Dest.X - 1;
          X := Result.X - Src.X;
          If dy <> 0 Then Result.Y := Round(((X * dy) / DX) + Src.Y)
     End
     Else
     Begin
          If Dest.Y > Src.Y Then Result.Y := Dest.Y + 1
          Else Result.Y := Dest.Y - 1;
          Y := Result.Y - Src.Y;
          If DX <> 0 Then Result.X := Round(((Y * DX) / dy) + Src.X)
     End;
End;
{$ENDIF}


Procedure TCanvas.MoveTo(X,Y:LongInt);
Begin
     PenPos:=Point(X,Y);
End;


Function TCanvas.GetVerticalRes:LongInt;
{$IFDEF OS2}
Var HDC:LongWord;
{$ENDIF}
Begin
     Result:=0;
     {$IFDEF OS2}
     If FControl=Nil Then
     Begin
          HDC:=GpiQueryDevice(FHandle);
          DevQueryCaps(HDC,CAPS_VERTICAL_RESOLUTION,1,Result);
     End
     Else
     Begin
          HDC:=WinOpenWindowDC(TControl(FControl).Handle);
          DevQueryCaps(HDC,CAPS_VERTICAL_RESOLUTION,1,Result);
          DevCloseDC(HDC);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=GetDeviceCaps(FHandle,LOGPIXELSY);
     Result := Result / ccNVInchMeter; {Wolfgang}
     {$ENDIF}
End;

Function TCanvas.GetHorizontalRes:LongInt;
{$IFDEF OS2}
Var HDC:LongWord;
{$ENDIF}
Begin
     Result:=0;
     {$IFDEF OS2}
     If FControl=Nil Then
     Begin
          HDC:=GpiQueryDevice(FHandle);
          DevQueryCaps(HDC,CAPS_HORIZONTAL_RESOLUTION,1,Result);
     End
     Else
     Begin
          HDC:=WinOpenWindowDC(TControl(FControl).Handle);
          DevQueryCaps(HDC,CAPS_HORIZONTAL_RESOLUTION,1,Result);
          DevCloseDC(HDC);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=GetDeviceCaps(FHandle,LOGPIXELSX);
     Result := Result / ccNVInchMeter; {Wolfgang}
     {$ENDIF}
End;

Procedure TCanvas.BeginPath;
Begin
     {$IFDEF OS2}
     GpiBeginPath(FHandle,1);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.BeginPath(FHandle);
     FInPath := True;
     {$ENDIF}
End;

Procedure TCanvas.EndPath;
Begin
     {$IFDEF OS2}
     GpiEndPath(FHandle);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.EndPath(FHandle);
     FInPath := False;
     {$ENDIF}
End;

Procedure TCanvas.CloseFigure;
Begin
     {$IFDEF OS2}
     GpiCloseFigure(FHandle);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.CloseFigure(FHandle);
     {$ENDIF}
End;

Procedure TCanvas.FillPath;
Begin
     {$IFDEF OS2}
     GpiFillPath(FHandle,1,FPATH_ALTERNATE);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.FillPath(FHandle);
     {$ENDIF}
End;

Procedure TCanvas.StrokePath;
Begin
     {$IFDEF OS2}
     GpiStrokePath(FHandle,1,0);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.StrokePath(FHandle);
     {$ENDIF}
End;

Procedure TCanvas.OutlinePath;
Begin
     {$IFDEF OS2}
     GpiOutlinePath(FHandle,1,0);
     {$ELSE}
     StrokePath; {.?.}
     {$ENDIF}
End;

Procedure TCanvas.PathToClipRegion(Mode:TPathClipMode);
{$IFDEF OS2}
Var  reg1,reg2,regnew,regold:HRGN;
{$ENDIF}
{$IFDEF Win32}
Var  iMode:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     reg2:=GpiPathToRegion(FHandle,1,FPATH_ALTERNATE);

     If Mode<>paReplace Then
     Begin
          GpiSetClipRegion(FHandle,0,reg1);
          regnew:=GpiCreateRegion(FHandle,0,Nil);
          GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_DIFF);
     End
     Else
     Begin
          regnew:=reg2;
          reg1:=0;
          reg2:=0;
     End;

     Case Mode Of
        paSubtract:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_XOR);
        paAdd:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_OR);
        paDiff:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_DIFF);
        paIntersect:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_AND);
        paReplace:;
     End;

     GpiSetClipRegion(FHandle,regnew,regold);
     If regold<>0 Then GpiDestroyRegion(FHandle,regold);
     If reg1<>0 Then GpiDestroyRegion(FHandle,reg1);
     If reg2<>0 Then GpiDestroyRegion(FHandle,reg2);
     If FClipRGN<>0 Then GpiDestroyRegion(FHandle,FClipRGN);
     FClipRGN:=regnew;
     {$ENDIF}
     {$IFDEF Win32}
     Case Mode Of
        paSubtract:iMode:=RGN_XOR;
        paAdd:iMode:=RGN_OR;
        paDiff:iMode:=RGN_DIFF;
        paIntersect:iMode:=RGN_AND;
        paReplace:iMode:=RGN_COPY;
     End;
     WinGDI.SelectClipPath(FHandle,iMode);
     {$ENDIF}
End;


Procedure TCanvas.LineTo(X,Y:LongInt);
Var  Dest:TPoint;
Begin
     Dest := Point(X,Y);
     {$IFDEF OS2}
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiLine(FHandle,Dest);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Dest := ExtendLastPoint(GetPenPosition,Dest);
     TransformClientPoint(Dest,fOwnerObject);  // TControl(FControl),FGraphic);
     WinGDI.LineTo(FHandle,Dest.X,Dest.Y);
     {$ENDIF}
End;

Procedure TCanvas.Line(X,Y,X1,y1:LongInt);
Begin
     MoveTo(X,Y);
     LineTo(X1,y1);
End;

Procedure TCanvas.PolyLine(Points:Array Of TPoint);
{$IFDEF Win32}
Var  T:LongInt;
     P:TPoint;
     Q:TPoint;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FUsePath Then GpiBeginPath(FHandle,1);
     GPIMove(FHandle,Points[0]);
     GpiPolyLine(FHandle,High(Points)+1,Points[0]);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If High(Points) > 1 Then
     Begin
          P:=Points[High(Points)-1];
          Points[High(Points)]:=ExtendLastPoint(P,Points[High(Points)]);
     End;

     If FInPath Then
     Begin
          For T:=1 To High(Points) Do
          Begin
               Q := Points[T-1];
               P := Points[T];
               If (Q.X < P.X) And (Q.Y > P.Y) Then
               Begin
                    P.X := P.X + 1;
                    P.Y := P.Y - 1;
                    Points[T] := P;
               End;
          End;
     End;

     For T:=0 To High(Points)
        Do TransformClientPoint(Points[T],fOwnerObject);  // TControl(FControl),FGraphic);
     WinGDI.PolyLine(FHandle,WinDef.Point(Points[0]),High(Points)+1);
     PenPos:=Points[High(Points)];
     {$ENDIF}
End;

Procedure TCanvas.Polygon(Points:Array Of TPoint);
{$IFDEF OS2}
Var  ThePolygon:PmGpi.Polygon;
{$ENDIF}
{$IFDEF Win32}
Var  T:LongInt;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FUsePath Then GpiBeginPath(FHandle,1);
     GPIMove(FHandle,Points[0]);
     ThePolygon.ulPoints:=High(Points)+1;
     ThePolygon.POINTL:=@Points[0];
     GpiPolygons(FHandle,1,ThePolygon,0,0);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     For T:=0 To High(Points)
        Do TransformClientPoint(Points[T], fOwnerObject);  // ,TControl(FControl),FGraphic);
     WinGDI.Polygon(FHandle,WinDef.Point(Points[0]),High(Points)+1);
     PenPos:=Points[High(Points)];
     {$ENDIF}
End;

Procedure TCanvas.ShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
{$IFDEF Win32}
Var  Pen:HPEN;
     Pen1:HPEN;
{$ENDIF}
{$IFDEF OS2}
Var  OldPenColor:TColor;
     OldPenWidth:LongInt;
{$ENDIF}
Begin
     If FHandle = 0 Then Exit;
     ColorHi := SysColorToRGB(ColorHi);
     ColorLo := SysColorToRGB(ColorLo);

     {$IFDEF OS2}
     OldPenColor := Pen.color;
     OldPenWidth := Pen.Width;
     Pen.color := ColorHi;
     Line(rec.Left,rec.Top,rec.Right,rec.Top);
     Pen.color := ColorLo;
     Line(rec.Left,rec.Bottom,rec.Right,rec.Bottom);
     Pen.color := ColorHi;
     Line(rec.Left,rec.Bottom,rec.Left,rec.Top);
     Pen.color := ColorLo;
     Line(rec.Right,rec.Bottom,rec.Right,rec.Top);
     Pen.color := OldPenColor;
     Pen.Width := OldPenWidth;
     {$ENDIF}

     {$IFDEF Win32}
     ColorLo := RGBToWinColor(ColorLo);
     ColorHi := RGBToWinColor(ColorHi);
     Pen1 := CreatePen(PS_SOLID,1,ColorHi);
     SelectObject(FHandle,Pen1);
     Line(rec.Left,rec.Bottom,rec.Left,rec.Top);
     Line(rec.Left,rec.Top,rec.Right,rec.Top);
     Pen:=CreatePen(PS_SOLID,1,ColorLo);
     DeleteObject(SelectObject(FHandle,Pen));
     Line(rec.Right,rec.Bottom,rec.Right,rec.Top);
     Line(rec.Left,rec.Bottom,rec.Right,rec.Bottom);
     If FPenHandle<>0 Then DeleteObject(SelectObject(FHandle,FPenHandle))
     Else DeleteObject(SelectObject(FHandle,GetStockObject(BLACK_PEN)));
     If Pen <> 0 Then DeleteObject(Pen);
     {$ENDIF}
End;

Procedure TCanvas.RoundShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
Var  I:LongInt;
     {$IFDEF Win32}
     Pen:HPEN;
     Pen1:HPEN;
     {$ENDIF}
     {$IFDEF OS2}
     OldPenColor:TColor;
     OldPenWidth:LongInt;
     {$ENDIF}
Begin
     If FHandle = 0 Then Exit;
     ColorHi := SysColorToRGB(ColorHi);
     ColorLo := SysColorToRGB(ColorLo);
     I := 2;

     {$IFDEF OS2}
     OldPenColor := Pen.color;
     OldPenWidth := Pen.Width;
     Pen.color := ColorHi;
     Line(rec.Left+I,rec.Bottom,rec.Left,rec.Bottom+I);
     Line(rec.Left,rec.Bottom+I,rec.Left,rec.Top-I);
     Pen.color := ColorLo;
     Line(rec.Right-I,rec.Top,rec.Right,rec.Top-2);
     Line(rec.Right,rec.Top-I,rec.Right,rec.Bottom+2);
     Pen.color := ColorHi;
     Line(rec.Left,rec.Top-I,rec.Left+I,rec.Top);
     Line(rec.Left+I,rec.Top,rec.Right-I,rec.Top);
     Pen.color := ColorLo;
     Line(rec.Right,rec.Bottom+I,rec.Right-I,rec.Bottom);
     Line(rec.Right-I,rec.Bottom,rec.Left+I,rec.Bottom);
     Pen.color := OldPenColor;
     Pen.Width := OldPenWidth;
     {$ENDIF}

     {$IFDEF Win32}
     ColorLo := RGBToWinColor(ColorLo);
     ColorHi := RGBToWinColor(ColorHi);
     Pen1 := CreatePen(PS_SOLID,1,ColorHi);
     SelectObject(FHandle,Pen1);
     Line(rec.Left+I,rec.Bottom,rec.Left,rec.Bottom+I);
     Line(rec.Left,rec.Bottom+I,rec.Left,rec.Top-I);
     Line(rec.Left,rec.Top-I,rec.Left+I,rec.Top);
     Line(rec.Left+I,rec.Top,rec.Right-I,rec.Top);
     Pen:=CreatePen(PS_SOLID,1,ColorLo);
     DeleteObject(SelectObject(FHandle,Pen));
     Line(rec.Right-I,rec.Top,rec.Right,rec.Top-I);
     Line(rec.Right,rec.Top-I,rec.Right,rec.Bottom+I);
     Line(rec.Right,rec.Bottom+I,rec.Right-I,rec.Bottom);
     Line(rec.Right-I,rec.Bottom,rec.Left+I,rec.Bottom);
     If FPenHandle<>0 Then DeleteObject(SelectObject(FHandle,FPenHandle))
     Else DeleteObject(SelectObject(FHandle,GetStockObject(BLACK_PEN)));
     If Pen <> 0 Then DeleteObject(Pen);
     {$ENDIF}
End;


Procedure TCanvas.Rectangle(Const rec:TRect);
{$IFDEF OS2}
Var  CurrentPoint,DiagPoint:TPoint;
{$ENDIF}

Begin
  {$IFDEF OS2}
  CurrentPoint.X:=rec.Left;
  CurrentPoint.Y:=rec.Bottom;
  DiagPoint.X:=CurrentPoint.X+(rec.Right-rec.Left);
  DiagPoint.Y:=CurrentPoint.Y+(rec.Top-rec.Bottom);
  GPIMove(FHandle,CurrentPoint);
  GPIBox(FHandle,DRO_OUTLINE,DiagPoint,0,0);
  {$ENDIF}
  {$IFDEF Win32}
  PolyLine([Point(rec.Left,rec.Bottom-1),Point(rec.Right+1,rec.Bottom-1),
            Point(rec.Right+1,rec.Top),Point(rec.Left,rec.Top),
            Point(rec.Left,rec.Bottom-1)])
  {$ENDIF}
End;

Procedure TCanvas.FilledRoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
Begin
  BeginPath;
  RoundRect(rec,RoundWidth,RoundHeight);
  EndPath;
  FillPath;
End;

Procedure TCanvas.RoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
{$IFDEF Win32}
Var rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If RoundWidth>rec.Right-rec.Left Then RoundWidth:=(rec.Right-rec.Left) Div 2;
     If RoundHeight>rec.Top-rec.Bottom Then RoundHeight:=(rec.Top-rec.Bottom) Div 2;

     PenPos:=Point(rec.Left+RoundWidth,rec.Bottom);
     LineTo(rec.Right-RoundWidth,rec.Bottom);
     Arc(rec.Right-RoundWidth,rec.Bottom+RoundHeight,RoundWidth,RoundHeight,270,90);

     LineTo(rec.Right,rec.Top-RoundHeight);
     Arc(rec.Right-RoundWidth,rec.Top-RoundHeight,RoundWidth,RoundHeight,0,90);

     LineTo(rec.Left+RoundWidth,rec.Top);
     Arc(rec.Left+RoundWidth,rec.Top-RoundHeight,RoundWidth,RoundHeight,90,90);

     LineTo(rec.Left,rec.Bottom+RoundHeight);
     Arc(rec.Left+RoundWidth,rec.Bottom+RoundHeight,RoundWidth,RoundHeight,180,90);
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     Dec(rc.Bottom);
     Inc(rc.Right);
     RectToWin32Rect(rc);
     WinGDI.RoundRect(FHandle, rc.Left, rc.Top, rc.Right, rc.Bottom, RoundWidth, RoundHeight);
     {$ENDIF}
End;

Procedure TCanvas.DrawInvertRect(Const rec:TRect);
Var  rc:TRect;
     {$IFDEF OS2}
     SaveLineType:TPenStyle;
     {$ENDIF}
Begin
     rc := rec;
     {$IFDEF OS2}
     Inc(rc.Right);
     Inc(rc.Top);
     SaveLineType:=Pen.Style;
     Pen.Style:=psAlternate;
     WinDrawBorder(FHandle,RECTL(rc),1,1,clBlack,clBlack,DB_DESTINVERT);
     Pen.Style:=SaveLineType;
     {$ENDIF}
     {$IFDEF Win32}
     Dec(rc.Bottom);
     Inc(rc.Right);
     RectToWin32Rect(rc);
     TransformClientRect(rc,fOwnerObject); // TControl(FControl),FGraphic);
     WinUser.DrawFocusRect(FHandle,RECTL(rc));
     {$ENDIF}
End;

Procedure TCanvas.Circle(X,Y:LongInt;Radius:LongInt);
Begin
     Ellipse(X,Y,Radius,Radius);
End;

Procedure TCanvas.BrushCopy(Const Dest:TRect;Bitmap:TGraphic;Const Source:TRect;Color:TColor);
Var Mask:TGraphic;
Begin
     Mask:=Bitmap.CreateMask(Color);
     Mask.Canvas.BitBlt(Self,Dest,Source,cmSrcAnd,bitfIgnore);
     Bitmap.Canvas.BitBlt(Self,Dest,Source,cmSrcPaint,bitfIgnore);
     Mask.Destroy;
End;

{Martin}
{16/2/2005: I've rewritten the Windows part of Arcs and Pies.}

{$ifdef win32}
 function WindowsArcPie(Canvas : tCanvas; Pie : boolean; X, Y : longint; dwRadiusX, dwRadiusY : LONGWORD;
                    fStartDegrees, fSweepDegrees : extended) : boolean;
   {if the sweep angle is greater than 360 degrees,
    the arc/pie will not be swept multiple times}
   {this code is based on http://support.microsoft.com/kb/q125693/}
   var
     iXStart, iYStart,        // End point of starting radial line.
     iXEnd, iYEnd : longint;  // End point of ending radial line.
     fStartRadians,           // Start angle in radians.
     fEndRadians : double;    // End angle in radians.
     bResult : boolean;       // Function result.
     fTwoPi : double;
     EndPoint : tPoint;
     winBrush : HBRUSH;
   begin
     fTwoPi := 2.0 * Pi;
     { Get the starting and ending angle in radians. }
     if fSweepDegrees > 0.0 then begin
       fStartRadians := ((fStartDegrees / 360.0) * fTwoPi);
       fEndRadians := (((fStartDegrees + fSweepDegrees) / 360.0) * fTwoPi);
     end
     else begin
       {Martin0607}fStartDegrees := 360.0 - fStartDegrees;
       fStartRadians := (((fStartDegrees + fSweepDegrees)  / 360.0) *
                          fTwoPi);
       fEndRadians :=  ((fStartDegrees / 360.0) * fTwoPi);
     end;

     { Calculate a point on the starting radial line via }
     { polar -> cartesian conversion. }
     SetTrigMode(Rad);

     iXStart := X + (dwRadiusX * cos(fStartRadians));
     iYStart := Y - (dwRadiusY * sin(fStartRadians));

     { Calculate a point on the ending radial line via }
     { polar -> cartesian conversion. }
     iXEnd := X + (dwRadiusX * cos(fEndRadians));
     iYEnd := Y - (dwRadiusY * sin(fEndRadians));

     if Pie then begin
       winBrush := WinGDI.CreateSolidBrush (RGBToWinColor(SysColorToRGB(Canvas.Brush.Color)));
       WinGDI.SelectObject (Canvas.Handle, winBrush);
       bResult := WinGDI.Pie(Canvas.Handle, X - dwRadiusX, Y - dwRadiusY,
                             X + dwRadiusX, Y + dwRadiusY,
                             iXStart, iYStart,
                             iXEnd, iYEnd);
       WinGDI.DeleteObject (winBrush);
     end
     else
       bResult := WinGDI.Arc(Canvas.Handle, X - dwRadiusX, Y - dwRadiusY,
                             X + dwRadiusX, Y + dwRadiusY,
                             iXStart, iYStart,
                             iXEnd, iYEnd);
     if not Pie then begin
       { Move to the ending point. Arc() will not do this}
       if (fSweepDegrees < 0.0) then begin
         EndPoint.X := ixStart; EndPoint.Y := iyStart;
       end
       else begin
         EndPoint.X := ixEnd; EndPoint.Y := iyEnd;
       end;
       TransformClientPoint(EndPoint,Canvas.OwnerObject);
       Canvas.Penpos := EndPoint;
     end;
     result := bResult;
 end;
{$endif}


Procedure ChordPie(Canvas:TCanvas;X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended;
                   Var StartPoint:TPoint);
Var  pt   :TPoint;
{$IFDEF OS2}
     arcp:ARCPARAMS;
     sa,swa:FIXED;
     save:TPenStyle;
{$ENDIF}

{$IFDEF Win32}
     ptw :  TPoint;
{$ENDIF}

Begin
     pt:=Point(X,Y);
     Canvas.PenPos:=pt;
     {$IFDEF OS2}
     arcp.lp:=RadiusX;
     arcp.lQ:=RadiusY;
     arcp.lr:=0;
     arcp.lS:=0;
     GpiSetArcParams(Canvas.FHandle,arcp);
     sa:=MAKEFIXED(Trunc(StartAngle),Round(Frac(StartAngle)*100));
     swa:=MAKEFIXED(0,0);
     save:=Canvas.Pen.Style;
     Canvas.Pen.Style:=psClear;
     GpiPartialArc(Canvas.FHandle,pt,MAKEFIXED(1,0),sa,swa);
     Canvas.Pen.Style:=save;
     StartPoint:=Canvas.PenPos;
     Canvas.BeginPath;
     swa:=MAKEFIXED(Trunc(SweepAngle),Round(Frac(SweepAngle)*100));
     GpiPartialArc(Canvas.FHandle,pt,MAKEFIXED(1,0),sa,swa);
     {$ENDIF}
     {$IFDEF Win32}
     ptw := pt;
     {Martin}TransformClientPoint(ptw,Canvas.OwnerObject);
     WindowsArcPie(Canvas, true,ptw.X,ptw.Y,RadiusX,RadiusY,StartAngle,SweepAngle);
     {$ENDIF}
End;

Procedure TCanvas.Chord(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
Var StartPoint:TPoint;
    SaveColor:TColor;
Begin
     SaveColor:=Pen.color;
     If Brush.Style=bsSolid Then Pen.color:=Brush.color;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     {$ifdef os2}
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     FillPath;
     {$endif}

     Pen.color:=SaveColor;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     {$ifdef os2}
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     OutlinePath;
     {$endif}
End;

Procedure TCanvas.Pie(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
Var StartPoint:TPoint;
    SaveColor:TColor;
Begin
     SaveColor:=Pen.color;
     If Brush.Style=bsSolid Then Pen.color:=Brush.color;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     {$ifdef os2}
     LineTo(X,Y);
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     FillPath;
     {$endif}

     Pen.color:=SaveColor;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     {$ifdef os2}
     LineTo(X,Y);
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     OutlinePath;
     {$endif}
End;

Procedure TCanvas.Arc(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);

Var  pt  : TPoint;

{$IFDEF Win32}
Var  ptw : TPoint;
{$ENDIF}
{$IFDEF OS2}
Var  arcp:ARCPARAMS;
     sa,swa:FIXED;
     save:TPenStyle;
{$ENDIF}


{ Martin0607

  The meaning of StartAngle and SweepAngle

  StartAngle 0.0 is three o'clock at the clock face
  SweepAngle < 0 means clockwise
  SweepAngle > 0 means counterclockwise

  Until June 2007, there was a bug in Canvas.Arc if SweepAngle < 0: The startpoint switched to 12 o'clock

  To simulate the old behaviour, use this:

  procedure OldArc (Canvas : tCanvas; X, Y, RadiusX, RadiusY : longint; StartAngle, SweepAngle : extended);
    begin
      if SweepAngle < 0.0 then begin
        StartAngle := StartAngle - 90.0;
        if StartAngle < 0.0 then StartAngle := StartAngle + 360.0;
      end;
      Canvas.Arc(X, Y, RadiusX, RadiusY, StartAngle, SweepAngle);
    end;

}



Begin
     pt:=Point(X,Y);
     {$IFDEF Win32}
     {Martin0607}
     (*If SweepAngle<0 Then
     Begin
          SetArcDirection(FHandle,AD_CLOCKWISE);
          SweepAngle:=-SweepAngle;
     End
     Else SetArcDirection(FHandle,AD_COUNTERCLOCKWISE);*)
     ptw := pt;
     TransformClientPoint(ptw,fOwnerObject);  // TControl(FControl),FGraphic);
     PenPos:=pt;
     WindowsArcPie(self, false, ptw.X,ptw.Y,RadiusX,RadiusY,StartAngle,SweepAngle);
     {Martin0607}
     (*SetArcDirection(FHandle,AD_COUNTERCLOCKWISE);*)
     {$ENDIF}
     {$IFDEF OS2}
     If SweepAngle>=0 Then //counterclockwise
     Begin
         arcp.lp:=RadiusX;
         arcp.lQ:=RadiusY;
         arcp.lr:=0;
         arcp.lS:=0;
     End
     Else
     Begin
         arcp.lr:=RadiusX;
         arcp.lS:=RadiusY;
         arcp.lp:=0;
         arcp.lQ:=0;
         (*If SweepAngle<0 Then SweepAngle:=-SweepAngle;*)
         {Martin0607}
         SweepAngle := -SweepAngle;
         StartAngle := StartAngle + 90.0;
         if StartAngle > 360.0 then StartAngle := StartAngle - 360.0;
     End;
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiSetArcParams(FHandle,arcp);
     sa:=MAKEFIXED(Trunc(StartAngle),Round(Frac(StartAngle)*100));
     swa:=MAKEFIXED(0,0);
     save:=Pen.Style;
     Pen.Style:=psClear;
     GpiPartialArc(FHandle,pt,MAKEFIXED(1,0),sa,swa);
     Pen.Style:=save;
     swa:=MAKEFIXED(Trunc(SweepAngle),Round(Frac(SweepAngle)*100));
     GpiPartialArc(FHandle,pt,MAKEFIXED(1,0),sa,swa);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
End;




Procedure TCanvas.FilledCircle(X,Y:LongInt;Radius:LongInt);
Begin
     FilledEllipse(X,Y,Radius,Radius);
End;

Procedure TCanvas.Ellipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
Var  pt:TPoint;
     {$IFDEF OS2}
     arcp:ARCPARAMS;
     {$ENDIF}
Begin
     pt:=Point(X,Y);
     {$IFDEF OS2}
     arcp.lp:=RadiusX;
     arcp.lQ:=RadiusY;
     arcp.lr:=0;
     arcp.lS:=0;
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiSetArcParams(FHandle,arcp);
     GPIMove(FHandle,pt);
     GpiFullArc(FHandle,DRO_OUTLINE,MAKEFIXED(1,0));
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,fOwnerObject);  // TControl(FControl),FGraphic);
     WinGDI.Arc(FHandle,pt.X-RadiusX,pt.Y+RadiusY,pt.X+RadiusX,pt.Y-RadiusY,
                pt.X-RadiusX,pt.Y-RadiusY,pt.X-RadiusX,pt.Y-RadiusY);
     {$ENDIF}
End;

Procedure TCanvas.FilledEllipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
Var  pt:TPoint;
     {$IFDEF OS2}
     arcp:ARCPARAMS;
     {$ENDIF}
Begin
     pt:=Point(X,Y);
     {$IFDEF OS2}
     arcp.lp:=RadiusX;
     arcp.lQ:=RadiusY;
     arcp.lr:=0;
     arcp.lS:=0;
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiSetArcParams(FHandle,arcp);
     GPIMove(FHandle,pt);
     GpiFullArc(FHandle,DRO_FILL,MAKEFIXED(1,0));
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,fOwnerObject);  // TControl(FControl),FGraphic);
     WinGDI.Ellipse(FHandle,pt.X-RadiusX,pt.Y+RadiusY,pt.X+RadiusX,pt.Y-RadiusY);
     {$ENDIF}
End;

Procedure TCanvas.BezierSpline(X,Y:LongInt;Points:Array Of TPoint);
{$IFDEF Win32}
Var  T:LongInt;
{$ENDIF}
Begin
     MoveTo(X,Y);
     {$IFDEF OS2}
     GpiPolySpline(FHandle,High(Points)+1,Points[0]);
     {$ENDIF}
     {$IFDEF Win32}
     For T:=0 To High(Points)
        Do TransformClientPoint(Points[T],fOwnerObject);  // TControl(FControl),FGraphic);
     PolyBezierTo(FHandle,Points[0],High(Points)+1);
     {$ENDIF}
End;

Procedure TCanvas.Box(Const rec:TRect);
{$IFDEF OS2}
Var  CurrentPoint,DiagPoint:TPoint;
{$ENDIF}
{$IFDEF Win32}
Var  Pen:HPEN;
     rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     CurrentPoint.X:=rec.Left;
     CurrentPoint.Y:=rec.Bottom;
     DiagPoint.X:=CurrentPoint.X+(rec.Right-rec.Left);
     DiagPoint.Y:=CurrentPoint.Y+(rec.Top-rec.Bottom);
     GPIMove(FHandle,CurrentPoint);
     GPIBox(FHandle,DRO_FILL,DiagPoint,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     Pen:=GetStockObject(NULL_PEN);
     If FHandle<>0 Then SelectObject(FHandle,Pen);
     TransformClientRect(rc,fOwnerObject); // TControl(FControl),FGraphic);
     Inc(rc.Bottom,2);
     Inc(rc.Right,2);
     WinGDI.Rectangle(FHandle,rc.Left,rc.Bottom,rc.Right,rc.Top);
     If FHandle<>0 Then
     Begin
          If FPenHandle<>0 Then SelectObject(FHandle,FPenHandle)
          Else SelectObject(FHandle,GetStockObject(BLACK_PEN));
     End;
     If Pen<>0 Then DeleteObject(Pen);
     {$ENDIF}
End;

Procedure TCanvas.OutlineBox(Const rec:TRect);
{$IFDEF OS2}
Var  CurrentPoint,DiagPoint:TPoint;
{$ENDIF}
{$IFDEF Win32}
Var  rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     CurrentPoint.X:=rec.Left;
     CurrentPoint.Y:=rec.Bottom;
     DiagPoint.X:=CurrentPoint.X+(rec.Right-rec.Left);
     DiagPoint.Y:=CurrentPoint.Y+(rec.Top-rec.Bottom);
     GPIMove(FHandle,CurrentPoint);
     GPIBox(FHandle,DRO_OUTLINEFILL,DiagPoint,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     TransformClientRect(rc,fOwnerObject); // TControl(FControl),FGraphic);
     Inc(rc.Bottom);
     Inc(rc.Right);
     WinGDI.Rectangle(FHandle,rc.Left,rc.Bottom,rc.Right,rc.Top);
     {$ENDIF}
End;

Procedure TCanvas.DrawFocusRect(Const rec:TRect);
{$IFDEF OS2}
Var  SaveLineType:TPenStyle;
{$ENDIF}
{$IFDEF Win32}
Var  rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     SaveLineType:=Pen.Style;
     Pen.Style:=psAlternate;
     Rectangle(rec);
     Pen.Style:=SaveLineType;
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     Inc(rc.Right);
     Dec(rc.Bottom);
     RectToWin32Rect(rc);
     TransformClientRect(rc,fOwnerObject); // TControl(FControl),FGraphic);
     WinUser.DrawFocusRect(FHandle,RECTL(rc));
     {$ENDIF}
End;


Procedure TCanvas.FloodFill(X,Y:LongInt;BorderColor:TColor;FillSurface:Boolean);
Var  RefPoint:TPoint;
     Options:LongWord;
Begin
     RefPoint := Point(X,Y);
     BorderColor := SysColorToRGB(BorderColor);
     {$IFDEF OS2}
     GPIMove(FHandle,RefPoint);
     If FillSurface Then Options:=FF_SURFACE
     Else Options:=FF_BOUNDARY;
     GPIFloodFill(FHandle,Options,BorderColor);
     {$ENDIF}
     {$IFDEF Win32}
     BorderColor:=RGBToWinColor(BorderColor);
     TransformClientPoint(RefPoint,fOwnerObject);  // TControl(FControl),FGraphic);
     If FillSurface Then Options:=FLOODFILLSURFACE
     Else Options:=FLOODFILLBORDER;
     WinGDI.ExtFloodFill(FHandle,RefPoint.X,RefPoint.Y,BorderColor,Options);
     {$ENDIF}
End;


Procedure TCanvas.DrawString(Const S:String);
Var  pp:TPoint;
     {$IFDEF OS2}
     CX,CY:LongInt;
     rc:TRect;
     {$ENDIF}
     {$IFDEF Win32}
     Align:LongWord;
     {$ENDIF}
Begin
     pp:=PenPos;
     {$IFDEF OS2}
     {Some Fonts don't overpaint the the background}
     If Font.Attributes <> [] Then
       If Brush.Mode = bmOpaque Then
     Begin
          GetTextExtent(S,CX,CY);
          rc.Left := pp.X;
          rc.Bottom := pp.Y;
          rc.Right := rc.Left + CX -1;
          rc.Top := rc.Bottom + CY -1;
          FillRect(rc,Brush.color);
     End;
     GpiCharString(FHandle,Length(S),S[1]);
     {$ENDIF}
     {$IFDEF Win32}
     Align:=GetTextAlign(FHandle);
     SetTextAlign(FHandle,Align Or TA_UPDATECP);
     WinGDI.TextOut(FHandle,pp.X,pp.Y,S[1],Length(S));
     SetTextAlign(FHandle,Align);
     {$ENDIF}
End;

Procedure TCanvas.TextOut(X,Y:LongInt;Const S:String);

Var  pt:TPoint;
     CX,CY:LongInt;
     {$IFDEF OS2}
     rc:TRect;
     {$ENDIF}
     {$IFDEF Win32}
     Align:LongWord;
     S1:String;
     tm : TEXTMETRIC;
     OldMode : tBrushMode;
     OldPenColor : tColor;
     {$ENDIF}

Begin
     pt := Point(X,Y);
     {$IFDEF OS2}
     {Some Fonts don't overpaint the the background}
     If Font.Attributes <> [] Then
       If Brush.Mode = bmOpaque Then
     Begin
          GetTextExtent(S,CX,CY);
          rc.Left := X;
          rc.Bottom := Y;
          rc.Right := rc.Left + CX -1;
          rc.Top := rc.Bottom + CY -1;
          FillRect(rc,Brush.color);
     End;
     Inc(pt.Y,FFont.FFontInfo.lMaxDescender);
     GpiCharStringAt(FHandle,pt,Length(S),S[1]);
     {$ENDIF}
     {$IFDEF Win32}
     OldMode := Brush.Mode;
     Dec(pt.Y);
     {Martin}
     GetTextMetrics (FHandle, tm);
     if (tm.tmItalic <> 0) and (Brush.Mode = bmOpaque) then begin
       Brush.Mode := bmTransparent;
       GetTextExtent(S,CX,CY);
       GetTextExtent(S,CX,CY);
       OldPenColor := Pen.Color;
       Pen.Color := Brush.Color;
       Polygon ([Point(X,Y),Point(X+tm.tmOverhang,Y+CY-1),Point(X+tm.tmOverhang+CX-1,Y+CY-1),Point(X+CX-1,Y)]);
       Pen.Color := OldPenColor;
     end;
     (*{Martin!}Inc(pt.Y,Font.Height); tSpeedButton und andere werden auch falsch gezeichnet! *)
     PenPos:= pt;
     Align := GetTextAlign(FHandle);
     SetTextAlign(FHandle,Align Or TA_UPDATECP);
     TransformClientPoint(pt,fOwnerObject);  // TControl(FControl),FGraphic);
     S1:=S;
     {Martin}
     if not NoConvertTextOut then StrOemToAnsi(S1);
     WinGDI.TextOut(FHandle,pt.X,pt.Y,S1[1],Length(S1));
     if Brush.Mode <> OldMode then Brush.Mode := OldMode;
     SetTextAlign(FHandle,Align);
     {$ENDIF}
End;

Procedure TCanvas.MnemoTextOut(X,Y:LongInt;Const S:String);
Var  OldFontAttr:TFontAttributes;
     CX,CY:LongInt;
     s1,s2:String;
     P:Integer;
     rc:TRect;
Begin
     P := Pos(StandardMnemoChar,S);
     If (P > 0) And (P < Length(S)) Then
     Begin
          If FControl <> Nil Then TPublicControl(FControl).FontChangeEnabled := False;  {dont call FontChange}
          s1 := S;

          {Draw normal portion}
          s2 := Copy(s1,1,P-1);
          Delete(s1,1,P);   {incl. mnemo}
          GetTextExtent(s2,CX,CY);
          rc.Left := X;
          rc.Bottom := Y;
          rc.Right := X + CX;
          rc.Top := Y + CY;
          TextOut(X,Y,s2);
          Inc(X,CX);

          {Draw underlines portion}
          OldFontAttr := FontAttributes;
          FontAttributes := OldFontAttr + [faUnderScore];
          s2 := Copy(s1,1,1);    {Mnemo}
          Delete(s1,1,1);
          GetTextExtent(s2,CX,CY);
          rc.Left := X;
          rc.Right := X + CX;
          rc.Top := Y + CY;
          TextOut(X,Y,s2);
          Inc(X,CX);

          {Draw rest portion}
          FontAttributes := OldFontAttr;
          s2 := s1;
          GetTextExtent(s2,CX,CY);
          rc.Left := X;
          rc.Right := X + CX;
          rc.Top := Y + CY;
          TextOut(X,Y,s2);
          
          If FControl <> Nil Then TPublicControl(FControl).FontChangeEnabled := True;  {Default}
     End
     Else
     Begin
          GetTextExtent(S,CX,CY);
          rc.Left := X;
          rc.Bottom := Y;
          rc.Right := X + CX;
          rc.Top := Y + CY;
          TextOut(X,Y,S);
     End;
End;

Procedure TCanvas.Draw(X,Y:LongInt;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}

     rec.Left:=X;
     rec.Right:=X+Graphic.Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Graphic.Height;
     Graphic.Draw(Self,rec);
End;

Procedure TCanvas.PartialDraw(X,Y:LongInt;Const SourceRec:TRect;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}
                                  
     rec.Left:=X;
     rec.Right:=X+Graphic.Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Graphic.Height;
     Graphic.PartialDraw(Self,SourceRec,rec);
End;

Procedure TCanvas.StretchDraw(X,Y,Width,Height:LongInt;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}

     rec.Left:=X;
     rec.Right:=X+Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Height;
     Graphic.Draw(Self,rec);
End;

Procedure TCanvas.StretchPartialDraw(X,Y,Width,Height:LongInt;
                                     Const SourceRec:TRect;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}

     rec.Left:=X;
     rec.Right:=X+Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Height;
     Graphic.PartialDraw(Self,SourceRec,rec);
End;

Procedure tCanvas.ChangeColor(Rec : TRect; SearchColor, ReplaceColor : tColor);

Var x,y : Longint;

Begin
  for x:=Rec.Left to Rec.Right do
    for y:=Rec.Bottom to Rec.Top do
      if getPixel(x,y)=SearchColor then
        SetPixel(x,y,ReplaceColor);
End;

{$IFDEF OS2}
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TMatrix Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TMatrix.GetM11:Extended;
Begin
     Result:=FMatrix.fxM11/65536.0;
End;

Procedure TMatrix.SetM11(Const NewValue:Extended);
Begin
     FMatrix.fxM11:=Round(65536*NewValue);
End;

Function TMatrix.GetM12:Extended;
Begin
     Result:=FMatrix.fxM12/65536.0;
End;

Procedure TMatrix.SetM12(Const NewValue:Extended);
Begin
     FMatrix.fxM12:=Round(65536*NewValue);
End;

Function TMatrix.GetM21:Extended;
Begin
     Result:=FMatrix.fxM21/65536.0;
End;

Procedure TMatrix.SetM21(Const NewValue:Extended);
Begin
     FMatrix.fxM21:=Round(65536*NewValue);
End;

Function TMatrix.GetM22:Extended;
Begin
     Result:=FMatrix.fxM22/65536.0;
End;

Procedure TMatrix.SetM22(Const NewValue:Extended);
Begin
     FMatrix.fxM22:=Round(65536*NewValue);
End;

Constructor TMatrix.Create(Const aM11,aM12:Extended;aM13:LongInt;
                           Const aM21,aM22:Extended;aM23:LongInt;
                           Const aM31,aM32,aM33:LongInt);
Begin
     M11:=aM11;
     M12:=aM12;
     M13:=aM13;
     M21:=aM21;
     M22:=aM22;
     M23:=aM23;
     M31:=aM31;
     M32:=aM32;
     M33:=aM33;
End;

Constructor TMatrix.CreateIntern;
Begin
End;

Constructor TMatrix.CreateEmpty;
Begin
     M11:=0.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=0.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=0;
End;

Constructor TMatrix.CreateDefault;
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=0;
End;

Constructor TMatrix.CreateLike(m:TMatrix);
Begin
     Assign(m);
End;

Constructor TMatrix.CreateTranslation(DeltaX,DeltaY:LongInt);
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=DeltaX;
     M32:=DeltaY;
     M33:=1;
End;

Constructor TMatrix.CreateScaling(Const ScalePercentX,ScalePercentY:Extended);
Begin
     M11:=ScalePercentX/100;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=ScalePercentY/100;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateVertReflection;
Begin
     M11:=-1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateHorzReflection;
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=-1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateYShear(Const Shear:Extended);
Begin
     M11:=1.0;
     M12:=Shear;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateXShear(Const Shear:Extended);
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=Shear;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateRotation(Const Degree:Extended);
Begin
     SetTrigMode(Deg);
     M11:=Cos(Degree);
     M12:=Sin(Degree);
     M13:=0;
     M21:=-Sin(Degree);
     M22:=Cos(Degree);
     M23:=0;
     m31:=0;
     m32:=0;
     m33:=1;
End;

Destructor TMatrix.Destroy;
Begin
End;

Procedure TMatrix.Assign(m:TMatrix);
Begin
     FMatrix:=m.FMatrix;
End;

Procedure TMatrix.TransformPoint(Var pt:TPoint);
Var Result:TPoint;
Begin
     Result.X:=Round(M11*pt.X+M21*pt.Y+M31);
     Result.Y:=Round(M12*pt.X+M22*pt.Y+M32);
     pt:=Result;
End;
{$ENDIF}


//unit initalization

Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-02  WD         Ausbau der LINUX-Teile
  25-Dez-03  WD         Unter Win32 die Funktion "Canvas.Rectangle" korrigiert.

  08-Aug-04  AL (Aaron Lawrence, copied by MV) tBitmap.Update rewritten
  08-Aug-04  MV         tMetafile OS/2 implemented, works fine in WSformat (visit www.WriteAndSet.com)
                        and a lot of minor stuff fixed
  15-Sep-04  CW         Korrektur von Tfont.GetWidth.
  03-Okt-04  MV         Einbau von der tFont.CodePage
  03-Nov-04  WD         Ergnzung von tCanvas.Create, damit nicht nur tComponent-Klassen
                        als Owner verwendet werden k”nnen. z.b. tPrinter
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  27-Nov-05  WD         Ermoeglichen, dass ein Icon auch in ein Bitmap geladen werden kann.
  18-Jan-06  WD         Procedure tCanvas.ChangeColor implemented
  08-Feb-06  MD         tFont.Codepage -> tFont.WinCodepage
                        tFont.OS2Codepage sets codepage for OS/2 (z.B.850,1004). Gets active within SetFont
                          default of OS2Codepage is 0
                          Sample:  NewFont := Screen.GetFontFromPointSize(...);
                                   NewFont.OS2Codepage := 1004; //Windows ANSI Codepage
                                   Control.Font := NewFont;
  03-Mai-06  WD         Funktion tBitmap.LoadFromResourceId auf Name-Resourcen umgebaut.
  18-Jul-06  WD         TCanvas.ExcludeClipRect: von RGN_XOR auf RGN_DIFF
     Sep-06  MV         tMetafile.CalculateWidthHeight improved
     Sep-06  MV         ReadSCUFont improved; now in Windows the fonts equal to the ressources for the OS/2 program are chosen
  23-Jun-07  MV         Changes in TCanvas.Arc
  24-Jun-07  WD         TBitmap: Property BitmapMem und BitmapMemLength eingebaut.
  19-Jam-08  MV         Umbau von TBitmap.Draw
}


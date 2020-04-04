Unit COLOR;

Interface

Uses SysUtils;
                      
{$M+}
type
    TColor=LongInt;

    TRGB=Record
           Blue:Byte;
           Green:Byte;
           Red:Byte;
           Fill:Byte;
         End;

const
{ Default RGB color values }
    clAliceblue                = TColor($00f0f8ff);
    clAntiquewhite             = TColor($00faebd7);
    clAqua                     = TColor($0000ffff);
    clAquamaria                = TColor($007fffd4);
    clAzure                    = TColor($00f0ffff);
    clBlack                    = TColor($00000000);
    clBlue                     = TColor($000000ff);
    clBeige                    = TColor($00f5f5dc);
    clBlueViolet               = TColor($008a2be2);
    clBrown                    = TColor($00a52a2a);
    clBurlywood                = TColor($00deb887);
    clCadetblue                = TColor($005f9ea0);
    clChartreuse               = TColor($007fff00);
    clChocolate                = TColor($00d2691e);
    clCoral                    = TColor($00ff7f50);
    clCornflowerblue           = TColor($006495ed);
    clCornsilk                 = TColor($00fff8dc);
    clCrimson                  = TColor($00dc143c);
    clDkBlue                   = TColor($0000008b);
    clDkCyan                   = TColor($00008b8b);
    clDkGoldenrad              = TColor($00b8860b);
    clDkGray                   = TColor($00a9a9a9);
    clDkGreen                  = TColor($00006400);
    clDkKhaki                  = TColor($00bdb76b);
    clDkMagenta                = TColor($008b008b);
    clDkOlivegreen             = TColor($00556b2f);
    clDkOrange                 = TColor($00ff8c00);
    clDkOrchid                 = TColor($009932cc);
    clDkRed                    = TColor($008b0000);
    clDkSalmon                 = TColor($00e9967a);
    clDkSeaGreen               = TColor($008fbc8f);
    clDkSlateBlue              = TColor($00483d8b);
    clDkSlateGray              = TColor($002f4f4f);
    clDkTurqoise               = TColor($0000ced1);
    clDkViolet                 = TColor($009400d3);
    clDeepPink                 = TColor($00ff1493);
    clDeepSkyBlue              = TColor($001e90ff);
    clDimGray                  = TColor($00696969);
    clDodgerBlue               = TColor($001e90ff);
    clFireBrick                = TColor($00b22222);
    clForalWhite               = TColor($00fffaf0);
    clForestGreen              = TColor($00228b22);
    clFuchsia                  = TColor($00ff00ff);
    clGainsBoro                = TColor($00dcdcdc);
    clGhostWhite               = TColor($00f8f8ff);
    clGold                     = TColor($00ffd700);
    clGoldenrod                = TColor($00daa520);
    clGray                     = TColor($00808080);
    clGreen                    = TColor($00008000);
    clGreenYellow              = TColor($00adff2f);
    clHoneydew                 = TColor($00f0fff0);
    clHotPink                  = TColor($00ff69b4);
    clIndianRed                = TColor($00cd5c5c);
    clIndigo                   = TColor($004b0082);
    clIvory                    = TColor($00fffff0);
    clKhaki                    = TColor($00f0e68c);
    clLavender                 = TColor($00e6e6fa);
    clLavenderBlush            = TColor($00fff0f5);
    clLawnGreen                = TColor($007cfc00);
    clLemonchiffon             = TColor($00fffacd);
    clLtBlue                   = TColor($00add8e6);
    clLtCoral                  = TColor($00f08080);
    clLtCyan                   = TColor($00e0ffff);
    clLtGoldenrodyellow        = TColor($00fafad2);
    clLtGreen                  = TColor($0090ee90);
    clLtGray                   = TColor($00d3d3d3);
    clLtPink                   = TColor($00ffb6c1);
    clLtRed                    = tColor($00CC0000);
    clLtMagenta                = tColor($004b004b);
    clLtSalmon                 = TColor($00ffa07a);
    clLtSeaGreen               = TColor($0020b2aa);
    clLtSkyBlue                = TColor($0087cefa);
    clLtSlateGray              = TColor($00778899);
    clLtSteelBlue              = TColor($00b0c4de);
    clLtYellow                 = TColor($00ffffe0);
    clLime                     = TColor($0000ff00);
    clLimeGreen                = TColor($0032cd32);
    clLinen                    = TColor($00faf0e6);
    clMaroon                   = TColor($00800000);
    clMaroonII                 = tColor($008e236b);
    clMediumAquamarina         = TColor($0066cdaa);
    clMediumBlue               = TColor($000000cd);
    clMediumOrchid             = TColor($00ba5593);
    clMediumPurple             = TColor($0009370d);
    clMediumSeaGreen           = TColor($003cb371);
    clMediumSlateBlue          = TColor($007b68ee);
    clMediumSpringGreen        = TColor($003cb371);
    clMediumTurquoise          = TColor($0048d1cc);
    clMediumVioletRed          = TColor($00c71585);
    clMidnightBlue             = TColor($00191970);
    clMintcream                = TColor($00f5fffa);
    clMistyros                 = TColor($00ffe4e1);
    clMoccasin                 = TColor($00ffe4b5);
    clNavajoWhite              = TColor($00ffdead);
    clNavy                     = TColor($00000080);
    clOldLace                  = TColor($00fdf5e6);
    clOlive                    = TColor($00808000);
    clOliveDrab                = TColor($006b8e23);
    clOrange                   = TColor($00ffa500);
    clOrangeRed                = TColor($00ff4500);
    clOrchid                   = TColor($00da70d6);
    clPaleGoldenrod            = TColor($00eee8aa);
    clPaleGreen                = TColor($0098fb98);
    clPaleTurquoiseafeeee      = TColor($00afeeee);
    clPaleVioletRed            = TColor($00db7093);
    clPapayaWhip               = TColor($00ffefd5);
    clPeachPuff                = TColor($00ffdab9);
    clPeru                     = TColor($00cd853f);
    clPink                     = TColor($00ffc0cb);
    clPlum                     = TColor($00dda0dd);
    clPowderBlue               = TColor($00b0e0e6);
    clPurple                   = TColor($00800080);
    clRed                      = TColor($00ff0000);
    clRosyBrown                = TColor($00bc8f8f);
    clRoyalBlue                = TColor($004169e1);
    clSaddleBrown              = TColor($008b4513);
    clSalmon                   = TColor($00fa8072);
    clSandyBrown               = TColor($00f4a460);
    clSeaGreen                 = TColor($002e8b57);
    clSeaShell                 = TColor($00fff5ee);
    clSienna                   = TColor($00a0522d);
    clSilver                   = TColor($00C6C6C6);
    clSkyBlue                  = TColor($0087ceeb);
    clSlateBlue                = TColor($006a5acd);
    clSlateGray                = TColor($00708090);
    clSnow                     = TColor($00fffafa);
    clSpringGreen              = TColor($0000ff7f);
    clSteelBlue                = TColor($004682b4);
    clTan                      = TColor($00d2b48c);
    clTeal                     = TColor($00008080);
    clThstle                   = TColor($00d8bfd8);
    clTomato                   = TColor($00ff6347);
    clTurquoise                = TColor($0040e0d0);
    clViolet                   = TColor($00ee82ee);
    clVioledRed                = tColor($00cc3299);
    clWheat                    = TColor($00f5deb3);
    clWhite                    = TColor($00ffffff);
    clWhitmoke                 = TColor($00f5f5f5);
    clYellow                   = TColor($00ffff00);
    clYellowGreen              = TColor($009acd32);

{ System Colors }
    clScrollbar                = TColor(0 Or $80000000);
    clBackGround               = TColor(1 Or $80000000);
    clActiveCaption            = TColor(2 Or $80000000);
    clInactiveCaption          = TColor(3 Or $80000000);
    clMenu                     = TColor(4 Or $80000000);
    clWindow                   = TColor(5 Or $80000000);
    clWindowFrame              = TColor(6 Or $80000000);
    clMenuText                 = TColor(7 Or $80000000);
    clWindowText               = TColor(8 Or $80000000);
    clCaptionText              = TColor(9 Or $80000000);
    clActiveBorder             = TColor(10 Or $80000000);
    clInactiveBorder           = TColor(11 Or $80000000);
    clAppWorkSpace             = TColor(12 Or $80000000);
    clHighlight                = TColor(13 Or $80000000);
    clHighlightText            = TColor(14 Or $80000000);
    clBtnFace                  = TColor(15 Or $80000000);
    clBtnShadow                = TColor(16 Or $80000000);
    clGrayText                 = TColor(17 Or $80000000);
    clBtnText                  = TColor(18 Or $80000000);
    clInactiveCaptionText      = TColor(19 Or $80000000);
    clBtnHighlight             = TColor(20 Or $80000000);
    cl3DDkShadow               = TColor(21 Or $80000000);
    cl3DLight                  = TColor(22 Or $80000000);
    clInfoText                 = TColor(23 Or $80000000);
    clInfo                     = TColor(24 Or $80000000);
    clBtnDefault               = TColor(25 Or $80000000);
    clDlgWindow                = TColor(26 Or $80000000);
    clEntryField               = TColor(27 Or $80000000);
    clStaticText               = TColor(28 Or $80000000);
{$M-}

// TransparentColor
    clTCNotDefined             = tColor(-1);

Type
    TColorName = Record
         Name: String[20];
         Value: LongInt;
    End;

Const
    MaxDefaultColors = 18;
    DefaultColors: Array[1..MaxDefaultColors] Of TColorName = (
         (Name:'clBlack'; Value:clBlack),
         (Name:'clMaroon'; Value:clMaroon),
         (Name:'clGreen'; Value:clGreen),
         (Name:'clOlive'; Value:clOlive),
         (Name:'clNavy'; Value:clNavy),
         (Name:'clPurple'; Value:clPurple),
         (Name:'clTeal'; Value:clTeal),
         (Name:'clGray'; Value:clGray),
         (Name:'clSilver'; Value:clSilver),
         (Name:'clRed'; Value:clRed),
         (Name:'clLime'; Value:clLime),
         (Name:'clYellow'; Value:clYellow),
         (Name:'clBlue'; Value:clBlue),
         (Name:'clFuchsia'; Value:clFuchsia),
         (Name:'clAqua'; Value:clAqua),
         (Name:'clLtGray'; Value:clLtGray),
         (Name:'clDkGray'; Value:clDkGray),
         (Name:'clWhite'; Value:clWhite));

    MaxSystemColors = 29;
    SystemColors: Array[1..MaxSystemColors] Of TColorName = (
         (Name:'clScrollbar'; Value:clScrollbar),
         (Name:'clBackGround'; Value:clBackGround),
         (Name:'clActiveCaption'; Value:clActiveCaption),
         (Name:'clInactiveCaption'; Value:clInactiveCaption),
         (Name:'clMenu'; Value:clMenu),
         (Name:'clWindow'; Value:clWindow),
         (Name:'clWindowFrame'; Value:clWindowFrame),
         (Name:'clMenuText'; Value:clMenuText),
         (Name:'clWindowText'; Value:clWindowText),
         (Name:'clCaptionText'; Value:clCaptionText),
         (Name:'clActiveBorder'; Value:clActiveBorder),
         (Name:'clInactiveBorder'; Value:clInactiveBorder),
         (Name:'clAppWorkSpace'; Value:clAppWorkSpace),
         (Name:'clHighLight'; Value:clHighlight),
         (Name:'clHighLightText'; Value:clHighlightText),
         (Name:'clBtnFace'; Value:clBtnFace),
         (Name:'clBtnShadow'; Value:clBtnShadow),
         (Name:'clGrayText'; Value:clGrayText),
         (Name:'clBtnText'; Value:clBtnText),
         (Name:'clInactiveCaptionText'; Value:clInactiveCaptionText),
         (Name:'clBtnHighlight'; Value:clBtnHighlight),
         (Name:'cl3DDkShadow'; Value:cl3DDkShadow),
         (Name:'cl3DLight'; Value:cl3DLight),
         (Name:'clInfoText'; Value:clInfoText),
         (Name:'clInfo'; Value:clInfo),
         (Name:'clBtnDefault'; Value:clBtnDefault),
         (Name:'clDlgWindow'; Value:clDlgWindow),
         (Name:'clEntryField'; Value:clEntryField),
         (Name:'clStaticText'; Value:clStaticText));


Function ColorName(ColorValue:TColor):String;
Function ColorValue(ColorName:String):TColor;
Procedure RGBToHSV(C: TColor; Var Hue: longint; Var Saturation, Value: real);
Function HSVToRGB( const H: longint; const S, V: real ):TColor;


{ Von Sybil-Team definiert }
{    clBlack                    = TColor($00000000);
    clMaroon                   = TColor($00800000);
    clGreen                    = TColor($00008000);
    clOlive                    = TColor($00808000);
    clNavy                     = TColor($00000080);
    clPurple                   = TColor($00800080);
    clTeal                     = TColor($00008080);
    clGray                     = TColor($00808080);
    clSilver                   = TColor($00C6C6C6);
    clRed                      = TColor($00FF0000);
    clLime                     = TColor($0000FF00);
    clYellow                   = TColor($00FFFF00);
    clBlue                     = TColor($000000FF);
    clFuchsia                  = TColor($00FF00FF);
    clAqua                     = TColor($0000FFFF);
    clLtGray                   = TColor($00CCCCCC);
    clDkGray                   = TColor($00808080);
    clWhite                    = TColor($00FFFFFF);
    clOrange                   = TColor($00FFA756);  }

Implementation

Function ColorName(ColorValue:TColor):String;
Var  T:LongInt;
Begin
  For T := 1 To MaxDefaultColors Do
    If DefaultColors[T].Value = ColorValue Then
      Begin
        Result := DefaultColors[T].Name;
        Exit;
      End;

  For T := 1 To MaxSystemColors Do
    If SystemColors[T].Value = ColorValue Then
      Begin
        Result := SystemColors[T].Name;
        Exit;
      End;

  Result := tostr(ColorValue);
End;


Function ColorValue(ColorName:String):TColor;
Var  T:LongInt;
     C:Integer;
     S:String;
Begin
  UpcaseStr(ColorName);

  For T := 1 To MaxDefaultColors Do
    Begin
      S := DefaultColors[T].Name;
      UpcaseStr(S);
      If S = ColorName Then
        Begin
          Result := DefaultColors[T].Value;
          Exit;
        End;
    End;

  For T := 1 To MaxSystemColors Do
    Begin
      S := SystemColors[T].Name;
      UpcaseStr(S);
      If S = ColorName Then
        Begin
          Result := SystemColors[T].Value;
          Exit;
        End;
    End;

  Val(ColorName,Result,C);
  If C <> 0 Then Result := 0;
End;


Procedure RGBToHSV(C: TColor; Var Hue: longint; Var Saturation, Value: real);

Var r,g,b: longint;
    hi, lo: longint;
    d: longint;

Begin
  r:= (c div 65536) and 255;
  g:= (c div 256) and 255;
  b:=  c and 255;
  hi:= maxLI( maxLI( r, g ), b );
  lo:= minLI( minLI( r, g ), b );
  d:= hi-lo;
  Value:= hi/256;
  if d>0 then
  begin
    if r=hi then
      Hue:= 256*(g-b)/d
    else if g=hi then
      Hue:= 512+256*(b-r)/d
    else
      Hue:= 1024+256*(r-g)/d;
    if Hue<0 then
      Hue:= Hue+1536;
  end
  else
    Hue:= 0; // doesn't matter (grey: Sat = 0)

  if hi>0 then
    Saturation:= d/hi
  else
    Saturation:= 0; // doesn't matter (black: Val = 0
End;

Function HSVToRGB( const H: longint; const S, V: real ):TColor;

Var r,g,b: longint;

Begin
  if ( h<0 ) or ( h>1535 )
     or ( S<0 ) or ( S>1 )
     or ( V<0 ) or ( V>1 ) then
  begin
    // Invalid value, use black
    Result:= 0;
    exit;
  end;
  case h div 256 of
  0:
   begin
    r:= 255;
    g:= h;
    b:= 0;
   end;
  1:
   begin
    r:= 511-h;
    g:= 255;
    b:= 0;
   end;
  2:
   begin
    r:= 0;
    g:= 255;
    b:= h-512;
   end;
  3:
   begin
    r:= 0;
    g:= 1023-h;
    b:= 255;
   end;
  4:
   begin
    r:= h-1024;
    g:= 0;
    b:= 255;
   end;
  5:
   begin
    r:= 255;
    g:= 0;
    b:= 1535-h;
   end;
  end;
  r:= V*( 255- S*(255-r) );
  g:= V*( 255- S*(255-g) );
  b:= V*( 255- S*(255-b) );
  Result:= b + 256*g + 65536*r;
end;


Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  10-Jun-04  AL/WD         Die Funktionen von Aaron Lawrence RGBToHSV und HSVtoRGB eingebaut


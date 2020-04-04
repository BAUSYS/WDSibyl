Unit uColorWheel;

Interface

Uses Classes, Forms, Graphics, Color;

{ WD: Diese Komponente gehoehrt noch fuer Windows umprogrammiert }

{$IFDEF OS2}
Type
  TValueBar=Class;

  TColorWheel=Class( TControl )
  Protected
    FValueBar: TValueBar;
    FHue: longint;
    FSaturation: real;
    FCursorDrawn: boolean;
    FOldCursorX, FOldCursorY: longint;
    FOldCursorSize: longint;
    FMarginWidth: longint;
    FCursorSize: longint;
    FWhiteAreaPercent: longint; // 0 to 50 percent of circle radius that is pure white
    FOnChange: TNotifyEvent;

    Procedure SetupComponent; Override;
    Procedure SetupShow; Override;
    Procedure HSFromPoint( X, Y: longint;
                           Var H: longint;
                           Var S: real );
    Procedure DrawCursor;

    Procedure Resize; override;
    Procedure SetMarginWidth( NewWidth: longint );
    Procedure SetCursorSize( NewSize: longint );
    Procedure SetValueBar( ValueBar: TValueBar );
    Procedure SetWhiteAreaPercent( WhiteAreaPercent: longint );
    Procedure Notification(AComponent:TComponent;Operation:TOperation); override;

    Function DrawWidth: longint;
    Function DrawHeight: longint;

    Procedure MouseDown( Button: TMouseButton;
                         ShiftState: TShiftState;
                         X, Y: Longint ); Override;
    Procedure MouseMove( ShiftState: TShiftState;
                         X, Y: Longint ); Override;
    Procedure MouseUp( Button: TMouseButton;
                       ShiftState: TShiftState;
                       X, Y: Longint ); Override;
    Procedure Change;
    Property OnCloseQuery; // hide it
  Public
    Destructor Destroy; Override;
    Procedure Redraw( const rec: Trect ); override;
    Property Hue: longint read FHue;
    Property Saturation: real read FSaturation;
    Procedure SetSelectedColor( const NewColor: TColor );
  Published
    Property Color;
    Property ParentColor;
    Property ValueBar: TValueBar read FValueBar write SetValueBar;

    Property MarginWidth: longint read FMarginWidth write SetMarginWidth;
    Property CursorSize: longint read FCursorSize write SetCursorSize;
    Property ZOrder;
    Property WhiteAreaPercent: longint read FWhiteAreaPercent write SetWhiteAreaPercent;

    Property OnChange: TNotifyEvent read FOnChange write FOnChange;
  End;

  TValueBar=Class( TControl )
  Protected
    FColorWheel: TColorWheel;
    FHue: longint;
    FSaturation: real;
    FValue: real;
    FCursorDrawn: boolean;
    FOldCursorY: longint;
    FMarginWidth: longint;
    FCursorHeight: longint;
    FOnChange: TNotifyEvent;
    FDither: boolean;

    Procedure SetupComponent; Override;
    Procedure SetupShow; Override;
    Procedure DrawCursor;

    Procedure Resize; override;
    Procedure SetMarginWidth( NewWidth: longint );
    Procedure SetValue( Value: real );
    Procedure SetDither( Dither: boolean );
    Procedure SetCursorHeight( CursorHeight: longint );

    Function GetSelectedColor: TColor;

    Procedure Change;

    Function DrawWidth: longint;
    Function DrawHeight: longint;

    Procedure MouseDown( Button: TMouseButton;
                         ShiftState: TShiftState;
                         X, Y: Longint ); Override;
    Procedure MouseMove( ShiftState: TShiftState;
                         X, Y: Longint ); Override;
    Procedure MouseUp( Button: TMouseButton;
                       ShiftState: TShiftState;
                       X, Y: Longint ); Override;
    Function ValueFromY( Y: longint ): real;
    Procedure DrawLine( Y: longint );
    Property OnCloseQuery; // hide it
  Public
    Destructor Destroy; Override;
    Procedure Redraw( const rec: Trect ); override;
    Procedure SetHS( Hue: longint; Sat: real );
  Published
    Property Color;
    Property ParentColor;
    Property Value: real read FValue write SetValue;
    Property SelectedColor: TColor read GetSelectedColor;

    property Dither: boolean read FDither write SetDither;

    Property MarginWidth: longint read FMarginWidth write SetMarginWidth;
    Property CursorHeight: longint read FCursorHeight write SetCursorHeight;
    Property ZOrder;

    Property OnChange: TNotifyEvent read FOnChange write FOnChange;
  End;


Function InsertValueBar(iParent       : TControl;
                        iLeft, iBottom, iWidth, iHeight : LongInt;
                        iHint         : String) : tColorWheel;

Function InsertColorWheel(iParent       : TControl;
                          iLeft, iBottom, iWidth, iHeight : LongInt;
                          iValueBar     : TValueBar;
                          iHint         : String) : tColorWheel;


{$ENDIF OS2}

Implementation

{$IFDEF OS2}
Uses PMGPI;

Function InsertValueBar(iParent       : TControl;
                        iLeft, iBottom, iWidth, iHeight : LongInt;
                        iHint         : String) : tColorWheel;

Begin
  Result.Create(iParent);
  Result.SetWindowPos(iLeft, iBottom, iWidth, iHeight);
  Result.Hint    := iHint;
  Result.Parent  := iParent;
End;

Function InsertColorWheel(iParent       : TControl;
                          iLeft, iBottom, iWidth, iHeight : LongInt;
                          iValueBar     : TValueBar;
                          iHint         : String) : tColorWheel;

Begin
  Result.Create(iParent);
  Result.SetWindowPos(iLeft, iBottom, iWidth, iHeight);
  Result.Hint    := iHint;
  Result.ValueBar:= iValueBar;
  Result.Parent  := iParent;
End;



Const RadToHue: real = 1536/(2*pi);

Procedure TColorWheel.SetupComponent;
Begin
  Inherited SetupComponent;
  FMarginWidth:= 5;
  FCursorSize:= 5;
  Width:= 100;
  Height:= 100;
  Name:= 'ColorWheel';
  ParentColor:= True;
  Exclude(ComponentState, csAcceptsControls);
  FWhiteAreaPercent:= 10;
End;

Procedure TColorWheel.SetupShow;
Begin
  Inherited SetupShow;
End;

Destructor TColorWheel.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TColorWheel.ReDraw( const rec: Trect );
Var
 x,y : longint;
 Hue: longint;
 saturation: real;
 c: tcolor;
 r: TRect;
Begin
  Canvas.ClipRect:= rec;
  // clear background rectangle
  Canvas.FillRect( rec, Color );

  if ( Width < MarginWidth * 2 ) or
    ( Height < MarginWidth * 2 ) then
    // margins too big
    exit;

{  Bugger there is a bug in Arc - it starts drawing
   from last position
  Canvas.Pen.Color:= clBtnHighlight;
  Canvas.Arc( Width div 2, Height div 2,
              DrawWidth div 2 + 1, DrawHeight div 2 + 1,
              45, 180 );
  Canvas.Pen.Color:= clBtnShadow;
  Canvas.Arc( Width div 2, Height div 2,
              DrawWidth div 2 + 1, DrawHeight div 2 + 1,
              225, 180 );}

  if Designed then
  begin
    // When designing, don't draw colors
    // but draw an outline
    Canvas.Pen.Style:= psDash;
    r.Left:= 0;
    r.Right:= Width - 1;
    r.Bottom:= 0;
    r.Top:= Height - 1;
    Canvas.Rectangle( r );
    Canvas.Ellipse( Width div 2, Height div 2,
                    DrawWidth div 2 + 1, DrawHeight div 2 + 1 );
    exit;
  end;

  if ( Width < MarginWidth * 2 ) or ( Height < MarginWIdth * 2 ) then
    exit;

  // scan all potential pixels and draw points on the wheel
  for X:=0 to DrawWidth-1 do
  begin
    for Y:=0 to DrawHeight-1 do
    begin
      // work out hue and saturation for point
      HSFromPoint( X, Y, Hue, Saturation );
      if Saturation<=1.0 then
      begin
        // point is within wheel
        C:= HSVToRGB( Hue, Saturation, 1.0 );
        // draw the pixel
        Canvas.Pixels[ X+FMarginWidth, Y+FMarginWidth ]:= C;
      end;
    end;
  end;

  FCursorDrawn:= false; // make cursor draw without erasing first
  DrawCursor;
  Canvas.DeleteClipRegion;
End;

Function TColorWheel.DrawWidth: longint;
Begin
  Result:= Width - FMarginWidth*2;
End;

Function TColorWheel.DrawHeight: longint;
Begin
  Result:= Height - FMarginWidth*2;
End;

Procedure TColorWheel.SetSelectedColor( const NewColor: TColor );
Var
  Value: real;
Begin
  RGBToHSV( NewColor, FHue, FSaturation, Value );
  Change;
  if FValueBar<>nil then
    FValueBar.Value:= Value;
End;

Procedure TColorWheel.Change;
Var
  C: TColor;
  H: longint;
  S, V: real;
Begin
  DrawCursor;
  C:= HSVToRGB( FHue, FSaturation, 1.0 );
  RGBToHSV( C, H, S, V );
  if FValueBar<>nil then
    FValueBar.SetHS( H, S );
  if FOnChange <> nil then
    FOnChange( self );
End;

Function AngleFrom( x, y: real ): real;
//
//     1|0
//   ---+----
//     2|3
Begin
  if X = 0 then
  begin
    if Y > 0 then
      Result:= pi/2
    else
      Result:= 3*pi/2;
  end
  else
  begin
    Result:= arctan( abs( y ) / abs( x ) );
    if ( x < 0 ) and ( y>=0 ) then
      // quadrant 1
      Result:= pi-Result
    else if ( x < 0 ) and ( y<0 ) then
      // quadrant 2
      Result:= Result+pi
    else if ( x >= 0 ) and ( y<0 ) then
      // quadrant 3
      Result:= 2*pi-Result;
  end;
end;

// Calculate hue and saturation for a given point in the color wheel
Procedure TColorWheel.HSFromPoint( X, Y: longint;
                                   Var H: longint;
                                   Var S: real );
Var
  xp, yp: real;
  halfw, halfh: longint;
Begin
  halfw:= DrawWidth div 2;
  halfh:= DrawHeight div 2;
  xp:= ( x- halfw )/halfw; // x as -1..1
  yp:= ( y- halfh )/halfh; // y as -1..1
  H:= RadToHue * AngleFrom( xp, yp );
  S:= sqrt( xp*xp+yp*yp );
  // scale saturation and limit to white, for white area
  S:= S * ( 1 + ( FWhiteAreaPercent / 100.0 ) ) - ( FWhiteAreaPercent / 100.0 );
  if S < 0 then
    S:= 0;
end;

Procedure TColorWheel.DrawCursor;
Var
  Angle: real;
  X, Y: longint;
  OldMode: TPenMode;
  S: real;
Begin
  if Handle = 0 then
    exit;

  if ( Width < MarginWidth * 2 ) or
     ( Height < MarginWidth * 2 ) then
    exit;

  Canvas.Pen.Width:= 2;

  Angle:= FHue/RadToHue;

  // Scale distance from centre for white area
  S:= FSaturation;
  if S > 0 then
    S:= S * ( 1 - ( FWhiteAreaPercent / 100.0 ) ) + ( FWhiteAreaPercent / 100.0 );

  // work out point for selected hue and saturation
  X:= Width div 2+cos( Angle )*S* ( DrawWidth div 2 );
  Y:= Height div 2+sin( Angle )*S* ( DrawHeight div 2 );

  OldMode:= Canvas.Pen.Mode;
  Canvas.Pen.Mode:= pmNot; // invert pixels
  if FCursorDrawn then
  begin
    // erase
    Canvas.Line( FOldCursorX-FOldCursorSize, FOldCursorY,
                 FOldCursorX+FOldCursorSize, FOldCursorY );
    Canvas.Line( FOldCursorX, FOldCursorY-FOldCursorSize,
                 FOldCursorX, FOldCursorY+FOldCursorSize );
  end;

  // draw cursor
  Canvas.Line( X-FCursorSize, Y,
               X+FCursorSize, Y );
  Canvas.Line( X, Y-FCursorSize,
               X, Y+FCursorSize );
  FOldCursorX:= X;
  FOldCursorY:= Y;
  FOldCursorSize:= FCursorSize;
  FCursorDrawn:= true;
  Canvas.Pen.Mode:= OldMode;
End;

Procedure TColorWheel.Resize;
Begin
  Invalidate;
End;

Procedure TColorWheel.SetMarginWidth( NewWidth: longint );
Begin
  FMarginWidth:= NewWidth;
  if Handle = 0 then
    exit;
  Invalidate;
End;

Procedure TColorWheel.SetCursorSize( NewSize: longint );
Begin
  FCursorSize:= NewSize;
  if Handle = 0 then
    exit;
  DrawCursor;
End;

Procedure TColorWheel.SetValueBar( ValueBar: TValueBar );
Begin
  if FValueBar<>nil then
    // tell the old value bar it's no longer controlled by this wheel
    FValueBar.FColorWheel:= nil;
  FValueBar:= ValueBar;
  if FValueBar<>nil then
  begin
    // Tell value bar it is controlled by this component
    FValueBar.FColorWheel:= Self;
    // request notification when other is freed
    FValueBar.FreeNotification(Self);
  end;

End;

Procedure TColorWheel.SetWhiteAreaPercent( WhiteAreaPercent: longint );
begin
  if WhiteAreaPercent > 50 then
    WhiteAreaPercent:= 50;

  if WhiteAreaPercent < 0 then
    WhiteAreaPercent:= 0;

  FWhiteAreaPercent:= WhiteAreaPercent;

  Invalidate;
end;

Procedure TColorWheel.Notification(AComponent:TComponent;Operation:TOperation);
Begin
  Inherited Notification(AComponent,Operation);
  If Operation = opRemove Then
  Begin
    If AComponent = FValueBar Then
      FValueBar:= Nil;
  end;
end;

Procedure TColorWheel.MouseDown( Button: TMouseButton;
                                 ShiftState: TShiftState;
                                 X, Y: Longint );
Begin
  dec( X, FMarginWidth );
  dec( Y, FMarginWidth );
  HSFromPoint( X, Y, FHue, FSaturation );
  if FSaturation>1.0 then
    FSaturation:= 1.0;
  Change;
  MouseCapture:= True;
End;

Procedure TColorWheel.MouseMove( ShiftState: TShiftState;
                                 X, Y: Longint );
Begin
  if not MouseCapture then
    exit;
  dec( X, FMarginWidth );
  dec( Y, FMarginWidth );
  HSFromPoint( X, Y, FHue, FSaturation );
  if FSaturation>1.0 then
    FSaturation:= 1.0;
  Change;
End;

Procedure TColorWheel.MouseUp( Button: TMouseButton;
                               ShiftState: TShiftState;
                               X, Y: Longint );
Begin
  if not MouseCapture then
    exit;
  MouseCapture:= false;
End;

// --------------------------------
// Value bar

Procedure TValueBar.SetupComponent;
Begin
  Inherited SetupComponent;
  FMarginWidth:= 5;
  Width:= 100;
  Height:= 100;
  Name:= 'ValueBar';
  ParentColor:= True;
  Exclude(ComponentState, csAcceptsControls);
  FDither:= false;
  FCursorHeight:= 10;
End;

Procedure TValueBar.SetupShow;
Begin
  Inherited SetupShow;
End;

Destructor TValueBar.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TValueBar.DrawLine( Y: longint );
var
 DrawVal: real;
 c: tcolor;
 r: TRect;
begin
  DrawVal:= ValueFromY( Y );

  C:= HSVToRGB( FHue, FSaturation, DrawVal );

  if FDither then
  begin
    // draw using fillrect, which will dither
    r.left:= FMarginWidth;
    r.bottom:= Y;
    r.Right:= Width-FMarginWidth;
    r.top:= Y;

    Canvas.FillRect( r, C );
  end
  else
  begin
    // draw using line, which will not dither
    Canvas.Pen.Color:= C;
    Canvas.Line( FMarginWidth, Y ,
                 Width-FMarginWidth-1, Y );
  end;
end;

Procedure TValueBar.ReDraw( const rec: Trect );
Var
 y : longint;
 r: TRect;
Begin
  Canvas.ClipRect:= rec;
  if Designed then
  begin
    // when designing just drwa
    // a rectangle to indicate
    Canvas.FillRect( rec, Color );
    Canvas.Pen.Style:= psDash;
    r.Left:= 0;
    r.Right:= Width - 1;
    r.Bottom:= 0;
    r.Top:= Height - 1;
    Canvas.Rectangle( r );
    if ( Width < MarginWidth * 2 ) or
       ( Height < MarginWidth * 2 ) then
      exit;
    r.left:= FMarginWidth;
    r.top:= Height - FMarginWidth - 1;
    r.right:= Width - FMarginWidth;
    r.bottom:= FMarginWidth;
    Canvas.Rectangle( r );
    exit;
  end;

  // Draw margins
  r.left:=0;
  r.bottom:=0;
  r.right:= FMarginWidth-1;
  r.top:= Height-1;
  Canvas.FillRect( r, Color ); // left
  r.left:= Width-FMarginWidth;
  r.right:= Width-1;
  Canvas.FillRect( r, Color ); // right

  r.left:= FMarginWidth;
  r.right:=Width-FMarginWidth - 1;
  r.bottom:= Height - FMarginWidth;
  r.top:= Height - 1;
  Canvas.FillRect( r, Color ); // top
  r.bottom:= 0;
  r.top:= FMarginWidth - 1;
  Canvas.FillRect( r, Color ); // bottom

  if ( Width < MarginWidth * 2 ) or
     ( Height < MarginWidth * 2 ) then
    exit;

  for Y:=0 to DrawHeight - 1 do
    DrawLine( Y + FMarginWidth );

  FCursorDrawn:= false;
  DrawCursor;
  Canvas.DeleteClipRegion;
End;

Procedure TValueBar.SetHS( Hue: longint; Sat: real );
Begin
  FHue:= Hue;
  FSaturation:= Sat;
  Invalidate;
  Change;
End;

Procedure TValueBar.SetValue( Value: real );
Begin
  FValue:= Value;
  Change;
End;

Function TValueBar.DrawWidth: longint;
Begin
  Result:= Width - FMarginWidth*2;
End;

Function TValueBar.DrawHeight: longint;
Begin
  Result:= Height - FMarginWidth*2;
End;

Procedure TValueBar.DrawCursor;
Var
  Y: longint;
  OldMode: TPenMode;
  r: TRect;
Begin
  if Handle = 0 then
    exit;
  if ( Width < MarginWidth * 2 ) or
     ( Height < MarginWidth * 2 ) then
    exit;

  if FCursorDrawn then
  begin
    // erase
    // redraw margins
    r.left:= 0;
    r.right:= FMarginWidth - 1;
    r.top:= FOldCursorY + FCursorHeight div 2;
    r.bottom:= FOldCursorY - FCursorHeight div 2;
    Canvas.FillRect( r, Color ); // left
    r.left:= Width - FMarginWidth;
    r.right:= Width - 1;
    Canvas.FillRect( r, Color ); // left
    for Y:= r.bottom to r.top do
      if ( Y < FMarginWidth ) or ( Y >= ( Height - FMarginWidth ) ) then
      begin
        // top/ bottom margin
        Canvas.Pen.Color:= Color;
        Canvas.Line( FMarginWidth, Y, Width - FMarginWidth - 1, Y );
      end
      else
        DrawLine( Y );
  end;

  Y:= FValue * ( DrawHeight-1 ) + FMarginWidth ;

  r.left:= FMarginWidth;
  r.right:= Width - FMarginWidth - 1;
  r.top:= Y + FCursorHeight div 2;
  r.bottom:= Y - FCursorHeight div 2;
  Canvas.FillRect( r, GetSelectedColor );
  Canvas.Pen.Color:= clBlack;
  Canvas.ShadowedBorder( r, clBtnHighlight, clBtnShadow );

  FOldCursorY:= Y;
  FCursorDrawn:= true;
//  Canvas.Pen.Mode:= OldMode;
End;

Procedure TValueBar.Resize;
Begin
  if Handle = 0 then
    exit;
  Invalidate;
End;

Procedure TValueBar.SetMarginWidth( NewWidth: longint );
Begin
  if MarginWidth<0 then
    MarginWidth:= 0;
  FMarginWidth:= NewWidth;
  Invalidate;
End;

Procedure TValueBar.SetDither( Dither: boolean );
Begin
  FDither:= Dither;
  Invalidate;
End;

Procedure TValueBar.SetCursorHeight( CursorHeight: longint );
begin
  if CursorHeight < 3 then
    CursorHeight:= 3;
  FCursorHeight:= CursorHeight;
  Invalidate;
end;

Function TValueBar.GetSelectedColor: TColor;
Begin
  Result:= HSVToRGB( FHue, FSaturation, FValue );
  if not FDither then
    Result:= GpiQueryNearestColor( Screen.Canvas.Handle,
                                   0,
                                   Result );
End;

Function TValueBar.ValueFromY( Y: longint ): real;
begin
  Result:= ( Y-MarginWidth )/( DrawHeight-1 );
  if Result<0 then
    Result:= 0;
  if Result>1.0 then
    Result:= 1.0;

end;

Procedure TValueBar.MouseDown( Button: TMouseButton;
                               ShiftState: TShiftState;
                               X, Y: Longint );
Begin
  FValue:= ValueFromY( Y );
  Change;
  MouseCapture:= True;
End;

Procedure TValueBar.MouseMove( ShiftState: TShiftState;
                                 X, Y: Longint );
Begin
  if not MouseCapture then
    exit;
  FValue:= ValueFromY( Y );
  Change;
End;

Procedure TValueBar.MouseUp( Button: TMouseButton;
                               ShiftState: TShiftState;
                               X, Y: Longint );
Begin
  if not MouseCapture then
    exit;
  MouseCapture:= false;
End;

Procedure TValueBar.Change;
begin
  DrawCursor;
  if FOnChange <> nil then FOnChange(self);
end;
{$ENDIF OS2}

Initialization
{$IFDEF OS2}
  RegisterClasses([TColorWheel, TValueBar]);
{$ENDIF OS2}
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  18-Jul-99  AL         Original Komponente ColorWheel.pas/tColorWheel von Hr. Aaron Lawrence
  10-Jun-04  WD         Einbau der Komponente in WDSibyl; Umbenennen der Datei auf uColorWheel.
  12-Jun-04  WD         Einbau der Insert-Befehle
}

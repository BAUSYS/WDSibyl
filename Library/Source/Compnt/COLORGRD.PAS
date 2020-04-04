
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ColorGrd;

Interface

Uses
  Color,Classes,Forms,StdCtrls;

Type
  TGridOrdering=(go16x1, go8x2, go4x4, go2x8, go1x16);

  TColorGrid=Class(TValueSet)
    Private
       FClickEnablesColor:Boolean;
       FGridOrdering:TGridOrdering;
       FForegroundIndex:LongInt;
       FBackgroundIndex:LongInt;
       FForegroundEnabled:Boolean;
       FBackgroundEnabled:Boolean;
       Procedure SetGridOrdering(Value:TGridOrdering);
       Procedure SetForegroundIndex(Value:LongInt);
       Procedure SetBackgroundIndex(Value:LongInt);
       Procedure EnableForeground(Value:Boolean);
       Procedure EnableBackground(Value:Boolean);
       Function GetBackgroundColor:TColor;
       Procedure SetBackgroundColor(NewValue:TColor);
       Function GetForegroundColor:TColor;
       Procedure SetForegroundColor(NewValue:TColor);
    Protected
       Procedure SetupComponent;Override;
       Procedure DrawSelection(Index:LongInt);Override;
       Procedure DrawInterior(Index:LongInt);Override;
       Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
       Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
       Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
       Property AutoSize;
       Property color;
       Property Bitmaps;
       Property BorderStyle;
       Property ColCount;
       Property ContentStyle;
       Property Ctl3D;
       Property Font;
       Property ItemBorder;
       Property ItemHeight;
       Property ItemWidth;
       Property ParentColor;
       Property ParentFont;
       Property ParentPenColor;
       Property PenColor;
       Property RowCount;
       Property ScaleBitmap;
       Property ScrollBars;
       Property Strings;
       Property XAlign;
       Property XStretch;
       Property YAlign;
       Property YStretch;
       Property OnFontChange;
    Published
       Property Align;
       Property BackgroundEnabled:Boolean Read FBackgroundEnabled Write EnableBackground;
       Property BackgroundIndex:LongInt Read FBackgroundIndex Write SetBackgroundIndex;
       Property BackgroundColor:TColor read GetBackgroundColor Write SetBackgroundColor;
       Property ClickEnablesColor:Boolean Read FClickEnablesColor Write FClickEnablesColor;
       Property DragCursor;
       Property DragMode;
       Property Enabled;
       Property ForegroundEnabled:Boolean Read FForegroundEnabled Write EnableForeground;
       Property ForegroundIndex:LongInt Read FForegroundIndex Write SetForegroundIndex;
       Property ForegroundColor:TColor read GetForegroundColor Write SetForegroundColor;
       Property GridOrdering:TGridOrdering Read FGridOrdering Write SetGridOrdering;
       Property ParentShowHint;
       Property Selection;
       Property ShowHint;
       Property TabOrder;
       Property TabStop;
       Property Visible;
       Property ZOrder;

       Property OnCanDrag;
       Property OnDragDrop;
       Property OnDragOver;
       Property OnEndDrag;
       Property OnEnter;
       Property OnExit;
       Property OnItemFocus;
       Property OnItemSelect;
       Property OnMouseClick;
       Property OnMouseDblClick;
       Property OnMouseDown;
       Property OnMouseMove;
       Property OnMouseUp;
       Property OnScan;
       Property OnSetupShow;
       Property OnStartDrag;
  End;


Function InsertColorGrid(parent:TControl;Left,Bottom,Width,Height:LongInt;
  GridOrdering:TGridOrdering):TColorGrid;


Implementation

Function InsertColorGrid(parent:TControl;Left,Bottom,Width,Height:LongInt;
  GridOrdering:TGridOrdering):TColorGrid;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.GridOrdering := GridOrdering;
  Result.parent := parent;
End;



Const
  BasicColors:Array[0..15] Of TColor =
    (clBlack,clMaroon,clGreen,clOlive,clNavy,clPurple,clTeal,clRed,clLime,
     clYellow,clBlue,clFuchsia,clAqua,clLtGray,clDkGray,clWhite);

Function TColorGrid.GetBackgroundColor:TColor;
Begin
   Result:=BasicColors[BackgroundIndex];
End;

Procedure TColorGrid.SetBackgroundColor(NewValue:TColor);
Var t:LongInt;
Begin
   For t:=0 To 15 Do
     If BasicColors[t]=NewValue Then
       BackgroundIndex:=t;
End;

Function TColorGrid.GetForegroundColor:TColor;
Begin
   Result:=BasicColors[ForegroundIndex];
End;

Procedure TColorGrid.SetForegroundColor(NewValue:TColor);
Var t:LongInt;
Begin
   For t:=0 To 15 Do
     If BasicColors[t]=NewValue Then
       ForegroundIndex:=t;
End;

Procedure TColorGrid.SetupComponent;
Begin
  Inherited SetupComponent;

  Font := Screen.SmallFont;
  Width := 120;
  Height := 120;
  Margin := 0;
  Spacing := 3;
  AutoSize := True;
  ContentStyle := vscRGBColor;
  BorderStyle := bsNone;
  ItemBorder := bsSingle;
  Ctl3D := True;
  GridOrdering := go4x4;
  FClickEnablesColor := False;
  FForegroundIndex := 0;
  FBackgroundIndex := 0;
  FForegroundEnabled := True;
  FBackgroundEnabled := True;
  Exclude(ComponentState, csAcceptsControls);
End;


Procedure TColorGrid.DrawSelection(Index:LongInt);
Begin
  {Nothing To Do}
End;


Procedure TColorGrid.DrawInterior(Index:LongInt);
Var
  rc:TRect;
  X,Y,CX,CY:LongInt;
  S:String;
Begin
  Inherited DrawInterior(Index);

  S := '';
  If (FForegroundIndex = Index) And FForegroundEnabled Then
  Begin
    If (FBackgroundIndex = Index) And FBackgroundEnabled Then S := 'FB'
    Else S := 'FG';
  End
  Else
  If (FBackgroundIndex = Index) And FBackgroundEnabled Then S := 'BG';

  If S <> '' Then
  Begin
    Canvas.GetTextExtent(S,CX,CY);
    rc := RectFromIndex(Index);
    X := rc.Left + (rc.Right - rc.Left - CX) Div 2;
    Y := rc.Bottom + (rc.Top - rc.Bottom - CY) Div 2;
    Canvas.Brush.Mode := bmTransparent;
    Canvas.Pen.color := OppositeRGB(Colors[Index]);
    Canvas.TextOut(X,Y,S);
  End;
End;


Procedure TColorGrid.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var
  Linear:LongInt;
Begin
  Linear := IndexFromPoint(X,Y);
  If Linear >= 0 Then
  Begin
    Case Button Of
      mbLeft:
      Begin
        If Not FForegroundEnabled And FClickEnablesColor Then
        Begin
          FForegroundEnabled := True;
        End;
        ForegroundIndex := Linear;
      End;
      mbRight:
      Begin
        If Not FBackgroundEnabled And FClickEnablesColor Then
        Begin
          FBackgroundEnabled := True;
        End;
        BackgroundIndex := Linear;

        If Linear >= 0 Then ItemFocus(Linear);
      End;
    End;
    Selection := Linear;
  End;

  Inherited MouseDown(Button,ShiftState,X,Y);
End;


Procedure TColorGrid.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
  If Button = mbRight Then
    If FBackgroundIndex >= 0 Then ItemSelect(FBackgroundIndex);

  Inherited MouseDblClick(Button,ShiftState,X,Y);
End;


Procedure TColorGrid.CharEvent(Var key:Char;RepeatCount:Byte);
Var
  Linear:LongInt;
Begin
  Case key Of
    'f','F':
    Begin
      Linear := Selection;
      If Not FForegroundEnabled And FClickEnablesColor Then
      Begin
        FForegroundEnabled := True;
        Linear := -1;
      End;
      ForegroundIndex := Linear;
      {Click}
    End;
    'b','B':
    Begin
      Linear := Selection;
      If Not FBackgroundEnabled And FClickEnablesColor Then
      Begin
        FBackgroundEnabled := True;
        Linear := -1;
      End;
      BackgroundIndex := Linear;
      {Click}
    End;
    Else Inherited CharEvent(key,RepeatCount);
  End;
End;


Procedure TColorGrid.SetGridOrdering(Value:TGridOrdering);
Begin
  If FGridOrdering <> Value Then
  Begin
    FGridOrdering := Value;
    BeginUpdate;
    ColCount := 16 Shr Ord(FGridOrdering);
    RowCount := 1 Shl Ord(FGridOrdering);
    SetColorArray(0,BasicColors);
    EndUpdate;
  End;
End;


Procedure TColorGrid.SetForegroundIndex(Value:LongInt);
Begin
  If (FForegroundIndex <> Value) And FForegroundEnabled Then
  Begin
    FForegroundIndex := Value;
    Invalidate;
  End;
End;


Procedure TColorGrid.SetBackgroundIndex(Value:LongInt);
Begin
  If (FBackgroundIndex <> Value) And FBackgroundEnabled Then
  Begin
    FBackgroundIndex := Value;
    Invalidate;
  End;
End;


Procedure TColorGrid.EnableForeground(Value:Boolean);
Begin
  If FForegroundEnabled <> Value Then
  Begin
    FForegroundEnabled := Value;
    Invalidate;
  End;
End;


Procedure TColorGrid.EnableBackground(Value:Boolean);
Begin
  If FBackgroundEnabled <> Value Then
  Begin
    FBackgroundEnabled := Value;
    Invalidate;
  End;
End;



Begin
  RegisterClasses([TColorGrid]);
End.



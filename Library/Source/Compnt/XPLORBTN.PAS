
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit XplorBtn;

Interface

Uses
  Color,Classes, Forms, Buttons, Graphics;

{Declare new class}
Type
  TExplorerButton=Class(TSpeedButton)
  Private
    FMouseInside:Boolean;
    FMouseTimer:TTimer;
    FCapture:Boolean;
    FFlat:Boolean;
    FBitmapDown:TBitmap;
    FBitmapUp:TBitmap;
    Procedure EvFMouseTimer(Sender:TObject);
    Function GetGlyphDown:TBitmap;
    Procedure SetGlyphDown(NewBitmap:TBitmap);
    Function GetGlyphUp:TBitmap;
    Procedure SetGlyphUp(NewBitmap:TBitmap);
    Procedure SetFlat(Value:Boolean);
  Protected
    Procedure SetupComponent; Override;
    Procedure MouseDown(Button:TMouseBUtton;ShiftState:TShiftState;X,Y:LongInt); Override;
    Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt); Override;
    Procedure MouseUp(Button:TMouseBUtton;ShiftState:TShiftState;X,Y:LongInt); Override;
    Procedure DrawFrame(Down:Boolean); Override;
    Procedure DrawBitmap(Bitmap:TBitmap;Down:Boolean); Override;
    Property Cancel;
    Property Default;
    Property Kind;
//    Property TabOrder;
//    Property TabStop;
//    Property ZOrder;
    Property OnKeyPress;
    Property OnScan;
  Public
    Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
    Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
    Property Flat:Boolean read FFlat write SetFlat;
  Published
    PROPERTY Align;
    PROPERTY Color;
    PROPERTY DragCursor;
    PROPERTY DragMode;
    PROPERTY Enabled;
    PROPERTY Font;
    PROPERTY ParentColor;
    PROPERTY ParentPenColor;
    PROPERTY ParentFont;
    PROPERTY ParentShowHint;
    PROPERTY PenColor;
    PROPERTY PopupMenu;
    PROPERTY ShowHint;
    PROPERTY TabOrder;
    PROPERTY TabStop;
    PROPERTY Visible;
    PROPERTY ZOrder;

    PROPERTY OnCanDrag;
    PROPERTY OnClick:TNotifyEvent Read FOnClick Write FOnClick;
    PROPERTY OnCommand;
    PROPERTY OnDblClick;
    PROPERTY OnDragDrop;
    PROPERTY OnDragOver;
    PROPERTY OnEndDrag;
    PROPERTY OnEnter;
    PROPERTY OnExit;
    PROPERTY OnFontChange;
    PROPERTY OnMouseClick;
    PROPERTY OnMouseDblClick;
    PROPERTY OnMouseDown;
    PROPERTY OnMouseMove;
    PROPERTY OnMouseUp;
    PROPERTY OnResize;
    PROPERTY OnSetupShow;
    PROPERTY OnStartDrag;
//    PROPERTY CaptionOff:STRING read GetCaptionOff write SetCaptionOff;
//    PROPERTY CaptionOn:STRING read GetCaptionOn write SetCaptionOn;
//    PROPERTY AllowDrawDown:BOOLEAN read FAllowDrawDown write SetAllowDrawDown;
//    PROPERTY AllowDrawFrame:BOOLEAN read FAllowDrawFrame write SetAllowDrawFrame;
    Property GlyphDown:TBitmap read GetGlyphDown write SetGlyphDown;
    Property GlyphUp:TBitmap read GetGlyphUp write SetGlyphUp;
  End;


{Define components to export}
{You may define a navigator page and a component bitmap file}
Exports
  TExplorerButton,'User','';


Implementation


Procedure TExplorerButton.SetupComponent;
Begin
  Inherited SetupComponent;

  Caption := '';
  Width := 40;
  Height := 40;
  FFlat := True;
  FMouseTimer.Create(Self);
  Include(FMouseTimer.ComponentState, csDetail);
  FMouseTimer.Interval := 50;
  FMouseTimer.OnTimer := EvFMouseTimer;
End;

Procedure TExplorerButton.MouseDown(Button:TMouseBUtton;ShiftState:TShiftState;X,Y:LongInt);
Begin
  Inherited MouseDown(Button,ShiftState,X,Y);

  If Button = mbLeft Then FCapture := True;
End;

Procedure TExplorerButton.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Begin
  FMouseTimer.Stop;

  Inherited MouseMove(ShiftState,X,Y);

  If Application <> Nil Then
    If Not Application.HasFocus Then exit;

  If (not FMouseInside) And (not FCapture) Then
  Begin
    FMouseInside := True;
    Redraw(ClientRect);
  End;

  {Start Timer}
  If FFlat Then FMouseTimer.Start;
End;

Procedure TExplorerButton.MouseUp(Button:TMouseBUtton;ShiftState:TShiftState;X,Y:LongInt);
Begin
  Inherited MouseUp(Button,ShiftState,X,Y);

  If Button = mbLeft Then FCapture := False;
End;

Procedure TExplorerButton.EvFMouseTimer(Sender:TObject);
Var
  AControl:TControl;
Begin
  FMouseTimer.Stop;

  If FCapture Then AControl := Self
  Else AControl := Screen.GetControlFromPoint(Screen.MousePos);

  If AControl <> Self Then
  Begin
    FMouseInside := False;
    Redraw(ClientRect);
  End
  Else FMouseTimer.Start;
End;

Procedure TExplorerButton.SetGlyphDown(NewBitmap:TBitmap);
Var
  OldBitmap:TBitmap;
Begin
  OldBitmap := FBitmapDown;

  {create internal copy}
  If NewBitmap <> Nil Then FBitmapDown := NewBitmap.Copy
  Else FBitmapDown := Nil;

  If FBitmapDown <> Nil Then Include(FBitmapDown.ComponentState, csDetail);

  If OldBitmap <> Nil Then
    If OldBitmap <> NewBitmap Then OldBitmap.Destroy;

  Arrange;
  Invalidate;
end;

Function TExplorerButton.GetGlyphDown:TBitmap;
Begin
  If FBitmapDown = Nil Then
  Begin
    FBitmapDown.Create;
    Include(FBitmapDown.ComponentState, csDetail);
  End;
  Result := FBitmapDown;
End;

Procedure TExplorerButton.SetGlyphUp(NewBitmap:TBitmap);
Var
  OldBitmap:TBitmap;
Begin
  OldBitmap := FBitmapUp;

  {create internal copy}
  If NewBitmap <> Nil Then FBitmapUp := NewBitmap.Copy
  Else FBitmapUp := Nil;

  If FBitmapUp <> Nil Then Include(FBitmapUp.ComponentState, csDetail);

  If OldBitmap <> Nil Then
    If OldBitmap <> NewBitmap Then OldBitmap.Destroy;

  Arrange;
  Invalidate;
end;

Function TExplorerButton.GetGlyphUp:TBitmap;
Begin
  If FBitmapUp = Nil Then
  Begin
    FBitmapUp.Create;
    Include(FBitmapUp.ComponentState, csDetail);
  End;
  Result := FBitmapUp;
End;

Procedure TExplorerButton.SetFlat(Value:Boolean);
Begin
     FFlat := Value;
     FMouseInside := False;
End;

Procedure TExplorerButton.DrawFrame(Down:Boolean);
Var
  rec:TRect;
  FrameColor:TColor;
Begin
  If ((not Down) And (FFlat) And
      (((not FMouseInside) And (not FCapture)) Or (not Enabled))) Then
  Begin
    // dont draw the Frame
    rec := ClientRect;
    If Parent <> Nil Then FrameColor := Parent.Color
    Else FrameColor := clBackGround;

    If Designed Then
    Begin
      Canvas.Brush.Color := FrameColor;
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Style := psDash;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(rec);
    End
    Else Canvas.ShadowedBorder(rec,FrameColor,FrameColor);

    InflateRect(rec,-1,-1);
    Canvas.ShadowedBorder(rec,FrameColor,FrameColor);

    Canvas.ClipRect := IntersectRect(Canvas.ClipRect,rec);
  End
  Else Inherited DrawFrame(Down);
End;

Procedure TExplorerButton.DrawBitmap(Bitmap:TBitmap;Down:Boolean);
Begin
  If ((not Down) And
      (((not FMouseInside) And (not FCapture)) Or (not Enabled))) Then
  Begin
    // inactive state
    Bitmap := Glyph;
  End
  Else
  Begin
    If Down Then Bitmap := FBitmapDown
    Else Bitmap := FBitmapUp;

    If Bitmap <> Nil Then
    Begin
      If Bitmap.Empty Then Bitmap := Glyph;
    End
    Else Bitmap := Glyph;
  End;

  Inherited DrawBitmap(Bitmap,Down);
End;

Procedure TExplorerButton.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
  If ResName = 'rnGlyphDown' THEN
  Begin
    If DataLen <> 0 Then GlyphDown.ReadSCUResource(rnBitmap,Data,DataLen);
  End
  Else
  If ResName = 'rnGlyphUp' Then
  Begin
    If DataLen <> 0 Then GlyphUp.ReadSCUResource(rnBitmap,Data,DataLen);
  End
  Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Function TExplorerButton.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
  Result := Inherited WriteSCUResource(Stream);
  If not Result Then exit;

  If (FBitmapDown <> Nil) And (ComponentState * [csDetail] = [])
  Then Result := FBitmapDown.WriteSCUResourceName(Stream,'rnGlyphDown');
  If not Result Then exit;

  If (FBitmapUp <> Nil) And (ComponentState * [csDetail] = [])
  Then Result := FBitmapUp.WriteSCUResourceName(Stream,'rnGlyphUp');
End;


Initialization
  {Register classes}
  RegisterClasses([TExplorerButton]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  04-Sep-06     TB         published inherited properties putted in declaration
                           (copied from TGlyphButton)


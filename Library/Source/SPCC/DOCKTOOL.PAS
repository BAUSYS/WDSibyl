
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit DockTool;

Interface

Uses Messages,SysUtils,Classes,Graphics,Forms,StdCtrls,ExtCtrls,
     uSysInfo,
     uList;

Type
    {$M+}
    TDockingEvent=Procedure(Sender:TObject;Var TargetForm:TForm;
         Var NewAlign:TToolbarAlign) Of Object;

    TDockingState=(dsHide,dsDock,dsFloat);
    {$M-}

Type
    TDockingToolbar=Class(TPanel)
      Private
         FAutoAlign:Boolean;
         FAutoWrap:Boolean;
         FMargin:LongInt;
         FState:TDockingState;
         FResizing:Boolean;
         FDragging:Boolean;
         FPanelForm:TForm;
         FDockingForm:TForm;
         FToolAlign:TToolbarAlign;
         FEnableDocking:TToolbarAlignments;
         PanelBorderSizeX:LongInt;
         PanelBorderSizeY:LongInt;
         PanelTitleHeight:LongInt;
         OldFgMode:TPenMode;
         OldLineWidth:LongInt;
         OldLineType:TPenStyle;
         InitDrag:TPoint;
         CurDrag:TPoint;
         TryDocking:Boolean;
         DraggingAborted:Boolean;
         LastActiveControl:TControl;
         LastDockToolbar:TToolbar;
         LastDockLeft:LongInt;
         LastDockBottom:LongInt;
         LastDockWidth:LongInt;
         LastDockHeight:LongInt;
         UsePanelFormSize:Boolean;
         FOnChange:TNotifyEvent;
         FOnDocking:TDockingEvent;
         Procedure UpdateTrackSize;
         Procedure SetAutoWrap(Value:Boolean);
         Procedure SetMargin(Value:LongInt);
         Function IsDocked:Boolean;
         Function GetState:TDockingState;
         Procedure SetState(Value:TDockingState);
         Function GetDockingForm:TForm;
         Procedure UndockPanel;
         Procedure DockPanel(ParentToolbar:TToolbar);
         Procedure DockLastPanel;
         Procedure HidePanel;
         Procedure FloatPanel;
         Procedure SetToolAlign(Value:TToolbarAlign);
         Procedure SetDockingForm(AForm:TForm);
         Function GetWrappedSize(Docked:Boolean;HorizToolbar:Boolean;
                                 Var WrapWidth,WrapHeight:LongInt):Boolean;
         Function GetToolbarMaxSize(ParentToolbar:TToolbar;NewSize:LongInt):LongInt;
         Procedure DrawDragFrame;
         Function GetDragTarget(ptScreen:TPoint;Var target:TRect):TControl;
         Function GetTargetToolbarAlign(TargetForm:TForm; ptScreen:TPoint):TToolbarAlign;
         Procedure FormOnClose(Sender:TObject;Var Action:TCloseAction);
         Procedure FormOnSetupShow(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure RealignControls;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure Change;Virtual;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure QueryDockingForm(Var TargetForm:TForm;Var NewAlign:TToolbarAlign);Virtual;
         Property Align;
         Property Alignment;
         Property BevelInner;
         Property BevelOuter;
         Property BevelWidth;
         Property BorderStyle;
         Property BorderWidth;
         Property Bottom;
         Property Caption;
         Property DragCursor;
         Property DragMode;
         Property Font;
         Property Height;
         Property Left;
         Property ParentFont;
         Property ParentPenColor;
         Property PenColor;
         Property Right;
         Property TabOrder;
         Property TabStop;
         Property Top;
         Property Visible;
         Property Width;
         Property ZOrder;
         Property OnFontChange;
      Public
         Destructor Destroy;Override;
         Procedure InsertControl(AChild:TControl);Override;
         Procedure RemoveControl(AChild:TControl);Override;
         Procedure Show;Override;
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Property DockingForm:TForm Read GetDockingForm Write SetDockingForm;
      Published
         Property AutoWrap:Boolean Read FAutoWrap Write SetAutoWrap;
         Property DockingState:TDockingState Read GetState Write SetState;
         Property EnableDocking:TToolbarAlignments Read FEnableDocking Write FEnableDocking;
         Property Margin:LongInt Read FMargin Write SetMargin;
         Property ToolbarAlign:TToolbarAlign Read FToolAlign Write SetToolAlign;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDocking:TDockingEvent Read FOnDocking Write FOnDocking;
    End;


Procedure WriteDockingToolbars;
Procedure ReadDockingToolbars;

Const
    UseSCUDockingInformation:Boolean=True;


Implementation

{$IFDEF OS2}
Uses Os2Def,PmWin;
{$ENDIF}

{$IFDEF WIN32}
Uses WinDef,WinNT,WinUser;
{$ENDIF}

Var
    DockingList:TList;
    OldTitleBarProc:Pointer;

{subclassed Window Procedure For Titlebar Of the PanelForms}
{$IFDEF OS2}
Function NewTitleBarProc(Win:HWND;Msg:ULONG;mp1,mp2:MPARAM):mresult;CDECL;
Var  OldProc:Function(Win:HWND;Msg:ULONG;mp1,mp2:MPARAM):mresult;CDECL;
     WinH:HWindow;
     AForm:TForm;
     AToolbar:TDockingToolbar;
     pt:TPoint;
Begin
     Case Msg Of
       WM_BUTTON1DOWN,WM_BUTTON2DOWN,
       WM_BUTTON1DBLCLK,WM_BUTTON2DBLCLK:
       Begin
         WinH := WinQueryWindow(Win,QW_PARENT); {HWindowFrame bestimmen}
         WinH := WinWindowFromID(WinH,FID_CLIENT); {HWindow bestimmen}
         AForm := TForm(HandleToControl(WinH));
         If AForm <> Nil Then
           If AForm.ControlCount = 1 Then
         Begin
           AToolbar := TDockingToolbar(AForm.Controls[0]);
           If AToolbar Is TDockingToolbar Then
             If Not IsControlLocked(AToolbar) Then
             Begin
               pt := Screen.MousePos;
               pt := AToolbar.ScreenToClient(pt);

               Case Msg Of
                 WM_BUTTON1DOWN:
                   AToolbar.MouseDown(mbLeft,[],pt.X,pt.Y);
                 WM_BUTTON2DOWN:
                   AToolbar.MouseDown(mbRight,[],pt.X,pt.Y);
                 WM_BUTTON1DBLCLK:
                   AToolbar.MouseDblClick(mbLeft,[],pt.X,pt.Y);
                 WM_BUTTON2DBLCLK:
                   AToolbar.MouseDblClick(mbRight,[],pt.X,pt.Y);
               End;
             End;
         End;
         Result := 0;
       End
       Else
       Begin
         OldProc := OldTitleBarProc;
         Result := OldProc(Win,Msg,mp1,mp2);
       End;
     End;
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC).                                  บ
บ                                                                           บ
บ This section: TDockingFrame Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TDockingFrame=Class(TToolbar)
      Private
         FAutoWrap:Boolean;
         FDockOrder:LongInt;
         Procedure SetAutoWrap(Value:Boolean);
      Public
         Property AutoWrap:Boolean Read FAutoWrap Write SetAutoWrap;
         Property DockOrder:LongInt Read FDockOrder Write FDockOrder;
    End;


Procedure TDockingFrame.SetAutoWrap(Value:Boolean);
Begin
     If Value <> FAutoWrap Then
     Begin
          FAutoWrap := Value;
          Sizeable := Not FAutoWrap;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC).                                  บ
บ                                                                           บ
บ This section: TDockingToolbar Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
    TDockingFrameRegistered:Boolean=False;


Procedure TDockingToolbar.SetupComponent;

Begin
     Inherited SetupComponent;

     Caption := '';
     Align := alClient;
     FAutoAlign := True;
     FAutoWrap := True;
     FToolAlign := tbTop;
     FState := dsHide;
     FEnableDocking := [tbTop,tbBottom,tbLeft,tbRight];
     FMargin := 6;
     FResizing := False;
     FDragging := False;
     UsePanelFormSize := False;

     If Owner Is TForm Then
     Begin
          FPanelForm := TForm(Owner);
          FPanelForm.BorderIcons := FPanelForm.BorderIcons -
                                        [biMinimize,biMaximize];
          FPanelForm.Visible := FALSE;

          If Not Designed Then
            If Not (csWriting In ComponentState)
            Then FPanelForm.OnClose := FormOnClose;

          FPanelForm.OnSetupShow := FormOnSetupShow;

          {Size Of the framecontrol Items}
          Case FPanelForm.BorderStyle Of
            bsSingle:   Begin
                             PanelBorderSizeX := goSysInfo.Screen.BorderSize.CX;
                             PanelBorderSizeY := goSysInfo.Screen.BorderSize.CY;
                           End;
            bsSizeable: Begin
                             PanelBorderSizeX := goSysInfo.Screen.SizeBorderSize.CX;
                             PanelBorderSizeY := goSysInfo.Screen.SizeBorderSize.CY;
                           End;
            bsDialog:   Begin
                             PanelBorderSizeX := goSysInfo.Screen.DlgBorderSize.CX;
                             PanelBorderSizeY := goSysInfo.Screen.DlgBorderSize.CY;
                           End;
          End;
          PanelTitleHeight := goSysInfo.Screen.TitlebarSize;
     End;
     Include(ComponentState, csAcceptsControls);

     If Not (csWriting In ComponentState) Then
       If Not Designed Then DockingList.Add(Self);


     If Not TDockingFrameRegistered Then
     Begin
          RegisterClasses([TDockingFrame]); {RuntimeSCU}
          TDockingFrameRegistered := True;
     End;
End;


Procedure TDockingToolbar.LoadedFromSCU(SCUParent:TComponent);
Begin
     Inherited LoadedFromSCU(SCUParent);

     SetState(FState);
End;


Procedure TDockingToolbar.Show;
Begin
     Inherited Show;

     RealignControls;
End;


Destructor TDockingToolbar.Destroy;
Begin
     If Not (csWriting In ComponentState) Then DockingList.Remove(Self);

     FAutoAlign := False;   {avoid RealignControls}

     Inherited Destroy;
End;


Procedure TDockingToolbar.InsertControl(AChild:TControl);
Begin
     Inherited InsertControl(AChild);

     RealignControls;
End;


Procedure TDockingToolbar.RemoveControl(AChild:TControl);
Begin
     Inherited RemoveControl(AChild);

     RealignControls;
End;


Function TDockingToolbar.GetWrappedSize(Docked:Boolean;HorizToolbar:Boolean;
                                   Var WrapWidth,WrapHeight:LongInt):Boolean;
Var  I,X,Y:LongInt;
     Control:TControl;
     ASize:LongInt;
     MaxHeight:LongInt;
     MaxWrapWidth:LongInt;
Begin
     Result := False;
     If ControlCount = 0 Then Exit;

     If Not FAutoWrap Then
     Begin
          Result := True;
          Exit;
     End;

     If Docked Then
     Begin
          WrapWidth := 0;
          WrapHeight := 0;

          {Search largest Control To determine wrapping Size}
          For I := 0 To ControlCount-1 Do
          Begin
               Control := Controls[I];
               If HorizToolbar Then
               Begin
                    ASize := Control.Height;
                    If ASize > WrapHeight Then WrapHeight := ASize;
                    Inc(WrapWidth, Control.Width);
               End
               Else
               Begin
                    ASize := Control.Width;
                    If ASize > WrapWidth Then WrapWidth := ASize;
                    Inc(WrapHeight, Control.Height);
               End;
          End;
     End;


     {determine the highest Control}
     MaxHeight := 0;
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];
          ASize := Control.Height;
          If ASize > MaxHeight Then MaxHeight := ASize;
     End;


     {determine final Size}
     MaxWrapWidth := 0;
     WrapHeight := 0;
     X := 0;
     Y := 0;
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];

          If X + Control.Width > WrapWidth Then
          Begin
               X := 0;
               Y := Y + MaxHeight;
          End;

          If X + Control.Width > MaxWrapWidth Then
          Begin
               MaxWrapWidth := X + Control.Width;
          End;

          If Y + Control.Height > WrapHeight Then
          Begin
               WrapHeight := Y + Control.Height;
          End;
          Inc(X,Control.Width);
     End;

     WrapWidth := MaxWrapWidth;

     Inc(WrapWidth, 2*FMargin);
     Inc(WrapHeight, 2*FMargin);

     Result := True;
End;


Procedure TDockingToolbar.RealignControls;
Var  I,X,Y:LongInt;
     xadd,yadd:LongInt;
     xmax,ymax:LongInt;
     Control:TControl;
Begin
     If Not FAutoAlign Then Exit;

     If FResizing Then Exit;
     If Handle = 0 Then Exit;

     If DockingState = dsFloat Then
       If Form.WindowState = wsMinimized Then Exit;


     If Not FAutoWrap Then // centre the Control
     Begin
          For I := 0 To ControlCount-1 Do
          Begin
               Control := Controls[I];
               Control.SetWindowPos(FMargin, FMargin,
                                    Width-2*FMargin, Height-2*FMargin);
          End;
          Exit;
     End;

     X := FMargin; {from Left}
     Y := FMargin; {from Top}
     xmax := 0;
     ymax := 0;
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];
          If Control.Handle <> 0 Then Control.Hide;

          If X + Control.Width > Width - FMargin Then
          Begin
               X := FMargin;
               Y := Y + ymax;
               ymax := 0;
          End;
          {Control.SetBounds(X,Y,Control.Width,Control.Height);}
          Inc(X,Control.Width);
          If xmax < X Then xmax := X;
          If ymax < Control.Height Then ymax := Control.Height;
     End;

     FResizing := True;
     If parent Is TForm Then
       If parent.ControlCount = 1 Then
         If Form <> Nil Then
           If Align = alClient Then
             If ControlCount > 0 Then
     Begin
          xadd := Form.Width - Form.ClientWidth;
          yadd := Form.Height - Form.ClientHeight;

          Form.SetBounds(Form.Left,Form.Top,
                         xmax + FMargin + xadd,
                         Y + ymax + FMargin + yadd);
     End;
     FResizing := False;

     X := FMargin; {from Left}
     Y := FMargin; {from Top}
     xmax := 0;
     ymax := 0;
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];
          {If Control.Handle <> 0 Then Control.Hide;}

          If X + Control.Width > Width - FMargin Then
          Begin
               X := FMargin;
               Y := Y + ymax;
               ymax := 0;
          End;
          Control.SetBounds(X,Y,Control.Width,Control.Height);
          Inc(X,Control.Width);
          If xmax < X Then xmax := X;
          If ymax < Control.Height Then ymax := Control.Height;
     End;

     If Handle <> 0 Then
       For I := 0 To ControlCount-1 Do
       Begin
            Control := Controls[I];
            If Control.Handle <> 0 Then Control.Show;
       End;

     UpdateTrackSize;
End;


Procedure TDockingToolbar.UpdateTrackSize;
Var  I,xadd,yadd:LongInt;
     wmin,wmax,hmin,hmax:LongInt;
     Control:TControl;
Begin
     If Designed Then Exit;
     If IsDocked Then Exit; {nicht im Docked Modus}
     If Form = Nil Then Exit; {noch nicht eingefgt}
     If FPanelForm = Nil Then Exit; {PanelForm zerst”rt}

     {Panel Modus}
     If FPanelForm.ControlCount = 1 Then
       If ControlCount > 0 Then
     Begin
          xadd := Form.Width - FPanelForm.ClientWidth + 2*FMargin;
          yadd := Form.Height - FPanelForm.ClientHeight + 2*FMargin;
          wmin := 0;
          wmax := 0;
          hmin := 0;
          hmax := 0;
          For I := 0 To ControlCount-1 Do
          Begin
               Control := Controls[I];
               If Control.Width > wmin Then wmin := Control.Width;
               Inc(wmax,Control.Width);
               If Control.Height > hmin Then hmin := Control.Height;
               Inc(hmax,Control.Height);  {?}
          End;
          FPanelForm.Constraints.MinWidth := wmin + xadd;
          FPanelForm.Constraints.MaxWidth := wmax + xadd;
          FPanelForm.Constraints.MinHeight := hmin + yadd;
          FPanelForm.Constraints.MaxHeight := hmax + yadd;
     End;
End;


Procedure TDockingToolbar.SetAutoWrap(Value:Boolean);
Begin
     If Value <> FAutoWrap Then
     Begin
          FAutoWrap := Value;
          RealignControls;

          If parent Is TDockingFrame
          Then TDockingFrame(parent).AutoWrap := FAutoWrap;
     End;
End;


Procedure TDockingToolbar.SetMargin(Value:LongInt);
Begin
     If Value <> FMargin Then
       If Value >= 0 Then
     Begin
          FMargin := Value;
          RealignControls;
     End;
End;


Procedure TDockingToolbar.SetToolAlign(Value:TToolbarAlign);
Begin
     If Value <> FToolAlign Then
     Begin
          FToolAlign := Value;
          LastDockLeft := 0;
          LastDockBottom := 0;

          If IsDocked Then
          Begin
               UndockPanel;
               DockPanel(Nil);
          End;
     End;
End;


Procedure TDockingToolbar.SetDockingForm(AForm:TForm);
Begin
     If AForm <> FDockingForm Then
     Begin
          If AForm = Nil Then Exit;

          If IsDocked Then
          Begin
               LastDockLeft := 0;
               LastDockBottom := 0;

               UndockPanel;
               FDockingForm := AForm;
               DockPanel(Nil);
          End
          Else FDockingForm := AForm;
     End;
End;


Function TDockingToolbar.IsDocked:Boolean;
Begin
     Result := parent Is TDockingFrame;
End;



Function TDockingToolbar.GetState:TDockingState;
Begin
     If Designed Then
     Begin
          Result := FState;
          Exit;
     End;

     If IsDocked Then Result := dsDock
     Else If Showing Then Result := dsFloat
          Else Result := dsHide;
End;


Procedure TDockingToolbar.SetState(Value:TDockingState);
Begin
     If (Designed) Or (csReading In ComponentState) Then
     Begin
          If Designed Or UseSCUDockingInformation Then FState := Value;
          Exit;
     End;

     If Value = GetState Then Exit;

     FState := Value;

     Case FState Of
       dsDock:  DockLastPanel;
       dsFloat: FloatPanel;
       dsHide:  HidePanel;
     End;
End;


Function TDockingToolbar.GetDockingForm:TForm;
Begin
     If FDockingForm = Nil Then FDockingForm := Application.MainForm;
     Result := FDockingForm;
End;


Procedure TDockingToolbar.UndockPanel;
Var  ParentToolbar:TDockingFrame;
     NewSize:LongInt;
Begin
     Align := alNone;

     ParentToolbar := TDockingFrame(parent);

     If Owner <> Nil Then Owner.RemoveComponent(Self);
     parent := Nil;

     If ParentToolbar Is TDockingFrame Then
     Begin
          LastDockToolbar := Nil;

          If ParentToolbar.ControlCount > 0 Then
          Begin
               If (ParentToolbar.ControlCount = 1) And
                  (ParentToolbar.Sizeable) Then ParentToolbar.Destroy
               Else
               Begin {Wrap it}
                    NewSize := GetToolbarMaxSize(ParentToolbar,0);
                    ParentToolbar.Size := NewSize;
                    LastDockToolbar := ParentToolbar;
               End;
          End
          Else ParentToolbar.Destroy;
     End;


     If FPanelForm <> Nil Then
     Begin
          FPanelForm.Close; {no Destroy}
          FPanelForm.Visible := FALSE;
     End;
End;


Procedure TDockingToolbar.HidePanel;
Begin
     If FPanelForm <> Nil Then
     Begin
          UndockPanel;

          Align := alClient;

          FPanelForm.Hide;
          FPanelForm.InsertComponent(Self);
          parent := FPanelForm;
     End;
End;


Procedure TDockingToolbar.FloatPanel;
Begin
     If GetState = dsFloat Then Exit;

     If FPanelForm <> Nil Then
     Begin
          UndockPanel;

          Align := alClient;

          FPanelForm.InsertComponent(Self);
          parent := FPanelForm;
          FPanelForm.Show;
     End;
End;


Procedure TDockingToolbar.DockPanel(ParentToolbar:TToolbar);
Var  HorizToolbar:Boolean;
     ToolWidth,ToolHeight:LongInt;
     NewSize:LongInt;
Begin
     FDockingForm := GetDockingForm;

     UndockPanel;

     If ParentToolbar <> Nil Then
       If Not (ParentToolbar Is TDockingFrame) Then ParentToolbar := Nil;

     If ParentToolbar = Nil Then
     Begin
          ParentToolbar := TDockingFrame.Create(FDockingForm);
          ParentToolbar.Alignment := FToolAlign;
          ParentToolbar.BevelStyle := tbNone;
          TDockingFrame(ParentToolbar).AutoWrap := FAutoWrap;
     End;

     HorizToolbar := ParentToolbar.Alignment In [tbTop,tbBottom];
     If FAutoWrap Then
     Begin
          ToolWidth := ParentToolbar.Width;
          ToolHeight := ParentToolbar.Height;
     End
     Else
     Begin
          If (FPanelForm <> Nil) And UsePanelFormSize Then
          Begin // take the Size Of the Panel Form
               ToolWidth := FPanelForm.ClientWidth;
               ToolHeight := FPanelForm.ClientHeight;
          End
          Else
          Begin
               ToolWidth := Width;
               ToolHeight := Height;
          End;
          Align := alClient;
     End;
     ParentToolbar.Sizeable := Not FAutoWrap;

     If GetWrappedSize(True,HorizToolbar,ToolWidth,ToolHeight) Then
     Begin
          If HorizToolbar Then NewSize := ToolHeight
          Else NewSize := ToolWidth;

          {Test ob Toolbar, gr”แer sein muแ als NewSize}
          NewSize := GetToolbarMaxSize(ParentToolbar,NewSize);

          ParentToolbar.Size := NewSize;
     End;

     SetWindowPos(LastDockLeft,LastDockBottom,ToolWidth,ToolHeight);

     parent := ParentToolbar;
     LastDockToolbar := ParentToolbar;

     ParentToolbar.parent := FDockingForm;

     FDockingForm.InsertComponent(Self);

     Change;
End;


Procedure TDockingToolbar.DockLastPanel;
Var  AToolbar:TDockingFrame;
     I:LongInt;
Begin
     AToolbar := Nil;
     {Search the Last Toolbar}
     If FAutoWrap Then
       If FDockingForm <> Nil Then
       Begin
            For I := 0 To FDockingForm.ControlCount-1 Do
            Begin
                 If FDockingForm.Controls[I] = LastDockToolbar Then
                   If LastDockToolbar Is TDockingFrame Then
                     If LastDockToolbar.Alignment = FToolAlign Then
                     Begin
                          AToolbar := TDockingFrame(LastDockToolbar);
                          break;
                     End;
            End;
       End;

     DockPanel(AToolbar);
End;


Function TDockingToolbar.GetToolbarMaxSize(ParentToolbar:TToolbar;NewSize:LongInt):LongInt;
Var  I:LongInt;
     AControl:TControl;
     horz:Boolean;
Begin
     If ParentToolbar <> Nil Then
     Begin
          horz := ParentToolbar.Alignment In [tbTop,tbBottom];
          For I := 0 To ParentToolbar.ControlCount-1 Do
          Begin
               AControl := ParentToolbar.Controls[I];
               If csDetail In AControl.ComponentState Then continue;

               If horz Then
               Begin
                    If AControl.Height > NewSize
                    Then NewSize := AControl.Height;
               End
               Else
               Begin
                    If AControl.Width > NewSize
                    Then NewSize := AControl.Width;
               End;
          End;
     End;
     Result := NewSize;
End;


Procedure TDockingToolbar.Change;
Begin
     If FOnChange <> Nil Then FOnChange(Self);
End;


{$HINTS OFF}
Procedure TDockingToolbar.FormOnClose(Sender:TObject;Var Action:TCloseAction);
Begin
     Action := caFreeHandle;
End;


Procedure TDockingToolbar.FormOnSetupShow(Sender:TObject);
Var  TitlebarWin:HWindow;
     ret:Pointer;
Begin
     If Designed Then Exit;

     {$IFDEF OS2}
     TitlebarWin := WinWindowFromID(FPanelForm.Frame.Handle,FID_TITLEBAR);
     ret := WinSubClassWindow(TitlebarWin, @NewTitleBarProc);
     If ret <> Nil Then OldTitleBarProc := ret;
     {$ENDIF}
End;
{$HINTS ON}


Procedure TDockingToolbar.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If FEnableDocking = [] Then Exit;

     FDragging := True;
     MouseCapture := True;
     DraggingAborted := False;
     LastActiveControl := Screen.ActiveControl;
     Focus;

     OldFgMode := Screen.Canvas.Pen.Mode;
     OldLineWidth := Screen.Canvas.Pen.Width;
     OldLineType := Screen.Canvas.Pen.Style;

     Screen.Canvas.Pen.Mode := pmNot;
     Screen.Canvas.Pen.Width := 1;
     Screen.Canvas.Pen.Style := psSolid;

     InitDrag := Forms.Point(X,Y);
     CurDrag := InitDrag;

     DrawDragFrame;
End;


Procedure TDockingToolbar.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  pt:TPoint;
     AControl:TControl;
     TargetForm:TForm;
     NewLeft:LongInt;
     NewBottom:LongInt;
     NewToolAlign:TToolbarAlign;
     rec:TRect;
     TargetToolbar:TToolbar;

  Procedure MovePanelForm(rec:TRect);
  Begin
       If FPanelForm = Nil Then Exit;

       FPanelForm.SetWindowPos(rec.Left, rec.Bottom,
                               FPanelForm.Width, FPanelForm.Height);
  End;

Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If FDragging Then
     Begin
          DrawDragFrame;

          FDragging := False;
          MouseCapture := False;

          Screen.Canvas.Pen.Mode := OldFgMode;
          Screen.Canvas.Pen.Width := OldLineWidth;
          Screen.Canvas.Pen.Style := OldLineType;

          Try
             If LastActiveControl <> Nil Then LastActiveControl.Focus;
          Except
          End;

          {ignore For DblClick}
          If (Abs(InitDrag.X - CurDrag.X) < 5) And
             (Abs(InitDrag.Y - CurDrag.Y) < 5) Then Exit;

          If DraggingAborted Then Exit;

          {Change Docking State}
          pt := Forms.Point(X,Y);
          pt := ClientToScreen(pt);

          AControl := GetDragTarget(pt,rec);

          If AControl = Nil Then
          Begin // target Is the DeskTop
               MovePanelForm(rec);
               FloatPanel;     {undock -> Align -> DeskTop}

               Change;
               Exit;
          End;

          {A drag target Is specified}
          TargetForm := AControl.Form;
          If TargetForm = Nil Then Exit; {?}

          If TargetForm = FPanelForm Then
          Begin // only the DeskTop Panel was moved
               MovePanelForm(rec);

               Change;
               Exit;
          End;

          {Set New Docking State Or Position}
          NewToolAlign := GetTargetToolbarAlign(TargetForm,pt);

          {check If we can dock At This Alignment}
          QueryDockingForm(TargetForm, NewToolAlign);

          If TargetForm = Nil Then
          Begin // target Is the DeskTop
               MovePanelForm(rec);
               FloatPanel;     {undock -> Align -> DeskTop}

               Change;
               Exit;
          End;


          {target redirected -> ignore Control To Insert}
          If AControl <> Nil Then
            If AControl.Form <> TargetForm Then AControl := Nil;


          If IsDocked Then                    {Docked}
            If TargetForm = Form Then         {In the same Form}
              If AControl = parent Then       {In the same Toolbar}
          Begin // only Position changes
               {determine the New Offset within the Toolbar}
               If FToolAlign In [tbTop,tbBottom] Then
               Begin
                    NewLeft := Left + X - InitDrag.X;
                    {clip Right}
                    If NewLeft + Width > parent.Width
                    Then NewLeft := parent.Width - Width;
                    {clip Left}
                    If NewLeft < 0 Then NewLeft := 0;
                    LastDockLeft := NewLeft;
                    LastDockBottom := 0;
               End
               Else
               Begin
                    NewBottom := Bottom + Y - InitDrag.Y;
                    {clip Top}
                    If NewBottom + Height > parent.Height
                    Then NewBottom := parent.Height - Height;
                    {clip Left}
                    If NewBottom < 0 Then NewBottom := 0;
                    LastDockLeft := 0;
                    LastDockBottom := NewBottom;
               End;

               SetWindowPos(LastDockLeft,LastDockBottom,Width,Height);

               Change;
               Exit;
          End;

          {Change the Docking Form, Toolbar And dock}
          While AControl <> Nil Do
          Begin
               If AControl Is TDockingFrame Then break
               Else AControl := AControl.parent;
          End;

          {fr neworder merken}
          TargetToolbar := TToolbar(AControl);

          {prevent Docking A non-wrapped In another Panel}
          If Not FAutoWrap Then AControl := Nil;

          {prevent Docking A wrapped In A non-wrapped Panel}
          If FAutoWrap Then
            If AControl Is TDockingFrame Then // check the Toolbar
              If Not TDockingFrame(AControl).AutoWrap Then AControl := Nil;


          UsePanelFormSize := True; {For Docking non-wrapped Panels}

          UndockPanel;

          LastDockLeft := 0;
          LastDockBottom := 0;
          FToolAlign := NewToolAlign;
          FDockingForm := TargetForm;
          FToolAlign := NewToolAlign;

          DockPanel(TDockingFrame(AControl));

          {neue order}
          If TargetToolbar <> Nil Then
            If TargetToolbar <> parent
            Then TDockingFrame(parent).order := TargetToolbar.order;

          UsePanelFormSize := False; {For Docking non-wrapped Panels}
     End;
End;


Procedure TDockingToolbar.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If FDragging Then
     Begin
          DrawDragFrame;
          CurDrag := Forms.Point(X,Y);
          TryDocking := Not (ssCtrl In ShiftState);
          DrawDragFrame;
     End;
End;


Procedure TDockingToolbar.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If FEnableDocking = [] Then Exit;

     If Button = mbLeft Then
     Begin
          If Not IsDocked Then
          Begin
               {check If FDockingForm In able To dock}
               If FDockingForm <> Nil Then
                 If FDockingForm.EnableDocking * [FToolAlign] <> []
                 Then DockLastPanel;
          End
          Else FloatPanel;
     End;
End;


Procedure TDockingToolbar.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     Inherited ScanEvent(KeyCode,RepeatCount);

     If FDragging Then
     Begin
       Case KeyCode Of
         kbEsc:
         Begin
              DraggingAborted := True;
              MouseUp(mbLeft,[],CurDrag.X,CurDrag.Y);
         End;
         kbCtrl:
         Begin
              MouseMove([ssCtrl],CurDrag.X,CurDrag.Y);
         End;
       End;
     End;
End;


Procedure TDockingToolbar.DrawDragFrame;
Var  rec:TRect;
     pt:TPoint;
     target:TControl;
{$IFDEF WIN32}
Procedure ScreenRect(Const rc:TRect);
Begin
     Screen.Canvas.Line(rc.Left,rc.Bottom,rc.Right,rc.Bottom);
     Screen.Canvas.Line(rc.Right,rc.Bottom,rc.Right,rc.Top);
     Screen.Canvas.Line(rc.Right,rc.Top,rc.Left,rc.Top);
     Screen.Canvas.Line(rc.Left,rc.Top,rc.Left,rc.Bottom);
End;
{$ENDIF}
Begin
     pt := CurDrag;
     pt := ClientToScreen(pt);

     target := GetDragTarget(pt, rec);

     {$IFDEF OS2}
     Screen.Canvas.Rectangle(rec);
     If target = Nil Then
     Begin
          Forms.InflateRect(rec,-1,-1);
          Screen.Canvas.Rectangle(rec);
          Forms.InflateRect(rec,-1,-1);
          Screen.Canvas.Rectangle(rec);
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     ScreenRect(rec);
     If target = Nil Then
     Begin
          Forms.InflateRect(rec,-1,-1);
          ScreenRect(rec);
          Forms.InflateRect(rec,-1,-1);
          ScreenRect(rec);
     End;
     {$ENDIF}
End;


Procedure TDockingToolbar.QueryDockingForm(Var TargetForm:TForm;Var NewAlign:TToolbarAlign);
Begin
     If TargetForm = Nil Then Exit;

     {dont drop In another Palette}
     If TargetForm.ControlCount = 1 Then
       If TargetForm.Controls[0] Is TDockingToolbar Then
       Begin
            TargetForm := Nil;
            Exit;
       End;

     If TargetForm.Designed Then
     Begin
          TargetForm := Nil;
          Exit;
     End;

     If Not (NewAlign In EnableDocking) Then
     Begin
          TargetForm := Nil;
          Exit;
     End;

     If Not (NewAlign In TargetForm.EnableDocking) Then
     Begin
          TargetForm := Nil;
          Exit;
     End;

     If FOnDocking <> Nil Then FOnDocking(Self,TargetForm,NewAlign);
End;


Function TDockingToolbar.GetDragTarget(ptScreen:TPoint;Var target:TRect):TControl;
Var  AControl:TControl;
     TargetForm:TForm;
     TargetToolbar:TDockingFrame;
     WrapWidth,WrapHeight:LongInt;
     FinalWrapHeight:LongInt;
     NewToolAlign:TToolbarAlign;
     dock:Boolean;
     horz:Boolean;
Begin
     Result := Nil;
     TargetForm := Nil;
     TargetToolbar := Nil;
     AControl := Screen.GetControlFromPoint(ptScreen);
     If AControl <> Nil Then TargetForm := AControl.Form;

     If Not TryDocking Then
     Begin
          TargetForm := Nil;
          AControl := Nil;
     End;

     If TargetForm <> Nil Then
     Begin // ignore framecontrol
          If TargetForm.Frame = AControl Then TargetForm := Nil;

          While AControl <> Nil Do
          Begin
               If AControl Is TDockingFrame Then
               Begin
                    TargetToolbar := TDockingFrame(AControl);
                    If TargetToolbar Is TDockingFrame
                    Then Result := AControl;
                    break;
               End
               Else AControl := AControl.parent;
          End;

          If AControl = Nil Then Result := TargetForm;
     End;

     If FPanelForm <> Nil Then
     Begin
          WrapWidth := FPanelForm.ClientWidth;
          WrapHeight := FPanelForm.ClientHeight;
     End;

     dock := (TargetForm <> FPanelForm) And (TargetForm <> Nil);

     NewToolAlign := FToolAlign;

     If dock Then // determine where To dock
     Begin
          If TargetToolbar <> Nil Then NewToolAlign := TargetToolbar.Alignment
          Else NewToolAlign := GetTargetToolbarAlign(TargetForm,ptScreen);
     End;

     {check If we can dock At This Alignment}
     QueryDockingForm(TargetForm, NewToolAlign);


     {target redirected -> ignore Control To Insert}
     If AControl <> Nil Then
       If AControl.Form <> TargetForm Then AControl := Nil;

     {no final target}
     If TargetForm = Nil Then Result := Nil;

     {Test again}
     dock := (TargetForm <> FPanelForm) And (TargetForm <> Nil);

     horz := NewToolAlign In [tbTop,tbBottom];

     // determine the New Size Of the Panel
     GetWrappedSize(dock, horz, WrapWidth, WrapHeight);

     // Add Titlebar Size
     FinalWrapHeight := WrapHeight;
     If Not dock Then Inc(FinalWrapHeight, PanelTitleHeight);

     If (IsDocked And (NewToolAlign <> FToolAlign)) Or
        (IsDocked <> dock) Or
        (InitDrag.X > WrapWidth) Or
        (InitDrag.Y > FinalWrapHeight) Then
     Begin {re-centre the dragframe}
          ptScreen.X := ptScreen.X - (WrapWidth Div 2) + InitDrag.X;
          ptScreen.Y := ptScreen.Y - (WrapHeight Div 2) + InitDrag.Y;
     End;

     {dragframe}
     target := Forms.Rect(ptScreen.X, ptScreen.Y,
                          ptScreen.X + WrapWidth, ptScreen.Y + WrapHeight);

     Forms.OffsetRect(target, -InitDrag.X, -InitDrag.Y);

     If Not dock Then // Add Form Frame sizes
     Begin
          Dec(target.Left, PanelBorderSizeX);
          Inc(target.Right, PanelBorderSizeX);
          Dec(target.Bottom, PanelBorderSizeY);
          Inc(target.Top, PanelBorderSizeY);
          Inc(target.Top, PanelTitleHeight);
     End;
End;


Function TDockingToolbar.GetTargetToolbarAlign(TargetForm:TForm; ptScreen:TPoint):TToolbarAlign;
Var  crect:TRect;
     Min:LongInt;
     ptForm:TPoint;
Begin
     Result := FToolAlign;

     If TargetForm <> Nil Then
     Begin // Get possible Toolbar Alignment
          ptForm := TargetForm.ScreenToClient(ptScreen);
          crect := TargetForm.ClientRect;

          Min := ptForm.X;
          Result := tbLeft;
          If crect.Right - ptForm.X < Min Then
          Begin
               Min := crect.Right - ptForm.X;
               Result := tbRight;
          End;
          If ptForm.Y < Min Then
          Begin
               Min := ptForm.Y;
               Result := tbBottom;
          End;
          If crect.Top - ptForm.Y < Min Then
          Begin
               Min := crect.Top - ptForm.Y;
               Result := tbTop;
          End;
     End;
End;


Const
     AligningPanels:Boolean=False;


Procedure TDockingToolbar.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Var  ParentToolbar:TDockingFrame;
     AControl:TControl;
     horz:Boolean;
     I,S:LongInt;
     APos,ASize:LongInt;
     MaxPos:LongInt;
     ASort:TControl;
     ASortPos:LongInt;
     SortList:TList;
     inserted:Boolean;
     moved:Boolean;
Begin
     If IsDocked And (Not AligningPanels) Then // prevent overlapping
     Begin
          AligningPanels := True;

          ParentToolbar := TDockingFrame(parent);
          horz := ParentToolbar.Alignment In [tbTop,tbBottom];
          SortList.Create;

          {Sort the Panels}
          For I := 0 To ParentToolbar.ControlCount-1 Do
          Begin
               AControl := ParentToolbar.Controls[I];
               If csDetail In AControl.ComponentState Then continue;

               If AControl = Self Then // Use the New Parameter
               Begin
                    If horz Then APos := NewLeft
                    Else APos := NewBottom;
               End
               Else
               Begin
                    If horz Then APos := AControl.Left
                    Else APos := AControl.Bottom;
               End;

               {Insert In the sorted List}
               inserted := False;
               For S := 0 To SortList.Count-1 Do
               Begin
                    ASort := TControl(SortList[S]);
                    If ASort = Self Then // Use the New Parameter
                    Begin
                         If horz Then ASortPos := NewLeft
                         Else ASortPos := NewBottom;
                    End
                    Else
                    Begin
                         If horz Then ASortPos := ASort.Left
                         Else ASortPos := ASort.Bottom;
                    End;

                    If APos < ASortPos Then
                    Begin
                         SortList.Insert(S, AControl);
                         inserted := True;
                         break;
                    End;
               End;
               If Not inserted Then SortList.Add(AControl);
          End;


          {Arrange the Panels}
          MaxPos := 0;
          For I := 0 To SortList.Count-1 Do
          Begin
               AControl := TControl(SortList[I]);
               If AControl = Self Then // Use the New Parameter
               Begin
                    If horz Then
                    Begin
                         APos := NewLeft;
                         ASize := NewWidth;
                    End
                    Else
                    Begin
                         APos := NewBottom;
                         ASize := NewHeight;
                    End;
               End
               Else
               Begin
                    If horz Then
                    Begin
                         APos := AControl.Left;
                         ASize := AControl.Width;
                    End
                    Else
                    Begin
                         APos := AControl.Bottom;
                         ASize := AControl.Height;
                    End;
               End;

               If APos < MaxPos Then APos := MaxPos;

               If AControl = Self Then
               Begin {Arrange Self With Inherited}
                    If horz Then NewLeft := APos
                    Else NewBottom := APos;
               End
               Else
               Begin
                    If horz Then
                    Begin
                         moved := AControl.Left <> APos;
                         AControl.Left := APos;
                    End
                    Else
                    Begin
                         moved := AControl.Bottom <> APos;
                         AControl.Bottom := APos;
                    End;

                    If moved Then
                      If AControl Is TDockingToolbar
                      Then TDockingToolbar(AControl).Change;
               End;

               MaxPos := APos + ASize;
          End;


          SortList.Destroy;
          AligningPanels := False;
     End;

     Inherited SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);

     If IsDocked Then
     Begin
          LastDockLeft := Left;
          LastDockBottom := Bottom;
          LastDockWidth := Width;
          LastDockHeight := Height;
     End;
End;


/////////////////////////////////////////////////////////////

Type
    TPosition=Record
         Left,Bottom,Width,Height:LongInt;
    End;

    TDockingData=Record
         DataSize:LongInt;
         PanelName:String[64];
         PanelPosition:TPosition;
         PanelAlign:TToolbarAlign;
         DockName:String[64];
         DockOrder:LongInt;
         DockingState:TDockingState;
         FormName:String[64];
         FormPosition:TPosition;
    End;


Procedure WriteDockingToolbars;
Var  I:LongInt;
     ADockTool:TDockingToolbar;
     AToolbar:TDockingFrame;
     Data:TDockingData;
     PanelForm:TForm;
     iniName,ext:String;
     F:File Of TDockingData;
Begin
     iniName := goSysInfo.ProgramInfo.ExeName; // ParamStr(0);
     ext := ExtractFileExt(iniName);
     SetLength(iniName, Length(iniName) - Length(ext));
     iniName := iniName + '.dtb';

     {$I-}
     Assign(F, iniName);
     Rewrite(F);

     Data.DataSize := SizeOf(TDockingData);

     Try
        For I := 0 To DockingList.Count-1 Do
        Begin
             ADockTool := TDockingToolbar(DockingList[I]);

             PanelForm := ADockTool.FPanelForm;
             Data.FormName := PanelForm.Name;

             Data.FormPosition.Left := PanelForm.Left;
             Data.FormPosition.Bottom := PanelForm.Bottom;
             Data.FormPosition.Width := PanelForm.Width;
             Data.FormPosition.Height := PanelForm.Height;

             Data.PanelName := ADockTool.Name;
             Data.PanelPosition.Left := ADockTool.LastDockLeft;
             Data.PanelPosition.Bottom := ADockTool.LastDockBottom;
             Data.PanelPosition.Width := ADockTool.LastDockWidth;
             Data.PanelPosition.Height := ADockTool.LastDockHeight;
             Data.PanelAlign := ADockTool.ToolbarAlign;

             Data.DockingState := ADockTool.DockingState;

             Data.DockName := ADockTool.DockingForm.Name;
             If Data.DockingState = dsDock Then
             Begin
                  AToolbar := TDockingFrame(ADockTool.parent);
                  Data.DockOrder := AToolbar.order;
             End
             Else Data.DockOrder := -1;

             Write(F, Data);
        End;
        Close(F);
     Except
        Close(F);
        ErrorBox2('DTB Write Error');
     End;
     {$I+}
End;


Procedure ReadDockingToolbars;
Var  I,J:LongInt;
     ADockTool:TDockingToolbar;
     ATempDock:TDockingToolbar;
     AToolbar:TDockingFrame;
     AControl:TControl;
     AForm:TForm;
     Data:TDockingData;
     PanelForm:TForm;
     DockForm:TForm;
     iniName,ext:String;
     F:File Of TDockingData;
     AFormName:String;
     OwnerName:String;
Begin
     iniName := goSysInfo.ProgramInfo.ExeName; // ParamStr(0);
     ext := ExtractFileExt(iniName);
     SetLength(iniName, Length(iniName) - Length(ext));
     iniName := iniName + '.dtb';

     {$I-}
     Assign(F, iniName);
     Reset(F,1);

     AligningPanels := True;

     If IOResult = 0 Then
     While Not Eof(F) Do
     Begin
        {Read A Data Set And Find the corresponding Panel In the List}
        Read(F, Data);
        If IOResult <> 0 Then break;

        If Data.DataSize <> SizeOf(TDockingData) Then break;

        {Search Panel}
        ADockTool := Nil;

        UpcaseStr(Data.FormName);
        UpcaseStr(Data.DockName);

        For I := 0 To DockingList.Count-1 Do
        Begin
             ATempDock := TDockingToolbar(DockingList[I]);

             If ATempDock.Name = Data.PanelName Then
               If ATempDock.Owner Is TForm Then
               Begin
                    OwnerName := ATempDock.Owner.Name;
                    UpcaseStr(OwnerName);
                    If OwnerName = Data.FormName Then
                    Begin
                         ADockTool := ATempDock;
                         break;
                    End;
               End;
        End;
        If ADockTool = Nil Then continue; {no Panel found For Data}

        {Panel found - Update the Status}

        If ADockTool.Designed Then continue; {no Designed dockbars}

        PanelForm := TForm(ADockTool.Owner);
        DockForm := Nil;

        For J := 0 To Screen.FormCount-1 Do
        Begin
             AForm := Screen.Forms[J];
             If AForm.Designed Then continue;

             AFormName := AForm.Name;
             UpcaseStr(AFormName);

             If DockForm = Nil Then
               If Data.DockName = AFormName Then DockForm := AForm;
        End;

        ADockTool.UndockPanel;

        ADockTool.FPanelForm := PanelForm;
        ADockTool.DockingForm := DockForm;


        AToolbar := Nil;
        If Data.DockOrder >= 0 Then
        Begin
          If DockForm <> Nil Then
          Begin // Search the Right Toolbar In the DockForm
            For J := 0 To DockForm.ControlCount-1 Do
            Begin
              AControl := DockForm.Controls[J];
              If AControl Is TDockingFrame Then
                If TDockingFrame(AControl).Alignment = Data.PanelAlign Then
                  If TDockingFrame(AControl).DockOrder = Data.DockOrder Then
                  Begin
                       AToolbar := TDockingFrame(AControl);
                       AToolbar.DockOrder := Data.DockOrder;
                       break;
                  End;
            End;
          End;
        End;

        ADockTool.FToolAlign := Data.PanelAlign;
        ADockTool.LastDockLeft := 0;
        ADockTool.LastDockBottom := 0;


        If PanelForm <> Nil Then
        Begin
             PanelForm.SetWindowPos(Data.FormPosition.Left,
                                    Data.FormPosition.Bottom,
                                    Data.FormPosition.Width,
                                    Data.FormPosition.Height);
        End;


        If Data.DockingState = dsDock Then
        Begin
             {Set Size For non wrapped Panels}
             ADockTool.SetWindowPos(Data.PanelPosition.Left,
                                    Data.PanelPosition.Bottom,
                                    Data.PanelPosition.Width,
                                    Data.PanelPosition.Height);

             ADockTool.DockPanel(AToolbar);

             {Set New Toolbar order}
             If Data.DockOrder >= 0 Then
             Begin
                  AToolbar := TDockingFrame(ADockTool.parent);
                  AToolbar.order := Data.DockOrder;
                  AToolbar.DockOrder := Data.DockOrder;
             End;
        End;


        Case Data.DockingState Of
          dsDock:
          Begin
               {Set Size within the Toolbar}
               ADockTool.SetWindowPos(Data.PanelPosition.Left,
                                      Data.PanelPosition.Bottom,
                                      Data.PanelPosition.Width,
                                      Data.PanelPosition.Height);
          End;
          dsFloat:
          Begin
               ADockTool.FloatPanel;
          End;
          dsHide:
          Begin
               ADockTool.HidePanel;
          End;
        End;
     End;

     Close(F);
     {$I+}

     AligningPanels := False;
End;


Initialization
     DockingList.Create;
     OldTitleBarProc := Nil;

Finalization
     DockingList.Destroy;
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  09-Mar-06   WD        Paramstr(0) durch uSysInfo ersetzt.
}
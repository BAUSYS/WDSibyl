
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2005..     Ing. Wolfgang Draxler, All rights reserved.  บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
             

Unit Buttons;

Interface

{$IFDEF OS2}
Uses PmWin,BseDos;
{$ENDIF}

{$IFDEF Win32}
Uses WinUser,CommCtrl;
{$ENDIF}

Uses SysUtils,Messages,Color,Classes,Forms,Graphics,
     uString;

Type
    TButtonControl=Class(TControl)
      Private
         FOnClick:TNotifyEvent;
      Protected
         Procedure SetupComponent;Override;
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure ParentNotification(Var Msg:TMessage);Override;
         Function EvaluateShortCut(KeyCode:TKeyCode):Boolean;Override;
      Public
         Procedure Click;Virtual;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
    End;


    TRadioButton=Class(TButtonControl)
      Private
         FInitChecked:Boolean;
         Function GetChecked:Boolean;
         Procedure SetChecked(NewState:Boolean);
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure CreateWnd;Override;
      Public
         Procedure Click;Override;
      Published
         Property Align;
         Property Color;
         Property Caption;
         Property Checked:Boolean Read GetChecked Write SetChecked;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentFont;
         Property ParentPenColor;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TCheckBoxState=(cbUnchecked,cbChecked,cbGrayed);

    TCheckBox=Class(TButtonControl)
      Private
         FInitState:TCheckBoxState;
         FAllowGrayed:Boolean;
         Function GetChecked:Boolean;
         Procedure SetChecked(NewState:Boolean);
         Function GetState:TCheckBoxState;
         Procedure SetState(NewState:TCheckBoxState);
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure CreateWnd;Override;
         Procedure Toggle;Virtual;
      Public
         Procedure Click;Override;
      Published
         Property Align;
         Property AllowGrayed:Boolean Read FAllowGrayed Write FAllowGrayed;
         Property Color;
         Property Caption;
         Property Checked:Boolean Read GetChecked Write SetChecked;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowHint;
         Property State:TCheckBoxState Read GetState Write SetState;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TButton=Class(TButtonControl)
      Private
         FCancel:Boolean;
         FDefault:Boolean;
         FModalResult:TCommand;
         Procedure SetDefault(Value:Boolean);Virtual;
         Procedure SetCancel(Value:Boolean);
         Function GetFormButton(Default:Boolean):TButton;
         Procedure SetFormButton(Default:Boolean;Button:TButton);
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure SetupShow;Override;
         Procedure SetFocus;Override;
      Public
         Destructor Destroy;Override;
         Procedure Click;Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property Cancel:Boolean Read FCancel Write SetCancel;
         Property Caption;
         Property PenColor;
         Property Command;
         Property Default:Boolean Read FDefault Write SetDefault;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ModalResult:TCommand Read FModalResult Write FModalResult;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TPosSize=Record
         Left,Bottom,Width,Height:LongInt;
    End;

    {$M+}
    TButtonLayout=(blGlyphLeft,blGlyphRight,blGlyphTop,blGlyphBottom);

    TBitBtnKind=(bkCustom,bkOk,bkCancel,bkHelp,bkYes,bkNo,bkClose,
                 bkAbort,bkRetry,bkIgnore,bkAll,bkOpen,bkPrev,bkNext,
                 bkFind, bkPrint, bkNew, bkDelete, bkEdit);
    {$M-}

    TNumGlyphs=LongInt;

    TBitBtn=Class(TButton)
      Private
         bmp:TPosSize;
         txt:TPosSize;
         Int:TPosSize;
         IsBmp:Boolean;
         IsTxt:Boolean;
         IsMnemo:Boolean;
         InRedraw:Boolean;
         FDragging:Boolean;
         FDown:Boolean;
         FSpaceDown:Boolean;
         FLayout:TButtonLayout;
         FMargin:LongInt;
         FSpacing:LongInt;
         FKind:TBitBtnKind;
         FBitmap:TBitmap;
         FNumGlyphs:TNumGlyphs;
      Private
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
         {$IFDEF Win32}
         Procedure WMKeyDown(Var Msg:TMessage); Message WM_KEYDOWN;
         Procedure WMKeyUp(Var Msg:TMessage); Message WM_KEYUP;
         {$ENDIF}
         Procedure SetDefault(Value:Boolean);Override;
         Function GetDown:Boolean;Virtual;
         Procedure SetDown(Value:Boolean);Virtual;
         Procedure SetLayout(Value:TButtonLayout);
         Procedure SetMargin(Value:LongInt);
         Procedure SetSpacing(Value:LongInt);
         Procedure SetKind(Value:TBitBtnKind);
         Function GetGlyph:TBitmap;
         Procedure SetGlyph(NewBitmap:TBitmap);Virtual;
         Procedure SetNumGlyphs(NewValue:TNumGlyphs);
      Protected
         Procedure SetupComponent;Override;
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure SetupShow;Override;
         Procedure RealignControls;Override;
         Procedure FontChange;Override;
         {$IFDEF OS2}
         Procedure ParentNotification(Var Msg:TMessage);Override;
         {$ENDIF}
         Procedure DrawFrame(Down:Boolean);Virtual;
         Procedure DrawText(Const Value:String;Down:Boolean);Virtual;
         Procedure DrawBitmap(Bitmap:TBitmap;Down:Boolean);Virtual;
         Procedure Arrange;Virtual;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Property Down:Boolean Read GetDown Write SetDown;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure Click;Override;
      Published
         Property Glyph:TBitmap Read GetGlyph Write SetGlyph;
         Property Kind:TBitBtnKind Read FKind Write SetKind;
         Property Layout:TButtonLayout Read FLayout Write SetLayout;
         Property Margin:LongInt Read FMargin Write SetMargin;
         Property Spacing:LongInt Read FSpacing Write SetSpacing;
         Property NumGlyphs:TNumGlyphs read FNumGlyphs write SetNumGlyphs;
         Property OnPaint;
    End;


    TAnimatedButton=Class(TBitBtn)
      Private
         FSaveBitmap:TBitmap;
         FBitmapList:TBitmapList;
         FAnimationTimer:TTimer;
         FLastPlayItem:LongInt;
         FInterval:LongInt;
         Procedure SetInterval(Value:LongInt);
         Procedure SetGlyph(NewBitmap:TBitmap);Override;
         Procedure EvTimer(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Procedure SetupShow;Override;
         Procedure StartAnimation;
         Procedure StopAnimation;
         Procedure ResetAnimation;
         Property BitmapList:TBitmapList Read FBitmapList;
      Published
         Property Interval:LongInt Read FInterval Write SetInterval;
    End;

    TButtonState=(bsNormal,bsUp,bsDown,bsDisabled,bsExclusive);

    TSpeedButton=Class(TBitBtn)
      Private
         FIgnoreClick:Boolean;
         FState:TButtonState;
         FAllowAllUp:Boolean;
         FGroupIndex:LongInt;
      Private
         Function GetState:TButtonState;
         Procedure SetState(NewValue:TButtonState);
         {$IFDEF OS2}
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         {$ENDIF}
         Procedure UpdateExclusive;
         Procedure cmButtonPressed(Var Msg:TMessage);Message CM_BUTTONPRESSED;
         Function GetDown:Boolean;Override;
         Procedure SetDown(Value:Boolean);Override;
         Procedure SetAllowAllUp(Value:Boolean);
         Procedure SetGroupIndex(Value:LongInt);
         Property ModalResult;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         {$IFDEF OS2}
         Procedure ParentNotification(Var Msg:TMessage);Override;
         {$ENDIF}
         Procedure DrawFrame(Down:Boolean);Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Property State:TButtonState Read GetState Write SetState;
      Public
         Procedure Click;Override;
      Published
         Property AllowAllUp:Boolean Read FAllowAllUp Write SetAllowAllUp;
         Property GroupIndex:LongInt Read FGroupIndex Write SetGroupIndex;
         Property Down; {after Property GroupIndex!}
    End;


Function InsertButton(parent:TControl;Left,Bottom,Width,Height:LongInt; Caption,Hint:String):TButton;
Function InsertButtonNLS(Parent:TControl;Left,Bottom,Width,Height:Longint; Caption,Hint:Longint):TButton;
Function InsertRadioButton(parent:TControl;Left,Bottom,Width,Height:LongInt; Caption,Hint:String):TRadioButton;
Function InsertRadioButtonNLS(Parent:TControl;Left,Bottom,Width,Height:Longint; Caption,Hint:Longint):TRadioButton;
Function InsertCheckBox(parent:TControl;Left,Bottom,Width,Height:LongInt; Caption,Hint:String):TCheckBox;
Function InsertCheckBoxNLS(Parent:TControl;Left,Bottom,Width,Height,Caption,Hint:Longint):TCheckBox;
Function InsertBitBtn(parent:TControl;Left,Bottom,Width,Height:LongInt; Kind:TBitBtnKind;Caption,Hint:String):TBitBtn;
Function InsertBitBtnNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT; Kind:TBitBtnKind;Caption,Hint:LONGINT):TBitBtn;
Function InsertAnimatedButton(parent:TControl;Left,Bottom,Width,Height:LongInt; BitmapId:LongWord;Caption,Hint:String):TAnimatedButton;
Function InsertAnimatedButtonName(parent:TControl;Left,Bottom,Width,Height:LongInt; Const BitmapId:String;Caption,Hint:String):TAnimatedButton;
Function InsertSpeedButton(parent:TControl;Left,Bottom,Width,Height:LongInt; BitmapId:LongWord;Caption,Hint:String):TSpeedButton;
Function InsertSpeedButtonNLS(Parent:TControl;Left,Bottom,Width,Height:Longint; BitmapId:Longword;Caption,Hint:Longint):TSpeedButton;

Procedure SetPackedCheckBoxList(aList:Array Of TCheckBox;Value:LongWord);
Function GetPackedCheckBoxList(aList:Array Of TCheckBox):LongWord;
Procedure SetPackedRadioButtonList(aList:Array Of TRadioButton;Value:LongWord);
Function GetPackedRadioButtonList(aList:Array Of TRadioButton):LongWord;

Var ShowBitBtnGlyph:Boolean;  //Show Glyphs In BitBtns
        

Implementation         

{$R Buttons}

Const
    StdBtnCaptionIds:Array[TBitBtnKind] Of LongWord=
      (SError, SOkButton, SCancelButton, SHelpButton, SYesButton, SNoButton, SCloseButton,
       SAbortButton, SRetryButton, SIgnoreButton, SAllButton, SOpenButton,
       SPrevButton, SNextButton, SFindButton, SPrinterButton,
       SNewButton, SDeleteButton, SEditButton);

    StdBtnCmds:Array[TBitBtnKind] Of LongWord=
      (0, cmOk, cmCancel, 0, cmYes, cmNo, 0,
       cmAbort, cmRetry, cmIgnore, cmAll, cmOpen,
       cmPrevious, cmNext, cmFind, cmPrint,
       cmNew, cmDelete, cmEdit);

    StdBtnBmpIds:Array[TBitBtnKind] Of String[20]=
      ('', 'StdBmpOk', 'StdBmpCancel', 'StdBmpHelp', 'StdBmpYes', 'StdBmpNo',
       'StdBmpClose', 'StdBmpAbort', 'StdBmpRetry', 'StdBmpIgnore', 'StdBmpAll',
       'StdBmpOpen', 'StdBmpPrev', 'StdBmpNext', 'StdBmpFind','StdBmpPrinter',
       'StdBmpNew','StdBmpDelete', 'StdBmpEdit');

    btDefault:Boolean=True;
    btCancel:Boolean=False;

Var StdBtnBitmaps:Array[TBitBtnKind] Of TBitmap;

Function GetStdBtnBitmap(Kind:TBitBtnKind):TBitmap;
Var  ResId:String;
Begin
  Result := StdBtnBitmaps[Kind];
  if Result = Nil Then
    Begin
      ResId := StdBtnBmpIds[Kind];
      If ResId = '' Then Exit;

      Result.Create;
      Result.LoadFromResourceName(ResId);
      StdBtnBitmaps[Kind] := Result;
    End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC).                                บ
บ                                                                           บ
บ This section: Some useful functions                                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure SetPackedCheckBoxList(aList:Array Of TCheckBox;Value:LongWord);
Var  T:LongWord;
Begin
  For T := Low(aList) To High(aList) Do
    Begin
      aList[T].Checked := (Value And (longword(1) Shl T)) <> 0; {Martin}
    End;
End;

Function GetPackedCheckBoxList(aList:Array Of TCheckBox):LongWord;
Var  T:LongWord;
Begin
  Result := 0;
  For T := Low(aList) To High(aList) Do
    If aList[T].Checked Then
      Result := Result Or (longword(1) Shl T); {Martin}
End;

Procedure SetPackedRadioButtonList(aList:Array Of TRadioButton;Value:LongWord);
Var  T:LongWord;
Begin
     For T := Low(aList) To High(aList) Do
     Begin
          aList[T].Checked := Value = T;
     End;
End;
        
Function GetPackedRadioButtonList(aList:Array Of TRadioButton):LongWord;
Var  T:LongWord;
Begin
     Result := 0;
     For T := Low(aList) To High(aList) Do
        If aList[T].Checked Then Result := T;
End;


Function InsertButton(parent:TControl;Left,Bottom,Width,Height:LongInt;Caption,Hint:String):TButton;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.Caption := Caption;
  Result.TabStop := True;
  Result.Hint := Hint;
  Result.parent := parent;
End;

Function InsertButtonNLS(Parent:TControl;Left,Bottom,Width,Height:Longint; Caption,Hint:Longint):TButton;

Begin
  Result:=InsertButton(parent, Left, Bottom, Width, Height,
             LoadNLSStr(Caption),
             iif(HInt=0, '', LoadNLSStr(Hint)));
End;

Function InsertRadioButton(parent:TControl;Left,Bottom,Width,Height:LongInt;Caption,Hint:String):TRadioButton;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.TabStop := True;
     Result.Hint := Hint;
     Result.parent := parent;
End;

Function InsertRadioButtonNLS(Parent:TControl;Left,Bottom,Width,Height:Longint; Caption,Hint:Longint):TRadioButton;

Begin
  Result:=InsertRadioButton(parent, Left, Bottom, Width, Height,
             LoadNLSStr(Caption),
             iif(HInt=0, '', LoadNLSStr(Hint)));
End;


Function InsertCheckBox(parent:TControl;Left,Bottom,Width,Height:LongInt;Caption,Hint:String):TCheckBox;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.Caption := Caption;
  Result.TabStop := True;
  Result.Hint := Hint;
  Result.parent := parent;
End;

Function InsertCheckBoxNLS(Parent:TControl;Left,Bottom,Width,Height,Caption,Hint:Longint):TCheckBox;

Begin
  Result:=InsertCheckBox(parent, Left, Bottom, Width, Height,
             LoadNLSStr(Caption),
             iif(HInt=0, '', LoadNLSStr(Hint)));
End;

Function InsertBitBtn(parent:TControl;Left,Bottom,Width,Height:LongInt;Kind:TBitBtnKind;Caption,Hint:String):TBitBtn;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.TabStop := True;
  Result.Hint := Hint;
  Result.parent := parent;
  Result.Kind := Kind;
  Result.Caption := Caption;
End;

Function InsertBitBtnNLS(Parent:TControl;Left,Bottom,Width,Height:Longint;Kind:TBitBtnKind;Caption,Hint:Longint):TBitBtn;

Begin
  Result:=InsertBitBtn(parent, Left, Bottom, Width, Height, Kind,
             LoadNLSStr(Caption),
             iif(HInt=0, '', LoadNLSStr(Hint)));
End;


Function InsertAnimatedButton(parent:TControl;Left,Bottom,Width,Height:LongInt;BitmapId:LongWord;Caption,Hint:String):TAnimatedButton;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.TabStop := True;
     Result.Hint := Hint;
     If BitmapId <> 0 Then Result.Glyph.LoadFromResourceId(BitmapId);
     Result.parent := parent;
End;

Function InsertAnimatedButtonName(parent:TControl;Left,Bottom,Width,Height:LongInt;Const BitmapId:String;Caption,Hint:String):TAnimatedButton;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.TabStop := True;
     Result.Hint := Hint;
     If BitmapId <> '' Then Result.Glyph.LoadFromResourceName(BitmapId);
     Result.parent := parent;
End;


Function InsertSpeedButton(parent:TControl;Left,Bottom,Width,Height:LongInt;BitmapId:LongWord;Caption,Hint:String):TSpeedButton;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.TabStop := False;
     Result.Hint := Hint;
     If BitmapId <> 0 Then Result.Glyph.LoadFromResourceId(BitmapId);
     Result.parent := parent;
End;

Function InsertSpeedButtonNLS(Parent:TControl;Left,Bottom,Width,Height:Longint;BitmapId:Longword;Caption,Hint:Longint):TSpeedButton;

Begin
  Result:=InsertSpeedButton(parent, Left, Bottom, Width, Height, BitmapID,
             LoadNLSStr(Caption), 
             iif(HInt=0, '', LoadNLSStr(Hint)));
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC).                                บ
บ                                                                           บ
บ This section: TButtonControl Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TButtonControl.SetupComponent;
Begin
     Inherited SetupComponent;

     Height := 30;
     Width := 80;
     Ownerdraw := False;
     PenColor := clBtnText;
     Color := clBtnFace;
     ParentPenColor := False;
     ParentColor := False;
End;


Procedure TButtonControl.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF OS2}
     ClassData.ClassULong := WC_BUTTON;
     {$ENDIF}
     {$IFDEF Win32}
     CreateSubClass(ClassData,'BUTTON');
     {$ENDIF}
End;

Procedure TButtonControl.ParentNotification(Var Msg:TMessage);
Begin
     Inherited ParentNotification(Msg);

     If Designed Then Exit;

     {$IFDEF OS2}
     If Msg.Param1Hi In [BN_CLICKED,BN_DBLCLICKED] Then
     {$ENDIF}
     {$IFDEF Win32}
     If Msg.Param1Hi In [BN_CLICKED,BN_DOUBLECLICKED] Then
     {$ENDIF}
     Begin
          Click;
          Msg.Handled := True;
          Msg.Result := 0;
     End;
End;


Procedure TButtonControl.Click;
Begin
     If FOnClick <> Nil Then FOnClick(Self);
End;


Function TButtonControl.EvaluateShortCut(KeyCode:TKeyCode):Boolean;
Var  S:String;
     P:Integer;
     key:TKeyCode;
Begin
     S := Caption;
     P := Pos(StandardMnemoChar,S);
     If (P > 0) And (P < Length(S)) Then
     Begin
          key := (Ord(S[P+1]) Or $20) + kb_Alt + kb_Char;
          If key = KeyCode Then
          Begin
               Click;
               Result := True;
               Exit;
          End;
     End;
     Result := Inherited EvaluateShortCut(KeyCode);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC).                                บ
บ                                                                           บ
บ This section: TRadioButton Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TRadioButton.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption := Name;
     Height := 20;
     Width := 130;
     PenColor := clWindowText;
     ParentPenColor := False;
     ParentColor := True;
     FInitChecked := False;
End;


Procedure TRadioButton.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     Params.Style := Params.Style Or BS_RADIOBUTTON;
     {$ENDIF}
     {$IFDEF Win32}
     Params.Style := Params.Style Or BS_AUTORADIOBUTTON;
     {$ENDIF}
End;


Procedure TRadioButton.CreateWnd;
Begin
  Inherited CreateWnd;
  SetChecked(FInitChecked);
End;


Function TRadioButton.GetChecked:Boolean;
Var  res:Word;
Begin
     Result := FInitChecked;
     If Handle = 0 Then Exit;

     {$IFDEF OS2}
     res := WinSendMsg(Handle,BM_QUERYCHECK,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     res := SendMessage(Handle,BM_GETCHECK,0,0);
     {$ENDIF}
     Result := (res = 1);
End;


Function GetGroup(Radio:TControl):TControl;
Var  ARadioRec,AChildRec:TRect;
     AChild:TControl;
     I:LongInt;
Begin
     Result := Radio.parent;
     If Result = Nil Then Exit;

     ARadioRec := Radio.WindowRect;

     For I := 0 To Radio.parent.ControlCount-1 Do
     Begin
          AChild := Radio.parent.Controls[I];
          AChildRec := AChild.WindowRect;

          If RectInRect(ARadioRec,AChildRec) Then
          Begin
               If Result <> Radio.parent Then {Select the smallest group}
               Begin
                    If RectInRect(AChildRec,Result.WindowRect)
                    Then Result := AChild;
               End
               Else Result := AChild;
          End;
     End;
End;


Procedure DeCheckAllRadiosInGroup(actual:TControl);
Var T    : LongInt;
    group: TControl;
    Radio: TRadioButton;

Begin
  group := GetGroup(actual);
  If group = Nil Then Exit;
  For T := 0 To actual.parent.ControlCount-1 Do
    Begin
      Radio := TRadioButton(actual.parent.Controls[T]);
      If Radio Is TRadioButton Then
        If Radio <> actual Then
          If GetGroup(Radio) = group Then
            Radio.SetChecked(False);
    End;
End;

Procedure TRadioButton.SetChecked(NewState:Boolean);
Begin
  FInitChecked := NewState;
  If Handle = 0 Then Exit;
  If NewState = GetChecked Then Exit;
  If NewState = True
    Then
      Begin
        DeCheckAllRadiosInGroup(Self);
        SendMsg(Handle,BM_SETCHECK,1,0);
      End
    Else SendMsg(Handle,BM_SETCHECK,0,0)
End;

Procedure TRadioButton.Click;
Begin
  SetChecked(True);
  Inherited Click;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC).                                บ
บ                                                                           บ
บ This section: TCheckBox Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCheckBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption := Name;
     Height := 20;
     Width := 130;
     PenColor := clWindowText;
     ParentPenColor := False;
     ParentColor := True;
     FInitState := cbUnchecked;
End;

Procedure TCheckBox.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     Params.Style := Params.Style Or BS_3STATE;
End;


Procedure TCheckBox.CreateWnd;
Begin
     Inherited CreateWnd;

     SetState(FInitState);
End;


Procedure TCheckBox.Click;
Begin
     Toggle;

     Inherited Click;
End;


Procedure TCheckBox.Toggle;
Begin
     Case State Of
       cbUnchecked: If AllowGrayed Then State := cbGrayed
                    Else State := cbChecked;
       cbChecked: State := cbUnchecked;
       cbGrayed: State := cbChecked;
     End;
End;


Procedure TCheckBox.SetChecked(NewState:Boolean);
Begin
     If NewState Then State := cbChecked
     Else State := cbUnchecked;
End;


Function TCheckBox.GetChecked:Boolean;
Begin
     Result := State = cbChecked;
End;


Procedure TCheckBox.SetState(NewState:TCheckBoxState);
Begin
     FInitState := NewState;
     If NewState = GetState Then Exit;
     If Handle = 0 Then Exit;
     SendMsg(Handle,BM_SETCHECK,LongWord(FInitState),0);
End;


Function TCheckBox.GetState:TCheckBoxState;
Var  res:Word;
Begin
     Result := FInitState;
     If Handle = 0 Then Exit;

     {$IFDEF OS2}
     res := WinSendMsg(Handle,BM_QUERYCHECK,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     res := SendMessage(Handle,BM_GETCHECK,0,0);
     {$ENDIF}
     Result := TCheckBoxState(res);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC).                                บ
บ                                                                           บ
บ This section: TButton Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TButton.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption := Name;
     Height := 30;
     Width := 80;               
     PenColor := clBtnText;
     Color := clBtnFace;
     ParentPenColor := False;
     ParentColor := False;
     FDefault := False;
End;

Procedure TButton.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     Params.Style := Params.Style Or BS_PUSHBUTTON;
     If FDefault Then Params.Style := Params.Style Or BS_DEFAULT;
     {$ENDIF}
     {$IFDEF Win32}
     If FDefault Then Params.Style := Params.Style Or BS_DEFPUSHBUTTON
     Else Params.Style := Params.Style Or BS_PUSHBUTTON;
     {$ENDIF}
End;


Procedure TButton.SetupShow;
Begin
     Inherited SetupShow;
     SetDefault(FDefault);  {Update the Form}
     SetCancel(FCancel);    {Update the Form}
End;


Procedure TButton.SetFocus;
Begin
     Inherited SetFocus;
     SetDefault(True);
End;


Procedure TButton.SetDefault(Value:Boolean);
Var  DefBtn:TButton;
Begin
     FDefault := Value;
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSendMsg(Handle,BM_SETDEFAULT,LongWord(FDefault),0);
          {$ENDIF}
          {$IFDEF Win32}
          If FDefault Then SendMessage(Handle,BM_SETSTYLE,BS_DEFPUSHBUTTON,1)
          Else SendMessage(Handle,BM_SETSTYLE,BS_PUSHBUTTON,1);
          {$ENDIF}
     End;

     If Form Is TForm Then
     Begin
          DefBtn := GetFormButton(btDefault);
          If FDefault Then
          Begin
               If DefBtn Is TButton Then
                 If DefBtn <> Self Then DefBtn.Default := False;

               SetFormButton(btDefault,Self);
          End
          Else If DefBtn = Self Then SetFormButton(btDefault,Nil);
     End;
End;


Procedure TButton.SetCancel(Value:Boolean);
Var  EscBtn:TButton;
Begin
     FCancel := Value;

     If Form Is TForm Then
     Begin
          EscBtn := GetFormButton(btCancel);
          If FCancel Then
          Begin
               If EscBtn Is TButton Then
                 If EscBtn <> Self Then EscBtn.Cancel := False;

               SetFormButton(btCancel,Self);
          End
          Else If EscBtn = Self Then SetFormButton(btCancel,Nil);;
     End;
End;


Destructor TButton.Destroy;
Begin
     If Form Is TForm Then
     Begin
          If GetFormButton(btDefault) = Self Then SetFormButton(btDefault,Nil);
          If GetFormButton(btCancel) = Self Then SetFormButton(btCancel,Nil);
     End;
     Inherited Destroy;
End;


Procedure TButton.Click;
Begin
     Inherited Click;

     If parent <> Nil Then
     Begin
          If ComponentState * [csDetail] = [] Then
          Begin
               If Form <> Nil Then
               Begin
                    If ModalResult<>cmNull Then
                      Form.ModalResult := ModalResult;
                    {force To Handle the modal Result}
                    SendMsg(Form.Handle,CM_COMMAND,Command{cmNull},0);
               End;
          End
          Else SendMsg(parent.Handle,CM_COMMAND,Command,0)
     End;
End;


Function TButton.GetFormButton(Default:Boolean):TButton;
Var  mp1:LongWord;
Begin
     Result := Nil;
     If Form <> Nil Then
     Begin
          If Default Then mp1 := 3
          Else mp1 := 4;
          Result := TButton(Form.Perform(CM_UPDATEBUTTONS,mp1,0));
     End;
End;


Procedure TButton.SetFormButton(Default:Boolean;Button:TButton);
Var  mp1:LongWord;
Begin
     If Form <> Nil Then
     Begin
          If Default Then mp1 := 1
          Else mp1 := 2;
          Form.Perform(CM_UPDATEBUTTONS,mp1,LongWord(Button));
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC).                                บ
บ                                                                           บ
บ This section: TBitBtn Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBitBtn.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption := Name;
     Height := 30;
     Width := 100;
     PenColor := clBtnText;
     color := clBtnFace;
     Ownerdraw := True;
     FBitmap := Nil;
     FDown := False;
     FSpaceDown := False;
     FLayout := blGlyphLeft;
     FMargin := -1;
     FSpacing := 4;
     FKind := bkCustom;
     InRedraw := False;
     FNumGlyphs:=1;
End;


Procedure TBitBtn.SetNumGlyphs(NewValue:TNumGlyphs);
Begin
     If NewValue<0 Then NewValue:=1
     Else If NewValue>4 Then NewValue:=4;
     If NewValue=FNumGlyphs Then exit;
     FNumGlyphs:=NewValue;
     Arrange;
     Invalidate;
End;


Procedure TBitBtn.GetClassData(Var ClassData:TClassData);
Begin
     {$IFDEF OS2}
     Inherited GetClassData(ClassData);
     {$ENDIF}
     {$IFDEF Win32}
     TControl.GetClassData(ClassData);   {no WC_BUTTON !}
     {$ENDIF}
End;


Procedure TBitBtn.CreateParams(Var Params:TCreateParams);
Begin
     TControl.CreateParams(Params);

     {$IFDEF OS2}
     Params.Style := Params.Style Or BS_USERBUTTON;
     {$ENDIF}
End;


Procedure TBitBtn.SetupShow;
Begin
     Inherited SetupShow;

     Arrange;
     {force To send the Window Message}
     If FDown Then
     Begin
          FDown := False;   {dont ignore SetDown}
          SetDown(True);
     End;
End;


Destructor TBitBtn.Destroy;
Begin
     If FBitmap <> Nil Then FBitmap.Destroy;
     FBitmap := Nil;

     Inherited Destroy;
End;


Procedure TBitBtn.RealignControls;
Begin
     Arrange;
     Invalidate;
End;


Procedure TBitBtn.FontChange;
Begin
     RealignControls;

     Inherited FontChange;
End;


{$IFDEF Win32}
Procedure TBitBtn.WMKeyDown(Var Msg:TMessage);
Var  KeyCode:LongInt;
Begin
     Inherited;

     Msg.Handled := True;
     If IsControlLocked(Self) Then Exit;

     KeyCode := Msg.Param1;
     If KeyCode = VK_SPACE Then
       If Not FSpaceDown Then
     Begin
          FSpaceDown := True;
          MouseDown(mbLeft,[],0,0);
     End;
End;


Procedure TBitBtn.WMKeyUp(Var Msg:TMessage);
Var  KeyCode:LongInt;
Begin
     Inherited;

     Msg.Handled := True;
     If IsControlLocked(Self) Then Exit;

     KeyCode := Msg.Param1;
     If KeyCode = VK_SPACE Then
       If FSpaceDown Then
     Begin
          FSpaceDown := False;
          MouseUp(mbLeft,[],0,0);
     End;

     If KeyCode = VK_ESCAPE Then
       If FSpaceDown Then
     Begin
          FSpaceDown := False;
          MouseUp(mbLeft,[],-1,-1);  {no Click}
     End;
End;
{$ENDIF}


{$IFDEF OS2}
Procedure TBitBtn.ParentNotification(Var Msg:TMessage);
Var  pUserBtn:PUSERBUTTON;
Begin
     TControl.ParentNotification(Msg);

     If Designed Then Exit;

     Case Msg.Param1Hi Of
       BN_CLICKED:
       Begin
            {OS2: Param2 Contains the Handle, If the Message was WM_CONTROL
                  To avoid duplicate Click only Use the WM_COMMAND event}
            If Msg.Param2 <> 0 Then Exit;
            Click;
       End;
       BN_PAINT:
       Begin
            pUserBtn := Pointer(Msg.Param2);
            FDefault := (pUserBtn^.fsState And BDS_DEFAULT) <> 0;
            Paint(ClientRect);
       End;
     End;
     Msg.Handled := True;
     Msg.Result := 0;
End;
{$ENDIF}

Procedure TBitBtn.Arrange;
Var  space:LongInt;
     rc1:TRect;
     S,S1,S2:String;
     P:Integer;
     FBmp:TBitmap;
     CX,CY:LongInt;
Begin
     If Canvas = Nil Then Exit;
     rc1 := ClientRect;
     Inc(rc1.Right);
     Inc(rc1.Top);
     {Size Of the Output String}
     S := Caption;
     P := Pos(StandardMnemoChar,S);
     IsMnemo := (P > 0) And (P < Length(S));
     If IsMnemo Then
     Begin
          s1 := S;
          {Draw normal portion}
          s2 := Copy(s1,1,P-1);
          Delete(s1,1,P);   {incl. mnemo}
          Canvas.GetTextExtent(s2,CX,CY);
          txt.Width:=CX;
          txt.Height:=CY;

          {Draw underlines portion}
          s2 := Copy(s1,1,1);    {mnemo char}
          Delete(s1,1,1);
          Canvas.GetTextExtent(s2,CX,CY);
          inc(txt.Width,CX);
          If CY>txt.Height Then txt.Height:=CY;

          {Draw rest portion}
          s2 := s1;
          Canvas.GetTextExtent(s2,CX,CY);
          inc(txt.Width,CX);
          If CY>txt.Height Then txt.Height:=CY;

          Delete(S,P,1); {Delete mnemo}
     End
     Else Canvas.GetTextExtent(S,txt.Width,txt.Height);
     IsTxt := S <> '';

     If FKind = bkCustom Then FBmp := FBitmap
     Else FBmp := GetStdBtnBitmap(FKind);

     IsBmp := False;
     bmp.Width := 0;
     bmp.Height := 0;
     If ShowBitBtnGlyph Or (ClassType <> TBitBtn) Or Designed Then
       If FBmp <> Nil Then
         If Not FBmp.Empty Then
         Begin
              IsBmp := True;
              bmp.Width := FBmp.Width Div NumGlyphs;
              bmp.Height := FBmp.Height;
         End;

     If IsBmp And IsTxt Then space := FSpacing
     Else space := 0;

     If IsBmp Or IsTxt Then
     Case FLayout Of
       blGlyphLeft:
       Begin
            {determine full Size}
            Int.Width := bmp.Width + space + txt.Width;

            If bmp.Height > txt.Height Then Int.Height := bmp.Height
            Else Int.Height := txt.Height;

            Int.Bottom := ((rc1.Top - rc1.Bottom) - Int.Height) Div 2;

            If FMargin >= 0 Then Int.Left := FMargin
            Else Int.Left := ((rc1.Right - rc1.Left) - Int.Width) Div 2;

            If IsBmp Then
            Begin
                 bmp.Left := Int.Left;
                 bmp.Bottom := Int.Bottom;
                 If bmp.Height < txt.Height
                 Then Inc(bmp.Bottom, (txt.Height - bmp.Height) Div 2);
            End;
            If IsTxt Then
            Begin
                 txt.Left := Int.Left + bmp.Width + space;
                 txt.Bottom := Int.Bottom;
                 If txt.Height < bmp.Height
                 Then Inc(txt.Bottom, (bmp.Height - txt.Height) Div 2);
            End;
       End;
       blGlyphRight:
       Begin
            {determine full Size}
            Int.Width := bmp.Width + space + txt.Width;

            If bmp.Height > txt.Height Then Int.Height := bmp.Height
            Else Int.Height := txt.Height;

            Int.Bottom := ((rc1.Top - rc1.Bottom) - Int.Height) Div 2;

            If FMargin >= 0 Then Int.Left := rc1.Right - Int.Width - FMargin
            Else Int.Left := ((rc1.Right - rc1.Left) - Int.Width) Div 2;

            If IsTxt Then
            Begin
                 txt.Left := Int.Left;
                 txt.Bottom := Int.Bottom;
                 If txt.Height < bmp.Height
                 Then Inc(txt.Bottom, (bmp.Height - txt.Height) Div 2);
            End;
            If IsBmp Then
            Begin
                 bmp.Left := Int.Left + txt.Width + space;
                 bmp.Bottom := Int.Bottom;
                 If bmp.Height < txt.Height
                 Then Inc(bmp.Bottom, (txt.Height - bmp.Height) Div 2);
            End;
       End;
       blGlyphTop:
       Begin
            {determine full Size}
            Int.Height := bmp.Height + space + txt.Height;

            If bmp.Width > txt.Width Then Int.Width := bmp.Width
            Else Int.Width := txt.Width;

            Int.Left := ((rc1.Right - rc1.Left) - Int.Width) Div 2;

            If FMargin >= 0 Then Int.Bottom := rc1.Top - Int.Height - FMargin
            Else Int.Bottom := ((rc1.Top - rc1.Bottom) - Int.Height) Div 2;

            If IsTxt Then
            Begin
                 txt.Left := Int.Left;
                 txt.Bottom := Int.Bottom;
                 If txt.Width < bmp.Width
                 Then Inc(txt.Left, (bmp.Width - txt.Width) Div 2);
            End;
            If IsBmp Then
            Begin
                 bmp.Left := Int.Left;
                 bmp.Bottom := Int.Bottom + txt.Height + space;
                 If bmp.Width < txt.Width
                 Then Inc(bmp.Left, (txt.Width - bmp.Width) Div 2);
            End;
       End;
       blGlyphBottom:
       Begin
            {determine full Size}
            Int.Height := bmp.Height + space + txt.Height;

            If bmp.Width > txt.Width Then Int.Width := bmp.Width
            Else Int.Width := txt.Width;

            Int.Left := ((rc1.Right - rc1.Left) - Int.Width) Div 2;

            If FMargin >= 0 Then Int.Bottom := FMargin
            Else Int.Bottom := ((rc1.Top - rc1.Bottom) - Int.Height) Div 2;

            If IsBmp Then
            Begin
                 bmp.Left := Int.Left;
                 bmp.Bottom := Int.Bottom;
                 If bmp.Width < txt.Width
                 Then Inc(bmp.Left, (txt.Width - bmp.Width) Div 2);
            End;
            If IsTxt Then
            Begin
                 txt.Left := Int.Left;
                 txt.Bottom := Int.Bottom + bmp.Height + space;
                 If txt.Width < bmp.Width
                 Then Inc(txt.Left, (bmp.Width - txt.Width) Div 2);
            End;
       End;
     End;
End;


Procedure TBitBtn.Redraw(Const rec:TRect);
Begin
     If Canvas = Nil Then Exit;
     If InRedraw Then Exit;
     InRedraw := True; {MnemoString causes recursive Redraw}

     If Canvas.ClipRect <> rec Then Canvas.ClipRect := rec; {manual call}

     DrawFrame(Down);

     If IsTxt Then DrawText(Caption,Down);

     If IsBmp Then
     Begin
          If FKind = bkCustom Then DrawBitmap(Glyph,Down)
          Else DrawBitmap(GetStdBtnBitmap(FKind),Down);
     End;

     Inherited Redraw(rec);

     Canvas.DeleteClipRegion;
     InRedraw := False;
End;


Procedure TBitBtn.DrawFrame(Down:Boolean);
Var  rc1:TRect;
Begin
     rc1 := ClientRect;
     DrawButtonFrame(Self,rc1,Down,Default,HasFocus And Enabled);
     Canvas.ClipRect := IntersectRect(Canvas.ClipRect,rc1);
End;


Procedure TBitBtn.DrawText(Const Value:String;Down:Boolean);
Var  rc1:TRect;
Begin
     Canvas.Brush.Color := Color;

     rc1.Left := txt.Left;
     rc1.Bottom := txt.Bottom;
     If Down Then
     Begin
          Inc(rc1.Left);
          Dec(rc1.Bottom);
     End;

     rc1.Right := rc1.Left + txt.Width -1;
     Canvas.Brush.Mode:=bmOpaque;
     rc1.Top := rc1.Bottom + txt.Height -1;
     If not Enabled Then
     Begin
          inc(rc1.Left);
          dec(rc1.Bottom);
          Canvas.Pen.Color:=clWhite;
          If IsMnemo Then Canvas.MnemoTextOut(rc1.Left,rc1.Bottom, Value)
          Else Canvas.TextOut(rc1.Left,rc1.Bottom, Value);
          Canvas.Pen.Color:=clDkGray;
          dec(rc1.Left);
          inc(rc1.Bottom);
     End
     Else Canvas.Pen.Color:=PenColor;
     If IsMnemo Then Canvas.MnemoTextOut(rc1.Left,rc1.Bottom, Value)
     Else Canvas.TextOut(rc1.Left,rc1.Bottom, Value);
     Canvas.Brush.Mode:=bmOpaque;
     If not Enabled Then
     Begin
          inc(rc1.Right);
          dec(rc1.Bottom);
     End;
     Canvas.ExcludeClipRect(rc1);
End;


Procedure TBitBtn.DrawBitmap(Bitmap:TBitmap;Down:Boolean);
// Zeichnet den Button

Var rc1,Dest:TRect;
    rc : trect;
    clr: tColor;

Begin
  rc1.Left := bmp.Left;
  rc1.Bottom := bmp.Bottom;
  If Down Then If NumGlyphs<3 Then
  Begin
       Inc(rc1.Left);
       Dec(rc1.Bottom);
  End;
  rc1.Right := rc1.Left + bmp.Width;
  rc1.Top := rc1.Bottom + bmp.Height;

  If Enabled Then
  Begin
       If ((NumGlyphs>2)And(Down)) Then
       Begin
            Dest.Left:=bmp.Width*2;
            Dest.Bottom:=0;
            Dest.Right:=Dest.Left+bmp.Width-1;
            Dest.Top:=bmp.Height;
            Bitmap.PartialDraw(Canvas,Dest,rc1);
       End
       Else Canvas.Draw(rc1.Left,rc1.Bottom,Bitmap)
  End
  Else
  Begin
       If NumGlyphs>1 Then
       Begin
            Dest.Left:=bmp.Width;
            Dest.Bottom:=0;
            Dest.Right:=Dest.Left+bmp.Width-1;
            Dest.Top:=bmp.Height;
            Bitmap.PartialDraw(Canvas,Dest,rc1);
       End
       Else Bitmap.DrawDisabled(Canvas,rc1);
  End;

  Dec(rc1.Right);
  Dec(rc1.Top);
  Canvas.ExcludeClipRect(rc1);

// Konvertieren der Transparentfarbe in die Farbe vom Button.
  rc.left:=0;
  rc.bottom:=0;
  rc.right:=Bitmap.Width;
  rc.Top  :=Bitmap.Height;

// Wenn die Transparentfarbe nicht definiert ist, dann die Farbe von der
// linken obere Ecke nehmen
  if Bitmap.TransparentColor in [clTCNotDefined,0]
    then Bitmap.TransparentColor:=Bitmap.Canvas.Pixels[0,rc.top-1];  // Linke obere Ecke
  Bitmap.Canvas.ChangeColor(rc, Bitmap.TransparentColor, Color)
End;


Procedure TBitBtn.SetDefault(Value:Boolean);
Begin
     Inherited SetDefault(Value);

     Paint(ClientRect);
End;


Function TBitBtn.GetDown:Boolean;
Begin
     Result := FDown;
     {$IFDEF OS2}
     If Handle <> 0 Then Result := Boolean(WinSendMsg(Handle,BM_QUERYHILITE,0,0));
     {$ENDIF}
End;


Procedure TBitBtn.SetDown(Value:Boolean);
Begin
     If FDown = Value Then Exit;
     FDown := Value;
     {$IFDEF OS2}
     If Handle <> 0 Then WinSendMsg(Handle,BM_SETHILITE,LongWord(FDown),0);
     {$ENDIF}
     {$IFDEF Win32}
     Paint(ClientRect);
     {$ENDIF}
End;


Procedure TBitBtn.SetLayout(Value:TButtonLayout);
Begin
     If FLayout <> Value Then
     Begin
          FLayout := Value;
          Arrange;
          Invalidate;
     End;
End;


Procedure TBitBtn.SetMargin(Value:LongInt);
Begin
     If FMargin <> Value Then
     Begin
          FMargin := Value;
          Arrange;
          Invalidate;
     End;
End;


Procedure TBitBtn.SetSpacing(Value:LongInt);
Begin
     If FSpacing <> Value Then
       If FSpacing >= 0 Then
       Begin
            FSpacing := Value;
            Arrange;
            Invalidate;
       End;
End;


Procedure TBitBtn.SetKind(Value:TBitBtnKind);
Begin
  If FKind <> Value Then
    Begin
      FKind := Value;
      If FKind <> bkCustom Then
        Begin
          If ComponentState * [csReading] = [] Then
            Begin
              If FKind=bkCustom Then Caption:=''
              Else Caption:= LoadNLSStr(StdBtnCaptionIds[FKind]);
              Command     := StdBtnCmds[FKind];     {For SpeedButtons}
              ModalResult := StdBtnCmds[FKind]; {For Buttons...}

              Default:= FKind In [bkOk,bkYes];
              Cancel := FKind In [bkCancel,bkNo];
            End;

          If FBitmap <> Nil Then FBitmap.Destroy; {!}
          FBitmap := Nil;
        End;
      Arrange;
      Invalidate;
    End;
End;


Procedure TBitBtn.SetGlyph(NewBitmap:TBitmap);
Var  OldBitmap:TBitmap;
Begin
     OldBitmap := FBitmap;

     {Create internal Copy}
     If NewBitmap <> Nil Then FBitmap := NewBitmap.Copy
     Else FBitmap := Nil;

     If FBitmap <> Nil Then Include(FBitmap.ComponentState, csDetail);

     If OldBitmap <> Nil Then
       If OldBitmap <> NewBitmap Then OldBitmap.Destroy;

     Kind := bkCustom; {!}

     Arrange;
     Invalidate;
End;


Function TBitBtn.GetGlyph:TBitmap;
Begin
     If FBitmap = Nil Then
     Begin
          FBitmap.Create;
          Include(FBitmap.ComponentState, csDetail);
     End;
     Result := FBitmap;
End;


{$HINTS OFF}
Procedure TBitBtn.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     {$IFDEF Win32}
     If Self Is TSpeedButton Then exit;
     If Button = mbLeft Then
     Begin
          Focus;
          FDown := True;
          Default := True;
          Paint(ClientRect);
          FDragging := True;
          MouseCapture := True;
     End;
     {$ENDIF}
End;


Procedure TBitBtn.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
{$IFDEF Win32}
Var  NewDown:Boolean;
{$ENDIF}
Begin
     Inherited MouseMove(ShiftState,X,Y);

     {$IFDEF Win32}
     If Self Is TSpeedButton Then exit;
     If Not FDragging Then Exit;
     NewDown := PointInRect(Point(X,Y),ClientRect);

     If NewDown <> FDown Then
     Begin
          FDown := NewDown;
          Paint(ClientRect);
     End;
     {$ENDIF}
End;


Procedure TBitBtn.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     {$IFDEF Win32}
     If Self Is TSpeedButton Then exit;
     If Button = mbLeft Then
     Begin
          If Not FDragging Then Exit;
          FDragging := False;
          FDown := False;
          Paint(ClientRect);
          MouseCapture := False;
          If PointInRect(Point(X,Y),ClientRect) Then Click;
     End;
     {$ENDIF}
End;


Procedure TBitBtn.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     {$IFDEF Win32}
     If Button = mbLeft Then
     Begin
          MouseDown(Button,ShiftState,X,Y);
     End;
     {$ENDIF}
End;


Procedure TBitBtn.CMTextChanged(Var Msg:TMessage);
Begin
     Arrange;
     Invalidate;
End;
{$HINTS ON}


Procedure TBitBtn.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnGlyph Then
     Begin
          If DataLen <> 0 Then Glyph.ReadSCUResource(rnBitmap,Data,DataLen);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TBitBtn.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If (FBitmap <> Nil) And (ComponentState * [csDetail] = [])
     Then Result := FBitmap.WriteSCUResourceName(Stream,rnGlyph);
End;


Procedure TBitBtn.Click;
Var  Control:TControl;
Begin
     Case FKind Of {they have Not A modal Result automatically}
       bkClose:
       Begin
            If (Form <> Nil) And Not Designed Then Form.Close
            Else Inherited Click;
       End;
       bkHelp:
       Begin
            Control := Self;
            While (Control <> Nil) And (Control.HelpContext = 0)
               Do Control := Control.parent;

            If Control <> Nil Then
              Application.HHelpContext(Control.HelpContext, Control.HelpContextString)  // Martin
            Else Inherited Click;
       End;
       Else Inherited Click;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TAnimatedButton Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TAnimatedButton.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption := Name;
     FBitmapList.Create;
     FBitmapList.Duplicates := True;
     FInterval := 200;
     FSaveBitmap := Nil;
End;


Destructor TAnimatedButton.Destroy;
Begin
     StopAnimation;
     FBitmapList.Destroy;
     FBitmapList := Nil;
     FBitmap := Nil;

     Inherited Destroy;
End;


Procedure TAnimatedButton.SetupShow;
Begin
     Inherited SetupShow;

     If FBitmapList.Count > 0 Then
       If FBitmap = Nil Then Glyph := FBitmapList.First
       Else If FBitmap.Empty Then Glyph := FBitmapList.First;
End;


Procedure TAnimatedButton.SetGlyph(NewBitmap:TBitmap);
Begin
     Inherited SetGlyph(NewBitmap);

     FSaveBitmap := FBitmap;
End;


Procedure TAnimatedButton.StartAnimation;
Begin
     If FBitmapList.Count = 0 Then Exit;

     If FAnimationTimer=Nil Then
     Begin
         FAnimationTimer.Create(Self);
         Include(FAnimationTimer.ComponentState, csDetail);
         FAnimationTimer.OnTimer := EvTimer;
         FAnimationTimer.Interval := FInterval;
     End;
     FAnimationTimer.Start;
End;


Procedure TAnimatedButton.StopAnimation;
Begin
     If FAnimationTimer <> Nil Then FAnimationTimer.Stop;
End;


Procedure TAnimatedButton.ResetAnimation;
Begin
     StopAnimation;
     FLastPlayItem := 0;

     FBitmap := FSaveBitmap;
     If FBitmapList.Count > 0 Then
       If FBitmap = Nil Then Glyph := FBitmapList.First
       Else If FBitmap.Empty Then Glyph := FBitmapList.First;
     Arrange;
     Paint(ClientRect);
End;


Procedure TAnimatedButton.SetInterval(Value:LongInt);
Var WasRunning:Boolean;
Begin
     FInterval := Value;
     If FAnimationTimer <> Nil Then
     Begin
          WasRunning:=FAnimationTimer.Running;
          FAnimationTimer.Stop;
          FAnimationTimer.Interval := FInterval;
          If WasRunning Then FAnimationTimer.Start;
     End;
End;


Procedure TAnimatedButton.EvTimer(Sender:TObject);
Var  CompleteRedraw:Boolean;
     FLastBitmap:TBitmap;
Begin
     If Sender = FAnimationTimer Then
     Begin
          If FLastPlayItem >= FBitmapList.Count Then FLastPlayItem := 0;
          FLastBitmap := FBitmap;
          FBitmap := FBitmapList.Bitmaps[FLastPlayItem];

          CompleteRedraw := False;
          If (FLastBitmap <> Nil) And (FBitmap <> Nil) Then
          Begin
               If (FLastBitmap.Width <> FBitmap.Width) Or
                  (FLastBitmap.Height <> FBitmap.Height)
               Then CompleteRedraw := True;
          End
          Else
          If (FLastBitmap = Nil) Xor (FBitmap = Nil) {mutex Nil}
          Then CompleteRedraw := True;

          If CompleteRedraw Then
          Begin
               Arrange;
               Paint(ClientRect);
          End
          Else
          Begin
               If FKind = bkCustom Then DrawBitmap(Glyph,Down)
               Else DrawBitmap(GetStdBtnBitmap(FKind),Down);
          End;
          Update;
          Inc(FLastPlayItem);
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TBitBtn Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSpeedButton.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption := '';
     Height := 30;
     Width := 30;
     FAllowAllUp := False;
     CursorTabStop := False;
     TabStop := False;
     FGroupIndex := 0;
     FState := bsNormal;
     FDragging := False;
     FIgnoreClick := False;
End;


Function TSpeedButton.GetState:TButtonState;
Begin
     If not Enabled Then Result:=bsDisabled
     Else Result:=FState;
End;


Procedure TSpeedButton.SetState(NewValue:TButtonState);
Begin
     If NewValue=FState Then exit;
     If NewValue=bsDisabled Then Enabled:=False
     Else FState:=NewValue;
End;


Procedure TSpeedButton.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     Params.Style := Params.Style Or BS_NOPOINTERFOCUS;
     {$ENDIF}
End;


{$IFDEF OS2}
Procedure TSpeedButton.WMChar(Var Msg:TWMChar);
Var  KeyCode:Word;
Begin
     Inherited;

     Msg.Handled := True;
     If IsControlLocked(Self) Then Exit;

     If Msg.KeyData And KC_VIRTUALKEY <> 0 Then {Virtual key}
     Begin
          KeyCode := Msg.VirtualKeyCode;
          If Msg.KeyData And KC_KEYUP <> 0 Then
          Begin
               If KeyCode = VK_SPACE Then
                 If FSpaceDown Then
               Begin
                    FSpaceDown := False;
                    MouseUp(mbLeft,[],0,0);
               End;

               If KeyCode = VK_ESC Then
                 If FSpaceDown Then
               Begin
                    FSpaceDown := False;
                    MouseUp(mbLeft,[],-1,-1);
               End;
          End
          Else
          Begin
               If KeyCode = VK_SPACE Then
                 If Not FSpaceDown Then
               Begin
                    FSpaceDown := True;
                    MouseDown(mbLeft,[],0,0);
               End;
          End;
     End;
End;
{$ENDIF}


{$IFDEF OS2}
Procedure TSpeedButton.ParentNotification(Var Msg:TMessage);
Var  pUserBtn:PUSERBUTTON;
Begin
     TControl.ParentNotification(Msg);

     If Designed Then Exit;

     Case Msg.Param1Hi Of
       BN_CLICKED:
       Begin
            {OS2: Param2 Contains the Handle, If the Message was WM_CONTROL
                  To avoid duplicate Click only Use the WM_COMMAND event}
            If Msg.Param2 <> 0 Then Exit;
            If Not FIgnoreClick Then Click;
            FIgnoreClick := False;
       End;
       BN_PAINT:
       Begin
            pUserBtn := Pointer(Msg.Param2);
            FDefault := (pUserBtn^.fsState And BDS_DEFAULT) <> 0;
            Paint(ClientRect);
       End;
     End;
     Msg.Handled := True;
     Msg.Result := 0;
End;
{$ENDIF}


Procedure TSpeedButton.DrawFrame(Down:Boolean);
Var  rc1:TRect;
Begin
     rc1 := ClientRect;

     If Down Then
     Begin
          Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight);
          InflateRect(rc1,-1,-1);
          Canvas.ShadowedBorder(rc1,cl3DDkShadow,clBtnHighlight);
     End
     Else
     Begin
          Canvas.ShadowedBorder(rc1,clBtnHighlight,cl3DDkShadow);
          InflateRect(rc1,-1,-1);
          Canvas.ShadowedBorder(rc1,clBtnHighlight,clBtnShadow);
     End;
     InflateRect(rc1,-1,-1);

     Canvas.ClipRect := IntersectRect(Canvas.ClipRect,rc1);
End;


Procedure TSpeedButton.UpdateExclusive;
Var  Msg:TMessage;
Begin
     If parent = Nil Then Exit;
     If FGroupIndex = 0 Then Exit;

     FillChar(Msg,SizeOf(Msg),0);
     Msg.Msg := CM_BUTTONPRESSED;
     Msg.Param1 := LongInt(Self);
     Msg.Param2 := FGroupIndex;
     Msg.Result := 0;

     Parent.BroadCast(Msg);
End;


Procedure TSpeedButton.cmButtonPressed(Var Msg:TMessage);
Var  Sender:TSpeedButton;
Begin
     Sender := TSpeedButton(Msg.Param1);
     If Not (Sender Is TSpeedButton) Then Exit;
     If Sender = Self Then Exit;
     If Msg.Param2 <> FGroupIndex Then Exit;

     If Sender.FDown And FDown Then
     Begin
          FDown := False;
          FState := bsNormal;
          {$IFDEF OS2}
          If Handle <> 0 Then WinSendMsg(Handle,BM_SETHILITE,LongWord(FDown),0);
          {$ENDIF}
          Paint(ClientRect);
     End;
     FAllowAllUp := Sender.AllowAllUp;
End;


Function TSpeedButton.GetDown:Boolean;
Begin
     Case FState Of      {Painting State}
       bsDown: Result := True;
       bsUp:   Result := False;
       Else    Result := Inherited GetDown;
     End;
End;


Procedure TSpeedButton.SetDown(Value:Boolean);
Begin
     If FGroupIndex = 0 Then Value := False;
     If FDown <> Value Then
     Begin
          If FDown And (Not FAllowAllUp) Then Exit;
          FDown := Value;
          If Value Then UpdateExclusive
          Else FState := bsNormal;
          {$IFDEF OS2}
          If Handle <> 0 Then WinSendMsg(Handle,BM_SETHILITE,LongWord(FDown),0);
          {$ENDIF}
          Paint(ClientRect); {!}
          {prevent up Redraw With mouse Click}
          If FDown And (Not FAllowAllUp) Then FState := bsDown;
     End;
End;


Procedure TSpeedButton.SetAllowAllUp(Value:Boolean);
Begin
     If FAllowAllUp <> Value Then
     Begin
          FAllowAllUp := Value;
          UpdateExclusive;
     End;
End;


Procedure TSpeedButton.SetGroupIndex(Value:LongInt);
Begin
     If FGroupIndex <> Value Then
     Begin
          FGroupIndex := Value;
          UpdateExclusive;
     End;
End;


{$HINTS OFF}
Procedure TSpeedButton.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          {$IFDEF OS2}
          If FGroupIndex = 0 Then Exit;
          {$ENDIF}
          If FDown And (Not FAllowAllUp) Then
          Begin
               FState := bsDown;  {sonst bringt OS/2 den Button up}
               Exit; {cannot switch OFF}
          End;

          If Not FDown Then
          Begin
               FState := bsDown;
               Paint(ClientRect);
          End;
          FDragging := True;
          {$IFDEF Win32}
          MouseCapture := True;
          {$ENDIF}
     End;
End;


Procedure TSpeedButton.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var  NewState:TButtonState;
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If Not FDragging Then Exit;

     If Not FDown Then
     Begin
          If PointInRect(Point(X,Y),ClientRect) Then NewState := bsDown
          Else NewState := bsUp;
     End
     Else NewState := bsDown;

     If NewState <> FState Then
     Begin
          FState := NewState;
          Paint(ClientRect);
     End;
End;


Procedure TSpeedButton.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          If Not FDragging Then Exit;
          FDragging := False;
          {$IFDEF Win32}
          MouseCapture := False;
          {$ENDIF}
          If PointInRect(Point(X,Y),ClientRect) Then
          Begin
               If FDown Then
               Begin
                    If FAllowAllUp Then
                    Begin
                         FState := bsNormal;
                         SetDown(False);
                         {manually because no ParentNotification occurs}
                         Click;
                    End
                    Else FIgnoreClick := True;
               End
               Else
               Begin
                    If FGroupIndex = 0 Then
                    Begin
                         FState := bsNormal;
                         Paint(ClientRect);
                    End;
                    SetDown(True);
               End;
               {$IFDEF Win32}
               If Not FIgnoreClick Then Click;

               FIgnoreClick := False;
               {$ENDIF}
          End;
     End;
End;


Procedure TSpeedButton.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          MouseDown(Button,ShiftState,X,Y);
          {$IFDEF OS2}
          MouseUp(Button,ShiftState,X,Y);   {Win32 sends it Self}
          {$ENDIF}
     End;
End;
{$HINTS OFF}


Procedure TSpeedButton.Click; {Do Not send A modal Result}
Begin
     If Parent <> Nil Then
     Begin
          If ComponentState * [csDetail] = [] Then
          Begin
               If Form <> Nil
               Then SendMsg(Form.Handle,CM_COMMAND,Command{cmNull},0);
          End
          Else SendMsg(parent.Handle,CM_COMMAND,Command,0)
     End;

     TButtonControl.Click;
End;


Begin
  FillChar(StdBtnBitmaps,SizeOf(StdBtnBitmaps),0);
  ShowBitBtnGlyph := True;
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02  WD         Ausbau der LINUX-Teile.
  10-Okt-03  WD         Diverse Insert-Funktionen eingebaut.
  08-Aug-04  MV         "1 shl" gegen "longword(1) shl" ausgetauscht.
  29-Aug-04  WD         tRadioButton.SetChecked: Korrekte Verarbeitung unter Windows.
  26-Mar-04  WD         Den Typ TBitBtnKind "bkPrev" und "bkNext" hinzugefgt.
  31-Jul-05  WD         Den Typ TBitBtnKind "bkFind" hinzugefgt.
  17-Sep-05  WD         Den Typ TBitBtnKind "bkPrinter" hinzugefgt.
  27-Okt-05  WD         Den Typ TBitBtnKind "bkNew" hinzugefgt.
  05-Mai-08  WD         Den Typ TBitBtnKind "bkEdit" hinzugefgt.
  17-Sep-08  WD         TBitBtn.DrawBitmap: Die Transparentfarbe auf die Farbe des Buttons umstellen.
  11-Nov-08  KF         StdBtnCmds: Korrigiert in die richtige Reihenfolge
}
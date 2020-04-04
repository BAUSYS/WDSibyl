
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit TabCtrls;

Interface

Uses SysUtils,Messages,Color,Classes,Graphics,Menus,Forms,Buttons,StdCtrls,ExtCtrls,
     Dialogs,
     uList,
     uString;

Type
    {$M+}
    TTabStyle=(tsStandard,tsOwnerDraw);

    TTabAlignment=(taBottom,taTop);
    {$M-}

    TTabSet=Class;

    TTabChangeEvent=Procedure(Sender:TObject;NewTab:LongInt;
         Var AllowChange:Boolean) Of Object;
    TMeasureTabEvent=Procedure(Sender:TObject;Index:LongInt;
         Var TabSize:LongInt) Of Object;
    TDrawTabEvent=Procedure(Sender:TObject;TabCanvas:TCanvas;rec:TRect;
         Index:LongInt;Selected:Boolean) Of Object;

    TTabSet=Class(TControl)
      Private
         FTabs:TStrings;
         FTabPositions:TList;
         FTabStyle:TTabStyle;
         FTabIndex:LongInt;
         FTabHeight:LongInt;
         FFirstIndex:LongInt;
         FLastIndex:LongInt;
         FAutoScroll:Boolean;
         FAlignment:TTabAlignment;
         FSelectedColor:TColor;
         FUnSelectedColor:TColor;
         FDitherBackground:Boolean;
         FStartMargin:LongInt;
         FEndMargin:LongInt;
         FVisibleTabs:LongInt;
         FLeftScroll:TSpeedButton;
         FRightScroll:TSpeedButton;
         FTabFocus:LongInt;
         FOnClick:TNotifyEvent;
         FOnChange:TTabChangeEvent;
         FOnMeasureTab:TMeasureTabEvent;
         FOnDrawTab:TDrawTabEvent;
         Procedure SetTabs(Value:TStrings);
         Procedure SetTabStyle(Value:TTabStyle);
         Procedure SetTabIndex(Value:LongInt);
         Procedure SetTabHeight(Value:LongInt);
         Procedure SetFirstIndex(Value:LongInt);
         Procedure SetAutoScroll(Value:Boolean);
         Procedure SetAlignment(Value:TTabAlignment);
         Procedure SetSelectedColor(Value:TColor);
         Procedure SetUnselectedColor(Value:TColor);
         Procedure SetDitherBackground(Value:Boolean);
         Procedure SetStartMargin(Value:LongInt);
         Procedure SetEndMargin(Value:LongInt);
         Procedure ArrangeTabs;
         Procedure SetButtons;
         Procedure UpdateButtons;
         Procedure EvScroll(Sender:TObject);
         Procedure EvTabsChange(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Resize;Override;
         Procedure FontChange;Override;
         Procedure SetFocus;Override;
         Procedure KillFocus;Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Function CanChange(NewIndex:LongInt):Boolean;Virtual;
         Function GetTabColor(Index:LongInt):TColor;Virtual;
         Procedure MeasureTab(Index:LongInt;Var TabSize:LongInt);Virtual;
         Procedure DrawTab(TabCanvas:TCanvas;rec:TRect;Index:LongInt;
                           Selected:Boolean);Virtual;
         Procedure RedrawBottom(Const rec:TRect);Virtual;
         Procedure RedrawTop(Const rec:TRect);Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Procedure Click;
         Procedure SelectNext(Direction:Boolean);
         Function ItemAtPos(Pos:TPoint):LongInt;
         Function ItemRect(Item:LongInt):TRect;
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property VisibleTabs:LongInt Read FVisibleTabs;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
         Property LastIndex:LongInt Read FLastIndex;{Martin0407}
      Published
         Property Align;
         Property Alignment:TTabAlignment Read FAlignment Write SetAlignment;
         Property AutoScroll:Boolean Read FAutoScroll Write SetAutoScroll;
         Property Color;
         Property DitherBackground:Boolean Read FDitherBackground Write SetDitherBackground;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property EndMargin:LongInt Read FEndMargin Write SetEndMargin;
         Property FirstIndex:LongInt Read FFirstIndex Write SetFirstIndex;
         Property Font;
         Property ParentFont;
         Property ParentShowHint;
         Property ParentColor;
         Property ParentPenColor;
         Property PenColor;
         Property SelectedColor:TColor Read FSelectedColor Write SetSelectedColor;
         Property ShowHint;
         Property StartMargin:LongInt Read FStartMargin Write SetStartMargin;
         Property TabHeight:LongInt Read FTabHeight Write SetTabHeight;
         Property TabIndex:LongInt Read FTabIndex Write SetTabIndex;
         Property Tabs:TStrings Read FTabs Write SetTabs;
         Property TabStop;
         Property TabStyle:TTabStyle Read FTabStyle Write SetTabStyle;
         Property UnselectedColor:TColor Read FUnSelectedColor Write SetUnselectedColor;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TTabChangeEvent Read FOnChange Write FOnChange;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDrawTab:TDrawTabEvent Read FOnDrawTab Write FOnDrawTab;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnMeasureTab:TMeasureTabEvent Read FOnMeasureTab Write FOnMeasureTab;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TPage=Class(TControl)
      Private
         SubCount:LongInt;
         SubIndex:LongInt;
         MainIndex:LongInt;
         PopupEntry:TMenuItem;
         FIsSubPage:Boolean;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure Paint(Const rec:TRect);Override;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseUp;
         Property OnMouseMove;
      Public
         Procedure BringToFront;Override;
         Property IsSubPage:Boolean Read FIsSubPage;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowHint;

         Property OnCommand;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnPaint;
         Property OnResize;
         Property OnSetupShow;
      Published
         Property Caption;
         Property Hint;
    End;


    TTabPage=Class(TPage)
    End;


    TTabSheet=Class(TPage)
    End;


    TNoteBook=Class;

    TPageAccess=Class(TStrings)
      Private
         FPages:TList;
         FNotebook:TNoteBook;
         FOnChange:TNotifyEvent;
      Private
         Function GetPage(Index:LongInt):TPage;
      Protected
         Function GetCount: LongInt; Override;
         Function Get(Index: LongInt): String; Override;
         Procedure Put(Index: LongInt; Const S: String); Override;
         Function GetObject(Index: LongInt): TObject; Override;
      Public
         Procedure Clear; Override;
         Procedure Delete(Index: LongInt); Override;
         Procedure Insert(Index: LongInt; Const S: String); Override;
         Procedure Move(CurIndex, NewIndex: LongInt); Override;
         Property Pages[Index:LongInt]:TPage Read GetPage;
         Property NoteBook:TNoteBook Read FNotebook;
         Property OnChange:TNotifyEvent Read FOnChange;
    End;


    TNoteBook=Class(TControl)
      Private
         FPages:TList;
         FAccess:TPageAccess;
         FPageIndex:LongInt;
         FOnPageChanged:TNotifyEvent;
         Function GetActivePage:String;
         Procedure SetActivePage(Const Value:String);
         Procedure SetPageIndex(Value:LongInt);
         Procedure SetPages(Value:TPageAccess);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Procedure LoadingFromSCU(SCUParent:TComponent);Override;
      Public
         Destructor Destroy;Override;
         Procedure GetDesignerPopupEvents(AString:TStringList);Override;
         Procedure DesignerPopupEvent(Id:LongInt);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property ActivePage:String Read GetActivePage Write SetActivePage; stored False;
         Property Align;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property PageIndex:LongInt Read FPageIndex Write SetPageIndex;
         Property Pages:TPageAccess Read FAccess Write SetPages;
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
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnPageChanged:TNotifyEvent Read FOnPageChanged Write FOnPageChanged;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    {$M+}
    TTabbedNotebookStyle=(nsDefault,nsWarp4,nsWin32);
    {$M-}

    TTabbedNotebook=Class(TControl)
      Private
         FTabSet:TTabSet;
         FNotebook:TNoteBook;
         FPageHint:TLabel;
         FPageCount:TLabel;
         FEdge:TImage;
         FAutoPopup:Boolean;
         FStyle:TTabbedNotebookStyle;
         FColorTabs:Boolean;
         FShowPageHint:Boolean;
         FRectangleTabs:Boolean;
         EdgeDraggingMinus:Boolean;
         EdgeDraggingPlus:Boolean;
         LastEdgeBmpId:String[30];
         IgnoreTabClick:Boolean;
         PagesPopup:TPopupMenu;
         FOnPageChanged:TNotifyEvent;
         Function GetActivePage:String;
         Procedure SetActivePage(Value:String);
         Function GetPageIndex:LongInt;
         Procedure SetPageIndex(Value:LongInt);
         Function GetPages:TPageAccess;
         Procedure SetPages(Value:TPageAccess);
         Function GetTabFont:TFont;
         Procedure SetTabFont(Value:TFont);
         Function GetTabAlignment:TTabAlignment;
         Procedure SetTabAlignment(Value:TTabAlignment);
         Procedure SetStyle(Value:TTabbedNotebookStyle);
         Procedure SetColorTabs(Value:Boolean);
         Procedure SetShowPageHint(Value:Boolean);
         Procedure SetRectangleTabs(Value:Boolean);
         Function GetTabHeight:LongInt;
         Procedure SetTabHeight(Value:LongInt);
         Function GetPageHint:String;
         Procedure SetPageHint(Const Value:String);
         Function GetPageRect:TRect;
         Procedure LoadEdge;
         Procedure ArrangeSubPages;
         Function Tab2Page(TabIdx:LongInt):LongInt;
         Function Page2Tab(PageIdx:LongInt):LongInt;
         Procedure EvTabSetClicked(Sender:TObject);
         Procedure EvPageIndexChanged(Sender:TObject);
         Procedure EvPageAccessChanged(Sender:TObject);
         Procedure EvCanChange(Sender:TObject;NewTab:LongInt;Var AllowChange:Boolean);
         Procedure EvMeasureTab(Sender:TObject;Index:LongInt;Var TabSize:LongInt);
         Procedure EvDrawTab(Sender:TObject;TabCanvas:TCanvas;rec:TRect;Index:LongInt;Selected:Boolean);
         Function SignFromPos(X,Y:LongInt):Boolean;
         Procedure EvEdgeMouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LongInt);
         Procedure EvEdgeMouseUp(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LongInt);
         Procedure EvMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
         Procedure EvPopupClicked(Sender:TObject);
         Procedure EvQueryTabColor(Sender:TObject;Index:LongInt;Var TabColor:TColor);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure FontChange;Override;
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Procedure LoadingFromSCU(SCUParent:TComponent);Override;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Function EvaluateShortCut(KeyCode:TKeyCode):Boolean;Override;
         Procedure SetEnabled(NewState:Boolean); Override;
         Function GetEnabled:Boolean; Override;
      Public
         Procedure Resize;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Procedure GetDesignerPopupEvents(AString:TStringList);Override;
         Procedure DesignerPopupEvent(Id:LongInt);Override;
         Property ColorTabs:Boolean Read FColorTabs Write SetColorTabs;
         Property ShowPageHint:Boolean Read FShowPageHint Write SetShowPageHint;
         Property RectangleTabs:Boolean Read FRectangleTabs Write SetRectangleTabs;
         Property PageHint:String Read GetPageHint Write SetPageHint;
         Property PageRect:TRect Read GetPageRect;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
         {Martin0407}property Tabset : tTabset Read fTabset;
      Published


         Property ActivePage:String Read GetActivePage Write SetActivePage; stored False;
         Property Align;
         Property AutoPopup:Boolean Read FAutoPopup Write FAutoPopup;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled:Boolean Read GetEnabled Write SetEnabled;
         Property Font;
         Property PageIndex:LongInt Read GetPageIndex Write SetPageIndex;
         Property Pages:TPageAccess Read GetPages Write SetPages;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowHint;
         Property Style:TTabbedNotebookStyle Read FStyle Write SetStyle;
         Property TabAlignment:TTabAlignment Read GetTabAlignment Write SetTabAlignment;
         Property TabFont:TFont Read GetTabFont Write SetTabFont;
         Property TabHeight:LongInt Read GetTabHeight Write SetTabHeight;
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
         Property OnFontChange;
         Property OnMouseMove;
         Property OnPageChanged:TNotifyEvent Read FOnPageChanged Write FOnPageChanged;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TPageControl=Class(TTabbedNotebook)
    End;


Function InsertTabSet(parent:TControl;Left,Bottom,Width,Height:LongInt):TTabSet;
Function InsertNotebook(parent:TControl;Left,Bottom,Width,Height:LongInt):TNoteBook;
Function InsertTabbedNotebook(parent:TControl;Left,Bottom,Width,Height:LongInt):TTabbedNotebook;


Implementation

{$IFDEF OS2}
Uses PmGpi,PmWin;
{$ENDIF}

{$IFDEF WIN32}
Uses WinUser;
{$ENDIF}

{$R TabCtrls}

Function InsertTabSet(parent:TControl;Left,Bottom,Width,Height:LongInt):TTabSet;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertNotebook(parent:TControl;Left,Bottom,Width,Height:LongInt):TNoteBook;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertTabbedNotebook(parent:TControl;Left,Bottom,Width,Height:LongInt):TTabbedNotebook;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;



Type
    TTabPos=Record
         Size,Start:Word;
    End;

Const
    EdgeWidth=9;
    TopMargin=2;
    BottomMargin=2;
    ScrollWidth=11;
    ScrollHeight=15;

Type
    TTabSetScroller=Class(TSpeedButton)
      Private
         FArrowLeft:Boolean;
      Public
         Procedure Redraw(Const rec:TRect);Override;
    End;


Procedure TTabSetScroller.Redraw(Const rec:TRect);
Var  mpt:TPoint;
     rc:TRect;
     trial:Array[0..2] Of TPoint;
Begin
     Inherited Redraw(rec);

     mpt := Point(ScrollWidth Div 2, ScrollHeight Div 2);
     If Down Then
     Begin
          Inc(mpt.X);
          Dec(mpt.Y);
     End;
     rc := ClientRect;
     Canvas.Pen.color := clBlack;
     Canvas.Rectangle(rc);

     If Enabled Then Canvas.Pen.color := clBlack
     Else Canvas.Pen.color := clDkGray;

     If FArrowLeft Then
     Begin
          trial[0].X := mpt.X - 3;
          trial[0].Y := mpt.Y;
          trial[1].X := mpt.X + 1;
          trial[1].Y := mpt.Y - 4;
          trial[2].X := mpt.X + 1;
          trial[2].Y := mpt.Y + 4;
     End
     Else
     Begin
          trial[0].X := mpt.X + 2;
          trial[0].Y := mpt.Y;
          trial[1].X := mpt.X - 2;
          trial[1].Y := mpt.Y - 4;
          trial[2].X := mpt.X - 2;
          trial[2].Y := mpt.Y + 4;
     End;
     Canvas.BeginPath;
     Canvas.PolyLine(trial);
     Canvas.EndPath;
     Canvas.FillPath;
End;


{***************************************************************************}

Procedure TTabSet.SetupComponent;
Begin
     Inherited SetupComponent;

     Ownerdraw := True;
     Width := 185;
     Height := 25;
     ParentPenColor := True;
     ParentColor := False;
     Color := clDlgWindow;
     TabStop := False;

     FTabs := TStringList.Create;
     TStringList(FTabs).OnChange := EvTabsChange;
     FTabPositions.Create;
     FTabStyle := tsStandard;
     FTabIndex := -1;
     FFirstIndex := 0;
     FLastIndex := 0;
     FSelectedColor := clDlgWindow;
     FUnSelectedColor := clWindow;
     FDitherBackground := True;
     FStartMargin := 5;
     FEndMargin := 5;
     FVisibleTabs := 0;
     FTabHeight := 20;
     FAutoScroll := True;
     FAlignment := taBottom;
End;


Procedure TTabSet.SetupShow;
Begin
     Inherited SetupShow;

     ArrangeTabs;
End;


Destructor TTabSet.Destroy;
Begin
     TStringList(FTabs).OnChange := Nil;
     FTabs.Destroy;
     FTabs := Nil;
     FTabPositions.Destroy;
     FTabPositions := Nil;

     Inherited Destroy;
End;


Procedure TTabSet.Resize;

Begin
  Inherited Resize;
  ArrangeTabs;
End;


Procedure TTabSet.FontChange;
Begin
  ArrangeTabs;
  Inherited FontChange;
End;

{$HINTS OFF}
Procedure TTabSet.EvTabsChange(Sender:TObject);
Begin
     ArrangeTabs;
     Invalidate;
End;
{$HINTS ON}

Procedure TTabSet.SetTabs(Value:TStrings);
Begin
     If Value <> FTabs Then FTabs.Assign(Value);
End;


Procedure TTabSet.SetTabStyle(Value:TTabStyle);
Begin
     If FTabStyle <> Value Then
     Begin
          FTabStyle := Value;
          ArrangeTabs;
          Invalidate;
     End;
End;


Procedure TTabSet.SetSelectedColor(Value:TColor);
Begin
     If FSelectedColor <> Value Then
     Begin
          FSelectedColor := Value;
          Invalidate;
     End;
End;


Procedure TTabSet.SetUnselectedColor(Value:TColor);
Begin
     If FUnSelectedColor <> Value Then
     Begin
          FUnSelectedColor := Value;
          Invalidate;
     End;
End;


Procedure TTabSet.SetDitherBackground(Value:Boolean);
Begin
     If FDitherBackground <> Value Then
     Begin
          FDitherBackground := Value;
          Invalidate;
     End;
End;


Procedure TTabSet.SetStartMargin(Value:LongInt);
Begin
     If FStartMargin <> Value Then
     Begin
          FStartMargin := Value;
          ArrangeTabs;
          Invalidate;
     End;
End;


Procedure TTabSet.SetEndMargin(Value:LongInt);
Begin
     If FEndMargin <> Value Then
     Begin
          FEndMargin := Value;
          ArrangeTabs;
          Invalidate;
     End;
End;


Procedure TTabSet.SetTabIndex(Value:LongInt);
Begin
     FTabFocus := Value;

     If ComponentState * [csReading] <> [] Then
     Begin
          FTabIndex := Value;
          Exit;
     End;

     If (Value < 0) Or (Value >= FTabs.Count) Then Exit;
     If FTabIndex <> Value Then
       If CanChange(Value) Then
       Begin
            FTabIndex := Value;
            ArrangeTabs;
            Invalidate;
            Click;
       End;
End;


Procedure TTabSet.SetTabHeight(Value:LongInt);
Begin
     If FTabHeight <> Value Then
     Begin
          FTabHeight := Value;
          If FTabStyle = tsOwnerDraw Then Invalidate;
     End;
End;


Procedure TTabSet.SetFirstIndex(Value:LongInt);
Begin
     If ComponentState * [csReading] <> [] Then
     Begin
          FFirstIndex := Value;
          Exit;
     End;

     If (Value < 0) Or (Value >= FTabs.Count) Then Exit;
     If FFirstIndex <> Value Then
     Begin
          FFirstIndex := Value;
          ArrangeTabs;
          Invalidate;
     End;
End;


Procedure TTabSet.SetAutoScroll(Value:Boolean);
Begin
     If FAutoScroll <> Value Then
     Begin
          FAutoScroll := Value;
          SetButtons;
          Invalidate;
     End;
End;


Procedure TTabSet.SetAlignment(Value:TTabAlignment);
Begin
     If FAlignment <> Value Then
     Begin
          FAlignment := Value;
          ArrangeTabs;
          SetButtons;
          Invalidate;
     End;
End;


Procedure TTabSet.SetButtons;
Begin
     If FAutoScroll And (FVisibleTabs < FTabs.Count) Then
     Begin
          If FLeftScroll = Nil Then
          Begin
               FLeftScroll := TTabSetScroller.Create(Self);
               Include(FLeftScroll.ComponentState, csDetail);
               FLeftScroll.Visible := False;
               InsertControl(FLeftScroll);
               FLeftScroll.OnClick := EvScroll;
               TTabSetScroller(FLeftScroll).FArrowLeft := True;
          End;
          If FAlignment = taBottom
          Then FLeftScroll.SetBounds(Width-2*ScrollWidth, TopMargin+1,
                                     ScrollWidth, ScrollHeight)
          Else FLeftScroll.SetWindowPos(Width-2*ScrollWidth, BottomMargin+1,
                                        ScrollWidth, ScrollHeight);
          FLeftScroll.SetDesigning(False);

          If FRightScroll = Nil Then
          Begin
               FRightScroll := TTabSetScroller.Create(Self);
               Include(FRightScroll.ComponentState, csDetail);
               FRightScroll.Visible := False;
               InsertControl(FRightScroll);
               FRightScroll.OnClick := EvScroll;
               TTabSetScroller(FRightScroll).FArrowLeft := False;
          End;
          If FAlignment = taBottom
          Then FRightScroll.SetBounds(Width-ScrollWidth-1, TopMargin+1,
                                      ScrollWidth, ScrollHeight)
          Else FRightScroll.SetWindowPos(Width-ScrollWidth-1, BottomMargin+1,
                                         ScrollWidth, ScrollHeight);
          FRightScroll.SetDesigning(False);
          UpdateButtons;
     End
     Else
     Begin
          If FLeftScroll <> Nil Then FLeftScroll.Destroy;
          FLeftScroll := Nil;
          If FRightScroll <> Nil Then FRightScroll.Destroy;
          FRightScroll := Nil;
     End;
End;


Procedure TTabSet.UpdateButtons;
Begin
     If FLeftScroll <> Nil Then
     Begin
          FLeftScroll.Enabled := FFirstIndex > 0;
          FLeftScroll.Visible := True;
     End;
     If FRightScroll <> Nil Then
     Begin
          FRightScroll.Enabled := FFirstIndex + FVisibleTabs < FTabs.Count;
          FRightScroll.Visible := True;
     End;
End;


Procedure TTabSet.EvScroll(Sender:TObject);
Begin
     If Sender = FLeftScroll Then SetFirstIndex(FFirstIndex - 1);
     If Sender = FRightScroll Then SetFirstIndex(FFirstIndex + 1);
End;


Procedure TTabSet.Click;
Begin
     If FOnClick <> Nil Then FOnClick(Self); {switch the NoteBook page}
End;


Function TTabSet.CanChange(NewIndex:LongInt):Boolean;
Begin
     Result := True;
     If FOnChange <> Nil Then FOnChange(Self,NewIndex,Result);
End;


Function TTabSet.GetTabColor(Index:LongInt):TColor;
Begin
     If Index = FTabIndex Then Result := FSelectedColor
     Else Result := FUnSelectedColor;
End;


{initialisiert mit Textbreite}
Procedure TTabSet.MeasureTab(Index:LongInt;Var TabSize:LongInt); {Width Or Height}
Begin
     If FOnMeasureTab <> Nil Then FOnMeasureTab(Self,Index,TabSize);
End;


{zeichne TabInhalt}
Procedure TTabSet.DrawTab(TabCanvas:TCanvas;rec:TRect;Index:LongInt;Selected:Boolean);
Begin
     If FOnDrawTab <> Nil Then FOnDrawTab(Self,TabCanvas,rec,Index,Selected);
End;


Procedure TTabSet.SelectNext(Direction:Boolean);
Var  idx:LongInt;
Begin
     If Tabs.Count > 1 Then
     Begin
          If Direction Then idx := FTabIndex + 1
          Else idx := FTabIndex - 1;
          If idx < 0 Then idx := Tabs.Count-1;
          If idx >= Tabs.Count Then idx := 0;
          SetTabIndex(idx);
     End;
End;


Function TTabSet.ItemAtPos(Pos:TPoint):LongInt;
Var  TabPos:TTabPos;
     I:LongInt;
Begin
     Result := -1;
     If Not PointInRect(Pos,ClientRect) Then Exit;

     For I := 0 To FTabPositions.Count-1 Do
     Begin
          TabPos := TTabPos(FTabPositions[I]);
          If (TabPos.Start <= Pos.X) And (TabPos.Start + TabPos.Size >= Pos.X) Then
          Begin
               Result := I;
               Exit;
          End;
     End;
End;


Function TTabSet.ItemRect(Item:LongInt):TRect;
Var  TabPos:TTabPos;
     EdgeWidthDiv2:LongInt;
     Y,CY:LongInt;
Begin
     Result := Rect(0,0,0,0);

     If (Item < 0) Or (Item >= FTabPositions.Count) Then Exit;

     EdgeWidthDiv2 := EdgeWidth Div 2;
     TabPos := TTabPos(FTabPositions[Item]);
     If FTabStyle = tsOwnerDraw Then CY := FTabHeight
     Else CY := Canvas.TextHeight('M');

     If FAlignment = taBottom Then
     Begin
          Y := Height - TopMargin - CY - BottomMargin;
          Result := Rect(TabPos.Start - EdgeWidthDiv2, Y,
                         TabPos.Start + TabPos.Size + EdgeWidthDiv2,
                         Height - TopMargin);
     End
     Else
     Begin
          Result := Rect(TabPos.Start - EdgeWidthDiv2, 0,
                         TabPos.Start + TabPos.Size + EdgeWidthDiv2,
                         BottomMargin + CY + TopMargin);
     End;
End;


Procedure TTabSet.SetFocus;
Begin
     Inherited SetFocus;
     Invalidate;
End;


Procedure TTabSet.KillFocus;
Begin
     Inherited KillFocus;
     Invalidate;
End;


{$HINTS OFF}
Procedure TTabSet.CharEvent(Var key:Char;RepeatCount:Byte);
Var  S:String;
     P:Integer;
     I:LongInt;
Begin
     If key = ' ' Then
     Begin
          If FTabFocus <> FTabIndex Then SetTabIndex(FTabFocus);
          key := #0;
          Exit;
     End;

     For I := 0 To FTabs.Count-1 Do
     Begin
          S := FTabs[I];
          P := Pos(StandardMnemoChar,S);
          If (P > 0) And (P < Length(S)) Then
          Begin
               If UpCase(key) = UpCase(S[P+1]) Then
               Begin
                    SetTabIndex(I);
                    If I >= FFirstIndex + FVisibleTabs Then
                    Begin
                         While (I >= FFirstIndex + FVisibleTabs) And
                               (I > FLastIndex) Do
                         Begin
                              SetFirstIndex(FFirstIndex + 1);
                         End;
                    End
                    Else If I < FFirstIndex Then SetFirstIndex(I);
                    key := #0;
                    Exit;
               End;
          End;
     End;

     Inherited CharEvent(key,RepeatCount);
End;


Procedure TTabSet.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     If TabStop Then
     Begin
          Case KeyCode Of
            kbCLeft:
            Begin
                 If FTabFocus > 0 Then
                 Begin
                      FTabFocus := FTabFocus -1;
                      If FTabFocus < FFirstIndex Then SetFirstIndex(FTabFocus);
                      Invalidate;
                 End;
                 KeyCode := kbNull;
            End;
            kbCRight:
            Begin
                 If FTabFocus < FTabs.Count-1 Then
                 Begin
                      FTabFocus := FTabFocus +1;
                      While (FTabFocus >= FFirstIndex + FVisibleTabs) And
                            (FTabFocus > FLastIndex) Do
                      Begin
                           SetFirstIndex(FFirstIndex + 1);
                      End;
                      Invalidate;
                 End;
                 KeyCode := kbNull;
            End;
            {$IFDEF OS2}
            kbEnter,
            {$ENDIF}
            kbCR:
            Begin
                 If FTabFocus <> FTabIndex Then SetTabIndex(FTabFocus);
                 KeyCode := kbNull;
            End;
            Else Inherited ScanEvent(KeyCode,RepeatCount);
          End;
     End
     Else Inherited ScanEvent(KeyCode,RepeatCount);
End;


Procedure TTabSet.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  idx:LongInt;
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          idx := ItemAtPos(Point(X,Y));
          If idx >= 0 Then
            If PointInRect(Point(X,Y), ItemRect(idx)) Then
            Begin
                 If TabStop Then
                   If FTabIndex = idx + FFirstIndex Then Focus;
                 SetTabIndex(idx + FFirstIndex);
            End;
     End;
End;
{$HINTS ON}


Procedure TTabSet.ArrangeTabs;
Var  TabPos:TTabPos;
     tabstart,tabend:LongInt;
     Index:LongInt;
     CX:LongInt;
Begin
     If Canvas = Nil Then Exit;
     FTabPositions.Count := 0;

     FVisibleTabs := 0;
     tabstart := FStartMargin + EdgeWidth;
     tabend := Width - FEndMargin;
     Index := FFirstIndex;
     While (Index < FTabs.Count) And (tabstart < tabend) Do
     Begin
          TabPos.Start := tabstart;
          CX := Canvas.TextWidth(FTabs[Index]);

          TabPos.Start := tabstart;
          If FTabStyle = tsOwnerDraw Then MeasureTab(Index, CX);

          TabPos.Size := CX;
          Inc(tabstart, CX + EdgeWidth);

          If tabstart <= tabend Then
          Begin
               FTabPositions.Add(Pointer(TabPos));
               FLastIndex := Index;
               Inc(Index);
               Inc(FVisibleTabs);
          End;
     End;
     SetButtons;
End;


Procedure TTabSet.Redraw(Const rec:TRect);
Begin
     If FAlignment = taBottom Then RedrawBottom(rec)
     Else RedrawTop(rec);
End;


Type
    TShortPos=Record
         X,Y:Integer;
    End;

    PPointArray=^TPointArray;
    TPointArray=Array[0..1000] Of TPoint;


{$HINTS OFF}
Procedure TTabSet.RedrawBottom(Const rec:TRect);
Var  rc:TRect;
     I:LongInt;
     TabPos:TTabPos;
     Y,CY:LongInt;
     IsSelected:Boolean;
     fullleft,fullright:Boolean;
     poly:Array[1..4] Of TPoint;
     shadow:Array[0..2] Of TPoint;
     wabe:Array[0..5] Of TPoint;
     topline1,topline2:TPoint;
     EdgeWidthDiv2:LongInt;
     OutlineList:TList;
     p1,p2:TShortPos;
     pPoly:PPointArray;
Begin
     If FDitherBackground Then
     Begin
          {$IFDEF OS2}
          Canvas.Pen.Color := Color;
          Canvas.Brush.Color := clWhite;
          Canvas.Brush.Style := bsDiagCross;
          {$ENDIF}
          {$IFDEF WIN32}
          Canvas.Brush.Color := cl3DLight;
          Canvas.Brush.Style := bsSolid;
          {$ENDIF}
     End
     Else
     Begin
          Canvas.Pen.Color := Color;
          Canvas.Brush.Color := Color;
          Canvas.Brush.Style := bsSolid;
     End;

     Canvas.Brush.Mode := bmOpaque;
     Canvas.Box(ClientRect); {background}

     Canvas.Brush.Style := bsSolid;

     If FTabStyle = tsOwnerDraw Then CY := FTabHeight
     Else CY := Canvas.TextHeight('M');

     EdgeWidthDiv2 := (EdgeWidth + 1) Div 2;
     topline1.X := 0;
     topline1.Y := Height - 1;
     topline2.X := Width -1;
     topline2.Y := Height - 1;
     {textline}
     Y := Height - TopMargin - CY;

     OutlineList.Create;
     p1.X := 0;
     p1.Y := Height - 2;
     OutlineList.Add(Pointer(p1));

     For I := 0 To FTabPositions.Count-1 Do
     Begin
          TabPos := TTabPos(FTabPositions[I]);
          rc := Rect(TabPos.Start, Y, TabPos.Start+TabPos.Size-1, Y+CY-1);

          IsSelected := (I + FFirstIndex) = FTabIndex;
          fullleft := IsSelected Or (I = 0);
          fullright := (I + FFirstIndex <> FTabIndex - 1) Or
                       (I = FTabPositions.Count-1);


          If fullleft Then
          Begin
               wabe[0].X := rc.Left - EdgeWidth;
               wabe[0].Y := rc.Top + 2;
               wabe[1] := wabe[0];
               {prevent flickering ON Top Line}
               If Not IsSelected Then Dec(wabe[0].Y, 2);
          End
          Else
          Begin
               wabe[0].X := rc.Left - 1;
               wabe[0].Y := rc.Top;
               wabe[1].X := rc.Left - EdgeWidthDiv2;
               wabe[1].Y := rc.Bottom + (rc.Top - rc.Bottom) Div 2;
          End;

          wabe[2] := Point(rc.Left, rc.Bottom - 1);
          wabe[3] := Point(rc.Right, rc.Bottom - 1);

          If fullright Then
          Begin
               wabe[4].X := rc.Right + EdgeWidth;
               wabe[4].Y := rc.Top + 2;
               wabe[5] := wabe[4];
               {$IFDEF OS2}
               {prevent flickering on Top Line}
               If Not IsSelected Then Dec(wabe[5].Y, 2);
               {$ENDIF}
          End
          Else
          Begin
               wabe[4].X := rc.Right + EdgeWidthDiv2;
               wabe[4].Y := rc.Bottom + (rc.Top - rc.Bottom) Div 2;
               wabe[5].X := rc.Right + 1;
               wabe[5].Y := rc.Top;
          End;

          Canvas.Pen.color := GetTabColor(I + FFirstIndex);

          Canvas.BeginPath;
          Canvas.PolyLine(wabe);
          Canvas.EndPath;
          Canvas.FillPath;

          If I > 0 Then {Redraw the Last border segment Of the previous tab}
          Begin
               Canvas.Pen.color := clBlack;
               Canvas.Line(poly[3].X,poly[3].Y,poly[4].X,poly[4].Y);
          End;

          {border Line}
          Canvas.Pen.color := clBlack;
          poly[1].X := wabe[1].X;
          poly[1].Y := wabe[1].Y-1;
          poly[2].X := wabe[2].X;
          poly[2].Y := wabe[2].Y-1;
          poly[3].X := wabe[3].X;
          poly[3].Y := wabe[3].Y-1;
          poly[4].X := wabe[4].X;
          poly[4].Y := wabe[4].Y-1;
          Canvas.PolyLine(poly);


          p1.X := poly[1].X;
          p1.Y := poly[1].Y;
          OutlineList.Add(Pointer(p1));
          p1.X := poly[2].X;
          p1.Y := poly[2].Y;
          OutlineList.Add(Pointer(p1));
          p1.X := poly[3].X;
          p1.Y := poly[3].Y;
          OutlineList.Add(Pointer(p1));
          p1.X := poly[4].X;
          p1.Y := poly[4].Y;
          OutlineList.Add(Pointer(p1));

          If I = FTabPositions.Count-1 Then
          Begin
               p1.X := Width-1;
               p1.Y := poly[4].Y;
               OutlineList.Add(Pointer(p1));
               p1.X := Width-1;
               p1.Y := Height-1;
               OutlineList.Add(Pointer(p1));
          End;


          If IsSelected Then {split topline}
          Begin
               Canvas.Pen.color := clBlack;
               Canvas.Line(topline1.X, topline1.Y, wabe[0].X, wabe[0].Y);
               Canvas.Pen.color := clBtnShadow;
               Canvas.Line(topline1.X, topline1.Y-1, wabe[0].X, wabe[0].Y-1);
               topline1 := wabe[5];
               {3D}
               shadow[0] := wabe[2];
               shadow[1] := wabe[3];
               shadow[2] := wabe[4];
               Canvas.PolyLine(shadow);
               Canvas.Line(shadow[1].X,shadow[1].Y+1,shadow[2].X-1,shadow[2].Y);

               Canvas.Pen.color := clBtnHighlight;
               Canvas.Line(wabe[0].X, wabe[0].Y, wabe[2].X, wabe[2].Y);
               Canvas.Line(wabe[0].X+1, wabe[0].Y, wabe[2].X, wabe[2].Y+1);
          End;


          If FTabStyle = tsOwnerDraw Then
          Begin
               DrawTab(Canvas, rc, I + FFirstIndex, IsSelected);
          End
          Else
          Begin
               Canvas.Pen.color := PenColor;
               Canvas.Brush.Mode := bmTransparent;
               Canvas.TextOut(rc.Left,rc.Bottom,FTabs[I + FirstIndex]);
          End;
     End;

     {Draw rest Of topline}
     Canvas.Pen.color := clBlack;
     Canvas.Line(topline1.X, topline1.Y, topline2.X, topline2.Y);
     Canvas.Pen.color := clBtnShadow;
     Canvas.Line(topline1.X, topline1.Y-1, topline2.X, topline2.Y-1);

     OutlineList.Destroy;
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TTabSet.RedrawTop(Const rec:TRect);
Var  rc:TRect;
     I:LongInt;
     TabPos:TTabPos;
     Y,CY:LongInt;
     IsSelected:Boolean;
     fullleft,fullright:Boolean;
     poly:Array[1..4] Of TPoint;
     Light:Array[0..2] Of TPoint;
     wabe:Array[0..5] Of TPoint;
     topline1,topline2:TPoint;
     poly3,poly4:TPoint;
     EdgeWidthDiv2:LongInt;
     OutlineList:TList;
     p1,p2:TShortPos;
     pPoly:PPointArray;
Begin
     If FDitherBackground Then
     Begin
          {$IFDEF OS2}
          Canvas.Pen.Color := Color;
          Canvas.Brush.Color := clWhite;
          Canvas.Brush.Style := bsDiagCross;
          {$ENDIF}
          {$IFDEF WIN32}
          Canvas.Brush.Color := cl3DLight;
          Canvas.Brush.Style := bsSolid;
          {$ENDIF}
     End
     Else
     Begin
          Canvas.Pen.Color := Color;
          Canvas.Brush.Color := Color;
          Canvas.Brush.Style := bsSolid;
     End;

     Canvas.Brush.Mode := bmOpaque;
     Canvas.Box(ClientRect); {background}

     Canvas.Brush.Style := bsSolid;

     If FTabStyle = tsOwnerDraw Then CY := FTabHeight
     Else CY := Canvas.TextHeight('M');

     EdgeWidthDiv2 := (EdgeWidth + 1) Div 2;
     topline1.X := 0;
     topline1.Y := 0;
     topline2.X := Width -1;
     topline2.Y := 0;
     {textline}
     Y := 2;

     OutlineList.Create;
     p1.X := 0;
     p1.Y := 1;
     OutlineList.Add(Pointer(p1));


     For I := 0 To FTabPositions.Count-1 Do
     Begin
          TabPos := TTabPos(FTabPositions[I]);
          rc := Rect(TabPos.Start, Y, TabPos.Start+TabPos.Size-1, Y+CY-1);

          IsSelected := (I + FFirstIndex) = FTabIndex;
          fullleft := IsSelected Or (I = 0);
          fullright := (I + FFirstIndex <> FTabIndex - 1) Or
                       (I = FTabPositions.Count-1);


          If fullleft Then
          Begin
               wabe[0].X := rc.Left - EdgeWidth;
               wabe[0].Y := rc.Bottom - 2;
               wabe[1] := wabe[0];
               {prevent flickering on Top Line}
               If Not IsSelected Then Inc(wabe[0].Y, 2);
          End
          Else
          Begin
               wabe[0].X := rc.Left - 1;
               wabe[0].Y := rc.Bottom;
               wabe[1].X := rc.Left - EdgeWidthDiv2;
               wabe[1].Y := rc.Bottom + (rc.Top - rc.Bottom) Div 2;
          End;

          wabe[2] := Point(rc.Left, rc.Top + 1);
          wabe[3] := Point(rc.Right, rc.Top + 1);

          If fullright Then
          Begin
               wabe[4].X := rc.Right + EdgeWidth;
               wabe[4].Y := rc.Bottom - 2;
               wabe[5] := wabe[4];
               {$IFDEF OS2}
               {prevent flickering ON Top Line}
               If Not IsSelected Then Inc(wabe[5].Y, 2);
               {$ENDIF}
          End
          Else
          Begin
               wabe[4].X := rc.Right + EdgeWidthDiv2;
               wabe[4].Y := rc.Bottom + (rc.Top - rc.Bottom) Div 2;
               wabe[5].X := rc.Right + 1;
               wabe[5].Y := rc.Bottom;
          End;

          Canvas.Pen.color := GetTabColor(I + FFirstIndex);

          Canvas.BeginPath;
          Canvas.PolyLine(wabe);
          Canvas.EndPath;
          Canvas.FillPath;

          If I > 0 Then
          Begin {Redraw the Last border segment Of the previous tab}
               poly3 := poly[3];
               poly4 := poly[4];

               If fullleft Then
               Begin {Redraw Last border before Current border}
                    Canvas.Pen.color := clBtnShadow;
                    Canvas.Line(poly3.X,poly3.Y,poly4.X,poly4.Y);
                    Canvas.Pen.color := clBlack;
                    Canvas.Line(poly3.X+1,poly3.Y,poly4.X+1,poly4.Y);
               End;
          End;

          {border Line}
          Canvas.Pen.color := clBtnHighlight;
          poly[1].X := wabe[1].X;
          poly[1].Y := wabe[1].Y+1;
          poly[2].X := wabe[2].X;
          poly[2].Y := wabe[2].Y+1;
          poly[3].X := wabe[3].X;
          poly[3].Y := wabe[3].Y+1;
          poly[4].X := wabe[4].X;
          poly[4].Y := wabe[4].Y+1;
          Canvas.Line(poly[1].X,poly[1].Y,poly[2].X,poly[2].Y);
          Canvas.Line(poly[2].X,poly[2].Y,poly[3].X,poly[3].Y);
          Canvas.Pen.color := clBtnShadow;
          Canvas.Line(poly[3].X,poly[3].Y,poly[4].X,poly[4].Y);
          Canvas.Pen.color := clBlack;
          Canvas.Line(poly[3].X+1,poly[3].Y,poly[4].X+1,poly[4].Y);

          If I > 0 Then
          Begin {Redraw the Last border segment Of the previous tab}
               If Not fullleft Then
               Begin {Redraw Last border after Current border}
                    Canvas.Pen.color := clBtnShadow;
                    Canvas.Line(poly3.X,poly3.Y,poly4.X,poly4.Y);
                    Canvas.Pen.color := clBlack;
                    Canvas.Line(poly3.X+1,poly3.Y,poly4.X+1,poly4.Y);
               End;
          End;


          p1.X := poly[1].X;
          p1.Y := poly[1].Y;
          OutlineList.Add(Pointer(p1));
          p1.X := poly[2].X;
          p1.Y := poly[2].Y;
          OutlineList.Add(Pointer(p1));
          p1.X := poly[3].X+1;
          p1.Y := poly[3].Y;
          OutlineList.Add(Pointer(p1));
          p1.X := poly[4].X+1;
          p1.Y := poly[4].Y;
          OutlineList.Add(Pointer(p1));

          If I = FTabPositions.Count-1 Then
          Begin
               p1.X := Width-1;
               p1.Y := poly[4].Y;
               OutlineList.Add(Pointer(p1));
               p1.X := Width-1;
               p1.Y := 0;
               OutlineList.Add(Pointer(p1));
          End;

          If IsSelected Then {split topline}
          Begin
               Canvas.Pen.color := clBtnHighlight;
               Canvas.Line(topline1.X, topline1.Y, wabe[0].X, wabe[0].Y);
               Canvas.Line(topline1.X, topline1.Y+1, wabe[0].X, wabe[0].Y+1);
               topline1 := wabe[5];
               {3D}
               Light[0] := wabe[1];
               Light[1] := wabe[2];
               Light[2] := wabe[3];
               Canvas.PolyLine(Light);
               Canvas.Line(Light[1].X,Light[1].Y+1,Light[2].X+1,Light[2].Y+1);

               Canvas.Pen.color := clBtnShadow;
               Canvas.Line(wabe[3].X, wabe[3].Y, wabe[4].X, wabe[4].Y);
               Canvas.Line(wabe[3].X+1, wabe[3].Y, wabe[4].X, wabe[4].Y+1);
          End;


          If FTabStyle = tsOwnerDraw Then
          Begin
               DrawTab(Canvas, rc, I + FFirstIndex, IsSelected);
          End
          Else
          Begin
               Canvas.Pen.color := PenColor;
               Canvas.Brush.Mode := bmTransparent;
               Canvas.TextOut(rc.Left,rc.Bottom,FTabs[I + FirstIndex]);
          End;
     End;

     {Draw rest Of topline}
     Canvas.Pen.color := clBtnHighlight;
     Canvas.Line(topline1.X, topline1.Y, topline2.X, topline2.Y);
     Canvas.Line(topline1.X, topline1.Y+1, topline2.X, topline2.Y+1);


     OutlineList.Destroy;
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TTabSet.GetChildren(Proc:TGetChildProc);
Begin
End;
{$HINTS ON}


Function TTabSet.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  aText:PChar;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     aText := Tabs.GetText;
     If aText <> Nil Then
     Begin
          Result := Stream.NewResourceEntry(rnTabs,aText^,Length(aText^)+1);
          StrDispose(aText);
     End;
End;


Procedure TTabSet.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  aText:PChar;
Begin
     If ResName = rnTabs Then
     Begin
          aText := @Data;
          Tabs.SetText(aText);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TPage Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPage.SetupComponent;
Begin
     Inherited SetupComponent;

     ZOrder := zoNone;
     Align := alClient;
     ParentFont := True;
     ParentPenColor := True;
     ParentColor := True;
     ShowHint := False;
     ParentShowHint := True;
     TabStop := False;
     Visible := False;
     Include(ComponentState, csDetail);
     Include(ComponentState, csAcceptsControls);
     If Designed Then CreateCanvas;
End;


Procedure TPage.LoadedFromSCU(SCUParent:TComponent);
Begin
     Inherited LoadedFromSCU(SCUParent);

     If SCUParent Is TNoteBook Then
     Begin
          TNoteBook(SCUParent).FPages.Add(Self);
          {redirect the Owner}
          If Owner <> Nil Then Owner.RemoveComponent(Self);
          SCUParent.InsertComponent(Self);
     End;
End;


Procedure TPage.Paint(Const rec:TRect);
Var  rc1:TRect;
Begin
     Inherited Paint(rec);

     If Designed Then
     Begin
          rc1 := ClientRect;
          Canvas.Pen.Style := psDash;
          Canvas.Rectangle(rc1);
     End;
End;


Procedure TPage.BringToFront;
Var  NoteBook:TNoteBook;
Begin
     If parent Is TNoteBook Then
     Begin
          NoteBook := TNoteBook(parent);
          If NoteBook.FPages.IndexOf(Self) <> (NoteBook.FPageIndex)
          Then NoteBook.SetPageIndex(NoteBook.FPages.IndexOf(Self));
     End;
     Inherited BringToFront;
End;


Procedure TPage.CreateWnd;
Var  NoteBook:TNoteBook;
Begin
     If parent Is TNoteBook Then
     Begin
          NoteBook := TNoteBook(parent);
          If NoteBook.FPages.IndexOf(Self) <> (NoteBook.FPageIndex) Then Exit;
     End;

     Inherited CreateWnd;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TPageAccess Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TPageAccess.GetPage(Index:LongInt):TPage;
Begin
     Result:=FPages.Items[Index];
End;

Function TPageAccess.GetCount: LongInt;
Begin
     Result := FPages.Count;
End;


Function TPageAccess.Get(Index: LongInt): String;
Var  page:TPage;
Begin
     page := TPage(FPages[Index]);
     Result := page.Caption;
End;


Procedure TPageAccess.Put(Index: LongInt; Const S: String);
Var  page:TPage;
Begin
     Page := TPage(FPages[Index]);
     Page.Caption := GetShortHint(S);
     Page.Hint := GetLongHint(S);
     Page.ShowHint := False;
     If FOnChange <> Nil Then FOnChange(Self);
End;


Function TPageAccess.GetObject(Index: LongInt): TObject;
Begin
     Result := TPage(FPages[Index]);
End;


Procedure TPageAccess.Clear;
Var  page:TPage;
     I:LongInt;
Begin
     For I := 0 To FPages.Count-1 Do
     Begin
          Page := TPage(FPages[I]);
          Page.Destroy;
     End;
     FPages.Clear;
     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TPageAccess.Delete(Index: LongInt);
Var  page:TPage;
Begin
     Page := TPage(FPages[Index]);
     Page.Destroy;
     FPages.Delete(Index);
     NoteBook.PageIndex := 0;
     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TPageAccess.Insert(Index: LongInt; Const S: String);
Var  page:TPage;
Begin
     Page.Create(NoteBook);
     NoteBook.InsertControl(Page);
     Page.SetWindowPos(0,0,NoteBook.Width,NoteBook.Height);
     Page.Caption := GetShortHint(S);
     Page.Hint := GetLongHint(S);
     FPages.Insert(Index, Page);

     NoteBook.PageIndex := Index;
     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TPageAccess.Move(CurIndex, NewIndex: LongInt);
Var  page:TObject;
Begin
     If CurIndex <> NewIndex Then
     Begin
          Page := FPages[CurIndex];
          FPages[CurIndex] := FPages[NewIndex];
          FPages[NewIndex] := page;
     End;
     If FOnChange <> Nil Then FOnChange(Self);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TNoteBook Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
   TPageRegistered:Boolean=False;

Procedure TNoteBook.SetupComponent;
Begin
     Inherited SetupComponent;

     FPages.Create;
     FPageIndex := -1;
     FAccess.Create;
     FAccess.FPages := FPages;
     FAccess.FNotebook := Self;
     FAccess.Add('Default');
     PageIndex := 0;

     Width := 200;
     Height := 200;
     ParentPenColor := True;
     ParentColor := True;

     If Not TPageRegistered Then
     Begin
          RegisterClasses([TPage]); {RuntimeSCU}
          TPageRegistered := True;
     End;
End;


Procedure TNoteBook.SetupShow;
Var  page:TPage;
Begin
     Inherited SetupShow;

     If (FPageIndex >= 0) And (FPageIndex < FPages.Count) Then
     Begin
          Page := FPages.Items[FPageIndex];
          Page.CreateWnd;
          Page.BringToFront;
          Page.Show;
     End
     Else FPageIndex := -1;
End;


Destructor TNoteBook.Destroy;
Begin
     FPages.Destroy;
     FPages := Nil;
     FAccess.Destroy;
     FAccess := Nil;

     Inherited Destroy;
End;


Procedure TNoteBook.GetDesignerPopupEvents(AString:TStringList);
Begin
     AddDesignerPopupEvent(AString, LoadNLSStr(SNextPage), 1);
     AddDesignerPopupEvent(AString, LoadNLSStr(SPreviousPage), -1);
End;


Procedure TNoteBook.DesignerPopupEvent(Id:LongInt);
Begin
     Case Id Of
        1: If PageIndex < Pages.Count-1 Then PageIndex := PageIndex + 1;
       -1: If PageIndex > 0 Then PageIndex := PageIndex - 1;
     End;
End;


Procedure TNoteBook.GetChildren(Proc:TGetChildProc);
Var  page:TPage;
     I:LongInt;
Begin
     For I := 0 To FPages.Count-1 Do
     Begin
          page := TPage(FPages[I]);
          Proc(page);
     End;
End;


Procedure TNoteBook.LoadingFromSCU(SCUParent:TComponent);
Begin
     Inherited LoadingFromSCU(SCUParent);

     FPages.Clear;
End;


Function TNoteBook.GetActivePage:String;
Begin
     Result := '';
     If (FPageIndex < 0) Or (FPageIndex >= FAccess.Count) Then Exit;
     Result := GetShortHint(FAccess[FPageIndex]);
End;


Procedure TNoteBook.SetActivePage(Const Value:String);
Begin
     SetPageIndex(FAccess.IndexOf(Value));
End;


Procedure TNoteBook.SetPageIndex(Value:LongInt);
Var  page,OldPage:TPage;
     OldPageIndex:LongInt;
{$IFDEF OS2}
     Control: TControl;
     I      : LongInt;
{$ENDIF}

Begin
     If ComponentState * [csReading] <> [] Then
     Begin
          FPageIndex := Value;
          Exit;
     End;

     If Value = FPageIndex Then Exit;
     If (Value < 0) Or (Value >= FPages.Count) Then Exit;

     OldPageIndex := FPageIndex;
     FPageIndex := Value;

     If Handle <> 0 Then
     Begin
          If (OldPageIndex >= 0) And (OldPageIndex < FPages.Count) Then
          Begin
               OldPage := FPages.Items[OldPageIndex];
               OldPage.Hide;
          End
          Else OldPage := Nil; {wozu}

          page := FPages.Items[FPageIndex];
          page.Show;
          page.BringToFront;

          {Focus First Control}
          {$IFDEF OS2} //Redraw Fehler in Win32 für Controls, au฿erdem gings nicht...
          If Not Designed Then
            If Form <> Nil Then
              If Not (Form.ActiveControl Is TTabSet) Then
          Begin
               Page.Focus;
               For I := 0 To Page.ControlCount-1 Do
               Begin
                    Control := Page.Controls[I];
                    If Control.Visible Then
                      If Control.TabStop Then
                      Begin
                           Control.Focus;
                           break;
                      End;
               End;
          End;
          {$ENDIF}
     End;
     If FOnPageChanged <> Nil Then FOnPageChanged(Self);
End;


Procedure TNoteBook.SetPages(Value:TPageAccess);
Begin
     If Value <> FAccess Then FAccess.Assign(Value);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TNotebookTabSet Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TQueryTabColorEvent=Procedure(Sender:TObject;Index:LongInt;
                                  Var TabColor:TColor) Of Object;

    TNotebookTabSet=Class(TTabSet)
      Private
         TabbedNotebook:TTabbedNotebook;
         FOnQueryTabColor:TQueryTabColorEvent;
      Protected
         Procedure SetupComponent;Override;
         Function GetTabColor(Index:LongInt):TColor;Override;
         Procedure RedrawBottom(Const rec:TRect);Override;
         Procedure RedrawTop(Const rec:TRect);Override;
      Public
         Property OnQueryTabColor:TQueryTabColorEvent
                  Read FOnQueryTabColor Write FOnQueryTabColor;
    End;


Procedure TNotebookTabSet.SetupComponent;
Begin
    Inherited SetupComponent;
    {$IFDEF WIN32}
    Color:=clLtGray;
    {$ENDIF}
End;


Function TNotebookTabSet.GetTabColor(Index:LongInt):TColor;
Begin
     Result := Inherited GetTabColor(Index);

     If FOnQueryTabColor <> Nil
     Then FOnQueryTabColor(Self,Index,Result);
End;


Procedure TNotebookTabSet.RedrawBottom(Const rec:TRect);
Var  rc:TRect;
     I:LongInt;
     TabPos:TTabPos;
     Y,CY:LongInt;
     IsSelected:Boolean;
     wabe:TRect;
     leftvis,rightvis:Boolean;
     topline1,topline2:TPoint;
     EdgeWidthDiv2:LongInt;
     OutlineList:TList;
     p1,p2:TShortPos;
     pPoly:PPointArray;
Begin
     If TabbedNotebook.FRectangleTabs Then
     Begin
          Canvas.Brush.Style := bsSolid;

          EdgeWidthDiv2 := (EdgeWidth + 1) Div 2;   {Left side Of tab}
          topline1.X := 0;
          topline1.Y := Height - 1;
          topline2.X := Width - 1;
          topline2.Y := Height - 1;
          CY := FTabHeight;
          Y := Height - TopMargin - CY;   {textline}

          OutlineList.Create;
          p1.X := 0;
          p1.Y := Height - 2;
          OutlineList.Add(Pointer(p1));

          For I := 0 To FTabPositions.Count-1 Do
          Begin
               TabPos := TTabPos(FTabPositions[I]);
               rc := Rect(TabPos.Start, Y, TabPos.Start+TabPos.Size-1, Y+CY-1);

               IsSelected := (I + FFirstIndex) = FTabIndex;
               leftvis := (I + FirstIndex <> FTabIndex + 1) Or (I = 0);
               rightvis := (I + FirstIndex <> FTabIndex - 1) Or (I = FTabPositions.Count-1);

               wabe := rc;
               Dec(wabe.Left, (EdgeWidthDiv2 - 2));   {BorderWidth = 2}
               Inc(wabe.Right, (EdgeWidth - EdgeWidthDiv2 - 2));

               If IsSelected Then
               Begin
                    Forms.InflateRect(wabe, 2, 2);
               End;

               Canvas.Pen.color := GetTabColor(I + FFirstIndex);

               Canvas.BeginPath;
               Canvas.Rectangle(wabe);
               Canvas.EndPath;
               Canvas.FillPath;

               If leftvis Then
               Begin
                    Canvas.Pen.color := clLtGray;
                    Canvas.Line(wabe.Left-1,wabe.Bottom,wabe.Left-1,wabe.Top);
                    Canvas.Pen.color := clBtnHighlight;
                    Canvas.Line(wabe.Left-2,wabe.Bottom,wabe.Left-2,wabe.Top);
                    Canvas.Pixels[wabe.Left-1,wabe.Bottom-1] := clBtnHighlight;
               End;

               If I = 0 Then
               Begin
                    p1.X := wabe.Left-2;
                    p1.Y := Height-2;
                    OutlineList.Add(Pointer(p1));
               End;
               p1.X := wabe.Left-2;
               p1.Y := wabe.Bottom;
               OutlineList.Add(Pointer(p1));

               Canvas.Pen.color := clBtnShadow;
               Canvas.Line(wabe.Left,wabe.Bottom-1,wabe.Right,wabe.Bottom-1);
               Canvas.Pen.color := clBlack;
               Canvas.Line(wabe.Left+1,wabe.Bottom-2,wabe.Right,wabe.Bottom-2);

               p1.X := wabe.Left;
               p1.Y := wabe.Bottom-2;
               OutlineList.Add(Pointer(p1));
               p1.X := wabe.Right;
               p1.Y := wabe.Bottom-2;
               OutlineList.Add(Pointer(p1));

               If rightvis Then
               Begin
                    Canvas.Pixels[wabe.Right+1,wabe.Bottom-1] := clBlack;
                    Canvas.Pen.color := clBtnShadow;
                    Canvas.Line(wabe.Right+1,wabe.Bottom,wabe.Right+1,wabe.Top);
                    Canvas.Pen.color := clBlack;
                    Canvas.Line(wabe.Right+2,wabe.Bottom,wabe.Right+2,wabe.Top);
               End;

               p1.X := wabe.Right+2;
               p1.Y := wabe.Bottom;
               OutlineList.Add(Pointer(p1));
               If I = FTabPositions.Count-1 Then
               Begin
                    p1.X := wabe.Right+2;
                    p1.Y := Height-2;
                    OutlineList.Add(Pointer(p1));
                    p1.X := Width-1;
                    p1.Y := Height-2;
                    OutlineList.Add(Pointer(p1));
                    p1.X := Width-1;
                    p1.Y := Height-1;
                    OutlineList.Add(Pointer(p1));
               End;


               If IsSelected Then {split topline}
               Begin
                    If I > 0 Then
                    Begin
                         Canvas.Pen.color := clBlack;
                         Canvas.Line(topline1.X, topline1.Y-1, wabe.Left-3,topline1.Y-1);
                         Canvas.Pen.color := clBtnShadow;
                         Canvas.Line(topline1.X, topline1.Y, wabe.Left-2,topline1.Y);
                    End;

                    topline1.X := wabe.Right+2;
               End;

               DrawTab(Canvas, rc, I + FFirstIndex, IsSelected);
          End;

          {Draw rest Of topline}
          Canvas.Pen.color := clBlack;
          Canvas.Line(topline1.X, topline1.Y-1, topline2.X, topline2.Y-1);
          Canvas.Pen.color := clBtnShadow;
          Canvas.Line(topline1.X, topline1.Y, topline2.X, topline2.Y);

          Canvas.Pixels[topline2.X, topline2.Y] := clBlack;


          p1.X := 0;  {Start & End}
          p1.Y := Height-1;
          OutlineList.Add(Pointer(p1));

          GetMem(pPoly, SizeOf(TPoint) * (OutlineList.Count+1));

          For I := 0 To OutlineList.Count-1 Do
          Begin
               p2 := TShortPos(OutlineList[I]);
               pPoly^[I].X := p2.X;
               pPoly^[I].Y := p2.Y;
          End;
          pPoly^[OutlineList.Count].X := p1.X;
          pPoly^[OutlineList.Count].Y := p1.Y;

          Canvas.BeginPath;
          Canvas.PolyLine(Slice(pPoly^,OutlineList.Count));
          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);

          FreeMem(pPoly, SizeOf(TPoint) * (OutlineList.Count+1));
          OutlineList.Destroy;

          {background}
          Canvas.Brush.Color := Color;
          Canvas.Pen.Color := Color;
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Mode := bmOpaque;
          Canvas.Box(ClientRect);
     End
     Else Inherited RedrawBottom(rec);
End;


Procedure TNotebookTabSet.RedrawTop(Const rec:TRect);
Var  rc:TRect;
     I:LongInt;
     TabPos:TTabPos;
     Y,CY:LongInt;
     IsSelected:Boolean;
     wabe:TRect;
     leftvis,rightvis:Boolean;
     topline1,topline2:TPoint;
     EdgeWidthDiv2:LongInt;
     OutlineList:TList;
     p1,p2:TShortPos;
     pPoly:PPointArray;
Begin
     If TabbedNotebook.FRectangleTabs Then
     Begin
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Mode := bmOpaque;

          EdgeWidthDiv2 := (EdgeWidth + 1) Div 2;   {Left side Of tab}
          topline1.X := 0;
          topline1.Y := 0;
          topline2.X := Width -1;
          topline2.Y := 0;
          CY := FTabHeight;
          Y := 2; {textline}

          OutlineList.Create;
          p1.X := 0;
          p1.Y := 1;
          OutlineList.Add(Pointer(p1));

          For I := 0 To FTabPositions.Count-1 Do
          Begin
               TabPos := TTabPos(FTabPositions[I]);
               rc := Rect(TabPos.Start, Y, TabPos.Start+TabPos.Size-1, Y+CY-1);

               IsSelected := (I + FFirstIndex) = FTabIndex;
               leftvis := (I + FirstIndex <> FTabIndex + 1) Or (I = 0);
               rightvis := (I + FirstIndex <> FTabIndex - 1) Or (I = FTabPositions.Count-1);

               wabe := rc;
               Dec(wabe.Left, (EdgeWidthDiv2 - 2));   {BorderWidth = 2}
               Inc(wabe.Right, (EdgeWidth - EdgeWidthDiv2 - 2));

               If IsSelected Then
               Begin
                    Forms.InflateRect(wabe, 2, 2);
               End;

               Canvas.Pen.color := GetTabColor(I + FFirstIndex);

               Canvas.BeginPath;
               Canvas.Rectangle(wabe);
               Canvas.EndPath;
               Canvas.FillPath;

               If leftvis Then
               Begin
                    Canvas.Pen.color := clLtGray;
                    Canvas.Line(wabe.Left-1,rc.Bottom-1,wabe.Left-1,wabe.Top);
                    Canvas.Pen.color := clBtnHighlight;
                    Canvas.Line(wabe.Left-2,rc.Bottom-1,wabe.Left-2,wabe.Top);
                    Canvas.Pixels[wabe.Left-1,wabe.Top+1] := clBtnHighlight;
               End;

               If I = 0 Then
               Begin
                    p1.X := wabe.Left-2;
                    p1.Y := 1;
                    OutlineList.Add(Pointer(p1));
               End;
               p1.X := wabe.Left-2;
               p1.Y := wabe.Top;
               OutlineList.Add(Pointer(p1));

               Canvas.Pen.color := clBtnHighlight;
               Canvas.Line(wabe.Left,wabe.Top+2,wabe.Right,wabe.Top+2);
               Canvas.Pen.color := clLtGray;
               Canvas.Line(wabe.Left,wabe.Top+1,wabe.Right,wabe.Top+1);

               p1.X := wabe.Left;
               p1.Y := wabe.Top+2;
               OutlineList.Add(Pointer(p1));
               p1.X := wabe.Right;
               p1.Y := wabe.Top+2;
               OutlineList.Add(Pointer(p1));

               If rightvis Then
               Begin
                    Canvas.Pixels[wabe.Right+1,wabe.Top+1] := clBtnHighlight;
                    Canvas.Pen.color := clBtnShadow;
                    Canvas.Line(wabe.Right+1,rc.Bottom-1,wabe.Right+1,wabe.Top);
                    Canvas.Pen.color := clBlack;
                    Canvas.Line(wabe.Right+2,rc.Bottom,wabe.Right+2,wabe.Top);
               End;

               p1.X := wabe.Right+2;
               p1.Y := wabe.Top;
               OutlineList.Add(Pointer(p1));
               If I = FTabPositions.Count-1 Then
               Begin
                    p1.X := wabe.Right+2;
                    p1.Y := 1;
                    OutlineList.Add(Pointer(p1));
                    p1.X := Width-1;
                    p1.Y := 1;
                    OutlineList.Add(Pointer(p1));
                    p1.X := Width-1;
                    p1.Y := 0;
                    OutlineList.Add(Pointer(p1));
               End;

               If IsSelected Then {split topline}
               Begin
                    If I > 0 Then
                    Begin
                         Canvas.Pen.color := clLtGray;
                         Canvas.Line(topline1.X, topline1.Y, wabe.Left,topline1.Y);
                         Canvas.Pen.color := clBtnHighlight;
                         Canvas.Line(topline1.X, topline1.Y+1, wabe.Left-2,topline1.Y+1);
                    End;

                    topline1.X := wabe.Right+2;
               End;

               DrawTab(Canvas, rc, I + FFirstIndex, IsSelected);
          End;

          {Draw rest Of topline}
          Canvas.Pen.color := clLtGray;
          Canvas.Line(topline1.X-1, topline1.Y, topline2.X, topline2.Y);
          Canvas.Pen.color := clBtnHighlight;
          Canvas.Line(topline1.X, topline1.Y+1, topline2.X, topline2.Y+1);

          Canvas.Pixels[0, 0] := clBtnHighlight;
          Canvas.Pixels[1, 0] := clLtGray;
          Canvas.Pixels[topline2.X, topline2.Y] := clBlack;
          Canvas.Pixels[topline2.X, topline2.Y+1] := clBlack;
          Canvas.Pixels[topline2.X-1, topline2.Y] := clDkGray;
          Canvas.Pixels[topline2.X-1, topline2.Y+1] := clDkGray;

          p1.X := 0;  {Start & End}
          p1.Y := 0;
          OutlineList.Add(Pointer(p1));

          GetMem(pPoly, SizeOf(TPoint) * (OutlineList.Count+1));

          For I := 0 To OutlineList.Count-1 Do
          Begin
               p2 := TShortPos(OutlineList[I]);
               pPoly^[I].X := p2.X;
               pPoly^[I].Y := p2.Y;
          End;
          pPoly^[OutlineList.Count].X := p1.X;
          pPoly^[OutlineList.Count].Y := p1.Y;

          Canvas.BeginPath;
          Canvas.PolyLine(Slice(pPoly^,OutlineList.Count));
          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);

          FreeMem(pPoly, SizeOf(TPoint) * (OutlineList.Count+1));
          OutlineList.Destroy;

          {background}
          Canvas.Brush.Color := Color;
          Canvas.Pen.Color := Color;
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Mode := bmOpaque;
          Canvas.Box(ClientRect);
     End
     Else Inherited RedrawTop(rec);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TTabbedNotebook Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
     NotebookMargin=10;
     HintMargin=30;
     HintIndent=5;
     PopupCmdBase=cmUser-100;


Procedure TTabbedNotebook.SetEnabled(NewState:Boolean);

Begin
  inherited SetEnabled(NewState);
  Resize;   { Wird ben”tigt, damit Windows die Objekte z.b. tEdit korrekt darstellt }
End;

Function TTabbedNotebook.GetEnabled:Boolean;

Begin
  Result:=inherited GetEnabled;
End;


Procedure TTabbedNotebook.SetupComponent;
Begin
     Inherited SetupComponent;

     Width := 200;
     Height := 200;
     Color := clDlgWindow;
     TabStop := False;
     
     FTabSet := TNotebookTabSet.Create(Self);
     TNotebookTabSet(FTabSet).TabbedNotebook := Self;
     FTabSet.Align := alTop;
     FTabSet.Alignment := taTop;
     FTabSet.ParentColor := True;
     FTabSet.DitherBackground := False;
     FTabSet.SelectedColor := Color;
     FTabSet.UnselectedColor := clDkGray; {??}
     FTabSet.Height := 25;
     FTabSet.TabHeight := 21;
     FTabSet.TabStop := True;
     FTabSet.OnClick := EvTabSetClicked;
     FTabSet.OnChange := EvCanChange;
     FTabSet.OnMeasureTab := EvMeasureTab;
     FTabSet.OnDrawTab := EvDrawTab;
     FTabSet.OnMouseClick := EvMouseClick;
     TNotebookTabSet(FTabSet).OnQueryTabColor := EvQueryTabColor;
     FTabSet.SetDesigning(Designed);
     FTabSet.TabStyle := tsOwnerDraw;
     Include(FTabSet.ComponentState, csDetail);
     InsertControl(FTabSet);

     FNotebook.Create(Self);
     FNotebook.TabStop := False;
     FNotebook.OnPageChanged := EvPageIndexChanged;
     FNotebook.FAccess.FOnChange := EvPageAccessChanged;
     FNotebook.SetDesigning(Designed);
     Include(FNotebook.ComponentState, csDetail);
     InsertControl(FNotebook);

     FAutoPopup := False;
     Style := nsDefault;

     EvPageAccessChanged(Nil);
     Resize;
     OnMouseClick := EvMouseClick;
     {clip TabSet At runtime}
     If Not Designed Then Include(ComponentState, csAcceptsControls);
End;


Procedure TTabbedNotebook.SetupShow;
Begin
     Inherited SetupShow;

     Resize;
End;

Procedure TTabbedNotebook.FontChange;
Begin
     Resize;

     Inherited FontChange;
End;


Procedure TTabbedNotebook.Resize;
Var  rcNotebook:TRect;
     yhint,yedge,xedge:LongInt;
     PageCountIndent:LongInt;
     I: Integer;

Begin
  Inherited Resize;
  If FTabSet=Nil Then exit;

  If TabAlignment = taTop
    Then
      Begin
        rcNotebook := Rect(NotebookMargin,
                           NotebookMargin,
                           Width - NotebookMargin,
                           Height - FTabSet.Height - NotebookMargin);
        If FShowPageHint Then
          Begin
            Forms.InflateRect(rcNotebook, -5, -5);
            Dec(rcNotebook.Top, HintMargin);
            yhint := rcNotebook.Top + 5;
            yedge := rcNotebook.Top + 3;
          End;
      End
    Else
      Begin
        rcNotebook := Rect(NotebookMargin,
                           NotebookMargin + FTabSet.Height,
                           Width - NotebookMargin,
                           Height - NotebookMargin);
        If FShowPageHint Then
          Begin
            Forms.InflateRect(rcNotebook, -5, -5);
            Inc(rcNotebook.Bottom, HintMargin);
            yhint := rcNotebook.Bottom - 10 - 20;
            yedge := rcNotebook.Bottom - HintMargin - 2;
          End;
      End;

  FNotebook.SetWindowPos(rcNotebook.Left,
                         rcNotebook.Bottom,
                         rcNotebook.Right - rcNotebook.Left,
                         rcNotebook.Top - rcNotebook.Bottom);

  If FEdge <> Nil Then
    Begin
      xedge := FNotebook.Left + FNotebook.Width - HintMargin + 2;
      FEdge.SetWindowPos(xedge, yedge, HintMargin, HintMargin);
    End;

  If Canvas <> Nil
    Then PageCountIndent := Canvas.TextWidth('Page 9 of 9')
    Else PageCountIndent := 100;

  If FPageCount <> Nil then
    FPageCount.SetWindowPos(xedge-PageCountIndent,
                                  yhint,
                                  PageCountIndent,
                                  20);

  If FPageHint <> Nil then
    FPageHint.SetWindowPos(rcNotebook.Left+HintIndent,
                                 yhint,
                                 FNotebook.Width-2*HintIndent-HintMargin,
                                 20);

  for I:=0 to Pages.Count-1 do
    Pages.Pages[I].Resize;
End;


Procedure TTabbedNotebook.GetChildren(Proc:TGetChildProc);
Begin
     FNotebook.GetChildren(Proc);
End;


Procedure TTabbedNotebook.LoadingFromSCU(SCUParent:TComponent);
Begin
     Inherited LoadingFromSCU(SCUParent);

     FNotebook.Pages.Clear;
End;


Procedure TTabbedNotebook.LoadedFromSCU(SCUParent:TComponent);
Var  I:LongInt;
     page:TControl;
Begin
     Inherited LoadedFromSCU(SCUParent);

     For I := ControlCount-1 DownTo 0 Do
     Begin
          page := Controls[I];
          If page Is TPage Then
          Begin
               FNotebook.FPages.Insert(0,Page);
               page.parent := FNotebook;
               {redirect the Owner}
               If Page.Owner <> Nil Then Page.Owner.RemoveComponent(page);
               FNotebook.InsertComponent(Page);
          End;
     End;

     EvPageAccessChanged(Nil);
     Resize; {Resize the NoteBook}
End;


Function TTabbedNotebook.GetActivePage:String;
Begin
     Result := FNotebook.ActivePage;
End;


Procedure TTabbedNotebook.SetActivePage(Value:String);
Begin
     FNotebook.ActivePage := Value;
End;


Function TTabbedNotebook.GetPageRect:TRect;
Begin
    Result:=FNotebook.BoundsRect;
End;


Function TTabbedNotebook.GetPageIndex:LongInt;
Begin
     Result := FNotebook.PageIndex;
End;


Procedure TTabbedNotebook.SetPageIndex(Value:LongInt);
Var  page:TPage;
Begin
     IgnoreTabClick := True;   {ignore the event handler}
     If ComponentState * [csReading] <> [] Then
     Begin
          FNotebook.FPageIndex := Value; {Update With NoteBook.SetupShow}
     End
     Else
     Begin
          Page := TPage(FNotebook.Pages.Objects[Value]);
          If Page.Enabled Then FNotebook.PageIndex := Value;
     End;
     IgnoreTabClick := False;
     {Martin0407: additional code to make sure that the tab of the current page is part of the shown tabs}
     if Value < fTabset.FirstIndex then fTabset.FirstIndex := Value
     else if Value > fTabset.LastIndex then fTabset.FirstIndex := fTabset.FirstIndex + Value - fTabset.LastIndex;
End;


Function TTabbedNotebook.GetPages:TPageAccess;
Begin
     Result := FNotebook.Pages;
End;


Procedure TTabbedNotebook.SetPages(Value:TPageAccess);
Begin
     FNotebook.Pages := Value;
End;


Function TTabbedNotebook.GetTabFont:TFont;
Begin
     Result := FTabSet.Font;
End;


Procedure TTabbedNotebook.SetTabFont(Value:TFont);
Begin
     FTabSet.Font := Value;
End;


Function TTabbedNotebook.GetTabAlignment:TTabAlignment;
Begin
     If FTabSet<>Nil Then Result := FTabSet.Alignment
     Else Result:=taTop;
End;


Procedure TTabbedNotebook.SetTabAlignment(Value:TTabAlignment);
Begin
     If FTabSet.Alignment <> Value Then
     Begin
          FTabSet.Alignment := Value;
          If FTabSet.Alignment = taTop Then FTabSet.Align := alTop
          Else FTabSet.Align := alBottom;
          LoadEdge;
          Resize;
          Invalidate;
     End;
End;


Procedure TTabbedNotebook.SetStyle(Value:TTabbedNotebookStyle);
Begin
     FStyle := Value;

     Case Value Of
       nsDefault:
       Begin
            {$IFDEF OS2}
            ColorTabs := True;
            ShowPageHint := True;
            RectangleTabs := False;
            {$ENDIF}
            {$IFDEF Win32}
            ColorTabs := False;
            ShowPageHint := True;
            RectangleTabs := True; //????????
            {$ENDIF}
       End;
       nsWarp4:
       Begin
            ColorTabs := True;
            ShowPageHint := True;
            RectangleTabs := False;
       End;
       nsWin32:
       Begin
            ColorTabs := False;
            ShowPageHint := False;
            RectangleTabs := True;
       End;
     End;
End;


Procedure TTabbedNotebook.SetColorTabs(Value:Boolean);
Begin
     If FColorTabs <> Value Then
     Begin
          FColorTabs := Value;
          FTabSet.Invalidate;
     End;
End;


Procedure TTabbedNotebook.SetShowPageHint(Value:Boolean);
Begin
     If FShowPageHint <> Value Then
     Begin
          FShowPageHint := Value;
          If FShowPageHint Then
          Begin
               If FEdge = Nil Then FEdge.Create(Self);
               Include(FEdge.ComponentState, csDetail);
               FEdge.ZOrder := zoTop;
               FEdge.SetDesigning(Designed);
               LoadEdge;
               FEdge.OnMouseDown := EvEdgeMouseDown;
               FEdge.OnMouseUp := EvEdgeMouseUp;
               FEdge.OnMouseClick := EvMouseClick;
               InsertControl(FEdge);

               If FPageCount = Nil Then FPageCount.Create(Self);
               Include(FPageCount.ComponentState, csDetail);
               FPageCount.Alignment := taRightJustify;
               FPageCount.ZOrder := zoTop;
               FPageCount.SetDesigning(Designed);
               FPageCount.OnMouseClick := EvMouseClick;
               InsertControl(FPageCount);

               If FPageHint = Nil Then FPageHint.Create(Self);
               Include(FPageHint.ComponentState, csDetail);
               FPageHint.ZOrder := zoBottom;
               FPageHint.SetDesigning(Designed);
               FPageHint.OnMouseClick := EvMouseClick;
               InsertControl(FPageHint);

               {Update labels}
               EvPageIndexChanged(Nil);
          End
          Else
          Begin
               If FEdge <> Nil Then FEdge.Destroy;
               FEdge := Nil;
               LastEdgeBmpId := '';

               If FPageCount <> Nil Then FPageCount.Destroy;
               FPageCount := Nil;

               If FPageHint <> Nil Then FPageHint.Destroy;
               FPageHint := Nil;
          End;
          Resize;
          Invalidate;
     End;
End;


Procedure TTabbedNotebook.SetRectangleTabs(Value:Boolean);
Begin
     If FRectangleTabs <> Value Then
     Begin
          FRectangleTabs := Value;
          If Value Then
          Begin
               FTabSet.FTabHeight := FTabSet.Height - 6;
               FTabSet.FStartMargin := -2;
               FTabSet.FEndMargin := -3;
          End
          Else
          Begin
               FTabSet.FTabHeight := FTabSet.Height - 4;
               FTabSet.FStartMargin := 5;
               FTabSet.FEndMargin := 5;
          End;
          FTabSet.ArrangeTabs;
          FTabSet.Invalidate;
     End;
End;


Function TTabbedNotebook.GetTabHeight:LongInt;
Begin
     Result := FTabSet.Height;
End;


Procedure TTabbedNotebook.SetTabHeight(Value:LongInt);
Begin
     FTabSet.Height := Value;
     If FRectangleTabs Then FTabSet.TabHeight := Value - 6
     Else FTabSet.TabHeight := Value - 4;
     Resize;
End;


Function TTabbedNotebook.GetPageHint:String;
Begin
     If FPageHint <> Nil Then Result := FPageHint.Caption
     Else Result := '';
End;


Procedure TTabbedNotebook.SetPageHint(Const Value:String);
Begin
     If FPageHint <> Nil Then
       If FPageHint.Caption <> Value Then FPageHint.Caption := Value;
End;


Procedure TTabbedNotebook.LoadEdge;
Var  NewEdgeBmpId:String[30];
Begin
     If FEdge = Nil Then Exit;

     If TabAlignment = taTop Then
     Begin
          If FNotebook.PageIndex = 0 Then NewEdgeBmpId := 'StdBmpEdgeTopPlus'
          Else If FNotebook.PageIndex = FNotebook.Pages.Count-1
               Then NewEdgeBmpId := 'StdBmpEdgeTopMinus'
               Else NewEdgeBmpId := 'StdBmpEdgeTop';
     End
     Else
     Begin
          If FNotebook.PageIndex = 0 Then NewEdgeBmpId := 'StdBmpEdgeBottomPlus'
          Else If FNotebook.PageIndex = FNotebook.Pages.Count-1
               Then NewEdgeBmpId := 'StdBmpEdgeBottomMinus'
               Else NewEdgeBmpId := 'StdBmpEdgeBottom';
     End;

     If NewEdgeBmpId <> LastEdgeBmpId Then
     Begin
          FEdge.Bitmap.LoadFromResourceName(NewEdgeBmpId);
          FEdge.Invalidate;
          LastEdgeBmpId := NewEdgeBmpId;
     End;
End;


Procedure TTabbedNotebook.ArrangeSubPages;
Var  page:TPage;
     LastMainPage:TPage;
     SubCount:LongInt;
     SubIndex:LongInt;
     MainIndex:LongInt;
     I:LongInt;
Begin
     If FNotebook.Pages.Count = 0 Then Exit;
     SubCount := 0;
     SubIndex := 1;
     MainIndex := 0;
     LastMainPage := TPage(FNotebook.Pages.Objects[0]);

     For I := 0 To FNotebook.Pages.Count-1 Do
     Begin
          page := TPage(FNotebook.Pages.Objects[I]);

          If (page.Caption <> '') Or (I = 0) Then   {main page}
          Begin
               LastMainPage.SubCount := SubCount;
               page.SubCount := 0;
               page.SubIndex := 0;
               page.MainIndex := MainIndex;
               page.FIsSubPage := False;
               SubCount := 0;
               SubIndex := 1;
               Inc(MainIndex);
               LastMainPage := page;
          End
          Else
          Begin
               page.SubCount := 0;
               page.SubIndex := SubIndex;
               page.MainIndex := MainIndex-1;
               page.FIsSubPage := True;
               Inc(SubIndex);
               Inc(SubCount);
          End;
     End;

     LastMainPage.SubCount := SubCount;
End;


Function TTabbedNotebook.Tab2Page(TabIdx:LongInt):LongInt;
Var  page:TPage;
     PageIdx:LongInt;
     I:LongInt;
Begin
     PageIdx := -1;
     For I := 0 To FNotebook.Pages.Count-1 Do
     Begin
          page := TPage(FNotebook.Pages.Objects[I]);
          If page.SubIndex = 0 Then Inc(PageIdx); {main page}

          Result := I;
          If TabIdx = PageIdx Then Exit;
     End;
     Result := -1;
End;


Function TTabbedNotebook.Page2Tab(PageIdx:LongInt):LongInt;
Var  page:TPage;
     I:LongInt;
Begin
     Result := 0;
     For I := 1 To PageIdx Do
     Begin
          page := TPage(FNotebook.Pages.Objects[I]);
          If page.SubIndex = 0 Then Inc(Result); {main page}
     End;
End;


{$HINTS OFF}
Procedure TTabbedNotebook.EvTabSetClicked(Sender:TObject);
Begin
     {ignore TabSet.OnClick If it was Not A mouse event}
     If Not IgnoreTabClick
     Then FNotebook.PageIndex := Tab2Page(FTabSet.TabIndex);
End;


Procedure TTabbedNotebook.EvPageIndexChanged(Sender:TObject);
Var  page:TPage;
     LastMainPage:TPage;
     S:String;
Begin
     {Test If Pages available And page (PageIndex) can exist}
     If (FNotebook.PageIndex < 0) Or
        (FNotebook.PageIndex >= FNotebook.Pages.Count) Then Exit;

     FTabSet.TabIndex := Page2Tab(FNotebook.PageIndex);

     If FShowPageHint Then
     Begin
          LoadEdge;
          page := TPage(FNotebook.Pages.Objects[FNotebook.PageIndex]);
          If FPageHint <> Nil Then FPageHint.Text := page.Hint;
          If FPageCount <> Nil Then
          Begin
               If (page.SubIndex > 0) Or (page.SubCount > 0) Then
               Begin
                    LastMainPage := TPage(FNotebook.Pages.Objects[FNotebook.PageIndex-page.SubIndex]);
                    S := 'Page ' + tostr(page.SubIndex+1) + ' of ' +
                                   tostr(LastMainPage.SubCount+1);
                    FPageCount.Text := S;
                    FPageCount.Visible := True;
               End
               Else
               Begin
                    FPageCount.Text := '';
                    FPageCount.Visible := False;
               End;
          End;
     End;

     If Sender <> Nil Then {no manual call}
       If FOnPageChanged <> Nil Then FOnPageChanged(Self);
End;


Procedure TTabbedNotebook.EvPageAccessChanged(Sender:TObject);
Var  PackedPages:TStringList;
     I:LongInt;
Begin
     ArrangeSubPages;

     PackedPages.Create;
     PackedPages.Assign(FNotebook.Pages);
     For I := PackedPages.Count-1 DownTo 1 Do
     Begin
          If PackedPages[I] = '' Then PackedPages.Delete(I);
     End;
     FTabSet.Tabs := PackedPages;
     PackedPages.Destroy;

     EvPageIndexChanged(Nil);

     If PagesPopup <> Nil Then
     Begin
          PagesPopup.Destroy;
          PagesPopup := Nil;
     End;
End;


Procedure TTabbedNotebook.EvCanChange(Sender:TObject;NewTab:LongInt;Var AllowChange:Boolean);
Var  page:TPage;
Begin
     page := TPage(FNotebook.Pages.Objects[Tab2Page(NewTab)]);
     AllowChange := page.Enabled;
End;


Procedure TTabbedNotebook.EvMeasureTab(Sender:TObject;Index:LongInt;Var TabSize:LongInt);
Begin
     TabSize := TabSize + 15;
End;


Procedure TTabbedNotebook.EvDrawTab(Sender:TObject;TabCanvas:TCanvas;rec:TRect;Index:LongInt;Selected:Boolean);
Var  S:String;
     P:Integer;
     X,Y,CX,CY:LongInt;
     allow:Boolean;
     OldTabFont:TFont;
Begin
     If FColorTabs Then TabCanvas.Pen.color := PenColor
     Else TabCanvas.Pen.color := OppositeRGB(color);

     EvCanChange(FTabSet,Index,allow);
     If Not allow Then
       If Not FColorTabs Then TabCanvas.Pen.color := clDkGray;

     If Selected Then
     Begin
          OldTabFont := FTabSet.Font;
          If OldTabFont.FaceName = 'WarpSans' Then
            If Not (faBold In OldTabFont.Attributes)
            Then TabCanvas.Font := Screen.GetFontFromPointSize(
                                 OldTabFont.FaceName + ' Bold',
                                 OldTabFont.PointSize);
     End;

     S := FTabSet.Tabs[Index];
     P := Pos(StandardMnemoChar,S);
     If P = Length(S) Then P := 0;
     If P > 0 Then Delete(S,P,1);
     TabCanvas.GetTextExtent(S,CX,CY);
     X := rec.Left + (rec.Right - rec.Left - CX) Div 2;
     Y := rec.Bottom + (rec.Top - rec.Bottom - CY) Div 2;
     TabCanvas.Brush.Mode := bmTransparent;
     If P = 0 Then TabCanvas.TextOut(X,Y, FTabSet.Tabs[Index])
     Else TabCanvas.MnemoTextOut(X,Y, FTabSet.Tabs[Index]);

     If FTabSet.HasFocus And (Index = FTabSet.FTabFocus) Then
     Begin // Draw the Focus Rect around the tab Text
          TabCanvas.DrawFocusRect(Rect(X,Y,X+CX,Y+CY));
     End;

     If Selected Then
     Begin
          TabCanvas.Font := OldTabFont;
     End;

     Canvas.Brush.Mode := bmOpaque;
End;


Function TTabbedNotebook.SignFromPos(X,Y:LongInt):Boolean; {True +, False -}
Begin
     If TabAlignment = taTop Then
     Begin
          Result := (X - 1) + (Y - 1) > HintMargin;
     End
     Else
     Begin
          Result := X - Y > 0;
     End;
End;


Procedure TTabbedNotebook.EvEdgeMouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LongInt);
Begin
     If Button <> mbLeft Then Exit;

     EdgeDraggingMinus := False;
     EdgeDraggingPlus := False;
     If SignFromPos(X,Y) Then EdgeDraggingPlus := True
     Else EdgeDraggingMinus := True;
     FEdge.MouseCapture := True;
End;


Procedure TTabbedNotebook.EvEdgeMouseUp(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LongInt);
Begin
     If Button <> mbLeft Then Exit;

     If PointInRect(Point(X,Y),FEdge.ClientRect) Then
     Begin
          If SignFromPos(X,Y) Then
          Begin
               If EdgeDraggingPlus Then
                 If PageIndex < Pages.Count-1 Then
               Begin
                    PageIndex := PageIndex + 1;
                    While (PageIndex >= FTabSet.FFirstIndex + FTabSet.FVisibleTabs) And
                          (PageIndex > Tab2Page(FTabSet.FLastIndex)) Do
                    Begin
                         FTabSet.SetFirstIndex(FTabSet.FFirstIndex + 1);
                    End;
               End;
          End
          Else
          Begin
               If EdgeDraggingMinus Then
                 If PageIndex > 0 Then
               Begin
                    PageIndex := PageIndex - 1;
                    If PageIndex < FTabSet.FFirstIndex Then FTabSet.SetFirstIndex(PageIndex);
               End;
          End;
     End;
     EdgeDraggingMinus := False;
     EdgeDraggingPlus := False;
     FEdge.MouseCapture := False;
End;


Procedure TTabbedNotebook.EvMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  entry,SubEntry:TMenuItem;
     page,LastMainPage:TPage;
     I:LongInt;
     pt:TPoint;
Begin
     If Button = mbRight Then
       If FAutoPopup Then
     Begin
          If PagesPopup = Nil Then
          Begin
               PagesPopup.Create(Self);

               For I := 0 To FNotebook.Pages.Count-1 Do
               Begin
                    page := TPage(FNotebook.Pages.Objects[I]);

                    If page.SubIndex > 0 Then
                    Begin
                         SubEntry.Create(PagesPopup);
                         SubEntry.Caption := 'Page ' + tostr(page.SubIndex+1)
                                    + ' of ' + tostr(LastMainPage.SubCount+1);
                         SubEntry.Command := PopupCmdBase + I;
                         SubEntry.OnClick := EvPopupClicked;
                         entry.Add(SubEntry);
                         page.PopupEntry := SubEntry;
                    End
                    Else
                    Begin
                         LastMainPage := page;
                         entry.Create(PagesPopup);
                         entry.Caption := page.Caption;
                         PagesPopup.Items.Add(entry);

                         If page.SubCount > 0 Then
                         Begin
                              SubEntry.Create(PagesPopup);
                              SubEntry.Caption := 'Page ' + tostr(page.SubIndex+1)
                                    + ' of ' + tostr(LastMainPage.SubCount+1);
                              SubEntry.Command := PopupCmdBase + I;
                              SubEntry.OnClick := EvPopupClicked;
                              entry.Add(SubEntry);
                              page.PopupEntry := SubEntry;
                         End
                         Else
                         Begin
                              entry.Command := PopupCmdBase + I;
                              entry.OnClick := EvPopupClicked;
                              page.PopupEntry := entry;
                         End;
                    End;
               End;
          End;

          {check the Right entry}
          For I := 0 To FNotebook.Pages.Count-1 Do
          Begin
               page := TPage(FNotebook.Pages.Objects[I]);
               entry := page.PopupEntry;
               If entry <> Nil Then
               Begin
                    entry.Checked := I = FNotebook.PageIndex;
                    entry.Enabled := page.Enabled;
               End;
          End;

          pt := TControl(Sender).ClientToScreen(Point(X,Y));
          PagesPopup.Popup(pt.X,pt.Y);
     End;
End;


Procedure TTabbedNotebook.EvPopupClicked(Sender:TObject);
Var  entry:TMenuItem;
Begin
     entry := TMenuItem(Sender);
     PageIndex := entry.Command - PopupCmdBase;
End;


Const
    PastelColors:Array[0..9,0..2] Of Byte = (
         (95,  223, 255),
         (95,  223, 127),
         (95,  127, 255),
         (191, 159, 159),
         (255, 255, 127),
         (127, 127, 159),
         (255, 127, 63),
         (255, 191, 0),
         (255, 159, 159),
         (255, 191, 127));

Procedure TTabbedNotebook.EvQueryTabColor(Sender:TObject;Index:LongInt;Var TabColor:TColor);
Var  TmpColor:TColor;
Begin
     If FColorTabs Then
     Begin
          Index := Index Mod 10;
          TabColor := ValuesToRGB(PastelColors[Index,0],
                                  PastelColors[Index,1],
                                  PastelColors[Index,2]);
          {$IFDEF OS2}
          TmpColor := GpiQueryNearestColor(Canvas.Handle,0,TabColor);
          If TmpColor >= 0 Then TabColor := TmpColor;
          {$ENDIF}
     End
     Else TabColor := color;
End;
{$HINTS ON}


Procedure TTabbedNotebook.Redraw(Const rec:TRect);
Var  rc:TRect;
     CL:TColor;
     rcHint:TRect;
     yline:LongInt;
     ypage:LongInt;
Begin
     rc := ClientRect;
     Canvas.ShadowedBorder(rc,clWhite,clBlack);
     Forms.InflateRect(rc,-1,-1);
     Canvas.ShadowedBorder(rc,clLtGray,clDkGray);
     Forms.InflateRect(rc,-1,-1);
     rc := Forms.IntersectRect(rc,rec);

     Inherited Redraw(rc);

     If FShowPageHint Then
     Begin
          rcHint := FNotebook.WindowRect;
          Inc(rcHint.Right);
          Inc(rcHint.Top);

          Forms.InflateRect(rcHint, 3, 3);
          If TabAlignment = taTop Then
          Begin
               yline := rcHint.Top;
               Inc(rcHint.Top, HintMargin);
               ypage := rcHint.Top - 2;
          End
          Else
          Begin
               yline := rcHint.Bottom;
               Dec(rcHint.Bottom, HintMargin);
               ypage := rcHint.Bottom + 2;
          End;
          Canvas.ShadowedBorder(rcHint, clDkGray, clWhite);
          Canvas.Pen.color := clDkGray;
          {page Line}
          Canvas.Line(rcHint.Left,ypage,rcHint.Right-HintMargin,ypage);
          Canvas.Line(rcHint.Right-3,rcHint.Bottom+1,rcHint.Right-3,rcHint.Top-1);
          {Cut Line}
          Canvas.Line(rcHint.Left+HintIndent,yline,
                      rcHint.Right-HintIndent-HintMargin,yline);
          Dec(yline);
          Canvas.Pen.color := clWhite;
          Canvas.Line(rcHint.Left+HintIndent,yline,
                      rcHint.Right-HintIndent-HintMargin,yline);
     End;

     If parent <> Nil Then CL := parent.color
     Else CL := clBackGround;
     If CL <> FTabSet.color Then FTabSet.color := CL;
End;


Function TTabbedNotebook.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     Result := TabFont.WriteSCUResourceName(Stream,rnTabFont);
End;


Procedure TTabbedNotebook.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnTabFont Then
     Begin
          If DataLen <> 0 Then TabFont := ReadSCUFont(Data,DataLen);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TTabbedNotebook.EvaluateShortCut(KeyCode:TKeyCode):Boolean;
Var  S:String;
     P:Integer;
     I:LongInt;
     key:TKeyCode;
Begin
     For I := 0 To Pages.Count-1 Do
     Begin
          S := Pages[I];
          P := Pos(StandardMnemoChar,S);
          If (P > 0) And (P < Length(S)) Then
          Begin
               key := (Ord(S[P+1]) Or $20) + kb_Alt + kb_Char;
               If key = KeyCode Then
               Begin
                    PageIndex := I;
                    Result := True;
                    Exit;
               End;
          End;
     End;
     Result := Inherited EvaluateShortCut(KeyCode);
End;


Procedure TTabbedNotebook.GetDesignerPopupEvents(AString:TStringList);
Begin
     AddDesignerPopupEvent(AString, LoadNLSStr(SNextPage), 1);
     AddDesignerPopupEvent(AString, LoadNLSStr(SPreviousPage), -1);
End;

           
Procedure TTabbedNotebook.DesignerPopupEvent(Id:LongInt);
Begin
     Case Id Of
        1: PageIndex := PageIndex + 1;
       -1: PageIndex := PageIndex - 1;
     End;
End;



Begin
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-02  WD         Ausbau der LINUX-Teile
  21-Okt-03  WD         Korrektur bei dem Property "Enabled". Falsche Darstellung unter Windows
  15-sep-04  CW/WD      TTabbedNotebook.Resize: Aufruf aller Seiten-Resizes-Funktionen
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  30-Apr-07  MV         make sure that the TabbedNotebook tab is shown if a page is selected by TabbedNotebook.PageIndex := X;
}

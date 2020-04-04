
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,     All rights reserved.  บ
 บ    Copyright (C) 2005..     Ing. Wolfgang Draxler, All rights reserved.  บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ComCtrls;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Interfasce-Teil                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
Interface

Uses Messages,Color,Classes,Forms,Graphics,Buttons,ExtCtrls,
     StdCtrls,             //  TB 2005-07-03
     uList,
     uString;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TProgressBar                                                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    {$M+}
    TProgressString=(psPercent,psCaption,psPosition);
    TProgressOrigin=(poLeft,poRight,poBottom,poTop);
    {$M-}

    TProgressBar=Class(TControl)
      Private
         FBorderStyle:TBorderStyle;
         FInterior:TRect;
         FMin:LongInt;
         FMax:LongInt;
         FPosition:LongInt;
         FBitmap:TBitmap;
         FProgressString:TProgressString;
         FOrigin:TProgressOrigin;
         FOnChange:TNotifyEvent;
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
         Procedure SetBorderStyle(bs:TBorderStyle);
         Procedure SetMin(lr:LongInt);
         Procedure SetMax(hr:LongInt);
         Procedure SetPosition(ps:LongInt);
         Procedure SetProgressString(ps:TProgressString);
         Procedure SetBitmap(NewBitmap:TBitmap);
         Function GetBitmap:TBitmap;
         Procedure SetOrigin(NewOrigin:TProgressOrigin);
         Procedure DrawInterior(Const rec:TRect);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Change;Virtual;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Destructor Destroy;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property Bitmap:TBitmap Read GetBitmap Write SetBitmap;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property Caption;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property Origin:TProgressOrigin Read FOrigin Write SetOrigin;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ProgressString:TProgressString Read FProgressString Write SetProgressString;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
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
         Property OnSetupShow;
         Property OnStartDrag;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TGauge                                                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
{$M+}
type
  TGaugeKind = (gkText,gkHorizontalBar,gkVerticalBar,gkPie,gkNeedle,gkHorizontal3DBar,gkVertical3DBar);
  TTextColor = (auto,black,dkgray,ltgray,white);
{$M-}
                                   
type
  TGauge = class(TControl)
  private
    FBorderStyle : TBorderStyle;
    FMinValue    : Longint;
    FMaxValue    : Longint;
    FCurValue    : Longint;
    FKind        : TGaugeKind;
    FTextColor   : TTextColor;
    FShowText    : Boolean;
    FForeColor   : TColor;
    FBackColor   : TColor;
    ForeBitmap   : TBitmap;
    BackBitmap   : TBitmap;
    procedure PaintAsText(AnImage: TBitmap; TextColor: TColor; PaintRect: TRect);
    procedure PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsPie(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsNeedle(AnImage: TBitmap; PaintRect: TRect);
    procedure SetGaugeKind(Value: TGaugeKind);
    procedure SetShowText(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetForeColor(Value: TColor);
    procedure SetTextColor(Value: TTextColor);
    procedure SetBackColor(Value: TColor);
    procedure SetMinValue(Value: Longint);
    procedure SetMaxValue(Value: Longint);
    procedure SetProgress(Value: Longint);
    function  GetPercentDone: Longint;
  protected
    Procedure SetupComponent; Override;
    Procedure SetupShow; Override;
  public
    //Destructor Destroy; Override;
    //constructor Create(AOwner: TComponent); override;
    procedure Redraw(const rec:TRect); override;
    procedure AddProgress(Value: Longint);
    property  PercentDone: Longint read GetPercentDone;

  published
    property Align;
    //property Anchors; { gibt es nicht in TControl }
    property BackColor: TColor read FBackColor write SetBackColor {default clWhite};
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle {default bsSingle};
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ForeColor: TColor read FForeColor write SetForeColor {default clBlack};
    property Kind: TGaugeKind read FKind write SetGaugeKind {default gkHorizontalBar};
    property MinValue: Longint read FMinValue write SetMinValue {default 0};
    property MaxValue: Longint read FMaxValue write SetMaxValue {default 100};
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Progress: Longint read FCurValue write SetProgress;
    property ShowHint;
    property ShowText: Boolean read FShowText write SetShowText {default True};
    property TextColor: TTextColor read FTextColor write SetTextColor; {default auto}
    property Visible;
  end;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TUpDown                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

    {$M+}
    TUDOrientation=(udHorizontal,udVertical);
    TUDAlignButton=(udLeft,udRight,udBottom,udTop,udNone);
    TUDBtnType=(btNext,btPrev);

    TOnUDChangingEvent=Procedure(Sender:TComponent;Var AllowChange:Boolean) Of Object;
    TOnUDClickEvent=Procedure(Sender:TComponent;Button:TUDBtnType) Of Object;
    {$M-}

    TUpDown=Class(TControl)
      Private
         FArrowKeys:Boolean;
         FIncrement:LongInt;
         FMin:LongInt;
         FMax:LongInt;
         FOrientation:TUDOrientation;
         FPosition:LongInt;
         FThousands:Boolean;
         FWrap:Boolean;
         FAssociate:TControl;
         FAlignButton:TUDAlignButton;
         FUpRightButton:TSpeedButton;
         FDownLeftButton:TSpeedButton;
         FOnChanging:TOnUDChangingEvent;
         FOnClick:TOnUDClickEvent;
         Procedure SetAssociate(NewControl:TControl);
         Procedure SetMin(NewValue:LongInt);
         Procedure SetMax(NewValue:LongInt);
         Procedure SetOrientation(NewValue:TUDOrientation);
         Procedure SetPosition(NewValue:LongInt);
         Procedure SetAlignButton(NewValue:TUDAlignButton);
         Procedure AlignButtons;
         Procedure EvButtonClick(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Resize;Override;
         Function CanChange:Boolean;Virtual;
         Procedure Click(Button:TUDBtnType);Virtual;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
      Public
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property AlignButton:TUDAlignButton Read FAlignButton Write SetAlignButton;
         Property ArrowKeys:Boolean Read FArrowKeys Write FArrowKeys;
         Property Associate:TControl Read FAssociate Write SetAssociate;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Increment:LongInt Read FIncrement Write FIncrement;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property Orientation:TUDOrientation Read FOrientation Write SetOrientation;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentShowHint;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Thousands:Boolean Read FThousands Write FThousands;
         Property Visible;
         Property Wrap:Boolean Read FWrap Write FWrap;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChanging:TOnUDChangingEvent Read FOnChanging Write FOnChanging;
         Property OnClick:TOnUDClickEvent Read FOnClick Write FOnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseMove;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TTrackBar                                                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

    {$M+}
    TTrackBarOrientation=(trHorizontal,trVertical);
    TTickMarks=(tmBoth,tmBottomRight,tmTopLeft);
    TTickStyle=(tsAuto,tsManual,tsNone);
    TTrackBarSelMode=(smManual,smAuto);
    TTrackSliderShape=(tsArrow,tsBox);
    TTrackSliderSize=(tssAuto,tssVeryLarge,tssLarge,tssMedium,tssSmall);
    {$M-}

    TTrackBar=Class(TControl)
      Private
         FPosition:LongInt;
         FLineSize:LongInt;
         FPageSize:LongInt;
         FMax:LongInt;
         FMin:LongInt;
         FOrientation:TTrackBarOrientation;
         FSelEnd:LongInt;
         FSelStart:LongInt;
         FTickMarks:TTickMarks;
         FTickStyle:TTickStyle;
         FFrequency:LongInt;
         FTracking:Boolean;
         FSelMode:TTrackBarSelMode;
         FTickSize:LongInt;
         FTrackTimer:TTimer;
         FSliderShape:TTrackSliderShape;
         FOnChange:TNotifyEvent;
         FTicks:TList;
         FUpdating:Boolean;
         FShowFocusRect:Boolean;
         FSliderSize:TTrackSliderSize;
         Procedure SetMax(NewValue:LongInt);
         Procedure SetMin(NewValue:LongInt);
         Procedure SetOrientation(NewValue:TTrackBarOrientation);
         Procedure SetPosition(NewValue:LongInt);
         Procedure SetSelEnd(NewValue:LongInt);
         Procedure SetSelStart(NewValue:LongInt);
         Procedure SetTickMarks(NewValue:TTickMarks);
         Procedure SetTickStyle(NewValue:TTickStyle);
         Procedure SetFrequency(NewValue:LongInt);
         Procedure SetSliderSize(NewSize:TTrackSliderSize);
         Procedure SetSelMode(NewMode:TTrackBarSelMode);
         Procedure DrawTrack(SliderW,SliderH:LongInt);
         Procedure DrawSlider(SliderW,SliderH:LongInt);
         Procedure GetSliderExtent(Var SliderWidth,SliderHeight:LongInt);
         Function PosInsideSlider(X,Y:LongInt):Boolean;
         Function PosInsideTrack(X,Y:LongInt):Boolean;
         Procedure UpdateSlider;
         Procedure EvTimer(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure SetFocus;Override;
         Procedure KillFocus;Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure Change;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Function CoordFromPos(Position:LongInt):LongInt;
         Function PosFromCoord(Coord:LongInt):LongInt;
         Procedure SetTick(Pos:LongInt);
         Procedure ClearTicks;
         Procedure BeginUpdate;
         Procedure EndUpdate;
         Property Tracking:Boolean Read FTracking;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Frequency:LongInt Read FFrequency Write SetFrequency;
         Property LineSize:LongInt Read FLineSize Write FLineSize;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property Orientation:TTrackBarOrientation Read FOrientation Write SetOrientation;
         Property PageSize:LongInt Read FPageSize Write FPageSize;
         Property ParentColor;
         Property ParentShowHint;
         Property PopupMenu;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property SelEnd:LongInt Read FSelEnd Write SetSelEnd;
         Property SelMode:TTrackBarSelMode Read FSelMode Write SetSelMode;
         Property SelStart:LongInt Read FSelStart Write SetSelStart;
         Property ShowFocusRect:Boolean Read FShowFocusRect Write FShowFocusRect;
         Property ShowHint;
         Property SliderSize:TTrackSliderSize Read FSliderSize Write SetSliderSize;
         Property TabOrder;
         Property TabStop;
         Property TickMarks:TTickMarks Read FTickMarks Write SetTickMarks;
         Property TickStyle:TTickStyle Read FTickStyle Write SetTickStyle;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TStatusPanel                                                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

    {$M+}
    TStatusPanelStyle=(psText, psOwnerDraw);
    TStatusPanelBevel=(pbNone, pbLowered, pbRaised);
    {$M-}

    TStatusPanel=Class(TCollectionItem)
      Private
         FText:PString;
         FWidth:LongInt;
         FAlignment:TAlignment;
         FBevel:TStatusPanelBevel;
         FStyle:TStatusPanelStyle;
      Private
         Function GetText:String;
         Procedure SetText(Const NewValue:String);
         Procedure SetWidth(NewValue:LongInt);
         Procedure SetAlignment(NewValue:TAlignment);
         Procedure SetBevel(NewValue:TStatusPanelBevel);
         Procedure SetStyle(NewValue:TStatusPanelStyle);
      Public
         Constructor Create(ACollection:TCollection);Override;
         Destructor Destroy;Override;
         Procedure Assign(Source:TCollectionItem);Override;
      Published
         Property Text:String Read GetText Write SetText;
         Property Width:LongInt Read FWidth Write SetWidth;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property Bevel:TStatusPanelBevel Read FBevel Write SetBevel;
         Property Style:TStatusPanelStyle Read FStyle Write SetStyle;
    End;

    TStatusBar=Class;

    {$HINTS OFF}
    TStatusPanels=Class(TCollection)
      Private
         FStatusBar:TStatusBar;
         Function GetItem(Index:LongInt):TStatusPanel;
         Procedure SetItem(Index:LongInt;Value:TStatusPanel);
      Protected
         Procedure SetupComponent;Override;
      Public
         Procedure Update(Item:TCollectionItem);Override;
         Function Add:TStatusPanel;
      Public
         Property Items[Index:LongInt]:TStatusPanel Read GetItem Write SetItem;Default;
         Property StatusBar:TStatusBar Read FStatusBar;
    End;
    {$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TStatusBar                                                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

    {$M+}
    TDrawPanelEvent=Procedure(StatusBar:TStatusBar;Panel:TStatusPanel;Const rc:TRect) Of Object;
    {$M-}

    TStatusBar=Class(TBevel)
      Private
         FSimpleText:String;
         FSimplePanel:Boolean;
         FPanels:TStatusPanels;
         FSizeGrip:Boolean;
         FSpacing:LongInt;
         FOnDrawPanel:TDrawPanelEvent;
         Procedure SetSimpleText(Const NewText:String);
         Procedure SetSimplePanel(NewValue:Boolean);
         Procedure SetPanels(NewValue:TStatusPanels);
         Procedure SetSizeGrip(NewValue:Boolean);
         Procedure UpdatePanel(Panel:TStatusPanel);
         Procedure SetSpacing(NewValue:LongInt);
         Property Shape;
      Protected
         Procedure SetupComponent;Override;
         Procedure DrawPanel(Panel:TStatusPanel;Const rc:TRect);Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Published
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
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
         Property OnClick;
         Property OnDblClick;
         Property Panels:TStatusPanels Read FPanels Write SetPanels;
         Property SimpleText:String Read FSimpleText Write SetSimpleText;
         Property SimplePanel:Boolean Read FSimplePanel Write SetSimplePanel;
         Property SizeGrip:Boolean Read FSizeGrip Write SetSizeGrip;
         Property OnDrawPanel:TDrawPanelEvent Read FOnDrawPanel Write FOnDrawPanel;
         Property Spacing:LongInt Read FSpacing Write SetSpacing;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: THeaderSection                                                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
    THeaderControl=Class;

    {$M+}
    THeaderSectionStyle=(hsText,hsOwnerDraw);
    {$M-}

    THeaderSection=Class(TCollectionItem)
      Private
         FText:PString;
         FWidth:LongInt;
         FMinWidth:LongInt;
         FMaxWidth:LongInt;
         FAlignment:TAlignment;
         FStyle:THeaderSectionStyle;
         FAllowClick:Boolean;
         FAllowSize:Boolean;
      Private
         Function GetText:String;
         Procedure SetText(Const NewValue:String);
         Procedure SetWidth(NewValue:LongInt);
         Function GetLeft:LongInt;
         Function GetRight:LongInt;
         Procedure SetStyle(NewValue:THeaderSectionStyle);
         Procedure SetAlignment(NewValue:TAlignment);
         Procedure SetMaxWidth(NewValue:LongInt);
         Procedure SetMinWidth(NewValue:LongInt);
      Public
         Constructor Create(ACollection:TCollection);Override;
         Destructor Destroy;Override;
         Procedure Assign(Source:TCollectionItem);Override;
      Public
         Property Left:LongInt Read GetLeft;
         Property Right:LongInt Read GetRight;
      Published
         Property Text:String Read GetText Write SetText;
         Property Width:LongInt Read FWidth Write SetWidth;
         Property MinWidth:LongInt Read FMinWidth Write SetMinWidth;
         Property MaxWidth:LongInt Read FMaxWidth Write SetMaxWidth;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property AllowClick:Boolean Read FAllowClick Write FAllowClick;
         Property AllowSize:Boolean Read FAllowSize Write FAllowSize;
         Property Style:THeaderSectionStyle Read FStyle Write SetStyle;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: THeaderSections                                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

    {$HINTS OFF}
    THeaderSections=Class(TCollection)
      Private
         FHeaderControl:THeaderControl;
         Function GetItem(Index:LongInt):THeaderSection;
         Procedure SetItem(Index:LongInt;NewValue:THeaderSection);
      Public
         Procedure Update(Item:TCollectionItem);Override;
         Procedure SetupComponent;Override;
         Function Add:THeaderSection;
      Public
         Property Items[Index:LongInt]:THeaderSection Read GetItem Write SetItem;Default;
         Property HeaderControl:THeaderControl Read FHeaderControl;
    End;
    {$HINTS ON}
    THeaderSectionsClass=Class Of THeaderSections;

    {$M+}
    TSectionTrackState=(tsTrackBegin,tsTrackMove,tsTrackEnd);

    TSectionNotifyEvent=Procedure(HeaderControl:THeaderControl;section:THeaderSection) Of Object;
    TDrawSectionEvent=Procedure(HeaderControl:THeaderControl;section:THeaderSection;
                                Const rc:TRect;Pressed:Boolean) Of Object;
    TSectionTrackEvent=Procedure(HeaderControl:THeaderControl;section:THeaderSection;
                                 Width:LongInt;State:TSectionTrackState) Of Object;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: THeaderControl                                                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
    THeaderControl=Class(TControl)
      Private
         FSections:THeaderSections;
         FSpacing:LongInt;
         FOnDrawSection:TDrawSectionEvent;
         FOnSectionClick:TSectionNotifyEvent;
         FOnSectionResize:TSectionNotifyEvent;
         FOnSectionTrack:TSectionTrackEvent;
         FSectionTrackState:TSectionTrackState;
         FClickSection:THeaderSection;
         FClickBase:THeaderSection;
         FSizeStartX:LongInt;
         FSizeX:LongInt;
         FSizeSection:THeaderSection;
         FBevelWidth:LongInt;
         FShape:TCursor;
         FSectionsClass:THeaderSectionsClass;
      Private
         Procedure SetSections(NewValue:THeaderSections);
         Procedure SetSpacing(NewValue:LongInt);
         Procedure SetBevelWidth(NewValue:LongInt);
         Function GetSections:THeaderSections;
      Protected
         Function GetMouseHeader(X,Y:LongInt):THeaderSection;Virtual;
         Procedure UpdateHeader(Header:THeaderSection);Virtual;
         Procedure DrawSectionRect(Const rc:TRect;Pressed:Boolean);Virtual;
         Procedure DrawSection(section:THeaderSection;Const rc:TRect;Pressed:Boolean);Virtual;
         Procedure SectionClick(section:THeaderSection);Virtual;
         Procedure SectionResize(section:THeaderSection);Virtual;
         Procedure SectionTrack(section:THeaderSection;Width:LongInt;State:TSectionTrackState);Virtual;
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
      Protected
         Property ClickSection:THeaderSection read FClickSection write FClickSection;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure WriteInfoToINI(InfoLine : String); Override;
         Function ReadInfoFromINI : String; Override;
      Public
         Property SectionsClass:THeaderSectionsClass read FSectionsClass write FSectionsClass;
      Published
         Property Align;
         Property BevelWidth:LongInt Read FBevelWidth Write SetBevelWidth;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property Sections:THeaderSections Read GetSections Write SetSections;
         Property ShowHint;
         Property ParentFont;
         Property ParentShowHint;
         Property PopupMenu;
         Property Spacing:LongInt Read FSpacing Write SetSpacing;
         Property TabOrder;
         Property TabStop;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnStartDrag;
         Property OnEndDrag;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSectionClick:TSectionNotifyEvent Read FOnSectionClick Write FOnSectionClick;
         Property OnDrawSection:TDrawSectionEvent Read FOnDrawSection Write FOnDrawSection;
         Property OnSectionResize:TSectionNotifyEvent Read FOnSectionResize Write FOnSectionResize;
         Property OnSectionTrack:TSectionTrackEvent Read FOnSectionTrack Write FOnSectionTrack;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: THeader                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
    THeader=Class(THeaderControl)  //For Delphi 1.0 compatibility
      Private
         Function GetSectionWidth(Index:LongInt):LongInt;
         Procedure SetSectionWidth(Index:LongInt;NewValue:LongInt);
      Public
         Property SectionWidth[Index:LongInt]:LongInt Read GetSectionWidth Write SetSectionWidth;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TMultiColumnListBox                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
Type
  TMultiColumnListBox=Class(TListBox)
    Private
      BmpList: TList;
      sections: THeaderSections;
      sep_char: string;

      Function GetBitmap(Index:LongInt):TBitmap;
      Procedure SetBitmap(index:LongInt;bmp:TBitmap);
      Function GetSepChar:string;
      Procedure SetSepChar(Value:string);
    Protected
      Procedure SetupComponent;Override;
      Procedure DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);Override;
    Public
      Function Add(s:string):LongInt;
      Function AddObject(s:string;o:TObject):LongInt;
      Property Bitmaps[index:LongInt]:TBitmap write SetBitmap read GetBitmap;
      Procedure SetHeader(s: THeaderSections);
      Procedure Sort(section:Integer);
      Destructor Destroy; Override;
      Procedure Clear; Override;
      Property Separator:string read GetSepChar write SetSepChar;
  End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TMultiColumnList                                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
Type
  tMultiColumnList=Class(TPanel)
  Private
    List     : TMultiColumnListBox;
    Header   : THeaderControl;
    HorScroll: tScrollbar;
    Fenabled : Boolean;
    drag_mode:TDragMode;
    Function GetSections:THeaderSections;
    Function GetSectionsItem(Index:LongInt):THeaderSection;//gehn
    Function GetSectionsCount:LongInt;//gehn
    Procedure SetSections(Value:THeaderSections);
    Function GetDuplicates:Boolean;
    Procedure SetDuplicates(Value:Boolean);
    Function GetExtendedSelect:Boolean;
    Procedure SetExtendedSelect(Value:Boolean);
    Function GetItemIndex:LongInt;
    Procedure SetItemIndex(Value:LongInt);
    Function GetMultiSelect:Boolean;
    Procedure SetMultiSelect(Value:Boolean);
    Function GetOnItemFocus:TItemFocusEvent;
    Procedure SetOnItemFocus(Value:TItemFocusEvent);
    Function GetOnItemSelect:TItemSelectEvent;
    Procedure SetOnItemSelect(Value:TItemSelectEvent);
    Function GetSelCount:LongInt;
    Function GetSelected(Index:LongInt):Boolean;
    Procedure SetSelected(Index:LongInt;Value:Boolean);
    Function GetTheFont:TFont;
    Procedure SetTheFont(Value:TFont);
    Function GetValue(field,index:LongInt):string;
    Procedure SetValue(field,index:LongInt;Value:string);
    Function GetBitmap(index:LongInt):TBitmap;
    Procedure SetBitmap(index:LongInt; bmp:TBitmap);
    Function GetHint:string;
    Procedure SetHint(Value:string);
    Function GetObjects(Index:LongInt):TObject;
    Procedure SetObjects(Index:LongInt;Value:TObject);
    Function GetShowDragRects:Boolean;
    Procedure SetShowDragRects(Value:Boolean);
    Function GetHeaderHint:string;
    Procedure SetHeaderHint(Value:string);
    Procedure SetEnabled(Value:Boolean);  Override;
    Function GetCount:LongInt;
    Procedure SetDragMode(Value:TDragMode);
    Procedure EvSectionPressed(sender: THeaderControl; section: THeaderSection);
    Procedure EvSectionTrack(sender: THeaderControl; section: THeaderSection; width: LongInt; State:TSectionTrackState);
    Procedure EvCanDrag(sender: TObject; X,Y: LongInt; var Accept: Boolean);
    Procedure EvDragDrop(sender: TObject; source: TObject; X,Y: LongInt);
    Procedure EvDragOver(sender: TObject; source: TObject; X,Y: LongInt; State: TDragState; var Accept: Boolean);
    Procedure EvScroll(Sender: TObject; ScrollCode: TScrollCode; Var ScrollPos: LongInt);

{$IFDEF Win32}
    Procedure EvOnDblClick(Sender: TObject);
{$ENDIF}

    Function GetSepChar:string;
    Procedure SetSepChar(Value:string);

    Function GetListItems:TStrings;                 // TB 11-Aug-2005
    Procedure SetListItems(AStrings:TStrings);      // TB 11-Aug-2005

    Function GetHorScrollPos : LongInt;

  Protected
    Procedure SetupComponent; Override;
    Procedure SetupShow;Override;
    Procedure Resize;Override;

  Public
    Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
    Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
    Destructor Destroy; Override;
    Constructor Create(AOwner:TComponent); Override;
    Procedure SelectAll;
    Procedure DeselectAll;
    Function Add(s:string):LongInt;
    Function AddObject(s:string;o:TObject):LongInt;
    Procedure Delete(Index:LongInt);
    Procedure Clear;
    Function ItemRect(Index:LongInt):TRect;
    Function IsDraggedSourceMe(source: TObject):Boolean;
    Procedure Sort(section:Integer);
    Function IndexOf(s:string):LongInt;
    Procedure BeginUpdate;
    Procedure EndUpdate;
    //gehn
    Procedure SetSectionsItemText(Index:LongInt; NewText:String);

    Property ListBox: TMultiColumnListBox read List;
    Property HeaderControl: THeaderControl read Header;
    Property SelCount: LongInt read GetSelCount;
    Property Selected[Index: LongInt]: Boolean read GetSelected write SetSelected;
    Property Values[field,index:LongInt]: string read GetValue write SetValue;default;
    Property Bitmaps[index:LongInt]:TBitmap write SetBitmap read GetBitmap;
    Property Objects[index:LongInt]:TObject read GetObjects write SetObjects;
    Property Count:LongInt read GetCount;
    Property ItemIndex: LongInt read GetItemIndex write SetItemIndex;
    Property TabStop;
    Property HorScrollPos : LongInt read GetHorScrollPos;

  Published
    Property Items: TStrings read GetListItems write SetListItems;      // TB 11-Aug-2005
    Property Sections: THeaderSections read GetSections write SetSections;
    Property Duplicates: Boolean read GetDuplicates write SetDuplicates;
    Property ExtendedSelect: Boolean read GetExtendedSelect write SetExtendedSelect;
    Property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    Property OnItemFocus: TItemFocusEvent read GetOnItemFocus write SetOnItemFocus;
    Property OnItemSelect: TItemSelectEvent read GetOnItemSelect write SetOnItemSelect;
    Property Font:TFont read GetTheFont write SetTheFont;
    Property Hint:string read GetHint write SetHint;
    Property HeaderHint:string read GetHeaderHint write SetHeaderHint;
    Property Enabled:Boolean read Fenabled write SetEnabled;
    Property ShowDragRects:Boolean read GetShowDragRects write SetShowDragRects;
    Property DragMode:TDragMode read drag_mode write SetDragMode;
    Property Separator:string read GetSepChar write SetSepChar;
  End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Insert-Proceduren                                                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
Function InsertProgressBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TProgressBar;
Function InsertGauge(parent:TControl;Left,Bottom,Width,Height:LongInt):TGauge;
Function InsertUpDown(parent:TControl;Left,Bottom,Width,Height:LongInt):TUpDown;
Function InsertTrackBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TTrackBar;
Function InsertStatusBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TStatusBar;
Function InsertHeaderControl(parent:TControl;Left,Bottom,Width,Height:LongInt):THeaderControl;

Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Implementation-Teil                                                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Uses PmWin;
{$ENDIF}

{$IFDEF WIN32}
Uses WinUser;
{$ENDIF}

Uses SysUtils, uSysInfo, uStream;

Function InsertProgressBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TProgressBar;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.parent := parent;
End;

Function InsertGauge(parent:TControl;Left,Bottom,Width,Height:LongInt):TGauge;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.parent := parent;
End;



Function InsertUpDown(parent:TControl;Left,Bottom,Width,Height:LongInt):TUpDown;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.parent := parent;
End;


Function InsertTrackBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TTrackBar;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.parent := parent;
End;

Function InsertStatusBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TStatusBar;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.parent := parent;
End;

Function InsertHeaderControl(parent:TControl;Left,Bottom,Width,Height:LongInt):THeaderControl;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.parent := parent;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TProgressBar Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TProgressBar.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnBitmap Then
     Begin
          If DataLen <> 0 Then Bitmap.ReadSCUResource(rnBitmap,Data,DataLen);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TProgressBar.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FBitmap <> Nil
     Then Result := FBitmap.WriteSCUResourceName(Stream,rnBitmap);
End;


Procedure TProgressBar.SetBitmap(NewBitmap:TBitmap);
Var  OldBitmap:TBitmap;
Begin
     OldBitmap := FBitmap;

     {Create internal Copy}
     If NewBitmap <> Nil Then FBitmap := NewBitmap.Copy
     Else FBitmap := Nil;

     If FBitmap <> Nil Then Include(FBitmap.ComponentState, csDetail);

     If OldBitmap <> Nil Then
       If OldBitmap <> NewBitmap Then OldBitmap.Destroy;

     If Handle <> 0 Then Invalidate;
End;


Function TProgressBar.GetBitmap:TBitmap;
Begin
     If FBitmap = Nil Then
     Begin
          FBitmap.Create;
          Include(FBitmap.ComponentState, csDetail);
     End;
     Result := FBitmap;
End;


{$HINTS OFF}
Procedure TProgressBar.CMTextChanged(Var Msg:TMessage);
Begin
     DrawInterior(ClientRect);
End;
{$HINTS ON}


Procedure TProgressBar.SetBorderStyle(bs:TBorderStyle);
Begin
     FBorderStyle := bs;
     If Handle<>0 Then Invalidate;
End;


Procedure TProgressBar.SetMin(lr:LongInt);
Begin
     If lr > FMax Then Exit;
     FMin := lr;
     If Handle<>0 Then DrawInterior(ClientRect);
     Change;
End;


Procedure TProgressBar.SetMax(hr:LongInt);
Begin
     If hr < FMin Then Exit;
     FMax := hr;
     If Handle<>0 Then DrawInterior(ClientRect);
     Change;
End;


Procedure TProgressBar.SetPosition(ps:LongInt);
Begin
     FPosition := ps;
     If Handle<>0 Then DrawInterior(ClientRect);
     Change;
End;


Procedure TProgressBar.SetProgressString(ps:TProgressString);
Begin
     FProgressString := ps;
     If Handle<>0 Then DrawInterior(ClientRect);
End;


Procedure TProgressBar.SetOrigin(NewOrigin:TProgressOrigin);
Begin
     FOrigin := NewOrigin;
     If Handle<>0 Then DrawInterior(ClientRect);
End;


{$HINTS OFF}
Procedure TProgressBar.DrawInterior(Const rec:TRect);
Var  X,Y,CX,CY,xm,ym:LongInt;
     Percent:LongInt;
     rec1:TRect;
     S:String;
Begin
     If Canvas = Nil Then Exit;
     If FMax = FMin Then
     Begin
          If FPosition < FMin Then Percent := 0
          Else Percent := 100;
     End
     Else Percent := ((FPosition-FMin) * 100) Div (FMax-FMin);
     If Percent < 0 Then Percent := 0;
     If Percent > 100 Then Percent := 100;

     If Percent <> 0 Then
     Begin
          Case FOrigin Of
            poLeft:
            Begin
                 xm := ((FInterior.Right-FInterior.Left) * Percent) Div 100;
                 Inc(xm,FInterior.Left);
            End;
            poRight:
            Begin
                 xm := ((FInterior.Right-FInterior.Left) * Percent) Div 100;
                 xm := FInterior.Right - xm;
            End;
            poBottom:
            Begin
                 ym := ((FInterior.Top-FInterior.Bottom) * Percent) Div 100;
                 Inc(ym,FInterior.Bottom);
            End;
            poTop:
            Begin
                 ym := ((FInterior.Top-FInterior.Bottom) * Percent) Div 100;
                 ym := FInterior.Top - ym;
            End;
          End;
     End
     Else
     Begin
          Case FOrigin Of
            poLeft:   xm := FInterior.Left-1;
            poRight:  xm := FInterior.Right+1;
            poBottom: ym := FInterior.Bottom-1;
            poTop:    ym := FInterior.Top+1;
          End;
     End;

     Case FProgressString Of
         psCaption:  S := Caption;
         psPosition: S := tostr(FPosition) + Caption;
         psPercent:  S := tostr(Percent) + ' %' + Caption;
     End;
     Canvas.GetTextExtent(S,CX,CY);
     Inc(CX);
     X := FInterior.Left + (FInterior.Right-FInterior.Left-CX) Div 2;
     Y := FInterior.Bottom + (FInterior.Top-FInterior.Bottom-CY) Div 2;
     If Y < FInterior.Bottom Then Y := FInterior.Bottom;

     If (FBitmap <> Nil) And (Not FBitmap.Empty)
     Then Canvas.Brush.Mode := bmTransparent
     Else Canvas.Brush.Mode := bmOpaque;

     rec1 := FInterior;
     Case FOrigin Of
       poLeft:   rec1.Right := xm;
       poRight:  rec1.Left := xm;
       poBottom: rec1.Top := ym;
       poTop:    rec1.Bottom := ym;
     End;
     Canvas.SetClipRegion([rec1]);
     If (FBitmap <> Nil) And (Not FBitmap.Empty) Then
     Begin
          Canvas.StretchDraw(FInterior.Left,
                             FInterior.Bottom,
                             FInterior.Right-FInterior.Left,
                             FInterior.Top-FInterior.Bottom,
                             FBitmap);
     End
     Else Canvas.FillRect(ClientRect,PenColor);

     Canvas.Pen.color := color;
     Canvas.Brush.color := PenColor;
     Canvas.Brush.Mode := bmTransparent;
     Canvas.TextOut(X,Y,S);

     rec1 := FInterior;
     Case FOrigin Of
       poLeft:   rec1.Left := xm+1;
       poRight:  rec1.Right := xm-1;
       poBottom: rec1.Bottom := ym+1;
       poTop:    rec1.Top := ym-1;
     End;
     Canvas.SetClipRegion([rec1]);
     Canvas.FillRect(ClientRect,color);

     Canvas.Pen.color := PenColor;
     Canvas.Brush.color := color;
     Canvas.TextOut(X,Y,S);
End;
{$HINTS ON}


Procedure TProgressBar.Redraw(Const rec:TRect);
Begin
     If Canvas = Nil Then Exit;

     FInterior:=ClientRect;

     DrawSystemBorder(Self,FInterior,FBorderStyle);

     DrawInterior(rec);
End;


Procedure TProgressBar.SetupComponent;
Begin
     Inherited SetupComponent;

     Width := 200;
     Height := 25;
     PenColor := clHighlight;
     ParentPenColor := False;
     ParentColor := True;
     TabStop := False;

     FBorderStyle := bsSingle;
     FMin := 0;
     FMax := 100;
     FPosition := 0;
     FProgressString := psPercent;
     FBitmap := Nil;
     FOrigin := poLeft;
End;


Procedure TProgressBar.SetupShow;
Var  I:LongInt;
Begin
     Inherited SetupShow;

     If FBorderStyle = bsNone Then I := 1
     Else I := 3;
     FInterior := ClientRect;
     Forms.InflateRect(FInterior,-I,-I);
End;


Procedure TProgressBar.Change;
Begin
     If FOnChange <> Nil Then FOnChange(Self);
End;


Destructor TProgressBar.Destroy;
Begin
     If FBitmap <> Nil Then FBitmap.Destroy;
     FBitmap := Nil;

     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TGauge Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Const MaxColors = 16777216;
{$ENDIF}
{$IFDEF Win32}
Const MaxColors = 256;
{$ENDIF}


procedure TGauge.SetupComponent;
begin
  inherited SetupComponent;

  ControlStyle := ControlStyle + [csFramed{,csOpaque}]; //Unit Forms

  // Vorgabewerte (default values)
  FMinValue := 0;
  FMaxValue := 100;
  FCurValue := 0;
  FKind     := gkHorizontalBar;
  FShowText := True;
  FBorderStyle := bsSingle;
  FForeColor := clBlue;
  FBackColor := clLtBlue;
  TextColor  := auto;
  Color  := clDlgWindow; //ohne Funktion
  Width  := 90;
  Height := 25;
end;

Procedure TGauge.SetupShow;
Var i:LongInt;
begin
  Inherited SetupShow;
end;

function SolveForX(Y, Z: Longint): Longint;
// This function solves for x in the equation "x is y% of z".
begin
  Result := Longint(Trunc(Z * (Y * 0.01)));
end;

function SolveForY(X, Z: Longint): Longint;
// This function solves for y in the equation "x is y% of z".
begin
  if Z = 0
  then Result := 0
  else Result := Longint(Trunc((X * 100.0) / Z));
end;

function TGauge.GetPercentDone: Longint;
begin
  Result := SolveForY(FCurValue - FMinValue, FMaxValue - FMinValue);
end;

procedure TGauge.Redraw(const rec:TRect);
var
  PaintRect: TRect;
  h,w : Integer;

begin
  if Canvas = Nil then Exit;

  PaintRect := ClientRect;

  //in DrawSystemBorder wird die Gr”sse von PaintRect autom. angepasst
  //daher InflateRect() nicht notwendig
  DrawSystemBorder(Self,PaintRect,FBorderStyle);

  h := PaintRect.Top-PaintRect.Bottom;
  w := PaintRect.Right-PaintRect.Left;

  //Hintergrundbitmap
  BackBitmap := TBitmap.Create;
  try
    BackBitmap.CreateNew(w+1,h+1,MaxColors);  //16777216 Farben

    //Hintergrundbitmap mit Farbe fllen und zeichnen
    if FKind = gkNeedle
    then BackBitmap.Canvas.FillRect(Rect(0,0,w,h),clDlgWindow)
    else begin
           BackBitmap.Canvas.FillRect(Rect(0,0,w,h),BackColor);
           if ShowText then PaintAsText(BackBitmap,FForeColor,PaintRect);
         end;
    Canvas.Draw(PaintRect.Left,PaintRect.Bottom,BackBitmap);

    //Fordergrundbitmap
    ForeBitmap := TBitmap.Create;
    try
      case FKind of
        gkText: ;
        gkHorizontalBar,
        gkVerticalBar,
        gkHorizontal3DBar,
        gkVertical3DBar: PaintAsBar(ForeBitmap,PaintRect);
        gkPie: begin
                 PaintAsPie(BackBitmap, PaintRect);
                 //Canvas.Brush.Style := bsClear;
                 //Canvas.CopyMode := cmSrcInvert
                 Canvas.Draw(PaintRect.Left,PaintRect.Bottom,BackBitmap);
               end;
        gkNeedle: begin
                    PaintAsNeedle(BackBitmap, PaintRect);
                    Canvas.Draw(PaintRect.Left,PaintRect.Bottom,BackBitmap);
                  end;
      end; //case
      Canvas.Draw(PaintRect.Left,PaintRect.Bottom,ForeBitmap);
    finally
      ForeBitmap.Destroy;
    end;
  finally
    BackBitmap.Destroy;
  end;
end;

procedure TGauge.PaintAsText(AnImage: TBitmap; TextColor: TColor; PaintRect: TRect);
var
  S: string;
  X, Y: Integer;
begin
  //S := Format('%d %%', [PercentDone]); //Fehler in WDSibyl, behoben 14-Dec-06
  S := IntToStr(PercentDone)+' %'; 
  with AnImage do
  begin
    Font := Self.Font;
    case FTextColor of
      auto   : Canvas.Pen.Color  := TextColor;
      black  : Canvas.Pen.Color  := clBlack;
      dkgray : Canvas.Pen.Color  := clDkGray;
      ltgray : Canvas.Pen.Color  := clLtGray;
      white  : Canvas.Pen.Color  := clWhite;
    end; {case}
    Canvas.Brush.Mode := bmTransparent;

    with PaintRect do
    begin
      X := (Right - Left + 1 - Canvas.TextWidth(S)) div 2;
      {$ifdef os2}
      Y := (Top - Bottom + 1 - Canvas.TextHeight(S)) div 2;
      {$endif}
      {$ifdef win32}
      Y := (Top - Bottom + 1 + Canvas.TextHeight(S)) div 2;
      {$endif}
    end;
    Canvas.TextOut(X, Y, S);
  end;
end;

procedure TGauge.PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
var
  FillSize: Longint;
  w,h     : Longint;

begin
  if PercentDone = 0 then Exit;

  w := PaintRect.Right - PaintRect.Left{ + 1};
  h := PaintRect.Top - PaintRect.Bottom{ + 1};

  with AnImage do
  begin
    case FKind of
      gkHorizontalBar,
      gkHorizontal3DBar:
        begin
          FillSize := SolveForX(PercentDone, W);
          if FillSize > W then FillSize := W;
          if FillSize > 0
         then begin
                 CreateNew(FillSize+1,h+1,MaxColors);  //16777216 Farben
                 Canvas.FillRect(Rect(0,0,FillSize,h),ForeColor);
                 if FKind = gkHorizontal3DBar
                 then begin
                        Canvas.ShadowedBorder(Rect(0,0,FillSize,h),clWhite,clDkGray);
                        Canvas.ShadowedBorder(Rect(1,1,FillSize-1,h-1),clWhite,clDkGray);
                      end;
                 if ShowText then PaintAsText(ForeBitmap,BackColor,PaintRect);
               end;
        end;
      gkVerticalBar,
      gkVertical3DBar:
        begin
          FillSize := SolveForX(PercentDone, H);
          if FillSize >= H then FillSize := H;
          CreateNew(w+1,FillSize+1,MaxColors);  //16777216 Farben
          Canvas.FillRect(Rect(0,0,w,FillSize),ForeColor);
          if FKind = gkVertical3DBar
          then begin
                 Canvas.ShadowedBorder(Rect(0,0,w,FillSize),clWhite,clDkGray);
                 Canvas.ShadowedBorder(Rect(1,1,w-1,FillSize-1),clWhite,clDkGray);
               end;
          if ShowText then PaintAsText(ForeBitmap,BackColor,PaintRect);
        end;
    end;
  end;
end;

procedure TGauge.PaintAsPie(AnImage: TBitmap; PaintRect: TRect);
var
  MiddleX, MiddleY: Integer;
  Angle: Double;
  W, H: LongInt;
  x1,y1,x2,y2,x3,y3,x4,y4 : LongInt;
  X,Y,RadiusX,RadiusY : LongInt;
  StartAngle,SweepAngle : Extended;
begin
  w := PaintRect.Right - PaintRect.Left;
  h := PaintRect.Top - PaintRect.Bottom;

  with AnImage do
  if PercentDone > 0
  then begin
         Canvas.Pen.Color := ForeColor;
         Canvas.Brush.Style := bsSolid;
         Canvas.Brush.Color := ForeColor;
         SweepAngle := PercentDone / 100 *360;
         StartAngle := 90 - SweepAngle;
         if StartAngle < 0 then StartAngle := StartAngle + 360;
         Canvas.Pie(w div 2,h div 2,w div 2,h div 2,StartAngle,SweepAngle);
         if ShowText
         then begin //optisch noch nicht optimal bei auto
         if SweepAngle < 180
                then PaintAsText(BackBitmap,ForeColor,PaintRect)
                else PaintAsText(BackBitmap,BackColor,PaintRect);
              end;
       end;
end;

procedure TGauge.PaintAsNeedle(AnImage: TBitmap; PaintRect: TRect);
var
  Angle: Double;
  W, H: Integer;
begin
  w := PaintRect.Right - PaintRect.Left;
  h := PaintRect.Top - PaintRect.Bottom;

  with AnImage do
  begin
    Canvas.Brush.Color := BackColor;
    Canvas.Pie(w div 2,0,w div 2,h,0,180);
    if ShowText then PaintAsText(AnImage,FForeColor,PaintRect);

    Canvas.Brush.Color := ForeColor;
    Canvas.Pen.Color := ForeColor;
    Canvas.Pen.Width := 1;
    Canvas.Ellipse(w div 2,0,w div 2,h);
    Angle := 180 * (PercentDone / 100);
    Canvas.Pie(w div 2,0,w div 2,h,180-Angle,0);
    Canvas.MoveTo(0,0);
    Canvas.LineTo(w,0);
  end;
end;

procedure TGauge.SetGaugeKind(Value: TGaugeKind);
begin
  if Value <> FKind
  then begin
         FKind := Value;
         Refresh;
       end;
end;

procedure TGauge.SetShowText(Value: Boolean);
begin
  if Value <> FShowText
  then begin
         FShowText := Value;
         Refresh;
       end;
end;

procedure TGauge.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle
  then begin
         FBorderStyle := Value;
         Refresh;
       end;
end;

procedure TGauge.SetForeColor(Value: TColor);
begin
  if Value <> FForeColor
  then begin
         FForeColor := Value;
         Refresh;
       end;
end;

procedure TGauge.SetBackColor(Value: TColor);
begin
  if Value <> FBackColor
  then begin
         FBackColor := Value;
         Refresh;
       end;
end;

procedure TGauge.SetTextColor(Value: TTextColor);
begin
  if Value <> FTextColor
  then begin
         FTextColor := Value;
         Refresh;
       end;
end;

procedure TGauge.SetMinValue(Value: Longint);
begin
  if Value <> FMinValue
  then begin
         //offen:
         //if Value > FMaxValue then
         //  if not (csLoading in ComponentState) then
         //    raise EInvalidOperation.CreateFmt(SOutOfRange, [-MaxInt, FMaxValue - 1]);
         FMinValue := Value;
         if FCurValue < Value then FCurValue := Value;
         Refresh;
       end;
end;

procedure TGauge.SetMaxValue(Value: Longint);
begin
  if Value <> FMaxValue
  then begin
         //offen:
         //if Value < FMinValue then
         //  if not (csLoading in ComponentState) then
         //    raise EInvalidOperation.CreateFmt(SOutOfRange, [FMinValue + 1, MaxInt]);
         FMaxValue := Value;
         if FCurValue > Value then FCurValue := Value;
         Refresh;
       end;
end;

procedure TGauge.SetProgress(Value: Longint);
var TempPercent: Longint;
begin
  TempPercent := GetPercentDone;  { remember where we were }
  if Value < FMinValue
  then Value := FMinValue
  else if Value > FMaxValue
       then Value := FMaxValue;
  if FCurValue <> Value
  then begin
         FCurValue := Value;
         if TempPercent <> GetPercentDone { only refresh if percentage changed }
         then Refresh;
       end;
end;

procedure TGauge.AddProgress(Value: Longint);
begin
  Progress := FCurValue + Value;
  Refresh;
end;





{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TUpDown Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TUpDownBtn=Class(TSpeedButton)
      Private
         FUp:Boolean;
         FTimer:TTimer;
      Protected
        Procedure SetupComponent;Override;
      Public
        Procedure Redraw(Const rec:TRect);Override;
        Procedure OnTimer(Sender:TObject);
        Procedure OnMDown(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
        Procedure OnMUp(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
    End;

Procedure TUpDownBtn.SetupComponent;
Begin
     Inherited SetupComponent;
     Include(ComponentState, csDetail);
     Caption := '';
     ParentPenColor := True;
     FTimer.Create(Self);
     FTimer.Interval:=400;
     FTimer.OnTimer:=OnTimer;
     OnMouseDown:=OnMDown;
     OnMouseUp:=OnMUp;
End;

{$HINTS OFF}
Procedure TUpDownBtn.OnMDown(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     FTimer.Stop;
     FTimer.Interval:=400;
     FTimer.Start;
End;

Procedure TUpDownBtn.OnMUp(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     FTimer.Stop;
End;

Procedure TUpDownBtn.OnTimer(Sender:TObject);
Begin
     FTimer.Stop;
     OnClick(Self);
     FTimer.Interval:=150;
     FTimer.Start;
End;
{$HINTS ON}

Procedure TUpDownBtn.Redraw(Const rec:TRect);
Var pts:Array[0..2] Of TPoint;
    WH:LongInt;
    space:LongInt;
Const MinSpace=2;
Begin
     Inherited Redraw(rec);

     Canvas.ClipRect:=rec;

     WH:=Height;
     If Width<WH Then WH:=Width;
     Dec(WH,4);
     If WH<1 Then WH:=1;
     space:=WH Div 5;
     If space<MinSpace Then space:=MinSpace;
     Dec(WH,space*2);

     If TUpDown(Owner).Orientation=udHorizontal Then
     Begin
          pts[0].X:=(Width-WH) Div 2;
          If Down Then Inc(pts[0].X);
          If pts[0].X<MinSpace Then pts[0].X:=MinSpace;

          If FUp Then  //Pfeil nach rechts
          Begin
               pts[0].Y:=Height-((Height-WH) Div 2);
               If pts[0].Y>Height-MinSpace Then pts[0].Y:=Height-MinSpace;

          End
          Else //Pfeil nach links
          Begin
               pts[0].Y:=Height Div 2;
               If pts[0].Y<MinSpace Then pts[0].Y:=MinSpace;
          End;
          If Down Then Dec(pts[0].Y);

          pts[1].X:=Width-((Width-WH) Div 2);
          If Down Then Inc(pts[1].X);
          If pts[1].X>Width-MinSpace Then pts[1].X:=Width-MinSpace;

          If FUp Then
          Begin
               pts[1].Y:=Height Div 2;
               If pts[1].Y<MinSpace Then pts[1].Y:=MinSpace;
          End
          Else
          Begin
               pts[1].Y:=Height-((Height-WH) Div 2);
               If pts[1].Y>Height-MinSpace Then pts[1].Y:=Height-MinSpace;
          End;
          If Down Then Dec(pts[1].Y);

          If FUp Then pts[2].X:=pts[0].X
          Else pts[2].X:=pts[1].X;

          pts[2].Y:=(Height-WH) Div 2;
          If pts[2].Y<MinSpace Then pts[2].Y:=MinSpace;
          If Down Then Dec(pts[2].Y);
     End
     Else
     Begin
          pts[0].X:=(Width-WH) Div 2;
          If Down Then Inc(pts[0].X);
          If pts[0].X<MinSpace Then pts[0].X:=MinSpace;

          If FUp Then
          Begin
               pts[0].Y:=(Height-WH) Div 2;
               If pts[0].Y<MinSpace Then pts[0].Y:=MinSpace;
          End
          Else
          Begin
               pts[0].Y:=Height-((Height-WH) Div 2);
               If pts[0].Y>Height-MinSpace Then pts[0].Y:=Height-MinSpace;
          End;
          If Down Then Dec(pts[0].Y);

          pts[1].X:=Width-((Width-WH) Div 2);
          If Down Then Inc(pts[1].X);
          If pts[1].X>Width-MinSpace Then pts[1].X:=Width-MinSpace;

          pts[1].Y:=pts[0].Y;

          pts[2].X:=pts[0].X+WH Div 2;
          If Down Then Inc(pts[2].X);

          If FUp Then
          Begin
               pts[2].Y:=Height-((Height-WH) Div 2);
               If pts[2].Y>Height-MinSpace Then pts[2].Y:=Height-MinSpace;
          End
          Else
          Begin
               pts[2].Y:=(Height-WH) Div 2;
               If pts[2].Y<MinSpace Then pts[2].Y:=MinSpace;
          End;
          If Down Then Dec(pts[2].Y);
     End;

     Canvas.Pen.color:=PenColor;
//     Canvas.BeginPath;
     Canvas.Polygon(pts);
//     Canvas.EndPath;
     Canvas.FillPath;
End;

///////////////////////////////////////////////////////////////////////

Procedure TUpDown.SetAssociate(NewControl:TControl);
Begin
     If NewControl=Self Then Exit;

     If FAssociate<>Nil Then FAssociate.Notification(Self,opRemove);
     FAssociate := NewControl;
     If FAssociate <> Nil Then FAssociate.FreeNotification(Self);
     AlignButton := FAlignButton;

     If Associate<>Nil Then
     Begin
          // TB 2005-07-03 because FPosition may be <> FMin set
          If Associate Is TScrollBar Then TScrollBar(Associate).Position:=FPosition
          Else If Associate Is TProgressBar Then TProgressBar(Associate).Position:=FPosition
          Else If Associate Is TTrackBar Then TTrackBar(Associate).Position:=FPosition
          Else If Associate Is TEdit Then TEdit(Associate).Text:=tostr(FPosition)
          Else Associate.Caption:=tostr(FMin);
     End;
End;


Procedure TUpDown.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FAssociate Then FAssociate := Nil;
End;


Procedure TUpDown.SetOrientation(NewValue:TUDOrientation);
Begin
     FOrientation:=NewValue;
     AlignButtons;
End;


Procedure TUpDown.SetPosition(NewValue:LongInt);
Begin
     If NewValue<Min Then NewValue:=Min;
     If NewValue>Max Then NewValue:=Max;
     If NewValue=FPosition Then Exit;
     FPosition:=NewValue;
     If Associate<>Nil Then
     Begin
          If Associate Is TScrollBar Then TScrollBar(Associate).Position:=FPosition
          Else If Associate Is TProgressBar Then TProgressBar(Associate).Position:=FPosition
          Else If Associate Is TTrackBar Then TTrackBar(Associate).Position:=FPosition
          Else Associate.Caption:=tostr(FPosition);
     End;
End;


Procedure TUpDown.SetMin(NewValue:LongInt);
Begin
     If NewValue>Max Then Exit;
     FMin:=NewValue;
     If Position<FMin Then Position:=FMin;
End;


Procedure TUpDown.SetMax(NewValue:LongInt);
Begin
     If NewValue<Min Then Exit;
     FMax:=NewValue;
     If Position>FMax Then Position:=FMax;
End;


Procedure TUpDown.SetAlignButton(NewValue:TUDAlignButton);
Begin
     FAlignButton:=NewValue;
     If Associate Is TControl Then
     Case AlignButton Of
       udRight:  SetWindowPos(Associate.Left+Associate.Width,Associate.Bottom,
                              Width,Height);
       udLeft:   SetWindowPos(Associate.Left-Width,Associate.Bottom,
                              Width,Height);
       udTop:    SetWindowPos(Associate.Left,Associate.Bottom+Associate.Height,
                              Width,Height);
       udBottom: SetWindowPos(Associate.Left,Associate.Bottom-Height,
                              Width,Height);
     End;
End;


Function GetUpRightButton(UpDown:TUpDown):TSpeedButton;
Begin
     Result:=UpDown.FUpRightButton;
End;

Function GetDownLeftButton(UpDown:TUpDown):TSpeedButton;
Begin
     Result:=UpDown.FDownLeftButton;
End;

Procedure TUpDown.SetupComponent;
Begin
     Inherited SetupComponent;

     ParentColor:=True;
     FArrowKeys:=True;
     FIncrement:=1;
     FMin:=0;
     FMax:=10;
     FPosition:=0;
     FThousands:=True;
     FWrap:=False;
     ParentColor:=True;
     PenColor:=clBlack;
     Width:=39;
     Height:=50;
     FAlignButton:=udNone;
     FOrientation:=udVertical;

     FUpRightButton:=TUpDownBtn.Create(Self);
     TUpDownBtn(FUpRightButton).FUp:=True;
     TUpDownBtn(FUpRightButton).OnClick:=EvButtonClick;
     InsertControl(FUpRightButton);
     FDownLeftButton:=TUpDownBtn.Create(Self);
     TUpDownBtn(FDownLeftButton).OnClick:=EvButtonClick;
     InsertControl(FDownLeftButton);
End;


Procedure TUpDown.AlignButtons;
Begin
     Case FOrientation Of
         udHorizontal:
         Begin
              FDownLeftButton.SetWindowPos(0,0,(Width Div 2),Height);
              FUpRightButton.SetWindowPos((Width Div 2),0,(Width Div 2),Height);
         End;
         udVertical:
         Begin
              FDownLeftButton.SetWindowPos(0,0,Width,(Height Div 2));
              FUpRightButton.SetWindowPos(0,(Height Div 2),Width,(Height Div 2));
         End;
     End;
End;


Procedure TUpDown.SetupShow;
Begin
     Inherited SetupShow;

     AlignButtons;
End;


Procedure TUpDown.Resize;
Begin
     Inherited Resize;

     AlignButtons;
End;


Procedure TUpDown.EvButtonClick(Sender:TObject);
Begin
     If Not CanChange Then Exit;

     If TBitBtn(Sender)=FUpRightButton Then
     Begin
          If Position=Max Then
          Begin
               If Not FWrap Then Exit;
               Position:=Min;
          End
          Else Position:=Position+1;
          Click(btNext);
     End
     Else
     Begin
          If Position=Min Then
          Begin
               If Not FWrap Then Exit;
               Position:=Max;
          End
          Else Position:=Position-1;
          Click(btPrev);
     End;
End;


Function TUpDown.CanChange:Boolean;
Begin
     Result := True;
     If FOnChanging <> Nil Then FOnChanging(Self,Result);
End;


Procedure TUpDown.Click(Button:TUDBtnType);
Begin
     If FOnClick <> Nil Then FOnClick(Self,Button);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TTrackBar Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TTrackBar.SetMax(NewValue:LongInt);
Begin
     If csLoading In ComponentState Then
     Begin
          FMax:=NewValue;
          exit;
     End;
     If NewValue<Min Then Exit;
     FMax:=NewValue;
     If Position>Max Then Position:=Max;
End;

Procedure TTrackBar.SetMin(NewValue:LongInt);
Begin
     If csLoading In ComponentState Then
     Begin
          FMin:=NewValue;
          exit;
     End;
     If NewValue>Max Then Exit;
     FMin:=NewValue;
     If FSelMode=smAuto Then If FSelStart<>Min Then
     Begin
          FSelStart:=Min;
          FSelEnd:=FPosition;
          If Not FUpdating Then Invalidate;
     End;
     If Position<Min Then Position:=Min;
End;

Procedure TTrackBar.SetOrientation(NewValue:TTrackBarOrientation);
Begin
     If FOrientation=NewValue Then Exit;
     FOrientation:=NewValue;
     //Exchange Width And Height
     SetWindowPos(Left,Bottom,Height,Width)
End;

Procedure TTrackBar.SetPosition(NewValue:LongInt);
Begin
     If csLoading In ComponentState Then
     Begin
          FPosition:=NewValue;
          exit;
     End;
     If NewValue<Min Then NewValue:=Min;
     If NewValue>Max Then NewValue:=Max;
     If NewValue=Position Then Exit;
     FPosition:=NewValue;
     If FSelMode=smAuto Then
     Begin
          FSelStart:=Min;
          FSelEnd:=FPosition;
     End;
     UpdateSlider;
     Change;
End;

Procedure TTrackBar.Change;
Begin
     If OnChange<>Nil Then OnChange(Self);
End;

Procedure TTrackBar.SetSelEnd(NewValue:LongInt);
Begin
     If FSelMode<>smManual Then Exit;
     FSelEnd:=NewValue;
     If FSelEnd>FSelStart Then If Not FUpdating Then UpdateSlider;
End;

Procedure TTrackBar.SetSelStart(NewValue:LongInt);
Begin
     If FSelMode<>smManual Then Exit;
     FSelStart:=NewValue;
     If FSelStart<FSelEnd Then If Not FUpdating Then UpdateSlider;
End;

Procedure TTrackBar.SetTickMarks(NewValue:TTickMarks);
Begin
     FTickMarks:=NewValue;
     If NewValue=tmBoth Then FSliderShape:=tsBox
     Else FSliderShape:=tsArrow;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetTickStyle(NewValue:TTickStyle);
Begin
     FTickStyle:=NewValue;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetFrequency(NewValue:LongInt);
Begin
     If csLoading In ComponentState Then
     Begin
          FFrequency:=NewValue;
          exit;
     End;
     If NewValue<1 Then NewValue:=1;
     If Min+NewValue>Max Then NewValue:=Max-Min;
     FFrequency:=NewValue;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetSelMode(NewMode:TTrackBarSelMode);
Begin
     FSelMode:=NewMode;
     If FSelMode=smAuto Then
     Begin
          FSelStart:=Min;
          FSelEnd:=Position;
     End;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetupComponent;
Begin
     Inherited SetupComponent;

     ParentColor:=True;
     FShowFocusRect:=True;
     FPosition:=0;
     FLineSize:=1;
     FPageSize:=5;
     FMax:=10;
     FMin:=0;
     FOrientation:=trHorizontal;
     FSelEnd:=0;
     FSelStart:=0;
     FTickMarks:=tmBottomRight;
     FTickStyle:=tsAuto;
     FFrequency:=1;
     FSelMode:=smManual;
     FSliderShape:=tsArrow;
     Width:=200;
     Height:=50;
     FTrackTimer.Create(Self);
     Include(FTrackTimer.ComponentState, csDetail);
     FTrackTimer.Interval:=400;
     FTrackTimer.OnTimer:=EvTimer;
     FSliderSize:=tssAuto;
End;

Destructor TTrackBar.Destroy;
Begin
     If FTicks<>Nil Then FTicks.Destroy;
     Inherited Destroy;
End;

Procedure TTrackBar.DrawSlider(SliderW,SliderH:LongInt);
Var
   pts:Array[0..5] Of TPoint;
   Diff,Diff1:LongInt;

   Procedure Draw;
   Begin
        Canvas.BeginPath;
        Canvas.PolyLine(pts);
        Canvas.EndPath;
   End;

   Procedure Inflate;
   Begin
        If Orientation=trHorizontal Then
        Begin
             If FSliderShape=tsBox Then
             Begin
                  Dec(pts[0].X);
                  Dec(pts[0].Y);

                  Inc(pts[1].X);
                  Dec(pts[1].Y);

                  Inc(pts[2].X);
                  Inc(pts[2].Y);

                  Dec(pts[3].X);
                  Inc(pts[3].Y);

                  pts[4]:=pts[0];
                  pts[5]:=pts[0];
             End
             Else
             Begin
                  Dec(pts[0].Y);
                  Dec(pts[1].Y);
                  Inc(pts[2].X);
                  Inc(pts[3].X);
                  Inc(pts[3].Y);
                  Dec(pts[4].X);
                  Inc(pts[4].Y);
                  Dec(pts[5].X);
             End;
        End
        Else
        Begin
             If FSliderShape=tsBox Then
             Begin
                  Dec(pts[0].X);
                  Dec(pts[0].Y);

                  Inc(pts[1].X);
                  Dec(pts[1].Y);

                  Inc(pts[2].X);
                  Inc(pts[2].Y);

                  Dec(pts[3].X);
                  Inc(pts[3].Y);

                  pts[4]:=pts[0];
                  pts[5]:=pts[0];
             End
             Else
             Begin
                  Dec(pts[0].Y);
                  Inc(pts[1].Y);
                  Inc(pts[2].X);
                  Inc(pts[2].Y);
                  Dec(pts[3].X);
                  Inc(pts[3].Y);
                  Dec(pts[4].X);
                  Dec(pts[4].Y);
                  Inc(pts[5].X);
                  Dec(pts[5].Y);
             End;
        End;
   End;

   Procedure DrawBoxL;
   Begin
        Canvas.PenPos:=pts[0];
        If FSliderShape=tsBox Then
        Begin
             Canvas.LineTo(pts[3].X,pts[3].Y);
             Canvas.LineTo(pts[2].X,pts[2].Y);
        End
        Else
        Begin
             Canvas.LineTo(pts[5].X,pts[5].Y);
             Canvas.LineTo(pts[4].X,pts[4].Y);
             Canvas.LineTo(pts[3].X,pts[3].Y);
        End;
   End;

   Procedure DrawBoxR;
   Begin
        Canvas.PenPos:=pts[0];
        If FSliderShape=tsBox Then
        Begin
             Canvas.LineTo(pts[1].X,pts[1].Y);
             Canvas.LineTo(pts[2].X,pts[2].Y);
        End
        Else
        Begin
             Canvas.LineTo(pts[1].X,pts[1].Y);
             Canvas.LineTo(pts[2].X,pts[2].Y);
             Canvas.LineTo(pts[3].X,pts[3].Y);
        End;
   End;

Begin
     Canvas.Pen.color:=color;

     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     If Orientation=trHorizontal Then
     Begin
          If FSliderShape=tsBox Then
          Begin
               pts[0].X:=2+CoordFromPos(Position)-SliderW Div 2;
               pts[0].Y:=Height-Diff-SliderH+SliderH Div 6;
               pts[1].X:=pts[0].X+SliderW-5;
               pts[1].Y:=pts[0].Y;
               pts[2].X:=pts[1].X;
               pts[2].Y:=pts[0].Y+SliderH-2-SliderH Div 6;
               pts[3].X:=pts[0].X;
               pts[3].Y:=pts[2].Y;
               pts[4]:=pts[0];
               pts[5]:=pts[0];
          End
          Else
          Begin
               pts[0].X:=CoordFromPos(Position)-1;
               pts[0].Y:=Height-Diff-SliderH+2;

               pts[1].X:=pts[0].X+2;
               pts[1].Y:=pts[0].Y;

               pts[2].X:=pts[1].X+((SliderW-8) Div 2);
               pts[2].Y:=pts[1].Y+(SliderH Div 3);

               pts[3].X:=pts[2].X;
               pts[3].Y:=pts[0].Y+SliderH-4;

               pts[4].X:=pts[0].X-((SliderW-6) Div 2);
               pts[4].Y:=pts[3].Y;

               pts[5].X:=pts[4].X;
               pts[5].Y:=pts[2].Y;

               If TickMarks=tmTopLeft Then
               Begin
                    Diff1:=pts[2].Y-pts[0].Y;
                    pts[3].Y:=pts[0].Y;
                    pts[0].Y:=pts[4].Y+SliderH Div 6;
                    pts[4].Y:=pts[3].Y;
                    pts[1].Y:=pts[0].Y;
                    pts[5].Y:=pts[0].Y-Diff1;
                    pts[2].Y:=pts[5].Y;
               End;
          End;
     End
     Else
     Begin
          If FSliderShape=tsBox Then
          Begin
               pts[0].X:=Diff+2;
               pts[0].Y:=2+CoordFromPos(Position)-SliderW Div 2;
               pts[1].X:=pts[0].X+SliderH-3-SliderH Div 6;
               pts[1].Y:=pts[0].Y;
               pts[2].Y:=pts[0].Y+SliderW-5;
               pts[2].X:=pts[1].X;
               pts[3].Y:=pts[2].Y;
               pts[3].X:=pts[0].X;
               pts[4]:=pts[0];
               pts[5]:=pts[0];
          End
          Else
          Begin
               pts[0].Y:=CoordFromPos(Position)-1;
               pts[0].X:=Diff+SliderH-1;

               pts[1].Y:=pts[0].Y+2;
               pts[1].X:=pts[0].X;

               pts[2].Y:=pts[1].Y+((SliderW-8) Div 2);
               pts[2].X:=pts[1].X-(SliderH Div 3);

               pts[3].Y:=pts[2].Y;
               pts[3].X:=Diff+2;

               pts[4].Y:=pts[0].Y-((SliderW-6) Div 2);
               pts[4].X:=pts[3].X;

               pts[5].Y:=pts[4].Y;
               pts[5].X:=pts[2].X;

               If TickMarks=tmTopLeft Then
               Begin
                    Diff1:=pts[0].X-pts[2].X;
                    pts[3].X:=pts[0].X;
                    pts[0].X:=pts[4].X-SliderH Div 6;
                    pts[4].X:=pts[3].X;
                    pts[1].X:=pts[0].X;
                    pts[5].X:=pts[0].X+Diff1;
                    pts[2].X:=pts[5].X;
               End;
          End;
     End;

     //Draw filled portion
     If FTracking Then
     Begin
          Canvas.Brush.color:=clWhite;
          Canvas.Brush.Style:=bsDiagCross;
     End;
     Draw;
     Canvas.FillPath;
     If FTracking Then
     Begin
          Canvas.Brush.Style:=bsSolid;
          Canvas.Brush.color:=color;
     End;

     Inflate;

     Canvas.Pen.color:=clBtnHighlight;
     DrawBoxL;

     Canvas.Pen.color:=clBtnShadow;
     DrawBoxR;

     Inflate;

     Canvas.Pen.color:=clBtnHighlight;
     DrawBoxL;

     Canvas.Pen.color:=clBtnDefault;
     DrawBoxR;

     Draw;
     Canvas.PathToClipRegion(paDiff);
End;

Procedure TTrackBar.DrawTrack(SliderW,SliderH:LongInt);
Var  rc,rc1:TRect;
     Diff:LongInt;
Begin
     //Draw Slider
     DrawSlider(SliderW,SliderH);

     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     //Draw Box
     If Orientation=trHorizontal Then
     Begin
          rc.Left := 2;
          rc.Bottom := Height-Diff-(SliderH Div 3)*2 -1;
          rc.Right := Width-3;
          rc.Top := (Height-Diff-SliderH Div 6)-2 +1;
     End
     Else
     Begin
          rc.Left := Diff+2+(SliderH Div 6) -1;
          rc.Bottom := 2;
          rc.Right := rc.Left + (SliderH Div 6) + (SliderH Div 3);
          rc.Top := Height-3;
     End;
     DrawSystemBorder(Self,rc,bsSingle);

     If FSelMode=smAuto Then
     Begin
          FSelStart:=Min;
          FSelEnd:=FPosition;
     End;

     If FSelEnd>FSelStart Then
     Begin
          If Orientation=trHorizontal Then
          Begin
               rc1.Left:=CoordFromPos(FSelStart);
               rc1.Right:=CoordFromPos(FSelEnd);
               If rc.Top-rc.Bottom>6 Then  //medium And large
               Begin
                    rc1.Bottom:=rc.Bottom+2;
                    rc1.Top:=rc.Top-2;
               End
               Else //small
               Begin
                    rc1.Bottom:=rc.Bottom+1;
                    rc1.Top:=rc.Top-1;
               End;
               Canvas.FillRect(rc1,clHighlight);
               Canvas.ExcludeClipRect(rc1);
          End
          Else
          Begin
               rc1.Bottom:=CoordFromPos(FSelStart);
               rc1.Top:=CoordFromPos(FSelEnd);
               If rc.Right-rc.Left>6 Then  //medium And large
               Begin
                    rc1.Left:=rc.Left+2;
                    rc1.Right:=rc.Right-2;
               End
               Else //small
               Begin
                    rc1.Left:=rc.Left+1;
                    rc1.Right:=rc.Right-1;
               End;
               Canvas.FillRect(rc1,clHighlight);
               Canvas.ExcludeClipRect(rc1);
          End;
     End;

     Canvas.FillRect(rc,clWhite);
     Forms.InflateRect(rc, 2, 2);
     Canvas.ExcludeClipRect(rc);
End;

Procedure TTrackBar.Redraw(Const rec:TRect);
Var SliderWidth,SliderHeight:LongInt;
    T:LongInt;
    X,Y,Diff:LongInt;
    rc:TRect;

    Procedure DrawTick(X,Y,X1,y1:LongInt);
    Var rc:TRect;
    Begin
         rc.LeftBottom:=Point(X1,y1);
         rc.RightTop:=Point(X,Y);
         Canvas.BeginPath;
         Canvas.Rectangle(rc);
         Canvas.EndPath;
         Canvas.OutlinePath;
         Canvas.BeginPath;
         Canvas.Rectangle(rc);
         Canvas.EndPath;
         Canvas.PathToClipRegion(paDiff);
    End;

    Procedure DrawLabelX;
    Begin
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then
         Begin
              DrawTick(X,Y,X,Y-FTickSize);
         End;
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then
         Begin
              DrawTick(X,Height-Diff+6,X,Height-Diff+6+FTickSize)
         End;
    End;

    Procedure DrawLabelY;
    Begin
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then
         Begin
              If ((SliderHeight=45)Or(SliderHeight=38)) Then
              Begin
                   If FSliderShape=tsBox Then
                      DrawTick(Diff+SliderHeight,Y,Diff+SliderHeight+FTickSize,Y)
                   Else
                      DrawTick(Diff+SliderHeight+2,Y,Diff+SliderHeight+2+FTickSize,Y)
              End
              Else  DrawTick(Diff+SliderHeight+2,Y,Diff+SliderHeight+2+FTickSize,Y)
         End;
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then
         Begin
              DrawTick(X,Y,X-FTickSize,Y);
         End;
    End;
Begin
     GetSliderExtent(SliderWidth,SliderHeight);

     //Draw Slider And Box
     DrawTrack(SliderWidth,SliderHeight);

     //Draw Ticks
     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;
     If Orientation=trHorizontal Then
     Begin
          Case FTickStyle Of
             tsAuto:
             Begin
                  Y:=Height-Diff-SliderHeight+2;
                  Dec(Y,5);

                  Canvas.Pen.color:=clBlack;
                  For T:=Min To Max Do
                  Begin
                       X:=CoordFromPos(T);
                       DrawLabelX;
                       Inc(T,FFrequency-1);
                  End;
             End;
             tsManual,tsNone:
             Begin
                  Y:=Height-Diff-SliderHeight+2;
                  Dec(Y,5);

                  Canvas.Pen.color:=clBlack;
                  If FTickStyle=tsManual Then
                  Begin
                       X:=CoordFromPos(Min);
                       DrawLabelX;

                       X:=CoordFromPos(Max);
                       DrawLabelX;
                  End;

                  If FTicks<>Nil Then For T:=0 To FTicks.Count-1 Do
                  Begin
                       X:=CoordFromPos(LongInt(FTicks[T]));
                       DrawLabelX;
                  End;
             End;
          End; {Case}
     End
     Else
     Begin
          Case FTickStyle Of
             tsAuto:
             Begin
                  X:=Diff-5;
                  If SliderHeight<>12 Then Dec(X,2);

                  Canvas.Pen.color:=clBlack;
                  For T:=Min To Max Do
                  Begin
                       Y:=CoordFromPos(T);
                       DrawLabelY;
                       Inc(T,FFrequency-1);
                  End;
             End;
             tsManual,tsNone:
             Begin
                  X:=Diff-5;
                  If SliderHeight<>12 Then Dec(X,2);

                  Canvas.Pen.color:=clBlack;
                  If FTickStyle=tsManual Then
                  Begin
                       Y:=CoordFromPos(Min);
                       DrawLabelY;

                       Y:=CoordFromPos(Max);
                       DrawLabelY;
                  End;

                  If FTicks<>Nil Then For T:=0 To FTicks.Count-1 Do
                  Begin
                       Y:=CoordFromPos(LongInt(FTicks[T]));
                       DrawLabelY;
                  End;
             End;
          End; {Case}
     End;

     //Erase background
     If HasFocus Then
     Begin
          rc:=ClientRect;
          Forms.InflateRect(rc,-1,-1);
     End
     Else rc:=rec;
     Inherited Redraw(rc);

     If HasFocus Then If ShowFocusRect Then
     Begin
          Canvas.DeleteClipRegion;
          rc:=ClientRect;
          Canvas.DrawFocusRect(rc);
     End;
End;

Procedure TTrackBar.GetSliderExtent(Var SliderWidth,SliderHeight:LongInt);
Var Extent,Diff:LongInt;
Label vl,L,M,S;
Begin
     Case SliderSize Of
        tssAuto:
        Begin
             If Orientation=trHorizontal Then Extent:=Height
             Else Extent:=Width;
             If TickMarks=tmBoth Then Diff:=44
             Else If TickMarks=tmTopLeft Then Diff:=24
             Else If TickMarks=tmBottomRight Then Diff:=24;

             If Extent>35+Diff Then //super large Size
             Begin
vl:
                  SliderWidth:=24;
                  SliderHeight:=45;
                  FTickSize:=12;
             End
             Else If Extent>25+Diff Then //large Size
             Begin
L:
                  SliderWidth:=20;
                  SliderHeight:=38;
                  FTickSize:=8;
             End
             Else If Extent>20+Diff Then //medium Size
             Begin
M:
                  SliderWidth:=16;
                  SliderHeight:=30;
                  FTickSize:=6;
             End
             Else //small Size
             Begin
S:
                  SliderWidth:=6;
                  SliderHeight:=12;
                  FTickSize:=3;
             End;
        End;
        tssVeryLarge:Goto vl;
        tssLarge:Goto L;
        tssMedium:Goto M;
        tssSmall:Goto S;
     End; {Case}
End;

Function TTrackBar.CoordFromPos(Position:LongInt):LongInt;
Var
   Scale:Extended;
   WH:LongInt;
   SliderWidth,SliderHeight:LongInt;
Begin
     GetSliderExtent(SliderWidth,SliderHeight);
     If Orientation=trHorizontal Then WH:=Width-2
     Else WH:=Height-2;
     Dec(WH,SliderWidth);
     Scale:=WH/(Max-Min);
     Result:=Round((Position-Min)*Scale);
     Inc(Result,1+SliderWidth Div 2)
End;

Function TTrackBar.PosFromCoord(Coord:LongInt):LongInt;
Var
   Scale:Extended;
   WH:LongInt;
   SliderWidth,SliderHeight:LongInt;
Begin
     GetSliderExtent(SliderWidth,SliderHeight);
     If Orientation=trHorizontal Then WH:=Width-2
     Else WH:=Height-2;
     Dec(WH,SliderWidth Div 2);
     Scale:=WH/(Max-Min);
     Result:=Min+Round((Coord-1)/Scale);
End;

Function TTrackBar.PosInsideSlider(X,Y:LongInt):Boolean;
Var SliderW,SliderH,Diff:LongInt;
    pts:Array[0..3] Of TPoint;
Begin
     GetSliderExtent(SliderW,SliderH);
     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     If Orientation=trHorizontal Then
     Begin
         pts[0].X:=CoordFromPos(Position)-SliderW Div 2;
         pts[0].Y:=Height-Diff-SliderH+2;
         pts[1].X:=pts[0].X+SliderW;
         pts[1].Y:=Height-Diff;

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End
     Else
     Begin
         pts[0].Y:=CoordFromPos(Position)-SliderW Div 2;
         pts[0].X:=Diff+2;
         pts[1].Y:=pts[0].Y+SliderW;
         pts[1].X:=pts[0].X+SliderH;

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End;
End;

Function TTrackBar.PosInsideTrack(X,Y:LongInt):Boolean;
Var SliderW,SliderH,Diff:LongInt;
    pts:Array[0..3] Of TPoint;
Begin
     GetSliderExtent(SliderW,SliderH);
     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     If Orientation=trHorizontal Then
     Begin
         pts[0].X:=3;
         pts[0].Y:=Height-Diff-((SliderH Div 3)*2);
         pts[1].X:=Width-3;
         pts[1].Y:=Height-Diff-(SliderH Div 6);

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End
     Else
     Begin
         pts[0].Y:=3;
         pts[0].X:=Diff+SliderH Div 6;
         pts[1].Y:=Height-3;
         pts[1].X:=Diff+((SliderH Div 3)*2);

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End;
End;

Procedure TTrackBar.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);
     If Button=mbLeft Then
     Begin
          Focus;
          If PosInsideSlider(X,Y) Then
          Begin
               MouseCapture:=True;
               FTracking:=True;
               UpdateSlider;
          End
          Else If PosInsideTrack(X,Y) Then
          Begin
               MouseCapture:=True;
               FTrackTimer.Start;
          End;
     End;
End;

Procedure TTrackBar.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);
     If Button=mbLeft Then
     Begin
          If FTracking Then
          Begin
               MouseCapture:=False;
               FTracking:=False;
               UpdateSlider;
               Change;
          End
          Else
          Begin
               MouseCapture:=False;
               FTrackTimer.Stop;
          End;
     End;
End;

Procedure TTrackBar.UpdateSlider;
Var rc,rc1:TRect;
    SliderWidth,SliderHeight:LongInt;
Begin
     If Canvas<>Nil Then
     Begin
         rc:=ClientRect;
         Inc(rc.Right);
         Inc(rc.Top);

         rc1:=rc;
         GetSliderExtent(SliderWidth,SliderHeight);

         If Orientation=trHorizontal Then
         Begin
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Dec(rc.Top,15);
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then
              Begin
                   rc.Bottom:=rc.Top-SliderHeight-4;
                   If SliderHeight=45 Then Inc(rc.Bottom);
              End;
         End
         Else
         Begin
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Inc(rc.Left,15);
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then rc.Right:=rc.Left+SliderHeight+5;
         End;

         If rc.Top=rc1.Top Then Dec(rc.Top);
         If rc.Right=rc1.Right Then Dec(rc.Right);
         If rc.Left=rc1.Left Then Inc(rc.Left);
         If rc.Bottom=rc1.Bottom Then Inc(rc.Bottom);
         Canvas.ClipRect:=rc;
         DrawTrack(SliderWidth,SliderHeight);
         {?????????+-1}
         Dec(rc.Right);
         Dec(rc.Top);
         Canvas.FillRect(rc,color);
         Canvas.DeleteClipRegion;
     End;
End;

Procedure TTrackBar.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var NewPos:LongInt;
Begin
     Inherited MouseMove(ShiftState,X,Y);
     If FTracking Then
     Begin
          If Orientation=trHorizontal Then NewPos:=PosFromCoord(X)
          Else NewPos:=PosFromCoord(Y);
          Position:=NewPos;
     End;
End;

Procedure TTrackBar.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var C:LongInt;
Begin
     Inherited MouseClick(Button,ShiftState,X,Y);
     If Button=mbLeft Then
     Begin
          If Not PosInsideSlider(X,Y) Then If PosInsideTrack(X,Y) Then
          Begin
               C:=CoordFromPos(Position);
               If Orientation=trHorizontal Then
               Begin
                    If C<X Then Position:=Position+PageSize
                    Else Position:=Position-PageSize;
               End
               Else
               Begin
                    If C<Y Then Position:=Position+PageSize
                    Else Position:=Position-PageSize;
               End;
          End;
     End;
End;

Procedure TTrackBar.EvTimer(Sender:TObject);
Var MPos:Array[0..0] Of TPoint;
    C:LongInt;
    SliderW,SliderH:LongInt;
Begin
     If Sender=FTrackTimer Then
     Begin
          GetSliderExtent(SliderW,SliderH);
          MPos[0]:=Screen.MousePos;
          Screen.MapPoints(Self,MPos);
          C:=CoordFromPos(Position);
          If Not PosInsideSlider(MPos[0].X,MPos[0].Y) Then
          Begin
               If Orientation=trHorizontal Then
               Begin
                    If C+SliderW<MPos[0].X Then Position:=Position+LineSize
                    Else If C>MPos[0].X+SliderW Then Position:=Position-LineSize;
               End
               Else
               Begin
                    If C+SliderW Div 2<MPos[0].Y Then Position:=Position+LineSize
                    Else If C>MPos[0].Y+SliderW Div 2 Then Position:=Position-LineSize;
               End;
          End;
     End;
End;

Procedure TTrackBar.SetFocus;
Begin
     Inherited SetFocus;
     Invalidate;
End;

Procedure TTrackBar.KillFocus;
Begin
     Inherited KillFocus;
     Invalidate;
End;

Procedure TTrackBar.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     Case KeyCode Of
         kbCLeft:If Orientation=trHorizontal Then Position:=Position-LineSize;
         kbCRight:If Orientation=trHorizontal Then Position:=Position+LineSize;
         kbCUp:If Orientation=trVertical Then Position:=Position+LineSize;
         kbCDown:If Orientation=trVertical Then Position:=Position-LineSize;
         kbPageDown:Position:=Position-PageSize;
         kbPageUp:Position:=Position+PageSize;
         Else Inherited ScanEvent(KeyCode,RepeatCount);
     End; //Case
End;

Procedure TTrackBar.SetTick(Pos:LongInt);
Begin
     If FTicks=Nil Then FTicks.Create;
     FTicks.Add(Pointer(Pos));
End;

Procedure TTrackBar.ClearTicks;
Begin
     If FTicks<>Nil Then FTicks.Clear;
End;

Procedure TTrackBar.BeginUpdate;
Begin
     FUpdating:=True;
End;

Procedure TTrackBar.EndUpdate;
Begin
     FUpdating:=False;
     Invalidate;
End;

Procedure TTrackBar.SetSliderSize(NewSize:TTrackSliderSize);
Begin
     FSliderSize:=NewSize;
     If Not FUpdating Then Invalidate;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TStatusPanel Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TStatusPanel.GetText:String;
Begin
     If FText<>Nil Then Result:=FText^
     Else Result:='';
End;

Procedure TStatusPanel.SetText(Const NewValue:String);
Begin
     If FText<>Nil Then
     Begin
          If NewValue=FText^ Then Exit;
          FreeMem(FText,Length(FText^)+1);
     End;

     GetMem(FText,Length(NewValue)+1);
     FText^:=NewValue;
     changed(False);
End;

Procedure TStatusPanel.SetWidth(NewValue:LongInt);
Begin
     If NewValue=FWidth Then Exit;
     FWidth:=NewValue;
     changed(True);
End;

Procedure TStatusPanel.SetAlignment(NewValue:TAlignment);
Begin
     If NewValue=FAlignment Then Exit;
     FAlignment:=NewValue;
     changed(False);
End;

Procedure TStatusPanel.SetBevel(NewValue:TStatusPanelBevel);
Begin
     If NewValue=FBevel Then Exit;
     FBevel:=NewValue;
     changed(True);
End;

Procedure TStatusPanel.SetStyle(NewValue:TStatusPanelStyle);
Begin
     If NewValue=FStyle Then Exit;
     FStyle:=NewValue;
     changed(False);
End;

Constructor TStatusPanel.Create(ACollection:TCollection);
Begin
     FBevel:=pbLowered;
     FAlignment:=taLeftJustify;
     FStyle:=psText;
     FWidth:=100;
     Inherited Create(ACollection);
End;

Destructor TStatusPanel.Destroy;
Begin
     If FText<>Nil Then FreeMem(FText,Length(FText^)+1);

     Inherited Destroy;
End;

Procedure TStatusPanel.Assign(Source:TCollectionItem);
Begin
     If Source Is TStatusPanel Then
       If Source<>Self Then
     Begin
          FBevel:=TStatusPanel(Source).Bevel;
          FStyle:=TStatusPanel(Source).Style;
          FAlignment:=TStatusPanel(Source).Alignment;
          Width:=TStatusPanel(Source).Width;
          Text:=TStatusPanel(Source).Text;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TStatusPanels Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TStatusPanels.GetItem(Index:LongInt):TStatusPanel;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited GetItem(Index);
     Result:=TStatusPanel(dummy);
End;

Procedure TStatusPanels.SetItem(Index:LongInt;Value:TStatusPanel);
Begin
     Inherited SetItem(Index,Value);
End;

Procedure TStatusPanels.Update(Item:TCollectionItem);
Begin
     If FStatusBar=Nil Then Exit;
     If Item=Nil Then FStatusBar.Invalidate
     Else FStatusBar.UpdatePanel(TStatusPanel(Item));
End;

Procedure TStatusPanels.SetupComponent;
Begin
     Inherited SetupComponent;

     If Owner Is TStatusBar Then FStatusBar:=TStatusBar(Owner);
     ItemClass:=TStatusPanel;
End;

Function TStatusPanels.Add:TStatusPanel;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited Add;
     Result:=TStatusPanel(dummy);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TStatusBar Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TStatusBar.UpdatePanel(Panel:TStatusPanel);
Var rc:TRect;
    T:LongInt;
    IsLastPanel:Boolean;
Begin
     If FSimplePanel Then
     Begin
          Invalidate;
          Exit;
     End;

     //Get Rectangle For the Panel
     IsLastPanel := False;
     rc:=ClientRect;
     For T:=0 To FPanels.Count-1 Do
     Begin
          If FPanels[T]=Panel Then
          Begin
               If T = FPanels.Count-1 Then IsLastPanel := True;
               break;
          End
          Else Inc(rc.Left,FPanels[T].Width+FSpacing);
     End;

     If IsLastPanel Then rc.Right:=Width-1
     Else rc.Right:=rc.Left+Panel.Width;
     InvalidateRect(rc);
     Update;
End;

Procedure TStatusBar.SetSimpleText(Const NewText:String);
Begin
     FSimpleText:=NewText;
     If FSimplePanel Then Invalidate;
End;

Procedure TStatusBar.SetSimplePanel(NewValue:Boolean);
Begin
     FSimplePanel:=NewValue;
     {If FSimplePanel Then} Invalidate;
End;

Procedure TStatusBar.SetPanels(NewValue:TStatusPanels);
Begin
     FPanels.Assign(NewValue);
End;

Procedure TStatusBar.SetSizeGrip(NewValue:Boolean);
Begin
     FSizeGrip:=NewValue;
     Invalidate;
End;

Procedure TStatusBar.SetSpacing(NewValue:LongInt);
Begin
     If FSpacing<0 Then FSpacing:=0;
     FSpacing:=NewValue;
     Invalidate;
End;

Procedure TStatusBar.SetupComponent;
Begin
     Inherited SetupComponent;

     Align:=alBottom;
     FSizeGrip:=True;
     FPanels.Create(Self);
     Height:=35;
     FSpacing:=2;
End;

Destructor TStatusBar.Destroy;
Begin
     FPanels.Destroy;
     Inherited Destroy;
End;

Procedure TStatusBar.DrawPanel(Panel:TStatusPanel;Const rc:TRect);
Var
   Align:TAlignment;
   S:String;
   Bev:TStatusPanelBevel;
   CX,CY,H:LongInt;
   RaisedColor,LoweredColor:TColor;
   rec:TRect;
Begin
     If Panel=Nil Then
     Begin
          Align:=taLeftJustify;
          S:=FSimpleText;
          If Style=bsLowered Then Bev:=pbLowered
          Else Bev:=pbRaised;
     End
     Else
     Begin
          Align:=Panel.Alignment;
          S:=Panel.Text;
          Bev:=Panel.Bevel;
     End;

     Canvas.GetTextExtent(S,CX,CY);

     Case Align Of
        taLeftJustify:rec.Left:=rc.Left+3;
        taRightJustify:rec.Left:=rc.Right-3-CX;
        Else //taCenter
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX) Div 2);
        End;
     End; //Case

     If rec.Left<rc.Left+3 Then rec.Left:=rc.Left+3;
     H:=rc.Top-rc.Bottom;
     rec.Bottom:=rc.Bottom+((H-CY) Div 2);
     If rec.Bottom<rc.Bottom+3 Then rec.Bottom:=rc.Bottom+3;
     rec.Right:=rec.Left+CX-1;
     rec.Top:=rec.Bottom+CY-1;

     Canvas.TextOut(rec.Left,rec.Bottom,S);

     Canvas.ExcludeClipRect(rec);

     If Bev=pbNone Then Canvas.FillRect(rc,color)
     Else
     Begin
          If Bev=pbRaised Then
          Begin
               RaisedColor:=clWhite;
               LoweredColor:=clDkGray;
          End
          Else
          Begin
               RaisedColor:=clDkGray;
               LoweredColor:=clWhite;
          End;

          Canvas.ShadowedBorder(rc,RaisedColor,LoweredColor);
          rec:=rc;
          Forms.InflateRect(rec,-1,-1);
          Canvas.FillRect(rec,color)
     End;
End;

Procedure TStatusBar.Redraw(Const rec:TRect);
Var T:LongInt;
    rc,rc2:TRect;
    Panel:TStatusPanel;
Begin
     Canvas.ClipRect:=rec;
     Canvas.Pen.color:=PenColor;
     Canvas.Brush.color:=color;

     If ((FSimplePanel)Or(FPanels.Count=0)) Then
     Begin
          rc:=ClientRect;
          DrawPanel(Nil,rc);
     End
     Else
     Begin
          rc:=ClientRect;

          For T:=0 To FPanels.Count-1 Do
          Begin
               Panel:=FPanels[T];
               If T=FPanels.Count-1 Then rc.Right:=Width-1
               Else rc.Right:=rc.Left+Panel.Width;
               If rc.Right>Width-1 Then rc.Right:=Width-1;

               rc2:=Forms.IntersectRect(rc,rec);
               If Not Forms.IsRectEmpty(rc2) Then
               Begin
                    Canvas.ClipRect:=rc2;

                    If Panel.Style=psOwnerDraw Then
                    Begin
                         If OnDrawPanel<>Nil Then OnDrawPanel(Self,Panel,rc)
                         Else DrawPanel(Panel,rc);
                    End
                    Else DrawPanel(Panel,rc);
               End;
               Inc(rc.Left,Panel.Width+FSpacing);
          End;

          Canvas.ClipRect:=rec;
          rc:=ClientRect;
          For T:=0 To FPanels.Count-1 Do
          Begin
               Panel:=FPanels[T];
               If T=FPanels.Count-1 Then rc.Right:=Width-1
               Else rc.Right:=rc.Left+Panel.Width;
               If rc.Right>Width-1 Then rc.Right:=Width-1;

               Canvas.ExcludeClipRect(rc);
               Inc(rc.Left,Panel.Width+FSpacing);
          End;

          Canvas.FillRect(rec,color); //Delete rest
     End;
     Canvas.DeleteClipRegion;

     If SizeGrip Then
     Begin
          For T:=0 To 12 Do
          Begin
               Canvas.Pen.color:=clLtGray;
               Canvas.Line(Width-T-1,0,Width-1,T);
               Inc(T);
               Canvas.Pen.color:=clDkGray;
               Canvas.Line(Width-T-1,0,Width-1,T);
               Inc(T);
               Canvas.Pen.color:=clWhite;
               Canvas.Line(Width-T-1,0,Width-1,T);
          End;
     End;
End;

Type
    PPanelItem=^TPanelItem;
    TPanelItem=Record
        Style:TStatusPanelStyle;
        Bevel:TStatusPanelBevel;
        Width:LongInt;
        Alignment:TAlignment;
    End;

Procedure TStatusBar.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   Count:^LongInt;
   Items:PPanelItem;
   Panel:TStatusPanel;
   T:LongInt;
   ps:^String;
Begin
     If ResName = rnStatusPanels Then
     Begin
          Count:=@Data;
          Items:=@Data;
          Inc(Items,4);
          For T:=1 To Count^ Do
          Begin
               Panel:=FPanels.Add;
               ps:=Pointer(Items);
               Panel.Text:=ps^;
               Inc(Items,Length(ps^)+1);
               Panel.Bevel:=Items^.Bevel;
               Panel.Style:=Items^.Style;
               Panel.Alignment:=Items^.Alignment;
               Panel.Width:=Items^.Width;
               Inc(Items,SizeOf(TPanelItem));
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TStatusBar.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Item:TPanelItem;
    Panel:TStatusPanel;
    S:String;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FPanels.Count>0 Then
     Begin
          MemStream.Create;
          T:=FPanels.Count;
          MemStream.Write(T,4);
          For T:=0 To FPanels.Count-1 Do
          Begin
               Panel:=FPanels[T];
               S:=Panel.Text;
               MemStream.Write(S,Length(S)+1);
               Item.Style:=Panel.Style;
               Item.Bevel:=Panel.Bevel;
               Item.Width:=Panel.Width;
               Item.Alignment:=Panel.Alignment;
               MemStream.Write(Item,SizeOf(TPanelItem));
          End;

          Result:=Stream.NewResourceEntry(rnStatusPanels,MemStream.Memory^,MemStream.Size);
          MemStream.Destroy;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: THeaderControl Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function THeaderSection.GetText:String;
Begin
     If FText<>Nil Then Result:=FText^
     Else Result:='';
End;

Procedure THeaderSection.SetText(Const NewValue:String);
Begin
     If FText<>Nil Then
     Begin
          If FText^=NewValue Then Exit;
          FreeMem(FText,Length(FText^)+1);
     End;
     GetMem(FText,Length(NewValue)+1);
     FText^:=NewValue;
     changed(False);
End;

Procedure THeaderSection.SetWidth(NewValue:LongInt);
Begin
     If NewValue<FMinWidth Then NewValue:=FMinWidth;
     If NewValue>FMaxWidth Then NewValue:=FMaxWidth;
     If NewValue=FWidth Then Exit;
     FWidth:=NewValue;
     changed(True);
End;

Function THeaderSection.GetLeft:LongInt;
Var T:LongInt;
    Sections:THeaderSections;
Begin
     Result:=0;
     Sections:=THeaderSections(collection);
     If Sections<>Nil Then For T:=0 To Index-1 Do
     Begin
           Inc(Result,Sections[T].Width);
           If Sections.FHeaderControl<>Nil Then Inc(Result,Sections.FHeaderControl.FSpacing);
     End;
End;

Function THeaderSection.GetRight:LongInt;
Begin
     Result:=Left+Width-1;
End;

Procedure THeaderSection.SetStyle(NewValue:THeaderSectionStyle);
Begin
     If NewValue=FStyle Then Exit;
     FStyle:=NewValue;
     changed(False);
End;

Procedure THeaderSection.SetAlignment(NewValue:TAlignment);
Begin
     If NewValue=FAlignment Then Exit;
     FAlignment:=NewValue;
     changed(False);
End;

Procedure THeaderSection.SetMaxWidth(NewValue:LongInt);
Begin
     If NewValue>10000 Then NewValue:=10000;
     If NewValue<FMinWidth Then NewValue:=FMinWidth;
     FMaxWidth:=NewValue;
     Width:=FWidth;  //Update
End;

Procedure THeaderSection.SetMinWidth(NewValue:LongInt);
Begin
     If NewValue<0 Then NewValue:=0;
     If NewValue>FMaxWidth Then NewValue:=FMaxWidth;
     FMinWidth:=NewValue;
     Width:=FWidth; //Update
End;

Constructor THeaderSection.Create(ACollection:TCollection);
Begin
     FWidth:=100;
     FMinWidth:=0;
     FMaxWidth:=10000;
     FAlignment:=taLeftJustify;
     FStyle:=hsText;
     FAllowClick:=True;
     FAllowSize:=True;
     Inherited Create(ACollection);
End;

Destructor THeaderSection.Destroy;
Begin
     If FText<>Nil Then FreeMem(FText,Length(FText^)+1);

     Inherited Destroy;
End;

Procedure THeaderSection.Assign(Source:TCollectionItem);
Begin
     If Source Is THeaderSection Then
       If Source<>Self Then
     Begin
          FMinWidth:=THeaderSection(Source).MinWidth;
          FMaxWidth:=THeaderSection(Source).MaxWidth;
          FAlignment:=THeaderSection(Source).Alignment;
          FStyle:=THeaderSection(Source).Style;
          FAllowClick:=THeaderSection(Source).AllowClick;
          FAllowSize:=THeaderSection(Source).AllowSize;
          Width:=THeaderSection(Source).Width;
          Text:=THeaderSection(Source).Text;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: THeaderSections Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function THeaderSections.GetItem(Index:LongInt):THeaderSection;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited GetItem(Index);
     Result:=THeaderSection(dummy);
End;

Procedure THeaderSections.SetItem(Index:LongInt;NewValue:THeaderSection);
Begin
     Inherited SetItem(Index,NewValue);
End;

Procedure THeaderSections.Update(Item:TCollectionItem);
Begin
     If FHeaderControl=Nil Then Exit;
     If Item=Nil Then FHeaderControl.Invalidate
     Else FHeaderControl.UpdateHeader(THeaderSection(Item));
End;

Procedure THeaderSections.SetupComponent;
Begin
     Inherited SetupComponent;

     If Owner Is THeaderControl Then FHeaderControl:=THeaderControl(Owner);
     ItemClass:=THeaderSection;
End;

Function THeaderSections.Add:THeaderSection;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited Add;
     Result:=THeaderSection(dummy);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: THeaderControl Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function THeaderControl.GetSections:THeaderSections;
Begin
     If FSections=Nil Then FSections:=FSectionsClass.Create(Self);
     Result:=FSections;
End;

Procedure THeaderControl.SetSections(NewValue:THeaderSections);
Begin
     Sections.Assign(NewValue);
End;

Procedure THeaderControl.UpdateHeader(Header:THeaderSection);
Var T:LongInt;
    rc:TRect;
Begin
     //Get Rectangle For the Panel
     rc:=ClientRect;
     If FSections<>Nil Then
       For T:=0 To FSections.Count-1 Do
       Begin
            If FSections[T]=Header Then break
            Else Inc(rc.Left,FSections[T].Width+FSpacing);
       End;

     rc.Right:=rc.Left+Header.Width-1;
     InvalidateRect(rc);
     Update;
End;


{$HINTS OFF}
Procedure THeaderControl.DrawSectionRect(Const rc:TRect;Pressed:Boolean);
Var  rec:TRect;
     PointsArray:Array[0..5] Of TPoint;
     offs:LongInt;
Begin
     If Pressed Then
     Begin
          rec:=rc;
          Canvas.ShadowedBorder(rec,clDkGray,clDkGray);
     End
     Else
     Begin
          If BevelWidth > 2 Then
          Begin
               offs := BevelWidth-1;
               PointsArray[0] := Point(rc.Left,rc.Bottom);
               PointsArray[1] := Point(rc.Left+offs,rc.Bottom+offs);
               PointsArray[2] := Point(rc.Left+offs,rc.Top-offs);
               PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
               PointsArray[4] := Point(rc.Right,rc.Top);
               PointsArray[5] := Point(rc.Left,rc.Top);
               Canvas.Pen.color := clWhite;
               Canvas.Polygon(PointsArray);
               PointsArray[2] := Point(rc.Right-offs,rc.Bottom+offs);
               PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
               PointsArray[4] := Point(rc.Right,rc.Top);
               PointsArray[5] := Point(rc.Right,rc.Bottom);
               Canvas.Pen.color := clDkGray;
               Canvas.Polygon(PointsArray);
               Canvas.Pen.color := PenColor;
          End
          Else
          If BevelWidth = 2 Then
          Begin
               rec:=rc;
               Canvas.ShadowedBorder(rec,clWhite,clBlack);
               Forms.InflateRect(rec,-1,-1);
               Canvas.ShadowedBorder(rec,clLtGray,clDkGray);
          End
          Else
          If BevelWidth = 1 Then
          Begin
               rec:=rc;
               Canvas.ShadowedBorder(rec,clWhite,clDkGray);
          End;
     End;
End;


Procedure THeaderControl.DrawSection(section:THeaderSection;Const rc:TRect;Pressed:Boolean);
Var
   Align:TAlignment;
   S:String;
   CX,CY,H,W:LongInt;
   rec:TRect;
Begin
  Align:=section.Alignment;
  S:=section.Text;

  Canvas.GetTextExtent(S,CX,CY);

  Case Align Of
     taLeftJustify:
       Begin
         rec.Left:=rc.Left+BevelWidth+2;
       End;
     taRightJustify:
       Begin
         rec.Left:=rc.Right-BevelWidth-2-CX;
       End;
     Else //taCenter
       Begin
         W:=rc.Right-rc.Left;
         rec.Left:=rc.Left+((W-CX) Div 2);
       End;
  End; //Case

  H:=rc.Top-rc.Bottom;
  rec.Bottom:=rc.Bottom+((H-CY) Div 2);
  rec.Right:=rec.Left+CX-1;
  rec.Top:=rec.Bottom+CY-1;

  If Pressed Then Forms.OffsetRect(rec,1,-1);

  Canvas.TextOut(rec.Left,rec.Bottom,S);

  Canvas.ExcludeClipRect(rec);

  DrawSectionRect(rc,Pressed);

  rec:=rc;
  If Pressed Then Forms.InflateRect(rec,-1,-1)
  Else Forms.InflateRect(rec,-BevelWidth,-BevelWidth);
  Canvas.FillRect(rec,color);
End;
{$HINTS ON}


Procedure THeaderControl.Redraw(Const rec:TRect);
Var T:LongInt;
    rc,rc2:TRect;
    section:THeaderSection;
    IsPressed:Boolean;
Begin
     Canvas.Brush.color:=color;
     Canvas.Pen.color:=PenColor;

     rc:=ClientRect;
     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          rc.Right:=rc.Left+section.Width-1;
          If rc.Right>Width-1 Then rc.Right:=Width-1;

          IsPressed:=section=FClickSection;

          rc2:=Forms.IntersectRect(rc,rec);
          If Not Forms.IsRectEmpty(rc2) Then
          Begin
               Canvas.ClipRect:=rc2;

               If section.Style=hsOwnerDraw Then
               Begin
                    If OnDrawSection<>Nil Then OnDrawSection(Self,section,rc,IsPressed)
                    Else DrawSection(section,rc,IsPressed);
               End
               Else DrawSection(section,rc,IsPressed);
          End;

          Inc(rc.Left,section.Width+FSpacing);
     End;

     //Draw rest Bevel
     If FSections<>Nil Then If ((rc.Left<Width)And(FSections.Count>0)) Then
     Begin
          rc.Right:=Width-1;
          rc2:=Forms.IntersectRect(rc,rec);
          If Not Forms.IsRectEmpty(rc2) Then
          Begin
               Canvas.ClipRect:=rc2;

               DrawSectionRect(rc,False);

               Forms.InflateRect(rc,-BevelWidth,-BevelWidth);
               Canvas.FillRect(rc,color);
          End;
     End;


     Canvas.ClipRect:=rec;
     rc:=ClientRect;
     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          rc.Right:=rc.Left+section.Width-1;
          If rc.Right>Width-1 Then rc.Right:=Width-1;

          Canvas.ExcludeClipRect(rc);
          Inc(rc.Left,section.Width+FSpacing);
     End;

     //Draw rest Bevel
     If FSections<>Nil Then If ((rc.Left<Width)And(FSections.Count>0)) Then
     Begin
          rc.Right:=Width-1;
          Canvas.ExcludeClipRect(rc);
     End;


     Canvas.FillRect(rec,color); //Delete rest
     Canvas.DeleteClipRegion;
End;

Type
    PHeaderItem=^THeaderItem;
    THeaderItem=Record
        Style:THeaderSectionStyle;
        Width:LongInt;
        MinWidth,MaxWidth:LongInt;
        AllowClick,AllowSize:Boolean;
        Alignment:TAlignment;
    End;


Procedure THeaderControl.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   Count:^LongInt;
   Items:PHeaderItem;
   section:THeaderSection;
   T:LongInt;
   ps:^String;
Begin
     If ResName = rnHeaders Then
     Begin
          Count:=@Data;
          Items:=@Data;
          Inc(Items,4);
          For T:=1 To Count^ Do
          Begin
               Section:=Sections.Add;
               ps:=Pointer(Items);
               section.Text:=ps^;
               Inc(Items,Length(ps^)+1);
               section.Style:=Items^.Style;
               section.Alignment:=Items^.Alignment;
               section.Width:=Items^.Width;
               section.MinWidth:=Items^.MinWidth;
               section.MaxWidth:=Items^.MaxWidth;
               section.AllowClick:=Items^.AllowClick;
               section.AllowSize:=Items^.AllowSize;
               Inc(Items,SizeOf(THeaderItem));
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function THeaderControl.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Item:THeaderItem;
    section:THeaderSection;
    S:String;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FSections<>Nil Then If FSections.Count>0 Then
     Begin
          MemStream.Create;
          T:=FSections.Count;
          MemStream.Write(T,4);
          For T:=0 To FSections.Count-1 Do
          Begin
               section:=FSections[T];
               S:=section.Text;
               MemStream.Write(S,Length(S)+1);
               Item.Style:=section.Style;
               Item.Width:=section.Width;
               Item.MinWidth:=section.MinWidth;
               Item.MaxWidth:=section.MaxWidth;
               Item.AllowClick:=section.AllowClick;
               Item.AllowSize:=section.AllowSize;
               Item.Alignment:=section.Alignment;
               MemStream.Write(Item,SizeOf(THeaderItem));
          End;

          Result:=Stream.NewResourceEntry(rnHeaders,MemStream.Memory^,MemStream.Size);
          MemStream.Destroy;
     End;
End;

Procedure THeaderControl.SectionClick(section:THeaderSection);
Begin
     If FOnSectionClick<>Nil Then FOnSectionClick(Self,section);
End;

Procedure THeaderControl.SectionResize(section:THeaderSection);
Begin
     If FOnSectionResize<>Nil Then FOnSectionResize(Self,section);
End;

Procedure THeaderControl.SectionTrack(section:THeaderSection;Width:LongInt;State:TSectionTrackState);
Begin
     If FOnSectionTrack<>Nil Then FOnSectionTrack(Self,section,Width,State);
End;

Procedure THeaderControl.SetSpacing(NewValue:LongInt);
Begin
     If NewValue<0 Then NewValue:=0;
     FSpacing:=NewValue;
     Invalidate;
End;

Procedure THeaderControl.SetBevelWidth(NewValue:LongInt);
Begin
     If NewValue<1 Then NewValue:=1;
     If NewValue>20 Then NewValue:=20;
     FBevelWidth:=NewValue;
     Invalidate;
End;

Procedure THeaderControl.SetupComponent;
Begin
     Inherited SetupComponent;

     Align:=alTop;
     color:=clDlgWindow;
     FSectionsClass:=THeaderSections;
     Height:=50;
     FSpacing:=1;
     FSectionTrackState:=tsTrackEnd;
     FBevelWidth:=1;
     HandlesDesignMouse:=True;
     Include(ComponentState,csAcceptsControls);
     FShape:=crDefault;
End;

Destructor THeaderControl.Destroy;
Begin
     If FSections<>Nil Then FSections.Destroy;
     Inherited Destroy;
End;

Procedure THeaderControl.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:THeaderSection;
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button <> mbLeft Then Exit;

     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          If ((section.AllowSize)And(X>section.Right-2)And(X<section.Right+2)) Then
          Begin
               Cursor:=crHSplit;
               FShape:=crHSplit;
               LastMsg.Handled:=True;   {dont pass To Form Editor}
               Canvas.Pen.Mode:=pmNot;
               Canvas.Pen.color:=clBlack;
               FSizeSection:=section;
               FSizeStartX:=section.Right;
               FSizeX:=FSizeStartX;
               Canvas.Line(FSizeX,0,FSizeX,Height);
               MouseCapture:=True;
               Canvas.Pen.Mode:=pmCopy;
               FSectionTrackState:=tsTrackBegin;
               If OnSectionTrack<>Nil Then OnSectionTrack(Self,FSizeSection,FSizeX-FSizeSection.Left,
                                                          FSectionTrackState);
               Exit;
          End;
     End;

     If Designed Then Exit;

     //Test Press
     section:=GetMouseHeader(X,Y);
     If section<>Nil Then If section.AllowClick Then
     Begin
          FClickBase:=section;
          FClickSection:=section;
          UpdateHeader(section);
          MouseCapture:=True;
     End;
End;

Function THeaderControl.GetMouseHeader(X,Y:LongInt):THeaderSection;
Var T:LongInt;
    section:THeaderSection;
Begin
     Result:=Nil;
     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          If ((Y>1)And(Y<Height-1)And(X>section.Left+1)And(X<section.Right-1)) Then
          Begin
               Result:=section;
               Exit;
          End;
     End;
End;

Procedure THeaderControl.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var section:THeaderSection;
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If Button=mbLeft Then
     Begin
          section:=GetMouseHeader(X,Y);
          If section<>Nil Then If section.AllowClick Then
          Begin
               FClickSection:=section;
               UpdateHeader(section);
               SysSleep(20);
               FClickSection:=Nil;
               UpdateHeader(section);
               If OnSectionClick<>Nil Then OnSectionClick(Self,section);
          End;
     End;
End;

Procedure THeaderControl.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var ClickHeader:THeaderSection;
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If Button <> mbLeft Then Exit;

     If FSectionTrackState In [tsTrackBegin,tsTrackMove] Then
     Begin
          LastMsg.Handled:=True; {dont pass To Form Editor}
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.color:=clBlack;
          {Delete old rubberline}
          Canvas.Line(FSizeX,0,FSizeX,Height);
          MouseCapture:=False;
          Cursor:=crDefault;
          FShape:=crDefault;
          Canvas.Pen.Mode:=pmCopy;

          If FSizeX<FSizeSection.Left Then FSizeX:=FSizeSection.Left;

          FSizeSection.Width:=FSizeX-FSizeSection.Left+1;

          FSectionTrackState:=tsTrackEnd;
          If OnSectionTrack<>Nil Then OnSectionTrack(Self,FSizeSection,FSizeSection.Width,
                                                     FSectionTrackState);
          FSizeSection:=Nil;
     End;

     If FClickBase<>Nil Then
     Begin
          ClickHeader:=GetMouseHeader(X,Y);
          MouseCapture:=False;
          If ClickHeader=FClickBase Then //clicked
          Begin
               FClickSection:=Nil;
               FClickBase:=Nil;
               UpdateHeader(ClickHeader);
               If OnSectionClick<>Nil Then OnSectionClick(Self,ClickHeader);
          End
          Else
          Begin
               ClickHeader:=FClickBase;
               FClickSection:=Nil;
               FClickBase:=Nil;
               UpdateHeader(ClickHeader);
          End;
     End;
End;

Procedure THeaderControl.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:THeaderSection;
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If FSectionTrackState In [tsTrackBegin,tsTrackMove] Then
     Begin
          LastMsg.Handled:=True; {dont pass To Form Editor}
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.color:=clBlack;
          {Delete old rubberline}
          Canvas.Line(FSizeX,0,FSizeX,Height);
          {Draw New Line}
          FSizeX:=X;
          If FSizeX<FSizeSection.Left Then FSizeX:=FSizeSection.Left;
          If FSizeX>=Width Then FSizeX:=Width;
          Canvas.Line(FSizeX,0,FSizeX,Height);
          Canvas.Pen.Mode:=pmCopy;

          FSectionTrackState:=tsTrackMove;
          If OnSectionTrack<>Nil Then OnSectionTrack(Self,FSizeSection,FSizeX-FSizeSection.Left,
                                                     FSectionTrackState);
          Exit;
     End
     Else
     Begin
          If FClickBase<>Nil Then
          Begin
               section:=GetMouseHeader(X,Y);
               If section<>FClickSection Then
               Begin
                    If FClickSection<>Nil Then
                    Begin
                         section:=FClickSection;
                         FClickSection:=Nil;
                         If section<>Nil Then UpdateHeader(section);
                    End
                    Else
                    Begin
                         If section=FClickBase Then
                         Begin
                              FClickSection:=section;
                              If FClickSection<>Nil Then UpdateHeader(FClickSection);
                         End;
                    End;
               End;
          End
          Else
          Begin
               If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
               Begin
                    section:=FSections[T];
                    If ((section.AllowSize)And(X>section.Right-2)And(X<section.Right+2)) Then
                    Begin
                         FShape:=crHSplit;
                         {$IFDEF OS2}
                         WinSetPointer(HWND_DESKTOP,Screen.Cursors[FShape]);
                         {$ENDIF}
                         {$IFDEF Win32}
                         SetClassWord(Handle,-12{GCW_HCURSOR},0);
                         SetCursor(Screen.Cursors[FShape]);
                         {$ENDIF}
                         LastMsg.Handled:=True; {dont pass To Form Editor}
                         Exit;
                    End;
               End;
          End;
     End;

     If FShape<>crDefault Then
     Begin
          FShape:=crDefault;

          {$IFDEF OS2}
          WinSetPointer(HWND_DESKTOP,Screen.Cursors[FShape]);
          {$ENDIF}
          {$IFDEF Win32}
          SetClassWord(Handle,-12{GCW_HCURSOR},0);
          SetCursor(Screen.Cursors[FShape]);
          {$ENDIF}
     End;
End;

Procedure THeaderControl.WriteInfoToINI(InfoLine : String);

Var CntrlInfo: String;
    section  : THeaderSection;
    Cou      : LongInt;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiLoadFormINI]) then exit;

  CntrlInfo:=TagINI_HeaderControl;
  if FSections<>nil then
    For Cou:=0 To FSections.Count-1 Do
      Begin
        section:=FSections[Cou];
        CntrlInfo:=CntrlInfo+'C'+tostr(Cou)+'='+toStr(section.Width)+';'
      End;
  CntrlInfo:=CntrlInfo+TagINI_End + InfoLine;

  inherited WriteInfoToINI(CntrlInfo);
End;

Function THeaderControl.ReadInfoFromINI : String;

var TagInfoList: tStringList;
    Cou,ColN   : LongInt;
    Col, ColW  : String;
    section    : THeaderSection;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiSaveToINI]) or
     (SaveLoadInfo=false) then exit;

  result:=inherited ReadInfoFromINI;
  if result='' then exit;

  try
    TagInfoList.Create;
    Result:=getInfoTag(TagINI_HeaderControl, Result, TagInfoList);
    for Cou:=0 to TagInfoList.Count-1 do
      Begin
        Col:=TagInfoList.Strings[Cou];
        if Col='' then continue;
        Split(Col,'=',Col,ColW);
        if Col[1]='C' then
          Begin
            ColN:=StrtoInt(copy(Col,2,5));
            section:=FSections[ColN];
            section.Width:=StrToInt(ColW);
          end;
      End;
  except
  end;
  TagInfoList.Destroy;
End;



Function THeader.GetSectionWidth(Index:LongInt):LongInt;
Begin
     Result:=Sections.Items[Index].Width;
End;

Procedure THeader.SetSectionWidth(Index:LongInt;NewValue:LongInt);
Begin
     Sections.Items[Index].Width:=NewValue;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TMultiColumnListBox Class Implementation                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMultiColumnListBox.Sort(section:Integer);
  Function CurrencyToFloat(s:string):double;
  Var
    i:LongInt;
  Begin
    // Get rid of any non numeric symbols...
    i:=1;
    If s[i]='-' then
      Inc(i);
    While (i<=Length(s)) do
    Begin
      /* gehn
      If ((s[i]<'0') Or (s[i]>'9')) And (s[i]<>'.') then
      */
      If ((s[i]<'0') Or (s[i]>'9')) And (s[i]<>DecimalSeparator) then
        Delete(s,i,1);
      i:=i+1;
    End;
    Try
      Result:=StrToFloat(s);
    Except
      Result:=0.0;
    End;
  End;

Var
  strings:TStringList;

  Function DoCompare(Const S, T: String): Integer;
  Var
    s1,s2,ds1,ds2,tmp: string;
    indx,i:Integer;
    dt1,dt2:TDateTime;
    f1,f2:Extended;
    h1,m1,h2,m2:LongInt;
  Begin
    s1:= S;
    s2:= T;
    // Remove the T/F flag that occupies the first char
    // and remove the bitmap number at the start.
    Delete(s1,1,1);
    Delete(s2,1,1);
    For i:=1 To section Do
    Begin
      indx:=Pos(sep_char,s1);
      if indx>0 then System.Delete(s1,1,indx);
      indx:=Pos(sep_char,s2);
      if indx>0 then System.Delete(s2,1,indx);
    End;
    Try
      ds1:=s1;
      indx:=Pos(sep_char,ds1);
      if indx>0 then System.SubStr(ds1,1,indx-1);
      ds2:=s2;
      indx:=Pos(sep_char,ds2);
      if indx>0 then System.SubStr(ds2,1,indx-1);
      dt1:=StrToDate(ds1);
      dt2:=StrToDate(ds2);
      If dt1<dt2 then
        Result:=1
      Else If dt1>dt2 then
        Result:=-1
      Else
        Result:=0;
    Except
      Try
        If ds1[2]=':' then
        Begin
          tmp:=ds1;
          SubStr(tmp,1,1);
          h1:=StrToInt(tmp);
          tmp:=ds1;
          SubStr(tmp,3,2);
          m1:=StrToInt(tmp);
          If h1=12 then h1:=0;
          tmp:=ds1;
          SubStr(tmp,5,2);
          If CompareText(tmp,'pm')=0 then
            h1:=h1+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else If ds1[3]=':' then
        Begin
          tmp:=ds1;
          SubStr(tmp,1,2);
          h1:=StrToInt(tmp);
          tmp:=ds1;
          SubStr(tmp,4,2);
          m1:=StrToInt(tmp);
          If h1=12 then h1:=0;
          tmp:=ds1;
          SubStr(tmp,6,2);
          If CompareText(tmp,'pm')=0 then
            h1:=h1+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else
          Raise EConvertError.Create('');
        If ds2[2]=':' then
        Begin
          tmp:=ds2;
          SubStr(tmp,1,1);
          h2:=StrToInt(tmp);
          tmp:=ds2;
          SubStr(tmp,3,2);
          m2:=StrToInt(tmp);
          If h2=12 then h2:=0;
          tmp:=ds2;
          SubStr(tmp,5,2);
          If CompareText(tmp,'pm')=0 then
            h2:=h2+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else If ds2[3]=':' then
        Begin
          tmp:=ds2;
          SubStr(tmp,1,2);
          h2:=StrToInt(tmp);
          tmp:=ds2;
          SubStr(tmp,4,2);
          m2:=StrToInt(tmp);
          If h2=12 then h2:=0;
          tmp:=ds2;
          SubStr(tmp,6,2);
          If CompareText(tmp,'pm')=0 then
            h2:=h2+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else
          Raise EConvertError.Create('');
        If h1<h2 then
          Result:=1
        Else If h1>h2 then
          Result:=-1
        Else If m1<m2 then
          Result:=1
        Else If m1>m2 then
          Result:=-1
        Else
          Result:=0;
      Except
        // Then try currency!
        Try
          f1:=CurrencyToFloat(ds1);
          f2:=CurrencyToFloat(ds2);
          If f1<f2 then
            Result:=-1
          Else If f1>f2 then
            Result:=1
          Else
            Raise EConvertError.Create('');
        Except
          // Or a number.
          Try
            f1:=StrToFloat(ds1);
            f2:=StrToFloat(ds2);
            If f1<f2 then
              Result:=-1
            Else If f1>f2 then
              Result:=1
            Else
              Raise EConvertError.Create('');
          Except
            // Then just compare the text!
            Result:=CompareText(s1,s2);
          End;
        End;
      End;
    End;
    If Result=0 then
      Result:=CompareText(S,T);
  End;

  Procedure Exchange(I, J:LongInt);
  Var
    p:Pointer;
  Begin
    strings.Exchange(I,J);
    Try
      p:=BmpList[I];
      BmpList[I]:=BmpList[J];
      BmpList[J]:=p;
    Except
      If BmpList.Count<Items.Count then
        BmpList.Count:=Items.Count;
    End;
  End;

  Procedure Reheap(I, K: LongInt);
  Var
    J: LongInt;
  Begin
    J := I;
    While J Shl 1 < K Do
    Begin
      If DoCompare(strings[J Shl 1 - 1], strings[J Shl 1 + 1 - 1]) > 0 Then J := J Shl 1
      Else J := J Shl 1 + 1;
    End;
    If J Shl 1 = K Then J := K;

    While DoCompare(strings[I - 1], strings[J - 1]) > 0 Do J := J Shr 1;

    Exchange(I - 1, J - 1);
    J := J Shr 1;

    While J >= I Do
    Begin
      Exchange(I - 1, J - 1);
      J := J Shr 1;
    End;
  End;

Var
  I, C: LongInt;
  s:string;
Begin

  strings.Create;
  For I:=0 to Items.Count-1 do
  Begin
    // Save the selected flag to be restored later.
    If Selected[I] then
      strings.AddObject('T'+Items[I],Items.Objects[I])
    Else
      strings.AddObject('F'+Items[I],Items.Objects[I]);
  End;
  C := strings.Count;
  For I := C Shr 1 DownTo 1 Do Reheap(I, C);
  For I := C DownTo 2 Do
  Begin
    Exchange(0, I - 1);
    Reheap(1, I - 1);
  End;
  Items.Clear;
  For I:=0 to strings.Count-1 do
  Begin
    s:=strings[I];
    Delete(s,1,1);
    Items.AddObject(s,strings.Objects[I]);
    Selected[I]:=(strings[I][1]='T');
  End;
  strings.Free;
End;

Procedure TMultiColumnListBox.SetupComponent;
Begin
  Inherited SetupComponent;
  Style:=lbOwnerdrawFixed;
  BmpList:=TList.Create;
  sep_char:='|';
  {Martin}
  {$ifdef win32}
  ItemHeight := Font.Height + 3;
  {$endif}
End;

Destructor TMultiColumnListBox.Destroy;
Begin
  Inherited Destroy;
  BmpList.Free;
End;

Procedure TMultiColumnListBox.Clear;
Begin
  Inherited Clear;
  BmpList.Clear;
End;

Function TMultiColumnListBox.Add(s:string):LongInt;
Begin
  Result:=Items.Add(s);
  If BmpList.Count<Items.Count then
    BmpList.Count:=Items.Count;
End;

Function TMultiColumnListBox.AddObject(s:string;o:TObject):LongInt;
Begin
  BeginUpdate;
  Result:=Items.AddObject(s,o);
  If BmpList.Count<Items.Count then
    BmpList.Count:=Items.Count;
  if o is tBitmap then
    Begin
      SetBitmap(Result, tBitmap(o))
    end;
  EndUpdate;
End;

Procedure TMultiColumnListBox.DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);

Var x,y,y1,cx,cy,cx1,cy1:LONGINT;
    idx,i,scPos :LONGINT;
    s,s1:STRING;
    rec1:TRect;
    bmp:TBitmap;

Begin
  if parent is TMultiColumnList
    then scPos:=TMultiColumnList(parent).HorScrollPos
    else scPos:=0;

  If State * [odSelected] <> []
    Then
      Begin
        Canvas.Pen.color  := clHighlightText;
        Canvas.Brush.color:= clHighlight;
      End
    Else
      Begin
        If Enabled
          then Canvas.Pen.Color := PenColor
          else Canvas.Pen.Color := clDkGray;
        Canvas.Brush.color:= Color;
      End;
  dec(Rec.Top);
  rec.Right:=Width;
  rec.Left:=0;
  Canvas.FillRect(Rec,Canvas.Brush.Color);
  Canvas.Brush.Mode := bmTransparent;

  x := Rec.Left + 2;
  y := Rec.Bottom;
  cx := Rec.Right - x;
  cy := Rec.Top - y;

  {Martin TMultiColumnListBox.DrawItem}
  if (Bmplist <> nil) and (Index < Bmplist.Count)
    then
      begin
        Try
          bmp:=TBitmap(BmpList[Index]);
        Except
          bmp:=Nil;
        End;
      end
    else
      bmp := nil;

  i := 1;
  s := Items.Strings[Index];
  While (i<=sections.Count) And (s<>'') do
    Begin
      idx:=Pos(sep_char,s);
      If idx=0
        Then
          Begin
            s1:=s;
            s:='';
          End
        Else
          Begin
            s1:=s;
            SubStr(s1,1,idx-1);
            Delete(s,1,idx);
          End;
      rec1.top:=rec.top+50;

      If rec1.top<2 then
        Exit;
      rec1.bottom:=rec.bottom;
      If rec1.bottom<2 then
        rec1.bottom:=2;
      rec1.left:=sections.Items[i-1].Left - scPos;
      rec1.right:=sections.Items[i-1].Right - scPos;

      If (i=1) And (bmp<>Nil)
        then
          Begin
            cx1:=bmp.Width;
            cy1:=bmp.Height;
          End
        Else
          Canvas.GetTextExtent(s1,cx1,cy1);
      If sections[i-1].Alignment=taRightJustify
        then
          Begin
            x:=sections[i-1].Right-2-cx1;
          End
        Else
          Begin
            If sections[i-1].Alignment=taLeftJustify
              then x:=sections[i-1].Left+2
              Else x:=(sections[i-1].Left+sections[i-1].Right-cx1)/2+2;
          End;
      y1 := y + ((cy - cy1) Div 2);
      If y1 < Rec.Bottom Then y1 := Rec.Bottom;
      If (i=1) And (bmp<>Nil)
        then Canvas.Draw(x - scPos,y1,bmp)
        Else Canvas.TextRect(rec1,x - scPos,y1,s1);
      i := i + 1;
    End;
{$IFDEF Win32}
// Bei WinXP enstehen beim schnellen bewegen des Horizontal-Scrollbar
// Darstellungsfehler. Mit Syssleep wird der Fehler verringert. (nicht komplett)
// Bei Win98 tritt dieser Fehler nicht auf.
  syssleep(10);
{$ENDIf}
End;

Function TMultiColumnListBox.GetSepChar:string;
Begin
  Result:=sep_char;
End;

Procedure TMultiColumnListBox.SetSepChar(Value:string);
Begin
  sep_char:=Value;
End;

Function TMultiColumnListBox.GetBitmap(Index:LongInt):TBitmap;
Begin
  If (Index<0) Or (Index>=BmpList.Count) then
    Result:=Nil
  Else
    Result:=BmpList[Index];
End;

Procedure TMultiColumnListBox.SetBitmap(Index:LongInt; bmp:TBitmap);
Begin
  If BmpList.Count<Items.Count then
    BmpList.Count:=Items.Count;
  If BmpList.Count>Index then
    BmpList[Index]:=bmp;
End;

Procedure TMultiColumnListBox.SetHeader(s: THeaderSections);
Begin
  sections:=s;
End;

// ------------------- tMultiColumnList ---------------------------

Function tMultiColumnList.GetHorScrollPos : LongInt;

Begin
  Result:=HorScroll.Position;
End;

Function tMultiColumnList.GetValue(field,index:LongInt):string;
Var
  i, p: LongInt;
Begin
  If (index>=List.Items.Count) Or (field<0) Or (index<0) then
    Result:=''
  Else Begin
    Result:=List.Items[index];
    For i:=0 to field-1 do
    Begin
      If Length(Result)>0 then
      Begin
        p:=Pos(List.Separator,Result);
        If p>0 then
          System.Delete(Result,1,p);
      End;
    End;
    If Length(Result)>0 then
    Begin
      p:=Pos(List.Separator,Result);
      If p>0 then
        SubStr(Result,1,p-1);
    End;
  End;
End;

Procedure tMultiColumnList.SetValue(field,index:LongInt;Value:string);
Var
  i, p: LongInt;
  sl,sr,s:string;
Begin
  If (field<sections.Count) And (index<List.Items.Count) And
     (field>=0) And (index>=0) then
  Begin
    sr:=List.Items[index];
    sl:='';
    For i:=0 to field-1 do
    Begin
      p:=Pos(List.Separator,sr);
      If p>0 then
      Begin
        s:=sr;
        System.SubStr(s,1,p-1);
        System.Delete(sr,1,p);
      End;
      sl:=sl+s+List.Separator;
    End;
    p:=Pos(List.Separator,sr);
    If p>0 then
    Begin
      System.Delete(sr,1,p);
      List.Items[Index]:=sl+Value+List.Separator+sr;
    End Else
      List.Items[Index]:=sl+Value;
  End;
End;

Function tMultiColumnList.GetSepChar:string;
Begin
  Result:=List.Separator;
End;

Procedure tMultiColumnList.SetSepChar(Value:string);
Begin
  List.Separator:=Value;
End;

Function tMultiColumnList.GetHint:string;
Begin
  Result:=List.Hint;
End;

Procedure tMultiColumnList.SetHint(Value:string);
Begin
  List.Hint:=Value;
End;

Procedure tMultiColumnList.SetEnabled(Value:Boolean);
Begin
  Fenabled:=Value;
  If Fenabled then
  Begin
    Header.Enabled   :=True;
    List.Enabled     :=True;
    HorScroll.Enabled:=true;
    Header.PenColor:=clBlack;
  End Else
  Begin
    Header.Enabled   :=False;
    List.Enabled     :=False;
    HorScroll.Enabled:=False;
    Header.PenColor:=clDkGray;
  End;
End;

Function tMultiColumnList.GetHeaderHint:string;
Begin
  Result:=Header.Hint;
End;

Procedure tMultiColumnList.SetHeaderHint(Value:string);
Begin
  Header.Hint:=Value;
End;

Function tMultiColumnList.GetShowDragRects:Boolean;
Begin
  Result:=List.ShowDragRects;
End;

Procedure tMultiColumnList.SetShowDragRects(Value:Boolean);
Begin
  List.ShowDragRects:=Value;
End;

Function tMultiColumnList.GetTheFont:TFont;
Begin
  Result:=List.Font;
End;

Procedure tMultiColumnList.SetTheFont(Value:TFont);
Begin
  List.Font:=Value;
  Header.Font:=Value;
End;

Function tMultiColumnList.GetSections:THeaderSections;
Begin
  Result := Header.sections;
End;

//gehn
Function tMultiColumnList.GetSectionsCount:LongInt;
Begin
  Result := GetSections.Count;
End;

//gehn
Function tMultiColumnList.GetSectionsItem(Index:LongInt):THeaderSection;
Begin
  If (Index < 0) or (Index > GetSectionsCount-1) then
    Begin
      Result := Nil;
    End
  else
    Begin
      Result := Header.Sections.Items[Index];
    End;
End;
//gehn
Procedure tMultiColumnList.SetSectionsItemText(Index:LongInt; NewText:String);
Var
  SectionsItem: THeaderSection;
Begin
  If (Index > 0) or (Index < GetSectionsCount-1) then
  Begin
    SectionsItem := GetSectionsItem(Index);
    SectionsItem.Text := NewText;
    Header.Sections.Items[Index] := SectionsItem;
  End;
End;

Procedure tMultiColumnList.SetSections(Value:THeaderSections);
Begin
  Header.sections := Value;
End;

Function tMultiColumnList.GetDuplicates:Boolean;
Begin
  Result:=List.Duplicates;
End;

Procedure tMultiColumnList.SetDuplicates(Value:Boolean);
Begin
  List.Duplicates:=Value;
End;

Function tMultiColumnList.GetExtendedSelect:Boolean;
Begin
  Result:= List.ExtendedSelect;
End;

Procedure tMultiColumnList.SetExtendedSelect(Value:Boolean);
Begin
  List.ExtendedSelect:= Value;
End;

Function tMultiColumnList.GetItemIndex:LongInt;
Begin
  Result:= List.ItemIndex;
End;

Procedure tMultiColumnList.SetItemIndex(Value:LongInt);
Begin
  List.ItemIndex:= Value;
End;

Function tMultiColumnList.GetMultiSelect:Boolean;
Begin
  Result:= List.MultiSelect;
End;

Procedure tMultiColumnList.SetMultiSelect(Value:Boolean);
Begin
  List.MultiSelect:= Value;
End;

Function tMultiColumnList.GetOnItemFocus:TItemFocusEvent;
Begin
  Result:= List.OnItemFocus;
End;

Procedure tMultiColumnList.SetOnItemFocus(Value:TItemFocusEvent);
Begin
  List.OnItemFocus:= Value;
End;

Function tMultiColumnList.GetOnItemSelect:TItemSelectEvent;
Begin
  Result:= List.OnItemSelect;
End;

Procedure tMultiColumnList.SetOnItemSelect(Value:TItemSelectEvent);
Begin
  List.OnItemSelect:= Value;
End;

Function tMultiColumnList.GetSelCount:LongInt;
Begin
  Result:= List.SelCount;
End;

Function tMultiColumnList.GetSelected(Index:LongInt):Boolean;
Begin
  Result:= List.Selected[Index];
End;

Procedure tMultiColumnList.SetSelected(Index:LongInt;Value:Boolean);
Begin
  List.Selected[Index]:= Value;
End;

Function tMultiColumnList.GetBitmap(Index:LongInt):TBitmap;
Begin
  Result:=List.Bitmaps[Index];
End;

Procedure tMultiColumnList.SetBitmap(Index:LongInt; bmp:TBitmap);
Begin
  List.Bitmaps[Index]:=bmp;
End;

Function tMultiColumnList.GetObjects(Index:LongInt):TObject;
Begin
  Result:=List.Items.Objects[Index];
End;

Procedure tMultiColumnList.SetObjects(Index:LongInt;Value:TObject);
Begin
  List.Items.Objects[Index]:=Value;
End;

Function tMultiColumnList.GetCount;
Begin
  Result:=List.Items.Count;
End;

Procedure tMultiColumnList.EvSectionPressed(sender: THeaderControl; section: THeaderSection);
Begin
  Sort(section.Index);
End;

Procedure tMultiColumnList.EvSectionTrack(sender: THeaderControl; section: THeaderSection; width: LongInt; State:TSectionTrackState);
Begin
  If state = tsTrackEnd then Invalidate;
  Resize;
End;

Procedure tMultiColumnList.EvScroll(Sender: TObject; ScrollCode: TScrollCode; Var ScrollPos: LongInt);

Begin
  Invalidate;
  Header.Left:=-ScrollPos;
End;

Procedure tMultiColumnList.SetupComponent;
Begin
  Inherited SetupComponent;

  Name:='MultiColumnList';
  Width:=150;
  Height:=150;
  ParentPenColor := True;
  ParentColor := True;
  ParentFont := True;
  TabStop := False;

  Header.Create(Self);
  Header.Align:=alNone;
  Header.parent:=Self;
  Header.SetWindowPos(0, Height-25, Width, 25);

  Header.OnSectionClick:=EvSectionPressed;
  Header.OnSectionTrack:=EvSectionTrack;
  Header.ParentFont:=True;
  Header.TabStop:=False;

  HorScroll.Create(Self);
  HorScroll.Kind      := sbHorizontal;
  HorScroll.Align     := alFixedLeftBottom;
  HorScroll.Parent    := Self;
  HorScroll.ParentFont:= True;
  HorScroll.SetWindowPos(0, 0, Width- goSysInfo.Screen.VScrollSize, goSysInfo.Screen.HScrollSize);

  HorScroll.TabStop   := False;
  HorScroll.OnScroll  := EvScroll;

  List.Create(Self);
  List.SetHeader(Header.Sections);
  List.parent    := Self;
  List.height    := height-24-goSysInfo.Screen.HScrollSize;
  List.top       := Header.height;
  List.ParentFont:= True;
  List.OnDragDrop:= EvDragDrop;
  List.OnCanDrag := EvCanDrag;
  List.OnDragOver:= EvDragOver;
  List.TabStop   := True;
  List.Align     := alFixedLeftBottom;
{$IFDEF Win32}
  List.OnDblClick:= evOnDblClick;
{$ENDIF}

  If Designed Then
    Begin
      Include(List.ComponentState, csDetail);
      Include(Header.ComponentState, csDetail);
      Include(HorScroll.ComponentState, csDetail);
    End;
End;

Procedure tMultiColumnList.SetupShow;
Begin
  Inherited SetupShow;

  Resize;
End;

Procedure tMultiColumnList.Resize;

Var Cou: LongInt;
    Mx : LongInt;
    lw : LongInt;

Begin
  Inherited Resize;

  List.SetWindowPos(0, goSysInfo.Screen.HScrollSize+1,
                       width, height-24-goSysInfo.Screen.HScrollSize);

  HorScroll.Width := Width-goSysInfo.Screen.HScrollSize;
  mx:=0;
  try
    For Cou:=0 To Header.Sections.Count-2 Do
      mx:=mx+Header.Sections[Cou].Width;
    lw:=Header.Sections[Cou].Width;
  except
    mx:=Width;
    lw:=0;
  end;

  HorScroll.Min :=0;
  HorScroll.Max :=Mx;

  Header.SetWindowPos(Header.Left, Height-25, Mx+lw, 25);

End;

Constructor tMultiColumnList.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  Fenabled:=True;
End;

Destructor tMultiColumnList.Destroy;
Begin
  Inherited Destroy;
End;

Function tMultiColumnList.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
  Result := Inherited WriteSCUResource(Stream);
  If Not Result Then Exit;
  Result := List.WriteSCUResource(Stream);
  If Not Result Then Exit;
  Result := Header.WriteSCUResource(Stream);
End;

Procedure tMultiColumnList.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
  List.ReadSCUResource(ResName,Data,DataLen);
  Header.ReadSCUResource(ResName,Data,DataLen);
  Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure tMultiColumnList.SelectAll;
Var
  i:LongInt;
Begin
  List.BeginUpdate;
  For i:=0 to List.Items.Count-1 do
    Selected[i]:=True;
  List.EndUpdate;
End;

Procedure tMultiColumnList.DeselectAll;
Var
  i:LongInt;
Begin
  List.BeginUpdate;
  For i:=0 to List.Items.Count-1 do
    Selected[i]:=False;
  List.EndUpdate;
End;

Function tMultiColumnList.Add(s:string):LongInt;
Begin
  Result:=List.Add(s);
End;

Function tMultiColumnList.AddObject(s:string;o:TObject):LongInt;
Begin
  Result:=List.AddObject(s,o);
End;

Procedure tMultiColumnList.Delete(Index:LongInt);
Begin
  List.Items.Delete(Index);
End;

Procedure tMultiColumnList.Clear;
Begin
  List.Clear;
End;

Function tMultiColumnList.ItemRect(Index:LongInt):TRect;
Begin
  Result:=List.ItemRect(Index);
End;

Procedure tMultiColumnList.SetDragMode(Value:TDragMode);
Begin
  drag_mode:=Value;
  List.DragMode:=Value;
End;

Procedure tMultiColumnList.EvCanDrag(sender: TObject; X,Y: LongInt; var Accept: Boolean);
Begin
  If OnCanDrag<>Nil then
    OnCanDrag(Self,X,Y,Accept);
End;

Procedure tMultiColumnList.EvDragDrop(sender: TObject; source: TObject; X,Y: LongInt);
Begin
  If OnDragDrop<>Nil then
    OnDragDrop(Self,source,X,Y);
End;

Procedure tMultiColumnList.EvDragOver(sender: TObject; source: TObject; X,Y: LongInt; State: TDragState; var Accept: Boolean);
Begin
  If OnDragOver<>Nil then
    OnDragOver(Self,source,X,Y,state,Accept);
End;

Function tMultiColumnList.IsDraggedSourceMe(source: TObject):Boolean;
Begin
  Result:=(source=Self) Or (source=List);
End;

Procedure tMultiColumnList.Sort(section:Integer);
Begin
  List.Sort(section);
End;

Function tMultiColumnList.IndexOf(s:string):LongInt;
Begin
  Result:=List.Items.IndexOf(s);
End;

Procedure tMultiColumnList.BeginUpdate;
Begin
  List.BeginUpdate;
End;

Procedure tMultiColumnList.EndUpdate;
Begin
  List.EndUpdate;
End;

Function tMultiColumnList.GetListItems:TStrings;               // TB 11-Aug-2005
Begin
  Result := Listbox.Items;
End;

Procedure tMultiColumnList.SetListItems(AStrings:TStrings);    // TB 11-Aug-2005
Begin
  If AStrings <> Listbox.Items Then Listbox.Items.Assign(AStrings);
End;

{$IFDEF Win32}
Procedure tMultiColumnList.EvOnDblClick (Sender: TObject);
Begin
  if OnDblClick<>nil then
    OnDblClick(Self);
End;
{$ENDIF}

Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Nov-03  WD         Delay-Funktion mit SysSleep ausgetauscht
  03-Jul-05  TB         TUpDown.SetAssociate: because FPosition may be <> FMin set
  08-Aug-05  MV/WD      TUpDownBtn.Redraw: Wurden keine Dreiecke angezeigt.
  11-Aug-05  TB/WD      Komponente in das Projekt hinzugefuegt.
  18-Aug-05  WD         Horizontaler-Scrollbalken eingebaut.
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  13-Nov-05  WD         tMultiColumnList/Win32: Korrekte Verarbeitung von DblClick.
  10-Jul-06  WD         TMultiColumnListBox.AddObject: Korrekter Verarbeitung bei Bitmaps
  12-Nov-06  WD         THeaderControl.WriteInfoToINI: Ueberpruefen ob fSection<>nil ist.
  16-Jan-07  MV         TMultiColumnListBox.DrawItem: Kleiner Fix bei dem Bitmaps
  22-Apr-07  RG, WD     Komponente tGauge eingebaut.
  12-Mai-09  PE         TGauge.PaintAsText: Positionsangabe fr Windows korregiert.
}
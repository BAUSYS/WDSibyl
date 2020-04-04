
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
        

Unit Forms;
                 
Interface

{$B-}                   

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmGpi,PmDev,PmStdDlg,PmBitmap,PmHelp,PmShl,
     PMWin;            
{$ENDIF}        

{$IFDEF Win32}
Uses WinDef,WinBase,WinNt,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Classes,Messages,SysUtils,Color,Graphics,ClipBrd,IniFiles, Menus,
     uList,      { Diverse List-Objekte }
     uString,    { Diverse String-Deklarationen und -Funktionen }
     uSysInfo,   { Diverse Systeminformationen }
     uSysClass,  { Diverse System-Klasssen}
     uLanguage;  { Sprach-Untersttzung }

Const
    {Caret Timer values for use with BlinkTime}
{$M+}
    ctNormal           = 500;
    ctFast             = 100;
{$M-}
                  
// Default-Parameter
Const paramWDSibylIDE = '-WDSIBYLIDE';  // Damit weiss das Programm, dass es von der IDE gestartet worden ist.
      paramLog        = '-LOG';         // Logging einschalten
      paramLanguage   = '-LNG';         // Sprache vorgeben

Const WDSibylPasWndTxt= 'WDSibyl-Pascal Window';

// Konstanten fuer die  diverse Cursors
{$R Cursors}

Type
{$M+}
    TCursor       = LongInt;    // predefined mouse Cursor constants

Const
{$IFDEF OS2}
    ListCursorsPtCount = 6;
{$ENDIF}
{$IFDEF Win32}
    ListCursorsPtCount = 1;
{$ENDIF}

Const crDefault     = TCursor(0);
      crNone        = TCursor(-1);
      crArrow       = TCursor(-2);
      crCross       = TCursor(-3);
      crIBeam       = TCursor(-4);
      crSize        = TCursor(-5);
      crSizeNESW    = TCursor(-6);
      crSizeNS      = TCursor(-7);
      crSizeNWSE    = TCursor(-8);
      crSizeWE      = TCursor(-9);
      crUpArrow     = TCursor(-10);
      crHourGlass   = TCursor(-11);
      crDrag        = TCursor(-12);
      crNoDrop      = TCursor(-13);
      crHSplit      = TCursor(-14);
      crVSplit      = TCursor(-15);
      crMultiDrag   = TCursor(-16);
      crSQLWait     = TCursor(-17);
      crNo          = TCursor(-18);
      crAppStart    = TCursor(-19);
      crHelp        = TCursor(-20);
      crSizeNW      = TCursor(-21);
      crSizeSE      = TCursor(-22);
      crSizeNE      = TCursor(-23);
      crSizeSW      = TCursor(-24);
      crHand        = TCursor(-25);
Type
    {Standard Class styles}
    TClassStyles=Set Of (wcsSizeRedraw,wcsHitTest,
                         wcsFrame,wcsClipChildren,wcsClipSiblings,
                         wcsParentClip,wcsSaveBits,wcsSyncPaint,wcsOwnDC);

    {Window Class Record}
    TClassData=Record
         StandardClass:Boolean;
         ClassName:Cstring;
         WindowProc:Pointer;
         ClassStyle:TClassStyles;
         DataCount:LongWord;
         ClassULong:LongWord; {only used For OS/2 }
    End;

{$M+}
    {Toolbar alignments}
    TToolbarAlign=(tbLeft,tbRight,tbTop,tbBottom);

    TToolbarAlignments=Set Of TToolbarAlign;

    TToolBarBevel=(tbRaised,tbLowered,tbNone);
{$M-}

    {Toolbar Forward}
    TToolbar=Class;
    TToolBarClass=Class Of TToolbar;

    {Control Forward}
    TControl=Class;
    TControlClass=Class Of TControl;

    {Form Forward}
    TForm=Class;
    TFormClass=Class Of TForm;

    {Timer Forward}
    TTimer=Class;
    TTimerClass=Class Of TTimer;

    TTimer=Class(TComponent)
      Private
         FId:LongInt;
         FRunning:Boolean;
         FTime:LongInt;
         FInterval:LongInt;
         FOnTimer:TNotifyEvent;
      Protected
         Procedure SetupComponent;Override;
         Procedure Timer;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Start;
         Procedure Stop;
         Property Id:LongInt Read FId;
         Property Running:Boolean Read FRunning;
         Property Time:LongInt Read FTime Write FTime;
      Published
         Property Interval:LongInt Read FInterval Write FInterval;
         Property OnTimer:TNotifyEvent Read FOnTimer Write FOnTimer;
    End;

    TCaret=Class
      Private
         FLeft,FBottom,FWidth,FHeight:LongInt;
         FCreated:Boolean;
         FBlinkTime:LongInt;
         FOldBlinkTime:LongInt;
         FControl:TControl;
         Procedure SetBlinkTime(ms:LongInt);
      Public
         Constructor Create(Owner:TControl);Virtual;
         Procedure SetPos(Left,Bottom:LongInt);
         Procedure SetSize(Width,Height:LongInt);
         Procedure Show;
         Procedure Hide;
         Procedure Remove;
         Property Left:LongInt Read FLeft Write FLeft;
         Property Bottom:LongInt Read FBottom Write FBottom;
         Property Width:LongInt Read FWidth Write FWidth;
         Property Height:LongInt Read FHeight Write FHeight;
         Property Created:Boolean Read FCreated Write FCreated;
         Property BlinkTime:LongInt Read FBlinkTime Write SetBlinkTime;
    End;


{$M+}
    TScrollCode=(scLineUp,scLineDown,scPageUp,scPageDown,
                 scColumnLeft,scColumnRight,scPageLeft,scPageRight,
                 scHorzTrack,scVertTrack,scHorzPosition,scVertPosition,
                 scHorzEndScroll,scVertEndScroll);

    TDragMode=(dmManual,dmAutomatic);
    TDragState=(dsDragEnter,dsDragMove,dsDragLeave);

    TDragDropSourceType=(drtSibyl,drtSibylObject,drtText,drtBinData,drtString);
    TDragDropRenderType=(drmSibyl,drmSibylObject,drmSibylFile,drmPrint,drmFile,drmString);
    TDragDropOperation=(doDefault,doCopy,doMove,doLink,doUnknown);
    TDragDropSupportedOps=Set Of(doCopyable,doMoveable,doLinkable);

    PDragDropData=^TDragDropData;
    {$M+}
    TDragDropData=Record
    {$M-}
         SourceWindow:HWindow;
         SourceType:TDragDropSourceType;
         RenderType:TDragDropRenderType;
         SourceString:String;
         RenderString:String;
         ContainerName:String;
         SourceFileName:String;
         TargetFileName:String;
         SupportedOps:TDragDropSupportedOps;
         DragOperation:TDragDropOperation;
         ItemId:LongWord;
    End;

    TExternalDragDropObject=Class(TComponent)
      Private
         FDragDropData:TDragDropData;
      Public
         Property SourceWindow:HWindow Read FDragDropData.SourceWindow;
         Property SourceType:TDragDropSourceType Read FDragDropData.SourceType;
         Property RenderType:TDragDropRenderType Read FDragDropData.RenderType;
         Property SourceString:String Read FDragDropData.SourceString;
         Property RenderString:String Read FDragDropData.RenderString;
         Property ContainerName:String Read FDragDropData.ContainerName;
         Property SourceFileName:String Read FDragDropData.SourceFileName;
         Property TargetFileName:String Read FDragDropData.TargetFileName;
         Property SupportedOps:TDragDropSupportedOps Read FDragDropData.SupporteDops;
         Property DragOperation:TDragDropOperation Read FDragDropData.DragOperatIon;
         Property ItemId:LongWord Read FDragDropData.ItemId;
         Property DragDropData:TDragDropData read FDragDropData write FDragDropData;
    End;
{$M-}

    {ScrollbarControl Forward}
    TScrollBar=Class;
    TScrollBarClass=Class Of TScrollBar;

{$M+}
    {Standard mouse Button states}
    TMouseButton=(mbRight,mbLeft,mbMiddle);

    TShiftState=Set Of (ssShift,ssAlt,ssCtrl,ssRight,ssLeft,ssMiddle,ssDouble);


    {TControl event types}
    TCommandEvent=Procedure(Sender:TObject;Var Command:TCommand) Of Object;
    TKeyPressEvent=Procedure(Sender:TObject;Var key:Char) Of Object;
    TScanEvent=Procedure(Sender:TObject;Var KeyCode:TKeyCode) Of Object;
    TMouseEvent=Procedure(Sender:TObject;Button:TMouseButton;
         Shift:TShiftState;X,Y:LongInt) Of Object;
    TMouseMoveEvent=Procedure(Sender:TObject;Shift:TShiftState;
         X,Y:LongInt) Of Object;
    TPaintEvent=Procedure(Sender:TObject;Const rec:TRect) Of Object;

    TCanDragEvent=Procedure(Sender:TObject;X,Y:LongInt;Var Accept:Boolean) Of Object;
    TStartDragEvent=Procedure(Sender:TObject;Var DragData:TDragDropData) Of Object;
    TEndDragEvent=Procedure(Sender:TObject;target:TObject;X,Y:LongInt) Of Object;
    TDragOverEvent=Procedure(Sender:TObject;Source:TObject;X,Y:LongInt;
         State:TDragState;Var Accept:Boolean) Of Object;
    TDragDropEvent=Procedure(Sender:TObject;Source:TObject;X,Y:LongInt) Of Object;

    TMenuEvent=Procedure(Sender:TObject;AMenu:TMenu;entry:TMenuItem) Of Object;


    TScrollStyle=(ssNone,ssHorizontal,ssVertical,ssBoth);

    {Text Alignment constants}
    TAlignment=(taLeftJustify,taRightJustify,taCenter);

    {Alignment constants}
    TAlign=(alNone,alTop,alBottom,alLeft,alRight,alClient,alFrame,alScale,
         alCenter,alCenterX,alCenterY,
         alFixedLeftTop,alFixedLeftBottom,alFixedRightTop,alFixedRightBottom);

    {X Alignment constants}
    TXAlign=(xaNone,xaParent,xaLeft,xaRight,xaCenter);

    {Y Alignment constants}
    TYAlign=(yaNone,yaParent,yaBottom,yaTop,yaCenter);

    {X stretching constants}
    TXStretch=(xsNone,xsParent,xsFrame,xsScale,xsFixed);

    {Y stretching constants}
    TYStretch=(ysNone,ysParent,ysFrame,ysScale,ysFixed);

    TZOrder=(zoNone,zoBottom,zoTop);
{$M-}

    TMouseParam=Record
         pt:TPoint;
         Button:TMouseButton;
         ShiftState:TShiftState;
    End;

    TKeyParam=Record
         KeyCode:TKeyCode;
         RepeatCount:Byte;
    End;

    TDesignerNotifyCode=(dncMouseDown,dncMouseUp,dncMouseClick,
                         dncMouseDblClk,dncMouseMove,dncChar,dncScan,
                         dncPaint,dncSCUModified,dncNewMenuItem,
                         dncPropertyUpdate);

    TDesignerNotifyStruct=Record
         Sender:TComponent;
         Code:TDesignerNotifyCode;
         return:LongInt;
         Case TDesignerNotifyCode Of
             dncMouseDown,
             dncMouseUp,
             dncMouseClick,
             dncMouseDblClk,
             dncMouseMove:        (mouseparam:TMouseParam);
             dncChar,dncScan:     (keyparam:TKeyParam);
             dncPaint:            (rec:TRect);
    End;


    TCreateParams=Record
         Style:LongInt;
         ExStyle:LongInt;
         FrameStyle:LongInt;
    End;


    PScaleInfo=^TScaleInfo;
    TScaleInfo=Record
         Left,Right,Bottom,Top:Extended;
    End;

    PFrameInfo=^TFrameInfo;
    TFrameInfo=Record
         Left,Right,Bottom,Top:LongInt;
    End;


    TLastMsg=Class
      Private
         FControl:TControl;
         Function GetHandled:LongBool;
         Procedure SetHandled(Value:LongBool);
         Function GetResult:LongWord;
         Procedure SetResult(Value:LongWord);
      Public
         Procedure CallDefaultHandler;
         Property Handled:LongBool Read GetHandled Write SetHandled;
         Property Result:LongWord Read GetResult Write SetResult;
    End;

    {$M+}
    TControlState = Set Of (csLButtonDown, csClicked, csPalette,
                            csReadingState, csAlignmentNeeded, csFocusing, csCreating,
                            csPaintCopy,csWindowDestroying);

    TControlStyle = Set Of (csCaptureMouse,csFramed,csFixedWidth,csFixedHeight,
                            csDisplayDragImage,csHintWindow);
    {$M-}

    TCloseQueryEvent=Procedure(Sender:TObject;Var CanClose:Boolean) Of Object;

    TSizeConstraints=Class(TComponent)
        Private
           FMaxHeight,FMaxWidth:LongInt;
           FMinHeight,FMinWidth:LongInt;
           FOnChange:TNotifyEvent;

           Procedure SetMaxHeight(NewValue:LongInt);
           Procedure SetMaxWidth(NewValue:LongInt);
           Procedure SetMinHeight(NewValue:LongInt);
           Procedure SetMinWidth(NewValue:LongInt);
           Function GetControl:TControl;
           Procedure Change;
        Protected
           Procedure SetupComponent;Override;
        Public
           Property Control:TControl read GetControl;
           Property Name;
           Property Tag;
        Published
           Property MaxHeight:LongInt read FMaxHeight write SetMaxHeight;
           Property MaxWidth:LongInt read FMaxWidth write SetMaxWidth;
           Property MinHeight:LongInt read FMinHeight write FMinHeight;
           Property MinWidth:LongInt read FMinWidth write FMinWidth;
           Property OnChange:TNotifyEvent read FOnChange write FOnChange;
    End;

    TControl=Class(TComponent)
      Private
         FControlState:TControlState;
         FControlStyle:TControlStyle;
         FParent:TControl;
         FControls:TList;
         FWindowId:LongWord;
         FDefWndProc:TWndProc;
         FCursor:TCursor;
         FHandle:HWindow;
         FCanvas:TCanvas;
         FInitCanvas:Boolean;
         FCaption:PString;
         FFrame:TControl;
         FLeft,FBottom,FWidth,FHeight:LongInt;
         FXAlign:TXAlign;
         FYAlign:TYAlign;
         FXStretch:TXStretch;
         FYStretch:TYStretch;
         FZOrder:TZOrder;
         FPenColor:TColor;
         FColor:TColor;
         FHasFocus:Boolean;
         FIsToolBar:Boolean;
         {$IFDEF Win32}
         FClickTime:LongInt;
         FLastLButtonDownTime:LongInt;
         FLastRButtonDownTime:LongInt;
         FDefFontHandle:LongWord;
         FCtlBrush:LongWord;
         {$ENDIF}
         FFont:TFont;
         FEnabled:Boolean;
         FVisible:Boolean;
         FCursorTabStop:Boolean;
         FTabStop:Boolean;
         FTabOrder:LongInt;
         FTabList:TList;
         FForm:TForm;
         FHint:PString;
         FShowHint:Boolean;
         FParentShowHint:Boolean;
         FParentFont:Boolean;
         FParentPenColor:Boolean;
         FParentColor:Boolean;
         FUpdateEnabled:Boolean;
         FOldEnabledState:Boolean;
         FHelpContext:THelpContext;
         FHelpContextString:string;   // Martin
         FAutoScale:PScaleInfo;
         FAutoFrame:PFrameInfo;
         FLastDeadKey:Word;
         FInitControls:Boolean;
         FFirstShow:Boolean;
         FOwnerDraw:Boolean;
         FHandlesDesignMouse:Boolean;
         FHandlesDesignKey:Boolean;
         FCommand:TCommand;
         FModalParent:TControl;
         FUpdatingPP:Boolean;
         FDragMode:TDragMode;
         FDragState:TDragState;
         FDragControl:TControl;
         FDragging:Boolean;
         FDragCursor:TCursor;
         FLastDragOperation:TDragDropOperation;
         {$IFDEF OS2}
         FDragInfo:PDRAGINFO;
         FDragCanvas:TCanvas;
         {$ENDIF}
         FAlternateFontName:PString;
         FCtl3d:Boolean;
         FMouseCapture:Boolean;
         FLastMsg:TLastMsg;
         FLastMsgAdr:PMessage;
         FReplaceMnemoEnabled:Boolean;
         FFontChangeEnabled:Boolean;
         FStandardControl:Boolean;
         FPopupMenu:TPopupMenu;
         FConstraints:TSizeConstraints;

// Event-Variable
         FOnEnter:TNotifyEvent;
         FOnExit:TNotifyEvent;
         FOnKeyPress:TKeyPressEvent;
         FOnScan:TScanEvent;
         FOnMouseDown:TMouseEvent;
         FOnMouseMove:TMouseMoveEvent;
         FOnMouseUp:TMouseEvent;
         FOnMouseClick:TMouseEvent;
         FOnMouseDblClick:TMouseEvent;
         FOnResize:TNotifyEvent;
         FOnMove:TNotifyEvent;
         FOnPaint:TPaintEvent;
         FOnBeforePaint,FOnAfterPaint:TPaintEvent;
         FOnCommand:TCommandEvent;
         FOnSetupShow:TNotifyEvent;
         FOnShow:TNotifyEvent;
         FOnHide:TNotifyEvent;
         FOnCanDrag:TCanDragEvent;
         FOnStartDrag:TStartDragEvent;
         FOnEndDrag:TEndDragEvent;
         FOnDragOver:TDragOverEvent;
         FOnDragDrop:TDragDropEvent;
         FOnFontChange:TNotifyEvent;
         FOnClick:TNotifyEvent;
         FOnDblClick:TNotifyEvent;
         FOnCloseQuery:TCloseQueryEvent;
      Private
         {$IFDEF OS2}
         Procedure WMBeginDrag(Var Msg:TMessage); Message WM_BEGINDRAG;
         Procedure WMEndDrag(Var Msg:TMessage); Message WM_ENDDRAG;
         Procedure DMDragOver(Var Msg:TMessage); Message DM_DRAGOVER;
         Procedure DMDragLeave(Var Msg:TMessage); Message DM_DRAGLEAVE;
         Procedure DMDrop(Var Msg:TMessage); Message DM_DROP;
         Procedure WMControl(Var Msg:TMessage); Message WM_CONTROL;
         Procedure WMButton1Down(Var Msg:TWMButton1Down); Message WM_BUTTON1DOWN;
         Procedure WMButton2Down(Var Msg:TWMButton2Down); Message WM_BUTTON2DOWN;
         Procedure WMSize(Var Msg:TWMSize); Message WM_SIZE;
         Procedure WMMove(Var Msg:TWMMove); Message WM_MOVE;
         Procedure WMPaint(Var Msg:TMessage); Message WM_PAINT;
         Procedure WMEraseBackGround(Var Msg:TMessage); Message WM_ERASEBACKGROUND;
         Procedure WMPresParamChanged(Var Msg:TMessage); Message WM_PRESPARAMCHANGED;
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         Procedure WMQueryConvertPos(Var Msg:TMessage); Message WM_QUERYCONVERTPOS;
         Procedure WMCommand(Var Msg:TWMCommand); Message WM_COMMAND;
         Procedure WMSetFocus(Var Msg:TWMSetFocus); Message WM_SETFOCUS;
         Procedure WMButton1Up(Var Msg:TWMButton1Up); Message WM_BUTTON1UP;
         Procedure WMButton2Up(Var Msg:TWMButton2Up); Message WM_BUTTON2UP;
         Procedure WMButton1Click(Var Msg:TWMButton1Click); Message WM_BUTTON1CLICK;
         Procedure WMButton1DblClk(Var Msg:TWMButton1DblClk); Message WM_BUTTON1DBLCLK;
         Procedure WMButton2Click(Var Msg:TWMButton2Click); Message WM_BUTTON2CLICK;
         Procedure WMButton2DblClk(Var Msg:TWMButton2DblClk); Message WM_BUTTON2DBLCLK;
         Procedure WMMouseMove(Var Msg:TWMMouseMove); Message WM_MOUSEMOVE;
         Procedure WMHScroll(Var Msg:TWMScroll); Message WM_HSCROLL;
         Procedure WMVScroll(Var Msg:TWMScroll); Message WM_VSCROLL;
         Procedure WMDestroy(Var Msg:TWMDestroy); Message WM_DESTROY;
         Procedure WMCaptureFocus(Var Msg:TMessage); Message WM_CAPTUREFOCUS;
         Procedure WMHelp(Var Msg:TMessage); Message WM_HELP;
         Procedure WMMeasureItem(Var Msg:TMessage); Message WM_MEASUREITEM;
         Procedure WMDrawItem(Var Msg:TMessage); Message WM_DRAWITEM;
         {$ENDIF}
         {$IFDEF Win32}
         Procedure WMButton1Down(Var Msg:TWMButton1Down); Message WM_LBUTTONDOWN;
         Procedure WMButton2Down(Var Msg:TWMButton2Down); Message WM_RBUTTONDOWN;
         Procedure WMSize(Var Msg:TWMSize); Message WM_SIZE;
         Procedure WMMove(Var Msg:TWMMove); Message WM_MOVE;
         Procedure WMPaint(Var Msg:TMessage); Message WM_PAINT;
         Procedure WMEraseBackGround(Var Msg:TMessage); Message WM_ERASEBKGND;
         Procedure WMCommand(Var Msg:TWMCommand); Message WM_COMMAND;
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         Procedure WMKillFocus(Var Msg:TMessage); Message WM_KILLFOCUS;
         Procedure WMSetFocus(Var Msg:TWMSetFocus); Message WM_SETFOCUS;
         Procedure WMButton1Up(Var Msg:TWMButton1Up); Message WM_LBUTTONUP;
         Procedure WMButton2Up(Var Msg:TWMButton2Up); Message WM_RBUTTONUP;
         Procedure WMButton1DblClk(Var Msg:TWMButton1DblClk); Message WM_LBUTTONDBLCLK;
         Procedure WMButton2DblClk(Var Msg:TWMButton2DblClk); Message WM_RBUTTONDBLCLK;
         Procedure WMKeyDown(Var Msg:TMessage); Message WM_KEYDOWN;
         Procedure WMSysKeyDown(Var Msg:TMessage); Message WM_SYSKEYDOWN;
         Procedure WMMouseMove(Var Msg:TWMMouseMove); Message WM_MOUSEMOVE;
         Procedure WMSetCursor(Var Msg:TMessage); Message WM_SETCURSOR;
         Procedure WMHScroll(Var Msg:TWMScroll); Message WM_HSCROLL;
         Procedure WMVScroll(Var Msg:TWMScroll); Message WM_VSCROLL;
         Procedure WMCtlColorBtn(Var Msg:TMessage); Message WM_CTLCOLORBTN;
         Procedure WMCtlColorStatic(Var Msg:TMessage); Message WM_CTLCOLORSTATIC;
         Procedure WMCtlColorDlg(Var Msg:TMessage); Message WM_CTLCOLORDLG;
         Procedure WMCtlColorScrollBar(Var Msg:TMessage); Message WM_CTLCOLORSCROLLBAR;
         Procedure WMCtlColorEdit(Var Msg:TMessage); Message WM_CTLCOLOREDIT;
         Procedure WMCtlColorListBox(Var Msg:TMessage); Message WM_CTLCOLORLISTBOX;
         Procedure WMDestroy(Var Msg:TWMDestroy); Message WM_DESTROY;
         Procedure WMNCDestroy(Var Msg:TMessage); Message WM_NCDESTROY;
         Procedure WMCaptureFocus(Var Msg:TMessage); Message WM_CAPTUREFOCUS;
         Procedure WMNotify(Var Msg:TMessage); Message WM_NOTIFY;
         Procedure WMMeasureItem(Var Msg:TMessage); Message WM_MEASUREITEM;
         Procedure WMDrawItem(Var Msg:TMessage); Message WM_DRAWITEM;
         {$ENDIF}

         Function GetControlState:TControlState;
         Function GetControlStyle:TControlStyle;
         Procedure SetControlState(NewValue:TControlState);
         Procedure SetControlStyle(NewValue:TControlStyle);
         Procedure SendScanMessage(Var Msg:TWMChar;Var KeyCode:TKeyCode;RepeatCount:Byte);
         Procedure SendCharMessage(Var Msg:TWMChar;Var CH:Char;RepeatCount:Byte);
         Function GetDesignerCoordinates(Var pt:TPoint):TControl;
         Function GetControlCount:LongInt;
         Function GetControl(AIndex:LongInt):TControl;
         Procedure SetColor(NewColor:TColor);Virtual;
         Procedure SetPenColor(NewColor:TColor);Virtual;
         Procedure SetParentFont(Value:Boolean);
         Procedure SetParentPenColor(Value:Boolean);
         Procedure SetParentColor(Value:Boolean);
         Procedure ParentFontChanged(Var Msg:TMessage); Message CM_PARENTFONTCHANGED;
         Procedure ParentPenColorChanged(Var Msg:TMessage); Message CM_PARENTPENCOLORCHANGEd;
         Procedure ParentColorChanged(Var Msg:TMessage); Message CM_PARENTCOLORCHANGED;
         Function GetWindowRect:TRect;
         Procedure SetWindowRect(Const rec:TRect);
         Function GetBoundsRect:TRect;
         Procedure SetBoundsRect(Const rec:TRect);
         Function GetClientRect:TRect;Virtual;
         Function GetClientWidth:LongInt;
         Function GetClientHeight:LongInt;
         Procedure SetClientWidth(NewWidth:LongInt);Virtual;
         Procedure SetClientHeight(NewHeight:LongInt);Virtual;
         Function GetClientOrigin:TPoint;Virtual;
         Function GetParentClientWidth:LongInt;
         Function GetParentClientHeight:LongInt;
         Procedure SetWidth(NewWidth:LongInt);
         Function GetWidth:LongInt;
         Procedure SetHeight(NewHeight:LongInt);Virtual;
         Function GetHeight:LongInt;
         Procedure SetLeft(NewLeft:LongInt);Virtual;
         Function GetLeft:LongInt;Virtual;
         Procedure SetBottom(NewBottom:LongInt);Virtual;
         Function GetBottom:LongInt;Virtual;
         Procedure SetTop(NewTop:LongInt);Virtual;
         Function GetTop:LongInt;
         Procedure SetRight(NewRight:LongInt);Virtual;
         Function GetRight:LongInt;
         Procedure SetAlign(NewAlign:TAlign);
         Function GetAlign:TAlign;
         Procedure SetXAlign(NewAlign:TXAlign);
         Function GetXAlign:TXAlign;
         Procedure SetYAlign(NewAlign:TYAlign);
         Function GetYAlign:TYAlign;
         Procedure SetXStretch(NewStretch:TXStretch);
         Function GetXStretch:TXStretch;
         Procedure SetYStretch(NewStretch:TYStretch);
         Function GetYStretch:TYStretch;
         Procedure SetZOrder(zo:TZOrder);
         Procedure Enable;
         Procedure Disable;
         Function IsWindowVisible:Boolean;
         Function GetShowing:Boolean;
         Function GetVisible:Boolean;
         Procedure SetVisible(NewState:Boolean);
         Function GetTabOrder:LongInt;Virtual;
         Procedure SetTabOrder(Value:LongInt);
         Function GetWindowFlags:LongWord;
         Procedure SetHint(Const NewText:String);
         Function GetHint:String;
         Procedure SetShowHint(Value:Boolean);
         Function GetShowHint:Boolean;
         Procedure SetMouseCapture(captive:Boolean);
         Procedure SetUpdateEnabled(Value:Boolean);
         Procedure SetParent(AParent:TControl);
         {$IFDEF Win32}
         Procedure SetCtlColor(Var Msg:TMessage);
         {$ENDIF}
         Procedure Insert(AChild:TControl);
         Procedure Remove(AChild:TControl);
         Function GetNextTabControl:TControl;
         Function GetPrevTabControl:TControl;
         Procedure FocusTabControl(Next:Boolean);
         Procedure FocusKeyControl(KeyCode:TKeyCode);
         Function GetLastMsg:TLastMsg;
         {$IFDEF OS2}
         Function SetPPForeGroundColor(AColor:TColor):Boolean;
         Function SetPPBackGroundColor(AColor:TColor):Boolean;
         {$ENDIF}
         Procedure DragFinished(target:TObject; X,Y:LongInt; Accepted:Boolean);
         Procedure DragFree;
         Procedure SetPopupMenu(NewMenu:TPopupMenu);
         Function GetStandardFont:TFont;Virtual;
         Procedure DoSetFocus;
         Procedure DoKillFocus;
         Procedure DoChangeFocus(Value:Boolean;otherfocuswin:Longword);Virtual;
      Protected
         Procedure SetEnabled(NewState:Boolean); Virtual;
         Procedure SetCursor(Index:TCursor); Virtual;
         Function GetEnabled:Boolean; Virtual;
         Procedure SetText(Const NewCaption:String);Virtual;
         Function GetText:String;Virtual;
         Procedure SetFont(NewFont:TFont);Virtual;
         Procedure DefaultHandler(Var Msg);Override;
         Procedure WndProc(Var Msg:TMessage);Virtual;
         Procedure UpdateWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Virtual;
         Procedure Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:Longint);Virtual;
         Function QueryConvertPos(Var Pos:TPoint):Boolean;Virtual;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Virtual;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Virtual;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongINt);Virtual;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Virtual;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Virtual;
         Procedure MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInT);Virtual;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LonGInT);Virtual;
         Procedure CheckMenuPopup(pt:TPoint);Virtual;
         Procedure Resize;Virtual;
         Procedure Move;Virtual;
         Procedure SetFocus;Virtual;
         Procedure KillFocus;Virtual;
         Procedure Paint(Const rec:TRect);Virtual;
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Virtual;
         Procedure GetClassData(Var ClassData:TClassData);Virtual;
         {$IFDEF Win32}
         {Martin0106}RememberMBshiftState : tShiftState;
         Procedure CreateSubClass(Var ClassData:TClassData;Const ControlClassName:Cstring);
         {$ENDIF}
         Procedure RegisterClass;Virtual;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure SetupShow;Virtual;
         Procedure CreateError;Virtual;
         Procedure CreateWnd;Virtual;
         Procedure RecreateWnd;Virtual;
         Procedure CreateControls;Virtual;
         Procedure DisposeWnd;Virtual;
         Procedure DestroyWnd;Virtual;
         Procedure DestroyHandle;Virtual;
         Procedure RealignControls;Virtual;
         Procedure CommandEvent(Var Command:TCommand);Virtual;
         Procedure ParentNotification(Var Msg:TMessage);Virtual;
         Function EvaluateShortCut(KeyCode:TKeyCode):Boolean;Virtual;
         Procedure CanDrag(X,Y:LongInt;Var Accept:Boolean);Virtual;
         Procedure DoStartDrag(Var DragData:TDragDropData);Virtual;
         Procedure DoEndDrag(target:TObject; X,Y:LongInt);Virtual;
         Procedure DragCanceled;Virtual;
         Procedure DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);Virtual;
         Procedure NotifyControls(MsgId:ULONG);
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Function HasParent:Boolean;Override;
         Function CanFocus:Boolean;Virtual;
         Property FontChangeEnabled:Boolean read FFontChangeEnabled write FFontChangeEnabled;
      Public
         {$IFDEF OS2}
         Function SetPPFontNameSize(Const FNS:String):Boolean;
         {$ENDIF}
         Procedure DesignerNotification(Var DNS:TDesignerNotifyStruct);Virtual;
         Procedure ScaleBy(CX,CY:LongInt);
         Procedure UpdateFont;
         Procedure FontChange;Virtual;
         Procedure ScrollBy(DeltaX,DeltaY:LongInt);
         Function ContainsControl(Control: TControl):Boolean;
         Function ControlAtPos(Const Pos:TPoint;AllowDisabled:Boolean):TControl;
         Procedure GetTabOrderList(List:TList);
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure BeginDrag(Immediate:Boolean); virtual; {dummy Parameter}
         Procedure DragDrop(Source:TObject;X,Y:LongInt);Virtual;
         Procedure CreateDragCanvas;
         Procedure DeleteDragCanvas;
         Destructor Destroy;Override;
         Procedure Show;Virtual;
         Procedure Hide;Virtual;
         Procedure BringToFront;Virtual;
         Procedure SendToBack;Virtual;
         Procedure InsertControl(AChild:TControl);Virtual;
         Procedure RemoveControl(AChild:TControl);Virtual;
         Procedure DestroyControls;
         Function CreateCanvas:TCanvas;Virtual;
         Procedure Redraw(Const rec:TRect);Virtual;
         Procedure Refresh;
         Procedure Repaint;
         Procedure Update;Virtual;
         Procedure Invalidate;Virtual;
         Procedure InvalidateRect(Const rec:TRect);
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Virtual;
         Procedure SetBounds(NewLeft,NewTop,NewWidth,NewHeight:LongInt);Virtual;
         Procedure Focus;Virtual;
         Procedure CaptureFocus;
         Function Focused:Boolean;
         Function Perform(MsgId:ULONG;mp1,mp2:LONG):LONG;
         Procedure BroadCast(Var Msg:TMessage);
         Function GetControlFromPoint(pt:TPoint):TControl;
         Function ClientToScreen(Const Point:TPoint):TPoint;
         Function ScreenToClient(Const Point:TPoint):TPoint;
         Procedure MapPoints(target:TControl;Var pts:Array Of TPoint);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInT);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;

         Procedure WriteInfoToINI(InfoLine : String); Override;
         Function ReadInfoFromINI : String; Override;
         Procedure RefreshLanguage; Virtual;
      Protected
         Property DragState:TDragState read FDragState write FDragState;
         Property CursorTabStop:Boolean Read FCursorTabStop Write FCursorTabStop;
         Property DefWndProc:TWndProc Read FDefWndProc Write FDefWndProc;
         Property Form:TForm Read FForm;
         Property HandlesDesignKey:Boolean Read FHandlesDesignKey Write FHandlesDesignKey;
         Property HandlesDesignMouse:Boolean Read FHandlesDesignMouse Write FHandlesDeSignMouse;
         Property LastDragOperation:TDragDropOperation Read FLastDragOperation;
         Property LastMsg:TLastMsg Read GetLastMsg;
         Property Ownerdraw:Boolean Read FOwnerDraw Write FOwnerDraw;
         Property ReplaceMnemoEnabled:Boolean Read FReplaceMnemoEnabled Write FReplaceMnemoEnabled;

         Property Color:TColor Read FColor Write SetColor;
         Property Command:TCommand Read FCommand Write FCommand;
         Property DragCursor:TCursor Read FDragCursor Write FDragCursor;
         Property DragMode:TDragMode Read FDragMode Write FDragMode;
         Property Font:TFont Read FFont Write SetFont;
         Property ParentColor:Boolean Read FParentColor Write SetParentColor;
         Property ParentFont:Boolean Read FParentFont Write SetParentFont;
         Property ParentPenColor:Boolean Read FParentPenColor Write SetParentPenColor;
         Property ParentShowHint:Boolean Read FParentShowHint Write FParentShowHint;
         Property PenColor:TColor Read FPenColor Write SetPenColor;
         Property PopupMenu:TPopupMenu Read FPopupMenu Write SetPopupMenu;
         Property Text:String Read GetText Write SetText;
         Property ZOrder       : TZOrder Read FZOrder Write SetZOrder;

         Property OnCanDrag:TCanDragEvent Read FOnCanDrag Write FOnCanDrag;
         Property OnKeyPress:TKeyPressEvent Read FOnKeyPress Write FOnKeyPress;
         Property OnCommand:TCommandEvent Read FOnCommand Write FOnCommand;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
         Property OnDblClick:TNotifyEvent Read FOnDblClick Write FOnDblClick;
         Property OnDragDrop:TDragDropEvent Read FOnDragDrop Write FOnDragDrop;
         Property OnDragOver:TDragOverEvent Read FOnDragOver Write FOnDragOver;
         Property OnEndDrag:TEndDragEvent Read FOnEndDrag Write FOnEndDrag;
         Property OnEnter:TNotifyEvent Read FOnEnter Write FOnEnter;
         Property OnExit:TNotifyEvent Read FOnExit Write FOnExit;
         Property OnFontChange:TNotifyEvent Read FOnFontChange Write FOnFontChange;
         Property OnHide:TNotifyEvent Read FOnHide Write FOnHide;
         Property OnMouseClick:TMouseEvent Read FOnMouseClick Write FOnMouseClick;
         Property OnMouseDblClick:TMouseEvent Read FOnMouseDblClick Write FOnMouseDblCLick;
         Property OnMouseDown:TMouseEvent Read FOnMouseDown Write FOnMouseDown;
         Property OnMouseMove:TMouseMoveEvent Read FOnMouseMove Write FOnMouseMove;
         Property OnMouseUp:TMouseEvent Read FOnMouseUp Write FOnMouseUp;
         Property OnMove:TNotifyEvent Read FOnMove Write FOnMove;
         Property OnPaint:TPaintEvent Read FOnPaint Write FOnPaint;
         Property OnResize:TNotifyEvent Read FOnResize Write FOnResize;
         Property OnScan:TScanEvent Read FOnScan Write FOnScan;
         Property OnSetupShow:TNotifyEvent Read FOnSetupShow Write FOnSetupShow;
         Property OnShow:TNotifyEvent Read FOnShow Write FOnShow;
         Property OnStartDrag:TStartDragEvent Read FOnStartDrag Write FOnStartDrag;
      Public
         Property Align:TAlign Read GetAlign Write SetAlign;
         Property BoundsRect:TRect Read GetBoundsRect write SetBoundsRect;
         Property Canvas:TCanvas Read FCanvas;
         Property ClientHeight:LongInt Read GetClientHeight Write SetClientHeight;
         Property ClientOrigin:TPoint Read GetClientOrigin;
         Property ClientRect:TRect Read GetClientRect;
         Property ClientWidth:LongInt Read GetClientWidth Write SetClientWidth;
         Property ControlCount:LongInt Read GetControlCount;
         Property Controls[Index:LongInt]:TControl Read GetControl;
         Property Dragging:Boolean Read FDragging;
         Property Enabled:Boolean Read GetEnabled Write SetEnabled;
         Property Handle:HWindow Read FHandle;
         Property WindowId:LongWord read FWindowId;
         Property HasFocus:Boolean Read FHasFocus write FHasFocus;
         Property MouseCapture:Boolean Read FMouseCapture Write SetMouseCapture;
         Property OnBeforePaint:TPaintEvent Read FOnBeforePaint Write FOnBeforePaint;
         Property OnAfterPaint:TPaintEvent Read FOnAfterPaint Write FOnAfterPaint;
         Property Parent:TControl Read FParent Write SetParent;
         Property Showing:Boolean Read GetShowing;
         Property TabOrder:LongInt Read GetTabOrder Write SetTabOrder;
         Property TabStop:Boolean Read FTabStop Write FTabStop;
         Property UpdateEnabled:Boolean Read FUpdateEnabled Write SetUpdateEnabled;
         Property Visible:Boolean Read GetVisible Write SetVisible;
         Property WindowRect:TRect Read GetWindowRect write SetWindowRect;
         Property XAlign:TXAlign Read GetXAlign Write SetXAlign;
         Property XStretch:TXStretch Read GetXStretch Write SetXStretch;
         Property YAlign:TYAlign Read GetYAlign Write SetYAlign;
         Property YStretch:TYStretch Read GetYStretch Write SetYStretch;
         Property ControlState: TControlState read GetControlState write SetControlState;
         Property ControlStyle: TControlStyle read GetControlStyle write SetControlStyle;
         Property StandardFont:TFont read GetStandardFont;
         Property ShowHint:Boolean Read FShowHint Write SetShowHint;
      Published
         Property Caption:String Read GetText Write SetText;
         Property Bottom:LongInt Read GetBottom Write SetBottom;
         Property Height:LongInt Read GetHeight Write SetHeight;
         Property HelpContext:THelpContext Read FHelpContext Write FHelpContext;
         Property HelpContextString:string Read FHelpContextString Write FHelpContextString;  // Martin
         Property Hint:String Read GetHint Write SetHint;
         Property Left:LongInt Read GetLeft Write SetLeft;
         Property Cursor:TCursor Read FCursor Write SetCursor;
         Property Right:LongInt Read GetRight Write SetRight; Stored False;
         Property Top:LongInt Read GetTop Write SetTop; Stored False;
         Property Width:LongInt Read GetWidth Write SetWidth;
         Property OnCloseQuery:TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
         Property Ctl3d:Boolean Read FCtl3d Write FCtl3d;
         Property Constraints:TSizeConstraints read FConstraints write FConstraints; stored False;
    End;

    TGraphicControl=Class(TControl)
      Protected
         Property Canvas;
    End;

    {$M+}
    TSizeBorderEvent=Procedure(Sender:TObject;Var SizeDelta:LongInt) Of Object;
    TSizeBorderAlign=(baVertical,baHorizontal,baTop,baBottom,baLeft,baRight,
                      baParentWidth,baParentHeight,
                      baHorizontalSizing, baVerticalSizing);
    {$M-}

    TSizeBorder=Class(TControl)
      Private
         FBorderAlign:TSizeBorderAlign;
         FSizing:Boolean;
         FOffs:LongInt;
         FDelta:LongInt;
         OldFgMode:TPenMode;
         OldLineWidth:LongInt;
         OldLineType:TPenStyle;
         FOnSizing:TSizeBorderEvent;
         FOnSized:TSizeBorderEvent;
         Procedure SetBorderAlign(Value:TSizeBorderAlign);
         Procedure DrawSizeLine;
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Property Hint;
         Property Cursor;
      Public
         Procedure Redraw(Const rec:TRect);Override;
      Published
         Property BorderAlign:TSizeBorderAlign Read FBorderAlign Write SetBorderAliGn;
         Property OnSized:TSizeBorderEvent Read FOnSized Write FOnSized;
         Property OnSizing:TSizeBorderEvent Read FOnSizing Write FOnSizing;
    End;


    TToolbar=Class(TControl)
      Private
         FAlignment:TToolbarAlign;
         FBevelStyle:TToolBarBevel;
         FSizeable:Boolean;
         FOrder:LongInt;
         SizeBorderCtrl:TSizeBorder;
         Procedure SetAlignment(NewAlign:TToolbarAlign);
         Procedure SetBevelStyle(NewStyle:TToolBarBevel);
         Procedure SetSize(NewSize:LongInt);
         Function GetSize:LongInt;
         Function GetLeft:LongInt;Override;
         Function GetBottom:LongInt;Override;
         Procedure SetLeft(NewLeft:LongInt);Override;
         Procedure SetBottom(NewBottom:LongInt);Override;
         Procedure SetTop(NewTop:LongInt);Override;
         Procedure SetRight(NewRight:LongInt);Override;
         Procedure SetSizeable(Value:Boolean);
         Procedure SetOrder(Value:LongInt);
         Function GetOrder:LongInt;
         Procedure EvBorderSizing(Sender:TObject;Var SizeDelta:LongInt);
         Procedure EvBorderSized(Sender:TObject;Var SizeDelta:LongInt);
      Protected
         IsMenuBar:Boolean;
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure SetupShow;Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Procedure EnableCommands(Cmds:Array Of TCommand);   {raus}
         Procedure DisableCommands(Cmds:Array Of TCommand);  {raus}
         Procedure Hide;Override;
         Procedure Show;Override;
         Property Bottom;
         Property Height;
         Property Left;
         Property Right;
         Property Top;
         Property Width;
      Published
         Property Alignment:TToolbarAlign Read FAlignment Write SetAlignment;
         Property Color;
         Property BevelStyle:TToolBarBevel Read FBevelStyle Write SetBevelStyle;
         Property Enabled;
         Property PenColor;
         Property Font;
         Property HelpContext;
         Property Order:LongInt Read GetOrder Write SetOrder; Stored False;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowHint;
         Property Size:LongInt Read GetSize Write SetSize;
         Property Sizeable:Boolean Read FSizeable Write SetSizeable;

         Property OnClick;
         Property OnDblClick;
         Property OnCommand;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnResize;
         Property OnSetupShow;
    End;


{$M+}
    TScrollBarKind=(sbHorizontal,sbVertical);

    TScrollEvent=Procedure(Sender:TObject;ScrollCode:TScrollCode;
                             Var ScrollPos:LongInt) Of Object;
{$M-}
    TScrollBarInc=1..32767;

    TScrollingWinControl=Class;

    TScrollBar=Class(TControl)
      Private
         lastpos:LongInt;
         FMin:LongInt;
         FMax:LongInt;
         FSliderSize:LongInt;
         FCalcRange:LongInt;
         FPosition:LongInt;
         FScale:Extended;
         FSmallChange:TScrollBarInc;
         FLargeChange:TScrollBarInc;
         FKind:TScrollBarKind;
         FOnScroll:TScrollEvent;
         FOnChange:TNotifyEvent;
         FControl:TScrollingWinControl;
         FAllowFocus:Boolean;
         Procedure SetPosition(NewPosition:LongInt);
         Procedure SetMin(NewMin:LongInt);
         Procedure SetMax(NewMax:LongInt);
         Procedure SetSliderSize(NewSliderSize:LongInt);
         Procedure SetKind(NewKind:TScrollBarKind);
         Procedure SetPenColor(NewColor:TColor);Override;
         Procedure SetColor(NewColor:TColor);Override;
      Protected
         Procedure SetupComponent;Override;
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure SetupShow;Override;
         Function CanFocus:Boolean;Override;
      Public
         Procedure SetScrollRange(aMin,aMax,aSliderSize:LongInt);
         Procedure SetParams(aPosition,aMin,aMax:LongInt);
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
         Property AllowFocus:Boolean read FAllowFocus write FAllowFocus;
      Published
         Property Align;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Kind:TScrollBarKind Read FKind Write SetKind;
         Property LargeChange:TScrollBarInc Read FLargeChange Write FLargeChange;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property ParentShowHint;
         Property PopupMenu;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property ShowHint;
         Property SliderSize:LongInt Read FSliderSize Write SetSliderSize;
         Property SmallChange:TScrollBarInc Read FSmallChange Write FSmallChange;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseMove;
         Property OnScan;
         Property OnScroll:TScrollEvent Read FOnScroll Write FOnScroll;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TControlScrollBar=Class(TScrollBar)
      Public
         Procedure SetupComponent;Override;
      Public
         Property Align;
         Property Bottom;
         Property Cursor;
         Property Left;
         Property Right;
         Property Top;
         Property HelpContext;
         Property Name;
         Property Tag;
         Property Width;
         Property Height;
         Property Hint;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Kind;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseMove;
         Property OnScan;
         Property OnScroll;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TScrollingWinControl=Class(TControl)
      Private
         FScrollBars:TScrollStyle;
         FHorzScrollBar:TControlScrollBar;
         FVertScrollBar:TControlScrollBar;
         FAutoScroll:Boolean;
         FHMin,FVMin:LongInt;
         FHMax,FVMax:LongInt;
         FHPos,FVPos:LongInt;
         FHLargeChange,FVLargeChange:LongInt;
         FHSmallChange,FVSmallChange:LongInt;
         FHColor,FVColor:LongInt;
         FHSliderSize,FVSliderSize:LongInt;
         FIgnoreAdjust:Boolean;
         Procedure SetScrollBars(NewValue:TScrollStyle);
         Procedure SetAutoScroll(NewValue:Boolean);
         Procedure AlignScrollbars;
         Procedure AdjustScrollbars;
      Protected
         Procedure Resize;Override;
         Procedure Paint(Const rec:TRect);Override;
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:Longint);Override;
         Procedure Loaded;Override;
      Public
         Destructor Destroy;Override;
         Procedure ScrollInView(AControl:TControl);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure InsertControl(AChild:TControl);Override;
         Procedure RemoveControl(AChild:TControl);Override;
      Public
         Property AutoScroll:Boolean read FAutoScroll write SetAutoScroll;
         Property HorzScrollBar:TControlScrollBar Read FHorzScrollBar;
         Property VertScrollBar:TControlScrollBar Read FVertScrollBar;
         Property ScrollBars:TScrollStyle Read FScrollBars Write SetScrollBars;
    End;


    {$M+}
    TFormBorderStyle=(bsNone,bsSingle,bsSizeable,bsDialog,bsToolWindow,
                      bsSizeToolWin);
    TBorderStyle=bsNone..bsSingle;
    {$M-}

    TScrollBox=Class(TScrollingWinControl)
      Private
        FBorderStyle:TBorderStyle;
        Procedure SetBorderStyle(NewValue:TBorderStyle);
      Protected
        Procedure SetupComponent;Override;
      Public
        Procedure Redraw(Const rec:TRect);Override;
      Published
        Property Align;
        Property Cursor;
        Property Tag;
        Property AutoScroll;
        Property BorderStyle:TBorderStyle read FBorderStyle write SetBorderStyle;
        Property DragCursor;
        Property DragMode;
        Property Enabled;
        Property Color;
        Property Font;
        Property HorzScrollBar; stored False;
        Property VertScrollBar; stored False;
        Property ParentColor;
        Property ParentFont;
        Property ParentShowHint;
        Property PopupMenu;
        Property ShowHint;
        Property TabOrder;
        Property TabStop;
        Property Visible;
        Property ZOrder;
        Property OnClick;
        Property OnCanDrag;
        Property OnKeyPress;
        Property OnDblClick;
        Property OnDragDrop;
        Property OnDragOver;
        Property OnEndDrag;
        Property OnEnter;
        Property OnExit;
        Property OnMouseDown;
        Property OnMouseMove;
        Property OnMouseUp;
        Property OnResize;
        Property OnPaint;
        Property OnScan;
        Property OnShow;
    End;


{$M+}
    TCloseAction=(caNone,caHide,caFree,caMinimize,caFreeHandle);

    TWindowState=(wsNormal,wsMinimized,wsMaximized);

    TBorderIcon=(biSystemMenu,biMinimize,biMaximize,biHelp,biClose);
    TBorderIcons=Set Of TBorderIcon;

    TFormStyle=(fsNormal,fsMDIChild,fsMDIForm);

    TTileMode=(tbHorizontal,tbVertical,tbNormal);

    TCloseEvent=Procedure(Sender:TObject;Var Action:TCloseAction) Of Object;
    TTranslateShortCutEvent=Procedure(Sender:TObject;KeyCode:TKeyCode;Var ReceiveR:TforM) Of object;

    tFormInfoINI = (fiNone, fiSaveToINI, fiLoadFormINI, fiSaveLoadINI);
{$M-}


    TPosition=(poDesigned,poDefault,poDefaultPosOnly,poDefaultSizeOnly,poScreenCenter);

    TModalResult=TCommand;

    TForm=Class(TScrollingWinControl)
      Private
         FLanguageSupport : Boolean;
         FMainMenu:TMainMenu;
         FLastMenu:TMenu;
         FLastEntry:TMenuItem;
         FMenuHandleList:TList;
         FAccelList:TList;
         FAccel:LongWord;
         FShortCutsEnabled:Boolean;
         FIsModal:Boolean;
         FModalShowing:Boolean;
         FModalResult:TModalResult;
         FLocked:Boolean;
         FWindowState:TWindowState;
         FBorderIcons:TBorderIcons;
         FBorderStyle:TFormBorderStyle;
         FFormStyle:TFormStyle;
         FTileMode:TTileMode;
         FEnableDocking:TToolbarAlignments;
         FMoveable:Boolean;
         FSizeable:Boolean;
         FActiveControl:TControl;
         FMDIChildren:TList;
         FMDIZOrder:TList; {last child is on top}
         FToolBarLists:Array[TToolbarAlign] Of TList;
         FIcon:TGraphic;
         FInternalWindowIdCount:LongWord;
         FDBCSStatusLine:Boolean;
         DefaultButton:TControl;
         CancelButton:TControl;

         FPosition:TPosition;
         FOnActivate:TNotifyEvent;
         FOnDeactivate:TNotifyEvent;
         FOnClose:TCloseEvent;
         FOnDismissDlg:TNotifyEvent;
         FOnMenuInit:TMenuEvent;
         FOnMenuEnd:TMenuEvent;
         FOnMenuItemFocus:TMenuEvent;
         FOnTranslateShortCut:TTranslateShortCutEvent;
         FOnMinimize:TNotifyEvent;
         FOnMaximize:TNotifyEvent;
         FOnRestore:TNotifyEvent;
         FOnCreate:TNotifyEvent;
         FOnDestroy:TNotifyEvent;
         FMenuBar:TToolBar;
         Procedure CMRelease(Var Msg:TMessage); Message CM_RELEASE;
         Procedure CMEndModalState(Var Msg:TMessage); Message CM_ENDMODALSTATE;
         Procedure CMUpdateButtons(Var Msg:TMessage); Message CM_UPDATEBUTTONS;
         Procedure WMActivate(Var Msg:TWMActivate); Message WM_ACTIVATE;
         {$IFDEF OS2}
         Procedure WMClose(Var Msg:TWMClose); Message WM_CLOSE;
         Procedure WMInitMenu(Var Msg:TMessage); Message WM_INITMENU;
         Procedure WMMenuEnd(Var Msg:TMessage); Message WM_MENUEND;
         Procedure WMMenuSelect(Var Msg:TMessage); Message WM_MENUSELECT;
         Procedure WMTranslateAccel(Var Msg:TMessage); Message WM_TRANSLATEACCEL;
         Procedure WMDDEInitiate(Var Msg:TMessage); Message WM_DDE_INITIATE;
         Procedure WMDDEDestroy(Var Msg:TMessage); Message WM_DDE_DESTROY;
         {$ENDIF}
         Function GetFrameFlags:LongWord;
         Function GetMDIChildCount:LongInt;
         Function GetMDIChild(AIndex:LongInt):TForm;
         Procedure SetWindowState(NewState:TWindowState);
         Function GetWindowState:TWindowState;
         Procedure SetBorderIcons(NewIcons:TBorderIcons);
         Procedure SetBorderStyle(NewStyle:TFormBorderStyle);
         Function GetTabOrder:LongInt;Override;
         Function GetAddWidth:LongInt;
         Function GetAddHeight:LongInt;
         Function GetClientRect:TRect;Override;
         Procedure SetClientWidth(NewWidth:LongInt);Override;
         Procedure SetClientHeight(NewHeight:LongInt);Override;
         Function GetClientOrigin:TPoint;Override;
         Procedure SetDBCSStatusLine(Value:Boolean);
         Procedure SetActiveControl(AControl:TControl);
         Procedure ForwardShortCut(Var Msg:TMessage);
         Procedure SetIcon(NewIcon:TGraphic);
         Function GetIcon:TGraphic;
         Procedure IconChanged(Sender:TObject);
         Procedure SetMainMenu(AMenu:TMainMenu);
         Procedure SetShortCutsEnabled(Value:Boolean);
         Procedure SetFormStyle(Value:TFormStyle);
         Procedure InsertMDIChild(Child:TForm);
         Procedure RemoveMDIChild(Child:TForm);
         Procedure CreateUniqueWindowId(AChild:TControl);
         Procedure SetPosition(NewValue:TPosition);
         Constructor CreateIntern(AOwner:TComponent; Var AReference:TForm);
         Function GetTopMDIChild:TForm;
         Procedure SetIsModal(iIsModal : Boolean);

         Procedure DoActivateMDIChild;
         Procedure DoDeactivateMDIChild;
         Procedure DoActivate;
         Procedure DoDeactivate;
         Procedure DoChangeFocus(Value:Boolean;otherfocuswin:Longword);Override;
         Procedure DoChangeActive(Value:Boolean);
      Protected
         Property MenuBar:TToolBar read FMenuBar write FMenuBar;
         Procedure CreateControls;Override;
         Procedure RealignControls;Override;
         Procedure Activate;Virtual;
         Procedure Deactivate;Virtual;
         Function GetTileCascadeRect:TRect;Virtual;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure CommandEvent(Var Command:TCommand);Override;
         Procedure TranslateShortCut(KeyCode:TKeyCode;Var Receiver:TForm);Virtual;
         Function CloseQuery:Boolean;Virtual;
         Procedure EndModalState;Virtual;
         Procedure ResetComponents;Virtual;
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure SetupShow;Override;
         Procedure Resize;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MenuInit(AMenu:TMenu;entry:TMenuItem);Virtual;
         Procedure MenuEnd(AMenu:TMenu;entry:TMenuItem);Virtual;
         Procedure MenuItemFocus(AMenu:TMenu;entry:TMenuItem);Virtual;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure DestroyWnd;Override;
         Procedure DestroyHandle;Override;
      Public
         Constructor Create(AOwner:TComponent);Override;
         Constructor CreateNew(AOwner:TComponent);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInT);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure WriteInfoToINI(InfoLine : String); Override;
         Function ReadInfoFromINI : String; Override;
         Destructor Destroy;Override;
         Procedure MenuCharEvent(AMenu:TMenu;entry:TMenuItem;Var key:Char;REP:Byte);Virtual;
         Procedure MenuScanEvent(AMenu:TMenu;entry:TMenuItem;Var KeyCode:TKeyCode;REP:Byte);Virtual;
         Procedure Release;
         Function ShowModal:LongWord;Virtual;
         Procedure DismissDlg(Result:TCommand);Virtual;
         Procedure Close;Virtual;
         Procedure RemoveComponent(AComponent:TComponent);Override;
         Procedure InsertControl(AChild:TControl);Override;
         Procedure RemoveControl(AChild:TControl);Override;
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Procedure Focus;Override;
         Procedure BringToFront;Override;
         Procedure SendToBack;Override;
         Procedure Tile;Virtual;
         Procedure Cascade;Virtual;
         Procedure Next;Virtual;
         Function GetFormImage:TGraphic;
         Procedure PrintForm(iDstRec: TRect);
         Procedure Print(Canvas:TCanvas;Dest:TRect);
         Procedure Previous;Virtual;
         Procedure CloseAll;Virtual;
         Procedure AddShortCut(KeyCode:TKeyCode;Command:TCommand);
         Procedure DeleteShortCut(KeyCode:TKeyCode);
         Procedure AlignToolBars;
      Public
         Property Moveable:Boolean Read FMoveable Write FMoveable; {only OS2}
         Property Sizeable:Boolean Read FSizeable Write FSizeable; {only OS2}
         Property ModalResult:TModalResult Read FModalResult Write FModalResult;
         Property Locked : Boolean Read FLocked;
         Property TileMode:TTileMode Read FTileMode Write FTileMode;
         Property MDIChildren[Index:LongInt]:TForm Read GetMDIChild;
         Property MDIChildCount:LongInt Read GetMDIChildCount;
         Property ActiveMDIChild:TForm Read GetTopMDIChild;
         Property ActiveControl:TControl Read FActiveControl Write SetActiveContRol;
         Property Frame:TControl Read FFrame;
         Property DBCSStatusLine:Boolean Read FDBCSStatusLine Write SetDBCSStatuSlinE;
         Property ShortCutsEnabled:Boolean Read FShortCutsEnabled Write SetShortCutsEnablEd;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property AutoScroll;
         Property Color;
         Property BorderIcons:TBorderIcons Read FBorderIcons Write SetBorderIcons;
         Property BorderStyle:TFormBorderStyle Read FBorderStyle Write SetBorderStYlE;
         Property Caption;
         Property ClientWidth;
         Property ClientHeight;
         Property Menu:TMainMenu Read FMainMenu Write SetMainMenu;
         Property PenColor;
         Property PopupMenu;
         Property Position:TPosition Read FPosition Write SetPosition;
         Property Enabled;
         Property EnableDocking:TToolbarAlignments Read FEnableDocking Write FEnabLeDockiNg;
         Property Font;
         Property FormStyle:TFormStyle Read FFormStyle Write SetFormStyle;
         Property Icon:TGraphic Read GetIcon Write SetIcon;
         Property IsModal:Boolean Read FIsModal Write SetIsModal;
         Property ScrollBars;
         Property HorzScrollBar;
         Property VertScrollBar;
         Property ShowHint;
         Property Visible;
         Property WindowState:TWindowState Read GetWindowState Write SetWindowStatE;
         Property LanguageSupport : Boolean Read FLanguageSupport Write FLanguageSupport;

         Property OnActivate:TNotifyEvent Read FOnActivate Write FOnActivate;
         Property OnClick;
         Property OnClose:TCloseEvent Read FOnClose Write FOnClose;
         Property OnCommand;
         Property OnCreate:TNotifyEvent Read FOnCreate Write FOnCreate;
         Property OnDblClick;
         Property OnDeactivate:TNotifyEvent Read FOnDeactivate Write FOnDeactivate;
         Property OnDestroy:TNotifyEvent Read FOnDestroy Write FOnDestroy;
         Property OnDismissDlg:TNotifyEvent Read FOnDismissDlg Write FOnDismissDlg;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnHide;
         Property OnKeyPress;
         Property OnMaximize:TNotifyEvent Read FOnMaximize Write FOnMaximize;
         Property OnMenuEnd:TMenuEvent Read FOnMenuEnd Write FOnMenuEnd;
         Property OnMenuInit:TMenuEvent Read FOnMenuInit Write FOnMenuInit;
         Property OnMenuItemFocus:TMenuEvent Read FOnMenuItemFocus Write FOnMenuItemFocus;
         Property OnMinimize:TNotifyEvent Read FOnMinimize Write FOnMinimize;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnMove;
         Property OnPaint;
         Property OnResize;
         Property OnRestore:TNotifyEvent Read FOnRestore Write FOnRestore;
         Property OnScan;
         Property OnSetupShow;
         Property OnShow;
         Property OnTranslateShortCut:TTranslateShortCutEvent Read FOnTranslateShortCut WritE fonTranslateShortCut;
    End;


    HCursor=LongWord;

    PCursorRec=^TCursorRec;
    TCursorRec=Record
         Index:TCursor;
         Handle:HCursor;
         Next:PCursorRec;
    End;

type
    tListCursorsPt = Array[0..ListCursorsPtCount] of tPointer;

    TScreen=Class(TComponent)
      Private
         FFonts                : TList;                    //Font List available (TFont)
         FCursor               : TCursor;
         FCursorList           : PCursorRec;               //mouse Cursor List available
         fCursorPointer        : tListCursorsPt;
         FDefaultCursor        : HCursor;
         FForms                : TList;                    //Forms on the DeskTop (TForm)
         FActiveForm           : TForm;                    //Active DeskTop Form
         FActiveControl        : TControl;
         FLastActiveForm       : TForm;
         FLastActiveControl    : TControl;
         FCanvas               : TCanvas;
         FMenuFont             : TFont;
         FSystemFontCount      : Longint;
         FSystemFont           : TFont;
         FDefaultFont          : TFont;
         FDefaultFrameFont     : TFont;
         FFontWindow           : TControl;                 //FontWindow For OS/2
         FHiddenWindow         : TControl;             //Window For PopupMenus & Timers
         FOnActiveFormChange   : TNotifyEvent;
         FOnActiveControlChange: TNotifyEvent;

         Procedure CreateCursors;
         Procedure DestroyCursors;
         Procedure InsertCursor(Index:TCursor;Handle:HCursor);
         Procedure DeleteCursor(Index:TCursor);
         Function GetCursors(Index:TCursor):HCursor;
         Procedure SetCursors(Index:TCursor;Handle:HCursor);
         Procedure SetCursor(Index:TCursor);
         Function GetHeight:LongInt;
         Function GetWidth:LongInt;
         Function GetFormCount:LongInt;
         Function GetForm(Index:LongInt):TForm;
         Function GetFontCount:LongInt;
         Function GetFont(Index:LongInt):TFont;
         Function GetMousePos:TPoint;
         Procedure SetMousePos(NewPos:TPoint);
         Function GetSystemDefaultFont:TFont;
         Function GetSystemFixedFont:TFont;
         Function GetSystemSmallFont:TFont;
         Procedure UpdateLastActive;
         Function GetCanvas:TCanvas;
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Function CreateCompatibleFont(Src:TFont):TFont;
         Function GetFontFromName(FaceName:String;Height,Width:LongInt):TFont;
         Function GetFontFromPointSize(FaceName:String;PointSize:LongWord):TFont;
         Function GetControlFromPoint(pt:TPoint):TControl;
         Function SystemMetrics(sm:TSystemMetrics):LongInt;
         Function SystemColors(sc:TColor):TColor;
         Procedure Update;
         Procedure MapPoints(Target:TControl;Var pts:Array Of TPoint);
         Function AddCursor(Handle:HCursor):TCursor;
      Public
         Property HiddenWindow:TControl Read FHiddenWindow;
         Property Width:LongInt Read GetWidth;
         Property Height:LongInt Read GetHeight;
         Property Forms[Index:LongInt]:TForm Read GetForm;
         Property FormCount:LongInt Read GetFormCount;
         Property ActiveForm:TForm Read FActiveForm;
         Property ActiveControl:TControl Read FActiveControl;
         Property MousePos:TPoint Read GetMousePos Write SetMousePos;
         Property Cursor:TCursor Read FCursor Write SetCursor;
         Property Cursors[Index:TCursor]:HCursor Read GetCursors Write SetCursors;
         Property Fonts[Index:LongInt]:TFont Read GetFont;
         Property FontCount:LongInt Read GetFontCount;
         property SystemFontCount : LongInt read FSystemFontCount;
         Property DefaultFrameFont:TFont Read FDefaultFrameFont;
         Property DefaultFont:TFont Read GetSystemDefaultFont {Martin}Write FDefaultFont;
         Property FixedFont:TFont Read GetSystemFixedFont;
         Property SmallFont:TFont Read GetSystemSmallFont;
         Property Canvas:TCanvas Read GetCanvas;
         Property MenuFont:TFont Read FMenuFont;
         Property OnActiveFormChange:TNotifyEvent Read FOnActiveFormChange Write FOnActiveFormChange;
         Property OnActiveControlChange:TNotifyEvent Read FOnActiveControlChange Write FOnActiveControlChange;
         Property FontList:TList read FFonts;
    End;

    THintInfo=Record
         HintControl:TControl;
         HintPos:TPoint;
         HintMaxWidth:LongInt;
         HintColor:TColor;
         HintPenColor:TColor;
         CursorRect:TRect;
         CursorPos:TPoint;
    End;

{$M+}
    TMessageEvent=Procedure(Var Msg:TMessage;Var Handled:Boolean) Of Object;
    TIdleEvent=Procedure(Sender:TObject;Var Done:Boolean) Of Object;
    TExceptionEvent=Procedure(Sender:TObject;E:Exception) Of Object;
    THelpEvent=Procedure(context:THelpContext;Var Result:Boolean) Of Object;
    TShowHintEvent=Procedure(Var HintStr:String;Var CanShow:Boolean;Var HintInfo:THintInfo) Of object;
{$M-}

{$M+}
    THintOrigin=(hiTop,hiBottom);
{$M-}

    THintWindow=Class(TControl)
      Private
         fHintText : tStringList;
      Protected
         Procedure SetupComponent;Override;
         {$IFDEF WIN32}
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure CreateWnd;Override;
         {$ENDIF}
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ActivateHint(Rect:TRect; Const AHint:String);Virtual;
         Procedure DeactivateHint;Virtual;
         Property Caption;
         Property Color;
         Property PenColor;
    End;

    THintWindowClass=Class Of THintWindow;

Const HintWindowClass:THintWindowClass=THintWindow;

// Application
Type
    {$HINTS OFF}
    TApplication=Class(TComponent)
      Private
         FMainForm:TForm;
         FShowMainForm:Boolean;
         FIcon:TGraphic;
         FHelpFile:PString;
         FHelpWindowTitle:PString;
         FHelpWindow:HWindow;
         {Martin}FHelpHTMLHELP : boolean;
                 FHtmlHelpIntroPage : string;
         FHintTimer:TTimer;
         FHintControl:TControl;
         FHintParent:TControl;
         FHintOwner:TControl;
         FHintWindow:THintWindow;
         FHint:String;
         FShowHint:Boolean;
         FHintPause:LongInt;
         FHintPenColor:TColor;
         FHintColor:TColor;
         FHintOrigin:THintOrigin;
         FMenuItemList:TList;
         FFont:TFont;
         FDBCSSystem:Boolean;
         FHasFocus:Boolean;
         FTerminate:Boolean;
         ExceptObject:Exception;
         FKeysHelpContext        : THelpContext;
         FGradientTitlebar       : Boolean;
         fLanguage               : tLanguage;
         fLanguageFile           : tLanguageFile;
         FFormInfoINI            : tFormInfoINI;
         FProgramName            : String;
         FProgramPath            : tFileName;
         FProgramVersion         : Word;
         FProgramSubVersion      : Word;
         FProgramDate            : TDateTime;
         FProgramIniFile         : TIniFile;
         fParameter              : tStringList;
         fLog                    : tcLog;
         fStartFromIDE           : Boolean;      // =true; Programm wurde von der IDE gestartet.
         fDestroyFormInOldMethode: Boolean;

         FOnHint:TNotifyEvent;
         FOnIdle:TIdleEvent;
         FOnMessage:TMessageEvent;          
         FOnMsgEvent:TMessageEvent;
         FOnException:TExceptionEvent;
         FOnHelp:THelpEvent;
         FOnShowHint:TShowHintEvent;
      Private
         Function GetHelpFile:String;
         Procedure SetHelpFile(NewName:String);
         Function GetHelpWindowTitle:String;
         Procedure SetHelpWindowTitle(NewTitle:String);
         Procedure SetHint(Const NewText:String);
         Procedure HintTimerExpired;
         Procedure DestroyHintWindow;
         Procedure SetFont(NewFont:TFont);
         Function ProcessMessage:Boolean;
         Procedure Idle;
         Function GetIcon:TGraphic;
         Procedure SetIcon(NewIcon:TGraphic);
         Procedure SetLanguage(Const NewLanguage: tLanguage);
         Function GetExeName : tFilename;
         Function GetProgramAlreadyRunning : Boolean;
//         Function GetFormInfo(Const FormName: String): TFormInfo;
//         Procedure SetFormInfo(Const FormName: String; Const FormInfo : TFormInfo);
         Procedure SetProgramIniFile(Const iIniFile :  TIniFile);
      Protected
         Procedure SetupComponent;Override;
      Public
         Constructor Create;Virtual;
         Destructor Destroy;Override;
         Procedure CreateForm(InstanceClass:TFormClass;Var Reference:TForm);
         Procedure LogWriteln(iText : String);
         Procedure Run;
         Procedure RunFailed;Virtual;
         Procedure ProcessMessages;
         Procedure HandleMessage;
         Procedure Terminate;
         Function TextException(E:Exception) : String;
         Procedure HandleException(Sender:TObject);
         Procedure ShowException(E:Exception);
         Procedure HelpIndex;
         Procedure HelpOnHelp;
         Procedure HelpContents;
         Procedure KeysHelp;
         Function HelpJump(Const JumpId:String):Boolean;
         Function HelpContext(context:THelpContext):Boolean;
         Function Help(context:THelpContext):Boolean;Virtual;
         {Martin HTML-Help}
           Function HHelpContext(context:THelpContext; contextstring:string):Boolean;
           Function HHelp(context:THelpContext; contextstring:string):Boolean;Virtual;
         Function NewMenuItem(Entry:TMenuItem):TCommand;
         Procedure DeleteMenuItem(Entry:TMenuItem);
         Function GetMenuItem(Command:TCommand):TMenuItem;

         Function GetProgramVersionString : String;
      Public
         Property Language : tLanguage Read fLanguage Write SetLanguage;
         Property MainForm:TForm Read FMainForm;
         {Martin}
           Property HelpHTMLhelp : boolean read FHelpHTMLhelp write FHelpHTMLHelp;
           Property HtmlHelpIntroPage : string read FHtmlHelpIntroPage write FHtmlHelpIntroPage;
         Property HelpFile:String Read GetHelpFile Write SetHelpFile;
         Property HelpWindowTitle:String Read GetHelpWindowTitle Write SetHelpWindowTitle;
         Property HelpWindow:HWindow Read FHelpWindow;
         Property DBCSSystem:Boolean Read FDBCSSystem;
         Property Terminated:Boolean Read FTerminate;
         Property HasFocus:Boolean Read FHasFocus;
         Property GradientTitlebar:Boolean Read FGradientTitlebar Write FGradientTitlebar;
         Property Hint:String Read FHint Write SetHint;
         Property ShowHint:Boolean Read FShowHint Write FShowHint;
         Property ShowMainForm:Boolean Read FShowMainForm Write FShowMainForm;
         Property HintPause:LongInt Read FHintPause Write FHintPause;
         Property HintPenColor:TColor Read FHintPenColor Write FHintPenColor;
         Property HintColor:TColor Read FHintColor Write FHintColor;
         Property HintOrigin:THintOrigin Read FHintOrigin Write FHintOrigin;
         Property Font:TFont Read FFont Write SetFont;
         Property Icon:TGraphic Read GetIcon Write SetIcon;
         Property KeysHelpContext        : THelpContext  Read FKeysHelpContext write FKeysHelpContext;
         Property ExeName                : tFileName     Read GetExeName;
         Property Parameter              : tStringList   Read fParameter;
         Property Log                    : tcLog         Read fLog;
         Property LanguageFile           : tLanguageFile Read fLanguageFile;
         Property ProgramPath            : tFileName     Read FProgramPath Write FProgramPath;
         Property ProgramName            : String        Read FProgramName Write FProgramName;
         Property ProgramAlreadyRunning  : Boolean       Read GetProgramAlreadyRunning;
         Property ProgramVersion         : Word          Read FProgramVersion Write FProgramVersion;
         Property ProgramSubVersion      : Word          Read FProgramSubVersion Write FProgramSubVersion;
         Property ProgramDate            : TDateTime     Read FProgramDate Write FProgramDate;
         Property ProgramIniFile         : TIniFile      Read FProgramIniFile Write SetProgramIniFile;
         Property FormInfoINI            : tFormInfoINI  Read FFormInfoINI Write FFormInfoINI;
         Property StartFromIDE           : Boolean       Read fStartFromIDE;
         Property DestroyFormInOldMethode: Boolean       Read fDestroyFormInOldMethode Write fDestroyFormInOldMethode;

         Property OnHint:TNotifyEvent Read FOnHint Write FOnHint;
         Property OnIdle:TIdleEvent Read FOnIdle Write FOnIdle;
         Property OnMessage:TMessageEvent Read FOnMessage Write FOnMessage;
         Property OnMsgEvent:TMessageEvent read FOnMsgEvent Write FOnMsgEvent;
         Property OnException:TExceptionEvent Read FOnException Write FOnException;
         Property OnHelp:THelpEvent Read FOnHelp Write FOnHelp;
         Property OnShowHint:TShowHintEvent Read FOnShowHint Write FOnShowHint;
    End;
    {$HINTS ON}

Type
    TCompLibData=Record
//         NewHeapOrg,NewHeapEnd,NewHeapPtr:Pointer;
//         NewHeapSize:LongWord;
//         NewLastHeapPage,NewLastHeapPageAdr:Pointer;
//         NewHeapMutex:LongWord;
         HeapGroup        : Pointer;
         InsideWriteSCUAdr: Pointer;
         Screen           : TScreen;
         Application      : TApplication;
         Clipboard        : TClipBoard;
         ToolsAPI         : TObject;
         ToolsAPIRequired : Boolean;
         NullStr          : PString;
    End;


{Martin!}
Function GeneralGetFontFromPointSize(Canvas : tCanvas; FaceName:String;PointSize:LongWord):TFont;
Function Point(X,Y:LongInt):TPoint;
Function Rect(Left,Bottom,Right,Top:LongInt):TRect;
Function PointInRect(pt:TPoint; rec:TRect):Boolean;
Function RectInRect(Const childrec,parentrec:TRect):Boolean;
Procedure InflateRect(Var rec:TRect; X,Y:LongInt);
Procedure OffsetRect(Var rec:TRect; X,Y:LongInt);
Function IntersectRect(Const rec1,rec2:TRect):TRect;
Function UnionRect(Const rec1,rec2:TRect):TRect;
Function IsRectEmpty(Const rec:TRect):Boolean;

Function SendMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):LONG;
Function PostMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):BOOL;
Function HandleToControl(ahwnd:HWindow):TControl;
Function OppositeRGB(color:TColor):TColor;
Function ValuesToRGB(Red,Green,Blue:Byte):TColor;
Function RGBToValues(color:TColor;Var Red,Green,Blue:Byte):TColor;
Function SysColorToRGB(color:TColor):TColor;
Function GetShortHint(Const Hint:String):String;
Function GetLongHint(Const Hint:String):String;
Function IsControlLocked(Control:TControl):Boolean;
Function GetParentForm(Control:TControl):TForm;

Procedure DrawSystemBorder(Control:TControl;Var rec:TRect;Style:TBorderStyle);
Procedure DrawSystemFrame(Control:TControl;Var rec:TRect;LightColor,DarkColor:TCoLor);
Procedure DrawButtonFrame(Control:TControl;Var rc1:TRect;IsDown,IsDefault,HasFocus:Boolean);

Procedure TransformPointToOS2(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
Procedure TransformRectToOS2(Var rec:TRect;Control:TControl;Graphic:TGraphic);
Procedure TransformPointToWin32(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
Procedure TransformRectToWin32(Var rec:TRect;Control:TControl;Graphic:TGraphic);
Procedure TransformClientPoint(Var pt:TPoint;iOwnerObject : tObject); // Control:TControl;Graphic:TGraphic);
Procedure TransformClientRect(Var rec:TRect;iOwnerObject : tObject);  // Control:TControl;Graphic:TGraphic);
Procedure MapDialogPoints(SourceWindow:HWindow;Var ptl:TPoint);
Procedure RectToWin32Rect(Var rec:TRect);
Procedure Win32RectToRect(Var rec:TRect);
Function ptInRect(Const rc:TRect;Const pt:TPoint):Boolean;

{$IFDEF OS2}
Function IsDBCSFirstByte(CH:Char):Boolean;
{$ENDIF}

Var Screen:TScreen;
    Application:TApplication;
             
Const
   MakeIniFile : boolean = true;   // =true: Erstellen der INI-Datei
   StandardMnemoChar:Char='~';     // used for all source code and scu data
   OS2MnemoChar:Char='~';
   WinMnemoChar:Char='&';
   {$IFDEF OS2}
   SystemMnemoChar:Char='~';
   {$ENDIF}
   {$IFDEF Win32}
   SystemMnemoChar:Char='&';
   {$ENDIF}

Function ConvertSystemMnemo(Const MnemoString:String):String;
Function ConvertSCUMNemo(Const SCUString : String):String;

Const
   RegisterToolsAPIProc:Procedure(ToolServ:TObject)=Nil;

{internal}
Procedure SetupCompLib(Var Data:TCompLibData);
Procedure RegisterAutomaticForm(FormClass:TFormClass;address:Pointer);
Procedure SetControlHandle(Control:TControl;Handle:HWND);
Procedure SetDefWndProc(Control:TControl;Proc:Pointer);
{$IFDEF OS2}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
{$ENDIF}
{$IFDEF Win32}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;APIENTRY;
{$ENDIF}
Function IsControl(Control:TControl):Boolean;


Function GetBorderHeight(Form:TForm):LongInt;
Function GetBorderWidth(Form:TForm):LongInt;

Var NewStyleControls: Boolean;

{$IFDEF WIN32}
Procedure DisposeMenuHandleItem(AOwner:TForm;AHandle:LongWord;AObject:TComponent);
Procedure NewMenuHandleItem(AOwner:TForm;AHandle:LongWord;AObject:TComponent);
Function WinColorToRGB(color:TColor):TColor;Assembler;
Function RGBToWinColor(color:TColor):TColor;Assembler;
{$ENDIF}

Implementation

Uses Printers;

Function GetTopBottomHeight(Form:TForm):LongInt;
Var T:LongInt;
    List:TList;
    Toolbar:TToolbar;
Begin
     Result:=0;

     List:=Form.FToolBarLists[tbTop];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;

     List:=Form.FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;
End;

Function GetLeftRightWidth(Form:TForm):LongInt;
Var T:LongInt;
    List:TList;
    Toolbar:TToolbar;
Begin
     Result:=0;

     List:=Form.FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;

     List:=Form.FToolBarLists[tbRight];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;
End;


Type
    TFrameControl=Class(TControl)
      Private
         FResourceId:LongWord;
         FResourceModule:LongWord;
         FChild:TForm;
         {$IFDEF OS2}
         Procedure WMActivate(Var Msg:TWMActivate); Message WM_ACTIVATE;
         Procedure WMFormatFrame(Var Msg:TMessage); Message WM_FORMATFRAME;
         Procedure WMQueryFrameCtlCount(Var Msg:TMessage); Message WM_QUERYFRAMECTlcOUNt;
         Procedure WMCalcFrameRect(Var Msg:TMessage); Message WM_CALCFRAMERECT;
         Procedure WMQueryTrackInfo(Var Msg:TMessage); Message WM_QUERYTRACKINFO;
         Procedure WMMinMaxFrame(Var Msg:TMessage); Message WM_MINMAXFRAME;
         {$ENDIF}
         {$IFDEF Win32}
         Procedure WMActivate(Var Msg:TWMActivate); Message WM_ACTIVATE;
         Procedure WMClose(Var Msg:TWMClose); Message WM_CLOSE;
         Procedure WMChildActivate(Var Msg:TMessage); Message WM_CHILDACTIVATE;
         Procedure WMInitMenuPopup(Var Msg:TMessage); Message WM_INITMENUPOPUP;
         Procedure WMMenuSelect(Var Msg:TMessage); Message WM_MENUSELECT;
         Procedure WMMenuChar(Var Msg:TMessage); Message WM_MENUCHAR;
         Procedure WMGetMinMaxInfo(Var Msg:TMessage); Message WM_GETMINMAXINFO;
         Procedure WMSysCommand(Var Msg:TMessage); Message WM_SYSCOMMAND;
         {$ENDIF}
         Procedure SetResourceId(NewId:LongWord);
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Function GetClientRect:TRect;Override;
         Function GetStandardFont:TFont;Override;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure CreateWnd;Override;
      Public
         Destructor Destroy;Override;
         Property ResourceId:LongWord Read FResourceId Write SetResourceId; {?}
         Property Child:TForm Read FChild;
    End;

////////////////////////////////////////////////////////////////////////////

Const
     {$IFDEF OS2}
     widClient = FID_CLIENT;
     {$ENDIF}
     {$IFDEF Win32}
     widClient = 1;
     {$ENDIF}

     cmInternalControlBase   = $9000;
     cmInternalMenuItemBase  = $1000;

     DBCSStatusLineHeight:LongInt = 0;
     ExternalDragDropObject:TExternalDragDropObject = Nil;


Function GetBorderWidth(Form:TForm):LongInt;
Begin
  Result := 0;
  If Form = Nil Then exit;
  If Not Form.Designed 
    Then
      Begin
        Case Form.FBorderStyle Of
          bsSingle:   Result := goSysinfo.Screen.BorderSize.CX;
          bsSizeable: Result := goSysinfo.Screen.SizeBorderSize.CX;
          bsDialog:   Result := goSysinfo.Screen.DlgBorderSize.CX;
        End;
      End
    Else Result := goSysinfo.Screen.SizeBorderSize.CX;
End;


Function GetBorderHeight(Form:TForm):LongInt;
Begin
  Result := 0;
  If Form = Nil Then exit;
  If Not Form.Designed
    Then
      Begin
        Case Form.FBorderStyle Of
          bsSingle:   Result := goSysinfo.Screen.BorderSize.CY;
          bsSizeable: Result := goSysinfo.Screen.SizeBorderSize.CY;
          bsDialog:   Result := goSysinfo.Screen.DlgBorderSize.CY;
        End;
      End
    Else Result := goSysinfo.Screen.SizeBorderSize.CY;
End;


{$HINTS OFF}

{$IFDEF Win32}
Function GetOwnerHeight(Control:TControl;Graphic:TGraphic):LongInt;
Begin
     If Control <> Nil Then
     Begin
          Result := Control.FHeight;
          {$IFDEF Win32} //!!
          If Control Is TFrameControl Then
          Begin
               Dec(Result, goSysInfo.Screen.TitlebarSize);
               //Dec(Result, GetBorderHeight(Control.FForm));
               //Dec(OwnerHeight, GetBorderHeight(Control.FForm));
          End;
          {$ENDIF}
     End
     Else If Graphic <> Nil Then Result := Graphic.Height
     Else Result := Screen.Height;
End;
{$ENDIF}

Procedure TransformPointToOS2(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}
Begin
     {$IFDEF Win32}
     OwnerHeight:=GetOwnerHeight(Control,Graphic);

     {$IFDEF Win32} //!!
     If Control Is TFrameControl Then
       Inc(pt.Y, GetBorderWidth(Control.FForm));
     {$ENDIF}

     pt.Y := (OwnerHeight-pt.Y);
     {$ENDIF}
End;


Procedure TransformRectToOS2(Var rec:TRect;Control:TControl;Graphic:TGraphic);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}
Begin
  {$IFDEF Win32}
  OwnerHeight:=GetOwnerHeight(Control,Graphic);
  If Control Is TFrameControl Then
    Begin
      Inc(rec.Left, GetBorderWidth(Control.FForm));
      Inc(rec.Right, GetBorderWidth(Control.FForm));
    End;
  rec.Bottom := (OwnerHeight-rec.Bottom);
  rec.Top := (OwnerHeight-rec.Top);
  {$ENDIF}
End;


Procedure TransformPointToWin32(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
Begin
  {$IFDEF Win32}
  TransformPointToOS2(pt,Control,Graphic);
  {$ENDIF}
End;

Procedure TransformRectToWin32(Var rec:TRect;Control:TControl;Graphic:TGraphic);
Begin
  {$IFDEF Win32}
  TransformRectToOS2(rec,Control,Graphic);
  {$ENDIF}
End;

Procedure TransformClientPoint(Var pt:TPoint; iOwnerObject : tObject); // ; Control:TControl; Graphic:TGraphic);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}

Begin
  {$IFDEF Win32}
  if iOwnerObject = Nil
    then OwnerHeight := Screen.Height
    else
      if iOwnerObject is tControl
        then OwnerHeight := tControl(iOwnerObject).ClientHeight
        else
          if iOwnerObject is tGraphic
            then OwnerHeight := tGraphic(iOwnerObject).Height
            else // OwnerHeight := Screen.Height;
              if iOwnerObject is tPrinter
                then OwnerHeight := tPrinter(iOwnerObject).PageHeight
                else OwnerHeight := Screen.Height;
  Dec(OwnerHeight);              {!}
  pt.Y:=(OwnerHeight-pt.Y);
  {$ENDIF}
End;

Procedure TransformClientRect(Var rec:TRect;iOwnerObject : tObject);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}
Begin
  {$IFDEF Win32}
  if iOwnerObject = Nil
    then OwnerHeight := Screen.Height
    else
      if iOwnerObject is tControl
        then OwnerHeight := tControl(iOwnerObject).ClientHeight
        else
          if iOwnerObject is tGraphic
            then OwnerHeight := tGraphic(iOwnerObject).Height
            else // OwnerHeight := Screen.Height;
              if iOwnerObject is tPrinter
                then OwnerHeight := tPrinter(iOwnerObject).PageHeight
                else OwnerHeight := Screen.Height;
  Dec(OwnerHeight);              {!}
  rec.Bottom:=(OwnerHeight-rec.Bottom);
  rec.Top:=(OwnerHeight-rec.Top);
  {$ENDIF}
End;

Procedure MapDialogPoints(SourceWindow:HWindow;Var ptl:TPoint);
Begin
     {$IFDEF OS2}
     WinMapDlgPoints(SourceWindow,POINTL(ptl),1,False);
     {$ENDIF}
End;

Function ptInRect(Const rc:TRect;Const pt:TPoint):Boolean;
Begin
  Result:=((pt.X>=rc.Left)And(pt.X<=rc.Top)And(pt.Y>=rc.Bottom)And(pt.Y<=rc.Top));
End;

Procedure RectToWin32Rect(Var rec:TRect);
{$IFDEF Win32}
Var  L:LongInt;
{$ENDIF}
Begin
  {$IFDEF Win32}
  L := rec.Top;
  rec.Top := rec.Bottom;
  rec.Bottom := L;
  {$ENDIF}
End;

Procedure Win32RectToRect(Var rec:TRect);
Begin
  {$IFDEF Win32}
  RectToWin32Rect(rec);
  {$ENDIF}
End;
{$HINTS ON}


Function SendMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):LONG;
Begin
     {$IFDEF OS2}
     Result := WinSendMsg(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
     {$IFDEF Win32}
     Result := WinUser.SendMessage(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
End;

Function PostMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):BOOL;
Begin
     {$IFDEF OS2}
     Result := WinPostMsg(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
     {$IFDEF Win32}
     Result := PostMessage(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
End;


Function HandleToControl(ahwnd:HWindow):TControl;
Var P:Pointer;
Begin
  Result := Nil;
  If ahwnd = 0 Then exit;

  Try
     {$IFDEF OS2}
     P := Pointer(WinQueryWindowULong(ahwnd,QWP_PFNWP));
     If P <> @SubclassedWndProc Then Exit; //no Sibyl Window
     Result := Pointer(WinQueryWindowULong(ahwnd,QWL_USER));
     {$ENDIF}
     {$IFDEF Win32}
     P := Pointer(GetWindowLong(ahwnd,GWL_WNDPROC));
     If P <> @SubclassedWndProc Then Exit; //no Sibyl Window
     Result := Pointer(GetWindowLong(ahwnd,GWL_USERDATA));
     {$ENDIF}
     If Not (Result Is TControl) Then Result := Nil;
  Except
    Result := Nil;
  End;
End;


Function GetParentForm(Control:TControl):TForm;
Begin
     Result := TForm(Control);
     While Result <> Nil Do
     Begin
          If Result Is TForm Then Exit;
          Result := TForm(Result.Parent);

          If TControl(Result) Is TFrameControl
          Then Result := TFrameControl(Result).FChild;
     End;
     Result := Nil;
End;


Procedure ListAdd(Var List:TList; Item:Pointer);
Begin
     If List = Nil Then List.Create;
     If List.IndexOf(Item) < 0 Then List.Add(Item);
End;


Procedure ListInsert(Var List:TList; Index:LongInt; Item:Pointer);
Begin
     If List = Nil Then List.Create;
     If List.IndexOf(Item) < 0 Then List.Insert(Index,Item);
End;


Procedure ListRemove(Var List:TList; Item:Pointer);
Begin
     If List <> Nil Then
     Begin
          List.Remove(Item);
          If List.Count = 0 Then
          Begin
               List.Destroy;
               List := Nil;
          End;
     End;
End;


Function ListFind(List:TList; Item:Pointer):LongInt;
Begin
     Result := -1;
     If List = Nil Then Exit;
     Result := List.IndexOf(Item);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TLastMsg Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function GetLastMsgAdr(Control:TControl):PMessage;
Begin
     Result:=Control.FLastMsgAdr;
End;

Function TLastMsg.GetHandled:LongBool;
Begin
     If FControl.FLastMsgAdr <> Nil Then Result := FControl.FLastMsgAdr^.Handled
     Else Result := False;
End;

Procedure TLastMsg.SetHandled(Value:LongBool);
Begin
     If FControl.FLastMsgAdr <> Nil Then FControl.FLastMsgAdr^.Handled := Value;
End;

Function TLastMsg.GetResult:LongWord;
Begin
     If FControl.FLastMsgAdr <> Nil Then Result := FControl.FLastMsgAdr^.Result
     Else Result := 0;
End;

Procedure TLastMsg.SetResult(Value:LongWord);
Begin
     If FControl.FLastMsgAdr <> Nil Then FControl.FLastMsgAdr^.Result := Value;
End;

Procedure TLastMsg.CallDefaultHandler;
Begin
     If FControl.FLastMsgAdr <> Nil
     Then FControl.DefaultHandler(FControl.FLastMsgAdr^);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TTimer Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type PTimerArray=^TTimerArray;
     TTimerArray=Array[1..4000] Of Boolean;

Var TimerList:TList;
    TimerArray:PTimerArray;
    TimerMutex:LongWord;
    TimerWindow:HWindow;


Procedure TTimer.SetupComponent;
Var  Id:LongInt;
Begin
     Inherited SetupComponent;

     {$IFDEF OS2}
     DosRequestMutexSem(TimerMutex,-1);
     {$ENDIF}
     {$IFDEF Win32}
     WaitForSingleObject(TimerMutex,INFINITE);
     {$ENDIF}

     TimerList.Add(Self);

     Asm
        MOV ECX,3998              // because of REPNE SCASB and ADD ECX,2
        MOV EDI,Forms.TimerArray
        ADD EDI,ECX
        MOV AL,0
        STD
        REPNE
        SCASB
        ADD ECX,2
        MOV Id,ECX
        CLD
     End;

     If Id<=2 Then Raise EProcessTerm.Create(LoadNLSStr(SNoMoreTimers));

     FId:=Id;
     TimerArray^[Id]:=True;

     {$IFDEF OS2}
     DosReleaseMutexSem(TimerMutex);
     {$ENDIF}
     {$IFDEF Win32}
     ReleaseMutex(TimerMutex);
     {$ENDIF}

     FRunning:=False;
     FInterval:=100;
     FTime:=0;
End;


Destructor TTimer.Destroy;
Begin
     Stop;

     {$IFDEF OS2}
     DosRequestMutexSem(TimerMutex,-1);
     {$ENDIF}
     {$IFDEF Win32}
     WaitForSingleObject(TimerMutex,$FFFFFFFF);
     {$ENDIF}

     TimerList.Remove(Self);
     If TimerArray^[FId]<>True
     Then Raise EProcessTerm.Create(LoadNLSStr(SCouldNotRemoveTimer)+':'+tostr(FID));
     TimerArray^[FId]:=False;

     {$IFDEF OS2}
     DosReleaseMutexSem(TimerMutex);
     {$ENDIF}
     {$IFDEF Win32}
     ReleaseMutex(TimerMutex);
     {$ENDIF}
     Inherited Destroy;
End;


Procedure TTimer.Stop;
Begin
     If Not FRunning Then Exit;

     {$IFDEF OS2}
     WinStopTimer(AppHandle,TimerWindow,FId);
     {$ENDIF}
     {$IFDEF Win32}
     KillTimer(TimerWindow,FId);
     {$ENDIF}
     FRunning := False;
End;


Procedure TTimer.Start;
Begin
     If FRunning Then Exit;

     FTime := 0;

     {$IFDEF OS2}
     WinStartTimer(AppHandle,TimerWindow,FId,FInterval);
     {$ENDIF}
     {$IFDEF Win32}
     SetTimer(TimerWindow,FId,FInterval,Nil);
     {$ENDIF}
     FRunning := True;
End;


Procedure TTimer.Timer;
Begin
     If OnTimer<>Nil Then OnTimer(Self);
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TCaret Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TCaret.Create(Owner:TControl);
Begin
     Inherited Create;
     FControl := Owner;
End;


Procedure TCaret.SetPos(Left,Bottom:LongInt);
{$IFDEF Win32}
Var pt:WinDef.Point;
{$ENDIF}
Begin
     Hide;

     {$IFDEF OS2}
     If FControl.Handle <> 0
     Then WinCreateCursor(FControl.Handle,Left,Bottom,FWidth,FHeight,
                          CURSOR_SETPOS Or CURSOR_FLASH,Nil);
     {$ENDIF}
     {$IFDEF Win32}
     pt.X := Left;
     pt.Y := Bottom;
     TransformClientPoint(pt,FControl); // ,nil);
     Dec(pt.Y,FHeight-1);
     {$ENDIF}
     
     {$IFDEF Win32}
     SetCaretPos(pt.X,pt.Y);
     {$ENDIF}
     FLeft := Left;
     FBottom := Bottom;

     Show;
End;


Procedure TCaret.SetSize(Width,Height:LongInt);
Begin
     If FControl.Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinCreateCursor(FControl.Handle,FLeft,FBottom,Width,Height,
                          CURSOR_SOLID Or CURSOR_FLASH,Nil);
          {$ENDIF}
          {$IFDEF Win32}
          CreateCaret(FControl.Handle,0,Width,Height);
          {$ENDIF}
     End;
     FCreated := True;
     FWidth := Width;
     FHeight := Height;
End;


Procedure TCaret.Show;
Begin
     If FControl.Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinShowCursor(FControl.Handle,True);
     {$ENDIF}
     {$IFDEF Win32}
     ShowCaret(FControl.Handle);
     {$ENDIF}
End;


Procedure TCaret.Hide;
Begin
     If FControl.Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinShowCursor(FControl.Handle,False);
     {$ENDIF}
     {$IFDEF Win32}
     HideCaret(FControl.Handle);
     {$ENDIF}
End;


Procedure TCaret.Remove;
Begin
     Hide;
     {$IFDEF OS2}
     If FCreated Then
       If FControl.Handle <> 0 Then WinDestroyCursor(FControl.Handle);
     {$ENDIF}
     {$IFDEF Win32}
     If FCreated Then DestroyCaret;
     {$ENDIF}
     FCreated := False;
End;


Procedure TCaret.SetBlinkTime(ms:LongInt);
Begin
     If ms <= 0 Then {restore original BlinkTime}
     Begin
          {$IFDEF Win32}
          If FOldBlinkTime <> 0 Then SetCaretBlinkTime(FOldBlinkTime);
          FOldBlinkTime := 0;
          {$ENDIF}
          Exit;
     End;

     FBlinkTime := ms;
     {$IFDEF OS2}
     If FControl.Handle <> 0
     Then WinStartTimer(AppHandle,FControl.Handle,TID_CURSOR,FBlinkTime);
     {$ENDIF}
     {$IFDEF Win32}
     If FOldBlinkTime = 0 Then FOldBlinkTime := GetCaretBlinkTime;
     SetCaretBlinkTime(FBlinkTime);
     {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TForm Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
{$ENDIF}
{$IFDEF Win32}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;APIENTRY;
{$ENDIF}
Var Control:TControl;
Const LastWnd:HWND=0;
      LastControl:TControl=Nil;
Begin
     {$IFDEF OS2}
     If not WinIsWindow(AppHandle,Win) Then exit;
     {$ENDIF}

     If Win <> LastWnd Then
     Begin
         If ((Msg >= WM_USER+1000) And (Msg <= WM_USER+1013)) Then //Web Messages
         Begin
             Control := HandleToControl(para1);
             If (Control = Nil) Or 
                (not (IsControl(Control))) Then Control := HandleToControl(Win);
         End
         Else Control := HandleToControl(Win);                 {Get VMT Pointer}
         If Control = Nil Then exit; //do not handle
         LastWnd := Win;
         LastControl := Control;
     End
     Else Control := LastControl;

     Asm
        PUSHL 0                 //Message.Result
        PUSHL para2             //Message.para2
        PUSHL para1             //Message.para1
        PUSHL 0                 //Message.Handled
        PUSHL Win               //Message.Receiver
        PUSHL Control           //Message.ReceiverClass
        PUSHL Msg               //Message.Message
        MOV   EDX,ESP
        PUSH  EDX               //Var Message
        PUSHL Control           //Self
        CALLN32 TControl.WndProc
        ADD   ESP,24
        POP   EAX               //Result
        MOV   Result,EAX
     End;
End;


Const
    OldTitlebarProc:Pointer=NIL;

{subclassed Window Procedure For Titlebar}
{$IFDEF OS2}
Function SubclassedTitlebarProc(Win:HWND;Msg:ULONG;mp1,mp2:MPARAM):mresult;CDECL;
Var  OldProc:Function(Win:HWND;Msg:ULONG;mp1,mp2:MPARAM):mresult;CDECL;
     aRectL:RECTL;
     bRectL:RECTL;
     ahps:HPS;
     DRed,DGreen,DBlue,DR,DG,DB:Extended;
     StartColor,EndColor:TColor;
     StartLoop,EndLoop:LONGINT;
     cs:CString;
     pt:TPoint;
Begin
     Case Msg Of
       TBM_SETHILITE:
       Begin
         OldProc := OldTitleBarProc;
         Result := OldProc(Win,Msg,mp1,mp2);
         WinInvalidateRect(Win,NIL,FALSE);
       End;
       WM_PAINT:
       Begin
         WinQueryWindowRect(Win,bRectL);

         ahps:=WinBeginPaint(Win,0,aRectL);

         GpiCreateLogColorTable(ahps,0,LCOLF_RGB,0,0,NIL);

         If WinSendMsg(Win,TBM_QUERYHILITE,0,0) <> 0 Then
         Begin
           StartColor:=SysColorToRGB(SYSCLR_ACTIVETITLE);
           EndColor:=0;
           DRed:=TRGB(StartColor).Red;
           DGreen:=TRGB(StartColor).Green;
           DBlue:=TRGB(StartColor).Blue;
           DR:=(TRGB(EndColor).Red-DRed) / (bRectL.xRight+16);
           DG:=(TRGB(EndColor).Green-DGreen) / (bRectL.xRight+16);
           DB:=(TRGB(EndColor).Blue-DBlue) / (bRectL.xRight+16);

           StartLoop:=0;
           EndLoop:=bRectL.xRight+1;

           While StartLoop<>EndLoop Do
           Begin
             aRectL.xLeft:=StartLoop;
             aRectL.xRight:=aRectL.xLeft+1;
             aRectL.yBottom:=bRectL.yBottom;
             aRectL.yTop:=bRectL.yTop;
             WinFillRect(ahps,aRectL,ValuesToRGB(Round(DRed),Round(DGreen),Round(DBlue)));

             DRed:=DRed+DR;
             If DRed < 0 Then DRed := TRGB(EndColor).Red;
             DGreen:=DGreen+DG;
             If DGreen < 0 Then DGreen := TRGB(EndColor).Green;
             DBlue:=DBlue+DB;
             If DBlue < 0 Then DBlue := TRGB(EndColor).Blue;

             inc(StartLoop);
           End;

           GpiSetColor(ahps,SysColorToRGB(SYSCLR_ACTIVETITLETEXT));
         End
         Else
         Begin
           StartColor:=SysColorToRGB(SYSCLR_INACTIVETITLE);
           WinFillRect(ahps,bRectL,StartColor);

           GpiSetColor(ahps,SysColorToRGB(SYSCLR_INACTIVETITLETEXT));
         End;

         WinQueryWindowText(Win,255,cs);
         pt.X := 10;
         pt.Y := 6;
         GpiCharStringAt(ahps,pt,Length(cs),cs[0]);

         WinEndPaint(ahps);
         Result := 0;
       End
       Else
       Begin
         OldProc := OldTitlebarProc;
         Result := OldProc(Win,Msg,mp1,mp2);
       End;
     End;
End;
{$ENDIF}


{$IFDEF WIN32}
Var ModalArray:Array[1..50] Of TControl;

Const
     ModalCount:Byte=0;

Procedure LockDesktopWindows(Lock:Boolean;Exclude:TControl);
Var  T:LongInt;
     actual:TForm;
Begin
     For T := 0 To Screen.FForms.Count-1 Do
     Begin
          actual := Screen.FForms.Items[T];
          If Actual <> Exclude Then
          Begin
               If Lock Then
               Begin
                    //If ModalCount = 0 Then
                    If not Actual.FLocked Then
                    Begin
                         Actual.FOldEnabledState := Actual.FEnabled;
                         If Actual.FFrame <> Nil Then Actual.FFrame.Disable;
                    End;
                    Actual.Disable;
                    Actual.FLocked := True;
               End
               Else
               Begin
                    If ((ModalCount = 1)Or(Actual = ModalArray[ModalCount-1])) Then
                    Begin
                         Actual.FLocked := False;
                         If Actual.FOldEnabledState Or Actual.Designed
                         Then
                         Begin
                             If Actual.FFrame <> Nil Then Actual.FFrame.Enable;
                             Actual.Enable;
                         End;
                    End;
               End;
          End
          Else
          Begin
               If not Lock Then
               Begin
                  Actual.FLocked := False;
                  If Actual.FFrame <> Nil Then Actual.FFrame.Enable;
                  Actual.Enable;
               End;
          End;
     End;

     If Lock Then
     Begin
          Inc(ModalCount);
          ModalArray[ModalCount] := Exclude;
     End
     Else If ModalCount > 0 Then Dec(ModalCount);
End;
{$ENDIF}

{$IFDEF OS2}
Const
   CurrentModalForm:TControl=NIL;
   CurrentModalFrame:HWND=0;
   DesktopHWND:HWND=0;
   ModalList:TList=NIL;

{$HINTS OFF}
Function InputHook(ahab:HAB;VAR apqmsg:QMSG;fs:ULONG):Bool;CDecl;
Var  aHwnd,aHwnd1:HWND;
Begin
     Result := False;

     If DesktopHWND = 0 Then DesktopHWND := WinQueryDesktopWindow(AppHandle, 0);
     aHwnd := apqmsg.hwnd;

     If not (apqmsg.msg IN [WM_CHAR,WM_VIOCHAR,WM_TRANSLATEACCEL,WM_SYSCOMMAND,
                            WM_MOUSEFIRST..WM_MOUSELAST]) Then exit;

     If (aHwnd = DesktopHWND) Or (aHwnd = 0) Then exit;

     While (aHwnd <> DesktopHWND) And (aHwnd <> 0) Do
     Begin
          // check if it is in the modal form
          If aHwnd = CurrentModalFrame Then exit;

          // check if it is a popup menu
          If aHwnd = Screen.FHiddenWindow.Handle Then exit;

          aHwnd1:=aHwnd;
          aHwnd := WinQueryWindow(aHwnd, QW_OWNER);

          If aHwnd = $1001{PMERR_INVALID_HWND} Then exit;
          If aHwnd = $1003{PMERR_PARAMETER_OUT_OF_RANGE} Then exit;

          If ((aHwnd=DesktopHWND)Or(aHwnd=0)) Then
          Begin
              //test Non SPCC form
              If aHwnd1<>0 Then
              Begin
                   //check if this is a memory pointer
                   If not IsControl(HandleToControl(aHwnd1)) Then exit;
              End;
          End;
     End;

     If apqmsg.msg = WM_BUTTON1DOWN Then
       If CurrentModalForm <> Nil Then CurrentModalForm.BringToFront;

     Result := True;
End;
{$HINTS ON}

Procedure LockDesktopWindows(Lock:Boolean;Exclude:TControl);
Var  t:LongInt;
     aForm:TForm;
Begin
     If Lock Then
     Begin
          If ModalList = Nil Then ModalList.Create;
          ModalList.Insert(0, Exclude);
          CurrentModalForm := Exclude;
          CurrentModalFrame := Exclude.FFrame.Handle;

          If ModalList.Count = 1 Then
          Begin
               WinSetHook(
                  AppHandle,
                  HMQ_CURRENT,
                  HK_INPUT,
                  @InputHook,
                  0);
          End;
     End
     Else
     Begin
          ModalList.Remove(Exclude);

          If ModalList.Count = 0 Then
          Begin
               CurrentModalForm := Nil;
               CurrentModalFrame := 0;

               WinReleaseHook(
                 AppHandle,
                 HMQ_CURRENT,
                 HK_INPUT,
                 @InputHook,
                 0);

               ModalList.Destroy;
               ModalList := Nil;
          End
          Else
          Begin
               CurrentModalForm := TControl(ModalList[0]);
               CurrentModalFrame := CurrentModalForm.FFrame.Handle
          End;
     End;

     For t := 0 To Screen.FForms.Count-1 Do
     Begin
          aForm := Screen.FForms.Items[t];
          If CurrentModalForm <> Nil Then
          Begin
               If aForm.Visible Then aForm.FLocked := aForm <> CurrentModalForm
               Else aForm.FLocked := False;
          End
          Else aForm.FLocked := False;
     End;
End;
{$ENDIF}

Procedure TForm.DestroyHandle;

Begin
  Inherited DestroyHandle;
End;


Procedure TForm.DestroyWnd;
Var  I:LongInt;
     Form:TForm;
     {$IFDEF OS2}
     ahswitch:HSwitch;
     rc : Apiret;
     {$ENDIF}
Begin

// Entfernen der Form aus der Taskliste
     {$IFDEF OS2}
     If Frame <> Nil Then
       If Frame.Handle <> 0 Then
       Begin
            ahswitch := WinQuerySwitchHandle(Frame.Handle, 0);
            rc:=WinRemoveSwitchEntry(ahswitch);
       End;
     {$ENDIF}

     If FMDIChildren <> Nil Then //destroy all MDI forms !
     Begin
          For I := 0 To TForm(Self).FMDIChildren.Count-1 Do
          Begin
               Form := TForm(Self).FMDIChildren.Items[I];
               If Form Is TForm Then Form.DestroyHandle;
          End;
     End;

     Inherited DestroyWnd;
End;

Procedure TForm.SetIsModal(iIsModal : Boolean);

Begin
  If Designed Then exit;
  FIsModal:=iIsModal;
  Forms.LockDesktopWindows(iIsModal ,Self);
End;


Procedure TForm.SetPosition(NewValue:TPosition);
Begin
    If NewValue<>FPosition Then
    Begin
         FPosition:=NewValue;
         If Not (csDesigning In ComponentState) Then RecreateWnd;
    End;
End;

{
Function TForm.GetLanguage:String;
Var S:String;
Begin
    Asm
       PUSH DWord Ptr Self
       LEA EAX,s
       PUSH EAX
       CALLN32 Classes.GetLanguage
    End;
    Result:=S;
End;


Procedure TForm.SetLanguage(Const NewLanguage:String);
Begin
     Asm
        PUSH DWord Ptr Self
        PUSH DWord Ptr NewLanguage
        CALLN32 Classes.SetLanguage
     End
End;
}

Const DdeMan_WMDDEDestroy:Procedure(Var Msg:TMessage)=Nil;
      DdeMan_WMDdeInitiate:Procedure(Self:TForm;Var Msg:TMessage)=Nil;
      DdeMan_OpenClientLinks:Procedure(Form:TForm)=Nil;
      DdeMan_CloseClientLinks:Procedure(Form:TForm)=Nil;
      DdeMan_CloseAllLinks:Procedure=Nil;

{$IFDEF OS2}
Procedure TForm.WMDDEDestroy(Var Msg:TMessage);
Begin
     If DdeMan_WMDdeDestroy<>Nil Then DdeMan_WMDdeDestroy(Msg);
End;
{$ENDIF}


{$IFDEF OS2}
Procedure TForm.WMDDEInitiate(Var Msg:TMessage);
Begin
     If DdeMan_WMDdeInitiate<>Nil Then DdeMan_WMDdeInitiate(Self,Msg);
End;
{$ENDIF}


{$HINTS OFF}
Procedure TForm.MenuInit(AMenu:TMenu;entry:TMenuItem);
Begin
     If FOnMenuInit <> Nil Then FOnMenuInit(Self,AMenu,entry);
End;


Procedure TForm.MenuEnd(AMenu:TMenu;entry:TMenuItem);
Begin
     If FOnMenuEnd <> Nil Then FOnMenuEnd(Self,AMenu,entry);
End;


Procedure TForm.MenuItemFocus(AMenu:TMenu;entry:TMenuItem);
Begin
     If OnMenuItemFocus <> Nil Then OnMenuItemFocus(Self,AMenu,entry);
End;


Procedure TForm.MenuCharEvent(AMenu:TMenu;entry:TMenuItem;Var key:Char;REP:Byte);
Begin
End;


Procedure TForm.MenuScanEvent(AMenu:TMenu;entry:TMenuItem;Var KeyCode:TKeyCode;REP:Byte);
Begin
End;
{$HINTS ON}


Procedure TForm.DoChangeFocus(Value:Boolean;otherfocuswin:Longword);
Var  ParentForm:TForm;
     newfocuscontrol:TControl;
Begin
     If Value = True Then      {window is getting Focus}
     Begin
          If FormStyle = fsMDIChild Then
          Begin
               ParentForm := TForm(Parent);
               If ParentForm <> Nil Then
                 If ParentForm.FormStyle = fsMDIForm Then 
                 Begin
                      // also activate the mdi form
                      ParentForm.DoActivate;

                      // reorder the parent's ZOrder list to become the top mdi child
                      If ParentForm.ActiveMDIChild <> Nil Then
                        If ParentForm.ActiveMDIChild <> Self Then
                        Begin
                             If ListFind(ParentForm.FMDIZOrder, Self) >= 0 Then
                             Begin
                                  ListRemove(ParentForm.FMDIZOrder, Self);
                                  ListAdd(ParentForm.FMDIZOrder, Self);
                             End;
                        End;
                 End;
          End;

          // activate the form
          DoActivate;
          DoSetFocus;
     End
     Else                      {window is loosing Focus}
     Begin
          {only deactivate if focus switch to another form}
          If otherfocuswin <> 0 Then
          Begin
               newfocuscontrol := HandleToControl(otherfocuswin);
               If newfocuscontrol <> Nil Then          {a Sibyl control}
                 If newfocuscontrol.Form <> Self 
                 Then newfocuscontrol := Nil;          {other Sibyl form - must deactivate}
          End
          Else newfocuscontrol := Nil;

          If newfocuscontrol = Nil Then DoDeactivate;
          DoKillFocus;
     End;
End;


Procedure TForm.Focus;
Begin
     If IsControlLocked(Self) Or (not CanFocus) Then Exit;

     If FormStyle = fsMDIForm Then
     Begin
          // focus the top mdi child
          If ActiveMDIChild <> Nil Then
          Begin
               ActiveMDIChild.CaptureFocus;
               Exit;
          End;
     End;

     Inherited Focus;
End;


Procedure TForm.DoDeactivateMDIChild;
Var  ParentForm:TForm;
Begin
     ParentForm := TForm(Parent);
     If ParentForm <> Nil Then
       If ParentForm.ActiveMDIChild = Self Then
         If ParentForm.MDIChildCount > 1 Then
         Begin
              If ListFind(ParentForm.FMDIZOrder, Self) >= 0 Then
              Begin
                   ListRemove(ParentForm.FMDIZOrder, Self);
                   ListInsert(ParentForm.FMDIZOrder, 0, Self);
              End;
              // focus the new top mdi child
              ParentForm.ActiveMDIChild.Focus;
         End;
End;


Procedure TForm.DoActivateMDIChild;

{ Var  ParentForm:TForm; }

Begin
/*
     ParentForm := TForm(Parent);
     If FormStyle = fsMDIChild Then
       If ParentForm <> Nil Then
         If ParentForm.FormStyle = fsMDIForm Then
         Begin
              ParentForm.DoActivate;

              If ParentForm.ActiveMDIChild <> Nil Then
                If ParentForm.ActiveMDIChild <> Self Then
                Begin
                     ParentForm.ActiveMDIChild.DoDeactivate;
                     If ListFind(ParentForm.FMDIZOrder, Self) >= 0 Then
                     Begin
                          ListRemove(ParentForm.FMDIZOrder, Self);
                          ListAdd(ParentForm.FMDIZOrder, Self);
                     End;
                     DoActivate;
                End;
         End;
*/
End;


Procedure TForm.DoChangeActive(Value:Boolean);
Begin
     If Value = True Then
     Begin
/*
          If FormStyle = fsMDIChild Then DoActivateMDIChild
          Else DoActivate;
*/
     End
     Else
     Begin
          If FormStyle = fsMDIChild Then DoDeactivateMDIChild;
     End;
End;


Procedure TForm.DoActivate;
Begin
     {$IFDEF Win32}
     If Frame <> Nil Then
       If Frame.Handle <> 0 Then SendMessage(Frame.Handle,WM_NCACTIVATE,1,0);
     {$ENDIF}

     If Application <> Nil Then Application.DestroyHintWindow;

     If Parent = Nil Then Screen.FActiveForm := Self;

     Activate;
End;


Procedure TForm.DoDeactivate;
Begin
     {$IFDEF Win32}
     If Frame <> Nil Then
       If Frame.Handle <> 0 Then SendMessage(Frame.Handle,WM_NCACTIVATE,0,0);
     {$ENDIF}

     If Application <> Nil Then Application.DestroyHintWindow;

     If Screen.FActiveForm = Self Then Screen.FActiveForm := Nil;

     Deactivate;
End;


Procedure TForm.Activate;
Begin
     If OnActivate <> Nil Then OnActivate(Self);
End;


Procedure TForm.Deactivate;
Begin
     If OnDeactivate <> Nil Then OnDeactivate(Self);
End;


Procedure TForm.WMActivate(Var Msg:TWMActivate);
Begin
     {wird unter Win32 nie aufgerufen - Exception zum Test}
End;


Procedure TForm.Release;
Begin
     If Handle <> 0 Then PostMsg(Handle,CM_RELEASE,0,0)
     Else Self.Destroy;
End;


Procedure TForm.CMRelease(Var Msg:TMessage);
Begin
     Self.Destroy;
     Msg.Handled := True;
End;


{$IFDEF OS2}
Procedure TForm.WMClose(Var Msg:TWMClose);
Begin
     Close;

     Msg.Handled := True;
     Msg.Result := 0;
End;


Procedure TForm.WMInitMenu(Var Msg:TMessage);
Var  Win:LongWord;
     AMenu:TMenu;
     entry:TMenuItem;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     Win := Msg.Param2;
     entry := Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}

     If entry Is TMenuItem Then AMenu := entry.Menu
     Else
     Begin
          AMenu := TMenu(entry);
          If Not (AMenu Is TMenu) Then AMenu := Nil;
          entry := Nil;
     End;

     MenuInit(AMenu,entry);
End;


Procedure TForm.WMMenuEnd(Var Msg:TMessage);
Var  Win:LongWord;
     AMenu:TMenu;
     entry:TMenuItem;
Begin
     Win := Msg.Param2;
     entry := Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}

     If entry Is TMenuItem Then AMenu := entry.Menu
     Else
     Begin
          AMenu := TMenu(entry);
          If Not (AMenu Is TMenu) Then AMenu := Nil;
          entry := Nil;
     End;

     MenuEnd(AMenu,entry);

     Application.Hint := '';
End;


Procedure TForm.WMMenuSelect(Var Msg:TMessage);
Var  Win:LongWord;
     AMenu:TMenu;
     entry:TMenuItem;
Begin
     Win := Msg.Param2;
     entry := Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}

     If entry Is TMenuItem Then
     Begin
          AMenu := entry.Menu;
          If AMenu = Nil Then Exit;
     End
     Else
     Begin
          AMenu := TMenu(entry);
          If Not (AMenu Is TMenu) Then Exit;
     End;

     entry := Menu.ItemFromInternalCommand(Msg.Param1Lo);

     MenuItemFocus(AMenu,entry);

     If entry <> Nil Then Application.Hint := GetLongHint(entry.Hint)
     Else Application.Hint := '';
End;
{$ENDIF}


Procedure TForm.CMUpdateButtons(Var Msg:TMessage);
Begin
     Case Msg.Param1 Of
       1: DefaultButton := TControl(Msg.Param2);
       2: CancelButton := TControl(Msg.Param2);
       3: Msg.Result := LongWord(DefaultButton);
       4: Msg.Result := LongWord(CancelButton);
     End;
     Msg.Handled := True;
End;


Procedure TForm.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var  aMsg:TMessage;
Begin
     Inherited ScanEvent(KeyCode,RepeatCount);

     Case KeyCode Of
       {$IFDEF OS2}
       kbEnter,
       {$ENDIF}
       kbCR:
       Begin
            Try
               If Not (IsControl(DefaultButton)) Then DefaultButton := Nil;
            Except
               DefaultButton := Nil;
            End;

            If DefaultButton <> Nil Then
              If DefaultButton.Enabled Then
                If DefaultButton.Visible Then
            Begin
                 FillChar(aMsg,SizeOf(aMsg),0);
                 {ReceiverClass = 0 -> no Default handler Is called}
                 {$IFDEF OS2}
                 aMsg.Msg := WM_CONTROL;
                 aMsg.Param1Lo := DefaultButton.FWindowId;
                 aMsg.Param1Hi := BN_CLICKED;
                 {$ENDIF}
                 {$IFDEF Win32}
                 aMsg.Msg := WM_COMMAND;
                 aMsg.Param1Lo := DefaultButton.FWindowId;
                 aMsg.Param1Hi := BN_CLICKED;
                 {$ENDIF}

                 DefaultButton.ParentNotification(aMsg); {causes Click}
                 If aMsg.Handled Then KeyCode := kbNull;
            End;
       End; {Case}
       kbEsc:
       Begin
            Try
               If Not (IsControl(CancelButton)) Then CancelButton := Nil;
            Except
               CancelButton := Nil;
            End;

            If CancelButton <> Nil Then
             If CancelButton.Enabled Then
                If CancelButton.Visible Then
            Begin
                 FillChar(aMsg,SizeOf(aMsg),0);
                 {ReceiverClass = 0 -> no Default handler Is called}
                 {$IFDEF OS2}
                 aMsg.Msg := WM_CONTROL;
                 aMsg.Param1Lo := CancelButton.FWindowId;
                 aMsg.Param1Hi := BN_CLICKED;
                 {$ENDIF}
                 {$IFDEF Win32}
                 aMsg.Msg := WM_COMMAND;
                 aMsg.Param1Lo := CancelButton.FWindowId;
                 aMsg.Param1Hi := BN_CLICKED;
                 {$ENDIF}
                 CancelButton.ParentNotification(aMsg); {causes Click}
            End;
            KeyCode := kbNull; {!}
       End;
     End;
End;


{$IFDEF OS2}
Procedure TForm.WMTranslateAccel(Var Msg:TMessage);
Var  fsFlags:LongWord;{Martin}
     ascii:Word;
     virtkey:Word;
     scan:TKeyCode;
     Param:TKeyCode;
     apqmsg:^QMSG;
     Receiver:TForm;
Label lsc;
Begin
     If FLocked Then Exit;

     apqmsg:=Pointer(Msg.Param1);

     fsFlags := Lo(apqmsg^.mp1);
     virtkey := Hi(apqmsg^.mp2); {Valid If KC_VIRTKEY}
     scan := Hi(apqmsg^.mp1);    {Valid If KC_SCANCODE}
     ascii := Lo(apqmsg^.mp2);   {Valid If KC_CHAR}

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or  (fsFlags And KC_CTRL <> 0) Then Goto lsc;
          If (fsFlags And KC_VIRTUALKEY <> 0) And (fsFlags And KC_SHIFT <> 0)
          Then Goto lsc;    {numerical block}
          Param := ascii;
     End
     Else
     Begin
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else If fsFlags And KC_KEYUP <> 0 Then Exit {!}
               Else Param := ascii Or kb_Char;  {E.G. Ctrl-J}

          If virtkey = VK_ALT Then Param := Param Or kb_Alt;
          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;
     End;

     Receiver := Nil;
     TranslateShortCut(Param, Receiver);
     If Receiver Is TForm Then Receiver.ForwardShortCut(Msg);
End;
{$ENDIF}


{$HINTS OFF}
Procedure TForm.TranslateShortCut(KeyCode:TKeyCode;Var Receiver:TForm);
Begin
     If OnTranslateShortCut <> Nil Then OnTranslateShortCut(Self,KeyCode,Receiver);
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TForm.ForwardShortCut(Var Msg:TMessage);
{$IFDEF OS2}
Var  apqmsg:^QMSG;
{$ENDIF}
{$IFDEF WIN32}
Var  amsg:WinUser.MSG;
{$ENDIF}
Begin
     {$IFDEF OS2}
     apqmsg := Pointer(Msg.Param1);
     If apqmsg^.HWND = Handle Then Exit;     {prevent recursion}
     apqmsg^.HWND := Handle;
     WinSendMsg(Handle,WM_TRANSLATEACCEL,Msg.Param1,Msg.Param2);
     Msg.Handled := True;
     Msg.Result := 1;
     {$ENDIF}

     {$IFDEF WIN32}
     If FAccel <> 0 Then
     Begin
          amsg.hwnd := Msg.Receiver;
          amsg.message := Msg.Msg;
          amsg.wParam := Msg.wParam;
          amsg.lParam := Msg.lParam;
          amsg.time := 0;
          amsg.pt := Point(0,0);

          // send it to the frame to get the menu messages
          If TranslateAccelerator(Frame.Handle,FAccel,amsg) <> 0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
               exit;
          End
     End;

     // handle Menu Mnemonics
     CaptureFocus;
     PostMsg(Handle,Msg.Msg,Msg.Param1,Msg.Param2);
     Msg.Handled := True;
     Msg.Result := 0;
     {$ENDIF}
End;
{$HINTS ON}

Function TForm.GetFormImage:TGraphic;
Var FDC,FPS,FHandle,ScreenPS:LongWord;
    {$IFDEF Win32}
    rec:TRect;
    {$ENDIF}
    {$IFDEF OS2}
    sizl:SIZEL;
    bmp2:BITMAPINFOHEADER2;
    aptl:ARRAY[0..2] OF TPoint;
    {$ENDIF}
Begin
     Result:=Nil;

     {$IFDEF OS2}
     FDC:=DevOpenDC(AppHandle,OD_MEMORY,'*',0,NIL,0) ;
     sizl.cx:=0;
     sizl.cy:=0;
     FPS:=GpiCreatePS(AppHandle,FDC,sizl,
                      PU_PELS OR GPIF_DEFAULT OR GPIT_MICRO OR GPIA_ASSOC);
     FillChar(bmp2,sizeof(BITMAPINFOHEADER2),0);
     bmp2.cbFix:=sizeof(BITMAPINFOHEADER2);
     bmp2.cx:=Width;
     bmp2.cy:=Height;
     bmp2.cPlanes:=1;
     bmp2.cBitCount:=8;
     FHandle:=GpiCreateBitmap (FPS,bmp2,0,NIL,NIL);
     ScreenPS:=WinGetScreenPS(HWND_DESKTOP);
     GpiCreateLogColorTable(ScreenPS,LCOL_RESET,LCOLF_RGB,0,0,NIL);

     GpiSetBitmap (FPS,FHandle);
     aptl[0].x:=0;
     aptl[0].y:=0;
     aptl[1].x:=Width;
     aptl[1].y:=Height;
     aptl[2].x:=Left;
     aptl[2].y:=Bottom;
     GpiBitBlt (FPS,ScreenPS,3,aptl[0],ROP_SRCCOPY,BBO_IGNORE) ;

     GpiDeleteSetId (ScreenPS,LCID_DEFAULT) ;
     WinReleasePS(ScreenPS);
     {$ENDIF}                  
     {$IFDEF Win32}
     FDC:=CreateDC('DISPLAY',NIL,NIL,NIL);
     FPS:=CreateCompatibleDC(FDC);
     FHandle:=CreateCompatibleBitmap(FDC,Width,Height);
     SelectObject(FPS,FHandle);
     ScreenPS:=FDC;
     rec:=WindowRect;
     RectToWin32Rect(rec);
     TransformRectToWin32(rec,NIL,NIL);
     WinGDI.BitBlt(FPS,0,0,ClientWidth,ClientHeight,ScreenPS,
                   rec.Left,rec.Bottom,SRCCOPY);
     DeleteObject(SelectObject(ScreenPS,0));
     {$ENDIF}

     Result:=TBitmap.Create;
     Result.CreatePalette:=True;
     If FHandle<>0 Then Result.LoadFromHandle(FHandle);

     {$IFDEF Win32}
     DeleteObject(SelectObject(FPS,0));
     DeleteDC(FPS);
     DeleteDC(FDC);
     {$ENDIF}
     {$IFDEF OS2}
     GpiSetBitmap(FPS,0);
     GpiSelectPalette(FPS,0);
     GpiDeleteBitmap(FHandle);
     WinReleasePS(FPS);
     DevCloseDC(FDC);
     {$ENDIF}
End;

Procedure tForm.PrintForm(iDstRec: TRect);

var Image: TBitmap;

Begin
  If not Printer.Printing Then
    EPrinter.Create(FmtLoadNLSStr(SPrinterIdle, ['PrintForm']));
  Image := TBitmap(GetFormImage);
  try
    Printer.PrintBitmap(Image,
                        Rect(0, 0, Image.Width, Image.Height),
                        iDstRec);
  finally
    Image.Free;
  end;
end;



Procedure TForm.Print(Canvas:TCanvas;Dest:TRect);
Var FormImage:TGraphic;
Begin
     FormImage:=GetFormImage;
     FormImage.Draw(Canvas,Dest);
     FormImage.Destroy;
End;

Type TFormIcon=Class(TGraphic)
         Public
               Property IsLocalCopy;
               Property OnChangedNotify;
     End;

Procedure TForm.SetIcon(NewIcon:TGraphic);
Begin
  If ((FIcon<>Nil)And(FIcon<>NewIcon) And (TFormIcon(FIcon).IsLocalCopy)) Then
    Begin
      FIcon.Destroy;
      FIcon:=Nil;
    End;

  If ((NewIcon<>Nil)And(NewIcon<>FIcon) And (TFormIcon(NewIcon).IsLocalCopy)) Then
    Begin   //Create A Copy !!
      Try
        NewIcon:=NewIcon.CopyGraphic;
        TFormIcon(NewIcon).IsLocalCopy:=True;
      Except
        NewIcon:=Nil;
      End;
    End;

  FIcon := NewIcon;

  If ((FIcon<>Nil)And(TFormIcon(FIcon).IsLocalCopy)) Then
    TFormIcon(FIcon).OnChangedNotify:=IconChanged;

  If ((Frame<>Nil)And(Handle<>0)And(Frame.Handle<>0)) Then
    Begin
      {$IFDEF OS2}
      If ((FIcon=Nil)Or(FIcon.Empty))
        Then WinSendMsg(Frame.Handle,WM_SETICON,0,0)
        Else WinSendMsg(Frame.Handle,WM_SETICON,FIcon.Handle,0);
      {$ENDIF}
      {$IFDEF Win32}
      //SendMessage(Frame.Handle,WM_SETICON,ICON_BIG,FIcon);
      If ((FIcon=Nil)Or(FIcon.Empty))
        Then SendMsg(Frame.Handle,WM_SETICON,ICON_SmalL,0)
        Else SendMsg(Frame.Handle,WM_SETICON,ICON_SMALL,FIcon.Handle);
      {$ENDIF}
    End;
End;

Procedure TForm.IconChanged(Sender:TObject);
Begin
  If TGraphic(Sender)=FIcon
    Then Icon:=TGraphic(Sender)
    Else TFormIcon(Sender).OnChangedNotify:=Nil;
End;


Function TForm.GetIcon:TGraphic;
Begin
  If FIcon = Nil Then
    Begin //Create Empty
      FIcon := TIcon.Create;
      TFormIcon(FIcon).IsLocalCopy := True;
    End;
  Result := FIcon;
End;


Procedure TForm.SetMainMenu(AMenu:TMainMenu);
{$IFDEF OS2}
Var  HMen:LongWord;
{$ENDIF}
Begin
     FMainMenu := AMenu;

     If FMainMenu <> Nil Then
     Begin
          //FMainMenu.ComponentIndex := 0;   {the First MainMenu Is Visible}
          If Handle <> 0 Then TMenu(FMainMenu).Show
          Else FInitControls := True;
     End
     Else
     If FFrame <> Nil Then {Clear the main Menu}
     Begin
          {$IFDEF OS2}
          HMen := WinWindowFromID(FFrame.Handle,FID_MENU);

          If HMen <> 0 Then
          Begin
               WinSetParent(HMen,WinQueryObjectWindow(HWND_DESKTOP),False);
               WinSetOwner(HMen,WinQueryObjectWindow(HWND_DESKTOP));
               WinSendMsg(FFrame.Handle,WM_UPDATEFRAME,FCF_MENU,0);
          End;
          {$ENDIF}
          {$IFDEF Win32}
          SetMenu(FFrame.Handle,0);
          {$ENDIF}
     End;
End;

Procedure TForm.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     BringToFront;
{problem mit focus bei listboxen im TOpenDialog
     CaptureFocus;
}

End;


Procedure TForm.Resize;
Begin
  Inherited Resize;
  {Make sure, that the Toolbars Do Not Draw over the Frame border}
  If IsWindowVisible Then
    Begin
      If ClientWidth < 1 Then  ClientWidth := 1;
      If ClientHeight < 1 Then ClientHeight := 1;
    End;
End;

Function TForm.GetFrameFlags:LongWord;
Type
    {Standard Frame Window styles}
    TFrameStyle=(wbsTitleBar, wbsSysMenu, wbsMenu, wbsTaskList,
                 wbsMinButton, wbsMaxButton, wbsHideButton,
                 wbsSizeBorder, wbsDlgBorder, wbsBorder,
                 wbsShellPosition, wbsNoMoveWithOwner,
                 wbsAutoIcon, wbsIcon, wbsAccelTable, wbsSysModal,
                 wbsNoByteAlign, wbsScreenAlign, wbsMouseAlign,wbsHelp);
    TFrameStyles=Set Of TFrameStyle;

{$IFDEF OS2}
Const
     FrameFlags:Array[Low(TFrameStyle)..High(TFrameStyle)] Of LongWord=
             (FCF_TITLEBAR, FCF_SYSMENU, FCF_MENU, FCF_TASKLIST,
              FCF_MINBUTTON, FCF_MAXBUTTON, FCF_HIDEBUTTON,
              FCF_SIZEBORDER, FCF_DLGBORDER, FCF_BORDER,
              FCF_SHELLPOSITION, FCF_NOMOVEWITHOWNER{WS_EX_ABSPOSITION},
              FCF_AUTOICON, FCF_ICON, FCF_ACCELTABLE, FCF_SYSMODAL,
              FCF_NOBYTEALIGN, FCF_SCREENALIGN, FCF_MOUSEALIGN,0);
{$ENDIF}
{$IFDEF Win32}
Const
     FrameFlags:Array[Low(TFrameStyle)..High(TFrameStyle)] Of LongWord=
             (WS_CAPTION, WS_SYSMENU, 0, 0,
              WS_MINIMIZEBOX, WS_MAXIMIZEBOX, 0,
              WS_THICKFRAME, WS_DLGFRAME OR DS_MODALFRAME, WS_BORDER,
              0,0,0,0,0,0,0,0,0,0);
{$ENDIF}
Var  T:TFrameStyle;
     Flags:TFrameStyles;
Begin
     Result := 0;
     Flags := [wbsTitleBar,wbsNoByteAlign];
     If not FModalShowing Then Flags := Flags + [wbsTaskList];

     If Designed Then
     Begin
          Flags := Flags + [wbsSizeBorder,wbsSysMenu];
     End
     Else
     Begin
          Case FBorderStyle Of
            bsNone: ;
            bsSingle:   Include(Flags,wbsBorder);
            bsSizeable: Include(Flags,wbsSizeBorder);
            bsDialog:   Include(Flags,wbsDlgBorder);
          End;
          If biSystemMenu In FBorderIcons Then Include(Flags,wbsSysMenu);
          If biMinimize In FBorderIcons Then Include(Flags,wbsMinButton);
          If biMaximize In FBorderIcons Then Include(Flags,wbsMaxButton);
          If biHelp in FBorderIcons then Include(Flags,wbsHelp);
     End;

     For T := Low(TFrameStyle) To High(TFrameStyle) Do
        If Flags * [T] <> [] Then Result := Result Or FrameFlags[T];

     {$IFDEF OS2}
     If FDBCSStatusLine Then Result := Result Or FCF_DBE_APPSTAT;
     {$ENDIF}
End;


Procedure TForm.SetWindowState(NewState:TWindowState);
Var  Win:LongWord;
     WinStyle:LongWord;
     {$IFDEF Win32}
     Placement:WINDOWPLACEMENT;
     {$ENDIF}
Begin
     FWindowState := NewState;
     If Designed Then Exit;

     If Frame = Nil Then Exit;
     Win := Frame.Handle;
     If Win = 0 Then Exit;

     {$IFDEF OS2}
     Case NewState Of
        wsNormal:    WinStyle := SWP_RESTORE;
        wsMinimized: WinStyle := SWP_MINIMIZE;
        wsMaximized: WinStyle := SWP_MAXIMIZE;
     End;
     WinSetWindowPos(Win,HWND_TOP,0,0,0,0,WinStyle);
     {$ENDIF}

     {$IFDEF Win32}
     Case NewState Of
        wsNormal:    WinStyle := SW_NORMAL;
        wsMinimized: WinStyle := SW_SHOWMINIMIZED;
        wsMaximized: WinStyle := SW_SHOWMAXIMIZED;
     End;
     FillChar(Placement,SizeOf(Placement),0);
     Placement.Length := SizeOf(WINDOWPLACEMENT);
     GetWindowPlacement(Win,Placement);
     Placement.ShowCmd := WinStyle;        {alten l”schen?}
     SetWindowPlacement(Win,Placement);
     {$ENDIF}

End;


Function TForm.GetWindowState:TWindowState;
Var  Win:LongWord;
     WinStyle:LongWord;
     {$IFDEF Win32}
     Placement:WINDOWPLACEMENT;
     {$ENDIF}
Begin
     Result := FWindowState;
     If Designed Then Exit;

     If Frame = Nil Then Exit;
     Win := Frame.Handle;
     If Win = 0 Then Exit;

     {$IFDEF OS2}
     WinStyle := WinQueryWindowULong(Win,QWL_STYLE);
     If WinStyle And WS_MAXIMIZED <> 0 Then Result := wsMaximized
     Else
     If WinStyle And WS_MINIMIZED <> 0 Then Result := wsMinimized
     Else Result := wsNormal;
     {$ENDIF}

     {$IFDEF Win32}
     FillChar(Placement,SizeOf(Placement),0);
     Placement.Length := SizeOf(WINDOWPLACEMENT);
     GetWindowPlacement(Win,Placement);
     WinStyle := Placement.ShowCmd;
     If WinStyle = SW_SHOWMAXIMIZED Then Result := wsMaximized
     Else
     If WinStyle = SW_SHOWMINIMIZED Then Result := wsMinimized
     Else Result := wsNormal;
     {$ENDIF}
End;


Procedure TForm.SetBorderIcons(NewIcons:TBorderIcons);
Begin
     If (Handle = 0) Or Designed Then FBorderIcons := NewIcons;
End;


Procedure TForm.SetBorderStyle(NewStyle:TFormBorderStyle);
Begin
     If (Handle = 0) Or Designed Then FBorderStyle := NewStyle;
End;


Function TForm.GetTabOrder:LongInt;
Begin
     Result := -1;
End;

Procedure TForm.SetDBCSStatusLine(Value:Boolean);
Begin
     If Handle = 0 Then FDBCSStatusLine := Value;
End;


Function TForm.GetAddWidth:LongInt;
Begin
     Result := GetBorderWidth(Self);

     Inc(Result,Result);

     Inc(Result,GetLeftRightWidth(Self));
End;


Function TForm.GetAddHeight:LongInt;
Begin
     Result := GetBorderHeight(Self);

     Inc(Result,Result);

     If FMainMenu <> Nil Then
     Begin
          If FMainMenu.Handle <> 0 Then Inc(Result,FMainMenu.Height)
          Else Inc(Result,goSysInfo.Screen.MenuSize);
     End
     Else If ComponentState*[csHasMainMenu]<>[] Then
     Begin
          Inc(Result,goSysInfo.Screen.MenuSize);
     End;

     Inc(Result,goSysInfo.Screen.TitlebarSize );

     Inc(Result,GetTopBottomHeight(Self));

     If FDBCSStatusLine Then Inc(Result,DBCSStatusLineHeight);
End;


Function _GetAddWidth_(Form:TForm):LongInt;
Begin
     Result:=Form.GetAddWidth;
End;

Function _GetAddHeight_(Form:TForm):LongInt;
Begin
     Result:=Form.GetAddHeight;
End;


Function TForm.GetClientRect:TRect;
Begin
     Result := Inherited GetClientRect;

     If Handle = 0 Then
     Begin
          Dec(Result.Right, GetAddWidth);
          Dec(Result.Top, GetAddHeight);
     End;
End;


Procedure TForm.SetClientWidth(NewWidth:LongInt);
Begin
     Inc(NewWidth, GetAddWidth);

     Inherited SetClientWidth(NewWidth);
End;


Procedure TForm.SetClientHeight(NewHeight:LongInt);
Begin
     Inc(NewHeight, GetAddHeight);

     Inherited SetClientHeight(NewHeight);
End;


Function TForm.GetClientOrigin:TPoint;
Var List:TList;
    T:LongInt;
    Toolbar:TToolbar;
Begin
     Result := Inherited GetClientOrigin;

     Case FBorderStyle Of
       bsSingle:
       Begin
            Inc(Result.X, goSysInfo.Screen.BorderSize.CX);
            Inc(Result.Y, goSysInfo.Screen.BorderSize.CY);
       End;
       bsSizeable:
       Begin
            Inc(Result.X, goSysInfo.Screen.SizeBorderSize.CX);
            Inc(Result.Y, goSysInfo.Screen.SizeBorderSize.CY);
       End;
       bsDialog:
       Begin
            Inc(Result.X, goSysInfo.Screen.DlgBorderSize.CX);
            Inc(Result.Y, goSysInfo.Screen.DlgBorderSize.CY);
       End;
     End;
     
     List:=FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result.X,Toolbar.Size);
     End;

     List:=FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result.Y,Toolbar.Size);
     End;

     If FDBCSStatusLine Then Inc(Result.Y,DBCSStatusLineHeight);
End;


Procedure TForm.RealignControls;
Var  Control:TControl;
     T      :LongInt;
     LastActive:TForm;
Begin
     Inherited RealignControls;

     {Align MDI Child windows again}
     If FMDIChildren = Nil Then Exit;

     LastActive := ActiveMDIChild;

     If FMDIChildren <> Nil Then
     For T := 0 To FMDIChildren.Count-1 Do
     Begin
          Control := FMDIChildren.Items[T];
          If IsControl(Control) Then
          Begin
              If (Control.XAlign In [xaLeft,xaRight,xaCenter]) Or
                 (Control.YAlign In [yaBottom,yaTop,yaCenter]) Or
                 (Control.XStretch In [xsParent,xsFrame,xsScale]) Or
                 (Control.YStretch In [ysParent,ysFrame,ysScale]) Then
              Begin
                   Control.SetWindowPos(Control.Left,Control.Bottom,
                                        Control.Width,Control.Height);
              End;

          End;
     End;

     If LastActive <> Nil Then LastActive.BringToFront;
End;


Procedure TForm.AlignToolBars;
{$IFNDEF OS2}
Var  T:TToolbarAlign;
     ToolBar:TToolBar;
     t1,t2:LongInt;
     List:TList;
     rc,rc1:TRect;
     _Left,_Bottom,_Width,_Height:LongInt;
     TheBottom,TheLeft,TheTop,TheRight:LongInt;
     MaxLeft,MaxRight,MaxBottom,MaxTop:LongInt;

     Procedure AlignToolBar(ToolBar:TToolBar);
     Begin
        If Toolbar.FVisible Then
        Begin
             Case t Of
                tbTop:
                Begin
                     Toolbar.FLeft:=rc.Left-MaxLeft;
                     Toolbar.FBottom:=TheTop;
                     Toolbar.FWidth:=(rc.Right+1-rc.Left)+MaxLeft+MaxRight;
                     Toolbar.FHeight:=Toolbar.Size;
                     Inc(TheTop,Toolbar.Size);
               End;
               tbBottom:
               Begin
                    Toolbar.FLeft:=rc.Left-MaxLeft;
                    Toolbar.FBottom:=TheBottom;
                    Toolbar.FWidth:=(rc.Right+1-rc.Left)+MaxLeft+MaxRight;
                    Toolbar.FHeight:=Toolbar.Size;
                    inc(TheBottom,Toolbar.Size);
               End;
               tbLeft:
               Begin
                    Toolbar.FLeft:=rc.Left-MaxLeft+TheLeft;
                    Toolbar.FBottom:=MaxTop;
                    Toolbar.FWidth:=Toolbar.Size;
                    Toolbar.FHeight:=(rc.Top+1-rc.Bottom);
                    Inc(TheLeft,Toolbar.Size);
               End;
               tbRight:
               Begin
                    Toolbar.FLeft:=rc.Right+1+TheRight-Toolbar.Size;
                    Toolbar.FBottom:=MaxTop;
                    Toolbar.FWidth:=Toolbar.Size;
                    Toolbar.FHeight:=(rc.Top+1-rc.Bottom);
                    Dec(TheRight,Toolbar.Size);
               End;
             End; {Case}

             {$IFDEF WIN32}
             If Toolbar.Handle <> 0
             Then WinUser.SetWindowPos(Toolbar.Handle,0,
                                       Toolbar.FLeft,
                                       Toolbar.FBottom,
                                       Toolbar.FWidth,
                                       Toolbar.FHeight,
                                       SWP_SHOWWINDOW);
             {$ENDIF}
        End; //If Toolbar.FVisible

     End;
{$ENDIF}
Begin
     If Frame = Nil Then Exit;
     If Frame.Handle = 0 Then Exit;

     {$IFNDEF OS2}
     rc := Frame.GetClientRect;

     MaxLeft:=0;
     List:=FToolBarLists[tbLeft];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
     End;

     MaxRight:=0;
     List:=FToolBarLists[tbRight];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
     End;

     MaxBottom:=0;
     List:=FToolBarLists[tbBottom];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxBottom,Toolbar.Size);
     End;

     MaxTop:=0;
     List:=FToolBarLists[tbTop];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxTop,Toolbar.Size);
     End;

     //windows coordinates Grow from Top To Bottom !
     TheBottom:=(rc.Top+1-rc.Bottom)+MaxTop;
     TheTop:=0;
     TheLeft:=0;
     TheRight:=MaxRight;

     //zuerst Top und Bottom !

     For t := High(TToolbarAlign) Downto Low(TToolbarAlign) Do
     Begin
          List:=FToolBarLists[t];

          If List=Nil Then continue;

          If t=tbBottom Then
          Begin
               For t2:=List.Count-1 DownTo 0 Do AlignToolBar(TToolBar(List[t2]));
          End
          Else
          Begin
               For t2:=0 To List.Count-1 Do AlignToolBar(TToolBar(List[t2]));
          End;
     End;

     {ClientBereich}
     If Handle = 0 Then Exit;
     {$IFDEF WIN32}
     WinUser.GetClientRect(Frame.Handle,RECTL(rc1));
     {$ENDIF}

     rc := Frame.GetClientRect;
     _Width := rc.Right-rc.Left+1;
     _Height := rc.Top-rc.Bottom+1;
     _Left := rc.Left;
     _Bottom := ((rc1.Top-rc1.Bottom)-_Height)-rc.Bottom;
          
     {$IFDEF WIN32}
     WinUser.SetWindowPos(Handle,0,_Left,_Bottom,_Width,_Height, SWP_SHOWWINDOW);
     {$ENDIF}
     
     {$ENDIF}
//IFNDEF OS2

     {$IFDEF OS2}
     WinSendMsg(Frame.Handle, WM_UPDATEFRAME, GetFrameFlags, 0);
     {$ENDIF}
End;


Procedure TForm.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Begin
     If FFrame <> Nil Then
     Begin
          FFrame.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
          {$IFDEF OS2}
          FLeft := Frame.FLeft;
          FBottom := Frame.FBottom;
          FWidth := Frame.FWidth;
          FHeight := Frame.FHeight;
          {$ENDIF}
          Exit;
     End;
     Inherited SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
End;


Function TForm.GetMDIChildCount:LongInt;
Begin
     If FMDIChildren = Nil Then Result := 0
     Else Result := FMDIChildren.Count;
End;


Function TForm.GetMDIChild(AIndex:LongInt):TForm;
Begin
     Result := Nil;
     If FMDIChildren = Nil Then Exit;
     If (AIndex < 0) Or (AIndex > FMDIChildren.Count-1) Then Exit;
     Result := FMDIChildren.Items[AIndex];
End;


Procedure TForm.InsertMDIChild(Child:TForm);
Var  rc:TRect;
Begin
     Child.FParent := Self;
     ListAdd(FMDIChildren, Child);
     ListInsert(FMDIZOrder, 0, Child); // not yet the top mdi child

     If (Child.FWidth = 0) Or (Child.FHeight = 0) Then
     Begin
          rc := GetTileCascadeRect;
          Child.FLeft := rc.Left;
          Child.FBottom := rc.Bottom;
          Child.FWidth := rc.Right - rc.Left;
          Child.FHeight := rc.Top - rc.Bottom;
     End;

     If Handle <> 0 Then
     Begin
          Child.CreateWnd;
          If Child.FVisible Or Child.Designed Then Child.Show;
     End
     Else FInitControls := True;
End;


Procedure TForm.RemoveMDIChild(Child:TForm);
Begin
     ListRemove(FMDIChildren, Child);
     ListRemove(FMDIZOrder, Child);
End;


Function TForm.GetTopMDIChild:TForm;
Begin
     Result := Nil;
     If FMDIZOrder <> Nil Then
       If FMDIZOrder.Count > 0 Then Result := FMDIZOrder[FMDIZOrder.Count-1];
End;


Procedure TForm.CreateUniqueWindowId(AChild:TControl);
Begin
     If AChild <> Nil Then
     Begin
          AChild.FWindowId := FInternalWindowIdCount;
          Inc(FInternalWindowIdCount);
     End;
End;


Procedure TForm.CreateControls;
Var  AForm:TForm;
     I:LongInt;
Begin
     If Not FInitControls Then Exit;

     Inherited CreateControls;

     If FMainMenu <> Nil Then
       If FFrame <> Nil Then TMenu(FMainMenu).Show;

     For I := 0 To MDIChildCount-1 Do
     Begin
          AForm := MDIChildren[I];
          AForm.CreateWnd;
          If AForm.FVisible Or AForm.Designed Then AForm.Show;
     End;
End;


Procedure TForm.SetFormStyle(Value:TFormStyle);
Var  OldStyle:TFormStyle;
     P:LongInt;
Begin
     If Value <> FFormStyle Then
     Begin
          If ComponentState * [csReading] = [] Then
          Case Value Of
            fsMDIForm: color := clAppWorkSpace;
            fsMDIChild: color := clWindow;
            fsNormal: ;
          End;

          If (Value = fsMDIChild) And (Position = poDesigned)
          Then Position := poDefault;

          OldStyle := FFormStyle;
          If (OldStyle = fsMDIChild) Or (Value = fsMDIChild) Then
            If Parent Is TForm Then  {Update contents Of the lists}
            Begin {but only If already in a List}
                 If OldStyle = fsMDIChild
                 Then P := ListFind(TForm(Parent).FMDIChildren,Self)
                 Else P := ListFind(Parent.FControls,Self);

                 If P >= 0 Then {was already inserted}
                 Begin
                      Parent.RemoveControl(Self);
                      FFormStyle := Value;
                      Parent.InsertControl(Self);
                 End;
            End;
          FFormStyle := Value;
     End;
End;


Procedure TForm.BringToFront;
Var  Flags:LongWord;
Begin
     If FLocked Then Exit;

     {$IFDEF OS2}
     If Frame <> Nil Then
     Begin
          If {F}Visible Then Flags := SWP_SHOW
          Else Flags := 0;
          WinSetWindowPos(Frame.Handle,HWND_TOP,0,0,0,0,
                          Flags Or SWP_ZORDER Or SWP_ACTIVATE);
     End;
     {$ENDIF}

     {$IFDEF Win32}
     If Frame <> Nil Then
     Begin
          If {F}Visible Then Flags := SWP_SHOWWINDOW
          Else Flags := 0;
          WinUser.SetWindowPos(Frame.Handle,HWND_TOP,0,0,0,0,
                               Flags Or SWP_NOMOVE Or SWP_NOSIZE);
          SetForeGroundWindow(Handle);
     End;
     {$ENDIF}
     
End;


Procedure TForm.SendToBack;
Begin
     Inherited SendToBack;
End;


Procedure TForm.RemoveComponent(AComponent:TComponent);
Begin
     Inherited RemoveComponent(AComponent);

     If AComponent = FMainMenu Then FMainMenu := Nil;
End;


Procedure TForm.InsertControl(AChild:TControl);
Var  Toolbar:TToolbar;
Begin
     If AChild Is TForm Then
       If TForm(AChild).FormStyle = fsMDIChild Then
         If FormStyle = fsMDIForm Then
         Begin
              InsertMDIChild(TForm(AChild));
              Exit;
         End;

     Inherited InsertControl(AChild);

     If AChild.FIsToolBar Then
     Begin
          Toolbar := TToolbar(AChild);

          If ToolBar<>FMenuBar Then
            ListAdd(FToolBarLists[Toolbar.Alignment], Toolbar);

          If Handle <> 0 Then
          Begin
               Toolbar.CreateWnd;
               Toolbar.Show;
               AlignToolBars;
          End;
     End;                           
End;


Procedure TForm.RemoveControl(AChild:TControl);
Var  Toolbar:TToolbar;
Begin
     If FFormStyle = fsMDIForm Then
       If AChild Is TForm Then
         If TForm(AChild).FFormStyle = fsMDIChild
           Then RemoveMDIChild(TForm(AChild));

     Inherited RemoveControl(AChild);    {Destroy the Handle}

     If AChild.FIsToolBar Then
     Begin
          Toolbar := TToolbar(AChild);

          If ToolBar<>FMenuBar Then
            ListRemove(FToolBarLists[Toolbar.Alignment], Toolbar);
          AlignToolBars;
     End;
End;


Type
    {FAccelList Item}
    PAccelItem=^AccelItem;
    AccelItem=Record
         KeyCode:TKeyCode;
         Command:TCommand;
    End;


Procedure DestroyShortCuts(AForm:TForm);
Var  dummy:PAccelItem;
     T:LongInt;
Begin
     If AForm = Nil Then Exit;

     If AForm.FAccelList <> Nil Then
     Begin
          For T := 0 To AForm.FAccelList.Count-1 Do
          Begin
               dummy := AForm.FAccelList.Items[T];
               Dispose(dummy);
          End;

          AForm.FAccelList.Destroy;
          AForm.FAccelList := Nil;
     End;
End;


Procedure UpdateShortCuts(AForm:TForm);
{$IFDEF OS2}
Type PCharAccels=^TCharAccels;
     TCharAccels=Record
                       dummy:PAccelItem;
                       Next:PCharAccels;
                 End;
Var
     T,t1:LongInt;
     dummy,dummy1:PAccelItem;
     Temp:LongWord;
     CH:Char;
     aAccel:PAccelTable;
     CharAccels,TempCharAccel:PCharAccels;
Label weiter;
{$ENDIF}
{$IFDEF WIN32}
TYPE taccels=Array[0..MaxInt] Of WinUser.ACCEL;
VAR  lpaccel:^taccels;
     accitem:PAccelItem;
     virt:WORD;
     T:LongInt;
{$ENDIF}
Begin
     If AForm = Nil Then Exit;
     If AForm.Frame = Nil Then Exit;
     If AForm.Frame.Handle = 0 Then Exit;

     // release old accel table
     If AForm.FAccel <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSetAccelTable(AppHandle,0,AForm.Frame.Handle);  //Erase old
          WinDestroyAccelTable(AForm.FAccel);
          {$ENDIF}

          {$IFDEF WIN32}
          DestroyAcceleratorTable(AForm.FAccel);
          {$ENDIF}

          AForm.FAccel := 0;
     End;


     If Not AForm.ShortcutsEnabled Then exit;

     If AForm.FAccelList = Nil Then Exit;


     {$IFDEF OS2}
     CharAccels:=Nil;
     For T:=0 To AForm.FAccelList.Count-1 Do
     Begin
          dummy:=AForm.FAccelList.Items[T];
          If dummy^.KeyCode And kb_Char<>0 Then
          Begin
               Temp:=dummy^.KeyCode And 255;
               CH:=Chr(Temp);
               If UpCase(CH) In ['A'..'Z'] Then  //Add also uppercase/lowercase Version Of accel
               Begin
                   If CH=UpCase(CH) Then
                   Begin
                       //check lowercase Version
                       CH:=Chr(Ord(CH)+32);
                   End
                   Else
                   Begin
                       //Insert uppercase Version
                       CH:=Chr(Ord(CH)-32);
                   End;

                   //look If the ShortCut Is already present
                   For t1:=0 To AForm.FAccelList.Count-1 Do
                   Begin
                        dummy1:=AForm.FAccelList.Items[t1];
                        If dummy1^.KeyCode And kb_Char<>0 Then
                          If (dummy1^.KeyCode And Not 255)=(dummy^.KeyCode And Not 255) Then
                            If (dummy1^.KeyCode And 255)=Ord(CH) Then Goto weiter;
                   End;

                   If CharAccels=Nil Then
                   Begin
                        New(CharAccels);
                        TempCharAccel:=CharAccels;
                        TempCharAccel^.Next:=Nil;
                   End
                   Else
                   Begin
                        New(TempCharAccel);
                        TempCharAccel^.Next:=CharAccels;
                        CharAccels:=TempCharAccel;
                   End;
                   TempCharAccel^.dummy:=dummy;
               End;
weiter:
          End;
     End;

     While CharAccels<>Nil Do
     Begin
          New(dummy);
          dummy^:=CharAccels^.dummy^;
          CH:=Chr(dummy^.KeyCode And 255);
          dummy^.KeyCode:=dummy^.KeyCode And Not 255;
          If CH=UpCase(CH) Then
          Begin
               //Insert lowercase Version
               dummy^.KeyCode:=dummy^.KeyCode Or (Ord(CH)+32);
          End
          Else
          Begin
               //Insert uppercase Version
               dummy^.KeyCode:=dummy^.KeyCode Or(Ord(CH)-32);
          End;
          AForm.FAccelList.Add(dummy);
          TempCharAccel:=CharAccels^.Next;
          Dispose(CharAccels);
          CharAccels:=TempCharAccel;
     End;

     GetMem(aAccel,(AForm.FAccelList.Count*SizeOf(accel))+4);
     aAccel^.cAccel:=AForm.FAccelList.Count;
     aAccel^.codepage:=0;

     For T:=0 To AForm.FAccelList.Count-1 Do
     Begin
          dummy:=AForm.FAccelList.Items[T];
          With aAccel^.aAccel[T] Do
          Begin
               fs:=0;
               Temp:=dummy^.KeyCode And 255;
               If dummy^.KeyCode And kb_VK<>0 Then fs:=fs Or AF_VIRTUALKEY;
               If dummy^.KeyCode And kb_Ctrl<>0 Then fs:=fs Or AF_CONTROL;
               If dummy^.KeyCode And kb_Shift<>0 Then fs:=fs Or AF_SHIFT;
               If dummy^.KeyCode And kb_Alt<>0 Then fs:=fs Or AF_ALT;
               If dummy^.KeyCode And kb_Char<>0 Then fs:=fs Or AF_CHAR;
               If fs=0 Then fs:=AF_CHAR;
               key:=Temp;
               cmd:=dummy^.Command;
          End;
     End;

     AForm.FAccel:=WinCreateAccelTable(AppHandle,aAccel^);
     If AForm.FAccel<>0
     Then WinSetAccelTable(AppHandle,AForm.FAccel,AForm.Frame.Handle); //Set New

     FreeMem(aAccel,(AForm.FAccelList.Count*SizeOf(accel))+4);
     {$ENDIF}


     {$IFDEF WIN32}
     GetMem(lpaccel,(AForm.FAccelList.Count*SizeOf(WinUser.ACCEL)));

     For T := 0 To AForm.FAccelList.Count-1 Do
     Begin
          accitem := AForm.FAccelList[T];

          virt := FNOINVERT or FVIRTKEY;
          If accitem^.KeyCode And kb_Ctrl <> 0 Then virt := virt Or FCONTROL;
          If accitem^.KeyCode And kb_Shift <> 0 Then virt := virt Or FSHIFT;
          If accitem^.KeyCode And kb_Alt <> 0 Then virt := virt Or FALT;

          lpaccel^[T].fVirt := virt;
          lpaccel^[T].key := accitem^.KeyCode And $0FF;
          lpaccel^[T].cmd := accitem^.Command;
     End;

     AForm.FAccel := CreateAcceleratorTable(lpaccel^[0],AForm.FAccelList.Count);

     FreeMem(lpaccel,(AForm.FAccelList.Count*SizeOf(WinUser.ACCEL)));
     {$ENDIF}
End;


Procedure TForm.AddShortCut(KeyCode:TKeyCode;Command:TCommand);
Var  dummy:PAccelItem;
     T:LongInt;
Begin
     If Command=cmNull Then Exit;

     If FAccelList<>Nil Then
     Begin
          For T:=0 To FAccelList.Count-1 Do
          Begin
               dummy:=FAccelList.Items[T];
               If dummy^.KeyCode=KeyCode Then Exit;  //no Duplicates !
          End;
     End
     Else FAccelList.Create;

     New(dummy);
     dummy^.KeyCode:=KeyCode;
     dummy^.Command:=Command;

     FAccelList.Add(dummy);

     UpdateShortCuts(Self);
End;


Procedure TForm.DeleteShortCut(KeyCode:TKeyCode);
Var  dummy:PAccelItem;
     T:LongInt;;
     ACommand:TCommand;
Begin
     If FAccelList = Nil Then Exit;

     ACommand := -1;
     For T := FAccelList.Count-1 Downto 0 Do
     Begin
          dummy := FAccelList.Items[T];
          If (dummy^.KeyCode=KeyCode) Or (dummy^.Command=ACommand) Then
          Begin
               ACommand := dummy^.Command;
               FAccelList.Remove(dummy);
               Dispose(dummy);
          End;
     End;

     If FAccelList.Count = 0 Then
     Begin
          FAccelList.Destroy;
          FAccelList := Nil;
     End;

     UpdateShortCuts(Self);
End;


Procedure TForm.SetShortCutsEnabled(Value:Boolean);
Begin
     If Value <> FShortCutsEnabled Then
     Begin
          FShortCutsEnabled := Value;
          UpdateShortCuts(Self);
     End;
End;


Procedure TForm.DismissDlg(Result:TCommand);
Begin
     If FModalShowing Then
     Begin
          FModalResult := Result;
          If OnDismissDlg <> Nil Then OnDismissDlg(Self);
          If FModalResult <> cmNull Then EndModalState;
     End;
End;


Procedure TForm.CMEndModalState(Var Msg:TMessage);
Var  AParent:TControl;
Begin
     If FIsModal Then AParent := FModalParent
     Else AParent := Nil;

     {$IFDEF OS2}
     If AParent <> Nil Then
     Begin
          If AParent.FFrame <> Nil
          Then WinSetActiveWindow(HWND_DESKTOP,AParent.FFrame.Handle)
          Else WinSetActiveWindow(HWND_DESKTOP,AParent.Handle);
     End;

     DestroyHandle;
     {$ENDIF}

     {$IFDEF Win32}
     If AParent <> Nil Then
     Begin
          {If AParent.FFrame <> Nil
          Then SetForeGroundWindow(AParent.FFrame.Handle)
          Else SetForeGroundWindow(AParent.Handle);}
     End;

     DestroyHandle; 
     {$ENDIF}

     FModalShowing := False;
     Msg.Handled := True;
End;

Procedure TForm.EndModalState;
Begin
     PostMsg(Handle,CM_ENDMODALSTATE,0,0);
End;


Procedure TForm.Close;
Var  Action:TCloseAction;
     i, T : longint;

Begin
     If CloseQuery Then
     Begin
          {If FFormStyle = fsMDIChild Then Action := caMinimize
          Else} Action := caFree; {!! caHide?}

          {Martin0707}
          {Alle sonstigen Forms der Applikation schlieแen; Mainform.CloseQuery wurde
           schon berprft}
/*WD         if self = Application.Mainform then begin
            {Problem: Wenn Close = Destroy, dann wird die Forms Liste hinten verkrzt,
             also rueckwrts abarbeiten}
            for T := Screen.FormCount-1 downto 0 do begin
              if (Screen.Forms[T] <> self) and (Screen.Forms[T] <> nil) then begin
                if Screen.Forms[T].Showing then begin
                  Screen.Forms[T].Close;
                end;
              end;
            end;
          end; */

          If dsAutoCreate In DesignerState Then Action := caFreeHandle;

          If FOnClose <> Nil Then FOnClose(Self, Action);

          If Action = caNone Then Exit;

          If FModalShowing Then
          Begin
               DismissDlg(cmCancel);
               Exit;
          End;

          If Application <> Nil Then
          Begin
              If Application.MainForm = Self Then
              Begin
                   {$IFDEF OS2}
                   If ModalList <> Nil Then
                     For i := 0 To ModalList.Count-1
                      Do TForm(ModalList[i]).EndModalState;
                   {$ENDIF}

                   Application.FTerminate:=True;

                   {$IFDEF WIN32}
                   Application.Terminate;
                   {$ENDIF}

                   Release;
                   Exit;
              End;
          End;

          DoChangeActive(False);

          Case Action Of
            caHide: Hide;
            caFree: Release;  {Post Destroy}
            caMinimize: WindowState := wsMinimized;
            caFreeHandle: DestroyHandle;
          End;
     End;
End;


Function TForm.CloseQuery:Boolean;
Var  T:LongInt;
     Form:TForm;

Const LogFunc = 'CloseQuery: ';

Begin
  Application.LogWriteln(LogFunc);
  Result := true;

// 1. User-Code abfragen
  If OnCloseQuery <> Nil Then OnCloseQuery(Self,Result);
  Application.LogWriteln(LogFunc+'OnCloseQuery:'+iif(Result,'true','false'));
  {wenn in User-Code Abbruch des Schliess-Vorganges, dann nicht weitermachen}
  if not result then exit;

// 2. Kind-Forms schlieแen
  For T := 0 To ControlCount-1 Do
    Begin
      Form := TForm(Controls[T]);
      Application.LogWriteln(LogFunc+'Form: '+ Form.Name);
      If Form Is TForm Then
        Begin
          If Not Form.CloseQuery Then Exit;
        End
      Else
        Begin
          If Form.OnCloseQuery <> Nil Then
            Begin
              Form.OnCloseQuery(Form,Result);
              If not Result Then exit;
            End;
        End;
    End;

  If FMDIChildren <> Nil Then
     Begin
       For T := 0 To FMDIChildren.Count-1 Do
         Begin
           Form := FMDIChildren.Items[T];
           Application.LogWriteln(LogFunc+'MdiForm: '+ Form.Name);
           If Form Is TForm Then
             If Not Form.CloseQuery Then Exit;
         End;
     End;

// 3. Alle Forms der Applikation auf CloseQuery berprfen
  if (Application <> nil) and
     (self = Application.Mainform) then
    begin {Martin0207 von tForm.Close verschoben}
// Alle Forms der Applikation CloseQuery abfragen, nur nicht die Mainform
// Wenn eine Form CloseQuery FALSE hat, dann Schlieแvorgang abbrechen}
      for T := 0 to Screen.FormCount-1 do
        begin
          Form:=Screen.Forms[T];
          Application.LogWriteln(LogFunc+'Screen: '+ Form.Name);
          if (Form <> self) and (Form <> nil) then
            if not Form.CloseQuery then exit;
        end;
    end;
  Application.LogWriteln(LogFunc+'Exit');
End;

Procedure TForm.WriteInfoToINI(InfoLine : String);

Var CntrlInfo: String;
    ws  : TWindowState;
    wsC : Char;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiLoadFormINI]) then exit;

  ws:=GetWindowState;         // fWindowState enthaelt nicht den aktuellen Status
  case ws of
    wsNormal   : wsC:='N';
    wsMinimized: wsC:='M';
    wsMaximized: wsC:='X';
  end;
  setWindowState(wsNormal);  // Setzen auf Normalgroesse

  CntrlInfo:= TagINI_Form + tostr(Left)  + ';' +
                         tostr(Bottom)+ ';' +
                         tostr(Width) + ';' +
                         tostr(Height)+ ';' +
                         wsC +
              TagINI_End + InfoLine; //   ']' + iif(InfoLine='','',';'+InfoLine);

  inherited WriteInfoToINI(CntrlInfo);

End;

Function tForm.ReadInfoFromINI : String;

var TagInfoList: tStringList;
    l,b,w,h    : LongInt;
    ws         : TWindowState;
    wsc        : Char;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiSaveToINI]) or
     (SaveLoadInfo=false) then exit;

  result:=inherited ReadInfoFromINI;
  if result='' then exit;

  TagInfoList.Create;
  Result:=getInfoTag(TagINI_Form, Result, TagInfoList);
  try
    L :=StrToInt(TagInfoList.Strings[0]);
    B :=StrToInt(TagInfoList.Strings[1]);
    W :=StrToInt(TagInfoList.Strings[2]);
    H :=StrToInt(TagInfoList.Strings[3]);
    {Martin0308}
    if (*not Sizeable*)BorderStyle in [bsDialog]
      then SetWindowPos(L, B, Width, Height)
      else SetWindowPos (L, B, W, H);
    SetWindowPos(L, B, W, H);
    wsc:=TagInfoList.Strings[4][1];
    case wsc of
      'N' : ws:=wsNormal;
      'M' : ws:=wsMinimized;
      'X' : ws:=wsMaximized;
    end;
    SetWindowState(ws);
  except
  end;
  TagInfoList.Destroy;
End;

Destructor TForm.Destroy;

Begin

  if (Application<>nil) and (Application.ProgramIniFile<>nil) and
     (Application.FormInfoINI in [fiSaveToINI, fiSaveLoadINI])
    then WriteInfoToINI('');

  If FOnDestroy <> Nil Then FOnDestroy(Self);

  If Application <> Nil Then
    Begin
      Application.LogWriteln('tForm.Destroy:'+Name);
      If Application.MainForm = Self Then Application.Terminate; {End MsgLoop}
    End;

  If Screen.FActiveForm = Self Then Screen.FActiveForm := Nil;

  Screen.FForms.Remove(Self);

  If FModalShowing Then DismissDlg(cmCancel);

  If FIcon <> Nil Then
    Begin
      If TFormIcon(FIcon).IsLocalCopy Then FIcon.Destroy;
      FIcon := Nil;
    End;

  DestroyShortCuts(Self);


  {Martin0707 Windows requires to destroy the client window first and then
      the frame window, OS/2 requires reverse !!!!!!!!!!!!!!!!!}
  {$ifdef win32}
  Inherited Destroy;
  {$endif}
  {$ifdef os2}
  if Application.DestroyFormInOldMethode then
    inherited Destroy;
  {$endif}

  If FMDIChildren<>Nil Then FMDIChildren.Destroy;

  FMDIChildren:=Nil;

  If FFrame <> Nil Then
    Begin
      TFrameControl(FFrame).FChild := Nil;

      FFrame.Destroy;
      FFrame := Nil;
    End;

  {$ifdef os2}
  if Application.DestroyFormInOldMethode=false then
    inherited Destroy; {Martin0707}
  {$endif}

  If Application <> Nil Then
    Begin
      If Application.MainForm = Self Then Application.FMainForm := Nil;
      Application.LogWriteln('tForm.Destroy-Ende:'+Name);
    End;

  Screen.UpdateLastActive;
End;


Procedure TForm.SetupComponent;
Begin
  Inherited SetupComponent;

  If Designed Then Include(ComponentState, csReference);
  Caption := Name;
  AutoScroll := False;
  FParentPenColor := False;
  FParentColor := False;
  FColor := clDlgWindow;
  FShowHint := True;
  FWindowState := wsNormal;
  FBorderIcons := [biSystemMenu,biMinimize,biMaximize,biClose];
  FBorderStyle := bsSizeable;
  FFormStyle := fsNormal;
  FTileMode := tbNormal;
  FEnableDocking := [];
  FMoveable := True;
  FSizeable := True;
  FTabStop := False;
  FCursorTabStop := False;
  FActiveControl := Self;
  FFrame := Nil;
  FForm := Self;
  Include(ComponentState, csForm); {To decide SetupSCU}
  Include(ComponentState, csAcceptsControls);
  FShortCutsEnabled     := True;
  FPosition             := poDesigned;
  FInternalWindowIdCount:= cmInternalControlBase;
End;

Procedure TForm.ResetComponents;

Var CmpCou    : LongWord;

Begin
  for CmpCou:=0 to ComponentCount-1 do
    Components[CmpCou].ResetComponent;
End;



Constructor TForm.CreateIntern(AOwner:TComponent; Var AReference:TForm);
Begin
  AReference := Self;
  If Application <> Nil Then
    If Application.FMainForm = Nil Then Application.FMainForm := Self;

  TForm.Create(AOwner);
End;


Constructor TForm.Create(AOwner:TComponent);

Begin
  Include(ComponentState, csForm); {To decide SetupSCU}
                                   
  Inherited Create(AOwner);

// SCU/Properties-Informationen einlesen
  Asm
    PUSH DWord Ptr Self
    CALLN32 Classes.SetupFormSCU
  End;

// Language-Support
  FLanguageSupport:=(FLanguageSupport ) and (designed=false) and (Application.LanguageFile<>nil);

  If FOnCreate <> Nil Then FOnCreate(Self);

  If Not (csReference In ComponentState) Then
    If Screen.FForms.IndexOf(Self) < 0 Then Screen.FForms.Add(Self);

  if (Application<>nil) and (Application.ProgramIniFile<>nil) and
     (Application.FormInfoINI in [fiLoadFormINI, fiSaveLoadINI])
    then ReadInfoFromINI;
End;


Constructor TForm.CreateNew(AOwner:TComponent);
Begin
     Include(ComponentState, csForm); {To decide SetupSCU}

     Inherited Create(AOwner);

     If FOnCreate <> Nil Then FOnCreate(Self);

     If Not (csReference In ComponentState) Then
       If Screen.FForms.IndexOf(Self) < 0 Then Screen.FForms.Add(Self);
End;


Procedure TForm.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LonGInt);
Begin
     If ResName = rnIcon Then
     Begin
          If DataLen <> 0 Then If (FIcon = Nil) Or (FIcon.Empty) Then
          Begin
              If FIcon = Nil Then
              Begin
                   FIcon := TIcon.Create;
                   TFormIcon(FIcon).IsLocalCopy := True;
              End;
              Try
                 FIcon.ReadSCUResource(rnBitmap,Data,DataLen);
              Except
                 FIcon.Destroy;
                 FIcon := Nil;
              End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TForm.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FIcon <> Nil Then
       If Not FIcon.Empty Then
         If FIcon<>Application.FIcon Then Result := FIcon.WriteSCUResourceName(Stream,rnIcoN);
End;


{$HINTS OFF}
Procedure TForm.LoadedFromSCU(SCUParent:TComponent);
Begin
     Exclude(ComponentState,csHasMainMenu);

     {SCUParent Is Nil; because Form Is ON DeskTop Or Is Reference}
     Inherited LoadedFromSCU(Nil);
End;
{$HINTS ON}

Procedure TForm.CreateWnd;
Var  Temp:TControl;
     TopMDI:TForm;
     dist:LONGINT;
     {$IFDEF WIN32}
     SysMenu:LongWord;
     {$ENDIF}
Begin
     If Not Designed Then
       If FFormStyle = fsMDIChild Then
         If Parent Is TForm Then
           If TForm(Parent).FormStyle = fsMDIForm Then
           Begin
                TopMDI := TForm(Parent).ActiveMDIChild;

                If FPosition = poDefault Then
                Begin
                     If TopMDI = Self Then TopMDI := Nil;
                     If TopMDI <> Nil Then
                     Begin
                          dist := goSysInfo.Screen.SizeBorderSize.CY;
                          inc(dist, goSysInfo.Screen.TitlebarSize);
                          
                          SetBounds(TopMDI.Left+dist, TopMDI.Top+dist,
                                    TopMDI.Width, TopMDI.Height);
                     End
                     Else
                     Begin
                          SetBounds(0,0, (Parent.ClientWidth Div 3)*2,
                                    (Parent.ClientHeight Div 3)*2);
                     End;
                End;
           End;


     ShortCutsEnabled := False;

     If FIsModal And (Not Designed) Then
     Begin
          Temp := FParent;
          FParent := FModalParent; {?}
          FModalParent := Temp;
     End;


     Inherited CreateWnd;


     {$IFDEF WIN32}
     If Frame<>Nil Then
       If ((FBorderStyle<>bsNone)And(biSystemMenu In FBorderIcons)And
           (FormStyle <> fsMDIChild)) then
     Begin
          SysMenu := GetSystemMenu(Frame.Handle, False);

          If SysMenu<>0 Then
          Begin
               If FBorderStyle=bsDialog Then
               Begin
                    DeleteMenu(SysMenu, SC_TASKLIST, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, 7, MF_BYPOSITION);
                    DeleteMenu(SysMenu, 5, MF_BYPOSITION);
                    DeleteMenu(SysMenu, SC_MAXIMIZE, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, SC_MINIMIZE, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, SC_SIZE, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, SC_RESTORE, MF_BYCOMMAND);
               End
               Else
               Begin
                    If not (biMinimize In FBorderIcons) Then
                       EnableMenuItem(SysMenu, SC_MINIMIZE, MF_BYCOMMAND or MF_GRAYED);
                    If not (biMaximize in FBorderIcons) Then
                       EnableMenuItem(SysMenu, SC_MAXIMIZE, MF_BYCOMMAND or MF_GRAYED);
               End;
          End;
     End;
     {$ENDIF}

     ShortCutsEnabled := True;

     If Not Designed Then
       If DDEMan_OpenClientLinks<>Nil Then DDEMan_OpenClientLinks(Self); //Open DDE clients
End;


Procedure TForm.SetupShow;
Begin
  Inherited SetupShow;

  If FIcon <> Nil
    Then Icon := FIcon
    Else
      If ((Application <> Nil) And
          (Application.Icon <> Nil) And
          (Not Application.Icon.Empty)) Then
        Begin
          Icon := Application.Icon;
        End;

  If FActiveControl <> Nil Then FActiveControl.Focus;
End;


Function TForm.ShowModal:LongWord;
Var OldFParent: TControl;
    ex        : Boolean;
    {$IFDEF OS2}
    Queue:QMSG;
    {$ENDIF}
    {$IFDEF Win32}
    aMsg:WinUser.Msg;
    {$ENDIF}

Label again;
Begin
  If Designed Then
    Begin
      Show;
      Exit;
    End;

  FIsModal := True;
  FModalResult := cmNull;
  FWindowState := wsNormal;

  FModalShowing := True;

  OldFParent := FParent;
  FModalParent := Nil;

  If Handle = 0 Then CreateWnd;
  If Handle <> 0 Then LockDesktopWindows(True, Self);

  Show;
  BringToFront;
again:
  ex := False;
  Try
    Repeat
      If Application = Nil
        Then
          Begin
            {$IFDEF OS2}
            If WinPeekMsg(AppHandle,Queue,0,0,0,PM_REMOVE) Then
            Begin
                If Queue.Msg <> WM_QUIT Then
                  WinDispatchMsg(AppHandle,Queue);
            End;
            {$ENDIF}

            {$IFDEF Win32}
            If PeekMessage(aMsg,0,0,0,PM_REMOVE) Then
            Begin
                If aMsg.Message <> WM_QUIT Then
                Begin
                     TranslateMessage(aMsg);
                     DispatchMessage(aMsg);
                End;
            End;
            {$ENDIF}
          End
        Else Application.HandleMessage;
    Until Not FModalShowing;
    ex := False;
  Except
    On E:Exception Do
      Begin
        If Application <> Nil
          Then
            Begin
              Application.ExceptObject := E;
              Application.HandleException(Self);
              Application.ExceptObject := Nil;
            End
          Else Raise;
      End;
    ex := True;
  End;
  If ex Then goto again; // don't terminate dialog on exception

  Result := FModalResult;

  LockDesktopWindows(False, Self);

{$IFDEF Win32}
// Bei Windows bekommt der Owner nicht den Focus.
// Da der Owner bei den automatisch, generierten Formen nicht gefuellt wird, bekommt
// die MainForm den Focus.
  if Owner=nil
    then Application.MainForm.Focus
    else tForm(Owner).Focus;
{$ENDIF}

  FParent := OldFParent;
End;


Procedure TForm.SetActiveControl(AControl:TControl);
Begin
     If IsControl(AControl) Then AControl.Focus
     Else Focus;
End;


Function TForm.GetTileCascadeRect:TRect;
Begin
     Result := GetClientRect;
End;


Procedure TForm.CommandEvent(Var Command:TCommand);
Var  MsgHandled:Boolean;
Begin
     Inherited CommandEvent(Command);

     MsgHandled := True;
     Case Command Of
        cmExit: Application.MainForm.Close;
        cmClose: Close;
        cmTile: Tile;
        cmCascade: Cascade;
        cmNext: Next;
        cmPrevious: previous;
        cmCloseAll: CloseAll;
        cmMaximize: If ActiveMDIChild <> Nil Then ActiveMDIChild.WindowState := wsMaximized;
        cmMinimize: If ActiveMDIChild <> Nil Then ActiveMDIChild.WindowState := wsMinimized;
        cmRestore: If ActiveMDIChild <> Nil Then ActiveMDIChild.WindowState := wsNormal;
        cmCloseTop: If ActiveMDIChild <> Nil Then ActiveMDIChild.Close;
        cmHelpIndex: Application.HelpIndex;
        cmHelpContents: Application.HelpContents;
        cmHelpOnHelp: Application.HelpOnHelp;
        cmKeysHelp: Application.KeysHelp;
        cmHelp: Application.HHelp(HelpContext, HelpContextString);{Martin}
        Else MsgHandled := False;
     End; {Case}

     If MsgHandled Then Command := cmNull;
End;


Procedure TForm.Tile;
Var  ChildCnt:LongInt;
     Rows,Columns,ExtraCols,CurRow,CurCol:LongWord;
     Square:LongWord;
     aLeft,aBottom,aHeight,aWidth:LongInt;
     rec:TRect;
     Child:TForm;
     I:LongInt;
     LastActive:TForm;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren = Nil Then Exit;
     ChildCnt := FMDIChildren.Count;
     If ChildCnt = 0 Then Exit;

     LastActive := ActiveMDIChild;

     Case FTileMode Of
       tbHorizontal:
       Begin
            rec := GetTileCascadeRect;
            aLeft := rec.Left;
            aBottom := rec.Bottom;
            aHeight := (rec.Top - rec.Bottom) Div ChildCnt;
            aWidth := rec.Right - rec.Left;
            For I := 0 To ChildCnt-1 Do
            Begin
                 Child := FMDIChildren[I];
                 If Child.WindowState <> wsNormal
                   Then Child.WindowState := wsNormal;

                 aBottom := rec.Bottom + I*aHeight;
                 If I = ChildCnt-1 Then aHeight := rec.Top - aBottom;

                 Child.SetWindowPos(aLeft, aBottom, aWidth, aHeight);
            End;
       End;
       tbVertical:
       Begin
            rec := GetTileCascadeRect;
            aLeft := rec.Left;
            aBottom := rec.Bottom;
            aHeight := rec.Top - rec.Bottom;
            aWidth := (rec.Right - rec.Left) Div ChildCnt;
            For I := 0 To ChildCnt-1 Do
            Begin
                 Child := FMDIChildren[I];
                 If Child.WindowState <> wsNormal
                   Then Child.WindowState := wsNormal;

                 aLeft := rec.Left + I*aWidth;
                 If I = ChildCnt-1 Then aWidth := rec.Right - aLeft;

                 Child.SetWindowPos(aLeft, aBottom, aWidth, aHeight);
            End;
       End;
       tbNormal:
       Begin
            Square:=2;
            While Square*2<=ChildCnt Do Inc(Square);
            If ChildCnt=3 Then Square:=3;

            Columns:=Square-1;
            Rows:=ChildCnt Div Columns;
            ExtraCols:=ChildCnt Mod Columns;
            rec:=GetTileCascadeRect;

            aHeight:=(rec.Top-rec.Bottom) Div Rows;
            ChildCnt:=0;

            For CurRow:=0 To Rows-1 Do
            Begin
                 If Rows-CurRow<=ExtraCols Then Inc(Columns);
                 For CurCol:=0 To Columns-1 Do
                 Begin
                      aWidth:=rec.Right Div Columns;

                      If ChildCnt<FMDIChildren.Count Then
                      Begin
                           Child:=FMDIChildren[ChildCnt];
                           Inc(ChildCnt);

                           If Child.WindowState<>wsNormal
                           Then Child.WindowState:=wsNormal;

                           Child.SetWindowPos(aWidth*CurCol,
                                              rec.Top-(aHeight*(CurRow+1)),
                                              aWidth,
                                              aHeight);
                      End;
                 End;
                 If Rows-CurRow<=ExtraCols Then
                 Begin
                      Dec(Columns);
                      Dec(ExtraCols);
                 End;
            End;
       End;
     End;

     If LastActive <> Nil Then
     Begin
          LastActive.BringToFront;
          LastActive.CaptureFocus;
     End;
End;


Procedure TForm.Cascade;
Var  xloc,yloc,xlen,ylen:LongInt;
     XDiv,YDiv:LongWord;
     rec:TRect;
     T:LongInt;
     Child:TForm;
     LastActive:TForm;
Begin
         If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren=Nil Then Exit;

     LastActive := ActiveMDIChild;

     XDiv:=goSysInfo.Screen.SizeBorderSize.CX;
     Inc(XDiv,goSysInfo.Screen.TitlebarSize);

     YDiv:=goSysInfo.Screen.SizeBorderSize.CY;
     Inc(YDiv,goSysInfo.Screen.TitlebarSize);

     rec:=GetTileCascadeRect;
     xloc:=rec.Left;
     xlen:=rec.Right-rec.Left;
     yloc:=rec.Bottom;
     ylen:=rec.Top-rec.Bottom;
     For T:=0 To FMDIChildren.Count-1 Do
     Begin
          Child:=FMDIChildren[T];
          If Child <> LastActive Then
          Begin
               If Child.WindowState<>wsNormal Then Child.WindowState:=wsNormal;
               Child.SetWindowPos(xloc,yloc,xlen,ylen);
               Child.BringToFront;
               Inc(xloc,XDiv);
               Dec(xlen,XDiv);
               Dec(ylen,YDiv);
          End;
     End;


     If LastActive <> Nil Then
     Begin
          If LastActive.WindowState <> wsNormal Then LastActive.WindowState := wsNormal;
          LastActive.SetWindowPos(xloc,yloc,xlen,ylen);
          LastActive.BringToFront;
          LastActive.CaptureFocus;
     End;
End;


(*
Procedure TForm.ArrangeIcons;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     {$IFDEF OS2}
     {...}
     {$ENDIF}
     {$IFDEF Win32}
     If (FFormStyle = fsMDIForm) And (Handle <> 0)
     Then SendMessage(Handle,WM_MDIICONARRANGE,0,0);
     {$ENDIF}
End;
*)

Procedure TForm.Next;
Var Child:TForm;
    L:LongInt;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren = Nil Then Exit;
     If FMDIChildren.Count < 2 Then Exit;

     Child := ActiveMDIChild;
     L := FMDIChildren.IndexOf(Child);
     If L >= 0 Then
     Begin
        If L >= FMDIChildren.Count-1 Then L := 0
        Else Inc(L);
     End
     Else L := 0;
     Child := FMDIChildren.Items[L];
     Child.BringToFront;
     Child.CaptureFocus;
End;


Procedure TForm.Previous;
Var Child:TForm;
    L:LongInt;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren = Nil Then Exit;
     If FMDIChildren.Count < 2 Then Exit;

     Child := ActiveMDIChild;
     L := FMDIChildren.IndexOf(Child);
     If L >= 0 Then
     Begin
          If L = 0 Then L := FMDIChildren.Count-1
          Else Dec(L);
     End
     Else L := 0;
     Child := FMDIChildren.Items[L];
     Child.BringToFront;
     Child.CaptureFocus;
End;


Procedure TForm.CloseAll;
Var  Child:TForm;
     L:LongInt;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     For L := MDIChildCount-1 Downto 0 Do
     Begin
          Child := MDIChildren[L];
          Child.Close;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TApplication Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure MsgProc;
Begin
  Application.HandleMessage;
End;


Procedure ProcessProc;
Begin
  Application.ProcessMessage;
End;

Constructor TApplication.Create;

Var INILanguage  : String;
    PrmLanguage: String;
    Cou          : LongWord;
    PrinterName  : String;

// Analyse Standardparameter
var strParam: tStr20;
    strValue: tStr20;
    lenParam: Byte;

// Variablen fuer die Spracheauswahl
    FNExe: tFilename;
    Lng  : String;

Begin
  Asm
    MOV EAX,@Forms.MsgProc
    MOV uSysClass.MsgProc,EAX
    MOV EAX,@Forms.ProcessProc
    MOV uSysClass.ProcessProc,EAX
  End;
  FShowMainForm  :=True;
  fDestroyFormInOldMethode:=false;  // Loeschen der Form nach der neuen Methode.

{ Berechnen der ProgramName }
  FProgramPath:=goSysInfo.ProgramInfo.Path;
  FProgramName:=goSysInfo.ProgramInfo.Name;

{ Version berechnen }
  FProgramVersion:=1;
  FProgramSubVersion:=0;
  FProgramDate:=date;

{ FormPosaition Speicherung setzen }
  fFormInfoINI:=fiSaveLoadINI;

{ ParameterListe befuellen }
  fParameter.Create;
  for Cou:=0 to ParamCount do
    fParameter.Add(ParamStr(cou));

// Klassen-Variablen vorbelegen
  flog:=nil;
  fStartFromIDE:=false;

// Standard-Parameter analysieren
  PrmLanguage:='';
  for cou:=1 to fParameter.Count-1 do
    Begin
      strParam:=uppercase(fParameter.Strings[cou]);
      lenParam:=pos('=',strParam);
      if lenParam=0
        then  // Parameter ohne Werangabe
          Begin
            if strParam=paramWDSibylIDE then
              fStartFromIDE:=true
            else if strParam=paramLog then
              Begin
                try
                  flog.Create(Application.ProgramName);
                except
                  RunError(RunError_LOG);
                end;
              End;
          end
        else  // Parameter mit Wertangabe
          Begin
            strValue:=copy(strparam, LenParam+1,sizeof(strValue));
            strParam:=copy(strParam, 1, lenParam-1);
            if strParam = paramLanguage then     // Sprache Auswahl
              PrmLanguage:=copy(strValue,1,2)
            else if strParam=paramLog then
              Begin
                try
                  flog.Create(strValue);
                except
                  RunError(RunError_LOG);
                end;
              End;
          End;
    End;
  LogWriteln('Application-Name:' + GetExeName);

{ Ini-Datei }
  if MakeIniFile then
    Begin
      try
        FNExe:=FProgramPath+FProgramName;
        if UpperCase(FProgramName)='SIBYL'
          then FProgramIniFile.Create(FNExe+EXT_UC_INI +'_WD')  { Sibyl verwendet eine intern ASCII-INI-Datei }
          else FProgramIniFile.Create(FNExe+EXT_UC_INI);
        AppIniFile:=fProgramIniFile;  // Definiert in Classes
        LogWriteln('ProgramIniFile: ' + fProgramIniFile.Filename);
      except
        MakeIniFile:=false;
        AppIniFile:=nil;
        fProgramIniFile := nil;
        LogWriteln('ProgramIniFile: <Create-INI exception>');
      end;
    End
  else
    Begin
      AppIniFile:=nil;
      fProgramIniFile := nil;
    End;

// Printer ermitteln      
  try
    if Printer=nil
      then LogWriteln('Printer: <Variable=nil>')
      else
        if (Printer.Printers.Count>0) and (FProgramIniFile <> nil)
          then
            Begin
              PrinterName:=FProgramIniFile.ReadString(INI_Sec_Program,'Printer',
                                               Printer.Printers[Printer.PrinterIndex]);
              LogWriteln('Printer: '+PrinterName);
              Printer.PrinterIndex:=Printer.Printers.IndexOf(PrinterName);
            End
          else LogWriteln('Printer: <No found>');
  except
    LogWriteln('Printer: <Printer exception>');
  end;

// Sprachen einstellen
  if (PrmLanguage='') and (FProgramIniFile <> nil)
    then      // Sprache aus der INI oder aus dem System ermitteln
      Begin
        Lng:=FProgramIniFile.ReadString(INI_Sec_Program,'Language','');
        if Lng='' then //  Sprache nun aus dem System ermitteln
          Lng:=Copy(goSysinfo.Country.LangEnv,1,2);  // Nur die erste 2 Zeichen verwenden
      End
    else Lng:=PrmLanguage;
  if Lng='' then  // Wenn alles nix hilft, dann Default-Sprache verwenden
    Lng:='WDSIBYL_NLS_DEFAULT';

  SetCurrentLanguageTable(Lng);
  SetLanguage(CurrentLanguageTable);
  LogWriteln('Language: '+GetCurrentLanguage);

  Lng := FNExe+'_'+GetCurrentLanguageShort+EXT_UC_Language;
  if FileExists(Lng)
    then
      Begin
        LogWriteln('LanguageFile: ' + Lng);
        fLanguageFile.Create(Lng);
      End
    else
      Begin
        LogWriteln('LanguageFile: <No found>');
        fLanguageFile:=nil;
      End;

// Nachschauen ob das Programm von der IDE aufgerufen worden ist.
  if (fStartFromIDE) and (FProgramIniFile <> nil) then
    Begin
// Loeschen der Formpositionen --> Uebernehmen der Daten aus den Resourcen.
      LogWriteln('EraseSection: ' + INI_Sec_FormInfo);
      try
        FProgramIniFile.EraseSection(INI_Sec_FormInfo);
      except
      end;
    End;

  LogWriteln('Call Create');
  Inherited Create(Nil);    { Ruft die Funktion TApplication.SetupComponent auf }
  LogWriteln('TApplication.Create: Ende');
End;

Procedure TApplication.LogWriteln(iText : String);

Begin
  if flog<>nil then flog.Writeln(iText);
End;

Function TApplication.GetProgramVersionString : String;
{ Darstellen der Version in Stringformat}

Begin
  if fProgramSubVersion < 10
    then Result := '0' + toStr(fProgramSubVersion)
    else Result := toStr(fProgramSubVersion);
  Result:=toStr(fProgramVersion) + '.' + Result;
End;

Function TApplication.GetProgramAlreadyRunning : Boolean;

Begin
  Application.LogWriteln('GetProgramAlreadyRunning');
  Result:=false;
  try
    if GlobalMutex=nil
      then Application.LogWriteln('GetProgramAlreadyRunning: <No GlobalMutex>')
      else Result:=(GlobalMutex.Typ=SemaphorTypOpen);
  except
    Application.LogWriteln('GetProgramAlreadyRunning: <Exception>');
  end;
End;

Function TApplication.GetExeName:String;
Begin
  Result:=goSysInfo.ProgramInfo.ExeName;
End;

//Function TApplication.GetLanguage:String;
//Var S:String;
//Begin
//     Asm
//        LEA EAX,s
//        PUSH EAX
//        CALLN32 Classes.GetAppLanguage
//     End;
//     Result:=S;
//End;


Procedure TApplication.SetLanguage(Const NewLanguage:tLanguage);

Begin
  SysUtils.CurrentLanguageTable:=NewLanguage;
  fLanguage:=NewLanguage;
  Application.LogWriteln('SetLanguage:'+SysUtils.GetCurrentLanguage);
End;


Function TApplication.GetIcon:TGraphic;
Begin
     If FIcon = Nil Then
     Begin //Create Empty
          FIcon := TIcon.Create;
          TFormIcon(FIcon).IsLocalCopy := True;
     End;
     Result := FIcon;
End;

Procedure TApplication.SetIcon(NewIcon:TGraphic);
Begin
     If ((FIcon<>Nil)And(FIcon<>NewIcon)And(TFormIcon(FIcon).IsLocalCopy)) Then FIcon.Destroy;
     FIcon:=Nil;

     If ((NewIcon<>Nil)And(NewIcon<>FIcon)And(TFormIcon(NewIcon).IsLocalCopy)) Then
     Begin
          //Create A Copy !!
          Try
             NewIcon:=NewIcon.CopyGraphic;
             TFormIcon(NewIcon).IsLocalCopy:=True;
          Except
             NewIcon:=Nil;
          End;
     End;

     FIcon:=NewIcon;
End;


Procedure TApplication.SetupComponent;
{$IFDEF OS2}
Var  MemBuf:Array[0..11] Of Byte;
     cc:COUNTRYCODE;
{$ENDIF}

Var  FontName   : String;
     FontSizeStr: tStr5;
     FaceName   : String;
     PointSize  : LongWord;

Begin
     Inherited SetupComponent;

     Application := Self;
     {Martin} HelpHTMLHelp := false; {default is Winhelp and not HTML-Help}
     FHint := '';
     FShowHint := True;
     FHintPause := 1000;
     FHintPenColor := clInfoText;
     FHintColor := clInfo;
     FHintControl := Nil;
     FHintParent := Nil;
     FHintOwner := Nil;
     FHintOrigin := hiBottom;
     FMenuItemList.Create;

{ Font aus der INI-Datei lesen }
{$IFDEF OS2}
     if FProgramIniFile <> nil then
       FontName:=FProgramIniFile.ReadString(INI_Sec_Program,'Font','WarpSans,9');
{$ENDIF}
{$IFDEF Win32}
     if FProgramIniFile <> nil then
       FontName:=FProgramIniFile.ReadString(INI_Sec_Program,'Font','MS Sans Serif,8');
{$ENDIF}
     Split(FontName,',',FaceName,FontSizeStr);
     PointSize:=strToInt(FontSizeStr);
     FFont := Screen.GetFontFromPointSize(FaceName,PointSize);
     if fFont=nil then
       FFont := Screen.GetFontFromPointSize(FaceName,PointSize);

     FTerminate := False;
     FGradientTitlebar := False;

     {$IFDEF OS2}
     FDBCSSystem := False;
     cc.country := 0;
     cc.codepage := 0;
     If DosQueryDBCSEnv(12,cc,MemBuf) = 0 Then
       If (MemBuf[0] <> 0) And (MemBuf[1] <> 0) Then FDBCSSystem := True;
     {$ENDIF}
     {$IFDEF Win32}
     FDBCSSystem := False;
     {$ENDIF}
End;


Procedure TApplication.CreateForm(InstanceClass:TFormClass;Var Reference:TForm);
Var  OldMainForm:TForm;
Begin
     OldMainForm := FMainForm;

     Try
        Reference := InstanceClass.CreateIntern(Nil,Reference);
     Except
        On E:Exception Do
        Begin
             Reference := Nil;
             FMainForm := OldMainForm;
             If Application <> Nil Then
             Begin
                Application.ExceptObject := E;
                Application.HandleException(Self);
                Application.ExceptObject := Nil;
             End
             Else Raise;
        End;
     End;
End;


Type
     PForm=^TForm;
     PAutomaticRec=^TAutomaticRec;
     TAutomaticRec=Record
                         Form:PForm;
                         FormClass:TFormClass;
                   End;

Const AutomaticForms:TList=Nil;

Procedure RegisterAutomaticForm(FormClass:TFormClass;address:Pointer);
Var dummy:PAutomaticRec;
Begin
     If AutomaticForms=Nil Then AutomaticForms.Create;
     New(dummy);
     dummy^.Form:=address;
     dummy^.FormClass:=FormClass;
     AutomaticForms.Add(dummy);
End;

Procedure CreateAutomaticForms;
Var T:LongInt;
    Item:PAutomaticRec;
Begin
     If AutomaticForms<>Nil Then
     Begin
          For T:=0 To AutomaticForms.Count-1 Do
          Begin
               Item:=AutomaticForms[T];
               //main Form Is already created !!
               If Item^.Form^<>Application.FMainForm Then
                  Application.CreateForm(Item^.FormClass,Item^.Form^);
               Dispose(Item);
          End;
          AutomaticForms.Destroy;
     End;
End;


Procedure TApplication.Run;
Var i:LongInt;
    AForm:TForm;
    ex:Boolean;
    tmpHelpFile: tFilename;

Label again;
Begin
  {Martin (Idea of Aaron Lawrence) }
  {$ifdef os2}
  DosErrorAPI( FERR_DISABLEHARDERR );
  {This omits the ugly OS/2 error window e.g. if drive A: is not available
   Dies unterdrckt die dummen OS/2 Fehlerfenster z.B. wenn Laufwerk A: nicht verfgbar ist}
  {$endif}

  ex:=False;
  Try
    CreateAutomaticForms;

    If FMainForm = Nil Then Exit;

// Main-Icon laden
{$IFDEF SPDLL30}
//WD Der neue Compiler hat Probleme mit den Icons
{$ELSE}
    FIcon:=TIcon.Create;
    Try
      FIcon.LoadFromResourceId(1);
    Except
      FIcon.Destroy;
      FIcon:=Nil;
    End;
{$ENDIF}

// Fonts
    If Application.Font = Nil Then
      Application.Font:=MainForm.Font;

// Hauptfenster
    FMainForm.CreateWnd;
    If FMainForm.Handle = 0 Then RunFailed;

    if FProgramIniFile <> nil then
      Begin
        tmpHelpFile:=FProgramIniFile.ReadString(INI_Sec_Program,'HelpFile',
             FProgramPath+FProgramName+EXT_UC_HELP);
        if FileExists(tmpHelpFile)
          then
            Begin
              HelpFile:=tmpHelpFile;
              LogWriteln('HelpFile: '+ tmpHelpFile);
            End
          else LogWriteln('HelpFile: <No found>');
      End;

    If FShowMainForm Then
      FMainForm.Show;

// show all visible MDI Forms
    If FMainForm.FormStyle = fsMDIForm Then
      For i := 0 To Screen.FormCount-1 Do
      Begin
           AForm := Screen.Forms[i];
           If AForm <> FMainForm Then
             If AForm.FormStyle = fsMDIChild Then
               If AForm.Visible Then AForm.Show;
      End;

again:
    ex:=False;
    Try
       Repeat
          HandleMessage;
       Until Terminated;
    Except
       On E:Exception Do
       Begin
           ex:=True;
           ExceptObject := E;
           HandleException(Self);
           ExceptObject := Nil;
       End;
    End;
    If ex Then goto again; //don't terminate on exception
 Except
    On E:Exception Do
    Begin
         If ex Then raise; //don't show msg twice
         ExceptObject := E;
         HandleException(Self);
         ExceptObject := Nil;
    End;
  End;

  Try
     If DDEMan_CloseAllLinks<>Nil Then DDEMan_CloseAllLinks;
  Except
  End;
End;

Function TApplication.ProcessMessage:Boolean;
Var  Msg:TMessage;
     Handled:Boolean;
     {$IFDEF OS2}
     Queue:QMSG;
     {$ENDIF}
     {$IFDEF Win32}
     aMsg:WinUser.Msg;
     {$ENDIF}
Begin
  Result := False;
  {$IFDEF OS2}
  If WinPeekMsg(AppHandle,Queue,0,0,0,PM_REMOVE) Then
    Begin
      Result := True;
      If Queue.Msg = WM_QUIT
        Then
          Begin   // Programm wird beendet
            Try
              If (FMainForm <> Nil) and
                 (FMainForm.FFrame <> Nil) and
                 (Queue.hwnd = FMainForm.FFrame.Handle)
                Then FMainForm.Close;
            Finally
            End;
          End
        else      // Normale Verarbeitung
          Begin
            Handled := False;
            If FOnMessage <> Nil Then
              Begin
                FillChar(Msg,SizeOf(Msg),0);
                Msg.Receiver := Queue.HWND;
                Msg.ReceiverClass := HandleToControl(Queue.HWND);
                Msg.Msg := Queue.Msg;
                Msg.Param1 := Queue.mp1;
                Msg.Param2 := Queue.mp2;
                FOnMessage(Msg, Handled);
              End;
            If Not Handled Then WinDispatchMsg(AppHandle,Queue);
          End;
  End;
  {$ENDIF}

  {$IFDEF Win32}
  If PeekMessage(aMsg,0,0,0,PM_REMOVE) Then
    Begin
      Result := True;
      If aMsg.Message = WM_QUIT
        Then      // Programm wird beendet
          Begin
            Try
              If FMainForm <> Nil Then
                FMainForm.Close;
            Finally
            End;
          End
        else      // Normale Verarbeitung
          Begin
            Handled := False;
            If FOnMessage <> Nil Then
              Begin
                FillChar(Msg,SizeOf(Msg),0);
                Msg.Receiver := aMsg.HWND;
                Msg.ReceiverClass := HandleToControl(aMsg.HWND);
                Msg.Msg := aMsg.Message;
                Msg.Param1 := aMsg.WParam;
                Msg.Param2 := aMsg.LParam;
                FOnMessage(Msg, Handled);
              End;
            If Not Handled Then
              Begin
                TranslateMessage(aMsg);
                DispatchMessage(aMsg);
              End;
          End;
    End;
 {$ENDIF}
End;

Procedure TApplication.ProcessMessages;
Begin
     While ProcessMessage Do ;
End;


Procedure TApplication.HandleMessage;
Begin
     If Not ProcessMessage Then Idle;
End;


Procedure TApplication.Idle;
Var  Done:Boolean;
Begin
     Done := True;
     If FOnIdle <> Nil Then FOnIdle(Self, Done);
     {$IFDEF OS2}
     If Done Then WinWaitMsg(AppHandle,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     If Done Then WaitMessage;
     {$ENDIF}
End;


Procedure TApplication.Terminate;
{$IFDEF OS2}
Var  Msg:TMessage;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If MainForm <> Nil Then
     Begin
          FillChar(Msg,SizeOf(Msg),0);
          Msg.Receiver := MainForm.Handle;
          Msg.ReceiverClass := MainForm;
          Msg.Msg := WM_CLOSE;
          MainForm.DefaultHandler(Msg);
          {DefaultHandler posts WM_QUIT To Queue}
     End;
     {$ENDIF}
     {$IFDEF Win32}
     {Martin0507}if HelpHtmlHelp then begin
       FreeHtmlHelp;
       FHelpWindow := 0;
     end;
     PostQuitMessage(0);
     {$ENDIF}
End;

Function tApplication.TextException(E:Exception) : String;

Begin
  result:=E.Message+' at '+tohex(LONGWORD(E.ExcptAddr))+' !'#13#10+
          LoadNLSStr(STerminateProgram)
End;

Procedure TApplication.HandleException(Sender:TObject);
Begin
  LogWriteln('Handle Exception:' + TextException(ExceptObject));
  if fLog<>nil then fLog.Destroy;
  fLog:=nil;
  If FOnException = Nil
    then ShowException(ExceptObject)
    else FOnException(Sender,ExceptObject);
End;


Procedure TApplication.ShowException(E:Exception);
Begin
  If MessageBox2(TextException(E),mtCritical,mbYesNo)=mrYes
    Then Raise E;
End;


  {Martin}
  function ModifyExtension (Name : string; Ext : string{without dot}) : string;
    var
      I, posp : byte;
    begin
      posp := 0; for I := 1 to length(Name) do if Name[I] = '.' then posp := I;
      if posp = 0 then result := Name + '.' + Ext
      else result := copy (Name, 1, posp) + Ext;
    end;

Procedure TApplication.HelpIndex;
Begin
     {$IFDEF OS2}
     If FHelpWindow <> 0 Then
     Begin
          WinSendMsg(FHelpWindow,HM_HELP_INDEX,0,0);
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     If HelpFile <> '' Then
     Begin
        if {Martin}HelpHTMLHelp then
          HTMLhelp (HWND_DESKTOP, ModifyExtension (HelpFile, 'chm')+'::/'+HtmlHelpIntroPage, HH_DISPLAY_INDEX, 0)
        else
          WinHelp(HWND_DESKTOP, HelpFile, HELP_FINDER, 0);
     End;
     {$ENDIF}
End;


Procedure TApplication.KeysHelp;
Begin
     {$IFDEF OS2}
     If FHelpWindow <> 0 Then
     Begin
          If FKeysHelpContext <> 0 Then
          Begin
               HelpContext(FKeysHelpContext);
               exit;
          End;
          WinSendMsg(FHelpWindow,HM_KEYS_HELP,0,0);
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     If HelpFile <> '' Then
     Begin
          If FKeysHelpContext <> 0 Then
          Begin
               HelpContext(FKeysHelpContext);
               exit;
          End;
          if {Martin}HelpHTMLhelp then
            HTMLHelp (HWND_DESKTOP, ModifyExtension (HelpFile, 'chm')+'::/'+HtmlHelpIntroPage, 0, 0)
          else
            WinHelp(HWND_DESKTOP, HelpFile, HELP_KEY, 0);
     End;
     {$ENDIF}
End;


Procedure TApplication.HelpOnHelp;
Begin
     {$IFDEF OS2}
     If FHelpWindow <> 0 Then
     Begin
          WinSendMsg(FHelpWindow,HM_DISPLAY_HELP,0,0);
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     if HelpFile <> '' Then
     Begin
          if {Martin}HelpHTMLhelp then
            HTMLHelp (HWND_DESKTOP, ModifyExtension (HelpFile, 'chm')+'::/'+HtmlHelpIntroPage, 0, 0)
          else
            WinHelp(HWND_DESKTOP, HelpFile, HELP_HELPONHELP, 0);
     End;
     {$ENDIF}
End;


Procedure TApplication.HelpContents;
Begin
     {$IFDEF OS2}
     If FHelpWindow <> 0 Then
     Begin
          WinSendMsg(FHelpWindow,HM_HELP_CONTENTS,0,0);
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     If HelpFile <> '' Then
     Begin
          if {Martin}HelpHTMLhelp then
            HTMLHelp (HWND_DESKTOP, ModifyExtension (HelpFile, 'chm')+'::/'+HtmlHelpIntroPage, HH_DISPLAY_TOC, 0)
          else
            WinHelp(HWND_DESKTOP, HelpFile, HELP_FINDER, 0);
     End;
     {$ENDIF}
End;


Function TApplication.HelpJump(Const JumpId:String):Boolean;
{$IFDEF OS2}
Var  CS:Cstring;
{$ENDIF}
Begin
     Result := False;
     If FHelpWindow <> 0 Then
     Begin
          {$IFDEF OS2}
          CS := JumpId;
          Result := (WinSendMsg(FHelpWindow,HM_DISPLAY_HELP,
                                LongWord(@CS),HM_PANELNAME) = 0);
          {$ENDIF}
     End;
End;


Function TApplication.Help(context:THelpContext):Boolean;
Begin
  If FOnHelp <> Nil
    Then FOnHelp(context,Result)
    Else Result := HelpContext(context);
End;


Function TApplication.HelpContext(context:THelpContext):Boolean;
Begin
     If context = 0 Then
     Begin
          HelpContents;
          Result := True;
     End
     Else
     Begin
          Result := False;
          {$IFDEF OS2}
          If FHelpWindow <> 0 Then
          Begin
               Result := (WinSendMsg(FHelpWindow,HM_DISPLAY_HELP,
                          LongWord(context),HM_RESOURCEID) = 0);
          End;
          {$ENDIF}
          {$IFDEF WIN32}
          If HelpFile <> '' Then
          Begin
               Result := WinHelp(HWND_DESKTOP{Martin}, HelpFile, HELP_CONTEXT, context);
          End;
          {$ENDIF}
     End;
End;


{Martin}
Function TApplication.HHelp(context:THelpContext; contextstring : string):Boolean;
Begin
 If FOnHelp <> Nil
   Then FOnHelp(context,Result)
   Else Result := HHelpContext(context, contextstring);
End;

{Martin}
Function TApplication.HHelpContext(context:THelpContext; contextstring : string):Boolean;
Begin
     If context = 0 Then
     Begin
          HelpContents;
          Result := True;
     End
     Else
     Begin
          Result := False;
          {$IFDEF OS2}
          HelpContext(context);
          {$ENDIF}
          {$IFDEF WIN32}
          If HelpFile <> '' Then
          Begin
             if {Martin}HelpHTMLhelp then
               HTMLHelp (HWND_DESKTOP, ModifyExtension (HelpFile, 'chm')+'::/'+contextstring+'.html', HH_DISPLAY_TOPIC, 0)
             else
               HelpContext(context);
          End;
          {$ENDIF}
     End;
End;


Procedure TApplication.RunFailed;
Begin
  ErrorBox2(LoadNLSStr(SMainWindowFailed)+'. '+LoadNLSStr(SProgramAborted)+'.');
  Halt(0);
End;


Destructor TApplication.Destroy;

Var AForm     : TForm;
    strPrinter: String;

Begin
  LogWriteln('Application.Destroy');
  {FMainForm.Destroy;}

  { Help-Programm schliessen }
  LogWriteln('HelpWindow:'+toStr(FhelpWindow));
  If FHelpWindow <> 0 Then
    Begin
     {$IFDEF OS2}
        WinDestroyHelpInstance(FHelpWindow);
     {$ENDIF}
     {$IFDEF WIN32}
//     {Martin}if HelpHTMLhelp then FreeHtmlHelp;
     {$ENDIF}
    End;

// Die offene INI-Datei soll geschlossen werden
// SysUtils.Language auf Application.Language um den LanguageName zu ermitteln
  LogWriteln('Write ProgramIniFile');
  if FProgramIniFile <> nil then
    Begin
//      CurrentLanguageTable:=fLanguage;
      FProgramIniFile.WriteString(INI_Sec_Program,'Name',GetExeName);
      FProgramIniFile.WriteString(INI_Sec_Program,'Language',GetCurrentLanguageTable);

      FProgramIniFile.WriteString(INI_Sec_Program,'Help',HelpFile);
      FProgramIniFile.WriteString(INI_Sec_Program,'Font', Font.FaceName+','+tostr(Font.PointSize));
      strPrinter:='';
      try
        if (Printer.Printers.Count>0) and
           (Printer.PrinterIndex>=0) then
          strPrinter:=Printer.Printers[Printer.PrinterIndex];
      except
      end;
      FProgramIniFile.WriteString(INI_Sec_Program,'Printer',strPrinter);
    End;                     

  LogWriteln('Destroy FMenuItemList');
  FMenuItemList.Destroy;
  FMenuItemList:=Nil;

//Destroy All DeskTop Forms
  LogWriteln('Screen.Forms.Cnt:'+toStr(Screen.FForms.Count));
  While Screen.FForms.Count > 0 Do
    Begin
      AForm:=Screen.FForms[0];
      AForm.Destroy;
    End;

// Close Language-Tabe
  LogWriteln('Destroy Language-File');
  if fLanguageFile<>nil then fLanguageFile.Destroy;

// Schliessen der INI-Datei
  SetProgramIniFile(nil);

// Parameterliste entfernen
  LogWriteln('Destroy Parameterlist');
  fParameter.Destroy;

// End-Logging;
  if fLog<>nil then flog.Destroy;
  fLog:=nil;

  Inherited Destroy;
End;


Function TApplication.GetHelpFile:String;
Begin
  Result := '';
  If FHelpFile <> Nil Then Result := FHelpFile^;
End;


Procedure TApplication.SetHelpFile(NewName:String);

{$IFDEF OS2}
Var aHelpInit:HELPINIT;
    C,c1:Cstring;
    rec:TRect;
{$ENDIF}

Begin
{03/2006: You have to initialize Help in Mainform.Setupshow, because Mainform.Frame.Handle has to be defined!}
  AssignStr(FHelpFile,NewName);
  Application.LogWriteln('SetHelpFile: ' + NewName);

  {$IFDEF OS2}
  Application.LogWriteln('SetHelpFile.MainForm:' + toHex(longWord(FMainForm)));
  if FMainForm = nil then exit;
  Application.LogWriteln('SetHelpFile.MainForm_Frame:' + toHex(longWord(FMainForm.Frame)));
  if FMainForm.Frame = nil then exit;
  If FHelpWindow <> 0 Then WinDestroyHelpInstance(FHelpWindow);

  C := HelpWindowTitle;
  aHelpInit.pszHelpWindowTitle := @C;
  c1 := HelpFile;
  aHelpInit.pszHelpLibraryName := @c1;
  aHelpInit.cb := SizeOf(HELPINIT);
  aHelpInit.ulReturnCode := 0;
  aHelpInit.pszTutorialname := Nil;
  aHelpInit.phtHelptable := Nil{Pointer($FFFF0000 Or Attr.ResourceId)};
  aHelpInit.hmodHelptableModule := 0{Attr.ResourceModule};
  aHelpInit.hmodAccelActionBarModule := 0;
  aHelpInit.idAcceltable := 0;
  aHelpInit.idActionBar := 0;
  aHelpInit.fShowPanelID := 0;
  FHelpWindow := WinCreateHelpInstance(AppHandle,aHelpInit);

  If FHelpWindow <> 0 Then
  Begin
       WinAssociateHelpInstance(HelpWindow,FMainForm.Frame.Handle);

       rec.Left := 0;
       rec.Right := Screen.Width Div 2;
       rec.Bottom := 0;
       rec.Top := Screen.Height;
       WinSendMsg(FHelpWindow,HM_SET_COVERPAGE_SIZE,LongWord(@rec),0);
  End
  {Martin: more detailed error message}
  Else ErrorBox2(LoadNLSStr(SAppHelpFailed)+' ('+Application.Helpfile+')');
  {$ENDIF}

End;


Function TApplication.GetHelpWindowTitle:String;
Begin
  Result := '';
  If FHelpWindowTitle <> Nil Then Result := FHelpWindowTitle^;
End;


Procedure TApplication.SetHelpWindowTitle(NewTitle:String);
Begin
  AssignStr(FHelpWindowTitle,NewTitle);
End;


Procedure TApplication.SetHint(Const NewText:String);
Begin
     If FHint <> NewText Then
     Begin
          FHint := NewText;
          If FOnHint <> Nil Then FOnHint(Self);
     End;
End;


Procedure TApplication.HintTimerExpired;
Var  HintInfo:THintInfo;
     CanShow:Boolean;
     MousePos:TPoint;
     BubbleSizeX,BubbleSizey:LongInt;
     BubbleText:String;
     HintRect:TRect;
Begin
     If FHintTimer <> Nil Then FHintTimer.Destroy;
     FHintTimer := Nil;
     If FHintControl = Nil Then Exit;
     If FHintControl.Designed Then Exit;
//     If Not FHintControl.Enabled Then Exit;

     If Not FHasFocus Then exit;
     If FHintWindow = Nil Then
     Begin
          FHintWindow := HintWindowClass.Create(Nil);
          FHintWindow.CreateWnd;
     End
     Else
     Begin
         {$IFDEF WIN32}
         FHintWindow.Left:=-1000;
         ShowWindow(FHintWindow.Handle,SW_SHOWNA);
         {$ENDIF}
     End;

     MousePos := Screen.MousePos;

     If Screen.GetControlFromPoint(MousePos) = Nil Then exit;

     BubbleText := GetShortHint(FHintControl.FHint^);
     If BubbleText = '' Then Exit;

     FHintWindow.Canvas.GetTextExtent(BubbleText,BubbleSizeX,BubbleSizeY);
     inc(BubbleSizeX,6);
     inc(BubbleSizeY,4);
     BubbleSizeX:=0;
     BubbleSizeY:=0;

     {Position der Bubble anpassen}
     HintRect.Left := MousePos.X;
     If FHintOrigin = hiBottom
       Then HintRect.Bottom := MousePos.Y - 15 - BubbleSizeY
       Else HintRect.Bottom := MousePos.Y;

     HintInfo.HintControl := FHintControl;
     HintInfo.HintPos := Point(HintRect.Left,HintRect.Bottom);
     HintInfo.HintMaxWidth := Screen.Width;
     HintInfo.HintColor := FHintColor;
     HintInfo.HintPenColor := FHintPenColor;
     HintInfo.CursorRect := FHintControl.WindowRect;
     HintInfo.CursorPos := MousePos;

     CanShow := True;
     If FOnShowHint <> Nil Then FOnShowHint(BubbleText,CanShow,HintInfo);
     If Not CanShow Then Exit;

     FHintWindow.Color := HintInfo.HintColor;
     FHintWindow.PenColor := HintInfo.HintPenColor;

     HintRect.Left := HintInfo.HintPos.X;
     HintRect.Bottom := HintInfo.HintPos.Y;
     HintRect.Right:= 0; // HintRect.Left + BubbleSizeX;
     HintRect.Top := 0; // HintRect.Bottom + BubbleSizeY;

     //hier evtl. Word Wrap
     If HintInfo.HintMaxWidth < BubbleSizeX Then
     Begin
          HintRect.Right := HintRect.Left + HintInfo.HintMaxWidth;
     End;

     FHintWindow.ActivateHint(HintRect, BubbleText);

     FHintOwner := FHintControl;
     FHintParent := FHintControl.Parent;
End;


Procedure TApplication.DestroyHintWindow;
Begin
  If FHintOwner = Nil Then Exit; {no Hint Is Showing}
  FHintOwner := Nil;
  FHintParent := Nil;
  FHintWindow.DeactivateHint;
End;


Function TApplication.NewMenuItem(Entry:TMenuItem):TCommand;
Begin
  Result := FMenuItemList.Count + cmInternalMenuItemBase;
  FMenuItemList.Add(entry);
End;


Procedure TApplication.DeleteMenuItem(entry:TMenuItem);
Var  idx:LongInt;
Begin
  if FMenuItemList = nil then exit;
  idx := FMenuItemList.IndexOf(entry);
  If idx >= 0 Then 
    FMenuItemList.Items[idx] := Nil;
  Idx := Pred(fMenuItemList.Count);
  while (idx>=0) AND (fMenuItemList.Items[idx] = NIL) do
    begin
      fMenuItemList.Delete (idx);
      Dec(idx);
    end;
End;


Function TApplication.GetMenuItem(Command:TCommand):TMenuItem;
Var  idx:LongInt;
Begin
     idx := Command - cmInternalMenuItemBase;
     If (idx >= 0) And (idx < FMenuItemList.Count) Then
     Begin
          Result := TMenuItem(FMenuItemList.Items[idx]);
          If Not (Result Is TMenuItem) Then Result := Nil;
     End
     Else Result := Nil;
End;


Procedure TApplication.SetFont(NewFont:TFont);
Var  Form:TForm;
     I:LongInt;
Begin
     If FFont <> NewFont Then
     Begin
          DereferenceFont(FFont,True);
          FFont := NewFont;
          ReferenceFont(FFont);
     End;

     For I := 0 To Screen.FormCount-1 Do
     Begin
          Form := Screen.Forms[I];
          If Not Form.Designed Then
            If Form.ParentFont Then
            Begin
                 Form.SetFont(FFont);
                 Form.FParentFont := True;
            End;
     End;
End;

Procedure TApplication.SetProgramIniFile(Const iIniFile :  TIniFile);

Begin
  if iIniFile=nil
    then
      Begin
        if FProgramIniFile=nil then exit;  // Die INI-Datei ist bereits geschlossen --> Procedure verlassen
        FProgramIniFile.Destroy;
        FProgramIniFile:=Nil;
        exit;
      End
    else
      Begin
        if fProgramIniFile<>nil             // Aktuelle Datei schliessen
          then fProgramIniFile.Destroy;
        fProgramIniFile:=iIniFile;
      End;
  AppIniFile:=fProgramIniFile;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: THintWindow Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure THintWindow.SetupComponent;
Begin
  Inherited SetupComponent;

  Font := Screen.SmallFont;
  {$IFDEF WIN32}
  Ownerdraw := True;
  {$ENDIF}
  Include(ControlStyle,csHintWindow);
End;

{$IFDEF WIN32}
Procedure THintWindow.GetClassData(Var ClassData:TClassData);
Begin
  Inherited GetClassData(ClassData);
  {$IFDEF WIN32}
  CreateSubClass(ClassData,'BUTTON');
  {$ENDIF}
End;

Procedure THintWindow.CreateParams(Var Params:TCreateParams);
Begin
  Inherited CreateParams(Params);
  Params.Style := Params.Style Or BS_USERBUTTON Or WS_DISABLED Or WS_POPUP;
End;

Procedure THintWindow.CreateWnd;

Begin
  {$IFDEF WIN32}
  FLeft:=-1000;
  {$ENDIF}

  Inherited CreateWnd;

  {$IFDEF WIN32}
  ShowWindow(Handle,SW_SHOWNA);
  {$ENDIF}
End;
{$ENDIF}


Procedure THintWindow.Redraw(Const rec:TRect);
Var  rc      : TRect;
     CntText : Longint;
     h,y,cou : LongInt;

Begin
  If Canvas = Nil Then exit;

  Canvas.Pen.Color := PenColor;
  Canvas.Brush.Color := Color;
  Inherited Redraw(rec);

  Canvas.Brush.Mode:=bmTransparent;
  h:=Canvas.TextHeight(Caption);
  cntText:=fHintText.Count-1;
  y:=2+(CntText*h);
  for cou:=0 to CntText do
    Begin
      Canvas.TextOut(3,y,fHintText[cou]);
      dec(y,h);
    End;

//  Canvas.TextOut(3,2, Caption);

  Canvas.Brush.Mode:=bmOpaque;

  rc := ClientRect;
  Canvas.ShadowedBorder(rc,clWhite,clBlack);
  InflateRect(rc,-1,-1);
  Canvas.ShadowedBorder(rc,Color,clDkGray);
End;

Procedure THintWindow.ActivateHint(Rect:TRect; Const AHint:String);

var CntText : LongInt;
    h,w     : LongInt;

Begin
  Caption := AHint;
  if fHintText=nil then
    fHintText.Create;
  fHintText.Clear;
  CntText:=SplitAll(AHint, #13, fHintText);

  WindowRect := Rect;

  If Rect.Left + Width > Screen.Width Then Rect.Left := Screen.Width - Width;
  If Rect.Left < 0 Then Rect.Left := 0;
  If Rect.Bottom + Height > Screen.Height Then Rect.Bottom := Screen.Height - HeIght;
  If Rect.Bottom < 0 Then Rect.Bottom := 0;

  if (Rect.Right=0) and (Rect.Top=0) then
    Begin
      w:=7;
      if Canvas=nil
        then h:=16
        else h:=Canvas.TextHeight(AHint);
      Height:=3+(CntText*h);
      Width:=6+(fHintText.MaxLength*w);
    End;

  SetWindowPos(Rect.Left, Rect.Bottom, Width, Height);
  Show;
End;


Procedure THintWindow.DeactivateHint;
Begin
  Hide;
  if fHintText<>nil then
    Begin
      fHintText.Destroy;
      fHintText:=nil;
    End;
End;

///////////////////////////////////////////////////////////////////////

Type
    THiddenWindow=Class(TControl)
      Private
         {$IFDEF OS2}
         Procedure WMInitMenu(Var Msg:TMessage); Message WM_INITMENU;
         Procedure WMMenuEnd(Var Msg:TMessage); Message WM_MENUEND;
         Procedure WMMenuSelect(Var Msg:TMessage); Message WM_MENUSELECT;
         Function GetData(Handle:LongWord;Var Menu:TPopupMenu;Var entry:TMenuItem):TForm;
         {$ENDIF}
         Procedure WMTimer(Var Msg:TWMTimer); Message WM_TIMER;
    End;

{$IFDEF OS2}
Function THiddenWindow.GetData(Handle:LongWord;Var Menu:TPopupMenu;Var entry:TMenuItem):TForm;
Begin
  entry := Pointer(WinQueryWindowULong(Handle,QWL_USER));  {Get VMT Pointer}

  If entry Is TMenuItem
    Then Menu := TPopupMenu(entry.Menu)
    Else
      Begin
        Menu := TPopupMenu(entry);
        entry := Nil;
      End;

  If Not (Menu Is TPopupMenu) Then Menu:=Nil;

  //determine Form !
  If Menu=Nil
    then Result:=Nil
    else
      Begin
        If Menu.PopupComponent Is TForm Then Result:=TForm(Menu.PopupComponent)
        Else If Menu.Owner Is TForm Then Result:=TForm(Menu.Owner)
        Else Result:=Nil;
      End;
End;

Procedure THiddenWindow.WMInitMenu(Var Msg:TMessage);
Var Form:TForm;
    entry:TMenuItem;
    Menu:TPopupMenu;

Begin
  Form:=GetData(Msg.Param2,Menu,entry);
  If Form<>Nil Then Form.MenuInit(Menu,entry);
End;

Procedure THiddenWindow.WMMenuEnd(Var Msg:TMessage);
Var Form:TForm;
    entry:TMenuItem;
    Menu:TPopupMenu;

Begin
  Form:=GetData(Msg.Param2,Menu,entry);
  If Form<>Nil Then Form.MenuEnd(Menu,entry);
End;

Procedure THiddenWindow.WMMenuSelect(Var Msg:TMessage);
Var Form:TForm;
    entry:TMenuItem;
    Menu:TPopupMenu;

Begin
  Form:=GetData(Msg.Param2,Menu,entry);
  If Menu<>Nil Then entry := Menu.ItemFromInternalCommand(Msg.Param1Lo);
  If Form<>Nil Then Form.MenuItemFocus(Menu,entry);
End;
{$ENDIF}


//////////// Handle Timer Messages

Procedure THiddenWindow.WMTimer(Var Msg:TWMTimer);
Var  TID:LongWord;
     Timer:TTimer;
     T:LongInt;
Begin
  TID := Msg.TimerId;

  {Search If the Timer Is Valid For us}
  T := 0;
  If TimerList.Count>0 Then
  While T < TimerList.Count Do
    Begin
      Timer := TimerList.Items[T];

      If Timer <> Nil Then
        If Timer.FId = TID Then
          //If Timer.FControl = Self Then {found}
          Begin
            If (Application <> Nil) And (Timer = Application.FHintTimer) Then
              Begin
                If Application.ShowHint Then
                  If Application.FHintControl <> Nil Then
                    If Application.FHintControl.FHint <> Nil Then
                      If Application.FHintControl.GetShowHint
                      Then Application.HintTimerExpired;
              End
            Else
              Begin
                Inc(Timer.FTime,Timer.FInterval);
                Timer.Timer;
              End;

            Msg.Handled := True;
            Msg.Result := 0;
            break;
          End;
      Inc(T);
    End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TScreen Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
     TControlFont=Class(TFont)
        Public
            Property InternalPointSize;
            Property FontInfo;
            Property Custom;
            {$IFDEF Win32}
            Property Handle;
            Property RefCount;
            {$ENDIF}
            Property AlternateName;
     End;

     TControlCanvas=Class(TCanvas)
        Public
            {$IFDEF Win32}
            Property PenHandle;
            Property BrushHandle;
            {$ENDIF}
     End;


Function TScreen.GetCanvas:TCanvas;
Begin
     Result:=FCanvas;
     {$IFDEF WIN32}
     If FCanvas<>Nil Then If FCanvas.Handle=0 Then
     Begin
          FCanvas.Handle:=CreateDC('DISPLAY',Nil,Nil,Nil);
          FCanvas.Brush.Color:=FCanvas.Brush.Color;
          FCanvas.Brush.Mode:=FCanvas.Brush.Mode;
          FCanvas.Brush.Style:=FCanvas.Brush.Style;
          FCanvas.Pen.Color:=FCanvas.Pen.Color;
          FCanvas.Pen.Mode:=FCanvas.Pen.Mode;
          FCanvas.Pen.Style:=FCanvas.Pen.Style;
          FCanvas.Pen.Width:=FCanvas.Pen.Width;
          FCanvas.Font:=FCanvas.Font;
     End;
     {$ENDIF}
End;

Procedure TScreen.MapPoints(Target:TControl;Var pts:Array Of TPoint);
Begin
     If ((target=Nil)Or(target.Handle=0)) Then Exit;

     {$IFDEF OS2}
     WinMapWindowPoints(HWND_DESKTOP,target.Handle,pts[0],High(pts)+1);
     {$ENDIF}
     {$IFDEF Win32}
     pts[0].Y := {Screen.}Height - pts[0].Y; {Martin0308}
     MapWindowPoints(HWND_DESKTOP,target.Handle,pts[0],High(pts)+1);
     pts[0].Y := Target.ClientHeight - pts[0].Y; {Martin0308}
     {$ENDIF}
End;

Procedure TScreen.Update;
Begin
     {$IFDEF OS2}
     WinUpdateWindow(HWND_DESKTOP);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.UpdateWindow(HWND_DESKTOP);
     {$ENDIF}
End;

Procedure TScreen.SetupComponent;
{$IFDEF OS2}
Var Count:LongInt;
    aPS:HPS;
    T:LongInt;
    Font:TFont;
Type
   PMyFontMetrics=^TMyFontMetrics;
   TMyFontMetrics=Array[0..1] Of FONTMETRICS;
Var
   pfm:PMyFontMetrics;
   fcd:FRAMECDATA;
   FHandle,Menu:LongWord;
   Titlebar:LongWord;
   cFNS:Cstring;
   FaceName,Temp:String;
   PointSize:LongInt;
   C:Integer;
   fm:FONTMETRICS;
   long1, long2 : longword;
{$ENDIF}
{$IFDEF W32, Win32}
Var aHDC:HDC;
{$ENDIF}

Begin
  Inherited SetupComponent;

  FFonts.Create;

  {$IFDEF OS2}
  aPS:=WinGetPS(HWND_DESKTOP);
  Count:=0;    // Damit GpiQueryFonts ein Wert liefert.
  Count:=GpiQueryFonts(aPS,QF_PUBLIC,Nil,Count,0,Nil);
  If Count>0 Then
    Begin
      GetMem(pfm,Count*SizeOf(FONTMETRICS));
      GpiQueryFonts(aPS,QF_PUBLIC,Nil,Count,
                    SizeOf(FONTMETRICS),pfm^[0]);

      For T:=0 To Count-1 Do
        Begin
          Font.Create(Screen);
          TControlFont(Font).FontInfo:=pfm^[T];
          TControlFont(Font).FontType:=ftBitmap;
         {Martin (otherwise arbitrary range check error)}
          long1 := TControlFont(Font).FontInfo.fsDefn; long2 := FM_DEFN_OUTLINE;
          if long1 and long2 <> 0
            then TControlFont(Font).FontType:=ftOutline;
           {Else TControlFont(Font).InternalPointSize:=TControlFont(Font).FontInfo.sNominalPointSize Div 10;}
          FFonts.Add(Font);
        End;
    End;
  FreeMem(pfm,Count*SizeOf(FONTMETRICS));
  WinReleasePS(aPS);
  {$ENDIF}
  {$IFDEF Win32}
  aHDC:=GetDC(HWND_DESKTOP);
  EnumFonts(aHDC,Nil,Pointer(@EnumFontCallBackW32),Nil);
  ReleaseDC(HWND_DESKTOP,aHDC);
  {$ENDIF}
  FSystemFontCount := FontCount;

  FFontWindow.Create(Nil);
  FFontWindow.FOwnerDraw:=True;
  FFontWindow.CreateWnd;
  FHiddenWindow:=THiddenWindow.Create(Nil);
  FHiddenWindow.CreateWnd;

// target Window For WM_TIMER Messages
  TimerWindow := FHiddenWindow.Handle;

  {$IFDEF OS2}
//determine Default Font
  aPS:=WinGetPS(HWND_DESKTOP);
  If GpiQueryFontMetrics(aPS,SizeOf(FONTMETRICS),fm) Then
    Begin
      If fm.sNominalPointSize<>0 Then
        FDefaultFont:=Screen.GetFontFromPointSize(fm.szFaceName,fm.sNominalPointSize Div 10);
      If FDefaultFont=Nil Then
        FDefaultFont:=GetFontFromPointSize(fm.szFaceName,10);
    End;
  WinReleasePS(aPS);
  If DefaultFont<>Nil Then If FSystemFont=Nil Then
    Begin
      FSystemFont:=Screen.CreateCompatibleFont(DefaultFont);
//todo    FSystemFont.FDefault:=True;
    End;

//determine Default System Menu Font
  fcd.cb:=SizeOf(FRAMECDATA);
  fcd.flCreateFlags:=FCF_TITLEBAR Or FCF_SYSMENU;
  fcd.hModResources:=0;
  fcd.idResources:=0;

  cFNS:='';
  FHandle:=WinCreateWCWindow(HWND_DESKTOP,WC_FRAME,cFNS,
                                0,               //flStyle
                                0,0,             //leave This ON 0 - Set by .Show
                                0,0,             //Position And Size
                                HWND_DESKTOP,    //Parent
                                HWND_TOP,        //Insert behind
                                1,               //Window Id
                                @fcd,            //CtlData
                                Nil);            //Presparams
  Menu:=WinWindowFromID(FHandle,FID_SYSMENU);
  If WinQueryPresParam(Menu,PP_FONTNAMESIZE,0,Nil,SizeOf(cFNS),cFNS,QPF_NOINHERIT)<>0
    Then
      Begin
        FaceName:=cFNS;
        If Pos('.',FaceName)<>0 Then
          Begin
            Temp:=Copy(FaceName,1,Pos('.',FaceName)-1);
            Delete(FaceName,1,Pos('.',FaceName));
            Val(Temp,PointSize,C);
            If C=0 Then FMenuFont:=GetFontFromPointSize(FaceName,PointSize)
            Else FMenuFont:=DefaultFont;
          End;
       End
     Else FMenuFont:=DefaultFont;

  Titlebar:=WinWindowFromID(FHandle,FID_TITLEBAR);
  If WinQueryPresParam(Titlebar,PP_FONTNAMESIZE,0,Nil,SizeOf(cFNS),cFNS,QPF_NOINHERIT)=0
    then FDefaultFrameFont:=DefaultFont
    else
      Begin
        FaceName:=cFNS;
        If Pos('.',FaceName)<>0 Then
          Begin
            Temp:=Copy(FaceName,1,Pos('.',FaceName)-1);
            Delete(FaceName,1,Pos('.',FaceName));
            Val(Temp,PointSize,C);
            If C=0
              Then FDefaultFrameFont:=GetFontFromPointSize(FaceName,PointSize)
              Else FDefaultFrameFont:=DefaultFont;
          End;
      End;

  WinDestroyWindow(FHandle);
  {$ENDIF}
  {$IFDEF Win32}
  FMenuFont:=DefaultFont;
  FDefaultFrameFont:=DefaultFont;
  {$ENDIF}

  FForms.Create;
  FActiveForm:=Nil;
  CreateCursors;
  FCursor:=crDefault;
  FCanvas.Create(Nil);
  FCanvas.OwnerDraw:=True;

  {$IFDEF OS2}
  FCanvas.Handle:=WinGetScreenPS(HWND_DESKTOP);
  {$ENDIF}
  {$IFDEF Win32}
  FCanvas.Handle:=CreateDC('DISPLAY',Nil,Nil,Nil);
  {$ENDIF}
  SetupScreenCanvas(FCanvas);

  FCanvas.Init;
  FCanvas.Font:=DefaultFont; {small}
End;


Function TScreen.CreateCompatibleFont(Src:TFont):TFont;
Begin
     Result.Create(Screen);
     TControlFont(Result).FontInfo:=TControlFont(Src).FontInfo;
     TControlFont(Result).FontType:=TControlFont(Src).FontType;
     TControlFont(Result).InternalPointSize:=TControlFont(Src).InternalPointSize;
     TControlFont(Result).Custom:=True;
End;


{Martin!}
{das ist im Prinzip dasselbe wie tScreen.GetFontFromPointSize, aber ohne zur Klasse tScreen zu geh”ren
 und daแ ein beliebiger Canvas bergeben werden kann.
}
Function GeneralGetFontFromPointSize(Canvas : tCanvas; FaceName:String;PointSize:LongWord):TFont;
Var  T:LongInt;
     Font:TFont;
     Attrs:TFontAttributes;
     {$IFDEF OS2}
     S,s1:String;
     long1, long2 : longword;
     _hps:LongWord;
     FInfo:FONTMETRICS;
Label l;
     {$ENDIF}
     {$IFDEF WIN32}
Var  s,s1:String;
     b:Byte;
     aFontInfo:LOGFONT;
     tm:TEXTMETRIC;
     TempHandle:LongWord;
     {$ENDIF}
Label BoldItalic;
Begin
     Attrs:=[];
     {$IFDEF OS2}
     S:=FaceName;
     UpcaseStr(S);
L:
     For T:=Length(S) Downto 1 Do
     Begin
          If S[T]='.' Then
          Begin
               s1:=Copy(S,T+1,255);
               If ((s1='BOLD')Or(s1='ITALIC')Or(s1='UNDERSCORE')Or(s1='STRIKEOUT')Or
                   (s1='OUTLINE')) Then
               Begin
                    S[0]:=Chr(T-1);
                    FaceName[0]:=Chr(T-1);

                    If s1='BOLD' Then Attrs:=Attrs+[faBold]
                    Else If s1='ITALIC' Then Attrs:=Attrs+[faItalic]
                    Else If s1='UNDERSCORE' Then Attrs:=Attrs+[faUnderScore]
                    Else If s1='STRIKEOUT' Then Attrs:=Attrs+[faStrikeOut]
                    Else If s1='OUTLINE' Then Attrs:=Attrs+[faOutline];
               End;
          End;
     End;
     {$ENDIF}

     If FaceName='System Default Font' Then
     Begin
          Result:=Screen.DefaultFont;
          Exit;
     End;

     //don't allow To Set "Helv Bold.Bold" Or "Helv Italic.Italic" !
     S:=FaceName+' ';
     UpcaseStr(S);
     If Pos(' BOLD',S)<>0 Then Attrs:=Attrs-[faBold];
     If Pos(' ITALIC',S)<>0 Then Attrs:=Attrs-[faItalic];

     {$IFDEF WIN32}
     s1:=FaceName;
     UpcaseStr(s1);
     b:=pos('.BOLD',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faBold];
          Delete(s1,b,length('.BOLD'));
          Delete(FaceName,b,length('.BOLD'));
     End;
     b:=pos('.ITALIC',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faItalic];
          Delete(s1,b,length('.ITALIC'));
          Delete(FaceName,b,length('.ITALIC'));
     End;
     b:=pos('.OUTLINE',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faOutLine];
          Delete(s1,b,length('.OUTLINE'));
          Delete(FaceName,b,length('.OUTLINE'));
     End;
     b:=pos('.STRIKEOUT',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faStrikeOut];
          Delete(s1,b,length('.STRIKEOUT'));
          Delete(FaceName,b,length('.STRIKEOUT'));
     End;
     b:=pos('.UNDERSCORE',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faUnderScore];
          Delete(s1,b,length('.UNDERSCORE'));
          Delete(FaceName,b,length('.UNDERSCORE'));
     End;
     {$ENDIF}

     If Attrs*[faBold,faItalic]=[faBold,faItalic] Then
     Begin
          //look If we Find A Bold Italic Font With the same Name !
BoldItalic:
          For T:=0 To Screen.FontCount-1 Do
          Begin
               s1:=Screen.Fonts[T].FaceName;
               UpcaseStr(s1);
               If Pos(S,s1)=1 Then If Pos(' BOLD ITALIC',s1)<>0 Then
               Begin
                    Attrs:=Attrs-[faBold,faItalic];
                    FaceName:=Screen.Fonts[T].FaceName;
                    break;
               End;
          End;
     End
     Else If Attrs*[faBold]<>[] Then
     Begin
          //look If we Find A Bold Font With the same Name !
          T:=Pos(' ITALIC',S);
          If T<>0 Then
          Begin
               Delete(S,T,7);
               Goto BoldItalic;
          End;

          For T:=0 To Screen.FontCount-1 Do
          Begin
               s1:=Screen.Fonts[T].FaceName;
               UpcaseStr(s1);
               If Pos(S,s1)=1 Then If Pos(' BOLD',s1)<>0 Then
                If ((Pos(' ITALIC',s1)=0)Or(Pos(' ITALIC',S)<>0)) Then
               Begin
                    Attrs:=Attrs-[faBold];
                    FaceName:=Screen.Fonts[T].FaceName;
                    break;
               End;
          End;
     End
     Else If Attrs*[faItalic]<>[] Then
     Begin
          //look If we Find an Italic Font With the same Name !
          For T:=0 To Screen.FontCount-1 Do
          Begin
               s1:=Screen.Fonts[T].FaceName;
               UpcaseStr(s1);
               If Pos(S,s1)=1 Then If Pos(' ITALIC',s1)<>0 Then
                 If ((Pos(' BOLD',s1)=0)Or(Pos(' BOLD',S)<>0)) Then
               Begin
                    Attrs:=Attrs-[faItalic];
                    FaceName:=Screen.Fonts[T].FaceName;
                    break;
               End;
          End;
     End;

     {look If the Font Is already registered}
     Result:=Nil;

     {$ifdef win32}
     if Canvas = Screen.Canvas then begin {Martin0806}
     {$endif}
       {bei Windows darf nur dann auf Kopien von Screen-Fonts zugegriffen werden,
        wenn der Font auch wirklich fuer Screen benoetigt wird,
        andernfalls wird die Schrift viel zu klein, weil die Groesse in Pixel nicht
        angepasst wird}
      For T:=0 To Screen.FontCount-1 Do
        Begin
          Font:=Screen.Fonts[T];
          If Font.FaceName=FaceName Then
            If TControlFont(Font).InternalPointSize=PointSize Then
              If Font.Attributes=Attrs Then
                Begin
                  Result:=Font;
                  If Screen<>Nil Then
                    Begin
                       //don't return DefaultFont here, create a copy instead
                      If Result<>Screen.FDefaultFont Then
                        Begin
                          exit;
                        End;
                    End
                  Else Exit;
                End;
        End;

     If Result<>Nil Then //A defaultfont was previously found
       Begin
         Result:=Screen.CreateCompatibleFont(Result);
         TControlFont(Result).Custom:=False;
         TControlFont(Result).InternalPointSize:=PointSize;
         exit;
       End;

     {$ifdef win32}
     end;
     {$endif}
     
     Result:=Nil;
     {look If there Is A Font registered called FaceName}
     (*If not Screen.Fonts = Nil Then*) For T:=0 To Screen.FontCount-1 Do
     Begin
          Font:=Screen.Fonts[T];
          If Font.FaceName=FaceName Then
          Begin
               Result:=Screen.CreateCompatibleFont(Font);
               TControlFont(Result).Custom:=False;
               TControlFont(Result).InternalPointSize:=PointSize;

               {$IFDEF OS2}
               S:=tostr(PointSize)+'.'+FaceName;

               S:=ModifyFontName(S,Attrs);
               If Not Screen.FFontWindow.SetPPFontNameSize(S) Then
               Begin
                    //Some Error occured
                    //ErrorBox2('Font could not be created:'+S);
                    Result.Destroy;
                    Result:=Nil;
                    Exit;
               End;

               _hps:=WinGetPS(Screen.FFontWindow.Handle{HWND_DESKTOP});
               If Not GpiQueryFontMetrics(_hps,SizeOf(FONTMETRICS),FInfo) Then
               Begin
                    //Some Error occured
                    Result.Destroy;
                    Result:=Nil;
                    WinReleasePS(_hps);
                    Exit;
               End;
               TControlFont(Result).FontInfo := FInfo;
               WinReleasePS(_hps);
               Result.FontType:=ftBitmap;
               {Martin otherwise arbitrary range check error}
               long1 := TControlFont(Result).FontInfo.fsDefn; long2 := FM_DEFN_OUTLINE;
               If long1 And long2 <> 0 Then Result.FontType:=ftOutline;


               //don't allow To Set "Helv Bold.Bold" Or "Helv Italic.Italic" !
               If Attrs*[faBold]<>[] Then
               Begin
                    S:=Result.FaceName;
                    UpcaseStr(S);
                    If Pos(' BOLD',S)=0 Then TControlFont(Result).FontInfo.fsSelection:=TControlFont(Result).FontInfo.fsSelection or FM_SEL_BOLD
                    Else TControlFont(Result).FontInfo.fsSelection:=TControlFont(Result).FontInfo.fsSelectioN And Not FM_SEL_BOLD;
               End;
               If Attrs*[faItalic]<>[] Then
               Begin
                    S:=Result.FaceName;
                    UpcaseStr(S);
                    If Pos(' ITALIC',S)=0 Then TControlFont(Result).FontInfo.fsSelection:=TControlFont(Result).FontInfo.fsSelection or FM_SEL_ITALIC
                    Else TControlFont(Result).FontInfo.fsSelection:=TControlFont(Result).FontInfo.fsSelection And Not FM_SEL_ITALIC
               End;

               If Attrs*[faUnderScore]<>[] Then
                  TControlFont(Result).FontInfo.fsSelection:=TControlFont(Result).FontInfo.fsSelection Or FM_SEL_UNDERSCORE;
               If Attrs*[faStrikeOut]<>[] Then
                  TControlFont(Result).FontInfo.fsSelection:=TControlFont(Result).FontInfo.fsSelection Or FM_SEl_STRIKEOUT;
               If Attrs*[faOutline]<>[] Then
                  TControlFont(Result).FontInfo.fsSelection:=TControlFont(Result).FontInfo.fsSelection Or FM_SEL_OUTLINE;
               {$ENDIF}
               {$IFDEF Win32}
               {fixed by Martin V., 1-Oct-2004}
               Result.Attributes:=Attrs;
               TControlFont(Result).FontInfo.lfHeight:= - round(
                 1.0/72.0{1 Point = 1/72 inch}
                 * PointSize
                 * GetDeviceCaps (Canvas.Handle, LOGPIXELSY){Pixels per Inch});
               TControlFont(Result).FontInfo.lfWidth:=0;{*}

               aFontInfo:=TControlFont(Result).FontInfo;
               aFontInfo.lfHeight:=TControlFont(Result).FontInfo.lfHeight;
               aFontInfo.lfWidth:=TControlFont(Result).FontInfo.lfWidth;
               aFontInfo.lfQuality:=DRAFT_QUALITY;
               aFontInfo.lfItalic:=0;
               aFontInfo.lfUnderline:=0;
               aFontInfo.lfStrikeOut:=0;
               aFontInfo.lfWeight:=FW_NORMAL;
               TempHandle:=CreateFontIndirect(aFontInfo);
               SelectObject(Canvas.Handle,TempHandle);
               FillChar(tm,sizeof(tm),0);
               GetTextMetrics(Canvas.Handle,tm);
// ErrorBox2('Height for FaceName='+FaceName+'='+tostr(tm.tmHeight)+
//           'Ascent='+tostr(tm.tmAscent)+
//           'Descent='+tostr(tm.tmDescent)+
//           ', MaxCharWidth='+tostr(tm.tmMaxCharWidth)+
//           ', Width='+tostr(tm.tmWeight)+
//           ', Width2='+tostr(tm.tmAveCharWidth));
               If tm.tmHeight<>0 Then
                 TControlFont(Result).FontInfo.lfHeight:=tm.tmHeight; // +tm.tmAscent+tm.tmDescent;
               TControlFont(Result).FontInfo.lfWidth:=tm.tmAveCharWidth;  // tm.tmMaxCharWidth;
               DeleteObject(TempHandle);
               {$ENDIF}
               //Screen.Fonts.Add(Result);
               Exit;
          End;
     End;
End;

{Martin!}
{
  Ersatz fr das bisherige TScreen.GetFontFromPointSize, ruft die General... function auf.
}
Function TScreen.GetFontFromPointSize(FaceName:String;PointSize:LongWord):TFont;
  begin
    result := GeneralGetFontFromPointSize (FFontWindow.Canvas, Facename, Pointsize);
    if result <> nil then
      FFonts.Add(Result);
  end;

Function TScreen.GetControlFromPoint(pt:TPoint):TControl;
Var  ahwnd:LongWord;
Begin
     {$IFDEF OS2}
     ahwnd := WinWindowFromPoint(HWND_DESKTOP,pt,True);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,Nil);
     ahwnd := WindowFromPoint(POINTL(pt));
     {$ENDIF}
     If ahwnd<>0 Then
     Begin
          Result := HandleToControl(ahwnd);
          If not IsControl(Result) Then Result:=Nil;
     End
     Else Result:=Nil;
End;


Function TScreen.SystemMetrics(sm:TSystemMetrics):LongInt;
Begin
     {$IFDEF OS2}
     Result := WinQuerySysValue(HWND_DESKTOP,sm);
     If sm = smCxMinMaxButton Then Result := Result Div 2;
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetSystemMetrics(sm);
     {$ENDIF}
End;

Function TScreen.SystemColors(sc:TColor):TColor;
Begin
     Result := SysColorToRGB(sc);
End;


Function TScreen.GetFontFromName(FaceName:String;Height,Width:LongInt):TFont;
Var T:LongInt;
    DifY,DifX:Word;
    tx,ty:Word;
    Font:TFont;
    Attrs:TFontAttributes;
{$IFDEF OS2}
    S,s1:String;
Label L;
{$ENDIF}
Begin
     If FaceName='System Default Font' Then
     Begin
          Result:=DefaultFont;
          Exit;
     End;

     Attrs:=[];
     {$IFDEF OS2}
     S:=FaceName;
     UpcaseStr(S);
L:
     For T:=Length(S) Downto 1 Do
     Begin
          If S[T]='.' Then
          Begin
               s1:=Copy(S,T+1,255);
               If ((s1='BOLD')Or(s1='ITALIC')Or(s1='UNDERSCORE')Or(s1='STRIKEOUT')Or
                   (s1='OUTLINE')) Then
               Begin
                    S[0]:=Chr(T-1);
                    FaceName[0]:=Chr(T-1);

                    If s1='BOLD' Then Attrs:=Attrs+[faBold]
                    Else If s1='ITALIC' Then Attrs:=Attrs+[faItalic]
                    Else If s1='UNDERSCORE' Then Attrs:=Attrs+[faUnderScore]
                    Else If s1='STRIKEOUT' Then Attrs:=Attrs+[faStrikeOut]
                    Else If s1='OUTLINE' Then Attrs:=Attrs+[faOutline];
                    Goto L;
               End;
          End;
     End;
     {$ENDIF}

     //Attrs mit einbeziehen

     Result:=Nil;
     DifY:=65535;
     DifX:=65535;
     For T:=0 To FFonts.Count-1 Do
     Begin
          Font:=Fonts[T];
          {$IFDEF OS2}
          If TControlFont(Font).FontInfo.szFaceName=FaceName Then
          Begin
               ty:=Abs(TControlFont(Font).FontInfo.lMaxbaseLineExt-Height);
               tx:=Abs(TControlFont(Font).FontInfo.LMaxCharInc-Width);

               If ty<=DifY Then If tx<=DifX Then
               Begin
                   Result:=Font;
                   DifY:=ty;
                   DifX:=tx;
               End;
          End;
          {$ENDIF}
          {$IFDEF Win32}
          If TControlFont(Font).FontInfo.lfFaceName=FaceName Then
          Begin
               ty:=Abs(TControlFont(Font).FontInfo.lfHeight-Height);
               If TControlFont(Font).FontInfo.lfHeight=0 Then ty:=0;
               tx:=Abs(TControlFont(Font).FontInfo.lfWidth-Width);
               If TControlFont(Font).FontInfo.lfWidth=0 Then tx:=0;

               If ty<=DifY Then If tx<=DifX Then
               Begin
                   Result:=Font;
                   DifY:=ty;
                   DifX:=tx;
               End
               Else
               Begin
                    If ty<=DifY Then
                    Begin
                         {tx greater}
                         If tx-DifX<DifY-ty Then
                         Begin
                              Result:=Font;
                              DifY:=ty;
                              DifX:=tx;
                         End;
                    End
                    Else If tx<=DifX Then
                    Begin
                         {ty greater}
                         If ty-DifY<DifX-tx Then
                         Begin
                              Result:=Font;
                              DifY:=ty;
                              DifX:=tx;
                         End;
                    End;
               End;
          End;
          {$ENDIF}
     End;
End;


Function TScreen.GetSystemFixedFont:TFont;
Var  I:LongInt;
     F:TFont;
Begin
     {$IFDEF OS2}
     Result := GetFontFromName('Courier',16,9);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetFontFromName('Fixedsys',15,8);
     {$ENDIF}

     If Result = Nil Then
      If Screen<>Nil Then
       For I := 0 To Screen.FontCount-1 Do
     Begin
          F := Screen.Fonts[I];
          If F.Pitch = fpFixed Then
            If F.FontType = ftBitmap Then
            Begin
                 Result := F;
                 Exit;
            End;
     End;
     If Result = Nil Then Result := GetSystemDefaultFont; {never return Nil}
End;


Function TScreen.GetSystemDefaultFont:TFont;
Begin
   {Martin}
     if FDefaultFont <>Nil Then begin
       Result:=FDefaultFont;
       exit;
     end;
   {end Martin}

     If FSystemFont<>Nil Then
     Begin
          Result:=FSystemFont;
          Exit;
     End;

     {$IFDEF OS2}
     If FDefaultFont<>Nil
       Then Result:=FDefaultFont
       Else
         Begin
           Result:=GetFontFromPointSize('WarpSans Bold',9);  { System Proportional, 10 }
           If Result=Nil Then Result := GetFontFromName('WarpSans Bold', 15,16);   { 'System Proportional',20,16); }
         End;
     //If Result <> Nil Then TControlFont(Result).FontInfo.usCodePage := 850;
     {$ENDIF}
     {$IFDEF Win32}
     If FDefaultFont<>Nil
       Then Result:=FDefaultFont
       Else
         Begin
           Result := GetFontFromName('MS Sans Serif',15,5);
           If Result=Nil Then Result := GetFontFromName('Fixedsys',15,8);
         End;
     {$ENDIF}
End;

Function TScreen.GetSystemSmallFont:TFont;
Begin
     If Width > 800 Then  //big Fonts
     Begin
          {$IFDEF OS2}
          Result := GetFontFromPointSize('Helv',8);
          {$ENDIF}
          {$IFDEF Win32}
          Result := GetFontFromName('MS Sans Serif',15,5);
          If Result = Nil Then Result := GetFontFromName('Arial',16,6);
          {$ENDIF}
     End
     Else
     Begin
          {$IFDEF OS2}
          Result := GetFontFromPointSize('Helv',8);
          {$ENDIF}
          {$IFDEF Win32}
          Result := GetFontFromName('MS Sans Serif',15,5);
          If Result = Nil Then Result := GetFontFromName('Arial',14,5);
          {$ENDIF}
     End;
     If Result = Nil Then Result := GetSystemDefaultFont;
End;


Function TScreen.GetFormCount:LongInt;
Begin
  Result := FForms.Count;
End;


Function TScreen.GetForm(Index:LongInt):TForm;
Begin
     Result := FForms.Items[Index];
End;


Function TScreen.GetFontCount:LongInt;
Begin
  {Martin!}
     if FFonts = nil then
       result := 0
     else
       Result:=FFonts.Count;
End;

Function TScreen.GetFont(Index:LongInt):TFont;
Begin
     Result:=FFonts.Items[Index];
End;
                   
Function TScreen.GetMousePos:TPoint;
Begin
     {$IFDEF OS2}
     WinQueryPointerPos(HWND_DESKTOP,Result);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.GetCursorPos(Result);
     TransformClientPoint(Result,Nil);
     {$ENDIF}         
End;

Procedure TScreen.SetMousePos(NewPos:TPoint);
Begin
     {$IFDEF OS2}
     WinSetPointerPos(HWND_DESKTOP,NewPos.X,NewPos.Y);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(NewPos,Nil);
     WinUser.SetCursorPos(NewPos.X,NewPos.Y);
     {$ENDIF}
End;

Destructor TScreen.Destroy;

Begin
  FFonts.Destroy;
  FFonts := Nil;
  FForms.Destroy;
  FForms := Nil;
  FFontWindow.Destroy;
  FFontWindow := Nil;
  FHiddenWindow.Destroy;
  FHiddenWindow := Nil;
  DestroyCursors;

  Inherited Destroy;  //Destroys All owned Components As well

  If Self=Screen Then Screen:=Nil;
End;

Procedure TScreen.CreateCursors;

Var Cou : LongWord;

Begin
     DestroyCursors;
     for Cou:=0 to ListCursorsPtCount do
       fCursorPointer[Cou].Create;

// Pointer fuer OS/2 und Windows
     {$IFDEF OS2}
     fCursorPointer[0].LoadFromResourceName('Cross');
     fCursorPointer[1].LoadFromResourceName('UpArrow');
     fCursorPointer[2].LoadFromResourceName('HSplit');
     fCursorPointer[3].LoadFromResourceName('VSplit');
     fCursorPointer[4].LoadFromResourceName('SQLWait');
     fCursorPointer[5].LoadFromResourceName('APPStart');
     fCursorPointer[6].LoadFromResourceName('Help');

// Vom OS/2-System
     InsertCursor(crDefault,WinQuerySysPointer(HWND_DESKTOP,SPTR_ARROW,False));
//crNone
     InsertCursor(crArrow,WinQuerySysPointer(HWND_DESKTOP,SPTR_ARROW,False));
     InsertCursor(crCross,fCursorPointer[0].Handle);
     InsertCursor(crIBeam,WinQuerySysPointer(HWND_DESKTOP,SPTR_TEXT,False));
     InsertCursor(crSize,WinQuerySysPointer(HWND_DESKTOP,SPTR_MOVE,False));
     InsertCursor(crSizeNESW,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENESW,False));
     InsertCursor(crSizeNS,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENS,False));
     InsertCursor(crSizeNWSE,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENWSE,False));
     InsertCursor(crSizeWE,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZEWE,False));
     InsertCursor(crUpArrow ,fCursorPointer[1].Handle);
     InsertCursor(crHourGlass,WinQuerySysPointer(HWND_DESKTOP,SPTR_WAIT,False));
     InsertCursor(crDrag,WinQuerySysPointer(HWND_DESKTOP,SPTR_FILE,False));
     InsertCursor(crNoDrop,WinQuerySysPointer(HWND_DESKTOP,SPTR_ILLEGAL,False));
     InsertCursor(crHSplit,fCursorPointer[2].Handle);
     InsertCursor(crVSplit,fCursorPointer[3].Handle);
     InsertCursor(crMultiDrag,WinQuerySysPointer(HWND_DESKTOP,SPTR_MULTFILE,False));
     InsertCursor(crSQLWait,fCursorPointer[4].Handle);
     InsertCursor(crNo,WinQuerySysPointer(HWND_DESKTOP,SPTR_ICONERROR,False));
     InsertCursor(crAppStart,fCursorPointer[5].Handle);
     InsertCursor(crHelp,fCursorPointer[6].Handle);
     InsertCursor(crSizeNW,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENWSE,False));
     InsertCursor(crSizeSE,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENWSE,False));
     InsertCursor(crSizeNE,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENESW,False));
     InsertCursor(crSizeSW,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENESW,False));
     InsertCursor(crHand,WinQuerySysPointer(HWND_DESKTOP,SPTR_ARROW,False));
     {$ENDIF}

     {$IFDEF Win32}
// Vom Windows-System
     fCursorPointer[0].LoadFromResourceName('Drag');
     fCursorPointer[1].LoadFromResourceName('SQLWait');

     InsertCursor(crDefault,LoadCursor(0,IDC_ARROW));
// crNone
     InsertCursor(crArrow,LoadCursor(0,IDC_ARROW));
     InsertCursor(crCross,LoadCursor(0,IDC_CROSS));
     InsertCursor(crIBeam,LoadCursor(0,IDC_IBEAM));
     InsertCursor(crSize,LoadCursor(0,IDC_SIZE));
     InsertCursor(crSizeNESW,LoadCursor(0,IDC_SIZENESW));
     InsertCursor(crSizeNS,LoadCursor(0,IDC_SIZENS));
     InsertCursor(crSizeNWSE,LoadCursor(0,IDC_SIZENWSE));
     InsertCursor(crSizeWE,LoadCursor(0,IDC_SIZEWE));
     InsertCursor(crUpArrow,LoadCursor(0,IDC_UPARROW));
     InsertCursor(crHourGlass,LoadCursor(0,IDC_WAIT));
     InsertCursor(crDrag,fCursorPointer[0].Handle);
     InsertCursor(crNoDrop,LoadCursor(0,IDC_NO));
     InsertCursor(crHSplit,LoadCursor(0,IDC_SIZEWE));
     InsertCursor(crVSplit,LoadCursor(0,IDC_SIZENS));
     InsertCursor(crMultiDrag,LoadCursor(0,IDC_MULTIDRAG));
     InsertCursor(crSQLWait,fCursorPointer[1].Handle);
     InsertCursor(crNo,LoadCursor(0,IDC_NO));
     InsertCursor(crAppStart,LoadCursor(0,IDC_APPSTARTING));
     InsertCursor(crHelp,LoadCursor(0, IDC_HELP));
     InsertCursor(crSizeNW,LoadCursor(0,IDC_SIZENWSE));
     InsertCursor(crSizeSE,LoadCursor(0,IDC_SIZENWSE));
     InsertCursor(crSizeNE,LoadCursor(0,IDC_SIZENESW));
     InsertCursor(crSizeSW,LoadCursor(0,IDC_SIZENESW));
     InsertCursor(crHand,LoadCursor(0,IDC_HAND));
     {$ENDIF}
End;


Procedure TScreen.DestroyCursors;

Var dummy: PCursorRec;
    cou  : LongWord;

Begin
  for Cou:=0 to ListCursorsPtCount do
    if fCursorPointer[Cou]<>nil then
      fCursorPointer[Cou].Destroy;

  While FCursorList <> Nil Do
    Begin
      {$IFDEF Win32}
      DestroyCursor(FCursorList^.Handle);
      {$ENDIF}
      dummy := FCursorList^.Next;
      Dispose(FCursorList);
      FCursorList := dummy;
    End;
  FDefaultCursor := 0;
End;


Procedure TScreen.SetCursors(Index:TCursor;Handle:HCursor);
Begin
     If Index = crNone Then Exit;

     DeleteCursor(Index);
     If Handle <> 0 Then
     Begin
          InsertCursor(Index, Handle);
          If Index = crDefault Then FDefaultCursor := Handle;
     End;
End;


Function TScreen.GetCursors(Index:TCursor):HCursor;
Var  dummy:PCursorRec;
Begin
     Result := 0;
     If Index = crNone Then Exit;

     dummy := FCursorList;
     While dummy <> Nil Do
     Begin
          If dummy^.Index = Index Then
          Begin
               Result := dummy^.Handle;
               Exit;
          End;
          dummy := dummy^.Next;
     End;
     Result := FDefaultCursor;
End;


Procedure TScreen.InsertCursor(Index:TCursor;Handle:HCursor);
Var  dummy:PCursorRec;
Begin
     New(dummy);
     dummy^.Next := FCursorList;
     dummy^.Index := Index;
     dummy^.Handle := Handle;
     FCursorList := dummy;
End;


Function TScreen.AddCursor(Handle:HCursor):TCursor;
Var dummy:PCursorRec;
Begin
     //look For the Next Free TCursor Handle
     Result:=TCursor(crDefault+1);
     While True Do
     Begin
          //look If the TCursor Handle Is used by another user...
          dummy:=FCursorList;
          While dummy<>Nil Do
          Begin
               If dummy^.Index=Result Then break;
               dummy:=dummy^.Next;
          End;

          If dummy=Nil Then break; //the Item Is available
          Inc(Result);
     End;

     InsertCursor(Result,Handle);
End;


Procedure TScreen.DeleteCursor(Index:TCursor);
Var  dummy,Prev:PCursorRec;
Begin
     Prev := Nil;
     dummy := FCursorList;
     While dummy <> Nil Do
     Begin
          If dummy^.Index = Index Then
          Begin
               If Prev = Nil Then FCursorList := dummy^.Next
               Else Prev^.Next := dummy^.Next;
               {$IFDEF Win32}
               DestroyCursor(dummy^.Handle);
               {$ENDIF}
               Dispose(dummy);
               Exit;
          End;
          dummy := dummy^.Next;
     End;
End;


Procedure TScreen.SetCursor(Index:TCursor);
Var  Control:TControl;
Begin
     FCursor := Index;
     Control := GetControlFromPoint(MousePos);
     If Control <> Nil Then Control.Cursor := Control.Cursor;
End;


Function TScreen.GetHeight:LongInt;
Begin
     Result := SystemMetrics(smCyScreen);
End;


Function TScreen.GetWidth:LongInt;
Begin
     Result := SystemMetrics(smCxScreen);
End;


Procedure TScreen.UpdateLastActive;
Begin
     If FLastActiveForm <> FActiveForm Then
     Begin
          FLastActiveForm := FActiveForm;
          If FOnActiveFormChange <> Nil Then FOnActiveFormChange(Self);
     End;

     If FLastActiveControl <> FActiveControl Then
     Begin
          FLastActiveControl := FActiveControl;
          If FOnActiveControlChange <> Nil Then FOnActiveControlChange(Self);
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: General functions Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function OppositeRGB(color:TColor):TColor;
Var  R,G,B:Byte;
Begin
     RGBToValues(color,R,G,B);
     If R > $80 Then R := 0 Else R := $FF;
     If G > $80 Then G := 0 Else G := $FF;
     If B > $80 Then B := 0 Else B := $FF;
     Result := ValuesToRGB(R,G,B);
End;


Function ValuesToRGB(Red,Green,Blue:Byte):TColor;
Var  R,G,B:LongInt;
Begin
     R := Red;
     G := Green;
     B := Blue;
     Result := R Shl 16 + (G Shl 8) + B;
End;


Function RGBToValues(color:TColor;Var Red,Green,Blue:Byte):TColor;
Begin
     Result := SysColorToRGB(color);
     Red := (Result And $FFFFFF) Shr 16;
     Green := (Result And $FFFF) Shr 8;
     Blue := (Result And $FF);
End;


Const
    SysColors:Array[0..28] Of TColor = (
       {$IFDEF OS2}
       SYSCLR_SCROLLBAR, {clScrollbar}
       SYSCLR_BACKGROUND, {clBackGround}
       SYSCLR_ACTIVETITLE, {clActiveCaption}
       SYSCLR_INACTIVETITLE, {clInactiveCaption}
       SYSCLR_MENU, {clMenu}
       SYSCLR_WINDOW, {clWindow}
       SYSCLR_WINDOWFRAME, {clWindowFrame}
       SYSCLR_MENUTEXT, {clMenuText}
       SYSCLR_WINDOWTEXT, {clWindowText}
       SYSCLR_ACTIVETITLETEXT, {clCaptionText}
       SYSCLR_ACTIVEBORDER, {clActiveBorder}
       SYSCLR_INACTIVEBORDER, {clInactiveBorder}
       SYSCLR_APPWORKSPACE, {clAppWorkSpace}
       SYSCLR_HILITEBACKGROUND, {clHighlight}
       SYSCLR_HILITEFOREGROUND, {clHighlightText}
       SYSCLR_BUTTONMIDDLE, {clBtnFace}
       SYSCLR_BUTTONDARK, {clBtnShadow}
       clDkGray, {clGrayText}
       SYSCLR_MENUTEXT, {clBtnText}
       SYSCLR_INACTIVETITLETEXT, {clInactiveCaptionText}
       SYSCLR_BUTTONLIGHT, {clBtnHighlight}
       clBlack, {cl3DDkShadow}
       clWhite, {cl3DLight}
       clBlack, {clInfoText}
       clYellow,{clInfo}
       SYSCLR_BUTTONDEFAULT, {clBtnDefault}
       SYSCLR_DIALOGBACKGROUND, {clDlgWindow}
       SYSCLR_ENTRYFIELD, {clEntryField}
       SYSCLR_WINDOWSTATICTEXT {clStaticText}
       {$ENDIF}
       {$IFDEF Win32}
       COLOR_SCROLLBAR Or $80000000, {clScrollbar}
       COLOR_BACKGROUND Or $80000000, {clBackGround}
       COLOR_ACTIVECAPTION Or $80000000, {clActiveCaption}
       COLOR_INACTIVECAPTION Or $80000000, {clInactiveCaption}
       COLOR_MENU Or $80000000, {clMenu}
       COLOR_WINDOW Or $80000000, {clWindow}
       COLOR_WINDOWFRAME Or $80000000, {clWindowFrame}
       COLOR_MENUTEXT Or $80000000, {clMenuText}
       COLOR_WINDOWTEXT Or $80000000, {clWindowText}
       COLOR_CAPTIONTEXT Or $80000000, {clCaptionText}
       COLOR_ACTIVEBORDER Or $80000000, {clActiveBorder}
       COLOR_INACTIVEBORDER Or $80000000, {clInactiveBorder}
       COLOR_APPWORKSPACE Or $80000000, {clAppWorkSpace}
       COLOR_HIGHLIGHT Or $80000000, {clHighlight}
       COLOR_HIGHLIGHTTEXT Or $80000000, {clHighlightText}
       COLOR_BTNFACE Or $80000000, {clBtnFace}
       COLOR_BTNSHADOW Or $80000000, {clBtnShadow}
       COLOR_GRAYTEXT Or $80000000, {clGrayText}
       COLOR_BTNTEXT Or $80000000, {clBtnText}
       COLOR_INACTIVECAPTIONTEXT Or $80000000, {clInactiveCaptionText}
       COLOR_BTNHIGHLIGHT Or $80000000, {clBtnHighlight}
       COLOR_3DDKSHADOW Or $80000000, {cl3DDkShadow}
       COLOR_3DLIGHT Or $80000000, {cl3DLight}
       COLOR_INFOTEXT Or $80000000, {clInfoText}
       COLOR_INFOBK Or $80000000, {clInfo}
       clBlack, {clBtnDefault}
       clLtGray, {clDlgWindow}
       COLOR_WINDOW Or $80000000, {clEntryField}
       COLOR_WINDOWTEXT Or $80000000 {clStaticText}
       {$ENDIF}
    );


Function SysColorToRGB(color:TColor):TColor;
Var  Col:LongInt;
Begin
     If color < 0 Then {SPCC Portable System color}
     Begin
          Col := Color And $000000FF;
          If Col In [0..28] Then Color := SysColors[Col];

          If Color < 0 Then
          Begin
               {$IFDEF OS2}
               Result := WinQuerySysColor(HWND_DESKTOP,Color,0) {OS/2 System color -> SPCC RGB}
               {$ENDIF}
               {$IFDEF Win32}
               color := color And $000000FF;
               color := GetSysColor(Color);     {Win32 System color -> Win32 RGB}
               Result := WinColorToRGB(Color);  {SPCC RGB}
               {$ENDIF}
          End
          Else Result := Color; {normal RGB color}
     End
     Else Result := Color;
End;


{$HINTS OFF}
Function WinColorToRGB(color:TColor):TColor;Assembler;
   Asm
     //Swap Red And Blue values
     MOV AL,color     //Red Value
     MOV BL,color+2   //Blue Value
     MOV color+2,AL
     MOV color,BL
     MOV EAX,color
     CMP EAX,$00C0C0C0
     JNE !ex
     MOV EAX,$00CCCCCC
!ex:
     leave
     RETN32 4
  End;


Function RGBToWinColor(color:TColor):TColor;Assembler;

  Asm
    //Swap Red And Blue values
    MOV AL,color     //Red Value
    MOV BL,color+2   //Blue Value
    MOV color+2,AL
    MOV color,BL
    MOV EAX,color
    CMP EAX,$00CCCCCC
    JNE !ex2
    MOV EAX,$00C0C0C0
!ex2:
    leave
    RETN32 4
  End;
{$HINTS ON}


Function GetShortHint(Const Hint:String):String;
Var  I:Integer;
Begin
     I := Pos('|',Hint);
     If I = 0 Then Result := Hint
     Else Result := Copy(Hint, 1, I-1);
End;

Function GetLongHint(Const Hint:String):String;
Var  I:Integer;
Begin
     I := Pos('|',Hint);
     If I = 0 Then Result := Hint
     Else Result := Copy(Hint, I+1, MaxInt);
End;


Function Point(X,Y:LongInt):TPoint;
Begin
     Result.X := X;
     Result.Y := Y;
End;


Function Rect(Left,Bottom,Right,Top:LongInt):TRect;
Begin
     Result.Left := Left;
     Result.Bottom := Bottom;
     Result.Right := Right;
     Result.Top := Top;
End;


Function PointInRect(pt:TPoint; rec:TRect):Boolean;
Begin
     Result := False;
     If pt.X < rec.Left Then Exit;
     If pt.X > rec.Right Then Exit;
     If pt.Y < rec.Bottom Then Exit;
     If pt.Y > rec.Top Then Exit;
     Result := True;
End;


Function RectInRect(Const childrec,parentrec:TRect):Boolean;
Begin
     Result := False;
     If childrec.Left <= parentrec.Left Then Exit;
     If childrec.Right >= parentrec.Right Then Exit;
     If childrec.Bottom <= parentrec.Bottom Then Exit;
     If childrec.Top >= parentrec.Top Then Exit;
     Result := True;
End;


Procedure InflateRect(Var rec:TRect; X,Y:LongInt);
Begin
     Dec(rec.Left, X);
     Dec(rec.Bottom, Y);
     Inc(rec.Right, X);
     Inc(rec.Top, Y);
End;


Procedure OffsetRect(Var rec:TRect; X,Y:LongInt);
Begin
     Inc(rec.Left, X);
     Inc(rec.Bottom, Y);
     Inc(rec.Right, X);
     Inc(rec.Top, Y);
End;


Procedure CheckEmpty(Var rec:TRect);
Begin
     If (rec.Left > rec.Right) Or (rec.Bottom > rec.Top) Then
       FillChar(rec,SizeOf(TRect),0);
End;

{returns Rectangle that Is owned by both rectangles Or Empty rec}
Function IntersectRect(Const rec1,rec2:TRect):TRect;
Begin
     Result:=rec1;
     Asm
        MOV ESI,rec2
        MOV EDI,rec1
        MOV EBX,[EBP-4]
        CLD

        //process TRect.Left And yBottom
        LODSD
        SCASD
        JLE     !l11
        MOV [EBX].TRect.Left,EAX
!l11:
        LODSD
        SCASD
        JLE     !l12
        MOV [EBX].TRect.Bottom,EAX
!l12:
        //process TRect.Right,yBottom
        LODSD
        SCASD
        JGE     !l13
        MOV [EBX].TRect.Right,EAX
!l13:
        LODSD
        SCASD
        JGE     !l14
        MOV [EBX].TRect.Top,EAX
!l14:
        PUSH DWord Ptr [EBP-4]
        CALLN32 Forms.CheckEmpty
     End;
End;


{returns Rectangle that covers both rectangles}
Function UnionRect(Const rec1,rec2:TRect):TRect;
Begin
     Result:=rec1;
     Asm
        MOV ESI,rec2
        MOV EDI,rec1
        MOV EBX,[EBP-4]
        CLD

        //process TRect.Left,yBottom
        LODSD
        SCASD
        JGE     !l21
        MOV [EBX].TRect.Left,EAX
!l21:
        LODSD
        SCASD
        JGE     !l22
        MOV [EBX].TRect.Bottom,EAX
!l22:
        //process TRect.Right,yTop
        LODSD
        SCASD
        JLE     !l23
        MOV [EBX].TRect.Right,EAX
!l23:
        LODSD
        SCASD
        JLE     !l24
        MOV [EBX].TRect.Top,EAX
!l24:
     End;
End;


Function IsRectEmpty(Const rec:TRect):Boolean;
Begin
     Result := (rec.Left=0)And(rec.Right=0)And(rec.Bottom=0)And(rec.Top=0);
End;


Function IsControlLocked(Control:TControl):Boolean;
Var  AForm:TForm;
Begin
     Result := False;
     If Control <> Nil Then
     Begin
          AForm := Control.Form;
          If AForm Is TForm Then Result := AForm.FLocked;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Some drawing elements                                                     บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{looks like TEdit}
Procedure DrawSystemBorder(Control:TControl;Var rec:TRect;Style:TBorderStyle);


Begin
  If Control = Nil Then Exit;
  If Style In [bsSingle] Then
    Begin
      Control.Canvas.ShadowedBorder(rec,clDkGray,clWhite);
      InflateRect(rec,-1,-1);
      Control.Canvas.ShadowedBorder(rec,clBlack,clLtGray);
      InflateRect(rec,-1,-1);
    End;
End;


{looks like TGroupBox}
Procedure DrawSystemFrame(Control:TControl;Var rec:TRect;LightColor,DarkColor:TColor);
Var  rc1:TRect;
Begin
     If Control = Nil Then Exit;
     rc1 := rec;
     Control.Canvas.Pen.color := LightColor;
     Inc(rc1.Left);
     Dec(rc1.Top);
     Control.Canvas.Rectangle(rc1);
     Control.Canvas.Pen.color := DarkColor;
     OffsetRect(rc1,-1,1);
     Control.Canvas.Rectangle(rc1);
     Control.Canvas.Pen.color := Control.color;
     Control.Canvas.Pixels[rec.Left,rec.Bottom]:=Control.Canvas.Pen.Color;
     Control.Canvas.Pixels[rec.Right,rec.Top]:=Control.Canvas.Pen.Color;
     InflateRect(rec,-1,-1);
     InflateRect(rec,-1,-1);
End;


{looks like TButton}
Procedure DrawButtonFrame(Control:TControl;Var rc1:TRect;IsDown,IsDefault,HasFocus:Boolean);

Var  Canvas:TCanvas;

{$IFDEF OS2}
     PBG:TColor;
     offs:LongInt;
{$ENDIF}

Label Warp;
Begin
  Canvas:=Control.Canvas;
  If Application<>Nil Then
     Begin
       {$IFDEF OS2}
       Case goSysInfo.OS.Platform Of
              OS2Ver20, OS2Ver30: {WARP}
         Begin
Warp:
           {typecast To have access To BackColor}
           If Control.Parent <> Nil
             Then PBG := TForm(Control.Parent).Color
             Else PBG := clBackGround;

           If IsDefault
             Then Canvas.Pen.color := clBtnDefault
             Else Canvas.Pen.color := PBG;
           Canvas.Rectangle(rc1);
           InflateRect(rc1,-1,-1);

           Canvas.Pen.color := clWindowFrame;
           Canvas.Rectangle(rc1);
           InflateRect(rc1,-1,-1);
           If IsDown
             Then Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight)
             Else Canvas.ShadowedBorder(rc1,clBtnHighlight,clBtnShadow);
           InflateRect(rc1,-1,-1);

           Canvas.Pen.color := PBG;
           If IsDefault
             Then offs := 3
             Else offs := 2;
           Canvas.Pixels[rc1.Left-offs,rc1.Bottom-offs]:=Canvas.Pen.color;
           Canvas.Pixels[rc1.Left-offs,rc1.Top+offs]:=Canvas.Pen.color;
           Canvas.Pixels[rc1.Right+offs,rc1.Bottom-offs]:=Canvas.Pen.color;
           Canvas.Pixels[rc1.Right+offs,rc1.Top+offs]:=Canvas.Pen.color;
         End;
       OS2Ver40, OS2Ver45: {MERLIN}
         Begin
           {typecast To have access To BackColor}
           If Control.Parent <> Nil
             Then PBG := TForm(Control.Parent).Color
             Else PBG := clBackGround;
           If IsDefault
             Then Canvas.Pen.color := clBtnDefault
             Else Canvas.Pen.color := PBG;
           Canvas.Rectangle(rc1);
           InflateRect(rc1,-1,-1);
           If IsDefault
             Then
                Begin
                  Canvas.Rectangle(rc1);
                  InflateRect(rc1,-1,-1);
                End
             Else
                Begin
                  Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight);
                  InflateRect(rc1,-1,-1);
                End;
           If IsDown
             Then
               Begin
                 Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight);
                 InflateRect(rc1,-1,-1);
                 Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight);
               End
             Else
               Begin
                 Canvas.ShadowedBorder(rc1,clBtnHighlight,clBtnShadow);
                 InflateRect(rc1,-1,-1);
                 Canvas.ShadowedBorder(rc1,clBtnHighlight,clBtnShadow);
               End;
           InflateRect(rc1,-1,-1);
         End;
       End;
       {$ENDIF}
       {$IFDEF Win32}
Warp:
       If IsDefault Then
         Begin
           Canvas.Pen.color := clBtnDefault;
           Canvas.Rectangle(rc1);
           InflateRect(rc1,-1,-1);
         End;

       If IsDown
         Then
           Begin
             Canvas.Pen.color := clBtnShadow;
             Canvas.Rectangle(rc1);
             InflateRect(rc1,-1,-1);
           End
         Else
           Begin
             Canvas.ShadowedBorder(rc1,clBtnHighlight,cl3DDkShadow);
             InflateRect(rc1,-1,-1);
             Canvas.ShadowedBorder(rc1,cl3DLight,clBtnShadow);
             InflateRect(rc1,-1,-1);
           End;
       {$ENDIF}
     End
   Else goto Warp;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TFrameControl Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Function StartWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
Begin
     Result:=WinDefWindowProc(Win,Msg,para1,para2);
End;
{$ENDIF}

{$IFDEF Win32}
Function StartWndProc(Win:HWND;Msg:ULONG;para1:WParam;para2:LParam):LRESULT;APIENTRY;
Begin
     Result:=DefWindowProc(Win,Msg,para1,para2);
End;
{$ENDIF}

{$IFDEF OS2}
Type
    PStructureArray=^TStructureArray;
    TStructureArray=Array[0..65000] Of SWP;

    TFmtFrameMessage=Record
         Message: LongWord;
         ReceiverClass: TObject;
         Receiver: HWindow;
         Handled: LongBool;  {True If the Message was Handled}
         structure: PStructureArray;
         Rect: ^RECTL;
         Count: LongWord;     {Count Of elements In structure}
    End;

    TCalcFRectMessage=Record
         Message: LongWord;
         ReceiverClass: TObject;
         Receiver: HWindow;
         Handled: LongBool;  {True If the Message was Handled}
         Rect: ^RECTL;
         Frame: LongWord;     {Frame indicator}
         Result: LongBool;    {Rect calculated indicator}
    End;
{$ENDIF}


{$IFDEF OS2}
Procedure TFrameControl.WMActivate(Var Msg:TWMActivate);
Begin
End;
{$ENDIF}


Function TFrameControl.GetStandardFont:TFont;
Begin
  If Result=Nil
    Then Result:=Inherited GetStandardFont;
  Result:=Inherited GetStandardFont;
End;

{$IFDEF Win32}
Procedure TFrameControl.WMClose(Var Msg:TWMClose);
Begin
     If FChild <> Nil Then FChild.Close;

     Msg.Handled := True;
     Msg.Result := 0;
End;


Procedure TFrameControl.WMActivate(Var Msg:TWMActivate);
Begin
     If Child = Nil Then Exit;

     If Msg.Active <> WA_INACTIVE Then
     Begin
          Child.Focus;
     End
     Else
     Begin
          // form und mdi child deaktivieren
     End;
End;


Procedure TFrameControl.WMChildActivate(Var Msg:TMessage); {only for MDI children}
Begin
     If Child = Nil Then Exit;

     Child.Focus;
End;
{$ENDIF}

{$IFDEF Win32}
Type
    PMenuHandleItem=^TMenuHandleItem;
    TMenuHandleItem=Record
         FObject:TComponent;
         FHandle:HWindow;
    End;


{todo FMenuHandleList in TMenu verlagern...}
Procedure NewMenuHandleItem(AOwner:TForm;AHandle:LongWord;AObject:TComponent);
Var  pmhi:PMenuHandleItem;
     FOwner:TFrameControl;
Begin
     If AHandle = 0 Then Exit;
     If AObject = Nil Then Exit;
     FOwner := TFrameControl(AOwner);
     If FOwner Is TFrameControl Then AOwner := FOwner.Child;
     If Not (AOwner Is TForm) Then Exit;
     If AOwner.FMenuHandleList = Nil Then AOwner.FMenuHandleList.Create;

     GetMem(pmhi, SizeOf(TMenuHandleItem));
     pmhi^.FObject := AObject;
     pmhi^.FHandle := AHandle;
     AOwner.FMenuHandleList.Add(pmhi);
End;


Procedure DisposeMenuHandleItem(AOwner:TForm;AHandle:LongWord;AObject:TComponent);
Var  pmhi:PMenuHandleItem;
     I:LongInt;
     FOwner:TFrameControl;
Begin
     If AHandle = 0 Then Exit;
     If AObject = Nil Then Exit;
     FOwner := TFrameControl(AOwner);
     If FOwner Is TFrameControl Then AOwner := FOwner.Child;
     If Not (AOwner Is TForm) Then Exit;
     If AOwner.FMenuHandleList = Nil Then Exit;

     For I := AOwner.FMenuHandleList.Count-1 Downto 0 Do
     Begin
          pmhi := PMenuHandleItem(AOwner.FMenuHandleList.Items[I]);
          If (pmhi^.FObject = AObject) And (pmhi^.FHandle = AHandle) Then
          Begin
               FreeMem(pmhi, SizeOf(TMenuHandleItem));
               AOwner.FMenuHandleList.Delete(I);
          End;
     End;
     If AOwner.FMenuHandleList.Count = 0 Then
     Begin
          AOwner.FMenuHandleList.Destroy;
          AOwner.FMenuHandleList := Nil;
     End;
End;


Function GetMenuHandleItem(AOwner:TForm;AHandle:LongWord):TComponent;
Var  pmhi:PMenuHandleItem;
     I:LongInt;
     FOwner:TFrameControl;
Begin
     Result := Nil;
     If AHandle = 0 Then Exit;
     FOwner := TFrameControl(AOwner);
     If FOwner Is TFrameControl Then AOwner := FOwner.Child;
     If Not (AOwner Is TForm) Then Exit;
     If AOwner.FMenuHandleList = Nil Then Exit;

     For I := 0 To AOwner.FMenuHandleList.Count-1 Do
     Begin
          pmhi := PMenuHandleItem(AOwner.FMenuHandleList.Items[I]);
          If pmhi^.FHandle = AHandle Then
          Begin
               Result := pmhi^.FObject;
               Exit;
          End;
     End;
End;


Procedure TFrameControl.WMInitMenuPopup(Var Msg:TMessage);
Var  Win:LongWord;
     Menu:TMenu;
     entry:TMenuItem;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If Not (FChild Is TForm) Then Exit;

     Win := Msg.Param1;
     entry := TMenuItem(GetMenuHandleItem(FChild,Win));

     If entry Is TMenuItem Then Menu := entry.Menu
     Else
     Begin
          Menu:=TMenu(entry);
          If Not (Menu Is TMenu) Then Menu := Nil;
          entry := Nil;
     End;
     FChild.FLastMenu := Menu;
     FChild.FLastEntry := entry;

     FChild.MenuInit(Menu,entry);
End;


Procedure TFrameControl.WMMenuSelect(Var Msg:TMessage);
Var  Win:LongWord;
     Menu:TMenu;
     entry:TMenuItem;
     AParent:TMenuItem;
     Flags:LongWord;{Martin}
     Id:Word;
Begin
     If Not (FChild Is TForm) Then Exit;

     Id := Msg.Param1Lo;
     Flags := Msg.Param1Hi;
     Win := Msg.Param2;                          //Parent-Menu-Handle
     If (Flags = $0FFFF) And (Win = 0) Then
     Begin
          FChild.MenuEnd(FChild.FLastMenu,FChild.FLastEntry);

          Application.Hint := '';
          Exit;
     End;

     entry := TMenuItem(GetMenuHandleItem(FChild,Win));
     AParent := entry;

     If entry Is TMenuItem Then
     Begin
          Menu := entry.Menu;
          If Menu = Nil Then Exit;
     End
     Else
     Begin
          Menu:=TMenu(entry);
          If Not (Menu Is TMenu) Then Exit;
     End;
     FChild.FLastMenu := Menu;

     If Flags And MF_POPUP = 0 Then  {Id Is Command}
     Begin
{todo}     
          entry := Menu.ItemFromInternalCommand(Id);
     End
     Else                            {Id Is Popup-Handle}
     Begin
          If AParent Is TMenuItem Then entry := TMenuItem(AParent.Items[Id])
          Else Exit;
     End;
     FChild.FLastEntry := entry;

     FChild.MenuItemFocus(Menu,entry);

     If entry <> Nil Then Application.Hint := GetLongHint(entry.Hint)
     Else Application.Hint := '';
End;


Procedure TFrameControl.WMMenuChar(Var Msg:TMessage);
Var  Win:LongWord;
     CH:Char;
     REP:Byte;
     Menu:TMenu;
     entry:TMenuItem;
Begin
     If Not (FChild Is TForm) Then Exit;

     Win := Msg.Param2;
     CH := Chr(Lo(Msg.Param1));
     REP := 1;
     entry := TMenuItem(GetMenuHandleItem(FChild,Win));

     If entry Is TMenuItem Then Menu := entry.Menu
     Else
     Begin
          Menu:=TMenu(entry);
          If Not (Menu Is TMenu) Then Exit;
     End;
     entry := Menu.SelectedMenuItem;

     FChild.MenuCharEvent(Menu,entry,CH,REP);

     If CH = #0 Then
     Begin
          Msg.Handled := True;
          Msg.Result := 0;
     End;
End;
{$ENDIF}


{$IFDEF OS2}
{wird nicht aufgerufen}
Procedure TFrameControl.WMCalcFrameRect(Var Msg:TMessage);
Var aMsg:TCalcFRectMessage Absolute Msg;
    List:TList;
    T:LongInt;
    Toolbar:TToolbar;
Begin
     DefaultHandler(Msg);  {Do Default Action}

     If aMsg.Result Then
       If aMsg.Frame<>0 Then
     Begin
          List:=FChild.FToolBarLists[tbBottom];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Inc(aMsg.Rect^.yBottom,Toolbar.Size);
          End;

          List:=FChild.FToolBarLists[tbTop];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Dec(aMsg.Rect^.yTop,Toolbar.Size);
          End;

          List:=FChild.FToolBarLists[tbLeft];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Inc(aMsg.Rect^.XLeft,Toolbar.Size);
          End;

          List:=FChild.FToolBarLists[tbRight];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Dec(aMsg.Rect^.xRight,Toolbar.Size);
          End;
     End;
End;


Procedure TFrameControl.WMFormatFrame(Var Msg:TMessage);
Var aMsg:TFmtFrameMessage Absolute Msg;
    ClientIndex:Word;
    T:Word;
    TempSWP:SWP;
    t1:TToolbarAlign;
    ClientWin:HWND;
    List:TList;
    t2:LongInt;
    Toolbar:TToolbar;
    MaxLeft,MaxRight,MaxBottom,MaxTop:LongInt;
Begin
     DefaultHandler(Msg);  {Do Default Action}

     ClientIndex := 65535;
     // Locate SWP For client Window
     If FChild = Nil Then Exit;
     ClientWin := FChild.Handle;
     For T := 0 To aMsg.Count Do
     Begin
          If aMsg.structure^[T].HWND=ClientWin Then
          Begin
               ClientIndex:=T;
               break;
          End;
     End;
     If ClientIndex=65535 Then Exit;  {something Is wrong here}

     MaxLeft:=0;
     List:=FChild.FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
     End;

     MaxRight:=0;
     List:=FChild.FToolBarLists[tbRight];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
     End;

     MaxBottom:=0;
     List:=FChild.FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxBottom,Toolbar.Size);
     End;

     MaxTop:=0;
     List:=FChild.FToolBarLists[tbTop];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxTop,Toolbar.Size);
     End;

     {Set up TopToolBar SWP}
     //zuerst Top und Bottom !
     For t1 := High(TToolbarAlign) Downto Low(TToolbarAlign) Do
     Begin
          List:=FChild.FToolBarLists[t1];

          If List<>Nil Then For t2:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[t2]);
               If Toolbar.FVisible Then
               Begin
                    aMsg.structure^[aMsg.Count]:=aMsg.structure^[ClientIndex];
                    If t1 In [tbTop,tbBottom] Then aMsg.structure^[aMsg.Count].CY:=Toolbar.Size
                    Else aMsg.structure^[aMsg.Count].CX:=Toolbar.Size;

                    Case t1 Of
                        tbTop:
                        Begin
                             aMsg.structure^[aMsg.Count].Y:=aMsg.structure^[ClientIndex].Y+
                                                        (aMsg.structure^[ClientIndex].CY-Toolbar.SiZe);
                        End;
                        tbBottom:;
                        tbLeft:;
                        tbRight:
                        Begin
                             aMsg.structure^[aMsg.Count].X:=aMsg.structure^[ClientIndex].X+
                                                           (aMsg.structure^[ClientIndex].CX-Toolbar.Size);
                        End;
                    End; {Case}

                    aMsg.structure^[aMsg.Count].HWND:=Toolbar.Handle;

                    WinSendMsg(aMsg.structure^[aMsg.Count].HWND,
                               WM_ADJUSTWINDOWPOS,
                               LongWord(@aMsg.structure^[aMsg.Count]),
                               0);

                    Inc(aMsg.Count);

                    {Actualize client SWP}
                    Case t1 Of
                        tbTop:Dec(aMsg.structure^[ClientIndex].CY,Toolbar.Size);
                        tbLeft:
                        Begin
                             Dec(aMsg.structure^[ClientIndex].CX,Toolbar.Size);
                             Inc(aMsg.structure^[ClientIndex].X,Toolbar.Size);
                        End;
                        tbRight:Dec(aMsg.structure^[ClientIndex].CX,Toolbar.Size);
                        tbBottom:
                        Begin
                             Dec(aMsg.structure^[ClientIndex].CY,Toolbar.Size);
                             Inc(aMsg.structure^[ClientIndex].Y,Toolbar.Size);
                        End;
                    End; {Case}
               End; //If Visible
          End; //For
     End; {For}

     {Copy client To End Of List - For Speed}
     If aMsg.Count>0 Then
     Begin
          TempSWP:=aMsg.structure^[aMsg.Count-1];
          aMsg.structure^[aMsg.Count-1]:=aMsg.structure^[ClientIndex];
          aMsg.structure^[ClientIndex]:=TempSWP;
          ClientIndex:=aMsg.Count-1;
     End;

     {Set up client RECTL}
     If aMsg.Rect<>Nil Then
     Begin
          Dec(aMsg.Rect^.yTop,(aMsg.Rect^.yTop-aMsg.Rect^.yBottom)-
                               aMsg.structure^[ClientIndex].CY);
          Dec(aMsg.Rect^.xRight,(aMsg.Rect^.xRight-aMsg.Rect^.XLeft)-
                                 aMsg.structure^[ClientIndex].CX);
     End;
     Msg.Handled:=True;
End;


Procedure TFrameControl.WMQueryFrameCtlCount(Var Msg:TMessage);
Var T:TToolbarAlign;
    t1:LongInt;
    List:TList;
    Toolbar:TToolbar;
Begin
     DefaultHandler(Msg);  {Query Default Control Count In aMsg.Result}

     For T := Low(TToolbarAlign) To High(TToolbarAlign) Do
     Begin
          List:=FChild.FToolBarLists[T];
          If List<>Nil Then For t1:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[t1]);
               If Toolbar.FVisible Then Inc(Msg.Result);
          End;
     End;
End;


Procedure TFrameControl.WMQueryTrackInfo(Var Msg:TMessage);
Var  pInfo:PTRACKINFO;
     Flags:LongWord;{Martin}
     Bound:TRect;
     WinRect:TRect;
Begin
     If FChild = Nil Then Exit;
     pInfo := PTRACKINFO(Msg.Param2);
     Flags := Msg.Param1Lo;

     If Flags = TF_MOVE Then
     Begin
          Msg.Handled := Not FChild.Moveable;
     End
     Else
     If Flags And (TF_BOTTOM Or TF_LEFT) <> 0 Then
     Begin
          Msg.Handled := Not (FChild.Moveable And FChild.Sizeable);
     End
     Else
     If Flags And (TF_TOP Or TF_RIGHT) <> 0 Then
     Begin
          Msg.Handled := Not FChild.Sizeable;
     End;

     If Not Msg.Handled Then
     Begin
          Bound.Left := MinInt;
          Bound.Right := MaxInt;
          Bound.Bottom := MinInt;
          Bound.Top := MaxInt;

          WinRect := GetWindowRect;
          Inc(WinRect.Right);
          Inc(WinRect.Top);

          pInfo^.cxBorder := goSysInfo.Screen.SizeBorderSize.CX;
          pInfo^.cyBorder := goSysInfo.Screen.SizeBorderSize.CY;
          pInfo^.cxGrid := 1;
          pInfo^.cyGrid := 1;
          pInfo^.cxKeyboard := 6;
          pInfo^.cyKeyboard := 16;
          pInfo^.rclTrack := RECTL(WinRect);
          pInfo^.rclBoundary := RECTL(Bound);
          pInfo^.ptlMinTrackSize := Point(FChild.Constraints.MinWidth,FChild.Constraints.MinHeight);
          pInfo^.ptlMaxTrackSize := Point(FChild.Constraints.MaxWidth,FChild.Constraints.MaxHeight);
          pInfo^.fs := Flags Or TF_ALLINBOUNDARY;

          Msg.Handled := True;
          Msg.Result := 1;
     End
     Else Msg.Result := 0;     {Disable Dragging}
End;


Procedure TFrameControl.WMMinMaxFrame(Var Msg:TMessage);
Var  pswp:^SWP;
     Flags:LongWord;
Begin
  pswp := Pointer(Msg.Param1);
  If pswp = Nil Then Exit;

  Flags := pswp^.fl And (SWP_RESTORE Or SWP_MINIMIZE Or SWP_MAXIMIZE);
  Case Flags Of
    SWP_RESTORE:
      Begin
        If FChild.OnRestore <> Nil Then FChild.OnRestore(FChild);
      End;
    SWP_MINIMIZE:
      Begin
        If FChild.OnMinimize <> Nil Then FChild.OnMinimize(FChild);
      End;
    SWP_MAXIMIZE:
      Begin
        If FChild.OnMaximize <> Nil Then FChild.OnMaximize(FChild);
      End;
  End;
End;
{$ENDIF}


{$IFDEF Win32}
Procedure TFrameControl.WMGetMinMaxInfo(Var Msg:TMessage);
Var  pInfo:PMINMAXINFO;
Begin
     pInfo := PMINMAXINFO(Msg.Param2);

     pInfo^.ptMinTrackSize := Point(FChild.Constraints.MinWidth,FChild.Constraints.MinHeight);
     pInfo^.ptMaxTrackSize := Point(FChild.Constraints.MaxWidth,FChild.Constraints.MaxHeight);
     {Min/Max
     pInfo^.ptMaxPosition :=
     pInfo^.ptMaxSize :=}

     Msg.Handled := True;
     Msg.Result := 0;
End;


Procedure TFrameControl.WMSysCommand(Var Msg:TMessage); {untested}
Var  WParam,Flags:LongWord;
Begin
     WParam := Msg.Param1 And $FFF0;

     Flags := WParam;
     Case Flags Of
       SC_RESTORE:
          If FChild.OnRestore <> Nil Then FChild.OnRestore(FChild);
       SC_MINIMIZE:
          If FChild.OnMinimize <> Nil Then FChild.OnMinimize(FChild);
       SC_MAXIMIZE:
          If FChild.OnMaximize <> Nil Then FChild.OnMaximize(FChild);
     End;
End;
{$ENDIF}


Procedure TFrameControl.SetupComponent;
Begin
     Inherited SetupComponent;

     FResourceModule := 0;
     FResourceId := 0;
     FWindowId := FResourceId;
     FOwnerDraw := False;
     FParentPenColor := False;
     FParentColor := False;
     Font := Screen.DefaultFrameFont;
End;


Procedure TFrameControl.SetResourceId(NewId:LongWord);
Begin
     If Handle <> 0 Then Exit;

     FResourceId := NewId;
     FWindowId := NewId; {!!}
End;


Procedure TFrameControl.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     If FChild Is TForm Then
     Begin
          {$IFDEF Win32}
          If FChild.Parent <> Nil Then Params.Style := Params.Style Or WS_CHILD;

          If Not FChild.Designed Then
          Begin
               If FChild.BorderStyle = bsDialog Then
                 Params.ExStyle := WS_EX_DLGMODALFRAME Or WS_EX_WINDOWEDGE;

               If FChild.FBorderIcons * [biHelp] <> [] Then
                 Params.ExStyle := Params.ExStyle Or WS_EX_CONTEXTHELP;
          End;
          {$ENDIF}
          Params.FrameStyle := FChild.GetFrameFlags;
     End;
End;


Procedure TFrameControl.CreateWnd;

Var Params:TCreateParams;
    FrameFlags:ULONG;
    WindowFlags:ULONG;
    cCaption:CString;
    ParentWin,OwnerWin:HWND;
    ClassData:TClassData;
    rc:TRect;
    ShellPos:Boolean;

    {$IFDEF OS2}
    WFlags:ULONG;
    fcd:FRAMECDATA;
    TitlebarWin:HWindow;
    OldWndProc:Pointer;
    {$ENDIF}
    {$IFDEF Win32}
    rc1:TRect;
    OldWndProc:Pointer;
    ExtendedFlags:ULONG;
    {$ENDIF}

Begin
     If Handle<>0 Then Exit;

     FFirstShow := True;

     RegisterClass;
     GetClassData(ClassData);

     If FCaption=Nil Then cCaption:=''
     Else cCaption:=FCaption^;

     If ((FForm<>Nil)And(Not FForm.Designed)) Then
     Begin
          ShellPos := FForm.Position In [poDefault,poDefaultPosOnly,poDefaultSizeOnly];

          If (FForm.FormStyle = fsMDIChild) And (FForm.Position = poDefault)
          Then ShellPos := False;

          If FForm.Position=poScreenCenter Then
          Begin
               FLeft:=(Screen.Width-FWidth) Div 2;
               If FLeft<0 Then FLeft:=0;
               FBottom:=(Screen.Height-FHeight) Div 2;
               If FBottom<0 Then FBottom:=0;
               FForm.FLeft:=FLeft;
               FForm.FBottom:=FBottom;
          End;
     End
     Else ShellPos:=False;

     If (FWidth=0) Or (FHeight=0) Then
     Begin
          If (Parent<>Nil) And (Parent.Handle<>0) Then
          Begin
               rc:=Parent.GetClientRect;
               FWidth:=rc.Right-rc.Left+1;
               FHeight:=rc.Top-rc.Bottom+1;
               FLeft:=rc.Left;
               {$IFDEF OS2}
               FBottom:=rc.Bottom;
               {$ENDIF}
               {$IFDEF Win32}
               WinUser.GetClientRect(Parent.Handle,RECTL(rc1));
               FBottom:=((rc1.Bottom-rc1.Top)-FHeight)-rc.Bottom;
               {$ENDIF}
          End
          Else
          Begin
               ShellPos := True;
               FLeft:=0;
               FBottom:=0;
               FWidth:=0;
               FHeight:=0;
          End;
     End
     Else
     Begin
          //direkt zuweisen !!!
          {$IFDEF Win32}
          If Parent<>Nil Then FBottom:=Parent.FHeight-FBottom-FHeight
          Else FBottom:=Screen.Height-FBottom-FHeight;
          {$ENDIF}
     End;

     If Parent<>Nil Then
     Begin
          If Parent.Handle=0 Then ParentWin:=HWND_DESKTOP
          Else ParentWin:=Parent.Handle;
     End
     Else ParentWin:=HWND_DESKTOP;

     If FModalParent<>Nil Then OwnerWin:=FModalParent.Handle
     Else OwnerWin:=ParentWin;

     CreateParams(Params);

     WindowFlags := Params.Style;
     FrameFlags := Params.FrameStyle;

     {Create Frame Window}
     {$IFDEF OS2}
     If ShellPos Then FrameFlags := FrameFlags Or FCF_SHELLPOSITION;

     fcd.cb:=SizeOf(FRAMECDATA);
     fcd.flCreateFlags:=FrameFlags;
     fcd.hModResources:=FResourceModule;
     fcd.idResources:=FResourceId;

     FHandle:=WinCreateWCWindow(ParentWin,       //Parent
                                WC_FRAME,
                                cCaption,
                                WindowFlags,     //flStyle
                                0,0,             //leave This ON 0 - Set by .Show
                                0,0,             //Position And Size
                                ParentWin,       //Owner
                                {OwnerWin,       //Owner erst unten setzen !}
                                HWND_TOP,        //Insert behind
                                FResourceId,     //Window Id
                                @fcd,            //CtlData
                                Nil);            //Presparams

     WinSetOwner(FHandle,OwnerWin);
     {$ENDIF}

     {$IFDEF Win32}
     If ClassData.ClassStyle * [wcsClipChildren] <> [] Then
       If Not Designed Then FrameFlags := FrameFlags Or WS_CLIPCHILDREN;

     If ClassData.ClassStyle * [wcsClipSiblings] <> []
     Then FrameFlags := FrameFlags Or WS_CLIPSIBLINGS;

     If ShellPos Then
     Begin
          If ((FForm<>Nil)And(Not FForm.Designed)) Then
          Begin
              If FForm.Position<>poDefaultSizeOnly Then
              Begin
                   FLeft := CW_USEDEFAULT;
                   FBottom := CW_USEDEFAULT;
              End;
              If FForm.Position<>poDefaultPosOnly Then
              Begin
                   FWidth := CW_USEDEFAULT;
                   FHeight := CW_USEDEFAULT;
              End;
          End
          Else
          Begin
              FLeft := CW_USEDEFAULT;
              FBottom := CW_USEDEFAULT;
              FWidth := CW_USEDEFAULT;
              FHeight := CW_USEDEFAULT;
          End;
     End;

     WindowFlags := WindowFlags Or FrameFlags;
     ExtendedFlags := Params.ExStyle;
     OemToAnsi(cCaption, cCaption);

     If ExtendedFlags=0
     Then FHandle:=CreateWindow(ClassData.ClassName,
                                cCaption,
                                WindowFlags,
                                FLeft,FBottom,
                                FWidth,FHeight,
                                OwnerWin,
                                FResourceId,
                                DllModule,
                                Nil)
     Else FHandle:=CreateWindowEx(ExtendedFlags,
                                  ClassData.ClassName,
                                  cCaption,
                                  WindowFlags,
                                  FLeft,FBottom,
                                  FWidth,FHeight,
                                  OwnerWin,
                                  FResourceId,
                                  DllModule,
                                  Nil);
     {$ENDIF}
     If FHandle=0 Then CreateError;

     {$IFDEF Win32}
     rc:=GetWindowRect;
     FLeft:=rc.Left;
     FBottom:=rc.Bottom;
     FWidth:=rc.Right-rc.Left +1;
     FHeight:=rc.Top-rc.Bottom +1;
     {$ENDIF}

     {$IFDEF OS2}
     If ShellPos Then
       If FForm<>Nil Then If Not FForm.Designed Then
         If FForm.Position In [poDefault,poDefaultPosOnly,poDefaultSizeOnly] Then
     Begin
          If FForm.Position In [poDefaultPosOnly,poDefaultSizeOnly] Then
          Begin
              WFlags:=SWP_ZORDER Or SWP_SHOW Or SWP_NOREDRAW;
              WinSetWindowPos(FHandle,HWND_TOP,0,0,0,0,WFlags);
          End;

          rc:=GetWindowRect;
          If FForm.Position In [poDefault,poDefaultPosOnly] Then
          Begin
               FLeft:=rc.Left;
               FBottom:=rc.Bottom;
               FForm.FLeft:=FLeft;
               FForm.FBottom:=FBottom;
          End;

          If FForm.Position In [poDefault,poDefaultSizeOnly] Then
          Begin
               FWidth:=rc.Right-rc.Left;
               FHeight:=rc.Top-rc.Bottom;
               FForm.FWidth:=FWidth;
               FForm.FHeight:=FHeight;
          End;

          If FForm.Position In [poDefaultPosOnly,poDefaultSizeOnly] Then
          Begin
              WinSetWindowPos(FHandle,HWND_TOP,FLeft,FBottom,FWidth,FHeight,SWP_SIZE Or SWP_MOVE Or
                              SWP_ZORDER Or SWP_HIDE);
          End;
     End;
     {$ENDIF}

     {$IFDEF OS2}
     WinSetWindowULong(Handle,QWL_USER,LongWord(Self));    {VMT Pointer}
     FDefWndProc:=Pointer(WinSubClassWindow(Handle,@SubclassedWndProc));
     {$ENDIF}
     {$IFDEF Win32}
     SetWindowLong(Handle,GWL_USERDATA,LongWord(Self));    {VMT Pointer}
     OldWndProc:=Pointer(SetWindowLong(Handle,GWL_WNDPROC,Longword(@SubclassedWndProc)));
     If @FDefWndProc = Nil Then FDefWndProc := OldWndProc;    {WinNT !!!}
     {$ENDIF}
     If Application <> Nil Then
       If Application.GradientTitlebar Then
       Begin
            {$IFDEF OS2}
            TitlebarWin := WinWindowFromID(FHandle,FID_TITLEBAR);
            OldWndProc := WinSubClassWindow(TitlebarWin, @SubclassedTitlebarProc);
            If OldWndProc <> Nil Then OldTitleBarProc := OldWndProc;
            {$ENDIF}
       End;

     If (Not FEnabled) And (Not FForm.Designed) Then Disable;
     If (Not FVisible) And (Not FForm.Designed) Then Hide;

     If FFont = Nil Then FFont := StandardFont;
     UpdateFont;

     SetupShow;
     If OnSetupShow<>Nil Then OnSetupShow(Self);
End;


Procedure TFrameControl.GetClassData(Var ClassData:TClassData);
Begin
     ClassData.StandardClass:=False;
     ClassData.ClassName:=WDSibylPasWndTxt;
     ClassData.WindowProc:=@StartWndProc;
     {!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
     ClassData.ClassStyle:=[wcsSizeRedraw,{wcsClipChildren,}wcsClipSiblings{,wcsSaveBits}];
     ClassData.DataCount:=4;
     ClassData.ClassULong:=0;
End;


Function TFrameControl.GetClientRect:TRect;
Var MaxLeft,MaxBottom,MaxRight,MaxTop:LongInt;
    List:TList;
    T:LongInt;
    Toolbar:TToolbar;
Begin
     Result := Inherited GetClientRect;

     If FChild=Nil Then Exit;

     MaxLeft:=0;
     List:=FChild.FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
     End;

     MaxRight:=0;
     List:=FChild.FToolBarLists[tbRight];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
     End;

     MaxBottom:=0;
     List:=FChild.FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxBottom,Toolbar.Size);
     End;

     MaxTop:=0;
     List:=FChild.FToolBarLists[tbTop];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxTop,Toolbar.Size);
     End;

     Inc(Result.Left,MaxLeft);
     Inc(Result.Bottom,MaxBottom);
     Dec(Result.Right,MaxRight);
     Dec(Result.Top,MaxTop);
End;


Destructor TFrameControl.Destroy;
Begin
     Inherited Destroy;

     If FChild <> Nil Then
     Begin
          FChild.FFrame := Nil;
          FChild.Destroy;
     End;
     FChild := Nil;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TSizeBorder Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSizeBorder.SetupComponent;
Begin
     Inherited SetupComponent;

     FZOrder := zoTop;
     ParentColor := True;
     FOwnerDraw:=True;
     FTabStop := False;
     FCursorTabStop := False;
     BorderAlign := baHorizontal;
     FSizing := False;
     FWidth:=100;
     FHeight:=5;
     YStretch:=ysFixed;
End;


Procedure TSizeBorder.SetBorderAlign(Value:TSizeBorderAlign);
Var OldValue:TSizeBorderAlign;
Begin
     If Value = FBorderAlign Then Exit;

     OldValue:=FBorderAlign;
     FBorderAlign := Value;
     Case FBorderAlign Of
       baHorizontal, baHorizontalSizing:
       Begin
            If OldValue In [baVertical,baParentHeight,baLeft,baRight] Then
              FWidth:=FHeight;
            FHeight := 5;
            Align:=alNone;
            YStretch:=ysFixed;
            Visible:=True;
       End;
       baVertical, baVerticalSizing:
       Begin
            If OldValue In [baHorizontal,baParentWidth,baBottom,baTop] Then
              FHeight:=FWidth;
            FWidth := 5;
            Align:=alNone;
            XStretch:=xsFixed;
            Visible:=True;
       End;
       baParentWidth:
       Begin
            FWidth := 0;
            FHeight := 5;
            FLeft:=0;
            Align:=alNone;
            XAlign:=xaLeft;
            XStretch:=xsParent;
            YStretch:=ysFixed;
            Visible:=True;
       End;
       baParentHeight:
       Begin
            FWidth := 5;
            FHeight := 0;
            FBottom:=0;
            Align:=alNone;
            YAlign:=yaBottom;
            YStretch:=ysParent;
            XStretch:=xsFixed;
            Visible:=True;
       End;
       baTop:
       Begin
            FWidth := 0;
            FHeight := 5;
            FCursor := crVSplit;
            Align := alTop;
            YStretch:=ysFixed;
            Visible := True;
       End;
       baBottom:
       Begin
            FWidth := 0;
            FHeight := 5;
            FCursor := crVSplit;
            Align := alBottom;
            YStretch:=ysFixed;
            Visible := True;
       End;
       baLeft:
       Begin
            FWidth := 5;
            FHeight := 0;
            FCursor := crHSplit;
            Align := alLeft;
            XStretch:=xsFixed;
            Visible := True;
       End;
       baRight:
       Begin
            FWidth := 5;
            FHeight := 0;
            FCursor := crHSplit;
            Align := alRight;
            XStretch:=xsFixed;
            Visible := True;
       End;
     End;
End;

{$HINTS OFF}
Procedure TSizeBorder.Redraw(Const rec:TRect);
Var  rc1:TRect;
Begin
  rc1 := ClientRect;
  Canvas.ShadowedBorder(rc1,clWhite,clBlack);
  InflateRect(rc1,-1,-1);
  Canvas.ShadowedBorder(rc1,clLtGray,clDkGray);
  InflateRect(rc1,-1,-1);
  Canvas.Pen.color := color;
  Canvas.Line(rc1.Left,rc1.Bottom,rc1.Right,rc1.Top);
End;
{$HINTS ON}


Procedure TSizeBorder.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
  Inherited MouseDown(Button,ShiftState,X,Y);

  If Parent = Nil Then Exit;

  Case FBorderAlign Of
    baLeft,baRight, baVerticalSizing:   FOffs := X;
    baBottom,baTop, baHorizontalSizing: FOffs := Y;
    Else Exit;
  End;
  FDelta := 0;

  OldFgMode := Screen.Canvas.Pen.Mode;
  OldLineWidth := Screen.Canvas.Pen.Width;
  OldLineType := Screen.Canvas.Pen.Style;

  Screen.Canvas.Pen.Mode := pmNot;
  Screen.Canvas.Pen.Width := 5;
  Screen.Canvas.Pen.Style := psSolid;

  DrawSizeLine;
  MouseCapture := True;
  FSizing := True;
End;

Procedure TSizeBorder.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If FSizing Then
     Begin
          DrawSizeLine;
          Case FBorderAlign Of
            baLeft,baRight, baVerticalSizing  : FDelta := X - FOffs;
            baBottom,baTop, baHorizontalSizing: FDelta := Y - FOffs;
            Else Exit;
          End;
          If FOnSizing <> Nil Then FOnSizing(Self,FDelta);
          DrawSizeLine;
     End;
End;

Procedure TSizeBorder.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If FSizing Then
     Begin
          DrawSizeLine;
          MouseCapture := False;
          FSizing := False;

          Screen.Canvas.Pen.Mode := OldFgMode;
          Screen.Canvas.Pen.Width := OldLineWidth;
          Screen.Canvas.Pen.Style := OldLineType;

          Case FBorderAlign Of
            baLeft,baRight, baVerticalSizing  : FDelta := X - FOffs;
            baBottom,baTop, baHorizontalSizing: FDelta := Y - FOffs;
            Else Exit;
          End;
          If FOnSized <> Nil Then FOnSized(Self,FDelta);
     End;
End;

Procedure TSizeBorder.DrawSizeLine;
Var  pt:TPoint;
Begin
  Case FBorderAlign Of
    baLeft,baRight, baVerticalSizing:
      Begin
        pt.X := FDelta + 2;
        pt.Y := 0;
        pt := ClientToScreen(pt);
        Screen.Canvas.Line(pt.X,pt.Y,pt.X,pt.Y+Height);
      End;
    baBottom,baTop, baHorizontalSizing:
      Begin
        pt.X := 0;
        pt.Y := FDelta + 2;
        pt := ClientToScreen(pt);
        Screen.Canvas.Line(pt.X,pt.Y,pt.X+Width,pt.Y);
    End;
  End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TToolbar Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TToolbar.Hide;
Begin
     Inherited Hide;
     If (Owner Is TForm) Then TForm(Owner).AlignToolBars;
End;


Procedure TToolbar.Show;
Begin
     If Not FVisible Then
     Begin
         Inherited Show;
         If (Owner Is TForm) Then TForm(Owner).AlignToolBars;
     End
     Else Inherited Show;
End;

Procedure TToolbar.EnableCommands(Cmds:Array Of TCommand);
Var  T,t1:LongInt;
     Control:TControl;
Begin
     For T:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[T];
          If Control.FCommand<>0 Then
          Begin
               For t1:=Low(Cmds) To High(Cmds) Do
                 If Control.FCommand=Cmds[t1] Then
                 Begin
                      Control.Enabled:=True;
                      break;
                 End;
          End;
     End;
End;

Procedure TToolbar.DisableCommands(Cmds:Array Of TCommand);
Var  T,t1:LongInt;
     Control:TControl;
Begin
     For T:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[T];
          If Control.FCommand<>0 Then
          Begin
               For t1:=Low(Cmds) To High(Cmds) Do
                 If Control.FCommand=Cmds[t1] Then
                 Begin
                      Control.Enabled:=False;
                      break;
                 End;
          End;
     End;
End;

Procedure TToolbar.SetupComponent;
Begin
     Inherited SetupComponent;

     FHeight:=50;
     FWidth:=50;
     color:=clLtGray;
     FParentPenColor:=True;
     ParentColor:=False;
     CursorTabStop:=False;
     TabStop:=False;
     FAlignment:=tbTop;
     FBevelStyle:=tbRaised;
     Include(ComponentState, csAcceptsControls);
     FSizeable:=False;
     FIsToolBar:=True;
     FOrder:=-1;
     SizeBorderCtrl:=Nil;
End;


Procedure TToolbar.CreateWnd;
Begin
     SetOrder(FOrder);

     If FParent Is TForm Then FParent := FParent.FFrame;  {Frame}
     Inherited CreateWnd;
     FParent := TControl(Owner);         {Form}
End;


Procedure TToolbar.SetupShow;
Var  rc:TRect;
Begin
     rc := Parent.GetClientRect;
     Case FAlignment Of
         tbTop:
         Begin
              FLeft := 0;
              {$IFDEF OS2}
              FBottom := rc.Top-FHeight+1;
              {$ENDIF}
              {$IFDEF Win32}
              FBottom := 0;
              {$ENDIF}
              FWidth := rc.Right-rc.Left+1;
         End;
         tbBottom:
         Begin
              FLeft := 0;
              {$IFDEF OS2}
              FBottom := 0;
              {$ENDIF}
              {$IFDEF Win32}
              FBottom := rc.Top-rc.Bottom+1;
              {$ENDIF}
              FWidth := rc.Right-rc.Left+1;
         End;
         tbLeft:
         Begin
              FBottom := 0;
              FLeft := rc.Left-FWidth;
              FHeight := rc.Top-rc.Bottom+1;
         End;
         tbRight:
         Begin
              FBottom := 0;
              FLeft := rc.Right+1;
              FHeight := rc.Top-rc.Bottom+1;
         End;
     End; {Case}
End;


Procedure TToolbar.Redraw(Const rec:TRect);
Var  rc:TRect;
Begin
     If FCanvas = Nil Then Exit;
     FCanvas.FillRect(rec,color);

     If FBevelStyle <> tbNone Then
     Begin
          rc := GetClientRect;
          If FBevelStyle = tbRaised Then FCanvas.ShadowedBorder(rc,clWhite,clDkGray)
          Else FCanvas.ShadowedBorder(rc,clDkGray,clWhite);
     End;
End;


Procedure TToolbar.SetSize(NewSize:LongInt);
Begin
     If FAlignment In [tbTop,tbBottom] Then Height := NewSize
     Else Width := NewSize;
End;


Function TToolbar.GetSize:LongInt;
Begin
     If FAlignment In [tbTop,tbBottom] Then Result := Height
     Else Result := Width;
End;


Procedure TToolbar.SetAlignment(NewAlign:TToolbarAlign);
Var  Own:TForm;
     OldSize:LongInt;
     OldAlign:TToolbarAlign;
Begin
     If FAlignment = NewAlign Then Exit;

     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     OldSize := Size;
     OldAlign := FAlignment;

     {++++++++++++++++++++++}
     ListRemove(Own.FToolBarLists[FAlignment], Self);
     ListAdd(Own.FToolBarLists[NewAlign], Self);
     {Move the Toolbar To the End Of the Controls List
      To guarantee To correct SCU order}
     If ListFind(Own.FControls, Self) >= 0 Then
     Begin
          ListRemove(Own.FControls, Self);
          ListAdd(Own.FControls, Self);
     End;

     FAlignment := NewAlign;

     {Update the sizeborder}
     If SizeBorderCtrl <> Nil Then
     Case FAlignment Of
       tbLeft: SizeBorderCtrl.BorderAlign := baRight;
       tbRight: SizeBorderCtrl.BorderAlign := baLeft;
       tbTop: SizeBorderCtrl.BorderAlign := baBottom;
       tbBottom:SizeBorderCtrl.BorderAlign := baTop;
     End;

     If Handle = 0 Then Exit;

     SetWindowPos(Left,Bottom,OldSize,OldSize);
End;


Procedure TToolbar.SetOrder(Value:LongInt);
Var  Own:TForm;
     List:TList;
     AToolbar:TToolbar;
     I:LongInt;
Begin
     FOrder := Value;
     If FOrder < 0 Then Exit; {auto Append}

     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     List := Own.FToolBarLists[FAlignment];

     If ListFind(List, Self) < 0 Then Exit;  {noch nicht In der Liste}
     If List.Count = 1 Then Exit;            {nur Self In Liste}

     ListRemove(List, Self);
     If FOrder > List.Count Then FOrder := List.Count;
     ListInsert(List, FOrder, Self);

     {reorder the Own.Controls List}
     For I := 0 To List.Count-1 Do
     Begin
          AToolbar := TToolbar(List.Items[I]);
          If ListFind(Own.FControls, AToolbar) >= 0 Then
          Begin
               ListRemove(Own.FControls, AToolbar);
               ListAdd(Own.FControls, AToolbar);
          End;
     End;

     Own.AlignToolBars;
End;


Function TToolbar.GetOrder:LongInt;
Var  Own:TForm;
Begin
     Own := TForm(Owner);
     If Own Is TForm Then
     Begin
          Result := ListFind(Own.FToolBarLists[FAlignment], Self);
     End
     Else Result := -1;
End;


Procedure TToolbar.SetBevelStyle(NewStyle:TToolBarBevel);
Begin
     FBevelStyle := NewStyle;
     If Handle <> 0 Then Invalidate;
End;


Function TToolbar.GetLeft:LongInt;
Var  Own:TForm;
     List:TList;
     T:LongInt;
     Toolbar:TToolbar;
     MaxLeft,MaxRight:LongInt;
Label ex;
Begin
     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     Case Alignment Of
        tbLeft:
        Begin
             MaxLeft:=0;
             List:=Own.FToolBarLists[tbLeft];
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
             End;
             Result:=-MaxLeft;
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar=Self Then Goto ex;
                  If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
             End;
        End;
        tbRight:
        Begin
             MaxRight:=0;
             List:=Own.FToolBarLists[tbRight];
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
             End;
             Result:=Own.GetClientWidth+MaxRight;
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Dec(Result,Toolbar.Size);
                  If Toolbar=Self Then Goto ex;
             End;
        End;
        tbBottom,tbTop:
        Begin
             Result:=0;
             List:=Own.FToolBarLists[tbLeft];
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Dec(Result,Toolbar.Size);
             End;
        End;
     End;
ex:
     FLeft := Result;
End;


Function TToolbar.GetBottom:LongInt;
Var  Own:TForm;
     List:TList;
     T:LongInt;
     Toolbar:TToolbar;
Label ex;
Begin
     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     Case Alignment Of
        tbLeft,tbRight:Result:=0;
        tbBottom:
        Begin
             Result:=0;
             List:=Own.FToolBarLists[tbBottom];
             If List<>Nil Then For T:=List.Count-1 Downto 0 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Dec(Result,Toolbar.Size);
                  If Toolbar=Self Then Goto ex;;
             End;
        End;
        tbTop:
        Begin
             Result := Own.GetClientHeight;
             List:=Own.FToolBarLists[tbTop];
             If List<>Nil Then For T:=List.Count-1 Downto 0 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar=Self Then Goto ex;
                  If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
             End;
        End;
     End;
ex:
     FBottom := Result;
End;


{$HINTS OFF}
Procedure TToolbar.SetLeft(NewLeft:LongInt);
Begin
End;

Procedure TToolbar.SetBottom(NewBottom:LongInt);
Begin
End;

Procedure TToolbar.SetTop(NewTop:LongInt);
Begin
End;

Procedure TToolbar.SetRight(NewRight:LongInt);
Begin
End;

Procedure TToolbar.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Var  Own:TForm;
Begin
     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     If Alignment In [tbLeft,tbRight] Then FWidth := NewWidth
     Else FHeight := NewHeight;

     If DesignerState * [dsNoRealSizing] <> [] Then Exit;
     Own.AlignToolBars;

     Resize; {because Of no WMSize}
End;
{$HINTS ON}


Procedure TToolbar.SetSizeable(Value:Boolean);
Begin
     If Value = FSizeable Then Exit;

     FSizeable := Value;
     If FSizeable Then
     Begin
          SizeBorderCtrl.Create(Self);
          Include(SizeBorderCtrl.ComponentState,csDetail);
          SizeBorderCtrl.OnSizing := EvBorderSizing;
          SizeBorderCtrl.OnSized := EvBorderSized;
          InsertControl(SizeBorderCtrl);

          Case FAlignment Of
            tbLeft: SizeBorderCtrl.BorderAlign := baRight;
            tbRight: SizeBorderCtrl.BorderAlign := baLeft;
            tbTop: SizeBorderCtrl.BorderAlign := baBottom;
            tbBottom: SizeBorderCtrl.BorderAlign := baTop;
          End;
     End
     Else
     Begin
          SizeBorderCtrl.Destroy;
          SizeBorderCtrl := Nil;
     End;
End;


{$HINTS OFF}
Procedure TToolbar.EvBorderSizing(Sender:TObject;Var SizeDelta:LongInt);
Begin
     Case FAlignment Of
       tbLeft:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientWidth Then SizeDelta := FForm.ClientWidth;
       End;
       tbBottom:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientHeight Then SizeDelta := FForm.ClientHeight;
       End;
       tbRight:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientWidth Then SizeDelta := -FForm.ClientWidth;
       End;
       tbTop:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientHeight Then SizeDelta := -FForm.ClientHeight;
       End;
     End;
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TToolbar.EvBorderSized(Sender:TObject;Var SizeDelta:LongInt);
Begin
     Case FAlignment Of
       tbLeft:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientWidth Then SizeDelta := FForm.ClientWidth;
            Size := Size + SizeDelta;
       End;
       tbBottom:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientHeight Then SizeDelta := FForm.ClientHeight;
            Size := Size + SizeDelta;
       End;
       tbRight:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientWidth Then SizeDelta := -FForm.ClientWidth;
            Size := Size - SizeDelta;
       End;
       tbTop:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientHeight Then SizeDelta := -FForm.ClientHeight;
            Size := Size - SizeDelta;
       End;
     End;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TSizeConstraints Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSizeConstraints.SetupComponent;
Begin
     Inherited SetupComponent;

     Include(ComponentState,csDetail);
     FMaxHeight:=MaxInt;
     FMaxWidth:=MaxInt;
End;

Function TSizeConstraints.GetControl:TControl;
Begin
     Result:=TControl(Owner);
End;                  

Procedure TSizeConstraints.Change;
Begin
     If Assigned(OnChange) Then OnChange(Self);
End;

Procedure TSizeConstraints.SetMaxWidth(NewValue:LongInt);
Begin
     FMaxWidth:=NewValue;
     Change;
End;

Procedure TSizeConstraints.SetMaxHeight(NewValue:LongInt);
Begin
     FMaxHeight:=NewValue;
     Change;
End;

Procedure TSizeConstraints.SetMinWidth(NewValue:LongInt);
Begin
     FMinWidth:=NewValue;
     Change;
End;

Procedure TSizeConstraints.SetMinHeight(NewValue:LongInt);
Begin
     FMinHeight:=NewValue;
     Change;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TControl Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure SetControlHandle(Control:TControl;Handle:HWND);
Begin
     Control.FHandle:=Handle;
End;

Procedure SetDefWndProc(Control:TControl;Proc:Pointer);
Begin
     Control.FDefWndProc:=Proc;
End;

Function IsControl(Control:TControl):Boolean;
Var p:^Pointer;
    p1:^Pointer;

{$IFDEF OS2}
    RegionSize,Flags:LongWord;
{$ENDIF}

Begin
     If Control = Nil Then
     Begin
          Result:=False;
          Exit;
     End;

     //check smallest/largest possible address (64KB And 1GB)
     {$IFDEF OS2}
     If ((LongWord(Control)<$10000)Or(LongWord(Control)>$40000000)) Then
     Begin
          Result:=False;
          Exit;
     End;

     Result:=True;

     RegionSize:=4;
     Flags:=0;
     If DosQueryMem(Pointer(Control),RegionSize,Flags)<>0 Then Result:=False
     Else If (Flags And PAG_COMMIT)=0 Then Result:=False
     Else If (Flags And PAG_READ)=0 Then Result:=False
     Else
     Begin
         p1:=Pointer(Control);
         p:=p1^;
         RegionSize:=4;
         Flags:=0;
         If DosQueryMem(p,RegionSize,Flags)<>0 Then Result:=False
         Else If (Flags And PAG_COMMIT)=0 Then Result:=False
         Else If (Flags And PAG_READ)=0 Then Result:=False
         Else
         Begin
              p1 := p;
              p := p1^;
              If DosQueryMem(p,RegionSize,Flags)<>0 Then Result:=False
              Else If (Flags And PAG_EXECUTE)=0 Then Result:=False
              Else If (Flags And PAG_READ)=0 Then Result:=False
              Else If not (Control Is TControl) Then Result:=False;
         End;
     End;
     {$ENDIF}
    
     {$IFDEF WIN32}
/* NT4 SP4 hat Adressen wie $060000
     If ((LongWord(Control)<$410000)Or(LongWord(Control)>$f0000000)) Then
     Begin
          Result:=False;
          Exit;
     End;
*/
     Result:=True;

     Try
        If IsBadReadPtr(Pointer(Control),4) Then Result:=False
        Else
        Begin
            p1:=Pointer(Control);
            p:=p1^;
            If IsBadReadPtr(p,4) Then Result:=False
            Else
            Begin
                 p1 := p;
                 p := p1^;
                 If IsBadReadPtr(p,4) Then Result:=False
                 Else If IsBadCodePtr(p) Then Result:=False
                 Else If not (Control Is TControl) Then Result:=False;
            End;
        End;
     Except
        Result:=False;
     End;
     {$ENDIF}
End;

Function TControl.GetStandardFont:TFont;
Begin
  Result := Screen.DefaultFont;
  If (Designed) or
     (ComponentState * [csWriting] <> []) or
     (Application = Nil)
    Then Exit;
  IF Application.Font <> Nil
    Then Result := Application.Font;    {small}
End;

Function TControl.ContainsControl(Control: TControl):Boolean;
Begin
  While ((Control<>Nil)And(Control<>Self)) Do
    Control := Control.Parent;
  Result:=Control<>Nil;
End;

Function TControl.ControlAtPos(Const Pos:TPoint;AllowDisabled:Boolean):TControl;
Var t:LongInt;
    Control:TControl;
    p:TPoint;
Begin
    Result:=Nil;
    p:=Point(Pos.X-Left,Pos.Y-Bottom);
    For t:=0 To ControlCount-1 Do
    Begin
         Control:=Controls[t];
         If ((Pos.X>=Control.Left)And(Pos.X<=Control.Right)And
             (Pos.Y>=Control.Bottom)And(Pos.Y<=Control.Top)) Then
         Begin
              If not AllowDisabled Then If Control.Enabled=False Then Continue;
              Result:=Control;
              exit;
         End;
    End;
End;

Procedure TControl.ScrollBy(DeltaX, DeltaY:LongInt);

{$IFDEF OS2}
Var t:LongInt;
    Control:TControl;
    aswp:SWP;
{$ENDIF}

Begin
     If Handle=0 Then exit;
     {$IFDEF OS2}
     WinScrollWindow(Handle,DeltaX,DeltaY,Nil,Nil,0,Nil,SW_SCROLLCHILDREN);
     For t:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[t];
          If Control.Handle<>0 Then
          Begin
             WinQueryWindowPos(Control.Handle,aswp);
             Control.FLeft:=aswp.x;
             Control.FBottom:=aswp.y;
             Control.Move;
          End
          Else
          Begin
             inc(Control.FLeft,DeltaX);
             inc(Control.FBottom,DeltaY);
          End;
     End;
     {$ENDIF}

     Invalidate;
End;

Procedure TControl.GetTabOrderList(List:TList);
Var t:LongInt;
    Control:TControl;
Begin
     If FTabList<>Nil Then
     Begin
          For t:=0 To FTabList.Count-1 Do
          Begin
              Control:=TControl(FTabList[t]);
              List.Add(Control);
              Control.GetTabOrderList(List);
          End;
     End;
End;

Procedure TControl.ScaleBy(CX,CY:LongInt);
Var t:LongInt;
Begin
     {$IFDEF OS2}
     WinEnableWindowUpdate(Handle,False);
     {$ENDIF}
     {$IFDEF Win32}
     SendMsg(Handle,WM_SETREDRAW,0,0);
     {$ENDIF}
     For t:=0 To ControlCount-1 Do Controls[t].ScaleBy(CX,CY);

     Width:=Width+CX;
     Height:=Height+CY;

     {$IFDEF OS2}
     WinEnableWindowUpdate(Handle,True);
     {$ENDIF}
     {$IFDEF Win32}
     SendMsg(Handle,WM_SETREDRAW,1,0);
     {$ENDIF}
End;

Function TControl.GetControlState:TControlState;
Begin
     Result:=FControlState;
     If ComponentState*[csReading]<>[] Then Include(Result,csReadingState);
End;

Function TControl.GetControlStyle:TControlStyle;
Begin
     Result:=FControlStyle;
     If MouseCapture Then Include(Result,csCaptureMouse);
     If Self Is TForm Then Include(Result,csFramed);
End;

Procedure TControl.SetControlState(NewValue:TControlState);
Begin
     If NewValue*[csReadingState]<>[] Then
     Begin
          Include(ComponentState,csReading);
          Exclude(NewValue,csReadingState);
     End
     Else Exclude(ComponentState,csReading);
     FControlState:=NewValue;
End;

Procedure TControl.SetControlStyle(NewValue:TControlStyle);
Begin
     If NewValue*[csCaptureMouse]<>[] Then
     Begin
          MouseCapture:=True;
          Exclude(NewValue,csCaptureMouse);
     End
     Else MouseCapture:=False;
     Exclude(NewValue,csFramed);
     FControlStyle:=NewValue;
End;

Procedure TControl.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FPopupMenu Then FPopupMenu := Nil;
End;


Procedure TControl.MapPoints(Target:TControl;Var pts:Array Of TPoint);
Begin
     If ((target=Nil)Or(target.Handle=0)) Then Exit;

     {$IFDEF OS2}
     WinMapWindowPoints(Handle,target.Handle,pts[0],High(pts)+1);
     {$ENDIF}
     {$IFDEF Win32}
     pts[0].Y := {Screen.}Height - pts[0].Y; {Martin0308}
     MapWindowPoints(HWND_DESKTOP,target.Handle,pts[0],High(pts)+1);
     pts[0].Y := Target.ClientHeight - pts[0].Y; {Martin0308}
     {$ENDIF}
End;

Procedure TControl.WMMeasureItem(Var Msg:TMessage);
Var
     Control:TControl;
     {$IFDEF OS2}
     Win:HWND;
     {$ENDIF}
     {$IFDEF Win32}
     MeasureItem:^MEASUREITEMSTRUCT;

     Function GetControlFromId(AParent:TControl;Id:LongWord):TControl;
     Var  I:LongInt;
     Begin
          If AParent <> Nil Then
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Result := AParent.Controls[I];
                 If Result.FWindowId = Id Then Exit;
                 Result := GetControlFromId(Result,Id);
                 If Result <> Nil Then Exit;
            End;
          Result := Nil;
     End;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.Param1Lo);
     If Win = 0 Then Exit;
     Control := HandleToControl(Win);
     {$ENDIF}
     {$IFDEF Win32}
     MeasureItem := Pointer(Msg.Param2);
     If MeasureItem = Nil Then Exit;
     {Win:=GetDlgItem(Handle,MeasureItem^.CtlId);
     If Win=0 Then Exit;
     Control:=HandleToControl(Win);}
     {GWL_USERDATA Is Not Set here - Search In Component List}
     Control := GetControlFromId(Self, MeasureItem^.CtlId);
     If Control = Nil Then {define Some defaults}
     Begin
          MeasureItem^.ItemHeight := 32;
          Msg.Handled := True;
          Msg.Result := 1;
          Exit;
     End;
     {$ENDIF}

     If not IsControl(Control) Then Control:=Nil;
     If Control <> Nil Then Control.ParentNotification(Msg);
End;


Procedure TControl.WMDrawItem(Var Msg:TMessage);
Var  Win:HWND;
     Control:TControl;
     {$IFDEF Win32}
     ItemStruct:^DRAWITEMSTRUCT;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.Param1Lo);
     {$ENDIF}
     {$IFDEF Win32}
     ItemStruct := Pointer(Msg.Param2);
     If ItemStruct = Nil Then Exit;
     Win := ItemStruct^.hwndItem;
     {$ENDIF}
     If Win = 0 Then Exit;
     Control := HandleToControl(Win);

     If not IsControl(Control) Then Control:=Nil;
     If Control <> Nil Then Control.ParentNotification(Msg);
End;


Procedure TControl.ParentNotification(Var Msg:TMessage);
Begin
     DefaultHandler(Msg);
End;

Procedure TControl.SetupComponent;
Begin
     Inherited SetupComponent;

     If Designed Then Exclude(ComponentState, csReference);
     FParent:=Nil;
     FFrame:=Nil;
     FCtl3d:=True;
     FControlState:=[];
     FControlStyle:=[];
     FCaption:=Nil;
     FCursor:=crDefault;
     FOwnerDraw:=True;
     FHandlesDesignMouse:=False;
     FHandlesDesignKey:=False;
     PenColor:=clWindowText;
     color:=clWindow;
     FEnabled:=True;
     FVisible:=True;
     {$IFDEF Win32}
     FClickTime:=GetDoubleClickTime Div 2;
     {$ENDIF}
     FXAlign:=xaNone;
     FYAlign:=yaNone;
     FXStretch:=xsNone;
     FYStretch:=ysNone;
     FReplaceMnemoEnabled:=True;
     FFontChangeEnabled:=True;
     FFont:=StandardFont;
     FHint:=Nil;
     FShowHint:=False;
     FParentShowHint:=True;
     FParentFont:=True;
     FParentPenColor:=False;
     FParentColor:=False;
     FCursorTabStop:=True;
     FTabStop:=True;
     FTabOrder:=-1;
     FZOrder:=zoTop;
     FDragMode:=dmManual;
     FDragCursor:=crDrag;
     FDragState:=dsDragEnter;
     FUpdateEnabled:=True;
     if Application=nil
       then SaveLoadInfo:=false
       else SaveLoadInfo:=Application.FormInfoINI <> fiNone; // Komponenteninformationen in der INI speichern.
     Include(ComponentState, csHandleLinks);
     FConstraints:=TSizeConstraints.Create(Self);
End;


Function TControl.GetAlign:TAlign;
Begin
     If FFrame = Nil Then
     Begin
          If (FXAlign=xaLeft) And (FYAlign=yaTop) And
             (FXStretch=xsParent) And (FYStretch=ysNone) Then Result := alTop
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsParent) And (FYStretch=ysNone) Then Result := alBottom
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysParent) Then Result := alLeft
          Else
          If (FXAlign=xaRight) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysParent) Then Result := alRight
          Else
          If (FXAlign=xaParent) And (FYAlign=yaParent) And
             (FXStretch=xsParent) And (FYStretch=ysParent) Then Result := alClient
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsFrame) And (FYStretch=ysFrame) Then Result := alFrame
          Else
          If (FXAlign=xaNone) And (FYAlign=yaNone) And
             (FXStretch=xsScale) And (FYStretch=ysScale) Then Result := alScale
          Else
          If (FXAlign=xaCenter) And (FYAlign=yaCenter) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alCenter
          Else
          If (FXAlign=xaCenter) And (FYAlign=yaNone) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alCenterX
          Else
          If (FXAlign=xaNone) And (FYAlign=yaCenter) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alCenterY
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaTop) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedLeftTop
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedLeftBottom
          Else
          If (FXAlign=xaRight) And (FYAlign=yaTop) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedRightTop
          Else
          If (FXAlign=xaRight) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedRightBottom
          Else Result := alNone;
     End
     Else Result := FFrame.GetAlign;
End;


Function TControl.GetXAlign:TXAlign;
Begin
     If FFrame = Nil Then Result := FXAlign
     Else Result := FFrame.FXAlign;
End;


Function TControl.GetYAlign:TYAlign;
Begin
     If FFrame = Nil Then Result := FYAlign
     Else Result := FFrame.FYAlign;
End;


Function TControl.GetXStretch:TXStretch;
Begin
     If FFrame = Nil Then Result := FXStretch
     Else Result := FFrame.FXStretch;
End;


Function TControl.GetYStretch:TYStretch;
Begin
     If FFrame = Nil Then Result := FYStretch
     Else Result := FFrame.FYStretch;
End;


Procedure TControl.SetAlign(NewAlign:TAlign);
Var  cw,CH:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          Case NewAlign Of
            alNone:
            Begin
                 FXAlign := xaNone;
                 FYAlign := yaNone;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alLeft:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysParent;
                 FLeft := 0;
                 FBottom := 0;
            End;
            alRight:
            Begin
                 FXAlign := xaRight;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysParent;
                 FBottom := 0;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 FAutoFrame^.Right := 0;
            End;
            alBottom:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsParent;
                 FYStretch := ysNone;
                 FLeft := 0;
                 FBottom := 0;
            End;
            alTop:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaTop;
                 FXStretch := xsParent;
                 FYStretch := ysNone;
                 FLeft := 0;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 FAutoFrame^.Top := 0;
            End;
            alCenter:
            Begin
                 FXAlign := xaCenter;
                 FYAlign := yaCenter;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alCenterX:
            Begin
                 FXAlign := xaCenter;
                 FYAlign := yaNone;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alCenterY:
            Begin
                 FXAlign := xaNone;
                 FYAlign := yaCenter;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alFixedLeftTop:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaTop;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If Parent = Nil Then CH:=Screen.Height
                 Else CH := GetParentClientHeight;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
            End;
            alFixedLeftBottom:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alFixedRightTop:
            Begin
                 FXAlign := xaRight;
                 FYAlign := yaTop;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If Parent = Nil Then CH:=Screen.Height
                 Else CH := GetParentClientHeight;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
                 If Parent = Nil Then cw:=Screen.Width
                 Else cw := GetParentClientWidth;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
            End;
            alFixedRightBottom:
            Begin
                 FXAlign := xaRight;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If Parent = Nil Then cw:=Screen.Width
                 Else cw := GetParentClientWidth;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
            End;
            alClient:
            Begin
                 FXAlign := xaParent;
                 FYAlign := yaParent;
                 FXStretch := xsParent;
                 FYStretch := ysParent;
            End;
            alFrame: {Parent necessary}
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsFrame;
                 FYStretch := ysFrame;
                 If Parent = Nil Then Exit;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 cw := GetParentClientWidth;
                 CH := GetParentClientHeight;
                 If cw <> 0 Then FAutoFrame^.Left := FLeft
                 Else FAutoFrame^.Left := 0;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
                 If CH <> 0 Then FAutoFrame^.Bottom := FBottom
                 Else FAutoFrame^.Bottom := 0;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
            End;
            alScale: {Parent necessary}
            Begin
                 FXAlign := xaNone;
                 FYAlign := yaNone;
                 FXStretch := xsScale;
                 FYStretch := ysScale;
                 If Parent = Nil Then Exit;
                 If FAutoScale = Nil Then New(FAutoScale);
                 cw := GetParentClientWidth;
                 CH := GetParentClientHeight;
                 If cw <> 0 Then FAutoScale^.Left := FLeft / cw
                 Else FAutoScale^.Left := 0;
                 If cw <> 0 Then FAutoScale^.Right := (FLeft+FWidth) / cw
                 Else FAutoScale^.Right := 1;
                 If CH <> 0 Then FAutoScale^.Bottom := FBottom / CH
                 Else FAutoScale^.Bottom := 0;
                 If CH <> 0 Then FAutoScale^.Top := (FBottom+FHeight) / CH
                 Else FAutoScale^.Top := 1;
            End;
          End;
          If Handle <> 0 Then SetWindowPos(Left,Bottom,Width,Height);
     End
     Else FFrame.SetAlign(NewAlign);
End;


Procedure TControl.SetXAlign(NewAlign:TXAlign);
Var  cw:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FXAlign := NewAlign;
          If FXAlign=xaRight Then
          Begin
               If Parent = Nil Then
               Begin
                    If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                       Then cw := Screen.Width
                    Else Exit;
               End
               Else cw := GetParentClientWidth;

               If FAutoFrame = Nil Then New(FAutoFrame);
               If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
               Else FAutoFrame^.Right := 0;
          End;
          If Handle <> 0 Then Left := Left;
     End
     Else FFrame.SetXAlign(NewAlign);
End;


Procedure TControl.SetYAlign(NewAlign:TYAlign);
Var  CH:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FYAlign := NewAlign;
          If FYAlign=yaTop Then
          Begin
               If Parent = Nil Then
               Begin
                    If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                      Then CH := Screen.Height
                    Else Exit;
               End
               Else CH := GetParentClientHeight;

               If FAutoFrame = Nil Then New(FAutoFrame);
               If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
               Else FAutoFrame^.Top := 0;
          End;
          If Handle <> 0 Then Bottom := Bottom;
     End
     Else FFrame.SetYAlign(NewAlign);
End;


Procedure TControl.SetXStretch(NewStretch:TXStretch);
Var  cw:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FXStretch := NewStretch;
          Case FXStretch Of
            xsFrame:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then cw := Screen.Width
                      Else Exit;
                 End
                 Else cw := GetParentClientWidth;

                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If cw <> 0 Then FAutoFrame^.Left := FLeft
                 Else FAutoFrame^.Left := 0;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
            End;
            xsScale:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then cw := Screen.Width
                      Else Exit;
                 End
                 Else cw := GetParentClientWidth;

                 If FAutoScale = Nil Then New(FAutoScale);
                 If cw <> 0 Then FAutoScale^.Left := FLeft / cw
                 Else FAutoScale^.Left := 0;
                 If cw <> 0 Then FAutoScale^.Right := (FLeft+FWidth) / cw
                 Else FAutoScale^.Right := 1;
            End;
          End;
          If Handle <> 0 Then Width := Width;
     End
     Else FFrame.SetXStretch(NewStretch);
End;


Procedure TControl.SetYStretch(NewStretch:TYStretch);
Var  CH:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FYStretch := NewStretch;
          Case FYStretch Of
            ysFrame:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then CH := Screen.Height
                      Else Exit;
                 End
                 Else CH := GetParentClientHeight;

                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If CH <> 0 Then FAutoFrame^.Bottom := FBottom
                 Else FAutoFrame^.Bottom := 0;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
            End;
            ysScale:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then CH := Screen.Height
                      Else Exit;
                 End
                 Else CH := GetParentClientHeight;

                 If FAutoScale = Nil Then New(FAutoScale);
                 If CH <> 0 Then FAutoScale^.Bottom := FBottom / CH
                 Else FAutoScale^.Bottom := 0;
                 If CH <> 0 Then FAutoScale^.Top := (FBottom+FHeight) / CH
                 Else FAutoScale^.Top := 1;
            End;
          End;
          If Handle <> 0 Then Height := Height;
     End
     Else FFrame.SetYStretch(NewStretch);
End;


Function TControl.GetControlCount:LongInt;
Begin
     If FControls = Nil Then Result := 0
     Else Result := FControls.Count;
End;


Function TControl.GetControl(AIndex:LongInt):TControl;
Begin
     If (FControls = Nil) Or (AIndex < 0) Or (AIndex >= FControls.Count)
     Then Result := Nil
     Else Result := FControls.Items[AIndex];
End;


Procedure TControl.SetPenColor(NewColor:TColor);
Begin
     FPenColor := NewColor;
     If ComponentState * [csReading] = [] Then FParentPenColor := False;
     {$IFDEF OS2}
     If Handle <> 0 Then SetPPForeGroundColor(NewColor);
     {$ENDIF}
     If Handle <> 0 Then Invalidate;
     NotifyControls(CM_PARENTPENCOLORCHANGED);
End;


Procedure TControl.SetColor(NewColor:TColor);
Begin
     FColor := NewColor;
     If ComponentState * [csReading] = [] Then FParentColor := False;
     {$IFDEF OS2}
     If Handle <> 0 Then SetPPBackGroundColor(NewColor);
     {$ENDIF}
     {$IFDEF Win32}     
     If FCtlBrush <> 0 Then DeleteObject(FCtlBrush);

     If Not FOwnerDraw Then
     Begin
          NewColor := RGBToWinColor(SysColorToRGB(NewColor));
          FCtlBrush := CreateSolidBrush(NewColor);
     End
     Else FCtlBrush := 0;
     {$ENDIF}
     If Handle <> 0 Then Invalidate;
     NotifyControls(CM_PARENTCOLORCHANGED);
End;

//Procedure TControl.SetSaveLoadInfo(NewValue : Boolean);
//
//var Cou : LongInt;
//
//Begin
//  fSaveLoadInfo:=NewValue;
//  For cou:=0 to ControlCount-1 do
//    Controls[Cou].SaveLoadInfo:=NewValue;
//End;


{$HINTS OFF}
Procedure TControl.ParentFontChanged(Var Msg:TMessage);
Begin
     If FParentFont Then
       If FParent <> Nil Then
       Begin
            SetFont(FParent.FFont);
            FParentFont := True;
       End;
End;


Procedure TControl.ParentPenColorChanged(Var Msg:TMessage);
Begin
     If FParentPenColor Then
       If FParent <> Nil Then
       Begin
            SetPenColor(FParent.FPenColor);
            FParentPenColor := True;
       End;
End;


Procedure TControl.ParentColorChanged(Var Msg:TMessage);
Begin
     If FParentColor Then
       If FParent <> Nil Then
       Begin
            SetColor(FParent.FColor);
            FParentColor := True;
       End;
End;
{$HINTS ON}


Procedure TControl.SetParentFont(Value:Boolean);
Begin
     If FParentFont <> Value Then
     Begin
          If Value Then
            If FParent <> Nil Then Font := FParent.FFont;
          FParentFont := Value;
     End;
End;


Procedure TControl.SetParentPenColor(Value:Boolean);
Begin
     If FParentPenColor <> Value Then
     Begin
          If Value Then
            If FParent <> Nil Then PenColor := FParent.FPenColor;
          FParentPenColor := Value;
     End;
End;


Procedure TControl.SetParentColor(Value:Boolean);
Begin
     If FParentColor <> Value Then
     Begin
          If Value Then
            If FParent <> Nil Then color := FParent.FColor;
          FParentColor := Value;
     End;
End;

Function ConvertSystemMnemo(Const MnemoString:String):String;
{ WD: Konvertiert das Zeichen "~" in "&" und umgekehrt kommt auf das
      Betriebsystem an }

Begin
     Result := MnemoString;

     If Pos(StandardMnemoChar,Result) > 0 Then 
       Result[Pos(StandardMnemoChar,Result)] := SystemMnemoChar;
End;


Function ConvertSCUMNemo(Const SCUString : String):String;
{ WD: Konvertiert das Zeichen "~" oder "&" in das Betriebsystem-Kurzmenue-Zeichen }

Var OS2Pos : Byte;
    WinPos : Byte;

Begin
     Result := SCUString;

     OS2Pos:=Pos(OS2MnemoChar,Result);
     WinPos:=Pos(WinMnemoChar,Result);
     if (OS2Pos=0) and (WinPos=0) then Exit;  { Kein "~" oder "&" gefunden }

     {$IFDEF OS2}
     if OS2Pos<WinPos
       then Result[WinPos]:=OS2MNemoChar
       else Result[OS2Pos]:=OS2MNemoChar
     {$ENDIF}
     {$IFDEF Win32}
     if OS2Pos<WinPos
       then Result[WinPos]:=WinMNemoChar
       else Result[OS2Pos]:=WinMNemoChar
     {$ENDIF}
End;



Procedure TControl.SetText(Const NewCaption:String);
Var  CS:Cstring;
Begin
     AssignStr(FCaption, NewCaption);

     If FFrame = Nil Then
     Begin
          If (Handle <> 0) And
             (FStandardControl Or (Self Is TFrameControl)) Then
          Begin
               {$IFDEF OS2}
               If (NewCaption = '') And (Self Is TFrameControl) Then CS := ' '
               Else If not FReplaceMnemoEnabled Then CS := NewCaption
                    Else CS := ConvertSystemMnemo(NewCaption);
               WinSetWindowText(Handle,CS);
               {$ENDIF}
               {$IFDEF Win32}
               If FOwnerDraw Then CS := NewCaption
               Else If not FReplaceMnemoEnabled Then CS := NewCaption
                    Else CS := ConvertSystemMnemo(NewCaption);
               if ConvertGetText{Martin} then OemToAnsi(CS,CS);
               SetWindowText(Handle,CS);
               {$ENDIF}
          End;
          Perform(CM_TEXTCHANGED,0,0);
     End
     Else FFrame.SetText(NewCaption);
End;


Function TControl.GetText:String;
Begin
     If FFrame = Nil Then
     Begin
          If FCaption = Nil Then Result := ''
          Else Result := FCaption^;
     End
     Else Result := FFrame.GetText;
End;


Procedure TControl.SetZOrder(zo:TZOrder);
Begin
     If zo <> FZOrder Then
     Begin
          FZOrder := zo;
          If FZOrder <> zoNone Then
            If Handle <> 0 Then UpdateWindowPos(FLeft,FBottom,FWidth,FHeight);
     End;
End;


Procedure TControl.GetClassData(Var ClassData:TClassData);
Begin
     ClassData.StandardClass:=False;
     ClassData.ClassName:=WDSibylPasWndTxt;
     ClassData.WindowProc:=@StartWndProc;
     {!!!!!!!!!!!!!!!!!!!!!!!!!!}
     ClassData.ClassStyle:=[wcsSizeRedraw,{wcsClipChildren,}
                            wcsClipSiblings,wcsOwnDC{,wcsSaveBits}];
     ClassData.DataCount:=4;
     ClassData.ClassULong:=0;
End;


{$IFDEF Win32}
Procedure TControl.CreateSubClass(Var ClassData:TClassData;
                                  Const ControlClassName:Cstring);
Var  WindowClass:WNDCLASS;
Begin
  ClassData.ClassName := ControlClassName;
  ClassData.ClassStyle := ClassData.ClassStyle + [wcsSizeRedraw]
                          - [wcsOwnDC];
  ClassData.StandardClass := True;
  If @FDefWndProc = Nil Then
  Begin
    If Not WinUser.GetClassInfo(DllModule, ControlClassName, WindowClass)
      Then WinUser.GetClassInfo(0, ControlClassName, WindowClass);

    FDefWndProc := @WindowClass.lpfnWndProc; {Get original WindowProc}
  End;
End;
{$ENDIF}


Procedure TControl.RegisterClass;
Var  ClassData:TClassData;
     ClassStyle:LongWord;
     {$IFDEF OS2}
     aClass:PmWin.ClassInfo;
     {$ENDIF}
     {$IFDEF Win32}
     aClass:WNDCLASS;
     {$ENDIF}
Begin
     GetClassData(ClassData);
     {$IFDEF OS2}
     FStandardControl := ClassData.ClassULong <> 0;
     {$ENDIF}
     {$IFDEF Win32}
     FStandardControl := ClassData.StandardClass;  {Set In CreateSubClass}
     {$ENDIF}

     {$IFDEF OS2}
     If Not WinQueryClassInfo(AppHandle,ClassData.ClassName,aClass) Then
     Begin
          ClassStyle:=0;
          If ClassData.ClassStyle*[wcsSizeRedraw]<>[]
            Then ClassStyle:=ClassStyle Or CS_SIZEREDRAW;
          If ClassData.ClassStyle*[wcsHitTest]<>[]
            Then ClassStyle:=ClassStyle Or CS_HITTEST;
          If ClassData.ClassStyle*[wcsFrame]<>[]
            Then ClassStyle:=ClassStyle Or CS_FRAME;
          If ClassData.ClassStyle*[wcsClipChildren]<>[] Then
            If Not Designed Then ClassStyle:=ClassStyle Or CS_CLIPCHILDREN;
          If ClassData.ClassStyle*[wcsClipSiblings]<>[]
            Then ClassStyle:=ClassStyle Or CS_CLIPSIBLINGS;
          If ClassData.ClassStyle*[wcsParentClip]<>[]
            Then ClassStyle:=ClassStyle Or CS_PARENTCLIP;
          If ClassData.ClassStyle*[wcsSaveBits]<>[]
            Then ClassStyle:=ClassStyle Or CS_SAVEBITS;
          If ClassData.ClassStyle*[wcsSyncPaint]<>[]
            Then ClassStyle:=ClassStyle Or CS_SYNCPAINT;
          ClassStyle:=ClassStyle Or CS_MOVENOTIFY;

          WinRegisterClass(AppHandle,
                           ClassData.ClassName,
                           ClassData.WindowProc,
                           ClassStyle,
                           ClassData.DataCount);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If Not ClassData.StandardClass Then
       If Not WinUser.GetClassInfo(DllModule,ClassData.ClassName,aClass) Then
     Begin
          ClassStyle:=CS_DBLCLKS;
          If ClassData.ClassStyle*[wcsSizeRedraw]<>[]
            Then ClassStyle:=ClassStyle Or CS_HREDRAW Or CS_VREDRAW;
          If ClassData.ClassStyle*[wcsSaveBits]<>[]
            Then ClassStyle:=ClassStyle Or CS_SAVEBITS;
          If ClassData.ClassStyle*[wcsOwnDC]<>[]
            Then ClassStyle:=ClassStyle Or CS_OWNDC;
          //others ignored

          aClass.Style         := ClassStyle;
          aClass.lpfnWndProc   := ClassData.WindowProc;
          aClass.cbClsExtra    := ClassData.DataCount;
          aClass.cbWndExtra    := 0;
          aClass.hInstance     := DllModule;
          aClass.hIcon         := 0;
          aClass.HCursor       := LoadCursor(0,IDC_ARROW);
          aClass.hbrBackground := 0;
          aClass.lpszMenuName  := Nil;
          aClass.lpszClassName := @ClassData.ClassName;

          WinUser.RegisterClass(aClass);
     End;
     {$ENDIF}
End;


Procedure TControl.UpdateFont;
{$IFDEF OS2}
var  S:String;
     C:Cstring;
{$ENDIF}
{$IFDEF Win32}
var  aFontInfo:LOGFONT;
     aFontAttr:TFontAttributes;
{$ENDIF}
Begin
     If FFont = Nil Then Exit;
     {$IFDEF OS2}
     If TControlFont(FFont).InternalPointSize<>0 Then
     Begin
          S:=tostr(TControlFont(FFont).InternalPointSize)+'.';
          C:=FFont.FaceName;
     End
     Else
     Begin
          S:=tostr((TControlFont(FFont).FontInfo.sNominalPointSize) Div 10)+'.';
          C:=TControlFont(FFont).FontInfo.szFaceName;
     End;

     S:=S+C;
     S:=ModifyFontName(S,FFont.Attributes);
     SetPPFontNameSize(S);
     {$ENDIF}

     {$IFDEF Win32}
     If TControlFont(FFont).Handle<>0 Then
     Begin
          If FDefFontHandle<>TControlFont(FFont).Handle Then
          Begin
               FDefFontHandle:=TControlFont(FFont).Handle;
               TControlFont(FFont).RefCount:=TControlFont(FFont).RefCount+1;
          End;
     End
     Else
     Begin
          aFontInfo:=TControlFont(FFont).FontInfo;
          aFontInfo.lfQuality:=DRAFT_QUALITY;
          aFontAttr:=FFont.Attributes;
          If aFontAttr*[faItalic]<>[] Then aFontInfo.lfItalic:=1
          Else aFontInfo.lfItalic:=0;
          If aFontAttr*[faUnderScore]<>[] Then aFontInfo.lfUnderline:=1
          Else aFontInfo.lfUnderline:=0;
          If aFontAttr*[faStrikeOut]<>[] Then aFontInfo.lfStrikeOut:=1
          Else aFontInfo.lfStrikeOut:=0;
          If aFontAttr*[faBold]<>[] Then aFontInfo.lfWeight:=FW_BOLD
          Else aFontInfo.lfWeight:=FW_NORMAL;
          FDefFontHandle:=CreateFontIndirect(aFontInfo);
          TControlFont(FFont).Handle:=FDefFontHandle;
          TControlFont(FFont).RefCount:=1;
     End;
     SendMsg(Handle,WM_SETFONT,FDefFontHandle,1);
     If FFontChangeEnabled Then FontChange;
     {$ENDIF}
End;


Procedure TControl.SetFont(NewFont:TFont);
Begin
     If (NewFont = FFont) and (NewFont.OS2Codepage = 0){Martin0206}
       Then Exit;
     If NewFont=Nil Then NewFont:=StandardFont;
     If ComponentState * [csReading] = [] Then FParentFont := False;

     If FFont<>NewFont Then
     Begin
          DereferenceFont(FFont,True);
          FFont:=NewFont;
          ReferenceFont(FFont);
     End;

     If Handle <> 0 Then
     Begin
          If FCanvas <> Nil Then
          Begin
               //FCanvas.Font := NewFont; //MIST da dies den ControlFont nicht ndert !!
               CreateControlFont(FCanvas,NewFont);
          End
          Else UpdateFont;
     End;

//     If FFrame <> Nil Then FFrame.Font := NewFont;
     NotifyControls(CM_PARENTFONTCHANGED);
End;


Function TControl.GetWindowFlags:LongWord;
Begin
     Result := WS_CLIPSIBLINGS;     {Win: + WS_CHILD .?.}

     If Not Designed Then
       If Not FEnabled Then Result := Result Or WS_DISABLED;

     If ComponentState * [csAcceptsControls] <> []
     Then Result := Result Or WS_CLIPCHILDREN;

     If Designed Then Result := Result And Not WS_CLIPCHILDREN;
End;


Procedure TControl.CreateParams(Var Params:TCreateParams);
Begin
     FillChar(Params, SizeOf(Params), 0);
     Params.Style := GetWindowFlags;
End;

Procedure TControl.RefreshLanguage;

Var LngEntry: String;
    cCaption: cString;

Begin
  LngEntry:=LngClassEntry+uppercase(UniqueName)+'_';
  Application.LogWriteln('RefreshLanguage.LngEntry: '+LngEntry);
  SetText(Application.LanguageFile.GetText(LngEntry+'CAPTION',getText));
  SetHint(Application.LanguageFile.GetText(LngEntry+'HINT',getHint));
End;

Function TControl.CreateCanvas:TCanvas;
Begin
     If FCanvas = Nil Then
     Begin
          FCanvas.Create(Self);
          FInitCanvas := True;
     End;
     If (Handle <> 0) And FInitCanvas Then
     Begin
          FCanvas.Init;
          FInitCanvas := False; {Init only 1 Time}
     End;
     Result := FCanvas;
End;


Procedure TControl.CreateWnd;
Var  OwnerHandle:LongWord;
     ParentHandle:LongWord;
     Params:TCreateParams;
     WindowFlags:LongWord;
     ClassData:TClassData;
     cCaption:CString;
     sCaption:String;
     aLeft,aBottom,aWidth,aHeight:LongInt;
     {$IFDEF Win32}
     ExtendedFlags:LongWord;
     OldWndProc:Pointer;
     rc,rc1:TRect;
     {$ENDIF}

Begin
     If Handle <> 0 Then Exit;

     FForm := GetParentForm(Self);
     If FForm <> Nil Then FForm.CreateUniqueWindowId(Self);

     FFirstShow := True;

     RegisterClass;
     GetClassData(ClassData);

     If FCaption = Nil Then sCaption := ' '
     Else sCaption := FCaption^;

     aLeft := FLeft;
     aBottom := FBottom;
     aWidth := FWidth;
     aHeight := FHeight;

     If Self Is TForm Then  {Create Frame Class}
     Begin
          If FFrame = Nil Then FFrame := TFrameControl.Create(Nil);
          If FCaption <> Nil Then FFrame.Caption := sCaption;     {!}
          FFrame.FParent:=FParent;
          FFrame.FModalParent:=FModalParent;
          FFrame.FForm:=TForm(Self);
          FFrame.FZOrder:=FZOrder;
          {FFrame.FFont:=FFont; wegen DBCSStatusLine}
          FFrame.SetDesigning(Designed);
          FFrame.FVisible:=FVisible;
          FFrame.FEnabled:=FEnabled;
          FFrame.FXAlign:=FXAlign;
          FFrame.FYAlign:=FYAlign;
          FFrame.FXStretch:=FXStretch;
          FFrame.FYStretch:=FYStretch;
          FFrame.SetWindowPos(aLeft,aBottom,aWidth,aHeight);
          FYAlign:=yaNone;
          FXAlign:=xaNone;
          FXStretch:=xsNone;
          FYStretch:=ysNone;
          TFrameControl(FFrame).FChild:=TForm(Self);
          FFrame.CreateWnd;

          FWindowId:=widClient; {!!!}

          {$IFDEF OS2}
          {shrink Size Of client because Of Frame}
          Dec(aWidth,TForm(Self).GetAddWidth);
          Dec(aHeight,TForm(Self).GetAddHeight);
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.GetClientRect(FFrame.Handle,RECTL(rc1));
          rc:=FFrame.GetClientRect;
          aWidth:=rc.Right-rc.Left+1;
          aHeight:=rc.Top-rc.Bottom+1;
          aLeft:=rc.Left;
          aBottom:=((rc1.Top-rc1.Bottom)-aHeight)-rc.Bottom;
          {$ENDIF}

          ParentHandle:=FFrame.Handle;
          OwnerHandle :=FFrame.Handle;
     End
     Else
     Begin
          If Parent<>Nil Then ParentHandle:=Parent.Handle
          Else ParentHandle:=HWND_DESKTOP;
          If FModalParent<>Nil Then OwnerHandle:=FModalParent.Handle
          Else OwnerHandle:=ParentHandle;

          {$IFDEF Win32}
          If Parent<>Nil
            Then aBottom:=Parent.FHeight-aBottom-aHeight
            Else aBottom:=Screen.Height-aBottom-aHeight;
          {$ENDIF}
     End;

     CreateParams(Params);

     WindowFlags := Params.Style;

     {$IFDEF OS2}
     {probably STD Control - replace Mnemo Char}
     If Not FOwnerDraw Then cCaption := ConvertSystemMnemo(sCaption)
     Else cCaption := sCaption;

     If ClassData.ClassULong<>0
     Then FHandle:=WinCreateWCWindow(ParentHandle,
                                     ClassData.ClassULong,
                                     cCaption,       //Caption
                                     WindowFlags,    //flStyle
                                     aLeft,aBottom,
                                     aWidth,aHeight, //Position And Size
                                     OwnerHandle,    //Owner
                                     HWND_TOP,       //Insert behind
                                     FWindowId,
                                     Nil,            //CtlData
                                     Nil)            //Presparams
     Else FHandle:=WinCreateWindow(ParentHandle,     //Parent
                                   ClassData.ClassName,
                                   cCaption,       //Caption
                                   WindowFlags,    //flStyle
                                   aLeft,aBottom,
                                   aWidth,aHeight, //Position And Size
                                   OwnerHandle,    //Owner
                                   HWND_TOP,       //Insert behind
                                   FWindowId,
                                   Nil,            //CtlData
                                   Nil);           //Presparams
     {$ENDIF}

     {$IFDEF Win32}
     If ParentHandle <> HWND_DESKTOP Then WindowFlags := WindowFlags Or WS_CHILD;

     ExtendedFlags := Params.ExStyle;

     {probably STD Control - replace Mnemo Char}
     StrOemToAnsi(sCaption);
     If Not FOwnerDraw Then cCaption := ConvertSystemMnemo(sCaption)
     Else cCaption := sCaption;

     If ExtendedFlags=0
     Then FHandle:=CreateWindow(ClassData.ClassName,
                                cCaption,
                                WindowFlags,
                                aLeft,aBottom,
                                aWidth,aHeight,
                                ParentHandle,
                                FWindowId,
                                DllModule,
                                Nil)
     Else FHandle:=CreateWindowEx(ExtendedFlags,
                                  ClassData.ClassName,
                                  cCaption,
                                  WindowFlags,
                                  aLeft,aBottom,
                                  aWidth,aHeight,
                                  ParentHandle,
                                  FWindowId,
                                  DllModule,
                                  Nil);

     If ParentHandle = HWND_DESKTOP Then
     Begin
          // remove titlebar
          ExtendedFlags := GetWindowLong(FHandle,GWL_STYLE);
          ExtendedFlags := ExtendedFlags And Not WS_CAPTION;
          SetWindowLong(FHandle,GWL_STYLE, ExtendedFlags);

          ExtendedFlags := GetWindowLong(FHandle,GWL_EXSTYLE);
          ExtendedFlags := ExtendedFlags Or WS_EX_TOPMOST;
          SetWindowLong(FHandle,GWL_EXSTYLE, ExtendedFlags);
          WinUser.SetWindowPos(FHandle,0,0,0,0,0,
             SWP_NOSIZE+SWP_NOMOVE+SWP_NOACTIVATE+SWP_NOZORDER+SWP_FRAMECHANGED);
     End;
     {$ENDIF}

     If FHandle = 0 Then CreateError;

     If FFont = Nil Then FFont := StandardFont;

     If FOwnerDraw Or FInitCanvas Then FCanvas := CreateCanvas;
     UpdateFont; //!! wird In Canvas.SetFont nicht mehr verndert !!

     {$IFDEF Win32}
     If Not FOwnerDraw Then
     Begin
          If FCtlBrush <> 0 Then DeleteObject(FCtlBrush);
          FCtlBrush:=CreateSolidBrush(RGBToWinColor(SysColorToRGB(color)));
     End;
     {$ENDIF}

     {$IFDEF OS2}
     WinSetWindowULong(Handle,QWL_USER,LongWord(Self));    {VMT Pointer}
     FDefWndProc:=Pointer(WinSubClassWindow(Handle,@SubclassedWndProc));
     {$ENDIF}
     {$IFDEF Win32}
     SetWindowLong(Handle,GWL_USERDATA,LongWord(Self));    {VMT Pointer}
     OldWndProc:=Pointer(SetWindowLong(Handle,GWL_WNDPROC,Longword(@SubclassedWndProc)));
     If @FDefWndProc = Nil Then FDefWndProc := OldWndProc;   {WinNT !!!}
     {$ENDIF}
     CreateControls;
     FInitControls:=False;

     If (Not FEnabled) And (Not Designed) Then Disable;
     If (Not FVisible) And (Not Designed) Then Hide;

     {$IFDEF Win32}
     rc:=GetWindowRect;
     FLeft:=rc.Left;
     FBottom:=rc.Bottom;
     FWidth:=rc.Right-rc.Left+1;
     FHeight:=rc.Top-rc.Bottom+1;
     {$ENDIF}

// Call SetupShow
     SetupShow;
     If OnSetupShow<>Nil Then OnSetupShow(Self);

// Language Support
     if (designed=false) and (fForm<>nil) and (fForm.LanguageSupport) then
       RefreshLanguage;
End;


Procedure TControl.CreateError;
Begin
  ErrorBox2(LoadNLSStr(SCouldNotCreateWindow)+'. '+LoadNLSStr(SProgramAborted)+'.');
  Halt(253);
End;


Procedure TControl.CreateControls;
Var  T:LongInt;
     Control:TControl;
Begin
  If Not FInitControls Then Exit;
  For T := 0 To ControlCount-1 Do
    Begin
      Control := Controls[T];
      If Control.ComponentState * [csReference] = [] Then
        Begin
          Control.CreateWnd;
          {$IFDEF Win32}
          If Control.FVisible Or Control.Designed Then Control.Show;
          {$ENDIF}
        End;
    End;
End;


Procedure TControl.Hide;
Var  WHandle:LongWord;
Begin
     If Not Designed Then FVisible := False;
     If Handle = 0 Then Exit;


     If FFrame <> Nil Then WHandle := FFrame.Handle
     Else WHandle := Handle;
     If WHandle=0 Then exit;
     
     If FOnHide <> Nil Then FOnHide(Self);
     
     {$IFDEF OS2}
     WinShowWindow(WHandle,False);
     {$ENDIF}
     {$IFDEF Win32}
     ShowWindow(WHandle,SW_HIDE);
     {$ENDIF}
End;


Procedure TControl.Show;
Var  T:LongInt;
     Control:TControl;
     WHandle:LongWord;

Begin
     If Handle = 0 Then CreateWnd;
     If Handle = 0 Then Exit;

     If FOnShow <> Nil Then FOnShow(Self);

     If Not Designed Then FVisible := True;

     If FFirstShow Then
     Begin
          FFirstShow := False;

          {Show Controls}
          For T := 0 To ControlCount-1 Do
          Begin
               Control := Controls[T];
               If Control.ComponentState * [csReference] = [] Then {!}
                 If Control.FVisible Or Control.Designed Then Control.Show;
          End;

          If FFrame <> Nil Then
          Begin
               Move;
               Resize;
               FFrame.Show;

               If Self Is TForm Then
                  TForm(Self).SetWindowState(TForm(Self).FWindowState);

               Update;
               FFrame.Update;

               {$IFDEF OS2}
               WinShowWindow(Handle,True);
               {$ENDIF}

               {$IFDEF Win32}
               ShowWindow(Handle,SW_SHOW);
               {$ENDIF}

               Exit;
          End;

          SetWindowPos(FLeft,FBottom,FWidth,FHeight);
     End;

     If FFrame <> Nil Then WHandle := FFrame.Handle
     Else WHandle := Handle;
     {$IFDEF OS2}
     WinShowWindow(WHandle,True);
     {$ENDIF}
     {$IFDEF Win32}
     If ControlStyle*[csHintWindow]<>[] Then ShowWindow(WHandle,SW_SHOWNA)
     Else ShowWindow(WHandle,SW_SHOW);
     {$ENDIF}
     If Not (Self Is TFrameControl) Then Update;
End;


Function TControl.GetControlFromPoint(pt:TPoint):TControl;
Var  ahwnd:LongWord;
Begin
     Result := Nil;
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     ahwnd := WinWindowFromPoint(Handle,pt,True);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,Self);
     ahwnd := ChildWindowFromPoint(Handle,POINTL(pt));
     {$ENDIF}
     Result := HandleToControl(ahwnd);
End;



Function TControl.GetWindowRect:TRect;
{$IFDEF OS2}
Var  aswp:SWP;
{$ENDIF}
Begin
     {OS2: Window With 0 created; Linux: Fram doesn't work}
     If (Handle = 0) {$IFDEF OS2} Or FFirstShow {$ENDIF} Then
     Begin                       
          Result.Left := FLeft;
          Result.Bottom := FBottom;
          Result.Right := FLeft + FWidth -1;
          Result.Top := FBottom + FHeight -1;
          Exit;
     End;

     {$IFDEF OS2}
     If FFrame <> Nil Then
     Begin
          Result := FFrame.GetWindowRect;
          Exit;
     End;

     WinQueryWindowPos(Handle,aswp);
     Result.Left := aswp.X;
     Result.Right := Result.Left + aswp.CX -1;
     Result.Bottom := aswp.Y;
     Result.Top := aswp.Y + aswp.CY -1;
     {$ENDIF}

     {$IFDEF Win32}
     WinUser.GetWindowRect(Handle,RECTL(Result));
     If FParent <> Nil Then
     Begin
          MapWindowPoints(HWND_DESKTOP,FParent.Handle,
                          WinDef.Point(Result.Left),2);
     End;
     TransformRectToOS2(Result,FParent,Nil);
     Win32RectToRect(Result);
     Dec(Result.Right);
     Dec(Result.Top);
     {$ENDIF}
End;


Procedure TControl.SetWindowRect(Const rec:TRect);
Begin
     SetWindowPos(rec.Left,rec.Bottom,rec.Right-rec.Left+1,rec.Top-rec.Bottom+1);
End;


Function TControl.GetBoundsRect:TRect;
Begin
     Result.Left := Left;
     Result.Right := Left + Width -1;
     Result.Bottom := Top + Height -1;
     Result.Top := Top;
End;


Procedure TControl.SetBoundsRect(Const rec:TRect);
Begin
     SetBounds(rec.Left,rec.Top,rec.Right-rec.Left+1,rec.Bottom-rec.Top+1);
End;



Function TControl.GetClientRect:TRect;
Begin
     {OS2: Window With 0 created; Linux: Frame doesn't work}
     If (Handle = 0) {$IFDEF OS2} Or FFirstShow {$ENDIF} Then
     Begin                       
          Result.Left := 0;
          Result.Bottom := 0;
          Result.Right := FWidth;
          Result.Top := FHeight;
     End
     Else
     Begin
          {$IFDEF OS2}
          WinQueryWindowRect(Handle,RECTL(Result));
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.GetClientRect(Handle,RECTL(Result));
          {$ENDIF}
     End;

     Dec(Result.Right);
     Dec(Result.Top);
End;


Function TControl.GetClientWidth:LongInt;
Var  rc:TRect;
Begin
     rc := GetClientRect;
     Result := rc.Right - rc.Left +1;
End;


Function TControl.GetClientHeight:LongInt;
Var  rc:TRect;
Begin
     rc := GetClientRect;
     Result := rc.Top - rc.Bottom +1;
End;


Procedure TControl.SetClientWidth(NewWidth:LongInt);
Begin
     Width := NewWidth;     {no border In TControl}
End;


Procedure TControl.SetClientHeight(NewHeight:LongInt);
Begin
     Height := NewHeight;   {no border In TControl}
End;


Function TControl.GetClientOrigin:TPoint;
Begin
     If IsControl(Parent) Then Result := Parent.ClientOrigin
     Else Result := Point(0,0);
     Inc(Result.X, Left);
     Inc(Result.Y, Bottom);
End;


Function TControl.GetParentClientWidth:LongInt;
Begin
     Result := 0;
     If IsControl(Parent) Then Result := Parent.ClientWidth
     Else If Self Is TFrameControl Then Result := Screen.Width
     Else If (Self Is TForm) And (TForm(Self).FormStyle <> fsMDIChild)
          Then Result := Screen.Width;
End;


Function TControl.GetParentClientHeight:LongInt;
Begin
     Result := 0;
     If IsControl(Parent) Then Result := Parent.ClientHeight
     Else If Self Is TFrameControl Then Result := Screen.Height
     Else If (Self Is TForm) And (TForm(Self).FormStyle <> fsMDIChild)
          Then Result := Screen.Height;
End;


Function TControl.ClientToScreen(Const Point:TPoint):TPoint;
Var  Origin:TPoint;
Begin
     Origin := ClientOrigin;
     Result.X := Point.X + Origin.X;
     Result.Y := Point.Y + Origin.Y;
End;


Function TControl.ScreenToClient(Const Point:TPoint):TPoint;
Var  Origin:TPoint;
Begin
     Origin := ClientOrigin;
     Result.X := Point.X - Origin.X;
     Result.Y := Point.Y - Origin.Y;
End;


Procedure TControl.WndProc(Var Msg:TMessage);
Var  OldLastMsgAdr:PMessage;
     Handled:Boolean;
Begin
     If ((Application<>Nil)And(Application.FOnMsgEvent<>Nil)) Then
     Begin
          Handled:=False;
          Application.FOnMsgEvent(Msg,Handled);
          Msg.Handled:=Msg.Handled Or Handled;
     End;

     {$IFDEF OS2}
     If Msg.Receiver<>Handle Then exit;
     {$ENDIF}

     {Store Last LastMsgAdr To Handle nested calls}
     OldLastMsgAdr := FLastMsgAdr;
     {Store the address Of the Current Msg To be able To Set Handled & Result
     Parameter In Some Methods, where This Parameter Is Not available}
     FLastMsgAdr := @Msg;

     If Not Msg.Handled Then Dispatch(Msg);     {send Messages To Object}
     If Not Msg.Handled Then DefaultHandler(Msg);

     {Reset Last LastMsgAdr To Handle nested calls}
     {$IFDEF OS2}
     If Msg.Msg <> CM_RELEASE Then
       If IsControl(Self) Then FLastMsgAdr := OldLastMsgAdr;
     {$ENDIF}

     {$IFDEF WIN32}
     If Screen<>Nil Then 
       If Screen.FCanvas.Handle<>0 Then
     Begin
          SelectObject(Screen.FCanvas.Handle,GetStockObject(BLACK_PEN));
          SelectObject(Screen.FCanvas.Handle,GetStockObject(WHITE_BRUSH));
          DeleteObject(TControlCanvas(Screen.FCanvas).PenHandle);
          TControlCanvas(Screen.FCanvas).PenHandle:=0;
          DeleteObject(TControlCanvas(Screen.FCanvas).BrushHandle);
          TControlCanvas(Screen.FCanvas).BrushHandle:=0;
          DeleteDC(Screen.FCanvas.Handle);
          Screen.FCanvas.Handle:=0;
     End;

     If Msg.Msg<>CM_RELEASE Then
       If Msg.Msg<>WM_CLOSE Then
         If Msg.Msg<>WM_NCLBUTTONDOWN Then
           If not ((Msg.Msg=WM_SYSCOMMAND)And(Msg.Param1=SC_CLOSE)) Then
     Begin
          Try
             If IsControl(Self) Then
             Begin
                  FLastMsgAdr := OldLastMsgAdr;
                  If FCanvas<>Nil Then
                  Begin
                       If TControlCanvas(FCanvas).PenHandle<>0 Then
                       Begin
                           If FCanvas.Handle<>0 Then
                             SelectObject(FCanvas.Handle,GetStockObject(BLACK_PEN));
                           DeleteObject(TControlCanvas(FCanvas).PenHandle);
                           TControlCanvas(FCanvas).PenHandle:=0;
                       End;
                       If TControlCanvas(FCanvas).BrushHandle<>0 Then
                       Begin
                            If FCanvas.Handle<>0 Then
                              SelectObject(FCanvas.Handle,GetStockObject(WHITE_BRUSH));
                            DeleteObject(TControlCanvas(FCanvas).BrushHandle);
                            TControlCanvas(FCanvas).BrushHandle:=0;
                       End;
                  End;
             End;
          Except
          End;
     End;
     {$ENDIF}
End;


Function TControl.GetLastMsg:TLastMsg;
Begin
     If FLastMsg = Nil Then
     Begin
          FLastMsg.Create;
          FLastMsg.FControl := Self;
     End;
     Result := FLastMsg;
End;


Procedure TControl.RecreateWnd;
Var  SaveOnSetupShow:TNotifyEvent;
     WasVisible:Boolean;
Begin
     If Handle <> 0 Then
     Begin
          SaveOnSetupShow := FOnSetupShow;
          FOnSetupShow := Nil;              {don't call it again}

          WasVisible := Visible;
          DestroyHandle;
          CreateWnd;
          If WasVisible Then Show;

          FOnSetupShow := SaveOnSetupShow;
     End;
End;


Procedure TControl.DisposeWnd;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSubClassWindow(Handle,@FDefWndProc);
          WinSetWindowULong(Handle,QWL_USER,0);
          {$ENDIF}
          {$IFDEF Win32}
          if IsWindow (Handle){Martin} then begin
            SetWindowLong(Handle,GWL_WNDPROC,Longword(@FDefWndProc));
            SetWindowLong(Handle,GWL_USERDATA,0);
          end;
          {$ENDIF}
     End;

     If FCanvas <> Nil Then FCanvas.Destroy;
     FCanvas := Nil;

     If Application<>Nil Then
     Begin
          If Application.FHintOwner = Self Then Application.DestroyHintWindow;

          If Application.FHintControl = Self Then
          Begin
               If Application.FHintTimer <> Nil Then Application.FHintTimer.Destroy;
               Application.FHintTimer := Nil;
               Application.FHintControl := Nil;
               Application.FHintParent := Nil;
          End;
     End;

     {$IFDEF OS2}
     DereferenceFont(FFont,True);
     {$ENDIF}
     
     {$IFDEF Win32}
     If FDefFontHandle <> 0 Then
     Begin
          If FDefFontHandle = TControlFont(FFont).Handle Then
          Begin
               If TControlFont(FFont).RefCount > 1 Then TControlFont(FFont).RefCount:=TControlFont(FFont).RefCount-1
               Else
               Begin
                    If FDefFontHandle <> 0 Then
                    Begin
                         {$IFDEF Win32}
                         DeleteObject(FDefFontHandle);
                         {$ENDIF}
                    End;
                    TControlFont(FFont).RefCount := 0;
                    TControlFont(FFont).Handle := 0;
               End;
          End
          Else If FDefFontHandle <> 0 Then
          Begin
               {$IFDEF Win32}
               DeleteObject(FDefFontHandle);
               {$ENDIF}
          End;      
     End;
     FDefFontHandle := 0;
     If FFont <> Nil Then DereferenceFont(FFont,False);

     {$IFDEF Win32}
     If FCtlBrush <> 0 Then DeleteObject(FCtlBrush);
     FCtlBrush := 0;
     {$ENDIF}
     {$ENDIF}
End;


Procedure TControl.DestroyWnd;
Var h:LongInt;
Begin
     AssignStr(FCaption, Caption);
     If Handle <> 0 Then
     Begin
          h:=Handle;
          FHandle:=0;
          {$IFDEF OS2}
          WinDestroyWindow(h);
          {$ENDIF}
          {$IFDEF Win32}
          DestroyWindow(h);
          {$ENDIF}
     End;

     If FFrame <> Nil Then FFrame.DestroyWnd; //client first !!

     FInitControls := True;       {For [re]CreateWnd}
     FLeft := Left;               {Get Value from Frame}
     FBottom := Bottom;
     FWidth := Width;
     FHeight := Height;
End;


Procedure TControl.DestroyHandle;

Var  I:LongInt;
     Control:TControl;

Begin
     If FHandle = 0 Then Exit;

     Include(ControlState,csWindowDestroying);

     If Self Is TForm Then
     Begin
          If DDEMan_CloseClientLinks <> Nil Then DDEMan_CloseClientLinks(TForm(Self));
     End;

     DisposeWnd;

     For I := 0 To ControlCount-1 Do     {WinControls}
     Begin
          Control := Controls[I];
          Control.DestroyHandle;
     End;

     DestroyWnd;

     If Self Is TForm Then Screen.Update;

     Exclude(ControlState,csWindowDestroying);
End;


Destructor TControl.Destroy;
Begin
  Include(ComponentState,csDestroying);

  If FHasFocus Then
    If FForm <> Nil Then
      If FForm.ComponentState * [csDestroying] = [] Then FForm.CaptureFocus;

     {Destroys the Window}
  If Parent <> Nil 
    Then SetParent(Nil)
    Else DestroyHandle;  {no phys. Parent -> only Destroy the Handle}

  DestroyControls; {Destroy All Child Controls}

  DisposeStr(FHint);
  FHint := Nil;

  DisposeStr(FCaption);
  FCaption := Nil;

  If FAutoScale <> Nil Then Dispose(FAutoScale);
  FAutoScale := Nil;
  If FAutoFrame <> Nil Then Dispose(FAutoFrame);
  FAutoFrame := Nil;

  If FForm Is TForm Then
    If FForm.FActiveControl = Self Then FForm.FActiveControl := Nil;
  If Screen.FActiveControl = Self Then Screen.FActiveControl := Nil;

  If FLastMsg <> Nil Then FLastMsg.Destroy;
  FLastMsg := Nil;
  If FAlternateFontName <> Nil Then DisposeStr(FAlternateFontName);
  FAlternateFontName := Nil;

  FConstraints.Destroy;
  Inherited Destroy;

  Screen.UpdateLastActive;
End;


Procedure TControl.DestroyControls;
Var  I:LongInt;
     Control:TControl;
Begin
     If FControls <> Nil Then
     Begin
          I := ControlCount;
          While I > 0 Do
          Begin
               Control := Controls[I-1];
               RemoveControl(Control);
               Control.Destroy;
               I := ControlCount;
          End;
     End;
End;

Procedure TControl.WMDestroy(Var Msg:TWMDestroy);
Begin
     DisposeWnd;

     FHandle := 0;
     Msg.Handled := True;
     Msg.Result := 0;
End;


{$IFDEF Win32}
Procedure TControl.WMNCDestroy(Var Msg:TMessage);
Begin
     FHandle := 0;
     Msg.Handled := True;
     Msg.Result := 0;
End;
{$ENDIF}


Procedure TControl.DefaultHandler(Var Msg:TMessage);
Begin
     If Handle = 0 Then Exit; {because Of Perform}
     If TMessage(Msg).ReceiverClass <> Self Then Exit; {don't call it For other handles!}
     If TMessage(Msg).Receiver <> Handle Then Exit; {don't call it For other handles!}
     {$IFDEF OS2}
     TMessage(Msg).Result := FDefWndProc(TMessage(Msg).Receiver,
                                         TMessage(Msg).Msg,
                                         TMessage(Msg).Param1,
                                         TMessage(Msg).Param2);
     {$ENDIF}
     {$IFDEF Win32}
     TMessage(Msg).Result := CallWindowProc(@FDefWndProc,TMessage(Msg).Receiver,
                                            TMessage(Msg).Msg,
                                            TMessage(Msg).Param1,
                                            TMessage(Msg).Param2);
     {$ENDIF}
     If TMessage(Msg).Msg <> WM_COMMAND Then TMessage(Msg).Handled := True; {!!}
End;


Procedure TControl.RealignControls;
Var  Control:TControl;
     T:LongInt;
Begin
     {Align Controls again}
     For T := 0 To ControlCount-1 Do
     Begin
          Control := Controls[T];
          {$IFDEF OS2}
          If (Control.XAlign In [xaParent,xaLeft,xaRight,xaCenter]) Or
             (Control.YAlign In [yaParent,yaBottom,yaTop,yaCenter]) Or
             (Control.XStretch In [xsParent,xsFrame,xsScale]) Or
             (Control.YStretch In [ysParent,ysFrame,ysScale]) Or
             (Control.FIsToolBar) Then
          Begin
               Control.SetWindowPos(Control.Left,Control.Bottom,
                                    Control.Width,Control.Height);
          End;
          {$ENDIF}
          {$IFDEF WIN32}
          Control.SetWindowPos(Control.Left,Control.Bottom,
                               Control.Width,Control.Height);
          {$ENDIF}
     End;
End;


Procedure TControl.SetLeft(NewLeft:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FLeft := NewLeft
          Else SetWindowPos(NewLeft,Bottom,Width,Height);
     End
     Else FFrame.SetLeft(NewLeft);
End;


Function TControl.GetLeft:LongInt;
Begin
     If FFrame = Nil Then Result := FLeft
     Else Result := FFrame.GetLeft;
End;


Procedure TControl.SetBottom(NewBottom:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FBottom := NewBottom
          Else SetWindowPos(Left,NewBottom,Width,Height);
     End
     Else FFrame.SetBottom(NewBottom);
End;


Function TControl.GetBottom:LongInt;
Begin
     If FFrame = Nil Then Result := FBottom
     Else Result := FFrame.GetBottom;
End;


Procedure TControl.SetWidth(NewWidth:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FWidth := NewWidth
          Else SetWindowPos(Left,Bottom,NewWidth,Height);
     End
     Else FFrame.SetWidth(NewWidth);
End;


Function TControl.GetWidth:LongInt;
Begin
     If FFrame = Nil Then Result := FWidth
     Else Result := FFrame.GetWidth;
End;


Procedure TControl.SetHeight(NewHeight:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FHeight := NewHeight
          Else SetWindowPos(Left,Bottom,Width,NewHeight);
     End
     Else
     Begin
          FFrame.SetHeight(NewHeight);
     End;
End;


Function TControl.GetHeight:LongInt;
Begin
     If FFrame = Nil Then Result := FHeight
     Else Result := FFrame.GetHeight;
End;


Procedure TControl.SetRight(NewRight:LongInt);
Var  _Width:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          _Width := GetParentClientWidth;
          SetWindowPos(_Width-Width-NewRight,Bottom,Width,Height);
     End
     Else FFrame.SetRight(NewRight);
End;


Function TControl.GetRight:LongInt;
Var  _Width:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          _Width := GetParentClientWidth;
          Result := _Width - FLeft - FWidth;
     End
     Else Result := FFrame.GetRight;
End;


Procedure TControl.SetTop(NewTop:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          SetBounds(Left,NewTop,Width,Height);
     End
     Else FFrame.SetTop(NewTop);
End;


Function TControl.GetTop:LongInt;
Var  _Height:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          _Height := GetParentClientHeight;
          Result := _Height - FBottom - FHeight;
     End
     Else Result := FFrame.GetTop;
End;


Procedure TControl.SetBounds(NewLeft,NewTop,NewWidth,NewHeight:LongInt);
Var  NewBottom:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          NewBottom := GetParentClientHeight - NewHeight - NewTop;
          SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
     End
     Else FFrame.SetBounds(NewLeft,NewTop,NewWidth,NewHeight);
End;


Procedure TControl.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Var  rc:TRect;
     cw,CH:LongInt;
     oldwidth,oldheight:LongInt;
Begin
     oldwidth := FWidth;
     oldheight := FHeight;
     Case FXStretch Of
       xsParent:
       Begin
            NewWidth := GetParentClientWidth;
       End;
       xsFrame:
       Begin {only relevant from A Parent WMSize call}
            If FAutoFrame <> Nil Then
            Begin
                 NewLeft := FAutoFrame^.Left;
                 NewWidth := GetParentClientWidth
                             - FAutoFrame^.Right - NewLeft;
            End;
       End;
       xsScale:
       Begin {only relevant from A Parent WMSize call}
            If FAutoScale <> Nil Then
            Begin
                 cw := GetParentClientWidth;
                 NewLeft := FAutoScale^.Left * cw;
                 NewWidth := FAutoScale^.Right * cw - NewLeft;
            End;
       End;
       xsFixed:
       Begin
            If Handle <> 0 Then NewWidth := Width;
       End;
     End;

     Case FYStretch Of
       ysParent:
       Begin
            NewHeight := GetParentClientHeight;
       End;
       ysFrame:
       Begin {only relevant from A Parent WMSize call}
            If FAutoFrame <> Nil Then
            Begin
                 NewBottom := FAutoFrame^.Bottom;
                 NewHeight := GetParentClientHeight
                              - FAutoFrame^.Top - NewBottom;
            End;
       End;
       ysScale:
       Begin {only relevant from A Parent WMSize call}
            If FAutoScale <> Nil Then
            Begin
                 CH := GetParentClientHeight;
                 NewBottom := FAutoScale^.Bottom * CH;
                 NewHeight := FAutoScale^.Top * CH - NewBottom;
            End;
       End;
       ysFixed:
       Begin
            If Handle <> 0 Then NewHeight := Height;
       End;
     End;

     Case FXAlign Of
       xaParent:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.ClientRect;
                 NewLeft := rc.Left;
            End
            Else NewLeft := 0;
       End;
       xaLeft:
       Begin
            NewLeft := Left;
       End;
       xaRight:
       Begin
            If FAutoFrame <> Nil Then
            Begin
                 cw := GetParentClientWidth;
                 NewLeft := cw - FAutoFrame^.Right - NewWidth;
            End;
       End;
       xaCenter:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.GetClientRect;
                 NewLeft := rc.Left+(rc.Right+1-rc.Left-NewWidth) Div 2;
            End
            Else NewLeft := (Screen.Width-NewWidth) Div 2;
       End;
     End;

     Case FYAlign Of
       yaParent:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.ClientRect;
                 NewBottom := rc.Bottom;
            End
            Else NewBottom := 0;
       End;
       yaBottom:
       Begin
            NewBottom := Bottom;
       End;
       yaTop:
       Begin
            If FAutoFrame <> Nil Then
            Begin
                 CH := GetParentClientHeight;
                 NewBottom := CH - FAutoFrame^.Top - NewHeight;
            End;
       End;
       yaCenter:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.GetClientRect;
                 NewBottom := rc.Bottom+(rc.Top+1-rc.Bottom-NewHeight) Div 2;
            End
            Else NewBottom := (Screen.Height-NewHeight) Div 2;
       End;
     End;

     FLeft := NewLeft;
     FBottom := NewBottom;
     FWidth := NewWidth;
     FHeight := NewHeight;

     If DesignerState * [dsNoRealSizing] <> [] Then Exit;

     If Handle <> 0 Then UpdateWindowPos(FLeft,FBottom,FWidth,FHeight);

     If Not (Self Is TForm) Then
     Begin
          If FStandardControl Then
            If (oldwidth <> FWidth) Or (oldheight <> FHeight) Or Designed
            Then Resize; {because Of no WMSize}
     End;

     If Parent Is TScrollingWinControl Then
     Begin
          TScrollingwinControl(Parent).AdjustScrollbars;
          TScrollingwinControl(Parent).AlignScrollbars;
     End;
End;


Procedure TControl.UpdateWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Var Flags:LongInt;
    ZWin:HWND;
    {$IFDEF Win32}
    rc,rc1:TRect;
    NewTop:LongInt;
    {$ENDIF}

Begin
  ZWin := 0;
  Flags := 0;
  If Handle=0 Then exit;

  {$IFDEF OS2}
  If Visible Then Flags := Flags Or SWP_SHOW;
  {Show flag nur setzen, wenn das Fenster schon sichtbar ist}
  Case FZOrder Of
    zoBottom: ZWin := HWND_BOTTOM;
    zoTop:    ZWin := HWND_TOP;
  End;
  If FZOrder <> zoNone Then Flags := Flags Or SWP_ZORDER;

  Flags := Flags Or SWP_SIZE Or SWP_MOVE;

  WinSetWindowPos(Handle,ZWin,NewLeft,NewBottom,NewWidth,NewHeight,Flags);
  {$ENDIF}

  {$IFDEF Win32}
  If Parent <> Nil
    Then
      Begin
        NewTop := Parent.FHeight - FBottom - FHeight;
        If Parent Is TFrameControl Then
          Begin
// the origin of the frame is equal to the client origin of the form
            Dec(NewTop, goSysInfo.Screen.TitlebarSize);
            Dec(NewTop, GetBorderHeight(FForm));
            Dec(NewLeft, GetBorderWidth(FForm));          {???}
            Dec(NewTop, GetBorderHeight(FForm));
          End;
     End
    Else NewTop := Screen.Height - FBottom - FHeight;
  If ControlStyle*[csHintWindow]<>[] Then Flags:=Flags Or SWP_NOACTIVATE;
  If Visible Then Flags := Flags Or SWP_SHOWWINDOW;

  Case FZOrder Of
    zoNone:   Flags := Flags Or SWP_NOZORDER;
    zoBottom: ZWin := HWND_BOTTOM;
    zoTop:    ZWin := HWND_TOP;
  End;

  WinUser.SetWindowPos(Handle,ZWin,NewLeft,NewTop,NewWidth,NewHeight,Flags);

  If Self Is TFrameControl Then
    If TFrameControl(Self).FChild <> Nil Then
      Begin
        WinUser.GetClientRect(Handle,RECTL(rc1));
        rc := GetClientRect;
        NewWidth := rc.Right-rc.Left+1;
        NewHeight := rc.Top-rc.Bottom+1;
        NewLeft := rc.Left;
        NewTop := ((rc1.Top-rc1.Bottom)-NewHeight)-rc.Bottom;
        Flags := 0;
        ZWin := 0;
        If TFrameControl(Self).FChild.Visible
          Then Flags := Flags Or SWP_SHOWWINDOW;
        Case FZOrder Of
          zoNone:   Flags := Flags Or SWP_NOZORDER;
          zoBottom: ZWin := HWND_BOTTOM;
          zoTop:    ZWin := HWND_TOP;
        End;

        WinUser.SetWindowPos(TFrameControl(Self).FChild.Handle,ZWin,
                             NewLeft,NewTop,NewWidth,NewHeight, Flags);
     End;
  {$ENDIF}
End;

Procedure TControl.SetupShow;
Begin
  {$IFDEF OS2}
  SetPPForeGroundColor(FPenColor);
  SetPPBackGroundColor(FColor);
  {$ENDIF}
End;


Procedure TControl.BringToFront;
Var  Win:LongWord;
     Flags:LongWord;
Begin
     If IsControlLocked(Self) Then Exit;

     If FFrame <> Nil Then Win := FFrame.Handle
     Else Win := Handle;
     If Win=0 Then exit;

     {$IFDEF OS2}
     If Visible Then Flags := SWP_SHOW
     Else Flags := 0;
     WinSetWindowPos(Win,HWND_TOP,0,0,0,0,
                     Flags Or SWP_ZORDER {Or SWP_ACTIVATE});
     {$ENDIF}
     {$IFDEF Win32}
     If Visible Then Flags := SWP_SHOWWINDOW
     Else Flags := 0;
     WinUser.SetWindowPos(Win,HWND_TOP,0,0,0,0,
                          Flags Or SWP_NOMOVE Or SWP_NOSIZE);
     {$ENDIF}
End;


Procedure TControl.SendToBack;
Var  Win:LongWord;
     Flags:LongWord;
Begin
     If IsControlLocked(Self) Then Exit;

     If FFrame <> Nil Then Win := FFrame.Handle
     Else Win := Handle;
     If Win=0 Then exit;

     {$IFDEF OS2}
     If Visible Then Flags := SWP_SHOW
     Else Flags := 0;
     WinSetWindowPos(Win,HWND_BOTTOM,0,0,0,0,
                     Flags Or SWP_ZORDER {Or SWP_ACTIVATE});
     {$ENDIF}
     {$IFDEF Win32}
     If Visible Then Flags := SWP_SHOWWINDOW
     Else Flags := 0;
     WinUser.SetWindowPos(Win,HWND_BOTTOM,0,0,0,0,
                          Flags Or SWP_NOMOVE Or SWP_NOSIZE);
     {$ENDIF}
End;


Procedure TControl.KillFocus;
Begin
     If OnExit <> Nil Then OnExit(Self);
End;


Procedure TControl.SetFocus;
Begin
     If OnEnter <> Nil Then OnEnter(Self);
End;


Procedure TControl.DoSetFocus;
Begin
     FHasFocus := TRUE;
     If Application <> Nil Then Application.FHasFocus := TRUE;

     If FForm Is TForm Then FForm.FActiveControl := Self;
     Screen.FActiveControl := Self;
     Screen.UpdateLastActive;

     SetFocus;
End;


Procedure TControl.DoKillFocus;
Begin
     FHasFocus := FALSE;
     If Application <> Nil Then Application.FHasFocus := FALSE;

     KillFocus;
End;


Procedure TControl.DoChangeFocus(Value:Boolean;otherfocuswin:Longword);
Begin
     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
     Begin
          TFrameControl(Self).Child.DoChangeFocus(Value,otherfocuswin);
          Exit;
     End;

     If Value = True Then
     Begin
          DoSetFocus;                    {window is getting Focus}
          {hold active titlebar if focus is comming from Form}
          If Form <> Nil Then
            If Screen.ActiveForm <> Form Then Form.DoActivate;
     End
     Else DoKillFocus;                   {window is loosing Focus}
End;


{$IFDEF Win32}
Procedure TControl.WMKillFocus(Var Msg:TMessage);
Begin
     If FStandardControl Then DefaultHandler(Msg);

     If Not Designed Or (Self Is TForm) Then Msg.Handled := True;

     DoChangeFocus(False, Msg.wParam);
End;


Procedure TControl.WMSetFocus(Var Msg:TWMSetFocus);
Begin
     If FStandardControl Then DefaultHandler(Msg);

     If (Not Designed) Or (Self Is TForm) Then Msg.Handled := True;

     DoChangeFocus(True, Msg.FocusedWnd);
End;
{$ENDIF}

{$IFDEF OS2}
Procedure TControl.WMSetFocus(Var Msg:TWMSetFocus);
Begin
     If FStandardControl Then DefaultHandler(TMessage(Msg));

     Msg.Handled := True;

     DoChangeFocus(Msg.Focus, Msg.FocusedWnd);
End;
{$ENDIF}


Procedure TControl.Paint(Const rec:TRect);
Begin
  If FCanvas <> Nil Then FCanvas.ClipRect := rec;
  If OnBeforePaint <> Nil Then OnBeforePaint(Self,rec);

  If OnPaint <> Nil
    Then OnPaint(Self,rec)
    Else Redraw(rec);

  If OnAfterPaint <> Nil Then OnAfterPaint(Self,rec);
  If FCanvas <> Nil Then
    If FCanvas.ClipRect = rec Then FCanvas.DeleteClipRegion;
End;


Procedure TControl.SetUpdateEnabled(Value:Boolean);
Begin
  FUpdateEnabled := Value;
  If Handle = 0 Then Exit;
  If FUpdateEnabled
    Then
      Begin
        {$IFDEF OS2}
        WinLockWindowUpdate(HWND_DESKTOP,0);
        {$ENDIF}
        {$IFDEF Win32}
        WinUser.LockWindowUpdate(0);
        {$ENDIF}
        Invalidate;
      End
    Else
      Begin
        {$IFDEF OS2}
        WinLockWindowUpdate(HWND_DESKTOP,Handle);
        {$ENDIF}
        {$IFDEF Win32}
        WinUser.LockWindowUpdate(Handle);
        {$ENDIF}
      End;
End;


Function TControl.GetDesignerCoordinates(Var pt:TPoint):TControl;
Begin
     Result := Self;
     While (Result.Designed) And (Result.Parent <> Nil) Do
     Begin
          Inc(pt.X, Result.Left);
          Inc(pt.Y, Result.Bottom);
          Result := Result.Parent;
     End;
End;


Procedure TControl.DesignerNotification(Var DNS:TDesignerNotifyStruct);
Var  AForm:TForm;
Begin
     AForm := TForm(Parent);
     If AForm <> Nil Then
     Begin
          While (AForm.Designed) And (AForm.Parent <> Nil) Do
          Begin
               AForm := TForm(AForm.Parent);
          End;
     End;
     If AForm <> Nil Then AForm.DesignerNotification(DNS);
End;


Procedure TControl.WMPaint(Var Msg:TMessage);
Var rec:TRect;
    relpt:TPoint;
    Control:TControl;
    DNS:TDesignerNotifyStruct;
    {$IFDEF OS2}
    FHPS:HPS;
    {$ENDIF}
    {$IFDEF Win32}
    FPS:PAINTSTRUCT;
    {$ENDIF}
Begin
  If Not IsWindowVisible Then Exit;

  If FOwnerDraw Then
    If FCanvas = Nil Then Exit;

  If Not FUpdateEnabled Then
    Begin
      Msg.Handled := True;
      Msg.Result := 0;
      Exit;
    End;

  If FOwnerDraw
    Then
      Begin
        {$IFDEF OS2}
        FHPS := WinBeginPaint(Handle,0,RECTL(rec));
        {$ENDIF}
        {$IFDEF Win32}
        BeginPaint(Msg.Receiver,FPS);
        rec := TRect(FPS.rcPaint);
        rec:=ClientRect;
        Win32RectToRect(rec);
        TransformRectToOS2(rec,Self,Nil);   {TransformClientRect?}
        Dec(rec.Bottom);
        Inc(rec.Top);
        {$ENDIF}

        If (rec.Top > rec.Bottom) Or (rec.Right > rec.Left) Then
          Begin
            Paint(rec);
            {$IFDEF Win32}
            If FCanvas<>Nil Then
              FCanvas.DeleteClipRegion; {because FPS.rcPaint will be clipped}
            {$ENDIF}
          End;

        {$IFDEF OS2}
        WinEndPaint(FHPS);
        {$ENDIF}
        {$IFDEF Win32}
        EndPaint(Msg.Receiver,FPS);
        {$ENDIF}
      End
    Else
      Begin
        DefaultHandler(Msg);       {Do Default Action}
        rec := TControl.GetClientRect;
      End;

  If Designed Then
    Begin
      relpt.X := 0;
      relpt.Y := 0;
      Control := GetDesignerCoordinates(relpt);
      If Control <> Nil Then
        Begin
          Inc(rec.Left,relpt.X);
          Inc(rec.Right,relpt.X);
          Inc(rec.Bottom,relpt.Y);
          Inc(rec.Top,relpt.Y);

          DNS.Sender := Self;
          DNS.Code := dncPaint;
          DNS.return := 0;
          DNS.rec := rec;
          Control.DesignerNotification(DNS);
        End;
    End;

  Msg.Handled := True;
  Msg.Result := 0;
End;


Procedure TControl.SetPopupMenu(NewMenu:TPopupMenu);
Begin
     If NewMenu=FPopupMenu Then Exit;

     If FPopupMenu<>Nil Then FPopupMenu.Notification(Self,opRemove);
     FPopupMenu := NewMenu;
     If FPopupMenu <> Nil Then FPopupMenu.FreeNotification(Self);
End;


Procedure TControl.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  Control:TControl;
Begin
     If FForm <> Nil Then FForm.BringToFront;
     If Button = mbLeft Then Include(ControlState,csLButtonDown);

     Control := Self;
     While True Do
     Begin
          If (Control.FOnMouseDown = Nil) And
             (Control.ComponentState * [csDetail] <> []) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then Exit;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control.FOnMouseDown <> Nil
     Then Control.FOnMouseDown(Control,Button,ShiftState,X,Y);
End;


Procedure TControl.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInT);
Var  Control:TControl;
Begin
     If Button = mbRight Then
       If Not Designed Then CheckMenuPopup(Point(X,Y));

     Control := Self;
     If Button=mbLeft Then
     Begin
          Exclude(ControlState,csLButtonDown);
          Exclude(ControlState,csClicked);
     End;

     While True Do
     Begin
          If (Control.FOnMouseUp = Nil) And
             (Control.ComponentState * [csDetail] <> []) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then Exit;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control.FOnMouseUp <> Nil
     Then Control.FOnMouseUp(Control,Button,ShiftState,X,Y);
End;


Procedure TControl.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var  Control:TControl;
Begin
     Control := Self;
     
     While True Do
     Begin
          If (Control.FOnMouseMove = Nil) And
             (Control.ComponentState * [csDetail] <> []) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then Exit;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control.FOnMouseMove <> Nil
     Then Control.FOnMouseMove(Control,ShiftState,X,Y);
End;



Procedure TControl.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LonGInt);
Var  Control:TControl;
Begin
     Control := Self;
     While True Do
     Begin
          If (Control.FOnMouseClick = Nil) And
             (csDetail In Control.ComponentState) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then break;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control <> Nil Then
       If Control.FOnMouseClick <> Nil
       Then Control.FOnMouseClick(Control,Button,ShiftState,X,Y);


     If Button = mbLeft Then
     Begin
          Control := Self;
          While True Do
          Begin
               If (Control.FOnClick = Nil) And
                  (csDetail In Control.ComponentState) Then
               Begin
                    Control := Control.Parent;
                    If Control = Nil Then break;
               End
               Else break;
          End;

          If Control <> Nil Then
            If Control.FOnClick <> Nil Then Control.FOnClick(Control);
     End;
End;


Procedure TControl.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  Control:TControl;
Begin
     Control := Self;
     While True Do
     Begin
          If (Control.FOnMouseDblClick = Nil) And
             (csDetail In Control.ComponentState) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then break;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control <> Nil Then
       If Control.FOnMouseDblClick <> Nil
       Then Control.FOnMouseDblClick(Control,Button,ShiftState,X,Y);


     If Button = mbLeft Then
     Begin
          Control := Self;
          While True Do
          Begin
               If (Control.FOnDblClick = Nil) And
                  (csDetail In Control.ComponentState) Then
               Begin
                    Control := Control.Parent;
                    If Control = Nil Then break;
               End
               Else break;
          End;

          If Control <> Nil Then
            If FOnDblClick <> Nil Then FOnDblClick(Control);
     End;
End;


Function MausPosFromParam(msgparam:LongWord):TPoint;
Var  X,Y:Integer;
Begin
     X := Lo(msgparam);
     Y := Hi(msgparam);
     Result.X := X;
     Result.Y := Y;
End;


{$HINTS OFF}
Function ShiftStateFromParam(msgparam:LongWord):TShiftState;
Begin
     Result := [];
     {$IFDEF OS2}
     If WinGetKeyState(HWND_DESKTOP,VK_ALT) And $8000 <> 0
       Then Include(Result,ssAlt);
     If WinGetKeyState(HWND_DESKTOP,VK_SHIFT) And $8000 <> 0
       Then Include(Result,ssShift);
     If WinGetKeyState(HWND_DESKTOP,VK_CTRL) And $8000 <> 0
       Then Include(Result,ssCtrl);
     If WinGetKeyState(HWND_DESKTOP,VK_BUTTON1) And $8000 <> 0
       Then Include(Result,ssLeft);
     If WinGetKeyState(HWND_DESKTOP,VK_BUTTON2) And $8000 <> 0
       Then Include(Result,ssRight);
     If WinGetKeyState(HWND_DESKTOP,VK_BUTTON3) And $8000 <> 0
       Then Include(Result,ssMiddle);
     {$ENDIF}
     {$IFDEF Win32}
     If GetKeyState(VK_MENU) < 0 Then Include(Result,ssAlt);
     If msgparam And MK_SHIFT <> 0 Then Include(Result,ssShift);
     If msgparam And MK_CONTROL <> 0 Then Include(Result,ssCtrl);
     If msgparam And MK_LBUTTON <> 0 Then Include(Result,ssLeft);
     If msgparam And MK_RBUTTON <> 0 Then Include(Result,ssRight);
     If msgparam And MK_MBUTTON <> 0 Then Include(Result,ssMiddle);
     {$ENDIF}
End;
{$HINTS ON}


{$IFDEF OS2}
Procedure TControl.WMButton1Click(Var Msg:TWMButton1Click);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseClick;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
     End;
End;


Procedure TControl.WMButton2Click(Var Msg:TWMButton2Click);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseClick(mbRight,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseClick;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseClick(mbRight,ShiftState,pt.X,pt.Y);
     End;
End;
{$ENDIF}


{$IFDEF Win32}
Var WinDragDropData: TDragDropData;
    WinDragControl : TControl;
    WinLastDrag    : TControl;


Function GetDragControl(Const pt:TPoint):TControl;
// Liefert von der aktuellen Mouse-Position (bezogen auf den Bildschirm)
// das Sibyl-Objekt zurueck. Wenn das Ergebnis NIL ist dann wurde kein Sibyl-
// Objekt gefunden.

Var Win:HWND;
    P:Pointer;
Begin
  Result:=Nil;
  Win:=WinUser.WindowFromPoint(pt);
  If Win<>0 Then
    Begin
      P:=Pointer(GetWindowLong(Win,GWL_WNDPROC));
      If P<>@SubclassedWndProc Then Exit; //no Sibyl Window
      Result:=Pointer(GetWindowLong(Win,GWL_USERDATA));
    End;
End;
{$ENDIF}

{+++ Left Button ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Procedure TControl.WMButton1Down(Var Msg:TWMButton1Down);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     HandleMsg:Boolean;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;
     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     FLastLButtonDownTime := GetMessageTime;
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.Handle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}

     HandleMsg:=Not (FStandardControl Or (Self Is TFrameControl));

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDown(mbLeft,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDown;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF Win32}
          If WinDragControl<>Nil Then DragFinished(Nil,pt.X,pt.Y,False);
          {$ENDIF}
          MouseDown(mbLeft,ShiftState,pt.X,pt.Y);
     End;

     If HandleMsg Then
     Begin
          Msg.Handled := True; {!!}
          Msg.Result := 0;
     End;
End;

Procedure TControl.WMButton1Up(Var Msg:TWMButton1Up);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     {$IFDEF Win32}
     Success:Boolean;
     DragObject:TObject;
     DragControl:TControl;
     pt1:TPoint;
     {$ENDIF}
Begin
     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.Handle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     If GetMessageTime - FLastLButtonDownTime < FClickTime Then  {Click}
     Begin
          If Designed Then
          Begin
               If FHandlesDesignMouse Then
               Begin
                    MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
                    If Msg.Handled Then Exit;  {Do Not send To Form Window}
               End;

               Control := GetDesignerCoordinates(pt);
               If Control <> Nil Then
               Begin
                    DNS.Sender := Self;
                    DNS.Code := dncMouseClick;
                    DNS.return := 0;
                    DNS.mouseparam.pt := pt;
                    DNS.mouseparam.Button := mbLeft;
                    DNS.mouseparam.ShiftState := ShiftState;
                    Control.DesignerNotification(DNS);
                    If DNS.return <> 0 Then
                    Begin
                         Msg.Handled := True;
                         Msg.Result := 0;
                    End;
               End;
          End
          Else
          Begin
               MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
          End;
     End;
     {$ENDIF}

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseUp(mbLeft,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseUp;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF OS2}
          MouseUp(mbLeft,ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF Win32}
          If WinDragControl<>Nil Then
          Begin
               Success:=False;
               If WinDragDropData.RenderType=drmSibylObject Then
               Begin
                    DragObject:=TObject(WinDragDropData.ItemId);
               End
               Else DragObject:=Nil;
               pt1:=Point(Msg.XPos,Msg.YPos);
               WinUser.ClientToScreen(Handle,pt1);
               DragControl:=GetDragControl(pt1);
               Success:=False;
               If DragControl<>Nil Then
                 If WinDragControl<>DragControl Then
                 Begin
                      pt:=pt1;
                      MapWindowPoints(HWND_DESKTOP,DragControl.Handle,pt,1);
                      DragControl.DragDrop(DragObject,pt.X,pt.Y);
                      Success:=True;
                 End;
               DragFinished(DragControl,pt.X,pt.Y, Success);
          End
          Else MouseUp(mbLeft,ShiftState,pt.X,pt.Y);
          {$ENDIF}
     End;
End;


Procedure TControl.WMButton1DblClk(Var Msg:TWMButton1DblClk);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.Handle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDblClick(mbLeft,ShiftState+[ssDouble],pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDblClk;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseDblClick(mbLeft,ShiftState+[ssDouble],pt.X,pt.Y);
     End;
End;


{+++ Right Button +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{initiate Dragging Of A non detail Control}
Function DragInit(Control:TControl; pt:TPoint):Boolean;
Var  Ok:Boolean;
Begin
     Result := False;

     While Control.ComponentState * [csDetail] <> [] Do
     Begin
          Inc(pt.X, Control.Left);
          Inc(pt.Y, Control.Bottom);
          Control := Control.Parent;
          If Control = Nil Then Exit;
     End;

     If Control.FDragMode=dmAutomatic Then
     Begin
          Ok := True;
          Control.CanDrag(pt.X,pt.Y,Ok);
          If Ok Then Control.BeginDrag(True);
          Result := True;
     End;
End;


Procedure TControl.WMButton2Down(Var Msg:TWMButton2Down);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     IsForm:Boolean;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     IsForm := Self Is TForm;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     FLastRButtonDownTime := GetMessageTime;
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.Handle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDown(mbRight,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDown;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF OS2}
          MouseDown(mbRight,ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF Win32}
          If WinDragControl=Nil Then
          Begin
               If DragInit(Self,pt) Then
               Begin
                    Msg.Handled:=True;
                    Msg.Result:=0;
               End
               Else MouseDown(mbRight,ShiftState,pt.X,pt.Y);
          End
          Else
          Begin
               If WinDragControl<>Nil Then DragFinished(Nil,pt.X,pt.Y,False);
               MouseDown(mbRight,ShiftState,pt.X,pt.Y);
          End;
          {$ENDIF}
     End;

     //If IsForm Then
     If Not (FStandardControl Or (Self Is TFrameControl)) Then
     Begin
          Msg.Handled := True; {!!}
          Msg.Result := 0;
     End;
End;

Procedure TControl.WMButton2Up(Var Msg:TWMButton2Up);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     {$IFDEF Win32}
     Success:Boolean;
     DragObject:TObject;
     DragControl:TControl;
     pt1:TPoint;
     {$ENDIF}
Begin
     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.Handle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     If GetMessageTime - FLastRButtonDownTime < FClickTime Then  {Click}
     Begin
          If Designed Then
          Begin
               If FHandlesDesignMouse Then
               Begin
                    MouseClick(mbRight,ShiftState,pt.X,pt.Y);
                    If Msg.Handled Then Exit;  {Do Not send To Form Window}
               End;

               Control := GetDesignerCoordinates(pt);
               If Control <> Nil Then
               Begin
                    DNS.Sender := Self;
                    DNS.Code := dncMouseClick;
                    DNS.return := 0;
                    DNS.mouseparam.pt := pt;
                    DNS.mouseparam.Button := mbRight;
                    DNS.mouseparam.ShiftState := ShiftState;
                    Control.DesignerNotification(DNS);
                    If DNS.return <> 0 Then
                    Begin
                         Msg.Handled := True;
                         Msg.Result := 0;
                    End;
               End;
          End
          Else
          Begin
               MouseClick(mbRight,ShiftState,pt.X,pt.Y);
          End;
     End;
     {$ENDIF}

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseUp(mbRight,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseUp;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF OS2}
          MouseUp(mbRight,ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF Win32}
          If WinDragControl<>Nil Then
          Begin
               Success:=False;
               {Martin0106}RememberMBshiftState := ShiftState;
               If WinDragDropData.RenderType=drmSibylObject Then
               Begin
                    DragObject:=TObject(WinDragDropData.ItemId);
               End
               Else DragObject:=Nil;
               pt1:=Point(Msg.XPos,Msg.YPos);
               WinUser.ClientToScreen(Handle,pt1);
               DragControl:=GetDragControl(pt1);
               Success:=False;
               If ((DragControl<>Nil)And(WinDragControl<>DragControl)) Then
               Begin
                    pt:=pt1;
                    MapWindowPoints(HWND_DESKTOP,DragControl.Handle,pt,1);
                    TransformPointToOS2(pt,DragControl,Nil);
                    DragControl.DragDrop(DragObject,pt.X,pt.Y);
                    Success:=True;
               End;
               DragFinished(DragControl,pt.X,pt.Y, Success);
          End
          Else MouseUp(mbRight,ShiftState,pt.X,pt.Y);
          {$ENDIF}
     End;
End;


Procedure TControl.WMButton2DblClk(Var Msg:TWMButton2DblClk);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.Handle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDblClick(mbRight,ShiftState+[ssDouble],pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDblClk;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseDblClick(mbRight,ShiftState+[ssDouble],pt.X,pt.Y);
     End;
End;


{Query the actually Visible mouse Cursor Handle}
Function CurrentMouseHandle(Control:TControl):HCursor;
Begin
     If Screen.Cursor <> crDefault
     Then Result := Screen.Cursors[Screen.FCursor]
     Else Result := Screen.Cursors[Control.FCursor];
End;


Procedure TControl.WMMouseMove(Var Msg:TWMMouseMove);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     OldHandled:Boolean;
     CanHint:Boolean;
     HintParent:TControl;
     HintOwner:TControl;

     {$IFDEF Win32}
     Accept:Boolean;
     DragControl:TControl;
     pt1:TPoint;
     DragObject:TObject;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     If IsControlLocked(Self) Then
     Begin
          WinSetPointer(HWND_DESKTOP,Screen.Cursors[FCursor]);
          Msg.Handled := True;
          Msg.Result := 0;
          Exit;
     End
     Else
     Begin
          If FCursor <> crDefault Then
          Begin
               If WinQueryPointer(HWND_DESKTOP) <> CurrentMouseHandle(Self)
               Then SetCursor(FCursor);
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.Handle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Msg.Result := 0;
          Exit;
     End
     Else
     Begin
       if DragControl=nil then
         Begin
          If FCursor <> crDefault Then
          Begin
               If WinUser.GetCursor <> CurrentMouseHandle(Self)
                 Then SetCursor(FCursor);
               Msg.Handled := True;
               Msg.Result := 0;
          End;
        End;
     End;
     {$ENDIF}

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               OldHandled := Msg.Handled;
               Msg.Handled := False;

               MouseMove(ShiftState,pt.X,pt.Y);

               If Msg.Handled Then Exit;  {Do Not send To Form Window}
               Msg.Handled := OldHandled;
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseMove;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF Win32}
          If WinDragControl<>Nil Then //we are Dragging
          Begin
               pt1:=Point(Msg.XPos,Msg.YPos);
               WinUser.ClientToScreen(Handle,pt1);
               DragControl:=GetDragControl(pt1);
               Accept:=false; // true;    // Accept:=false

               If WinDragDropData.RenderType=drmSibylObject
                 Then DragObject:=TObject(WinDragDropData.ItemId)
                 Else DragObject:=Nil;

//               If DragControl<>WinDragControl Then       //02.10.2004
//               Begin                                     //02.10.2004
                    If DragControl<>WinLastDrag Then
                    Begin
                         If WinLastDrag<>Nil Then
                         Begin
                              WinLastDrag.FDragState:=dsDragEnter;
                              TransformPointToOS2(pt,WinLastDrag,Nil);
                              WinLastDrag.DragOver(DragObject,
                                                   pt.X,pt.Y,
                                                   dsDragLeave,
                                                   Accept);
                         End;
                         WinLastDrag:=DragControl;
                         If DragControl<>Nil
                         Then DragControl.FDragState:=dsDragEnter;
                    End
                    Else If DragControl<>Nil
                         Then DragControl.FDragState:=dsDragMove;

                    If DragControl<>Nil Then
                    Begin
                         pt:=pt1;
                         MapWindowPoints(HWND_DESKTOP,DragControl.Handle,pt,1);
                         TransformPointToOS2(pt,DragControl,Nil);
                         DragControl.DragOver(DragObject,pt.X,pt.Y,FDragState,
                                              Accept);
                    End;
//               End;                                      //02.10.2004
               If Accept
                 then WinUser.SetCursor(Screen.Cursors[crDrag])  // WinDragControl.FDragCursor
                 Else WinUser.SetCursor(Screen.Cursors[crNo]);
          End
          Else MouseMove(ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF OS2}
          MouseMove(ShiftState,pt.X,pt.Y);
          {$ENDIF}
     End;

     {Bubble}
     If Application = Nil Then Exit;

     If Application.FHintWindow = Self Then Exit;
     If Application.FHintOwner = Self Then Exit;

     {Destroy Bubble If Not from Self}
     If Application.FHintOwner <> Nil Then
       If Application.FHintOwner <> Self Then
       Begin
            HintOwner := Application.FHintOwner;
            HintParent := Application.FHintParent;
            Application.DestroyHintWindow;
            Application.FHintParent := HintParent;  {Enable Immediate Showing}

            While HintOwner <> Nil Do
            Begin
               HintOwner.Update;
               HintOwner := HintOwner.Parent;
            End;
       End;

     CanHint := (FHint <> Nil) And GetShowHint And (Not Designed);

     {If Timer Is Running, Stop it Or Destroy it}
     If Application.FHintTimer <> Nil Then
     Begin
          Application.FHintTimer.Stop;
          If (Application.FHintControl <> Self) Or (Not CanHint) Then
          Begin
               Application.FHintTimer.Destroy;
               Application.FHintTimer := Nil;
               Application.FHintParent := Nil;
          End;
     End;

     {Show Own Bubble Or Start Timer}
     Application.FHintControl := Self;

     If CanHint Then
     Begin
          If (Application.FHintParent = Parent) And (Parent <> Nil) Then
          Begin {Immediate Showing}
               If Application.FHintOwner = Nil
               Then Application.HintTimerExpired;
          End
          Else
          Begin {Start Timer}
               If Application.FHintTimer = Nil
               Then Application.FHintTimer.Create(Nil);
               Include(Application.FHintTimer.ComponentState, csDetail);
               Application.FHintTimer.Interval := Application.FHintPause;
               Application.FHintTimer.Start;
          End;
     End;

     If (Application.FHintParent <> Parent) And
        (Application.FHintParent <> Self) Then Application.FHintParent := Nil;
End;


Procedure TControl.CheckMenuPopup(pt:TPoint);
Var  AControl:TControl;
     APopup:TPopupMenu;
Begin
     If Designed Then Exit;

     AControl := Self;
     While AControl <> Nil Do
     Begin
          APopup := AControl.PopupMenu;
          If APopup <> Nil Then
            If APopup.AutoPopup Then //Popup-Control found
            Begin
                 APopup.PopupComponent := AControl;
                 pt := ClientToScreen(pt);
                 APopup.Popup(pt.X,pt.Y);
                 Exit;
            End;
          AControl := AControl.Parent;
     End;
End;


{$IFDEF Win32}
Procedure TControl.WMSetCursor(Var Msg:TMessage);
Begin
     If Self Is TFrameControl Then Exit;

     If WinUser.GetCursor <> CurrentMouseHandle(Self)
     Then SetCursor(FCursor);

     Msg.Handled := True;
     Msg.Result := 0;
End;
{$ENDIF}

Procedure TControl.SetCursor(Index:TCursor);
Begin
     FCursor := Index;
     If Designed Then Exit;
     {$IFDEF OS2}
     WinSetPointer(HWND_DESKTOP, CurrentMouseHandle(Self));
     {$ENDIF}
     {$IFDEF Win32}
     SetClassLong(Handle,GCL_HCURSOR,0);
     WinUser.SetCursor(CurrentMouseHandle(Self));
     {$ENDIF}
End;


Procedure TControl.Resize;
Begin
     RealignControls;

     If OnResize <> Nil Then OnResize(Self);
End;


Procedure TControl.Move;
Begin
     If OnMove<>Nil Then OnMove(Self);
End;


{unter Win32 nicht Die Msg.Parameter verwenden}
{$HINTS OFF}
Procedure TControl.WMMove(Var Msg:TWMMove);
Var  rc:TRect;
     {$IFDEF Win32}
     Child:TControl;
     {$ENDIF}
Begin
     If Self Is TForm Then
       If TForm(Self).WindowState = wsMinimized Then
         If Not TForm(Self).Designed Then Exit;

     rc := GetWindowRect;
     FLeft := rc.Left;
     FBottom := rc.Bottom;

     Move;

     {$IFDEF Win32}
     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
     Begin
          Child := TFrameControl(Self).FChild;
          Child.Move;
     End;
     {$ENDIF}
End;
{$HINTS ON}

{unter Win32 nicht Die Msg.Parameter verwenden}
Procedure TControl.WMSize(Var Msg:TWMSize);
Var  rc:TRect;
     {$IFDEF Win32}
     rc1:TRect;
     _Left,_Bottom,_Width,_Height:LongInt;
     T:LongInt;
     Control:TControl;
     {$ENDIF}
Begin
     {$IFDEF Win32}
     If Msg.SizeType = SIZE_MINIMIZED Then
       If (Self Is TFrameControl) And (TFrameControl(Self).Child <> Nil) Then
         TFrameControl(Self).Child.DoChangeActive(False);
     {$ENDIF}

     If Self Is TForm Then
       If TForm(Self).WindowState = wsMinimized Then
         If Not TForm(Self).Designed Then Exit;

     {$IFDEF Win32}
     For T:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[T];
          If Not (Control.FIsToolBar) Then
            If Control.FFirstShow Then
              If Control.FVisible Or Control.Designed Then Control.Show;
     End;
     {$ENDIF}

     {$IFDEF OS2}
     rc:=GetWindowRect;
     FLeft:=rc.Left;
     FBottom:=rc.Bottom;
     FWidth:=Msg.Width;
     FHeight:=Msg.Height;
     If FFrame<>Nil Then
     Begin
          rc:=FFrame.GetWindowRect;
          FFrame.FLeft:=rc.Left;
          FFrame.FBottom:=rc.Bottom;
          FFrame.FWidth:=rc.Right-rc.Left +1;
          FFrame.FHeight:=rc.Top-rc.Bottom +1;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     rc:=GetWindowRect;
     FWidth:=rc.Right-rc.Left +1;
     FHeight:=rc.Top-rc.Bottom +1;

     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
     Begin
          WinUser.GetClientRect(Handle,RECTL(rc1));
          rc:=GetClientRect;
          _Width:=rc.Right-rc.Left+1;
          _Height:=rc.Top-rc.Bottom+1;
          _Left:=rc.Left;
          _Bottom:=((rc1.Top-rc1.Bottom)-_Height)-rc.Bottom;

          WinUser.SetWindowPos(TFrameControl(Self).FChild.Handle,0,
                               _Left,_Bottom,_Width,_Height, SWP_SHOWWINDOW);

          TFrameControl(Self).FChild.RealignControls;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     {If..?} WMMove(TWMMove(Msg));   {track Bottom Frame border}
     {$ENDIF}
     Resize;
End;


Procedure TControl.WMEraseBackGround(Var Msg:TMessage);
Begin
     If Not FOwnerDraw Then Exit;
     {$IFDEF OS2}
     Msg.Result:=0;          {don't Do any Action}
     Msg.Handled:=True;
     {$ENDIF}
     {$IFDEF Win32}
     Msg.Result:=1;
     Msg.Handled:=True;
     {$ENDIF}
End;


Procedure TControl.FontChange;
Begin
     If FOnFontChange <> Nil Then FOnFontChange(Self)
     Else If (Handle <> 0) And IsWindowVisible Then Invalidate;
End;


{$IFDEF OS2}
Function TControl.SetPPFontNameSize(Const FNS:String):Boolean;
Var  CS:Cstring;
Begin
     FUpdatingPP := True;
     CS := FNS;

     Result:=true;
     Result := WinSetPresParam(Handle,PP_FONTNAMESIZE,Length(CS)+1,CS);
     FUpdatingPP := False;

     If FFontChangeEnabled Then FontChange;
End;


Function TControl.SetPPForeGroundColor(AColor:TColor):Boolean;

Begin
// Ab da macht der neue Compiler probleme
  FUpdatingPP := True;
  AColor := SysColorToRGB(AColor);
  Result :=WinSetPresParam(Handle,PP_FOREGROUNDCOLOR,4,AColor);
  FUpdatingPP := False;
End;


Function TControl.SetPPBackGroundColor(AColor:TColor):Boolean;
Begin
  FUpdatingPP := True;
  AColor := SysColorToRGB(AColor);
  Result := WinSetPresParam(Handle,PP_BACKGROUNDCOLOR,4,AColor);
  WinSetPresParam(Handle,PP_DISABLEDBACKGROUNDCOLOR,4,AColor);
  FUpdatingPP := False;
End;


Procedure TControl.WMPresParamChanged(Var Msg:TMessage);
Var  PPid:LongWord;
     cFNS:Cstring;
     FNS:String;
     Size,P:Byte;
     C:Integer;
     aFont:TFont;
     NewColor:TColor;
Begin
     If (Self = Screen.FFontWindow) Or FUpdatingPP Then Exit;

     {drag & drop von der SystemPalette auf Details weiterleiten an Parent}
     If ComponentState * [csDetail] <> [] Then
       If Parent <> Nil Then
       Begin
            Parent.WMPresParamChanged(Msg);
            Exit;
       End;

     PPid := Msg.Param1;
     Case PPid Of
       PP_FONTNAMESIZE:
       Begin
            {wichtig: verwende Msg.Receiver wegen umgeleiteten Nachrichten!}
            WinQueryPresParam(Msg.Receiver{Handle},
                              PPid,
                              0,
                              Nil,
                              SizeOf(cFNS),
                              cFNS,
                              QPF_NOINHERIT);
            FNS := cFNS;
            P := Pos('.',FNS);
            If P = 0 Then Exit;
            Val(Copy(FNS,1,P-1),Size,C);
            If C <> 0 Then Exit;
            Delete(FNS,1,P);

            aFont := Screen.GetFontFromPointSize(FNS,Size);
            If aFont <> Nil Then Font := aFont;
       End;
       PP_FOREGROUNDCOLOR:
       Begin
            {wichtig: verwende Msg.Receiver wegen umgeleiteten Nachrichten!}
            WinQueryPresParam(Msg.Receiver{Handle},
                              PPid,
                              0,
                              Nil,
                              4,
                              NewColor,
                              QPF_NOINHERIT);
            PenColor := NewColor;
       End;
       PP_BACKGROUNDCOLOR:
       Begin
            {wichtig: verwende Msg.Receiver wegen umgeleiteten Nachrichten!}
            WinQueryPresParam(Msg.Receiver{Handle},
                              PPid,
                              0,
                              Nil,
                              4,
                              NewColor,
                              QPF_NOINHERIT);
            color := NewColor;
       End;
     End;
End;
{$ENDIF}


Procedure TControl.WMCommand(Var Msg:TWMCommand);
Var  cmd:TCommand;
     Control:TControl;
     FrameChild:TForm;
     entry:TMenuItem;

{$IFDEF OS2}
     Win:HWindow;
     Button:TControl;
     aMsg:TMessage;
{$ENDIF}

Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     {$IFDEF Win32}
     Control := HandleToControl(Msg.Ctl);
     Try
        If Not (IsControl(Control)) Then Control := Nil;
     Except
        Exit;
     End;
     If Control <> Nil Then Control.ParentNotification(TMessage(Msg));
     If Msg.Handled Then Exit;
     {$ENDIF}

     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil)
     Then Control := TFrameControl(Self).FChild
     Else Control := Self;
     FrameChild := TForm(Control);

     cmd := Msg.ItemId;

     {$IFDEF OS2}
     Case Msg.NotifyCode Of
       CMDSRC_PUSHBUTTON: {internal Button Command = FWindowId}
       Begin
            Win := WinWindowFromID(Handle,cmd);
            Button := HandleToControl(Win);
            If not IsControl(Button) Then Button:=Nil;
            If Button <> Nil Then
            Begin
                 FillChar(aMsg,SizeOf(aMsg),0);
                 {ReceiverClass = 0 -> no Default handler Is called}
                 aMsg.Msg := WM_CONTROL;
                 aMsg.Param1Lo := cmd;
                 aMsg.Param1Hi := BN_CLICKED;
                 Button.ParentNotification(aMsg);    {causes Click!}
                 If aMsg.Handled Then
                 Begin
                      Msg.Handled := True;
                      Exit;
                 End;
            End;
            Exit; {! because kbEsc destroyes the client Window}
       End;
       CMDSRC_MENU: {internal Menu Command}
       Begin
            entry := Application.GetMenuItem(cmd);
            If entry <> Nil Then
            Begin
                 If Not entry.Designed Then entry.Click;
                 Msg.Handled := True;
                 Exit;
            End;
       End;
       CMDSRC_ACCELERATOR: {internal Menu Command Or Real user Command}
       Begin
            entry := Application.GetMenuItem(cmd);
            If entry <> Nil Then
            Begin
                 If Not entry.Designed Then entry.Click;
                 Msg.Handled := True;
                 Exit;
            End;
            {Else - no Special Handling Of user Commands}
       End;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     If (cmd >= cmInternalMenuItemBase) And (cmd < cmUser) Then
     Begin {probably an internal Menu Command}
          entry := Application.GetMenuItem(cmd);
          If entry <> Nil Then
          Begin
               Entry.Click;
               Msg.Handled := True;
               Exit;
          End;
     End;
     {$ENDIF}


     If Not Msg.Handled Then
     Begin
          If FrameChild.OnCommand <> Nil Then FrameChild.OnCommand(FrameChild,cmd);
          If cmd <> cmNull Then FrameChild.CommandEvent(cmd);
          If cmd <> cmNull Then FrameChild.DispatchCommand(Msg,cmd);

          If Not Msg.Handled Then
            If FrameChild Is TForm Then
              If FrameChild.FIsModal
                Then FrameChild.DismissDlg(FrameChild.ModalResult);

          If cmd = cmNull Then Msg.Handled := True;

          If FrameChild <> Self Then Msg.Handled := True; {!!}
     End;
End;


{$HINTS OFF}
Procedure TControl.CommandEvent(Var Command:TCommand);
Begin
     Update;
End;
{$HINTS ON}


{$IFDEF Win32}
Procedure TControl.WMNotify(Var Msg:TMessage);
Var Header:^NMHDR;
    Control:TControl;
Begin
     Header:=Pointer(Msg.Param2);
     If Header=Nil Then Exit;
     Control := HandleToControl(Header^.hwndFrom);
     If not IsControl(Control) Then Control:=Nil;
     If Control<>Nil Then Control.ParentNotification(Msg);
End;
{$ENDIF}

{$IFDEF OS2}
Procedure TControl.WMControl(Var Msg:TMessage);
Var  Win:LongWord;
     Control:TControl;
Begin
     Win := WinWindowFromID(Handle,Msg.Param1Lo);
     Control := HandleToControl(Win);
     If not IsControl(Control) Then Control:=Nil;
     If Control <> Nil Then Control.ParentNotification(Msg);
End;
{$ENDIF}


Function TControl.GetNextTabControl:TControl;
Var  I,idx:LongInt;
     AChild:TControl;
     AParent:TControl;
Begin
     {Try First Child}
     If FTabList <> Nil Then
     For I := 0 To FTabList.Count-1 Do
     Begin
          Result := TControl(FTabList.Items[I]);
          If IsControl(Result) Then
            If Result.Enabled Then
             If Result.CanFocus Then
              If Result.Visible Then Exit; {found}
     End;
     Result := Nil;

     {Try Next sibling}
     AChild := Self;
     While AChild <> Nil Do
     Begin
          AParent := AChild.FParent;
          If AParent = Nil Then Exit;
          If AParent.FTabList = Nil Then Exit;

          idx := AParent.FTabList.IndexOf(AChild);
          If idx < 0 Then Exit; {AChild Is Not In the tab List Of the Parent}
          While idx < AParent.FTabList.Count-1 Do
          Begin
               Result := AParent.FTabList.Items[idx+1];
               If Result.Enabled Then
                If Result.CanFocus Then
                 If Result.Visible Then Exit;
               Inc(idx);
          End;
          Result := Nil;
          {no sibling available}

          If AParent Is TForm Then
          Begin
               Result := AParent.FTabList.First;
               If Result.Enabled Then
                If Result.CanFocus Then
                 If Result.Visible Then Exit;
               Result := Nil;
          End;

          AChild := AParent;   {Try Next sibling Of the Parent}
     End;
End;


Function TControl.GetPrevTabControl:TControl;
Var  I,idx:LongInt;
     AChild:TControl;
     AParent:TControl;
Begin
     {Try Last Child}
     If FTabList <> Nil Then
     For I := FTabList.Count-1 Downto 0 Do
     Begin
          Result := TControl(FTabList.Items[I]);
          If IsControl(Result) Then
            If Result.Enabled Then
             If Result.CanFocus Then
              If Result.Visible Then Exit; {found}
     End;
     Result := Nil;

     {Try Prev sibling}
     AChild := Self;
     While AChild <> Nil Do
     Begin
          AParent := AChild.FParent;
          If AParent = Nil Then Exit;
          If AParent.FTabList = Nil Then Exit;

          idx := AParent.FTabList.IndexOf(AChild);
          If idx < 0 Then Exit; {Self Is Not In the tab List Of the Parent}
          While idx > 0 Do
          Begin
               Result := AParent.FTabList.Items[idx-1];
               If Result.Enabled Then
                If Result.CanFocus Then
                 If Result.Visible Then Exit;
               Dec(idx);
          End;
          Result := Nil;
          {no Prev sibling available}

          If AParent Is TForm Then
          Begin
               Result := AParent.FTabList.Last;
               If Result.Enabled Then
                If Result.CanFocus Then
                 If Result.Visible Then Exit;
               Result := Nil;
          End;

          AChild := AParent;   {Try Next sibling Of the Parent}
     End;
End;


Procedure TControl.FocusTabControl(Next:Boolean);
Var  Control:TControl;
     Last:TControl;
Begin
     Control := Self;
     While True Do
     Begin
          Last := Control;
          If Next Then Control := Last.GetNextTabControl
          Else Control := Last.GetPrevTabControl;

          If IsControl(Control) Then
          Begin
               If Control = Self Then Exit;   {Test Max 1 Round}
               If Control = Last Then Exit;   {Nothing To Do}
               If Control.TabStop Then
               Begin
                    Control.Focus;
                    Exit;
               End;
          End
          Else Exit;
     End;
End;


Procedure TControl.FocusKeyControl(KeyCode:TKeyCode);
Var  Comp:TControl;
     ASelf:TControl;
     AParent:TControl;
     Nearest:TControl;
     I:LongInt;
Begin
     ASelf := Self;
     While ASelf.ComponentState * [csDetail] <> [] Do
     Begin
          If ASelf.Parent = Nil Then Exit;
          ASelf := ASelf.Parent;
     End;
     AParent := ASelf.Parent;
     If AParent = Nil Then Exit;

     Nearest := Nil;
     Case KeyCode Of
       kbCUp:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Left < ASelf.Left + ASelf.Width Then
                           If Comp.Left + Comp.Width > ASelf.Left Then
                             If Comp.Bottom > ASelf.Bottom Then
                               If Nearest <> Nil Then
                                 If Comp.CanFocus Then
                                 Begin
                                      If Comp.Bottom < Nearest.Bottom
                                      Then Nearest := Comp;
                                 End
                                 Else Nearest := Comp;
            End;
       End;
       kbCDown:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Left < ASelf.Left + ASelf.Width Then
                           If Comp.Left + Comp.Width > ASelf.Left Then
                             If Comp.Bottom + Comp.Height < ASelf.Bottom + ASelf.Height Then
                               If Nearest <> Nil Then
                                 If Comp.CanFocus Then
                                 Begin
                                      If Comp.Bottom + Comp.Height >
                                         Nearest.Bottom + Nearest.Height
                                      Then Nearest := Comp;
                                 End
                                 Else Nearest := Comp;
            End;
       End;
       kbCLeft:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Bottom < ASelf.Bottom + ASelf.Height Then
                           If Comp.Bottom + Comp.Height > ASelf.Bottom Then
                             If Comp.Left + Comp.Width < ASelf.Left + ASelf.Width Then
                               If Nearest <> Nil Then
                                 If Comp.CanFocus Then
                                 Begin
                                      If Comp.Left + Comp.Width >
                                        Nearest.Left + Nearest.Width
                                      Then Nearest := Comp;
                                 End
                                 Else Nearest := Comp;
            End;
       End;
       kbCRight:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Bottom < ASelf.Bottom + ASelf.Height Then
                           If Comp.Bottom + Comp.Height > ASelf.Bottom Then
                             If Comp.Left > ASelf.Left Then
                               If Nearest <> Nil Then
                                 If Comp.CanFocus Then
                                 Begin
                                      If Comp.Left < Nearest.Left
                                      Then Nearest := Comp;
                                 End
                                 Else Nearest := Comp;
            End;
       End;
       Else Exit;
     End;
     If Nearest <> Nil Then Nearest.CaptureFocus;
End;


Function TControl.EvaluateShortCut(KeyCode:TKeyCode):Boolean;
Var  Control:TControl;
     I:LongInt;
Begin
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];
          If Control.Enabled Then
            If Control.Visible Then
            Begin
                 Result := Control.EvaluateShortCut(KeyCode);
                 If Result Then Exit; {found}
            End;
     End;
     Result := False;
End;


{$HINTS OFF}
Procedure TControl.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     Case KeyCode Of
       kbTab:
       Begin
            FocusTabControl(True);
            KeyCode := kbNull;
       End;
       kbShiftTab:
       Begin
            FocusTabControl(False);
            KeyCode := kbNull;
       End;
       kbCLeft,kbCRight,kbCUp,kbCDown:
       Begin
            FocusKeyControl(KeyCode);
            KeyCode := kbNull;
       End;
     End;

     {Mnemo}
     If KeyCode And kb_Alt <> 0 Then
       If KeyCode <> kbAlt Then
         If FForm Is TForm Then
           If FForm.EvaluateShortCut(KeyCode) Then KeyCode := kbNull;
End;


Procedure TControl.CharEvent(Var key:Char;RepeatCount:Byte);
Var  KeyCode:TKeyCode;
Begin
  If key = #0 Then Exit;

  {Mnemo}
  If FForm Is TForm Then
    Begin
      KeyCode := {Martin}longword(Ord(key)) + kb_Char + kb_Alt;
      If FForm.EvaluateShortCut(KeyCode) Then key := #0;
    End;
End;
{$HINTS ON}


{$IFDEF OS2}
Procedure TControl.WMHelp(Var Msg:TMessage);
Var  HelpControl:TControl;
Begin
     Msg.Handled := True;

     HelpControl := Self;
     While HelpControl <> Nil Do
     Begin
          If HelpControl.HelpContext <> 0 Then
          Begin
               {Martin}Application.HHelp(HelpControl.HelpContext, HelpControl.HelpContextString);
               exit;
          End;
          HelpControl := HelpControl.Parent;
     End;

     Application.HelpContents;
End;
{$ENDIF}


Procedure TControl.SendScanMessage(Var Msg:TWMChar;Var KeyCode:TKeyCode;RepeatCounT:Byte);
Var  DNS:TDesignerNotifyStruct;
Begin
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil Then
       Begin
            TFrameControl(Self).FChild.SendScanMessage(Msg,KeyCode,RepeatCount);
            Exit;
       End;

     If Designed Then
     Begin
          If FHandlesDesignKey Then
          Begin
               ScanEvent(KeyCode,RepeatCount);

               If KeyCode = kbNull Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
                    Exit;  {Do Not send To Form Window}
               End;
          End;

          DNS.Sender := Self;
          DNS.Code := dncScan;
          DNS.return := 0;
          DNS.keyparam.KeyCode := KeyCode;
          DNS.keyparam.RepeatCount := RepeatCount;
          DesignerNotification(DNS);
          If DNS.return <> 0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
          If OnScan <> Nil Then OnScan(Self,KeyCode);
          If KeyCode <> kbNull Then ScanEvent(KeyCode,RepeatCount);

          If KeyCode = kbNull Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;


Procedure TControl.SendCharMessage(Var Msg:TWMChar;Var CH:Char;RepeatCount:Byte);
Var  DNS:TDesignerNotifyStruct;
     {$IFDEF OS2}
     dbcs:Byte;
     {$ENDIF}
Begin
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil Then
       Begin
            TFrameControl(Self).FChild.SendCharMessage(Msg,CH,RepeatCount);
            Exit;
       End;

     If Designed Then
     Begin
          If FHandlesDesignKey Then
          Begin
               CharEvent(CH,RepeatCount);
               {$IFDEF OS2}
               dbcs := Hi(Msg.CharCode);
               If dbcs > 0 Then CharEvent(Char(dbcs),RepeatCount);
               {$ENDIF}

               If CH = #0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
                    Exit;  {Do Not send To Form Window}
               End;
          End;

          DNS.Sender := Self;
          DNS.Code := dncChar;
          DNS.return := 0;
          DNS.keyparam.KeyCode := Ord(CH);
          DNS.keyparam.RepeatCount := RepeatCount;
          DesignerNotification(DNS);
          If DNS.return <> 0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
          If OnKeyPress <> Nil Then OnKeyPress(Self,CH);
          If CH <> #0 Then CharEvent(CH,RepeatCount);
          {$IFDEF OS2}
          dbcs := Hi(Msg.CharCode);
          If dbcs > 0 Then {Insert the 2nd Byte of the dbcs Char}
          Begin
               If OnKeyPress <> Nil Then OnKeyPress(Self,Char(dbcs));
               If Char(dbcs) <> #0 Then CharEvent(Char(dbcs),RepeatCount);

               If Char(dbcs) = #0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
          {$ENDIF}

          If CH = #0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;


{$IFDEF Win32}
Procedure TControl.WMKeyDown(Var Msg:TMessage);
Var KeyCode:TKeyCode;
    RepeatCount:LongInt;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     KeyCode := Msg.Param1;
     RepeatCount := Msg.Param2 And 15;

     If KeyCode In [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_DELETE,VK_INSERT,
                    VK_END,VK_HOME,VK_NEXT,VK_PRIOR,VK_BACK,VK_RETURN,
                    VK_ESCAPE,VK_CAPITAL,VK_SCROLL,VK_PRINT,VK_CONTROL,
                    VK_MENU,VK_TAB,VK_NUMLOCK,VK_PAUSE,VK_SHIFT,
                    VK_F1..VK_F24] Then
     Begin
          {Real Virtual Code}
          KeyCode := KeyCode Or kb_VK;

          If GetKeyState(VK_CONTROL) < 0 Then KeyCode := KeyCode Or kb_Ctrl;
          If GetKeyState(VK_SHIFT) < 0 Then KeyCode := KeyCode Or kb_Shift;
          If GetKeyState(VK_MENU) < 0 Then KeyCode := KeyCode Or kb_Alt;

          SendScanMessage(TWMChar(Msg),KeyCode,RepeatCount);

          {Send Clicks for dialog buttons}
          If not Msg.Handled Then
            If not (Self Is TForm) Then
              If Form<>Nil Then If KeyCode In [kbEsc,kbCR] Then
                Form.ScanEvent(KeyCode,RepeatCount);

          If KeyCode = kbEsc Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;

          Exit; {!!}
     End;

     {normal key}
     KeyCode := KeyCode Or kb_Char;

     {check whether Control was Pressed}
     If GetKeyState(VK_CONTROL) < 0 Then
     Begin
          KeyCode := KeyCode Or kb_Ctrl;
          If GetKeyState(VK_SHIFT) < 0 Then KeyCode := KeyCode Or kb_Shift;
          If GetKeyState(VK_MENU) < 0 Then KeyCode := KeyCode Or kb_Alt; {enable @ char}

          SendScanMessage(TWMChar(Msg),KeyCode,RepeatCount);
     End;
End;


// called when the user presses ALT and another key
Procedure TControl.WMSysKeyDown(Var Msg:TMessage);
Var KeyCode:TKeyCode;
    RepeatCount:LongInt;
    Receiver:TForm;
Begin
     If Application <> Nil Then Application.DestroyHintWindow;

     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Msg.Result := 0;
          Exit;
     End;

     KeyCode := Msg.Param1;             // the character code
     RepeatCount := Msg.Param2 And 15;

     If KeyCode In [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_DELETE,VK_INSERT,
                    VK_END,VK_HOME,VK_NEXT,VK_PRIOR,VK_BACK,VK_RETURN,
                    VK_ESCAPE,VK_CAPITAL,VK_SCROLL,VK_PRINT,VK_CONTROL,
                    VK_MENU,VK_TAB,VK_NUMLOCK,VK_PAUSE,VK_SHIFT,
                    VK_F1..VK_F24] Then
     Begin
          KeyCode := KeyCode Or kb_VK;     //  needed for kbAltBkSp
     End
     Else
     Begin
          KeyCode := KeyCode Or kb_Char;   // kb_Char is ok
     End;

     If GetKeyState(VK_CONTROL) < 0 Then KeyCode := KeyCode Or kb_Ctrl;
     If GetKeyState(VK_SHIFT) < 0 Then KeyCode := KeyCode Or kb_Shift;
     If GetKeyState(VK_MENU) < 0 Then KeyCode := KeyCode Or kb_Alt;

     If Self Is TForm Then
     Begin
          Receiver := Nil;
          TForm(Self).TranslateShortCut(KeyCode, Receiver);
          If Receiver Is TForm Then 
            If Receiver <> Self Then {prevent recursion}
            Begin
                 Receiver.ForwardShortCut(Msg);
                 exit;
            End;
     End;

     SendScanMessage(TWMChar(Msg),KeyCode,RepeatCount);
End;
{$ENDIF}

Procedure TControl.WMChar(Var Msg:TWMChar);
Var  CH:Char;
     REP:Byte;

{$IFDEF OS2}
Var  Param  : TKeyCode;
     scan   : TKeyCode;
     virtkey: Word;
     ascii  : Word;
     fsFlags:LongWord;{Martin}

Label lsc;
{$ENDIF}
Begin
     If Application <> Nil Then Application.DestroyHintWindow;

     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     fsFlags := Msg.KeyData;
     REP := GetKeyRepeat(TMessage(Msg));
     scan := Msg.ScanCode;
     ascii := Lo(Msg.CharCode);
     virtkey := Msg.VirtualKeyCode;

     If Self Is TFrameControl Then Exit;  {send To client by DefWindowProc}

     If fsFlags And KC_KEYUP <> 0 Then Exit;

     If fsFlags And KC_DEADKEY <> 0 Then  {wait For composite}
     Begin
          FLastDeadKey := ascii;
          Exit;
     End;

     If fsFlags And KC_INVALIDCOMP <> 0 Then
     Begin {invalid composite after deadkey}
          CH := Chr(FLastDeadKey);
          SendCharMessage(Msg,CH,1);
          If fsFlags And KC_CHAR = 0 Then Exit;  {ignore scan Or Virtual key}
     End;

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or (fsFlags And KC_CTRL <> 0) Then Goto lsc;

          If (fsFlags And KC_VIRTUALKEY <> 0) And (fsFlags And KC_SHIFT <> 0)
          Then Goto lsc;    {numerical block}

          CH := Chr(ascii);
          SendCharMessage(Msg,CH,REP);
          Msg.CharCode := Ord(CH)+256*(Msg.CharCode Shr 8);
     End
     Else
     Begin
          // test AltGr+BkSp
          If (fsFlags And KC_VIRTUALKEY <> 0) And
             (fsFlags And KC_SCANCODE <> 0) And
             (virtkey = VK_BACKSPACE) Then fsFlags := fsFlags Or KC_ALT;
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else Param := ascii Or kb_Char;       {E.G. Ctrl-J}

          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;

          SendScanMessage(Msg,Param,REP);
     End;
     {$ENDIF}

     {$IFDEF Win32}
     CH := Chr(Msg.CharCode);

     // Ansi to OEM conversion for ,”,,แ,,,

     If (CH < #32) or (Ch = #127{Backspace key Martin0308}) Then Exit;  {Not printable}

     CH := AnsiToOEMtable[CH];

     REP := Msg.KeyData And 15;

     //If CH < #32 Then Exit;  {hier nicht, sondern vor der Konvertierung Martin0308}

     SendCharMessage(Msg,CH,REP);
     Msg.CharCode := Ord(CH);
     {$ENDIF}

     Try {maybe Self Is destroyed}
        If Self Is TForm Then Msg.Handled := True; {don't Dispatch it further}
     Except
        Msg.Handled := True;
     End;
End;




{$IFDEF OS2}
Procedure TControl.WMQueryConvertPos(Var Msg:TMessage);
Var  prec:PRect;
     pt:TPoint;
Begin
     If FStandardControl Then Exit;

     {Param1 Points To A Rectangle}
     prec := PRect(Msg.Param1);

     pt.X := -1;
     pt.Y := -1;
     If QueryConvertPos(pt) Then
     Begin
          prec^.Left := pt.X;
          prec^.Bottom := pt.Y;
          prec^.Right := 0;
          prec^.Top := 0;
          Msg.Result := QCP_CONVERT;
     End
     Else Msg.Result := QCP_NOCONVERT;
     Msg.Handled := True;
End;
{$ENDIF}


{$HINTS OFF}
Function TControl.QueryConvertPos(Var Pos:TPoint):Boolean;
Begin
     Result := True; {Use Standard Position}
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TControl.Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LOnGint);
Begin
End;
{$HINTS ON}


Procedure TControl.WMHScroll(Var Msg:TWMScroll);
Var  target:TControl;
     ScrollBar:TScrollBar;
     ScrollCode:TScrollCode;
     ScrollPos:LongInt;
     {$IFDEF OS2}
     Win:LongWord;
     {$ENDIF}
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     target := Self;
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil
       Then target := TFrameControl(Self).FChild;

     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.ScrollBarId);
     ScrollBar := TScrollBar(HandleToControl(Win));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINERIGHT:
         Begin
              ScrollCode := scColumnRight;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_LINELEFT:
         Begin
              ScrollCode := scColumnLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_PAGERIGHT:
         Begin
              ScrollCode := scPageRight;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_PAGELEFT:
         Begin
              ScrollCode := scPageLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_SLIDERTRACK:
         Begin
              ScrollCode := scHorzTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_SLIDERPOSITION:
         Begin
              ScrollCode := scHorzPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scHorzEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
     End; {Case}
     {$ENDIF}

     {$IFDEF Win32}
     ScrollBar := TScrollBar(HandleToControl(Msg.ScrollBar));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINERIGHT:
         Begin
              ScrollCode := scColumnRight;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_LINELEFT:
         Begin
              ScrollCode := scColumnLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_PAGERIGHT:
         Begin
              ScrollCode := scPageRight;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_PAGELEFT:
         Begin
              ScrollCode := scPageLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_THUMBTRACK:
         Begin
              ScrollCode := scHorzTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_THUMBPOSITION:
         Begin
              ScrollCode := scHorzPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scHorzEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
         SB_BOTTOM: Exit;
         SB_TOP: Exit;
     End;
     {$ENDIF}

     If ScrollPos < ScrollBar.Min Then ScrollPos := ScrollBar.Min;
     If ScrollPos > ScrollBar.FCalcRange Then ScrollPos := ScrollBar.FCalcRange;

     If ScrollCode <> scHorzEndScroll Then
       If ScrollCode <> scHorzPosition Then
         If ScrollPos = ScrollBar.Position Then Exit;

     Target.Scroll(ScrollBar,ScrollCode,ScrollPos);
     If ScrollBar.OnScroll <> Nil
     Then ScrollBar.OnScroll(ScrollBar,ScrollCode,ScrollPos);

     ScrollBar.Position := ScrollPos; {Set the final Position}

     If ScrollBar.FOnChange<>Nil Then ScrollBar.FOnChange(Self);

     Msg.Handled := True; {!!}
     Msg.Result := 0;
End;


Procedure TControl.WMVScroll(Var Msg:TWMScroll);
Var  target:TControl;
     ScrollBar:TScrollBar;
     ScrollCode:TScrollCode;
     ScrollPos:LongInt;
     {$IFDEF OS2}
     Win:LongWord;
     {$ENDIF}
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     target := Self;
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil
       Then target := TFrameControl(Self).FChild;

     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.ScrollBarId);
     ScrollBar := TScrollBar(HandleToControl(Win));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINEUP:
         Begin
              ScrollCode := scLineUp;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_LINEDOWN:
         Begin
              ScrollCode := scLineDown;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_PAGEUP:
         Begin
              ScrollCode := scPageUp;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_PAGEDOWN:
         Begin
              ScrollCode := scPageDown;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_SLIDERTRACK:
         Begin
              ScrollCode := scVertTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_SLIDERPOSITION:
         Begin
              ScrollCode := scVertPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scVertEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
     End; {Case}
     {$ENDIF}

     {$IFDEF Win32}
     ScrollBar := TScrollBar(HandleToControl(Msg.ScrollBar));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINEUP:
         Begin
              ScrollCode := scLineUp;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_LINEDOWN:
         Begin
              ScrollCode := scLineDown;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_PAGEUP:
         Begin
              ScrollCode := scPageUp;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_PAGEDOWN:
         Begin
              ScrollCode := scPageDown;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_THUMBTRACK:
         Begin
              ScrollCode := scVertTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_THUMBPOSITION:
         Begin
              ScrollCode := scVertPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scVertEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
         SB_BOTTOM: Exit;
         SB_TOP: Exit;
     End;
     {$ENDIF}

     If ScrollPos < ScrollBar.Min Then ScrollPos := ScrollBar.Min;
     If ScrollPos > ScrollBar.FCalcRange Then ScrollPos := ScrollBar.FCalcRange;

     If ScrollCode <> scVertEndScroll Then
       If ScrollCode <> scVertPosition Then
         If ScrollPos = ScrollBar.Position Then Exit;

     target.Scroll(ScrollBar,ScrollCode,ScrollPos);
     If ScrollBar.OnScroll <> Nil
     Then ScrollBar.OnScroll(ScrollBar,ScrollCode,ScrollPos);

     ScrollBar.Position := ScrollPos; {Set the final Position}

     If ScrollBar.FOnChange<>Nil Then ScrollBar.FOnChange(Self);

     Msg.Handled := True; {!!}
     Msg.Result := 0;
End;

                     
{$IFDEF Win32}
Procedure TControl.SetCtlColor(Var Msg:TMessage);
Var  Control:TControl;
Begin
     Control := HandleToControl(Msg.Param2); {Get VMT Pointer}
     If IsControl(Control) Then
     Begin
          WinGDI.SetTextColor(Msg.Param1,
                              RGBToWinColor(SysColorToRGB(Control.PenColor)));
          WinGDI.SetBkColor(Msg.Param1,
                            RGBToWinColor(SysColorToRGB(Control.color)));
          Msg.Result := Control.FCtlBrush;
     End
     Else {Set Standard}
     Begin
          WinGDI.SetTextColor(Msg.Param1,
                              RGBToWinColor(SysColorToRGB(PenColor)));
          WinGDI.SetBkColor(Msg.Param1,
                            RGBToWinColor(SysColorToRGB(color)));
          Msg.Result := FCtlBrush;
     End;
     Msg.Handled := True;
End;


Procedure TControl.WMCtlColorBtn(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorEdit(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorListBox(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorStatic(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorDlg(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorScrollBar(Var Msg:TMessage);
Var  Control:TControl;
Begin
     Control := HandleToControl(Msg.Param2); {VMT Pointer}
     If IsControl(Control) Then
       If Control.color = clScrollbar Then Exit;      {DefWndProc!}
       {dont Change Default brush! (Pattern will Get lost)}

     SetCtlColor(Msg);
End;
{$ENDIF}


{captive = True -> Capture ON}
Procedure TControl.SetMouseCapture(captive:Boolean);
Begin
     If Handle = 0 Then Exit;
     FMouseCapture := captive;
     {$IFDEF OS2}
     If captive Then WinSetCapture(HWND_DESKTOP,Handle)
     Else WinSetCapture(HWND_DESKTOP,0);
     {$ENDIF}
     {$IFDEF Win32}
     If captive Then SetCapture(Handle)
     Else ReleaseCapture;
     {$ENDIF}
End;


{$HINTS OFF}
Procedure TControl.WMCaptureFocus(Var Msg:TMessage);
Begin
     Focus;
End;
{$HINTS ON}


Function TControl.CanFocus:Boolean;
Begin
  Result:=True;
End;


Procedure TControl.Focus;
Begin
  If IsControlLocked(Self) Or (not CanFocus) Then Exit;

  If Handle <> 0 Then
    Begin
      {$IFDEF OS2}
      WinSetFocus(HWND_DESKTOP,Handle);
      {$ENDIF}
      {$IFDEF Win32}
      WinUser.SetFocus(Handle);
      {$ENDIF}
    End;
End;


{Use This Function within SetFocus notify method To redirect the Focus}
{Otherwise Is it Not possible To Change the Focus}
Procedure TControl.CaptureFocus;
Begin
  If not CanFocus Then exit;

  If Handle <> 0
    Then PostMsg(Handle,WM_CAPTUREFOCUS,0,0)
    Else Focus;
End;


Function TControl.Focused:Boolean;
Begin
  Result := FHasFocus;
End;


Function TControl.GetEnabled:Boolean;
Begin
  {$IFDEF OS2}
  If (Handle = 0) Or Designed
    Then Result := FEnabled
    Else Result := WinIsWindowEnabled(Handle);
  {$ENDIF}
  {$IFDEF Win32}
  If (Handle = 0) Or Designed
    Then Result := FEnabled
    Else Result := IsWindowEnabled(Handle);
  {$ENDIF}
End;


Procedure TControl.SetEnabled(NewState:Boolean);
Var  i:LongInt;
Begin
  FEnabled := NewState;
  If (Handle = 0) Or Designed Then
    Begin
      If Handle<>0 Then Invalidate;
      Exit;
    End;

  For i := 0 To ControlCount-1 Do
    Controls[i].Enabled := FEnabled;

  If FEnabled
    Then Enable
    Else Disable;
End;

Procedure TControl.Enable;
Begin
  If Handle = 0 Then Exit;
  {$IFDEF OS2}
  If FFrame <> Nil
    Then WinEnableWindow(FFrame.Handle,True)
    Else WinEnableWindow(Handle,True);
  {$ENDIF}
  {$IFDEF Win32}
  If FFrame <> Nil
    Then EnableWindow(FFrame.Handle,True)
    Else EnableWindow(Handle,True);
  If not ((Self Is TForm) Or (Self Is TFrameControl))
    Then Invalidate;
  {$ENDIF}
End;

Procedure TControl.Disable;
Begin
  If Handle = 0 Then Exit;
  {$IFDEF OS2}
  If FFrame <> Nil
    Then WinEnableWindow(FFrame.Handle,False)
    Else WinEnableWindow(Handle,False);
  {$ENDIF}
  {$IFDEF Win32}
  If FFrame <> Nil
    Then EnableWindow(FFrame.Handle,False)
    Else EnableWindow(Handle,False);
  If not ((Self Is TForm)Or(Self Is TFrameControl))
    Then Invalidate;
  {$ENDIF}
End;


Function TControl.IsWindowVisible:Boolean;
Begin
     {$IFDEF OS2}
     If FFrame <> Nil Then Result := WinIsWindowVisible(FFrame.Handle)
     Else Result := WinIsWindowVisible(Handle);
     {$ENDIF}
     {$IFDEF Win32}
     If FFrame <> Nil Then Result := WinUser.IsWindowVisible(FFrame.Handle)
     Else Result := WinUser.IsWindowVisible(Handle);
     {$ENDIF}
End;


Function TControl.GetShowing;
Begin
     If Handle=0 Then Result:=False
     Else Result:=GetVisible;
End;


Function TControl.GetVisible:Boolean;
Begin
     If (Handle = 0) Or Designed Then Result := FVisible
     Else Result := IsWindowVisible;
End;


Procedure TControl.SetVisible(NewState:Boolean);
Begin
     If NewState Then
     Begin
          FVisible := True;
          If (Handle = 0) Or Designed Then Exit;
          Show;
     End
     Else
     Begin
          FVisible := False;
          If (Handle = 0) Or Designed Then Exit;
          Hide;
     End;
End;


Function TControl.GetTabOrder:LongInt;
Begin
     Result := -1;
     If FParent <> Nil Then
       If FParent.FTabList <> Nil
       Then Result := FParent.FTabList.IndexOf(Self);
End;


Procedure TControl.SetTabOrder(Value:LongInt);
Var  idx:LongInt;
     ACount:LongInt;
Begin
     If Value < 0 Then Exit;

     If ComponentState * [csReading] <> [] Then
     Begin
          FTabOrder := Value;
          Exit;
     End;

     If FParent <> Nil Then
       If FParent.FTabList <> Nil Then
       Begin
            ACount := FParent.FTabList.Count;
            If Value >= ACount Then Value := ACount - 1;
            idx := FParent.FTabList.IndexOf(Self);
            If idx >= 0 Then FParent.FTabList.Move(idx,Value);
       End;
End;

Procedure TControl.LoadedFromSCU(SCUParent:TComponent);
Var  Control:TControl;
     NewList:TList;
     I:LongInt;
     ControlTabOrder:LongInt;
Begin
     Inherited LoadedFromSCU(SCUParent);

     If IsControl(TControl(SCUParent)) Then SetParent(TControl(SCUParent));

     {Update Special Alignment, Parent Is Valid now}
     If Align In [alFrame,alScale,alFixedRightBottom,
                  alFixedRightTop,alFixedLeftTop] Then SetAlign(Align);

     {reorder the tablist}
     If FTabList = Nil Then Exit;
     If FTabList.Count < 2 Then Exit; {Nothing To Do}

     NewList.Create;
     NewList.Count := FTabList.Count; {Fill With Nil}
     For I := 0 To FTabList.Count-1 Do
     Begin
          Control := FTabList.Items[I];
          If Not (IsControl(Control)) Then continue;
          If Control.ComponentState * [csLoaded] <> []
          Then ControlTabOrder := Control.FTabOrder
          Else ControlTabOrder := I;

          If ControlTabOrder < 0 Then continue; {was Not In the list?}
          If ControlTabOrder >= FTabList.Count Then continue;

          NewList.Items[ControlTabOrder] := Control;
     End;

     NewList.Pack; {Remove NILs}
     FTabList.Destroy;
     FTabList := NewList;
End;


Procedure TControl.Redraw(Const rec:TRect);
Begin
  If FCanvas = Nil Then Exit;
  FCanvas.FillRect(rec,color);
End;


Procedure TControl.Refresh;
Begin
  Invalidate;
  Update;
End;


Procedure TControl.Repaint;
Begin
  Refresh;
End;


Procedure TControl.Update;
Begin
  If Handle = 0 Then Exit;
  If Not FUpdateEnabled Then Exit;
  {$IFDEF OS2}
  WinUpdateWindow(Handle);
  {$ENDIF}
  {$IFDEF Win32}
  WinUser.UpdateWindow(Handle);
  {$ENDIF}
End;


Procedure TControl.Invalidate;
{$IFDEF WIN32}
Var t:LongInt;
{$ENDIF}
Begin
  If Handle = 0 Then Exit;
  If Not FUpdateEnabled Then Exit;
  If FCanvas <> Nil Then FCanvas.DeleteClipRegion;
  If Application<>Nil Then Application.DestroyHintWindow;

  {$IFDEF OS2}
  WinInvalidateRect(Handle,Nil,True);
  {$ENDIF}
  {$IFDEF Win32}
  WinUser.InvalidateRect(Handle,Nil,True);
  For t:=0 To ControlCount-1 Do
    Controls[t].Invalidate;
  {$ENDIF}
End;


Procedure TControl.InvalidateRect(Const rec:TRect);
Var  rc:TRect;
Begin
  If Handle = 0 Then Exit;
  If Not FUpdateEnabled Then Exit;
  If Application<>Nil Then Application.DestroyHintWindow;

  rc := rec;
  {$IFDEF OS2}
  WinInvalidateRect(Handle,RECTL(rc),True);
  {$ENDIF}
  {$IFDEF Win32}
  inc(rc.Right);
  dec(rc.Bottom);
  RectToWin32Rect(rc);
  TransformClientRect(rc,Self);
  WinUser.InvalidateRect(Handle,RECTL(rc),True);
  {$ENDIF}
End;


Function TControl.Perform(MsgId:ULONG;mp1,mp2:LONG):LONG;
Var  Msg:TMessage;
Begin
     FillChar(Msg,SizeOf(Msg),0);
     Msg.Msg := MsgId;
     Msg.ReceiverClass := Self;
     Msg.Receiver := Handle;
     Msg.Handled := False;
     Msg.Param1 := mp1;
     Msg.Param2 := mp2;
     Msg.Result := 0;
     If Self <> Nil Then WndProc(Msg);
     Result := Msg.Result;
End;


Procedure TControl.NotifyControls(MsgId:ULONG);
Var  Msg:TMessage;
Begin
     Msg.Msg := MsgId;
     Msg.ReceiverClass := Self;
     Msg.Receiver := Handle;
     Msg.Handled := False;
     Msg.Param1 := 0;
     Msg.Param1 := 0;
     Msg.Result := 0;
     BroadCast(Msg);
End;


Procedure TControl.BroadCast(Var Msg:TMessage);
Var  I:LongInt;
     Control:TControl;
Begin
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];
          Msg.Receiver := Control.Handle;  //!!!
          Control.WndProc(Msg);
          If Msg.Result <> 0 Then Exit;
     End;
End;


Procedure TControl.GetChildren(Proc:TGetChildProc);
Var  T:LongInt;
     Child:TComponent;
     Control:TControl;
Begin
     Inherited GetChildren(Proc);

     If ComponentState * [csReference] = [] Then
     Begin
          For T := 0 To ControlCount-1 Do
          Begin
               Control := Controls[T];
               If Control.Designed Then
                 If Control.ComponentState * [csDetail,csReference] = [] Then
                 Begin
                      Proc(Control);
                 End;
          End;

          For T := 0 To ComponentCount-1 Do
          Begin
               Child := Components[T];
               If Child.Designed Then
                 If (Not Child.HasParent) Then
                   If Child.ComponentState *
                      [csDetail,csReference,csReferenceControl] = [] Then
                   Begin
                        Proc(Child);
                   End;
          End;
     End;
End;


Function TControl.HasParent:Boolean;
Begin
     Result := Parent <> Nil;
End;


Procedure TControl.SetHint(Const NewText:String);
Begin
     AssignStr(FHint,NewText);
End;


Function TControl.GetHint:String;
Begin
     If FHint = Nil Then Result := ''
     Else Result := FHint^;
End;


Procedure TControl.SetShowHint(Value:Boolean);
Begin
     If FShowHint <> Value Then
     Begin
          FShowHint := Value;
          If ComponentState * [csReading] = [] Then FParentShowHint := False;
     End;
End;


Function TControl.GetShowHint:Boolean; {internal used}
Begin
     If FParentShowHint Then
     Begin
          If Parent <> Nil Then Result := Parent.GetShowHint
          Else Result := FShowHint;
     End
     Else Result := FShowHint;
End;

Type TConstraints=Record
                       FMinW,FMinH,FMaxW,FMaxH:LongInt;
     End;                  

Procedure TControl.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnFont Then
     Begin
          If DataLen <> 0 Then
          Begin
               Font := ReadSCUFont(Data,DataLen);
               If ((Font<>Nil)And(TControlFont(Font).AlternateName<>Nil)) Then
               Begin
                   AssignStr(FAlternateFontName,TControlFont(Font).AlternateName^);
                   DisposeStr(TControlFont(Font).AlternateName);
                   TControlFont(Font).AlternateName:=Nil;
               End;
          End;
     End
     Else If ResName=rnConstraints Then
     Begin
          Constraints.FMinWidth:=TConstraints(Data).FMinW;
          Constraints.FMaxWidth:=TConstraints(Data).FMaxW;
          Constraints.FMinHeight:=TConstraints(Data).FMinH;
          Constraints.FMaxHeight:=TConstraints(Data).FMaxH;
          Constraints.Change;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TControl.WriteSCUResource(Stream:TResourceStream):Boolean;
Var c:TConstraints;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If (Font <> Nil) And (ComponentState * [csDetail] = [])
     Then
     Begin
          DisposeStr(TControlFont(Font).AlternateName);
          TControlFont(Font).AlternateName:=FAlternateFontName;
          Result := Font.WriteSCUResourceName(Stream,rnFont);
          TControlFont(Font).AlternateName:=Nil;
     End;

     c.FMinW:=Constraints.MinWidth;
     c.FMaxW:=Constraints.MaxWidth;
     c.FMinH:=Constraints.MinHeight;
     c.FMaxH:=Constraints.MaxHeight;
     If ((c.FMinW<>0)Or(c.FMaxW<>MaxInt)Or(c.FMinH<>0)Or(c.FMaxH<>MaxInt)) Then
       Result:=Stream.NewResourceEntry(rnConstraints,c,sizeof(TConstraints));
End;

Procedure TControl.WriteInfoToINI(InfoLine : String);

Var CntrlInfo: String;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiLoadFormINI]) or
     (SaveLoadInfo=false) then exit;

  CntrlInfo:= TagINI_Control + fFont.FaceName+ ';' +
                            tostr(fFont.PointSize) + ';' +
                            tostr(fColor) + ';' +
                            toStr(fPenColor) +
              TagINI_End + InfoLine;     //; + iif(InfoLine='','',';'+InfoLine);
  inherited WriteInfoToINI(CntrlInfo);
End;

Function TControl.ReadInfoFromINI : String;

var TagInfoList: tStringList;
    FontName   : String;
    FontSize   : LongInt;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiSaveToINI]) or
     (SaveLoadInfo=false) then exit;

  result:=inherited ReadInfoFromINI;
  if result='' then exit;

  TagInfoList.Create;
  Result:=getInfoTag(TagINI_Control, result, TagInfoList);

  try
    FontName := TagInfoList.Strings[0];
    FontSize := StrToInt(TagInfoList.Strings[1]);

    FFont := Screen.GetFontFromPointSize(FontName, FontSize);
    fColor:=StrToInt(TagInfoList.Strings[2]);
    fPenColor:=StrToInt(TagInfoList.Strings[3]);
  except
  end;

  TagInfoList.Destroy;

End;

Procedure TControl.DoStartDrag(Var DragData:TDragDropData);
Begin
     With DragData Do
     Begin
          SourceWindow := Handle;
          SourceType := drtSibylObject;
          SourceString:='';
          RenderType := drmSibylObject;
          RenderString:='';
          SourceFileName := '';
          TargetFileName := '';
          ContainerName := '';
          SupportedOps := [doCopyable,doMoveable,doLinkable];
          DragOperation := doDefault;
          ItemId := LongWord(Self);
     End;

     If FOnStartDrag <> Nil Then FOnStartDrag(Self,DragData);
End;


{$IFDEF OS2}
Function FlagsFromDragSupport(SupportedOps:TDragDropSupportedOps):LongWord;
Begin
     Result := 0;
     If SupportedOps * [doCopyable] <> [] Then Result := Result Or DO_COPYABLE;
     If SupportedOps * [doMoveable] <> [] Then Result := Result Or DO_MOVEABLE;
     If SupportedOps * [doLinkable] <> [] Then Result := Result Or DO_LINKABLE;
End;


Function DragSupportFromFlags(Flags:LongWord):TDragDropSupportedOps;
Begin
     Result := [];
     If Flags And DO_COPYABLE <> 0 Then Include(Result, doCopyable);
     If Flags And DO_MOVEABLE <> 0 Then Include(Result, doMoveable);
     If Flags And DO_LINKABLE <> 0 Then Include(Result, doLinkable);
End;


Function FlagFromDragOperation(Operation:TDragDropOperation):LongWord;
Const
    DragOps:Array[TDragDropOperation] Of LongWord=
        (DO_DEFAULT,DO_COPY,DO_MOVE,DO_LINK,DO_UNKNOWN);
Begin
     Result := DragOps[Operation];
End;


Function DragOperationFromFlag(flag:LongWord):TDragDropOperation;
Begin
     Case flag Of
       DO_DEFAULT: Result := doDefault;
       DO_COPY: Result := doCopy;
       DO_MOVE: Result := doMove;
       DO_LINK: Result := doLink;
       Else Result := doUnknown;
     End;
End;
{$ENDIF}

{$HINTS OFF}
Procedure TControl.BeginDrag(Immediate:Boolean); {zZ dummy Parameter}
{$IFDEF OS2}
Var DItem:DRAGITEM;
    DImg:DRAGIMAGE;
    apsz:Cstring;
    hwndDrop:HWND;
    DrgData:TDragDropData;
    RMF:Cstring;
    Typ:Cstring;
    ContainerName,SourceName,TargetName:LongWord;
    DragControl:TControl;
    Accepted:Boolean;
    pt:TPoint;
    apid,adrgpid:PID;
    atid,adrgtid:TID;
{$ENDIF}
Begin
     {$IFDEF OS2}
     {Do Not allow drag inside Of drag}
     If ((Form.FDragControl<>Nil)Or(Form.FDragInfo<>Nil)) Then Exit;
     Form.FDragControl:=Self;
     Form.FDragControl.FDragging:=True;

     //allocate drag Info With one DRAGITEM
     Form.FDragInfo:=DrgAllocDragInfo(1);

     DoStartDrag(DrgData);

     Form.FDragInfo^.usOperation := FlagFromDragOperation(DrgData.DragOperation);

     Case DrgData.RenderType Of
        drmSibylObject:
        Begin
             Typ:='DRT_SIBYLOBJECT'+tohex(AppHandle);
             RMF:='<DRM_SIBYLOBJECT'+tohex(AppHandle)+',DRF_SIBYLOBJECT'+tohex(AppHaNdle)+'>';
        End;
        drmFile, drmSibylFile,
        drmPrint, drmSibyl, drmString:
        Begin
             If DrgData.SourceType=drtString Then Typ:=DrgData.SourceString
             Else If DrgData.SourceType=drtText Then Typ:='DRT_TEXT'
             Else If DrgData.SourceType=drtSibyl Then Typ:='DRT_SIBYL'
             Else Typ:='DRT_BINDATA';

             If DrgData.RenderType=drmString Then RMF:='<'+DrgData.RenderString+','
             Else If DrgData.RenderType=drmPrint Then RMF:='<DRM_PRINT,'
             Else If DrgData.RenderType=drmSibyl Then RMF:='<DRM_SIBYL,'
             Else RMF:='<DRM_OS2FILE,';
             If DrgData.SourceType=drtText Then RMF:=RMF+'DRF_TEXT>'
             Else RMF:=RMF+'DRF_UNKNOWN>';
        End;
     End;

     If DrgData.ContainerName<>'' Then
     Begin
          apsz:=DrgData.ContainerName;
          ContainerName:=DrgAddStrHandle(apsz);
     End
     Else ContainerName:=0;
     If DrgData.SourceFileName<>'' Then
     Begin
          apsz:=DrgData.SourceFileName;
          SourceName:=DrgAddStrHandle(apsz);
     End
     Else SourceName:=0;
     If DrgData.TargetFileName<>'' Then
     Begin
          apsz:=DrgData.TargetFileName;
          TargetName:=DrgAddStrHandle(apsz);
     End
     Else TargetName:=0;

     //Setup DRAGITEM structure
     DItem.hwndItem:=Handle;
     DItem.ulItemID:=DrgData.ItemId;
     DItem.hstrType:=DrgAddStrHandle(Typ);
     DItem.hstrRMF:=DrgAddStrHandle(RMF);
     DItem.hstrContainerName:=ContainerName;
     DItem.hstrSourceName:=SourceName;
     DItem.hstrTargetName:=TargetName;
     DItem.cxOffset:=0;
     DItem.cyOffset:=0;
     DItem.fsControl:=0;
     DItem.fsSupportedOps:=FlagsFromDragSupport(DrgData.SupportedOps);

     //Set First drag Item (Index 0)
     DrgSetDragItem(Form.FDragInfo^,DItem,SizeOf(DRAGITEM),0);

      //initialize DRAGIMAGE structure
     DImg.cb:=SizeOf(DRAGIMAGE);
     DImg.cptl:=0;
     DImg.hImage:=Screen.Cursors[DragCursor];
     DImg.sizlStretch.CX:=20;
     DImg.sizlStretch.CY:=20;
     DImg.fl:=DRG_ICON {Or DRG_STRETCH};
     DImg.cxOffset:=0;
     DImg.cyOffset:=0;

     //Perform drag Operation
     hwndDrop:=DrgDrag(Handle,Form.FDragInfo^,DImg,1,VK_ENDDRAG,Nil);
     {DrgDrag returns If drag Operation Is completed}

     (* Store final drag Operation *)
     FLastDragOperation:=DragOperationFromFlag(Form.FDragInfo^.usOperation);

     WinQueryWindowProcess(Handle,apid,atid);
     WinQueryWindowProcess(hwndDrop,adrgpid,adrgtid);
     If apid=adrgpid
       then DragControl:=HandleToControl(hwndDrop) //the same Application
       Else DragControl:=Nil;                      //other Application

     pt:=Screen.MousePos;
     Accepted:=hwndDrop<>0;

     If Not Accepted Then
     Begin
          FLastDragOperation:=doUnknown;
          DragControl:=Nil;
     End
     Else If DragControl=Nil Then DragControl:=TControl(ExternalDragDropObject);

     DragFinished(DragControl, pt.X,pt.Y, Accepted);
     {$ENDIF}

     {$IFDEF Win32}
     DoStartDrag(WinDragDropData);
     Case WinDragDropData.RenderType Of
        drmSibylObject,drmSibyl,drmSibylFile:
        Begin
             WinDragControl:=Self;
             FDragState:=dsDragEnter;
             WinLastDrag:=Nil;
             MouseCapture:=True;
             WinDragControl.FDragCursor:=Screen.Cursors[crDrag];
             WinUser.SetCursor(WinDragControl.FDragCursor);
        End;
        Else
          Begin
            WinDragControl:=Nil;
          End;
     End; //Case
     {$ENDIF}
End;
{$HINTS ON}

Procedure TControl.DragFree;
Begin
     {$IFDEF Win32}
     WinDragControl:=Nil;
     MouseCapture:=False;
     WinUser.SetCursor(Screen.Cursors[Cursor]);
     {$ENDIF}
     {$IFDEF OS2}
     If Form.FDragControl=Nil Then Exit;  //no previous drag
     Form.FDragControl.FDragging:=False;
     Form.FDragControl.FDragState:=dsDragEnter;

     //Free DragInfo structure
     DrgDeleteDragInfoStrHandles(Form.FDragInfo^);
     DrgFreeDragInfo(Form.FDragInfo);
     Form.FDragInfo:=Nil;
     {$ENDIF}
     Form.FDragControl:=Nil;
End;


Procedure TControl.DragFinished(target:TObject; X,Y:LongInt; Accepted:Boolean);
Begin
     If Not Accepted Then DragCanceled;
     DoEndDrag(target, X,Y);

     DragFree;
End;


Procedure TControl.CanDrag(X,Y:LongInt;Var Accept:Boolean);
Begin
     If OnCanDrag <> Nil Then OnCanDrag(Self,X,Y,Accept);
End;


Procedure TControl.DoEndDrag(target:TObject; X,Y:LongInt);
Begin
     {target Koord. aufbereiten}
     If FOnEndDrag <> Nil Then FOnEndDrag(Self, target, X,Y);
End;


Procedure TControl.DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:BOolean);
Begin
  Accept := True;
  If OnDragOver = Nil
    Then Accept := False
    Else OnDragOver(Self,Source,X,Y,State,Accept);
End;


Procedure TControl.DragDrop(Source:TObject;X,Y:LongInt);
Begin
     If OnDragDrop <> Nil Then OnDragDrop(Self,Source,X,Y);
End;


Procedure TControl.DragCanceled;
Begin
End;


Procedure TControl.CreateDragCanvas;
Begin
     {$IFDEF OS2}
     FDragCanvas:=FCanvas;
     FCanvas.Create(Self);
     FCanvas.Handle:=DrgGetPS(Handle);
     GpiCreateLogColorTable(FCanvas.Handle,LCOL_RESET,LCOLF_RGB,0,0,Nil);

     //FCanvas.Font := FDragCanvas.Font; !!

     FCanvas.Pen.color:=clBlack;
     FCanvas.Brush.color:=clWhite;
     FCanvas.Brush.Mode:=bmOpaque;
     FCanvas.Pen.Mode:=pmCopy;
     {$ENDIF}
End;


Procedure TControl.DeleteDragCanvas;
Begin
     {$IFDEF OS2}
     DrgReleasePS(FCanvas.Handle);
     FCanvas.Handle:=0;
     FCanvas.Destroy;
     FCanvas:=FDragCanvas;
     {$ENDIF}
End;


{$IFDEF OS2}
Procedure TControl.WMBeginDrag(Var Msg:TMessage);
Begin
     DragInit(Self, MausPosFromParam(Msg.Param1));

     Msg.Handled:=True;
     Msg.Result:=1;
End;

Procedure TControl.WMEndDrag(Var Msg:TMessage);
Var  pt:TPoint;
Begin
     If FDragMode=dmAutomatic Then
     Begin
          pt:=Screen.MousePos;
          DragFinished(Nil,pt.X,pt.Y,False);
     End;
     Msg.Handled:=True;
     Msg.Result:=1;
End;

Function GetDragSource(Var Msg:TMessage;Var DragInfo:PDRAGINFO;
                       Var DragDropData:TDragDropData;Var DragSource:TObject;
                       ItemIndex:LongInt):Boolean;
Var
   DRAGITEM:PDragItem;
   apsz:Cstring;
   flResult:Boolean;
Label ex;
Begin
     Result:=False;
     DragSource:=Nil;
     DragInfo:=Pointer(Msg.Param1);
     If Not DrgAccessDragInfo(DragInfo) Then Exit;
     If DragInfo^.cdItem=0 Then Goto ex;
     DRAGITEM:=DrgQueryDragitemPtr(DragInfo^,ItemIndex);
     If DRAGITEM=Nil Then Goto ex;

     FillChar(DragDropData,SizeOf(DragDropData),0);
     DragDropData.SourceWindow:=DragInfo^.HwndSource;
     apsz:='DRT_SIBYLOBJECT'+tohex(AppHandle);
     flResult:=DrgVerifyTrueType(DRAGITEM^,apsz);
     If flResult Then
     Begin
          DragSource:=TObject(DRAGITEM^.ulItemID);
          With DragDropData Do
          Begin
               SourceType:=drtSibylObject;
               RenderType:=drmSibylObject;
               DragSource:=TControl(DRAGITEM^.ulItemID);
          End;
     End
     Else
     Begin
          apsz:='DRT_SIBYL';
          DragDropData.SourceString:=apsz;
          flResult:=DrgVerifyTrueType(DRAGITEM^,apsz);
          If flResult Then
          Begin
               With DragDropData Do
               Begin
                   SourceType:=drtSibyl;
                   RenderType:=drmSibyl;
                   DragDropData.RenderString:='DRM_SIBYL';
               End;
          End
          Else
          Begin
               flResult:=DrgQueryNativeRMF(DRAGITEM^,255,apsz);
               DragDropData.RenderString:=apsz;
               If ((flResult)And(Pos('DRM_OS2FILE',apsz) <> 0)) Then
               Begin
                    DragDropData.RenderType:=drmFile;
                    apsz:='DRT_TEXT'; {oder Plain Text, ...}
                    If DrgVerifyTrueType(DRAGITEM^,apsz) Then
                    Begin
                         DragDropData.SourceType:=drtText;
                         DragDropData.SourceString:=apsz;
                    End
                    Else DragDropData.SourceType:=drtBinData;
               End
               Else If ((flResult)And(Pos('DRM_PRINT',apsz) <> 0)) Then
               Begin
                    DragDropData.RenderType:=drmPrint;
                    apsz:='DRT_TEXT';
                    If DrgVerifyTrueType(DRAGITEM^,apsz) Then
                    Begin
                         DragDropData.SourceType:=drtText;
                         DragDropData.SourceString:=apsz;
                    End
                    Else DragDropData.SourceType:=drtBinData;
               End
               Else If flResult Then
               Begin
                    With DragDropData Do
                    Begin
                         RenderType:=drmString;
                         DragDropData.RenderString:=apsz;
                         If DrgQueryTrueType(DRAGITEM^,255,apsz) Then
                         Begin
                              SourceType:=drtString;
                              SourceString:=apsz;
                         End
                         Else flResult:=False;
                    End;
               End;
          End;
     End;

     Result:=flResult;

     If Result Then With DragDropData Do
     Begin
          DrgQueryStrName(DRAGITEM^.hstrContainerName,255,apsz);
          ContainerName:=apsz;
          DrgQueryStrName(DRAGITEM^.hstrSourceName,255,apsz);
          SourceFileName:=apsz;
          DrgQueryStrName(DRAGITEM^.hstrTargetName,255,apsz);
          TargetFileName:=apsz;
          SupportedOps:=DragSupportFromFlags(DRAGITEM^.fsSupportedOps);
          DragOperation:=DragOperationFromFlag(DragInfo^.usOperation);
          ItemId:=DRAGITEM^.ulItemID;
     End;
ex:
     DrgFreeDragInfo(DragInfo);
End;

Procedure TControl.DMDragOver(Var Msg:TMessage);
Var
   Accept:Boolean;
   DragSource:TObject;
   pt:TPoint;
   DragInfo:PDRAGINFO;
   DragDropData:TDragDropData;
   Ok:Boolean;
Begin
     Ok:=GetDragSource(Msg,DragInfo,DragDropData,DragSource,0);
     pt:=MausPosFromParam(Msg.Param2);
     WinMapWindowPoints(HWND_DESKTOP,Handle,pt,1);

     Msg.Handled:=True;
     Accept:=False;

     If Ok Then  //Rendering Type Accepted
     Begin
          If DragSource=Nil Then
          Begin
               ExternalDragDropObject.FDragDropData:=DragDropData;
               DragSource:=TObject(ExternalDragDropObject);
          End;
          DragOver(DragSource,pt.X,pt.Y,FDragState,Accept);
          FDragState:=dsDragMove;
     End;

     If Accept Then Msg.Result:=MRFROM2SHORT(DOR_DROP,DO_UNKNOWN)
     Else Msg.Result:=MPFROM2SHORT(DOR_NODROP,DO_UNKNOWN);
     //If we return DOR_NEVERDROP, the Window will Not Get DragOver Messages anymore
End;

Procedure TControl.DMDragLeave(Var Msg:TMessage);
Var
   Accept:Boolean;
   DragSource:TObject;
   pt:TPoint;
   DragInfo:PDRAGINFO;
   DragDropData:TDragDropData;
   Ok:Boolean;
Begin
     Ok:=GetDragSource(Msg,DragInfo,DragDropData,DragSource,0);
     pt:=Screen.MousePos;
     WinMapWindowPoints(HWND_DESKTOP,Handle,pt,1);

     Msg.Handled:=True;
     Accept:=False;

     If Ok Then  //Rendering Type Accepted
     Begin
          If DragSource=Nil Then
          Begin
               ExternalDragDropObject.FDragDropData:=DragDropData;
               DragSource:=TObject(ExternalDragDropObject);
          End;

          FDragState:=dsDragEnter;
          DragOver(DragSource,pt.X,pt.Y,dsDragLeave,Accept);
     End;

     If Accept Then Msg.Result:=MRFROM2SHORT(DOR_DROP,DO_COPY)
     Else Msg.Result:=MPFROM2SHORT(DOR_NEVERDROP,DO_UNKNOWN);
End;

Procedure TControl.DMDrop(Var Msg:TMessage);
Var
   DragSource:TObject;
   pt:TPoint;
   DragInfo:PDRAGINFO;
   DRAGITEM:PDragItem;
   DragDropData:TDragDropData;
   Ok:Boolean;
   hwndItem:HWND;
   ulItemID:LongWord;
   ItemCount,T:LongWord;
Begin
     Ok:=GetDragSource(Msg,DragInfo,DragDropData,DragSource,0);
     pt:=Screen.MousePos;
     WinMapWindowPoints(HWND_DESKTOP,Handle,pt,1);

     Msg.Handled:=True;

     If DragInfo<>Nil Then
     Begin
          If DrgAccessDragInfo(DragInfo) Then
          Begin
               If DragInfo^.cdItem>0 Then
               Begin
                    ItemCount:=DragInfo^.cdItem;
                    DRAGITEM:=DrgQueryDragitemPtr(DragInfo^,0);
                    hwndItem:=DRAGITEM^.hwndItem;
                    ulItemID:=DRAGITEM^.ulItemID;
               End
               Else DRAGITEM:=Nil;
               DrgFreeDragInfo(DragInfo);
          End
          Else DRAGITEM:=Nil;
     End
     Else DRAGITEM:=Nil;
     If DRAGITEM=Nil Then Exit;

     If Ok Then  {Rendering Type Accepted}
     Begin
          FDragState:=dsDragEnter;
          For T:=1 To ItemCount Do
          Begin
               If GetDragSource(Msg,DragInfo,DragDropData,DragSource,T-1) Then
               Begin
                    If DragSource=Nil Then
                    Begin
                         ExternalDragDropObject.FDragDropData:=DragDropData;
                         DragSource:=TObject(ExternalDragDropObject);
                    End;

                    DragDrop(DragSource,pt.X,pt.Y);

                    If DrgAccessDragInfo(DragInfo) Then
                    Begin
                         DRAGITEM:=DrgQueryDragitemPtr(DragInfo^,T-1);
                         If DRAGITEM<>Nil Then
                         Begin
                              hwndItem:=DRAGITEM^.hwndItem;
                              {If Ok Then}
                              DrgSendTransferMsg(hwndItem,
                                                 DM_ENDCONVERSATION,
                                                 MPFROMLONG(ulItemID),
                                                 MPFROMLONG(DMFL_TARGETSUCCESSFUL));
                              {Else
                              DrgSendTransferMsg(hwndItem,
                                                 DM_ENDCONVERSATION,
                                                 MPFROMLONG(ulItemID),
                                                 MPFROMLONG(DMFL_TARGETFAIL));}
                         End;
                         DrgFreeDragInfo(DragInfo);
                    End;
               End;
          End;
     End
     Else
     Begin
          DrgSendTransferMsg(hwndItem,
                             DM_ENDCONVERSATION,
                             MPFROMLONG(ulItemID),
                             MPFROMLONG(DMFL_TARGETFAIL));
     End;
End;
{$ENDIF}


{creates AChild Window If its phys. Parent Is created}
Procedure TControl.InsertControl(AChild:TControl);
Begin
     Insert(AChild); {Insert AChild In Some lists}

     AChild.Perform(CM_PARENTFONTCHANGED,0,0);
     AChild.Perform(CM_PARENTPENCOLORCHANGED,0,0);
     AChild.Perform(CM_PARENTCOLORCHANGED,0,0);

     If Handle <> 0 Then
     Begin
          If Not (AChild.FIsToolBar) Then
          Begin
               AChild.CreateWnd;
               If AChild.FVisible Or AChild.Designed Then AChild.Show;
          End;
     End
     Else FInitControls := True;
End;


Procedure TControl.Insert(AChild:TControl);
Begin
     ListAdd(FControls, AChild);
     If Not (csReferenceControl In AChild.ComponentState) Then ListAdd(FTabList, AChild);
     AChild.FParent := Self;

     AChild.FForm := GetParentForm(Self);  {allows fast access To the Form}
End;


Procedure TControl.RemoveControl(AChild:TControl);  {call by SetParent(Nil)}
Begin
     {removefocus}
     AChild.DestroyHandle;

     Remove(AChild);  {Delete AChild from Some lists}
End;


Procedure TControl.Remove(AChild:TControl);
Begin
     ListRemove(FTabList, AChild);
     ListRemove(FControls, AChild);
     AChild.FParent := Nil;
End;


Procedure TControl.SetParent(AParent:TControl);
Begin
     If FParent <> AParent Then
     Begin
          If AParent = Self Then Exit;
          If FParent <> Nil Then FParent.RemoveControl(Self);
          If AParent <> Nil Then AParent.InsertControl(Self);
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TScrollBar Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TScrollBar.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF Win32}
     CreateSubClass(ClassData,'SCROLLBAR');
     {$ENDIF}
     {$IFDEF OS2}
     ClassData.ClassULong := WC_SCROLLBAR;
     {$ENDIF}
End;

Procedure TScrollBar.SetupComponent;
Begin
     Inherited SetupComponent;

     Height := goSysInfo.Screen.HScrollSize;
     Width := 100;
     FOwnerDraw := False;
     Color := clScrollbar;
     ParentFont := False;
     ParentPenColor := False;
     ParentColor := False;

     FKind := sbHorizontal;
     FSmallChange := 1;
     FLargeChange := 1;
     FMin := 0;
     FMax := 100;
     FSliderSize := 1;
     FPosition := 0;
     FCalcRange := FMax - FSliderSize + 1;
     FAllowFocus:=True;
End;

Function TScrollBar.CanFocus:Boolean;
Begin
     Result:=FAllowFocus;
End;

Procedure TScrollBar.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);
     If FKind = sbHorizontal
     Then Params.Style := Params.Style Or SBS_HORZ
     Else Params.Style := Params.Style Or SBS_VERT;
End;

Procedure TScrollBar.SetupShow;
Begin
     Inherited SetupShow;

     SetScrollRange(FMin,FMax,FSliderSize);
End;

Procedure TScrollBar.SetPenColor(NewColor:TColor);
Begin
     TControl.SetPenColor(NewColor);
     TControl.SetColor(NewColor);
End;

Procedure TScrollBar.SetColor(NewColor:TColor);
Begin
     TControl.SetPenColor(NewColor);
     TControl.SetColor(NewColor);
End;

Procedure TScrollBar.SetKind(NewKind:TScrollBarKind);
Begin
     If FKind <> NewKind Then
     Begin
          If NewKind = sbHorizontal Then
          Begin
               FWidth := FHeight;
               FHeight := goSysInfo.Screen.HScrollSize;
          End
          Else
          Begin
               FHeight := FWidth;
               FWidth := goSysInfo.Screen.VScrollSize;
          End;
          FKind := NewKind;
          RecreateWnd;
     End;
End;

Procedure TScrollBar.SetPosition(NewPosition:LongInt);
Begin
     If NewPosition < FMin Then NewPosition := FMin;
     If NewPosition > FCalcRange Then NewPosition := FCalcRange;
     If NewPosition > FMax Then NewPosition:=FMax;

     FPosition := NewPosition;

     If Handle = 0 Then Exit;
     {transform}
     NewPosition := Round((NewPosition - FMin) / FScale);

     If FScale > 1 Then  {Handle Special cases}
     Begin
          If FPosition = FMin Then NewPosition := 0
          Else
          If NewPosition = 0 Then NewPosition := 1  {still Enable Left Scroll}
          Else
          If FPosition = FCalcRange Then NewPosition := lastpos
          Else
          If NewPosition = lastpos Then NewPosition := lastpos - 1;
     End;

     {$IFDEF OS2}
     If WinSendMsg(Handle,SBM_QUERYPOS,0,0) <> NewPosition
     Then WinSendMsg(Handle,SBM_SETPOS,NewPosition,0);
     {$ENDIF}
     {$IFDEF Win32}
     If WinUser.GetScrollPos(Handle,SB_CTL) <> NewPosition
     Then  WinUser.SetScrollPos(Handle,SB_CTL,NewPosition,True);
     {$ENDIF}
End;

Procedure TScrollBar.SetMin(NewMin:LongInt);
Begin
     If NewMin > FMax Then Exit;
     SetScrollRange(NewMin,FMax,FSliderSize);
     If FControl<>Nil Then
       If FControl.AutoScroll Then
       Begin
            If Min<0 Then
              If FHandle<>0 Then Show;
       End;
End;

Procedure TScrollBar.SetMax(NewMax:LongInt);
Begin
     If NewMax < FMin Then Exit;
     SetScrollRange(FMin,NewMax,FSliderSize);
     If FControl<>Nil Then
       If FControl.AutoScroll Then
       Begin
            If Kind=sbHorizontal Then
            Begin
                 If Max>FControl.ClientWidth Then
                   If FHandle<>0 Then Show;
            End
            Else
            Begin
                 If Max>FControl.ClientHeight Then
                   If FHandle<>0 Then Show;
            End;
       End;
End;

Procedure TScrollBar.SetSliderSize(NewSliderSize:LongInt);
Begin
     If NewSliderSize < 1 Then Exit;
     SetScrollRange(FMin,FMax,NewSliderSize);
End;

Procedure TScrollBar.SetScrollRange(aMin,aMax,aSliderSize:LongInt);
Var  APos:LongInt;
     {$IFDEF Win32}
     ScrollInfo:TScrollInfo;
     {$ENDIF}
Begin
     If aMin > aMax Then Exit;
     If aSliderSize < 1 Then Exit;

     FMin := aMin;
     FMax := aMax;
     FSliderSize := aSliderSize;
     FCalcRange := FMax - FSliderSize + 1;
     If FCalcRange < 0 Then FCalcRange := 0;
     FScale := 1;

     If Handle = 0 Then Exit;
     {transform}
     If FMax - FMin > MaxInt Then FScale := (FMax - FMin) / (MaxInt - 1);
     APos := Round((FPosition - FMin) / FScale);
     aMin := Round((FMin - FMin) / FScale);
     aMax := Trunc((FMax - FMin) / FScale);
     aSliderSize := Round(FSliderSize / FScale);

     lastpos := aMax - aSliderSize + 1;
     {$IFDEF OS2}
     WinSendMsg(Handle,SBM_SETSCROLLBAR, APos, MAKELONG(aMin,lastpos));
     WinSendMsg(Handle,SBM_SETTHUMBSIZE, MAKELONG(aSliderSize,aMax-aMin+1), 0);
     {$ENDIF}
     {$IFDEF Win32}
     ScrollInfo.cbSize := SizeOf(ScrollInfo);
     ScrollInfo.fMask := SIF_ALL;
     ScrollInfo.nMin := aMin;
     ScrollInfo.nMax := aMax;
     ScrollInfo.nPage := aSliderSize;
     ScrollInfo.nPos := APos;
     ScrollInfo.nTrackPos := APos;
     SetScrollInfo(Handle, SB_CTL, ScrollInfo, True);
     {$ENDIF}

     SetPosition(FPosition);
End;

Procedure TScrollBar.SetParams(aPosition,aMin,aMax:LongInt);
Begin
     SetScrollRange(aMin,aMax,FSliderSize);
     SetPosition(aPosition);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TControlScrollBar Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TControlScrollBar.SetupComponent;
Begin
    Inherited SetupComponent;
    Exclude(ComponentState,csHandleLinks);
    SmallChange:=5;
    LargeChange:=10;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TScrollingWinControl Class Implementation                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TScrollingWinControl.SetupComponent;
Begin
     Inherited SetupComponent;

     FScrollBars := ssNone;
     FAutoScroll := True;
     FHorzScrollBar := Nil;
     FVertScrollBar := Nil;
     FHMin:=0;
     FHMax:=Width;
     FHPos:=0;
     FHLargeChange:=10;
     FHSmallChange:=5;
     FHColor:=clScrollBar;
     FHSliderSize:=1;
     FVMin:=0;
     FVMax:=Height;
     FVPos:=0;
     FVLargeChange:=10;
     FVSmallChange:=5;
     FVColor:=clScrollBar;
     FVSliderSize:=1;
End;


Procedure TScrollingWinControl.SetupShow;
Begin
  Inherited SetupShow;
  SetScrollBars(FScrollBars);
End;


Procedure TScrollingWinControl.ScrollInView(AControl:TControl);
Var rc:TRect;
Begin
     If ((AControl=Nil)Or(AControl.Parent<>Self)) Then exit;
     rc:=AControl.ClientRect;

     If rc.Left<0 Then
     Begin
          If FHorzScrollBar<>Nil Then
            FHorzScrollBar.Position:=FHorzScrollBar.Position-rc.Left;
          AControl.Left:=0;
     End
     Else If rc.Right>ClientWidth Then
     Begin
          If FHorzScrollBar<>Nil Then
            FHorzScrollBar.Position:=FHorzScrollBar.Position-(ClientWidth-rc.Right);
          rc.Left:=rc.Left-(ClientWidth-rc.Right);
     End;

     If rc.Bottom<0 Then
     Begin
          If FVertScrollBar<>Nil Then
            FVertScrollBar.Position:=FVertScrollBar.Position-rc.Bottom;
          AControl.Bottom:=0;
     End
     Else If rc.Top>ClientHeight Then
     Begin
          If FVertScrollBar<>Nil Then
            FVertScrollBar.Position:=FVertScrollBar.Position-(ClientHeight-rc.Top);
          rc.Bottom:=rc.Bottom-(ClientHeight-rc.Top);
     End;
End;


Procedure TScrollingWinControl.Resize;
Begin
  Inherited Resize;
  AdjustScrollbars;
  AlignScrollbars;
End;

Destructor TScrollingWinControl.Destroy;
Begin
  Include(ComponentState,csDestroying);
  If FHorzScrollBar <> Nil Then
    Begin
      FHorzScrollBar.Destroy;
      FHorzScrollBar := Nil;
    End;
  If FVertScrollBar <> Nil Then
    Begin
      FVertScrollBar.Destroy;
      FVertScrollBar := Nil;
    End;
  Inherited Destroy;
End;


Procedure TScrollingWinControl.Paint(Const rec:TRect);
Var  rc:TRect;
Begin
     Inherited Paint(rec);

     If (FHorzScrollBar <> Nil) And (FVertScrollBar <> Nil) Then
       If ((FHorzScrollBar.Visible)And(FVertScrollBar.Visible)) Then
     Begin
          rc := GetClientRect;
          rc.Left := rc.Right - FVertScrollBar.Width +1;
          rc.Top := rc.Bottom + FHorzScrollBar.Height -1;
          FCanvas.FillRect(rc, clLtGray);
     End;
End;


Procedure TScrollingWinControl.SetAutoScroll(NewValue:Boolean);
Begin
     If FAutoScroll <> NewValue Then
     Begin
          FAutoScroll := NewValue;
          If Not FAutoScroll Then
          Begin
               AlignScrollbars;
               If FHorzScrollbar <> Nil Then FHorzScrollbar.Show;
               If FVertScrollbar <> Nil Then FVertScrollbar.Show;
          End
          Else SetScrollBars(ssBoth);
     End;
End;


Procedure TScrollingWinControl.SetScrollBars(NewValue:TScrollStyle);
Var  t:LongInt;
     Control:TControl;
Begin
     If FAutoScroll Then NewValue := ssBoth;

     FScrollBars := NewValue;
     If Handle = 0 Then Exit;

     {Delete}
     If NewValue In [ssNone,ssHorizontal] Then
     Begin
          If FVertScrollBar <> Nil Then
          Begin
               FVertScrollBar.Destroy;
               FVertScrollBar := Nil;
          End;
     End;

     If NewValue In [ssNone,ssVertical] Then
     Begin
          If FHorzScrollBar <> Nil Then
          Begin
               FHorzScrollBar.Destroy;
               FHorzScrollBar := Nil;
          End;
     End;

     If NewValue <> ssNone Then
     Begin
          For t:=0 To ControlCount-1 Do
          Begin
               Control:=Controls[t];
               If Control<>FVertScrollBar Then
                 If Control<>FHorzScrollBar Then Control.ZOrder:=zoBottom;
          End;
     End;

     {Create}
     If NewValue In [ssHorizontal,ssBoth] Then
       If FHorzScrollBar = Nil Then
       Begin
            FHorzScrollBar.Create(Self);
            FHorzScrollBar.FControl:=Self;
            Exclude(FHorzScrollBar.ComponentState, csHandleLinks);
            FHorzScrollBar.HandlesDesignMouse:=True;
            FHorzScrollBar.Min:=FHMin;
            FHorzScrollBar.Max:=FHMax;
            FHorzScrollBar.Position:=FHPos;
            FHorzScrollBar.LargeChange:=FHLargeChange;
            FHorzScrollBar.SmallChange:=FHSmallChange;
            FHorzScrollBar.Color:=FHColor;
            FHorzScrollBar.SliderSize:=FHSliderSize;
            FHorzScrollBar.Kind := sbHorizontal;
            Include(FHorzScrollBar.ComponentState, csDetail);
            FHorzScrollBar.SetDesigning(False); {!}
            If AutoScroll Then FHorzScrollBar.Hide;
            //FHorzScrollBar.SetDesigning(Designed);
            FHorzScrollBar.Parent := Self;
       End;

     If NewValue In [ssVertical,ssBoth] Then
       If FVertScrollBar = Nil Then
       Begin
            FVertScrollBar.Create(Self);
            FVertScrollBar.FControl:=Self;
            FVertScrollBar.HandlesDesignMouse:=True;
            FVertScrollBar.Min:=FVMin;
            FVertScrollBar.Max:=FVMax;
            FVertScrollBar.Position:=FVPos;
            FVertScrollBar.LargeChange:=FVLargeChange;
            FVertScrollBar.SmallChange:=FVSmallChange;
            FVertScrollBar.Color:=FVColor;
            FVertScrollBar.SliderSize:=FVSliderSize;
            FVertScrollBar.Kind := sbVertical;
            Include(FVertScrollBar.ComponentState, csDetail);
            FVertScrollBar.SetDesigning(False); {!}
            If AutoScroll Then FVertScrollBar.Hide;
            //FVertScrollBar.SetDesigning(Designed);
            FVertScrollBar.Parent := Self;
       End;

     AdjustScrollbars;
     AlignScrollbars;

     {Update Children}
     If Not FFirstShow Then RealignControls;
End;


{$HINTS OFF}
Procedure TScrollingWinControl.Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Var  Control:TControl;
     t:Longint;
Begin
     If (Sender = FVertScrollBar) Or (Sender = FHorzScrollBar) Then
       If ScrollCode In [scHorzEndScroll,scVertEndScroll,scHorzPosition,scVertPosition] Then
     Begin
          If FAutoScroll Then
          Begin
               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,False);
               {$ENDIF}
               {$IFDEF Win32}
               SendMsg(Handle,WM_SETREDRAW,0,0);
               {$ENDIF}

               FIgnoreAdjust := True;
               If Sender=FVertScrollBar Then
               Begin
                    For t:=0 To ControlCount-1 Do
                    Begin
                        Control:=Controls[t];
                        If Control<>FVertScrollBar Then
                          If Control<>FHorzScrollBar Then
                          Begin
                               Control.ZOrder:=zoBottom;
                               Control.Bottom:=Control.Bottom+(ScrollPos-FVPos);
                          End;
                    End;
                    FVPos:=ScrollPos;
               End;

               If Sender=FHorzScrollBar Then
               Begin
                    For t:=0 To ControlCount-1 Do
                    Begin
                        Control:=Controls[t];
                        If Control<>FVertScrollBar Then
                          If Control<>FHorzScrollBar Then
                          Begin
                               Control.ZOrder:=zoBottom;
                               Control.Left:=Control.Left-(ScrollPos-FHPos);
                          End;
                    End;
                    FHPos:=ScrollPos;
               End;
               FIgnoreAdjust := False;

               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,True);
               {$ENDIF}
               {$IFDEF Win32}
               SendMsg(Handle,WM_SETREDRAW,1,0);
               {$ENDIF}
               Invalidate;

               If Designed Then Form.Invalidate;
          End;

          CaptureFocus;
     End;
End;
{$HINTS ON}


Procedure TScrollingWinControl.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Type TScrollExtents=Record
                         VMin,VMax:LongInt;
                         HMin,HMax:LongInt;
                         VPos,HPos:LongInt;
                         VLargeChange,VSmallChange:LongInt;
                         HLargeChange,HSmallChange:LongInt;
                         VColor,HColor:TColor;
                         VSliderSize,HSliderSize:LongInt;
                   End;
     PScrollExtents=^TScrollExtents;
Var ScrollExtents:PScrollExtents;
Begin
     If ResName = rnScrollExtents Then
     Begin
          If DataLen <> 0 Then
          Begin
               ScrollExtents:=@Data;
               If FVertScrollBar<>Nil Then
               Begin
                    FVertScrollBar.Min:=ScrollExtents^.VMin;
                    FVertScrollBar.Max:=ScrollExtents^.VMax;
                    FVertScrollBar.Position:=ScrollExtents^.VPos;
                    FVertScrollBar.LargeChange:=ScrollExtents^.VLargeChange;
                    FVertScrollBar.SmallChange:=ScrollExtents^.VSmallChange;
                    FVertScrollBar.Color:=ScrollExtents^.VColor;
                    FVertScrollBar.SliderSize:=ScrollExtents^.VSliderSize;
               End
               Else
               Begin
                    FVMin:=ScrollExtents^.VMin;
                    FVMax:=ScrollExtents^.VMax;
                    FVPos:=ScrollExtents^.VPos;
                    FVLargeChange:=ScrollExtents^.VLargeChange;
                    FVSmallChange:=ScrollExtents^.VSmallChange;
                    FVColor:=ScrollExtents^.VColor;
                    FVSliderSize:=ScrollExtents^.VSliderSize;
               End;
               If FHorzScrollBar<>Nil Then
               Begin
                    FHorzScrollBar.Min:=ScrollExtents^.HMin;
                    FHorzScrollBar.Max:=ScrollExtents^.HMax;
                    FHorzScrollBar.Position:=ScrollExtents^.HPos;
                    FHorzScrollBar.LargeChange:=ScrollExtents^.HLargeChange;
                    FHorzScrollBar.SmallChange:=ScrollExtents^.HSmallChange;
                    FHorzScrollBar.Color:=ScrollExtents^.HColor;
                    FHorzScrollBar.SliderSize:=ScrollExtents^.HSliderSize;
               End
               Else
               Begin
                    FHMin:=ScrollExtents^.HMin;
                    FHMax:=ScrollExtents^.HMax;
                    FHPos:=ScrollExtents^.HPos;
                    FHLargeChange:=ScrollExtents^.HLargeChange;
                    FHSmallChange:=ScrollExtents^.HSmallChange;
                    FHColor:=ScrollExtents^.HColor;
                    FHSliderSize:=ScrollExtents^.HSliderSize;
               End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TScrollingWinControl.WriteSCUResource(Stream:TResourceStream):Boolean;
Var ScrollExtents:Record
                         VMin,VMax:LongInt;
                         HMin,HMax:LongInt;
                         VPos,HPos:LongInt;
                         VLargeChange,VSmallChange:LongInt;
                         HLargeChange,HSmallChange:LongInt;
                         VColor,HColor:TColor;
                         VSliderSize,HSliderSize:LongInt;
                  End;
Begin
     Result := Inherited WriteSCUResource(Stream);

     If Not Result Then Exit;
     If ((FVertScrollBar=Nil)And(FHorzScrollBar=Nil)) Then exit;

     If FVertScrollBar<>Nil Then
     Begin
          ScrollExtents.VMin:=FVertScrollBar.Min;
          ScrollExtents.VMax:=FVertScrollBar.Max;
          ScrollExtents.VPos:=FVertScrollBar.Position;
          ScrollExtents.VLargeChange:=FVertScrollBar.LargeChange;
          ScrollExtents.VSmallChange:=FVertScrollBar.SmallChange;
          ScrollExtents.VColor:=FVertScrollBar.Color;
          ScrollExtents.VSliderSize:=FVertScrollBar.SliderSize;
     End
     Else
     Begin
          ScrollExtents.VMin:=0;
          ScrollExtents.VMax:=100;
          ScrollExtents.VPos:=0;
          ScrollExtents.VLargeChange:=10;
          ScrollExtents.VSmallChange:=5;
          ScrollExtents.VColor:=clScrollBar;
          ScrollExtents.VSliderSize:=1;
     End;

     If FHorzScrollBar<>Nil Then
     Begin
          ScrollExtents.HMin:=FHorzScrollBar.Min;
          ScrollExtents.HMax:=FHorzScrollBar.Max;
          ScrollExtents.HPos:=FHorzScrollBar.Position;
          ScrollExtents.HLargeChange:=FHorzScrollBar.LargeChange;
          ScrollExtents.HSmallChange:=FHorzScrollBar.SmallChange;
          ScrollExtents.HColor:=FHorzScrollBar.Color;
          ScrollExtents.HSliderSize:=FHorzScrollBar.SliderSize;
     End
     Else
     Begin
          ScrollExtents.HMin:=0;
          ScrollExtents.HMax:=100;
          ScrollExtents.HPos:=0;
          ScrollExtents.HLargeChange:=10;
          ScrollExtents.HSmallChange:=5;
          ScrollExtents.HColor:=clScrollBar;
          ScrollExtents.HSliderSize:=1;
     End;

     Result := Stream.NewResourceEntry(rnScrollExtents,ScrollExtents,sizeof(ScrollExtents));
End;


Procedure TScrollingWinControl.RemoveControl(AChild:TControl);
Begin
     Inherited RemoveControl(AChild);

     If AChild <> FHorzScrollbar Then
       If AChild <> FVertScrollbar Then
       Begin
            AdjustScrollbars;
            AlignScrollbars;
       End;
End;


Procedure TScrollingWinControl.InsertControl(AChild:TControl);
Begin
     Inherited InsertControl(AChild);

     If AChild <> FHorzScrollbar Then
       If AChild <> FVertScrollbar Then
       Begin
            AdjustScrollbars;
            AlignScrollbars;
       End;
End;


Procedure TScrollingWinControl.AdjustScrollbars;
Var  i,horzmax,vertmax:Longint;
     Control:TControl;
     OldIgnoreAdjust:Boolean;
     HorzIsVisible,VertIsVisible:Boolean;
     hpos,vpos:Longint;
Begin
     If FIgnoreAdjust Then exit;

     OldIgnoreAdjust := FIgnoreAdjust;
     FIgnoreAdjust := True;

     If FAutoScroll And
       (FHorzScrollBar <> Nil) And (FVertScrollBar <> Nil) Then
     Begin
          horzmax := 0;
          vertmax := ClientHeight;

          hpos := FHorzScrollbar.Position;
          vpos := FVertScrollbar.Position;

          For i := 0 To ControlCount-1 Do
          Begin
               Control := Controls[i];
               If Control <> FHorzScrollBar Then
                 If Control <> FVertScrollBar Then
                 Begin
                      If Control.Left + Control.Width + hpos > horzmax
                        Then horzmax := Control.Left + Control.Width + hpos;
                      If Control.Bottom - vpos < vertmax
                        Then vertmax := Control.Bottom - vpos;
                 End;
          End;

          If vertmax < 0 Then // vertscroll is visible
          Begin
               inc(horzmax, FVertScrollbar.Width);
               If horzmax > ClientWidth Then dec(vertmax, FHorzScrollbar.Height);
          End
          Else
          Begin
               If horzmax > ClientWidth Then // horzscroll is visible
               Begin
                    dec(vertmax, FHorzScrollbar.Height);
                    If vertmax < 0 Then inc(horzmax, FVertScrollbar.Width);
               End;
          End;


          //show or hide Scrollbars
          FHorzScrollBar.SetScrollRange(0,horzmax,ClientWidth);
          //FHPos := FHorzScrollBar.Position;

          HorzIsVisible := horzmax > ClientWidth;
          If HorzIsVisible Then FHorzScrollBar.Show
          Else FHorzScrollBar.Hide;


          FVertScrollBar.SetScrollRange(0,ClientHeight-vertmax,ClientHeight);
          //FVPos := FVertScrollBar.Position;

          VertIsVisible := vertmax < 0;
          If VertIsVisible Then FVertScrollBar.Show
          Else FVertScrollBar.Hide;


          If horzmax - hpos < ClientWidth Then
          Begin
               hpos := FHorzScrollBar.Position;
               Scroll(FHorzScrollbar, scHorzPosition, hpos);
          End;

          If vertmax + vpos > 0 Then
          Begin
               vpos := FVertScrollBar.Position;
               Scroll(FVertScrollbar, scVertPosition, vpos);
          End;
     End;

     FIgnoreAdjust := OldIgnoreAdjust;
End;


Procedure TScrollingWinControl.AlignScrollbars;
Var  HorzIsVisible,VertIsVisible:Boolean;
     OldIgnoreAdjust:Boolean;
     rc:TRect;
Begin
     If FIgnoreAdjust Then exit;

     OldIgnoreAdjust := FIgnoreAdjust;
     FIgnoreAdjust := True;

     If FAutoScroll Then
     Begin
          If FHorzScrollBar = Nil Then HorzIsVisible := False
          Else HorzIsVisible := FHorzScrollBar.Max > ClientWidth;

          If FVertScrollBar = Nil Then VertIsVisible := False
          Else VertIsVisible := FVertScrollBar.Max > ClientHeight;
     End
     Else
     Begin
          HorzIsVisible := FHorzScrollBar <> Nil;
          VertIsVisible := FVertScrollBar <> Nil;
     End;

     If FHorzScrollBar <> Nil Then
     Begin
          rc := GetClientRect;

          If VertIsVisible Then dec(rc.Right,FVertScrollBar.Width-1);

          FHorzScrollBar.SetWindowPos(rc.Left,rc.Bottom,
                            rc.Right-rc.Left+1,FHorzScrollBar.Height);
          FHorzScrollBar.FFirstShow := False;
     End;

     If FVertScrollBar <> Nil Then
     Begin
          rc := GetClientRect;

          If HorzIsVisible Then inc(rc.Bottom,FHorzScrollBar.Height);

          FVertScrollBar.SetWindowPos(rc.Right+1-FVertScrollBar.Width,rc.Bottom,
                            FVertScrollBar.Width,rc.Top-rc.Bottom+1);
          FVertScrollBar.FFirstShow := False;
     End;

     FIgnoreAdjust := OldIgnoreAdjust;
End;


Procedure TScrollingWinControl.Loaded;
Begin
     Inherited Loaded;

     If FHorzScrollbar <> Nil Then FHPos := FHorzScrollbar.Position;
     If FVertScrollbar <> Nil Then FVPos := FVertScrollbar.Position;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TScrollBox Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TScrollBox.SetBorderStyle(NewValue:TBorderStyle);
Begin
     If NewValue=FBorderStyle Then exit;
     FBorderStyle:=NewValue;
     Invalidate;
End;

{$HINTS OFF}
Procedure TScrollBox.Redraw(Const rec:TRect);
Var rc:TRect;
Begin
     rc:=ClientRect;
     If FHorzScrollBar<>Nil Then
       If FHorzScrollBar.Visible Then inc(rc.Bottom,FHorzScrollBar.Height);
     If FVertScrollBar<>Nil Then
       If FVertScrollBar.Visible Then dec(rc.Right,FVertScrollBar.Width);
     If BorderStyle=bsSingle Then
     Begin
          FCanvas.ShadowedBorder(rc,clDkGray,clWhite);
          InflateRect(rc,-1,-1);
     End;
     Inherited Redraw(rc);
End;
{$HINTS ON}


Procedure TScrollBox.SetupComponent;
Begin
     Inherited SetupComponent;

     AutoScroll:=True;
     Color:=clLtGray;
     FBorderStyle:=bsSingle;
     Width:=300;
     Height:=300;
     ScrollBars:=ssBoth;
     Include(ComponentState, csAcceptsControls);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure SetupCompLib(Var Data:TCompLibData);

var SetupCompLib:text;
    t1 : LongInt;
    Comp:TComponentClass;

Begin
     // destroy old items because they will point to the sibyl-app items
     If Screen <> Nil Then Screen.Destroy;
     Screen := Nil;
     If Clipboard <> Nil Then Clipboard.Destroy;
     Clipboard := Nil;

     Asm
        MOVB System.InheritsSoftMode,1  {!!! wegen complib.dll !!!}
        MOVB Classes.InsideDesigner,1
        MOVB Classes.InsideCompLib,1
        MOV EDI,Data
        MOV EAX,[EDI].TCompLibData.InsideWriteSCUAdr
        MOV Classes.InsideWriteSCUAdr,EAX
     End;

// Den Heap-Speicher von der IDE an die DLL weitergeben.
     Heap_Change(Data.HeapGroup, false);

/*     HeapOrg:=Data.NewHeapOrg;
     HeapEnd:=Data.NewHeapEnd;
     HeapPtr:=Data.NewHeapPtr;
     System.HeapSize:=Data.NewHeapSize;
     {$IFDEF OS2}
     Asm                     
        MOV EDI,Data
        MOV EAX,[EDI].TCompLibData.NewLastHeapPage
        MOV System.LastHeapPage,EAX
        MOV EAX,[EDI].TCompLibData.NewLastHeapPageAdr
        MOV System.LastHeapPageAdr,EAX
        MOV EAX,[EDI].TCompLibData.NewHeapMutex;
        MOV System.HeapMutex,EAX
     End;
     {$ENDIF} */

     Screen:=Data.Screen;
     Clipboard:=Data.Clipboard;
     Application:=Data.Application;

     NullStr:=Data.NullStr;
     If RegisterToolsAPIProc<>Nil Then
       Begin
         RegisterToolsAPIProc(Data.ToolsAPI);
         Data.ToolsAPIRequired:=True;
       End
     Else Data.ToolsAPIRequired:=False;
End;

{$IFDEF OS2}
Var
    DBCSFirstBytes:Array[0..255] Of Boolean;

Function IsDBCSFirstByte(CH:Char):Boolean;
Begin
     Result := DBCSFirstBytes[Ord(CH)];
End;


Procedure InitDBCSHandling;
Var  MemBuf:Array[0..11] Of Byte;
     cc:COUNTRYCODE;
     I,First,Second:Byte;
     Font:TFont;
     dbcs:Boolean;
Begin
     dbcs := False;
     FillChar(DBCSFirstBytes[0], SizeOf(DBCSFirstBytes), 0);
     cc.country := 0;
     cc.codepage := 0;
     If DosQueryDBCSEnv(12,cc,MemBuf) = 0 Then
     Begin
          For I := 0 To 5 Do
          Begin
               First := MemBuf[2*I];
               Second := MemBuf[(2*I)+1];
               If (First = 0) And (Second = 0) Then break;
               FillChar(DBCSFirstBytes[First], Second-First+1, 1);
               dbcs := True;
          End;
     End;

     If Not dbcs Then Exit;

     {initialize DBCSStatusLineHeight}
     Font := Screen.DefaultFrameFont;
     If Font <> Nil
     Then DBCSStatusLineHeight := TControlFont(Font).FontInfo.lMaxbaseLineExt +2;
End;
{$ENDIF}

{$IFDEF WIN32}
Var SA:SECURITY_ATTRIBUTES;
{$ENDIF}

Var Ch:Char;
    rv: LongWord;

Initialization
     {Martin}ConvertGetText := true;
     {Martin}For Ch := #0 to #255 Do OemToAnsiTable[Ch] := Ch;
     OemToAnsiTable['€'] := #199;
     OemToAnsiTable[''] := #252;
     OemToAnsiTable[''] := #233;
     OemToAnsiTable[''] := #226;
     OemToAnsiTable[''] := #228;
     OemToAnsiTable['…'] := #224;
     OemToAnsiTable[''] := #229;
     OemToAnsiTable[''] := #231;
     OemToAnsiTable[''] := #234;
     OemToAnsiTable[''] := #235;
     OemToAnsiTable[''] := #232;
     OemToAnsiTable[''] := #239;
     OemToAnsiTable[''] := #238;
     OemToAnsiTable[''] := #236;
     OemToAnsiTable[''] := #196;
     OemToAnsiTable[''] := #197;
     OemToAnsiTable[''] := #201;
     OemToAnsiTable['‘'] := #230;
     OemToAnsiTable['’'] := #198;
     OemToAnsiTable['“'] := #244;
     OemToAnsiTable['”'] := #246;
     OemToAnsiTable['•'] := #242;
     OemToAnsiTable['–'] := #251;
     OemToAnsiTable['—'] := #249;
     OemToAnsiTable[''] := #255;
     OemToAnsiTable[''] := #214;
     OemToAnsiTable[''] := #220;
     OemToAnsiTable[''] := #248;
     OemToAnsiTable[''] := #163;
     OemToAnsiTable[''] := #216;
     OemToAnsiTable[''] := #215;
     OemToAnsiTable[' '] := #225;
     OemToAnsiTable['ก'] := #237;
     OemToAnsiTable['ข'] := #243;
     OemToAnsiTable['ฃ'] := #250;
     OemToAnsiTable['ค'] := #241;
     OemToAnsiTable['ฅ'] := #209;
     OemToAnsiTable['ฆ'] := #170;
     OemToAnsiTable['ง'] := #186;
     OemToAnsiTable['จ'] := #191;
     OemToAnsiTable['ฉ'] := #174;
     OemToAnsiTable['ช'] := #172;
     OemToAnsiTable['ซ'] := #189;
     OemToAnsiTable['ฌ'] := #188;
     OemToAnsiTable['ญ'] := #161;
     OemToAnsiTable['ฎ'] := #171;
     OemToAnsiTable['ฏ'] := #187;
     OemToAnsiTable['ต'] := #193;
     OemToAnsiTable['ถ'] := #194;
     OemToAnsiTable['ท'] := #192;
     OemToAnsiTable['ธ'] := #169;
     OemToAnsiTable['พ'] := #165;
     OemToAnsiTable['ฟ'] := #172;
     OemToAnsiTable['ฦ'] := #227;
     OemToAnsiTable['ว'] := #195;
     OemToAnsiTable['Ý'] := #166;
     OemToAnsiTable['ฯ'] := #164;
     OemToAnsiTable['ะ'] := #240;
     OemToAnsiTable['ั'] := #208;
     OemToAnsiTable['า'] := #202;
     OemToAnsiTable['ำ'] := #203;
     OemToAnsiTable['ิ'] := #200;
     OemToAnsiTable['ึ'] := #205;
     OemToAnsiTable['ื'] := #206;
     OemToAnsiTable['ุ'] := #207;
     OemToAnsiTable['Þ'] := #204;
     OemToAnsiTable['เ'] := #211;
     OemToAnsiTable['แ'] := #223;
     OemToAnsiTable['โ'] := #212;
     OemToAnsiTable['ใ'] := #210;
     OemToAnsiTable['ไ'] := #245;
     OemToAnsiTable['ๅ'] := #213;
     OemToAnsiTable['ๆ'] := #181;
     OemToAnsiTable['็'] := #254;
     OemToAnsiTable['่'] := #222;
     OemToAnsiTable['้'] := #218;
     OemToAnsiTable['๊'] := #219;
     OemToAnsiTable['๋'] := #217;
     OemToAnsiTable['์'] := #253;
     OemToAnsiTable['ํ'] := #221;
     OemToAnsiTable['๎'] := #175;
     OemToAnsiTable['๏'] := #180;
     OemToAnsiTable['๐'] := #173;
     OemToAnsiTable['๑'] := #177;
     OemToAnsiTable['๓'] := #190;
     OemToAnsiTable['๔'] := #182;
     OemToAnsiTable['๕'] := #167;
//     OemToAnsiTable[#21] := #167;
     OemToAnsiTable['๖'] := #247;
     OemToAnsiTable['๗'] := #184;
     OemToAnsiTable['๘'] := #176;
     OemToAnsiTable['๙'] := #168;
     OemToAnsiTable['๚'] := #183;
     OemToAnsiTable['๛'] := #185;
     OemToAnsiTable['ü'] := #179;
     OemToAnsiTable['ý'] := #178;
     OemToAnsiTable['ี'] := #128;
     {Martin}OemToAnsiTable['þ'] := #149;
     FillChar (AnsiToOemTable, sizeof(AnsiToOemTable), #32);
     {fill reveserse table}
     For Ch := #0 To #255 Do
       Begin
         If (AnsiToOemTable[OemToAnsiTable[Ch]] = #32) Or
            (AnsiToOemTable[OemToAnsiTable[Ch]] = OemToAnsiTable[Ch])
           Then AnsiToOemTable[OemToAnsiTable[Ch]] := Ch;
       End;
     AnsiToOemTable[#130] := #39; AnsiToOemTable[#146] := #39;

     {$IFDEF OS2}
     NewStyleControls:=False;
     {$ENDIF}
     {$IFDEF WIN32}
     NewStyleControls:=Lo(GetVersion)>=4;
     {$ENDIF}

     RegisterClasses([TControl,TSizeConstraints]);

     @DdeMan_WMDDEDestroy:=Nil;
     @DdeMan_WMDdeInitiate:=Nil;
     @DdeMan_OpenClientLinks:=Nil;
     @DdeMan_CloseClientLinks:=Nil;
     @DdeMan_CloseAllLinks:=Nil;

     If ApplicationType=cApplicationType_GUI Then
     Begin
          Screen.Create(Nil);
          Clipboard.Create(Nil);
          TimerList.Create;
          New(TimerArray);
          ExternalDragDropObject.Create(Nil);
     End
     Else
     Begin
          Screen:=Nil;
          Clipboard:=Nil;
          TimerList:=Nil;
          TimerArray:=Nil;
          ExternalDragDropObject:=Nil;
     End;

     {$IFDEF OS2}
     DosCreateMutexSem(Nil,TimerMutex,DC_SEM_SHARED,False);
     InitDBCSHandling;
     {$ENDIF}
     {$IFDEF Win32}
     WinDragControl:=Nil;
     WinLastDrag:=Nil;
     SA.nLength:=sizeof(SA);
     SA.lpSecurityDescriptor:=Nil;
     SA.bInheritHandle:=True;
     TimerMutex:=CreateMutex(SA,False,Nil);
     InitCommonControls;
     {$ENDIF}

Finalization
     {$IFDEF OS2}
     rv:=DosCloseMutexSem(TimerMutex);
     {$ENDIF}
     if Screen<>nil then Screen.Destroy;
     Screen:=nil;
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-02  WD         Ausbau der LINUX-Teile
                        Propertys Parameter, Log, ProgramPath, ProgramName,
                        ProgramVersion, ProgramSubVersion, ProgramDate,
                        ProgramIniFile, FormPos[Const FormName: String]
                        in tApplication eingebaut.
  03-Aug-03  WD         tControl.Caption von "Protected" auf "Published"
  12-Aug-03  WD         Das Help-Programm nach dem Beenden der Applikation schliessen
  14-Sep-03  WD         Einbau des Property "Parameter" in tApplication
  16-Sep-03  WD         Einbau des Property "Log" in tApplication
  06-Okt-03  WD         ResetComponent und tForm.ResetComponents eingebaut
  21-Okt-03  WD         Funktionen tControl.SetEnabled und tControl.GetEnabled von Private auf Protected umgestellt
  26-Dez-03  WD         Korrektur von der Funktion "DrawSystemBorder"
  08-Aug-04  MV         Microsoft HTML-Help
                        Unterdrcken der OS/2-Fehlermeldung "Laufwerk nicht bereit"
                        und eine Menge kleine Dinge, die sich ber Jahre angesammelt haben
  21-Aug-04  WD         Drag&Drop und CreateCursor korrigiert.
  31-Aug-04  WD         TScreen.GetFontFromPointSize: Bessere Ermittlung von lfHeight und lfWidth unter Windows
  15-Sep-04  CW         TframeControl.CreateWnd: Korrekte Anzeige der Form-Caption bei Sonderzeichen
                        Tapplication.DeleteMenuItem: The TApplication component doesn't reduce the Tlist of active TMenuItems when the newest ones are deleted
  29-Sep-04  WD         Umbau der Drag&Drop unter Windows
  01-Okt-04  MV         Korrketur von tScreen.GetFontFromPointSize: Umrechnung von Pitch --> Pixel
  04-Okt-04  MV         Einbau der Property tScreen.SystemFontCount
  08-Nov-04  WD         Einbau der Funktion tForm.PrintForm;
  14-Nov-04  WD         Umbau der Logik fuer die Positionspeichern dem Forms. Jetzt auch
                        abhngig von Application.FormPositionINI. default: fpSaveLoadINI
  05-Dez-04  WD         Durch den neuen RC-Compiler: Rueckbau von Curs_OS2.RC und Curs_W32.RC auf Cursors.RC
  07-Feb-05  WD         Aendern der Applikations-INI-Datei: FormPosition -> FormInfo. Dadurch k”nnen
                        mehrere Attribute gespeichert werden. (z.b. FormPosition, Schriftart usw.)
  23-Mai-05  MV/WD      BeginDrag ab nun als "virtual" definiert
  22-Jun-05  WD         Wenn keine INI-Datei existiert, dann soll die Fonts von der IDE verwendet werden.
  30-Jun-05  WD         Set-/GetFormInfo: Abspeichern und Laden von Color
  07-Jul-05  WD         Speichern der Schrift und die Farbe der einzelen Komponenten
  20-Jul-05  WD         Abspeichern div Infos (tControl, tForm) in die Application-INI-Datei
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  18-Okt-05  MV/WD      Ausbau der If-Statements aus der Funktion TApplication.SetHelpFile
  25-Okt-05  WD         Abspeichern des WindowsStates (Normal, Minimize und Maxmize) in der INI.
  12-Nov-05  WD         Windows/Showmodal: Wenn die Form beendet wird, dann bekommt der Owner den Focus
  12-Dez-05  WD         In der INI wird nun auch der Drucker gespeichert.
  26-Dez-05  WD         Neue Funktion TApplication.GetProgramAlreadyRunning; Lauft schon das Programm?
  20-Jan-06  MV/WD      tControl.SetCursor: von Private nach protected verschieben und mit virtual versehen
  28-Jan-06  WD         Korrektur: Programmabsturz wenn kein Durcker im System vorhanden ist
  17-Feb-06  WD         Einbau der Klasse tLanguageFile (Sprache)
  17-Mar-06  WD         Application.Run/SetHelp: Hilfelogik verschoben.
  16-Jul-06  MV         Statt #0 in der AnsiToOemTable auf #32 geaendert.
  16-Jul-06  MV         Korrektur der schrumpfenden Controls.
  10-Aug-06  MV         Control.ShowHint von Protected auf Public umgestellt.
  10-Aug-06  WD         TApplication.ProcessMessage: If Anweisung geaendert und FTerminate:=True herausgenommen, da
                        diese Variable schon in der Close-Funktion eventuell gesetzt wird.
  19-Aug-06  MV         tForm.SetHelpWindowTitle: Ausbau von den beiden IFs
  30-Aug-06  MV         GeneralGetFontFromPointSize: bei Windows darf nur dann auf Kopien von Screen-Fonts zugegriffen werden,
                                 wenn der Font auch wirklich fuer Screen benoetigt wird,
                                 andernfalls wird die Schrift viel zu klein, weil die Groesse in Pixel nicht
                                 angepasst wird
  30-Aug-06  WD         Finalization (inkl. Aufruf von Screen.Destroy; DosCloseMutexSem) eingebaut.
  04-Sep-06  MV/TB      TApplication.HintTimerExpired: Ausbau vom Check ob das Control enabled ist oder nicht.
  03-Okt-06  KF         Einbau von der Variable: MakeIniFile
  06-Nov-06  WD         TApplication.DeleteMenuItem: Check auf FMenuItemList=nil
  21-Mar-07  MV         TSystemOpenDialog.Execute:Boolean: OFN_FILEMUSTEXIST ausgebaut
  21-Apr-07  WD, MV     Die neue Heap-Verwaltung von Martin V fr die IDE eingebaut.
  23-Apr-07  WD         TApplication.Create: So umgebaut, dass es auch den Parameter "-LOG=" versteht
  16-Jul-07  WD         THintWindow.Redraw: Umbau der Hints, damit mehrer Zeile ausgegeben werden kann.
  01-Sep-07  WD         tSizeBorder: BorderAlign "baVerticalSizing" eingebaut.
  09-Mar-08  MV         StrOEMtoAnsi, StrAnsiToOEM moved to SYSUTILS.PAS
  15-Mar-08  MV         ReadInfoFromINI: Kl. korrektur bzgl. bsDialog;
  15-Mar-08  MV         TControl.WMChar: umgebaut
  15-Mar-08  MV         Initialization: Auskommentieren von OemToAnsiTable[#21] := #167;
  15-Mar-08  MV         TScreen.MapPoints und TControl.MapPoints: Umrechnung fr Windows eingebaut.
  03-Jun-08  WD         Property Locked und IsModal eingebaut bzw. erweitert.
}



{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2005..     Ing. Wolfgang Draxler, All rights reserved.  บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ExtCtrls;

Interface

Uses SysUtils,Color,Classes,Messages,Forms,Graphics,Buttons,StdCtrls,
     uList,
     uString;

Type
    TShapeType=(stRectangle,stSquare,stRoundRect,stRoundSquare,
                stEllipse,stCircle,stTriangle);

    TShape=Class(TControl)
      Private
         FTempPen:TPen;
         FTempBrush:TBrush;
         FShape:TShapeType;
         Function GetBrush:TBrush;
         Function GetPen:TPen;
         Procedure SetShape(NewShape:TShapeType);
         Procedure SetColor(NewColor : tColor);
         Function GetColor : tColor;
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Property Canvas;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Brush:TBrush Read GetBrush;
         Property Color Read GetColor Write SetColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentShowHint;
         Property Pen:TPen Read GetPen;
         Property Shape:TShapeType Read FShape Write SetShape;
         Property ShowHint;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TPaintBox=Class(TControl)
      Protected
         Procedure SetupComponent;Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
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
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property ShowHint;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnPaint;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TImage=Class(TControl)
      Private
         FPicture:TPicture;
         FNeedBitmap:Boolean;
         FAutoSize:Boolean;
         FStretch:Boolean;
         FCenter:Boolean;
         FOnChange:TNotifyEvent;
         Function  GetTransparentColor : tColor;
         Procedure SetTransparentColor(iColor : tColor);
         Procedure SetStretch(NewValue:Boolean);
         Procedure SetCenter(NewValue:Boolean);
         Procedure SetBitmap(NewBitmap:TBitmap);
         Function GetBitmap:TBitmap;
         Function GetIcon:TIcon;
         Procedure SetIcon(NewIcon:TIcon);
         Function GetGraphic:TGraphic;
         Procedure SetGraphic(NewGraphic:TGraphic);
         Procedure SetPicture(NewPicture:TPicture); //RG 13-Nov-06

         Procedure PictureChanged(Sender:TObject);
      Protected
         Procedure Change;Virtual;
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Property NeedBitmap:Boolean Read FNeedBitmap Write FNeedBitmap;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Public
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
         Property Picture:TPicture read FPicture write SetPicture; //RG 13-Nov-06
         Property Graphic:TGraphic read GetGraphic write SetGraphic;
         Property Icon:TIcon Read GetIcon Write SetIcon;
      Published
         Property Align;
         Property AutoSize:Boolean Read FAutoSize Write FAutoSize;
         Property Center:Boolean Read FCenter Write SetCenter;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentShowHint;
         Property Bitmap:TBitmap Read GetBitmap Write SetBitmap;
         Property PopupMenu;
         Property ShowHint;
         Property Stretch:Boolean Read FStretch Write SetStretch;
         Property TransparentColor : tColor Read GetTransparentColor Write SetTransparentColor;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent read FOnChange write FOnChange;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    {$M+}
    TBevelShape=(bsBottomLine,bsBox,bsFrame,bsLeftLine,bsRightLine,bsTopLine,
      bsBorder);

    TBevelStyle=(bsLowered,bsRaised);
    {$M-}

    TBevel=Class(TControl)
      Private
         FShape:TBevelShape;
         FStyle:TBevelStyle;
         Procedure SetShape(NewShape:TBevelShape);
         Procedure SetStyle(NewStyle:TBevelStyle);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property ParentShowHint;
         Property PopupMenu;
         Property Shape:TBevelShape Read FShape Write SetShape;
         Property ShowHint;
         Property Style:TBevelStyle Read FStyle Write SetStyle;
         Property Visible;
         Property ZOrder;

         Property OnCommand;
         Property OnResize;
         Property OnSetupShow;
    End;


    {$M+}
    TPanelBevel=(bvRaised,bvLowered,bvNone);
    {$M-}

    TPanel=Class(TControl)
      Private
         FBevelInner:TPanelBevel;
         FBevelOuter:TPanelBevel;
         FBevelWidth:LongInt;
         FBorderStyle:TBorderStyle;
         FBorderWidth:LongInt;
         FAlignment:TAlignment;
         FInterior:TRect;
         Procedure CMTextChanged(Var Msg:TMessage); Message CM_TEXTCHANGED;
         Procedure SetBevelInner(NewBevel:TPanelBevel);
         Procedure SetBevelOuter(NewBevel:TPanelBevel);
         Procedure SetBevelWidth(NewWidth:LongInt);
         Procedure SetBorderStyle(NewStyle:TBorderStyle);
         Procedure SetBorderWidth(NewWidth:LongInt);
         Procedure SetAlignment(ta:TAlignment);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure DrawText(Const rec:TRect);Virtual;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property BevelInner:TPanelBevel Read FBevelInner Write SetBevelInner;
         Property BevelOuter:TPanelBevel Read FBevelOuter Write SetBevelOuter;
         Property BevelWidth:LongInt Read FBevelWidth Write SetBevelWidth;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property BorderWidth:LongInt Read FBorderWidth Write SetBorderWidth;
         Property Caption;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
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
         Property OnCommand;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnPaint;
         Property OnResize;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

    TRadioGroup=Class(TGroupBox)
      Private
         FItems:TStrings;
         FRadios:TList;
         FItemIndex:LongInt;
         FColumns:LongInt;
         FOnClick:TNotifyEvent;
         Procedure SetItemIndex(Value:LongInt);
         Procedure SetColumns(Value:LongInt);
         Procedure SetItems(Value:TStrings);
         Procedure SetRadioCount(Value:LongInt);
         Function GetItemsEnabled(Index:LongInt):Boolean;
         Procedure SetItemsEnabled(Index:LongInt;Value:Boolean);
         Procedure UpdateRadios;
         Procedure ArrangeRadios;
         Procedure EvItemsChange(Sender:TObject);
         Procedure EvRadioClick(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Resize;Override;
         Procedure FontChange;Override;
         Procedure Click;Virtual;
         Procedure ItemIndexChange;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property ItemsEnabled[Index:LongInt]:Boolean Read GetItemsEnabled Write SetItemsEnabled;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Caption;
         Property Color;
         Property Columns:LongInt Read FColumns Write SetColumns;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ItemIndex:LongInt Read FItemIndex Write SetItemIndex;
         Property Items:TStrings Read FItems Write SetItems;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

    TCheckGroup=Class(TGroupBox)
      Private
         FItems:TStrings;
         FChecks:TList;
         FItemIndex:LongInt;
         FColumns:LongInt;
         FOnClick:TNotifyEvent;
         Procedure SetItemIndex(Value:LongInt);
         Procedure SetColumns(Value:LongInt);
         Procedure SetItems(Value:TStrings);
         Procedure SetCheckCount(Value:LongInt);
         Function GetItemsEnabled(Index:LongInt):Boolean;
         Procedure SetItemsEnabled(Index:LongInt;Value:Boolean);
         Procedure UpdateChecks;
         Procedure ArrangeChecks;
         Procedure EvItemsChange(Sender:TObject);
         Procedure EvCheckClick(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Resize;Override;
         Procedure FontChange;Override;
         Procedure Click;Virtual;
         Procedure ItemIndexChange;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property ItemsEnabled[Index:LongInt]:Boolean Read GetItemsEnabled Write SetItemsEnabled;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Caption;
         Property Color;
         Property Columns:LongInt Read FColumns Write SetColumns;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ItemIndex:LongInt Read FItemIndex Write SetItemIndex;
         Property Items:TStrings Read FItems Write SetItems;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

type tOkCancelButtonKind = (okcHorizontal, okcVertical);
Type
  tOKCancelButton=Class(TControl)
    Private
      fBtnOK        : tBitBtn;
      fBtnCancel    : tBitBtn;
      fBtnHelp      : tBitBtn;
      fKind         : tOkCancelButtonKind;
      fOnOKClick    : TNotifyEvent;
      fOnCancelClick: TNotifyEvent;
      fOnHelpClick  : TNotifyEvent;
      fTabStop      : Boolean;

      Procedure SetOBCKind(iKind : tOkCancelButtonKind);
      Procedure SetOBCFont(iFont : tFont);
      Procedure SetTabStop(iTabStop : Boolean);
      Procedure SetOkModalResult(iModalResult : tCommand);
      Function  GetOkModalResult : tCommand;
      Function  GetOBCFont : tFont;

      Procedure OCBOnOKClick(Sender : tObject);
      Procedure OCBOnCancelClick(Sender : tObject);
      Procedure OCBOnHelpClick(Sender : tObject);


    Protected
      Procedure SetupComponent; Override;
      Procedure Resize; Override;
    Public
      Destructor Destroy; Override;
    Published
      Property Align;
      Property Kind         : tOkCancelButtonKind   Read fKind            Write SetOBCKind;
      Property Font         : tFont                 Read GetOBCFont       Write SetOBCFont;
      Property TabStop      : Boolean               Read fTabStop         Write SetTabStop;
      Property TabOrder;
      Property OkModalResult: TCommand              Read GetOkModalResult Write SetOkModalResult;

      Property OnOKClick    : TNotifyEvent          Read FOnOKClick       Write fOnOKClick;
      Property OnCancelClick: TNotifyEvent          Read FOnCancelClick   Write fOnCancelClick;
      Property OnHelpClick  : TNotifyEvent          Read FOnHelpClick     Write fOnHelpClick;
  End;

Function InsertShape(parent:TControl;Left,Bottom,Width,Height:LongInt):TShape;
Function InsertImage(parent:TControl;Left,Bottom,Width,Height:LongInt;BitmapId:LongWord):TImage;
Function InsertImageName(parent:TControl;Left,Bottom,Width,Height:LongInt;Const BitmapId:String):TImage;
Function InsertBevel(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Shape:TBevelShape;Style:TBevelStyle):TBevel;
Function InsertPanel(parent:TControl;Left,Bottom,Width,Height:LongInt;
           BevelInner:TPanelBevel;BevelOuter:TPanelBevel;BevelWidth:LongInt;
           Caption:String):TPanel;
Function InsertRadioGroup(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Caption:String):TRadioGroup;
Function InsertCheckGroup(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Caption:String):TCheckGroup;


Function InsertOKCancelButton(parent      : TControl;
                              Left,Bottom : LongInt) : tOKCancelButton;
Implementation

Function InsertShape(parent:TControl;Left,Bottom,Width,Height:LongInt):TShape;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertImage(Parent:TControl;Left,Bottom,Width,Height:LongInt;
  BitmapId:LongWord):TImage;
Var  Bitmap:TBitmap;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Bitmap.Create;
     Bitmap.LoadFromResourceId(BitmapId);
     Result.Picture.Graphic:=Bitmap;
     Bitmap.Destroy; {#}
     Result.Parent := Parent;
End;

Function InsertImageName(Parent:TControl;Left,Bottom,Width,Height:LongInt;
  Const BitmapId:String):TImage;
Var  Bitmap:TBitmap;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Bitmap.Create;
     Bitmap.LoadFromResourceName(BitmapId);
     Result.Picture.Graphic:=Bitmap;
     Bitmap.Destroy; {#}
     Result.Parent := Parent;
End;


Function InsertBevel(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Shape:TBevelShape;Style:TBevelStyle):TBevel;
Begin
     Result.Create(parent);
     Result.Shape := Shape;
     Result.Style := Style;
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertPanel(parent:TControl;Left,Bottom,Width,Height:LongInt;
  BevelInner:TPanelBevel;BevelOuter:TPanelBevel;BevelWidth:LongInt;
  Caption:String):TPanel;
Begin
     Result.Create(parent);
     Result.BevelInner:=BevelInner;
     Result.BevelOuter:=BevelOuter;
     Result.BevelWidth:=BevelWidth;
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.parent := parent;
End;


Function InsertRadioGroup(parent:TControl;Left,Bottom,Width,Height:LongInt;
                          Caption:String):TRadioGroup;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.Caption := Caption;
  Result.parent := parent;
End;

Function InsertCheckGroup(parent:TControl;Left,Bottom,Width,Height:LongInt;
                          Caption:String):TCheckGroup;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.Caption := Caption;
  Result.parent := parent;
End;

Const cHorzHeight = 30;
      cHorzWidth  = 311;
      cVertHeight = 100;
      cVertWidth  = 100;

Function InsertOKCancelButton(parent : TControl; Left,Bottom : LongInt) : tOKCancelButton;

Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,cHorzWidth,cHorzHeight);
  Result.Parent := parent;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TShape Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TShape.SetupComponent;
Begin
     Inherited SetupComponent;

     Height:=100;
     Width:=100;
     ParentPenColor:=False;
     ParentColor:=True;
     TabStop:=False;
     ZOrder:=zoBottom;
     FShape:=stRectangle;
     FTempBrush.Create(Nil);
     //FTempBrush.Color := clWhite;
     FTempPen.Create(Nil);
End;

Procedure TShape.SetupShow;
Begin
     Inherited SetupShow;

     Canvas.Brush:=FTempBrush;
     Canvas.Pen:=FTempPen;
End;

Destructor TShape.Destroy;
Begin
     Inherited Destroy;

     FTempBrush.Destroy;
     FTempPen.Destroy;
End;

Function TShape.GetBrush:TBrush;
Begin
     If Canvas <> Nil Then Result := Canvas.Brush
     Else Result := FTempBrush;
End;

Function TShape.GetPen:TPen;
Begin
     If Canvas <> Nil Then Result := Canvas.Pen
     Else Result := FTempPen;
End;

Procedure TShape.SetShape(NewShape:TShapeType);
Begin
  FShape:=NewShape;
  Invalidate;
End;

Procedure TShape.SetColor(NewColor : tColor);

Begin
  Brush.Color:=NewColor;
  Refresh;
End;


Function TShape.GetColor : tColor;

Begin
  Result:=Brush.Color;
End;


Procedure TShape.Redraw(Const rec:TRect);
Var SaveColor:TColor;
    OldPenColor,OldBrushColor:TColor;
    SaveStyle:TBrushStyle;
    Radius,middleX,MiddleY,W,H:LongInt;
    rc:TRect;

    Procedure DrawTriangle;
    Begin
         Canvas.PenPos:=Point(0,0);
         Canvas.LineTo(Width,0);
         Canvas.LineTo(Width Div 2,Height);
         Canvas.LineTo(0,0);
    End;
Begin
     If Canvas = Nil Then exit;
     OldPenColor := Canvas.Pen.Color;
     OldBrushColor := Canvas.Brush.Color;

     SaveColor:=Canvas.Pen.color;

     If Canvas.Brush.Style=bsSolid Then Canvas.Pen.color:=Canvas.Brush.color;

     middleX := ClientWidth Div 2;
     MiddleY := ClientHeight Div 2;

     Case FShape Of
       stTriangle:
       Begin
            Canvas.BeginPath;
            DrawTriangle;
            Canvas.EndPath;
            Canvas.FillPath;
            Canvas.Pen.color:=SaveColor;

            Canvas.BeginPath;
            DrawTriangle;
            Canvas.EndPath;
            Canvas.OutlinePath;

            Canvas.BeginPath;
            DrawTriangle;
            Canvas.EndPath;
            Canvas.PathToClipRegion(paDiff);
       End;
       stRectangle,stSquare:
       Begin
            If FShape=stSquare Then
            Begin
                 If Width>Height Then
                 Begin
                      rc.Bottom:=0;
                      rc.Top:=Height-1;
                      rc.Left:=(Width-Height) Div 2;
                      rc.Right:=rc.Left+Height;
                 End
                 Else
                 Begin
                      rc.Left:=0;
                      rc.Right:=Width-1;
                      rc.Bottom:=(Height-Width) Div 2;
                      rc.Top:=rc.Bottom+Width;
                 End;
            End
            Else rc:=ClientRect;

            Canvas.BeginPath;
            Canvas.Rectangle(rc);
            Canvas.EndPath;
            Canvas.FillPath;
            Canvas.Pen.color:=SaveColor;

            Canvas.BeginPath;
            Canvas.Rectangle(rc);
            Canvas.EndPath;
            Canvas.OutlinePath;

            Canvas.BeginPath;
            Canvas.Rectangle(rc);
            Canvas.EndPath;
            Canvas.PathToClipRegion(paDiff);
       End;
       stRoundRect,stRoundSquare:
       Begin
            If FShape=stRoundSquare Then
            Begin
                 If Width>Height Then
                 Begin
                      rc.Bottom:=0;
                      rc.Top:=Height-1;
                      rc.Left:=(Width-Height) Div 2;
                      rc.Right:=rc.Left+Height;
                 End
                 Else
                 Begin
                      rc.Left:=0;
                      rc.Right:=Width-1;
                      rc.Bottom:=(Height-Width) Div 2;
                      rc.Top:=rc.Bottom+Width;
                 End;
            End
            Else rc:=ClientRect;

            W:=(rc.Right-rc.Left) Div 10;
            H:=(rc.Top-rc.Bottom) Div 10;

            Canvas.BeginPath;
            Canvas.RoundRect(rc,W,H);
            Canvas.EndPath;
            Canvas.FillPath;
            Canvas.Pen.color:=SaveColor;

            Canvas.BeginPath;
            Canvas.RoundRect(rc,W,H);
            Canvas.EndPath;
            Canvas.OutlinePath;

            Canvas.BeginPath;
            Canvas.RoundRect(rc,W,H);
            Canvas.EndPath;
            Canvas.PathToClipRegion(paDiff);
       End;
       stEllipse:
       Begin
           Canvas.BeginPath;
           Canvas.Ellipse(middleX,MiddleY,middleX-1,MiddleY-1);
           Canvas.EndPath;
           Canvas.FillPath;
           Canvas.Pen.color:=SaveColor;

           Canvas.BeginPath;
           Canvas.Ellipse(middleX,MiddleY,middleX-1,MiddleY-1);
           Canvas.EndPath;
           Canvas.OutlinePath;

           Canvas.BeginPath;
           Canvas.Ellipse(middleX,MiddleY,middleX-1,MiddleY-1);
           Canvas.EndPath;
           Canvas.PathToClipRegion(paDiff);
       End;
       stCircle:
       Begin
           If ClientWidth>ClientHeight Then Radius:=MiddleY
           Else Radius:=middleX;

           Canvas.BeginPath;
           Canvas.Circle(middleX,MiddleY,Radius-1);
           Canvas.EndPath;
           Canvas.FillPath;
           Canvas.Pen.color:=SaveColor;

           Canvas.BeginPath;
           Canvas.Circle(middleX,MiddleY,Radius-1);
           Canvas.EndPath;
           Canvas.OutlinePath;

           Canvas.BeginPath;
           Canvas.Circle(middleX,MiddleY,Radius-1);
           Canvas.EndPath;
           Canvas.PathToClipRegion(paDiff);
       End;
     End; //Case

     Canvas.Pen.Color := OldPenColor;
     Canvas.Brush.Color := OldBrushColor;

     SaveColor:=Canvas.Pen.color;
     SaveStyle:=Canvas.Brush.Style;

     Canvas.Pen.color:=color;
     Canvas.Brush.Style:=bsSolid;
     Canvas.Box(rec);

     Canvas.Pen.color:=SaveColor;
     Canvas.Brush.Style:=SaveStyle;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TImage Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TImage.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption:=Name;
     Width:=50;
     Height:=50;
     ParentPenColor:=False;
     ParentColor:=True;
     CursorTabStop:=False;
     TabStop:=False;
     FNeedBitmap:=True;
     ZOrder:=zoBottom;
     FAutoSize:=False;
     FStretch:=True;
     FCenter:=False;

     FPicture.Create(Self);
     FPicture.OnChange := PictureChanged;
     Include(FPicture.ComponentState, csDetail);
End;

Procedure TImage.Change;
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;


{$HINTS OFF}
Procedure TImage.PictureChanged(Sender:TObject);
Begin
    Change;
    Invalidate;
End;
{$HINTS ON}

Function TImage.GetTransparentColor  : tColor;

var bmp : tBitmap;

Begin
  Bmp:=getBitmap;
  if bmp=nil
    then Result:=0
    else Result:=Bmp.TransparentColor
End;

Procedure TImage.SetTransparentColor(iColor : tColor);

var bmp : tBitmap;

Begin
  Bmp:=getBitmap;
  if bmp<>nil
    then Bmp.TransparentColor:=iColor;
End;

Procedure TImage.SetStretch(NewValue:Boolean);
Begin
  FStretch:=NewValue;
  Invalidate;
End;

Procedure TImage.SetCenter(NewValue:Boolean);
Begin
     FCenter:=NewValue;
     Invalidate;
End;

//RG 13-Nov-06 
procedure TImage.SetPicture(NewPicture:TPicture);
begin
  if FPicture <> NewPicture
    then FPicture.Assign(NewPicture);
end;


Procedure TImage.SetBitmap(NewBitmap:TBitmap);
Begin
     Picture.Bitmap := NewBitmap;
End;

Function TImage.GetBitmap:TBitmap;
Begin
     If ((Picture.HasFormat(TBitmap))Or(Picture.Empty)) Then
       Result := Picture.Bitmap
     Else
       Result:=Nil;
End;

Function TImage.GetIcon:TIcon;
Begin
     If ((Picture.HasFormat(TIcon))Or(Picture.Empty)) Then
       Result := Picture.Icon
     Else
       Result:=Nil;
End;                 

Procedure TImage.SetIcon(NewIcon:TIcon);
Begin
     Picture.Icon:=NewIcon;
End;

Function TImage.GetGraphic:TGraphic;
Begin
     Result:=Picture.Graphic;
End;

Procedure TImage.SetGraphic(NewGraphic:TGraphic);
Begin
     Picture.Graphic:=NewGraphic;
End;

Procedure TImage.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
       If Form Is TForm Then
     Begin
          Form.BringToFront;

          LastMsg.Handled:=True; {!!}
          LastMsg.Result:=0;
     End;
End;

Procedure TImage.Redraw(Const rec:TRect);
Var  rc:TRect;
     X,Y:LongInt;
     aGraphic:TGraphic;
Label proceed;
Begin
     If Canvas = Nil Then Exit;

     If FPicture.Graphic <> Nil Then
       If not FPicture.Graphic.Empty Then
       Begin
            aGraphic := FPicture.Graphic;
            //clear background for icons and pointers
            If ((aGraphic Is TIcon)Or(aGraphic Is TPointer)
                {Martin: also Metafiles need to clear background}Or (aGraphic Is TMetafile)
                ) Then Inherited Redraw(rec);
            goto proceed;
       End;

     Inherited Redraw(rec);

     If Designed Then
     Begin
          Canvas.DeleteClipRegion;
          Canvas.Brush.color:=color;
          Canvas.Pen.color:=clBlack;
          Canvas.TextOut(4,4,Name);
          rc.Left:=1;
          rc.Top:=Height-1;
          rc.Bottom:=1;
          rc.Right:=Width-1;
          Canvas.Rectangle(rc);
     End;
     Exit;

proceed:
     {If aGraphic Is TBitmap Then
       Bitmap.RealizePalette(Canvas);}
     If Stretch Then Canvas.StretchDraw(0,0,Width,Height,aGraphic)
     Else If ((Center)And(aGraphic.Width<=Width)And(aGraphic.Height<=Height)) Then
     Begin
          X:=Width Div 2;
          Y:=Height Div 2;
          Dec(X,aGraphic.Width Div 2);
          Dec(Y,aGraphic.Height Div 2);
          Canvas.Draw(X,Y,aGraphic);
          rc.Left:=X;
          rc.Right:=X+aGraphic.Width-1;
          rc.Bottom:=Y;
          rc.Top:=Y+aGraphic.Height-1;
          Canvas.ExcludeClipRect(rc);
          Inherited Redraw(rec);
     End
     Else
     Begin
          Canvas.Draw(0,0,aGraphic);
          rc.Left:=0;
          rc.Right:=aGraphic.Width-1;
          rc.Bottom:=0;
          rc.Top:=aGraphic.Height-1;
          Canvas.ExcludeClipRect(rc);
          Inherited Redraw(rec);
     End;
End;

Procedure TImage.SetupShow;
Var  needBMP:Boolean;
     aBMP:TBitmap;
Begin
     needBmp := FALSE;

     If Designed Then
       If FNeedBitmap Then
         If ComponentState * [csDetail,csLoaded] = [] Then needBmp := TRUE;

     If FPicture.Graphic <> Nil Then
       If not FPicture.Graphic.Empty Then needBMP := FALSE;


     If needBMP Then
     Begin
          aBMP := Bitmap;

          If CallClassPropertyEditor(aBMP) = peOk Then
          Begin
               Width := aBMP.Width;
               Height := aBMP.Height;
          End
          Else
          Begin
               //aBMP.Destroy;
               Bitmap := Nil;
          End;
     End;

     {$IFDEF OS2}
     If FPicture.Graphic Is TBitmap Then
        Bitmap.RealizePalette(Canvas);
     {$ENDIF}

     Inherited SetupShow;
End;

Destructor TImage.Destroy;
Begin
     If FPicture <> Nil Then
     Begin
        FPicture.Destroy;
        FPicture := Nil;
     End;

     Inherited Destroy;
End;

Procedure TImage.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnPicture Then
     Begin
          If DataLen <> 0 Then Bitmap.ReadSCUResource(rnBitmap,Data,DataLen);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TImage.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FPicture.Graphic Is TBitmap
     Then Result := Bitmap.WriteSCUResourceName(Stream,rnPicture);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TBevel Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBevel.SetupComponent;
Begin
     Inherited SetupComponent;

     Height:=100;
     Width:=100;
     ParentPenColor:=True;
     ParentColor:=True;
     CursorTabStop:=False;
     TabStop:=False;
     ZOrder:=zoBottom;
     FShape:=bsBox;
     FStyle:=bsLowered;
     Include(ComponentState, csAcceptsControls);
End;

Procedure TBevel.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
       If Form Is TForm Then
     Begin
          Form.BringToFront;

          LastMsg.Handled:=True; {!!}
          LastMsg.Result:=0;
     End;
End;

Procedure TBevel.SetShape(NewShape:TBevelShape);
Begin
     FShape := NewShape;
     If Handle <> 0 Then Invalidate;
End;

Procedure TBevel.SetStyle(NewStyle:TBevelStyle);
Begin
     FStyle := NewStyle;
     If Handle <> 0 Then Invalidate;
End;

Procedure TBevel.Redraw(Const rec:TRect);
Var  rc1:TRect;
     RaisedColor:TColor;
     LoweredColor:TColor;
Begin
     If Canvas = Nil Then Exit;
     Inherited Redraw(rec);

     rc1 := ClientRect;

     If FStyle=bsRaised Then
     Begin
          RaisedColor:=clWhite;
          LoweredColor:=clDkGray;
     End
     Else
     Begin
          RaisedColor:=clDkGray;
          LoweredColor:=clWhite;
     End;

     Case FShape Of
         bsBorder:
         Begin
              If FStyle=bsRaised Then
              Begin
                   Canvas.ShadowedBorder(rc1,clWhite,clBlack);
                   InflateRect(rc1,-1,-1);
                   Canvas.ShadowedBorder(rc1,clLtGray,clDkGray);
              End
              Else
              Begin
                   Canvas.ShadowedBorder(rc1,clDkGray,clWhite);
                   InflateRect(rc1,-1,-1);
                   Canvas.ShadowedBorder(rc1,clBlack,clLtGray);
              End;
         End;
         bsBottomLine:
         Begin
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Left,rc1.Bottom,rc1.Right,rc1.Bottom);
              Inc(rc1.Bottom);
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Left,rc1.Bottom,rc1.Right,rc1.Bottom);
         End;
         bsBox:
         Begin
              Canvas.ShadowedBorder(rc1,RaisedColor,LoweredColor);
         End;
         bsFrame:
         Begin
              DrawSystemFrame(Self,rc1,LoweredColor,RaisedColor);
         End;
         bsLeftLine:
         Begin
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Left,rc1.Bottom);
              Inc(rc1.Left);
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Left,rc1.Bottom);
         End;
         bsRightLine:
         Begin
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Right,rc1.Top,rc1.Right,rc1.Bottom);
              Dec(rc1.Right);
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Right,rc1.Top,rc1.Right,rc1.Bottom);
         End;
         bsTopLine:
         Begin
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Right,rc1.Top);
              Dec(rc1.Top);
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Right,rc1.Top);
         End;
     End; {Case}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPanel Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPanel.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption:=Name;
     Height:=100;
     Width:=100;
     ParentPenColor:=True;
     ParentColor:=True;
     CursorTabStop:=False;
     TabStop:=False;
     ZOrder:=zoBottom;
     FBevelInner:=bvNone;
     FBevelOuter:=bvRaised;
     FBevelWidth:=1;
     FBorderStyle:=bsNone;
     FBorderWidth:=0;
     FAlignment:=taCenter;
     Include(ComponentState, csAcceptsControls);
End;

Procedure TPanel.Redraw(Const rec:TRect);
Var  OuterRaisedColor:TColor;
     OuterLoweredColor:TColor;
     InnerRaisedColor:TColor;
     InnerLoweredColor:TColor;
     rc1:TRect;

  Procedure DrawFrame(rc:TRect;FrameWidth:LongInt;HiColor,LoColor:TColor);
  Var  PointsArray:Array[0..5] Of TPoint;
       offs:LongInt;
  Begin
       offs := FrameWidth-1;

       If FrameWidth > 1 Then
       Begin
            PointsArray[0] := Point(rc.Left,rc.Bottom);
            PointsArray[1] := Point(rc.Left+offs,rc.Bottom+offs);
            PointsArray[2] := Point(rc.Left+offs,rc.Top-offs);
            PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
            PointsArray[4] := Point(rc.Right,rc.Top);
            PointsArray[5] := Point(rc.Left,rc.Top);
            Canvas.Pen.color := HiColor;
            Canvas.Polygon(PointsArray);
            PointsArray[2] := Point(rc.Right-offs,rc.Bottom+offs);
            PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
            PointsArray[4] := Point(rc.Right,rc.Top);
            PointsArray[5] := Point(rc.Right,rc.Bottom);
            Canvas.Pen.color := LoColor;
            Canvas.Polygon(PointsArray);
       End
       Else Canvas.ShadowedBorder(rc1,HiColor,LoColor);
  End;
Begin
     If Canvas = Nil Then Exit;

     If FBevelInner = bvRaised Then
     Begin
          InnerRaisedColor := clBtnHighlight;
          InnerLoweredColor := clBtnShadow;
     End
     Else
     Begin
          InnerRaisedColor := clBtnShadow;
          InnerLoweredColor := clBtnHighlight;
     End;

     If FBevelOuter = bvRaised Then
     Begin
          OuterRaisedColor := clBtnHighlight;
          OuterLoweredColor := clBtnShadow;
     End
     Else
     Begin
          OuterRaisedColor := clBtnShadow;
          OuterLoweredColor := clBtnHighlight;
     End;

     rc1 := ClientRect;
     DrawSystemBorder(Self,rc1,FBorderStyle);

     If FBevelOuter <> bvNone Then
       If FBevelWidth > 0 Then
     Begin
          DrawFrame(rc1,FBevelWidth,OuterRaisedColor,OuterLoweredColor);
          InflateRect(rc1,-FBevelWidth,-FBevelWidth);
     End;

     If FBorderWidth > 0 Then
     Begin
          DrawFrame(rc1,FBorderWidth,color,color);
          InflateRect(rc1,-FBorderWidth,-FBorderWidth);
     End;

     If FBevelInner <> bvNone Then
       If FBevelWidth > 0 Then
     Begin
          DrawFrame(rc1,FBevelWidth,InnerRaisedColor,InnerLoweredColor);
          InflateRect(rc1,-FBevelWidth,-FBevelWidth);
     End;

     FInterior := rc1;
     DrawText(rec);
End;

{$HINTS OFF}
Procedure TPanel.DrawText(Const rec:TRect);
Var  X,Y,CX,CY:LongInt;
Begin
     If Canvas = Nil Then Exit;

     Canvas.FillRect(FInterior,color);
     Canvas.SetClipRegion([FInterior]);

     {Draw Caption}
     If Caption <> '' Then
     Begin
          Canvas.GetTextExtent(Caption,CX,CY);
          Case FAlignment Of
            taLeftJustify:   X := FInterior.Left+1;
            taRightJustify:  X := FInterior.Right-CX;
            taCenter:        X := (Width-CX) Div 2;
          End;
          Y := (Height-CY) Div 2;
          Canvas.Pen.color := PenColor;
          Canvas.Brush.color := color;
          Canvas.TextOut(X,Y,Caption);
     End;

     Canvas.DeleteClipRegion;  {Win32!}
End;
{$HINTS ON}


Procedure TPanel.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
       If Form Is TForm Then
     Begin
          Form.BringToFront;

          LastMsg.Handled:=True; {!!}
          LastMsg.Result:=0;
     End;
End;


Procedure TPanel.SetBevelInner(NewBevel:TPanelBevel);
Begin
     FBevelInner:=NewBevel;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBevelOuter(NewBevel:TPanelBevel);
Begin
     FBevelOuter:=NewBevel;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBevelWidth(NewWidth:LongInt);
Begin
     If NewWidth<0 Then NewWidth:=0;
     FBevelWidth:=NewWidth;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBorderStyle(NewStyle:TBorderStyle);
Begin
     FBorderStyle:=NewStyle;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBorderWidth(NewWidth:LongInt);
Begin
     If NewWidth<0 Then NewWidth:=0;
     FBorderWidth:=NewWidth;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetAlignment(ta:TAlignment);
Begin
     FAlignment:=ta;
     If Handle<>0 Then DrawText(ClientRect);
End;

{$HINTS OFF}
Procedure TPanel.CMTextChanged(Var Msg:TMessage);
Begin
     DrawText(ClientRect);
End;
{$HINTS ON}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TRadioGroup Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TRadioGroup.SetupComponent;
Begin
  Inherited SetupComponent;
  Caption := Name;
  FRadios.Create;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := EvItemsChange;
  FItemIndex := -1;
  FColumns := 1;
End;

Procedure TRadioGroup.SetupShow;
Begin
  Inherited SetupShow;
  UpdateRadios;
  SetItemIndex(FItemIndex);
  ArrangeRadios;
End;


Destructor TRadioGroup.Destroy;
Begin
  SetRadioCount(0);
  FRadios.Destroy;
  FRadios := Nil;
  TStringList(FItems).OnChange := Nil;
  FItems.Destroy;
  FItems := Nil;
  Inherited Destroy;
End;


Procedure TRadioGroup.Resize;
Begin
  Inherited Resize;
  ArrangeRadios;
End;

Procedure TRadioGroup.FontChange;
Var  I:LongInt;
     Radio:TRadioButton;
Begin
  Inherited FontChange;
  For I := 0 To FRadios.Count-1 Do
    Begin
      Radio := TRadioButton(FRadios.Items[I]);
      Radio.Font := Font;
    End;
  ArrangeRadios;
End;

Procedure TRadioGroup.Click;
Begin
  If FOnClick <> Nil Then FOnClick(Self);
End;


Procedure TRadioGroup.SetItemIndex(Value:LongInt);
{$IFDEF WIN32}
var I : integer;
{$ENDIF}
Begin
  If ComponentState * [csReading] <> [] Then
  Begin
    FItemIndex := Value;
    Exit;
  End;

  {Martin}
  {$IFDEF WIN32}
  for I := 0 to FRadios.Count-1 do TRadioButton(FRadios[I]).Checked := False;
  {$ENDIF}
  SetRadioCount(FItems.Count);
  If Value < 0 Then Value := -1;
  If Value >= FRadios.Count Then Value := FRadios.Count-1;
  {deselect old because New Value can be < 0}
  If (FItemIndex >= 0) And (FItemIndex < FRadios.Count)
  Then TRadioButton(FRadios[FItemIndex]).Checked := False;
  FItemIndex := Value;
  If FItemIndex >= 0 {Select New}
  Then TRadioButton(FRadios[FItemIndex]).Checked := True;
  ItemIndexChange;
End;


Procedure TRadioGroup.ItemIndexChange;
Begin
End;


Procedure TRadioGroup.SetColumns(Value:LongInt);
Begin
  If Value <= 0 Then Value := 1;
  If FColumns <> Value Then
  Begin
       FColumns := Value;
       ArrangeRadios;
  End;
End;


Procedure TRadioGroup.SetItems(Value:TStrings);
Begin
  If Value <> FItems Then FItems.Assign(Value);
End;


Procedure TRadioGroup.SetRadioCount(Value:LongInt);
Var  Radio:TRadioButton;
Begin
  While FRadios.Count < Value Do
    Begin
      Radio.Create(Self);
      Include(Radio.ComponentState, csDetail);
      Radio.Font := Font;
      Radio.OnClick := EvRadioClick;
      FRadios.Add(Radio);
    End;
  While FRadios.Count > Value Do
    Begin
      Radio := TRadioButton(FRadios.Last);
      FRadios.Remove(Radio);
      Radio.Destroy;
    End;
End;


Function TRadioGroup.GetItemsEnabled(Index:LongInt):Boolean;
Var  Radio:TRadioButton;
Begin
  Radio := TRadioButton(FRadios.Items[Index]);
  Result := Radio.Enabled;
End;

Procedure TRadioGroup.SetItemsEnabled(Index:LongInt;Value:Boolean);
Var  Radio:TRadioButton;
Begin
  Radio := TRadioButton(FRadios.Items[Index]);
  Radio.Enabled := Value;
End;


Procedure TRadioGroup.UpdateRadios;
Var  I:LongInt;
     Radio:TRadioButton;
Begin
  SetRadioCount(FItems.Count);
  For I := 0 To FItems.Count- 1 Do
  Begin
       Radio := TRadioButton(FRadios.Items[I]);
       Radio.Caption := FItems[I];
  End;
  SetItemIndex(FItemIndex);
  ArrangeRadios;
End;


Procedure TRadioGroup.ArrangeRadios;
Const Margin=10;
Var  I:LongInt;
     Radio:TRadioButton;
     RadioWidth:LongInt;
     RadioHeight:LongInt;
     RadiosPerColumn:LongInt;
     XPos,YPos:LongInt;
     rc:TRect;
Begin
  If Handle = 0 Then Exit;
  If FRadios.Count = 0 Then Exit;
  rc := ClientRect;
  Inc(rc.Left,Margin);
  Inc(rc.Bottom,Margin);
  Dec(rc.Right,Margin);
  Dec(rc.Top,Margin+Font.Height);
  RadiosPerColumn :=  (FRadios.Count + FColumns - 1) Div FColumns;
  RadioWidth := (rc.Right - rc.Left) Div FColumns;
  RadioHeight := (rc.Top - rc.Bottom) Div RadiosPerColumn;
  XPos := rc.Left;
  YPos := rc.Top - RadioHeight;
  For I := 0 To FRadios.Count-1 Do
    Begin
      Radio := TRadioButton(FRadios[I]);
      Radio.SetWindowPos(XPos,YPos,RadioWidth,RadioHeight);
      If Radio.parent = Nil Then Radio.parent := Self;
      If ((I+1) Mod RadiosPerColumn) = 0 Then
        Begin
          YPos := rc.Top - RadioHeight;
          Inc(XPos,RadioWidth);
        End
      Else Dec(YPos,RadioHeight);
    End;
End;


{$HINTS OFF}
Procedure TRadioGroup.EvItemsChange(Sender:TObject);
Begin
  If ComponentState * [csReading] = [] Then
    Begin
      UpdateRadios;
    End;
End;
{$HINTS ON}


Procedure TRadioGroup.EvRadioClick(Sender:TObject);
Begin
  FItemIndex := FRadios.IndexOf(Sender);
  ItemIndexChange;
  Click;
End;

Function TRadioGroup.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  aText:PChar;
Begin
  Result := Inherited WriteSCUResource(Stream);
  If Not Result Then Exit;
  aText := Items.GetText;
  If aText <> Nil Then
    Begin
      Result := Stream.NewResourceEntry(rnItems,aText^,Length(aText^)+1);
      StrDispose(aText);
    End;
End;


Procedure TRadioGroup.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  aText:PChar;
Begin
  If ResName = rnItems Then
    Begin
      aText := @Data;
      Items.SetText(aText);
    End
  Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TCheckGroup Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCheckGroup.SetupComponent;
Begin
  Inherited SetupComponent;
  Caption := Name;
  FChecks.Create;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := EvItemsChange;
  FItemIndex := -1;
  FColumns := 1;
End;

Procedure TCheckGroup.SetupShow;
Begin
  Inherited SetupShow;
  UpdateChecks;
  SetItemIndex(FItemIndex);
  ArrangeChecks;
End;


Destructor TCheckGroup.Destroy;
Begin
  SetCheckCount(0);
  FChecks.Destroy;
  FChecks := Nil;
  TStringList(FItems).OnChange := Nil;
  FItems.Destroy;
  FItems := Nil;
  Inherited Destroy;
End;

Procedure TCheckGroup.Resize;
Begin
  Inherited Resize;
  ArrangeChecks;
End;

Procedure TCheckGroup.FontChange;
Var  I:LongInt;
     Check:tCheckBox;
Begin
  Inherited FontChange;
  For I := 0 To FChecks.Count-1 Do
    Begin
      Check := TCheckBox(FChecks.Items[I]);
      Check.Font := Font;
    End;
  ArrangeChecks;
End;

Procedure TCheckGroup.Click;
Begin
  If FOnClick <> Nil Then FOnClick(Self);
End;

Procedure TCheckGroup.SetItemIndex(Value:LongInt);
{$IFDEF WIN32}
var I : integer;
{$ENDIF}
Begin
  If ComponentState * [csReading] <> [] Then
  Begin
    FItemIndex := Value;
    Exit;
  End;

  {Martin}
  {$IFDEF WIN32}
  for I := 0 to FChecks.Count-1 do
    TCheckBox(fChecks[I]).Checked := False;
  {$ENDIF}
  SetCheckCount(FItems.Count);
  If Value < 0
    Then Value := -1;
  If Value >= FChecks.Count
    Then Value := FChecks.Count-1;
  {deselect old because New Value can be < 0}
  If (FItemIndex >= 0) And (FItemIndex < FChecks.Count)
    Then TCheckBox(fChecks[FItemIndex]).Checked := False;
  FItemIndex := Value;
  If FItemIndex >= 0 {Select New}
    Then TCheckBox(FChecks[FItemIndex]).Checked := True;
  ItemIndexChange;
End;


Procedure TCheckGroup.ItemIndexChange;
Begin
End;


Procedure TCheckGroup.SetColumns(Value:LongInt);
Begin
  If Value <= 0 Then Value := 1;
  If FColumns <> Value Then
  Begin
       FColumns := Value;
       ArrangeChecks;
  End;
End;


Procedure TCheckGroup.SetItems(Value:TStrings);
Begin
  If Value <> FItems Then
    FItems.Assign(Value);
End;


Procedure TCheckGroup.SetCheckCount(Value:LongInt);

Var Check:TCheckBox;

Begin
  While FChecks.Count < Value Do
    Begin
      Check.Create(Self);
      Include(Check.ComponentState, csDetail);
      Check.Font := Font;
      Check.OnClick := EvCheckClick;
      FChecks.Add(Check);
    End;
  While FChecks.Count > Value Do
    Begin
      Check := TCheckBox(FChecks.Last);
      FChecks.Remove(Check);
      Check.Destroy;
    End;
End;


Function TCheckGroup.GetItemsEnabled(Index:LongInt):Boolean;
Var Check:TCheckBox;
Begin
  Check := TCheckBox(FChecks.Items[Index]);
  Result := Check.Enabled;
End;

Procedure TCheckGroup.SetItemsEnabled(Index:LongInt;Value:Boolean);
Var Check:TCheckBox;
Begin
  Check := TCheckBox(FChecks.Items[Index]);
  Check.Enabled := Value;
End;


Procedure TCheckGroup.UpdateChecks;
Var  I:LongInt;
     Check:TCheckBox;
Begin
  SetCheckCount(FItems.Count);
  For I := 0 To FItems.Count- 1 Do
    Begin
      Check := TCheckBox(FChecks.Items[I]);
      Check.Caption := FItems[I];
    End;
  SetItemIndex(FItemIndex);
  ArrangeChecks;
End;


Procedure TCheckGroup.ArrangeChecks;
Const Margin=10;
Var  I          : LongInt;
     Check      : TCheckBox;
     CheckWidth : LongInt;
     CheckHeight: LongInt;
     ChecksPerColumn:LongInt;
     XPos,YPos  : LongInt;
     rc:TRect;
Begin
  If Handle = 0 Then Exit;
  If FChecks.Count = 0 Then Exit;
  rc := ClientRect;
  Inc(rc.Left,Margin);
  Inc(rc.Bottom,Margin);
  Dec(rc.Right,Margin);
  Dec(rc.Top,Margin+Font.Height);
  ChecksPerColumn :=  (FChecks.Count + FColumns - 1) Div FColumns;
  CheckWidth := (rc.Right - rc.Left) Div FColumns;
  CheckHeight := (rc.Top - rc.Bottom) Div ChecksPerColumn;
  XPos := rc.Left;
  YPos := rc.Top - CheckHeight;
  For I := 0 To FChecks.Count-1 Do
    Begin
      Check := TCheckBox(FChecks[I]);
      Check.SetWindowPos(XPos,YPos,CheckWidth,CheckHeight);
      If Check.parent = Nil Then Check.parent := Self;
      If ((I+1) Mod ChecksPerColumn) = 0 Then
        Begin
          YPos := rc.Top - CheckHeight;
          Inc(XPos,CheckWidth);
        End
      Else Dec(YPos,CheckHeight);
    End;
End;


{$HINTS OFF}
Procedure TCheckGroup.EvItemsChange(Sender:TObject);
Begin
  If ComponentState * [csReading] = [] Then
    Begin
      UpdateChecks;
    End;
End;
{$HINTS ON}


Procedure TCheckGroup.EvCheckClick(Sender:TObject);
Begin
  FItemIndex := FChecks.IndexOf(Sender);
  ItemIndexChange;
  Click;
End;

Function TCheckGroup.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  aText:PChar;
Begin
  Result := Inherited WriteSCUResource(Stream);
  If Not Result Then Exit;
  aText := Items.GetText;
  If aText <> Nil Then
    Begin
      Result := Stream.NewResourceEntry(rnItems,aText^,Length(aText^)+1);
      StrDispose(aText);
    End;
End;


Procedure TCheckGroup.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  aText:PChar;
Begin
  If ResName = rnItems Then
    Begin
      aText := @Data;
      Items.SetText(aText);
    End
  Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPaintBox Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPaintBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Height:=200;
     Width:=200;
     ParentPenColor:=True;
     ParentColor:=True;
     TabStop:=False;
     ZOrder:=zoBottom;
End;


Procedure TPaintBox.Redraw(Const rec:TRect);
Var rc:TRect;
Begin
     Inherited Redraw(rec);

     If Designed Then
     Begin
          rc:=ClientRect;
          Canvas.Brush.color:=color;
          Canvas.Pen.color:=clBlack;
          Canvas.TextOut(20,20,'PaintBox');
          Canvas.Pen.Style := psDash;
          Canvas.Brush.Style := bsClear;
          Canvas.Rectangle(rc);
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section:  tOKCancelButton Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tOKCancelButton.OCBOnOKClick(Sender : tObject);

Begin
  if fOnOKClick<>nil then fOnOKClick(Self);
End;

Procedure tOKCancelButton.OCBOnCancelClick(Sender : tObject);

Begin
  if fOnCancelClick<>nil then fOnCancelClick(Self);
End;

Procedure tOKCancelButton.OCBOnHelpClick(Sender : tObject);

Begin
  if Form.HelpContext <> 0 then
    Application.HelpContext(Form.HelpContext);
  if fOnHelpClick<>nil then fOnHelpClick(Self);
End;

Procedure tOKCancelButton.SetOBCFont(iFont : tFont);

Begin
  fbtnOk.Font    :=iFont;
  fbtnCancel.Font:=iFont;
  fbtnHelp.Font  :=iFont;
End;

Procedure tOKCancelButton.SetTabStop(iTabStop : Boolean);

Begin
  fTabStop          := iTabStop;
  fBtnOk.TabStop    := iTabStop;
{  fBtnCancel.TabStop:= iTabStop;
  fBtnHelp.TabStop  := iTabStop; }
End;

Function  tOKCancelButton.GetOBCFont : tFont;

Begin
  Result:=fbtnOk.Font;
End;

Procedure tOKCancelButton.SetOBCKind(iKind : tOkCancelButtonKind);

Begin
  fKind := iKind;
  Resize;
End;

Procedure tOKCancelButton.SetOkModalResult(iModalResult : tCommand);

Begin
  fbtnOk.ModalResult:=iModalResult;
End;

Function  tOKCancelButton.GetOkModalResult : tCommand;

Begin
  Result:=fbtnOk.ModalResult
End;

Procedure tOKCancelButton.Resize;

Var OKPoint    : tPoint;
    CancelPoint: tPoint;
    HelpPoint  : tPoint;

Begin
  if fKind = okcHorizontal
    then
      Begin
        Height:=cHorzHeight;
        Width :=cHorzWidth;
        OKPoint.X:=0;
        OKPoint.Y:=0;
        CancelPoint.X:=105;
        CancelPoint.Y:=0;
        HelpPoint.X:=210;
        HelpPoint.Y:=0;
      End
    else
      Begin
        Height:=cVertHeight;
        Width :=cVertWidth;
        OKPoint.X:=0;
        OKPoint.Y:=2*cHorzHeight+10;
        CancelPoint.X:=0;
        CancelPoint.Y:=cHorzHeight + 5;
        HelpPoint.X:=0;
        HelpPoint.Y:=0;
      End;

  fbtnOk.SetWindowPos(OKPoint.X, OKPoint.Y, cVertWidth, cHorzHeight);
  fbtnCancel.SetWindowPos(CancelPoint.X, CancelPoint.Y, cVertWidth, cHorzHeight);
  fbtnHelp.SetWindowPos(HelpPoint.X, HelpPoint.Y, cVertWidth, cHorzHeight);

  Inherited Resize;
End;

Procedure tOKCancelButton.SetupComponent;
Begin
  Inherited SetupComponent;
  Name:='OkCancelButton';
  Width:=cHorzWidth;;
  Height:=cHorzHeight;
  ParentPenColor:= True;
  ParentColor:= True;
  Inherited TabStop := false;   { Damit kann das Controlselber nicht angesprungen werden }

  fBtnOK:= InsertBitBtn(Self, 0,   0, cVertWidth, cHorzHeight,  bkOK,
                 '~' + LoadNLSStr(SOk), '');
  fBtnOk.Name      := 'btnOCBOK';
  fBtnOk.OnClick   := OCBOnOKClick;
  fBtnOk.TabStop   := true;
  fBtnOk.ParentFont:= true;

  fBtnCancel:= InsertBitBtn(Self, 105, 0, cVertWidth, cHorzHeight,  bkCancel,
                 '~' + LoadNLSStr(SCancel), '');
  fBtnCancel.Name      := 'btnOCBCancel';
  fBtnCancel.OnClick   := OCBOnCancelClick;
  fBtnCancel.TabStop   := true;
  fBtnCancel.ParentFont:= true;

  fBtnHelp  := InsertBitBtn(Self, 210, 0, cVertWidth, cHorzHeight,  bkHelp,
                 '~' + LoadNLSStr(SHelp), '');
  fBtnHelp.Name      := 'btnOCBHelp';
  fBtnHelp.OnClick   := OCBOnHelpClick;
  fBtnHelp.TabStop   := true;
  fBtnHelp.ParentFont:= true;

  If Designed
    then
      Begin
        Include(fBtnOk.ComponentState, csDetail);
        Include(fBtnCancel.ComponentState, csDetail);
        Include(fBtnHelp.ComponentState, csDetail);
      End
    else fBtnHelp.Enabled:=Application.HelpFile <> '';

  fKind:=okcHorizontal;

  setTabStop(true);
End;

Destructor tOKCancelButton.Destroy;
Begin
  Inherited Destroy;
End;


Begin
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  08-Aug-04  MV         minor adaption to tMetafile
                               fixed: Radiogroup button sometimes not set
  27-Aug-05  WD         Komponete "tOKCancelButton" eingebaut
  13-Nov-06  RG         TImage.SetPicture eingebaut
  28-Jan-07  WD         tShape.Set/GetColor: Property eingebaut.
  17-Sep-08  WD         tImage: Property "SetTransparentColor" eingebaut.
  20-Sep-08  WD         tOKCancelButton: Property "OkModalResult" eingebaut.
  17-Mar-09  WD         TCheckGroup: Eingebaut.
}
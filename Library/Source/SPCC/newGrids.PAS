
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit newGrids;
                           
Interface         
                            
{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmGpi,PmDev,PmStdDlg;
{$ENDIF}

{$IFDEF Win32}
Uses WinDef,WinBase,WinNt,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Dos,Color,Classes,Forms,Graphics,Buttons,StdCtrls,Dialogs,Mask,
     uList,
     uStream;


Type
    {$M+}
    newTGridOptions=Set Of (goBorder,goRowSizing,goColSizing,goEditing,
                         goAlwaysShowEditor,goShowSelection,goAlwaysShowSelection,
                         goMouseSelect);

    newTSelectCell=Procedure(Sender:TObject;Col,Row:LongInt) Of Object;
    {$M-}

    newPGridWidthArray=^newTGridWidthArray;
    newTGridWidthArray=Array[0..$0FFFFFFF] Of LongInt;


    newTGridDrawState=Set Of (gdSelected,gdFocused,gdFixed);

    newTGridCoord=Record
                    X:LongInt;
                    Y:LongInt;
    End;

    newTGridRect=Record
       Case Integer Of
         0:(Left, Top, Right, Bottom:LongInt);
         1:(TopLeft, BottomRight:newTGridCoord);
    End;

    {custom Grid}
    newTGrid=Class(TControl)
      Private
         FUpdateLocked:Boolean;
         FFixedColor:TColor;
         FFixedRows:LongInt;
         FFixedCols:LongInt;
         FDefaultColWidth:LongInt;
         FDefaultRowHeight:LongInt;
         FColCount:LongInt;
         FRowCount:LongInt;
         FColWidths:newPGridWidthArray;
         FRowHeights:newPGridWidthArray;
         FColList:TList;  {List Of TColEntry}
         FScrollBars:TScrollStyle;
         FSizeCol:LongInt;
         FSizeRow:LongInt;
         FSizeShape:TCursor;
         FSizeStartX,FSizeStartY,FSizeX,FSizeY:LongInt;
         FOptions:newTGridOptions;
         FEntryColor:TColor;
         FGridUpdateLocked:Boolean;
         FSelectCol,FSelectRow:LongInt;
         FOnSelectCell:newTSelectCell;
         FVertScrollBar:TScrollBar;
         FHorzScrollBar:TScrollBar;
         fDblClickSizing : Boolean;
         FGridLineWidth: LongInt;  //RG April-2011
      Protected
         FLeftExtent,FUpExtent:LongInt;
         FLeftScrolled,FUpScrolled:LongInt;
      Private
         Procedure SetFixedColor(NewColor:TColor);
         Procedure SetFixedRows(NewRows:LongInt);
         Procedure SetFixedCols(NewCols:LongInt);
         Procedure SetDefaultColWidth(NewWidth:LongInt);
         Procedure SetDefaultRowHeight(NewHeight:LongInt);
         Procedure SetColCount(NewCount:LongInt);
         Procedure SetRowCount(NewCount:LongInt);
         Procedure SetScrollBars(NewValue:TScrollStyle);
         Procedure CreateHScrollBar;
         Procedure CreateVScrollBar;
         Procedure UpdateScrollBars;
         Function GetSizeItem(Const pt:TPoint;Var Col,Row:LongInt):TCursor;
         Procedure SetOptions(NewOptions:newTGridOptions);
         Procedure SetEntryColor(NewColor:TColor);
         Procedure SetColWidth(Col:LongInt;NewWidth:LongInt);
         Function GetColWidth(Col:LongInt):LongInt;
         Procedure SetRowHeight(Row:LongInt;NewHeight:LongInt);
         Function GetRowHeight(Row:LongInt):LongInt;
         Procedure SetUpdateLocked(NewValue:Boolean);
         Procedure GetGridExtent(Var CX,CY:LongInt);
         Procedure ClearFocus;Virtual;
         Function GetVisibleRowCount:LongInt;
         Function GetVisibleColCount:LongInt;
         Procedure SetTopRow(NewValue:LongInt);
         Procedure SetLeftCol(NewValue:LongInt);
         Function GetGridWidth:LongInt;
         Function GetGridHeight:LongInt;
         Procedure SetCol(NewValue:LongInt);
         Procedure SetRow(NewValue:LongInt);
         Procedure SetCellColors(Col,Row:LongInt;AState:newTGridDrawState);
         Function GetSelection:newTGridRect;
         Procedure SetSelection(NewValue:newTGridRect);
         Function ScrollHorzTrack(ScrollBar:TScrollBar;NewPosition:LongInt):LongInt;
         Function ScrollVertTrack(ScrollBar:TScrollBar;NewPosition:LongInt):LongInt;
         Procedure SetScrollBar(ScrollBar:TScrollBar;NewValue:LongInt);Virtual;
         procedure SetGridLineWidth(Value: LongInt); //RG April-2011
      Protected
         Procedure SetupComponent;Override;
         Procedure Resize;Override;
         Procedure Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LonGInT);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure KillFocus;Override;
         Procedure SetFocus;Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Function CellRect(Col,Row:LongInt):TRect;
         Function SelectCell(Col,Row:LongInt):Boolean;Virtual;
         Procedure UpdateGridContents(NewCols,NewRows:LongInt);Virtual;
         Procedure DrawCell(Col,Row:LongInt;rec:TRect;AState:newTGridDrawState);Virtual;
         Procedure SetupCellColors(Col,Row:LongInt;AState:newTGridDrawState;Var background,ForeGround:TColor);Virtual;
         Procedure RowHeightChanged(Row:LongInt);Virtual;
         Procedure ColWidthChanged(Col:LongInt);Virtual;
         Procedure MouseDblClickSizing(Col:LongInt);Virtual;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Destructor Destroy;Override;
         Procedure Show;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure BeginUpdate;
         Procedure EndUpdate;
      Public
         Property GridRects[Col,Row:LongInt]:TRect Read CellRect;
         Property ColWidths[Col:LongInt]:LongInt Read GetColWidth Write SetColWidth;
         Property RowHeights[Row:LongInt]:LongInt Read GetRowHeight Write SetRowHeight;
         Property GridUpdateLocked:Boolean Read FGridUpdateLocked Write SetUpdateLocked;
         Property Col:LongInt Read FSelectCol Write SetCol;
         Property Row:LongInt Read FSelectRow Write SetRow;
         Property Selection:newTGridRect Read GetSelection Write SetSelection;
         Property VisibleRowCount:LongInt Read GetVisibleRowCount;
         Property VisibleColCount:LongInt Read GetVisibleColCount;
         Property TopRow:LongInt Read FUpScrolled Write SetTopRow;
         Property LeftCol:LongInt Read FLeftScrolled Write SetLeftCol;
         Property GridWidth:LongInt Read GetGridWidth;
         Property GridHeight:LongInt Read GetGridHeight;
         Property FixedColor:TColor Read FFixedColor Write SetFixedColor;
         Property FixedRows:LongInt Read FFixedRows Write SetFixedRows;
         Property FixedCols:LongInt Read FFixedCols Write SetFixedCols;
         Property DefaultColWidth:LongInt Read FDefaultColWidth Write SetDefaultColWidth;
         Property DefaultRowHeight:LongInt Read FDefaultRowHeight Write SetDefaultRowHeight;
         Property ColCount:LongInt Read FColCount Write SetColCount;
         Property RowCount:LongInt Read FRowCount Write SetRowCount;
         Property ScrollBars:TScrollStyle Read FScrollBars Write SetScrollBars;
         Property Options:newTGridOptions Read FOptions Write SetOptions;
         Property EntryColor:TColor Read FEntryColor Write SetEntryColor;
         Property VertScrollBar:TScrollBar Read FVertScrollBar;
         Property HorzScrollBar:TScrollBar Read FHorzScrollBar;
         property GridLineWidth: Longint read FGridLineWidth write SetGridLineWidth default 1; //RG April-2011

         Property OnSelectCell:newTSelectCell Read FOnSelectCell Write FOnSelectCell;
         Property OnClick;
         property OnExit;     //RG
         Property OnKeyPress; //RG
      Published
         Property PopupMenu;
    End;


    newTStringGridData=Class
         Data:PString;
    End;

    newTStringGrid=Class;

    {$M+}
    newTGetCellEvent=Procedure(Grid:newTStringGrid;Col,Row:LongInt;Var Result:String) Of Object;
    newTSetCellEvent=Procedure(Grid:newTStringGrid;Col,Row:LongInt;Var NewContent:String) Of Object;
    newTCanEditEvent=Procedure(Grid:newTStringGrid;Col,Row:LongInt;Var AllowEdit:Boolean) Of Object;
    {$M-}

    newTInplaceEdit=Class
        Private
            Procedure SetInternalText(Const NewValue:String);
            Function GetInternalControl:TControl;
            Constructor Create(Grid:newTGrid;Col,Row:LongInt);Virtual;
        Private
            FGrid:newTGrid;
            FCol,FRow:LongInt;
        Protected
            Function GetText:String;Virtual;Abstract;
            Procedure SetText(Const NewValue:String);Virtual;Abstract;
            Function GetControl:TControl;Virtual;Abstract;
            Procedure SetWindowPos(X,Y,W,H:LongInt);Virtual;Abstract;
            Procedure Show;Virtual;Abstract;
            Procedure Hide;Virtual;Abstract;
        Public
            Procedure SetupEdit(Grid:newTGrid);Virtual;Abstract;
            Destructor Destroy;Virtual;
        Public
            Property Text:String read GetText write SetInternalText;
            Property Control:TControl read GetInternalControl;
            Property Grid:newTGrid read FGrid;
            Property Col:LongInt read FCol;
            Property Row:LongInt read FRow;
    End;
    newTInplaceEditClass=Class Of newTInplaceEdit;

    {$M+}
    newTOnShowEditor=Function(Sender:newTGrid;Col,Row:LongInt):newTInplaceEditClass Of Object;

    newTGetEditEvent=Procedure(Sender:TObject;ACol,ARow:Longint;Var Value:String) Of Object;
    newTSetEditEvent=Procedure(Sender:TObject;ACol,ARow:Longint;Const Value:String) Of Object;
    newTDrawCellEvent=Procedure(Sender:TObject;ACol,ARow:LongInt;
                             rc:TRect;State:newTGridDrawState) Of Object;
    {$M-}

    newTStringGrid=Class(newTGrid)
      Private
         FEdit:newTInplaceEdit;
         FColumns:TList;
         FOnGetCell:newTGetCellEvent;
         FOnSetCell:newTSetCellEvent;
         FOnCanEdit:newTCanEditEvent;
         FOnDrawCell:newTDrawCellEvent;
         FEditorMode:Boolean;
         FAlignment:TAlignment; //En
         FOnShowEditor:newTOnShowEditor;
         FOnGetEditMask:newTGetEditEvent;
         FOnGetEditText:newTGetEditEvent;
         FOnSetEditText:newTSetEditEvent;
         Procedure EvEntryKillFocus(Sender:TObject);
         Procedure ShowEntry(S:String);
         Procedure ClearFocus;Override;
         Procedure ShowEditorIntern;
         Procedure HideEditorIntern;
         Procedure SetEditorMode(NewValue:Boolean);
      Protected
         Function GetCell(Col,Row:LongInt):String;Virtual;
         Procedure SetCell(Col,Row:LongInt;Const NewContent:String);Virtual;
         Procedure DrawCell(Col,Row:LongInt;rec:TRect;AState:newTGridDrawState);Override;
         Procedure SetupCellDrawing(Col,Row:LongInt;AState:newTGridDrawState;
                                    Var Alignment:TAlignment;Var Font:TFont);Virtual;
         Function SelectCell(Col,Row:LongInt):Boolean;Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure Resize;Override;
         Function ShowEditor(Col,Row:LongInt):newTInplaceEditClass;Virtual;
         Procedure MouseDblClickSizing(Col:LongInt);Override;
         Procedure SetupComponent;Override; //En
      Public
         Destructor Destroy;Override;
         Function IndexOf(Const iSt : String; iCol, iRow : LongInt) : tPoint;

         Property Cells[Col,Row:LongInt]:String Read GetCell Write SetCell;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
         Property EditorMode:Boolean Read FEditorMode Write SetEditorMode;
         Property InplaceEdit:newTInplaceEdit read FEdit;
      Published
         Property Align;
         Property Alignment:TAlignment READ FAlignment Write FAlignment; //En
         Property Color;
         Property ColCount;
         Property PenColor;
         Property DefaultColWidth;
         Property DefaultRowHeight;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property EntryColor;
         Property Font;
         Property FixedColor;
         Property FixedCols;
         Property FixedRows;
         Property Options;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property RowCount;
         Property ScrollBars;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnCanEdit:newTCanEditEvent Read FOnCanEdit Write FOnCanEdit;
         Property OnCommand;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnGetCell:newTGetCellEvent Read FOnGetCell Write FOnGetCell;
         Property OnSetCell:newTSetCellEvent Read FOnSetCell Write FOnSetCell;
         Property OnKeyPress;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnResize;
         Property OnScan;
         Property OnSelectCell;
         Property OnSetupShow;
         Property OnStartDrag;
         Property OnDrawCell:newTDrawCellEvent Read FOnDrawCell Write FOnDrawCell;
         Property OnShowEditor:newTOnShowEditor read FOnShowEditor write FOnShowEditor;
         Property OnGetEditMask:newTGetEditEvent read FOnGetEditMask write FOnGetEditMask;
         Property OnGetEditText:newTGetEditEvent read FOnGetEditText write FOnGetEditText;
         Property OnSetEditText:newTSetEditEvent read FOnSetEditText write FOnSetEditText;
    End;

    {$M+}
    newTOpenEditorEvent=Procedure(Sender:TObject;ACol,ARow:LongInt) Of Object;
    {$M-}

    newTDrawGrid=Class(newTGrid)
      Private
         FOnDrawCell:newTDrawCellEvent;
         FDefaultDrawing:Boolean;
         FEditorMode:Boolean;
         FOnOpenEditor:newTOpenEditorEvent;
         FOnCloseEditor:TNotifyEvent;
      Private
         Procedure SetDefaultDrawing(NewValue:Boolean);
         Procedure SetEditorMode(NewValue:Boolean);
         Procedure ShowEditor;
         Procedure HideEditor;
      Protected
         Procedure SetupComponent;Override;
         Procedure DrawCell(Col,Row:LongInt;rec:TRect;AState:newTGridDrawState);Override;
         Function SelectCell(Col,Row:LongInt):Boolean;Override;
         Procedure CloseEditor;Virtual;
         Procedure OpenEditor(Col,Row:LongInt);Virtual;
      Public
         Procedure SetupCellColors(Col,Row:LongInt;AState:newTGridDrawState;Var background,ForeGround:TColor);Override;
         Procedure MouseToCell(X,Y:LongInt;Var ACol,ARow:LongInt);
      Public
         Property EditorMode:Boolean Read FEditorMode Write SetEditorMode;
      Published
         Property FixedColor;
         Property FixedRows;
         Property FixedCols;
         Property DefaultColWidth;
         Property DefaultRowHeight;
         Property ColCount;
         Property RowCount;
         Property ScrollBars;
         Property Options;
         Property EntryColor;
         property GridLineWidth; //RG April-2011

         Property OnSelectCell;
         Property OnClick;           { OnClick:TNotifyEvent Read FOnClick Write FOnClick; }
         Property OnDrawCell:newTDrawCellEvent Read FOnDrawCell Write FOnDrawCell;
         Property OnOpenEditor:newTOpenEditorEvent Read FOnOpenEditor Write FOnOpenEditor;
         Property OnCloseEditor:TNotifyEvent Read FOnCloseEditor Write FOnCloseEditor;
         Property DefaultDrawing:Boolean Read FDefaultDrawing Write SetDefaultDrawing;
         property OnExit; //RG       { OnExit:TNotifyEvent Read FOnExit Write FOnExit; }
        {Property OnKeyDown;} //RG
         Property OnKeyPress; //RG   { OnKeyPress:TKeyPressEvent Read FOnKeyPress Write FOnKeyPress; }
    End;

Function newInsertStringGrid(parent:TControl;Left,Bottom,Width,Height:LongInt) : newTStringGrid;


//*** roga
{Zu exportierende Komponenten definieren}
{Sie k”nnen eine Seite der Komponentenpalette und eine Bitmapdatei fr die Komponente angeben}
Exports
  newTDrawGrid,'BAUSYS','',
  newTStringGrid,'BAUSYS','';
//*** roga


Implementation

Function newInsertStringGrid(parent:TControl;Left,Bottom,Width,Height:LongInt) : newTStringGrid;

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
บ This section: TInplaceEdit Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor newTInplaceEdit.Create(Grid:newTGrid;Col,Row:LongInt);
Begin
     Inherited Create;
     FGrid:=Grid;
     FCol:=Col;
     FRow:=Row;
     SetupEdit(Grid);
End;

Destructor newTInplaceEdit.Destroy;
Begin
    FGrid:=Nil;
    Inherited Destroy;
End;

Procedure newTInplaceEdit.SetInternalText(Const NewValue:String);
Begin
     SetText(NewValue);
End;

Function newTInplaceEdit.GetInternalControl:TControl;
Begin
     Result:=GetControl;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TDefaultEdit Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Type
  TDefaultEdit=Class(newTInplaceEdit)
        Protected
            FEdit:TEdit;
            FEditMask:String;
        Protected
            Function GetText:String;Override;
            Function GetControl:TComponent;Override;
            Procedure SetText(Const NewValue:String);Override;
            Procedure SetWindowPos(X,Y,W,H:LongInt);Override;
            Procedure SetupEdit(Grid:newTGrid);Override;
            Destructor Destroy;Override;
            Procedure Show;Override;
            Procedure Hide;Override;
    End;

Function TDefaultEdit.GetText:String;
Begin
     Result:=FEdit.Text;
End;

Function TDefaultEdit.GetControl:TControl;
Begin
     Result:=FEdit;
End;

Procedure TDefaultEdit.SetText(Const NewValue:String);
Begin
     FEdit.Text:=NewValue;
End;

Procedure TDefaultEdit.SetWindowPos(X,Y,W,H:LongInt);
Begin
     FEdit.SetWindowPos(X,Y,W,H);
End;

Procedure TDefaultEdit.SetupEdit(Grid:newTGrid);
Var EditMask:String;
Begin
     EditMask:='';
     If newTStringGrid(Grid).OnGetEditMask<>Nil Then newTStringGrid(Grid).OnGetEditMask(Self,Col,Row,EditMask);

     If FEdit=Nil Then
     Begin
        If EditMask<>'' Then
        Begin
             FEdit:=TMaskEdit.Create(Grid);
             TMaskEdit(FEdit).EditMask:=EditMask;
        End
        Else FEdit.Create(Grid);
        FEdit.BorderStyle:=bsNone;
     End
     Else If ((EditMask<>'')And(not (FEdit Is TMaskEdit))) Then
     Begin
          FEdit.Destroy;
          FEdit:=TMaskEdit.Create(Grid);
          TMaskEdit(FEdit).EditMask:=EditMask;
     End
     Else If ((FEditMask='')And(FEdit Is TMaskEdit)) Then
     Begin
          FEdit.Destroy;
          FEdit.Create(Nil);
     End;
End;

Destructor TDefaultEdit.Destroy;
Begin
     FEdit.Destroy;
     Inherited Destroy;
End;

Procedure TDefaultEdit.Show;
Begin
     FEdit.SelLength := 0; // clear selection
     FEdit.SelStart := Length(FEdit.Text);
     FEdit.Show;
End;

Procedure TDefaultEdit.Hide;
Begin
     FEdit.Hide;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TGrid Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure newTGrid.BeginUpdate;
Begin
  FUpdateLocked:=True;
End;

Procedure newTGrid.EndUpdate;
Begin
  FUpdateLocked:=False;
  UpdateScrollBars;
  Invalidate;
End;

Procedure newTGrid.ClearFocus;
Var rc:TRect;
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)) Then
     Begin
          rc:=GridRects[FSelectCol,FSelectRow];
          FSelectCol:=-1;
          FSelectRow:=-1;
          InvalidateRect(rc);
          Update;
     End;
End;

Procedure newTGrid.KillFocus;
Var rc:TRect;
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)) Then
     Begin
          rc:=GridRects[FSelectCol,FSelectRow];
          InvalidateRect(rc);
          Update;
     End;
     Inherited KillFocus;
End;

Procedure newTGrid.SetFocus;
Var rc:TRect;
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)) Then
     Begin
          rc:=GridRects[FSelectCol,FSelectRow];
          InvalidateRect(rc);
          Update;
     End;
     Inherited SetFocus;
End;


Procedure newTGrid.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Type PGridSizes=^TGridSizes;
     TGridSizes=Record
         EntryType:Byte;
         Index:LongInt;
         Value:LongInt;
     End;
Var  sizes:PGridSizes;
     T:LongInt;
Begin
     If ResName = rnGridSizes Then
     Begin
          sizes:=@Data;
          T:=0;
          While T<DataLen Do
          Begin
               If sizes^.EntryType=1
               Then ColWidths[sizes^.Index]:=sizes^.Value {Col entry}
               Else RowHeights[sizes^.Index]:=sizes^.Value;
               Inc(T,SizeOf(TGridSizes));
               Inc(sizes,SizeOf(TGridSizes));
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function newTGrid.WriteSCUResource(Stream:TResourceStream):Boolean;
Const
     ColEntry:Byte=1;
     RowEntry:Byte=0;
Var  MemStream:TMemoryStream;
     T,t1:LongInt;
     Col:LongInt;
     Row:LongInt;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     MemStream.Create;
     For T:=0 To FColCount-1 Do
     Begin
          Col:=FColWidths^[T];
          If Col<>FDefaultColWidth Then
          Begin
               MemStream.Write(ColEntry,1);
               MemStream.Write(T,4);
               MemStream.Write(Col,4);
          End;
     End;
     For t1:=0 To FRowCount-1 Do
     Begin
          Row:=FRowHeights^[t1];
          If Row<>FDefaultRowHeight Then
          Begin
               MemStream.Write(RowEntry,1);
               MemStream.Write(t1,4);
               MemStream.Write(Row,4);
          End;
     End;
     If MemStream.Size>0
     Then Result:=Stream.NewResourceEntry(rnGridSizes,
                                          MemStream.Memory^,MemStream.Size);
     MemStream.Destroy;
End;

Procedure newTGrid.SetColWidth(Col:LongInt;NewWidth:LongInt);
Begin
     If ((Col<0)Or(Col>=FColCount)) Then Exit;
     If NewWidth<=0 Then NewWidth:=FDefaultColWidth;
     If FColWidths^[Col]=NewWidth Then Exit;
     FColWidths^[Col]:=NewWidth;
     //ClearFocus;
     If Not FUpdateLocked Then Invalidate;
End;

Function newTGrid.GetColWidth(Col:LongInt):LongInt;
Begin
     Result:=0;
     If ((Col<0)Or(Col>=FColCount)) Then Exit;
     Result:=FColWidths^[Col];
End;

Procedure newTGrid.SetRowHeight(Row:LongInt;NewHeight:LongInt);
Begin
     If ((Row<0)Or(Row>=FRowCount)) Then Exit;
     If NewHeight<=0 Then NewHeight:=FDefaultRowHeight;
     If FRowHeights^[Row]=NewHeight Then Exit;
     FRowHeights^[Row]:=NewHeight;
     //ClearFocus;
     If Not FUpdateLocked Then Invalidate;
End;

Function newTGrid.GetRowHeight(Row:LongInt):LongInt;
Begin
     Result:=0;
     If ((Row<0)Or(Row>=FRowCount)) Then Exit;
     Result:=FRowHeights^[Row];
End;

Procedure newTGrid.SetEntryColor(NewColor:TColor);
Begin
     FEntryColor:=NewColor;
     //ClearFocus;
     If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetFixedColor(NewColor:TColor);
Begin
     FFixedColor:=NewColor;
     If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetFixedRows(NewRows:LongInt);
Begin
     If ((NewRows<0)Or(NewRows>=FRowCount)) Then Exit;
     FFixedRows:=NewRows;
     If FSelectRow=-1 Then If FFixedRows<FRowCount Then FSelectRow:=FFixedRows
     Else FSelectRow:=-1;
     //ClearFocus;
     If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetFixedCols(NewCols:LongInt);
Begin
     If ((NewCols<0)Or(NewCols>=FColCount)) Then Exit;
     FFixedCols:=NewCols;
     If FSelectCol=-1 Then If FFixedCols<FColCount Then FSelectCol:=FFixedCols
     Else FSelectCol:=-1;
     //ClearFocus;
     If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetDefaultColWidth(NewWidth:LongInt);
Var T:LongInt;
    P:Pointer;
Begin
     If NewWidth<1 Then Exit;
     P:=FColWidths;
     T:=FColCount;
     Asm
        MOV EDI,P
        MOV ECX,T
        MOV EAX,NewWidth
        CLD
        REP STOSD
     End;
     //ClearFocus;
     FDefaultColWidth:=NewWidth;
     If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetOptions(NewOptions:newTGridOptions);
Begin
  FOptions:=NewOptions;
  If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetDefaultRowHeight(NewHeight:LongInt);
Var T:LongInt;
    P:Pointer;
Begin
     If NewHeight<1 Then Exit;
     P:=FRowHeights;
     T:=FRowCount;
     Asm
        MOV EDI,P
        MOV ECX,T
        MOV EAX,NewHeight
        CLD
        REP STOSD
     End;
     FDefaultRowHeight:=NewHeight;
     //ClearFocus;
     If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetColCount(NewCount:LongInt);
Begin
     If ((NewCount<1)Or(NewCount<FFixedCols)) Then Exit;
     If NewCount=FColCount Then Exit;
     FLeftScrolled:=0;
     FUpScrolled:=0;
     FLeftExtent:=0;
     FUpExtent:=0;
     UpdateGridContents(NewCount,FRowCount);
End;

Procedure newTGrid.SetRowCount(NewCount:LongInt);
Begin
     If ((NewCount<1)Or(NewCount<FFixedRows)) Then Exit;
     If NewCount=FRowCount Then Exit;
     FLeftScrolled:=0;
     FUpScrolled:=0;
     FLeftExtent:=0;
     FUpExtent:=0;
     UpdateGridContents(FColCount,NewCount);
End;

Procedure newTGrid.UpdateScrollBars;
Var MaxWidth,MaxHeight:LongInt;
    viewarea:LongInt;
Begin
     IF FUpdateLocked then exit;
     GetGridExtent(MaxWidth,MaxHeight);

     If ((FVertScrollBar<>Nil)And(FHorzScrollBar<>Nil)) Then
     Begin
          If MaxWidth>Width Then
          Begin
               Inc(MaxHeight,FHorzScrollBar.Height);
               If MaxHeight>Height Then Inc(MaxWidth,FVertScrollBar.Width);
          End
          Else If MaxHeight>Height Then
          Begin
               Inc(MaxWidth,FVertScrollBar.Width);
               If MaxWidth>Width Then Inc(MaxHeight,FHorzScrollBar.Height);
          End;
     End;

     If FHorzScrollBar<>Nil Then
     Begin
          If MaxWidth>Width Then
          Begin
              viewarea:=Width;
              If FVertScrollBar<>Nil Then If MaxHeight>Height Then Dec(viewarea,FVertScrollBar.Width);
              FHorzScrollBar.SetScrollRange(0,MaxWidth,viewarea);
              FHorzScrollBar.Position:=FLeftExtent;
              If FVertScrollBar<>Nil Then
              Begin
                   If MaxHeight>Height Then FHorzScrollBar.Width:=Width-FVertScrollBar.Width
                   Else FHorzScrollBar.Width:=Width;
              End
              Else FHorzScrollBar.Width:=Width;
              If FHorzScrollBar.Handle<>0 Then FHorzScrollBar.Show
              Else FHorzScrollBar.Visible:=True;
          End
          Else FHorzScrollBar.Hide;
     End;

     If FVertScrollBar<>Nil Then
     Begin
          If MaxHeight>Height Then
          Begin
               viewarea:=Height;
               If FHorzScrollBar<>Nil Then If MaxWidth>Width Then Dec(viewarea,FHorzScrollBar.Height);
               FVertScrollBar.SetScrollRange(0,MaxHeight,viewarea);
               FVertScrollBar.Position:=FUpExtent;
               If FHorzScrollBar<>Nil Then
               Begin
                    If MaxWidth>Width Then FVertScrollBar.Height:=Height-FHorzScrollBar.Height
                    Else FVertScrollBar.Height:=Height;
               End
               Else FVertScrollBar.Height:=Height;
               If FVertScrollBar.Handle<>0 Then FVertScrollBar.Show
               Else FVertScrollBar.Visible:=True;
          End
          Else FVertScrollBar.Hide;
     End;
     //ClearFocus;
End;



Procedure newTGrid.Show;
Begin
     Inherited Show;

     UpdateScrollBars;
End;

Procedure newTGrid.Resize;
Begin
  Inherited Resize;

  If FHorzScrollBar<>Nil Then
    Begin
      If FVertScrollBar<>Nil
        Then FHorzScrollBar.Width:=Width-FHorzScrollBar.Height
        Else FHorzScrollBar.Width:=Width;
    End;

  If FVertScrollBar<>Nil Then
    Begin
       If FHorzScrollBar<>Nil
         Then FVertScrollBar.Height:=Height-FVertScrollBar.Width
         Else FVertScrollBar.Height:=Height;
    End;

  FLeftScrolled:=0;
  FUpScrolled:=0;
  FLeftExtent:=0;
  FUpExtent:=0;

  UpdateScrollBars;
End;


Procedure newTGrid.CreateHScrollBar;
Begin
     If FHorzScrollBar<>Nil Then Exit;

     FHorzScrollBar.Create(Nil);
     FHorzScrollBar.Hide;
     InsertControl(FHorzScrollBar);
     FHorzScrollBar.Kind:=sbHorizontal;
     FHorzScrollBar.SetWindowPos(0,0,Width-FHorzScrollBar.Height,FHorzScrollBar.Height);
     FHorzScrollBar.XAlign:=xaLeft;
     FHorzScrollBar.YAlign:=yaBottom;
     Include(FHorzScrollBar.ComponentState, csDetail);
     FHorzScrollBar.HandlesDesignMouse:=True;
     FHorzScrollBar.SetDesigning(False); {!}
End;


Procedure newTGrid.CreateVScrollBar;
Begin
     If FVertScrollBar<>Nil Then Exit;

     FVertScrollBar.Create(Nil);
     FVertScrollBar.Hide;
     InsertControl(FVertScrollBar);
     FVertScrollBar.Kind:=sbVertical;
     FVertScrollBar.SetWindowPos(Width-FVertScrollBar.Width,FVertScrollBar.Width,
                                 FVertScrollBar.Width,Height-FVertScrollBar.Width);
     FVertScrollBar.XAlign:=xaRight;
     FVertScrollBar.YAlign:=yaTop;
     Include(FVertScrollBar.ComponentState, csDetail);
     FVertScrollBar.HandlesDesignMouse:=True;
     FVertScrollBar.SetDesigning(False); {!}
End;


Procedure newTGrid.SetScrollBars(NewValue:TScrollStyle);
Begin
     FScrollBars:=NewValue;
     Case NewValue Of
        ssBoth:
        Begin
             CreateHScrollBar;
             CreateVScrollBar;
        End;
        ssHorizontal:
        Begin
             CreateHScrollBar;
             If FVertScrollBar<>Nil Then FVertScrollBar.Destroy;
             FVertScrollBar:=Nil;
             FHorzScrollBar.Width:=FHorzScrollBar.Width+FHorzScrollBar.Height;
             If FLeftScrolled>0 Then
             Begin
                  FLeftScrolled:=0;
                  FLeftExtent:=0;
                  Invalidate;
             End;
        End;
        ssVertical:
        Begin
             CreateVScrollBar;
             If FHorzScrollBar<>Nil Then FHorzScrollBar.Destroy;
             FHorzScrollBar:=Nil;
             FVertScrollBar.Height:=FVertScrollBar.Height+FVertScrollBar.Width;
             If FUpScrolled>0 Then
             Begin
                  FUpScrolled:=0;
                  FUpExtent:=0;
                  Invalidate;
             End;
        End;
        ssNone:
        Begin
             If FVertScrollBar<>Nil Then FVertScrollBar.Destroy;
             FVertScrollBar:=Nil;
             If FHorzScrollBar<>Nil Then FHorzScrollBar.Destroy;
             FHorzScrollBar:=Nil;
             If ((FLeftScrolled>0)Or(FUpScrolled>0)) Then
             Begin
                  FLeftScrolled:=0;
                  FUpScrolled:=0;
                  FLeftExtent:=0;
                  FUpExtent:=0;
                  Invalidate;
             End;
        End;
     End; {Case}
     UpdateScrollBars;
End;

procedure newTGrid.SetGridLineWidth(Value: LongInt); //RG April-2011
begin
  if FGridLineWidth <> Value then
  begin
    FGridLineWidth := Value;
    Invalidate;
  end;
end;

{$HINTS OFF}
Procedure newTGrid.SetupCellColors(Col,Row:LongInt;AState:newTGridDrawState;Var background,ForeGround:TColor);
Begin
     ForeGround:=PenColor;

     If AState*[gdFixed]<>[] Then
     Begin
          background:=FFixedColor;
     End
     Else
     Begin
          background:=FEntryColor;

          If AState*[gdSelected]<>[] Then If Options*[goShowSelection,goEditing]<>[] Then
          Begin
               If AState*[gdFocused]=[] Then
               Begin
                    If Options*[goAlwaysShowSelection]<>[] Then
                    Begin
                         background:=clHighlight;
                         ForeGround:=clHighlightText;
                    End;
               End
               Else
               Begin
                    If Options*[goAlwaysShowEditor]=[] Then
                    Begin
                         background:=clHighlight;
                         ForeGround:=clHighlightText;
                    End;
               End;
          End;
     End;
End;
{$HINTS ON}

Procedure newTGrid.SetCellColors(Col,Row:LongInt;AState:newTGridDrawState);
Var back,Fore:TColor;
Begin
     SetupCellColors(Col,Row,AState,back,Fore);
     Canvas.Brush.color:=back;
     Canvas.Pen.color:=Fore;
End;

{$HINTS OFF}
Procedure newTGrid.DrawCell(Col,Row:LongInt;rec:TRect;AState:newTGridDrawState);
Var rc:TRect;
Begin
     If Canvas=Nil Then Exit;

     SetCellColors(Col,Row,AState);

     If AState*[gdFixed]<>[] Then
     Begin
          Dec(rec.Top);
          If Col>0 Then Inc(rec.Left);
          {??????+-1}
          Dec(rec.Right);
          Dec(rec.Top);
          Canvas.FillRect(rec,Canvas.Brush.color);
          rc:=Canvas.ClipRect;
          Dec(rc.Bottom);
          If Col=0 Then Dec(rc.Left);
          Canvas.ClipRect:=rc;

          Dec(rec.Bottom);
          Dec(rec.Left);
          Canvas.ShadowedBorder(rec,clWhite,clDkGray);

          Inc(rc.Bottom);
          Inc(rc.Left);
          Canvas.ClipRect:=rc;
     End
     Else
     Begin
          {??????+-1}
          Dec(rec.Right);
          Dec(rec.Top);
          Canvas.FillRect(rec,Canvas.Brush.color);
          If AState*[gdFocused]<>[] Then
          Begin
               //InflateRect(rec,-1,-1);
               Dec(rec.Right);
               Dec(rec.Top);
               Canvas.DrawFocusRect(rec);
          End;
     End;
End;
{$HINTS ON}

Procedure newTGrid.Redraw(Const rec:TRect);
Var T,t1:LongInt;
    X,Y:LongInt;
    RowHeight:LongInt;
    ColWidth:LongInt;
    rc1,rc2,rec1,rcSave:TRect;
    MaxWidth,MaxHeight:LongInt;
    LeftCount,UpCount:LongInt;
    DrawIt:Boolean;
    AState:newTGridDrawState;
Label Ende;
Begin
     If Canvas=Nil Then Exit;
     If FGridUpdateLocked Then Exit;
     Dec(rec.Left);
     Inc(rec.Top);
     rec1:=rec;
     If Options*[goBorder]<>[] Then If rec1.Right>Width-1 Then rec1.Right:=Width-1;
     If ((FHorzScrollBar<>Nil)And(FHorzScrollBar.Visible)) Then
       If rec1.Bottom<FHorzScrollBar.Height Then rec1.Bottom:=FHorzScrollBar.Height;
     If ((FVertScrollBar<>Nil)And(FVertScrollBar.Visible)) Then
       If rec1.Right>Width-FVertScrollBar.Width Then rec1.Right:=Width-FVertScrollBar.Width;
     Canvas.SetClipRegion([rec1]);

     {Draw contents}
     If Options*[goBorder]<>[] Then X:=1
     Else X:=0;
     MaxWidth:=0;
     MaxHeight:=0;
     LeftCount:=1;
     For T:=0 To FColCount-1 Do
     Begin
          If Options*[goBorder]<>[] Then Y:=Height-1
          Else Y:=Height;
          ColWidth:=FColWidths^[T];
          UpCount:=1;
          For t1:=0 To FRowCount-1 Do
          Begin
               If Y>0 Then
               Begin
                    If ((T+1<=FFixedCols)And(t1+1<=FFixedRows)) Then DrawIt:=True {Ecke(N) links oben}
                    Else
                    Begin
                         If ((T+1<=FFixedCols)And(UpCount>FUpScrolled)) Then DrawIt:=True
                         Else If ((t1+1<=FFixedRows)And(LeftCount>FLeftScrolled)) Then DrawIt:=True
                         Else If ((UpCount>FUpScrolled)And(LeftCount>FLeftScrolled)) Then DrawIt:=True
                         Else DrawIt:=False;
                    End;

                    If DrawIt Then
                    Begin
                         RowHeight:=FRowHeights^[t1];
                         rc1.Left:=X;
                         rc1.Right:=X+ColWidth;
                         If Options*[goBorder]<>[] Then If rc1.Right>=Width Then rc1.Right:=Width-1;
                         rc1.Top:=Y;
                         If t1=0 Then Inc(rc1.Top);
                         rc1.Bottom:=(Y-RowHeight);

                         rc2:=IntersectRect(rc1,rec1);
                         If Not IsRectEmpty(rc2) Then
                         Begin
                              If rc2.Bottom>0 Then Dec(rc2.Bottom);
                              If Options*[goBorder]<>[] Then If rc2.Bottom<=0 Then rc2.Bottom:=1;
                              Dec(rc2.Right);
                              Dec(rc2.Top);
                              If Options*[goBorder]<>[] Then If rc2.Right>=Width-1 Then rc2.Right:=Width-2;
                              rcSave:=Canvas.ClipRect;
                              Canvas.ClipRect:=rc2;
                              If Options*[goBorder]<>[] Then
                              Begin
                                   If t1=0 Then Inc(rc1.Left)
                                   Else If ((rc1.Left>0)And(((FixedCols>0)Or(T>0)))) Then Inc(rc1.Left);
                              End
                              Else
                              Begin
                                   If ((FixedCols>0)Or(T>0)) Then Inc(rc1.Left);
                              End;
                              Inc(rc1.Bottom);
                              If Options*[goBorder]<>[] Then If rc1.Bottom<=0 Then rc1.Bottom:=1;
                              Canvas.Brush.color:=FEntryColor;
                              Canvas.Pen.color:=PenColor;
                              AState:=[];
                              If ((T+1<=FFixedCols)Or(t1+1<=FFixedRows)) Then Include(AState,gdFixed);
                              If ((T=FSelectCol)And(t1=FSelectRow)) Then
                              Begin
                                   Include(AState,gdSelected);
                                   If HasFocus Then Include(AState,gdFocused);
                              End;
                              DrawCell(T,t1,rc1,AState);
                              Canvas.ClipRect:=rcSave;
                         End;
                         Dec(Y,RowHeight);
                    End;
               End;
               If t1+1>FFixedRows Then Inc(UpCount); {Next Row}
          End;
          If ((T+1<=FFixedCols)Or(LeftCount>FLeftScrolled)) Then Inc(X,ColWidth);
          If X>Width Then Goto Ende;  {invisible}
          If T+1>FFixedCols Then Inc(LeftCount);  {Next Column}
     End;

Ende:
     MaxWidth:=X;
     MaxHeight:=Y;

     Canvas.DeleteClipRegion;

     {Draw Grid}
     If Options*[goBorder]<>[] Then
     Begin
          Y:=Height-1;
          X:=1;
     End
     Else
     Begin
          Y:=Height;
          X:=0;
     End;

     For T:=0 To FFixedRows-1 Do Dec(Y,FRowHeights^[T]);
     Canvas.Pen.color:=clDkGray;
     LeftCount:=1;
     For T:=0 To FColCount-1 Do
     Begin
          ColWidth:=FColWidths^[T];
          If ((T+1<=FFixedCols)Or(LeftCount>FLeftScrolled)) Then
          Begin
               Canvas.Line(X+ColWidth,Height,X+ColWidth,MaxHeight);

               Canvas.Pen.color:=clWhite;
               Canvas.Line(X+ColWidth+1,Y,X+ColWidth+1,Height);
               Canvas.Pen.color:=clDkGray;

               Inc(X,ColWidth);
          End;
          If T+1>FFixedCols Then Inc(LeftCount); {Next Row}
          If X>MaxWidth Then break;
     End;

     UpCount:=1;
     Canvas.Pen.color:=clDkGray;
     If Options*[goBorder]<>[] Then
     Begin
          Y:=Height-1;
          X:=1;
     End
     Else
     Begin
          Y:=Height;
          X:=0;
     End;

     For T:=0 To FFixedCols-1 Do Inc(X,FColWidths^[T]);
     For T:=0 To FRowCount-1 Do
     Begin
          RowHeight:=FRowHeights^[T];
          If ((T+1<=FFixedRows)Or(UpCount>FUpScrolled)) Then
          Begin
               Canvas.Line(X,Y-RowHeight,MaxWidth,Y-RowHeight);

               Canvas.Pen.color:=clWhite;
               Canvas.Line(0,Y-RowHeight-1,X,Y-RowHeight-1);
               Canvas.Pen.color:=clDkGray;

               Dec(Y,RowHeight);
          End;
          If T+1>FFixedRows Then Inc(UpCount);
          If Y<0 Then break;
     End;

     If MaxHeight>0 Then
     Begin
          rc1.Left:=0;
          If Options*[goBorder]<>[] Then Inc(rc1.Left);
          rc1.Right:=Width-1;
          If Options*[goBorder]<>[] Then Dec(rc1.Right);
          rc1.Bottom:=0;
          If Options*[goBorder]<>[] Then Inc(rc1.Bottom);
          rc1.Top:=MaxHeight-1;
          Canvas.FillRect(rc1,color);
     End;

     If MaxWidth<Width Then
     Begin
          rc1.Left:=MaxWidth+1;
          rc1.Right:=Width-1;
          If Options*[goBorder]<>[] Then Dec(rc1.Right);
          rc1.Bottom:=MaxHeight;
          rc1.Top:=Height-1;
          If Options*[goBorder]<>[] Then Dec(rc1.Top);
          Canvas.FillRect(rc1,color);
     End;

     Canvas.DeleteClipRegion;

     If Options*[goBorder]<>[] Then
     Begin
          rc1.Left:=0;
          rc1.Top:=Height-1;
          {$IFDEF OS2}
          rc1.Right:=Width-1;
          rc1.Bottom:=0;
          {$ENDIF}
          {$IFDEF Win32}
          rc1.Right:=Width-2;
          rc1.Bottom:=1;
          {$ENDIF}

          Canvas.Pen.color:=clBlack;
          Canvas.Rectangle(rc1);
     End;

     If ((FVertScrollBar<>Nil)And(FHorzScrollBar<>Nil)And(FVertScrollBar.Visible)And
         (FHorzScrollBar.Visible)) Then
     Begin
          rc1.Left:=FHorzScrollBar.Width;
          rc1.Right:=Width-1;
          rc1.Bottom:=0;
          rc1.Top:=FHorzScrollBar.Height-1;
          Canvas.FillRect(rc1,color);
     End;
End;

Procedure newTGrid.UpdateGridContents(NewCols,NewRows:LongInt);
Var T:LongInt;
    P:Pointer;
    Def:LongInt;
Begin
     If FColWidths=Nil Then
     Begin
          {no List was previously Active}
          GetMem(FColWidths,NewCols*4);
          P:=FColWidths;
          Def:=FDefaultColWidth;
          Asm
             MOV EDI,p
             MOV ECX,NewCols
             MOV EAX,Def
             CLD
             REP
             STOSD
          End;
          GetMem(FRowHeights,NewRows*4);
          P:=FRowHeights;
          Def:=FDefaultRowHeight;
          Asm
             MOV EDI,p
             MOV ECX,NewRows
             MOV EAX,Def
             CLD
             REP
             STOSD
          End;
          FColCount:=NewCols;
          FRowCount:=NewRows;
     End
     Else
     Begin
          If NewCols<FColCount Then
          Begin
              {Delete Columns}
              GetMem(P,NewCols*4);
              System.Move(FColWidths^,P^,NewCols*4);
              FreeMem(FColWidths,FColCount*4);
              FColWidths:=P;
          End
          Else If NewCols>FColCount Then
          Begin
               {Add Columns}
               GetMem(P,NewCols*4);
               System.Move(FColWidths^,P^,FColCount*4);
               FreeMem(FColWidths,FColCount*4);
               FColWidths:=P;
               Inc(P,FColCount*4);
               T:=NewCols-FColCount;
               Def:=FDefaultColWidth;
               Asm
                  MOV EDI,p
                  MOV ECX,t
                  MOV EAX,Def
                  CLD
                  REP
                  STOSD
               End;
          End;
          FColCount:=NewCols;

          If NewRows<FRowCount Then
          Begin
               {Delete Rows}
               GetMem(P,NewRows*4);
               System.Move(FRowHeights^,P^,NewRows*4);
               FreeMem(FRowHeights,FRowCount*4);
               FRowHeights:=P;
          End
          Else If NewRows>FRowCount Then
          Begin
               {Add Rows}
               GetMem(P,NewRows*4);
               System.Move(FRowHeights^,P^,FRowCount*4);
               FreeMem(FRowHeights,FRowCount*4);
               FRowHeights:=P;
               Inc(P,FRowCount*4);
               T:=NewRows-FRowCount;
               Def:=FDefaultRowHeight;
               Asm
                  MOV EDI,p
                  MOV ECX,t
                  MOV EAX,Def
                  CLD
                  REP
                  STOSD
               End;
          End;
          FRowCount:=NewRows;
     End;

     If Not FUpdateLocked Then Invalidate;
     UpdateScrollBars;
End;

Destructor newTGrid.Destroy;
Begin
     ScrollBars:=ssNone;    {Destroy the ScrollBars}

     If FColCount>0 Then FreeMem(FColWidths,FColCount*4);
     FColWidths:=Nil;
     If FRowCount>0 Then FreeMem(FRowHeights,FRowCount*4);
     FRowHeights:=Nil;

     Inherited Destroy;
End;

Procedure newTGrid.SetupComponent;
Begin
     Inherited SetupComponent;

     Width:=200;
     Height:=200;
     ParentPenColor:=True;
     ParentColor:=True;
     HandlesDesignMouse:=True;
     FSelectCol:=-1;
     FSelectRow:=-1;

     FFixedColor:=clLtGray;
     FEntryColor:=clWhite;
     FFixedRows:=1;
     FFixedCols:=1;
     FDefaultRowHeight:=24; //40;
     FDefaultColWidth:=64; //50;
     FRowCount:=4;
     FColCount:=5;
     FGridLineWidth := 1; //RG April-2011
     UpdateGridContents(FColCount,FRowCount);
     ScrollBars:=ssBoth;
     FSizeShape:=crDefault;
     FOptions:=[goBorder,goShowSelection,goMouseSelect];
     If not Designed Then Include(ComponentState,csAcceptsControls);
End;

Procedure newTGrid.SetScrollBar(ScrollBar:TScrollBar;NewValue:LongInt);
Begin
     ScrollBar.Position:=NewValue;
     //ClearFocus;
     If Not FUpdateLocked Then Invalidate;
End;

Procedure newTGrid.SetTopRow(NewValue:LongInt);
Var  t,i:Longint;
Begin
     If NewValue > RowCount-FixedRows-1 Then NewValue := RowCount-FixedRows;
     If NewValue < 0 Then NewValue := 0;

     T := 0;
     For i := FixedRows To FixedRows+NewValue-1 Do
     Begin
          Inc(T,FRowHeights^[i]);
     End;
     IF FVertScrollBar <> NIL THEN
       FVertScrollBar.Position := T;
     ScrollVertTrack(FVertScrollBar,T); //manual
     Invalidate
End;

Procedure newTGrid.SetLeftCol(NewValue:LongInt);
Var  t,i:Longint;
Begin
     If NewValue > ColCount-FixedCols-1 Then NewValue := ColCount-FixedCols;
     If NewValue < 0 Then NewValue := 0;

     T := 0;
     For i := FixedCols To FixedCols+NewValue-1 Do
     Begin
          Inc(T,FColWidths^[i]);
     End;
     if FHorzScrollBar <> NIL then
       FHorzScrollBar.Position := T;
     ScrollHorzTrack(FHorzScrollBar,T); //manual
     Invalidate
End;

Procedure newTGrid.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Begin
     Case ScrollCode Of
         scLineUp:       ScrollPos:=ScrollVertTrack(ScrollBar,FUpExtent-FRowHeights^[FFixedRows+FUpScrolled]);
         scLineDown:     ScrollPos:=ScrollVertTrack(ScrollBar,FUpExtent+FRowHeights^[FFixedRows+FUpScrolled]);
         scPageUp:       ScrollPos:=ScrollVertTrack(ScrollBar,FUpExtent-Height);
         scPageDown:     ScrollPos:=ScrollVertTrack(ScrollBar,FUpExtent+Height);
         scVertTrack:    ScrollPos:=ScrollVertTrack(ScrollBar,ScrollPos);
         scVertPosition: ScrollPos:=ScrollVertTrack(ScrollBar,ScrollPos);
         scColumnLeft:   ScrollPos:=ScrollHorzTrack(ScrollBar,FLeftExtent-FColWidths^[FFixedCols+FLeftScrolled-1]);
         scColumnRight:  ScrollPos:=ScrollHorzTrack(ScrollBar,FLeftExtent+FColWidths^[FFixedCols+FLeftScrolled]);
         scPageLeft:     ScrollPos:=ScrollHorzTrack(ScrollBar,FLeftExtent-Width);
         scPageRight:    ScrollPos:=ScrollHorzTrack(ScrollBar,FLeftExtent+Width);
         scHorzTrack:    ScrollPos:=ScrollHorzTrack(ScrollBar,ScrollPos);
         scHorzPosition: ScrollPos:=ScrollHorzTrack(ScrollBar,ScrollPos);
     End;
     ScrollBar.Update;
     Invalidate;
End;

Procedure newTGrid.GetGridExtent(Var CX,CY:LongInt);
Var T:LongInt;
Begin
     CX:=0;
     CY:=0;
     For T:=0 To FColCount-1 Do Inc(CX,FColWidths^[T]);
     For T:=0 To FRowCount-1 Do Inc(CY,FRowHeights^[T]);
End;

Function newTGrid.GetVisibleRowCount:LongInt;
Var T,H,MinHeight:LongInt;
Begin
     Result:=0;
     H:=Height;

     MinHeight:=0;
     If FHorzScrollBar<>Nil Then
       If FHorzScrollBar.Visible Then Inc(MinHeight,FHorzScrollBar.Height);

     For T:=0 To FFixedRows-1 Do
     Begin
          Dec(H,FRowHeights^[T]);
          Inc(Result);
          If H<=MinHeight Then Exit;
     End;

     For T:=FUpScrolled+FFixedRows To FRowCount-1 Do
     Begin
          Dec(H,FRowHeights^[T]);
          Inc(Result);
          If H<=MinHeight Then Exit;
     End;
End;

Function newTGrid.GetVisibleColCount:LongInt;
Var T,W,MaxWidth:LongInt;
Begin
     Result:=0;
     W:=0;

     MaxWidth:=Width;
     If FVertScrollBar<>Nil Then
       If FVertScrollBar.Visible Then Dec(MaxWidth,FVertScrollBar.Width);

     For T:=0 To FFixedCols-1 Do
     Begin
          Inc(W,FColWidths^[T]);
          Inc(Result);
          If W>=MaxWidth Then Exit;
     End;

     For T:=FLeftScrolled+FFixedCols To FColCount-1 Do
     Begin
          Inc(W,FColWidths^[T]);
          Inc(Result);
          If W>=MaxWidth Then Exit;
     End;
End;

Function newTGrid.GetGridWidth:LongInt;
Var T:LongInt;
Begin
     Result:=0;
     For T:=0 To FColCount-1 Do Inc(Result,FColWidths^[T]);
End;

Function newTGrid.GetGridHeight:LongInt;
Var T:LongInt;
Begin
     Result:=0;
     For T:=0 To FRowCount-1 Do Inc(Result,FRowHeights^[T]);
End;

{$HINTS OFF}
Function newTGrid.ScrollHorzTrack(ScrollBar:TScrollBar;NewPosition:LongInt):LongInt;
Var MaxWidth,MaxHeight,Value:LongInt;
    T:LongInt;
Begin
     If NewPosition<0 Then NewPosition:=0;
     GetGridExtent(MaxWidth,MaxHeight);
     If NewPosition>MaxWidth Then NewPosition:=MaxWidth;
     Value:=Width;
     If FVertScrollBar<>Nil Then If FVertScrollBar.Visible Then Dec(Value,FVertScrollBar.Width);

     FLeftScrolled:=0;
     FLeftExtent:=0;
     For T:=FFixedCols To FColCount-1 Do
     Begin
          If FLeftExtent>=NewPosition Then break;
          If FLeftExtent+Value>=MaxWidth Then break;  {rest fits In Window}
          Inc(FLeftExtent,FColWidths^[T]);
          Inc(FLeftScrolled);
     End;

     Result:=FLeftExtent;
End;

Function newTGrid.ScrollVertTrack(ScrollBar:TScrollBar;NewPosition:LongInt):LongInt;
Var MaxWidth,MaxHeight,Value:LongInt;
    T:LongInt;
Begin
     If NewPosition<0 Then NewPosition:=0;
     GetGridExtent(MaxWidth,MaxHeight);
     If NewPosition>MaxHeight Then NewPosition:=MaxHeight;
     Value:=Height;
     If FHorzScrollBar<>Nil Then If FHorzScrollBar.Visible Then Dec(Value,FHorzScrollBar.Height);

     FUpScrolled:=0;
     FUpExtent:=0;
     For T:=FFixedRows To FRowCount-1 Do
     Begin
          If FUpExtent>=NewPosition Then break;
          If FUpExtent+Value>=MaxHeight Then break;  {rest fits In Window}
          Inc(FUpExtent,FRowHeights^[T]);
          Inc(FUpScrolled);
     End;

     Result:=FUpExtent;
End;
{$HINTS ON}

Function newTGrid.CellRect(Col,Row:LongInt):TRect;
Var X,Y:LongInt;
    LeftCount,UpCount:LongInt;
    T,t1:LongInt;
    TheRowHeight:LongInt;
    TheColWidth:LongInt;
    DrawIt:Boolean;
Begin
     FillChar(Result,SizeOf(TRect),0);
     If ((Row<0)Or(Row>FRowCount-1)Or(Col<0)Or(Col>FColCount-1)) Then Exit;

     If Options*[goBorder]<>[] Then X:=1
     Else X:=0;
     LeftCount:=1;
     For T:=0 To FColCount-1 Do
     Begin
          If Options*[goBorder]<>[] Then Y:=Height-1
          Else Y:=Height;
          TheColWidth:=FColWidths^[T];
          UpCount:=1;
          For t1:=0 To FRowCount-1 Do
          Begin
               If Y>0 Then
               Begin
                    If ((T+1<=FFixedCols)And(t1+1<=FFixedRows)) Then DrawIt:=True {Ecke(N) links oben}
                    Else
                    Begin
                         If ((T+1<=FFixedCols)And(UpCount>FUpScrolled)) Then DrawIt:=True
                         Else If ((t1+1<=FFixedRows)And(LeftCount>FLeftScrolled)) Then DrawIt:=True
                         Else If ((UpCount>FUpScrolled)And(LeftCount>FLeftScrolled)) Then DrawIt:=True
                         Else DrawIt:=False;
                    End;

                    If DrawIt Then
                    Begin
                         TheRowHeight:=FRowHeights^[t1];
                         If T=Col Then If t1=Row Then
                         Begin
                              Result.Left:=X+1;
                              Result.Right:=X+TheColWidth;
                              Result.Top:=Y;
                              Result.Bottom:=(Y-TheRowHeight)+1;
                              Exit;
                         End;
                         Dec(Y,TheRowHeight);
                    End;
               End;
               If t1+1>FFixedRows Then Inc(UpCount); {Next Column}
          End;
          If ((T+1<=FFixedCols)Or(LeftCount>FLeftScrolled)) Then Inc(X,TheColWidth);
          If T+1>FFixedCols Then Inc(LeftCount);  {Next Row}
     End;
End;


Function newTGrid.GetSizeItem(Const pt:TPoint;Var Col,Row:LongInt):TCursor;
Var T,t1:LongInt;
    LeftCount,UpCount:LongInt;
    DrawIt:Boolean;
    ColWidth,RowHeight:LongInt;
    X,Y:LongInt;
Begin
  Result:=crDefault;
  If Options*[goBorder]<>[]
    Then X:=1
    Else X:=0;
  Col:=-1;
  Row:=-1;

  LeftCount:=1;
  For T:=0 To FColCount-1 Do
    Begin
      Col:=T;
      ColWidth:=FColWidths^[T];
      If Options*[goBorder]<>[]
        Then Y:=Height-1
        Else Y:=Height;
      UpCount:=1;
      If ((T+1<=FFixedCols)Or(LeftCount>FLeftScrolled))
        Then Inc(X,ColWidth);
      If T+1>FFixedCols
        Then Inc(LeftCount);  {Next Row}
      For t1:=0 To FRowCount-1 Do
        Begin
          If Y>0 Then
            Begin
              If ((T+1<=FFixedCols)And(t1+1<=FFixedRows))
                Then DrawIt:=True {Ecke(N) links oben}
                Else
                  Begin
                    If ((T+1<=FFixedCols)And(UpCount>FUpScrolled))
                      Then DrawIt:=True
                      Else
                        If ((t1+1<=FFixedRows)And(LeftCount>FLeftScrolled))
                          Then DrawIt:=True
                          Else
                            If ((UpCount>FUpScrolled)And(LeftCount>FLeftScrolled))
                              Then DrawIt:=True
                              Else DrawIt:=False;
                  End;

              If DrawIt Then
                Begin
                  Row:=t1;
                  RowHeight:=FRowHeights^[t1];
                  Dec(Y,RowHeight);

                  If ((Options*[goRowSizing]<>[])Or(Designed)) Then
                    Begin
                      If ((pt.Y>=Y-1)And(pt.Y<=Y+1)And(pt.X<X)And(pt.X>X-ColWidth)And
                          (T+1<=FFixedCols)) Then
                        Begin
                          Result:=crVSplit;
                          Exit;
                        End;
                    End;

                  If ((Options*[goColSizing]<>[])Or(Designed)) Then
                     Begin
                       If ((pt.X>=X-1)And(pt.X<=X+1)And(pt.Y>Y)And(pt.Y<Y+RowHeight)And
                           (t1+1<=FFixedRows)) Then
                         Begin
                           Result:=crHSplit;
                           Inc(Y,RowHeight);
                           Exit;
                         End;
                     End;

                  If ((pt.Y>=Y+1)And(pt.Y<=Y+(RowHeight-1))And(pt.X>=X-(ColWidth-1))And(pt.X<=X-1)) then
                    If ((T+1>FFixedCols)And(t1+1>FFixedRows)) Then {FIXED entries cannot be Selected}
                      Begin
                        {entry Focused}
                        Exit;
                      End;
                End; {If DrawIt}
              If t1+1>FFixedRows Then Inc(UpCount); {Next Column}
            End;
        End;
    End;
  Col:=-1;
  Row:=-1;
End;


{$HINTS OFF}
Procedure newTGrid.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var Row:LongInt;
    Col:LongInt;
    Shape:TCursor;
    X1,y1:LongInt;
Begin
  Inherited MouseMove(ShiftState,X,Y);

  If FSizeShape<>crDefault Then {Sizing}
    Begin
      fDblClickSizing:=true;
      LastMsg.Handled:=True;
      Canvas.Pen.Mode:=pmNot;
      Canvas.Pen.color:=clBlack;
      {Delete old rubberline}
      If FSizeShape=crVSplit
        Then Canvas.Line(0,FSizeY,Width,FSizeY)
        Else Canvas.Line(FSizeX,0,FSizeX,Height);
      {Draw New Line}
      FSizeX:=X;
      If FSizeX<=FSizeStartX+5
        Then FSizeX:=FSizeStartX+5;
      If FSizeX>=Width-5
        Then FSizeX:=Width-5;
       FSizeY:=Y;
      If FSizeY>=FSizeStartY-5
        Then FSizeY:=FSizeStartY-5;
      If FSizeY<=5
        Then FSizeY:=5;

      If FSizeShape=crVSplit
        Then Canvas.Line(0,FSizeY,Width,FSizeY)
        Else Canvas.Line(FSizeX,0,FSizeX,Height);
      Canvas.Pen.Mode:=pmCopy;
      Exit;
    End;

  Shape:=GetSizeItem(Point(X,Y),Col,Row);
  {$IFDEF OS2}
  WinSetPointer(HWND_DESKTOP,Screen.Cursors[Shape]);
  {$ENDIF}
  {$IFDEF Win32}
  SetClassWord(Handle,-12{GCW_HCURSOR},0);
  SetCursor(Screen.Cursors[Shape]);
  {$ENDIF}
  If Shape<>crDefault Then LastMsg.Handled:=True; {dont pass To Form Editor}
End;

Procedure newTGrid.RowHeightChanged(Row:LongInt);
Begin
End;

Procedure newTGrid.ColWidthChanged(Col:LongInt);
Begin
End;

Procedure newTGrid.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);

Var  Row:LongInt;
     Col:LongInt;
     Shape:TCursor;

Begin
  Inherited MouseDown(Button,ShiftState,X,Y);

  If Button <> mbLeft Then Exit;
  Focus;

  Shape:=GetSizeItem(Point(X,Y),Col,Row);
  {$IFDEF OS2}
  WinSetPointer(HWND_DESKTOP,Screen.Cursors[Shape]);
  {$ENDIF}
  {$IFDEF Win32}
  SetClassWord(Handle,-12{GCW_HCURSOR},0);
  SetCursor(Screen.Cursors[Shape]);
  {$ENDIF}
  If Shape<>crDefault Then
    Begin
      LastMsg.Handled:=True; {dont pass To Form Editor}
      Canvas.Pen.Mode:=pmNot;
      Canvas.Pen.color:=clBlack;
      FSizeCol:=Col;
      FSizeRow:=Row;
      FSizeShape:=Shape;
      FSizeStartX:=X-FColWidths^[Col];
      FSizeStartY:=Y+FRowHeights^[Row];
      FSizeX:=X;
      FSizeY:=Y;
      If FSizeShape=crVSplit
        Then Canvas.Line(0,FSizeY,Width,FSizeY)
        Else Canvas.Line(FSizeX,0,FSizeX,Height);
      MouseCapture:=True;
      Canvas.Pen.Mode:=pmCopy;
      //ClearFocus;
    End
  Else
    Begin
      If Designed Then Exit;
      If ((Row<>-1)And(Col<>-1)) Then
        If Options*[goMouseSelect]<>[] Then
          Begin
            {entry Focused}
            If Not SelectCell(Col,Row) Then Exit;
            If OnSelectCell<>Nil Then OnSelectCell(Self,Col,Row);
          End;
      //Else ClearFocus;
    End;
End;

Procedure newTGrid.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    Col:LongInt;
    Row:LongInt;
    DNS:TDesignerNotifyStruct;
Begin
  Inherited MouseUp(Button,ShiftState,X,Y);

  If Button <> mbLeft Then Exit;

  If FSizeShape<>crDefault Then
    Begin
      LastMsg.Handled:=True; {dont pass To Form Editor}
      Canvas.Pen.Mode:=pmNot;
      Canvas.Pen.color:=clBlack;
      {Delete old rubberline}
      If FSizeShape=crVSplit
        Then Canvas.Line(0,FSizeY,Width,FSizeY)
        Else Canvas.Line(FSizeX,0,FSizeX,Height);
      MouseCapture:=False;
      Canvas.Pen.Mode:=pmCopy;

      If FSizeX<=FSizeStartX+5 Then FSizeX:=FSizeStartX+5;
      If FSizeY>=FSizeStartY-5 Then FSizeY:=FSizeStartY-5;

      FSizeX:=FSizeX-FSizeStartX;
      FSizeY:=FSizeStartY-FSizeY;

      If FSizeShape=crVSplit Then
        Begin
          {Row Height Sizing}
          FRowHeights^[FSizeRow]:=FSizeY;
          RowHeightChanged(FSizeRow);
        End
      Else
        Begin
          {Column Width Sizing}
          FColWidths^[FSizeCol]:=FSizeX;
          ColWidthChanged(FSizeCol);
        End;

      DNS.Sender := Self;
      DNS.Code := dncSCUModified;
      DNS.return := 0;
      DesignerNotification(DNS);

      FSizeShape:=crDefault;
      UpdateScrollBars;
      Invalidate;
    End;
End;

Procedure newTGrid.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LonGInT);
Begin
  Inherited MouseDblClick(Button,ShiftState,X,Y);
  If Button <> mbLeft Then Exit;

  if fDblClickSizing then
    MouseDblClickSizing(FSizeCol);
  fDblClickSizing:=false;
End;


Procedure newTGrid.MouseDblClickSizing(Col:LongInt);
Begin
End;

Function newTGrid.GetSelection:newTGridRect;
Begin
     Result.Left:=Col;
     Result.Top:=Row;

     //we only Do support Single Selection For now...
     Result.Right:=Result.Left;
     Result.Bottom:=Result.Top;
End;

Procedure newTGrid.SetSelection(NewValue:newTGridRect);
Begin
     //we only Do support Single Selection For now...
     SelectCell(NewValue.Left,NewValue.Top);
End;

Function newTGrid.SelectCell(Col,Row:LongInt):Boolean;
Var rc:TRect;
    T:LongInt;
    Count:LongInt;
    ActualCol,ActualRow:LongInt;
    DoRefresh:Boolean;

    Function ColMatch:Boolean;
    Var T:LongInt;
        X:LongInt;
        MaxWidth:LongInt;
    Begin
         Result:=False;
         X:=0;
         MaxWidth:=Width;
         If FVertScrollBar<>Nil Then
           If FVertScrollBar.Visible Then Dec(MaxWidth,FVertScrollBar.Width);
         For T:=0 To FFixedCols-1 Do Inc(X,FColWidths^[T]);
         For T:=Count To Col Do
         Begin
              Inc(X,FColWidths^[T]);
              If X>=MaxWidth Then If T<>Col Then Exit;
         End;
         Result:=True;
    End;

    Function RowMatch:Boolean;
    Var T:LongInt;
        Y:LongInt;
        MinHeight:LongInt;
    Begin
         Result:=False;
         Y:=Height;
         MinHeight:=0;
         If FHorzScrollBar<>Nil Then
           If FHorzScrollBar.Visible Then Inc(MinHeight,FHorzScrollBar.Height);
         For T:=0 To FFixedRows-1 Do Dec(Y,FRowHeights^[T]);
         For T:=Count To Row Do
         Begin
              Dec(Y,FRowHeights^[T]);
              If Y<=MinHeight Then If T<>Row Then Exit;
         End;
         Result:=True;
    End;

Begin
     Result:=True;
     If ((Col<0)Or(Col>FColCount)Or(Col<FFixedCols)Or
         (Row<0)Or(Row>FRowCount)Or(Row<FFixedRows)) Then Exit;

     If ((Col=FSelectCol)And(Row=FSelectRow)) Then Exit;

     If ((FSelectCol>=0)And(FSelectRow>=0)) Then
     Begin
          rc:=GridRects[FSelectCol,FSelectRow];
          If Options*[goShowSelection]<>[] Then InvalidateRect(rc);
     End;

     FSelectCol:=Col;
     FSelectRow:=Row;
     DoRefresh:=False;

     If Col>FLeftScrolled+VisibleColCount-FFixedCols Then
     Begin
          T:=FLeftExtent;
          Count:=FLeftScrolled+FFixedCols;
          Repeat
                Inc(T,FColWidths^[Count]);
                Inc(Count);
          Until ColMatch;

          If FHorzScrollBar<>Nil Then
          Begin
            FHorzScrollBar.Position:=T;
            FHorzScrollBar.Update;
          End;
          ScrollHorzTrack(FHorzScrollBar,T);
          DoRefresh:=True;
     End
     Else If Col<FLeftScrolled+FFixedCols Then
     Begin
          T:=FLeftExtent;
          Count:=FLeftScrolled;
          While Count>Col-FFixedCols Do
          Begin
               Dec(T,FColWidths^[Count+FFixedCols-1]);
               Dec(Count);
          End;

          If FHorzScrollBar<>Nil Then
          Begin
            FHorzScrollBar.Position:=T;
            FHorzScrollBar.Update;
          End;
          ScrollHorzTrack(FHorzScrollBar,T);
          DoRefresh:=True;
     End;

     If Row>FUpScrolled+VisibleRowCount-FFixedRows Then
     Begin
          T:=FUpExtent;
          Count:=FUpScrolled+FFixedRows;
          Repeat
                Inc(T,FRowHeights^[Count]);
                Inc(Count);
          Until RowMatch;

          If FVertScrollBar<>Nil Then
          Begin
               FVertScrollBar.Position:=T;
               FVertScrollBar.Update;
          End;
          ScrollVertTrack(FVertScrollBar,T);
          DoRefresh:=True;
     End
     Else If Row<FUpScrolled+FFixedRows Then
     Begin
          T:=FUpExtent;
          Count:=FUpScrolled;
          While Count>Row-FFixedRows Do
          Begin
               Dec(T,FRowHeights^[Count+FFixedRows-1]);
               Dec(Count);
          End;

          If FVertScrollBar<>Nil Then
          Begin
              FVertScrollBar.Position:=T;
              FVertScrollBar.Update;
          End;
          ScrollVertTrack(FVertScrollBar,T);
          DoRefresh:=True;
     End;

     If ((FSelectCol>=0)And(FSelectRow>=0)) Then
     Begin
          rc:=GridRects[FSelectCol,FSelectRow];
          If Options*[goShowSelection]<>[] Then InvalidateRect(rc);
     End;

     If DoRefresh Then Refresh
     Else Update;
End;

Procedure newTGrid.SetUpdateLocked(NewValue:Boolean);
Begin
     If NewValue=FGridUpdateLocked Then Exit;
     FGridUpdateLocked:=NewValue;
     If Not FGridUpdateLocked Then If Handle<>0 Then Invalidate;
End;

Procedure newTGrid.SetCol(NewValue:LongInt);
Begin
     If ((NewValue>=0)And(NewValue<FColCount)And(NewValue<>FSelectCol)) Then
     Begin
          If ((FSelectRow>=0)And(FSelectRow<FRowCount)) Then
          Begin
               If Not SelectCell(NewValue,FSelectRow) Then Exit;
               If OnSelectCell<>Nil Then OnSelectCell(Self,NewValue,FSelectRow);
          End
          Else FSelectCol:=NewValue;
     End;
End;

Procedure newTGrid.SetRow(NewValue:LongInt);
Begin
     If ((NewValue>=0)And(NewValue<FRowCount)And(NewValue<>FSelectRow)) Then
     Begin
          If ((FSelectCol>=0)And(FSelectCol<FColCount)) Then
          Begin
               If Not SelectCell(FSelectCol,NewValue) Then Exit;
               If OnSelectCell<>Nil Then OnSelectCell(Self,FSelectCol,NewValue);
          End
          Else FSelectRow:=NewValue;
     End;
End;

Procedure newTGrid.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var Visible:LongInt;
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)) Then
     Begin
          Case KeyCode Of
             kbCLeft:If Col>FFixedCols Then Col:=Col-1;
             kbCRight:If Col<FColCount-1 Then Col:=Col+1;
             kbCUp:If Row>FFixedRows Then Row:=Row-1;
             kbCDown:If Row<FRowCount-1 Then Row:=Row+1;
             kbPageDown:
             Begin
                  Visible:=VisibleRowCount;
                  If FSelectRow+Visible<FRowCount-1 Then Row:=FSelectRow+Visible
                  Else Row:=FRowCount-1;
             End;
             kbPageUp:
             Begin
                  Visible:=VisibleRowCount;
                  If FSelectRow-FFixedRows>Visible Then Row:=FSelectRow-Visible
                  Else Row:=FFixedRows;
             End;
             kbHome:Col:=FFixedCols;
             kbEnd:Col:=ColCount-1;
             Else Inherited ScanEvent(KeyCode,RepeatCount);
          End;
     End
     Else Inherited ScanEvent(KeyCode,RepeatCount);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TStringGrid Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//added En
Procedure newTStringGrid.SetupComponent;
Begin
     Inherited SetupComponent;

     FAlignment:=taLeftjustify;
     FOnDrawCell := NIL
End;

Function newTStringGrid.IndexOf(Const iSt : String; iCol, iRow : LongInt) : tPoint;

Var StCol, StRow,
    EnCol, EnRow : LongInt;
    Col,Row      : LongInt;
    RowList      : TList;
    ps           : PString;

label Gefunden;

Begin
  Result.X:=-1;
  Result.Y:=-1;
  If (iRow<-1) Or (iRow>FRowCount-1) Or
     (iCol<-1) Or (iCol>FColCount-1) or
     (FColumns = nil) Then Exit;
  if iCol=-1
    then
      Begin
        StCol:=0;
        EnCol:=FColCount-1;
      End
    else
      Begin
        StCol:=iCol;
        EnCol:=iCol;
      End;
  if iRow=-1
    then
      Begin
        StRow:=0;
        EnRow:=FRowCount-1;
      End
    else
      Begin
        StRow:=iRow;
        EnRow:=iRow;
      End;

   for Col:=StCol to EnCol do
     Begin
       RowList:=FColumns.Items[Col];
       If RowList<>Nil Then
         for Row:=StRow to enRow do
           Begin
             ps:=RowList.Items[Row];
             if ((ps=nil) and (iSt='')) or
                 (ps^=iSt) then
               goto Gefunden;
           End;
     End;
   exit;

Gefunden:
   Result.Y:=Row;
   Result.X:=Col;

End;

Procedure newTStringGrid.SetupCellDrawing(Col,Row:LongInt;AState:newTGridDrawState;
                                       Var Alignment:TAlignment;Var Font:TFont);
Begin
//     Alignment:=taLeftJustify;
     Alignment:=FAlignment; //En
     Font:=Self.Font;
End;


Procedure newTStringGrid.DrawCell(Col,Row:LongInt;rec:TRect;AState:newTGridDrawState);
Var
    X,Y:LongInt;
    S:String;
    OldClip:TRect;
    Exclude:TRect;
    CX,CY:LongInt;
    Alignment:TAlignment;
    TheFont,OldFont:TFont;
Begin
     If ((FEdit<>Nil)And(FEdit.Control.Visible)) Then AState:=AState-[gdSelected,gdFocused];
     SetCellColors(Col,Row,AState);
     SetupCellDrawing(Col,Row,AState,Alignment,TheFont);

     If TheFont<>Canvas.Font Then
     Begin
          OldFont:=Canvas.Font;
          Canvas.Font:=TheFont;
     End
     Else OldFont:=Nil;

     S:=Cells[Col,Row];
     X:=rec.Left+2;
     Y:=rec.Top-2-Canvas.Font.Height;

     Canvas.GetTextExtent(S,CX,CY);

     Case Alignment Of
        taLeftJustify:;
        taRightJustify:If CX<(rec.Right-rec.Left)-2 Then X:=rec.Right-2-CX;
        taCenter:If CX<(rec.Right-rec.Left)-2 Then X:=(rec.Right-rec.Left-CX-2) Div 2 + rec.left;
        // changed En
     End; {Case}

     If FOnDrawCell<>Nil Then FOnDrawCell(Self,Col,Row,rec,AState);
     Canvas.TextOut(X,Y,S);
     OldClip:=Canvas.ClipRect;

     Exclude.Left:=X;
     Exclude.Right:=Pred(X+CX);
     Exclude.Bottom:=Y;
     Exclude.Top:=Y+CY-1;
     Canvas.ClipRect:=rec;
     Canvas.ExcludeClipRect(Exclude);
     Inherited DrawCell(Col,Row,rec,AState);
     Canvas.ClipRect:=OldClip;

     If OldFont<>Nil Then Canvas.Font:=OldFont;
     If FOnDrawCell<>Nil Then FOnDrawCell(Self,Col,Row,rec,AState);
End;

{$HINTS OFF}
Procedure newTStringGrid.EvEntryKillFocus(Sender:TObject);
Begin
     ClearFocus;
End;
{$HINTS ON}


Function newTStringGrid.SelectCell(Col,Row:LongInt):Boolean;
Var rc:TRect;
    Ok:Boolean;
Label L;
Begin
     Result:=True;
     If ((FOptions*[goEditing]<>[])And(FOptions*[goAlwaysShowEditor]<>[])) Then
     Begin
L:
          If ((FSelectCol>=0)And(FSelectRow>=0)And(FEdit<>Nil)And(FEdit.Control.Visible)And
              (FEdit.Text<>Cells[FSelectCol,FSelectRow])) Then
          Begin
             If ((FSelectCol=Col)And(FSelectRow=Row)) Then Exit;

             Try
                If OnSetEditText<>Nil Then OnSetEditText(Self,FSelectCol,FSelectRow,FEdit.Text);
                Cells[FSelectCol,FSelectRow]:=FEdit.Text;
             Except
{WD                ON E:ESQLError Do ErrorBox(E.Message);
                Else }Raise;
             End;
          End;

          If ((FSelectCol=Col)And(FSelectRow=Row)And
              (FEdit<>Nil)And(FEdit.Control.Visible)) Then Exit;

          If FOptions*[goAlwaysShowEditor]<>[] Then Inherited SelectCell(Col,Row);

          ShowEntry(Cells[FSelectCol,FSelectRow]);

          If FOptions*[goAlwaysShowEditor]=[] Then
          Begin
              rc:=GridRects[FSelectCol,FSelectRow];
              InvalidateRect(rc);
              Update;
          End;
     End
     Else
     Begin
          If ((FSelectCol=Col)And(FSelectRow=Row)And(FOptions*[goEditing]<>[])) Then
          Begin
               Ok:=True;
               If OnCanEdit<>Nil Then OnCanEdit(Self,Col,Row,Ok);
               If Ok Then Goto L;
          End;

          If ((Col<>FSelectCol)Or(Row<>FSelectRow)) Then
            If ((FSelectCol>=0)And(FSelectRow>=0)) Then
            Begin
                 HideEditorIntern;
            End;
          Inherited SelectCell(Col,Row);
     End;
End;

Procedure newTStringGrid.SetCell(Col,Row:LongInt;Const NewContent:String);
Var Rows:TList;
    ps:PString;
    T:LongInt;
    NewValue:String;
Begin
     If ((Row<0)Or(Row>FRowCount-1)Or(Col<0)Or(Col>FColCount-1)) Then Exit;

     {entry exists}
     If FColumns=Nil Then FColumns.Create;
     For T:=0 To Col-FColumns.Count Do //Append Columns
     Begin
          Rows.Create;
          FColumns.Add(Rows);
     End;

     Rows:=FColumns.Items[Col];
     If Rows=Nil Then
     Begin
          Rows.Create;
          FColumns.Items[Col]:=Rows;
     End;

     For T:=0 To Row-Rows.Count Do Rows.Add(Nil);   //Append Rows ??

     NewValue:=NewContent;
     If OnSetCell<>Nil Then OnSetCell(Self,Col,Row,NewValue);

     ps:=Rows.Items[Row];
     If ps<>Nil Then FreeMem(ps,Length(ps^)+1);

     If NewValue='' Then ps:=Nil
     Else
     Begin
          GetMem(ps,Length(NewValue)+1);
          ps^:=NewValue;
     End;
     Rows.Items[Row]:=ps;
     invalidate
End;

Function newTStringGrid.GetCell(Col,Row:LongInt):String;
Var Rows:TList;
    ps:PString;
Begin
     Result:='';
     If ((Row<0)Or(Row>FRowCount-1)Or(Col<0)Or(Col>FColCount-1)) Then Exit;

     {entry exists}
     If FColumns<>Nil Then
       If Col<=FColumns.Count-1 Then //Not Assigned
     Begin
         Rows:=FColumns.Items[Col];
         If Rows<>Nil Then
         Begin
              If Row<=Rows.Count-1 Then //Not Assigned
              Begin
                   ps:=Rows.Items[Row];
                   If ps=Nil Then Result:=''
                   Else Result:=ps^;
              End;
         End;
     End;
     If OnGetCell<>Nil Then OnGetCell(Self,Col,Row,Result);
End;

Destructor newTStringGrid.Destroy;
Var T,t1:LongInt;
    Rows:TList;
    ps:PString;
Begin
     //Destroy Columns/Rows that had been Assigned
     If FEdit<>Nil Then FEdit.Destroy;
     FEdit := Nil;
     If FColumns<>Nil Then
     Begin
          For T:=0 To FColumns.Count-1 Do
          Begin
               Rows:=FColumns.Items[T];
               If Rows<>Nil Then
               Begin
                    For t1:=0 To Rows.Count-1 Do
                    Begin
                         ps:=Rows.Items[t1];
                         If ps<>Nil Then FreeMem(ps,Length(ps^)+1);
                    End;
                    Rows.Destroy;
               End;
          End;
          FColumns.Destroy;
          FColumns := Nil;
     End;

     Inherited Destroy;
End;

Procedure newTStringGrid.ClearFocus;
Var rc:TRect;
{    S:String; }
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)And(FEdit<>Nil)And(FEdit.Control.Visible)) Then
     Begin
          Try
             If FEdit.Text<>Cells[FSelectCol,FSelectRow] Then
             Begin
                  If OnSetEditText<>Nil Then OnSetEditText(Self,FSelectCol,FSelectRow,FEdit.Text);
                  Cells[FSelectCol,FSelectRow]:=FEdit.Text;
             End;
          Except
{ WD             ON E:ESQLError Do
             Begin
                  s:=Cells[FSelectCol,FSelectRow];
                  If OnGetEditText<>Nil Then OnGetEditText(Self,FSelectCol,FSelectRow,s);
                  FEdit.Text:=s;
                  ErrorBox(E.Message);
             End;
             Else } Raise;
          End;

          FEdit.Hide;
          rc:=GridRects[FSelectCol,FSelectRow];
          InvalidateRect(rc);
          Update;
     End;

     Inherited ClearFocus;
End;

Procedure newTStringGrid.ShowEntry(S:String);
Var rc:TRect;
    W,H:LongInt;
    back,Fore:TColor;
    Control:TControl;
    FEditClass:newTInplaceEditClass;
Begin
     rc:=GridRects[FSelectCol,FSelectRow];
     Inc(rc.Left);
     Dec(rc.Top,3);
     Dec(rc.Right);
     Inc(rc.Bottom,2);

     FEditClass:=ShowEditor(FSelectCol,FSelectRow);
     If FEditClass=Nil Then FEditClass:=TDefaultEdit;

     If ((FEdit<>Nil)And(FEditClass<>FEdit.ClassType)) Then
     Begin
          Focus;   //FEdit darf beim Destroy nicht den Fokus haben
          FEdit.Hide;
          FEdit.Destroy;
          FEdit:=Nil;
     End;

     If FEdit=Nil Then FEdit:=FEditClass.Create(Self,FSelectCol,FSelectRow)
     Else
     Begin
          FEdit.Hide;
          FEdit.FCol:=FSelectCol;
          FEdit.FRow:=FSelectRow;
          Focus;
          FEdit.SetupEdit(Self);
     End;

     Control:=FEdit.Control;
     Include(Control.ComponentState, csDetail);
     FEdit.Hide;
     FEdit.Control.Parent:=Self;
     FEdit.Control.OnExit:=EvEntryKillFocus;

     FEdit.Control.Font:=Font;
     W:=(rc.Right-rc.Left);
     H:=Canvas.Font.Height;
     If rc.Left+W>=Width Then W:=(Width-rc.Left)-1;
     If ((FVertScrollBar<>Nil)And(FVertScrollBar.Visible)) Then
        If rc.Left+W>=FVertScrollBar.Left Then W:=FVertScrollBar.Left-rc.Left;
     If rc.Top-H<=0 Then H:=rc.Top-1;
     FEdit.SetWindowPos(rc.Left,rc.Top-H,W,H);
     If OnGetEditText<>Nil Then OnGetEditText(Self,FSelectCol,FSelectRow,S);
     FEdit.Text:=S;
     SetupCellColors(FSelectCol,FSelectRow,[],back,Fore);
     FEdit.Control.Color:=Back;
     FEdit.Control.PenColor:=Fore;
     FEdit.Control.Focus;
     FEdit.Show;
End;

Function newTStringGrid.ShowEditor(Col,Row:LongInt):newTInplaceEditClass;
Begin
     If @FOnShowEditor<>Nil Then
       Result:=FOnShowEditor(Self,FSelectCol,FSelectRow)
     Else
       Result:=TDefaultEdit;
End;


Procedure newTStringGrid.MouseDblClickSizing(Col:LongInt);

Var r, m, i: LongInt;
    w,h    : LongInt;
    l      : Integer;

Begin
  inherited MouseDblClickSizing(Col);
  m:=0;
  i:=0;
  For r:=0 to fRowCount do
    Begin
      l:=length(Cells[Col,R]);
      if m < l then
        Begin
          m:=l;
          i:=r;
        End;
    end;
  Canvas.GetTextExtent(Cells[Col,I],w,h);
  ColWidths[Col]:=w+10;
End;

Procedure newTStringGrid.ShowEditorIntern;
Var rc:TRect;
Begin
  If ((FSelectCol<0)Or(FSelectRow<0)Or(((FEdit<>Nil)And(FEdit.Control.Visible)))) Then Exit;
  ShowEntry(Cells[FSelectCol,FSelectRow]);
  rc:=GridRects[FSelectCol,FSelectRow];
  InvalidateRect(rc);
  Update;
End;


Procedure newTStringGrid.HideEditorIntern;
Var  rc:TRect;
     SelCol,SelRow:LongInt;
     Error:Boolean;
     ErrorText:String;
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)And(FEdit<>Nil)And(FEdit.Control.Visible)) Then
     Begin
          Try
             If FEdit.Text<>Cells[FSelectCol,FSelectRow] Then
             Begin
                  If OnSetEditText<>Nil Then OnSetEditText(Self,FSelectCol,FSelectRow,FEdit.Text);
                  Cells[FSelectCol,FSelectRow]:=FEdit.Text;
             End;
             Error:=False;
          Except
{WD             ON E:ESQLError Do
             Begin
                  ErrorText:=Cells[FSelectCol,FSelectRow];
                  If OnGetEditText<>Nil Then OnGetEditText(Self,FSelectCol,FSelectRow,ErrorText);
                  FEdit.Text:=ErrorText;
                  ErrorText:=E.Message;
                  Error:=True;
             End;
             Else} Raise;
          End;

          SelCol := FSelectCol;
          SelRow := FSelectRow;
          Focus;   //FEdit darf beim Destroy nicht den Fokus haben
          FEdit.Hide;
          FEdit.Destroy;
          FEdit:=Nil;
          newTGrid.SelectCell(SelCol,SelRow); //Selection erneuern
          rc:=GridRects[FSelectCol,FSelectRow];
          CaptureFocus;
          InvalidateRect(rc);
          Update;
          If Error Then ErrorBox(ErrorText);
     End
     Else If FEdit<>Nil Then FEdit.Hide;
End;

Procedure newTStringGrid.CharEvent(Var key:Char;RepeatCount:Byte);
Var rc:TRect;
    S:String;
    Ok:Boolean;
Begin
     If ((FOptions*[goEditing]<>[])And(FSelectCol>=0)And(FSelectRow>=0)) Then
     Begin
          Ok:=True;
          If OnCanEdit<>Nil Then OnCanEdit(Self,Col,Row,Ok);
          If Ok Then
          Begin
               S:=key;
               ShowEntry(S);
               rc:=GridRects[FSelectCol,FSelectRow];
               InvalidateRect(rc);
               Update;
               exit;
          End;
     End;

     Inherited CharEvent(key,RepeatCount);
End;

Procedure newTStringGrid.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var
    Ok:Boolean;
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)And(FOptions*[goEditing]<>[])) Then
     Begin
          Case KeyCode Of
             {$IFDEF OS2}
             kbCR,kbEnter:
             {$ENDIF}
             {$IFDEF Win32}
             kbCR:
             {$ENDIF}
             Begin
                  If ((FEdit<>Nil)And(FEdit.Control.Visible)) Then HideEditorIntern
                  Else
                  Begin
                       Ok:=True;
                       If OnCanEdit<>Nil Then OnCanEdit(Self,Col,Row,Ok);
                       If Ok Then ShowEditorIntern;
                  End;
                  KeyCode := kbNull;
             End;
             Else Inherited ScanEvent(KeyCode,RepeatCount);
          End;
     End
     Else Inherited ScanEvent(KeyCode,RepeatCount);
End;


Procedure newTStringGrid.Resize;
Var rc:TRect;
    W,H:LongInt;
Begin
     Inherited Resize;
     If ((FSelectCol>=0)And(FSelectRow>=0)And(FOptions*[goEditing]<>[])And(FEdit<>Nil)And(FEdit.Control.Visible)) Then
     Begin
          rc:=GridRects[FSelectCol,FSelectRow];
          Inc(rc.Left);
          Dec(rc.Top,3);
          Dec(rc.Right);
          Inc(rc.Bottom,2);
          W:=(rc.Right-rc.Left)-2;
          H:=Canvas.Font.Height;
          If rc.Left+W>=Width Then W:=(Width-rc.Left)-1;
          If ((FVertScrollBar<>Nil)And(FVertScrollBar.Visible)) Then
             If rc.Left+W>=FVertScrollBar.Left Then W:=FVertScrollBar.Left-rc.Left;
          If rc.Top-H<=0 Then H:=rc.Top-1;
          FEdit.SetWindowPos(rc.Left,rc.Top-H,W,H);
     End;
End;

Procedure newTStringGrid.SetEditorMode(NewValue:Boolean);
Begin
     If NewValue Then ShowEditorIntern
     Else HideEditorIntern;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TDrawGrid Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure newTDrawGrid.SetupComponent;
Begin
     Inherited SetupComponent;

     FDefaultDrawing:=True;
End;

Procedure newTDrawGrid.MouseToCell(X,Y:LongInt;Var ACol,ARow:LongInt);
Begin
     GetSizeItem(Point(X,Y),ACol,ARow);
End;

Procedure newTDrawGrid.SetDefaultDrawing(NewValue:Boolean);
Begin
     FDefaultDrawing:=NewValue;
     Refresh;
End;

Procedure newTDrawGrid.DrawCell(Col,Row:LongInt;rec:TRect;AState:newTGridDrawState);
Begin
     If ((DefaultDrawing)Or(Designed)) Then Inherited DrawCell(Col,Row,rec,AState);
     If FOnDrawCell<>Nil Then FOnDrawCell(Self,Col,Row,rec,AState);
End;

Procedure newTDrawGrid.SetEditorMode(NewValue:Boolean);
Begin
     If NewValue Then ShowEditor
     Else HideEditor;
End;

Procedure newTDrawGrid.ShowEditor;
Begin
     If ((FSelectCol>=0)And(FSelectRow>=0)And(FOptions*[goEditing]<>[])) Then
     Begin
          FEditorMode:=True;
          OpenEditor(FSelectCol,FSelectRow);
     End;
End;

Procedure newTDrawGrid.HideEditor;
Begin
     If Not FEditorMode Then Exit;
     FEditorMode:=False;
     CloseEditor;
End;

Procedure newTDrawGrid.OpenEditor(Col,Row:LongInt);
Begin
     If FOnOpenEditor<>Nil Then FOnOpenEditor(Self,Col,Row);
End;

Procedure newTDrawGrid.CloseEditor;
Begin
     If FOnCloseEditor<>Nil Then FOnCloseEditor(Self);
End;

Procedure newTDrawGrid.SetupCellColors(Col,Row:LongInt;AState:newTGridDrawState;Var background,ForeGround:TColor);
Begin
     Inherited SetupCellColors(Col,Row,AState,background,ForeGround);
End;

Function newTDrawGrid.SelectCell(Col,Row:LongInt):Boolean;
Var rc:TRect;
Label L;
Begin
     Result:=True;
     If ((FOptions*[goEditing]<>[])And(FOptions*[goAlwaysShowEditor]<>[])) Then
     Begin
L:
          If ((FSelectCol>=0)And(FSelectRow>=0)And(FEditorMode=True)) Then
          Begin
             If ((FSelectCol=Col)And(FSelectRow=Row)) Then Exit;
             HideEditor;
          End;

          If FOptions*[goAlwaysShowEditor]<>[] Then Inherited SelectCell(Col,Row);

          ShowEditor;

          If FOptions*[goAlwaysShowEditor]=[] Then
          Begin
              rc:=GridRects[FSelectCol,FSelectRow];
              InvalidateRect(rc);
              Update;
          End;
     End
     Else
     Begin
          If ((FSelectCol=Col)And(FSelectRow=Row)And(FOptions*[goEditing]<>[])) Then Goto L;
          Inherited SelectCell(Col,Row);
     End;
End;

(*
Begin
End.
*)


Initialization
  {Klassen registrieren}
  RegisterClasses([newTDrawGrid,newTStringGrid]); //roga
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02   WD        Ausbau der LINUX-Teile
  22-Aug-03   WD        Einabau von IndexOf in die Klasse "TStringGrid"
  15-Sep-04   CW        TStringGrid.DrawCell: statt dec den Befehl "Pred" verwenden
  03-Mar-05   WD        TGrid.Redraw: Korrektur der Umrandung unter Windows
  23-Dez-06   WD        Funktion InsertStringGrid eingebaut.
  25-Dez-06   WD        tGrid und tStringGrid: Groessen Anpassung bei Doubleclick.
  02-Feb-09   PE        tStringGrid: Diverse korrekturen (Scrollbar usw.)
  01-Apr-09   PE        tStringGrid: Einbau von DrawCellEvent
  19-Apr-11   RG        TDrawGrid: Einbau von OnExit, OnKeyPress
}



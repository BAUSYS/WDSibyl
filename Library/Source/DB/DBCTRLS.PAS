
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit DBCtrls;

Interface

{$R DBCtrls}

Uses SysUtils,Messages,Classes,Graphics,Forms,Grids,
     Color, uList, uString, uStream,
     DBBase,Buttons,StdCtrls,Dialogs,ExtCtrls,Mask;

Type
    {$M+}
    TDBGridOptions = Set Of
      (dgBorder,dgRowResize,dgColumnResize,dgEditing,dgAlwaysShowEditor,
       dgShowSelection,dgAlwaysShowSelection,dgConfirmDelete,
       dgCancelOnExit,dgIndicator,dgTitles,dgMouseSelect,dgLineNumbers,
       dgEnableMaskEdit);
    {$M-}

    TDBGrid=Class;
    TDBGridColumn=Class;
    TDBGridColumns=Class;

    TDBColumnTitle=Class
       Private
         FCaption:^String;
         FAlignment:TAlignment;
         FFont:TFont;
         FColor:TColor;
         FGrid:TDBGrid;
         FColumn:TDBGridColumn;
         FPenColor:TColor;
       Private
         Function GetFont:TFont;
         Procedure SetFont(NewFont:TFont);
         Procedure SetColor(NewColor:TColor);
         Procedure SetPenColor(NewColor:TColor);
         Procedure SetAlignment(NewValue:TAlignment);
         Function GetCaption:String;
         Procedure SetCaption(Const NewValue:String);
       Public
         Constructor Create(DBGrid:TDBGrid;Column:TDBGridColumn);
         Destructor Destroy;Override;
       Public
         Property Font:TFont Read GetFont Write SetFont;
         Property Color:TColor Read FColor Write SetColor;
         Property PenColor:TColor Read FPenColor Write SetPenColor;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property Caption:String Read GetCaption Write SetCaption;
    End;

    TDBGridColumn=Class
       Private
         FFieldName:^String;
         FTitle:TDBColumnTitle;
         FColor:TColor;
         FGrid:TDBGrid;
         FColumns:TDBGridColumns;
         FWidth:LongInt;
         FAlignment:TAlignment;
         FReadOnly:Boolean;
         FFont:TFont;
         FPenColor:TColor;
       Private
         Function GetFieldName:String;
         Procedure SetFieldName(Const NewValue:String);
         Procedure SetTitle(NewTitle:TDBColumnTitle);
         Procedure SetColor(NewColor:TColor);
         Procedure SetPenColor(NewColor:TColor);
         Function GetWidth:LongInt;
         Procedure SetWidth(NewWidth:LongInt);
         Procedure SetAlignment(NewValue:TAlignment);
         Function GetFont:TFont;
         Procedure SetFont(NewFont:TFont);
       Public
         Constructor Create(DBGrid:TDBGrid;Columns:TDBGridColumns);
         Destructor Destroy;Override;
       Public
         Property FieldName:String Read GetFieldName Write SetFieldName;
         Property Title:TDBColumnTitle Read FTitle Write SetTitle;
         Property Color:TColor Read FColor Write SetColor;
         Property PenColor:TColor Read FPenColor Write SetPenColor;
         Property Width:LongInt Read GetWidth Write SetWidth;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property ReadOnly:Boolean Read FReadOnly Write FReadOnly;
         Property Font:TFont Read GetFont Write SetFont;
    End;

    {$HINTS OFF}
    TDBGridColumns=Class(TList)
        Private
         FAutoCreated:Boolean;
         FGrid:TDBGrid;
         FUpdateLocked:Boolean;
        Private
         Function GetColumn(Index:LongInt):TDBGridColumn;
         Procedure SetColumn(Index:LongInt;Column:TDBGridColumn);
       Protected
         Procedure FreeItem(Item:Pointer);Override;
        Public
         Constructor Create(DBGrid:TDBGrid);
         Destructor Destroy;Override;
         Function Add:TDBGridColumn;
         Procedure Delete(Index:LongInt);
         Procedure BeginUpdate;
         Procedure EndUpdate;
        Public
         Property AutoCreated:Boolean Read FAutoCreated;
         Property Items[Index:LongInt]:TDBGridColumn Read GetColumn Write SetColumn;Default;
         Property Grid:TDBGrid Read FGrid;
    End;
    {$HINTS ON}

    TDBGrid=Class(TStringGrid)
      Private
         FDataLink:TTableDataLink;
         FGridOptions:TDBGridOptions;
         FColumns:TDBGridColumns;
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetGridOptions(NewValue:TDBGridOptions);
         Procedure SetColumns(NewColumns:TDBGridColumns);
      Protected
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure SetFont(NewFont:TFont);Override;
         Procedure Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);Override;
         Procedure SetupComponent;Override;
         Function GetCell(Col,Row:LongInt):String;Override;
         Procedure SetCell(Col,Row:LongInt;Const NewContent:String);Override;
         Function SelectCell(Col,Row:LongInt):Boolean;Override;
         Procedure SetupCellDrawing(Col,Row:LongInt;AState:TGridDrawState;
                                    Var Alignment:TAlignment;Var DrawFont:TFont);Override;
         Procedure SetupCellColors(Col,Row:LongInt;AState:TGridDrawState;Var background,ForeGround:TColor);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Procedure RowHeightChanged(Row:LongInt);Override;
         Procedure ColWidthChanged(Col:LongInt);Override;
         Function ShowEditor(Col,Row:LongInt):TInplaceEditClass;Override;
      Protected
         Property FixedCols;
         Property FixedRows;
         Property ColCount;
         Property RowCount;
         Property Options;
      Public
         Destructor Destroy;Override;
         Procedure DrawCell(Col,Row:LongInt;rec:TRect;AState:TGridDrawState);Override;
      Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property GridOptions:TDBGridOptions Read FGridOptions Write SetGridOptions;
         Property Columns:TDBGridColumns Read FColumns Write SetColumns;
    End;

    TDBEdit=Class(TEdit)
      Private
         FDataLink:TFieldDataLink;
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
         Procedure WriteBack;
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure KillFocus;Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
      Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DataField:String Read GetDataField Write SetDataField;
    End;

    TDBText=Class(TLabel)
      Private
         FDataLink:TFieldDataLink;
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
      Protected
         Procedure SetupComponent;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure SetupShow;Override;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
      Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DataField:String Read GetDataField Write SetDataField;
    End;

    TDBCheckBox=Class(TCheckBox)
      Private
         FDataLink:TFieldDataLink;
         FValueChecked:PString;
         FValueUnchecked:PString;
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
         Procedure SetValueChecked(NewValue:String);
         Function GetValueChecked:String;
         Procedure SetValueUnchecked(NewValue:String);
         Function GetValueUnchecked:String;
         Procedure WriteBack;
      Protected
         Procedure SetupComponent;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure SetupShow;Override;
         Procedure Click;Override;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
      Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property ValueChecked:String Read GetValueChecked Write SetValueChecked;
         Property ValueUnchecked:String Read GetValueUnchecked Write SetValueUnchecked;
         Property DataField:String Read GetDataField Write SetDataField;
    End;


    TDBImage=Class(TImage)
      Private
         FDataLink:TFieldDataLink;
         FChangeLock:Boolean;
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
         Procedure WriteBack;
      Protected
         Procedure SetupComponent;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure SetupShow;Override;
         Procedure Change;Override;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Property Bitmap;
      Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DataField:String Read GetDataField Write SetDataField;
    End;


    TDBMemo=Class(TMemo)
      Private
         FDataLink:TFieldDataLink;
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
         Procedure WriteBack;
      Protected
         Procedure SetupComponent;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure SetupShow;Override;
         Procedure KillFocus;Override;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
      Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DataField:String Read GetDataField Write SetDataField;
    End;

    {$HINTS OFF}
    TDBListBox=Class(TListBox)
      Private
         FDataLink:TFieldDataLink;
         FDBStrings:TStrings;
      Private
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
         Procedure SetItems(NewValue:TStrings);
      Protected
         Procedure SetupComponent;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure SetupShow;Override;
         Procedure ItemFocus(Index:LongInt);Override;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
      Public
         Property Items:TStrings Read FDBStrings Write SetItems;
      Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DataField:String Read GetDataField Write SetDataField;
    End;
    {$HINTS ON}

    TDBComboBox=Class(TComboBox)
       Private
         FDataLink:TFieldDataLink;
         FLock:Boolean;
       Private
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
         Procedure WriteBack;
       Protected
         Procedure EditChange;Override;
         Procedure SetupShow;Override;
         Procedure SetupComponent;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
       Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
       Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DataField:String Read GetDataField Write SetDataField;
    End;

    TDBRadioGroup=Class(TRadioGroup)
       Private
         FDataLink:TFieldDataLink;
         FValues:TStrings;
         FLock:Boolean;
       Private
         Procedure SetDataSource(NewValue:TDataSource);
         Function GetDataSource:TDataSource;
         Procedure SetDataField(NewValue:String);
         Function GetDataField:String;
         Function GetValue:String;
         Procedure SetValue(Const NewValue:String);
         Procedure SetValues(NewValue:TStrings);
         Procedure WriteBack;
       Protected
         Procedure SetupShow;Override;
         Procedure SetupComponent;Override;
         Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
         Procedure ItemIndexChange;Override;
       Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
       Public
         Property Value:String Read GetValue Write SetValue;
         Property Values:TStrings Read FValues Write SetValues;
       Published
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DataField:String Read GetDataField Write SetDataField;
    End;

    {$M+}
    TNavigateBtn=(dbFirst, dbPrior, dbNext, dbLast, dbInsert,
                  dbDelete, dbEdit, dbPost, dbCancel, dbRefresh);
    TNavigateBtnSet=Set Of TNavigateBtn;

    TNavClick=Procedure(Sender:TObject;Button:TNavigateBtn) Of Object;
    {$M-}

    TDBNavigator=Class(TControl)
      Private
         FButtons:Array[TNavigateBtn] Of TBitBtn;
         FVisibleButtons:TNavigateBtnSet;
         FEnabledButtons:TNavigateBtnSet;
         FDataLink:TTableDataLink;
         FOnNavClick:TNavClick;
         Procedure SetVisibleButtons(NewState:TNavigateBtnSet);
         Procedure SetEnabledButtons(NewState:TNavigateBtnSet);
         Function GetButton(Index:TNavigateBtn):TBitBtn;
         Function GetDataSource:TDataSource;
         Procedure SetDataSource(NewValue:TDataSource);
         Procedure EvButtonClick(Sender:TObject);
      Protected
         Procedure CommandEvent(Var Command:TCommand);Override;
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure RealignControls;Override;
         Property Buttons[Index:TNavigateBtn]:TBitBtn Read GetButton;
         Property Hint;
         Property Cursor;
      Public
         Destructor Destroy;Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property EnabledButtons:TNavigateBtnSet Read FEnabledButtons Write SetEnabledButtons;
         Property ParentShowHint;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property VisibleButtons:TNavigateBtnSet Read FVisibleButtons Write SetVisibleButtons;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick:TNavClick Read FOnNavClick Write FOnNavClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseMove;
         Property OnResize;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBGridColumns Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TDBGridColumns.BeginUpdate;
Begin
     FUpdateLocked:=True;
End;

Procedure TDBGridColumns.EndUpdate;
Begin
     FUpdateLocked:=False;
     If FGrid<>Nil Then
      If FGrid.FColumns=Self Then FGrid.Invalidate;
End;

Function TDBGridColumns.GetColumn(Index:LongInt):TDBGridColumn;
Begin
     Result:=TDBGridColumn(Inherited Items[Index]);
End;

Procedure TDBGridColumns.SetColumn(Index:LongInt;Column:TDBGridColumn);
Var OldColumn:TDBGridColumn;
Begin
     OldColumn:=Items[Index];
     If OldColumn<>Column Then OldColumn.Destroy;

     Inherited Items[Index]:=Column;
End;

Procedure TDBGridColumns.FreeItem(Item:Pointer);
Var Column:TDBGridColumn;
Begin
     Inherited FreeItem(Item);
     Column:=Item;
     If Column<>Nil Then Column.Destroy;
End;

Function TDBGridColumns.Add:TDBGridColumn;
Begin
     Result.Create(FGrid,Self);
     Inherited Add(Result);
End;

Procedure TDBGridColumns.Delete(Index:LongInt);
Begin
     Inherited Delete(Index);
     If FGrid<>Nil Then If Not FUpdateLocked Then
       If FGrid.FColumns=Self Then FGrid.Invalidate;
End;

Constructor TDBGridColumns.Create(DBGrid:TDBGrid);
Begin
     Inherited Create;
     FGrid:=DBGrid;
End;

Destructor TDBGridColumns.Destroy;
Begin
     If FGrid<>Nil Then
       If FGrid.FColumns=Self Then FGrid.FColumns:=Nil;
     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBGridColumn Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBGridColumn.GetFieldName:String;
Begin
     If FFieldName<>Nil Then Result:=FFieldName^
     Else Result:='';
End;

Procedure TDBGridColumn.SetFieldName(Const NewValue:String);
Begin
     If FFieldName<>Nil Then FreeMem(FFieldName,Length(FFieldName^)+1);
     GetMem(FFieldName,Length(NewValue)+1);
     FFieldName^:=NewValue;
     If FColumns<>Nil Then
      If Not FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumns Then FGrid.Invalidate;
End;

Procedure TDBGridColumn.SetTitle(NewTitle:TDBColumnTitle);
Begin
     If NewTitle<>FTitle Then FTitle.Destroy;
     FTitle:=NewTitle;
     If FTitle=Nil Then FTitle.Create(FGrid,Self);
     FTitle.FGrid:=FGrid;
     If FColumns<>Nil Then
      If Not FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumns Then FGrid.Invalidate;
End;

Procedure TDBGridColumn.SetColor(NewColor:TColor);
Begin
     FColor:=NewColor;
     If FColumns<>Nil Then
      If Not FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumns Then FGrid.Invalidate;
End;

Procedure TDBGridColumn.SetPenColor(NewColor:TColor);
Begin
     FPenColor:=NewColor;
     If FColumns<>Nil Then
      If Not FColumns.FUpdateLocked Then
        If FGrid.FColumns=FColumns Then FGrid.Invalidate;
End;

Function TDBGridColumn.GetWidth:LongInt;
Begin
     If FGrid.Columns<>Nil Then
       If FGrid.Columns.IndexOf(Self)>=0 Then
         Result:=FGrid.ColWidths[FGrid.FColumns.IndexOf(Self)+FGrid.FixedCols];
End;

Procedure TDBGridColumn.SetWidth(NewWidth:LongInt);
Begin
     If FGrid.Columns<>Nil Then
       If FGrid.Columns.IndexOf(Self)>=0 Then
         FGrid.ColWidths[FGrid.FColumns.IndexOf(Self)+FGrid.FixedCols]:=NewWidth;
End;

Procedure TDBGridColumn.SetAlignment(NewValue:TAlignment);
Begin
     FAlignment:=NewValue;
     If FColumns<>Nil Then
      If Not FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumns Then FGrid.Invalidate;
End;

Function TDBGridColumn.GetFont:TFont;
Begin
     If FFont<>Nil Then Result:=FFont
     Else Result:=FGrid.Font;
End;

Procedure TDBGridColumn.SetFont(NewFont:TFont);
Begin
     If NewFont=FFont Then Exit;
     FFont:=NewFont;
     If FColumns<>Nil Then
      If Not FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumns Then FGrid.Invalidate;
End;

{$HINTS OFF}                    
Constructor TDBGridColumn.Create(DBGrid:TDBGrid;Columns:TDBGridColumns);
Begin
     Inherited Create;
     FGrid:=DBGrid;
     FTitle.Create(FGrid,Self);
     FColor:=FGrid.EntryColor;
     FPenColor:=FGrid.PenColor;
     FWidth:=40;
     FAlignment:=taLeftJustify;
End;
{$HINTS ON}

Destructor TDBGridColumn.Destroy;
Begin
     If FFieldName<>Nil Then FreeMem(FFieldName,Length(FFieldName^)+1);
     If FTitle<>Nil Then FTitle.Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBColumnTitle Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBColumnTitle.GetFont:TFont;
Begin
     If FFont<>Nil Then Result:=FFont
     Else Result:=FGrid.Font;
End;

Procedure TDBColumnTitle.SetFont(NewFont:TFont);
Begin
     If NewFont=FFont Then Exit;
     FFont:=NewFont;
     If FColumn.FColumns<>Nil Then
      If Not FColumn.FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumn.FColumns Then FGrid.Invalidate;
End;

Procedure TDBColumnTitle.SetColor(NewColor:TColor);
Begin
     FColor:=NewColor;
     If FColumn.FColumns<>Nil Then
      If Not FColumn.FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumn.FColumns Then FGrid.Invalidate;
End;

Procedure TDBColumnTitle.SetPenColor(NewColor:TColor);
Begin
     FPenColor:=NewColor;
     If FColumn.FColumns<>Nil Then
      If Not FColumn.FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumn.FColumns Then FGrid.Invalidate;
End;

Procedure TDBColumnTitle.SetAlignment(NewValue:TAlignment);
Begin
     FAlignment:=NewValue;
     If FColumn.FColumns<>Nil Then
      If Not FColumn.FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumn.FColumns Then FGrid.Invalidate;
End;

Constructor TDBColumnTitle.Create(DBGrid:TDBGrid;Column:TDBGridColumn);
Begin
     Inherited Create;

     FGrid:=DBGrid;
     FColumn:=Column;
     FColor:=FGrid.FixedColor;
     FPenColor:=FGrid.PenColor;
     FAlignment:=taLeftJustify;
End;

Destructor TDBColumnTitle.Destroy;
Begin
     If FCaption<>Nil Then FreeMem(FCaption,Length(FCaption^)+1);
     Inherited Destroy;
End;

Function TDBColumnTitle.GetCaption:String;
Begin
     If FCaption<>Nil Then Result:=FCaption^
     Else Result:=FColumn.FieldName;
End;

Procedure TDBColumnTitle.SetCaption(Const NewValue:String);
Begin
     If FCaption<>Nil Then FreeMem(FCaption,Length(FCaption^)+1);
     GetMem(FCaption,Length(NewValue)+1);
     FCaption^:=NewValue;
     If FColumn.FColumns<>Nil Then
      If Not FColumn.FColumns.FUpdateLocked Then
       If FGrid.FColumns=FColumn.FColumns Then FGrid.Invalidate;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBGrid Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type TInplaceDBEdit=Class(TInplaceEdit)
        Protected
            FControl:TControl;
            FFieldType:TFieldType;
        Protected
            Function GetText:String;Override;
            Function GetControl:TComponent;Override;
            Procedure SetText(Const NewValue:String);Override;
            Procedure SetWindowPos(X,Y,W,H:LongInt);Override;
            Procedure SetupEdit(Grid:TGrid);Override;
            Destructor Destroy;Override;
            Procedure Show;Override;
            Procedure Hide;Override;
     End;

Function TInplaceDBEdit.GetText:String;
Begin
     Case FFieldType Of
        ftSmallInt,ftInteger,ftWord,ftFloat,ftCurrency:Result:=TEdit(FControl).Text;
        ftBoolean:Result:=TComboBox(FControl).Text;
        ftDate,ftTime,ftDateTime:Result:=TMaskEdit(FControl).Text;
     End; //case
End;

Function TInplaceDBEdit.GetControl:TComponent;
Begin
     Result:=FControl;
End;

Procedure TInplaceDBEdit.SetText(Const NewValue:String);
Begin
     Case FFieldType Of
        ftSmallInt,ftInteger,ftWord,ftFloat,ftCurrency:TEdit(FControl).Text:=NewValue;
        ftBoolean:TComboBox(FControl).Text:=NewValue;
        ftDate,ftTime,ftDateTime:TMaskEdit(FControl).Text:=NewValue;
     End; //case
End;

Procedure TInplaceDBEdit.SetWindowPos(X,Y,W,H:LongInt);
Begin
     Case FFieldType Of
        ftSmallInt,ftInteger,ftWord,ftFloat,ftCurrency,
        ftDate,ftTime,ftDateTime:FControl.SetWindowPos(X,Y,W,H);
        ftBoolean:FControl.SetWindowPos(X-1,Y+2,W+2,H);
     End; //case
End;

Procedure TInplaceDBEdit.SetupEdit(Grid:TGrid);
Var Edit:TEdit;
    ComboBox:TComboBox;
    FieldType:TFieldType;
    MaskEdit:TMaskEdit;
    Index:Longint;

    Function BuildMask(Value:String):String;
    Var t:LongInt;
    Begin
         If pos(' ampm',Value)<>0 Then Value[0]:=chr(Pos(' ampm',Value)-1);
         If ((pos('h:',Value)=1)Or(pos(' h:',Value)<>0)) Then
           Insert('h',Value,pos('h:',Value));
         For t:=1 To Length(Value) Do
          If Value[t] In ['y','d','m','h','s'] Then Value[t]:='9';
         Result:=Value+';1;0';
    End;
Begin
     Index:=Col-Grid.FixedCols;
     FieldType:=TDBGrid(Grid).FDataLink.DataSource.DataSet.FieldTypes[Index];
     If FControl<>Nil Then If FieldType<>FFieldType Then
     Begin
          FControl.Destroy;
          FControl:=Nil;
     End;
     FFieldType:=FieldType;

     If FControl=Nil Then
     Begin
          Case FFieldType Of
             ftSmallInt,ftInteger,ftWord,ftFloat,ftCurrency:
             Begin
                  Edit.Create(Grid);
                  Edit.NumbersOnly:=True;
                  Edit.BorderStyle:=bsNone;
                  FControl:=Edit;
             End;
             ftBoolean:
             Begin
                  ComboBox.Create(Grid);
                  ComboBox.Style:=csDropDownList;
                  ComboBox.Items.Add('True');
                  ComboBox.Items.Add('False');
                  ComboBox.BorderStyle:=bsNone;
                  FControl:=ComboBox;
             End;
             ftDate:
             Begin
                  MaskEdit.Create(Grid);
                  MaskEdit.BorderStyle:=bsNone;
                  MaskEdit.EditMask:=BuildMask(ShortDateFormat);
                  FControl:=MaskEdit;
             End;
             ftTime:
             Begin
                  MaskEdit.Create(Grid);
                  MaskEdit.BorderStyle:=bsNone;
                  MaskEdit.EditMask:=BuildMask(LongTimeFormat);
                  FControl:=MaskEdit;
             End;
             ftDateTime:
             Begin
                  MaskEdit.Create(Grid);
                  MaskEdit.BorderStyle:=bsNone;
                  MaskEdit.EditMask:=BuildMask(ShortDateFormat+' '+LongTimeFormat);
                  FControl:=MaskEdit;
             End;
          End; //case
     End;
End;

Destructor TInplaceDBEdit.Destroy;
Begin
     FControl.Destroy;
     Inherited Destroy;
End;

Procedure TInplaceDBEdit.Show;
Begin
    If FFieldType=ftBoolean Then TComboBox(FControl).OnExit:=Nil; //!!
    FControl.Show;
End;

Procedure TInplaceDBEdit.Hide;
Begin
     FControl.Hide;
End;

Type
    TColumnsRec=Record
                       ColAlignment:TAlignment;
                       ColColor:TColor;
                       ColPenColor:TColor;
                       ColWidth:LongInt;
                       ColReadOnly:Boolean;
                       TitleAlignment:TAlignment;
                       TitleColor:TColor;
                       TitlePenColor:TColor;
     End;

Function TDBGrid.ShowEditor(Col,Row:LongInt):TInplaceEditClass;
Var FieldType:TFieldType;
Begin
     Col:=Col-FixedCols;
     Result:=Nil; //default editor
     If FGridOptions*[dgEnableMaskEdit]<>[] Then
       If FDataLink.DataSource<>Nil Then
          If FDataLink.DataSource.DataSet<>Nil Then
            If FDataLink.DataSource.DataSet.Active Then
              If Col>=0 Then
                If Col<=FDataLink.DataSource.DataSet.FieldCount Then
     Begin
          FieldType:=FDataLink.DataSource.DataSet.FieldTypes[Col];
          Case FieldType Of
             ftSmallInt,ftInteger,ftWord,ftBoolean,
             ftFloat,ftCurrency:Result:=TInplaceDBEdit;
             ftDate,ftTime,ftDateTime:Result:=TInplaceDBEdit;
          End; //case
     End;
End;

Procedure TDBGrid.SetFont(NewFont:TFont);
Var Column:TDBGridColumn;
    OldFont:TFont;
    T:LongInt;
Begin
     OldFont:=Font;
     Inherited SetFont(NewFont);

     If ((NewFont<>OldFont)And(FColumns<>Nil)) Then For T:=0 To FColumns.Count-1 Do
     Begin
          Column:=FColumns[T];
          If Column.Font=OldFont Then Column.Font:=NewFont;
          If Column.Title.Font=OldFont Then Column.Title.Font:=NewFont;
     End;
End;

{$HINTS OFF}
Procedure TDBGrid.RowHeightChanged(Row:LongInt);
Begin
End;
{$HINTS ON}

Procedure TDBGrid.ColWidthChanged(Col:LongInt);
Var Column:TDBGridColumn;
Begin
     If FColumns<>Nil Then
     Begin
          If Col-FixedCols>=0 Then
            If Col-FixedCols<=FColumns.Count-1 Then
            Begin
                 Column:=FColumns.Items[Col-FixedCols];
                 If Column<>Nil Then Column.Width:=ColWidths[Col];
            End;
          FColumns.FAutoCreated := False;
     End;
End;

Function TDBGrid.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Column:TDBGridColumn;
    rec:TColumnsRec;
    S,s1:String;
    Attrs:TFontAttributes;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FColumns<>Nil Then
       If Not FColumns.AutoCreated Then
         If FColumns.Count>0 Then
     Begin
          MemStream.Create;

          T:=FColumns.Count-1;
          MemStream.WriteBuffer(T,4);  //Array elements
          For T:=0 To FColumns.Count-1 Do
          Begin
               Column:=FColumns.Items[T];

               rec.ColAlignment:=Column.Alignment;
               rec.ColColor:=Column.color;
               rec.ColPenColor:=Column.PenColor;
               rec.ColWidth:=Column.Width;
               rec.ColReadOnly:=Column.ReadOnly;
               rec.TitleAlignment:=Column.Title.Alignment;
               rec.TitlePenColor:=Column.Title.PenColor;
               rec.TitleColor:=Column.Title.color;

               MemStream.WriteBuffer(rec,SizeOf(TColumnsRec));

               S:=Column.FieldName;
               MemStream.WriteBuffer(S,Length(S)+1);
               S:=Column.Title.Caption;
               MemStream.WriteBuffer(S,Length(S)+1);

               If Column.Font=Font Then S:=''
               Else
               Begin
                    S:=Column.Font.FaceName;
                    If Column.Font.IsDefault Then S:='System Default Font';
                    S:=tostr(Column.Font.PointSize)+'.'+S;

                    s1:=S;
                    UpcaseStr(s1);
                    Attrs:=Column.Font.Attributes;
                    If Attrs*[faBold]<>[] Then If Pos(' BOLD',s1)=0 Then S:=S+'!BOLD!';
                    If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',s1)=0 Then S:=S+'!ITALIC!';
                    If Attrs*[faOutline]<>[] Then S:=S+'!OUTLINE!';
                    If Attrs*[faStrikeOut]<>[] Then S:=S+'!STRIKEOUT!';
                    If Attrs*[faUnderScore]<>[] Then S:=S+'!UNDERSCORE!';
               End;
               MemStream.WriteBuffer(S,Length(S)+1);

               If Column.Title.Font=Font Then S:=''
               Else
               Begin
                    S:=Column.Title.Font.FaceName;
                    If Column.Title.Font.IsDefault Then S:='System Default Font';
                    S:=tostr(Column.Title.Font.PointSize)+'.'+S;

                    s1:=S;
                    UpcaseStr(s1);
                    Attrs:=Column.Title.Font.Attributes;
                    If Attrs*[faBold]<>[] Then If Pos(' BOLD',s1)=0 Then S:=S+'!BOLD!';
                    If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',s1)=0 Then S:=S+'!ITALIC!';
                    If Attrs*[faOutline]<>[] Then S:=S+'!OUTLINE!';
                    If Attrs*[faStrikeOut]<>[] Then S:=S+'!STRIKEOUT!';
                    If Attrs*[faUnderScore]<>[] Then S:=S+'!UNDERSCORE!';
               End;
               MemStream.WriteBuffer(S,Length(S)+1);
          End;

          If MemStream.Size>0 Then Result:=Stream.NewResourceEntry(rnDBGridCols,
                                                                   MemStream.Memory^,MemStream.Size);
          MemStream.Destroy;
     End;
End;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;
Begin
     Result:=FontName;
     UpcaseStr(FontName);
     If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',FontName)=0 Then Result:=Result+'.Italic';
     If Attrs*[faBold]<>[] Then If Pos(' BOLD',FontName)=0 Then Result:=Result+'.Bold';
     If Attrs*[faOutline]<>[] Then Result:=Result+'.Outline';
     If Attrs*[faStrikeOut]<>[] Then Result:=Result+'.Strikeout';
     If Attrs*[faUnderScore]<>[] Then Result:=Result+'.Underscore';
End;

Procedure TDBGrid.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var Count:^LongInt;
    T,t1:LongInt;
    Temp:^Byte;
    Column:TDBGridColumn;
    rec:TColumnsRec;
    S,s1:String;
    PointSize:LongInt;
    C:Integer;
    Attrs:TFontAttributes;
Begin
     If ResName=rnDBGridCols Then
     Begin
          Count:=@Data;
          Temp:=@Data;
          Inc(Temp,4);
          If Count^>=0 Then  //FColumns.Count-1 was written to SCU
          Begin
               FColumns.Create(Self);
               FColumns.BeginUpdate;
          End;
          For T:=0 To Count^ Do
          Begin
               Column:=FColumns.Add;
               System.Move(Temp^,rec,SizeOf(TColumnsRec));
               Inc(Temp,SizeOf(TColumnsRec));
               Column.Alignment:=rec.ColAlignment;
               Column.color:=rec.ColColor;
               Column.PenColor:=rec.ColPenColor;
               Column.Width:=rec.ColWidth;
               Column.ReadOnly:=rec.ColReadOnly;
               Column.Title.Alignment:=rec.TitleAlignment;
               Column.Title.PenColor:=rec.TitlePenColor;
               Column.Title.color:=rec.TitleColor;

               System.Move(Temp^,S,Temp^+1);
               Inc(Temp,Temp^+1);
               Column.FieldName:=S;
               System.Move(Temp^,S,Temp^+1);
               Inc(Temp,Temp^+1);
               Column.Title.Caption:=S;

               System.Move(Temp^,S,Temp^+1);
               Inc(Temp,Temp^+1);
               If S<>'' Then
               Begin
                    Attrs:=[];
                    t1:=Pos('!',S);
                    If t1<>0 Then
                    Begin
                         If Pos('!BOLD!',S)<>0 Then Attrs:=Attrs+[faBold];
                         If Pos('!ITALIC!',S)<>0 Then Attrs:=Attrs+[faItalic];
                         If Pos('!OUTLINE!',S)<>0 Then Attrs:=Attrs+[faOutline];
                         If Pos('!STRIKEOUT!',S)<>0 Then Attrs:=Attrs+[faStrikeOut];
                         If Pos('!UNDERSCORE!',S)<>0 Then Attrs:=Attrs+[faUnderScore];
                         If Attrs<>[] Then S[0]:=Chr(t1-1);
                    End;

                    PointSize:=0;
                    If Pos('.',S)<>0 Then
                    Begin
                         s1:=Copy(S,1,Pos('.',S)-1);
                         Delete(S,1,Pos('.',S));
                         Val(s1,PointSize,C);
                    End;
                    S:=ModifyFontName(S,Attrs);
                    Column.Font:=Screen.GetFontFromPointSize(S,PointSize);
               End;

               System.Move(Temp^,S,Temp^+1);
               Inc(Temp,Temp^+1);
               If S<>'' Then
               Begin
                    Attrs:=[];
                    t1:=Pos('!',S);
                    If t1<>0 Then
                    Begin
                         If Pos('!BOLD!',S)<>0 Then Attrs:=Attrs+[faBold];
                         If Pos('!ITALIC!',S)<>0 Then Attrs:=Attrs+[faItalic];
                         If Pos('!OUTLINE!',S)<>0 Then Attrs:=Attrs+[faOutline];
                         If Pos('!STRIKEOUT!',S)<>0 Then Attrs:=Attrs+[faStrikeOut];
                         If Pos('!UNDERSCORE!',S)<>0 Then Attrs:=Attrs+[faUnderScore];
                         If Attrs<>[] Then S[0]:=Chr(t1-1);
                    End;

                    PointSize:=0;
                    If Pos('.',S)<>0 Then
                    Begin
                         s1:=Copy(S,1,Pos('.',S)-1);
                         Delete(S,1,Pos('.',S));
                         Val(s1,PointSize,C);
                    End;
                    S:=ModifyFontName(S,Attrs);
                    Column.Title.Font:=Screen.GetFontFromPointSize(S,PointSize);
               End;
          End;
          If FColumns<>Nil Then FColumns.EndUpdate;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure TDBGrid.SetColumns(NewColumns:TDBGridColumns);
Var T:LongInt;
    Column:TDBGridColumn;
Begin
     If NewColumns<>FColumns Then If FColumns<>Nil Then FColumns.Destroy;
     FColumns:=NewColumns;

     If FColumns<>Nil Then FColumns.FGrid:=Self;

     If FColumns<>Nil Then If FColumns.Count=0 Then
     Begin
          FColumns.Destroy;
          FColumns:=Nil;
     End;

     If FColumns<>Nil Then
     Begin
          ColCount:=FColumns.Count+FixedCols;
          For T:=0 To FColumns.Count-1 Do
          Begin
               Column:=FColumns.Items[T];
               ColWidths[T+FixedCols]:=Column.Width;
          End;
     End
     Else
     Begin
          If FDataLink.DataSource<>Nil Then ColCount:=FDataLink.FieldCount+FixedCols;
     End;

     Invalidate;
End;

Procedure TDBGrid.SetGridOptions(NewValue:TDBGridOptions);
Var IOptions:TGridOptions;
Begin
     IOptions:=[];
     FGridOptions:=NewValue;
     If FGridOptions*[dgBorder]<>[] Then Include(IOptions,goBorder);
     If FGridOptions*[dgRowResize]<>[] Then Include(IOptions,goRowSizing);
     If FGridOptions*[dgColumnResize]<>[] Then Include(IOptions,goColSizing);
     If FGridOptions*[dgEditing]<>[] Then Include(IOptions,goEditing);
     If FGridOptions*[dgAlwaysShowEditor]<>[] Then Include(IOptions,goAlwaysShowEditor);
     If FGridOptions*[dgShowSelection]<>[] Then Include(IOptions,goShowSelection);
     If FGridOptions*[dgAlwaysShowSelection]<>[] Then Include(IOptions,goAlwaysShowSelection);
     If FGridOptions*[dgMouseSelect]<>[] Then Include(IOptions,goMouseSelect);
     Inherited Options:=IOptions;

     If FGridOptions*[dgIndicator]=[] Then FixedCols:=0
     Else FixedCols:=1;
     If FGridOptions*[dgTitles]=[] Then FixedRows:=0
     Else FixedRows:=1;
End;

Function TDBGrid.SelectCell(Col,Row:LongInt):Boolean;
Begin
     Result:=Inherited SelectCell(Col,Row);
     If FDataLink.DataSource<>Nil Then
      If FDataLink.DataSource.DataSet<>Nil Then
        If FDataLink.DataSource.DataSet.Active Then
        Begin
             Try
                FDataLink.DataSource.DataSet.CurrentRow:=Row-1;
             Except
                ON E:ESQLError Do ErrorBox(E.Message);
                Else Raise;
             End;
        End;
End;

Procedure TDBGrid.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Begin
     If ScrollCode In [scVertTrack,scHorzTrack] Then Exit;
     Inherited Scroll(ScrollBar,ScrollCode,ScrollPos);
End;

Procedure TDBGrid.SetupCellColors(Col,Row:LongInt;AState:TGridDrawState;Var background,ForeGround:TColor);
Var Col1:LongInt;
    Column:TDBGridColumn;
Begin
     Col1:=Col-FixedCols;
     If ((FColumns<>Nil)And(Col1>=0)And(Col1<FColumns.Count)) Then
     Begin
          Column:=FColumns.Items[Col1];
          If Row<FixedRows Then
          Begin
               background:=Column.Title.color;
               ForeGround:=Column.Title.PenColor;
          End
          Else
          Begin
               background:=Column.color;
               ForeGround:=Column.PenColor;
          End;
     End
     Else Inherited SetupCellColors(Col,Row,AState,background,ForeGround);

     If AState*[gdFixed]=[] Then
     Begin
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
                    background:=clHighlight;
                    ForeGround:=clHighlightText;
               End;
          End;
     End;
End;

Procedure TDBGrid.SetupCellDrawing(Col,Row:LongInt;AState:TGridDrawState;
                                   Var Alignment:TAlignment;Var DrawFont:TFont);
Var Col1:LongInt;
    Column:TDBGridColumn;
Begin
     Col1:=Col-FixedCols;
     If ((FColumns<>Nil)And(Col1>=0)And(Col1<FColumns.Count)) Then
     Begin
          Column:=FColumns.Items[Col1];
          If Row<FixedRows Then
          Begin
               Alignment:=Column.Title.Alignment;
               DrawFont:=Column.Title.Font;
          End
          Else
          Begin
               Alignment:=Column.Alignment;
               DrawFont:=Column.Font;
          End;
     End
     Else Inherited SetupCellDrawing(Col,Row,AState,Alignment,DrawFont);
End;

Procedure TDBGrid.DrawCell(Col,Row:LongInt;rec:TRect;AState:TGridDrawState);
Var rc:TRect;
    X,Y,CX,CY:LongInt;
    s:String;
Begin
     If Canvas=Nil Then Exit;

     Inherited DrawCell(Col,Row,rec,AState);

     If ((AState*[gdFixed]<>[])And(Col=0)And(Col<FixedCols)And(Row-FixedRows>=0)And
         (FDataLink.DataSource<>Nil)And(FDataLink.DataSource.DataSet<>Nil)) Then
     Begin
          If Row-FixedRows=FDataLink.DataSource.DataSet.CurrentRow Then
          Begin
               {Draw Polygon To Mark Current Row In DataSet}
               rc:=GridRects[Col,Row];
               Canvas.ClipRect := rc;
               X:=rc.Left+((((rc.Right-rc.Left)-10) Div 2));
               Y:=rc.Bottom+(((rc.Top-rc.Bottom)-10) Div 2);
               Canvas.Pen.Color:=PenColor;
               If FDataLink.DataSource.DataSet.RowInserted
               Then Canvas.PolyLine([Point(X,Y),Point(X,Y+10),Point(X+10,Y+5),Point(X,Y)])
               Else Canvas.Polygon([Point(X,Y),Point(X,Y+10),Point(X+10,Y+5),Point(X,Y)]);
          End
          Else
          Begin
               If dgLineNumbers In FGridOptions Then
               Begin
                    rc:=GridRects[Col,Row];
                    Canvas.ClipRect:=rc;
                    s:=tostr(Row-FixedRows+1);
                    Canvas.GetTextExtent(s,CX,CY);
                    X:=rc.Right-3-CX;
                    Y:=rc.Top-2-Canvas.Font.Height;
                    Canvas.Pen.Color:=PenColor;
                    Canvas.TextOut(X,Y,s);
               End;
          End;
     End;
End;

Function TDBGrid.GetCell(Col,Row:LongInt):String;
Var
    Field:TField;
    Column:TDBGridColumn;
    Col1:LongInt;
Begin
     Result:='';

     If Row<=FixedRows-1 Then
     Begin
          If Row=0 Then If Col>=FixedCols-1 Then
          Begin
               If FColumns<>Nil Then
               Begin
                    Col1:=Col-FixedCols;
                    If ((Col1>=0)And(Col1<FColumns.Count)) Then
                    Begin
                         Column:=FColumns.Items[Col1];
                         Result:=Column.Title.Caption;
                         If Result='' Then Result:=Column.FieldName;
                    End
                    Else Result:=Inherited GetCell(Col,Row);
               End
               Else
               Begin
                    If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;
                    Result:=FDataLink.DataSource.DataSet.FieldNames[Col-FixedCols];
               End;
          End;
     End
     Else If Col<=FixedCols-1 Then Exit
     Else
     Begin
          Try
             Field:=Nil;
             If FColumns<>Nil Then
             Begin
                  Col1:=Col-FixedCols;
                  If ((Col1>=0)And(Col1<FColumns.Count)) Then
                  Begin
                       If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then
                       Begin
                            Result:=Inherited GetCell(Col,Row);
                            Exit;
                       End;

                       Column:=FColumns.Items[Col1];
                       Field:=FDataLink.FieldsFromColumnName[Column.FieldName,Row-FixedRows];
                       If Field=Nil Then //ColumnName does Not exist
                       Begin
                            Result:=Inherited GetCell(Col,Row);
                            Exit;
                       End;
                  End
                  Else
                  Begin
                       Result:=Inherited GetCell(Col,Row);
                       Exit;
                  End;
             End
             Else
             Begin
                  If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;
                  Field:=FDataLink.Fields[Col-FixedCols,Row-FixedRows];
                  If Field=Nil Then RowCount:=Row;  {no more Rows}
             End;
          Except
             ON E:ESQLError Do
             Begin
                  ErrorBox(E.Message);
                  Field:=Nil;
             End;
             Else Raise;
          End;
          If Field<>Nil Then Result:=Field.AsString;
     End;
End;

{$HINTS OFF}
Procedure TDBGrid.SetCell(Col,Row:LongInt;Const NewContent:String);
Var Field:TField;
    Column:TDBGridColumn;
    Col1:LongInt;
Begin
     If FDataLink.DataSource=Nil Then Exit;
     If FDataLink.DataSource.DataSet=Nil Then Exit;

     If ((Col<FixedCols)Or(Row<FixedRows)) Then Exit;

     Try
        Field:=Nil;
        If FColumns<>Nil Then
        Begin
             Col1:=Col-FixedCols;
             If ((Col1>=0)And(Col1<FColumns.Count)) Then
             Begin
                  Column:=FColumns.Items[Col1];
                  If Not Column.ReadOnly Then
                  Begin
                       Field:=FDataLink.FieldsFromColumnName[Column.FieldName,Row-FixedRows];
                       If Field=Nil Then //ColumnName does Not exist
                       Begin
                            Inherited SetCell(Col,Row,NewContent);
                            Exit;
                       End;
                  End;
             End
             Else
             Begin
                  Inherited SetCell(Col,Row,NewContent);
                  Exit;
             End;
        End
        Else Field:=FDataLink.Fields[Col-FixedCols,Row-FixedRows];
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;

     If Field=Nil Then Exit;

     If Field.AsString=NewContent Then Exit;
     Field.AsString:=NewContent;
     If Not FDataLink.DataSource.DataSet.RowInserted
     Then FDataLink.DataSource.DataSet.Post
     Else FDataLink.DataSource.DataSet.Refresh;
End;

Procedure TDBGrid.DataChange(Sender:TObject;event:TDataChange);
Var Col,Row:LongInt;
    I:LongInt;
    FieldClass:TFieldClass;
    LastRow:LongInt;
    T,t1:LongInt;
    X,Y:LongInt;
    su:Boolean;
    Max:LongInt;
    dummy:TDBGridColumn;
Begin
     If Event=deTableNameChanged Then
     Begin
          Columns:=Nil;
          exit;
     End;

     GridUpdateLocked:=True;
     If FDataLink.DataSource<>Nil Then
     Begin
          If (FColumns=Nil) And (FDataLink.FieldCount>0) Then
          Begin
               //add default columns
               ColCount:=FDataLink.FieldCount+FixedCols;  {!!}

               FColumns.Create(Self);
               FColumns.FAutoCreated := True;

               For t:=0 To FDataLink.FieldCount-1 Do
               Begin
                   dummy:=FColumns.Add;
                   dummy.Alignment:=taLeftJustify;
                   dummy.Color:=clEntryField;
                   dummy.PenColor:=clBlack;
                   dummy.Width:=DefaultColWidth;
                   dummy.Font:=Font;
                   dummy.FieldName:=FDataLink.FieldNames[t];
                   dummy.Title.Alignment:=taLeftJustify;
                   dummy.Title.Color:=clLtGray;
                   dummy.Title.PenColor:=clBlack;
                   dummy.Title.Font:=Font;
                   If FDataLink.DataSource.DataSet<>Nil Then
                   Begin
                        FieldClass:=FDataLink.DataSource.DataSet.FieldDefs[t].FieldClass;
                        If (FieldClass Is TMemoField) Or
                           (FieldClass Is TBlobField)
                        Then dummy.ReadOnly:=True;

                        If (FieldClass Is TSmallintField) Or
                           (FieldClass Is TIntegerField) Or
                           (FieldClass Is TFloatField)
                        Then dummy.Alignment:=taRightJustify;

                        If (FieldClass Is TStringField)
                        Then dummy.Width:=Font.Width*FDataLink.DataSource.DataSet.FieldDefs[t].Size Div 2;
                   End;
               End;
          End;

          If (FDataLink.FieldCount = 0) Then
            If FColumns <> Nil Then
              If FColumns.FAutoCreated Then
              Begin
                   //remove default columns
                   SetColumns(Nil);
              End;

          If FColumns<>Nil Then ColCount:=FColumns.Count+FixedCols
          Else ColCount:=FDataLink.FieldCount+FixedCols;

          If FDataLink.DataSource.DataSet<>Nil Then
          Begin
               If RowCount<>FDataLink.DataSource.DataSet.MaxRows+FixedRows Then
                  RowCount:=FDataLink.DataSource.DataSet.MaxRows+FixedRows;

               //check If CurrentRow fits In Window
               Max:=FDataLink.DataSource.DataSet.CurrentRow;
               If Max<>-1 Then
               Begin
                    If Max<TopRow Then
                    Begin
                         {Scroll up}
                         FUpScrolled:=0;
                         FUpExtent:=0;
                         su:=True;
                    End
                    Else su:=False;

                    //check If marker would fit In Window
                    If GridOptions*[dgBorder]<>[] Then Y:=Height-1
                    Else Y:=Height;
                    If HorzScrollBar<>Nil Then
                      If HorzScrollBar.Visible Then Dec(Y,HorzScrollBar.Height);
                    For T:=0 To FixedRows-1 Do Dec(Y,RowHeights[T]);
                    For T:=FixedRows+TopRow To FixedRows+Max Do Dec(Y,RowHeights[T]);
                    If Y<0 Then //Scroll
                    Begin
                         T:=TopRow;
                         For t1:=FixedRows+TopRow To FixedRows+Max Do
                         Begin
                              Inc(FUpExtent,RowHeights[t1]);
                              Inc(T);
                              Inc(Y,RowHeights[t1]);
                              If Y>0 Then break;
                         End;
                         FUpScrolled:=T;
                    End;
                    VertScrollBar.Position:=FUpExtent;
                    Invalidate;
               End;
          End;
     End;
     GridUpdateLocked:=False;  //Redraw whole Grid
End;
{$HINTS ON}

Procedure TDBGrid.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBGrid.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBGrid.SetupComponent;
Begin
     Inherited SetupComponent;

     FGridOptions:=[dgBorder,dgShowSelection,dgTitles,dgIndicator,dgMouseSelect,dgEnableMaskEdit];
     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
     ColWidths[0]:=20;
End;

Destructor TDBGrid.Destroy;
Begin
     If FColumns<>Nil Then FColumns.Destroy;
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;

     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBEdit Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBEdit.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;

     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBEdit.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure TDBEdit.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBEdit.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBEdit.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBEdit.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Procedure TDBEdit.SetupComponent;
Begin
     Inherited SetupComponent;

     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
End;

Destructor TDBEdit.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;

     Inherited Destroy;
End;

{$HINTS OFF}
Procedure TDBEdit.DataChange(Sender:TObject;event:TDataChange);
Var Field:TField;
Begin
     Try
        Field:=FDataLink.Field;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
     If Field<>Nil Then Caption:=Field.AsString
     Else Caption:='';
End;
{$HINTS ON}

Procedure TDBEdit.SetupShow;
Begin
     Inherited SetupShow;
     DataChange(FDataLink,deDSNChanged);
End;


Procedure TDBEdit.WriteBack;
Var  S:String;
     Field:TField;
Begin
     If FDataLink = Nil Then exit;
     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;
     S:=Text;

     Try
        Field:=FDataLink.Field;
        If Field<>Nil Then
          If Field.AsString<>S Then
          Begin
               Field.AsString:=S;
               If Not FDataLink.DataSource.DataSet.RowInserted
               Then FDataLink.DataSource.DataSet.Post
               Else FDataLink.DataSource.DataSet.Refresh;
          End;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
End;

Procedure TDBEdit.KillFocus;
Begin
     WriteBack;

     Inherited KillFocus;
End;

Procedure TDBEdit.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     If KeyCode=kbCR Then WriteBack;

     Inherited ScanEvent(KeyCode,RepeatCount);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBText Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBText.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;
     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBText.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Procedure TDBText.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBText.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBText.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBText.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Procedure TDBText.SetupComponent;
Begin
     Inherited SetupComponent;

     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);

     Caption:=Name;
     AutoSize:=False;
End;

Destructor TDBText.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;

     Inherited Destroy;
End;

{$HINTS OFF}
Procedure TDBText.DataChange(Sender:TObject;event:TDataChange);
Var Field:TField;
Begin
     Try
        Field:=FDataLink.Field;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
     If Field<>Nil Then Caption:=Field.AsString
     Else Caption:='';
End;
{$HINTS ON}

Procedure TDBText.SetupShow;
Begin
     Inherited SetupShow;
     DataChange(FDataLink,deDSNChanged);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBCheckBox Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBCheckBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;
     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBCheckBox.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Procedure TDBCheckBox.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBCheckBox.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBCheckBox.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBCheckBox.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Procedure TDBCheckBox.SetupComponent;
Begin
     Inherited SetupComponent;

     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);

     Caption:=Name;

     ValueChecked := 'True';
     ValueUnchecked := 'False';
End;

Destructor TDBCheckBox.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;
     If FValueChecked<>Nil Then FreeMem(FValueChecked,Length(FValueChecked^)+1);
     FValueChecked:=Nil;
     If FValueUnchecked<>Nil Then FreeMem(FValueUnchecked,Length(FValueUnchecked^)+1);
     FValueUnchecked:=Nil;

     Inherited Destroy;
End;


Procedure TDBCheckBox.WriteBack;
Var S:String;
    Field:TField;
Begin
     If FDataLink = Nil Then exit;
     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;
     If Checked Then S:=ValueChecked
     Else S:=ValueUnchecked;

     Try
        Field:=FDataLink.Field;
        If Field<>Nil Then
          If Field.AsString<>S Then
          Begin
               Field.AsString:=S;
               If Not FDataLink.DataSource.DataSet.RowInserted
               Then FDataLink.DataSource.DataSet.Post
               Else FDataLink.DataSource.DataSet.Refresh;
          End;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
End;

Procedure TDBCheckBox.Click;
Begin
     Inherited Click;

     WriteBack;
End;

{$HINTS OFF}
Procedure TDBCheckBox.DataChange(Sender:TObject;event:TDataChange);
Var Field:TField;
    S,s1:String;
    Value:String;
    B:Byte;
Begin
     Try
        Field:=FDataLink.Field;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
     If Field<>Nil Then
     Begin
          Value:=Field.AsString;
          If Value <> '' Then
          Begin
               S:=ValueChecked;
               UpcaseStr(S);
               UpcaseStr(Value);
               B:=Pos(';',S);
               While B<>0 Do
               Begin
                    s1:=Copy(S,1,B-1);
                    Delete(S,1,B);
                    If s1=Value Then
                    Begin
                         Checked:=True;
                         Exit;
                    End;
                    B:=Pos(';',S);
               End;
               Checked:=S=Value;
          End
          Else State:=cbGrayed;
     End
     //Else Checked:=False;
     Else State:=cbGrayed;
End;
{$HINTS ON}

Procedure TDBCheckBox.SetupShow;
Begin
     Inherited SetupShow;
     DataChange(FDataLink,deDSNChanged);
End;

Procedure TDBCheckBox.SetValueChecked(NewValue:String);
Begin
     If FValueChecked<>Nil Then FreeMem(FValueChecked,Length(FValueChecked^)+1);
     If NewValue<>'' Then
     Begin
          GetMem(FValueChecked,Length(NewValue)+1);
          FValueChecked^:=NewValue;
     End
     Else FValueChecked:=Nil;
End;

Function TDBCheckBox.GetValueChecked:String;
Begin
     If FValueChecked=Nil Then Result:=''
     Else Result:=FValueChecked^;
End;

Procedure TDBCheckBox.SetValueUnchecked(NewValue:String);
Begin
     If FValueUnchecked<>Nil Then FreeMem(FValueUnchecked,Length(FValueUnchecked^)+1);
     If NewValue<>'' Then
     Begin
          GetMem(FValueUnchecked,Length(NewValue)+1);
          FValueUnchecked^:=NewValue;
     End
     Else FValueUnchecked:=Nil;
End;

Function TDBCheckBox.GetValueUnchecked:String;
Begin
     If FValueUnchecked=Nil Then Result:=''
     Else Result:=FValueUnchecked^;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBImage Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBImage.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;
     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBImage.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Procedure TDBImage.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBImage.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBImage.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBImage.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Procedure TDBImage.SetupComponent;
Begin
     Inherited SetupComponent;

     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
End;

Destructor TDBImage.Destroy;
Begin
(* destroyed In Inherited
     If FBitmap<>Nil Then
     Begin
          FBitmap.Destroy;
          FBitmap:=Nil;
     End;
*)
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;

     Inherited Destroy;
End;

Procedure TDBImage.SetupShow;
Begin
     NeedBitmap := False;
     Inherited SetupShow;
     DataChange(FDataLink,deDSNChanged);
End;

//Inhalt der Grafik hat sich gendert - in DB zurckschreiben
Procedure TDBImage.Change;
Begin
     If FChangeLock Then exit;

     Inherited Change;

     FChangeLock:=True;
     WriteBack;

     FChangeLock:=False;
End;

{$HINTS OFF}
Procedure TDBImage.DataChange(Sender:TObject;event:TDataChange);
Var  Field:TField;
Begin
     If FChangeLock Then exit;
     FChangeLock:=True;
     Try
        Field := FDataLink.Field;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else
        Begin
             FChangeLock:=False;
             Raise;
        End;
     End;
     If Field Is TBlobField Then
     Begin
          Try
             {creates A New Bitmap In GetBitmap If FBitmap = Nil}
             Bitmap.LoadFromMem(TBlobField(Field).Value^,Field.ValueLen);
          Except
             Bitmap := Nil;
          End;
     End
     Else Bitmap := Nil;

     Invalidate;
     FChangeLock:=False;
End;
{$HINTS ON}

Procedure TDBImage.WriteBack;
Var  Field:TBlobField;
     Stream:TMemoryStream;
Begin
     If FDataLink = Nil Then exit;
     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;

     Try
        Field:=TBlobField(FDataLink.Field);
        If Field<>Nil Then
        Begin
          If Field Is TBlobField Then
          Begin
            Stream.Create;
            Bitmap.SaveToStream(Stream);
            Field.LoadFromStream(Stream);
            Stream.Destroy;

            If Not FDataLink.DataSource.DataSet.RowInserted
            Then FDataLink.DataSource.DataSet.Post
            Else FDataLink.DataSource.DataSet.Refresh;
          End;
        End;
     Except
        On E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBMemo Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBMemo.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;
     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBMemo.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Procedure TDBMemo.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBMemo.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBMemo.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBMemo.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Procedure TDBMemo.SetupComponent;
Begin
     Inherited SetupComponent;

     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
End;

Destructor TDBMemo.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;

     Inherited Destroy;
End;

{$HINTS OFF}
Procedure TDBMemo.DataChange(Sender:TObject;event:TDataChange);
Var Field:TField;
Begin
     Try
        Field:=FDataLink.Field;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
     If Field<>Nil Then
     Begin
          If Field Is TBlobField Then
            Lines.SetText(PChar(TBlobField(Field).Value))
          Else If Field Is TMemoField Then
            Lines.SetText(PChar(TMemoField(Field).Value))
          Else
            Lines.SetText(Nil);
     End
     Else
     Begin
          Lines.SetText(Nil);
     End;
End;
{$HINTS ON}

Procedure TDBMemo.SetupShow;
Begin
     Inherited SetupShow;
     DataChange(FDataLink,deDSNChanged);
End;


Procedure TDBMemo.WriteBack;
Var  Ansi:AnsiString;
     pc:PChar;
     Field:TField;
Begin
     If FDataLink = Nil Then exit;
     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;

     Try
        Field:=FDataLink.Field;
        If Field<>Nil Then
        Begin
          pc:=Lines.GetText;
          If pc <> Nil Then
          Begin
               Ansi:=pc^;
               StrDispose(pc);
          End
          Else Ansi := '';

          If Field.AsAnsiString<>Ansi Then
          Begin
               Field.AsAnsiString:=Ansi;
               If Not FDataLink.DataSource.DataSet.RowInserted
               Then FDataLink.DataSource.DataSet.Post
               Else FDataLink.DataSource.DataSet.Refresh;
          End;
        End;
     Except
        On E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
End;

Procedure TDBMemo.KillFocus;
Begin
     WriteBack;

     Inherited KillFocus;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBListBox Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBListBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;
     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBListBox.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Procedure TDBListBox.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBListBox.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBListBox.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBListBox.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Type
  TDBListBoxStrings=Class(TStrings)
      Private
         Items:TStrings;
         DataLink:TFieldDataLink;
      Protected
         Function GetCount:LongInt; Override;
         Function Get(Index:LongInt):String; Override;
         Function GetObject(Index:LongInt):TObject; Override;
         Procedure Put(Index:LongInt;Const S:String); Override;
         Procedure PutObject(Index:LongInt;AObject:TObject); Override;
      Public
         Procedure Assign(AStrings:TStrings); Override;
         Function Add(Const S:String):LongInt; Override;
         Procedure Insert(Index:LongInt;Const S:String); Override;
         Procedure Delete(Index:LongInt); Override;
         Procedure Clear; Override;
         {$IFDEF OS2}
         Function IndexOf(Const S:String):LongInt; Override;
         {$ENDIF}
    End;

Function TDBListBoxStrings.GetCount:LongInt;
Begin
     Result:=Items.Count;
End;

Function TDBListBoxStrings.Get(Index:LongInt):String;
Begin
     Result:=Items.Strings[Index];
End;

Function TDBListBoxStrings.GetObject(Index:LongInt):TObject;
Begin
     Result:=Items.Objects[Index];
End;

Procedure TDBListBoxStrings.Put(Index:LongInt;Const S:String);
Var Field:TField;
Begin
     If ((DataLink.DataSource=Nil)Or(DataLink.DataSource.DataSet=Nil)) Then Exit;

     //Change DSN
     Try
        Field:=DataLink.Field;
        If Field<>Nil Then If Field.AsString<>S Then
        Begin
             Field.AsString:=S;
             If Not DataLink.DataSource.DataSet.RowInserted
             Then DataLink.DataSource.DataSet.Post
             Else DataLink.DataSource.DataSet.Refresh;
        End;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;

     If Field<>Nil Then Items.Strings[Index]:=S;
End;

Procedure TDBListBoxStrings.PutObject(Index:LongInt;AObject:TObject);
Begin
     Items.Objects[Index]:=AObject;
End;

Procedure TDBListBoxStrings.Assign(AStrings:TStrings);
Var T:LongInt;
Begin
     If AStrings=Nil Then Exit;
     For T:=0 To Count-1 Do
     Begin
          If T>AStrings.Count-1 Then Exit;
          Strings[T]:=AStrings.Strings[T];
     End;
End;

Function TDBListBoxStrings.Add(Const S:String):LongInt;
Begin
     Result := Items.Add(S);
     //Change DSN
End;

Procedure TDBListBoxStrings.Insert(Index:LongInt;Const S:String);
Begin
     Items.Insert(Index,S);
     //Change DSN
End;

Procedure TDBListBoxStrings.Delete(Index:LongInt);
Begin
     Items.Delete(Index);
     //Change DSN
End;

Procedure TDBListBoxStrings.Clear;
Begin
     Items.Clear;
     //Change DSN
End;

{$IFDEF OS2}
Function TDBListBoxStrings.IndexOf(Const S:String):LongInt;
Begin
     Result:=Items.IndexOf(S);
End;
{$ENDIF}

Procedure TDBListBox.SetupComponent;
Begin
     Inherited SetupComponent;

     FDBStrings:=TDBListBoxStrings.Create;
     TDBListBoxStrings(FDBStrings).Items:=Inherited Items;
     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
End;

Destructor TDBListBox.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;
     FDBStrings.Destroy;
     FDBStrings:=Nil;

     Inherited Destroy;
End;

{$HINTS OFF}
Procedure TDBListBox.DataChange(Sender:TObject;event:TDataChange);
Var Field:TField;
    OldRow:LongInt;
    Eof:Boolean;
Begin
     If ((event=deDSNChanged)Or(Items.Count=0)) Then
     Begin
          BeginUpdate;
          Items.Clear;
          If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)Or
              (Not FDataLink.DataSource.DataSet.Active)) Then
          Begin
               EndUpdate;
               Exit;
          End;

          FDataLink.DataSource.DataSet.DataChangeLock:=True;
          OldRow:=FDataLink.DataSource.DataSet.CurrentRow;

          Try
             FDataLink.DataSource.DataSet.First;

             Repeat
                  Try
                     Field:=FDataLink.Field;
                  Except
                     ON E:ESQLError Do
                     Begin
                          ErrorBox(E.Message);
                          Field:=Nil;
                     End;
                     Else Raise;
                  End;

                  If Field<>Nil Then TDBListBoxStrings(FDBStrings).Items.Add(Field.AsString);

                  Eof:=FDataLink.DataSource.DataSet.Eof;
                  FDataLink.DataSource.DataSet.Next;
             Until Eof;
          Except
          End;

          FDataLink.DataSource.DataSet.CurrentRow:=OldRow;
          FDataLink.DataSource.DataSet.DataChangeLock:=False;
          EndUpdate;
          ItemIndex:=OldRow;
     End
     Else If event=dePositionChanged Then
     Begin
          If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;
          ItemIndex:=FDataLink.DataSource.DataSet.CurrentRow;
     End;
End;
{$HINTS ON}

Procedure TDBListBox.SetupShow;
Begin
     Inherited SetupShow;
     TDBListBoxStrings(FDBStrings).Items:=Inherited Items;
     DataChange(FDataLink,deDSNChanged);
End;

Procedure TDBListBox.SetItems(NewValue:TStrings);
Begin
     TDBListBoxStrings(FDBStrings).Assign(NewValue);
End;

Procedure TDBListBox.ItemFocus(Index:LongInt);
Begin
     Inherited ItemFocus(Index);
     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;
     FDataLink.DataSource.DataSet.CurrentRow:=ItemIndex;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBComboBox Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;
     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBComboBox.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure TDBComboBox.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBComboBox.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBComboBox.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBComboBox.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Procedure TDBComboBox.SetupComponent;
Begin
     Inherited SetupComponent;

     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
End;

Destructor TDBComboBox.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;

     Inherited Destroy;
End;

{$HINTS OFF}
Procedure TDBComboBox.DataChange(Sender:TObject;event:TDataChange);
Var Field:TField;
    S:String;
Begin
     Try
        Field:=FDataLink.Field;
        If Field<>Nil Then
        Begin
            S:=Field.AsString;
            If S<>Text Then Text:=S;
        End;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
End;
{$HINTS ON}

Procedure TDBComboBox.SetupShow;
Begin
     Inherited SetupShow;
     DataChange(FDataLink,deDSNChanged);
End;

Procedure TDBComboBox.WriteBack;
Var Field:TField;
Begin
     If FDataLink = Nil Then exit;
     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;

     Try
        Field:=FDataLink.Field;
        If Field<>Nil Then
          If Field.AsString<>Text Then
          Begin
               Field.AsString:=Text;
               If Not FDataLink.DataSource.DataSet.RowInserted
               Then FDataLink.DataSource.DataSet.Post
               Else FDataLink.DataSource.DataSet.Refresh;
          End;
     Except
        FLock:=False;
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
End;


Procedure TDBComboBox.EditChange;
Begin
     If FLock Then Exit;
     FLock:=True;
     WriteBack;
     FLock:=False;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBRadioGroup Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDBRadioGroup.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If Result=False Then Exit;
     S:=FDataLink.FieldName;
     Result:=Stream.NewResourceEntry(rnDBDataField,S,Length(S)+1);
End;

Procedure TDBRadioGroup.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
     If ResName = rnDBDataField Then
     Begin
          System.Move(Data,S,DataLen);
          FDataLink.FieldName:=S;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure TDBRadioGroup.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBRadioGroup.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Procedure TDBRadioGroup.SetDataField(NewValue:String);
Begin
     FDataLink.FieldName:=NewValue;
End;

Function TDBRadioGroup.GetDataField:String;
Begin
     Result:=FDataLink.FieldName;
End;

Procedure TDBRadioGroup.SetupComponent;
Begin
     Inherited SetupComponent;

     FValues:=TStringList.Create;
     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
End;

Destructor TDBRadioGroup.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;
     FValues.Destroy;
     FValues:=Nil;

     Inherited Destroy;
End;

{$HINTS OFF}
Procedure TDBRadioGroup.DataChange(Sender:TObject;event:TDataChange);
Var Field:TField;
    S:String;
    T:LongInt;
Begin
     Try
        Field:=FDataLink.Field;
        If Field<>Nil Then
          If Value<>Field.AsString Then Value:=Field.AsString;
     Except
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
End;
{$HINTS ON}

Procedure TDBRadioGroup.SetupShow;
Begin
     Inherited SetupShow;
     DataChange(FDataLink,deDSNChanged);
End;

Procedure TDBRadioGroup.WriteBack;
Var S:String;
    Field:TField;
Begin
     If FDataLink = Nil Then exit;
     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)) Then Exit;
     If ((FLock)Or(ItemIndex<0)) Then Exit;

     FLock:=True;
     If ItemIndex<FValues.Count Then S:=FValues[ItemIndex]
     Else If ItemIndex<Items.Count Then S:=Items[ItemIndex]
     Else Exit;

     Try
        Field:=FDataLink.Field;
        If Field<>Nil Then
          If Field.AsString<>S Then
          Begin
               Field.AsString:=S;
               If Not FDataLink.DataSource.DataSet.RowInserted
               Then FDataLink.DataSource.DataSet.Post
               Else FDataLink.DataSource.DataSet.Refresh;
          End;
     Except
        FLock:=False;
        ON E:ESQLError Do
        Begin
             ErrorBox(E.Message);
             Field:=Nil;
        End;
        Else Raise;
     End;
     FLock:=False;
End;


Procedure TDBRadioGroup.ItemIndexChange;
Begin
     WriteBack;
End;


Function TDBRadioGroup.GetValue:String;
Begin
    If ItemIndex<0 Then Result:=''
    Else
    Begin
        If ItemIndex<FValues.Count Then Result:=FValues[ItemIndex]
        Else If ItemIndex<Items.Count Then Result:=Items[ItemIndex]
        Else Result:='';
    End;
End;

Procedure TDBRadioGroup.SetValue(Const NewValue:String);
Var T:LongInt;
Begin
     For T:=0 To FValues.Count-1 Do
     Begin
          If FValues[T]=NewValue Then
          Begin
               If ItemIndex<>T Then ItemIndex:=T;
               Exit;
          End;
     End;

     For T:=0 To Items.Count-1 Do
     Begin
          If Items[T]=NewValue Then
          Begin
               If ItemIndex<>T Then ItemIndex:=T;
               Exit;
          End;
     End;

     ItemIndex:=-1;
End;

Procedure TDBRadioGroup.SetValues(NewValue:TStrings);
Begin
     FValues.Assign(NewValue);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDBNavigator Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
    cmDBFirst           = TCommand(cmBase+70);
    cmDBPrior           = TCommand(cmBase+71);
    cmDBNext            = TCommand(cmBase+72);
    cmDBLast            = TCommand(cmBase+73);
    cmDBInsert          = TCommand(cmBase+74);
    cmDBDelete          = TCommand(cmBase+75);
    cmDBEdit            = TCommand(cmBase+76);
    cmDBPost            = TCommand(cmBase+77);
    cmDBCancel          = TCommand(cmBase+78);
    cmDBRefresh         = TCommand(cmBase+79);


Procedure TDBNavigator.SetVisibleButtons(NewState:TNavigateBtnSet);
Var T:TNavigateBtn;
Begin
     FVisibleButtons:=NewState;
     For T:=dbFirst To dbRefresh Do FButtons[T].Visible:=NewState*[T]<>[];
     RealignControls;
End;

Procedure TDBNavigator.SetEnabledButtons(NewState:TNavigateBtnSet);
Var T:TNavigateBtn;
Begin
     FEnabledButtons:=NewState;
     For T:=dbFirst To dbRefresh Do FButtons[T].Enabled:=NewState*[T]<>[];
     If Handle<>0 Then Invalidate;
End;

Procedure TDBNavigator.RealignControls;
Var X:LongInt;
    Count,W:LongInt;
    T:TNavigateBtn;
Begin
     If Handle=0 Then Exit;

     X:=0;

     Count:=0;
     For T:=dbFirst To dbRefresh Do If FVisibleButtons*[T]<>[] Then Inc(Count);

     W:=Width Div Count;
     For T:=dbFirst To dbRefresh Do
     Begin
          If FVisibleButtons*[T]<>[] Then
          Begin
               FButtons[T].SetWindowPos(X,0,W,Height);
               Inc(X,FButtons[T].Width);
          End
          Else
          If Designed Then FButtons[T].SetWindowPos(X,Height,W,Height);
     End;
End;


Function TDBNavigator.GetButton(Index:TNavigateBtn):TBitBtn;
Begin
     Result := FButtons[Index];
End;


Procedure TDBNavigator.SetupComponent;
Type
     TButDataRec=Record
        bmp:String[20];
        cmd:TCommand;
        Bubble:LongWord;
     End;
Const
     ButData:Array[TNavigateBtn] Of TButDataRec=
        ((bmp:'StdBmpDBFirst';cmd:cmDBFirst;Bubble:SFirstRecordHint),
         (bmp:'StdBmpDBPrior';cmd:cmDBPrior;Bubble:SPriorRecordHint),
         (bmp:'StdBmpDBNext';cmd:cmDBNext;Bubble:SNextRecordHint),
         (bmp:'StdBmpDBLast';cmd:cmDBLast;Bubble:SLastRecordHint),
         (bmp:'StdBmpDBInsert';cmd:cmDBInsert;Bubble:SInsertRecordHint),
         (bmp:'StdBmpDBDelete';cmd:cmDBDelete;Bubble:SDeleteRecordHint),
         (bmp:'StdBmpDBEdit';cmd:cmDBEdit;Bubble:SEditRecordHint),
         (bmp:'StdBmpDBPost';cmd:cmDBPost;Bubble:SPostRecordHint),
         (bmp:'StdBmpDBCancel';cmd:cmDBCancel;Bubble:SCancelRecordHint),
         (bmp:'StdBmpDBRefresh';cmd:cmDBRefresh;Bubble:SRefreshRecordHint));
Var  T:TNavigateBtn;
Begin
     Inherited SetupComponent;

     FDataLink.Create(Self);
     FDataLink.OnDataChange:=Nil{DataChange};
     Include(FDataLink.ComponentState, csDetail);

     FVisibleButtons:=[dbFirst..dbRefresh];
     FEnabledButtons:=[dbFirst..dbRefresh];
     Width:=240;
     Height:=25;
     ParentColor:=True;

     For T:=dbFirst To dbRefresh Do
     Begin
          FButtons[T]:=InsertBitBtn(Self,32,0,32,32, bkCustom,'',
                                    LoadNLSStr(ButData[T].Bubble));
          FButtons[T].Command:=ButData[T].cmd;
          FButtons[T].Glyph.LoadFromResourceName(ButData[T].bmp);
          FButtons[T].YAlign:=yaBottom;
          FButtons[T].YStretch:=ysParent;
          Include(FButtons[T].ComponentState, csDetail);
          FButtons[T].SetDesigning(Designed);

          If Not Designed Then
          Begin
               FButtons[T].Tag := LongInt(T);
               FButtons[T].OnClick := EvButtonClick;
          End;
     End;

     VisibleButtons:=VisibleButtons-[dbEdit];
End;

Destructor TDBNavigator.Destroy;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;

     Inherited Destroy;
End;

Procedure TDBNavigator.CreateWnd;
Begin
     Inherited CreateWnd;

     RealignControls;
End;


Procedure TDBNavigator.SetDataSource(NewValue:TDataSource);
Begin
     FDataLink.DataSource:=NewValue;
End;

Function TDBNavigator.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;


Procedure TDBNavigator.CommandEvent(Var Command:TCommand);
Begin
     Inherited CommandEvent(Command);

     If ((FDataLink<>Nil)And(FDataLink.DataSource<>Nil)And
         (FDataLink.DataSource.DataSet<>Nil)) Then
     Begin
          Try
             Case Command Of
               cmDBFirst:FDataLink.DataSource.DataSet.First;
               cmDBPrior:FDataLink.DataSource.DataSet.Prior;
               cmDBNext:FDataLink.DataSource.DataSet.Next;
               cmDBLast:FDataLink.DataSource.DataSet.Last;
               cmDBInsert:FDataLink.DataSource.DataSet.Insert;
               cmDBDelete:FDataLink.DataSource.DataSet.Delete;
               cmDBEdit: ;
               cmDBPost:FDataLink.DataSource.DataSet.Post;
               cmDBCancel:FDataLink.DataSource.DataSet.Cancel;
               cmDBRefresh:FDataLink.DataSource.DataSet.Refresh;
             End;
          Except
              ON E:ESQLError Do ErrorBox(E.Message);
              ON EDSNError Do
              Begin
              End;
              Else Raise;
          End;
     End;
End;


Procedure TDBNavigator.EvButtonClick(Sender:TObject);
Begin
     If FOnNavClick <> Nil
     Then FOnNavClick(Self,TNavigateBtn(TComponent(Sender).Tag));
End;


Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  25-Sep-04  WD         In das Projekt wieder aufgenommen
}

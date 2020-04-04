
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit DBBase;                 

Interface

Uses Dos,SysUtils,Classes,Forms,Dialogs,
     uStream, uList, uString,
     DBLayer;

Type
    TField=Class;
    TDataSet=Class;
    TDataSource=Class;

    ESQLError=Class(Exception);

    TDataChange=(dePositionChanged,deDSNChanged,deTableNameChanged);

    TDataChangeEvent=Procedure(Sender:TObject;event:TDataChange) Of Object;


    TDataLink=Class(TComponent)
      Private
         FDataSource:TDataSource;
         FOnDataChange:TDataChangeEvent;
         Procedure SetDataSource(NewValue:TDataSource);
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure DataChange(event:TDataChange);
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Property DataSource:TDataSource Read FDataSource Write SetDataSource;
         Property OnDataChange:TDataChangeEvent Read FOnDataChange Write FOnDataChange;
    End;


    TTableDataLink=Class(TDataLink)
      Private
         Function GetColRowField(Col,Row:LongInt):TField;
         Function GetNameRowField(Name:String;Row:LongInt):TField;
         Function GetFieldCount:LongInt;
         Function GetFieldName(Index:LongInt):String;
      Public
         Property Fields[Col,Row:LongInt]:TField Read GetColRowField;
         Property FieldsFromColumnName[Col:String;Row:LongInt]:TField Read GetNameRowField;
         Property FieldCount:LongInt Read GetFieldCount;
         Property FieldNames[Index:LongInt]:String read GetFieldName;
    End;


    TFieldDataLink=Class(TDataLink)
      Private
         FFieldName:PString;
         Procedure SetFieldName(Const NewValue:String);
         Function GetFieldName:String;
         Function GetField:TField;
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Property FieldName:String Read GetFieldName Write SetFieldName;
         Property field:TField Read GetField;
    End;

    TFieldType=(ftUnknown,ftString,ftSmallInt,ftInteger,ftWord,ftBoolean,
                ftFloat,ftCurrency,ftBCD,ftDate,ftTime,ftDateTime,ftBytes,
                ftVarBytes,ftAutoInc,ftBlob,ftMemo,ftGraphic,ftFmtMemo,
                ftTypedBinary,ftOLE);

    EDSNError=Class(Exception);

    TFieldDefs=Class;
    TFieldDef=Class;

    TOnFieldChange=Procedure(Sender:TField) Of Object;

    TField=Class
      Private
         FSize:Longword;      //store size of datatype (floatfield!)
         FValue:Pointer;
         FValueLen:LongWord;
         FDataType:TFieldType;
         FDataSet:TDataSet;
         FFieldDef:TFieldDef;
         FRequired:Boolean;
         FRow:LongInt;
         FCol:LongInt;
         FReadOnly:Boolean;
         FOnChange:TOnFieldChange;
         Procedure FreeMemory;
         Procedure GetMemory(Size:Longint);
         Function GetFieldName:String;
         Function GetIsNull:Boolean;
         Procedure SetNewValue(Var NewValue;NewLen:LongInt);
         Function GetAsVariant:Variant;Virtual;
         Procedure SetAsVariant(NewValue:Variant);Virtual;
         Function GetIsIndexField:Boolean;
         Function GetCanModify:Boolean;
         Function GetReadOnly:Boolean;
      Protected
         Procedure SetAsValue(Var Value;Len:LongInt);Virtual;
         Function GetAsString:String;Virtual;
         Procedure SetAsString(Const NewValue:String);Virtual;
         Function GetAsAnsiString:AnsiString;Virtual;
         Procedure SetAsAnsiString(NewValue:AnsiString);Virtual;
         Function GetAsBoolean:Boolean;Virtual;
         Procedure SetAsBoolean(NewValue:Boolean);Virtual;
         Function GetAsDateTime:TDateTime;Virtual;
         Procedure SetAsDateTime(NewValue:TDateTime);Virtual;
         Function GetAsFloat:Extended;Virtual;
         Procedure SetAsFloat(Const NewValue:Extended);Virtual;
         Function GetAsInteger:LongInt;Virtual;
         Procedure SetAsInteger(NewValue:LongInt);Virtual;
         Procedure AccessError(Const TypeName:String);Virtual;
         Procedure CheckInactive;
      Public
         Destructor Destroy;Override;
         Procedure Clear;Virtual;
         Procedure Assign(Field:TField);
         Procedure SetData(Buffer:Pointer);
         Property IsNull:Boolean Read GetIsNull;
         Property ValueLen:LongWord Read FValueLen;
         Property DataType:TFieldType Read FDataType;
         Property Required:Boolean Read FRequired Write FRequired;
         Property Row:LongInt read FRow write FRow;
         Property Value:Variant read GetAsVariant write SetAsVariant;
         Property IsIndexField:Boolean read GetIsIndexField;
         Property CanModify:Boolean read GetCanModify;
         Property DataSet:TDataSet read FDataSet;
         Property DataSize:LongWord read FValueLen;
         Property ReadOnly:boolean read GetReadOnly write FReadOnly;
         Property Index:LongInt read FCol;
      Published
         Property FieldName:String Read GetFieldName;
         Property AsString:String Read GetAsString Write SetAsString;
         Property AsAnsiString:AnsiString Read GetAsAnsiString Write SetAsAnsiString;
         Property AsBoolean:Boolean Read GetAsBoolean Write SetAsBoolean;
         Property AsDateTime:TDateTime Read GetAsDateTime Write SetAsDateTime;
         Property AsFloat:Extended Read GetAsFloat Write SetAsFloat;
         Property AsInteger:LongInt Read GetAsInteger Write SetAsInteger;
         Property OnChange:TOnFieldChange read FOnChange write FOnChange;
    End;
    TFieldClass=Class Of TField;


    TStringField=Class(TField)
      Protected
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsBoolean:Boolean;Override;
         Procedure SetAsBoolean(NewValue:Boolean);Override;
         Function GetAsDateTime:TDateTime;Override;
         Function GetAsFloat:Extended;Override;
         Procedure SetAsFloat(Const NewValue:Extended);Override;
         Function GetAsInteger:LongInt;Override;
         Procedure SetAsInteger(NewValue:LongInt);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
      Public
         Property Value:String Read GetAsString write SetAsString;
    End;


    TSmallintField=Class(TField)
      Protected
         Function GetAsBoolean:Boolean;Override;
         Procedure SetAsBoolean(NewValue:Boolean);Override;
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsSmallint:Integer;Virtual;
         Procedure SetAsSmallInt(NewValue:Integer);Virtual;
         Function GetAsFloat:Extended;Override;
         Procedure SetAsFloat(Const NewValue:Extended);Override;
         Function GetAsInteger:LongInt;Override;
         Procedure SetAsInteger(NewValue:LongInt);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
      Public
         Property Value:Integer Read GetAsSmallint Write SetAsSmallInt;
    End;


    TIntegerField=Class(TField)
      Protected
         Function GetAsBoolean:Boolean;Override;
         Procedure SetAsBoolean(NewValue:Boolean);Override;
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsFloat:Extended;Override;
         Procedure SetAsFloat(Const NewValue:Extended);Override;
         Function GetAsInteger:LongInt;Override;
         Procedure SetAsInteger(NewValue:LongInt);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
      Public
         Property Value:LongInt Read GetAsInteger Write SetAsInteger;
    End;


    TAutoIncField=Class(TIntegerField)
    End;


    TBooleanField=Class(TField)
      Protected
         Function GetAsBoolean:Boolean;Override;
         Procedure SetAsBoolean(NewValue:Boolean);Override;
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsFloat:Extended;Override;
         Procedure SetAsFloat(Const NewValue:Extended);Override;
         Function GetAsInteger:LongInt;Override;
         Procedure SetAsInteger(NewValue:LongInt);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
      Public
         Property Value:Boolean Read GetAsBoolean Write SetAsBoolean;
    End;


    TFloatField=Class(TField)
      Private
         FPrecision:Longint;
         Procedure SetPrecision(Value:Longint);
      Protected
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsFloat:Extended;Override;
         Procedure SetAsFloat(Const NewValue:Extended);Override;
         Function GetAsInteger:LongInt;Override;
         Procedure SetAsInteger(NewValue:LongInt);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
      Public
         Constructor Create;
         Property Value:Extended Read GetAsFloat Write SetAsFloat;
         Property Precision:Longint Read FPrecision Write SetPrecision;
    End;


    TCurrencyField=Class(TFloatField)
      Public
         Constructor Create;
    End;


    TDateField=Class(TField)
      Private
         FDisplayFormat:PString;
      Private
         Function GetDisplayFormat:String;
         Procedure SetDisplayFormat(Const NewValue:String);
      Protected
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsFloat:Extended;Override;
         Function GetAsDateTime:TDateTime;Override;
         Procedure SetAsDateTime(NewValue:TDateTime);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
         Destructor Destroy;Override;
      Public
         Property Value:TDateTime Read GetAsDateTime Write SetAsDateTime;
         Property DisplayFormat:String read GetDisplayFormat write SetDisplayFormat;
    End;


    TTimeField=Class(TField)
      Private
         FDisplayFormat:PString;
      Private
         Function GetDisplayFormat:String;
         Procedure SetDisplayFormat(Const NewValue:String);
      Protected
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsFloat:Extended;Override;
         Function GetAsDateTime:TDateTime;Override;
         Procedure SetAsDateTime(NewValue:TDateTime);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
         Destructor Destroy;Override;
      Public
         Property Value:TDateTime Read GetAsDateTime Write SetAsDateTime;
         Property DisplayFormat:String read GetDisplayFormat write SetDisplayFormat;
    End;


    TDateTimeField=Class(TField)
      Private
         FDisplayFormat:PString;
      Private
         Function GetDisplayFormat:String;
         Procedure SetDisplayFormat(Const NewValue:String);
      Protected
         Function GetAsString:String;Override;
         Procedure SetAsString(Const NewValue:String);Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
         Function GetAsFloat:Extended;Override;
         Function GetAsDateTime:TDateTime;Override;
         Procedure SetAsDateTime(NewValue:TDateTime);Override;
         Function GetAsVariant:Variant;Override;
         Procedure SetAsVariant(NewValue:Variant);Override;
         Destructor Destroy;Override;
      Public
         Property Value:TDateTime Read GetAsDateTime Write SetAsDateTime;
         Property DisplayFormat:String read GetDisplayFormat write SetDisplayFormat;
    End;


    TBlobField=Class(TField)
      Protected
         Function GetAsString:String;Override;
         Function GetAsAnsiString:AnsiString;Override;
      Public
         Procedure LoadFromStream(Stream:TStream);
         Procedure LoadFromFile(Const FileName:String);
         Procedure SaveToStream(Stream:TStream);
         Procedure SaveToFile(Const FileName:String);
         Property Value:Pointer Read FValue;
    End;


    TMemoField=Class(TField)
      Protected
         Function GetAsString:String;Override;
         Function GetAsAnsiString:AnsiString;Override;
         Procedure SetAsAnsiString(NewValue:AnsiString);Override;
      Public
         Property Value:AnsiString Read GetAsAnsiString write SetAsAnsiString;
    End;


    TGraphicField=Class(TBlobField)
      Protected
         Function GetAsString:String;Override;
    End;


    TFieldList=Class(TList)  //List Of Fields (TField entries)
      Public
         Procedure Clear;Override;
    End;


    TFieldDef=Class
      Private
         FFields:TList;
         FOwner:TFieldDefs;
         FName:String;
         FRequired:Boolean;
         FSize:Longword;
         FPrecision:LongInt;
         FDataType:TFieldType;
         FFieldNo:Longint;
         FPrimaryKey:Boolean;
         FForeignKey:PString;
         FTypeName:PString;
         Function GetFieldClass:TFieldClass;
         Function GetPrimaryKey:Boolean;
         Procedure SetPrimaryKey(NewValue:Boolean);
         Function GetForeignKey:String;
         Procedure SetForeignKey(Const NewValue:String);
         Function GetTypeName:String;
         Procedure SetTypeName(Const NewValue:String);
      Public
         Constructor Create(aOwner:TFieldDefs; Const aName:String;
                            aDataType:TFieldType; aSize:Longword; aRequired:Boolean;
                            aFieldNo:Longint);
         Destructor Destroy;Override;
         Function CreateField(Owner:TComponent):TField;
       Public
         Property Fields:TList Read FFields;
         Property DataType:TFieldType Read FDataType;
         Property FieldClass:TFieldClass Read GetFieldClass;
         Property FieldNo:Longint Read FFieldNo;
         Property Name:String Read FName;
         Property TypeName:String Read GetTypeName write SetTypeName;
         Property Precision:Longint Read FPrecision Write FPrecision;
         Property Required:Boolean Read FRequired;
         Property Size:Longword Read FSize Write FSize;
         Property PrimaryKey:Boolean read GetPrimaryKey write FPrimaryKey;
         Property ForeignKey:String read GetForeignKey write SetForeignKey;
    End;


    TFieldDefs=Class
      Private
         FDataSet:TDataSet;
         FItems:TList;
         Function Rows:Longint;
         Function GetCount:Longint;
         Function GetItem(Index:Longint):TFieldDef;
      Public
         Constructor Create(DataSet:TDataSet);
         Destructor Destroy;Override;
         Procedure Clear;
         Function Add(Const Name:String; DataType:TFieldType; Size:Longint; Required:Boolean):TFieldDef;
         Procedure Update;
         Procedure Assign(FieldDefs: TFieldDefs);
         Function Find(Const Name: string): TFieldDef;
         Function IndexOf(Const Name: string): LongInt;
      Public
         Property Count:Longint Read GetCount;
         Property Items[Index:Longint]:TFieldDef Read GetItem; default
    End;

    TDataSetNotifyEvent=Procedure(DataSet:TDataSet) Of Object;

    {$M+}
    TLocateOptions=Set Of (loCaseInsensitive,loPartialKey);
    {$M-}

    {$M+}
    TIndexOptions = Set of (ixPrimary, ixUnique, ixDescending,
                            ixCaseInsensitive, ixExpression);
    {$M-}

    TDataSet=Class(TComponent)
      Private
         fODBC : tcODBC;
         FCurrentRow:LongInt;
         FCurrentField:LongInt;
         FRowIsInserted:Boolean;
         FFieldDefs:TFieldDefs;
         FActive:Boolean;
         FOpened:Boolean;
         FDSN:PString;
         FDataSetLocked:Boolean;
         FRefreshOnLoad:Boolean;
         FSelect:TStrings;
         FDataChangeLock:Boolean;
         FMaxRows:LongInt;
         FBeforeOpen:TDataSetNotifyEvent;
         FAfterOpen:TDataSetNotifyEvent;
         FBeforeClose:TDataSetNotifyEvent;
         FAfterClose:TDataSetNotifyEvent;
         FBeforeInsert:TDataSetNotifyEvent;
         FAfterInsert:TDataSetNotifyEvent;
         FBeforePost:TDataSetNotifyEvent;
         FAfterPost:TDataSetNotifyEvent;
         FBeforeCancel:TDataSetNotifyEvent;
         FAfterCancel:TDataSetNotifyEvent;
         FBeforeDelete:TDataSetNotifyEvent;
         FAfterDelete:TDataSetNotifyEvent;
         FReadOnly:Boolean;
      Private
         Function GetBOF:Boolean;
         Function GetEOF:Boolean;
         Function GetField(Index:LongInt):TField;
         Function GetFieldCount:LongInt;
         Function GetFieldName(Index:LongInt):String;
         Function GetFieldType(Index:LongInt):TFieldType;
         Procedure SetCurrentField(NewValue:LongInt);
         Procedure SetCurrentRow(NewValue:LongInt);
         Procedure UpdateField(field:TField;OldValue:Pointer;OldValueLen:LongInt);
         Function GetFieldFromColumnName(ColumnName:String):TField;
         Procedure CheckRequiredFields;
         Procedure SetFieldDefs(NewValue:TFieldDefs);
         Procedure DesignerNotification(Var DNS:TDesignerNotifyStruct);
         Function IsTable:Boolean;
      Protected
         Procedure SetupComponent;Override;
         Procedure Loaded;Override;
         Procedure DataChange(event:TDataChange);Virtual;
         Procedure CheckInactive;Virtual;
         Procedure SetActive(NewValue:Boolean);Virtual;
         Procedure SetDSNName(Const NewValue:String);Virtual;
         Function GetDSNName:String;Virtual;
         Function GetMaxRows:LongInt;Virtual;
         Function GetResultColRow(Col,Row:LongInt):TField;Virtual;
         Procedure CommitInsert(Commit:Boolean);Virtual;
         Function UpdateFieldSelect(Field:TField):Boolean;Virtual;
         Function GetFieldClass(FieldType:TFieldType):TFieldClass;Virtual;
         Procedure InsertCurrentFields;
         Procedure RemoveCurrentFields;
         Procedure QueryTable;Virtual;
         Procedure DoOpen;Virtual;
         Procedure DoClose;Virtual;
         Procedure DoPost;Virtual;
         Procedure DoCancel;Virtual;
         Procedure DoInsert;Virtual;
         Procedure DoDelete;Virtual;
         Property DataSetLocked:Boolean read FDataSetLocked write FDataSetLocked;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Procedure Open;
         Procedure Close;
         Procedure First;
         Procedure Last;
         Procedure Next;
         Procedure Prior;
         Procedure MoveBy(Distance:LongInt);
         Procedure Refresh;
         Procedure Post;Virtual;
         Procedure Cancel;Virtual;
         Procedure Insert;Virtual;
         Procedure Append;Virtual;
         Procedure Delete;Virtual;
         Procedure GetFieldNames(List:TStrings);
         Procedure GetDataSources(List:TStrings);Virtual;
         Procedure GetStoredProcNames(List:TStrings);Virtual;
         Procedure RefreshTable;Virtual;
         Procedure AppendRecord(Const values:Array Of Const);
         Procedure SetFields(Const values:Array Of Const);
         Procedure InsertRecord(Const Values:Array Of Const);Virtual;
         Function FieldByName(Const FieldName:String):TField;
         Function FindField(Const FieldName:String):TField;
         Function FindFirst: Boolean;
         Function FindLast: Boolean;
         Function FindNext: Boolean;
         Function FindPrior: Boolean;
         Procedure GetFieldList(List:TList;Const FieldNames:String);
         Function Locate(Const KeyFields:String;Const KeyValues:Array Of Const;
                         Options:TLocateOptions):Boolean;Virtual;
      Public
         Property Bof:Boolean Read GetBOF;
         Property Eof:Boolean Read GetEOF;
         Property FieldCount:LongInt Read GetFieldCount;
         Property Fields[Index:LongInt]:TField Read GetField;
         Property FieldDefs:TFieldDefs read FFieldDefs write SetFieldDefs;
         Property FieldNames[Index:LongInt]:String Read GetFieldName;
         Property FieldTypes[Index:LongInt]:TFieldType Read GetFieldType;
         Property CurrentField:LongInt Read FCurrentField Write SetCurrentField;
         Property CurrentRow:LongInt Read FCurrentRow Write SetCurrentRow;
         Property RowInserted:Boolean Read FRowIsInserted write FRowIsInserted;
         Property FieldFromColumnName[ColumnName:String]:TField Read GetFieldFromColumnName;
         Property DataChangeLock:Boolean Read FDataChangeLock Write FDataChangeLock;
         Property MaxRows:LongInt read GetMaxRows;
         Property RecordCount:Longint read GetMaxRows;
         Property RecNo:Longint read FCurrentRow;
         Property DSNName:String Read GetDSNName Write SetDSNName;
      Published
         Property Active:Boolean Read FActive Write SetActive;
         Property DSN:String Read GetDSNName Write SetDSNName;
         Property ReadOnly:Boolean read FReadOnly write FReadOnly;
         Property BeforeOpen:TDataSetNotifyEvent Read FBeforeOpen Write FBeforeOpen;
         Property AfterOpen:TDataSetNotifyEvent Read FAfterOpen Write FAfterOpen;
         Property BeforeClose:TDataSetNotifyEvent Read FBeforeClose Write FBeforeClose;
         Property AfterClose:TDataSetNotifyEvent Read FAfterClose Write FAfterClose;
         Property BeforeInsert:TDataSetNotifyEvent Read FBeforeInsert Write FBeforeInsert;
         Property AfterInsert:TDataSetNotifyEvent Read FAfterInsert Write FAfterInsert;
         Property BeforePost:TDataSetNotifyEvent Read FBeforePost Write FBeforePost;
         Property AfterPost:TDataSetNotifyEvent Read FAfterPost Write FAfterPost;
         Property BeforeCancel:TDataSetNotifyEvent Read FBeforeCancel Write FBeforeCancel;
         Property AfterCancel:TDataSetNotifyEvent Read FAfterCancel Write FAfterCancel;
         Property BeforeDelete:TDataSetNotifyEvent Read FBeforeDelete Write FBeforeDelete;
         Property AfterDelete:TDataSetNotifyEvent Read FAfterDelete Write FAfterDelete;
    End;

    TDataSource=Class(TComponent)
      Private
         FDataSet:TDataSet;
         FOnDataChange:TDataChangeEvent;
         Procedure SetDataSet(NewValue:TDataSet);
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
      Protected
         Procedure SetupComponent;Override;
         Procedure DataChange(event:TDataChange);Virtual;
      Public
         Destructor Destroy;Override;
      Published
         Property DataSet:TDataSet Read FDataSet Write SetDataSet;
         Property OnDataChange:TDataChangeEvent Read FOnDataChange Write FOnDataChange;
    End;

    TLockType=(ltReadLock,ltWriteLock);

    TIndexDefs=Class;

    TIndexDef=Class
      Private
         FOwner: TIndexDefs;
         FName:PString;
         FFields:PString;
         FOptions:TIndexOptions;
         Function GetFields:String;
         Function GetName:String;
      Public
         Constructor Create(Owner:TIndexDefs;Const Name, Fields:String;
                            Options:TIndexOptions);
         Destructor Destroy; override;
      Public
         Property Fields:String read GetFields;
         Property Name:String read GetName;
         Property Options: TIndexOptions read FOptions;
    End;

    TIndexDefs=Class
       Private
         FDataSet:TDataSet;
         FItems:TList;
         FUpdated: Boolean;
         Function GetCount:LongInt;
         Function GetItem(Index:LongInt): TIndexDef;
       Public
         Constructor Create(DataSet:TDataSet);
         Destructor Destroy;Override;
         Function Add(Const Name,Fields:String;Options:TIndexOptions):TIndexDef;
         Procedure Assign(IndexDefs:TIndexDefs);
         Procedure Clear;
         Function FindIndexForFields(Const Fields:String):TIndexDef;
         Function GetIndexForFields(Const Fields:String;CaseInsensitive:Boolean):TIndexDef;
         Function IndexOf(Const Name:String):LongInt;
         Procedure Update;
       Public
         Property Count:LongInt read GetCount;
         Property Items[Index:LongInt]:TIndexDef read GetItem;default;
         Property Updated:Boolean read FUpdated write FUpdated;
    End;

    TTable=Class(TDataSet)
      Private
         FTableName       : String;
         fOrderBy         : String;
         FMasterSource    : TDataSource;
         FTempMasterSource: TDataSource;
         FMasterFields    : PString;
         FServants        : TList;  //Servants that are connected With This
         FDataTypes       : TStringList;
         FIndexDefs       : TIndexDefs;
         FIndexFieldMap   : TList;
         fODBCStmt        : tcODBCStmt;
      Private
         Function GetPassword:String;
         Function GetUserId:String;
         Procedure SetPassword(NewValue:String);
         Procedure SetUserId(NewValue:String);
         Procedure SetTableName(NewValue:String);
         Procedure SetTableLock(LockType:TLockType;Lock:Boolean);
         Procedure SetMasterSource(NewValue:TDataSource);
         Function GetMasterFields:String;
         Procedure SetMasterFields(Const NewValue:String);
         Procedure ConnectServant(Servant:TTable;Connect:Boolean);
         Procedure CloseStmt;
         Procedure GetNames(List:TStrings;Const Name:String);
         Procedure GetKeys(List:TStrings;Primary:Boolean);
         Function GetIndexFieldCount:LongInt;
         Function GetIndexField(Index:LongInt):TField;
         Procedure SetIndexField(Index:LongInt;NewValue:TField);
         Function GetIndexDefs:TIndexDefs;
      Protected
         Procedure SetupComponent;Override;
         Procedure SetActive(NewValue:Boolean);Override;
         Function GetResultColRow(Col,Row:LongInt):TField;Override;
         Procedure CommitInsert(Commit:Boolean);Override;
         Function UpdateFieldSelect(Field:TField):Boolean;Override;
         Procedure DataChange(event:TDataChange);Override;
         Procedure QueryTable;Override;
         Procedure DoOpen;Override;
         Procedure DoClose;Override;
         Procedure DoDelete;Override;
         Procedure DoCancel;Override;
         Procedure DoPost;Override;
         Procedure Loaded;Override;
         Procedure UpdateLinkList(Const PropertyName:String;LinkList:TList);Override;
      Public
         Procedure UpdateIndexDefs;Virtual;
         Procedure UpdateFieldDefs;
         Destructor Destroy;Override;
         Procedure RefreshTable;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Procedure GetDataSources(List:TStrings);Override;
         Procedure GetStoredProcNames(List:TStrings);Override;
         Procedure LockTable(LockType:TLockType);Virtual;
         Procedure UnlockTable(LockType:TLockType);Virtual;
         Procedure GetPrimaryKeys(List:TStrings);Virtual;
         Procedure GetTableNames(List:TStrings);Virtual;
         Procedure AddIndex(Const Name:String;Fields:String;Options:TIndexOptions);Virtual;
         Procedure DeleteIndex(Const Name: string);Virtual;
         Procedure CreateTable;Virtual;
         Procedure DeleteTable;Virtual;
         Procedure EmptyTable;Virtual;
         Function FindKey(Const KeyValues:Array of Const):Boolean;Virtual;
         Procedure GetIndexNames(List: TStrings);Virtual;
         Procedure RenameTable(NewTableName:String);Virtual;
         Procedure GetViewNames(List:TStrings);Virtual;
         Procedure GetSystemTableNames(List:TStrings);Virtual;
         Procedure GetSynonymNames(List:TStrings);Virtual;
         Procedure GetDataTypes(List:TStrings);Virtual;
         Procedure GetForeignKeys(List:TStrings);Virtual;
         Function DataType2Name(DataType:TFieldType):String;
      Public
         Property IndexDefs:TIndexDefs read GetIndexDefs;
         Property IndexFieldCount:LongInt read GetIndexFieldCount;
         Property IndexFields[Index:LongInt]:TField read GetIndexField write SetIndexField;
      Published
         Property TableName: String Read fTableName  Write SetTableName;
//         Property OrderBy  : String Read fOrderBy    Write fOrderBy;
         Property Password : String Read GetPassword Write SetPassword;
         Property UserId   : String Read GetUserId   Write SetUserId;
         Property MasterSource:TDataSource Read FMasterSource Write SetMasterSource;
         Property MasterFields:String Read GetMasterFields Write SetMasterFields;
    End;


    TQuery=Class(TTable)
      Private
         Property TableName;
         Property MasterFields;
         Property MasterSource;
         Property ReadOnly;
         Procedure SetSQL(NewValue:TStrings);
      Protected
         Procedure SetupComponent;Override;
      Public
         Procedure RefreshTable;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
      Published
         Property SQL:TStrings Read FSelect Write SetSQL;
    End;

    TParams = Class;

    TParamType = (ptUnknown, ptInput, ptOutput, ptInputOutput, ptResult, ptResultSet);

    TParam = Class
      Private
         FParamList: TParams;
         FData: Variant;
         FName:PString;
         FDataType: TFieldType;
         FNull: Boolean;
         FBound: Boolean;
         FParamType: TParamType;
         FResultNTS:CString;
         FResultLongInt:LongInt;
         FResultSmallInt:SmallInt;
         FResultExtended:Extended;
         FResultDate:Record
                         Year:Word;
                         Month:Word;
                         Day:Word;
         End;
         FResultTime:Record
                         Hour:WORD;
                         Minute:WORD;
                         Second:WORD;
         End;
         FResultDateTime:Record
                         Year:Word;
                         Month:Word;
                         Day:Word;
                         Hour:WORD;
                         Minute:WORD;
                         Second:WORD;
                         Fraction:LongWord;
         End;
         FOutLen:SQLINTEGER;
      Private
         Procedure SetAsBCD(Value: Currency);
         Procedure SetAsBoolean(Value: Boolean);
         Procedure SetAsCurrency(Value:Extended);
         Procedure SetAsDate(Value: TDateTime);
         Procedure SetAsDateTime(Value: TDateTime);
         Procedure SetAsFloat(Const Value:Extended);
         Procedure SetAsInteger(Value: Longint);
         Procedure SetAsString(const Value: string);
         Procedure SetAsSmallInt(Value: LongInt);
         Procedure SetAsTime(Value: TDateTime);
         Procedure SetAsVariant(Value: Variant);
         Procedure SetAsWord(Value: LongInt);
         Function GetName:String;
         Procedure SetName(Const NewValue:String);
      Protected
         Function GetAsBCD: Currency;
         Function GetAsBoolean: Boolean;
         Function GetAsDateTime: TDateTime;
         Function GetAsFloat:Extended;
         Function GetAsInteger: Longint;
         Function GetAsString: string;
         Function GetAsVariant: Variant;
         Function IsEqual(Value: TParam): Boolean;
         Procedure SetDataType(Value: TFieldType);
         Procedure SetText(Const Value:String);
      Public
         Constructor Create(AParamList: TParams; AParamType: TParamType);
         Destructor Destroy;Override;
         Procedure Assign(Param: TParam);
         Procedure AssignField(Field: TField);
         Procedure AssignFieldValue(Field:TField;Const Value: Variant);
         Procedure Clear;
      Public
         Property AsBCD: Currency read GetAsBCD write SetAsBCD;
         Property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
         Property AsCurrency:Extended read GetAsFloat write SetAsCurrency;
         Property AsDate: TDateTime read GetAsDateTime write SetAsDate;
         Property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
         Property AsFloat:Extended read GetAsFloat write SetAsFloat;
         Property AsInteger: LongInt read GetAsInteger write SetAsInteger;
         Property AsSmallInt: LongInt read GetAsInteger write SetAsSmallInt;
         Property AsString:String read GetAsString write SetAsString;
         Property AsTime: TDateTime read GetAsDateTime write SetAsTime;
         Property AsWord: LongInt read GetAsInteger write SetAsWord;
         Property Bound: Boolean read FBound write FBound;
         Property DataType: TFieldType read FDataType write SetDataType;
         Property IsNull: Boolean read FNull;
         Property Name:String read GetName write SetName;
         Property ParamType: TParamType read FParamType write FParamType;
         Property Text:String read GetAsString write SetText;
         Property Value: Variant read GetAsVariant write SetAsVariant;
    End;

    TParams=Class
      Private
         FItems: TList;
         Function GetParam(Index: Word): TParam;
         Function GetParamValue(Const ParamName:String):Variant;
         Procedure SetParamValue(Const ParamName:String;Const Value: Variant);
      Public
         Constructor Create;Virtual;
         Destructor Destroy;Override;
         Procedure AddParam(Value: TParam);
         Procedure RemoveParam(Value: TParam);
         Function CreateParam(FldType:TFieldType;Const ParamName:String;ParamType: TParamType): TParam;
         Function Count:LongInt;
         Procedure Clear;
         Function IsEqual(Value:TParams): Boolean;
         Function ParamByName(Const Value:String): TParam;
         Property Items[Index: Word]: TParam read GetParam;default;
         Property ParamValues[Const ParamName:String]: Variant read GetParamValue write SetParamValue;
    End;

    TStoredProc=Class(TTable)
      Private
         FPrepared:Boolean;
         FParams:TParams;
         FProcName:String;
         Function GetParamCount:Word;
         Procedure SetPrepared(NewValue:Boolean);
         Procedure SetParams(NewValue:TParams);
         Procedure SetStoredProcName(NewValue:String);
         Property TableName;
         Property MasterSource;
         Property MasterFields;
         Property ReadOnly;
      Protected
         Procedure Loaded;Override;
         Procedure DoOpen;Override;
         Procedure DoClose;Override;
         Function UpdateFieldSelect(field:TField):Boolean;Override;
      Public
         Constructor Create(AOwner: TComponent);Override;
         Destructor Destroy;Override;
         Procedure Insert;Override;
         Procedure Delete;Override;
         Procedure InsertRecord(Const Values:Array Of Const);Override;
         Procedure CopyParams(Value:TParams);
         Procedure ExecProc;
         Function ParamByName(Const Value:String):TParam;
         Procedure Prepare;
         Procedure UnPrepare;
         Procedure SetDefaultParams;
         Property ParamCount:Word read GetParamCount;
//         Property StmtHandle:SQLHStmt read FDBProcs.ahstmt;
         Property Prepared: Boolean read FPrepared write SetPrepared;
         Property Params:TParams read FParams write SetParams;
       Published
         Property StoredProcName:String read FProcName write SetStoredProcName;
    End;


Function Field2String(field:TField):String;
Function ExtractFieldName(Const Fields:String;Var Pos:LongInt):String;

Procedure DSNError(Const Message:String);
Procedure SQLError(Const Message:String);



Implementation

Type TGraphicHeader=Record
       Count:Word;                { Fixed at 1 }
       HType:Word;                { Fixed at $0100 }
       Size:Longint;              { Size not including header }
     End;

Var SQLProcessCount : LongWord;

Procedure EnterSQLProcessing;
Begin
  Screen.Cursor:=crSQLWait;
  inc(SQLProcessCount);
End;

Procedure LeaveSQLProcessing;
Begin
  If SQLProcessCount>0 Then dec(SQLProcessCount);
  If SQLProcessCount=0 Then Screen.Cursor:=crDefault;
End;

Procedure DSNError(Const Message:String);
Begin
  SQLProcessCount:=0;
  LeaveSQLProcessing;
  Raise EDSNError.Create(Message);
End;

Procedure SQLError(Const Message:String);
Begin
  SQLProcessCount:=0;
  LeaveSQLProcessing;
  Raise ESQLError.Create(Message);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDataLink Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TDataLink.SetDataSource(NewValue:TDataSource);
Begin
  If NewValue=FDataSource Then Exit;
  If FDataSource<>Nil Then FDataSource.Notification(Self,opRemove);
  FDataSource:=NewValue;
  If FDataSource<>Nil Then FDataSource.FreeNotification(Self);
  DataChange(deDSNChanged);
End;

Procedure TDataLink.DataChange(event:TDataChange);
Begin
  If OnDataChange<>Nil Then OnDataChange(Self,event);
End;

Procedure TDataLink.Notification(AComponent:TComponent;Operation:TOperation);
Begin
  Inherited Notification(AComponent,Operation);
  If AComponent=TComponent(FDataSource) Then If Operation=opRemove Then
    Begin
      FDataSource:=Nil;
      DataChange(deDSNChanged);
    End;
End;

Destructor TDataLink.Destroy;
Begin
  If FDataSource<>Nil Then FDataSource.Notification(Self,opRemove);
  FDataSource:=Nil;
  DataChange(deDSNChanged);
  Inherited Destroy;
End;

Procedure TDataLink.SetupComponent;
Begin
  Inherited SetupComponent;
  If Owner<>Nil Then SetDesigning(Owner.Designed);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TTableDataLink Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TTableDataLink.GetColRowField(Col,Row:LongInt):TField;
Begin
  Result:=Nil;
  If ((FDataSource=Nil)Or(FDataSource.DataSet=Nil)) Then Exit;
  Result:=FDataSource.DataSet.GetResultColRow(Col,Row);
End;

Function TTableDataLink.GetNameRowField(Name:String;Row:LongInt):TField;
Var Col:LongInt;
    S:String;
    T:LongInt;
Label Ok;
Begin
  Result:=Nil;
  If ((FDataSource=Nil)Or(FDataSource.DataSet=Nil)) Then Exit;

  UpcaseStr(Name);
  For T:=0 To FDataSource.DataSet.FieldCount-1 Do
    Begin
      S:=FDataSource.DataSet.FieldNames[T];
      UpcaseStr(S);
      If S=Name Then
        Begin
          Col:=T;
          Goto Ok;
        End;
    End;
  Exit;
Ok:
  Result:=FDataSource.DataSet.GetResultColRow(Col,Row);
End;

Function TTableDataLink.GetFieldCount:LongInt;
Begin
  Result:=0;
  If ((FDataSource=Nil)Or(FDataSource.DataSet=Nil)) Then Exit;
  Result:=FDataSource.DataSet.FieldCount;
End;

Function TTableDataLink.GetFieldName(Index:LongInt):String;
Begin
  Result:='';
  If ((FDataSource=Nil)Or(FDataSource.DataSet=Nil)) Then Exit;
  Result:=FDataSource.DataSet.FieldNames[Index];
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TFieldDataLink Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFieldDataLink.SetFieldName(Const NewValue:String);
Begin
  If GetFieldName=NewValue Then exit;
  AssignStr(FFieldName,NewValue);
  DataChange(deDSNChanged);
End;

Function TFieldDataLink.GetFieldName:String;
Begin
  Result:=FFieldName^;
End;

Procedure TFieldDataLink.SetupComponent;
Begin
  AssignStr(FFieldName,'');
  Inherited SetupComponent;
End;

Function TFieldDataLink.GetField:TField;
Var T:LongInt;
    S,s1:String;
Begin
  Result:=Nil;
  S:=GetFieldName;
  If ((FDataSource=Nil)Or(FDataSource.DataSet=Nil)Or(S='')) Then Exit;
  UpcaseStr(S);
  For T:=0 To FDataSource.DataSet.FieldCount-1 Do
    Begin
      s1:=FDataSource.DataSet.FieldNames[T];
      UpcaseStr(s1);
      If S=s1 Then
        Begin
          Result:=FDataSource.DataSet.Fields[T];
          Exit;
        End;
    End;
End;

Destructor TFieldDataLink.Destroy;
Begin
  AssignStr(FFieldName,'');
  Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDataSource Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//This tables DataSource changes, notify All Servants linked With MasterSource
Procedure NotifyServants(Table:TTable);
Var T:LongInt;
    Servant:TTable;
Begin
  If Table.FServants<>Nil Then
    Begin  //notify All Servants that their MasterSource Is invalid
      For T:=0 To Table.FServants.Count-1 Do
        Begin
          Servant:=Table.FServants[T];
          Servant.FMasterSource:=Nil;
          If ((Servant.ComponentState*[csReading]=[]) And
              (Not Servant.FDataSetLocked)) Then
            Servant.RefreshTable;
        End;
      Table.FServants.Clear;
    End;
End;

Procedure TDataSource.SetDataSet(NewValue:TDataSet);
Var Table,Servant:TTable;
    T:LongInt;
Begin
  If FDataSet<>Nil Then
    Begin
      If FDataSet Is TTable Then
        Begin
          If Not (NewValue Is TTable)
            Then NotifyServants(TTable(FDataSet))
            Else
              If NewValue<>FDataSet Then
                Begin
                    //New DataSet Is also A Table
                    //Link All Servants Of  This Table To the New one
                  Table:=TTable(FDataSet);
                  If Table.FServants<>Nil Then
                    Begin
                      For T:=0 To Table.FServants.Count-1 Do
                        Begin
                          Servant:=Table.FServants[T];
                          TTable(NewValue).ConnectServant(Servant,True);
                        End;
                      Table.FServants.Clear;
                    End;
               End;
        End;
      FDataSet.Notification(Self,opRemove);
    End;
  FDataSet:=NewValue;
  If FDataSet<>Nil Then FDataSet.FreeNotification(Self);
  DataChange(deDSNChanged);
End;

Destructor TDataSource.Destroy;
Begin
  If FDataSet Is TTable Then NotifyServants(TTable(FDataSet));
  If FDataSet<>Nil Then FDataSet.Notification(Self,opRemove);
  FDataSet:=Nil;
  Inherited Destroy;
End;

Procedure TDataSource.SetupComponent;
Begin
  Include(ComponentState, csHandleLinks);
  Inherited SetupComponent;
End;

Procedure TDataSource.DataChange(event:TDataChange);
Var T:LongInt;
    Link:TDataLink;
    FLinkList:TList;
Begin
  FLinkList:=FreeNotifyList;
  If FLinkList<>Nil Then For T:=0 To FLinkList.Count-1 Do
    Begin
      Link:=FLinkList.Items[T];
      If Link Is TDataLink Then Link.DataChange(event);
    End;
End;

Procedure TDataSource.Notification(AComponent:TComponent;Operation:TOperation);
Begin
  Inherited Notification(AComponent,Operation);

  If AComponent=TComponent(FDataSet) Then If Operation=opRemove Then
    Begin
      FDataSet:=Nil;
      DataChange(deDSNChanged);
      If OnDataChange<>Nil Then OnDataChange(Self,deDSNChanged);
    End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TField Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TField.GetIsIndexField:Boolean;
Var s,s1,s2:String;
    t:LongInt;
    IndexDef:TIndexDef;
Begin
     Result:=False;
     If not (FDataSet Is TTable) Then exit;
     s:=FieldName;
     UpcaseStr(s);
     For t:=0 To TTable(FDataSet).IndexDefs.Count-1 Do
     Begin
          IndexDef:=TTable(FDataSet).IndexDefs[t];
          s1:=IndexDef.Fields;
          UpcaseStr(s1);
          While pos(';',s1)<>0 Do
          Begin
               s2:=Copy(s1,1,pos(';',s1)-1);
               Delete(s1,1,pos(';',s1));
               If s=s2 Then
               Begin
                   Result:=True;
                   exit;
               End;
          End;
          If s=s1 Then Result:=True;
     End;
End;

Function TField.GetReadOnly:Boolean;
Begin
  Result:=FReadOnly Or FDataSet.ReadOnly;
End;

Function TField.GetCanModify:Boolean;
Begin
  Result:=not ReadOnly;
End;

Procedure TField.SetData(Buffer:Pointer);
Begin
  If ReadOnly Then DSNError('Cannot modify a readonly field !');
  If FValueLen > 0 Then
    Begin
      If FValue<>Nil Then FreeMem(FValue,FValueLen);
      FValue:=Nil;
      If Buffer<>Nil Then
        Begin
          GetMem(FValue,FValueLen);
          Move(Buffer^,FValue^,FValueLen);
        End;
    End;
End;

Procedure TField.Assign(Field:TField);
Begin
  If ReadOnly Then DSNError('Cannot modify a readonly field !');
  If Field=Nil Then
    Begin
      Clear;
      If FValueLen<>0 Then FreeMem(FValue,FValueLen);
      FValueLen:=0;
      FValue:=Nil;
      exit;
    End;
  Value:=Field.Value;
End;

Function TField.GetAsVariant:Variant;
Begin
  AccessError('Variant');
End;

Procedure TField.SetAsVariant(NewValue:Variant);
Begin
  AccessError('Variant');
End;

Function TField.GetFieldName:String;
Begin
  If FFieldDef <> Nil
    Then Result := FFieldDef.Name
    Else Result:='';
End;

Function TField.GetIsNull:Boolean;
Begin
  Result:=FValue=Nil;
End;

Destructor TField.Destroy;
Begin
  If FValue<>Nil Then
    If FValueLen>0 Then FreeMem(FValue,FValueLen);
  FValueLen:=0;
  FValue:=Nil;
  Inherited Destroy;
End;

Procedure TField.Clear;
Var  OldValue:Pointer;
     OldValueLen:LongInt;
Begin
  //SetNewValue(Nil,0);
  OldValue := FValue;
  OldValueLen := FValueLen;
  FValueLen := 0;
  FValue := Nil;
  FDataSet.UpdateField(Self,OldValue,OldValueLen);
  {wo wird der alte Speicher wieder freigegeben???}
End;

Procedure TField.FreeMemory;
Begin
  If (FValue <> Nil) And (FValueLen > 0) Then FreeMem(FValue,FValueLen);
  FValueLen := 0;
  FValue := Nil;
End;

Procedure TField.GetMemory(Size:Longint);
Begin
  FValueLen := Size;
  GetMem(FValue,FValueLen);
End;


Procedure TField.AccessError(Const TypeName:String);
Begin
  DSNError('Invalid type conversion to '+TypeName+' in field: '+FieldName);
End;


Procedure TField.CheckInactive;
Begin
  If FDataSet <> Nil Then FDataSet.CheckInactive;
End;


{$HINTS OFF}
Procedure TField.SetAsValue(Var Value;Len:LongInt);
Begin
  SetNewValue(Value,Len);
End;

Function TField.GetAsString:String;
Begin
  AccessError('String');
End;

Procedure TField.SetAsString(Const NewValue:String);
Begin
  AccessError('String');
End;

Function TField.GetAsAnsiString:AnsiString;
Begin
  AccessError('AnsiString');
End;

Procedure TField.SetAsAnsiString(NewValue:AnsiString);
Begin
  AccessError('AnsiString');
End;

Function TField.GetAsBoolean:Boolean;
Begin
  AccessError('Boolean');
End;

Procedure TField.SetAsBoolean(NewValue:Boolean);
Begin
  AccessError('Boolean');
End;

Function TField.GetAsDateTime:TDateTime;
Begin
  AccessError('DateTime');
End;

Procedure TField.SetAsDateTime(NewValue:TDateTime);
Begin
  AccessError('DateTime');
End;

Function TField.GetAsFloat:Extended;
Begin
  AccessError('Float');
End;

Procedure TField.SetAsFloat(Const NewValue:Extended);
Begin
  AccessError('Float');
End;

Function TField.GetAsInteger:LongInt;
Begin
  AccessError('Integer');
End;

Procedure TField.SetAsInteger(NewValue:LongInt);
Begin
  AccessError('Integer');
End;
{$HINTS ON}

Procedure TField.SetNewValue(Var NewValue;NewLen:LongInt);
Var OldValue:Pointer;
    OldValueLen:LongInt;
Begin
  If ReadOnly Then DSNError('Cannot modify a readonly field !');
  OldValue:=FValue;
  OldValueLen:=FValueLen;
  FValueLen:=NewLen;
  If FValueLen > 0 Then
    Begin
      GetMem(FValue,FValueLen);
      Move(NewValue,FValue^,FValueLen);
    End;
  FDataSet.UpdateField(Self,OldValue,OldValueLen);
  {wo wird der alte Speicher wieder freigegeben???}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TStringField Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TStringField.GetAsVariant:Variant;
Begin
  Result:=GetAsString;
End;

Procedure TStringField.SetAsVariant(NewValue:Variant);
Begin
  SetAsString(NewValue);
End;

Function TStringField.GetAsString:String;
Begin
  If FValue <> Nil
    Then
      Begin
        Result[0] := Chr(FValueLen);
        Move(FValue^,Result[1],Ord(Result[0]));
        If Result[Length(Result)]=#0 Then
          If length(Result)>0 Then Dec(Result[0]);
      End
//Else Result:='NULL';
    Else Result := '';
End;

Procedure TStringField.SetAsString(Const NewValue:String);
Var C:CString;
Begin
  If NewValue <> ''
    Then
      Begin
        C:=NewValue;
        SetNewValue(C,Length(NewValue)+1);
      End
    Else Clear;
End;

Function TStringField.GetAsAnsiString:AnsiString;
Begin
  If FValue<>Nil
    Then Result:=PChar(Value)^
    Else Result:='';
End;

Procedure TStringField.SetAsAnsiString(NewValue:AnsiString);
Begin
  If PChar(NewValue) = Nil
    Then NewValue:=#0;
  SetNewValue(PChar(NewValue)^,length(PChar(NewValue)^)+1)
End;

Function TStringField.GetAsBoolean:Boolean;
Var S:String;
Begin
  S:=GetAsString;
  UpcaseStr(S);
  Result:=((S='TRUE') Or (S='YES') Or (S='1'));
End;

Procedure TStringField.SetAsBoolean(NewValue:Boolean);
Var S:String;
Begin
  If NewValue
    Then S:='True'
    Else S:='False';
  SetAsString(S);
End;

Function TStringField.GetAsDateTime:TDateTime;
Begin
  Result:=StrToDateTime(GetAsString);
End;

Function TStringField.GetAsFloat:Extended;
Begin
  Result:=StrToFloat(GetAsString);
End;

Procedure TStringField.SetAsFloat(Const NewValue:Extended);
Begin
  SetAsString(FloatToStr(NewValue));
End;

Function TStringField.GetAsInteger:LongInt;
Begin
  Result:=StrToInt(GetAsString);
End;

Procedure TStringField.SetAsInteger(NewValue:LongInt);
Begin
  SetAsString(tostr(NewValue));
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TSmallintField Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TSmallIntField.GetAsVariant:Variant;
Begin
  Result:=GetAsSmallInt;
End;

Procedure TSmallIntField.SetAsVariant(NewValue:Variant);
Begin
  SetAsSmallInt(NewValue);
End;


Function TSmallintField.GetAsString:String;
Begin
  If FValue<>Nil
    Then Result:=tostr(Integer(FValue^))
    Else Result:='';
End;

Procedure TSmallintField.SetAsString(Const NewValue:String);
Var I,C:Integer;
Begin
  If NewValue <> ''
    Then
      Begin
        Val(NewValue,I,C);
        If C=0 Then SetNewValue(I,SizeOf(Integer));
      End
    Else Clear;
End;

Function TSmallintField.GetAsAnsiString:AnsiString;
Begin
  Result:=GetAsString;
End;

Procedure TSmallintField.SetAsAnsiString(NewValue:AnsiString);
Begin
  SetAsString(NewValue);
End;

Function TSmallintField.GetAsBoolean:Boolean;
Var I:Integer;
Begin
  I:=GetAsInteger;
  Result:=I<>0;
End;

Procedure TSmallintField.SetAsBoolean(NewValue:Boolean);
Begin
  If NewValue
    Then SetAsInteger(1)
    Else SetAsInteger(0);
End;

Function TSmallintField.GetAsSmallint:Integer;
Begin
  If FValue<>Nil
    Then Result:=Integer(FValue^)
    Else AccessError('Smallint');
End;

Procedure TSmallintField.SetAsSmallInt(NewValue:Integer);
Begin
  SetNewValue(NewValue,SizeOf(Integer));
End;

Function TSmallintField.GetAsFloat:Extended;
Begin
  If FValue<>Nil
    Then Result:=Integer(FValue^)
    Else AccessError('Float');
End;

Procedure TSmallintField.SetAsFloat(Const NewValue:Extended);
Begin
  SetAsSmallInt(Round(NewValue));
End;

Function TSmallintField.GetAsInteger:LongInt;
Begin
  If FValue<>Nil
    Then Result:=Integer(FValue^)
    Else AccessError('Integer');
End;

Procedure TSmallintField.SetAsInteger(NewValue:LongInt);
Begin
  SetAsSmallInt(NewValue);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TIntegerField Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TIntegerField.GetAsVariant:Variant;
Begin
  Result:=GetAsInteger;
End;

Procedure TIntegerField.SetAsVariant(NewValue:Variant);
Begin
  SetAsInteger(NewValue);
End;

Function TIntegerField.GetAsString:String;
Begin
  If FValue<>Nil
    Then Result:=tostr(LongInt(FValue^))
    Else Result:='';
End;

Procedure TIntegerField.SetAsString(Const NewValue:String);
Var I:LongInt;
    C:Integer;
Begin
  If NewValue <> ''
    Then
      Begin
        Val(NewValue,I,C);
        If C=0
          Then SetNewValue(I,SizeOf(LongInt))
          Else AccessError('String');
      End
    Else Clear;
End;

Function TIntegerField.GetAsAnsiString:AnsiString;
Begin
  Result:=GetAsString;
End;

Procedure TIntegerField.SetAsAnsiString(NewValue:AnsiString);
Begin
  SetAsString(NewValue);
End;

Function TIntegerField.GetAsBoolean:Boolean;
Var I:Integer;
Begin
  I:=GetAsInteger;
  Result:=I<>0;
End;

Procedure TIntegerField.SetAsBoolean(NewValue:Boolean);
Begin
  If NewValue
    Then SetAsInteger(1)
    Else SetAsInteger(0);
End;

Function TIntegerField.GetAsFloat:Extended;
Begin
  If FValue<>Nil
    Then Result:=LongInt(FValue^)
    Else AccessError('Float');
End;

Procedure TIntegerField.SetAsFloat(Const NewValue:Extended);
Begin
  SetAsInteger(Round(NewValue));
End;

Function TIntegerField.GetAsInteger:LongInt;
Begin
  If FValue<>Nil
    Then Result:=LongInt(FValue^)
    Else AccessError('Integer');
End;

Procedure TIntegerField.SetAsInteger(NewValue:LongInt);
Begin
  SetNewValue(NewValue,SizeOf(LongInt));
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TBooleanField Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TBooleanField.GetAsVariant:Variant;
Begin
  Result:=GetAsBoolean;
End;

Procedure TBooleanField.SetAsVariant(NewValue:Variant);
Begin
  SetAsBoolean(NewValue);
End;


Function TBooleanField.GetAsString:String;
Begin
  If FValue<>Nil
    Then
      Begin
        If Boolean(FValue^)
          Then Result:='True'
          Else Result:='False';
      End
    Else Result:='';
End;

Procedure TBooleanField.SetAsString(Const NewValue:String);
Var  s:String;
Begin
  If NewValue <> ''
    Then
      Begin
        s:=NewValue;
        UpcaseStr(s);

        If ((s='TRUE')Or(s='YES')Or(s='T')Or(s='Y')Or(s='1'))
          Then SetAsBoolean(True)
          Else SetAsBoolean(False);
      End
    Else Clear;
End;

Function TBooleanField.GetAsAnsiString:AnsiString;
Begin
  Result:=GetAsString;
End;

Procedure TBooleanField.SetAsAnsiString(NewValue:AnsiString);
Begin
  SetAsString(NewValue);
End;

Function TBooleanField.GetAsBoolean:Boolean;
Begin
  If FValue<>Nil
    Then Result:=Boolean(FValue^)
    Else Result:=False;
End;

Procedure TBooleanField.SetAsBoolean(NewValue:Boolean);
Begin
  SetNewValue(NewValue,SizeOf(Boolean))
End;

Function TBooleanField.GetAsFloat:Extended;
Begin
  If FValue<>Nil
    Then
      Begin
        If Boolean(FValue^)
          Then Result := 1
          Else Result := 0;
      End
    Else AccessError('Float');
End;

Procedure TBooleanField.SetAsFloat(Const NewValue:Extended);
Begin
  SetAsInteger(round(NewValue));
End;

Function TBooleanField.GetAsInteger:LongInt;
Begin
  If FValue<>Nil
    Then
      Begin
        If Boolean(FValue^)
          Then Result := 1
          Else Result := 0;
      End
    Else AccessError('Integer');
End;

Procedure TBooleanField.SetAsInteger(NewValue:LongInt);
Begin
  If NewValue = 0
    Then SetAsBoolean(False)
    Else SetAsBoolean(True);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TFloatField Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TFloatField.Create;
Begin
  Inherited Create;
  FPrecision := -1;
End;

Function TFloatField.GetAsVariant:Variant;
Begin
  Result:=GetAsFloat;
End;

Procedure TFloatField.SetAsVariant(NewValue:Variant);
Begin
  SetAsFloat(NewValue);
End;


Procedure TFloatField.SetPrecision(Value:Longint);
Begin
  //If Value < 2 Then Value := 2;
  If Value > 15 Then Value := 15;
  FPrecision := Value;
End;


Function TFloatField.GetAsString:String;
Var  E:Extended;
Begin
  If FValue <> Nil
    Then
      Begin
        E := GetAsFloat;
        If Precision >= 0
          Then
            Begin
              Result := Format('%.'+ tostr(Precision) +'f',[E]);
              If Precision = 0 Then
                If pos('.',Result) > 0 Then SubStr(Result,1,pos('.',Result)-1);
            End
          Else Result := FloatToStr(E);
      End
    Else Result := '';
End;

Procedure TFloatField.SetAsString(Const NewValue:String);
Var E:Extended;
    C:Integer;
    p:Integer;
    aValue:String;
Begin
  If NewValue <> ''
    Then
      Begin
        //replace , by .
        p := pos(',',NewValue);
        If p > 0
          Then
            Begin
              aValue := NewValue;
              aValue[p] := '.';
              Val(aValue,E,C);
            End
          Else Val(NewValue,E,C);
        If C=0
          Then SetAsFloat(E)
          Else AccessError('String');
     End
    Else Clear;
End;

Function TFloatField.GetAsAnsiString:AnsiString;
Begin
  Result:=GetAsString;
End;

Procedure TFloatField.SetAsAnsiString(NewValue:AnsiString);
Begin
  SetAsString(NewValue);
End;

Function TFloatField.GetAsFloat:Extended;
Begin
  If FValue<>Nil
    then
      Begin
        Case FSize Of
          4:Result:=Single(FValue^);
          8:Result:=Double(FValue^);
         10:Result:=Extended(FValue^);
         Else AccessError('Float');
        End; {Case}
      End
     //Else AccessError('Float');
   Else Result := 0;
End;

Procedure TFloatField.SetAsFloat(Const NewValue:Extended);
Var E:Extended;
    S:Single;
    D:Double;
Begin
  Case FSize Of
    4: Begin
         S:=NewValue;
         SetNewValue(S,SizeOf(Single));
       End;
    8: Begin
         D:=NewValue;
         SetNewValue(D,SizeOf(Double));
       End;
   10: Begin
         E:=NewValue;
         SetNewValue(E,SizeOf(Extended));
       End;
  End;
End;

Function TFloatField.GetAsInteger:LongInt;
Begin
  Result := Round(GetAsFloat);
End;


Procedure TFloatField.SetAsInteger(NewValue:LongInt);
Var  E:Extended;
Begin
  E := NewValue;
  SetAsFloat(E);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TCurrencyField Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TCurrencyField.Create;
Begin
  Inherited Create;
  FPrecision := 2;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDateField Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDateField.GetAsString:String;
Var  date:TDateTime;
Begin
  If FValue <> Nil
    Then
      Begin
        date := GetAsDateTime;
        DateTimeToString(result,DisplayFormat,date);
      End
    Else Result := '';
End;

Destructor TDateField.Destroy;
Begin
  AssignStr(FDisplayFormat,'');
  Inherited Destroy;
End;

Function TDateField.GetDisplayFormat:String;
Begin
  If FDisplayFormat=Nil
    Then Result:=ShortDateFormat
    Else Result:=FDisplayFormat^;
End;

Procedure TDateField.SetDisplayFormat(Const NewValue:String);
Begin
  AssignStr(FDisplayFormat,NewValue);
  If FDataSet<>Nil Then
    FDataSet.DataChange(deDSNChanged);
End;

Function TDateField.GetAsVariant:Variant;
Begin
  Result:=GetAsDateTime;
End;

Procedure TDateField.SetAsVariant(NewValue:Variant);
Begin
  SetAsDateTime(NewValue);
End;


Procedure TDateField.SetAsString(Const NewValue:String);
Var dt:TDateTime;
    Valid:Boolean;
Begin
  If NewValue <> ''
     Then
       Begin
         Try
           dt:=StrToDate(NewValue);
           Valid:=True;
         Except
           Valid:=False;
         End;
         If Valid Then SetAsDateTime(dt);
       End
     Else Clear;
End;

Function TDateField.GetAsAnsiString:AnsiString;
Begin
  Result:=GetAsString;
End;

Procedure TDateField.SetAsAnsiString(NewValue:AnsiString);
Begin
  SetAsString(NewValue);
End;

Function TDateField.GetAsFloat:Extended;
Begin
  If FValue<>Nil
    Then Result:=GetAsDateTime
    Else AccessError('Float');
End;


Function TDateField.GetAsDateTime:TDateTime;
Var  date:TODBCDate;
Begin
  If FValue<>Nil
    Then
      Begin
        date:=TODBCDate(FValue^);
        Result:=EncodeDate(date.Year,date.Month,date.Day);
      End
    Else AccessError('DateTime');
End;

Procedure TDateField.SetAsDateTime(NewValue:TDateTime);
Var  R:TODBCDate;
Begin
  DecodeDate(NewValue,R.Year,R.Month,R.Day);
  SetNewValue(R,SizeOf(R));
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TTimeField Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure RoundDecodeTime(Time: TDateTime; Var Hour, Min, Sec: Word);
Var  MSec:Word;
Begin
  DecodeTime(Time, Hour, Min, Sec, MSec);

  If MSec > 500 Then
    Begin
      MSec := 0;
      inc(Sec);
    End;
  If Sec >= 60 Then
    Begin
      dec(Sec,60);
      inc(Min);
    End;
  If Min >= 60 Then
    Begin
      dec(Min,60);
      inc(Hour);
    End;
End;


Destructor TTimeField.Destroy;
Begin
  AssignStr(FDisplayFormat,'');
  Inherited Destroy;
End;

Function TTimeField.GetDisplayFormat:String;
Begin
  If FDisplayFormat=Nil
    Then Result:=LongTimeFormat
    Else Result:=FDisplayFormat^;
End;

Procedure TTimeField.SetDisplayFormat(Const NewValue:String);
Begin
  AssignStr(FDisplayFormat,NewValue);
  If FDataSet<>Nil Then
    FDataSet.DataChange(deDSNChanged);
End;

Function TTimeField.GetAsVariant:Variant;
Begin
  Result:=GetAsDateTime;
End;

Procedure TTimeField.SetAsVariant(NewValue:Variant);
Begin
  SetAsDateTime(NewValue);
End;


Function TTimeField.GetAsString:String;
Var Time:TDateTime;
Begin
  If FValue<>Nil
    Then
      Begin
        Time:=GetAsDateTime;
        DateTimeToString(Result,DisplayFormat,Time);
      End
    Else Result:='';
End;

Procedure TTimeField.SetAsString(Const NewValue:String);
Var dt:TDateTime;
    Valid:Boolean;
Begin
  If NewValue <> ''
    Then
      Begin
        Try
          dt:=StrToTime(NewValue);
          Valid:=True;
        Except
          Valid:=False;
        End;
        If Valid Then SetAsDateTime(dt);
      End
    Else Clear;
End;

Function TTimeField.GetAsAnsiString:AnsiString;
Begin
  Result:=GetAsString;
End;

Procedure TTimeField.SetAsAnsiString(NewValue:AnsiString);
Begin
  SetAsString(NewValue);
End;

Function TTimeField.GetAsFloat:Extended;
Begin
  If FValue<>Nil
    Then Result:=GetAsDateTime
    Else AccessError('Float');
End;


Function TTimeField.GetAsDateTime:TDateTime;
Var  Time:TODBCTime;
Begin
  If FValue<>Nil
    Then
      Begin
        Time:=TODBCTime(FValue^);
        Result:=EncodeTime(Time.Hour,Time.Minute,Time.Second,0);
      End
    Else AccessError('DateTime');
End;

Procedure TTimeField.SetAsDateTime(NewValue:TDateTime);
Var  R:TODBCTime;
Begin
  RoundDecodeTime(NewValue,R.Hour,R.Minute,R.Second);
  SetNewValue(R,SizeOf(R));
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDateTimeField Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Destructor TDateTimeField.Destroy;
Begin
  AssignStr(FDisplayFormat,'');
  Inherited Destroy;
End;

Function TDateTimeField.GetDisplayFormat:String;
Begin
  If FDisplayFormat=Nil
    Then Result:=ShortDateFormat+' '+LongTimeFormat
    Else Result:=FDisplayFormat^;
End;

Procedure TDateTimeField.SetDisplayFormat(Const NewValue:String);
Begin
  AssignStr(FDisplayFormat,NewValue);
  If FDataSet<>Nil Then
    FDataSet.DataChange(deDSNChanged);
End;

Function TDateTimeField.GetAsVariant:Variant;
Begin
  Result:=GetAsDateTime;
End;

Procedure TDateTimeField.SetAsVariant(NewValue:Variant);
Begin
  SetAsDateTime(NewValue);
End;


Function TDateTimeField.GetAsString:String;
Var DateTime:TDateTime;
Begin
  If FValue<>Nil
    Then
      Begin
        DateTime:=GetAsDateTime;
        DateTimeToString(result,DisplayFormat,DateTime);
      End
    Else Result:='';
End;

Procedure TDateTimeField.SetAsString(Const NewValue:String);
Var dt:TDateTime;
    Valid:Boolean;
Begin
  If NewValue <> ''
    Then
      Begin
        Try
          dt:=StrToDateTime(NewValue);
          Valid:=True;
        Except
          Valid:=False;
        End;
        If Valid Then SetAsDateTime(dt);
      End
    Else Clear;
End;

Function TDateTimeField.GetAsAnsiString:AnsiString;
Begin
  Result:=GetAsString;
End;

Procedure TDateTimeField.SetAsAnsiString(NewValue:AnsiString);
Begin
  SetAsString(NewValue);
End;

Function TDateTimeField.GetAsFloat:Extended;
Begin
  If FValue<>Nil
    Then Result:=GetAsDateTime
    Else AccessError('Float');
End;

Function TDateTimeField.GetAsDateTime:TDateTime;
Var  dt:TODBCDateTime;
Begin
  If FValue<>Nil
    Then
      Begin
        dt:=TODBCDateTime(FValue^);
        Result:=EncodeDate(dt.Date.Year,dt.Date.Month,dt.Date.Day) +
                EncodeTime(dt.Time.Hour,dt.Time.Minute,dt.Time.Second,0);
      End
    Else AccessError('DateTime');
End;

Procedure TDateTimeField.SetAsDateTime(NewValue:TDateTime);
Var  R:TODBCDateTime;
Begin
  DecodeDate(NewValue,R.Date.Year,R.Date.Month,R.Date.Day);
  RoundDecodeTime(NewValue,R.Time.Hour,R.Time.Minute,R.Time.Second);
  SetNewValue(R,SizeOf(R));
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TBlobField Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TBlobField.GetAsString:String;
Begin
  If FValue <> Nil
    Then Result := '[Blob]'
    Else Result := '[BLOB]';
End;

Function TBlobField.GetAsAnsiString:AnsiString;
Begin
  Result := GetAsString;
End;

Procedure TBlobField.LoadFromStream(Stream:TStream);
Var  prec:^Byte;
Begin
  If Stream Is TStream Then
    Begin
      GetMem(prec, Stream.Size);
      Stream.Position := 0;
      Stream.Read(prec^,Stream.Size);
      SetAsValue(prec^, Stream.Size);
      FreeMem(prec, Stream.Size);
    End;
End;


Procedure TBlobField.LoadFromFile(Const FileName:String);
Var  Stream:TFileStream;
Begin
     Stream.Create(FileName, fmOpenRead Or fmShareDenyNone);
     Try
        LoadFromStream(Stream);
     Finally
        Stream.Destroy;
     End;
End;


Procedure TBlobField.SaveToStream(Stream:TStream);
Begin
     If Stream Is TStream Then
     Begin
          If FValue <> Nil Then Stream.Write(FValue^,FValueLen);
     End;
End;


Procedure TBlobField.SaveToFile(Const FileName:String);
Var  Stream:TFileStream;
Begin
     Stream.Create(FileName, fmCreate);
     Try
        SaveToStream(Stream);
     Finally
        Stream.Destroy;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMemoField Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TMemoField.GetAsString:String;
Begin
     If FValue <> Nil Then Result := '[Memo]'
     Else Result := '[MEMO]';
End;

Function TMemoField.GetAsAnsiString:AnsiString;
Begin
     If FValue = Nil Then Result := ''
     Else Result := PChar(FValue)^;
End;

Procedure TMemoField.SetAsAnsiString(NewValue:AnsiString);
Begin
     If NewValue <> '' Then
     Begin
          SetNewValue(PChar(NewValue)^,length(PChar(NewValue)^)+1);
     End
     Else Clear;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TGraphicField Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TGraphicField.GetAsString:String;
Begin
     If FValue<>Nil Then Result:='[Graphic]'
     Else Result:='[GRAPHIC]';
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TFieldList Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFieldList.Clear;
Var T:LongInt;
    field:TField;
Begin
     For T:=0 To Count-1 Do
     Begin
          field:=Items[T];
          field.Destroy;
     End;
     Inherited Clear;
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TIndexDef Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TIndexDef.GetName:String;
Begin
    If FName<>Nil Then Result:=FName^
    Else Result:='';
End;

Function TIndexDef.GetFields:String;
Begin
     If FFields<>Nil Then Result:=FFields^
     Else Result:='';
End;

Constructor TIndexDef.Create(Owner:TIndexDefs;Const Name, Fields:String;Options:TIndexOptions);
Begin
     Inherited Create;

     If Owner <> Nil Then
     Begin
         Owner.FItems.Add(Self);
         FOwner:=Owner;
     End;

     AssignStr(FName,Name);
     AssignStr(FFields,Fields);
     FOptions:=Options;
End;

Destructor TIndexDef.Destroy;
Begin
     If FOwner <> Nil Then FOwner.FItems.Remove(Self);

     AssignStr(FName,'');
     AssignStr(FFields,'');

     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TIndexDefs Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TIndexDefs.GetCount:LongInt;
Begin
     Result:=FItems.Count;
End;

Function TIndexDefs.GetItem(Index:LongInt):TIndexDef;
Begin
     Result:=TIndexDef(FItems[Index]);
End;

Constructor TIndexDefs.Create(DataSet:TDataSet);
Begin
     Inherited Create;
     FDataSet:=DataSet;
     FItems.Create;
End;

Destructor TIndexDefs.Destroy;
Begin
     Clear;
     FItems.Destroy;
     Inherited Destroy;
End;

Procedure TIndexDefs.Clear;
Var IndexDef:TIndexDef;
Begin
     While FItems.Count > 0 Do
     Begin
          IndexDef := TIndexDef(FItems[0]);
          IndexDef.Destroy; // auto removing from FItems
     End;
End;

Function TIndexDefs.Add(Const Name,Fields:String;Options:TIndexOptions):TIndexDef;
Begin
     //...check valid
     Result.Create(Self, Name, Fields,Options);
End;

Procedure TIndexDefs.Assign(IndexDefs: TIndexDefs);
Var IndexDef:TIndexDef;
    t:LongInt;
Begin
     Clear;
     For t:=0 To IndexDefs.Count-1 Do
     Begin
          IndexDef:=IndexDefs.Items[t];
          Add(IndexDef.Name,IndexDef.Fields,IndexDef.Options);
     End;
End;

Function TIndexDefs.FindIndexForFields(Const Fields:String):TIndexDef;
Begin
     Result:=GetIndexForFields(Fields,False);
     If Result=Nil Then DSNError('No index for fields: '+Fields);
End;

Function TIndexDefs.GetIndexForFields(Const Fields:String;CaseInsensitive:Boolean):TIndexDef;
Var t:LongInt;
    s,s1:String;
Begin
     s:=Fields;
     If CaseInsensitive Then UpcaseStr(s);
     Result:=Nil;
     For t:=0 To Count-1 Do
     Begin
          s1:=Items[t].Fields;
          If CaseInsensitive Then UpcaseStr(s1);
          If s=s1 Then
          Begin
               Result:=Items[t];
               exit;
          End;
     End;
End;

Function TIndexDefs.IndexOf(Const Name:String):LongInt;
Var t:LongInt;
Begin
  Result:=-1;
  For t:=0 To Count-1 Do
    If Items[t].Name=Name Then
      Begin
        Result:=t;
        exit;
      End;
End;

Procedure TIndexDefs.Update;
Begin
  TTable(FDataSet).UpdateIndexDefs;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TFieldDef Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TFieldDef.Create(aOwner:TFieldDefs; Const aName:String;
  aDataType:TFieldType; aSize:Longword; aRequired:Boolean; aFieldNo:Longint);
Begin
  Inherited Create;
  If aOwner <> Nil Then
    Begin
      aFieldNo := aOwner.FItems.Add(Self);
      FOwner := aOwner;
    End;

  FName := aName;
  FDataType := aDataType;
  FSize := aSize;
  If aDataType = ftString Then Inc(FSize);
  FRequired := aRequired;
  FFieldNo := aFieldNo;
  FPrecision := -1;
  If FDataType In [ftWord,ftInteger,ftSmallInt] Then
    If not (FSize In [1,2,4]) Then
      FSize:=4; //LongInt
  If FDataType=ftFloat Then
    If not (FSize In [4,8,10]) Then FSize:=10; //Extended
      FFields.Create;
End;

Function TFieldDef.GetTypeName:String;
Begin
  If FTypeName=Nil
    Then
      Begin
        Result:='';
        If FOwner.FDataSet Is TTable Then
          Result:=TTable(FOwner.FDataSet).DataType2Name(FDataType);
      End
    Else Result:=FTypeName^;
End;

Procedure TFieldDef.SetTypeName(Const NewValue:String);
Begin
  AssignStr(FTypeName,NewValue);
End;

Destructor TFieldDef.Destroy;
Var  i:Longint;
     Field:TField;
Begin
  If FOwner <> Nil Then FOwner.FItems.Remove(Self);

  If FFields <> Nil Then
    Begin
      For i := 0 To FFields.Count-1 Do
        Begin
          Field := TField(FFields[i]);
          If Field <> Nil Then Field.Destroy;
        End;
    End;

  AssignStr(FForeignKey,'');
  AssignStr(FTypeName,'');

  FFields.Destroy;
  FFields := Nil;

  Inherited Destroy;
End;


Function TFieldDef.CreateField(Owner:TComponent):TField;
Var  FieldClass:TFieldClass;
Begin
  FieldClass := GetFieldClass;
  If FieldClass = Nil Then
    DSNError('Unknown field type "'+Name+'"');
   Result := FieldClass.Create;
   Try
     Result.FFieldDef := Self;
     Result.FRequired := Required;
     Result.FSize := Size;
     Result.FDataType := FDataType;
     If Result Is TFloatField Then
       Begin
         TFloatField(Result).FPrecision := Precision;
         If not (Size In [4,8]) Then
           Begin
             Size:=8;
             Result.FSize:=8;
           End;
       End;
     If FOwner <> Nil Then
       Result.FDataSet := FOwner.FDataSet;
     GetMem(Result.FValue,Size);
     Result.FValueLen := Size;
   Except;
     Result.Free;
     Raise;
   End;
End;

Function TFieldDef.GetFieldClass:TFieldClass;
Begin
  Result := FOwner.FDataSet.GetFieldClass(FDataType);
End;


Function TFieldDef.GetPrimaryKey:Boolean;
Var Keys:TStrings;
    t:LongInt;
Begin
     If (Not (FOwner.FDataSet.IsTable)) Then
        DSNError('Cannot perform this action on a query or stored procedure');

     Result:=False;
     If FOwner.FDataSet.Active Then
     Begin
          Keys.Create;
          TTable(FOwner.FDataSet).GetPrimaryKeys(Keys);
          For t:=0 To Keys.Count-1 Do
            If Keys[t]=Name Then
            Begin
                 Keys.Destroy;
                 Result:=True;
                 exit;
            End;
          Keys.Destroy;
     End
     Else Result:=FPrimaryKey;
End;

Procedure TFieldDef.SetPrimaryKey(NewValue:Boolean);
Begin
     If (Not (FOwner.FDataSet.IsTable)) Then
        DSNError('Cannot perform this action on a query or stored procedure');

     FPrimaryKey:=NewValue;
     If FOwner.FDataSet.Active Then //Modify table definition
     Begin
     End;
End;

Function TFieldDef.GetForeignKey:String;
Var Keys:TStrings;
    t:LongInt;
    s:String;
Begin
     If (Not (FOwner.FDataSet.IsTable)) Then
        DSNError('Cannot perform this action on a query or stored procedure');

     If FOwner.FDataSet.Active Then
     Begin
          Keys.Create;
          TTable(FOwner.FDataSet).GetForeignKeys(Keys);
          For t:=0 To Keys.Count-1 Do
          Begin
            s:=Keys[t];
            If Pos('>',s)<>0 Then s[0]:=chr(pos('>',s)-1);
            If s=Name Then
            Begin
                 Keys.Destroy;
                 s:=Keys[t];
                 Delete(s,1,pos('>',s));
                 Result:=s;
                 exit;
            End;
          End;
          Keys.Destroy;
     End
     Else
     Begin
         If FForeignKey<>Nil Then Result:=FForeignKey^
         Else Result:='';
     End;
End;

Procedure TFieldDef.SetForeignKey(Const NewValue:String);
Begin
     If (Not (FOwner.FDataSet.IsTable)) Then
        DSNError('Cannot perform this action on a query or stored procedure');

     AssignStr(FForeignKey,NewValue);
     If FOwner.FDataSet.Active Then //modify table definition
     Begin
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TFieldDefs Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TFieldDefs.Create(DataSet:TDataSet);
Begin
     Inherited Create;

     FDataSet := DataSet;
     FItems.Create;
End;


Destructor TFieldDefs.Destroy;
Begin
  Clear;
  FItems.Destroy;

  Inherited Destroy;
End;


Function TFieldDefs.Rows:LongInt;
Var  FieldDef:TFieldDef;
Begin
     Result := 0;
     If Count = 0 Then Exit;
     FieldDef := Items[0];
     Result := FieldDef.Fields.Count;
End;


Procedure TFieldDefs.Clear;
Var  FieldDef:TFieldDef;
Begin
     While FItems.Count > 0 Do
     Begin
          FieldDef := TFieldDef(FItems[0]);
          FieldDef.Destroy; // auto removing from FItems
     End;
End;


Function TFieldDefs.GetCount:Longint;
Begin
     Result := FItems.Count;
End;


Function TFieldDefs.GetItem(Index:Longint):TFieldDef;
Begin
     Result := FItems[Index];
End;


Function TFieldDefs.Add(Const Name:String; DataType:TFieldType; Size:Longint; Required:Boolean):TFieldDef;
Begin
     //...check valid
     Result.Create(Self, Name, DataType, Size, Required, FItems.Count);
End;

Procedure TFieldDefs.Assign(FieldDefs: TFieldDefs);
Var FieldDef:TFieldDef;
    t:LongInt;
Begin
     Clear;
     For t:=0 To FieldDefs.Count-1 Do
     Begin
          FieldDef:=Items[t];
          Add(FieldDef.Name,FieldDef.DataType,FieldDef.Size,FieldDef.Required);
     End;
End;

Function TFieldDefs.Find(const Name: string): TFieldDef;
Var Index:LongInt;
Begin
     Index:=IndexOf(Name);
     If Index=-1 Then SQLError('Field not found: '+Name)
     Else Result:=Items[Index];
End;

Function TFieldDefs.IndexOf(const Name: string): LongInt;
Var t:LongInt;
Begin
     Result:=-1;
     For t:=0 To Count-1 Do If Items[t].Name=Name Then
     Begin
          Result:=t;
          exit;
     End;
End;

Procedure TFieldDefs.Update;
Begin
  FDataSet.QueryTable;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDataSet Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
   DefaultFieldClasses:Array[TFieldType] Of TFieldClass=
                    (TBlobField,       {ftUnknown}
                     TStringField,     {ftString}
                     TSmallintField,   {ftSmallInt}
                     TIntegerField,    {ftInteger}
                     TBlobField,       {ftWord}
                     TBooleanField,    {ftBoolean}
                     TFloatField,      {ftFloat}
                     TCurrencyField,   {ftCurrency}
                     TBlobField,       {ftBCD}
                     TDateField,       {ftDate}
                     TTimeField,       {ftTime}
                     TDateTimeField,   {ftDateTime}
                     TBlobField,       {ftBytes}
                     TBlobField,       {ftVarBytes}
                     TAutoIncField,    {ftAutoInc}
                     TBlobField,       {ftBlob}
                     TMemoField,       {ftMemo}
                     TGraphicField,    {ftGraphic}
                     TMemoField,       {ftFmtMemo}
                     TBlobField,       {ftTypedBinary}
                     TBlobField        {ftOLE}
                    );


Procedure TDataSet.SetupComponent;
Begin
  Include(ComponentState, csHandleLinks);

  AssignStr(FDSN,'');

  Inherited SetupComponent;

  FFieldDefs.Create(Self);
  FSelect:=TStringList.Create;
  FCurrentRow:=-1;
  FCurrentField:=0;
  fODBC.Create;
End;

Destructor TDataSet.Destroy;
Begin
  FFieldDefs.Destroy;
  FFieldDefs:=Nil;
  AssignStr(FDSN,'');
  FSelect.Destroy;
  FSelect:=Nil;
  fODBC.Destroy;
  Inherited Destroy;
End;


Function TDataSet.GetFieldClass(FieldType:TFieldType):TFieldClass;
Begin
  Result:=DefaultFieldClasses[FieldType];
End;

Procedure TDataSet.DesignerNotification(Var DNS:TDesignerNotifyStruct);
Var  AForm:TForm;
Begin
     AForm := TForm(Owner);
     If AForm <> Nil Then
     Begin
          While (AForm.Designed) And (AForm.Owner <> Nil) Do
          Begin
               AForm := TForm(AForm.Owner);
          End;
     End;
     If AForm <> Nil Then
      If AForm Is TForm Then AForm.DesignerNotification(DNS);
End;


Function TDataSet.Locate(Const KeyFields:String;Const KeyValues:Array Of Const;
                         Options:TLocateOptions):Boolean;
Begin
  Result := False;
  //???
End;


Procedure TDataSet.SetFieldDefs(NewValue:TFieldDefs);
Begin
  FFieldDefs.Assign(NewValue);
End;


Procedure TDataSet.GetStoredProcNames(List:TStrings);
Begin
  List.Clear;
End;


Procedure TDataSet.Open;
Begin
  Active := True;
End;


Procedure TDataSet.Close;
Begin
  Active := False;
End;


Procedure TDataSet.SetActive(NewValue:Boolean);
Begin
  If FActive <> NewValue Then
    Begin
      FActive := NewValue;
      DataChange(deDSNChanged);
    End;
End;


Procedure TDataSet.SetCurrentRow(NewValue:LongInt);
Begin
  MoveBy(NewValue-FCurrentRow);
End;


Procedure TDataSet.SetCurrentField(NewValue:LongInt);
Begin
  If NewValue<0 Then NewValue:=0;
  If NewValue>FieldCount-1 Then NewValue:=FieldCount-1;
  FCurrentField:=NewValue;
End;


Function TDataSet.GetEOF:Boolean;
Begin
  Result := GetResultColRow(0,FCurrentRow+1) = Nil;
End;


Function TDataSet.GetBOF:Boolean;
Begin
  Result := FCurrentRow <= 0;
End;


Function TDataSet.GetMaxRows:LongInt;
Begin
  Result := FMaxRows;
  If RowInserted Then inc(Result);
End;


Procedure TDataSet.Refresh;
Begin
  DataChange(deDSNChanged);
End;


Procedure TDataSet.DataChange(event:TDataChange);
Var I:LongInt;
    Source:TDataSource;
    FLinkList:TList;
Begin
  If FDataChangeLock Then Exit;
  FLinkList:=FreeNotifyList;
  If FLinkList<>Nil Then
    For I:=0 To FLinkList.Count-1 Do
      Begin
        Source:=FLinkList.Items[I];
        If Source Is TDataSource Then
          Begin
            Source.DataChange(event);
            If Source.OnDataChange<>Nil Then
              Source.OnDataChange(Source,event);
          End;
      End;
End;


Procedure TDataSet.First;
Begin
  SetCurrentRow(0);
End;


Procedure TDataSet.Last;
Begin
  SetCurrentRow(MaxRows-1);
End;


Procedure TDataSet.Next;
Begin
  SetCurrentRow(FCurrentRow+1);
End;


Procedure TDataSet.Prior;
Begin
  SetCurrentRow(FCurrentRow-1);
End;


Procedure TDataSet.MoveBy(Distance:LongInt);
Var  Field:TField;
     FieldDef:TFieldDef;
Begin
     If Distance = 0 Then Exit;
     If FFieldDefs.Count = 0 Then exit;

     If FRowIsInserted Then CommitInsert(True);

     FCurrentRow := FCurrentRow + Distance;
     If FCurrentRow < 0 Then FCurrentRow := 0;
     If FCurrentRow >= MaxRows Then FCurrentRow := MaxRows-1;

     Field := GetResultColRow(0,FCurrentRow);

     FieldDef := FFieldDefs[0];

     If FieldDef <> Nil Then
     Begin
          If FCurrentRow > FieldDef.Fields.Count-1
          Then FCurrentRow := FieldDef.Fields.Count-1;
          If FCurrentRow < 0 Then FCurrentRow := 0;
     End;

     DataChange(dePositionChanged);
End;


Function TDataSet.WriteSCUResource(Stream:TResourceStream):Boolean;
Var S:String;
    dll:String;
    P,p1:Pointer;
    len:LongInt;
//    dbType:TDBTypes;
    dbOrd:LongInt;
    Advanced,UID:String;

Begin
  S:=''; // Server;
  len:=Length(S)+1+Length(dll)+1+4;
  GetMem(P,len);
  p1:=P;
  Move(S,p1^,Length(S)+1);
  Inc(p1,Length(S)+1);
  Move(dll,p1^,Length(dll)+1);
  inc(p1,length(dll)+1);
  Move(dbOrd,p1^,4);
  Result:=Stream.NewResourceEntry(rnDBServer,P^,len);
  FreeMem(P,len);
  If Not Result Then Exit;
  S:=DSN;
  len:=Length(S)+1+Length(Advanced)+1+length(UID)+1;
  GetMem(P,len);
  p1:=P;
  Move(S,p1^,Length(S)+1);
  Inc(p1,Length(S)+1);
  Move(Advanced,p1^,Length(Advanced)+1);
  Inc(p1,Length(Advanced)+1);
  Move(UID,p1^,Length(UID)+1);
  Result:=Stream.NewResourceEntry(rnDBDatabase,S,Length(S)+1);
  FreeMem(P,len);
End;


Procedure TDataSet.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   S,dll:String;
   B:^Byte;
   Advanced,UID:String;

Begin
  If ResName = rnDBServer Then
    Begin
      B:=@Data;
      Move(B^,S,B^+1);
      Inc(B,B^+1);
      Move(B^,dll,B^+1);
      If DataLen>length(S)+1+length(dll)+1 Then //Sibyl FP3
        Begin
          inc(B,length(dll)+1);
        End;
    End;

  If ResName = rnDBDatabase Then
    Begin
      Advanced:='';
      UID:='';
      B:=@Data;
      Move(B^,S,B^+1);
      Inc(B,B^+1);
      If DataLen>length(S)+1 Then //Sibyl FP3
        Begin
          Move(B^,Advanced,B^+1);
          Inc(B,B^+1);
          Move(B^,UID,B^+1);
        End;
      DSN:=S;
    End;
End;

Function TDataSet.GetDSNName:String;
Begin
  Result:=FDSN^;
End;


Procedure TDataSet.SetDSNName(Const NewValue:String);

Var DNS:TDesignerNotifyStruct;

Begin
  If GetDSNName=NewValue Then Exit;

  If FOpened Then
    If GetDSNName<>'' Then
      Begin
        ErrorBox(LoadNLSStr(SCannotPerformDBAction));
        Exit;
      End;

  AssignStr(FDSN,NewValue);
  fODBC.DSN:=NewValue;

//     GetDBServerFromDBAlias(NewValue,Alias,Advanced,UID);
//   If Alias<>'' Then If Alias<>Server Then
//     Begin
//       AssignStr(FServer, Alias);
//          fODBC.AliasName:=Alias;
//     End;
//     If ComponentState*[csReading]=[]
//       Then fODBC.UID:=UID
//       Else If fODBC.UID='' Then fODBC.UID:=UID;
//     GetDBServerFromAlias(fODBC.AliasName,DllName,fODBC.DBType);

  If Self Is TTable Then If ComponentState*[csReading]=[] Then
    Begin
      TTable(Self).TableName:='';
      TTable(Self).UserId:='';
      TTable(Self).Password:='';
    End;

  DNS.Sender := Self;
  DNS.Code := dncPropertyUpdate;
  DNS.return := 0;
  DesignerNotification(DNS);
End;

Function TDataSet.GetFieldCount:LongInt;
Begin
  Result:=FFieldDefs.Count;
End;


Function TDataSet.GetFieldName(Index:LongInt):String;
Var  FieldDef:TFieldDef;
Begin
  Result:='';
  If ((Index<0)Or(Index>FieldCount-1)) Then Exit;
  FieldDef:=FFieldDefs[Index];
  Result:=FieldDef.Name;
End;


Function TDataSet.GetFieldType(Index:LongInt):TFieldType;
Var  FieldDef:TFieldDef;
Begin
  Result:=ftUnknown;
  If ((Index<0)Or(Index>FieldCount-1)) Then Exit;
  FieldDef:=FFieldDefs[Index];
  Result:=FieldDef.DataType;
End;


Function TDataSet.GetFieldFromColumnName(ColumnName:String):TField;
Var Index:LongInt;
    T:LongInt;
    FieldDef:TFieldDef;
    S:String;
Begin
     Result:=Nil;
     Index:=-1;
     UpcaseStr(ColumnName);
     For T:=0 To FFieldDefs.Count-1 Do
     Begin
          FieldDef:=FFieldDefs[T];
          S:=FieldDef.Name;
          UpcaseStr(S);
          If S=ColumnName Then
          Begin
               Index:=T;
               break;
          End;
     End;

     If Index<>-1 Then Result:=Fields[Index];
End;


Procedure TDataSet.CheckRequiredFields;
Var  Field:TField;
     i:Longint;
Begin
  For i := 0 To FieldCount-1 Do
    Begin
      Field := GetResultColRow(i,FCurrentRow);
      If Field<>Nil Then
        If Field.Required And Field.IsNull Then
          Begin
            //Field.FocusControl;
            ErrorBox('Field '+ Field.FieldName +' is required');
            DSNError('Field '+ Field.FieldName +' is required');
          End;
    End;
End;


Function TDataSet.GetField(Index:LongInt):TField;
Begin
  Result:=Nil;
  If ((Index<0)Or(Index>FieldCount-1)Or(FCurrentRow<0)) Then Exit;
  Result:=GetResultColRow(Index,FCurrentRow);
End;


Function TDataSet.GetResultColRow(Col,Row:LongInt):TField;
Var  FieldDef:TFieldDef;
Begin
  Result := Nil;
  If Not FOpened Then Exit;

  If Row < 0 Then Exit;  //Row does Not exist
  If Row >= GetMaxRows Then Exit;  //Row does Not exist
  If (Col < 0) Or (Col >= FieldDefs.Count) Then Exit;  {Column does Not exist}

  FieldDef := FieldDefs[Col];
  If Row <= FieldDef.Fields.Count-1
    Then Result := FieldDef.Fields.Items[Row];
End;


Procedure TDataSet.AppendRecord(Const values:Array Of Const);
Begin
  InsertRecord(values);
End;


Procedure TDataSet.SetFields(Const values:Array Of Const);
Var T:LongInt;
    rec:TVarRec;
    field:TField;
Begin
  Try
    FDataChangeLock:=True;
    For T:=0 To High(values) Do
      Begin
        If T>FieldCount-1 Then Exit;
        Field:=Fields[T];
        If Field=Nil Then continue;
        rec:=TVarRec(values[T]);
        Case rec.VType Of
          vtInteger:field.AsInteger:=rec.VInteger;
          vtBoolean:field.AsBoolean:=rec.VBoolean;
          vtChar:field.AsString:=rec.VChar;
          vtExtended:field.AsFloat:=rec.VExtended^;
          vtString:field.AsString:=rec.VString^;
          vtPointer:;
          vtPChar:field.AsString:=rec.VPChar^;
          vtAnsiString:field.AsString:=AnsiString(rec.VAnsiString);
        End; {Case}
      End;
  Finally
    FDataChangeLock:=False;
    Post;
  End;
End;


Procedure TDataSet.InsertRecord(Const values:Array Of Const);
Begin
  Try
    FDataChangeLock:=True;
    Insert;
  Finally
    FDataChangeLock:=False;
  End;
  SetFields(values);
End;


Function TDataSet.FieldByName(Const FieldName:String):TField;
Begin
  Result:=FindField(FieldName);
  If Result=Nil Then DSNError('Field '+FieldName+' not found');
End;


Function TDataSet.FindFirst:Boolean;
Begin
  Result:=BOF;
End;


Function TDataSet.FindLast:Boolean;
Begin
  Result:=EOF;
End;


Function TDataSet.FindNext:Boolean;
Begin
  Result:=not EOF;
End;


Function TDataSet.FindPrior:Boolean;
Begin
  Result:=not BOF;
End;


Function ExtractFieldName(Const Fields:String;Var Pos:LongInt):String;
Var  t:LongInt;
Begin
  t:=Pos;
  While (t<=Length(Fields))And(Fields[t]<>';') Do Inc(t);
  Result:=Copy(Fields,Pos,t-Pos);
  If (t<=Length(Fields))And(Fields[t]=';') Then Inc(t);
  Pos:=t;
End;


Procedure TDataSet.GetFieldList(List:TList; const FieldNames: string);
Var  t:LongInt;
Begin
  t:=1;
  While t<=Length(FieldNames) Do
    List.Add(FieldByName(ExtractFieldName(FieldNames,t)));
End;


Function TDataSet.FindField(Const FieldName:String):TField;
Var T:LongInt;
    S,s1:String;
Begin
  Result:=Nil;
  S:=FieldName;
  UpcaseStr(S);
  For T:=0 To FieldCount-1 Do
    Begin
      s1:=FieldNames[T];
      UpcaseStr(s1);
      If S=s1 Then
        Begin
          Result:=Fields[T];
          Exit;
        End;
    End;
End;

Procedure TDataSet.DoOpen;
Begin
  FOpened := True;
End;


Procedure TDataSet.DoClose;
Begin
  If FRowIsInserted Then CommitInsert(True);
  FMaxRows:=0;
  FCurrentRow := -1;
  FOpened := False;
End;


Procedure TDataSet.RefreshTable;
Begin
End;


Procedure TDataSet.GetDataSources(List:TStrings);
Begin
     List.Clear;
End;


Procedure TDataSet.GetFieldNames(List:TStrings);
Var T:LongInt;
Begin
  List.Clear;
  If FieldCount=0 Then
    Begin
      If ((Designed)And(Not FOpened))
        Then
          Begin
            FActive:=True;
            DoOpen;
            If Not FOpened Then FActive:=False
            Else RefreshTable;
          End
        Else RefreshTable;
    End;

  For T:=0 To FieldCount-1 Do
    List.Add(FieldNames[T]);
End;


Procedure TDataSet.Delete;
Begin
  If Not FOpened Then Exit;
  If (CurrentRow < 0) Or (CurrentRow >= RecordCount) Then exit;
  Try
    If FBeforeDelete <> Nil Then FBeforeDelete(Self);
    If FRowIsInserted
      Then CommitInsert(False)
      Else DoDelete;
    DataChange(deDSNChanged);
    If FAfterDelete <> Nil Then FAfterDelete(Self);
  Except
    Raise;
  End;
End;


Procedure TDataSet.DoDelete;
Begin
  RemoveCurrentFields;
End;


Procedure TDataSet.Append;
Begin
  Insert;
End;


Procedure TDataSet.Insert;
Begin
  If Not FOpened Then Exit;
  Try
    If FBeforeInsert <> Nil Then FBeforeInsert(Self);
    If FRowIsInserted Then CommitInsert(True);
    DoInsert;
    DataChange(deDSNChanged);
    If FAfterInsert <> Nil Then FAfterInsert(Self);
  Except
    Raise;
  End;
End;


Procedure TDataSet.DoInsert;
Begin
  If FCurrentRow < 0 Then FCurrentRow := 0; //empty table
  InsertCurrentFields;
  FRowIsInserted := True;
End;


Procedure TDataSet.InsertCurrentFields;
Var  Col,Row:LongInt;
     FieldDef:TFieldDef;
     Field:TField;
Begin
     For Col := 0 To FFieldDefs.Count-1 Do
     Begin
          FieldDef := FFieldDefs[Col];
          Field := FieldDef.CreateField(Nil);
          //Field.Clear;
          If Field.FValue<>Nil Then FreeMem(Field.FValue,Field.FValueLen);
          Field.FValue:=Nil;
          Field.FValueLen:=0;
          Field.FRow := FCurrentRow;
          Field.FCol := Col;
          FieldDef.Fields.Insert(FCurrentRow,Field);

          For Row := FCurrentRow+1 To FieldDef.Fields.Count-1 Do
          Begin
               Field := FieldDef.Fields[Row];
               If Field <> Nil Then Inc(Field.FRow);
          End;
     End;
End;


Const Months:Array[1..12] Of String[4]=('Jan','Feb','Mar','Apr','May','Jun','Jul',
                                        'Aug','Sep','Oct','Nov','Dec');

Function Field2String(field:TField):String;

Var dt:TDateTime;
    Year,Month,Day,Hour,Min,Sec:Word;

Begin
     If field.IsNull Then
     Begin
          Result:='NULL';
          Exit;
     End;

     Case field.DataType Of
        ftDate:
        Begin
             dt:=field.GetAsDateTime;
             DecodeDate(dt,Year,Month,Day);
             Result:=tostr(Year)+'-'+tostr(Month)+'-'+tostr(Day);
        End;
        ftTime:
        Begin
             dt:=field.GetAsDateTime;
             RoundDecodeTime(dt,Hour,Min,Sec);
             Result:=tostr(Hour)+'.'+tostr(Min)+'.'+tostr(Sec);
        End;
        ftDateTime:
        Begin
             dt:=field.GetAsDateTime;
             DecodeDate(dt,Year,Month,Day);
             RoundDecodeTime(dt,Hour,Min,Sec);
             Result:=tostr(Year)+'-'+tostr(Month)+'-'+tostr(Day);
             Result:=Result+'-'+tostr(Hour)+'.'+tostr(Min)+'.';
             Result:=Result+tostr(Sec)+'.00';
        End;
        ftMemo:
        Begin
             Result:=PChar(Field.FValue)^;
        End;
        ftFloat:
        Begin
             Result:=field.AsString;
             //eliminate decimal separator
             If pos(',',Result)<>0 Then Result[pos(',',Result)]:='.';

        End;
        Else Result:=field.AsString;
     End; {Case}

     If Not (field.DataType In [ftSmallInt,ftInteger,ftWord,ftFloat,ftCurrency]) Then
       Result:=#39+Result+#39;
End;


Procedure TDataSet.CommitInsert(Commit:Boolean);
Begin
End;


Procedure TDataSet.RemoveCurrentFields;
Var  Col,Row:LongInt;
     Field:TField;
     FieldDef:TFieldDef;
Begin
     FieldDef := Nil;

     For Col := 0 To FFieldDefs.Count-1 Do
     Begin
          FieldDef := FFieldDefs[Col];
          Field := FieldDef.Fields[FCurrentRow];
          If Field <> Nil Then
          Begin
               FieldDef.Fields.Remove(Field);
               Field.Destroy;
          End;

          For Row := FCurrentRow To FieldDef.Fields.Count-1 Do
          Begin
               Field := FieldDef.Fields[Row];
               If Field <> Nil Then Dec(Field.FRow);
          End;
     End;

     If FieldDef <> Nil Then
       If FCurrentRow >= FieldDef.Fields.Count
       Then FCurrentRow := FieldDef.Fields.Count-1;
End;


Function TDataSet.UpdateFieldSelect(Field:TField):Boolean;
Begin
  Result:=False;
End;


Procedure TDataSet.UpdateField(field:TField;OldValue:Pointer;OldValueLen:LongInt);
Begin
     If Not FOpened Then Exit;
     If FSelect.Count=0 Then Exit;  //Nothing To Select
     Try
        If Not UpdateFieldSelect(field) Then
        Begin
             FreeMem(field.FValue,field.FValueLen);
             field.FValue:=OldValue;
             field.FValueLen:=OldValueLen;
        End
        Else FreeMem(OldValue,OldValueLen);
     Except
        FreeMem(field.FValue,field.FValueLen);
        field.FValue:=OldValue;
        field.FValueLen:=OldValueLen;
        Raise;
     End;
End;


Procedure TDataSet.Post;
Begin
  If Not FOpened Then Exit;
  If (CurrentRow < 0) Or (CurrentRow >= RecordCount) Then exit;
  Try
    CheckRequiredFields;
    If FBeforePost <> Nil Then FBeforePost(Self);
    If FRowIsInserted
      Then CommitInsert(True)
      Else DoPost;
    DataChange(deDSNChanged);
    If FAfterPost <> Nil Then FAfterPost(Self);
  Except
    Raise;
  End;
End;

Procedure TDataSet.DoPost;
Begin
End;

Procedure TDataSet.Cancel;
Begin
     If Not FOpened Then Exit;
     If (CurrentRow < 0) Or (CurrentRow >= RecordCount) Then exit;

     Try
        If FBeforeCancel <> Nil Then FBeforeCancel(Self);

        If FRowIsInserted Then CommitInsert(False)
        Else DoCancel;

        DataChange(deDSNChanged);

        If FAfterCancel <> Nil Then FAfterCancel(Self);
     Except
        Raise;
     End;
End;


Procedure TDataSet.DoCancel;
Begin
End;


Procedure TDataSet.QueryTable;
Begin
End;


Procedure TDataSet.Loaded;
Begin
  Inherited Loaded;
  If FRefreshOnLoad Then Active:=True;
End;


Procedure TDataSet.CheckInactive;
Begin
  If Active Then
    Begin
      //Close;
      DSNError('Cannot perform this operation on active dataset !');
    End;
End;

Function TDataSet.IsTable:Boolean;
Begin
     Result := (Self Is TTable) And (Not (Self Is TQuery)) And (Not (Self Is TStoredProc));
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TTable Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TTable.GetPrimaryKeys(List:TStrings);
Begin
  GetKeys(List,True);
End;

Function MapODBCType(colType:TFieldType):SQLSMALLINT;
Begin
  Case colType Of
    ftString:Result:=SQL_VARCHAR;
    ftCurrency:Result:=SQL_NUMERIC;
    ftInteger:Result:=SQL_INTEGER;
    ftSmallInt:Result:=SQL_SMALLINT;
    ftFloat:Result:=SQL_DOUBLE;
    ftDate:Result:=SQL_DATE;
    ftTime:Result:=SQL_TIME;
    ftDateTime:Result:=SQL_TIMESTAMP;
    ftMemo:Result:=SQL_LONGVARCHAR;
    ftBlob:Result:=SQL_VARBINARY;
    ftGraphic:Result:=SQL_VARGRAPHIC;
    Else Result:=SQL_BLOB;
  End; {Case}
End;

Function TTable.DataType2Name(DataType:TFieldType):String;
Var List:TStringList;
    t:LongInt;
Begin
    Result:='';
    If FDataTypes=Nil Then
      Begin
        List.Create;
        GetDataTypes(List);
        List.Destroy;
      End;

    Result:='';
    If FDataTypes=Nil Then exit;
    For t:=0 To FDataTypes.Count-1 Do
      If TFieldType(FDataTypes.Objects[t])=DataType Then
        Begin
          Result:=FDataTypes[t];
          exit;
        End;
End;

Function TTable.GetIndexDefs:TIndexDefs;
Begin
     If ((FIndexDefs=Nil)Or(FIndexDefs.Count=0)) Then UpdateIndexDefs;
     Result:=FIndexDefs;
End;

Procedure UpdateIndexFieldMap(Table:TTable);
Var t,Index:LongInt;
    IndexDef:TIndexDef;
    s,s1:String;
Begin
     If Table.FIndexFieldMap<>Nil Then Table.FIndexFieldMap.Clear
     Else Table.FIndexFieldMap.Create;

     For t:=0 To Table.IndexDefs.Count-1 Do
     Begin
          IndexDef:=Table.IndexDefs[t];

          s:=IndexDef.Fields;
          While pos(';',s)<>0 Do
          Begin
               s1:=Copy(s,1,pos(';',s)-1);
               System.Delete(s,1,pos(';',s));

               Index:=Table.FieldDefs.IndexOf(s1);
               If Index>=0 Then If Table.FIndexFieldMap.IndexOf(Pointer(Index))<0 Then
                 Table.FIndexFieldMap.Add(Pointer(Index));
          End;
          If s<>'' Then
          Begin
               Index:=Table.FieldDefs.IndexOf(s);
               If Index>=0 Then If Table.FIndexFieldMap.IndexOf(Pointer(Index))<0 Then
                 Table.FIndexFieldMap.Add(Pointer(Index));
          End;
     End;
End;

Function TTable.GetIndexFieldCount:LongInt;
Begin
     If ((FIndexFieldMap=Nil)Or(FIndexFieldMap.Count=0)) Then UpdateIndexFieldMap(Self);
     Result:=FIndexFieldMap.Count
End;

Function TTable.GetIndexField(Index:LongInt):TField;
Begin
  If ((FIndexFieldMap=Nil)Or(FIndexFieldMap.Count=0))
    Then UpdateIndexFieldMap(Self);
  Result:=Fields[LongInt(FIndexFieldMap[Index])]
End;

Procedure TTable.SetIndexField(Index:LongInt;NewValue:TField);
Begin
  GetIndexField(Index).Assign(NewValue);
End;

Procedure TTable.AddIndex(Const Name:String;Fields:String;Options:TIndexOptions);

Var OldActive,OldOpen:Boolean;
    S1,s2   : String;
    Stmt    : tcODBCStmt;

Begin
  If (Not IsTable) Then SQLError('Illegal operation');

  OldActive:=FActive;
  OldOpen:=FOpened;
  If Not FOpened Then
    Begin
      FActive:=True;
      DoOpen;
      If Not FOpened Then Active:=False;
    End;

  s1:='CREATE';
  If Options*[ixUnique]<>[] Then s1:=s1+' UNIQUE';
  s1:=s1+' INDEX '+Name+' ON '+TableName+'(';
  While pos(';',Fields)<>0 Do
    Begin
      s2:=Copy(Fields,1,pos(';',Fields)-1);
      System.Delete(Fields,1,pos(';',Fields));
      If s1[length(s1)]<>'('
        Then s1:=s1+',';
      s1:=s1+s2;
      If Options*[ixDescending]<>[]
        Then s1:=s1+' DESC'
        Else s1:=s1+' ASC';
    End;
  If s1[length(s1)]<>'('
    Then s1:=s1+',';
     s1:=s1+Fields;
  If Options*[ixDescending]<>[]
    Then s1:=s1+' DESC'
    Else s1:=s1+' ASC';
  s1:=s1+')';

  If FOpened Then
    Begin
      EnterSQLProcessing;
      Stmt.Create(fODBC);
      If Stmt.SQLExecDirect(s1)<>SQL_SUCCESS Then
        Begin
          S1:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S1);
        End;
      Stmt.Destroy;
      LeaveSQLProcessing;
    End;

  DoPost;
  If not OldOpen Then DoClose;
  FActive:=OldActive;
  UpdateIndexDefs;
End;

Procedure TTable.DeleteIndex(Const Name: string);
Var OldActive,OldOpen:Boolean;
    S1:String;
    Stmt : tcODBCStmt;

Begin
  If (Not IsTable) Then SQLError('Illegal operation');

  OldActive:=FActive;
  OldOpen:=FOpened;
  If Not FOpened Then
    Begin
      FActive:=True;
      DoOpen;
      If Not FOpened Then Active:=False;
    End;

  If FOpened Then
    Begin
      EnterSQLProcessing;
      Stmt.Create(fODBC);
      s1:='DROP INDEX '+Name;
      If Stmt.SQLExecDirect(s1)<>SQL_SUCCESS Then
        Begin
          S1:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S1);
        End;

      Stmt.Destroy;
      LeaveSQLProcessing;
    End;

  DoPost;
  If not OldOpen Then DoClose;
  FActive:=OldActive;
  UpdateIndexDefs;
End;


Procedure TTable.CreateTable;
Var s:AnsiString;
    s1:String;
    Stmt : tcODBCStmt;
    t:LongInt;
    FieldDef:TFieldDef;
    OldActive:Boolean;
Begin
  If (Not IsTable) Then SQLError('Illegal operation');

  CheckInactive;

  s:='CREATE TABLE '+TableName+'(';

  For t:=0 To FieldDefs.Count-1 Do
    Begin
      FieldDef:=FieldDefs[t];
      s1:=FieldDef.TypeName;
      s:=s+FieldDef.Name+' '+s1;
      If ((FieldDef.DataType=ftString)Or(s1='LONG RAW')) Then
        s:=s+'('+tostr(FieldDef.Size)+')';
      If FieldDef.Required then s:=s+' NOT NULL';
      If FieldDef.PrimaryKey Then s:=s+' PRIMARY KEY';
      If FieldDef.ForeignKey<>'' Then s:=s+' REFERENCES '+FieldDef.ForeignKey;
      If t<>FieldDefs.Count-1 Then s:=s+',';
    End;

  s:=s+')';

  OldActive:=FActive;
  If Not FOpened Then
    Begin
      FActive:=True;
      DoOpen;
      If Not FOpened Then Active:=False;
    End;

  If FOpened Then
    Begin
      EnterSQLProcessing;
      Stmt.Create(fODBC);
      If Stmt.SQLExecDirect(PChar(s)^)<>SQL_SUCCESS Then
        Begin
          S1:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S1);
        End;
      Stmt.Destroy;
      LeaveSQLProcessing;
    End;
  DoClose;
  FActive:=OldActive;
End;

Procedure TTable.DeleteTable;
Var s1:String;
    Stmt : tcODBCStmt;

Begin
  If (Not IsTable) Then SQLError('Illegal operation');
  If Active Then DoClose;

  If Not FOpened Then
    Begin
      FActive:=True;
      DoOpen;
      If Not FOpened Then Active:=False;
    End;
  If FOpened Then
    Begin
      EnterSQLProcessing;
      Stmt.Create(fODBC);
      If Stmt.SQLExecDirect('DROP TABLE '+TableName)<>SQL_SUCCESS Then
        Begin
          S1:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S1);
        End;
      Stmt.Destroy;
      LeaveSQLProcessing;
    End;

  DoPost;
  DoClose;
End;

Procedure TTable.EmptyTable;
Var OldActive,OldOpen:Boolean;
    S1:String;
    Stmt : tcODBCStmt;

Begin
  If (Not IsTable) Then SQLError('Illegal operation');

  OldActive:=FActive;
  OldOpen:=FOpened;
  If Not FOpened Then
    Begin
      FActive:=True;
      DoOpen;
      If Not FOpened Then Active:=False;
    End;

  If FOpened Then
    Begin
      EnterSQLProcessing;
      Stmt.Create(fODBC);
      If Stmt.SQLExecDirect('DELETE * FROM '+TableName)<>SQL_SUCCESS Then
        Begin
          S1:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S1);
        End;
      Stmt.Destroy;
      LeaveSQLProcessing;
    End;

  DoPost;
  If not OldOpen Then DoClose;
  FActive:=OldActive;
End;

Function TTable.FindKey(Const KeyValues:Array of Const):Boolean;
Begin
  If (Not IsTable) Then SQLError('Illegal operation');
  Result:=False;
  //???
End;

Procedure TTable.GetIndexNames(List: TStrings);
Var t:LongInt;
Begin
  List.Clear;
  For t:=0 To IndexDefs.Count-1 Do
    List.Add(IndexDefs[t].Name);
End;

Procedure TTable.RenameTable(NewTableName:String);
Var OldActive,OldOpen:Boolean;
    S1:String;
    Stmt : tcODBCStmt;
    tn:String;

Begin
  If (Not IsTable) Then SQLError('Illegal operation');
  OldActive:=FActive;
  OldOpen:=FOpened;
  If Not FOpened Then
    Begin
      FActive:=True;
      DoOpen;
      If Not FOpened Then Active:=False;
    End;
  If FOpened Then
    Begin
      EnterSQLProcessing;
      Stmt.Create(fODBC);
      tn:=TableName;
      s1:='ALTER TABLE '+TableName+' RENAME '+NewTableName;
      If Stmt.SQLExecDirect(s1)<>SQL_SUCCESS Then
        Begin
          S1:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S1);
        End;
      Stmt.Destroy;
      LeaveSQLProcessing;
    End;

  DoPost;
  DoClose;
  TableName:=NewTableName;
  FActive:=OldActive;
End;

Procedure TTable.GetNames(List:TStrings;Const Name:String);
Var Stmt : tcODBCStmt;
    cols:SQLSMALLINT;
    I:LongInt;
    C:Array[0..4] Of cstring;
    OutLen:Array[0..4] Of SQLINTEGER;
    rc:SQLRETURN;
    S,S1:String;
    OldActive:Boolean;
    OldOpen:Boolean;
    Index:LongInt;

Begin
  List.Clear;
  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked)) Then
    Begin
      OldActive:=FActive;
      OldOpen:=FOpened;
      If Not FOpened Then
        Begin
          FActive:=True;
          DoOpen;
          If Not FOpened Then Active:=False;
        End;

      If FOpened Then
        Begin
          EnterSQLProcessing;
          Stmt.Create(fODBC);
          If Stmt.SQLTables(Name)=SQL_SUCCESS Then
            Begin
              Stmt.SQLNumResultCols(cols);
              If cols>5 Then cols:=5;
                For I := 0 To cols-1 Do
                  Stmt.SQLBindCol(I + 1, SQL_C_CHAR, C[I], 255, OutLen[I]);
                rc:=Stmt.SQLFetch;
                While ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Do
                  Begin
                    If Cols=1
                      Then Index:=0 //msql
                      Else Index:=2;
                    If OutLen[Index]<>SQL_NULL_DATA Then
                      Begin
                        Move(C[Index],S[1],OutLen[Index]);
                        S[0]:=Chr(OutLen[Index]);
                        If S[length(s)]=#0 Then
                          If length(S)>0 Then dec(S[0]);
                          If Cols>1 Then //get qualifier
                            If OutLen[0]<>SQL_NULL_DATA Then
                              Begin
                                Move(C[0],S1[1],OutLen[0]);
                                S1[0]:=Chr(OutLen[0]);
                                If S1[length(S1)]=#0 Then
                                If length(S1)>0 Then dec(S1[0]);
                                If S1<>'' Then S:=S1+'.'+S;
                              End;
                          List.Add(S);
                      End;
                    rc:=Stmt.SQLFetch;
                  End;
            End;

          Stmt.Destroy;
          LeaveSQLProcessing;
        End;

      If Not OldOpen Then DoClose;
      FActive:=OldActive;
    End;
End;

Procedure TTable.GetViewNames(List:TStrings);
Begin
  GetNames(List,'VIEW');
End;

Procedure TTable.GetSystemTableNames(List:TStrings);
Begin
  GetNames(List,'SYSTEM TABLE');
End;

Procedure TTable.GetSynonymNames(List:TStrings);
Begin
  GetNames(List,'SYNONYM');
End;

Function MapSQLType(colType:SQLSMALLINT):TFieldType;
Begin
  Case colType Of
    SQL_CHAR:          Result:=ftString;
    SQL_NUMERIC:       Result:=ftFloat;
    SQL_DECIMAL:       Result:=ftFloat;
    SQL_INTEGER:       Result:=ftInteger;
    SQL_SMALLINT:      Result:=ftSmallInt;
    SQL_FLOAT:         Result:=ftFloat;
    SQL_REAL:          Result:=ftFloat;
    SQL_DOUBLE:        Result:=ftFloat;
    SQL_DATE:          Result:=ftDate;
    SQL_TIME:          Result:=ftTime;
    SQL_TIMESTAMP:     Result:=ftDateTime;
    SQL_VARCHAR:       Result:=ftString;
    SQL_LONGVARCHAR:   Result:=ftMemo;
    SQL_BINARY:        Result:=ftBlob;
    SQL_VARBINARY:     Result:=ftBlob;
    SQL_LONGVARBINARY: Result:=ftBlob;
   {SQL_BIGINT       =-5;  /* Not supported */
    SQL_TINYINT      =-6;  /* Not supported */}
    SQL_BIT:           Result:=ftBoolean;
    SQL_GRAPHIC:       Result:=ftGraphic;
    SQL_VARGRAPHIC:    Result:=ftGraphic;
    SQL_LONGVARGRAPHIC:Result:=ftGraphic;
    SQL_BLOB:          Result:=ftBlob;
    SQL_CLOB:          Result:=ftBlob;
    SQL_DBCLOB:        Result:=ftBlob;
    Else               Result:=ftUnknown;
  End; {Case}
End;

Procedure TTable.GetDataTypes(List:TStrings);
Var OldActive:Boolean;
    OldOpen:Boolean;

  Procedure GetType(Typ:SQLSMALLINT);
  Var cols:SQLSMALLINT;
      C:cstring;
      OutLen:SQLINTEGER;
      rc:SQLRETURN;
      S    : String;
      Stmt : tcODBCStmt;

  Begin
    EnterSQLProcessing;
    Stmt.Create(fODBC);
    If Stmt.SQLGetTypeInfo(Typ)=SQL_SUCCESS Then
      Begin
        Stmt.SQLNumResultCols(cols);
        If cols=0 Then exit;
        Stmt.SQLBindCol(1, SQL_C_CHAR, C, 255, OutLen);
        rc:=Stmt.SQLFetch;
        If ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Then
          Begin
            If OutLen<>SQL_NULL_DATA Then
              Begin
                Move(C,S[1],OutLen);
                S[0]:=Chr(OutLen);
                If S[length(s)]=#0 Then
                If length(s)>0 Then dec(S[0]);
                UpcaseStr(S);
                If List.IndexOf(S)<0 Then List.AddObject(S,Pointer(MapSQLType(Typ)));
              End;
          End;
      End;
    Stmt.Destroy;
    LeaveSQLProcessing;
  End;

  Procedure ListAddObject(Const s:String;DataType:TFieldType);
  Begin
    List.AddObject(s,Pointer(DataType));
  End;

Begin
  List.Clear;
  If FDataTypes<>Nil Then
    Begin
      List.Assign(FDataTypes);
      exit;
    End;

  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked)) Then
    Begin
      OldActive:=FActive;
      OldOpen:=FOpened;
      If Not FOpened Then
        Begin
          FActive:=True;
          DoOpen;
          If Not FOpened Then Active:=False;
        End;
      If FOpened Then
        Begin
          GetType(SQL_BIGINT);
          GetType(SQL_BINARY);
          GetType(SQL_BIT);
          GetType(SQL_CHAR);
          GetType(SQL_DATE);
          GetType(SQL_DECIMAL);
          GetType(SQL_DOUBLE);
          GetType(SQL_FLOAT);
          GetType(SQL_INTEGER);
          GetType(SQL_LONGVARBINARY);
          GetType(SQL_LONGVARCHAR);
          GetType(SQL_NUMERIC);
          GetType(SQL_REAL);
          GetType(SQL_SMALLINT);
          GetType(SQL_TIME);
          GetType(SQL_TIMESTAMP);
          GetType(SQL_TINYINT);
          GetType(SQL_VARBINARY);
          GetType(SQL_VARCHAR);
        End;

      If Not OldOpen Then DoClose;
      FActive:=OldActive;

      If FDataTypes=Nil Then If List.Count>0 Then
        Begin
          FDataTypes.Create;
          FDataTypes.Assign(List);
        End;
    End;
End;


Procedure TTable.GetForeignKeys(List:TStrings);
Begin
  GetKeys(List,False);
End;


Procedure TTable.GetTableNames(List:TStrings);
Begin
  GetNames(List,'TABLE');
End;


Procedure TTable.SetTableLock(LockType:TLockType;Lock:Boolean);
Var C:cstring;
    Stmt : tcODBCStmt;
    S:String;

Begin
  If Lock
    Then
      Begin
        C:='LOCK TABLE '+TableName+' IN ';
        If LockType=ltReadLock
          Then C:=C+'EXCLUSIVE'
          Else C:=C+'SHARE';
        C:=C+' MODE';
      End
    Else C:='ROLLBACK';

  EnterSQLProcessing;
  Stmt.Create(fODBC);
  If Stmt.SQLExecDirect(C)<>SQL_SUCCESS Then
    Begin
      S:=fODBC.SQLErrorText(Stmt.HStmt);
      SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S);
    End;
  Stmt.Destroy;
  LeaveSQLProcessing;
End;

Procedure TTable.LockTable(LockType:TLockType);
Begin
  SetTableLock(LockType,True);
End;

Procedure TTable.UnlockTable(LockType:TLockType);
Begin
  SetTableLock(LockType,False);
End;

Procedure TTable.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  S:String;
Begin
 If ResName = rnDBTable
   Then
     Begin
       Move(Data,S,DataLen);
       TableName:=S;
     End
   Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Function TTable.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  S:String;
Begin
  Result := False;
  If Inherited WriteSCUResource(Stream) Then
    Begin
      S:=TableName;
      Result:=Stream.NewResourceEntry(rnDBTable,S,Length(S)+1);
    End;
End;

Procedure TTable.SetupComponent;
Begin
  fTableName:='';
  AssignStr(FMasterFields,'');
  Inherited SetupComponent;
End;


Procedure TTable.SetActive(NewValue:Boolean);
Begin
  If FActive = NewValue Then exit;
  Inherited SetActive(NewValue);
  If FActive
    Then
      Begin
        RefreshTable;
        FActive := FOpened;
      End
    Else DoClose;
End;

Procedure TTable.RefreshTable;
Begin
  If ((csReading In ComponentState) Or (FDataSetLocked)) Then
    Begin
      FRefreshOnLoad := FActive;
      Exit;
    End;
  DoOpen;
  If Not FOpened Then Exit;
  If TableName <> '' Then QueryTable;
End;

Procedure TTable.SetTableName(NewValue:String);

Begin
  If fTableName=NewValue Then Exit;

  If FIndexDefs<>Nil Then FIndexDefs.Clear;
  fTableName:=NewValue;

  FSelect.Clear;
  NewValue:='SELECT * FROM '+ NewValue;
  FSelect.Add(NewValue);

  If FActive Then
    Begin
      RefreshTable;
      DataChange(deTableNameChanged);
    End;
End;

Function TTable.GetPassword:String;
Begin
  Result:=fODBC.Password;
End;

Function TTable.GetUserId:String;
Begin
  Result:=fODBC.UserID;
End;

Procedure TTable.SetPassword(NewValue:String);
Begin
  If FOpened Then
    Begin
      ErrorBox(LoadNLSStr(SCannotPerformDBAction));
      Exit;
    End;
  fODBC.Password:=NewValue;
End;

Procedure TTable.SetUserId(NewValue:String);
Begin
  If FOpened Then
    Begin
      ErrorBox(LoadNLSStr(SCannotPerformDBAction));
      Exit;
    End;
  fODBC.UserID:=NewValue;
End;

Destructor TTable.Destroy;
Begin
//  DoClose;
  SetActive(false);

  fTableName:='';
  If FServants<>Nil Then
    Begin
      NotifyServants(Self);
      FServants.Destroy;
    End;
  FServants:=Nil;
  If FDataTypes<>Nil Then
    Begin
      FDataTypes.Destroy;
      FDataTypes:=Nil;
    End;
  If FIndexDefs<>Nil Then
    Begin
      FIndexDefs.Destroy;
      FIndexDefs:=Nil;
    End;
  If FIndexFieldMap<>Nil Then
    Begin
      FIndexFieldMap.Destroy;
      FIndexFieldMap:=Nil;
    End;
  If FMasterSource<>Nil Then
    If FMasterSource.DataSet Is TTable Then
      TTable(FMasterSource.DataSet).ConnectServant(Self,False);
  AssignStr(FMasterFields,'');
  Inherited Destroy;
End;

Procedure TTable.Loaded;
Begin
  If FTempMasterSource<>Nil Then
    If FTempMasterSource.DataSet Is TTable Then
      If FMasterSource=Nil Then
        MasterSource:=FTempMasterSource;
  Inherited Loaded;
End;

{$HINTS OFF}
Procedure TTable.UpdateLinkList(Const PropertyName:String;LinkList:TList);
Var T:LongInt;
    DataSource:TDataSource;
Begin
  For T:=LinkList.Count-1 DownTo 0 Do
    Begin
      DataSource:=TDataSource(LinkList[T]);
      If DataSource Is TDataSource Then
        Begin
          If DataSource.DataSet Is TTable
            Then
              Begin  //no recursive elements !!
                If TTable(DataSource.DataSet)=Self Then LinkList.Remove(DataSource);
              End
            Else
              Begin  //no DataSources that are Not linked To tables !
                LinkList.Remove(DataSource);
              End;
        End;
    End;
End;
{$HINTS ON}

Procedure TTable.SetMasterSource(NewValue:TDataSource);
Var OldLocked:Boolean;
    IsLoaded:Boolean;
Begin
  If NewValue=FMasterSource Then Exit;
  If NewValue<>Nil Then
    Begin
      If Not (NewValue.DataSet Is TTable) Then
        Begin
          IsLoaded:=((ComponentState*[csReading]=[])And(Not FDataSetLocked));
          If ((NewValue.DataSet=Nil)And(Not IsLoaded))
            Then FTempMasterSource:=NewValue
            Else If ComponentState*[csDesigning]<>[] Then ErrorBox(LoadNLSStr(SDataSourceLinkError));
          Exit;
        End;
      If TTable(NewValue.DataSet)=Self Then
        Begin
          If ComponentState*[csDesigning]<>[] Then
            ErrorBox('Illegal recursive DataSource link');
          Exit;
        End;
      If ((FServants<>Nil)And(FServants.IndexOf(NewValue.DataSet)>=0)) Then
        Begin
          If ComponentState*[csDesigning]<>[] Then
            ErrorBox('Illegal circular DataSource link');
          Exit;
        End;
    End;

//prevent call Of RefreshTable In ConnectServant
  OldLocked:=FDataSetLocked;
  FDataSetLocked:=True;
  If FMasterSource<>Nil Then
    If FMasterSource.DataSet Is TTable Then
      TTable(FMasterSource.DataSet).ConnectServant(Self,False);
  FMasterSource:=NewValue;
  FDataSetLocked:=OldLocked;
  If FMasterSource<>Nil
    Then
      Begin
        If FMasterSource.DataSet Is TTable
          Then TTable(FMasterSource.DataSet).ConnectServant(Self,True)
          Else
            If ((ComponentState*[csReading]=[])And(Not FDataSetLocked))
              Then RefreshTable;
      End
    Else
      If ((ComponentState*[csReading]=[])And(Not FDataSetLocked))
        Then RefreshTable;
End;

Function TTable.GetMasterFields:String;
Begin
  Result:=FMasterFields^;
End;

Procedure TTable.SetMasterFields(Const NewValue:String);
Begin
  If GetMasterFields=NewValue Then exit;
  AssignStr(FMasterFields,NewValue);
  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked))
    Then RefreshTable;
End;

Procedure TTable.ConnectServant(Servant:TTable;Connect:Boolean);
Begin
  If Connect
    Then
      Begin
        If FServants=Nil Then FServants.Create;
        FServants.Add(Servant);
      End
    Else If FServants<>Nil Then
      Begin
        If FServants.IndexOf(Servant)>=0 Then FServants.Remove(Servant);
      End;
  If ((Servant.ComponentState*[csReading]=[])And(Not Servant.FDataSetLocked)) Then
    Servant.RefreshTable;
End;

Procedure TTable.DataChange(event:TDataChange);
Var T:LongInt;
    Servant:TTable;
Begin
  If FServants<>Nil Then
    For T:=0 To FServants.Count-1 Do
      Begin
        Servant:=FServants[T];
        If ((Servant.ComponentState*[csReading]=[])And(Not Servant.FDataSetLocked)) Then
          Servant.RefreshTable;
      End;
  Inherited DataChange(event);
End;

Function TTable.GetResultColRow(Col,Row:LongInt):TField;
Var FieldDef:TFieldDef;
    I,t:LongInt;
    field:TField;
    rc:SQLRETURN;
    OutLen:LongInt;
    Temp:Pointer;
    NewLen:LongInt;
    MapType:LongInt;
    S:String;
    ActRows:LongWord;
    RowStatus:Word;
    ExtFetchOk:Boolean;
    Header:TGraphicHeader;

Label again,err;

Begin
  Result := Nil;
  If Not FOpened Then Exit;
  Result := Inherited GetResultColRow(Col,Row);
  If Result <> Nil Then exit;
  If fODBCStmt.HStmt=0 Then Exit;       {no previous Select Command Or no more Rows}

/* Store Result Row(S)  */
again:
//Try if we are able to retrieve cursored rows !
  If Self Is TStoredProc
    Then //due to "Function sequence error"
      Begin
        rc:=fODBCStmt.SQLFetch;
        ExtFetchOk:=False;
      End
    Else
      Begin
        rc:=fODBCStmt.SQLExtendedFetch(SQL_FETCH_ABSOLUTE, Row+1, ActRows, RowStatus);
        ExtFetchOk:=rc<>SQL_ERROR;
        If not ExtFetchOk
          Then rc:=fODBCStmt.SQLFetch; //Driver not capable (DB2 !)
      End;
  FieldDef:=FFieldDefs[0];
  If ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Then
    Begin
      For I:=0 To FFieldDefs.Count-1 Do
        Begin
          FieldDef:=FFieldDefs[I];
          {Create Row}
          Field := FieldDef.CreateField(Nil);
          If ExtFetchOk
            Then Field.FRow:=Row+1
            Else Field.FRow:=FieldDef.Fields.Count;
          Field.FCol:=I;

          Case FieldDef.DataType Of
            ftBytes,ftVarBytes,ftBlob,ftMemo,ftGraphic,
            ftFmtMemo,ftTypedBinary : MapType:=SQL_C_BINARY;
            ftFloat: Begin
                       Case FieldDef.Size Of
                         4:MapType:=SQL_C_FLOAT;
                         Else MapType:=SQL_C_DOUBLE;
                       End; //case
                     End;
            Else MapType:=SQL_C_DEFAULT;
          End;

          rc:=fODBCStmt.SQLGetData(I+1,MapType,field.FValue^,
                               FieldDef.Size,OutLen);
          If rc<>SQL_ERROR Then
            Begin
              If ((rc=SQL_SUCCESS_WITH_INFO) And (OutLen>field.FValueLen)And
                  (MapType=SQL_C_BINARY)) Then
                Begin
                  NewLen:=OutLen-field.FValueLen;
                  GetMem(Temp,OutLen);
                  Move(Field.FValue^,Temp^,Field.FValueLen);
                  FreeMem(Field.FValue,Field.FValueLen);
                  Field.FValue:=Temp;
                  Inc(Temp,field.FValueLen);
                  Field.FValueLen:=OutLen;
                  rc:=fODBCStmt.SQLGetData(I+1,MapType,Temp^,NewLen,OutLen);
                  If rc=SQL_ERROR Then
                    Begin
                      Field.Destroy;
                      Goto err;
                    End;
                  OutLen:=Field.FValueLen+1;
                End;
              If OutLen=SQL_NULL_DATA
                Then
                  Begin
                    Field.FreeMemory;  //TOM TEST
                  End
                Else
                  Begin
                    If OutLen<=field.FValueLen Then
                      Begin
                        GetMem(Temp,OutLen);
                        Move(Field.FValue^,Temp^,OutLen);
                        FreeMem(Field.FValue,Field.FValueLen);
                        Field.FValue:=Temp;
                        Field.FValueLen:=OutLen;
                      End;
                  End;

              If ExtFetchOk
                Then
                  Begin
                    If Row<=FieldDef.Fields.Count-1
                      Then
                        Begin
                          FieldDef.Fields[Row]:=Field;
                        End
                      Else
                        Begin
                          For t:=FieldDef.Fields.Count+1 To Row Do
                            FieldDef.Fields.Add(Nil);
                          FieldDef.Fields.Add(Field);
                        End;
                  End
                Else FieldDef.Fields.Add(Field);
              End
            Else
              Begin
                Field.Destroy;
                Goto err;
              End;

          If Field Is TBlobField Then // check graphic header
            Begin
              If Field.FValueLen >= SizeOf(TGraphicHeader) Then
                Begin
                  move(Field.FValue^, Header, SizeOf(TGraphicHeader));
                  If (Header.Count = 1) And (Header.HType = $0100) And
                     (Header.Size = Field.FValueLen - SizeOf(TGraphicHeader)) Then
                    Begin
                      GetMem(Temp, Header.Size);
                      inc(Field.FValue, SizeOf(TGraphicHeader));
                      Move(Field.FValue^,Temp^, Header.Size);
                      dec(Field.FValue, SizeOf(TGraphicHeader));
                      FreeMem(Field.FValue, Field.FValueLen);
                      Field.FValue := Temp;
                      Field.FValueLen := Header.Size;
                    //Field.FBlobType := ftGraphic;
                    End;
                End;
             End;
        End;

      FieldDef:=FFieldDefs[Col];

      If ((ExtFetchOk)Or(Row=FieldDef.Fields.Count-1)) Then
        Begin
          {result found}
          Result:=FieldDef.Fields.Items[Row];
          exit;
        End;

      Goto again;  {fetch Next Row}
    End
  Else
    Begin
     {no more Rows}
     If rc=SQL_ERROR Then
       Begin
err:
         S:=fODBC.SQLErrorText(fODBCStmt.HStmt);
         CloseStmt;
         SQLError('Error fetching result row '+FieldDef.Name+#13#10+S);
       End;
       CloseStmt;
    End;
End;


Procedure TTable.GetKeys(List:TStrings;Primary:Boolean);
Var Stmt : tcODBCStmt;
    cols:SQLSMALLINT;
    C:Array[0..8] Of cstring;
    cc:cstring;
    S,S1:String;
    I:LongInt;
    OutLen:Array[0..8] Of SQLINTEGER;
    rc:SQLRETURN;
    Offset,Offset1:LongInt;

Begin
  If Primary
    Then
      Begin
        Offset:=0;
        Offset1:=0;
      End
    Else
      Begin
        Offset:=4;
        Offset1:=-4;
      End;

  EnterSQLProcessing;
  Stmt.Create(fODBC);
  cc:=TableName;
  Try //Some DB2 Servers return a GPF here ...
    rc:=SQL_ERROR;
    If Primary
      Then rc:=Stmt.SQLPrimaryKeys(TableName)
      Else rc:=Stmt.SQLForeignKeys(TableName);
    If rc=SQL_SUCCESS Then
      Begin
        Stmt.SQLNumResultCols(cols);
        If cols>8 Then cols:=8;
        For I := 0 To cols-1 Do
          Stmt.SQLBindCol(I + 1, SQL_C_CHAR, C[I], 255, OutLen[I]);
        rc:=Stmt.SQLFetch;
        While ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Do
          Begin
            If OutLen[3+Offset]<>SQL_NULL_DATA Then
              Begin
                Move(C[3+Offset],S[1],OutLen[3+Offset]);
                S[0]:=Chr(OutLen[3+Offset]);
                If S[Length(S)]=#0 Then
                  If length(S)>0 Then dec(S[0]);
                If ((TableName='')Or(Not Primary)) Then
                   Begin
                     If OutLen[2+Offset+Offset1]<>SQL_NULL_DATA Then
                       Begin
                         Move(C[2+Offset+Offset1],S1[1],OutLen[2+Offset+Offset1]);
                         S1[0]:=Chr(OutLen[2+Offset+Offset1]);
                         If S1[Length(S1)]=#0 Then
                           If length(S1)>0 Then dec(S1[0]);
                         If not Primary
                           Then
                             Begin
                               S:=S+'>'+S1;
                               If OutLen[2+Offset+Offset1+1]<>SQL_NULL_DATA Then
                                 Begin
                                   Move(C[2+Offset+Offset1+1],S1[1],OutLen[2+Offset+Offset1+1]);
                                   S1[0]:=Chr(OutLen[2+Offset+Offset1+1]);
                                   If S1[Length(S1)]=#0 Then
                                     If length(S1)>0 Then dec(S1[0]);
                                   S:=S+'.'+S1;
                                 End;
                             End
                           Else S:=S1+'.'+S;
                       End;
                   End;
                 List.Add(S);
              End;
            rc:=Stmt.SQLFetch;
          End;
      End;

  Except
    List.Clear;
  End;
  Stmt.Destroy;
  LeaveSQLProcessing;
End;


Procedure TTable.DoOpen;
Var rc:SQLRETURN;
    s:String;

Begin
  Application.LogWriteln('tTable.DoOpen-Start');
  If Not FActive Then Exit;
  If Not FOpened Then
    Begin
       EnterSQLProcessing;
       Try
         If FBeforeOpen<>Nil Then FBeforeOpen(Self);
         if fODBC.AllocateDBEnvironment<>SQL_SUCCESS Then
           Begin
             LeaveSQLProcessing;
             ErrorBox(LoadNLSStr(SErrAllocDBEnv)+'.'+fODBC.SQLErrorText(0));
             Active:=False;
             Exit;
           End;

// Connect To Server
         If fODBC.SQLAllocConnect<>SQL_SUCCESS Then
           Begin
             LeaveSQLProcessing;
             ErrorBox(LoadNLSStr(SErrAllocDBConnect)+'.'+fODBC.SQLErrorText(0));
             DoClose;
             Exit;
           End;

// Set autocommit OFF
         If fODBC.SQLSetConnectOption(SQL_AUTOCOMMIT,SQL_AUTOCOMMIT_ON)<>SQL_SUCCESS Then
           Begin
             LeaveSQLProcessing;
             ErrorBox(LoadNLSStr(SErrSettingDBOpts)+'.'+fODBC.SQLErrorText(0));
             DoClose;
             Exit;
           End;

// Connect
         Try
           rc:=fODBC.SqlConnect;
           if rc<>SQL_SUCCESS Then
             Begin
                S:=fODBC.SQLErrorText(0);
                SQLError(LoadNLSStr(SErrorDBConnecting)+' "'+DSN+'".'+#13#10+S);
                DoClose;
             End;
         Except
           ON E:ESQLError Do
             Begin
               LeaveSQLProcessing;
               ErrorBox(E.Message);
               Exit;
             End;
           Else Raise;
         End;

         FOpened:=True;
         fODBCStmt.Create(fODBC);

         LeaveSQLProcessing;
         If FAfterOpen<>Nil Then AfterOpen(Self);
       Except
         LeaveSQLProcessing;
         Raise;
       End;
    End;
  Application.LogWriteln('tTable.DoOpen-End');
End;


Procedure TTable.DoClose;
Begin
  Try
    If FBeforeClose<>Nil Then FBeforeClose(Self);
    If FOpened Then
      Begin
        CloseStmt;
        Post;  //Commit All transactions
      End;

    FActive:=False;
    FDataSetLocked:=True;
    FFieldDefs.Clear;
    FDataSetLocked:=False;

    If fODBC.hdbc <> 0 Then
      Begin
        If FOpened Then
          If fODBC.SQLDisconnect <> SQL_SUCCESS Then
            ErrorBox('Disconnect error ' + fODBC.SQLErrorText(0));
        If fODBC.SQLFreeConnect <> SQL_SUCCESS Then
          ErrorBox('FreeConnect error ' + fODBC.SQLErrorText(0));
        if fODBCStmt<>nil then
          Begin
            fODBCStmt.Destroy;
            fODBCStmt:=nil;
          End;
      End;

    If fODBC.henv <> 0 Then
      Begin
        If fODBC.SQLFreeEnv <> SQL_SUCCESS Then
          ErrorBox('FreeEnv error '+fODBC.SQLErrorText(0));
      End;

    Inherited DoClose;

    DataChange(deDSNChanged);

    If FAfterClose<>Nil Then FAfterClose(Self);
  Except
    Raise;
  End;
End;


Procedure TTable.GetStoredProcNames(List:TStrings);
Var Stmt : tcODBCStmt;
    cols:SQLSMALLINT;
    I:LongInt;
    C:Array[0..4] Of cstring;
    OutLen:Array[0..4] Of SQLINTEGER;
    rc:SQLRETURN;
    S,S1:String;
    OldActive:Boolean;
    OldOpen:Boolean;

Begin
  Inherited GetStoredProcNames(List);

  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked)) Then
    Begin
      OldActive:=FActive;
      OldOpen:=FOpened;
      If Designed Then
        If Not FOpened Then
          Begin
            FActive:=True;
            DoOpen;
            If Not FOpened Then Active:=False;
          End;

        If FOpened Then
          Begin
            EnterSQLProcessing;
            Stmt.Create(fODBC);
            If Stmt.SQLProcedures=SQL_SUCCESS
              Then
                Begin
                  Stmt.SQLNumResultCols(cols);
                  If cols>3 Then cols:=3;
                    For I := 0 To cols-1 Do
                      Stmt.SQLBindCol(I + 1, SQL_C_CHAR, C[I], 255, OutLen[I]);
                  rc:=Stmt.SQLFetch;
                  While ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Do
                    Begin
                      If OutLen[2]<>SQL_NULL_DATA Then
                        Begin
                          Move(C[2],S[1],OutLen[2]);
                          S[0]:=Chr(OutLen[2]);
                          If S[length(S)]=#0 Then
                            If length(S)>0 Then dec(S[0]);
                              If OutLen[0]<>SQL_NULL_DATA Then
                                Begin
                                  Move(C[0],S1[1],OutLen[0]);
                                  S1[0]:=Chr(OutLen[0]);
                                  If S1[length(S1)]=#0 Then
                                    If length(S1)>0 Then
                                      dec(S1[0]);
                                  If S1<>'' Then S:=S1+'.'+S;
                                End;
                           List.Add(S);
                         End;
                       rc:=Stmt.SQLFetch;
                    End;
                End
              Else List.Clear;

            Stmt.Destroy;
            LeaveSQLProcessing;
          End;

        If Designed Then
          Begin
            If Not OldOpen Then
              DoClose;
            FActive:=OldActive;
          End;
    End;
End;

Procedure TTable.GetDataSources(List:TStrings);

Var rv : SQLRETURN;
    sDSNItem, sDRVItem : cString;
    iDSNLen, iDRVLen : SQLSMALLINT;

Begin
  List.Clear;
  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked)) Then
    Repeat
      fillChar(sDSNItem, Sizeof(sDSNItem),#0);
      fillChar(sDRVItem, Sizeof(sDRVItem),#0);
      rv:=fODBC.SQLDataSources(SQL_FETCH_NEXT,
                   sDSNItem, 255, iDSNLen, sDRVItem, 255, iDRVLen);
      if rv=SQL_SUCCESS then
        List.Add(sDSNItem);
    Until rv<>SQL_SUCCESS;
End;


Procedure TTable.DoDelete;
Var C,c1:cstring;
    Stmt, Stmt1 : tcODBCStmt;
    S:String;
    resultCols:SQLSMALLINT;
    rc :SQLRETURN;
    T  :LongInt;
    T1 :LongInt;

Begin
  If ReadOnly Then SQLError('Cannot modify a readonly dataset!');
  If (Not IsTable) Then exit; //cannot update this result set...
  EnterSQLProcessing;
  Stmt.Create(fODBC);

//  C:='SELECT _rowid,'+Fields[0].FieldName+' FROM '+TableName+' FOR UPDATE';
  C:='SELECT * FROM '+TableName+' FOR UPDATE';
  If Stmt.SQLExecDirect(C)<>SQL_SUCCESS Then
    Begin
       S:=fODBC.SQLErrorText(Stmt.HStmt);
       Stmt.Destroy;
       SQLError('Error executing SELECT SQL statement: '+S);
       exit;
     End;

  Stmt.SQLNumResultCols(resultCols);
  If resultCols=0 Then //Not A Select statement
    Begin
      Stmt.Destroy;
      LeaveSQLProcessing;
      Exit;
    End;

  T1:=Fields[0].Row-1;
  For T:=1 To T1 Do
    Begin
      rc:=Stmt.SQLFetch;
      If ((rc=SQL_NO_DATA_FOUND)Or(rc=SQL_ERROR)) Then
        Begin
          S:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorFetchingSQLStatement)+': '+S);
        End;
    End;

// Cursor definieren
  FillChar(c1,255,0);
  If Stmt.SQLGetCursorName(c1,255,resultCols)<>SQL_SUCCESS Then
    Begin
      S:=fODBC.SQLErrorText(Stmt.HStmt);
      SQLError('Error executing SQLGetCursorName statement: '+S);
    End;

  Stmt1.Create(fODBC);
  C:='DELETE FROM '+TableName+' WHERE CURRENT OF '+c1;

  If Stmt1.SQLExecDirect(C)<>SQL_SUCCESS Then
     Begin
       S:=fODBC.SQLErrorText(Stmt1.HStmt);
       SQLError('Error executing SQL DELETE statement: '+S);
     End;

  Stmt1.Destroy;
  Stmt.Destroy;
  LeaveSQLProcessing;
  Inherited DoDelete;
  QueryTable;
End;


Procedure TTable.CommitInsert(Commit:Boolean);
Var Stmt : tcODBCStmt;
    Ansi : AnsiString;
    S    : String;
    T    : LongInt;
    Field: TField;

Begin
  Inherited CommitInsert(Commit);
  If ReadOnly Then SQLError('Cannot modify a readonly dataset!');
  If Commit
    Then
      Begin
        EnterSQLProcessing;
        Stmt.Create(fODBC);
        Ansi:='INSERT INTO '+TableName+' (';
        For T:=0 To FieldCount-1 Do
          Begin
            Ansi:=Ansi+FieldNames[T];
            If T<>FieldCount-1 Then Ansi:=Ansi+',';
          End;
        Ansi:=Ansi+') VALUES(';
        For T:=0 To FieldCount-1 Do
          Begin
            Field:=Fields[T];
          If Field.DataType=ftMemo
            Then Ansi:=Ansi+#39+PChar(Field.FValue)^+#39
            Else
              Begin
                S:=Field2String(field);
                Ansi:=Ansi+S;
              End;
          If T<>FieldCount-1 Then Ansi:=Ansi+',';
        End;
        Ansi:=Ansi+')';

        If Stmt.SQLExecDirect(PChar(Ansi)^)<>SQL_SUCCESS Then
          Begin
            S:=fODBC.SQLErrorText(Stmt.HStmt);
            SQLError('Error executing INSERT SQL statement: '+S);
          End;

        Stmt.Destroy;
        LeaveSQLProcessing;
        FRowIsInserted:=False;
        QueryTable;
      End
    Else
      Begin
        RemoveCurrentFields;
        RowInserted := False;
      End;
End;

Function TTable.UpdateFieldSelect(Field:TField):Boolean;
Var Stmt, Stmt1 : tcODBCStmt;
    resultCols:SQLSMALLINT;
    C,c1:cstring;
    rc:SQLRETURN;
    S:String;
    T,T1    : LongInt;
    Ansi    : AnsiString;
    TempFile: FILE;
    TempFileName:String;

Begin
  Result:=False;
  If Not FOpened Then Exit;
  If ((field=Nil)Or(FSelect.Count=0)) Then Exit;
  If FRowIsInserted Then
    Begin
      Result:=True;
      Exit;
    End;

  If ReadOnly Then SQLError('Cannot modify a readonly dataset!');
  If (Not IsTable) Then exit; //cannot update this result set...

  EnterSQLProcessing;
  Stmt.Create(fODBC);
  C:='SELECT * FROM '+TableName+' FOR UPDATE';

  If Stmt.SQLExecDirect(C)<>SQL_SUCCESS Then
    Begin
      S:=fODBC.SQLErrorText(Stmt.HStmt);
      SQLError('Error executing SELECT SQL statement: '+S);
    End;

  Stmt.SQLNumResultCols(resultCols);
  If resultCols=0 Then //Not A Select statement
    Begin
      Stmt.Destroy;
      LeaveSQLProcessing;
      Exit;
    End;

  T1:=Field.FRow-2;

  For T:=0 To T1 Do
    Begin
      rc:=Stmt.SQLFetch;
      If ((rc=SQL_NO_DATA_FOUND)Or(rc=SQL_ERROR)) Then
        Begin
          S:=fODBC.SQLErrorText(Stmt.HStmt);
          SQLError(LoadNLSStr(SErrorFetchingSQLStatement)+': '+S);
        End;
    End;

  FillChar(c1,255,0);
  If Stmt.SQLGetCursorName(c1,255,resultCols)<>SQL_SUCCESS Then
    Begin
      S:=fODBC.SQLErrorText(Stmt.HStmt);
      SQLError('Error executing SQLGetCursorName statement: '+S);
    End;

  Ansi:='UPDATE '+TableName+' SET '+field.FieldName+'=';
  Case Field.DataType Of
    ftBlob: Begin
              TempFileName := GetTempFileName;
              If Field Is TBlobField Then
                Begin
                  Try
                    TBlobField(Field).SaveToFile(TempFileName);
                  Except
                    TempFileName := GetTempFileName; // 'c:\blob0001.tmp';
                    TBlobField(Field).SaveToFile(TempFileName);
                  End;
                End;
              Ansi:=Ansi+#39+TempFileName+#39;
            End;
    ftMemo: Ansi:=Ansi+#39+PChar(Field.FValue)^+#39
    Else    Ansi:=Ansi+Field2String(field);
  End;

  Ansi:=Ansi+' WHERE CURRENT OF '+c1;

  Stmt1.Create(fODBC);
  If Stmt1.SQLExecDirect(PChar(Ansi)^)<>SQL_SUCCESS Then
    Begin
      S:=fODBC.SQLErrorText(Stmt1.HStmt);
      SQLError('Error executing SQL UPDATE statement: '+S);
    End;

  Case Field.DataType Of
    ftBlob: Begin
              System.Assign(TempFile, TempFileName);
              {$i-}
              Erase(TempFile);
              {$i+}
            End;
  End;
  Stmt1.Destroy;
  Stmt.Destroy;
  LeaveSQLProcessing;
  Result:=True;
End;

Procedure TTable.DoCancel;
Begin
  fODBC.SQLTransact(SQL_ROLLBACK);
End;


Procedure TTable.DoPost;
Begin
  fODBC.SQLTransact(SQL_COMMIT);
End;


Procedure TTable.CloseStmt;

Begin
  If Not FOpened Then Exit;
  fODBCStmt.Reset;
End;

Procedure TTable.UpdateIndexDefs;

Var Stmt: tcODBCStmt;
    cols:SQLSMALLINT;
    I:LongInt;
    C:Array[0..9] Of cstring;
    OutLen:Array[0..9] Of SQLINTEGER;
    rc:SQLRETURN;
    S,S1,Fields:String;
    OldActive:Boolean;
    OldOpen:Boolean;
    IndexDef:TIndexDef;
Begin
  If FIndexDefs<>Nil
    Then FIndexDefs.Clear
    Else FIndexDefs.Create(Self);
  If FIndexFieldMap<>Nil Then FIndexFieldMap.Clear;

  If (Not IsTable) Then SQLError('Illegal operation');

  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked)) Then
    Begin
      OldActive:=FActive;
      OldOpen:=FOpened;
      If Not FOpened Then
        Begin
          FActive:=True;
          DoOpen;
          If Not FOpened Then Active:=False;
        End;

      If FOpened Then
        Begin
          EnterSQLProcessing;
          Stmt.Create(fODBC);
          If Stmt.SQLStatistics(TableName,SQL_INDEX_ALL,SQL_ENSURE)=SQL_SUCCESS
            Then
              Begin
                Stmt.SQLNumResultCols(cols);
                If cols>9 Then cols:=9;
                For I := 0 To cols-1 Do
                  Stmt.SQLBindCol(I + 1, SQL_C_CHAR, C[I], 255, OutLen[I]);
                rc:=Stmt.SQLFetch;
                While ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Do
                  Begin
                    If OutLen[5]<>SQL_NULL_DATA Then
                      Begin
                        Move(C[5],S[1],OutLen[5]);
                        S[0]:=Chr(OutLen[5]);
                        If S[length(s)]=#0 Then
                        If length(S)>0 Then dec(S[0]);
                        If OutLen[4]<>SQL_NULL_DATA Then
                          Begin
                            Move(C[4],S1[1],OutLen[4]);
                            S1[0]:=Chr(OutLen[4]);
                            If S1[length(S1)]=#0 Then
                              If length(S1)>0 Then dec(S1[0]);
                              If S1<>'' Then S:=S1+'.'+S;
                          End;

                        //get column name
                        If OutLen[8]<>SQL_NULL_DATA Then
                          Begin
                            Move(C[8],Fields[1],OutLen[8]);
                            Fields[0]:=Chr(OutLen[8]);
                            If Fields[length(Fields)]=#0 Then
                              If length(Fields)>0 Then dec(Fields[0]);
                          End;

                        If ((s<>'')And(Fields<>'')) Then
                          Begin
                            If FIndexDefs.IndexOf(s)>=0
                              Then
                                Begin
                                  IndexDef:=FIndexDefs.Items[FIndexDefs.IndexOf(s)];
                                  AssignStr(IndexDef.FFields,IndexDef.Fields+';'+Fields);
                                End
                              Else FIndexDefs.Add(s,Fields,[]);
                          End;
                      End;
                    rc:=Stmt.SQLFetch;
                  End;
               End
            Else
              Begin
                S:=fODBC.SQLErrorText(Stmt.HStmt);
                DSNError(s);
              End;
          Stmt.Destroy;
          LeaveSQLProcessing;
        End;

      If Not OldOpen Then DoClose;
      FActive:=OldActive;
    End;
End;

Procedure TTable.UpdateFieldDefs;
Begin
  QueryTable;
End;

Procedure TTable.QueryTable;
Var resultCols:SQLSMALLINT;
    colName:cstring;
    colNameLen:SQLSMALLINT;
    colType:SQLSMALLINT;
    Size:SQLUINTEGER;
    Scale:SQLSMALLINT;
    I:LongInt;
    S:String;
    Select:PChar;
    Temp:TStringList;
    t2:String;
    J,j1:String;
    First:Boolean;
    B:Byte;
    field:TField;
    MasterTable:TTable;
    rc:SQLRETURN;
    pfNullable:SQLSMALLINT;
    FieldDef:TFieldDef;

Label lll;
Begin
  If Not FOpened Then Exit;

//Erase All tables And Reset Object
  CloseStmt;
  FFieldDefs.Clear;
  FCurrentRow:=-1;
  FCurrentField:=0;

  If ((Self Is TTable)And(TTable(Self).FMasterSource<>Nil)And
     (TTable(Self).FMasterSource.DataSet Is TTable))
    then
      Begin
        Temp.Create;

        t2:=TTable(TTable(Self).FMasterSource.DataSet).TableName;
        S:='SELECT * FROM '+TableName;
        if fOrderBy<>'' then
          S:=S+' ORDER BY '+fOrderBy;
        Temp.Add(S);

        S:=TTable(Self).MasterFields;
        First:=True;
        MasterTable:=TTable(TTable(Self).FMasterSource.DataSet);
        While S<>'' Do
          Begin
            B:=Pos(';',S);
            If B<>0
              Then
                Begin
                  J:=Copy(S,1,B-1);
                  System.Delete(S,1,B);
                End
              Else
                Begin
                  J:=S;
                  S:='';
                End;
             B:=Pos('=',J);
             If B<>0
               Then
                 Begin
                   j1:=System.Copy(J,B+1,255);
                   J[0]:=Chr(B-1);
                 End
               Else j1:=J;
             field:=MasterTable.FieldFromColumnName[j1];
             If field=Nil Then
               Begin
                 Temp.Destroy;
                 Goto lll;
               End;

             j1:=Field2String(field);

             If First
               Then Temp.Add('WHERE '+J+'='+j1)
               Else Temp.Add('AND '+J+'='+j1);
             First:=False;
          End;
        Select:=Temp.GetText;
        Temp.Destroy;
      End
    Else
      Begin
lll:
        Select:=FSelect.GetText;
      End;

  If Select=Nil Then
    Begin
      DoClose;
      Exit;
    End;

   While ((Select^<>'') And (Select^[length(Select^)-1] In [#13,#10])) Do
     Select^[length(Select^)-1]:=#0;

   EnterSQLProcessing;
   Try
     If fODBCStmt.SQLExecDirect(Select^)<>SQL_SUCCESS Then
       Begin
         S:=fODBC.SQLErrorText(fODBCStmt.HStmt);
         CloseStmt;
         DoClose;
         SQLError('Error executing SELECT statement: '+S);
       End;

// The driver determines the number of rows in the result set
    rc:=fODBCStmt.SQLFetch;;
    FMaxRows:=0;
    While ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Do
      Begin
        inc(FMaxRows);
        rc:=fODBCStmt.SQLFetch;
      End;
    fODBCStmt.Reset;

// The driver recreates the result set}
    fODBCStmt.SQLSetStmtOption(SQL_CURSOR_TYPE,SQL_CURSOR_KEYSET_DRIVEN);
    If fODBCStmt.SQLExecDirect(Select^)<>SQL_SUCCESS Then
      Begin
        S:=fODBC.SQLErrorText(fODBCStmt.HStmt);
        CloseStmt;
        DoClose;
        SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S);
      End;

// The driver determines the result set columns}
    fODBCStmt.SQLNumResultCols(resultCols);
    If resultCols=0
      Then //Not A Select statement
        Begin
          CloseStmt;
          SQLError(LoadNLSStr(SEmptyResultSet));
        End
      Else  // Store Result Columns
        Begin
          For I := 0 To resultCols-1 Do
            Begin
              Size:=0;
              fODBCStmt.SQLDescribeCol(I + 1, colName,
                    SizeOf(colName), colNameLen, colType, Size, Scale, pfNullable);
              If Size>65535 Then Size:=4096;
              S:=colName;
              Case ColType Of
                SQL_REAL:Size:=4;
                SQL_FLOAT,SQL_DOUBLE,SQL_NUMERIC:Size:=8;
              End; //case
              FFieldDefs.Add(S, MapSQLType(colType), Size, pfNullable=SQL_NO_NULLS);
              FieldDef := FFieldDefs[I];
              FieldDef.Precision := Scale;
            End;
          FCurrentRow:=0;   {First Row}
          FCurrentField:=0; {First field}
        End;

    Post;  //Commit All transactions Until here
    StrDispose(Select);
    LeaveSQLProcessing;

  Except
    ON E:ESQLError Do
      Begin
        StrDispose(Select);
        CloseStmt;
        LeaveSQLProcessing;
        ErrorBox(E.Message);
      End;
    Else
      Begin
        StrDispose(Select);
        CloseStmt;
        LeaveSQLProcessing;
        Raise;
      End;
    End;

  DataChange(deDSNChanged);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TQuery Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TQuery.RefreshTable;
Begin
  If ((ComponentState*[csReading]<>[])Or(FDataSetLocked)) Then
    Begin
      FRefreshOnLoad:=FActive;
      Exit;
    End;
  DoOpen;
  If Not FOpened Then Exit;
  If FSelect.Count<>0 Then QueryTable;
End;

Procedure TQuery.SetSQL(NewValue:TStrings);
Begin
  If ((NewValue=FSelect)Or(NewValue.Equals(FSelect))) Then
    Exit; {!}
  FSelect.Assign(NewValue);
  If FActive Then RefreshTable;
End;

Procedure TQuery.SetupComponent;
Begin
  Inherited SetupComponent;
  ReadOnly:=True;
End;

Function TQuery.WriteSCUResource(Stream:TResourceStream):Boolean;
Var aText:PChar;
Begin
  Result:=Inherited WriteSCUResource(Stream);
  If Result=False Then Exit;
  aText:=FSelect.GetText;
  If aText<>Nil Then
    Begin
      Result:=Stream.NewResourceEntry(rnDBQuery,aText^,Length(aText^)+1);
      StrDispose(aText);
    End;
End;

Procedure TQuery.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var aText:PChar;
Begin
  If ResName = rnDBQuery
    Then
      Begin
        aText:=@Data;
        FSelect.SetText(aText);
      End
    Else
      Inherited ReadSCUResource(ResName,Data,DataLen)
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TParam Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TParam.SetAsBCD(Value: Currency);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsBoolean(Value: Boolean);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsCurrency(Value:Extended);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsDate(Value: TDateTime);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsDateTime(Value: TDateTime);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsFloat(Const Value:Extended);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsInteger(Value: Longint);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsString(Const Value:String);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsSmallInt(Value: LongInt);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsTime(Value: TDateTime);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Procedure TParam.SetAsVariant(Value: Variant);
Begin
  FNull := False;
  FBound := True;
  Case VarType(Value) Of
    varByte,varSmallint:DataType:=ftSmallInt;
    varInteger,varLongInt,varLongWord:DataType:=ftInteger;
    varCurrency:DataType:=ftBCD;
    varSingle,varDouble,varExtended:DataType:=ftFloat;
    varBoolean:DataType:=ftBoolean;
    varString:DataType:=ftString;
    Else DataType := ftUnknown;
  End;
  FData := Value;
End;

Procedure TParam.SetAsWord(Value: LongInt);
Begin
  FNull := False;
  FBound := True;
  FData:=Value;
End;

Function TParam.GetAsBCD: Currency;
Begin
  Result:=FData;
End;

Function TParam.GetAsBoolean: Boolean;
Begin
  Result:=FData;
End;

Function TParam.GetAsDateTime: TDateTime;
Begin
  Result:=FData;
End;

Function TParam.GetAsFloat:Extended;
Begin
  Result:=FData;
End;

Function TParam.GetAsInteger: Longint;
Begin
  Result:=FData;
End;

Function TParam.GetAsString:String;
Begin
  Result:=FData;
End;

Function TParam.GetAsVariant: Variant;
Begin
  Result:=FData;
End;

Function TParam.IsEqual(Value: TParam): Boolean;
Begin
  result:=False;
  If ParamType=Value.ParamType Then
    If Bound=Value.Bound Then
      If VarType(FData)=VarType(Value.FData) Then
        If Name=Value.Name Then
          If FData=Value.FData Then result:=True;
End;

Procedure TParam.SetDataType(Value: TFieldType);
Begin
  FData := 0;
  FDataType := Value;
End;

Procedure TParam.SetText(Const Value:String);
Begin
  FNull := False;
  FBound := True;
  If FDataType=ftUnknown Then
    DataType:=ftString;
  FData := Value;
  Case DataType of
    ftBoolean:FData:=Boolean(FData);
    ftInteger,ftSmallInt,ftWord: FData := Integer(FData);
    ftDateTime,ftTime,ftDate:FData:=Extended(FData);
    ftBCD:FData:=Currency(FData);
    ftCurrency,ftFloat:FData:=Extended(FData);
  End;
End;

Constructor TParam.Create(AParamList:TParams;AParamType: TParamType);
Begin
  FParamList:=AParamList;
  If FParamList<>Nil Then
    FParamList.AddParam(Self);
  FParamType := AParamType;
  DataType := ftUnknown;
  FBound := False;
End;

Destructor TParam.Destroy;
Begin
  If FParamList<>Nil Then
    FParamList.RemoveParam(Self);
  If FName<>Nil Then
    FreeMem(FName,length(FName^)+1);
  Inherited Destroy;
End;

Function TParam.GetName:String;
Begin
  If FName=Nil
    Then result:=''
    Else Result:=FName^;
End;

Procedure TParam.SetName(Const NewValue:String);
Begin
  If FName<>Nil Then
    FreeMem(FName,length(FName^)+1);
  GetMem(FName,length(NewValue)+1);
  FName^:=NewValue;
End;

Procedure TParam.Assign(Param: TParam);
Begin
  If Param=Nil Then exit;
  DataType:=Param.DataType;
  If not Param.IsNull
    Then
      Begin
        FNull := False;
        FBound := True;
        FData := Param.FData;
      End
    Else Clear;
  Name:=Param.Name;
  FBound:=Param.Bound;
  If FParamType=ptUnknown Then
    FParamType:=Param.ParamType;
End;

Procedure TParam.AssignField(Field: TField);
Begin
  If Field=Nil Then exit;
  DataType:=Field.DataType;
  If not Field.IsNull
    Then
      Begin
        FNull := False;
        FBound := True;
        FData := Field.AsString;
      End
    Else Clear;
  Name:=Field.FieldName;
  FBound:=True;
End;

Procedure TParam.AssignFieldValue(Field:TField;Const Value: Variant);
Begin
  If Field=Nil Then exit;
  DataType := Field.DataType;
  If VarIsNull(Value)
    Then Clear
    Else
      Begin
        FNull := False;
        FBound := True;
        FData := Value;
      End;
  FBound := True;
End;

Procedure TParam.Clear;
Begin
  FData:=0;
  FNull:=True;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TParams Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TParams.GetParam(Index: Word): TParam;
Begin
  result:=FItems[Index];
End;

Function TParams.GetParamValue(Const ParamName:String): Variant;
Var Param:TParam;
Begin
  Param:=ParamByName(ParamName);
  If Param<>Nil Then Result:=Param.Value;
End;

Procedure TParams.SetParamValue(Const ParamName:String;Const Value: Variant);
Var Param:TParam;
Begin
  Param:=ParamByName(ParamName);
  If Param<>Nil Then Param.Value:=Value;
End;

Constructor TParams.Create;
Begin
  Inherited Create;
  FItems.Create;
End;

Destructor TParams.Destroy;
Begin
  Clear;
  FItems.Destroy;
  Inherited Destroy;
End;

Procedure TParams.AddParam(Value: TParam);
Begin
  FItems.Add(Value);
End;

Procedure TParams.RemoveParam(Value: TParam);
Begin
  FItems.Remove(Value);
  If Value.FParamList=Self Then Value.FParamList:=Nil;
End;

Function TParams.CreateParam(FldType:TFieldType;Const ParamName:String;ParamType: TParamType): TParam;
Begin
  Result.Create(Self,ParamType);
  Result.Name:=ParamName;
  Result.DataType := FldType;
End;

Function TParams.Count:LongInt;
Begin
  Result:=FItems.Count;
End;

Procedure TParams.Clear;
Var t:LongInt;
    Param:TParam;
Begin
  For t:=FItems.Count-1 DownTo 0 Do
    Begin
      Param:=FItems[t];
      Param.Destroy;
    End;
End;

Function TParams.IsEqual(Value:TParams): Boolean;
Var t:LongInt;
Begin
  Result:=False;
  If FItems.Count=Value.Count Then
    For t:=0 To FItems.Count-1 Do If not Items[t].IsEqual(Value.Items[t]) Then exit;
End;

Function TParams.ParamByName(Const Value:String):TParam;
Var t:LongInt;
Begin
  For t:=0 To FItems.Count - 1 Do
  Begin
    Result:=FItems[t];
    If Result.Name=Value Then Exit;
  End;
  DSNError('Invalid stored procedure parameter name: '+Value);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TStoredProc Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TStoredProc.GetParamCount:Word;
Begin
  Result:=FParams.Count;
End;

Procedure TStoredProc.SetDefaultParams;
Var Stmt  : tcODBCStmt;
    cols  : SQLSMALLINT;
    I     : LongInt;
    C     : Array[0..12] Of cstring;
    OutLen: Array[0..12] Of SQLINTEGER;
    si    : SQLSMALLINT;
    rc    : SQLRETURN;
    S     : String;
    Cs    : CString;
    OldActive:Boolean;
    OldOpen:Boolean;
    pt    : TParamType;
    ft    : TFieldType;
    cc    : Integer;

/*    t   : LongInt;
    Names : TStringList;
    Types,Modes:TList; */

Label weiter;
Begin
    //determine parameter from driver
  FParams.Clear;

  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked)) Then
    If StoredProcName<>'' Then
      Begin
        OldActive:=FActive;
        OldOpen:=FOpened;
        If Designed Then
          If Not FOpened Then
            Begin
              FActive:=True;
              DoOpen;
              If Not FOpened Then Active:=False;
            End;

        If FOpened Then
          Begin
            EnterSQLProcessing;
            Stmt.Create(fODBC);
            Cs:=FProcName;
            If Stmt.SQLProcedureColumns(Cs,length(FProcName))=SQL_SUCCESS Then
              Begin
                Stmt.SQLNumResultCols(cols);
                If cols>13 Then cols:=13;
                For I := 0 To cols-1 Do
                  Stmt.SQLBindCol(I + 1, SQL_C_CHAR, C[I], 255, OutLen[I]);
                rc:=Stmt.SQLFetch;
                While ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Do
                  Begin
                    If OutLen[3]<>SQL_NULL_DATA Then //Parameter name
                      Begin
                        Move(C[4],S[1],OutLen[4]); //Parameter type
                        S[0]:=Chr(OutLen[4]);
                        Val(S,si,cc);
                        If cc<>0 Then goto weiter; //illegal

                        Case si Of
                          SQL_PARAM_INPUT:pt:=ptInput;
                          SQL_PARAM_OUTPUT:pt:=ptOutput;
                          SQL_PARAM_INPUT_OUTPUT:pt:=ptInputOutput;
                          SQL_RETURN_VALUE:pt:=ptResult;
                          SQL_RESULT_COL:pt:=ptResultSet;
                          Else pt:=ptUnknown;
                        End;

                        Move(C[5],S[1],OutLen[5]); //Parameter data type
                        S[0]:=Chr(OutLen[5]);
                        Val(S,si,cc);
                        If cc<>0 Then goto weiter; //illegal

                        ft:=MapSQLType(si);

                        Move(C[3],S[1],OutLen[3]);
                        S[0]:=Chr(OutLen[3]);

                        FParams.CreateParam(ft,S,pt);
                      End;
weiter:
                    rc:=Stmt.SQLFetch;
                  End;
              End;
            Stmt.Destroy;
            LeaveSQLProcessing;
          End;
        End;

      If Designed Then
        Begin
          If Not OldOpen Then DoClose;
          FActive:=OldActive;
        End;
End;

Procedure TStoredProc.SetPrepared(NewValue:Boolean);
Begin
  If not NewValue Then
    Begin
      FPrepared:=False;
      exit;
    End;
  If ((ComponentState*[csReading]=[])And(Not FDataSetLocked)) Then
    DoOpen;
//    If FOpened Then
//      fODBC.SQLAllocStmt(fODBC.ahdbc,fODBC.ahstmt);
  FPrepared:=True;
End;

Procedure TStoredProc.SetParams(NewValue:TParams);
Var t:LongInt;
Begin
  FParams.Clear;
  For t:=0 To NewValue.Count-1 Do
    FParams.CreateParam(NewValue[t].DataType,NewValue[t].Name,NewValue[t].ParamType);
End;

Procedure TStoredProc.SetStoredProcName(NewValue:String);
Begin
  CheckInactive;
  FProcName:=NewValue;
  FParams.Clear;
End;

Constructor TStoredProc.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);

  ReadOnly:=True;
  FParams.Create;
End;

Destructor TStoredProc.Destroy;
Begin
  FParams.Destroy;
  Inherited Destroy;
End;

Procedure TStoredProc.CopyParams(Value:TParams);
Begin
  Params:=Value;
End;

Procedure TStoredProc.ExecProc;
Var rc:SQLRETURN;
    ReturnsResultSet:Boolean;
    Param:TParam;
    I:LongInt;
    ptsql,ctype,sqltype,Len:SQLSMALLINT;
    p:Pointer;

/*
    t:LongInt;
    s:String;
    c:CString;
    resultCols:SQLSMALLINT;
    Size:SQLUINTEGER;
    colName:CString;
    colNameLen:SQLSMALLINT;
    colType:SQLSMALLINT;
    Scale:SQLSMALLINT;
    FieldDef:TFieldDef; */

    Function ExecSQL:SQLRETURN;
    Var s:String;
        c:CString;
        t:LongInt;
    Begin
      s:='call '+StoredProcName+'(';
      For t:=0 To FParams.Count-1 Do
        Begin
          Param:=FParams[t];
          If Param.ParamType=ptResultSet Then
            Begin
              ReturnsResultSet:=True;
              continue;
            End;
          If ((Param.ParamType=ptResult)And(s[1]<>'?'))
            Then s:='?='+s
            Else
              Begin
                If s[length(s)]<>'(' Then s:=s+',';
                s:=s+'?';
              End;
        End;

      s:='{'+s+')}';
      c:=s;
//    Result:=fODBC.SQLExecDirect(fODBC.ahstmt,c,SQL_NTS);
    End;

    Procedure BindParameters;
    Var i:LongInt;
        Param:TParam;
    Begin
      For i:=0 To FParams.Count-1 Do
        Begin
           Param:=FParams[i];

          Case Param.ParamType Of
             ptInput:ptsql:=SQL_PARAM_INPUT;
             ptOutput:ptsql:=SQL_PARAM_OUTPUT;
             ptResult:
             Begin
               ptsql:=SQL_PARAM_OUTPUT;
             End;
             ptInputOutput:ptsql:=SQL_PARAM_INPUT_OUTPUT;
             Else Continue; //Next Parameter
          End;

          Case Param.DataType Of
             ftString:
             Begin
                  sqlType:=SQL_CHAR;
                  cType:=SQL_C_CHAR;
                  p:=@Param.FResultNTS;
                  Param.FResultNTS:=Param.AsString;
                  Len:=Length(Param.FResultNTS);
                  Param.FOutLen:=SQL_NTS;
             End;
             ftCurrency:
             Begin
                  sqlType:=SQL_NUMERIC;
                  cType:=SQL_C_FLOAT;
                  Len:=10;
                  p:=@Param.FResultExtended;
                  Param.FResultExtended:=Param.AsFloat;
                  Param.FOutLen:=10;
             End;
             ftInteger:
             Begin
                  sqlType:=SQL_INTEGER;
                  cType:=SQL_C_LONG;
                  Len:=4;
                  p:=@Param.FResultLongInt;
                  Param.FResultLongInt:=Param.AsInteger;
                  Param.FOutLen:=4;
             End;
             ftSmallInt:
             Begin
                  sqlType:=SQL_SMALLINT;
                  cType:=SQL_C_SHORT;
                  Len:=2;
                  p:=@Param.FResultSmallInt;
                  Param.FResultSmallInt:=Param.AsSmallInt;
                  Param.FOutLen:=2;
             End;
             ftFloat:
             Begin
                  sqlType:=SQL_FLOAT;
                  cType:=SQL_C_FLOAT;
                  Len:=10;
                  p:=@Param.FResultExtended;
                  Param.FResultExtended:=Param.AsFloat;
                  Param.FOutLen:=10;
             End;
             ftDate:
             Begin
                  sqlType:=SQL_DATE;
                  cType:=SQL_C_DATE;
                  Len:=sizeof(Param.FResultDate);
                  p:=@Param.FResultDate;
                  DecodeDate(Param.AsDate,Param.FResultDate.Year,Param.FResultDate.Month,Param.FResultDate.Day);
                  Param.FOutLen:=sizeof(Param.FResultDate);
             End;
             ftTime:
             Begin
                  sqlType:=SQL_TIME;
                  cType:=SQL_C_TIME;
                  Len:=sizeof(Param.FResultTime);
                  p:=@Param.FResultTime;
                  RoundDecodeTime(Param.AsTime,Param.FResultTime.Hour,Param.FResultTime.Minute,Param.FResultTime.Second);
                  Param.FOutLen:=sizeof(Param.FResultTime);
             End;
             ftDateTime:
             Begin
                  sqlType:=SQL_TIMESTAMP;
                  cType:=SQL_C_TIMESTAMP;
                  Len:=sizeof(Param.FResultDateTime);
                  p:=@Param.FResultDateTime;
                  DecodeDate(Param.AsDate,Param.FResultDateTime.Year,Param.FResultDateTime.Month,Param.FResultDateTime.Day);
                  RoundDecodeTime(Param.AsTime,Param.FResultDateTime.Hour,Param.FResultDateTime.Minute,Param.FResultDateTime.Second);
                  Param.FOutLen:=sizeof(Param.FResultDateTime);
             End;
             ftMemo:
             Begin
                  sqlType:=SQL_LONGVARCHAR;
                  cType:=SQL_C_CHAR;
                  Len:=0; //??
                  p:=Nil; //???
                  Param.FOutLen:=0; //?? current len
             End;
             ftBlob:
             Begin
                  sqlType:=SQL_VARBINARY;
                  cType:=SQL_C_BINARY;
                  Len:=0; //??
                  p:=Nil; //???
                  Param.FOutLen:=0; //?? current len
             End;
             ftGraphic:
             Begin
                  sqlType:=SQL_VARGRAPHIC;
                  cType:=SQL_C_BINARY;
                  Len:=0; //??
                  p:=Nil; //???
                  Param.FOutLen:=0; //?? current len
             End;
          End; //case

/*          Try
             rc:=fODBC.SQLBindParameter(fODBC.ahstmt,i+1,ptsql,ctype,sqltype,Len,0,p^,Len,Param.FOutLen);
             If rc=SQL_ERROR Then
             Begin
                 S:=SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,fODBC.ahstmt);
                 CloseStmt;
                 DoClose;
                 SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S);
             End;

          Except
             ON E:ESQLError Do
             Begin
                  CloseStmt;
                  ErrorBox(E.Message);
             End;
             Else
             Begin
                  CloseStmt;
                  Raise;
             End;
          End;
          If fODBC.ahstmt=0 Then
          Begin
               DoClose;
               exit;
          End;    */
     End;
    End;
Label err;
Begin
     If not Prepared Then Prepare;

     CloseStmt; //if previous proc returned a result set...
     FMaxRows:=0;
     If not FOpened Then DoOpen;

/*     If FOpened Then
     Begin
          fODBC.SQLAllocStmt(fODBC.ahdbc,fODBC.ahstmt);
          If fODBC.SQLSetStmtOption(fODBC.ahstmt,SQL_CURSOR_TYPE,SQL_CURSOR_KEYSET_DRIVEN)=SQL_ERROR THEN
          Begin
             //S:=SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,fODBC.ahstmt);
             //ErrorBox(S);
          End;
     End
     Else exit; */

     //Bind Parameters
     BindParameters;
/*     If fODBC.ahstmt=0 Then
     Begin
          DoClose;
          exit;
     End; */

     FFieldDefs.Clear;
     FCurrentRow:=-1;
     FCurrentField:=0;

     ReturnsResultSet:=False;

     EnterSQLProcessing;
     rc:=ExecSQL;

     If rc<>SQL_ERROR Then
     Begin
         For i:=0 To FParams.Count-1 Do
         Begin
             Param:=FParams[i];

             If Param.ParamType<>ptOutput Then
               If Param.ParamType<>ptInputOutput Then
                 If Param.ParamType<>ptResult Then continue;

             Case Param.DataType Of
               ftString:
               Begin
                    Param.AsString:=Param.FResultNTS;
               End;
               ftCurrency:
               Begin
                    Param.AsFloat:=Param.FResultExtended;
               End;
               ftInteger:
               Begin
                    Param.AsInteger:=Param.FResultLongInt;
               End;
               ftSmallInt:
               Begin
                    Param.AsSmallInt:=Param.FResultSmallInt;
               End;
               ftFloat:
               Begin
                    Param.AsFloat:=Param.FResultExtended;
               End;
               ftDate:
               Begin
                    Param.AsDate:=EncodeDate(Param.FResultDate.Year,Param.FResultDate.Month,Param.FResultDate.Day);
               End;
               ftTime:
               Begin
                    Param.AsTime:=EncodeTime(Param.FResultTime.Hour,Param.FResultTime.Minute,Param.FResultTime.Second,0);
               End;
               ftDateTime:
               Begin
                    Param.AsDateTime:=EncodeDate(Param.FResultDateTime.Year,Param.FResultDateTime.Month,Param.FResultDateTime.Day) +
                                      EncodeTime(Param.FResultDateTime.Hour,Param.FResultDateTime.Minute,Param.FResultDateTime.Second, 0);
               End;
               ftMemo:
               Begin
               End;
               ftBlob:
               Begin
               End;
               ftGraphic:
               Begin
               End;
             End; //case
         End; //for

         If ReturnsResultSet Then
         Begin
              {The driver determines the number of rows in the result set}
/*              rc:=fODBC.SQLFetch(fODBC.ahstmt);
              FMaxRows:=0;
              While ((rc<>SQL_NO_DATA_FOUND)And(rc<>SQL_ERROR)) Do
              Begin
                  inc(FMaxRows);
                  rc:=fODBC.SQLFetch(fODBC.ahstmt);
              End;
              fODBC.SQLFreeStmt(fODBC.ahstmt,SQL_DROP);
              fODBC.ahstmt:=0;

              {The driver recreates the result set}
              fODBC.SQLAllocStmt(fODBC.ahdbc,fODBC.ahstmt);
              If fODBC.SQLSetStmtOption(fODBC.ahstmt,SQL_CURSOR_TYPE,SQL_CURSOR_KEYSET_DRIVEN)=SQL_ERROR THEN
              Begin
                 //S:=SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,fODBC.ahstmt);
                 //ErrorBox(S);
              End;
              BindParameters;
              If fODBC.ahstmt=0 Then
              Begin
                  DoClose;
                  LeaveSQLProcessing;
                  exit;
              End;

              rc:=fODBC.SQLExecDirect(fODBC.ahstmt,c,SQL_NTS);
              If rc=SQL_ERROR Then goto err;

              Try
                 fODBC.SQLNumResultCols(fODBC.ahstmt,resultCols);
                 If resultCols=0 Then //Not A Select statement
                 Begin
                      CloseStmt;
                      SQLError(LoadNLSStr(SEmptyResultSet));
                 End
                 Else
                 Begin
                      {Store Result Columns}
                      For I := 0 To resultCols-1 Do
                      Begin
                            Size:=0;
                            fODBC.SQLDescribeCol(fODBC.ahstmt, I + 1, colName,
                              SizeOf(colName), colNameLen, colType, Size, Scale, Nil);
                            If Size>65535 Then Size:=4096;
                            S:=colName;

                            Case ColType Of
                               SQL_REAL:Size:=4;
                               SQL_FLOAT,SQL_DOUBLE,SQL_NUMERIC:Size:=8;
                            End; //case

                            FFieldDefs.Add(S, MapSQLType(colType), Size, False);

                            FieldDef := FFieldDefs[I];
                            FieldDef.Precision := Scale;
                      End;

                      FCurrentRow:=0;   {First Row}
                      FCurrentField:=0; {First field}
                 End;

                 Post;  //Commit All transactions Until here
                 DataChange(deDataBaseChanged);
              Except
                 ON E:ESQLError Do
                 Begin
                      CloseStmt;
                      LeaveSQLProcessing;
                      ErrorBox(E.Message);
                 End;
                 Else
                 Begin
                      CloseStmt;
                      LeaveSQLProcessing;
                      Raise;
                 End;
              End;

              //for result sets the statement must remain open... */
         End
         Else CloseStmt;

         LeaveSQLProcessing;
     End
     Else
     Begin
err:
          LeaveSQLProcessing;
/*          Try
             S:=SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,fODBC.ahstmt);
             CloseStmt;
             SQLError(LoadNLSStr(SErrorExecutingSQLStatement)+': '+S);
          Except
             ON E:ESQLError Do
             Begin
                  CloseStmt;
                  ErrorBox(E.Message);
             End;
             Else
             Begin
                  CloseStmt;
                  Raise;
             End;
          End; */
     End;
End;

Function TStoredProc.ParamByName(Const Value:String):TParam;
Begin
  Result := FParams.ParamByName(Value);
End;

Procedure TStoredProc.Prepare;
Begin
  If FParams.Count=0 Then SetDefaultParams;
  Prepared:=True;
End;


Procedure TStoredProc.UnPrepare;
Begin
  Prepared:=False;
End;


Procedure TStoredProc.DoOpen;

/* Var rc:SQLRETURN;
    S:String; */
Begin
     If Not FActive Then Exit;

/*     If Not FillDBProcs(FDBProcs) Then
     Begin
          ErrorBox(LoadNLSStr(SErrLoadingDB));
          Active:=False;
          Exit; {Error}
     End;
     fODBC.IsStoredProc:=True;

     If Not FOpened Then
     Begin
          Try
             If FBeforeOpen<>Nil Then FBeforeOpen(Self);

             fODBC.ahstmt:=0;
             fODBC.ahenv:=0;
             If AllocateDBEnvironment(FDBProcs)<>SQL_SUCCESS Then
             Begin
                  ErrorBox(LoadNLSStr(SErrAllocDBEnv)+'.'+
                           SQLErrorText(FDBProcs,fODBC.ahenv,0,0));
                  Active:=False;
                  Exit;
             End;

             {Connect To Server}
             fODBC.ahdbc:=0;
             If fODBC.SQLAllocConnect(fODBC.ahenv,fODBC.ahdbc)<>SQL_SUCCESS Then
             Begin
                  ErrorBox(LoadNLSStr(SErrAllocDBConnect)+'.'+
                            SQLErrorText(FDBProcs,fODBC.ahenv,0,0));
                  DoClose;
                  Exit;
             End;

             {Set autocommit OFF}
             If fODBC.SQLSetConnectOption(fODBC.ahdbc,SQL_AUTOCOMMIT,SQL_AUTOCOMMIT_OFF)<>SQL_SUCCESS Then
             Begin
                  ErrorBox(LoadNLSStr(SErrSettingDBOpts)+'.'+
                            SQLErrorText(FDBProcs,fODBC.ahenv,0,0));
                  DoClose;
                  Exit;
             End;

             {Connect}
             Try
                If fODBC.uid='' Then
                Begin
                     If fODBC.pwd='' Then
                       rc:=fODBC.SqlConnect(fODBC.ahdbc,fODBC.DataBase,SQL_NTS,
                                               Nil,0,Nil,0)
                     Else
                       rc:=fODBC.SqlConnect(fODBC.ahdbc,fODBC.DataBase,SQL_NTS,
                                               Nil,0,fODBC.pwd,SQL_NTS);
                End
                Else If fODBC.pwd='' Then
                Begin
                     rc:=fODBC.SqlConnect(fODBC.ahdbc,fODBC.DataBase,SQL_NTS,
                                             fODBC.uid,SQL_NTS,Nil,0);
                End
                Else rc:= fODBC.SqlConnect(fODBC.ahdbc,fODBC.DataBase,SQL_NTS,
                                              fODBC.uid,SQL_NTS,fODBC.pwd,SQL_NTS);
                If rc<>SQL_SUCCESS Then
                Begin
                     S:=SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,0);
                     DoClose;
                     SQLError(LoadNLSStr(SErrorDBConnecting)+' "'+DataBase+'".'+#13#10+S);
                End;
             Except
                ON E:ESQLError Do
                Begin
                     ErrorBox(E.Message);
                     Exit;
                End;
                Else Raise;
             End;

             FOpened:=True;
             If FAfterOpen<>Nil Then AfterOpen(Self);

             If FParams.Count=0 Then SetDefaultParams;
          Except
             Raise;
          End;
     End;    */
End;


Procedure TStoredProc.DoClose;
Var OldOpened:Boolean;
Begin
  Try
    If FBeforeClose<>Nil Then FBeforeClose(Self);

    OldOpened:=FOpened;
    TDataSet.DoClose;
    FOpened:=OldOpened;

    If FOpened Then
      Begin
        CloseStmt;
        Post;  //Commit All transactions
      End;

    FActive:=False;
    FDataSetLocked:=True;
    FFieldDefs.Clear;

    FDataSetLocked:=False;

/*  If fODBC.ahdbc<>0 Then
      Begin
        If FOpened Then
          If fODBC.SQLDisconnect(fODBC.ahdbc)<>SQL_SUCCESS Then
            ErrorBox('Disconnect error '+SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,0));
          If fODBC.SQLFreeConnect(fODBC.ahdbc)<>SQL_SUCCESS Then
            ErrorBox('FreeConnect error '+SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,0));
          fODBC.ahdbc:=0;
      End;

    If fODBC.ahenv<>0 Then
      Begin
        If fODBC.SQLFreeEnv(fODBC.ahenv)<>SQL_SUCCESS Then
          ErrorBox('FreeEnv error '+SQLErrorText(FDBProcs,fODBC.ahenv,fODBC.ahdbc,0));
            fODBC.ahenv:=0;
      End;   */

    FOpened:=False;
    DataChange(deDSNChanged);

    If FAfterClose<>Nil Then FAfterClose(Self);
  Except
    Raise;
  End;
End;


Procedure TStoredProc.Loaded;
Var OldOpen,OldActive:Boolean;
Begin
  Inherited Loaded;

  OldOpen:=FOpened;
  OldActive:=FActive;
  FActive:=True;
  DoOpen;
  If not OldOpen Then DoClose;
  FActive:=OldActive;
End;


Procedure TStoredProc.Delete;
Begin
End;


Procedure TStoredProc.Insert;
Begin
End;


Procedure TStoredProc.InsertRecord(Const values:Array Of Const);
Begin
  Try
    FDataChangeLock:=True;
    Insert;
  Finally
    FDataChangeLock:=False;
  End;
  SetFields(values);
End;


Function TStoredProc.UpdateFieldSelect(field:TField):Boolean;
Begin
  Result:=False;
End;

Initialization
  SQLProcessCount:=0;
  {Klassen registrieren}
  RegisterClasses([tDataset,TTable]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  25-Sep-04  WD         In das Projekt wieder aufgenommen
  27-Mai-05  WD         TTable.UpdateFieldSelect: Der Cursor stand beim Update auf dem falschen Satz
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
}

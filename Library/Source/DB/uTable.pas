Unit uTable;

Interface

Uses Classes, SysUtils, Grids, uStream,
     uString,
     uList;

Type
  tTab_FieldType = (Tab_ft_String, Tab_ft_LongWord, Tab_ft_Boolean,
                    Tab_ft_DateTime);

  tpTab_Header_Field_Def = ^trTab_Header_Field_Def;
  trTab_Header_Field_Def = Record
     Name             : String;
     TableName        : String;
     Typ              : tTab_FieldType;
     Length           : LongWord;
     NotNullFlag      : Boolean;
     PriKeyFlag       : Boolean;
     UniqueKeyFlag    : Boolean;
     MultipleKeyFlag  : Boolean;
     BlobFlag         : Boolean;
     UnsignedFlag     : Boolean;
     ZerofillFlag     : Boolean;
     BinaryFlag       : Boolean;
     EnumFlag         : Boolean;
     AutoincrementFlag: Boolean;
     TimestampFlag    : Boolean;
     SetFlag          : Boolean;
     NumFlag          : Boolean;
     PartKeyFlag      : Boolean;
     GroutFlag        : Boolean;
     UniqueFlag       : Boolean;
  End;

  tcTab_Header = Class
    private
      Function GetItems(iIndex : LongWord) : trTab_Header_Field_Def;
      Function getCount : LongWord;
      fHeaderList : tList;
    Public
      Function Add(iTab_Header_Field_Def : trTab_Header_Field_Def) : LongWord;
      Procedure Clear;

      Constructor Create; virtual;
      Destructor Destroy; override;

      Property Items[Index:LongWord] : trTab_Header_Field_Def Read GetItems; Default;
      Property Count : LongWord Read getCount;
  end;

  tcTable  = Class
    private
      fName       : String;
      fData       : tArrayPointer;
      fHeader     : tcTab_Header;
      fAffectCount: LongWord;

      Function getRowCount : LongWord;  { Zeile }
      Function getColCount : LongWord;  { Spalte }
      Function getSelect   : Boolean;

      Function gettoPChar(iCol, iRow : LongWord) : PChar;
      Function gettoString(iCol, iRow : LongWord) : String;
      Function gettoLongWord(iCol, iRow : LongWord) : LongWord;
      Function gettoDateTime(iCol, iRow : LongWord) : TDateTime;
      Function gettoBoolean(iCol, iRow : LongWord) : Boolean;

      Procedure setAffectCount(iValue : LongWord);

{      Procedure DataFreeItem(iSender: tobject; iRow:ppCharArray); }
      Procedure DataFreeItem(iSender: tobject; iRow:Pointer);
    public
      Function AddHeaderFieldDef(iTab_Header_Field_Def : trTab_Header_Field_Def) : LongWord;
      Function AddData(iData : ppCharArray) : LongWord;

      Procedure Clear;
      Procedure getStringGrid(iStringGrid : TStringGrid);
      Procedure getList(iList : tStrings; iCol: LongWord);
      Procedure getListStr(iList : tStrings; iSeperator : Char);
      Procedure getListID(iList : tStrings);

      Procedure getInMemorySteam(iCol, iRow : LongWord; iMemoryStream : tMemoryStream);
      Procedure getInStringList(iCol, iRow : LongWord; iStringList : tStringList);

      Procedure WriteCSV(iFileName : tFileName);

      Constructor Create(iName : String); virtual;
      Destructor Destroy; override;

      Property Name       : String  Read fName;
      Property ColCount   : LongWord Read getColCount;
      Property RowCount   : LongWord Read getRowCount;
      Property AffectCount: LongWord Read fAffectCount Write setAffectCount;
      Property Select     : Boolean Read getSelect;

      Property toPChar[iCol, iRow : LongWord]   : PChar     Read gettoPChar;
      Property toString[iCol, iRow : LongWord]  : String    Read gettoString;
      Property toLongWord[iCol, iRow : LongWord]: LongWord  Read gettoLongWord;
      Property toDateTime[iCol, iRow : LongWord]: TDateTime Read gettoDateTime;
      Property toBoolean[iCol, iRow : LongWord] : Boolean   Read gettoBoolean;
  end;

Implementation

{ ------------------------------ Tabelle ---------------------------------------- }

Function tcTable.gettoPChar(iCol, iRow : LongWord) : PChar;
{ Lesen der Daten aus dem Speicher
  iCol ... Spalte, iRow ... Zeile }

var Row : ppCharArray;

Begin
  Row:=fData.Row[iRow];
  Result:=Row[iCol];      
End;

Function tcTable.gettoString(iCol, iRow : LongWord) : String;
{ Lesen der Daten in String-Form
  iCol ... Spalte, iRow ... Zeile }

Begin
  Result:=strPas(getToPChar(iCol, iRow));
End;

Function tcTable.gettoLongWord(iCol, iRow : LongWord) : LongWord;
{ Lesen der Daten in LongWord-Form
  iCol ... Spalte, iRow ... Zeile }

Begin
  try
    Result:=strToInt(getToString(iCol, iRow))
  except
    Result:=0;
  end;
//  if fHeader.Items[iCol].Typ = Tab_ft_LongWord
//    then
//    else Result:=0;
End;


Function tcTable.gettoBoolean(iCol, iRow : LongWord) : Boolean;
{ Lesen der Daten in Boolean-Form
  iCol ... Spalte, iRow ... Zeile }

var s : String;

Begin
  s:=UpperCase(getToString(iCol, iRow));
  Result:= (s= '1') or (s='TRUE') or (s='T');

/*  case fHeader.Items[iCol].Typ of
    Tab_ft_LongWord : Result:= s='1';
    Tab_ft_String   : Begin
                        s:=UpperCase(s);
                        Result:= s='TRUE';
                      End;
  end; */
End;


Function tcTable.gettoDateTime(iCol, iRow : LongWord) : TDateTime;
{ Lesen der Daten in DateTime-Form
  iCol ... Spalte, iRow ... Zeile }

Var value : tStr20;

Begin
  if fHeader.Items[iCol].Typ = Tab_ft_Datetime
    then
      Begin
        Value:=getToString(iCol, iRow);
        Result:=EncodeDate(strtoInt(copy(Value,1,4)),      { Jahr }
                           strtoInt(copy(Value,6,2)),      { Monat }
                           strtoInt(copy(Value,9,2)));     { Tag }
      End
    else Result:=0;
End;

Procedure tcTable.getInMemorySteam(iCol, iRow : LongWord; iMemoryStream : tMemoryStream);

var Daten   : pChar;
    LenDaten: LongWord;

Begin
  iMemoryStream.Clear;
  Daten:=gettoPChar(iCol, iRow);
  LenDaten:=StrLen(Daten);
  iMemoryStream.WriteBuffer(Daten^, LenDaten);
  iMemoryStream.Position:=0;       // Zeigen auf den Anfang setzen.
End;

Procedure tcTable.getInStringList(iCol, iRow : LongWord; iStringList : tStringList);

Var MemoryStream : tMemoryStream;
    Daten        : String;

Begin
  iStringList.Clear;
  MemoryStream.Create;
  getInMemorySteam(iCol, iRow, MemoryStream);
  while MemoryStream.Position <MemoryStream.Size do
    Begin
      Daten:=MemoryStream.Readln;
      iStringList.Add(Daten);
    End;
  MemoryStream.Destroy;
End;


{ -------------------------------------------------------------------------------- }

Procedure tcTable.getList(iList : tStrings; iCol: LongWord);

var RowCou : LongWord;
    Row    : ppCharArray;

Begin
  iList.Clear;
  if (iCol>getColCount) or (getRowCount=0) then exit;
  for RowCou:=0 to getRowCount-1 do
    Begin
      Row:=fData.Row[RowCou];
      iList.Add(strPas(Row[iCol]));
    End;
End;

Procedure tcTable.getListStr(iList : tStrings; iSeperator : Char);

var RowCou : LongWord;
    ColCou : LongWord;
    MaxCol : LongWord;
    MaxRow : LongWord;
    Row    : ppCharArray;
    StRow  : String;

Begin
  iList.Clear;
  MaxCol:=getColCount-1;
  MaxRow:=getRowCount;
  if MaxRow=0 then exit;        // Keine Daten gefunden -> Funktion verlassen
  for RowCou:=0 to MaxRow-1 do
    Begin
      Row:=fData.Row[RowCou];
      StRow:=strPas(Row[0]);
      For ColCou:=1 to MaxCol do
        StRow:=StRow+iSeperator+strPas(Row[ColCou]);
      iList.Add(stRow);
    End;
End;

Procedure tcTable.getListID(iList : tStrings);

var RowCou : LongWord;
    MaxCol : LongWord;
    MaxRow : LongWord;
    Row    : ppCharArray;
    StRow  : String;
    IDRow  : LongInt;

Begin
  iList.Clear;
  MaxRow:=getRowCount;
  if MaxRow=0 then exit;
  MaxCol:=getColCount-1;
  for RowCou:=0 to MaxRow-1 do
    Begin
      Row:=fData.Row[RowCou];
//      Writeln('Row:', RowCou,', <',strpas(row[1]),'>');
      IDRow:=strToInt(strPas(Row[0]));
      StRow:=strPas(Row[1]);
      iList.AddObjectID(stRow, nil, IDRow)
    End;
End;

Procedure tcTable.getStringGrid(iStringGrid : TStringGrid);

var RowCou, ColCou: LongWord;
    Row           : ppCharArray;
    St            : String;

Begin
{  iStringGrid.Clear; }
  iStringGrid.RowCount := getRowCount+1;  { +1 wegen der öberschrift }
  iStringGrid.ColCount := getColCount;
  for ColCou:=0 to getColCount-1 do
    Begin
      St:=fHeader.Items[ColCou].Name+':';
      ST[1]:=UpCase(St[1]);
      iStringGrid.Cells[ColCou, 0]:=St;
      iStringGrid.ColWidths[ColCou]:=length(st)*10;
    End;
  if getRowCount=0 then exit;
  for RowCou:=0 to getRowCount-1 do
    Begin
      Row:=fData.Row[RowCou];
      for ColCou:=0 to getColCount-1 do
        iStringGrid.Cells[ColCou, RowCou+1]:=strPas(Row[ColCou]);
    End;
  iStringGrid.Refresh;
End;

{ -------------------------------------------------------------------------------- }

Procedure tcTable.WriteCSV(iFileName : tFileName);

var RowCou, ColCou: LongWord;
    Row           : ppCharArray;
    fs            : tFileStream;
    values        : AnsiString;
    len           : Integer;
    CRLF          : WORD;

Begin
  if getRowCount=0 then exit;
  CRLF := $0A0D;
  fs.Create(iFileName, fmCreate);
  for RowCou:=0 to getRowCount-1 do
    Begin
      Row:=fData.Row[RowCou];
      Values:='';
      for ColCou:=0 to getColCount-1 do
        Values:=Values+strPas(Row[ColCou])+';';
      len:=length(Values)-1;
      fs.WriteBuffer(PChar(Values)^,Len);
      fs.WriteBuffer(CRLF,2);
    End;
  fs.Destroy;
End;

{ -------------------------------------------------------------------------------- }

Function tcTable.getColCount : LongWord;
{ Anzahl der Spalten }

Begin
  Result := fHeader.Count;
End;

Function tcTable.getRowCount : LongWord;
{ Anzahl der Zeilen }

Begin
  Result := fData.RowCount;
End;

Procedure tcTable.setAffectCount(iValue : LongWord);
{ Anzahl der Zeilen die geaendert worden sind, nach einem "Update", "Insert"
  oder "Delete" }

Begin
  if (fHeader.Count=0) and (fData.RowCount=0)
    then fAffectCount := iValue
    else Writeln('tcTable.setAffectCount: Nicht erlaubt');
End;

Function tcTable.getSelect : Boolean;
{ Das SQL-Statement war ein "Select" }

Begin
  Result:=(fAffectCount = 0)  and (fData.RowCount<>0);
End;

Function tcTable.AddHeaderFieldDef(iTab_Header_Field_Def : trTab_Header_Field_Def): LongWord;
{ Neue Spalte hinzufuegen }

Begin
  Result := fHeader.Add(iTab_Header_Field_Def);
End;

Function tcTable.AddData(iData : ppCharArray) : LongWord;
{ Neue Zeile hinzufuegen }

Var col : LongWord;
    len : LongWord;
    Row : pPointerArray;

Begin
  if fData.RowCount=0 then
    fData.ColCount :=fHeader.Count;
  Row := fData.Add;
  for col:=0 to fHeader.Count-1 do
    Begin
      len:=strlen(iData[col])+1;  //      len:=fHeader.Items[col].Length+1;
      getMem(Row[col], len);
      if iData[col] = nil
        then fillchar(Row[col]^, len, 0)
        else move(iData[col]^, Row[col]^, len);
    End;
  Result:=fData.RowCount;
End;

Procedure tcTable.DataFreeItem(iSender: tobject; iRow : Pointer);
{ Wird aufgerufen wenn eine Zeile geloescht wird }

Var Row : pPointerArray absolute iRow;
    Col : LongWord;
    Len : LongWord;

Begin
{  writeln('Table: del:', strpas(Row[0])); }
  for col:=0 to fHeader.Count-1 do           { Einzelne felder ins Array Åbertragen }
    Begin
      len:=fHeader.Items[col].Length+1;
      freeMem(Row[col], len);
    End;
End;


Procedure tcTable.Clear;
{ Loeschen der Tabelle }

Begin
  fAffectCount:=0;
  fData.Clear;
  fHeader.Clear;
End;

Constructor tcTable.Create(iName : String);

Begin
{  Writeln('Table: Create'); }
  inherited Create;
  fName := iName;
  fHeader.Create;
  fData.Create;
  fData.OnFreeItem:=@DataFreeItem;
  Clear;
End;

Destructor tcTable.Destroy;

Begin
  fData.Destroy;
  fHeader.Destroy;
  inherited Destroy;
{  Writeln('Table: Destroy'); }
End;

{ ------------------------------ Header ---------------------------------------- }

Function tcTab_Header.GetItems(iIndex : LongWord) : trTab_Header_Field_Def;

Var pTab_Header_Field_Def : tpTab_Header_Field_Def;

Begin
  pTab_Header_Field_Def:= fHeaderList.items[iIndex];
  Result:=pTab_Header_Field_Def^;
End;

Function tcTab_Header.getCount : LongWord;

Begin
  Result:=fHeaderList.Count;
End;

Function tcTab_Header.Add(iTab_Header_Field_Def : trTab_Header_Field_Def) : LongWord;

Var pTab_Header_Field_Def : tpTab_Header_Field_Def;

begin
  New(pTab_Header_Field_Def);
  pTab_Header_Field_Def^ := iTab_Header_Field_Def;
  result:=fHeaderList.Add(pTab_Header_Field_Def);
end;

Procedure tcTab_Header.Clear;

Var pTab_Header_Field_Def : tpTab_Header_Field_Def;
    Cou : LongWord;

Begin
  if fHeaderList.Count =0 then exit;
  for cou:=0 to fHeaderList.Count-1 do
    Begin
      pTab_Header_Field_Def:= fHeaderList.items[cou];
      dispose(pTab_Header_Field_Def);
    End;
  fHeaderList.Clear;
End;

Constructor tcTab_Header.Create;

Begin
  inherited Create;
  fHeaderList.Create;
End;

Destructor tcTab_Header.Destroy;

Begin
  Clear;
  fHeaderList.Destroy;
  inherited Destroy;
End;


Initialization
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  29-Aug-04  WD         Neue Funktionen: getInMemorySteam und getInStringList
  17-Jan-04  WD         Einabu der Funktionen "getListStr" und "getListID"
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  04-Jan-09  PE         tcTable.WriteCSV: korrigiert.
}



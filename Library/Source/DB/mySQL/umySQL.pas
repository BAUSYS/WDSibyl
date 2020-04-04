Unit umySQL;

Interface

Uses SysUtils, Classes,Dialogs,
     uList,
     umySQLDLL,
     uTable,
     uString,
     uSysClass;

type
  EmySQLError=Class(Exception);

{ anfangen mit 0; taFieldType = (FIELD_TYPE_DECIMAL, FIELD_TYPE_TINY,
                 FIELD_TYPE_SHORT,  FIELD_TYPE_LONG, FIELD_TYPE_FLOAT,
                 FIELD_TYPE_DOUBLE,
                        FIELD_TYPE_NULL,   FIELD_TYPE_TIMESTAMP,
                        FIELD_TYPE_LONGLONG,FIELD_TYPE_INT24,
                        FIELD_TYPE_DATE,   FIELD_TYPE_TIME,
                        FIELD_TYPE_DATETIME, FIELD_TYPE_YEAR,
                        FIELD_TYPE_NEWDATE,
                        FIELD_TYPE_ENUM=247,
                        FIELD_TYPE_SET=248,
                        FIELD_TYPE_TINY_BLOB=249,
                        FIELD_TYPE_MEDIUM_BLOB=250,
                        FIELD_TYPE_LONG_BLOB=251,
                        FIELD_TYPE_BLOB=252,
                        FIELD_TYPE_VAR_STRING=253,
                        FIELD_TYPE_STRING=254
}

  tcmySQL = Class
    private
      fmySQLDLL   : tcmySQLDll;
      fmySQL      : tpMYSQL;
      fmySQLResult: tpMYSQL_RESULT;

      fFieldCount : LongWord;
      fQuerySelect: Boolean;

      fHost    : String;
      fUser    : String;
      fPassword: String;
      fDatabase: String;
      fConnect : Boolean;
      foLog    : tcLog;

      Procedure Error(iMessage : String);

      Function GetHeaderFieldDef(iIndex : LongInt) : trTab_Header_Field_Def;

    public
      Constructor Create(iHost, iDatabase, iUser, iPassword : String); virtual;
      Destructor Destroy; override;

      Function Ping : Boolean;
      Function QueryCStr(iSQL : PChar) : LongWord;
      Function QueryStrings(iSQL : TStrings) : LongWord;
      Function Query(iSQL : String) : LongWord;
      Procedure FreeResult;
      Function FetchRow : ppCharArray;
      Function FetchRowList(iList : tList) : LongWord;   { var iRow : tpMYSQL_ROW }

      property Log        : tcLog          Read foLog Write foLog;
      property mySQLLDLL  : tcmySQLDll     Read fmySQLDLL;

      Property mySQL      : tpMYSQL        Read fmySQL;
      Property mySQLResult: tpMYSQL_RESULT Read fmySQLResult;

      Property FieldCount : LongWord       Read fFieldCount;
      Property QuerySelect: Boolean        Read fQuerySelect;
      Property Connect    : Boolean        Read fConnect;

      Property Database   : String         Read fDatabase;

      Property HeaderFieldDef[Index:LongInt] : trTab_Header_Field_Def Read GetHeaderFieldDef;
    end;

Implementation

Procedure tcmySQL.Error(iMessage : String);

Var ErrText : String;

Begin
  if fmySQL = nil
    then ErrText := iMessage
    else ErrText := 'Error (' + iMessage + ') :' +
                    tostr(FMYSQLDLL.FUNC.ERRNO(fMYSQL)) + ' - ' +
                    strpas(fmySQLDLL.Func.Error(fmySQL));
  if foLog <>nil then foLog.Writeln('Error:' + ErrText);
  Raise EmySQLError.Create(errText);
End;

Function tcmySQL.GetHeaderFieldDef(iIndex : LongInt) : trTab_Header_Field_Def;

Var FieldDef : tpMYSQL_FIELD;

Begin
  fillChar(Result, sizeof(trTab_Header_Field_Def), #0);
  if fFieldCount = 0 then exit;
  if (iIndex < 0) or (iIndex > fFieldCount) then
    Begin
      Writeln('Falscher Index:', iIndex);
      Exit;
    End;
  FieldDef := fmySQLDLL.Func.Fetch_Field_Direct(fmySQLResult, iIndex);
  Result.Name      := StrPas(FieldDef^.fName);
  Result.TableName := StrPas(FieldDef^.Table);
  Case FieldDef^.fType of
    1,3, 168 : Result.Typ := Tab_ft_LongWord;
    10,11,12 : Result.Typ := Tab_ft_Datetime;
    253, 254 : Result.Typ := Tab_ft_String;
    else       Result.Typ := Tab_ft_String;
  end;
  Result.Length := FieldDef^.max_length;
  Result.NotNullFlag      := (FieldDef^.flags and cNOT_NULL_FLAG) = cNOT_NULL_FLAG;
  Result.PriKeyFlag       := (FieldDef^.flags and cPRI_KEY_FLAG) = cPRI_KEY_FLAG;
  Result.UniqueKeyFlag    := (FieldDef^.flags and cUNIQUE_KEY_FLAG) = cUNIQUE_KEY_FLAG;
  Result.MultipleKeyFlag  := (FieldDef^.flags and cMULTIPLE_KEY_FLAG) = cMULTIPLE_KEY_FLAG;
  Result.BlobFlag         := (FieldDef^.flags and cBLOB_FLAG) = cBLOB_FLAG;
  Result.UnsignedFlag     := (FieldDef^.flags and cUNSIGNED_FLAG) = cUNSIGNED_FLAG;
  Result.ZerofillFlag     := (FieldDef^.flags and cZEROFILL_FLAG) = cZEROFILL_FLAG;
  Result.BinaryFlag       := (FieldDef^.flags and cBINARY_FLAG) = cBINARY_FLAG;
  Result.EnumFlag         := (FieldDef^.flags and cENUM_FLAG) = cENUM_FLAG;
  Result.AutoincrementFlag:= (FieldDef^.flags and cAUTO_INCREMENT_FLAG) = cAUTO_INCREMENT_FLAG;
  Result.TimestampFlag    := (FieldDef^.flags and cTIMESTAMP_FLAG) = cTIMESTAMP_FLAG;
  Result.SetFlag          := (FieldDef^.flags and cSET_FLAG) = cSET_FLAG;
  Result.NumFlag          := (FieldDef^.flags and cNUM_FLAG) = cNUM_FLAG;
  Result.PartKeyFlag      := (FieldDef^.flags and cPART_KEY_FLAG) = cPART_KEY_FLAG;
  Result.GroutFlag        := (FieldDef^.flags and cGROUP_FLAG) = cGROUP_FLAG;
  Result.UniqueFlag       := (FieldDef^.flags and cUNIQUE_FLAG) = cUNIQUE_FLAG;
End;

Function tcmySQL.Query(iSQL : String) : LongWord;

var cStr : cString;

Begin
  if foLog <>nil then foLog.Writeln('Query: '+iSQL);
  cStr:=iSQL;
  Result:=QueryCStr(@cStr);
  if foLog <>nil then foLog.Writeln('Query-Ende: ' +toStr(Result));
End;

/*
Var oSQL : tStringList;

Begin
  oSQL.Create;
  oSQL.Add(iSQL);
  Result:=QueryStrings(oSQL);
  oSQL.Destroy;
End; */

Function tcmySQL.QueryStrings(iSQL : TStrings) : LongWord;

Var SQL   : PChar;
    cSQL  : cString;
    cou   : LongInt;
    mem   : LongWord;

Begin
  if foLog <>nil then foLog.Writeln('QueryStrings-Start');
  if fmySQLResult<>nil then
    FreeResult;                      { Letzte Abfrage loeschen }
  Result:=0;
  if iSQL.Count<0 then exit;         { Kein Text }

{ Speicher bereich berechnen }
  mem:=0;
  for cou:=0 to iSQL.Count-1 do
    Begin
      if foLog <>nil then foLog.Writeln(tostr(cou)+': ' + iSQL.Strings[cou]);
      mem:=mem+length(iSQL.Strings[cou])+2;
    End;
  GetMem(SQL, mem);

{ Zusammenkopieren der Zeilen in ein C-String }
  if foLog <>nil then foLog.Writeln('QueryStrings: Zusammenkopieren: '+tostr(iSQL.Count)+', '+tostr(mem));
  for cou:=0 to iSQL.Count-1 do
    Begin
      cSQL := iSQL.Strings[cou] + ' ';
      strcat(SQL, @cSQL);
    End;
  if foLog <>nil then foLog.Writeln('QueryStrings: SQL='+strpas(SQL));

{ AusfÅhren des C-Strings (SQL-Statement) }
  if foLog <>nil then foLog.Writeln('QueryStrings: QueryCStr');
  Result:=QueryCStr(SQL);

{ Speicher von C-String wieder freigeben }
  FreeMem(SQL, mem);

  if foLog <>nil then foLog.Writeln('QueryStrings-Ende:' + toStr(Result));
End;

Function tcmySQL.QueryCStr(iSQL : PChar) : LongWord;

Begin
  if foLog <>nil then foLog.Writeln('QueryStringsCStr-Start');

{ AusfÅhren des C-Strings (SQL-Statement) }
  if fmySQLDLL.Func.query(fmySQL, iSQL) = 0
    then
      Begin
        fFieldCount:=fmySQLDLL.Func.Field_Count(fmySQL);
        if fFieldCount = 0
          then
            Begin
              fQuerySelect := false;
              Result:=fmySQLDLL.Func.Affected_Rows(fmySQL);
            End
          else
            Begin
              fQuerySelect := true;
              fmySQLResult:=fmySQLDLL.Func.Store_Result(fmySQL);
              Result:=fmySQLDLL.Func.Num_Rows(fmySQLResult);
            End;
      End
    else Error('QueryStrings');

  if foLog <>nil then foLog.Writeln('QueryStringsCStr-Ende:' + toStr(Result));
End;


Function tcmySQL.FetchRow : ppCharArray;

Var Row : tpMYSQL_ROW;

Begin
  Result := nil;
  if fmySQLResult=nil then exit;   { Es gibt kein Ergebnis }

  Row:=fmySQLDLL.Func.Fetch_Row(fmySQLResult);
  if Row=nil then exit;           { Kein neuer Satz }

  Result:=Row;
End;

Function tcmySQL.FetchRowList(iList : tList) : LongWord;

Var Row : tpMYSQL_ROW;
    col : LongWord;

Begin
  iList.Clear;
  Result:=0;
  if fmySQLResult=nil then exit;   { Es gibt kein Ergebnis }

  Row:=fmySQLDLL.Func.Fetch_Row(fmySQLResult);
  if Row=nil then exit;           { Kein neuer Satz }

  for col:=0 to fFieldCount-1 do
    iList.Add(Row^[col]);

  Result:=fFieldCount;
End;

Procedure tcmySQL.FreeResult;

Var dump: Pointer;

Begin
  if fmySQLResult<> nil then
    Begin
      dump:=fmySQLDLL.Func.Free_Result(fmySQLResult);
      fmySQLResult:=nil;
      fFieldCount:=0;
    End;
End;

Function tcmySQL.Ping : Boolean;

Begin
  Writeln(fmySQLDLL.Func.Ping(fmySQL));
  Result:=false;
End;

Constructor tcmySQL.Create(iHost, iDatabase, iUser, iPassword : String);

Var Host    : CString;
    User    : CString;
    Password: CString;
    Database: CString;
    Error   : PChar;

Begin
  inherited Create;
  fConnect := false;
  fHost    := iHost;
  fUser    := iUser;
  fPassword:= iPassword;
  fDatabase:= iDatabase;

  Host    := iHost;
  User    := iUser;
  Password:= iPassword;
  Database:= iDatabase;

  fFieldCount := 0;

  fmySQLResult:=nil;
  fmySQLDLL.Create;
  if fmySQLDLL.DLLLoaded then
    Begin
      fmySQL:=fmySQLDLL.Func.Init(nil);
      fConnect:= fmySQLDLL.Func.Real_Connect(fmySQL,
                    @Host, @User, @Password, @Database, 0, nil, 0) = fmySQL;
      if fConnect=false then
        Begin
          Error:=fmySQLDLL.Func.Error(fmySQL);
          ErrorBox('tcmySQL.Create:'+strPas(Error));
        End;

//      if fconnect=false then Error('tcmySQL.Create');
    End;
End;


Destructor tcmySQL.Destroy;

var x : Pointer;

Begin
  x:=fmySQLDLL.Func.Disconnect(fmySQL);
  fmySQL:=nil;
  fmySQLDLL.Destroy;
  inherited Destroy;
End;

Initialization
End.

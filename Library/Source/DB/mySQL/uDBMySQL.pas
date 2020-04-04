Unit uDBMySQL;

Interface

Uses Classes, SysUtils,
     uString, uSysClass,
     umySQL, uTable;

type
  tcDatabase = Class
    private
      fmySQL  : tcmySQL;
      fConnect: Boolean;
      fLog    : tcLog;

      Procedure SetLog(ioLog : tcLog);
      Function getName : String;
      Function GetDLLName : tFilename;

    public
      Constructor Create; virtual;
      Destructor Destroy; override;
      Function Use(iHost, iDatenbank, iUser, iPasswort : String) : Boolean;
      Function Query(iSQL : String; iTable : tcTable) : LongWord;
      Function QueryStrings(iSQL : tStringList; iTable : tcTable) : LongWord;
      Function ExistRecord(iTable, iField, iValue : String) : Boolean;
      Function ExistTable(iTableName : String) : Boolean;

      Function GetTableList(iTableList : tStrings) : LongWord;
      Function GetTableValues(iTableName : String; iTable : tcTable) : LongWord;

      property Log    : tcLog     Read fLog Write setLog;
      property DLLName: tFilename Read GetDLLName;

      Property Connect: Boolean   Read fConnect;
      Property Name   : String    Read getName;
  End;

Implementation

Function tcDatabase.GetTableList(iTableList : tStrings) : LongWord;

Var Data : ppCharArray;

Begin
  iTableList.Clear;
  Result:=fmySQL.Query('Show Tables');
  Data:=fmySQL.FetchRow;
  while Data<>nil do
    Begin
      iTableList.Add(strPas(Data^[0]));
      Data:=fmySQL.FetchRow;
    End;
  fmySQL.FreeResult;
End;

Function tcDatabase.GetTableValues(iTablename : String; iTable : tcTable) : LongWord;

Var SQL : String;

Begin
  if iTableName='' then exit;
  SQL:='Select * from ' + iTableName;
  Result:=Query(SQL, iTable);
End;

Function tcDatabase.ExistTable(iTableName : String) : Boolean;

Var Tabellen : tStringList;
    tmp      : LongInt;

Begin
  Result:=false;
  if iTableName ='' then exit;
  Tabellen.Create;
  Tabellen.CaseSensitive:=false;
  GetTableList(Tabellen);
  Result:=Tabellen.Find(iTableName, tmp);
  Tabellen.Destroy;
End;

Function tcDatabase.ExistRecord(iTable, iField, iValue : String) : Boolean;

Var SQL    : String;
    NumRows: LongWord;
    Data   : ppCharArray;

Begin
  Result:=false;
  SQL:='select distinct "true" from ' + iTable +
       ' where ' + iField + '= "' + iValue + '"';
  NumRows:=fmySQL.Query(SQL);
  Data:=fmySQL.FetchRow;
  Result:=(NumRows>0) and (Data^[0]<>nil);
  fmySQL.FreeResult;
End;

Function tcDatabase.QueryStrings(iSQL : tStringList; iTable : tcTable) : LongWord;

Var cou    : LongInt;
    Data   : ppCharArray;

Begin
  if fLog<>nil then flog.Writeln('QueryStrings');
  iTable.Clear;
  Result:=fmySQL.QueryStrings(iSQL);
{  Writeln('Anzahl der Rows:',Result); }
  if fmySQL.QuerySelect = false then
    Begin
      iTable.AffectCount := Result;
      exit;
    End;

{ Headerinformationen laden }
  For cou:=0 to fmySQL.FieldCount-1 do
    iTable.AddHeaderFieldDef(fmySQL.HeaderFieldDef[cou]);

{ Daten abspeichern }
  Data:=fmySQL.FetchRow;
  while Data<>nil do
    Begin
      iTable.AddData(Data);
      Data:=fmySQL.FetchRow;
    End;
  fmySQL.FreeResult;
{  Writeln('Daten:',iTabelle.RowCount); }
  if fLog<>nil then flog.Writeln('QueryStrings-Ende: ' + toStr(Result));
End;

Function tcDatabase.Query(iSQL : String; iTable : tcTable) : LongWord;

Var oSQL : tStringList;

Begin
  oSQL.Create;
  oSQL.Add(iSQL);
  if fLog<>nil then flog.Writeln('tcDatabase.Query: '+iSQL + ', '+ tohex(longWord(iTable)));
  Result:=QueryStrings(oSQL, iTable);
  oSQL.Destroy;
  if fLog<>nil then flog.Writeln('tcDatabase.Query: '+toStr(Result));
End;

Procedure tcDatabase.SetLog(ioLog : tcLog);

Begin
  if ioLog=nil then exit;
  fLog:=ioLog;
  if fmySQL<>nil
    then fmySQL.Log:=ioLog;
End;

Function tcDatabase.getName : String;

Begin
  Result:=fmySQL.Database;            
End;

Function tcDatabase.GetDLLName : tFilename;

Begin
  Result:=fmySQL.mySQLLDLL.FileName;
End;

Function tcDatabase.Use(iHost, iDatenbank, iUser, iPasswort : String) : Boolean;

Begin
  result:=false;
  if fmySQL<>nil then fmySQL.Destroy;
  try
    fmySQL.Create(iHost, iDatenbank, iUser, iPasswort);
    fmySQL.Log:=fLog;
    fConnect := fmySQL.Connect;
    if fLog<>nil then fLog.Writeln('Use: '+iHost+', '+iDatenbank+', '+
                           iUser+' ==> '+
                           iif(fConnect,'Connect','Not Connect'));
    result:=fConnect;
  except
    if fLog<>nil then fLog.Writeln('Use-Error: '+iHost+', '+iDatenbank+', '+
                           iUser+' ==> '+
                           iif(fConnect,'Connect','Not Connect'));
    on e:EFileNotFound do
      Begin
        if fLog<>nil then fLog.Writeln('File mySQL not found.');
        Halt(2);
      End;
  end;
End;

Constructor tcDatabase.Create;

Begin
  inherited Create;
  fLog:=nil;
  fmySQL:=nil;
End;


Destructor tcDatabase.Destroy;

Begin
  if fmySQL <> nil then fmySQL.Destroy;
  inherited Destroy;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  11-Aug-04   WD        Umbennen von tcDatenbank auf tcDatabase
}
Unit umySQLDll;

Interface         

Uses SysUtils, uSysInfo, uSysClass;

const cMYSQL_ERRMSG_SIZE   = 200;

{ Feld-Flag }
      cNOT_NULL_FLAG       = 1;     { Field can't be NULL }
      cPRI_KEY_FLAG        = 2;     { Field is part of a primary key }
      cUNIQUE_KEY_FLAG     = 4;     { Field is part of a unique key }
      cMULTIPLE_KEY_FLAG   = 8;     { Field is part of a key }
      cBLOB_FLAG           = 16;    { Field is a blob }
      cUNSIGNED_FLAG       = 32;    { Field is unsigned }
      cZEROFILL_FLAG       = 64;    { Field is zerofill }
      cBINARY_FLAG         = 128;
      cENUM_FLAG           = 256;   { field is an enum }
      cAUTO_INCREMENT_FLAG = 512;   { field is a autoincrement field }
      cTIMESTAMP_FLAG      = 1024;  { Field is a timestamp }
      cSET_FLAG            = 2048;  { field is a set }
      cNUM_FLAG            = 32768; { Field is num (for clients) }
      cPART_KEY_FLAG       = 16384; { Intern; Part of some key }
      cGROUP_FLAG          = 32768; { Intern: Group field }
      cUNIQUE_FLAG         = 65536;


type mysql_status = (MYSQL_STATUS_READY,MYSQL_STATUS_GET_RESULT, MYSQL_STATUS_USE_RESULT);

     tpUSED_MEM = ^trUSED_MEM;
     trUSED_MEM = record                { struct for once_alloc }
                    next : tpUSED_MEM;  { Next block in use }
                    left : Word;        { memory left in block }
                    size : Word;        { size of block }
                  end;
     tpPMEM_ROOT =^trMEM_ROOT;
     trMEM_ROOT = record
                    free          : tpUSED_MEM;
                    used          : tpUSED_MEM;
                    min_malloc    : Word;
                    block_size    : Word;
                    error_handler : procedure;
                  end;

     tpPNET = ^trNET;
     trNET = record
               fd                 : Integer;
               fcntl              : Integer;
               buff, buff_end     : ^BYTE;
               write_pos          : ^BYTE;
               last_error         : Array[0..cMYSQL_ERRMSG_SIZE-1] of Char;
               last_errno         : Word;
               max_packet,timeout : Word;
               pkt_nr             : Word;
               error, return_errno: Boolean;
             end;


{$IFDEF OS2}
     tpMYSQL_FIELD = ^trMYSQL_FIELD;
     trMYSQL_FIELD  = record
                        fname     : PChar;    { Name of column }
                        table     : PChar;    { Table of column if column was a field }
                        def       : PChar;    { Default value (set by mysql_list_fields) }
                        ftype     : Byte;     { Feldtype; Sollte Longword sein, aber bei den Test wurden falsche Daten in dump1 mitgeliefert }
                        dump1     : array[0..2] of byte;
                        length    : LongWord; { Width of column }
                        max_length: LongWord; { Max width of selected set }
                        flags     : Word;     { Div flags }
                        decimals  : Word;     { Number of decimals in field }
                      end;
{$ENDIF}
{$IFDEF Win32}
     tpMYSQL_FIELD = ^trMYSQL_FIELD;
     trMYSQL_FIELD  = record
                        fname     : PChar;    { Name of column }
                        table     : PChar;    { Table of column if column was a field }
                        org_table : PChar;    // Org table name if table was an alias
                        db        : PChar;    // Database for table
                        def       : PChar;    { Default value (set by mysql_list_fields) }
                        length    : LongWord; { Width of column }
                        max_length: LongWord; { Max width of selected set }
                        flags     : Word;     { Div flags }
                        decimals  : Word;     { Number of decimals in field }
                        dump1     : LongWord; // Keine Ahnung was da drinnen steht; Bei Tests war es notwendig }
                        ftype     : Byte;     { Feldtype }
                      end;
{$ENDIF}


     tpMYSQL_ROW =^trMYSQL_ROW;
     trMYSQL_ROW = tpCharArray;

     tpMYSQL_ROWS =^trMYSQL_ROWS;
     trMYSQL_ROWS = record
                      next : tpMYSQL_ROWS;             { list of rows }
                      data : tpMYSQL_ROW;
                    end;

     PMYSQL_DATA =^trMYSQL_DATA;
     trMYSQL_DATA = record
                      rows   : Word;
                      fields : Word;
                      data   : tpMYSQL_ROWS;
                      alloc  : trMEM_ROOT;
                    end;

     tpMYSQL =^trMYSQL;
     trMYSQL = record
                 net                 : trNET;          { Communication parameters }
                 host,user,passwd    : PChar;
                 unix_socket         : PChar;
                 server_version      : PChar;
                 host_info,info,db   : PChar;
                 port, client_flag   : Word;
                 server_capabilities : Word;
                 protocol_version    : Word;
                 field_count         : Word;
                 thread_id           : Word;          { Id for connection in server }
                 affected_rows       : LongWord;      { FrÅher: Cardinal }
                 insert_id           : LongWord;      { FrÅher: Cardinal } { id if insert on table with NEXTNR }
                 extra_info          : LongWord;      { Used by mysqlshow }
                 status              : mysql_status;
                 fields              : tpMYSQL_FIELD;
                 field_alloc         : trMEM_ROOT;
                 free_me             : boolean;       { If free in mysql_close }
                 reconnect           : boolean;       { set to 1 if automatic reconnect }
               end;

     tpMYSQL_RESULT =^trMYSQL_RESULT;
     trMYSQL_RESULT = record
                        row_count           : LongWord;      { FrÅher: Cardinal }
                        field_count         : Word;
                        current_field       : Word;
                        fields              : tpMYSQL_FIELD;
                        data                : PMYSQL_DATA;
                        data_cursor         : tpMYSQL_ROWS;
                        field_alloc         : trMEM_ROOT;
                        row                 : tpMYSQL_ROW;   { If unbuffered read }
                        current_row         : tpMYSQL_ROW;   { buffer to current row }
                        lengths             : ^Word;        { column lengths of current row }
                        handle              : tpMYSQL;       { for unbuffered reads }
                        eof                 : boolean;      { Used my mysql_fetch_row }
                      end;

  pmySQLFunc=^tmySQLFunc;
  tmySQLFunc=Record
    Init              : Function(mysql:tpMYSQL) : tpMYSQL; APIENTRY;
    Ping              : Function(mysql:tpMYSQL) : LongWord; APIENTRY;
    Real_Connect      : Function(mysql:tpMYSQL;const host,user,passwd,db :PChar;
                                 port:Word; const unix_socket:PChar; client_flag:Word):tpMYSQL; APIENTRY;
    Disconnect        : Function(mysql:tpMYSQL) : pointer; APIENTRY;
    Errno             : Function(mysql:tpMYSQL) : LongWord; APIENTRY;
    Error             : Function(mysql:tpMYSQL) : PChar; APIENTRY;

    Query             : Function(mysql:tpMYSQL;Const Query:PChar):LongInt;APIENTRY;
    Field_Count       : Function(mysql:tpMYSQL) : LongWord; APIENTRY;
    Affected_Rows     : Function(mysql:tpMySQL) : LongInt; APIENTRY;
    Num_Rows          : Function(hres :tpMYSQL_RESULT) : LongWord; APIENTRY;
    Store_Result      : Function(mysql:tpMySQL) : tpMYSQL_RESULT; APIENTRY;
    Free_Result       : Function(hres :tpMYSQL_RESULT) : Pointer; APIENTRY;
    Fetch_Field_Direct: Function(hres :tpMYSQL_RESULT; FieldNr :LongWord) : tpMYSQL_FIELD; APIENTRY;
    Fetch_Row         : Function(hres :tpMYSQL_RESULT) : tpMYSQL_ROW; APIENTRY;
  End;

  tcmySQLDLL = Class(tcDLL)
    private
      fmySQLFunc : tmySQLFunc;
{      Function GetProcAddress(const iProcName : String) : pointer; }
    Public
      Constructor Create; virtual;
      property Func : tmySQLFunc read fmySQLFunc;
  End;

Implementation

{$IFDEF OS2}
uses bsedos, bseErr, oS2Def;
{$ENDIF}

{Function tcmySQLDLL.GetProcAddress(const iProcName : String) : pointer;
         
Begin
  Write('GetProcAdress:' + iProcName);
  Result:=Pointer(inherited GetProcAddress(iProcName));
  Writeln('; Result:' + tostr(LongWord(Result)));
  if Result=nil                                         
    then Writeln('  nicht gefunden')
End;  }
  

Constructor tcmySQLDLL.Create;

var mySQLDLL: tFilename;
{$IFDEF OS2}
    Path : AnsiString;
    cDllName: cString;
    phmod: HMODULE;
    rv:ApiRet;
{$ENDIF}

Begin
{$IFDEF OS2}
  Path:=goSysInfo.Env['PATH'];
  mySQLDLL:=FileSearch('mySQL.DLL', Path);               // Version 3.25
  if mySQLDLL='' then
    Begin
      mySQLDLL:=FileSearch('mySQL40.DLL', Path);         // Version 4.0
      if mySQLDLL = '' then BEGIN
        mySQLDLL:=FileSearch('mySQL41.DLL', Path);         // Version 4.1
        if mySQLDLL='' then
          Begin
            mySQLDLL:=FileSearch('mySQL50.DLL', Path);     // Version 5.0
            if mySQLDLL='' then
              Begin
                mySQLDLL:=FileSearch('libmySQL.DLL', Path);  // Windows
                if mySQLDLL='' then
                  mySQLDLL:='mySQL50.DLL';                  // aktuelle MySQL-Version (OS/2)
              End;
          End;
      END;
    End;
{$ENDIF}
{$IFDEF WIN32}
  mySQLDLL:='libmySQL.DLL';
{$ENDIF}
  inherited Create(mySQLDLL);
  Upper:=false;
  if DLLLoaded then
    Begin
      fmySQLFunc.Init:=pointer(GetProcAddress('mysql_init'));
      fmySQLFunc.Ping:=pointer(GetProcAddress('mysql_ping'));
      fmySQLFunc.Real_Connect:=pointer(GetProcAddress('mysql_real_connect'));
      fmySQLFunc.Disconnect:=pointer(GetProcAddress('mysql_close'));
      fmySQLFunc.Query:=Pointer(GetProcAddress('mysql_query'));
      fmySQLFunc.Field_Count:=Pointer(GetProcAddress('mysql_field_count'));
      fmySQLFunc.Affected_Rows:=Pointer(GetProcAddress('mysql_affected_rows'));
      fmySQLFunc.Num_Rows:=Pointer(GetProcAddress('mysql_num_rows'));
      fmySQLFunc.Store_Result:=Pointer(GetProcAddress('mysql_store_result'));
      fmySQLFunc.Free_Result:=Pointer(GetProcAddress('mysql_free_result'));
      fmySQLFunc.Fetch_Field_Direct:=Pointer(GetProcAddress('mysql_fetch_field_direct'));
      fmySQLFunc.Fetch_Row:=Pointer(GetProcAddress('mysql_fetch_row'));

      fmySQLFunc.Errno:=Pointer(GetProcAddress('mysql_errno'));
      fmySQLFunc.Error:=Pointer(GetProcAddress('mysql_error'));
    End;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  30-Aug-04   WD        trMYSQL_FIELD: unters. zw. Windows (mySQL Ver. 4) und OS/2 (mySQL Ver.3)
  28-Aug-05   WD        Variablen die nicht verwendet werden entfernt.
  01-Apr-09   PE        Suchen nach der mySQL Verison 4.0 eingebaut.
}
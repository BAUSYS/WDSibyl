Unit DBLayer;

Interface

Uses SysUtils,
     uString, uList, uSysClass;

{$IFDEF OS2}
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}

Type SQLHENV = LongWord;
     SQLHDBC = LongWord;
     SQLHSTMT= LongWord;
     SQLHWND = LongWord;

     SWORD=Integer;
     UWORD=Word;
     SQLSMALLINT=SWORD;
     SQLUSMALLINT=UWORD;
     SQLUINTEGER=LongWord;
     SQLINTEGER=LongInt;
     SQLRETURN=SQLSMALLINT;
     SQLCHAR=cstring;
     SQLPOINTER=Pointer;

Const SQL_SUCCESS             =0;
      SQL_SUCCESS_WITH_INFO   =1;
      SQL_NO_DATA_FOUND       =100;
      SQL_NEED_DATA           =99;
      SQL_NO_DATA             =SQL_NO_DATA_FOUND;
      SQL_STILL_EXECUTING     =2;
      SQL_ERROR               =-1;
      SQL_INVALID_HANDLE      =-2;
      SQL_COMMIT              =0;
      SQL_ROLLBACK            =1;

    /* Options For SQLSetConnectOption/SQLGetConnectOption */
Const SQL_ACCESS_MODE              =101;
      SQL_AUTOCOMMIT               =102;
      SQL_LOGIN_TIMEOUT            =103;
      SQL_OPT_TRACE                =104;
      SQL_OPT_TRACEFILE            =105;
      SQL_TRANSLATE_DLL            =106;
      SQL_TRANSLATE_OPTION         =107;
      SQL_TXN_ISOLATION            =108;
      SQL_CURRENT_QUALIFIER        =109;
      SQL_ODBC_CURSORS             =110;
      SQL_QUIET_MODE               =111;
      SQL_PACKET_SIZE              =112;
      SQL_CONNECT_OPT_DRVR_START   =1000;

      SQL_PARAM_TYPE_UNKNOWN       =0;
      SQL_PARAM_INPUT              =1;
      SQL_PARAM_INPUT_OUTPUT       =2;
      SQL_RESULT_COL               =3;
      SQL_PARAM_OUTPUT             =4;
      SQL_RETURN_VALUE             =5;
      SQL_PARAM_RESULT             =6; //Oracle7

    /* Options For SQLGetConnectOption/SQLSetConnectOption extensions */
      SQL_WCHARTYPE                =1252;
      SQL_LONGDATA_COMPAT          =1253;
      SQL_CURRENT_SCHEMA           =1254;
      SQL_DB2EXPLAIN               =1258;
      SQL_DB2ESTIMATE              =1259;
      SQL_PARAMOPT_ATOMIC          =1260;
      SQL_STMTTXN_ISOLATION        =1261;
      SQL_MAXCONN                  =1262;

    /* Options For SQLSetConnectOption, SQLSetEnvAttr */
      SQL_CONNECTTYPE              =1255;
      SQL_SYNC_POINT               =1256;

    /* Options For SQL_LONGDATA_COMPAT */
      SQL_LD_COMPAT_YES            =1;
      SQL_LD_COMPAT_NO             =0;
      SQL_LD_COMPAT_DEFAULT        =SQL_LD_COMPAT_NO;

    /*  Options For SQL_PARAMOPT_ATOMIC*/
      SQL_ATOMIC_YES               =1;
      SQL_ATOMIC_NO                =0;
      SQL_ATOMIC_DEFAULT           =SQL_ATOMIC_YES;

    /* Options For SQL_CONNECT_TYPE */
      SQL_CONCURRENT_TRANS         =1;
      SQL_COORDINATED_TRANS        =2;
      SQL_CONNECTTYPE_DEFAULT      =SQL_CONCURRENT_TRANS;

    /* Options For SQL_SYNCPOINT */
      SQL_ONEPHASE                 =1;
      SQL_TWOPHASE                 =2;
      SQL_SYNCPOINT_DEFAULT        =SQL_ONEPHASE;

    /* Options For SQL_DB2ESTIMATE */
      SQL_DB2ESTIMATE_ON           =1;
      SQL_DB2ESTIMATE_OFF          =0;
      SQL_DB2ESTIMATE_DEFAULT      =SQL_DB2ESTIMATE_OFF;

    /* Options For SQL_DB2EXPLAIN */
      SQL_DB2EXPLAIN_ON            =1;
      SQL_DB2EXPLAIN_OFF           =0;
      SQL_DB2EXPLAIN_DEFAULT       =SQL_DB2EXPLAIN_OFF;

    /* Options For SQL_WCHARTYPE */
      SQL_WCHARTYPE_CONVERT        =1;
      SQL_WCHARTYPE_NOCONVERT      =0;
      SQL_WCHARTYPE_DEFAULT        =SQL_WCHARTYPE_NOCONVERT;

    /* SQL_ACCESS_MODE Options */
      SQL_MODE_READ_WRITE          =0;
      SQL_MODE_READ_ONLY           =1;
      SQL_MODE_DEFAULT             =SQL_MODE_READ_WRITE;

    /* SQL_AUTOCOMMIT Options */
      SQL_AUTOCOMMIT_OFF           =0;
      SQL_AUTOCOMMIT_ON            =1;
      SQL_AUTOCOMMIT_DEFAULT       =SQL_AUTOCOMMIT_ON;

    /* SQL_LOGIN_TIMEOUT Options */
      SQL_LOGIN_TIMEOUT_DEFAULT    =0;

    /* Column types And scopes In SQLSpecialColumns */
      SQL_BEST_ROWID               =1;
      SQL_ROWVER                   =2;

      SQL_SCOPE_CURROW             =0;
      SQL_SCOPE_TRANSACTION        =1;
      SQL_SCOPE_SESSION            =2;

    /* Defines For SQLStatistics */
      SQL_INDEX_UNIQUE             =0;
      SQL_INDEX_ALL                =1;

      SQL_QUICK                    =0;
      SQL_ENSURE                   =1;

    /* Defines For SQLStatistics (returned In the Result Set) */
      SQL_TABLE_STAT               =0;
      SQL_INDEX_CLUSTERED          =1;
      SQL_INDEX_HASHED             =2;
      SQL_INDEX_OTHER              =3;

    /* Defines For SQLSpecialColumns (returned In the Result Set) */
      SQL_PC_UNKNOWN               =0;
      SQL_PC_NOT_PSEUDO            =1;
      SQL_PC_PSEUDO                =2;

    /* SQLDataSources "fDirection" values, also used ON SQLExtendedFetch() */
    /* See sqlext.H For additional SQLExtendedFetch fetch Direction Defines */
      SQL_FETCH_NEXT             =1;
      SQL_FETCH_FIRST            =2;
      SQL_FETCH_LAST             =3;
      SQL_FETCH_PRIOR            =4;
      SQL_FETCH_ABSOLUTE         =5;
      SQL_FETCH_RELATIVE         =6;

    /* Special Length values  */
      SQL_NULL_DATA        =-1;
      SQL_DATA_AT_EXEC     =-2;
      SQL_NTS              =-3;      /* NTS = Null Terminated String    */

    /* SQLFreeStmt option values  */
      SQL_CLOSE               =0;
      SQL_DROP                =1;
      SQL_UNBIND              =2;
      SQL_RESET_PARAMS        =3;

    /* SQLColAttributes Defines */
      SQL_COLUMN_COUNT             =0;
      SQL_COLUMN_NAME              =1;
      SQL_COLUMN_TYPE              =2;
      SQL_COLUMN_LENGTH            =3;
      SQL_COLUMN_PRECISION         =4;
      SQL_COLUMN_SCALE             =5;
      SQL_COLUMN_DISPLAY_SIZE      =6;
      SQL_COLUMN_NULLABLE          =7;
      SQL_COLUMN_UNSIGNED          =8;
      SQL_COLUMN_MONEY             =9;
      SQL_COLUMN_UPDATABLE        =10;
      SQL_COLUMN_AUTO_INCREMENT   =11;
      SQL_COLUMN_CASE_SENSITIVE   =12;
      SQL_COLUMN_SEARCHABLE       =13;
      SQL_COLUMN_TYPE_NAME        =14;
      SQL_COLUMN_TABLE_NAME       =15;
      SQL_COLUMN_OWNER_NAME       =16;
      SQL_COLUMN_QUALIFIER_NAME   =17;
      SQL_COLUMN_LABEL            =18;
      SQL_COLUMN_SCHEMA_NAME      =SQL_COLUMN_OWNER_NAME;
      SQL_COLUMN_CATALOG_NAME     =SQL_COLUMN_QUALIFIER_NAME;
      SQL_COLUMN_DISTINCT_TYPE    =1250;

    /* SQLColAttributes Defines For SQL_COLUMN_UPDATABLE condition */
      SQL_ATTR_READONLY           = 0;
      SQL_ATTR_WRITE              = 1;
      SQL_ATTR_READWRITE_UNKNOWN  = 2;

    /* Standard SQL Data types */
      SQL_CHAR                =1;
      SQL_NUMERIC             =2;
      SQL_DECIMAL             =3;
      SQL_INTEGER             =4;
      SQL_SMALLINT            =5;
      SQL_FLOAT               =6;
      SQL_REAL                =7;
      SQL_DOUBLE              =8;
      SQL_DATE                =9;
      SQL_TIME               =10;
      SQL_TIMESTAMP          =11;
      SQL_VARCHAR            =12;

    /* SQL Extended Data types */
      SQL_LONGVARCHAR        =-1;
      SQL_BINARY             =-2;
      SQL_VARBINARY          =-3;
      SQL_LONGVARBINARY      =-4;
      SQL_BIGINT             =-5;  /* Not supported */
      SQL_TINYINT            =-6;  /* Not supported */
      SQL_BIT                =-7;  /* Not supported */
      SQL_GRAPHIC            =-95;
      SQL_VARGRAPHIC         =-96;
      SQL_LONGVARGRAPHIC     =-97;
      SQL_BLOB               =-98;
      SQL_CLOB               =-99;
      SQL_DBCLOB             =-350;

      SQL_SIGNED_OFFSET      =-20;
    SQL_UNSIGNED_OFFSET    =-22;

    /* C Data Type To SQL Data Type mapping */
      SQL_C_CHAR       =SQL_CHAR;      /* Char, VARCHAR, DECIMAL, NUMERIC */
      SQL_C_LONG       =SQL_INTEGER;   /* Integer                         */
      SQL_C_SHORT      =SQL_SMALLINT;  /* SMALLINT                        */
      SQL_C_FLOAT      =SQL_REAL;      /* Real                            */
      SQL_C_DOUBLE     =SQL_DOUBLE;    /* FLOAT, Double                   */
      SQL_C_DATE       =SQL_DATE;      /* date                            */
      SQL_C_TIME       =SQL_TIME;      /* Time                            */
      SQL_C_TIMESTAMP  =SQL_TIMESTAMP; /* TIMESTAMP                       */
      SQL_C_BINARY     =SQL_BINARY;    /* binary, VARGINARY               */
      SQL_C_BIT        =SQL_BIT;
      SQL_C_TINYINT    =SQL_TINYINT;
      SQL_C_DBCHAR     =SQL_DBCLOB;
      SQL_C_DEFAULT    =99;

    /* For ODBC compatibility only */
      SQL_C_SLONG      =SQL_C_LONG+SQL_SIGNED_OFFSET;
      SQL_C_SSHORT     =SQL_C_SHORT+SQL_SIGNED_OFFSET;
      SQL_C_STINYINT   =SQL_C_TINYINT+SQL_SIGNED_OFFSET;
      SQL_C_ULONG      =SQL_C_LONG+SQL_UNSIGNED_OFFSET;
      SQL_C_USHORT     =SQL_C_SHORT+SQL_UNSIGNED_OFFSET;
      SQL_C_UTINYINT   =SQL_C_TINYINT+SQL_UNSIGNED_OFFSET;

    /* generally useful constants */
      SQL_SQLSTATE_SIZE        = 5;   /* Size Of SQLSTATE, Not including
                                          Null terminating Byte           */
      SQL_MAX_MESSAGE_LENGTH   =1024; /* Message Buffer Size             */
      SQL_MAX_DSN_LENGTH       =32;   /* maximum Data Source Name Size   */
      SQL_MAX_ID_LENGTH        =18;   /* maximum identifier Name Size, */

    //SQLSetStmtOption values
      SQL_QUERY_TIMEOUT =0;
      SQL_MAX_ROWS      =1;
      SQL_NOSCAN        =2;
      SQL_MAX_LENGTH    =3;
      SQL_ASYNC_ENABLE  =4;
      SQL_BIND_TYPE     =5;
      SQL_CURSOR_TYPE   =6;
      SQL_CONCURRENCY   =7;
      SQL_KEYSET_SIZE   =8;
      SQL_ROWSET_SIZE   =9;
      SQL_SIMULATE_CURSOR =10;
      SQL_RETRIEVE_DATA =11;
      SQL_USE_BOOKMARKS =12;
      SQL_GET_BOOKMARK  =13;
      SQL_ROW_NUMBER    =14;

    //SQLScrollOptions
      SQL_SO_FORWARD_ONLY         = 1;
      SQL_SO_KEYSET_DRIVEN        = 2;
      SQL_SO_DYNAMIC              = 4;
      SQL_SO_MIXED                = 8;
      SQL_SO_STATIC               = 16;

    //CursorType
      SQL_CURSOR_FORWARD_ONLY     =0;
      SQL_CURSOR_KEYSET_DRIVEN    =1;
      SQL_CURSOR_DYNAMIC          =2;
      SQL_CURSOR_STATIC           =3;

      SQL_NO_NULLS                =0;
      SQL_NULLABLE                =1;
      SQL_NULLABLE_UNKNOWN        =2;


Type TODBCDate=Record
       Year,Month,Day:Word;
     End;
     TODBCTime=Record
       Hour,Minute,Second:Word;
     End;
     TODBCDateTime=Record
        Date:TODBCDate;
        Time:TODBCTime;
     End;

     trODBCFunc= Record
                   SQLAllocEnv:Function(Var phenv:SQLHENV):SQLRETURN;APIENTRY;
                   SQLAllocConnect:Function(ahenv:SQLHENV;Var phdbc:SQLHDBC):SQLRETURN;APIENTRY;
                   SQLConnect:Function(ahdbc:SQLHDBC;Const szDSN:SQLCHAR;
                                       cbDSN:LongInt;Const szUID:SQLCHAR;
                                       cbUID:LongInt;Const szAuthString:SQLCHAR;
                                       cbAuthString:LongInt):SQLRETURN;APIENTRY;
                   SQLDriverConnect:Function(ahdbc:SQLHDBC;HWindow:SQLHWND;
                                             Const szConnStrIn:SQLCHAR;cbConnStrIn:LongInt;
                                             Var szConnStrOut:SQLCHAR;cbConnStrOutMax:LongInt;
                                             Var pcbConnStrOut:SQLSMALLINT;
                                             fDriverCompletion:LongWord):SQLRETURN;APIENTRY;
                   SQLDataSources:Function(ahenv:SQLHENV;fDirection:LongWord;
                                           Var szDSN:SQLCHAR;cbDSNMax:LongInt;
                                           Var pcbDSN:SQLSMALLINT;
                                           Var szDescription:SQLCHAR;cbDescriptionMax:LongInt;
                                           Var pcbDescription:SQLSMALLINT):SQLRETURN;APIENTRY;
                   SQLGetInfo:Function(ahdbc:SQLHDBC;fInfoType:LongWord;Var rgbInfoValue;cbInfoValueMax:LongInt;
                                        Var pcbInfoValue:SQLSMALLINT):SQLRETURN;APIENTRY;
                   SQLGetFunctions:Function(ahdbc:SQLHDBC;fFunction:LongWord;Var pfExists:SQLUSMALLINT):SQLRETURN;APIENTRY;
                   SQLGetTypeInfo:Function(ahstmt:SQLHSTMT;fSQLType:LongInt):SQLRETURN;APIENTRY;
                   SQLSetConnectOption:Function(ahdbc:SQLHDBC;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
                   SQLGetConnectOption:Function(ahdbc:SQLHDBC;fOption:LongWord;Var pvParam):SQLRETURN;APIENTRY;
                   SQLSetStmtOption:Function(ahstmt:SQLHSTMT;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
                   SQLGetStmtOption:Function(ahstmt:SQLHSTMT;fOption:LongWord;Var pvParam):SQLRETURN;APIENTRY;
                   SQLAllocStmt:Function(ahdbc:SQLHDBC;Var phstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                   SQLPrepare:Function(ahstmt:SQLHSTMT;Const szSqlStr:SQLCHAR;cbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLBindParameter:Function(ahstmt:SQLHSTMT;ipar:LongWord;fParamType:LongInt;
                                             fCType:LongInt;fSQLType:LongInt;cbParamDef:SQLUINTEGER;
                                             ibScale:LongInt;Var rgbValue;cbValueMax:SQLINTEGER;
                                             Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLSetParam:Function(ahstmt:SQLHSTMT;ipar:LongWord;fCType:LongInt;fSQLType:LongInt;
                                        cbParamDef:SQLUINTEGER;ibScale:LongInt;Var rgbValue;
                                        Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLParamOptions:Function(ahstmt:SQLHSTMT;crow:SQLUINTEGER;Var pirow:SQLUINTEGER):SQLRETURN;APIENTRY;
                   SQLGetCursorName:Function(ahstmt:SQLHSTMT;Var szCursor:SQLCHAR;cbCursorMax:LongInt;
                                             Var pcbCursor:SQLSMALLINT):SQLRETURN;APIENTRY;
                   SQLSetCursorName:Function(ahstmt:SQLHSTMT;Const szCursor:SQLCHAR;cbCursor:LongInt):SQLRETURN;APIENTRY;
                   SQLExecute:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                   SQLExecDirect:Function(ahstmt:SQLHSTMT;Const szSqlStr:SQLCHAR;cbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLNativeSql:Function(ahdbc:SQLHDBC;Const szSqlStrIn:SQLCHAR;cbSqlStrIn:SQLINTEGER;
                                         Var szSqlStr:SQLCHAR;cbSqlStrMax:SQLINTEGER;Var pcbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLNumParams:Function(ahstmt:SQLHSTMT;Var pcpar:SQLSMALLINT):SQLRETURN;APIENTRY;
                   SQLParamData:Function(ahstmt:SQLHSTMT;Var prgbValue):SQLRETURN;APIENTRY;
                   SQLPutData:Function(ahstmt:SQLHSTMT;Var rgbValue;Var cbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLRowCount:Function(ahstmt:SQLHSTMT;Var pcrow:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLNumResultCols:Function(ahstmt:SQLHSTMT;Var pccol:SQLSMALLINT):SQLRETURN;APIENTRY;
                   SQLDescribeCol:Function(ahstmt:SQLHSTMT;icol:LongWord;Var szColName:SQLCHAR;
                                           cbColNameMax:LongInt;Var pcbColName:SQLSMALLINT;
                                           Var pfSqlType:SQLSMALLINT;Var pcbColDef:SQLUINTEGER;
                                           Var pibScale:SQLSMALLINT;Var pfNullable:SQLSMALLINT):SQLRETURN;APIENTRY;
                   SQLColAttributes:Function(ahstmt:SQLHSTMT;icol:LongWord;fDescType:LongWord;
                                             Var rgbDesc:SQLCHAR;cbDescMax:LongInt;
                                                  Var pcbDesc:SQLSMALLINT;Var pfDesc:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLBindCol:Function(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;Var rgbValue;
                                       cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLFetch:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                   SQLExtendedFetch:Function(ahstmt:SQLHSTMT;fFetchType:LongWord;irow:SQLINTEGER;
                                             Var pcrow:SQLUINTEGER;Var rgfRowStatus):SQLRETURN;APIENTRY;
                   SQLGetData:Function(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;
                                       Var rgbValue;cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                   SQLMoreResults:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                   SQLError:Function(ahenv:SQLHENV;ahdbc:SQLHDBC;ahstmt:SQLHSTMT;Var szSqlState:SQLCHAR;
                                     Var pfNativeError:SQLINTEGER;Var szErrorMsg;
                                     cbErrorMsgMax:LongInt;Var pcbErrorMsg:SQLSMALLINT):SQLRETURN;APIENTRY;
                   SQLColumns:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                       Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                       Const szTableName:SQLCHAR;cbTableName:LongInt;
                                       Const szColumnName:SQLCHAR;cbColumnName:LongInt):SQLRETURN;APIENTRY;
                   SQLForeignKeys:Function(ahstmt:SQLHSTMT;Const szPkCatalogName:SQLCHAR;cbPkCatalogName:LongInt;
                                           Const szPkSchemaName:SQLCHAR;cbPkSchemaName:LongInt;
                                           Const szPkTableName:SQLCHAR;cbPkTableName:LongInt;
                                           Const szFkCatalogName:SQLCHAR;cbFkCatalogName:LongInt;
                                           Const szFkSchemaName:SQLCHAR;cbFkSchemaName:LongInt;
                                           Const szFkTableName:SQLCHAR;cbFkTableName:LongInt):SQLRETURN;APIENTRY;
                   SQLPrimaryKeys:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                                Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                                Const szTableName:SQLCHAR;cbTableName:LongInt):SQLRETURN;APIENTRY;
                   SQLProcedureColumns:Function(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                                                     Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                                                     Const szProcName:SQLCHAR;cbProcName:LongInt;
                                                     Const szColumnName:SQLCHAR;cbColumnName:LongInt):SQLRETURN;APIENTRY;
                   SQLProcedures:Function(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                                               Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                                               Const szProcName:SQLCHAR;cbProcName:LongInt):SQLRETURN;APIENTRY;
                   SQLSpecialColumns:Function(ahstmt:SQLHSTMT;fColType:LongWord;
                                                   Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                                   Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                                   Const szTableName:SQLCHAR;cbTableName:LongInt;
                                                   fScope:LongWord;fNullable:LongWord):SQLRETURN;APIENTRY;
                   SQLStatistics:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                               Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                               Const szTableName:SQLCHAR;cbTableName:LongInt;
                                               fUnique:LongWord;fAccuracy:LongWord):SQLRETURN;APIENTRY;
                   SQLTablePrivileges:Function(ahstmt:SQLHSTMT;Const szTableQualifier:SQLCHAR;cbTableQualifier:LongInt;
                                                    Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                                    Const szTableName:SQLCHAR;cbTableName:LongInt):SQLRETURN;APIENTRY;
                   SQLTables:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                      Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                      Const szTableName:SQLCHAR;cbTableName:LongInt;
                                      Const szTableType:SQLCHAR;cbTableType:LongInt):SQLRETURN;APIENTRY;
                   SQLFreeStmt:Function(ahstmt:SQLHSTMT;fOption:LongWord):SQLRETURN;APIENTRY;
                   SQLCancel:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                   SQLTransact:Function(ahenv:SQLHENV;ahdbc:SQLHDBC;fType:LongWord):SQLRETURN;APIENTRY;
                   SQLDisconnect:Function(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
                   SQLFreeConnect:Function(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
                   SQLFreeEnv:Function(ahenv:SQLHENV):SQLRETURN;APIENTRY;
     End;

     tcODBC = class(tcDll)
       private
         fODBCFunc : trODBCFunc;
         fHenv    : SQLHENV;      //Environment Handle
         fhdbc    : SQLHDBC;      //DSN Handle
         fUserId  : String;       //user Id
         fPassword: String;       //pasword
         fDSN: String;       //DSN Name

       Public
         Constructor Create; virtual;
         Function AllocateDBEnvironment : SQLRETURN;
         Function SQLAllocConnect : SQLRETURN;
         Function SQLSetConnectOption(fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;
         Function SQLConnect : SQLRETURN;
         Function SQLDisconnect : SQLRETURN;
         Function SQLFreeConnect : SQLRETURN;
         Function SQLFreeEnv : SQLRETURN;
         Function SQLTransact(fType:LongWord):SQLRETURN;
         Function SQLErrorText(fHStmt : SQLHSTMT) : String;
         Function SQLDataSources(fDirection:LongWord;
                                 Var szDSN:SQLCHAR;cbDSNMax:LongInt;
                                 Var pcbDSN:SQLSMALLINT;
                                 Var szDescription:SQLCHAR;cbDescriptionMax:LongInt;
                                 Var pcbDescription:SQLSMALLINT):SQLRETURN;

         property DSN: String   read fDSN write fDSN;
         property UserId  : String   read fUserId   write fUserID;
         property Password: String   read fPassword write fPassword;
         property HEnv    : SQLHENV  read fHenv;
         property HDbc    : SQLHDBC  read fHdbc;
         property Func  : trODBCFunc read fODBCFunc;

         ModHandle:LongWord;  //Module Handle

         AliasName:String;    //Server alias Name
         Host:string;         //DSN host
         Assigned:Boolean;    //True if functions and heap-structures are valid
         FuncTable:Pointer;   //function table for some native db's (like mSQL)
         IsStoredProc:Boolean;//True for stored procs
     End;

Type tcODBCStmt = Class
       Private
         fODBC  : tcODBC;
         fHStmt : SQLHSTMT;     //statement Handle
       Public
         Constructor Create(iODBC : tcODBC); virtual;
         Destructor Destroy; Override;

         Function Reset : SQLRETURN;

         Function SQLExecDirect(Const szSqlStr:SQLCHAR): SQLRETURN;
         Function SQLFetch : SQLRETURN;
         Function SQLExtendedFetch(fFetchType:LongWord;irow:SQLINTEGER;
                             Var pcrow:SQLUINTEGER;Var rgfRowStatus):SQLRETURN;
         Function SQLSetStmtOption(fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;
         Function SQLNumResultCols(Var pccol:SQLSMALLINT):SQLRETURN;
         Function SQLDescribeCol(icol:LongWord;Var szColName:SQLCHAR;
                                 cbColNameMax:LongInt;Var pcbColName:SQLSMALLINT;
                                 Var pfSqlType:SQLSMALLINT;Var pcbColDef:SQLUINTEGER;
                                 Var pibScale:SQLSMALLINT;Var pfNullable:SQLSMALLINT):SQLRETURN;
         Function SQLTables(Const szTableType:SQLCHAR):SQLRETURN;
         Function SQLGetData(icol:LongWord;fCType:LongInt;
                             Var rgbValue;cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;
         Function SQLGetTypeInfo(fSQLType:LongInt):SQLRETURN;
         Function SQLBindCol(icol:LongWord;fCType:LongInt;Var rgbValue;
                              cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;
         Function SQLPrimaryKeys(Const TableName : String):SQLRETURN;
         Function SQLForeignKeys(Const FkTableName : String):SQLRETURN;

         Function SQLGetCursorName(Var szCursor:SQLCHAR;cbCursorMax:LongInt;
                          Var pcbCursor:SQLSMALLINT):SQLRETURN;
         Function SQLSetCursorName(Const szCursor:SQLCHAR;cbCursor:LongInt):SQLRETURN;
         Function SQLStatistics(Const szTableName:SQLCHAR; fUnique:LongWord;fAccuracy:LongWord):SQLRETURN;

         Function SQLProcedures:SQLRETURN;
         Function SQLProcedureColumns(Const szProcName:SQLCHAR;cbProcName:LongInt):SQLRETURN;

         property ODBC  : tcODBC   read fODBC;
         property HStmt : SQLHSTMT read fhStmt;
     End;

/*    PDBProcs=^TDBProcs;
    TDBProcs=Record


    End;

Type EProcAddrError=Class(Exception);




/*
Function FillDBProcs(Var DbProcs:TDBProcs):Boolean;
Procedure FreeDBProcs(Var DbProcs:TDBProcs);
Function SQLErrorText(Var DbProcs:TDBProcs;ahenv:SQLHENV;ahdbc:SQLHDBC;ahstmt:SQLHSTMT):String;

// Function GetDBServersCount:LongInt;
// Procedure GetDBServer(Index:LongInt;Var AliasName,DllName:String;Var DBType:TDBTypes);
// Procedure GetDBServerFromAlias(Const alias:String;Var DllName:String;Var DBType:TDBTypes);
// Procedure AddServerAlias(Const AliasName,DllName:String;DBType:TDBTypes);
// Procedure ModifyServerAlias(Const AliasName,NewAliasName,DllName:String;DBType:TDBTypes);
// Procedure RemoveServerAlias(Const AliasName:String);
// Function IsDefaultServer(Const AliasName:String):Boolean;

Function GetDBAliasNamesCount:LongInt;
Procedure GetDBAlias(Index:LongInt;Var AliasName,DriverName,Advanced,UID:String);
Procedure GetDBServerFromDBAlias(Const AliasName:String;Var DriverName,Advanced,UID:String);
Procedure AddDatabaseAlias(Const AliasName,DriverName,Advanced,UID:String);
Procedure ModifyDatabaseAlias(Const AliasName,NewAliasName,DriverName,Advanced,UID:String);
Procedure RemoveDatabaseAlias(Const AliasName:String);


Function AllocateDBEnvironment(Var Procs:TDBProcs):SQLRETURN;
Procedure RegisterDBDrivers(IniName:String);
Procedure RegisterDBAliasNames(IniName:String);
*/

Implementation

Constructor tcODBCStmt.Create(iODBC : tcODBC);

Var rv : SQLRETURN;

Begin
  inherited Create;
  if (iODBC=nil) or (iODBC.HDBC=0) then exit;
  fODBC:=iODBC;
  rv:=fODBC.Func.SQLAllocStmt(fODBC.Hdbc, fHStmt);
End;

Destructor tcODBCStmt.Destroy;

Var rv : SQLRETURN;

Begin
  rv:=fODBC.Func.SQLFreeStmt(fHStmt, SQL_DROP);
  inherited Destroy;
End;

Function tcODBCStmt.Reset : SQLRETURN;

Begin
  if fHStmt<>0 then
    Begin
      Result:=fODBC.Func.SQLFreeStmt(fHStmt, SQL_DROP);
      fHStmt:=0;
    End;
  Result:=fODBC.Func.SQLAllocStmt(fODBC.Hdbc, fHStmt);
End;

Function tcODBCStmt.SQLExecDirect(Const szSqlStr:SQLCHAR): SQLRETURN;

Begin
  Result:=fODBC.Func.SQLExecDirect(fHStmt, szSqlStr, SQL_NTS);
End;

Function tcODBCStmt.SQLFetch : SQLRETURN;

Begin
  Result:=fODBC.Func.SQLFetch(fHStmt);
End;

Function tcODBCStmt.SQLSetStmtOption(fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLSetStmtOption(fHStmt, fOption, vParam);
End;

Function tcODBCStmt.SQLNumResultCols(Var pccol:SQLSMALLINT):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLNumResultCols(fHstmt,pccol);
End;

Function tcODBCStmt.SQLDescribeCol(icol:LongWord;Var szColName:SQLCHAR;
                         cbColNameMax:LongInt;Var pcbColName:SQLSMALLINT;
                         Var pfSqlType:SQLSMALLINT;Var pcbColDef:SQLUINTEGER;
                         Var pibScale:SQLSMALLINT;Var pfNullable:SQLSMALLINT):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLDescribeCol(fhstmt, icol,szColName, cbColNameMax,
                         pcbColName, pfSqlType, pcbColDef, pibScale, pfNullable);
End;

Function tcODBCStmt.SQLExtendedFetch(fFetchType:LongWord;irow:SQLINTEGER;
                             Var pcrow:SQLUINTEGER;Var rgfRowStatus):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLExtendedFetch(fHStmt, fFetchType, irow, pcrow, rgfRowStatus);
End;


Function tcODBCStmt.SQLTables(Const szTableType:SQLCHAR):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLTables(fHStmt,Nil,0,Nil,0,Nil,0,szTableType,SQL_NTS);
End;

Function tcODBCStmt.SQLGetData(icol:LongWord;fCType:LongInt;
               Var rgbValue;cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLGetData(fHStmt, icol, fCType, rgbValue, cbValueMax, pcbValue);
End;

Function tcODBCStmt.SQLGetTypeInfo(fSQLType:LongInt):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLGetTypeInfo(fHStmt, fSQLType);
End;

Function tcODBCStmt.SQLBindCol(icol:LongWord;fCType:LongInt;Var rgbValue;
                              cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLBindCol(fHStmt, icol, fCType, rgbValue, cbValueMax, pcbValue);
End;

Function tcODBCStmt.SQLPrimaryKeys(Const TableName : String):SQLRETURN;

Var szTableName : SQLCHAR;

Begin
  if szTableName = ''
    then Result:=fODBC.Func.SQLPrimaryKeys(fHStmt,Nil,0,Nil,0,Nil,0)
    else
      Begin
        szTableName:=TableName;
        Result:=fODBC.Func.SQLPrimaryKeys(fHStmt,Nil,0,Nil,0,szTableName,SQL_NTS);
      End;
End;

Function tcODBCStmt.SQLForeignKeys(Const FkTableName : String):SQLRETURN;

Var szFKTableName : SQLCHAR;

Begin
  if szFKTableName = ''
    then Result:=fODBC.Func.SQLForeignKeys(fHStmt, nil,0, nil,0, nil,0, nil,0, nil,0, nil,0)
    else
      Begin
        szFKTableName:=FKTableName;
        Result:=fODBC.Func.SQLForeignKeys(fHStmt, nil,0, nil,0, nil,0, nil,0, nil,0, szFkTableName,SQL_NTS);
      End;
End;

Function tcODBCStmt.SQLProcedures :SQLRETURN;

Begin
  Result:=fODBC.Func.SQLProcedures(fHstmt, Nil,0,Nil,0,Nil,0);
End;

Function tcODBCStmt.SQLProcedureColumns(Const szProcName:SQLCHAR;cbProcName:LongInt):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLProcedureColumns(fHStmt, Nil,0, Nil,0, szProcName, cbProcName, Nil,0);
End;

Function tcODBCStmt.SQLStatistics(Const szTableName:SQLCHAR; fUnique:LongWord;fAccuracy:LongWord):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLStatistics(fHStmt, Nil,0,Nil,0, szTableName, SQL_NTS, fUnique, fAccuracy);
End;


Function tcODBCStmt.SQLGetCursorName(Var szCursor:SQLCHAR;cbCursorMax:LongInt;
                          Var pcbCursor:SQLSMALLINT):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLGetCursorName(fHStmt, szCursor, cbCursorMax, pcbCursor);
End;

Function tcODBCStmt.SQLSetCursorName(Const szCursor:SQLCHAR;cbCursor:LongInt):SQLRETURN;

Begin
  Result:=fODBC.Func.SQLSetCursorName(fHStmt, szCursor, cbCursor);
End;


{ ---------------------------------------------------------------------------------------- }

Function tcODBC.SQLDataSources(fDirection:LongWord;
                               Var szDSN:SQLCHAR;cbDSNMax:LongInt;
                               Var pcbDSN:SQLSMALLINT;
                               Var szDescription:SQLCHAR;cbDescriptionMax:LongInt;
                               Var pcbDescription:SQLSMALLINT):SQLRETURN;

Begin
  Result:=fODBCFunc.SQLDataSources(fHenv, fDirection, szDSN, cbDSNMax, pcbDSN,
                         szDescription, cbDescriptionMax, pcbDescription);
End;

Function tcODBC.SQLErrorText(fHStmt : SQLHSTMT) : String;

Var SQLSTATE:SQLCHAR;
    Buffer:cstring;
    sqlCode:SQLINTEGER;
    len:SQLSMALLINT;

Begin
  Result:=#13#10;
  While fODBCFunc.SQLError(fHenv,fHdbc,fHstmt,SQLSTATE,sqlCode,Buffer,
                       255,len)=SQL_SUCCESS Do
    Begin
      Result:=Result+'SQLSTATE: '+SQLSTATE+#13#10+
                     'Native error code: '+tostr(sqlCode)+#13#10+
                     Buffer;
    End;
  If Result=#13#10 Then Result:='';
End;

Function tcODBC.AllocateDBEnvironment : SQLRETURN;

Begin
  fHenv:=0;
  fHdbc:=0;
  Result:=fODBCFunc.SQLAllocEnv(fHenv);
End;

Function tcODBC.SQLAllocConnect : SQLRETURN;

Begin
  Result:=fODBCFunc.SQLAllocConnect(fhenv, fhdbc);
End;

Function tcODBC.SQLSetConnectOption(fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;

Begin
  Result:=fODBCFunc.SQLSetConnectOption(fhdbc, fOption, vParam);
End;

Function tcODBC.SqlConnect : SQLRETURN;

var szDSN       : SQLCHAR;
    szUID       : SQLCHAR;
    szAuthString: SQLCHAR;

Begin
  szDSN:=fDSN;
  szUID:=fUserID;
  szAuthString:=fPassword;
  if fUserID=''
    then
      Begin
        if fPassword=''
          then Result:=fODBCFunc.SqlConnect(fhdbc, szDSN, SQL_NTS, Nil, 0, Nil, 0)
          else Result:=fODBCFunc.SqlConnect(fhdbc, szDSN, SQL_NTS, Nil, 0, szAuthString, SQL_NTS);
      End
    else
      Begin
        if fPassword=''
          then Result:=fODBCFunc.SqlConnect(fhdbc, szDSN, SQL_NTS, szUID, SQL_NTS, Nil, 0)
          else Result:=fODBCFunc.SqlConnect(fhdbc, szDSN, SQL_NTS, szUID, SQL_NTS, szAuthString, SQL_NTS);
      End;
End;

Function tcODBC.SQLDisconnect : SQLRETURN;

Begin
  Result:=fODBCFunc.SQLDisconnect(fhdbc);
End;

Function tcODBC.SQLFreeConnect : SQLRETURN;

Begin
  Result:=fODBCFunc.SQLFreeConnect(fhdbc);
  fhdbc:=0;
End;

Function tcODBC.SQLFreeEnv : SQLRETURN;

Begin
  Result:=fODBCFunc.SQLFreeEnv(fhenv);
  fHenv:=0;
End;

Function tcODBC.SQLTransact(fType:LongWord) : SQLRETURN;

Begin
  Result:=fODBCFunc.SQLTransact(fhenv, fhdbc, fType);
End;


Constructor tcODBC.Create;

Begin
  inherited Create('ODBC32.DLL');
  Upper:=false;
  fHenv:=0;
  fhdbc:=0;
  if DLLLoaded then
    Begin
      fODBCFunc.SQLAllocEnv:=Pointer(GetProcAddress('SQLAllocEnv'));
      fODBCFunc.SQLAllocConnect:=Pointer(GetProcAddress('SQLAllocConnect'));
      fODBCFunc.SQLConnect:=Pointer(GetProcAddress('SQLConnect'));
      fODBCFunc.SQLDriverConnect:=Pointer(GetProcAddress('SQLDriverConnect'));
      fODBCFunc.SQLDataSources:=Pointer(GetProcAddress('SQLDataSources'));
      fODBCFunc.SQLGetInfo:=Pointer(GetProcAddress('SQLGetInfo'));
      fODBCFunc.SQLGetFunctions:=Pointer(GetProcAddress('SQLGetFunctions'));
      fODBCFunc.SQLGetTypeInfo:=Pointer(GetProcAddress('SQLGetTypeInfo'));
      fODBCFunc.SQLSetConnectOption:=Pointer(GetProcAddress('SQLSetConnectOption'));
      fODBCFunc.SQLGetConnectOption:=Pointer(GetProcAddress('SQLGetConnectOption'));
      fODBCFunc.SQLSetStmtOption:=Pointer(GetProcAddress('SQLSetStmtOption'));
      fODBCFunc.SQLGetStmtOption:=Pointer(GetProcAddress('SQLGetStmtOption'));
      fODBCFunc.SQLAllocStmt:=Pointer(GetProcAddress('SQLAllocStmt'));
      fODBCFunc.SQLPrepare:=Pointer(GetProcAddress('SQLPrepare'));
      fODBCFunc.SQLBindParameter:=Pointer(GetProcAddress('SQLBindParameter'));
      fODBCFunc.SQLSetParam:=Pointer(GetProcAddress('SQLSetParam'));
      fODBCFunc.SQLParamOptions:=Pointer(GetProcAddress('SQLParamOptions'));
      fODBCFunc.SQLGetCursorName:=Pointer(GetProcAddress('SQLGetCursorName'));
      fODBCFunc.SQLSetCursorName:=Pointer(GetProcAddress('SQLSetCursorName'));
      fODBCFunc.SQLExecute:=Pointer(GetProcAddress('SQLExecute'));
      fODBCFunc.SQLExecDirect:=Pointer(GetProcAddress('SQLExecDirect'));
      fODBCFunc.SQLNativeSql:=Pointer(GetProcAddress('SQLNativeSql'));
      fODBCFunc.SQLNumParams:=Pointer(GetProcAddress('SQLNumParams'));
      fODBCFunc.SQLParamData:=Pointer(GetProcAddress('SQLParamData'));
      fODBCFunc.SQLPutData:=Pointer(GetProcAddress('SQLPutData'));
      fODBCFunc.SQLRowCount:=Pointer(GetProcAddress('SQLRowCount'));
      fODBCFunc.SQLNumResultCols:=Pointer(GetProcAddress('SQLNumResultCols'));
      fODBCFunc.SQLDescribeCol:=Pointer(GetProcAddress('SQLDescribeCol'));
      fODBCFunc.SQLColAttributes:=Pointer(GetProcAddress('SQLColAttributes'));
      fODBCFunc.SQLBindCol:=Pointer(GetProcAddress('SQLBindCol'));
      fODBCFunc.SQLFetch:=Pointer(GetProcAddress('SQLFetch'));
      fODBCFunc.SQLExtendedFetch:=Pointer(GetProcAddress('SQLExtendedFetch'));
      fODBCFunc.SQLGetData:=Pointer(GetProcAddress('SQLGetData'));
      fODBCFunc.SQLMoreResults:=Pointer(GetProcAddress('SQLMoreResults'));
      fODBCFunc.SQLError:=Pointer(GetProcAddress('SQLError'));
      fODBCFunc.SQLColumns:=Pointer(GetProcAddress('SQLColumns'));
      fODBCFunc.SQLForeignKeys:=Pointer(GetProcAddress('SQLForeignKeys'));
      fODBCFunc.SQLPrimaryKeys:=Pointer(GetProcAddress('SQLPrimaryKeys'));
      fODBCFunc.SQLProcedureColumns:=Pointer(GetProcAddress('SQLProcedureColumns'));
      fODBCFunc.SQLProcedures:=Pointer(GetProcAddress('SQLProcedures'));
      fODBCFunc.SQLSpecialColumns:=Pointer(GetProcAddress('SQLSpecialColumns'));
      fODBCFunc.SQLStatistics:=Pointer(GetProcAddress('SQLStatistics'));
      fODBCFunc.SQLTablePrivileges:=Pointer(GetProcAddress('SQLTablePrivileges'));
      fODBCFunc.SQLTables:=Pointer(GetProcAddress('SQLTables'));
      fODBCFunc.SQLFreeStmt:=Pointer(GetProcAddress('SQLFreeStmt'));
      fODBCFunc.SQLCancel:=Pointer(GetProcAddress('SQLCancel'));
      fODBCFunc.SQLTransact:=Pointer(GetProcAddress('SQLTransact'));
      fODBCFunc.SQLDisconnect:=Pointer(GetProcAddress('SQLDisconnect'));
      fODBCFunc.SQLFreeConnect:=Pointer(GetProcAddress('SQLFreeConnect'));
      fODBCFunc.SQLFreeEnv:=Pointer(GetProcAddress('SQLFreeEnv'));
   end;
end;

Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  25-Sep-04  WD         In das Projekt wieder aufgenommen
}


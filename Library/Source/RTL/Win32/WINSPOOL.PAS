Unit WinSpool;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for Win32                                     บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Interface


Uses WinBase, WinDef, WinADVAPI, uSysClass;

type tphPrinter= ^thPrinter;
     thPrinter = LongInt;

type tpPrinter_Info_1 = ^tPrinter_Info_1;
     tPrinter_Info_1 = Record
       Flags        : LongWord;
       pDescription : pChar;
       pName        : pChar;
       pComment     : pChar;
     end;


type tpPrinter_Info_2 = ^tPrinter_Info_2;
     tPrinter_Info_2 = Record
       pServerName        : pChar;
       pPrinterName       : pChar;
       pShareName         : pChar;
       pPortName          : pChar;
       pDriverName        : pChar;
       pComment           : pChar;
       pLocation          : pChar;
       pDevMode           : Pointer;    // LPDEVMODEA
       pSepFile           : pChar;
       pPrintProcessor    : pChar;
       pDatatype          : pChar;
       pParameters        : pChar;
       pSecurityDescriptor: Pointer;  // PSECURITY_DESCRIPTOR
       Attributes         : LongWord;
       Priority           : LongWord;
       DefaultPriority    : LongWord;
       StartTime          : LongWord;
       UntilTime          : LongWord;
       Status             : LongWord;
       cJobs              : LongWord;
       AveragePPM         : LongWord;
     End;

type tpPrinter_Info_3 = ^tPrinter_Info_3;
     tPrinter_Info_3 = Record
       pSecurityDescriptor: Pointer;  // PSECURITY_DESCRIPTOR;
     end;

type tpPrinter_Info_4 = ^tPrinter_Info_4;
     tPrinter_Info_4 = Record
       pPrinterName : PChar;
       pServerName  : PChar;
       Attributes   : LongWord;
     End;

type tpPrinter_Info_5 = ^tPrinter_Info_5;
     tPrinter_Info_5 = Record
       pPrinterName : PChar;
       pPortName    : PChar;
       Attributes   : LongWord;
       DeviceNotSelectedTimeout:LongWord;
       TransmissionRetryTimeout:LongWord;
     End;

type tpPrinter_Info_6 = ^tPrinter_Info_6;
     tPrinter_Info_6 = Record
       dwStatus : LongWord;
     End;

Type tPrinter_Info_7 = Record
       pszObjectGUID : PChar;
       dwAction      : LongWord;
     End;

Const DSPRINT_PUBLISH            = 1;
      DSPRINT_UPDATE             = 2;
      DSPRINT_UNPUBLISH          = 3;

      PRINTER_CONTROL_PAUSE      = 1;
      PRINTER_CONTROL_RESUME     = 2;
      PRINTER_CONTROL_PURGE      = 3;
      PRINTER_CONTROL_SET_STATUS = 4;

      PRINTER_STATUS_PAUSED            = $00000001;
      PRINTER_STATUS_ERROR             = $00000002;
      PRINTER_STATUS_PENDING_DELETION  = $00000004;
      PRINTER_STATUS_PAPER_JAM         = $00000008;
      PRINTER_STATUS_PAPER_OUT         = $00000010;
      PRINTER_STATUS_MANUAL_FEED       = $00000020;
      PRINTER_STATUS_PAPER_PROBLEM     = $00000040;
      PRINTER_STATUS_OFFLINE           = $00000080;
      PRINTER_STATUS_IO_ACTIVE         = $00000100;
      PRINTER_STATUS_BUSY              = $00000200;
      PRINTER_STATUS_PRINTING          = $00000400;
      PRINTER_STATUS_OUTPUT_BIN_FULL   = $00000800;
      PRINTER_STATUS_NOT_AVAILABLE     = $00001000;
      PRINTER_STATUS_WAITING           = $00002000;
      PRINTER_STATUS_PROCESSING        = $00004000;
      PRINTER_STATUS_INITIALIZING      = $00008000;
      PRINTER_STATUS_WARMING_UP        = $00010000;
      PRINTER_STATUS_TONER_LOW         = $00020000;
      PRINTER_STATUS_NO_TONER          = $00040000;
      PRINTER_STATUS_PAGE_PUNT         = $00080000;
      PRINTER_STATUS_USER_INTERVENTION = $00100000;
      PRINTER_STATUS_OUT_OF_MEMORY     = $00200000;
      PRINTER_STATUS_DOOR_OPEN         = $00400000;
      PRINTER_STATUS_SERVER_UNKNOWN    = $00800000;
      PRINTER_STATUS_POWER_SAVE        = $01000000;

      PRINTER_ATTRIBUTE_QUEUED           = $00000001;
      PRINTER_ATTRIBUTE_DIRECT           = $00000002;
      PRINTER_ATTRIBUTE_DEFAULT          = $00000004;
      PRINTER_ATTRIBUTE_SHARED           = $00000008;
      PRINTER_ATTRIBUTE_NETWORK          = $00000010;
      PRINTER_ATTRIBUTE_HIDDEN           = $00000020;
      PRINTER_ATTRIBUTE_LOCAL            = $00000040;
      PRINTER_ATTRIBUTE_ENABLE_DEVQ      = $00000080;
      PRINTER_ATTRIBUTE_KEEPPRINTEDJOBS  = $00000100;
      PRINTER_ATTRIBUTE_DO_COMPLETE_FIRST= $00000200;

      PRINTER_ATTRIBUTE_WORK_OFFLINE     = $00000400;
      PRINTER_ATTRIBUTE_ENABLE_BIDI      = $00000800;
      PRINTER_ATTRIBUTE_RAW_ONLY         = $00001000;
      PRINTER_ATTRIBUTE_PUBLISHED        = $00002000;

      NO_PRIORITY  = 0;
      MAX_PRIORITY =99;
      MIN_PRIORITY = 1;
      DEF_PRIORITY = 1;

type tJOB_INFO_1 = Record
       JobId       : LongWord;
       pPrinterName: PChar;
       pMachineName: PChar;
       pUserName   : PChar;
       pDocument   : PChar;
       pDatatype   : PChar;
       pStatus     : PChar;
       Status      : LongWord;
       Priority    : LongWord;
       Position    : LongWord;
       TotalPages  : LongWord;
       PagesPrinted: LongWord;
       Submitted   : SYSTEMTIME ;
     End;

type tJOB_INFO_2 = Record
       JobId          : LongWord;
       pPrinterName   : pChar;
       pMachineName   : pChar;
       pUserName      : pChar;
       pDocument      : pChar;
       pNotifyName    : pChar;
       pDatatype      : pChar;
       pPrintProcessor: pChar;
       pParameters    : pChar;
       pDriverName    : pChar;
       pDevMode       : Pointer;  // LPDEVMODEA
       pStatus        : pChar;
       pSecurityDescriptor: Pointer;  // PSECURITY_DESCRIPTOR
       Status         : LongWord;
       Priority       : LongWord;
       Position       : LongWord;
       StartTime      : LongWord;
       UntilTime      : LongWord;
       TotalPages     : LongWord;
       Size           : LongWord;
       Submitted      : SYSTEMTIME ;    // Time the job was spooled
       Time           : LongWord;;      // How many seconds the job has been printing
       PagesPrinted   : LongWord;;
     End;

type tJOB_INFO_3 = Record
       JobId    : LongWord;
       NextJobId: LongWord;
       Reserved : LongWord;
     End;

Const JOB_CONTROL_PAUSE              = 1;
      JOB_CONTROL_RESUME             = 2;
      JOB_CONTROL_CANCEL             = 3;
      JOB_CONTROL_RESTART            = 4;
      JOB_CONTROL_DELETE             = 5;
      JOB_CONTROL_SENT_TO_PRINTER    = 6;
      JOB_CONTROL_LAST_PAGE_EJECTED  = 7;

      JOB_STATUS_PAUSED               = $00000001;
      JOB_STATUS_ERROR                = $00000002;
      JOB_STATUS_DELETING             = $00000004;
      JOB_STATUS_SPOOLING             = $00000008;
      JOB_STATUS_PRINTING             = $00000010;
      JOB_STATUS_OFFLINE              = $00000020;
      JOB_STATUS_PAPEROUT             = $00000040;
      JOB_STATUS_PRINTED              = $00000080;
      JOB_STATUS_DELETED              = $00000100;
      JOB_STATUS_BLOCKED_DEVQ         = $00000200;
      JOB_STATUS_USER_INTERVENTION    = $00000400;
      JOB_STATUS_RESTART              = $00000800;
      JOB_POSITION_UNSPECIFIED        = 0;


type tADDJOB_INFO_1 = Record
       Path : PChar;
       JobId: LongWord;
     End;

type tDRIVER_INFO_1 = Record
       pName: PChar;              // QMS 810
     End;

type tDRIVER_INFO_2 = Record
       cVersion    : LongWord;
       pName       : pChar;        // QMS 810
       pEnvironment: pChar;        // Win32 x86
       pDriverPath : pChar;        // c:\drivers\pscript.dll
       pDataFile   : pChar;        // c:\drivers\QMS810.PPD
       pConfigFile : pChar;        // c:\drivers\PSCRPTUI.DLL
     End;

type tDRIVER_INFO_3 = Record
       cVersion        : LongWord;
       pName           : pChar;    // QMS 810
       pEnvironment    : pChar;    // Win32 x86
       pDriverPath     : pChar;    // c:\drivers\pscript.dll
       pDataFile       : pChar;    // c:\drivers\QMS810.PPD
       pConfigFile     : pChar;    // c:\drivers\PSCRPTUI.DLL
       pHelpFile       : pChar;    // c:\drivers\PSCRPTUI.HLP
       pDependentFiles : pChar;    // PSCRIPT.DLL\0QMS810.PPD\0PSCRIPTUI.DLL\0PSCRIPTUI.HLP\0PSTEST.TXT\0\0
       pMonitorName    : pChar;    // "PJL monitor"
       pDefaultDataType: pChar;    // "EMF"
     End;

// FLAGS for DeletePrinterDriverEx.
Const DPD_DELETE_UNUSED_FILES          = $00000001;
      DPD_DELETE_SPECIFIC_VERSION      = $00000002;
      DPD_DELETE_ALL_FILES             = $00000004;

// FLAGS for AddPrinterDriverEx.
      APD_STRICT_UPGRADE               = $00000001;
      APD_STRICT_DOWNGRADE             = $00000002;
      APD_COPY_ALL_FILES               = $00000004;
      APD_COPY_NEW_FILES               = $00000008;

type tDOC_INFO_1 = Record
       pDocName   : pChar;
       pOutputFile: pChar;
       pDatatype  : pChar;
     End;

type tFORM_INFO_1 = Record
       Flags : LongWord;
       pName : pChar;
       Size  : SIZEL;
       ImageableArea: RECTL;
     End;

type tDOC_INFO_2 = Record
       pDocName   : pChar;
       pOutputFile: pChar;
       pDatatype  : pChar;
       dwMode     : LongWord;
       JobId      : LongWord;
     End;

Const DI_CHANNEL       =1;    // start direct read/write channel,
      DI_READ_SPOOL_JOB=3;


      FORM_USER       = $00000000;
      FORM_BUILTIN    = $00000001;
      FORM_PRINTER    = $00000002;


type tPRINTPROCESSOR_INFO_1 = Record
       pName : pChar;
     End;

type tPRINTPROCESSOR_CAPS_1 = Record
       dwLevel         : LongWord;
       dwNupOptions    : LongWord;
       dwPageOrderFlags: LongWord;
       dwNumberOfCopies: LongWord;
     End;

type tPORT_INFO_1 = Record
       pName : pChar;
     End;

type tPORT_INFO_2 = Record
       pPortName   : pChar;
       pMonitorName: pChar;
       pDescription: pChar;
       fPortType   : LongWord;
       Reserved    : LongWord;
     End;

Const PORT_TYPE_WRITE         = $0001;
      PORT_TYPE_READ          = $0002;
      PORT_TYPE_REDIRECTED    = $0004;
      PORT_TYPE_NET_ATTACHED  = $0008;

type tPORT_INFO_3 = Record
       dwStatus  : LongWord;
       pszStatus : pChar;
       dwSeverity: LongWord;
     End;

Const RT_STATUS_TYPE_ERROR     = 1;
      PORT_STATUS_TYPE_WARNING = 2;
      PORT_STATUS_TYPE_INFO    = 3;

      PORT_STATUS_OFFLINE              =  1;
      PORT_STATUS_PAPER_JAM            =  2;
      PORT_STATUS_PAPER_OUT            =  3;
      PORT_STATUS_OUTPUT_BIN_FULL      =  4;
      PORT_STATUS_PAPER_PROBLEM        =  5;
      PORT_STATUS_NO_TONER             =  6;
      PORT_STATUS_DOOR_OPEN            =  7;
      PORT_STATUS_USER_INTERVENTION    =  8;
      PORT_STATUS_OUT_OF_MEMORY        =  9;
      PORT_STATUS_TONER_LOW            = 10;
      PORT_STATUS_WARMING_UP           = 11;
      PORT_STATUS_POWER_SAVE           = 12;

type tMONITOR_INFO_1 = Record
       pName : pChar;
     End;

type tMONITOR_INFO_2 = Record
       pName       : pChar;
       pEnvironment: pChar;
       pDLLName    : LongWord;
     End;

type tDATATYPES_INFO_1 = Record
       pName : pChar;
     End;

type tpPRINTER_DEFAULTS = ^tPRINTER_DEFAULTS;
     tPRINTER_DEFAULTS = Record
       pDatatype    : pChar;
       pDevMode     : Pointer;  // LPDEVMODEA;
       DesiredAccess: Pointer;  // ACCESS_MASK;
     End;


type tPRINTER_ENUM_VALUES = Record
       pValueName : pChar;
       cbValueName: LongWord;
       dwType     : LongWord;
       pData      : LPBYTE;
       cbData     : Pointer;
     End;

Const PRINTER_ENUM_DEFAULT     = $00000001;
      PRINTER_ENUM_LOCAL       = $00000002;
      PRINTER_ENUM_CONNECTIONS = $00000004;
      PRINTER_ENUM_FAVORITE    = $00000004;
      PRINTER_ENUM_NAME        = $00000008;
      PRINTER_ENUM_REMOTE      = $00000010;
      PRINTER_ENUM_SHARED      = $00000020;
      PRINTER_ENUM_NETWORK     = $00000040;

      PRINTER_ENUM_EXPAND      = $00004000;
      PRINTER_ENUM_CONTAINER   = $00008000;

      PRINTER_ENUM_ICONMASK    = $00ff0000;
      PRINTER_ENUM_ICON1       = $00010000;
      PRINTER_ENUM_ICON2       = $00020000;
      PRINTER_ENUM_ICON3       = $00040000;
      PRINTER_ENUM_ICON4       = $00080000;
      PRINTER_ENUM_ICON5       = $00100000;
      PRINTER_ENUM_ICON6       = $00200000;
      PRINTER_ENUM_ICON7       = $00400000;
      PRINTER_ENUM_ICON8       = $00800000;

/*
BOOL
WINAPI
ResetPrinter(
   HANDLE   hPrinter,
   LPPRINTER_DEFAULTSA pDefault
);
BOOL

BOOL
WINAPI
SetJob(
    HANDLE  hPrinter,
    DWORD   JobId,
    DWORD   Level,
    LPBYTE  pJob,
    DWORD   Command
);

BOOL
WINAPI
GetJob(
   HANDLE   hPrinter,
   DWORD    JobId,
   DWORD    Level,
   LPBYTE   pJob,
   DWORD    cbBuf,
   LPDWORD  pcbNeeded
);

BOOL
WINAPI
EnumJobs(
    HANDLE  hPrinter,
    DWORD   FirstJob,
    DWORD   NoJobs,
    DWORD   Level,
    LPBYTE  pJob,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

HANDLE
WINAPI
AddPrinter(
    LPSTR   pName,
    DWORD   Level,
    LPBYTE  pPrinter
);

BOOL
WINAPI
DeletePrinter(
   HANDLE   hPrinter
);

BOOL
WINAPI
SetPrinter(
    HANDLE  hPrinter,
    DWORD   Level,
    LPBYTE  pPrinter,
    DWORD   Command
);

BOOL
WINAPI
GetPrinter(
    HANDLE  hPrinter,
    DWORD   Level,
    LPBYTE  pPrinter,
    DWORD   cbBuf,
    LPDWORD pcbNeeded
);

BOOL
WINAPI
AddPrinterDriver(
    LPSTR   pName,
    DWORD   Level,
    LPBYTE  pDriverInfo
);

BOOL
WINAPI
AddPrinterDriverEx(
    LPSTR   pName,
    DWORD     Level,
    LPBYTE    pDriverInfo,
    DWORD     dwFileCopyFlags
);

BOOL
WINAPI
EnumPrinterDrivers(
    LPSTR   pName,
    LPSTR   pEnvironment,
    DWORD   Level,
    LPBYTE  pDriverInfo,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

BOOL
WINAPI
GetPrinterDriver(
    HANDLE  hPrinter,
    LPSTR   pEnvironment,
    DWORD   Level,
    LPBYTE  pDriverInfo,
    DWORD   cbBuf,
    LPDWORD pcbNeeded
);

BOOL
WINAPI
GetPrinterDriverDirectory(
    LPSTR   pName,
    LPSTR   pEnvironment,
    DWORD   Level,
    LPBYTE  pDriverDirectory,
    DWORD   cbBuf,
    LPDWORD pcbNeeded
);

BOOL
WINAPI
DeletePrinterDriver(
   LPSTR    pName,
   LPSTR    pEnvironment,
   LPSTR    pDriverName
);

BOOL
WINAPI
DeletePrinterDriverEx(
   LPSTR    pName,
   LPSTR    pEnvironment,
   LPSTR    pDriverName,
   DWORD      dwDeleteFlag,
   DWORD      dwVersionFlag
);

BOOL
WINAPI
AddPerMachineConnection(
   LPCSTR    pServer,
   LPCSTR    pPrinterName,
   LPCSTR    pPrintServer,
   LPCSTR    pProvider
);

BOOL
WINAPI
DeletePerMachineConnection(
   LPCSTR    pServer,
   LPCSTR    pPrinterName
);

BOOL
WINAPI
EnumPerMachineConnections(
    LPCSTR   pServer,
    LPBYTE  pPrinterEnum,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

BOOL
WINAPI
AddPrintProcessor(
    LPSTR   pName,
    LPSTR   pEnvironment,
    LPSTR   pPathName,
    LPSTR   pPrintProcessorName
);

BOOL
WINAPI
EnumPrintProcessors(
    LPSTR   pName,
    LPSTR   pEnvironment,
    DWORD   Level,
    LPBYTE  pPrintProcessorInfo,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

BOOL
WINAPI
GetPrintProcessorDirectory(
    LPSTR   pName,
    LPSTR   pEnvironment,
    DWORD   Level,
    LPBYTE  pPrintProcessorInfo,
    DWORD   cbBuf,
    LPDWORD pcbNeeded
);

BOOL
WINAPI
EnumPrintProcessorDatatypes(
    LPSTR   pName,
    LPSTR   pPrintProcessorName,
    DWORD   Level,
    LPBYTE  pDatatypes,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

BOOL
WINAPI
DeletePrintProcessor(
    LPSTR   pName,
    LPSTR   pEnvironment,
    LPSTR   pPrintProcessorName
);

DWORD
WINAPI
StartDocPrinter(
    HANDLE  hPrinter,
    DWORD   Level,
    LPBYTE  pDocInfo
);

BOOL
WINAPI
StartPagePrinter(
    HANDLE  hPrinter
);

BOOL
WINAPI
WritePrinter(
    HANDLE  hPrinter,
    LPVOID  pBuf,
    DWORD   cbBuf,
    LPDWORD pcWritten
);


BOOL
WINAPI
EndPagePrinter(
   HANDLE   hPrinter
);

BOOL
WINAPI
AbortPrinter(
   HANDLE   hPrinter
);

BOOL
WINAPI
ReadPrinter(
    HANDLE  hPrinter,
    LPVOID  pBuf,
    DWORD   cbBuf,
    LPDWORD pNoBytesRead
);

BOOL
WINAPI
EndDocPrinter(
   HANDLE   hPrinter
);

BOOL
WINAPI
AddJob(
    HANDLE  hPrinter,
    DWORD   Level,
    LPBYTE  pData,
    DWORD   cbBuf,
    LPDWORD pcbNeeded
);

BOOL
WINAPI
ScheduleJob(
    HANDLE  hPrinter,
    DWORD   JobId
);

LONG
WINAPI
DocumentProperties(
    HWND      hWnd,
    HANDLE    hPrinter,
    LPSTR   pDeviceName,
    PDEVMODEA pDevModeOutput,
    PDEVMODEA pDevModeInput,
    DWORD     fMode
);

LONG
WINAPI
AdvancedDocumentProperties(
    HWND    hWnd,
    HANDLE  hPrinter,
    LPSTR   pDeviceName,
    PDEVMODEA pDevModeOutput,
    PDEVMODEA pDevModeInput
);

DWORD
WINAPI
GetPrinterData(
    HANDLE   hPrinter,
    LPSTR  pValueName,
    LPDWORD  pType,
    LPBYTE   pData,
    DWORD    nSize,
    LPDWORD  pcbNeeded
);

DWORD
WINAPI
GetPrinterDataEx(
    HANDLE   hPrinter,
    LPCSTR pKeyName,
    LPCSTR pValueName,
    LPDWORD  pType,
    LPBYTE   pData,
    DWORD    nSize,
    LPDWORD  pcbNeeded
);

DWORD
WINAPI
EnumPrinterData(
    HANDLE   hPrinter,
    DWORD    dwIndex,
    LPSTR  pValueName,
    DWORD    cbValueName,
    LPDWORD  pcbValueName,
    LPDWORD  pType,
    LPBYTE   pData,
    DWORD    cbData,
    LPDWORD  pcbData
);

DWORD
WINAPI
EnumPrinterDataEx(
    HANDLE   hPrinter,
    LPCSTR pKeyName,
    LPBYTE   pEnumValues,
    DWORD    cbEnumValues,
    LPDWORD  pcbEnumValues,
    LPDWORD  pnEnumValues
);

DWORD
WINAPI
EnumPrinterKey(
    HANDLE   hPrinter,
    LPCSTR pKeyName,
    LPSTR  pSubkey,
    DWORD    cbSubkey,
    LPDWORD  pcbSubkey
);

DWORD
WINAPI
SetPrinterData(
    HANDLE  hPrinter,
    LPSTR pValueName,
    DWORD   Type,
    LPBYTE  pData,
    DWORD   cbData
);

DWORD
WINAPI
SetPrinterDataEx(
    HANDLE   hPrinter,
    LPCSTR pKeyName,
    LPCSTR pValueName,
    DWORD    Type,
    LPBYTE   pData,
    DWORD    cbData
);

DWORD
WINAPI
DeletePrinterData(
    HANDLE  hPrinter,
    LPSTR pValueName
);

DWORD
WINAPI
DeletePrinterDataEx(
    HANDLE   hPrinter,
    LPCSTR pKeyName,
    LPCSTR pValueName
);

DWORD
WINAPI
DeletePrinterKey(
    HANDLE   hPrinter,
    LPCSTR pKeyName
);
*/

Const PRINTER_NOTIFY_TYPE = $00;
      JOB_NOTIFY_TYPE     = $01;

      PRINTER_NOTIFY_FIELD_SERVER_NAME             = $00;
      PRINTER_NOTIFY_FIELD_PRINTER_NAME            = $01;
      PRINTER_NOTIFY_FIELD_SHARE_NAME              = $02;
      PRINTER_NOTIFY_FIELD_PORT_NAME               = $03;
      PRINTER_NOTIFY_FIELD_DRIVER_NAME             = $04;
      PRINTER_NOTIFY_FIELD_COMMENT                 = $05;
      PRINTER_NOTIFY_FIELD_LOCATION                = $06;
      PRINTER_NOTIFY_FIELD_DEVMODE                 = $07;
      PRINTER_NOTIFY_FIELD_SEPFILE                 = $08;
      PRINTER_NOTIFY_FIELD_PRINT_PROCESSOR         = $09;
      PRINTER_NOTIFY_FIELD_PARAMETERS              = $0A;
      PRINTER_NOTIFY_FIELD_DATATYPE                = $0B;
      PRINTER_NOTIFY_FIELD_SECURITY_DESCRIPTOR     = $0C;
      PRINTER_NOTIFY_FIELD_ATTRIBUTES              = $0D;
      PRINTER_NOTIFY_FIELD_PRIORITY                = $0E;
      PRINTER_NOTIFY_FIELD_DEFAULT_PRIORITY        = $0F;
      PRINTER_NOTIFY_FIELD_START_TIME              = $10;
      PRINTER_NOTIFY_FIELD_UNTIL_TIME              = $11;
      PRINTER_NOTIFY_FIELD_STATUS                  = $12;
      PRINTER_NOTIFY_FIELD_STATUS_STRING           = $13;
      PRINTER_NOTIFY_FIELD_CJOBS                   = $14;
      PRINTER_NOTIFY_FIELD_AVERAGE_PPM             = $15;
      PRINTER_NOTIFY_FIELD_TOTAL_PAGES             = $16;
      PRINTER_NOTIFY_FIELD_PAGES_PRINTED           = $17;
      PRINTER_NOTIFY_FIELD_TOTAL_BYTES             = $18;
      PRINTER_NOTIFY_FIELD_BYTES_PRINTED           = $19;
      PRINTER_NOTIFY_FIELD_OBJECT_GUID             = $1A;

      JOB_NOTIFY_FIELD_PRINTER_NAME                = $00;
      JOB_NOTIFY_FIELD_MACHINE_NAME                = $01;
      JOB_NOTIFY_FIELD_PORT_NAME                   = $02;
      JOB_NOTIFY_FIELD_USER_NAME                   = $03;
      JOB_NOTIFY_FIELD_NOTIFY_NAME                 = $04;
      JOB_NOTIFY_FIELD_DATATYPE                    = $05;
      JOB_NOTIFY_FIELD_PRINT_PROCESSOR             = $06;
      JOB_NOTIFY_FIELD_PARAMETERS                  = $07;
      JOB_NOTIFY_FIELD_DRIVER_NAME                 = $08;
      JOB_NOTIFY_FIELD_DEVMODE                     = $09;
      JOB_NOTIFY_FIELD_STATUS                      = $0A;
      JOB_NOTIFY_FIELD_STATUS_STRING               = $0B;
      JOB_NOTIFY_FIELD_SECURITY_DESCRIPTOR         = $0C;
      JOB_NOTIFY_FIELD_DOCUMENT                    = $0D;
      JOB_NOTIFY_FIELD_PRIORITY                    = $0E;
      JOB_NOTIFY_FIELD_POSITION                    = $0F;
      JOB_NOTIFY_FIELD_SUBMITTED                   = $10;
      JOB_NOTIFY_FIELD_START_TIME                  = $11;
      JOB_NOTIFY_FIELD_UNTIL_TIME                  = $12;
      JOB_NOTIFY_FIELD_TIME                        = $13;
      JOB_NOTIFY_FIELD_TOTAL_PAGES                 = $14;
      JOB_NOTIFY_FIELD_PAGES_PRINTED               = $15;
      JOB_NOTIFY_FIELD_TOTAL_BYTES                 = $16;
      JOB_NOTIFY_FIELD_BYTES_PRINTED               = $17;


type tPRINTER_NOTIFY_OPTIONS_TYPE = Record
       Typ      : Word;
       Reserved0: Word;
       Reserved1: LongWord;
       Reserved2: LongWord;
       Count    : LongWord;
       pFields  : ^Word;
     End;


Const PRINTER_NOTIFY_OPTIONS_REFRESH  = $01;

type tPRINTER_NOTIFY_OPTIONS = Record
       Version: LongWord;
       Flags  : LongWord;
       Count  : LongWord;
       PPRINTER_NOTIFY_OPTIONS_TYPE : Pointer // pTypes;
     End;

Const PRINTER_NOTIFY_INFO_DISCARDED   = $01;

/*
type tPRINTER_NOTIFY_INFO_DATA = Record
       Typ     : Word;
       Field   : Word;
       Reserved: LongWord;
       Id      : LongWord;
    union {
        DWORD adwData[2];
        struct {
            DWORD  cbBuf;
            LPVOID pBuf;
        } Data;
    } NotifyData;
     End;
*/
/*
type tPRINTER_NOTIFY_INFO = Record
       DWORD Version: LongWord;
       DWORD Flags  : LongWord;
       DWORD Count  : LongWord;
       PRINTER_NOTIFY_INFO_DATA aData[1];
} PRINTER_NOTIFY_INFO, *PPRINTER_NOTIFY_INFO, *LPPRINTER_NOTIFY_INFO;
*/
/*
DWORD
WINAPI
WaitForPrinterChange(
    HANDLE  hPrinter,
    DWORD   Flags
);

HANDLE
WINAPI
FindFirstPrinterChangeNotification(
    HANDLE  hPrinter,
    DWORD   fdwFlags,
    DWORD   fdwOptions,
    LPVOID  pPrinterNotifyOptions
);


BOOL
WINAPI
FindNextPrinterChangeNotification(
    HANDLE hChange,
    PDWORD pdwChange,
    LPVOID pvReserved,
    LPVOID *ppPrinterNotifyInfo
);

BOOL
WINAPI
FreePrinterNotifyInfo(
    PPRINTER_NOTIFY_INFO pPrinterNotifyInfo
);

BOOL
WINAPI
FindClosePrinterChangeNotification(
    HANDLE hChange
);

*/

Const PRINTER_CHANGE_ADD_PRINTER              = $00000001;
      PRINTER_CHANGE_SET_PRINTER              = $00000002;
      PRINTER_CHANGE_DELETE_PRINTER           = $00000004;
      PRINTER_CHANGE_FAILED_CONNECTION_PRINTER= $00000008;
      PRINTER_CHANGE_PRINTER                  = $000000FF;
      PRINTER_CHANGE_ADD_JOB                  = $00000100;
      PRINTER_CHANGE_SET_JOB                  = $00000200;
      PRINTER_CHANGE_DELETE_JOB               = $00000400;
      PRINTER_CHANGE_WRITE_JOB                = $00000800;
      PRINTER_CHANGE_JOB                      = $0000FF00;
      PRINTER_CHANGE_ADD_FORM                 = $00010000;
      PRINTER_CHANGE_SET_FORM                 = $00020000;
      PRINTER_CHANGE_DELETE_FORM              = $00040000;
      PRINTER_CHANGE_FORM                     = $00070000;
      PRINTER_CHANGE_ADD_PORT                 = $00100000;
      PRINTER_CHANGE_CONFIGURE_PORT           = $00200000;
      PRINTER_CHANGE_DELETE_PORT              = $00400000;
      PRINTER_CHANGE_PORT                     = $00700000;
      PRINTER_CHANGE_ADD_PRINT_PROCESSOR      = $01000000;
      PRINTER_CHANGE_DELETE_PRINT_PROCESSOR   = $04000000;
      PRINTER_CHANGE_PRINT_PROCESSOR          = $07000000;
      PRINTER_CHANGE_ADD_PRINTER_DRIVER       = $10000000;
      PRINTER_CHANGE_SET_PRINTER_DRIVER       = $20000000;
      PRINTER_CHANGE_DELETE_PRINTER_DRIVER    = $40000000;
      PRINTER_CHANGE_PRINTER_DRIVER           = $70000000;
      PRINTER_CHANGE_TIMEOUT                  = $80000000;
      PRINTER_CHANGE_ALL                      = $7777FFFF;

/*
DWORD
WINAPI
PrinterMessageBox(
    HANDLE  hPrinter,
    DWORD   Error,
    HWND    hWnd,
    LPSTR   pText,
    LPSTR   pCaption,
    DWORD   dwType
);

*/

Const PRINTER_ERROR_INFORMATION   = $80000000;
      PRINTER_ERROR_WARNING       = $40000000;
      PRINTER_ERROR_SEVERE        = $20000000;

      PRINTER_ERROR_OUTOFPAPER    = $00000001;
      PRINTER_ERROR_JAM           = $00000002;
      PRINTER_ERROR_OUTOFTONER    = $00000004;

/*
BOOL
WINAPI
AddForm(
    HANDLE  hPrinter,
    DWORD   Level,
    LPBYTE  pForm
);

BOOL
WINAPI
DeleteForm(
    HANDLE  hPrinter,
    LPSTR   pFormName
);

BOOL
WINAPI
GetForm(
    HANDLE  hPrinter,
    LPSTR   pFormName,
    DWORD   Level,
    LPBYTE  pForm,
    DWORD   cbBuf,
    LPDWORD pcbNeeded
);

BOOL
WINAPI
SetForm(
    HANDLE  hPrinter,
    LPSTR   pFormName,
    DWORD   Level,
    LPBYTE  pForm
);

BOOL
WINAPI
EnumForms(
    HANDLE  hPrinter,
    DWORD   Level,
    LPBYTE  pForm,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

BOOL
WINAPI
EnumMonitors(
    LPSTR   pName,
    DWORD   Level,
    LPBYTE  pMonitors,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

BOOL
WINAPI
AddMonitor(
    LPSTR   pName,
    DWORD   Level,
    LPBYTE  pMonitors
);

BOOL
WINAPI
DeleteMonitor(
    LPSTR   pName,
    LPSTR   pEnvironment,
    LPSTR   pMonitorName
);

BOOL
WINAPI
EnumPorts(
    LPSTR   pName,
    DWORD   Level,
    LPBYTE  pPorts,
    DWORD   cbBuf,
    LPDWORD pcbNeeded,
    LPDWORD pcReturned
);

BOOL
WINAPI
AddPort(
    LPSTR   pName,
    HWND    hWnd,
    LPSTR   pMonitorName
);

BOOL
WINAPI
ConfigurePort(
    LPSTR   pName,
    HWND    hWnd,
    LPSTR   pPortName
);

BOOL
WINAPI
DeletePort(
    LPSTR pName,
    HWND    hWnd,
    LPSTR pPortName
);

BOOL
WINAPI
XcvData(
    HANDLE  hXcv,
    PCWSTR  pszDataName,
    PBYTE   pInputData,
    DWORD   cbInputData,
    PBYTE   pOutputData,
    DWORD   cbOutputData,
    PDWORD  pcbOutputNeeded,
    PDWORD  pdwStatus
);

BOOL
WINAPI
SetPort(
    LPSTR     pName,
    LPSTR     pPortName,
    DWORD       dwLevel,
    LPBYTE      pPortInfo
);

BOOL
WINAPI
AddPrinterConnection(
    LPSTR   pName
);

BOOL
WINAPI
DeletePrinterConnection(
    LPSTR   pName
);

HANDLE
WINAPI
ConnectToPrinterDlg(
    HWND    hwnd,
    DWORD   Flags
);
*/

type tPROVIDOR_INFO_1 = Record
       pName       : pChar;
       pEnvironment: pChar;
       pDLLName    : pChar;
     End;

/*
BOOL
WINAPI
AddPrintProvidor(
    LPSTR  pName,
    DWORD    level,
    LPBYTE   pProvidorInfo
);

BOOL
WINAPI
DeletePrintProvidor(
    LPSTR   pName,
    LPSTR   pEnvironment,
    LPSTR   pPrintProvidorName
);

// SetPrinterData and GetPrinterData Server Handle Key values
#define    SPLREG_DEFAULT_SPOOL_DIRECTORY             TEXT("DefaultSpoolDirectory")
#define    SPLREG_PORT_THREAD_PRIORITY_DEFAULT        TEXT("PortThreadPriorityDefault")
#define    SPLREG_PORT_THREAD_PRIORITY                TEXT("PortThreadPriority")
#define    SPLREG_SCHEDULER_THREAD_PRIORITY_DEFAULT   TEXT("SchedulerThreadPriorityDefault")
#define    SPLREG_SCHEDULER_THREAD_PRIORITY           TEXT("SchedulerThreadPriority")
#define    SPLREG_BEEP_ENABLED                        TEXT("BeepEnabled")
#define    SPLREG_NET_POPUP                           TEXT("NetPopup")
#define    SPLREG_EVENT_LOG                           TEXT("EventLog")
#define    SPLREG_MAJOR_VERSION                       TEXT("MajorVersion")
#define    SPLREG_MINOR_VERSION                       TEXT("MinorVersion")
#define    SPLREG_ARCHITECTURE                        TEXT("Architecture")
#define    SPLREG_OS_VERSION                          TEXT("OSVersion")
#define    SPLREG_DS_PRESENT                          TEXT("DsPresent")
*/

Const SERVER_ACCESS_ADMINISTER    = $00000001;
      SERVER_ACCESS_ENUMERATE     = $00000002;

      PRINTER_ACCESS_ADMINISTER   = $00000004;
      PRINTER_ACCESS_USE          = $00000008;

      JOB_ACCESS_ADMINISTER       = $00000010;

// Access rights for print servers
      SERVER_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED or
                            SERVER_ACCESS_ADMINISTER or
                            SERVER_ACCESS_ENUMERATE);

      SERVER_READ        = (STANDARD_RIGHTS_READ or
                            SERVER_ACCESS_ENUMERATE);

      SERVER_WRITE       = (STANDARD_RIGHTS_WRITE or
                            SERVER_ACCESS_ADMINISTER or
                            SERVER_ACCESS_ENUMERATE);

      SERVER_EXECUTE     = (STANDARD_RIGHTS_EXECUTE or
                            SERVER_ACCESS_ENUMERATE);

// Access rights for printers
      PRINTER_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED or
                             PRINTER_ACCESS_ADMINISTER or
                             PRINTER_ACCESS_USE);

      PRINTER_READ        = (STANDARD_RIGHTS_READ or
                             PRINTER_ACCESS_USE);

      PRINTER_WRITE       = (STANDARD_RIGHTS_WRITE or
                             PRINTER_ACCESS_USE);

      PRINTER_EXECUTE     = (STANDARD_RIGHTS_EXECUTE or
                             PRINTER_ACCESS_USE);

// Access rights for jobs
      JOB_ALL_ACCESS       = (STANDARD_RIGHTS_REQUIRED or
                              JOB_ACCESS_ADMINISTER);

      JOB_READ             = (STANDARD_RIGHTS_READ or
                              JOB_ACCESS_ADMINISTER);

      JOB_WRITE            = (STANDARD_RIGHTS_WRITE or
                              JOB_ACCESS_ADMINISTER);

      JOB_EXECUTE          = (STANDARD_RIGHTS_EXECUTE or
                              JOB_ACCESS_ADMINISTER);

//DS Print-Queue property tables


/*
// Predefined Registry Keys used by Set/GetPrinterDataEx
#define SPLDS_SPOOLER_KEY                       TEXT("DsSpooler")
#define SPLDS_DRIVER_KEY                        TEXT("DsDriver")
#define SPLDS_USER_KEY                          TEXT("DsUser")


// DS Print-Queue properties

#define SPLDS_ASSET_NUMBER                      TEXT("assetNumber")
#define SPLDS_BYTES_PER_MINUTE                  TEXT("bytesPerMinute")
#define SPLDS_DESCRIPTION                       TEXT("description")
#define SPLDS_DRIVER_NAME                       TEXT("driverName")
#define SPLDS_DRIVER_VERSION                    TEXT("driverVersion")
#define SPLDS_LOCATION                          TEXT("location")
#define SPLDS_PORT_NAME                         TEXT("portName")
#define SPLDS_PRINT_ATTRIBUTES                  TEXT("printAttributes")
#define SPLDS_PRINT_BIN_NAMES                   TEXT("printBinNames")
#define SPLDS_PRINT_COLLATE                     TEXT("printCollate")
#define SPLDS_PRINT_COLOR                       TEXT("printColor")
#define SPLDS_PRINT_DUPLEX_SUPPORTED            TEXT("printDuplexSupported")
#define SPLDS_PRINT_END_TIME                    TEXT("printEndTime")
#define SPLDS_PRINTER_CLASS                     TEXT("printQueue")
#define SPLDS_PRINTER_NAME                      TEXT("printerName")
#define SPLDS_PRINT_KEEP_PRINTED_JOBS           TEXT("printKeepPrintedJobs")
#define SPLDS_PRINT_LANGUAGE                    TEXT("printLanguage")
#define SPLDS_PRINT_MAC_ADDRESS                 TEXT("printMACAddress")
#define SPLDS_PRINT_MAX_X_EXTENT                TEXT("printMaxXExtent")
#define SPLDS_PRINT_MAX_Y_EXTENT                TEXT("printMaxYExtent")
#define SPLDS_PRINT_MAX_RESOLUTION_SUPPORTED    TEXT("printMaxResolutionSupported")
#define SPLDS_PRINT_MEDIA_READY                 TEXT("printMediaReady")
#define SPLDS_PRINT_MEDIA_SUPPORTED             TEXT("printMediaSupported")
#define SPLDS_PRINT_MEMORY                      TEXT("printMemory")
#define SPLDS_PRINT_MIN_X_EXTENT                TEXT("printMinXExtent")
#define SPLDS_PRINT_MIN_Y_EXTENT                TEXT("printMinYExtent")
#define SPLDS_PRINT_NETWORK_ADDRESS             TEXT("printNetworkAddress")
#define SPLDS_PRINT_NOTIFY                      TEXT("printNotify")
#define SPLDS_PRINT_NUMBER_UP                   TEXT("printNumberUp")
#define SPLDS_PRINT_ORIENTATIONS_SUPPORTED      TEXT("printOrientationsSupported")
#define SPLDS_PRINT_OWNER                       TEXT("printOwner")
#define SPLDS_PRINT_RATE                        TEXT("printRate")
#define SPLDS_PRINT_RATE_UNIT                   TEXT("printRateUnit")
#define SPLDS_PRINT_SEPARATOR_FILE              TEXT("printSeparatorFile")
#define SPLDS_PRINT_SHARE_NAME                  TEXT("printShareName")
#define SPLDS_PRINT_SPOOLING                    TEXT("printSpooling")
#define SPLDS_PRINT_STAPLING_SUPPORTED          TEXT("printStaplingSupported")
#define SPLDS_PRINT_START_TIME                  TEXT("printStartTime")
#define SPLDS_PRINT_STATUS                      TEXT("printStatus")
#define SPLDS_PRIORITY                          TEXT("priority")
#define SPLDS_SERVER_NAME                       TEXT("serverName")
#define SPLDS_UNC_NAME                          TEXT("uNCName")
#define SPLDS_URL                               TEXT("url")
#define SPLDS_VERSION_NUMBER                    TEXT("versionNumber")

{
-- Additional Print-Queue properties --

These properties are not defined in the default Directory Services Schema,
but should be used when extending the Schema so a consistent interface is maintained.
}


#define SPLDS_PRINTER_NAME_ALIASES              TEXT("printerNameAliases")      // MULTI_SZ
#define SPLDS_PRINTER_LOCATIONS                 TEXT("printerLocations")        // MULTI_SZ
#define SPLDS_PRINTER_MODEL                     TEXT("printerModel")            // SZ
*/


Const PRINTER_HTML_VIEW_QUEUE          = 0;
      PRINTER_HTML_VIEW_PRINTPROPERTIES= 1;
      PRINTER_HTML_VIEW_INSTALL        = 2;
      PRINTER_HTML_VIEW_JOBPROPERTIES  = 3;

/*
DWORD
WINAPI
SetPrinterHTMLView(
    HANDLE hPrinter,
    DWORD dwView,
    LPCSTR lpszPath
);

DWORD
WINAPI
GetPrinterHTMLView(
    HANDLE hPrinter,
    DWORD dwView,
    LPSTR lpszPath,
    DWORD nSize,
    LPDWORD pcbNeeded
);*/

type
  pWinSpoolDrvFunc = ^tWinSpoolDrvFunc;
  tWinSpoolDrvFunc = Record
    OpenPrinter      : Function(var pPrinterName : cString; phPrinter : tphPrinter;
                                pDefault  : tpPRINTER_DEFAULTS) : Bool; APIENTRY;
    ClosePrinter     : Function(hPrinter : thPrinter) : Bool; APIENTRY;
    EnumPrinters     : Function(Flags : LongWord; Name : PChar; Level : LongWord;
                                pPrinterEnum : LPBYTE; cbBuf : LongWord;
                                var pcbNeeded : LongWord; var pcReturned : LongWord) : Bool; APIENTRY;
    PrinterProperties: Function(ahWnd : HWND; hPrinter : thPrinter) : Bool; APIENTRY;
    GetDefaultPrinter: Function(var pszBuffer : cString; var pcchBuffer : LongWord): BOOL; APIENTRY;
  End;

type
  tcWinSpoolDrv = Class(tcDLL)
    private
      fWinSpoolDrvFunc : tWinSpoolDrvFunc;
    Public
      Constructor Create; virtual;
      property Func : tWinSpoolDrvFunc read fWinSpoolDrvFunc;
  End;


Implementation

Constructor tcWinSpoolDrv.Create;

Begin
  Inherited Create('Winspool.drv');
  Upper:=false;
  if DLLLoaded then
    Begin
      fWinSpoolDrvFunc.OpenPrinter:=pointer(GetProcAddress('OpenPrinterA'));
      fWinSpoolDrvFunc.ClosePrinter:=pointer(GetProcAddress('ClosePrinter'));
      fWinSpoolDrvFunc.EnumPrinters:=pointer(GetProcAddress('EnumPrintersA'));
      fWinSpoolDrvFunc.PrinterProperties:=pointer(GetProcAddress('PrinterProperties'));
    End;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  09-Feb-06  MV/ZE      Verbesserung der Printer-Funktionalitaet (fuer Windows)
}

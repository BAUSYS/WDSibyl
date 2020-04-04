
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit Ddeml;

Interface

uses WinNT,WinDef,WinBase,WinUser;

Type
    HConvList=Longint;
    HConv=Longint;
    HSz=Longint;
    HDDEData=Longint;

Type
    PHSZPair=^THSZPair;
    THSZPair=Record
                 hszSvc: HSZ;
                 hszTopic: HSZ;
    End;

    PConvContext=^TConvContext;
    TConvContext=Record
                 cb: LongWord;
                 wFlags: LongWord;
                 wCountryID: LongWord;
                 iCodePage: Integer;
                 dwLangID: DWORD;
                 dwSecurity: DWORD;
                 qos: TSecurityQualityOfService;
    End;

    PConvInfo=^TConvInfo;
    TConvInfo=Record
                 cb: DWORD;
                 hUser: DWORD;
                 hConvPartner: HConv;
                 hszSvcPartner: HSz;
                 hszServiceReq: HSz;
                 hszTopic: HSz;
                 hszItem: HSz;
                 wFmt: LongWord;
                 wType: LongWord;
                 wStatus: LongWord;
                 wConvst: LongWord;
                 wLastError: LongWord;
                 hConvList: HConvList;
                 ConvCtxt: TConvContext;
                 hwnd: HWND;
                 hwndPartner: HWND;
    End;

Type
  TFNCallback=Function(CallType,Fmt:LongWord;Conv:HConv;hsz1,hsz2:HSZ;
                       Data:HDDEData;Data1,Data2:LongWord):HDDEData;APIENTRY;

Const
  CBR_BLOCK = $FFFFFFFF;

Const
     CBF_FAIL_SELFCONNECTIONS = $00001000;
     CBF_FAIL_CONNECTIONS = $00002000;
     CBF_FAIL_ADVISES = $00004000;
     CBF_FAIL_EXECUTES = $00008000;
     CBF_FAIL_POKES = $00010000;
     CBF_FAIL_REQUESTS = $00020000;
     CBF_FAIL_ALLSVRXACTIONS = $0003f000;

     CBF_SKIP_CONNECT_CONFIRMS = $00040000;
     CBF_SKIP_REGISTRATIONS = $00080000;
     CBF_SKIP_UNREGISTRATIONS = $00100000;
     CBF_SKIP_DISCONNECTS = $00200000;
     CBF_SKIP_ALLNOTIFICATIONS = $003c0000;

     APPCMD_CLIENTONLY = $00000010;
     APPCMD_FILTERINITS = $00000020;
     APPCMD_MASK = $00000FF0;

     APPCLASS_STANDARD = $00000000;
     APPCLASS_MASK = $0000000F;

Const
     XST_NULL = 0;
     XST_INCOMPLETE = 1;
     XST_CONNECTED = 2;
     XST_INIT1 = 3;
     XST_INIT2 = 4;
     XST_REQSENT = 5;
     XST_DATARCVD = 6;
     XST_POKESENT = 7;
     XST_POKEACKRCVD = 8;
     XST_EXECSENT = 9;
     XST_EXECACKRCVD = 10;
     XST_ADVSENT = 11;
     XST_UNADVSENT = 12;
     XST_ADVACKRCVD = 13;
     XST_UNADVACKRCVD = 14;
     XST_ADVDATASENT = 15;
     XST_ADVDATAACKRCVD = 16;

     CADV_LATEACK = $FFFF;

     ST_CONNECTED = $0001;
     ST_ADVISE = $0002;
     ST_ISLOCAL = $0004;
     ST_BLOCKED = $0008;
     ST_CLIENT = $0010;
     ST_TERMINATED = $0020;
     ST_INLIST = $0040;
     ST_BLOCKNEXT = $0080;
     ST_ISSELF = $0100;

     DDE_FACK = $8000;
     DDE_FBUSY = $4000;
     DDE_FDEFERUPD = $4000;
     DDE_FACKREQ = $8000;
     DDE_FRELEASE = $2000;
     DDE_FREQUESTED = $1000;
     DDE_FAPPSTATUS = $00ff;
     DDE_FNOTPROCESSED = $0000;
     DDE_FACKRESERVED = $3ff0;
     DDE_FADVRESERVED = $3fff;
     DDE_FDATRESERVED = $4fff;
     DDE_FPOKRESERVED = $dfff;

     MSGF_DDEMGR = $8001;

     CP_WINANSI = 1004;
     CP_WINUNICODE = 1200;
     CP_WINNEUTRAL = CP_WINANSI;

     XTYPF_NOBLOCK = $0002;
     XTYPF_NODATA = $0004;
     XTYPF_ACKREQ = $0008;

     XCLASS_MASK = $FC00;
     XCLASS_BOOL = $1000;
     XCLASS_DATA = $2000;
     XCLASS_FLAGS = $4000;
     XCLASS_NOTIFICATION = $8000;

     XTYP_ERROR = $0000 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
     XTYP_ADVDATA = $0010 or XCLASS_FLAGS;
     XTYP_ADVREQ = $0020 or XCLASS_DATA or XTYPF_NOBLOCK;
     XTYP_ADVSTART = $0030 or XCLASS_BOOL;
     XTYP_ADVSTOP = $0040 or XCLASS_NOTIFICATION;
     XTYP_EXECUTE = $0050 or XCLASS_FLAGS;
     XTYP_CONNECT = $0060 or XCLASS_BOOL or XTYPF_NOBLOCK;
     XTYP_CONNECT_CONFIRM = $0070 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
     XTYP_XACT_COMPLETE = $0080 or XCLASS_NOTIFICATION;
     XTYP_POKE = $0090 or XCLASS_FLAGS;
     XTYP_REGISTER = $00A0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
     XTYP_REQUEST = $00B0 or XCLASS_DATA;
     XTYP_DISCONNECT = $00C0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
     XTYP_UNREGISTER = $00D0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;
     XTYP_WILDCONNECT = $00E0 or XCLASS_DATA or XTYPF_NOBLOCK;

     XTYP_MASK = $00F0;
     XTYP_SHIFT = 4;

     TIMEOUT_ASYNC =           -1;

     QID_SYNC =                -1;

     SZDDESYS_TOPIC = 'System';
     SZDDESYS_ITEM_TOPICS = 'Topics';
     SZDDESYS_ITEM_SYSITEMS = 'SysItems';
     SZDDESYS_ITEM_RTNMSG = 'ReturnMessage';
     SZDDESYS_ITEM_STATUS = 'Status';
     SZDDESYS_ITEM_FORMATS = 'Formats';
     SZDDESYS_ITEM_HELP = 'Help';
     SZDDE_ITEM_ITEMLIST = 'TopicItemList';

Const
     EC_ENABLEALL = 0;
     EC_ENABLEONE = ST_BLOCKNEXT;
     EC_DISABLE = ST_BLOCKED;
     EC_QUERYWAITING = 2;

     DNS_REGISTER = $0001;
     DNS_UNREGISTER = $0002;
     DNS_FILTERON = $0004;
     DNS_FILTEROFF = $0008;

     HDATA_APPOWNED = $0001;

     DMLERR_NO_ERROR = 0;

     DMLERR_FIRST = $4000;

     DMLERR_ADVACKTIMEOUT = $4000;
     DMLERR_BUSY = $4001;
     DMLERR_DATAACKTIMEOUT = $4002;
     DMLERR_DLL_NOT_INITIALIZED = $4003;
     DMLERR_DLL_USAGE = $4004;
     DMLERR_EXECACKTIMEOUT = $4005;
     DMLERR_INVALIDPARAMETER = $4006;
     DMLERR_LOW_MEMORY = $4007;
     DMLERR_MEMORY_ERROR = $4008;
     DMLERR_NOTPROCESSED = $4009;
     DMLERR_NO_CONV_ESTABLISHED = $400a;
     DMLERR_POKEACKTIMEOUT = $400b;
     DMLERR_POSTMSG_FAILED = $400c;
     DMLERR_REENTRANCY = $400D;
     DMLERR_SERVER_DIED = $400E;
     DMLERR_SYS_ERROR = $400F;
     DMLERR_UNADVACKTIMEOUT = $4010;
     DMLERR_UNFOUND_QUEUE_ID = $4011;

     DMLERR_LAST = $4011;

Type
  TDdemlMsgHookData=Record
           uiLo: LongWord;
           uiHi: LongWord;
           cbData: DWORD;
           Data: array [0..7] of DWORD;
  End;

  TMonMsgStruct=Record
        cb: LongWord;
        hWndTo: HWND;
        dwTime: DWORD;
        hTask: LongWord;
        wMsg: LongWord;
        wParam: WPARAM;
        lParam: LPARAM;
        dmhd: TDdemlMsgHookData;
  end;

  TMonCBStruct=Record
        cb: LongWord;
        dwTime: DWORD;
        hTask: LongWord;
        dwRet: DWORD;
        wType: LongWord;
        wFmt: LongWord;
        hConv: HConv;
        hsz1: HSZ;
        hsz2: HSZ;
        hData: HDDEData;
        dwData1: DWORD;
        dwData2: DWORD;
        cc: TConvContext;
        cbData: DWORD;
        Data: array [0..7] of DWORD;
  end;

  TMonHSZStructA=Record
        cb: LongWord;
        fsAction: BOOL;
        dwTime: DWORD;
        HSZ: HSZ;
        hTask: LongWord;
        wReserved: LongWord;
        Str: array[0..0] of AnsiChar;
  End;

  TMonHSZStructW=Record
        cb: LongWord;
        fsAction: BOOL;
        dwTime: DWORD;
        HSZ: HSZ;
        hTask: LongWord;
        wReserved: LongWord;
        Str: array[0..0] of Word;
  End;
  TMonHSZStruct = TMonHSZStructA;

Const
     MH_CREATE = 1;
     MH_KEEP = 2;
     MH_DELETE = 3;
     MH_CLEANUP = 4;

Type
  PMonErrStruct=^TMonErrStruct;
  TMonErrStruct=Record
        cb: LongWord;
        wLastError: LongWord;
        dwTime: DWORD;
        hTask: LongWord;
  End;

  PMonLinkStruct=^TMonLinkStruct;
  TMonLinkStruct=Record
        cb: LongWord;
        dwTime: DWORD;
        hTask: LongWord;
        fEstablished: BOOL;
        fNoData: BOOL;
        hszSvc: HSz;
        hszTopic: HSz;
        hszItem: HSz;
        wFmt: LongWord;
        fServer: BOOL;
        hConvServer: HConv;
        hConvClient: HConv;
  End;

  PMonConvStruct=^TMonConvStruct;
  TMonConvStruct=Record
        cb: LongWord;
        fConnect: BOOL;
        dwTime: DWORD;
        hTask: LongWord;
        hszSvc: HSz;
        hszTopic: HSz;
        hConvClient: HConv;
        hConvServer: HConv;
  End;

Const
     MAX_MONITORS = 4;
     APPCLASS_MONITOR = 1;
     XTYP_MONITOR = $00F0 or XCLASS_NOTIFICATION or XTYPF_NOBLOCK;

     MF_HSZ_INFO = $01000000;
     MF_SENDMSGS = $02000000;
     MF_POSTMSGS = $04000000;
     MF_CALLBACKS = $08000000;
     MF_ERRORS = $10000000;
     MF_LINKS = $20000000;
     MF_CONV = $40000000;


  ddelib = 'user32.dll';

Imports
    Function DdeInitialize(var Inst: Longint; Callback:TFNCallback;
      Cmd, Res: Longint): Longint;APIENTRY; 'User32' name 'DdeInitializeA';
    Function DdeInitializeW(var Inst: Longint; Callback: TFNCallback;
      Cmd, Res: Longint): Longint;APIENTRY; 'User32' name 'DdeInitializeW';
    Function DdeUninitialize(Inst: DWORD): BOOL;APIENTRY; 'User32' name 'DdeUninitialize';
    Function DdeConnectList(Inst: DWORD; Service, Topic: HSZ;
      ConvList: HConvList; CC: PConvContext): HConvList;APIENTRY; 'User32' name 'DdeConnectList';
    Function DdeQueryNextServer(ConvList: HConvList; ConvPrev: HConv): HConv;APIENTRY; 'User32' name 'DdeQueryNextServer';
    Function DdeDisconnectList(ConvList: HConvList): BOOL;APIENTRY; 'User32' name 'DdeDisconnectList';
    Function DdeConnect(Inst: DWORD; Service, Topic: HSZ;
      CC: PConvContext): HConv;APIENTRY; 'User32' name 'DdeConnect';
    Function DdeDisconnect(Conv: HConv): BOOL;APIENTRY; 'User32' name 'DdeDisconnect';
    Function DdeReconnect(Conv: HConv): HConv;APIENTRY; 'User32' name 'DdeReconnect';
    Function DdeQueryConvInfo(Conv: HConv; Transaction: DWORD;
     ConvInfo: PConvInfo): LongWord;APIENTRY; 'User32' name 'DdeQueryConvInfo';
    Function DdeSetUserHandle(Conv: HConv; ID, User: DWORD): BOOL;APIENTRY; 'User32' name 'DdeSetUserHandle';
    Function DdeAbandonTransaction(Inst: DWORD; Conv: HConv;
      Transaction: DWORD): BOOL;APIENTRY; 'User32' name 'DdeAbandonTransaction';
    Function DdePostAdvise(Inst: DWORD; Topic, Item: HSZ): BOOL;APIENTRY; 'User32' name 'DdePostAdvise';
    Function DdeEnableCallback(Inst: DWORD; Conv: HConv; Cmd: LongWord): BOOL;APIENTRY; 'User32' name 'DdeEnableCallback';
    Function DdeNameService(Inst: DWORD; hsz1, hsz2: HSZ; Cmd: LongWord): HDDEData;APIENTRY; 'User32' name 'DdeNameService';
    Function DdeClientTransaction(Var Data; DataLen: DWORD;
      Conv: HConv; Item: HSZ; Fmt, DataType: LongWord; Timeout: DWORD;
      Var Result:LongWord): HDDEData;APIENTRY; 'User32' name 'DdeClientTransaction';
    Function DdeCreateDataHandle(Inst: DWORD;Var Src;
      cb, Off: DWORD; Item: HSZ; Fmt, Cmd: LongWord): HDDEData;APIENTRY; 'User32' name 'DdeCreateDataHandle';
    Function DdeAddData(Data: HDDEData;Var Src;
      cb, Off: DWORD): HDDEData;APIENTRY; 'User32' name 'DdeAddData';
    Function DdeGetData(Data: HDDEData;Var Dst;
      Max, Off: DWORD): DWORD;APIENTRY; 'User32' name 'DdeGetData';
    Function DdeAccessData(Data: HDDEData;Var DataSize:LongWord): Pointer;APIENTRY; 'User32' name 'DdeAccessData';
    Function DdeUnaccessData(Data: HDDEData): BOOL;APIENTRY; 'User32' name 'DdeUnaccessData';
    Function DdeFreeDataHandle(Data: HDDEData): BOOL;APIENTRY; 'User32' name 'DdeFreeDataHandle';
    Function DdeGetLastError(Inst: DWORD): LongWord;APIENTRY; 'User32' name 'DdeGetLastError';
    Function DdeCreateStringHandle(Inst: DWORD;Const psz:CString;
      CodePage: Integer): HSZ;APIENTRY; 'User32' name 'DdeCreateStringHandleA';
    Function DdeCreateStringHandleW(Inst: DWORD;Const psz:CString;
      CodePage: Integer): HSZ;APIENTRY; 'User32' name 'DdeCreateStringHandleW';
    Function DdeQueryString(Inst: DWORD; aHSZ: HSZ;Var psz:CString;
      Max: DWORD; CodePage: Integer): DWORD;APIENTRY; 'User32' name 'DdeQueryStringA';
    Function DdeQueryStringW(Inst: DWORD; aHSZ: HSZ;Var psz:CString;
      Max: DWORD; CodePage: Integer): DWORD;APIENTRY; 'User32' name 'DdeQueryStringW';
    Function DdeFreeStringHandle(Inst: DWORD; aHSZ: HSZ): BOOL;APIENTRY; 'User32' name 'DdeFreeStringHandle';
    Function DdeKeepStringHandle(Inst: DWORD; aHSZ: HSZ): BOOL;APIENTRY; 'User32' name 'DdeKeepStringHandle';
    Function DdeCmpStringHandles(hsz1, hsz2: HSZ): Integer;APIENTRY; 'User32' name 'DdeCmpStringHandles';
End;

implementation

end.


{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ScktComp;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Delphi 3 compatible sockets                                          บ
 บ     Portions Copyright (C) 1997 Borland Inc.                             บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Interface

Uses SysUtils,Classes,Forms,SyncComp,
     uSysClass,
     uList,
     uStream;

{$IFDEF OS2}
Uses Os2Def,BseDos,BseErr,PmWin;
{$ENDIF}
{$IFDEF WIN32}
Uses WinNT,WinBase,WinUser;
{$ENDIF}

Const
  CM_SOCKETMESSAGE = WM_USER + $0005;
  CM_DEFERFREE = WM_USER + $0006;

  {$IFDEF OS2}
  INFINITE=SEM_INDEFINITE_WAIT;
  {$ENDIF}
  {$IFDEF WIN32}
  INFINITE=WinBase.INFINITE;
  {$ENDIF}

Type
  ESocketError = class(Exception);

  TSocket=LongInt;

  TIn_Addr=Record
                 Case Integer Of
                   1:(S_un_b:Record s_b1,s_b2,s_b3,s_b4:Byte; End;);
                   2:(s_un_w:Record s_w1,s_w2:Word; End;);
                   3:(s_addr:LongWord);
  End;

  TSockAddrIn=Record
                    sin_family:Integer;
                    sin_port:Word;
                    sin_addr:TIn_addr;
                    sin_zero:CString[7];;
  End;
  TInAddr=TIn_Addr;

  TServerWinSocket=Class;
  TServerClientWinSocket=Class;
  TCustomWinSocket=Class;
  TCustomSocket=Class;
  TServerAcceptThread=Class;
  TServerClientThread=Class;

  {$M+}
  TClientType = (ctNonBlocking, ctBlocking);
  TServerType = (stNonBlocking, stThreadBlocking);

  TSocketEvent=(seLookup, seConnecting, seConnect, seDisconnect, seListen,
                seAccept, seWrite, seRead, seDisconnected);
  TErrorEvent = (eeGeneral, eeSend, eeReceive, eeConnect, eeDisconnect, eeAccept);

  TGetSocketEvent = Procedure(Sender: TObject; Socket: TSocket;
                              Var ClientSocket: TServerClientWinSocket) of object;
  TGetThreadEvent = Procedure(Sender: TObject; ClientSocket: TServerClientWinSocket;
                              Var SocketThread: TServerClientThread) of object;

  TSocketEventEvent = Procedure(Sender: TObject; Socket: TCustomWinSocket;
                                SocketEvent: TSocketEvent) Of Object;
  TSocketErrorEvent = Procedure(Sender: TObject; Socket: TCustomWinSocket;
                                ErrorEvent: TErrorEvent; Var ErrorCode:Word) Of Object;

  TSocketNotifyEvent = Procedure(Sender: TObject; Socket: TCustomWinSocket) Of Object;

  TThreadNotifyEvent = Procedure(Sender:TObject;Thread: TServerClientThread) Of Object;

  TAsyncStyle=(asRead,asWrite,asOOB,asAccept,asConnect,asClose);
  TAsyncStyles=Set Of TAsyncStyle;
  {$M-}

  TCustomWinSocket=Class
    Private
       FConnected: Boolean;
       FSendStream: TStream;
       FSocket: TSocket;
       FDropAfterSend: Boolean;
       FHandle:LongWord;
       FOnSocketEvent: TSocketEventEvent;
       FOnErrorEvent: TSocketErrorEvent;
       FData: Pointer;
       FSocketControl:TControl;
       FAddr: TSockAddrIn;
       FAsyncStyles: TASyncStyles;
    Private
       Function GetHandle:LongWord;
       Function GetLocalHost:String;
       Function GetLocalAddress:String;
       Function GetLocalPort:LongInt;
       Function GetRemoteHost:String;
       Function GetRemoteAddress:String;
       Function GetRemotePort:LongInt;
       Function GetRemoteAddr:TSockAddrIn;
    Protected
       Procedure Open(Var Name,Address,Service:String;Port:Word);
       Procedure Read(Socket:TSocket); Virtual;
       Procedure Write(Socket:TSocket); Virtual;
       Procedure Connect(Socket:TSocket); Virtual;
       Procedure Disconnect(Socket:TSocket); Virtual;
       Function InitSocket(Var Name,Address,Service:String;Port:Word;
                           Client:Boolean):TSockAddrIn;
       Procedure Event(Socket:TCustomWinSocket;SocketEvent:TSocketEvent); Virtual;
       Procedure Error(Socket:TCustomWinSocket;ErrorEvent:TErrorEvent;Var ErrorCode:Word); Virtual;
       Procedure SetAsyncStyles(Value:TASyncStyles);
       Procedure Listen(Var Name,Address,Service:String;Port:Word;QueueSize:LongInt);
       Procedure Accept(Socket:TSocket); Virtual;
    Public
       Constructor Create(ASocket:TSocket);
       Destructor Destroy; Override;
       Function ReceiveBuf(Var Buf;Count:LongInt):LongInt;
       Function ReceiveText: String;
       Function SendBuf(Var Buf; Count: LongInt): LongInt;
       Function SendStream(AStream: TStream): Boolean;
       Procedure Close;
       Function LookupName(Const Name:String):TInAddr;
       Function LookupService(Const Service:String):LongInt;
       Function ReceiveLength:LongInt;
       Function SendStreamThenDrop(AStream:TStream): Boolean;
       Procedure SendText(Const S:String);
    Public
       Property LocalHost:String read GetLocalHost;
       Property LocalAddress:String read GetLocalAddress;
       Property LocalPort:LongInt read GetLocalPort;
       Property RemoteHost:String read GetRemoteHost;
       Property RemoteAddress:String read GetRemoteAddress;
       Property RemotePort:LongInt read GetRemotePort;
       Property RemoteAddr:TSockAddrIn read GetRemoteAddr;
       Property Connected:Boolean read FConnected;
       Property Addr:TSockAddrIn read FAddr;
       Property ASyncStyles:TAsyncStyles read FAsyncStyles write SetAsyncStyles;
       Property Handle:LongWord read GetHandle;
       Property SocketHandle:TSocket read FSocket;
       Property OnSocketEvent:TSocketEventEvent read FOnSocketEvent write FOnSocketEvent;
       Property OnErrorEvent:TSocketErrorEvent read FOnErrorEvent write FOnErrorEvent;
       Property Data:Pointer read FData write FData;
  End;

  TClientWinSocket=Class(TCustomWinSocket)
    Private
       FClientType:TClientType;
    Protected
       Procedure Connect(Socket:TSocket); Override;
       Procedure SetClientType(Value:TClientType);
    Public
       Property ClientType:TClientType read FClientType write SetClientType;
  End;

  TServerClientWinSocket=Class(TCustomWinSocket)
    Private
       FServerWinSocket: TServerWinSocket;
    Public
       Constructor Create(Socket:TSocket;ServerWinSocket:TServerWinSocket);
       Destructor Destroy; Override;
    Public
       Property ServerWinSocket:TServerWinSocket read FServerWinSocket;
  End;

  TServerWinSocket=Class(TCustomWinSocket)
    Private
       FConnections: TList;
       FActiveThreads: TList;
       FServerType: TServerType;
       FThreadCacheSize: LongInt;
       FServerAcceptThread: TServerAcceptThread;
       FOnGetSocket: TGetSocketEvent;
       FOnGetThread: TGetThreadEvent;
       FOnThreadStart: TThreadNotifyEvent;
       FOnThreadEnd: TThreadNotifyEvent;
       FOnClientConnect: TSocketNotifyEvent;
       FOnClientDisconnect: TSocketNotifyEvent;
       FOnClientDisconnected: TSocketNotifyEvent;
       FOnClientRead: TSocketNotifyEvent;
       FOnClientWrite: TSocketNotifyEvent;
       FOnClientError: TSocketErrorEvent;
    Private
       Procedure ClientEvent(Sender:TObject;Socket:TCustomWinSocket;SocketEvent: TSocketEvent);
       Procedure ClientError(Sender:TObject;Socket:TCustomWinSocket;
                             ErrorEvent:TErrorEvent;Var ErrorCode:Word);
       Function GetActiveConnections:LongInt;
       Function GetActiveThreads:LongInt;
       Function GetConnections(Index:LongInt):TCustomWinSocket;
       Function GetIdleThreads:LongInt;
    Protected
       Procedure Accept(Socket:TSocket); Override;
       Procedure ClientConnect(Socket:TCustomWinSocket); Virtual;
       Procedure ClientDisconnect(Socket:TCustomWinSocket); Virtual;
       Procedure ClientDisconnected(Socket:TCustomWinSocket); Virtual;
       Procedure ClientErrorEvent(Socket:TCustomWinSocket; ErrorEvent: TErrorEvent;
                                  Var ErrorCode:Word); Virtual;
       Procedure Disconnect(Socket:TSocket); Override;
       Procedure ClientRead(Socket:TCustomWinSocket); Virtual;
       Procedure ClientWrite(Socket:TCustomWinSocket); Virtual;
       Function DoCreateThread(ClientSocket:TServerClientWinSocket): TServerClientThread; Virtual;
       Procedure Listen(Var Name,Address,Service:String;Port:Word;QueueSize:LongInt);
       Procedure SetServerType(Value:TServerType);
       Procedure SetThreadCacheSize(Value:LongInt);
       Procedure ThreadEnd(AThread:TServerClientThread); Virtual;
       Procedure ThreadStart(AThread:TServerClientThread); Virtual;
       Function GetClientSocket(Socket:TSocket): TServerClientWinSocket; Virtual;
       Function GetServerThread(ClientSocket:TServerClientWinSocket): TServerClientThread; Virtual;
    Public
       Constructor Create(ASocket:TSocket);
       Destructor Destroy; Override;
       Function GetClientThread(ClientSocket:TServerClientWinSocket): TServerClientThread;
    Public
       Property ActiveConnections:LongInt read GetActiveConnections;
       Property ActiveThreads:LongInt read GetActiveThreads;
       Property Connections[Index: LongInt]: TCustomWinSocket read GetConnections;
       Property IdleThreads:LongInt read GetIdleThreads;
       Property ServerType:TServerType read FServerType write SetServerType;
       Property ThreadCacheSize: LongInt read FThreadCacheSize write SetThreadCacheSize;
       Property OnGetSocket:TGetSocketEvent read FOnGetSocket write FOnGetSocket;
       Property OnGetThread:TGetThreadEvent read FOnGetThread write FOnGetThread;
       Property OnThreadStart:TThreadNotifyEvent read FOnThreadStart write FOnThreadStart;
       Property OnThreadEnd:TThreadNotifyEvent read FOnThreadEnd write FOnThreadEnd;
       Property OnClientConnect:TSocketNotifyEvent read FOnClientConnect write FOnClientConnect;
       Property OnClientDisconnect:TSocketNotifyEvent read FOnClientDisconnect write FOnClientDisconnect;
       Property OnClientDisconnected:TSocketNotifyEvent read FOnClientDisconnected write FOnClientDisconnected;
       Property OnClientRead:TSocketNotifyEvent read FOnClientRead write FOnClientRead;
       Property OnClientWrite:TSocketNotifyEvent read FOnClientWrite write FOnClientWrite;
       Property OnClientError:TSocketErrorEvent read FOnClientError write FOnClientError;
  End;

  TServerAcceptThread=Class(TThread)
    Private
       FServerSocket: TServerWinSocket;
    Public
       Constructor Create(CreateSuspended:Boolean;ASocket:TServerWinSocket);
       Procedure Execute; Override;
    Public
       Property ServerSocket:TServerWinSocket read FServerSocket;
  End;

  TServerClientThread = class(TThread)
    Private
       FKeepInCache: Boolean;
       FData: Pointer;
       FClientSocket: TServerClientWinSocket;
       FServerSocket: TServerWinSocket;
       FException: Exception;
       FEvent: TSimpleEvent;
    Private
       Procedure HandleEvent(Sender:TObject;Socket:TCustomWinSocket;SocketEvent: TSocketEvent);
       Procedure HandleError(Sender:TObject;Socket:TCustomWinSocket;
                             ErrorEvent:TErrorEvent;Var ErrorCode:Word);
       Procedure DoHandleException;
       Procedure DoRead;
       Procedure DoWrite;
    Protected
       Procedure DoTerminate; Override;
       Procedure Execute; Override;
       Procedure ClientExecute; virtual;
       Procedure Event(SocketEvent:TSocketEvent); virtual;
       Procedure Error(ErrorEvent:TErrorEvent; Var ErrorCode:Word); virtual;
       Procedure HandleException(e:Exception); virtual;
       Procedure ReActivate(ASocket:TServerClientWinSocket);
       Function StartConnect:Boolean;
       Function EndConnect:Boolean;
    Public
       Constructor Create(CreateSuspended:Boolean;ASocket:TServerClientWinSocket);
       Destructor Destroy; Override;
    Public
       Property ClientSocket:TServerClientWinSocket read FClientSocket;
       Property ServerSocket:TServerWinSocket read FServerSocket;
       Property KeepInCache:Boolean read FKeepInCache write FKeepInCache;
       Property Data:Pointer read FData write FData;
  End;

  TCustomSocket=Class(TComponent)
    Private
       FActive:Boolean;
       FPort:LongInt;
       FAddress:String;
       FHost:String;
       FService:String;
       FOnLookup:TSocketNotifyEvent;
       FOnConnect:TSocketNotifyEvent;
       FOnConnecting:TSocketNotifyEvent;
       FOnDisconnect:TSocketNotifyEvent;
       FOnListen:TSocketNotifyEvent;
       FOnAccept:TSocketNotifyEvent;
       FOnRead:TSocketNotifyEvent;
       FOnWrite:TSocketNotifyEvent;
       FOnError:TSocketErrorEvent;
    Private
       Procedure DoEvent(Sender:TObject;Socket:TCustomWinSocket;SocketEvent:TSocketEvent);
       Procedure DoError(Sender:TObject;Socket:TCustomWinSocket;ErrorEvent:TErrorEvent;Var ErrorCode:Word);
    Protected
       Procedure Event(Socket:TCustomWinSocket;SocketEvent:TSocketEvent); Virtual;
       Procedure Error(Socket:TCustomWinSocket;ErrorEvent:TErrorEvent;Var ErrorCode:Word); Virtual;
       Procedure DoActivate(Value:Boolean); Virtual; Abstract;
       Procedure Loaded; Override;
       Procedure SetActive(Value:Boolean);
       Procedure SetAddress(Value:String);
       Procedure SetHost(Value:String);
       Procedure SetPort(Value:LongInt);
       Procedure SetService(Value:String);
    Protected
       Property Active:Boolean read FActive write SetActive;
       Property Address:String read FAddress write SetAddress;
       Property OnRead:TSocketNotifyEvent read FOnRead write FOnRead;
       Property OnWrite:TSocketNotifyEvent read FOnWrite write FOnWrite;
       Property Host:String read FHost write SetHost;
       Property Port:LongInt read FPort write SetPort;
       Property Service:String read FService write SetService;
       Property OnLookup:TSocketNotifyEvent read FOnLookup write FOnLookup;
       Property OnConnecting:TSocketNotifyEvent read FOnConnecting write FOnConnecting;
       Property OnConnect:TSocketNotifyEvent read FOnConnect write FOnConnect;
       Property OnDisconnect:TSocketNotifyEvent read FOnDisconnect write FOnDisconnect;
       Property OnListen:TSocketNotifyEvent read FOnListen write FOnListen;
       Property OnAccept:TSocketNotifyEvent read FOnAccept write FOnAccept;
       Property OnError:TSocketErrorEvent read FOnError write FOnError;
    Public
       Procedure Open;
       Procedure Close;
  End;

  TWinSocketStream=Class(TStream)
    Private
       FSocket: TCustomWinSocket;
       FTimeout: Longint;
       FEvent: TSimpleEvent;
    Public
       Constructor Create(ASocket:TCustomWinSocket;TimeOut:Longint);
       Destructor Destroy; Override;
       Function WaitForData(Timeout:Longint):Boolean;
       Function Read(Var Buffer;Count:Longint):Longint; Override;
       Function Write(Const Buffer;Count:Longint):Longint; Override;
       Function Seek(Offset:Longint;Origin:Word):Longint; Override;
    Public
       Property TimeOut:Longint read FTimeout write FTimeout;
  End;

  TClientSocket=Class(TCustomSocket)
    Private
       FClientSocket: TClientWinSocket;
    Private
       Procedure DoActivate(Value:Boolean); Override;
    Protected
       Function GetClientType:TClientType;
       Procedure SetClientType(Value:TClientType);
    Public
       Constructor Create(AOwner:TComponent); Override;
       Destructor Destroy; Override;
    Public
       Property Socket:TClientWinSocket read FClientSocket;
    Published
       Property Active;
       Property Address;
       Property ClientType:TClientType read GetClientType write SetClientType;
       Property Host;
       Property Port;
       Property Service;
       Property OnLookup;
       Property OnConnecting;
       Property OnConnect;
       Property OnDisconnect;
       Property OnRead;
       Property OnWrite;
       Property OnError;
  End;

  TServerSocket = class(TCustomSocket)
    Private
       Procedure DoActivate(Value:Boolean); Override;
    Protected
       FServerSocket: TServerWinSocket;
    Protected
       Function GetServerType:TServerType;
       Function GetGetThreadEvent:TGetThreadEvent;
       Function GetGetSocketEvent:TGetSocketEvent;
       Function GetThreadCacheSize:LongInt;
       Function GetOnThreadStart:TThreadNotifyEvent;
       Function GetOnThreadEnd:TThreadNotifyEvent;
       Function GetOnClientConnect:TSocketNotifyEvent;
       Function GetOnClientDisconnect:TSocketNotifyEvent;
       Function GetOnClientDisconnected:TSocketNotifyEvent;
       Function GetOnClientRead:TSocketNotifyEvent;
       Function GetOnClientWrite:TSocketNotifyEvent;
       Function GetOnClientError:TSocketErrorEvent;
       Procedure SetServerType(Value:TServerType);
       Procedure SetGetThreadEvent(Value:TGetThreadEvent);
       Procedure SetGetSocketEvent(Value:TGetSocketEvent);
       Procedure SetThreadCacheSize(Value:LongInt);
       Procedure SetOnThreadStart(Value:TThreadNotifyEvent);
       Procedure SetOnThreadEnd(Value:TThreadNotifyEvent);
       Procedure SetOnClientConnect(Value:TSocketNotifyEvent);
       Procedure SetOnClientDisconnect(Value:TSocketNotifyEvent);
       Procedure SetOnClientDisconnected(Value:TSocketNotifyEvent);
       Procedure SetOnClientRead(Value:TSocketNotifyEvent);
       Procedure SetOnClientWrite(Value:TSocketNotifyEvent);
       Procedure SetOnClientError(Value:TSocketErrorEvent);
    Public
       Constructor Create(AOwner: TComponent); Override;
       Destructor Destroy; Override;
    Public
       Property Socket: TServerWinSocket read FServerSocket;
    Published
       Property Active;
       Property Port;
       Property Service;
       Property OnListen;
       Property OnAccept;
       Property ServerType:TServerType read GetServerType write SetServerType;
       Property ThreadCacheSize:LongInt read GetThreadCacheSize write SetThreadCacheSize;
       Property OnGetThread:TGetThreadEvent read GetGetThreadEvent write SetGetThreadEvent;
       Property OnGetSocket:TGetSocketEvent read GetGetSocketEvent write SetGetSocketEvent;
       Property OnThreadStart:TThreadNotifyEvent read GetOnThreadStart write SetOnThreadStart;
       Property OnThreadEnd:TThreadNotifyEvent read GetOnThreadEnd write SetOnThreadEnd;
       Property OnClientConnect:TSocketNotifyEvent read GetOnClientConnect write SetOnClientConnect;
       Property OnClientDisconnect:TSocketNotifyEvent read GetOnClientDisconnect write SetOnClientDisconnect;
       Property OnClientDisconnected:TSocketNotifyEvent read GetOnClientDisconnected write SetOnClientDisconnected;
       Property OnClientRead:TSocketNotifyEvent read GetOnClientRead write SetOnClientRead;
       Property OnClientWrite:TSocketNotifyEvent read GetOnClientWrite write SetOnClientWrite;
       Property OnClientError:TSocketErrorEvent read GetOnClientError write SetOnClientError;
  End;

ThreadVar SocketErrorProc:Procedure(ErrorCode:Word);
Function SocketErrorMsg(ErrorCode:Word):String;

Implementation

Uses Forms;

Const
     INADDR_ANY              =$00000000;
     PF_INET                 =2;
     SOCK_STREAM             =1;               /* stream socket */
     IPPROTO_IP              =0;               /* dummy for IP */

     FD_READ         =$01;
     FD_WRITE        =$02;
     FD_OOB          =$04;
     FD_ACCEPT       =$08;
     FD_CONNECT      =$10;
     FD_CLOSE        =$20;

     INVALID_SOCKET  = -1;
     SOCKET_ERROR    = -1;

     IOCPARM_MASK    = $7f;
     IOC_VOID        = $20000000;
     IOC_OUT         = $40000000;
     IOC_IN          = $80000000;
     IOC_INOUT       = IOC_IN Or IOC_OUT;
     FIONREAD        = IOC_OUT Or ((Longint(SizeOf(Longint)) And IOCPARM_MASK) Shl 16) Or
                       (Longint(Byte('f')) Shl 8) Or 127;
     FIONBIO         = IOC_IN Or ((Longint(SizeOf(Longint)) And IOCPARM_MASK) Shl 16) Or
                       (Longint(Byte('f')) shl 8) Or 126;
     FIOASYNC        = IOC_IN Or ((Longint(SizeOf(Longint)) And IOCPARM_MASK) Shl 16) Or
                       (Longint(Byte('f')) Shl 8) Or 125;

     SOMAXCONN       =5;


Const
     WSABASEERR              =10000;
     WSAEINTR                =(WSABASEERR+4);
     WSAEBADF                =(WSABASEERR+9);
     WSAEACCES               =(WSABASEERR+13);
     WSAEFAULT               =(WSABASEERR+14);
     WSAEINVAL               =(WSABASEERR+22);
     WSAEMFILE               =(WSABASEERR+24);
     WSAEWOULDBLOCK          =(WSABASEERR+35);
     WSAEINPROGRESS          =(WSABASEERR+36);
     WSAEALREADY             =(WSABASEERR+37);
     WSAENOTSOCK             =(WSABASEERR+38);
     WSAEDESTADDRREQ         =(WSABASEERR+39);
     WSAEMSGSIZE             =(WSABASEERR+40);
     WSAEPROTOTYPE           =(WSABASEERR+41);
     WSAENOPROTOOPT          =(WSABASEERR+42);
     WSAEPROTONOSUPPORT      =(WSABASEERR+43);
     WSAESOCKTNOSUPPORT      =(WSABASEERR+44);
     WSAEOPNOTSUPP           =(WSABASEERR+45);
     WSAEPFNOSUPPORT         =(WSABASEERR+46);
     WSAEAFNOSUPPORT         =(WSABASEERR+47);
     WSAEADDRINUSE           =(WSABASEERR+48);
     WSAEADDRNOTAVAIL        =(WSABASEERR+49);
     WSAENETDOWN             =(WSABASEERR+50);
     WSAENETUNREACH          =(WSABASEERR+51);
     WSAENETRESET            =(WSABASEERR+52);
     WSAECONNABORTED         =(WSABASEERR+53);
     WSAECONNRESET           =(WSABASEERR+54);
     WSAENOBUFS              =(WSABASEERR+55);
     WSAEISCONN              =(WSABASEERR+56);
     WSAENOTCONN             =(WSABASEERR+57);
     WSAESHUTDOWN            =(WSABASEERR+58);
     WSAETOOMANYREFS         =(WSABASEERR+59);
     WSAETIMEDOUT            =(WSABASEERR+60);
     WSAECONNREFUSED         =(WSABASEERR+61);
     WSAELOOP                =(WSABASEERR+62);
     WSAENAMETOOLONG         =(WSABASEERR+63);
     WSAEHOSTDOWN            =(WSABASEERR+64);
     WSAEHOSTUNREACH         =(WSABASEERR+65);
     WSAENOTEMPTY            =(WSABASEERR+66);
     WSAEPROCLIM             =(WSABASEERR+67);
     WSAEUSERS               =(WSABASEERR+68);
     WSAEDQUOT               =(WSABASEERR+69);
     WSAESTALE               =(WSABASEERR+70);
     WSAEREMOTE              =(WSABASEERR+71);
     WSASYSNOTREADY          =(WSABASEERR+91);
     WSAVERNOTSUPPORTED      =(WSABASEERR+92);
     WSANOTINITIALISED       =(WSABASEERR+93);
     WSAHOST_NOT_FOUND       =(WSABASEERR+1001);
     HOST_NOT_FOUND          =WSAHOST_NOT_FOUND;
     WSATRY_AGAIN            =(WSABASEERR+1002);
     TRY_AGAIN               =WSATRY_AGAIN;
     WSANO_RECOVERY          =(WSABASEERR+1003);
     NO_RECOVERY             =WSANO_RECOVERY;
     WSANO_DATA              =(WSABASEERR+1004);
     NO_DATA                 =WSANO_DATA;
     WSANO_ADDRESS           =WSANO_DATA;
     NO_ADDRESS              =WSANO_ADDRESS;


Function SocketErrorMsg(ErrorCode:Word):String;
Begin
     Case ErrorCode Of
         WSAEINTR:Result:='Blocking call canceled';
         WSAEFAULT:Result:='Parameter fault';
         WSAEINVAL:Result:='No listen call for accept';
         WSAEMFILE:Result:='Queue empty for accept';
         WSAEWOULDBLOCK:Result:='Call would block';
         WSAEINPROGRESS:Result:='Blocking call in progress';
         WSAENOTSOCK:Result:='Invalid socket handle';
         WSAEDESTADDRREQ:Result:='Destination address required';
         WSAEMSGSIZE:Result:='Datagram too large';
         WSAENOPROTOOPT:Result:='Option not supported';
         WSAEOPNOTSUPP:Result:='Invalid socket handle type';
         WSAEAFNOSUPPORT:Result:='Address family not supported';
         WSAEADDRINUSE:Result:='Address is in use';
         WSAEADDRNOTAVAIL:Result:='Address not available';
         WSAENETDOWN:Result:='Network subsystem failure';
         WSAENETUNREACH:Result:='Network unreachable';
         WSAENETRESET:Result:='Connection timed out';
         WSAECONNABORTED:Result:='Connection aborted due to timeout or failure';
         WSAECONNRESET:Result:='Connection reset by remote host';
         WSAENOBUFS:Result:='No more buffer space';
         WSAEISCONN:Result:='Socket already connected';
         WSAENOTCONN:Result:='Socket not connected';
         WSAESHUTDOWN:Result:='Socket has been shutdown';
         WSAETIMEDOUT:Result:='TimeOut';
         WSAECONNREFUSED:Result:='Connection rejected';
         WSAENAMETOOLONG:Result:='Name too long';
         WSAEHOSTDOWN:Result:='Host down';
         WSAEHOSTUNREACH:Result:='Host unreachable';
         WSASYSNOTREADY:Result:='System not ready';
         WSAVERNOTSUPPORTED:Result:='Version not supported';
         WSANOTINITIALISED:Result:='WinSock not initialized';
         WSAHOST_NOT_FOUND:Result:='Host not found';
         WSATRY_AGAIN:Result:='Try again';
         WSANO_RECOVERY:Result:='No recovery';
         WSANO_DATA:Result:='No data';
         Else Result:='Unkown error';
     End;
     Result:=' ('+Result+'.)';
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TCustomWinSocket Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TCMSocketMessage=Record
        Msg: LongWord;
        ReceiverClass: TObject;
        Receiver: Longword;
        Handled: LONGBOOL;  {True If the message was handled}
        Socket: TSocket;
        SelectEvent: Word;
        SelectError: Word;
        Result: Longint;
    End;

    TSocketNotifyControl=Class(TControl)
      Private
         FSocket:TCustomWinSocket;
         Procedure CreateWnd;Override;
      Protected
         Procedure SetupComponent;Override;
         Procedure CMSocketMessage(Var Message: TCMSocketMessage); message CM_SOCKETMESSAGE;
         Procedure CMDeferFree(Var Message:TMessage); message CM_DEFERFREE;
    End;


Procedure TSocketNotifyControl.CreateWnd; //dummy
Begin
    Inherited CreateWnd;
End;

Procedure TSocketNotifyControl.SetupComponent;
Begin
     Inherited SetupComponent;
     Include (ComponentState, csDetail);
End;

Procedure TSocketNotifyControl.CMSocketMessage(Var Message: TCMSocketMessage);
Var
   ErrorEvent: TErrorEvent;
Begin
    Case Message.SelectEvent of
      FD_READ:
      Begin
           Message.Handled:=True;
           If Message.SelectError=0 Then
           Begin
                FSocket.Read(Message.Socket);
                exit;
           End
           Else ErrorEvent:=eeReceive;
      End;
      FD_WRITE:
      Begin
           Message.Handled:=True;
           If Message.SelectError=0 Then
           Begin
               FSocket.Write(Message.Socket);
               exit;
           End
           Else ErrorEvent:=eeSend;
      End;
      FD_ACCEPT:
      Begin
           Message.Handled:=True;
           If Message.SelectError=0 Then
           Begin
               FSocket.Accept(Message.Socket);
               exit;
           End
           Else ErrorEvent:=eeAccept;
      End;
      FD_CLOSE:
      Begin
           Message.Handled:=True;
           If Message.SelectError=0 Then
           Begin
                FSocket.Disconnect(Message.Socket);
                exit;
           End
           Else ErrorEvent:=eeDisconnect;
      End;
      FD_CONNECT:
      Begin
           Message.Handled:=True;
           If Message.SelectError=0 Then
           Begin
                FSocket.Connect(Message.Socket);
                exit;
           End
           Else ErrorEvent:=eeConnect;
      End;
      Else ErrorEvent :=eeGeneral;
    End; //case
    FSocket.Error(FSocket,ErrorEvent,Message.SelectError);
    If Message.SelectError<>0 Then
      raise ESocketError.Create('Async socket error #'+tostr(Message.SelectError)+
                                SocketErrorMsg(Message.SelectError));
End;


Procedure TSocketNotifyControl.CMDeferFree(Var Message:TMessage);
Begin
     If FSocket<>Nil Then FSocket.Destroy;
     FSocket:=Nil;
     Message.Handled:=True;
End;

Const WinSockHandle:LongWord=0;

Const
    WSADESCRIPTION_LEN      =256;
    WSASYS_STATUS_LEN       =128;

Type
    WSAData=Record
               wVersion:Word;
               wHighVersion:Word;
               szDescription: array[0..WSADESCRIPTION_LEN] of Char;
               szSystemStatus: array[0..WSASYS_STATUS_LEN] of Char;
               iMaxSockets:Word;
               iMaxUdpDg:Word;
               lpVendorInfo:PChar;
    End;
    PWSADATA=^WSAData;

Type TWinSockProcs=Record
        WSAStartup:Function(wVersionRequired:Word;Var aWSAData:WSAData):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        WSACleanup:Function:LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        WSAGetLastError:Function:LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        getsockname:Function(s:TSOCKET;Var name;Var namelen:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        getpeername:Function(s:TSOCKET;Var name;Var nameLen:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        gethostname:Function(Const name:CString;namelen:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        inet_ntoa:Function(Var _in):PChar; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        gethostbyaddr:Function(Var addr;len,typ:LongInt):Pointer; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        ntohs:Function(netshort:Word):Word; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        gethostbyname:Function(Const name:CString):Pointer; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        getservbyname:Function(Const name,proto:CString):Pointer; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        inet_addr:Function(Const cp:CString):LongWord; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        htons:Function(hostshort:Word):Word; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        socket:Function(af,typ,protocol:LongInt):TSOCKET; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        accept:Function(s:TSOCKET;Var addr;Var addrlen:LongInt):TSOCKET; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        bind:Function(s:TSOCKET;Const addr;namelen:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        WSAAsyncSelect:Function(s:TSOCKET;ahWnd:LongWord;wMsg:LongWord;lEvent:LongInt):LongWord; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        listen:Function(s:TSOCKET;backlog:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        ioctlsocket:Function(s:TSOCKET;cmd:LongInt;Var argp:LongWord):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        connect:Function(s:TSOCKET;Const name;namelen:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        closesocket:Function(s:TSOCKET):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        send:Function(s:TSOCKET;Const Buf;len,flags:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        recv:Function(s:TSOCKET;Var Buf;len,flags:LongInt):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
        select:Function(nfds:LongInt;Var readfds,writefds,exceptfds;
                        Const timeout):LongInt; {$IFDEF OS2}CDecl;{$ENDIF}{$IFDEF Win32}APIENTRY;{$ENDIF}
     End;

Var WinSockProcs:TWinSockProcs;

Function InitWinSock:BOOLEAN;
Var ok:BOOLEAN;
{$IFDEF OS2}
    c:Cstring;
{$ENDIF}

    Function GetProcAddr(Const ProcName:String):Pointer;
    Var S:cstring;
    Begin
       S:=ProcName;
       {$IFDEF OS2}
       If DosQueryProcAddr(WinSockHandle,0,S,Result)<>0 Then Raise Exception.Create(ProcName);
       {$ENDIF}
       {$IFDEF Win32}
       Result:=GetProcAddress(WinSockHandle,S);
       If Result=Nil Then Raise Exception.Create(ProcName);
       {$ENDIF}
    End;

Begin
     result:=WinSockHandle<>0;
     If result Then exit;

     {$IFDEF OS2}
     If DosLoadModule(c,255,'PMWSOCK',WinSockHandle)<>0 Then
     Begin
          WinSockHandle:=0;
          ErrorBox2('PMWSOCK.DLL not found. Sockets not available');
          exit;
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     WinSockHandle:=LoadLibrary('wsock32.dll');
     If WinSockHandle=0 Then
     Begin
          WinSockHandle:=0;
          ErrorBox2('WSOCK32.DLL not found. Sockets not available');
          exit;
     End;
     {$ENDIF}

     ok:=TRUE;
     With WinSockProcs Do
     Begin
        Try
           WSAStartup:=Pointer(GetProcAddr('WSAStartup'));
           WSACleanup:=Pointer(GetProcAddr('WSACleanup'));
           WSAGetLastError:=Pointer(GetProcAddr('WSAGetLastError'));
           getpeername:=Pointer(GetProcAddr('getpeername'));
           getsockname:=Pointer(GetProcAddr('getsockname'));
           socket:=Pointer(GetProcAddr('socket'));
           inet_ntoa:=Pointer(GetProcAddr('inet_ntoa'));
           gethostname:=Pointer(GetProcAddr('gethostname'));
           gethostbyaddr:=Pointer(GetProcAddr('gethostbyaddr'));
           ntohs:=Pointer(GetProcAddr('ntohs'));
           gethostbyname:=Pointer(GetProcAddr('gethostbyname'));
           getservbyname:=Pointer(GetProcAddr('getservbyname'));
           inet_addr:=Pointer(GetProcAddr('inet_addr'));
           htons:=Pointer(GetProcAddr('htons'));
           accept:=Pointer(GetProcAddr('accept'));
           bind:=Pointer(GetProcAddr('bind'));
           WSAAsyncSelect:=Pointer(GetProcAddr('WSAAsyncSelect'));
           listen:=Pointer(GetProcAddr('listen'));
           ioctlsocket:=Pointer(GetProcAddr('ioctlsocket'));
           connect:=Pointer(GetProcAddr('connect'));
           closesocket:=Pointer(GetProcAddr('closesocket'));
           send:=Pointer(GetProcAddr('send'));
           recv:=Pointer(GetProcAddr('recv'));
           select:=Pointer(GetProcAddr('select'));
        Except
             ok:=FALSE;
             {$IFDEF OS2}
             DosFreeModule(WinSockHandle);
             {$ENDIF}
             {$IFDEF WIN32}
             FreeLibrary(WinSockHandle);
             {$ENDIF}
             WinSockHandle:=0;
        End;
     End;

     If Not ok Then raise ESocketError.Create('Windows sockets not available');

     result:=ok;
End;


Var
  aWSAData: WSAData;

Procedure CheckSockError(Socket:TCustomWinSocket;Const Op:String);
Var ErrorCode:Word;
Begin
     If WinSockHandle<>0 Then ErrorCode:=WinSockProcs.WSAGetLastError
     Else ErrorCode:=0;
     If ErrorCode<>WSAEWOULDBLOCK Then
     Begin
          Socket.Error(Socket,eeReceive,ErrorCode);
          Socket.Disconnect(Socket.FSocket);
          If ErrorCode <> 0 Then
            raise ESocketError.Create('Socket error #'+tostr(ErrorCode)+' in '+Op+
                                      SocketErrorMsg(ErrorCode));
     End;
End;

Procedure CheckSockResult(ResultCode: Integer; Const Op: String);
Var Ret:LongInt;
Begin
    If ResultCode=0 Then exit; //no error
    If WinSockHandle<>0 Then Ret:=WinSockProcs.WSAGetLastError
    Else Ret:=0;
    If Ret=WSAEWOULDBLOCK Then exit;
    If SocketErrorProc<>Nil Then SocketErrorProc(Ret)
    Else Raise ESocketError.Create('Windows socket error #'+tostr(Ret)+' in '+Op+
                                   SocketErrorMsg(Ret));
End;

Const CallCount:LongInt=0;

Constructor TCustomWinSocket.Create(ASocket: TSocket);
Var ErrorCode:LongInt;
    InsideDesigner:Boolean;
Begin
  Inherited Create;
  InitWinSock;

  If CallCount=0 Then
  Begin
    If WinSockHandle<>0 Then
    Begin
        Asm
            MOV AL,Classes.InsideDesigner
            MOV InsideDesigner,AL
         End;
         If not InsideDesigner Then
         Begin
            ErrorCode := WinSockProcs.WSAStartup($0101, aWSAData);
            If ErrorCode <> 0 Then
              raise ESocketError.Create('Windows socket error #'+tostr(ErrorCode)+
                                        SocketErrorMsg(ErrorCode));
         End;
    End;
  End;
  inc(CallCount);

  FSocket := ASocket;
  FASyncStyles := [asRead, asWrite, asConnect, asClose];
  FAddr.sin_addr.s_addr := INADDR_ANY;
  FAddr.sin_port := 0;
  FAddr.sin_family := PF_INET;
  FConnected:=FSocket>0;
End;

Destructor TCustomWinSocket.Destroy;
Var ErrorCode:LongInt;
    InsideDesigner:Boolean;
Begin
  FOnSocketEvent := nil;
  If FSocket>0 Then Disconnect(FSocket);

  If FSocketControl<>Nil Then
  Begin
       TSocketNotifyControl(FSocketControl).FSocket:=Nil;
       FSocketControl.Destroy;
       FHandle:=0;
  End;
  FSocketControl:=Nil;
  If CallCount>0 Then dec(CallCount);

  If CallCount=0 Then
  Begin
     If WinSockHandle<>0 Then
     Begin
         Asm
            MOV AL,Classes.InsideDesigner
            MOV InsideDesigner,AL
         End;
         If not InsideDesigner Then
         Begin
             ErrorCode := WinSockProcs.WSACleanup;
             If ErrorCode <> 0 Then
               raise ESocketError.Create('Windows socket error #'+tostr(ErrorCode)+
                                         SocketErrorMsg(ErrorCode));
         End;
         {$IFDEF OS2}
         DosFreeModule(WinSockHandle);
         {$ENDIF}
         {$IFDEF WIN32}
         FreeLibrary(WinSockHandle);
         {$ENDIF}
         WinSockHandle:=0;
     End;
  End;

  Inherited Destroy;
End;


Procedure TCustomWinSocket.Accept(Socket: TSocket);
Begin
End;

Procedure TCustomWinSocket.Close;
Begin
     Disconnect(FSocket);
End;

Procedure TCustomWinSocket.Connect(Socket: TSocket);
Begin
End;

Function TCustomWinSocket.GetHandle:LongWord;
Begin
    If FHandle = 0 Then
    Begin
         FSocketControl:=TSocketNotifyControl.Create(Nil);
         TSocketNotifyControl(FSocketControl).FSocket:=Self;
         TSocketNotifyControl(FSocketControl).CreateWnd;
         FHandle:=FSocketControl.Handle;
    End;
    Result := FHandle;
End;

Function TCustomWinSocket.GetRemoteAddr: TSockAddrIn;
Var
   Size:LongInt;
Begin
     FillChar(Result, SizeOf(TSockAddrIn), 0);
     If not FConnected Then Exit;

     Size:=SizeOf(TSockAddrIn);
     If WinSockHandle<>0 Then
      If WinSockProcs.getpeername(FSocket,Result,Size)<>0 Then FillChar(Result,SizeOf(TSockAddrIn),0);
End;

Function TCustomWinSocket.GetLocalAddress: String;
Var
  Size:LongInt;
  SoIn:TSockAddrIn;
Begin
     Result:='';
     If FSocket<=0 Then Exit; //invalid socket

     Size:=SizeOf(SoIn);
     FillChar(SoIn,SizeOf(TSockAddrIn),0);
     If WinSockHandle<>0 Then
       If WinSockProcs.getsockname(FSocket,SoIn,Size)=0 Then
         With SoIn.sin_Addr.S_un_b Do
            Result:=tostr(s_b1)+'.'+tostr(s_b2)+'.'+tostr(s_b3)+'.'+tostr(s_b4);
End;

Function TCustomWinSocket.GetRemoteAddress:String;
Var
   Size:LongInt;
   SoIn:TSockAddrIn;
Begin
     Result := '';
     If not FConnected Then Exit;

     If WinSockHandle<>0 Then
     Begin
         Size:=SizeOf(SoIn);
         CheckSockResult(WinSockProcs.getpeername(FSocket,SoIn,Size),'getpeername');
         With SoIn.sin_Addr.S_un_b Do
           Result:=tostr(s_b1)+'.'+tostr(s_b2)+'.'+tostr(s_b3)+'.'+tostr(s_b4);
     End;
End;

Function TCustomWinSocket.GetLocalHost:String;
Var
   LocName:CString;
Begin
    Result:='';
    If FSocket<=0 Then Exit; //invalid socket

    If WinSockHandle<>0 Then
      If WinSockProcs.gethostname(LocName,255)=0 Then Result:=LocName;
End;

Type
    hostent=Record
       h_name:PChar;             /* official name of host */
       h_aliases:PpCharArray;     /* alias list */
       h_addrtype:LongInt;       /* host address type */
       h_length:LongInt;         /* length of address */
       h_addr_list:^PChar        /* PCharArray; list of addresses from name server */
       //h_addr  h_addr_list[0]  /* address, for backward compatiblity */
    End;
    phostent=^hostent;

Function TCustomWinSocket.GetRemoteHost:String;
Var
  Size:LongInt;
  aHostEnt:PHostEnt;
  SoIn:TSockAddrIn;
Begin
     Result:='';
     If not FConnected Then Exit;

     If WinSockHandle<>0 Then
     Begin
         Size:=SizeOf(SoIn);
         CheckSockResult(WinSockProcs.getpeername(FSocket,SoIn,Size),'getpeername');
         aHostEnt:=WinSockProcs.gethostbyaddr(SoIn.sin_addr.s_addr,4,PF_INET);
         If aHostEnt<>Nil Then Result:=aHostEnt^.h_name^;
     End;
End;

Function TCustomWinSocket.GetLocalPort:LongInt;
Var
  Size:LongInt;
  SoIn:TSockAddrIn;
Begin
     Result:=-1;
     If FSocket<=0 Then Exit; //invalid socket

     If WinSockHandle<>0 Then
     Begin
        Size := SizeOf(SoIn);
        If WinSockProcs.getsockname(FSocket,SoIn,Size)=0 Then
          Result:=WinSockProcs.ntohs(SoIn.sin_port);
     End;
End;

Function TCustomWinSocket.GetRemotePort: LongInt;
Var
   Size:LongInt;
   SoIn:TSockAddrIn;
Begin
     Result := 0;
     If not FConnected Then Exit;

     If WinSockHandle<>0 Then
     Begin
         Size:=SizeOf(SoIn);
         CheckSockResult(WinSockProcs.getpeername(FSocket,SoIn,Size),'getpeername');
         Result:=WinSockProcs.ntohs(SoIn.sin_port);
     End;
End;

Function TCustomWinSocket.LookupName(Const Name: String): TInAddr;

Var HostEnt : phostent;
{$IFDEF OS2}
    Addr    : pChar;
{$ENDIF}

Begin
     FillChar(Result, SizeOf(TInAddr),0);
     If WinSockHandle<>0
       then HostEnt:=WinSockProcs.gethostbyname(Name)
       else exit;
     If HostEnt=Nil Then exit;

{$IFDEF OS2}
     Addr:=HostEnt^.h_addr_list^;
     Result.s_addr:=longWord(Addr^);
{$ENDIF}
{$IFDEF Win32}
     Result.s_addr:=longWord(HostEnt^.h_addr_list^);
{$ENDIF}
End;

Type
   servent=Record
       s_name:PChar;
       s_aliases:PpCharArray;
       s_port:LongInt;
       s_proto:PChar;
   End;
   pservent=^servent;

Function TCustomWinSocket.LookupService(Const Service: String): LongInt;
Var
   aServEnt: PServEnt;
Begin
    Result:=0;
    If WinSockHandle<>0 Then aServEnt:=WinSockProcs.getservbyname(Service, 'tcp')
    Else exit;
    If aServEnt=Nil Then exit;
    Result:=WinSockProcs.ntohs(aServEnt^.s_port)
End;

Function TCustomWinSocket.InitSocket(Var Name,Address,Service:String;Port:Word;
                                     Client:Boolean):TSockAddrIn;
Begin
     FillChar(Result,sizeof(Result),0);
     Result.sin_family := PF_INET;
     If Name<>''
       Then Result.sin_addr:=LookupName(name)
       Else If Address<>''
         Then
           Begin
             If WinSockHandle<>0
               Then Result.sin_addr.s_addr:=WinSockProcs.inet_addr(Address)
               Else Raise ESocketError.Create('Sockets not available');
           End
         Else If not Client
           Then Result.sin_addr.s_addr:=INADDR_ANY
           Else Raise ESocketError.Create('No socket address');
     If Service<>''
       Then
         Begin
           If WinSockHandle<>0
             Then Result.sin_port:=WinSockProcs.htons(LookupService(Service))
             Else Raise ESocketError.Create('Sockets not available');
         End
       Else
         Begin
           If WinSockHandle<>0
             Then Result.sin_port:=WinSockProcs.htons(Port)
             Else Raise ESocketError.Create('Sockets not available');
         End;
End;

Procedure TCustomWinSocket.Listen(Var Name,Address,Service:String;Port:Word;QueueSize:LongInt);
Var
   SoIn: TSockAddrIn;
   Blocking:LongWord;
Begin
     If FConnected Then Raise ESocketError.Create('Socket cannot listen on open');
     If FSocket>0 Then
     Begin
          If WinSockHandle<>0 Then CheckSockResult(WinSockProcs.closesocket(FSocket), 'closesocket');
     End;
     If WinSockHandle<>0 Then FSocket:=WinSockProcs.socket(PF_INET, SOCK_STREAM, IPPROTO_IP)
     Else FSocket:=INVALID_SOCKET;
     If FSocket<=0 Then Raise ESocketError.Create('Cannot create socket');

     Try
        SoIn:=InitSocket(Name,Address,Service,Port,False);
        CheckSockResult(WinSockProcs.bind(FSocket, SoIn, SizeOf(TSockAddrIn)),'bind');
        If FAsyncStyles<>[] Then WinSockProcs.WSAAsyncSelect(FSocket,Handle,CM_SOCKETMESSAGE,Longint(FAsyncStyles))
        Else
        Begin
             WinSockProcs.WSAAsyncSelect(FSocket,0,WM_NULL,0);
             Blocking := 0;
             WinSockProcs.ioctlsocket(FSocket,FIONBIO,Blocking);
        End;

        Event(Self,seListen);
        If QueueSize>SOMAXCONN Then QueueSize:=SOMAXCONN;
        CheckSockResult(WinSockProcs.listen(FSocket, QueueSize), 'listen');
        FConnected := True;
     Except
        Disconnect(FSocket);
        Raise;
     End;
End;

Procedure TCustomWinSocket.Open(Var Name,Address,Service:String;Port:Word);
Var
   SoIn:TSockAddrIn;
   Blocking:LongWord;
Begin
     If FConnected Then raise ESocketError.Create('Socket already open');
     If WinSockHandle<>0
       Then FSocket:=WinSockProcs.socket(PF_INET, SOCK_STREAM, IPPROTO_IP)
       Else FSocket:=INVALID_SOCKET;
     If FSocket<=0 Then Raise ESocketError.Create('Cannot create socket');
     Try
        Event(Self, seLookUp);
        SoIn := InitSocket(Name, Address, Service, Port, True);
        If FAsyncStyles=[]
          Then
            Begin
              WinSockProcs.WSAAsyncSelect(FSocket,0,WM_NULL,0);
              Blocking := 0;
              WinSockProcs.ioctlsocket(FSocket,FIONBIO,Blocking);
            End
          Else WinSockProcs.WSAAsyncSelect(FSocket,Handle,CM_SOCKETMESSAGE,Longint(FAsyncStyles));
        Event(Self,seConnecting);
        CheckSockResult(WinSockProcs.connect(FSocket,SoIn, SizeOf(TSockAddrIn)),'connect');
        If not (asConnect In FAsyncStyles) Then
          Begin
            FConnected:=FSocket>0;
            Event(Self,seConnect);
          End;
     Except
        Disconnect(FSocket);
        Raise;
     End;
End;

Procedure TCustomWinSocket.Read(Socket: TSocket);
Begin
     If ((FSocket<=0)Or(Socket<>FSocket)) Then Exit;
     Event(Self, seRead);
End;

Procedure TCustomWinSocket.Write(Socket: TSocket);
Var Stream:TStream;
Begin
     If ((FSocket<=0)Or(Socket<>FSocket)) Then Exit;
     Stream:=FSendStream;
     FSendStream:=Nil;
     If not SendStream(Stream) Then Event(Self, seWrite);
End;


Procedure TCustomWinSocket.Disconnect(Socket: TSocket);
Begin
     If not FConnected Then exit;

     If ((Socket<=0)Or(Socket<>FSocket)) Then exit;

     Event(Self, seDisconnect);
     If WinSockHandle<>0 Then
     Begin
          WinSockProcs.WSAAsyncSelect(FSocket,0,WM_NULL,0);

          IF FSocket<0 Then
          Begin
              FSocket:=INVALID_SOCKET;
              FConnected:=False;
              exit;
          End;
          CheckSockResult(WinSockProcs.closesocket(FSocket), 'closesocket');
     End;
     FSocket:=INVALID_SOCKET;
     FConnected:=False;
     If FSendStream<>Nil Then
     Begin
         FSendStream.Destroy;
         FSendStream := nil;
     End;

     Event(Self, seDisconnected);
End;

Procedure TCustomWinSocket.Event(Socket:TCustomWinSocket;SocketEvent:TSocketEvent);
Begin
     If FOnSocketEvent<>Nil Then FOnSocketEvent(Self,Socket,SocketEvent);
End;

Procedure TCustomWinSocket.Error(Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
                                 Var ErrorCode:Word);
Begin
     If FOnErrorEvent<>Nil Then FOnErrorEvent(Self,Socket,ErrorEvent,ErrorCode);
End;

Procedure TCustomWinSocket.SendText(Const s: String);
Begin
     SendBuf(S[1], Length(S));
End;

Function TCustomWinSocket.SendStream(AStream: TStream): Boolean;
Var
   BufferBytesLeft:LongInt;
   BufferBytesSent:LongInt;
   ErrorCode:Word;
   Buf:Array[0..4095] of Byte;
   StartPos:LongInt;
Label ex;
Begin
     Result := False;
     If WinSockHandle=0 Then exit;

     If FSendStream = nil Then
     Begin
         FSendStream := AStream;

         If FSendStream=Nil Then exit;
         If ((FSocket<=0)Or(not FConnected)) Then exit;

         Repeat
             StartPos:=FSendStream.Position;
             BufferBytesLeft:=FSendStream.Read(Buf,SizeOf(Buf));

             If BufferBytesLeft>0 Then
             Begin
                  BufferBytesSent:=WinSockProcs.send(FSocket,Buf,BufferBytesLeft,0);
                  If BufferBytesSent=SOCKET_ERROR Then
                  Begin
                      ErrorCode := WinSockProcs.WSAGetLastError;
                      If ErrorCode <> WSAEWOULDBLOCK Then
                      Begin
                           Error(Self,eeSend, ErrorCode);
                           Disconnect(FSocket);
                           goto ex;
                      End
                      Else
                      Begin
                           FSendStream.Position:=StartPos;
                           Result:=True;
                           exit;
                      End;
                  End
                  Else If BufferBytesLeft>BufferBytesSent Then FSendStream.Position:=StartPos+(BufferBytesLeft-BufferBytesSent)
                  Else If FSendStream.Position=FSendStream.Size Then goto ex;
             End
             Else
             Begin
ex:
                 If FDropAfterSend Then Disconnect(FSocket);
                 FDropAfterSend := False;
                 FSendStream.Destroy;
                 FSendStream := nil;
                 Result:=True;
                 exit;
             End;
         Until False;
     End;
End;

Function TCustomWinSocket.SendStreamThenDrop(AStream: TStream): Boolean;
Begin
     FDropAfterSend := True;
     Result := SendStream(AStream);
     If not Result Then FDropAfterSend:=False;
End;

Function TCustomWinSocket.SendBuf(Var Buf;Count:LongInt):LongInt;
Begin
    Result := 0;
    If not FConnected Then Exit;
    If WinSockHandle=0 Then exit;

    Result:=WinSockProcs.send(FSocket, Buf, Count, 0);
    If Result=SOCKET_ERROR Then CheckSockError(Self,'send');
End;

Procedure TCustomWinSocket.SetAsyncStyles(Value: TASyncStyles);
Var Blocking:LongWord;
Begin
     If Value <> FASyncStyles Then
     Begin
          FASyncStyles := Value;
          If WinSockHandle=0 Then exit;
          If FSocket>0 Then
          Begin
            If FAsyncStyles<>[] Then WinSockProcs.WSAAsyncSelect(FSocket,Handle,CM_SOCKETMESSAGE,Longint(FAsyncStyles))
            Else
            Begin
                WinSockProcs.WSAAsyncSelect(FSocket,0,WM_NULL,0);
                Blocking := 0;
                WinSockProcs.ioctlsocket(FSocket,FIONBIO,Blocking);
            End;
          End;
     End;
End;

Function TCustomWinSocket.ReceiveBuf(Var Buf; Count: LongInt): LongInt;
Begin
    Result := 0;
    If not FConnected Then Exit;
    If WinSockHandle=0 Then exit;

    If ((Count=-1)And(FConnected)) Then WinSockProcs.ioctlsocket(FSocket,FIONREAD,LongWord(Result))
    Else
    Begin
         Result:=WinSockProcs.recv(FSocket, Buf, Count, 0);
         If Result = SOCKET_ERROR Then CheckSockError(Self,'recv');
    End;
End;

Function TCustomWinSocket.ReceiveLength: LongInt;
Var p:Pointer;
Begin
     p:=Nil;
     Result := ReceiveBuf(p^, -1);
End;

Function TCustomWinSocket.ReceiveText: String;
Var p:Pointer;
Begin
     p:=Nil;
     SetLength(Result, ReceiveBuf(p^, -1));
     ReceiveBuf(Result[1], Length(Result));
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TClientWinSocket Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TClientWinSocket.Connect(Socket: TSocket);
Begin
     FConnected:=True;
     Event(Self, seConnect);
End;

Procedure TClientWinSocket.SetClientType(Value: TClientType);
Begin
     If Value=FClientType Then exit;

     If FConnected Then Raise ESocketError.Create('Cannot change socket while active');

     FClientType := Value;
     If FClientType=ctBlocking Then ASyncStyles:=[]
     Else ASyncStyles:=[asRead,asWrite,asConnect,asClose];
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TServerClientWinSocket Class Implementation                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TServerClientWinSocket.Create(Socket: TSocket;ServerWinSocket:TServerWinSocket);
Var Blocking:LongWord;
Begin
     FServerWinSocket := ServerWinSocket;
     If FServerWinSocket<>Nil Then
     Begin
         If FServerWinSocket.FConnections.IndexOf(Self)<0 Then
           FServerWinSocket.FConnections.Add(Self);
         If FServerWinSocket.AsyncStyles <> [] Then
           OnSocketEvent := FServerWinSocket.ClientEvent;
     End;

     Inherited Create(Socket);

     If FServerWinSocket.ASyncStyles <> [] Then
      If WinSockHandle<>0 Then
     Begin
          If FAsyncStyles<>[] Then WinSockProcs.WSAAsyncSelect(FSocket,Handle,CM_SOCKETMESSAGE,Longint(FAsyncStyles))
          Else
          Begin
              WinSockProcs.WSAAsyncSelect(FSocket,0,WM_NULL,0);
              Blocking := 0;
              WinSockProcs.ioctlsocket(FSocket,FIONBIO,Blocking);
          End;
     End;
     If FConnected Then Event(Self, seConnect);
End;

Destructor TServerClientWinSocket.Destroy;
Begin
     If FServerWinSocket<>Nil Then
     Begin
          If FServerWinSocket.FConnections.IndexOf(Self)>=0 Then
            FServerWinSocket.FConnections.Remove(Self);
     End;
     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TServerWinSocket Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TServerWinSocket.Create(ASocket: TSocket);
Begin
     FConnections.Create;
     FActiveThreads.Create;
     Inherited Create(ASocket);
     FAsyncStyles:=[asAccept];
End;

Destructor TServerWinSocket.Destroy;
Begin
     Inherited Destroy;
     FConnections.Destroy;
     FActiveThreads.Destroy;
End;

Procedure TServerWinSocket.ClientEvent(Sender:TObject;Socket:TCustomWinSocket;
                                       SocketEvent:TSocketEvent);
Begin
    Case SocketEvent of
      seConnect:ClientConnect(Socket);
      seDisconnect:ClientDisconnect(Socket);
      seDisconnected:ClientDisconnected(Socket);
      seRead:ClientRead(Socket);
      seWrite:ClientWrite(Socket);
    End;
End;

Procedure TServerWinSocket.ClientError(Sender: TObject; Socket: TCustomWinSocket;
                                       ErrorEvent: TErrorEvent;Var ErrorCode:Word);
Begin
     ClientErrorEvent(Socket, ErrorEvent, ErrorCode);
End;

Function TServerWinSocket.GetConnections(Index:LongInt):TCustomWinSocket;
Begin
    Result:=FConnections[Index];
End;

Function TServerWinSocket.GetActiveConnections:LongInt;
Begin
    Result:=FConnections.Count;
End;

Function TServerWinSocket.GetActiveThreads: LongInt;
Var
   t:LongInt;
Begin
    Result := 0;
    For t:=0 To FActiveThreads.Count-1 Do
      If TServerClientThread(FActiveThreads[t]).ClientSocket<>Nil Then
        Inc(Result);
End;

Function TServerWinSocket.GetIdleThreads: LongInt;
Var
   t:LongInt;
Begin
    Result := 0;
    For t:=0 To FActiveThreads.Count-1 Do
      If TServerClientThread(FActiveThreads[t]).ClientSocket=Nil Then
        Inc(Result);
End;

Procedure TServerWinSocket.Accept(Socket: TSocket);
Var
   ClientSocket: TServerClientWinSocket;
   ClientWinSocket: TSocket;
   Addr: TSockAddrIn;
   Len: LongInt;
Begin
    If WinSockHandle=0 Then exit;
    Len := SizeOf(TSockAddrIn);
    ClientWinSocket := WinSockProcs.accept(Socket, Addr, Len);
    If ClientWinSocket>0 Then
    Begin
         ClientSocket:=GetClientSocket(ClientWinSocket);
         If FOnSocketEvent<>Nil Then FOnSocketEvent(Self,ClientSocket,seAccept);
         If FServerType=stThreadBlocking Then
         Begin
             ClientSocket.ASyncStyles := [];
             GetServerThread(ClientSocket);
         End;
    End;
End;

Procedure TServerWinSocket.Listen(Var Name, Address, Service: String; Port: Word;
  QueueSize: LongInt);
Begin
  Inherited Listen(Name, Address, Service, Port, QueueSize);
  If FConnected Then If ServerType = stThreadBlocking Then
    FServerAcceptThread := TServerAcceptThread.Create(False, Self);
End;

Procedure TServerWinSocket.Disconnect(Socket: TSocket);
Var
  SaveCacheSize: LongInt;
  sc:TServerClientThread;
  cw:TCustomWinSocket;
Begin
    If not FConnected Then exit;

    SaveCacheSize := ThreadCacheSize;

    Try
        ThreadCacheSize := 0;

        While FActiveThreads.Count>0 Do
        Begin
             sc:=TServerClientThread(FActiveThreads.Last);
             sc.FreeOnTerminate := False;
             sc.Terminate;
             sc.FEvent.SetEvent;
             If sc.ClientSocket<>Nil Then If sc.ClientSocket.Connected Then sc.ClientSocket.Close;
             sc.WaitFor;
             sc.Destroy;
        End;

        While FConnections.Count>0 Do
        Begin
             cw:=TCustomWinSocket(FConnections.Last);
             cw.Destroy;
        End;

        If FServerAcceptThread <> nil Then FServerAcceptThread.Terminate;
        Inherited Disconnect(Socket);
        If FServerAcceptThread<>Nil Then
        Begin
            FServerAcceptThread.Destroy;
            FServerAcceptThread:=Nil;
        End;
    Finally
        ThreadCacheSize := SaveCacheSize;
    End;
End;

Function TServerWinSocket.DoCreateThread(ClientSocket: TServerClientWinSocket): TServerClientThread;
Begin
     Result := TServerClientThread.Create(False, ClientSocket);
End;

Procedure TServerWinSocket.ThreadStart(AThread: TServerClientThread);
Begin
     If FOnThreadStart<>Nil Then FOnThreadStart(Self,AThread);
End;

Procedure TServerWinSocket.ThreadEnd(AThread: TServerClientThread);
Begin
     If FOnThreadEnd<>Nil Then FOnThreadEnd(Self,AThread);
End;

Procedure TServerWinSocket.SetServerType(Value: TServerType);
Begin
     If Value=FServerType Then exit;
     If FConnected Then Raise ESocketError.Create('Cannot change socket while active');

     FServerType := Value;
     If FServerType=stThreadBlocking Then ASyncStyles := []
     Else ASyncStyles := [asAccept];
End;

Procedure TServerWinSocket.SetThreadCacheSize(Value: LongInt);
Var
   Start,t:LongInt;
   sc:TServerClientThread;
Begin
    If Value=FThreadCacheSize Then exit;

    If Value<FThreadCacheSize Then Start:=Value
    Else Start := FThreadCacheSize;

    FThreadCacheSize := Value;

    For t:=0 To FActiveThreads.Count-1 Do
    Begin
        sc:=TServerClientThread(FActiveThreads[t]);
        sc.KeepInCache:=t<Start;
    End;
End;

Function TServerWinSocket.GetClientSocket(Socket: TSocket): TServerClientWinSocket;
Begin
     Result:=Nil;
     If FOnGetSocket<>Nil Then FOnGetSocket(Self,Socket,Result);
     If Result=nil Then Result := TServerClientWinSocket.Create(Socket,Self);
End;

Function TServerWinSocket.GetServerThread(ClientSocket: TServerClientWinSocket): TServerClientThread;
Var
   t:LongInt;
Begin
     Result := Nil;

     For t:=0 To FActiveThreads.Count-1 Do
     Begin
          Result:=TServerClientThread(FActiveThreads[t]);
          If Result.ClientSocket=Nil Then
          Begin
              Result.ReActivate(ClientSocket);
              break;
          End;
     End;

     If FOnGetThread<>Nil Then FOnGetThread(Self,ClientSocket,Result);
     If Result=Nil Then Result:=DoCreateThread(ClientSocket);
End;

Function TServerWinSocket.GetClientThread(ClientSocket: TServerClientWinSocket): TServerClientThread;
Var
   t:LongInt;
Begin
     For t:=0 To FActiveThreads.Count-1 Do
     Begin
          Result:=TServerClientThread(FActiveThreads[t]);
          If Result.ClientSocket=ClientSocket Then exit;
     End;
     Result:=Nil;
End;

Procedure TServerWinSocket.ClientRead(Socket: TCustomWinSocket);
Begin
     If FOnClientRead<>Nil Then FOnClientRead(Self,Socket);
End;

Procedure TServerWinSocket.ClientWrite(Socket: TCustomWinSocket);
Begin
     If FOnClientWrite<>Nil Then FOnClientWrite(Self,Socket);
End;

Procedure TServerWinSocket.ClientConnect(Socket: TCustomWinSocket);
Begin
     If FOnClientConnect<>Nil Then FOnClientConnect(Self,Socket);
End;

Procedure TServerWinSocket.ClientDisconnect(Socket: TCustomWinSocket);
Begin
     If FOnClientDisconnect<>Nil Then FOnClientDisconnect(Self,Socket);
End;

Procedure TServerWinSocket.ClientDisconnected(Socket: TCustomWinSocket);
Begin
     If FOnClientDisconnected<>Nil Then FOnClientDisconnected(Self,Socket);
     If ServerType=stNonBlocking Then
      If Socket.FHandle<>0 Then PostMsg(Socket.FHandle,CM_DEFERFREE,0,0);
End;


Procedure TServerWinSocket.ClientErrorEvent(Socket: TCustomWinSocket;
                       ErrorEvent: TErrorEvent; Var ErrorCode:Word);
Begin
     If FOnClientError<>Nil Then FOnClientError(Self,Socket,ErrorEvent,ErrorCode);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TServerAcceptThread Class Implementation                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Constructor TServerAcceptThread.Create(CreateSuspended: Boolean;ASocket: TServerWinSocket);
Begin
     FServerSocket := ASocket;
     Inherited Create(CreateSuspended);
End;

Procedure TServerAcceptThread.Execute;
Begin
     While Not Terminated Do FServerSocket.Accept(FServerSocket.SocketHandle);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TServerClientThread Class Implementation                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Constructor TServerClientThread.Create(CreateSuspended:Boolean;
                                       ASocket:TServerClientWinSocket);
Begin
     FreeOnTerminate := True;
     FEvent:=TSimpleEvent.Create;
     Inherited Create(True);
     Priority:=tpHigher;
     ReActivate(ASocket);
     If not CreateSuspended Then Resume;
End;

Destructor TServerClientThread.Destroy;
Begin
     FClientSocket.Destroy;
     FEvent.Destroy;
     Inherited Destroy;
End;

Procedure TServerClientThread.Execute;
Begin
     FServerSocket.ThreadStart(Self);
     Try
        Try
           While True Do
           Begin
               If StartConnect Then ClientExecute;
               If EndConnect Then Break;
           End;
        Except
           On e:Exception Do
           Begin
                HandleException(e);
                KeepInCache := False;
           End;
        End;
     Finally
        FServerSocket.ThreadEnd(Self);
     End;
End;

Function TServerClientThread.StartConnect:Boolean;
Begin
     If FEvent.WaitFor(INFINITE) = wrSignaled Then FEvent.ResetEvent;
     Result := not Terminated;
End;

Function TServerClientThread.EndConnect: Boolean;
Begin
     FClientSocket.Destroy;
     FClientSocket := nil;
     Result:=Terminated or Not KeepInCache;
End;

Procedure TServerClientThread.ReActivate(ASocket: TServerClientWinSocket);
Begin
     FClientSocket := ASocket;
     If FClientSocket<>Nil Then
     Begin
         FServerSocket := FClientSocket.ServerWinSocket;
         If FServerSocket.FActiveThreads.IndexOf(Self)<0 Then
         Begin
              FServerSocket.FActiveThreads.Add(Self);
              If FServerSocket.FActiveThreads.Count<=FServerSocket.FThreadCacheSize Then
                KeepInCache:=True;
         End;
         FClientSocket.OnErrorEvent:=HandleError;
         FClientSocket.OnSocketEvent:=HandleEvent;
         FEvent.SetEvent;
     End;
End;

Procedure TServerClientThread.DoHandleException;
Begin
     {$IFDEF OS2}
     WinSetCapture(HWND_DESKTOP,0);
     {$ENDIF}
     If FException Is Exception Then Application.ShowException(FException)
     Else Raise FException;
End;

Procedure TServerClientThread.HandleException(e:Exception);
Begin
     FException := e;
     Try
        Synchronize(DoHandleException);
     Finally
        FException := nil;
     End;
End;


Procedure TServerClientThread.DoRead;
Begin
     ClientSocket.ServerWinSocket.Event(ClientSocket,seRead);
End;

Procedure TServerClientThread.DoWrite;
Begin
     FServerSocket.Event(ClientSocket, seWrite);
End;

Procedure TServerClientThread.DoTerminate;
Begin
     If FServerSocket<>Nil Then
     Begin
          If FServerSocket.FActiveThreads.IndexOf(Self)>=0 Then
            FServerSocket.FActiveThreads.Remove(Self);
     End;
End;

Procedure TServerClientThread.HandleEvent(Sender:TObject;Socket:TCustomWinSocket;
                                          SocketEvent:TSocketEvent);
Begin
     Event(SocketEvent);
End;

Procedure TServerClientThread.Event(SocketEvent: TSocketEvent);
Begin
     FServerSocket.ClientEvent(Self,ClientSocket,SocketEvent);
End;

Procedure TServerClientThread.HandleError(Sender:TObject;Socket:TCustomWinSocket;
                                          ErrorEvent:TErrorEvent;Var ErrorCode:Word);
Begin
     Error(ErrorEvent, ErrorCode);
End;


Procedure TServerClientThread.Error(ErrorEvent:TErrorEvent;Var ErrorCode:Word);
Begin
     FServerSocket.ClientError(Self, ClientSocket, ErrorEvent, ErrorCode);
End;

Const FD_SETSIZE      = 64;

Type TFDSET=Record
                fd_count:Word;
                fd_array:Array[0..FD_SETSIZE-1] Of TSOCKET;
     End;

     timeval=Record
                tv_sec:LongInt;
                tv_usec:LongInt;
     End;

Procedure FD_ZERO(Var aset:TFDSET);
Begin
    aset.fd_count:=0;
End;

Procedure FD_SET(Socket:TSocket;Var FDSet:TFDSet);
Begin
  If FDSet.fd_count < FD_SETSIZE Then
  Begin
    FDSet.fd_array[FDSet.fd_count]:=Socket;
    Inc(FDSet.fd_count);
  End;
End;

Procedure TServerClientThread.ClientExecute;
Var
   FDSet: TFDSet;
   aTimeVal: TimeVal;
Begin
     If WinSockHandle=0 Then exit;
     While not Terminated And ClientSocket.Connected Do
     Begin
          FD_ZERO(FDSet);
          FD_SET(ClientSocket.SocketHandle, FDSet);
          aTimeVal.tv_sec := 0;
          aTimeVal.tv_usec := 500;
          If (WinSockProcs.select(0, FDSet, nil, nil, aTimeVal) > 0) and not Terminated Then
            If ClientSocket.ReceiveBuf(FDSet, -1) = 0 Then Break
          Else Synchronize(DoRead);
          If WinSockProcs.select(0, nil, FDSet, nil, aTimeVal) > 0 Then
            If not Terminated Then Synchronize(DoWrite);
     End; //While
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TCustomSocket Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCustomSocket.Open;
Begin
     Active := True;
End;

Procedure TCustomSocket.Close;
Begin
     Active := False;
End;

Procedure TCustomSocket.SetActive(Value: Boolean);
Var InsideDesigner:Boolean;
Begin
  If Value<>FActive Then
  Begin
      FActive := Value;
      Asm
         MOV AL,Classes.InsideDesigner
         MOV InsideDesigner,AL
      End;
      If ((not (csLoading In ComponentState)) And (not InsideDesigner)) Then
        Begin
         DoActivate(Value);
       End;
  End;
End;

Procedure TCustomSocket.DoEvent(Sender:TObject;Socket:TCustomWinSocket;
                                SocketEvent:TSocketEvent);
Begin
     Event(Socket,SocketEvent);
End;

Procedure TCustomSocket.DoError(Sender:TObject;Socket:TCustomWinSocket;
                                ErrorEvent:TErrorEvent;Var ErrorCode:Word);
Begin
     Error(Socket,ErrorEvent,ErrorCode);
End;

Procedure TCustomSocket.Event(Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
Begin
     Case SocketEvent Of
         seRead:If FOnRead<>Nil Then FOnRead(Self, Socket);
         seWrite:If FOnWrite<>Nil Then FOnWrite(Self, Socket);
         seLookup: If Assigned(FOnLookup) Then FOnLookup(Self, Socket);
         seAccept:If FOnAccept<>Nil Then FOnAccept(Self,Socket);
         seConnecting:If FOnConnecting<>Nil Then FOnConnecting(Self,Socket);
         seConnect:
         Begin
              FActive := True;
              If FOnConnect<>Nil Then FOnConnect(Self,Socket);
         End;
         seDisconnect:
         Begin
              FActive := False;
              If FOnDisconnect<>Nil Then FOnDisconnect(Self,Socket);
         End;
         seListen:
         Begin
              FActive := True;
              If FOnListen<>Nil Then FOnListen(Self,Socket);
         End;
     End; //case
End;

Procedure TCustomSocket.Error(Socket:TCustomWinSocket;ErrorEvent:TErrorEvent;
                              Var ErrorCode:Word);
Begin
     If FOnError<>Nil Then FOnError(Self,Socket,ErrorEvent,ErrorCode);
End;

Procedure TCustomSocket.Loaded;
Var InsideDesigner:Boolean;
Begin
    Inherited Loaded;
    Asm
       MOV AL,Classes.InsideDesigner
       MOV InsideDesigner,AL
    End;
    If not InsideDesigner Then DoActivate(FActive);
End;

Procedure TCustomSocket.SetService(Value: String);
Begin
    If CompareText(Value,FService)=0 Then exit;

    If not (csLoading in ComponentState) and FActive Then
      raise ESocketError.Create('Cannot change socket while active');
    FService := Value;
End;

Procedure TCustomSocket.SetHost(Value: String);
Begin
    If CompareText(Value,FHost)=0 Then exit;

    If not (csLoading in ComponentState) and FActive Then
      raise ESocketError.Create('Cannot change socket while active');
    FHost := Value;
End;

Procedure TCustomSocket.SetAddress(Value: String);
Begin
    If CompareText(Value,FAddress)=0 Then exit;

    If not (csLoading in ComponentState) and FActive Then
      Raise ESocketError.Create('Cannot change socket while active');
    FAddress := Value;
End;

Procedure TCustomSocket.SetPort(Value: LongInt);
Begin
    If FPort=Value Then exit;

    If not (csLoading in ComponentState) and FActive Then
      raise ESocketError.Create('Cannot change socket while active');
    FPort := Value;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TWinSocketStream Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Constructor TWinSocketStream.Create(ASocket: TCustomWinSocket; TimeOut: Longint);
Begin
     If ASocket.ASyncStyles <> [] Then Raise ESocketError.Create('Socket must be blocking');
     FSocket := ASocket;
     FTimeOut := TimeOut;
     FEvent.Create;
     Inherited Create;
End;

Destructor TWinSocketStream.Destroy;
Begin
    FEvent.Destroy;
    Inherited Destroy;
End;

Function TWinSocketStream.Read(Var Buffer;Count:Longint): Longint;
Begin
    Result:=0;
    If WinSockHandle=0 Then exit;
    result:=WinSockProcs.recv(FSocket.SocketHandle,Buffer,Count,0);
    If FEvent.WaitFor(FTimeOut)<>wrSignaled Then Result:=0
    Else FEvent.ResetEvent;
End;

Function TWinSocketStream.Write(Const Buffer; Count: Longint): Longint;
Begin
    Result:=0;
    If WinSockHandle=0 Then exit;
    result:=WinSockProcs.send(FSocket.SocketHandle,Buffer,Count,0);
    If FEvent.WaitFor(FTimeOut)<>wrSignaled Then Result:=0
    Else FEvent.ResetEvent;
End;

Function TWinSocketStream.WaitForData(Timeout: Longint): Boolean;
Var
  FDSet: TFDSet;
  aTimeVal: TimeVal;
Begin
    Result:=False;
    If WinSockHandle=0 Then exit;
    aTimeVal.tv_sec:=Timeout Div 1000;
    aTimeVal.tv_usec:=(Timeout Mod 1000)*1000;
    FD_ZERO(FDSet);
    FD_SET(FSocket.SocketHandle, FDSet);
    Result:=WinSockProcs.select(0,FDSet,Nil,Nil,aTimeVal)>0;
End;

Function TWinSocketStream.Seek(Offset: Longint; Origin: Word): Longint;
Begin
     Result := 0;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TClientSocket Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Constructor TClientSocket.Create(AOwner:TComponent);
Begin
     Inherited Create(AOwner);
     FClientSocket.Create(INVALID_SOCKET);
     FClientSocket.OnSocketEvent:=DoEvent;
     FClientSocket.OnErrorEvent:=DoError;
End;

Destructor TClientSocket.Destroy;
Begin
     FClientSocket.Destroy;
     Inherited Destroy;
End;

Procedure TClientSocket.DoActivate(Value: Boolean);
Begin
    If FClientSocket.Connected=Value Then exit;
    If csDesigning In ComponentState Then exit;
    If ((Value=False) And (FClientSocket.Connected))
      Then FClientSocket.Disconnect(FClientSocket.FSocket)
      Else If Value
        Then FClientSocket.Open(FHost,FAddress,FService,FPort);
End;

Function TClientSocket.GetClientType: TClientType;
Begin
    Result := FClientSocket.ClientType;
End;

Procedure TClientSocket.SetClientType(Value: TClientType);
Begin
    FClientSocket.ClientType := Value;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TServerSocket Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TServerSocket.Create(AOwner: TComponent);
Begin
    Inherited Create(AOwner);
    FServerSocket.Create(INVALID_SOCKET);
    FServerSocket.OnSocketEvent:=DoEvent;
    FServerSocket.OnErrorEvent:=DoError;
    FServerSocket.ThreadCacheSize:=10;
End;

Destructor TServerSocket.Destroy;
Begin
     FServerSocket.Destroy;
     Inherited Destroy;
End;

Function TServerSocket.GetServerType: TServerType;
Begin
    Result:=FServerSocket.ServerType;
End;

Procedure TServerSocket.SetServerType(Value: TServerType);
Begin
    FServerSocket.ServerType:=Value;
End;

Function TServerSocket.GetGetThreadEvent: TGetThreadEvent;
Begin
    Result:=FServerSocket.OnGetThread;
End;

Procedure TServerSocket.SetGetThreadEvent(Value: TGetThreadEvent);
Begin
    FServerSocket.OnGetThread:=Value;
End;

Function TServerSocket.GetGetSocketEvent: TGetSocketEvent;
Begin
    Result:=FServerSocket.OnGetSocket;
End;

Procedure TServerSocket.SetGetSocketEvent(Value:TGetSocketEvent);
Begin
    FServerSocket.OnGetSocket:=Value;
End;

Function TServerSocket.GetThreadCacheSize:LongInt;
Begin
    Result:=FServerSocket.ThreadCacheSize;
End;

Procedure TServerSocket.SetThreadCacheSize(Value:LongInt);
Begin
    FServerSocket.ThreadCacheSize:=Value;
End;

Function TServerSocket.GetOnThreadStart:TThreadNotifyEvent;
Begin
    Result:=FServerSocket.OnThreadStart;
End;

Function TServerSocket.GetOnThreadEnd:TThreadNotifyEvent;
Begin
    Result:=FServerSocket.OnThreadEnd;
End;

Procedure TServerSocket.SetOnThreadStart(Value:TThreadNotifyEvent);
Begin
    FServerSocket.OnThreadStart:=Value;
End;

Procedure TServerSocket.SetOnThreadEnd(Value:TThreadNotifyEvent);
Begin
    FServerSocket.OnThreadEnd:=Value;
End;

Function TServerSocket.GetOnClientConnect:TSocketNotifyEvent;
Begin
    Result:=FServerSocket.OnClientConnect;
End;

Procedure TServerSocket.SetOnClientConnect(Value:TSocketNotifyEvent);
Begin
    FServerSocket.OnClientConnect:=Value;
End;

Function TServerSocket.GetOnClientDisconnect:TSocketNotifyEvent;
Begin
    Result:=FServerSocket.OnClientDisconnect;
End;

Function TServerSocket.GetOnClientDisconnected:TSocketNotifyEvent;
Begin
    Result:=FServerSocket.OnClientDisconnected;
End;


Procedure TServerSocket.SetOnClientDisconnect(Value:TSocketNotifyEvent);
Begin
    FServerSocket.OnClientDisconnect:=Value;
End;

Procedure TServerSocket.SetOnClientDisconnected(Value:TSocketNotifyEvent);
Begin
    FServerSocket.OnClientDisconnected:=Value;
End;


Function TServerSocket.GetOnClientRead: TSocketNotifyEvent;
Begin
    Result:=FServerSocket.OnClientRead;
End;

Procedure TServerSocket.SetOnClientRead(Value:TSocketNotifyEvent);
Begin
    FServerSocket.OnClientRead:=Value;
End;

Function TServerSocket.GetOnClientWrite:TSocketNotifyEvent;
Begin
    Result:=FServerSocket.OnClientWrite;
End;

Procedure TServerSocket.SetOnClientWrite(Value:TSocketNotifyEvent);
Begin
    FServerSocket.OnClientWrite:=Value;
End;

Function TServerSocket.GetOnClientError:TSocketErrorEvent;
Begin
    Result:=FServerSocket.OnClientError;
End;

Procedure TServerSocket.SetOnClientError(Value:TSocketErrorEvent);
Begin
    FServerSocket.OnClientError:=Value;
End;

Procedure TServerSocket.DoActivate(Value: Boolean);
Begin
    If Value=FServerSocket.Connected Then exit;
    If csDesigning In ComponentState Then exit;

    If ((Value=False)And(FServerSocket.Connected)) Then FServerSocket.Disconnect(FServerSocket.SocketHandle)
    Else If Value Then FServerSocket.Listen(FHost,FAddress,FService,FPort,5);
End;

Begin
    RegisterClasses([TClientSocket,TServerSocket]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  13-Feb-04  WD         Umbau von "TCustomWinSocket.LookupName" fuer Windows

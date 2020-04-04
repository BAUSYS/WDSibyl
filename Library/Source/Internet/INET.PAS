
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
   

Unit INet;

Interface

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin;
{$ENDIF}

{$IFDEF Win32}
Uses WinDef,WinBase,WinUser;
{$ENDIF}

Uses SysUtils,Classes,Forms,Dialogs,
     uString, uStream;

Const
  //Common MIME pairs
  MIME_IMAGE_GIF     ='image/gif';
  MIME_IMAGE_JPEG    ='image/jpeg';
  MIME_IMAGE_xBitmap ='image/x-xbitmap';
  MIME_IMAGE_BMP     ='image/bmp';

  MIME_APP_PDF       ='application/pdf';

/* WX_* window messages */
Const
  WX_MOUSEMOVE           = WM_USER + 1000;
  WX_BUTTONCLICK         = WM_USER + 1001;
  WX_LOADRESULT          = WM_USER + 1004;
  WX_LOADSTATUS          = WM_USER + 1005;
  WX_PRINTRESULT         = WM_USER + 1006;
  WX_MSGERROR            = WM_USER + 1007;
  WX_MSGINFO             = WM_USER + 1008;
  WX_MSGSTATUS           = WM_USER + 1009;
  WX_DISPLAYDIALOG       = WM_USER + 1010;
  WX_MSGSECURITY         = WM_USER + 1011;
  WX_CHANGEEXPIREDPASSWD = WM_USER + 1012;
  WX_SELNEWPRIVKEY       = WM_USER + 1013;

/* Error Messages */
Const
  WXENONE        =  0;
  WXEINVAL       =  1;
  WXEINPROGRESS  =  2;
  WXEFILE        =  3;
  WXENODOC       =  4;
  WXEBUFSIZE     =  5;
  WXENOPROXY     =  6;
  WXENOSOCKS     =  7;
  WXEMIME        =  8;
  WXENOTFOUND    =  9;
  WXEINTR        = 10;
  WXENOANCHOR    = 11;

Type
  {$M+}
  THTTPPos = Record
    Component:LongWord;
    x:Word;
    y:Word;
  End;

  THTTPFontSize=(httpFontSmall,httpFontNormal,httpFontLarge,httpFontXLarge);

  THTTPGateway=(httpGatewayNone,httpGatewayProxy,httpGatewaySocks,httpGatewayProxySocks);

  THTTPLoadStatus=(httpLoadSuccess,httpLoadCancelled,httpLoadError);

  THTTPOnLoad=Procedure(Sender:TObject;Status:THTTPLoadStatus) Of Object;

  THTTPOnMouseEvent=Procedure(Sender:TObject;Const Pos:THTTPPos) Of Object;

  THTTPSearchOptions=(httpSearchForward,httpSearchBackward);

  THTTPAnchorState=(httpAnchorDefault,httpAnchorVisited);
  {$M-}

  THTTPBrowser=Class(TControl)
     Private
         FInlineGraphicsAssigned:Boolean;
         FInlineGraphics:Boolean;
         FUnderlineAnchorsAssigned:Boolean;
         FUnderlineAnchors:Boolean;
         FHTTPFontSizeAssigned:Boolean;
         FHTTPFontSize:THTTPFontSize;
         FEmailAddress:PString;
         FNewsServer:PString;
         FProxyServer:PString;
         FSocksServer:PString;
         FGatewayAssigned:Boolean;
         FGateway:THTTPGateway;
         FEnableCacheAssigned:Boolean;
         FEnableCache:Boolean;
         FCacheDocLimitAssigned:Boolean;
         FCacheDocLimit:LongInt;
         FCacheImageLimitAssigned:Boolean;
         FCacheImageLimit:LongInt;
         FCacheDir:PString;

         FOnLoad:THTTPOnLoad;
         FOnDocMouseClick:THTTPOnMouseEvent;
         FOnDocMouseMove:THTTPOnMouseEvent;

         FLoaded:Boolean;
         FLoadCancel:Boolean;
         FURL:PString;
         FDLLHandle:LongWord;
         FWXViewQueryVersion:Function:Word;APIENTRY;
         FWXViewQueryDisplayOpts:Function(hwndView:LongWord;Var wxDisplayOpts;
                                          usSize:Word):LongWord;APIENTRY
         FWXViewSetDisplayOpts:Function(hwndView:LongWord;Var wxDisplayOpts;
                                        usSize:Word):LongWord;APIENTRY;
         FWXViewLoad:Function(hwndView:LongWord;pcszURL:PChar;
                              wxLoadFlags:LongWord;Const pwxAnchorData):LongWord;APIENTRY;
         FWXViewQueryViewer:Function(hwndView:LongWord;pcszMIMEType:PChar;
                                     Var Viewer;usSize:Word):LongWord;APIENTRY;
         FWXViewSetViewer:Function(hwndView:LongWord;Var pwxViewer;
                                   usSize:Word):LongWord;APIENTRY;
         FWXViewQueryNetworkOpts:Function(hwndView:LongWord;Var Opts;
                                          usSize:Word):LongInt;APIENTRY;
         FWXViewSetNetworkOpts:Function(hwndView:LongWord;Var Opts;
                                        usSize:Word):LongInt;APIENTRY;
         FWXViewEnableGateway:Function(hwndView:LongWord;wxGateway:LongWord):LongInt;APIENTRY;
         FWXViewQueryCacheOpts:Function(hwndView:LongWord;Var Opts;
                                        usSize:Word):Longint;APIENTRY;
         FWXViewSetCacheOpts:Function(hwndView:LongWord;Var Opts;
                                      usSize:Word):Longint;APIENTRY;
         FWXViewCancelLoad:Function(hwndView:LongWord):LongInt;APIENTRY;
         FWXViewQueryDocTitle:Function(hwndView:LongWord;pszTitle:PChar;
                                       usLen:Word):LongInt;APIENTRY;
         FWXViewQueryAnchorData:Function(hwndView:LongWord;Const pwxPos;
                                         var pwxAnchorData;usLen:Word):LongInt;APIENTRY;
         FWXViewQueryAnchorDataLen:Function(hwndView:LongWord;Const pwxPos):Word;APIENTRY;
         FWXViewQueryAnchor:Function(hwndView:LongWord;Const pwxPos;pszAnchor:PChar;
                                     usLen:Word):LongInt;APIENTRY;
         FWXViewQueryPos:Function(hwndView:LongWord;x,y:Word;
                                  Const pwxPos):LongInt;APIENTRY;
         FWXViewLoadToFile:Function(hwndView:LongWord;pcszURL,pcszFileName:PChar;
                                    wxLoadFlags:LongWord;Const pwxAnchorData):LongInt;APIENTRY;
         FWXViewQueryDocAnchor:Function(hwndView:LongWord;pszAnchor:PChar;
                                        usLen:Word):LongInt;APIENTRY;
         FWXViewSearch:Function(hwndView:LongWord;wxSearchOpts:LongWord;
                                Const pwStartPos;Var pwNextPos;
                                pcszSearchData:PChar):LongInt;APIENTRY;
         FWXViewIsLoading:Function(hwndView:LongWord):BOOL;APIENTRY;
         FWXViewQueryAnchorState:Function(hwndView:LongWord;pcszAnchor:PChar;
                                 Var pwxAnchorOpts:LongWord):LongInt;APIENTRY;
         FWXViewSetAnchorState:Function(hwndView:LongWord;pcszAnchor:PChar;
                                        wxAnchorOpts:LongWord):LongInt;APIENTRY;
         FWXViewQueryLastError:Function(hwndView:LongWord):LongInt;APIENTRY
         FWXViewQueryLastLoadError:Function(hwndView:LongWord):LongInt;APIENTRY;

     Private
         Function GetURL:String;
         Procedure SetURL(NewValue:String);
         Function GetVersion:Word;
         Function GetInlineGraphics:Boolean;
         Procedure SetInlineGraphics(NewValue:Boolean);
         Function GetUnderlineAnchors:Boolean;
         Procedure SetUnderlineAnchors(NewValue:Boolean);
         Function GetHTTPFontSize:THTTPFontSize;
         Procedure SetHTTPFontSize(NewValue:THTTPFontSize);
         Function GetEmailAddress:String;
         Procedure SetEmailAddress(NewValue:String);
         Function GetNewsServer:String;
         Procedure SetNewsServer(NewValue:String);
         Function GetProxyServer:String;
         Procedure SetProxyServer(NewValue:String);
         Function GetSocksServer:String;
         Procedure SetSocksServer(NewValue:String);
         Function GetGateway:THTTPGateway;
         Procedure SetGateway(NewValue:THTTPGateway);
         Function GetEnableCache:Boolean;
         Procedure SetEnableCache(NewValue:Boolean);
         Function GetCacheDocLimit:LongInt;
         Procedure SetCacheDocLimit(NewValue:LongInt);
         Function GetCacheImageLimit:LongInt;
         Procedure SetCacheImageLimit(NewValue:LongInt);
         Function GetCacheDir:String;
         Procedure SetCacheDir(NewValue:String);
         Procedure SetLoaded(NewValue:Boolean);
         Function GetDocTitle:String;
         Function GetIsLoading:Boolean;
         Function GetAnchorState(Const Anchor:String):THTTPAnchorState;
         Procedure SetAnchorState(Const Anchor:String;NewValue:THTTPAnchorState);
         Function GetLastLoadError:LongInt;
         Function GetLastError:LongInt;
     Protected
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure SetupShow;Override;
         Procedure WXLoadResult(Var Msg:TMessage); message WX_LOADRESULT;
         Procedure WXButtonClick(Var Msg:TMessage); message WX_BUTTONCLICK;
         Procedure WXMouseMove(Var Msg:TMessage); message WX_MOUSEMOVE;
         Procedure SetupComponent;Override;
     Public
         Destructor Destroy;Override;
         Function GetMIMEViewer(MIMEPair:String):String;
         Procedure SetMIMEViewer(MIMEPair,EXEProgram:String);
         Procedure Load;
         Procedure LoadWithAnchor(Var Anchor);
         Function LoadToFile(Const FileName:String):Boolean;
         Function LoadToFileWithAnchor(Const FileName:String;Var Anchor):Boolean;
         Procedure CancelLoad;
         Function GetAnchorDataLen(Const Pos:THTTPPos):LongWord;
         Function GetAnchorData(Const Pos:THTTPPos;Var Buf;BufLen:LongWord):Boolean;
         Function GetAnchor(Const Pos:THTTPPos):String;
         Function GetDocAnchor:String;
         Function Search(Const s:String;Const StartPos:THTTPPos;Options:THTTPSearchOptions):THTTPPos;
     Public
         Property Version:Word read GetVersion;
         Property DocTitle:String read GetDocTitle;
         Property IsLoading:Boolean read GetIsLoading;
         Property AnchorState[Const Anchor:String]:THTTPAnchorState read GetAnchorState write SetAnchorState;
         Property LastLoadError:LongInt read GetLastLoadError;
         Property LastError:LongInt read GetLastError;
     Published
         Property Align;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;

         Property URL:String read GetURL write SetURL;
         Property InlineGraphics:Boolean read GetInlineGraphics write SetInlineGraphics;
         Property UnderlineAnchors:Boolean read GetUnderlineAnchors write SetUnderlineAnchors;
         Property httpFontSize:THTTPFontSize read GetHTTPFontSize write SetHTTPFontSize;
         Property EmailAddress:String read GetEmailAddress write SetEmailAddress;
         Property NewsServer:String read GetNewsServer write SetNewsServer;
         Property ProxyServer:String read GetProxyServer write SetProxyServer;
         Property SocksServer:String read GetSocksServer write SetSocksServer;
         Property Gateway:THTTPGateway read GetGateway write SetGateway;
         Property EnableCache:Boolean read GetEnableCache write SetEnableCache;
         Property CacheDocLimit:LongInt read GetCacheDocLimit write SetCacheDocLimit;
         Property CacheImageLimit:LongInt read GetCacheImageLimit write SetCacheImageLimit;
         Property CacheDir:String read GetCacheDir write SetCacheDir;
         Property Loaded:Boolean read FLoaded write SetLoaded;

         Property OnLoad:THTTPOnLoad read FOnLoad write FOnLoad;
         Property OnDocMouseClick:THTTPOnMouseEvent read FOnDocMouseClick write FOnDocMouseClick;
         Property OnDocMouseMove:THTTPOnMouseEvent read FOnDocMouseMove write FOnDocMouseMove;
  End;

  {$M+}
  TFTPError=(ftpOk,ftpUnknownService,ftpUnkownHost,ftpSocketError,ftpCannotConnect,
             ftpLoginFailed,ftpTransferAborted,ftpCannotOpenFile,ftpConnectionError,
             fptCommandFailed,ftpProxyError,ftpNoPrimaryProxy,ftpNoTranslateTable,
             ftpNotConnected,ftpOther);

  TOnFTPError=Procedure(Sender:TObject;Err:TFTPError;Const Description:String) Of Object;

  TFTPDirOptions=(ftpDirWide,ftpDirShort);

  TFTPTransferMode=(ftpAscii,ftpBinary);

  TFTPPingResult=(ftpPingOk,ftpPingHostDoesNotReply,ftpPingSocketError,
                  ftpPingUnkownProtocol,ftpPingSendFailed,ftpPingReceiveFailed,
                  ftpPingUnkownHost,ftpPingOther);

  TFTPOnTransferProgress=Procedure(Sender:TObject;TransferredBytes,TotalBytes:LongInt) Of Object;
  {$M-}

  TFTP=Class(TComponent)
     Private
        FPassWord:PString;
        FRemoteHost:PString;
        FRemoteAccount:PString;
        FUserId:PString;
        FDLLHandle:LongWord;
        FConnected:Boolean;
        FTransferMode:TFTPTransferMode;
        FOnFTPError:TOnFTPError;

        Fftplogoff:Procedure;APIENTRY;
        Fftpget:Function(Const Host,UserId,Pwd,Account,Local,Remote,Mode:CString;
                         TransferType:LongInt):Longint;APIENTRY;
        Fftpput:Function(Const Host,UserId,Pwd,Account,Local,Remote:CString;
                         TransferType:LongInt):LongInt;APIENTRY;
        Fftpappend:Function(Const Host,UserId,Pwd,Account,Local,Remote:CString;
                            TransferType:LongInt):Longint;APIENTRY;
        Fftpputunique:Function(Const Host,UserId,Pwd,Account,Local,Remote:CString;
                               TransferType:LongInt):LongInt;APIENTRY;
        Fftpcd:Function(Const Host,UserId,Pwd,Account,Dir:CString):LongInt;APIENTRY;
        Fftpmkd:Function(Const Host,UserId,Pwd,Account,Dir:CString):LongInt;APIENTRY;
        Fftprmd:Function(Const Host,UserId,Pwd,Account,Dir:CString):LongInt;APIENTRY;
        Fftpdelete:Function(Const Host,UserId,Pwd,Account,Name:CString):LongInt;APIENTRY;
        Fftprename:Function(Const Host,UserId,Pwd,Account,NameFrom,NameTo:CString):LongInt;APIENTRY;
        Fftpls:Function(Const Host,UserId,Pwd,Account,Local,Pattern:CString):LongInt;APIENTRY;
        Fftpdir:Function(Const Host,UserId,Pwd,Account,Local,Pattern:CString):LongInt;APIENTRY;
        Fftpquote:Function(Const Host,UserId,Pwd,Account,QuoteStr:CString):LongInt;APIENTRY;
        Fftpping:Function(Const Host:CString;Len:LongInt;Var Addr:LongWord):LongInt;APIENTRY;
        Fftppwd:Function(Const Host,UserId,Pwd,Account:CString;Var Buf:CString;BufLen:LongInt):LongInt;APIENTRY;
        Fftpsys:Function(Const Host,UserId,Pwd,Account:CString;Var Buf:CString;BufLen:LongInt):LongInt;APIENTRY;
        Fftpver:Function(Var Buf:CString;BufLen:LongInt):LongInt;APIENTRY;
        FftpWindow:Procedure(Handle:LongWord);
        Fftp_errno:Function:LongInt;APIENTRY;

        FNotifyControl:TControl;
        FOnTransferProgress:TFTPOnTransferProgress;
        FOnError:TOnFTPError;
     Private
        Function GetPassWord:String;
        Procedure SetPassWord(NewValue:String);
        Function GetRemoteHost:String;
        Procedure SetRemoteHost(NewValue:String);
        Function GetRemoteAccount:String;
        Procedure SetRemoteAccount(NewValue:String);
        Function GetUserID:String;
        Procedure SetUserID(NewValue:String);
        Function GetRemoteDirName:String;
        Procedure SetRemoteDirName(NewValue:String);
        Function GetFTPError:TFTPError;
        Procedure SetConnected(NewValue:Boolean);
        Function GetVersion:String;
        Function GetSystem:String;
     Protected
        Procedure SetupComponent;Override;
     Public
        Destructor Destroy;Override;
        Function Connect:TFTPError;
        Procedure Disconnect;
        Function GetRemoteDir(Const Pattern:String;Dir:TStrings;Options:TFTPDirOptions):TFTPError;
        Function DeleteRemoteFile(Const FileName:String):TFTPError;
        Function RenameRemoteFile(Const OldName,NewName:String):TFTPError;
        Function MakeRemoteDir(Const DirName:String):TFTPError;
        Function RemoveRemoteDir(Const DirName:String):TFTPError;
        Function AppendToRemoteFile(Const RemoteFileName,LocalFileName:String):TFTPError;
        Function GetRemoteFile(Const RemoteFileName,LocalFileName:String):TFTPError;
        Function PutLocalFile(Const LocalFileName,RemoteFileName:String):TFTPError;
        Function PutUniqueLocalFile(Const LocalFileName,RemoteFileName:String):TFTPError;
        Function Quote(Const ftpstring:String):TFTPError;
        Function Ping(Const HostName:String;PacketLen:LongInt;
                      Var Address:LongWord;Var Milliseconds:LongInt):TFTPPingResult;
        Procedure FTPError(Err:TFTPError);VIRTUAL;
     Public
        Property Connected:Boolean read FConnected write SetConnected;
        Property Version:String read GetVersion;
        Property System:String read GetSystem;
     Published
        Property Password:String read GetPassWord write SetPassWord;
        Property RemoteHost:String read GetRemoteHost write SetRemoteHost;
        Property RemoteAccount:String read GetRemoteAccount write SetRemoteAccount;
        Property UserId:String read GetUserId write SetUserId;
        Property RemoteDirName:String read GetRemoteDirName write SetRemoteDirName;
        Property TransferMode:TFTPTransferMode read FTransferMode write FTransferMode;

        Property OnTransferProgress:TFTPOnTransferProgress read FOnTransferProgress write FOnTransferProgress;
        Property OnError:TOnFTPError read FOnError write FOnError;
  End;

  TTCPError=Procedure(Sender:TObject;ErrNumber:LongInt;Const Description:String) Of Object;
  TTCPConnectionRequest=Procedure(Sender:TObject;PortID:LongInt;Const IP:String) Of Object;

  TTCPState=(sckClosed,sckListening,sckConnected,sckError);

//TTCP Error codes
Const
    SOCBASEERR              =10000;

    /* OS/2 SOCKET API definitions */
    SOCEPERM                =SOCBASEERR+1;             /* Not owner */
    SOCESRCH                =SOCBASEERR+3;             /* No such process */
    SOCEINTR                =SOCBASEERR+4;             /* Interrupted system call */
    SOCENXIO                =SOCBASEERR+6;             /* No such device or address */
    SOCEBADF                =SOCBASEERR+9;             /* Bad file number */
    SOCEACCES               =SOCBASEERR+13;            /* Permission denied */
    SOCEFAULT               =SOCBASEERR+14;            /* Bad address */
    SOCEINVAL               =SOCBASEERR+22;            /* Invalid argument */
    SOCEMFILE               =SOCBASEERR+24;            /* Too many open files */
    SOCEPIPE                =SOCBASEERR+32;            /* Broken pipe */

    SOCEOS2ERR              =SOCBASEERR+100;           /* OS/2 Error */

    /* OS/2 SOCKET API definitions of regular BSD error constants */
    SOCEWOULDBLOCK          =SOCBASEERR+35;            /* Operation would block */
    SOCEINPROGRESS          =SOCBASEERR+36;            /* Operation now in progress */
    SOCEALREADY             =SOCBASEERR+37;            /* Operation already in progress */
    SOCENOTSOCK             =SOCBASEERR+38;            /* Socket operation on non-socket */
    SOCEDESTADDRREQ         =SOCBASEERR+39;            /* Destination address required */
    SOCEMSGSIZE             =SOCBASEERR+40;            /* Message too long */
    SOCEPROTOTYPE           =SOCBASEERR+41;            /* Protocol wrong type for socket */
    SOCENOPROTOOPT          =SOCBASEERR+42;            /* Protocol not available */
    SOCEPROTONOSUPPORT      =SOCBASEERR+43;            /* Protocol not supported */
    SOCESOCKTNOSUPPORT      =SOCBASEERR+44;            /* Socket type not supported */
    SOCEOPNOTSUPP           =SOCBASEERR+45;            /* Operation not supported on socket */
    SOCEPFNOSUPPORT         =SOCBASEERR+46;            /* Protocol family not supported */
    SOCEAFNOSUPPORT         =SOCBASEERR+47;            /* Address family not supported by protocol family */
    SOCEADDRINUSE           =SOCBASEERR+48;            /* Address already in use */
    SOCEADDRNOTAVAIL        =SOCBASEERR+49;            /* Can't assign requested address */
    SOCENETDOWN             =SOCBASEERR+50;            /* Network is down */
    SOCENETUNREACH          =SOCBASEERR+51;            /* Network is unreachable */
    SOCENETRESET            =SOCBASEERR+52;            /* Network dropped connection on reset */
    SOCECONNABORTED         =SOCBASEERR+53;            /* Software caused connection abort */
    SOCECONNRESET           =SOCBASEERR+54;            /* Connection reset by peer */
    SOCENOBUFS              =SOCBASEERR+55;            /* No buffer space available */
    SOCEISCONN              =SOCBASEERR+56;            /* Socket is already connected */
    SOCENOTCONN             =SOCBASEERR+57;            /* Socket is not connected */
    SOCESHUTDOWN            =SOCBASEERR+58;            /* Can't send after socket shutdown */
    SOCETOOMANYREFS         =SOCBASEERR+59;            /* Too many references: can't splice */
    SOCETIMEDOUT            =SOCBASEERR+60;            /* Connection timed out */
    SOCECONNREFUSED         =SOCBASEERR+61;            /* Connection refused */
    SOCELOOP                =SOCBASEERR+62;            /* Too many levels of symbolic links */
    SOCENAMETOOLONG         =SOCBASEERR+63;            /* File name too long */
    SOCEHOSTDOWN            =SOCBASEERR+64;            /* Host is down */
    SOCEHOSTUNREACH         =SOCBASEERR+65;            /* No route to host */
    SOCENOTEMPTY            =SOCBASEERR+66;            /* Directory not empty */

Type
  TTCP = Class(TComponent)
     Private
        FInSocket:LongInt;
        FOutSocket:LongInt;
        FAcceptSocket:LongInt;
        FOnError:TTCPError;
        FOnConnect:TNotifyEvent;
        FOnConnectionRequest:TTCPConnectionRequest;
        FOnClose:TNotifyEvent;
        FOnSendComplete:TNotifyEvent;
        FQueueLength:LongInt;
        FLocalAddress:LongWord;
        FDLLHandle:LongWord;
        FTCPDLLHandle:LongWord;
        FErrorCode:LongInt;
        FLocalPort:LongInt;
        FSockMode:LongWord;
        FConnected:Boolean;
        FState:TTCPState;

        FAccept:Function(p1:LONGINT;VAR sa;var p2:LONGINT):LongInt;APIENTRY;
        FSock_Init:Function:LongInt;APIENTRY;
        FSoClose:Function(p1:LongInt):LongInt;APIENTRY;
        FINet_Addr:Function(Const c:CSTRING):LongWord;APIENTRY;
        FBind:Function(p1:LongInt;Var sa;p2:LongInt):LongInt;APIENTRY;
        FConnect:Function(p1:LongInt;Var sa;p2:LongInt):LongInt;APIENTRY;
        FGethostname:Function(Var C:CString;Len:LongWord):LongInt;APIENTRY;
        FGethostid:Function:LongInt;APIENTRY;
        FGetpeername:Function(p1:LongInt;Var sa;Var p2:LongInt):LongInt;APIENTRY;
        FGetsockname:Function(p1:LongInt;Var sa;Var p2:LongInt):LongInt;APIENTRY;
        FGetsockopt:Function(p1,p2,p3:LongInt;Var c:CString;Var p4:LongInt):LongInt;APIENTRY;
        Fioctl:Function(p1,p2:LongInt;Var c:CString;p3:LongInt):LongInt;APIENTRY;
        FListen:Function(p1,p2:LongInt):LongInt;APIENTRY;
        Frecvmsg:Function(p1:LongInt;Var mh;p2:LongInt):LongInt;APIENTRY;
        Frecv:Function(p1:LongInt;Var c;p2,p3:LongInt):LongInt;APIENTRY;
        Frecvfrom:Function(p1:LongInt;Var c;p2,p3:LongInt;Var sa;
                           Var p4:LongInt):LongInt;APIENTRY;
        Fselect:Function(Var p1:LongInt;p2,p3,p4,p5:LongInt):LongInt;APIENTRY;
        Fsend:Function(p1:LONGINT;VAR c;p2,p3:LONGINT):LONGINT;APIENTRY;
        Fsendmsg:Function(p1:LongInt;Var mh;p2:LongInt):LongInt;APIENTRY;
        Fsendto:Function(p1:LongInt;Var c;p2,p3:LongInt;
                         Var sa;p4:LongInt):LongInt;APIENTRY;
        Fsetsockopt:Function(p1,p2,p3:LongInt;Var c:CString;p4:LongInt):LongInt;APIENTRY;
        Fsock_errno:Function:LongInt;APIENTRY;
        Fpsock_errno:Function(Const c:CString):LongInt;APIENTRY;
        FSocket:Function(p1,p2,p3:LongInt):LongInt;APIENTRY;
        Fsoabort:Function(p1:LongInt):LongInt;APIENTRY;
        Fso_cancel:Function(p1:LongInt):LongInt;APIENTRY;
        Freadv:Function(p1:LongInt;Var io;p2:LongInt):LongInt;APIENTRY;
        Fwritev:Function(p1:LongInt;Var io;p2:LongInt):LongInt;APIENTRY;
        Fshutdown:Function(p1,p2:LongInt):LongInt;APIENTRY;
        Fgetinetversion:Function(Var c:CString):LongInt;APIENTRY;
        FBswap:Function(p:Word):Word;APIENTRY;
        Fgethostbyname:Function(Const c:CString):Pointer;APIENTRY;
     Private
        Function GetLocalHostName:String;
        Function GetLocalIP:String;
        Function GetLocalPort:LongInt;
        Procedure SetLocalPort(NewValue:LongInt);
     Protected
        Procedure SetupComponent;Override;
     Public
        Procedure Connect(Const RemoteHost:String;RemotePort:LongInt);
        Procedure Listen;
        Procedure Accept(Var PortID:LongInt;Var IP:String);
        Procedure SendData(Var Buf;BufLen:LongInt);
        Procedure GetData(Var Buf;MaxLen:LongInt;Var Received:LongInt);
        Procedure PeekData(Var Buf;MaxLen:LongInt;Var Received:LongInt);
        Procedure Close;
        Destructor Destroy;Override;
        Procedure TCPError(Code:LongInt);Virtual;
     Public
        Property LocalHostName:String read GetLocalHostName;
        Property LocalIP:String read GetLocalIP;
        Property InSocketHandle:LongInt read FInSocket;
        Property OutSocketHandle:LongInt read FOutSocket;
        Property AcceptSocketHandle:LongInt read FAcceptSocket;
        Function INetAddressFromName(Const Name:String):LongWord;
        Property ErrorCode:LongInt read FErrorCode;
        Property Connected:Boolean read FConnected;
        Property State:TTCPState read FState;
     Published
        Property LocalPort:LongInt read GetLocalPort write SetLocalPort;
        Property QueueLength:LongInt read FQueueLength write FQueueLength;
        Property LocalAddress:LongWord read FLocalAddress write FLocalAddress;

        Property OnError:TTCPError read FOnError write FOnError;
        Property OnConnect:TNotifyEvent read FOnConnect write FOnConnect;
        Property OnConnectionRequest:TTCPConnectionRequest read FOnConnectionRequest write FOnConnectionRequest;
        Property OnClose:TNotifyEvent read FOnClose write FOnClose;
        Property OnSendComplete:TNotifyEvent read FOnSendComplete write FOnSendComplete;
  End;

  TUDP=Class(TTCP)
     Protected
        Procedure SetupComponent;Override;
     Public
        Procedure SendTo(Const RemoteHost:String;RemotePort:LongInt;
                         Var Buf;BufLen:LongInt);
        Procedure ReceiveFrom(Const RemoteHost:String;RemotePort:LongInt;
                              Var Buf;BufLen:LongWord);
  End;

Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: THTTPBrowser Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Type
    EProcAddrError=Class(Exception);

Const
    WC_WXVIEW:Cstring[9]='WXViewWC';

Const
  WX_ERROR       = -1;
  WX_SUCCESS     =  0;
  WX_CANCELLED   =  1;

Type
  WXFONTSIZE = LongWord;

Const
  WXFONT_SMALL  = 0;
  WXFONT_NORMAL = 1;
  WXFONT_LARGE  = 2;
  WXFONT_XLARGE = 3;

  WXSMALLSTRING  =   32;
  WXMEDSTRING    =  256;
  WXLARGESTRING  = 1024;

  WXGATEWAY_NONE          = 0;
  WXGATEWAY_PROXY         = 1;          /* gateway flags can be OR'ed */
  WXGATEWAY_SOCKS         = 2;

  WXSEARCH_FORWARD  = 0;
  WXSEARCH_BACKWARD = 1;

  WXANCHOR_DEFAULT = 0;                 /* can be OR'ed together */
  WXANCHOR_VISITED = 1;

  WM_FTPAPI_XFER_UPDATE    = WM_USER + 1000;

Type
  PWXDISPLAYOPTS = ^WXDISPLAYOPTS;
  WXDISPLAYOPTS = Record
    szFontName: cstring[WXSMALLSTRING-1];
    wxFontSize: WXFONTSIZE;
    bUnderlineAnchors: BOOL;                /* use underline text for links */

    lClrText: LONG;                         /* text color */
    lClrAnchor: LONG;                       /* link color */
    lClrVisitedAnchor: LONG ;               /* seen link color */
    lClrBackground: LONG ;                  /* bg view color */

    bInlineGraphics: BOOL;                  /* show inline images? */
    bFastLoad: BOOL;                        /* load document ahead of images? */
    bStreamingGraphics: BOOL;               /* scanline-at-a-time redraw? */
    bFancyInterlace: BOOL;                  /* blur the ilaced GIF? */

    bInternalViewer: BOOL;                  /* view standalone imgs in view? */
    bIgnoreImgErrors: BOOL;                 /* toggle display of red "X" on error */
  End;

  WXVIEWER = Record
    szMIMEType: CString[WXMEDSTRING-1];       /* MIME type to be viewed */
    szProgram: CString[WXLARGESTRING-1];      /* program to use as a viewer */
  End;
  PWXVIEWER = ^WXVIEWER;

  WXGATEWAY = ULONG;

  WXNETWORKOPTS = Record
    szEmailAddress: CString[WXLARGESTRING-1];     /* user@host smtp style address */
    szNewsServer: CString[WXLARGESTRING-1];       /* news hostname/ip address */
    wxGateway: WXGATEWAY;                       /* proxy or socks server state */
    szHTTPProxyServer: CString[WXLARGESTRING-1];  /* proxy gw (http://..) */
    szSocksServer: CString[WXLARGESTRING-1];      /* socks gw hostname/ip address */
  End;
  PWXNETWORKOPTS = ^WXNETWORKOPTS;

  WXCACHEOPTS = Record
    bEnabled: BOOL;                         /* enable, disable cacheing */
    bMemoryImageCacheing: BOOL;             /* keep cached images in memory */
    lDocLimit: LONG;                        /* number of docs to cache */
    lImageLimit: LONG;                      /* number of images to cache */
    szCacheDir: Cstring[WXMEDSTRING-1];       /* directory for cacheing to disk */
  End;
  PWXCACHEOPTS = ^WXCACHEOPTS;

  WXFLAGS   = ULONG;

  WXBUTTONDATA = Record
    usButtonNum: USHORT;
    usClickNum: USHORT;
    x: SHORT;
    y: SHORT;
    fsHitTestRes: USHORT;
    fsFlags: USHORT;
    wxflPosType: WXFLAGS;
  End;
  PWXBUTTONDATA = ^WXBUTTONDATA;

  WXMOUSEDATA = Record
    x: USHORT;
    y: USHORT;
    uswHitTest: USHORT;
    fsFlags: USHORT;
    wxflPosType: WXFLAGS;
  end;
  PWXMOUSEDATA = ^WXMOUSEDATA;


Function GetProcAddr(DllHandle:LongWord;Const ProcName:String):Pointer;
Var S:cstring;
Begin
     S:=ProcName;
     {$IFDEF OS2}
     If DosQueryProcAddr(DllHandle,0,S,Result)<>0 Then Raise EProcAddrError.Create(ProcName);
     {$ENDIF}
     {$IFDEF Win32}
     Result:=GetProcAddress(DllHandle,S);
     If Result=Nil Then Raise EProcAddrError.Create(ProcName);
     {$ENDIF}
End;

Procedure THTTPBrowser.GetClassData(Var ClassData:TClassData);
Begin
   Inherited GetClassData(ClassData);
   If FDLLHandle<>0 Then
   Begin
      ClassData.ClassULong:=0;
      ClassData.ClassName:=WC_WXVIEW;
      OwnerDraw:=False;
   End;
End;

Function THTTPBrowser.GetVersion:Word;
Begin
    If FDLLHandle<>0 Then Result:=FWXViewQueryVersion
    Else Result:=0;
End;

Procedure THTTPBrowser.SetupShow;
Var Opts: WXDISPLAYOPTS;
Begin
    Inherited SetupShow;

    If FDLLHandle<>0 Then
    Begin
       If not FHTTPFontSizeAssigned Then
       Begin
          FWXViewQueryDisplayOpts(Handle,Opts,SizeOf(Opts));
          Opts.WXFontSize := WXFONT_SMALL;
          FWXViewSetDisplayOpts(Handle,Opts,SizeOf(Opts));
       End;

       If FInlineGraphicsAssigned Then InlineGraphics:=FInlineGraphics;
       If FUnderlineAnchorsAssigned Then UnderlineAnchors:=FUnderlineAnchors;
       If FHTTPFontSizeAssigned Then HTTPFontSize:=FHTTPFontSize;
       If FEmailAddress<>Nil Then
       Begin
         EmailAddress:=FEmailAddress^;
         FreeMem(FEmailAddress,length(FEmailAddress^)+1);
         FEmailAddress:=Nil;
       End;
       If FNewsServer<>Nil Then
       Begin
         NewsServer:=FNewsServer^;
         FreeMem(FNewsServer,length(FNewsServer^)+1);
         FNewsServer:=Nil;
       End;
       If FProxyServer<>Nil Then
       Begin
         ProxyServer:=FProxyServer^;
         FreeMem(FProxyServer,length(FProxyServer^)+1);
         FProxyServer:=Nil;
       End;
       If FSocksServer<>Nil Then
       Begin
         SocksServer:=FSocksServer^;
         FreeMem(FSocksServer,length(FSocksServer^)+1);
         FSocksServer:=Nil;
       End;
       If FGatewayAssigned Then Gateway:=FGateway;
       If FEnableCacheAssigned Then EnableCache:=FEnableCache;
       If FCacheDocLimitAssigned Then CacheDocLimit:=FCacheDocLimit;
       If FCacheImageLimitAssigned Then CacheImageLimit:=FCacheImageLimit;
       If FCacheDir<>Nil Then
       Begin
           CacheDir:=FCacheDir^;
           FreeMem(FCacheDir,length(FCacheDir^)+1);
           FCacheDir:=Nil;
       End;
    End;
End;

Function THTTPBrowser.GetURL:String;
Begin
    If FURL<>Nil Then Result:=FURL^
    Else Result:='';
End;

Procedure THTTPBrowser.SetURL(NewValue:String);
Begin
    If FDLLHandle=0 Then exit;

    If FURL<>Nil Then FreeMem(FURL,length(FURL^)+1);
    GetMem(FURL,length(NewValue)+1);
    FURL^:=NewValue;
    If Loaded Then Load;
End;

Procedure THTTPBrowser.Load;
Var C:CString;
Begin
    If FDLLHandle<>0 Then If Handle<>0 Then If URL<>'' Then
    Begin
        C:=FURL^;
        If FWXViewLoad(Handle,@C,0,Nil)<>WX_SUCCESS Then
         If FOnLoad<>Nil Then FOnLoad(Self,httpLoadError);;
    End;
End;

Procedure THTTPBrowser.LoadWithAnchor(Var Anchor);
Var C:CString;
Begin
    If FDLLHandle<>0 Then If Handle<>0 Then If URL<>'' Then
    Begin
        C:=FURL^;
        If FWXViewLoad(Handle,@C,0,Anchor)<>WX_SUCCESS Then
         If FOnLoad<>Nil Then FOnLoad(Self,httpLoadError);
    End;
End;

Function THTTPBrowser.LoadToFile(Const FileName:String):Boolean;
Var C,C1:CString;
Begin
    Result:=False;
    If FDLLHandle<>0 Then If Handle<>0 Then If URL<>'' Then
    Begin
        C:=FURL^;
        C1:=FileName;
        Result:=FWXViewLoadToFile(Handle,@C,@C1,0,Nil)=WX_SUCCESS;
        If not Result Then
         If FOnLoad<>Nil Then FOnLoad(Self,httpLoadError);
    End;
End;

Function THTTPBrowser.LoadToFileWithAnchor(Const FileName:String;Var Anchor):Boolean;
Var C,C1:CString;
Begin
    Result:=False;
    If FDLLHandle<>0 Then If Handle<>0 Then If URL<>'' Then
    Begin
        C:=FURL^;
        C1:=FileName;
        Result:=FWXViewLoadToFile(Handle,@C,@C1,0,Anchor)=WX_SUCCESS;
        If not Result Then
         If FOnLoad<>Nil Then FOnLoad(Self,httpLoadError);
    End;
End;


Procedure THTTPBrowser.CancelLoad;
Begin
     If FDLLHandle<>0 Then If Handle<>0 Then
     Begin
         FLoadCancel:=False;
         If FWXViewCancelLoad(Handle)<>WX_ERROR Then
         Begin
             //wait for the cancel operation to complete
             Repeat
                 Application.HandleMessage;
             Until FLoadCancel;
         End;
     End;
End;

Procedure THTTPBrowser.SetupComponent;

Var DllName:CString;
{$IFDEF OS2}
    C : cString;
    rc: ApiRet;
{$ENDIF}

Begin
    Inherited SetupComponent;

    Width:=300;
    Height:=300;

    DllName:='WEBEXWIN';
    {$IFDEF OS2}
    rc:=DosLoadModule(C,255,DllName,FDllHandle);
    If rc<>0 Then
    Begin
         FDLLHandle:=0;
         If ComponentState * [csWriting,csDesigning] = []
           Then ErrorBox('DLL not found: WEBEXWIN.DLL !');
         Exit;
    End;
    {$ENDIF}
    {$IFDEF WIN32}
    If ComponentState * [csWriting,csDesigning] = []
      Then ErrorBox('THTTPBrowser currently not supported for Win32 !');
    Exit;
    {$ENDIF}

    Try
       FWXViewQueryVersion:=Pointer(GetProcAddr(FDllHandle,'WXViewQueryVersion'));
       FWXViewQueryDisplayOpts:=Pointer(GetProcAddr(FDllHandle,'WXViewQueryDisplayOpts'));
       FWXViewSetDisplayOpts:=Pointer(GetProcAddr(FDllHandle,'WXViewSetDisplayOpts'));
       FWXViewLoad:=Pointer(GetProcAddr(FDllHandle,'WXViewLoad'));
       FWXViewQueryViewer:=(GetProcAddr(FDllHandle,'WXViewQueryViewer'));
       FWXViewSetViewer:=(GetProcAddr(FDllHandle,'WXViewSetViewer'));
       FWXViewQueryNetworkOpts:=(GetProcAddr(FDllHandle,'WXViewQueryNetworkOpts'));
       FWXViewSetNetworkOpts:=(GetProcAddr(FDllHandle,'WXViewSetNetworkOpts'));
       FWXViewEnableGateway:=(GetProcAddr(FDllHandle,'WXViewEnableGateway'));
       FWXViewQueryCacheOpts:=(GetProcAddr(FDllHandle,'WXViewQueryCacheOpts'));
       FWXViewSetCacheOpts:=(GetProcAddr(FDllHandle,'WXViewSetCacheOpts'));
       FWXViewCancelLoad:=(GetProcAddr(FDllHandle,'WXViewCancelLoad'));
       FWXViewQueryDocTitle:=(GetProcAddr(FDllHandle,'WXViewQueryDocTitle'));
       FWXViewQueryAnchorData:=(GetProcAddr(FDllHandle,'WXViewQueryAnchorData'));
       FWXViewQueryAnchorDataLen:=(GetProcAddr(FDllHandle,'WXViewQueryAnchorDataLen'));
       FWXViewQueryAnchor:=(GetProcAddr(FDllHandle,'WXViewQueryAnchor'));
       FWXViewQueryPos:=(GetProcAddr(FDllHandle,'WXViewQueryPos'));
       FWXViewLoadToFile:=(GetProcAddr(FDllHandle,'WXViewLoadToFile'));
       FWXViewQueryDocAnchor:=(GetProcAddr(FDllHandle,'WXViewQueryDocAnchor'));
       FWXViewSearch:=(GetProcAddr(FDllHandle,'WXViewSearch'));
       FWXViewIsLoading:=(GetProcAddr(FDllHandle,'WXViewIsLoading'));
       FWXViewQueryAnchorState:=(GetProcAddr(FDllHandle,'WXViewQueryAnchorState'));
       FWXViewSetAnchorState:=(GetProcAddr(FDllHandle,'WXViewSetAnchorState'));
       FWXViewQueryLastError:=(GetProcAddr(FDllHandle,'WXViewQueryLastError'));
       FWXViewQueryLastLoadError:=(GetProcAddr(FDllHandle,'WXViewQueryLastLoadError'));

       FWXViewQueryVersion; //Initialize and load window class
    Except
       {$IFDEF OS2}
       DosFreeModule(FDLLHandle);
       {$ENDIF}
       FDLLHandle:=0;
       On E:EProcAddrError Do
       Begin
         If ComponentState * [csWriting,csDesigning] = []
           Then ErrorBox('Cannot retrieve procedure from WEBEXWIN:'+E.Message+' !');
       End;
       Else Raise;
    End;
End;

Destructor THTTPBrowser.Destroy;
Begin
    If FDLLHandle<>0 Then
    Begin
         {$IFDEF OS2}
         DosFreeModule(FDLLHandle);
         {$ENDIF}
         FDLLHandle:=0;
    End;
    If FURL<>Nil Then
    Begin
       FreeMem(FURL,length(FURL^)+1);
       FURL:=Nil;
    End;

    If FEmailAddress<>Nil Then
    Begin
         FreeMem(FEmailAddress,length(FEmailAddress^)+1);
         FEmailAddress:=Nil;
    End;
    If FNewsServer<>Nil Then
    Begin
         FreeMem(FNewsServer,length(FNewsServer^)+1);
         FNewsServer:=Nil;
    End;
    If FProxyServer<>Nil Then
    Begin
         FreeMem(FProxyServer,length(FProxyServer^)+1);
         FProxyServer:=Nil;
    End;
    If FSocksServer<>Nil Then
    Begin
         FreeMem(FSocksServer,length(FSocksServer^)+1);
         FSocksServer:=Nil;
    End;
    If FCacheDir<>Nil Then
    Begin
         FreeMem(FCacheDir,length(FCacheDir^)+1);
         FCacheDir:=Nil;
    End;

    Inherited Destroy;
End;

Function THTTPBrowser.GetInlineGraphics:Boolean;
Var Opts: WXDISPLAYOPTS;
Begin
    If FDLLHandle=0 Then exit;
    If Handle=0 Then
    Begin
       If FInlineGraphicsAssigned Then result:=FInlineGraphics
       Else Result:=False;
       exit
    End;
    FWXViewQueryDisplayOpts(Handle,Opts,SizeOf(Opts));
    Result:=Opts.bInlineGraphics;
End;

Procedure THTTPBrowser.SetInlineGraphics(NewValue:Boolean);
Var Opts: WXDISPLAYOPTS;
    RetErr:LongInt;
Begin
    If FDLLHandle=0 Then exit;
    If Handle<>0 Then
    Begin
       RetErr:=FWXViewQueryDisplayOpts(Handle,Opts,SizeOf(Opts));
       If RetErr<>WX_SUCCESS Then exit;
       Opts.bInlineGraphics:=NewValue;
       FWXViewSetDisplayOpts(Handle,Opts,SizeOf(Opts));
    End
    Else
    Begin
       FInlineGraphicsAssigned:=True;
       FInlineGraphics:=NewValue;
    End;
End;

Function THTTPBrowser.GetUnderlineAnchors:Boolean;
Var Opts: WXDISPLAYOPTS;
Begin
    If FDLLHandle=0 Then exit;
    If Handle=0 Then
    Begin
        If FUnderlineAnchorsAssigned Then Result:=FUnderlineAnchors
        Else Result:=False;
        exit;
    End;
    FWXViewQueryDisplayOpts(Handle,Opts,SizeOf(Opts));
    Result:=Opts.bUnderlineAnchors;
End;

Procedure THTTPBrowser.SetUnderlineAnchors(NewValue:Boolean);
Var Opts: WXDISPLAYOPTS;
    RetErr:LongInt;
Begin
    If FDLLHandle=0 Then exit;
    If Handle<>0 Then
    Begin
        RetErr:=FWXViewQueryDisplayOpts(Handle,Opts,SizeOf(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.bUnderlineAnchors:=NewValue;
        FWXViewSetDisplayOpts(Handle,Opts,SizeOf(Opts));
    End
    Else
    Begin
        FUnderlineAnchorsAssigned:=True;
        FUnderlineAnchors:=NewValue;
    End;
End;

Function THTTPBrowser.GetHTTPFontSize:THTTPFontSize;
Var Opts: WXDISPLAYOPTS;
Begin
    Result:=httpFontNormal;
    If FDLLHandle=0 Then exit;
    If Handle=0 Then
    Begin
       If FHTTPFontSizeAssigned Then result:=FHTTPFontSize
       Else Result:=httpFontNormal;
       exit;
    End;
    FWXViewQueryDisplayOpts(Handle,Opts,SizeOf(Opts));
    Case Opts.wxFontSize Of
       WXFONT_SMALL:Result:=httpFontSmall;
       WXFONT_LARGE:Result:=httpFontLarge;
       WXFONT_XLARGE:Result:=httpFontXLarge;
       Else Result:=httpFontNormal;
    End;
End;

Procedure THTTPBrowser.SetHTTPFontSize(NewValue:THTTPFontSize);
Var Opts: WXDISPLAYOPTS;
    s:WXFONTSIZE;
    RetErr:LongInt;
Begin
    If FDLLHandle=0 Then exit;
    If Handle<>0 Then
    Begin
       RetErr:=FWXViewQueryDisplayOpts(Handle,Opts,SizeOf(Opts));
       If RetErr<>WX_SUCCESS Then exit;
       Case NewValue Of
          httpFontSmall:s:=WXFONT_SMALL;
          httpFontNormal:s:=WXFONT_NORMAL;
          httpFontLarge:s:=WXFONT_LARGE;
          httpFontXLarge:s:=WXFONT_XLARGE;
       End;
       Opts.wxFontSize:=s;
       FWXViewSetDisplayOpts(Handle,Opts,SizeOf(Opts));
    End
    Else
    Begin
       FHTTPFontSizeAssigned:=True;
       FHTTPFontSize:=NewValue;
    End;
End;

Function THTTPBrowser.GetMIMEViewer(MIMEPair:String):String;
Var Viewer:WXVIEWER;
    RetErr:LongInt;
    c:CString;
Begin
    Result:='';
    If FDLLHandle=0 Then exit;
    If Handle=0 Then exit;
    c:=MimePair;
    Viewer.szMIMEType:=c;
    Viewer.szProgram:='';
    RetErr:=FWXViewQueryViewer(Handle,@c,Viewer,sizeof(Viewer));
    If RetErr=WX_SUCCESS Then Result:=Viewer.szProgram
    Else Result:='';
End;

Procedure THTTPBrowser.SetMIMEViewer(MIMEPair,EXEProgram:String);
Var Viewer:WXVIEWER;
Begin
    If FDLLHandle=0 Then exit;
    If Handle=0 Then exit;
    Viewer.szMIMEType:=MIMEPair;
    Viewer.szProgram:=ExeProgram;
    FWXViewSetViewer(Handle,Viewer,sizeof(Viewer));
End;

Function THTTPBrowser.GetEmailAddress:String;
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     Result:='';
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
         If FEmailAddress<>Nil Then Result:=FEmailAddress^
         Else Result:='';
         exit;
     End;
     RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.szEmailAddress;
End;

Procedure THTTPBrowser.SetEmailAddress(NewValue:String);
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
        RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.szEmailAddress:=NewValue;
        FWXViewSetNetWorkOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
        GetMem(FEmailAddress,length(NewValue)+1);
        FEmailAddress^:=NewValue;
     End;
End;


Function THTTPBrowser.GetNewsServer:String;
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     Result:='';
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
        If FNewsServer<>Nil Then Result:=FNewsServer^
        Else Result:='';
        exit;
     End;
     RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.szNewsServer;
End;

Procedure THTTPBrowser.SetNewsServer(NewValue:String);
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
        RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.szNewsServer:=NewValue;
        FWXViewSetNetWorkOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
        GetMem(FNewsServer,length(NewValue)+1);
        FNewsServer^:=NewValue;
     End;
End;

Function THTTPBrowser.GetProxyServer:String;
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     Result:='';
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
        If FProxyServer<>Nil Then Result:=FProxyServer^
        Else Result:='';
        exit;
     End;
     RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.szHTTPProxyServer;
End;

Procedure THTTPBrowser.SetProxyServer(NewValue:String);
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
        RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.szHTTPProxyServer:=NewValue;
        FWXViewSetNetWorkOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
        GetMem(FProxyServer,length(NewValue)+1);
        FProxyServer^:=NewValue;
     End;
End;

Function THTTPBrowser.GetSocksServer:String;
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     Result:='';
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
         If FSocksServer<>Nil Then Result:=FSocksServer^
         Else Result:='';
         exit;
     End;
     RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.szSocksServer;
End;

Procedure THTTPBrowser.SetSocksServer(NewValue:String);
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
         RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
         If RetErr<>WX_SUCCESS Then exit;
         Opts.szSocksServer:=NewValue;
         FWXViewSetNetWorkOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
         GetMem(FSocksServer,length(NewValue)+1);
         FSocksServer^:=NewValue;
     End;
End;

Function THTTPBrowser.GetGateway:THTTPGateway;
Var Opts:WXNETWORKOPTS;
    RetErr:LongInt;
Begin
     Result:=httpGatewayNone;
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
       If FGatewayAssigned Then Result:=FGateway
       Else Result:=httpGatewayNone;
       exit;
     End;
     RetErr:=FWXViewQueryNetWorkOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     Case Opts.wxGateway Of
        WXGATEWAY_PROXY:Result:=httpGatewayProxy;
        WXGATEWAY_SOCKS:Result:=httpGatewaySocks;
        WXGATEWAY_PROXY Or WXGATEWAY_SOCKS:Result:=httpGatewayProxySocks;
        Else Result:=httpGatewayNone;
     End;
End;

Procedure THTTPBrowser.SetGateway(NewValue:THTTPGateway);
Var gw:WXGATEWAY;
Begin
    If FDLLHandle=0 Then exit;
    If Handle<>0 Then
    Begin
       Case NewValue Of
          httpGatewayProxy:gw:=WXGATEWAY_PROXY;
          httpGatewaySocks:gw:=WXGATEWAY_SOCKS;
          httpGatewayProxySocks:gw:=WXGATEWAY_PROXY Or WXGATEWAY_SOCKS;
          Else gw:=WXGATEWAY_NONE;
       End;
       FWXViewEnableGateway(Handle,gw);
    End
    Else
    Begin
       FGatewayAssigned:=True;
       FGateway:=NewValue;
    End;
End;

Function THTTPBrowser.GetEnableCache:Boolean;
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     Result:=False;
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
        If FEnableCacheAssigned Then Result:=FEnableCache
        Else Result:=False;
        exit;
     End;
     RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.bEnabled;
End;

Procedure THTTPBrowser.SetEnableCache(NewValue:Boolean);
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
        RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.bEnabled:=NewValue;
        FWXViewSetCacheOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
        FEnableCacheAssigned:=True;
        FEnableCache:=NewValue;
     End;
End;

Function THTTPBrowser.GetCacheDocLimit:LongInt;
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     Result:=0;
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
        If FCacheDocLimitAssigned Then Result:=FCacheDocLimit
        Else Result:=0;
        exit;
     End;
     RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.lDocLimit;
End;

Procedure THTTPBrowser.SetCacheDocLimit(NewValue:LongInt);
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
        RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.lDocLimit:=NewValue;
        FWXViewSetCacheOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
        FCacheDocLimitAssigned:=True;
        FCacheDocLimit:=NewValue;
     End;
End;

Function THTTPBrowser.GetCacheImageLimit:LongInt;
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     Result:=0;
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
        If FCacheImageLimitAssigned Then Result:=FCacheImageLimit
        Else Result:=0;
        exit;
     End;
     RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.lImageLimit;
End;

Procedure THTTPBrowser.SetCacheImageLimit(NewValue:LongInt);
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
        RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.lImageLimit:=NewValue;
        FWXViewSetCacheOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
        FCacheImageLimitAssigned:=True;
        FCacheImageLimit:=NewValue;
     End;
End;

Function THTTPBrowser.GetCacheDir:String;
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     Result:='';
     If FDLLHandle=0 Then exit;
     If Handle=0 Then
     Begin
         If FCacheDir<>Nil Then Result:=FCacheDir^
         Else Result:='';
         exit;
     End;
     RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
     If RetErr<>WX_SUCCESS Then exit;
     result:=Opts.szCacheDir;
End;

Procedure THTTPBrowser.SetCacheDir(NewValue:String);
Var Opts:WXCACHEOPTS;
    RetErr:LongInt;
Begin
     If FDLLHandle=0 Then exit;
     If Handle<>0 Then
     Begin
        RetErr:=FWXViewQueryCacheOpts(Handle,Opts,sizeof(Opts));
        If RetErr<>WX_SUCCESS Then exit;
        Opts.szCacheDir:=NewValue;
        FWXViewSetCacheOpts(Handle,Opts,sizeof(Opts));
     End
     Else
     Begin
        GetMem(FCacheDir,length(NewValue)+1);
        FCacheDir^:=NewValue;
     End;
End;

Procedure THTTPBrowser.SetLoaded(NewValue:Boolean);
Begin
    If NewValue Then Load
    Else CancelLoad;
End;

Procedure THTTPBrowser.WXLoadResult(Var Msg:TMessage);
Var s:THTTPLoadStatus;
Begin
    FLoaded:=Msg.Param2=WX_SUCCESS;
    Case Msg.Param2 Of
       WX_SUCCESS:s:=httpLoadSuccess;
       WX_CANCELLED:s:=httpLoadCancelled;
       Else s:=httpLoadError;
    End;
    If FOnLoad<>Nil Then FOnLoad(Self,s);
    FLoadCancel:=True; //indicate message received
End;

Function THTTPBrowser.GetDocTitle:String;
Var C:CString;
Begin
    If ((FDLLHandle=0)Or(Handle=0)) Then exit;
    If FWXViewQueryDocTitle(Handle,@c,250)<>WX_SUCCESS Then Result:=''
    Else Result:=c;
End;

Function THTTPBrowser.GetAnchorDataLen(Const Pos:THTTPPos):LongWord;
Begin
    If ((FDLLHandle=0)Or(Handle=0)) Then exit;
    Result:=FWXViewQueryAnchorDataLen(Handle,Pos);
End;

Function THTTPBrowser.GetAnchorData(Const Pos:THTTPPos;Var Buf;BufLen:LongWord):Boolean;
Begin
    If ((FDLLHandle=0)Or(Handle=0)) Then exit;
    Result:=FWXViewQueryAnchorData(Handle,Pos,Buf,BufLen)=WX_SUCCESS;
End;

Function THTTPBrowser.GetAnchor(Const Pos:THTTPPos):String;
Var c:CString;
Begin
    If ((FDLLHandle=0)Or(Handle=0)) Then exit;
    If FWXViewQueryAnchor(Handle,Pos,@c,250)=WX_SUCCESS Then Result:=c
    Else Result:='';
End;

Procedure THTTPBrowser.WXButtonClick(Var Msg:TMessage);
Var BData:PWXBUTTONDATA;
    Pos:THTTPPos;
Begin
    BData:=Pointer(Msg.Param2);
    If BData<>Nil Then If BData^.usButtonNum=1 Then //only for left button
    Begin
         If FWXViewQueryPos(Handle,BData^.x,BData^.y,Pos)=WX_SUCCESS Then
           If FOnDocMouseClick<>Nil Then FOnDocMouseClick(Self,Pos);
    End;
End;

Procedure THTTPBrowser.WXMouseMove(Var Msg:TMessage);
Var MData:PWXMOUSEDATA;
    Pos:THTTPPos;
Begin
    MData:=Pointer(Msg.Param2);
    If MData<>Nil Then
    Begin
         If FWXViewQueryPos(Handle,MData^.x,MData^.y,Pos)=WX_SUCCESS Then
           If FOnDocMouseMove<>Nil Then FOnDocMouseMove(Self,Pos);
    End;
End;

Function THTTPBrowser.GetDocAnchor:String;
Var c:CString;
Begin
     Result:='';
     If ((FDLLHandle=0)Or(Handle=0)) Then exit;
     If FWXViewQueryDocAnchor(Handle,@c,250)=WX_SUCCESS Then Result:=C;
End;

Function THTTPBrowser.Search(Const s:String;Const StartPos:THTTPPos;Options:THTTPSearchOptions):THTTPPos;
Var Opt:LongWord;
    C:CString;
Begin
     If ((FDLLHandle=0)Or(Handle=0)) Then exit;
     C:=s;
     If Options=httpSearchBackward Then Opt:=WXSEARCH_BACKWARD
     Else Opt:=WXSEARCH_FORWARD;
     If FWXViewSearch(Handle,Opt,StartPos,Result,@C)<>WX_SUCCESS Then
       FillChar(Result,sizeof(Result),0);
End;

Function THTTPBrowser.GetIsLoading:Boolean;
Begin
    Result:=False;
    If ((FDLLHandle=0)Or(Handle=0)) Then exit;
    Result:=FWXViewIsLoading(Handle);
End;

Function THTTPBrowser.GetAnchorState(Const Anchor:String):THTTPAnchorState;
Var C:CString;
    S:LongWord;
Begin
     result:=httpAnchorDefault;
     If ((FDLLHandle=0)Or(Handle=0)) Then exit;
     C:=Anchor;
     If FWXViewQueryAnchorState(Handle,@C,s)=WX_SUCCESS Then
     Begin
         If s=WXANCHOR_VISITED Then Result:=httpAnchorVisited
         Else result:=httpAnchorDefault;
     End;
End;

Procedure THTTPBrowser.SetAnchorState(Const Anchor:String;NewValue:THTTPAnchorState);
Var S:LongWord;
    C:CString;
Begin
     If ((FDLLHandle=0)Or(Handle=0)) Then exit;
     C:=Anchor;
     If NewValue=httpAnchorVisited Then s:=WXANCHOR_VISITED
     Else s:=WXANCHOR_DEFAULT;
     FWXViewSetAnchorState(Handle,@C,s);
End;

Function THTTPBrowser.GetLastLoadError:LongInt;
Begin
     Result:=0;
     If ((FDLLHandle=0)Or(Handle=0)) Then exit;
     Result:=FWXViewQueryLastLoadError(Handle);
End;

Function THTTPBrowser.GetLastError:LongInt;
Begin
     Result:=0;
     If ((FDLLHandle=0)Or(Handle=0)) Then exit;
     Result:=FWXViewQueryLastError(Handle);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TFTP Class Implementation                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Type
   TFTPNotifyControl=Class(TControl)
      Private
         FFTP:TFTP;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure WMFTPUpdate(Var Msg:TMessage); message WM_FTPAPI_XFER_UPDATE;
   End;

Procedure TFTPNotifyControl.WMFTPUpdate(Var Msg:TMessage);
Begin
     If FFTP.OnTransferProgress<>Nil Then
      FFTP.OnTransferProgress(FFTP,Msg.Param1,Msg.Param2);
End;

Procedure TFTPNotifyControl.SetupComponent;
Begin
     Inherited SetupComponent;
     Include (ComponentState, csDetail);
End;

Procedure TFTPNotifyControl.CreateWnd; //dummy
Begin
     Inherited CreateWnd;
End;

Const
    FTPSERVICE    =1;    /* ftp: ftp/tcp: unknown service */
    FTPHOST       =2;    /* unknown host */
    FTPSOCKET     =3;    /* unable to obtain socket */
    FTPCONNECT    =4;    /* unable to connect to server */
    FTPLOGIN      =5;    /* login failed */
    FTPABORT      =6;    /* transfer aborted */
    FTPLOCALFILE  =7;    /* problem openning local file */
    FTPDATACONN   =8;    /* problem initializing data connection */
    FTPCOMMAND    =9;    /* command failed */
    FTPPROXYTHIRD =10;   /* proxy server does not support third party transfers */
    FTPNOPRIMARY  =11;   /* No primary connection for proxy transfer */
    FTPNOXLATETBL =12;   /* No code page translation table was loded */

    T_ASCII       =1;
    T_EBCDIC      =2;
    T_BINARY      =3;

    /* ping error codes */
    PINGREPLY     =-1;   /* host does not reply */
    PINGSOCKET    =-3;   /* unable to obtain socket */
    PINGPROTO     =-4;   /* unknown protcol ICMP */
    PINGSEND      =-5;   /* send failed */
    PINGRECV      =-6;   /* recv failed */
    PINGHOST      =-7;   /* can't resolve the host name */

Procedure TFTP.FTPError(Err:TFTPError);
Var Desc:String;
Begin
     Case Err Of
        ftpUnknownService:Desc:='Unknown service';
        ftpUnkownHost:Desc:='Unknown host';
        ftpSocketError:Desc:='Unable to obtain socket';
        ftpCannotConnect:Desc:='Unable to connect to server';
        ftpLoginFailed:Desc:='Login failed';
        ftpTransferAborted:Desc:='Transfer aborted';
        ftpCannotOpenFile:Desc:='Problem openning local file';
        ftpConnectionError:Desc:='Problem initializing data connection';
        fptCommandFailed:Desc:='Command failed';
        ftpProxyError:Desc:='Proxy server does not support third party transfers';
        ftpNoPrimaryProxy:Desc:='No primary connection for proxy transfer';
        ftpNoTranslateTable:Desc:='No code page translation table was loded';
        Else Desc:='Unkown FTP error';
     End; //case
     If FOnError<>Nil Then FOnError(Self,Err,Desc);
End;

Function TFTP.GetFTPError:TFTPError;
Var Value:LongInt;
Begin
  Value:=Fftp_errno;
  Case Value Of
    FTPSERVICE:Result:=ftpUnknownService;
    FTPHOST:Result:=ftpUnkownHost;
    FTPSOCKET:Result:=ftpSocketError;
    FTPCONNECT:Result:=ftpCannotConnect;
    FTPLOGIN:Result:=ftpLoginFailed;
    FTPABORT:Result:=ftpTransferAborted;
    FTPLOCALFILE:Result:=ftpCannotOpenFile;
    FTPDATACONN:Result:=ftpConnectionError;
    FTPCOMMAND:Result:=fptCommandFailed;
    FTPPROXYTHIRD:Result:=ftpProxyError;
    FTPNOPRIMARY:Result:=ftpNoPrimaryProxy;
    FTPNOXLATETBL:Result:=ftpNoTranslateTable;
    Else Result:=ftpOther;
  End;
End;

Function TFTP.GetPassWord:String;
Begin
   If FPassWord<>Nil Then Result:=FPassWord^
   Else Result:='';
End;

Procedure TFTP.SetPassWord(NewValue:String);
Begin
   If FPassWord<>Nil Then FreeMem(FPassWord,length(FPassWord^)+1);
   GetMem(FPassWord,length(NewValue)+1);
   FPassWord^:=NewValue;
End;

Function TFTP.GetRemoteHost:String;
Begin
   If FRemoteHost<>Nil Then Result:=FRemoteHost^
   Else Result:='';
End;

Procedure TFTP.SetRemoteHost(NewValue:String);
Begin
   If FRemoteHost<>Nil Then FreeMem(FRemoteHost,length(FRemoteHost^)+1);
   GetMem(FRemoteHost,length(NewValue)+1);
   FRemoteHost^:=NewValue;
End;

Function TFTP.GetRemoteAccount:String;
Begin
   If FRemoteAccount<>Nil Then Result:=FRemoteAccount^
   Else Result:='';
End;

Procedure TFTP.SetRemoteAccount(NewValue:String);
Begin
   If FRemoteAccount<>Nil Then FreeMem(FRemoteAccount,length(FRemoteAccount^)+1);
   GetMem(FRemoteAccount,length(NewValue)+1);
   FRemoteAccount^:=NewValue;
End;

Function TFTP.GetUserID:String;
Begin
    If FUserId<>Nil Then Result:=FUserId^
    Else Result:='';
End;

Procedure TFTP.SetUserID(NewValue:String);
Begin
    If FUserId<>Nil Then FreeMem(FUserId,length(FUserId^)+1);
    GetMem(FUserId,length(NewValue)+1);
    FUserId^:=NewValue;
End;

Procedure TFTP.SetupComponent;
Var DLLName:CString;
{$IFDEF OS2}
    C : cString;
{$ENDIF}

Begin
   Inherited SetupComponent;

   RemoteHost:='127.0.0.1';
   TransferMode:=ftpBinary;

   DllName:='FTPAPI';

   {$IFDEF OS2}
   If DosLoadModule(C,255,DllName,FDllHandle)<>0 Then
   Begin
        FDLLHandle:=0;
        If ComponentState * [csWriting,csDesigning] = [] Then
        Begin
           If ApplicationType=cApplicationType_GUI
             Then ErrorBox('DLL not found: FTPAPI.DLL !')
             Else Writeln('DLL not found: FTPAPI.DLL !');
        End;
        Exit;
   End;
   {$ENDIF}
   {$IFDEF WIN32}
   If ComponentState * [csWriting,csDesigning] = []
     Then ErrorBox('TFTP currently not supported for Win32 !');
   Exit;
   {$ENDIF}
   Try
      Fftplogoff:=Pointer(GetProcAddr(FDllHandle,'FTPLOGOFF'));
      Fftpget:=Pointer(GetProcAddr(FDllHandle,'FTPGET'));
      Fftpput:=Pointer(GetProcAddr(FDllHandle,'FTPPUT'));
      Fftpappend:=Pointer(GetProcAddr(FDllHandle,'FTPAPPEND'));
      Fftpputunique:=(GetProcAddr(FDllHandle,'FTPPUTUNIQUE'));
      Fftpcd:=(GetProcAddr(FDllHandle,'FTPCD'));
      Fftpmkd:=(GetProcAddr(FDllHandle,'FTPMKD'));
      Fftprmd:=(GetProcAddr(FDllHandle,'FTPRMD'));
      Fftpdelete:=(GetProcAddr(FDllHandle,'FTPDELETE'));
      Fftprename:=(GetProcAddr(FDllHandle,'FTPRENAME'));
      Fftpls:=(GetProcAddr(FDllHandle,'FTPLS'));
      Fftpdir:=(GetProcAddr(FDllHandle,'FTPDIR'));
      Fftpquote:=(GetProcAddr(FDllHandle,'FTPQUOTE'));
      Fftpping:=(GetProcAddr(FDllHandle,'FTPPING'));
      Fftppwd:=(GetProcAddr(FDllHandle,'FTPPWD'));
      Fftpsys:=(GetProcAddr(FDllHandle,'FTPSYS'));
      Fftpver:=(GetProcAddr(FDllHandle,'FTPVER'));
{      FftpWindow:=(GetProcAddr(FDllHandle,'FTPWINDOW')); }    { WD }
      FftpWindow:=(GetProcAddr(FDllHandle,'FTPXFERWND'));      { WD }

      Fftp_errno:=(GetProcAddr(FDllHandle,'FTP_ERRNO'));

      If ApplicationType=cApplicationType_GUI Then
      Begin
         FNotifyControl:=TFTPNotifyControl.Create(Self);
         TFTPNotifyControl(FNotifyControl).FFTP:=Self;
         TFTPNotifyControl(FNotifyControl).CreateWnd;
      End;

      If FNotifyControl<>Nil Then FftpWindow(FNotifyControl.Handle);  //start FTP services
   Except
      {$IFDEF OS2}
      DosFreeModule(FDLLHandle);
      {$ENDIF}
      FDLLHandle:=0;
      ON E:EProcAddrError Do
      Begin
         If ComponentState * [csWriting,csDesigning] = [] Then
         Begin
           If ApplicationType=cApplicationType_GUI Then ErrorBox('Cannot retrieve procedure from FTPAPI:'+E.Message+' !')
           Else Writeln('Cannot retrieve procedure from FTPAPI:'+E.Message+' !');
         End;
      End;
      Else Raise;
   End;
End;

Function TFTP.GetRemoteDirName:String;
Var C:CString;
    HK: Byte;
Begin
  Result:='';
  If FDLLHandle=0 Then
    exit
  Else
    If not FConnected Then
      exit
    Else
      Begin
        If Fftppwd(RemoteHost,UserId,Password,RemoteAccount,C,250)=0 Then
          Begin
            Result:=C;
            HK:=pos('"', Result)+1;
            if HK>0 then  // Das Verzeichnis steht unter Hochkomma
              Begin
                Result:=copy(Result, HK, 255);
                HK:=Pos('"', Result)-1;
                Result:=copy(Result, 1, HK);
              End;
          End
        Else
          Begin
            Result:='';
            FTPError(GetFTPError);
          End;
      End;
End;

Procedure TFTP.SetRemoteDirName(NewValue:String);
Begin
    If FDLLHandle=0 Then exit
    Else If not Connected Then
    Begin
        FTPError(ftpNotConnected);
        exit;
    End
    Else
    Begin
        If Fftpcd(RemoteHost,UserId,Password,RemoteAccount,NewValue)<>0 Then
          FTPError(GetFTPError);
    End;
End;

Procedure SystemAssign(Var f:File;Const Name:String);
Begin
    System.Assign(f,Name);
End;

Function TFTP.GetRemoteDir(Const Pattern:String;Dir:TStrings;Options:TFTPDirOptions):TFTPError;
Var Res          : LongInt;
    TempFile,s   : String;
    TmpFileStream: tFileStream;

    f:TEXT;
Begin
  If FDLLHandle=0 Then Result:=ftpOther
  Else If not Connected Then Result:=ftpNotConnected
  Else
    Begin
      TempFile:=GetTempFileName;
      Dir.Clear;
      If Options=ftpDirShort
        then Res:=Fftpls(RemoteHost,UserId,Password,RemoteAccount,TempFile,Pattern)
        else Res:=Fftpdir(RemoteHost,UserId,Password,RemoteAccount,TempFile,Pattern);
      If Res=0
        then
          Begin
            Result:=ftpOk;
            TmpFileStream.Create(TempFile, Stream_Open);
            while not TmpFileStream.EndOfData do
              Dir.Add(TmpFileStream.Readln);
            TmpFileStream.Destroy;
          End
        else Result:=GetFTPError;
      DeleteFile(TempFile);
    End;
  If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.Connect:TFTPError;
Begin
   If FDLLHandle=0 Then Result:=ftpOther
   Else If Connected Then Result:=ftpOk
   Else
   Begin
      If Fftpcd(RemoteHost,UserId,Password,RemoteAccount,'.')<>0 Then Result:=GetFTPError
      Else Result:=ftpOk;
      FConnected:=Result=ftpOk;
   End;
   If Result<>ftpOk Then FTPError(Result);
End;

Procedure TFTP.Disconnect;
Begin
    If not FConnected Then exit;
    If FDLLHandle=0 Then exit;
    FConnected:=False;
End;

Procedure TFTP.SetConnected(NewValue:Boolean);
Begin
     If NewValue Then Connect
     Else Disconnect;
End;

Destructor TFTP.Destroy;
Begin
    Disconnect;
    If FPassWord<>Nil Then FreeMem(FPassWord,length(FPassWord^)+1);
    If FRemoteHost<>Nil Then FreeMem(FRemoteHost,length(FRemoteHost^)+1);
    If FRemoteAccount<>Nil Then FreeMem(FRemoteAccount,length(FRemoteAccount^)+1);
    If FUserId<>Nil Then FreeMem(FUserId,length(FUserId^)+1);
    If FNotifyControl<>Nil Then FNotifyControl.Destroy;
    FNotifyControl:=Nil;
    If FDllHandle<>0 Then
    Begin
       {$IFDEF OS2}
       DosFreeModule(FDLLHandle);
       {$ENDIF}
       FDLLHandle:=0;
    End;
    Inherited Destroy;
End;

Function TFTP.GetVersion:String;
Var C:CString;
Begin
     If FDLLHandle=0 Then exit;
     Fftpver(C,250);
     Result:=C;
End;

Function TFTP.DeleteRemoteFile(Const FileName:String):TFTPError;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If FftpDelete(RemoteHost,UserId,Password,RemoteAccount,FileName)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.RenameRemoteFile(Const OldName,NewName:String):TFTPError;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If FftpRename(RemoteHost,UserId,Password,RemoteAccount,OldName,NewName)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.MakeRemoteDir(Const DirName:String):TFTPError;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If Fftpmkd(RemoteHost,UserId,Password,RemoteAccount,DirName)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.RemoveRemoteDir(Const DirName:String):TFTPError;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If Fftprmd(RemoteHost,UserId,Password,RemoteAccount,DirName)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.AppendToRemoteFile(Const RemoteFileName,LocalFileName:String):TFTPError;
Var tt:LongInt;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If TransferMode=ftpAscii Then tt:=T_ASCII
          Else tt:=T_BINARY;
          If Fftpappend(RemoteHost,UserId,Password,RemoteAccount,
                        LocalFileName,RemoteFileName,tt)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.GetRemoteFile(Const RemoteFileName,LocalFileName:String):TFTPError;
Var tt:LongInt;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If TransferMode=ftpAscii Then tt:=T_ASCII
          Else tt:=T_BINARY;
          If Fftpget(RemoteHost,UserId,Password,RemoteAccount,
                     LocalFileName,RemoteFileName,'w',tt)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.PutLocalFile(Const LocalFileName,RemoteFileName:String):TFTPError;
Var tt:LongInt;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If TransferMode=ftpAscii Then tt:=T_ASCII
          Else tt:=T_BINARY;
          If Fftpput(RemoteHost,UserId,Password,RemoteAccount,
                    LocalFileName,RemoteFileName,tt)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.PutUniqueLocalFile(Const LocalFileName,RemoteFileName:String):TFTPError;
Var tt:LongInt;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If TransferMode=ftpAscii Then tt:=T_ASCII
          Else tt:=T_BINARY;
          If Fftpputunique(RemoteHost,UserId,Password,RemoteAccount,
                           LocalFileName,RemoteFileName,tt)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.Quote(Const ftpstring:String):TFTPError;
Begin
     If FDLLHandle=0 Then Result:=ftpOther
     Else If not Connected Then Result:=ftpNotConnected
     Else
     Begin
          If Fftpquote(RemoteHost,UserId,Password,RemoteAccount,ftpString)=0 Then Result:=ftpOk
          Else Result:=GetFTPError;
     End;
     If Result<>ftpOk Then FTPError(Result);
End;

Function TFTP.GetSystem:String;
Var C:CString;
Begin
     If FDLLHandle=0 Then Result:=''
     Else If not Connected Then
     Begin
          Result:='';
          FTPError(ftpNotConnected);
     End
     Else
     Begin
          If Fftpsys(RemoteHost,UserId,Password,RemoteAccount,C,250)=0 Then Result:=C
          Else
          Begin
               Result:='';
               FTPError(GetFTPError);
          End;
     End;
End;

Function TFTP.Ping(Const HostName:String;PacketLen:LongInt;
                   Var Address:LongWord;Var Milliseconds:LongInt):TFTPPingResult;
Begin
     If FDLLHandle=0 Then Result:=ftpPingOther
     Else
     Begin
         Milliseconds:=FftpPing(HostName,PacketLen,Address);
         If Milliseconds<0 Then
         Begin
            Case Milliseconds Of
               PINGREPLY:Result:=ftpPingHostDoesNotReply;
               PINGSOCKET:Result:=ftpPingSocketError;
               PINGPROTO:Result:=ftpPingUnkownProtocol;
               PINGSEND:Result:=ftpPingSendFailed;
               PINGRECV:Result:=ftpPingReceiveFailed;
               PINGHOST:Result:=ftpPingUnkownHost;
               Else Result:=ftpPingOther;
            End; //case
         End
         Else Result:=ftpPingOk;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TTCP Class Implementation                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
    INADDR_ANY              =$00000000;

     /* Address families. */
Const
     AF_UNSPEC       =0;               /* unspecified */
     AF_UNIX         =1;               /* local to host (pipes, portals) */
     AF_INET         =2;               /* internetwork: UDP, TCP, etc. */
     AF_IMPLINK      =3;               /* arpanet imp addresses */
     AF_PUP          =4;               /* pup protocols: e.g. BSP */
     AF_CHAOS        =5;               /* mit CHAOS protocols */
     AF_NS           =6;               /* XEROX NS protocols */
     AF_NBS          =7;               /* nbs protocols */
     AF_ECMA         =8;               /* european computer manufacturers */
     AF_DATAKIT      =9;               /* datakit protocols */
     AF_CCITT        =10;              /* CCITT protocols, X.25 etc */
     AF_SNA          =11;              /* IBM SNA */
     AF_DECnet       =12;              /* DECnet */
     AF_DLI          =13;              /* Direct data link interface */
     AF_LAT          =14;              /* LAT */
     AF_HYLINK       =15;              /* NSC Hyperchannel */
     AF_APPLETALK    =16;              /* Apple Talk */

     AF_MAX          =17;

    /* Protocol families, same as address families for now. */
Const
     PF_UNSPEC       =AF_UNSPEC;
     PF_UNIX         =AF_UNIX;
     PF_INET         =AF_INET;
     PF_IMPLINK      =AF_IMPLINK;
     PF_PUP          =AF_PUP;
     PF_CHAOS        =AF_CHAOS;
     PF_NS           =AF_NS;
     PF_NBS          =AF_NBS;
     PF_ECMA         =AF_ECMA;
     PF_DATAKIT      =AF_DATAKIT;
     PF_CCITT        =AF_CCITT;
     PF_SNA          =AF_SNA;
     PF_DECnet       =AF_DECnet;
     PF_DLI          =AF_DLI;
     PF_LAT          =AF_LAT;
     PF_HYLINK       =AF_HYLINK;
     PF_APPLETALK    =AF_APPLETALK;

     PF_MAX          =AF_MAX;

Const
     SOCK_STREAM     =1;               /* stream socket */
     SOCK_DGRAM      =2;               /* datagram socket */
     SOCK_RAW        =3;               /* raw-protocol interface */
     SOCK_RDM        =4;               /* reliably-delivered message */
     SOCK_SEQPACKET  =5;               /* sequenced packet stream */

     MSG_PEEK        =2;

Type
    sockaddr=Record
                   sa_family:WORD;              /* address family */
                   sa_data:CSTRING[13];         /* up to 14 bytes of direct address */
    End;

    hostent=Record
       h_name:PChar;             /* official name of host */
       h_aliases:PpCharArray;     /* alias list */
       h_addrtype:LongInt;       /* host address type */
       h_length:LongInt;         /* length of address */
       h_addr_list:PpCharArray;   /* list of addresses from name server */
       //h_addr  h_addr_list[0]  /* address, for backward compatiblity */
    End;
    phostent=^hostent;

    in_addr=Record
       s_addr:LongWord;
    End;

    sockaddr_in=Record
        sin_family:SmallInt;
        sin_port:Word;
        sin_addr:in_addr;
        sin_zero:Array[0..7] Of Char;
    End;


Procedure TTCP.SetupComponent;
Var DLLName:CString;
{$IFDEF OS2}
    C : cString;
{$ENDIF}
Begin
   Inherited SetupComponent;

   LocalPort:=1024;
   LocalAddress:=INADDR_ANY;
   QueueLength:=1;
   FSockMode:=SOCK_STREAM;
   FState:=sckClosed;

   DllName:='SO32DLL';
   {$IFDEF OS2}
   If DosLoadModule(C,255,DllName,FDllHandle)<>0 Then
   Begin
        FDLLHandle:=0;
        If ComponentState * [csWriting,csDesigning] = [] Then
        Begin
          If ApplicationType=cApplicationType_GUI Then ErrorBox('DLL not found: SO32DLL.DLL !')
          Else Writeln('DLL not found: SO32DLL.DLL !');
        End;
        Exit;
   End;
   DllName:='TCP32DLL';
   If DosLoadModule(C,255,DllName,FTCPDllHandle)<>0 Then
   Begin
        {$IFDEF OS2}
        DosFreeModule(FDLLHandle);
        {$ENDIF}
        FDLLHandle:=0;
        FTCPDLLHandle:=0;
        If ComponentState * [csWriting,csDesigning] = [] Then
        Begin
          If ApplicationType=cApplicationType_GUI
            Then ErrorBox('DLL not found: TCP32DLL.DLL !')
            Else Writeln('DLL not found: TCP32DLL.DLL !');
        End;
        Exit;
   End;
   {$ENDIF}
   {$IFDEF WIN32}
   If ComponentState * [csWriting,csDesigning] = []
     Then ErrorBox('TTCP currently not supported for Win32 !');
   Exit;
   {$ENDIF}
   Try
      FAccept:=Pointer(GetProcAddr(FDllHandle,'ACCEPT'));
      FSock_Init:=Pointer(GetProcAddr(FDllHandle,'SOCK_INIT'));
      FSoClose:=Pointer(GetProcAddr(FDllHandle,'SOCLOSE'));
      FBind:=Pointer(GetProcAddr(FDllHandle,'BIND'));
      FConnect:=Pointer(GetProcAddr(FDllHandle,'CONNECT'));
      FGethostid:=Pointer(GetProcAddr(FDllHandle,'GETHOSTID'));
      FGetpeername:=Pointer(GetProcAddr(FDllHandle,'GETPEERNAME'));
      FGetsockname:=Pointer(GetProcAddr(FDllHandle,'GETSOCKNAME'));
      FGetsockopt:=Pointer(GetProcAddr(FDllHandle,'GETSOCKOPT'));
      Fioctl:=Pointer(GetProcAddr(FDllHandle,'IOCTL'));
      FListen:=Pointer(GetProcAddr(FDllHandle,'LISTEN'));
      Frecvmsg:=Pointer(GetProcAddr(FDllHandle,'RECVMSG'));
      Frecv:=Pointer(GetProcAddr(FDllHandle,'RECV'));
      Frecvfrom:=Pointer(GetProcAddr(FDllHandle,'RECVFROM'));
      Fselect:=Pointer(GetProcAddr(FDllHandle,'SELECT'));
      Fsend:=Pointer(GetProcAddr(FDllHandle,'SEND'));
      Fsendmsg:=Pointer(GetProcAddr(FDllHandle,'SENDMSG'));
      Fsendto:=Pointer(GetProcAddr(FDllHandle,'SENDTO'));
      Fsetsockopt:=Pointer(GetProcAddr(FDllHandle,'SETSOCKOPT'));
      Fsock_errno:=Pointer(GetProcAddr(FDllHandle,'SOCK_ERRNO'));
      Fpsock_errno:=Pointer(GetProcAddr(FDllHandle,'PSOCK_ERRNO'));
      FSocket:=Pointer(GetProcAddr(FDllHandle,'SOCKET'));
      Fsoabort:=Pointer(GetProcAddr(FDllHandle,'SOABORT'));
      Fso_cancel:=Pointer(GetProcAddr(FDllHandle,'SO_CANCEL'));
      Freadv:=Pointer(GetProcAddr(FDllHandle,'READV'));
      Fwritev:=Pointer(GetProcAddr(FDllHandle,'WRITEV'));
      Fshutdown:=Pointer(GetProcAddr(FDllHandle,'SHUTDOWN'));
      Fgetinetversion:=Pointer(GetProcAddr(FDllHandle,'GETINETVERSION'));

      FINet_Addr:=Pointer(GetProcAddr(FTCPDllHandle,'INET_ADDR'));
      Fgethostbyname:=Pointer(GetProcAddr(FTCPDllHandle,'GETHOSTBYNAME'));
      FBswap:=Pointer(GetProcAddr(FTCPDllHandle,'BSWAP'));
      Fgethostname:=Pointer(GetProcAddr(FTCPDllHandle,'GETHOSTNAME'));

      FSock_Init;
   Except
      {$IFDEF OS2}
      DosFreeModule(FDLLHandle);
      {$ENDIF}
      FDLLHandle:=0;
      {$IFDEF OS2}
      DosFreeModule(FTCPDLLHandle);
      {$ENDIF}
      FTCPDLLHandle:=0;
      ON E:EProcAddrError Do
      Begin
         If ComponentState * [csWriting,csDesigning] = [] Then
         Begin
           If ApplicationType=cApplicationType_GUI 
             Then ErrorBox('Cannot retrieve procedure from SO32DLL or TCP32DLL:'+E.Message+' !')
             Else Writeln('Cannot retrieve procedure from SO32DLL or TCP32DLL:'+E.Message+' !');
         End;
      End;
      Else Raise;
   End;
End;

Procedure TTCP.Close;
Begin
    If FDLLHandle<>0 Then
    Begin
        If FInSocket<>0 Then FSoClose(FInSocket);
        FInSocket:=0;
        If FOutSocket<>0 Then FSoClose(FOutSocket);
        FOutSocket:=0;
        If FAcceptSocket<>0 Then FSoClose(FAcceptSocket);
        FAcceptSocket:=0;
    End;
    FConnected:=False;
    FState:=sckClosed;
End;

Destructor TTCP.Destroy;
Begin
    Close;

    If FDllHandle<>0 Then
    Begin
       {$IFDEF OS2}
       DosFreeModule(FDLLHandle);
       {$ENDIF}
       FDLLHandle:=0;
    End;
    If FTCPDllHandle<>0 Then
    Begin
       {$IFDEF OS2}
       DosFreeModule(FTCPDLLHandle);
       {$ENDIF}
       FTCPDLLHandle:=0;
    End;
    Inherited Destroy;
End;

Procedure TTCP.Listen; //Server starts this to listen for connection requests
Var Server,Server1:sockaddr_in;
    nameLen:LongInt;
Begin
    If FDllHandle=0 Then exit;

    If FInSocket=0 Then
    Begin
       /* Request a socket */
       FInSocket:=Fsocket(PF_INET, FSockMode, 0);
       If FInSocket<0 Then //Error
       Begin
          FErrorCode:=Fsock_errno;
          TCPError(FErrorCode);
          exit;
       End
       Else FErrorCode:=0;

       /* Bind the socket to the server address.*/
       FillChar(Server,sizeof(Server),0);
       Server.sin_family := AF_INET;
       Server.sin_port   := FBswap(LocalPort);
       Server.sin_addr.s_addr := LocalAddress;

       If Fbind(FInSocket,Server,sizeof(Server)) < 0 Then
       Begin //Error
          FErrorCode:=Fsock_errno;
          TCPError(FErrorCode);
          exit;
       End
       Else
       Begin
          FErrorCode:=0;
          //Find out what port is really assigned
          FillChar(Server1,sizeof(Server1),0);
          NameLen:=sizeof(Server1);
          If FGetSockName(FOutSocket,Server1,NameLen)=0 Then
            FLocalPort:=Fbswap(server1.sin_port);
       End;
    End;

    /* Listen for connections */
    FState:=sckListening;
    If Flisten(FInSocket,QueueLength)<>0 Then //Error
    Begin
        FErrorCode:=Fsock_errno;
        TCPError(FErrorCode);
        exit;
    End
    Else FErrorCode:=0;

    //Listen returns if connection attempt is made by client
End;

Function TTCP.INetAddressFromName(Const Name:String):LongWord;
Begin
    If FDLLHandle=0 Then exit;
    Result:=FINet_Addr(Name);
End;

Procedure TTCP.Connect(Const RemoteHost:String;RemotePort:LongInt);
Var hostnm:phostent;
    Server:sockaddr_in;
    IP:LongWord;
Type PLong=^LongWord;
Begin //Client starts this to connect to a server
    hostnm := Fgethostbyname(RemoteHost);
    If hostnm=Nil Then IP:=Finet_addr(RemoteHost)
    Else IP:=PLong(hostnm^.h_addr_list^[0])^;

    FillChar(Server,sizeof(Server),0);
    server.sin_family      := AF_INET;
    server.sin_port        := FBswap(RemotePort);
    server.sin_addr.s_addr := IP;

    If FOutSocket=0 Then
    Begin
         /* Get a stream socket. */
         FOutSocket := Fsocket(PF_INET, FSockMode, 0);
         If FOutSocket<0 Then //Error
         Begin
            FErrorCode:=Fsock_errno;
            TCPError(FErrorCode);
            FState:=sckError;
            exit;
         End
         Else FErrorCode:=0;
    End;

    /* Connect to the server. */
    If FConnect(FOutSocket,server,sizeof(server)) < 0 Then
    Begin //Error
        FErrorCode:=Fsock_errno;
        FState:=sckError;
        TCPError(FErrorCode);
        exit;
    End
    Else
    Begin
         FErrorCode:=0;
         If FOnConnect<>Nil Then FOnConnect(Self);
         FConnected:=True;
         FState:=sckConnected;
    End;
End;

Function TTCP.GetLocalHostName:String;
Var C:CString;
Begin
     If FDllHandle=0 Then exit;
     If Fgethostname(C,255)=0 Then Result:=C
     Else Result:='';
End;

Function TTCP.GetLocalIP:String;
Var l:LongWord;
Begin
     If FDllHandle=0 Then exit;
     l:=Fgethostid;
     Result:=tostr(l And 255);
     l:=l SHR 8;
     Result:=tostr(l And 255)+'.'+Result;
     l:=l SHR 8;
     Result:=tostr(l And 255)+'.'+Result;
     l:=l SHR 8;
     Result:=tostr(l And 255)+'.'+Result;
End;

Function TTCP.GetLocalPort:LongInt;
Begin
     Result:=FLocalPort;
End;

Procedure TTCP.SetLocalPort(NewValue:LongInt);
Begin
     FLocalPort:=NewValue;
End;

Procedure TTCP.Accept(Var PortID:LongInt;Var IP:String);
Var Client:sockaddr_in;
    NameLen:LongInt;
    l:LongWord;
Begin
     If FDllHandle=0 Then exit;
     If FAcceptSocket<>0 Then FSoClose(FAcceptSocket);
     FAcceptSocket:=0;
     Namelen:=sizeof(Client);
     FillChar(Client,sizeof(Client),0);
     FAcceptSocket:=Faccept(FInSocket,client,namelen);
     If FAcceptSocket=-1 Then //Error
     Begin
        FErrorCode:=Fsock_errno;
        PortID:=0;
        IP:='';
        TCPError(FErrorCode);
        FState:=sckError;
        exit;
     End
     Else
     Begin
         FErrorCode:=0;
         PortID:=Client.sin_port;
         l:=Client.sin_addr.s_addr;
         IP:=tostr(l And 255);
         l:=l SHR 8;
         IP:=IP+'.'+tostr(l And 255);
         l:=l SHR 8;
         IP:=IP+'.'+tostr(l And 255);
         l:=l SHR 8;
         IP:=IP+'.'+tostr(l And 255);
         If FOnConnectionRequest<>Nil Then FOnConnectionRequest(Self,PortId,IP);
         FConnected:=True;
         FState:=sckConnected;
     End;
End;

Procedure TTCP.SendData(Var Buf;BufLen:LongInt);
Var s:LongWord;
Begin
     If FDLLHandle=0 Then exit;
     If FAcceptSocket<>0 Then s:=FAcceptSocket
     Else If FOutSocket<>0 Then s:=FOutSocket
     Else s:=FInSocket;

     If Fsend(s,Buf,BufLen,0) < 0 Then //Error
     Begin
        FErrorCode:=Fsock_errno;
        TCPError(FErrorCode);
        exit;
     End
     Else
     Begin
          FErrorCode:=0;
          If FOnSendComplete<>Nil Then FOnSendComplete(Self);
     End;
End;

Procedure TTCP.GetData(Var Buf;MaxLen:LongInt;Var Received:LongInt);
Var s:LongWord;
Begin
     If FDLLHandle=0 Then exit;
     If FAcceptSocket<>0 Then s:=FAcceptSocket
     Else If FOutSocket<>0 Then s:=FOutSocket
     Else s:=FInSocket;

     Received:=Frecv(s,Buf,MaxLen,0);
     If Received = -1 Then
     Begin //Error
        FErrorCode:=Fsock_errno;
        TCPError(FErrorCode);
        exit;
     End
     Else FErrorCode:=0;
End;

Procedure TTCP.PeekData(Var Buf;MaxLen:LongInt;Var Received:LongInt);
Var s:LongWord;
Begin
     If FDLLHandle=0 Then exit;
     If FAcceptSocket<>0 Then s:=FAcceptSocket
     Else If FOutSocket<>0 Then s:=FOutSocket
     Else s:=FInSocket;

     Received:=Frecv(s,Buf,MaxLen,MSG_PEEK);
     If Received = -1 Then
     Begin //Error
        FErrorCode:=Fsock_errno;
        TCPError(FErrorCode);
        exit;
     End
     Else FErrorCode:=0;
End;

Procedure TTCP.TCPError(Code:LongInt);
Var s:String;
Begin
     Case Code Of
        SOCEPERM:s:='Not owner';
        SOCESRCH:s:='No such process';
        SOCEINTR:s:='Interrupted system call';
        SOCENXIO:s:='No such device or address';
        SOCEBADF:s:='Bad file number';
        SOCEACCES:s:='Permission denied';
        SOCEFAULT:s:='Bad address';
        SOCEINVAL:s:='Invalid argument';
        SOCEMFILE:s:='Too many open files';
        SOCEPIPE:s:='Broken pipe';
        SOCEOS2ERR:s:='OS/2 Error';
        SOCEWOULDBLOCK:s:='Operation would block';
        SOCEINPROGRESS:s:='Operation now in progress';
        SOCEALREADY:s:='Operation already in progress';
        SOCENOTSOCK:s:='Socket operation on non-socket';
        SOCEDESTADDRREQ:s:='Destination address required';
        SOCEMSGSIZE:s:='Message too long';
        SOCEPROTOTYPE:s:='Protocol wrong type for socket';
        SOCENOPROTOOPT:s:='Protocol not available';
        SOCEPROTONOSUPPORT:s:='Protocol not supported';
        SOCESOCKTNOSUPPORT:s:='Socket type not supported';
        SOCEOPNOTSUPP:s:='Operation not supported on socket';
        SOCEPFNOSUPPORT:s:='Protocol family not supported';
        SOCEAFNOSUPPORT:s:='Address family not supported by protocol family';
        SOCEADDRINUSE:s:='Address already in use';
        SOCEADDRNOTAVAIL:s:='Can'#39't assign requested address';
        SOCENETDOWN:s:='Network is down';
        SOCENETUNREACH:s:='Network is unreachable';
        SOCENETRESET:s:='Network dropped connection on reset';
        SOCECONNABORTED:s:='Software caused connection abort';
        SOCECONNRESET:s:='Connection reset by peer';
        SOCENOBUFS:s:='No buffer space available';
        SOCEISCONN:s:='Socket is already connected';
        SOCENOTCONN:s:='Socket is not connected';
        SOCESHUTDOWN:s:='Can'#39't send after socket shutdown';
        SOCETOOMANYREFS:s:='Too many references: can'#39't splice';
        SOCETIMEDOUT:s:='Connection timed out';
        SOCECONNREFUSED:s:='Connection refused';
        SOCELOOP:s:='Too many levels of symbolic links';
        SOCENAMETOOLONG:s:='File name too long';
        SOCEHOSTDOWN:s:='Host is down';
        SOCEHOSTUNREACH:s:='No route to host';
        SOCENOTEMPTY:s:='Directory not empty';
        Else s:='Unkown error';
     End; //case
     If FOnError<>Nil Then FOnError(Self,Code,s);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TUDP Class Implementation                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TUDP.SetupComponent;
Begin
   Inherited SetupComponent;
   FSockMode:=SOCK_DGRAM;
End;

Procedure TUDP.SendTo(Const RemoteHost:String;RemotePort:LongInt;
                      Var Buf;BufLen:LongInt);
Var server:sockaddr_in;
    s:LongWord;
Begin
     If FDllHandle=0 Then exit;
     server.sin_family      := AF_INET;
     server.sin_port        := FBswap(RemotePort);
     server.sin_addr.s_addr := Finet_addr(RemoteHost);

     If FAcceptSocket<>0 Then s:=FAcceptSocket
     Else If FOutSocket<>0 Then s:=FOutSocket
     Else If FInSocket<>0 Then s:=FInSocket
     Else
     Begin
          FOutSocket := Fsocket(PF_INET, FSockMode, 0);
          If FOutSocket<0 Then //Error
          Begin
             FErrorCode:=Fsock_errno;
             TCPError(FErrorCode);
             exit;
          End
          Else FErrorCode:=0;
          s:=FOutSocket;
     End;
     If FSendTo(s,Buf,BufLen,0,Server,Sizeof(Server))=0 Then FErrorCode:=0
     Else
     Begin
          FErrorCode:=Fsock_errno;
          TCPError(FErrorCode);
     End;
End;

Procedure TUDP.ReceiveFrom(Const RemoteHost:String;RemotePort:LongInt;
                           Var Buf;BufLen:LongWord);
Var server:sockaddr_in;
    s:LongWord;
    NameLen:LongInt;
Begin
     If FDllHandle=0 Then exit;
     server.sin_family      := AF_INET;
     server.sin_port        := FBswap(RemotePort);
     server.sin_addr.s_addr := Finet_addr(RemoteHost);

     If FAcceptSocket<>0 Then s:=FAcceptSocket
     Else If FInSocket<>0 Then s:=FInSocket
     Else If FOutSocket<>0 Then s:=FOutSocket
     Else
     Begin
          FInSocket := Fsocket(PF_INET, FSockMode, 0);
          If FInSocket<0 Then //Error
          Begin
             FErrorCode:=Fsock_errno;
             TCPError(FErrorCode);
             exit;
          End
          Else FErrorCode:=0;
          s:=FInSocket;
     End;
     NameLen:=sizeof(Server);
     If Frecvfrom(s,Buf,BufLen,0,Server,NameLen)=0 Then FErrorCode:=0
     Else
     Begin
          FErrorCode:=Fsock_errno;
          TCPError(FErrorCode);
     End;

End;

Initialization
   RegisterClasses([THTTPBrowser,TFTP,TUDP,TTCP]);
End.

{ -- date --  -- from -- -- changes ----------------------------------------------
  16-Aug-97   J”rg       Fehler in WebExWin-Records gefixt. Alle Strukturen mit
                         CSTRING[...STRING] waren falsch bersetzt. Jeweils -1
                         eingefgt.
  01-Feb-07   WD         Umbau von der Funktion tFTP.GetRemoteDir
}

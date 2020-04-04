
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit PMWSock;

{****************************************************************************
 *                                                                          *
 * WINSOCK.H--definitions to be used with the WINSOCK.DLL                   *
 *                                                                          *
 * This header file corresponds to version 1.1 of the Windows Sockets       *
 * specification.                                                           *
 *                                                                          *
 * This file includes parts which are Copyright (c) 1982-1986 Regents       *
 * of the University of California.  All rights reserved.  The Berkeley     *
 * Software License Agreement specifies the terms and conditions for        *
 * redistribution.                                                          *
 *                                                                          *
 ****************************************************************************}

Interface

Uses Os2Def, SysUtils;

Type TSOCKET=LongWord;

Const FD_SETSIZE      = 64;

Type TFDSET=Record
                fd_count:Word;
                fd_array:Array[0..FD_SETSIZE-1] Of TSOCKET;
     End;

     timeval=Record
                tv_sec:LongInt;
                tv_usec:LongInt;
     End;

Const
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

type
    hostent=Record
       h_name:PChar;             /* official name of host */
       h_aliases:PpCharArray;     /* alias list */
       h_addrtype:LongInt;       /* host address type */
       h_length:LongInt;         /* length of address */
       h_addr_list:PpCharArray;   /* list of addresses from name server */
       //h_addr  h_addr_list[0]  /* address, for backward compatiblity */
    End;
    phostent=^hostent;

    netent=Record
       n_name:PChar;
       n_aliases:PpCharArray;
       n_addrtype:LongInt;
       n_net:LongWord;
    End;
    pnetent=^netent;

    servent=Record
       s_name:PChar;
       s_aliases:PpCharArray;
       s_port:LongInt;
       s_proto:PChar;
    End;
    pservent=^servent;

    protoent=Record
       p_name:PChar;
       p_aliases:PpCharArray;
       p_proto:LongInt;
    End;
    pprotoent=^protoent;

Const
     IPPROTO_IP              =0;               /* dummy for IP */
     IPPROTO_ICMP            =1;               /* control message protocol */
     IPPROTO_GGP             =2;               /* gateway^2 (deprecated) */
     IPPROTO_TCP             =6;               /* tcp */
     IPPROTO_PUP             =12;              /* pup */
     IPPROTO_UDP             =17;              /* user datagram protocol */
     IPPROTO_IDP             =22;              /* xns idp */
     IPPROTO_ND              =77;              /* UNOFFICIAL net disk proto */
     IPPROTO_RAW             =255;             /* raw IP packet */
     IPPROTO_MAX             =256;

     IPPORT_ECHO             =7;
     IPPORT_DISCARD          =9;
     IPPORT_SYSTAT           =11;
     IPPORT_DAYTIME          =13;
     IPPORT_NETSTAT          =15;
     IPPORT_FTP              =21;
     IPPORT_TELNET           =23;
     IPPORT_SMTP             =25;
     IPPORT_TIMESERVER       =37;
     IPPORT_NAMESERVER       =42;
     IPPORT_WHOIS            =43;
     IPPORT_MTP              =57;
     IPPORT_TFTP             =69;
     IPPORT_RJE              =77;
     IPPORT_FINGER           =79;
     IPPORT_TTYLINK          =87;
     IPPORT_SUPDUP           =95;
     IPPORT_EXECSERVER       =512;
     IPPORT_LOGINSERVER      =513;
     IPPORT_CMDSERVER        =514;
     IPPORT_EFSSERVER        =520;
     IPPORT_BIFFUDP          =512;
     IPPORT_WHOSERVER        =513;
     IPPORT_ROUTESERVER      =520;
     IPPORT_RESERVED         =1024;

     IMPLINK_IP              =155;
     IMPLINK_LOWEXPER        =156;
     IMPLINK_HIGHEXPER       =158;

Type in_addr=Record
           Case Integer Of
             1:(S_un_b:Record s_b1,s_b2,s_b3,s_b4:Byte; End;);
             2:(s_un_w:Record s_w1,s_w2:Word; End;);
             3:(s_addr:LongWord);
     End;

Const
   IN_CLASSA_NET           =$ff000000;
   IN_CLASSA_NSHIFT        =24;
   IN_CLASSA_HOST          =$00ffffff;
   IN_CLASSA_MAX           =128;

   IN_CLASSB_NET           =$ffff0000;
   IN_CLASSB_NSHIFT        =16;
   IN_CLASSB_HOST          =$0000ffff;
   IN_CLASSB_MAX           =65536;

   IN_CLASSC_NET           =$ffffff00;
   IN_CLASSC_NSHIFT        =8;
   IN_CLASSC_HOST          =$000000ff;

   INADDR_ANY              =$00000000;
   INADDR_LOOPBACK         =$7f000001;
   INADDR_BROADCAST        =$ffffffff;
   INADDR_NONE             =$ffffffff;


Type
    sockaddr_in=Record
                      sin_family:Integer;
                      sin_port:Word;
                      sin_addr:in_addr;
                      sin_zero:CString[7];
    End;

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


Const
    IP_OPTIONS      =1;

Const
    INVALID_SOCKET  = -1;
    SOCKET_ERROR    = -1;

Const
    SOCK_STREAM     =1;               /* stream socket */
    SOCK_DGRAM      =2;               /* datagram socket */
    SOCK_RAW        =3;               /* raw-protocol interface */
    SOCK_RDM        =4;               /* reliably-delivered message */
    SOCK_SEQPACKET  =5;               /* sequenced packet stream */

Const
    SO_DEBUG        =$0001;          /* turn on debugging info recording */
    SO_ACCEPTCONN   =$0002;          /* socket has had listen() */
    SO_REUSEADDR    =$0004;          /* allow local address reuse */
    SO_KEEPALIVE    =$0008;          /* keep connections alive */
    SO_DONTROUTE    =$0010;          /* just use interface addresses */
    SO_BROADCAST    =$0020;          /* permit sending of broadcast msgs */
    SO_USELOOPBACK  =$0040;          /* bypass hardware when possible */
    SO_LINGER       =$0080;          /* linger on close if data present */
    SO_OOBINLINE    =$0100;          /* leave received OOB data in line */
    SO_DONTLINGER   =NOT SO_LINGER;  /* dont linger */
    SO_SNDBUF       =$1001;          /* send buffer size */
    SO_RCVBUF       =$1002;          /* receive buffer size */
    SO_SNDLOWAT     =$1003;          /* send low-water mark */
    SO_RCVLOWAT     =$1004;          /* receive low-water mark */
    SO_SNDTIMEO     =$1005;          /* send timeout */
    SO_RCVTIMEO     =$1006;          /* receive timeout */
    SO_ERROR        =$1007;          /* get error status and clear */
    SO_TYPE         =$1008;          /* get socket type */

Const
    TCP_NODELAY     =$0001;

Const
    AF_UNSPEC       =0;               /* unspecified */
    AF_UNIX         =1;               /* local to host (pipes, portals) */
    AF_INET         =2;               /* internetwork: UDP, TCP, etc. */
    AF_IMPLINK      =3;               /* arpanet imp addresses */
    AF_PUP          =4;               /* pup protocols: e.g. BSP */
    AF_CHAOS        =5;               /* mit CHAOS protocols */
    AF_NS           =6;               /* XEROX NS protocols */
    AF_ISO          =7;               /* ISO protocols */
    AF_OSI          =AF_ISO;          /* OSI is ISO */
    AF_ECMA         =8;               /* european computer manufacturers */
    AF_DATAKIT      =9;               /* datakit protocols */
    AF_CCITT        =10;              /* CCITT protocols, X.25 etc */
    AF_SNA          =11;              /* IBM SNA */
    AF_DECnet       =12;              /* DECnet */
    AF_DLI          =13;              /* Direct data link interface */
    AF_LAT          =14;              /* LAT */
    AF_HYLINK       =15;              /* NSC Hyperchannel */
    AF_APPLETALK    =16;              /* AppleTalk */
    AF_NETBIOS      =17;              /* NetBios-style addresses */
    AF_MAX          =18;

Type
    sockaddr=Record
        sa_family:Word;
        sa_data:CString[13];
    End;

    sockproto=Record
        sp_family:Word;
        sp_protocol:Word;
    End;

Const
    PF_UNSPEC       =AF_UNSPEC;
    PF_UNIX         =AF_UNIX;
    PF_INET         =AF_INET;
    PF_IMPLINK      =AF_IMPLINK;
    PF_PUP          =AF_PUP;
    PF_CHAOS        =AF_CHAOS;
    PF_NS           =AF_NS;
    PF_ISO          =AF_ISO;
    PF_OSI          =AF_OSI;
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

Type
    linger=Record
        l_onoff:LongInt;
        l_linger:LongInt;
    End;

Const
     SOL_SOCKET      =$ffff;          /* options for socket level */

     SOMAXCONN       =5;

     MSG_OOB         =1;             /* process out-of-band data */
     MSG_PEEK        =2;             /* peek at incoming message */
     MSG_DONTROUTE   =4;             /* send without using routing tables */
     MSG_MAXIOVLEN   =16;

     MAXGETHOSTSTRUCT =1024;

     FD_READ         =$01;
     FD_WRITE        =$02;
     FD_OOB          =$04;
     FD_ACCEPT       =$08;
     FD_CONNECT      =$10;
     FD_CLOSE        =$20;

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

Const
     EWOULDBLOCK             =WSAEWOULDBLOCK;
     EINPROGRESS             =WSAEINPROGRESS;
     EALREADY                =WSAEALREADY;
     ENOTSOCK                =WSAENOTSOCK;
     EDESTADDRREQ            =WSAEDESTADDRREQ;
     EMSGSIZE                =WSAEMSGSIZE;
     EPROTOTYPE              =WSAEPROTOTYPE;
     ENOPROTOOPT             =WSAENOPROTOOPT;
     EPROTONOSUPPORT         =WSAEPROTONOSUPPORT;
     ESOCKTNOSUPPORT         =WSAESOCKTNOSUPPORT;
     EOPNOTSUPP              =WSAEOPNOTSUPP;
     EPFNOSUPPORT            =WSAEPFNOSUPPORT;
     EAFNOSUPPORT            =WSAEAFNOSUPPORT;
     EADDRINUSE              =WSAEADDRINUSE;
     EADDRNOTAVAIL           =WSAEADDRNOTAVAIL;
     ENETDOWN                =WSAENETDOWN;
     ENETUNREACH             =WSAENETUNREACH;
     ENETRESET               =WSAENETRESET;
     ECONNABORTED            =WSAECONNABORTED;
     ECONNRESET              =WSAECONNRESET;
     ENOBUFS                 =WSAENOBUFS;
     EISCONN                 =WSAEISCONN;
     ENOTCONN                =WSAENOTCONN;
     ESHUTDOWN               =WSAESHUTDOWN;
     ETOOMANYREFS            =WSAETOOMANYREFS;
     ETIMEDOUT               =WSAETIMEDOUT;
     ECONNREFUSED            =WSAECONNREFUSED;
     ELOOP                   =WSAELOOP;
     ENAMETOOLONG            =WSAENAMETOOLONG;
     EHOSTDOWN               =WSAEHOSTDOWN;
     EHOSTUNREACH            =WSAEHOSTUNREACH;
     ENOTEMPTY               =WSAENOTEMPTY;
     EPROCLIM                =WSAEPROCLIM;
     EUSERS                  =WSAEUSERS;
     EDQUOT                  =WSAEDQUOT;
     ESTALE                  =WSAESTALE;
     EREMOTE                 =WSAEREMOTE;

Imports
       Function __WSAFDIsSet(s:TSOCKET;Var fd:TFDSET):LongInt; ApiEntry; 'PMWSock' name '__WSAFDIsSet';
       Function accept(s:TSOCKET;Var addr;Var addrlen:LongInt):TSOCKET; ApiEntry; 'PMWSock' name 'accept';
       Function bind(s:TSOCKET;Const addr;namelen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'bind';
       Function closesocket(s:TSOCKET):LongInt; ApiEntry; 'PMWSock' name 'closesocket';
       Function connect(s:TSOCKET;Const name;namelen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'connect';
       Function ioctlsocket(s:TSOCKET;cmd:LongInt;Var argp:LongWord):LongInt; ApiEntry; 'PMWSock' name 'ioctlsocket';
       Function getpeername(s:TSOCKET;Var name;Var nameLen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'getpeername';
       Function getsockname(s:TSOCKET;Var name;Var namelen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'getsockname';
       Function getsockopt(s:TSOCKET;level,optname:LongInt;Var optval;Var optlen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'getsockopt';
       Function htonl(hostlong:LongWord):LongWord; ApiEntry; 'PMWSock' name 'htonl';
       Function htons(hostshort:Word):Word; ApiEntry; 'PMWSock' name 'htons';
       Function inet_addr(Const cp:CString):LongWord; ApiEntry; 'PMWSock' name 'inet_addr';
       Function inet_ntoa(Var _in):PChar; ApiEntry; 'PMWSock' name 'inet_ntoa';
       Function listen(s:TSOCKET;backlog:LongInt):LongInt; ApiEntry; 'PMWSock' name 'listen';
       Function ntohl(netlong:LongWord):LongWord; ApiEntry; 'PMWSock' name 'ntohl';
       Function ntohs(netshort:Word):Word; ApiEntry; 'PMWSock' name 'ntohs';
       Function recv(s:TSOCKET;Var Buf;len,flags:LongInt):LongInt; ApiEntry; 'PMWSock' name 'recv';
       Function recvfrom(s:TSOCKET;Var Buf;len,flags:LongInt;
                         Var from:sockaddr;Var fromLen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'recvfrom';
       Function select(nfds:LongInt;Var readfds,writefds,exceptfds:TFDSET;
                       Const timeout:timeval):LongInt; ApiEntry; 'PMWSock' name 'select';
       Function send(s:TSOCKET;Const Buf;len,flags:LongInt):LongInt; ApiEntry; 'PMWSock' name 'send';
       Function sendto(s:TSOCKET;Const Buf;len,flags:LongInt;
                       Const _to:sockaddr;tolen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'sendto';
       Function setsockopt(s:TSOCKET;level,optname:LongInt;
                           Const optval;optlen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'setsockopt';
       Function shutdown(s:TSOCKET;how:LongInt):LongInt; ApiEntry; 'PMWSock' name 'shutdown';
       Function socket(af,typ,protocol:LongInt):TSOCKET; ApiEntry; 'PMWSock' name 'socket';
       Function gethostbyaddr(Var addr;len,typ:LongInt):phostent; ApiEntry; 'PMWSock' name 'gethostbyaddr';
       Function gethostbyname(Const name:CString):phostent; ApiEntry; 'PMWSock' name 'gethostbyname';
       Function gethostname(Const name:CString;namelen:LongInt):LongInt; ApiEntry; 'PMWSock' name 'gethostname';
       Function getservbyport(port:LongInt;Const proto:CString):pservent; ApiEntry; 'PMWSock' name 'getservbyport';
       Function getservbyname(Const name,proto:CString):pservent; ApiEntry; 'PMWSock' name 'getservbyname';
       Function getprotobynumber(proto:LongInt):pprotoent; ApiEntry; 'PMWSock' name 'getprotobynumber';
       Function getprotobyname(Const name:CString):pprotoent; ApiEntry; 'PMWSock' name 'getprotobyname';
       Function WSAStartup(wVersionRequired:Word;Var aWSAData:WSAData):LongInt; ApiEntry; 'PMWSock' name 'WSAStartup';
       Function WSACleanup:LongInt; ApiEntry; 'PMWSock' name 'WSACleanup';
       Procedure WSASetLastError(iError:LongInt); ApiEntry; 'PMWSock' name 'WSASetLastError';
       Function WSAGetLastError:LongInt; ApiEntry; 'PMWSock' name 'WSAGetLastError';
       Function WSAIsBlocking:LongBool; ApiEntry; 'PMWSock' name 'WSAIsBlocking';
       Function WSAUnhookBlockingHook:LongInt; ApiEntry; 'PMWSock' name 'WSAUnhookBlockingHook';
       Function WSASetBlockingHook(lpBlockFunc:Pointer):Pointer; ApiEntry; 'PMWSock' name 'WSASetBlockingHook';
       Function WSACancelBlockingCall:LongInt; ApiEntry; 'PMWSock' name 'WSACancelBlockingCall';
       Function WSAAsyncGetServByName(ahWnd:HWND;wMsg:LongWord;
                                      Const name,proto:CString;
                                      Var Buf;buflen:LongInt):LongWord; ApiEntry; 'PMWSock' name 'WSAAsyncGetServByName';
       Function WSAAsyncGetServByPort(ahWnd:HWND;wMsg:LongWord;
                                      port:LongInt;Const proto:CString;
                                      Var Buf;buflen:LongInt):LongWord; ApiEntry; 'PMWSock' name 'WSAAsyncGetServByPort';
       Function WSAAsyncGetProtoByName(ahWnd:HWND;wMsg:LongWord;
                                       Const name:CString;
                                       Var Buf;buflen:LongInt):LongWord; ApiEntry; 'PMWSock' name 'WSAAsyncGetProtoByName';
       Function WSAAsyncGetProtoByNumber(ahWnd:HWND;wMsg:LongWord;
                                         number:LongInt;
                                         Var Buf;buflen:LongInt):LongWord; ApiEntry; 'PMWSock' name 'WSAAsyncGetProtoByNumber';
       Function WSAAsyncGetHostByName(ahWnd:HWND;wMsg:LongWord;
                                      Const name:CString;
                                      Var Buf;buflen:LongInt):LongWord; ApiEntry; 'PMWSock' name 'WSAAsyncGetHostByName';
       Function WSAAsyncGetHostByAddr(ahWnd:HWND;wMsg:LongWord;
                                      Const addr:CString;len,typ:LongInt;
                                      Var Buf;buflen:LongInt):LongWord; ApiEntry; 'PMWSock' name 'WSAAsyncGetHostByAddr';
       Function WSACancelAsyncRequest(hAsyncTaskHandle:LongWord):LongInt; ApiEntry; 'PMWSock' name 'WSACancelAsyncRequest';
       Function WSAAsyncSelect(s:TSOCKET;ahWnd:HWND;wMsg:LongWord;lEvent:LongInt):LongWord; ApiEntry; 'PMWSock' name 'WSAAsyncSelect';
End;

/*
#define FD_CLR(fd, set) do { \
    u_int __i; \
    for (__i = 0; __i < ((fd_set *)(set))->fd_count ; __i++) { \
        if (((fd_set *)(set))->fd_array[__i] == fd) { \
            while (__i < ((fd_set *)(set))->fd_count-1) { \
                ((fd_set *)(set))->fd_array[__i] = \
                    ((fd_set *)(set))->fd_array[__i+1]; \
                __i++; \
            } \
            ((fd_set *)(set))->fd_count--; \
            break; \
        } \
    } \
} while(0)

#define FD_ISSET(fd, set) __WSAFDIsSet((SOCKET)fd, (fd_set *)set)

#define timerisset(tvp)         ((tvp)->tv_sec || (tvp)->tv_usec)
#define timercmp(tvp, uvp, cmp) \
        ((tvp)->tv_sec cmp (uvp)->tv_sec || \
         (tvp)->tv_sec == (uvp)->tv_sec && (tvp)->tv_usec cmp (uvp)->tv_usec)
#define timerclear(tvp)         (tvp)->tv_sec = (tvp)->tv_usec = 0

#define _IO(x,y)        (IOC_VOID|(x<<8)|y)

#define _IOR(x,y,t)     (IOC_OUT|(((long)sizeof(t)&IOCPARM_MASK)<<16)|(x<<8)|y)

#define _IOW(x,y,t)     (IOC_IN|(((long)sizeof(t)&IOCPARM_MASK)<<16)|(x<<8)|y)
*/
{

#define FIONREAD    _IOR('f', 127, u_long) /* get # bytes to read */
#define FIONBIO     _IOW('f', 126, u_long) /* set/clear non-blocking i/o */
#define FIOASYNC    _IOW('f', 125, u_long) /* set/clear async i/o */

/* Socket I/O Controls */
#define SIOCSHIWAT  _IOW('s',  0, u_long)  /* set high watermark */
#define SIOCGHIWAT  _IOR('s',  1, u_long)  /* get high watermark */
#define SIOCSLOWAT  _IOW('s',  2, u_long)  /* set low watermark */
#define SIOCGLOWAT  _IOR('s',  3, u_long)  /* get low watermark */
#define SIOCATMARK  _IOR('s',  7, u_long)  /* at oob mark? */

#define IN_CLASSA(i)            (((long)(i) & $80000000) == 0)
#define IN_CLASSB(i)            (((long)(i) & $c0000000) == $80000000)
#define IN_CLASSC(i)            (((long)(i) & $e0000000) == $c0000000)

#define h_errno         WSAGetLastError()

#define WSAMAKEASYNCREPLY(buflen,error)     MAKELONG(buflen,error)
/*
 * WSAMAKESELECTREPLY is intended for use by the Windows Sockets implementation
 * when constructing the response to WSAAsyncSelect().
 */
#define WSAMAKESELECTREPLY(event,error)     MAKELONG(event,error)
/*
 * WSAGETASYNCBUFLEN is intended for use by the Windows Sockets application
 * to extract the buffer length from the lParam in the response
 * to a WSAGetXByY().
 */
#define WSAGETASYNCBUFLEN(lParam)           LOUSHORT(lParam)
/*
 * WSAGETASYNCERROR is intended for use by the Windows Sockets application
 * to extract the error code from the lParam in the response
 * to a WSAGetXByY().
 */
#define WSAGETASYNCERROR(lParam)            HIUSHORT(lParam)
/*
 * WSAGETSELECTEVENT is intended for use by the Windows Sockets application
 * to extract the event code from the lParam in the response
 * to a WSAAsyncSelect().
 */
#define WSAGETSELECTEVENT(lParam)           LOUSHORT(lParam)
/*
 * WSAGETSELECTERROR is intended for use by the Windows Sockets application
 * to extract the error code from the lParam in the response
 * to a WSAAsyncSelect().
 */
#define WSAGETSELECTERROR(lParam)           HIUSHORT(lParam)

#endif  /* _WINSOCKAPI_ */
}

Procedure FD_ZERO(Var aset:TFDSET);
Procedure FD_SET(Socket: TSocket; Var FDSet: TFDSet);

implementation

Procedure FD_ZERO(Var aset:TFDSET);
Begin
    aset.fd_count:=0;
End;

procedure FD_SET(Socket: TSocket; var FDSet: TFDSet);
begin
  if FDSet.fd_count < FD_SETSIZE then
  begin
    FDSet.fd_array[FDSet.fd_count] := Socket;
    Inc(FDSet.fd_count);
  end;  
end;


end.


{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT SockApi;

INTERFACE           

CONST
     SOCK_STREAM     =1;               /* stream socket */
     SOCK_DGRAM      =2;               /* datagram socket */
     SOCK_RAW        =3;               /* raw-protocol interface */
     SOCK_RDM        =4;               /* reliably-delivered message */
     SOCK_SEQPACKET  =5;               /* sequenced packet stream */

/*
 * Option flags per-socket.
 */
     SO_DEBUG        =$0001;          /* turn on debugging info recording */
     SO_ACCEPTCONN   =$0002;          /* socket has had listen() */
     SO_REUSEADDR    =$0004;          /* allow local address reuse */
     SO_KEEPALIVE    =$0008;          /* keep connections alive */
     SO_DONTROUTE    =$0010;          /* just use interface addresses */
     SO_BROADCAST    =$0020;          /* permit sending of broadcast msgs */
     SO_USELOOPBACK  =$0040;          /* bypass hardware when possible */
     SO_LINGER       =$0080;          /* linger on close if data present */
     SO_OOBINLINE    =$0100;          /* leave received OOB data in line */

/*
 * Additional options, not kept in so_options.
 */
     SO_SNDBUF       =$1001;          /* send buffer size */
     SO_RCVBUF       =$1002;          /* receive buffer size */
     SO_SNDLOWAT     =$1003;          /* send low-water mark */
     SO_RCVLOWAT     =$1004;          /* receive low-water mark */
     SO_SNDTIMEO     =$1005;          /* send timeout */
     SO_RCVTIMEO     =$1006;          /* receive timeout */
     SO_ERROR        =$1007;          /* get error status and clear */
     SO_TYPE         =$1008;          /* get socket type */

/*
 * Structure used for manipulating linger option.
 */
TYPE
    linger=RECORD
                 l_onoff:LONGINT;                /* option on/off */
                 l_linger:LONGINT;               /* linger time */
    END;

/*
 * Level number for (get/set)sockopt() to apply to socket itself.
 */
CONST
     SOL_SOCKET      =$ffff;          /* options for socket level */

/*
 * Address families.
 */
CONST
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

/*
 * Structure used by kernel to store most
 * addresses.
 */
TYPE
    sockaddr=RECORD
                   sa_family:WORD;              /* address family */
                   sa_data:CSTRING[13];         /* up to 14 bytes of direct address */
    END;

/*
 * Structure used by kernel to pass protocol
 * information in raw sockets.
 */
    sockproto=RECORD
                    sp_family:WORD;              /* address family */
                    sp_protocol:WORD;            /* protocol */
    END;

/*
 * Protocol families, same as address families for now.
 */
CONST
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

/*
 * Maximum queue length specifiable by listen.
 */
     SOMAXCONN       =5;

/*
 * Message header for recvmsg and sendmsg calls.
 */
TYPE
    iovec=RECORD
                iov_base:PChar;
                iov_len:LONGINT;
    END;

    uio=RECORD
              uio_iov:^iovec;
              uio_iovcnt:LONGINT;
              uio_offset:LONGINT;
              uio_segflg:LONGINT;
              uio_resid:LONGINT;
    END;

    uio_rw =(UIO_READ, UIO_WRITE );

    msghdr=RECORD
                 msg_name:PChar;               /* optional address */
                 msg_namelen:LONGINT;          /* size of address */
                 msg_iov:^iovec;               /* scatter/gather array */
                 msg_iovlen:LONGINT;           /* # elements in msg_iov */
                 msg_accrights:PChar;          /* access rights sent/received */
                 msg_accrightslen:LONGINT;
    END;

CONST
     FREAD  =1;
     FWRITE =2;

     MSG_OOB         =$1;             /* process out-of-band data */
     MSG_PEEK        =$2;             /* peek at incoming message */
     MSG_DONTROUTE   =$4;             /* send without using routing tables */

     MSG_MAXIOVLEN   =16;

IMPORTS

FUNCTION accept( p1:LONGINT;VAR sa:sockaddr;var p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 1;
FUNCTION bind( p1:LONGINT;VAR sa:sockaddr;p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 2;
FUNCTION connect( p1:LONGINT;VAR sa:sockaddr;p2:LONGINT ):LONGINT;
         APIENTRY; 'SO32DLL' index 3;
FUNCTION gethostid:LONGINT;
         APIENTRY; 'SO32DLL' index 4;
FUNCTION getpeername(p1:LONGINT;VAR sa:sockaddr;VAR p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 5;
FUNCTION getsockname(p1:LONGINT;VAR sa:sockaddr;VAR p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 6;
FUNCTION getsockopt(p1,p2,p3:LONGINT;VAR c:CSTRING;VAR p4:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 7;
FUNCTION ioctl(p1,p2:LONGINT;VAR c:CSTRING;p3:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 8;
FUNCTION listen(p1,p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 9;
FUNCTION recvmsg(p1:LONGINT;VAR mh:msghdr;p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 21;
FUNCTION recv( p1:LONGINT;VAR c:CSTRING;p2,p3:LONGINT ):LONGINT;
         APIENTRY; 'SO32DLL' index 10;
FUNCTION recvfrom(p1:LONGINT;VAR c:CSTRING;p2,p3:LONGINT;VAR sa:sockaddr;VAR p4:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 11;
FUNCTION select(VAR p1:LONGINT;p2,p3,p4,p5:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 12;
FUNCTION send(p1:LONGINT;VAR c:CSTRING;p2,p3:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 13;
FUNCTION sendmsg(p1:LONGINT;VAR mh:msghdr;p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 22;
FUNCTION sendto(p1:LONGINT;VAR c:CSTRING;p2,p3:LONGINT;VAR sa:sockaddr;p4:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 14;
FUNCTION setsockopt(p1,p2,p3:LONGINT;VAR c:CSTRING;p4:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 15;
FUNCTION sock_init:LONGINT;
         APIENTRY; 'SO32DLL' index 26;
FUNCTION sock_errno:LONGINT;
         APIENTRY; 'SO32DLL' index 20;
FUNCTION psock_errno(CONST c:CSTRING):LONGINT;
         APIENTRY; 'SO32DLL' index 30;
FUNCTION socket(p1,p2,p3:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 16;
FUNCTION soclose( p1:LONGINT ):LONGINT;
         APIENTRY; 'SO32DLL' index 17;
FUNCTION soabort(p1:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 19;
FUNCTION so_cancel(p1:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 18;
FUNCTION readv(p1:LONGINT;VAR io:iovec;p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 23;
FUNCTION writev(p1:LONGINT;VAR io:iovec;p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 24;
FUNCTION shutdown(p1,p2:LONGINT):LONGINT;
         APIENTRY; 'SO32DLL' index 25;
FUNCTION getinetversion(VAR c:CSTRING):LONGINT;
         APIENTRY; 'SO32DLL' index 31;
END;

IMPLEMENTATION

BEGIN
END.

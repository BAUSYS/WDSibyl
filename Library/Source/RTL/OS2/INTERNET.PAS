
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT Internet;

INTERFACE

/*
 * Protocols
 */
CONST
     IPPROTO_IP              =0;               /* dummy for IP */
     IPPROTO_ICMP            =1;               /* control message protocol */
     IPPROTO_GGP             =3;               /* gateway^2 (deprecated) */
     IPPROTO_TCP             =6;               /* tcp */
     IPPROTO_EGP             =8;               /* exterior gateway protocol */
     IPPROTO_PUP             =12;              /* pup */
     IPPROTO_UDP             =17;              /* user datagram protocol */
     IPPROTO_IDP             =22;              /* xns idp */

     IPPROTO_RAW             =255;             /* raw IP packet */
     IPPROTO_MAX             =256;


/*
 * Ports < IPPORT_RESERVED are reserved for
 * privileged processes (e.g. root).
 * Ports > IPPORT_USERRESERVED are reserved
 * for servers, not necessarily privileged.
 */
CONST
    IPPORT_RESERVED         =1024;
    IPPORT_USERRESERVED     =5000;

/*
 * Link numbers
 */
CONST
    IMPLINK_IP              =155;
    IMPLINK_LOWEXPER        =156;
    IMPLINK_HIGHEXPER       =158;

/*
 * Internet address (a structure for historical reasons)
 */
TYPE
    in_addr=RECORD
                  s_addr:LONGWORD;
    END;

/*
 * Definitions of bits in internet address integers.
 * On subnets, the decomposition of addresses to host and net parts
 * is done according to subnet mask, not the masks here.
 */
CONST
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
     INADDR_BROADCAST        =$ffffffff;     /* must be masked */
     INADDR_NONE             =$ffffffff;     /* -1 return */

     IN_LOOPBACKNET          =127;           /* official! */

/*
 * Socket address, internet style.
 */
TYPE
    sockaddr_in=RECORD
                      sin_family:INTEGER;
                      sin_port:WORD;
                      sin_addr:in_addr;
                      sin_zero:CSTRING[7];
    END;

/*
 * Options for use with [gs]etsockopt at the IP level.
 */
CONST
     IP_OPTIONS      =1;               /* set/get IP per-packet options */

IMPORTS
FUNCTION inet_addr(CONST c:CSTRING):LONGWORD;
         APIENTRY; 'TCP32DLL' index 5;
FUNCTION inet_makeaddr(p1,p2:LONGWORD):LONGWORD; {in_addr}
         APIENTRY; 'TCP32DLL' index 8;
FUNCTION inet_network(VAR c:CSTRING):LONGWORD;
         APIENTRY; 'TCP32DLL' index 9;
FUNCTION inet_ntoa(ia:LONGWORD{in_addr}):LONGWORD;
         APIENTRY; 'TCP32DLL' index 10;
FUNCTION inet_lnaof(ia:LONGWORD{in_addr}):LONGWORD;
         APIENTRY; 'TCP32DLL' index 6;
FUNCTION inet_netof(ia:LONGWORD{in_addr}):LONGWORD;
         APIENTRY; 'TCP32DLL' index 7;
END;

FUNCTION IN_CLASSA(i:LONGINT):BOOLEAN;
FUNCTION IN_CLASSB(i:LONGINT):BOOLEAN;
FUNCTION IN_CLASSC(i:LONGINT):BOOLEAN;
FUNCTION IN_CLASSD(i:LONGINT):BOOLEAN;
FUNCTION IN_MULTICAST(i:LONGINT):BOOLEAN;
FUNCTION IN_EXPERIMENTAL(i:LONGINT):BOOLEAN;
FUNCTION IN_BADCLASS(i:LONGINT):BOOLEAN;

IMPLEMENTATION

FUNCTION IN_CLASSA(i:LONGINT):BOOLEAN;
BEGIN
     result:=(((i) AND $80000000) = 0);
END;

FUNCTION IN_CLASSB(i:LONGINT):BOOLEAN;
BEGIN
     result:=(((i) AND $c0000000) = $80000000);
END;

FUNCTION IN_CLASSC(i:LONGINT):BOOLEAN;
BEGIN
     result:=(((i) AND $e0000000) = $c0000000);
END;

FUNCTION IN_CLASSD(i:LONGINT):BOOLEAN;
BEGIN
     result:=(((i) AND $f0000000) = $e0000000);
END;

FUNCTION IN_MULTICAST(i:LONGINT):BOOLEAN;
BEGIN
     result:=IN_CLASSD(i);
END;

FUNCTION IN_EXPERIMENTAL(i:LONGINT):BOOLEAN;
BEGIN
     result:=(((i) AND $e0000000) = $e0000000);
END;

FUNCTION IN_BADCLASS(i:LONGINT):BOOLEAN;
BEGIN
     result:=(((i) AND $f0000000) = $f0000000);
END;


BEGIN
END.

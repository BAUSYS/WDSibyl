
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for Win32                                     บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

UNIT WinBase;

{****************************************************************************
 *                                                                          *
 * Win32 KERNEL32 Imports definition file                                   *
 *                                                                          *
 ****************************************************************************}


INTERFACE

USES WinNT, WinDef;

CONST
     INVALID_FILE_SIZE           =$FFFFFFFF;

     FILE_BEGIN                  =0;
     FILE_CURRENT                =1;
     FILE_END                    =2;

     TIME_ZONE_ID_INVALID        =$FFFFFFFF;
     WAIT_FAILED                 =$FFFFFFFF;
     WAIT_OBJECT_0               =STATUS_WAIT_0;
     WAIT_ABANDONED              =STATUS_ABANDONED_WAIT_0;
     WAIT_ABANDONED_0            =STATUS_ABANDONED_WAIT_0;
     WAIT_TIMEOUT                =STATUS_TIMEOUT;
     WAIT_IO_COMPLETION          =STATUS_USER_APC;
     STILL_ACTIVE                =STATUS_PENDING;

     {Exception constants}
     EXCEPTION_ACCESS_VIOLATION     =STATUS_ACCESS_VIOLATION;
     EXCEPTION_DATATYPE_MISALIGNMENT=STATUS_DATATYPE_MISALIGNMENT;
     EXCEPTION_BREAKPOINT           =STATUS_BREAKPOINT;
     EXCEPTION_SINGLE_STEP          =STATUS_SINGLE_STEP;
     EXCEPTION_ARRAY_BOUNDS_EXCEEDED=STATUS_ARRAY_BOUNDS_EXCEEDED;
     EXCEPTION_FLT_DENORMAL_OPERAND =STATUS_FLOAT_DENORMAL_OPERAND;
     EXCEPTION_FLT_DIVIDE_BY_ZERO   =STATUS_FLOAT_DIVIDE_BY_ZERO;
     EXCEPTION_FLT_INEXACT_RESULT   =STATUS_FLOAT_INEXACT_RESULT;
     EXCEPTION_FLT_INVALID_OPERATION=STATUS_FLOAT_INVALID_OPERATION;
     EXCEPTION_FLT_OVERFLOW         =STATUS_FLOAT_OVERFLOW;
     EXCEPTION_FLT_STACK_CHECK      =STATUS_FLOAT_STACK_CHECK;
     EXCEPTION_FLT_UNDERFLOW        =STATUS_FLOAT_UNDERFLOW;
     EXCEPTION_INT_DIVIDE_BY_ZERO   =STATUS_INTEGER_DIVIDE_BY_ZERO;
     EXCEPTION_INT_OVERFLOW         =STATUS_INTEGER_OVERFLOW;
     EXCEPTION_PRIV_INSTRUCTION     =STATUS_PRIVILEGED_INSTRUCTION;
     EXCEPTION_IN_PAGE_ERROR        =STATUS_IN_PAGE_ERROR;
     EXCEPTION_ILLEGAL_INSTRUCTION  =STATUS_ILLEGAL_INSTRUCTION;
     EXCEPTION_NONCONTINUABLE_EXCEPTION=STATUS_NONCONTINUABLE_EXCEPTION;
     EXCEPTION_STACK_OVERFLOW       =STATUS_STACK_OVERFLOW;
     EXCEPTION_INVALID_DISPOSITION  =STATUS_INVALID_DISPOSITION;
     EXCEPTION_GUARD_PAGE           =STATUS_GUARD_PAGE_VIOLATION;
     CONTROL_C_EXIT                 =STATUS_CONTROL_C_EXIT;

CONST
     FILE_FLAG_WRITE_THROUGH         =$80000000;
     FILE_FLAG_OVERLAPPED            =$40000000;
     FILE_FLAG_NO_BUFFERING          =$20000000;
     FILE_FLAG_RANDOM_ACCESS         =$10000000;
     FILE_FLAG_SEQUENTIAL_SCAN       =$08000000;
     FILE_FLAG_DELETE_ON_CLOSE       =$04000000;
     FILE_FLAG_BACKUP_SEMANTICS      =$02000000;
     FILE_FLAG_POSIX_SEMANTICS       =$01000000;

CONST
     CREATE_NEW           =1;
     CREATE_ALWAYS        =2;
     OPEN_EXISTING        =3;
     OPEN_ALWAYS          =4;
     TRUNCATE_EXISTING    =5;



{dwOpenMode values for CreateNamedPipe}
CONST
     PIPE_ACCESS_INBOUND         =$00000001;
     PIPE_ACCESS_OUTBOUND        =$00000002;
     PIPE_ACCESS_DUPLEX          =$00000003;

{Named Pipe End flags for GetNamedPipeInfo}
CONST
     PIPE_CLIENT_END             =$00000000;
     PIPE_SERVER_END             =$00000001;

{dwPipeMode values for CreateNamedPipe}
CONST
     PIPE_WAIT                   =$00000000;
     PIPE_NOWAIT                 =$00000001;
     PIPE_READMODE_BYTE          =$00000000;
     PIPE_READMODE_MESSAGE       =$00000002;
     PIPE_TYPE_BYTE              =$00000000;
     PIPE_TYPE_MESSAGE           =$00000004;

{CreateNamedPipe nMaxInstances}
CONST
     PIPE_UNLIMITED_INSTANCES    =255;

{Bits for CreateFile}
CONST
     SECURITY_CONTEXT_TRACKING   =$00040000;
     SECURITY_EFFECTIVE_ONLY     =$00080000;

     SECURITY_SQOS_PRESENT       =$00100000;
     SECURITY_VALID_SQOS_FLAGS   =$001F0000;

{File structures}
TYPE
    POVERLAPPED=^OVERLAPPED;
    OVERLAPPED=RECORD
                     Internal:LONGWORD;
                     InternalHigh:LONGWORD;
                     Offset:LONGWORD;
                     OffsetHigh:LONGWORD;
                     hEvent:HANDLE;
    END;

    PSECURITY_ATTRIBUTES=^SECURITY_ATTRIBUTES;
    SECURITY_ATTRIBUTES=RECORD
                              nLength:LONGWORD;
                              lpSecurityDescriptor:POINTER;
                              bInheritHandle:BOOL;
                        END;

    PPROCESS_INFORMATION=^PROCESS_INFORMATION;
    PROCESS_INFORMATION=RECORD
                              hProcess:HANDLE;
                              hThread:HANDLE;
                              dwProcessId:LONGWORD;
                              dwThreadId:LONGWORD;
    END;

    PFILETIME=^FILETIME;
    FILETIME=RECORD
                   dwLowDateTime:LONGWORD;
                   dwHighDateTime:LONGWORD;
    END;

    PSYSTEMTIME=^SYSTEMTIME;
    SYSTEMTIME=RECORD
                     wYear:WORD;
                     wMonth:WORD;
                     wDayOfWeek:WORD;
                     wDay:WORD;
                     wHour:WORD;
                     wMinute:WORD;
                     wSecond:WORD;
                     wMilliseconds:WORD;
     END;

     {Thread start proc}
     LPTHREAD_START_ROUTINE=FUNCTION(lpThreadParameter:POINTER):ULONG;


CONST
     SP_SERIALCOMM    =$00000001;

     PST_UNSPECIFIED  =$00000000;
     PST_RS232        =$00000001;
     PST_PARALLELPORT =$00000002;
     PST_RS422        =$00000003;
     PST_RS423        =$00000004;
     PST_RS449        =$00000005;
     PST_MODEM        =$00000006;
     PST_FAX          =$00000021;
     PST_SCANNER      =$00000022;
     PST_NETWORK_BRIDGE=$00000100;
     PST_LAT          =$00000101;
     PST_TCPIP_TELNET =$00000102;
     PST_X25          =$00000103;

     PCF_DTRDSR       =$0001;
     PCF_RTSCTS       =$0002;
     PCF_RLSD         =$0004;
     PCF_PARITY_CHECK =$0008;
     PCF_XONXOFF      =$0010;
     PCF_SETXCHAR     =$0020;
     PCF_TOTALTIMEOUTS=$0040;
     PCF_INTTIMEOUTS  =$0080;
     PCF_SPECIALCHARS =$0100;
     PCF_16BITMODE    =$0200;

     SP_PARITY        =$0001;
     SP_BAUD          =$0002;
     SP_DATABITS      =$0004;
     SP_STOPBITS      =$0008;
     SP_HANDSHAKING   =$0010;
     SP_PARITY_CHECK  =$0020;
     SP_RLSD          =$0040;

     BAUD_075         =$00000001;
     BAUD_110         =$00000002;
     BAUD_134_5       =$00000004;
     BAUD_150         =$00000008;
     BAUD_300         =$00000010;
     BAUD_600         =$00000020;
     BAUD_1200        =$00000040;
     BAUD_1800        =$00000080;
     BAUD_2400        =$00000100;
     BAUD_4800        =$00000200;
     BAUD_7200        =$00000400;
     BAUD_9600        =$00000800;
     BAUD_14400       =$00001000;
     BAUD_19200       =$00002000;
     BAUD_38400       =$00004000;
     BAUD_56K         =$00008000;
     BAUD_128K        =$00010000;
     BAUD_115200      =$00020000;
     BAUD_57600       =$00040000;
     BAUD_USER        =$10000000;

     DATABITS_5       =$0001;
     DATABITS_6       =$0002;
     DATABITS_7       =$0004;
     DATABITS_8       =$0008;
     DATABITS_16      =$0010;
     DATABITS_16X     =$0020;

     STOPBITS_10      =$0001;
     STOPBITS_15      =$0002;
     STOPBITS_20      =$0004;
     PARITY_NONE      =$0100;
     PARITY_ODD       =$0200;
     PARITY_EVEN      =$0400;
     PARITY_MARK      =$0800;
     PARITY_SPACE     =$1000;

type TDCB = RECORD
       DCBLength  : LongWord;
       Baudrate   : LongWord;
       Flags      : LongInt;
       wReserved  : Word;
       XONLim     : Word;
       XOFFLim    : Word;
       BYTESize   : BYTE;
       Parity     : BYTE;
       StopBits   : BYTE;
       XONChar    : Char;
       XOFFChar   : Char;
       ErrorChar  : Char;
       EOFChar    : Char;
       EvtChar    : Char;
       wReserved1 : Word;
     End;

     TComStat = RECORD
        Flags      : LongWord;
        CbInQue    : LongWord;
        CbOutQue   : LongWord;
     End;

TYPE
    LPCOMMPROP=^COMMPROP;
    COMMPROP=RECORD
                   wPacketLength:WORD;
                   wPacketVersion:WORD;
                   dwServiceMask:ULONG;
                   dwReserved1:ULONG;
                   dwMaxTxQueue:ULONG;
                   dwMaxRxQueue:ULONG;
                   dwMaxBaud:ULONG;
                   dwProvSubType:ULONG;
                   dwProvCapabilities:ULONG;
                   dwSettableParams:ULONG;
                   dwSettableBaud:ULONG;
                   wSettableData:WORD;
                   wSettableStopParity:WORD;
                   dwCurrentTxQueue:ULONG;
                   dwCurrentRxQueue:ULONG;
                   dwProvSpec1:ULONG;
                   dwProvSpec2:ULONG;
                   wcProvChar:CHAR;
    END;

CONST
     COMMPROP_INITIALIZED =$E73CF52E;

CONST
     DTR_CONTROL_DISABLE    =$00;
     DTR_CONTROL_ENABLE     =$01;
     DTR_CONTROL_HANDSHAKE  =$02;

     RTS_CONTROL_DISABLE    =$00;
     RTS_CONTROL_ENABLE     =$01;
     RTS_CONTROL_HANDSHAKE  =$02;
     RTS_CONTROL_TOGGLE     =$03;

TYPE
    LPCOMMRTIMEOUTS=^COMMTIMEOUTS;
    COMMTIMEOUTS=RECORD
                       ReadIntervalTimeout:ULONG;
                       ReadTotalTimeoutMultiplier:ULONG;
                       ReadTotalTimeoutConstant:ULONG;
                       WriteTotalTimeoutMultiplier:ULONG;
                       WriteTotalTimeoutConstant:ULONG;
    END;


TYPE
    LPSYSTEM_INFO=^SYSTEM_INFO;
    SYSTEM_INFO=RECORD
                      dwOemId:ULONG;
                      dwPageSize:ULONG;
                      lpMinimumApplicationAddress:POINTER;
                      lpMaximumApplicationAddress:POINTER;
                      dwActiveProcessorMask:ULONG;
                      dwNumberOfProcessors:ULONG;
                      dwProcessorType:ULONG;
                      dwAllocationGranularity:ULONG;
                      dwReserved:ULONG;
     END;

CONST
     {Memory Flags}
     GMEM_FIXED          =$0000;
     GMEM_MOVEABLE       =$0002;
     GMEM_NOCOMPACT      =$0010;
     GMEM_NODISCARD      =$0020;
     GMEM_ZEROINIT       =$0040;
     GMEM_MODIFY         =$0080;
     GMEM_DISCARDABLE    =$0100;
     GMEM_NOT_BANKED     =$1000;
     GMEM_SHARE          =$2000;
     GMEM_DDESHARE       =$2000;
     GMEM_NOTIFY         =$4000;
     GMEM_LOWER          =GMEM_NOT_BANKED;
     GMEM_VALID_FLAGS    =$7F72;
     GMEM_INVALID_HANDLE =$8000;
     GHND                =GMEM_MOVEABLE OR GMEM_ZEROINIT;
     GPTR                =GMEM_FIXED OR GMEM_ZEROINIT;

     {GlobalFlags return values}
     GMEM_DISCARDED      =$4000;
     GMEM_LOCKCOUNT      =$00FF;

TYPE
    LPMEMORYTSTATUS=^MEMORYSTATUS;
    MEMORYSTATUS=RECORD
                       dwLength:ULONG;
                       dwMemoryLoad:ULONG;
                       dwTotalPhys:ULONG;
                       dwAvailPhys:ULONG;
                       dwTotalPageFile:ULONG;
                       dwAvailPageFile:ULONG;
                       dwTotalVirtual:ULONG;
                       dwAvailVirtual:ULONG;
    END;

CONST
    {Local Memory Flags}
    LMEM_FIXED          =$0000;
    LMEM_MOVEABLE       =$0002;
    LMEM_NOCOMPACT      =$0010;
    LMEM_NODISCARD      =$0020;
    LMEM_ZEROINIT       =$0040;
    LMEM_MODIFY         =$0080;
    LMEM_DISCARDABLE    =$0F00;
    LMEM_VALID_FLAGS    =$0F72;
    LMEM_INVALID_HANDLE =$8000;
    LHND                =LMEM_MOVEABLE OR LMEM_ZEROINIT;
    LPTR                =LMEM_FIXED OR LMEM_ZEROINIT;
    NONZEROLHND         =LMEM_MOVEABLE;
    NONZEROLPTR         =LMEM_FIXED;

    {LocalFlags return values}
    LMEM_DISCARDED      =$4000;
    LMEM_LOCKCOUNT      =$00FF;


    {Process creation flags}
    DEBUG_PROCESS               =$00000001;
    DEBUG_ONLY_THIS_PROCESS     =$00000002;
    CREATE_SUSPENDED            =$00000004;
    DETACHED_PROCESS            =$00000008;
    CREATE_NEW_CONSOLE          =$00000010;
    NORMAL_PRIORITY_CLASS       =$00000020;
    IDLE_PRIORITY_CLASS         =$00000040;
    HIGH_PRIORITY_CLASS         =$00000080;
    REALTIME_PRIORITY_CLASS     =$00000100;
    CREATE_NEW_PROCESS_GROUP    =$00000200;
    CREATE_UNICODE_ENVIRONMENT  =$00000400;
    CREATE_SEPARATE_WOW_VDM     =$00000800;
    CREATE_DEFAULT_ERROR_MODE   =$04000000;
    CREATE_NO_WINDOW            =$08000000;
    PROFILE_USER                =$10000000;
    PROFILE_KERNEL              =$20000000;
    PROFILE_SERVER              =$40000000;

    {Thread priority constants}
    THREAD_PRIORITY_LOWEST      =THREAD_BASE_PRIORITY_MIN;
    THREAD_PRIORITY_BELOW_NORMAL=THREAD_PRIORITY_LOWEST+1;
    THREAD_PRIORITY_NORMAL      =0;
    THREAD_PRIORITY_HIGHEST     =THREAD_BASE_PRIORITY_MAX;
    THREAD_PRIORITY_ABOVE_NORMAL=THREAD_PRIORITY_HIGHEST-1;
    THREAD_PRIORITY_ERROR_RETURN=MAXLONG;
    THREAD_PRIORITY_TIME_CRITICAL=THREAD_BASE_PRIORITY_LOWRT;
    THREAD_PRIORITY_IDLE        =THREAD_BASE_PRIORITY_IDLE;

CONST
     {Debug API}
     EXCEPTION_DEBUG_EVENT       =1;
     CREATE_THREAD_DEBUG_EVENT   =2;
     CREATE_PROCESS_DEBUG_EVENT  =3;
     EXIT_THREAD_DEBUG_EVENT     =4;
     EXIT_PROCESS_DEBUG_EVENT    =5;
     LOAD_DLL_DEBUG_EVENT        =6;
     UNLOAD_DLL_DEBUG_EVENT      =7;
     OUTPUT_DEBUG_STRING_EVENT   =8;
     RIP_EVENT                   =9;

    {$IFDEF OS2}
CONST
     SIZE_OF_80387_REGISTERS      = 80;

TYPE
    PFLOATING_SAVE_AREA=^FLOATING_SAVE_AREA;
    FLOATING_SAVE_AREA=RECORD
                             ControlWord:LONGWORD;
                             StatusWord:LONGWORD;
                             TagWord:LONGWORD;
                             ErrorOffset:LONGWORD;
                             ErrorSelector:LONGWORD;
                             DataOffset:LONGWORD;
                             DataSelector:LONGWORD;
                             RegisterArea:ARRAY[0..SIZE_OF_80387_REGISTERS-1] OF BYTE;
                             Cr0NpxState:LONGWORD;
    END;

TYPE
    PCONTEXT=^CONTEXT;
    CONTEXT=RECORD
                  ContextFlags:LONGWORD;
                  Dr0:LONGWORD;
                  Dr1:LONGWORD;
                  Dr2:LONGWORD;
                  Dr3:LONGWORD;
                  Dr6:LONGWORD;
                  Dr7:LONGWORD;

                  FloatSave:FLOATING_SAVE_AREA;

                  SegGs:LONGWORD;
                  SegFs:LONGWORD;
                  SegEs:LONGWORD;
                  SegDs:LONGWORD;

                  Edi:LONGWORD;
                  Esi:LONGWORD;
                  Ebx:LONGWORD;
                  Edx:LONGWORD;
                  Ecx:LONGWORD;
                  Eax:LONGWORD;

                  Ebp:LONGWORD;
                  Eip:LONGWORD;
                  SegCs:LONGWORD;
                  EFlags:LONGWORD;
                  Esp:LONGWORD;
                  SegSs:LONGWORD;
    END;

CONST
     EXCEPTION_CONTINUABLE         = 0; // Continuable exception
     EXCEPTION_NONCONTINUABLE      = 1; // Noncontinuable exception
     EXCEPTION_MAXIMUM_PARAMETERS  =15; // maximum number of exception parameters

TYPE
    PEXCEPTION_RECORD=^EXCEPTION_RECORD;
    EXCEPTION_RECORD=RECORD
                           ExceptionCode:LONGWORD;
                           ExceptionFlags:LONGWORD;
                           ExceptionRecord:PEXCEPTION_RECORD;
                           ExceptionAddress:POINTER;
                           NumberParameters:LONGWORD;
                           ExceptionInformation:ARRAY[0..EXCEPTION_MAXIMUM_PARAMETERS-1] OF LONGWORD;
    END;

TYPE
    PEXCEPTION_POINTERS=^EXCEPTION_POINTERS;
    EXCEPTION_POINTERS=RECORD
                             ExceptionRecord:PEXCEPTION_RECORD;
                             ContextRecord:PCONTEXT;
    END;
    {$ENDIF}

type
    LPEXCEPTION_DEBUG_INFO=^EXCEPTION_DEBUG_INFO;
    EXCEPTION_DEBUG_INFO=RECORD
                               {$IFDEF Win32}
                               ExceptionRecord:SYSTEM.EXCEPTION_RECORD;
                               {$ENDIF}
                               {$IFDEF OS2}
                               ExceptionRecord:EXCEPTION_RECORD;
                               {$ENDIF}
                               dwFirstChance:ULONG;
    END;


    LPCREATE_THREAD_DEBUG_INFO=^CREATE_THREAD_DEBUG_INFO;
    CREATE_THREAD_DEBUG_INFO=RECORD
                                   hThread:HANDLE;
                                   lpThreadLocalBase:POINTER;
                                   lpStartAddress:LPTHREAD_START_ROUTINE;
    END;

    LPCREATE_PROCESS_DEBUG_INFO=^CREATE_PROCESS_DEBUG_INFO;
    CREATE_PROCESS_DEBUG_INFO=RECORD
                                    hFile:HANDLE;
                                    hProcess:HANDLE;
                                    hThread:HANDLE;
                                    lpBaseOfImage:POINTER;
                                    dwDebugInfoFileOffset:ULONG;
                                    nDebugInfoSize:ULONG;
                                    lpThreadLocalBase:POINTER;
                                    lpStartAddress:LPTHREAD_START_ROUTINE;
                                    lpImageName:POINTER;
                                    fUnicode:WORD;
    END;

    LPEXIT_THREAD_DEBUG_INFO=^EXIT_THREAD_DEBUG_INFO;
    EXIT_THREAD_DEBUG_INFO=RECORD
                                 dwExitCode:ULONG;
    END;

    LPEXIT_PROCESS_DEBUG_INFO=^EXIT_PROCESS_DEBUG_INFO;
    EXIT_PROCESS_DEBUG_INFO=RECORD
                                  dwExitCode:ULONG;
    END;

    LPLOAD_DLL_DEBUG_INFO=^LOAD_DLL_DEBUG_INFO;
    LOAD_DLL_DEBUG_INFO=RECORD
                              hFile:HANDLE;
                              lpBaseOfDll:POINTER;
                              dwDebugInfoFileOffset:ULONG;
                              nDebugInfoSize:ULONG;
                              lpImageName:POINTER;
                              fUnicode:WORD;
    END;

    LPUNLOAD_DLL_DEBUG_INFO=^UNLOAD_DLL_DEBUG_INFO;
    UNLOAD_DLL_DEBUG_INFO=RECORD
                                lpBaseOfDll:POINTER;
    END;

    LPOUTPUT_DEBUG_STRING_INFO=^OUTPUT_DEBUG_STRING_INFO;
    OUTPUT_DEBUG_STRING_INFO=RECORD
                                   lpDebugStringData:LPStr;
                                   fUnicode:WORD;
                                   nDebugStringLength:WORD;
    END;

    LPRIP_INFO=^RIP_INFO;
    RIP_INFO=RECORD
                   dwError:ULONG;
                   dwType:ULONG;
    END;

    LPDEBUG_EVENT=^DEBUG_EVENT;
    DEBUG_EVENT=RECORD
                      dwDebugEventCode:ULONG;
                      dwProcessId:ULONG;
                      dwThreadId:ULONG;
                      CASE Integer OF
                        1:(Exception:EXCEPTION_DEBUG_INFO);
                        2:(CreateThread:CREATE_THREAD_DEBUG_INFO);
                        3:(CreateProcessInfo:CREATE_PROCESS_DEBUG_INFO);
                        4:(ExitThread:EXIT_THREAD_DEBUG_INFO);
                        5:(ExitProcess:EXIT_THREAD_DEBUG_INFO);
                        6:(LoadDll:LOAD_DLL_DEBUG_INFO);
                        7:(UnloadDll:UNLOAD_DLL_DEBUG_INFO);
                        8:(DebugString:OUTPUT_DEBUG_STRING_INFO);
                        9:(RipInfo:RIP_INFO);
    END;

CONST
     DRIVE_UNKNOWN     =0;
     DRIVE_NO_ROOT_DIR =1;
     DRIVE_REMOVABLE   =2;
     DRIVE_FIXED       =3;
     DRIVE_REMOTE      =4;
     DRIVE_CDROM       =5;
     DRIVE_RAMDISK     =6;

     FILE_TYPE_UNKNOWN   =$0000;
     FILE_TYPE_DISK      =$0001;
     FILE_TYPE_CHAR      =$0002;
     FILE_TYPE_PIPE      =$0003;
     FILE_TYPE_REMOTE    =$8000;

CONST
     {Standard handles}
     STD_INPUT_HANDLE    =-10;
     STD_OUTPUT_HANDLE   =-11;
     STD_ERROR_HANDLE    =-12;

CONST
     NOPARITY            =0;
     ODDPARITY           =1;
     EVENPARITY          =2;
     MARKPARITY          =3;
     SPACEPARITY         =4;

     ONESTOPBIT          =0;
     ONE5STOPBITS        =1;
     TWOSTOPBITS         =2;

     IGNORE              =0;
     INFINITE            =$FFFFFFFF;

CONST
     {Baud rates}
     CBR_110             =110;
     CBR_300             =300;
     CBR_600             =600;
     CBR_1200            =1200;
     CBR_2400            =2400;
     CBR_4800            =4800;
     CBR_9600            =9600;
     CBR_14400           =14400;
     CBR_19200           =19200;
     CBR_38400           =38400;
     CBR_56000           =56000;
     CBR_57600           =57600;
     CBR_115200          =115200;
     CBR_128000          =128000;
     CBR_256000          =256000;

CONST
    {Error Flags}
    CE_RXOVER            =$0001;  // Receive Queue overflow
    CE_OVERRUN           =$0002;  // Receive Overrun Error
    CE_RXPARITY          =$0004;  // Receive Parity Error
    CE_FRAME             =$0008;  // Receive Framing error
    CE_BREAK             =$0010;  // Break Detected
    CE_TXFULL            =$0100;  // TX Queue is full
    CE_PTO               =$0200;  // LPTx Timeout
    CE_IOE               =$0400;  // LPTx I/O Error
    CE_DNS               =$0800;  // LPTx Device not selected
    CE_OOP               =$1000;  // LPTx Out-Of-Paper
    CE_MODE              =$8000;  // Requested mode unsupported

    IE_BADID             =-1;     // Invalid or unsupported id
    IE_OPEN              =-2;     // Device Already Open
    IE_NOPEN             =-3;     // Device Not Open
    IE_MEMORY            =-4;     // Unable to allocate queues
    IE_DEFAULT           =-5;     // Error in default parameters
    IE_HARDWARE          =-10;    // Hardware Not Present
    IE_BYTESIZE          =-11;    // Illegal Byte Size
    IE_BAUDRATE          =-12;    // Unsupported BaudRate

CONST
    {Events}
    EV_RXCHAR           =$0001;  // Any Character received
    EV_RXFLAG           =$0002;  // Received certain character
    EV_TXEMPTY          =$0004;  // Transmitt Queue Empty
    EV_CTS              =$0008;  // CTS changed state
    EV_DSR              =$0010;  // DSR changed state
    EV_RLSD             =$0020;  // RLSD changed state
    EV_BREAK            =$0040;  // BREAK received
    EV_ERR              =$0080;  // Line status error occurred
    EV_RING             =$0100;  // Ring signal detected
    EV_PERR             =$0200;  // Printer error occured
    EV_RX80FULL         =$0400;  // Receive buffer is 80 percent full
    EV_EVENT1           =$0800;  // Provider specific event 1
    EV_EVENT2           =$1000;  // Provider specific event 2

    {Escape Functions}
    SETXOFF             =1;       // Simulate XOFF received
    SETXON              =2;       // Simulate XON received
    SETRTS              =3;       // Set RTS high
    CLRRTS              =4;       // Set RTS low
    SETDTR              =5;       // Set DTR high
    CLRDTR              =6;       // Set DTR low
    RESETDEV            =7;       // Reset device if possible
    SETBREAK            =8;       // Set the device break line.
    CLRBREAK            =9;       // Clear the device break line.

    PURGE_TXABORT       =$0001;
    PURGE_RXABORT       =$0002;
    PURGE_TXCLEAR       =$0004;
    PURGE_RXCLEAR       =$0008;

    LPTx                =$80;    // Set if ID is for LPT device

    {Modem Status Flags}
    MS_CTS_ON           =$0010;
    MS_DSR_ON           =$0020;
    MS_RING_ON          =$0040;
    MS_RLSD_ON          =$0080;

    S_QUEUEEMPTY        =0;
    S_THRESHOLD         =1;
    S_ALLTHRESHOLD      =2;

    S_NORMAL      =0;
    S_LEGATO      =1;
    S_STACCATO    =2;

    S_PERIOD512   =0;
    S_PERIOD1024  =1;
    S_PERIOD2048  =2;
    S_PERIODVOICE =3;
    S_WHITE512    =4;
    S_WHITE1024   =5;
    S_WHITE2048   =6;
    S_WHITEVOICE  =7;

    S_SERDVNA     =-1;  // Device not available
    S_SEROFM      =-2;  // Out of memory
    S_SERMACT     =-3;  // Music active
    S_SERQFUL     =-4;  // Queue full
    S_SERBDNT     =-5;  // Invalid note
    S_SERDLN      =-6;  // Invalid note length
    S_SERDCC      =-7;  // Invalid note count
    S_SERDTP      =-8;  // Invalid tempo
    S_SERDVL      =-9;  // Invalid volume
    S_SERDMD      =-10; // Invalid mode
    S_SERDSH      =-11; // Invalid shape
    S_SERDPT      =-12; // Invalid pitch
    S_SERDFQ      =-13; // Invalid frequency
    S_SERDDR      =-14; // Invalid duration
    S_SERDSR      =-15; // Invalid source
    S_SERDST      =-16; // Invalid state

    NMPWAIT_WAIT_FOREVER       =$ffffffff;
    NMPWAIT_NOWAIT             =$00000001;
    NMPWAIT_USE_DEFAULT_WAIT   =$00000000;

    FS_CASE_IS_PRESERVED       =FILE_CASE_PRESERVED_NAMES;
    FS_CASE_SENSITIVE          =FILE_CASE_SENSITIVE_SEARCH;
    FS_UNICODE_STORED_ON_DISK  =FILE_UNICODE_ON_DISK;
    FS_PERSISTENT_ACLS         =FILE_PERSISTENT_ACLS;
    FS_VOL_IS_COMPRESSED       =FILE_VOLUME_IS_COMPRESSED;
    FS_FILE_COMPRESSION        =FILE_FILE_COMPRESSION;


CONST
     {Open file flags}
     OF_READ             =$00000000;
     OF_WRITE            =$00000001;
     OF_READWRITE        =$00000002;
     OF_SHARE_COMPAT     =$00000000;
     OF_SHARE_EXCLUSIVE  =$00000010;
     OF_SHARE_DENY_WRITE =$00000020;
     OF_SHARE_DENY_READ  =$00000030;
     OF_SHARE_DENY_NONE  =$00000040;
     OF_PARSE            =$00000100;
     OF_DELETE           =$00000200;
     OF_VERIFY           =$00000400;
     OF_CANCEL           =$00000800;
     OF_CREATE           =$00001000;
     OF_PROMPT           =$00002000;
     OF_EXIST            =$00004000;
     OF_REOPEN           =$00008000;

     OFS_MAXPATHNAME     =128;

TYPE
    {Open file structure}
    POFSTRUCT=^OFSTRUCT;
    OFSTRUCT=RECORD
                   cBytes:BYTE;
                   fFixedDisk:BYTE;
                   nErrCode:WORD;
                   Reserved1:WORD;
                   Reserved2:WORD;
                   szPathName:ARRAY[0..OFS_MAXPATHNAME-1] OF CHAR;
    END;

    PPROCESS_HEAP_ENTRY=^PROCESS_HEAP_ENTRY;
    PROCESS_HEAP_ENTRY=RECORD
                             lpData:POINTER;
                             cbData:ULONG;
                             cbOverhead:BYTE;
                             iRegionIndex:BYTE;
                             wFlags:WORD;
                             CASE Integer OF
                               1:(Block:RECORD
                                              hMem:HANDLE;
                                              dwReserved:ARRAY[0..2] OF ULONG;
                                        END);
                               2:(Region:RECORD
                                              dwCommittedSize:ULONG;
                                              dwUnCommittedSize:ULONG;
                                              lpFirstBlock:POINTER;
                                              lpLastBlock:POINTER;
                                         END);
    END;
    LPPROCESS_HEAP_ENTRY=PPROCESS_HEAP_ENTRY;

CONST
     PROCESS_HEAP_REGION             =$0001;
     PROCESS_HEAP_UNCOMMITTED_RANGE  =$0002;
     PROCESS_HEAP_ENTRY_BUSY         =$0004;
     PROCESS_HEAP_ENTRY_MOVEABLE     =$0010;
     PROCESS_HEAP_ENTRY_DDESHARE     =$0020;

CONST
     SCS_32BIT_BINARY    =0;
     SCS_DOS_BINARY      =1;
     SCS_WOW_BINARY      =2;
     SCS_PIF_BINARY      =3;
     SCS_POSIX_BINARY    =4;
     SCS_OS216_BINARY    =5;

CONST
     SEM_FAILCRITICALERRORS      =$0001;
     SEM_NOGPFAULTERRORBOX       =$0002;
     SEM_NOALIGNMENTFAULTEXCEPT  =$0004;
     SEM_NOOPENFILEERRORBOX      =$8000;

CONST
     LOCKFILE_FAIL_IMMEDIATELY   =$00000001;
     LOCKFILE_EXCLUSIVE_LOCK     =$00000002;

TYPE
    PBY_HANDLE_FILE_INFORMATION=^BY_HANDLE_FILE_INFORMATION;
    BY_HANDLE_FILE_INFORMATION=RECORD
                                     dwFileAttributes:ULONG;
                                     ftCreationTime:FILETIME;
                                     ftLastAccessTime:FILETIME;
                                     ftLastWriteTime:FILETIME;
                                     dwVolumeSerialNumber:ULONG;
                                     nFileSizeHigh:ULONG;
                                     nFileSizeLow:ULONG;
                                     nNumberOfLinks:ULONG;
                                     nFileIndexHigh:ULONG;
                                     nFileIndexLow:ULONG;
    END;
    LPBY_HANDLE_FILE_INFORMATION=PBY_HANDLE_FILE_INFORMATION;

CONST
     HANDLE_FLAG_INHERIT             =$00000001;
     HANDLE_FLAG_PROTECT_FROM_CLOSE  =$00000002;

     HINSTANCE_ERROR                 =32;

CONST
     GET_TAPE_MEDIA_INFORMATION      =0;
     GET_TAPE_DRIVE_INFORMATION      =1;

     SET_TAPE_MEDIA_INFORMATION      =0;
     SET_TAPE_DRIVE_INFORMATION      =1;

TYPE
    PTIME_ZONE_INFORMATION=^TIME_ZONE_INFORMATION;
    TIME_ZONE_INFORMATION=RECORD
                                Bias:LONG;
                                StandardName:ARRAY[0..31] OF WCHAR;
                                StandardDate:SYSTEMTIME;
                                StandardBias:LONG;
                                DaylightName:ARRAY[0..31] OF WCHAR;
                                DaylightDate:SYSTEMTIME;
                                DaylightBias:LONG;
    END;
    LPTIME_ZONE_INFORMATION=PTIME_ZONE_INFORMATION;

CONST
     FORMAT_MESSAGE_ALLOCATE_BUFFER =$00000100;
     FORMAT_MESSAGE_IGNORE_INSERTS  =$00000200;
     FORMAT_MESSAGE_FROM_STRING     =$00000400;
     FORMAT_MESSAGE_FROM_HMODULE    =$00000800;
     FORMAT_MESSAGE_FROM_SYSTEM     =$00001000;
     FORMAT_MESSAGE_ARGUMENT_ARRAY  =$00002000;
     FORMAT_MESSAGE_MAX_WIDTH_MASK  =$000000FF;

CONST
     TLS_OUT_OF_INDEXES             =$FFFFFFFF;

TYPE
    LPWIN32_STREAM_ID=^WIN32_STREAM_ID;
    WIN32_STREAM_ID=RECORD
                          dwStreamId:ULONG ;
                          dwStreamAttributes:ULONG ;
                          Size:LARGE_INTEGER;
                          dwStreamNameSize:ULONG ;
                          cStreamName:ARRAY[0..ANYSIZE_ARRAY-1] OF WCHAR ;
    END;

CONST
     {Stream Ids}
     BACKUP_INVALID          =$00000000;
     BACKUP_DATA             =$00000001;
     BACKUP_EA_DATA          =$00000002;
     BACKUP_SECURITY_DATA    =$00000003;
     BACKUP_ALTERNATE_DATA   =$00000004;
     BACKUP_LINK             =$00000005;
     BACKUP_PROPERTY_DATA    =$00000006;

     {Stream Attributes}
     STREAM_NORMAL_ATTRIBUTE    =$00000000;
     STREAM_MODIFIED_WHEN_READ  =$00000001;
     STREAM_CONTAINS_SECURITY   =$00000002;
     STREAM_CONTAINS_PROPERTIES =$00000004;

     STARTF_USESHOWWINDOW    =$00000001;
     STARTF_USESIZE          =$00000002;
     STARTF_USEPOSITION      =$00000004;
     STARTF_USECOUNTCHARS    =$00000008;
     STARTF_USEFILLATTRIBUTE =$00000010;
     STARTF_RUNFULLSCREEN    =$00000020;
     STARTF_FORCEONFEEDBACK  =$00000040;
     STARTF_FORCEOFFFEEDBACK =$00000080;
     STARTF_USESTDHANDLES    =$00000100;

TYPE
    PSTARTUPINFO=^STARTUPINFO;
    STARTUPINFO=RECORD
                      cb:ULONG;
                      lpReserved:LPSTR;
                      lpDesktop:LPSTR;
                      lpTitle:LPSTR;
                      dwX:ULONG;
                      dwY:ULONG;
                      dwXSize:ULONG;
                      dwYSize:ULONG;
                      dwXCountChars:ULONG;
                      dwYCountChars:ULONG;
                      dwFillAttribute:ULONG;
                      dwFlags:ULONG;
                      wShowWindow:WORD;
                      cbReserved2:WORD;
                      lpReserved2:LPBYTE;
                      hStdInput:HANDLE;
                      hStdOutput:HANDLE;
                      hStdError:HANDLE;
    END;
    LPSTARTUPINFO=PSTARTUPINFO;

CONST
     SHUTDOWN_NORETRY                =$00000001;

TYPE
     PWIN32_FIND_DATA=^WIN32_FIND_DATA;
     WIN32_FIND_DATA=RECORD
                           dwFileAttributes:ULONG;
                           ftCreationTime:FILETIME;
                           ftLastAccessTime:FILETIME;
                           ftLastWriteTime:FILETIME;
                           nFileSizeHigh:ULONG;
                           nFileSizeLow:ULONG;
                           dwReserved0:ULONG;
                           dwReserved1:ULONG;
                           cFileName:ARRAY[0..MAX_PATH-1] OF CHAR;
                           cAlternateFileName:ARRAY[0..14] OF CHAR;
     END;
     LPWIN32_FIND_DATA=PWIN32_FIND_DATA;

CONST
     DONT_RESOLVE_DLL_REFERENCES     =$00000001;
     LOAD_LIBRARY_AS_DATAFILE        =$00000002;
     LOAD_WITH_ALTERED_SEARCH_PATH   =$00000008;

TYPE
    ENUMRESTYPEPROC=FUNCTION(hModule:HINSTANCE;lpType:LPTSTR;lParam:LONG):BOOL;
    ENUMRESNAMEPROC=FUNCTION(hModule:HINSTANCE;lpType:LPCTSTR;lpName:LPTSTR;lParam:LONG):BOOL;
    ENUMRESLANGPROC=FUNCTION(hModule:HINSTANCE;lpType:LPCTSTR;lpName:LPCTSTR;wLanguage:WORD;
                             lParam:LONG):BOOL;

CONST
     DDD_RAW_TARGET_PATH         =$00000001;
     DDD_REMOVE_DEFINITION       =$00000002;
     DDD_EXACT_MATCH_ON_REMOVE   =$00000004;

     MOVEFILE_REPLACE_EXISTING   =$00000001;
     MOVEFILE_COPY_ALLOWED       =$00000002;
     MOVEFILE_DELAY_UNTIL_REBOOT =$00000004;

CONST
     MAX_COMPUTERNAME_LENGTH =15;

TYPE
    POSVERSIONINFO=^OSVERSIONINFO;
    OSVERSIONINFO=RECORD
                        dwOSVersionInfoSize:ULONG;
                        dwMajorVersion:ULONG;
                        dwMinorVersion:ULONG;
                        dwBuildNumber:ULONG;
                        dwPlatformId:ULONG;
                        szCSDVersion:ARRAY[0..127] OF CHAR;
    END;
    LPOSVERSIONINFO=POSVERSIONINFO;

CONST
     VER_PLATFORM_WIN32s         =0;
     VER_PLATFORM_WIN32_NT       =2;

CONST
     {Termination codes}
     TC_NORMAL       =0;
     TC_HARDERR      =1;
     TC_GP_TRAP      =2;
     TC_SIGNAL       =3;

CONST
    EXCEPTION_EXECUTE_HANDLER       = 1;
    EXCEPTION_CONTINUE_SEARCH       = 0;
    EXCEPTION_CONTINUE_EXECUTION    =-1;

TYPE
    PTOP_LEVEL_EXCEPTION_FILTER=FUNCTION(VAR ExceptionInfo:EXCEPTION_POINTERS):LONG;APIENTRY;
    LPTOP_LEVEL_EXCEPTION_FILTER=PTOP_LEVEL_EXCEPTION_FILTER;

    LPOVERLAPPED_COMPLETION_ROUTINE=PROCEDURE(dwErrorCode:ULONG;
                                              dwNumberOfBytesTransfered:ULONG;
                                              VAR lpOverlapped:OVERLAPPED);APIENTRY;

    CRITICAL_SECTION=RECORD
                           ulReserved:ARRAY[0..7] OF LONGWORD;
    END;
    PCRITICAL_SECTION=^CRITICAL_SECTION;

TYPE
  SECURITY_CONTEXT_TRACKING_MODE = Boolean;

  TSecurityImpersonationLevel = (SecurityAnonymous,
                                 SecurityIdentification,
                                 SecurityImpersonation,
                                 SecurityDelegation);

  PSecurityQualityOfService = ^TSecurityQualityOfService;
  TSecurityQualityOfService=RECORD
    Length: LongWord;
    ImpersonationLevel: TSecurityImpersonationLevel;
    ContextTrackingMode: SECURITY_CONTEXT_TRACKING_MODE;
    EffectiveOnly: Boolean;
  End;


{ Konstanten fuer die Funktion: GetLocaleInfoA }
Const LOCALE_ILANGUAGE            = $01;
      LOCALE_SLANGUAGE            = $02;
      LOCALE_SENGLANGUAGE         = $1001;
      LOCALE_SABBREVLANGNAME      = $03;
      LOCALE_SNATIVELANGNAME      = $04;
      LOCALE_ICOUNTRY             = $05;
      LOCALE_SCOUNTRY             = $06;
      LOCALE_SENGCOUNTRY          = $1002;
      LOCALE_SABBREVCTRYNAME      = $07;
      LOCALE_SNATIVECTRYNAME      = $08;
      LOCALE_IDEFAULTLANGUAGE     = $09;
      LOCALE_IDEFAULTCOUNTRY      = $0A;
      LOCALE_IDEFAULTCODEPAGE     = $0B;
      LOCALE_SLIST                = $0C;
      LOCALE_IMEASURE             = $0D;
      LOCALE_SDECIMAL             = $0E;
      LOCALE_STHOUSAND            = $0F;
      LOCALE_SGROUPING            = $10;
      LOCALE_IDIGITS              = $11;
      LOCALE_ILZERO               = $12;
      LOCALE_SNATIVEDIGITS        = $13;
      LOCALE_SCURRENCY            = $14;
      LOCALE_SINTLSYMBOL          = $15;
      LOCALE_SMONDECIMALSEP       = $16;
      LOCALE_SMONTHOUSANDSEP      = $17;
      LOCALE_SMONGROUPING         = $18;
      LOCALE_ICURRDIGITS          = $19;
      LOCALE_IINTLCURRDIGITS      = $1A;
      LOCALE_ICURRENCY            = $1B;
      LOCALE_INEGCURR             = $1C;
      LOCALE_SDATE                = $1D;
      LOCALE_STIME                = $1E;
      LOCALE_SSHORTDATE           = $1F;
      LOCALE_SLONGDATE            = $20;
      LOCALE_STIMEFORMAT          = $1003;
      LOCALE_IDATE                = $21;
      LOCALE_ILDATE               = $22;
      LOCALE_ITIME                = $23;
      LOCALE_ICENTURY             = $24;
      LOCALE_ITLZERO              = $25;
      LOCALE_IDAYLZERO            = $26;
      LOCALE_IMONLZERO            = $27;
      LOCALE_S1159                = $28;
      LOCALE_S2359                = $29;
      LOCALE_SDAYNAME1            = $2A;
      LOCALE_SDAYNAME2            = $2B;
      LOCALE_SDAYNAME3            = $2C;
      LOCALE_SDAYNAME4            = $2D;
      LOCALE_SDAYNAME5            = $2E;
      LOCALE_SDAYNAME6            = $2F;
      LOCALE_SDAYNAME7            = $30;
      LOCALE_SABBREVDAYNAME1      = $31;
      LOCALE_SABBREVDAYNAME2      = $32;
      LOCALE_SABBREVDAYNAME3      = $33;
      LOCALE_SABBREVDAYNAME4      = $34;
      LOCALE_SABBREVDAYNAME5      = $35;
      LOCALE_SABBREVDAYNAME6      = $36;
      LOCALE_SABBREVDAYNAME7      = $37;
      LOCALE_SMONTHNAME1          = $38;
      LOCALE_SMONTHNAME2          = $39;
      LOCALE_SMONTHNAME3          = $3A;
      LOCALE_SMONTHNAME4          = $3B;
      LOCALE_SMONTHNAME5          = $3C;
      LOCALE_SMONTHNAME6          = $3D;
      LOCALE_SMONTHNAME7          = $3E;
      LOCALE_SMONTHNAME8          = $3F;
      LOCALE_SMONTHNAME9          = $40;
      LOCALE_SMONTHNAME10         = $41;
      LOCALE_SMONTHNAME11         = $42;
      LOCALE_SMONTHNAME12         = $43;
      LOCALE_SABBREVMONTHNAME1    = $44;
      LOCALE_SABBREVMONTHNAME2    = $45;
      LOCALE_SABBREVMONTHNAME3    = $46;
      LOCALE_SABBREVMONTHNAME4    = $47;
      LOCALE_SABBREVMONTHNAME5    = $48;
      LOCALE_SABBREVMONTHNAME6    = $49;
      LOCALE_SABBREVMONTHNAME7    = $4A;
      LOCALE_SABBREVMONTHNAME8    = $4B;
      LOCALE_SABBREVMONTHNAME9    = $4C;
      LOCALE_SABBREVMONTHNAME10   = $4D;
      LOCALE_SABBREVMONTHNAME11   = $4E;
      LOCALE_SABBREVMONTHNAME12   = $4F;
      LOCALE_SABBREVMONTHNAME13   = $100F;
      LOCALE_SPOSITIVESIGN        = $50;
      LOCALE_SNEGATIVESIGN        = $51;
      LOCALE_IPOSSIGNPOSN         = $52;
      LOCALE_INEGSIGNPOSN         = $53;
      LOCALE_IPOSSYMPRECEDES      = $54;
      LOCALE_IPOSSEPBYSPACE       = $55;
      LOCALE_INEGSYMPRECEDES      = $56;
      LOCALE_INEGSEPBYSPACE       = $57;

{ default color table indices }
      CLR_BLACK         = $00000000;
      CLR_DARKBLUE      = $00FF0000;
      CLR_DARKGREEN     = $00008000;
      CLR_DARKCYAN      = $00FFFF00;
      CLR_DARKRED       = $000000FF;
      CLR_DARKPINK      = $00800080;
      CLR_BROWN         = $00FF00FF;
      CLR_PALEGRAY      = $00C0C0C0;
      CLR_DARKGRAY      = $00808080;
      CLR_BLUE          = $00FF0000;
      CLR_GREEN         = $00008000;
      CLR_CYAN          = $00FFFF00;
      CLR_RED           = $000000FF;
      CLR_PINK          = $00800080;
      CLR_YELLOW        = $0000FFFF;
      CLR_WHITE         = $00FFFFFF;

Const CDERR_DIALOGFAILURE      = $FFFF;
      CDERR_GENERALCODES       = $0000;
      CDERR_STRUCTSIZE         = $0001;
      CDERR_INITIALIZATION     = $0002;
      CDERR_NOTEMPLATE         = $0003;
      CDERR_NOHINSTANCE        = $0004;
      CDERR_LOADSTRFAILURE     = $0005;
      CDERR_FINDRESFAILURE     = $0006;
      CDERR_LOADRESFAILURE     = $0007;
      CDERR_LOCKRESFAILURE     = $0008;
      CDERR_MEMALLOCFAILURE    = $0009;
      CDERR_MEMLOCKFAILURE     = $000A;
      CDERR_NOHOOK             = $000B;
      CDERR_REGISTERMSGFAIL    = $000C;

      PDERR_PRINTERCODES       = $1000;
      PDERR_SETUPFAILURE       = $1001;
      PDERR_PARSEFAILURE       = $1002;
      PDERR_RETDEFFAILURE      = $1003;
      PDERR_LOADDRVFAILURE     = $1004;
      PDERR_GETDEVMODEFAIL     = $1005;
      PDERR_INITFAILURE        = $1006;
      PDERR_NODEVICES          = $1007;
      PDERR_NODEFAULTPRN       = $1008;
      PDERR_DNDMMISMATCH       = $1009;
      PDERR_CREATEICFAILURE    = $100A;
      PDERR_PRINTERNOTFOUND    = $100B;
      PDERR_DEFAULTDIFFERENT   = $100C;

      CFERR_CHOOSEFONTCODES    = $2000;
      CFERR_NOFONTS            = $2001;
      CFERR_MAXLESSTHANMIN     = $2002;

      FNERR_FILENAMECODES      = $3000;
      FNERR_SUBCLASSFAILURE    = $3001;
      FNERR_INVALIDFILENAME    = $3002;
      FNERR_BUFFERTOOSMALL     = $3003;

      FRERR_FINDREPLACECODES   = $4000;
      FRERR_BUFFERLENGTHZERO   = $4001;

      CCERR_CHOOSECOLORCODES   = $5000;


IMPORTS
       FUNCTION InterlockedIncrement(VAR lpAppend:LONG):LONG;
                  APIENTRY;  'KERNEL32' name 'InterlockedIncrement';
       FUNCTION InterlockedDecrement(VAR lpAddend:LONG):LONG;
                  APIENTRY;  'KERNEL32' name 'InterlockedDecrement';
       FUNCTION InterlockedExchange(VAR Target:LONG;Value:LONG):LONG;
                  APIENTRY;  'KERNEL32' name 'InterlockedExchange';
       FUNCTION FreeResource(hResData:HGLOBAL):BOOL;
                  APIENTRY;  'KERNEL32' name 'FreeResource';
       FUNCTION LockResource(hResData:HGLOBAL):POINTER;
                  APIENTRY;  'KERNEL32' name 'LockResource';
       FUNCTION FreeLibrary(hLibModule:HINSTANCE):BOOL;
                  APIENTRY;  'KERNEL32' name 'FreeLibrary';
       PROCEDURE FreeLibraryAndExitThread(hLibModule:HMODULE;dwExitCode:ULONG);
                  APIENTRY;  'KERNEL32' name 'FreeLibraryAndExitThread';
       FUNCTION DisableThreadLibraryCalls(hLibModule:HMODULE):BOOL;
                  APIENTRY;  'KERNEL32' name 'DisableThreadLibraryCalls';
       FUNCTION GetProcAddress(hModule:HINSTANCE;CONST lpProcName:CSTRING):POINTER;
                  APIENTRY;  'KERNEL32' name 'GetProcAddress';
       FUNCTION GetVersion:ULONG;
                  APIENTRY;  'KERNEL32' name 'GetVersion';
{ Bit 0  ... Bit 7  (1. Byte)  = Version       = Lo(LoWord(x))
  Bit 7  ... Bit 15 (2. Byte)  = Revision      = Hi(LoWord(x))
  Bit 16 ... Bit 30            = reserviert
  Bit 31                       = Plattform  
Als Rckgabewert erhlt man ein ULong. 
Das h”herwertige Wort enthlt die Betriebssystem-Plattform.
Das h”chstwertitgen Bit bedeutet 0=WinNT und 1=Win32s mit Win3.1. Die
restlichen Bits sind reserviert. }

       FUNCTION GlobalAlloc(uFlags:ULONG;dwBytes:ULONG):HGLOBAL;
                  APIENTRY;  'KERNEL32' name 'GlobalAlloc';
       FUNCTION GlobalReAlloc(hMem:HGLOBAL;dwBytes:ULONG;uFlags:ULONG):HGLOBAL;
                  APIENTRY;  'KERNEL32' name 'GlobalReAlloc';
       FUNCTION GlobalSize(hMem:HGLOBAL):ULONG;
                  APIENTRY;  'KERNEL32' name 'GlobalSize';
       FUNCTION GlobalFlags(hMem:HGLOBAL):ULONG;
                  APIENTRY;  'KERNEL32' name 'GlobalFlags';
       FUNCTION GlobalLock(hMem:HGLOBAL):POINTER;
                  APIENTRY;  'KERNEL32' name 'GlobalLock';
       FUNCTION GlobalHandle(pMem:POINTER):HGLOBAL;
                  APIENTRY;  'KERNEL32' name 'GlobalHandle';
       FUNCTION GlobalUnlock(hMem:HGLOBAL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GlobalUnlock';
       FUNCTION GlobalFree(hMem:HGLOBAL):HGLOBAL;
                  APIENTRY;  'KERNEL32' name 'GlobalFree';
       FUNCTION GlobalCompact(dwMinFree:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GlobalCompact';
       PROCEDURE GlobalFix(hMem:HGLOBAL);
                  APIENTRY;  'KERNEL32' name 'GlobalFix';
       PROCEDURE GlobalUnfix(hMem:HGLOBAL);
                  APIENTRY;  'KERNEL32' name 'GlobalUnfix';
       FUNCTION GlobalWire(hMem:HGLOBAL):POINTER;
                  APIENTRY;  'KERNEL32' name 'GlobalWire';
       FUNCTION GlobalUnWire(hMem:HGLOBAL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GlobalUnWire';
       PROCEDURE GlobalMemoryStatus(VAR lpBuffer:MEMORYSTATUS);
                  APIENTRY;  'KERNEL32' name 'GlobalMemoryStatus';
       FUNCTION LocalAlloc(uFlags:ULONG;uBytes:ULONG):HLOCAL;
                  APIENTRY;  'KERNEL32' name 'LocalAlloc';
       FUNCTION LocalReAlloc(hMem:HLOCAL;uBytes:ULONG;uFlags:ULONG):HLOCAL;
                  APIENTRY;  'KERNEL32' name 'LocalReAlloc';
       FUNCTION LocalLock(hMem:HLOCAL):POINTER;
                  APIENTRY;  'KERNEL32' name 'LocalLock';
       FUNCTION LocalHandle(pMem:POINTER):HLOCAL;
                  APIENTRY;  'KERNEL32' name 'LocalHandle';
       FUNCTION LocalUnlock(hMem:HLOCAL):BOOL;
                  APIENTRY;  'KERNEL32' name 'LocalUnlock';
       FUNCTION LocalSize(hMem:HLOCAL):ULONG;
                  APIENTRY;  'KERNEL32' name 'LocalSize';
       FUNCTION LocalFlags(hMem:HLOCAL):ULONG;
                  APIENTRY;  'KERNEL32' name 'LocalFlags';
       FUNCTION LocalFree(hMem:HLOCAL):HLOCAL;
                  APIENTRY;  'KERNEL32' name 'LocalFree';
       FUNCTION LocalShrink(hMem:HLOCAL;cbNewSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'LocalShrink';
       FUNCTION LocalCompact(uMinFree:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'LocalCompact';
       FUNCTION FlushInstructionCache(hProcess:HANDLE;lpBaseAddress:POINTER;
                                      dwSize:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'FlushInstructionCache';
       FUNCTION VirtualAlloc(lpAddress:POINTER;dwSize:ULONG;flAllocationType:ULONG;
                             flProtect:ULONG):POINTER;
                  APIENTRY;  'KERNEL32' name 'VirtualAlloc';
       FUNCTION VirtualFree(lpAddress:POINTER;dwSize:ULONG;dwFreeType:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'VirtualFree';
       FUNCTION VirtualProtect(lpAddress:POINTER;dwSize:ULONG;flNewProtect:ULONG;
                               VAR lpflOldProtect:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'VirtualProtect';
       FUNCTION VirtualQuery(lpAddress:POINTER;VAR lpBuffer:MEMORY_BASIC_INFORMATION;
                             dwLength:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'VirtualQuery';
       FUNCTION VirtualProtectEx(hProcess:HANDLE;lpAddress:POINTER;dwSize:ULONG;
                                 flNewProtect:ULONG;VAR lpflOldProtect:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'VirtualProtectEx';
       FUNCTION VirtualQueryEx(hProcess:HANDLE;lpAddress:POINTER;
                               VAR lpBuffer:MEMORY_BASIC_INFORMATION;
                               dwLength:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'VirtualQueryEx';
       FUNCTION HeapCreate(flOptions:ULONG;dwInitialSize:ULONG;
                           dwMaximumSize:ULONG):HANDLE;
                  APIENTRY;  'KERNEL32' name 'HeapCreate';
       FUNCTION HeapDestroy(hHeap:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'HeapDestroy';
       FUNCTION HeapAlloc(hHeap:HANDLE;dwFlags,dwBytes:ULONG):POINTER;
                  APIENTRY;  'KERNEL32' name 'HeapAlloc';
       FUNCTION HeapReAlloc(hHeap:HANDLE;dwFlags:ULONG;lpMem:POINTER;
                            dwBytes:ULONG):POINTER;
                  APIENTRY;  'KERNEL32' name 'HeapReAlloc';
       FUNCTION HeapFree(hHeap:HANDLE;dwFlags:ULONG;lpMem:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'HeapFree';
       FUNCTION HeapSize(hHeap:HANDLE;dwFlags:ULONG;lpMem:POINTER):ULONG;
                  APIENTRY;  'KERNEL32' name 'HeapSize';
       FUNCTION HeapValidate(hHeap:HANDLE;dwFlags:ULONG;lpMem:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'HeapValidate';
       FUNCTION HeapCompact(hHeap:HANDLE;dwFlags:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'HeapCompact';
       FUNCTION GetProcessHeap:HANDLE;
                  APIENTRY;  'KERNEL32' name 'GetProcessHeap';
       FUNCTION GetProcessHeaps(NumberOfHeaps:ULONG;VAR ProcessHeaps:HANDLE):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetProcessHeaps';
       FUNCTION HeapLock(hHeap:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'HeapLock';
       FUNCTION HeapUnlock(hHeap:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'HeapUnlock';
       FUNCTION HeapWalk(hHeap:HANDLE;VAR lpEntry:PROCESS_HEAP_ENTRY):BOOL;
                  APIENTRY;  'KERNEL32' name 'HeapWalk';
       FUNCTION GetBinaryType(CONST lpApplicationName:CSTRING;
                              VAR lpBinaryType:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetBinaryTypeA';
       FUNCTION GetShortPathName(CONST lpszLongPath:CSTRING;
                                 VAR lpszShortPath:CSTRING;cchBuffer:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetShortPathNameA';
       FUNCTION GetProcessAffinityMask(hProcess:HANDLE;VAR lpProcessAffinityMask,
                                       lpSystemAffinityMask:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetProcessAffinityMask';
       FUNCTION GetProcessTimes(hProcess:HANDLE;VAR lpCreationTime,
                                lpExitTime,lpKernelTime,lpUserTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetProcessTimes';
       FUNCTION GetProcessWorkingSetSize(hProcess:HANDLE;VAR Min,Max:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetProcessWorkingSetSize';
       FUNCTION SetProcessWorkingSetSize(hProcess:HANDLE;Min,Max:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetProcessWorkingSetSize';
       FUNCTION OpenProcess(dwDesiredAccess:ULONG;bInheritHandle:BOOL;
                            dwProcessId:ULONG):HANDLE;
                  APIENTRY;  'KERNEL32' name 'OpenProcess';
       FUNCTION GetCurrentProcess:HANDLE;
                  APIENTRY;  'KERNEL32' name 'GetCurrentProcess';
       FUNCTION GetCurrentProcessId:ULONG;
                  APIENTRY;  'KERNEL32' name 'GetCurrentProcessId';
       PROCEDURE ExitProcess(uExitCode:ULONG);
                  APIENTRY;  'KERNEL32' name 'ExitProcess';
       FUNCTION TerminateProcess(hProcess:HANDLE;uExitCode:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'TerminateProcess';
       FUNCTION GetExitCodeProcess(hProcess:HANDLE;VAR lpExitCode:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetExitCodeProcess';
       PROCEDURE FatalExit(ExitCode:LONGINT);
                  APIENTRY;  'KERNEL32' name 'FatalExit';
       FUNCTION GetEnvironmentStrings:PChar;
                  APIENTRY;  'KERNEL32' name 'GetEnvironmentStrings'; {A ??}
       FUNCTION FreeEnvironmentStrings(p:PChar):BOOL;
                  APIENTRY;  'KERNEL32' name 'FreeEnvironmentStringsA';
       PROCEDURE RaiseException(dwExceptionCode,dwExceptionFlags:ULONG;
                                nNumberOfArguments:ULONG;VAR lpArguments);
                  APIENTRY;  'KERNEL32' name 'RaiseException';
       FUNCTION UnhandledExceptionFilter(VAR ExceptionInfo:EXCEPTION_POINTERS):LONG;
                  APIENTRY;  'KERNEL32' name 'UnhandledExceptionFilter';
       FUNCTION SetUnhandledExceptionFilter(lpTopLevelFilter:PTOP_LEVEL_EXCEPTION_FILTER):
                                LPTOP_LEVEL_EXCEPTION_FILTER;
                  APIENTRY;  'KERNEL32' name 'SetUnhandledExceptionFilter';
       FUNCTION CreateThread(VAR ThreadAttrs:SECURITY_ATTRIBUTES;Stack:ULONG;
                             lpStartAddress:LPTHREAD_START_ROUTINE;
                             lpParameter:POINTER;dwCreationFlags:ULONG;
                             VAR lpThreadId:ULONG):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateThread';
       FUNCTION CreateRemoteThread(hProcess:HANDLE;VAR Attrs:SECURITY_ATTRIBUTES;
                                   dwStack:ULONG;lpStartAddr:LPTHREAD_START_ROUTINE;
                                   lpParameter:POINTER;dwCreationFlags:ULONG;
                                   VAR lpThreadId:ULONG):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateRemoteThread';
       FUNCTION GetCurrentThread:HANDLE;
                  APIENTRY;  'KERNEL32' name 'GetCurrentThread';
       FUNCTION GetCurrentThreadId:ULONG;
                  APIENTRY;  'KERNEL32' name 'GetCurrentThreadId';
       FUNCTION SetThreadAffinityMask(hThread:HANDLE;dwMask:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetThreadAffinityMask';
       FUNCTION SetThreadPriority(hThread:HANDLE;nPriority:LONGINT):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetThreadPriority';
       FUNCTION GetThreadPriority(hThread:HANDLE):LONGINT;
                  APIENTRY;  'KERNEL32' name 'GetThreadPriority';
       FUNCTION GetThreadTimes(hThread:HANDLE;VAR lpCreationTime,
                               lpExitTime,lpKernelTime,lpUserTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetThreadTimes';
       PROCEDURE ExitThread(ExitCode:ULONG);
                  APIENTRY;  'KERNEL32' name 'ExitThread';
       FUNCTION TerminateThread(hThread:HANDLE;dwExitCode:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'TerminateThread';
       FUNCTION GetExitCodeThread(hThread:HANDLE;VAR lpExitCode:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetExitCodeThread';
       FUNCTION GetLastError:ULONG;
                  APIENTRY;  'KERNEL32' name 'GetLastError';
       PROCEDURE SetLastError(dwErrCode:ULONG);
                  APIENTRY;  'KERNEL32' name 'SetLastError';
       FUNCTION GetOverlappedResult(hFile:HANDLE;VAR lpOverlapped:OVERLAPPED;
                                    VAR lpNumberBytes:ULONG;bWait:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetOverlappedResult';
       FUNCTION CreateIoCompletionPort(FileHandle:HANDLE;ExistingPort:HANDLE;
                                       CompletionKey,NumberConcThreads:ULONG):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateIoCompletionPort';
       FUNCTION GetQueuedCompletionStatus(CompletionPort:HANDLE;
                                          VAR lpNumber,lpKey:ULONG;
                                          VAR lpOverlapped:OVERLAPPED;
                                          dwMillisecs:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetQueuedCompletionStatus';
       FUNCTION SetErrorMode(uMode:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetErrorMode';
       FUNCTION ReadProcessMemory(hProcess:HANDLE;lpBaseAddress:POINTER;
                                  VAR lpBuffer;nSize:ULONG;
                                  VAR lpNumberOfBytesRead:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'ReadProcessMemory';
       FUNCTION WriteProcessMemory(hProcess:HANDLE;lpBaseAddress:POINTER;
                                   VAR lpBuffer;nSize:ULONG;
                                   VAR lpNumberOfBytesWritten:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'WriteProcessMemory';
       FUNCTION GetThreadContext(hThread:HANDLE;VAR lpContext:CONTEXT):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetThreadContext';
       FUNCTION SetThreadContext(hThread:HANDLE;CONST lpContext:CONTEXT):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetThreadContext';
       FUNCTION SuspendThread(hThread:HANDLE):ULONG;
                  APIENTRY;  'KERNEL32' name 'SuspendThread';
       FUNCTION ResumeThread(hThread:HANDLE):ULONG;
                  APIENTRY;  'KERNEL32' name 'ResumeThread';
       PROCEDURE DebugBreak;
                  APIENTRY;  'KERNEL32' name 'DebugBreak';
       FUNCTION WaitForDebugEvent(VAR lpDebugEvent:DEBUG_EVENT;
                                  dwMilliseconds:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'WaitForDebugEvent';
       FUNCTION ContinueDebugEvent(dwProcessId,dwThreadId,dwStatus:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'ContinueDebugEvent';
       FUNCTION DebugActiveProcess(dwProcessId:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'DebugActiveProcess';
       PROCEDURE InitializeCriticalSection(VAR CritSec:CRITICAL_SECTION);
                  APIENTRY;  'KERNEL32' name 'InitializeCriticalSection';
       PROCEDURE EnterCriticalSection(VAR CritSec:CRITICAL_SECTION);
                  APIENTRY;  'KERNEL32' name 'EnterCriticalSection';
       PROCEDURE LeaveCriticalSection(VAR CritSec:CRITICAL_SECTION);
                  APIENTRY;  'KERNEL32' name 'LeaveCriticalSection';
       PROCEDURE DeleteCriticalSection(VAR CritSec:CRITICAL_SECTION);
                  APIENTRY;  'KERNEL32' name 'DeleteCriticalSection';
       FUNCTION SetEvent(hEvent:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetEvent';
       FUNCTION ResetEvent(hEvent:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'ResetEvent';
       FUNCTION PulseEvent(hEvent:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'PulseEvent';
       FUNCTION ReleaseSemaphore(hSemaphore:HANDLE;lReleaseCount:LONG;
                                 VAR lpPreviousCount:LONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'ReleaseSemaphore';
       FUNCTION ReleaseMutex(hMutex:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'ReleaseMutex';
       FUNCTION WaitForSingleObject(hHandle:HANDLE;dwMilliseconds:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'WaitForSingleObject';
       FUNCTION WaitForMultipleObjects(nCount:ULONG;VAR lpHandle:HANDLE;
                                       bWaitAll:BOOL;dwMilliseconds:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'WaitForMultipleObjects';
       PROCEDURE Sleep(dwMilliseconds:ULONG);
                  APIENTRY;  'KERNEL32' name 'Sleep';
       FUNCTION LoadResource(hModule:HINSTANCE;hResInfo:HRSRC):HGLOBAL;
                  APIENTRY;  'KERNEL32' name 'LoadResource';
       FUNCTION SizeofResource(hModule:HINSTANCE;hResInfo:HRSRC):ULONG;
                  APIENTRY;  'KERNEL32' name 'SizeofResource';
       FUNCTION GlobalDeleteAtom(nAtom:ATOM):ATOM;
                  APIENTRY;  'KERNEL32' name 'GlobalDeleteAtom';
       FUNCTION InitAtomTable(nSize:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'InitAtomTable';
       FUNCTION DeleteAtom(nAtom:ATOM):ATOM;
                  APIENTRY;  'KERNEL32' name 'DeleteAtom';
       FUNCTION SetHandleCount(uNumber:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetHandleCount';
       FUNCTION GetLogicalDrives:ULONG;
                  APIENTRY;  'KERNEL32' name 'GetLogicalDrives';
       FUNCTION LockFile(hFile:HANDLE;dwFileOffsetLow,dwFileOffsetHigh:ULONG;
                         dwNumbersToLockLow,dwNumbersToLockHigh:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'LockFile';
       FUNCTION UnlockFile (hFile:HANDLE;dwFileOffsetLow,dwFileOffsetHigh:ULONG;
                         dwNumbersToUnlockLow,dwNumbersToUnlockHigh:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'UnlockFile';
       FUNCTION LockFileEx(hFile:HANDLE;dwFlags,dwReserved:ULONG;
                           nNumberOfBytesToLockLow,nNumberOfBytesToLockHigh:ULONG;
                           VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'LockFileEx';
       FUNCTION UnlockFileEx(hFile:HANDLE;dwFlags,dwReserved:ULONG;
                           nNumberOfBytesToUnlockLow,nNumberOfBytesToUnlockHigh:ULONG;
                           VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'UnlockFileEx';
       FUNCTION GetFileInformationByHandle(hFile:HANDLE;
                             VAR lpFileInformation:BY_HANDLE_FILE_INFORMATION):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetFileInformationByHandle';
       FUNCTION GetFileType(hFile:HANDLE):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetFileType';
       FUNCTION GetFileSize(hFile:HANDLE;VAR lpFileSizeHigh:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetFileSize';
       FUNCTION GetStdHandle(nStdHandle:ULONG):HANDLE;
                  APIENTRY;  'KERNEL32' name 'GetStdHandle';
       FUNCTION SetStdHandle(nStdHandle:ULONG;hHandle:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetStdHandle';
       FUNCTION WriteFile(hFile:HANDLE;CONST lpBuffer;nNumberOfBytesToWrite:ULONG;
                          VAR lpNumberOfBytesWritten:ULONG;
                          VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'WriteFile';
       FUNCTION ReadFile(hFile:HANDLE;VAR lpBuffer;nNumberOfBytesToRead:ULONG;
                         VAR lpNumberOfBytesRead:ULONG;
                         VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'ReadFile';
       FUNCTION FlushFileBuffers(hFile:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'FlushFileBuffers';
       FUNCTION DeviceIoControl(hDevice:HANDLE;dwloControlCode:ULONG;
                                VAR lpInBuffer;nInBufferSize:ULONG;
                                VAR lpOutBuffer;nOutBufferSize:ULONG;
                                VAR lpBytesReturned:ULONG;
                                VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'DeviceIoControl';
       FUNCTION SetEndOfFile(hFile:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetEndOfFile';
       FUNCTION SetFilePointer(hFile:HANDLE;lDistanceToMove:LONG;
                               VAR lpDistanceToMoveHigh:LONG;
                               dwMoveMethod:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetFilePointer';
       FUNCTION FindClose(hFindFile:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'FindClose';
       FUNCTION GetFileTime(hFile:HANDLE;VAR lpCreationTime,lpLastAccessTime,
                            lpLastWriteTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetFileTime';
       FUNCTION SetFileTime(hFile:HANDLE;VAR lpCreationTime,lpLastAccessTime,
                            lpLastWriteTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetFileTime';
       FUNCTION CloseHandle(hObject:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'CloseHandle';
       FUNCTION DuplicateHandle(hSourceProcessHandle,hSourceHandle:HANDLE;
                                hTargetProcessHandle:HANDLE;VAR lpTargetHandle:HANDLE;
                                dwDesiredAccess:ULONG;bInheritHandle:BOOL;
                                dwOptions:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'DuplicateHandle';
       FUNCTION GetHandleInformation(hObject:HANDLE;VAR lpdwFlags:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetHandleInformation';
       FUNCTION SetHandleInformation(hObject:HANDLE;dwMask,dwFlags:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetHandleInformation';
       FUNCTION LoadModule(CONST lpModuleName:CSTRING;lpParameterBlock:POINTER):ULONG;
                  APIENTRY;  'KERNEL32' name 'LoadModule';
       FUNCTION WinExec(CONST lpCmdLine:CSTRING;uCmdShow:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'WinExec';
       {FUNCTION BuildCommDCB(VAR lpDef:CSTRING;VAR lpDCB:DCB):BOOL;
                  APIENTRY;  'KERNEL32' name 'BuildCommDCB';
       FUNCTION BuildCommDCBAndTimeouts(VAR lpDef:CSTRING;VAR lpDCB:DCB;
                                        VAR lpCommTimeouts:COMMTIMEOUTS):BOOL;
                  APIENTRY;  'KERNEL32' name 'BuildCommDCBAndTimeouts';}
       FUNCTION ClearCommBreak(hFile:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'ClearCommBreak';
       {FUNCTION ClearCommError(hFile:HANDLE;VAR lpErrors:ULONG;
                               VAR lpStat:COMSTAT):BOOL;
                  APIENTRY;  'KERNEL32' name 'ClearCommError';}
       FUNCTION SetupComm(hFile:HANDLE;dwInQueue,dwOutQueue:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetupComm';
       FUNCTION EscapeCommFunction(hFile:HANDLE;dwFunc:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'EscapeCommFunction';
       {FUNCTION GetCommConfig(hCommDev:HANDLE;VAR lpCC:COMMCONFIG;
                              VAR lpdwSize:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetCommConfig';}
       FUNCTION GetCommMask(hFile:HANDLE;VAR lpEvtMask:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetCommMask';
       FUNCTION GetCommProperties(hFile:HANDLE;VAR lpCommProp:COMMPROP):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetCommProperties';
       FUNCTION GetCommModemStatus(hFile:HANDLE;VAR lpModemStat:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetCommModemStatus';
       {FUNCTION GetCommTimeouts(hFile:HANDLE;VAR lpCommTimeouts:COMMTIMEOUTS):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetCommTimeouts';
       FUNCTION SetCommBreak(hFile:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetCommBreak';
       FUNCTION SetCommConfig(hCommDev:HANDLE;VAR lpCC:COMMCONFIG;
                              dwSize:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetCommConfig';}
       FUNCTION GetCommState(hFile:HANDLE;VAR lpDCB:TDCB):BOOL;
                  APIENTRY; 'KERNEL32' name 'GetCommState';
       FUNCTION SetCommState(hFile:HANDLE;VAR lpDCB:TDCB):BOOL;
                  APIENTRY; 'KERNEL32' name 'SetCommState';
       FUNCTION PurgeComm(hFile:HANDLE;dwFlags:ULONG):BOOL;
                  APIENTRY; 'KERNEL32' name 'PurgeComm';
       FUNCTION ClearCommError(hFile:HANDLE;VAR lpErrors:ULONG;VAR lpStat:TCOMSTAT):BOOL;
                  APIENTRY; 'KERNEL32' name 'ClearCommError';
       FUNCTION SetCommMask(hFile:HANDLE;dwEvtMask:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetCommMask';
       {FUNCTION SetCommTimeouts(hFile:HANDLE;VAR lpCommTimeouts:COMMTIMEOUTS):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetCommTimeouts';}
       FUNCTION TransmitCommChar(hFile:HANDLE;cChar:CHAR):BOOL;
                  APIENTRY;  'KERNEL32' name 'TransmitCommChar';
       FUNCTION WaitCommEvent(hFile:HANDLE;VAR lpEvtMask:ULONG;
                              VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'WaitCommEvent';
       FUNCTION SetTapePosition(hDevice:HANDLE;dwPositionMethod,dwPartition:ULONG;
                                dwOffsetLow,dwOffsetHigh:ULONG;bImmediate:BOOL):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetTapePosition';
       FUNCTION GetTapePosition(hDevice:HANDLE;dwPositionType:ULONG;
                                VAR lpdwPartition,lpdwOffsetLow,lpdwOffsetHigh:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetTapePosition';
       FUNCTION PrepareTape(hDevice:HANDLE;dwOperation:ULONG;bImmediate:BOOL):ULONG;
                  APIENTRY;  'KERNEL32' name 'PrepareTape';
       FUNCTION EraseTape(hDevice:HANDLE;dwEraseType:ULONG;bImmediate:BOOL):ULONG;
                  APIENTRY;  'KERNEL32' name 'EraseTape';
       FUNCTION CreateTapePartition(hDevice:HANDLE;dwPartitionMethod:ULONG;
                                    dwCount,dwSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'CreateTapePartition';
       FUNCTION WriteTapemark(hDevice:HANDLE;dwTapemarkType,dwTapeMarkCount:ULONG;
                              bImmediate:BOOL):ULONG;
                  APIENTRY;  'KERNEL32' name 'WriteTapemark';
       FUNCTION GetTapeStatus(hDevice:HANDLE):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetTapeStatus';
       FUNCTION GetTapeParameters(hDevice:HANDLE;dwOperation:ULONG;
                                  VAR lpdwSize:ULONG;VAR lpTapeInformation):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetTapeParameters';
       FUNCTION SetTapeParameters(hDevice:HANDLE;dwOperation:ULONG;
                                  VAR lpTapeInformation):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetTapeParameters';
       FUNCTION Beep(dwFreq,dwDuration:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'Beep';
       PROCEDURE OpenSound;
                  APIENTRY;  'KERNEL32' name 'OpenSound';
       PROCEDURE CloseSound;
                  APIENTRY;  'KERNEL32' name 'CloseSound';
       PROCEDURE StartSound;
                  APIENTRY;  'KERNEL32' name 'StartSound';
       PROCEDURE StopSound;
                  APIENTRY;  'KERNEL32' name 'StopSound';
       FUNCTION WaitSoundState(nState:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'WaitSoundState';
       FUNCTION SyncAllVoices:ULONG;
                  APIENTRY;  'KERNEL32' name 'SyncAllVoices';
       FUNCTION CountVoiceNotes(nVoice:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'CountVoiceNotes';
       FUNCTION GetThresholdEvent:LPDWORD;
                  APIENTRY;  'KERNEL32' name 'GetThresholdEvent';
       FUNCTION GetThresholdStatus:ULONG;
                  APIENTRY;  'KERNEL32' name 'GetThresholdStatus';
       FUNCTION SetSoundNoise(nSource,nDuration:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetSoundNoise';
       FUNCTION SetVoiceAccent(nVoice,nTempo,nVolume,nMode,nPitch:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetVoiceAccent';
       FUNCTION SetVoiceEnvelope(nVoice,nShape,nRepeat:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetVoiceEnvelope';
       FUNCTION SetVoiceNote(nVoice,nValue,nLength,nCdots:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetVoiceNote';
       FUNCTION SetVoiceQueueSize(nVoice,nBytes:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetVoiceQueueSize';
       FUNCTION SetVoiceSound(nVoice,Frequency,nDuration:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetVoiceSound';
       FUNCTION SetVoiceThreshold(nVoice,nNotes:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'SetVoiceThreshold';
       FUNCTION MulDiv(nNumber,nNumerator,nDenominator:LONGINT):LONGINT;
                  APIENTRY;  'KERNEL32' name 'MulDiv';
       PROCEDURE GetSystemTime(VAR lpSystemTime:SYSTEMTIME);
                  APIENTRY;  'KERNEL32' name 'GetSystemTime';
       FUNCTION SetSystemTime(CONST lpSystemTime:SYSTEMTIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetSystemTime';
       PROCEDURE GetLocalTime(VAR lpSystemTime:SYSTEMTIME);
                  APIENTRY;  'KERNEL32' name 'GetLocalTime';
       FUNCTION SetLocalTime(CONST lpSystemTime:SYSTEMTIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetLocalTime';
       PROCEDURE GetSystemInfo(VAR lpSystemInfo:SYSTEM_INFO);
                  APIENTRY;  'KERNEL32' name 'GetSystemInfo';
       FUNCTION SystemTimeToTzSpecificLocalTime(VAR lpTimeZoneInfo:TIME_ZONE_INFORMATION;
                        VAR lpUniversalTime,lpLocalTime:SYSTEMTIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'SystemTimeToTzSpecificLocalTime';
       FUNCTION GetTimeZoneInformation(VAR lpTimeZoneInfo:TIME_ZONE_INFORMATION):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetTimeZoneInformation';
       FUNCTION SetTimeZoneInformation(CONST lpTimeZoneInfo:TIME_ZONE_INFORMATION):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetTimeZoneInformation';
       FUNCTION SystemTimeToFileTime(CONST lpSystemTime:SYSTEMTIME;
                                     VAR lpFileTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'SystemTimeToFileTime';
       FUNCTION FileTimeToLocalFileTime(CONST lpFileTime:FILETIME;
                                        VAR lpLocalFileTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'FileTimeToLocalFileTime';
       FUNCTION LocalFileTimeToFileTime(CONST lpLocalFileTime:FILETIME;
                                        VAR lpFileTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'LocalFileTimeToFileTime';
       FUNCTION FileTimeToSystemTime(CONST lpFileTime:FILETIME;
                                     VAR lpSystemTime:SYSTEMTIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'FileTimeToSystemTime';
       FUNCTION CompareFileTime(CONST lpFileTime1,lpFileTime2:FILETIME):LONG;
                  APIENTRY;  'KERNEL32' name 'CompareFileTime';
       FUNCTION FileTimeToDosDateTime(CONST lpFileTime:FILETIME;
                                      VAR lpFatDate,lpFatTime:WORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'FileTimeToDosDateTime';
       FUNCTION DosDateTimeToFileTime(wFatDate,wFatTime:WORD;VAR lpFileTime:FILETIME):BOOL;
                  APIENTRY;  'KERNEL32' name 'DosDateTimeToFileTime';
       FUNCTION GetTickCount:ULONG;
                  APIENTRY;  'KERNEL32' name 'GetTickCount';
       FUNCTION SetSystemTimeAdjustment(dwTimeAdjustment:ULONG;
                                        bTimeAdjustmentDisabled:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetSystemTimeAdjustment';
       FUNCTION GetSystemTimeAdjustment(VAR lpTimeAdjustment,lpTimeIncrement:ULONG;
                                        VAR lpTimeAdjustmentDisabled:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetSystemTimeAdjustment';
       FUNCTION FormatMessage(dwFlags:ULONG;VAR lpSource;
                              dwMessageId,dwLanguageId:ULONG;
                              VAR lpBuffer:CSTRING;nSize:ULONG;
                              Arguments:POINTER):ULONG;
                  APIENTRY;  'KERNEL32' name 'FormatMessageA';
       FUNCTION CreatePipe(VAR hReadPipe,hWritePipe:HANDLE;
                           VAR lpPipeAttributes:SECURITY_ATTRIBUTES;
                           nSize:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'CreatePipe';
       FUNCTION ConnectNamedPipe(hNamedPipe:HANDLE;VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'ConnectNamedPipe';
       FUNCTION DisconnectNamedPipe(hNamedPipe:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'DisconnectNamedPipe';
       FUNCTION SetNamedPipeHandleState(hNamedPipe:HANDLE;
                        VAR lpMode,lpMaxCollectionCount:ULONG;
                        VAR lpCollectDataTimeOut:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetNamedPipeHandleState';
       FUNCTION GetNamedPipeInfo(hNamedPipe:HANDLE;
                           VAR lpFlags,lpOutBufferSize:ULONG;
                           VAR lpInBufferSize,lpMaxInstances:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetNamedPipeInfo';
       FUNCTION PeekNamedPipe(hNamedPipe:HANDLE;VAR lpBuffer;nBufferSize:ULONG;
                              VAR lpBytesRead,lpTotalBytesAvail:ULONG;
                              VAR lpBytesLeftThisMessage:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'PeekNamedPipe';
       FUNCTION TransactNamedPipe(hNamedPipe:HANDLE;VAR lpInBuffer;nInBufferSize:ULONG;
                                  VAR lpOutBuffer;nOutBufferSize:ULONG;
                                  VAR lpBytesRead:ULONG;
                                  VAR lpOverlapped:OVERLAPPED):BOOL;
                  APIENTRY;  'KERNEL32' name 'TransactNamedPipe';
       FUNCTION CreateMailslot(CONST lpName:CSTRING;nMaxMessageSize:ULONG;
                               lReadTimeOut:ULONG;
                               VAR lpSecurityAttributes:SECURITY_ATTRIBUTES):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateMailslotA';
       FUNCTION GetMailslotInfo(hMailslot:HANDLE;VAR lpMaxMessageSize:ULONG;
                                VAR lpNextSize,lpMessageCount:ULONG;
                                VAR lpReadTimeout:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetMailslotInfo';
       FUNCTION SetMailslotInfo(hMailslot:HANDLE;lReadTimeOut:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetMailslotInfo';
       FUNCTION MapViewOfFile(hFileMappingObject:HANDLE;dwDesiredAccess:ULONG;
                              dwFileOffsetHigh,dwFileOffsetLow:ULONG;
                              dwNumberOfBytesToMap:ULONG):POINTER;
                  APIENTRY;  'KERNEL32' name 'MapViewOfFile';
       FUNCTION FlushViewOfFile(lpBasAddress:POINTER;dwNumberOfBytesToFlush:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'FlushViewOfFile';
       FUNCTION UnmapViewOfFile(lpBaseAddress:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'UnmapViewOfFile';
       FUNCTION lstrcmp(CONST lpString1,lpString2:CSTRING):LONGINT;
                  APIENTRY;  'KERNEL32' name 'lstrcmpA';
       FUNCTION lstrcmpi(CONST lpString1,lpString2:CSTRING):LONGINT;
                  APIENTRY;  'KERNEL32' name 'lstrcmpiA';
       FUNCTION lstrcpyn(VAR lpString1:CSTRING;CONST lpString2:CSTRING;
                         iMaxLength:LONGINT):PChar;
                  APIENTRY;  'KERNEL32' name 'lstrcpynA';
       FUNCTION lstrcpy(VAR lpString1:CSTRING;CONST lpString2:CSTRING):PChar;
                  APIENTRY;  'KERNEL32' name 'lstrcpyA';
       FUNCTION lstrcat(VAR lpString1:CSTRING;CONST lpString2:CSTRING):PChar;
                  APIENTRY;  'KERNEL32' name 'lstrcatA';
       FUNCTION lstrlen(CONST lpString:CSTRING):LONGINT;
                  APIENTRY;  'KERNEL32' name 'lstrlenA';
       FUNCTION OpenFile(CONST lpFileName:CSTRING;VAR lpReOpenBuf:OFSTRUCT;
                         uStyle:ULONG):HFILE;
                  APIENTRY;  'KERNEL32' name 'OpenFile';
       FUNCTION _lopen(CONST lpPathName:CSTRING;iReadWrite:LONGINT):HFILE;
                  APIENTRY;  'KERNEL32' name '_lopen';
       FUNCTION _lcreat(CONST lpPathName:CSTRING;iAttribute:LONGINT):HFILE;
                  APIENTRY;  'KERNEL32' name '_lcreat';
       FUNCTION _lread(ahFile:HFILE;VAR lpBuffer;uBytes:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name '_lread';
       FUNCTION _lwrite(ahFile:HFILE;CONST Buffer;uBytes:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name '_lwrite';
       FUNCTION _hread(ahFile:HFILE;VAR lpBuffer;lBytes:LONGINT):LONGINT;
                  APIENTRY;  'KERNEL32' name '_hread';
       FUNCTION _hwrite(ahFile:HFILE;CONST lpBuffer;lBytes:LONGINT):LONGINT;
                  APIENTRY;  'KERNEL32' name '_hwrite';
       FUNCTION _lclose(ahFile:HFILE):HFILE;
                  APIENTRY;  'KERNEL32' name '_lclose';
       FUNCTION _llseek(ahFile:HFILE;lOffset:LONG;iOrigin:LONGINT):LONG;
                  APIENTRY;  'KERNEL32' name '_llseek';
       FUNCTION IsTextUnicode(CONST lpBuffer;cb:LONGINT;VAR lpi:LONGINT):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsTextUnicode';
       FUNCTION TlsAlloc:ULONG;
                  APIENTRY;  'KERNEL32' name 'TlsAlloc';
       FUNCTION TlsGetValue(dwTlsIndex:ULONG):POINTER;
                  APIENTRY;  'KERNEL32' name 'TlsGetValue';
       FUNCTION TlsSetValue(dwTlsIndex:ULONG;lpTlsValue:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'TlsSetValue';
       FUNCTION TlsFree(dwTlsIndex:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'TlsFree';
       FUNCTION SleepEx(dwMilliseconds:ULONG;bAlertable:BOOL):ULONG;
                  APIENTRY;  'KERNEL32' name 'SleepEx';
       FUNCTION WaitForSingleObjectEx(hHandle:HANDLE;dwMillieconds:ULONG;
                                      bAlertable:BOOL):ULONG;
                  APIENTRY;  'KERNEL32' name 'WaitForSingleObjectEx';
       FUNCTION WaitForMultipleObjectsEx(nCount:ULONG;VAR lpHandles:HANDLE;
                                         bWaitAll:BOOL;dwMilliseconds:ULONG;
                                         bAlertable:BOOL):ULONG;
                  APIENTRY;  'KERNEL32' name 'WaitForMultipleObjectsEx';
       FUNCTION ReadFileEx(hFile:HANDLE;VAR lpBuffer;nNumberOfBytesToRead:ULONG;
                           VAR lpOverlapped:OVERLAPPED;
                           lpCompletionRoutine:LPOVERLAPPED_COMPLETION_ROUTINE):BOOL;
                  APIENTRY;  'KERNEL32' name 'ReadFileEx';
       FUNCTION WriteFileEx(hFile:HANDLE;CONST lpBuffer;nNumberOfBytesToWrite:ULONG;
                            VAR lpOverlapped:OVERLAPPED;
                            lpCompletionRoutine:LPOVERLAPPED_COMPLETION_ROUTINE):BOOL;
                  APIENTRY;  'KERNEL32' name 'WriteFileEx';
       FUNCTION BackupRead(hFile:HANDLE;VAR lpBuffer;nNumberOfBytesToRead:ULONG;
                           VAR lpNumberOfBytesRead:ULONG;bAbort:BOOL;
                           bProcessSecurity:BOOL;VAR lpContext:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'BackupRead';
       FUNCTION BackupSeek(hFile:HANDLE;dwLowBytesToSeek,dwHighBytesToSeek:ULONG;
                           VAR lpdwLowByteSeeked,lpdwHighByteSeeked:ULONG;
                           VAR lpContext:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'BackupSeek';
       FUNCTION BackupWrite(hFile:HANDLE;VAR lpBuffer;nNumberOfBytesToWrite:ULONG;
                            VAR lpNumberOfBytesWritten:ULONG;bAbort:BOOL;
                            bProcessSecurity:BOOL;VAR lpContext:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'BackupWrite';
       FUNCTION CreateMutex(VAR lpMutexAttributes:SECURITY_ATTRIBUTES;
                            bInitialOwner:BOOL;lpName:cString):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateMutexA';
       FUNCTION OpenMutex(dwDesiredAccess:ULONG;bInheritHandle:BOOL;
                          lpName:cString):HANDLE;
                  APIENTRY;  'KERNEL32' name 'OpenMutexA';
       FUNCTION CreateEvent(VAR lpEventAttributes:SECURITY_ATTRIBUTES;
                            bManualReset,bInitialState:BOOL;
                            lpName:PChar):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateEventA';
       FUNCTION OpenEvent(dwDesiredAccess:ULONG;bInheritHandle:BOOL;
                          lpName:PChar):HANDLE;
                  APIENTRY;  'KERNEL32' name 'OpenEventA';
       FUNCTION CreateSemaphore(VAR lpSemaphoreAttributes:SECURITY_ATTRIBUTES;
                                lInitialCount,lMaximumCount:LONG;
                                lpName:PChar):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateSemaphoreA';
       FUNCTION OpenSemaphore(dwDesiredAccess:ULONG;bInheritHandle:BOOL;
                              lpName:PChar):HANDLE;
                  APIENTRY;  'KERNEL32' name 'OpenSemaphoreA';
       FUNCTION CreateFileMapping(hFile:HANDLE;
                                  VAR lpFileMappingAttributes:SECURITY_ATTRIBUTES;
                                  flProtect,dwMaximumSizeHigh,dwMaximumSizeLow:ULONG;
                                  CONST lpName:CSTRING):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateFileMappingA';
       FUNCTION OpenFileMapping(dwDesiredAccess:ULONG;bInheritHandle:BOOL;
                                CONST lpName:CSTRING):HANDLE;
                  APIENTRY;  'KERNEL32' name 'OpenFileMappingA';
       FUNCTION GetLogicalDriveStrings(nBufferLength:ULONG;
                                       VAR lpBuffer:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetLogicalDriveStringsA';
       FUNCTION LoadLibrary(CONST lpLibFileName:CSTRING):HINSTANCE;
                  APIENTRY;  'KERNEL32' name 'LoadLibraryA';
       FUNCTION LoadLibraryEx(CONST lpLibFileName:CSTRING;hFile:HANDLE;
                              dwFlags:ULONG):HINSTANCE;
                  APIENTRY;  'KERNEL32' name 'LoadLibraryExA';
       FUNCTION GetModuleFileName(hModule:HINSTANCE;VAR lpFileName;
                                  nSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetModuleFileNameA';
       FUNCTION GetModuleHandle(CONST lpModuleName:CSTRING):HMODULE;
                  APIENTRY;  'KERNEL32' name 'GetModuleHandleA';
       FUNCTION CreateProcess(CONST lpApplicationName:CSTRING;VAR lpCommandLine:CSTRING;
                              VAR lpProcessAttributes,lpThreadAttributes:SECURITY_ATTRIBUTES;
                              bInheritHandles:BOOL;dwCreationFlags:ULONG;
                              lpEnvironment:POINTER;CONST lpCurrentDir:CSTRING;
                              VAR lpStartupInfo:STARTUPINFO;
                              VAR lpProcessInformation:PROCESS_INFORMATION):BOOL;
                  APIENTRY;  'KERNEL32' name 'CreateProcessA';
       FUNCTION SetProcessShutdownParameters(dwLevel,dwFlags:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetProcessShutdownParameters';
       FUNCTION GetProcessShutdownParameters(VAR lpdwLevel,lpdwFlags:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetProcessShutdownParameters';
       PROCEDURE FatalAppExit(uAction:ULONG;CONST lpMessageText:CSTRING);
                  APIENTRY;  'KERNEL32' name 'FatalAppExitA';
       PROCEDURE GetStartupInfo(VAR lpStartupInfo:STARTUPINFO);
                  APIENTRY;  'KERNEL32' name 'GetStartupInfoA';
       FUNCTION GetCommandLine:PChar;
                  APIENTRY;  'KERNEL32' name 'GetCommandLineA';
       FUNCTION GetEnvironmentVariable(CONST lpName:CSTRING;VAR lpBuffer:CSTRING;
                                       nSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetEnvironmentVariableA';
       FUNCTION SetEnvironmentVariable(CONST lpName,lpValue:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetEnvironmentVariableA';
       FUNCTION ExpandEnvironmentStrings(CONST lpSrc:CSTRING;VAR lpDst:CSTRING;
                                         nSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'ExpandEnvironmentStringsA';
       PROCEDURE OutputDebugString(CONST lpOutputString:CSTRING);
                  APIENTRY;  'KERNEL32' name 'OutputDebugStringA';
       FUNCTION FindResource(hModule:HINSTANCE;CONST lpName,lpType:CSTRING):HRSRC;
                  APIENTRY;  'KERNEL32' name 'FindResourceA';
       FUNCTION FindResourceEx(hModule:HINSTANCE;CONST lpType,lpName:CSTRING;
                               wLanguage:WORD):HRSRC;
                  APIENTRY;  'KERNEL32' name 'FindResourceExA';
       FUNCTION EnumResourceTypes(hModule:HINSTANCE;lpEnumFunc:ENUMRESTYPEPROC;
                                  lParam:LONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'EnumResourceTypesA';
       FUNCTION EnumResourceNames(hModule:HINSTANCE;CONST lpType:CSTRING;
                                  lpEnumFunc:ENUMRESNAMEPROC;lParam:LONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'EnumResourceNamesA';
       FUNCTION EnumResourceLanguages(hModule:HINSTANCE;CONST lpType,lpName:CSTRING;
                                      lpEnumFunc:ENUMRESLANGPROC;lParam:LONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'EnumResourceLanguagesA';
       FUNCTION BeginUpdateResource(CONST pFileName:CSTRING;
                                    bDeleteExistingResources:BOOL):HANDLE;
                  APIENTRY;  'KERNEL32' name 'BeginUpdateResourceA';
       FUNCTION UpdateResource(hUpdate:HANDLE;CONST lpType,lpName:CSTRING;
                               wLanguage:WORD;lpData:POINTER;
                               cbData:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'UpdateResourceA';
       FUNCTION EndUpdateResource(hUpdate:HANDLE;fDiscard:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'EndUpdateResourceA';
       FUNCTION GlobalAddAtom(CONST lpString:CSTRING):ATOM;
                  APIENTRY;  'KERNEL32' name 'GlobalAddAtomA';
       FUNCTION GlobalFindAtom(CONST lpString:CSTRING):ATOM;
                  APIENTRY;  'KERNEL32' name 'GlobalFindAtomA';
       FUNCTION GlobalGetAtomName(nAtom:ATOM;VAR lpBuffer:CSTRING;
                                  nSize:LONGINT):ULONG;
                  APIENTRY;  'KERNEL32' name 'GlobalGetAtomNameA';
       FUNCTION AddAtom(CONST lpString:CSTRING):ATOM;
                  APIENTRY;  'KERNEL32' name 'AddAtomA';
       FUNCTION FindAtom(CONST lpString:CSTRING):ATOM;
                  APIENTRY;  'KERNEL32' name 'FindAtomA';
       FUNCTION GetAtomName(nAtom:ATOM;VAR lpBuffer:CSTRING;nSize:LONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetAtomNameA';
       FUNCTION GetProfileInt(CONST lpAppName,lpKeyName:CSTRING;
                              nDefault:LONGINT):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetProfileIntA';
       FUNCTION GetProfileString(CONST lpAppName,lpKeyName,lpDefault:CSTRING;
                                 VAR lpReturnedString:CSTRING;nSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetProfileStringA';
       FUNCTION WriteProfileString(CONST lpAppName,lpKeyName,lpString:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'WriteProfileStringA';
       FUNCTION GetProfileSection(CONST lpAppName:CSTRING;VAR lpReturnedString:CSTRING;
                                  nSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetProfileSectionA';
       FUNCTION WriteProfileSection(CONST lpAppName,lpString:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'WriteProfileSectionA';
       FUNCTION GetPrivateProfileInt(CONST lpAppName,lpKeyName:CSTRING;
                                     nDefault:LONGINT;CONST lpFileName:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetPrivateProfileIntA';
       FUNCTION GetPrivateProfileString(CONST lpAppName,lpKeyName:CSTRING;
                                        CONST lpDefault:CSTRING;
                                        VAR lpReturnedString:CSTRING;
                                        nSize:ULONG;CONST lpFileName:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetPrivateProfileStringA';
       FUNCTION WritePrivateProfileString(CONST lpAppName,lpKeyName:CSTRING;
                                          CONST lpString,lpFileName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'WritePrivateProfileStringA';
       FUNCTION GetPrivateProfileSection(CONST lpAppName:CSTRING;
                                         VAR lpReturnedString:CSTRING;
                                         nSize:ULONG;CONST lpFileName:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetPrivateProfileSectionA';
       FUNCTION WritePrivateProfileSection(CONST lpAppName,lpString:CSTRING;
                                           CONST lpFileName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'WritePrivateProfileSectionA';
       FUNCTION GetDriveType(CONST lpRootPathName:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetDriveTypeA';
       FUNCTION GetSystemDirectory(VAR lpBuffer:CSTRING;uSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetSystemDirectoryA';
       FUNCTION GetTempPath(nBufferLength:ULONG;VAR lpBuffer:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetTempPathA';
       FUNCTION GetTempFileName(CONST lpPathName,lpPrefixString:CSTRING;
                                uUnique:ULONG;VAR lpTempFileName:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetTempFileNameA';
       FUNCTION GetWindowsDirectory(VAR lpBuffer:CSTRING;uSize:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetWindowsDirectoryA';
       FUNCTION SetCurrentDirectory(CONST lpPathName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetCurrentDirectoryA';
       FUNCTION GetCurrentDirectory(nBufferLength:ULONG;VAR lpBuffer):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetCurrentDirectoryA';
       FUNCTION GetDiskFreeSpace(CONST lpRootPathName:CSTRING;
                                 VAR lpSectorsPerCluster,lpBytesPerSector:ULONG;
                                 VAR lpNumberOfFreeClusters,lpTotalClusters:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetDiskFreeSpaceA';

       {Martin (funktioniert auch mit >2GB)}
       FUNCTION GetDiskFreeSpaceEx(CONST lpRootPathName:CSTRING;
                                 VAR lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes,
                                     lpTotalNumberOfFreeBytes : ULARGE_INTEGER):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetDiskFreeSpaceExA';

       FUNCTION CreateDirectory(CONST lpPathName:CSTRING;
                                VAR lpSecurityAttributes:SECURITY_ATTRIBUTES):BOOL;
                  APIENTRY;  'KERNEL32' name 'CreateDirectoryA';
       FUNCTION CreateDirectoryEx(CONST lpTemplateDir,lpNewDir:CSTRING;
                                  VAR lpSecurityAttribtes:SECURITY_ATTRIBUTES):BOOL;
                  APIENTRY;  'KERNEL32' name 'CreateDirectoryExA';
       FUNCTION RemoveDirectory(CONST lpPathName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'RemoveDirectoryA';
       FUNCTION GetFullPathName(CONST lpFileName:CSTRING;nBufferLength:ULONG;
                                VAR lpBuffer;VAR lpFilePart:PChar):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetFullPathNameA';
       FUNCTION DefineDosDevice(dwFlags:ULONG;CONST lpDeviceName:CSTRING;
                                CONST lpTargetPath:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'DefineDosDeviceA';
       FUNCTION QueryDosDevice(CONST lpDeviceName:CSTRING;VAR lpTargetPath:CSTRING;
                               ucchMax:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'QueryDosDeviceA';
       FUNCTION CreateFile(CONST lpFileName:CSTRING;dwDesiredAccess:ULONG;
                           dwShareMode:ULONG;VAR lpSecurityAttributes:SECURITY_ATTRIBUTES;
                           deCreationDisposition,dwFlagsAndAttributes:ULONG;
                           hTemplateFile:HANDLE):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateFileA';
       FUNCTION SetFileAttributes(CONST lpFileName:CSTRING;
                                  dwFileAttributes:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetFileAttributesA';
       FUNCTION GetFileAttributes(CONST lpFileName:CSTRING):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetFileAttributesA';
       FUNCTION GetCompressedFileSize(CONST lpFileName:CSTRING;
                                      VAR lpFileSizeHigh:ULONG):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetCompressedFileSizeA';
       FUNCTION DeleteFile(CONST lpFileName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'DeleteFileA';
       FUNCTION FindFirstFile(CONST lpFileName:CSTRING;
                              VAR lpFindFileData:WIN32_FIND_DATA):HANDLE;
                  APIENTRY;  'KERNEL32' name 'FindFirstFileA';
       FUNCTION FindNextFile(hFindFile:HANDLE;
                             VAR lpFindFileData:WIN32_FIND_DATA):BOOL;
                  APIENTRY;  'KERNEL32' name 'FindNextFileA';
       FUNCTION SearchPath(CONST lpPath,lpFileName,lpExtension:CSTRING;
                           nBufferLength:ULONG;VAR lpBuffer:CSTRING;
                           VAR lpFilePart:PChar):ULONG;
                  APIENTRY;  'KERNEL32' name 'SearchPathA';
       FUNCTION CopyFile(CONST lpExistingFileName,lpNewFileName:CSTRING;
                         bFailIfExists:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'CopyFileA';
       FUNCTION MoveFile(CONST lpExistingFileName,lpNewFileName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'MoveFileA';
       FUNCTION MoveFileEx(CONST lpExistingFileName,lpNewFileName:CSTRING;
                           dwFlags:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'MoveFileExA';
       FUNCTION CreateNamedPipe(CONST lpName:CSTRING;dwOpenMode:ULONG;
                                dwPipeMode,nMaxInstances,nOutBufferSize:ULONG;
                                nInBufferSize,nDefaultTimeOut:ULONG;
                                VAR lpSecurityAttributes:SECURITY_ATTRIBUTES):HANDLE;
                  APIENTRY;  'KERNEL32' name 'CreateNamedPipeA';
       FUNCTION GetNamedPipeHandleState(hNamedPipe:HANDLE;VAR lpState:ULONG;
                              VAR lpCurInstances,lpMaxCollectionCount:ULONG;
                              VAR lpCollectDataTimeOut:ULONG;
                              VAR lpUserName:CSTRING;nMaxUserNameSize:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetNamedPipeHandleStateA';
       FUNCTION CallNamedPipe(CONST lpNamedPipeName:CSTRING;
                              VAR lpInBuffer;nInBufferSize:ULONG;
                              VAR lpOutBuffer;nOutBufferSize:ULONG;
                              VAR lpBytesRead:ULONG;nTimeOut:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'CallNamedPipeA';
       FUNCTION WaitNamedPipe(CONST lpNamedPipeName:CSTRING;
                              nTimeOut:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'WaitNamedPipeA';
       FUNCTION SetVolumeLabel(CONST lpRootPathName,lpVolumeName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetVolumeLabelA';
       PROCEDURE SetFileApisToOEM;
                  APIENTRY;  'KERNEL32' name 'SetFileApisToOEM';
       PROCEDURE SetFileApisToANSI;
                  APIENTRY;  'KERNEL32' name 'SetFileApisToANSI';
       FUNCTION AreFileApisANSI:BOOL;
                  APIENTRY;  'KERNEL32' name 'AreFileApisANSI';
       FUNCTION GetVolumeInformation(CONST lpRootPathName:CSTRING;
                                     VAR lpVolumeNameBuffer:CSTRING;
                                     nVolumeNameSize:ULONG;
                                     VAR lpVolumeSerialNumber:ULONG;
                                     VAR lpMaximumComponentLength:ULONG;
                                     VAR lpFileSystemFlags:ULONG;
                                     VAR lpFileSystemNameBuffer:CSTRING;
                                     nFileSystemNameSize:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetVolumeInformationA';
       FUNCTION ClearEventLog(hEventLog:HANDLE;CONST lpBackupFileName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'ClearEventLogA';
       FUNCTION BackupEventLog(hEventLog:HANDLE;CONST lpBackupFileName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'BackupEventLogA';
       FUNCTION CloseEventLog(hEventLog:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'CloseEventLog';
       FUNCTION DeregisterEventSource(hEventLog:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'DeregisterEventSource';
       FUNCTION NotifyChangeEventLog(hEventLog,hEvent:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'NotifyChangeEventLog';
       FUNCTION GetNumberOfEventLogRecords(hEventLog:HANDLE;VAR NumberOfRecords:WORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetNumberOfEventLogRecords';
       FUNCTION GetOldestEventLogRecord(hEventLog:HANDLE;VAR OldestRecord:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetOldestEventLogRecord';
       FUNCTION OpenEventLog(CONST lpUNCServerName:CSTRING;
                             CONST lpSourceName:CSTRING):HANDLE;
                  APIENTRY;  'KERNEL32' name 'OpenEventLogA';
       FUNCTION RegisterEventSource(CONST lpUNCServerName:CSTRING;
                                    CONST lpSourceName:CSTRING):HANDLE;
                  APIENTRY;  'KERNEL32' name 'RegisterEventSourceA';
       FUNCTION OpenBackupEventLog(CONST lpUNCServerName:CSTRING;
                                   CONST lpFileName:CSTRING):HANDLE;
                  APIENTRY;  'KERNEL32' name 'OpenBackupEventLogA';
       FUNCTION ReadEventLog(hEventLog:HANDLE;dwReadFlags,dwRecordOffset:ULONG;
                             VAR lpBuffer;nNumberOfBytesToRead:ULONG;
                             VAR pnBytesRead,pnMinNumberOfBytesNeeded:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'ReadEventLogA';
       {FUNCTION ReportEvent(hEventLog:HANDLE;wType,wCategory:WORD;
                            dwEventID:ULONG;VAR lpUserSid:SID;
                            wNumStrings:WORD;VAR lpStrings:PChar;
                            VAR lpRawData):BOOL;
                  APIENTRY;  'KERNEL32' name 'ReportEventA';
       FUNCTION DuplicateToken(ExistingTokenHandle:HANDLE;
                               Impoersonation_Level:SECURITY_IMPERSONATION_LEVEL;
                               VAR DuplicateTokenHandle:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'DuplicateToken';
       FUNCTION GetKernelObjectSecurity(Handle:HANDLE;Requested_Information:SECURITY_INFORMATION;
                                        VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                        nLength:ULONG;VAR lpnLengthNeeded:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetKernelObjectSecurity';
       FUNCTION ImpersonateNamedPipeClient(hNamedPipe:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'ImpersonateNamedPipeClient';
       FUNCTION ImpersonateSelf(ImpoersonationLevel:SECURITY_IMPOERSONATION_LEVEL):BOOL;
                  APIENTRY;  'KERNEL32' name 'ImpersonateSelf';
       FUNCTION RevertToSelf:BOOL;
                  APIENTRY;  'KERNEL32' name 'RevertToSelf';
       FUNCTION SetThreadToken(VAR Thread:HANDLE;Token:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetThreadToken';
       FUNCTION AccessCheck(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                            ClientToken:HANDLE;DesiredAccess:ULONG;
                            VAR GenericMapping:GENERIC_MAPPING;
                            VAR PrivilegeSet:PRIVILEGE_SET;
                            VAR PrivilegeSetLength:ULONG;
                            VAR GrantedAccess:ULONG;VAR AccessStatus:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'AccessCheck';
       FUNCTION OpenProcessToken(ProcessHandle:HANDLE;DesiredAccess:ULONG;
                                 VAR TokenHandle:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'OpenProcessToken';
       FUNCTION OpenThreadToken(ThreadHandle:HANDLE;DesiredAccess:ULONG;
                                OpenAsSelf:BOOL;VAR TokenHandle:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'OpenThreadToken';
       FUNCTION GetTokenInformation(TokenHandle:HANDLE;
                               TokenInformationClass:TOKEN_INFORMATION_CLASS;
                               VAR TokenInformation;TokenInformationLength:ULONG;
                               VAR ReturnLength:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetTokenInformation';
       FUNCTION SetTokenInformation(TokenHandle:HANDLE;
                               TokenInformationClass:TOKEN_INFORMATION_CLASS;
                               VAR TokenInformation;TokenInformationLength:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetTokenInformation';
       FUNCTION AdjustTokenPrivileges(TokenHandle:HANDLE;DisableAllPrivileges:BOOL;
                                      VAR NewState:TOKEN_PRIVILEGES;
                                      BufferLength:ULONG;
                                      VAR PreviousState:TOKEN_PRIVILEGES;
                                      VAR ReturnLength:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'AdjustTokenPrivileges';
       FUNCTION AdjustTokenGroups(TokenHandle:HANDLE;ResetToDefault:BOOL;
                                  VAR NewState:TOKEN_GROUPS;BufferLength:ULONG;
                                  VAR PreviousState:TOKEN_GROUPS;
                                  VAR ReturnLength:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'AdjustTokenGroups';
       FUNCTION PrivilegeCheck(ClientToken:HANDLE;
                               VAR RequiredPrivileges:PRIVILEGE_SET;
                               VAR pfResult:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'PrivilegeCheck';
       FUNCTION AccessCheckAndAuditAlarm(CONST SubsystemName:CSTRING;
                                         VAR HandleId;
                                         VAR ObjectTypeName,ObjectName:CSTRING;
                                         VAR SecurityDescriptor:SECURITY_DESCRIPTOR;
                                         DesiredAccess:ULONG;
                                         VAR GenericMapping:GENERIC_MAPPING;
                                         ObjectCreation:BOOL;
                                         VAR GrantedAccess:ULONG;
                                         VAR AccessStatus,pfGenerateOnClose:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'AccessCheckAndAuditAlarmA';
       FUNCTION ObjectOpenAuditAlarm(CONST SubSystemName:CSTRING;VAR HandleId;
                                     VAR ObjectTypeName,ObjectName:CSTRING;
                                     VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                     ClientToken:HANDLE;
                                     DesiredAccess,GrantedAccess:ULONG;
                                     VAR Privileges:PRIVILEGE_SET;
                                     ObjectCreation,AccessGranted:BOOL;
                                     VAR GenerateOnClose:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'ObjectOpenAuditAlarmA';
       FUNCTION ObjectPrivilegeAuditAlarm(CONST SubsystemName:CSTRING;
                                          VAR HandleId;ClientToken:HANDLE;
                                          DesiredAccess:ULONG;
                                          VAR Privileges:PRIVILEGE_SET;
                                          AccessGranted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'ObjectPrivilegeAuditAlarmA';
       FUNCTION ObjectCloseAuditAlarm(CONST SubsystemName:CSTRING;
                                      VAR HandleId;GenerateOnClose:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'ObjectCloseAuditAlarmA';
       FUNCTION PrivilegedServiceAuditAlarm(CONST SubsystemName,ServiceName:CSTRING;
                                    ClientToken:HANDLE;
                                    VAR Privileges:PRIVILEGE_SET;
                                    AccessGranted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'PrivilegedServiceAuditAlarmA';
       FUNCTION IsValidSid(VAR pSid:SID):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsValidSid';
       FUNCTION EqualSid(VAR pSid1,pSid2:SID):BOOL;
                  APIENTRY;  'KERNEL32' name 'EqualSid';
       FUNCTION EqualPrefixSid(VAR pSid1,pSid2:SID):BOOL;
                  APIENTRY;  'KERNEL32' name 'EqualPrefixSid';
       FUNCTION GetSidLengthRequired(nSubAuthorityCount:BYTE):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetSidLengthRequired';
       FUNCTION AllocateAndInitializeSid(VAR pIdentifierAuthority:SID_IDENTIFIER_AUTHORITY;
                        nSubAuthorityCount:BYTE;
                        nSubAuthority0,nSubAuthority1,nSubAuthority2:ULONG;
                        nSubAuthority3,nSubAuthority4,nSubAuthority5:ULONG;
                        nSubAuthority6,nSubAuthority7:ULONG;
                        VAR pSid:PSID):BOOL;
                  APIENTRY;  'KERNEL32' name 'AllocateAndInitializeSid';
       FUNCTION FreeSid(VAR pSid:SID):POINTER;
                  APIENTRY;  'KERNEL32' name 'FreeSid';
       FUNCTION InitializeSid(VAR pIdentifierAuthority:SID_IDENTIFIER_AUTHORITY;
                              nSubAuthorityCount:BYTE):BOOL;
                  APIENTRY;  'KERNEL32' name 'InitializeSid';
       FUNCTION GetSidIdentifierAuthority(VAR pSid:SID):PSID_IDENTIFIER_AUTHORITY;
                  APIENTRY;  'KERNEL32' name 'GetSidIdentifierAuthority';
       FUNCTION GetSidSubAuthority(VAR pSid:SID;nSubAuthority:ULONG):PULONG;
                  APIENTRY;  'KERNEL32' name 'GetSidSubAuthority';
       FUNCTION GetSidSubAuthorityCount(VAR pSid:SID):PBYTE;
                  APIENTRY;  'KERNEL32' name 'GetSidSubAuthorityCount';
       FUNCTION GetLengthSid(VAR pSid:SID):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetLengthSid';
       FUNCTION CopySid(nDestinationSidLength:ULONG;
                        VAR pDestinationSid,pSourceSid:SID):BOOL;
                  APIENTRY;  'KERNEL32' name 'CopySid';
       FUNCTION AreAllAccessesGranted(GrantedAccess,DesiredAccess:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'AreAllAccessesGranted';
       FUNCTION AreAnyAccessesGranted(GrantedAccess,DesiredAccess:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'AreAnyAccessesGranted';
       PROCEDURE MapGenericMask(VAR AccessMask:ULONG;VAR GenericMapping:GENERIC_MAPPING);
                  APIENTRY;  'KERNEL32' name 'MapGenericMask';
       FUNCTION IsValidAcl(VAR pAcl:ACL):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsValidAcl';
       FUNCTION InitializeAcl(VAR pAcl:ACL;nAclLength,deAclRevision:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'InitializeAcl';
       FUNCTION GetAclInformation(VAR pAcl:ACL;VAR pAclInformation;
                                  nAclInformationlength:ULONG;
                                  dwAclInformationClass:ACL_INFORMATION_CLASS):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetAclInformation';
       FUNCTION SetAclInformation(VAR pAcl:ACL;VAR pAclInformation;
                                  nAclInformationLength:ULONG;
                                  dwAclInformationClass:ACL_INFORMATION_CLASS):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetAclInformation';
       FUNCTION AddAce(VAR pACL:ACL;dwAceRevision,dwStartingAceIndex:ULONG;
                       VAR pAceList;nAceListLength:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'AddAce';
       FUNCTION DeleteAce(VAR pAcl:ACL;deAceIndex:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'DeleteAce';
       FUNCTION GetAce(VAR pAcl:ACL;dwAceIndex:ULONG;VAR pAce:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetAce';
       FUNCTION AddAccessAllowedAce(VAR pAcl:ACL;dwAceRevision,AcessMask:ULONG;
                                    VAR pSid:SID):BOOL;
                  APIENTRY;  'KERNEL32' name 'AddAccessAllowedAce';
       FUNCTION AddAccessDeniedAce(VAR pAcl:ACL;dwAceRevision,dwAccessMask:ULONG;
                                   VAR pSid:SID):BOOL;
                  APIENTRY;  'KERNEL32' name 'AddAccessDeniedAce';
       FUNCTION AddAuditAccessAce(VAR pAcl:ACL;dwAceRevision,dwAccessMask:ULONG;
                                  VAR pSid:SID):BOOL;
                  APIENTRY;  'KERNEL32' name 'AddAuditAccessAce';
       FUNCTION FindFirstFreeAce(VAR pAcl:ACL;VAR pAce:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'FindFirstFreeAce';
       FUNCTION InitializeSecurityDescriptor(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                              dwRevision:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'InitializeSecurityDescriptor';
       FUNCTION IsValidSecurityDescriptor(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsValidSecurityDescriptor';
       FUNCTION GetSecurityDescriptorLength(VAR pSecurityDesciptor:SECURITY_DESCRIPTOR):ULONG;
                  APIENTRY;  'KERNEL32' name 'GetSecurityDescriptorLength';
       FUNCTION GetSecurityDescriptorControl(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                VAR pControl:SECURITY_DESCRITOR_CONTROL;
                                VAR lpdwRevision:ULONG):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetSecurityDescriptorControl';
       FUNCTION SetSecurityDescriptorDacl(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                           bDaclPresent:BOOL;VAR pDacl:ACL;
                                           bDaclDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetSecurityDescriptorDacl';
       FUNCTION GetSecurityDescriptorDacl(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                          VAR lpbDaclPresent:BOOL;
                                          VAR pDacl:PACL;VAR lpbDaclDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetSecurityDescriptorDacl';
       FUNCTION SetSecurityDescriptorSacl(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                          bSaclPresent:BOOL;VAR pSacl:ACL;
                                          bSaclDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetSecurityDescriptorSacl';
       FUNCTION GetSecurityDescriptorSacl(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                          VAR lpbSaclPresent:BOOL;VAR pSacl:PACL;
                                          VAR lpbSaclDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetSecurityDescriptorSacl';
       FUNCTION SetSecurityDescriptorOwner(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                           VAR pOwner:SID;bOwnerDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetSecurityDescriptorOwner';
       FUNCTION GetSecurityDescriptorOwner(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                           VAR pOwner:PSID;VAR lpbOwnerDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetSecurityDescriptorOwner';
       FUNCTION SetSecurityDescriptorGroup(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                           VAR pGroup:SID;bGroupDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetSecurityDescriptorGroup';
        FUNCTION GetSecurityDescriptorGroup(VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;
                                            VAR pGroup:SID;VAR lpGroupDefaulted:BOOL):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetSecurityDescriptorGroup';
        FUNCTION CreatePrivateObjectSecurity(VAR ParentDescriptor,CreatorDescritor:SECURITY_DESCRIPTOR;
                                             VAR NewDescriptor:PSECURITY_DESCRIPTOR;
                                             IsDirectoryObject:BOOL;Token:HANDLE;
                                             VAR GenericMapping:GENERIC_MAPPING):BOOL;
                  APIENTRY;  'KERNEL32' name 'CreatePrivateObjectSecurity';
        FUNCTION SetPrivateObjectSecurity(SecurityInformation:SECURITY_INFORMATION;
                                          VAR ModificationDescriptor:SECURITY_DESCRIPTOR;
                                          VAR ObjectsSecurityDescriptor:PSECURITY_DESCRIPTOR;
                                          VAR GenericMapping:GENERIC_MAPPING;
                                          Token:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetPrivateObjectSecurity';
        FUNCTION GetPrivateObjectSecurity(VAR ObjectDescriptor:SECURITY_DESCRIPTOR;
                                          SecurityInformation:SECURITY_INFORMATION;
                                          VAR ResultantDescriptor:SECURITY_DESCRIPTOR;
                                          DescriptorLength:LONGWORD;VAR ReturnLength:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetPrivateObjectSecurity';
        FUNCTION DestroyPrivateObjectSecurity(VAR ObjectDescriptor:PSECURITY_DESCRIPTOR):BOOL;
                  APIENTRY;  'KERNEL32' name 'DestroyPrivateObjectSecurity';
        FUNCTION MakeSelfRelativeSD(VAR pAbsoluteSecurityDescriptor,pSelfRelativeSecurityDescriptor:SECURITY_DESCRIPTOR;
                                    VAR lpdwBufferLength:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'MakeSelfRelativeSD';
        FUNCTION MakeAbsoluteSD(VAR pSelfRelativeSecurityDescriptor,pAbsoluteSecurityDescriptor:SECURITY_DESCRIPTOR;
                                VAR lpdwAbsoluteSecurityDescriptorSize:LONGWORD;VAR pDacl:ACL;
                                VAR lpdwDaclSize:LONGWORD;VAR pSacl:ACL;VAR lpdwSaclSize:LONGWORD;
                                VAR pOwner:SID;VAR lpdwOwnerSize:LONGWORD;VAR pPrimaryGroup:SID;
                                VAR lpdwPrimaryGroupSize:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'MakeAbsoluteSD';
        FUNCTION SetFileSecurity(CONST lpFileName:CSTRING;SecurityInformation:SECURITY_INFORMATION;
                                 VAR pSecurityDescriptor:SECURITY_DESCRIPTOR):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetFileSecurityA';
        FUNCTION GetFileSecurity(CONST lpFileName:CSTRING;SecurityInformation:SECURITY_INFORMATION;
                                 VAR pSecurityDescriptor:SECURITY_DESCRIPTOR;nLength:LONGWORD;
                                 VAR lpnLengthNeeded:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetFileSecurityA';
        FUNCTION SetKernelObjectSecurity(aHandle:HANDLE;SecurityInformation:SECURITY_INFORMATION;
                                         VAR pSecurityDescriptor:SECURITY_DESCRIPTOR):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetKernelObjectSecurity';
        FUNCTION FindFirstChangeNotification(CONST lpPathName:CSTRING;bWatchSubTree:BOOL;
                                             dwNotifyFilter:LONGWORD):HANDLE;
                  APIENTRY;  'KERNEL32' name 'FindFirstChangeNotificationA';
        FUNCTION FindNextChangeNotification(hChangeHandle:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'FindNextChangeNotification';
        FUNCTION FindCloseChangeNotification(hChangeHandle:HANDLE):BOOL;
                  APIENTRY;  'KERNEL32' name 'FindCloseChangeNotification';}
        FUNCTION VirtualLock(VAR lpAdress;dwSize:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'VirtualLock';
        FUNCTION VirtualUnlock(VAR lpAdress;dwSize:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'VirtualUnlock';
        FUNCTION MapViewOfFileEx(hFileMappingObject:HANDLE;dwDesiredAccess,dwFileOffsetHigh,
                                 dwFileOffsetLow,dwNumberOfBytesToMap:LONGWORD;
                                 VAR lpBaseAddress):POINTER;
                  APIENTRY;  'KERNEL32' name 'MapViewOfFileEx';
        FUNCTION SetPriorityClass(hProcess:HANDLE;dwPriorityClass:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetPriorityClass';
        FUNCTION GetPriorityClass(hProcess:HANDLE):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'GetPriorityClass';
        FUNCTION IsBadReadPtr(lp:POINTER;ucb:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsBadReadPtr';
        FUNCTION IsBadWritePtr(lp:POINTER;ucb:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsBadWritePtr';
        FUNCTION IsBadHugeReadPtr(lp:POINTER;ucb:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsBadHugeReadPtr';
        FUNCTION IsBadHugeWritePtr(lp:POINTER;ucb:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsBadHugeWritePtr';
        FUNCTION IsBadCodePtr(lpfn:POINTER):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsBadCodePtr';
        FUNCTION IsBadStringPtr(CONST lpsz:CSTRING;ucchMax:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'IsBadStringPtrA';
        {FUNCTION LookupAccountSid(CONST lpSystemName:CSTRING;VAR aSid:SID;VAR Name:CSTRING;
                                   VAR cbName:LONGWORD;VAR ReferencedDomainName:CSTRING;
                                   VAR cbReferencedDomainName:LONGWORD;VAR peUse:SID_NAME_USE):BOOL;
                  APIENTRY;  'KERNEL32' name 'LookupAccountSidA';
        FUNCTION LookupAccountName(CONST lpSystemName:CSTRING;lpAccountName:CSTRING;VAR aSid:SID;
                                   VAR cbSid:LONGWORD;VAR ReferencedDomainName:CSTRING;
                                   VAR cbReferencedDomainName:LONGWORD;VAR peUse:SID_NAME_USE):BOOL;
                  APIENTRY;  'KERNEL32' name 'LookupAccountNameA';
        FUNCTION LookupPrivilegeValue(CONST lpSystemName:CSTRING;CONST lpName:CSTRING;VAR alpLuid:LUID):BOOL;
                  APIENTRY;  'KERNEL32' name 'LookupPrivilegeValueA';
        FUNCTION LookupPrivilegeName(CONST lpSystemName:CSTRING;VAR alpLuid:LUID;VAR lpName:CSTRING;
                                      VAR cbName:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'LookupPrivilegeNameA';
        FUNCTION LookupPrivilegeDisplayName(CONST lpSystemName,lpName:CSTRING;VAR lpDisplayName:CSTRING;
                                            VAR cbDisplayName,lpLanguageId:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'LookupPrivilegeDisplayNameA';
        FUNCTION AllocateLocallyUniqueId(VAR aLuid:LUID):BOOL;
                  APIENTRY;  'KERNEL32' name 'AllocateLocallyUniqueId';
        FUNCTION BuildCommDCB(CONST lpDef:CSTRING;VAR alpDCB:DCB):BOOL;
                  APIENTRY;  'KERNEL32' name 'BuildCommDCBA';
        FUNCTION BuildCommDCBAndTimeouts(CONST lpDef:CSTRING;VAR alpDCB:DCB;VAR alpCommTimeOuts:COMMTIMEOUTS):BOOL;
                  APIENTRY;  'KERNEL32' name 'BuildCommDCBAndTimeoutsA';
        FUNCTION CommConfigDialog(CONST lpszName:CSTRING;ahWnd:HWND;VAR lpCC:COMMCONFIG):BOOL;
                  APIENTRY;  'KERNEL32' name 'CommConfigDialogA';
        FUNCTION GetDefaultCommConfig(CONST lpszName:CSTRING;VAR lpCC:COMMCONFIG;VAR lpdwSize:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetDefaultCommConfigA';
        FUNCTION SetDefaultCommConfig(CONST lpszName:CSTRING;VAR lpCC:COMMCONFIG;dwSize:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetDefaultCommConfigA';}
        FUNCTION GetComputerName(VAR lpBuffer:CSTRING;VAR nSize:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetComputerNameA';
        FUNCTION SetComputerName(CONST lpComputerName:CSTRING):BOOL;
                  APIENTRY;  'KERNEL32' name 'SetComputerNameA';
        FUNCTION GetUserName(VAR lpBuffer:CSTRING;VAR nSize:LONGWORD):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetUserNameA';
        FUNCTION QueryPerformanceCounter(VAR lpPerformanceCount:LARGE_INTEGER):BOOL;
                  APIENTRY;  'KERNEL32' name 'QueryPerformanceCounter';
        FUNCTION QueryPerformanceFrequency(VAR lpFrequency:LARGE_INTEGER):BOOL;
                  APIENTRY;  'KERNEL32' name 'QueryPerformanceFrequency';
        FUNCTION GetVersionEx(lpVersionInformation:OSVERSIONINFO):BOOL;
                  APIENTRY;  'KERNEL32' name 'GetVersionExA';

        Function GetSystemDefaultLCID : LongWord;
                  APIENTRY;  'KERNEL32' name 'GetSystemDefaultLCID';
        Function GetUserDefaultLCID : LongWord;
                  APIENTRY;  'KERNEL32' name 'GetUserDefaultLCID';
        FUNCTION GetLocaleInfo(LCID : LongWord; LCType : LongWord;
                          var lpLCData : CString;
                          lLength : Longword) : LongWord;
                  APIENTRY;  'KERNEL32' name 'GetLocaleInfoA';
END;

FUNCTION FreeModule(hLibModule:HINSTANCE):BOOL;
FUNCTION MakeProcInstance(lpProc:POINTER;ahInstance:HINSTANCE):POINTER;
FUNCTION FreeProcInstance(lpProc:POINTER):POINTER;
FUNCTION GlobalLRUNewest(h:HGLOBAL):HANDLE;
FUNCTION GlobalLRUOldest(h:HGLOBAL):HANDLE;
FUNCTION GlobalDiscard(h:HGLOBAL):HGLOBAL;
FUNCTION LocalDiscard(h:HGLOBAL):HGLOBAL;
FUNCTION GetFreeSpace(w:LONGWORD):LONGWORD;

IMPLEMENTATION

FUNCTION FreeModule(hLibModule:HINSTANCE):BOOL;
BEGIN
     result:=FreeLibrary(hLibModule);
END;

FUNCTION MakeProcInstance(lpProc:POINTER;ahInstance:HINSTANCE):POINTER;
BEGIN
     result:=lpProc;
END;

FUNCTION FreeProcInstance(lpProc:POINTER):POINTER;
BEGIN
     result:=lpProc;
END;

FUNCTION GlobalLRUNewest(h:HGLOBAL):HANDLE;
BEGIN
     result:=h;
END;

FUNCTION GlobalLRUOldest(h:HGLOBAL):HANDLE;
BEGIN
     result:=h;
END;

FUNCTION GlobalDiscard(h:HGLOBAL):HGLOBAL;
BEGIN
     result:=GlobalReAlloc(h,0,GMEM_MOVEABLE);
END;

FUNCTION LocalDiscard(h:HGLOBAL):HGLOBAL;
BEGIN
     result:=LocalReAlloc(h,0,LMEM_MOVEABLE);
END;

FUNCTION GetFreeSpace(w:LONGWORD):LONGWORD;
BEGIN
     result:=$100000;
END;

END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  06-Aug-04   MV        Funktion GetDiskFreeSpaceEx eingebaut.
  29-Jul-06   WD        Neue Konstanten eingebaut.
}


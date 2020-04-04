
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT WinNT;

{****************************************************************************
 *                                                                          *
 * 32 Bit Windows constants and types for use with Win32 and DAX            *
 *                                                                          *
 ****************************************************************************}

INTERFACE

CONST
     HEAP_NO_SERIALIZE               =$00000001;
     HEAP_GROWABLE                   =$00000002;
     HEAP_GENERATE_EXCEPTIONS        =$00000004;
     HEAP_ZERO_MEMORY                =$00000008;
     HEAP_REALLOC_IN_PLACE_ONLY      =$00000010;
     HEAP_TAIL_CHECKING_ENABLED      =$00000020;
     HEAP_FREE_CHECKING_ENABLED      =$00000040;
     HEAP_DISABLE_COALESCE_ON_FREE   =$00000080;


TYPE
    LPCH       = PChar;
    PCH        = PChar;

    PSHORT     = ^SHORT;
    SHORT      = ShortInt;
    PLONG      = ^LONG;
    LONG       = LongInt;

    Handle     = LONGWORD;

    CCHAR      = char;

    PLCID      = ^LCID;
    LCID       = LongWord;


CONST
     APPLICATION_ERROR_MASK       =$20000000;
     ERROR_SEVERITY_SUCCESS       =$00000000;
     ERROR_SEVERITY_INFORMATIONAL =$40000000;
     ERROR_SEVERITY_WARNING       =$80000000;
     ERROR_SEVERITY_ERROR         =$C0000000;

CONST
     MINCHAR        =$80;
     MAXCHAR        =$7F;
     MINSHORT       =$8000;
     MAXSHORT       =$7FFF;
     MINLONG        =$80000000;
     MAXLONG        =$7FFFFFFF;
     MAXBYTE        =$ff;
     MAXWORD        =$ffff;
     MAXDWORD       =$ffffffff;

CONST
     LANG_NEUTRAL                   = $00;
     LANG_BULGARIAN                 = $02;
     LANG_CHINESE                   = $04;
     LANG_CROATIAN                  = $1a;
     LANG_CZECH                     = $05;
     LANG_DANISH                    = $06;
     LANG_DUTCH                     = $13;
     LANG_ENGLISH                   = $09;
     LANG_FINNISH                   = $0b;
     LANG_FRENCH                    = $0c;
     LANG_GERMAN                    = $07;
     LANG_GREEK                     = $08;
     LANG_HUNGARIAN                 = $0e;
     LANG_ICELANDIC                 = $0f;
     LANG_ITALIAN                   = $10;
     LANG_JAPANESE                  = $11;
     LANG_KOREAN                    = $12;
     LANG_NORWEGIAN                 = $14;
     LANG_POLISH                    = $15;
     LANG_PORTUGUESE                = $16;
     LANG_ROMANIAN                  = $18;
     LANG_RUSSIAN                   = $19;
     LANG_SLOVAK                    = $1b;
     LANG_SLOVENIAN                 = $24;
     LANG_SPANISH                   = $0a;
     LANG_SWEDISH                   = $1d;
     LANG_TURKISH                   = $1f;

     SUBLANG_NEUTRAL                = $00;   /* language neutral */
     SUBLANG_DEFAULT                = $01;   /* user default */
     SUBLANG_SYS_DEFAULT            = $02;   /* system default */

     SUBLANG_CHINESE_TRADITIONAL    = $01;   /* Chinese (Taiwan) */
     SUBLANG_CHINESE_SIMPLIFIED     = $02;   /* Chinese (PR China) */
     SUBLANG_CHINESE_HONGKONG       = $03;   /* Chinese (Hong Kong) */
     SUBLANG_CHINESE_SINGAPORE      = $04;   /* Chinese (Singapore) */
     SUBLANG_DUTCH                  = $01;   /* Dutch */
     SUBLANG_DUTCH_BELGIAN          = $02;   /* Dutch (Belgian) */
     SUBLANG_ENGLISH_US             = $01;   /* English (USA) */
     SUBLANG_ENGLISH_UK             = $02;   /* English (UK) */
     SUBLANG_ENGLISH_AUS            = $03;   /* English (Australian) */
     SUBLANG_ENGLISH_CAN            = $04;   /* English (Canadian) */
     SUBLANG_ENGLISH_NZ             = $05;   /* English (New Zealand) */
     SUBLANG_ENGLISH_EIRE           = $06;   /* English (Irish) */
     SUBLANG_FRENCH                 = $01;   /* French */
     SUBLANG_FRENCH_BELGIAN         = $02;   /* French (Belgian) */
     SUBLANG_FRENCH_CANADIAN        = $03;   /* French (Canadian) */
     SUBLANG_FRENCH_SWISS           = $04;   /* French (Swiss) */
     SUBLANG_GERMAN                 = $01;   /* German */
     SUBLANG_GERMAN_SWISS           = $02;   /* German (Swiss) */
     SUBLANG_GERMAN_AUSTRIAN        = $03;   /* German (Austrian) */
     SUBLANG_ITALIAN                = $01;   /* Italian */
     SUBLANG_ITALIAN_SWISS          = $02;   /* Italian (Swiss) */
     SUBLANG_NORWEGIAN_BOKMAL       = $01;   /* Norwegian (Bokmal) */
     SUBLANG_NORWEGIAN_NYNORSK      = $02;   /* Norwegian (Nynorsk) */
     SUBLANG_PORTUGUESE             = $02;   /* Portuguese */
     SUBLANG_PORTUGUESE_BRAZILIAN   = $01;   /* Portuguese (Brazilian) */
     SUBLANG_SPANISH                = $01;   /* Spanish (Castilian) */
     SUBLANG_SPANISH_MEXICAN        = $02;   /* Spanish (Mexican) */
     SUBLANG_SPANISH_MODERN         = $03;   /* Spanish (Modern) */

CONST
    SORT_DEFAULT                   = $0;     /* sorting default */

    SORT_JAPANESE_XJIS             = $0;     /* Japanese XJIS order */
    SORT_JAPANESE_UNICODE          = $1;     /* Japanese Unicode order */

    SORT_CHINESE_BIG5              = $0;     /* Chinese BIG5 order */
    SORT_CHINESE_UNICODE           = $1;     /* Chinese Unicode order */

    SORT_KOREAN_KSC                = $0;     /* Korean KSC order */
    SORT_KOREAN_UNICODE            = $1;     /* Korean Unicode order */


CONST
     NLS_VALID_LOCALE_MASK  =$000fffff;

CONST
     STATUS_WAIT_0                    =$00000000;
     STATUS_ABANDONED_WAIT_0          =$00000080;
     STATUS_USER_APC                  =$000000C0;
     STATUS_TIMEOUT                   =$00000102;
     STATUS_PENDING                   =$00000103;
     STATUS_GUARD_PAGE_VIOLATION      =$80000001;
     STATUS_DATATYPE_MISALIGNMENT     =$80000002;
     STATUS_BREAKPOINT                =$80000003;
     STATUS_SINGLE_STEP               =$80000004;
     STATUS_ACCESS_VIOLATION          =$C0000005;
     STATUS_IN_PAGE_ERROR             =$C0000006;
     STATUS_NO_MEMORY                 =$C0000017;
     STATUS_ILLEGAL_INSTRUCTION       =$C000001D;
     STATUS_NONCONTINUABLE_EXCEPTION  =$C0000025;
     STATUS_INVALID_DISPOSITION       =$C0000026;
     STATUS_ARRAY_BOUNDS_EXCEEDED     =$C000008C;
     STATUS_FLOAT_DENORMAL_OPERAND    =$C000008D;
     STATUS_FLOAT_DIVIDE_BY_ZERO      =$C000008E;
     STATUS_FLOAT_INEXACT_RESULT      =$C000008F;
     STATUS_FLOAT_INVALID_OPERATION   =$C0000090;
     STATUS_FLOAT_OVERFLOW            =$C0000091;
     STATUS_FLOAT_STACK_CHECK         =$C0000092;
     STATUS_FLOAT_UNDERFLOW           =$C0000093;
     STATUS_INTEGER_DIVIDE_BY_ZERO    =$C0000094;
     STATUS_INTEGER_OVERFLOW          =$C0000095;
     STATUS_PRIVILEGED_INSTRUCTION    =$C0000096;
     STATUS_STACK_OVERFLOW            =$C00000FD;
     STATUS_CONTROL_C_EXIT            =$C000013A;

CONST
     MAXIMUM_WAIT_OBJECTS   = 64;
     MAXIMUM_SUSPEND_COUNT  = MAXCHAR;

CONST
     CONTEXT_i386    = $00010000;    // this assumes that i386 and
     CONTEXT_i486    = $00010000;    // i486 have identical context records

     CONTEXT_CONTROL = CONTEXT_i386 OR $00000001; // SS:SP, CS:IP, FLAGS, BP
     CONTEXT_INTEGER = CONTEXT_i386 OR $00000002; // AX, BX, CX, DX, SI, DI
     CONTEXT_SEGMENTS= CONTEXT_i386 OR $00000004; // DS, ES, FS, GS
     CONTEXT_FLOATING_POINT=CONTEXT_i386 OR $00000008;  // 387 state
     CONTEXT_DEBUG_REGISTERS=CONTEXT_i386 OR $00000010; // DB 0-3,6,7
     CONTEXT_FULL    = CONTEXT_CONTROL OR CONTEXT_INTEGER OR CONTEXT_SEGMENTS;

CONST
     PAGE_NOACCESS          =$01;
     PAGE_READONLY          =$02;
     PAGE_READWRITE         =$04;
     PAGE_WRITECOPY         =$08;
     PAGE_EXECUTE           =$10;
     PAGE_EXECUTE_READ      =$20;
     PAGE_EXECUTE_READWRITE =$40;
     PAGE_EXECUTE_WRITECOPY =$80;
     PAGE_GUARD             =$100;
     PAGE_NOCACHE           =$200;
     MEM_COMMIT             =$1000;
     MEM_RESERVE            =$2000;
     MEM_DECOMMIT           =$4000;
     MEM_RELEASE            =$8000;
     MEM_FREE               =$10000;
     MEM_PRIVATE            =$20000;
     MEM_MAPPED             =$40000;
     MEM_TOP_DOWN           =$100000;
     SEC_FILE               =$800000;
     SEC_IMAGE              =$1000000;
     SEC_RESERVE            =$4000000;
     SEC_COMMIT             =$8000000;
     SEC_NOCACHE            =$10000000;
     MEM_IMAGE              =SEC_IMAGE;

{access rights to files and directories}
CONST
    GENERIC_READ            =$80000000;
    GENERIC_WRITE           =$40000000;
    GENERIC_EXECUTE         =$20000000;
    GENERIC_ALL             =$10000000;

CONST
    FILE_READ_DATA            =$0001;
    FILE_LIST_DIRECTORY       =$0001;
    FILE_WRITE_DATA           =$0002;
    FILE_ADD_FILE             =$0002;
    FILE_APPEND_DATA          =$0004;
    FILE_ADD_SUBDIRECTORY     =$0004;
    FILE_CREATE_PIPE_INSTANCE =$0004;
    FILE_READ_EA              =$0008;
    FILE_READ_PROPERTIES      =FILE_READ_EA;
    FILE_WRITE_EA             =$0010;
    FILE_WRITE_PROPERTIES     =FILE_WRITE_EA;
    FILE_EXECUTE              =$0020;
    FILE_TRAVERSE             =$0020;
    FILE_DELETE_CHILD         =$0040;
    FILE_READ_ATTRIBUTES      =$0080;
    FILE_WRITE_ATTRIBUTES     =$0100;

CONST
    FILE_SHARE_READ                 =$00000001;
    FILE_SHARE_WRITE                =$00000002;
    FILE_ATTRIBUTE_READONLY         =$00000001;
    FILE_ATTRIBUTE_HIDDEN           =$00000002;
    FILE_ATTRIBUTE_SYSTEM           =$00000004;
    FILE_ATTRIBUTE_DIRECTORY        =$00000010;
    FILE_ATTRIBUTE_ARCHIVE          =$00000020;
    FILE_ATTRIBUTE_NORMAL           =$00000080;
    FILE_ATTRIBUTE_TEMPORARY        =$00000100;
    FILE_ATTRIBUTE_ATOMIC_WRITE     =$00000200;
    FILE_ATTRIBUTE_XACTION_WRITE    =$00000400;
    FILE_ATTRIBUTE_COMPRESSED       =$00000800;
    FILE_ATTRIBUTE_HAS_EMBEDDING    =$00001000;
    FILE_NOTIFY_CHANGE_FILE_NAME    =$00000001;
    FILE_NOTIFY_CHANGE_DIR_NAME     =$00000002;
    FILE_NOTIFY_CHANGE_ATTRIBUTES   =$00000004;
    FILE_NOTIFY_CHANGE_SIZE         =$00000008;
    FILE_NOTIFY_CHANGE_LAST_WRITE   =$00000010;
    FILE_NOTIFY_CHANGE_SECURITY     =$00000100;
    MAILSLOT_NO_MESSAGE             =-1;
    MAILSLOT_WAIT_FOREVER           =-1;
    FILE_CASE_SENSITIVE_SEARCH      =$00000001;
    FILE_CASE_PRESERVED_NAMES       =$00000002;
    FILE_UNICODE_ON_DISK            =$00000004;
    FILE_PERSISTENT_ACLS            =$00000008;
    FILE_FILE_COMPRESSION           =$00000010;
    FILE_VOLUME_IS_COMPRESSED       =$00008000;
    IO_COMPLETION_MODIFY_STATE      =$0002;
    DUPLICATE_CLOSE_SOURCE          =$00000001;
    DUPLICATE_SAME_ACCESS           =$00000002;

    TLS_MINIMUM_AVAILABLE       =64;
    THREAD_BASE_PRIORITY_LOWRT  =15;
    THREAD_BASE_PRIORITY_MAX    =2;
    THREAD_BASE_PRIORITY_MIN    =-2;
    THREAD_BASE_PRIORITY_IDLE   =-15;
    EVENT_MODIFY_STATE          =2;
    MUTANT_QUERY_STATE          =1;
    ANYSIZE_ARRAY               =1;

    API_DELETE                  =$00010000; {was DELETE !!!!!!!!!!}
    READ_CONTROL                =$00020000;
    WRITE_DAC                   =$00040000;
    WRITE_OWNER                 =$00080000;
    SYNCHRONIZE                 =$00100000;

    STANDARD_RIGHTS_REQUIRED    =$000F0000;
    STANDARD_RIGHTS_READ        =READ_CONTROL;
    STANDARD_RIGHTS_WRITE       =READ_CONTROL;
    STANDARD_RIGHTS_EXECUTE     =READ_CONTROL;

    STANDARD_RIGHTS_ALL         =$001F0000;

    SPECIFIC_RIGHTS_ALL         =$0000FFFF;

    EVENT_ALL_ACCESS  = STANDARD_RIGHTS_REQUIRED OR SYNCHRONIZE OR 3;
    MUTANT_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED OR SYNCHRONIZE OR MUTANT_QUERY_STATE;

TYPE
    PMEMORY_BASIC_INFORMATION=^MEMORY_BASIC_INFORMATION;
    MEMORY_BASIC_INFORMATION=RECORD
                                   BaseAddress:POINTER;
                                   AllocationBase:POINTER;
                                   AllocationProtect:LONGWORD;
                                   RegionSize:LONGWORD;
                                   State:LONGWORD;
                                   Protect:LONGWORD;
                                   aType:LONGWORD;
                             END;

CONST
     SECTION_QUERY       =$0001;
     SECTION_MAP_WRITE   =$0002;
     SECTION_MAP_READ    =$0004;
     SECTION_MAP_EXECUTE =$0008;
     SECTION_EXTEND_SIZE =$0010;

CONST
     DBG_CONTINUE              =$00010002;
     DBG_TERMINATE_THREAD      =$40010003;
     DBG_TERMINATE_PROCESS     =$40010004;
     DBG_CONTROL_C             =$40010005;
     DBG_CONTROL_BREAK         =$40010008;
     DBG_EXCEPTION_NOT_HANDLED =$80010001;

FUNCTION MAKELANGID(p,s:LONGWORD):LONGWORD;
FUNCTION PRIMARYLANGID(lgid:LONGWORD):LONGWORD;
FUNCTION SUBLANGID(lgid:LONGWORD):LONGWORD;

IMPLEMENTATION

FUNCTION MAKELANGID(p,s:LONGWORD):LONGWORD;
BEGIN
     result:=(s SHL 10) OR p;
END;

FUNCTION PRIMARYLANGID(lgid:LONGWORD):LONGWORD;
BEGIN
     result:=lgid AND $3ff;
END;

FUNCTION SUBLANGID(lgid:LONGWORD):LONGWORD;
BEGIN
     result:=lgid SHR 10;
END;

END.

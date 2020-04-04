
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT BseExcpt;

{****************************************************************************
 *                                                                          *
 * Descriptive Name: Thread Exception Constants and Structure Definitions   *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES OS2Def;

{ User Exception Handler Return Codes: }


CONST
       XCPT_CONTINUE_SEARCH    =$00000000;     { exception not handled   }
       XCPT_CONTINUE_EXECUTION =$FFFFFFFF;     { exception handled       }
       XCPT_CONTINUE_STOP      =$00716668;     { exception handled by    }
                                                { debugger (VIA DosDebug) }

{
 * fHandlerFlags values (see ExceptionReportRecord):
 *
 * The user may only set (but not clear) the EH_NONCONTINUABLE flag.
 * All other flags are set by the system.
 *
 }

       EH_NONCONTINUABLE   =$1;         { Noncontinuable exception }
       EH_UNWINDING        =$2;         { Unwind is in progress }
       EH_EXIT_UNWIND      =$4;         { Exit unwind is in progress }
       EH_STACK_INVALID    =$8;         { Stack out of limits or unaligned }
       EH_NESTED_CALL      =$10;        { Nested exception handler call }


{
 * Unwind all exception handlers (see DosUnwindException API)
 }
       UNWIND_ALL          =0;


{
 *   Exception values are 32 bit values layed out as follows:
 *
 *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
 *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 *   +---+-+-------------------------+-------------------------------+
 *   |Sev|C|       Facility          |               Code            |
 *   +---+-+-------------------------+-------------------------------+
 *
 *   where
 *
 *       Sev - is the severity code
 *           00 - Success
 *           01 - Informational
 *           10 - Warning
 *           11 - Error
 *
 *       C - is the Customer code flag
 *
 *       Facility - is the facility code
 *
 *       Code - is the facility's status code
 *
 *   Exceptions specific to OS/2 2.0 (e.g. XCPT_SIGNAL) will be marked
 *   with a facility code of 1.
 *
 *   System defined exceptions have a facility code of zero.
 *
 *   Each exception may also have several pieces of additional information.
 *   These are stored in the ExceptionInfo fields of the
 *   ExceptionReportRecord. They are documented here with the exceptions
 *   only for ease of reference.
 }

       XCPT_FATAL_EXCEPTION    =$C0000000;
       XCPT_SEVERITY_CODE      =$C0000000;
       XCPT_CUSTOMER_CODE      =$20000000;
       XCPT_FACILITY_CODE      =$1FFF0000;
       XCPT_EXCEPTION_CODE     =$0000FFFF;

{  Violation flags in ExceptionInfo }

       XCPT_UNKNOWN_ACCESS     =$00000000;     { Unknown access }
       XCPT_READ_ACCESS        =$00000001;     { Read access    }
       XCPT_WRITE_ACCESS       =$00000002;     { Write access   }
       XCPT_EXECUTE_ACCESS     =$00000004;     { Execute access }
       XCPT_SPACE_ACCESS       =$00000008;     { Address space access }
       XCPT_LIMIT_ACCESS       =$00000010;     { Address space limit violation }
       XCPT_DATA_UNKNOWN       =$FFFFFFFF;

{  Signal numbers for XCPT_SIGNAL }

       XCPT_SIGNAL_INTR        =1;
       XCPT_SIGNAL_KILLPROC    =3;
       XCPT_SIGNAL_BREAK       =4;

{  Portable non-fatal software generated exceptions }

       XCPT_GUARD_PAGE_VIOLATION       =$80000001;
      { ExceptionInfo[ 0 ] - Access Code: XCPT_READ_ACCESS
                                           XCPT_WRITE_ACCESS }
      { ExceptionInfo[ 1 ] - FaultAddr }

       XCPT_UNABLE_TO_GROW_STACK       =$80010001;

{  Portable fatal hardware generated exceptions }

       XCPT_DATATYPE_MISALIGNMENT      =$C000009E;
      { ExceptionInfo[ 0 ] - Access Code: XCPT_READ_ACCESS
                                           XCPT_WRITE_ACCESS }
      { ExceptionInfo[ 1 ] - Alignment }
      { ExceptionInfo[ 2 ] - FaultAddr }

       XCPT_BREAKPOINT                 =$C000009F;
       XCPT_SINGLE_STEP                =$C00000A0;
       XCPT_ACCESS_VIOLATION           =$C0000005;
      { ExceptionInfo[ 0 ] - Access Code: XCPT_READ_ACCESS
                                           XCPT_WRITE_ACCESS
                                           XCPT_SPACE_ACCESS
                                           XCPT_LIMIT_ACCESS
                                           XCPT_UNKNOWN_ACCESS }
      { ExceptionInfo[ 1 ] - FaultAddr (XCPT_READ_ACCESS/XCPT_WRITE_ACCESS)
                              Selector  (XCPT_SPACE_ACCESS)
                              -1        (XCPT_LIMIT_ACCESS) }

       XCPT_ILLEGAL_INSTRUCTION        =$C000001C;
       XCPT_FLOAT_DENORMAL_OPERAND     =$C0000094;
       XCPT_FLOAT_DIVIDE_BY_ZERO       =$C0000095;
       XCPT_FLOAT_INEXACT_RESULT       =$C0000096;
       XCPT_FLOAT_INVALID_OPERATION    =$C0000097;
       XCPT_FLOAT_OVERFLOW             =$C0000098;
       XCPT_FLOAT_STACK_CHECK          =$C0000099;
       XCPT_FLOAT_UNDERFLOW            =$C000009A;
       XCPT_INTEGER_DIVIDE_BY_ZERO     =$C000009B;
       XCPT_INTEGER_OVERFLOW           =$C000009C;
       XCPT_PRIVILEGED_INSTRUCTION     =$C000009D;

{  Portable fatal software generated exceptions }

       XCPT_IN_PAGE_ERROR              =$C0000006;
      { ExceptionInfo[ 0 ] - FaultAddr }

       XCPT_PROCESS_TERMINATE          =$C0010001;
       XCPT_ASYNC_PROCESS_TERMINATE    =$C0010002;
      { ExceptionInfo[ 0 ] - TID of 'terminator' thread }

       XCPT_NONCONTINUABLE_EXCEPTION   =$C0000024;
       XCPT_INVALID_DISPOSITION        =$C0000025;

{  Non-portable fatal exceptions }

       XCPT_INVALID_LOCK_SEQUENCE      =$C000001D;
       XCPT_ARRAY_BOUNDS_EXCEEDED      =$C0000093;
       XCPT_B1NPX_ERRATA_02            =$C0010004;

{  Misc exceptions }

       XCPT_UNWIND                     =$C0000026;
       XCPT_BAD_STACK                  =$C0000027;
       XCPT_INVALID_UNWIND_TARGET      =$C0000028;

{  Signal Exceptions }

       XCPT_SIGNAL                     =$C0010003;
      { ExceptionInfo[ 0 ] - Signal Number }

{
 * ContextRecord
 *
 * This is the machine specific register contents for the thread
 * at the time of the exception. Note that only the register sets
 * specified by ContextFlags contain valid data. Conversely, only
 * registers specified in ContextFlags will be restored if an exception
 * is handled.
 }

{  The following flags control the contents of the CONTEXT structure. }

       CONTEXT_CONTROL         =$00000001;     { SS:ESP, CS:EIP, EFLAGS,  }
                                                { EBP                      }
       CONTEXT_INTEGER         =$00000002;     { EAX, EBX, ECX, EDX, ESI, }
                                                { EDI                      }
       CONTEXT_SEGMENTS        =$00000004;     { DS, ES, FS, GS           }
       CONTEXT_FLOATING_POINT  =$00000008;     { numeric coprocessor state }

       CONTEXT_FULL            =CONTEXT_CONTROL OR CONTEXT_INTEGER OR
                                CONTEXT_SEGMENTS OR CONTEXT_FLOATING_POINT;


IMPLEMENTATION

BEGIN
END.



{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT BseTIB;

{****************************************************************************
 *                                                                          *
 * OS/2 Thread Information Block Include File                               *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES Os2Def;

{ Thread Information Block (TIB) }

TYPE
    PTIB2=^TIB2;
    TIB2=RECORD
              tib2_ultid:ULONG;             { Thread I.D. }
              tib2_ulpri:ULONG;             { Thread priority }
              tib2_version:ULONG;           { Version number for this structure }
              tib2_usMCCount:USHORT;        { Must Complete count }
              tib2_fMCForceFlag:USHORT;     { Must Complete force flag }
         END;

    PTIB=^TIB;
    TIB=RECORD
              tib_pexchain:POINTER;     { Head of exception handler chain }
              tib_pstack:POINTER;       { Pointer to base of stack }
              tib_pstacklimit:POINTER;  { Pointer to end of stack }
              tib_ptib2:PTIB2;          { Pointer to system specific TIB }
              tib_version:ULONG;        { Version number for this TIB structure }
              tib_ordinal:ULONG;        { Thread ordinal number        }
        END;


{ Process Information Block (PIB) }

TYPE
    PPIB=^PIB;
    PIB=RECORD
             pib_ulpid:ULONG;          { Process I.D. }
             pib_ulppid:ULONG;         { Parent process I.D. }
             pib_hmte:ULONG;           { Program (.EXE) module handle }
             pib_pchcmd:PChar;         { Command line pointer }
             pib_pchenv:PChar;         { Environment pointer }
             pib_flstatus:ULONG;       { Process' status bits }
             pib_ultype:ULONG;         { Process' type code }
       END;


IMPLEMENTATION

BEGIN
END.
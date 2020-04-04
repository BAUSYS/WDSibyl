
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT REXXSAA;

{****************************************************************************
 *                                                                          *
 * OS/2 REXX Interface                                                      *
 *                                                                          *
 * fuer OS/2, eCS: im System enthalten                                      *
 * fuer Win32 eCS: Regina": http://regina-rexx.sourceforge.net/index.html   *
 *                                                                          *
 ****************************************************************************}

INTERFACE

{$IFDEF OS2}
USES OS2Def;
{$ENDIF}

{$IFDEF Win32}
{$ENDIF}

Uses SysUtils;

TYPE
     PRXSTRING=^RXSTRING;
     RXSTRING=RECORD
                    strlength:LONGWORD;
                    strptr:PChar;
              END;

CONST
     RXAUTOBUFLEN        = 256;

TYPE
    PRXSYSEXIT=^RXSYSEXIT;
    RXSYSEXIT=RECORD
                    sysexit_name:PChar;
                    sysexit_code:LONGINT;
    END;

CONST
     RXCOMMAND       =0;
     RXSUBROUTINE    =1;
     RXFUNCTION      =2;

CONST
     RXSUBCOM_DROPPABLE   =$00;
     RXSUBCOM_NONDROP     =$01;

CONST
     RXSUBCOM_ISREG       =$01;
     RXSUBCOM_ERROR       =$01;
     RXSUBCOM_FAILURE     =$02;
     RXSUBCOM_BADENTRY    =1001;
     RXSUBCOM_NOEMEM      =1002;
     RXSUBCOM_BADTYPE     =1003;
     RXSUBCOM_NOTINIT     =1004;
     RXSUBCOM_OK          = 0;
     RXSUBCOM_DUP         =10;
     RXSUBCOM_MAXREG      =20;
     RXSUBCOM_NOTREG      =30;
     RXSUBCOM_NOCANDROP   =40;
     RXSUBCOM_LOADERR     =50;
     RXSUBCOM_NOPROC      =127;

CONST
    RXSHV_SET          =$00;       /* Set var from given value    */
    RXSHV_FETCH        =$01;       /* Copy value of var to buffer */
    RXSHV_DROPV        =$02;       /* Drop variable               */
    RXSHV_SYSET        =$03;       /* Symbolic name Set variable  */
    RXSHV_SYFET        =$04;       /* Symbolic name Fetch variable*/
    RXSHV_SYDRO        =$05;       /* Symbolic name Drop variable */
    RXSHV_NEXTV        =$06;       /* Fetch "next" variable       */
    RXSHV_PRIV         =$07;       /* Fetch private information   */
    RXSHV_EXIT         =$08;       /* Set function exit value     */

    RXSHV_NOAVL        =144;       /* Interface not available     */

    RXSHV_OK           =$00;       /* Execution was OK            */
    RXSHV_NEWV         =$01;       /* Variable did not exist      */
    RXSHV_LVAR         =$02;       /* Last var trans via SHVNEXTV */
    RXSHV_TRUNC        =$04;       /* Truncation occurred-Fetch   */
    RXSHV_BADN         =$08;       /* Invalid variable name       */
    RXSHV_MEMFL        =$10;       /* Out of memory failure       */
    RXSHV_BADF         =$80;       /* Invalid funct code (shvcode)*/

TYPE
    PSHVBLOCK=^SHVBLOCK;
    SHVBLOCK=RECORD
                   shvnext:PSHVBLOCK;
                   shvname:RXSTRING;
                   shvvalue:RXSTRING;
                   shvnamelen:ULONG;
                   shvvaluelen:ULONG;
                   shvcode:BYTE;
                   shvret:BYTE;
    END;

CONST
    RXFUNC_DYNALINK       =1;        /* Function Available in DLL  */
    RXFUNC_CALLENTRY      =2;        /* Registered as mem entry pt.*/

    RXFUNC_OK             =0;        /* REXX-API Call Successful   */
    RXFUNC_DEFINED       =10;        /* Function Defined in AFT    */
    RXFUNC_NOMEM         =20;        /* Not Enough Mem to Add      */
    RXFUNC_NOTREG        =30;        /* Funct Not Registered in AFT*/
    RXFUNC_MODNOTFND     =40;        /* Funct Dll Module Not Found */
    RXFUNC_ENTNOTFND     =50;        /* Funct Entry Point Not Found*/
    RXFUNC_NOTINIT       =60;        /* API not initialized        */
    RXFUNC_BADTYPE       =70;        /* Bad function type          */

    RXEXIT_DROPPABLE     =$00;       /* handler to be dropped by all*/
    RXEXIT_NONDROP       =$01;       /* process with same PID as the*/
                                     /* registrant may drop environ */

    RXEXIT_HANDLED       =0;         /* Exit handled exit event     */
    RXEXIT_NOT_HANDLED   =1;         /* Exit passes on exit event   */
    RXEXIT_RAISE_ERROR   =-1;        /* Exit handler error occurred */

    RXEXIT_ISREG         =$01;     /* Exit is registered          */
    RXEXIT_ERROR         =$01;     /* Exit Ended in Error         */
    RXEXIT_FAILURE       =$02;     /* Exit Ended in Failure       */
    RXEXIT_BADENTRY      =1001;    /* Invalid Entry Conditions    */
    RXEXIT_NOEMEM        =1002;    /* Insuff stor to complete req */
    RXEXIT_BADTYPE       =1003;    /* Bad registration type.      */
    RXEXIT_NOTINIT       =1004;    /* API system not initialized. */
    RXEXIT_OK            = 0;      /* Function Complete           */
    RXEXIT_DUP           =10;      /* Duplicate Exit Name-        */
                                   /* but Registration Completed  */

    RXEXIT_MAXREG        =20;       /* Cannot register more        */
                                      /* handlers                    */
    RXEXIT_NOTREG        =30;       /* Name Not Registered         */
    RXEXIT_NOCANDROP     =40;       /* Name not droppable          */
    RXEXIT_LOADERR       =50;       /* Could not load function     */
    RXEXIT_NOPROC       =127;       /* RXEXIT routine - not found  */

    RXENDLST    =0;                 /* End of exit list.           */
    RXFNC       =2;                 /* Process external functions. */
    RXFNCCAL    =1;                 /* subcode value.              */
    RXCMD       =3;                 /* Process host commands.      */
    RXCMDHST    =1;                 /* subcode value.              */
    RXMSQ       =4;                 /* Manipulate queue.           */
    RXMSQPLL    =1;                 /* Pull a line from queue      */
    RXMSQPSH    =2;                 /* Place a line on queue       */
    RXMSQSIZ    =3;                 /* Return num of lines on queue*/
    RXMSQNAM    =20;                /* Set active queue name       */
    RXSIO       =5;                 /* Session I/O.                */
    RXSIOSAY    =1;                 /* SAY a line to STDOUT        */
    RXSIOTRC    =2;                 /* Trace output                */
    RXSIOTRD    =3;                 /* Read from char stream       */
    RXSIODTR    =4;                 /* DEBUG read from char stream */
    RXSIOTLL    =5;                 /* Return linelength(N/A OS/2) */
    RXHLT       =7;                 /* Halt processing.            */
    RXHLTCLR    =1;                 /* Clear HALT indicator        */
    RXHLTTST    =2;                 /* Test HALT indicator         */
    RXTRC       =8;                 /* Test ext trace indicator.   */
    RXTRCTST    =1;                 /* subcode value.              */
    RXINI       =9;                 /* Initialization processing.  */
    RXINIEXT    =1;                 /* subcode value.              */
    RXTER       =10;                /* Termination processing.     */
    RXTEREXT    =1;                 /* subcode value.              */
    RXNOOFEXITS =11;                /* 1 + largest exit number.    */

TYPE
    PEXIT=PUCHAR;
    PFN=POINTER;

CONST
    RXARI_OK                   =0;  /* Interface completed         */
    RXARI_NOT_FOUND            =1;  /* Target program not found    */
    RXARI_PROCESSING_ERROR     =2;  /* Error processing request    */

    RXMACRO_SEARCH_BEFORE      =1;  /* Beginning of search order  */
    RXMACRO_SEARCH_AFTER       =2;  /* End of search order        */

    RXMACRO_OK                 =0;  /* Macro interface completed   */
    RXMACRO_NO_STORAGE         =1;  /* Not Enough Storage Available*/
    RXMACRO_NOT_FOUND          =2;  /* Requested function not found*/
    RXMACRO_EXTENSION_REQUIRED =3;  /* File ext required for save  */
    RXMACRO_ALREADY_EXISTS     =4;  /* Macro functions exist       */
    RXMACRO_FILE_ERROR         =5;  /* File I/O error in save/load */
    RXMACRO_SIGNATURE_ERROR    =6;  /* Incorrect format for load   */
    RXMACRO_SOURCE_NOT_FOUND   =7;  /* Requested cannot be found   */
    RXMACRO_INVALID_POSITION   =8;  /* Invalid search order pos    */
    RXMACRO_NOT_INIT           =9;  /* API not initialized         */

TYPE
    RXARGUMENTS = array[0..0] of RXString;

    RexxFunctionHandler=FUNCTION(Name:PChar;ul:ULONG;
                                 VAR rxArgs:RXARGUMENTS;
                                 VAR qName:CSTRING;
                                 VAR result:RXSTRING):ULONG; APIENTRY;

    RxFnCCal_Parm = RECORD
                      rxfnc_flags: Byte;
                      rxfnc_name:  PChar;
                      rxfnc_namel: Word;
                      rxfnc_que:   PChar;
                      rxfnc_quel:  Word;
                      rxfnc_argc:  Word;
                      rxfnc_argv:  PRxString;
                      rxfnc_retc:  RxString;
    END;

CONST

  rxfcfail = $01;  { Command failed.            }
  rxfcerr  = $02;  { Command ERROR occurred.    }

  rxfmlifo = $01;  { Stack entry LIFO if set    }

  rxfhhalt = $01;  { Set if HALT occurred.      }

TYPE
  RxCmdHst_Parm = RECORD
                    rxcmd_flags:    Byte;
                    rxcmd_address:  PChar;
                    rxcmd_addressl: Word;
                    rxcmd_dll:      PChar;
                    rxcmd_dll_len:  Word;
                    rxcmd_command:  RxString;
                    rxcmd_retc:     RxString;
  END;

  RxMsqPll_Parm = RECORD
                    rxmsq_retc: RxString;
  END;

TYPE
  RxMsqPsh_Parm = RECORD
                    rxmsq_flags: Byte;
                    rxmsq_value: RxString
  END;

  RxMsqSiz_Parm = RECORD
                    rxmsq_size: ULong;
  END;

  RxMsqNam_Parm = RECORD
                    rxmsq_name: RxString;
  END;

  RxSioSay_Parm = RECORD
                    rxsio_string: RxString;
  END;

  RxSioTrc_Parm = RECORD
                    rxsio_string: RxString;
  END;

  RxSioTrd_Parm = RECORD
                    rxsiotrd_retc: RxString;
  END;

  RxSioDtr_Parm = RECORD
                    rxsiodtr_retc: RxString;
  END;

TYPE
   RxHltTst_Parm= RECORD
                    rxhlt_flags: Byte;
   END;

TYPE
  RxTrcTst_Parm = RECORD
                    rxtrc_flags: Byte;
  END;

IMPORTS
{$IFDEF OS2}
     FUNCTION RexxStart (ArgC:Long;VAR ArgV:RxString;
                         VAR FileName:CSTRING;
                         VAR Proc:RxString;
                         VAR Env:CSTRING;
                         rType:Long;
                         VAR Exit:RxSysExit;
                         var Ret:Word;
                         var RetVal:RxString):LONG;
           APIENTRY; 'REXX' INDEX 1;
     FUNCTION RexxRegisterSubcomDll(CONST Name:CSTRING;
                                    CONST DllName:CSTRING;
                                    CONST ProcName:CSTRING;
                                    VAR UserArea;
                                    Authority:LONGWORD):APIRET;
           APIENTRY; 'REXXAPI' INDEX 6;
     FUNCTION RexxRegisterSubcomExe(Const HandlerName:CSTRING;
                                    HandlerAddr:PFN;
                                    VAR UserArea):APIRET;
           APIENTRY; 'REXXAPI' INDEX 7;
     FUNCTION RexxQuerySubcom(CONST EnvName:CSTRING;
                              CONST DllName:CSTRING;
                              VAR ExCode:WORD;
                              VAR User:WORD):APIRET;
           APIENTRY; 'REXXAPI' INDEX 8;
     FUNCTION RexxDeregisterSubcom(CONST EnvName:CSTRING;
                                   CONST DllName:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 9;
     FUNCTION RexxVariablePool(VAR block:SHVBLOCK):APIRET;
           APIENTRY; 'REXX' INDEX 2;
     FUNCTION RexxRegisterFunctionDll(CONST FuncName:CSTRING;
                                      CONST DllName:CSTRING;
                                      CONST Entry:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 17;
     FUNCTION RexxRegisterFunctionExe(CONST FuncName:CSTRING;
                                      Entry:PFN):APIRET;
           APIENTRY; 'REXXAPI' INDEX 18;
     FUNCTION RexxDeregisterFunction(CONST Name:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 19;
     FUNCTION RexxQueryFunction(CONST Name:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 20;
     FUNCTION RexxRegisterExitDll(CONST Handler:CSTRING;
                                  CONST DllName:CSTRING;
                                  CONST ProcName:CSTRING;
                                  VAR UserArea;
                                  authority:ULONG):APIRET;
           APIENTRY; 'REXXAPI' INDEX 11;
     FUNCTION RexxRegisterExitExe(CONST Handler:CSTRING;
                                  Address:PFN;
                                  VAR UserArea):APIRET;
           APIENTRY; 'REXXAPI' INDEX 12;
      FUNCTION RexxDeregisterExit(CONST Name:CSTRING;
                                  CONST DllName:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 13;
      FUNCTION RexxQueryExit(CONST ExitName:CSTRING;
                             CONST DllName:CSTRING;
                             VAR ExistanceFlag:USHORT;
                             VAR UserArea):APIRET;
           APIENTRY; 'REXXAPI' INDEX 14;
      FUNCTION RexxSetHalt(apid:PID;atid:TID):APIRET;
           APIENTRY; 'REXX' INDEX 3;
      FUNCTION RexxSetTrace(apid:PID;atid:TID):APIRET;
           APIENTRY; 'REXX' INDEX 4;
      FUNCTION RexxResetTrace(apid:PID;atid:TID):APIRET;
           APIENTRY; 'REXXAPI' INDEX 5;
      FUNCTION RexxAddMacro(CONST FuncName:CSTRING;
                            CONST FileName:CSTRING;
                            searchpos:ULONG):APIRET;
           APIENTRY; 'REXXAPI' INDEX 22;
      FUNCTION RexxDropMacro(CONST Name:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 23;
      FUNCTION RexxSaveMacroSpace(argcount:ULONG;
                                  VAR NameList:PChar;
                                  CONST FileName:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 28;
      FUNCTION RexxLoadMacroSpace(argcount:ULONG;
                                  VAR NameList:PChar;
                                  CONST FileName:CSTRING):APIRET;
           APIENTRY; 'REXXAPI' INDEX 25;
      FUNCTION RexxQueryMacro(CONST FuncName:CSTRING;
                              VAR posflag:WORD):APIRET;
           APIENTRY; 'REXXAPI' INDEX 26;
      FUNCTION RexxReorderMacro(CONST FuncName:CSTRING;
                                NewPos:ULONG):APIRET;
           APIENTRY; 'REXXAPI' INDEX 27;
      FUNCTION RexxClearMacroSpace:APIRET;
           APIENTRY; 'REXXAPI' INDEX 24;
{$ENDIF}

{$IFDEF WIN322}
// REXX untersttzung fr Windows "Regina": http://regina-rexx.sourceforge.net/index.html

{$ENDIF}

END;

FUNCTION RXNULLSTRING(CONST r:RXSTRING):BOOLEAN;
FUNCTION RXZEROLENSTRING(CONST r:RXSTRING):BOOLEAN;
FUNCTION RXVALIDSTRING(CONST r:RXSTRING):BOOLEAN;
FUNCTION RXSTRLEN(CONST r:RXSTRING):LONGINT;
FUNCTION RXSTRPTR(CONST r:RXSTRING):PChar;
PROCEDURE MAKERXSTRING(VAR r:RXSTRING;p:PChar;l:LONGINT);
Procedure MakeRXStringPas(var r:RXSTRING;st : String);

IMPLEMENTATION

FUNCTION RXNULLSTRING(CONST r:RXSTRING):BOOLEAN;
BEGIN
  result:=r.strptr=NIL;
END;

FUNCTION RXZEROLENSTRING(CONST r:RXSTRING):BOOLEAN;
BEGIN
  result:=((r.strptr<>NIL)AND(r.strlength=0));
END;

FUNCTION RXVALIDSTRING(CONST r:RXSTRING):BOOLEAN;
BEGIN
  result:=((r.strptr<>NIL)AND(r.strlength>0));
END;

FUNCTION RXSTRLEN(CONST r:RXSTRING):LONGINT;
BEGIN
  IF RXNULLSTRING(r)
    THEN result:=0
    ELSE result:=r.strlength;
END;

FUNCTION RXSTRPTR(CONST r:RXSTRING):PChar;
BEGIN
  result:=r.strptr;
END;

PROCEDURE MAKERXSTRING(VAR r:RXSTRING;p:PChar;l:LONGINT);
BEGIN
  r.strptr:=p;
  r.strlength:=l;
END;

Procedure MakeRXStringPas(var r:RXSTRING;st : String);
Begin
  strpCopy(r.strptr, st);
  r.strlength:=length(st);
End;

BEGIN
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  11-Jun-05  WD         Fuer die Windows-Schiene ein- bzw. umbauen.
}

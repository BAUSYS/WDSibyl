
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Visual Development Environment                                 บ
 บ                                                                          บ
 บ     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Sibyl Integrated Development Environment (IDE)                           บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
 บ                                                                          บ
 บ This program is free software; you can redistribute it and/or modify it  บ
 บ under the terms of the GNU General Public License (GPL) as published by  บ
 บ the Free Software Foundation; either version 2 of the License, or (at    บ
 บ your option) any later version. This program is distributed in the hope  บ
 บ that it will be useful, but WITHOUT ANY WARRANTY; without even the       บ
 บ implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR          บ
 บ PURPOSE.                                                                 บ
 บ See the GNU General Public License for more details. You should have     บ
 บ received a copy of the GNU General Public License along with this        บ
 บ program; if not, write to the Free Software Foundation, Inc., 59 Temple  บ
 บ Place - Suite 330, Boston, MA 02111-1307, USA.                           บ
 บ                                                                          บ
 บ In summary the original copyright holders (SpeedSoft) grant you the      บ
 บ right to:                                                                บ
 บ                                                                          บ
 บ - Freely modify and publish the sources provided that your modification  บ
 บ   is entirely free and you also make the modified source code available  บ
 บ   to all for free (except a fee for disk/CD production etc).             บ
 บ                                                                          บ
 บ - Adapt the sources to other platforms and make the result available     บ
 บ   for free.                                                              บ
 บ                                                                          บ
 บ Under this licence you are not allowed to:                               บ
 บ                                                                          บ
 บ - Create a commercial product on whatever platform that is based on the  บ
 บ   whole or parts of the sources covered by the license agreement. The    บ
 บ   entire program or development environment must also be published       บ
 บ   under the GNU General Public License as entirely free.                 บ
 บ                                                                          บ
 บ - Remove any of the copyright comments in the source files.              บ
 บ                                                                          บ
 บ - Disclosure any content of the source files or use parts of the source  บ
 บ   files to create commercial products. You always must make available    บ
 บ   all source files whether modified or not.                              บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

UNIT DAsm;

INTERFACE

uses uList, uString;

{$IFDEF OS2}
USES Os2Def,BseDos;
{$ENDIF}
{$IFDEF WIN32}
Uses WinBase;

TYPE HWND=LongWord;
     PID=LongWord;
     TID=LongWord;

    PDbgBuf=^TDbgBuf;
    TDbgBuf=RECORD
                 Pid:PID;                 { Debuggee Process id          }
                 Tid:TID;                 { Debuggee Thread id           }
                 Cmd:LONGINT;             { Command or Notification      }
                 Value:LONGINT;           { Generic Data Value           }
                 Addr:LONGWORD;           { Debuggee Address             }
                 Buffer:LONGWORD;         { Debugger Buffer Address      }
                 Len:LONGWORD;            { Length of Range              }
                 index:LONGWORD;          { Generic Identifier Index     }
                 MTE:LONGWORD;            { Module Table Entry Handle    }
                 EAX:LONGWORD;            { Register Set                 }
                 ECX:LONGWORD;
                 EDX:LONGWORD;
                 EBX:LONGWORD;
                 ESP:LONGWORD;
                 EBP:LONGWORD;
                 ESI:LONGWORD;
                 EDI:LONGWORD;
                 EFlags:LONGWORD;
                 EIP:LONGWORD;
                 CSLim:LONGWORD;
                 CSBase:LONGWORD;
                 CSAcc:BYTE;
                 CSAtr:BYTE;
                 CS:WORD;
                 DSLim:LONGWORD;
                 DSBase:LONGWORD;
                 DSAcc:BYTE;
                 DSAtr:BYTE;
                 DS:WORD;
                 ESLim:LONGWORD;
                 ESBase:LONGWORD;
                 ESAcc:BYTE;
                 ESAtr:BYTE;
                 ES:WORD;
                 FSLim:LONGWORD;
                 FSBase:LONGWORD;
                 FSAcc:BYTE;
                 FSAtr:BYTE;
                 FS:WORD;
                 GSLim:LONGWORD;
                 GSBase:LONGWORD;
                 GSAcc:BYTE;
                 GSAtr:BYTE;
                 GS:WORD;
                 SSLim:LONGWORD;
                 SSBase:LONGWORD;
                 SSAcc:BYTE;
                 SSAtr:BYTE;
                 SS:WORD;
         END;

CONST
   DBG_C_Null              =0;       { Null                         }
   DBG_C_ReadMem           =1;       { Read Word                    }
   DBG_C_ReadMem_I         =1;       { Read Word                    }
   DBG_C_ReadMem_D         =2;       { Read Word (same as 1)        }
   DBG_C_ReadReg           =3;       { Read Register Set            }
   DBG_C_WriteMem          =4;       { Write Word                   }
   DBG_C_WriteMem_I        =4;       { Write Word                   }
   DBG_C_WriteMem_D        =5;       { Write Word (same as 4)       }
   DBG_C_WriteReg          =6;       { Write Register Set           }
   DBG_C_Go                =7;       { Go                           }
   DBG_C_Term              =8;       { Terminate                    }
   DBG_C_SStep             =9;       { Single Step                  }
   DBG_C_Stop              =10;      { Stop                         }
   DBG_C_Freeze            =11;      { Freeze Thread                }
   DBG_C_Resume            =12;      { Resume Thread                }
   DBG_C_NumToAddr         =13;      { Object Number to Address     }
   DBG_C_ReadCoRegs        =14;      { Read Coprocessor Registers   }
   DBG_C_WriteCoRegs       =15;      { Write Coprocessor Registers  }
                                        { 16 is reserved               }
   DBG_C_ThrdStat          =17;      { Get Thread Status            }
   DBG_C_MapROAlias        =18;      { Map read-only alias          }
   DBG_C_MapRWAlias        =19;      { Map read-write alias         }
   DBG_C_UnMapAlias        =20;      { Unmap Alias                  }
   DBG_C_Connect           =21;      { Connect to Debuggee          }
   DBG_C_ReadMemBuf        =22;      { Read Memory Buffer           }
   DBG_C_WriteMemBuf       =23;      { Write Memory Buffer          }
   DBG_C_SetWatch          =24;      { Set Watchpoint               }
   DBG_C_ClearWatch        =25;      { Clear Watchpoint             }
   DBG_C_RangeStep         =26;      { Range Step                   }
   DBG_C_Continue          =27;      { Continue after an Exception  }
   DBG_C_AddrToObject      =28;      { Address to Object            }
   DBG_C_XchgOpcode        =29;      { Exchange opcode and go       }
   DBG_C_LinToSel          =30;      { 32 to 16 conversion      A001}
   DBG_C_SelToLin          =31;      { 16 to 32 conversion      A001}

   {------ Notifications ---------------}
   DBG_N_SUCCESS             = 0;
   DBG_N_ERROR               =-1;
   DBG_N_ProcTerm            =-6;
   DBG_N_Exception           =-7;
   DBG_N_ModuleLoad          =-8;
   DBG_N_CoError             =-9;
   DBG_N_ThreadTerm          =-10;
   DBG_N_AsyncStop           =-11;
   DBG_N_NewProc             =-12;
   DBG_N_AliasFree           =-13;
   DBG_N_Watchpoint          =-14;
   DBG_N_ThreadCreate        =-15;
   DBG_N_ModuleFree          =-16;
   DBG_N_RangeStep           =-17;

   DBG_X_PRE_FIRST_CHANCE    = 0;
   DBG_X_FIRST_CHANCE        = 1;
   DBG_X_LAST_CHANCE         = 2;
   DBG_X_STACK_INVALID       = 3;

   DBG_W_Local               =$0000001;
   DBG_W_Global              =$0000002;
   DBG_W_Execute             =$00010000;
   DBG_W_Write               =$00020000;
   DBG_W_ReadWrite           =$00030000;

Const //Exception codes
       XCPT_FATAL_EXCEPTION    =$C0000000;
       XCPT_SEVERITY_CODE      =$C0000000;
       XCPT_CUSTOMER_CODE      =$20000000;
       XCPT_FACILITY_CODE      =$1FFF0000;
       XCPT_EXCEPTION_CODE     =$0000FFFF;


       XCPT_UNKNOWN_ACCESS     =$00000000;     { Unknown access }
       XCPT_READ_ACCESS        =$00000001;     { Read access    }
       XCPT_WRITE_ACCESS       =$00000002;     { Write access   }
       XCPT_EXECUTE_ACCESS     =$00000004;     { Execute access }
       XCPT_SPACE_ACCESS       =$00000008;     { Address space access }
       XCPT_LIMIT_ACCESS       =$00000010;     { Address space limit violation }
       XCPT_DATA_UNKNOWN       =$FFFFFFFF;
       XCPT_SIGNAL_INTR        =1;
       XCPT_SIGNAL_KILLPROC    =3;
       XCPT_SIGNAL_BREAK       =4;
       XCPT_GUARD_PAGE_VIOLATION       =$80000001;
       XCPT_UNABLE_TO_GROW_STACK       =$80010001;
       XCPT_DATATYPE_MISALIGNMENT      =$C000009E;
       XCPT_BREAKPOINT                 =$C000009F;
       XCPT_SINGLE_STEP                =$C00000A0;
       XCPT_ACCESS_VIOLATION           =$C0000005;
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
       XCPT_IN_PAGE_ERROR              =$C0000006;
       XCPT_PROCESS_TERMINATE          =$C0010001;
       XCPT_ASYNC_PROCESS_TERMINATE    =$C0010002;
       XCPT_NONCONTINUABLE_EXCEPTION   =$C0000024;
       XCPT_INVALID_DISPOSITION        =$C0000025;
       XCPT_INVALID_LOCK_SEQUENCE      =$C000001D;
       XCPT_ARRAY_BOUNDS_EXCEEDED      =$C0000093;
       XCPT_B1NPX_ERRATA_02            =$C0010004;
       XCPT_UNWIND                     =$C0000026;
       XCPT_BAD_STACK                  =$C0000027;
       XCPT_INVALID_UNWIND_TARGET      =$C0000028;
       XCPT_SIGNAL                     =$C0010003;

       XCPT_CONTINUE_SEARCH    =$00000000;     { exception not handled   }
       XCPT_CONTINUE_EXECUTION =$FFFFFFFF;     { exception handled       }
       XCPT_CONTINUE_STOP      =$00716668;     { exception handled by    }
                                               { debugger (VIA DosDebug) }

{$ENDIF}

USES Classes,Dialogs;


TYPE PCodePointer=^TCodePointer;
     TCodePointer=ARRAY[0..16] OF BYTE;

TYPE
     PValidAddrArray=^TValidAddrArray;
     TValidAddrArray=ARRAY[0..0] OF BYTE;

     PModulesLoaded=^TModulesLoaded;

     PLineNumberInfo=^TLineNumberInfo;
     TLineNumberInfo=RECORD
                           LineNumber:LONGWORD;
                           Offset:LONGWORD;
                           Next:PLineNumberInfo;
                     END;

     PPublicsInfo=^TPublicsInfo;
     TPublicsInfo=RECORD
                         PublicName:^STRING;
                         ObjectIndex:LONGWORD;
                         Typ:WORD;
                         TypOffset:LONGINT;
                         Offset:LONGWORD;
                         Next:PPublicsInfo;
                  END;

     PSymbolsInfo=^TSymbolsInfo;
     TSymbolsInfo=RECORD
                        SymbolName:^STRING;                {ProcName or SymbolName}
                        Typ:WORD;                          {ResultType or SymbolType}
                        TypOffset:LONGINT;                 {Offset in type table}
                        OffsetTyp:BYTE;                    {04-EBP 05-VAR Para EBP}
                        Offset:LONGINT;                    {Offset proc or Offset relative to EBP}
                        Len:LONGWORD;                      {Length of Proc}
                        Symbols:PSymbolsInfo;              {Symbole fr Proc}
                        next:PSymbolsInfo;
                  END;

     PTypesInfo=^TTypesInfo;
     TTypesInfo=ARRAY[0..655350] OF BYTE;

     PModuleInfo=^TModuleInfo;
     TModuleInfo=RECORD
                       PublicsStart,PublicsLen:LONGWORD;
                       LineStart,LineLen:LONGWORD;
                       SymbolsStart,SymbolsLen:LONGWORD;
                       TypesStart,TypesLen:LONGWORD;
                       CodeOffs,CodeLen:LONGWORD;
                       SourceFile:STRING;
                       ModIndex:LONGWORD;
                       ObjectIndex:LONGWORD;
                       LineNumberInfo:PLineNumberInfo;
                       PublicsInfo:PPublicsInfo;
                       SymbolsInfo:PSymbolsInfo;
                       TypesInfo:PTypesInfo;
                       Module:PModulesLoaded;
                       Next:PModuleInfo;
                 END;

     PLineNumbers=^TLineNumbers;
     TLineNumbers=RECORD
                        LineNumber:LONGWORD;
                        LinearAddr:LONGWORD;
                        Next:PLineNumbers;
                  END;

     PObjectList=^TObjectList;
     TObjectList=RECORD
                       id:LONGWORD;
                       Start,Len:LONGWORD;
                       Flags:LONGWORD;
                       LineNumbers:PLineNumbers;
                       SourceFile:STRING;
                       Next:PObjectList;
                 END;

    TModulesLoaded=RECORD
                          MTE:LONGWORD;
                          Name:STRING;
                          Objects:PObjectList;
                          DebugModules:PModuleInfo;
                          Next:PModulesLoaded;
                    END;


TYPE DebugReturn=RECORD
                       msg:LONGINT;
                       data:LONGWORD;
                       source:string;
                       Line:WORD;  {0- No line number Debuginfo}
                       ModuleInfo:PModuleInfo;
                       BreakSource:BYTE; {0 for TRUE Breakpoint}
                       name:STRING;
                       ErrStr:STRING;
                       NextAction:BYTE;
                 END;

VAR
   DbgReturn:DebugReturn;

{next Actions}
CONST
     A_WAITSEM   =1;
     A_CONTINUE  =2;
     A_RETRYXCPT =4;
     A_RUNXCPT   =8;
     A_ABORTXCPT =16;

     LastCommandFromSrc:BOOLEAN=FALSE;

{Extra Notifications}
CONST
     DBG_N_SSTEPCOMPLETED =1;

{Extra commands}
CONST
     DBG_C_STEPINTO       =100;



TYPE PCPUDump=^TCPUDump;
     TCPUDump=RECORD
                    StartAddr,Len:LONGWORD;
                    Module:PModulesLoaded;
                    Objects:PObjectList;
                    Alias:POINTER;
     END;

VAR
    CPUDumpTopAddr:LONGWORD;

TYPE TCPUDumpList=CLASS(TList)
            PROCEDURE FreeItem(Item:POINTER);OVERRIDE;
     END;

VAR
    CPUDumpList:TCPUDumpList;

TYPE
    PSourceFileItem=^TSourceFileItem;
    TSourceFileItem=RECORD
                          Name:STRING;
                          Lines:TStringList;
                    END;

TYPE PCPUListItem=^TCPUListItem;
     TCPUListItem=RECORD
                        Address:LONGWORD;
                        Len:LONGINT;
                        CPUDump:PCPUDump;
                        Disassembly,Source,SourceFile:String;
                        SourceLine:WORD;
                        SourceFileInfo:PSourceFileItem;
     END;

TYPE TCPUList=CLASS(TList)
            PROCEDURE FreeItem(Item:POINTER);OVERRIDE;
     END;

     TCoproBuf=RECORD
                    CW:WORD;
                    Reserved1:WORD;
                    SW:WORD;
                    Reserved2:WORD;
                    TW:WORD;
                    Reserved3:WORD;
                    IP:LONGWORD;
                    CS:WORD;
                    OPCode:WORD;
                    OpOfs:LONGWORD;
                    OpSel:WORD;
                    Reserved4:WORD;

                    ST0:EXTENDED;
                    ST1:EXTENDED;
                    ST2:EXTENDED;
                    ST3:EXTENDED;
                    ST4:EXTENDED;
                    ST5:EXTENDED;
                    ST6:EXTENDED;
                    ST7:EXTENDED;
     END;

VAR CPUList:TCPUList;
    DisAsmSelectedIndex:LONGINT;
    DisAsmCurrentIndex:LONGINT;


TYPE TSourceFilesList=CLASS(TList)
            PROCEDURE FreeItem(Item:POINTER);OVERRIDE;
     END;

VAR SourceFilesList:TSourceFilesList;

FUNCTION DisAssemble(Code:PCodePointer;VAR Len:LONGINT;Dump:PCpuDump):STRING;
FUNCTION DisAssembleBack(Code:PCodePointer;VAR Len:LONGINT;Dump:PCpuDump):STRING;

TYPE
    TAddrType=(AddrCode,AddrData,AddrLocal);

TYPE
    PTypeList=^TTypeList;
    TTypeList=RECORD
                    Name:^STRING;
                    Value:^STRING;
                    Typ:BYTE;
                    Next:PTypeList;
              END;

CONST
     OPT_SHOWANSIREF =1;

TYPE
    PBreakPoints=^TBreakPoints;
    TBreakPoints=RECORD
                       LinearAddr:LongWord;
                       Typ:BYTE;
                       OldOpCode:WORD;
                       Next:PBreakPoints;
    END;

    PLocalVars=^TLocalVars;
    TLocalVars=RECORD
                     Name:STRING;
                     Next:PLocalVars;
               END;

{$IFDEF OS2}
IMPORTS
       FUNCTION DebugLoad(s,param:STRING;CPUAvailProc:POINTER;
                          ahwnd,hwndFrame:HWND;
                          ahmq,ahab:LONGWORD):BOOLEAN;     'WDSPDB10' index 1;
       PROCEDURE DebugUnload;                              'WDSPDB10' index 2;
       PROCEDURE CreateEventSem;                           'WDSPDB10' index 3;
       PROCEDURE PostEventSem;                             'WDSPDB10' index 4;
       PROCEDURE SetNextAction(Action:BYTE);               'WDSPDB10' index 5;
       PROCEDURE GetDebugReturn(VAR ret:DebugReturn);      'WDSPDB10' index 6;
       FUNCTION MainLoop(Command:LONGINT):LONGINT;         'WDSPDB10' index 7;
       PROCEDURE Dummy;                                    'WDSPDB10' index 8;
       FUNCTION GetModulesLoaded:PModulesLoaded;           'WDSPDB10' index 9;
       FUNCTION GetModuleInfo:PModuleInfo;                 'WDSPDB10' index 10;
       FUNCTION GetRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;   'WDSPDB10' index 11;
       FUNCTION PutRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;   'WDSPDB10' index 12;
       PROCEDURE DeleteWorkThread(Destroy:BOOLEAN);        'WDSPDB10' index 13;
       PROCEDURE SetStartBreakpoint(Typ:BYTE);             'WDSPDB10' index 14;
       FUNCTION SetBreakPoint(Address:LongWord;
                              Typ:BYTE):BOOLEAN;           'WDSPDB10' index 15;
       FUNCTION UnsetBreakPoint(Address:LongWord;
                           VAR BreakSource:BYTE):BOOLEAN;  'WDSPDB10' index 16;
       FUNCTION SetBreakPointLine(Source:STRING;Line:WORD;
                     yp:BYTE;VAR Adress:LongWord):BOOLEAN; 'WDSPDB10' index 17;
       PROCEDURE SetBreakAtStartAddr(Addr:LongWord);       'WDSPDB10' index 18;
       FUNCTION GetAdressFromLine(Source:STRING;Line:WORD;
                             VAR adress:LongWord):BOOLEAN; 'WDSPDB10' index 19;
       PROCEDURE SetNextDbgBrk(Adress:LongWord;Typ:BYTE);  'WDSPDB10' index 20;
       FUNCTION  GetNextDbgBrk:LongWord;                   'WDSPDB10' index 21;
       FUNCTION GetValueFromExpr(Expr:STRING;
                    VAR Value:STRING;VAR EXEAddr:LongWord;
                    VAR ValueLen:LongWord;VAR ValueTyp:BYTE;MakeTypeList:BOOLEAN):BOOLEAN; 'WDSPDB10' index 22;
       FUNCTION  SetValueFromExpr(NewValue:STRING;EXEAddr:LongWord;
                       Len:LongWord;Typ:BYTE):BOOLEAN;     'WDSPDB10' index 23;
       PROCEDURE SetWatchHwnd(w,f:LONGWORD);               'WDSPDB10' index 24;
       PROCEDURE SetRegHwnd(w,f:LONGWORD);                 'WDSPDB10' index 25;
       PROCEDURE SetProjectHwnd(w,f:LONGWORD);             'WDSPDB10' index 26;
       FUNCTION  GetProcTermResult:LONGWORD;               'WDSPDB10' index 27;
       FUNCTION  IsBreakPointLine(Source:STRING;Line:WORD;
                    Typ:BYTE;VAR Adress:LongWord):BOOLEAN; 'WDSPDB10' index 28;
       FUNCTION GetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN; 'WDSPDB10' index 29;
       FUNCTION SetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN; 'WDSPDB10' index 30;
       PROCEDURE LockInput(DbgHwnd:HWND);                  'WDSPDB10' index 31;
       PROCEDURE UnlockInput;                              'WDSPDB10' index 32;
       FUNCTION IssueDebugCommand(VAR Buf:TDbgBuf):BOOLEAN;'WDSPDB10' index 33;
       PROCEDURE GetLineFromEIP(LinearAddr:LongWord;IncClosest:BOOLEAN;
                                VAR Source:STRING;VAR Line:WORD;
                                Module:PModuleInfo);       'WDSPDB10' index 34;
       FUNCTION GetBreakPointOp(Address:LongWord;VAR OldOp:BYTE):BOOLEAN; 'WDSPDB10' index 35;
       FUNCTION GetNameFromAddr(Addr:LONGWORD;Typ:TAddrType;Offset:LONGINT):STRING; 'WDSPDB10' index 36;
       PROCEDURE SearchLineNum(LinearAddr:LongWord;IncClosest:BOOLEAN;
                               VAR Source:STRING;VAR Line:WORD;
                               VAR Module:PModuleInfo);                             'WDSPDB10' index 37;
       FUNCTION GetNearestProc(EIP:LONGWORD):STRING;                                'WDSPDB10' index 38;
       FUNCTION GetTypeInfoFromExpr(Expr:STRING;VAR EXEAddr:LongWord;VAR ValueTyp:BYTE):PTypeList; 'WDSPDB10' index 39;
       PROCEDURE FreeTypeList;                             'WDSPDB10' index 40;
       FUNCTION SetWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN; 'WDSPDB10' index 41;
       FUNCTION ClearWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN; 'WDSPDB10' index 42;
       FUNCTION GetCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;    'WDSPDB10' index 43;
       FUNCTION PutCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;    'WDSPDB10' index 44;
       FUNCTION DbgLineAvail(CONST Source:STRING;Line:LongWord):BOOLEAN; 'WDSPDB10' index 45;
       PROCEDURE DbgSetExceptions(RTL,SPCC:LONGWORD); 'WDSPDB10' index 46;
       FUNCTION GetBreakPoints:PBreakPoints; 'WDSPDB10' index 47;
       PROCEDURE GetNextDbgBrkInfo(VAR Adress:LongWord;VAR Typ:BYTE); 'WDSPDB10' index 48;
       FUNCTION GetLocalVars(VAR ActualProc:STRING):PLocalVars; 'WDSPDB10' index 49;
       PROCEDURE FreeLocalVars(p:PLocalVars); 'WDSPDB10' index 50;
       PROCEDURE GetAdressFromName(s,s1:STRING;VAR value:LONGWORD); 'WDSPDB10' index 51;
       PROCEDURE SetOptions(Options:LONGWORD); 'WDSPDB10' index 52;
     END; {IMPORTS}
{$ENDIF}
{$IFDEF WIN32}
IMPORTS
       FUNCTION DebugLoad(s,param:STRING;CPUAvailProc:POINTER;
                          ahwnd,hwndFrame:HWND;
                          ahmq,ahab:LONGWORD):BOOLEAN;     'WDSPDB10' Name 'DebugLoad';
       PROCEDURE DebugUnload;                              'WDSPDB10' Name 'DebugUnload';
       PROCEDURE CreateEventSem;                           'WDSPDB10' Name 'CreateEventSem';
       PROCEDURE PostEventSem;                             'WDSPDB10' Name 'PostEventSem';
       PROCEDURE SetNextAction(Action:BYTE);               'WDSPDB10' Name 'SetNextAction';
       PROCEDURE GetDebugReturn(VAR ret:DebugReturn);      'WDSPDB10' Name 'GetDebugReturn';
       FUNCTION MainLoop(Command:LONGINT):LONGINT;         'WDSPDB10' Name 'MainLoop';
       PROCEDURE Dummy;                                    'WDSPDB10' Name 'Dummy';
       FUNCTION GetModulesLoaded:PModulesLoaded;           'WDSPDB10' Name 'GetModulesLoaded';
       FUNCTION GetModuleInfo:PModuleInfo;                 'WDSPDB10' Name 'GetModuleInfo';
       FUNCTION GetRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;   'WDSPDB10' Name 'GetRegisterSet';
       FUNCTION PutRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;   'WDSPDB10' Name 'PutRegisterSet';
       PROCEDURE DeleteWorkThread(Destroy:BOOLEAN);        'WDSPDB10' Name 'DeleteWorkThread';
       PROCEDURE SetStartBreakPoint(Typ:BYTE);             'WDSPDB10' Name 'SetStartBreakPoint';
       FUNCTION SetBreakPoint(Address:LongWord;
                              Typ:BYTE):BOOLEAN;           'WDSPDB10' Name 'SetBreakPoint';
       FUNCTION UnsetBreakPoint(Address:LongWord;
                           VAR BreakSource:BYTE):BOOLEAN;  'WDSPDB10' Name 'UnsetBreakPoint';
       FUNCTION SetBreakPointLine(Source:STRING;Line:WORD;
                       Typ:BYTE;VAR Adress:LongWord):BOOLEAN; 'WDSPDB10' Name 'SetBreakPointLine';
       PROCEDURE SetBreakAtStartAddr(Addr:LongWord);          'WDSPDB10' Name 'SetBreakAtStartAddr';
       FUNCTION GetAdressFromLine(Source:STRING;Line:WORD;
                                VAR adress:LongWord):BOOLEAN; 'WDSPDB10' Name 'GetAdressFromLine';
       PROCEDURE SetNextDbgBrk(Adress:LongWord;Typ:BYTE);     'WDSPDB10' Name 'SetNextDbgBrk';
       FUNCTION  GetNextDbgBrk:LongWord;                      'WDSPDB10' Name 'GetNextDbgBrk';
       FUNCTION GetValueFromExpr(Expr:STRING;
                    VAR Value:STRING;VAR EXEAddr:LongWord;
                    VAR ValueLen:LongWord;VAR ValueTyp:BYTE;MakeTypeList:BOOLEAN):BOOLEAN; 'WDSPDB10' Name 'GetValueFromExpr';
       FUNCTION  SetValueFromExpr(NewValue:STRING;EXEAddr:LongWord;
                          Len:LongWord;Typ:BYTE):BOOLEAN;     'WDSPDB10' Name 'SetValueFromExpr';
       PROCEDURE SetWatchHwnd(w,f:LONGWORD);               'WDSPDB10' Name 'SetWatchHwnd';
       PROCEDURE SetRegHwnd(w,f:LONGWORD);                 'WDSPDB10' Name 'SetRegHwnd';
       PROCEDURE SetProjectHwnd(w,f:LONGWORD);             'WDSPDB10' Name 'SetProjectHwnd';
       FUNCTION  GetProcTermResult:LONGWORD;               'WDSPDB10' Name 'GetProcTermResult';
       FUNCTION  IsBreakPointLine(Source:STRING;Line:WORD;
                       Typ:BYTE;VAR Adress:LongWord):BOOLEAN; 'WDSPDB10' Name 'IsBreakPointLine';
       FUNCTION GetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN; 'WDSPDB10' Name 'GetDump';
       FUNCTION SetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN; 'WDSPDB10' Name 'SetDump';
       PROCEDURE LockInput(DbgHwnd:HWND);                  'WDSPDB10' Name 'LockInput';
       PROCEDURE UnlockInput;                              'WDSPDB10' Name 'UnlockInput';
       FUNCTION IssueDebugCommand(VAR Buf:TDbgBuf):BOOLEAN;'WDSPDB10' Name 'IssueDebugCommand';
       PROCEDURE GetLineFromEIP(LinearAddr:LongWord;IncClosest:BOOLEAN;
                                VAR Source:STRING;VAR Line:WORD;
                                Module:PModuleInfo);       'WDSPDB10' Name 'GetLineFromEIP';
       FUNCTION GetBreakPointOp(Address:LongWord;VAR OldOp:BYTE):BOOLEAN; 'WDSPDB10' Name 'GetBreakPointOp';
       FUNCTION GetNameFromAddr(Addr:LONGWORD;Typ:TAddrType;Offset:LONGINT):STRING; 'WDSPDB10' Name 'GetNameFromAddr';
       PROCEDURE SearchLineNum(LinearAddr:LongWord;IncClosest:BOOLEAN;
                               VAR Source:STRING;VAR Line:WORD;
                               VAR Module:PModuleInfo);                             'WDSPDB10' Name 'SearchLineNum';
       FUNCTION GetNearestProc(EIP:LONGWORD):STRING;                                'WDSPDB10' Name 'GetNearestProc';
       FUNCTION GetTypeInfoFromExpr(Expr:STRING;VAR EXEAddr:LongWord;VAR ValueTyp:BYTE):PTypeList; 'WDSPDB10' Name 'GetTypeInfoFromExpr';
       PROCEDURE FreeTypeList;                             'WDSPDB10' Name 'FreeTypeList';
       FUNCTION SetWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN; 'WDSPDB10' Name 'SetWatchPoint';
       FUNCTION ClearWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN; 'WDSPDB10' Name 'ClearWatchPoint';
       FUNCTION GetCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;    'WDSPDB10' Name 'GetCoproRegisterSet';
       FUNCTION PutCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;    'WDSPDB10' Name 'PutCoproRegisterSet';
       FUNCTION DbgLineAvail(CONST Source:STRING;Line:LongWord):BOOLEAN; 'WDSPDB10' Name 'DbgLineAvail';
       PROCEDURE DbgSetExceptions(RTL,SPCC:LONGWORD); 'WDSPDB10' Name 'DbgSetExceptions';
       FUNCTION GetBreakPoints:PBreakPoints; 'WDSPDB10' Name 'GetBreakPoints';
       PROCEDURE GetNextDbgBrkInfo(VAR Adress:LongWord;VAR Typ:BYTE); 'WDSPDB10' Name 'GetNextDbgBrkInfo';
       FUNCTION GetLocalVars(VAR ActualProc:STRING):PLocalVars; 'WDSPDB10' Name 'GetLocalVars';
       PROCEDURE FreeLocalVars(p:PLocalVars); 'WDSPDB10' Name 'FreeLocalVars';
       PROCEDURE GetAdressFromName(s,s1:STRING;VAR value:LONGWORD); 'WDSPDB10' Name 'GetAdressFromName';
       PROCEDURE SetOptions(Options:LONGWORD); 'WDSPDB10' Name 'SetOptions';
     END; //IMPORTS


{$ENDIF}

VAR InDebugger:BOOLEAN;
    DebuggerRunning:BOOLEAN;

TYPE
    TBreakpointType=(NormalBrk,ConditionalBrk,SpecialBrk);

    PBreakPointItem=^TBreakPointItem;
    TBreakPointItem=RECORD
                          Address:LONGWORD;
                          Typ:TBreakpointType;
                          ExtendedInfo:POINTER;
                          Defined:BOOLEAN;
                          BrkTyp:BYTE;
                    END;

    TDebugBreakPointList=CLASS(TList)
         PROCEDURE FreeItem(Item:POINTER);OVERRIDE;
    END;

FUNCTION IsBreakpointDefined(List:TDebugBreakpointList;Address:LONGWORD):BOOLEAN;
PROCEDURE AddBreakpoint(List:TDebugBreakpointList;Typ:TBreakpointType;Address:LONGWORD;
                        ExtendedInfo:POINTER;BrkTyp:BYTE);
PROCEDURE RemoveBreakpoint(List:TDebugBreakpointList;Addr:LONGWORD);
FUNCTION EnableBreakpoint(Addr:LONGWORD;Typ:BYTE):BOOLEAN;
PROCEDURE UnmarkBreakpoint(List:TDebugBreakpointList;Addr:LONGWORD);
PROCEDURE RemarkBreakpoints(List:TDebugBreakpointList);
PROCEDURE DisableAllBreakpoints(List:TDebugBreakpointList);
PROCEDURE DebugCommand(command:LONGINT);

VAR SetDebuggerActiveProc:PROCEDURE;
    ResetDebuggerActiveProc:PROCEDURE;

IMPLEMENTATION

PROCEDURE DebugCommand(command:LONGINT);
BEGIN
     IF SetDebuggerActiveProc<>NIL THEN SetDebuggerActiveProc;
     MainLoop(Command);
END;

PROCEDURE TDebugBreakpointList.FreeItem(Item:POINTER);
BEGIN
     FreeMem(Item,Sizeof(TBreakpointItem));
     Inherited FreeItem(Item);
END;

FUNCTION EnableBreakpoint(Addr:LONGWORD;Typ:BYTE):BOOLEAN;
BEGIN
     IF ((InDebugger)AND(not DebuggerRunning)) THEN result:=SetBreakpoint(Addr,Typ)
     ELSE result:=FALSE;
END;

PROCEDURE RemarkBreakpoints(List:TDebugBreakpointList);
VAR t:LONGINT;
    Item:PBreakpointItem;
BEGIN
     FOR t:=0 TO List.Count-1 DO
     BEGIN
          Item:=List.Items[t];
          IF not Item^.Defined THEN Item^.Defined:=EnableBreakpoint(Item^.Address,Item^.BrkTyp);
     END;
END;

PROCEDURE DisableAllBreakpoints(List:TDebugBreakpointList);
VAR t:LONGINT;
    Item:PBreakpointItem;
BEGIN
     FOR t:=0 TO List.Count-1 DO
     BEGIN
          Item:=List.Items[t];
          Item^.Defined:=FALSE;
     END;
END;

FUNCTION IsBreakpointDefined(List:TDebugBreakpointList;Address:LONGWORD):BOOLEAN;
VAR t:LONGINT;
    Item:PBreakpointItem;
BEGIN
     result:=FALSE;
     FOR t:=0 TO List.Count-1 DO
     BEGIN
          Item:=List.Items[t];
          IF Item^.Address=Address THEN
          BEGIN
               result:=TRUE;
               exit;
          END;
     END;
END;

FUNCTION GetBreakpointItem(List:TDebugBreakpointList;Addr:LONGWORD):PBreakpointItem;
VAR t:LONGINT;
BEGIN
     FOR t:=0 TO List.Count-1 DO
     BEGIN
          result:=List.Items[t];
          IF result^.Address=Addr THEN exit;
     END;
     result:=NIL;
END;

PROCEDURE UnmarkBreakpoint(List:TDebugBreakpointList;Addr:LONGWORD);
VAR Item:PBreakpointItem;
BEGIN
     Item:=GetBreakpointItem(List,Addr);
     IF Item=NIL THEN exit;
     IF not Item^.Defined THEN exit;
     SetNextDbgBrk(Item^.Address,Item^.BrkTyp);
END;

PROCEDURE AddBreakpoint(List:TDebugBreakpointList;Typ:TBreakpointType;Address:LONGWORD;
                        ExtendedInfo:POINTER;BrkTyp:BYTE);
VAR Item:PBreakpointItem;
BEGIN
     Item:=GetBreakpointItem(List,Address);
     IF Item=NIL THEN
     BEGIN
          new(Item);
          Item^.Address:=Address;
          Item^.Typ:=Typ;
          Item^.ExtendedInfo:=ExtendedInfo;
          Item^.Defined:=FALSE;
          Item^.BrkTyp:=BrkTyp;
          List.Add(Item);
     END
     ELSE IF Item^.Defined THEN exit;
     IF EnableBreakpoint(Address,BrkTyp) THEN Item^.Defined:=TRUE;
END;

PROCEDURE RemoveBreakpoint(List:TDebugBreakpointList;Addr:LONGWORD);
VAR Item:PBreakpointItem;
    Src:BYTE;
LABEL l;
BEGIN
     Item:=GetBreakpointItem(List,Addr);
     IF Item=NIL THEN exit;
     IF not Item^.Defined THEN goto l; {only remove}
     IF Item^.Address=GetNextDbgBrk THEN
     BEGIN
          SetNextDbgBrk(0,0); {clear}
          goto l;
     END;
     IF UnsetBreakpoint(Item^.Address,Src) THEN
     BEGIN
l:
          List.Remove(Item);
     END;
END;



PROCEDURE TCPUDumpList.FreeItem(Item:POINTER);
BEGIN
     FreeMem(Item,Sizeof(TCPUDump));
     Inherited FreeItem(Item);
END;

PROCEDURE TCPUList.FreeItem(Item:POINTER);
BEGIN
     FreeMem(Item,Sizeof(TCPUListItem));
     Inherited FreeItem(Item);
END;

PROCEDURE TSourceFilesList.FreeItem(Item:POINTER);
VAR s:PSourceFileItem;
BEGIN
     s:=Item;
     s^.Lines.Destroy;
     FreeMem(Item,Sizeof(TSourceFileItem));
     Inherited FreeItem(Item);
END;


VAR ActCPUDump:PCPUDump;

FUNCTION MemoryValid(Address:POINTER;len:LONGWORD):BOOLEAN;
BEGIN
     result:=FALSE;
     {$IFDEF OS2}
     IF Address<ActCPUDump^.Alias THEN exit;
     IF LONGWORD(Address)+Len>LONGWORD(ActCPUDump^.Alias)+ActCPUDump^.Len THEN exit;
     {$ENDIF}
     result:=TRUE;
END;

TYPE
    TOpcodeKind=(_ModRm,_Direkt,_Override,_Other,_Special,_Jmp,_Nix,_Copro);
    TOpCodeRec=Record
                      Kind:TOpcodeKind;
                      Index:LONGINT;
                End;

{ModRm}
CONST I_ADD=1;
      I_OR=2;
      I_ADC=3;
      I_AND=4;
      I_SUB=5;
      I_XOR=6;
      I_CMP=7;
      I_SBB=8;

ModRmStrings:ARRAY[I_ADD..I_SBB] OF STRING[3]=('ADD','OR','ADC','AND','SUB','XOR','CMP','SBB');

{Direkt}
CONST
     D_PUSH_ES=1;
     D_POP_ES=2;
     D_PUSH_CS=3;
     D_PUSH_SS=4;
     D_POP_SS=5;
     D_PUSH_DS=6;
     D_POP_DS=7;
     D_DAA=8;
     D_DAS=9;
     D_AAA=10;
     D_INC_AX=11;
     D_INC_CX=12;
     D_INC_DX=13;
     D_INC_BX=14;
     D_INC_SP=15;
     D_INC_BP=16;
     D_INC_SI=17;
     D_INC_DI=18;
     D_DEC_AX=19;
     D_DEC_CX=20;
     D_DEC_DX=21;
     D_DEC_BX=22;
     D_DEC_SP=23;
     D_DEC_BP=24;
     D_DEC_SI=25;
     D_DEC_DI=26;
     D_PUSH_AX=27;
     D_PUSH_CX=28;
     D_PUSH_DX=29;
     D_PUSH_BX=30;
     D_PUSH_SP=31;
     D_PUSH_BP=32;
     D_PUSH_SI=33;
     D_PUSH_DI=34;
     D_POP_AX=35;
     D_POP_CX=36;
     D_POP_DX=37;
     D_POP_BX=38;
     D_POP_SP=39;
     D_POP_BP=40;
     D_POP_SI=41;
     D_POP_DI=42;
     D_PUSHA=43;
     D_POPA=44;
     D_INSB=45;
     D_INSW=46;
     D_OUTSB=47;
     D_OUTSW=48;
     D_NOP=49;
     D_XCHG_CX_AX=50;
     D_XCHG_DX_AX=51;
     D_XCHG_BX_AX=52;
     D_XCHG_SP_AX=53;
     D_XCHG_BP_AX=54;
     D_XCHG_SI_AX=55;
     D_XCHG_DI_AX=56;
     D_CBW=57;
     D_CWD=58;
     D_WAIT=59;
     D_PUSHF=60;
     D_POPF=61;
     D_SAHF=62;
     D_LAHF=63;
     D_MOVSB=64;
     D_MOVSW=65;
     D_CMPSB=66;
     D_CMPSW=67;
     D_STOSB=68;
     D_STOSW=69;
     D_LODSB=70;
     D_LODSW=71;
     D_SCASB=72;
     D_SCASW=73;
     D_RET=74;
     D_AAS=75;
     D_LEAVE=76;
     D_RETF=77;
     D_INT3=78;
     D_INTO=79;
     D_IRET=80;
     D_XLAT=81;
     D_IN_AL_DX=82;
     D_IN_AX_DX=83;
     D_OUT_DX_AL=84;
     D_OUT_DX_AX=85;
     D_LOCK=86;
     D_REPNZ=87;
     D_REP=88;
     D_HLT=89;
     D_CMC=90;
     D_CLC=91;
     D_STC=92;
     D_CLI=93;
     D_STI=94;
     D_CLD=95;
     D_STD=96;

{Override}
CONST
     O_SEG_ES=1;
     O_SEG_CS=2;
     O_SEG_SS=3;
     O_SEG_DS=4;
     O_SEG_FS=5;
     O_SEG_GS=6;
     O_66=7;
     O_67=8;
     O_0F=9;

{Other}
CONST
     T_PUSH_IMM16=1;
     T_PUSH_IMM8=2;
     T_TEST_MEM_R8=3;
     T_TEST_MEM_R16=4;
     T_XCHG_MEM_R8=5;
     T_XCHG_MEM_R16=6;
     T_MOV_MEM_R8=7;
     T_MOV_MEM_R16=8;
     T_MOV_R8_MEM=9;
     T_MOV_R16_MEM=10;
     T_MOV_MEM_SEG=11;
     T_LEA_R16_MEM=12;
     T_MOV_SEG_MEM=13;
     T_POP_MEM16=14;
     T_CALL_SEG_OFS=15;
     T_TEST_R8_IMM=16;
     T_TEST_R16_IMM=17;
     T_MOV_AL_IMM=18;
     T_MOV_CL_IMM=19;
     T_MOV_DL_IMM=20;
     T_MOV_BL_IMM=21;
     T_MOV_AH_IMM=22;
     T_MOV_CH_IMM=23;
     T_MOV_DH_IMM=24;
     T_MOV_BH_IMM=25;
     T_MOV_AX_IMM=26;
     T_MOV_CX_IMM=27;
     T_MOV_DX_IMM=28;
     T_MOV_BX_IMM=29;
     T_MOV_SP_IMM=30;
     T_MOV_BP_IMM=31;
     T_MOV_SI_IMM=32;
     T_MOV_DI_IMM=33;
     T_RET_16=34;
     T_LES_AX_MEM=35;
     T_LDS_AX_MEM=36;
     T_MOV_MEM8_IMM=37;
     T_MOV_MEM16_IMM=38;
     T_ENTER_W_B=39;
     T_RETF_16=40;
     T_INT_B=41;
     T_IN_AL_IMM=42;
     T_IN_AX_IMM=43;
     T_OUT_IMM_AL=44;
     T_OUT_IMM_AX=45;
     T_CALL=46;
     T_JMP=47;
     T_JMP_SEG_OFS=48;
     T_TEST_MEM8_IMM=49;
     T_TEST_MEM16_IMM=50;

{Jmp}
CONST
     J_JO=1;
     J_JNO=2;
     J_JB=3;
     J_JNB=4;
     J_JE=5;
     J_JNE=6;
     J_JBE=7;
     J_JA=8;
     J_JS=9;
     J_JNS=10;
     J_JP=11;
     J_JNP=12;
     J_JL=13;
     J_JNL=14;
     J_JLE=15;
     J_JG=16;
     J_LOOPNZ=17;
     J_LOOPZ=18;
     J_LOOP=19;
     J_JCXZ=20;
     J_JMP=21;

JmpStrings:ARRAY[J_JO..J_JMP] OF STRING[6]=
         ('JO','JNO','JB','JNB','JE','JNE','JBE','JA','JS','JNS','JP','JNP','JL',
          'JNL','JLE','JG','LOOPNZ','LOOPZ','LOOP','JCXZ','JMP'
         );

{Special}
CONST
     MEM8_IMM16=1;
     MEM16_IMM16=2;
     MEM8_IMM8=3;
     MEM16_IMM8=4;
     INC_DEC_MEM8=5;
     INC_DEC_MEM16=6;

CONST
    OpCodeRec:ARRAY[0..255] OF TOpCodeRec=
          (
           (Kind:_ModRm;Index:I_ADD),             {00}
           (Kind:_ModRm;Index:I_ADD),             {01}
           (Kind:_ModRm;Index:I_ADD),             {02}
           (Kind:_ModRm;Index:I_ADD),             {03}
           (Kind:_ModRm;Index:I_ADD),             {04}
           (Kind:_ModRm;Index:I_ADD),             {05}
           (Kind:_Direkt;Index:D_PUSH_ES),        {06}
           (Kind:_Direkt;Index:D_POP_ES),         {07}
           (Kind:_ModRm;Index:I_OR),              {08}
           (Kind:_ModRm;Index:I_OR),              {09}
           (Kind:_ModRm;Index:I_OR),              {10}
           (Kind:_ModRm;Index:I_OR),              {11}
           (Kind:_ModRm;Index:I_OR),              {12}
           (Kind:_ModRm;Index:I_OR),              {13}
           (Kind:_Direkt;Index:D_PUSH_CS),        {14}
           (Kind:_Override;Index:O_0F),           {15}   {mehrere}
           (Kind:_ModRm;Index:I_ADC),             {16}
           (Kind:_ModRm;Index:I_ADC),             {17}
           (Kind:_ModRm;Index:I_ADC),             {18}
           (Kind:_ModRm;Index:I_ADC),             {19}
           (Kind:_ModRm;Index:I_ADC),             {20}
           (Kind:_ModRm;Index:I_ADC),             {21}
           (Kind:_Direkt;Index:D_PUSH_SS),        {22}
           (Kind:_Direkt;Index:D_POP_SS),         {23}
           (Kind:_ModRm;Index:I_SBB),             {24}
           (Kind:_ModRm;Index:I_SBB),             {25}
           (Kind:_ModRm;Index:I_SBB),             {26}
           (Kind:_ModRm;Index:I_SBB),             {27}
           (Kind:_ModRm;Index:I_SBB),             {28}
           (Kind:_ModRm;Index:I_SBB),             {29}
           (Kind:_Direkt;Index:D_PUSH_DS),        {30}
           (Kind:_Direkt;Index:D_POP_DS),         {31}
           (Kind:_ModRm;Index:I_AND),             {32}
           (Kind:_ModRm;Index:I_AND),             {33}
           (Kind:_ModRm;Index:I_AND),             {34}
           (Kind:_ModRm;Index:I_AND),             {35}
           (Kind:_ModRm;Index:I_AND),             {36}
           (Kind:_ModRm;Index:I_AND),             {37}
           (Kind:_Override;Index:O_SEG_ES),       {38}
           (Kind:_Direkt;Index:D_DAA),            {39}
           (Kind:_ModRm;Index:I_SUB),             {40}
           (Kind:_ModRm;Index:I_SUB),             {41}
           (Kind:_ModRm;Index:I_SUB),             {42}
           (Kind:_ModRm;Index:I_SUB),             {43}
           (Kind:_ModRm;Index:I_SUB),             {44}
           (Kind:_ModRm;Index:I_SUB),             {45}
           (Kind:_Override;Index:O_SEG_CS),       {46}
           (Kind:_Direkt;Index:D_DAS),            {47}
           (Kind:_ModRm;Index:I_XOR),             {48}
           (Kind:_ModRm;Index:I_XOR),             {49}
           (Kind:_ModRm;Index:I_XOR),             {50}
           (Kind:_ModRm;Index:I_XOR),             {51}
           (Kind:_ModRm;Index:I_XOR),             {52}
           (Kind:_ModRm;Index:I_XOR),             {53}
           (Kind:_Override;Index:O_SEG_SS),       {54}
           (Kind:_Direkt;Index:D_AAA),            {55}
           (Kind:_ModRm;Index:I_CMP),             {56}
           (Kind:_ModRm;Index:I_CMP),             {57}
           (Kind:_ModRm;Index:I_CMP),             {58}
           (Kind:_ModRm;Index:I_CMP),             {59}
           (Kind:_ModRm;Index:I_CMP),             {60}
           (Kind:_ModRm;Index:I_CMP),             {61}
           (Kind:_Override;Index:O_SEG_DS),       {62}
           (Kind:_Direkt;Index:D_AAS),            {63}
           (Kind:_Direkt;Index:D_INC_AX),         {64}
           (Kind:_Direkt;Index:D_INC_CX),         {65}
           (Kind:_Direkt;Index:D_INC_DX),         {66}
           (Kind:_Direkt;Index:D_INC_BX),         {67}
           (Kind:_Direkt;Index:D_INC_SP),         {68}
           (Kind:_Direkt;Index:D_INC_BP),         {69}
           (Kind:_Direkt;Index:D_INC_SI),         {70}
           (Kind:_Direkt;Index:D_INC_DI),         {71}
           (Kind:_Direkt;Index:D_DEC_AX),         {72}
           (Kind:_Direkt;Index:D_DEC_CX),         {73}
           (Kind:_Direkt;Index:D_DEC_DX),         {74}
           (Kind:_Direkt;Index:D_DEC_BX),         {75}
           (Kind:_Direkt;Index:D_DEC_SP),         {76}
           (Kind:_Direkt;Index:D_DEC_BP),         {77}
           (Kind:_Direkt;Index:D_DEC_SI),         {78}
           (Kind:_Direkt;Index:D_DEC_DI),         {79}
           (Kind:_Direkt;Index:D_PUSH_AX),        {80}
           (Kind:_Direkt;Index:D_PUSH_CX),        {81}
           (Kind:_Direkt;Index:D_PUSH_DX),        {82}
           (Kind:_Direkt;Index:D_PUSH_BX),        {83}
           (Kind:_Direkt;Index:D_PUSH_SP),        {84}
           (Kind:_Direkt;Index:D_PUSH_BP),        {85}
           (Kind:_Direkt;Index:D_PUSH_SI),        {86}
           (Kind:_Direkt;Index:D_PUSH_DI),        {87}
           (Kind:_Direkt;Index:D_POP_AX),         {88}
           (Kind:_Direkt;Index:D_POP_CX),         {89}
           (Kind:_Direkt;Index:D_POP_DX),         {90}
           (Kind:_Direkt;Index:D_POP_BX),         {91}
           (Kind:_Direkt;Index:D_POP_SP),         {92}
           (Kind:_Direkt;Index:D_POP_BP),         {93}
           (Kind:_Direkt;Index:D_POP_SI),         {94}
           (Kind:_Direkt;Index:D_POP_DI),         {95}
           (Kind:_Direkt;Index:D_PUSHA),          {96}
           (Kind:_Direkt;Index:D_POPA),           {97}
           (Kind:_Special;Index:0),               {98}  {mehrere (BOUND)}
           (Kind:_Special;Index:0),               {99}  {mehrere (ARPL)}
           (Kind:_Override;Index:O_SEG_FS),       {100}
           (Kind:_Override;Index:O_SEG_GS),       {101}
           (Kind:_Override;Index:O_66),           {102}
           (Kind:_Override;Index:O_67),           {103}
           (Kind:_Other;Index:T_PUSH_IMM16),      {104}
           (Kind:_Special;Index:0),               {105} {mehrere (IMUL)}
           (Kind:_Other;Index:T_PUSH_IMM8),       {106}
           (Kind:_Special;Index:0),               {107} {mehrere (IMUL)}
           (Kind:_Direkt;Index:D_INSB),           {108}
           (Kind:_Direkt;Index:D_INSW),           {109}
           (Kind:_Direkt;Index:D_OUTSB),          {110}
           (Kind:_Direkt;Index:D_OUTSW),          {111}
           (Kind:_Jmp;Index:J_JO),                {112}
           (Kind:_Jmp;Index:J_JNO),               {113}
           (Kind:_Jmp;Index:J_JB),                {114}
           (Kind:_Jmp;Index:J_JNB),               {115}
           (Kind:_Jmp;Index:J_JE),                {116}
           (Kind:_Jmp;Index:J_JNE),               {117}
           (Kind:_Jmp;Index:J_JBE),               {118}
           (Kind:_Jmp;Index:J_JA),                {119}
           (Kind:_Jmp;Index:J_JS),                {120}
           (Kind:_Jmp;Index:J_JNS),               {121}
           (Kind:_Jmp;Index:J_JP),                {122}
           (Kind:_Jmp;Index:J_JNP),               {123}
           (Kind:_Jmp;Index:J_JL),                {124}
           (Kind:_Jmp;Index:J_JNL),               {125}
           (Kind:_Jmp;Index:J_JLE),               {126}
           (Kind:_Jmp;Index:J_JG),                {127}
           (Kind:_Special;Index:MEM8_IMM16),      {128}
           (Kind:_Special;Index:MEM16_IMM16),     {129}
           (Kind:_Special;Index:MEM8_IMM8),       {130}
           (Kind:_Special;Index:MEM16_IMM8),      {131}
           (Kind:_Other;Index:T_TEST_MEM_R8),     {132}
           (Kind:_Other;Index:T_TEST_MEM_R16),    {133}
           (Kind:_Other;Index:T_XCHG_MEM_R8),     {134}
           (Kind:_Other;Index:T_XCHG_MEM_R16),    {135}
           (Kind:_Other;Index:T_MOV_MEM_R8),      {136}
           (Kind:_Other;Index:T_MOV_MEM_R16),     {137}
           (Kind:_Other;Index:T_MOV_R8_MEM),      {138}
           (Kind:_Other;Index:T_MOV_R16_MEM),     {139}
           (Kind:_Other;Index:T_MOV_MEM_SEG),     {140}
           (Kind:_Other;Index:T_LEA_R16_MEM),     {141}
           (Kind:_Other;Index:T_MOV_SEG_MEM),     {142}
           (Kind:_Other;Index:T_POP_MEM16),       {143}
           (Kind:_Direkt;Index:D_NOP),            {144}
           (Kind:_Direkt;Index:D_XCHG_CX_AX),     {145}
           (Kind:_Direkt;Index:D_XCHG_DX_AX),     {146}
           (Kind:_Direkt;Index:D_XCHG_BX_AX),     {147}
           (Kind:_Direkt;Index:D_XCHG_SP_AX),     {148}
           (Kind:_Direkt;Index:D_XCHG_BP_AX),     {149}
           (Kind:_Direkt;Index:D_XCHG_SI_AX),     {150}
           (Kind:_Direkt;Index:D_XCHG_DI_AX),     {151}
           (Kind:_Direkt;Index:D_CBW),            {152}
           (Kind:_Direkt;Index:D_CWD),            {153}
           (Kind:_Other;Index:T_CALL_SEG_OFS),    {154}
           (Kind:_Direkt;Index:D_WAIT),           {155}
           (Kind:_Direkt;Index:D_PUSHF),          {156}
           (Kind:_Direkt;Index:D_POPF),           {157}
           (Kind:_Direkt;Index:D_SAHF),           {158}
           (Kind:_Direkt;Index:D_LAHF),           {159}
           (Kind:_Other;Index:T_MOV_R8_MEM),      {160}  {nochmal??}
           (Kind:_Other;Index:T_MOV_R16_MEM),     {161}  {nochmal??}
           (Kind:_Other;Index:T_MOV_MEM_R8),      {162}  {nochmal??}
           (Kind:_Other;Index:T_MOV_MEM_R16),     {163}  {nochmal??}
           (Kind:_Direkt;Index:D_MOVSB),          {164}
           (Kind:_Direkt;Index:D_MOVSW),          {165}
           (Kind:_Direkt;Index:D_CMPSB),          {166}
           (Kind:_Direkt;Index:D_CMPSW),          {167}
           (Kind:_Other;Index:T_TEST_R8_IMM),     {168}
           (Kind:_Other;Index:T_TEST_R16_IMM),    {169}
           (Kind:_Direkt;Index:D_STOSB),          {170}
           (Kind:_Direkt;Index:D_STOSW),          {171}
           (Kind:_Direkt;Index:D_LODSB),          {172}
           (Kind:_Direkt;Index:D_LODSW),          {173}
           (Kind:_Direkt;Index:D_SCASB),          {174}
           (Kind:_Direkt;Index:D_SCASW),          {175}
           (Kind:_Other;Index:T_MOV_AL_IMM),      {176}
           (Kind:_Other;Index:T_MOV_CL_IMM),      {177}
           (Kind:_Other;Index:T_MOV_DL_IMM),      {178}
           (Kind:_Other;Index:T_MOV_BL_IMM),      {179}
           (Kind:_Other;Index:T_MOV_AH_IMM),      {180}
           (Kind:_Other;Index:T_MOV_CH_IMM),      {182}
           (Kind:_Other;Index:T_MOV_DH_IMM),      {182}
           (Kind:_Other;Index:T_MOV_BH_IMM),      {183}
           (Kind:_Other;Index:T_MOV_AX_IMM),      {184}
           (Kind:_Other;Index:T_MOV_CX_IMM),      {185}
           (Kind:_Other;Index:T_MOV_DX_IMM),      {186}
           (Kind:_Other;Index:T_MOV_BX_IMM),      {187}
           (Kind:_Other;Index:T_MOV_SP_IMM),      {188}
           (Kind:_Other;Index:T_MOV_BP_IMM),      {189}
           (Kind:_Other;Index:T_MOV_SI_IMM),      {190}
           (Kind:_Other;Index:T_MOV_DI_IMM),      {191}
           (Kind:_Special;Index:0),               {192} {mehrere (ROL,ROR)}
           (Kind:_Special;Index:0),               {193} {mehrere (ROL,ROR)}
           (Kind:_Other;Index:T_RET_16),          {194}
           (Kind:_Direkt;Index:D_RET),            {195}
           (Kind:_Other;Index:T_LES_AX_MEM),      {196}
           (Kind:_Other;Index:T_LDS_AX_MEM),      {197}
           (Kind:_Other;Index:T_MOV_MEM8_IMM),    {198}
           (Kind:_Other;Index:T_MOV_MEM16_IMM),   {199}
           (Kind:_Other;Index:T_ENTER_W_B),       {200}
           (Kind:_Direkt;Index:D_LEAVE),          {201}
           (Kind:_Other;Index:T_RETF_16),         {202}
           (Kind:_Direkt;Index:D_RETF),           {203}
           (Kind:_Direkt;Index:D_INT3),           {204}
           (Kind:_Other;Index:T_INT_B),           {205}
           (Kind:_Direkt;Index:D_INTO),           {206}
           (Kind:_Direkt;Index:D_IRET),           {207}
           (Kind:_Special;Index:0),               {208} {mehrere (ROL,ROR)}
           (Kind:_Special;Index:0),               {209} {mehrere (ROL,ROR)}
           (Kind:_Special;Index:0),               {210} {mehrere (ROL,ROR)}
           (Kind:_Special;Index:0),               {211} {mehrere (ROL,ROR)}
           (Kind:_Special;Index:0),               {212} {mehrere (D4,0A=AAM)}
           (Kind:_Special;Index:0),               {213} {mehrere (D5,0A=AAD)}
           (Kind:_Nix;Index:0),                   {214}
           (Kind:_Direkt;Index:D_XLAT),           {215}
           (Kind:_Copro;Index:0),                 {216} {Copro}
           (Kind:_Copro;Index:0),                 {217} {Copro}
           (Kind:_Copro;Index:0),                 {218} {Copro}
           (Kind:_Copro;Index:0),                 {219} {Copro}
           (Kind:_Copro;Index:0),                 {220} {Copro}
           (Kind:_Copro;Index:0),                 {221} {Copro}
           (Kind:_Copro;Index:0),                 {222} {Copro}
           (Kind:_Copro;Index:0),                 {223} {Copro}
           (Kind:_Jmp;Index:J_LOOPNZ),            {224}
           (Kind:_Jmp;Index:J_LOOPZ),             {225}
           (Kind:_Jmp;Index:J_LOOP),              {226}
           (Kind:_Jmp;Index:J_JCXZ),              {227}
           (Kind:_Other;Index:T_IN_AL_IMM),       {228}
           (Kind:_Other;Index:T_IN_AX_IMM),       {229}
           (Kind:_Other;Index:T_OUT_IMM_AL),      {230}
           (Kind:_Other;Index:T_OUT_IMM_AX),      {231}
           (Kind:_Other;Index:T_CALL),            {232}
           (Kind:_Other;Index:T_JMP),             {233}
           (Kind:_Other;Index:T_JMP_SEG_OFS),     {234}
           (Kind:_Jmp;Index:J_JMP),               {235}
           (Kind:_Direkt;Index:D_IN_AL_DX),       {236}
           (Kind:_Direkt;Index:D_IN_AX_DX),       {237}
           (Kind:_Direkt;Index:D_OUT_DX_AL),      {238}
           (Kind:_Direkt;Index:D_OUT_DX_AX),      {239}
           (Kind:_Direkt;Index:D_LOCK),           {240}
           (Kind:_Nix;Index:0),                   {241}
           (Kind:_Direkt;Index:D_REPNZ),          {242}
           (Kind:_Direkt;Index:D_REP),            {243}
           (Kind:_Direkt;Index:D_HLT),            {244}
           (Kind:_Direkt;Index:D_CMC),            {245}
           (Kind:_Other;Index:T_TEST_MEM8_IMM),   {246}
           (Kind:_Other;Index:T_TEST_MEM16_IMM),  {247}
           (Kind:_Direkt;Index:D_CLC),            {248}
           (Kind:_Direkt;Index:D_STC),            {249}
           (Kind:_Direkt;Index:D_CLI),            {250}
           (Kind:_Direkt;Index:D_STI),            {251}
           (Kind:_Direkt;Index:D_CLD),            {252}
           (Kind:_Direkt;Index:D_STD),            {253}
           (Kind:_Special;Index:INC_DEC_MEM8),    {254}   {mehrere INC,DEC}
           (Kind:_Special;Index:INC_DEC_MEM16)    {255}   {mehrere INC,DEC}
          );


VAR Override66,Override67:BOOLEAN;
    OverrideES,OverrideDS,OverrideSS,OverrideCS,OverrideGS,OverrideFS:BOOLEAN;

FUNCTION GetDirektString(Code:LONGINT):STRING;
BEGIN
     CASE Code OF
         D_PUSH_ES:result:='PUSH ES';
         D_POP_ES:result:='POP ES';
         D_PUSH_CS:result:='PUSH CS';
         D_PUSH_SS:result:='PUSH SS';
         D_POP_SS:result:='POP SS';
         D_PUSH_DS:result:='PUSH DS';
         D_POP_DS:result:='POP DS';
         D_DAA:result:='DAA';
         D_DAS:result:='DAS';
         D_AAA:result:='AAA';
         D_INC_AX:IF Override66 THEN Result:='INC AX'
                  ELSE result:='INC EAX';
         D_INC_CX:IF Override66 THEN Result:='INC CX'
                  ELSE result:='INC ECX';
         D_INC_DX:IF Override66 THEN Result:='INC DX'
                  ELSE result:='INC EDX';
         D_INC_BX:IF Override66 THEN Result:='INC BX'
                  ELSE result:='INC EBX';
         D_INC_SP:IF Override66 THEN Result:='INC SP'
                  ELSE result:='INC ESP';
         D_INC_BP:IF Override66 THEN Result:='INC BP'
                  ELSE result:='INC EBP';
         D_INC_SI:IF Override66 THEN Result:='INC SI'
                  ELSE result:='INC ESI';
         D_INC_DI:IF Override66 THEN Result:='INC DI'
                  ELSE result:='INC EDI';
         D_DEC_AX:IF Override66 THEN Result:='DEC AX'
                  ELSE result:='DEC EAX';
         D_DEC_CX:IF Override66 THEN Result:='DEC CX'
                  ELSE result:='DEC ECX';
         D_DEC_DX:IF Override66 THEN Result:='DEC DX'
                  ELSE result:='DEC EDX';
         D_DEC_BX:IF Override66 THEN Result:='DEC BX'
                  ELSE result:='DEC EBX';
         D_DEC_SP:IF Override66 THEN Result:='DEC SP'
                  ELSE result:='DEC ESP';
         D_DEC_BP:IF Override66 THEN Result:='DEC BP'
                  ELSE result:='DEC EBP';
         D_DEC_SI:IF Override66 THEN Result:='DEC SI'
                  ELSE result:='DEC ESI';
         D_DEC_DI:IF Override66 THEN Result:='DEC DI'
                  ELSE result:='DEC EDI';
         D_PUSH_AX:IF Override66 THEN Result:='PUSH AX'
                  ELSE result:='PUSH EAX';
         D_PUSH_CX:IF Override66 THEN Result:='PUSH CX'
                  ELSE result:='PUSH ECX';
         D_PUSH_DX:IF Override66 THEN Result:='PUSH DX'
                  ELSE result:='PUSH EDX';
         D_PUSH_BX:IF Override66 THEN Result:='PUSH BX'
                  ELSE result:='PUSH EBX';
         D_PUSH_SP:IF Override66 THEN Result:='PUSH SP'
                  ELSE result:='PUSH ESP';
         D_PUSH_BP:IF Override66 THEN Result:='PUSH BP'
                  ELSE result:='PUSH EBP';
         D_PUSH_SI:IF Override66 THEN Result:='PUSH SI'
                  ELSE result:='PUSH ESI';
         D_PUSH_DI:IF Override66 THEN Result:='PUSH DI'
                  ELSE result:='PUSH EDI';
         D_POP_AX:IF Override66 THEN Result:='POP AX'
                  ELSE result:='POP EAX';
         D_POP_CX:IF Override66 THEN Result:='POP CX'
                  ELSE result:='POP ECX';
         D_POP_DX:IF Override66 THEN Result:='POP DX'
                  ELSE result:='POP EDX';
         D_POP_BX:IF Override66 THEN Result:='POP BX'
                  ELSE result:='POP EBX';
         D_POP_SP:IF Override66 THEN Result:='POP SP'
                  ELSE result:='POP ESP';
         D_POP_BP:IF Override66 THEN Result:='POP BP'
                  ELSE result:='POP EBP';
         D_POP_SI:IF Override66 THEN Result:='POP SI'
                  ELSE result:='POP ESI';
         D_POP_DI:IF Override66 THEN Result:='POP DI'
                  ELSE result:='POP EDI';
         D_PUSHA:IF Override66 THEN Result:='PUSHA'
                 ELSE result:='PUSHAD';
         D_POPA:IF Override66 THEN Result:='POPA'
                ELSE result:='POPAD';
         D_INSB:result:='INSB';
         D_INSW:result:='INSW';
         D_OUTSB:result:='OUTSB';
         D_OUTSW:result:='OUTSW';
         D_NOP:result:='NOP';
         D_XCHG_CX_AX:IF Override66 THEN Result:='XCHG CX,AX'
                      ELSE result:='XCHG ECX,EAX';
         D_XCHG_DX_AX:IF Override66 THEN Result:='XCHG DX,AX'
                      ELSE result:='XCHG EDX,EAX';
         D_XCHG_BX_AX:IF Override66 THEN Result:='XCHG BX,AX'
                      ELSE result:='XCHG EBX,EAX';
         D_XCHG_SP_AX:IF Override66 THEN Result:='XCHG SP,AX'
                      ELSE result:='XCHG ESP,EAX';
         D_XCHG_BP_AX:IF Override66 THEN Result:='XCHG BP,AX'
                      ELSE result:='XCHG EBP,EAX';
         D_XCHG_SI_AX:IF Override66 THEN Result:='XCHG SI,AX'
                      ELSE result:='XCHG ESI,EAX';
         D_XCHG_DI_AX:IF Override66 THEN Result:='XCHG DI,AX'
                      ELSE result:='XCHG EDI,EAX';
         D_CBW:IF Override66 THEN Result:='CBW'
               ELSE result:='CDQ';
         D_CWD:IF Override66 THEN Result:='CWD'
               ELSE result:='CWDE';
         D_WAIT:result:='WAIT';
         D_PUSHF:IF Override66 THEN Result:='PUSHF'
                 ELSE result:='PUSHFD';
         D_POPF:IF Override66 THEN Result:='POPF'
                ELSE result:='POPFD';
         D_SAHF:result:='SAHF';
         D_LAHF:result:='LAHF';
         D_MOVSB:result:='MOVSB';
         D_MOVSW:IF Override66 THEN Result:='MOVSW'
                 ELSE result:='MOVSD';
         D_CMPSB:Result:='CMPSB';
         D_CMPSW:IF Override66 THEN Result:='CMPSB'
                 ELSE result:='CMPSD';
         D_STOSB:result:='STOSB';
         D_STOSW:IF Override66 THEN Result:='STOSB'
                 ELSE result:='STOSD';
         D_LODSB:result:='LODSB';
         D_LODSW:IF Override66 THEN Result:='LODSB'
                 ELSE result:='LODSD';
         D_SCASB:result:='SCASB';
         D_SCASW:IF Override66 THEN Result:='SCASB'
                 ELSE result:='SCASD';
         D_RET:result:='RETN32';
         D_AAS:result:='AAS';
         D_LEAVE:result:='LEAVE';
         D_RETF:result:='RETF';
         D_INT3:result:='INT 3';
         D_INTO:result:='INTO';
         D_IRET:result:='IRET';
         D_XLAT:result:='XLAT';
         D_IN_AL_DX:result:='IN AL,DX';
         D_IN_AX_DX:result:='IN AX,DX';
         D_OUT_DX_AL:result:='OUT DX,AL';
         D_OUT_DX_AX:result:='OUT DX,AX';
         D_LOCK:result:='LOCK';
         D_REPNZ:result:='REPNZ';
         D_REP:result:='REP';
         D_HLT:result:='HLT';
         D_CMC:result:='CMC';
         D_CLC:result:='CLC';
         D_STC:result:='STC';
         D_CLI:result:='CLI';
         D_STI:result:='STI';
         D_CLD:result:='CLD';
         D_STD:result:='STD';
         ELSE result:='???';
     END; {case}
END;

FUNCTION GetModRmString(VAR Code:PCodePointer;VAR mem,reg:STRING;Size:LONGINT):BOOLEAN;
VAR b,ModByte,RegByte,RmByte,IndexByte,BaseByte,SSByte:BYTE;
    DispSize,l:LONGINT;
    s:STRING;
    pl:^LONGINT;
    pb:^ShortInt;
    pi:^INTEGER;
    IsLocal,IsGlobal:BOOLEAN;
    Addr:LONGINT;
    memzusatz,SibAdd,SibBase:STRING;
LABEL loop1,loop2;
BEGIN
     result:=FALSE;
     IsLocal:=FALSE;
     IsGlobal:=FALSE;

     IF not MemoryValid(Code,1) THEN exit;
     b:=Code^[0];
     RmByte:=b AND 7;
     RegByte:=(b SHR 3) AND 7;
     ModByte:=(b SHR 6) AND 3;
     inc(Code);
     DispSize:=0;

     SibBase:='';
     SibAdd:='';
     CASE ModByte OF
        0:
        BEGIN
loop1:
             CASE RMByte OF
                 0:IF Override67 THEN mem:='[AX'
                   ELSE mem:='[EAX';
                 1:IF Override67 THEN mem:='[CX'
                   ELSE mem:='[ECX';
                 2:IF Override67 THEN mem:='[DX'
                   ELSE mem:='[EDX';
                 3:IF Override67 THEN mem:='[BX'
                   ELSE mem:='[EBX';
                 4:
                 BEGIN  {SIB}
                      IF not MemoryValid(Code,1) THEN exit;
                      b:=Code^[0];
                      BaseByte:=b AND 7;
                      IndexByte:=(b SHR 3) AND 7;
                      SSByte:=(b SHR 6) AND 3;
                      inc(Code);
                      CASE SSByte OF
                         0:
                         BEGIN
                              s:='';
loop2:
                              CASE IndexByte OF
                                  0:SibBase:='[EAX';
                                  1:SibBase:='[ECX';
                                  2:SibBase:='[EDX';
                                  3:SibBase:='[EBX';
                                  4:SibBase:='[';
                                  5:SibBase:='[EBP';
                                  6:SibBase:='[ESI';
                                  7:SibBase:='[EDI';
                              END; {case}
                              mem:=SibBase+s;
                         END;
                         1:
                         BEGIN
                              s:='*2';
                              goto loop2;
                         END;
                         2:
                         BEGIN
                              s:='*4';
                              goto loop2;
                         END;
                         3:
                         BEGIN
                              s:='*8';
                              goto loop2;
                         END;
                      END; {case}

                      CASE BaseByte OF
                         0:SibAdd:='+EAX';
                         1:SibAdd:='+ECX';
                         2:SibAdd:='+EDX';
                         3:SibAdd:='+EBX';
                         4:SibAdd:='+ESP';
                         5:IF ModByte=0 THEN
                           BEGIN
                                DispSize:=4;
                                SibAdd:='';
                           END
                           ELSE SibAdd:='+ESP';
                         6:SibAdd:='+ESI';
                         7:SibAdd:='+EDI';
                      END; {case}

                      mem:=mem+SibAdd;

                      IF pos('[+',mem)=1 THEN Delete(Mem,2,1);
                 END;
                 5:
                 BEGIN
                      mem:='';
                      IsGlobal:=TRUE;
                      DispSize:=4;
                 END;
                 6:IF Override66 THEN mem:='[SI'
                   ELSE mem:='[ESI';
                 7:IF Override66 THEN mem:='[DI'
                   ELSE mem:='[EDI';
             END; {case}
        END;
        1:
        BEGIN
             DispSize:=1;
             IF RmByte=5 THEN
             BEGIN
                  IF Override66 THEN mem:='[BP'
                  ELSE
                  BEGIN
                       mem:='[EBP';
                       IsLocal:=TRUE;
                  END;
             END
             ELSE goto loop1;
        END;
        2:
        BEGIN
             IF Override66 THEN DispSize:=2
             ELSE DispSize:=4;
             IF RmByte=5 THEN
             BEGIN
                  IF Override66 THEN mem:='[BP'
                  ELSE
                  BEGIN
                       mem:='[EBP';
                       IsLocal:=TRUE;
                  END;
             END
             ELSE goto loop1;
        END;
        3:
        BEGIN
             CASE RMByte OF
                 0:IF Size=1 THEN mem:='AL'
                   ELSE IF Override66 THEN mem:='AX'
                   ELSE mem:='EAX';
                 1:IF Size=1 THEN mem:='CL'
                   ELSE IF Override66 THEN mem:='CX'
                   ELSE mem:='ECX';
                 2:IF Size=1 THEN mem:='DL'
                   ELSE IF Override66 THEN mem:='DX'
                   ELSE mem:='EDX';
                 3:IF Size=1 THEN mem:='BL'
                   ELSE IF Override66 THEN mem:='BX'
                   ELSE mem:='EBX';
                 4:IF Size=1 THEN mem:='AH'
                   ELSE IF Override66 THEN mem:='SP'
                   ELSE mem:='ESP';
                 5:IF Size=1 THEN mem:='CH'
                   ELSE IF Override66 THEN mem:='BP'
                   ELSE mem:='EBP';
                 6:IF Size=1 THEN mem:='DH'
                   ELSE IF Override66 THEN mem:='SI'
                   ELSE mem:='ESI';
                 7:IF Size=1 THEN mem:='BH'
                   ELSE IF Override66 THEN mem:='DI'
                   ELSE mem:='EDI';
             END; {case}
        END;
     END; {case}

     CASE DispSize OF
        1:
        BEGIN
             IF not MemoryValid(Code,1) THEN exit;
             pb:=POINTER(Code);
             l:=pb^;
        END;
        2:
        BEGIN
             IF not MemoryValid(Code,2) THEN exit;
             pi:=POINTER(Code);
             l:=pi^;
        END;
        4:
        BEGIN
             IF not MemoryValid(Code,4) THEN exit;
             pl:=POINTER(Code);
             l:=pl^;
        END;
        ELSE l:=0;
     END; {case}

     IF DispSize>0 THEN
     BEGIN
          inc(Code,DispSize);
          IF ((l>0)OR(length(mem)=0)) THEN
          BEGIN
               s:=ToHex(l);
               Delete(s,1,1);  {Delete $}
               IF DispSize=1 THEN Delete(s,1,6)
               ELSE IF DispSize=2 THEN Delete(s,1,4);
               IF length(mem)>0 THEN s:='+'+s;
          END
          ELSE
          BEGIN
               l:=-l;
               s:=ToHex(l);
               Delete(s,1,1);  {Delete $}
               IF DispSize=1 THEN Delete(s,1,6)
               ELSE IF DispSize=2 THEN Delete(s,1,4);
               s:='-'+s;
               l:=-l;
          END;
          memzusatz:=s;
     END
     ELSE memzusatz:='';

     IF ((IsLocal)OR(IsGlobal)) THEN
     BEGIN
          Addr:=LONGINT(Code);  {End Address}
          Addr:=Addr-LONGINT(ActCPUDump^.Alias);
          Addr:=Addr+ActCPUDump^.StartAddr;
          IF IsLocal THEN s:=GetNameFromAddr(Addr,AddrLocal,l)
          ELSE s:=GetNameFromAddr(Addr,AddrData,l);
          IF s<>'' THEN
          BEGIN
               mem:='[';
               MemZusatz:=s;
          END;
     END;

     mem:=mem+memzusatz;
     IF mem[1]='[' THEN mem:=mem+']';

     CASE RegByte OF
        0:IF Size=1 THEN reg:='AL'
          ELSE IF Override66 THEN reg:='AX'
          ELSE reg:='EAX';
        1:IF Size=1 THEN reg:='CL'
          ELSE IF Override66 THEN reg:='CX'
          ELSE reg:='ECX';
        2:IF Size=1 THEN reg:='DL'
          ELSE IF Override66 THEN reg:='DX'
          ELSE reg:='EDX';
        3:IF Size=1 THEN reg:='BL'
          ELSE IF Override66 THEN reg:='BX'
          ELSE reg:='EBX';
        4:IF Size=1 THEN reg:='AH'
          ELSE IF Override66 THEN reg:='SP'
          ELSE reg:='ESP';
        5:IF Size=1 THEN reg:='CH'
          ELSE IF Override66 THEN reg:='BP'
          ELSE reg:='EBP';
        6:IF Size=1 THEN reg:='DH'
          ELSE IF Override66 THEN reg:='SI'
          ELSE reg:='ESI';
        7:IF Size=1 THEN reg:='BH'
          ELSE IF Override66 THEN reg:='DI'
          ELSE reg:='EDI';
     END; {case}

     result:=TRUE;
END;

FUNCTION DisAssemble_Code(Code:PCodePointer;VAR Len:LONGINT):STRING;
VAR SaveCode:PCodePointer;
    s,mem,reg:STRING;
    b,b1:BYTE;
    i:LONGINT;
    lw:LONGWORD;
    DispSize:BYTE;
    ok:BOOLEAN;
    plw:^LONGWORD;
    pw:^WORD;
    pb:^BYTE;
    pi:^SHORTINT;
    pl:^LONGINT;
    ShortJmp:BOOLEAN;
    {$IFDEF WIN32}
    p:Pointer;
    OldCode:PCodePointer;
    DbgBuf:TDbgBuf;
    {$ENDIF}
CONST ModRMOperations:ARRAY[0..7] OF STRING[3]=('ADD','OR','ADC','SBB','AND','SUB','XOR','CMP');
      SetStrings:ARRAY[$92..$9F] OF STRING[5]=('SETB','SETAE','SETE','SETNE','SETBE','SETA','SETS','SETNS',
                                               'SETP','SETNP','SETL','SETGE','SETLE','SETG');
LABEL ex,again,imm,jmp,jmp1,accerr,int3;
BEGIN
     result:='???';
     SaveCode:=Code;
     Override66:=FALSE;
     Override67:=FALSE;
     OverrideES:=FALSE;
     OverrideDS:=FALSE;
     OverrideSS:=FALSE;
     OverrideCS:=FALSE;
     OverrideGS:=FALSE;
     OverrideFS:=FALSE;
     ShortJmp:=TRUE;

     {$IFDEF WIN32}
     GetMem(p,16);
     DbgBuf.Addr:=LongWord(Code);
     DbgBuf.Buffer:=LongWord(p);
     DbgBuf.Len:=16;
     DbgBuf.Cmd:=DBG_C_READMEMBUF;
     IssueDebugCommand(DbgBuf);
     OldCode:=Code;
     Code:=p;
     SaveCode:=Code;
     {$ENDIF}
again:
     IF not MemoryValid(Code,1) THEN
     BEGIN
accerr:
          result:='???';
          Len:=0;
          {$IFDEF WIN32}
          FreeMem(p,16);
          {$ENDIF}
          exit;
     END;
     b:=Code^[0];
int3:
     CASE OpCodeRec[b].Kind OF
         _ModRm:
         BEGIN
              s:=ModRmStrings[OpCodeRec[b].Index]+' ';
              b:=b AND 7;
              inc(Code);
              IF not MemoryValid(Code,1) THEN goto accerr;
              CASE b OF
                 0:  {mem,r8}
                 BEGIN
                      IF GetModRmString(Code,mem,reg,1) THEN result:=s+mem+','+reg
                      ELSE goto accerr;
                 END;
                 1:  {mem,r16}
                 BEGIN
                      IF GetModRmString(Code,mem,reg,2) THEN result:=s+mem+','+reg
                      ELSE goto accerr;
                 END;
                 2:  {r8,mem}
                 BEGIN
                      IF GetModRmString(Code,mem,reg,1) THEN result:=s+reg+','+mem
                      ELSE goto accerr;
                 END;
                 3:  {r16,mem}
                 BEGIN
                      IF GetModRmString(Code,mem,reg,2) THEN result:=s+reg+','+mem
                      ELSE goto accerr;
                 END;
                 4:  {AL,imm8}
                 BEGIN
                      result:=s+' AL,';
                      DispSize:=1;
                      goto imm;
                 END;
                 5:  {AX/EAX,imm16/32}
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:=s+' AX,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:=s+' EAX,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
              END; {case}
         END;
         _Direkt:
         BEGIN
              IF OpCodeRec[b].Index=D_INT3 THEN
              BEGIN
                   i:=LONGINT(Code);  {End Address}
                   i:=i-LONGINT(ActCPUDump^.Alias);
                   i:=i+ActCPUDump^.StartAddr;
                   IF GetBreakPointOp(i,b) THEN
                   BEGIN
                        {Breakpoint by debugger}
                        goto int3;
                   END;
              END;

              IF ((OverrideES)OR(OverrideCS)OR(OverrideSS)OR(OverrideDS)OR(OverrideFS)OR(OverrideGS)) THEN  goto ex;

              result:=GetDirektString(OpCodeRec[b].Index);
              inc(Code);
              IF not MemoryValid(Code,1) THEN goto accerr;
         END;
         _Override:
         BEGIN
              IF OpCodeRec[b].Index IN [O_SEG_ES,O_SEG_CS,O_SEG_SS,O_SEG_DS,O_SEG_FS,O_SEG_GS] THEN
                IF ((OverrideES)OR(OverrideCS)OR(OverrideSS)OR(OverrideDS)OR(OverrideFS)OR(OverrideGS)) THEN goto ex;

              CASE OpCodeRec[b].Index OF
                  O_SEG_ES:OverrideES:=TRUE;
                  O_SEG_CS:OverrideCS:=TRUE;
                  O_SEG_SS:OverrideSS:=TRUE;
                  O_SEG_DS:OverrideDS:=TRUE;
                  O_SEG_FS:OverrideFS:=TRUE;
                  O_SEG_GS:OverrideGS:=TRUE;
                  O_66:IF Override66 THEN goto ex
                       ELSE Override66:=TRUE;
                  O_67:IF Override67 THEN goto ex
                       ELSE Override67:=TRUE;
                  O_0F:
                  BEGIN
                       inc(Code);
                       IF not MemoryValid(Code,1) THEN goto accerr;
                       dec(Code);
                       IF ((Code^[1]>128)AND(Code^[1]<143)) THEN {Jump}
                       BEGIN
                            b:=Code^[1]-16;
                            Inc(Code);
                            ShortJmp:=FALSE;
                            goto Jmp1;
                       END
                       ELSE IF ((Code^[1]>=$92)AND(Code^[1]<=$9F)) THEN {SETxx}
                       BEGIN
                            b:=Code^[1];
                            inc(Code,2);
                            IF not GetModRmString(Code,mem,reg,1) THEN goto accerr;
                            result:=SetStrings[b]+' '+reg;
                            goto ex;
                       END
                       ELSE goto ex;
                  END;
                  ELSE goto ex;
              END; {case}
              inc(Code);
              IF not MemoryValid(Code,1) THEN goto accerr;
              goto again;
         END;
         _Other:
         BEGIN
              i:=OpCodeRec[b].Index;
              inc(Code);
              {$IFDEF WIN32}
              inc(OldCode);
              {$ENDIF}
              CASE i OF
                 T_PUSH_IMM16:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='PUSH ';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='PUSHL ';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_PUSH_IMM8:
                 BEGIN
                      result:='PUSH ';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_TEST_MEM_R8:IF GetModRmString(Code,mem,reg,1) THEN result:='TEST '+mem+','+reg
                               ELSE goto accerr;
                 T_TEST_MEM_R16:IF GetModRmString(Code,mem,reg,2) THEN result:='TEST '+mem+','+reg
                                ELSE goto accerr;
                 T_XCHG_MEM_R8:IF GetModRmString(Code,mem,reg,1) THEN result:='XCHG '+mem+','+reg
                               ELSE goto accerr;
                 T_XCHG_MEM_R16:IF GetModRmString(Code,mem,reg,2) THEN result:='XCHG '+mem+','+reg
                                ELSE goto accerr;
                 T_MOV_MEM_R8:IF GetModRmString(Code,mem,reg,1) THEN result:='MOV '+mem+','+reg
                              ELSE goto accerr;
                 T_MOV_MEM_R16:IF GetModRmString(Code,mem,reg,2) THEN result:='MOV '+mem+','+reg
                               ELSE goto accerr;
                 T_MOV_R8_MEM:IF GetModRmString(Code,mem,reg,1) THEN result:='MOV '+reg+','+mem
                              ELSE goto accerr;
                 T_MOV_R16_MEM:IF GetModRmString(Code,mem,reg,2) THEN result:='MOV '+reg+','+mem
                               ELSE goto accerr;
                 T_MOV_MEM_SEG:;
                 T_LEA_R16_MEM:IF GetModRmString(Code,mem,reg,2) THEN result:='LEA '+reg+','+mem
                               ELSE goto accerr;
                 T_MOV_SEG_MEM:;
                 T_POP_MEM16:IF GetModRmString(Code,mem,reg,2) THEN result:='POP '+mem
                             ELSE goto accerr;
                 T_CALL_SEG_OFS:;
                 T_TEST_R8_IMM:
                 BEGIN
                      IF GetModRmString(Code,mem,reg,1) THEN
                      BEGIN
                           result:='TEST '+mem+',';
                           DispSize:=1;
                           goto imm;
                      END
                      ELSE goto accerr;
                 END;
                 T_TEST_R16_IMM:
                 BEGIN
                      IF GetModRmString(Code,mem,reg,2) THEN
                      BEGIN
                           result:='TEST '+mem+',';
                           IF Override66 THEN DispSize:=2
                           ELSE DispSize:=4;
                           goto imm;
                      END
                      ELSE goto accerr;
                 END;
                 T_MOV_AL_IMM:
                 BEGIN
                      result:='MOV AL,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_CL_IMM:
                 BEGIN
                      result:='MOV CL,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_DL_IMM:
                 BEGIN
                      result:='MOV DL,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_BL_IMM:
                 BEGIN
                      result:='MOV BL,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_AH_IMM:
                 BEGIN
                      result:='MOV AH,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_CH_IMM:
                 BEGIN
                      result:='MOV CH,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_DH_IMM:
                 BEGIN
                      result:='MOV DH,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_BH_IMM:
                 BEGIN
                      result:='MOV BH,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_MOV_AX_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV AX,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV EAX,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_MOV_CX_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV CX,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV ECX,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_MOV_DX_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV DX,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV EDX,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_MOV_BX_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV BX,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV EBX,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_MOV_SP_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV SP,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV ESP,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_MOV_BP_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV BP,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV EBP,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_MOV_SI_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV SI,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV ESI,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_MOV_DI_IMM:
                 BEGIN
                      IF Override66 THEN
                      BEGIN
                           result:='MOV DI,';
                           DispSize:=2;
                      END
                      ELSE
                      BEGIN
                           result:='MOV EDI,';
                           DispSize:=4;
                      END;
                      goto imm;
                 END;
                 T_RET_16:
                 BEGIN
                      result:='RETN32 ';
                      DispSize:=2;
                      goto imm;
                 END;
                 T_LES_AX_MEM:;
                 T_LDS_AX_MEM:;
                 T_MOV_MEM8_IMM:
                 BEGIN
                      IF GetModRmString(Code,mem,reg,1) THEN
                      BEGIN
                           result:='MOV '+mem+',';
                           DispSize:=1;
                           goto imm;
                      END
                      ELSE goto accerr;
                 END;
                 T_MOV_MEM16_IMM:
                 BEGIN
                      IF GetModRmString(Code,mem,reg,2) THEN
                      BEGIN
                           result:='MOV '+mem+',';
                           IF Override66 THEN DispSize:=2
                           ELSE DispSize:=4;
                           goto imm;
                      END
                      ELSE goto accerr;
                 END;
                 T_ENTER_W_B:;
                 T_RETF_16:
                 BEGIN
                      result:='RETF ';
                      DispSize:=2;
                      goto imm;
                 END;
                 T_INT_B:
                 BEGIN
                      result:='INT ';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_IN_AL_IMM:
                 BEGIN
                      result:='IN AL,';
                      DispSize:=1;
                      goto imm;
                 END;
                 T_IN_AX_IMM:
                 BEGIN
                      result:='IN AX,';
                      DispSize:=2;
                      goto imm;
                 END;
                 T_OUT_IMM_AL:;
                 T_OUT_IMM_AX:;
                 T_CALL:
                 BEGIN
                      result:='CALLN32 ';
                      ShortJmp:=FALSE;
                      Dec(Code);
                      {$IFDEF WIN32}
                      Dec(OldCode);
                      {$ENDIF}
                      goto Jmp;
                 END;
                 T_JMP:
                 BEGIN
                      result:='JMP ';
                      ShortJmp:=FALSE;
                      Dec(Code);
                      {$IFDEF WIN32}
                      Dec(OldCode);
                      {$ENDIF}
                      goto Jmp;
                 END;
                 T_JMP_SEG_OFS:;
                 T_TEST_MEM8_IMM:
                 BEGIN
                      IF GetModRmString(Code,mem,reg,1) THEN
                      BEGIN
                           result:='TEST '+mem+',';
                           DispSize:=1;
                           goto imm;
                      END
                      ELSE goto accerr;
                 END;
                 T_TEST_MEM16_IMM:
                 BEGIN
                      IF GetModRmString(Code,mem,reg,2) THEN
                      BEGIN
                           result:='TEST '+mem+',';
                           IF Override66 THEN DispSize:=2
                           ELSE DispSize:=4;
                           goto imm;
                      END
                      ELSE goto accerr;
                 END;
              END; {case}
         END;
         _Special:
         BEGIN
              i:=OpCodeRec[b].Index;
              inc(Code);
              IF not MemoryValid(Code,1) THEN goto accerr;
              b:=Code^[0]; {Store ModRmByte}
              DispSize:=0;
              CASE i OF
                  MEM8_IMM16,MEM16_IMM16,MEM8_IMM8,MEM16_IMM8:
                  BEGIN
                       IF i IN [MEM8_IMM16,MEM8_IMM8] THEN ok:=GetModRmString(Code,mem,reg,1)
                       ELSE ok:=GetModRmString(Code,mem,reg,2);
                       IF ok THEN
                       BEGIN
                            CASE i OF
                                MEM8_IMM16:DispSize:=2;
                                MEM16_IMM16:DispSize:=2;
                                MEM8_IMM8:DispSize:=1;
                                MEM16_IMM8:DispSize:=1;
                            END; {case}
                            IF DispSize=2 THEN IF not Override66 THEN DispSize:=4;

                            b:=(b SHR 3) AND 7;
                            s:=ModRmOperations[b];
                            IF mem[1]='[' THEN
                            BEGIN
                                 IF i IN [MEM8_IMM16,MEM8_IMM8] THEN s:=s+'B'
                                 ELSE IF Override66 THEN s:=s+'W'
                                 ELSE s:=s+'D';
                            END;
                            result:=s+' '+mem+',';
imm:
                            CASE DispSize OF
                               1:
                               BEGIN
                                    IF not MemoryValid(Code,1) THEN goto accerr;
                                    pb:=POINTER(Code);
                                    lw:=pb^;
                               END;
                               2:
                               BEGIN
                                    IF not MemoryValid(Code,2) THEN goto accerr;
                                    pw:=POINTER(Code);
                                    lw:=pw^;
                               END;
                               4:
                               BEGIN
                                    IF not MemoryValid(Code,4) THEN goto accerr;
                                    plw:=POINTER(Code);
                                    lw:=plw^;
                               END;
                            END; {case}
                            s:=tohex(lw);
                            inc(Code,DispSize);
                            Delete(s,1,1);   {Delete $}
                            IF DispSize=1 THEN Delete(s,1,6)
                            ELSE IF DispSize=2 THEN Delete(s,1,4);
                            result:=result+s;

                            IF DispSize=4 THEN IF pos('PUSHL',result)<>0 THEN
                            BEGIN
                                 i:=LONGINT(Code);  {End Address}
                                 i:=i-LONGINT(ActCPUDump^.Alias);
                                 i:=i+ActCPUDump^.StartAddr;
                                 s:=GetNameFromAddr(i,AddrData,lw);
                                 IF s<>'' THEN result:='PUSHL OFFSET('+s+')';
                            END;
                       END
                       ELSE goto accerr;
                  END;
                  INC_DEC_MEM8,INC_DEC_MEM16:
                  BEGIN
                       b:=b SHR 3 AND 7;

                       IF b IN [0,1] THEN
                       BEGIN
                            IF i=INC_DEC_MEM8 THEN
                            BEGIN
                                 IF not GetModRmString(Code,mem,reg,1) THEN goto accerr;
                            END
                            ELSE
                            BEGIN
                                 IF not GetModRmString(Code,mem,reg,2) THEN goto accerr;
                            END;

                            CASE b OF
                              0: {Inc}
                              BEGIN
                                   IF i=INC_DEC_MEM8 THEN result:='INC BYTE PTR '+mem
                                   ELSE
                                   BEGIN
                                        IF Override66 THEN result:='INC WORD PTR '+mem
                                        ELSE result:='INC DWORD PTR '+mem
                                   END;
                              END;
                              1: {Dec}
                              BEGIN
                                   IF i=INC_DEC_MEM8 THEN result:='DEC BYTE PTR '+mem
                                   ELSE
                                   BEGIN
                                        IF Override66 THEN result:='DEC WORD PTR '+mem
                                        ELSE result:='DEC DWORD PTR '+mem
                                   END;
                              END;
                            END;
                       END
                       ELSE
                       BEGIN
                            IF ((i=INC_DEC_MEM16)AND(b=4)) THEN //JMP Mem
                            BEGIN
                                 IF not GetModRmString(Code,mem,reg,2) THEN goto accerr;
                                 result:='JMP '+mem;
                            END
                            ELSE
                            BEGIN
                                IF ((i=INC_DEC_MEM16)AND(b=6)) THEN {PUSH MEM16}
                                BEGIN
                                     IF not GetModRmString(Code,mem,reg,2) THEN goto accerr;
                                     IF Override66 THEN result:='PUSH WORD PTR '+mem
                                     ELSE result:='PUSH DWORD PTR '+mem
                                END
                                ELSE Dec(Code);
                            END;
                       END;
                  END;
              END; {case}
         END;
         _Jmp:
         BEGIN
Jmp1:
              result:=JmpStrings[OpCodeRec[b].Index]+' ';
Jmp:
              inc(Code);
              {$IFDEF WIN32}
              inc(OldCode);
              {$ENDIF}
              IF ShortJmp THEN
              BEGIN
                   IF not MemoryValid(Code,1) THEN goto accerr;
                   pi:=POINTER(Code);
                   i:=pi^;
                   inc(Code,1);
                   {$IFDEF WIN32}
                   inc(OldCode,1);
                   {$ENDIF}
              END
              ELSE
              BEGIN
                   IF not MemoryValid(Code,4) THEN goto accerr;
                   pl:=POINTER(Code);
                   i:=pl^;
                   inc(Code,4);
                   {$IFDEF WIN32}
                   inc(OldCode,4);
                   {$ENDIF}
              END;
              s:=ToHex(i);
              Delete(s,1,1);   {Delete $}
              {$IFDEF OS2}
              i:=LONGINT(Code)+i;  {End Address}
              {$ENDIF}
              {$IFDEF WIN32}
              i:=LONGINT(OldCode)+i;
              {$ENDIF}
              i:=i-LONGINT(ActCPUDump^.Alias);
              i:=i+ActCPUDump^.StartAddr;
              result:=result+s+' [';
              s:=tohex(i);
              Delete(s,1,1);  {Delete $}
              result:=result+s+']';

              IF pos('CALLN32',result)<>0 THEN
              BEGIN
                   s:=GetNameFromAddr(i,AddrCode,i);
                   IF s<>'' THEN result:='CALLN32 '+s;
              END;
         END;
         _Nix:;
         _Copro:
         BEGIN
              IF b=$9b THEN
              BEGIN
                   result:='FWAIT';
                   inc(Code);
                   goto ex;
              END;
              b1:=b;
              IF not MemoryValid(Code,1) THEN goto accerr;
              b:=Code^[1];

              //Check operations with no operands
              CASE b1 OF
                 $D9:
                 BEGIN
                      CASE b OF
                         $D0:result:='FNOP';
                         $E0:result:='FCHS';
                         $E1:result:='FABS';
                         $E4:result:='FTST';
                         $E5:result:='FXAM';
                         $E8:result:='FLD1';
                         $E9:result:='FLDL2T';
                         $EA:result:='FLDL2E';
                         $EB:result:='FLDPI';
                         $EC:result:='FLDLG2';
                         $ED:result:='FLDLN2';
                         $EE:result:='FLDZ';
                         $F0:result:='F2XM1';
                         $F1:result:='FYL2X';
                         $F2:result:='FPTAN';
                         $F3:result:='FPATAN';
                         $F4:result:='FXTRACT';
                         $F5:result:='FPREM1';
                         $F6:result:='FDECSTP';
                         $F7:result:='FINCSTP';
                         $F8:result:='FPREM';
                         $F9:result:='FYL2XP1';
                         $FA:result:='FSQRT';
                         $FB:result:='FSINCOS';
                         $FC:result:='FRNDINT';
                         $FD:result:='FSCALE';
                         $FE:result:='FSIN';
                         $FF:result:='FCOS';
                      END; //case
                 END;
                 $DB:
                 BEGIN
                      CASE b OF
                         $E0:result:='FENI';
                         $E1:result:='FDISI';
                         $E2:result:='FCLEX';
                         $E3:result:='FINIT';
                         $E4:result:='FSETPM';
                      END; //case
                 END;
                 $DE:IF b=$D9 THEN result:='FCOMPP';
                 $DA:IF b=$E9 THEN result:='FUCOMPP';
                 $DF:IF b=$E0 THEN result:='FSTSW AX';
              END; //case

              IF result[1]<>'?' THEN
              BEGIN
                   inc(Code,2);
                   goto ex;
              END;

              //Check operatons with one register operand
              CASE b1 OF
                 $D8:
                 BEGIN
                      if b AND $D8=$D8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FCOMP ST('+tostr(b)+')';
                      END
                      ELSE if b AND $D0=$D0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FCOM ST('+tostr(b)+')';
                      END;
                 END;
                 $D9:
                 BEGIN
                      if b AND $C8=$C8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FXCH ST('+tostr(b)+')';
                      END
                      ELSE if b AND $C0=$C0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FLD ST('+tostr(b)+')';
                      END;
                 END;
                 $DD:
                 BEGIN
                      if b AND $E8=$E8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FUCOMP ST('+tostr(b)+')';
                      END
                      ELSE if b AND $E0=$E0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FUCOM ST('+tostr(b)+')';
                      END
                      ELSE if b AND $D8=$D8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FSTP ST('+tostr(b)+')';
                      END
                      ELSE if b AND $D0=$D0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FST ST('+tostr(b)+')';
                      END
                      ELSE if b AND $C0=$C0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FFREE ST('+tostr(b)+')';
                      END;
                 END;
              END; //case

              IF result[1]<>'?' THEN
              BEGIN
                   inc(Code,2);
                   goto ex;
              END;

              //Check operations with two register operands
              CASE b1 OF
                 $DE:  //FADDP ST(i),ST FDIVRP ST(i),ST FDIVP ST(i),ST
                 BEGIN
                      if b AND $F8=$F8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FDIVP ST('+tostr(b)+'),ST';
                      END
                      ELSE if b AND $F0=$F0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FDIVRP ST('+tostr(b)+'),ST';
                      END
                      ELSE if b AND $E0=$E0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FSUBRP ST('+tostr(b)+'),ST';
                      END
                      ELSE if b AND $C8=$C8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FMULP ST('+tostr(b)+'),ST';
                      END
                      ELSE IF b AND $C0=$C0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FADDP ST('+tostr(b)+'),ST';
                      END;
                 END;
                 $DC:  //FADD ST(i),ST FDIV ST(i),ST FDIVR ST(i),ST
                 BEGIN
                      if b AND $F8=$F8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FDIV ST('+tostr(b)+'),ST';
                      END
                      ELSE if b AND $F0=$F0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FDIVR ST('+tostr(b)+'),ST';
                      END
                      ELSE if b AND $E8=$E8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FSUB ST('+tostr(b)+'),ST';
                      END
                      ELSE if b AND $E0=$E0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FSUBR ST('+tostr(b)+'),ST';
                      END
                      ELSE if b AND $C8=$C8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FMUL ST('+tostr(b)+'),ST';
                      END
                      ELSE IF b AND $C0=$C0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FADD ST('+tostr(b)+'),ST';
                      END;
                 END;
                 $D8:  //FADD ST,ST(i) FDIV ST,ST(i) FDIVR ST,ST(i)
                 BEGIN
                      if b AND $F8=$F8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FDIVR ST,ST('+tostr(b)+')';
                      END
                      ELSE if b AND $F0=$F0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FDIV ST,ST('+tostr(b)+')';
                      END
                      ELSE if b AND $E8=$E8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FSUBR ST,ST('+tostr(b)+')';
                      END
                      ELSE if b AND $E0=$E0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FSUB ST,ST('+tostr(b)+')';
                      END
                      ELSE if b AND $C8=$C8 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FMUL ST,ST('+tostr(b)+')';
                      END
                      ELSE IF b AND $C0=$C0 THEN
                      BEGIN
                           b:=b AND 7;
                           result:='FADD ST,ST('+tostr(b)+')';
                      END;
                 END;
              END; //case

              IF result[1]<>'?' THEN
              BEGIN
                   inc(Code,2);
                   goto ex;
              END;

              //check memory operations
              inc(Code);
              CASE b1 OF
                 $D8,$DC:
                 BEGIN
                      IF b AND $38=$38 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FDIVR';
                      END
                      ELSE IF b AND $30=$30 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FDIV';
                      END
                      ELSE IF b AND $28=$28 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FSUBR';
                      END
                      ELSE IF b AND $20=$20 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FSUB';
                      END
                      ELSE IF b AND $18=$18 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FCOMP';
                      END
                      ELSE IF b AND $10=$10 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FCOM';
                      END
                      ELSE IF b AND $08=$08 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FMUL';
                      END
                      ELSE IF b AND $38=0 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FADD';
                      END;

                      IF result[1]<>'?' THEN
                      BEGIN
                           IF b=$D8 THEN result:=result+' DWORD PTR '+mem
                           ELSE result:=result+' QWORD PTR '+mem;
                      END;
                 END;
                 $D9:
                 BEGIN
                      IF b AND $38=$38 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FSTCW '+mem;
                      END
                      ELSE IF b AND $30=$30 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FSTENV '+mem;
                      END
                      ELSE IF b AND $28=$28 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FLDCW '+mem;
                      END
                      ELSE IF b AND $20=$20 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FLDENV '+mem;
                      END
                      ELSE IF b AND $18=$18 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FSTP DWORD PTR '+mem;
                      END
                      ELSE IF b AND $10=$10 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FST DWORD PTR '+mem;
                      END
                      ELSE IF b AND $38=0 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FLD DWORD PTR '+mem;
                      END;
                 END;
                 $DD:
                 BEGIN
                      IF b AND $38=$38 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FSTSW '+mem;
                      END
                      ELSE IF b AND $30=$30 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FSAVE '+mem;
                      END
                      ELSE IF b AND $20=$20 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FRSTOR '+mem;
                      END
                      ELSE IF b AND $18=$18 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FSTP QWORD PTR '+mem;
                      END
                      ELSE IF b AND $10=$10 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FST QWORD PTR '+mem;
                      END
                      ELSE IF b AND $38=0 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FLD QWORD PTR '+mem;
                      END
                 END;
                 $DE,$DA:
                 BEGIN
                      IF b AND $38=$38 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FIDIVR';
                      END
                      ELSE IF b AND $30=$30 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FIDIV';
                      END
                      ELSE IF b AND $28=$28 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FISUBR';
                      END
                      ELSE IF b AND $20=$20 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FISUB';
                      END
                      ELSE IF b AND $18=$18 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FICOMP';
                      END
                      ELSE IF b AND $10=$10 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FICOM';
                      END
                      ELSE IF b AND $08=$08 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FIMUL';
                      END
                      ELSE IF b AND $38=0 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN result:='FIADD';
                      END;

                      IF result[1]<>'?' THEN
                      BEGIN
                           IF b=$DE THEN result:=result+' WORD PTR '+mem
                           ELSE result:=result+' DWORD PTR '+mem;
                      END;
                 END;
                 $DF:
                 BEGIN
                      IF b AND $38=$38 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FISTP QWORD PTR '+mem;
                      END
                      ELSE IF b AND $30=$30 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FBSTP TBYTE PTR '+mem;
                      END
                      ELSE IF b AND $28=$28 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FILD QWORD PTR '+mem;
                      END
                      ELSE IF b AND $20=$20 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FBLD TBYTE PTR '+mem;
                      END
                      ELSE IF b AND $18=$18 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FISTP WORD PTR '+mem;
                      END
                      ELSE IF b AND $10=$10 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FIST WORD PTR '+mem;
                      END
                      ELSE IF b AND $38=0 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FILD WORD PTR '+mem;
                      END;
                 END;
                 $DB:
                 BEGIN
                      IF b AND $38=$38 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FSTP TBYTE PTR '+mem;
                      END
                      ELSE IF b AND $20=$20 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FLD TBYTE PTR '+mem;
                      END
                      ELSE IF b AND $18=$18 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FISTP DWORD PTR '+mem;
                      END
                      ELSE IF b AND $10=$10 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FIST DWORD PTR '+mem;
                      END
                      ELSE IF b AND $38=0 THEN
                      BEGIN
                           IF GetModRmString(Code,mem,reg,1) THEN
                              result:='FILD DWORD PTR '+mem;
                      END;
                 END;
              END; //Case

              IF result[1]<>'?' THEN goto ex;

              //check special instuctions
         END;
     END; {case}
ex:
     IF result[1]='?' THEN Code:=SaveCode;
     Len:=LONGINT(Code)-LONGINT(SaveCode);
     {$IFDEF WIN32}
     FreeMem(p,16);
     {$ENDIF}
END;

FUNCTION RangeDisAsm(Max,Code:PCodePointer;VAR Len:LONGINT;VAR s:STRING):BOOLEAN;
BEGIN
     result:=FALSE;
     WHILE Code<Max DO
     BEGIN
          s:=DisAssemble_Code(Code,Len);
          IF s[1]='?' THEN exit;
          Inc(Code,Len);
          IF Code=Max THEN
          BEGIN
               result:=TRUE;
               exit;
          END;
     END;
END;

FUNCTION DisAssembleBack(Code:PCodePointer;VAR Len:LONGINT;Dump:PCpuDump):STRING;
VAR MaxAddress:PCodePointer;
    t:LONGINT;
BEGIN
     MaxAddress:=Code;
     result:='???';
     ActCPUDump:=Dump;

     FOR t:=32 DOWNTO 1 DO
     BEGIN
          Code:=MaxAddress;
          dec(Code,t);
          IF Code<Dump^.Alias THEN Code:=Dump^.Alias;
          IF RangeDisAsm(MaxAddress,Code,Len,result) THEN exit;
     END;

     IF result[1]='?' THEN
     BEGIN
          Code:=MaxAddress;
          dec(Code);
          IF MemoryValid(Code,1) THEN
          BEGIN
               result:=ToHex(Code^[0]);
               delete(result,1,7);
               result:='DB '+result;
               Len:=1;
          END;
     END;
END;

FUNCTION DisAssemble(Code:PCodePointer;VAR Len:LONGINT;Dump:PCpuDump):STRING;
VAR s:STRING;
BEGIN
     ActCPUDump:=Dump;
     result:=DisAssemble_Code(Code,Len);
     IF result[1]='?' THEN IF MemoryValid(Code,1) THEN
     BEGIN
          s:=ToHex(Code^[0]);
          delete(s,1,7);
          result:='DB '+s;
          Len:=1;
     END;
END;

BEGIN
     CPUDumpList.Create;
     CPUList.Create;
     SourceFilesList.Create;
END.

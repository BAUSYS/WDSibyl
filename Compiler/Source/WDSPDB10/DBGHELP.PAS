
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
                
UNIT DbgHelp;
                       
INTERFACE                                                                

Uses Dos,Classes, SysUtils, uSysClass;

{$IFDEF OS2}
USES Os2Def,BseDos,BseExcpt,PmWin;
{$ENDIF}

{$IFDEF WIN32}
USES WinBase,WinUser,WinNT;

TYPE
    PID=LongWord;
    TID=LongWord;
    ULONG=LongWord;
    HModule=LongWord;
    HWnd=LongWord;
    HEV=LongWord;
    HAB=LongWord;
    HMQ=LongWord;

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

VAR DebugEvent:DEBUG_EVENT;
{$ENDIF}


TYPE
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
                        SymbolName:^STRING;    {ProcName or SymbolName}
                        Typ:WORD;              {ResultType or SymbolType}
                        TypOffset:LONGINT;     {Offset in type table}
                        OffsetTyp:BYTE;        {04-EBP 05-VAR Para EBP}
                        Offset:LONGINT;        {Offset proc or Offset relative to EBP}
                        Len:ULONG;             {Length of Proc}
                        Symbols:PSymbolsInfo;  {Symbole fr Proc}
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
                          MTE:HMODULE;
                          Name:STRING;
                          Objects:PObjectList;
                          DebugModules:PModuleInfo;
                          Next:PModulesLoaded;
                    END;

VAR
   VMTCallAddr:ULONG;
   {$IFDEF WIN32}
   ExceptionListAddr:ULONG;
   WatchPtCount:LongWord;
   ProcessDebuggedAddr:ULONG;
   {$ENDIF}
   ModuleInfo:PModuleInfo;
   ProcTermResult:LONGWORD;
   DbgAppType:LONGWORD;
   ModulesLoaded:PModulesLoaded;
   ObjectBuffer:STRING;
   SessHandle,SessThreadHandle:LongWord;
   SessTID:TID;
   SessID:LONGWORD;
   SessPID:PID;
   DbgBuf:TDbgBuf;
   ServerHwnd,ServerFrameWin:HWND;
   Serverhmq,ServerHab:LONGWORD;
   WatchHwnd,WatchFrame:HWND;
   RegHWnd,RegFrame:HWND;
   ProjectHwnd,ProjectFrame:HWND;
   DebuggeeName:STRING;
   DebuggeeArgs:STRING;
   WaitSem:HEV;
   StartCS,StartEIP,StartEIPLinear:ULONG;
   StartEIPSourceLine:LONGWORD;
   StartEIPSourceFile:STRING;
   WorkThreadID:TID;
   BreakAtStart:BOOLEAN;
   BreakAtStartTyp:BYTE;
   BreakAtStartAddr:ULONG;
   {$IFDEF OS2}
   DesktopSWP:SWP;
   {$ENDIF}

CONST
     {Values for DebugMode}
     Dbg_Mode_LinesOnly =1;  {Single step only through line numbers}
     Dbg_Mode_All       =2;  {Single step regardless}

VAR
    LastExcptTID:LONGWORD;  {only if Notification=DBG_N_EXCEPTION}
    LastExcptAddr:LONGWORD; {only if Notification=DBG_N_EXCEPTION}
    LastExcptLine:WORD;     {only if Notification=DBG_N_EXCEPTION}
    LastExcptSource:STRING; {only if Notification=DBG_N_EXCEPTION}
    DebugMode:BYTE;
    Postmode:BYTE;

    Log : tcLog;

{next Actions}
CONST
     A_WAITSEM   =1;
     A_CONTINUE  =2;
     A_RETRYXCPT =4;
     A_RUNXCPT   =8;
     A_ABORTXCPT =16;

CONST RetryTheExcept:BOOLEAN=FALSE;

VAR RetryExceptRegBuf:TDbgBuf;
    RetryExceptCoproBuf:TCoproBuf;

{Extra Notifications}
CONST
     DBG_N_SSTEPCOMPLETED =1;

{Extra commands}
CONST
     DBG_C_STEPINTO       =100;

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

VAR DbgReturn:DebugReturn;

TYPE PBreakPoints=^TBreakPoints;
     TBreakPoints=RECORD
                        LinearAddr:ULONG;
                        Typ:BYTE;
                        OldOpCode:WORD;
                        Next:PBreakPoints;
                  END;

VAR BreakPoints:PBreakPoints;

TYPE PLocalVars=^TLocalVars;
     TLocalVars=RECORD
                      Name:STRING;
                      Next:PLocalVars;
                END;


TYPE PSymBuffer=^TSymBuffer;
     TSymBuffer=ARRAY[0..655350] OF LONGWORD;

     PSymByteBuffer=^TSymByteBuffer;
     TSymByteBuffer=ARRAY[0..655350] OF BYTE;

VAR SymBuffer:PSymBuffer;
    SymBufferLen:LONGWORD;

VAR
    DebuggeeHwnd:HWND;
    DebuggeeClass:CSTRING;
    CoverFrameWin,CoverWin:HWND;
    CoverHab:HAB;
    CoverQueue:HMQ;
    CoverThreadID:TID;
    CoverCreated:BOOLEAN;
    NextDbgBreakAddr:ULONG;
    NextDbgBreakTyp:ULONG;

TYPE
    PTypeList=^TTypeList;
    TTypeList=RECORD
                    Name:^STRING;
                    Value:^STRING;
                    Typ:BYTE;
                    Next:PTypeList;
              END;

FUNCTION GetLocalVars(VAR ActualProc:STRING):PLocalVars;
PROCEDURE FreeLocalVars(p:PLocalVars);
FUNCTION GetBreakPoints:PBreakPoints;
PROCEDURE DebugCommand(Command:LONGINT;msg:STRING);
PROCEDURE DebuggerFatalError(Msg:STRING);
FUNCTION StartDebuggee(ProcessName,CMDBuf:STRING):BOOLEAN;
PROCEDURE PostAndWaitMsg(Msg:LONGINT;s:STRING);
FUNCTION GetModulesLoaded:PModulesLoaded;
FUNCTION GetModuleInfo:PModuleInfo;
PROCEDURE SetStartBreakPoint(Typ:BYTE);
PROCEDURE SetBreakAtStartAddr(Addr:ULONG);
PROCEDURE SetNextDbgBrk(Adress:ULONG;Typ:BYTE);
PROCEDURE GetNextDbgBrkInfo(VAR Adress:ULONG;VAR Typ:BYTE);
FUNCTION GetNextDbgBrk:ULONG;
FUNCTION GetValueFromExpr(Expr:STRING;VAR Value:STRING;
              VAR EXEAddr:ULONG;VAR ValueLen:ULONG;VAR ValueTyp:BYTE;MakeTypeList:BOOLEAN):BOOLEAN;
FUNCTION GetTypeInfoFromExpr(Expr:STRING;VAR EXEAddr:ULONG;VAR ValueTyp:BYTE):PTypeList;
PROCEDURE FreeTypeList;
FUNCTION SetValueFromExpr(NewValue:STRING;EXEAddr:ULONG;
                          Len:ULONG;Typ:BYTE):BOOLEAN;

PROCEDURE SetWatchHwnd(w,f:HWND);
PROCEDURE SetRegHwnd(w,f:HWND);
PROCEDURE SetProjectHwnd(w,f:HWND);

{Set Breakpoint at linear address}
FUNCTION SetBreakPoint(Address:ULONG;Typ:BYTE):BOOLEAN;
{Delete Breakpoint at linear address}
FUNCTION UnsetBreakPoint(Address:ULONG;VAR BreakSource:BYTE):BOOLEAN;
{Set Breakpoint at line}
FUNCTION SetBreakPointLine(Source:STRING;Line:WORD;Typ:BYTE;VAR Adress:ULONG):BOOLEAN;
{Get adress from line}
FUNCTION GetAdressFromLine(Source:STRING;Line:WORD;VAR adress:ULONG):BOOLEAN;
{Notification DBG_N_MODULELOAD}
FUNCTION IsBreakPointLine(Source:STRING;Line:WORD;Typ:BYTE;
                          VAR Adress:ULONG):BOOLEAN;
PROCEDURE HandleModuleLoad;
{Notification DBG_N_THREADCREATE}
PROCEDURE HandleThreadCreate;
{Initialize start EIP and symbol buffer}
FUNCTION GetDebugInfo(name:STRING):BOOLEAN;
{Fill symbol structures - called when first thread is created}
PROCEDURE FillSymbolLists;
{Searches source and line num from linear address}
PROCEDURE SearchLineNum(LinearAddr:ULONG;IncClosest:BOOLEAN;
                        VAR Source:STRING;VAR Line:WORD;
                        VAR Module:PModuleInfo);
{Reads register set}
FUNCTION GetRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;
{Writes register set}
FUNCTION PutRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;
{Reads copro register set}
FUNCTION GetCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;
{Writes register set}
FUNCTION PutCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;
{Delete work thread}
PROCEDURE DeleteWorkThread(Destroy:BOOLEAN);
{Loads debuggee}
FUNCTION DebugLoad(s,param:STRING;CPUAvailProc:POINTER;
                   ahwnd,hwndFrame:HWND;
                   ahmq,ahab:LONGWORD):BOOLEAN;
{Unloads debuggee}
PROCEDURE DebugUnload;
{Handled notifications}
FUNCTION HandleNotifications:Boolean;
{Creates Event Semaphore}
PROCEDURE CreateEventSem;
{Post semaphore}
PROCEDURE PostEventSem;
{Sets next action}
PROCEDURE SetNextAction(Action:BYTE);
{Gets debugger return notification}
PROCEDURE GetDebugReturn(VAR ret:DebugReturn);
PROCEDURE Dummy;
FUNCTION GetProcTermResult:LONGWORD;
FUNCTION GetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN;
FUNCTION SetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN;
PROCEDURE LockInput(DbgHwnd:HWND);
PROCEDURE UnlockInput;
FUNCTION IssueDebugCommand(VAR Buf:TDbgBuf):BOOLEAN;
PROCEDURE GetLineFromEIP(LinearAddr:ULONG;IncClosest:BOOLEAN;
                         VAR Source:STRING;VAR Line:WORD;
                         Module:PModuleInfo);
FUNCTION GetBreakPointOp(Address:ULONG;VAR OldOp:BYTE):BOOLEAN;
FUNCTION GetNearestProc(EIP:LONGWORD):STRING;
FUNCTION SetWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN;
FUNCTION ClearWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN;
FUNCTION DbgLineAvail(CONST Source:STRING;Line:LongWord):BOOLEAN;
PROCEDURE DbgSetExceptions(RTL,SPCC:LONGWORD);
PROCEDURE GetAdressFromName(s,s1:STRING;VAR value:ULONG);
PROCEDURE SetOptions(Options:LONGWORD);
FUNCTION DebugStop(Dummy:LONGINT):LONGINT;
FUNCTION DebugRun(dummy:LONGINT):LONGINT;
FUNCTION DebugStepInto(Dummy:LONGINT):LONGINT;
FUNCTION DebugSingleStep(Dummy:LONGINT):LONGINT;
FUNCTION MainLoop(Command:LONGINT):LONGINT;

TYPE
    TAddrType=(AddrCode,AddrData,AddrLocal);

FUNCTION GetNameFromAddr(Addr:LONGWORD;Typ:TAddrType;Offset:LONGINT):STRING;

{$IFDEF WIN32}
Function DosDebug(Var Buf:TDBGBuf):LongInt;
{$ENDIF}

VAR IsCPUAvail:FUNCTION:BOOLEAN;

IMPLEMENTATION

Procedure LogWriteln(txt : String);

Begin
  if Log<>nil then Log.Writeln(txt);
End;

{$IFDEF WIN32}
Function DosDebug(Var Buf:TDBGBuf):LongInt;
Var 
    CX: Context;
    Res:Boolean;
    Code:LongWord;
    DR7Type:LongWord;
    Count:LongWord;
Type
  PDRs=^TDRs;
  TDRs=Array[0..3] Of LongWord;
Var
  aPDRS:PDRs;
Label go;
Begin
     Result:=DBG_N_SUCCESS;
     DebugEvent.dwDebugEventCode:=0;
     logWriteln('DosDebug:'+tostr(Buf.Cmd));
     Case Buf.Cmd Of
         DBG_C_Null:;
         DBG_C_ReadMem: {Read Word}
         Begin
           LogWriteln('  ReadMem');
           if not ReadProcessMemory(SessHandle,Pointer(Buf.Addr),Buf.Value,2,Nil) then Result := DBG_N_ERROR;
         End;
         DBG_C_ReadReg:             { Read Register Set            }
         Begin
           LogWriteln('  ReadReg');
           CX.ContextFlags := CONTEXT_FULL;
           If Buf.TID=0 Then Buf.TID:=SessThreadHandle;
           If GetThreadContext(Buf.TID,CX)=False Then Result:=DBG_N_ERROR
             Else
               Begin
                   FillChar(Buf,Sizeof(Buf),0);
                   With Buf Do
                   Begin
                        GS:=CX.SegGs;
                        FS:=CX.SegFs;
                        ES:=CX.SegEs;
                        DS:=CX.SegDs;
                        EDI:=CX.Edi;
                        ESI:=CX.Esi;
                        EBX:=CX.Ebx;
                        EDX:=CX.Edx;
                        ECX:=CX.Ecx;
                        EAX:=CX.Eax;
                        EBP:=CX.Ebp;
                        EIP:=CX.Eip;
                        CS:=CX.SegCs;
                        EFlags:=CX.EFlags;
                        ESP:=CX.Esp;
                        SS:=CX.SegSs;
                   End;
              End;
         End;
         DBG_C_WriteMem:              { Write Word                   }
         Begin
           LogWriteln('  WriteMem');
           if not WriteProcessMemory(SessHandle,Pointer(Buf.Addr),Buf.Value,2,Nil) then Result := DBG_N_ERROR;
         End;
         DBG_C_WriteReg:      { Write Register Set           }
         Begin
           LogWriteln('  WriteReg');
            With Buf Do
              Begin
                   CX.ContextFlags := CONTEXT_FULL;
                   CX.SegGs := GS;
                   CX.SegFs := FS;
                   CX.SegEs := ES;
                   CX.SegDs := DS;
                   CX.Edi := EDI;
                   CX.Esi := ESI;
                   CX.Ebx := EBX;
                   CX.Edx := EDX;
                   CX.Ecx := ECX;
                   CX.Eax := EAX;
                   CX.Ebp := EBP;
                   CX.Eip := EIP;
                   CX.SegCs := CS;
                   CX.EFlags := EFlags;
                   CX.Esp := ESP;
                   CX.SegSs := SS;
              End;
              If Buf.TID=0 Then Buf.TID:=SessThreadHandle;
              If SetThreadContext(Buf.Tid,CX)=False Then Result:=DBG_N_ERROR;
         End;
         DBG_C_Go:      { Go                           }
         Begin
           LogWriteln('  Go');
           Code:=dbg_Continue;
go:
           Res:=ContinueDebugEvent(SessPID,SessTID,Code);
           Code:=dbg_Continue;
           Res:=True;
           If Res Then
           Begin
             LogWriteln('  Go: WaitForDebugEvent');
             If WaitForDebugEvent(DebugEvent, Infinite) Then
               Begin
                 LogWriteln('  Go: WaitForDebugEvent:'+tostr(DebugEvent.dwDebugEventCode));
                 Case DebugEvent.dwDebugEventCode Of
                   EXCEPTION_DEBUG_EVENT:Result:=DBG_N_EXCEPTION;
                   CREATE_THREAD_DEBUG_EVENT:Result:=DBG_N_THREADCREATE;
                   CREATE_PROCESS_DEBUG_EVENT:Result:=DBG_N_NEWPROC;
                   EXIT_THREAD_DEBUG_EVENT:Result:=DBG_N_THREADTERM;
                   EXIT_PROCESS_DEBUG_EVENT:Result:=DBG_N_PROCTERM;
                   LOAD_DLL_DEBUG_EVENT:Result:=DBG_N_MODULELOAD;
                   UNLOAD_DLL_DEBUG_EVENT:Result:=DBG_N_MODULEFREE;
                   OUTPUT_DEBUG_STRING_EVENT:Result:=DBG_N_SUCCESS;
                   RIP_EVENT:
                     Begin
                       //ErrorBox2('RIP Event for PID:'+tohex(SessPID)+' TID:'+tohex(SessTID));
                       Result:=DBG_N_ERROR;
                     End;
                   Else Result:=DBG_N_SUCCESS;
                 End; //case
               End
             Else
               Begin
                 //ErrorBox2('Error while WaitForDebugEvent for PID:'+tohex(SessPID)+' TID:'+tohex(SessTID));
                 Result:=DBG_N_ERROR;
               End;
             LogWriteln('  Go: WaitForDebugEvent-nach-if');
           End
           Else
           Begin
                //ErrorBox2('Error while ContinueDebugEvent for PID:'+tohex(SessPID)+' TID:'+tohex(SessTID));
             Result:=DBG_N_ERROR;
           End;
         End;
         DBG_C_Term:    { Terminate                    }
         Begin
           LogWriteln('  Terminate');
           CX.ContextFlags := CONTEXT_CONTROL;
           GetThreadContext(SessThreadHandle, CX);
           CX.EIP := Longint(GetProcAddress(GetModuleHandle('kernel32.dll'), 'ExitProcess'));
           SetThreadContext(SessThreadHandle, CX);
           Code:=dbg_Continue;
           goto go;
         End;
         DBG_C_SStep:   { Single Step                  }
         Begin
           LogWriteln('  SingleStep');
           If Buf.TID=0 Then Buf.TID:=SessThreadHandle;
           CX.ContextFlags:=CONTEXT_CONTROL;
           GetThreadContext(Buf.TID,CX);
           CX.EFlags:=CX.EFlags or $0100; // Set Trap Flag
           SetThreadContext(Buf.TID, CX);
           Code:=dbg_Continue;
           goto go;
         End;
         DBG_C_Stop:    { Stop                         }
         Begin
           LogWriteln('  Stop');
         End;
         DBG_C_Freeze:  { Freeze Thread                }
         Begin
           LogWriteln('  Freeze Thread');
         End;
         DBG_C_Resume:    { Resume Thread                }
         Begin
           LogWriteln('  Resume Thread');
         End;
         DBG_C_NumToAddr:    { Object Number to Address     }
         Begin
           LogWriteln('  Object Number to Address ');
         End;
         DBG_C_ReadCoRegs:   { Read Coprocessor Registers   }
         Begin
           LogWriteln('  Read Coprocessor Registers');
           CX.ContextFlags := CONTEXT_FLOATING_POINT;
           If Buf.TID=0 Then Buf.TID:=SessThreadHandle;
           If GetThreadContext(Buf.TID,CX)=False Then Result:=DBG_N_ERROR
           Else Move(CX.FloatSave,Pointer(Buf.Buffer)^,108);
         End;
         DBG_C_WriteCoRegs:  { Write Coprocessor Registers  }
         Begin
           LogWriteln('  Write Coprocessor Registers');
           FillChar(CX, SizeOf(CX), 0);
           CX.ContextFlags := CONTEXT_FLOATING_POINT;
           Move(Pointer(Buf.Buffer)^,CX.FloatSave,108);
           If Buf.TID=0 Then Buf.TID:=SessThreadHandle;
           If SetThreadContext(Buf.Tid,CX)=False Then Result:=DBG_N_ERROR;
         End;
         DBG_C_ThrdStat:    { Get Thread Status            }
         Begin
           LogWriteln('  Get Thread Status');
         End;
         DBG_C_MapROAlias:    { Map read-only alias          }
         Begin
           LogWriteln('  Map read-only alias');
           Buf.Buffer:=Buf.Addr;
         End;
         DBG_C_MapRWAlias:   { Map read-write alias         }
         Begin
           LogWriteln('  Map read-write alias ');
         End;
         DBG_C_UnMapAlias:   { Unmap Alias                  }
         Begin
           LogWriteln('  Unmap Alias');
         End;
         DBG_C_Connect:     { Connect to Debuggee          }
         Begin
           LogWriteln('  Connect to Debuggee');
         End;
         DBG_C_ReadMemBuf:  { Read Memory Buffer           }
         Begin
           LogWriteln('  Read Memory Buffer');
           if not ReadProcessMemory(SessHandle,Pointer(Buf.Addr),Pointer(Buf.Buffer)^,Buf.Len,Nil) then Result := 1;
         End;
         DBG_C_WriteMemBuf:    { Write Memory Buffer          }
         Begin
           LogWriteln('  Write Memory Buffer');
           if not WriteProcessMemory(SessHandle,Pointer(Buf.Addr),Pointer(Buf.Buffer)^,Buf.Len,Nil) then Result := 1;
         End;
         DBG_C_SetWatch:     { Set Watchpoint               }
         begin
           LogWriteln('  Set Watchpoint ');
           If WatchPtCount=4 Then Result:=DBG_N_ERROR
           Else
           Begin
               FillChar(CX,sizeof(CX),0);
               CX.ContextFlags := CONTEXT_DEBUG_REGISTERS;
               If Buf.TID=0 Then Buf.TID:=SessThreadHandle;
               If GetThreadContext(Buf.TID,CX)=False Then Result:=DBG_N_ERROR
               Else
               Begin
                    CX.DR7:=CX.DR7 And $ffff00ff;
                    CX.DR7:=CX.DR7 Or $00000100;
                    //ErrorBox2('Before DR0:'+tohex(CX.DR0)+' DR7:'+tohex(CX.DR7));

                    If (Buf.Value And $30000)<>0 Then DR7Type:=3 //read write
                    Else If (Buf.Value And $10000)<>0 Then DR7Type:=0 //execute
                    Else DR7Type:=1; //write
                    aPDRs:=@CX.DR0;
                    aPDRs^[WatchPtCount]:=Buf.Addr;
                    Count:=WatchPtCount*4;
                    CX.DR7:=(CX.DR7 and not ($0F shl (16 + (Count))));
                    CX.DR7:=CX.DR7 or ($0001 shl (WatchPtCount*2));
                    CX.DR7:=CX.DR7 or (DR7Type shl (16 + Count));
                    CX.DR7:=CX.DR7 or ((Buf.Len-1) shl (18 + Count));

                    //ErrorBox2('Modified DR0:'+tohex(CX.DR0)+' DR7:'+tohex(CX.DR7));

                    If SetThreadContext(Buf.TID,CX)=False Then Result:=DBG_N_ERROR
                    Else
                    Begin
                         inc(WatchPtCount);
                         DbgBuf.Index:=WatchPtCount;

                         If GetThreadContext(Buf.TID,CX)=False Then Result:=DBG_N_ERROR
                         Else
                         Begin
                              //ErrorBox2('After DR0:'+tohex(CX.DR0)+' DR7:'+tohex(CX.DR7));
                         End;
                    End;
               End;
           End;
         End;
         DBG_C_ClearWatch:   { Clear Watchpoint             }
         Begin
           LogWriteln('  Clear Watchpoint');
           If WatchPtCount=0 Then Result:=DBG_N_ERROR
           Else
           Begin
               CX.ContextFlags := CONTEXT_DEBUG_REGISTERS;
               If Buf.TID=0 Then Buf.TID:=SessThreadHandle;
               If GetThreadContext(Buf.TID,CX)=False Then Result:=DBG_N_ERROR
               Else
               Begin
                    dec(Buf.Index);
                    aPDRs:=@CX.DR0;
                    aPDRs^[Buf.Index] := 0;
                    CX.DR7:=CX.DR7 and not (($1 shl (Buf.Index*2)) or
                                            ($F shl (16 + (Buf.Index*4))));
                    If SetThreadContext(Buf.TID,CX)=False Then Result:=DBG_N_ERROR
                    Else
                    Begin
                         dec(WatchPtCount);
                         DbgBuf.Index:=WatchPtCount;
                    End;
               End;
           End;
         End;
         DBG_C_RangeStep:    { Range Step                   }
         Begin
           LogWriteln('  Range Step');
         End;
         DBG_C_Continue:     { Continue after an Exception  }
         Begin
           LogWriteln('  Continue after an Exception');
           Code:=dbg_Exception_Not_Handled;
           goto go;
         End;
         DBG_C_AddrToObject: { Address to Object            }
         Begin
           LogWriteln('  Address to Object');
           Buf.Buffer:=Buf.Addr;
           Buf.Len:=0;
           Buf.MTE:=0;
         End;
         DBG_C_XchgOpcode:   { Exchange opcode and go       }
         Begin
           LogWriteln('  Exchange opcode and go');
         End;
         DBG_C_LinToSel:   { 32 to 16 conversion      A001}
         Begin
           LogWriteln('  32 to 16 conversion      A001');
         End;
         DBG_C_SelToLin:   { }
         Begin
           LogWriteln('  16 to 32 conversion      A001');
         End;
         Else
           Begin
             LogWriteln('  Error');
             Result:=DBG_N_ERROR; //Error
           End;
     End; //case

     Buf.Cmd:=Result;
     If result<>DBG_N_ERROR Then Result:=0
     Else
     Begin
          Result:=GetLastError;
          If Result=0 Then Result:=DBG_N_ERROR;
     End;
End;
{$ENDIF}

VAR ShowAnsiRef:BOOLEAN;

CONST
     OPT_SHOWANSIREF =1;

PROCEDURE SetOptions(Options:LONGWORD);
BEGIN
  logWriteln('SetOptions'+toStr(Options));
  ShowAnsiRef:=Options AND OPT_SHOWANSIREF<>0;
END;

TYPE PWatchPoint=^TWatchPoint;
     TWatchPoint=RECORD
                     Address:LONGWORD;
                     Flags:LONGWORD;
                     Len:LONGWORD;
                     Id:LONGWORD;
                     Next:PWatchPoint;
                 END;

CONST WatchPoints:PWatchPoint=NIL;

PROCEDURE FreeWatchPoints;
VAR Next:PWatchPoint;
BEGIN
     WHILE WatchPoints<>NIL DO
     BEGIN
          Next:=WatchPoints^.Next;
          Dispose(WatchPoints);
          WatchPoints:=Next;
     END;
END;

VAR TypeList:PTypeList;
    LastTypeList:PTypeList;

PROCEDURE AddToTypeList(CONST Name,Value:STRING;Typ:BYTE);FORWARD;

FUNCTION GetValueFromCode(VAR variable,expr:STRING;Module:PModuleInfo;
                          Typ:WORD;VAR TypOffset:LONGINT;
                          VAR EXEAddr:ULONG;
                          VAR ValueLen:ULONG;
                          VAR ValueTyp:BYTE;Nested,MakeTypeList:BOOLEAN):STRING;FORWARD;

CONST InputLocked:BOOLEAN=FALSE;

PROCEDURE LockInput(DbgHwnd:HWND);
BEGIN
     IF InputLocked THEN exit;
     InputLocked:=TRUE;
     {$IFDEF OS2}
     IF DbgAppType=3 THEN WinLockInput(0,TRUE); {only for PM apps}
     WinSetSysModalWindow(HWND_DESKTOP,DbgHwnd);
     {WinSetFocus(HWND_DESKTOP,DbgHwnd);}
     WinSetSysModalWindow(HWND_DESKTOP,0);
     {$ENDIF}
END;

PROCEDURE UnlockInput;
BEGIN
     IF not InputLocked THEN exit;
     {$IFDEF OS2}
     IF DbgAppType=3 THEN WinLockInput(0,FALSE); {only for PM apps}
     {$ENDIF}
     InputLocked:=FALSE;
END;

PROCEDURE GetAdressFromName(s,s1:STRING;VAR value:ULONG);
VAR modules:PModuleInfo;
    publics:PPublicsInfo;
    ss:STRING;
BEGIN
     value:=0;
     IF s<>'' THEN s:=s+'.PAS';
     UpcaseStr(s);
     UpcaseStr(s1);
     modules:=ModuleInfo;
     WHILE modules<>NIL DO
     BEGIN
          IF ((s='')OR(modules^.sourcefile=s)) THEN
          BEGIN
               publics:=modules^.PublicsInfo;
               WHILE publics<>NIL DO
               BEGIN
                    ss:=Publics^.PublicName^;
                    UpcaseStr(ss);
                    IF ss=s1 THEN
                    BEGIN
                         value:=publics^.offset;
                         exit;
                    END;
                    publics:=publics^.next;
               END;
               exit;
          END;
          modules:=modules^.next;
     END;
END;

VAR PointerHided:BOOLEAN;

PROCEDURE ShowPointer;
BEGIN
     IF not PointerHided THEN exit;
     {$IFDEF OS2}
     WinShowPointer(HWND_DESKTOP,TRUE);
     {$ENDIF}
     PointerHided:=FALSE;
END;

PROCEDURE HidePointer;
BEGIN
     IF PointerHided THEN exit;
     {$IFDEF OS2}
     WinShowPointer(HWND_DESKTOP,FALSE);
     {$ENDIF}
     PointerHided:=TRUE;
END;

{Standard types}
CONST
     {This is NOT compatible to IPMD !}
     TT_SHORTINT    =$80; {like IPMD}
     TT_LONGINT     =$82; {like IPMD}
     TT_BYTE        =$84; {like IPMD}
     TT_WORD        =$85; {like IPMD}
     TT_LONGWORD    =$86; {like IPMD}
     TT_INTEGER     =$87; {like IPMD}
     TT_SINGLE      =$88; {like IPMD}
     TT_DOUBLE      =$89; {like IPMD}
     TT_REAL        =TT_DOUBLE;
     TT_EXTENDED    =$8a; {like IPMD}
     TT_STRING      =$8b; {not IPMD !}
     TT_CSTRING     =$8c; {not IPMD !}
     TT_PROC        =$8d; {not IPMD !}
     TT_VAR         =$8e; {like IPMD}
     TT_FILE        =$8f; {not IPMD !}
     TT_BOOLEAN     =$90; {like IPMD}
     TT_WORDBOOL    =$91; {like IPMD}
     TT_LONGBOOL    =$92; {like IPMD}
     TT_TEXT        =$93; {not IPMD !}
     TT_CHAR        =$94; {like IPMD}
     TT_POINTER     =$95; {not IPMD !}
     TT_ANSISTRING  =$96; {not IPMD !}
     TT_UNTYPED     =$97; {like IPMD !}

     TT_RECORD      =$F0;
     TT_OBJECT      =$F1;
     TT_SET         =$F2;

CONST
     SSTMODULES    =    $0101;
     SSTPUBLICS    =    $0102;
     SSTTYPES      =    $0103;
     SSTSYMBOLS    =    $0104;
     SSTSRCLINES   =    $0105;
     SSTLIBRARIES  =    $0106;
     SSTSRCLINES2  =    $0109;
     SSTSRCLINES32 =    $010B;

PROCEDURE CreateEventSem;
{$IFDEF WIN32}
Var SA:SECURITY_ATTRIBUTES;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     DosCreateEventSem(NIL,WaitSem,0,FALSE);
     {$ENDIF}
     {$IFDEF WIN32}
     SA.nLength:=sizeof(SA);
     SA.lpSecurityDescriptor:=Nil;
     SA.bInheritHandle:=True;
     WaitSem:=CreateEvent(SA,False,False,Nil);
     {$ENDIF}
END;

PROCEDURE PostEventSem;
BEGIN
  logWriteln('PostEventSem');
  {$IFDEF OS2}
  DosPostEventSem(WaitSem);
  {$ENDIF}
  {$IFDEF WIN32}
  SetEvent(WaitSem);
  {$ENDIF}
END;

PROCEDURE SetNextDbgBrk(Adress:ULONG;Typ:BYTE);
BEGIN
  logWriteln('SetNextDbfBrk');
  NextDbgBreakAddr:=Adress;
  NextDbgBreakTyp:=Typ;
END;

PROCEDURE GetNextDbgBrkInfo(VAR Adress:ULONG;VAR Typ:BYTE);
BEGIN
  logWriteln('GetNextDbgBrkInfo');
  Adress:=NextDbgBreakAddr;
  Typ:=NextDbgBreakTyp;
END;

FUNCTION GetNextDbgBrk:ULONG;
BEGIN
  logWriteln('GetNextDbgBrk');
  GetNextDbgBrk:=NextDbgBreakAddr;
END;


PROCEDURE SetNextAction(Action:BYTE);
BEGIN
  logWriteln('SetNextAction');
  {$IFDEF OS2}
  DosEnterCritSec;
  {$ENDIF}
  DbgReturn.NextAction:=Action;
  {$IFDEF OS2}
  DosExitCritSec;
  {$ENDIF}
END;

PROCEDURE GetDebugReturn(VAR ret:DebugReturn);
BEGIN
  logWriteln('GetDebugReturn');
  ret:=DbgReturn;
END;

FUNCTION GetModulesLoaded:PModulesLoaded;
BEGIN
  logWriteln('GetModulesLoaded');
  GetModulesLoaded:=ModulesLoaded;
END;

FUNCTION GetModuleInfo:PModuleInfo;
BEGIN
  logWriteln('GetModuleInfo');
  GetmoduleInfo:=ModuleInfo;
END;

PROCEDURE DeleteWorkThread(Destroy:BOOLEAN);
VAR result:ULONG;
BEGIN
  logWriteln('DeleteWorkThread');
  IF WorkThreadID=0 THEN exit; {No thread exists !}
  {When calling DosKillThread extrem care is recommended
   This should only be called when the thread is suspended}
  result:=1;
  {We try to kill the thread until it is no longer busy}
  {$IFDEF OS2}
  WHILE result<>0 DO result:=DosKillThread(WorkThreadID);
  {$ENDIF}
  {$IFDEF WIN32}
  CloseHandle(WorkThreadID);
  {$ENDIF}
  WorkThreadID:=0;
END;


PROCEDURE PostAndWaitMsg(Msg:LONGINT;s:STRING);
VAR
    rc:ULONG;
LABEL l1;
BEGIN
  logWriteln('PostAndWaitMsg');
  DbgReturn.msg:=Msg;

  IF PostMode=0 THEN exit;

  IF DbgAppType<>3 THEN goto l1;  {the following only for PM apps !}

l1:
  rc:=0;
  Dbgreturn.NextAction:=0;
  {ShowPointer;}  {Show pointer}
  WHILE rc=0 DO
  BEGIN
       {$IFDEF OS2}
       DosSleep(50);
       rc:=ULONG(WinPostMsg(Serverhwnd,WM_SEM1,LONGWORD(@s),0));
       {$ENDIF}
       {$IFDEF WIN32}
       Sleep(50);
       rc:=ULONG(PostMessage(Serverhwnd,WM_SEM1,LONGWORD(@s),0));
       {$ENDIF}
  END;

  rc:=0;
  REPEAT
       {$IFDEF OS2}
       DosSleep(50);
       {$ENDIF}
       {$IFDEF WIN32}
       Sleep(50);
       {$ENDIF}
       {inc(rc);}
  UNTIL ((DbgReturn.NextAction<>0)OR(rc>10));
  IF rc>10 THEN DbgReturn.nextAction:=A_CONTINUE;

  CASE Dbgreturn.NextAction OF
     A_WAITSEM:
     BEGIN
          {Wait for semaphore to be posted}
          {$IFDEF OS2}
          DosWaitEventSem(WaitSem,SEM_INDEFINITE_WAIT);
          DosCloseEventSem(WaitSem);
          {$ENDIF}
          {$IFDEF WIN32}
          WaitForSingleObject(WaitSem,INFINITE);
          CloseHandle(WaitSem);
          {$ENDIF}
     END;
  END; {case}
END;

PROCEDURE Dummy;
BEGIN
  logWriteln('Dummy');
END;

PROCEDURE DebugCommand(Command:LONGINT;msg:STRING);
VAR
   rc:LONGWORD;
BEGIN
  logWriteln('DebugCommand:'+tostr(Command));
  {$IFDEF OS2}
  DosSelectSession(SessPID);
  {$ENDIF}
  DbgBuf.Cmd := Command;
  DbgBuf.Pid := SessPID;
  ShowPointer;  {Show pointer}
  rc := DosDebug(DbgBuf);
  (*HidePointer;  {Hide pointer}
  WinSetPointerPos(HWND_DESKTOP,x,y);*)
  IF rc<>0 THEN DebuggerFatalError('Error while '+msg
                                   +' (Code:'+tostr(rc)+')');
  IF (DbgBuf.Cmd=DBG_N_ERROR) THEN
    DebuggerFatalError('Error while '+msg +' (Code:'+tostr(rc)+')');
END;                  

PROCEDURE DebuggerFatalError(Msg:STRING);
BEGIN
  logWriteln('DebugFatalError');
  PostAndWaitMsg(DBG_N_ERROR,'Fatal debugger error:'+msg);
END;

FUNCTION StartDebuggee(ProcessName,CMDBuf:STRING):BOOLEAN;
{$IFDEF OS2}
VAR
   aStartData:STARTDATA;
   rc:LONGWORD;
   c,c1:CSTRING;
{$ENDIF}
{$IFDEF WIN32}
VAR
   aStartData:STARTUPINFO;
   C,CMD:CString;
   ProcessInfo:PROCESS_INFORMATION;
   S :String;
   CX:CONTEXT;
   pd:LongWord;
   bo:Boolean;
{$ENDIF}
BEGIN
  LogWriteln('StartDebuggee');
  result:=FALSE;
  {$IFDEF OS2}
  c:=ProcessName;
  DosQueryAppType(c,DbgAppType);
  DbgAppType:=DbgAppType AND 3;
  aStartData.Length:=sizeof(STARTDATA);
  aStartData.Related:=SSF_RELATED_CHILD;
  aStartData.FgBg:=SSF_FGBG_BACK;
  aStartData.TraceOpt:=SSF_TRACEOPT_TRACE{ALL};
  aStartData.PgmTitle:=@c;
  aStartData.PgmName:=@c;  //ProcessName
  c1:=CmdBuf;
  aStartData.PgmInputs:=@c1;
  aStartData.TermQ:=NIL;
  aStartData.Environment:=NIL;
  aStartData.InheritOpt:=SSF_INHERTOPT_PARENT;
  aStartData.SessionType:=DbgAppType;
  aStartData.IconFile:=NIL;
  aStartData.PgmHandle:=0;
  aStartData.PgmControl:=SSF_CONTROL_VISIBLE;
  aStartData.InitXPos:=0;
  aStartData.InitYPos:=0;
  aStartData.InitXSize:=0;
  aStartData.InitYSize:=0;
  aStartData.Reserved:=0;
  aStartData.ObjectBuffer:=@ObjectBuffer;
  aStartData.ObjectBuffLen:=256;
  DosSelectSession(0);
  rc:=DosStartSession(aStartData,SessId,SessPid);
  IF rc<>0 THEN
    BEGIN
      result:=FALSE;
      DbgReturn.ErrStr:='DosStartSession error '+tostr(rc);
      exit;
    END;

  DosSelectSession(0);
  DbgBuf.Cmd := DBG_C_Connect;
  DbgBuf.Pid := SessPid;
  DbgBuf.Tid := 0;
  DbgBuf.Value := DBG_L_386;
  rc := DosDebug(DbgBuf);
  IF rc<>0 THEN
  BEGIN
       result:=FALSE;
       DbgReturn.ErrStr:='Could not connect to debuggee !';
  END
  ELSE result:=TRUE;
  {$ENDIF}
  {$IFDEF WIN32}
  FillChar(aStartData, SizeOf(aStartData), 0);
  With aStartData Do
    Begin
      cb := SizeOf(aStartData);
      dwFlags := startf_UseShowWindow;
      wShowWindow := sw_ShowNormal;
      C:='Sibyl debugging:' + ProcessName;
      lpTitle:=@C;
    End;
  FillChar(ProcessInfo,sizeof(ProcessInfo),0);
  CMD:=CmdBuf;
  Result:=CreateProcess(ProcessName, // FileName
                        Cmd        , // Command Line
                        nil        , // Process attributes
                        nil        , // Thread attributes
                        False      , // Inherit handles
                        debug_Only_This_Process + create_New_Console,
                        nil        , // Environment
                        nil        , // Current directory
                        aStartData,
                        ProcessInfo);
  If Result Then
  Begin
       SessPID:= ProcessInfo.dwProcessID;
       SessTID:= ProcessInfo.dwThreadId;
       SessHandle:=ProcessInfo.hProcess;
       SessThreadHandle:=ProcessInfo.hThread;

       FillChar(DebugEvent,sizeof(DebugEvent),0);
       DebugEvent.dwProcessId:=SessPID;
       DebugEvent.dwThreadId:=SessTID;
       LogWriteln('befor: WaitForDebugEvent');
       While WaitForDebugEvent(DebugEvent,Infinite) Do
       Begin
         //If HandleNotifications Then break; //stop
         case DebugEvent.dwDebugEventCode of
           CREATE_PROCESS_DEBUG_EVENT:
             Begin
               LogWriteln('CREATE_PROCESS_DEBUG_EVENT');
               BreakAtStartAddr:=longword(@DebugEvent.CreateProcessInfo.lpStartAddress);
               StartEIPLinear:=BreakAtStartAddr;

               If BreakAtStart Then
               Begin
                 IF not SetBreakPoint(BreakAtStartAddr,BreakAtStartTyp) THEN
                 Begin
                      s:='Cannot set start breakpoint';
                      DbgReturn.Msg:=DBG_N_ERROR;
                      PostMessage(ServerHwnd,WM_SEM1,LongWord(@s),0);
                 End;
               End;

               //Tell the debugged process about the debugger
               If ProcessDebuggedAddr<>0 Then
               Begin
                    //Get address of ProcessDebugged
                    pd:=0;
                    DbgBuf.Pid:=SessPid;
                    DbgBuf.Tid:=0;
                    DbgBuf.Addr:=ProcessDebuggedAddr;
                    DbgBuf.Buffer:=LongWord(@pd);
                    DbgBuf.Len:=4;
                    DebugCommand(DBG_C_READMEMBUF,'READ MEM BUF');

                    If pd<>0 Then
                    Begin
                         //set processdebugged=True
                         bo:=True;
                         DbgBuf.Pid:=SessPID;
                         DbgBuf.Tid:=0;
                         DbgBuf.Addr:=pd;
                         DbgBuf.Buffer:=LONGWORD(@bo);
                         DbgBuf.Len:=1;
                         DebugCommand(DBG_C_WRITEMEMBUF,'WRITE MEM BUF');
                    End;
               End;
             End;

           EXCEPTION_DEBUG_EVENT:
             Begin
               LogWriteln('EXCEPTION_DEBUG_EVENT');
               Break;
             End;

           else
             Begin
//               LogWriteln('case/else:'+tostr(DebugEvent.dwDebugEventCode));
             End;
         End;
         ContinueDebugEvent(DebugEvent.dwProcessId, DebugEvent.dwThreadId, dbg_Continue);
       End;

       FillChar(CX,sizeof(CX),0);
       CX.ContextFlags := CONTEXT_DEBUG_REGISTERS;
       GetThreadContext(SessThreadHandle,CX);
       CX.DR7:=CX.DR7 And $00000100;
       SetThreadContext(SessThreadHandle,CX);
  End
  Else DbgReturn.ErrStr:='Could not connect to debuggee !';
  {$ENDIF}
END;


FUNCTION UnsetBreakPoint(Address:ULONG;VAR BreakSource:BYTE):BOOLEAN;
VAR
   dummy:PBreakPoints;
   BreakDbgBuf:TDbgBuf;
   Last:PBreakPoints;

BEGIN
  logWriteln('UnsetBreakPoint');
  result:=FALSE;
  dummy:=BreakPoints;
  Last:=NIL;
  WHILE dummy<>NIL DO
  BEGIN
       IF dummy^.LinearAddr=Address THEN
       BEGIN
            BreakSource:=dummy^.typ;
            BreakDbgBuf.Pid:=SessPID;
            BreakDbgBuf.Addr:=Address;
            BreakDbgBuf.Cmd:=DBG_C_WRITEMEM;
            BreakDbgBuf.value:=dummy^.OldOpCode;
            DosDebug(BreakDbgBuf);
            IF BreakDbgBuf.cmd<>DBG_N_SUCCESS THEN exit;
            IF dummy=BreakPoints THEN
            BEGIN
                 BreakPoints:=BreakPoints^.Next;
                 Dispose(dummy);
            END
            ELSE
            BEGIN
                 Last^.Next:=dummy^.Next;
                 dispose(dummy);
            END;
            result:=TRUE;
            exit;
       END;
       Last:=dummy;
       dummy:=dummy^.Next;
  END;
END;

FUNCTION GetBreakPointOp(Address:ULONG;VAR OldOp:BYTE):BOOLEAN;
VAR dummy:PBreakPoints;
BEGIN
  logWriteln('GetBreakPointOp');
  dummy:=Breakpoints;
  WHILE dummy<>NIL DO
  BEGIN
       IF dummy^.LinearAddr=Address THEN
       BEGIN
            OldOp:=dummy^.OldOpCode;
            result:=TRUE;
            exit;
       END;
       dummy:=dummy^.Next;
  END;
  result:=FALSE;
END;

FUNCTION SetBreakPoint(Address:ULONG;Typ:BYTE):BOOLEAN;
VAR dummy:PBreakPoints;
    BreakDbgBuf:TDbgBuf;
    OldOp:WORD;
BEGIN
  logWriteln('SetBreakPoint');
  result:=FALSE;

  dummy:=Breakpoints;
  WHILE dummy<>NIL DO
  BEGIN
       IF dummy^.LinearAddr=Address THEN
       BEGIN
            {Breakpoint already set}
            result:=TRUE;
            exit;
       END;
       dummy:=dummy^.Next;
  END;

  BreakDbgBuf.Pid:=SessPID;
  BreakDbgBuf.Addr:=Address;
  BreakDbgBuf.Cmd:=DBG_C_READMEM;
  DosDebug(BreakDbgBuf);
  IF BreakDbgBuf.cmd<>DBG_N_SUCCESS THEN exit;
  OldOp:=BreakDbgBuf.Value;

  BreakDbgBuf.Pid:=SessPID;
  BreakDbgBuf.Addr:=Address;
  BreakDbgBuf.Cmd:=DBG_C_WRITEMEM;
  BreakDbgBuf.value:=$cc+(256*hi(OldOp));  {INT 3}
  DosDebug(BreakDbgBuf);
  IF BreakDbgBuf.cmd<>DBG_N_SUCCESS THEN exit;

  IF BreakPoints=NIL THEN
  BEGIN
       New(BreakPoints);
       dummy:=BreakPoints;
  END
  ELSE
  BEGIN
       dummy:=BreakPoints;
       WHILE dummy^.Next<>NIL DO dummy:=dummy^.Next;
       New(Dummy^.Next);
       dummy:=dummy^.Next;
  END;
  dummy^.LinearAddr:=Address;
  dummy^.OldOpCode:=OldOp;
  dummy^.Next:=NIL;
  dummy^.Typ:=Typ;
  result:=TRUE;
END;

FUNCTION GetAdressFromLine(Source:STRING;Line:WORD;VAR adress:ULONG):BOOLEAN;
VAR
    dir:String;
    name:String;
    ext:String;
    m:PModuleInfo;
    ll:PLineNumberInfo;
LABEL l,l1;
BEGIN
  logWriteln('GetAdressFromLine');
  result:=FALSE;
  fsplit(Source,dir,name,ext);
  Source:=name+ext;
  m:=ModuleInfo;
  WHILE m<>NIL DO
  BEGIN
       IF m^.SourceFile=Source THEN goto l;
       m:=m^.next;
  END;
  exit;
l:
  ll:=m^.LineNumberInfo;
  WHILE ll<>NIL DO
  BEGIN
       IF ll^.LineNumber=Line THEN goto l1;
       ll:=ll^.next;
  END;
  exit;
l1:
  Adress:=ll^.Offset;
  result:=TRUE;
END;

FUNCTION SetBreakPointLine(Source:STRING;Line:WORD;Typ:BYTE;
                           VAR Adress:ULONG):BOOLEAN;
VAR result:BOOLEAN;
LABEL ex;
BEGIN
  logWriteln('SetBreakPointLine');
  result:=FALSE;
  IF not GetAdressFromLine(Source,Line,Adress) THEN goto ex;
  result:=SetBreakPoint(Adress,Typ);
ex:
  SetBreakPointLine:=result;
END;

FUNCTION IsBreakPointLine(Source:STRING;Line:WORD;Typ:BYTE;
                          VAR Adress:ULONG):BOOLEAN;
VAR result:BOOLEAN;
    dummy:PBreakPoints;
LABEL ex;
BEGIN
  logWriteln('IsBreakPointLine');
  result:=FALSE;
  IF not GetAdressFromLine(Source,Line,Adress) THEN goto ex;

  dummy:=BreakPoints;
  WHILE dummy<>NIL DO
  BEGIN
       IF dummy^.LinearAddr=Adress THEN
         IF dummy^.Typ=Typ THEN
       BEGIN
            result:=TRUE;
            goto ex;
       END;
       dummy:=dummy^.next;
  END;
ex:
  IsBreakPointLine:=result;
END;

PROCEDURE HandleModuleLoad;

{$IFDEF OS2}
VAR s:STRING;
    t:LONGWORD;
    rc:LONGWORD;
    dummy:PModulesLoaded;
    Name:CString;
    o:PObjectList;
    ModDbgBuf:TDbgBuf;
{$ENDIF}

BEGIN
  logWriteln('HandleModuleLoad');
  {$IFDEF OS2}
  DosQueryModuleName(DbgBuf.Value,CCHMAXPATH, Name);
  s:=Name;
  UpcaseStr(s);
  IF ModulesLoaded=NIL THEN
  BEGIN
       New(ModulesLoaded);
       dummy:=ModulesLoaded;
  END
  ELSE
  BEGIN
       dummy:=ModulesLoaded;
       WHILE dummy^.next<>NIL DO dummy:=dummy^.next;
       new(Dummy^.Next);
       Dummy:=Dummy^.Next;
  END;
  dummy^.MTE:=DbgBuf.Value;
  dummy^.Name:=s;
  dummy^.Next:=NIL;
  dummy^.Objects:=NIL;
  dummy^.DebugModules:=NIL;

  FOR t:=1 TO 256 DO  {Check all possible object numbers}
  BEGIN
       ModDbgBuf.Cmd:= DBG_C_NumToAddr;
       ModDbgBuf.Value:=t;
       ModDbgBuf.Buffer:=0;
       ModDbgBuf.Len:=0;
       ModDbgBuf.MTE:=dummy^.MTE;
       ModDbgBuf.Pid := SessPID;
       rc := DosDebug(ModDbgBuf);
       IF ModDbgBuf.cmd<>DBG_N_ERROR THEN
       BEGIN
            IF dummy^.Objects=NIL THEN
            BEGIN
                 new(dummy^.Objects);
                 o:=dummy^.Objects;
            END
            ELSE
            BEGIN
                 o:=dummy^.Objects;
                 WHILE o^.Next<>NIL DO o:=o^.next;
                 New(o^.Next);
                 o:=o^.Next;
            END;

            o^.id:=t;
            o^.Start:=ModDbgBuf.Addr;
            o^.Len:=0;
            o^.Flags:=0;
            o^.LineNumbers:=NIL;
            o^.SourceFile:='';
            o^.Next:=NIL;
            {$IFDEF OS2}
            ModDbgBuf.Cmd:= DBG_C_AddrToObject;
            ModDbgBuf.Pid := SessPID;
            rc := DosDebug(ModDbgBuf);
            IF ModDbgBuf.cmd<>DBG_N_ERROR THEN
              IF ModDbgBuf.Value AND DBG_O_OBJMTE=DBG_O_OBJMTE THEN
            BEGIN
                 o^.Len:=ModDbgBuf.Len;
                 o^.Flags:=ModDbgBuf.Value;
            END;
            {$ENDIF}
       END;
  END;
  {$ENDIF}
END;

PROCEDURE HandleThreadCreate;

{$IFDEF OS2}
VAR dummy:PModulesLoaded;
    odummy:PObjectList;

LABEL l;
{$ENDIF}

BEGIN
  logWriteln('HandleThreadCreate');
  {$IFDEF OS2}
  IF StartEIPLinear=0 THEN
  BEGIN
       dummy:=ModulesLoaded;
       WHILE dummy<>NIL DO
       BEGIN
           IF dummy^.Name=DebuggeeName THEN
           BEGIN
                odummy:=dummy^.objects;
                WHILE odummy<>NIL DO
                BEGIN
                     IF odummy^.id=StartCS THEN
                     BEGIN
                          StartEIPLinear:=odummy^.Start+StartEIP;
                          goto l;
                     END;
                     odummy:=odummy^.Next;
                END;
                goto l;
           END;
           dummy:=dummy^.next;
      END;
l:
      IF StartEIPLinear=0 THEN
          PostAndWaitMsg(DBG_N_ERROR,'Could not find starting CS:EIP')
      ELSE
      BEGIN
           IF BreakAtStart THEN
           BEGIN
             IF BreakAtStartAddr<>0 THEN
             BEGIN
                IF not SetBreakPoint(BreakAtStartAddr,BreakAtStartTyp) THEN
                  PostAndWaitMsg(DBG_N_ERROR,'Could not set start breakpoint')
             END
             ELSE
             BEGIN
                IF not SetBreakPoint(StartEIPLinear,BreakAtStartTyp) THEN
                  PostAndWaitMsg(DBG_N_ERROR,'Could not set start breakpoint');
             END;
           END;
      END;
      FillSymbolLists;
      GetAdressFromName('SYSTEM','SYSTEM.!VMTCALL',VmtCallAddr);
  END;
  {$ENDIF}
  {PostAndWaitMsg(DBG_N_THREADCREATE,'Thread '+tostr(DbgBuf.aTid)+
                 ' created !');}
END;

PROCEDURE SetStartBreakPoint(Typ:BYTE);
BEGIN
  logWriteln('SetStartBreakPoint');
  BreakAtStart:=TRUE;  {Set when first thread created (HandleThreadCreate)}
  BreakAtStartTyp:=Typ;
  BreakAtStartAddr:=0;
END;

PROCEDURE SetBreakAtStartAddr(Addr:ULONG);
BEGIN
  logWriteln('SetBreakAtStartAddr');
  BreakAtStartAddr:=Addr;
END;

{$IFDEF WIN32}
Type
    TWin32Object=Record
              Name:Array[1..8] Of CHAR;
              VirtualSize:LongInt;
              rva:LongInt;
              PhysicalSize:LongInt;
              PhysicalOfs:LongInt;
              ReloPtr:LongInt;
              LinePtr:LongInt;
              ReloEntries:Word;
              LineEntries:Word;
              Flags:LongInt;
    End;

    T_Win32EXEHeader=Record
              Signature:LongInt;   //Win32 Magic EXE number 0x4550
              CPU:Word;            // 0x014c = 80386
              ObjectEntries:Word;  //Number of entries in object table
              TimeStamp:LongInt;   //Time and Date
              Symbols:LongInt;     //Pointer to symbol table
              NrSymbols:LongInt;   //Number of Symbol entries
              HeaderSize:Word;     //Size of optional header 0x0e
              Attributes:Word;     //Attributes of EXE 0x8182
              Magic:Word;          // 0x010b
              lmajor:Byte;         // 0x06
              lminor:Byte;         // 0x00
              CodeSize:LongInt;    //Size of code
              InitDatas:LongInt;   //Size of init data
              UnInitDatas:LongInt; //Size if uninit data
              EntryCSEIP:LongInt;  //Entrypoint rva
              CodeBase:LongInt;    //Base of code (4096)
              DataBase:LongInt;    //Base of data
              ImageBase:LongInt;   //Base of image 0x400000
              ObjAlign:LongInt;    //Object align (4096)
              FileAlign:LongInt;   //File align (512)
              OSMajor:Word;        // 0x01
              OSMinor:Word;        // 0x00
              UserMajor:Word;      // 0x00
              UserMinor:Word;      // 0x00
              SubSysMajor:Word;    // 0x03
              SubSysMinor:Word;    // 0x10
              reserved1:LongInt;   // 0x00
              ImageSize:LongInt;   //Size of image
              NHeaderSize:LongInt; //Size of header 0x0400
              CheckSum:LongInt;    // 0x00
              SubSys:Word;         //Subsystem 0x02
              DLLFlags:Word;       // 0x00
              StackSize:LongInt;   //Stack size 0x1000000
              StackCommit:LongInt; //4096
              HeapSize:LongInt;    //Heap size 0x1000000
              HeapCommit:LongInt;  //4096
              reserved2:LongInt;   // 0x00
              Count:LongInt;       //Interesting count 0x10
              ExportTable:LongInt; //Export Table rva
              ExportData:LongInt;  //Export data size
              ImportTable:LongInt; //Import table rva
              ImportData:LongInt;  //Import data size
              ResTable:LongInt;    //Resource table rva
              ResData:LongInt;     //Resource table size
              ExcptTable:LongInt;  //Exception table rva
              ExcptData:LongInt;   //Exception table size
              SecTable:LongInt;    //Security table rva
              SecData:LongInt;     //Security table size
              FixTable:LongInt;    //Fixup table rva
              FixData:LongInt;     //Fixup table size
              DebugTable:LongInt;  //Debug table rva
              DebugDirs:LongInt;   //Debug table dir entries
              ImageTable:LongInt;  //Image description rva
              ImageData:LongInt;   //Image description size
              MachTable:LongInt;   //Machine specific rva
              MachData:LongInt;    //Machine specific size

              //Fill up to 504
              Reserved:Array[1..56] Of Byte;
              Code:TWin32Object;
              Data:TWin32Object;
              iData:TWin32Object;
              eData:TWin32Object;
              Relo:TWin32Object;
              Res:TWin32Object;
              Debug:TWin32Object;
    END;
{$ENDIF}

FUNCTION GetDebugInfo(name:STRING):BOOLEAN;

VAR f:FILE;
    w:WORD;
    t1:LONGWORD;
{$IFDEF OS2}
    b:BYTE;
    NewHeaderStart:LONGWORD;
{$ENDIF}
{$IFDEF WIN32}
    s:String;
    Win32Header:T_Win32EXEHeader;
    dummy1:PModulesLoaded;

    Procedure AddObject(dummy:PModulesLoaded;Id,Start,Len,Flags:LongInt);
    Var o:PObjectList;
    Begin
        IF dummy^.Objects=NIL THEN
        BEGIN
             new(dummy^.Objects);
             o:=dummy^.Objects;
        END
        ELSE
        BEGIN
             o:=dummy^.Objects;
             WHILE o^.Next<>NIL DO o:=o^.next;
             New(o^.Next);
             o:=o^.Next;
        END;

        o^.id:=Id;
        o^.Start:=Start;
        o^.Len:=Len;
        o^.Flags:=Flags;
        o^.LineNumbers:=NIL;
        o^.SourceFile:='';
        o^.Next:=NIL;
    End;
{$ENDIF}

{$IFDEF OS2}
LABEL l1;
{$ENDIF}
LABEL l2;
BEGIN
  logWriteln('GetDebugInfo');
  Result:=False;
  DbgReturn.ErrStr:='Could not load debug information';

  FileMode:=fmInput;
  Assign(f,name);
  {$i-}
  Reset(f,1);
  {$i+}
  FileMode:=fmInOut;

  {$IFDEF WIN32}
  IF ioresult=0 THEN
  BEGIN
       {first we want to get the Entry point of the main program}
       {$i-}
       BlockRead(f,w,2);
       {$i+}
       IF ioresult<>0 THEN goto l2;
       IF w<>$5a4d THEN goto l2;  {Magic number for DOS EXE}

       {$i-}
       Seek(f,256);  {onto new Win32 header}
       {$i+}
       IF ioresult<>0 THEN goto l2;

       {$i-}
       BlockRead(f,Win32Header,sizeof(Win32Header));  {Read size of old Header in Paras}
       {$i+}
       IF ioresult<>0 THEN goto l2;

       If Win32Header.Signature<>$4550 Then goto l2; //magic
       If Win32Header.DebugTable=0 Then goto l2; //no debug info

       If Win32Header.ResTable=0 Then Win32Header.Debug:=Win32Header.Res;

       {Read symbol information if present}
       SymBuffer:=NIL;
       {$i-}
       t1:=FileSize(f);
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       Seek(f,t1-8);
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,w,2);
       {$i+}
       IF IoResult<>0 THEN goto l2;
       IF w<>$424e THEN goto l2;{IPMD 32 Bit PM debugging info magic number}

       {$i-}
       BlockRead(f,w,2);  {Overread version}
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,SymBufferLen,4);  {Length of debugger data}
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       t1:=FilePos(f);
       {$i+}
       IF Ioresult<>0 THEN goto l2;
       IF SymBufferLen>=t1 THEN goto l2;
       {$i-}
       Seek(f,t1-SymBufferLen);
       {$i+}
       IF IoResult<>0 THEN goto l2;

       GetMem(SymBuffer,SymBufferLen);
       {$i-}
       BlockRead(f,SymBuffer^,SymBufferLen);
       {$i+}
       IF IoResult<>0 THEN
       BEGIN
            FreeMem(SymBuffer,SymBufferLen);
            SymBuffer:=NIL;
            goto l2;
       END;
       w:=SymBuffer^[0];
       IF w<>$424e THEN
       BEGIN
            FreeMem(SymBuffer,SymBufferLen);
            SymBuffer:=NIL;
            goto l2;
       END;
       t1:=SymBuffer^[4];  {Start of dir table}
       IF t1>=SymBufferLen THEN
       BEGIN
            FreeMem(SymBuffer,SymBufferLen);
            SymBuffer:=NIL;
            goto l2;
       END;

       s:=DebuggeeName;
       UpcaseStr(s);
       IF ModulesLoaded=NIL THEN
       BEGIN
            New(ModulesLoaded);
            dummy1:=ModulesLoaded;
       END
       ELSE
       BEGIN
            dummy1:=ModulesLoaded;
            WHILE dummy1^.next<>NIL DO dummy1:=dummy1^.next;
            new(Dummy1^.Next);
            Dummy1:=Dummy1^.Next;
       END;
       dummy1^.MTE:=0;
       dummy1^.Name:=s;
       dummy1^.Next:=NIL;
       dummy1^.Objects:=NIL;
       dummy1^.DebugModules:=NIL;

       AddObject(dummy1,1,Win32Header.ImageBase+Win32Header.Code.rva,Win32Header.Code.VirtualSize,Win32Header.Code.Flags);
       AddObject(dummy1,2,Win32Header.ImageBase+Win32Header.Data.rva,Win32Header.Data.VirtualSize,Win32Header.Data.Flags);

       Result:=True;
       FillSymbolLists;
       GetAdressFromName('SYSTEM','SYSTEM.!VMTCALL',VmtCallAddr);
       GetAdressFromName('SYSTEM','SYSTEM.!EXCEPTIONLIST',ExceptionListAddr);
       GetAdressFromName('SYSTEM','SYSTEM.!DEBUGPRESENT',ProcessDebuggedAddr);
l2:
       {$i-}
       Close(f);
       {$i+}
  END;
  {$ENDIF}

  {$IFDEF OS2}
  IF ioresult=0 THEN
  BEGIN
       {first we want to get the Entry point of the main program}
       {$i-}
       BlockRead(f,w,2);
       {$i+}
       IF ioresult<>0 THEN goto l2;
       IF w<>$5a4d THEN goto l2;  {Magic number for DOS EXE}
       {$i-}
       Seek(f,14);  {onto size of old EXE header}
       {$i+}
       IF ioresult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,b,1);  {Read size of old Header in Paras}
       {$i+}
       IF ioresult<>0 THEN goto l2;

       NewHeaderStart:=b*16;
       {$i-}
       Seek(f,NewHeaderStart);
       {$i+}
       IF ioresult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,w,2);
       {$i+}
       IF ioresult<>0 THEN goto l2;
       IF w<>$584c THEN goto l2;  {Magic number for OS/2 EXE}

       {$i-}
       Seek(f,NewHeaderStart+24); {onto start CS:EIP}
       {$i+}
       IF ioresult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,StartCS,4);
       {$i+}
       IF ioresult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,StartEIP,4);
       {$i+}
       IF ioresult<>0 THEN goto l2;

       {Read symbol information if present}
       SymBuffer:=NIL;
       {$i-}
       t1:=FileSize(f);
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       Seek(f,t1-8);
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,w,2);
       {$i+}
       IF IoResult<>0 THEN goto l2;
       IF w<>$424e THEN goto l1;{IPMD 32 Bit PM debugging info magic number}

       {$i-}
       BlockRead(f,w,2);  {Overread version}
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       BlockRead(f,SymBufferLen,4);  {Length of debugger data}
       {$i+}
       IF IoResult<>0 THEN goto l2;
       {$i-}
       t1:=FilePos(f);
       {$i+}
       IF Ioresult<>0 THEN goto l2;
       IF SymBufferLen>=t1 THEN goto l2;
       {$i-}
       Seek(f,t1-SymBufferLen);
       {$i+}
       IF IoResult<>0 THEN goto l2;
       GetMem(SymBuffer,SymBufferLen);
       {$i-}
       BlockRead(f,SymBuffer^,SymBufferLen);
       {$i+}
       IF IoResult<>0 THEN
       BEGIN
            FreeMem(SymBuffer,SymBufferLen);
            SymBuffer:=NIL;
            goto l2;
       END;
       w:=SymBuffer^[0];
       IF w<>$424e THEN
       BEGIN
            FreeMem(SymBuffer,SymBufferLen);
            SymBuffer:=NIL;
            goto l2;
       END;
       t1:=SymBuffer^[4];  {Start of dir table}
       IF t1>=SymBufferLen THEN
       BEGIN
            FreeMem(SymBuffer,SymBufferLen);
            SymBuffer:=NIL;
            goto l2;
       END;
l1:
       result:=TRUE;
l2:
       {$i-}
       Close(f);
       {$i+}
  END;
  {$ENDIF}
END;

PROCEDURE GetLineNumbers(p:PModuleInfo);
VAR
   AcLine:LONGWORD;
   DebugData:PSymByteBuffer;
   dummy,Last:PLineNumberInfo;
   ww:LONGWORD;
   tl,th:LONGWORD;
   NumLines:LONGWORD;
   Offset1:LONGWORD;
BEGIN
  logWriteln('GetLineNumbers');
  DebugData:=POINTER(SymBuffer);
  {Scan line number of this entry}
  p^.LineNumberInfo:=NIL;
  AcLine:=p^.LineStart;
  NumLines:=DebugData^[AcLine+4]+256*DebugData^[AcLine+5];
  Inc(AcLine,8);
  FOR ww:=1 TO NumLines DO
  BEGIN
       tl:=DebugData^[AcLine+4]+256*DebugData^[AcLine+5];
       th:=DebugData^[AcLine+6]+256*DebugData^[AcLine+7];
       Offset1:=tl + (th SHL 16);

       IF p^.LineNumberInfo=NIL THEN
       BEGIN
            new(p^.LineNumberInfo);
            dummy:=p^.LineNumberInfo;
       END
       ELSE
       BEGIN
            New(Last^.next);
            dummy:=Last^.Next;
       END;

       dummy^.LineNumber:=DebugData^[AcLine]+256*DebugData^[AcLine+1];
       dummy^.Offset:=p^.CodeOffs+Offset1;
       IF dummy^.Offset=StartEIPLinear THEN
       BEGIN
            StartEIPSourceLine:=dummy^.LineNumber;
            StartEIPSourceFile:=p^.SourceFile;
       END;
       dummy^.next:=NIL;
       Last:=dummy;
       inc(AcLine,8);
  END;
END;

PROCEDURE GetPublics(p:PModuleInfo);
VAR
   dummy,Last:PPublicsInfo;
   PStart,PMax:LONGWORD;
   DebugData:PSymByteBuffer;
   tl,th,w:LongWORD;
   Offset:LONGWORD;
   b,b1:BYTE;
   s1:STRING;
   CSBase:LONGWORD;
   modLoad:PModulesLoaded;
   ol:PObjectList;
   ObjectIndex:LONGWORD;
   Typ:WORD;
LABEL ll,l2;
BEGIN
  logWriteln('GetPublics');
//   ProfileEvent( 'GetPublics' );
     DebugData:=POINTER(SymBuffer);
     {Scan Publics of this entry}
     PStart:=p^.PublicsStart;
     PMax:=PStart+p^.PublicsLen;
     p^.PublicsInfo:=NIL;

//     ProfileEvent( '  Objects start at = ' + IntToHex( PStart, 8 ) );
//     ProfileEvent( '    Length = ' + IntToHex( p^.PublicsLen, 8 ) );
//     ProfileEvent( '    End at = ' + IntToHex( PMax, 8 ) );

ll:
//     ProfileEvent( '  Symbol at = ' + IntToHex( PStart, 8 ) );

     w:=DebugData^[PStart+4]+256*DebugData^[PStart+5];        {Object id}
     Typ:=DebugData^[PStart+6]+256*DebugData^[PStart+7];      {Object typ}

     CSBase:=w;

//     ProfileEvent( '  In object ID = ' + IntToHex( CSBase, 8 ) );

     {Calc base adress for that object}
     modLoad:=ModulesLoaded;
     WHILE ModLoad<>NIL DO
     BEGIN
          IF ModLoad^.Name=DebuggeeName THEN
          BEGIN
//               ProfileEvent( '    Found debuggee module' );
               ol:=ModLoad^.Objects;
               WHILE ol<>NIL DO
               BEGIN
//                    ProfileEvent( '      Object ID = ' + IntToHex( ol^.id, 8 ) );
                    IF ol^.id=CSBase THEN
                    BEGIN
//                         ProfileEvent( '      CSBase found, ol^.start = ' + IntToHex( ol^.Start, 8 ) );
                         CSBase:=ol^.Start;
                         ObjectIndex:=ol^.id;
                         goto l2;
                    END;
                    ol:=ol^.Next;
               END;
//               ProfileEvent( '      CSBase not found' );
               PostAndWaitMsg(DBG_N_ERROR,
                   'Object '+tostr(CSBase)+' in module '+DebuggeeName+
                           ' not found (PUBLICS)');
               goto l2;
          END;
          ModLoad:=ModLoad^.Next;
      END;
      PostAndWaitMsg(DBG_N_ERROR,'module '+DebuggeeName+' not found (PUBLICS)');
l2:
     tl:=DebugData^[PStart]+256*DebugData^[PStart+1];
     th:=DebugData^[PStart+2]+256*DebugData^[PStart+3];
     Offset:=tl + (th SHL 16); {Object offset}

     inc(PStart,8);
     b:=DebugData^[PStart];
     inc(PStart);
//     ProfileEvent( '   Name length = ' + IntToStr( b ) );
     s1[0]:=chr(b);
     FOR b1:=1 TO b DO
     BEGIN
          s1[b1]:=chr(DebugData^[PStart]);
          inc(PStart);
     END;
//     ProfileEvent( '   Name = ' + s1  );

     IF p^.PublicsInfo=NIL THEN
     BEGIN
          new(p^.PublicsInfo);
          dummy:=p^.PublicsInfo;
     END
     ELSE
     BEGIN
          New(Last^.Next);
          dummy:=Last^.Next;
     END;

     GetMem(dummy^.PublicName,length(s1)+1);
     dummy^.PublicName^:=s1;
     dummy^.Offset:=CSBase+Offset;
     dummy^.Typ:=Typ;
     dummy^.TypOffset:=-1;
     dummy^.ObjectIndex:=ObjectIndex;
     Dummy^.Next:=NIL;
     Last:=dummy;

     IF PStart<PMax THEN goto ll;
END;

PROCEDURE GetSymbols(p:PModuleInfo);
VAR
   dummy,Symbols,LastMain,LastSym:PSymbolsInfo;
   PStart,PMax:LONGWORD;
   DebugData:PSymByteBuffer;
   CSBase:ULONG;
   Offset,Len:LONGINT;
   w,w1:LONGWORD;
   b,b1,t:BYTE;
   Typ:WORD;
   OffsetTyp:BYTE;
   s:STRING;
LABEL ll,l2,l3;
BEGIN
     DebugData:=POINTER(SymBuffer);
     {Scan Publics of this entry}
     PStart:=p^.SymbolsStart;
     PMax:=PStart+p^.SymbolsLen;
     Inc(PStart,34);
     CSBase:=p^.CodeOffs;
     p^.SymbolsInfo:=NIL;
ll:
     b:=DebugData^[PStart]; {Get Len}
     w:=DebugData^[PStart+2]+256*DebugData^[PStart+3];
     w1:=DebugData^[PStart+4]+256*DebugData^[PStart+5];
     Offset:=w+65536*w1;

     Typ:=DebugData^[PStart+6]+256*DebugData^[PStart+7];  {Result type}

     w:=DebugData^[PStart+8]+256*DebugData^[PStart+9];
     w1:=DebugData^[PStart+10]+256*DebugData^[PStart+11];
     Len:=w+65536*w1;

     b1:=DebugData^[PStart+21];
     s:='';
     FOR t:=1 TO b1 DO s:=s+chr(DebugData^[PStart+21+t]);
     inc(PStart,b+1);  {Len}

     IF p^.SymbolsInfo=NIL THEN
     BEGIN
          new(p^.SymbolsInfo);
          dummy:=p^.SymbolsInfo;
     END
     ELSE
     BEGIN
          New(LastMain^.Next);
          dummy:=LastMain^.Next;
     END;

     GetMem(dummy^.SymbolName,length(s)+1);
     dummy^.SymbolName^:=s;
     dummy^.Offset:=CSBase+Offset;
     dummy^.Len:=Len;
     dummy^.TypOffset:=-1;
     dummy^.Typ:=Typ;
     dummy^.OffsetTyp:=0;
     Dummy^.Next:=NIL;
     Dummy^.Symbols:=NIL;
     LastMain:=Dummy;

     b:=DebugData^[PStart];
     inc(PStart,b+1);
l3:
     b:=DebugData^[PStart];
     IF b=1 THEN
     BEGIN
          inc(PStart,4);
          goto l2;  {end of symbols or next symbol}
     END;

     OffsetTyp:=DebugData^[PStart+1];  {04-EBP}

     w:=DebugData^[PStart+2]+256*DebugData^[PStart+3];
     w1:=DebugData^[PStart+4]+256*DebugData^[PStart+5];
     Offset:=w+65536*w1;

     Typ:=DebugData^[PStart+6]+256*DebugData^[PStart+7];

     b1:=DebugData^[PStart+8];
     s:='';
     FOR t:=1 TO b1 DO s:=s+chr(DebugData^[PStart+8+t]);
     inc(PStart,b+1);  {Len}

     IF dummy^.Symbols=NIL THEN
     BEGIN
          new(dummy^.Symbols);
          Symbols:=dummy^.Symbols;
     END
     ELSE
     BEGIN
          New(LastSym^.Next);
          Symbols:=LastSym^.Next;
     END;

     GetMem(Symbols^.SymbolName,length(s)+1);
     Symbols^.SymbolName^:=s;
     Symbols^.OffsetTyp:=OffsetTyp;
     Symbols^.Offset:=Offset;
     Symbols^.Len:=0;
     Symbols^.TypOffset:=-1;
     Symbols^.Typ:=Typ;
     Symbols^.Next:=NIL;
     Symbols^.Symbols:=NIL;
     LastSym:=Symbols;

     IF PStart<PMax THEN goto l3;  {Next Symbol}
l2:
     IF PStart<PMax THEN goto ll;
END;

PROCEDURE GetTypes(p:PModuleInfo);
VAR
   TStart:LONGWORD;
   DebugData:PSymByteBuffer;
BEGIN
     DebugData:=POINTER(SymBuffer);

     {Scan Types of this entry}
     TStart:=p^.TypesStart;
     Getmem(p^.TypesInfo,p^.TypesLen);
     move(DebugData^[TStart],p^.TypesInfo^,p^.TypesLen);
END;

PROCEDURE FillSymbolLists;
VAR
   DirStart,DirCount:LONGWORD;
   ModStart,ModIndex:LONGWORD;
   Typ:WORD;
   t:LONGWORD;
   DebugData:PSymByteBuffer;
   tl,th:LONGWORD;
   b,b1:BYTE;
   p,Last:PModuleInfo;
   CSBase,CSOffs,CSLen:LONGWORD;
   modload:PModulesLoaded;
   ol:PObjectList;
   s:STRING;
LABEL l,l1,l2,ex;
BEGIN
//   StartProfile( 'dbghelp.log' );

     IF SymBuffer=NIL THEN
     BEGIN
          PostAndWaitMsg(DBG_N_ERROR,'No debug data present');
          exit; {No debug data present}
     END;

     DebugData:=POINTER(SymBuffer);
     ModuleInfo:=NIL;
     tl:=DebugData^[4]+256*DebugData^[5];
     th:=DebugData^[6]+256*DebugData^[7];
     DirStart:=tl + (th SHL 16);  {Start of dir table}
     inc(DirStart,4);
     tl:=DebugData^[DirStart]+256*DebugData^[DirStart+1];
     th:=DebugData^[DirStart+2]+256*DebugData^[DirStart+3];
     DirCount:=tl + (th SHL 16);
     inc(DirStart,4);
//   ProfileEvent( 'Scan directory, up to count = ' + IntToStr( DirCount ) );
     FOR t:=1 TO DirCount DO
     BEGIN
//          ProfileEvent( '  Dir # ' + IntToStr( t ) );

          Typ:=DebugData^[DirStart]+256*DebugData^[DirStart+1];
          IF Typ=SSTMODULES THEN
          BEGIN
//              ProfileEvent( '    Module ' );
               {Module found}
               tl:=DebugData^[DirStart+4]+256*DebugData^[DirStart+5];
               th:=DebugData^[DirStart+6]+256*DebugData^[DirStart+7];
               ModStart:=tl + (th SHL 16); {Section start}

//              ProfileEvent( '      Module data at ' + IntToHex( ModStart, 8 ) );
             
               ModIndex:=DebugData^[DirStart+2]+256*DebugData^[DirStart+3];

//             ProfileEvent( '      Module index ' + IntToStr( ModIndex ) );

               IF ModuleInfo=NIL THEN
               BEGIN
                    New(ModuleInfo);
                    p:=ModuleInfo;
               END
               ELSE
               BEGIN
                    New(Last^.Next);
                    p:=Last^.Next;
               END;
               p^.PublicsLen:=0;
               p^.TypesLen:=0;
               p^.SymbolsLen:=0;
               p^.LineLen:=0;
               p^.ModIndex:=ModIndex;
               p^.LineNumberInfo:=NIL;
               p^.PublicsInfo:=NIL;
               p^.TypesInfo:=NIL;
               p^.SymbolsInfo:=NIL;
               p^.ObjectIndex:=0; {unkown}
               p^.Next:=NIL;
               p^.Module:=NIL;
               Last:=p;

               CSBase:=DebugData^[ModStart]+256*DebugData^[ModStart+1];
               tl:=DebugData^[ModStart+2]+256*DebugData^[ModStart+3];
               th:=DebugData^[ModStart+4]+256*DebugData^[ModStart+5];

//             ProfileEvent( '      CSBase ' + IntToHex( CSBase, 8 ) );

               CSOffs:=tl + (th SHL 16);
               tl:=DebugData^[ModStart+6]+256*DebugData^[ModStart+7];
               th:=DebugData^[ModStart+8]+256*DebugData^[ModStart+9];
               CSLen:=tl + (th SHL 16);
               p^.CodeLen:=CSLen;
               {Calc base adress for that object}
               modLoad:=ModulesLoaded;
               WHILE ModLoad<>NIL DO
               BEGIN
                    IF ModLoad^.Name=DebuggeeName THEN
                    BEGIN
                         IF ModLoad^.DebugModules=NIL THEN
                           ModLoad^.DebugModules:=p;
                         p^.Module:=ModLoad;
                         ol:=ModLoad^.Objects;
                         WHILE ol<>NIL DO
                         BEGIN
                              IF ol^.id=CSBase THEN
                              BEGIN
                                   CSBase:=ol^.Start;
//                                 ProfileEvent( '      New CSBase ' + IntToHex( CSBase, 8 ) );
                                   p^.ObjectIndex:=ol^.id;
                                   goto l2;
                              END;
                              ol:=ol^.Next;
                         END;
                         PostAndWaitMsg(DBG_N_ERROR,
                           'Object '+tostr(CSBase)+'in module '+DebuggeeName+
                           ' not found (FillSymbolList)');
                         goto l2;
                    END;
                    ModLoad:=ModLoad^.Next;
               END;
               PostAndWaitMsg(DBG_N_ERROR,'module '+DebuggeeName+' not found');
l2:
               p^.CodeOffs:=CSBase+CSOffs;
               inc(ModStart,20);
               b:=DebugData^[ModStart];
               s[0]:=chr(b);
               FOR b1:=1 TO b DO
               BEGIN
                    inc(ModStart);
                    s[b1]:=chr(DebugData^[ModStart]);
               END;
               s[length(s)+1]:=#0;
//             ProfileEvent( '      Name ' + S );
             
               p^.SourceFile:=s;
l1:
               inc(DirStart,12);
               inc(t);
               IF t>DirCount THEN goto l;
               tl:=DebugData^[DirStart+2]+256*DebugData^[DirStart+3];
               IF ModIndex<>tl THEN goto l;
               Typ:=DebugData^[DirStart]+256*DebugData^[DirStart+1];

               CASE Typ OF
                 SSTPUBLICS:
                 BEGIN
                      tl:=DebugData^[DirStart+4]+256*DebugData^[DirStart+5];
                      th:=DebugData^[DirStart+6]+256*DebugData^[DirStart+7];
                      p^.PublicsStart:=tl + (th SHL 16);
                      tl:=DebugData^[DirStart+8]+256*DebugData^[DirStart+9];
                      th:=DebugData^[DirStart+10]+256*DebugData^[DirStart+11];
                      p^.PublicsLen:=tl + (th SHL 16);
                      GetPublics(p);
                 END;
                 SSTSRCLINES32:
                 BEGIN
                      tl:=DebugData^[DirStart+4]+256*DebugData^[DirStart+5];
                      th:=DebugData^[DirStart+6]+256*DebugData^[DirStart+7];
                      p^.LineStart:=tl + (th SHL 16);
                      tl:=DebugData^[DirStart+8]+256*DebugData^[DirStart+9];
                      th:=DebugData^[DirStart+10]+256*DebugData^[DirStart+11];
                      p^.LineLen:=tl + (th SHL 16);
                      GetLineNumbers(p);
                 END;
                 SSTSYMBOLS:
                 BEGIN
                      tl:=DebugData^[DirStart+4]+256*DebugData^[DirStart+5];
                      th:=DebugData^[DirStart+6]+256*DebugData^[DirStart+7];
                      p^.SymbolsStart:=tl + (th SHL 16);
                      tl:=DebugData^[DirStart+8]+256*DebugData^[DirStart+9];
                      th:=DebugData^[DirStart+10]+256*DebugData^[DirStart+11];
                      p^.SymbolsLen:=tl + (th SHL 16);
                      GetSymbols(p);
                 END;
                 SSTTYPES:
                 BEGIN
                      tl:=DebugData^[DirStart+4]+256*DebugData^[DirStart+5];
                      th:=DebugData^[DirStart+6]+256*DebugData^[DirStart+7];
                      p^.TypesStart:=tl + (th SHL 16);
                      tl:=DebugData^[DirStart+8]+256*DebugData^[DirStart+9];
                      th:=DebugData^[DirStart+10]+256*DebugData^[DirStart+11];
                      p^.TypesLen:=tl + (th SHL 16);
                      GetTypes(p);
                 END;
               END;
               goto l1;
l:
               dec(t);
               dec(DirStart,12);
          END; {Typ=SSTMODULES}
          Inc(DirStart,12);
          IF DirStart>=SymBufferLen THEN goto ex;
     END;
ex:
     FreeMem(SymBuffer,SymBufferLen);
     SymBuffer:=NIL;
END;

PROCEDURE SearchLineNum(LinearAddr:ULONG;IncClosest:BOOLEAN;
                        VAR Source:STRING;VAR Line:WORD;
                        VAR Module:PModuleInfo);
VAR p:PModuleInfo;
    li:PLineNumberInfo;
    Loaded:PModulesLoaded;
    o:PObjectList;
    ClosestMatch:WORD;
    MaxDiff:LONGWORD;
LABEL l;
BEGIN
     Source:='';
     Line:=0;
     Module:=NIL;
     p:=ModuleInfo;
     WHILE p<>NIL DO
     BEGIN
          ClosestMatch:=0;
          MaxDiff:=65536;
          IF LinearAddr>=p^.CodeOffs THEN
           IF LinearAddr<=p^.CodeOffs+p^.CodeLen THEN
           BEGIN
                {Line is in this module}
                Module:=p;
                Source:=p^.SourceFile;
                li:=p^.LineNumberInfo;
                WHILE li<>NIL DO
                BEGIN
                     IF li^.Offset=LinearAddr THEN
                     BEGIN
                          Line:=li^.LineNumber;
                          goto l;
                     END
                     ELSE IF IncClosest THEN
                     BEGIN
                         {This assumes that linenumbers are sorted by offset!}
                         IF ((LinearAddr>li^.Offset)AND(li^.next<>NIL)AND(LinearAddr<li^.next^.Offset)) THEN
                           IF LinearAddr-li^.Offset<MaxDiff THEN
                         BEGIN
                              MaxDiff:=LinearAddr-li^.Offset;
                              ClosestMatch:=li^.LineNumber;
                         END;
                     END;
                     li:=li^.Next;
                END;

                IF ClosestMatch<>0 THEN
                BEGIN
                     Line:=ClosestMatch;
                     goto l;
                END;
           END;
           p:=p^.Next;
     END;
     Loaded:=ModulesLoaded;
     WHILE Loaded<>NIL DO
     BEGIN
          o:=Loaded^.Objects;
          WHILE o<>NIL DO
          BEGIN
               IF LinearAddr>=o^.Start THEN
                IF LinearAddr<=o^.Start+o^.Len THEN
                BEGIN
                     Source:=Loaded^.Name;
                     Line:=0;  {no line number info}
                     goto l;
                END;
               o:=o^.Next;
          END;
          Loaded:=Loaded^.Next;
     END;
l:
END;

PROCEDURE GetLineFromEIP(LinearAddr:ULONG;IncClosest:BOOLEAN;
                         VAR Source:STRING;VAR Line:WORD;
                         Module:PModuleInfo);
VAR p:PModuleInfo;
    li:PLineNumberInfo;
    Loaded:PModulesLoaded;
    o:PObjectList;
    ClosestMatch:WORD;
LABEL l;
BEGIN
     Source:='';
     Line:=0;
     p:=Module;
     ClosestMatch:=0;
     IF LinearAddr>=p^.CodeOffs THEN
      IF LinearAddr<=p^.CodeOffs+p^.CodeLen THEN
      BEGIN
           {Line is in this module}
           Module:=p;
           Source:=p^.SourceFile;
           li:=p^.LineNumberInfo;
           WHILE li<>NIL DO
           BEGIN
                IF li^.Offset=LinearAddr THEN
                BEGIN
                     Line:=li^.LineNumber;
                     goto l;
                END
                ELSE IF IncClosest THEN
                BEGIN
                    {This assumes that linenumbers are sorted by offset!}
                    IF LinearAddr>li^.Offset THEN
                     IF li^.next<>NIL THEN
                      IF LinearAddr<li^.next^.offset THEN
                      BEGIN
                           ClosestMatch:=li^.LineNumber;
                      END;
                END;
                li:=li^.Next;
           END;
           IF ClosestMatch<>0 THEN
           BEGIN
                Line:=ClosestMatch;
                goto l;
           END;
      END;
      Loaded:=ModulesLoaded;
      WHILE Loaded<>NIL DO
      BEGIN
           o:=Loaded^.Objects;
           WHILE o<>NIL DO
           BEGIN
                IF LinearAddr>=o^.Start THEN
                 IF LinearAddr<=o^.Start+o^.Len THEN
                 BEGIN
                      Source:=Loaded^.Name;
                      Line:=0;  {no line number info}
                      goto l;
                 END;
                o:=o^.Next;
           END;
           Loaded:=Loaded^.Next;
      END;
l:
END;


FUNCTION GetRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;
BEGIN
     IF RetryTheExcept THEN
     BEGIN
          Buf:=RetryExceptRegBuf;
          result:=TRUE;
     END
     ELSE
     BEGIN
         Buf.PID:=SessPID;
         Buf.TID:=0; {active thread}
         Buf.cmd:=DBG_C_READREG;
         result:=DosDebug(Buf)=DBG_N_SUCCESS;
     END;
END;

FUNCTION IssueDebugCommand(VAR Buf:TDbgBuf):BOOLEAN;
BEGIN
     Buf.PID:=SessPID;
     Buf.TID:=0; {active thread}
     result:=DosDebug(Buf)=DBG_N_SUCCESS;
END;

{Reads copro register set}
FUNCTION GetCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;
VAR DbgBuf:TDbgBuf;
BEGIN
     IF RetryTheExcept THEN
     BEGIN
          Buf:=RetryExceptCoproBuf;
          result:=TRUE;
     END
     ELSE
     BEGIN
          DbgBuf.PID:=SessPID;
          DbgBuf.TID:=0; {active thread}
          DbgBuf.Value:=1;
          DbgBuf.Buffer:=LONGWORD(@Buf);
          DbgBuf.Len:=108;
          DbgBuf.Index:=0;
          DbgBuf.cmd:=DBG_C_READCOREGS;
          result:=DosDebug(DbgBuf)=DBG_N_SUCCESS;
     END;
END;

{Writes register set}
FUNCTION PutCoproRegisterSet(VAR Buf:TCoproBuf):BOOLEAN;
VAR DbgBuf:TDbgBuf;
BEGIN
     DbgBuf.PID:=SessPID;
     DbgBuf.TID:=0; {active thread}
     DbgBuf.Value:=1;
     DbgBuf.Buffer:=LONGWORD(@Buf);
     DbgBuf.Len:=108;
     DbgBuf.Index:=0;
     DbgBuf.cmd:=DBG_C_WRITECOREGS;
     result:=DosDebug(DbgBuf)=DBG_N_SUCCESS;
END;

{$HINTS OFF}
PROCEDURE SetWatchHwnd(w,f:HWND);
BEGIN
     WatchHwnd:=0{w};
     WatchFrame:=0{f};
END;

PROCEDURE SetRegHwnd(w,f:HWND);
BEGIN
     RegHwnd:=0{w};
     RegFrame:=0{f};
END;

PROCEDURE SetProjectHwnd(w,f:HWND);
BEGIN
     ProjectHwnd:=0{w};
     ProjectFrame:=0{f};
END;
{$HINTS ON}

FUNCTION PutRegisterSet(VAR Buf:TDbgBuf):BOOLEAN;
BEGIN
     Buf.PID:=SessPID;
     Buf.TID:=0; {active thread}
     Buf.cmd:=DBG_C_WRITEREG;
     result:=DosDebug(Buf)=DBG_N_SUCCESS;
END;

FUNCTION GetProcTermResult:LONGWORD;
BEGIN
     GetProcTermResult:=ProcTermResult;
END;

{$IFDEF WIN32}
Const MaxWin32DbgEvents=4;

Var Win32DbgEvents:Array[1..MaxWin32DbgEvents] Of LongWord;
         {DBG_C_GO
         DBG_C_STOP
         DBG_C_SSTEP
         DBG_C_STEPINTO}
    MainDbgThread:LongWord;
    MainInitOk:Boolean;
    MainInitEvent:LongWord;

Function MainDbgEvents(dummy:LongInt):LongInt;
Var Index:LongInt;
Begin
     MainInitOk:=StartDebuggee(DebuggeeName,DebuggeeArgs);
     //post completion of initialization
     SetEvent(MainInitEvent);

     //enter a loop to query debug messages
     While True Do
     Begin
          Index:=WaitForMultipleObjects(MaxWin32DbgEvents,Win32DbgEvents[1],False,INFINITE)+1;
          Case Index Of
             1: //DBG_C_GO
             Begin
                  DebugRun(0);
             End;
             2: //DBG_C_STOP
             Begin
                  DebugStop(0);
             End;
             3: //DBG_C_SSTEP
             Begin
                  DebugSingleStep(0);
             End;
             4: //DBG_C_STEPINTO
             Begin
                  DebugStepInto(0);
             End;
          End; //case
     End;
End;

Function Win32StartDebuggee:Boolean;
Var t:LongInt;
    id:LongWord;
    SA:Security_Attributes;
Begin
     //Create events
     SA.nLength:=sizeof(SA);
     SA.lpSecurityDescriptor:=Nil;
     SA.bInheritHandle:=True;
     For t:=1 To MaxWin32DbgEvents Do
     Begin
        Win32DbgEvents[t]:=CreateEvent(SA,False,False,Nil);
     End;
     MainInitEvent:=CreateEvent(SA,False,False,Nil);

     //Create Main debugger thread
     MainInitOk:=False;
     MainDbgThread:=CreateThread(Nil,128000,@MainDbgEvents,Nil,0,id);
     //Wait for debugger to complete initialization
     WaitForSingleObject(MainInitEvent,INFINITE);
     CloseHandle(MainInitEvent);
     Result:=MainInitOk;
End;
{$ENDIF}

FUNCTION DebugLoad(s,param:STRING;CPUAvailProc:POINTER;
                   ahwnd,hwndFrame:HWND;ahmq,ahab:LONGWORD):BOOLEAN;

{$IFDEF WIN32}
Var t:LongInt;
{$ENDIF}

BEGIN
     IF CPUAvailProc<>NIL THEN IsCPUAvail:=CPUAvailProc;
     ShowAnsiRef:=FALSE;
     PostMode:=1;
     InputLocked:=FALSE;
     ProcTermResult:=0;
     result:=FALSE;
     {$IFDEF OS2}
     BreakAtStart:=FALSE;
     {$ENDIF}
     BreakAtStartAddr:=0;
     DebuggeeName:=s;
     DebuggeeArgs:=Param;
     UpcaseStr(DebuggeeName);
     NextDbgBreakAddr:=0;
     NextDbgBreakTyp:=0;
     SymBuffer:=NIL;
     SymBufferLen:=0;
     StartEIPLinear:=0;
     StartEIPSourceLine:=0;
     StartEIPSourceFile:='';
     WorkThreadID:=0;
     BreakPoints:=NIL;
     FreeWatchPoints;
     Serverhwnd:=ahwnd;
     ServerFrameWin:=hwndFrame;
     Serverhmq:=ahmq;
     Serverhab:=ahab;
     WatchHwnd:=0;
     WatchFrame:=0;
     RegHwnd:=0;
     RegFrame:=0;
     ProjectHwnd:=0;
     ProjectFrame:=0;
     {$IFDEF OS2}
     ModulesLoaded:=NIL;
     {$ENDIF}
     DebugMode:=Dbg_Mode_LinesOnly;
     RetryTheExcept:=FALSE;
     {$IFDEF WIN32}
     MainDbgThread:=0;
     For t:=1 To MaxWin32DbgEvents Do Win32DbgEvents[t]:=0;
     ModulesLoaded:=Nil;
     {$ENDIF}
     IF GetDebugInfo(DebuggeeName) THEN
     BEGIN
          {$IFDEF OS2}
          IF not StartDebuggee(DebuggeeName,DebuggeeArgs) THEN
          BEGIN
               result:=FALSE;
               exit;
          END;
          result:=TRUE;
          {$ENDIF}
          {$IFDEF WIN32}
          Result:=Win32StartDebuggee;
          {$ENDIF}
     END
     ELSE
     BEGIN
          DbgReturn.ErrStr:='No debug information found';
          result:=FALSE;  {No debug info}
     END;
END;

CONST XCPT_INTERNAL_RTL=$E0000000;
      EXCEPTION_INTERNAL_RTL         =$E0000000;

PROCEDURE HandleWatchPoint;
VAR Source:STRING;
    Line:WORD;
    Module:PModuleInfo;
    Item:PWatchPoint;
    Address:LONGWORD;

{$IFDEF OS2}
    rc:LONGINT;
{$ENDIF}

LABEL ok;
BEGIN
     //Look if present
     Item:=WatchPoints;
     WHILE Item<>NIL DO
     BEGIN
          IF Item^.Id=DbgBuf.Index THEN goto ok;
          Item:=Item^.Next;
     END;

     exit; //not found
ok:
    //set the WatchPoint again because it was cleared

    Address:=DbgBuf.Addr;

    {$IFDEF OS2}
    DbgBuf.Cmd := DBG_C_SetWatch;
    DbgBuf.Pid := SessPid;
    DbgBuf.Tid := 0;
    DbgBuf.Addr:= Item^.Address;
    DbgBuf.Len := Item^.Len;
    DbgBuf.Index:=0;
    DbgBuf.Value := Item^.Flags OR 2;  //local watchpoint
    rc := DosDebug(DbgBuf);
    IF rc<>0 THEN  DebuggerFatalError('Error while DBG_C_SETWATCH'
                                       +' (Code:'+tostr(rc)+')');
    Item^.Id:=DbgBuf.Index;
    {$ENDIF}

    SearchLineNum(Address,TRUE,Source,Line,Module);
    Dbgreturn.Source:=Source;
    Dbgreturn.Line:=Line;
    Dbgreturn.ModuleInfo:=Module;

    PostAndWaitMsg(DBG_N_WATCHPOINT,'Watchpoint hit !');
END;

//Bei nderungen auch Projects ndern !
CONST MaxRTLXcpts=30;
CONST RTLXcpts:ARRAY[1..MaxRtlXcpts] OF STRING [20]=
            (
             'Exception',
             'EAbort',
             'EAccessDenied',
             'EConvertError',
             'EDiskFull',
             'EDivByZero',
             'EEndOfFile',
             'EFault',
             'EFileNotFound',
             'EGPFault',
             'EInOutError',
             'EIntError',
             'EIntOverFlow',
             'EInvalidCast',
             'EInvalidFileName',
             'EInvalidHeap',
             'EInvalidInput',
             'EInvalidOp',
             'EInvalidOpCode',
             'EInvalidPointer',
             'EMathError',
             'EOutOfMemory',
             'EOverflow',
             'EPageFault',
             'EProcessorException',
             'ERangeError',
             'ETooManyOpenFiles',
             'EUnderflow',
             'EVariantError',
             'EZeroDivide'
            );

CONST MaxSPCCXcpts=22;
CONST SPCCXcpts:ARRAY[1..MaxSPCCXcpts] OF STRING [20]=
            (
             'EBitsError',
             'EDataBaseError',
             'EIniFileError',
             'EInvalidBitmap',
             'EInvalidCursor',
             'EInvalidIcon',
             'EListError',
             'EListBoxIndexError',
             'EListViewError',
             'EMemoIndexError',
             'EOutlineError',
             'EOutlineIndexError',
             'EOutlineNodeError',
             'EPrinter',
             'ESCUError',
             'ESQLError',
             'EStreamCreateError',
             'EStreamOpenError',
             'EStreamReadError',
             'EStreamSeekError',
             'EStreamWriteError',
             'EStringListError'
            );

VAR
   RTLExceptions,SPCCExceptions:LONGWORD;

PROCEDURE DbgSetExceptions(RTL,SPCC:LONGWORD);
BEGIN
     RTLExceptions:=RTL;
     SPCCExceptions:=SPCC;
END;

{$IFDEF WIN32}
Function MapOS2Exception(Code:LongInt):LongInt;
Begin
  Case Code Of
     EXCEPTION_ACCESS_VIOLATION:Result:=XCPT_ACCESS_VIOLATION;
     //EXCEPTION_DATATYPE_MISALIGNMENT:Result:=XCPT_DATATYPE_MISALIGNMENT;
     EXCEPTION_BREAKPOINT:Result:=XCPT_BREAKPOINT;
     EXCEPTION_SINGLE_STEP:Result:=XCPT_SINGLE_STEP;
     EXCEPTION_ARRAY_BOUNDS_EXCEEDED:Result:=XCPT_ARRAY_BOUNDS_EXCEEDED;
     EXCEPTION_FLT_DENORMAL_OPERAND:Result:=XCPT_FLOAT_DENORMAL_OPERAND;
     EXCEPTION_FLT_DIVIDE_BY_ZERO:Result:=XCPT_FLOAT_DIVIDE_BY_ZERO;
     EXCEPTION_FLT_INEXACT_RESULT:Result:=XCPT_FLOAT_INEXACT_RESULT;
     EXCEPTION_FLT_INVALID_OPERATION:Result:=XCPT_FLOAT_INVALID_OPERATION;
     EXCEPTION_FLT_OVERFLOW:Result:=XCPT_FLOAT_OVERFLOW;
     EXCEPTION_FLT_STACK_CHECK:Result:=XCPT_FLOAT_STACK_CHECK;
     EXCEPTION_FLT_UNDERFLOW:Result:=XCPT_FLOAT_UNDERFLOW;
     EXCEPTION_INT_DIVIDE_BY_ZERO:Result:=XCPT_INTEGER_DIVIDE_BY_ZERO;
     EXCEPTION_INT_OVERFLOW:Result:=XCPT_INTEGER_OVERFLOW;
     EXCEPTION_PRIV_INSTRUCTION:Result:=XCPT_PRIVILEGED_INSTRUCTION;
     EXCEPTION_IN_PAGE_ERROR:Result:=XCPT_IN_PAGE_ERROR;
     EXCEPTION_ILLEGAL_INSTRUCTION:Result:=XCPT_ILLEGAL_INSTRUCTION;
     EXCEPTION_NONCONTINUABLE_EXCEPTION:Result:=XCPT_NONCONTINUABLE_EXCEPTION;
     EXCEPTION_STACK_OVERFLOW:Result:=XCPT_BAD_STACK;
     EXCEPTION_INVALID_DISPOSITION:Result:=XCPT_INVALID_DISPOSITION;
     EXCEPTION_GUARD_PAGE:Result:=XCPT_GUARD_PAGE_VIOLATION;
     CONTROL_C_EXIT:Result:=XCPT_SIGNAL;
     EXCEPTION_INTERNAL_RTL:Result:=XCPT_INTERNAL_RTL;
     Else Result:=XCPT_GUARD_PAGE_VIOLATION;
  End; //case
End;
{$ENDIF}

FUNCTION HandleException:Boolean;

{$IFDEF WIN32}
Type
  PDRs=^TDRs;
  TDRs=Array[0..3] Of LongWord;
{$ENDIF}

VAR SaveNextDbgBreakAddr,SaveNextDbgBreakTyp:ULONG;
    TheExceptionNum:LONGWORD;
    TheBuffer:LONGWORD;
    s,s1,TheExcptText,TheExcptClassName:STRING;
    ExcptDbgBuf:TDbgBuf;
    ExcptType:ULONG;
    ExcptBuffer:ULONG;
    Module:PModuleInfo;
    p,t:LONGWORD;
    NextAction:LONGWORD;

    {$IFDEF OS2}
    TheException:PEXCEPTIONREPORTRECORD;
    TheContext:PCONTEXTRECORD;
    Context:CONTEXTRECORD;
    low,hiw:LONGWORD;
    {$ENDIF}

    {$IFDEF WIN32}
    TheException:PEXCEPTION_RECORD;
    TheContext:Pointer;
    CX:CONTEXT;
    aPDRS:PDRs;
    {$ENDIF}

LABEL l;
BEGIN
     Result:=False; //dont stop
     TheExceptionNum:=0;
     LastExcptTID:=DbgBuf.TID;
     LastExcptAddr:=DbgBuf.Addr;
     ExcptType:=DbgBuf.Value;
     ExcptBuffer:=DbgBuf.Buffer;
     TheException:=POINTER(ExcptBuffer);
     TheContext:=Pointer(DbgBuf.Len);
     NextDbgBreakAddr:=0;
     NextDbgBreakTyp:=0;
     {$IFDEF WIN32}
     TheExceptionNum:=DbgBuf.Index;
     ExcptBuffer:=TheExceptionNum;
     {$ENDIF}

     {Stop debuggee}
     {$IFDEF OS2}
     IF ExcptType<>DBG_X_FIRST_CHANCE THEN
     BEGIN
        ExcptDbgBuf:=DbgBuf;
        DbgBuf.Tid:=LastExcptTID;
        DbgBuf.Value:=XCPT_CONTINUE_STOP;
        DebugCommand(DBG_C_CONTINUE,'STOP AFTER STEP EXCPT');
        HandleNotifications;
        DbgBuf:=ExcptDbgBuf;
     END;
     {$ENDIF}

     TheExcptClassName:='';
     IF ExcptType=DBG_X_FIRST_CHANCE THEN
     BEGIN
          TheBuffer:=ExcptBuffer;
          ExcptDbgBuf:=DbgBuf;

          {$IFDEF OS2}
          DbgBuf.Addr:=TheBuffer;
          DebugCommand(DBG_C_READMEM,'READ MEM');
          HandleNotifications;
          low:=DbgBuf.Value;

          DbgBuf.Addr:=TheBuffer+2;
          DebugCommand(DBG_C_READMEM,'READ MEM');
          HandleNotifications;
          hiw:=DbgBuf.Value;

          DbgBuf:=ExcptDbgBuf;
          TheExceptionNum:=low+(hiw SHL 16);
          {$ENDIF}

          /****************************************************************************/
          /* Now, read the "real" register values into AppPTB. DosDebug gives us      */
          /* a bogus set of registers so we have to patch them up.                    */
          /****************************************************************************/
          {$IFDEF OS2}
          p:=LONGWORD(TheContext);
          DbgBuf.Addr:=p;
          DbgBuf.Buffer:=LongWord(@CONTEXT);
          DbgBuf.Len:=sizeof(CONTEXTRECORD);
          DebugCommand(DBG_C_READMEMBUF,'READ MEM BUF');
          HandleNotifications;
          RetryExceptRegBuf:=ExcptDbgBuf;
          WITH RetryExceptRegBuf DO
          BEGIN
               EAX:=Context.ctx_RegEax;
               EBX:=Context.ctx_RegEbx;
               ECX:=Context.ctx_RegEcx;
               EDX:=Context.ctx_RegEdx;
               ESI:=Context.ctx_RegEsi;
               EDI:=Context.ctx_RegEdi;
               ESP:=Context.ctx_RegEsp;
               EBP:=Context.ctx_RegEbp;
               EIP:=Context.ctx_RegEip;
               CS:=Context.ctx_SegCs;
               DS:=Context.ctx_SegDs;
               ES:=Context.ctx_SegEs;
               FS:=Context.ctx_SegFs;
               GS:=Context.ctx_SegGs;
               SS:=Context.ctx_SegSs;
               EFlags:=Context.ctx_EFlags;
          END;
          Move(Context.ctx_env[0],RetryExceptCoproBuf,sizeof(TCoproBuf));
          {$ENDIF}
          {$IFDEF WIN32}
          GetRegisterSet(RetryExceptRegBuf);
          RetryExceptRegBuf.EIP:=LastExcptAddr;
          PutRegisterSet(RetryExceptRegBuf);
          GetCoproRegisterSet(RetryExceptCoproBuf);
          {$ENDIF}

          DbgBuf:=ExcptDbgBuf;

          IF TheExceptionNum=XCPT_INTERNAL_RTL THEN
          BEGIN
               ExcptDbgBuf:=DbgBuf;

               {$IFDEF OS2}
               p:=LONGWORD(TheException);
               //get exception address from extra parameters
               DbgBuf.Addr:=p+20;
               DebugCommand(DBG_C_READMEM,'READ MEM');
               HandleNotifications;
               low:=DbgBuf.Value;

               DbgBuf.Addr:=p+22;
               DebugCommand(DBG_C_READMEM,'READ MEM');
               HandleNotifications;
               hiw:=DbgBuf.Value;

               LastExcptAddr:=low+(hiw SHL 16);
               {$ENDIF}
               {$IFDEF WIN32}
               LastExcptAddr:=TheException^.ExceptionInformation[0];
               {$ENDIF}

               //get exception text from extra parameters
               p:=0;
               {$IFDEF OS2}
               p:=LONGWORD(TheException);
               DbgBuf.Addr:=p+24;
               DebugCommand(DBG_C_READMEM,'READ MEM');
               HandleNotifications;
               low:=DbgBuf.Value;

               DbgBuf.Addr:=p+26;
               DebugCommand(DBG_C_READMEM,'READ MEM');
               HandleNotifications;
               hiw:=DbgBuf.Value;

               p:=low+(hiw SHL 16);
               {$ENDIF}
               {$IFDEF WIN32}
               p:=TheException^.ExceptionInformation[1];
               {$ENDIF}

               TheExcptText:='';
               IF p<>0 THEN
               BEGIN
                    DbgBuf.Addr:=p;
                    DbgBuf.Buffer:=LONGWORD(@TheExcptText);
                    DbgBuf.Len:=254;
                    DebugCommand(DBG_C_READMEMBUF,'READ MEMBUF');
                    HandleNotifications;
               END;

               //get exception classname
               p:=0;
               {$IFDEF OS2}
               p:=LONGWORD(TheException);
               DbgBuf.Addr:=p+28;
               DebugCommand(DBG_C_READMEM,'READ MEM');
               HandleNotifications;
               low:=DbgBuf.Value;

               DbgBuf.Addr:=p+30;
               DebugCommand(DBG_C_READMEM,'READ MEM');
               HandleNotifications;
               hiw:=DbgBuf.Value;

               p:=low+(hiw SHL 16);
               {$ENDIF}

               IF p<>0 THEN
               BEGIN
                    DbgBuf.Addr:=p;
                    DbgBuf.Buffer:=LONGWORD(@TheExcptClassName);
                    DbgBuf.Len:=254;
                    DebugCommand(DBG_C_READMEMBUF,'READ MEMBUF');
                    HandleNotifications;
               END;

               DbgBuf:=ExcptDbgBuf;
          END;

          {$IFDEF WIN32}
          //Test if exception was generated due to data breakpoint
          If TheExceptionNum=XCPT_SINGLE_STEP Then
          Begin
              FillChar(CX,sizeof(CX),0);
              CX.ContextFlags := CONTEXT_DEBUG_REGISTERS;
              If GetThreadContext(SessThreadHandle,CX) Then
              Begin
                   If (CX.DR6 and $0f)<>0 Then
                    If (CX.DR6 and (1 shl 14))=0 Then //kein Single step
                   Begin
                        DbgBuf.Index:=0;
                        DbgBuf.Addr:=LastExcptAddr;
                        If (((CX.DR6 And 1)<>0)And((CX.DR7 And 3)<>0)) Then DbgBuf.Index:=1
                        Else If (((CX.DR6 And 2)<>0)And((CX.DR7 And 12)<>0)) Then DbgBuf.Index:=2
                        Else If (((CX.DR6 And 4)<>0)And((CX.DR7 And 48)<>0)) Then DbgBuf.Index:=3
                        Else If (((CX.DR6 And 8)<>0)And((CX.DR7 And 192)<>0)) Then DbgBuf.Index:=4;
                        aPDRs:=@CX.DR0;
                        If DbgBuf.Index>0 Then
                        Begin
                            HandleWatchpoint;
                            Result:=True; //stop execution
                            exit;
                        End;
                   End;
                   CX.DR6:=CX.DR6 And not (1 shl 14);
                   SetThreadContext(SessThreadHandle,CX);
              End;
          End;
          {$ENDIF}
     END;

     SearchLineNum(LastExcptAddr,TRUE,LastExcptSource,LastExcptLine,Module);
     Dbgreturn.Source:=LastExcptSource;
     Dbgreturn.Line:=LastExcptLine;
     Dbgreturn.ModuleInfo:=Module;

     CASE ExcptType OF
         DBG_X_PRE_FIRST_CHANCE:
         BEGIN
              CASE ExcptBuffer OF
                 XCPT_BREAKPOINT:
                 BEGIN
                      IF not UnsetBreakPoint(LastExcptAddr,DbgReturn.BreakSource) THEN
                      BEGIN
                           {$IFDEF WIN32}
                           PostAndWaitMsg(DBG_N_ERROR,
                           'HandleException:Could not unset breakpoint at '+ToHex(LastExcptAddr));
                           {$ENDIF}
                      END
                      ELSE
                      BEGIN
                           //mark "real" breakpoint to be reset after go or sstep !
                           IF DbgReturn.BreakSource=0 THEN
                           BEGIN
                                NextDbgBreakAddr:=LastExcptAddr;
                                NextDbgBreakTyp:=DbgReturn.BreakSource;
                           END;
                      END;

                      DbgReturn.Data:=ExcptBuffer;
                      IF DbgReturn.BreakSource <> 1 THEN {real Breakpoint}
                      PostAndWaitMsg(DBG_N_EXCEPTION,
                        'Pre First chance Breakpoint Exception at '+ToHex(LastExcptAddr)+
                         ' in '+LastExcptSource+'('+tostr(LastExcptLine)+')');
                 END;
                 XCPT_SINGLE_STEP:
                 BEGIN
                      DbgReturn.Data:=ExcptBuffer;

                      {PostAndWaitMsg(DBG_N_EXCEPTION,
                        'Pre First chance Single step Exception at '+ToHex(LastExcptAddr)+
                         ' in '+LastExcptSource+'('+tostr(LastExcptLine)+')');}
                 END;
                 ELSE PostAndWaitMsg(DBG_N_ERROR,
                       'Undefined Pre first exception notification');
              END; {case}
         END;
         DBG_X_FIRST_CHANCE:
         BEGIN
              DbgReturn.data:=TheExceptionNum;

              CASE TheExceptionNum OF
                XCPT_FATAL_EXCEPTION:s:='Fatal Exception';
                //XCPT_SEVERITY_CODE:s:='Severity code';
                XCPT_CUSTOMER_CODE:s:='Custumer code';
                XCPT_FACILITY_CODE:s:='Facility code';
                XCPT_EXCEPTION_CODE:s:='Exception code';
                XCPT_UNKNOWN_ACCESS:s:='Unknown access';
                XCPT_READ_ACCESS:s:='Read Access';
                XCPT_WRITE_ACCESS:s:='Write access';
                XCPT_EXECUTE_ACCESS:s:='Excecute access';
                XCPT_SPACE_ACCESS:s:='Space access';
                XCPT_LIMIT_ACCESS:s:='Limit access';
                XCPT_DATA_UNKNOWN:s:='Data unkown';
                //XCPT_SIGNAL_INTR:s:='Signal Intr';
                //XCPT_SIGNAL_KILLPROC:s:='Signal KillProc';
                //XCPT_SIGNAL_BREAK:s:='Signal Break';
                XCPT_GUARD_PAGE_VIOLATION:goto l{s:='Guard Page violation'};
                XCPT_UNABLE_TO_GROW_STACK:s:='Unable to grow stack';
                XCPT_DATATYPE_MISALIGNMENT:s:='Data misalignment';
                XCPT_BREAKPOINT:
                BEGIN
                      s:='Breakpoint';
                      {$IFDEF WIN32} //Win32 doesnt get pre first chance exceptions
                      IF not UnsetBreakPoint(LastExcptAddr,DbgReturn.BreakSource) THEN
                      BEGIN
                           PostAndWaitMsg(DBG_N_ERROR,
                            'HandleException:Could not unset breakpoint at '+ToHex(LastExcptAddr));
                      END
                      ELSE
                      BEGIN
                           //mark "real" breakpoint to be reset after go or sstep !
                           IF DbgReturn.BreakSource=0 THEN
                           BEGIN
                                NextDbgBreakAddr:=LastExcptAddr;
                                NextDbgBreakTyp:=DbgReturn.BreakSource;
                           END;
                      END;

                      DbgReturn.Data:=ExcptBuffer;
                      IF DbgReturn.BreakSource <> 1 THEN {real Breakpoint}
                         s:='First chance Breakpoint Exception at '+ToHex(LastExcptAddr)+
                            ' in '+LastExcptSource+'('+tostr(LastExcptLine)+')'
                      Else exit; //ignore
                      {$ENDIF}
                END;
                XCPT_SINGLE_STEP:
                BEGIN
                     {$IFDEF OS2}
                     s:='Single step';
                     {$ENDIF}
                     {$IFDEF WIN32}
                     DbgReturn.Data:=ExcptBuffer;
                     exit;
                     {$ENDIF}
                END;
                XCPT_ACCESS_VIOLATION:
                BEGIN
                     s:='Access violation';
                     TheExcptClassName:='EGPFault';
                END;
                XCPT_ILLEGAL_INSTRUCTION:
                BEGIN
                     s:='Illegal instruction';
                     TheExcptClassName:='EInvalidOpCode';
                END;
                XCPT_FLOAT_DENORMAL_OPERAND:
                BEGIN
                     s:='Float:Denormal operand';
                     TheExcptClassName:='EMathError';
                END;
                XCPT_FLOAT_DIVIDE_BY_ZERO:
                BEGIN
                     s:='Float:Divide by zero';
                     TheExcptClassName:='EZeroDivide';
                END;
                XCPT_FLOAT_INEXACT_RESULT:
                BEGIN
                     s:='Float:Inexact result';
                     TheExcptClassName:='EMathError';
                END;
                XCPT_FLOAT_INVALID_OPERATION:
                BEGIN
                     s:='Float:Invalid operation';
                     TheExcptClassName:='EInvalidOp';
                END;
                XCPT_FLOAT_OVERFLOW:
                BEGIN
                     s:='Float:Overflow';
                     TheExcptClassName:='EOverflow';
                END;
                XCPT_FLOAT_STACK_CHECK:
                BEGIN
                     s:='Float:Stack check';
                     TheExcptClassName:='EMathError';
                END;
                XCPT_FLOAT_UNDERFLOW:
                BEGIN
                     s:='Float:Underflow';
                     TheExcptClassName:='EUnderflow';
                END;
                XCPT_INTEGER_DIVIDE_BY_ZERO:
                BEGIN
                     s:='Integer divide by zero';
                     TheExcptClassName:='EDivByZero';
                END;
                XCPT_INTEGER_OVERFLOW:
                BEGIN
                     s:='Integer overflow';
                     TheExcptClassName:='EIntOverflow';
                END;
                XCPT_PRIVILEGED_INSTRUCTION:
                BEGIN
                     s:='Privileged instruction';
                     TheExcptClassName:='EInvalidOpCode';
                END;
                XCPT_IN_PAGE_ERROR:s:='In page error';
                XCPT_PROCESS_TERMINATE:s:='Process terminate';
                XCPT_ASYNC_PROCESS_TERMINATE:s:='Async process terminate';
                XCPT_NONCONTINUABLE_EXCEPTION:s:='Noncontinuable exception';
                XCPT_INVALID_DISPOSITION:s:='Invalid disposition';
                XCPT_INVALID_LOCK_SEQUENCE:s:='Invalid lock sequence';
                XCPT_ARRAY_BOUNDS_EXCEEDED:
                BEGIN
                     s:='Array bounds exceeded';
                     TheExcptClassName:='ERangeError';
                END;
                XCPT_B1NPX_ERRATA_02:s:='B1 NPX ErrData_02';
                XCPT_UNWIND:s:='Unwind';
                XCPT_BAD_STACK:s:='Bad Stack';
                XCPT_INVALID_UNWIND_TARGET:s:='Invalid Unwind target';
                XCPT_SIGNAL:s:='Signal';
                //CASE BUG ! XCPT_INTERNAL_RTL:s:=TheExcptText;
                ELSE
                BEGIN
                     IF TheExceptionNum=XCPT_INTERNAL_RTL THEN s:=TheExcptText
                     ELSE
                     BEGIN
                         DbgReturn.NextAction:=A_CONTINUE;
                         goto l; {dont handle unknown exception}
                     END;
                END;
              END; {case}

              DbgReturn.errstr:=s;

              IF TheExcptClassName<>'' THEN //look if we shall handle the exception
              BEGIN
                   UpcaseStr(TheExcptClassName);

                   FOR t:=1 TO MaxRTLXcpts DO
                   BEGIN
                        s1:=RTLXcpts[t];
                        UpcaseStr(s1);
                        IF TheExcptClassName=s1 THEN
                        BEGIN
                             IF RTLExceptions AND (1 SHL (t-1))=0 THEN //don't handle
                             BEGIN
                                  DbgReturn.NextAction:=A_CONTINUE;
                                  goto l;
                             END
                             ELSE break;
                        END;
                   END;

                   FOR t:=1 TO MaxSPCCXcpts DO
                   BEGIN
                        s1:=SPCCXcpts[t];
                        UpcaseStr(s1);
                        IF TheExcptClassName=s1 THEN
                        BEGIN
                             IF SPCCExceptions AND (1 SHL (t-1))=0 THEN //don't handle
                             BEGIN
                                  DbgReturn.NextAction:=A_CONTINUE;
                                  goto l;
                             END
                             ELSE break;
                        END;
                   END;
              END;

              IF TheExceptionNum<>XCPT_PROCESS_TERMINATE THEN RetryTheExcept:=TRUE;
              PostAndWaitMsg(DBG_N_EXCEPTION,'Exception '+s+' at '+
                             ToHex(LastExcptAddr)+
                             ' in '+LastExcptSource+'('+tostr(LastExcptLine)+')');

              {Start debuggee again if requested}
l:
              ExcptDbgBuf:=DbgBuf;
              DbgBuf.Tid:=LastExcptTID;
              NextAction:=DbgReturn.NextAction;
              IF NextAction=A_RETRYXCPT THEN
              BEGIN
                   {$IFDEF OS2}
                   RetryTheExcept:=TRUE;
                   {$ENDIF}
                   {$IFDEF WIN32}
                   RetryTheExcept:=FALSE; //??
                   {$ENDIF}

                   {$IFDEF WIN32}
                   Result:=True; //stop
                   {$ENDIF}
                   {$IFDEF OS2}
                   DbgBuf.Value:=XCPT_CONTINUE_STOP;
                   DebugCommand(DBG_C_CONTINUE,'STOP AFTER STEP EXCPT');
                   HandleNotifications;
                   {$ENDIF}
                   //NextDbgBreak is modified by IDE, so save it !
                   SaveNextDbgBreakAddr:=NextDbgBreakAddr;
                   SaveNextDbgBreakTyp:=NextDbgBreakTyp;
                   PostAndWaitMsg(DBG_N_SSTEPCOMPLETED,'Examine exception');
                   NextDbgBreakAddr:=SaveNextDbgBreakAddr;
                   NextDbgBreakTyp:=SaveNextDbgBreakTyp;
              END
              ELSE IF NextAction=A_ABORTXCPT THEN
              BEGIN
                   RetryTheExcept:=FALSE;
                   {$IFDEF WIN32}
                   Result:=True; //stop
                   {$ENDIF}
                   {$IFDEF OS2}
                   UnlockInput;
                   DbgBuf.Value:=XCPT_CONTINUE_STOP;
                   DebugCommand(DBG_C_CONTINUE,'STOP AFTER STEP EXCPT');
                   HandleNotifications;
                   {$ENDIF}
                   PostAndWaitMsg(DBG_N_PROCTERM,'Process terminated due to exception');
                   PostAndWaitMsg(DBG_N_SUCCESS,'Program terminated.');
              END
              ELSE //A_RUNXCPT,A_CONTINUE
              BEGIN
                   RetryTheExcept:=FALSE;
                   {$IFDEF OS2}
                   UnlockInput;
                   DbgBuf.Value:=XCPT_CONTINUE_SEARCH;
                   DebugCommand(DBG_C_CONTINUE,'CONTINUE AFTER EXCPT');
                   HandleNotifications;
                   {$ENDIF}
                   {$IFDEF WIN32}
                   If ((TheExceptionNum<>XCPT_BREAKPOINT)And(TheExceptionNum<>XCPT_SINGLE_STEP)) Then
                   Begin
                        {If NextAction=A_RUNXCPT Then
                          DebugCommand(DBG_C_CONTINUE,'CONTINUE AFTER EXCPT')
                        Else}
                        Begin
                            //Set Exception handler for the process
                            If ExceptionListAddr<>0 Then
                            Begin
                               GetRegisterSet(RetryExceptRegBuf);
                               RetryExceptRegBuf.EIP:=ExceptionListAddr;
                               RetryExceptRegBuf.EAX:=TheExceptionNum;  //ExceptionCode
                               RetryExceptRegBuf.EBX:=LastExcptAddr;  //ExcptAddr
                               PutRegisterSet(RetryExceptRegBuf);
                            End;
                            DebugCommand(DBG_C_GO,'CONTINUE AFTER EXCCPT');
                        End;
                        Result:=HandleNotifications;
                   End;
                   {$ENDIF}
              END;
              DbgBuf:=ExcptDbgBuf;
         END;
         DBG_X_LAST_CHANCE:
         BEGIN
              DbgReturn.data:=DBG_X_LAST_CHANCE;
              {PostAndWaitMsg(DBG_N_ERROR,
                 'Unhandled last chance exception notification'+
                 ' in '+LastExcptSource+'('+tostr(LastExcptLine)+')');}
              DbgReturn.NextAction:=A_CONTINUE;
              goto l;
         END;
         DBG_X_STACK_INVALID:
         BEGIN
              DbgReturn.Data:=DBG_X_STACK_INVALID;
              PostAndWaitMsg(DBG_N_ERROR,
                 'Unhandled stack invalid exception notification'+
                 ' in '+LastExcptSource+'('+tostr(LastExcptLine)+')');
              DbgReturn.NextAction:=A_CONTINUE;
              goto l;
         END;
         ELSE
         BEGIN
              PostAndWaitMsg(DBG_N_ERROR,'Unknown Exception at Linear Address:'+
                    ToHex(LastExcptAddr)+
                   ' in '+LastExcptSource+'('+tostr(LastExcptLine)+')');
              goto l;
         END;
     END; {case}
END;


FUNCTION HandleNotifications:Boolean;

BEGIN
     DbgReturn.msg:=DbgBuf.Cmd;
     Result:=False; //dont stop
     {$IFDEF OS2}
     CASE DbgBuf.Cmd OF
         DBG_N_SUCCESS:;
         DBG_N_ERROR:DebuggerFatalError('Debug error'+tostr(DbgBuf.Value));
         DBG_N_ProcTerm:
         BEGIN
            ProcTermResult:=DbgBuf.Value;
            PostAndWaitMsg(DBG_N_PROCTERM,'Process terminated with rc='+tostr(DbgBuf.Value));
         END;
         DBG_N_Exception:HandleException;
         DBG_N_ModuleLoad:HandleModuleLoad;
         DBG_N_CoError:
           PostAndWaitMsg(DBG_N_CoError,'Coprocessor Error');
         DBG_N_ThreadTerm:;
           {PostAndWaitMsg(DBG_N_THREADTERM,'Thread '+tostr(DbgBuf.tid)+' terminated with rc='+
                                  tostr(DbgBuf.Value));}
         DBG_N_AsyncStop:
           PostAndWaitMsg(DBG_N_ASYNCSTOP,'Asynchronous stop');
         DBG_N_NewProc:
           PostAndWaitMsg(DBG_N_NEWPROC,'Debuggee started new Process with PID '+
                               tostr(DbgBuf.Value));
         DBG_N_AliasFree:
           PostAndWaitMsg(DBG_N_ALIASFREE,'Alias freed');
         DBG_N_Watchpoint:HandleWatchPoint;
         DBG_N_ThreadCreate:HandleThreadCreate;
         DBG_N_ModuleFree:;
         DBG_N_RangeStep:
           PostAndWaitMsg(DBG_N_RANGESTEP,'RangeStep Notification');
     END; {case}
     {$ENDIF}
     {$IFDEF WIN32}
     If DebugEvent.dwDebugEventCode=0 Then
     Begin
          CASE DbgBuf.Cmd OF
             DBG_N_SUCCESS:;
             Else DebuggerFatalError('Debug error'+tostr(DbgBuf.Value));
          END;
     End
     Else
     Begin
          Case DebugEvent.dwDebugEventCode Of
              EXCEPTION_DEBUG_EVENT:
              Begin
                   With DbgBuf,DebugEvent.Exception Do
                   Begin
                        If dwFirstChance<>0 Then Value:=DBG_X_FIRST_CHANCE
                        Else Value:=DBG_X_LAST_CHANCE;
                        TID:=0;
                        Addr:=LongWord(ExceptionRecord.ExceptionAddress);
                        Buffer:=LongWord(@DebugEvent.Exception.ExceptionRecord);
                        Len:=0;   //Context
                        Index:=MapOS2Exception(ExceptionRecord.ExceptionCode); //Exception code
                   End;
                   Result:=HandleException;
              End;
              CREATE_THREAD_DEBUG_EVENT:
              Begin
                   DbgBuf.TID:=DebugEvent.CreateThread.hThread;
                   HandleThreadCreate;
              End;
              CREATE_PROCESS_DEBUG_EVENT:
              Begin
                   PostAndWaitMsg(DBG_N_NEWPROC,'Debuggee started new Process with PID '+
                                  tostr(DebugEvent.CreateProcessInfo.hProcess));
              End;
              EXIT_THREAD_DEBUG_EVENT:;
              EXIT_PROCESS_DEBUG_EVENT:
              Begin
                   ProcTermResult:=DebugEvent.ExitProcess.dwExitCode;
                   PostAndWaitMsg(DBG_N_PROCTERM,'Process terminated with rc='+tostr(DebugEvent.ExitProcess.dwExitCode));
              End;
              LOAD_DLL_DEBUG_EVENT:
              Begin
                   DbgBuf.Value:=DebugEvent.LoadDll.hFile;
                   HandleModuleLoad;
              End;
              UNLOAD_DLL_DEBUG_EVENT:;
              OUTPUT_DEBUG_STRING_EVENT:;
              ELSE DebuggerFatalError('Debug error'+tostr(DbgBuf.Value));
          End; //case
     End;
     {$ENDIF}
END;

PROCEDURE DebugUnload;
VAR m,mdummy:PModuleInfo;
    l,ldummy:PLineNumberInfo;
    ml,mldummy:PModulesLoaded;
    b,bdummy:PBreakPoints;
    p,pdummy:PPublicsInfo;
    s,sdummy,s1,s1dummy:PSymbolsInfo;
    o,odummy:PObjectList;
{$IFDEF WIN32}
    t:LongInt;
{$ENDIF}
BEGIN
     IF SessPID<>0 THEN
     BEGIN
          PostMode:=0;
          DeleteWorkThread(TRUE);
          DebugCommand(DBG_C_TERM,'TERMINATE');
          HandleNotifications;
          WorkThreadID:=0; {!!!}
          SessPID:=0;
          SessHandle:=0;
          {$IFDEF WIN32}
          WatchPtCount:=0;
          {$ENDIF}
          SessThreadHandle:=0;
          SessTID:=0;
     END;

     {reset debugger}

     BreakAtStart:=FALSE;
     BreakAtStartAddr:=0;
     SessID:=0;
     SessPID:=0;
     SessHandle:=0;
     {$IFDEF WIN32}
     WatchPtCount:=0;
     {$ENDIF}
     SessThreadHandle:=0;
     SessTID:=0;
     ServerHwnd:=0;
     ServerFrameWin:=0;
     StartEIPLinear:=0;
     NextDbgBreakAddr:=0;
     NextDbgBreakTyp:=0;
     UnlockInput;

     {$IFDEF WIN32}
     TerminateThread(MainDbgThread,0);
     CloseHandle(MainDbgThread);
     MainDbgThread:=0;
     For t:=1 To MaxWin32DbgEvents Do
     Begin
          CloseHandle(Win32DbgEvents[t]);
          Win32DbgEvents[t]:=0;
     End;
     {$ENDIF}

     {$IFDEF OS2}
     WinShowPointer(HWND_DESKTOP,TRUE);
     {$ENDIF}
     PointerHided:=FALSE;

     {Delete Module info}
     m:=ModuleInfo;
     WHILE m<>NIL DO
     BEGIN
          l:=m^.LineNumberInfo;
          WHILE l<>NIL DO
          BEGIN
               ldummy:=l^.next;
               dispose(l);
               l:=ldummy;
          END;

          p:=m^.PublicsInfo;
          WHILE p<>NIL DO
          BEGIN
               pdummy:=p^.Next;
               IF p^.PublicName<>NIL THEN FreeMem(p^.PublicName,length(p^.PublicName^)+1);
               dispose(p);
               p:=pdummy;
          END;

          s:=m^.SymbolsInfo;
          WHILE s<>NIL DO
          BEGIN
               s1:=s^.Symbols;
               WHILE s1<>NIL DO
               BEGIN
                    s1dummy:=s1^.Next;
                    IF s1^.SymbolName<>NIL THEN
                    BEGIN
                         FreeMem(s1^.SymbolName,length(s1^.SymbolName^)+1);
                    END;
                    dispose(s1);
                    s1:=s1dummy;
               END;
               sdummy:=s^.Next;
               IF s^.SymbolName<>NIL THEN
               BEGIN
                    FreeMem(s^.SymbolName,length(s^.SymbolName^)+1);
               END;
               dispose(s);
               s:=sdummy;
          END;

          IF m^.TypesInfo<>NIL THEN IF m^.TypesLen<>0 THEN
          BEGIN
               FreeMem(m^.TypesInfo,m^.TypesLen);
          END;

          mdummy:=m^.next;
          Dispose(m);
          m:=mdummy;
     END;
     ModuleInfo:=NIL;

     {Delete Modules loaded}
     ml:=ModulesLoaded;
     WHILE ml<>NIL DO
     BEGIN
          o:=ml^.Objects;
          WHILE o<>NIL DO
          BEGIN
               odummy:=o^.Next;
               dispose(o);
               o:=odummy;
          END;
          mldummy:=ml^.next;
          dispose(ml);
          ml:=mldummy;
     END;
     ModulesLoaded:=NIL;

     {Delete Breakpoints}
     b:=BreakPoints;
     WHILE b<>NIL DO
     BEGIN
          bdummy:=b^.next;
          dispose(b);
          b:=bdummy;
     END;
     BreakPoints:=NIL;
     SymBuffer:=NIL;
END;


FUNCTION GetStandardType(VAR value:STRING;Typ:WORD;EXEAddr:ULONG;
                         VAR ValueLen:ULONG;VAR ValueTyp:BYTE):BOOLEAN;
VAR reg:TDbgBuf;
    b:BYTE;
    w:WORD;
    lw:LONGWORD;
    si:SHORTINT;
    i:INTEGER;
    li:LONGINT;
    s:STRING;
    ch:char;
    bo:BOOLEAN;
    cs:CString;
    sing:SINGLE;
    d:DOUBLE;
    e:EXTENDED;
    ValueAddr:PSymByteBuffer;
    pc:^CString;
    pl:^pointer;
    AnsiLen:LONGINT;
LABEL l;
BEGIN
     ValueLen:=0;
     CASE Typ OF
        TT_BYTE:ValueLen:=1;
        TT_WORD:ValueLen:=2;
        TT_LONGWORD:ValueLen:=4;
        TT_SHORTINT:ValueLen:=1;
        TT_INTEGER:ValueLen:=2;
        TT_LONGINT:ValueLen:=4;
        TT_CHAR:ValueLen:=1;
        TT_STRING:ValueLen:=256;
        TT_CSTRING:ValueLen:=256;
        TT_POINTER:ValueLen:=4;
        TT_BOOLEAN:ValueLen:=1;
        TT_WORDBOOL:ValueLen:=2;
        TT_LONGBOOL:ValueLen:=4;
        TT_PROC:ValueLen:=4;
        TT_VAR:ValueLen:=4;
        TT_FILE:ValueLen:=128;
        TT_SINGLE:ValueLen:=4;
        //TT_REAL:ValueLen:=8;
        TT_DOUBLE:ValueLen:=8;
        TT_EXTENDED:ValueLen:=10;
        TT_TEXT:ValueLen:=128;
        TT_ANSISTRING:ValueLen:=4;
        ELSE
        BEGIN
             IF Typ<$ff THEN {Pointer to standard data type}
             BEGIN
                  Typ:=TT_POINTER;
                  ValueLen:=4;
             END;
        END;
     END; {case}
     IF ValueLen<>0 THEN
     BEGIN
          getmem(ValueAddr,ValueLen);
          Reg.Pid:=SessPID;
          Reg.Addr:=EXEAddr;
          Reg.BUFFER:=LONGWORD(ValueAddr);
          Reg.Len:=ValueLen;
          Reg.Cmd:=DBG_C_READMEMBUF;
          DosDebug(Reg);
          IF Reg.cmd<>DBG_N_SUCCESS THEN
          BEGIN
               value:='<Access violation !>';
               FreeMem(ValueAddr,ValueLen);
               valuelen:=0;
               EXEAddr:=0;
               goto l;
          END;
          CASE Typ OF
             TT_BYTE:
             BEGIN
                  move(ValueAddr^[0],b,1);
                  STR(b,value);
             END;
             TT_WORD:
             BEGIN
                  move(ValueAddr^[0],w,2);
                  STR(w,value);
             END;
             TT_LONGWORD:
             BEGIN
                  move(ValueAddr^[0],lw,4);
                  STR(lw,value);
             END;
             TT_SHORTINT:
             BEGIN
                  move(ValueAddr^[0],si,1);
                  STR(si,value);
             END;
             TT_INTEGER:
             BEGIN
                  move(ValueAddr^[0],i,2);
                  STR(i,value);
             END;
             TT_LONGINT:
             BEGIN
                  move(ValueAddr^[0],li,4);
                  STR(li,value);
             END;
             TT_CHAR:
             BEGIN
                  move(ValueAddr^[0],ch,1);
                  value:=#39+ch+#39;
             END;
             TT_STRING:
             BEGIN
                  move(ValueAddr^[0],s,256);
                  value:=#39+s+#39;
             END;
             TT_CSTRING:
             BEGIN
                  move(ValueAddr^[0],cs,256);
                  s:=cs;
                  value:=#39+s+#39;
             END;
             TT_POINTER:
             BEGIN
                  move(ValueAddr^[0],lw,4);
                  IF lw=0 THEN value:='Nil'
                  ELSE value:=tohex(lw);
             END;
             TT_BOOLEAN,TT_WORDBOOL,TT_LONGBOOL:
             BEGIN
                  move(ValueAddr^[0],bo,1);
                  IF bo=FALSE THEN value:='False'
                  ELSE value:='True';
             END;
             TT_PROC:
             BEGIN
                  move(ValueAddr^[0],lw,4);
                  value:=tohex(lw);
             END;
             TT_VAR:
             BEGIN
                  move(ValueAddr^[0],lw,4);
                  value:=tohex(lw);
             END;
             {TT_FILE:ValueLen:=128;
             TT_TEXT:ValueLen:=128;}
             TT_SINGLE:
             BEGIN
                  move(ValueAddr^[0],sing,4);
                  STR(sing,value);
             END;
             TT_DOUBLE {,TT_REAL}:
             BEGIN
                  move(ValueAddr^[0],d,8);
                  STR(d,value);
             END;
             TT_EXTENDED:
             BEGIN
                  move(ValueAddr^[0],e,10);
                  STR(e,value);
             END;
             TT_ANSISTRING:
             BEGIN
                  pl:=pointer(ValueAddr);
                  IF pl^=nil THEN
                  BEGIN
                       IF ShowAnsiRef THEN Value:='[Unassigned] '#39#39 {empty}
                       ELSE Value:=#39#39;
                  END
                  ELSE
                  BEGIN
                       {get reference count of ansi}
                       Reg.Pid:=SessPID;
                       Reg.Addr:=longword(pl^)-8;
                       Reg.BUFFER:=LONGWORD(@AnsiLen);
                       Reg.Len:=4;
                       Reg.Cmd:=DBG_C_READMEMBUF;
                       DosDebug(Reg);
                       IF Reg.cmd<>DBG_N_SUCCESS THEN
                       BEGIN
                           value:='<Access violation in Ansi string !>';
                           FreeMem(ValueAddr,ValueLen);
                           FreeMem(pc,255);
                           valuelen:=0;
                           EXEAddr:=0;
                           goto l;
                       END;

                       {get length of ansi}
                       getmem(pc,255);
                       Reg.Pid:=SessPID;
                       Reg.Addr:=longword(pl^)-4;
                       Reg.BUFFER:=LONGWORD(@li);
                       Reg.Len:=4;
                       Reg.Cmd:=DBG_C_READMEMBUF;
                       DosDebug(Reg);
                       IF Reg.cmd<>DBG_N_SUCCESS THEN
                       BEGIN
                           value:='<Access violation in Ansi string !>';
                           FreeMem(ValueAddr,ValueLen);
                           FreeMem(pc,255);
                           valuelen:=0;
                           EXEAddr:=0;
                           goto l;
                       END;
                       Reg.Pid:=SessPID;
                       Reg.Addr:=longword(pl^);
                       Reg.BUFFER:=LONGWORD(pc);
                       Reg.Len:=li;
                       Reg.Cmd:=DBG_C_READMEMBUF;
                       DosDebug(Reg);
                       IF Reg.cmd<>DBG_N_SUCCESS THEN
                       BEGIN
                           value:='<Access violation in Ansi string !>';
                           FreeMem(ValueAddr,ValueLen);
                           FreeMem(pc,255);
                           valuelen:=0;
                           EXEAddr:=0;
                           goto l;
                       END;
                       Value:=#39+pc^+#39;
                       IF ShowAnsiRef THEN value:='['+tostr(AnsiLen)+'] '+Value;
                  END;
             END;
             ELSE Value:='<Expression not supported>';
          END; {case}
          FreeMem(ValueAddr,ValueLen);
l:
          GetStandardType:=TRUE;
          ValueTyp:=Typ;
     END
     ELSE GetStandardType:=FALSE;
END;

FUNCTION GetTypeOffset(Module:PModuleInfo;Typ:WORD;VAR TypOffset:LONGINT):STRING;
VAR count:WORD;
    TypInfo:PTypesInfo;
    akt,max:LONGINT;
    w:WORD;
BEGIN
     IF Typ<512 THEN
     BEGIN
          GetTypeOffset:=' No valid type';
          exit; {no valid type}
     END;
     TypInfo:=Module^.TypesInfo;
     IF TypInfo=NIL THEN
     BEGIN
          GetTypeOffset:=' No types available';
          exit;  {no types available}
     END;
     akt:=0;
     max:=Module^.TypesLen;
     count:=512;
     WHILE akt<max DO
     BEGIN
          IF count=Typ THEN
          BEGIN
               GetTypeOffset:='';
               TypOffset:=akt;
               exit;
          END;
          w:=TypInfo^[akt]+256*TypInfo^[akt+1]; {Get len of this entry}
          inc(akt,w+2);  {next type entry}
          inc(Count);
     END;
     GetTypeOffset:=' Type not found';
END;

PROCEDURE SplitExpr(VAR Variable,Expr:STRING);
VAR t:BYTE;
LABEL l;
BEGIN
     FOR t:=1 TO length(Expr) DO
     BEGIN
          CASE Expr[t] OF
            'A'..'Z','0'..'9','_':;
            ELSE
            BEGIN
                 variable:=copy(Expr,1,t-1);
                 delete(Expr,1,t-1);
                 goto l;
            END;
          END; {case}
     END;
     Variable:=Expr;
     Expr:='';
l:
END;

FUNCTION GetRecordName(VAR name:STRING;TypInfo:PTypesInfo;
                       akt:LONGINT;VAR lw:LONGINT;VAR Typ:WORD):BOOLEAN;
VAR result:BOOLEAN;
    tlen:WORD;
    countsub,count,t:WORD;
    toffs:LONGINT;
    ps:^STRING;
    s:STRING;
    pl:^LONGINT;
LABEL l;
BEGIN
     result:=FALSE;
     tlen:=TypInfo^[akt]+256*TypInfo^[akt+1];
     countsub:=TypInfo^[akt+8]+256*typInfo^[akt+9];

     inc(akt,tlen+2);  {to types descr}
     toffs:=akt;
     tlen:=TypInfo^[akt]+256*TypInfo^[akt+1];
     inc(akt,tlen+2+4);  {to name descr and first entry}

     FOR count:=1 TO countsub DO
     BEGIN
          IF TypInfo^[akt]<>$82 THEN goto l;  {error}
          ps:=@TypInfo^[akt+1];
          s:=ps^;
          UpcaseStr(s);
          IF s=name THEN {found}
          BEGIN
               inc(akt,2+length(s));
               IF TypInfo^[akt]<>$86 THEN goto l;  {error}
               pl:=@TypInfo^[akt+1];
               {get type}
               akt:=toffs+4;
               FOR t:=1 TO count-1 DO
               BEGIN
                    IF TypInfo^[akt]<>$83 THEN goto l; {error}
                    inc(akt,3);
               END;
               IF TypInfo^[akt]<>$83 THEN goto l; {error}
               lw:=pl^;
               Typ:=TypInfo^[akt+1]+256*TypInfo^[akt+2];
               result:=TRUE;
               goto l;  {Success !!}
          END;
          inc(akt,7+length(s));  {next entry}
     END;
l:
     GetRecordName:=result;
END;

FUNCTION GetEnumName(VAR name:STRING;TypInfo:PTypesInfo;akt:LONGINT):BOOLEAN;
VAR
    tlen:WORD;
    countsub,count:WORD;
    toffs:LONGINT;
    ps:^STRING;
    pl:^LONGINT;
    number:LONGINT;
    c:INTEGER;
    result:BOOLEAN;
LABEL l;
BEGIN
     result:=FALSE;
     VAL(name,number,c);
     IF c<>0 THEN goto l;  {some error}

     tlen:=TypInfo^[akt]+256*TypInfo^[akt+1];
     countsub:=TypInfo^[akt+8]+256*typInfo^[akt+9];

     inc(akt,tlen+2);  {to types descr}
     toffs:=akt;
     tlen:=TypInfo^[akt]+256*TypInfo^[akt+1];
     inc(akt,tlen+2+4);  {to name descr and first entry}

     FOR count:=1 TO countsub DO
     BEGIN
          IF TypInfo^[akt]<>$82 THEN goto l;  {error}
          ps:=@TypInfo^[akt+1];
          inc(akt,2+length(ps^));
          pl:=@TypInfo^[akt+1];
          IF pl^=number THEN {found}
          BEGIN
               IF TypInfo^[akt]<>$86 THEN goto l;  {error}
               name:=ps^;
               result:=TRUE;
               goto l;  {Success !!}
          END;
          inc(akt,5);  {next entry}
     END;
l:
     GetEnumName:=result;
END;


FUNCTION GetTypesSize(typ:WORD;Module:PModuleInfo;VAR TheTypOffset:LONGINT):ULONG;
VAR result:ULONG;
    TypTable:PTypesInfo;
    ttyp:WORD;
    ul:^ULONG;
LABEL l;
BEGIN
     result:=0;
     CASE Typ OF
        TT_BYTE:result:=1;
        TT_WORD:result:=2;
        TT_LONGWORD:result:=4;
        TT_SHORTINT:result:=1;
        TT_INTEGER:result:=2;
        TT_LONGINT:result:=4;
        TT_CHAR:result:=1;
        TT_STRING:result:=256;
        TT_CSTRING:result:=256;
        TT_POINTER:result:=4;
        TT_BOOLEAN:result:=1;
        TT_WORDBOOL:result:=2;
        TT_LONGBOOL:result:=4;
        TT_PROC:result:=4;
        TT_VAR:result:=4;
        TT_FILE:result:=128;
        TT_SINGLE:result:=4;
        //TT_REAL:result:=8;
        TT_DOUBLE:result:=8;
        TT_EXTENDED:result:=10;
        TT_TEXT:result:=128;
        TT_ANSISTRING:result:=4;
        ELSE
        BEGIN
             IF Typ<512 THEN {Pointer to standard data type}
                 result:=4;
        END;
     END; {case}
     IF result<>0 THEN goto l;

     IF TheTypOffset=-1 THEN
     BEGIN
          GetTypeOffset(Module,Typ,TheTypOffset);
          IF TheTypOffset=-1 THEN goto l;  {zero length}
     END;

     TypTable:=Module^.TypesInfo;
     ttyp:=TypTable^[TheTypOffset+2]+256*TypTable^[TheTypOffset+3];
     CASE ttyp OF
         $017a:result:=4;  {pointer to}
         ELSE
         BEGIN
              ul:=@TypTable^[TheTypOffset+4];
              result:=ul^;
         END;
     END; {case}
l:
     GetTypesSize:=result;
END;


FUNCTION GetWholeRecord(Module:PModuleInfo;EXEAddr:ULONG;
                        TypOffset:LONGINT;MakeTypeList:BOOLEAN):STRING;
VAR result:STRING;
    tlen:WORD;
    akt,oldakt:LONGINT;
    toffs:LONGINT;
    lw:ULONG;
    ps:^STRING;
    pl:^LONGINT;
    Typ:WORD;
    count,t,countsub:WORD;
    variable,expr:STRING;
    ValueLen:ULONG;
    ValueTyp:BYTE;
    TypInfo:PTypesInfo;
    NewEXEAddr:ULONG;
    MTypeList:BOOLEAN;
LABEL l;
BEGIN
     result:='(';
     akt:=TypOffset;
     TypInfo:=Module^.TypesInfo;
     tlen:=TypInfo^[akt]+256*TypInfo^[akt+1];
     countsub:=TypInfo^[akt+8]+256*typInfo^[akt+9];

     inc(akt,tlen+2);  {to types descr}
     toffs:=akt;
     tlen:=TypInfo^[akt]+256*TypInfo^[akt+1];
     inc(akt,tlen+2+4);  {to name descr and first entry}

     MTypeList:=MakeTypeList AND (TypeList=NIL);

     FOR count:=1 TO countsub DO
     BEGIN
          IF length(result)>1 THEN result:=result+',';

          IF TypInfo^[akt]<>$82 THEN goto l;  {error}
          ps:=@TypInfo^[akt+1];

          Variable:=ps^;
          Expr:='';

          IF MTypeList THEN AddToTypeList(Variable,Expr,0);
          UpcaseStr(Variable);

          oldakt:=akt+7+length(Variable);
          inc(akt,2+length(Variable));
          IF TypInfo^[akt]<>$86 THEN goto l;  {error}
          pl:=@TypInfo^[akt+1];
          {get type}
          akt:=toffs+4;
          FOR t:=1 TO count-1 DO
          BEGIN
               IF TypInfo^[akt]<>$83 THEN goto l; {error}
               inc(akt,3);
          END;
          IF TypInfo^[akt]<>$83 THEN goto l; {error}
          lw:=pl^;
          Typ:=TypInfo^[akt+1]+256*TypInfo^[akt+2];

          TypOffset:=-1;

          NewEXEAddr:=EXEAddr+lw;
          IF MTypeList THEN result:=GetValueFromCode(Variable,Expr,Module,Typ,
                                                     TypOffset,NewEXEAddr,
                                                     ValueLen,ValueTyp,TRUE,FALSE)
          ELSE result:=result+GetValueFromCode(Variable,Expr,Module,Typ,
                                               TypOffset,NewEXEAddr,
                                               ValueLen,ValueTyp,TRUE,FALSE);
          akt:=oldakt;  {next entry}

          IF MTypeList THEN
          BEGIN
               FreeMem(LastTypeList^.Value,length(LastTypeList^.Value^)+1);
               GetMem(LastTypeList^.Value,length(result)+1);
               LastTypeList^.Value^:=result;
               LastTypeList^.Typ:=ValueTyp;
          END;
     END;
l:
     IF MTypeList THEN GetWholeRecord:='()'
     ELSE GetWholeRecord:=result+')';
END;

FUNCTION GetWholeArray(Module:PModuleInfo;EXEAddr:ULONG;
                       ElemTyp:WORD;Low,High:LONGINT;MakeTypeList:BOOLEAN):STRING;
VAR result:STRING;
    t:LONGINT;
    NewEXEAddr:ULONG;
    Elemsize:ULONG;
    off:LONGINT;
    Variable,Expr:STRING;
    TypOffset:LONGINT;
    ValueLen:ULONG;
    ValueTyp:BYTE;
    s:STRING;
LABEL l;
BEGIN
     result:='(';
     TypOffset:=-1;
     Elemsize:=GetTypesSize(ElemTyp,Module,TypOffset);

     FOR t:=Low TO High DO
     BEGIN
          IF t>low THEN result:=result+',';
          off:=(t-Low)*ElemSize;
          NewEXEAddr:=EXEAddr+off;
          Variable:='';
          Expr:='';
          s:=GetValueFromCode(Variable,Expr,Module,ElemTyp,
                              TypOffset,NewEXEAddr,
                              ValueLen,ValueTyp,FALSE,FALSE);
          result:=result+s;
          IF length(s)<>0 THEN IF s[1]='<' THEN goto l; {some error}
     END;
l:
     GetWholeArray:=result+')';
END;

FUNCTION GetValueFromCode(VAR variable,expr:STRING;Module:PModuleInfo;
                          Typ:WORD;VAR TypOffset:LONGINT;
                          VAR EXEAddr:ULONG;
                          VAR ValueLen:ULONG;
                          VAR ValueTyp:BYTE;Nested,MakeTypeList:BOOLEAN):STRING;
VAR
    s,value,name:STRING;
    ttyp:WORD;
    TypInfo:PTypesInfo;
    akt,lw:LONGINT;
    TheTypOffset:LONGINT;
    first:BOOLEAN;
    Reg:TDbgBuf;
    ul,size:ULONG;
    ul1:^ULONG;
    c:INTEGER;
    low,high:LONGINT;
    TheSet:ARRAY[0..31] OF BYTE;
    t,t1:BYTE;
    potenz,OldE:ULONG;
LABEL l,l1;
BEGIN
     ValueLen:=0;
     value:='';
     TheTypOffset:=TypOffset;
     first:=TRUE;
l1:
     IF GetStandardType(value,Typ,EXEAddr,ValueLen,ValueTyp) THEN
     BEGIN
          IF Expr='' THEN goto l;
          IF Expr[1]='[' THEN
          BEGIN
               IF not (ValueTyp IN [TT_STRING,TT_CSTRING]) THEN
               BEGIN
                  value:='<Error in expression ( unexpected [ )>';
                  goto l;
               END;

               IF Expr[length(Expr)]<>']' THEN
               BEGIN
                    value:='<Error in expression ( ] expected )>';
                    goto l;
               END;

               name:=copy(Expr,2,length(Expr)-2);
               Expr:='';

               VAL(name,lw,c);
               IF c<>0 THEN
               BEGIN
                   value:='<Error in expression ( constant expected )>';
                   goto l;
               END;

               Value:=copy(Value,2,length(Value)-2);

               IF lw>length(Value) THEN
               BEGIN
                   value:='<String index out of length>';
                   goto l;
               END;

               value:=#39+value[lw]+#39;
               ExeAddr:=ExeAddr+lw;
               IF valuetyp=TT_CSTRING THEN dec(ExeAddr);
               valuetyp:=TT_CHAR;
               valuelen:=1;
               goto l;
          END;

          IF ValueTyp<>TT_POINTER THEN
          BEGIN
              value:='<Error in expression ( unexpected characters )>';
              goto l;
          END;
     END;

     {Handle pointer to standard data types if ^ is given !}
     IF Typ<512 THEN
     BEGIN
          IF Typ<$20 THEN
          BEGIN
               value:='<Error in expression (Illegal standard type)>';  {Some error}
               goto l;
          END;
          Dec(Typ,$20);  {Pointer to standard type is type+$20}

          Reg.Pid:=SessPID;
          Reg.Addr:=EXEAddr;
          Reg.BUFFER:=LONGWORD(@ul);
          Reg.Len:=4;
          Reg.Cmd:=DBG_C_READMEMBUF;
          DosDebug(Reg);
          IF Reg.cmd<>DBG_N_SUCCESS THEN
          BEGIN
               value:='<Access violation !>';
               EXEAddr:=0;
               goto l;
          END;
          IF Expr='' THEN
          BEGIN
               {put out pointer as hex}
               IF ul=0 THEN value:='Nil'
               ELSE value:=tohex(ul);
               valuelen:=4;
               valueTyp:=TT_POINTER;
               goto l;
          END;
          IF Expr[1]<>'^' THEN
          BEGIN
               value:='<Error in expression ( ^ expected )>';
               goto l;
          END;
          Delete(Expr,1,1);
          EXEAddr:=ul;
          TheTypOffset:=-1; {always search}
          goto l1;  {check type again}
     END;

     {Handle records,objects,arrays...}
     IF TheTypOffset=-1 THEN
     BEGIN
          s:=GetTypeOffset(Module,Typ,TheTypOffset);
          IF TheTypOffset=-1 THEN
          BEGIN
               value:='<Could not get type offset '+ tohex(Typ)+'('+s+') >';
               goto l;  {error}
          END;
          IF first THEN TypOffset:=TheTypOffset;
     END;

     first:=FALSE;
     TypInfo:=Module^.TypesInfo;
     akt:=TheTypOffset;
     ttyp:=TypInfo^[akt+2]+256*TypInfo^[akt+3];
     CASE ttyp OF
        $82: {Set}
        BEGIN
             IF Expr<>'' THEN
             BEGIN
                  value:='<Error in expression (Illegal qualifier)>';  {Some error}
                  goto l;
             END;

             Typ:=TypInfo^[akt+5]+256*TypInfo^[akt+6];
             TheTypOffset:=-1; {always search}
             IF GetStandardType(value,Typ,EXEAddr,ValueLen,ValueTyp) THEN
             BEGIN
                  Reg.Pid:=SessPID;
                  Reg.Addr:=EXEAddr;
                  Reg.BUFFER:=LONGWORD(@TheSet);
                  Reg.Len:=32;
                  Reg.Cmd:=DBG_C_READMEMBUF;
                  DosDebug(Reg);
                  IF Reg.cmd<>DBG_N_SUCCESS THEN
                  BEGIN
                       value:='<Access violation !>';
                       EXEAddr:=0;
                       goto l;
                  END;
                  value:='[';  {empty set}

                  FOR t:=0 TO 31 DO
                  BEGIN
                       FOR t1:=0 TO 7 DO
                       BEGIN
                            potenz:=1 SHL t1;
                            IF TheSet[t] AND potenz=potenz THEN
                            BEGIN
                                IF length(value)>1 THEN value:=value+',';
                                IF Typ=TT_CHAR THEN
                                BEGIN
                                     potenz:=(t*8)+t1;
                                     value:=value+#39+chr(potenz)+#39;
                                END
                                ELSE value:=value+tostr((t*8)+t1);
                            END;
                       END;
                  END;

                  value:=value+']';
                  goto l;
             END;

             {now it can only be an enum set}
             TheTypOffset:=-1;
             Typ:=TypInfo^[akt+5]+256*TypInfo^[akt+6];
             GetTypeOffset(Module,Typ,TheTypOffset);
             IF TheTypOffset=-1 THEN
             BEGIN
                 value:='<Error in expression (Could not get enum type offset)>';
                 goto l;  {error}
             END;

             TypInfo:=Module^.TypesInfo;
             akt:=TheTypOffset;
             ttyp:=TypInfo^[akt+2]+256*TypInfo^[akt+3];
             IF ttyp<>$81 {enum} THEN
             BEGIN
                  value:='<Error in expression (Enum type offset expected)>';
                  goto l;  {error}
             END;

             Reg.Pid:=SessPID;
             Reg.Addr:=EXEAddr;
             Reg.BUFFER:=LONGWORD(@ul);
             Reg.Len:=4;
             Reg.Cmd:=DBG_C_READMEMBUF;
             DosDebug(Reg);
             IF Reg.cmd<>DBG_N_SUCCESS THEN
             BEGIN
                  value:='<Access violation !>';
                  EXEAddr:=0;
                  goto l;
             END;

             value:='[';

             FOR t:=0 TO 31 DO
             BEGIN
                  potenz:=1 SHL t;
                  IF ul AND potenz=potenz THEN
                  BEGIN
                       IF length(value)>1 THEN value:=value+',';
                       name:=tostr(t);
                       GetEnumName(name,TypInfo,akt);
                       value:=value+name;
                  END;
             END;

             value:=value+']';
             ValueTyp:=TT_SET;
             goto l;
        END;
        $81: {Enum}
        BEGIN
             IF Expr='' THEN {Enums cannot be qualified}
             BEGIN
                  value:=GetValueFromCode(Variable,expr,Module,TT_WORD,
                                          TypOffset,EXEAddr,
                                          ValueLen,ValueTyp,FALSE,FALSE);
                  GetEnumName(value,TypInfo,akt);
                  goto l;
             END
             ELSE
             BEGIN
                  value:='<Error in expression (Illegal qualifier)>';  {Some error}
                  goto l;
             END;
        END;
        $79,$80,$83:  {Record,Object,Class}
        BEGIN
             OldE:=EXEAddr;

             //implicit ^ on classes
             IF ttyp=$80 THEN  {Class}
             BEGIN
                  Reg.Pid:=SessPID;
                  Reg.Addr:=EXEAddr;
                  Reg.BUFFER:=LONGWORD(@ul);
                  Reg.Len:=4;
                  Reg.Cmd:=DBG_C_READMEMBUF;
                  DosDebug(Reg);
                  IF Reg.cmd<>DBG_N_SUCCESS THEN
                  BEGIN
                       value:='<Access violation !>';
                       EXEAddr:=0;
                       goto l;
                  END;
                  EXEAddr:=ul;

                  IF Nested THEN
                  BEGIN
                       IF ul=0 THEN value:='Nil'
                       ELSE value:=tohex(ul);
                       valuelen:=4;
                       valueTyp:=TT_OBJECT;
                       EXEAddr:=OldE;
                       goto l;
                  END
                  ELSE IF ul=0 THEN
                  BEGIN
                       Value:='Nil';
                       ValueLen:=4;
                       ValueTyp:=TT_OBJECT;
                       EXEAddr:=OldE;
                       goto l;
                  END;
             END;

             IF Expr='' THEN //whole object/record
             BEGIN
                  {put out whole record/object}
                  valueLen:=0;
                  IF ttyp=$80 THEN ValueTyp:=TT_OBJECT
                  ELSE ValueTyp:=TT_RECORD;
                  value:=GetWholeRecord(Module,EXEAddr,TheTypOffset,MakeTypeList);

                  IF value='' THEN
                  BEGIN
                       value:='<Error in expression ( error in record )>';
                       goto l;
                  END;

                  EXEAddr:=OldE;
                  goto l;
             END;

             IF Expr[1]<>'.' THEN
             BEGIN
                  value:='<Error in expression ( . expected )>';
                  goto l;
             END;

             Delete(Expr,1,1);
             SplitExpr(name,Expr);
             IF not GetRecordName(Name,TypInfo,akt,lw,Typ) THEN
             BEGIN
                  value:='<Illegal record identifier>';
                  goto l;
             END;

             TheTypOffset:=-1; {always search}
             inc(EXEAddr,lw);
             goto l1;  {check type again}
        END;
        $017a:  {Pointer to}
        BEGIN
             Reg.Pid:=SessPID;
             Reg.Addr:=EXEAddr;
             Reg.BUFFER:=LONGWORD(@ul);
             Reg.Len:=4;
             Reg.Cmd:=DBG_C_READMEMBUF;
             DosDebug(Reg);
             IF Reg.cmd<>DBG_N_SUCCESS THEN
             BEGIN
                  value:='<Access violation !>';
                  EXEAddr:=0;
                  goto l;
             END;
             IF Expr='' THEN
             BEGIN
                  {put out pointer as hex}
                  IF ul=0 THEN value:='Nil'
                  ELSE value:=tohex(ul);
                  valuelen:=4;
                  valueTyp:=TT_POINTER;
                  goto l;
             END;
             IF Expr[1]<>'^' THEN
             BEGIN
                  value:='<Error in expression ( ^ expected )>';
                  goto l;
             END;
             Delete(Expr,1,1);
             EXEAddr:=ul;
             Typ:=TypInfo^[akt+5]+256*TypInfo^[akt+6];
             TheTypOffset:=-1; {always search}
             goto l1;  {check type again}
        END;
        $78:  {Array}
        BEGIN
             IF Expr='' THEN
             BEGIN
                  {Put out whole array}
                  ul1:=@TypInfo^[akt+16];
                  low:=ul1^;
                  ul1:=@TypInfo^[akt+20];
                  high:=ul1^;
                  Typ:=TypInfo^[akt+12]+256*TypInfo^[akt+13];
                  valueLen:=0;
                  valueTyp:=0;
                  value:=GetWholeArray(Module,EXEAddr,Typ,low,high,MakeTypeList);

                  IF value='' THEN
                  BEGIN
                       value:='<Error in expression ( error in array )>';
                       goto l;
                  END;

                  //EXEAddr:=0;  ??????????????
                  goto l;
             END;

             IF Expr[1]<>'[' THEN
             BEGIN
                  value:='<Error in expression ( [ expected )>';
                  goto l;
             END;

             Delete(Expr,1,1);
             {Handle also variables as index}
             SplitExpr(Name,Expr);
             IF Expr[1]<>']' THEN
             BEGIN
                  value:='<Error in expression ( ] expected )>';
                  goto l;
             END;
             Delete(Expr,1,1);

             Typ:=TypInfo^[akt+12]+256*TypInfo^[akt+13];
             TheTypOffset:=-1; {always search}
             size:=GetTypesSize(Typ,Module,TheTypOffset);
             TheTypOffset:=-1;

             IF size=0 THEN {some error}
             BEGIN
                  value:='<Error in expression ( illegal size )>';
                  goto l;
             END;

             VAL(name,lw,c);
             IF c<>0 THEN
             BEGIN
                  value:='<Error in expression ( constant expected )>';
                  goto l;
             END;

             ul1:=@TypInfo^[akt+16];
             low:=ul1^;
             ul1:=@TypInfo^[akt+20];
             high:=ul1^;
             IF ((lw<low)OR(lw>high)) THEN
             BEGIN
                  value:='<Error in expression ( Range check )>';
                  goto l;
             END;
             inc(ExeAddr,(lw-low)*size);
             goto l1;  {check type again}
        END;
        ELSE value:='<Error in expression (Illegal type handle: '+
                    tohex(ttyp)+' )>';  {Some error}
     END; {case}
l:
     IF TypeList=NIL THEN
       IF MakeTypeList THEN AddToTypeList('',Value,ValueTyp);
     GetValueFromCode:=value;
END;


FUNCTION SearchObjectName(Module:PModuleInfo;Locals:PSymbolsInfo;
                          VAR Variable:STRING;VAR lw1:LONGINT;
                          VAR Typ:WORD):BOOLEAN;
VAR result:BOOLEAN;
    ttyp:WORD;
    TypInfo:PTypesInfo;
    akt:LONGINT;
LABEL l,l1;
BEGIN
     result:=FALSE;

     {get object from type and check for name and put offset into lw1}
     IF Locals^.TypOffset=-1 THEN
     BEGIN
          GetTypeOffset(Module,Locals^.Typ,Locals^.TypOffset);
          IF Locals^.TypOffset=-1 THEN goto l;  {error}
     END;

     TypInfo:=Module^.TypesInfo;
     akt:=Locals^.TypOffset;
l1:
     ttyp:=TypInfo^[akt+2]+256*TypInfo^[akt+3];
     IF ttyp<>$80 THEN
     BEGIN
          IF ttyp>512 THEN
          BEGIN
               akt:=-1;
               GetTypeOffset(Module,ttyp,akt);
               IF akt=-1 THEN goto l;
               goto l1;
          END;
          goto l;  {no object}
     END;
     IF GetRecordName(Variable,TypInfo,akt,lw1,Typ) THEN
     BEGIN
          result:=TRUE;
     END;
l:
     SearchObjectName:=result;
END;

FUNCTION GetValueFromExpr(Expr:STRING;VAR Value:STRING;VAR EXEAddr:ULONG;
                          VAR ValueLen:ULONG;VAR ValueTyp:BYTE;MakeTypeList:BOOLEAN):BOOLEAN;
VAR
    Reg,Reg1:TDbgBuf;
    EIP:ULONG;
    EBP:LONGINT;
    lw,lw1:LONGINT;
    Module:PModuleInfo;
    ThisModule:PModuleInfo;
    Symbols,Locals:PSymbolsInfo;
    Variable,s,s1,ss:STRING;
    dir:dirstr;
    name:namestr;
    ext:extstr;
    Publics:PPublicsInfo;
    t1:BYTE;
    Typ:WORD;
    TypOffset:LONGINT;
LABEL l1,l2,l3;
BEGIN
     value:='<Undefined Identifier>';
     ExeAddr:=0;
     valueLen:=0;
     ValueTyp:=0;

     SplitExpr(variable,Expr);

     {First look if it is a local variable}
     GetRegisterSet(Reg);
     EIP:=Reg.EIP;
     Module:=ModuleInfo;
     ThisModule:=NIL;
     WHILE Module<>NIL DO
     BEGIN
          IF ((EIP>=Module^.CodeOffs)AND(EIP<=Module^.CodeOffs+Module^.CodeLen)) THEN
          BEGIN  {Within this module}
               ThisModule:=Module;
               Symbols:=Module^.SymbolsInfo;
               WHILE Symbols<>NIL DO
               BEGIN
                    IF ((EIP>=Symbols^.Offset)AND(EIP<Symbols^.Offset+Symbols^.Len)) THEN {within this proc}
                    BEGIN
                         Locals:=Symbols^.Symbols;
                         WHILE Locals<>NIL DO
                         BEGIN
                              s:=Locals^.SymbolName^;
                              UpcaseStr(s);
                              IF s=Variable THEN {found}
                              BEGIN
                                   EBP:=reg.EBP;
                                   EXEAddr:=EBP+Locals^.Offset;
                                   IF Locals^.OffsetTyp=5 THEN {VAR_Parameter}
                                   BEGIN
                                        Reg1.Pid:=SessPID;
                                        Reg1.Addr:=EXEAddr;
                                        Reg1.BUFFER:=LONGWORD(@lw);
                                        Reg1.Len:=4;
                                        Reg1.Cmd:=DBG_C_READMEMBUF;
                                        DosDebug(Reg1);
                                        IF Reg1.cmd<>DBG_N_SUCCESS THEN
                                        BEGIN
                                             value:='<Access violation !>';
                                             goto l1;
                                        END;
                                        EXEAddr:=lw;
                                   END;
                                   value:=GetValueFromCode(variable,Expr,
                                                           Module,
                                                           Locals^.typ,
                                                           Locals^.TypOffset,
                                                           EXEAddr,
                                                           ValueLen,ValueTyp,FALSE,MakeTypeList);
                                   IF value<>'' THEN goto l1;
                              END;
                              Locals:=Locals^.Next;
                         END;
                    END;
                    Symbols:=Symbols^.Next;
               END;
          END;
          Module:=Module^.Next;
     END;

     {Look if it is an local Objekt var}
     Module:=ModuleInfo;
     WHILE Module<>NIL DO
     BEGIN
          IF ((EIP>=Module^.CodeOffs)AND(EIP<=Module^.CodeOffs+Module^.CodeLen)) THEN
          BEGIN  {Within this module}
               Symbols:=Module^.SymbolsInfo;
               WHILE Symbols<>NIL DO
               BEGIN
                    IF ((EIP>=Symbols^.Offset)AND(EIP<Symbols^.Offset+Symbols^.Len)) THEN {within this proc}
                    BEGIN
                         Locals:=Symbols^.Symbols;
                         WHILE Locals<>NIL DO
                         BEGIN
                              IF Locals^.OffsetTyp=6 THEN {Object found}
                              BEGIN
                                   IF SearchObjectName(Module,Locals,
                                                       Variable,lw1,Typ) THEN
                                   BEGIN
                                        EBP:=reg.EBP;
                                        EXEAddr:=EBP+8;  {SELF Pointer}

                                        Reg1.Pid:=SessPID;
                                        Reg1.Addr:=EXEAddr;
                                        Reg1.BUFFER:=LONGWORD(@lw);
                                        Reg1.Len:=4;
                                        Reg1.Cmd:=DBG_C_READMEMBUF;
                                        DosDebug(Reg1);
                                        IF Reg1.cmd<>DBG_N_SUCCESS THEN
                                        BEGIN
                                            value:='<Access violation !>';
                                            goto l1;
                                        END;
                                        EXEAddr:=lw+lw1; {Offset within Object}

                                        typoffset:=-1; {always search}
                                        value:=GetValueFromCode(variable,Expr,
                                                           Module,
                                                           Typ,
                                                           TypOffset,
                                                           EXEAddr,
                                                           ValueLen,ValueTyp,FALSE,MakeTypeList);
                                        IF value<>'' THEN goto l1;
                                   END;
                              END;
                              Locals:=Locals^.Next;
                         END;
                    END;
                    Symbols:=Symbols^.Next;
               END;
          END;
          Module:=Module^.Next;
     END;

     {Look if it an local global var in the actual module}
     IF ThisModule<>NIL THEN
     BEGIN
          s:=ThisModule^.sourcefile;
          fsplit(s,dir,name,ext);
          s:=name;
          UpcaseStr(s);
          s:=s+'.'+variable;
          Publics:=ThisModule^.PublicsInfo;
          WHILE Publics<>NIL DO
          BEGIN
               IF Publics^.ObjectIndex=2 THEN {Data segment}
               BEGIN
                    ss:=Publics^.PublicName^;
                    UpcaseStr(ss);
                    IF ss=s THEN {found}
                    BEGIN
                        s1:=ss;
                        t1:=pos('!',s1);
                        IF t1<>0 THEN s1[0]:=chr(t1-1);
                        IF s1<>s THEN goto l2;
                        EXEAddr:=Publics^.Offset;
                        value:=GetValueFromCode(variable,Expr,ThisModule,
                                                Publics^.Typ,Publics^.TypOffset,
                                                EXEAddr,
                                                ValueLen,ValueTyp,FALSE,MakeTypeList);
                        IF value<>'' THEN goto l1;
                   END;
               END;
l2:
               Publics:=Publics^.Next;
          END;
     END;

     {Now look if it is a global variable}
     Module:=ModuleInfo;
     WHILE Module<>NIL DO
     BEGIN
          Publics:=Module^.PublicsInfo;
          WHILE Publics<>NIL DO
          BEGIN
               IF Publics^.ObjectIndex=2 THEN {Data segment}
               BEGIN
                    s1:=Publics^.PublicName^;
                    UpcaseStr(s1);
                    t1:=pos('!',s1);
                    IF t1<>0 THEN s1[0]:=chr(t1-1);
                    t1:=pos('.',s1);
                    IF t1<>0 THEN s1:=copy(s1,t1+1,length(s1)-t1);
                    IF s1<>Variable THEN goto l3;
                    EXEAddr:=Publics^.Offset;
                    value:=GetValueFromCode(variable,Expr,Module,
                                            Publics^.Typ,Publics^.TypOffset,
                                            EXEAddr,
                                            ValueLen,ValueTyp,FALSE,MakeTypeList);
                    IF value<>'' THEN goto l1;
               END;
l3:
               Publics:=Publics^.Next;
          END;
          Module:=Module^.Next;
     END;
     value:='<Undefined Identifier>';
l1:
     result:=TRUE;
     IF value[1]='<' THEN
     BEGIN
          ExeAddr:=0;
          valueLen:=0;
          ValueTyp:=0;
          result:=FALSE;
     END
     ELSE IF EXEAddr<>0 THEN
     BEGIN
          {Handle also complex expressions}
     END;
END;

FUNCTION SetValueFromExpr(NewValue:STRING;EXEAddr:ULONG;
                          Len:ULONG;Typ:BYTE):BOOLEAN;
VAR result:BOOLEAN;
    ValueAddr:PSymbyteBuffer;
    b:BYTE;
    w:WORD;
    lw:LONGWORD;
    si:SHORTINT;
    i:INTEGER;
    li:LONGINT;
    ch:CHAR;
    bo:BOOLEAN;
    wbo:WORDBOOL;
    lbo:LONGBOOL;
    c:INTEGER;
    sing:SINGLE;
    d:DOUBLE;
    e:EXTENDED;
    Reg1:TDbgBuf;
LABEL l;
BEGIN
     WHILE NewValue[length(NewValue)]=#32 DO dec(NewValue[0]);
     WHILE ((NewValue[1]=#32)AND(length(NewValue)>0)) DO delete(NewValue,1,1);
     result:=FALSE;
     GetMem(ValueAddr,Len);
     CASE Typ OF
             TT_BYTE:
             BEGIN
                  VAL(NewValue,b,c);
                  IF c<>0 THEN goto l;
                  move(b,ValueAddr^[0],1);
             END;
             TT_WORD:
             BEGIN
                  VAL(NewValue,w,c);
                  IF c<>0 THEN goto l;
                  move(w,ValueAddr^[0],2);
             END;
             TT_LONGWORD:
             BEGIN
                  VAL(NewValue,lw,c);
                  IF c<>0 THEN goto l;
                  move(lw,ValueAddr^[0],4);
             END;
             TT_SHORTINT:
             BEGIN
                  VAL(NewValue,si,c);
                  IF c<>0 THEN goto l;
                  move(si,ValueAddr^[0],1);
             END;
             TT_INTEGER:
             BEGIN
                  VAL(NewValue,i,c);
                  IF c<>0 THEN goto l;
                  move(i,ValueAddr^[0],2);
             END;
             TT_LONGINT:
             BEGIN
                  VAL(NewValue,li,c);
                  IF c<>0 THEN goto l;
                  move(li,ValueAddr^[0],4);
             END;
             TT_CHAR:
             BEGIN
                  IF length(NewValue)<>3 THEN goto l;
                  IF NewValue[1]<>#39 THEN goto l;
                  IF NewValue[3]<>#39 THEN goto l;
                  ch:=NewValue[2];
                  move(ch,ValueAddr^[0],1);
             END;
             TT_STRING:
             BEGIN
                  IF length(NewValue)<3 THEN goto l;
                  IF NewValue[1]<>#39 THEN goto l;
                  IF NewValue[Length(NewValue)]<>#39 THEN goto l;
                  dec(NewValue[0]);
                  delete(NewValue,1,1);
                  move(NewValue,ValueAddr^[0],256);
             END;
             TT_CSTRING:
             BEGIN
                  IF length(NewValue)<3 THEN goto l;
                  IF NewValue[1]<>#39 THEN goto l;
                  IF NewValue[Length(NewValue)]<>#39 THEN goto l;
                  dec(NewValue[0]);
                  delete(NewValue,1,1);
                  move(NewValue,ValueAddr^[0],256);
             END;
             TT_POINTER:
             BEGIN
                  c:=0;
                  IF NewValue='NIL' THEN lw:=0
                  ELSE VAL(NewValue,lw,c);
                  IF c<>0 THEN goto l;
                  move(lw,ValueAddr^[0],4);
             END;
             TT_BOOLEAN:
             BEGIN
                  UpcaseStr(NewValue);
                  IF NewValue='TRUE' THEN bo:=TRUE
                  ELSE
                  BEGIN
                       IF NewValue='FALSE' THEN bo:=FALSE
                       ELSE goto l;
                  END;
                  move(bo,ValueAddr^[0],1);
             END;
             TT_WORDBOOL:
             BEGIN
                  UpcaseStr(NewValue);
                  IF NewValue='TRUE' THEN wbo:=TRUE
                  ELSE
                  BEGIN
                       IF NewValue='FALSE' THEN wbo:=FALSE
                       ELSE goto l;
                  END;
                  move(wbo,ValueAddr^[0],2);
             END;
             TT_LONGBOOL:
             BEGIN
                  UpcaseStr(NewValue);
                  IF NewValue='TRUE' THEN lbo:=TRUE
                  ELSE
                  BEGIN
                       IF NewValue='FALSE' THEN lbo:=FALSE
                       ELSE goto l;
                  END;
                  move(lbo,ValueAddr^[0],2);
             END;
             TT_PROC:
             BEGIN
                  VAL(NewValue,lw,c);
                  IF c<>0 THEN goto l;
                  move(lw,ValueAddr^[0],4);
             END;
             TT_VAR:
             BEGIN
                  VAL(NewValue,lw,c);
                  IF c<>0 THEN goto l;
                  move(lw,ValueAddr^[0],4);
             END;
             {TT_FILE:ValueLen:=128;
             TT_TEXT:ValueLen:=128;}
             TT_SINGLE:
             BEGIN
                  VAL(NewValue,sing,c);
                  IF c<>0 THEN goto l;
                  move(sing,ValueAddr^[0],4);
             END;
             TT_DOUBLE{,TT_REAL}:
             BEGIN
                  VAL(NewValue,d,c);
                  IF c<>0 THEN goto l;
                  move(d,ValueAddr^[0],8);
             END;
             TT_EXTENDED:
             BEGIN
                  VAL(NewValue,e,c);
                  IF c<>0 THEN goto l;
                  move(e,ValueAddr^[0],10);
             END;
             ELSE goto l;
     END; {case}
     Reg1.Pid:=SessPID;
     Reg1.Addr:=EXEAddr;
     Reg1.BUFFER:=LONGWORD(ValueAddr);
     Reg1.Len:=Len;
     Reg1.Cmd:=DBG_C_WRITEMEMBUF;
     DosDebug(Reg1);
     IF Reg1.cmd<>DBG_N_SUCCESS THEN goto l;
     result:=TRUE; {Success !}
l:
     FreeMem(ValueAddr,Len);
     SetValueFromExpr:=result;
END;

FUNCTION GetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN;
VAR Reg:TDbgBuf;
BEGIN
     result:=FALSE;
     FillChar(Buf,Len,144);  {NOP}
     Reg.Pid:=SessPID;
     Reg.Addr:=Address;
     Reg.BUFFER:=LONGWORD(@Buf);
     Reg.Len:=Len;
     Reg.Cmd:=DBG_C_READMEMBUF;
     DosDebug(Reg);
     IF Reg.cmd=DBG_N_SUCCESS THEN result:=TRUE;
END;

FUNCTION SetDump(Address:LONGWORD;VAR Buf;Len:LONGWORD):BOOLEAN;
VAR Reg:TDbgBuf;
BEGIN
     result:=FALSE;
     Reg.Pid:=SessPID;
     Reg.Addr:=Address;
     Reg.BUFFER:=LONGWORD(@Buf);
     Reg.Len:=Len;
     Reg.Cmd:=DBG_C_WRITEMEMBUF;
     DosDebug(Reg);
     IF Reg.cmd=DBG_N_SUCCESS THEN result:=TRUE;
END;

FUNCTION DefCPUAvail:BOOLEAN;
BEGIN
     result:=FALSE;
END;

{$IFDEF OS2}
ASSEMBLER
DBGHELP.!PMWinCalls PROC NEAR32
    DD @PMWIN,926
    DB 16,'WinRegisterClass'
    DD @PMWIN,911
    DB 16,'WinDefWindowProc'
    DD @PMWIN,728
    DB 16,'WinDestroyWindow'
    DD @PMWIN,883
    DB 13,'WinShowWindow'
    DD @PMWIN,840
    DB 18,'WinQueryWindowRect'
    DD @PMWIN,757
    DB 8,'WinGetPS'
    DD @PMWIN,848
    DB 12,'WinReleasePS'
    DD @PMWIN,738
    DB 11,'WinEndPaint'
    DD @PMWIN,749
    DB 12,'WinGetClipPS'
    DD @PMWIN,774
    DB 18,'WinIsWindowShowing'
    DD @PMWIN,703
    DB 13,'WinBeginPaint'
    DD @PMWIN,794
    DB 15,'WinOpenWindowDC'
    DD @PMWIN,849
    DB 15,'WinScrollWindow'
    DD @PMWIN,743
    DB 11,'WinFillRect'
    DD @PMWIN,833
    DB 15,'WinQueryVersion'
    DD @PMWIN,800
    DB 19,'WinQueryAnchorBlock'
    DD @PMWIN,909
    DB 15,'WinCreateWindow'
    DD @PMWIN,909
    DB 17,'WinCreateWCWindow'
    DD @PMWIN,735
    DB 15,'WinEnableWindow'
    DD @PMWIN,773
    DB 18,'WinIsWindowEnabled'
    DD @PMWIN,736
    DB 21,'WinEnableWindowUpdate'
    DD @PMWIN,775
    DB 18,'WinIsWindowVisible'
    DD @PMWIN,841
    DB 18,'WinQueryWindowText'
    DD @PMWIN,877
    DB 16,'WinSetWindowText'
    DD @PMWIN,842
    DB 24,'WinQueryWindowTextLength'
    DD @PMWIN,899
    DB 15,'WinWindowFromID'
    DD @PMWIN,772
    DB 11,'WinIsWindow'
    DD @PMWIN,834
    DB 14,'WinQueryWindow'
    DD @PMWIN,917
    DB 20,'WinMultWindowFromIDs'
    DD @PMWIN,865
    DB 12,'WinSetParent'
    DD @PMWIN,768
    DB 10,'WinIsChild'
    DD @PMWIN,864
    DB 11,'WinSetOwner'
    DD @PMWIN,838
    DB 21,'WinQueryWindowProcess'
    DD @PMWIN,820
    DB 20,'WinQueryObjectWindow'
    DD @PMWIN,813
    DB 21,'WinQueryDesktopWindow'
    DD @PMWIN,875
    DB 15,'WinSetWindowPos'
    DD @PMWIN,863
    DB 19,'WinSetMultWindowPos'
    DD @PMWIN,837
    DB 17,'WinQueryWindowPos'
    DD @PMWIN,892
    DB 15,'WinUpdateWindow'
    DD @PMWIN,765
    DB 17,'WinInvalidateRect'
    DD @PMWIN,766
    DB 19,'WinInvalidateRegion'
    DD @PMWIN,767
    DB 13,'WinInvertRect'
    DD @PMWIN,730
    DB 13,'WinDrawBitmap'
    DD @PMWIN,913
    DB 11,'WinDrawText'
    DD @PMWIN,731
    DB 13,'WinDrawBorder'
    DD @PMWIN,781
    DB 13,'WinLoadString'
    DD @PMWIN,779
    DB 14,'WinLoadMessage'
    DD @PMWIN,851
    DB 18,'WinSetActiveWindow'
    DD @PMWIN,929
    DB 17,'WinSubclassWindow'
    DD @PMWIN,805
    DB 17,'WinQueryClassName'
    DD @PMWIN,925
    DB 17,'WinQueryClassInfo'
    DD @PMWIN,799
    DB 20,'WinQueryActiveWindow'
    DD @PMWIN,771
    DB 17,'WinIsThreadActive'
    DD @PMWIN,827
    DB 22,'WinQuerySysModalWindow'
    DD @PMWIN,872
    DB 20,'WinSetSysModalWindow'
    DD @PMWIN,844
    DB 20,'WinQueryWindowUShort'
    DD @PMWIN,879
    DB 18,'WinSetWindowUShort'
    DD @PMWIN,843
    DB 19,'WinQueryWindowUlong'
    DD @PMWIN,878
    DB 17,'WinSetWindowULong'
    DD @PMWIN,839
    DB 17,'WinQueryWindowPtr'
    DD @PMWIN,876
    DB 15,'WinSetWindowPtr'
    DD @PMWIN,874
    DB 16,'WinSetWindowBits'
    DD @PMWIN,702
    DB 19,'WinBeginEnumWindows'
    DD @PMWIN,756
    DB 16,'WinGetNextWindow'
    DD @PMWIN,737
    DB 17,'WinEndEnumWindows'
    DD @PMWIN,900
    DB 18,'WinWindowFromPoint'
    DD @PMWIN,788
    DB 18,'WinMapWindowPoints'
    DD @PMWIN,895
    DB 15,'WinValidateRect'
    DD @PMWIN,896
    DB 17,'WinValidateRegion'
    DD @PMWIN,898
    DB 15,'WinWindowFromDC'
    DD @PMWIN,835
    DB 16,'WinQueryWindowDC'
    DD @PMWIN,759
    DB 14,'WinGetScreenPS'
    DD @PMWIN,784
    DB 19,'WinLockWindowUpdate'
    DD @PMWIN,782
    DB 17,'WinLockVisRegions'
    DD @PMWIN,831
    DB 18,'WinQueryUpdateRect'
    DD @PMWIN,832
    DB 20,'WinQueryUpdateRegion'
    DD @PMWIN,742
    DB 22,'WinExcludeUpdateRegion'
    DD @PMWIN,920
    DB 20,'WinSendMsg'
    DD @PMWIN,824
    DB 17,'WinQueryQueueInfo'
    DD @PMWIN,705
    DB 17,'WinCancelShutdown'
    DD @PMWIN,915
    DB 9,'WinGetMsg'
    DD @PMWIN,918
    DB 10,'WinPeekMsg'
    DD @PMWIN,912
    DB 14,'WinDispatchMsg'
    DD @PMWIN,919
    DB 10,'WinPostMsg'
    DD @PMWIN,846
    DB 18,'WinRegisterUserMsg'
    DD @PMWIN,845
    DB 23,'WinRegisterUserDatatype'
    DD @PMWIN,862
    DB 13,'WinSetMsgMode'
    DD @PMWIN,870
    DB 17,'WinSetSynchroMode'
    DD @PMWIN,761
    DB 12,'WinInSendMsg'
    DD @PMWIN,901
    DB 15,'WinBroadcastMsg'
    DD @PMWIN,897
    DB 10,'WinWaitMsg'
    DD @PMWIN,825
    DB 19,'WinQueryQueueStatus'
    DD @PMWIN,818
    DB 14,'WinQueryMsgPos'
    DD @PMWIN,819
    DB 15,'WinQueryMsgTime'
    DD @PMWIN,978
    DB 15,'WinWaitEventSem'
    DD @PMWIN,979
    DB 18,'WinRequestMutexSem'
    DD @PMWIN,980
    DB 17,'WinWaitMuxWaitSem'
    DD @PMWIN,902
    DB 15,'WinPostQueueMsg'
    DD @PMWIN,861
    DB 17,'WinSetMsgInterest'
    DD @PMWIN,853
    DB 22,'WinSetClassMsgInterest'
    DD @PMWIN,860
    DB 11,'WinSetFocus'
    DD @PMWIN,746
    DB 14,'WinFocusChange'
    DD @PMWIN,852
    DB 13,'WinSetCapture'
    DD @PMWIN,804
    DB 15,'WinQueryCapture'
    DD @PMWIN,998
    DB 13,'WinCheckInput'
    DD @PMWIN,817
    DB 13,'WinQueryFocus'
    DD @PMWIN,752
    DB 14,'WinGetKeyState'
    DD @PMWIN,758
    DB 18,'WinGetPhysKeyState'
    DD @PMWIN,734
    DB 18,'WinEnablePhysInput'
    DD @PMWIN,769
    DB 21,'WinIsPhysInputEnabled'
    DD @PMWIN,921
    DB 24,'WinSetKeyboardStateTable'
    DD @PMWIN,914
    DB 12,'WinGetDlgMsg'
    DD @PMWIN,924
    DB 10,'WinLoadDlg'
    DD @PMWIN,923
    DB 9,'WinDlgBox'
    DD @PMWIN,729
    DB 13,'WinDismissDlg'
    DD @PMWIN,814
    DB 20,'WinQueryDlgItemShort'
    DD @PMWIN,858
    DB 18,'WinSetDlgItemShort'
    DD @PMWIN,859
    DB 17,'WinSetDlgItemText'
    DD @PMWIN,815
    DB 19,'WinQueryDlgItemText'
    DD @PMWIN,816
    DB 25,'WinQueryDlgItemTextLength'
    DD @PMWIN,910
    DB 13,'WinDefDlgProc'
    DD @PMWIN,701
    DB 8,'WinAlarm'
    DD @PMWIN,789
    DB 13,'WinMessageBox'
    DD @PMWIN,796
    DB 13,'WinProcessDlg'
    DD @PMWIN,903
    DB 17,'WinSendDlgItemMsg'
    DD @PMWIN,787
    DB 15,'WinMapDlgPoints'
    DD @PMWIN,740
    DB 14,'WinEnumDlgItem'
    DD @PMWIN,886
    DB 20,'WinSubstituteStrings'
    DD @PMWIN,922
    DB 12,'WinCreateDlg'
    DD @PMWIN,778
    DB 11,'WinLoadMenu'
    DD @PMWIN,718
    DB 14,'WinDdeInitiate'
    DD @PMWIN,720
    DB 13,'WinDdeRespond'
    DD @PMWIN,719
    DB 13,'WinDdePostMsg'
    DD @PMWIN,604
    DB 18,'WinDeleteProcedure'
    DD @PMWIN,722
    DB 16,'WinDeleteLibrary'
    DD @PMWIN,603
    DB 16,'WinLoadProcedure'
    DD @PMWIN,777
    DB 14,'WinLoadLibrary'
    DD @PMWIN,935
    DB 18,'WinSetDesktopBkgnd'
    DD @PMWIN,936
    DB 20,'WinQueryDesktopBkgnd'
    DD @PMWIN,941
    DB 17,'WinRealizePalette'
    DD @PMWIN,907
    DB 13,'WinCreateMenu'
    DD @PMWIN,937
    DB 12,'WinPopupMenu'
    DD @PMWIN,908
    DB 18,'WinCreateStdWindow'
    DD @PMWIN,745
    DB 14,'WinFlashWindow'
    DD @PMWIN,906
    DB 22,'WinCreateFrameControls'
    DD @PMWIN,704
    DB 16,'WinCalcFrameRect'
    DD @PMWIN,755
    DB 17,'WinGetMinPosition'
    DD @PMWIN,754
    DB 17,'WinGetMaxPosition'
    DD @PMWIN,943
    DB 16,'WinSaveWindowPos'
    DD @PMWIN,710
    DB 11,'WinCopyRect'
    DD @PMWIN,868
    DB 10,'WinSetRect'
    DD @PMWIN,770
    DB 14,'WinIsRectEmpty'
    DD @PMWIN,741
    DB 12,'WinEqualRect'
    DD @PMWIN,869
    DB 15,'WinSetRectEmpty'
    DD @PMWIN,792
    DB 13,'WinOffsetRect'
    DD @PMWIN,762
    DB 14,'WinInflateRect'
    DD @PMWIN,797
    DB 11,'WinPtInRect'
    DD @PMWIN,764
    DB 16,'WinIntersectRect'
    DD @PMWIN,891
    DB 12,'WinUnionRect'
    DD @PMWIN,887
    DB 15,'WinSubtractRect'
    DD @PMWIN,786
    DB 11,'WinMakeRect'
    DD @PMWIN,785
    DB 13,'WinMakePoints'
    DD @PMWIN,829
    DB 16,'WinQuerySysValue'
    DD @PMWIN,873
    DB 14,'WinSetSysValue'
    DD @PMWIN,938
    DB 15,'WinSetPresParam'
    DD @PMWIN,939
    DB 17,'WinQueryPresParam'
    DD @PMWIN,940
    DB 18,'WinRemovePresParam'
    DD @PMWIN,826
    DB 16,'WinQuerySysColor'
    DD @PMWIN,871
    DB 15,'WinSetSysColors'
    DD @PMWIN,884
    DB 13,'WinStartTimer'
    DD @PMWIN,885
    DB 12,'WinStopTimer'
    DD @PMWIN,750
    DB 17,'WinGetCurrentTime'
    DD @PMWIN,776
    DB 17,'WinLoadAccelTable'
    DD @PMWIN,709
    DB 17,'WinCopyAccelTable'
    DD @PMWIN,713
    DB 19,'WinCreateAccelTable'
    DD @PMWIN,723
    DB 20,'WinDestroyAccelTable'
    DD @PMWIN,904
    DB 17,'WinTranslateAccel'
    DD @PMWIN,850
    DB 16,'WinSetAccelTable'
    DD @PMWIN,798
    DB 18,'WinQueryAccelTable'
    DD @PMWIN,890
    DB 12,'WinTrackRect'
    DD @PMWIN,882
    DB 16,'WinShowTrackRect'
    DD @PMWIN,855
    DB 18,'WinSetClipbrdOwner'
    DD @PMWIN,854
    DB 17,'WinSetClipbrdData'
    DD @PMWIN,806
    DB 19,'WinQueryClipbrdData'
    DD @PMWIN,807
    DB 22,'WinQueryClipbrdFmtInfo'
    DD @PMWIN,856
    DB 19,'WinSetClipbrdViewer'
    DD @PMWIN,739
    DB 18,'WinEnumClipbrdFmts'
    DD @PMWIN,733
    DB 15,'WinEmptyClipbrd'
    DD @PMWIN,793
    DB 14,'WinOpenClipbrd'
    DD @PMWIN,707
    DB 15,'WinCloseClipbrd'
    DD @PMWIN,808
    DB 20,'WinQueryClipbrdOwner'
    DD @PMWIN,809
    DB 21,'WinQueryClipbrdViewer'
    DD @PMWIN,725
    DB 16,'WinDestroyCursor'
    DD @PMWIN,880
    DB 13,'WinShowCursor'
    DD @PMWIN,715
    DB 15,'WinCreateCursor'
    DD @PMWIN,812
    DB 18,'WinQueryCursorInfo'
    DD @PMWIN,866
    DB 13,'WinSetPointer'
    DD @PMWIN,971
    DB 18,'WinSetPointerOwner'
    DD @PMWIN,881
    DB 14,'WinShowPointer'
    DD @PMWIN,639
    DB 20,'WinLockPointerUpdate'
    DD @PMWIN,828
    DB 18,'WinQuerySysPointer'
    DD @PMWIN,780
    DB 14,'WinLoadPointer'
    DD @PMWIN,717
    DB 16,'WinCreatePointer'
    DD @PMWIN,867
    DB 16,'WinSetPointerPos'
    DD @PMWIN,727
    DB 17,'WinDestroyPointer'
    DD @PMWIN,821
    DB 15,'WinQueryPointer'
    DD @PMWIN,823
    DB 18,'WinQueryPointerPos'
    DD @PMWIN,942
    DB 24,'WinCreatePointerIndirect'
    DD @PMWIN,822
    DB 19,'WinQueryPointerInfo'
    DD @PMWIN,732
    DB 14,'WinDrawPointer'
    DD @PMWIN,760
    DB 15,'WinGetSysBitmap'
    DD @PMWIN,928
    DB 10,'WinSetHook'
    DD @PMWIN,927
    DB 14,'WinReleaseHook'
    DD @PMWIN,905
    DB 16,'WinCallMsgFilter'
    DD @PMWIN,930
    DB 20,'WinSetClassThunkProc'
    DD @PMWIN,931
    DB 22,'WinQueryClassThunkProc'
    DD @PMWIN,932
    DB 21,'WinSetWindowThunkProc'
    DD @PMWIN,933
    DB 23,'WinQueryWindowThunkProc'
    DD @PMWIN,934
    DB 19,'WinQueryWindowModel'
    DD @PMWIN,810
    DB 10,'WinQueryCp'
    DD @PMWIN,857
    DB 8,'WinSetCp'
    DD @PMWIN,811
    DB 14,'WinQueryCpList'
    DD @PMWIN,712
    DB 20,'WinCpTranslateString'
    DD @PMWIN,711
    DB 18,'WinCpTranslateChar'
    DD @PMWIN,893
    DB 8,'WinUpper'
    DD @PMWIN,894
    DB 12,'WinUpperChar'
    DD @PMWIN,791
    DB 11,'WinNextChar'
    DD @PMWIN,795
    DB 11,'WinPrevChar'
    DD @PMWIN,708
    DB 17,'WinCompareStrings'
    DD @PMWIN,830
    DB 23,'WinQuerySystemAtomTable'
    DD @PMWIN,714
    DB 18,'WinCreateAtomTable'
    DD @PMWIN,724
    DB 19,'WinDestroyAtomTable'
    DD @PMWIN,700
    DB 10,'WinAddAtom'
    DD @PMWIN,744
    DB 11,'WinFindAtom'
    DD @PMWIN,721
    DB 13,'WinDeleteAtom'
    DD @PMWIN,803
    DB 17,'WinQueryAtomUsage'
    DD @PMWIN,801
    DB 18,'WinQueryAtomLength'
    DD @PMWIN,802
    DB 16,'WinQueryAtomName'
    DD @PMWIN,753
    DB 15,'WinGetLastError'
    DD @PMWIN,751
    DB 15,'WinGetErrorInfo'
    DD @PMWIN,748
    DB 16,'WinFreeErrorInfo'
    DD @PMWIN,995
    DB 12,'WinLockInput'
    DD @PMWIN,990
    DB 15,'WinQuerySendMsg'
    DD @PMWIN,993
    DB 14,'WinQueueFromId'
    DD @PMWIN,991
    DB 11,'WinReplyMsg'
    DD @PMWIN,994
    DB 19,'WinThreadAssocQueue'
    DD @PMWIN,992
    DB 13,'WinWakeThread'
    DD 0
DBGHELP.!PmWinCalls ENDP

DBGHELP.!PMGpiCalls PROC NEAR32
    DD @PMGPI,369
    DB 11,'GpiCreatePS'
    DD @PMGPI,379
    DB 12,'GpiDestroyPS'
    DD @PMGPI,351
    DB 12,'GpiAssociate'
    DD @PMGPI,499
    DB 12,'GpiRestorePS'
    DD @PMGPI,501
    DB 9,'GpiSavePS'
    DD @PMGPI,389
    DB 8,'GpiErase'
    DD @PMGPI,444
    DB 14,'GpiQueryDevice'
    DD @PMGPI,498
    DB 10,'GpiResetPS'
    DD @PMGPI,539
    DB 8,'GpiSetPS'
    DD @PMGPI,471
    DB 10,'GpiQueryPS'
    DD @PMGPI,390
    DB 19,'GpiErrorSegmentData'
    DD @PMGPI,446
    DB 19,'GpiQueryDrawControl'
    DD @PMGPI,521
    DB 17,'GpiSetDrawControl'
    DD @PMGPI,447
    DB 19,'GpiQueryDrawingMode'
    DD @PMGPI,522
    DB 17,'GpiSetDrawingMode'
    DD @PMGPI,487
    DB 16,'GpiQueryStopDraw'
    DD @PMGPI,550
    DB 14,'GpiSetStopDraw'
    DD @PMGPI,366
    DB 17,'GpiCorrelateChain'
    DD @PMGPI,488
    DB 11,'GpiQueryTag'
    DD @PMGPI,551
    DB 9,'GpiSetTag'
    DD @PMGPI,478
    DB 24,'GpiQueryPickApertureSize'
    DD @PMGPI,589
    DB 22,'GpiSetPickApertureSize'
    DD @PMGPI,477
    DB 28,'GpiQueryPickAperturePosition'
    DD @PMGPI,545
    DB 26,'GpiSetPickAperturePosition'
    DD @PMGPI,428
    DB 20,'GpiQueryBoundaryData'
    DD @PMGPI,497
    DB 20,'GpiResetBoundaryData'
    DD @PMGPI,367
    DB 16,'GpiCorrelateFrom'
    DD @PMGPI,582
    DB 19,'GpiCorrelateSegment'
    DD @PMGPI,408
    DB 14,'GpiOpenSegment'
    DD @PMGPI,361
    DB 15,'GpiCloseSegment'
    DD @PMGPI,376
    DB 16,'GpiDeleteSegment'
    DD @PMGPI,455
    DB 27,'GpiQueryInitialSegmentAttrs'
    DD @PMGPI,527
    DB 25,'GpiSetInitialSegmentAttrs'
    DD @PMGPI,482
    DB 20,'GpiQuerySegmentAttrs'
    DD @PMGPI,547
    DB 18,'GpiSetSegmentAttrs'
    DD @PMGPI,484
    DB 23,'GpiQuerySegmentPriority'
    DD @PMGPI,548
    DB 21,'GpiSetSegmentPriority'
    DD @PMGPI,377
    DB 17,'GpiDeleteSegments'
    DD @PMGPI,483
    DB 20,'GpiQuerySegmentNames'
    DD @PMGPI,394
    DB 10,'GpiGetData'
    DD @PMGPI,421
    DB 10,'GpiPutData'
    DD @PMGPI,380
    DB 12,'GpiDrawChain'
    DD @PMGPI,382
    DB 11,'GpiDrawFrom'
    DD @PMGPI,383
    DB 14,'GpiDrawSegment'
    DD @PMGPI,381
    DB 15,'GpiDrawDynamics'
    DD @PMGPI,496
    DB 17,'GpiRemoveDynamics'
    DD @PMGPI,353
    DB 15,'GpiBeginElement'
    DD @PMGPI,386
    DB 13,'GpiEndElement'
    DD @PMGPI,397
    DB 8,'GpiLabel'
    DD @PMGPI,384
    DB 10,'GpiElement'
    DD @PMGPI,449
    DB 15,'GpiQueryElement'
    DD @PMGPI,372
    DB 16,'GpiDeleteElement'
    DD @PMGPI,373
    DB 21,'GpiDeleteElementRange'
    DD @PMGPI,374
    DB 30,'GpiDeleteElementsBetweenLabels'
    DD @PMGPI,448
    DB 16,'GpiQueryEditMode'
    DD @PMGPI,523
    DB 14,'GpiSetEditMode'
    DD @PMGPI,450
    DB 22,'GpiQueryElementPointer'
    DD @PMGPI,524
    DB 20,'GpiSetElementPointer'
    DD @PMGPI,406
    DB 23,'GpiOffsetElementPointer'
    DD @PMGPI,451
    DB 19,'GpiQueryElementType'
    DD @PMGPI,525
    DB 27,'GpiSetElementPointerAtLabel'
    DD @PMGPI,485
    DB 30,'GpiQuerySegmentTransformMatrix'
    DD @PMGPI,549
    DB 28,'GpiSetSegmentTransformMatrix'
    DD @PMGPI,364
    DB 10,'GpiConvert'
    DD @PMGPI,618
    DB 20,'GpiConvertWithMatrix'
    DD @PMGPI,468
    DB 28,'GpiQueryModelTransformMatrix'
    DD @PMGPI,538
    DB 26,'GpiSetModelTransformMatrix'
    DD @PMGPI,357
    DB 20,'GpiCallSegmentMatrix'
    DD @PMGPI,443
    DB 25,'GpiQueryDefaultViewMatrix'
    DD @PMGPI,520
    DB 23,'GpiSetDefaultViewMatrix'
    DD @PMGPI,472
    DB 20,'GpiQueryPageViewport'
    DD @PMGPI,540
    DB 18,'GpiSetPageViewport'
    DD @PMGPI,491
    DB 30,'GpiQueryViewingTransformMatrix'
    DD @PMGPI,553
    DB 28,'GpiSetViewingTransformMatrix'
    DD @PMGPI,564
    DB 12,'GpiTranslate'
    DD @PMGPI,565
    DB 8,'GpiScale'
    DD @PMGPI,566
    DB 9,'GpiRotate'
    DD @PMGPI,526
    DB 19,'GpiSetGraphicsField'
    DD @PMGPI,454
    DB 21,'GpiQueryGraphicsField'
    DD @PMGPI,552
    DB 19,'GpiSetViewingLimits'
    DD @PMGPI,490
    DB 21,'GpiQueryViewingLimits'
    DD @PMGPI,354
    DB 12,'GpiBeginPath'
    DD @PMGPI,387
    DB 10,'GpiEndPath'
    DD @PMGPI,360
    DB 14,'GpiCloseFigure'
    DD @PMGPI,403
    DB 13,'GpiModifyPath'
    DD @PMGPI,392
    DB 11,'GpiFillPath'
    DD @PMGPI,515
    DB 14,'GpiSetClipPath'
    DD @PMGPI,563
    DB 14,'GpiOutlinePath'
    DD @PMGPI,559
    DB 15,'GpiPathToRegion'
    DD @PMGPI,554
    DB 13,'GpiStrokePath'
    DD @PMGPI,592
    DB 22,'GpiCreateLogColorTable'
    DD @PMGPI,438
    DB 17,'GpiQueryColorData'
    DD @PMGPI,593
    DB 21,'GpiQueryLogColorTable'
    DD @PMGPI,480
    DB 18,'GpiQueryRealColors'
    DD @PMGPI,469
    DB 20,'GpiQueryNearestColor'
    DD @PMGPI,439
    DB 18,'GpiQueryColorIndex'
    DD @PMGPI,479
    DB 16,'GpiQueryRGBColor'
    DD @PMGPI,594
    DB 16,'GpiCreatePalette'
    DD @PMGPI,577
    DB 16,'GpiDeletePalette'
    DD @PMGPI,578
    DB 16,'GpiSelectPalette'
    DD @PMGPI,595
    DB 17,'GpiAnimatePalette'
    DD @PMGPI,596
    DB 20,'GpiSetPaletteEntries'
    DD @PMGPI,579
    DB 15,'GpiQueryPalette'
    DD @PMGPI,597
    DB 19,'GpiQueryPaletteInfo'
    DD @PMGPI,517
    DB 11,'GpiSetColor'
    DD @PMGPI,437
    DB 13,'GpiQueryColor'
    DD @PMGPI,356
    DB 6,'GpiBox'
    DD @PMGPI,404
    DB 7,'GpiMove'
    DD @PMGPI,398
    DB 7,'GpiLine'
    DD @PMGPI,415
    DB 11,'GpiPolyLine'
    DD @PMGPI,558
    DB 19,'GpiPolyLineDisjoint'
    DD @PMGPI,541
    DB 13,'GpiSetPattern'
    DD @PMGPI,473
    DB 15,'GpiQueryPattern'
    DD @PMGPI,352
    DB 12,'GpiBeginArea'
    DD @PMGPI,385
    DB 10,'GpiEndArea'
    DD @PMGPI,358
    DB 13,'GpiCharString'
    DD @PMGPI,359
    DB 15,'GpiCharStringAt'
    DD @PMGPI,503
    DB 14,'GpiSetAttrMode'
    DD @PMGPI,423
    DB 16,'GpiQueryAttrMode'
    DD @PMGPI,588
    DB 11,'GpiSetAttrs'
    DD @PMGPI,583
    DB 13,'GpiQueryAttrs'
    DD @PMGPI,504
    DB 15,'GpiSetBackColor'
    DD @PMGPI,424
    DB 17,'GpiQueryBackColor'
    DD @PMGPI,537
    DB 9,'GpiSetMix'
    DD @PMGPI,467
    DB 11,'GpiQueryMix'
    DD @PMGPI,505
    DB 13,'GpiSetBackMix'
    DD @PMGPI,425
    DB 15,'GpiQueryBackMix'
    DD @PMGPI,530
    DB 14,'GpiSetLineType'
    DD @PMGPI,459
    DB 16,'GpiQueryLineType'
    DD @PMGPI,531
    DB 15,'GpiSetLineWidth'
    DD @PMGPI,460
    DB 17,'GpiQueryLineWidth'
    DD @PMGPI,532
    DB 19,'GpiSetLineWidthGeom'
    DD @PMGPI,461
    DB 21,'GpiQueryLineWidthGeom'
    DD @PMGPI,528
    DB 13,'GpiSetLineEnd'
    DD @PMGPI,457
    DB 15,'GpiQueryLineEnd'
    DD @PMGPI,529
    DB 14,'GpiSetLineJoin'
    DD @PMGPI,458
    DB 16,'GpiQueryLineJoin'
    DD @PMGPI,519
    DB 21,'GpiSetCurrentPosition'
    DD @PMGPI,441
    DB 23,'GpiQueryCurrentPosition'
    DD @PMGPI,502
    DB 15,'GpiSetArcParams'
    DD @PMGPI,422
    DB 17,'GpiQueryArcParams'
    DD @PMGPI,412
    DB 11,'GpiPointArc'
    DD @PMGPI,393
    DB 10,'GpiFullArc'
    DD @PMGPI,612
    DB 13,'GpiPartialArc'
    DD @PMGPI,413
    DB 13,'GpiPolyFillet'
    DD @PMGPI,417
    DB 13,'GpiPolySpline'
    DD @PMGPI,414
    DB 18,'GpiPolyFilletSharp'
    DD @PMGPI,543
    DB 16,'GpiSetPatternSet'
    DD @PMGPI,475
    DB 18,'GpiQueryPatternSet'
    DD @PMGPI,542
    DB 21,'GpiSetPatternRefPoint'
    DD @PMGPI,474
    DB 23,'GpiQueryPatternRefPoint'
    DD @PMGPI,584
    DB 21,'GpiQueryCharStringPos'
    DD @PMGPI,585
    DB 23,'GpiQueryCharStringPosAt'
    DD @PMGPI,489
    DB 15,'GpiQueryTextBox'
    DD @PMGPI,442
    DB 18,'GpiQueryDefCharBox'
    DD @PMGPI,513
    DB 13,'GpiSetCharSet'
    DD @PMGPI,433
    DB 15,'GpiQueryCharSet'
    DD @PMGPI,510
    DB 13,'GpiSetCharBox'
    DD @PMGPI,430
    DB 15,'GpiQueryCharBox'
    DD @PMGPI,509
    DB 15,'GpiSetCharAngle'
    DD @PMGPI,429
    DB 17,'GpiQueryCharAngle'
    DD @PMGPI,514
    DB 15,'GpiSetCharShear'
    DD @PMGPI,434
    DB 17,'GpiQueryCharShear'
    DD @PMGPI,511
    DB 19,'GpiSetCharDirection'
    DD @PMGPI,431
    DB 21,'GpiQueryCharDirection'
    DD @PMGPI,512
    DB 14,'GpiSetCharMode'
    DD @PMGPI,432
    DB 16,'GpiQueryCharMode'
    DD @PMGPI,649
    DB 19,'GpiSetTextAlignment'
    DD @PMGPI,648
    DB 21,'GpiQueryTextAlignment'
    DD @PMGPI,580
    DB 16,'GpiCharStringPos'
    DD @PMGPI,581
    DB 18,'GpiCharStringPosAt'
    DD @PMGPI,614
    DB 15,'GpiSetCharExtra'
    DD @PMGPI,616
    DB 20,'GpiSetCharBreakExtra'
    DD @PMGPI,613
    DB 17,'GpiQueryCharExtra'
    DD @PMGPI,615
    DB 22,'GpiQueryCharBreakExtra'
    DD @PMGPI,402
    DB 9,'GpiMarker'
    DD @PMGPI,416
    DB 13,'GpiPolyMarker'
    DD @PMGPI,533
    DB 12,'GpiSetMarker'
    DD @PMGPI,534
    DB 15,'GpiSetMarkerBox'
    DD @PMGPI,535
    DB 15,'GpiSetMarkerSet'
    DD @PMGPI,462
    DB 14,'GpiQueryMarker'
    DD @PMGPI,463
    DB 17,'GpiQueryMarkerBox'
    DD @PMGPI,464
    DB 17,'GpiQueryMarkerSet'
    DD @PMGPI,395
    DB 8,'GpiImage'
    DD @PMGPI,418
    DB 6,'GpiPop'
    DD @PMGPI,420
    DB 12,'GpiPtVisible'
    DD @PMGPI,495
    DB 14,'GpiRectVisible'
    DD @PMGPI,363
    DB 10,'GpiComment'
    DD @PMGPI,368
    DB 16,'GpiCreateLogFont'
    DD @PMGPI,378
    DB 14,'GpiDeleteSetId'
    DD @PMGPI,400
    DB 12,'GpiLoadFonts'
    DD @PMGPI,555
    DB 14,'GpiUnloadFonts'
    DD @PMGPI,586
    DB 13,'GpiQueryFonts'
    DD @PMGPI,453
    DB 19,'GpiQueryFontMetrics'
    DD @PMGPI,456
    DB 20,'GpiQueryKerningPairs'
    DD @PMGPI,492
    DB 18,'GpiQueryWidthTable'
    DD @PMGPI,470
    DB 20,'GpiQueryNumberSetIds'
    DD @PMGPI,486
    DB 14,'GpiQuerySetIds'
    DD @PMGPI,575
    DB 18,'GpiQueryFaceString'
    DD @PMGPI,574
    DB 19,'GpiQueryLogicalFont'
    DD @PMGPI,576
    DB 18,'GpiQueryFontAction'
    DD @PMGPI,622
    DB 18,'GpiLoadPublicFonts'
    DD @PMGPI,623
    DB 20,'GpiUnloadPublicFonts'
    DD @PMGPI,518
    DB 8,'GpiSetCp'
    DD @PMGPI,440
    DB 10,'GpiQueryCp'
    DD @PMGPI,452
    DB 28,'GpiQueryFontFileDescriptions'
    DD @PMGPI,355
    DB 9,'GpiBitBlt'
    DD @PMGPI,371
    DB 15,'GpiDeleteBitmap'
    DD @PMGPI,399
    DB 13,'GpiLoadBitmap'
    DD @PMGPI,506
    DB 12,'GpiSetBitmap'
    DD @PMGPI,557
    DB 11,'GpiWCBitBlt'
    DD @PMGPI,598
    DB 15,'GpiCreateBitmap'
    DD @PMGPI,602
    DB 16,'GpiSetBitmapBits'
    DD @PMGPI,507
    DB 21,'GpiSetBitmapDimension'
    DD @PMGPI,508
    DB 14,'GpiSetBitmapId'
    DD @PMGPI,599
    DB 18,'GpiQueryBitmapBits'
    DD @PMGPI,426
    DB 23,'GpiQueryBitmapDimension'
    DD @PMGPI,427
    DB 20,'GpiQueryBitmapHandle'
    DD @PMGPI,573
    DB 24,'GpiQueryBitmapParameters'
    DD @PMGPI,601
    DB 24,'GpiQueryBitmapInfoHeader'
    DD @PMGPI,445
    DB 27,'GpiQueryDeviceBitmapFormats'
    DD @PMGPI,544
    DB 9,'GpiSetPel'
    DD @PMGPI,476
    DB 11,'GpiQueryPel'
    DD @PMGPI,560
    DB 12,'GpiFloodFill'
    DD @PMGPI,603
    DB 11,'GpiDrawBits'
    DD @PMGPI,362
    DB 16,'GpiCombineRegion'
    DD @PMGPI,370
    DB 15,'GpiCreateRegion'
    DD @PMGPI,611
    DB 16,'GpiDestroyRegion'
    DD @PMGPI,388
    DB 14,'GpiEqualRegion'
    DD @PMGPI,407
    DB 15,'GpiOffsetRegion'
    DD @PMGPI,409
    DB 14,'GpiPaintRegion'
    DD @PMGPI,617
    DB 14,'GpiFrameRegion'
    DD @PMGPI,419
    DB 13,'GpiPtInRegion'
    DD @PMGPI,481
    DB 17,'GpiQueryRegionBox'
    DD @PMGPI,587
    DB 19,'GpiQueryRegionRects'
    DD @PMGPI,494
    DB 15,'GpiRectInRegion'
    DD @PMGPI,546
    DB 12,'GpiSetRegion'
    DD @PMGPI,516
    DB 16,'GpiSetClipRegion'
    DD @PMGPI,436
    DB 18,'GpiQueryClipRegion'
    DD @PMGPI,435
    DB 15,'GpiQueryClipBox'
    DD @PMGPI,391
    DB 23,'GpiExcludeClipRectangle'
    DD @PMGPI,396
    DB 25,'GpiIntersectClipRectangle'
    DD @PMGPI,405
    DB 19,'GpiOffsetClipRegion'
    DD @PMGPI,365
    DB 15,'GpiCopyMetaFile'
    DD @PMGPI,375
    DB 17,'GpiDeleteMetaFile'
    DD @PMGPI,401
    DB 15,'GpiLoadMetaFile'
    DD @PMGPI,411
    DB 15,'GpiPlayMetaFile'
    DD @PMGPI,465
    DB 20,'GpiQueryMetaFileBits'
    DD @PMGPI,466
    DB 22,'GpiQueryMetaFileLength'
    DD @PMGPI,500
    DB 15,'GpiSaveMetaFile'
    DD @PMGPI,536
    DB 18,'GpiSetMetaFileBits'
    DD @PMGPI,567
    DB 20,'GpiQueryDefArcParams'
    DD @PMGPI,590
    DB 16,'GpiQueryDefAttrs'
    DD @PMGPI,568
    DB 14,'GpiQueryDefTag'
    DD @PMGPI,569
    DB 24,'GpiQueryDefViewingLimits'
    DD @PMGPI,570
    DB 18,'GpiSetDefArcParams'
    DD @PMGPI,591
    DB 14,'GpiSetDefAttrs'
    DD @PMGPI,571
    DB 12,'GpiSetDefTag'
    DD @PMGPI,572
    DB 22,'GpiSetDefViewingLimits'
    DD @PMGPI,650
    DB 11,'GpiPolygons'
    DD 0
DBGHELP.!PmGpiCalls ENDP

DBGHELP.!DosCalls PROC NEAR32
    DD @DOSCALLS,286
    DB 7,'DosBeep'
    DD @DOSCALLS,234
    DB 7,'DosExit'
    DD @DOSCALLS,311
    DB 15,'DosCreateThread'
    DD @DOSCALLS,237
    DB 15,'DosResumeThread'
    DD @DOSCALLS,238
    DB 16,'DosSuspendThread'
    DD @DOSCALLS,312
    DB 16,'DosGetInfoBlocks'
    DD @DOSCALLS,111
    DB 13,'DosKillThread'
    DD @DOSCALLS,280
    DB 12,'DosWaitChild'
    DD @DOSCALLS,349
    DB 13,'DosWaitThread'
    DD @DOSCALLS,229
    DB 8,'DosSleep'
    DD @DOSCALLS,317
    DB 8,'DosDebug'
    DD @DOSCALLS,232
    DB 15,'DosEnterCritSec'
    DD @DOSCALLS,233
    DB 14,'DosExitCritSec'
    DD @DOSCALLS,296
    DB 11,'DosExitList'
    DD @DOSCALLS,283
    DB 10,'DosExecPgm'
    DD @DOSCALLS,236
    DB 14,'DosSetPriority'
    DD @DOSCALLS,235
    DB 14,'DosKillProcess'
    DD @DOSCALLS,428
    DB 15,'DosSetFileLocks'
    DD @DOSCALLS,639
    DB 22,'DosProtectSetFileLocks'
    DD @DOSCALLS,429
    DB 20,'DosCancelLockRequest'
    DD @DOSCALLS,273
    DB 7,'DosOpen'
    DD @DOSCALLS,637
    DB 14,'DosProtectOpen'
    DD @DOSCALLS,257
    DB 8,'DosClose'
    DD @DOSCALLS,638
    DB 15,'DosProtectClose'
    DD @DOSCALLS,281
    DB 7,'DosRead'
    DD @DOSCALLS,641
    DB 14,'DosProtectRead'
    DD @DOSCALLS,282
    DB 8,'DosWrite'
    DD @DOSCALLS,642
    DB 15,'DosProtectWrite'
    DD @DOSCALLS,259
    DB 9,'DosDelete'
    DD @DOSCALLS,110
    DB 14,'DosForceDelete'
    DD @DOSCALLS,260
    DB 12,'DosDupHandle'
    DD @DOSCALLS,276
    DB 15,'DosQueryFHState'
    DD @DOSCALLS,645
    DB 22,'DosProtectQueryFHState'
    DD @DOSCALLS,221
    DB 13,'DosSetFHState'
    DD @DOSCALLS,644
    DB 20,'DosProtectSetFHState'
    DD @DOSCALLS,224
    DB 13,'DosQueryHType'
    DD @DOSCALLS,264
    DB 12,'DosFindFirst'
    DD @DOSCALLS,265
    DB 11,'DosFindNext'
    DD @DOSCALLS,263
    DB 12,'DosFindClose'
    DD @DOSCALLS,269
    DB 11,'DosFSAttach'
    DD @DOSCALLS,277
    DB 16,'DosQueryFSAttach'
    DD @DOSCALLS,285
    DB 8,'DosFSCtl'
    DD @DOSCALLS,272
    DB 14,'DosSetFileSize'
    DD @DOSCALLS,640
    DB 21,'DosProtectSetFileSize'
    DD @DOSCALLS,254
    DB 14,'DosResetBuffer'
    DD @DOSCALLS,256
    DB 13,'DosSetFilePtr'
    DD @DOSCALLS,621
    DB 20,'DosProtectSetFilePtr'
    DD @DOSCALLS,271
    DB 7,'DosMove'
    DD @DOSCALLS,258
    DB 7,'DosCopy'
    DD @DOSCALLS,261
    DB 11,'DosEditName'
    DD @DOSCALLS,270
    DB 12,'DosCreateDir'
    DD @DOSCALLS,226
    DB 12,'DosDeleteDir'
    DD @DOSCALLS,220
    DB 17,'DosSetDefaultDisk'
    DD @DOSCALLS,275
    DB 19,'DosQueryCurrentDisk'
    DD @DOSCALLS,255
    DB 16,'DosSetCurrentDir'
    DD @DOSCALLS,274
    DB 21,'DosQueryCurrentDirAPI'
    DD @DOSCALLS,278
    DB 14,'DosQueryFSInfo'
    DD @DOSCALLS,222
    DB 12,'DosSetFSInfo'
    DD @DOSCALLS,225
    DB 14,'DosQueryVerify'
    DD @DOSCALLS,210
    DB 12,'DosSetVerify'
    DD @DOSCALLS,209
    DB 11,'DosSetMaxFH'
    DD @DOSCALLS,382
    DB 14,'DosSetRelMaxFH'
    DD @DOSCALLS,279
    DB 16,'DosQueryFileInfo'
    DD @DOSCALLS,646
    DB 23,'DosProtectQueryFileInfo'
    DD @DOSCALLS,218
    DB 14,'DosSetFileInfo'
    DD @DOSCALLS,643
    DB 21,'DosProtectSetFileInfo'
    DD @DOSCALLS,223
    DB 16,'DosQueryPathInfo'
    DD @DOSCALLS,219
    DB 14,'DosSetPathInfo'
    DD @DOSCALLS,415
    DB 11,'DosShutdown'
    DD @DOSCALLS,372
    DB 16,'DosEnumAttribute'
    DD @DOSCALLS,636
    DB 23,'DosProtectEnumAttribute'
    DD @DOSCALLS,299
    DB 11,'DosAllocMem'
    DD @DOSCALLS,304
    DB 10,'DosFreeMem'
    DD @DOSCALLS,305
    DB 9,'DosSetMem'
    DD @DOSCALLS,303
    DB 16,'DosGiveSharedMem'
    DD @DOSCALLS,302
    DB 15,'DosGetSharedMem'
    DD @DOSCALLS,301
    DB 20,'DosGetNamedSharedMem'
    DD @DOSCALLS,300
    DB 17,'DosAllocSharedMem'
    DD @DOSCALLS,306
    DB 11,'DosQueryMem'
    DD @DOSCALLS,345
    DB 14,'DosSubAllocMem'
    DD @DOSCALLS,346
    DB 13,'DosSubFreeMem'
    DD @DOSCALLS,344
    DB 12,'DosSubSetMem'
    DD @DOSCALLS,347
    DB 14,'DosSubUnsetMem'
    DD @DOSCALLS,324
    DB 17,'DosCreateEventSem'
    DD @DOSCALLS,325
    DB 15,'DosOpenEventSem'
    DD @DOSCALLS,326
    DB 16,'DosCloseEventSem'
    DD @DOSCALLS,327
    DB 16,'DosResetEventSem'
    DD @DOSCALLS,328
    DB 15,'DosPostEventSem'
    DD @DOSCALLS,329
    DB 15,'DosWaitEventSem'
    DD @DOSCALLS,330
    DB 16,'DosQueryEventSem'
    DD @DOSCALLS,331
    DB 17,'DosCreateMutexSem'
    DD @DOSCALLS,332
    DB 15,'DosOpenMutexSem'
    DD @DOSCALLS,333
    DB 16,'DosCloseMutexSem'
    DD @DOSCALLS,334
    DB 18,'DosRequestMutexSem'
    DD @DOSCALLS,335
    DB 18,'DosReleaseMutexSem'
    DD @DOSCALLS,336
    DB 16,'DosQueryMutexSem'
    DD @DOSCALLS,337
    DB 19,'DosCreateMuxWaitSem'
    DD @DOSCALLS,338
    DB 17,'DosOpenMuxWaitSem'
    DD @DOSCALLS,339
    DB 18,'DosCloseMuxWaitSem'
    DD @DOSCALLS,340
    DB 17,'DosWaitMuxWaitSem'
    DD @DOSCALLS,341
    DB 16,'DosAddMuxWaitSem'
    DD @DOSCALLS,342
    DB 19,'DosDeleteMuxWaitSem'
    DD @DOSCALLS,343
    DB 18,'DosQueryMuxWaitSem'
    DD @DOSCALLS,230
    DB 14,'DosGetDateTime'
    DD @DOSCALLS,350
    DB 14,'DosSetDateTime'
    DD @DOSCALLS,350
    DB 13,'DosAsyncTimer'
    DD @DOSCALLS,351
    DB 13,'DosStartTimer'
    DD @DOSCALLS,290
    DB 12,'DosStopTimer'
    DD @DOSCALLS,318
    DB 13,'DosLoadModule'
    DD @DOSCALLS,322
    DB 13,'DosFreeModule'
    DD @DOSCALLS,321
    DB 16,'DosQueryProcAddr'
    DD @DOSCALLS,319
    DB 20,'DosQueryModuleHandle'
    DD @DOSCALLS,320
    DB 18,'DosQueryModuleName'
    DD @DOSCALLS,586
    DB 16,'DosQueryProcType'
    DD @DOSCALLS,352
    DB 14,'DosGetResource'
    DD @DOSCALLS,353
    DB 15,'DosFreeResource'
    DD @DOSCALLS,572
    DB 20,'DosQueryResourceSize'
    DD @NLS,5
    DB 16,'DosQueryCtryInfo'
    DD @NLS,6
    DB 15,'DosQueryDBCSEnv'
    DD @NLS,7
    DB 10,'DosMapCase'
    DD @NLS,8
    DB 15,'DosQueryCollate'
    DD @DOSCALLS,291
    DB 10,'DosQueryCp'
    DD @DOSCALLS,289
    DB 15,'DosSetProcessCp'
    DD @DOSCALLS,354
    DB 22,'DosSetExceptionHandler'
    DD @DOSCALLS,355
    DB 24,'DosUnsetExceptionHandler'
    DD @DOSCALLS,356
    DB 17,'DosRaiseException'
    DD @DOSCALLS,379
    DB 22,'DosSendSignalException'
    DD @DOSCALLS,357
    DB 18,'DosUnwindException'
    DD @DOSCALLS,378
    DB 26,'DosSetSignalExceptionFocus'
    DD @DOSCALLS,380
    DB 20,'DosEnterMustComplete'
    DD @DOSCALLS,381
    DB 19,'DosExitMustComplete'
    DD @DOSCALLS,418
    DB 29,'DosAcknowledgeSignalException'
    DD @DOSCALLS,239
    DB 13,'DosCreatePipe'
    DD @QUECALLS,11
    DB 13,'DosCloseQueue'
    DD @QUECALLS,16
    DB 14,'DosCreateQueue'
    DD @QUECALLS,15
    DB 12,'DosOpenQueue'
    DD @QUECALLS,13
    DB 12,'DosPeekQueue'
    DD @QUECALLS,10
    DB 13,'DosPurgeQueue'
    DD @QUECALLS,12
    DB 13,'DosQueryQueue'
    DD @QUECALLS,9
    DB 12,'DosReadQueue'
    DD @QUECALLS,14
    DB 13,'DosWriteQueue'
    DD @DOSCALLS,212
    DB 11,'DosErrorAPI'
    DD @MSG,6
    DB 13,'DosGetMessage'
    DD @DOSCALLS,211
    DB 11,'DosErrClass'
    DD @MSG,4
    DB 16,'DosInsertMessage'
    DD @MSG,5
    DB 13,'DosPutMessage'
    DD @DOSCALLS,348
    DB 15,'DosQuerySysInfo'
    DD @DOSCALLS,227
    DB 10,'DosScanEnv'
    DD @DOSCALLS,228
    DB 13,'DosSearchPath'
    DD @MSG,8
    DB 17,'DosQueryMessageCP'
    DD @DOSCALLS,112
    DB 15,'DosQueryRASInfo'
    DD @SESMGR,37
    DB 15,'DosStartSession'
    DD @SESMGR,39
    DB 13,'DosSetSession'
    DD @SESMGR,38
    DB 19,'DosSelectSessionAPI'
    DD @SESMGR,40
    DB 14,'DosStopSession'
    DD @DOSCALLS,323
    DB 15,'DosQueryAppType'
    DD @DOSCALLS,231
    DB 12,'DosDevConfig'
    DD @DOSCALLS,284
    DB 11,'DosDevIOCtl'
    DD @DOSCALLS,287
    DB 15,'DosPhysicalDisk'
    DD @DOSCALLS,240
    DB 12,'DosCallNPipe'
    DD @DOSCALLS,241
    DB 15,'DosConnectNPipe'
    DD @DOSCALLS,242
    DB 18,'DosDisConnectNPipe'
    DD @DOSCALLS,243
    DB 14,'DosCreateNPipe'
    DD @DOSCALLS,244
    DB 12,'DosPeekNPipe'
    DD @DOSCALLS,245
    DB 16,'DosQueryNPHState'
    DD @DOSCALLS,248
    DB 17,'DosQueryNPipeInfo'
    DD @DOSCALLS,249
    DB 21,'DosQueryNPipeSemState'
    DD @DOSCALLS,246
    DB 15,'DosRawReadNPipe'
    DD @DOSCALLS,247
    DB 16,'DosRawWriteNPipe'
    DD @DOSCALLS,250
    DB 14,'DosSetNPHState'
    DD @DOSCALLS,251
    DB 14,'DosSetNPipeSem'
    DD @DOSCALLS,252
    DB 16,'DosTransactNPipe'
    DD @DOSCALLS,253
    DB 12,'DosWaitNPipe'
    DD @DOSCALLS,362
    DB 15,'DosTmrQueryFreq'
    DD @DOSCALLS,363
    DB 15,'DosTmrQueryTime'
    DD @DOSCALLS,367
    DB 19,'DosRegisterPerfCtrs'
    DD @DOSCALLS,308
    DB 10,'DosOpenVDD'
    DD @DOSCALLS,309
    DB 13,'DosRequestVDD'
    DD @DOSCALLS,310
    DB 11,'DosCloseVDD'
    DD @DOSCALLS,373
    DB 19,'DosQueryDOSProperty'
    DD @DOSCALLS,374
    DB 17,'DosSetDOSProperty'
    DD 0
DBGHELP.!DosCalls ENDP

END;
{$ENDIF}

FUNCTION CheckDlls(Addr:LONGWORD;Proc:POINTER):POINTER;ASSEMBLER;
     {Check libraries}
     ASM
        MOVD [EBP-4],0
        MOV EBX,Addr
        MOV ESI,Proc
        CLD
        JMP !loop1
!loop2:
        MOVZXB ECX,[ESI]
        INC ECX
        ADD ESI,ECX
!loop1:
        LODSD
        ADD EAX,ESI
        CMP EAX,EBX
        JE !found
        CMP EAX,ESI
        JNE !loop2    //until end
        JMP !notfound
!found:
        MOV [EBP-4],ESI
!notfound:
        MOV EAX,[EBP-4]
        MOV Result,EAX
     END;

FUNCTION GetNearestProc(EIP:LONGWORD):STRING;
VAR Module,ThisModule:PModuleInfo;
    Symbols:PSymbolsInfo;
BEGIN
    result:='';
    Module:=ModuleInfo;
    ThisModule:=NIL;
    WHILE Module<>NIL DO
    BEGIN
         IF EIP>=Module^.CodeOffs THEN
           IF EIP<=Module^.CodeOffs+Module^.CodeLen THEN
         BEGIN  {Within this module}
              ThisModule:=Module;
              Symbols:=Module^.SymbolsInfo;
              WHILE Symbols<>NIL DO
              BEGIN
                   IF EIP>=Symbols^.Offset THEN IF EIP<Symbols^.Offset+Symbols^.Len THEN
                   BEGIN
                        result:=Symbols^.SymbolName^;
                        exit;
                   END;
                   Symbols:=Symbols^.Next;
              END;
         END;
         Module:=Module^.Next;
    END;
END;

FUNCTION DbgLineAvail(CONST Source:STRING;Line:LongWord):BOOLEAN;
VAR Module:PModuleInfo;
    Lines:PLineNumberInfo;

BEGIN
     result:=FALSE;
     //FSplit(Source,d,n,e);
     //Source:=n+e;
     Module:=ModuleInfo;
     WHILE Module<>NIL DO
     BEGIN
          IF Module^.SourceFile=Source THEN
          BEGIN
               Lines:=Module^.LineNumberInfo;
               WHILE Lines<>NIL DO
               BEGIN
                    IF Lines^.LineNumber=Line THEN
                    BEGIN
                         result:=TRUE;
                         exit;
                    END;
                    Lines:=Lines^.Next;
               END;
          END;
          Module:=Module^.Next;
     END;
END;

FUNCTION GetNameFromAddr(Addr:LONGWORD;Typ:TAddrType;Offset:LONGINT):STRING;
VAR
    EIP:ULONG;
    Module:PModuleInfo;
    ThisModule:PModuleInfo;
    Symbols,Locals,MaxLocalOffset:PSymbolsInfo;
    s,s1:STRING;
    Publics:PPublicsInfo;
    t1:BYTE;
    ps:^STRING;
{$IFDEF OS2}
    p:POINTER;
{$ENDIF}

LABEL ex1;
BEGIN
     result:='';
     CASE Typ OF
        AddrLocal:
        BEGIN
             {look if it is a local variable}
             EIP:=Addr;
             Module:=ModuleInfo;
             ThisModule:=NIL;
             WHILE Module<>NIL DO
             BEGIN
                  IF EIP>=Module^.CodeOffs THEN
                    IF EIP<=Module^.CodeOffs+Module^.CodeLen THEN
                  BEGIN  {Within this module}
                       ThisModule:=Module;
                       Symbols:=Module^.SymbolsInfo;
                       WHILE Symbols<>NIL DO
                       BEGIN
                            IF EIP>=Symbols^.Offset THEN
                             IF EIP<Symbols^.Offset+Symbols^.Len THEN {within this proc}
                            BEGIN
                                 Locals:=Symbols^.Symbols;
                                 MaxLocalOffset:=NIL;
                                 WHILE Locals<>NIL DO
                                 BEGIN
                                      IF Locals^.Offset=Offset THEN
                                      BEGIN
                                           result:=Locals^.SymbolName^;
ex1:
                                           IF Offset<0 THEN
                                           BEGIN
                                                result:=result+' ([EBP-';
                                                Offset:=-Offset;
                                           END
                                           ELSE result:=result+' ([EBP+';
                                           s:=tohex(Offset);
                                           Delete(s,1,1);
                                           IF Offset<65536 THEN Delete(s,1,4);
                                           IF Offset<256 THEN Delete(s,1,2);
                                           result:=result+s+'])';

                                           exit;
                                      END
                                      ELSE IF Locals^.Offset<Offset THEN
                                      BEGIN
                                           IF Offset<0 THEN MaxLocalOffset:=Locals;
                                      END;
                                      Locals:=Locals^.Next;
                                 END;

                                 IF MaxLocalOffset<>NIL THEN
                                 BEGIN
                                      result:=MaxLocalOffset^.SymbolName^;
                                      s:=tohex(Offset-MaxLocalOffset^.Offset);
                                      Delete(s,1,1);
                                      IF Offset-MaxLocalOffset^.Offset<65545 THEN
                                         delete(s,1,4);
                                      IF Offset-MaxLocalOffset^.Offset<255 THEN
                                         delete(s,1,2);
                                      result:=result+'+'+s;
                                      Offset:=MaxLocalOffset^.Offset+(Offset-MaxLocalOffset^.Offset);
                                      goto ex1;
                                 END;

                                 exit;
                            END;
                            Symbols:=Symbols^.Next;
                       END;
                  END;
                  Module:=Module^.Next;
             END;
        END; {AddrLocal}
        AddrData:
        BEGIN
             {Now look if it is a global variable}
             Module:=ModuleInfo;
             WHILE Module<>NIL DO
             BEGIN
                  Publics:=Module^.PublicsInfo;
                  WHILE Publics<>NIL DO
                  BEGIN
                       IF Publics^.ObjectIndex=2 THEN {Data segment}
                        IF Publics^.Offset{+Module^.CodeOffs}=Offset THEN
                       BEGIN
                            s1:=Publics^.PublicName^;
                            UpcaseStr(s1);
                            t1:=pos('!',s1);
                            IF t1<>0 THEN s1[0]:=chr(t1-1);
                            {t1:=pos('.',s1);
                            IF t1<>0 THEN s1:=copy(s1,t1+1,length(s1)-t1);}
                            s:=tohex(Offset);
                            Delete(s,1,1);
                            s:=' ('+s+')';
                            result:=s1+s;
                            exit;
                       END;
                       Publics:=Publics^.Next;
                  END;
                  Module:=Module^.Next;
             END;
        END; {AddrData}
        AddrCode:
        BEGIN
             {look if it is a local variable}
             EIP:=Addr;
             Module:=ModuleInfo;
             ThisModule:=NIL;
             WHILE Module<>NIL DO
             BEGIN
                  IF EIP>=Module^.CodeOffs THEN
                    IF EIP<=Module^.CodeOffs+Module^.CodeLen THEN
                  BEGIN  {Within this module}
                       ThisModule:=Module;
                       Symbols:=Module^.SymbolsInfo;
                       WHILE Symbols<>NIL DO
                       BEGIN
                            IF EIP=Symbols^.Offset THEN
                            BEGIN
                                 s:=tohex(EIP);
                                 Delete(s,1,1);
                                 s:=' ('+s+')';
                                 result:=Symbols^.SymbolName^+s;
                                 exit;
                            END;
                            Symbols:=Symbols^.Next;
                       END;
                  END;
                  Module:=Module^.Next;
             END;

             IF Addr>$1000000 THEN
             BEGIN
                  ps:=NIL;
                  {$IFDEF OS2}
                  {Check libraries}
                  ASM
                     MOV EAX,@DBGHELP.!PmWinCalls
                     MOV p,EAX
                  END;
                  ps:=CheckDlls(Addr,p);
                  IF ps<>NIL THEN
                  BEGIN
                       s:=tohex(Addr);
                       Delete(s,1,1);
                       s:=' ('+s+')';
                       result:='PMWIN.'+ps^+s;
                       exit;
                  END;
                  ASM
                     MOV EAX,@DBGHELP.!PmGpiCalls
                     MOV p,EAX
                  END;
                  ps:=CheckDlls(Addr,p);
                  IF ps<>NIL THEN
                  BEGIN
                       s:=tohex(Addr);
                       Delete(s,1,1);
                       s:=' ('+s+')';
                       result:='PMGPI.'+ps^+s;
                       exit;
                  END;
                  ASM
                     MOV EAX,@DBGHELP.!DosCalls
                     MOV p,EAX
                  END;
                  ps:=CheckDlls(Addr,p);
                  IF ps<>NIL THEN
                  BEGIN
                       s:=tohex(Addr);
                       Delete(s,1,1);
                       s:=' ('+s+')';
                       result:='DOSCALLS.'+ps^+s;
                       exit;
                  END;
                  {$ENDIF}
             END;
        END; {AddrCode}
     END; {case}
END;

FUNCTION GetLocalVars(VAR ActualProc:STRING):PLocalVars;
VAR Buf:TDbgBuf;
    Module,ThisModule:PModuleInfo;
    EIP:LONGWORD;
    dummy:PLocalVars;
    Locals,Symbols:PSymbolsInfo;
    s,s1:STRING;
BEGIN
     result:=NIL;

     IF not GetRegisterSet(Buf) THEN exit;

     EIP:=Buf.EIP;
     Module:=ModuleInfo;
     s1:=ActualProc;
     UpcaseStr(s1);
     ThisModule:=NIL;
     WHILE Module<>NIL DO
     BEGIN
          IF ((EIP>=Module^.CodeOffs)AND(EIP<=Module^.CodeOffs+Module^.CodeLen)) THEN
          BEGIN  {Within this module}
               ThisModule:=Module;
               Symbols:=Module^.SymbolsInfo;
               WHILE Symbols<>NIL DO
               BEGIN
                    IF ((EIP>=Symbols^.Offset)AND(EIP<Symbols^.Offset+Symbols^.Len)) THEN {within this proc}
                    BEGIN
                         s:=Symbols^.SymbolName^;
                         UpcaseStr(s);
                         IF s1=s THEN exit;  //same procedure
                         ActualProc:=Symbols^.SymbolName^;
                         Locals:=Symbols^.Symbols;
                         WHILE Locals<>NIL DO
                         BEGIN
                              IF Locals^.Offset<>0 THEN
                                IF Locals^.SymbolName^<>'SPEEDSOFT96' THEN
                              BEGIN
                                   IF result=NIL THEN
                                   BEGIN
                                        New(result);
                                        dummy:=result;
                                   END
                                   ELSE
                                   BEGIN
                                        new(dummy^.Next);
                                        dummy:=dummy^.Next;
                                   END;

                                   dummy^.Name:=Locals^.SymbolName^;
                                   dummy^.Next:=NIL;
                              END;
                              Locals:=Locals^.Next;
                         END;
                         exit; //found
                    END;
                    Symbols:=Symbols^.Next;
               END;
          END;
          Module:=Module^.Next;
     END;
END;

PROCEDURE FreeLocalVars(p:PLocalVars);
VAR Next:PLocalVars;
BEGIN
     WHILE p<>NIL DO
     BEGIN
          Next:=p^.Next;
          Dispose(p);
          p:=Next;
     END;
END;

FUNCTION GetTypeInfoFromExpr(Expr:STRING;VAR EXEAddr:ULONG;VAR ValueTyp:BYTE):PTypeList;
VAR s:STRING;
    ValueLen:LONGWORD;
BEGIN
     TypeList:=NIL;
     UpcaseStr(Expr);
     IF not GetValueFromExpr(Expr,s,EXEAddr,ValueLen,ValueTyp,TRUE) THEN
     BEGIN
          FreeTypeList;
          result:=NIL;
     END
     ELSE result:=TypeList;
END;

PROCEDURE FreeTypeList;
VAR Next:PTypeList;
BEGIN
     WHILE TypeList<>NIL DO
     BEGIN
          Next:=TypeList^.Next;
          FreeMem(TypeList^.Name,length(TypeList^.Name^)+1);
          FreeMem(TypeList^.Value,length(TypeList^.Value^)+1);
          Dispose(TypeList);
          TypeList:=Next;
     END;
END;

PROCEDURE AddToTypeList(CONST Name,Value:STRING;Typ:BYTE);
VAR dummy:PTypeList;
BEGIN
    IF TypeList=NIL THEN
    BEGIN
         New(TypeList);
         dummy:=TypeList;
    END
    ELSE
    BEGIN
         New(LastTypeList^.Next);
         dummy:=LastTypeList^.Next;
    END;

    GetMem(dummy^.Name,length(Name)+1);
    dummy^.Name^:=Name;
    GetMem(dummy^.Value,length(Value)+1);
    dummy^.Value^:=Value;
    dummy^.Typ:=Typ;
    dummy^.Next:=NIL;
    LastTypeList:=dummy;
END;

FUNCTION SetWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN;
VAR rc:LONGINT;
    dummy:PWatchPoint;
BEGIN
     //Look if alread set
     dummy:=WatchPoints;
     WHILE dummy<>NIL DO
     BEGIN
          IF ((dummy^.Address=Address)AND(Dummy^.Flags=Flags)AND(Dummy^.Len=Len)) THEN
          BEGIN
               result:=TRUE;
               exit;
          END;
          dummy:=dummy^.Next;
     END;

     DbgBuf.Cmd := DBG_C_SetWatch;
     DbgBuf.Pid := SessPid;
     DbgBuf.Tid := 0;
     DbgBuf.Addr:= Address;
     DbgBuf.Len := Len;
     DbgBuf.Index:=0;
     DbgBuf.Value := Flags OR 2;  //local watchpoint
     rc := DosDebug(DbgBuf);
     IF rc<>0 THEN result:=FALSE
     ELSE
     BEGIN
          //Add to list
          IF WatchPoints=NIL THEN
          BEGIN
               New(Dummy);
               WatchPoints:=Dummy;
          END
          ELSE
          BEGIN
               dummy:=WatchPoints;
               WHILE dummy^.Next<>NIL DO Dummy:=Dummy^.Next;
               New(Dummy^.Next);
               Dummy:=Dummy^.Next;
          END;
          Dummy^.Address:=Address;
          Dummy^.Flags:=Flags;
          Dummy^.Len:=Len;
          Dummy^.Id:=DbgBuf.Index;
          Dummy^.Next:=NIL;
          result:=TRUE;
     END;
END;

FUNCTION ClearWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN;
VAR Last,Dummy:PWatchPoint;
    rc:LONGINT;
LABEL ok;
BEGIN
     //Look if present
     dummy:=WatchPoints;
     Last:=NIL;
     WHILE dummy<>NIL DO
     BEGIN
          IF ((dummy^.Address=Address)AND(Dummy^.Flags=Flags)AND(Dummy^.Len=Len)) THEN
            goto ok;
          Last:=dummy;
          dummy:=dummy^.Next;
     END;
     result:=TRUE;
     exit;
ok:
     DbgBuf.Cmd := DBG_C_ClearWatch;
     DbgBuf.Pid := SessPid;
     DbgBuf.Tid := 0;
     DbgBuf.Addr:= Address;
     DbgBuf.Len := Len;
     DbgBuf.Index:=dummy^.Id;
     DbgBuf.Value := Flags OR 2;  //local watchpoint
     rc := DosDebug(DbgBuf);
     IF rc<>0 THEN result:=FALSE
     ELSE
     BEGIN
          //Clear from list
          IF Last=NIL THEN WatchPoints:=dummy^.Next
          ELSE Last^.Next:=Dummy^.Next;
          Dispose(Dummy);
          result:=TRUE;
     END;
END;

FUNCTION GetBreakPoints:PBreakPoints;
BEGIN
     result:=BreakPoints;
END;

FUNCTION DebugStop(Dummy:LONGINT):LONGINT;
{Dummy=1 indicated that the request came from WorkThread}
VAR result:LONGINT;
LABEL l;
BEGIN
     DebugCommand(DBG_C_STOP,'STOP');
     HandleNotifications;
     CASE DbgBuf.Cmd OF
         DBG_N_SUCCESS:result:=DBG_N_SUCCESS;
         ELSE
         BEGIN
              WHILE DbgBuf.Cmd<>DBG_N_SUCCESS DO
              BEGIN
                   DebugCommand(DBG_C_Stop,'STOP');
                   HandleNotifications;
              END;
              result:=DBG_N_SUCCESS;
         END;
    END; {case}
l:
    IF dummy IN [0,2] THEN
    BEGIN
         PostAndWaitMsg(DBG_N_SUCCESS,'STOP completed');
         WorkThreadID:=0; {!!}
    END;
    DebugStop:=result;
END;

PROCEDURE RetryException;
BEGIN
     UnlockInput;
     RetryTheExcept:=FALSE;
     PutRegisterSet(RetryExceptRegBuf);
     DbgBuf.Value:=XCPT_CONTINUE_SEARCH;
     DebugCommand(DBG_C_CONTINUE,'STOP AFTER STEP EXCPT');
     {$IFDEF OS2}
     HandleNotifications;
     {$ENDIF}
     {$IFDEF WIN32}
     If HandleNotifications Then exit;
     {$ENDIF}
     {$IFDEF OS2}
     PostAndWaitMsg(DBG_N_PROCTERM,'Process terminated due to exception');
     DebugCommand(DBG_C_TERM,'TERMINATE');
     HandleNotifications;
     {$ENDIF}
END;

FUNCTION DebugRun(dummy:LONGINT):LONGINT;
{Dummy=1 indicated that the request came from WorkThread}
VAR Result:LONGINT;
    NextDbgB:LONGWORD;
    NextDbgT:BYTE;
LABEL l,l2,l3,l4;
BEGIN
     Result:=DBG_N_ERROR;

     IF RetryTheExcept THEN
     BEGIN
          RetryException;
          goto l3;
     END;

     IF NextDbgBreakAddr<>0 THEN  {issue first SSTEP to set break again}
     BEGIN
          NextDbgB:=NextDbgBreakAddr;
          NextDbgT:=NextDbgBreakTyp;
l2:
          DebugCommand(DBG_C_SSTEP,'SINGLESTEP');
          {$IFDEF OS2}
          HandleNotifications;
          {$ENDIF}
          {$IFDEF WIN32}
          If HandleNotifications Then goto l4; //stop
          {$ENDIF}

          IF DbgBuf.Cmd<>DBG_N_EXCEPTION THEN goto l2; {--> DBG_C_STOP ????}
l4:
          SetBreakPoint(NextDbgB,NextDbgT);
          NextDbgBreakAddr:=0;
          NextDbgBreakTyp:=0;
     END;

     REPEAT
          DebugCommand(DBG_C_Go,'RUN');
          {$IFDEF OS2}
          HandleNotifications;
          {$ENDIF}
          {$IFDEF WIN32}
          If HandleNotifications Then exit;
          {$ENDIF}
     UNTIL FALSE;
l:
     DebugCommand(DBG_C_TERM,'TERMINATE');
     HandleNotifications;
l3:
     IF dummy IN [0,2] THEN
     BEGIN
         PostAndWaitMsg(DBG_N_SUCCESS,'GO completed');
         WorkThreadID:=0; {!!!}
         SessPID:=0;
     END;
     DebugRun:=result;
END;

FUNCTION DebugStepInto(Dummy:LONGINT):LONGINT;
{Dummy=1 indicated that the request came from WorkThread}
VAR Module:PModuleInfo;
    Line:WORD;
    Source:STRING;
    Reg:TDbgBuf;
    Bytes:ARRAY[1..5] OF BYTE;
    dump:record
                 code:BYTE;
                 adress:LONGINT;
         end ABSOLUTE Bytes;
    ad:LONGINT;
    Stack:LONGWORD;
    RetAdress:LONGWORD ABSOLUTE Bytes;
    IncClosest:BOOLEAN;
    NextDbgB:LONGWORD;
    NextDbgT:BYTE;
LABEL l,l1,l2,l3,l4,l5,l6,l7;
BEGIN
    IF RetryTheExcept THEN
    BEGIN
         RetryException;
         goto l3;
    END;

    IncClosest:=FALSE;
    IF ((DebugMode=Dbg_Mode_LinesOnly)AND(not IsCPUAvail)) THEN
    BEGIN
        {Look where we are}
        GetRegisterSet(Reg);
        LastExcptAddr:=Reg.EIP;
        Stack:=Reg.ESP;
l:
        IncClosest:=FALSE;
        Reg.Pid:=SessPID;
        Reg.Addr:=LastExcptAddr;
        Reg.BUFFER:=LONGWORD(@Bytes);
        Reg.Len:=5;
        Reg.Cmd:=DBG_C_READMEMBUF;
        DosDebug(Reg);
        IF Reg.cmd<>DBG_N_SUCCESS THEN
        BEGIN
           //PostAndWaitMsg(DBG_N_ERROR,'ReadMemBuf (Code) failed in SSTEP');
           PostAndWaitMsg(DBG_N_PROCTERM,'Process terminated.');
        END;

        CASE Bytes[1] OF
            $E8: {CALLN32}
            BEGIN
                 {Check if next adress is valid}
                 ad:=dump.adress; {LONGINT(Bytes[2]);}
                 ad:=(LastExcptAddr+5)+ad;

                 IF ad=VMTCallAddr THEN  {Handle object calls}
                 BEGIN
                      {Set breakpoint to next adress at end of VMTCALL
                       --> JMP [EDI+0] }
                      SetBreakPoint(VmtCallAddr+52,1);
                      NextDbgB:=NextDbgBreakAddr;
                      NextDbgT:=NextDbgBreakTyp;
l5:
                      DebugCommand(DBG_C_GO,'GO SINGLESTEP');
                      {$IFDEF OS2}
                      HandleNotifications;
                      {$ENDIF}
                      {$IFDEF WIN32}
                      If HandleNotifications Then exit; //stop
                      {$ENDIF}

                      CASE DbgBuf.Cmd OF
                         DBG_N_EXCEPTION:
                         BEGIN
                             IF NextDbgB<>0 THEN
                             BEGIN
                                 SetBreakPoint(NextDbgB,NextDbgT);
                                 NextDbgBreakAddr:=0;
                                 NextDbgBreakTyp:=0;
                             END;
                         END;
                         ELSE goto l5;  {try again}
                      END; {case}

                      {Check if we can perform a step into or not
                       by performing JMP [EDI+0] and look at new EIP}
                      NextDbgB:=NextDbgBreakAddr;
                      NextDbgT:=NextDbgBreakTyp;
l6:
                      DebugCommand(DBG_C_SSTEP,'SINGLESTEP');
                      {$IFDEF OS2}
                      HandleNotifications;
                      {$ENDIF}
                      {$IFDEF WIN32}
                      If HandleNotifications Then exit; //stop
                      {$ENDIF}


                      CASE DbgBuf.Cmd OF
                         DBG_N_EXCEPTION:
                         BEGIN
                             IF NextDbgB<>0 THEN
                             BEGIN
                                SetBreakPoint(NextDbgB,NextDbgT);
                                NextDbgBreakAddr:=0;
                                NextDbgBreakTyp:=0;
                             END;
                         END;
                         ELSE goto l6;  {try again}
                      END; {case}

                      {Look where we are}
                      GetRegisterSet(Reg);
                      SearchLineNum(Reg.EIP,IncClosest,Source,Line,Module);
                      IF Line<>0 THEN
                      BEGIN
                           {Perform step into}
                           LastExcptAddr:=Reg.EIP;
                           goto l3;
                      END;
                 END;

                 SearchLineNum(ad,FALSE,Source,Line,Module);
                 IF Line<>0 THEN goto l1; {Perform step into}

                 {Single step not supported for this function}

                 {Set breakpoint to next adress}
                 SetBreakPoint(LastExcptAddr+5,1);
                 NextDbgB:=NextDbgBreakAddr;
                 NextDbgT:=NextDbgBreakTyp;
l2:
                 DebugCommand(DBG_C_GO,'GO SINGLESTEP');
                 {$IFDEF OS2}
                 HandleNotifications;
                 {$ENDIF}
                 {$IFDEF WIN32}
                 If HandleNotifications Then exit; //stop
                 {$ENDIF}

                 CASE DbgBuf.Cmd OF
                     DBG_N_EXCEPTION:
                     BEGIN
                          IF NextDbgB<>0 THEN
                          BEGIN
                               SetBreakPoint(NextDbgB,NextDbgT);
                               NextDbgBreakAddr:=0;
                               NextDbgBreakTyp:=0;
                          END;
                          goto l4; {continue}
                     END;
                     ELSE goto l2;  {try again}
                 END; {case}
            END;
            $C3,$C2:  {RET,RET n}
            BEGIN
                 {Read top of stack adress}
                 Reg.Pid:=SessPID;
                 Reg.Addr:=Stack;
                 Reg.BUFFER:=LONGWORD(@Bytes);
                 Reg.Len:=4;
                 Reg.Cmd:=DBG_C_READMEMBUF;
                 DosDebug(Reg);
                 IF Reg.cmd<>DBG_N_SUCCESS THEN
                 PostAndWaitMsg(DBG_N_ERROR,'ReadMemBuf (Stack) failed in SSTEP');
                 ad:=RetAdress;
                 SearchLineNum(ad,TRUE,Source,Line,Module);
                 IF Line<>0 THEN
                 BEGIN
                      IncClosest:=TRUE;
                      goto l1;  {Normal Single step}
                 END;

                 IncClosest:=FALSE;
                 DebugRun(1);  {Issue Run --> next line not known}
                 goto l3;
            END;
        END; {case}
        NextDbgB:=NextDbgBreakAddr;
        NextDbgT:=NextDbgBreakTyp;
l1:
        DebugCommand(DBG_C_SSTEP,'SINGLESTEP');
        {$IFDEF OS2}
        HandleNotifications;
        {$ENDIF}
        {$IFDEF WIN32}
        If HandleNotifications Then exit; //stop
        {$ENDIF}

        CASE DbgBuf.Cmd OF
            DBG_N_EXCEPTION:
            BEGIN
                 IF NextDbgB<>0 THEN
                 BEGIN
                     SetBreakPoint(NextDbgB,NextDbgT);
                     NextDbgBreakAddr:=0;
                     NextDbgBreakTyp:=0;
                 END;
            END;
            ELSE goto l1;  {try again}
        END; {case}
        {Look if adress is in list}
l4:
        GetRegisterSet(Reg);
        LastExcptAddr:=Reg.EIP;
        Stack:=Reg.ESP;
        SearchLineNum(LastExcptAddr,IncClosest,Source,Line,Module);
        IF Line=0 THEN goto l; {next step}
    END
    ELSE
    BEGIN
        NextDbgB:=NextDbgBreakAddr;
        NextDbgT:=NextDbgBreakTyp;

        DebugCommand(DBG_C_SSTEP,'SINGLESTEP');
        {$IFDEF OS2}
        HandleNotifications;
        {$ENDIF}
        {$IFDEF WIN32}
        If HandleNotifications Then goto l7; //stop
        {$ENDIF}

        IF DbgBuf.Cmd<>DBG_N_EXCEPTION THEN goto l2; {--> DBG_C_STOP ????}
l7:
        IF NextDbgB<>0 THEN
        BEGIN
             SetBreakPoint(NextDbgB,NextDbgT);
             NextDbgBreakAddr:=0;
             NextDbgBreakTyp:=0;
        END;
    END;

l3:
    IF Dummy IN [0,2] THEN
    BEGIN
         {Look where we are}
         GetRegisterSet(Reg);
         LastExcptAddr:=Reg.EIP;
         SearchLineNum(LastExcptAddr,IncClosest,DbgReturn.Source,DbgReturn.Line,
                       DbgReturn.ModuleInfo);
         PostAndWaitMsg(DBG_N_SSTEPCOMPLETED,'STEP INTO completed at '+
                         Tohex(LastExcptAddr)+' '+DbgReturn.Source+'('+
                         tostr(DbgReturn.Line)+')');
         WorkThreadID:=0; {!!}
    END;
    DebugStepInto:=DBG_N_SUCCESS;
END;

FUNCTION DebugSingleStep(Dummy:LONGINT):LONGINT;
{Dummy=1 indicated that the request came from WorkThread}
VAR
    Module:PModuleInfo;
    Line:WORD;
    Source:STRING;
    Reg:TDbgBuf;
    Bytes:ARRAY[1..5] OF BYTE;
    ad:LONGWORD;
    Stack:LONGWORD;
    RetAdress:LONGWORD ABSOLUTE Bytes;
    IncClosest:BOOLEAN;
    NextDbgB:LONGWORD;
    NextDbgT:BYTE;
LABEL l,l1,l2,l3,l4,l2_1,l5;
BEGIN
    result:=DBG_N_SUCCESS;

    IF RetryTheExcept THEN
    BEGIN
         RetryException;
         goto l3;
    END;

    IncClosest:=FALSE;
    IF ((DebugMode=Dbg_Mode_LinesOnly)AND(not ISCPUAvail)) THEN
    BEGIN
        {Look where we are}
        GetRegisterSet(Reg);
        LastExcptAddr:=Reg.EIP;
        Stack:=Reg.ESP;
l:
        IncClosest:=FALSE;
        Reg.Pid:=SessPID;
        Reg.Addr:=LastExcptAddr;
        Reg.BUFFER:=LONGWORD(@Bytes);
        Reg.Len:=5;
        Reg.Cmd:=DBG_C_READMEMBUF;
        DosDebug(Reg);
        IF Reg.cmd<>DBG_N_SUCCESS THEN
        BEGIN
             //PostAndWaitMsg(DBG_N_ERROR,'ReadMemBuf (Code) failed in SSTEP 1');
             PostAndWaitMsg(DBG_N_PROCTERM,'Process terminated.');
        END;

        CASE Bytes[1] OF
            $E8: {CALLN32}
            BEGIN
                 {Set breakpoint to next adress}
                 SetBreakPoint(LastExcptAddr+5,1);
                 NextDbgB:=NextDbgBreakAddr;
                 NextDbgT:=NextDbgBreakTyp;
l2:
                 DebugCommand(DBG_C_GO,'GO SINGLESTEP');
                 {$IFDEF OS2}
                 HandleNotifications;
                 {$ENDIF}
                 {$IFDEF WIN32}
                 If HandleNotifications Then exit; //stop
                 {$ENDIF}

                 CASE DbgBuf.Cmd OF
                     DBG_N_EXCEPTION:
                     BEGIN
                          IF NextDbgB<>0 THEN
                          BEGIN
                               SetBreakPoint(NextDbgB,NextDbgT);
                               NextDbgBreakAddr:=0;
                               NextDbgBreakTyp:=0;
                          END;
                          goto l4; {continue}
                     END;
                     ELSE goto l2;  {try again}
                 END; {case}
            END;
            $C3,$C2:  {RET,RET n}
            BEGIN
                 {Read top of stack adress}
                 Reg.Pid:=SessPID;
                 Reg.Addr:=Stack;
                 Reg.BUFFER:=LONGWORD(@Bytes);
                 Reg.Len:=4;
                 Reg.Cmd:=DBG_C_READMEMBUF;
                 DosDebug(Reg);
                 IF Reg.cmd<>DBG_N_SUCCESS THEN
                 PostAndWaitMsg(DBG_N_ERROR,'ReadMemBuf (Stack) failed in SSTEP');
                 ad:=RetAdress;
                 SearchLineNum(ad,TRUE,Source,Line,Module);
                 IF Line<>0 THEN
                 BEGIN
                      IncClosest:=TRUE;
                      goto l1;  {Normal single step}
                 END;

                 IncClosest:=FALSE;
                 DebugRun(1);  {Issue run --> next line not known}
                 goto l3;
            END;
        END; {case}
        NextDbgB:=NextDbgBreakAddr;
        NextDbgT:=NextDbgBreakTyp;
l1:
        DebugCommand(DBG_C_SSTEP,'SINGLESTEP');
        {$IFDEF OS2}
        HandleNotifications;
        {$ENDIF}
        {$IFDEF WIN32}
        If HandleNotifications Then exit; //stop
        {$ENDIF}

        CASE DbgBuf.Cmd OF
            DBG_N_EXCEPTION:
            BEGIN
                 IF NextDbgB<>0 THEN
                 BEGIN
                     SetBreakPoint(NextDbgB,NextDbgT);
                     NextDbgBreakAddr:=0;
                     NextDbgBreakTyp:=0;
                 END;
            END;
            ELSE goto l1;  {try again}
        END; {case}
        {Look if adress is in list}
l4:
        GetRegisterSet(Reg);
        LastExcptAddr:=Reg.EIP;
        Stack:=Reg.ESP;
        SearchLineNum(LastExcptAddr,IncClosest,Source,Line,Module);
        IF Line=0 THEN goto l; {next step}
    END
    ELSE
    BEGIN
        {Look where we are}
        GetRegisterSet(Reg);
        LastExcptAddr:=Reg.EIP;
        Stack:=Reg.ESP;

        IncClosest:=FALSE;
        Reg.Pid:=SessPID;
        Reg.Addr:=LastExcptAddr;
        Reg.BUFFER:=LONGWORD(@Bytes);
        Reg.Len:=5;
        Reg.Cmd:=DBG_C_READMEMBUF;
        DosDebug(Reg);
        IF Reg.cmd<>DBG_N_SUCCESS THEN
        BEGIN
             //PostAndWaitMsg(DBG_N_ERROR,'ReadMemBuf (Code) failed in SSTEP 2');
             PostAndWaitMsg(DBG_N_PROCTERM,'Process terminated.');
        END;

        CASE Bytes[1] OF
            $E8: {CALLN32}
            BEGIN
                 {Set breakpoint to next adress}
                 SetBreakPoint(LastExcptAddr+5,1);
                 NextDbgB:=NextDbgBreakAddr;
                 NextDbgT:=NextDbgBreakTyp;
l2_1:
                 DebugCommand(DBG_C_GO,'GO SINGLESTEP');
                 {$IFDEF OS2}
                 HandleNotifications;
                 {$ENDIF}
                 {$IFDEF WIN32}
                 If HandleNotifications Then exit; //stop
                 {$ENDIF}
               
                 CASE DbgBuf.Cmd OF
                     DBG_N_EXCEPTION:
                     BEGIN
                          IF NextDbgB<>0 THEN
                          BEGIN
                               SetBreakPoint(NextDbgB,NextDbgT);
                               NextDbgBreakAddr:=0;
                               NextDbgBreakTyp:=0;
                          END;
                          goto l3; {continue}
                     END;
                     ELSE goto l2_1;  {try again}
                 END; {case}
            END;
        END; {case}

        NextDbgB:=NextDbgBreakAddr;
        NextDbgT:=NextDbgBreakTyp;

        DebugCommand(DBG_C_SSTEP,'SINGLESTEP');
        {$IFDEF OS2}
        HandleNotifications;
        {$ENDIF}
        {$IFDEF WIN32}
        If HandleNotifications Then goto l5; //stop
        {$ENDIF}

        IF DbgBuf.Cmd<>DBG_N_EXCEPTION THEN goto l2; {--> DBG_C_STOP ????}
l5:
        IF NextDbgB<>0 THEN
        BEGIN
             SetBreakPoint(NextDbgB,NextDbgT);
             NextDbgBreakAddr:=0;
             NextDbgBreakTyp:=0;
        END;
    END;

l3:
    IF Dummy IN [0,2] THEN
    BEGIN
         {Look where we are}
         GetRegisterSet(Reg);
         LastExcptAddr:=Reg.EIP;
         SearchLineNum(LastExcptAddr,IncClosest,DbgReturn.Source,DbgReturn.Line,
                       DbgReturn.ModuleInfo);
         PostAndWaitMsg(DBG_N_SSTEPCOMPLETED,'SINGLE STEP completed at '+
                         Tohex(LastExcptAddr)+' '+DbgReturn.Source+'('+
                         tostr(DbgReturn.Line)+')');
         WorkThreadID:=0; {!!}
    END;
    DebugSingleStep:=DBG_N_SUCCESS;
END;

FUNCTION MainLoop(Command:LONGINT):LONGINT;

{$IFDEF OS2}
VAR p:POINTER;
{$ENDIF}

BEGIN
     Result:=DBG_N_SUCCESS;
     {$IFDEF OS2}
     DeleteWorkThread(TRUE);
     CASE Command OF
         DBG_C_GO:p:=@DebugRun;
         DBG_C_STOP:p:=@DebugStop;
         DBG_C_SSTEP:p:=@DebugSingleStep;
         DBG_C_STEPINTO:p:=@DebugStepInto;
         ELSE p:=NIL;
     END; {case}
     IF p<>NIL THEN
     BEGIN
          {Create the thread that performs the action}
          UnlockInput;
          {$IFDEF OS2}
          DosCreateThread(WorkThreadID,p,NIL,0,128000);
          {$ENDIF}
          {$IFDEF WIN32}
          WorkThreadID:=CreateThread(Nil,128000,p,Nil,0,id);
          {$ENDIF}
     END
     ELSE result:=DBG_N_ERROR;
     {$ENDIF}
     {$IFDEF WIN32}
     CASE Command OF
         DBG_C_GO:If not SetEvent(Win32DbgEvents[1]) Then Result:=DBG_N_ERROR;
         DBG_C_STOP:If not SetEvent(Win32DbgEvents[2]) Then Result:=DBG_N_ERROR;
         DBG_C_SSTEP:If not SetEvent(Win32DbgEvents[3]) Then Result:=DBG_N_ERROR;
         DBG_C_STEPINTO:If not SetEvent(Win32DbgEvents[4]) Then Result:=DBG_N_ERROR;
         Else Result:=DBG_N_ERROR;

         If Result=DBG_N_ERROR Then
         Begin
              Result:=GetLastError;
              If Result=0 Then Result:=DBG_N_ERROR;
         End;
     END; {case}
     {$ENDIF}
END;


VAR t:LONGWORD;

Initialization
  Log:=nil;
  Log.Create('WDSibyl_DbgHelp');

  IsCPUAvail:=@DefCPUAvail;
  {$IFDEF OS2}
  WinQueryWindowPos(HWND_DESKTOP,DesktopSWP);
  {$ENDIF}
  PointerHided:=FALSE;
  //Turn on all RTL exceptions
  RTLExceptions:=0;
  FOR t:=1 TO MaxRTLXcpts DO RTLExceptions:=RTLExceptions OR 1 SHL (t-1);
  //Turn on all SPCC exceptions
  SPCCExceptions:=0;
  FOR t:=1 TO MaxSPCCXcpts DO SPCCExceptions:=SPCCExceptions OR 1 SHL (t-1);

Finalization
  if Log<>nil then Log.Destroy;
END.


{ -- date -- --from-- -- changes ----------------------------------------------
  28-Aug-05  WD       Variablen die nicht verwendet werden entfernt.
}

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

LIBRARY WDSPDB10;
                     
{$M 128000,8388608}     {256K Stack,0,12MB Heap}
                           
USES DbgHelp;
                         
{$IFDEF OS2}    
EXPORTS
       DebugLoad                   Index 1,
       DebugUnload                 Index 2,
       CreateEventSem              Index 3,
       PostEventSem                Index 4,
       SetNextAction               Index 5,
       GetDebugReturn              Index 6,
       MainLoop                    Index 7,
       Dummy                       Index 8,
       GetModulesLoaded            Index 9,
       GetModuleInfo               Index 10,
       GetRegisterSet              Index 11,
       PutRegisterSet              Index 12,
       DeleteWorkThread            Index 13,
       SetStartBreakPoint          Index 14,
       SetBreakPoint               Index 15,
       UnsetBreakPoint             Index 16,
       SetBreakPointLine           Index 17,
       SetBreakAtStartAddr         Index 18,
       GetAdressFromLine           Index 19,
       SetNextDbgBrk               Index 20,
       GetNextDbgBrk               Index 21,
       GetValueFromExpr            Index 22,
       SetValueFromExpr            Index 23,
       SetWatchHwnd                Index 24,
       SetRegHwnd                  Index 25,
       SetProjectHwnd              Index 26,
       GetProcTermResult           Index 27,
       IsBreakPointLine            Index 28,
       GetDump                     Index 29,
       SetDump                     Index 30,
       LockInput                   Index 31,
       UnlockInput                 Index 32,
       IssueDebugCommand           Index 33,
       GetLineFromEIP              Index 34,
       GetBreakPointOp             Index 35,
       GetNameFromAddr             Index 36,
       SearchLineNum               Index 37,
       GetNearestProc              Index 38,
       GetTypeInfoFromExpr         Index 39,
       FreeTypeList                Index 40,
       SetWatchPoint               Index 41,
       ClearWatchPoint             Index 42,
       GetCoproRegisterSet         Index 43,
       PutCoproRegisterSet         Index 44,
       DbgLineAvail                Index 45,
       DbgSetExceptions            Index 46,
       GetBreakPoints              Index 47,
       GetNextDbgBrkInfo           Index 48,
       GetLocalVars                Index 49,
       FreeLocalVars               Index 50,
       GetAdressFromName           Index 51,
       SetOptions                  Index 52;
{$ENDIF}

{$IFDEF WIN32}
EXPORTS
       DebugLoad                   Name 'DebugLoad',
       DebugUnload                 Name 'DebugUnload',
       CreateEventSem              Name 'CreateEventSem',
       PostEventSem                Name 'PostEventSem',
       SetNextAction               Name 'SetNextAction',
       GetDebugReturn              Name 'GetDebugReturn',
       MainLoop                    Name 'MainLoop',
       Dummy                       Name 'Dummy',
       GetModulesLoaded            Name 'GetModulesLoaded',
       GetModuleInfo               Name 'GetModuleInfo',
       GetRegisterSet              Name 'GetRegisterSet',
       PutRegisterSet              Name 'PutRegisterSet',
       DeleteWorkThread            Name 'DeleteWorkThread',
       SetStartBreakPoint          Name 'SetStartBreakPoint',
       SetBreakPoint               Name 'SetBreakPoint',
       UnsetBreakPoint             Name 'UnsetBreakPoint',
       SetBreakPointLine           Name 'SetBreakPointLine',
       SetBreakAtStartAddr         Name 'SetBreakAtStartAddr',
       GetAdressFromLine           Name 'GetAdressFromLine',
       SetNextDbgBrk               Name 'SetNextDbgBrk',
       GetNextDbgBrk               Name 'GetNextDbgBrk',
       GetValueFromExpr            Name 'GetValueFromExpr',
       SetValueFromExpr            Name 'SetValueFromExpr',
       SetWatchHwnd                Name 'SetWatchHwnd',
       SetRegHwnd                  Name 'SetRegHwnd',
       SetProjectHwnd              Name 'SetProjectHwnd',
       GetProcTermResult           Name 'GetProcTermResult',
       IsBreakPointLine            Name 'IsBreakPointLine',
       GetDump                     Name 'GetDump',
       SetDump                     Name 'SetDump',
       LockInput                   Name 'LockInput',
       UnlockInput                 Name 'UnlockInput',
       IssueDebugCommand           Name 'IssueDebugCommand',
       GetLineFromEIP              Name 'GetLineFromEIP',
       GetBreakPointOp             Name 'GetBreakPointOp',
       GetNameFromAddr             Name 'GetNameFromAddr',
       SearchLineNum               Name 'SearchLineNum',
       GetNearestProc              Name 'GetNearestProc',
       GetTypeInfoFromExpr         Name 'GetTypeInfoFromExpr',
       FreeTypeList                Name 'FreeTypeList',
       SetWatchPoint               Name 'SetWatchPoint',
       ClearWatchPoint             Name 'ClearWatchPoint',
       GetCoproRegisterSet         Name 'GetCoproRegisterSet',
       PutCoproRegisterSet         Name 'PutCoproRegisterSet',
       DbgLineAvail                Name 'DbgLineAvail',
       DbgSetExceptions            Name 'DbgSetExceptions',
       GetBreakPoints              Name 'GetBreakPoints',
       GetNextDbgBrkInfo           Name 'GetNextDbgBrkInfo',
       GetLocalVars                Name 'GetLocalVars',
       FreeLocalVars               Name 'FreeLocalVars',
       GetAdressFromName           Name 'GetAdressFromName',
       SetOptions                  Name 'SetOptions';
{$ENDIF}

                                         
BEGIN
END.

{ -- date -- --from-- -- changes ----------------------------------------------
  02-Sep-04  WD       Erstellung des Projektes
}
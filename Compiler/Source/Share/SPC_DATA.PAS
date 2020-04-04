
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

// Bei Verwendung von den Typen bei dem der DLL SPDLL25 muss TPasParams und
// TPasReturn global definiert sein, ansonsten gibt es einen abturz

UNIT SPC_Data;

INTERFACE

uses SysUtils, uSysClass, uSysInfo,dos;

// Compiler-DLL definieren
{$IFDEF OS2}
Const gCompilerDLL25 = 'SPDLL25.DLL';
{$ENDIF}
{$IFDEF WIN32}
Const gCompilerDLL25 = 'SPDLL30.DLL';
{$ENDIF}
Const gCompilerDLL30 = 'SPDLL30.DLL';

CONST errLineNumber    = 1;   //SourceFile,Line,Column valid
      errNone          = 2;   //NotifyStr valid
      errWarning       = 3;   //all parameters valid
      errError         = 4;   //all parameters valid
      errFatalError    = 5;   //all parameters valid


TYPE PMemoryList=^TMemoryList;
     TMemoryList=RECORD
        Name:CSTRING;
        Adresse:POINTER;
        Len:longword;
        Modified:LONGBOOL;
        Next:PMemoryList;
     END;

     PAddResources=^TAddResources;
     TAddResources=RECORD
         TotalDataLen:LONGINT; //length of structure for freemem
         Data:POINTER;         //pointer to full names of language SRF files that should be installed
                               //each item is a pascal string, end is a zero length string
         TotalNameLen:LONGINT; //length of structure for freemem
         Names:POINTER;        //pointer to names of languages that should be included.
                               //each item is a pascal string, end is a zero length string
     END;

     PPasParams=^TPasParams;
     TPasParams=RECORD
         Language:LONGWORD;       {1=German}
         Version:LONGWORD;        {1=Old IDE,2=Sibyl}
         MsgProc:POINTER;
         AddResources:PAddResources;
         ErrorTable:^Char;
         ApplicationIcon:POINTER;
         ApplicationIconLen:LongWord;
         InMemory:PMemoryList;
         Quell:CSTRING;           {File to Compile}
         Lib:CSTRING;             {Library directory}
         Out:CSTRING;             {Output directory}
         ExeOut:CSTRING;          {Output fr die Exe - nur fr CompLib}
         LibSrc:CSTRING;          {Library sources - for build}
         Params:CSTRING;          {Command line parameters}
         Defines:CSTRING;         {Conditional defines}
         IncSrcDir:CSTRING;
         SCUDir:CSTRING;
         Reserved3:POINTER;
     END;

/*{$IFDEF WDSIBYL}
         Aliases:CString;         {Unit aliases}
{$ENDIF}*/


     TRetFilesArray=ARRAY[0..249] OF CSTRING;
     PRetFilesArray=^TRetFilesArray;

     PPasReturn=^TPasReturn;
     TPasReturn=RECORD
         Error:LONGBOOL;
         RetFiles:PRetFilesArray;
         RetFilesCount:LONGINT;
         RetType:LONGINT;
     END;


     tCompStatusMsg = Procedure(CONST StatusMsg,ErrorFile:CSTRING;
                         ErrorType:LONGINT; ErrorLine,ErrorColumn:LONGINT); CDECL;

     tCompilerTyp = (CompSPC, CompRes, CompHlp);


type
  tCompilerFunc=Record
    InvokeCompiler: Procedure(VAR Params:TPasParams;VAR Return:TPasReturn);
    BreakCompiler : Procedure;
    LoadSPDLL     : Procedure(const path : tFilename);
    FreeSPDLL     : Procedure;
//    3 AllocCompilerMem
//    4 FreeCompilerMem
  end;

  tcCompiler = Class(tcDLL)
    private
      fCompilerFunc : tCompilerFunc;
      fCompilerTyp  : tCompilerTyp;
    Public
      Constructor Create(iCompilerTyp : tCompilerTyp; iPath : tFileName); virtual;

      Procedure InvokeCompiler(VAR Params:TPasParams;VAR Return:TPasReturn);
      Procedure BreakCompiler;
      Procedure FreeSPDLL;

      property Func : tCompilerFunc read fCompilerFunc;
  End;

implementation

Procedure tcCompiler.InvokeCompiler(VAR Params:TPasParams;VAR Return:TPasReturn);

Begin
  fCompilerFunc.InvokeCompiler(Params, Return);
End;

Procedure tcCompiler.BreakCompiler;
              
Begin
  if fCompilerFunc.BreakCompiler<>nil then
    fCompilerFunc.BreakCompiler;
End;

Procedure tcCompiler.FreeSPDLL;

Begin
  fCompilerFunc.FreeSPDLL;
End;

Constructor tcCompiler.Create(iCompilerTyp : tCompilerTyp; iPath : tFileName);

var DLLName   : tFileName;
    InvokeName: String;
    Path      : tFilename;

begin
  fCompilerTyp := iCompilerTyp;
  FillChar(fCompilerFunc, sizeof(tCompilerFunc), #0);
  case fCompilerTyp of
    CompSPC : Begin
                DLLName:='WDSPD10.DLL';
                InvokeName:='INVOKESPC';
              end;
    CompRes : Begin
                DLLName:='WDRCD10.DLL';
                InvokeName:='INVOKERES';
              end;
    CompHlp : Begin
                DLLName:='WDHLPD10.DLL';
                InvokeName:='INVOKEHLP';
              end;
  end;
  if iPath = ''
    then Path:=goSysInfo.ProgramInfo.Path
    else Path:=iPath;
  try
    Upper:=false;
    inherited Create(Path+DLLName);
  except
//    MessageBox('tcCompiler.Create:'+lastErr+','+DLLName);
  end;

  if DLLLoaded then
    Begin
      fCompilerFunc.InvokeCompiler:=pointer(GetProcAddress(InvokeName));
      try
        fCompilerFunc.BreakCompiler :=pointer(GetProcAddress('BREAKCOMPILER'));
      except
        fCompilerFunc.BreakCompiler:=nil;
      end;
      try
        fCompilerFunc.LoadSPDLL:=pointer(GetProcAddress('LOADSPDLL'));
        fCompilerFunc.FreeSPDLL:=pointer(GetProcAddress('FREESPDLL'));

        fCompilerFunc.LoadSPDLL(Path);
      except
        fCompilerFunc.FreeSPDLL:=nil;
        fCompilerFunc.LoadSPDLL:=nil;
      end;
    End;
end;

Begin
end.

{ -- date --- --from-- -- changes ----------------------------------------------
  23-Sep-2002 WD       Statt SPDLL20 wird nun SPDLL25 verwendet
  21-Dec-2002 WD       Import fuer die Resourcen eingebaut
  12-Jun-2005 WD       Klasse tcSPDLL eingebaut. Damit funktioniert das Umschalten zwischen OS/2 und Windows.
  27-Mai-2006 WD       tcCompiler.Create: Parametererweiterung
}

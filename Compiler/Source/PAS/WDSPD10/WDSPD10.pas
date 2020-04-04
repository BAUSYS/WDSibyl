{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Visual Development Environment                                 บ
 บ                                                                          บ
 บ     Copyright (C) 2005 W. Draxler,   All rights reserved.                บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Library WDSPD10;    

Uses SPC_DATA, uSysClass, sysUtils, uString;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ DLL-Sourcen                                                              บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

//{$IFDEF OS2}
//IMPORTS
//  PROCEDURE SPDLL25_InvokeSPC(VAR Params:TPasParams;VAR Return:TPasReturn);
//       APIENTRY; 'SPDLL25' index 1;
//  PROCEDURE SPDLL25_BreakCompiler;
//       APIENTRY; 'SPDLL25' index 2;
//END;
//{$ENDIF}
//{$IFDEF Win32}
//IMPORTS
//  PROCEDURE SPDLL25_InvokeSPC(VAR Params:TPasParams;VAR Return:TPasReturn);
//        APIENTRY; 'SPDLL25' name 'InvokeSPC';
//  PROCEDURE SPDLL25_BreakCompiler;
//        APIENTRY; 'SPDLL25' name 'BreakCompiler';
//END;
//{$ENDIF}

/* Testen der Compiler-DLL
P:
cd P:\WDSIBYL\WDSIBYL\COMPILER\OUTPUT\OS2
copy P:\WatCom\WDSPC10\PASC\Sourcen\WatCom\OS2\spdll30.dll *.*
wdspc10 test.pas
*/

{$IFDEF OS2}
Uses OS2Def, BSEDos;
{$ENDIF}

Const cVersion = '1.0';

type
  tSPDLLFunc=Record
    InvokeCompiler: Procedure(VAR Params:TPasParams;VAR Return:TPasReturn); APIENTRY;
    BreakCompiler : Procedure; APIENTRY;
  end;

  tcSPDLL = Class(tcDLL)
    private
      fFunInvoke: tStr20;
      fFunBreak : tStr20;
      fSPDLLFunc: tSPDLLFunc;
    Public
      Constructor Create(iPath : tFileName); virtual;

      Procedure InvokeSPC(VAR Params:TPasParams;VAR Return:TPasReturn);
      Procedure BreakCompiler;

      property Func : tSPDLLFunc read fSPDLLFunc;
    Published
      property FunInvoke: tStr20 Read fFunInvoke;
      property FunBreak : tStr20 Read fFunBreak;
  End;

Var gCompilerDLL : tFileName;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Klasse: tcSPDLL                                                          บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Constructor tcSPDLL.Create(iPath : tFileName);

var DLLName  : tFilename;
    Version  : Byte;

Begin
  DLLName:=iPath+gCompilerDLL30;
  fFunInvoke:='InvokeSPC';
  fFunBreak :='BreakCompiler';
  if not FileExists(DLLName) then
    DLLName:=iPath+gCompilerDLL25;
  try
    inherited Create(DLLName);
  except
    Beep(200,100);
  end;
                        
  Upper:=false;
  if DLLLoaded then
    Begin
      fSPDLLFunc.InvokeCompiler:=pointer(GetProcAddress(fFunInvoke));
      fSPDLLFunc.BreakCompiler :=pointer(GetProcAddress(fFunBreak));
    End;
End;


Procedure tcSPDLL.InvokeSPC(VAR Params:TPasParams;VAR Return:TPasReturn);
Begin
  fSPDLLFunc.InvokeCompiler(Params, Return);
End;

Procedure tcSPDLL.BreakCompiler;

Begin
  fSPDLLFunc.BreakCompiler;
End;                 

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ DLL-Funktionen                                                           บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Var OwnModule  : LongWord;
    OwnModName : tFilename;    
    OwnPath    : tFilename;
    OldExitProc: Pointer;
    oSPDLL     : tcSPDLL;

Procedure InvokeSpc(VAR PasParams:TPasParams;VAR PasReturn:TPasReturn);

Var  CompStatusMsg : tCompStatusMsg;

  Procedure OutputMsg(msg : String);

  Begin
    if CompStatusMsg=nil
      then Writeln('>', msg)
      else CompStatusMsg(msg,'',errNone,0,0);
  End;

               
Begin
  CompStatusMsg:=PasParams.MsgProc;

  if oSPDLL.DLLLoaded
    then
      Begin
        OutputMsg('WDSibyl Pascal Compiler Version ' + cVersion);
        OutputMsg('Compiling: '+PasParams.Quell);
        OutputMsg('Parameter: '+PasParams.Params);
        OutputMsg('Defines: '+PasParams.Defines);
        OutputMsg('Own-Handle:' +tohex(OwnModule)+', '+OwnModName);
        OutputMsg('  Invoke-Handle:' +
              tohex(LongWord(oSPDLL.Func.InvokeCompiler))+', <'+oSPDLL.FunInvoke+'>');
        OutputMsg('  Break-Handle :' +
              tohex(LongWord(oSPDLL.Func.BreakCompiler))+', <'+oSPDLL.FunBreak+'>');
        OutputMsg('SPDLL:'+oSPDLL.Filename);
        oSPDLL.InvokeSPC(PasParams, PasReturn);
      End
    else
      Begin
        OutputMsg('DLL <'+oSPDLL.FileName+'> not loaded');
      End;
End;

Procedure BreakCompiler;

Begin
  oSPDLL.BreakCompiler;
End;

Procedure LoadSPDLL(const iPath : tFilename);

Var cModName : cString;

Begin
  cModName:='WDSPD10.DLL';
{$IFDEF OS2}
  DosQueryModuleHandle(cModName, OwnModule);
  DosQueryModuleName(OwnModule, 255, cModName);
{$ENDIF}
  OwnModName:=cModName;

  oSPDLL.Create(iPath);
End;

Procedure FreeSPDLL;

Begin
  oSPDLL.Destroy;
End;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ DLL-Definition                                                           บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{$IFDEF OS2}
EXPORTS
  InvokeSPC     Index 1,
  BreakCompiler Index 2,
  LoadSPDLL     index 3,
  FreeSPDLL     index 4;
{$ENDIF}
                     
{$IFDEF WIN32}         
EXPORTS
  InvokeSPC     Name 'INVOKESPC',
  BreakCompiler Name 'BREAKCOMPILER',
  LoadSPDLL     Name 'LOADSPDLL',
  FreeSPDLL     Name 'FREESPDLL';
{$ENDIF}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ DLL-Initialisn                                                           บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

// --------------------------------------------------------------------------

Procedure NewExitProc;

Begin
  FreeSPDLL;
  ExitProc:=@OldExitProc;
End;

Begin
  OldExitProc:=ExitProc;
  ExitProc := @NewExitProc;

//  LoadDLL;
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  25-Nov-04   WD       Erstellung des Projektes
  23-Nov-05   WD       Ausgabe der Compiler-Definitionen
}
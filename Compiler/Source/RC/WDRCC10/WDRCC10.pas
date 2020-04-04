Program WDRCC10;

Uses Crt, Dos, SysUtils, SPC_DATA,
     uString, uConst, uSysInfo,
     uFunc;

Var PasParams    : TPasParams;
    LastErrorType: LongInt;          

Const cVersion = '1.1';

{                     
  cd F:\sprachen\pascal\wdsibyl\bin
  Rcomp25 P:\WDSibyl\WDSibyl\Compiler\Test\Test P:\WDSibyl\WDSibyl\Compiler\Output -OS2
  Compiling P:\WDSibyl\WDSibyl\Compiler\Test\Test.rc
  Error in:1 :Icon/Bitmap not found:P:\WDSibyl\BMP\COMPNT\SPINDOWN.BMP
}

Function ParameterVerarbeiten : Boolean;

Var PS2, PS3   : String;

Begin
  Result:=true;
  FillChar(PasParams, sizeOf(tPasParams), #0);
  PasParams.Quell:=ExpandFileName(ParamStr(1));
  if ExtractFileExt(PasParams.Quell) =''
    then PasParams.Quell:=PasParams.Quell+EXT_UC_RC;
  PS2:=ParamStr(2);
  PS3:=ParamStr(3);
  if PS2 = '' then exit;
  if PS2[1]='-'
    then
      Begin
        PasParams.Params:=PS2;
        exit;       
      end
    else PasParams.Out:=PS2;
  if PS3[1]='-'
    then PasParams.Params:=PS3;
End;

Function Compileraufruf : Boolean;

Var PasReturn:TPasReturn;
    CompilerDLL : tcCompiler;

Begin
//  Writeln('   Output: ', PasParams.Out);
//  Writeln('   Param:  ', PasParams.Params);
  PasParams.MsgProc:= @SetCompilerStatusMessage;
  PasParams.Params := uppercase(PasParams.Params);
  CompilerDLL.Create(CompRes,'');
  try
    CompilerDLL.InvokeCompiler(PasParams, PasReturn);
//    if (SysInfo.OS.System=Win32) or (PasParams.Params='-NEW')
//      then
//        Begin
//          PasParams.Params:='-OS2';
//          uResDll.InvokeRes(PasParams, PasReturn);
//        End
//
//      else SPC_DATA.InvokeRes(PasParams, PasReturn);

  except
    PasReturn.Error := TRUE;
    SetCompilerStatusMessage('Internal Compiler Error occured.','',errNone,0,0);
  end;
  CompilerDLL.Destroy;
  Result:=true;
End;
                        
Procedure Show_Help;

Begin                        
  Writeln('WDSibyl Resource Compiler Version '+cVersion+forOS);
  Writeln('-------------------------------------------------------');
  Writeln;
  Writeln(CopyRightText);
  Writeln;
  Writeln('Usage: '+goSysInfo.ProgramInfo.Name+' [Sourcefile[.rc]] [DestDir] [-Win32] [-OS2]');
  Writeln;
End;

Begin          
  LastErrorType:=0;
  if ParamCount = 0
    then Show_Help
    else
      if ParameterVerarbeiten then
        Compileraufruf;
// Readln;
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  24-Jul-2004 WD       Erstellung des Projektes
  25-Sep-2004 WD       Aufteilung des Compilers in die WDRCD10.SPR und in die WDRCC10.SPR
}
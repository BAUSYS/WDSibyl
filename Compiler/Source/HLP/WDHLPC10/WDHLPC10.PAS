PROGRAM WDHLPC10;

USES Dos,crt,Classes, SysUtils, uString, uSysInfo,
     SPC_DATA, uFunc,
     uHlpDef, uHlpComp;

{
cd P:\WDSibyl\WDSibyl\Help\Source
P:\WDSIBYL\WDSIBYL\COMPILER\OUTPUT\OS2\wdhlpc10 wdsibyl.shs -os2 -L=EN
}

Const cVersion = '1.0';               

Var PasParams    : TPasParams;
    LastErrorType: LongInt;

Function ParameterVerarbeiten : Boolean;

var Cou : Byte;
    Parameter: String;

Begin
  Result:=true;
  FillChar(PasParams, sizeOf(tPasParams), #0);
  PasParams.Quell:=ExpandFileName(ParamStr(1));
  if ExtractFileExt(PasParams.Quell) =''
    then PasParams.Quell:=PasParams.Quell+EXT_UC_WDSibyl_Help;
  PasParams.Params:='';

  for Cou:=2 to ParamCount do
    Begin
      Parameter:=ParamStr(cou)+' ';
      if Parameter[1]='-'
        then PasParams.Params:=PasParams.Params+Parameter
        else PasParams.Out:=Parameter;
    End;

/*
  PS2:=ParamStr(2);
  PS3:=ParamStr(3);
  if PS2 = '' then exit;

  if PS2[1]='-'
    then
      Begin
        Start:=1;
        PasParams.Params:=PS2+' '+PS3;
        exit;       
      end
    else
  if PS3[1]='-'
    then PasParams.Params:=PS3+' '+PS4; */


End;

Function Compileraufruf : Boolean;

Var PasReturn:TPasReturn;

Begin
// Writeln('   Quell:',   PasParams.Quell);
// Writeln('   Output: ', PasParams.Out);
// Writeln('   Param:  ', PasParams.Params);
  PasParams.MsgProc:= @SetCompilerStatusMessage;
  PasParams.Params := uppercase(PasParams.Params);     
  try
//    SPC_DATA.InvokeHlp(PasParams, PasReturn);
    uHLPComp.InvokeHlp(PasParams, PasReturn);
  except
    PasReturn.Error := TRUE;
    SetCompilerStatusMessage('Internal Compiler Error occured.','',errNone,0,0);
  end;
  Result:=true;
End;


Procedure Show_Help;
            
Begin
  Writeln('WDSibyl Help Compiler Version '+cVersion+forOS);
  Writeln('-------------------------------------------------------');
  Writeln;
  Writeln(CopyRightText);
  Writeln;
  Writeln('Usage: '+goSysInfo.ProgramInfo.Name+' [Sourcefile['+
    EXT_UC_WDSibyl_Help+']] [DestDir] [-Win32] [-OS2] [Options]');
  Writeln;
  Writeln('Options:');
  Writeln('   -L=   Language DE, EN or NL');
  Writeln;
End;

Begin
  LastErrorType:=0;
  if ParamCount = 0
    then Show_Help
    else
      if ParameterVerarbeiten then
        Compileraufruf;
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  27-Feb-2005 WD       Help-Compiler in das WDSibyl-Projekt eingefuegt.
}

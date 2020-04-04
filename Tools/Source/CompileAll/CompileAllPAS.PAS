Program CompileAllPAS;

Uses Crt, Dos, SysUtils, uSysInfo, uSysClass, uString,
     Consts,
     uFunc, SPC_DATA;

/* Aufruf:
cd V:\Temp\WDSIBYL\TOOLS\OUTPUT\OS2
compileallpas V:\Temp\WDSibyl\Bin\OS2\ V:\Temp\WDSibyl\Library\Source V:\Temp\WDSibyl\OS\Win32\Lib W32
*/

Var CompOS        : tStr6;    // Fuer das angegebene Betriebsystem kompilieren
    CompOS_Path   : tStr6;
    CompilerPAS   : tcCompiler;
    CompPathBin   : tFileName;
    SrcPath       : tFileName;
    OutPath       : tFileName;
    Params        : TPasParams;
    Return        : TPasReturn;
    CompErr       : Boolean;
    LogName       : tFileName;
    Log           : tcLog;
    LogTxt        : String;
    RunFromInstall: Boolean;
{$IFDEF OS2}
    Event         : tcEventSemaphor;
{$ENDIF}

Const Msg_RunFromInstall = 'Run from Install';
      Msg_NoSemaphor     = 'No Install-Semaphor found';

PROCEDURE SetCompilerAllStatusMessage(StatusMsg,ErrorFile:CSTRING;
                                   ErrorType:LONGINT; ErrorLine,ErrorColumn:LONGINT); CDECL;

VAR s,d,n,e:STRING;
    ErrorMsg:STRING;
    newline:BOOLEAN;

BEGIN
  newline := LastErrorType <> errLineNumber;
  LastErrorType := ErrorType;

  CASE ErrorType OF
    errNone:       s := StatusMsg;
    errWarning:    s := 'Warning at [';
    errError:      s := 'Error at [';
    errFatalError: s := 'Fatal Error at [';
  END;

  CASE ErrorType OF
    errWarning,errError,errFatalError:
    BEGIN
      FSplit(ErrorFile,d,n,e);
      ErrorMsg := '"' + StatusMsg + '"';
      s := s + tostr(ErrorLine) + ',' + tostr(ErrorColumn) +
        '] in ' + n + e + '  ' + ErrorMsg;
    END;
    errLineNumber:
    BEGIN
      FSplit(ErrorFile,d,n,e);
      s := n + e + ' (' + tostr(ErrorLine) + ')';
    END;
    ELSE s := StatusMsg;
  END;

  Log.Writeln(s);
  if ErrorType in [errError, errFatalError] then
    begin
      IF not newline THEN GotoXY(1,WhereY-1);
      CompErr := true;
    end;

End;


Function InvokeCompilerPas(Source, IncSrcDir : tFileName; TargetTyp : Byte) : Boolean;

// TargetTyp: 1 ... GUI, 2 ... Text

Begin
  Result:=false;
  fillchar(Params,sizeof(tPasParams),0);
  FillChar(Return,sizeof(Return),0);
  Params.MsgProc     := @SetCompilerAllStatusMessage;
  Params.Out         := OutPath;
  Params.Version     := 201;  //SPC20 owner
  Params.AddResources:= NIL;
  Params.ErrorTable  := NIL;
  Params.Quell       := Source;
  Params.ExeOut      := '';
  Params.Lib         := OutPath;
  Params.IncSrcDir   := IncSrcDir;   // bei SPDLL30
  Params.Defines     := '';
  Params.Params      := ' -D -L -M-' + CompOS + '-O3-$I--T'+tostr(TargetTyp)+'-%S256-%H8192';
  Log.Writeln('----------------------------------------');
  Log.Writeln('InvokeSPC:'+ Source);
  Log.Writeln('Out:      '+ Params.Out);
  Log.Writeln('Lib:      '+ Params.Lib);
  Log.Writeln('IncSrcdir:'+ Params.IncSrcDir);

  TRY
    CompilerPas.InvokeCompiler(Params,Return);
  EXCEPT
    Return.Error := TRUE;
    SetCompilerStatusMessage('Internal Compiler Error occured.','',errNone,0,0);
    CompErr:=true;
    exit;
  END;
End;


Procedure CompilePAS;

Var FiSearchRec         : tSearchRec;
    Src_RC              : tFileName;
    Src_RTL, Src_RTL_OS : tFileName;
    Src_TP70            : tFileName;
    Src_SPCC            : tFileName;
    Src_DB              : tFileName;
    Src_Compnt          : tFileName;
    Src_Dialog          : tFileName;
    Src_Inter           : tFileName;
    Src_MM              : tFileName;
    Src_Rest            : tFileName;

Begin
  Src_RC    := SrcPath + 'RC\';
  Src_RTL   := SrcPath + 'RTL\';
  Src_RTL_OS:= Src_RTL + CompOS_Path + '\';
  Src_TP70  := SrcPath + 'TP70\';
  Src_SPCC  := SrcPath + 'SPCC\';
  Src_DB    := SrcPath + 'DB\';
  Src_Compnt:= SrcPath + 'Compnt\';
  Src_Dialog:= SrcPath + 'Dialog\';
  Src_Inter := SrcPath + 'Internet\';
  Src_MM    := SrcPath + 'Multimedia\';
  Src_Rest  := SrcPath + 'Rest\';

  Log.Writeln('Path_Src_RC        :'+Src_RC);
  Log.Writeln('Path_Src_RTL       :'+Src_RTL);
  Log.Writeln('Path_Src_RTL_OS    :'+Src_RTL_OS);
  Log.Writeln('Path_Src_TP70      :'+Src_TP70);
  Log.Writeln('Path_Src_SPCC      :'+Src_SPCC);
  Log.Writeln('Path_Src_DB        :'+Src_DB);
  Log.Writeln('Path_Src_Compnt    :'+Src_Compnt);
  Log.Writeln('Path_Src_Dialog    :'+Src_Dialog);
  Log.Writeln('Path_Src_Internet  :'+Src_Inter);
  Log.Writeln('Path_Src_MultiMedia:'+Src_MM);
  Log.Writeln('Path_Src_Rest      :'+Src_Rest);


// MakeRTL.PAS
  if InvokeCompilerPas(SrcPath+'MakeRTL',
                    Src_RTL +';'+Src_RTL_OS+';'+Src_RC, 2) then exit;

// MakeTP70.PAS
  if InvokeCompilerPas(SrcPath+'MakeTP70', Src_RTL +';'+Src_TP70, 2) then exit;
                 
// MakeSPCC.PAS
  if InvokeCompilerPas(SrcPath+'MakeSPCC', Src_SPCC, 2) then exit;

// MakeDB.PAS
  if InvokeCompilerPas(SrcPath+'MakeDB',
                    Src_DB+';'+Src_DB+'mySQL\', 2) then exit;

// MakeCompnt.PAS
  if InvokeCompilerPas(SrcPath+'MakeCompnt', Src_Compnt, 2) then exit;

// MakeDialog.PAS
  if InvokeCompilerPas(SrcPath+'MakeDialog', Src_Dialog, 2) then exit;

// MakeInternet.PAS
  if InvokeCompilerPas(SrcPath+'MakeInternet', Src_Inter, 2) then exit;
 
// MakeMultiMedia.PAS
  if InvokeCompilerPas(SrcPath+'MakeMultiMedia', Src_MM, 2) then exit;

// MakeRest.PAS
  if InvokeCompilerPas(SrcPath+'MakeRest', Src_TP70, 2) then exit;

End;

Procedure ShowHelp;

Begin
  Writeln(CopyRightText);
  Writeln;
  Writeln('Usage: CompileAllPAS Compile-Path Source-Path Output-Path [Options]');
  Writeln;
  Writeln('Options are:');
{$IFDEF OS2}
  Writeln('  -OS2    OS/2 Target (default)');
  Writeln('  -Win32  Win32 Target');
{$ENDIF}
{$IFDEF Win32}
  Writeln('  -Win32  Win32 Target (default)');
  Writeln('  -OS2    OS/2 Target');
{$ENDIF}
End;

Begin
  ClrScr;
  RunFromInstall:=false;
  Writeln('WDSibyl CompileAllPAS Version 1.1 ' + ForOS);
  Writeln('-----------------------------------------------------------------------');
  Writeln;

  if ParamCount=0 then
    Begin
      ShowHelp;
      exit;
    end;

{$IFDEF OS2}
  CompOS:='OS2';
{$ENDIF}
{$IFDEF Win32}
  CompOS:='W32';
{$ENDIF}

  CompPathBin:=AddPathSeparator(ParamStr(1));
  SrcPath:=AddPathSeparator(ParamStr(2));
  OutPath:=AddPathSeparator(ParamStr(3));
  if ParamStr(4) <> '' then
    CompOS:=copy(ParamStr(4),2,5);    // TB 13-07-2006
  if CompOS = 'OS2' then
    Begin
      CompOS_Path:='OS2';
    end
  else if (CompOS = 'W32') or (CompOS = 'Win32') then
    Begin
      CompOS:='W32';
      CompOS_Path:='Win32';
    End
  else
    Begin
      Writeln('Error: Parameter for OS is not correct !');
      Halt(1);
    End;

  LogName:=ChangeFileExt(goSysInfo.ProgramInfo.ExeName, '_'+CompOS+Ext_UC_Log);
  Writeln('Log: ',LogName);
  Log.Create(LogName);

  if ParamStr(5) = WDSibyl_Install_Param then
    Begin
      RunFromInstall:=true;
      Writeln(Msg_RunFromInstall);
      Log.Writeln(Msg_RunFromInstall);

      {$IFDEF OS2}
      Event.Create(WDSibyl_Sem_CompileALLPas);
      LogTxt:='Semaphor:'+tostr(event.handle)+', Typ:'+Event.TypText;
      Writeln(LogTxt);
      Log.Writeln(LogTxt);
      if Event.Typ<>SemaphorTypOpen then
        Begin
          Writeln(Msg_NoSemaphor);
          Log.Writeln(Msg_NoSemaphor);
          RunFromInstall:=false;
          Event.Destroy;
        End;
      {$ENDIF}
    End;                  
  CompilerPAS.Create(CompSPC, CompPathBin);
  CompilePAS;
  CompilerPas.Destroy;

  Writeln;
  Writeln;
  Writeln('Compiler has finished.');

  if RunFromInstall then
    Begin
      {$IFDEF OS2}
      Event.Post;
      SysSleep(100);  // Nur mal kurz warten, damit alles Verarbeitet wird.
      Event.Destroy;  // Semaphor kann jetzt geloescht werden
      {$ENDIF}
    End;


  Log.Destroy;
End.

{ -- date -- --from-- -- changes ----------------------------------------------
  21-Aug-06  WD       Fuer jedes Betriebsystem eine eigene LOG-Datei
  19-Mar-07  WD       Den EventSemaphor und den Parameter "-INSTALL" eingenbaut
  08-Feb-09  WD       Umbau auf die neuen Semaphor-Klasse.
}

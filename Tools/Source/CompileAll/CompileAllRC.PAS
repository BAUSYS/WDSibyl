Program CompileAllRC;

Uses Crt, Dos, SysUtils, uSysClass, uSysInfo, uFunc, uString,
     SPC_DATA, Consts;

Var CompOS        : tStr6;    // Fuer das angegebene Betriebsystem kompilieren
    CompilerRes   : tcCompiler;
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


Procedure CompileRC;

Var FiSearchRec : tSearchRec;

Begin
  fillchar(Params,sizeof(tPasParams),0);
  FillChar(Return,sizeof(Return),0);
  Params.MsgProc     := @SetCompilerAllStatusMessage;
  Params.Out         := OutPath;
  Params.Params      := '-'+CompOS;
  If FindFirst(SrcPath+'*.RC', faAnyFile, FiSearchRec) = 0 then
    Begin
      Repeat
        Params.Quell := SrcPath+FiSearchRec.Name;
        try
          CompilerRes.InvokeCompiler(Params,Return);
        except
          Return.Error := TRUE;
          SetCompilerStatusMessage('Internal Compiler Error occured.','',errNone,0,0);
          CompErr:=true;
          exit;
        end;
      Until FindNext(FiSearchRec)<>0;
      FindClose(FiSearchRec);
    End;
End;

Procedure ShowHelp;

Begin
  Writeln(CopyRightText);
  Writeln;
  Writeln('Usage: CompileAllRC Compile-Path Source-Path Output-Path [Options]');
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
  Writeln('WDSibyl CompileAllRC Version 1.1 ' + ForOS);
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
  CompOS:=AnsiUpperCase(CompOS);
  if (CompOS <> 'OS2') and (CompOS <> 'W32') then
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
      Event.Create(WDSibyl_Sem_CompileALLRC);
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

  CompilerRes.Create(CompRes, CompPathBin);
  CompileRC;
  CompilerRes.Destroy;
  Writeln;
  Writeln;
  Writeln('Ressource compiler has finished.');

  if RunFromInstall then
    Begin
      {$IFDEF OS2}
      Event.Post;
      SysSleep(100);  // Nur mal kurz warten, damit alles Verarbeitet wird.
      Event.Destroy;  // Semaphor kann jetzt geloescht werden
      {$ENDIF}
    End;
  Log.Destroy;
//  Readln;
End.

{ -- date -- --from-- -- changes ----------------------------------------------
  21-Aug-06  WD       Fuer jedes Betriebsystem eine eigene LOG-Datei
  19-Mar-07  WD       Den EventSemaphor und den Parameter "-INSTALL" eingenbaut
  08-Feb-09  WD       Umbau auf die neuen Semaphor-Klasse.
}
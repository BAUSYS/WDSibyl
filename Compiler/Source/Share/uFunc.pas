Unit uFunc;

Interface

uses Dos, Crt, SysUtils, SPC_Data, uString;

const LastErrorType:LONGINT = 0;

Function ForOS : tStr10;

Function CopyRightText : String;

Procedure SetCompilerStatusMessage(StatusMsg,ErrorFile:CSTRING;
                                   ErrorType:LONGINT; ErrorLine,ErrorColumn:LONGINT); CDECL;

Implementation

Function CopyRightText : String;

Begin
  Result:='von Ing. Wolfgang Draxler      @2004..09'
End;

Function ForOS : tStr10;

Begin
{$IFDEF OS2}
  Result:=' for OS/2';
{$ENDIF}
{$IFDEF Win32}
  Result:=' for Win32';
{$ENDIF}
End;

PROCEDURE SetCompilerStatusMessage(StatusMsg,ErrorFile:CSTRING;
                                   ErrorType:LONGINT; ErrorLine,ErrorColumn:LONGINT); CDECL;
/* in WatCom
void APIENTRY (*NotifyIDE) (char *NotifyStr, char *SourceFile,
                                         longint NotifyCode, longint yylineno,
                                         longint yycolno);
*/

VAR
  s,d,n,e:STRING;
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

  IF not newline THEN GotoXY(1,WhereY-1);
  Writeln(s);
END;

Initialization
End.

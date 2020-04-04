program RexxTest;

{******************************************************************************
 *                                                                            *
 * Sample program showing how to use the Sibyl REXX interface                 *
 *                                                                            *
 *                                                                            *
 ******************************************************************************}

USES Os2Def, RexxSaa, BseDOS,Crt;

CONST
  RexxSrcBufLen      = 4096;

TYPE
  PRexxBuf           = ^TRexxBuf;
  TRexxBuf           = ARRAY[0..RexxSrcBufLen-1] OF CSTRING;
  TRexxSrcBuf        = ARRAY[0..RexxSrcBufLen-1] OF Char;

FUNCTION CreateRexxSrcCode(CONST RexxSrc:PRexxBuf;RexxSrcLen:LONGWORD;VAR Len:LONGINT):TRexxSrcBuf;
VAR C:CSTRING;
    t,t1:LONGINT;
BEGIN
     {Create REXX procedure source code at runtime in memory}
     Len := 0;
     FOR t1 := 0 TO RexxSrcLen DO
     BEGIN
          C := RexxSrc^[t1];
          FOR t:=0 TO length(C) DO
          BEGIN
              result[Len] := C[t];
              Inc(Len);
          END;
          result[Len]:= #13;    { terminate line with CR+LF }
          result[Len+1]:= #10;
          Inc(Len, 2);
     END;
END;

{Executes a REXX procedure with one single argument}
FUNCTION InterpretRexxCommand(const RexxSrc:PRexxBuf;RexxSrcLen:LONGWORD;CONST AArg:CString):Longint;
VAR
  RexxFName,RexxEnv:CSTRING;
  Len:LongInt;
  Arg:RxString;
  RexxReturnBuf:RxString;
  RexxRC:Word;
  RexxCmdBuf:ARRAY[0..1] OF RxString;
  SrcBuf:TRexxSrcBuf;
BEGIN
  SrcBuf:=CreateRexxSrcCode(RexxSrc,RexxSrcLen,Len);

  RexxCmdBuf[0].strptr := @SrcBuf;
  RexxCmdBuf[0].strlength := Len;

  RexxCmdBuf[1].strptr := NIL;
  RexxCmdBuf[1].strlength := 0;


  { Now we call the interpreter via API}
  RexxFName:='SP_CallRexx';
  RexxEnv:='CMD';
  Arg.strlength := Length(AArg);
  Arg.strptr := @AArg[0];
  RexxReturnBuf.strlength := 0;
  result:= RexxStart(1,                    { We have 1 argument to pass }
                     Arg,                  { Argument buffer            }
                     RexxFName,            { REXX procedure name        }
                     RexxCmdBuf[0],        { Procedure source buffer    }
                     RexxEnv,              { REXX environment name      }
                     rxCommand,            { command code               }
                     NIL,                  { No exit                    }
                     RexxRC,               { Rexx return variable       }
                     RexxReturnBuf         { Rexx output                }
                    );

  {Release memory of buffers}
  IF RexxReturnBuf.strptr<>NIL THEN DosFreeMem(RexxReturnBuf.strptr);
  DosFreeMem(RexxCmdBuf[1].strptr);
END;

{REXX source that is to be executed}
CONST
  DirCommandBuf: array [0..1] of CSTRING =
    ( 'Parse Arg Data',
      'DIR Data'
    );

VAR
  rc:Longint;  {return code indicating success/error}

BEGIN
  Writeln('Press any key to perform a DIR *.* operation via REXX');
  readkey;

  { Perform a DIR operation }
  rc:=InterpretRexxCommand(PRexxBuf(@DirCommandBuf),2, '*.*');
  if rc<>0 then
    WriteLn('Failed to perform DIR *.* command, REXX Error Code is ',RC);

  Writeln('Press any key to terminate demo');
  readkey;
END.

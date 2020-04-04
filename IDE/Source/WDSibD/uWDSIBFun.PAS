Unit uWDSIBFun;
                  
Interface

Uses Forms, Color, StdCtrls, ExtCtrls, Dialogs, Dos, SysUtils, Buttons,
     Graphics,
     Consts, uDLLDef, Dos, uStream,
     SPC_Data;

{$IFDEF OS2}
USES Os2Def,BseTib,PmWin,BseDos,PmStdDlg;
{$ENDIF}

{$IFDEF WIN32}
Uses WinBase;
{$ENDIF}


Procedure InitWDSibDLL(DLLInfo : tWDSibDLLInfo);
Procedure DestroyWDSibDLL;

FUNCTION Upcased(CONST s:STRING):STRING;
FUNCTION SplitFontName(FontName:STRING; VAR Name:STRING; VAR Size:LONGINT):BOOLEAN;
FUNCTION SplitFixedFontName(FontName:STRING; VAR Name:STRING; VAR Height,Width:LONGINT):BOOLEAN;
PROCEDURE NormalizeDir(VAR dirstr:STRING);
FUNCTION GetNextDir(VAR dir:STRING):STRING;
//FUNCTION ReplaceEnvStrings(CONST Path:STRING):STRING;

FUNCTION GetShortName(s:STRING;anz:INTEGER):STRING;

FUNCTION IsFlag(s,test:STRING):BOOLEAN;
PROCEDURE AddFlag(VAR s:STRING;CONST flag:STRING);

FUNCTION ReplaceEnvStrings(CONST Path:STRING):STRING;
FUNCTION FExpand(Path:STRING):STRING;

FUNCTION Exec2(CONST Path: PathStr; CmdLine: STRING):LONGWORD;

Procedure GetRCIcon(Name : String; Var Icon : tIcon);

Procedure LogRunCompiler(Quell_Ext : String; Params : TPasParams);


Implementation


Procedure InitWDSibDLL(DLLInfo : tWDSibDLLInfo);

Begin
  gDLLInfo:=DLLInfo;
  Application:=gDLLInfo.Application;
End;

Procedure DestroyWDSibDLL;

Begin
End;

// -------------------------------------------------------------------

FUNCTION IsFlag(s,test:STRING):BOOLEAN;
// Original: Projects

CONST NoSeparators = ['0'..'9','A'..'Z','_','„','Ž','”','™','','š','á'];

VAR p:INTEGER;

BEGIN
  Result := FALSE;
  UpcaseStr(s);
  UpcaseStr(test);
  p := pos(test,s);
  IF p = 0 THEN exit;
  {Test Separator}
  IF p > 1 THEN
    IF s[p-1] IN NoSeparators THEN exit;
  IF p + Length(test) <= Length(s) THEN
    IF s[p+Length(test)] IN NoSeparators THEN exit;
  Result := TRUE;
END;

PROCEDURE AddFlag(VAR s:STRING;CONST flag:STRING);
// Original: Projects

BEGIN
  IF s = ''
    THEN s := flag
    ELSE s := s + ',' + flag;
END;

// -------------------------------------------------------------------

FUNCTION ReplaceEnvStrings(CONST Path:STRING):STRING;
VAR
  p,i,c:INTEGER;
  env:STRING;
BEGIN
  Result := Path;
  {ersetze %Environment% Variable}
  WHILE pos('%',Result) > 0 DO
  BEGIN
    p := pos('%',Result);
    c := 0;
    env := '';
    FOR i := p+1 TO Length(Result) DO
      IF Result[i] = '%' THEN
      BEGIN
        env := copy(Result,p+1,c);
        break;
      END
      ELSE inc(c);

    IF env = '' THEN break; {kein Endezeichen gefunden}

    UpcaseStr(env);
    env := GetEnv(env);
    IF env <> '' THEN
    BEGIN
         {markiere % im EnvStr}
         FOR i := 1 TO Length(env) DO
           IF env[i] = '%' THEN env[i] := chr(255);

         delete(Result,p,c+2);  {2x %}
         insert(env,Result,p)
    END
    ELSE Result[p] := chr(255);   {markieren}
  END;

  FOR i := 1 TO Length(Result) DO
    IF ord(Result[i]) = 255 THEN Result[i] := '%';
END;

FUNCTION FExpand(Path:STRING):STRING;
BEGIN
  Result := '';
  IF Path = '' THEN exit;
  Path := ReplaceEnvStrings(Path);
  IF Path = '' THEN exit;
  //relative Pfade sind relativ zum aktuellen Verzeichnis
  Result := DOS.FExpand(Path);
END;

// -------------------------------------------------------------------


FUNCTION GetShortName(s:STRING;anz:INTEGER):STRING;
VAR  d,lw:STRING;
     pseudo:STRING;
     ps:INTEGER;
BEGIN
     lw := copy(s,1,3);
     pseudo := '';
     d := copy(s,4,Length(s)-3);

     WHILE Length(d) > anz DO
     BEGIN
          ps := pos('\',d);
          IF ps > 0 THEN
          BEGIN
               delete(d,1,ps);
               pseudo := '...\';
          END
          ELSE break;
     END;
     Result := lw + pseudo + d;
END;

FUNCTION Upcased(CONST s:STRING):STRING;
BEGIN
  Result := s;
  UpcaseStr(Result);
END;


{$HINTS OFF}
FUNCTION SplitFontName(FontName:STRING; VAR Name:STRING; VAR Size:LONGINT):BOOLEAN;
VAR  s:STRING;
     p,e:INTEGER;
BEGIN
  Result := FALSE;
  p := pos('.',FontName);
  IF p = 0 THEN exit;
  s := copy(FontName,1,p-1);
  val(s,Size,e);
  IF e <> 0 THEN exit;  {Error}
  Name := copy(FontName,p+1,255);
  IF Name <> '' THEN Result := TRUE;
END;


FUNCTION SplitFixedFontName(FontName:STRING; VAR Name:STRING; VAR Height,Width:LONGINT):BOOLEAN;
VAR  s:STRING;
     p,x,e:INTEGER;
BEGIN
  Result := FALSE;
  p := pos('.',FontName);
  IF p = 0 THEN exit;
  s := copy(FontName,1,p-1);
  x := pos('x',s);
  val(copy(s,1,x-1),Height,e);
  IF e <> 0 THEN exit;  {Error}
  val(copy(s,x+1,255),Width,e);
  IF e <> 0 THEN exit;  {Error}
  Name := copy(FontName,p+1,255);
  IF Name <> '' THEN Result := TRUE;
END;
{$HINTS ON}


PROCEDURE NormalizeDir(VAR dirstr:STRING);
BEGIN
  IF dirstr[Length(dirstr)] = '\' THEN dec(dirstr[0]);
END;

FUNCTION GetNextDir(VAR dir:STRING):STRING;
VAR  ps:WORD;
BEGIN
  ps := pos(';',dir);
  IF ps > 0
    THEN
      BEGIN
        Result := copy(dir,1,ps-1);
        delete(dir,1,ps);
      END
    ELSE
      BEGIN
        Result := dir;
        dir := '';
      END;
  NormalizeDir(Result);
END;


//kopiert aus Dos.pas
//Parameter: aStartData.InheritOpt:=SSF_INHERTOPT_PARENT;
FUNCTION Exec2(CONST Path: PathStr; CmdLine: STRING):LONGWORD;
// Original: Compiler

type tdata = record
             d1: word;
             d2: word
           end;
VAR
    {$IFDEF OS2}
    aStartData:STARTDATA;
    ObjectBuffer:STRING;
    SessID:LONGWORD;
    SessPID:PID;
    eresult:ExecResultCode;

    tib:PTIB;
    pib:PPIB;
    QueueHandle:HQUEUE;
    PIDS: STRING;
    QUE_NAME:CSTRING;

    Request:REQUESTDATA;         /* Request-identification data */
    DataLength:LongWord;            /* Length of element received */
    DataAddress:POINTER;         /* Address of element received */
    ElementCode:LongWord;           /* Request a particular element */
    NoWait:BOOL;                 /* No wait if queue is empty */
    ElemPriority:BYTE;           /* Priority of element received */

    SEM_NAME:CSTRING;
    SemHandle:HEV;               /* Semaphore handle */
    flAttr:LongWord;                /* Creation attributes */
    fState:BOOLEAN;              /* Initial state of semaphore */
    ulPostCt:LONGWORD;           /* Current post count for the semaphore */

    Queue: QMSG;                  { Message-Queue }
    ahab: hab;

    rc:APIRET;                   /* Return code */
    rdata: ^tdata;
    {$ENDIF}
    {$IFDEF Win32}
    aStartData:StartupInfo;
    aProcessInfo:PROCESS_INFORMATION;
    {$ENDIF}
    c,c1:CSTRING;
BEGIN
     c:=Path;
     c1:=CmdLine;
     {$IFDEF OS2}
     IF ExecViaSession THEN
     BEGIN
          IF NOT AsynchExec THEN
          BEGIN
            DosGetInfoBlocks(tib,pib);
            IF pib=NIL THEN raise EProcessTerm.Create('Can''t retrieve process-id')
            ELSE str(pib^.pib_ulpid,PIDS);
            QUE_NAME:='\QUEUES\TERMQ\'+PIDS+#0;
            rc := DosCreateQueue(QueueHandle,QUE_FIFO OR QUE_CONVERT_ADDRESS,QUE_NAME);
            if rc<>0 THEN raise EProcessTerm.Create('Can''t create exec termination-Queue');
            aStartData.TermQ:=@QUE_NAME;
          END
          ELSE aStartData.TermQ:=NIL;

          aStartData.Length:=sizeof(STARTDATA);
          aStartData.Related:=SSF_RELATED_CHILD;
          aStartData.FgBg:=SSF_FGBG_BACK;
          aStartData.TraceOpt:=SSF_TRACEOPT_NONE;
          aStartData.PgmTitle:=@c;
          aStartData.PgmName:=@c;
          aStartData.PgmInputs:=@c1;
          aStartData.Environment:=NIL;
          aStartData.InheritOpt:=SSF_INHERTOPT_PARENT;
          aStartData.SessionType:=SSF_TYPE_DEFAULT;
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
          DosError:=DosStartSession(aStartData,SessId,SessPid);

          IF DosError<>0 THEN
          BEGIN
            IF NOT AsynchExec THEN
            BEGIN
                rc := DosCloseQueue(QueueHandle);
                if rc<>0 THEN raise EProcessTerm.Create('Can''t close exec termination-Queue');
            END;
            exit;
          END;

          DosSelectSession(SessID);
          IF NOT AsynchExec THEN
          BEGIN
            IF ApplicationType<>cApplicationType_GUI THEN
            BEGIN
              Request.pid := pib^.pib_ulpid;
              ElementCode := 0;
              NoWait := FALSE;
              SemHandle := 0;
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t read termination-Queue');
              rdata:=DataAddress;
              Result:=rdata^.d2;
              rc := DosFreeMem(DataAddress);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t free QueueData');
              rc := DosCloseQueue(QueueHandle);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t close termination-Queue');
            END
            ELSE
            BEGIN
              SEM_NAME:='\SEM32\TERMQ\'+PIDS+#0;
              flAttr := 0;
              fState := FALSE;
              rc := DosCreateEventSem(SEM_NAME,SemHandle,flAttr,fState);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t create event-semaphore');
              Request.pid := pib^.pib_ulpid;
              ElementCode := 0;
              NoWait := TRUE;
              ahab :=  AppHandle; //WinQueryAnchorBlock(1);
              ulPostCt:=0;
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              IF (rc<>0)AND(rc<>342) THEN raise EProcessTerm.Create('Can''t read termination-Queue');
              WHILE WinGetMsg(ahab,Queue,0,0,0) DO
              BEGIN
                rc := DosQueryEventSem(SemHandle, ulPostCt);
                IF rc<>0 THEN raise EProcessTerm.Create('Can''t query event-semaphore');
                IF ulPostCt>0 THEN BREAK;
                WinDispatchMsg(ahab,Queue);
              END;

              rc := DosCloseEventSem(SemHandle);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t close event-semaphore');
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t read termination-Queue');
              rdata:=DataAddress;
              Result:=rdata^.d2;
              rc := DosFreeMem(DataAddress);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t free QueueData');
              rc := DosCloseQueue(QueueHandle);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t close termination-Queue');
            END;
          END
          ELSE Result:=SessID;
     END
     ELSE
     BEGIN
          LastExecResult:=0;
          IF AsynchEXEC THEN DosExecPgm(@ObjectBuffer,256,2,c1,
                                        NIL,eresult,c)
          ELSE
          BEGIN
               c1:=#0+c1;
               DosExecPgm(@ObjectBuffer,256,0,c1,
                          NIL,eresult,c);
               LastExecresult:=eresult.CodeResult;
          END;
          Result:=LastExecResult;
     END;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     FillChar(aStartData,sizeof(aStartData),0);
     aStartData.cb:=sizeof(aStartData);
     IF not CreateProcess(c,c1,NIL,NIL,FALSE,CREATE_NEW_CONSOLE OR
                          NORMAL_PRIORITY_CLASS,NIL,NIL,
                          aStartData,aProcessInfo) THEN
     BEGIN
          DosError:=1;
          exit;
     END;                
     Result:=aProcessInfo.hProcess;
     {$ENDIF}
END;

Procedure GetRCIcon(Name : String; Var Icon : tIcon);

Begin
  Icon.Create;
  Icon.LoadFromResourceName(Name);
End;

Procedure LogRunCompiler(Quell_Ext : String; Params : TPasParams);

Begin
  gDLLInfo.Application.LogWriteln('CallInvokeCompiler: SPDLL geladen.');
  gDLLInfo.Application.LogWriteln('RunCompiler: Ext:'      + Quell_Ext);
  gDLLInfo.Application.LogWriteln('RunCompiler: SCUDir:'   + Params.SCUDir);
  gDLLInfo.Application.LogWriteln('RunCompiler: Out:'      + Params.Out);
  gDLLInfo.Application.LogWriteln('RunCompiler: ExeOut:'   + Params.ExeOut);
  gDLLInfo.Application.LogWriteln('RunCompiler: Lib:'      + Params.Lib);
  gDLLInfo.Application.LogWriteln('RunCompiler: LibSrc:'   + Params.LibSrc);
  gDLLInfo.Application.LogWriteln('RunCompiler: IncSrcDir:'+ Params.IncSrcDir);
  gDLLInfo.Application.LogWriteln('RunCompiler: Params:'   + Params.Params );
  gDLLInfo.Application.LogWriteln('RunCompiler: Defines:'  + Params.Defines);
End;

Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  03-Sep-2006 WD       Funktion: GetRCIcon
}

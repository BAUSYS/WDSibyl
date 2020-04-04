UNIT Process;

{**************************************************************************
 *                 General Unit for Speed-Pascal/2                        *
 *                                                                        *
 *                                                                        *
 * Copyright (C) 1995..96 SpeedSoft                                       *
 *                                                                        *
 * Basic objects for process and thread handling                          *
 *                                                                        *
 **************************************************************************}


INTERFACE

USES Os2Def,BseDos,uString;

TYPE
     PProcess=^TProcess;
     TProcess=OBJECT
                   TheExeName:STRING;
                   TheParams:STRING;
                   TheProcessID:ULONG;
                   TheProcessPID:PID;
                   TheStartData:STARTDATA;
                   ObjBuf:STRING;
                   CONSTRUCTOR Init(ExeName,Params:STRING);
                   FUNCTION Run:LONGWORD;
                   DESTRUCTOR Done;
              END;

     PThread=^TThread;
     TThread=OBJECT
                   TheThreadProc:PROCEDURE(Param:POINTER);
                   TheThreadData:POINTER;
                   TheStackSize:ULONG;
                   TheThreadTID:TID;
                   Suspended:BOOLEAN;
                   CONSTRUCTOR Init(ThreadProc,ThreadData:POINTER;
                                    ThreadStack:ULONG);
                   PROCEDURE Run;
                   PROCEDURE Kill;
                   PROCEDURE Suspend;
                   PROCEDURE Resume;
                   PROCEDURE ThreadProc;CDECL;
                   PROCEDURE SetPriority(aClass,Delta:ULONG);
                   FUNCTION HasEnded:BOOLEAN;
                   DESTRUCTOR Done;
             END;

Function GetProcesslist(MyList:TStrings) : Boolean;

IMPLEMENTATION

Uses SysUtils;

{***************************************************************************
 *                                                                         *
 *                                                                         *
 *     Object TProcess                                                     *
 *                                                                         *
 ***************************************************************************}


CONSTRUCTOR TProcess.Init(ExeName,Params:STRING);
VAR s:STRING;
    rc:ULONG;
    AppType:ULONG;
BEGIN
     IF pos('\',ExeName)=0 THEN
     BEGIN
          GetDir(0,s);
          IF s[length(s)]='\' THEN dec(s[0]);
          ExeName:=s+'\'+ExeName;
     END;
     IF Pos('.',ExeName)=0 THEN ExeName:=ExeName+'.EXE';

     TheExeName:=ExeName;
     TheParams:=params;

     TheStartData.Length:=sizeof(STARTDATA);
     TheStartData.Related:=SSF_RELATED_CHILD;
     TheStartData.FgBg:=SSF_FGBG_BACK;
     TheStartData.TraceOpt:=SSF_TRACEOPT_NONE;
     TheStartData.PgmTitle:=@TheExeName;
     TheStartData.PgmName:=@TheExeName;
     TheStartData.PgmInputs:=@TheParams;
     TheStartData.TermQ:=NIL;
     TheStartData.Environment:=NIL;
     TheStartData.InheritOpt:=SSF_INHERTOPT_SHELL;

     rc:=DosQueryAppType(ExeName,AppType);

     IF rc<>0 THEN TheStartData.SessionType:=SSF_TYPE_DEFAULT
     ELSE
     BEGIN
          IF ((AppType AND 32=32)OR(AppType=3)) THEN {DOS}
             TheStartData.SessionType:=SSF_TYPE_VDM
          ELSE TheStartData.SessionType:=SSF_TYPE_DEFAULT;
     END;

     TheStartData.IconFile:=NIL;
     TheStartData.PgmHandle:=0;
     TheStartData.PgmControl:=SSF_CONTROL_VISIBLE;
     TheStartData.InitXPos:=30;
     TheStartData.InitYPos:=40;
     TheStartData.InitXSize:=200;
     TheStartData.InitYSize:=140;
     TheStartData.Reserved:=0;
     TheStartData.ObjectBuffer:=@ObjBuf;
     TheStartData.ObjectBuffLen:=256;

     TheProcessID:=0;
     TheProcessPID:=0;
END;

FUNCTION TProcess.Run:LONGWORD;
BEGIN
     Run:=DosStartSession(TheStartData,TheProcessId,TheProcessPID);
END;

DESTRUCTOR TProcess.Done;
BEGIN
END;

{***************************************************************************
 *                                                                         *
 *                                                                         *
 *     Object TThread                                                      *
 *                                                                         *
 ***************************************************************************}


CONSTRUCTOR TThread.Init(ThreadProc,ThreadData:POINTER;ThreadStack:ULONG);
BEGIN
     TheThreadProc:=ThreadProc;
     TheThreadData:=ThreadData;
     IF ThreadStack<16384 THEN ThreadStack:=16384;
     TheStackSize:=ThreadStack;
     TheThreadTID:=0;
     Suspended:=FALSE;
END;

PROCEDURE TThread.ThreadProc;CDECL;

VAR p:PROCEDURE(Param:POINTER);

BEGIN
     p:=TheThreadProc;
     p(TheThreadData);
     {Clear TID if Thread resumed}
     TheThreadTID:=0;
END;

PROCEDURE TThread.Run;
BEGIN
     DosCreateThread(TheThreadTID,@ThreadProc,POINTER(SELF),
                     STACK_COMMITTED,TheStackSize);
END;

PROCEDURE TThread.Kill;
VAR r:ULONG;
LABEL l;
BEGIN
     IF TheThreadTID<>0 THEN
     BEGIN
l:
          r:=DosKillThread(TheThreadTID);
          IF r=170 THEN  {Thread busy}
          BEGIN
               DosSleep(50);
               goto l;
          END;
     END;
     TheThreadTID:=0;
END;

PROCEDURE TThread.Suspend;
BEGIN
     IF TheThreadTID<>0 THEN IF not Suspended THEN
     BEGIN
          DosSuspendThread(TheThreadTID);
          Suspended:=TRUE;
     END;
END;

PROCEDURE TThread.Resume;
BEGIN
     IF TheThreadTID<>0 THEN IF Suspended THEN
     BEGIN
          DosResumeThread(TheThreadTID);
          Suspended:=FALSE;
     END;
END;

PROCEDURE TThread.SetPriority(aClass,Delta:ULONG);
BEGIN
     IF TheThreadTID<>0 THEN
       DosSetPriority(PRTYS_THREAD,aClass,Delta,TheThreadTID);
END;

FUNCTION TThread.HasEnded:BOOLEAN;
BEGIN
     HasEnded:=TheThreadTID=0;
END;

DESTRUCTOR TThread.Done;
BEGIN
     Kill;
END;

// -----------------------------------------------------------

Function GetProcesslist(MyList:TStrings) : Boolean;

var buffer,work         :pointer;
    RC:Longint;
    pl_pid              : Longint;
    pl_sgid             : Longint;
    pl_pName             : String;

const buffersize          =1*1024*1024;

  Function  Process_name:String;

  var mte               :^qsLrec;
      tmp               :string;

  begin
    mte:=pointer(qsPtrRec(buffer^).pLibRec);
    while Assigned(mte) do
      with mte^ do
        if QSPrec(Work^).hMte=hmte then
          begin
            tmp:=StrPas(pName);
            //while Pos('\',tmp)<>0 do Delete(tmp,1,Pos('\',tmp));
            Result:=tmp;
            Exit;
          end
        else
          mte:=pNextRec;
    Result:='?';
  end;

Begin
  Result:=false;
  GetMem(buffer,buffersize);
  FillChar(buffer^,buffersize,0);
  RC:= DosQuerySysState(QS_PROCESS+QS_MTE,0,0,0,buffer^,buffersize);
  IF RC=0 then       // cbBuf
    Begin
      work:=qsPtrRec(buffer^).pProcRec;
      while Assigned(work) do
        case qsPrec(work^).RecType of
          0         : Break;
          QS_PROCESS: Begin
                         PL_PID:=QsPrec(Work^).PID;
                         PL_sgid:=QSPrec(Work^).Sgid;
                         Pl_PName:=Process_Name;
                         MyList.Add(ToStr(PL_Pid:5)+'|'+Pl_pName);
                         work:=QSPrec(Work^).pThrdRec;
                       End;
          QS_THREAD: Inc(longint(work),SizeOf(qsTrec));
        else Break;
      end; (* case *)
      result:=true;
    End;
  FreeMem(buffer);
End;

BEGIN
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  03-Nov-06  WD, RB     Funktion GetProcesslist eingebaut.
}
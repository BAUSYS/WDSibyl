
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit SyncComp;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Delphi 3 compatible synchronisation components                       บ
 บ     Portions Copyright (C) 1997 Borland Inc.                             บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Interface

Uses Classes;

{$IFDEF OS2}
Uses BseDos,BseErr;
{$ENDIF}
{$IFDEF WIN32}
Uses WinNT,WinBase;
{$ENDIF}

Type
  TSynchroObject = class(TObject)
    Public
      Procedure Acquire; virtual;
      Procedure Release; virtual;
  End;

  TWaitResult = (wrSignaled, wrTimeout, wrAbandoned, wrError);

  TEvent = class(TObject)
    Private
      FHandle: LongWord;
      FLastError: LongInt;
    Public
      Constructor Create(ManualReset,InitialState: Boolean;Const Name: String);
      Function WaitFor(Timeout: Longint): TWaitResult;
      Procedure SetEvent;
      Procedure ResetEvent;
      Destructor Destroy; Override;
      Property LastError: LongInt read FLastError;
      Property Handle: LongWord read FHandle;
  End;

  TSimpleEvent = class(TEvent)
    Public
      Constructor Create;
  End;

  TCriticalSection = class(TSynchroObject)
    {$IFDEF WIN32}
    Private
      FSection:CRITICAL_SECTION;
    {$ENDIF}
    Public
      Procedure Acquire; Override;
      Procedure Release; Override;
      Procedure Enter;
      Procedure Leave;
      Constructor Create;Virtual;
      Destructor Destroy;Override;
  End;


Implementation

Procedure TSynchroObject.Acquire;
Begin
End;

Procedure TSynchroObject.Release;
Begin
End;

Constructor TEvent.Create(ManualReset,InitialState: Boolean; Const Name: String);
Var c:CString;
Begin
  c:=Name;
  {$IFDEF OS2}
  DosCreateEventSem(c,FHandle,0,InitialState);
  {$ENDIF}
  {$IFDEF WIN32}
  FHandle:=CreateEvent(Nil,ManualReset,InitialState,@c);
  {$ENDIF}
End;

Destructor TEvent.Destroy;
Begin
  {$IFDEF OS2}
  If FHandle<>0 Then DosCloseEventSem(FHandle);
  {$ENDIF}
  {$IFDEF WIN32}
  If FHandle<>0 Then CloseHandle(FHandle);
  {$ENDIF}
  Inherited Destroy;
End;

Function TEvent.WaitFor(Timeout: Longint): TWaitResult;

{$IFDEF OS2}
Var Err:LongInt;
{$ENDIF}

Begin
  {$IFDEF OS2}
  Err:= DosWaitEventSem(Handle, Timeout);
  Case Err of
    ERROR_INTERRUPT: Result := wrAbandoned;
    0: Result := wrSignaled;
    ERROR_TIMEOUT: Result := wrTimeout;
    Else
    Begin
       Result := wrError;
       FLastError := Err;
    End;
  End;
  {$ENDIF}
  {$IFDEF WIN32}
  Case WaitForSingleObject(Handle,Timeout) Of
    WAIT_ABANDONED: Result := wrAbandoned;
    WAIT_OBJECT_0: Result := wrSignaled;
    WAIT_TIMEOUT: Result := wrTimeout;
    Else
    Begin
        Result := wrError;
        FLastError := GetLastError;
    End;
  End;
  {$ENDIF}
End;

Procedure TEvent.SetEvent;
Begin
  {$IFDEF OS2}
  DosPostEventSem(Handle);
  {$ENDIF}
  {$IFDEF WIN32}
  WinBase.SetEvent(FHandle);
  {$ENDIF}
End;

Procedure TEvent.ResetEvent;

{$IFDEF OS2}
Var PostCount:LongWord;
{$ENDIF}

Begin
  {$IFDEF OS2}
  DosResetEventSem(Handle,PostCount);
  {$ENDIF}
  {$IFDEF WIN32}
  WinBase.ResetEvent(FHandle);
  {$ENDIF}
End;

Constructor TSimpleEvent.Create;
Begin
  {$IFDEF OS2}
  FHandle := DosCreateEventSem(Nil,FHandle,0,False);
  {$ENDIF}
  {$IFDEF WIN32}
  FHandle:=CreateEvent(Nil,True,False,Nil);
  {$ENDIF}
End;

Constructor TCriticalSection.Create;
Begin
     Inherited Create;

     {$IFDEF WIN32}
     InitializeCriticalSection(FSection);
     {$ENDIF}
End;

Procedure TCriticalSection.Acquire;
Begin
  {$IFDEF OS2}
  DosEnterCritSec;
  {$ENDIF}
  {$IFDEF WIN32}
  EnterCriticalSection(FSection);
  {$ENDIF}
End;

Procedure TCriticalSection.Release;
Begin
  {$IFDEF OS2}
  DosExitCritSec;
  {$ENDIF}
  {$IFDEF WIN32}
  LeaveCriticalSection(FSection);
  {$ENDIF}
End;

Destructor TCriticalSection.Destroy;
Begin
     {$IFDEF WIN32}
     DeleteCriticalSection(FSection);
     {$ENDIF}
     Inherited Destroy;
End;

Procedure TCriticalSection.Enter;
Begin
  Acquire;
End;

Procedure TCriticalSection.Leave;
Begin
  Release;
End;


Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Aug-05  WD        Variablen die nicht verwendet werden entfernt.
}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT SerialIO;

INTERFACE

{**************************************************************************
 *                                                                        *
 * Written for Speed Pascal/2 & Sibyl V2.0                                *
 * Interface to Async communications under OS/2                           *
 * Author:      Alex T. Vermeulen (a.vermeulen@ecn.nl;atverm@zap.a2000.nl)*
 * Date:        17-4-95                                                   *
 * Update:      1-12-98                                                   *
 **************************************************************************}

{$ifdef win32}
Won't work in Windows!
{$endif}

TYPE
  parityt = (par_none,par_odd,par_even,par_mark,par_space);

FUNCTION initport (port_num:integer;
                   parity:parityt;
                   databits,stopbits:byte;
                   RTS_CTS,XON_XOFF:BOOLEAN):INTEGER;
{ This function initializes the com buffer and com parameters, 
  returns 0 ik ok else an error number}

PROCEDURE closeport;
{ This function closes the com port,etc. }

PROCEDURE outcomch (ch: char);
{ This function outputs one character to the com port }

PROCEDURE set_baud (baud:longint);
{ This function sets the com speed to that passed }

PROCEDURE setdtr(i:boolean);
{ This function sets the DTR pin to the status given }

PROCEDURE setrts(i:boolean);
{ This function sets the RTS pin to the status given }

FUNCTION carrierdetect:boolean;
{ This returns the status of the carrier detect lead from the modem }

Function DataAvailable : Boolean;

function nravailable:longint;

function readall(var buffer;max:longint):longint;

procedure flushin;

FUNCTION readchar(var ch:char):boolean;

IMPLEMENTATION

USES { crt, }
     bsedev,bsedos,os2def;

CONST
  BAUD_RATE : WORD =9600;
  COMM_BUFFER_SIZE =16384;

VAR
  PortHandle   : HFILE;                               { OS/2 file handle for COM port }

type
   BuffRec = Record     { For storing TX or RX buffer records }
     BytesIn,           { Number of bytes in buffer }
     FullSize : Word;   { Size of the buffer }
    End; { BuffRec }

Function DataAvailable : Boolean;
Var
  BufferRec : BuffRec;
  RetLength : Ulong;
Begin  { DataAvailable }
  DosDevIOCtl(PortHandle,ioctl_Async,async_GetInQueCount,NIL,0,RetLength,BufferRec,
              SizeOf(BufferRec),RetLength);
  DataAvailable := BufferRec.BytesIn > 0;
End;  { DataAvailable }

Function NrAvailable;
Var
  BufferRec : BuffRec;
  RetLength : ULong;
Begin  { DataAvailable }
  DosDevIOCtl(PortHandle,ioctl_Async,async_GetInQueCount,NIL,0,
               RetLength,Bufferrec,SizeOf(BufferRec),RetLength);
  NrAvailable := BufferRec.BytesIn;
End;  { DataAvailable }

function readall(var buffer;max:longint):longint;
Var
  BufferRec : BuffRec;
  RetLength : ULONG;
  BytesRead : ULONG;                { num. bytes read from last DosRead() call }
  res       : APIRET;
Begin  { DataAvailable }
  DosDevIOCtl (PortHandle,ioctl_Async,async_GetInQueCount,NIL,0,
               RetLength,BufferRec,SizeOf(BufferRec),RetLength);
  if bufferrec.bytesin>max then
    res:=DosRead(PortHandle, buffer, max, BytesRead)
  else
    res:=DosRead(PortHandle, buffer, bufferrec.bytesin, BytesRead);
  readall := BytesRead;
end;

procedure flushin;
Var
  BufferRec : BuffRec;
  RetLength : ULONG;
  res       : APIRET;
  ch        : array [1..8192] of byte;
  BytesRead : ULONG;                { num. bytes read from last DosRead() call }
begin
  DosDevIOCtl(PortHandle,ioctl_Async,async_GetInQueCount,NIL,0,RetLength,BufferRec,
              SizeOf(BufferRec),RetLength);
  res:=DosRead(PortHandle, ch, BufferRec.BytesIn, BytesRead);
end;

Function readchar(var ch:char):boolean;
VAR BytesRead : ULONG;                { num. bytes read from last DosRead() call }
    res       : APIRET;
BEGIN
  res:=DosRead(PortHandle, ch, 1, BytesRead);
  readchar:=bytesread<>0;
END;

{ This function outputs one character to the com port }
PROCEDURE outcomch (ch: char);

VAR

  rc : APIRET;
  BytesWritten : ULONG;                { unless but required parameter }
BEGIN
  rc:=DosWrite (PortHandle, ch, 1, BytesWritten);
END;


const
  ASYNC_EXTSETBAUDRATE = $43;

{ This function sets the com speed to that passed }
PROCEDURE set_baud (baud:longint);
var
  par : RECORD
          rate     : ULONG;
          fraction : UCHAR;
        END;

  res : APIRET;
begin
  {
   * OS/2 2.11+ standard COM drivers support up to 345600 bps !
   }
  par.rate:=baud;
  par.fraction:=0;
  if ((par.rate <= 345600) and (par.rate >= 10)) then
    res:=DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_EXTSETBAUDRATE,
                      par, sizeof (par), NIL, NIL, 0, NIL);
end;


{ This function sets the DTR pin to the status given }

PROCEDURE setdtr(i:boolean);
var
  ms   : MODEMSTATUS;
  data : UINT;
  res  : APIRET;
begin
  ms.fbModemOn:=0;ms.fbModemOff:=0;

  if i then ms.fbModemOn := DTR_ON
  else ms.fbModemOff := DTR_OFF;

  res:=DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETMODEMCTRL, ms,
                    sizeof (ms), NIL, data, sizeof (data), NIL);
end;


{ This function sets the RTS pin to the status given }

PROCEDURE setrts(i:boolean);
var
  ms    : MODEMSTATUS;
  data  : UINT;
  res   : APIRET;
begin
  ms.fbModemOn:=0;ms.fbModemOff:=0;
  if i then ms.fbModemOn := RTS_ON
  else ms.fbModemOff := RTS_OFF;

  res:=DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETMODEMCTRL, ms,
                    sizeof (ms), NIL, data, sizeof (data), NIL);
end;

{ This function initializes the com buffer, setting up the interrupt,
 * and com parameters }

FUNCTION initport (port_num:integer;
                   parity:parityt;
                   databits,stopbits:byte;
                   RTS_CTS,XON_XOFF:BOOLEAN):integer;
var action        : ULONG;
    lctl          : LINECONTROL;
    dcb           : DCBINFO;
    portname      : Cstring;

begin
  { open com port }
  initport:=0;

  portname:= 'COM'+CHR(port_num + ORD('0'));

  if DosOpen (portname, PortHandle, action, 0, 0, 1, $42, NIL)<>0 then
  begin
    initport:=1;
    Exit;
  end;

  { set line }
  lctl.bParity := ord(parity);
  lctl.bDataBits := databits;
  if stopbits=1 then lctl.bStopBits := 0 else lctl.bStopBits:=2;
  lctl.fTransBreak := 0;
  if DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETLINECTRL,
                  lctl, sizeof (LINECONTROL), NIL, NIL, 0, NIL)<>0 then
  begin
    DosClose (PortHandle);
    initport:=2;
    exit;
  end;

  { set device control block info }
  dcb.usWriteTimeout := 0;
  dcb.usReadTimeout := 0;
  dcb.fbCtlHndShake := MODE_DTR_CONTROL;

  IF RTS_CTS THEN
  BEGIN
    dcb.fbFlowReplace := MODE_RTS_HANDSHAKE;
    dcb.fbCtlHndShake := dcb.fbCtlHndShake + MODE_CTS_HANDSHAKE;
  END
  ELSE dcb.fbFlowReplace := MODE_RTS_CONTROL;

  IF XON_XOFF THEN
    dcb.fbFlowReplace := dcb.fbFlowReplace + MODE_AUTO_RECEIVE + MODE_AUTO_TRANSMIT;

  dcb.fbTimeout := MODE_NO_WRITE_TIMEOUT + MODE_WAIT_READ_TIMEOUT;
  dcb.bErrorReplacementChar := 0;
  dcb.bBreakReplacementChar := 0;
  dcb.bXONChar := $11;
  dcb.bXOFFChar := $13;
  if DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETDCBINFO, dcb,
                  sizeof (DCBINFO), NIL, NIL, 0, NIL)<>0 then
  begin
    initport:=3;
    DosClose (PortHandle);
    exit;
  end;

  { indicate receive buffer is currently empty }

  setdtr(true);
end;

{ This function closes out the com port, removing the interrupt routine,
  etc. }

PROCEDURE closeport;
begin
  { close COM port handle }
  DosClose (PortHandle);
end;


{ This returns the status of the carrier detect lead from the modem }
FUNCTION carrierdetect:boolean;
var
  instat : BYTE;
begin
  { if DosDevIOCtl() returns an error, return 0 }
  if DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_GETMODEMINPUT,
                   NIL, 0, NIL, instat, sizeof (instat), NIL)<>0 then
  begin
    carrierdetect:=false;
    exit;
  end;

  { otherwise return carrier detect status }
  carrierdetect:=(instat and DCD_ON)<>0;
end;


end.



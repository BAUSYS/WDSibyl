UNIT uPorts;

{ Original Komponente Serial.pas / tSerialPort von Hr. Willem Clements.
  Die Copyright-Informationen befinden sich im Copyright-Verzeichnis }

INTERFACE

Uses SysUtils, Classes, Forms,
     uSysClass;

{$IFDEF OS2}
Uses BseDos,BseDev,Os2Def;
{$ELSE}
Uses WinNt,WinDef,WinBase,WinUser;
{$ENDIF}

TYPE
   TCommPort      = (cpCOM1, cpCOM2, cpCOM3, cpCOM4,cpCOM5, cpCOM6, cpCOM7, cpCOM8);
   TBaudRate      = (br110, br300, br600, br1200,
                     br2400, br4800, br9600, br14400,
                     br19200, br38400, br56000,
                     br128000, br256000);
   TParityType    = (pcNone, pcOdd, pcEven,pcMark, pcSpace);
   TStopBits      = (sbOne, sbOnePtFive, sbTwo);
   TDataBits      = (db4, db5, db6, db7, db8);
   TFlowControl   = (fcNone, fcXON_XOFF,fcRTS_CTS, fsDSR_DTR);
   TDataType      = (dtChars,dtString);
CONST
   dflt_CommPort               = cpCOM2;
   dflt_BaudRate               = br9600;
   dflt_ParityType             = pcNone;
   dflt_ParityCheck            = False;
   dflt_ParityErrorChar        = 0;
   dflt_ParityErrorReplacement = False;
   dflt_StopBits               = sbOne;
   dflt_DataBits               = db8;
   dflt_XONChar                = $11;
   dflt_XOFFChar               = $13;
   dflt_XONLim                 = 1024;
   dflt_XOFFLim                = 2048;
   dflt_ErrorChar              = 0;
   dflt_FlowControl            = fcNone;
   dflt_StripNullChars         = False;
   dflt_EOFChar                = 0;
   dflt_DataType               = dtString;
   dflt_PollTime               = 1000;

{$IFDEF OS2}
CONST
   ComFlags             = OPEN_ACCESS_READWRITE +
                          OPEN_SHARE_DENYREADWRITE +
                          OPEN_FLAGS_FAIL_ON_ERROR; 

   dcb_DTR_ChangeAtOpenClose  = $01;
   dcb_DTR_AsHandShake        = $02;
   dcb_CTS_Ignore             = $08;
   dcb_DSR_IsHandShake        = $10;
   dcb_DCD_NeedForTransmit    = $20;
   dcb_DSR_NeedForReceive     = $40;
   dcb_XonXoff_Transmit       = $01;
   dcb_XonXOff_Receive        = $02;
   dcb_EnableErrReplacement   = $04;
   dcb_NullStripping          = $08;
   dcb_EnableBreakReplacement = $10;
   dcb_FullDuplex             = $20;
TYPE
   Handle = HFile;
{$ENDIF}

TYPE
  TSerialPort=CLASS(TComponent)
  PRIVATE
    hCommPort               : Handle;
    fCommPort               : TCommPort;
    fBaudRate               : TBaudRate;
    fParityType             : TParityType;
    fParityCheck            : BOOLEAN;
    fParityErrorChar        : BYTE;
    fParityErrorReplacement : BOOLEAN;
    fStopBits               : TStopBits;
    fDataBits               : TDataBits;
    fXONChar                : BYTE;
    fXOFFChar               : BYTE;
    fXONLim                 : word;
    fXOFFLim                : word;
    fErrorChar              : BYTE;
    fFlowControl            : TFlowControl;
    fStripNullChars         : BOOLEAN;
    fEOFChar                : BYTE;
    fTimer                  : TTimer;
    fCurrString             : STRING;
    fInTimer                : BOOLEAN;
    fOnStringRead           : TNotifyEvent;
    fOnCharsRead            : TNotifyEvent;
    fDataType               : TDataType;
{$IFDEF Win32}
    fDTRState               : BOOLEAN;
    fRTSState               : BOOLEAN;
{$ENDIF}
    PROCEDURE Timer (Sender: TObject);
    PROCEDURE SetCommPort(value : TCommPort);
    PROCEDURE SetBaudRate(value : TBaudRate);
    PROCEDURE SetParityType(value : TParityType);
    PROCEDURE SetParityCheck(value : BOOLEAN);
    PROCEDURE SetParityErrorChar(value : BYTE);
    PROCEDURE SetParityErrorReplacement(value : BOOLEAN);
    PROCEDURE SetStopBits(value : TStopBits);
    PROCEDURE SetDataBits(value : TDataBits);
    PROCEDURE SetXONChar(value : BYTE);
    PROCEDURE SetXOFFChar(value : BYTE);
    PROCEDURE SetXONLim(value : word);
    PROCEDURE SetXOFFLim(value : word);
    PROCEDURE SetErrorChar(value : BYTE);
    PROCEDURE SetFlowControl(value : TFlowControl);
    PROCEDURE SetStripNullChars(value : BOOLEAN);
    PROCEDURE SetEOFChar(value : BYTE);
    PROCEDURE Initialize_DCB;
    PROCEDURE SetDtr(value:BOOLEAN);
    FUNCTION  GetDtr:BOOLEAN;
    PROCEDURE SetRTS(value:BOOLEAN);
    FUNCTION  GetRTS:BOOLEAN;
    FUNCTION  GetCTS:BOOLEAN;
    FUNCTION  GetDSR:BOOLEAN;
    FUNCTION  GetRI:BOOLEAN;
    FUNCTION  GetDCD:BOOLEAN;
    PROCEDURE GetModemOutput (P: POINTER);
    PROCEDURE SetModemOutput (P: POINTER);
    PROCEDURE GetModemInput (P: POINTER);
    PROCEDURE SetPollTime (value: LongInt);
    FUNCTION  GetPollTime: LongInt;
  PUBLIC
    CONSTRUCTOR Create(AOwner : TComponent); OVERRIDE;
    FUNCTION    OpenPort : BOOLEAN;
    FUNCTION    ClosePort : BOOLEAN;
    PROCEDURE   SendData(data : POINTER; size : LongWord);
    PROCEDURE   GetData(data : POINTER; VAR size : LongWord);
    FUNCTION    BytesInQue : LongWord;
    FUNCTION    PortIsOpen : BOOLEAN;
    FUNCTION    ReadString : STRING;
    PROCEDURE   FlushTX;
    PROCEDURE   FlushRX;
    DESTRUCTOR  Destroy; OVERRIDE;
    PROPERTY DTR                    : BOOLEAN        read GetDTR
                                                     write SetDTR;
    PROPERTY RTS                    : BOOLEAN        read GetRTS
                                                     write SetRTS;
    PROPERTY CTS                    : BOOLEAN        read GetCTS;
    PROPERTY DSR                    : BOOLEAN        read GetDSR;
    PROPERTY RI                     : BOOLEAN        read GetRI;
    PROPERTY DCD                    : BOOLEAN        read GetDCD;
  PUBLISHED
    PROPERTY CommPort               : TCommport      read fCommPort
                                                     write SetCommPort;
    PROPERTY BaudRate               : TBaudRate      read fBaudRate
                                                     write SetBaudRate;
    PROPERTY ParityType             : TParityType    read fParityType
                                                     write SetParityType;
    PROPERTY ParityErrorChecking    : BOOLEAN        read fParityCheck
                                                     write SetParityCheck;
    PROPERTY ParityErrorChar        : BYTE           read fParityErrorChar
                                                     write SetParityErrorChar;
    PROPERTY ParityErrorReplacement : BOOLEAN        read fParityErrorReplacement
                                                     write SetParityErrorReplacement;
    PROPERTY StopBits               : TStopBits      read fStopBits
                                                     write SetStopBits;
    PROPERTY DataBits               : TDataBits      read fDataBits
                                                     write SetDataBits;
    PROPERTY XONChar                : BYTE           read fXONChar
                                                     write SetXONChar;
    PROPERTY XOFFChar               : BYTE           read fXOFFChar
                                                     write SetXOFFChar;
    PROPERTY XONLim                 : word           read fXONLim
                                                     write SetXONLim;
    PROPERTY XOFFLim                : word           read fXOFFLim
                                                     write SetXOFFLim;
    PROPERTY ErrorChar              : BYTE           read fErrorChar
                                                     write SetErrorChar;
    PROPERTY FlowControl            : TFlowControl   read fFlowControl
                                                     write SetFlowControl;
    PROPERTY StripNullChars         : BOOLEAN        read  fStripNullChars
                                                     write SetStripNullChars;
    PROPERTY EOFChar                : BYTE           read fEOFChar
                                                     write SetEOFChar;
    PROPERTY PollTime               : LongInt        read  GetPollTime
                                                     write SetPollTime;
    PROPERTY DataType               : TDataType      read fDataType
                                                     write fDataType;
    PROPERTY OnStringRead           : TNotifyEvent   read fOnStringRead
                                                     write fOnStringRead;
    PROPERTY OnCharsRead            : TNotifyEvent   read fOnCharsRead
                                                     write fOnCharsRead;

  END;

{ ----------------------------------------------------------------------------------- }

type tJoyPosEvent = procedure (iSender: TObject; iJoystickNr : LongWord; iPos : tPoint) of object;
     tJoyDigEvent = procedure (iSender: TObject; iJoystickNr : LongWord; iDig : trDigJoystick) of object;
     tJoyButtonEvent = procedure (iSender: TObject; iJoystickNr : LongWord; iButtonNr : LongWord) of object;

Type
  tJoystickPort=Class(TComponent)
  Private
    fJoystick  : tcJoystick;
    fTimer     : tTimer;
    fInterval  : LongInt;
    fOldStatus : trJoystickStatus;
    fOldDig    : Array[1..cMaxJoystick] of trDigJoystick;

    fOnJoyPosEvent   : tJoyPosEvent;
    fOnJoyButtonEvent: tJoyButtonEvent;
    fOnJoyDigEvent   : tJoyDigEvent;

    Procedure SetInterval(Value:LongInt);
    Procedure EvTimer(Sender:TObject);
  Protected
    Procedure SetupComponent; Override;
  Public
    Destructor Destroy; Override;

    Procedure Start;
    Procedure Stop;

  Published
    Property Interval  : LongInt  Read fInterval Write SetInterval;

    Property OnJoyPosEvent   : tJoyPosEvent Read fOnJoyPosEvent Write fOnJoyPosEvent;
    Property OnJoyButtonEvent: tJoyButtonEvent Read fOnJoyButtonEvent Write fOnJoyButtonEvent;
    Property OnJoyDigEvent   : tJoyDigEvent Read fOnJoyDigEvent Write fOnJoyDigEvent;
  End;


{ ----------------------------------------------------------------------------------- }

IMPLEMENTATION


{$IFDEF OS2}
TYPE
   TDCB          = DCBINFO;
   TBaud         = WORD;
   TComError     = WORD;
   TLineCtrl     = RECORD
      DataBits   : BYTE;
      Parity     : BYTE;
      StopBits   : BYTE;
      TransBreak : BYTE;
      END;
   TFixedBaud    = RECORD
      Baud       : ULong;
      Fraction   : BYTE;
      END;
   TQueueCount = RECORD
      Count    : WORD;
      Size     : WORD;
      END;
   TModemCtrl = RECORD
      MaskOn   : BYTE;
      MaskOff  : BYTE;
      END;
   TMdmIn      = BYTE;
{$ENDIF}

CONSTRUCTOR TSerialPort.Create(AOwner : TComponent);
BEGIN
   INHERITED Create(AOwner);
   hCommPort       := INVALID_HANDLE_VALUE;
   fCommPort       := dflt_CommPort;
   fBaudRate       := dflt_BaudRate;
   fParityCheck    := dflt_ParityCheck;
   fStopBits       := dflt_StopBits;
   fDataBits       := dflt_DataBits;
   fXONChar        := dflt_XONChar;
   fXOFFChar       := dflt_XOFFChar;
   fXONLim         := dflt_XONLim;
   fXOFFLim        := dflt_XOFFLim;
   fErrorChar      := dflt_ErrorChar;
   fFlowControl    := dflt_FlowControl;
{$IFDEF Win32}
   fDTRState       := TRUE;
   fRTSState       := TRUE;
{$ENDIF}
   FCurrString     := '';
   fTimer          := fTimer.Create (Self);
   fTimer.OnTimer  := Self.Timer;
   fTimer.Interval := dflt_PollTime;
   fInTimer        := FALSE;
   fOnCharsRead    := NIL;
   fOnStringRead   := NIL;
   fDataType       := dflt_DataType;
END;

DESTRUCTOR TSerialPort.Destroy;
BEGIN
   WITH fTimer DO
      IF Running THEN
         Stop;
   fTimer.Destroy;
   ClosePort;
   INHERITED Destroy;
END;

PROCEDURE TSerialPort.Timer;
VAR
  Ch   : CHAR;
  Size : LongWord;
BEGIN
   IF fInTimer THEN
      exit;
   finTimer := TRUE;
   IF BytesInQue <> 0 THEN BEGIN
      IF fDataType = dtString THEN BEGIN
         WHILE BytesInQue <> 0 DO BEGIN
            Size := 1;
            GetData (@Ch,Size);
            IF Ch IN [#10,#13] THEN BEGIN
               IF Length (fCurrString) <> 0 THEN BEGIN
                  IF Assigned (fOnStringRead) THEN
                     fOnStringRead (Self);
                  END;
               fCurrString := '';
               END
          ELSE fCurrString := fCurrString + Ch;
            END
         END
    ELSE IF Assigned (fOnCharsRead) THEN
            fOnCharsRead (Self);
      END;
   fInTimer := FALSE;
END;

FUNCTION TSerialPort.ReadString: STRING;
BEGIN
   IF fDataType = dtString THEN
      Result := fCurrString
 ELSE Result := '';
END;

FUNCTION TSerialPort.PortIsOpen : BOOLEAN;
BEGIN
   Result := hCommPort <> INVALID_HANDLE_VALUE;
END;

FUNCTION TSerialPort.OpenPort: BOOLEAN;
VAR MyPort : CSTRING [25];

{$IFDEF OS2}
    Action : LongWord;
{$ENDIF}

BEGIN
   MyPort :=  'COM' + ToStr(Succ (ord(fCommPort)));
   ClosePort;
{$IFDEF Win32}
   hCommPort := CreateFile(MyPort,
                GENERIC_READ OR GENERIC_WRITE,
                0,
                nil,
                OPEN_EXISTING,
                0,0);
{$ENDIF}
{$IFDEF OS2}
   IF DosOpen (MyPort,hCommPort,Action,0,0,FILE_OPEN,COmFlags,NIL) > 0 THEN
      hCommPort := INVALID_HANDLE_VALUE;
{$ENDIF}
   Initialize_DCB;
   result := hCommPort <> INVALID_HANDLE_VALUE;
   IF Result THEN
      fTimer.Start;
END;

FUNCTION TSerialPort.ClosePort : BOOLEAN;
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN
      exit;
   fTimer.Stop;
   FlushTX;
   FlushRX;
{$IFDEF Win32}
   result := CloseHandle(hCommPort);
{$ELSE}
   DosClose (hCommPort);
   Result := TRUE;
{$ENDIF}
   hCommPort := INVALID_HANDLE_VALUE;
END;

PROCEDURE TSerialPort.FlushRx;
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN
      exit;
{$IFDEF Win32}
   PurgeComm(hCommPort,PURGE_RXABORT or PURGE_RXCLEAR);
{$ENDIF}
END;

PROCEDURE TSerialPort.FlushTx;
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN
     exit;
{$IFDEF Win32}
   PurgeComm(hCommPort,PURGE_TXABORT or PURGE_TXCLEAR);
{$ENDIF}
END;

PROCEDURE TSerialPort.Initialize_DCB;
VAR
   MyDCB : TDCB;
{$IFDEF OS2}
   BaudRate : TFixedBaud;
   LineCtrl : TLineCtrl;
{$ENDIF}
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN
      exit;
{$IFDEF Win32}
   GetCommState(hCommPort, MyDCB);
   CASE fBaudRate OF
      br110    : MyDCB.BaudRate := 110;
      br300    : MyDCB.BaudRate := 300;
      br600    : MyDCB.BaudRate := 600;
      br1200   : MyDCB.BaudRate := 1200;
      br2400   : MyDCB.BaudRate := 2400;
      br4800   : MyDCB.BaudRate := 4800;
      br9600   : MyDCB.BaudRate := 9600;
      br14400  : MyDCB.BaudRate := 14400;
      br19200  : MyDCB.BaudRate := 19200;
      br38400  : MyDCB.BaudRate := 38400;
      br56000  : MyDCB.BaudRate := 56000;
      br128000 : MyDCB.BaudRate := 128000;
      br256000 : MyDCB.BaudRate := 256000;
      END;
   CASE fParityType OF
      pcNone  : MyDCB.Parity := NOPARITY;
      pcEven  : MyDCB.Parity := EVENPARITY;
      pcOdd   : MyDCB.Parity := ODDPARITY;
      pcMark  : MyDCB.Parity := MARKPARITY;
      pcSpace : MyDCB.Parity := SPACEPARITY;
      END;
   IF fParityCheck THEN
       Inc(MyDCB.Flags, $0002);
   IF fParityErrorReplacement THEN
       Inc(MyDCB.Flags, $0021);
   MyDCB.ErrorChar := char(fErrorChar);
   CASE fStopBits OF
      sbOne       : MyDCB.StopBits := ONESTOPBIT;
      sbOnePtFive : MyDCB.StopBits := ONE5STOPBITS;
      sbTwo       : MyDCB.StopBits := TWOSTOPBITS;
      END;
   CASE fDataBits OF
      db4 : MyDCB.BYTESize := 4;
      db5 : MyDCB.BYTESize := 5;
      db6 : MyDCB.BYTESize := 6;
      db7 : MyDCB.BYTESize := 7;
      db8 : MyDCB.BYTESize := 8;
      END;
   CASE fFlowControl OF
      fcXON_XOFF : MyDCB.Flags := MyDCB.Flags or $0020 or $0018;
      fcRTS_CTS  : MyDCB.Flags := MyDCB.Flags or $0004 or $0024*RTS_CONTROL_HANDSHAKE;
      fsDSR_DTR  : MyDCB.Flags := MyDCB.Flags or $0008 or $0010*DTR_CONTROL_HANDSHAKE;
      END;
   IF fStripNullChars THEN
      Inc(MyDCB.Flags,$0022);
   MyDCB.XONChar  := Char(fXONChar);
   MyDCB.XOFFChar := Char(fXONChar);
   MyDCB.XONLim   := fXONLim;
   MyDCB.XOFFLim  := fXOFFLim;
   IF fEOFChar <> 0 THEN
      MyDCB.EOFChar := char(EOFChar);
   SetCommState(hCommPort, MyDCB);
   SetDtr (fDTRState);
   SetRts (fRTSState);
{$ELSE}
   WITH BaudRate DO
      case fBaudRate of
         br110    : Baud := 110;
         br300    : Baud := 300;
         br600    : Baud := 600;
         br1200   : Baud := 1200;
         br2400   : Baud := 2400;
         br4800   : Baud := 4800;
         br9600   : Baud := 9600;
         br14400  : Baud := 14400;
         br19200  : Baud := 19200;
         br38400  : Baud := 38400;
         br56000  : Baud := 56000;
         br128000 : Baud := 128000;
         br256000 : Baud := 256000;
         END;
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,$43,BaudRate,SizeOf (TBaud),NIL,NIL,0,NIL);
   WITH LineCtrl DO BEGIN
      Parity     := Ord (fParityType);
      DataBits   := Ord (fDataBits) + 4;
      StopBits   := Ord (fStopBits);
      TransBreak := 1;
      END;
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,ASYNC_SETLINECTRL,LineCtrl,SizeOf (TLineCtrl),NIL,NIL,0,NIL);
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,ASYNC_GETDCBINFO,NIL,0,NIL,MyDCB,SizeOf (TDCB),NIL);
   WITH MyDCB DO BEGIN
      IF fFlowControl = fsDSR_DTR THEN BEGIN
         fbFlowReplace:=fbFlowReplace OR dcb_DTR_AsHandShake;
         fbFlowReplace:=fbFlowReplace AND (NOT dcb_DTR_ChangeAtOpenClose);
         END
    ELSE BEGIN
         fbFlowReplace:=fbFlowReplace OR dcb_DTR_ChangeAtOpenClose;
         fbFlowReplace:=fbFlowReplace AND (NOT dcb_DTR_AsHandShake);
         END;
      IF fStripNullChars THEN
         fbFlowReplace:=fbFlowReplace OR dcb_EnableBreakReplacement
    ELSE fbFlowReplace:=fbFlowReplace AND (NOT dcb_EnableBreakReplacement);
      IF fParityErrorReplacement THEN BEGIN
         fbFlowReplace:=fbFlowReplace OR dcb_EnableErrReplacement;
         bErrorReplacementChar := fParityErrorChar;
         END
    ELSE fbFlowReplace:=fbFlowReplace AND (NOT dcb_EnableErrReplacement);
      bXONChar:= fXOnChar;
      bXOFFChar:=fXOffChar;
      END;
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,ASYNC_SETDCBINFO,MyDCB,SizeOf (TDCB),NIL,NIL,0,NIL);
{$ENDIF}
END;

PROCEDURE TSerialPort.SendData (data : Pointer; size : LongWord);

VAR
   NumBytesWritten : LongWord;
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN
      exit;
{$IFDEF Win32}
   WriteFile(hCommPort,
            Data^,
            Size,
            NumBytesWritten,
            nil);
{$ELSE}
   DosWrite (hCommPort,data^,size,NumBytesWritten);
{$ENDIF}
END;

FUNCTION TSerialPort.BYTEsInQue: LongWord;
VAR
{$IFDEF Win32}
   oStatus     : TComStat;
   dwErrorCode : LongWord;
{$ELSE}
   QueueCount : TQueueCOunt;
{$ENDIF}
BEGIN
{$IFDEF Win32}
   ClearCommError(hCommPort, dwErrorCode, oStatus);
   Result := oStatus.cbInQue;
{$ELSE}
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,ASYNC_GETINQUECOUNT,NIL,0,NIL,QueueCount,SizeOf (TQueueCount),NIL);
   Result := QueueCount.Count;
{$ENDIF}
END;

PROCEDURE TSerialPort.GetData (data : POINTER; VAR size : LongWord);
VAR
   NumBytesRead : LongWord;
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN
      exit;
   NumBytesRead := 0;
{$IFDEF Win32}
   IF size > 0 THEN
      ReadFile(hCommPort,Data^,size,NumBYTEsRead,nil);
{$ELSE}
   DosRead (hCommPort,data^,size,NumBYTEsRead);
{$ENDIF}
   size := NumBYTEsRead;
END;

PROCEDURE TSerialport.SetCommPort(value : TCommPort);
BEGIN
   fCommPort := value;
   IF PortIsOpen THEN BEGIN
      ClosePort;
      OpenPort;
      END
 ELSE Initialize_DCB;

END;

PROCEDURE TSerialport.SetBaudRate(value : TBaudRate);
BEGIN
   fBaudRate := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetParityType(value : TParityType);
BEGIN
   fParityType := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetParityCheck(value : BOOLEAN);
BEGIN
   fParityCheck := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetParityErrorChar(value : BYTE);
BEGIN
   fParityErrorChar := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetParityErrorReplacement(value : BOOLEAN);
BEGIN
   fParityErrorReplacement := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetStopBits(value : TStopBits);
BEGIN
   fStopBits := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetDataBits(value : TDataBits);
BEGIN
   fDataBits := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetXONChar(value : BYTE);
BEGIN
   fXONChar := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetXOFFChar(value : BYTE);
BEGIN
   fXOFFChar := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetXONLim(value : word);
BEGIN
   fXONLim := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetXOFFLim(value : word);
BEGIN
   fXOFFLim := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetErrorChar(value : BYTE);
BEGIN
   fErrorChar := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetFlowControl(value : TFlowControl);
BEGIN
   fFlowControl := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetStripNullChars(value : BOOLEAN);
BEGIN
   fStripNullChars := value;
   Initialize_DCB;
END;

PROCEDURE TSerialport.SetEOFChar(value : BYTE);
BEGIN
   fEOFChar := value;
   Initialize_DCB;
END;

PROCEDURE TSerialPort.SetDTR (value: BOOLEAN);
VAR
{$IFDEF OS2}
   MCtrl : TModemCtrl;
{$ELSE}
   MCtrl : ULong;
{$ENDIF}
BEGIN
{$IFDEF OS2}
   WITH MCtrl DO BEGIN
      MaskOn  := 0;
      MaskOff := $FF;
      IF value THEN
         MaskOn := $01
    ELSE MaskOff := $FE;
      END;

{$ELSE}
   IF value THEN
      MCtrl := WinBase.SetDtr
 ELSE MCtrl := WinBase.ClrDtr;
   fDTRState := value;
{$ENDIF}
   SetModemOutput (@MCtrl);
END;

FUNCTION  TSerialPort.GetDTR: BOOLEAN;
{$IFDEF OS2}
VAR
   MCtrl : TModemCtrl;
{$ELSE}
{$ENDIF}
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN BEGIN
      Result := FALSE;
      Exit;
      END;
{$IFDEF OS2}
   GetModemOutput (@MCtrl);
   WITH MCtrl DO
      Result := MaskOn AND $01 <> 0;
{$ELSE}
   result := fDTRState;
{$ENDIF}
END;

PROCEDURE TSerialPort.SetRTS (value: BOOLEAN);
VAR
{$IFDEF OS2}
   MCtrl : TModemCtrl;
{$ELSE}
   MCtrl : ULong;
{$ENDIF}
BEGIN
{$IFDEF OS2}
   WITH MCtrl DO BEGIN
      MaskOn  := 0;
      MaskOff := $FF;
      IF value THEN
         MaskOn := $02
    ELSE MaskOff := $FD;
      END;
{$ELSE}
   IF value THEN
      MCtrl := WinBase.SetRts
 ELSE MCtrl := WinBase.ClrRts;
   fRTSState := value;
{$ENDIF}
   SetModemOutput (@MCtrl);
END;

FUNCTION  TSerialPort.GetRTS: BOOLEAN;
{$IFDEF OS2}
VAR
   MCtrl : TModemCtrl;
{$ELSE}
{$ENDIF}
BEGIN
{$IFDEF OS2}
   IF hCommPort = INVALID_HANDLE_VALUE THEN BEGIN
      Result := False;
      Exit;
      END;
   GetModemOutput (@MCtrl);
   WITH MCtrl DO
      Result := MaskOn AND $02 <> 0;
{$ELSE}
   Result := fRTSState;
{$ENDIF}
END;

FUNCTION  TSerialPort.GetCTS: BOOLEAN;
VAR
{$IFDEF OS2}
   MdmIn : TMdmIn;
{$ELSE}
   MdmIn : ULong;
{$ENDIF}
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN BEGIN
      Result := FALSE;
      Exit;
      END;
   GetModemInput (@MdmIn);
{$IFDEF OS2}
   Result := (MdmIn AND $10) <> 0;
{$ELSE}
   Result := (MdmIn AND ms_CTS_on) <> 0;
{$ENDIF}
END;

FUNCTION  TSerialPort.GetDSR: BOOLEAN;
VAR
{$IFDEF OS2}
   MdmIn : TMdmIn;
{$ELSE}
   MdmIn : ULong;
{$ENDIF}
BEGIN
  IF hCommPort = INVALID_HANDLE_VALUE THEN BEGIN
      Result := FALSE;
      Exit;
      END;
   GetModemInput (@MdmIn);
{$IFDEF OS2}
   Result := (MdmIn AND $20) <> 0;
{$ELSE}
   Result := (MdmIn AND ms_DSR_on) <> 0;
{$ENDIF}
END;

FUNCTION  TSerialPort.GetRI: BOOLEAN;
VAR
{$IFDEF OS2}
   MdmIn : TMdmIn;
{$ELSE}
   MdmIn   : ULong;
{$ENDIF}
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN BEGIN
      Result := FALSE;
      Exit;
      END;
   GetModemInput (@MdmIn);
{$IFDEF OS2}
   Result := (MdmIn AND $40) <> 0;
{$ELSE}
   Result := (MdmIn AND ms_RING_on) <> 0
{$ENDIF}
END;


FUNCTION  TSerialPort.GetDCD: BOOLEAN;
VAR
{$IFDEF OS2}
   MdmIn : TMdmIn;
{$ELSE}
   MdmIn : ULong;
{$ENDIF}
BEGIN
   IF hCommPort = INVALID_HANDLE_VALUE THEN BEGIN
      Result := FALSE;
      Exit;
      END;
   GetModemInput (@MdmIn);
{$IFDEF OS2}
   Result := (MdmIn AND $80) <> 0;
{$ELSE}
   Result := (MdmIn AND ms_RLSD_on) <> 0;
{$ENDIF}
END;

PROCEDURE TSerialPort.GetModemOutput (P: POINTER);
BEGIN
{$IFDEF OS2}
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,$66,NIL,0,NIL,P^,SizeOf (TModemCtrl),NIL);
{$ELSE}
{$ENDIF}
END;

PROCEDURE TSerialPort.SetModemOutput (P: POINTER);
{$IFDEF OS2}
VAR
   TErr: TComError;
{$ENDIF}
BEGIN
{$IFDEF OS2}
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,$46,P^,SizeOf (TModemCtrl),NIL,TErr,SizeOf (TCOmError),NIL);
{$ELSE}
   EscapeCommFunction (hCommPort,ULong (P^));
{$ENDIF}
END;

PROCEDURE TSerialPort.GetModemInput;
BEGIN
{$IFDEF OS2}
   DosDevIOCTL (hCommPort,IOCTL_ASYNC,$67,NIL,0,NIL,P^,SizeOf (TMdmIn),NIL);
{$ELSE}
   GetCommModemStatus (hCommPort,ULong (P^));
{$ENDIF}
END;

PROCEDURE TSerialPort.SetPollTime (value: LongInt);
BEGIN
   WITH fTimer DO BEGIN
      IF Time <> value THEN BEGIN
         Time := value;
         IF Running THEN BEGIN
            Stop;
            Start;
            END;
         END;
      END;
END;

FUNCTION TSerialPort.GetPollTime: LongInt;
BEGIN
   Result := fTimer.Time;
END;

{ ----------------------------------------------------------------------------------- }

Procedure tJoystickPort.SetInterval(Value:LongInt);

Var Running:Boolean;

Begin
  fInterval := Value;
  If fTimer <> Nil Then
    Begin
      Running:=fTimer.Running;
      fTimer.Stop;
      fTimer.Interval := fInterval;
      If Running Then fTimer.Start;
     End;
End;

Procedure tJoystickPort.EvTimer(Sender:TObject);

var JoyNr : LongWord;
    Cou   : LongWord;
    Dig   : trDigJoystick;

Begin
  If (Sender <> fTimer) or
     (fJoystick.ReadStatus = false) then exit;

  for JoyNr := 1 to cMaxJoystick do
    Begin
{ Buttons gedrueckt }
      if fOnJoyButtonEvent <> nil then
        begin
          for Cou:=1 to cMaxJoystickBtn do
            if fJoystick.Status[JoyNr].Button[Cou].Press = true then
              fOnJoyButtonEvent(Self, JoyNr, Cou);
        end;


{ Position berechnen }
      if ((fJoystick.Status[JoyNr].Pos.X <> fOldStatus[JoyNr].Pos.X) or
          (fJoystick.Status[JoyNr].Pos.Y <> fOldStatus[JoyNr].Pos.Y)) then
        Begin
          if fOnJoyPosEvent <> nil then
            fOnJoyPosEvent(Self, JoyNr, fJoystick.Status[JoyNr].Pos);
        End;
      if fOnJoyDigEvent <> nil then
        Begin
          Dig:=fJoystick.Digital[JoyNr];
          fOnJoyDigEvent(Self, JoyNr, Dig);
        End;

    End;
  fOldStatus := fJoystick.Status;
End;

Procedure tJoystickPort.Start;

Begin
  If Designed Then exit;
  fillchar(fOldStatus, sizeOf(trJoystickStatus),#0);
  If fTimer=Nil Then
    Begin
      fTimer.Create(Self);
      Include(fTimer.ComponentState, csDetail);
      fTimer.OnTimer := EvTimer;
      fTimer.Interval := FInterval;
    End;
  fTimer.Start;
End;

Procedure tJoystickPort.Stop;

Begin
  If fTimer <> Nil Then fTimer.Stop;
End;

Procedure tJoystickPort.SetupComponent;
Begin
  Inherited SetupComponent;
  fInterval := 100;
  If Designed= false Then
    fJoystick.Create;
End;

Destructor tJoystickPort.Destroy;
Begin
  If Designed= false Then
    fJoystick.Destroy;
  Stop;
  Inherited Destroy;
End;

Initialization
  RegisterClasses([TSerialPort, tJoystickPort]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  29-Mar-00  WC         Original Komponente Serial.pas/tSerialPort von Hr. Willem Clements
  05-Jun-03  WD         Einbau der Komponente in WDSibyl; Umbenennen der Datei auf uSerialPort.
  26-Sep-04  WD         Umbennen der Unit von uSerialPort auf uPorts.
  26-Sep-04  WD         Einabu der Komponente JoystickPort aus uJoystickPort
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
}
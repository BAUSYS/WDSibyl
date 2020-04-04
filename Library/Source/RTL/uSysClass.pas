Unit uSysClass;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ Diese Unit behinaltet diverse Systemklassen                               บ
บ                                                                           บ
บ Klassen: tcSemaphor, tcEventSemaphor, tcMutexSemaphor, tcMuxWaitSemaphor  บ
บ          tcQueue, tcQueueString,                                          บ
บ          tcPipeServer, tcPipeClient,                                      บ
บ          tcNamedPipeServer, tcNamedPipeClient,                            บ
บ          tcJoystick, tcUSB  (only OS/2)                                   บ
บ          tcWinFunc (only Windows)                                         บ
บ          tcLog, tcDLL, tcFileSearch, tcExec                               บ
บ          tcPortIO                                                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Interface

{$IFDEF OS2}
Uses OS2Def, BseDos, BseErr, PmWin;
{$ENDIF}

{$IFDEF WIN32}
Uses WINDef, WINBase, WinUser, WinNT, WinErr;
{$ENDIF}

Uses SysUtils, uString, uStream, uList;


{ ----------------------------------------------------------------------------- }

type
  EDllFuncNotFound = Class(Exception);

{$IFDEF OS2}
  tDLLHandle = LongWord;
{$ENDIF}
{$IFDEF Win32}
  tDLLHandle = HINSTANCE;
{$ENDIF}

  tcDLL = Class(tObject)
    Private
      fDLLName   : String;
      fDLLLoaded : Boolean;
      fHandle    : tDllHandle;
      fUpper     : Boolean;
      fLastErr   : LongWord;

      Function LoadDLL : Boolean;
      Function FreeDLL : Boolean;
      Function getFileName : tFileName;
    Protected
    Public
      Constructor Create(iDLLName : tFileName); Virtual;
      Destructor Destroy; Override;

      Function GetProcAddress(const iProcName : String) : pointer;
      Procedure ReLoad;

      Property DLLName   : String      Read fDLLName;
      Property DLLLoaded : Boolean     Read fDLLLoaded;
      Property FileName  : tFileName   Read getFileName;
      Property Handle    : tDLLHandle  Read fHandle;
      Property Upper     : Boolean     Read fUpper Write fUpper;
      Property LastErr   : LongWord    Read fLastErr;
  End;

{ ----------------------------------------------------------------------------- }

Const
  INDEFINITE_WAIT= -1;
  NO_WAIT= 0;

type
  tSemaphorTyp = (SemaphorTypNone, SemaphorTypCreate, SemaphorTypOpen);

Type
  tcSemaphor = Class
    Private
      FHandle : LongWord;
      FName   : String;
      fTyp    : tSemaphorTyp;

      Function getTypText : String;
    Public
      Constructor Create(Const iName : String); Virtual;

      Property Name   : String       read FName;
      Property Handle : LongWord     read fHandle;
      Property Typ    : tSemaphorTyp read fTyp;
      Property TypText: String       read getTypText;
  end;


{ ----------------------------------------------------------------------------- }

  //Mutex Semaphore
  tcMutexSemaphor= Class(tcSemaphor)
    Protected
      FShared        : Boolean;
    Private
      Procedure CreateHandle;Virtual;
      Procedure DestroyHandle;Virtual;
      Function  getCount : LongWord;
    Public
      Constructor Create(Shared:Boolean;Const iName:String);Virtual; Overload;
      Constructor Create; Virtual; Overload;
      Constructor Create(Const Name:String); Virtual; Overload;
      Constructor Create(Const iHandle : LongWord); Virtual; Overload;
      Destructor Destroy;Override;
      Function Request(TimeOut:LongInt):Boolean;Virtual;
      Function Release:Boolean;Virtual;
      Procedure Acquire;
      Procedure Enter;
      Procedure Leave;
    Public
      Property Shared : Boolean  read fShared;
      Property Count  : LongWord read getCount;
  End;

{ ----------------------------------------------------------------------------- }

//Event Semaphor (no count, only Set/Reset !)
  tcEventSemaphor= Class(TcMutexSemaphor)
    Private
      FLastPostCount:LongWord;
    Private
      Procedure CreateHandle;Override;
      Procedure DestroyHandle;Override;
      Function getPostCount : LongWord;
    Public
      Function Post: Boolean; Virtual;
      Function Request(TimeOut:LongInt): Boolean;Override;
      Function Release: Boolean;Override;
      Function WaitFor(TimeOut: LongInt): Boolean; Virtual;
      Function Reset: Boolean; Virtual;
    Public
      Property PostCount    : LongWord             read getPostCount;
      Property LastPostCount: LongWord             read FLastPostCount;
  End;

{ ----------------------------------------------------------------------------- }

Const  MuxWaitSemaphorMax = 63;

type
  tMuxWaitSemaphorFlag = (tMuxWaitSemFlagAll, tMuxWaitSemFlagAny);

  tcMuxWaitSemaphor = class(tcSemaphor)
    private
      fShared : Boolean;
      fFlag   : tMuxWaitSemaphorFlag;
      fList   : tList;
      Function getCount : LongWord;
    public
      Constructor Create(Const iName:String; iShared: Boolean; iFlag : tMuxWaitSemaphorFlag); Virtual; // Overload;
      Destructor Destroy; Override;

      Function Add(iSemaphor : tcSemaphor; iSemaphorId : LongWord) : LongInt;
      Procedure Delete(iSemaphorIndex : LongInt);
      Function WaitFor(iTimeOut: LongInt; var iSemaphorID : LongWord): Boolean;

      Property Shared : Boolean              read fShared;
      Property Flag   : tMuxWaitSemaphorFlag read fFlag;
      Property Count  : LongWord             read getCount;
  End;

{ ----------------------------------------------------------------------------- }

  //Critical Section
  tcCriticalSection=Class
    {$IFDEF WIN32}
    Private
       FCRITICAL_SECTION:CRITICAL_SECTION;
    {$ENDIF}
    Public
      Constructor Create; Virtual;
      Destructor Destroy; Override;
      Function Enter(TimeOut:LongWord): Boolean;
      Function Leave: Boolean;
  End;


//  tEvent = class(tcEventSemaphor);   // Damit es mit der Unit Syncobjs kompatibel ist.
//  tMutex = class(tcMutexSemaphor);  // Damit es mit der Unit Syncobjs kompatibel ist.
//  tCriticalSection = class(tcCriticalSection);   // Damit es mit der Unit Syncobjs kompatibel ist.

{ ----------------------------------------------------------------------------- }

{$IFDEF OS2}
  tQueueTyp = (tQue_FIFO, tQue_LIFO);

  tcQueue = Class(tObject)
    Private
      fQueueName  : String;           { Name der Queue }
      fQueueHandle: hQueue;           { OS/2-Handle der Queue }
      fQueueTyp   : tQueueTyp;        { Type Der Queue: First-In-First-Out, Last-In-First-Qut }
      fQueueCreate: Boolean;          { =true ... Die Queue ist in OS/2 richtig eingerichtet worden }
      function GetElements : LongWord;
    Public
      constructor Create(iQueueName : String; iQueueTyp : tQueueTyp); virtual;
      destructor Destroy; Override;
    Protected
      Function WriteQueue(var iData; iDatalen : LongWord; iElemPriority : Byte) : Boolean; virtual;
      Function ReadQueue(var iData; iGetData : Boolean) : LongWord;
    Published
      Property QueueName   : String    Read fQueueName;
      Property QueueTyp    : tQueueTyp Read fQueueTyp;
      Property QueueCreate : Boolean   Read fQueueCreate;
      Property Elements    : LongWord  Read GetElements;
  End;

  tcQueueString = Class(tcQueue)
    Private
      fLastText : String;
    Public
      Function WriteQueue(iText : String; iElemPriority : Byte) : Boolean; virtual;
      Function ReadQueue : String; virtual;
    Published
      Property LastText : String Read fLastText;
  End;
{$ENDIF}

{ ----------------------------------------------------------------------------- }

type
 {$M+}
 TThreadPriority=(tpIdle,tpLowest,tpLower,tpNormal,tpHigher,tpHighest,tpTimeCritical);
 {$M-}
 TThreadMethod=Procedure Of Object;

    TThread=Class
      Private
         FOnTerminate:TNotifyEvent;
         FHandle:LongWord;
         FPriority:TThreadPriority;
         FFreeOnTerminate:Boolean;
         FTerminated:Boolean;
         FReturnValue:LongInt;
         FSuspended:Boolean;
         FFinished:Boolean;
         FThreadId:LongWord;
         FParameter:Pointer;
         FMethod:TThreadMethod;
         Procedure SetSuspended(NewValue:Boolean);
         Procedure SetPriority(NewValue:TThreadPriority);
         Procedure SyncTerminate;
         Procedure MsgIdle;
      Protected
         Procedure DoTerminate;Virtual;
         Procedure Execute;Virtual;Abstract;
      Public
         Constructor Create(CreateSuspended:Boolean);
         Constructor ExtCreate(CreateSuspended:Boolean;StackSize:LongWord;
                               Priority:TThreadPriority;Param:Pointer);
         Destructor Destroy;Override;
         Function WaitFor:LongInt;
         Procedure Terminate;
         Procedure Suspend;
         Procedure Resume;
         Procedure Kill;
         Procedure Synchronize(method:TThreadMethod);
         Procedure ProcessMsgs;
         Property Terminated:Boolean Read FTerminated;
         Property ReturnValue:LongInt Read FReturnValue Write FReturnValue;
         Property ThreadId:LongWord Read FThreadId;
         Property Handle:LongWord Read FHandle;
         Property Priority:TThreadPriority Read FPriority Write SetPriority;
         Property Parameter:Pointer Read FParameter Write FParameter;
         Property Suspended:Boolean Read FSuspended Write SetSuspended;
         Property FreeOnTerminate:Boolean Read FFreeOnTerminate Write FFreeOnTerminate;
         Property OnTerminate:TNotifyEvent Read FOnTerminate Write FOnTerminate;
    End;

// -----------------------------------------------------------------------------

Type
  TNotifyPipeInEvent = procedure(Sender: TObject; InstanceNr : LongWord) of object;
  tNamedPipeAccess  = (tNamedPipeAccessOutBound, tNamedPipeAccessInBound, tNamedPipeAccessDuplex);
  tNamedPipeModeType= (tNamedPipeModeTypeByte, tNamedPipeModeTypeMessage);
  tNamedPipeSemStatus = (
       tNamedPipeSemStatusNull,
       tNamedPipeSemStatusEoi,      // End of information buffer. No more
       tNamedPipeSemStatusRData,    // Read data is available.
       tNamedPipeSemStatusWSpace,   // Write space is available.
       tNamedPipeSemStatusClose);   // The pipe is closed.

  tcPipeThread = Class(tThread)
    private
      fHandle            : LongWord;
      fOnPipeExecuteStart: TNotifyEvent;
      fOnPipeExecuteStop : TNotifyEvent;
      fOnPipeIn          : TNotifyPipeInEvent;
    protected
      Procedure Execute; Override;
      Procedure PipeExecute; Virtual; Abstract;
      Procedure Close; Virtual; Abstract;
    public
      constructor Create(iCreateSuspended: Boolean); virtual;
      property Handle            : LongWord      Read fHandle;
      property OnPipeExecuteStart: TNotifyEvent  Read fOnPipeExecuteStart Write fOnPipeExecuteStart;
      property OnPipeExecuteStop : TNotifyEvent  Read fOnPipeExecuteStop  Write fOnPipeExecuteStop;
      property OnPipeIn          : TNotifyPipeInEvent  Read fOnPipeIn Write fOnPipeIn;
  end;

  tcPipeServer = Class(tcPipeThread)
    Private
      fBufferIn     : tMemoryStream;
      fLenBufferIn  : LongInt;
      fBufferOut    : tMemoryStream;
      fLenBufferOut : LongInt;
      fSendBufferOut: Boolean;
    Protected
    Public
      Procedure SendBufferOut; virtual; abstract;
      constructor Create(iLenBufferIn, iLenBufferOut : LongInt; iCreateSuspended: Boolean); virtual;
      destructor Destroy; Override;

      property LenBufferIn       : LongInt       Read fLenBufferIn;
      property BufferIn          : tMemoryStream Read fBufferIn;

      property LenBufferOut      : LongInt       Read fLenBufferOut;
      property BufferOut         : tMemoryStream Read fBufferOut;
  End;

  tcPipeClient = Class(tcPipeThread)
    Private
    Protected
    Public
      constructor Create; virtual;
  End;

// -----

  tcNamedPipeServer = Class(tcPipeServer)
    private
      fPipeName     : String;
      fInstanceCount: Byte;       // Bei 0..unlimitierte Instancen
      fAccess       : tNamedPipeAccess;
      fReadModeType : tNamedPipeModeType;
      fWriteModeType: tNamedPipeModeType;
      fInherit      : Boolean;
      fWriteBehind  : Boolean;
      fSemaphor     : tcEventSemaphor;

      Function getSemStatus : tNamedPipeSemStatus;
    protected
      Procedure PipeExecute; Override;
      Procedure Close; Virtual;

    public
      Procedure SendBufferOut; Override;
      Procedure Resume; virtual;   // Starten des Servers
      Procedure Suspend; virtual;  // Beenden des Servers

      constructor Create(iPipeName : String; iLenBufferIn, iLenBufferOut : LongInt); virtual;
      destructor Destroy; Override;

      property PipeName     : String             Read fPipeName;
      property LenBufferOut : LongInt            Read fLenBufferOut;
      property InstanceCount: Byte               Read fInstanceCount Write fInstanceCount;
      property ReadModeType : tNamedPipeModeType Read fReadModeType  Write fReadModeType;
      property WriteModeType: tNamedPipeModeType Read fWriteModeType Write fWriteModeType;
      property Access       : tNamedPipeAccess   Read fAccess;
      property Inherit      : Boolean            Read fInherit       Write fInherit;
      property WriteBehind  : Boolean            Read fWriteBehind   Write fWriteBehind;
      property SemStatus    : tNamedPipeSemStatus read getSemStatus;
  End;

  tcAnonymousPipeServer = Class(tcPipeServer)
    Private
      property Handle;
      fHandleIn : LongWord;
      fHandleOut: LongWord;
    protected
      Procedure PipeExecute; Override;
      Procedure Close; Virtual;

    public
      Procedure SendBufferOut; Override;
      Procedure Resume; virtual;   // Starten des Servers
      Procedure Suspend; virtual;  // Beenden des Servers

      constructor Create(iLenBuffer : LongInt); virtual;
      destructor Destroy; Override;

      property HandleIn : LongWord      Read fHandleIn;
      property HandleOut: LongWord      Read fHandleOut;
  End;

  tcNamedPipeClient = Class(tcPipeClient)
    Private
      fPipeName    : String;

    Protected
      Procedure PipeExecute; Override;
      Procedure Close; Virtual;

    Public
      Procedure Resume; virtual;   // Starten des Client
      Procedure Suspend; virtual;  // Beenden des Client

      constructor Create(iPipeName : String); virtual;
      destructor Destroy; Override;

      property PipeName     : String             Read fPipeName;
  End;


/*
type
  tcPipeClient = Class(tObject)
    Private
      fPipeName    : String;
{$IFDEF OS2}
      fHPipe       : HPipe;
{$ENDIF}
      fLenBufferIn : LongWord;
      fLenBufferOut: LongWord;
      fBuffer      : tMemoryStream;
      fLastError   : LongWord;           { =true ... Ein andere Thread sendet gerade Daten }
      fTransfer    : Boolean;
      Function GetInfo      : Boolean;   { Einlesen der Pipe-Info }
      Function GetPipeServer: String;
      Function PipeOpen     : LongInt;
      Procedure PipeClose;
    Protected
    Public
      constructor Create(iComputerName, iPipeName : String);
      destructor Destroy; Override;
      Function SendBuffer : Boolean;            { Senden und Empfangen von der Pipe }

    Published
      Property Buffer      : tMemoryStream Read fBuffer    Write fBuffer;
      Property LenBufferIn : LongWord      Read fLenBufferIn  Write fLenBufferIn;
      Property LenBufferOut: LongWord      Read fLenBufferOut Write fLenBufferOut;
      Property PipeServer  : String        Read GetPipeServer;
      Property PipeName    : String        Read fPipeName;
      Property LastError   : LongWord      Read fLastError;
  End;
*/

{ ----------------------------------------------------------------------------- }

const cMaxJoystick    = 2;                { Anzahl der Joysticks, abhaengig vom Treiber }
      cMaxJoystickBtn = 2;                { Anzahl der Buttons pro Joystick, abhaengig vom Treiber }

type tDigJoystickLCR = (joy_Left,joy_Center,joy_Right);

type trDigJoystick = Record
       PosByte : tPoint;                  { Position des Joysticks in einem Berich von 0..255 }
       DigX    : tDigJoystickLCR;         { X-Position in: joy_Left, joy_Center, joy_Right }
       DigY    : tDigJoystickLCR;         { Y-Position in: joy_Left, joy_Center, joy_Right }
     End;

type trJoystickStatus= Array[1.. cMaxJoystick] of Record
       Pos    : tPoint;                   { Aktuelle Position }
       Low    : tPoint;                   { Minimalwert vom Joystick}
       Center : tPoint;                   { Mittelwert vom Joystick }
       High   : tPoint;                   { Maximalwert vom Joystick }
       Button : Array[1..cMaxJoystickBtn] of Record
         Press: Boolean;                  { Button auf dem Joystick gedrueckt }
         Count: LongWord;                 { Wieoft der Button gedrueckt worden ist. }
       End;
     End;

Type
  tcJoystick = Class(TObject)
    Private
      fGamePort   : LongWord;             { Handle zu Joystick }
      fOldPos     : tPoint;               { Alte Position vom Joystick }
      fStatus     : trJoystickStatus;      { Status-Variable }
      fTicks      : LongWord;             { Anzahl der Abfragen}
      Function getDigital(iJoy : Byte) : trDigJoystick;
    Public
      Constructor Create;
      Destructor Destroy;  override;
      Function ReadStatus    : Boolean;
      Function GetGameVersion: LongWord;

      Property Digital[iJoy : Byte] : trDigJoystick read getDigital;
    Published
      Property GamePortHandle : LongWord         Read fGamePort;
      Property GameVersion    : LongWord         Read GetGameVersion;
      Property Status         : trJoystickStatus Read fStatus;
      Property Ticks          : LongWord         Read fTicks;
  End;

{ ----------------------------------------------------------------------------- }

{$IFDEF OS2}
Const USB_CLASS_PER_INTERFACE        = 0;
      USB_CLASS_AUDIO                = 1;
      USB_CLASS_COMM                 = 2;
      USB_CLASS_HID                  = 3;
      USB_CLASS_PRINTER              = 7;
      USB_CLASS_MASS_STORAGE         = 8;
      USB_CLASS_HUB                  = 9;
      USB_CLASS_DATA                 = 10;
      USB_CLASS_VENDOR_SPEC          = $ff;

// USB descriptor types
Const USB_DT_DEVICE                  = $01;
      USB_DT_CONFIG                  = $02;
      USB_DT_STRING                  = $03;
      USB_DT_INTERFACE               = $04;
      USB_DT_ENDPOINT                = $05;
      USB_DT_HID                     = $21;
      USB_DT_REPORT                  = $22;
      USB_DT_PHYSICAL                = $23;
      USB_DT_HUB                     = $29;

// Descriptor sizes per descriptor type
Const USB_DT_DEVICE_SIZE             = 18;
      USB_DT_CONFIG_SIZE             = 9;
      USB_DT_INTERFACE_SIZE          = 9;
      USB_DT_ENDPOINT_SIZE           = 7;
      USB_DT_ENDPOINT_AUDIO_SIZE     = 9;
      USB_DT_HUB_NONVAR_SIZE         = 7;

// Endpoint-Types
Const USB_ENDPOINT_ADDRESS_MASK      = $0f;
      USB_ENDPOINT_DIR_MASK          = $80;
      USB_ENDPOINT_TYPE_MASK         = $03;
      USB_ENDPOINT_TYPE_CONTROL      = 0;
      USB_ENDPOINT_TYPE_ISOCHRONOUS  = 1;
      USB_ENDPOINT_TYPE_BULK         = 2;
      USB_ENDPOINT_TYPE_INTERRUPT    = 3;

// Standard requests
Const USB_REQ_GET_STATUS             = $00;
      USB_REQ_CLEAR_FEATURE          = $01;
      USB_REQ_SET_FEATURE            = $03;
      USB_REQ_SET_ADDRESS            = $05;
      USB_REQ_GET_DESCRIPTOR         = $06;
      USB_REQ_SET_DESCRIPTOR         = $07;
      USB_REQ_GET_CONFIGURATION      = $08;
      USB_REQ_SET_CONFIGURATION      = $09;
      USB_REQ_GET_INTERFACE          = $0A;
      USB_REQ_SET_INTERFACE          = $0B;
      USB_REQ_SYNCH_FRAME            = $0C;

// USB types
Const USB_TYPE_STANDARD              = ($00 << 5);
      USB_TYPE_CLASS                 = ($01 << 5);
      USB_TYPE_VENDOR                = ($02 << 5);
      USB_TYPE_RESERVED              = ($03 << 5);

// USB recipients
Const USB_RECIP_DEVICE               = $00;
      USB_RECIP_INTERFACE            = $01;
      USB_RECIP_ENDPOINT             = $02;
      USB_RECIP_OTHER                = $03;

// USB Masks
Const USB_TYPE_MASK                  = ($03 << 5);
      USB_RECIP_MASK                 =  $1f;

// USB directions
Const USB_DIR_OUT                    = $00;
      USB_DIR_IN                     = $80;

// USB Errors
Const USB_NOT_INIT                   = 8000;
      USB_ERROR_NO_MORE_NOTIFICATIONS= 8001;
      USB_ERROR_OUTOF_RESOURCES      = 8002;
      USB_ERROR_INVALID_ENDPOINT     = 8003;
      USB_ERROR_LESSTRANSFERED       = 8004;

Const USB_ANY_PRODUCTVERSION         = $FFFF;
      USB_OPEN_FIRST_UNUSED          = $0000;

type tUsbHandle = Longword;

type tpUsb_device_descriptor = ^tUsb_device_descriptor;
     tUsb_device_descriptor = Record
       bLength           : Byte;
       bDescriptorType   : Byte;
       bcdUSB            : Word;
       bDeviceClass      : Byte;
       bDeviceSubClass   : Byte;
       bDeviceProtocol   : Byte;
       bMaxPacketSize0   : Byte;
       idVendor          : Word;
       idProduct         : Word;
       bcdDevice         : Word;
       iManufacturer     : Byte;
       iProduct          : Byte;
       iSerialNumber     : Byte;
       bNumConfigurations: Byte;
      End;

type tpUsb_config_descriptor = ^tUsb_config_descriptor;
     tUsb_config_descriptor = Record
       bLength            : Byte;
       bDescriptorType    : Byte;
       wTotalLength       : Word;
       bNumInterfaces     : Byte;
       bConfigurationValue: Byte;
       iConfiguration     : Byte;
       bmAttributes       : Byte;
       MaxPower           : Byte;
       usb_interface      : Pointer; // struct usb_interface *interface;
       extra              : PChar;   /* Extra descriptors */
       extralen           : Word;
     End;

type pUSBFunc=^tUSBFunc;
     tUSBFunc=Record
       UsbQueryDeviceReport         : Function(ulDevNumber : LongWord;
                                           var ulBufLen : LongWord; pData : pChar) : ApiRet; APIENTRY;
       UsbQueryNumberDevices        : Function(var lNumDev : LongWord) : ApiRet; APIENTRY;
       UsbBulkRead                  : Function(UsbHandle : tUsbHandle; bEndpoint : Byte; bInterface : Byte;
                                           var ulNumBytes: LongWord; pData : puChar; ulTimeout : LongWord) : ApiRet; APIENTRY;
       UsbIsoStart                  : Function(UsbHandle : tUsbHandle; bEndpoint : Byte; bInterface : Byte;
                                           phIso : LongWord) : ApiRet; APIENTRY;
       UsbIrqStart                  : Function(UsbHandle : tUsbHandle; bEndpoint : Byte; pInterface: Byte;
                                           usNumBytes: word; pData : puChar; pHevModified : Hev) : ApiRet; APIENTRY;
       UsbBulkWrite                 : Function(UsbHandle : tUsbHandle; bEndpoint : Byte; bInterface: Byte;
                                           ulNumBytes: LongWord; pData : puChar; ulTimeout : LongWord) : ApiRet; APIENTRY;
       UsbIsoDequeue                : Function(hIso : LongWord; pData : puChar; ulNumBytes : LongWord) : ApiRet; APIENTRY;
       UsbCtrlMessage               : Function(UsbHandle: tUsbHandle; ucRequestType : Byte; ucRequest : Byte;
                                           usValue : Word; usIndex : Word; usLength : Word;
                                           pData: pChar; ulTimeout : LongWord) : ApiRet; APIENTRY;
       UsbDeregisterNotification    : Function(NotifyID : LongWord)  : ApiRet; APIENTRY;
       UsbIsoGetLength              : Function(hIso : LongWord; pulLength : LongWord) : ApiRet; APIENTRY;
       UsbIsoPeekQueue              : Function(hIso : LongWord; pByte : puChar; ulOffset : LongWord) : ApiRet; APIENTRY;
       UsbOpen                      : function(var UsbHandle : tUsbHandle; usVendor : LongWord;
                                           usProduct : LongWord; usBCDDevice : LongWord;
                                           usEnumDevice: LongWord) : ApiRet; APIENTRY;
       UsbRegisterChangeNotification: function(pNotifyID : LongWord; hDeviceAdded, hDeviceRemoved : hev) : ApiRet; APIENTRY;
       UsbClose                     : function(UsbHandle : tUsbHandle) : ApiRet; APIENTRY;
       UsbRegisterDeviceNotification: function(pNotifyID : LongWord; hDeviceAdded, hDeviceRemoved : hev;
                                           usVendor, usProduct, usBCDVersion : Word) : ApiRet; APIENTRY;
       UsbIsoStop                   : function(hIso : LongWord) : ApiRet; APIENTRY;
       UsbIrqStop                   : function(UsbHandle : tUsbHandle; HevModified : Hev) : ApiRet; APIENTRY;
  End;

  tcUSBCalls = Class(tcDLL)
    private
      fUsbFunc : tUSBFunc;
{      Function GetProcAddress(const iProcName : String) : pointer; }

    Public
      Constructor Create; virtual;
      Function DeviceNr(iVendorID, iProductID : LongWord; Var iDeviceNr : LongWord) : ApiRet;
      Function SetConfiguration(iUsbHandle : tUsbHandle; iConfigurationValue: Byte) : ApiRet;

      property Func : tUsbFunc read fUSBFunc;
  End;
{$ENDIF}

{ ----------------------------------------------------------------------------- }

{$IFDEF Win32}

type pWinFunc=^tWinFunc;
     tWinFunc=Record
       CreateLinkProgramsPrivate : function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;
       CreateLinkProgramsPublic  : function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;
       CreateLinkStartupPrivate  : function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;
       CreateLinkStartupPublic   : function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;
       CreateLinkDesktopPrivate  : function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;
       CreateLinkDesktopPublic   : function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;
       CreateLinkStartmenuPrivate: function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;
       CreateLinkStartmenuPublic : function(const AFilename, ALNKFilename, ADescription: cString): Boolean; APIENTRY;

       DeleteLinkProgramsPrivate : function(const ALNKFilename: cString): Boolean; APIENTRY;
       DeleteLinkProgramsPublic  : function(const ALNKFilename: cString): Boolean; APIENTRY;
       DeleteLinkStartupPrivate  : function(const ALNKFilename: cString): Boolean; APIENTRY;
       DeleteLinkStartupPublic   : function(const ALNKFilename: cString): Boolean; APIENTRY;
       DeleteLinkDesktopPrivate  : function(const ALNKFilename: cString): Boolean; APIENTRY;
       DeleteLinkDesktopPublic   : function(const ALNKFilename: cString): Boolean; APIENTRY;
       DeleteLinkStartmenuPrivate: function(const ALNKFilename: cString): Boolean; APIENTRY;
       DeleteLinkStartmenuPublic : function(const ALNKFilename: cString): Boolean; APIENTRY;

     End;

  tcWinFunc = Class(tcDLL)
    private
      fWinFunc : tWinFunc;
    Public
      Constructor Create; virtual;
      property Func : tWinFunc read fWinFunc;
  End;
{$ENDIF}

{ ----------------------------------------------------------------------------- }

type
  tcLog = Class
    Private
      fWriteScreen: Boolean;  { =true; Schreiben des logs in das WinCrt-Fenster }
      fFilename   : String;
      fLog        : Boolean;
      fLastWrite  : String;
      fFileStream : tFileStream;

      Procedure SetLog(iValue : Boolean);
      Procedure setWriteScreen(iValue : Boolean);
    Public
      Constructor Create(iFilename: tFilename); Virtual;
      Destructor Destroy; Override;
      Procedure Writeln(iText : String);
      Procedure Write(iText : String);
    Published
      Property Log        : Boolean   Read fLog Write SetLog;
      Property Filenname  : tFilename Read fFilename;
      Property WriteScreen: Boolean   Read fWriteScreen Write setWriteScreen;
  End;

{ ----------------------------------------------------------------------------- }

  tprFileInfo = ^trFileInfo;
  trFileInfo = Record
    Path: tFilename;
    Name: tFilename;
    Attr: Byte;
    Size: LongWord;
    Time: tDateTime;
  End;

  tfFindSearchNotify = procedure(iSender: TObject; iFileInfo : trFileInfo) of object;
  tfFindSearchErrorNotify = procedure(iSender: TObject; iPath, iMask : tFilename) of object;

  tcFileSearch = Class
    Private
      fDateSince   : tDateTime;
      fDateBefore  : tDateTime;
      fFileList    : tStringList;
      fFileNameExc : tStringList;  { Liste der Dateien die nicht durchsucht werden soll }
      fRecursiv    : Boolean;
      fChkDate     : Boolean;

      fOnFileSearch: tfFindSearchNotify;
      fOnError     : tfFindSearchErrorNotify;

      Function ChkDatei(iFileInfo : trFileInfo) : Boolean;
      Function CnvParamDt(iStr : String; var iDtm : tDatetime) : Boolean;
    Public
      Constructor Create;
      Destructor Destroy; Override;

      Function SetStrDateSince(iStrDate : String) : Boolean;
      Function SetStrDateBefore(iStrDate : String): Boolean;

      Procedure Start;

      Property OnFileSearch: tfFindSearchNotify Read fOnFileSearch Write fOnFileSearch;
      Property OnError     : tfFindSearchErrorNotify Read fOnError Write fOnError;

      Property Recursiv   : Boolean     Read fRecursiv Write fRecursiv;
      Property ChkDate    : Boolean     Read fChkDate Write fChkDate;
      Property DateSince  : tDateTime   Read fDateSince    Write fDateSince;
      Property DateBefore : tDateTime   Read fDateBefore   Write fDateBefore;
      Property FileList   : tStringList Read fFileList;
      Property FileNameExc: tStringList Read fFileNameExc;
  End;

{ ----------------------------------------------------------------------------- }

  tcExecWindowState = (ExWsNormal,ExWsSetPos,ExWsMinimized,ExWsMaximized,ExWsHidden);
  tcExecStartFgBg   = (ExStForeground, ExStBackground);
  tcExec = Class    
    Private
      fFileName       : tFileName;
      fParameters     : tStringList;
      fSessionID      : LongWord;
      fProcessID      : LongWord;
      fProcessHandle  : LongWord;
      fThreadID       : LongWord;
      fThreadHandle   : LongWord;
      fLastExecResult : LongWord;
      fPipeServer     : tcAnonymousPipeServer;

      fTitle          : String;
      fWindowState    : tcExecWindowState;
      fWindowPos      : tPoint;
      fWindowSize     : tSize;
      fExecViaSession : Boolean;           // =true; Programm wird in einer neue Session gestarten
      fAsynchExec     : Boolean;           // =true; Programm wird asynchron gestartet
      fUrlSupport     : Boolean;           // =true; Als Programm wurde ein URL angegeben
      fStartFgBg      : tcExecStartFgBg;

      Function getProgramFromUrl(Const url : String; Var urlProgram : tFilename) : Boolean;
      Function getParameter2AnsiString : AnsiString;

    Public
      Procedure AddParameter(Const iParameter : String);
      Function StartProgram : LongInt;
      {$IFDEF OS2}
      Function StartProgramOS2 : LongInt;
      {$ENDIF}
      {$IFDEF Win32}
      Function StartProgramWin32 : LongInt;
      {$ENDIF}
      Function DosExitCode : LongWord;
      Function ProcessActive : Boolean;
      Function KillProcess : LongInt;

      Constructor Create(Const iFileName : tFileName);
      Destructor Destroy; Override;

      Property FileName      : tFileName   Read fFileName;
      Property Parameters    : tStringList Read fParameters;
      Property SessionID     : LongWord    Read fSessionID;
      Property ProcessID     : LongWord    Read fProcessID;
      Property ThreadID      : LongWord    Read fThreadID;

      Property Title          : String             Read fTitle           Write fTitle;
      Property WindowState    : tcExecWindowState  Read fWindowState     Write fWindowState;
      Property ExecViaSession : Boolean            Read fExecViaSession  Write fExecViaSession;
      Property AsynchExec     : Boolean            Read fAsynchExec      Write fAsynchExec;
      Property UrlSupport     : Boolean            Read fUrlSupport      Write fUrlSupport;
      Property StartFgBg      : tcExecStartFgBg    Read fStartFgBg       Write fStartFgBg;

      Property PipeServer     : tcAnonymousPipeServer Read fPipeServer Write fPipeServer;

      Property WindowPos      : tPoint             Read fWindowPos       Write fWindowPos;
      Property WindowSize     : tSize              Read fWindowSize      Write fWindowSize;

  End;

// Errortext:
Const ERR_EXEC_CANNOT_RETRIEVE_PID     = 1; // 'Can''t retrieve process-id';
      ERR_EXEC_CANNOT_CREATE_TERM_QUEUE= 2; // 'Can''t create exec termination-Queue';
      ERR_EXEC_CANNOT_READ_TERM_QUEUE  = 3; // 'Can''t read termination-Queue';
      ERR_EXEC_CANNOT_CLOSE_TERM_QUEUE = 4; // 'Can''t close exec termination-Queue';
      ERR_EXEC_CANNOT_CREATE_EVENT_SEM = 5; // 'Can''t create event-semaphore';
      ERR_EXEC_CANNOT_QUERY_EVENT_SEM  = 6; // 'Can''t query event-semaphore';
      ERR_EXEC_CANNOT_CLOSE_EVENT_SEM  = 7; // 'Can''t close event-semaphore';
      ERR_EXEC_CANNOT_FREE_QUEUE_DATA  = 8; // 'Can''t free QueueData';
      ERR_EXEC_CANNOT_CREATE_PROCESS   = 9; // 'Cannot create process';
      ERR_EXEC_CANNOT_WAITSINGLEOBJECT = 10; // 'Error by WaitSingleObject';

{ ----------------------------------------------------------------------------- }

type
  tcPortIO = Class
    Private
      fIoDriverHandle: LongWord;
      fIOAction      : LongWord;

      function GetByte(iPortAdress: Word): Byte;
      procedure SetByte(iPortAdress:Word; Value: Byte);
      function GetWord(iPortAdress: Word): Word;
      procedure SetWord(iPortAdress:Word; Value: Word);

    Public
      Constructor Create;
      Destructor Destroy; Override;

      property IODriverHandle : LongWord      read fIoDriverHandle;
      property IOByte[PortAdress: Word]: Byte read GetByte write SetByte; default;
      property IOWord[PortAdress: Word]: Word read GetWord write SetWord;

  End;


{ ----------------------------------------------------------------------------- }

Implementation

Uses uSysInfo, IniFiles;

{$IFDEF OS2}
Uses bseTib;
{$ENDIF}

Const PathSem = '\SEM32\';
      PathPipe= '\PIPE\';
      PathQueue='\QUEUES\';

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcDLL Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tcDLL.LoadDLL : Boolean;

{$IFDEF OS2}
Var cLoadError: CString;
{$ENDIF}
Var cName     : CString;

Begin
  Result:=false;
  if fHandle<>0 then exit;
  cName:=fDLLName;
{$IFDEF OS2}
  cLoadError:='';
  fLastErr:= DosLoadModule(cLoadError,255,cName, fHandle);
  if (fLastErr <> NO_ERROR) then
    Begin
      if (not fLastErr in [ERROR_FILE_NOT_FOUND, ERROR_INIT_ROUTINE_FAILED]) then
        fHandle := 0;
    End;
{$ENDIF}
{$IFDEF Win32}
  fHandle:=LoadLibrary(cName);
  if fHandle<32 then
    fHandle := 0;
{$ENDIF}

  if fHandle=0
    then
      Begin
        Result:=false;
        Raise EFileNotFound.Create(fDLLName);
      End
    else Result:=true;
End;

Function tcDLL.FreeDLL : Boolean;

Begin
  Result:=false;
  if fHandle = 0 then exit;
  {$IFDEF OS2}
  fLastErr:=DosFreeModule(fHandle);
{ if rc <> NO_ERROR then
  CallError(cERR_APIERROR, toStr(rc)); }
  {$ENDIF}
  {$IFDEF Win32}
  FreeLibrary(fHandle);
  {$ENDIF}
End;

Function tcDLL.GetFileName : tFileName;

Var FileName : CSTRING;

Begin
  {$IFDEF OS2}
  DosQueryModuleName(fHandle,255, FileName);
  Result:=FileName;
  {$ENDIF}
  {$IFDEF Win32}
  Result:=fDLLName;
  {$ENDIF}
End;

Procedure tcDLL.ReLoad;

Begin
  FreeDLL;
  SysSleep(100);
  fDLLLoaded:=LoadDLL;
End;

Constructor tcDLL.Create(iDLLName : TFilename);

Begin
  inherited Create;
  fHandle:=0;
  fDLLName:=iDLLName;
  fUpper:=true;
  fDLLLoaded:=LoadDLL;
End;

Destructor tcDLL.Destroy;
             
Begin
  FreeDLL;
  inherited destroy;
End;

Function tcDLL.GetProcAddress(const iProcName : String) : pointer;

Var c : cString;

Begin
  Result:=nil;
  if fHandle = 0
    then { CallError(cERR_DLL_NOT_LOADED, '') }
    else
      Begin
        if fUpper
          then c := UpperCase(iProcName)
          else c := iProcName;
{$IFDEF OS2}
        fLastErr:=DosQueryProcAddr(fHandle,0,c,Result);
        If fLastErr <> NO_ERROR then
          Begin
            Raise EDllFuncNotFound.Create(iProcname);
            Result:=Nil;
          End;
{$ENDIF}
{$IFDEF Win32}
        Result := Winbase.GetProcAddress(fHandle,c);
        if Result=nil then
          Raise EDllFuncNotFound.Create(iProcname);
{$ENDIF}
      End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcSemaphor Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tcSemaphor.getTypText : String;

Begin
  Case fTyp of
    SemaphorTypNone  : Result:='None';
    SemaphorTypCreate: Result:='Create';
    SemaphorTypOpen  : Result:='Open';
  End;
End;


Constructor tcSemaphor.Create(Const iName : String);

Begin
  inherited Create;
  fHandle:=0;
  fTyp:=SemaphorTypNone;
  FName:=iName;
  if fName<>'' then
    Begin
      fName:=uppercase(fName);
      {$IFDEF OS2}
      if pos(PathSem,fName)=0 then
        fName:=PathSem+fName;
      {$ENDIF}
    End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TcMutexSemaphor Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor tcMutexSemaphor.Create(Shared: Boolean;Const iName:String);
Begin
  Inherited Create(iName);
  FShared:=Shared;
  CreateHandle;
End;
         
Constructor tcMutexSemaphor.Create;
Begin
  Create(False,'');
End;

Constructor tcMutexSemaphor.Create(Const Name:String);
Begin
  Create(False,Name);
End;

Constructor tcMutexSemaphor.Create(Const iHandle : LongWord);

{$IFDEF OS2}
var rc    : APIRET;
{$ENDIF}

Begin
  Inherited Create('');
  fHandle:=iHandle;
  {$IFDEF OS2}
  rc:=DosOpenMutexSem(nil, fHandle);
    if rc=NO_ERROR then
      fTyp:=SemaphorTypOpen;
{$ENDIF}
End;

Destructor tcMutexSemaphor.Destroy;
Begin
  DestroyHandle;
  Inherited Destroy;
End;

Procedure tcMutexSemaphor.CreateHandle;
{$IFDEF OS2}
Var flAttr: LONGWORD;
    rc    : APIRET;
{$ENDIF}

Var cs : CString;

Begin
  If (fTyp<>SemaphorTypNone) then exit;
  {$IFDEF OS2}
  If FShared
    Then flAttr:= BseDos.DC_SEM_SHARED
    Else flAttr:= 0;

  if fName='' then
    rc:=BseDos.DosCreateMutexSem(nil,FHandle,flAttr,False)
  else
    Begin
      cs:=FName;
      rc:=BseDos.DosCreateMutexSem(cs,FHandle,flAttr,False);
    End;

  case rc of
    NO_ERROR:
      fTyp:=SemaphorTypCreate;
    ERROR_DUPLICATE_NAME:
      Begin
        rc:=DosOpenMutexSem(cs, fHandle);
        if rc=NO_ERROR then
          fTyp:=SemaphorTypOpen;
      End;
  end;
  {$ENDIF}
  {$IFDEF WIN32}
  FHandle:= WinBase.CreateMutex(NIL,False,cs);
  case GetLastError of
    NO_ERROR:
      fTyp:=SemaphorTypCreate;
    ERROR_ALREADY_EXISTS:
      fTyp:=SemaphorTypOpen;
  end;
  {$ENDIF}
// Ein bisschen warten bis der Semaphor eingerichtet ist.
  syssleep(100);
End;

Procedure tcMutexSemaphor.DestroyHandle;
Begin
  If FHandle<>0 Then
    Begin
      {$IFDEF OS2}
      BseDos.DosCloseMutexSem(FHandle);
      {$ENDIF}
      {$IFDEF WIN32}
      WinBase.CloseHandle(FHandle);
      {$ENDIF}
      FHandle:=0;
    End;
End;

Function tcMutexSemaphor.Request(TimeOut:LongInt): Boolean;
Begin
  If FHandle=0 Then exit;
  {$IFDEF OS2}
  Result:=BseDos.DosRequestMutexSem(FHandle,TimeOut)=BseErr.NO_ERROR;
  {$ENDIF}
  {$IFDEF Win32}
  Result:=WinBase.WaitForSingleObject(FHandle, TimeOut) In [WAIT_OBJECT_0,WAIT_ABANDONED];
  {$ENDIF}
End;

Procedure tcMutexSemaphor.Acquire;
Begin
  Request(INDEFINITE_WAIT);
End;

Procedure tcMutexSemaphor.Enter;

Begin
  Acquire;
End;

Procedure tcMutexSemaphor.Leave;
Begin
  Release;
End;

Function tcMutexSemaphor.Release: Boolean;
Begin
  {$IFDEF OS2}
  Result:=BseDos.DosReleaseMutexSem(FHandle)=BseErr.NO_ERROR;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:= WinBase.ReleaseMutex(FHandle);
  {$ENDIF}
End;

Function tcMutexSemaphor.getCount : LongWord;

{$IFDEF OS2}
var p : pid;
    t : tid;
{$ENDIF}

Begin
{$IFDEF OS2}
  BseDos.DosQueryMutexSem(fHandle, p, t, Result);
{$ENDIF}
{$IFDEF WIN32}
  Result:=0;
{$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TEventSemaphor Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcEventSemaphor.CreateHandle;

Var cs:CString;
{$IFDEF OS2}
    flAttr:LongWord;
    rc    : APIRET;
{$ENDIF}
{$IFDEF WIN32}
    cName:PChar;
{$ENDIF}

Begin
  If (FHandle<>0) Then exit;
  fLastPostCount:=0;

  {$IFDEF OS2}
  If FShared
    Then flAttr:= BseDos.DC_SEM_SHARED
    Else flAttr:= 0;
  if fName='' then
    rc:=BseDos.DosCreateEventSem(nil,FHandle,flAttr,False)
  else
    Begin
      cs:=FName;
      rc:=BseDos.DosCreateEventSem(cs,FHandle,flAttr,False);
    End;
  case rc of
    NO_ERROR:
      fTyp:=SemaphorTypCreate;
    ERROR_DUPLICATE_NAME:
      Begin
        rc:=DosOpenEventSem(cs, fHandle);
        if rc = NO_ERROR then
          fTyp:=SemaphorTypOpen;
      End;
  end;
  {$ENDIF}
  {$IFDEF WIN32}
  FHandle:= WinBase.CreateEvent(NIL,TRUE,False,cName);
  case GetLastError of
    NO_ERROR:
      fTyp:=SemaphorTypCreate;
    ERROR_ALREADY_EXISTS:
      fTyp:=SemaphorTypOpen;
  end;
  {$ENDIF}
// Ein bischen warten, damit das System alles einrichten kann.
  SysSleep(100);
End;

Procedure tcEventSemaphor.DestroyHandle;

{$IFDEF OS2}
var rc : APIRET;
{$ENDIF}

Begin
  If FHandle<>0 Then
    Begin
      {$IFDEF OS2}
      rc:=BseDos.DosCloseEventSem(FHandle);
      {$ENDIF}
      {$IFDEF Win32}
      WinBase.CloseHandle(FHandle);
      {$ENDIF}
      FHandle:=0;
    End;
End;

Function tcEventSemaphor.getPostCount : LongWord;

Begin
  {$IFDEF OS2}
  BseDos.DosQueryEventSem(fHandle, Result);
  {$ENDIF}
  {$IFDEF Win32}
  Result:=0;
  {$ENDIF}
End;


Function tcEventSemaphor.Post: Boolean;
Begin
  {$IFDEF OS2}
  Result:= (BseDos.DosPostEventSem(FHandle) <> BseErr.ERROR_INVALID_HANDLE);
  {$ENDIF}
  {$IFDEF Win32}
  Result:= WinBase.SetEvent(FHandle);
  {$ENDIF}
End;

Function tcEventSemaphor.Request(TimeOut:LongInt): Boolean;
Begin
  WaitFor(TimeOut);
End;

Function tcEventSemaphor.WaitFor(TimeOut: LongInt): Boolean;

{$IFDEF OS2}
Var rc : LongWord;
{$ENDIF}

Begin
  {$IFDEF OS2}
  rc:=BseDos.DosWaitEventSem(FHandle, TimeOut);
  Result:= (rc=BseErr.NO_ERROR);
  {$ENDIF}
  {$IFDEF Win32}
  Result:=WinBase.WaitForSingleObject(FHandle, TimeOut) In [WAIT_OBJECT_0,WAIT_ABANDONED];
  {$ENDIF}
End;

Function tcEventSemaphor.Release: Boolean;
Begin
  Result:=Reset;
End;

Function tcEventSemaphor.Reset: Boolean;

Begin
  {$IFDEF OS2}
  Result:=not (BseDos.DosResetEventSem(FHandle, fLastPostCount) In
                 [BseErr.ERROR_INVALID_HANDLE,BseErr.ERROR_ALREADY_RESET]);
  {$ENDIF}
  {$IFDEF Win32}
  Result:= WinBase.ResetEvent(FHandle);
  {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcMuxWaitSemaphor Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tcMuxWaitSemaphor.getCount : LongWord;

Begin
  result:=0;
  if fHandle=0 then exit;
  result:=fList.Count;
End;

Function tcMuxWaitSemaphor.Add(iSemaphor : tcSemaphor; iSemaphorId : LongWord) : LongInt;

{$IFDEF OS2}
Var rc    : APIRet;
    SemRec: SEMRECORD;
{$ENDIF}

Begin
  Result:=-1;
  if fHandle=0 then exit;

{$IFDEF OS2}
  SemRec.hsemCur:=iSemaphor.Handle;
  SemRec.ulUser:=iSemaphorId;
  rc:=BseDos.DosAddMuxWaitSem(fHandle, SemRec);
  if rc=NO_ERROR then
    Result:=fList.Add(iSemaphor);
{$ENDIF}
End;

Procedure tcMuxWaitSemaphor.Delete(iSemaphorIndex : LongInt);

{$IFDEF OS2}
var Sem : tcSemaphor;
    rc  : APIRET;
{$ENDIF}

Begin
{$IFDEF OS2}
  Sem:=fList.Items[iSemaphorIndex];
  rc:=bsedos.DosDeleteMuxWaitSem(fHandle, Sem.Handle);
  if rc=NO_ERROR then
    fList.Delete(iSemaphorIndex);
{$ENDIF}
End;

Function tcMuxWaitSemaphor.WaitFor(iTimeOut: LongInt; var iSemaphorID : LongWord): Boolean;

{$IFDEF OS2}
var rc : APIRET;
{$ENDIF}

Begin
  Result:=false;
  iSemaphorId:=0;
{$IFDEF OS2}
  rc:=bsedos.DosWaitMuxWaitSem(fHandle, iTimeOut, iSemaphorID);
  Result:=rc=NO_ERROR;
{$ENDIF}
End;

Constructor tcMuxWaitSemaphor.Create(Const iName:String; iShared: Boolean; iFlag : tMuxWaitSemaphorFlag);

Var cs:CString;
{$IFDEF OS2}
    flAttr:LongWord;
    rc    : APIRET;
{$ENDIF}

Begin
  inherited Create(iName);
  fShared:=iShared;
  fFlag:=iFlag;
  fList.Create;

  {$IFDEF OS2}
  If fShared
    Then flAttr:= BseDos.DC_SEM_SHARED
    Else flAttr:= 0;
  case fFlag of
    tMuxWaitSemFlagAll: flAttr:=flAttr or DCMW_WAIT_ALL;
    tMuxWaitSemFlagAny: flAttr:=flAttr or DCMW_WAIT_ANY;
  End;

  cs:=fName;
  rc:=BseDos.DosCreateMuxWaitSem(cs,fHandle, 0, nil, flAttr);
  case rc of
    NO_ERROR:
      fTyp:=SemaphorTypCreate;
    ERROR_DUPLICATE_NAME:
      Begin
        rc:=BseDos.DosOpenMuxWaitSem(cs, fHandle);
        if rc=NO_ERROR
          then fTyp:=SemaphorTypOpen
          else fTyp:=SemaphorTypNone;
      End;
  end;
  {$ENDIF}
  {$IFDEF WIN32}
  {$ENDIF}
End;

Destructor tcMuxWaitSemaphor.Destroy;

{$IFDEF OS2}
var rc : APIRET;
{$ENDIF}

Begin
  fList.Destroy;
  {$IFDEF OS2}
  rc:=BseDos.DosCloseMuxWaitSem(fHandle);
  {$ENDIF}
  Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcCriticalSection Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Constructor tcCriticalSection.Create;

Begin
  inherited Create;

  {$IFDEF OS2}
  //Nothing to do
  {$ENDIF}
  {$IFDEF Win32}
  WinBase.InitializeCriticalSection(FCRITICAL_SECTION);
  {$ENDIF}
End;

Destructor tcCriticalSection.Destroy;

Begin
  {$IFDEF OS2}
  //Nothing to do
  {$ENDIF}
  {$IFDEF Win32}
  WinBase.DeleteCriticalSection(FCRITICAL_SECTION);
  {$ENDIF}
  inherited Destroy;
End;


Function tcCriticalSection.Enter(TimeOut:LongWord): Boolean;

Begin
  {$IFDEF OS2}
  Result:= (BseDos.DosEnterCritSec=BseErr.NO_ERROR);
  {$ENDIF}
  {$IFDEF WIN32}
  WinBase.EnterCriticalSection(FCRITICAL_SECTION);
  Result:= TRUE;
  {$ENDIF}
End;

Function tcCriticalSection.Leave: Boolean;

Begin
  {$IFDEF OS2}
  Result:= (BseDos.DosExitCritSec= BseErr.NO_ERROR);
  {$ENDIF}
  {$IFDEF WIN32}
  WinBase.LeaveCriticalSection(FCRITICAL_SECTION);
  Result:= TRUE;
  {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcQueue Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Function tcQueue.WriteQueue(var iData; iDatalen : LongWord; iElemPriority : Byte) : Boolean;

Var pDaten : pByte;

Begin
  Result:=false;
  if fQueueCreate=false then exit;
  GetMem(pDaten, iDataLen);
  move(iData, pDaten^, iDataLen);
  Result:=DosWriteQueue(fQueueHandle, 0, iDataLen, pDaten^, iElemPriority) = NO_ERROR;
End;

Function tcQueue.ReadQueue(var iData; iGetData : Boolean) : LongWord;

var pDaten  : pByte;
    Request : RequestData;
    Priority: Byte;
    rc      : APIRET;

Begin
  Result:=0;
  if fQueueCreate=false then exit;
  if GetElements > 0 then
    Begin
      rc:=DosReadQueue(fQueueHandle, Request, Result, pDaten, 0, false, Priority, 0);
      if rc = NO_ERROR then
        Begin
          if iGetData then  { Beim Destroy des Objekts sind die Daten unwichtig }
            move(pDaten^, iData, Result);
          Freemem(pDaten, Result);
        End;
    End;
End;


function tcQueue.GetElements : LongWord;

Begin
  Result:=0;
  if fQueueCreate then
    DosQueryQueue(fQueueHandle, Result);
End;

constructor tcQueue.Create(iQueueName : String; iQueueTyp : tQueueTyp);

Var cQueueName : CString;
    QueueFlag  : LongWord;

Begin
  inherited Create;
  fQueueName:=PathQueue + iQueueName;
  cQueueName:=fQueuename;
  if iQueueTyp = tQue_FIFO
    then QueueFlag:=QUE_FIFO or QUE_CONVERT_ADDRESS or QUE_PRIORITY
    else QueueFlag:=QUE_LIFO; {or QUE_CONVERT_ADDRESS or QUE_PRIORITY;}
  fQueueCreate:=DosCreateQueue(fQueueHandle, QueueFlag, cQueueName) = NO_ERROR;
End;

destructor tcQueue.Destroy;

var Temp : Byte;

Begin
  if fQueueCreate then
    Begin
{ Loeschen alle Eintraege in der Queue }
      While GetElements > 0 do
        ReadQueue(Temp, false);
{ Queue schliessen }
      DosCloseQueue(fQueueHandle);
    End;
{ Objekt entgueltig zerstoeren }
  inherited Destroy;
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcQueueString Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Function tcQueueString.WriteQueue(iText : String; iElemPriority : Byte) : Boolean;

Begin
  fLastText:=iText;
  Result:=inherited WriteQueue(fLastText, length(iText)+1, iElemPriority);
End;

Function tcQueueString.ReadQueue : String;

Var Len : byte;

Begin
  Len:=inherited ReadQueue(Result, true);
  if Length(Result)<>(Len-1)
    then Result:='';  { Sollte nie vorkommen }
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tThread Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TThread.SetSuspended(NewValue:Boolean);
Begin
     If NewValue Then Suspend
     Else Resume;
End;

{$IFDEF OS2}
Const
  PArray:Array[TThreadPriority] Of LongWord=
         (PRTYC_IDLETIME,PRTYC_REGULAR,PRTYC_REGULAR,PRTYC_REGULAR,PRTYC_REGULAR,
          PRTYC_REGULAR,PRTYC_TIMECRITICAL);
  PDelta:Array[tpIdle..tpTimeCritical] Of LongWord=(0,-31,-16,0,16,31,0);
{$ENDIF}
{$IFDEF Win32}
Const  
  PArray:Array[TThreadPriority] Of LongWord=
         (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
          THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,THREAD_PRIORITY_HIGHEST,
          THREAD_PRIORITY_TIME_CRITICAL);
{$ENDIF}

Procedure TThread.SetPriority(NewValue:TThreadPriority);
Begin
     FPriority:=NewValue;
     {$IFDEF OS2}
     If ThreadId<>0 Then DosSetPriority(2,PArray[NewValue],PDelta[NewValue],ThreadId);
     {$ENDIF}
     {$IFDEF Win32}
     SetThreadPriority(FHandle,PArray[NewValue]);
     {$ENDIF}
End;

Procedure TThread.SyncTerminate;
Begin
     FOnTerminate(Self);
End;

Procedure TThread.DoTerminate;
Begin
     If FOnTerminate<>Nil Then Synchronize(SyncTerminate);
End;

Function ThreadLayer(Param:TThread):LongInt;
{$IFDEF OS2}
Var  PAppHandle:LongWord;
     PAppQueueHandle:LongWord;
{$ENDIF}
Var FreeTerm:Boolean;
Begin
     {$IFDEF OS2}
     Param.FThreadId:=System.GetThreadId;
     If ApplicationType=cApplicationType_GUI Then
     Begin
          PAppHandle := WinInitializeAPI(0);
          PAppQueueHandle := WinCreateMsgQueueAPI(PAppHandle,0);
     End;
     {$ENDIF}

     Param.Priority:=Param.FPriority;
     Param.Execute;
     Result:=Param.ReturnValue;
     FreeTerm:=Param.FreeOnTerminate;
     Param.FFinished:=True;
     Param.DoTerminate;
     If FreeTerm Then Param.Destroy;

     {$IFDEF OS2}
     If ApplicationType=cApplicationType_GUI Then
     Begin
          WinDestroyMsgQueueAPI(PAppQueueHandle);
          WinTerminateAPI(PAppHandle);
     End;
     {$ENDIF}

     System.EndThread(Result);
End;


Const
     ThreadWindow:LongWord=0;
     WM_EXECUTEPROC=WM_USER+1;

Var ThreadDefWndProc:Function(Win,Msg,para1,para2:LongWord):LongWord;APIENTRY;
    MsgProc:Procedure;
    ProcessProc:Procedure;

Procedure TThread.MsgIdle;
Begin
     ProcessProc;
End;

Function ThreadWndProc(Win:LongWord;Msg,para1,para2:LongWord):LongWord;APIENTRY;
Var Thread:TThread;
Begin
     If Msg=WM_EXECUTEPROC Then
     Begin
          Thread:=TThread(para1);
          Thread.FMethod;
          Result:=0;
     End
     Else
     Begin
          If @ThreadDefWndProc<>Nil Then Result:=ThreadDefWndProc(Win,Msg,para1,para2)
          Else
          Begin
              {$IFDEF OS2}
              Result:=WinDefWindowProc(Win,Msg,para1,para2);
              {$ENDIF}
              {$IFDEF Win32}
              Result:=DefWindowProc(Win,Msg,para1,para2);
              {$ENDIF}
          End;
     End;
End;


Constructor TThread.ExtCreate(CreateSuspended:Boolean;StackSize:LongWord;Priority:TThreadPriority;
                              Param:Pointer);
Var Options:LongWord;
Begin
     If ((ApplicationType=cApplicationType_GUI) And
         (ThreadWindow=0)) Then
     Begin
          ThreadDefWndProc:=Nil;
          {$IFDEF OS2}
          ThreadWindow:=WinCreateWCWindow(HWND_DESKTOP,
                                          WC_BUTTON,
                                          '',
                                          0,               //flStyle
                                          0,0,             //leave This ON 0 - Set by .Show
                                          0,0,             //Position And Size
                                          HWND_DESKTOP,    //parent
                                          HWND_TOP,        //Insert behind
                                          1,               //Window Id
                                          Nil,             //CtlData
                                          Nil);            //Presparams
          ThreadDefWndProc:=Pointer(WinSubClassWindow(ThreadWindow,@ThreadWndProc));
          {$ENDIF}
          {$IFDEF Win32}
          ThreadWindow:=CreateWindow('BUTTON',
                                     '',
                                     0,
                                     0,0,
                                     0,0,
                                     HWND_DESKTOP,
                                     1,
                                     DllModule,
                                     Nil);
          ThreadDefWndProc:=Pointer(SetWindowLong(ThreadWindow,GWL_WNDPROC,LongInt(@ThreadWndProc)));
          {$ENDIF}
     End;

     //Inherited Create;
     FSuspended:=CreateSuspended;
     Options:=0;
     If FSuspended Then Options:=Options Or THREAD_SUSPENDED;
     FPriority:=Priority;
     FParameter:=Param;
     FHandle:=BeginThread(Nil,StackSize,@ThreadLayer,Pointer(Self),Options,FThreadId);
End;

Constructor TThread.Create(CreateSuspended: Boolean);
Begin
     TThread.ExtCreate(CreateSuspended,65535,tpNormal,Nil);
End;

Destructor TThread.Destroy;
Begin
     If ((Not FFinished)And(Not FSuspended)) Then
     Begin
          Terminate;
          WaitFor;
     End
     Else If FSuspended Then
     Begin
          FFreeOnTerminate:=False;
          System.KillThread(FHandle);
     End;
     {$IFDEF Win32}
     If FHandle<>0 Then CloseHandle(FHandle);
     {$ENDIF}
     Inherited Destroy;
End;

Function TThread.WaitFor:LongInt;
Var FreeIt:Boolean;

Begin
  FreeIt:=FFreeOnTerminate;
  FFreeOnTerminate:=False;
  Repeat
        If ((ApplicationType=cApplicationType_GUI) And
            (MsgProc<>Nil))
          Then MsgProc
          Else
            {$IFDEF OS2}
            Dossleep(50);
            {$ENDIF}
            {$IFDEF Win32}
            Sleep(50);
            {$ENDIF}
  Until FFinished;
  Result:=ReturnValue;
  If FreeIt Then Self.Destroy;
End;

Procedure TThread.Terminate;
Begin
  FTerminated:=True;
End;

Procedure TThread.Suspend;
Begin
  FSuspended:=True;
  {$IFDEF OS2}
  DosSuspendThread(FHandle);
  {$ENDIF}
  {$IFDEF Win32}
  SuspendThread(FHandle);
  {$ENDIF}
End;

Procedure TThread.Resume;
Begin
  {$IFDEF OS2}
  If DosResumeThread(FHandle)=0 Then FSuspended:=False;
  {$ENDIF}
  {$IFDEF Win32}
  If ResumeThread(FHandle) = 1 Then FSuspended:=False;
  {$ENDIF}
End;

//nach M”glichkeit nicht benutzen (statt dessen Terminate !), "abwrgen" des Threads
//falls keine M”glichkeit zur Abfrage von "Terminated" besteht
Procedure TThread.Kill;
Var FreeTerm:Boolean;
Begin
  Suspend;
  System.KillThread(FHandle);
  FreeTerm:=FreeOnTerminate;
  FFinished:=True;
  DoTerminate;
  If FreeTerm Then Self.Destroy;
End;

Procedure TThread.ProcessMsgs;
Begin
  If ProcessProc<>Nil Then Synchronize(MsgIdle);
End;

Procedure TThread.Synchronize(method:TThreadMethod);
Begin
  //If @method<>@MsgIdle Then ProcessMsgs;
  //MsgIdle;
  If ThreadWindow<>0 Then
  Begin
       FMethod:=method;
       {$IFDEF OS2}
       WinSendMsg(ThreadWindow,WM_EXECUTEPROC,LongWord(Self),0);
       {$ENDIF}
       {$IFDEF Win32}
       SendMessage(ThreadWindow,WM_EXECUTEPROC,LongWord(Self),0);
       {$ENDIF}
  End
  Else method;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcPipeThread Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

procedure tcPipeThread.Execute;

Begin
  if fOnPipeExecuteStart<>nil then fOnPipeExecuteStart(Self);
  While (not fTerminated) do
    Begin
      PipeExecute;
      SysSleep(1000);  { Ein biแchen warten, damit der Client die Daten empfangen kann }
    End;
  if fOnPipeExecuteStop<>nil then fOnPipeExecuteStop(Self);
End;

constructor tcPipeThread.Create(iCreateSuspended: Boolean);

Begin
  fHandle:=0;
  inherited Create(iCreateSuspended);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcPipeServer Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

constructor tcPipeServer.Create(iLenBufferIn, iLenBufferOut : LongInt; iCreateSuspended: Boolean);

Begin
  fLenBufferIn  :=iLenBufferIn;
  fLenBufferOut :=iLenBufferOut;
  fSendBufferOut:=false;
  if fLenBufferIn>0 then
    fBufferIn.Create;
  if fLenBufferOut>0 then
    Begin
//      fBufferOutSem.Create(false, '');
      fBufferOut.Create;
    End;

  inherited Create(iCreateSuspended);
End;

Destructor tcPipeServer.Destroy;

Begin
{ Object zerstoeren }
  inherited Destroy;

{ Buffer-Speicher wieder freigeben }
  if fLenBufferIn>0 then
    fBufferIn.Destroy;
  if fLenBufferOut>0 then
    fBufferOut.Destroy;

End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcNamedPipeServer Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcNamedPipeServer.PipeExecute;

Var BytesRead   : LongWord;
    BufferInTemp: pByteArray;
    cou : LongWord;
{$IFDEF OS2}
var rc          : APIRET;
{$ENDIF}

Begin
// Connection aufbauen
  cou:=0;
  if fLenBufferIn>0 then
    GetMem(BufferInTemp, fLenBufferIn);

  While (not fTerminated) do
    Begin
{$IFDEF OS2}
// Verbinden des Servers mit der Pipe
      inc(cou);
      if ApplicationType=cApplicationType_GUI then  // WPS-Messages verarbeiten
        ProcessMsgs;
      rc:=DosConnectNPipe(fHandle);
      Repeat
// Warten bis ein Client in die Pipe schreibt. Dazu wird der Semaphor
// verwendet. Dieser wird vom Betriebsystem automatisch gesetzt.
        if fLenBufferIn>0 then
          Begin
            fSemaphor.Waitfor(100);
            fSemaphor.Reset;

// Daten einlesen
            rc:=DosRead(fHandle, BufferInTemp^, fLenBufferIn, BytesRead);
            if BytesRead<>0 then
              Begin
                fBufferIn.Clear;
                fBufferIn.Write(BufferInTemp^, BytesRead);
                fBufferIn.Seek(soFromBeginning,0);

// Event-Procedure ausfuehren
                if fOnPipeIn<>nil then fOnPipeIn(Self, 0);
              End;
          End;
// Den ausgehenden DatenBuffer in die Pipeschreiben
        if (fLenBufferOut > 0) and
           (fSendBufferOut=true) and
           (fBufferOut.Size > 0) then
          Begin
            fSendBufferOut:=true;
            fBufferOut.Seek(soFromBeginning,0);
            FileWrite(fHandle, fBufferOut.Memory^[0], fBufferOut.Size);
            fSendBufferOut:=false;
          End;

// Damit die anderen Prozesse auch dran kommen
        DosSleep(0);
      Until (fTerminated) or (BytesRead=0);
// Pipe wieder schliessen.
      rc:=DosDisConnectNPipe(fHandle);

{$ENDIF}
    End;

// Thread beenden
  Close;

// Speicher wieder freigeben
  if fLenBufferIn>0 then
    FreeMem(BufferInTemp, fLenBufferIn);

  ReturnValue:=0;
End;

Procedure tcNamedPipeServer.SendBufferOut;

Begin
  if fLenBufferOut=0 then exit;

// Warten bis das Schreiben erledigt ist.
  while fSendBufferOut do
    sysSleep(100);
// Variable fuer das Schreiben setzen, damit der Pipe-Thread das Schreiben durchfuehrt.
  fSendBufferOut:=true;
End;

Procedure tcNamedPipeServer.Resume;

var cPipeName : cString;

{$IFDEF OS2}
var CreateOpenMode: LongWord;
    CreatePipeMode: LongWord;
    rc            : APIRET;
{$ENDIF}

Begin
// Wenn notwendig die Pipe erstellen
  if fHandle=0 then
    Begin    // Pipe neu erstellen
      cPipeName:=fPipeName;

{$IFDEF OS2}

// Berechnung von CreateOpenMode
      case fAccess of
        tNamedPipeAccessOutBound: CreateOpenMode:=NP_ACCESS_OUTBOUND;
        tNamedPipeAccessInBound : CreateOpenMode:=NP_ACCESS_INBOUND;
        tNamedPipeAccessDuplex  : CreateOpenMode:=NP_ACCESS_DUPLEX;
      end;
      if fInherit
        then CreateOpenMode:=CreateOpenMode or NP_INHERIT
        else CreateOpenMode:=CreateOpenMode or NP_NOINHERIT;

      if fWriteBehind
        then CreateOpenMode:=CreateOpenMode or NP_WRITEBEHIND
        else CreateOpenMode:=CreateOpenMode or NP_NOWRITEBEHIND;

// Berechung von CreatePipeMode
      CreatePipeMode:=NP_NOWAIT;
      if fInstanceCount=0
        then CreatePipeMode:=CreatePipeMode or NP_UNLIMITED_INSTANCES
        else CreatePipeMode:=CreatePipeMode or fInstanceCount;


      case fReadModeType of
        tNamedPipeModeTypeByte   : CreatePipeMode:=CreatePipeMode or NP_READMODE_BYTE;
        tNamedPipeModeTypeMessage: CreatePipeMode:=CreatePipeMode or NP_READMODE_MESSAGE;
      End;

      case fWriteModeType of
        tNamedPipeModeTypeByte   : CreatePipeMode:=CreatePipeMode or NP_TYPE_BYTE;
        tNamedPipeModeTypeMessage: CreatePipeMode:=CreatePipeMode or NP_TYPE_MESSAGE;
      End;

// Nun die Pipe erstellen
      rc:=DosCreateNPipe(cPipeName, fHandle, CreateOpenMode, CreatePipeMode,
                         fLenBufferOut, fLenBufferIn, 500);
      if rc<>NO_ERROR then
        Begin
          Close;
          exit;
        End;

// Pipe und Semaphor verbinden.
      if fInstanceCount=0 then
        Begin // Es gibt keine limitierung der Instancen.
          fSemaphor.Create(true, '');
          rc:=DosSetNPipeSem(fHandle, fSemaphor.Handle, 0);
        End
      else    // Pipe hat eine Limitierte Anzahl von Instancen
        Begin
//      for Cou:=0 to
//      fSemaphor.Create(true, '', false);
//      rc:=DosSetNPipeSem(fHandle, fSemaphor.Handle, 1);
        End;

      if rc<>NO_ERROR then
        Begin // Fehler --> Die Pipe wieder entfernen.
          Close;
          exit;
        End;
{$ENDIF}
    End;

// Thread starten
  inherited Resume;
End;

Procedure tcNamedPipeServer.Suspend;

Begin
  Close;
  inherited Suspend;
End;

Procedure tcNamedPipeServer.Close;

{$IFDEF OS2}
var rc : APIRET;
{$ENDIF}

Begin
  if fHandle=0 then exit;

{$IFDEF OS2}
  rc:=DosDisConnectNPipe(fHandle);
  rc:=DosClose(fHandle);
{$ENDIF}
  fHandle:=0;
End;

Function tcNamedPipeServer.getSemStatus : tNamedPipeSemStatus;

{$IFDEF OS2}
var SemState  : PIPESEMSTATE;
{$ENDIF}

Begin
  Result:=tNamedPipeSemStatusNull;
  {$IFDEF OS2}
  bsedos.DosQueryNPipeSemState(fSemaphor.Handle, SemState, sizeof(PIPESEMSTATE));
  case SemState.fStatus of
    NPSS_EOI   : Result:=tNamedPipeSemStatusEoi;
    NPSS_RDATA : Result:=tNamedPipeSemStatusRData;
    NPSS_WSPACE: Result:=tNamedPipeSemStatusWSpace;
    NPSS_CLOSE : Result:=tNamedPipeSemStatusClose;
  end;
  {$ENDIF}
End;

constructor tcNamedPipeServer.Create(iPipeName : String; iLenBufferIn, iLenBufferOut : LongInt);

Begin
  fHandle:=0;

// Pipeanem ermitteln
  fPipeName:=uppercase(iPipeName);
  if pos(PathPipe,fPipeName)=0 then
    fPipeName:=PathPipe+fPipeName;

// Andere Variablen definieren
  fInstanceCount:=0;
  fSendBufferOut:=false;
  fReadModeType :=tNamedPipeModeTypeByte;
  fWriteModeType:=tNamedPipeModeTypeByte;
  fInherit      :=true;
  fWriteBehind  :=true;
  fSemaphor:=nil;
  if iLenBufferIn=0 then
    if iLenBufferOut=0 then
      exit
    else
      fAccess:=tNamedPipeAccessOutBound
  else
    if iLenBufferOut=0 then
      fAccess:=tNamedPipeAccessInBound
    else
      fAccess:=tNamedPipeAccessDuplex;
  inherited Create(iLenBufferIn, iLenBufferOut, true);
End;

Destructor tcNamedPipeServer.Destroy;

Begin
  Close;
  inherited Destroy;

//  rc:=WaitFor;
  if fSemaphor<>nil then
    fSemaphor.Destroy;
  fSemaphor:=nil;

End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcAnonymousPipeServer Class Implementation                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcAnonymousPipeServer.PipeExecute;

Var BytesRead   : LongWord;
    BufferInTemp: pByteArray;
    cou : LongWord;
{$IFDEF OS2}
var rc          : APIRET;
{$ENDIF}

Begin
  GetMem(BufferInTemp, fLenBufferIn);
  While (not fTerminated) do
    Begin
      if ApplicationType=cApplicationType_GUI then  // WPS-Messages verarbeiten
        ProcessMsgs;

// Daten einlesen
{$IFDEF OS2}
      rc:=DosRead(fHandleIn, BufferInTemp^, fLenBufferIn, BytesRead);
      if rc<>NO_ERROR then
        break;

      if BytesRead<>0 then
        Begin
          fBufferIn.Clear;
          fBufferIn.Write(BufferInTemp^, BytesRead);
          fBufferIn.Seek(soFromBeginning,0);

// Event-Procedure ausfuehren
          if fOnPipeIn<>nil then fOnPipeIn(Self, 0);
        End;
{$ENDIF}
    End;
End;

Procedure tcAnonymousPipeServer.SendBufferOut;

Begin
  fBufferOut.Seek(soFromBeginning,0);
  FileWrite(fHandleOut, fBufferOut.Memory^[0], fBufferOut.Size);
End;

Procedure tcAnonymousPipeServer.Resume;

{$IFDEF OS2}
var rc : APIRET;
{$ENDIF}

Begin
// Pipe anlegen
{$IFDEF OS2}
  rc:=DosCreatePipe(fHandleIn, fHandleOut, fLenBufferIn);
  if rc<>NO_ERROR then
    Begin
      Close;
      exit;
    End;
{$ENDIF}

// Thread jetzt starten
  inherited Resume;
End;

Procedure tcAnonymousPipeServer.Suspend;

Begin
Writeln('suspend');
  Close;
  inherited Suspend;
End;

Procedure tcAnonymousPipeServer.Close;

var ch: Char;
{$IFDEF OS2}
var rc: APIRET;
{$ENDIF}

Begin
// Damit DosRead ein Wert empfaengt und der Thread beendet wird.
  ch:=#0;
  FileWrite(fHandleOut, ch, 1);
{$IFDEF OS2}
  rc:=DosClose(fHandleIn);
  rc:=DosClose(fHandleOut);
{$ENDIF}
  fHandleIn:=0;
  fHandleOut:=0;
End;

constructor tcAnonymousPipeServer.Create(iLenBuffer : LongInt);

Begin
  fHandle:=0;
  fHandleIn:=0;
  fHandleOut:=0;
  inherited Create(iLenBuffer, iLenBuffer, true);
End;

Destructor tcAnonymousPipeServer.Destroy;

Begin
  Close;
  inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcPipeClient Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

constructor tcPipeClient.Create;

Begin
  inherited Create(true);
End;

/*
Destructor tcPipeClient.Destroy;

Begin
  inherited Destroy;
End;
*/


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcNamedPipeClient Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcNamedPipeClient.Resume;

var cPipeName : cString;
{$IFDEF OS2}
    rc        : APIRET;
    Action    : LongWord;
{$ENDIF}

Begin
  if fHandle=0 then
    Begin
      cPipeName:=fPipeName;
{$IFDEF OS2}
      Action:=0;
      rc:=DosOpen(cPipeName,            // Namen der Pipe
                  fHandle,              // Handle der Pipe
                  Action,               // Rueckgabewert von DosOpen
                  0,                    // Dateigroesse
                  FILE_NORMAL,          // Open-Flags
                  OPEN_ACCESS_READONLY, // Zugriff aus die Pipe
                  OPEN_SHARE_DENYNONE,  // Zugriff fuer andere Prozesse
                  nil);                 // Erweiterte Attribute
      if rc<>NO_ERROR then
        Begin // Fehler --> Die Pipe wieder entfernen.
          Close;
          exit;
        End;
{$ENDIF}
    End;
    close;
// Starten des Threads
  inherited Resume;
End;

Procedure tcNamedPipeClient.Suspend;

Begin
  Close;
  inherited Suspend
End;

Procedure tcNamedPipeClient.PipeExecute;

Begin
  Writeln('PipeClient');
  if ApplicationType=cApplicationType_GUI then  // WPS-Messages verarbeiten
    ProcessMsgs;

End;

Procedure tcNamedPipeClient.Close;

{$IFDEF OS2}
var rc : APIRET;
{$ENDIF}

Begin
  if fHandle=0 then exit;

{$IFDEF OS2}
  rc:=DosClose(fHandle);
{$ENDIF}
  fHandle:=0;
End;

constructor tcNamedPipeClient.Create(iPipeName : String);

Begin
// Pipeanem ermitteln
  fPipeName:=uppercase(iPipeName);
  if pos(PathPipe,fPipeName)=0 then
    fPipeName:=PathPipe+fPipeName;

// Thread erstellen
  inherited Create;
End;

destructor tcNamedPipeClient.Destroy;

Begin
  inherited Destroy;
End;



/*Function tcNamedPipeClient.PipeOpen : LongInt;
{ Oeffnet die Pipe. }

{$IFDEF OS2}
Var FileNameZ  : cstring[256];
    rc         : ApiRet;
    ActionTaken: LongWord;
{$ENDIF}

Begin
{$IFDEF OS2}
  FileNameZ := fPipeName;
  repeat
    dosSleep(50);
    rc:=DosOpen(FileNameZ, fHPipe, ActionTaken, 0, 0,
                OPEN_ACTION_OPEN_IF_EXISTS, fmShareDenyNone, nil);
  Until rc <> ERROR_PIPE_BUSY;
  if rc = NO_ERROR
    then Result:=fHPipe
    else Result:=-RC;
{$ENDIF}
End;

*/


/*
Function tcPipeClient.SendBuffer : Boolean;

{$IFDEF OS2}
Var pcbActual : ULong;
    BufferTemp: PByteArray;
    rc        : APIRet;
{$ENDIF}

Begin
{$IFDEF OS2}
  if fTransfer then
    Begin                { Ein andere Thread schickt gerade was }
      Result:=false;
      exit;
    End;
  fTransfer:=true;
  if fBuffer.Size > fLenBufferOut then                { Die Daten sind zu gross }
    Begin
      Result:=false;
      exit;
    End;
  if PipeOpen < 0 then
    Begin
      Result:=false;
      exit;
    End;
  getmem(BufferTemp, fLenBufferIn);                   { Speicherberiech allokieren }
  DosEnterCritSec;                                    { Kritischer-Teil: Kein Prozess/Thread wechsel }
  rc:=DosTransactNPipe(fHPipe, fBuffer.Memory^[0], fBuffer.Size, BufferTemp^, fLenBufferIn, pcbActual);
  fBuffer.Clear;                                      { Buffer loeschen }
  fBuffer.Write(BufferTemp^, pcbActual);              { Pipe-Daten in den Bufer kopieren }
  while rc=ERROR_MORE_DATA do                         { Daten solange lesen bis in der Pipe nichts mehr steht }
    Begin
      rc:=DosRead(fHPipe, BufferTemp^, fLenBufferIn, pcbActual);
      fBuffer.Write(BufferTemp^, pcbActual);
    End;
  Result:= rc = NO_ERROR;
  DosExitCritSec;                                     { Ende des Kritischen-Teils }
  fBuffer.Seek(0, soFromBeginning);                   { An den Anfang der Pipe }
  PipeClose;
  freemem(BufferTemp, fLenBufferIn);                  { Speicher wieder freigeben }
  fTransfer:=false;
{$ENDIF}
End;

Procedure tcPipeClient.PipeClose;
{ Schliesst die Pipe wieder}

Begin
{$IFDEF OS2}
  DosClose(fHPipe);
  fHPipe:=0;
{$ENDIF}
End;

Function tcPipeClient.GetPipeServer: String;
{ Ermittelt aus den Pipename den Pipe-Server }

Begin
  Result:='';
{$IFDEF OS2}
  if (fPipeName[1] = '\') and (fPipeName[2] = '\') then
    Begin
      Result:=copy(fPipename, 3, 255);
      Result[0]:=chr(pos('\', Result)-1);
    End;
{$ENDIF}
End;

Function tcPipeClient.GetInfo : Boolean;

{$IFDEF OS2}
var BufferTemp : PByteArray;
    InfoBuf    : ^PipeInfo absolute BufferTemp;

Const Len_Info = 1024;
{$ENDIF}

Begin
{$IFDEF OS2}
  if PipeOpen < 0
    then Result:=false
    else
      Begin
        getmem(BufferTemp, Len_Info);              { Speicherberiech allokieren }
        Result:=DosQueryNPipeInfo(fHPipe, 1, BufferTemp^, Len_Info) = NO_ERROR;
        fLenBufferIn:=InfoBuf^.cbOut;              { Groesse der Daten die in das Programm hereinkommen }
        fLenBufferOut:=InfoBuf^.cbIn;              { Groesse der Daten die aus dem Programm herauskommen }
        freemem(BufferTemp, Len_Info);             { Speicher wieder freigeben }
        PipeClose;
      End;
  DosSleep(500);
{$ENDIF}
{$IFDEF Win32}
  Result:=false;
{$ENDIF}
End;

constructor tcPipeClient.Create(iComputerName, iPipeName : String);

Begin
{$IFDEF OS2}
  if iComputername = ''
    then fPipeName:=PathPipe+iPipeName
    else fPipeName:='\\' + iComputerName  + PathPipe + iPipeName;
  fBuffer.Create;
  if GetInfo = false then              { Info ueber die Pipe lesen }
    Begin
      EFOpenError.Create(LoadNLSStr(SStreamOpenErrorText));
      exit;
    End;
{$ENDIF}
  inherited Create;
End;

destructor tcPipeClient.Destroy;

Begin
{$IFDEF OS2}
  PipeClose;
  fBuffer.Destroy;
{$ENDIF}
  inherited Destroy;
End;

*/

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcJoystick Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
type trGameStatus = Record
       Joystick    : Array[1..cMaxJoystick, 1..2] of Word;
       BtnCount    : Array[1..cMaxJoystick, 1..cMaxJoystickBtn] of Word;
       ButtonMask  : Byte;
       ButtonStatus: Byte;
       Ticks       : LongWord;
     End;

Const PORT_NAME                = 'GAME$';
      IOCTL_CAT_USER           = $080;
      GAME_GET_VERSION         = $001;
      GAME_GET_PARMS           = $002;
      GAME_SET_PARMS           = $003;
      GAME_GET_CALIB           = $004;
      GAME_SET_CALIB           = $005;
      GAME_GET_DIGSET          = $006;
      GAME_SET_DIGSET          = $007;
      GAME_GET_STATUS          = $010;
      GAME_GET_STATUS_BUTWAIT  = $011;
      GAME_GET_STATUS_SAMPWAIT = $012;
      GAME_PORT_GET            = $020;
      GAME_RESET_PORT          = $060;

      JOY_AX_BIT               = $001;
      JOY_AY_BIT               = $002;
      JOY_BX_BIT               = $004;
      JOY_BY_BIT               = $008;

      JOY_BUT_BIT : Array[1..cMaxJoystick, 1..cMaxJoystickBtn] of Word =
                      (($010, $020),($040,$080));

{      JOY_A_BITS                      = (JOY_AX_BIT OR JOY_AY_BIT);
      JOY_B_BITS                      = (JOY_BX_BIT OR JOY_BY_BIT);
      JOY_ALLPOS_BITS                 = (JOY_A_BITS OR JOY_B_BITS);
      JOY_ALL_BUTS                    = (JOY_BUT1_BIT OR JOY_BUT2_BIT OR JOY_BUT3_BIT OR JOY_BUT4_BIT); }
{$ENDIF}

Function tcJoystick.getDigital(iJoy : Byte) : trDigJoystick;
{ Umwandeln der Position vom Joystick in ein
  Byte-Position und in "joy_Left", "joy_Center" und
  "joy_Right" }

  Function DigBerechnung(iBytePos : Byte) : tDigJoystickLCR;

  Begin
    Case iBytePos of
      0..95    : Result:=joy_Left;
      156..255 : Result:=joy_right;
      else       Result:=joy_center;
    End;
  End;

Begin
  fStatus[iJoy].Center.X:=(fStatus[iJoy].Low.X + fStatus[iJoy].High.X) div 2;
  fStatus[iJoy].Center.Y:=(fStatus[iJoy].Low.Y + fStatus[iJoy].High.Y) div 2;
  if (fStatus[iJoy].Center.X>0) and (fStatus[iJoy].Center.Y>0)
    then
      Begin
        Result.PosByte.X:= (128 / fStatus[iJoy].Center.X) * fStatus[iJoy].Pos.X;
        Result.PosByte.Y:= (128 / fStatus[iJoy].Center.Y) * fStatus[iJoy].Pos.Y;
        Result.DigX:=DigBerechnung(Result.PosByte.X);
        Result.DigY:=DigBerechnung(Result.PosByte.Y);
      End
    else
      Begin
        Result.PosByte.X:= 128;
        Result.PosByte.Y:= 128;
        Result.DigX:=joy_center;
        Result.DigY:=joy_center;
      End;
End;

Function tcJoystick.GetGameVersion: LongWord;
{ Liefert die Joystick-Version }

{$IFDEF OS2}
Var Len : LongWord;
{$ENDIF}

Begin
{$IFDEF OS2}
  if fGamePort = 0
    then Result:=0
    else DosDevIOCTL(fGameport,
                       IOCTL_CAT_USER,
                       GAME_GET_VERSION,
                       NIL, 0, NIL,
                       Result,
                       4,
                       Len);
{$ENDIF}
{$IFDEF Win32}
  Result:=0;
{$ENDIF}
End;

Function tcJoystick.ReadStatus : Boolean;
{ Liest den Status des Joysticks ein und berechnet die Variablen vom Object }

{$IFDEF OS2}
var GameStatus : trGameStatus;
    Len        : LongWord;
    Cou1, Cou2 : Byte;
{$ENDIF}

Begin
  if fGamePort = 0 then
    Begin   
      Result:=false;
      exit;
    End;
{$IFDEF OS2}
  Result:=DosDevIOCTL(fGameport,
                   IOCTL_CAT_USER,
                   GAME_PORT_GET,
                   NIL,
                   0,
                   NIL,
                   GameStatus,
                   SizeOf(trGameStatus),
                   Len) = 0;
  if Result then
    Begin
      fTicks := GameStatus.Ticks;
      for Cou1:=1 to cMaxJoystick do
        Begin
          fOldPos := fStatus[Cou1].Pos;
          fStatus[Cou1].Pos.X := (fOldPos.X + GameStatus.Joystick[Cou1,1]) div 2;
          fStatus[Cou1].Pos.Y := (fOldPos.Y + GameStatus.Joystick[Cou1,2]) div 2;
          for Cou2:=1 to cMaxJoystickBtn do
            Begin
              fStatus[Cou1].Button[Cou2].Press:=
                   (GameStatus.ButtonStatus and JOY_BUT_BIT[Cou1, Cou2]) = JOY_BUT_BIT[Cou1, Cou2];
              fStatus[Cou1].Button[Cou2].Count:=GameStatus.BtnCount[Cou1, Cou2]
            End;
          if (fStatus[Cou1].Center.X <> 0) and
             (fStatus[Cou1].Center.Y <> 0) then
            Begin
              if fStatus[Cou1].Pos.X < fStatus[Cou1].Low.X  then
                fStatus[Cou1].Low.X := fStatus[Cou1].Pos.X;
              if fStatus[Cou1].Pos.Y < fStatus[Cou1].Low.Y  then
                fStatus[Cou1].Low.Y := fStatus[Cou1].Pos.Y;

              if fStatus[Cou1].Pos.X > fStatus[Cou1].High.X  then
                fStatus[Cou1].High.X := fStatus[Cou1].Pos.X;
              if fStatus[Cou1].Pos.Y > fStatus[Cou1].High.Y  then
                fStatus[Cou1].High.Y := fStatus[Cou1].Pos.Y;
            End;

        End;
    End;
{$ENDIF}
End;

Constructor tcJoystick.Create;
{ Generieren des Objekts und Oeffnen des Joystick-Ports }

{$IFDEF OS2}
Var rc    : APIRET;
    Action: LongWord;
    Cou   : Byte;
{$ENDIF}

Begin
  inherited Create;
{$IFDEF OS2}
  fGameport := 0;
  Action    := 0;
  rc := DosOpen(PORT_NAME,
                fGameport,     { Filehandle}
                Action,        { action taken}
                0,             { FileSize}
                FILE_READONLY, { FileAttribute}
                FILE_OPEN,     { OPEN_ACTION_CREATE_IF_NEW, (OpenFlag) }
                OPEN_SHARE_DENYNONE OR OPEN_ACCESS_READONLY,
                NIL);          {EABUF}
  if rc<>0 then
    Begin
      fGameport :=0;
    End;
  FillChar(fStatus, sizeof(trJoystickStatus),#0);
  ReadStatus;
  ReadStatus;
  for Cou:=1 to cMaxJoystick do
    Begin
      fStatus[Cou].Center := fStatus[Cou].Pos;
      fStatus[Cou].Low.X :=fStatus[Cou].Center.X div 10;
      fStatus[Cou].Low.Y :=fStatus[Cou].Center.Y div 10;
      fStatus[Cou].High.X :=fStatus[Cou].Center.X * 2.2;
      fStatus[Cou].High.Y :=fStatus[Cou].Center.Y * 2.2;
    End;
{$ENDIF}
{$IFDEF Win32}
  fGameport:=0;
{$ENDIF}
End;

Destructor tcJoystick.Destroy;
{ Schliessen des Porrs und zerst”ren des Objekts }

Begin
{$IFDEF OS2}
  if fGamePort <>0 then
    DosClose(fGamePort);
{$ENDIF}
  inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcUSBCalls Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Constructor tcUSBCalls.Create;

Begin
  inherited Create('USBCALLS');
  Upper:=false;
  if DLLLoaded then
    Begin
       fUsbFunc.UsbQueryDeviceReport         :=pointer(GetProcAddress('UsbQueryDeviceReport'));
       fUsbFunc.UsbQueryNumberDevices        :=pointer(GetProcAddress('UsbQueryNumberDevices'));
       fUsbFunc.UsbBulkRead                  :=pointer(GetProcAddress('UsbBulkRead'));
       fUsbFunc.UsbIsoStart                  :=pointer(GetProcAddress('UsbIsoStart'));
       fUsbFunc.UsbIrqStart                  :=pointer(GetProcAddress('UsbIrqStart'));
       fUsbFunc.UsbBulkWrite                 :=pointer(GetProcAddress('UsbBulkWrite'));
       fUsbFunc.UsbIsoDequeue                :=pointer(GetProcAddress('UsbIsoDequeue'));
       fUsbFunc.UsbCtrlMessage               :=pointer(GetProcAddress('UsbCtrlMessage'));
       fUsbFunc.UsbDeregisterNotification    :=pointer(GetProcAddress('UsbDeregisterNotification'));
       fUsbFunc.UsbIsoGetLength              :=pointer(GetProcAddress('UsbIsoGetLength'));
       fUsbFunc.UsbIsoPeekQueue              :=pointer(GetProcAddress('UsbIsoPeekQueue'));
       fUsbFunc.UsbOpen                      :=pointer(GetProcAddress('UsbOpen'));
       fUsbFunc.UsbRegisterChangeNotification:=pointer(GetProcAddress('UsbRegisterChangeNotification'));
       fUsbFunc.UsbClose                     :=pointer(GetProcAddress('UsbClose'));
       fUsbFunc.UsbRegisterDeviceNotification:=pointer(GetProcAddress('UsbRegisterDeviceNotification'));
       fUsbFunc.UsbIsoStop                   :=pointer(GetProcAddress('UsbIsoStop'));
       fUsbFunc.UsbIrqStop                   :=pointer(GetProcAddress('UsbIrqStop'));
    End
End;

Function tcUSBCalls.DeviceNr(iVendorID, iProductID : LongWord; Var iDeviceNr : LongWord) : ApiRet;

var NumDev    : LongWord;
    CouDev    : LongWord;
    CharBuffer: tChr4000;
    LenBuffer : longWord;
    Usb_device_descriptor : tpUsb_device_descriptor;

Begin
  iDeviceNr:=0;
  Result:=fUsbFunc.UsbQueryNumberDevices(NumDev);
  if Result <> NO_ERROR then exit;

  for CouDev:=1 to NumDev do
    Begin
      lenBuffer:=sizeof(CharBuffer);
      Result:=fUsbFunc.UsbQueryDeviceReport(CouDev, LenBuffer, CharBuffer);
      if Result <> NO_ERROR then exit;

      Usb_device_descriptor:=@CharBuffer;
      if (Usb_device_descriptor^.idVendor = iVendorID) and
         (Usb_device_descriptor^.idProduct= iProductID) then
        Begin
          iDeviceNr := CouDev;
          exit;
        End;
    End;
End;

Function tcUSBCalls.SetConfiguration(iUsbHandle : tUsbHandle; iConfigurationValue: Byte) : ApiRet;

Begin
  Result:=fUsbFunc.UsbCtrlMessage(iUsbHandle, $00, $09, iConfigurationValue, 0, 0, nil, 0);
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcWinFunc Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF Win32}
Constructor tcWinFunc.Create;

Begin
  inherited Create('WINFUNC');
  Upper:=false;
  if DLLLoaded then
    Begin
      fWinFunc.CreateLinkProgramsPrivate :=pointer(GetProcAddress('_CreateLinkProgramsPrivate'));
      fWinFunc.CreateLinkProgramsPublic  :=pointer(GetProcAddress('_CreateLinkProgramsPublic'));
      fWinFunc.CreateLinkStartupPrivate  :=pointer(GetProcAddress('_CreateLinkStartupPrivate'));
      fWinFunc.CreateLinkStartupPublic   :=pointer(GetProcAddress('_CreateLinkStartupPublic'));
      fWinFunc.CreateLinkDesktopPrivate  :=pointer(GetProcAddress('_CreateLinkDesktopPrivate'));
      fWinFunc.CreateLinkDesktopPublic   :=pointer(GetProcAddress('_CreateLinkDesktopPublic'));
      fWinFunc.CreateLinkStartmenuPrivate:=pointer(GetProcAddress('_CreateLinkStartmenuPrivate'));
      fWinFunc.CreateLinkStartmenuPublic :=pointer(GetProcAddress('_CreateLinkStartmenuPublic'));
      fWinFunc.DeleteLinkProgramsPrivate :=pointer(GetProcAddress('_DeleteLinkProgramsPrivate'));
      fWinFunc.DeleteLinkProgramsPublic  :=pointer(GetProcAddress('_DeleteLinkProgramsPublic'));
      fWinFunc.DeleteLinkStartupPrivate  :=pointer(GetProcAddress('_DeleteLinkStartupPrivate'));
      fWinFunc.DeleteLinkStartupPublic   :=pointer(GetProcAddress('_DeleteLinkStartupPublic'));
      fWinFunc.DeleteLinkDesktopPrivate  :=pointer(GetProcAddress('_DeleteLinkDesktopPrivate'));
      fWinFunc.DeleteLinkDesktopPublic   :=pointer(GetProcAddress('_DeleteLinkDesktopPublic'));
      fWinFunc.DeleteLinkStartmenuPrivate:=pointer(GetProcAddress('_DeleteLinkStartmenuPrivate'));
      fWinFunc.DeleteLinkStartmenuPublic :=pointer(GetProcAddress('_DeleteLinkStartmenuPublic'));
    End;
End;
{$ENDIF}
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcLog Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcLog.SetLog(iValue : Boolean);

Begin
  flog:=true;
  if iValue
    then tcLog.Writeln('Log: Turn on')
    else tcLog.Writeln('Log: Turn off');
  fLog:=iValue;
End;

Procedure tcLog.setWriteScreen(iValue : Boolean);

Begin
  fWriteScreen:= (iValue) and
                 (ScreenInOut.ClassName='TWinCrtScreenInOutClass');
End;

Procedure tcLog.Write(iText : String);

Begin
  fLastWrite := fLastWrite + iText;
End;

Procedure tcLog.Writeln(iText : String);

var TxtFile : File;

Begin
  if fLog then
    Begin
      iText:=NowStr + ': ' + fLastWrite + iText+#13+#10;

      if fWriteScreen then System.Writeln('Log:', iText);

      Assign(TxtFile, fFilename);
      Append(TxtFile);
      BlockWrite(TxtFile,iText[1],length(iText));
      Close(TxtFile);
    End;
  fLastWrite:='';
End;

Constructor tcLog.Create(iFilename : tFilename);

var TxtFile : File;

Begin
  inherited Create;

{ Log-Filename definieren }
  fFileName:=upperCase(iFilename);
  if pos('.LOG', fFilename) =0 then   // Bei einbinden von uSysInfo --> Probleme beim
    fFilename:=fFilename + '.LOG';    // Windows-Compiler
  fFilename:=ExpandFileName(fFilename);

{ Befuellen der Klassen-Variablen }
  fLog:=true;
  setWriteScreen(true);

{ Schreiben des Log-Headers }
  Assign(TxtFile, fFilename);
  Rewrite(TxtFile,0);
  Close(TxtFile);
  tcLog.Writeln('Log gestartet: ' + fFilename);
End;

Destructor tcLog.Destroy;

Begin
  if fLastWrite<>'' then   { Damit die Daten von fLastWrite geschrieben werden }
    tcLog.Writeln('');
  tcLog.Writeln('Log gestoppt: ' + fFilename);
  inherited Destroy;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcFileSearch Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tcFileSearch.ChkDatei(iFileInfo : trFileInfo) : Boolean;

Var Cou : LongInt;

Begin
  Result:=false;
  if (fChkDate) and
     ((iFileInfo.Time > fDateBefore) and
      (iFileInfo.Time < fDateSince)) then
    Exit;
  iFileInfo.Name:=uppercase(iFileInfo.Name);
  for cou:=0 to fFileNameExc.Count-1 do
    if StrMatch(fFileNameExc.Strings[cou], iFileInfo.Name, '*', '?') then
      exit;
  Result:=true;
End;

Procedure tcFileSearch.Start;

Const cfaScanDir = faDirectory or faMustDirectory;

Var DirStr     : tStringList;

  Function ScanPath(iPath : tFilename) : Boolean;

  Var SearchRec : tSearchRec;
      SubPath   : tFilename;

  Begin
    Result:=false;
    if FindFirst(iPath+'*.*',cfaScanDir, SearchRec) < 0
      then exit
      else
        Repeat
          if (Searchrec.Name[1]<>'.') then
            Begin
              SubPath:=iPath+SearchRec.Name+'\';
              DirStr.Add(SubPath);
              if Scanpath(SubPath)=false then exit;
            End;
        Until FindNext(SearchRec)<0;
    Result:=true;
  End;

Var Cou, Cou1: LongInt;
    AktDatei : tFilename;
    AktPath  : tFilename;
    AktMask  : String;
    FileInfo : trFileInfo;
    FiSearchRec: tSearchRec;

Begin
  DirStr.Create;
  For Cou:=0 to fFileList.Count-1 do
    Begin
      DirStr.Clear;
      AktDatei:=Uppercase(fFileList.Strings[Cou]);
      AktPath :=AddPathSeparator(ExtractFilePath(AktDatei));
      AktMask :=ExtractFilename(AktDatei);
      DirStr.add(AktPath);

      if (fRecursiv=false) or (ScanPath(AktPath)) then
        for Cou1:=0 to DirStr.Count-1 do
          Begin
            AktPath:=DirStr.Strings[Cou1];
            If FindFirst(AktPath+AktMask, faAnyFile, FiSearchRec) = 0
              then
                Begin
                  Repeat
                    if (FiSearchRec.Name <> '.') and
                       (FiSearchRec.Name <> '..') and
                        not ((FiSearchrec.Attr and faDirectory) = faDirectory) then
                      Begin
                        FileInfo.Path:=AktPath;
                        FileInfo.Name:=FiSearchRec.Name;
                        FileInfo.Attr:=FiSearchRec.Attr;
                        FileInfo.Size:=FiSearchRec.Size;
                        FileInfo.Time:=FileDateToDateTime(FiSearchRec.Time);
                        if ChkDatei(FileInfo) then
                          fOnFileSearch(self, FileInfo);
                      End;
                  Until FindNext(FiSearchRec)<>0;
                  FindClose(FiSearchRec);
                End
              else fOnError(self, AktPath, AktMask);
          End;
    End;
  DirStr.Destroy;
End;

Function tcFileSearch.CnvParamDt(iStr : String; var iDtm : tDatetime) : Boolean;

var len,ps: Byte;
    StrDT : tStr10;
    StrTM : tStr8;

Begin
  Result:=false;
  len:=length(iStr);
  if (iStr[1]<>'(') or (iStr[len]<>')') then exit;
  iStr:=Copy(iStr, 2, len-2);
  ps:=pos(':',iStr);
  if ps=0 then exit;
  StrDT:=Copy(iStr,1,ps-1);
  StrTM:=Copy(iStr,ps+1,len-ps);
  if (StrDT='') or (StrTM='') then exit;
  try
    iDtm:=StrToDate(StrDT);
    iDtm:=iDtm+StrToTime(StrTM);
  except
    iDtm:=0;
    exit;
  end;
  Result:=true;
End;

Function tcFileSearch.SetStrDateSince(iStrDate : String) : Boolean;

var dtm : tDateTime;

Begin
  Result:=CnvParamDt(iStrDate, dtm);
  if Result then fDateSince:=dtm;
End;

Function tcFileSearch.SetStrDateBefore(iStrDate : String): Boolean;

var dtm : tDateTime;

Begin
  Result:=CnvParamDt(iStrDate, dtm);
  if Result then fDateBefore:=dtm;
End;

Constructor tcFileSearch.Create;

Begin
  inherited Create;
  fFileList.Create;
  fFileNameExc.Create;
  fRecursiv:=false;
End;

Destructor tcFileSearch.Destroy;

Begin
  fFileList.Destroy;
  fFileNameExc.Destroy;
  fFileList   :=nil;
  fFileNameExc:=nil;
  fDateBefore :=1E+06; { also fast ins Unendlichen }
  fDateSince  :=0;
  inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcExec Class Implementation                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcExec.AddParameter(Const iParameter : String);

Begin
  fParameters.Add(iParameter);
end;

Function tcExec.GetParameter2AnsiString : AnsiString;

var cou : LongInt;

Begin
  Result:='';
  for cou:=0 to fParameters.Count-1 do
    Result:=Result+fParameters.Strings[cou]+' ';
End;

Function tcExec.getProgramFromUrl(Const url : String; Var urlProgram : tFilename) : Boolean;

Var pdb   : Byte;
    UrlTyp: String;
    Path  : tFilename;

Begin
  UrlProgram:='';
  pdb:=pos(':',url);
  if pdb=2 then
    Begin
      UrlProgram:=url;
      result:=false;
      exit;
    end;

  result:=true;
  UrlTyp:=UpperCase(Copy(url, 1, pdb-1));
  if UrlTyp='HTTP' then
    urlProgram:=goSysInfo.SysAppInfo.DefaultBrowser
  else if UrlTyp='FTP' then
    urlProgram:=goSysInfo.SysAppInfo.DefaultBrowser
  else
    Begin
      urlProgram:=url;
      exit;    // Damit der Pfad nicht gendert wird
    end;
  path:=ExtractFilePath(urlProgram);
  path[0]:=chr(ord(path[0])-1);
  chdir(path);
End;

{$IFDEF OS2}
Imports
  FUNCTION DosExecPgm2(pObjname:POINTER;cbObjname:LONG;execFlag:ULONG;
                    pArg,pEnv:PCHAR ; VAR pRes:RESULTCODES;
                    CONST pName:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 283;
End;

Function tcExec.StartProgramOS2 : LongInt;

type tdata = record
             d1: word;
             d2: word
           end;


VAR aStartData  : STARTDATA;
    ObjectBuffer: CSTRING;
    SessID      : LONGWORD;
    SessPID     : LongWord;
    eresult     : RESULTCODES;

    tib:PTIB;
    pib:PPIB;
    QueueHandle:HQUEUE;
    PIDS: STRING;
    QUE_NAME:CSTRING;

    Request:REQUESTDATA;         /* Request-identification data */
    DataLength:ULONG;            /* Length of element received */
    DataAddress : POINTER;       /* Address of element received */
    ElementCode : ULONG;         /* Request a particular element */
    NoWait      : BOOL;          /* No wait if queue is empty */
    ElemPriority: BYTE;          /* Priority of element received */

    SEM_NAME    : CSTRING;
    SemHandle   : HEV;           /* Semaphore handle */
    flAttr      : ULONG;         /* Creation attributes */
    fState      : BOOLEAN;       /* Initial state of semaphore */
    ulPostCt    : LONGWORD;      /* Current post count for the semaphore */

    Queue       : QMSG;          { Message-Queue }
    ahab        : hab;

    rc          : APIRET;        /* Return code */
    rdata       : ^tdata;

    cPrg        : cString;       // Programname (Path+File)
    cTitle      : cString;       // Title from the program
    prg         : String;        // Programname
    inh         : Word;

    Parameter   : AnsiString;
    LenParam    : LongWord;
    cpParam     : PChar;
    cpParam1    : PChar;

// Variables for Pipes
    SaveStdIn   : HFile;
    SaveStdOut  : HFile;
    SaveStdErr  : HFile;
    NewStdHandle: HFile;

Begin
  Result    :=0;
  fSessionID:=0; // Session-ID
  fProcessID:=0; // Prozess-ID
  fThreadID :=0; // Thread-ID
  cTitle:=fTitle;

// Paramater in ein C-String umwandeln
  Parameter:=getParameter2AnsiString;
  LenParam :=Length(Parameter);

// Link-Support
  if (fUrlSupport) and (getProgramFromUrl(fFileName, prg))
    then
      Begin
        LenParam:=Length(fFileName)+LenParam+1;
        GetMem(cpParam, LenParam);
        strPCopy(cpParam,fFileName+' ');
        StrACopy(@cpParam^[Length(fFileName)+1], Parameter);
        cPrg:=prg;
        inh :=SSF_INHERTOPT_PARENT;
      End
    else
      Begin
        GetMem(cpParam, LenParam);
        StrACopy(cpParam, Parameter);
        cPrg:=fFileName;
        inh :=SSF_INHERTOPT_SHELL;
      End;

// PipeServer angegeben  --> StdIn/Stdout/StdErr umlenken
  if fPipeServer<>nil then
    Begin
      SaveStdIn:=-1;
      SaveStdOut:=-1;
      SaveStdErr:=-1;
      rc:=DosDupHandle(0, SaveStdIn);
      rc:=DosDupHandle(1, SaveStdOut);
      rc:=DosDupHandle(2, SaveStdErr);
      NewStdHandle:=0;
      rc:=DosDupHandle(fPipeServer.HandleIn,NewStdHandle);
      NewStdHandle :=1;
      rc:=DosDupHandle(fPipeServer.HandleOut,NewStdHandle);
      NewStdHandle :=2;
      rc:=DosDupHandle(fPipeServer.HandleOut,NewStdHandle);
    End;


// Aufruf des Programmes
  IF fExecViaSession THEN
    BEGIN
      IF fAsynchExec
        THEN aStartData.TermQ:=NIL
        ELSE
          BEGIN
            DosGetInfoBlocks(tib,pib);
            IF pib=NIL
              THEN
                Begin
                  result:=ERR_EXEC_CANNOT_RETRIEVE_PID;
                 exit;
                End
              ELSE str(pib^.pib_ulpid,PIDS);
            QUE_NAME:=PathQueue+'TERMQ\'+PIDS+#0;
            rc := DosCreateQueue(QueueHandle,QUE_FIFO OR QUE_CONVERT_ADDRESS,QUE_NAME);
            if rc<>0 THEN
              Begin
                result:=ERR_EXEC_CANNOT_CREATE_TERM_QUEUE;
                exit;
              End;
            aStartData.TermQ:=@QUE_NAME;
          END;

      aStartData.Length       := sizeof(STARTDATA);
      aStartData.Related      := SSF_RELATED_CHILD;
      case fStartFgBg of
        ExStForeground : aStartData.FgBg := SSF_FGBG_FORE;
        ExStBackground : aStartData.FgBg := SSF_FGBG_BACK;
      end;
      aStartData.TraceOpt     := SSF_TRACEOPT_NONE;
      aStartData.PgmTitle     := @cTitle;
      aStartData.PgmName      := @cPrg;
      aStartData.PgmInputs    := cpParam;
      aStartData.Environment  := nil; // @pib^.pib_pchenv; //  NIL;
      aStartData.InheritOpt   := inh;         // SSF_INHERTOPT_PARENT; --> Pipe m”glich
      aStartData.SessionType  := SSF_TYPE_DEFAULT;
      aStartData.IconFile     := NIL;
      aStartData.PgmHandle    := 0;
      case fWindowState of
        ExWsNormal   : aStartData.PgmControl:=SSF_CONTROL_VISIBLE;
        ExWsSetPos   : aStartData.PgmControl:=SSF_CONTROL_SETPOS;
        ExWsMinimized: aStartData.PgmControl:=SSF_CONTROL_MINIMIZE;
        ExWsMaximized: aStartData.PgmControl:=SSF_CONTROL_MAXIMIZE;
        ExWsHidden   : aStartData.PgmControl:=SSF_CONTROL_INVISIBLE;
      End;
      aStartData.InitXPos     := fWindowPos.X;
      aStartData.InitYPos     := fWindowPos.Y;
      aStartData.InitXSize    := fWindowSize.CX;
      aStartData.InitYSize    := fWindowSize.CY;
      aStartData.Reserved     := 0;
      aStartData.ObjectBuffer := @ObjectBuffer;
      aStartData.ObjectBuffLen:= 256;

      rc:=DosStartSession(aStartData, SessId, SessPid);
      fProcessID:=SessPID;

      IF rc<>0 THEN
        BEGIN
          IF NOT fAsynchExec THEN
            BEGIN
              rc := DosCloseQueue(QueueHandle);
              if rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_CLOSE_TERM_QUEUE;
                  exit;
                End
            END;
          exit;
        END;

      DosSelectSession(SessID);

      IF fAsynchExec then
        fSessionID:=SessID
      else
        Begin
          IF ApplicationType<>cApplicationType_GUI THEN
            BEGIN
              SEM_NAME:=PathSem+'TERMQ\'+PIDS+#0;
              flAttr := 0;
              fState := FALSE;
              rc := DosCreateEventSem(SEM_NAME,SemHandle,flAttr,fState);
              if rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_CREATE_EVENT_SEM;
                  exit;
                End;
              Request.pid := pib^.pib_ulpid;
              ElementCode := 0;
              NoWait := TRUE;
              ahab :=  AppHandle; //WinQueryAnchorBlock(1);
              ulPostCt:=0;
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              IF (rc<>0)AND(rc<>342) THEN
                Begin
                  result:=ERR_EXEC_CANNOT_READ_TERM_QUEUE;
                  exit;
                End;
              WHILE WinGetMsg(ahab,Queue,0,0,0) DO
                BEGIN
                  rc := DosQueryEventSem(SemHandle, ulPostCt);
                  IF rc<>0 THEN
                    Begin
                      result:=ERR_EXEC_CANNOT_QUERY_EVENT_SEM;
                      exit;
                    end;
                  IF ulPostCt>0 THEN BREAK;
                  WinDispatchMsg(ahab,Queue);
                END;

              rc := DosCloseEventSem(SemHandle);
              IF rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_CLOSE_EVENT_SEM;
                  exit;
                End;
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              IF rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_READ_TERM_QUEUE;
                  exit;
                End;
              rdata:=DataAddress;
              fSessionID:=rdata^.d2;
              rc := DosFreeMem(DataAddress);
              IF rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_FREE_QUEUE_DATA;
                  exit;
                End;
              rc := DosCloseQueue(QueueHandle);
              IF rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_CLOSE_TERM_QUEUE;
                  exit;
                End;
            END
          else
            BEGIN
              Request.pid := pib^.pib_ulpid;
              ElementCode := 0;
              NoWait := FALSE;
              SemHandle := 0;
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              if rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_READ_TERM_QUEUE;
                  exit;
                End;
              rdata:=DataAddress;
              fSessionID:=rdata^.d2;
              rc := DosFreeMem(DataAddress);
              if rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_FREE_QUEUE_DATA;
                  exit;
                End;
              rc := DosCloseQueue(QueueHandle);
              if rc<>0 THEN
                Begin
                  result:=ERR_EXEC_CANNOT_CLOSE_TERM_QUEUE;
                  exit;
                End;
            END;
        END;
    END
  ELSE  // fExecViaSession=false
    BEGIN
      // Programm starten
      fLastExecResult:=0;
      IF fAsynchEXEC THEN
        DosExecPgm2(@ObjectBuffer, 256, 2, cpParam, NIL, eresult, cPrg)
      ELSE
        BEGIN
          getmem(cpParam1,LenParam+1);
          cpParam1[0]:=#0;                 // 1. Zeichen ein 0-Byte
          strCopy(@cpParam1^[1],cpParam);  // Restliche mit den Parameter befuellen
          DosExecPgm2(@ObjectBuffer, 256, 0, cpParam1, NIL, eresult, cPrg);
          fLastExecresult:=eresult.CodeResult;
          Freemem(cpParam1,LenParam+1);
        END;
      fSessionID:=fLastExecResult;
    END;

// StdIn/Out/Err wieder korrigieren
  if fPipeServer<>nil then
    Begin
      NewStdHandle :=0;
      rc:=DosDupHandle(SaveStdIn,NewStdHandle);
      rc:=DosClose(SaveStdIn);
      NewStdHandle :=1;
      rc:=DosDupHandle(SaveStdOut,NewStdHandle);
      rc:=DosClose(SaveStdOut);
      NewStdHandle :=1;
      rc:=DosDupHandle(SaveStdErr,NewStdHandle);
      rc:=DosClose(SaveStdErr);
    End;

// Parameter-C-String wieder entfernen;
  FreeMem(cpParam, LenParam);
End;
{$ENDIF}

{$IFDEF Win32}
imports
  FUNCTION CreateProcess2(CONST lpApplicationName : CSTRING; lpCommandLine : PChar;
                          VAR lpProcessAttributes,lpThreadAttributes:SECURITY_ATTRIBUTES;
                          bInheritHandles:BOOL;dwCreationFlags:ULONG;
                          lpEnvironment:POINTER;CONST lpCurrentDir:CSTRING;
                          VAR lpStartupInfo:STARTUPINFO;
                          VAR lpProcessInformation:PROCESS_INFORMATION):BOOL;
              APIENTRY;  'KERNEL32' name 'CreateProcessA';
End;


Function tcExec.StartProgramWin32 : LongInt;

Var aStartData  : StartupInfo;
    aProcessInfo: PROCESS_INFORMATION;

    prg         : String;        // Programname
    cPrg        : cString;
    cTitle      : cString;       // Title from the program


    Parameter   : AnsiString;
    LenParam    : LongWord;
    LenPrgParam : LongWord;
    cpParam     : PChar;
    cpPrgParam  : PChar;

    c : cstring;

Begin
  Result    :=0;
  fSessionID:=0; // Session-ID
  fProcessID:=0; // Prozess-ID
  fThreadID :=0; // Thread-ID
  cTitle:=fTitle;

// Paramater in ein C-String umwandeln
  Parameter:=getParameter2AnsiString;
  LenParam :=Length(Parameter);

// Link-Support
  if (fUrlSupport) and (getProgramFromUrl(fFileName, prg))
    then
      Begin
        LenParam:=Length(fFileName)+LenParam+1;
        GetMem(cpParam, LenParam);
        strPCopy(cpParam,fFileName+' ');
        StrACopy(@cpParam^[Length(fFileName)+1], Parameter);
      End
    else
      Begin
        GetMem(cpParam, LenParam);
        StrACopy(cpParam, Parameter);
        Prg:=fFileName;
      End;

// Aufruf des Programmes
  FillChar(aStartData,sizeof(aStartData),0);
  aStartData.cb:=sizeof(aStartData);
  case fWindowState of
    ExWsHidden : Begin
                   aStartData.dwFlags    :=STARTF_USESHOWWINDOW;
                   aStartData.wShowWindow:=SW_HIDE;
                 End;
  End;

// CommandLine zusammen stellen (C1:=C+' '+C1);
  cPrg:=Prg;
  LenPrgParam:=Length(Prg)+LenParam+1;
  getMem(cpPrgParam, LenPrgParam);
  strPCopy(cpPrgParam, Prg+' ');   // Programname
  strCat(cpPrgParam, cpParam);     // Parammeter

// Programm starten
  IF not CreateProcess2(cPrg, cpPrgParam, NIL, NIL, FALSE,
                        CREATE_NEW_CONSOLE OR NORMAL_PRIORITY_CLASS,
                        NIL,NIL,
                        aStartData,aProcessInfo) THEN
    BEGIN
      result:=ERR_EXEC_CANNOT_CREATE_PROCESS;
      exit;
    END;

// Returnvalues ermitteln
  fSessionID    :=0;
  fProcessID    :=aProcessInfo.dwProcessId;
  fProcessHandle:=aProcessInfo.hProcess;
  fThreadID     :=aProcessInfo.dwThreadId;
  fThreadHandle :=aProcessInfo.hThread;

  if not fAsynchEXEC then
    Begin
      CloseHandle(aProcessInfo.hThread);
      if WaitForSingleObject(fProcessHandle, Infinite)=Wait_Failed then
        Begin
          result:=ERR_EXEC_CANNOT_WAITSINGLEOBJECT;
          exit;
        End;
      CloseHandle(fProcessHandle);
    End;

// Commandline-String wieder loeschen
  freeMem(cpPrgParam, LenPrgParam);
End;
{$ENDIF}

Function tcExec.StartProgram : LongInt;

Begin
  {$IFDEF OS2}
  Result:=StartProgramOS2;
  {$ENDIF}
  {$IFDEF Win32}
  Result:=StartProgramWin32;
  {$ENDIF}
End;

FUNCTION tcExec.DosExitCode : LONGWORD;
{$IFDEF OS2}
VAR
   rc    : LONGWORD;
   Status: STATUSDATA;
   return: RESULTCODES;
{$ENDIF}
BEGIN
  {$IFDEF OS2}
  IF fExecViaSession THEN
    BEGIN
      Status.length:=6;
      Status.SelectInd:=0;
      Status.BondInd:=0;
      try
        rc:=DosSelectSession(fSessionID);
      except
        rc:=0;
      end;
      While (rc<>ERROR_SMG_GRP_NOT_FOUND) DO
        Begin
          SysSleep(100);
          try    // Es kommt bei Warp 3 manchmal zu einem Exception.
            rc:=DosSetSession(fSessionID,Status);
          except
            rc:=ERROR_SMG_GRP_NOT_FOUND;
          end;
        End;
      Result:=0;
    END
  ELSE
  BEGIN
    IF fLastExecResult=0 THEN
      BEGIN
        DosWaitChild(DCWA_PROCESS,DCWW_WAIT,return,fSessionId,fSessionId);
        fLastExecResult:=return.CodeResult;
        Result:=return.CodeResult;
      END
    ELSE Result:=fLastExecResult;
  END;
  {$ENDIF}
  {$IFDEF Win32}
  Repeat
    GetExitCodeProcess(fProcessHandle,Result);
    If Result<>STILL_ACTIVE Then
    Begin
      Result:=0;
      break;
    End;
    SysSleep(50);
  Until False;
  {$ENDIF}
END;

Function tcExec.KillProcess : LongInt;

Begin
  {$IFDEF OS2}
  Result:=DosKillProcess(0,fProcessID);
  {$ENDIF}
  {$IFDEF Win32}
  Result:=BYTE(TerminateProcess(fProcessHandle,0)=FALSE);
  {$ENDIF}
End;

Function tcExec.ProcessActive : Boolean;
{$IFDEF OS2}
VAR r   :LONGWORD;
{$ENDIF}

Begin
  {$IFDEF OS2}
  r:=DosSetPriority(PRTYS_PROCESS, PRTYC_NOCHANGE,0, fProcessID);
  Result:=r=ERROR_NOT_DESCENDANT
  {$ENDIF}
  {$IFDEF Win32}
  Result:=GetPriorityClass(fProcessHandle)>0;
  {$ENDIF}
End;

Constructor tcExec.Create(Const iFileName : tFileName);

Begin
  Inherited Create;
  fFileName:=iFileName;
  fTitle:=fFileName;

  fSessionID:=0;
  fProcessID:=0;
  fThreadID :=0;
  fExecViaSession:=true;
  fAsynchExec    :=true;
  fUrlSupport    :=true;
  fWindowState   :=ExWsNormal;     // Fenster normal starten
  fStartFgBg     :=ExStBackground; // Fenster im Hintergrund starten
  fWindowPos.X   :=0;
  fWindowPos.Y   :=0;
  fWindowSize.CX :=0;
  fWindowSize.CY :=0;
  fPipeServer    :=nil;   // Kein PipeServer verwenden

  fParameters.Create;
End;

Destructor tcExec.Destroy;

Begin
  fParameters.Destroy;
  inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tcPortIO Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const IODriverName:STRING='TESTCFG$'; {Driver name for Port I/O}
      TSTCFG_CAT         =$80;
      TSTCFG_FCN_PHYS    =$40;
      TSTCFG_FCN_INPUT   =$41;
      TSTCFG_FCN_OUTPUT  =$42;

Type tPortAddr=Record
                 ioaddr:WORD;
                 iowidth:WORD;
                 iovalue:WORD;
               End;

     tPortPhysAddr=Record
                     Command:LONGWORD;
                     Address:LONGWORD;
                     Bytes:LONGWORD;
                   End;

function tcPortIO.GetByte(iPortAdress: Word): Byte;

{$IFDEF OS2}
Var rc      : APIRet;
    PortAddr: tPortAddr;
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}

Begin
  Result:=0;
{$IFDEF OS2}
  Fillchar(PortAddr,sizeOf(tPortAddr), #0);
  PortAddr.IoAddr:=iPortAdress;
  PortAddr.IoWidth:=1;
  rc:=DosDevIoCtl(fIODriverHandle,TSTCFG_CAT, TSTCFG_FCN_INPUT, PortAddr,
                  SizeOf(TPortAddr),NIL,Result,1,NIL);
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}
End;

procedure tcPortIO.SetByte(iPortAdress:Word; Value: Byte);

{$IFDEF OS2}
Var rc : APIRet;
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}

Begin
{$IFDEF OS2}
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}
End;

function tcPortIO.GetWord(iPortAdress: Word): Word;

{$IFDEF OS2}
Var rc : APIRet;
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}

Begin
{$IFDEF OS2}
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}
End;

procedure tcPortIO.SetWord(iPortAdress:Word; Value: Word);

{$IFDEF OS2}
Var rc : APIRet;
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}

Begin
{$IFDEF OS2}
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}
End;

Constructor tcPortIO.Create;

{$IFDEF OS2}
Var rc : APIRet;
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}

Begin
  Inherited Create;
{$IFDEF OS2}
//  rc:=DosOpen(IODriverName,fIoDriverHandle,fIoAction,0,0,1,$40,NIL);
  rc:=DosOpen(IODriverName,fIoDriverHandle,fIoAction,0,
         FILE_NORMAL, FILE_OPEN,
         OPEN_ACCESS_READWRITE or OPEN_SHARE_DENYNONE,
         NIL);
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}
End;


Destructor tcPortIO.Destroy;

{$IFDEF OS2}
Var rc : APIRet;
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}

Begin
{$IFDEF OS2}
  if fIODriverHandle<>0 then
    DosClose(fIoDriverHandle);
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}
  inherited Destroy;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: Initialization/Finalization                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Initialization
{ Wird fuer tThread verwendet }
  MsgProc:=Nil;
  ProcessProc:=Nil;

Finalization

End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-04  WD         Einbau von tcJoystick (vorher in uJoystick)
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  25-Dez-05  WD         Umbau von dem Objekt tcMutex, tcCriticalSection, tcEvent usw
  08-Jan-05  WD         Einbau der Klasse tcUSBCalls.
  05-Mai-06  WD         Klasse tcLog von uLog eingebaut.
  27-Mai-06  WD         Klasse tcFunc eingebaut.
  10-Jul-07  WD         Klasse tcFileSearch eingebaut.
  04-Jan-09  WD         Klasse tcExec eingebaut.
  02-Feb-09  WD         Klasse tcMuxWaitSemaphor eingebaut.
  04-Feb-09  WD         Klasse tEvent, tEventtMutex, tCriticalSection geloescht.
  11-Feb-09  WD         Funktion DLLExists in die Unit uSysFunc verschoben.
  25-Feb-09  WD         Umbau der Klasse tcPipeServer, tcPipeClient, tcCriticalSection usw.
  31-Mar-09  WD         tcExec: Einbau der Pipe
  06-Apr-09  WD         tcPort: Klasse eingebaut
}

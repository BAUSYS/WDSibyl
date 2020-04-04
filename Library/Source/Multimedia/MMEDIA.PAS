{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Multimedia Classes                                            บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit MMedia;

Interface

{$r MMedia}

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmBitmap;
{$ENDIF}
{$IFDEF Win32}
Uses WinDef,WinBase,WinUser,MMSystem;
{$ENDIF}

Uses SysUtils,Messages,Color,Classes,Forms,Graphics,StdCtrls,Dialogs,Buttons,
     uList, uSysClass;

Const MMIO_SUCCESS               = 0;
      MMIO_WARNING               = 2;
      MMIO_ERROR                 =-1;
      MMIOERR_UNSUPPORTED_MESSAGE=-2;
      MMIO_TRANSLATEHEADER       =$00000002; /* Translation */
      MMIO_TRACK                 =$00000001;
      MMIO_NORMAL_READ           =$00000002;
      MMIO_SCAN_READ             =$00000004;
      MMIO_REVERSE_READ          =$00000008;
      MMIO_CODEC_ASSOC           =$00000100;
      MMIO_READ                  =$00000004;       /* Open */
      MMIO_SET_EXTENDEDINFO      =$0001;
      MMIO_RESETTRACKS           =-1;

{$IFDEF OS2}

Const MCIERR_SUCCESS=0;
      CODEC_INFO_SIZE    =8;
      CODEC_HW_NAME_SIZE =32;
      DLLNAME_SIZE       =CCHMAXPATH;
      PROCNAME_SIZE      =32;
      MAX_EXTENSION_NAME =4;


type PMMTIME=^MMTIME;
     MMTIME=LONGWORD;
     FOURCC=LONGWORD;
     PFOURCC=^FOURCC;
     MMIOPROC=Function(Var pmmioInfo;wMsg:LONGWORD;lParam1,lParam2:LONG):LONG;APIENTRY;
     PMMIOPROC=^MMIOPROC;
     PCODECPROC=^MMIOPROC;
     HMMIO=LONGWORD;
     HMMCF=LONGWORD;

Type PCODECINIFILEINFO=^CODECINIFILEINFO;
     CODECINIFILEINFO=Record
                           ulStructLen:LONGWORD;
                           fcc:FOURCC;
                           szDLLName:Cstring[DLLNAME_SIZE-1];
                           szProcName:Cstring[PROCNAME_SIZE-1];
                           ulCompressType:LONGWORD;
                           ulCompressSubType:LONGWORD;
                           ulMediaType:LONGWORD;
                           ulCapsFlags:LONGWORD;
                           ulFlags:LONGWORD;
                           szHWID:Cstring[CODEC_HW_NAME_SIZE-1];
                           ulMaxSrcBufLen:LONGWORD;
                           ulSyncMethod:LONGWORD;
                           fccPreferredFormat:LONGWORD;
                           ulXalignment:LONGWORD;
                           ulYalignment:LONGWORD;
                           ulSpecInfo:Cstring[CODEC_INFO_SIZE-1];
     End;
     PMMTRACKINFO=^MMTRACKINFO;
     MMTRACKINFO=Record
                      ulTrackID:LONGWORD;
                      ulMediaType:LONGWORD;
                      ulCountry:LONGWORD;
                      ulCodePage:LONGWORD;
                      ulReserved1:LONGWORD;
                      ulReserved2:LONGWORD;
     End;

     PMMIOINFO=^MMIOINFO;
     MMIOINFO=Record
                   dwFlags:LONGWORD;
                   fccIOProc:FOURCC;
                   pIOProc:PMMIOPROC;
                   dwErrorRet:LONGWORD;
                   cchBuffer:LONG;
                   pchBuffer:PChar;
                   pchNext:PChar;
                   pchEndRead:PChar;
                   pchEndWrite:PChar;
                   lBufOffset:LONG;
                   lDiskOffset:LONG;
                   adwInfo:Array[0..3] Of LONGWORD;
                   lLogicalFilePos:LONG;
                   ulTranslate:LONGWORD;
                   fccChildIOProc:FOURCC;
                   pExtraInfoStruct:POINTER;
                   hmmio:HMMIO;
     End;

     PCODECASSOC=^CODECASSOC;
     CODECASSOC=Record
                     pCodecOpen:POINTER;
                     pCodecIniFileInfo:PCODECINIFILEINFO;
     End;


     PMMEXTENDINFO=^MMEXTENDINFO;
     MMEXTENDINFO=Record
                       ulStructLen:LONGWORD;
                       ulBufSize:LONGWORD;
                       ulFlags:LONGWORD;
                       ulTrackID:LONGWORD;
                       ulNumCODECs:LONGWORD;
                       pCODECAssoc:PCODECASSOC;
     End;
{$ENDIF}

{$M+}
Type TMCIStatus=(mciPaused,mciPlaying,mciRewind,mciStopped,mciRecording,
                 mciNothing,mciError);

     TMCIDeviceMode=(dmNotReady,dmStopped,dmPlaying,dmSeeking,dmRecording,
                     dmPaused,dmOther,dmUnknown);

     TMCINotifyEvents=(mciNotifySuperseded,mciNotifyAborted,mciNotifySuccess,
                       mciNotifyError,mciNotifyPositionChange,mciNotifyCuePoint);

     TChannel=(chLeft,chRight,chBoth);

     TTimeFormat=(tfMilliseconds,tfMMTime,tfMSF,tfTMSF,tfFrames,tfHMS,tfHMSF,tfBytes,tfSamples,
                  tfSMPTE24,tfSMPTE25,tfSMPTE30,tfSP,tfUnknown);
     TTimeFormats=Set Of TTimeFormat;
{$M-}

     TTimeInfo=Record
         Case Format:TTimeFormat Of
           tfMilliSeconds:(MilliSeconds:LONGWORD);
           tfMMTime:(MMTime:LONGWORD);
           tfMSF:(msf_Minutes,msf_Seconds,msf_Frames,msf_Reserved:BYTE);
           tfTMSF:(tmsf_Track,tmsf_Minutes,tmsf_Seconds,tmsf_Frames:BYTE);
           tfFrames:(Frames:LONGWORD);
           tfHMS:(hms_Hours,hms_Minutes,hms_Seconds,hms_reserved:BYTE);
           tfHMSF:(hmsf_Hours,hmsf_Minutes,hmsf_Seconds,hmsf_Frames:BYTE);
           tfBytes:(Bytes:LONGWORD);
           tfSamples:(Samples:LONGWORD);
           tfSMPTE24:(SMPTE24:LONGWORD);
           tfSMPTE25:(SMPTE25:LONGWORD);
           tfSMPTE30:(SMPTE30:LONGWORD);
           tfSP:(SongPointer:LONGWORD);
           tfUnknown:(Unknown:LONGWORD);
     End;

     tTrack = Record
       Titel    : String;
       Interpret: String;
       Length   : TTimeInfo;
     End;

     tTrackList = Class(TList)
       Private
       public
     end;


{$M+}
     TMCIPositionChanged=Procedure(Sender:TObject;Const NewPosition:TTimeInfo) Of Object;
     TMCICuePointReached=Procedure(Sender:TObject;Const NewPosition:TTimeInfo;CuEPOintid:LONGWORD) Of Object;
{$M-}


     TCueTypes=(cuOutput,cuInput);

     TMCIDevice=Class(TComponent)
       Private
         FDeviceOpen   : BOOLEAN;
         FAliasName    : STRING;
         FDeviceName   : STRING;
         FFileName     : String;
         FTitel        : String;
         FFileNameRequired:BOOLEAN;
         FPositionAdvise:BOOLEAN;
         FPositionAdviseUnits:TTimeInfo;
         FCuePointCount:WORD;
         FOnPlayingCompleted:TNotifyEvent;
         FOnPlayingAborted:TNotifyEvent;
         FOnPositionChanged:TMCIPositionChanged;
         FOnCuePointReached:TMCICuePointReached;
       Private
         Procedure SetTimeFormat(NewFormat:TTimeFormat);
         Function TimeInfoStr(TimeInfo:TTimeInfo;SaveTime:TTimeFormat):String;

         Function GetChannels:LONGINT;
         Function GetVolume(Channel:TChannel):Byte;
         Procedure SetVolume(Channel:TChannel;NewVolume:Byte);
         Function GetCurrentTrack:LONGINT;
         Function GetTrackLength(Track:LONGINT):TTimeInfo;
         Function GetTracks:LONGINT;
         Function GetMediaPresent:BOOLEAN;
         Function GetDeviceReady:BOOLEAN;
         Function GetPosition:TTimeInfo;
         Function GetLength:TTimeInfo;
         Function GetDeviceMode:TMCIDeviceMode;
         Function GetDeviceId:LONGWORD;
         Procedure SetPositionAdvise(NewValue:BOOLEAN);
         Procedure SetPositionAdviseUnits(NewUnits:TTimeInfo);
         Procedure SetFileName(Const NewValue:String);
         Function GetCanEject:BOOLEAN;
         Function GetCanPlay:BOOLEAN;
         Function GetCanRecord:BOOLEAN;
         Function GetCanSave:BOOLEAN;
         Function GetCanLockEject:BOOLEAN;
         Function GetCanSetVolume:BOOLEAN;
         Function GetHasAudio:BOOLEAN;
         Function GetHasVideo:BOOLEAN;
         Function GetUsesFiles:BOOLEAN;
       Protected
         FTimeFormatsAvailable:TTimeFormats;
         FDefaultTimeFormat:TTimeFormat;
         FTimeFormat:TTimeFormat;
         FFileLoaded:BOOLEAN;
         FStatus:TMCIStatus;
         FNotifyControl: TControl;
         FLastMCIReturn:String;
         fTrackList : tTrackList;

         Function GetMediumID:String; Virtual;
         Function GetMCIStatusNumber(Const option:String):LONGINT;
         Function GetMCITimeInfo(Const option:String):TTimeInfo;
         Function GetMCICapBoolean(Const Option:String):BOOLEAN;
         Function GetMCIStatusBoolean(Const option:String):BOOLEAN;
         Function GetMCICapLong(Const Option:String):LONGWORD;

         Procedure SetupComponent;Override;
         Procedure HandleMCIError(Const ErrorStr:String);Virtual;
         Procedure MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUsErCode:LONGWORD);Virtual;
         Procedure PositionChanged(Const NewPosition:TTimeInfo);Virtual;
         Procedure CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);Virtual;
         Procedure PlayingCompleted;Virtual;
         Procedure PlayingAborted;Virtual;
       Protected
         Property FileNameRequired:BOOLEAN read FFileNameRequired write FFileNameRequired;
       Public
         Procedure GetDefaultFileMask(Var Ext,Description:String);Virtual;
         Procedure Load;Virtual;
         Procedure Play;Virtual;
         Procedure Pause;Virtual;
         Procedure Stop;Virtual;
         Procedure Resume;Virtual;
         Procedure StartRecording;Virtual;
         Procedure SeekToStart;Virtual;
         Procedure SeekToEnd;Virtual;
         Procedure Seek(NewPos:TTimeInfo);Virtual;
         Procedure OpenDevice;Virtual;
         Procedure CloseDevice;Virtual;
         Procedure NextTrack;Virtual;
         Procedure PreviousTrack;Virtual;
         Destructor Destroy;Override;
         Function AddCuePoint(Const CuePoint:TTimeInfo):LONGWORD;
         Function DeleteCuePoint(Const CuePoint:TTimeInfo):BOOLEAN;
         Function SendString(Const s:String;usUserParm:WORD):BOOLEAN;Virtual;
         Function WriteSCUResource(Stream:TResourceStream):BOOLEAN;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LOngint);Override;
         Function Cue(CueFor:TCueTypes):BOOLEAN;
         Procedure Cut(StartPos,EndPos:TTimeInfo);
         Procedure Copy(StartPos,EndPos:TTimeInfo);
         Procedure Paste(StartPos,EndPos:TTimeInfo);
       Public
         Procedure ShowMCIError(Code:LONGWORD);
         Property Status:TMCIStatus read FStatus write fStatus;
         Property Channels:LONGINT read GetChannels;
         Property Volume[Channel:TChannel]:Byte read GetVolume write SetVolume;
         Property CurrentTrack:LONGINT read GetCurrentTrack;
         Property TrackLength[Track:LONGINT]:TTimeInfo read GetTrackLength;

         Property Tracks:LONGINT read GetTracks;
         Property TrackList:tTrackList read fTrackList write fTrackList;
         Property MediaPresent:BOOLEAN read GetMediaPresent;
         Property DeviceReady:BOOLEAN read GetDeviceReady;
         Property Position:TTimeInfo read GetPosition write Seek;

         Property Titel:String read FTitel write FTitel;
         Property Length:TTimeInfo read GetLength;
         Property DeviceMode:TMCIDeviceMode read GetDeviceMode;
         Property DeviceId:LONGWORD read GetDeviceId;
         Property PositionAdviseUnits:TTimeInfo read FPositionAdviseUnits write SeTpositiOnadviseUNits;
         Property LastMCIReturn:String read FLastMCIReturn;
         Property PositionAdvise:BOOLEAN read FPositionAdvise write SetPositionAdvIse;
         Property TimeFormatsAvailable:TTimeFormats read FTimeFormatsAvailable;
         Property DefaultTimeFormat:TTimeFormat read FDefaultTimeFormat;
         Property DeviceOpen:BOOLEAN read FDeviceOpen;
         Property CanEject:BOOLEAN read GetCanEject;
         Property CanPlay:BOOLEAN read GetCanPlay;
         Property CanRecord:BOOLEAN read GetCanRecord;
         Property CanSave:BOOLEAN read GetCanSave;
         Property CanLockEject:BOOLEAN read GetCanLockEject;
         Property CanSetVolume:BOOLEAN read GetCanSetVolume;
         Property HasAudio:BOOLEAN read GetHasAudio;
         Property HasVideo:BOOLEAN read GetHasVideo;
         Property UsesFiles:BOOLEAN read GetUsesFiles;

       Published
         Property OnPlayingAborted:TNotifyEvent read FOnPlayingAborted write FOnPlAyinGAbOrted;
         Property OnPlayingCompleted:TNotifyEvent read FOnPlayingCompleted write FOnplAyiNgcompLetEd;
         Property OnPositionChanged:TMCIPositionChanged read FOnPositionChanged wrIte FOnPositiOnCHanGed;
         Property OnCuePointReached:TMCICuePointReached read FOnCuePointReached wrIte FOnCuepoiNtREacHed;
         Property FileName:String        read fFileName   write SetFileName;
         Property DeviceName:String      read fDeviceName write fDeviceName;
         Property AliasName:String       read fAliasName  write fAliasName;
         Property TimeFormat:TTimeFormat read FTimeFormat write SetTimeFormat;
     End;

Function TimeFormatToString(tf:TTimeFormat):String;
Function DeviceModeToString(dm:TMCIDeviceMode):String;
Function ConvertTimeInfo(Var TimeInfo:TTimeInfo;NewFormat:TTimeFormat):BOOLEAN;
Function CompareTimeInfos(TimeInfo1,TimeInfo2:TTimeInfo):LONGINT;
Function TimeInfoToString(Const TimeInfo:TTimeInfo):String;

{$IFDEF OS2}
Function InitMMPM2:BOOLEAN;

Var mciGetDeviceIdAddr:Function(AliasName:Cstring):LONGWORD;APIENTRY; {MDM index 16;}
    mciGetErrorStringAddr:Function(ulError:LONGWORD;
                                   Var pszBuffer:Cstring;
                                   usLength:LONGWORD):LONGWORD;APIENTRY; {MDM index 3;}
    mciSendStringAddr:Function(s:Cstring;Var ret:Cstring;retlen:LONGWORD;
                             ahwnd:HWND;userParam:LONGWORD):LONGWORD;APIENTRY; {MDM index 2;}
    mmioOpenAddr:Function( pszFileName:Cstring;Var apmmioinfo:MMIOINFO;
                         dwOpenFlags:LONGWORD ):HMMIO;APIENTRY;  {MMIO index 27;}
    mmioCloseAddr:Function( ahmmio:HMMIO;wFlags:LONGWORD ):WORD;APIENTRY;  {MMIO index 32;}
    mmioGetHeaderAddr:Function( ahmmio:HMMIO;Var pHeader;lHeaderLength:LONG;
                       Var plBytesRead:LONG;dwReserved:ULONG;dwFlags:ULONG ):LONGWORD;APIENTRY;  {MMIO index 77;}
    mmioSetAddr:Function(ahmmio:HMMIO;Var pUserExtendmminfo:MMEXTENDINFO;
                     ulFlags:ULONG):ULONG;APIENTRY;  {MMIO index 101;}
    mmioQueryHeaderLengthAddr:Function( ahmmio:HMMIO;Var plHeaderLength:LONG;
                               dwReserved:LONGWORD;dwFlags:LONGWORD ):LONGWORD;APIENTRY;  {MMIO index 76;}

{$ENDIF}

Implementation

/* Uses uMediaPlayer, uVideoDevice; */

{$IFDEF OS2}
Var MMPM2Initialized : BOOLEAN;
Type EProcAddrError=Class(Exception);
{$ENDIF}

Type TMCINotifyControl=Class(TControl)
      Private
         FDevice:TMCIDevice;
         {$IFDEF Win32}
         Procedure MMMCINotify(Var Msg:TMessage); Message $3B9; {MM_MCINOTIFY;}
         {PROCEDURE MMMCIPositionChange(VAR Msg:TMessage); message MM_MCIPOSITIONCHANGE; ???
         Procedure MMMCICuePoint(Var Msg:TMessage); Message MM_MCICUEPOINT; ???}
         {$ENDIF}
         {$IFDEF OS2}
         Procedure MMMCINotify(Var Msg:TMessage); Message $0500; {MM_MCINOTIFY;}
         Procedure MMMCIPositionChange(Var Msg:TMessage); Message $0502; {MM_MCIPOSITIONCHANGE;}
         Procedure MMMCICuePoint(Var Msg:TMessage); Message $0503; {MM_MCICUEPOINT;}
         {$ENDIF}
         Procedure CreateWnd;Override;
      Protected
         Procedure SetupComponent;Override;
    End;

Procedure TMCINotifyControl.CreateWnd; //dummy
Begin
  Inherited CreateWnd;
End;

Procedure TMCINotifyControl.SetupComponent;
Begin
  Inherited SetupComponent;
  Include (ComponentState, csDetail);
End;

Procedure TMCINotifyControl.MMMCINotify(Var Msg:TMessage);
Var usNotifyCode : Word;
    Event:TMCINotifyEvents;
    usDeviceId:WORD;
    usUserCode:WORD;
{$IFDEF Win32}
Const MCI_NOTIFY_SUCCESSFUL  =$0001;
      MCI_NOTIFY_SUPERSEDED  =$0002;
      MCI_NOTIFY_ABORTED     =$0004;
{$ENDIF}
{$IFDEF OS2}
Var usCommandMessage : WORD;

Const MCI_NOTIFY_SUCCESSFUL =$0000;
      MCI_NOTIFY_SUPERSEDED =$0001;
      MCI_NOTIFY_ABORTED    =$0002;
{$ENDIF}

Begin
{$IFDEF OS2}
  usNotifyCode:=Msg.Param1Lo;
  usCommandMessage:=Msg.Param2Hi;
  usDeviceId:=Msg.Param2Lo;
  usUserCode:=Msg.Param1Hi;

  Case usNotifyCode Of
    MCI_NOTIFY_SUPERSEDED:Event:=mciNotifySuperseded;
    MCI_NOTIFY_ABORTED:Event:=mciNotifyAborted;
    MCI_NOTIFY_SUCCESSFUL:Event:=mciNotifySuccess;
    Else Event:=mciNotifyError;
  End; {case}
{$ENDIF}
{$IFDEF Win32}
  usNotifyCode:=0; {??}
  usDeviceId:=0;   {??}
  usUserCode:=0;   {??}

  Case Msg.Param1 Of
    MCI_NOTIFY_SUPERSEDED:Event:=mciNotifySuperseded;
    MCI_NOTIFY_ABORTED:Event   :=mciNotifyAborted;
    MCI_NOTIFY_SUCCESSFUL:Event:=mciNotifySuccess;
    Else Event:=mciNotifyError;
  End; {case}
{$ENDIF}
  FDevice.MCIEvent(Event,usDeviceid,usNotifyCode,usUserCode);
  Msg.Handled:=TRUE;
  Msg.Result:=0;
End;

{$IFDEF OS2}
Procedure TMCINotifyControl.MMMCIPositionChange(Var Msg:TMessage);
Var usDeviceId:WORD;
    usUserCode:WORD;
    ulmmTime:LONGWORD;
Begin
  {$IFDEF OS2}
  usDeviceId:=Msg.Param1Hi;
  usUserCode:=Msg.Param1Lo;
  ulmmTime:=Msg.Param2;
  {$ENDIF}
  {$IFDEF Win32}
  ???
  {$ENDIF}
  FDevice.MCIEvent(mciNotifyPositionChange,usDeviceid,ulmmTime,usUserCode);
  Msg.Handled:=TRUE;
  Msg.Result:=0;
End;


Procedure TMCINotifyControl.MMMCICuePoint(Var Msg:TMessage);
Var usDeviceId:WORD;
    ulmmTime:LONGWORD;
    usUserCode:WORD;
Begin
  {$IFDEF OS2}
  usDeviceId:=Msg.Param1Hi;
  ulmmTime:=Msg.Param2;
  usUserCode:=Msg.Param1Lo;
  {$ENDIF}
  {$IFDEF Win32}
  ???
  {$ENDIF}
  FDevice.MCIEvent(mciNotifyCuePoint,usDeviceid,ulmmTime,usUserCode);
  Msg.Handled:=TRUE;
  Msg.Result:=0;
End;
{$ENDIF}

{$IFDEF OS2}
Function InitMMPM2:BOOLEAN;
Var c:Cstring;
    MdmModHandle:LONGWORD;
    ok:BOOLEAN;

  Function GetProcaddr(Index:LONGWORD):POINTER;
  Begin
    result:=Nil;
    If DosQueryProcAddr(MdmModHandle,Index,Nil,result)<>0 Then
      Begin
        ErrorBox2(LoadNLSStr(SMMAccessError));
        Raise EProcAddrError.Create(tostr(Index));
      End;
  End;

Begin
  result:=MMPM2Initialized;
  If result Then exit;

  If DosLoadModule(c,255,'MDM',MdmModHandle)<>0 Then
    Begin
      ErrorBox2(LoadNLSStr(SMDMNotFound));
      exit;
    End;

  ok:=TRUE;
   Try
     mciGetDeviceIdAddr:=Pointer(GetProcAddr(16));
     mciGetErrorStringAddr:=Pointer(GetProcAddr(3));
     mciSendStringAddr:=Pointer(GetProcAddr(2));
   Except
     ok:=FALSE;
   End;
   If ok=false Then exit;

   If DosLoadModule(c,255,'MMIO',MdmModHandle)<>0 Then
     Begin
       ErrorBox2(LoadNLSStr(SMMIONotFound));
       exit;
     End;

   ok:=TRUE;
     Try
        mmioOpenAddr:=Pointer(GetProcAddr(27));
        mmioCloseAddr:=Pointer(GetProcAddr(32));
        mmioGetHeaderAddr:=Pointer(GetProcAddr(77));
        mmioSetAddr:=Pointer(GetProcAddr(101));
        mmioQueryHeaderLengthAddr:=Pointer(GetProcAddr(76));
     Except
        ok:=FALSE;
     End;
     MMPM2Initialized:=ok;
     result:=ok;
End;

{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMCIDevice Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TMCIDevice.GetMediumID:String;

Begin
  Result:='';
End;

Function TMCIDevice.GetCanEject:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('can eject');
End;

Function TMCIDevice.GetCanPlay:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('can play');
End;

Function TMCIDevice.GetCanRecord:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('can record');
End;

Function TMCIDevice.GetCanSave:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('can save');
End;

Function TMCIDevice.GetCanLockEject:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('can lockeject');
End;

Function TMCIDevice.GetCanSetVolume:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('can setvolume');
End;

Function TMCIDevice.GetHasAudio:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('has audio');
End;

Function TMCIDevice.GetHasVideo:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('has video');
End;

Function TMCIDevice.GetUsesFiles:BOOLEAN;
Begin
  If Not FDeviceOpen Then OpenDevice;
  result:=GetMCICapBoolean('uses files');
End;

Procedure TMCIDevice.SetFileName(Const NewValue:String);
Begin
  Stop;
  CloseDevice;
  fFilename:=NewValue;
  FFileLoaded:=False;
  Load;
End;

Procedure TMCIDevice.GetDefaultFileMask(Var Ext,Description:String);
Begin
  Ext:='*.*';
  Description:=LoadNLSStr(SAllFiles);
End;

Function TMCIDevice.GetMCIStatusNumber(Const option:String):LONGINT;
Var c:INTEGER;
Begin
  result:=-1;
  OpenDevice;
  If Not SendString('status '+AliasName+' '+option+' wait',0) Then exit;
  VAL(FLastMCIReturn,result,c);
  If c<>0 Then result:=-1;
End;

Function TMCIDevice.GetMCIStatusBoolean(Const option:String):BOOLEAN;
Var temp:LONGINT;
Begin
  temp:=GetMCIStatusNumber(option);
  result:=FLastMCIReturn='TRUE';
End;

Function TMCIDevice.GetMCICapBoolean(Const Option:String):BOOLEAN;
Begin
  result:=FALSE;
  If Not SendString('capability '+AliasName+' '+Option+' wait',0) Then exit;
  result:=FLastMCIReturn='TRUE';
End;

Function TMCIDevice.GetMCICapLong(Const Option:String):LONGWORD;
Var c:INTEGER;
Begin
  result:=0;
  If Not SendString('capability '+AliasName+' '+Option+' wait',0) Then exit;
  VAL(FLastMCIReturn,result,c);
  If c<>0 Then result:=0;
End;

Function TMCIDevice.GetDeviceReady:BOOLEAN;
Begin
  result:=GetMCIStatusBoolean('ready');
End;

Const DeviceModesArray:Array[dmNotReady..dmUnknown] Of String[15]=
            (
             'not ready',
             'stopped',
             'playing',
             'seeking',
             'recording',
             'paused',
             'other',
             'unknown'
            );

Function DeviceModeToString(dm:TMCIDeviceMode):String;
Begin
  result:=DeviceModesArray[dm];
End;

Function TMCIDevice.Cue(CueFor:TCueTypes):BOOLEAN;
Var s:String[10];
Begin
  result:=FALSE;
  If CueFor=cuOutput
    Then s:=' output'
    Else s:=' input';
  OpenDevice;
  If Not SendString('cue '+AliasName+s+' wait',0) Then exit;
  result:=TRUE;
End;


Procedure TMCIDevice.SetPositionAdvise(NewValue:BOOLEAN);
{$IFDEF OS2}
Var SaveFormat:TTimeFormat;
{$ENDIF}

Begin
  OpenDevice;
  If FNotifyControl<>Nil Then
    If FFileLoaded Then
      Begin
        If NewValue
          Then
            Begin
              If Not FPositionAdvise Then
                Begin
                  {$IFDEF OS2}
                  SaveFormat:=TimeFormat;
                  If SendString('setpositionadvise '+AliasName+' on every '
                                +TimeInfoStr(FPositionAdviseUnits,SaveFormat)+' wait',0) Then
                    FPositionAdvise:=TRUE;
                  TimeFormat:=SaveFormat;
                  {$ENDIF}
                  {$IFDEF Win32}
                  FPositionAdvise:=TRUE;
                  {$ENDIF}
                End;
            End
          Else
            If FPositionAdvise Then
              Begin
                {$IFDEF OS2}
                If SendString('setpositionadvise '+AliasName+' off wait',0) Then
                {$ENDIF}
                FPositionAdvise:=FALSE;
              End;
      End;
End;

Function TMCIDevice.GetDeviceId:LONGWORD;
Begin
  {$IFDEF OS2}
  result:=0;
  If Not InitMMPM2 Then exit;
  result:=mciGetDeviceIdAddr(AliasName);
  {$ENDIF}
  {$IFDEF Win32}
  result:=mciGetDeviceId(AliasName);
  {$ENDIF}
End;

Function TMCIDevice.GetDeviceMode:TMCIDeviceMode;
Var t:TMCIDeviceMode;
Begin
  result:=dmUnknown;
  OpenDevice;
  If Not SendString('status '+AliasName+' mode wait',0) Then exit;
  For t:=dmNotReady To dmOther Do
    If FLastMCIReturn=DeviceModesArray[t] Then
      Begin
        result:=t;
        exit;
      End;
End;

Function TMCIDevice.GetMediaPresent:BOOLEAN;
Begin
  result:=GetMCIStatusBoolean('media present');
End;

Function TMCIDevice.GetChannels:LONGINT;
Begin
   result:=GetMCIStatusNumber('channels');
End;

Function TMCIDevice.GetCurrentTrack:LONGINT;
Begin
  result:=GetMCIStatusNumber('current track');
End;

Procedure TMCIDevice.NextTrack;
Begin
End;

Procedure TMCIDevice.PreviousTrack;
Begin
End;

Function TMCIDevice.GetTrackLength(Track:LONGINT):TTimeInfo;
Begin
  If Track=0 Then Track:=CurrentTrack;
  result:=GetMCITimeInfo('length track '+tostr(track));
End;

Function TMCIDevice.GetMCITimeInfo(Const option:String):TTimeInfo;
Var s:String;
    OldTimeFormat:TTimeFormat;

  Procedure GetNextNumber(Var res:BYTE);
  Var b:BYTE;
      s1:String;
      c:INTEGER;
  Begin
    If s=''
      Then res:=0 //default
      Else
        Begin
          b:=pos(':',s);
          If b<>0
            Then
              Begin
                s1:=System.Copy(s,1,b-1);
                delete(s,1,b);
              End
            Else
              Begin
                s1:=s;
                s:='';
              End;
          VAL(s1,res,c);
          If c<>0 Then res:=0;
        End;
  End;

Begin
  OldTimeFormat:=TimeFormat;
  Case OldTimeFormat Of
    tfTMSF:
       Begin
         //we must process strings :-(
         GetMCIStatusNumber(option);
         s:=FLastMCIReturn;
         {lock for tracks}
         result.Format:=tfTMSF;
         GetNextNumber(result.tmsf_Track);
         GetNextNumber(result.tmsf_Minutes);
         GetNextNumber(result.tmsf_Seconds);
         GetNextNumber(result.tmsf_Frames);
       End;
     tfBytes,tfSamples,tfSP,tfFrames:
       Begin
         result.Bytes:=GetMCIStatusNumber(option);
         If result.Bytes=-1
           Then result.Format:=tfUnknown
           Else result.Format:=OldTimeFormat;
       End;
    Else
        Begin //we can convert to mmtime and vice versa
          TimeFormat:=tfMMTime;
          result.mmTime:=GetMCIStatusNumber(option);
          If result.mmTime=-1
            Then result.Format:=tfUnknown
            Else
              Begin
                {$IFDEF OS2}
                result.Format:=tfMMTime;
                {$ENDIF}
                {$IFDEF Win32}
                result.Format:=tfMilliseconds;
                {$ENDIF}
                ConvertTimeInfo(result,OldTimeFormat);
              End;
          TimeFormat:=OldTimeFormat;
          exit;
        End;
    End;  // Case
End;

Function TMCIDevice.GetPosition:TTimeInfo;
Begin
  result:=GetMCITimeInfo('position');
End;

Function TMCIDevice.GetLength:TTimeInfo;
Begin
  result:=GetMCITimeInfo('length');
End;

Function TMCIDevice.GetVolume(Channel:TChannel):Byte;
Var s,s1:String;
    b:BYTE;
    c:INTEGER;
    Temp,Temp1:LONGINT;
Begin
  result:=-1;
  OpenDevice;
  If Not SendString('status '+AliasName+' volume wait',0) Then exit;
  s:=LastMCIReturn;
  b:=pos(':',s);
  If b=0 Then exit;
  Case Channel Of
    chLeft:s[0]:=chr(b-1);
    chRight:delete(s,1,b);
    chBoth:
      Begin
        s1:=s;
        s[0]:=chr(b-1);
        VAL(s,temp,c);
        If c<>0 Then exit;
        delete(s1,1,b);
        VAL(s1,temp1,c);
        If c<>0 Then exit;
        result:=(temp+temp1) Div 2;
        exit;
      End;
  End; {case}
  VAL(s,result,c);
  If c<>0 Then result:=-1;
End;

Procedure TMCIDevice.SetVolume(Channel:TChannel;NewVolume:Byte);
Var s:String;
Begin
  OpenDevice;
// GetCanSetVolume
  Case Channel Of
    chLeft:s:='left';
    chRight:s:='right';
    chBoth:s:='all';
  End; {Case}
  SendString('set '+AliasName+' audio '+s+' volume '+tostr(NewVolume)+' wait',0);
End;

Function CompareTimeInfos(TimeInfo1,TimeInfo2:TTimeInfo):LONGINT;
Label process;
Begin
  result:=-2; {cannot compare}
  Case TimeInfo1.Format Of
    tfTMSF,tfBytes,tfSamples,tfSP,tfFrames:
      Begin
        If TimeInfo2.Format=TimeInfo1.Format
          Then Goto process
          Else exit; {cannot compare}
      End;
    Else
      Begin
        {we can convert to mmtime}
        ConvertTimeInfo(TimeInfo1,tfMMTime);
        Case TimeInfo1.Format Of
          tfTMSF,tfBytes,tfSamples,tfSP,tfFrames:exit; {cannot compare}
          Else
            Begin
              {we can convert to mmtime}
              {$IFDEF OS2}
              ConvertTimeInfo(TimeInfo2,tfMMTime);
              {$ENDIF}
              {$IFDEF Win32}
              ConvertTimeInfo(TimeInfo2,tfMilliseconds);
              {$ENDIF}
process:
              If TimeInfo1.mmTime>TimeInfo2.mmTime
                Then result:=1        {first greater}
                Else
                  If TimeInfo1.mmTime<TimeInfo2.mmTime
                    Then result:=-1   {second greater}
                    Else result:=0;   {equal}
            End;
        End; {case}
      End;
  End; {case}
End;

Function ConvertTimeInfo(Var TimeInfo:TTimeInfo;NewFormat:TTimeFormat):BOOLEAN;
Var OldFormat:LONGWORD;
Begin
  result:=TRUE;
  Case TimeInfo.Format Of
    tfMSF:TimeInfo.msf_Reserved:=0;
    tfHMS:TimeInfo.hms_reserved:=0;
  End;
  If TimeInfo.Format=NewFormat Then exit;

  OldFormat:=TimeInfo.Unknown;
  {Convert format to MMTime, all conversions convert from MMTime format}
  Case TimeInfo.Format Of
    tfMilliSeconds:
      Begin
        If OldFormat>$FFFFFFFF Div 3
          Then OldFormat:=0
          Else OldFormat:=OldFormat*3;
      End;
    tfMMTime:;
    tfMSF:
      Begin
        OldFormat:=(OldFormat And $000000FF)*60*3000;
        OldFormat:=(OldFormat And $0000FF00) Div $100 * 3000;
        OldFormat:=(OldFormat And $00FF0000) Div $10000*3000 Div 75;
      End;
    tfHMS:
      Begin
        OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
        OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
        OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
      End;
    tfHMSF:
      Begin
        OldFormat:=(OldFormat And $000000FF)*60*3000;
        OldFormat:=(OldFormat And $0000FF00) Div $100 * 3000;
        OldFormat:=(OldFormat And $00FF0000) Div $10000*3000 Div 75;
        OldFormat:=(OldFormat And $FF000000) Div $1000000 Div 60*3000;
      End;
    tfSMPTE24:
      Begin
        OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
        OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
        OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
        OldFormat:=(OldFormat And $FF000000) Div $1000000 * 3000 Div 24;
      End;
    tfSMPTE25:
      Begin
        OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
        OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
        OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
        OldFormat:=(OldFormat And $FF000000) Div $1000000 * 3000 Div 25;
      End;
    tfSMPTE30:
      Begin
        OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
        OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
        OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
        OldFormat:=(OldFormat And $FF000000) Div $1000000 * 3000 Div 30;
      End;
    Else
      Begin
        //we cannot convert the format (for example tfTMSF) to MMTime
        result:=FALSE;
        exit;
      End;
  End; {case}

  {Convert Format to result}
  Case NewFormat Of
    tfMilliSeconds:
      Begin
        TimeInfo.Unknown:=(OldFormat+1) Div 3;
      End;
    tfMMTime:;
    tfMSF:
      Begin
        If (OldFormat+20)>=$100*60*3000
          Then TimeInfo.Unknown:=0
          Else TimeInfo.Unknown:=((((OldFormat)+20) Div (60*3000)) +
                                 (((OldFormat)+20) Mod (60*3000) Div 3000 Shl 8) +
                                 (((OldFormat)+20) Div (3000 Div 75) Mod 75 shl 16));
      End;
    tfHMS:
      Begin
        If (OldFormat+50)>=$100*60*60*3000
          Then TimeInfo.Unknown:=0
          Else TimeInfo.Unknown:=(((((((OldFormat)+50) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                 (((((((OldFormat)+50) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                 ((((((OldFormat)+50) Div 3000) Div 60) Div 60)  and $000000FF));
      End;
    tfHMSF:
      Begin
        If (OldFormat+20)>=$100*60*3000
          Then TimeInfo.Unknown:=0
          Else TimeInfo.Unknown:=(((OldFormat)+20) Mod (60*3000) Div 3000*60) +
                                 ((((OldFormat)+20) Div (60*3000) Shl 8) +
                                 (((OldFormat)+20) Mod (60*3000) Div 3000 Shl 16) +
                                 (((OldFormat)+20) Div (3000 Div 75) Mod 75 shl 24));
      End;
    tfSMPTE24:
      Begin
        If (OldFormat+63)>=$100*60*60*3000
          Then TimeInfo.Unknown:=0
          Else TimeInfo.Unknown:=(((((((OldFormat)+63) Mod 3000)Div(3000 Div 24)) Shl 24) And $FF000000) or
                                 ((((((OldFormat)+63) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                 (((((((OldFormat)+63) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                 ((((((OldFormat)+63) Div 3000) Div 60) Div 60)  And $000000FF));
      End;
    tfSMPTE25:
      Begin
        If (OldFormat+63)>=$100*60*60*3000
          Then TimeInfo.Unknown:=0
          Else TimeInfo.Unknown:=(((((((OldFormat)+63) Mod 3000)Div(3000 Div 25)) shl 24) And $FF000000) or
                                 ((((((OldFormat)+63) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                 (((((((OldFormat)+63) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                 ((((((OldFormat)+63) Div 3000) Div 60) Div 60)  and $000000FF));
      End;
    tfSMPTE30:
      Begin
        If (OldFormat+63)>=$100*60*60*3000
          Then TimeInfo.Unknown:=0
          Else TimeInfo.Unknown:=(((((((OldFormat)+63) Mod 3000)Div(3000 Div 30)) shl 24) And $FF000000) or
                                 ((((((OldFormat)+63) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                 (((((((OldFormat)+63) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                 ((((((OldFormat)+63) Div 3000) Div 60) Div 60)  and $000000FF));
      End;
    Else
      Begin
        result:=FALSE;
        exit;
      End;
  End;

  TimeInfo.Format:=NewFormat;
  Case TimeInfo.Format Of
    tfMSF:TimeInfo.msf_Reserved:=0;
    tfHMS:TimeInfo.hms_reserved:=0;
  End;
  result:=TRUE;
End;

Const TimeFormatsArray:Array[tfMilliSeconds..tfUnknown] Of String[30]=
         (
          'milliseconds',
          'mmtime',
          'msf',
          'tmsf',
          'frames',
          'hms',
          'hmsf',
          'bytes',
          'samples',
          'smpte 24',
          'smpte 25',
          'smpte 30',
          'song pointer',
          'unknown'
         );

Function TimeFormatToString(tf:TTimeFormat):String;
Begin
     result:=TimeFormatsArray[tf];
End;

Function TimeInfoToString(Const TimeInfo:TTimeInfo):String;
   Function ToStr(i:LONGINT):String;
   Begin
        result:=System.Tostr(i);
        If System.length(result)<2 Then result:='0'+result;
   End;

Begin
     With TimeInfo Do
     Case Format Of
           tfMilliSeconds:result:=tostr(MilliSeconds);
           tfMMTime:result:=tostr(MMTime);
           tfMSF:result:=tostr(msf_Minutes)+':'+tostr(msf_Seconds)+':'+tostr(msF_FramEs);
           tfTMSF:result:=tostr(tmsf_Track)+':'+tostr(tmsf_Minutes)+':'+tostr(tMsf_SeConds)+':'+tostr(tmsf_FRames);
           tfFrames:result:=System.tostr(Frames);
           tfHMS:result:=tostr(hms_Hours)+':'+tostr(hms_Minutes)+':'+tostr(hms_SecondS);
           tfHMSF:result:=tostr(hmsf_Hours)+':'+tostr(hmsf_Minutes)+':'+tostr(hMsf_SeConds)+':'+tostr(hmsf_FRames);
           tfBytes:result:=System.tostr(Bytes);
           tfSamples:result:=System.tostr(Samples);
           tfSMPTE24:result:=System.tostr(SMPTE24);
           tfSMPTE25:result:=System.tostr(SMPTE25);
           tfSMPTE30:result:=System.tostr(SMPTE30);
           tfSP:result:=System.tostr(SongPointer);
           tfUnknown:result:='???';
     End; {case}
End;

Procedure TMCIDevice.SetTimeFormat(NewFormat:TTimeFormat);
Begin
     If NewFormat=FTimeFormat Then exit;
     {$IFDEF Win32}
     If NewFormat=tfMMTime Then NewFormat:=tfMilliseconds;
     {$ENDIF}
     If Not (NewFormat In FTimeFormatsAvailable) Then exit;
     FTimeFormat:=NewFormat;
     If FDeviceOpen Then
     Begin
       SendString('set '+AliasName+' time format '+TimeFormatsArray[NewFormat]+' wait',0);
     End;
End;

Function TMCIDevice.GetTracks:LONGINT;
Begin
     result:=GetMCIStatusNumber('number of tracks');
End;

Procedure TMCIDevice.HandleMCIError(Const ErrorStr:String);
Begin
     ErrorBox(ErrorStr);
     If FDeviceOpen Then //clear error condition
     Begin
          CloseDevice;
          OpenDevice;
     End;
End;

Procedure TMCIDevice.ShowMCIError(Code:LONGWORD);
Var ErrBuff:Cstring;
    s:String;
    {$IFDEF OS2}
    ret:LONGWORD;
    {$ENDIF}
Begin
  {$IFDEF OS2}
  If Not InitMMPM2 Then exit;
  ret:=mciGetErrorStringAddr( Code, ErrBuff,255);
  Case ret Of
    MCIERR_SUCCESS:
      Begin
        s:=ErrBuff;
        HandleMCIError(s);
      End;
    Else HandleMCIError(LoadNLSStr(SUnknownMCIError));
  End; {case}
  {$ENDIF}
  {$IFDEF Win32}
  If mciGetErrorString( Code, ErrBuff,255)
    Then
      Begin
        s:=ErrBuff;
        HandleMCIError(s);
      End
    Else HandleMCIError(LoadNLSStr(SUnknownMCIError));
  {$ENDIF}
End;

Procedure TMCIDevice.SeekToStart;
Begin
  Load;
  Stop;
  SendString('seek '+AliasName+' to start wait',0);
  PositionChanged(Position);
End;

Procedure TMCIDevice.SeekToEnd;
Begin
  Load;
  Stop;
  SendString('seek '+AliasName+' to End wait',0);
  PositionChanged(Position);
End;

Function TMCIDevice.TimeInfoStr(TimeInfo:TTimeInfo;SaveTime:TTimeFormat):String;
Begin
     If SaveTime<>TimeInfo.Format Then
     Begin
          TimeFormat:=TimeInfo.Format;
          SaveTime:=TimeInfo.Format;
     End;

     Case SaveTime Of
        tfTMSF,tfHMSF:
        Begin
             result:=tostr(TimeInfo.tmsf_Track)+':'+
                     tostr(TimeInfo.tmsf_Minutes)+':'+
                     tostr(TimeInfo.tmsf_Seconds)+':'+
                     tostr(TimeInfo.tmsf_Frames);
        End;
        tfBytes,tfSamples,tfSP,tfFrames,tfMilliSeconds,tfMMTime,
        tfSMPTE24,tfSMPTE25,tfSMPTE30:
        Begin
             result:=tostr(TimeInfo.Bytes);
        End;
        tfMSF,tfHMS:
        Begin
             result:=tostr(TimeInfo.msf_Minutes)+':'+
                     tostr(TimeInfo.msf_Seconds)+':'+
                     tostr(TimeInfo.msf_Frames);
        End;
     End; {case}
End;

Procedure TMCIDevice.Seek(NewPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='seek '+AliasName+' to '+TimeInfoStr(NewPos,SaveTime)+' wait';
     TimeFormat:=SaveTime;
     SendString(s,0);
     PositionChanged(Position);
End;

Procedure TMCIDevice.Cut(StartPos,EndPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='copy '+AliasName+' from '+TimeInfoStr(StartPos,SaveTime)+
                          ' to '+TimeInfoStr(EndPos,SaveTime);
     TimeFormat:=SaveTime;
     SendString(s,0);
End;


Procedure TMCIDevice.Copy(StartPos,EndPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='copy '+AliasName+' from '+TimeInfoStr(StartPos,SaveTime)+
                          ' to '+TimeInfoStr(EndPos,SaveTime);
     TimeFormat:=SaveTime;
     SendString(s,0);
End;

Procedure TMCIDevice.Paste(StartPos,EndPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='paste '+AliasName+' from '+TimeInfoStr(StartPos,SaveTime)+
                          ' to '+TimeInfoStr(EndPos,SaveTime);
     TimeFormat:=SaveTime;
     SendString(s,0);
End;


Procedure TMCIDevice.StartRecording;
Begin
     OpenDevice;
     Stop;
     PositionAdvise:=TRUE;
     If SendString('record '+AliasName+' overwrite notify',0) Then FStatus:=mciRecording
     Else
     Begin
          PositionAdvise:=FALSE;
          FStatus:=mciError;
     End;
End;

Procedure TMCIDevice.Play;
Begin
     OpenDevice;
     Case FStatus Of
       mciStopped,mciNothing:
       Begin
            Load;
            PositionAdvise:=TRUE;
            If SendString('play '+AliasName+' notify',0)
            Then FStatus:=mciPlaying
            Else
            Begin
                 PositionAdvise:=FALSE;
                 FStatus:=mciError;
            End;
       End;
       mciPaused:Resume;
       mciPlaying:;
     End;
End;

Procedure TMCIDevice.SetPositionAdviseUnits(NewUnits:TTimeInfo);
Begin
  If Not (NewUnits.Format In FTimeFormatsAvailable) Then exit;
  FPositionAdviseUnits:=NewUnits;
  If FPositionAdvise Then
    Begin
      PositionAdvise:=FALSE;
      PositionAdvise:=TRUE;
    End;
End;

Procedure TMCIDevice.Resume;
Begin
  If FStatus<>mciPaused Then exit;
  If SendString('resume '+AliasName+' wait',0)
    Then FStatus:=mciPlaying
    Else FStatus:=mciError;
End;

Procedure TMCIDevice.Pause;
Begin
  If FStatus=mciPaused Then
    Begin
      Resume;
      exit;
    End;
  If FStatus<>mciPlaying Then exit;
  If SendString('pause '+AliasName+' wait',0)
    Then FStatus:=mciPaused
    Else FStatus:=mciError;
End;

Procedure TMCIDevice.Stop;
Begin
  If Not FDeviceOpen Then exit;
  PositionAdvise:=FALSE;
  If Not (FStatus In [mciPlaying,mciPaused,mciRewind]) Then exit;
  If SendString('stop '+AliasName+' wait',0)
    Then
      Begin
        Repeat
          Application.HandleMessage;
        Until Not (FStatus In [mciPlaying,mciPaused,mciRewind]);
      End
    Else FStatus:=mciError;
End;

Function TMCIDevice.SendString(Const s:String;usUserParm:WORD):BOOLEAN;
Var
   lmciSendStringRC:LONG;    /* return value fromm mciSendString    */
   szReturn:Cstring;
   c:Cstring;
   Handle:LONGWORD;
Begin
  Application.LogWriteln('MCI: '+s);
  c:=s;
  If FNotifyControl<>Nil
    Then Handle:=FNotifyControl.Handle
    Else Handle:=0;
  szReturn:='';
  {$IFDEF OS2}
  result:=FALSE;
  If Not InitMMPM2 Then exit;
  lmciSendStringRC:=mciSendStringAddr(c,szReturn,255,Handle,usUserParm);
  {$ENDIF}
  {$IFDEF Win32}
  lmciSendStringRC:=mciSendString(c,szReturn,255,Handle);
  {$ENDIF}
  FLastMCIReturn:=szReturn;
  If lmciSendStringRC <> 0
    Then
      Begin
        ShowMCIError(lmciSendStringRC);
        FStatus:=mciError;
        result:=FALSE;
      End
    Else result:=TRUE;
End;


Function TMCIDevice.AddCuePoint(Const CuePoint:TTimeInfo):LONGWORD;
Var SaveFormat:TTimeFormat;
Begin
  OpenDevice;
  SaveFormat:=TimeFormat;
  If SendString('setcuepoint '+AliasName+' on at '+TimeInfoStr(CuePoint,SaveFormat)+
                ' return '+tostr(FCuePointCount+1)+' wait',0)
    Then
      Begin
        inc(FCuePointCount);
        result:=FCuePointCount;
      End
    Else result:=0; {error}
  TimeFormat:=SaveFormat;
End;

Function TMCIDevice.DeleteCuePoint(Const CuePoint:TTimeInfo):BOOLEAN;
Var SaveFormat:TTimeFormat;
Begin
  OpenDevice;
  SaveFormat:=TimeFormat;
  If SendString('setcuepoint '+AliasName+' off at '+TimeInfoStr(CuePoint,SaveFormat)+
                ' wait',0)
    Then result:=TRUE
    Else result:=FALSE; {error}
  TimeFormat:=SaveFormat;
End;

Procedure TMCIDevice.CloseDevice;
Begin
  If Not FDeviceOpen Then exit;
  If FFileLoaded Then Stop;
  PositionAdvise:=FALSE;
  If SendString('close '+AliasName+' wait',0)
    Then
      Begin
        FStatus:=mciNothing;
        FDeviceOpen:=FALSE;
        FFileLoaded:=FALSE;
      End
    Else
      Begin
        HandleMCIError('Cannot close mci device '+DeviceName);
        FStatus:=mciError;
      End;
  FFileLoaded:=False;
End;

Procedure TMCIDevice.OpenDevice;
Var tf:TTimeFormat;
Begin
  If FDeviceOpen Then exit;
  If SendString('open '+DeviceName+' alias '+AliasName+' shareable wait', 0 )
    Then
      Begin
        /* Open success, set the flag and return true */
        fDeviceOpen := TRUE;
        tf:=FTimeFormat;
        FTimeFormat:=tfUnknown;
        TimeFormat:=tf;
        If FTimeFormat=tfUnknown Then FTimeFormat:=DefaultTimeFormat;
      End
    Else
      Begin
        HandleMCIError('Error opening mci device '+DeviceName);
        FStatus:=mciError;
      End;
End;


Procedure TMCIDevice.SetupComponent;
Var PosAdviseUnits:TTimeInfo;
Begin
  Inherited SetupComponent;

  DeviceName:='Unknown';
  AliasName:='Unknown';

  FNotifyControl:=TMCINotifyControl.Create(Self);
  TMCINotifyControl(FNotifyControl).FDevice:=Self;
  TMCINotifyControl(FNotifyControl).CreateWnd;

  FStatus:=mciNothing;
  FFileName:='';
  FFileNameRequired:=TRUE;
  FTimeFormatsAvailable:=[tfMilliseconds,tfMMTime];
  FDefaultTimeFormat:=tfMilliseconds;
  FTimeFormat:=FDefaultTimeFormat;
  Include(ComponentState, csHandleLinks);
  PosAdviseUnits.Format:=tfMilliseconds;
  PosAdviseUnits.Milliseconds:=1000;
  PositionAdviseUnits:=PosAdviseUnits;
End;

Procedure TMCIDevice.Load;
Var  mciStr:String;
Begin
  If FileName=''
    Then
      Begin
        If FFileNameRequired
          Then
            Begin
              HandleMCIError(LoadNLSStr(SNoFileName));
              FStatus:=mciError;
            End
          Else FFileLoaded:=TRUE;
        exit; //no file loaded
      End
    Else If Not FFileNameRequired Then exit;
  Screen.Cursor := crHourglass;
  OpenDevice;
  If Not FFileLoaded Then
    Begin
      mciStr:='load '+AliasName+' '+FileName+' wait';
      If Not SendString(mciStr,0) Then
        Begin
          Screen.Cursor := crDefault;
          FStatus:=mciError;
          exit;
        End;

       FFileLoaded:=TRUE;
     End;
     Screen.Cursor := crDefault;
End;

Destructor TMCIDevice.Destroy;
Begin
  Stop;
  CloseDevice;
  FNotifyControl.Destroy;
  FNotifyControl:=Nil;
  FFileName:='';
  Inherited Destroy;
End;

Function TMCIDevice.WriteSCUResource(Stream:TResourceStream):BOOLEAN;
Var s:String;
Begin
  Result := Inherited WriteSCUResource(Stream);
  If Not Result Then exit;
  s:=FileName;
  If s<>'' Then result:=Stream.NewResourceEntry(rnFileName,s,System.length(s)+1);
End;

Procedure TMCIDevice.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LONgiNT);
Var s:String;
Begin
  If ResName = rnFileName
    Then
      Begin
        If DataLen<>0 Then
          Begin
            move(Data,s,DataLen);
            FileName:=s;
          End;
      End
    Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure TMCIDevice.PlayingCompleted;
Begin
  If FOnPlayingCompleted<>Nil Then FOnPlayingCompleted(Self);
End;

Procedure TMCIDevice.PlayingAborted;
Begin
  If FOnPlayingAborted<>Nil Then FOnPlayingAborted(Self);
End;

{$HINTS OFF}
Procedure TMCIDevice.CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);
Begin
  If OnCuePointReached<>Nil Then OnCuePointReached(Self,CuePoint,CuePointId);
End;

Procedure TMCIDevice.PositionChanged(Const NewPosition:TTimeInfo);
Begin
  If OnPositionChanged<>Nil Then OnPositionChanged(Self,NewPosition);
End;
{$HINTS ON}

Procedure TMCIDevice.MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUserCOde:LONGWORD);
Var TimeInfo:TTimeInfo;
    LinkList:TList;

Begin
     Case Event Of
         mciNotifySuperseded:;
         mciNotifyAborted:
         Begin
              FStatus:=mciStopped;
              PlayingAborted;
              PositionAdvise:=FALSE;
         End;
         mciNotifyError:
         Begin
              FStatus:=mciError;
              If ulNotifyCode<>0 Then ShowMCIError(ulNotifyCode)
              Else ErrorBox(LoadNLSStr(SFatalMCIError));
              PositionAdvise:=FALSE;
         End;
         mciNotifySuccess:
         Begin
              FStatus:=mciStopped;
              PlayingCompleted;
              PositionAdvise:=FALSE;
         End;
         mciNotifyPositionChange:
         Begin
              If TimeFormat=tfTMSF Then TimeInfo:=Position
              Else
              Begin
                  TimeInfo.Format:=tfMMTime;
                  TimeInfo.mmTime:=ulNotifyCode;
                  ConvertTimeInfo(TimeInfo,TimeFormat);
              End;
              PositionChanged(TimeInfo);
         End;
         mciNotifyCuePoint:
         Begin
              TimeInfo.Format:=tfMMTime;
              TimeInfo.mmTime:=ulNotifyCode;
              ConvertTimeInfo(TimeInfo,TimeFormat);
              CuePointReached(TimeInfo,ulUserCode);
         End;
     End; {case}

     LinkList:=FreeNotifyList;
     ulDeviceId:=DeviceId;
/*     If LinkList<>Nil Then For t:=0 To LinkList.Count-1 Do
     Begin
       Component:=LinkList[t];
       If Component Is TVideoWindow
         Then
           TVideoWindow(Component).MCIEvent(Event,ulDeviceId,ulNotifyCode,ulUserCodE)
         Else If Component Is TMediaPlayer
           Then
             TMediaPlayer(Component).MCIEvent(Event,ulDeviceId,ulNotifyCode,ulUserCodE);      End;
*/
End;


Begin
  {$IFDEF OS2}
  MMPM2Initialized:=false;
  {$ENDIF}
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  01-Jul-04   WD        CDDevice: Einbau von GetMediumID bzw. MediumID
  05-Jul-04   WD        Eigener MultiMedia-Projekt erstellt.
  15-Jul-04   WD        SetVolume, GetVolume auf Byte umgestellt.
  28-Aug-05   WD        Variablen die nicht verwendet werden entfernt.
}
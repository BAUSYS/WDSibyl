{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Multimedia Classes                                            บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit uMMDevices;

Interface

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmBitmap;
{$ENDIF}
{$IFDEF Win32}
Uses WinDef,WinBase,WinUser,MMSystem;
{$ENDIF}

Uses SysUtils,Messages,Color,Classes,Forms,Graphics,StdCtrls,Dialogs,Buttons,
     uList, MMedia;



type TCDMediaTypes=(mtAudio,mtData,mtOther,mtUnknown);

     TCDDeviceCapabilities=Record
       CanProcessInternal:BOOLEAN;
       CanStream:BOOLEAN;
     End;

// ----- CD-Device

     TCDDevice=Class(TMCIDevice)
       Private
         Function GetTrackChannels(Track:LONGINT):LONGINT;
         Function GetTrackPosition(Track:LONGINT):TTimeInfo;
         Function GetPositionInTrack:TTimeInfo;
         Function GetStartPosition:TTimeInfo;
         Function GetMediaType:TCDMediaTypes;
         Function GetTrackType(Track:LONGINT):TCDMediaTypes;
         Function GetCapabilities:TCDDeviceCapabilities;
         Function GetMediumID:String; Override;
       Private
         Property FileName;
       Protected
         Procedure SetupComponent;Override;
       Public
         Procedure Eject;Virtual;
         Procedure Close;Virtual;
         Procedure LockDoor;Virtual;
         Procedure UnlockDoor;Virtual;
         Procedure NextTrack;Override;
         Procedure PreviousTrack;Override;
         Procedure Resume;Override;

         Property MediumID : String Read GetMediumID;
         Property TrackChannels[Track:LONGINT]:LONGINT read GetTrackChannels;
         Property TrackPosition[Track:LONGINT]:TTimeInfo read GetTrackPosition;
         Property PositionInTrack:TTimeInfo read GetPositionInTrack;
         Property StartPosition:TTimeInfo read GetStartPosition;
         Property MediaType:TCDMediaTypes read GetMediaType;
         Property TrackType[Track:LONGINT]:TCDMediaTypes read GetTrackType;
         Property Capabilities:TCDDeviceCapabilities read GetCapabilities;
     End;

// ----- Video-Device

type TVideoDeviceCapabilities=Record
         CanDistort:BOOLEAN;
         CanProcessInternal:BOOLEAN;
         CanRecordInsert:BOOLEAN;
         CanStream:BOOLEAN;
         CanStretch:BOOLEAN;
         FastPlayRate:LONGWORD;
         HasTuner:BOOLEAN;
         HorizontalVideoExtent:LONGWORD;
         HorizontalImageExtent:LONGWORD;
         NormalPlayRate:LONGWORD;
         SlowPlayRate:LONGWORD;
         VerticalImageExtent:LONGWORD;
         VerticalVideoExtent:LONGWORD;
    End;


    TVideoDevice=Class(TMCIDevice)
      Private
         FVideoWindow:TControl;
      Private
         Function GetCapabilities:TVideoDeviceCapabilities;
         Function GetBitsPerSample:LONGINT;
         Function GetImageBitsPerPel:LONGINT;
         Function GetImagePelFormat:String;
         Function GetBrightness:LONGINT;
         Function GetContrast:LONGINT;
         Function GetHue:LONGINT;
         Function GetClipBoardDataAvail:BOOLEAN;
         Function GetSaturation:LONGINT;
         Function GetSamplesPerSec:LONGINT;
         Function GetTunerTVChannel:LONGINT;
         Function GetTunerFineTune:LONGINT;
         Function GetTunerFrequency:LONGINT;
         Function GetValidSignal:BOOLEAN;
         Procedure SetBrightness(NewValue:LONGINT);
         Procedure SetContrast(NewValue:LONGINT);
         Procedure SetHue(NewValue:LONGINT);
         Procedure SetSaturation(NewValue:LONGINT);
         Procedure SetSamplesPerSec(NewValue:LONGINT);
         Procedure SetTunerTVChannel(NewValue:LONGINT);
         Procedure SetTunerFineTune(NewValue:LONGINT);
         Procedure SetTunerFrequency(NewValue:LONGINT);
      Private
         Property DeviceName;
      Protected
         Procedure SetupComponent;Override;
         Procedure GetDefaultFileMask(Var Ext,Description:String);Override;
      Public
         Procedure Seek(NewPos:TTimeInfo);Override;
         Procedure SeekToStart;Override;
         Procedure Load;Override;
         Property Capabilities:TVideoDeviceCapabilities read GetCapabilities;
         Property BitsPerSample:LONGINT read GetBitsPerSample;
         Property ImageBitsPerPel:LONGINT read GetImageBitsPerPel;
         Property ImagePelFormat:String read GetImagePelFormat;
         Property Brightness:LONGINT read GetBrightness write SetBrightness;
         Property Contrast:LONGINT read GetContrast write SetContrast;
         Property Hue:LONGINT read GetHue write SetHue;
         Property ClipBoardDataAvail:BOOLEAN read GetClipBoardDataAvail;
         Property Saturation:LONGINT read GetSaturation write SetSaturation;
         Property SamplesPerSec:LONGINT read GetSamplesPerSec write SetSamplesPerSEc;
         Property TunerTVChannel:LONGINT read GetTunerTVChannel write SetTunerTVChAnneL;
         Property TunerFineTune:LONGINT read GetTunerFineTune write SetTunerFineTuNe;
         Property TunerFrequency:LONGINT read GetTunerFrequency write SetTunerFreqUencY;
         Property ValidSignal:BOOLEAN read GetValidSignal;

         Property AliasName;
    End;

    TVideoWindow=Class(TControl)
      Private
         FVideoDevice:TVideoDevice;
         hwndFrame:HWND;
         ulMovieWidth,ulMovieHeight,ulMovieLength:LONGWORD;
         FOnPlayingCompleted:TNotifyEvent;
         FOnPlayingAborted:TNotifyEvent;
         FOnPositionChanged:TMCIPositionChanged;
         FOnCuePointReached:TMCICuePointReached;
      Private
         Function DoesFileExist(pszFileName:String):BOOLEAN;
         Procedure SetVideoDevice(NewDevice:TVideoDevice);
      Protected
         Procedure SetupComponent;Override;
         Procedure PositionChanged(Const NewPosition:TTimeInfo);Virtual;
         Procedure CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);Virtual;
         Procedure PlayingCompleted;Virtual;
         Procedure PlayingAborted;Virtual;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
      Public
         Procedure MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUsErcode:LoNGword);Virtual;
         Procedure Redraw(Const rc:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentShowHint;
         Property ShowHint;
         Property VideoDevice:TVideoDevice read FVideoDevice write SetVideoDeviCe;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnCuePointReached:TMCICuePointReached read FOnCuePointReached wrIte FonCuepoinTreached;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnPlayingAborted:TNotifyEvent read FOnPlayingAborted write FONplAyinGabOrted;
         Property OnPlayingCompleted:TNotifyEvent read FOnPlayingCompleted writE FOnPlAyiNgcomplEted;
         Property OnPositionChanged:TMCIPositionChanged read FOnPositionChanged wrIte FonPositioNchanGed;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

// ----- Audio-Device

type TAudioDevice=Class(TMCIDevice)
      Private
         Function GetAlignment:LONGINT;
         Function GetBitsPerSample:LONGINT;
         Function GetBytesPerSec:LONGINT;
         Function GetSamplesPerSec:LONGINT;
         Procedure SetBitsPerSample(NewValue:LONGINT);
         Procedure SetBytesPerSec(NewValue:LONGINT);
         Procedure SetSamplesPerSec(NewValue:LONGINT);
      Private
         Property DeviceName;
      Protected
         Procedure SetupComponent;Override;
         Procedure GetDefaultFileMask(Var Ext,Description:String);Override;
      Public
         Property Alignment:LONGINT read GetAlignment;
         Property BitsPerSample:LONGINT read GetBitsPerSample write SetBitsPerSampLe;
         Property BytesPerSec:LONGINT read GetBytesPerSec write SetBytesPerSec;
         Property SamplesPerSec:LONGINT read GetSamplesPerSec write SetSamplesPerSEc;
      Public
         Property AliasName;
    End;

// ------ Funktionen und Proceduren

Function MediaTypeToString(mt:TCDMediaTypes):String;

Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (Multimedia)                           บ
บ                                                                           บ
บ This section: TCDDevice Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TCDDevice.GetMediumID:String;

  Function cddb_sum(iTrackPos : LongWord) : LongWord;

  Begin
    Result := 0;
    while iTrackPos>0 do
      begin
        Result := Result + (iTrackPos mod 10);
        iTrackPos := iTrackPos div 10;
      end;
  End;

Var Time : tTimeInfo;
    Cou  : Byte;
    LWSec: Longword;
    n    : LongWord;
    Query: String;
    OldTF: TTimeFormat;

Begin
  Result:=inherited GetMediumID;

  LockDoor;
  if (MediaPresent) and
     (MediaType = mtAudio) then
    Begin
      OldTF:=TimeFormat;
      TimeFormat:=tfMSF;
      n:=0;
      Query:='';
      for Cou:=1 to Tracks do
        Begin
          Time:=TrackPosition[Cou];
          LWSec:=Time.msf_Minutes*60 + Time.msf_Seconds;
          Query:=Query+' '+tostr(LWSec*75 + Time.msf_Frames);
          n := n + cddb_sum(LWSec);
        End;
        Time:=Length;
        LWSec:=Time.msf_Minutes*60 + Time.msf_Seconds;
        Result:=System.Copy(lowercase(tohex(((n mod $FF) shl 24) or
                                      (LWSec shl 8) or
                                      Tracks)),
                             2,8) + ' ' +
                toStr(Tracks) + ' ' +
                Query + ' ' +
                toStr(LWSec);
        TimeFormat:=OldTF;
    End;
  UnLockDoor;
End;

Procedure TCDDevice.Resume;

Begin
  If fStatus<>mciPaused Then exit;
  {$IFDEF Win32}
  If Self Is TCDDevice Then //resume not supported for MCICDA Win32
    Begin
      fStatus:=mciStopped;  //prevent recursion
      Play;
      exit;
    End;
  {$ENDIF}

  inherited Resume;
End;


Procedure TCDDevice.NextTrack;
Var OldStatus:TMCIStatus;
    trk:LONGINT;
Begin
     OpenDevice;
     Trk:=CurrentTrack;
     If Trk+1>Tracks Then exit;
     OldStatus:=fStatus;
     Stop;
     Seek(TrackPosition[trk+1]);
     If OldStatus=mciPlaying Then Play;
End;

Procedure TCDDevice.PreviousTrack;
Var OldStatus:TMCIStatus;
    trk:LONGINT;
    ti:TTimeInfo;
Begin
     OpenDevice;
     Trk:=CurrentTrack;
     OldStatus:=fStatus;
     Stop;
     ti:=PositionInTrack;
     ConvertTimeInfo(ti,tfHMS);
     If ((ti.Format=tfHMS)And(ti.hms_Seconds<1)) Then dec(trk);
     If trk=0 Then trk:=1;
     Seek(TrackPosition[trk]);
     If OldStatus=mciPlaying Then Play;
End;

Procedure TCDDevice.SetupComponent;
Begin
  Inherited SetupComponent;

  AliasName:='Sibyl_CD';
  DeviceName:='cdaudio';
  FileNameRequired:=FALSE;
  FTimeFormatsAvailable:=[tfMilliseconds,tfMMtime,tfMSF,tfTMSF];
  FDefaultTimeFormat:=tfTMSF;
  FTimeFormat:=FDefaultTimeFormat;
End;


Function TCDDevice.GetTrackChannels(Track:LONGINT):LONGINT;
Begin
  If Track=0 Then Track:=CurrentTrack;
  result:=GetMCIStatusNumber('channels track '+tostr(Track));
End;


Function TCDDevice.GetTrackPosition(Track:LONGINT):TTimeInfo;
Begin
  If Track=0 Then Track:=CurrentTrack;
  result:=GetMCITimeInfo('position track '+tostr(track));
End;

Function TCDDevice.GetPositionInTrack:TTimeInfo;
Begin
  result:=GetMCITimeInfo('position in track');
End;

Function TCDDevice.GetStartPosition:TTimeInfo;
Begin
  result:=GetMCITimeInfo('start position');
End;

Const MediaTypesArray:Array[mtAudio..mtUnknown] Of String[8]=
          ('audio', 'data', 'other', 'unknown');

Function MediaTypeToString(mt:TCDMediaTypes):String;
Begin
  result:=MediaTypesArray[mt];
End;

Function TCDDevice.GetMediaType:TCDMediaTypes;
Var t:TCDMediaTypes;
Begin
     result:=mtUnknown;
     If Not DeviceOpen Then OpenDevice;
     If Not SendString('status '+AliasName+' type wait',0) Then exit;
     For t:=mtAudio To mtOther Do
       If LastMCIReturn=MediaTypesArray[t] Then
       Begin
            result:=t;
            exit;
       End;
End;

Function TCDDevice.GetTrackType(Track:LONGINT):TCDMediaTypes;
Var t:TCDMediaTypes;
Begin
     result:=mtUnknown;
     If Track=0 Then Track:=CurrentTrack;
     If Not DeviceOpen Then OpenDevice;
     If Not SendString('status '+AliasName+' type track '+tostr(track)+' wait',0) Then exit;
     For t:=mtAudio To mtOther Do
       If LastMCIReturn=MediaTypesArray[t] Then
       Begin
            result:=t;
            exit;
       End;
End;

Function TCDDevice.GetCapabilities:TCDDeviceCapabilities;
Begin
     FillChar(result,sizeof(TCDDeviceCapabilities),0);
     If Not DeviceOpen Then OpenDevice;
     result.CanProcessInternal:=GetMCICapBoolean('can process internal');
     result.CanStream:=GetMCICapBoolean('can stream');
End;

Procedure TCDDevice.Eject;
Begin
     If Not DeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door open wait',0);
End;

Procedure TCDDevice.Close;
Begin
     If Not DeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door closed wait',0);
End;

Procedure TCDDevice.LockDoor;
Begin
     If Not DeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door locked wait',0);
End;

Procedure TCDDevice.UnlockDoor;
Begin
     If Not DeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door unlocked wait',0);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (MultiMedia)                           บ
บ                                                                           บ
บ This section: TAudioDevice Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TAudioDevice.SetBitsPerSample(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' bitspersample '+tostr(NewValue)+' wait',0);
End;

Procedure TAudioDevice.SetBytesPerSec(NewValue:LONGINT);
Begin
  SendString('set '+AliasName+' bytespersec '+tostr(NewValue)+' wait',0);
End;

Procedure TAudioDevice.SetSamplesPerSec(NewValue:LONGINT);
Begin
  SendString('set '+AliasName+' samplespersec '+tostr(NewValue)+' wait',0);
End;

Function TAudioDevice.GetAlignment:LONGINT;
Begin
  result:=GetMCIStatusNumber('alignment');
End;

Function TAudioDevice.GetBitsPerSample:LONGINT;
Begin
  result:=GetMCIStatusNumber('bitspersample');
End;

Function TAudioDevice.GetBytesPerSec:LONGINT;
Begin
  result:=GetMCIStatusNumber('bytespersec');
End;

Function TAudioDevice.GetSamplesPerSec:LONGINT;
Begin
  result:=GetMCIStatusNumber('samplespersec');
End;

Procedure TAudioDevice.SetupComponent;
Begin
  Inherited SetupComponent;

  AliasName:='Sibyl_audio';
  DeviceName:='waveaudio';
  FTimeFormatsAvailable:=[tfMilliseconds,tfMMtime,tfBytes,tfSamples];
End;

Procedure TAudioDevice.GetDefaultFileMask(Var Ext,Description:String);
Begin
  Ext:='*.WAV';
  Description:=LoadNLSStr(SWaveFiles);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (Multimedia)                           บ
บ                                                                           บ
บ This section: TVideoDevice Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
type XDIBHDR_PREFIX=Record
                         ulMemSize:LONGWORD;
                         ulPelFormat:LONGWORD;
                         usTransType:WORD;
                         ulTransVal:LONGWORD;
    End;


     PGENPAL=^GENPAL;
     GENPAL=Record
            ulStartIndex:ULONG;
            ulNumColors:ULONG;
            prgb2Entries:PRGB2;
     End;

     PMMXDIBHEADER=^MMXDIBHEADER;
     MMXDIBHEADER=Record
                       XDIBHeaderPrefix:XDIBHDR_PREFIX;
                       BMPInfoHeader2:BITMAPINFOHEADER2;
     End;

    PMMMOVIEHEADER=^MMMOVIEHEADER;
    MMMOVIEHEADER=Record
                        ulStructLen:LONGWORD;
                        ulContentType:LONGWORD;
                        ulMediaType:LONGWORD;
                        ulMovieCapsFlags:LONGWORD;
                        ulMaxBytesPerSec:LONGWORD;
                        ulPaddingGranularity:LONGWORD;
                        ulSuggestedBufferSize:LONGWORD;
                        ulStart:LONGWORD;
                        ulLength:LONGWORD;
                        ulNextTrackID:LONGWORD;
                        ulNumEntries:LONGWORD;
                        pmmTrackInfoList:PMMTRACKINFO;
                        pszMovieTitle:PChar;
                        ulCountry:LONGWORD;
                        ulCodePage:LONGWORD;
                        ulAvgBytesPerSec:LONGWORD;
   End;

   PMMVIDEOHEADER=^MMVIDEOHEADER;
   MMVIDEOHEADER=Record
                        ulStructLen:LONGWORD;
                        ulContentType:LONGWORD;
                        ulMediaType:LONGWORD;
                        ulVideoCapsFlags:LONGWORD;
                        ulWidth:LONGWORD;
                        ulHeight:LONGWORD;
                        ulScale:LONGWORD;
                        ulRate:LONGWORD;
                        ulStart:LONGWORD;
                        ulLength:LONGWORD;
                        ulTotalFrames:LONGWORD;
                        ulInitialFrames:LONGWORD;
                        mmtimePerFrame:MMTIME;
                        ulSuggestedBufferSize:LONGWORD;
                        genpalVideo:GENPAL;
                        pmmXDIBHeader:PMMXDIBHEADER;
    End;
{$ENDIF}

Function TVideoDevice.GetCapabilities:TVideoDeviceCapabilities;

Begin
     OpenDevice;
     result.CanDistort:=GetMCICapBoolean('can distort');
     result.CanProcessInternal:=GetMCICapBoolean('can process internal');
     result.CanRecordInsert:=GetMCICapBoolean('can record insert');
     result.CanStream:=GetMCICapBoolean('can stream');
     result.CanStretch:=GetMCICapBoolean('can stretch');
     result.FastPlayRate:=GetMCICapLong('fast play rate');
     result.HasTuner:=GetMCICapBoolean('has tuner');
     result.HorizontalVideoExtent:=GetMCICapLong('horizontal video extent');
     result.HorizontalImageExtent:=GetMCICapLong('horizontal image extent');
     result.NormalPlayRate:=GetMCICapLong('normal play rate');
     result.SlowPlayRate:=GetMCICapLong('slow play rate');
     result.VerticalImageExtent:=GetMCICapLong('vertical image extent');
     result.VerticalVideoExtent:=GetMCICapLong('vertical video extent');
End;

Procedure TVideoDevice.Seek(NewPos:TTimeInfo);
Begin
     OpenDevice;
     Inherited Seek(NewPos);

     {$IFDEF OS2}
     {SendString('step '+AliasName+' wait',0);
     SendString('step '+AliasName+' reverse wait',0);}
     {$ENDIF}
End;

Procedure TVideoDevice.SeekToStart;
Begin
     OpenDevice;
     Inherited SeekToStart;

     {$IFDEF OS2}
     {SendString('step '+AliasName+' wait',0);
     SendString('step '+AliasName+' reverse wait',0);}
     {$ENDIF}
End;

Procedure TVideoDevice.SetupComponent;
Var PosAdviseUnits:TTimeInfo;
Begin
     Inherited SetupComponent;
     AliasName:='Sibyl_movie';
     {$IFDEF OS2}
     DeviceName:='digitalvideo';
     {$ENDIF}
     {$IFDEF Win32}
     DeviceName:='avivideo';
     {$ENDIF}
     FTimeFormatsAvailable:=[tfMilliseconds,tfMMtime,tfFrames,tfHMS,tfHMSF];
     FDefaultTimeFormat:=tfFrames;
     FTimeFormat:=FDefaultTimeFormat;
     PosAdviseUnits.Format:=tfFrames;
     PosAdviseUnits.Frames:=1;
     PositionAdviseUnits:=PosAdviseUnits;
End;

Procedure TVideoDevice.GetDefaultFileMask(Var Ext,Description:String);
Begin
     Ext:='*.AVI';
     Description:=LoadNLSStr(SVideoFiles);
End;

Procedure TVideoDevice.Load;
Var
   szHandle:Cstring[10];
   szWindowString:Cstring;
   szPutString:Cstring;
   {$IFDEF OS2}
   swpAppFrame:SWP;
   szx:Cstring[5];
   szy:Cstring[5];
   szcx:Cstring[5];
   szcy:Cstring[5];
   {$ENDIF}
   {$IFDEF Win32}
   ret:LONG;
   hwndMovie:HWND;
   s:String;
   c:INTEGER;
   rc:TRect;
   {$ENDIF}
Begin
   If FileName='' Then
   Begin
     ErrorBox(LoadNLSStr(SNoFilename));
     fStatus:=mciError;
     exit; //no movie loaded
   End;

   Screen.Cursor := crHourglass;

   OpenDevice;
   {$IFDEF OS2}
   szWindowString:='window '+AliasName+' handle ';
   If FVideoWindow<>Nil Then
   Begin
        szHandle:=tostr(FVideoWindow.Handle);
        szWindowString:=szWindowString+szHandle+' wait';
   End
   Else szWindowString:=szWindowString+'default';

   If Not SendString(szWindowString, 0) Then
   Begin
        Screen.Cursor := crDefault;
        fStatus:=mciError;
        exit;
   End;
   {$ENDIF}

   {$IFDEF Win32}
   If Not FFileLoaded Then
   Begin
        szWindowString:='open '+FileName+
                        ' alias '+AliasName+' style child parent ';
        If FVideoWindow<>Nil Then szHandle:=tostr(FVideoWindow.Handle)
        Else szHandle:='default';
        szWindowString:=szWindowString+szHandle;
        If Not SendString(szWindowString, 0) Then
        Begin
             Screen.Cursor := crDefault;
             FStatus:=mciError;
             exit;
        End;
   End;
   {$ENDIF}

   {$IFDEF OS2}
   If Not FFileLoaded Then
   Begin
       If SendString('load '+AliasName+' '+FileName+' wait', 0)
           Then FFileLoaded := TRUE
       Else
       Begin
            Screen.Cursor := crDefault;
            FStatus:=mciError;
            exit;
       End;
       SeekToStart;
   End;
   {$ENDIF}

   If Not FFileLoaded Then
   Begin
        {$IFDEF OS2}
        If FVideoWindow<>Nil Then
        Begin
             WinQueryWindowPos (FNotifyControl.Handle, swpAppFrame);

             swpAppFrame.x := 0;
             swpAppFrame.y := 0;

             szx:=tostr(swpAppFrame.x);
             szy:=tostr(swpAppFrame.y);
             szcx:=tostr(swpAppFrame.cx);
             szcy:=tostr(swpAppFrame.cy);

             szPutString:='put '+AliasName+' destination at ';
             szPutString:=szPutString+szx+' '+szy+' '+szcx+' '+szcy+' '+'wait';

             If Not SendString( szPutString, 0 ) Then
             Begin
                  Screen.Cursor := crDefault;
                  FStatus:=mciError;
                  exit;
             End;
        End;

        {$ENDIF}
        {$IFDEF Win32}
        ret:=mciSendString('status '+AliasName+' window handle',
                           szPutString,255,0);
        If ret<>0 Then
        Begin
             Screen.Cursor := crDefault;
             FStatus:=mciError;
             ShowMCIError(ret);
             exit;
        End;

        s:=szPutString;
        VAL(s,hwndMovie,c);
        If c<>0 Then
        Begin
             Screen.Cursor := crDefault;
             FStatus:=mciError;
             ErrorBox(LoadNLSStr(SWrongMovieHandle));
             exit;
        End;

        If FVideoWindow<>Nil Then
        Begin
             rc:=FVideoWindow.ClientRect;
             {???????+-1}
             inc(rc.Right);
             inc(rc.Top);
             {wo Konverierung ?}
             MoveWindow(hwndMovie,rc.Left,rc.Bottom,
                        rc.Right,rc.Top,TRUE);
        End;
        {$ENDIF}
   End;

   {$IFDEF Win32}
   If Not FFileLoaded Then
     If Not SendString('window '+AliasName+' state show',0) Then
   Begin
        Screen.Cursor := crDefault;
        FStatus:=mciError;
        exit;
   End;
   FFileLoaded:=TRUE;
   {$ENDIF}

   Screen.Cursor := crDefault;
End;

Function TVideoDevice.GetBitsPerSample:LONGINT;
Begin
     result:=GetMCIStatusNumber('bitspersample');
End;

Function TVideoDevice.GetImageBitsPerPel:LONGINT;
Begin
     result:=GetMCIStatusNumber('image bitsperpel');
End;

Function TVideoDevice.GetImagePelFormat:String;
Begin
     GetMCIStatusNumber('image pelformat');
     result:=FLastMCIReturn;
End;

Function TVideoDevice.GetBrightness:LONGINT;
Begin
     result:=GetMCIStatusNumber('brightness');
End;

Function TVideoDevice.GetContrast:LONGINT;
Begin
     result:=GetMCIStatusNumber('contrast');
End;

Function TVideoDevice.GetHue:LONGINT;
Begin
     result:=GetMCIStatusNumber('hue');
End;

Function TVideoDevice.GetClipBoardDataAvail:BOOLEAN;
Begin
     result:=GetMCIStatusBoolean('clipboard');
End;

Function TVideoDevice.GetSaturation:LONGINT;
Begin
     result:=GetMCIStatusNumber('saturation');
End;

Function TVideoDevice.GetSamplesPerSec:LONGINT;
Begin
     result:=GetMCIStatusNumber('samplespersec');
End;

Function TVideoDevice.GetTunerTVChannel:LONGINT;
Begin
     result:=GetMCIStatusNumber('tuner tv channel');
End;

Function TVideoDevice.GetTunerFineTune:LONGINT;
Begin
     result:=GetMCIStatusNumber('tuner finetune');
End;

Function TVideoDevice.GetTunerFrequency:LONGINT;
Begin
     result:=GetMCIStatusNumber('tuner frequency');
End;

Function TVideoDevice.GetValidSignal:BOOLEAN;
Begin
     result:=GetMCIStatusBoolean('valid signal');
End;

Procedure TVideoDevice.SetBrightness(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' brightness '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetContrast(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' contrast '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetHue(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' hue '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetSaturation(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' saturation '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetSamplesPerSec(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' samplespersec '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetTunerTVChannel(NewValue:LONGINT);
Begin
     SendString('settuner '+AliasName+' tv channel '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetTunerFineTune(NewValue:LONGINT);
Var Temp:LONGINT;
    s:String[10];
Begin
     Temp:=TunerFineTune;
     If NewValue=Temp Then exit;
     If NewValue<Temp Then s:='minus '
     Else s:='plus ';
     SendString('settuner '+AliasName+' finetune '+s+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetTunerFrequency(NewValue:LONGINT);
Begin
     SendString('settuner '+AliasName+' frequency '+tostr(NewValue)+' wait',0);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TVideoWindow Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TVideoWindow.PlayingCompleted;
Begin
     If FOnPlayingCompleted<>Nil Then FOnPlayingCompleted(Self);
End;

Procedure TVideoWindow.PlayingAborted;
Begin
     If FOnPlayingAborted<>Nil Then FOnPlayingAborted(Self);
End;

{$HINTS OFF}
Procedure TVideoWindow.CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);
Begin
     If OnCuePointReached<>Nil Then OnCuePointReached(Self,CuePoint,CuePointId);
End;

Procedure TVideoWindow.PositionChanged(Const NewPosition:TTimeInfo);
Begin
     If OnPositionChanged<>Nil Then OnPositionChanged(Self,NewPosition);
End;
{$HINTS ON}

Procedure TVideoWindow.MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUSerCode:LONGWORD);
Var TimeInfo:TTimeInfo;
Begin
     Case Event Of
         mciNotifySuperseded:;
         mciNotifyAborted:
         Begin
              VideoDevice.Status:=mciStopped;
              PlayingAborted;
              VideoDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyError:
         Begin
              VideoDevice.Status:=mciError;
              If ulNotifyCode<>0 Then VideoDevice.ShowMCIError(ulNotifyCode)
              Else ErrorBox(LoadNLSStr(SFatalMCIError));
              VideoDevice.PositionAdvise:=FALSE;
         End;
         mciNotifySuccess:
         Begin
              VideoDevice.Status:=mciStopped;
              PlayingCompleted;
              VideoDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyPositionChange:
         Begin
              If ulDeviceId=VideoDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,VideoDevice.TimeFormat);
                   PositionChanged(TimeInfo);
              End;
         End;
         mciNotifyCuePoint:
         Begin
              If ulDeviceId=VideoDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,VideoDevice.TimeFormat);
                   CuePointReached(TimeInfo,ulUserCode);
              End;
         End;
     End; {case}
End;

Procedure TVideoWindow.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption:=Name;
     Height:=200;
     Width:=200;
     ParentPenColor:=FALSE;
     ParentColor:=TRUE;
End;

Procedure TVideoWindow.Redraw(Const rc:TRect);
Var rec:TRect;
Begin
     If Canvas = Nil Then exit;
     If ((VideoDevice=Nil)Or(Not VideoDevice.DeviceOpen)) Then
     Begin
          Inherited Redraw(rc);
          If Designed Then
          Begin
              Canvas.Brush.Color:=Color;
              Canvas.Pen.Color:=clBlack;
              Canvas.TextOut(20,20,'Video Window');
              rec:=ClientRect;
              Canvas.Pen.Style := psDash;
              Canvas.Brush.Style := bsClear;
              Canvas.Rectangle(rec);
          End;
     End;
End;

Function TVideoWindow.DoesFileExist(pszFileName:String):BOOLEAN;
{$IFDEF OS2}
Const
   bReturn:ULONG=0;
   rc:ULONG=MMIO_SUCCESS;
Var
   hFile:LONGWORD;
   lHeaderLengthMovie:LONG;
   lHeaderLengthVideo:LONG;
   lBytes:LONG;
   apmmMovieHeader:PMMMOVIEHEADER;
   ammVideoHeader:MMVIDEOHEADER;
   ammExtendInfo:MMEXTENDINFO;
   ammioinfo:MMIOINFO;
{$ENDIF}
Begin
     {$IFDEF OS2}
     fillchar(ammioinfo, sizeof(MMIOINFO),0);
     fillchar(ammExtendinfo,sizeof(MMEXTENDINFO),0);
     fillchar(ammVideoHeader,sizeof(MMVIDEOHEADER),0);

     ammioinfo.ulTranslate :=  MMIO_TRANSLATEHEADER;

     ammExtendinfo.ulFlags := MMIO_TRACK;

     result:=FALSE;
     If Not InitMMPM2 Then exit;

     hFile := mmioOpenAddr( pszFileName, ammioinfo, MMIO_READ );

     If hFile <> 0 Then
     Begin
        ammExtendinfo.ulTrackID := -1;

        bReturn := mmioSetAddr(hFile, ammExtendinfo, MMIO_SET_EXTENDEDINFO);
        bReturn := mmioQueryHeaderLengthAddr(hFile, lHeaderLengthMovie,0, 0);

        If bReturn=0 Then
            getmem(apmmMovieHeader,lHeaderLengthMovie);

        bReturn := mmioGetHeaderAddr(hFile,
                                 apmmMovieHeader^,
                                 lHeaderLengthMovie,
                                 lBytes,
                                 0,
                                 0);
        If bReturn=0 Then
        Begin
            ammExtendinfo.ulTrackID := apmmMovieHeader^.ulNextTrackID;
            bReturn := mmioSetAddr(hFile, ammExtendinfo, MMIO_SET_EXTENDEDINFO);
            lHeaderLengthVideo := sizeof(MMVIDEOHEADER);
            bReturn := mmioGetHeaderAddr(hFile,
                                    ammVideoHeader,
                                    lHeaderLengthVideo,
                                    lBytes,
                                    0,
                                    0);

            ulMovieWidth  := ammVideoHeader.ulWidth;

            ulMovieHeight := ammVideoHeader.ulHeight;

            ulMovieLength := ammVideoHeader.ulLength;

            ammExtendinfo.ulTrackID := MMIO_RESETTRACKS;

            bReturn := mmioSetAddr(hFile, ammExtendinfo,MMIO_SET_EXTENDEDINFO);

            mmioCloseAddr( hFile, 0);

            freemem(apmmMovieHeader,lHeaderLengthMovie);
            result:=TRUE;
            exit;
         End;
     End;
     result:=FALSE;
     {$ENDIF}
     {$IFDEF Win32}
     result:=TRUE;
     {$ENDIF}
End;

Procedure TVideoWindow.SetVideoDevice(NewDevice:TVideoDevice);
Begin
     If FVideoDevice<>Nil Then FVideoDevice.Notification(Self,opRemove);
     FVideoDevice := NewDevice;
     If FVideoDevice <> Nil Then
     Begin
          FVideoDevice.FreeNotification(Self);
          FVideoDevice.FVideoWindow:=Self;
     End;
End;

Procedure TVideoWindow.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FVideoDevice Then
       Begin
            FVideoDevice.Stop;
            FVideoDevice.FVideoWindow:=Nil;
            FVideoDevice := Nil;
       End;
End;




Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  19-Nov-04  WD         Erstellung der Unit. Dateien von uVideoDevuce, uCDDevice und
                        uAudioDevice zusammen gefuehrt.
}


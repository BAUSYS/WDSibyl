{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Multimedia Classes                                            บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit uMediaPlayer;

Interface

Uses Classes, Forms, Buttons, SysUtils, Color, Graphics,
     MMedia;

type
    {$M+}
    TMPBtnType=(btPlay, btPause, btStop, btNext, btPrev, btStep, btBack,
                btRecord, btEject, btRewind);
    TMPButtonSet=Set Of TMPBtnType;

    EMPNotify=Procedure(Sender:TObject;Button:TMPBtnType;Var DoDefault:BOOLEAN) of Object;

    TMPDeviceTypes=(dtAutoSelect,dtAVIVideo,dtCDAudio,dtDAT,dtDigitalVideo,
                    dtMMMovie,dtOther,dtOverlay,dtScanner,dtSequencer,
                    dtVCR,dtVideoDisc,dtWaveAudio);
    {$M-}

type TMediaPlayer=Class(TControl)
       Private
         FButtons:Array[TMPBtnType] Of TBitBtn;
         FFrames:LONGINT;
         FPlayButton:TAnimatedButton;
         FRecordButton:TAnimatedButton;
         FVisibleButtons:TMPButtonSet;
         FEnabledButtons:TMPButtonSet;
         FFileName:PString;
         FUseAnimation:BOOLEAN;
         FMCIDevice:TMCIDevice;
         FOpened:BOOLEAN;
         FOnClick:EMPNotify;
         FOnPlayingCompleted:TNotifyEvent;
         FOnPlayingAborted:TNotifyEvent;
         FOnPositionChanged:TMCIPositionChanged;
         FOnCuePointReached:TMCICuePointReached;
         FDestroyMCIDev:BOOLEAN;
         FDeviceType:TMPDeviceTypes;
         Procedure SetVisibleButtons(NewState:TMPButtonSet);
         Procedure SetEnabledButtons(NewState:TMPButtonSet);
         Function GetFileName:String;
         Procedure SetFileName(NewName:String);
         Procedure SetMCIDevice(NewDevice:TMCIDevice);
         Function GetButton(Index:TMPBtnType):TBitBtn;
         Procedure EvButtonClick(Sender:TObject);
         Procedure SetDeviceType(NewValue:TMPDeviceTypes);
       Protected
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure RealignControls;Override;
         Procedure PositionChanged(Const NewPosition:TTimeInfo);Virtual;
         Procedure CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);Virtual;
         Procedure PlayingAborted;Virtual;
         Procedure PlayingCompleted;Virtual;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Property Buttons[Index:TMPBtnType]:TBitBtn read GetButton;
         Property Hint;
         Property Cursor;
       Public
         Procedure MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUsErcode:LoNGWORD);Virtual;

         Destructor Destroy;Override;
         Procedure Open;Virtual;
         Procedure Play;Virtual;
         Procedure StartRecording;Virtual;
         Procedure Stop;Virtual;
         Procedure Pause;Virtual;
         Procedure Close;Virtual;
         Procedure Rewind;Virtual;
         Procedure Next;Virtual;
         Procedure Previous;Virtual;
         Procedure Step;Virtual;
         Procedure Back;Virtual;
         Procedure Eject;Virtual;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
       Published
         Property Align;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property DeviceType:TMPDeviceTypes read FDeviceType write SetDeviceTypE;
         Property EnabledButtons:TMPButtonSet read FEnabledButtons write SetEnaBlEdbutTons;
         Property FileName:String read GetFileName write SetFileName;
         Property Frames:LONGINT read FFrames write FFrames;
         Property MCIDevice:TMCIDevice read FMCIDevice write SetMCIDevice;
         Property ParentShowHint;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property UseAnimation:BOOLEAN read FUseAnimation write FUseAnimation;
         Property Visible;
         Property VisibleButtons:TMPButtonSet read FVisibleButtons write SetVisIbLebutTons;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick:EMPNotify read FOnClick write FOnClick;
         Property OnCuePointReached:TMCICuePointReached read FOnCuePointReached wRite FonCuePoinTreached;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnPlayingAborted:TNotifyEvent read FOnPlayingAborted write FONPLayinGabortEd;
         Property OnPlayingCompleted:TNotifyEvent  read FOnPlayingCompleted wriTe fonPLayingCompLeted;
         Property OnPositionChanged:TMCIPositionChanged read FOnPositionChanged wRite FonPosItioNchangEd;
         Property OnResize;
         Property OnSetupShow;
         Property OnStartDrag;
     End;

type TVolumeControl=Class(TControl)
      Private                            
         FPosition:BYTE;
         FTimerEndPos:LONGINT;
         FAngleTimer:TTimer;
         FHasCapture:BOOLEAN;
         FOnPositionChanged:TNotifyEvent;
         fMCIDevice:TMCIDevice;
         fChannel:TChannel;

         Procedure DrawSlider;
         Procedure DrawBoxes;
         Procedure SetPosition(NewPosition:BYTE);
         Procedure GetCircleParams(Var MiddleX,MiddleY,CircleRadius:LONGINT);
         Function InsideCircle(MiddleX,MiddleY,Radius:LONGINT;Const pt:TPoint;Var AnglE:LOnginT):BooLEaN;
         Procedure EvTimer(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGiNT);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LONGINT);Override;
         Procedure PositionChanged;Virtual;
         Property Cursor;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Destructor Destroy;Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentShowHint;
         Property Position:BYTE read FPosition write SetPosition;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;
         Property Channel:tChannel read fChannel write fChannel;
         Property MCIDevice:TMCIDevice read fMCIDevice write fMCIDevice;

         Property OnCanDrag;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnPositionChanged:TNotifyEvent read FOnPositionChanged write FonPOsitionchAnged;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


Implementation

Uses uMMDevices;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMediaPlayer Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMediaPlayer.SetMCIDevice(NewDevice:TMCIDevice);
Begin
  If FMCIDevice=NewDevice Then exit;
  If FMCIDevice<>Nil Then
    Begin
      If FDestroyMCIDev
        Then FMCIDevice.Destroy
        Else FMCIDevice.Notification(Self,opRemove);
    End;
  FDestroyMCIDev:=FALSE;
  FMCIDevice := NewDevice;
  If FMCIDevice <> Nil Then FMCIDevice.FreeNotification(Self);
End;


Procedure TMediaPlayer.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FMCIDevice Then FMCIDevice := Nil;
End;


Procedure TMediaPlayer.PlayingAborted;
Begin
     EnabledButtons:=EnabledButtons-[btPause,btStop];
     If FOnPlayingAborted<>Nil Then FOnPlayingAborted(Self);
End;

Procedure TMediaPlayer.PlayingCompleted;
Begin
     EnabledButtons:=EnabledButtons-[btPause,btStop];
     If FOnPlayingCompleted<>Nil Then FOnPlayingCompleted(Self);
End;

{$HINTS OFF}
Procedure TMediaPlayer.PositionChanged(Const NewPosition:TTimeInfo);
Begin
     If OnPositionChanged<>Nil Then OnPositionChanged(Self,NewPosition);
End;

Procedure TMediaPlayer.CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);
Begin
     If OnCuePointReached<>Nil Then OnCuePointReached(Self,CuePoint,CuePointId);
End;

Procedure TMediaPlayer.MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUSerCode:LONGWORD);
Var TimeInfo:TTimeInfo;
Begin
      Case Event Of
         mciNotifySuperseded:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;
         End;
         mciNotifyAborted:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;

              MCIDevice.Status:=mciStopped;
              PlayingAborted;
              MCIDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyError:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;

              MCIDevice.Status:=mciError;
              MCIDevice.PositionAdvise:=FALSE;
         End;
         mciNotifySuccess:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;

              MCIDevice.Status:=mciStopped;
              PlayingCompleted;
              MCIDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyPositionChange:
         Begin
              If ulDeviceId=MCIDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,MCIDevice.TimeFormat);
                   PositionChanged(TimeInfo);
              End;
         End;
         mciNotifyCuePoint:
         Begin
              If ulDeviceId=MCIDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,MCIDevice.TimeFormat);
                   CuePointReached(TimeInfo,ulUserCode);
              End;
         End;
      End;
End;
{$HINTS ON}


Procedure TMediaPlayer.EvButtonClick(Sender:TObject);
Var DoDefault:BOOLEAN;
    BtnType:TMPBtnType;
Begin
     DoDefault:=TRUE;
     BtnType:=TMPBtnType(TComponent(Sender).Tag);
     If OnClick <> Nil Then OnClick(Self,BtnType,DoDefault);
     If DoDefault Then
     Begin
          Case BtnType Of
              btPlay: Play;
              btStop: Stop;
              btPause: Pause;
              btBack: Back;
              btStep: Step;
              btEject: Eject;
              btRecord: StartRecording;
              btNext: Next;
              btPrev: Previous;
              btRewind:Rewind;
          End;
     End;
End;


Function TMediaPlayer.GetButton(Index:TMPBtnType):TBitBtn;
Begin
     Result := FButtons[Index];
End;


Procedure TMediaPlayer.CreateWnd;
Begin
     Inherited CreateWnd;

     RealignControls;
End;


Procedure TMediaPlayer.SetupComponent;
  Procedure InitBtn(Btn:TBitBtn;BtnTag:TMPBtnType;Const BtnBmp:String);
  Begin
       FButtons[BtnTag] := Btn;
       If BtnBmp <> '' Then Btn.Glyph.LoadFromResourceName(BtnBmp);
       Btn.YAlign := yaBottom;
       Btn.YStretch := ysParent;
       Btn.Visible := FALSE;
       Include(Btn.ComponentState, csDetail);
       Btn.SetDesigning(Designed);

       If Not Designed Then
       Begin
            Btn.Tag := LONGINT(BtnTag);
            Btn.OnClick := EvButtonClick;
       End;
  End;
Var  FNextTrkButton:TBitBtn;
     FPrevTrkButton:TBitBtn;
     FPauseButton:TBitBtn;
     FRewindButton:TBitBtn;
     FStopButton:TBitBtn;
     FBackTrkButton:TBitBtn;
     FStepTrkButton:TBitBtn;
     FEjectButton:TBitBtn;
Begin
     Inherited SetupComponent;

     Caption:='';
     Width:=32*4;
     Height:=32;
     ParentColor:=TRUE;
     FFrames:=1;
     DeviceType:=dtAutoSelect;

     FPlayButton:=InsertAnimatedButtonName(Self,0,0,32,32,'StdBmpPlay','',LoadNLSStr(SPlAyHInt));
     InitBtn(FPlayButton,btPlay,'');
     FPlayButton.Interval:=200;
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay');
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay1');
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay2');
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay3');

     FPauseButton:=InsertBitBtn(Self,32,0,32,32, bkCustom,'',LoadNLSStr(SPauseHint));
     InitBtn(FPauseButton,btPause,'StdBmpPause');

     FStopButton:=InsertBitBtn(Self,64,0,32,32, bkCustom,'',LoadNLSStr(SStopHint));
     InitBtn(FStopButton,btStop,'StdBmpStop');

     FNextTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SNextTraCkHInt));
     InitBtn(FNextTrkButton,btNext,'StdBmpNextTrk');

     FPrevTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SPreviouSTrAckHint));
     InitBtn(FPrevTrkButton,btPrev,'StdBmpPrevTrk');

     FStepTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SStepTrackHint));
     InitBtn(FStepTrkButton,btStep,'StdBmpStepTrk');

     FBackTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SBackTrackHint));
     InitBtn(FBackTrkButton,btBack,'StdBmpBackTrk');

     FRecordButton:=InsertAnimatedButtonName(Self,96,0,32,32,'StdBmpRecord','',LoadNLSStR(SRecordHint));
     InitBtn(FRecordButton,btRecord,'');
     FRecordButton.Interval:=200;
     FRecordButton.BitmapList.AddResourceName('StdBmpRecord');
     FRecordButton.BitmapList.AddResourceName('StdBmpRecord1');

     FEjectButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SEjectHint));
     InitBtn(FEjectButton,btEject,'StdBmpEject');

     FRewindButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SRewindHint));
     InitBtn(FRewindButton,btRewind,'StdBmpRewind');

     VisibleButtons:=[btPlay,btPause,btRewind,btStop];
     EnabledButtons:=[btPlay,btRecord,btNext,btPrev];
     FUseAnimation:=TRUE;
End;


Destructor TMediaPlayer.Destroy;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.CloseDevice;
          If FDestroyMCIDev Then FMCIDevice.Destroy;
     End;
     FPlayButton.StopAnimation;
     FRecordButton.StopAnimation;
     If FFileName<>Nil Then FreeMem(FFileName,System.length(FFileName^)+1);
     FFileName := Nil;

     Inherited Destroy;
End;


Function TMediaPlayer.GetFileName:String;
Begin
     If MCIDevice<>Nil Then result:=MCIDevice.FileName
     Else If FFileName<>Nil Then result:=FFileName^
     Else Result:='';
End;


Procedure TMediaPlayer.SetFileName(NewName:String);
Begin
     If MCIDevice<>Nil Then MCIDevice.FileName:=NewName
     Else
     Begin
          If FFileName<>Nil Then FreeMem(FFileName,System.length(FFileName^)+1);
          GetMem(FFileName,System.length(NewName)+1);
          FFileName^:=NewName;
     End;
End;


Procedure TMediaPlayer.SetVisibleButtons(NewState:TMPButtonSet);
Var  idx:TMPBtnType;
Begin
     FVisibleButtons := NewState;
     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FButtons[idx]<>Nil Then
            FButtons[idx].Visible := FVisibleButtons * [idx] <> [];
     End;
     RealignControls;
End;


Procedure TMediaPlayer.SetEnabledButtons(NewState:TMPButtonSet);
Var  idx:TMPBtnType;
Begin
     FEnabledButtons := NewState;
     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FButtons[idx]<>Nil Then
            FButtons[idx].Enabled := FEnabledButtons * [idx] <> [];
     End;
     If Handle <> 0 Then Invalidate;
End;


Procedure TMediaPlayer.RealignControls;
Var  x:LONGINT;
     count,w:LONGINT;
     idx:TMPBtnType;
Begin
     If Handle = 0 Then exit;

     count := 0;
     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FVisibleButtons * [idx] <> [] Then inc(count);
     End;
     If count = 0 Then exit;

     x := 0;
     w := Width Div count;

     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FButtons[idx]<>Nil Then
          Begin
              If FVisibleButtons * [idx] <> [] Then
              Begin
                   FButtons[idx].SetWindowPos(x,0,w,Height);
                   inc(x, w);
              End
              Else
              If Designed Then FButtons[idx].SetWindowPos(x,Height,w,Height);
          End;
     End;
End;

Procedure TMediaPlayer.Open;
Var s:String;
    DevType:TMPDeviceTypes;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.OpenDevice;
          FOpened:=MCIDevice.DeviceOpen;
     End
     Else
     Begin
          FDestroyMCIDev:=TRUE;

          If DeviceType=dtAutoSelect Then
          Begin
               DevType:=dtOther;
               s:=FileName;
               UpcaseStr(s);
               If pos('.WAV',s)<>0 Then DevType:=dtWaveAudio
               Else If pos('.AVI',s)<>0 Then DevType:=dtAVIVideo;
          End
          Else DevType:=DeviceType;

          Case DevType Of
            dtAVIVideo:FMCIDevice:=TVideoDevice.Create(nil);
            dtCDAudio:FMCIDevice:=TCDDevice.Create(nil);
            dtDAT:
            Begin
                 FMCIDevice:=TMCIDevice.Create(nil);
                 MCIDevice.DeviceName:='DAT';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtDigitalVideo:FMCIDevice:=TVideoDevice.Create(Nil);
            dtMMMovie:FMCIDevice:=TVideoDevice.Create(Nil);
            dtOther:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Other';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtOverlay:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Overlay';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtScanner:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Scanner';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtSequencer:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Sequencer';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtVCR:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='VCR';
                 MCIDevice.AliasName:='Sibyl_'+FMCIDevice.DeviceName;
            End;
            dtVideoDisc:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Videodisc';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtWaveAudio:FMCIDevice:=TAudioDevice.Create(Nil);
          End; //case

          MCIDevice.FileName:=FileName;
          MCIDevice.OpenDevice;
          FOpened:=MCIDevice.DeviceOpen;
     End;
End;


Procedure TMediaPlayer.Play;
Begin
     If Not FOpened Then Open;
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.Play;
          If MCIDevice.Status=mciPlaying Then
          Begin
               EnabledButtons:=EnabledButtons-[btRecord];
               EnabledButtons:=EnabledButtons+[btPause,btStop,btRewind];
               If UseAnimation Then FPlayButton.StartAnimation;
          End;
     End;
End;


Procedure TMediaPlayer.StartRecording;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.StartRecording;
          If MCIDevice.Status=mciRecording Then
          Begin
               EnabledButtons:=EnabledButtons-[btPlay];
               EnabledButtons:=EnabledButtons+[btPause,btStop,btRewind];
               If UseAnimation Then FRecordButton.StartAnimation;
          End;
     End;
End;


Procedure TMediaPlayer.Stop;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.Stop;
          EnabledButtons:=EnabledButtons-[btStop,btPause];
          EnabledButtons:=EnabledButtons+[btPlay,btRecord];
          FPlayButton.ResetAnimation;
          FRecordButton.ResetAnimation;
     End;
End;


Procedure TMediaPlayer.Next;
Var WasPlaying:Boolean;
Begin
     If MCIDevice<>Nil Then
     Begin
          WasPlaying:=MCIDevice.Status=mciPlaying;
          Stop;
          MCIDevice.NextTrack;
          If WasPlaying Then Play;
     End;
End;


Procedure TMediaPlayer.Previous;
Var WasPlaying:Boolean;
Begin
     If MCIDevice<>Nil Then
     Begin
          WasPlaying:=MCIDevice.Status=mciPlaying;
          Stop;
          MCIDevice.PreviousTrack;
          If WasPlaying Then Play;
     End;
End;


Procedure TMediaPlayer.Pause;
Begin
     If MCIDevice<>Nil Then
     Begin
          If MCIDevice.Status<>mciPlaying Then
          Begin
               EnabledButtons:=EnabledButtons+[btStop];
               MCIDevice.Pause;
               If MCIDevice.Status=mciPlaying Then
                 If UseAnimation Then FPlayButton.StartAnimation;
          End
          Else
          Begin
               EnabledButtons:=EnabledButtons+[btPlay,btRecord];
               EnabledButtons:=EnabledButtons-[btStop];
               MCIDevice.Pause;
               FPlayButton.StopAnimation;
               FRecordButton.StopAnimation;
          End;
     End;
End;


Procedure TMediaPlayer.Rewind;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.SeekToStart;
          EnabledButtons:=EnabledButtons+[btPlay,btRecord];
          EnabledButtons:=EnabledButtons-[btStop,btPause,btRewind];
          FPlayButton.ResetAnimation;
          FRecordButton.ResetAnimation;
     End;
End;


Procedure TMediaPlayer.Close;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.CloseDevice;
          FOpened:=FALSE;
          EnabledButtons:=[btPlay,btRecord,btNext,btPrev];
          FPlayButton.ResetAnimation;
          FRecordButton.ResetAnimation;
     End;
End;

Procedure TMediaPlayer.Step;
Var ti:TTimeInfo;
Begin
     If MCIDevice<>Nil Then
     Begin
         ti:=MCIDevice.Position;
         ti.Unknown:=ti.Unknown+Frames;
         MCIDevice.Seek(ti);
     End;
End;

Procedure TMediaPlayer.Back;
Var ti:TTimeInfo;
Begin
     If MCIDevice<>Nil Then
     Begin
         ti:=MCIDevice.Position;
         ti.Unknown:=ti.Unknown-Frames;
         MCIDevice.Seek(ti);
     End;
End;

Procedure TMediaPlayer.Eject;
Begin
  If MCIDevice Is TCDDevice Then
    TCDDevice(MCIDevice).Eject;
End;

Procedure TMediaPlayer.SetDeviceType(NewValue:TMPDeviceTypes);
Var WasOpened:BOOLEAN;
Begin
     If NewValue<>DeviceType Then
     Begin
          WasOpened:=FOpened;
          Close;
          FDeviceType:=NewValue;
          If WasOpened Then Open;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TVolumeControl Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TVolumeControl.InsideCircle(MiddleX,MiddleY,Radius:LONGINT;Const pt:TPoint;Var Angle:LONGINT):BOOLEAn;
Var a,b:LONGINT;
    temp:Extended;
    OldRad:BOOLEAN;
    OldToRad:EXTENDED;
    OldFromRad:EXTENDED;
Begin
  result:=FALSE;
  If pt.X=MiddleX
    Then
      Begin
        If abs(pt.y-MiddleY)<=Radius Then result:=TRUE;
        Angle:=90;
      End
    Else
      If pt.Y=MiddleY
        Then
          Begin
            If abs(pt.x-MiddleX)<=Radius Then result:=TRUE;
            If pt.x<MiddleX
              Then Angle:=180
              Else Angle:=0;
          End
        Else
          Begin
            {Zwischenpunkt fr rechtwinkliges Dreieck}
            a:=pt.Y-MiddleY;
            b:=pt.X-MiddleX;
            temp:=sqrt(sqr(a)+sqr(b));
            If round(temp)<=Radius Then result:=TRUE;

            {Save old trigmode}
            OldRad:=IsNotRad;
            OldToRad:=ToRad;
            OldFromRad:=FromRad;

            {Set trigmode to degrees}
            ToRad:=0.01745329262;
            FromRad:=57.29577951;
            IsNotRad:=TRUE;
            Angle:=round(arcsin(abs(b)/temp));
            If pt.X>MiddleX
              Then Angle:=90-Angle
              Else inc(Angle,90);

            {Restore old trigmode}
            ToRad:=OldToRad;
            FromRad:=OldFromRad;
            IsNotRad:=OldRad;

            If ((FPosition<50)And(pt.x<MiddleX)And(pt.y<MiddleY))
              Then Angle:=180
              Else
                If ((FPosition>50)And(pt.x>MiddleX)And(pt.y<MiddleY))
                  Then Angle:=0;
          End;
End;

{$HINTS OFF}
Procedure TVolumeControl.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONgiNT);
Var MiddleX,MiddleY,CircleRadius:LONGINT;
    Angle:LONGINT;
    rec:TRect;
Label found;
Begin
  Inherited MouseDown(Button,ShiftState,X,Y);
  If Button <> mbLeft Then exit;
  GetCircleParams(MiddleX,MiddleY,CircleRadius);
  If InsideCircle(MiddleX,MiddleY,CircleRadius Div 2,Point(X,Y),Angle)
    Then
      Begin
found:
        MouseCapture:=TRUE;
        FHasCapture:=TRUE;
        FTimerEndPos:=100-round((Angle*100) / 180);
        FAngleTimer.Create(Self);
        Include(FAngleTimer.ComponentState, csDetail);
        FAngleTimer.OnTimer:=EvTimer;
        FAngleTimer.Interval:=30;
        FAngleTimer.Start;
      End
    Else
      Begin
        If Y>=MiddleY Then
         If InsideCircle(MiddleX,MiddleY,(CircleRadius+30) Div 2,Point(X,Y),Angle)
           then Goto found;
         If ((Y>=5)And(Y<=20))
           Then //test boxes
             Begin
               If ((X>=1)And(X<=16)And(FPosition>0))
                 Then {minus}
                   Begin
                     rec.Left:=1;
                     rec.Right:=16;
                     FTimerEndPos:=0;
                     Position:=Position-1;
                   End
                 Else
                   If ((X>=Width-16)And(X<=Width-1)And(FPosition<100))
                     Then {plus}
                       Begin
                         rec.Left:=Width-16;
                         rec.Right:=Width-1;
                         FTimerEndPos:=100;
                         Position:=Position+1;
                       End
                     Else exit;
               PositionChanged;
               rec.Bottom:=5;
               rec.Top:=20;
               Canvas.ShadowedBorder(rec,clBlack,clWhite);
               MouseCapture:=TRUE;
               FHasCapture:=FALSE;
               FAngleTimer.Create(Self);
               Include(FAngleTimer.ComponentState, csDetail);
               FAngleTimer.OnTimer:=EvTimer;
               FAngleTimer.Interval:=250;
               FAngleTimer.Start;
             End;
      End;
End;

Procedure TVolumeControl.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGInt);
Begin
  Inherited MouseUp(Button,ShiftState,X,Y);
  If Button <> mbLeft Then exit;
  If MouseCapture Then If FAngleTimer<>Nil Then
    Begin
      FAngleTimer.Stop;
      FAngleTimer.Destroy;
      FAngleTimer:=Nil;
      MouseCapture:=FALSE;
      FHasCapture:=FALSE;
      DrawBoxes;
    End;
End;

Procedure TVolumeControl.MouseMove(ShiftState:TShiftState;X,Y:LONGINT);
Var MiddleX,MiddleY,CircleRadius:LONGINT;
    Angle:LONGINT;
Begin
  Inherited MouseMove(ShiftState,X,Y);
  If FHasCapture Then
    Begin
      GetCircleParams(MiddleX,MiddleY,CircleRadius);
      InsideCircle(MiddleX,MiddleY,CircleRadius Div 2,Point(X,Y),Angle);
      FAngleTimer.Stop;
      FTimerEndPos:=100-round((Angle*100) Div 180);
      If FTimerEndPos<FPosition
        Then Position:=Position-1
        Else If FTimerEndPos>FPosition Then Position:=Position+1;
      PositionChanged;
      FAngleTimer.Start;
    End;
End;
{$HINTS ON}

Procedure TVolumeControl.EvTimer(Sender:TObject);
Var t,Ende:LONGINT;
Begin
  If Sender=FAngleTimer Then
    Begin
      If FTimerEndPos=FPosition Then
        Begin
          FAngleTimer.Stop;
          exit;
        End;
      If MouseCapture
        Then Ende:=6  //not boxes
        Else Ende:=1;

      For t:=1 To Ende Do
        Begin
          If FTimerEndPos<FPosition
            Then Position:=Position-1
            Else
              If FTimerEndPos>FPosition Then Position:=Position+1;
          PositionChanged;
        End;
    End;
End;

Procedure TVolumeControl.SetupComponent;
Begin
  Inherited SetupComponent;
  Width:=75;
  Height:=75;
  ParentPenColor:=TRUE;
  ParentColor:=TRUE;
  FPosition:=100;
  FHasCapture:=FALSE;
  fMCIDevice:=nil;
  fChannel:=chBoth;
End;

Procedure TVolumeControl.GetCircleParams(Var MiddleX,MiddleY,CircleRadius:LONGINT);
Begin
  MiddleX:=Width Div 2;
  MiddleY:=Height Div 2;
  If Height>Width
    Then CircleRadius:=Width-30
    Else CircleRadius:=Height-30;
  If CircleRadius And 1<>0 Then inc(CircleRadius);
End;

Procedure TVolumeControl.DrawSlider;
Var  MiddleX,MiddleY:LONGINT;
     CircleRadius:LONGINT;
     Angle:EXTENDED;
Begin
  GetCircleParams(MiddleX,MiddleY,CircleRadius);
  Angle:=((100-FPosition)*180) / 100;
  Canvas.Pen.Style:=psClear;
  Canvas.Arc(MiddleX,MiddleY,(CircleRadius-6) Div 2,(CircleRadius-6) Div 2,Angle,0);
  Canvas.Pen.Style:=psSolid;
  Canvas.LineTo(MiddleX,MiddleY);
End;

Procedure TVolumeControl.SetPosition(NewPosition:BYTE);
Begin
  If NewPosition=FPosition Then exit;
  If NewPosition>100 Then NewPosition:=100;
  If Handle<>0
    Then
      Begin
        Canvas.Pen.Color:=Color;
        DrawSlider; {erase old slider}
        FPosition:=NewPosition;
        Canvas.Pen.Color:=clBlack;
        DrawSlider; {draw new slider}
      End
    Else FPosition:=NewPosition;
End;

Procedure TVolumeControl.DrawBoxes;
Var rec:TRect;
Begin
  rec.Left:=1;
  rec.Right:=16;
  rec.Bottom:=5;
  rec.Top:=20;
  Canvas.ShadowedBorder(rec,clWhite,clBlack);
  rec.Left:=Width-16;
  rec.Right:=Width-1;
  Canvas.ShadowedBorder(rec,clWhite,clBlack);
  Canvas.Line(4,12,13,12);
  Canvas.Line(Width-13,12,Width-4,12);
  Canvas.Line(Width-8,8,Width-8,17);
End;

Procedure TVolumeControl.Redraw(Const rec:TRect);
Var MiddleX,MiddleY:LONGINT;
    CircleRadius:LONGINT;

  Procedure DrawLines(Radius:LONGINT);
  Var t:LONGINT;
      ptStart:TPoint;
      Angle:EXTENDED;
  Begin
    Angle:=0;
    For t:=1 To 34 Do
      Begin
        Canvas.Pen.Style:=psClear;
        Canvas.Arc(MiddleX,MiddleY,Radius Div 2,Radius Div 2,Angle,0);
        ptStart:=Canvas.PenPos;
        Canvas.Arc(MiddleX,MiddleY,(Radius+15) Div 2,(Radius+15) Div 2,Angle,0);
        Canvas.Pen.Style:=psSolid;
        Canvas.LineTo(ptStart.X,ptStart.Y);
        Angle:=Angle + 180/33;
      End;
  End;

Begin
  Canvas.FillRect(rec,Color);

  GetCircleParams(MiddleX,MiddleY,CircleRadius);
  Canvas.Pen.Width:=2;
  Canvas.Pen.Color:=clBlack;
  Canvas.Circle(MiddleX,MiddleY,CircleRadius Div 2);
  Canvas.Pen.Color:=clWhite;
  Canvas.Arc(MiddleX,MiddleY,(CircleRadius-2) Div 2,(CircleRadius-2) Div 2,30,180);
  Canvas.Pen.Color:=clDkGray;
  Canvas.Arc(MiddleX,MiddleY,(CircleRadius-2) Div 2,(CircleRadius-2) Div 2,240,130);

  Canvas.Pen.Width:=1;
  Canvas.Pen.Color:=PenColor;
  Canvas.Brush.Color:=Color;
  DrawLines(CircleRadius+10);
  DrawSlider;
  DrawBoxes;
End;

Destructor TVolumeControl.Destroy;
Begin
  If FAngleTimer<>Nil
    Then FAngleTimer.Destroy;
  FAngleTimer:=Nil;
  Inherited Destroy;
End;

Procedure TVolumeControl.PositionChanged;
Begin
  if fMCIDevice<>nil
    then fMCIDevice.Volume[fChannel]:=FPosition;
  If OnPositionChanged<>Nil Then OnPositionChanged(Self);
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  09-Jul-04  WD         Erstellung der Unit.
  15-Jul-04  WD         VolumeControl: Wenn ein MCI-Gert angegeben ist wird das
                        Volume (abhaengig vom Channel) vom Device gesetzt.
}
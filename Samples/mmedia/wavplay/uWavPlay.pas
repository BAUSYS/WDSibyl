Unit uWavPlay;

Interface

Uses
  Classes, Forms, Graphics, uMMDevices, MMedia, uMediaPlayer, FileCtrl,
  StdCtrls, ComCtrls;
Type
  TFrmWavPlay = Class (TForm)
    edFileName: tEditFileName;
    lblFileName: TLabel;
    AudioDevice: TAudioDevice;
    MediaPlayer: TMediaPlayer;
    VolumeControl1: TVolumeControl;
    ProgressBar: TProgressBar;
    Procedure FrmWavPlayOnClose (Sender: TObject; Var Action: TCloseAction);
    Procedure AudioDeviceOnPositionChanged (Sender: TObject;
      Const NewPosition: TTimeInfo);
    Procedure edFileNameOnChange (Sender: TObject);
  Private
    {Private Deklarationen hier einfuegen}
  Public
    {Oeffentliche Deklarationen hier einfuegen}
  End;

Var
  FrmWavPlay: TFrmWavPlay;

Implementation

Procedure TFrmWavPlay.FrmWavPlayOnClose (Sender: TObject;
  Var Action: TCloseAction);
Begin
  AudioDevice.Stop;
End;

Procedure TFrmWavPlay.AudioDeviceOnPositionChanged (Sender: TObject;
  Const NewPosition: TTimeInfo);
Begin
Writeln('xxx');
  ProgressBar.Position:=NewPosition.Milliseconds;
  ProgressBar.Refresh;
End;

Procedure TFrmWavPlay.edFileNameOnChange (Sender: TObject);
Begin
  AudioDevice.FileName:=edFileName.FileName;
  ProgressBar.Max := AudioDevice.Length.Milliseconds;
End;

Initialization
  RegisterClasses ([TFrmWavPlay, tEditFileName, TLabel, TAudioDevice,
    TMediaPlayer, TVolumeControl, TProgressBar]);
End.

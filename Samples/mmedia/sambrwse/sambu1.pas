unit SamBU1;

interface

uses
  Classes, Forms, Graphics, FileCtrl, StdCtrls, ComCtrls, Buttons, MMedia,
  Gradient,
  uMMDevices;

type
  TMainForm = class (TForm)
    FileListBox: TFileListBox;
    DirListBox: TDirectoryListBox;
    DriveComboBox: TDriveComboBox;
    FltComboBox: TFilterComboBox;
    NameEdit: TEdit;
    ResEdit: TEdit;
    RateEdit: TEdit;
    SizeEdit: TEdit;
    ProgressBar: TProgressBar;
    StartButton: TSpeedButton;
    LenEdit: TEdit;
    AudioDevice: TAudioDevice;
    ChEdit: TEdit;
    VolumeSlider: TTrackBar;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure NameEditOnChange (Sender: TObject);
    procedure PlayEnd (Sender: TObject);
    procedure PlayProgress (Sender: TObject; const NewPosition: TTimeInfo);
    procedure StartButtonOnClick (Sender: TObject);
    procedure MainFormOnCreate (Sender: TObject);
    procedure VolumeSliderOnChange (Sender: TObject);
  private
    {Insert private declarations here}
  public
    {Insert public declarations here}
  end;

var
  MainForm: TMainForm;

implementation

uses
  SysUtils;

procedure TMainForm.PlayEnd (Sender: TObject);
begin
  ProgressBar.Position := ProgressBar.Max;
end;

procedure TMainForm.PlayProgress (Sender: TObject;
  const NewPosition: TTimeInfo);
begin
  ProgressBar.Position := NewPosition.Milliseconds;
end;

procedure TMainForm.StartButtonOnClick (Sender: TObject);
begin
  AudioDevice.SeekToStart;
  AudioDevice.Play;
end;

procedure TMainForm.MainFormOnCreate (Sender: TObject);
begin
  VolumeSlider.Position := AudioDevice.Volume[chBoth];
  AudioDevice.TimeFormat := tfMilliseconds;
  AudioDevice.PositionAdvise := True;
  AudioDevice.PositionAdviseUnits.Milliseconds := 50;
end;

procedure TMainForm.VolumeSliderOnChange (Sender: TObject);
begin
  AudioDevice.Volume[chBoth] := VolumeSlider.Position;
end;

procedure TMainForm.NameEditOnChange (Sender: TObject);
var
  SearchRec: TSearchRec;
  FileName:  string;
  TimeInfo:  TTimeInfo;
  WavLength:    LongInt;
begin
  FileName := NameEdit.Text;
  if FileName[Length(FileName)] = '\' then Exit;
  if not FileExists(Filename) then exit;

  FindFirst(FileName, faAnyFile, SearchRec);
  SizeEdit.Text := Format('%d bytes', [SearchRec.Size]);
  FindClose(SearchRec);

  Cursor := crHourGlass;
  AudioDevice.CloseDevice;
  AudioDevice.FileName := FileName;
  AudioDevice.Load;
  Cursor := crDefault;

  WavLength := (AudioDevice.Length.Milliseconds + 999) div 1000;

  ResEdit.Text := Format('%d bits/sample', [AudioDevice.BitsPerSample]);
  LenEdit.Text := Format('%d secs', [WavLength]);
  RateEdit.Text := Format('%d samples/sec', [AudioDevice.SamplesPerSec]);

  case AudioDevice.Channels of
    0: ChEdit.Text := 'No audio';
    1: ChEdit.Text := 'Mono';
    2: ChEdit.Text := 'Stereo';
  else
    ChEdit.Text := 'Unknown';
  end;

  StartButton.Enabled := True;
  ProgressBar.Position := 0;
  ProgressBar.Max := AudioDevice.Length.Milliseconds;
end;

initialization
  RegisterClasses ([TMainForm, TFileListBox, TDirectoryListBox, TDriveComboBox,
    TFilterComboBox, TGroupBox, TEdit, TLabel, TProgressBar, TSpeedButton
   , TAudioDevice, TTrackBar]);
end.

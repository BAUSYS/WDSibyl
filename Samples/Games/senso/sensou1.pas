unit SensoU1;

interface

uses
  SysUtils, Classes, Forms, Graphics, ExtCtrls, Buttons, Gradient,
  color;

type
  TSensoForm = class (TForm)
    ScorePanel: TPanel;
    ButtonPanel: TPanel;
    StartButton: TBitBtn;
    StopButton: TBitBtn;
    Gradient1: TGradient;
    RedButton: TSpeedButton;
    YellowButton: TSpeedButton;
    BlueButton: TSpeedButton;
    GreenButton: TSpeedButton;
    Timer: TTimer;
    procedure YellowButtonOnMouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure RedButtonOnMouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure BlueButtonOnMouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure GreenButtonOnMouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure GreenButtonOnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure BlueButtonOnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure RedButtonOnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure YellowButtonOnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    procedure TimerOnTimer (Sender: TObject);
    procedure StopButtonOnClick (Sender: TObject);
    procedure StartButtonOnClick (Sender: TObject);
  private
    {Insert private declarations here}
    Sequence: AnsiString;
    SequencePos: LongInt;

    procedure ComputerTurn;
    procedure PlayerTurn;
    procedure PlayerRight;
    procedure PlayerWrong;
  public
    {Insert public declarations here}
  end;

var
  SensoForm: TSensoForm;

implementation

procedure TSensoForm.YellowButtonOnMouseUp (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  YellowButton.Color := clOlive;
end;

procedure TSensoForm.RedButtonOnMouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  RedButton.Color := clMaroon;
end;

procedure TSensoForm.BlueButtonOnMouseUp (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  BlueButton.Color := clNavy;
end;

procedure TSensoForm.GreenButtonOnMouseUp (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  GreenButton.Color := clGreen;
end;

procedure TSensoForm.GreenButtonOnMouseDown (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  if Sequence[SequencePos] = 'G' then
  begin
    GreenButton.Color := clLime;
    Beep(330, 200);
    PlayerRight;
  end
  else PlayerWrong;
end;

procedure TSensoForm.BlueButtonOnMouseDown (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  if Sequence[SequencePos] = 'B' then
  begin
    BlueButton.Color := clBlue;
    Beep(264, 200);
    PlayerRight;
  end
  else PlayerWrong;
end;

procedure TSensoForm.RedButtonOnMouseDown (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  if Sequence[SequencePos] = 'R' then
  begin
    RedButton.Color := clRed;
    Beep(528, 200);
    PlayerRight;
  end
  else PlayerWrong;
end;

procedure TSensoForm.YellowButtonOnMouseDown (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
begin
  if Sequence[SequencePos] = 'Y' then
  begin
    YellowButton.Color := clYellow;
    Beep(396, 200);
    PlayerRight;
  end
  else PlayerWrong;
end;

procedure TSensoForm.TimerOnTimer (Sender: TObject);
var
  X: Integer;
begin
  case Sequence[SequencePos] of
    'B':
    begin
      BlueButton.Color := clBlue;
      Beep(264, 200);
      BlueButton.Color := clNavy;
    end;

    'G':
    begin
      GreenButton.Color := clLime;
      Beep(330, 200);
      GreenButton.Color := clGreen;
    end;

    'Y':
    begin
      YellowButton.Color := clYellow;
      Beep(396, 200);
      YellowButton.Color := clOlive;
    end;

    'R':
    begin
      RedButton.Color := clRed;
      Beep(528, 200);
      RedButton.Color := clMaroon;
    end;
  end;

  Inc(SequencePos);
  if SequencePos > Length(Sequence) then PlayerTurn;
end;

procedure TSensoForm.StopButtonOnClick (Sender: TObject);
var
  I: LongInt;
begin
  Beep(220, 500);
  RedButton.Enabled := False;
  BlueButton.Enabled := False;
  GreenButton.Enabled := False;
  YellowButton.Enabled := False;
  StartButton.Enabled := True;
  StopButton.Enabled := False;
end;

procedure TSensoForm.StartButtonOnClick (Sender: TObject);
begin
  ScorePanel.Caption := '0 Points';
  Sequence := '';
  Randomize;
  ComputerTurn;
  StartButton.Enabled := False;
  StopButton.Enabled := True;
end;

procedure TSensoForm.ComputerTurn;
const
  Colors: string[4] = 'BGYR';
begin
  RedButton.Enabled := False;
  BlueButton.Enabled := False;
  GreenButton.Enabled := False;
  YellowButton.Enabled := False;
  Sequence := Sequence + Colors[1 + Random(4)];
  SequencePos := 1;
  Timer.Start;
end;

procedure TSensoForm.PlayerTurn;
begin
  Timer.Stop;
  SequencePos := 1;
  RedButton.Enabled := True;
  BlueButton.Enabled := True;
  GreenButton.Enabled := True;
  YellowButton.Enabled := True;
end;

procedure TSensoForm.PlayerRight;
begin
  Inc(SequencePos);
  if SequencePos > Length(Sequence) then
  begin
    ScorePanel.Caption := IntToStr(Length(Sequence)) + ' Points';
    ComputerTurn;
  end;
end;

procedure TSensoForm.PlayerWrong;
var
  I: LongInt;
begin
  Beep(220, 500);
  RedButton.Enabled := False;
  BlueButton.Enabled := False;
  GreenButton.Enabled := False;
  YellowButton.Enabled := False;
  StartButton.Enabled := True;
  StopButton.Enabled := False;
end;

initialization
  RegisterClasses ([TSensoForm, TPanel, TBitBtn, TSpeedButton, TTimer, TGradient]);
end.

Program WavPlay;

Uses
  Forms, Graphics, uWavPlay;

{$r WavPlay.scu}

Begin
  Application.Create;
  Application.CreateForm (TFrmWavPlay, FrmWavPlay);
  Application.Run;
  Application.Destroy;
End.

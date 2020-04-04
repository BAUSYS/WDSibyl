Program CDPlay;

Uses
  Forms, Graphics, Unit1, Unit2, Unit3;

{$r CDPlay.scu}

Begin
  Application.Create;
  Application.CreateForm (TForm1, Form1);
  Application.Run;
  Application.Destroy;
End.

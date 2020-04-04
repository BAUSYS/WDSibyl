Program ResXPlor;

Uses          
  Forms, Graphics, RxMain, AboutWin, AboutUnit;

{$r ResXPlor.scu}

Begin
  Application.Create;
  Application.CreateForm (TMainForm, MainForm);
  Application.Run;
  Application.Destroy;
End.

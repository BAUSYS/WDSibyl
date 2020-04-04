Program WDSibylSort;

Uses        
  Forms, Graphics, uWDSibylSort;

{$r WDSibylSort.scu}

Begin
  Application.Create;
  Application.CreateForm (TMainForm, MainForm);
  Application.Run;
  Application.Destroy;
End.

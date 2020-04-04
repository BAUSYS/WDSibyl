Program ProcessList;

Uses
  Forms, Graphics, uProcessList;

{$r Processlist.scu}

Begin
  Application.Create;
  Application.CreateForm (TFrmProcessList, FrmProcessList);
  Application.Run;
  Application.Destroy;
End.

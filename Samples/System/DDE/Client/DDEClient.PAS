Program DDEClient;

Uses
  Forms, uDDEClient;

{$r DDEClient.scu}

Begin
  Application.Create;
  Application.CreateForm(TDDEClientForm, DDEClientForm);
  Application.Run;
  Application.Destroy;
End.

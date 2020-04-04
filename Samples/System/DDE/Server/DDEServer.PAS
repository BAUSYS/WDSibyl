Program DDEServer;

Uses
  Forms, Graphics, uDDEServer;

{$r DDEServer.scu}

Begin
  Application.Create;
  Application.CreateForm (TDDEServerForm, DDEServerForm);
  Application.Run;
  Application.Destroy;
End.

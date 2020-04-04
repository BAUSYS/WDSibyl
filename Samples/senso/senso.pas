program Senso;

uses
  Forms, Graphics, SensoU1;

{$r Senso.scu}

begin
  Application.Create;
  Application.CreateForm (TSensoForm, SensoForm);
  Application.Run;
  Application.Destroy;
end.

program SamBrwse;

uses
  Forms, Graphics, SamBU1;

{$r SamBrwse.scu}

begin
  Application.Create;
  Application.CreateForm (TMainForm, MainForm);
  Application.Run;
  Application.Destroy;
end.

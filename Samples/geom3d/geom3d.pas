Program GEOM3D;

Uses
  Forms, Graphics, GeomU1;

{$r GEOM3D.scu}

Begin
  Application.Create;
  Application.CreateForm (TDemoForm, DemoForm);
  Application.Run;
  Application.Destroy;
End.

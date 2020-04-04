Program Transfrm;

{
This example uses model transform operations to perform various
graphical transformations to a picture. It also shows usage of
operator overloading and path/area usage in Sibyl
}

Uses
  Forms, Graphics, TransU1;

{$r Transfrm.scu}

Begin
  Application.Create;
  Application.CreateForm (TTransformForm, TransformForm);
  Application.Run;
  Application.Destroy;
End.

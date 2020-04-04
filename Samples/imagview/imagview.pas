Program ImagView;

Uses
  Forms, Graphics, ImageWin, ViewWin;

{$r ImagView.scu}

Begin
  Application.Create;
  Application.CreateForm (TImageForm, ImageForm);
  Application.Run;
  Application.Destroy;
End.

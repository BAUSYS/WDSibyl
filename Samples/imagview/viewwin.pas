Unit ViewWin;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls;

Type
  TViewForm = Class (TForm)
    Image1: TImage;
  Private
    {Private Deklarationen hier einf�gen}
  Public
    {�ffentliche Deklarationen hier einf�gen}
  End;

Var
  ViewForm: TViewForm;

Implementation

Initialization
  RegisterClasses ([TViewForm, TImage]);
End.

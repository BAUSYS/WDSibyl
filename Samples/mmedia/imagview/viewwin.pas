Unit ViewWin;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls;

Type
  TViewForm = Class (TForm)
    Image1: TImage;
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  ViewForm: TViewForm;

Implementation

Initialization
  RegisterClasses ([TViewForm, TImage]);
End.

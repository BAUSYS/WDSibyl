Unit about;

Interface

Uses
  Classes, Forms, Graphics, Buttons, StdCtrls;

Type
  TAboutForm = Class (TForm)
    Button1: TButton;
    Memo1: TMemo;
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  AboutForm: TAboutForm;

Implementation


Initialization
  RegisterClasses ([TAboutForm, TButton, TMemo]);
End.

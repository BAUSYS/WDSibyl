Unit AboutUnit;

Interface

Uses
  Classes, Forms, Graphics, Buttons, ExtCtrls, StdCtrls;

Type
  TAboutForm = Class (TForm)
    OkButton1: TBitBtn;
    Panel1: TPanel;
    ProgramIcon1: TImage;
    ProductName1: TLabel;
    Version1: TLabel;
    Copyright1: TLabel;
    Comment1: TLabel;
    Copyright2: TLabel;
    Procedure OkButton1OnClick (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  AboutForm: TAboutForm;

Implementation

Procedure TAboutForm.OkButton1OnClick (Sender: TObject);
Begin
  close;
End;

Initialization
  RegisterClasses ([TAboutForm, TBitBtn, TPanel, TImage, TLabel]);
End.

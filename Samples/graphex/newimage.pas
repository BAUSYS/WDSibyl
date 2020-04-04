Unit NewImage;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Buttons;

Type
  TNewImageForm = Class (TForm)
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  NewImageForm: TNewImageForm;

Implementation

Initialization
  RegisterClasses ([TNewImageForm, TGroupBox, TBitBtn, TEdit, TLabel]);
End.

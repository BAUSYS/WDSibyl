Unit ChessOpt;

Interface
            
Uses
  Classes, Forms, Graphics, Buttons, StdCtrls, Chess;

Type
  TOptionsForm = Class (TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Procedure Button1OnClick (Sender: TObject);
    Procedure Form1OnSetupShow (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  OptionsForm: TOptionsForm;

Implementation

Procedure TOptionsForm.Button1OnClick (Sender: TObject);
Begin
  If Radiobutton1.Checked then CalcDepth:=1
  Else If Radiobutton2.Checked then CalcDepth:=2
  Else If Radiobutton3.Checked then CalcDepth:=3
  Else If Radiobutton4.Checked then CalcDepth:=4
  Else If Radiobutton5.Checked then CalcDepth:=5
  Else If Radiobutton6.Checked then CalcDepth:=6;
End;

Procedure TOptionsForm.Form1OnSetupShow (Sender: TObject);
Begin
  If CalcDepth=1 Then RadioButton1.Checked:=True
  Else If CalcDepth=2 Then RadioButton2.Checked:=True
  Else If CalcDepth=3 Then RadioButton3.Checked:=True
  Else If CalcDepth=4 Then RadioButton4.Checked:=True
  Else If CalcDepth=5 Then RadioButton5.Checked:=True
  Else If CalcDepth=6 Then RadioButton6.Checked:=True;
End;

Initialization
  RegisterClasses ([TOptionsForm, TButton, TGroupBox, TRadioButton]);
End.

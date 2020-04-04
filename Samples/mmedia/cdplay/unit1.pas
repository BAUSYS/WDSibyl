Unit Unit1;

Interface

Uses
  Classes, Forms, Graphics, CoolBar, Buttons,Unit2;

Type
  TForm1 = Class (TForm)
    CoolBar1: TCoolBar;
    Button1: TButton;
    ImageList1: TImageList;
    CoolBar2: TCoolBar;
    Procedure Button1OnClick (Sender: TObject);
    Procedure Form1OnCreate (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var                     
  Form1: TForm1;

Implementation

Procedure TForm1.Button1OnClick (Sender: TObject);
var l:integer;
Begin
   ImageForm1.ShowModal;
End;

Procedure TForm1.Form1OnCreate (Sender: TObject);
Begin

End;

Initialization
  RegisterClasses ([TForm1, TCoolBar, TImageList, TButton]);
End.

Unit GeomU1;

Interface

Uses
  Classes, Forms, Graphics, TabCtrls, StdCtrls, ExtCtrls, Buttons,
  Vector,Dialogs;

Type
  TDemoForm = Class (TForm)
    TabbedNotebook1: TTabbedNotebook;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ax: TEdit;
    ay: TEdit;
    az: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    bx: TEdit;
    by: TEdit;
    bz: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    a_Plus_b: TLabel;
    Label20: TLabel;
    a_Minus_b: TLabel;
    BitBtn1: TBitBtn;
    Label22: TLabel;
    a_Mul_b: TLabel;
    Label24: TLabel;
    a_Cross_b: TLabel;
    Label26: TLabel;
    Amount_a: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    a_Normalized: TLabel;
    Amount_a_Cross_b: TLabel;
    Procedure Form1OnCreate (Sender: TObject);
    Procedure BitBtn1OnClick (Sender: TObject);
    Procedure Label20OnClick (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
    Function GetVectorValues(Var a,b:TVector):Boolean;
  End;

Var
  DemoForm: TDemoForm;

Implementation

//gets the vector values from the entry fields
Procedure TDemoForm.Form1OnCreate (Sender: TObject);
Begin
  tostrdigits:=4; //we only want 4 decimal digits
End;

Function TDemoForm.GetVectorValues(Var a,b:TVector):Boolean;
Var
   x,y,z:Extended;
   c:Integer;
Begin
    result:=False;

    Val(ax.Text,x,c);
    If c<>0 Then exit;
    Val(ay.Text,y,c);
    If c<>0 Then exit;
    Val(az.Text,z,c);
    If c<>0 Then exit;
    a.Create(x,y,z);

    Val(bx.Text,x,c);
    If c<>0 Then exit;
    Val(by.Text,y,c);
    If c<>0 Then exit;
    Val(bz.Text,z,c);
    If c<>0 Then exit;
    b.Create(x,y,z);

    result:=True;
End;

//Update button inside the "Vectors" page
Procedure TDemoForm.BitBtn1OnClick (Sender: TObject);
Var a,b:TVector;
Begin
    If not GetVectorValues(a,b) Then
    Begin
       ErrorBox('Values of vector(s) invalid or not completely filled in !');
       a_Plus_b.Text:='not available';
       a_Minus_b.Text:='not available';
       a_Mul_b.Text:='not available';
       a_Cross_b.Text:='not available';
       Amount_a.Text:='not available';
       Amount_a_Cross_b.Text:='not available';
       a_Normalized.Text:='not available';
    End
    Else
    Begin
       a_Plus_b.Text:=(a+b).tostr;
       a_Minus_b.Text:=(a-b).tostr;
       a_Mul_b.Text:=tostr((a*b):0:tostrdigits);
       a_Cross_b.Text:=tostr((a#b).Amount:0:tostrdigits);
       Amount_a.Text:=tostr(a.Amount:0:tostrdigits);
       Amount_a_Cross_b.Text:=tostr((a#b).Amount:0:tostrdigits);
       a.Normalize;
       a_Normalized.Text:=a.tostr;
    End;
End;

Procedure TDemoForm.Label20OnClick (Sender: TObject);
Begin

End;

Initialization
  RegisterClasses ([TDemoForm, TTabbedNotebook, TMemo, TLabel, TBevel, TEdit,
    TBitBtn]);
End.

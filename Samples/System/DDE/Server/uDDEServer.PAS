Unit uDDEServer;

Interface 

Uses
  Classes, Forms, Graphics, StdCtrls, Buttons, Dialogs, DDEMan, COLOR,
  uString;

Type
  TDDEServerForm = Class (TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    DdeServerConv1: TDdeServerConv;
    DdeServerItem1: TDdeServerItem;
    AddBtn: TButton;
    RemoveBtn: TButton;
    EditBtn: TButton;
    Procedure ListBox1OnSetupShow (Sender: TObject);
    Procedure EditBtnOnClick (Sender: TObject);
    Procedure RemoveBtnOnClick (Sender: TObject);
    Procedure AddBtnOnClick (Sender: TObject);
    Procedure DDEServerFormOnSetupShow (Sender: TObject);
    Procedure DdeServerConv1OnExecuteMacro (Sender: TObject; Macro: TStrings;
                                            Var Success: Boolean);
    Procedure DdeServerItem1OnPokeData (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  DDEServerForm: TDDEServerForm;

Implementation

Procedure TDDEServerForm.ListBox1OnSetupShow (Sender: TObject);
Var t:Longint;
Begin
   For t:=1 To 10 Do
     ListBox1.Items.Add('DDE Server Item #'+tostr(t));
End;

Procedure TDDEServerForm.EditBtnOnClick (Sender: TObject);
Var s:String;
Begin
  If ListBox1.ItemIndex<0 Then
  Begin
     ErrorBox('No item selected !');
     exit;
  End
  Else
  Begin
     s:=ListBox1.Items[ListBox1.ItemIndex];
     If InputQuery('Modify Item','New caption of item:',s) Then
     Begin
        ListBox1.Items[ListBox1.ItemIndex]:=s;
        DDEServerItem1.Lines:=ListBox1.Items;
     End;
  End;
End;

Procedure TDDEServerForm.RemoveBtnOnClick (Sender: TObject);
Begin
  If ListBox1.ItemIndex<0 Then
  Begin
     ErrorBox('No item selected !');
     exit;
  End
  Else
  Begin
     ListBox1.Items.Delete(ListBox1.ItemIndex);
     DDEServerItem1.Lines:=ListBox1.Items;
  End;
End;

Procedure TDDEServerForm.AddBtnOnClick (Sender: TObject);
Var s:String;
Begin
  s:='';
  If InputQuery('Add Item','Caption of item:',s) Then
  Begin
    ListBox1.Items.Add(s);
    DDEServerItem1.Lines:=ListBox1.Items;
  End;
End;

Procedure TDDEServerForm.DDEServerFormOnSetupShow (Sender: TObject);
Begin
  //Set the font for the application to the font of the mainform
  //this is useful for the dialogs (InputQuery) to display the correct font
  Application.Font:=Font;

  DDEServerItem1.Lines:=ListBox1.Items;
  //specify the DDE service we support (DDESRV by default)
  DdeMgr.AppName:='Sibyl DDESRV Demo';
End;

Procedure TDDEServerForm.DdeServerConv1OnExecuteMacro (Sender: TObject;
          Macro: TStrings; Var Success: Boolean);
Var t:LongInt;
Begin
  For t:=0 To Macro.Count-1 Do
  Begin
      If Macro[t]='Change Color' Then
      Begin
          If Color=clDlgWindow Then Color:=clDkGray
          Else Color:=clDlgWindow;
      End;
  End;
End;

Procedure TDDEServerForm.DdeServerItem1OnPokeData (Sender: TObject);
Begin
  ListBox1.Items:=TDdeServerItem(Sender).Lines;
End;

Initialization
  RegisterClasses ([TDDEServerForm, TLabel, TListBox, TDdeServerConv, TDdeServerItem,
    TButton]);
End.

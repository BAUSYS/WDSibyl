Unit uDDECLient;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Buttons, DDEMan;

Type
  TDDEClientForm = Class (TForm)
    Label1: TLabel;
    ConnectBtn: TBitBtn;
    RequestBtn: TBitBtn;
    PokeBtn: TBitBtn;
    AdviseBtn: TBitBtn;
    MacroBtn: TBitBtn;
    Memo1: TMemo;
    Label2: TLabel;
    DdeClientConv1: TDdeClientConv;
    DdeClientItem1: TDdeClientItem;
    Procedure MacroBtnOnClick (Sender: TObject);
    Procedure PokeBtnOnClick (Sender: TObject);
    Procedure AdviseBtnOnClick (Sender: TObject);
    Procedure DdeClientItem1OnChange (Sender: TObject);
    Procedure RequestBtnOnClick (Sender: TObject);
    Procedure DdeClientConv1OnClose (Sender: TObject);
    Procedure DdeClientConv1OnOpen (Sender: TObject);
    Procedure ConnectBtnOnClick (Sender: TObject);
  Private
    {Insert private declarations here}
    FConnected:Boolean;
    FAdviseMode:Boolean;
  Public
    {Insert public declarations here}
  End;

Var
  DDEClientForm: TDDEClientForm;

Implementation

Procedure TDDEClientForm.MacroBtnOnClick (Sender: TObject);
Begin
  DDEClientConv1.ExecuteMacro('Change Color',TRUE);
End;

Procedure TDDEClientForm.PokeBtnOnClick (Sender: TObject);
Begin
  DDEClientItem1.Lines:=Memo1.Lines;
  DDEClientItem1.Poke;
End;

Procedure TDDEClientForm.AdviseBtnOnClick (Sender: TObject);
Begin
  If FAdviseMode Then
  Begin
     AdviseBtn.Caption:='~Advise';
     DDEClientItem1.UnAdvise;
     FAdviseMode:=False;
  End
  Else
  Begin
     AdviseBtn.Caption:='~Unadvise';
     DDEClientItem1.Advise;
     FAdviseMode:=True;
  End;
End;

Procedure TDDEClientForm.DdeClientItem1OnChange (Sender: TObject);
Begin
  Memo1.Lines:=DDEClientItem1.Lines;
End;

Procedure TDDEClientForm.RequestBtnOnClick (Sender: TObject);
Begin
  DDEClientItem1.Request;
End;

Procedure TDDEClientForm.DdeClientConv1OnClose (Sender: TObject);
Begin
  Caption:='DDE Client Sample (not connected)';
  FConnected:=False;
  ConnectBtn.Caption:='~Connect';
  RequestBtn.Enabled:=False;
  PokeBtn.Enabled:=False;
  AdviseBtn.Enabled:=False;
  FAdviseMode:=False;
  AdviseBtn.Caption:='~Advise';
  MacroBtn.Enabled:=False;
End;

Procedure TDDEClientForm.DdeClientConv1OnOpen (Sender: TObject);
Begin
  Caption:='DDE Client Sample (connected to:'+
           DDEClientConv1.DDEService+')';
  FConnected:=True;
  ConnectBtn.Caption:='~Disconnect';
  RequestBtn.Enabled:=True;
  PokeBtn.Enabled:=True;
  AdviseBtn.Enabled:=True;
  MacroBtn.Enabled:=True;
End;
        
Procedure TDDEClientForm.ConnectBtnOnClick (Sender: TObject);
Begin
  If not FConnected
    Then DDEClientConv1.OpenLink
    Else DDEClientConv1.CloseLink;
End;

Initialization
  RegisterClasses ([TDDEClientForm, TLabel, TBitBtn, TMemo, TDdeClientConv,
                    TDdeClientItem]);
End.

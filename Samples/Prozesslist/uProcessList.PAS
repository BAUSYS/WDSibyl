Unit uProcessList;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Buttons,BSEDOS, Process,
  ComCtrls,SysUtils,Dialogs;

Type
  TFrmProcessList = Class (TForm)
    BtnGetProcessList: TButton;
    btnKill: TButton;
    MultiColumnList: tMultiColumnList;
    Procedure BtnGetProcessListOnClick (Sender: TObject);
    Procedure btnKillOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  FrmProcessList: TFrmProcessList;

Implementation

Procedure TFrmProcessList.btnKillOnClick (Sender: TObject);

VAR ActionCode,rc,Index:Longint;

Begin
  Index:=StrtoInt(MultiColumnList.Values[0,MultiColumnList.ItemIndex]);
  ShowMessage('Killen : '+#13+MultiColumnList.Values[1,MultiColumnList.ItemIndex]+'PID : '+ToStr(Index));
  rc := DosKillProcess(1, Index);
  IF RC<>0 Then ShowMessage('Return Code : '+ToStr(RC)) else
    Begin
      MultiColumnList.Clear;
      GetProcessList(MultiColumnList.Items);
    End;
End;

Procedure TFrmProcessList.BtnGetProcessListOnClick (Sender: TObject);
Begin
  MultiColumnList.Items.Clear;
  GetProcessList(MultiColumnList.Items);
End;

Initialization
  RegisterClasses ([TFrmProcessList, TButton, tMultiColumnList]);
End.

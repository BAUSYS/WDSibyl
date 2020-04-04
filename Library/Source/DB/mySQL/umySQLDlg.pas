Unit umySQLDlg;

Interface

Uses Classes, SysUtils, Forms, Messages, Dialogs, Buttons, StdCtrls, Color,
     ExtCtrls, uString, Grids,
     uDBMySQL, uTable;

type
  tInstallNotifyEvent = procedure (iSender: TObject; iDatabase : String) of object;

  TDatabaseDialog=Class(TDialog)
    Private
      fcbConnect     : tComboBox;
      fedHost        : tEdit;
      fedDatabase    : tEdit;
      fedUser        : tEdit;
      fedPassword    : tEdit;
      fBtnAdd        : tButton;
      fBtnDelete     : tButton;
      fBtnInstall    : tButton;
      fOkCancelButton: tOKCancelButton;
      fOnInstall     : tInstallNotifyEvent;

      procedure DismissDlg(Result: TCommand); override;

      Procedure evcbConnectOnItemFocus(Sender : tObject; Index: LongInt);
      Procedure evBtnAddOnClick(Sender : tObject);
      Procedure evBtnDeleteOnClick(Sender : tObject);
      Procedure evBtnInstallOnClick(Sender : tObject);
      Procedure RefreshConnect;

      Procedure SetFields(iCurrent : String);

      Function getCurrent : String;
      Procedure setCurrent(iCurrent : String);

      Function getHost : String;
      Function getDatabase : String;
      Function getUser : String;
      Function getPassword : String;

    Protected
      Procedure SetupComponent; Override;
    Public
      Constructor Create(AOwner: TComponent); virtual;

    Published
      Property Current : String Read getCurrent Write setCurrent;
      Property Host    : String Read getHost;
      Property Database: String Read getDatabase;
      Property User    : String Read getUser;
      Property Password: String Read getPassword;

      Property OnInstall:tInstallNotifyEvent Read fOnInstall Write fOnInstall;
  End;

  TDBInfoDialog=Class(TForm)
    Private
      fCbTables  : tComboBox;
      fLblZeilen : tLabel;
      flblSpalten: tLabel;
      fsgTable   : TStringGrid;
      fDatabase  : tcDatabase;

      Procedure fcbTablesOnItemFocus(Sender: TObject; Index: LongInt);
    Protected
      Procedure SetupComponent; Override;
    Public
      Constructor Create(AOwner: TComponent; iDatabase : tcDatabase); virtual;

      Property Database : tcDatabase Read fDatabase;
    Published
  End;

Implementation

// --------------------- TDBInfoDialog -------------------------


Procedure TDBInfoDialog.fcbTablesOnItemFocus(Sender: TObject; Index: LongInt);

Var TableName : String;
    oDaten    : tcTable;
    SQL       : String;

Begin
  Screen.Cursor:=crSQLWait;
  TableName:=fcbTables.Text;
  oDaten.Create(TableName);
  SQL:='Select * from '+ TableName;
  fDatabase.Query(SQL, oDaten);
  flblZeilen.Caption:='Zeilen: '+toStr(oDaten.RowCount);
  flblSpalten.Caption:='Spalten: '+toStr(oDaten.ColCount);
  oDaten.getStringGrid(fsgTable);
  oDaten.Destroy;
  Screen.Cursor:=crDefault;
End;

Procedure TDBInfoDialog.SetupComponent;

var lbl : tLabel;

Begin
  Inherited SetupComponent;
  Name    := 'DBInfoDialog';
  Caption := 'Datenbankinformationen ...';
  Width   := 600;
  Height  := 420;
  Color   := clDlgWindow;

// Komponenten erstellen
  lbl:=InsertLabel(Self, 10, 350, 80,30, 'Tabelle:');
  lbl.PenColor:=clBlack;
  lbl.Align:=alFixedLeftTop;

  fCbTables:=InsertComboBox(Self, 90, 350, 250, 30, csDropDownList);
  fDatabase.GetTableList(fcbTables.Items);
  fcbTables.Align:=alFixedLeftTop;
  fcbTables.OnItemFocus:=fcbTablesOnItemFocus;

  flblZeilen :=InsertLabel(Self, 10, 330, 100, 20,'Zeilen:');
  flblZeilen.Align:=alFixedLeftTop;
  flblSpalten:=InsertLabel(Self, 130, 330, 100, 20,'Spalten:');
  flblSpalten.Align:=alFixedLeftTop;

  fsgTable:=InsertStringGrid(Self,10,10,570,310);
  fsgTable.Align:=alFrame;
  fsgTable.RowCount:=1;
  fsgTable.ColCount:=1;
  fsgTable.FixedCols:=0;
  fsgTable.Options:=[goBorder,goColSizing,goShowSelection,goMouseSelect];
End;


Constructor TDBInfoDialog.Create(AOwner: TComponent; iDatabase : tcDatabase);

Begin
// fDatabase muss vorher definiert werden, den in Parentklasse wird
// SetupComponent aufgerufen und da wird Variable fDatabase verwendet.

  fDatabase := iDatabase;
  inherited Create(AOwner);
End;

// --------------------- tDatabaseDialog -------------------------

Const cSecConnect    = 'mySQLConnect';

Procedure tDatabaseDialog.RefreshConnect;

Begin
  fcbConnect.Clear;
  Application.ProgramIniFile.ReadSection(cSecConnect, fcbConnect.Items);
End;

Procedure tDatabaseDialog.SetupComponent;

var lbl    : tLabel;

Begin
  Inherited SetupComponent;
  Name    := 'DatabaseDialog';
  Caption := 'Datenbank wechseln...';
  Width   := 450;
  Height  := 290;
  Color   := clDlgWindow;

  lbl:=InsertLabel(Self, 10, 220, 100,30, 'Verbindung:');
  lbl.PenColor:=clBlack;
  lbl:=InsertLabel(Self, 10, 150, 100,30, 'Host:');
  lbl.PenColor:=clBlack;
  lbl:=InsertLabel(Self, 10, 120, 100,30, 'Datenbank:');
  lbl.PenColor:=clBlack;
  lbl:=InsertLabel(Self, 10,  90, 100,30, 'User:');
  lbl.PenColor:=clBlack;
  lbl:=InsertLabel(Self, 10,  60, 100,30, 'Passwort:');
  lbl.PenColor:=clBlack;

  fcbConnect := InsertComboBox(Self,100,220,330,30,csDropDown);
  fcbConnect.OnItemFocus:=evcbConnectOnItemFocus;

  fBtnAdd    := InsertButton(Self,150,190,100,30,'HinzufÅgen', 'Verbindung hinzufÅgen');
  fBtnAdd.OnClick:=evBtnAddOnClick;
  fBtnDelete := InsertButton(Self,270,190,100,30,'Loeschen', 'Verbindung lîschen');
  fBtnDelete.OnClick:=evBtnDeleteOnClick;

  fedHost    := InsertEdit(Self,100,160,330,30, 'localhost', 'Hostname');
  fedDatabase:= InsertEdit(Self,100,130,220,30, 'Datenbank', 'Datenbank');
  fedUser    := InsertEdit(Self,100,100,330,30, 'User', 'Username');
  fedPassword:= InsertEdit(Self,100, 70,330,30, 'Passwort', 'Passwort von dem User');
{  fPassword.PasswordChar:='*'; }
  fedPassword.Unreadable:=true;

  if fOnInstall<>nil then
    Begin
      fBtnInstall:= InsertButton(Self, 330, 128, 100, 25, 'Install', 'Installieren der DB');
      fBtnInstall.OnClick:=evBtnInstallOnClick;
    End;

  fOkCancelButton:=InsertOKCancelButton(Self, 120, 10);

// Verbindungen einlesen
  RefreshConnect;
End;

procedure tDatabaseDialog.DismissDlg(Result: TCommand);

Var SelText : String;

Begin
  if ModalResult = cmOK then
    Begin
//      SelText:=fcbConnect.Text;
//      Application.ProgramIniFile.WriteString(cSecConnect, cIdntCurConnect, SelText);
    End;
  inherited DismissDlg(Result);
End;

Procedure tDatabaseDialog.evBtnInstallOnClick(Sender : tObject);

Begin
  fOnInstall(Sender, fedDatabase.Text);
End;

Procedure tDatabaseDialog.evBtnAddOnClick(Sender : tObject);

Var ConnectStr : String;
    Ident      : String;

Begin
  Ident:=fcbConnect.Text;
  if Ident = '' then
    Begin
      MessageBox('Verbindungsname eingeben', mtError, [mbOk]);
      exit;
    End;
  ConnectStr:=fedHost.Text+';'+ fedDatabase.Text+';' +
              fedUser.Text+';'+fedPassword.Text;
  Application.ProgramIniFile.WriteString(cSecConnect, Ident, ConnectStr);
  RefreshConnect;
End;

Procedure tDatabaseDialog.evBtnDeleteOnClick(Sender : tObject);

Var Ident : String;

Begin
  Ident:=fcbConnect.Text;
  if Ident = '' then
    Begin
      MessageBox('Verbindungsname auswÑhlen', mtError, [mbOk]);
      exit;
    End;
  Application.ProgramIniFile.Erase(cSecConnect, IDent);
  RefreshConnect;
End;

Procedure tDatabaseDialog.evcbConnectOnItemFocus(Sender : tObject; Index: LongInt);

Var ConnectStr : String;

Begin
  ConnectStr:=fcbConnect.Items[Index];
  SetFields(ConnectStr);
End;


Function tDatabaseDialog.getCurrent : String;

Begin
  Result:=fcbConnect.Text;
End;

Procedure tDatabaseDialog.setCurrent(iCurrent : String);

var DB : String;

Begin
  DB:=Application.ProgramIniFile.ReadString(cSecConnect, iCurrent, '');
  if DB='' then
    Begin
      Raise EFileNotFound.Create('DB "'+iCurrent+'" not found');
      exit;
    end;

  fcbConnect.Text:=iCurrent;
  if iCurrent=''
    then
      Begin
      End
    else
      Begin
        SetFields(iCurrent);
      End;
End;

Procedure tDatabaseDialog.SetFields(iCurrent : String);

var ConnectStr: String;
    CurList   : tStringList;

Begin
  ConnectStr:=Application.ProgramIniFile.ReadString(cSecConnect, iCurrent, '');
  CurList.Create;
  CurList.AddSplit(ConnectStr,';');
  fedHost.Text    :=CurList.Strings[0];
  fedDatabase.Text:=CurList.Strings[1];
  fedUser.Text    :=CurList.Strings[2];
  fedPassword.Text:=CurList.Strings[3];
  CurList.Destroy;
End;

Function tDatabaseDialog.getHost : String;

Begin
  Result:=fedHost.Text;
End;

Function tDatabaseDialog.getDatabase : String;

Begin
  Result:=fedDatabase.Text;
End;

Function tDatabaseDialog.getUser : String;

Begin
  Result:=fedUser.Text;
End;

Function tDatabaseDialog.getPassword : String;

Begin
  Result:=fedPassword.Text;
End;

Constructor tDatabaseDialog.Create(AOwner: TComponent);

Begin
  inherited Create(AOwner);
  fOnInstall:=nil;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  04-Sep-05  WD         Erweiterung des Dialoges
  25-Sep-05  WD         toBoolean: Typ=String verarbeiten
  20-Dez-06  WD         Create und Check auf OnInstall eingebaut.
  22-Dez-06  WD         Info-Dialog eingebaut
}
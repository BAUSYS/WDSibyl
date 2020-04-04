Unit uWDSibDlg;

Interface

Uses Forms, StdCtrls, ExtCtrls, Dialogs, Dos, SysUtils, Graphics,
     Buttons, Color,
     Consts, uDLLDef, BmpList, uString;

PROCEDURE AboutDialog(InfoAboutDialog : tInfoAboutDialog);

Implementation

CONST StartupBmpWidth  = 346;
      StartupBmpHeight = 178;

// Internetadressen
Const MaxPowerby = 6;
      cPowerByTxt : Array [1..6] of tStr30 =
         ('CuL','Toolbox','OS/2 User Association Schweiz',
          'OS/2 Team Hamburg','Martin Vieregg',
          'KFZ-Werkstatt Gerald Christ');

      cPowerByLink : Array [1..6] of String =
         ('http://www.cul.de',
          'http://www.toolbox-mag.de',
          'http://www.os2.ch',
          'http://www.teamos2hamburg.de',
          'http://www.hypermake.com/english/home.html',
          'http://www.kfz-werkstaette.com');
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: About Dialog                                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

type TAboutDialog=CLASS(TDialog)
       fGBox         : tGroupbox;
       fInfo         : tInfoAboutDialog;
       fStatic       : TLabel;
       fPicture      : TImage;
       fBitmapListBox: TBitmapListBox;
       fmmContact    : tMemo;

       PROCEDURE SetupComponent;OVERRIDE;
       Constructor Create(InfoAboutDialog : tInfoAboutDialog); Virtual;

     Private
       Procedure CallUrl(iUrl : String);
       PROCEDURE PictureOnClick(Sender:TObject);
       Procedure BitmapListBoxOnItemSelect(Sender: TObject; Index: LongInt);
       Procedure evmmContactSetupShow(Sender: TObject);
     end;

Constructor TAboutDialog.Create(InfoAboutDialog : tInfoAboutDialog);

Begin
  fInfo:=InfoAboutDialog;
  inherited Create(gDLLInfo.Application.MainForm);
End;


Procedure TAboutDialog.CallUrl(iUrl : String);

var evs, ae : boolean;

Begin
  evs:=ExecViaSession;
  ae :=AsynchExec;
  ExecViaSession := true;
  AsynchExec := true;
  exec(iUrl,'');
  ExecViaSession:=evs;
  AsynchExec:=ae;
End;


procedure TAboutDialog.PictureOnClick(Sender: TObject);

Begin
  CallUrl(WDSibyl_HomepageLink);
end;


Procedure TAboutDialog.BitmapListBoxOnItemSelect(Sender: TObject; Index: LongInt);

var cou : LongWord;
    txt : tStr30;

Begin
  cou:=0;
  txt:=fBitmapListBox.Items[Index];
  repeat
    inc(cou);
  until txt=cPowerByTxt[cou];
  CallUrl(cPowerByLink[cou]);
End;

Procedure tAboutDialog.evmmContactSetupShow(Sender: TObject);

Begin
// Kontakte befuellen
// In frmMainOnSetupShow funktioniert der Property nicht.
  fmmContact.Text:=WDSibyl_Contact;
End;

procedure tAboutDialog.SetupComponent;

var bmp : tBitmap;

Begin
  Inherited SetupComponent;

  HelpContext := fInfo.HelpContext;  //hctxDialogAbout;
  Caption:=fInfo.Caption;           //LoadNLSStr(SiProductInformation);
  Width:=500;
  Height:=630;

  fGBox:=InsertGroupBoxNLS(Self,10,255,470,335,0);
  fPicture:=InsertImageName(fGBox,10,142,StartupBmpWidth,StartupBmpHeight,'SibLogo');
  fPicture.XAlign:=xaCenter;
  fPicture.ZOrder:=zoTop;
  fPicture.OnClick:=PictureOnClick;
  fPicture.Hint:='Link:' + WDSibyl_HomepageLink;

  fStatic:=InsertLabel(fGBox,10,115,300,20,fInfo.VPDTool);
  fStatic.AutoSize:=TRUE;
  fStatic.XAlign:=xaCenter;
  fStatic:=InsertLabel(fGBox,10,95,300,20,
         'Version: ' + Application.GetProgramVersionString);
  fStatic.AutoSize:=TRUE;
  fStatic.XAlign:=xaCenter;

  fmmContact:=InsertMemo(fgBox,60,10,353,81,'');
  fmmContact.Color:=clYellow;
  fmmContact.ReadOnly:=true;
  fmmContact.Font:=Screen.GetFontFromPointSize('Courier',9);
  fmmContact.Caption:='fjdkshfksajdhfk';
  fmmContact.OnSetupShow:=evmmContactSetupShow;
//  fmmContact.Text:=WDSibyl_Contact;

// PoweredBy-Listbox erstellen
  fStatic:=InsertLabel(Self,10,225,300,20, 'Powered by:');
  fBitmapListBox:=InsertBitmapListBox(Self, 10, 50, 470, 170, 100);
  fBitmapListBox.OnItemSelect:=BitmapListBoxOnItemSelect;
  bmp.Create;

// Alphabetisch sortiert
  bmp.LoadFromResourceName('PWByChristG');
  fBitmapListBox.AddBitmap(cPowerByTxt[6],bmp);
  bmp.LoadFromResourceName('PwByCul');
  fBitmapListBox.AddBitmap(cPowerByTxt[1],bmp);
  bmp.LoadFromResourceName('PwByOS2Hamburg');
  fBitmapListBox.AddBitmap(cPowerByTxt[4],bmp);
  bmp.LoadFromResourceName('PWByOS2CH');
  fBitmapListBox.AddBitmap(cPowerByTxt[3],bmp);
  bmp.LoadFromResourceName('PwByToolbox');
  fBitmapListBox.AddBitmap(cPowerByTxt[2],bmp);
  bmp.LoadFromResourceName('PWByViereggM');
  fBitmapListBox.AddBitmap(cPowerByTxt[5],bmp);

// Bitmap-Objekt wieder zerstoeren
  bmp.destroy;

  InsertBitBtnNLS(Self,210,10,80,30,bkOk,SOkButton,SClickHereToAccept);

End;

PROCEDURE AboutDialog(InfoAboutDialog : tInfoAboutDialog);

VAR Dialog:TAboutDialog;
                     
BEGIN
  Dialog.Create(InfoAboutDialog);
  Dialog.ShowModal;
  Dialog.Destroy;
END;

Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  19-Apr-2006 WD       AboutDialog: PoweredBy-Listbox erstellt
}

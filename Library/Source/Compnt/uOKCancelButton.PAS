Unit uOKCancelButton;

Interface

Uses
  Classes, Forms, Graphics, Buttons,
  SysUtils,
  uString;

{Deklariere neue Klasse}

type tOkCancelButtonKind = (okcHorizontal, okcVertical);

Type
  tOKCancelButton=Class(TControl)
    Private
      fBtnOK        : tBitBtn;
      fBtnCancel    : tBitBtn;
      fBtnHelp      : tBitBtn;
      fKind         : tOkCancelButtonKind;
      fOnOKClick    : TNotifyEvent;
      fOnCancelClick: TNotifyEvent;
      fOnHelpClick  : TNotifyEvent;
      fTabStop      : Boolean;

      Procedure SetOBCKind(iKind : tOkCancelButtonKind);
      Procedure SetOBCFont(iFont : tFont);
      Procedure SetTabStop(iTabStop : Boolean);

      Function  GetOBCFont : tFont;

      Procedure OCBOnOKClick(Sender : tObject);
      Procedure OCBOnCancelClick(Sender : tObject);
      Procedure OCBOnHelpClick(Sender : tObject);


    Protected
      Procedure SetupComponent; Override;
      Procedure Resize; Override;
    Public
      Destructor Destroy; Override;
    Published
      Property Align;
      Property Kind         : tOkCancelButtonKind Read fKind          Write SetOBCKind;
      Property Font         : tFont               Read GetOBCFont     Write SetOBCFont;
      Property TabStop      : Boolean Read fTabStop Write SetTabStop;
      Property TabOrder;

      Property OnOKClick    : TNotifyEvent        Read FOnOKClick     Write fOnOKClick;
      Property OnCancelClick: TNotifyEvent        Read FOnCancelClick Write fOnCancelClick;
      Property OnHelpClick  : TNotifyEvent        Read FOnHelpClick   Write fOnHelpClick;
  End;

{Zu exportierende Komponenten definieren}
{Sie kînnen eine Seite der Komponentenpalette und eine Bitmapdatei fÅr die Komponente angeben}
{ Exports
  tOKCancelButton,'Buttons','S:\SibylIDE\Bmp\OKCancelButton.bmp'; }

Implementation

Const cHorzHeight = 30;
      cHorzWidth  = 311;
      cVertHeight = 100;
      cVertWidth  = 100;

Procedure tOKCancelButton.OCBOnOKClick(Sender : tObject);

Begin
  if fOnOKClick<>nil then fOnOKClick(Self);
End;

Procedure tOKCancelButton.OCBOnCancelClick(Sender : tObject);

Begin
  if fOnCancelClick<>nil then fOnCancelClick(Self);
End;

Procedure tOKCancelButton.OCBOnHelpClick(Sender : tObject);

Begin
  if Form.HelpContext <> 0 then
    Application.HelpContext(Form.HelpContext);
  if fOnHelpClick<>nil then fOnHelpClick(Self);
End;

Procedure tOKCancelButton.SetOBCFont(iFont : tFont);

Begin
  fbtnOk.Font    :=iFont;
  fbtnCancel.Font:=iFont;
  fbtnHelp.Font  :=iFont;
End;

Procedure tOKCancelButton.SetTabStop(iTabStop : Boolean);

Begin
  fTabStop          := iTabStop;
  fBtnOk.TabStop    := iTabStop;
{  fBtnCancel.TabStop:= iTabStop;
  fBtnHelp.TabStop  := iTabStop; }
End;

Function  tOKCancelButton.GetOBCFont : tFont;

Begin
  Result:=fbtnOk.Font;
End;

Procedure tOKCancelButton.SetOBCKind(iKind : tOkCancelButtonKind);

Begin
  fKind := iKind;
  Resize;
End;

Procedure tOKCancelButton.Resize;

Var OKPoint    : tPoint;
    CancelPoint: tPoint;
    HelpPoint  : tPoint;

Begin
  if fKind = okcHorizontal
    then
      Begin
        Height:=cHorzHeight;
        Width :=cHorzWidth;
        OKPoint.X:=0;
        OKPoint.Y:=0;
        CancelPoint.X:=105;
        CancelPoint.Y:=0;
        HelpPoint.X:=210;
        HelpPoint.Y:=0;
      End
    else
      Begin
        Height:=cVertHeight;
        Width :=cVertWidth;
        OKPoint.X:=0;
        OKPoint.Y:=2*cHorzHeight+10;
        CancelPoint.X:=0;
        CancelPoint.Y:=cHorzHeight + 5;
        HelpPoint.X:=0;
        HelpPoint.Y:=0;
      End;

  fbtnOk.SetWindowPos(OKPoint.X, OKPoint.Y, cVertWidth, cHorzHeight);
  fbtnCancel.SetWindowPos(CancelPoint.X, CancelPoint.Y, cVertWidth, cHorzHeight);
  fbtnHelp.SetWindowPos(HelpPoint.X, HelpPoint.Y, cVertWidth, cHorzHeight);

  Inherited Resize;
End;

Procedure tOKCancelButton.SetupComponent;
Begin
  Inherited SetupComponent;
  Name:='OkCancelButton';
  Width:=cHorzWidth;;
  Height:=cHorzHeight;
  ParentPenColor:= True;
  ParentColor:= True;
  Inherited TabStop := false;   { Damit kann das Controlselber nicht angesprungen werden }

  fBtnOK:= InsertBitBtn(Self, 0,   0, cVertWidth, cHorzHeight,  bkOK,
                 '~' + LoadNLSStr(SOk), '');
  fBtnOk.Name      := 'btnOCBOK';
  fBtnOk.OnClick   := OCBOnOKClick;
  fBtnOk.TabStop   := true;
  fBtnOk.ParentFont:= true;

  fBtnCancel:= InsertBitBtn(Self, 105, 0, cVertWidth, cHorzHeight,  bkCancel,
                 '~' + LoadNLSStr(SCancel), '');
  fBtnCancel.Name      := 'btnOCBCancel';
  fBtnCancel.OnClick   := OCBOnCancelClick;
  fBtnCancel.TabStop   := true;
  fBtnCancel.ParentFont:= true;

  fBtnHelp  := InsertBitBtn(Self, 210, 0, cVertWidth, cHorzHeight,  bkHelp,
                 '~' + LoadNLSStr(SHelp), '');
  fBtnHelp.Name      := 'btnOCBHelp';
  fBtnHelp.OnClick   := OCBOnHelpClick;
  fBtnHelp.TabStop   := true;
  fBtnHelp.ParentFont:= true;

  If Designed
    then
      Begin
        Include(fBtnOk.ComponentState, csDetail);
        Include(fBtnCancel.ComponentState, csDetail);
        Include(fBtnHelp.ComponentState, csDetail);
      End
    else fBtnHelp.Enabled:=Application.HelpFile <> '';

  fKind:=okcHorizontal;

  setTabStop(true);
End;

Destructor tOKCancelButton.Destroy;
Begin
  Inherited Destroy;
End;

Initialization
  {Klassen registrieren}
  RegisterClasses([tOKCancelButton]);
End.


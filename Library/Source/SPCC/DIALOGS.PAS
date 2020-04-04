
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit Dialogs;

Interface

{$IFDEF OS2}
Uses BseDos,BseErr,PmWin,PmStdDlg;
{$ENDIF}
{$IFDEF Win32}
Uses WinDef,WinBase,WinUser,CommDlg;
{$ENDIF}

Uses Dos,SysUtils,Color,Classes,Messages,Graphics,Forms,Buttons,StdCtrls,ExtCtrls,ComCtrls,
     FileCtrl,Printers,
     uString;

Type
    TDialog=Class(TForm)
      Protected
         Procedure SetupComponent;Override;
         Property AutoScroll;
         Property EnableDocking;
         Property HorzScrollBar;
         Property Constraints;
         Property Menu;
         Property FormStyle;
         Property VertScrollBar;
         Property OnMenuInit;
         Property OnMenuEnd;
         Property OnMenuItemFocus;
      Public
         Function Execute:Boolean;Virtual;
         Property Align;
         Property BorderIcons;
         Property BorderStyle;
         Property Bottom;
         Property ClientHeight;
         Property ClientWidth;
         Property Color;
         Property Cursor;
         Property Enabled;
         Property Font;
         Property Height;
         Property Hint;
         Property Icon;
         Property Left;
         Property PenColor;
         Property PopupMenu;
         Property Right;
         Property ScrollBars;
         Property ShowHint;
         Property Top;
         Property Visible;
         Property Width;
         Property WindowState;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;

         Property OnActivate;
         Property OnClose;
         Property OnCloseQuery;
         Property OnCommand;
         Property OnCreate;
         Property OnDeactivate;
         Property OnDestroy;
         Property OnDismissDlg;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnHide;
         Property OnKeyPress;
         Property OnMaximize;
         Property OnMinimize;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnMove;
         Property OnPaint;
         Property OnResize;
         Property OnRestore;
         Property OnScan;
         Property OnSetupShow;
         Property OnShow;
         Property OnTranslateShortCut;
    End;

    {$IFDEF WIN32,OS2}
    TSystemOpenSaveDialog=Class(TComponent)
      Private
         FOkName           : String;
         FTitle            : String;
         FFileName         : String;
         FDefaultExt       : String;
         FFilter           : String;
         FFilterIndex      : LongInt;
         FMaskList         : TStringList;
         FHelpContext      : THelpContext;
         FHelpContextString: string;
         FInitialDir       : tFileName;
         {$ifdef win32}
         //procedure OFNHookProc(Win:HWND;Msg:ULONG;para1:WParam;para2:longint);
         {$endif}
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         {Martin0706}Procedure AddFilter(Name,Mask:String);
      Published
         Property DefaultExt:String Read FDefaultExt Write FDefaultExt;
         Property Filter:String Read FFilter Write FFilter;
         Property FilterIndex:LongInt Read FFilterIndex Write FFilterIndex;
         Property FileName:String Read FFileName Write FFileName;
         Property OkName:String Read FOkName Write FOkName;
         Property Title:String Read FTitle Write FTitle;
         Property Caption:String Read FTitle Write FTitle;{Martin0706}
         Property HelpContext:THelpContext Read FHelpContext Write FHelpContext;
         Property HelpContextString:string Read FHelpContextString Write FHelpContextString;
         Property InitialDir : string read FInitialDir write FInitialDir;{Martin0108}
    End;

    TSystemOpenDialog=Class(TSystemOpenSaveDialog)
      Protected
         Procedure SetupComponent;Override;
      Public
         Function Execute:Boolean;
    End;


    TSystemSaveDialog=Class(TSystemOpenSaveDialog)
      Protected
         Procedure SetupComponent;Override;
      Public
         Function Execute:Boolean;
    End;
    {$ENDIF}

    TOpenDialog=Class(TDialog)
      Private
         FCurDir          : String;
         FTitle           : String;
         FFileName        : String;
         FFilter          : String;
         FFilterIndex     : LongInt;
         FDefaultExt      : String;
         FOkName          : String;
         FFileNameEdit    : TEdit;
         FLabel1,FLabel2,
           FLabel3,FLabel4,
           FLabel5        : tLabel;
         FFilterCombo     : TFilterComboBox;
         FDriveCombo      : TDriveComboBox;
         FFileList        : TFileListBox;
         FDirectoryList   : TDirectoryListBox;
         FCurrentNamePanel: TPanel;
         FOkButton        : TBitBtn;
         FCancelButton    : TBitBtn;

         fFiles           : tStringList;

         Procedure SetFileName(Value:String);
         Function GetFileName:String;
         Procedure SetCurDir(Value:String);
         Procedure FileChange(Sender:TObject);
         Procedure FileSelect(Sender:TObject;Index:LongInt);
         Procedure FilterSelect(Sender:TObject;Index:LongInt);
         Procedure EvKillFocus(Sender:TObject);
         Procedure EvFileItemFocus(Sender:TObject;Index:LongInt);
         Procedure EvDirListChange(Sender:TObject);
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
         function GetFileTypeName (Index:LongInt) : string;
         function GetFileTypeExt (Index:LongInt) : string;
         Procedure SetMultiSelect(Value : Boolean);

         Function GetMultiSelect : Boolean;

         {Martin0206}
         FFileNameEditTop : integer;
         FFilterComboTop : integer;
         FDriveComboTop : integer;
         FFileListTop : integer; {Martin0306}
         FLabel1Top, FLabel2Top, FLabel3Top, FLabel4Top, FLabel5Top : integer;
         ListDiff : integer;
         FileDirPart : double;
      Protected
         Margin, WidthDefault, HeightDefault : integer;
         Procedure SetupComponent;Override;
         procedure Resize; override;
         Procedure SetupShow;Override;
      Public
         HelpButton:TBitBtn;
         {Martin}Function Execute:Boolean;Virtual; override;
         Procedure DismissDlg(Result:TCommand);Override;
         Procedure AddFilter(Name,Mask:String);
         Property Caption;
         Property Font;
         {Martin}property FileTypeName[Index:LongInt] : string read GetFileTypeName;
         {Martin}property FileTypeExt[Index:LongInt] : string read GetFileTypeExt;
      Published
         Property DefaultExt : String      Read FDefaultExt Write FDefaultExt;
         Property FileName   : String      Read FFileName Write FFileName;
         Property Files      : tStringList Read fFiles;
         Property Filter     : String      Read FFilter Write FFilter;
         Property FilterIndex: LongInt     Read FFilterIndex Write FFilterIndex;
         Property OkName     : String      Read FOkName Write FOkName;
         Property Title      : String      Read FTitle Write FTitle;
         Property MultiSelect: Boolean     Read GetMultiSelect Write SetMultiSelect;
    End;

    TSaveDialog=Class(TOpenDialog)
      Private
         FCreateButtonTop : integer;
         FCreateButton:TSpeedButton;
         Procedure EvCreateDir(Sender:TObject);
         Property MultiSelect;
      Protected
         Procedure SetupComponent;Override;
         procedure Resize; override;
    End;

    TCreateDirDialog=Class(TDialog)
      Private
         FOkName:String;
         FDirectory:String;
         FChangeDir:Boolean;
         FDirEdit:TEdit;
         FChangeCheck:TCheckBox;
         FOkButton:TBitBtn;
         FCancelButton:TBitBtn;
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         HelpButton:TBitBtn;
         Procedure DismissDlg(Result:TCommand);Override;
         Property Font;
      Published
         Property ChangeDir:Boolean Read FChangeDir Write FChangeDir;
         Property Directory:String Read FDirectory Write FDirectory;
         Property OkName:String Read FOkName Write FOkName;
    End;


    TChangeDirDialog=Class(TDialog)
      Private
         FOkName:String;
         FDirectory:String;
         FDriveCombo:TDriveComboBox;
         FOkButton:TBitBtn;
         FCancelButton:TBitBtn;
         FCreateButton:TBitBtn;
         Procedure DirectoryChange(Sender:TObject);
         Procedure EvCreateDir(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         DirectoryList:TDirectoryListBox;
         FileNameEdit:TEdit;
         HelpButton:TBitBtn;
         Function Execute:Boolean;Override;
      Published
         Property Directory:String Read FDirectory Write FDirectory;
         Property OkName:String Read FOkName Write FOkName;
    End;


    {$M+}
    TFindDirection = (fdForward,fdBackward);
    TFindOrigin    = (foEntireScope,foCursor);
    TFindScope     = (fsGlobal,fsSelection);
    TFindOptions   = Set Of (foCaseSensitive,foWordsOnly);
    {$M-}

    TFindDialog=Class(TDialog)
      Private
         Lab_Find:TLabel;
         CoB_Find:TComboBox;
         Grp_Options:TGroupBox;
         ChB_CaseSense:TCheckBox;
         ChB_WordsOnly:TCheckBox;
         Grp_Scope:TGroupBox;
         RaB_Global:TRadioButton;
         RaB_Selection:TRadioButton;
         Grp_Origin:TGroupBox;
         RaB_EntireScope:TRadioButton;
         RaB_Cursor:TRadioButton;
         Grp_Direction:TGroupBox;
         RaB_Forward:TRadioButton;
         RaB_Backward:TRadioButton;
         BiB_Find:TBitBtn;
         BiB_Cancel:TBitBtn;
         BiB_Help:TBitBtn;
         FFindTextExt:String;
         Function GetFindOptions:TFindOptions;
         Procedure SetFindOptions(Value:TFindOptions);
         Function GetFindOrigin:TFindOrigin;
         Procedure SetFindOrigin(Value:TFindOrigin);
         Function GetFindScope:TFindScope;
         Procedure SetFindScope(Value:TFindScope);
         Function GetFindDirection:TFindDirection;
         Procedure SetFindDirection(Value:TFindDirection);
         Function GetFindText:String;
         Procedure SetFindText(Const Value:String);
         Procedure SetFindTextExtend(Const Value:String);
         Procedure SetFindHistory(Const Strings:TStringList);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Property FindHistory:TStringList Write SetFindHistory;
      Published
         Property Options:TFindOptions Read GetFindOptions Write SetFindOptions;
         Property Origin:TFindOrigin Read GetFindOrigin Write SetFindOrigin;
         Property Scope:TFindScope Read GetFindScope Write SetFindScope;
         Property Direction:TFindDirection Read GetFindDirection Write SetFindDirection;
         Property FindText:String Read GetFindText Write SetFindText;
         Property FindTextExtend:String Read FFindTextExt Write SetFindTextExtend;
    End;


    TReplaceDialog=Class(TFindDialog)
      Private
         CoB_Replace:TComboBox;
         ChB_Confirm:TCheckBox;
         Function GetConfirm:Boolean;
         Procedure SetConfirm(Value:Boolean);
         Function GetReplaceText:String;
         Procedure SetReplaceText(Const Value:String);
         Procedure SetReplaceHistory(Const Strings:TStringList);
      Protected
         Procedure SetupComponent;Override;
      Public
         Property ReplaceHistory:TStringList Write SetReplaceHistory;
      Published
         Property Confirm:Boolean Read GetConfirm Write SetConfirm;
         Property ReplaceText:String Read GetReplaceText Write SetReplaceText;
    End;


    TColorDialog=Class(TDialog)
      Private
         FSelColor:TColor;
         FRedScroll,FGreenScroll,FBlueScroll:TScrollBar;
         FColorArea:TPanel;
         FOkBtn:TBitBtn;
         FDefaultCombo:TComboBox;
         Procedure SetSelColor(Value:TColor);
         Procedure EvSelectComboItem(Sender:TObject;Index:LongInt);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);Override;
         Procedure UpdateColorArea;
      Public
         Property RGBColor:TColor Read FSelColor Write SetSelColor;
    End;


    TFontDialog=Class(TDialog)
      Private
         FNameCombo:TComboBox;
         FSizeCombo:TComboBox;
         FExampleText:TButton;
         FItalicCheck:TCheckBox;
         FBoldCheck:TCheckBox;
         FOutlineCheck:TCheckBox;
         FUnderscoreCheck:TCheckBox;
         FStrikeOutCheck:TCheckBox;
         FOkBtn:TBitBtn;
         Function GetFontName:String;
         Procedure SetFontName(Value:String);
         Function GetFaceName:String;
         Procedure SetFaceName(Value:String);
         Function GetPointSize:LongInt;
         Procedure SetPointSize(Value:LongInt);
         Procedure SetTheFont;
         Procedure InsertSizes(Var TheFont:TFont);
         Procedure EvComboSelect(Sender:TObject;Index:LongInt);
         Procedure EvComboSizeSelect(Sender:TObject;Index:LongInt);
         Function GetEditFont:TFont;
         Procedure SetEditFont(NewFont:TFont);
         Function GetAttributes:TFontAttributes;
         Procedure SetAttributes(NewValue:TFontAttributes);
         Procedure StyleChanged(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Property FaceName:String Read GetFaceName Write SetFaceName;
         Property PointSize:LongInt Read GetPointSize Write SetPointSize;
      Published
         Property FontName:String Read GetFontName Write SetFontName;
         Property EditFont:TFont Read GetEditFont Write SetEditFont;
         Property Attributes:TFontAttributes Read GetAttributes Write SetAttributes;
    End;


    TPrinterSetupDialog=Class(TDialog)
      Private
         FPrinterListHeadLine: TLabel;
         FPrinterList: TListBox;
         FPrinterGroupCaption: String;
         FSetPrinterButton: TBitBtn;
         FCancelButton: TBitBtn;
         FPropertyButton: TBitBtn;
         FOkName: String;
         FOldPrinterIndex: LongInt;
         Procedure PrinterSelected (Sender: TObject; Index: LongInt);
         Procedure PrinterFocused (Sender: TObject; Index: LongInt);
         Procedure PropertyBtnClicked (Sender: TObject);
         Procedure SetOkName (NewName: String);
      Protected
         Procedure SetupComponent; Override;
      Public
         HelpButton: TBitBtn;
         Function Execute: Boolean; Override;
      Published
         Property OkName: String Read FOkName Write SetOkName;
    End;


    TPrintDialog=Class(TDialog)
      Private
         FTitleBox: TGroupBox;
         FTitle: TEdit;
         FOptionsGroupBox: TGroupBox;
         FNumberOfCopiesLabel: TLabel;
         FNumberOfCopies: TUpDown;
         FNumberOfCopiesEdit: TEdit;
         FPagesBox: TRadioGroup;
         FPrintFromLabel: TRadioButton;
         FPrintFrom: TUpDown;
         FPrintFromEdit: TEdit;
         FPrintToLabel: TLabel;
         FPrintTo: TUpDown;
         FPrintToEdit: TEdit;
         FPrintAll: TRadioButton;
         FOptionsBox: TRadioGroup;
         FPrinter: TRadioButton;
         FFileOutPut: TRadioButton;
         FFile: TEdit;
         FPrintButton: TBitBtn;
         FCancelButton: TBitBtn;
         FPropertyButton: TBitBtn;
         FCopies: LongInt;
         FMinPage: LongInt;
         FMaxPage: LongInt;
         FFromPage: LongInt;
         FToPage: LongInt;
         FAllPages: Boolean;
         FOkName: String;
         FOldPrinterIndex: LongInt;
      Protected
         Procedure PropertyBtnClicked (Sender: TObject);
         Procedure SetupComponent; Override;
         Procedure SetMinPage (NewValue: LongInt);
         Procedure SetMaxPage (NewValue: LongInt);
         Procedure SetToPage (NewValue: LongInt);
         Procedure SetFromPage (NewValue: LongInt);
         Procedure SetOkName (NewName: String);
         Procedure UpdateSpinSize (Sender: TObject);
      Public
         HelpButton: TBitBtn;
         Function Execute: Boolean; Override;
         Property AllPages: Boolean Read FAllPages;
         Property MinPage: LongInt Read FMinPage Write SetMinPage;
         Property MaxPage: LongInt Read FMaxPage Write SetMaxPage;
         Property FromPage: LongInt Read FFromPage Write SetFromPage;
         Property ToPage: LongInt Read FToPage Write SetToPage;
      Published
         Property OkName: String Read FOkName Write SetOkName;
    End;


    TMessageBox=Class(TDialog)
      Private
         FMsg:String;
         FHelpCtx:THelpContext;
         FButtons:TMsgDlgButtons;
         fType:TMsgDlgType;
      Protected
         Procedure SetupShow;Override;
         Procedure SetupComponent;Override;
      Published
         Property Message:String Read FMsg Write FMsg;
         Property Buttons:TMsgDlgButtons Read FButtons Write FButtons;
         Property DlgType:TMsgDlgType Read fType Write fType;
         Property HelpCtx:THelpContext Read FHelpCtx Write FHelpCtx;
    End;

    tInfoDialog=Class(TDialog)
      Private
        FOkButton      : TBitBtn;
        FProgramName   : TLabel;
        FProgramVersion: TLabel;
        FProgramPath   : TLabel;
        FProgramDate   : TLabel;
      Protected
        Procedure SetupComponent; Override;
      Public
        Property Font;
    End;

    tUserPasswordDialog=Class(tDialog)
      Private
        fInfotext      : String;
        fLblInfoText   : tLabel;
        fLblUser       : tLabel;
        fLblPassword   : tLabel;
        fedUser        : tEdit;
        fedPassword    : tEdit;
        fOkCancelButton: tOkCancelButton;

        Procedure SetInfoText(iValue : String);
        Procedure SetUser(iValue : String);
        Procedure SetPassword(iValue : String);
        Function GetUser : String;
        Function GetPassword : String;

      Protected
        Procedure SetupComponent; Override;
      Public
        Property Font;

      Published
        Property Infotext: String Write SetInfoText Read FInfoText;
        Property User    : String Write SetUser     Read GetUser;
        Property Password: String Write SetPassword Read GetPassword;
    end;


Function MessageBox(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Function ErrorBox(Const Msg:String):TMsgDlgReturn;

Function CreateMessageDialog(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons):TForm;
Function MessageDlg(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext):TMsgDlgReturn;
Function MessageDlgPos(Const Msg:String;DlgType: TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext;
                       X,Y:LongInt):TMsgDlgReturn;
Procedure ShowMessage(Const Msg:String);
Procedure ShowMessagePos(Const Msg:String;X,Y:LongInt);
Function InputBox(Const ACaption,APrompt,ADefault:String):String;
Function InputQuery(Const ACaption,APrompt:String;Var Value:String):Boolean;


Procedure ShowInfoDialog(AOwner: TComponent);

Implementation

Uses uSysInfo;


Type tInputQueryDialog = Class(tDialog)
       Private
         FEdit     : TEdit;
         fPrompt   : String;
         fValue    : String;
         flblPrompt: tLabel;

       Protected
         Procedure SetupComponent; Override;
         Procedure SetupShow;Override;
         Procedure DismissDlg(Result:TCommand);Override;

       Public
         Property Font;
         Property Prompt : String Read fPrompt  Write fPrompt;
         Property Value  : String Read fValue   Write fValue;
     End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: Some useful functions                                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure ShowInfoDialog(AOwner: TComponent);

var InfoDialog : tInfoDialog;

Begin
  InfoDialog.Create(AOwner);
  InfoDialog.Execute;
  InfoDialog.Destroy;
End;

Function MessageBox(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Var  Dlg:TMessageBox;
     OldDesignerForm:TForm;
Begin
     OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

     Dlg.Create(Screen.ActiveForm);
     Dlg.Width:=200;
     Dlg.Height:=200;
     Dlg.Buttons:=Buttons;
     Dlg.DlgType:=Typ;
     Dlg.FMsg:=Msg;

     If OldDesignerForm <> Nil {Reset the designer flag}
     Then Include(OldDesignerForm.ComponentState, csDesigning);

     Dlg.Execute;
     Case Dlg.ModalResult Of
       cmOk:     Result:=mrOk;
       cmCancel: Result:=mrCancel;
       cmYes:    Result:=mrYes;
       cmNo:     Result:=mrNo;
       cmIgnore: Result:=mrIgnore;
       cmRetry:  Result:=mrRetry;
       cmAbort:  Result:=mrAbort;
       Else      Result:=mrCancel;
     End;
     Dlg.Destroy;
End;


Function ErrorBox(Const Msg:String):TMsgDlgReturn;
Begin
     Beep(1000,200);
     Result:=MessageBox(Msg,mtError,[mbOk]);
End;


Procedure ShowMessage(Const Msg:String);
Var  Dlg:TMessageBox;
     OldDesignerForm:TForm;
Begin
     OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

     Dlg.Create(Screen.ActiveForm);
     Dlg.Width:=200;
     Dlg.Height:=200;
     Dlg.FButtons:=[mbOk];
     Dlg.fType:=mtInformation;
     Dlg.FMsg:=Msg;
     Dlg.Caption:=goSysInfo.ProgramInfo.Name; // ParamStr(0);

     If OldDesignerForm <> Nil {Reset the designer flag}
     Then Include(OldDesignerForm.ComponentState, csDesigning);

     Dlg.Execute;
     Dlg.Destroy;
End;

Procedure ShowMessagePos(Const Msg:String;X,Y:LongInt);
Var  Dlg:TMessageBox;
     OldDesignerForm:TForm;
Begin
     OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

     Dlg.Create(Screen.ActiveForm);
     Dlg.Width:=200;
     Dlg.Height:=200;
     Dlg.Left:=X;
     Dlg.Top:=Y;
     Dlg.FButtons:=[mbOk];
     Dlg.fType:=mtInformation;
     Dlg.FMsg:=Msg;
     Dlg.Caption:=goSysInfo.ProgramInfo.Name; // ParamStr(0);

     If OldDesignerForm <> Nil {Reset the designer flag}
     Then Include(OldDesignerForm.ComponentState, csDesigning);

     Dlg.Execute;
     Dlg.Destroy;
End;

Function CreateMessageDialog(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons):TForm;
Var Dlg:TMessageBox;
    OldDesignerForm:TForm;
Begin
    OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

    Dlg.Create(Screen.ActiveForm);
    Dlg.Width:=200;
    Dlg.Height:=200;
    Dlg.DlgType:=DlgType;
    Dlg.Buttons:=DlgButtons;
    Dlg.FMsg:=Msg;

    If OldDesignerForm <> Nil {Reset the designer flag}
      Then Include(OldDesignerForm.ComponentState, csDesigning);

    Result:=Dlg;
End;

Function MessageDlg(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext):TMsgDlgReturn;
Var Dlg:TMessageBox;
Begin
     Dlg:=TMessageBox(CreateMessageDialog(Msg,DlgType,DlgButtons));
     Dlg.HelpCtx:=HelpCtx;
     Dlg.Execute;
     Case Dlg.ModalResult Of
       cmOk:     Result:=mrOk;
       cmCancel: Result:=mrCancel;
       cmYes:    Result:=mrYes;
       cmNo:     Result:=mrNo;
       cmIgnore: Result:=mrIgnore;
       cmRetry:  Result:=mrRetry;
       cmAbort:  Result:=mrAbort;
       Else      Result:=mrCancel;
     End;
     Dlg.Destroy;
End;

Function MessageDlgPos(Const Msg:String;DlgType: TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext;
                       X,Y:LongInt):TMsgDlgReturn;
Var Dlg:TMessageBox;
Begin
     Dlg:=TMessageBox(CreateMessageDialog(Msg,DlgType,DlgButtons));
     Dlg.HelpCtx:=HelpCtx;
     Dlg.Left:=X;
     Dlg.Top:=Y;
     Dlg.Execute;
     Case Dlg.ModalResult Of
       cmOk:     Result:=mrOk;
       cmCancel: Result:=mrCancel;
       cmYes:    Result:=mrYes;
       cmNo:     Result:=mrNo;
       cmIgnore: Result:=mrIgnore;
       cmRetry:  Result:=mrRetry;
       cmAbort:  Result:=mrAbort;
       Else      Result:=mrCancel;
     End;
     Dlg.Destroy;
End;

Function InputBox(Const ACaption,APrompt,ADefault:String):String;
Begin
  Result:=ADefault;
  InputQuery(ACaption,APrompt,Result);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TDialog Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TDialog.SetupComponent;
Begin
  Inherited SetupComponent;

  SaveLoadInfo   := false;
  LanguageSupport:= false;      // Bei Dialogen sollte LoadNLSStr verwendet werden.
  XAlign         := xaCenter;
  YAlign         := yaCenter;
  PenColor       := clStaticText;
  Color          := clDlgWindow;
  ParentPenColor := False;
  ParentColor    := False;
  BorderIcons    := [biSystemMenu];
  BorderStyle    := bsDialog;
  Visible        := FALSE;

End;


Function TDialog.Execute:Boolean;
Begin
  ShowModal;
  Result := ModalResult In [cmOk,cmYes];
  DestroyHandle;
End;


{$IFDEF WIN32,OS2}
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TSystemOpenSaveDialog Class Implementation                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSystemOpenSaveDialog.SetupComponent;
Begin
  Inherited SetupComponent;

  FFileName := '';
  FDefaultExt := '';
  FFilter := '';
  FFilterIndex := 1;
  FMaskList.Create;
  FHelpContext := 0;
  HelpContextString := '';
  FInitialDir := '';
  {$ifdef win32}
  GetDir (0, FInitialDir);{Martin0308}
  {$endif}
End;


Destructor TSystemOpenSaveDialog.Destroy;
Begin
  Inherited Destroy;

  FMaskList.Destroy;
  FMaskList := Nil;
End;

{Martin0706}Procedure TSystemOpenSaveDialog.AddFilter(Name,Mask:String);
Begin
     If FFilter <> '' Then Name := '|' + Name;
     FFilter := FFilter + Name + '|' + Mask;
End;




{$IFDEF OS2}
Procedure SetupFilters(hFCB:Longword;SOSD:TSystemOpenSaveDialog);
Var  AMask,AFilter:String;
     S:String;
     cs:CString;
     P:Integer;
Begin
     If hFCB = 0 Then exit;
     If SOSD = Nil Then exit;

     WinSendMsg(hFCB,LM_DELETEALL,0,0);
     WinSetWindowText(hFCB,'');

     SOSD.FMaskList.Clear;

     S := SOSD.FFilter;
     P := Pos('|',S);
     While P > 0 Do
     Begin
          AFilter := Copy(S,1,P-1);
          Delete(S,1,P);
          P := Pos('|',S);
          If P > 0 Then
          Begin
               AMask := Copy(S,1,P-1);
               Delete(S,1,P);
          End
          Else
          Begin
               AMask := S;
               S := '';
          End;
          cs := AFilter;
          WinSendMsg(hFCB,LM_INSERTITEM,LIT_END,LongWord(@cs));
          SOSD.FMaskList.Add(AMask);
          P := Pos('|',S);
     End;
     WinSendMsg(hFCB,LM_SELECTITEM,SOSD.FilterIndex-1,1);
End;


Function GetMask(hFCB:Longword;SOSD:TSystemOpenSaveDialog):String;
Var  itp:LONGINT;
Begin
     Result := '';
     If hFCB = 0 Then exit;
     If SOSD = Nil Then exit;

     itp := WinSendMsg(hFCB,LM_QUERYSELECTION,MPFROMSHORT(LIT_FIRST),0);

     SOSD.FilterIndex := itp+1;      // TB 2005-07-11 remember FilterIndex

     If (itp >= 0) And (itp < SOSD.FMaskList.Count)
     Then Result := SOSD.FMaskList[itp]
End;

Function FileDlgWndProc(Win:HWindow;Msg:LONGWORD;Param1,Param2:LONGWORD):LONGWORD;CDECL;
Var  hFCB,hFNEd:HWindow;
     Ext:CString;
     DlgAdr:^FileDlg;
     SOSD:TSystemOpenSaveDialog;
Begin
     If (Msg = WM_INITDLG) Then
     Begin
          DlgAdr := Pointer(WinQueryWindowULong(Win,QWL_USER));
          SOSD := TSystemOpenSaveDialog (DlgAdr^.ulUser);
          hFCB := WinWindowFromId(Win,DID_FILTER_CB);
          hFNEd := WinWindowFromId(Win,DID_FILENAME_ED);
          // init the filter combobox
          SetupFilters(hFCB, SOSD);
     End;

     If (Msg = WM_CONTROL) And
        (Lo(param1) = DID_FILTER_CB) And (Hi(param1) = CBN_ENTER) Then
     Begin
          DlgAdr := Pointer(WinQueryWindowULong(Win,QWL_USER));
          SOSD := TSystemOpenSaveDialog (DlgAdr^.ulUser);
          hFCB := WinWindowFromId(Win,DID_FILTER_CB);
          hFNEd := WinWindowFromId(Win,DID_FILENAME_ED);
          // get selected extension
          Ext := GetMask(hFCB, SOSD);
          WinSetWindowText(hFNEd,Ext);
          WinSetFocus(HWND_DESKTOP,hFNEd);
          WinPostMsg(hFNEd, WM_CHAR, MPFROM2SHORT(KC_VIRTUALKEY,0),MPFROM2SHORT(0,VK_ENTER));
          FileDlgWndProc := 0;
          exit;
     End;

     FileDlgWndProc := WinDefFileDlgProc(Win, Msg, Param1, Param2);
End;
{$ENDIF}
{$ENDIF}

{$IFDEF WIN32,OS2}
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TSystemOpenDialog Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSystemOpenDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     FTitle := LoadNLSStr(SOpenAFile);
     FOkName := LoadNLSStr(SOpen);
End;


Function TSystemOpenDialog.Execute:Boolean;
Var  cTitle,cOKName:cstring;
     S,E:String;
     {$IFDEF OS2}
     Dlg:FileDlg;
     P:Integer;
     TempMaskList:TStringList;
     TempMask:String;
     {$ENDIF}
     {$IFDEF Win32}
     O:OPENFILENAME;
     cDefExt:cstring;
     cres:cstring;
     cfil:cstring;
     i,len:Integer;
     {$ENDIF}
Begin
     cTitle := FTitle;
     {Martin}
     S := FTitle;
     {$ifdef win32} strOEMtoANSI (S);{$endif}
     cTitle := S;
     cOKName := FOkName;
     {$IFDEF OS2}
     FillChar(Dlg,SizeOf(FileDlg),0); {Clear Dialog structure}

     Dlg.cbSize := SizeOf(FileDlg);
     Dlg.fl := FDS_OPEN_DIALOG | FDS_CENTER | FDS_ENABLEFILELB | FDS_FILTERUNION;
     Dlg.pszTitle := @cTitle;
     Dlg.pszOkButton := @cOKName;
     Dlg.szFullFile := FFileName;
     If {(FFileName = '') And} (FFilterIndex > 0) Then  // TB 2005-07-11 should also work with FileName
     Begin
          TempMaskList.Create;
          S := FFilter;
          P := Pos('|',S);
          While P > 0 Do
          Begin
               Delete(S,1,P);                   {Filter}
               P := Pos('|',S);
               If P > 0 Then
               Begin
                    TempMask := Copy(S,1,P-1);
                    Delete(S,1,P);              {Mask}
               End
               Else
               Begin
                    TempMask := S;
                    S := '';
               End;
               TempMaskList.Add(TempMask);
               P := Pos('|',S);
          End;

          If FFilterIndex <= TempMaskList.Count
          Then Dlg.szFullFile := TempMaskList[FFilterIndex-1];

          TempMaskList.Destroy;
     End;
     Dlg.ulUser := Longword(Self);
     Dlg.pfnDlgProc := @FileDlgWndProc;

     WinFileDlg(HWND_DESKTOP,HWND_DESKTOP,Dlg);
     Result := Dlg.lReturn = 1; {DID_OK}
     If Result Then FFileName := Dlg.szFullFile;
     {$ENDIF}

     {$IFDEF Win32}
     FillChar(O,SizeOf(OPENFILENAME),0); {Clear Dialog structure}

     O.lStructSize := SizeOf(OPENFILENAME);
     If Owner Is TControl Then O.hwndOwner := TControl(Owner).Handle
     Else O.hwndOwner := 0;
     cfil := FFilter;
     len := Length(cfil);
     cfil[len+1] := #0;     // second #0 terminator
     For i := 0 To len-1 Do
       If cfil[i] = '|' Then cfil[i] := #0;
     O.lpStrFilter := @cfil;
     O.nFilterIndex := FFilterIndex;
     O.lpStrTitle := @cTitle;
     cDefExt := FDefaultExt;
     O.lpstrDefExt := @cDefExt;
     O.Flags := OFN_PATHMUSTEXIST (*Or OFN_FILEMUSTEXIST*){Martin0207}
          {Martin0607}Or OFN_HIDEREADONLY
          {Martin0307}or OFN_NOCHANGEDIR;

     fFileName:=DeleteLastPathSeparator(fFileName);
     cres := FFileName;
     O.lpStrFile := @cres;
     O.nMaxFile := 254;
     O.hInstance := AppHandle;
     O.lpfnHook := nil;{Martin}
     Result := GetOpenFileName(O);
     If Result Then begin
       FFileName := O.lpStrFile^;
       FFilterIndex := O.nFilterIndex;    // TB 2005-07-11 remember FilterIndex
     end;
     {$ENDIF}
     If Result Then
     Begin
          FSplit(FFileName,S,S,E);
          If E = '' Then FFileName := FFileName + '.' + FDefaultExt;
     End;
End;
(*
{$ifdef win32}
const
  CDN_HELP : longint = -605;

procedure tSystemOpenSaveDialog.OFNHookProc(Win:HWND;Msg:ULONG;para1:WParam;para2:longint);
/*    hdlg :HWindow,  // handle to child dialog window
    uiMsg : ULONG, // message identifier
    WPARAM wParam,      // message parameter
    LPARAM lParam       // message parameter
   );*/
  begin
    if para2 =
       CDN_HELP then Application.HHelpContext (FHelpContext, FHelpContextString);
  end;
{$endif}
*)
{$ENDIF}

{$IFDEF WIN32,OS2}
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TSystemSaveDialog Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSystemSaveDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     FTitle := LoadNLSStr(SSaveFileAs);
     FOkName := LoadNLSStr(SSave);
End;


Function TSystemSaveDialog.Execute:Boolean;
Var  cTitle,cOKName:cstring;
     S,E:String;
     {$IFDEF OS2}
     Dlg:FileDlg;
     P:Integer;
     TempMaskList:TStringList;
     TempMask:String;
     {$ENDIF}
     {$IFDEF Win32}
     O:OPENFILENAME;
     cDefExt:cstring;
     cres:cstring;
     cfil:cstring;
     i,len:Integer;
     {$ENDIF}
Begin
     cTitle := FTitle;
     cOKName := FOkName;
     {$IFDEF OS2}
     FillChar(Dlg,SizeOf(FileDlg),0); {Clear Dialog structure}

     Dlg.cbSize := SizeOf(FileDlg);
     Dlg.fl := FDS_SAVEAS_DIALOG | FDS_CENTER | FDS_ENABLEFILELB;
     Dlg.pszTitle := @cTitle;
     Dlg.pszOkButton := @cOKName;
     Dlg.szFullFile := FFileName;
     If {(FFileName = '') And} (FFilterIndex > 0) Then  // TB 2005-07-11 should also work with FileName

     Begin
          TempMaskList.Create;
          S := FFilter;
          P := Pos('|',S);
          While P > 0 Do
          Begin
               Delete(S,1,P);                   {Filter}
               P := Pos('|',S);
               If P > 0 Then
               Begin
                    TempMask := Copy(S,1,P-1);
                    Delete(S,1,P);              {Mask}
               End
               Else
               Begin
                    TempMask := S;
                    S := '';
               End;
               TempMaskList.Add(TempMask);
               P := Pos('|',S);
          End;

          If FFilterIndex <= TempMaskList.Count
          Then Dlg.szFullFile := TempMaskList[FFilterIndex-1];

          TempMaskList.Destroy;
     End;
     Dlg.ulUser := Longword(Self);
     Dlg.pfnDlgProc := @FileDlgWndProc;

     WinFileDlg(HWND_DESKTOP,HWND_DESKTOP,Dlg);
     Result := Dlg.lReturn = 1; {DID_OK}
     If Result Then FFileName := Dlg.szFullFile;
     {$ENDIF}
     {$IFDEF Win32}
     FillChar(O,SizeOf(OPENFILENAME),0); {Clear Dialog structure}

     O.lStructSize := SizeOf(OPENFILENAME);
     If Owner Is TControl Then O.hwndOwner := TControl(Owner).Handle
     Else O.hwndOwner := 0;
     cfil := FFilter;
     len := Length(cfil);
     cfil[len+1] := #0;     // second #0 terminator
     For i := 0 To len-1 Do
       If cfil[i] = '|' Then cfil[i] := #0;
     O.lpStrFilter := @cfil;
     O.nFilterIndex := FFilterIndex;
     O.lpStrTitle := @cTitle;
     cDefExt := FDefaultExt;
     O.lpstrDefExt := @cDefExt;
     O.Flags := {Martin0607}OFN_HIDEREADONLY{checkbox} or OFN_NOCHANGEDIR{Martin0208};
     O.lpfnHook := nil;
     (*
     if (FHelpContext <> 0) or (FHelpContextString <> '') then begin
       O.Flags := O.Flags or OFN_SHOWHELP or OFN_ENABLEHOOK;
       O.lpfnHook := @OFNHookProc;
     end;
     *)
     fFileName:=DeleteLastPathSeparator(fFileName);
     cres := FFileName;
     O.lpStrFile := @cres;
     O.nMaxFile := 254;
     O.hInstance := AppHandle;
     Result := {Martin0607}GetSaveFileName(O);
     If Result Then begin
       FFileName := O.lpStrFile^;
       FFilterIndex := O.nFilterIndex;    // TB 2005-07-11 remember FilterIndex
     end;

     {$ENDIF}
     If Result Then
     Begin
          FSplit(FFileName,S,S,E);
          If E = '' Then FFileName := FFileName + '.' + FDefaultExt;
     End;
End;

{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TOpenDialog Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TOpenDialog.SetupComponent;
Begin
  Inherited SetupComponent;

  BorderStyle := bsSizeable;{Martin0206}
  ClientWidth := 470;
  ClientHeight := 370;
  FOkName := LoadNLSStr(SOpenButton);
  FTitle := LoadNLSStr(SOpenAFile);
  FFileName := '';
  FFilter := '';
  FFilterIndex := 1;
  FDefaultExt := '';
  fFiles.Create;
  fFiles.Duplicates:=dupError;

  FLabel1 := InsertLabel(Self,20,340,390,20,LoadNLSStr(SFilename)+':');
  FFileNameEdit := InsertEdit(Self,20,314,430,26,'',''); {oder Combo}

  FLabel2 := InsertLabel(Self,20,290,160,20,LoadNLSStr(SDrive)+':');
  FDriveCombo := InsertDriveComboBox(Self,20,264,170,26);

  FLabel3 := InsertLabel(Self,200,290,250,20,LoadNLSStr(SFileType)+':');
  FFilterCombo := InsertFilterComboBox(Self,200,264,250,26);
  FFilterCombo.OnItemSelect := FilterSelect;

  FLabel4 := InsertLabel(Self,20,240,160,20,LoadNLSStr(SDirectories)+':');
  FDirectoryList := InsertDirectoryListBox(Self,20,90,170,148);
  FDirectoryList.HorzScroll:= True;
  FDirectoryList.OnExit    := EvKillFocus;
  fDirectoryList.OnChange  := EvDirListChange;

  FLabel5 := InsertLabel(Self,200,240,250,20,LoadNLSStr(SFiles)+':');
  FFileList := InsertFileListBox(Self,200,90,250,148);
  FFileList.HorzScroll  := True;
  FFileList.OnChange    := FileChange;
  FFileList.OnItemSelect:= FileSelect;
  FFIleList.OnItemFocus := EvFileItemFocus;
  FFileList.OnExit      := EvKillFocus;
  fFileList.MultiSelect := false;

  FCurrentNamePanel := InsertPanel(Self,20,55,430,25,bvNone,bvLowered,1,'');
  FCurrentNamePanel.Alignment := taLeftJustify;
  FCurrentNamePanel.PenColor := clWindowText;

  FOkButton := InsertBitBtn(Self,20,15,100,30,bkOk,LoadNLSStr(SOpenButton),LoadNLSStr(SClickHereToAccept));
  FCancelButton := InsertBitBtn(Self,130,15,100,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
  HelpButton := InsertBitBtn(Self,350,15,100,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));

  {Connect}
  FDriveCombo.DirList := FDirectoryList;
  FFilterCombo.FileList := FFileList;
  FDirectoryList.FileList := FFileList;
  {FFileList.FileEdit := FFileNameEdit; See FileChange}

  SetCurDir(''); {Current dir}

  {Martin0206}
  FFileNameEditTop := FFileNameEdit.Top;
  FFilterComboTop := FFilterCombo.Top;
  FDriveComboTop := FDriveCombo.Top;
  FFileListTop := FFileList.Top;
  FLabel1Top := FLabel1.Top;
  FLabel2Top := FLabel2.Top;
  FLabel3Top := FLabel3.Top;
  FLabel4Top := FLabel4.Top;
  FLabel5Top := FLabel5.Top;
  ListDiff := ClientHeight - FDirectoryList.Height;
  Margin := 20;
  WidthDefault := Width;
  HeightDefault := Height;
  FileDirPart := 1.0 / ClientWidth * FFileList.Left;
  //Messagebox (tostr(ClientWidth) + ' ' + tostr(FFileList.Left), mtInformation, [mbOK]);
End;

procedure tOpenDialog.Resize;
  var
    middle : integer;
  begin
    inherited Resize;
    {Martin0206}
    if Width < WidthDefault then begin
      Width := WidthDefault; exit;
    end;
    if Height < HeightDefault then begin
      Height := HeightDefault; exit;
    end;
    FLabel1.Top := FLabel1Top;
    FLabel2.Top := FLabel2Top;
    FLabel3.Top := FLabel3Top;
    FLabel4.Top := FLabel4Top;
    FLabel5.Top := FLabel5Top;
    FDirectoryList.Height := ClientHeight - ListDiff;
    FFileList.Height := ClientHeight - ListDiff;
    //Caption := tostr(FileDirPart:0:0);
    middle := round(1.0 * FileDirPart * ClientWidth);
    FFileList.Left := middle;
    FFileList.Width := ClientWidth - Margin - middle;
    FFilterCombo.Width := ClientWidth - Margin - middle;
    FDirectoryList.Width := middle - 2*Margin;
    FDriveCombo.Width := middle - 2*Margin;
    FFilenameEdit.Width := ClientWidth - 2*Margin;
    FCurrentNamePanel.Width := ClientWidth - 2*Margin;
    FLabel3.Left := middle;
    FLabel5.Left := middle;
    FFilterCombo.Left := middle;
    HelpButton.Right := Margin;
    FFileNameEdit.Top := FFileNameEditTop;
    FFilterCombo.Top := FFilterComboTop;
    FDriveCombo.Top := FDriveComboTop;
    FFileList.Top := FFileListTop;
    FDirectoryList.Top := FFileListTop;
  end;

{Martin}
function TOpenDialog.Execute : boolean;
  {Problem: Bei Windows wird im OpenDialog C:\ angezeigt und nicht das aktuelle Verzeichnis, bei OS/2 ist es OK}
  {$IFDEF Win32}

var CurrentDir : string;
  {$ENDIF}
begin
  fFiles.Clear;
{$IFDEF Win32}
  getdir (0, CurrentDir);
{$ENDIF}
  result := inherited Execute;
{$IFDEF Win32}
  chdir (CurrentDir);
{$ENDIF}
end;

Procedure TOpenDialog.SetupShow;
Begin
     Inherited SetupShow;

     Caption := FTitle;
     FOkButton.Caption := FOkName;

     If FFilter <> '' Then FFilterCombo.Filter := FFilter;
     If FFilterIndex >= 1 Then
       if FFilterIndex {- 1} <= FFilterCombo.Items.Count {- 1} then  {Martin}
         FFilterCombo.ItemIndex := FFilterIndex - 1;
     SetFileName(FFileName);
     FileChange(Nil);

     {$IFDEF Win32}
     FFileList.SetWindowPos(200,90,250,148);
     {$ENDIF}

     FFileNameEdit.Focus;
     FOkButton.Default := True;
End;

Procedure TOpenDialog.DismissDlg(Result:TCommand);
Var  S,D,N,E,lw,dn:String;
     dismiss: Boolean;
     Status : Integer;
     Search : TSearchRec;
     pn     : Integer;
     FiInd  : LongInt;

Begin
  If Result = cmOk Then
  Begin
       {check If we can dismiss}
       S := FFileNameEdit.Caption;
       While S[Length(S)] = #32 Do Dec(S[0]);
       If S = '' Then
       Begin
            ModalResult := cmNull; {Reset}
            Exit;
       End;

       dismiss := True;
       {check If we MUST Change dir}
       S := ExpandPath(FCurDir,S);
       FSplit(S,D,N,E);
       pn := Pos('*',N);
       If (E = '') Or (pn <> 0) Then
       Begin {Test If we MUST Change Directory}
            lw := D+N;
            Delete(lw,1,1); {Test 'x:\'; FindFirst can't detect it}

            dn := D + N;
            If dn[Length(dn)] In ['\','/'] Then SetLength(dn,Length(dn)-1);

            Status := FindFirst(dn,faDirectory,Search);
            If (Status = 0) Or (lw = ':\') Or (lw = ':/') Then
            Begin
                 If pn <> 0 Then SetCurDir(D)
                 Else SetCurDir(D+N);

                 If pn = 0 Then {no wildcards}
                 Begin
                      FFileList.Directory := FCurDir; {?}
                      If E = '' Then FFileNameEdit.Caption := FFileList.Mask
                      Else FFileNameEdit.Caption := E; {???}
                      FFileNameEdit.SelectAll;
                      dismiss := False;
                 End;
            End;
            FindClose(Search);
       End;

       If pn <> 0 Then
       Begin
            FFileList.Directory := FCurDir; {?}
            FFileList.Mask := N + E;
            FFileNameEdit.Caption := FFileList.Mask;
            FFileNameEdit.SelectAll;
            dismiss := False;
       End;

       If Not dismiss Then
       Begin
            ModalResult := cmNull; {Reset}
            Exit;
       End;
  End;

  FFileName := GetFileName;
  FFilterIndex := FFilterCombo.ItemIndex + 1;

  if (fFileName<>'') and
     (fFiles.Find(fFileName, FiInd)=false) then
    fFiles.Add(fFileName);

  Inherited DismissDlg(Result);
End;


Procedure TOpenDialog.AddFilter(Name,Mask:String);
Begin
     If FFilter <> '' Then Name := '|' + Name;
     FFilter := FFilter + Name + '|' + Mask;
End;


{$HINTS OFF}
Procedure TOpenDialog.FileChange(Sender:TObject);
Var  S,D,N,E:String;
Begin
  {TFileListBox.Change}
  If ExtractFileName(FFileList.FileName) <> '' Then
    Begin
      FFileNameEdit.Caption := ExtractFileName(FFileList.FileName);
      FFileNameEdit.SelectAll;
    End; {Else the old FileName}

  FCurDir := FFileList.Directory;
  S := FCurDir + '\' + FFileNameEdit.Caption;
  If FDefaultExt <> '' Then
    Begin
      FSplit(S,D,N,E);
      If E = '' Then S := S + '.' + FDefaultExt;
    End;
  FCurrentNamePanel.Caption := S;
End;


Procedure TOpenDialog.FileSelect(Sender:TObject;Index:LongInt);
Begin
  FileChange(Sender);
  DismissDlg(cmOk);
End;

{Martin}
Procedure TOpenDialog.FilterSelect(Sender:TObject;Index:LongInt);
Var  D,N,E,actdir:String;
Begin
  if FilterIndex > 0 then begin
    FSplit(FFileNameEdit.Text,D,N,E);
    FFileNameEdit.Text :=  D + N + '.' + FileTypeExt[Index];
  end;
End;
{$HINTS ON}


Procedure TOpenDialog.SetFileName(Value:String);
Var  D,N,E,actdir:String;
Begin
  FSplit(Value,D,N,E);

  {$I-}
  GetDir(0,actdir);
  If Length(D) > 3 Then Dec(D[0]);

  ChDir(D);
  If InOutRes = 0 Then
  Begin
       SetCurDir(D);
       FFileList.Directory := FCurDir; {?}
  End;
  ChDir(actdir);
  {$I+}

  If N + E <> '' Then FFileNameEdit.Caption := N + e
  Else FFileNameEdit.Caption := FFileList.Mask;
End;


Function TOpenDialog.GetFileName:String;
Var  D,N,E:String;
Begin
  Result := FFileNameEdit.Caption;

  {Do not add the current directory if a drive is selected, e.g. A:TEXT.TXT}
  {Martin} if pos (':', Result) <> 2 then
    If Pos('\',Result) = 0 Then Result := FCurDir + '\' + Result;

  FSplit(Result,D,N,E);
  If E = '' Then If N<>'' Then Result := D + N + '.' + FDefaultExt;
End;


Procedure TOpenDialog.SetCurDir(Value:String);
Begin
  If Value = '' Then
  Begin
       {$I-}
       GetDir(0,FCurDir);
       {$I+}
  End
  Else FCurDir := Value;

  If FCurDir[Length(FCurDir)] In ['\','/'] Then Dec(FCurDir[0]);
  FCurrentNamePanel.Caption := FCurDir + '\' + FFileNameEdit.Caption;
End;

Function TOpenDialog.GetMultiSelect : Boolean;

Begin
  Result:=fFileList.MultiSelect;
End;

Procedure TOpenDialog.SetMultiSelect(Value : Boolean);

Begin
  fFileList.MultiSelect:=Value;
  fFileList.ExtendedSelect:=Value;
End;

{$HINTS OFF}
Procedure TOpenDialog.CMTextChanged(Var Msg:TMessage);
Begin
// FTitle := Caption;
// TB 2005-07-11 what should this line ?
// if it is executed the title of the dialog is overwritten
// by the name of the object
End;

{Martin}
  //           1................. 2...........3................
  //           1------------2-----3-------4---5-----------6----
  //Filter := 'Pascal files|*.PAS|C files|*.C|Basic files|*.BAS';
function tOpenDialog.GetFileTypeExt (Index:LongInt) : string;
  var
    SegSt : string;
    Seg, SegI, I, PosSeg : longint;
  begin
    Seg := (Index+1)*2; {Combobox counts from 0, FilterIndex from 1}
    SegI := 1; I := 1;
    while (I <= length(Filter)) and (SegI < Seg) do begin
      if Filter[I] = '|' then inc (SegI);
      inc (I);
    end;
    SegSt := copy (Filter, I+1, 199);
    I := pos ('|', SegSt); if I > 0 then delete (SegSt, I, 199);
    if (length(SegSt) > 0) and (SegSt[1] = '*') then delete (SegSt, 1, 1);
    if (length(SegSt) > 0) and (SegSt[1] = '.') then delete (SegSt, 1, 1);
    {if extension is *.HTML,*.HTM use the first one}
    posSeg := pos (SegSt, ','); if posSeg > 0 then delete (SegSt, posSeg, 199);
    posSeg := pos (SegSt, ';'); if posSeg > 0 then delete (SegSt, posSeg, 199);
    {make the extension in lowercase letters}
    for I := 1 to length(SegSt) do if (SegSt[I] >= 'A') and (SegSt[I] <= 'Z') then SegSt[I] := char(ord(SegSt[I])+32);
    result := SegSt;
  end;

function tOpenDialog.GetFileTypeName (Index:LongInt) : string;
  var
    SegSt : string;
    Seg, SegI, I, PosSeg : longint;
  begin
    Seg := (Index+1)*2 - 1;
    SegI := 1; I := 1;
    while (I <= length(Filter)) and (SegI < Seg) do begin
      if Filter[I] = '|' then inc (SegI);
      inc (I);
    end;
    SegSt := copy (Filter, I+1, 199);
    I := pos ('|', SegSt); if I > 0 then delete (SegSt, I, 199);
    result := SegSt;
  end;

Procedure TOpenDialog.EvDirListChange(Sender:TObject);

Begin
  fFiles.Clear;
End;

Procedure TOpenDialog.EvFileItemFocus(Sender:TObject;Index:LongInt);

Var FN   : tFilename;
    FiInd: LongInt;

Begin
  FN:=FCurDir+PathSeparator+fFileList.Items.Strings[Index];
  If fFiles.Find(FN, FiInd)
    Then fFiles.Delete(FiInd) // Die Selektion wurde entfernt
    else fFiles.Add(FN);      // Datei selktieren.
End;

Procedure TOpenDialog.EvKillFocus(Sender:TObject);
Begin
  If Sender Is TListBox Then TListBox(Sender).ItemIndex := -1;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TSaveDialog Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSaveDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     FOkName := LoadNLSStr(SSaveButton);
     FTitle := LoadNLSStr(SSaveFileAs);

     FFileNameEdit.Width := FFileNameEdit.Width - 30;

     FCreateButton := InsertSpeedButton(Self,450-25,314,25,25,0,'',
                                        LoadNLSStr(SCreateDirectory));
     FCreateButton.Kind := bkOpen;
     FCreateButton.Caption := '';
     FCreateButton.OnClick := EvCreateDir;

     {Martin0206}
     FCreateButtonTop := FCreateButton.Top;
End;

procedure tSaveDialog.Resize;
  begin
    inherited Resize;
    {Martin0206}
     FCreateButton.Top := FCreateButtonTop;
     FCreateButton.Right := Margin;
     FFilenameEdit.Width := ClientWidth - FCreateButton.Width - 2*Margin - 5;
  end;

{$HINTS OFF}
Procedure TSaveDialog.EvCreateDir(Sender:TObject);
Var  CreateDirDlg:TCreateDirDialog;
Begin
     CreateDirDlg.Create(Self);
     CreateDirDlg.Font:=Font;
     CreateDirDlg.Directory := FDirectoryList.Directory;
     If CreateDirDlg.Execute Then
     Begin
          If CreateDirDlg.ChangeDir
          Then FDirectoryList.Directory := CreateDirDlg.Directory
          Else FDirectoryList.Directory := FDirectoryList.Directory; {rebuild List}
     End;
     CreateDirDlg.Destroy;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TCreateDirDialog Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCreateDirDialog.SetupComponent;
Var  group:TGroupBox;
Begin
     Inherited SetupComponent;

     ClientWidth := 370;
     ClientHeight := 180;

     Caption := LoadNLSStr(SCreateDirectory);
     FOkName := LoadNLSStr(SCreateButton);
     FDirectory := '';

     group := InsertGroupBox(Self,20,60,330,100,LoadNLSStr(SEnterNewDirectory));
     FDirEdit := InsertEdit(group,15,45,300,26,'','');
     FChangeCheck := InsertCheckBox(group,15,15,300,20,LoadNLSStr(SChangeToTargetDir),'');

     FOkButton := InsertBitBtn(Self,20,15,100,30,bkOk,FOkName,LoadNLSStr(SClickHereToAccept));
     FCancelButton := InsertBitBtn(Self,130,15,100,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     HelpButton := InsertBitBtn(Self,240,15,100,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));
End;


Procedure TCreateDirDialog.SetupShow;
Begin
     Inherited SetupShow;

     If FDirectory = '' Then
     Begin
          {$I-}
          GetDir(0,FDirectory);
          {$I+}
          If FDirectory[Length(FDirectory)] In ['\','/']
          Then Dec(FDirectory[0]);
     End;

     FDirEdit.Text := FDirectory;
     FDirEdit.Focus;
     FDirEdit.SelectAll;
     FChangeCheck.Checked := FChangeDir;
     FOkButton.Caption := FOkName;
     FOkButton.Default := True;
End;


Function CreateDir(Init,dir:String):Boolean;
{$IFDEF OS2}
Const
  NoError = NO_ERROR;
  PathNotFound = ERROR_PATH_NOT_FOUND;
{$ENDIF}
{$IFDEF WIN32}
Const
  NoError = 0;
  PathNotFound = 3;
{$ENDIF}

  Procedure NormalizeDir(Var S:String);
  Begin
       If Length(S) > 3 Then
         If S[Length(S)] = '\' Then SetLength(S,Length(S)-1);
  End;

Var
  Name,ext,makedir,dir1:String;
  rc,P:LongWord;
Label err;
Begin
     Result := True;
     If Init = '' Then
     Begin
          {$I-}
          GetDir(0,Init);
          {$I+}
     End;
     NormalizeDir(dir);

     If Pos('\',dir) = 1 Then dir := Copy(Init,1,2) + dir;
     If Pos(':',dir) = 0 Then dir := Init + '\' + dir;
     NormalizeDir(dir);

     makedir := '';
     rc := PathNotFound;
     While rc <> NoError Do
     Begin
          {$I-}
          MkDir(dir);
          {$I+}
          rc := IOResult;
          If rc = PathNotFound Then
          Begin
               FSplit(dir,dir1,Name,ext);
               dir := dir1;
               NormalizeDir(dir);
               If dir[Length(dir)] = ':' Then Goto err;
               makedir := Name + '\' + makedir;
          End
          Else If rc <> NoError Then Goto err;
     End;

     While makedir <> '' Do
     Begin
          P := Pos('\',makedir);
          dir := dir + '\' + Copy(makedir,1,P-1);
          Delete(makedir,1,P);
          {$I-}
          MkDir(dir);
          {$I+}
          rc := IOResult;
          If rc <> NoError Then Goto err;
     End;
     Exit;
err:
     ErrorBox(LoadNLSStr(SError)+' [' + tostr(rc) + '] : '+LoadNLSStr(SCannotCreateDir)+' !');
     Result := False;
End;


Procedure TCreateDirDialog.DismissDlg(Result:TCommand);
Var  FInitDir:String;
Begin
     If Result = cmOk Then
     Begin
          FInitDir := FDirectory;  {Initial Directory from App}
          FDirectory := ExpandPath(FInitDir,FDirEdit.Text);
          FChangeDir := FChangeCheck.Checked;

          If CreateDir(FInitDir,FDirectory) Then
          Begin
               If FChangeDir Then
               Begin
                    {$I-}
                    ChDir(FDirectory);
                    {$I+}
               End;
          End
          Else
          Begin
               ModalResult := cmNull; {Reset}
               FDirEdit.CaptureFocus;
               Exit;
          End;
     End;

     Inherited DismissDlg(Result);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TChangeDirDialog Class Implementation                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TChangeDirDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     ClientWidth := 440;
     ClientHeight := 300;

     Caption := LoadNLSStr(SChangeDirectory);
     FOkName := LoadNLSStr(SChangeButton);
     InsertLabel(Self,20,265,270,20,LoadNLSStr(SDirectoryName)+':');
     FileNameEdit := InsertEdit(Self,20,240,270,26,'','');

     InsertLabel(Self,20,215,270,20,LoadNLSStr(SDrive)+':');
     FDriveCombo := InsertDriveComboBox(Self,20,185,270,26);

     InsertLabel(Self,20,160,270,20,LoadNLSStr(SDirectories)+':');
     {$IFDEF OS2}
     DirectoryList := InsertDirectoryListBox(Self,20,20,270,140);
     {$ENDIF}
     {$IFDEF WIN32}
     DirectoryList := InsertDirectoryListBox(Self,20,45{???},270,140);
     {$ENDIF}

     DirectoryList.OnChange := DirectoryChange;
     FDriveCombo.DirList := DirectoryList;

     FOkButton := InsertBitBtn(Self,315,240,105,30,bkOk,FOkName,LoadNLSStr(SClickHereToAccept));
     FOkButton.Margin := 10;
     FCancelButton := InsertBitBtn(Self,315,200,105,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     FCancelButton.Margin := 10;
     FCreateButton := InsertBitBtn(Self,315,160,105,30,bkOpen,LoadNLSStr(SCreateButton),LoadNLSStr(SClickHereToCreateADir));
     FCreateButton.Margin := 10;
     FCreateButton.ModalResult := 0; {dont Close the Dialog}
     FCreateButton.OnClick := EvCreateDir;
     HelpButton := InsertBitBtn(Self,315,120,105,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));
     HelpButton.Margin := 10;
End;


Procedure TChangeDirDialog.SetupShow;
Begin
     Inherited SetupShow;

     If FDirectory = '' Then
     Begin
          {$I-}
          GetDir(0,FDirectory);
          {$I+}
          If FDirectory[Length(FDirectory)] In ['\','/']
          Then Dec(FDirectory[0]);
     End;
     DirectoryList.Directory:=FDirectory;
     FileNameEdit.Caption:=FDirectory;

     FileNameEdit.Focus;
     FileNameEdit.SelectAll;
     FOkButton.Caption := FOkName;
     FOkButton.Default := True;
End;


{$HINTS OFF}
Procedure TChangeDirDialog.DirectoryChange(Sender:TObject);
Begin
     FileNameEdit.Caption := DirectoryList.Directory;
End;
{$HINTS ON}


Function TChangeDirDialog.Execute:Boolean;
Begin

     Result := Inherited Execute;
     If Result Then
     Begin
          FDirectory := ExpandPath(DirectoryList.Directory,FileNameEdit.Caption);

          If Length(FDirectory) > 3 Then
            If FDirectory[Length(FDirectory)] = '\'
            Then SetLength(FDirectory,Length(FDirectory)-1);
          {$I-}
          ChDir(FDirectory);
          {$I+}
     End;
End;

{$HINTS OFF}
Procedure TChangeDirDialog.EvCreateDir(Sender:TObject);
Var  CreateDirDlg:TCreateDirDialog;
Begin
     CreateDirDlg.Create(Self);
     CreateDirDlg.Directory := DirectoryList.Directory;
     CreateDirDlg.Font:=Font;
     If CreateDirDlg.Execute Then
     Begin
          If CreateDirDlg.ChangeDir
          Then DirectoryList.Directory := CreateDirDlg.Directory
          Else DirectoryList.Directory := DirectoryList.Directory; {rebuild List}
     End;
     CreateDirDlg.Destroy;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TFindDialog Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFindDialog.SetupComponent;   
Begin
  Inherited SetupComponent;

  Caption := LoadNLSStr(SFindText);
  ClientWidth := 430;
  ClientHeight := 310;

  Grp_Options := InsertGroupBox(Self,20,170,180,75,LoadNLSStr(SOptions));
  ChB_CaseSense := InsertCheckBox(Grp_Options,15,30,160,20,LoadNLSStr(SCaseSensitive),'');
  ChB_WordsOnly := InsertCheckBox(Grp_Options,15,10,160,20,LoadNLSStr(SWordsOnly),'');

  Grp_Scope := InsertGroupBox(Self,230,170,180,75,LoadNLSStr(SScope));
  RaB_Global := InsertRadioButton(Grp_Scope,15,30,160,20,LoadNLSStr(SGlobal),'');
  RaB_Selection := InsertRadioButton(Grp_Scope,15,10,160,20,LoadNLSStr(SSelectedText),'');

  Grp_Origin := InsertGroupBox(Self,20,70,180,75,LoadNLSStr(SOrigin));
  RaB_EntireScope := InsertRadioButton(Grp_Origin,15,30,160,20,LoadNLSStr(SEntireScope),'');
  RaB_Cursor := InsertRadioButton(Grp_Origin,15,10,160,20,LoadNLSStr(SFromCursor),'');

  Grp_Direction := InsertGroupBox(Self,230,70,180,75,LoadNLSStr(SDirection));
  RaB_Forward := InsertRadioButton(Grp_Direction,15,30,160,20,LoadNLSStr(SForwardButton),'');
  RaB_Backward := InsertRadioButton(Grp_Direction,15,10,160,20,LoadNLSStr(SBackwardButton),'');

  BiB_Find := InsertBitBtn(Self,20,20,90,30,bkOk,LoadNLSStr(SFindButton),LoadNLSStr(SClickHereToAccept));
  BiB_Cancel := InsertBitBtn(Self,130,20,100,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
  BiB_Help := InsertBitBtn(Self,320,20,90,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));

  Lab_Find := InsertLabel(Self,20,270,70,20,LoadNLSStr(SFind)+':');
  CoB_Find := InsertComboBox(Self,110,270,300,20,csDropDown);
End;


Procedure TFindDialog.SetupShow;
Begin
  Inherited SetupShow;
  CoB_Find.Focus;
  BiB_Find.Default := True;
End;


Function TFindDialog.GetFindOptions:TFindOptions;
Begin
  Result := [];
  If ChB_CaseSense.Checked Then Result := Result + [foCaseSensitive];
  If ChB_WordsOnly.Checked Then Result := Result + [foWordsOnly];
End;

Procedure TFindDialog.SetFindOptions(Value:TFindOptions);
Begin
  ChB_CaseSense.Checked := Value * [foCaseSensitive] <> [];
  ChB_WordsOnly.Checked := Value * [foWordsOnly] <> [];
End;

Function TFindDialog.GetFindOrigin:TFindOrigin;
Begin
  If RaB_EntireScope.Checked
    Then Result := foEntireScope
    Else Result := foCursor;
End;

Procedure TFindDialog.SetFindOrigin(Value:TFindOrigin);
Begin
  RaB_EntireScope.Checked := Value = foEntireScope;
  RaB_Cursor.Checked := Value = foCursor;
End;

Function TFindDialog.GetFindScope:TFindScope;
Begin
  If RaB_Global.Checked
    Then Result := fsGlobal
    Else Result := fsSelection;
End;

Procedure TFindDialog.SetFindScope(Value:TFindScope);
Begin
  RaB_Global.Checked := Value = fsGlobal;
  RaB_Selection.Checked := Value = fsSelection;
End;

Function TFindDialog.GetFindDirection:TFindDirection;
Begin
  If RaB_Forward.Checked
    Then Result := fdForward
    Else Result := fdBackward;
End;

Procedure TFindDialog.SetFindDirection(Value:TFindDirection);
Begin
  RaB_Forward.Checked := Value = fdForward;
  RaB_Backward.Checked := Value = fdBackward;
End;

Function TFindDialog.GetFindText:String;
Begin
  Result := CoB_Find.Caption;
End;

Procedure TFindDialog.SetFindText(Const Value:String);
Begin
  CoB_Find.Caption := Value;
End;

Procedure TFindDialog.SetFindTextExtend(Const Value:String);
Begin
  CoB_Find.TextExtension := Value;
  FFindTextExt := Value;
End;

Procedure TFindDialog.SetFindHistory(Const Strings:TStringList);
Begin
  CoB_Find.Items := Strings;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TReplaceDialog Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TReplaceDialog.SetupComponent;
Var  BiB_All:TBitBtn;
Begin
     Inherited SetupComponent;

     Caption := LoadNLSStr(SReplaceText);
     ClientWidth := 430;
     ClientHeight := 350;

     Lab_Find.Bottom := 310;
     CoB_Find.Bottom := 310;
     InsertLabel(Self,20,270,70,20,LoadNLSStr(SReplace)+':');
     CoB_Replace := InsertComboBox(Self,110,270,300,20,csDropDown);
     CoB_Replace.TabOrder := CoB_Find.TabOrder +1;

     Grp_Options.SetWindowPos(20,150,180,95);
     ChB_CaseSense.Bottom := 50;
     ChB_WordsOnly.Bottom := 30;
     ChB_Confirm := InsertCheckBox(Grp_Options,15,10,160,20,LoadNLSStr(SConfirmButton),'');
     ChB_Confirm.TabOrder := ChB_WordsOnly.TabOrder +1;

     BiB_Find.Width := 110;
     BiB_Find.Caption := LoadNLSStr(SReplaceButton);
     BiB_All := InsertBitBtn(Self,140,20,75,30,bkAll,LoadNLSStr(SAllButton),'');
     BiB_All.TabOrder := BiB_Find.TabOrder +1;
     BiB_Cancel.SetWindowPos(225,20,95,30);
     BiB_Help.SetWindowPos(330,20,80,30);
End;

Function TReplaceDialog.GetConfirm:Boolean;
Begin
     Result := ChB_Confirm.Checked;
End;

Procedure TReplaceDialog.SetConfirm(Value:Boolean);
Begin
     ChB_Confirm.Checked := Value;
End;

Function TReplaceDialog.GetReplaceText:String;
Begin
     Result := CoB_Replace.Caption;
End;

Procedure TReplaceDialog.SetReplaceText(Const Value:String);
Begin
     CoB_Replace.Caption := Value;
End;

Procedure TReplaceDialog.SetReplaceHistory(Const Strings:TStringList);
Begin
     CoB_Replace.Items := Strings;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TColorDialog Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TColorDialog.SetupComponent;
Var  T:LongInt;
     Btn:TBitBtn;
Begin
     Inherited SetupComponent;

     ClientWidth:=420;
     ClientHeight:=200;
     Caption:=LoadNLSStr(SSelectAColor);

     FRedScroll:=InsertScrollBar(Self,20,20,16,160,sbVertical);
     FRedScroll.color:=clRed;
     FRedScroll.SetScrollRange(0,255,1);
     FRedScroll.LargeChange:=8;
     FGreenScroll:=InsertScrollBar(Self,50,20,16,160,sbVertical);
     FGreenScroll.color:=clLime;
     FGreenScroll.SetScrollRange(0,255,1);
     FGreenScroll.LargeChange:=8;
     FBlueScroll:=InsertScrollBar(Self,80,20,16,160,sbVertical);
     FBlueScroll.color:=clBlue;
     FBlueScroll.SetScrollRange(0,255,1);
     FBlueScroll.LargeChange:=8;

     FDefaultCombo:=InsertComboBox(Self,120,160,150,20,csDropDownList);
     FDefaultCombo.Text:=LoadNLSStr(SDefaultColors);
     FDefaultCombo.sorted:=True;
     FDefaultCombo.DropDownCount := 7;
     FDefaultCombo.OnItemSelect:=EvSelectComboItem;
     For T:=1 To MaxDefaultColors
        Do FDefaultCombo.Items.Add(DefaultColors[T].Name);
     For T:=1 To MaxSystemColors
        Do FDefaultCombo.Items.Add(SystemColors[T].Name);

     FColorArea.Create(Self);
     FColorArea.SetWindowPos(120,20,150,120);
     FColorArea.BorderStyle:=bsSingle;
     FColorArea.BevelInner:=bvNone;
     FColorArea.BevelOuter:=bvNone;
     InsertControl(FColorArea);
     SetSelColor(FSelColor);

     FOkBtn := InsertBitBtn(Self,300,145,100,35,bkOk,LoadNLSStr(SSelectButton),LoadNLSStr(SClickHereToAccept));
     FOkBtn.Margin := 10;
     Btn := InsertBitBtn(Self,300,105,100,35,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     Btn.Margin := 10;
     Btn := InsertBitBtn(Self,300,65,100,35,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));
     Btn.Margin := 10;
End;


Procedure TColorDialog.SetupShow;
Begin
     Inherited SetupShow;

     FColorArea.Canvas.Brush.Mode := bmTransparent;

     FDefaultCombo.Focus;
     FOkBtn.Default := True;
End;


Procedure TColorDialog.SetSelColor(Value:TColor);
Begin
     FSelColor := SysColorToRGB(Value);
     FColorArea.color := FSelColor;
     FRedScroll.Position := TRGB(FSelColor).Red;
     FGreenScroll.Position := TRGB(FSelColor).Green;
     FBlueScroll.Position := TRGB(FSelColor).Blue;
     UpdateColorArea;
End;

{$HINTS OFF}
Procedure TColorDialog.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Begin
     TRGB(FSelColor).Fill:=0;
     If ScrollBar=FRedScroll Then TRGB(FSelColor).Red:=ScrollPos
     Else If ScrollBar=FGreenScroll Then TRGB(FSelColor).Green:=ScrollPos
     Else If ScrollBar=FBlueScroll Then TRGB(FSelColor).Blue:=ScrollPos;

     UpdateColorArea;
End;


Procedure TColorDialog.EvSelectComboItem(Sender:TObject;Index:LongInt);
Var S:String;
    Col:TColor;
    T:LongInt;
Label found;
Begin
     S:=FDefaultCombo.Text;

     For T:=1 To MaxDefaultColors Do
     Begin
          If DefaultColors[T].Name=S Then
          Begin
               FSelColor:=DefaultColors[T].Value;
               Goto found;
          End;
     End;

     For T:=1 To MaxSystemColors Do
     Begin
          If SystemColors[T].Name=S Then
          Begin
               FSelColor:=SystemColors[T].Value;
               break;
          End;
     End;
found:

     Col:=SysColorToRGB(FSelColor);
     FRedScroll.Position:=TRGB(Col).Red;
     FGreenScroll.Position:=TRGB(Col).Green;
     FBlueScroll.Position:=TRGB(Col).Blue;

     UpdateColorArea;
End;
{$HINTS ON}


Procedure TColorDialog.UpdateColorArea;
Var  Col:TColor;
     T:Longint;
Begin
     Col:=SysColorToRGB(FSelColor);
     FColorArea.PenColor := OppositeRGB(Col);
     FColorArea.Color := Col;
     FColorArea.Caption := 'RGB('+tostr(TRGB(Col).Red)+','
                                 +tostr(TRGB(Col).Green)+','
                                 +tostr(TRGB(Col).Blue)+')';

     For T:=1 To MaxDefaultColors Do
     Begin
          If SysColorToRGB(DefaultColors[T].Value)=Col Then
          Begin
               FDefaultCombo.Text := DefaultColors[T].Name;
               exit;
          End;
     End;

     For T:=1 To MaxSystemColors Do
     Begin
          If SysColorToRGB(SystemColors[T].Value)=Col Then
          Begin
               FDefaultCombo.Text := SystemColors[T].Name;
               exit;
          End;
     End;

     FDefaultCombo.Text := LoadNLSStr(SDefaultColors);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TFontDialog Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFontDialog.SetupComponent;
Var  T:LongInt;
     aFont:TFont;
     group:TGroupBox;
Begin
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SSelectAFont);
     Width:=400;
     Height:=330;
     color:=clLtGray;

     group:=InsertGroupBox(Self,5,5,280,Height-40,'');
     group.ZOrder:=zoBottom;

     InsertLabel(Self,12,270,80,20,LoadNLSStr(SName)+':');
     FNameCombo:=InsertComboBox(Self,12,250-100,200,120,csDropDownList);
     FNameCombo.sorted := True;
     FNameCombo.Duplicates:=False;
     FNameCombo.OnItemSelect:=EvComboSelect;

     InsertLabel(Self,218,270,50,20,LoadNLSStr(SSize)+':');
     FSizeCombo:=InsertComboBox(Self,218,250-100,60,120,csDropDown);
     FSizeCombo.OnItemSelect:=EvComboSizeSelect;
     FSizeCombo.Duplicates:=False;

     group:=InsertGroupBox(Self,12,150,110,90,LoadNLSStr(SStyle));
     group.ZOrder:=zoTop;
     FItalicCheck:=InsertCheckBox(Self,20,200,95,20,LoadNLSStr(SItalic),'');
     FItalicCheck.OnClick:=StyleChanged;
     FBoldCheck:=InsertCheckBox(Self,20,180,95,20,LoadNLSStr(SBold),'');
     FBoldCheck.OnClick:=StyleChanged;

     group:=InsertGroupBox(Self,127,150,150,90,LoadNLSStr(SEmphasis));
     group.ZOrder:=zoTop;
     FOutlineCheck:=InsertCheckBox(Self,135,200,135,20,LoadNLSStr(SOutline),'');
     FOutlineCheck.OnClick:=StyleChanged;
     FStrikeOutCheck:=InsertCheckBox(Self,135,180,135,20,LoadNLSStr(SStrikeout),'');
     FStrikeOutCheck.OnClick:=StyleChanged;
     FUnderscoreCheck:=InsertCheckBox(Self,135,160,135,20,LoadNLSStr(SUnderscore),'');
     FUnderscoreCheck.OnClick:=StyleChanged;

     FExampleText:=InsertButton(Self,10,20,270,120,LoadNLSStr(SExampleText),'');
     FExampleText.OnClick:=StyleChanged;

     FNameCombo.Listbox.Style:=lbStandard;
     For T:=0 To Screen.FontCount-1 Do
       Begin
         aFont:=Screen.Fonts[T];
         FNameCombo.Items.Add(aFont.FaceName);
       End;
     FNameCombo.Items.Add('System Default Font');

     FOkBtn := InsertBitBtn(Self,290,240,90,30,bkOk,LoadNLSStr(SOkButton),LoadNLSStr(SClickHereToAccept));
     InsertBitBtn(Self,290,200,90,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     InsertBitBtn(Self,290,160,90,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));

     SetFontName('');  {Init}
End;


Procedure TFontDialog.SetupShow;
Begin
     SetTheFont;

     Inherited SetupShow;

     FNameCombo.Focus;
     FOkBtn.Default := True;
End;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;
Begin
     Result:=FontName;
     UpcaseStr(FontName);
     If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',FontName)=0 Then Result:=Result+'.Italic';
     If Attrs*[faBold]<>[] Then If Pos(' BOLD',FontName)=0 Then Result:=Result+'.Bold';
     If Attrs*[faOutline]<>[] Then Result:=Result+'.Outline';
     If Attrs*[faStrikeOut]<>[] Then Result:=Result+'.Strikeout';
     If Attrs*[faUnderScore]<>[] Then Result:=Result+'.Underscore';
End;

Function TFontDialog.GetAttributes:TFontAttributes;
Var S:String;
Begin
     Result:=[];

     S:=FNameCombo.Caption;
     UpcaseStr(S);
     If FItalicCheck.Checked Then
       If Pos(' ITALIC',S)=0 Then Result:=Result+[faItalic];
     If FBoldCheck.Checked Then
       If Pos(' BOLD',S)=0 Then Result:=Result+[faBold];
     If FOutlineCheck.Checked Then Result:=Result+[faOutline];
     If FStrikeOutCheck.Checked Then Result:=Result+[faStrikeOut];
     If FUnderscoreCheck.Checked Then Result:=Result+[faUnderScore];
End;

Procedure TFontDialog.SetAttributes(NewValue:TFontAttributes);
Var S:String;
Begin
     S:=FNameCombo.Caption;
     S:=ModifyFontName(S,NewValue);
     If PointSize<>0 Then FontName:=tostr(PointSize)+'.'+s
     Else FontName:=S;
End;

Function TFontDialog.GetFaceName:String;
Begin
     Result:=FNameCombo.Caption;
     Result:=ModifyFontName(Result,Attributes);
End;

Procedure TFontDialog.SetFaceName(Value:String);
Var S:String;
Begin
     S:=Value;
     UpcaseStr(S);
     FBoldCheck.Checked:=FBoldCheck.Checked Or(Pos(' BOLD',S)<>0);
     FItalicCheck.Checked:=FItalicCheck.Checked Or(Pos(' ITALIC',S)<>0);
     Value:=ModifyFontName(Value,Attributes);
     If PointSize<>0 Then FontName:=tostr(PointSize)+'.'+Value
     Else FontName:=Value;
End;


Function TFontDialog.GetPointSize:LongInt;
Var S:String;
    C:Integer;
Begin
  If FNameCombo.Caption='System Default Font'
    Then Result:=Screen.DefaultFont.PointSize
    Else
      Begin
        S:=FSizeCombo.Caption;
        Val(S,Result,C);
        If C<>0 Then Result:=0;
      End;
End;


Procedure TFontDialog.SetPointSize(Value:LongInt);
Begin
  If Value=0 Then Value:=8;
  FontName:=tostr(Value)+'.'+FaceName;
End;


Function TFontDialog.GetEditFont:TFont;
Begin
     Result:=Screen.GetFontFromPointSize(FaceName,PointSize);
End;

Procedure TFontDialog.SetEditFont(NewFont:TFont);
Var S:String;
    Attrs:TFontAttributes;
Begin
     If NewFont=Nil Then NewFont:=Screen.DefaultFont;

     If NewFont.IsDefault Then
     Begin
          S:=tostr(Screen.DefaultFont.PointSize)+'.'+'System Default Font';;
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=False;
          FontName:=S;
     End
     Else
     Begin
          S:=NewFont.FaceName;
          UpcaseStr(S);
          Attrs:=NewFont.Attributes;
          FBoldCheck.Checked:=(Pos(' BOLD',S)<>0)Or(Attrs*[faBold]<>[]);
          FItalicCheck.Checked:=(Pos(' ITALIC',S)<>0)Or(Attrs*[faItalic]<>[]);
          S:=NewFont.FaceName;
          S:=ModifyFontName(S,NewFont.Attributes);
          If NewFont.PointSize<>0 Then FontName:=tostr(NewFont.PointSize)+'.'+s
          Else FontName:=S;
     End;
End;

{$HINTS OFF}
Procedure TFontDialog.StyleChanged(Sender:TObject);
Begin
     If Handle<>0 Then SetTheFont;
End;
{$HINTS ON}

Function TFontDialog.GetFontName:String;
Begin
  Result := tostr(PointSize) + '.' + FaceName;
End;


Procedure TFontDialog.SetFontName(Value:String);
Var  S,s1:String;
     DefPointSize,T:LongInt;
     B:Byte;
     C:Integer;
     Attrs:TFontAttributes;
Label L;
Begin
     If Value = '' Then Value := '8.Helv';
     B := Pos('.',Value);
     If B <> 0 Then
     Begin
          S := Copy(Value,1,B-1);
          Delete(Value,1,B);
          If Value='' Then Value:='Helv';
          Val(S,DefPointSize,C);
          If C <> 0 Then DefPointSize := 8;
     End
     Else DefPointSize := 8;

     Attrs:=[];
     S:=Value;
     UpcaseStr(S);
L:
     For T:=Length(S) DownTo 1 Do
     Begin
          If S[T]='.' Then
          Begin
               s1:=Copy(S,T+1,255);
               If ((s1='BOLD')Or(s1='ITALIC')Or(s1='UNDERSCORE')Or(s1='STRIKEOUT')Or
                   (s1='OUTLINE')) Then
               Begin
                    S[0]:=Chr(T-1);
                    Value[0]:=Chr(T-1);

                    If s1='BOLD' Then Attrs:=Attrs+[faBold]
                    Else If s1='ITALIC' Then Attrs:=Attrs+[faItalic]
                    Else If s1='UNDERSCORE' Then Attrs:=Attrs+[faUnderScore]
                    Else If s1='STRIKEOUT' Then Attrs:=Attrs+[faStrikeOut]
                    Else If s1='OUTLINE' Then Attrs:=Attrs+[faOutline];
               End;
          End;
     End;

     If Value='System Default Font' Then
     Begin
          FNameCombo.Caption := Value;
          FSizeCombo.Caption := tostr(Screen.DefaultFont.PointSize);
     End
     Else
     Begin
          For T := 0 To Screen.FontCount-1 Do If Screen.Fonts[T].FaceName = Value Then
          Begin
               FNameCombo.Caption := Value;
               FSizeCombo.Caption := tostr(DefPointSize);
               break;
          End;
     End;

     UpcaseStr(Value);
     FItalicCheck.Checked:=((Attrs*[faItalic]<>[])Or(Pos(' ITALIC',Value)<>0));
     FBoldCheck.Checked:=((Attrs*[faBold]<>[])Or(Pos(' BOLD',Value)<>0));

     FOutlineCheck.Checked:=Attrs*[faOutline]<>[];
     FUnderscoreCheck.Checked:=Attrs*[faUnderScore]<>[];
     FStrikeOutCheck.Checked:=Attrs*[faStrikeOut]<>[];

     If Handle<>0 Then SetTheFont;
End;


Procedure TFontDialog.SetTheFont;
{$IFDEF OS2}
Var  C:cstring;
{$ENDIF}
Var  Font:TFont;
     IsDefault:Boolean;
     S,Value:String;
     T:LongInt;
     B:Byte;
Label L;
Begin
     IsDefault:=False;
     S:=FNameCombo.Caption;
     If S='System Default Font' Then
     Begin
          FSizeCombo.Caption:=tostr(Screen.DefaultFont.PointSize);
          FSizeCombo.Enabled:=False;
          IsDefault:=True;
     End
     Else FSizeCombo.Enabled:=True;

     For T:=0 To Screen.FontCount-1 Do
     Begin
          Font:=Screen.Fonts[T];
          If Font.FaceName=S Then
          Begin
               If Font.FontType=ftBitmap Then
               Begin
                    FOutlineCheck.Checked:=False;
                    FOutlineCheck.Enabled:=False;
               End
               Else FOutlineCheck.Enabled:=Not IsDefault;
               Goto L;
          End;
     End;

     FOutlineCheck.Enabled:=Not IsDefault;
L:
     Value:=FNameCombo.Caption;
     UpcaseStr(Value);

     If Pos(' ITALIC',Value)<>0 Then
     Begin
          If Not FItalicCheck.Checked Then
          Begin
               B:=Pos(' ITALIC',Value);
               S:=FNameCombo.Caption;
               Delete(S,B,7);
               FNameCombo.Caption:=S;
          End;
          FItalicCheck.Enabled:=True;
     End
     Else FItalicCheck.Enabled:=Not IsDefault;

     If Pos(' BOLD',Value)<>0 Then
     Begin
          If Not FBoldCheck.Checked Then
          Begin
               B:=Pos(' BOLD',Value);
               S:=FNameCombo.Caption;
               Delete(S,B,5);
               FNameCombo.Caption:=S;
          End;
          FBoldCheck.Enabled:=True;
     End
     Else FBoldCheck.Enabled:=Not IsDefault;

     Value:=FNameCombo.Caption;
     UpcaseStr(Value);
     FItalicCheck.Checked:=FItalicCheck.Checked Or (Pos(' ITALIC',Value)<>0);
     FBoldCheck.Checked:=FBoldCheck.Checked Or (Pos(' BOLD',Value)<>0);

     FStrikeOutCheck.Enabled:=Not IsDefault;
     FUnderscoreCheck.Enabled:=Not IsDefault;

     Font:=Screen.GetFontFromPointSize(FaceName,PointSize);
     InsertSizes(Font);
     If Font<>Nil Then
     Begin
          Font:=Screen.CreateCompatibleFont(Font);
          Font.AutoDestroy:=True;
          FExampleText.Font:=Font;
          FNameCombo.Caption:=FExampleText.Font.FaceName;
          FSizeCombo.Caption:=tostr(FExampleText.Font.PointSize);
     End
     Else
     Begin
          {$IFDEF OS2}
          C := FontName;
          WinSetPresParam(FExampleText.Handle,PP_FONTNAMESIZE,Length(C)+1,C);
          {$ENDIF}
     End;
End;

Procedure TFontDialog.InsertSizes(Var TheFont:TFont);
Var  C,c1,c2,T,t1:LongInt;
     OldCaption:String;
     cc:Integer;
     CaptionUpdated:Boolean;
     OldFont:TFont;
Label weiter,found,TryThis;
{$IFDEF WIN32}
Label defSize;
{$ENDIF}
Begin
     OldCaption:=FSizeCombo.Caption;

     FSizeCombo.BeginUpdate;
     FSizeCombo.Clear;

     {$IFDEF WIN32}
     goto defSize;
     {$ENDIF}

     If TheFont=Nil Then
     Begin
{$IFDEF WIN32}
defsize:
{$ENDIF}
          C:=4;
          While C<48 Do
          Begin
               FSizeCombo.Items.Add(tostr(C));
               Inc(C,2);
          End;
     End
     Else
     Begin
          If TheFont.MinimumPointSize=TheFont.MaximumPointSize Then
          Begin
               CaptionUpdated:=False;
TryThis:
               For T:=0 To Screen.FontCount-1 Do
               Begin
                    If Screen.Fonts[T].FaceName=FNameCombo.Caption Then
                    Begin
                         c2:=Screen.Fonts[T].MinimumPointSize;
                         If c2<4 Then c2:=4;

                         While ((c2<48)And(c2<=Screen.Fonts[T].MaximumPointSize)) Do
                         Begin
                              C:=c2;

                              For t1:=0 To FSizeCombo.Items.Count-1 Do
                              Begin
                                   Val(FSizeCombo.Items[t1],c1,cc);
                                   If cc=0 Then
                                   Begin
                                       If c1<4 Then c1:=4;
                                       If c1=C Then Goto weiter;
                                       If c1>C Then
                                       Begin
                                           Goto found;
                                       End;
                                   End;
                              End;
                              t1:=FSizeCombo.Items.Count;
found:
                              FSizeCombo.Items.Insert(t1,tostr(C));
weiter:
                              If c2 And 1<>0 Then Inc(c2)
                              Else Inc(c2,2);
                         End; //While
                    End;
               End;

               If ((Not CaptionUpdated)And(FSizeCombo.Items.IndexOf(OldCaption)<0)) Then
               Begin
                    If ((TheFont.NominalPointSize<>0)And
                        (FSizeCombo.Items.IndexOf(tostr(TheFont.NominalPointSize))>=0)) Then
                      OldCaption:=tostr(TheFont.NominalPointSize)
                    Else If FSizeCombo.Items.Count>0 Then
                      OldCaption:=FSizeCombo.Items[0];
               End;
          End
          Else
          Begin
               C:=TheFont.MinimumPointSize;
               If C<4 Then C:=4;

               While ((C<48)And(C<=TheFont.MaximumPointSize)) Do
               Begin
                    FSizeCombo.Items.Add(tostr(C));
                    If C And 1<>0 Then Inc(C)
                    Else Inc(C,2);
               End;

               Val(OldCaption,c1,cc);
               If cc=0 Then
               Begin
                    If ((c1<TheFont.MinimumPointSize)Or(c1>TheFont.MaximumPointSize)) Then
                    Begin
                         If TheFont.NominalPointSize<>0 Then
                           OldCaption:=tostr(TheFont.NominalPointSize)
                         Else If FSizeCombo.Items.Count>0 Then
                           OldCaption:=FSizeCombo.Items[0];
                    End;
               End;
               CaptionUpdated:=True;
               Goto TryThis;
          End;
     End;

     FSizeCombo.Caption := OldCaption;
     FSizeCombo.EndUpdate;
     //recreate Font In Case that Size changed
     OldFont:=TheFont;
     TheFont:=Screen.GetFontFromPointSize(FaceName,PointSize);
     If TheFont=Nil Then TheFont:=OldFont;
End;


{$HINTS OFF}
Procedure TFontDialog.EvComboSelect(Sender:TObject;Index:LongInt);
Var S:String;
Begin
     S:=FNameCombo.Text;
     UpcaseStr(S);
     If Pos(' BOLD',S)<>0 Then
     Begin
          If Pos(' ITALIC',S)<>0 Then
          Begin
               FBoldCheck.Checked:=True;
               FItalicCheck.Checked:=True;
          End
          Else
          Begin
               FBoldCheck.Checked:=True;
               FItalicCheck.Checked:=False;
          End;
     End
     Else If Pos(' ITALIC',S)<>0 Then
     Begin
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=True;
     End
     Else
     Begin
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=False;
     End;

     SetTheFont;
End;


Procedure TFontDialog.EvComboSizeSelect(Sender:TObject;Index:LongInt);
Begin
  SetTheFont;
End;
{$HINTS ON}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPrintDialog Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TPrintDialog.Execute;
Begin
  FPrintAll.Checked := True;
  FPrinter.Checked := True;
  if Printer.PrinterIndex >0 then
    FPrinter.Caption := Printer.Printers [Printer.PrinterIndex];
  FNumberOfCopiesEdit.Caption := '1';
  FPrintFromEdit.Caption := IntToStr (FMinPage);
  FPrintToEdit.Caption := IntToStr (FMaxPage);
  FNumberOfCopies.Min := 1;
  FNumberOfCopies.Max := 9999;
  FTitle.Caption := Printer.Title;
  if Printer.Printers.Count =0 then
    Begin
      FPrintButton.Enabled   :=false;
      FPropertyButton.Enabled:=false;
    End;

  Result := Inherited Execute;
  If Result Then
    Begin
      Printer.Title := FTitle.Caption;
      If FFileOutPut.Checked
        Then
          Begin
            Printer.PrintToFile := True;
            Printer.FileName := FFile.Caption;
          End
        Else Printer.PrintToFile := False;
      If FPrintAll.Checked
        Then
          Begin
            FAllPages := True;
            FromPage := MinPage;
            ToPage := MaxPage;
          End
        Else
          Begin
            FAllPages := False;
            FromPage := StrToInt (FPrintFromEdit.Caption);
            ToPage := StrToInt (FPrintToEdit.Caption);
            MinPage := StrToInt (FPrintFromEdit.Caption);
            MaxPage := StrToInt (FPrintToEdit.Caption);
          End;
      Printer.copies := StrToInt (FNumberOfCopiesEdit.Caption);
    End;
End;

Procedure TPrintDialog.SetMinPage;
Begin
  FMinPage := NewValue;
  FFromPage := FMinPage;
  FPrintFrom.Min := FFromPage;
  FPrintTo.Min := FFromPage;
End;

Procedure TPrintDialog.SetMaxPage;
Begin
  FMaxPage := NewValue;
  FToPage := FMaxPage;
  FPrintFrom.Max := FToPage;
  FPrintTo.Max := FToPage;
End;

Procedure TPrintDialog.SetToPage;
Begin
  FToPage := NewValue;
  FPrintFrom.Max := FToPage;
  FPrintTo.Max := FToPage;
End;

Procedure TPrintDialog.SetFromPage;
Begin
  FFromPage := NewValue;
  FPrintFrom.Min := FFromPage;
  FPrintTo.Min := FFromPage;
End;

Procedure TPrintDialog.SetOkName;
Begin
  FPrintButton.Caption := NewName;
  FOkName := NewName;
End;

{$HINTS OFF}
Procedure TPrintDialog.PropertyBtnClicked;
Begin
  Printer.OptionsDlg;
End;
{$HINTS ON}

Procedure TPrintDialog.SetupComponent;
Begin
  Inherited SetupComponent;
  Name := 'PrintDialog';
  Caption := LoadNLSStr(SPrint);
  FOkName := LoadNLSStr(SPrintButton);
  Width := 500;
  Height := 330;
  FPrintButton := TBitBtn.Create (Self);
  FPrintButton.Kind := bkOk;
  FPrintButton.Margin := 10;
  FCancelButton := TBitBtn.Create (Self);
  FCancelButton.Kind := bkCancel;
  FCancelButton.Margin := 10;
  FPropertyButton := TBitBtn.Create (Self);
  FPropertyButton.Glyph.LoadFromResourceName('StdBmpProp');
  FPropertyButton.Kind := bkCustom;
  FPropertyButton.Margin := 10;
  HelpButton := TBitBtn.Create (Self);
  HelpButton.Kind := bkHelp;
  HelpButton.Command := cmHelp;
  HelpButton.Margin := 10;
  FTitleBox := TGroupBox.Create (Self);
  FTitle := TEdit.Create (Self);
  FPagesBox := TRadioGroup.Create (Self);
  FPrintFromLabel := TRadioButton.Create (Self);
  FPrintFromEdit := TEdit.Create (Self);
  FPrintFrom := TUpDown.Create (Self);
  FPrintToLabel := TLabel.Create (Self);
  FPrintToEdit := TEdit.Create (Self);
  FPrintTo := TUpDown.Create (Self);
  FPrintAll := TRadioButton.Create (Self);
  FOptionsBox := TRadioGroup.Create (Self);
  FPrinter := TRadioButton.Create (Self);
  FFileOutPut := TRadioButton.Create (Self);
  FFile := TEdit.Create (Self);
  FNumberOfCopiesLabel := TLabel.Create (Self);
  FNumberOfCopiesEdit := TEdit.Create (Self);
  FNumberOfCopies := TUpDown.Create (Self);
  FPrintButton.SetWindowPos (330, 250, 150, 30);
  FCancelButton.SetWindowPos (330, 210, 150, 30);
  FPropertyButton.SetWindowPos (330, 170, 150, 30);
  HelpButton.SetWindowPos (330, 15, 150, 30);
  FTitleBox.SetWindowPos (15, 230, 300, 60);
  FTitle.SetWindowPos (10, 13, 280, 20);
  FPagesBox.SetWindowPos (15, 140, 300, 85);
  FPrintFromLabel.SetWindowPos (10, 40, 70, 20);
  FPrintFromEdit.SetWindowPos (85, 37, 60, 20);
  FPrintFrom.SetWindowPos (145, 37, 21, 20);
  FPrintToLabel.SetWindowPos (175, 37, 30, 20);
  FPrintToLabel.PenColor := clBlack;
  FPrintToEdit.SetWindowPos (205, 37, 60, 20);
  FPrintTo.SetWindowPos (265, 37, 21, 20);
  FPrintAll.SetWindowPos (10, 15, 60, 20);
  FOptionsBox.SetWindowPos (15, 15, 300, 120);
  FPrinter.SetWindowPos (10, 75, 280, 20);
  FFileOutPut.SetWindowPos (10, 50, 50, 20);
  FFile.SetWindowPos (85, 48, 200, 20);
  FNumberOfCopiesLabel.SetWindowPos (12, 17, 60, 20);
  FNumberOfCopiesLabel.PenColor := clBlack;
  FNumberOfCopiesEdit.SetWindowPos (85, 15, 60, 20);
  FNumberOfCopies.SetWindowPos (145, 15, 21, 20);
  InsertControl (FPrintButton);
  InsertControl (FCancelButton);
  InsertControl (FPropertyButton);
  InsertControl (HelpButton);
  InsertControl (FTitleBox);
  FTitleBox.InsertControl (FTitle);
  InsertControl (FOptionsBox);
  FOptionsBox.InsertControl (FNumberOfCopiesLabel);
  FOptionsBox.InsertControl (FNumberOfCopies);
  FOptionsBox.InsertControl (FNumberOfCopiesEdit);
  InsertControl (FPagesBox);
  FPagesBox.InsertControl (FPrintFromLabel);
  FPagesBox.InsertControl (FPrintFrom);
  FPagesBox.InsertControl (FPrintFromEdit);
  FPagesBox.InsertControl (FPrintToLabel);
  FPagesBox.InsertControl (FPrintTo);
  FPagesBox.InsertControl (FPrintToEdit);
  FPagesBox.InsertControl (FPrintAll);
  FOptionsBox.InsertControl (FPrinter);
  FOptionsBox.InsertControl (FFileOutPut);
  FOptionsBox.InsertControl (FFile);
  FPrintButton.Caption := LoadNLSStr(SPrintButton);
  FCancelButton.Caption := LoadNLSStr(SCancelButton);
  FPropertyButton.Caption := LoadNLSStr(SProperties);
  HelpButton.Caption := LoadNLSStr(SHelpButton);
  FTitleBox.Caption := LoadNLSStr(STitle);
  FOptionsBox.Caption := LoadNLSStr(SOptions);
  FNumberOfCopiesLabel.Caption := LoadNLSStr(SCopies);
  FPagesBox.Caption := LoadNLSStr(SPages);
  FPrintFromLabel.Caption := LoadNLSStr(SFrom);
  FPrintToLabel.Caption := LoadNLSStr(STo);
  FPrintAll.Caption := LoadNLSStr(SAllButton);
  FOptionsBox.Caption := LoadNLSStr(SOptions);
  FFileOutPut.Caption := LoadNLSStr(SFile);
  FPrintFrom.Associate := FPrintFromEdit;
  FPrintTo.Associate := FPrintToEdit;
  FNumberOfCopies.Associate := FNumberOfCopiesEdit;
  FTitle.Caption := Printer.Title;
  FPropertyButton.OnClick := PropertyBtnClicked;
  FMaxPage := 1;
  FMinPage := 1;
  FFromPage := FMinPage;
  FToPage := FMaxPage;
  FPrintFrom.Min := FFromPage;
  FPrintFrom.Max := FToPage;
  FPrintTo.Min := FFromPage;
  FPrintTo.Max := FToPage;
  FPrintButton.Hint := LoadNLSStr(SClickHereToAccept);
  FCancelButton.Hint := LoadNLSStr(SClickHereToCancel);
  FPropertyButton.Hint := LoadNLSStr(SClickHereToSetProperties);
  HelpButton.Hint := LoadNLSStr(SClickHereToGetHelp);
  FNumberOfCopiesEdit.OnFontChange := UpdateSpinSize;
  FPrintFromEdit.OnFontChange := UpdateSpinSize;
  FPrintToEdit.OnFontChange := UpdateSpinSize;
  FPrintButton.Focus;
  FPrintButton.TabStop := True;
  FCancelButton.TabStop := True;
  FPropertyButton.TabStop := True;
  HelpButton.TabStop := True;
  FTitle.TabStop := True;
  FNumberOfCopiesEdit.TabStop := True;
  FPrintFromLabel.TabStop := True;
  FPrintFromEdit.TabStop := True;
  FTitleBox.TabStop := False;
  FOptionsBox.TabStop := False;
  FNumberOfCopiesLabel.TabStop := False;
  FNumberOfCopies.TabStop := False;
  FPagesBox.TabStop := False;
  FPrintFrom.TabStop := False;
  FPrintToLabel.TabStop := False;
  FPrintTo.TabStop := False;
  FPrintButton.TabOrder := 0;
  FCancelButton.TabOrder := 1;
  FPropertyButton.TabOrder := 2;
  HelpButton.TabOrder := 3;
  FTitle.TabOrder := 4;
  FPrintFromLabel.TabOrder := 5;
  FPrintFromEdit.TabOrder := 6;
  FPrintToEdit.TabOrder := 7;
  FPrintAll.TabOrder := 8;
  FPrinter.TabOrder := 9;
  FFileOutPut.TabOrder := 10;
  FFile.TabOrder := 11;
  FNumberOfCopiesEdit.TabOrder := 12;
End;

{$HINTS OFF}
Procedure TPrintDialog.UpdateSpinSize;
Begin
  FNumberOfCopies.Height := FNumberOfCopiesEdit.Height;
  FPrintFrom.Height := FPrintFromEdit.Height;
  FPrintTo.Height := FPrintToEdit.Height;
End;
{$HINTS ON}



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TPrinterSetupDialog Class Implementation                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$HINTS OFF}
Procedure TPrinterSetupDialog.PrinterSelected(Sender:TObject;Index:LongInt);
Begin
  Printer.PrinterIndex := FPrinterList.ItemIndex;
  DismissDlg (cmOk);
End;

Procedure TPrinterSetupDialog.PrinterFocused(Sender:TObject;Index:LongInt);
Begin
  Printer.PrinterIndex := FPrinterList.ItemIndex;
End;

Procedure TPrinterSetupDialog.PropertyBtnClicked(Sender:TObject);
Begin
  Printer.OptionsDlg;
End;
{$HINTS ON}

Procedure TPrinterSetupDialog.SetOkName;
Begin
  FSetPrinterButton.Caption := NewName;
  FOkName := NewName;
End;

Procedure TPrinterSetupDialog.SetupComponent;
Begin
  Inherited SetupComponent;
  Name := 'PrinterSetupDialog';
  Caption := LoadNLSStr(SSetupPrinter);
  FOkName := LoadNLSStr(SSetPrinter);
  Width := 450;
  Height := 285;
  color := clDlgWindow;
  FPrinterListHeadLine := TLabel.Create (Self);
  FPrinterList := TListBox.Create (Self);
  FSetPrinterButton := TBitBtn.Create (Self);
  FSetPrinterButton.Kind := bkOk;
  FSetPrinterButton.Margin := 10;
  FCancelButton := TBitBtn.Create (Self);
  FCancelButton.Kind := bkCancel;
  FCancelButton.Margin := 10;
  FPropertyButton := TBitBtn.Create (Self);
  FPropertyButton.ModalResult := cmNull;
  FPropertyButton.Glyph.LoadFromResourceName('StdBmpProp');
  FPropertyButton.Margin := 10;
  HelpButton := TBitBtn.Create (Self);
  HelpButton.Kind := bkHelp;
  HelpButton.Command := cmHelp;
  HelpButton.Margin := 10;
  FPrinterListHeadLine.SetWindowPos (15, 230, 250, 20);
  FPrinterList.SetWindowPos (15, 15, 250, 215);
  FSetPrinterButton.SetWindowPos (280, 200, 150, 30);
  FCancelButton.SetWindowPos (280, 160, 150, 30);
  FPropertyButton.SetWindowPos (280, 120, 150, 30);
  HelpButton.SetWindowPos (280, 15, 150, 30);
  InsertControl (FPrinterListHeadLine);
  InsertControl (FPrinterList);
  InsertControl (FSetPrinterButton);
  InsertControl (FCancelButton);
  InsertControl (FPropertyButton);
  InsertControl (HelpButton);
  FPropertyButton.OnClick := PropertyBtnClicked;
  FPrinterList.OnItemSelect := PrinterSelected;
  FPrinterList.OnItemFocus := PrinterFocused;
  FPrinterListHeadLine.Caption := LoadNLSStr(SCurrentPrinter)+':';
  FSetPrinterButton.Caption := LoadNLSStr(SSetPrinter);
  FCancelButton.Caption := LoadNLSStr(SCancelButton);
  FPropertyButton.Caption := LoadNLSStr(SProperties);
  FSetPrinterButton.Hint := LoadNLSStr(SClickHereToAccept);
  FPropertyButton.Hint := LoadNLSStr(SClickHereToSetProperties);
  FCancelButton.Hint := LoadNLSStr(SClickHereToCancel);
  HelpButton.Hint := LoadNLSStr(SClickHereToGetHelp);
  FPrinterListHeadLine.TabStop := False;
  FPrinterList.TabStop := True;
  FSetPrinterButton.TabStop := True;
  FPropertyButton.TabStop := True;
  FCancelButton.TabStop := True;
  HelpButton.TabStop := True;
  FPrinterList.TabOrder := 1;
  FSetPrinterButton.TabOrder := 2;
  FCancelButton.TabOrder := 3;
  FPropertyButton.TabOrder := 4;
  HelpButton.TabOrder := 5;
  FSetPrinterButton.Focus;
End;

Function TPrinterSetupDialog.Execute;
Begin
  FPrinterList.Items := Printer.Printers;
  FOldPrinterIndex := Printer.PrinterIndex;
  FPrinterList.ItemIndex := FOldPrinterIndex;
  Result := Inherited Execute;
  If Not Result Then
    Printer.PrinterIndex := FOldPrinterIndex;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TMessageBox Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMessageBox.SetupComponent;
Begin
     Inherited SetupComponent;

     FButtons:=[mbOk];
     fType:=mtInformation;
     Caption:='';
End;

Procedure TMessageBox.SetupShow;
Const SButtonNames:Array[mbYes..mbHelp] Of String[15]=
          (
           '~Yes','~No','~Ok','~Cancel','~Abort','~Retry','~Ignore','~All','~Help'
          );
      SButtonKinds:Array[mbYes..mbHelp] Of TBitBtnKind=
          (
           bkYes,bkNo,bkOk,bkCancel,bkAbort,bkRetry,bkIgnore,bkAll,bkHelp
          );
Var  FLabel:TLabel;
     CX,CY:LongInt;
     LabelX:LongInt;
     BtnX:LongInt;
     tw:LongInt;
     PictureY:LongWord;
     ButtonNames:Array[1..10] Of String[15];
     ButtonKinds:Array[1..10] Of TBitBtnKind;
     ButtonCount,T:LongInt;
     Btn:TBitBtn;
     Counter:TMsgDlgBtn;
     MaxWidth,W:LongInt;
Begin
  Inherited SetupShow;

  SButtonNames[mbYes]:=LoadNLSStr(SYesButton);
  SButtonNames[mbNo]:=LoadNLSStr(SNoButton);
  SButtonNames[mbOk]:=LoadNLSStr(SOkButton);
  SButtonNames[mbCancel]:=LoadNLSStr(SCancelButton);
  SButtonNames[mbAbort]:=LoadNLSStr(SAbortButton);
  SButtonNames[mbRetry]:=LoadNLSStr(SRetryButton);
  SButtonNames[mbIgnore]:=LoadNLSStr(SIgnoreButton);
  SButtonNames[mbAll]:=LoadNLSStr(SAllButton);
  SButtonNames[mbHelp]:=LoadNLSStr(SHelpButton);

  //check Single Buttons. only the following values are Valid And can be or'ed
  //mbYes,mbNo,mbOk,mbCancel,mbHelp,mbAbort.mbRetry,mbIgnore,mbAll
  //All Buttons are invisible
  MaxWidth:=340;
  W:=0;
  ButtonCount:=0;

  For Counter:=mbYes To mbHelp Do
  Begin
       If Counter IN FButtons Then
       Begin
            Inc(ButtonCount);
            ButtonNames[ButtonCount]:=SButtonNames[Counter];
            ButtonKinds[ButtonCount]:=SButtonKinds[Counter];

            Inc(W, Canvas.TextWidth(ButtonNames[ButtonCount]) + 20);
            If ShowBitBtnGlyph Then Inc(W, 25);

            If W > MaxWidth Then
            Begin
                 If W > Screen.Width-50 Then break;
                 MaxWidth := W;
            End;
       End;
  End;

  LabelX := 20;
  If fType<>mtCustom Then Inc(LabelX,32);

  FLabel := InsertLabel(Self,LabelX,60,MaxWidth,20,FMsg);
  FLabel.WordWrap := True;
  FLabel.ShowAccelChar := False;
  FLabel.Height := FLabel.Canvas.Font.Height * FLabel.Rows;

  PictureY := FLabel.Bottom + FLabel.Height - 32;

  CX := LabelX + MaxWidth + 25;
  CY := 10 + 30 + 20 + FLabel.Height + 45;

  {Center Box}
  SetWindowPos(Left,Bottom,CX,CY);

  If fType<>mtCustom Then
  Begin
       If fType=mtConfirmation Then InsertImageName(Self,10,PictureY,32,32,'StdBmpAsk')
       Else If fType In [mtError,mtCritical,mtWarning] Then InsertImageName(Self,10,PictureY,32,32,'StdBmpHand')
       Else InsertImageName(Self,10,PictureY,32,32,'StdBmpInfo');
  End;

  If Caption='' Then  //overwrite Default
  Begin
      If fType=mtWarning Then Caption:=LoadNLSStr(SWarning)
      Else If fType=mtInformation Then Caption:=LoadNLSStr(sInformation)
      Else If fType=mtConfirmation Then Caption:=LoadNLSStr(SConfirmation)
      Else If fType=mtCritical Then Caption:=LoadNLSStr(SCriticalError)
      Else If fType=mtError Then Caption:=LoadNLSStr(SError)
      Else If fType=mtCustom Then Caption:=goSysInfo.ProgramInfo.Name // ParamStr(0)
      Else Caption:=LoadNLSStr(sInformation);
  End;

  //Create the Buttons
  BtnX := 10;
  For T := 1 To ButtonCount Do
    Begin
      tw := Canvas.TextWidth(ButtonNames[T]) + 20;
      If ShowBitBtnGlyph Then Inc(tw, 25);
      Btn := InsertBitBtn(Self,BtnX,10,tw,30,ButtonKinds[T],ButtonNames[T],'');
      Inc(BtnX, tw + 10);
      If T=1 Then Btn.Focus;
    End;
  HelpContext := FHelpCtx;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TInfoDialog Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tInfoDialog.SetupComponent;
{ wird ausgefuehrt, wenn das Objekt erstellt wird }

Var DlgFont: TFontDialog;
    Pos    : LongInt;

Begin
  Inherited SetupComponent;
  Icon:=Application.Icon;
  Height:=200;
  Width:=400;
  Caption:=LoadNlsStr(SInformation);
  Color := clDlgWindow;

  DlgFont.Create(Self);
{ Text: Programmname }
  DlgFont.FaceName:='Times New Roman Bold Italic';
  DlgFont.PointSize:=20;
  Pos:=ClientHeight-DlgFont.EditFont.Height;
  FProgramName:=InsertLabel
         (Self,0,Pos,ClientWidth,DlgFont.EditFont.Height,Application.ProgramName);
  FProgramName.Font:=dlgFont.EditFont;
  FProgramName.PenColor:=clBlack;
  FProgramName.Alignment:=taCenter;
  FProgramName.Hint:=LoadNlsStr(SProgram) + ' Name';

{ Text: Version }
  DlgFont.FaceName:='Times New Roman';
  DlgFont.PointSize:=10;
  Pos:=Pos-DlgFont.EditFont.Height;
  FProgramVersion:=InsertLabel
         (Self,0,Pos,ClientWidth,DlgFont.EditFont.Height, 'Version: ' + tostr(Application.ProgramVersion) + '.' + tostr(Application.ProgramSubVersion));
  FProgramVersion.Font:=dlgFont.EditFont;
  FProgramVersion.PenColor:=clBlack;
  FProgramVersion.Alignment:=taCenter;
  FProgramVersion.Hint:=LoadNlsStr(SProgram) + ' ' + LoadNlsStr(SVersion);

{ Text: Pfadnamen }
  Pos:=Pos-DlgFont.EditFont.Height;
  FProgramPath:=InsertLabel
         (Self,0,Pos,ClientWidth,DlgFont.EditFont.Height,Application.ProgramPath);
  FProgramPath.Font:=dlgFont.EditFont;
  FProgramPath.PenColor:=clBlack;
  FProgramPath.Alignment:=taLeftJustify;
  FProgramPath.Hint:=LoadNlsStr(SProgram) + ' ' + LoadNlsStr(SPath);

{ Text: Datum }
  Pos:=Pos-DlgFont.EditFont.Height;
  FProgramDate:=InsertLabel
         (Self,0,Pos,ClientWidth,DlgFont.EditFont.Height,'@' + DateToStr(Application.ProgramDate));
  FProgramDate.PenColor:=clBlack;
  FProgramDate.Alignment:=taRightJustify;
  FProgramDate.HInt:=LoadNlsStr(SProgram) + ' ' + LoadNlsStr(SDate);

{ Button: OK }

  FOkButton:=InsertBitBtn(Self,Round(ClientWidth/2)-50,10,100,30,bkOk,LoadNLSStr(SOKButton),LoadNLSStr(SClickHereToAccept));
  dlgFont.destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TUserPassworDialog Class Implementation                     บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tUserPasswordDialog.SetInfoText(iValue : String);

Begin
  fInfoText:=iValue;
  fLblInfoText.Caption:=fInfoText;
End;

Procedure tUserPasswordDialog.SetUser(iValue : String);

Begin
  fedUser.Text:=iValue;
End;

Procedure tUserPasswordDialog.SetPassword(iValue : String);

Begin
  fedPassword.Text:=iValue;
End;

Function tUserPasswordDialog.GetUser : String;

Begin
  Result:=fedUser.Text;
End;

Function tUserPasswordDialog.GetPassword : String;

Begin
  Result:=fedPassword.Text;
End;

Procedure tUserPasswordDialog.SetupComponent;
{ wird ausgefuehrt, wenn das Objekt erstellt wird }

Begin
  Inherited SetupComponent;
  Height:= 180;
  Width := 350;
  Caption:=LoadNlsStr(SUser) + ' / '+LoadNlsStr(SPassword);
  Color := clDlgWindow;

  fLblInfoText:=InsertLabel(Self, 10, 120, 300, 20, fInfoText);
  fLblInfoText.PenColor:=clBlack;
  fLblUser    :=InsertLabel(Self, 10, 90,  70, 20, LoadNlsStr(SUser));
  fLblUser.PenColor:=clBlack;
  fLblPassword:=InsertLabel(Self, 10, 60,  70, 20, LoadNlsStr(SPassword) + ':');
  fLblPassword.PenColor:=clBlack;
  fedUser     :=InsertEdit(Self, 90, 90, 200, 20, '', LoadNlsStr(SUser));
  fedPassword :=InsertEdit(Self, 90, 60, 200, 20, '', LoadNlsStr(SPassword));
  fedPassword.Unreadable:=true;

  fOkCancelButton:=InsertOKCancelButton(Self, 30, 10);

End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes                                        บ
บ                                                                           บ
บ This section: tInputQueryDialog Class Implementation                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tInputQueryDialog.SetupComponent;

Begin
  Inherited SetupComponent;
  ClientWidth:=355;
  ClientHeight:=130;

  InsertBitBtn(Self,20,10,90,30,bkOk,LoadNLSStr(SOkButton),'');
  InsertBitBtn(Self,120,10,90,30,bkCancel,LoadNLSStr(SCancelButton),'');
  fLblPrompt:=InsertLabel(Self,20,90,310,20,fPrompt);
  fEdit:=InsertEdit(Self,20,60,310,20,'','');
End;

Procedure tInputQueryDialog.SetupShow;

Begin
  inherited SetupShow;

  flblPrompt.Text:=fPrompt;
  fEdit.Text:=fValue;
  fEdit.Focus;
End;

Procedure tInputQueryDialog.DismissDlg(Result:TCommand);

Begin
  If Result = cmOk Then
    fValue:=fEdit.Text;

  Inherited DismissDlg(Result);
End;

Function InputQuery(Const ACaption,APrompt:String;Var Value:String):Boolean;

Var Dlg : tInputQueryDialog;
    OldDesignerForm:TForm;

Begin
  OldDesignerForm := Nil;
  If Screen.ActiveForm <> Nil Then
    If Screen.ActiveForm.Designed Then
      Begin {Clear the designer flag To Assign the correct Font}
        OldDesignerForm := Screen.ActiveForm;
        Exclude(OldDesignerForm.ComponentState, csDesigning);
      End;
  Dlg.Create(Screen.ActiveForm);
  Dlg.Caption:=ACaption;
  Dlg.Prompt:=APrompt;
  Dlg.Value:=Value;
  Dlg.Execute;
  case Dlg.ModalResult of
    cmOk: Begin
            Value:=Dlg.Value;
            Result:=True;
          End;
    Else Result:=False;
  End; {Case}
  Dlg.Destroy;
End;



Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02   WD        Ausbau der LINUX-Teile
  20-Mar-03   WD        Einbau der tInfoDialog
  08-Aug-04   MV        fHelpButton moved from private to public HelpButton
                            (to enable HelpButton.Visible := false)
                        bei A:TEXT.TXT in OpenDialog nicht Verzeichnis anfgen
                        Bei OpenDialog.Execute war als Default bei Windows nicht das aktuelle Verzeichnis
                        Bei ChangeDirDialog DirectoryList und FilenameEdit von Private nach Public
  17-Apr-05   WD        TPrintDialog: Buttons "Print" und "Properties" deaktivieren,
                            wenn es kein Drucker im System existiert.
  11-Jul-05   TB        Diverse korrketuren an TSystemOpenDialog, TSystemSaveDialog usw.
  26-Jul-05   WD        Dialogs: SaveLoadInfo als Default auf False setzen.
  26-Jul-05   MV        tOpenDialog: if another file type is selected, the file extension
                        gets changed automatically
  18-Sep-05   WD        Dialog: User-Password eingebaut
  19-Feb-06   MV        tOpenDialog: resizable window
  09-Mar-06   WD        Paramstr(0) durch uSysInfo ersetzt.
  29-Jul-06   MV/WD     tOpenSystemDialog.Execute und tSaveSystemDialog.Execute: Entfernen des letzten PathSeparators.
  06-Okt-06   WD        tInputQueryDialog: Klasse neu programmiert und Funktion InputQuery angepasst
  27-Feb-08   MV        TSystemSaveDialog.Execute:Boolean: oFlag fr Vista umgebaut.
  15-Mar-08   MV        TSystemOpenSaveDialog.SetupComponent: Korrekte Befllung von FInitialDir
}
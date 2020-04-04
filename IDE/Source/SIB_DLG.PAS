
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Visual Development Environment                                 บ
 บ                                                                          บ
 บ     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Sibyl Integrated Development Environment (IDE)                           บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
 บ                                                                          บ
 บ This program is free software; you can redistribute it and/or modify it  บ
 บ under the terms of the GNU General Public License (GPL) as published by  บ
 บ the Free Software Foundation; either version 2 of the License, or (at    บ
 บ your option) any later version. This program is distributed in the hope  บ
 บ that it will be useful, but WITHOUT ANY WARRANTY; without even the       บ
 บ implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR          บ
 บ PURPOSE.                                                                 บ
 บ See the GNU General Public License for more details. You should have     บ
 บ received a copy of the GNU General Public License along with this        บ
 บ program; if not, write to the Free Software Foundation, Inc., 59 Temple  บ
 บ Place - Suite 330, Boston, MA 02111-1307, USA.                           บ
 บ                                                                          บ
 บ In summary the original copyright holders (SpeedSoft) grant you the      บ
 บ right to:                                                                บ
 บ                                                                          บ
 บ - Freely modify and publish the sources provided that your modification  บ
 บ   is entirely free and you also make the modified source code available  บ
 บ   to all for free (except a fee for disk/CD production etc).             บ
 บ                                                                          บ
 บ - Adapt the sources to other platforms and make the result available     บ
 บ   for free.                                                              บ
 บ                                                                          บ
 บ Under this licence you are not allowed to:                               บ
 บ                                                                          บ
 บ - Create a commercial product on whatever platform that is based on the  บ
 บ   whole or parts of the sources covered by the license agreement. The    บ
 บ   entire program or development environment must also be published       บ
 บ   under the GNU General Public License as entirely free.                 บ
 บ                                                                          บ
 บ - Remove any of the copyright comments in the source files.              บ
 บ                                                                          บ
 บ - Disclosure any content of the source files or use parts of the source  บ
 บ   files to create commercial products. You always must make available    บ
 บ   all source files whether modified or not.                              บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

UNIT SIB_DLG;
{ Unit fuer diverse Dialoge }

INTERFACE

USES SysUtils,Dos,Color,Classes,Forms,Graphics,Buttons,StdCtrls,ExtCtrls,TabCtrls,
     uSysInfo, uSysClass, uString, uList,
     Messages, Menus,
     Dialogs,Outline,Printers,IniFiles,DockTool,ComCtrls,Grids,
     uConvert;

Uses Consts,Sib_Ctrl,Projects,Sib_Prj,Form_Gen,Editors,Sib_Edit,
     Inspect,BaseForm,BaseEdit,DualList,ColorGrd,CheckLB,EditList,
     DebugHlp,DAsm, Dfm, Compiler, FormEdit;

{$IFDEF OS2}
USES BseDos,BseErr;
{$ENDIF}

{$IFDEF WIN32}
Uses WinUser;
{$ENDIF}

// PROCEDURE AboutDialog;
PROCEDURE Call_AboutDialog;

PROCEDURE SlidingUndoDialog;
PROCEDURE BookmarksDialog;
PROCEDURE ProjectDialog;
PROCEDURE GeneralDialog;
PROCEDURE CustomizeDialog;
PROCEDURE InitProjectManager;
PROCEDURE GotoLineDialog;
PROCEDURE RunParamDialog;
PROCEDURE NewProjectDialog;
PROCEDURE ToolOptionDialog;
PROCEDURE PrintDialog;
PROCEDURE LanguageSettingsDialog;
PROCEDURE ToolbarsDialog;
PROCEDURE FindInFilesDialog(CONST s,x:STRING);

TYPE PVDELanguageList=^TVDELanguageList;
     TVDELanguageList=RECORD
        Name:STRING[64];
        Active:BOOLEAN;
        TableLen:LONGWORD;
        Table:POINTER;
        Next:PVDELanguageList;
     END;

PROCEDURE DestroyVDELanguageList(VAR List:PVDELanguageList);
PROCEDURE WriteVDELanguageList(List:PVDELanguageList);
FUNCTION ReadVDELanguageList(ShowError:BOOLEAN):PVDELanguageList;

CONST ProjectManager:TForm=NIL;

IMPLEMENTATION

{$IFDEF OS2}
uses pmwin;
{$ENDIF}

PROCEDURE Call_AboutDialog;

var info : tInfoAboutDialog;

Begin
  info.HelpContext:= hctxDialogAbout;
  info.Caption    := LoadNLSStr(SiProductInformation);
  info.VPDTool    := LoadNLSStr(SiVisualPascalDevelopmentTool);
  AboutDialog(Info);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Sliding Undo Dialog                                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TSlidingUndoDialog=CLASS(TDialog)
       Slider:TScrollbar;
       PosText:TLabel;
       LastPos:LONGINT;
       Edit:TSibEditor;
       PROCEDURE SetupComponent;OVERRIDE;
       PROCEDURE EvScroll(Sender:TObject;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
     END;


PROCEDURE TSlidingUndoDialog.SetupComponent;
VAR  sh:LONGINT;
     Text:TLabel;
BEGIN
  Inherited SetupComponent;

  ClientWidth := 300;
  Height := 150;
  Caption := LoadNLSStr(SiSlidingUndo);
  Edit := CodeEditor.TopEditor;
  LastPos := CodeEditor.TopEditor.UndoCount;
  Text := InsertLabel(SELF,15,90,60,20,LoadNLSStr(SiFirst));
  Text.AutoSize := FALSE;
  Text.Alignment := taLeftJustify;
  Text := InsertLabel(SELF,225,90,60,20,LoadNLSStr(SiLast));
  Text.AutoSize := FALSE;
  Text.Alignment := taRightJustify;
  PosText := InsertLabel(SELF,120,90,60,20,tostr(LastPos));
  PosText.AutoSize := FALSE;
  PosText.Alignment := taCenter;
  sh := goSysInfo.Screen.HScrollSize;
  Slider := InsertScrollbar(SELF,10,56,280,sh,sbHorizontal);
  Slider.SetScrollRange(0,LastPos,1);
  Slider.Position := LastPos;
  Slider.OnScroll := EvScroll;
  InsertBitBtnNLS(SELF,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(SELF,105,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
  InsertBitBtnNLS(SELF,200,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


{$HINTS OFF}
PROCEDURE TSlidingUndoDialog.EvScroll(Sender:TObject;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
BEGIN
  IF ScrollPos = LastPos THEN exit;

  Edit.BeginUpdate;
  IF LastPos < ScrollPos
    THEN WHILE Edit.UndoCount < ScrollPos DO Edit.Redo
    ELSE WHILE Edit.UndoCount > ScrollPos DO Edit.Undo;
  Edit.EndUpdate;

  LastPos := Edit.UndoCount;
  PosText.Caption := tostr(LastPos);
  {Slider.Position := LastPos;}
  ScrollPos := LastPos;
END;
{$HINTS ON}


PROCEDURE SlidingUndoDialog;
VAR  Dialog:TSlidingUndoDialog;
     OldOptions:TEditOpt;
     InitCount:LONGINT;
     TopEdit:TSibEditor;
BEGIN
  TopEdit := CodeEditor.TopEditor;
  IF TopEdit = NIL THEN exit;
  IF TopEdit.UndoCount = 0 THEN exit;
  InitCount := TopEdit.UndoCount;
  OldOptions := TopEdit.EditOptions;
  TopEdit.EditOptions := OldOptions - [eoUndoGroups];

  Dialog.Create(Application.MainForm);
  Dialog.HelpContext := hctxDialogSlidingUndo;
  Dialog.ShowModal;
  IF Dialog.ModalResult = cmCancel THEN
    BEGIN
      TopEdit.BeginUpdate;
      WHILE TopEdit.UndoCount < InitCount DO
        TopEdit.Redo;
      TopEdit.EndUpdate;
    END;
  Dialog.Destroy;
  CodeEditor.TopEditor.EditOptions := OldOptions;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Bookmarks Dialog                                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TBookmarkDialog=CLASS(TDialog)
         List:TListBox;
         AddBtn,RmvBtn:TSpeedButton;
         NameEdit,FileEdit,LineEdit:TEdit;
         Browse,Current:TSpeedButton;
         GotoBtn,CloseBtn,HelpBtn:TBitBtn;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE ListItemFocused(Sender:TObject;Index:LONGINT);
         PROCEDURE ListItemSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE InsertBlankItem(Sender:TObject);
         PROCEDURE RemoveListItem(Sender:TObject);
         PROCEDURE BrowseFileName(Sender:TObject);
         PROCEDURE TakeCurrentPosition(Sender:TObject);
         PROCEDURE WriteBackToList(Sender:TObject);
    END;


PROCEDURE TBookmarkDialog.SetupComponent;
VAR  i:LONGINT;
     s:STRING;
BEGIN
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiBookmarks);
  ClientWidth := 380;
  Height := 370;

  List := InsertListBox(SELF,20,155,210,165,'');
  List.OnItemFocus := ListItemFocused;
  List.OnItemSelect := ListItemSelected;
  List.Focus;
  FOR i := 0 TO Project.BookmarkList.Count-1 DO
    BEGIN
      s := GetShortHint(Project.BookmarkList.Strings[i]);
      List.Items.Add(s);
    END;

  AddBtn := InsertSpeedButtonNLS(SELF,20,130,105,25, 0,SiAdd,0);
  AddBtn.TabStop := FALSE;
  AddBtn.OnClick := InsertBlankItem;
  RmvBtn := InsertSpeedButtonNLS(SELF,125,130,105,25, 0,SiRemove,0);
  RmvBtn.Enabled := Project.BookmarkList.Count > 0;
  RmvBtn.TabStop := FALSE;
  RmvBtn.OnClick := RemoveListItem;

  InsertLabel(SELF,20,85,60,22,LoadNLSStr(SiName));
  NameEdit := InsertEdit(SELF,80,90,260,22,'','');
  NameEdit.Enabled := Project.BookmarkList.Count > 0;
  NameEdit.AutoSize := TRUE;
  NameEdit.OnExit := WriteBackToList;

  InsertLabel(SELF,20,50,60,22,LoadNLSStr(SiFile));
  FileEdit := InsertEdit(SELF,80,55,200,22,'','');
  FileEdit.Enabled := Project.BookmarkList.Count > 0;
  FileEdit.OnExit := WriteBackToList;

  Browse := InsertSpeedButtonNLS(SELF,280,55,60,FileEdit.Height, 0,SiBrowse,0);
  Browse.Enabled := ToolsList.Count > 0;
  Browse.TabStop := FALSE;
  Browse.OnClick := BrowseFileName;

  InsertLabel(SELF,20,15,60,22,LoadNLSStr(SiLine));
  LineEdit := InsertEdit(SELF,80,20,70,22,'','');
  LineEdit.Enabled := Project.BookmarkList.Count > 0;
  LineEdit.AutoSize := TRUE;
  LineEdit.OnExit := WriteBackToList;

  Current := InsertSpeedButtonNLS(SELF,150,20,190,25, 0,SiCurrentEditorPos,0);
  Current.Enabled := CodeEditor.TopEditor <> NIL;
  Current.TabStop := FALSE;
  Current.OnClick := TakeCurrentPosition;

  GotoBtn := InsertBitBtnNLS(SELF,250,290,110,30,bkOk,SiGoto,0);
  GotoBtn.Enabled := Project.BookmarkList.Count > 0;
  IF IdeSettings.ShowBitBtnGlyph THEN GotoBtn.Margin := 10;
  CloseBtn := InsertBitBtnNLS(SELF,250,250,110,30,bkClose,SiClose,0);
  IF IdeSettings.ShowBitBtnGlyph THEN CloseBtn.Margin := 10;
  CloseBtn.Cancel := TRUE;
  HelpBtn := InsertBitBtnNLS(SELF,250,210,110,30,bkHelp,SHelpButton,0);
  IF IdeSettings.ShowBitBtnGlyph THEN HelpBtn.Margin := 10;
END;


PROCEDURE TBookmarkDialog.SetupShow;
BEGIN
  Inherited SetupShow;
  IF List.Items.Count > 0 THEN List.ItemIndex := 0;
END;


{$HINTS OFF}
PROCEDURE TBookmarkDialog.ListItemFocused(Sender:TObject;Index:LONGINT);
BEGIN
  IF Index < 0 THEN exit;
  NameEdit.Caption := GetShortHint(Project.BookmarkList.Strings[Index]);
  FileEdit.Caption := GetLongHint(Project.BookmarkList.Strings[Index]);
  LineEdit.Caption := tostr(LONGINT(Project.BookmarkList.Objects[Index]));
  GotoBtn.Enabled := TRUE;
END;


PROCEDURE TBookmarkDialog.ListItemSelected(Sender:TObject;Index:LONGINT);
BEGIN
     GotoBtn.Click;
END;


PROCEDURE TBookmarkDialog.InsertBlankItem(Sender:TObject);
BEGIN
  Project.BookmarkList.Add(LoadNLSStr(SiNew)+'|');
  List.ItemIndex := List.Items.Add(LoadNLSStr(SiNew));
  NameEdit.Focus;

  RmvBtn.Enabled := TRUE;
  NameEdit.Enabled := TRUE;
  FileEdit.Enabled := TRUE;
  Browse.Enabled := TRUE;
  LineEdit.Enabled := TRUE;
END;


PROCEDURE TBookmarkDialog.RemoveListItem(Sender:TObject);
VAR  i:LONGINT;
BEGIN
  i := List.ItemIndex;
  IF (i < 0) OR (i >= List.Items.Count) THEN exit;
  Project.BookmarkList.Delete(i);
  List.Items.Delete(i);
  List.Focus;
  IF i >= List.Items.Count THEN i := List.Items.Count-1;
  IF i < 0 THEN
  BEGIN
       NameEdit.Caption := '';
       FileEdit.Caption := '';
       LineEdit.Caption := '';
  END
  ELSE List.ItemIndex := i;

  RmvBtn.Enabled := List.Items.Count > 0;
  NameEdit.Enabled := List.Items.Count > 0;
  FileEdit.Enabled := List.Items.Count > 0;
  Browse.Enabled := List.Items.Count > 0;
  LineEdit.Enabled := List.Items.Count > 0;
END;


PROCEDURE TBookmarkDialog.BrowseFileName(Sender:TObject);
VAR  d,n,e:STRING;
{$ifdef OS2}
     CFOD:TOpenDialog;
{$endif}
{$ifdef Win32}
     CFOD:TSystemOpenDialog;
{$endif}

BEGIN
  CFOD.Create(SELF);
  CFOD.HelpContext := hctxDialogBrowseBookmarkFileName;
  CFOD.Caption := LoadNLSStr(SiSelectAFile);
  CFOD.OkName := LoadNLSStr(SiSelect);
  SetFileDialogTypes(CFOD);
  FSplit(FileEdit.Caption,d,n,e);
  IF e = '' THEN e := EXT_UC_PASCAL; // '.PAS';
  CFOD.DefaultExt := GetDefaultExt('*'+ e);
  CFOD.FileName := FileEdit.Caption;
  IF CFOD.Execute THEN
    BEGIN
      FileEdit.Caption := CFOD.FileName;
      WriteBackToList(NIL);
    END;
  CFOD.Destroy;
  Screen.Update;
  FileEdit.CaptureFocus;
END;


PROCEDURE TBookmarkDialog.TakeCurrentPosition(Sender:TObject);
VAR  TopEdit:TSibEditor;
     fc:TEditorPos;
BEGIN
  TopEdit := CodeEditor.TopEditor;
  IF TopEdit = NIL THEN exit;
  FileEdit.Caption := TopEdit.FileName;
  fc := TopEdit.CursorPos;
  LineEdit.Caption := tostr(fc.Y);
  WriteBackToList(NIL);
END;


PROCEDURE TBookmarkDialog.WriteBackToList(Sender:TObject);
VAR  s:STRING;
     i,j:LONGINT;
     c:INTEGER;
BEGIN
  i := List.ItemIndex;
  IF (i < 0) OR (i >= List.Items.Count) THEN exit;
  s := NameEdit.Caption + '|' + FileEdit.Caption;
  val(LineEdit.Caption,j,c);
  IF c <> 0 THEN j := 0;
  Project.BookmarkList.Strings[i] := s;
  Project.BookmarkList.Objects[i] := TObject(j);
  List.Items.Strings[i] := NameEdit.Caption;
END;
{$HINTS ON}


PROCEDURE BookmarksDialog;
VAR  Dialog:TBookmarkDialog;
     s:STRING;
     c:INTEGER;
     fc:TEditorPos;
BEGIN
  Dialog.Create(NIL);
  Dialog.HelpContext := hctxDialogBookmarks;
  IF Dialog.Execute THEN
    BEGIN
      s := Dialog.FileEdit.Text;
      fc.X := 1;
      val(Dialog.LineEdit.Text,fc.Y,c);
      IF c <> 0 THEN fc.Y := 1;
      IF LoadEditor(s,0,0,0,0,TRUE,fc,Fokus,ShowIt) = NIL
        THEN ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[s]));
    END;
  Dialog.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Project Settings Dialog                                     บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TProjectDialog=CLASS(TDialog)
      PRIVATE
         LastHintControl:TControl;
         TempSettings:TProjectSettings;
         Modified,SCUModified,NeedRecompile:BOOLEAN;
         Notebook:TTabbedNotebook;
         CompPage,WarnPage,LinkPage,DebugPage,DirPage,FormPage,ApplicationPage:TPage;
         SaveStdBtn:TBitBtn;
         DirCombo:TComboBox;
         DirList:TEditListBox;
         GUIRadio,FullScreenRadio,WindowRadio:TRadioButton;
         ExePackNoneRadio,ExePack1Radio,ExePack2Radio:TRadioButton;
         DataSegCheck:TCheckBox;
         RunVDMCheck:TCheckBox;
         HeapEdit,StackEdit:TEdit;
         PlatformCombo:TComboBox;
         AsmSrcCheck,InlineCheck,AssertCheck,SaveConstCheck,StrictVarCheck,CompleteBoolCheck:TCheckBox;
         OptimizeCommonSubCheck,OptimizePeepholeCheck:TCheckBox;
         IOCheck,OverflowCheck,StackCheck,RangeCheck:TCheckBox;
         CondEdit:TEdit;
         DebugInfoCheck,LocalSymCheck,BubblesCheck:TCheckBox;
         ShowAnsiRefCheck:TCheckBox;
         RTLLab, SPCCLab, AppIconFilename, AppIconTyp, AppComplib :TLabel;
         RTLExceptions,SPCCExceptions:TCheckListBox;
         W1Check,W2Check,W3Check,W4Check,W5Check,W6Check,W7Check:TCheckBox;
         WAllRadio,WSelRadio,WNoneRadio:TRadioButton;
         WarnCountEdit,ErrCountEdit:TEdit;
         MainFormCombo:TComboBox;
         AutoCreate:TDualList;
         ApplicationIcon:TImage;
         TheApplicationIcon:STRING;
         PROCEDURE SetMouseHint(Control:TControl;AHint:LONGINT);
         PROCEDURE EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
         PROCEDURE EvPageChanged(Sender:TObject);
         PROCEDURE EvModified(Sender:TObject);
         PROCEDURE EvNeedRecompile(Sender:TObject);
         PROCEDURE EvDebugInfo(Sender:TObject);
         PROCEDURE EvPlatformSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE EvEnableWarnings(Sender:TObject);
         PROCEDURE EvDisableWarnings(Sender:TObject);
         PROCEDURE EvDebugSetupShow(Sender:TObject);
         PROCEDURE EvSaveAsStandard(Sender:TObject);
         PROCEDURE EvAutoCreateChange(Sender:TObject);
         PROCEDURE EvMainFormSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE SetupCompilerPage;
         PROCEDURE InitCompilerPage;
         PROCEDURE StoreCompilerPage;
         PROCEDURE SetupWarningsPage;
         PROCEDURE InitWarningsPage;
         PROCEDURE StoreWarningsPage;
         PROCEDURE SetupLinkerPage;
         PROCEDURE InitLinkerPage;
         PROCEDURE StoreLinkerPage;
         PROCEDURE SetupDebuggerPage;
         PROCEDURE InitDebuggerPage;
         PROCEDURE StoreDebuggerPage;
         PROCEDURE InitDirectoriesPage;
         PROCEDURE StoreDirectoriesPage;
         PROCEDURE SetupDirectoriesPage;
         PROCEDURE SetEditDirectory(ed:TEditDir;WriteBack:BOOLEAN);
         PROCEDURE WriteBackEditDirectory(ed:TEditDir);
         PROCEDURE EvBrowseDir(Sender:TObject;VAR dir:STRING);
         PROCEDURE EvDirSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE EvIconSelect(Sender:TObject);
         PROCEDURE InitFormsPage;
         PROCEDURE StoreFormsPage;
         PROCEDURE InitApplicationPage;
         PROCEDURE SetupApplicationPage;
         PROCEDURE StoreApplicationPage;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE DismissDlg(Result:TCommand);OVERRIDE;
    END;



PROCEDURE TProjectDialog.SetupComponent;
BEGIN
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiProjectSettings);
  ClientWidth := 580;
  ClientHeight := 420;

  TempSettings := Project.Settings;
  Modified := FALSE;
  SCUModified := FALSE;
  NeedRecompile := FALSE;

  Notebook := InsertTabbedNotebook(SELF,0,50,580,370);
  Notebook.Align := alTop;
  Notebook.Pages.Clear;
  Notebook.OnPageChanged := EvPageChanged;

  InsertBitBtnNLS(SELF,20,10,100,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(SELF,135,10,100,30,bkCancel,SCancelButton,SClickHereToCancel);
  SaveStdBtn := InsertBitBtnNLS(SELF,250,10,190,30,bkCustom,SiSavePageAsStandard,SiSavePageAsStandardHint);
  SaveStdBtn.ModalResult := cmNull;
  SaveStdBtn.Glyph.LoadFromResourceId(1100);
  SaveStdBtn.OnClick := EvSaveAsStandard;
  InsertBitBtnNLS(SELF,460,10,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);

  InitCompilerPage;
  InitWarningsPage;
  InitLinkerPage;
  InitDebuggerPage;
  InitDirectoriesPage;
  InitFormsPage;
  InitApplicationPage;

  Notebook.PageIndex := ActiveProjectPage;
  Notebook.AutoPopup := TRUE;
END;


PROCEDURE TProjectDialog.SetMouseHint(Control:TControl;AHint:LONGINT);
BEGIN
  Control.ParentShowHint := FALSE;
  Control.ShowHint := FALSE;
  Control.Hint := LoadNLSStr(AHint);
  Control.OnMouseMove := EvMouseHint;
END;


{$HINTS OFF}
PROCEDURE TProjectDialog.EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
BEGIN
  IF Sender IS TControl THEN
  BEGIN
       Notebook.PageHint := TControl(Sender).Hint;

       IF LastHintControl <> Sender THEN
       BEGIN
            IF LastHintControl <> NIL THEN
            BEGIN
                 LastHintControl.PenColor := clWindowText;
                 LastHintControl := NIL;
            END;
            IF (Sender IS TCheckBox) OR (Sender IS TRadioButton) THEN
            BEGIN
                 TControl(Sender).PenColor := clRed;
                 LastHintControl := TControl(Sender);
            END;
       END;
  END;
END;


PROCEDURE TProjectDialog.EvPageChanged(Sender:TObject);
BEGIN
  SaveStdBtn.Enabled := Notebook.PageIndex <> FormPropertiesIndex;
END;


PROCEDURE TProjectDialog.EvModified(Sender:TObject);
BEGIN
  Modified := TRUE;
END;


PROCEDURE TProjectDialog.EvNeedRecompile(Sender:TObject);
BEGIN
  Modified := TRUE;
  NeedRecompile := TRUE;
END;


PROCEDURE TProjectDialog.EvDebugInfo(Sender:TObject);
VAR  EnablePacking:BOOLEAN;
BEGIN
  EvNeedRecompile(Sender);

  LocalSymCheck.Enabled := DebugInfoCheck.Checked;
  //IF not DebugInfoCheck.Checked THEN LocalSymCheck.Checked := FALSE;

  EnablePacking := (PlatformCombo.Text = PlatformOS2) AND (not DebugInfoCheck.Checked);
  RunVDMCheck.Enabled := EnablePacking;
  ExePackNoneRadio.Enabled := EnablePacking;
  ExePack1Radio.Enabled := EnablePacking;
  ExePack2Radio.Enabled := EnablePacking;
END;


PROCEDURE TProjectDialog.EvPlatformSelect(Sender:TObject;Index:LONGINT);
{ Wird ausgeloest, surch clicken auf das Objekt "PlatformCombo" }


VAR  EnablePacking:BOOLEAN;
     Var Platform:TPlatform;
BEGIN
  Modified := TRUE;
  NeedRecompile := TRUE;

  case Index Of
    0 : Platform:=pf_OS2;
    1 : Platform:=pf_Win32;
  end;

  EnablePacking := (Index = 0) AND (not DebugInfoCheck.Checked);
  RunVDMCheck.Enabled := EnablePacking;
  ExePackNoneRadio.Enabled := EnablePacking;
  ExePack1Radio.Enabled := EnablePacking;
  ExePack2Radio.Enabled := EnablePacking;

  If Platform<>TempSettings.Platform Then
  Begin
       PlatformCombo.OnItemSelect:=Nil;

       If DirCombo.ItemIndex>=0 Then
         SetEditDirectory(TEditDir(DirCombo.ItemIndex),TRUE);
       StoreCompilerPage;
       StoreWarningsPage;
       StoreLinkerPage;
       StoreDebuggerPage;
       StoreDirectoriesPage;
       StoreApplicationPage;

       TempSettings.Platform:=Platform;

       SetupCompilerPage;
       SetupWarningsPage;
       SetupLinkerPage;
       SetupDebuggerPage;
       SetupDirectoriesPage;
       SetupApplicationPage;

       EnablePacking := (Index = 0) AND (not DebugInfoCheck.Checked);
       RunVDMCheck.Enabled := EnablePacking;
       ExePackNoneRadio.Enabled := EnablePacking;
       ExePack1Radio.Enabled := EnablePacking;
       ExePack2Radio.Enabled := EnablePacking;

       PlatformCombo.OnItemSelect:=EvPlatformSelect;
  End;
END;


PROCEDURE TProjectDialog.EvEnableWarnings(Sender:TObject);
BEGIN
  W1Check.Enabled := TRUE;
  W2Check.Enabled := TRUE;
  W3Check.Enabled := TRUE;
  W4Check.Enabled := TRUE;
  W5Check.Enabled := TRUE;
  W6Check.Enabled := TRUE;
  W7Check.Enabled := TRUE;
  Modified := TRUE;
END;


PROCEDURE TProjectDialog.EvDisableWarnings(Sender:TObject);
BEGIN
  W1Check.Enabled := FALSE;
  W2Check.Enabled := FALSE;
  W3Check.Enabled := FALSE;
  W4Check.Enabled := FALSE;
  W5Check.Enabled := FALSE;
  W6Check.Enabled := FALSE;
  W7Check.Enabled := FALSE;
  Modified := TRUE;
END;


PROCEDURE TProjectDialog.EvDebugSetupShow(Sender:TObject);
BEGIN
    {update Position wegen IntegralHeight}
    IF Sender = RTLExceptions
    THEN RTLLab.Bottom := RTLExceptions.Bottom + RTLExceptions.Height;
    IF Sender = SPCCExceptions
    THEN SPCCLab.Bottom := SPCCExceptions.Bottom + SPCCExceptions.Height;
END;


PROCEDURE TProjectDialog.EvSaveAsStandard(Sender:TObject);
Var Platform:TPlatForm;
BEGIN
  Platform:=TempSettings.Platform;
  CASE Notebook.PageIndex OF
    0: {CompilerPage}
    BEGIN
         StoreCompilerPage;
         If Platform=pf_OS2
           Then IdeSettings.CompOptOs2 := TempSettings.CompOptOs2
           Else IdeSettings.CompOptWin := TempSettings.CompOptWin;
         IdeSettings.Modified := TRUE;
    END;
    1: {WarningsPage}
    BEGIN
         StoreWarningsPage;
         If Platform=pf_OS2
           Then IdeSettings.WarnOptOS2 := TempSettings.WarnOptOS2
           Else IdeSettings.WarnOptWin := TempSettings.WarnOptWin;
         IdeSettings.Modified := TRUE;
    END;
    2: {LinkerPage}
    BEGIN
         StoreLinkerPage;
         If Platform=pf_OS2 Then
           Begin
             IdeSettings.LinkOptOS2 := TempSettings.LinkOptOS2;
             IdeSettings.MemSizesOS2 := TempSettings.MemSizesOS2;
           End
         Else
           Begin
             IdeSettings.LinkOptWin := TempSettings.LinkOptWin;
             IdeSettings.MemSizesWin := TempSettings.MemSizesWin;
           End;
         IdeSettings.Modified := TRUE;
    END;
    3: {DebuggerPage}
    BEGIN
         StoreDebuggerPage;
         If Platform=pf_OS2 Then IdeSettings.DebugOptOS2 := TempSettings.DebugOptOS2
         Else IdeSettings.DebugOptWin := TempSettings.DebugOptWin;
         IdeSettings.Modified := TRUE;
    END;
    4: {DirectoriesPage}
    BEGIN
         StoreDirectoriesPage;
         If Platform=pf_OS2 Then IdeSettings.DirectoriesOS2 := TempSettings.DirectoriesOS2
         Else IdeSettings.DirectoriesWin := TempSettings.DirectoriesWin;
         IdeSettings.Modified := TRUE;
    END;
  END;
END;


PROCEDURE TProjectDialog.EvAutoCreateChange(Sender:TObject);
BEGIN
  IF AutoCreate.SrcItems.IndexOf(MainFormCombo.Text) < 0
    THEN MainFormCombo.Text := '';
  SCUModified := TRUE;
END;


PROCEDURE TProjectDialog.EvMainFormSelect(Sender:TObject;Index:LONGINT);
VAR  idx:LONGINT;
BEGIN
  idx := AutoCreate.DstItems.IndexOf(MainFormCombo.Text);
  IF idx >= 0 THEN
    BEGIN
      AutoCreate.SrcItems.Add(AutoCreate.DstItems[idx]);
      AutoCreate.DstItems.Delete(idx);
    END;
END;
{$HINTS ON}

PROCEDURE TProjectDialog.SetupCompilerPage;
VAR CompOpt:^TCompilerOptions;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:CompOpt:=@TempSettings.CompOptOS2;
     pf_WIN32:CompOpt:=@TempSettings.CompOptWin;
  END;

  WITH CompOpt^ DO
  BEGIN
       If PlatformCombo.Items.Count=0 Then
       Begin
          PlatformCombo.Items.Add(PlatformOS2);
          PlatformCombo.Items.Add(PlatformWin32);
          PlatformCombo.Text := PlatformCombo.Items[LONGINT(TempSettings.Platform)];
       End;

       AsmSrcCheck.Checked := CodeGen * [cg_ASMSource] <> [];
       InlineCheck.Checked := CodeGen * [cg_InlineStrings] <> [];
       AssertCheck.Checked := CodeGen * [cg_Assertions] <> [];
       SaveConstCheck.Checked := CodeGen * [cg_SaveConstructors] <> [];

       OptimizeCommonSubCheck.Checked := Optimize * [om_OptimizeCommonSub] <> [];
       OptimizePeepholeCheck.Checked := Optimize * [om_OptimizePeephole] <> [];

       StrictVarCheck.Checked := Syntax * [sx_StrictVAR] <> [];
       CompleteBoolCheck.Checked := Syntax * [sx_CompleteBoolEval] <> [];

       IOCheck.Checked := Runtime * [rc_InOut] <> [];
       OverflowCheck.Checked := Runtime * [rc_Overflow] <> [];
       StackCheck.Checked := Runtime * [rc_Stack] <> [];
       RangeCheck.Checked := Runtime * [rc_Range] <> [];

       CondEdit.Text := CondDef;
  END;
END;

PROCEDURE TProjectDialog.InitCompilerPage;
VAR idx:LONGINT;
    Group:TGroupBox;
    Lab:TLabel;

BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiCompiler));
  CompPage := TPage(Notebook.Pages.Objects[idx]);
  CompPage.PenColor := clStaticText;
  CompPage.HelpContext := hctxDialogProjectSettingsCompiler;
  SetMouseHint(CompPage,SiCompilerHint);

  Lab := InsertLabelNLS(CompPage,285,255,70,20,SiPlatForm);
  SetMouseHint(Lab,SiCompilerHint);

  PlatformCombo := InsertComboBox(CompPage,365,255,155,22,csDropDown);
  PlatformCombo.OnItemSelect := EvPlatformSelect;
  SetMouseHint(PlatformCombo,SiPlatFormHint);

  Group := InsertGroupBoxNLS(CompPage,20,145,245,130,SiCodeGeneration);
  SetMouseHint(Group,SiCompilerHint);

  AsmSrcCheck := InsertCheckBoxNLS(Group,15,85,220,20,SiGenerateAssemblerSource,0);
  AsmSrcCheck.OnClick := EvModified;
  SetMouseHint(AsmSrcCheck,SiGenerateAssemblerSourceHint);

  InlineCheck := InsertCheckBoxNLS(Group,15,60,220,20,SiInlineStringFunctions,0);
  InlineCheck.OnClick := EvNeedRecompile;
  SetMouseHint(InlineCheck,SiInlineStringFunctionsHint);

  AssertCheck := InsertCheckBoxNLS(Group,15,35,220,20,SiAssertions,0);
  AssertCheck.OnClick := EvNeedRecompile;
  SetMouseHint(AssertCheck,SiAssertionsHint);

  SaveConstCheck := InsertCheckBoxNLS(Group,15,10,220,20,SiSaveConstructors,0);
  SaveConstCheck.OnClick := EvNeedRecompile;
  SetMouseHint(SaveConstCheck,SiSaveConstructorsHint);


  Group := InsertGroupBoxNLS(CompPage,20,60,245,80,SiSyntaxOptions);
  SetMouseHint(Group,SiCompilerHint);

  StrictVarCheck := InsertCheckBoxNLS(Group,15,35,220,20,SiStrictVarStrings,0);
  StrictVarCheck.OnClick := EvNeedRecompile;
  SetMouseHint(StrictVarCheck,SiStrictVarStringsHint);

  CompleteBoolCheck := InsertCheckBoxNLS(Group,15,10,225,20,SiCompleteBooleanEval,0);
  CompleteBoolCheck.OnClick := EvNeedRecompile;
  SetMouseHint(CompleteBoolCheck,SiCompleteBooleanEvalHint);


  Group := InsertGroupBoxNLS(CompPage,285,170,235,80,SiOptimizations);
  SetMouseHint(Group,SiOptimizationsHint);

  OptimizeCommonSubCheck := InsertCheckBoxNLS(Group,15,35,215,20,SiCommonSubexpressions,0);
  OptimizeCommonSubCheck.OnClick := EvNeedRecompile;
  SetMouseHint(OptimizeCommonSubCheck,SiCommonSubexpressionsHint);

  OptimizePeepholeCheck := InsertCheckBoxNLS(Group,15,10,215,20,SiPeepholeOptimization,0);
  OptimizePeepholeCheck.OnClick := EvNeedRecompile;
  SetMouseHint(OptimizePeepholeCheck,SiPeepholeOptimizationHint);


  Group := InsertGroupBoxNLS(CompPage,285,35,235,130,SiRuntimeErrors);
  SetMouseHint(Group,SiCompilerHint);

  IOCheck := InsertCheckBoxNLS(Group,15,85,200,20,SiIOChecking,0);
  IOCheck.OnClick := EvNeedRecompile;
  SetMouseHint(IOCheck,SiIOCheckingHint);

  OverflowCheck := InsertCheckBoxNLS(Group,15,60,200,20,SiOverflowChecking,0);
  OverflowCheck.OnClick := EvNeedRecompile;
  SetMouseHint(OverflowCheck,SiOverflowCheckingHint);

  StackCheck := InsertCheckBoxNLS(Group,15,35,200,20,SiStackChecking,0);
  StackCheck.OnClick := EvNeedRecompile;
  SetMouseHint(StackCheck,SiStackCheckingHint);

  RangeCheck := InsertCheckBoxNLS(Group,15,10,200,20,SiRangeChecking,0);
  RangeCheck.OnClick := EvNeedRecompile;
  SetMouseHint(RangeCheck,SiRangeCheckingHint);


  Lab := InsertLabelNLS(CompPage,20,30,250,20,SiCondDefines);
  SetMouseHint(Lab,SiCompilerHint);

  CondEdit := InsertEdit(CompPage,20,5,500,22,'','');
  CondEdit.OnChange := EvNeedRecompile;
  SetMouseHint(CondEdit,SiEnterCondDefsHere);

  SetupCompilerPage;
END;


PROCEDURE TProjectDialog.StoreCompilerPage;
Var CompOpt:^TCompilerOptions;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:CompOpt:=@TempSettings.CompOptOS2;
     pf_WIN32:CompOpt:=@TempSettings.CompOptWin;
  END;

  WITH CompOpt^ DO
  BEGIN
       CodeGen := [];
       Optimize := [];
       Syntax := [];
       Runtime := [];

       IF AsmSrcCheck.Checked THEN Include(CodeGen,cg_ASMSource);
       IF InlineCheck.Checked THEN Include(CodeGen,cg_InlineStrings);
       IF AssertCheck.Checked THEN Include(CodeGen,cg_Assertions);
       IF SaveConstCheck.Checked THEN Include(CodeGen,cg_SaveConstructors);

       IF OptimizeCommonSubCheck.Checked THEN Include(Optimize,om_OptimizeCommonSub);
       IF OptimizePeepholeCheck.Checked THEN Include(Optimize,om_OptimizePeephole);

       IF StrictVarCheck.Checked THEN Include(Syntax,sx_StrictVAR);
       IF CompleteBoolCheck.Checked THEN Include(Syntax,sx_CompleteBoolEval);

       IF IOCheck.Checked THEN Include(Runtime,rc_InOut);
       IF OverflowCheck.Checked THEN Include(Runtime,rc_Overflow);
       IF StackCheck.Checked THEN Include(Runtime,rc_Stack);
       IF RangeCheck.Checked THEN Include(Runtime,rc_Range);

       CondDef:=CondEdit.Text;
  END;
END;

PROCEDURE TProjectDialog.SetupWarningsPage;
VAR WarnOpt:^TWarningOptions;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:WarnOpt:=@TempSettings.WarnOptOS2;
     pf_WIN32:WarnOpt:=@TempSettings.WarnOptWin;
  END;

  WITH WarnOpt^ DO
  BEGIN
       W1Check.Checked := Warnings * [w_w1] <> [];
       W2Check.Checked := Warnings * [w_w2] <> [];
       W3Check.Checked := Warnings * [w_w3] <> [];
       W4Check.Checked := Warnings * [w_w4] <> [];
       W5Check.Checked := Warnings * [w_w5] <> [];
       W6Check.Checked := Warnings * [w_w6] <> [];
       W7Check.Checked := Warnings * [w_w7] <> [];
       WSelRadio.Checked := Warnings * [w_wAll,w_WNone] = [];
       WAllRadio.Checked := Warnings * [w_wAll] <> [];
       WNoneRadio.Checked := Warnings * [w_wNone] <> [];

       IF Warnings * [w_wAll,w_WNone] <> [] THEN
       BEGIN
            W1Check.Enabled := FALSE;
            W2Check.Enabled := FALSE;
            W3Check.Enabled := FALSE;
            W4Check.Enabled := FALSE;
            W5Check.Enabled := FALSE;
            W6Check.Enabled := FALSE;
            W7Check.Enabled := FALSE;
       END;

       WarnCountEdit.Text := tostr(MaxWarnings);
       ErrCountEdit.Text := tostr(MaxErrors);
  END;
END;

PROCEDURE TProjectDialog.InitWarningsPage;
VAR  idx:LONGINT;
  Group:TGroupBox;
  Lab:TLabel;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiWarning));
  WarnPage := TPage(Notebook.Pages.Objects[idx]);
  WarnPage.PenColor := clStaticText;
  WarnPage.HelpContext := hctxDialogProjectSettingsWarnings;
  SetMouseHint(WarnPage,SiWarningsHint);

  Group := InsertGroupBoxNLS(WarnPage,20,90,350,180,SiCompilerWarnings);
  SetMouseHint(Group,SiCompilerWarningsHint);

  W1Check := InsertCheckBoxNLS(Group,15,130,330,20,SiPossibleUseBeforeDef,0);
  W1Check.OnClick := EvModified;
  SetMouseHint(W1Check,SiPossibleUseBeforeDefHint);

  W2Check := InsertCheckBoxNLS(Group,15,110,310,20,SiInheritedPropertyRedef,0);
  W2Check.OnClick := EvModified;
  SetMouseHint(W2Check,SiInheritedPropertyRedefHint);

  W3Check := InsertCheckBoxNLS(Group,15,90,310,20,SiInheritedVarRedef,0);
  W3Check.OnClick := EvModified;
  SetMouseHint(W3Check,SiInheritedVarRedefHint);

  W4Check := InsertCheckBoxNLS(Group,15,70,310,20,SiVirtualMethRedef,0);
  W4Check.OnClick := EvModified;
  SetMouseHint(W4Check,SiVirtualMethRedefHint);

  W5Check := InsertCheckBoxNLS(Group,15,50,310,20,SiIdentDeclaredNeverUsed,0);
  W5Check.OnClick := EvModified;
  SetMouseHint(W5Check,SiIdentDeclaredNeverUsedHint);

  W6Check := InsertCheckBoxNLS(Group,15,30,330,20,SiParamDeclaredNeverUsed,0);
  W6Check.OnClick := EvModified;
  SetMouseHint(W6Check,SiParamDeclaredNeverUsedHint);

  W7Check := InsertCheckBoxNLS(Group,15,10,310,20,SiFunctionShouldRet,0);
  W7Check.OnClick := EvModified;
  SetMouseHint(W7Check,SiFunctionShouldRetHint);


  Group := InsertGroupBoxNLS(WarnPage,390,170,130,100,SiSelectWarnings);
  SetMouseHint(Group,SiSelectWarningsHint);

  WSelRadio := InsertRadioButtonNLS(Group,15,50,110,20,SiSelected,0);
  WSelRadio.OnClick := EvEnableWarnings;
  SetMouseHint(WSelRadio,SiSelectedHint);

  WAllRadio := InsertRadioButtonNLS(Group,15,30,110,20,SiAll,0);
  WAllRadio.OnClick := EvDisableWarnings;
  SetMouseHint(WAllRadio,SiAllHint);

  WNoneRadio := InsertRadioButtonNLS(Group,15,10,110,20,SiNone,0);
  WNoneRadio.OnClick := EvDisableWarnings;
  SetMouseHint(WNoneRadio,SiNoneHint);


  Group := InsertGroupBox(WarnPage,20,10,350,70,'');
  SetMouseHint(Group,SiSetupWarnError);

  Lab := InsertLabelNLS(Group,15,35,75,20,SiStopAfter);
  SetMouseHint(Lab,SiStopAfterHint);
  WarnCountEdit := InsertEdit(Group,95,35,50,22,'','');
  WarnCountEdit.Alignment := taRightJustify;
  WarnCountEdit.OnChange := EvModified;
  SetMouseHint(WarnCountEdit,SiWarnCountHint);
  InsertLabelNLS(Group,155,35,80,20,SiAfterWarnings);

  Lab := InsertLabelNLS(Group,15,10,75,20,SiStopAfter);
  SetMouseHint(Lab,SiStopAfterHint2);
  ErrCountEdit := InsertEdit(Group,95,10,50,22,'','');
  ErrCountEdit.Alignment := taRightJustify;
  ErrCountEdit.OnChange := EvModified;
  SetMouseHint(ErrCountEdit,SiErrCountHint);
  InsertLabelNLS(Group,155,10,60,20,SiAfterErrors);

  {initialize}
  SetupWarningsPage;
END;


PROCEDURE TProjectDialog.StoreWarningsPage;
VAR  t,c:INTEGER;
     WarnOpt:^TWarningOptions;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:WarnOpt:=@TempSettings.WarnOptOS2;
     pf_WIN32:WarnOpt:=@TempSettings.WarnOptWin;
  END;

  WITH WarnOpt^ DO
  BEGIN
       Warnings := [];
       MaxWarnings := 200;
       MaxErrors := 10;

       IF W1Check.Checked THEN Include(Warnings,W_W1);
       IF W2Check.Checked THEN Include(Warnings,W_W2);
       IF W3Check.Checked THEN Include(Warnings,W_W3);
       IF W4Check.Checked THEN Include(Warnings,W_W4);
       IF W5Check.Checked THEN Include(Warnings,W_W5);
       IF W6Check.Checked THEN Include(Warnings,W_W6);
       IF W7Check.Checked THEN Include(Warnings,W_W7);

       IF WAllRadio.Checked THEN Include(Warnings,W_WAll);
       IF WNoneRadio.Checked THEN Include(Warnings,W_WNone);

       val(WarnCountEdit.Text,t,c);
       IF c = 0 THEN MaxWarnings := t;

       val(ErrCountEdit.Text,t,c);
       IF c = 0 THEN MaxErrors := t;
  END;
END;

PROCEDURE TProjectDialog.SetupLinkerPage;
VAR LinkOpt:^TLinkerOptions;
    MemSizes:^TMemorySizes;
    EnablePacking:Boolean;
    DebugOpt:^TDebuggerOptions;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:
     BEGIN
          LinkOpt:=@TempSettings.LinkOptOS2;
          MemSizes:=@TempSettings.MemSizesOS2;
          DebugOpt:=@TempSettings.DebugOptOS2;
     END;
     pf_WIN32:
     BEGIN
          LinkOpt:=@TempSettings.LinkOptWin;
          MemSizes:=@TempSettings.MemSizesWin;
          DebugOpt:=@TempSettings.DebugOptWin;
     END;
  END;

  WITH LinkOpt^ DO
  BEGIN
       GUIRadio.Checked := LinkerTarget = lt_GUI;
       FullScreenRadio.Checked := LinkerTarget = lt_FullScreen;
       WindowRadio.Checked := LinkerTarget = lt_Window;

       EnablePacking := (TempSettings.Platform = pf_OS2)
                    AND (DebugOpt^.Info * [di_LineNumbers] = []);
       ExePackNoneRadio.Enabled := EnablePacking;
       ExePackNoneRadio.Checked := ExePacking = ep_None;
       ExePack1Radio.Enabled := EnablePacking;
       ExePack1Radio.Checked := ExePacking = ep_ExePack1;
       ExePack2Radio.Enabled := EnablePacking;
       ExePack2Radio.Checked := ExePacking = ep_ExePack2;

       DataSegCheck.Checked := DataSegment = ds_SingleShared;

       RunVDMCheck.Enabled := EnablePacking;
       RunVDMCheck.Checked := RunVDM;
  END;

  WITH MemSizes^ DO
  BEGIN
       HeapEdit.Text := tostr(Heap);
       StackEdit.Text := tostr(Stack);
  END;
END;

PROCEDURE TProjectDialog.InitLinkerPage;
VAR  idx:LONGINT;
     Group:TGroupBox;
     Lab:TLabel;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiLinker));
  LinkPage := TPage(Notebook.Pages.Objects[idx]);
  LinkPage.PenColor := clStaticText;
  LinkPage.HelpContext := hctxDialogProjectSettingsLinker;
  SetMouseHint(LinkPage,SiLinkerHint);

  Group := InsertGroupBoxNLS(LinkPage,10,165,260,105,SiLinkerTarget);
  SetMouseHint(Group,SiLinkerHint);

  GUIRadio := InsertRadioButtonNLS(Group,10,60,180,20,siGUI,0);
  GUIRadio.OnClick := EvNeedRecompile;
  SetMouseHint(GUIRadio,SiGUIHint);

  FullScreenRadio := InsertRadioButtonNLS(Group,10,35,180,20,SiTextModeFull,0);
  FullScreenRadio.OnClick := EvNeedRecompile;
  SetMouseHint(FullScreenRadio,SiTextModeFullHint);

  WindowRadio := InsertRadioButtonNLS(Group,10,10,180,20,SiTextModeWindow,0);
  WindowRadio.OnClick := EvNeedRecompile;
  SetMouseHint(WindowRadio,SiTextModeWindowHint);

  Group := InsertGroupBoxNLS(LinkPage,280,165,255,105,SiMemorySizes);
  SetMouseHint(Group,SiMemorySizesHint);

  Lab := InsertLabelNLS(Group,15,50,110,20,SiHeap);
  SetMouseHint(Lab,SiHeapHint);
  HeapEdit := InsertEdit(Group,125,55,70,25,'','');
  HeapEdit.Alignment := taRightJustify;
  HeapEdit.OnChange := EvNeedRecompile;
  SetMouseHint(HeapEdit,SiHeapEditHint);

  Lab := InsertLabelNLS(Group,15,15,110,20,SiStack);
  SetMouseHint(Lab,SiStackHint);
  StackEdit := InsertEdit(Group,125,20,70,25,'','');
  StackEdit.Alignment := taRightJustify;
  StackEdit.OnChange := EvNeedRecompile;
  SetMouseHint(StackEdit,SiStackEditHint);


  Group := InsertGroupBoxNLS(LinkPage,10,45,260,105,SiExePacking);
  SetMouseHint(Group,SiLinkerHint);

  ExePackNoneRadio := InsertRadioButtonNLS(Group,10,60,180,20,SiExePackNone,0);
  ExePackNoneRadio.OnClick := EvNeedRecompile;
  SetMouseHint(ExePackNoneRadio,SiExePackNoneHint);

  ExePack1Radio := InsertRadioButtonNLS(Group,10,35,180,20,SiExePack1,0);
  ExePack1Radio.OnClick := EvNeedRecompile;
  SetMouseHint(ExePack1Radio,SiExePack1Hint);

  ExePack2Radio := InsertRadioButtonNLS(Group,10,10,180,20,SiExePack2,0);
  ExePack2Radio.OnClick := EvNeedRecompile;
  SetMouseHint(ExePack2Radio,SiExePack2Hint);


  Group := InsertGroupBoxNLS(LinkPage,280,100,255,50,SiDataSegment);
  SetMouseHint(Group,SiLinkerHint);

  DataSegCheck := InsertCheckBoxNLS(Group,10,10,180,20,SiSingleShared,0);
  DataSegCheck.OnClick := EvNeedRecompile;
  SetMouseHint(DataSegCheck,SiSingleSharedHint);


  Group := InsertGroupBoxNLS(LinkPage,280,45,255,50,SiVDM);
  SetMouseHint(Group,SiLinkerHint);

  RunVDMCheck := InsertCheckBoxNLS(Group,10,10,180,20,SiRunFromVDM,0);
  RunVDMCheck.OnClick := EvNeedRecompile;
  SetMouseHint(RunVDMCheck,SiRunFromVDMHint);

  {initialize}
  SetupLinkerPage;
END;


PROCEDURE TProjectDialog.StoreLinkerPage;
VAR  c:INTEGER;
     count:LONGWORD;
     LinkOpt:^TLinkerOptions;
     MemSizes:^TMemorySizes;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:
     BEGIN
          LinkOpt:=@TempSettings.LinkOptOS2;
          MemSizes:=@TempSettings.MemSizesOS2;
     END;
     pf_WIN32:
     BEGIN
          LinkOpt:=@TempSettings.LinkOptWin;
          MemSizes:=@TempSettings.MemSizesWin;
     END;
  END;


  WITH LinkOpt^ DO
  BEGIN
       IF GUIRadio.Checked THEN LinkerTarget := lt_GUI
       ELSE IF FullScreenRadio.Checked THEN LinkerTarget := lt_FullScreen
       ELSE IF WindowRadio.Checked THEN LinkerTarget := lt_Window;

       IF ExePackNoneRadio.Checked THEN ExePacking := ep_None
       ELSE IF ExePack1Radio.Checked THEN ExePacking := ep_ExePack1
       ELSE IF ExePack2Radio.Checked THEN ExePacking := ep_ExePack2;

       IF DataSegCheck.Checked THEN DataSegment := ds_SingleShared
       ELSE DataSegment := ds_Normal;

       RunVDM := RunVDMCheck.Checked;
  END;

  WITH MemSizes^ DO
  BEGIN
       val(HeapEdit.Text,count,c);
       IF c = 0 THEN Heap := count;

       val(StackEdit.Text,count,c);
       IF c = 0 THEN Stack := count;
  END;
END;

PROCEDURE TProjectDialog.SetupDebuggerPage;
VAR DebugOpt:^TDebuggerOptions;
    t:LongInt;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:DebugOpt:=@TempSettings.DebugOptOS2;
     pf_WIN32:DebugOpt:=@TempSettings.DebugOptWin;
  END;

  WITH DebugOpt^ DO
  BEGIN
       DebugInfoCheck.Checked := Info * [di_LineNumbers] <> [];
       LocalSymCheck.Checked := Info * [di_LocalSymbols] <> [];

       LocalSymCheck.Enabled := DebugInfoCheck.Checked;
       //IF not DebugInfoCheck.Checked THEN LocalSymCheck.Checked := FALSE;

       BubblesCheck.Checked := IdeSettings.CodeInsight.ToolTips;
       {$IFDEF OS2}
       ShowAnsiRefCheck.Checked:=(Options AND OPT_SHOWANSIREF)<>0;
       {$ENDIF}
       {$IFDEF Win32}
       ShowAnsiRefCheck.Checked:=False;
       {$ENDIF}

       FOR t := 1 TO MaxRTLXcpts DO
         IF (RTL_Exceptions AND (1 SHL (t-1)))<>0
         THEN RTLExceptions.State[t-1]:=clsChecked
         ELSE RTLExceptions.State[t-1]:=clsUnChecked;

       FOR t := 1 TO MaxSPCCXcpts DO
         IF (SPCC_Exceptions AND (1 SHL (t-1)))<>0
         THEN SPCCExceptions.State[t-1]:=clsChecked
         ELSE SPCCExceptions.State[t-1]:=clsUnChecked;
  END;
END;

PROCEDURE TProjectDialog.InitDebuggerPage;
VAR  idx:LONGINT;
     Group:TGroupBox;
     t:LONGWORD;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiDebugger));
  DebugPage := TPage(Notebook.Pages.Objects[idx]);
  DebugPage.PenColor := clStaticText;
  DebugPage.HelpContext := hctxDialogProjectSettingsDebugger;
  SetMouseHint(DebugPage,SiDebuggerHint);

  Group := InsertGroupBoxNLS(DebugPage,30,205,235,75,SiDebugInformation);
  SetMouseHint(Group,SiDebugInformationHint);

  DebugInfoCheck := InsertCheckBoxNLS(Group,15,35,215,20,SiIncludeDebugInfo,0);
  DebugInfoCheck.OnClick := EvDebugInfo;
  SetMouseHint(DebugInfoCheck,SiIncludeDebugInfoHint);

  LocalSymCheck := InsertCheckBoxNLS(Group,15,10,215,20,SiIncludeLocalSyms,0);
  LocalSymCheck.OnClick := EvNeedRecompile;
  SetMouseHint(LocalSymCheck,SiIncludeLocalSymsHint);


  Group := InsertGroupBoxNLS(DebugPage,280,205,235,75,SiDebuggerOptions);
  SetMouseHint(Group,SiDebuggerHint);

  BubblesCheck := InsertCheckBoxNLS(Group,15,35,215,20,SiShowWatchHints,0);
  BubblesCheck.OnClick := EvModified;
  SetMouseHint(BubblesCheck,SiShowWatchHintsHint);

  ShowAnsiRefCheck := InsertCheckBoxNLS(Group,15,10,215,20,SiShowAnsiStringCounter,0);
  ShowAnsiRefCheck.OnClick := EvModified;
  SetMouseHint(ShowAnsiRefCheck,SiShowAnsiStringCounterHint);


  Group:=InsertGroupBoxNLS(DebugPage,30,10,485,195,SiBreakOnExceptions);
  SetMouseHint(Group,SiBreakOnExceptionsHint);

  RTLLab := InsertLabelNLS(Group,15,150,200,20,SiRtlAndSystemExceptions);
  SetMouseHint(RTLLab,SiRTLAndSystemExceptionsHint);

  RTLExceptions:=InsertCheckListBox(Group,15,10,225,140);
  RTLExceptions.IntegralHeight := TRUE;
  RTLExceptions.OnStateChanged := EvModified;
  RTLExceptions.OnSetupShow := EvDebugSetupShow;
  SetMouseHint(RTLExceptions,SiRTLExcptHint);
  FOR t := 1 TO MaxRTLXcpts DO RTLExceptions.Items.Add(RTLXcpts[t]);

  SPCCLab := InsertLabelNLS(Group,250,150,200,20,SiSPCCExceptions);
  SetMouseHint(SPCCLab,SiSPCCExceptionsHint);

  SPCCExceptions:=InsertCheckListBox(Group,250,10,225,140);
  SPCCExceptions.IntegralHeight := TRUE;
  SPCCExceptions.OnStateChanged := EvModified;
  SPCCExceptions.OnSetupShow := EvDebugSetupShow;
  SetMouseHint(SPCCExceptions,SiSPCCExcptHint);
  FOR t := 1 TO MaxSPCCXcpts DO
    SPCCExceptions.Items.Add(SPCCXcpts[t]);

  {initialize}
  SetupDebuggerPage;
END;


PROCEDURE TProjectDialog.StoreDebuggerPage;
VAR t:LONGWORD;
    DebugOpt:^TDebuggerOptions;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:DebugOpt:=@TempSettings.DebugOptOS2;
     pf_WIN32:DebugOpt:=@TempSettings.DebugOptWin;
  END;

  WITH DebugOpt^ DO
  BEGIN
       Info := [];
       SPCC_Exceptions := 0;
       RTL_Exceptions := 0;
       Options:=0;

       IF DebugInfoCheck.Checked THEN Include(Info,di_LineNumbers);
       IF LocalSymCheck.Checked THEN Include(Info,di_LocalSymbols);

       IdeSettings.CodeInsight.ToolTips := BubblesCheck.Checked;

       {$IFDEF OS2}
       IF ShowAnsiRefCheck.Checked THEN Options:=Options OR OPT_SHOWANSIREF;
       {$ENDIF}

       FOR t := 1 TO MaxRTLXcpts DO
         IF RTLExceptions.State[t-1]=clsChecked
         THEN RTL_Exceptions:=RTL_Exceptions OR (1 SHL (t-1));

       FOR t := 1 TO MaxSPCCXcpts DO
         IF SPCCExceptions.State[t-1]=clsChecked
         THEN SPCC_Exceptions:=SPCC_Exceptions OR (1 SHL (t-1));
  END;
END;

PROCEDURE TProjectDialog.SetupDirectoriesPage;
VAR IdeDirectories:^TDirectories;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:IdeDirectories:=@IdeSettings.DirectoriesOS2;
     pf_WIN32:IdeDirectories:=@IdeSettings.DirectoriesWin;
  END;

  DirCombo.OnItemSelect:=Nil;
  DirCombo.ItemIndex := LONGINT(IdeDirectories^.LastEditDir);
  SetEditDirectory(IdeDirectories^.LastEditDir,FALSE);
  DirCombo.OnItemSelect := EvDirSelect;
END;

PROCEDURE TProjectDialog.InitDirectoriesPage;
VAR idx:LONGINT;
    Group:TGroupBox;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiDirectories));
  DirPage := TPage(Notebook.Pages.Objects[idx]);
  DirPage.PenColor := clStaticText;
  DirPage.HelpContext := hctxDialogProjectSettingsDirectories;
  SetMouseHint(DirPage,SiDirectoriesHint);

  Group := InsertGroupBox(DirPage,10,10,527,262,'');
  SetMouseHint(Group,SiDirectoriesHint);

  DirCombo := InsertComboBox(Group,20,215,487,25,csDropDown);
  DirCombo.Items.Add(LoadNLSStr(SiOutputDirectory));
  DirCombo.Items.Add(LoadNLSStr(SiUnitDirectories));
  DirCombo.Items.Add(LoadNLSStr(SiLibAndSourceDirectories));
  DirCombo.Items.Add(LoadNLSStr(SiIncludeAndSourceDirs));
  DirCombo.Items.Add(LoadNLSStr(SiComponentDirectories));
  SetMouseHint(DirCombo,SiDirectoriesHint);

  DirList.Create(Group);
  DirList.SetWindowPos(20,15,487,185);
  DirList.Parent := Group;
  DirList.OnEnter := EvNeedRecompile;
  DirList.OnBrowse := EvBrowseDir;

  {initialize}
  SetupDirectoriesPage;
END;


PROCEDURE TProjectDialog.SetEditDirectory(ed:TEditDir;WriteBack:BOOLEAN);
VAR s:STRING;
    p:INTEGER;
    Directories,IdeDirectories:^TDirectories;

BEGIN
  Case TempSettings.Platform OF
     pf_OS2:
     BEGIN
          IdeDirectories:=@IdeSettings.DirectoriesOS2;
          Directories:=@TempSettings.DirectoriesOS2;
     END;
     pf_WIN32:
     BEGIN
          IdeDirectories:=@IdeSettings.DirectoriesWin;
          Directories:=@TempSettings.DirectoriesWin;
     END;
  END;

  //aktuelles zurckschreiben
  IF WriteBack THEN WriteBackEditDirectory(IdeDirectories^.LastEditDir);

  CASE ed OF
    edOut:
    BEGIN
      s := Directories^.OutDir;
      DirList.Caption := ' '+ LoadNLSStr(SiOutputDirectory);
      SetMouseHint(DirList,SiOutputDirectoryHint);
    END;
    edLib:
    BEGIN
      s := Directories^.LibDir;
      DirList.Caption := ' '+ LoadNLSStr(SiUnitDirectories);
      SetMouseHint(DirList,SiUnitDirectoriesHint);
    END;
    edLibSrc:
    BEGIN
      s := Directories^.LibSrcDir;
      DirList.Caption := ' '+ LoadNLSStr(SiLibAndSourceDirectories);
      SetMouseHint(DirList,SiLibAndSourceDirectoriesHint);
    END;
    edIncSrc:
    BEGIN
      s := Directories^.IncSrcDir;
      DirList.Caption := ' '+ LoadNLSStr(SiIncludeAndSourceDirs);
      SetMouseHint(DirList,SiIncludeAndSourceDirsHint);
    END;
    edComp:
    BEGIN
      s := Directories^.CompInstallDir;
      DirList.Caption := ' '+ LoadNLSStr(SiComponentDirectories);
      SetMouseHint(DirList,SiComponentDirectoriesHint);
    END;
  END;


  DirList.BeginUpdate;
  DirList.Clear;
  WHILE s <> '' DO
  BEGIN
       p := pos(';',s);
       IF p > 0 THEN
       BEGIN
            DirList.Items.Add(copy(s,1,p-1));
            delete(s,1,p);
       END
       ELSE
       BEGIN
            DirList.Items.Add(s);
            s := '';
       END;
  END;
  IF DirList.Showing THEN DirList.Items.Add('');
  DirList.EndUpdate;

  IdeDirectories^.LastEditDir := ed;
END;


PROCEDURE TProjectDialog.StoreDirectoriesPage;
Var IdeDirectories:^TDirectories;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:
     BEGIN
          IdeDirectories:=@IdeSettings.DirectoriesOS2;
     END;
     pf_WIN32:
     BEGIN
          IdeDirectories:=@IdeSettings.DirectoriesWin;
     END;
  END;

  WriteBackEditDirectory(IdeDirectories^.LastEditDir);
END;


PROCEDURE TProjectDialog.WriteBackEditDirectory(ed:TEditDir);
VAR s,s1:STRING;
    i:LONGINT;
    Directories:^TDirectories;
BEGIN
  Case TempSettings.Platform OF
     pf_OS2:
     BEGIN
          Directories:=@TempSettings.DirectoriesOS2;
     END;
     pf_WIN32:
     BEGIN
          Directories:=@TempSettings.DirectoriesWin;
     END;
  END;

  s := '';
  FOR i := 0 TO DirList.Items.Count-1 DO
  BEGIN
       s1 := DirList.Items[i];
       IF s1 = '' THEN continue;
       IF s <> '' THEN s := s + ';' + s1
       ELSE s := s1;
  END;


  CASE ed OF
    edOut:
    BEGIN
      Directories^.OutDir := s;
    END;
    edLib:
    BEGIN
      Directories^.LibDir := s;
    END;
    edLibSrc:
    BEGIN
      Directories^.LibSrcDir := s;
    END;
    edIncSrc:
    BEGIN
      Directories^.IncSrcDir := s;
    END;
    edComp:
    BEGIN
      Directories^.CompInstallDir := s;
    END;
  END;
END;


CONST LastValidDir:STRING='';

PROCEDURE TProjectDialog.EvBrowseDir(Sender:TObject;VAR dir:STRING);
VAR  ChangeDirDlg:TChangeDirDialog;
BEGIN
  ChangeDirDlg.Create(SELF);
  ChangeDirDlg.Caption := DirList.Caption;
  ChangeDirDlg.OkName := LoadNLSStr(SiSelect);
  IF dir = '' THEN ChangeDirDlg.Directory := LastValidDir
  ELSE ChangeDirDlg.Directory := dir;
  ChangeDirDlg.HelpContext := 0;
  IF ChangeDirDlg.Execute THEN
  BEGIN
       dir := ChangeDirDlg.Directory;
       LastValidDir := dir;
  END;
  ChangeDirDlg.Destroy;
END;


PROCEDURE TProjectDialog.EvDirSelect(Sender:TObject;Index:LONGINT);
BEGIN
  SetEditDirectory(TEditDir(Index),TRUE);
  Modified := TRUE;
END;


PROCEDURE TProjectDialog.InitFormsPage;
VAR  idx:LONGINT;
  Lab:TLabel;
  i:LONGINT;
  FormItem:PFormListItem;
  MFName:STRING;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiPrjForms));
  FormPage := TPage(Notebook.Pages.Objects[idx]);
  FormPage.PenColor := clStaticText;
  FormPage.HelpContext := hctxDialogProjectSettingsForms;
  SetMouseHint(FormPage,SiFormsHint);

  {verbiete diese Seite bei nichtvisuellen Projekten}
  IF Project.Settings.ProjectType = pt_NonVisual THEN
  BEGIN
       FormPage.Enabled := FALSE;
       IF ActiveProjectPage = FormPropertiesIndex THEN ActiveProjectPage := 0;
  END;


  Lab := InsertLabelNLS(FormPage,20,240,100,20,SiMainForm);
  SetMouseHint(Lab,SiFormsHint);

  MainFormCombo := InsertComboBox(FormPage,120,240,300,20,csDropDownList);
  MainFormCombo.Text := Project.Settings.MainForm;
  MainFormCombo.OnItemSelect := EvMainFormSelect;
  SetMouseHint(MainFormCombo, SiMainFormHint);

  AutoCreate := InsertDualList(FormPage,20,30,400,190,
           LoadNLSStr(SiAutoCreate)+':',LoadNLSStr(SiManualCreate)+':');
  AutoCreate.OnChange := EvAutoCreateChange;
  SetMouseHint(AutoCreate, SiAutoCreateFormsHint);


  {initialize}
  MFName := Upcased(Project.Settings.MainForm);
  FOR i := 0 TO Project.Forms.Count-1 DO
  BEGIN
       FormItem := Project.Forms.Items[i];
       IF FormItem^.AutoCreate OR (MFName = Upcased(FormItem^.FormName))
       THEN AutoCreate.SrcItems.Add(FormItem^.FormName)
       ELSE AutoCreate.DstItems.Add(FormItem^.FormName);

       MainFormCombo.Items.Add(FormItem^.FormName);
  END;
  SCUModified := FALSE;
END;

PROCEDURE CheckIconValid(Const s:String);
{$IFDEF WIN32}
VAR f:File;
    SaveMode:LongWord;
Type TCursorOrIcon=Record
                     Reserved: Word;
                     wType: Word;
                     Count: Word;
                   End;

VAR IR:TCursorOrIcon;
{$ENDIF}

BEGIN
  {$IFDEF WIN32}
  SaveMode:=FileMode;
  filemode:=fminput;
  Assign(f,s);
  {$i-}
  Reset(f);
  {$i+}
  FileMode:=SaveMode;
  If IoResult<>0 Then
    Raise EInvalidIcon.Create('EInvalidIcon:Icon file not found');

  {$I-}
  BlockRead(f,IR,sizeof(TCursorOrIcon));
  {$I+}
  if ioresult<>0 then
  Begin
       {$I-}
       Close(f);
       {$I+}
       Raise EInvalidIcon.Create('EInvalidIcon:Cannot read from Icon file');
  End;
  {$I-}
  Close(f);
  {$I+}

  If not ((IR.Reserved=0)And(IR.wType In [0,1,2])) Then
    Raise EInvalidIcon.Create('Wrong icon file format');
  {$ENDIF}
END;

PROCEDURE TProjectDialog.EvIconSelect(Sender:TObject);
Var CFOD:TOpenDialog;
    s:String;
    AIcon:TIcon;
Begin
  CFOD.Create(SELF);
  CFOD.Caption := LoadNLSStr(SiSelectAFile);
  CFOD.OkName := LoadNLSStr(SiSelect);
  CFOD.AddFilter('Icons',ALL_FILES_UC_ICON); // '*.ICO');
  CFOD.DefaultExt := ALL_FILES_UC_ICON; // '*.ICO';
  CFOD.FileName := TheApplicationIcon;
  IF CFOD.Execute THEN
    BEGIN
      s:=CFOD.FileName;
      TheApplicationIcon:=s;

      AIcon.Create;
      Try
        CheckIconValid(s);
        AIcon.LoadFromFile(s);
      Except
        On E:Exception Do
          Begin
            ErrorBox(LoadNLSStr(SiCannotDisplayAppIcon)+
                     #13#10+E.Message+' ('+s+')'#13#10+
                     LoadNLSStr(SiIconFileMaybeInvalid));
            AIcon.Destroy;
            AIcon:=Nil;
          End;
        End;

       Modified := TRUE;
       NeedRecompile := TRUE;
       ApplicationIcon.Icon:=AIcon;
       AppIconFilename.Caption:=s;
       if AIcon=nil
         then s:='<none>'
         else
           Begin
             case AIcon.IconTyp of
               itOS2  : s:='OS/2-Icon';
               itWin32: s:='Win32-Icon';
             end;
             AIcon.Destroy;
           End;
       AppIconTyp.Caption:=s;
    End;
  CFOD.Destroy;
End;

PROCEDURE TProjectDialog.SetupApplicationPage;
VAR AIcon: TIcon;
    s    : String;
    ApplicationOpt:^TApplicationOptions;

BEGIN
  Case TempSettings.Platform OF
    pf_OS2:   Begin
                ApplicationOpt:=@TempSettings.ApplicationOptOS2;
                s:=ApplicationOpt^.ApplicationIcon;
                if s='' then s:=GetBinDir+'\default_os2.ico';
              End;
    pf_WIN32: Begin
                ApplicationOpt:=@TempSettings.ApplicationOptWin;
                s:=ApplicationOpt^.ApplicationIcon;
                If s='' Then s:=GetBinDir+'\default_win32.ico'
              End;
  END;
  if FileExists(s)
    then
      Begin
        AIcon.Create;
        Try
          CheckIconValid(s);
          Application.LogWriteln('LoadFromFile:'+s);
          AIcon.LoadFromFile(s);
        Except
          Application.LogWriteln('LoadFromFile-Error');
          On E:Exception Do
            Begin
              ErrorBox(LoadNLSStr(SiCannotDisplayAppIcon)+
                      #13#10+E.Message+' ('+s+')'#13#10+
                      LoadNLSStr(SiIconFileMaybeInvalid));
              AIcon.Destroy;
              AIcon:=Nil;
            End;
        End;
        Application.LogWriteln('LoadFromFile-end');
      End
    else
      Begin
        ErrorBox(FmtLoadNLSStr(SFileNotFound,[s])+'.');
        AIcon:=Nil;
      End;

  TheApplicationIcon:=s;
  AppIconFilename.Caption:=s;
  ApplicationIcon.Icon:=AIcon;
  if AIcon=nil
    then s:='<none>'
    else
      Begin
        case AIcon.IconTyp of
          itOS2  : s:='OS/2-Icon';
          itWin32: s:='Win32-Icon';
        end;
        AIcon.Destroy;
      End;
  AppIconTyp.Caption:=s;

  {$IFDEF OS2}
  AppComplib.Caption:=TempSettings.CompLibNameOS2;
  AppComplib.Hint   :='CompLib: OS/2';
  {$ENDIF}
  {$IFDEF Win32}
  AppComplib.Caption:=TempSettings.CompLibNameWin;
  AppComplib.Hint   :='CompLib: Win32';
  {$ENDIF}

END;

PROCEDURE TProjectDialog.InitApplicationPage;
VAR  idx:LONGINT;
     Lab:TLabel;
     Button:TButton;
BEGIN
  idx := Notebook.Pages.Add('Application');
  ApplicationPage := TPage(Notebook.Pages.Objects[idx]);
  ApplicationPage.PenColor := clStaticText;

  Lab := InsertLabel(ApplicationPage,20,240,40,20,'Icon:');
  Lab := InsertLabel(ApplicationPage,20,210,40,20,'Typ:');
  Lab := InsertLabel(ApplicationPage,20,180,70,20, LoadNLSStr(SFileName)+':');
  Lab := InsertLabel(ApplicationPage,20,100,60,20,'CompLib:');

  AppIconTyp     := InsertLabel(ApplicationPage,90,210,100,20,'');
  AppIconFilename:= InsertLabel(ApplicationPage,90,180,450,20,'');
  AppComplib     := InsertLabel(ApplicationPage,90,100,450,20,'');

  Button:=InsertButton(ApplicationPage,70,140,80,30,LoadNLSStr(siBrowse),'');
  Button.OnClick:=EvIconSelect;

  ApplicationIcon.Create(ApplicationPage);
  ApplicationIcon.SetWindowPos(60,240,32,32);
  ApplicationIcon.Parent:=ApplicationPage;

  SetupApplicationPage;
END;

PROCEDURE TProjectDialog.StoreApplicationPage;
VAR ApplicationOpt:^TApplicationOptions;
BEGIN
  Case TempSettings.Platform OF
    pf_OS2:
      BEGIN
        ApplicationOpt:=@TempSettings.ApplicationOptOS2;
      END;
    pf_WIN32:
      BEGIN
        ApplicationOpt:=@TempSettings.ApplicationOptWin;
      END;
  END;
  ApplicationOpt^.ApplicationIcon:=TheApplicationIcon;
END;


PROCEDURE TProjectDialog.StoreFormsPage;
BEGIN
  TempSettings.MainForm := MainFormCombo.Text;
END;


PROCEDURE TProjectDialog.DismissDlg(Result:TCommand);
VAR  i:LONGINT;
     FormItem:PFormListItem;
     newAutoCreate:BOOLEAN;
     OldSCU:POINTER;
     Form:TFormEditor;
BEGIN
  IF Result = cmOk THEN
    IF Project.Settings.ProjectType = pt_Visual THEN
      IF Project.Forms.Count > 0 THEN
  BEGIN
     IF MainFormCombo.Text <> '' THEN
     BEGIN
        FOR i := 0 TO Project.Forms.Count-1 DO
        BEGIN
           FormItem := Project.Forms.Items[i];
           newAutoCreate := AutoCreate.SrcItems.IndexOf(FormItem^.FormName) >= 0;

           IF FormItem^.AutoCreate <> newAutoCreate THEN {setze neuen Status}
           BEGIN
              IF FormItem^.Form = NIL THEN {create temp form}
              BEGIN
                 IF FormItem^.SCUPointer <> NIL THEN
                 BEGIN
                   OldSCU := SCUPointer;

                   SCUPointer := FormItem^.SCUPointer;
                   PSCUFileFormat(SCUPointer)^.UseEntry := 0;

                   FormItem^.Form := FormEditClass.Create(NIL);

                   FreeMem(FormItem^.SCUPointer, FormItem^.SCUSize);

                   SCUPointer := OldSCU;
                 END
                 ELSE
                 BEGIN
                    ErrorBox(LoadNLSStr(SiNoTempSCUInfoFound));
                    FormItem^.Form := FormEditClass.Create(NIL);
                 END;

                 FormItem^.Form.TypeName := 'T'+ FormItem^.Form.Name;
                 FormItem^.SCUPointer := POINTER(1); {-> spter CloseForm}
                 FormItem^.SCUSize := 0;
              END;

              {Setze das wichtige Flag}
              FormItem^.AutoCreate := newAutoCreate;
              IF newAutoCreate
              THEN Include(FormItem^.Form.DesignerState, dsAutoCreate)
              ELSE Exclude(FormItem^.Form.DesignerState, dsAutoCreate);

              IF FormItem^.SCUPointer = POINTER(1) THEN {Form war nicht sichtbar}
              BEGIN
                 FormItem^.SCUPointer := NIL;
                 Form := TFormEditor(FormItem^.Form);
                 CloseForm(Form);
                 Form.Destroy;
              END;
           END;
        END;
     END
     ELSE
     BEGIN
        ErrorBox(LoadNLSStr(SiYouMustSelectAMainForm));
        ModalResult := cmNull; {reset}
        Notebook.PageIndex := FormPropertiesIndex;
        exit; {no Inherited}
     END;
  END;
  Inherited DismissDlg(Result);
END;


PROCEDURE ProjectDialog;
VAR  Dialog:TProjectDialog;
     Directories:^TDirectories;
     DebugOpt:^TDebuggerOptions;
BEGIN
  Dialog.Create(NIL);
  Dialog.HelpContext := hctxDialogProjectSettings;
  IF Dialog.Execute THEN
  BEGIN
       Dialog.StoreCompilerPage;
       Dialog.StoreWarningsPage;
       Dialog.StoreLinkerPage;
       Dialog.StoreDebuggerPage;
       Dialog.StoreDirectoriesPage;
       Dialog.StoreFormsPage;
       Dialog.StoreApplicationPage;

       {testen, ob sich die MainForm gendert hat}
       IF Upcased(Dialog.TempSettings.MainForm) <>
          Upcased(Project.Settings.MainForm) THEN
       BEGIN
            SetProjectMainForm(Dialog.TempSettings.MainForm,TRUE);
            IF ProjectFormsList <> NIL THEN ProjectFormsList.Invalidate;
       END;

       Project.Settings := Dialog.TempSettings;

       Case Project.Settings.Platform OF
         pf_OS2:
         BEGIN
              Directories:=@Project.Settings.DirectoriesOS2;
              DebugOpt:=@Project.Settings.DebugOptOS2;
         END;
         pf_WIN32:
         BEGIN
              Directories:=@Project.Settings.DirectoriesWin;
              DebugOpt:=@Project.Settings.DebugOptWin;
         END;
       END;

       AddSrcDir(Directories^.LibSrcDir);
       AddSrcDir(Directories^.IncSrcDir);
       DbgSetExceptions(DebugOpt^.RTL_Exceptions,DebugOpt^.SPCC_Exceptions);
       SetOptions(DebugOpt^.Options);

       IF Dialog.Modified THEN Project.Modified := TRUE;
       IF Dialog.SCUModified THEN Project.SCUModified := TRUE;
       IF Dialog.NeedRecompile THEN Project.NeedRecompile := TRUE;
  END;
  ActiveProjectPage := Dialog.Notebook.PageIndex;
  Dialog.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: VDE Settings Dialog                                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TGeneralDialog=CLASS;
     TEditorSample=CLASS(TScrollingWinControl)
       PRIVATE
          FirstX,FirstY:LONGINT;
          xmax,ymax,ymin:LONGINT;
          GeneralDlg:TGeneralDialog;
          iBlock,iScope,iField,iSpace:STRING;
          PROCEDURE Changed;
          FUNCTION TempKey(idx:BYTE):STRING;
       PROTECTED
          PROCEDURE SetupComponent;OVERRIDE;
          PROCEDURE SetupShow;OVERRIDE;
          PROCEDURE Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);OVERRIDE;
          PROCEDURE FontChange;OVERRIDE;
       PUBLIC
          PROCEDURE Redraw(CONST rec:TRect);OVERRIDE;
     END;


     TGeneralDialog=CLASS(TDialog)
       PRIVATE
          LastHintControl:TControl;
          TempIdeSettings:TIdeSettings;
          IdeModified,EditorModified,DesignerModified,FlatBtnModified,
          IconbarModified:BOOLEAN;
          FontIndex:LONGINT;
          Notebook:TTabbedNotebook;
          EditPage,ColorPage,FormatPage,DesignPage,BrowsePage, CompilerPage,
          AutoPage, GeneralPage,PathPage, CodeInsightPage:TPage;
          InsertCheck,IndentCheck,AddIndentCheck,UnindentCheck,ClimbCheck,
          Click2Check,BlockCheck,PersistCheck,OverCheck,UndoCheck,SmartCheck,
          HomeCheck,BracketCheck:TCheckBox;
          BackupCheck,AppBakCheck,TextCheck,HiliteCheck,OpenCheck,FullCheck,
          WrapCheck,SaveCheck : TCheckBox;
          WrapEdit,SaveEdit,TabEdit,UndoEdit:TEdit;
          KeyCombo, PrioCombo:TComboBox;
          TabRadio,MDIRadio,MArrowRadio,MIBeamRadio,CUnderRadio,CVerticalRadio:TRadioButton;
          FontCombo:TComboBox;
          ColorList:TListBox;
          ColorGrid:TColorGrid;
          FgCheck,BgCheck:TCheckBox;
          EditorSample:TEditorSample;
          UpperRadio,MixedRadio,LowerRadio:TRadioButton;
          BlockScroll,ScopeScroll,FieldScroll,SpaceScroll:TScrollBar;
          BreakEdit:TEdit;
          EditorSample2:TEditorSample;
          GWidthEdit,GHeightEdit:TEdit;
          BrowseCheck:ARRAY[Browser_Constants..Browser_Published] OF TCheckBox;
          RTLCheck,SPCCCheck,PrjCheck:TCheckBox;
          GShowCheck,GActiveCheck,AutoCreateCheck:TCheckBox;
          DropMoveRadio,DropSizeRadio,SelIncludeRadio,SelTouchRadio:TRadioButton;
          SFilesCheck,SSCUCheck,SProjectCheck,SINICheck,RSourceCheck,
          RPrjFileCheck,RModulCheck,RUsesCheck,RSCUCheck:TCheckBox;
          HintsCheck,MsgViewCheck,FlatCheck,GlyphCheck,IconbarCheck,LastPrjCheck,
          AskRecompileCheck,SoundCheck:TCheckBox;
          DropOpenRadio,DropImportRadio:TRadioButton;
          PrjDirEdit, TemplateDirEdit, HelpCompFileNameEdit :TEdit;
          ComplCheck,ParamCheck,ToolTipCheck:TCheckBox;
          TimeTrack:TTrackBar;
          TemplGrid:TStringGrid;
          TemplAddBtn,TemplEditBtn,TemplDeleteBtn:TSpeedButton;
          TemplMemo:TMemo;
          TempCodeTemplateList:TList;
          TemplNameEdit,TemplDescEdit:TEdit;
          TemplOkBtn:TBitBtn;
          OkButton,CancelButton,HelpButton:TBitBtn;
          HelpLanguages:TCheckListBox;

          PROCEDURE SetMouseHintNLS(Control:TControl;AHint:LONGINT);
          PROCEDURE SetMouseHint(Control:TControl;AHint:String);
          PROCEDURE EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
          PROCEDURE EvEditorModified(Sender:TObject);
          PROCEDURE EvDesignerModified(Sender:TObject);
          PROCEDURE EvIdeModified(Sender:TObject);
          PROCEDURE EvKeySelect(Sender:TObject;Index:LONGINT);
          PROCEDURE EvFontSelect(Sender:TObject;Index:LONGINT);
          PROCEDURE EvPaintColorPage(Sender:TObject;CONST rec:TRect);
          PROCEDURE EvColorItemFocused(Sender:TObject;Index:LONGINT);
          PROCEDURE EvColorFocused(Sender:TObject;Index:LONGINT);
          PROCEDURE EvDefaultChange(Sender:TObject);
          PROCEDURE EvIdentifierStyle(Sender:TObject);
          PROCEDURE EvIndentScroll(Sender:TObject;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
          PROCEDURE EvApplFontClick(Sender:TObject);
          PROCEDURE EvBrowsePrjPath(Sender:TObject);
          PROCEDURE EvBrowseTemplatePath(Sender:TObject);
          PROCEDURE EvFlatBtnModified(Sender:TObject);
          PROCEDURE EvGlyphBtnModified(Sender:TObject);
          PROCEDURE EvIconbarModified(Sender:TObject);
          PROCEDURE EvTemplateAdd(Sender:TObject);
          PROCEDURE EvTemplateEdit(Sender:TObject);
          PROCEDURE EvTemplateDelete(Sender:TObject);
          PROCEDURE EvTemplateSelected(Sender:TObject;Col,Row:LONGINT);
          PROCEDURE EvTemplateCodeExit(Sender:TObject);
          PROCEDURE UpdateTemplateControls;
          PROCEDURE EvTemplateNameChanged(Sender:TObject);
          PROCEDURE EvBrowseHelpCompFilename(Sender:TObject);
          FUNCTION GetCodeTemplateDescription(CONST Caption:STRING;
                                 VAR Name,Description:STRING):BOOLEAN;
          PROCEDURE InitEditorPage;
          PROCEDURE StoreEditorPage;
          PROCEDURE InitColorPage;
          PROCEDURE StoreColorPage;
          PROCEDURE InitFormatPage;
          PROCEDURE StoreFormatPage;
          PROCEDURE InitDesignPage;
          PROCEDURE StoreDesignPage;
          PROCEDURE InitBrowsePage;
          PROCEDURE StoreBrowsePage;
          Procedure InitCompilerPage;
          Procedure StoreCompilerPage;
          PROCEDURE InitAutoPage;
          PROCEDURE StoreAutoPage;
          PROCEDURE InitGeneralPage;
          PROCEDURE StoreGeneralPage;
          Procedure InitPathPage;
          Procedure StorePathPage;
          PROCEDURE InitCodeInsightPage;
          PROCEDURE StoreCodeInsightPage;
       PROTECTED
          PROCEDURE SetupComponent;OVERRIDE;
     END;


PROCEDURE TEditorSample.SetupComponent;
BEGIN
  Inherited SetupComponent;
  Font      := EditorFont;
  ScrollBars:= ssBoth;
  FirstX    := 1;
  FirstY    := 1;
  Include(ComponentState, csAcceptsControls);
END;

PROCEDURE TEditorSample.SetupShow;
BEGIN
  Inherited SetupShow;
  Changed;
END;

PROCEDURE TEditorSample.Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
BEGIN
  Inherited Scroll(Sender,ScrollCode,ScrollPos);
  IF Sender = HorzScrollBar THEN FirstX := ScrollPos;
  IF Sender = VertScrollBar THEN FirstY := ScrollPos;
  Changed;
END;

PROCEDURE TEditorSample.FontChange;
BEGIN
  Inherited FontChange;
  Changed;
END;


PROCEDURE TEditorSample.Changed;
VAR  rec:TRect;
BEGIN
  IF Handle = 0 THEN exit;
  IF (HorzScrollBar = NIL) OR (VertScrollBar = NIL) THEN exit;

  xmax := (Width - goSysInfo.Screen.VScrollSize) DIV Font.Width;
  ymax := (Height - goSysInfo.Screen.HScrollSize) DIV Font.Height;
  ymin := goSysInfo.Screen.HScrollSize;

  HorzScrollBar.SetScrollRange(1,80,xmax);
  VertScrollBar.SetScrollRange(1,27,ymax);

  iBlock := StringOfChars(' ',GeneralDlg.TempIdeSettings.CodeGen.IndentBlock);
  iScope := StringOfChars(' ',GeneralDlg.TempIdeSettings.CodeGen.IndentScope);
  iField := StringOfChars(' ',GeneralDlg.TempIdeSettings.CodeGen.IndentField);
  iSpace := StringOfChars(' ',GeneralDlg.TempIdeSettings.CodeGen.IndentSpace);

  rec := ClientRect;
  rec.Bottom := ymin;
  dec(rec.Right, goSysInfo.Screen.VScrollSize);
  InvalidateRect(rec);
END;


FUNCTION TEditorSample.TempKey(idx:BYTE):STRING;
BEGIN
  Result := Bezeichner[idx];

  CASE GeneralDlg.TempIdeSettings.CodeGen.IdentifierStyle OF
    is_Uppercase: UpcaseStr(Result);               {BEZEICHNER}
    is_Mixed:     Result[1] := Upcase(Result[1]);  {Bezeichner}
    is_Lowercase: ;                                {bezeichner}
  END;
END;

PROCEDURE TEditorSample.Redraw(CONST rec:TRect);
VAR  x,y,w:LONGINT;
     i,c:INTEGER;
     s,s1,s2:STRING;
     ca:TColorArray;
     ci:INTEGER; {index in ca}

  FUNCTION GetAddress(fg:BYTE):PEditCol;
  BEGIN
    WITH GeneralDlg.TempIdeSettings.Colors.Editor DO
    BEGIN
         CASE fg OF
           fgcPlainText:   Result := @PlainText;
           fgcMarkedBlock: Result := @MarkedBlock;
           fgcSearchMatch: Result := @SearchMatch;
           fgcRightMargin: Result := @RightMargin;
           fgcHIL:         Result := @ReservedWord;
           fgcSTR:         Result := @Strings;
           fgcASM:         Result := @AsmBlock;
           fgcNumber:      Result := @Number;
           fgcSymbol:      Result := @Symbol;
           fgcREM1:        Result := @Comment1;
           fgcREM2:        Result := @Comment2;
           fgcREM3:        Result := @Comment3;
           fgcREM4:        Result := @Comment4;
           fgcREM5:        Result := @Comment5;
           fgcBreak:       Result := @ValidBreak;
           fgcInvBrk:      Result := @InvalidBreak;
           fgcExec:        Result := @ExecPoint;
           fgcError:       Result := @ErrorLine;
           ELSE            Result := NIL;
         END;
    END;
  END;

  PROCEDURE AddCol(n,fg:BYTE);
  VAR  i:INTEGER;
  BEGIN
       FOR i := 1 TO n DO
       BEGIN
            ca[ci].Fgc := fg;
            ca[ci].Bgc := fg+1;
            inc(ci);
       END;
  END;

  FUNCTION GetColorEntry(fg:BYTE):TColor;
  VAR  pec:PEditCol;
  BEGIN
       pec := GetAddress(fg);
       IF pec^.flag AND usefore <> 0 THEN
       BEGIN
            CASE fg OF
              fgcPlainText:   Result := clWindowText;
              fgcMarkedBlock: Result := clHighLightText;
              ELSE            Result := GetColorEntry(fgcPlainText);
            END;
       END
       ELSE Result := pec^.fg;
  END;

  FUNCTION GetBackColorEntry(bg:BYTE):TColor;
  VAR  pec:PEditCol;
  BEGIN
       pec := GetAddress(bg-1);
       IF pec^.flag AND useback <> 0 THEN
       BEGIN
            CASE bg OF
              bgcPlainText:   Result := clWindow;
              bgcMarkedBlock: Result := clHighLight;
              ELSE            Result := GetBackColorEntry(bgcPlainText);
            END;
       END
       ELSE Result := pec^.bg;
   END;

  PROCEDURE TextOut; {draw text s with color array ca at pos x,y}
  VAR  PenColorIndex:BYTE;
       BrushColorIndex:BYTE;
       i,x1,ps,count:LONGINT;
       s1:STRING;
  BEGIN
       IF s <> '' THEN
       BEGIN
            PenColorIndex := ca[1].Fgc;
            BrushColorIndex := ca[1].Bgc;
            Canvas.Pen.Color := GetColorEntry(PenColorIndex);
            Canvas.Brush.Color := GetBackColorEntry(BrushColorIndex);

            count := 0;
            ps := 0;
            FOR i := 1 TO Length(s) DO
            BEGIN
                 IF (PenColorIndex <> ca[i].Fgc) OR
                    (BrushColorIndex <> ca[i].Bgc) THEN
                 BEGIN
                      x1 := x + (ps * Canvas.FontWidth);
                      s1 := copy(s,ps+1,count);
                      Canvas.TextOut(x1,y,s1);

                      inc(ps,count);
                      count := 1;
                      PenColorIndex := ca[i].Fgc;
                      BrushColorIndex := ca[i].Bgc;
                      Canvas.Pen.Color := GetColorEntry(PenColorIndex);
                      Canvas.Brush.Color := GetBackColorEntry(BrushColorIndex);
                 END
                 ELSE inc(count);
            END;
            IF count <> 0 THEN
            BEGIN
                 x1 := x + (ps * Canvas.FontWidth);
                 s1 := copy(s,ps+1,count);
                 Canvas.TextOut(x1,y,s1);
            END;
       END;

       dec(y,Font.Height);
       ci := 1; {reset index in ca}
  END;

LABEL l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18,l19,l20,
      l21,l22,l23,l24,l25,l26,l27,wrap;
BEGIN
     Canvas.FillRect(rec, GetBackColorEntry(bgcPlainText));

     x := (FirstX - 1) * -Font.Width;
     y := Height - Font.Height;
     Canvas.Pen.Color := clBlack;
     ci := 1;

     CASE FirstY OF
       1:  goto l1;
       2:  goto l2;
       3:  goto l3;
       4:  goto l4;
       5:  goto l5;
       6:  goto l6;
       7:  goto l7;
       8:  goto l8;
       9:  goto l9;
       10: goto l10;
       11: goto l11;
       12: goto l12;
       13: goto l13;
       14: goto l14;
       15: goto l15;
       16: goto l16;
       17: goto l17;
       18: goto l18;
       19: goto l19;
       20: goto l20;
       21: goto l21;
       22: goto l22;
       23: goto l23;
       24: goto l24;
       25: goto l25;
       26: goto l26;
       27: goto l27;
     END;
l1:
     {line1}
     s := TempKey(_TYPE_);
     AddCol(4,fgcHIL);
     TextOut;
     IF y < ymin THEN goto wrap;
l2:
     {line2}
     s := iBlock + 'TForm1' + iSpace + '=' + iSpace + TempKey(_CLASS_) + iSpace + '(TForm)';
     AddCol(Length(iBlock+iSpace)+6,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(Length(iSpace),fgcPlainText);
     AddCol(5,fgcHIL);
     AddCol(Length(iSpace),fgcPlainText);
     AddCol(7,fgcPlainText);
     TextOut;
     IF y < ymin THEN goto wrap;
l3:
     {line3}
     s := iBlock + iScope + TempKey(_PUBLISHED_);
     AddCol(Length(iBlock+iScope),fgcPlainText);
     AddCol(9,fgcHIL);
     TextOut;
     IF y < ymin THEN goto wrap;
l4:
     {line4}
     s := iBlock + iScope + iField + 'Button1:' + iSpace + 'TButton;';
     AddCol(Length(iBlock+iScope+iField)+7,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(Length(iSpace)+7,fgcPlainText);
     AddCol(1,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l5:
     {line5}
     s := iBlock + iScope + iField + TempKey(_PROCEDURE_) + ' Button1Click(Sender:' + iSpace + 'TComponent);';
     AddCol(Length(iBlock+iScope+iField),fgcPlainText);
     AddCol(9,fgcHIL);
     AddCol(13,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(6,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(Length(iSpace)+10,fgcPlainText);
     AddCol(2,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l6:
     {line6}
     s := iBlock + TempKey(_END_) + ';';
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(3,fgcHIL);
     AddCol(1,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l7:
     {line7}
     s := '';
     AddCol(0,fgcPlainText);
     TextOut;
     IF y < ymin THEN goto wrap;
l8:
     {line8}
     s := '{ '+LoadNLSStr(SiCommentOne)+' }';
     AddCol(Length(s),fgcREM1);
     TextOut;
     IF y < ymin THEN goto wrap;
l9:
     {line9}
     s := TempKey(_PROCEDURE_) + ' TForm1.Button1Click(Sender:' + iSpace + 'TComponent);';
     AddCol(9,fgcHIL);
     AddCol(7,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(12,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(6,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(Length(iSpace)+10,fgcPlainText);
     AddCol(2,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l10:
     {line10}
     s := TempKey(_VAR_) + ' number,i:' + iSpace + 'Integer;';
     AddCol(3,fgcHIL);
     AddCol(7,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(1,fgcPlainText);
     AddCol(1,fgcSymbol);
     AddCol(Length(iSpace)+7,fgcPlainText);
     AddCol(1,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l11:
     {line11}
     s := TempKey(_BEGIN_);
     AddCol(5,fgcHIL);
     TextOut;
     IF y < ymin THEN goto wrap;
l12:
     {line12}
     s1 := '(* '+LoadNLSStr(SiCommentTwo)+' *)';
     s := iBlock + 'Caption := '+#39+'12345'+#39+';        '+s1;
     AddCol(Length(iBlock)+8,fgcPlainText);
     AddCol(2,fgcSymbol);
     AddCol(1,fgcPlainText);
     AddCol(7,fgcSTR);
     AddCol(1,fgcSymbol);
     AddCol(8,fgcPlainText);
     AddCol(Length(s1),fgcREM2);
     TextOut;
     IF y < ymin THEN goto wrap;
l13:
     {line13}
     s := iBlock + TempKey(_ASM_);
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(3,fgcHIL);
     TextOut;
     IF y < ymin THEN goto wrap;
l14:
     {line14}
     s1 := '/* '+LoadNLSStr(SiCommentThree)+' */';
     s := iBlock + iBlock + 'MOV AX,123               '+s1;
     AddCol(2*Length(iBlock),fgcPlainText);
     AddCol(10,fgcASM);
     AddCol(15,fgcPlainText);
     AddCol(Length(s1),fgcREM3);
     TextOut;
     IF y < ymin THEN goto wrap;
l15:
     {line15}
     s1 := '// '+LoadNLSStr(SiCommentFour);
     s := iBlock + iBlock + 'MOV number,AX            '+s1;
     AddCol(2*Length(iBlock),fgcPlainText);
     AddCol(13,fgcASM);
     AddCol(12,fgcPlainText);
     AddCol(Length(s1),fgcREM4);
     TextOut;
     IF y < ymin THEN goto wrap;
l16:
     {line16}
     s := iBlock + TempKey(_END_) + ';';
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(3,fgcHIL);
     AddCol(1,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l17:
     {line17}
     s1 := LoadNLSStr(SiSearchMatch);
     s2 := LoadNLSStr(SiMarkedBlock);
     s := iBlock + '{'+s1+', '+s2+'}';
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(1,fgcREM1);
     AddCol(Length(s1),fgcSearchMatch);
     AddCol(2,fgcREM1);
     AddCol(Length(s2),fgcMarkedBlock);
     AddCol(1,fgcREM1);
     TextOut;
     IF y < ymin THEN goto wrap;
l18:
     {line18}
     s1 := '{'+LoadNLSStr(SiThisIsACompilerSwitch)+'}';
     s := iBlock + '{$I+}                      '+s1;
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(5,fgcREM5);
     AddCol(22,fgcPlainText);
     AddCol(Length(s1),fgcREM1);
     TextOut;
     IF y < ymin THEN goto wrap;
l19:
     {line19}
     s := iBlock + TempKey(_FOR_) + ' i := 0 ' + TempKey(_TO_) + ' 10 ' + TempKey(_DO_);
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(3,fgcHIL);
     AddCol(3,fgcPlainText);
     AddCol(2,fgcSymbol);
     AddCol(1,fgcPlainText);
     AddCol(1,fgcNumber);
     AddCol(1,fgcPlainText);
     AddCol(2,fgcHIL);
     AddCol(1,fgcPlainText);
     AddCol(2,fgcNumber);
     AddCol(1,fgcPlainText);
     AddCol(2,fgcHIL);
     TextOut;
     IF y < ymin THEN goto wrap;
l20:
     {line20}
     s := iBlock + TempKey(_BEGIN_);
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(5,fgcHIL);
     TextOut;
     IF y < ymin THEN goto wrap;
l21:
     {line21}
     s := iBlock + iBlock + 'inc(number);             {'+LoadNLSStr(SiExecutionPoint)+'}                                        ';
     AddCol(255,fgcExec);
     TextOut;
     IF y < ymin THEN goto wrap;
l22:
     {line22}
     s := iBlock + iBlock + 'inc(number);             {'+LoadNLSStr(SiEnabledBreakPoint)+'}                                     ';
     AddCol(255,fgcBreak);
     TextOut;
     IF y < ymin THEN goto wrap;
l23:
     {line23}
     s := iBlock + TempKey(_END_) + ';';
     AddCol(Length(iBlock),fgcPlainText);
     AddCol(3,fgcHIL);
     AddCol(1,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l24:
     {line24}
     s := iBlock + 'Caption := tostr(number);  {'+LoadNLSStr(SiErrorLine)+'}                                                    ';
     AddCol(255,fgcError);
     TextOut;
     IF y < ymin THEN goto wrap;
l25:
     {line25}
     s := iBlock + '{'+LoadNLSStr(SiInvalidBreakPoint)+'}                                                                       ';
     AddCol(255,fgcInvBrk);
     TextOut;
     IF y < ymin THEN goto wrap;
l26:
     {line26}
     s := TempKey(_END_) + ';';
     AddCol(3,fgcHIL);
     AddCol(1,fgcSymbol);
     TextOut;
     IF y < ymin THEN goto wrap;
l27:
     {line27}
     s := '';
     AddCol(0,fgcPlainText);
     TextOut;

wrap:
     {word wrap line}
     w := GeneralDlg.TempIdeSettings.EditOpt.WrapColumn;
     val(GeneralDlg.WrapEdit.Text,i,c);
     IF c = 0 THEN w := i;
     IF w <= 0 THEN w := xmax + FirstX -1;

     {WordWrap Line}
     x := (w - FirstX + 1) * Canvas.FontWidth;
     Canvas.Pen.Color := GetColorEntry(fgcRightMargin);
     Canvas.MoveTo(x,Height);
     Canvas.LineTo(x,y + Font.Height);
END;


////////////////////////////////////////////////////////////////////////////

PROCEDURE TGeneralDialog.SetupComponent;
BEGIN
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiGeneralSettings);
  ClientWidth := 580;
  ClientHeight := 440;

  TempIdeSettings := IdeSettings;
  IdeModified := FALSE;
  EditorModified := FALSE;
  DesignerModified := FALSE;
  FlatBtnModified := FALSE;
  IconbarModified := FALSE;
  FontIndex := -1;

  Notebook := InsertTabbedNotebook(SELF,0,50,580,390);
  Notebook.Align := alTop;
  Notebook.Pages.Clear;

  OkButton:=InsertBitBtnNLS(SELF,20,10,100,30,bkOk,SOkButton,SClickHereToAccept);
  CancelButton:=InsertBitBtnNLS(SELF,135,10,100,30,bkCancel,SCancelButton,SClickHereToCancel);
  HelpButton:=InsertBitBtnNLS(SELF,460,10,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);

  InitEditorPage;
  InitColorPage;
  InitFormatPage;
  InitDesignPage;
  InitBrowsePage;
  InitCompilerPage;
  InitAutoPage;
  InitGeneralPage;
  InitPathPage;
  InitCodeInsightPage;

  Notebook.PageIndex := ActiveGeneralPage;
  Notebook.AutoPopup := TRUE;
END;


PROCEDURE TGeneralDialog.SetMouseHintNLS(Control:TControl;AHint:LONGINT);

Begin
  SetMouseHint(Control, LoadNLSStr(AHint));
End;


PROCEDURE TGeneralDialog.SetMouseHint(Control:TControl;AHint:String);
BEGIN
  Control.ParentShowHint:= FALSE;
  Control.ShowHint      := FALSE;
  Control.Hint          := AHint;
  Control.OnMouseMove   := EvMouseHint;
END;


{$HINTS OFF}
PROCEDURE TGeneralDialog.EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
BEGIN
  IF Sender IS TControl THEN
  BEGIN
       Notebook.PageHint := TControl(Sender).Hint;

       IF LastHintControl <> Sender THEN
       BEGIN
            IF LastHintControl <> NIL THEN
            BEGIN
                 LastHintControl.PenColor := clWindowText;
                 LastHintControl := NIL;
            END;
            IF (Sender IS TCheckBox) OR (Sender IS TRadioButton) THEN
            BEGIN
                 TControl(Sender).PenColor := clRed;
                 LastHintControl := TControl(Sender);
            END;
       END;
  END;
END;


PROCEDURE TGeneralDialog.EvEditorModified(Sender:TObject);
BEGIN
     IdeModified := TRUE;
     EditorModified := TRUE;

     IF Sender = WrapCheck THEN WrapEdit.Enabled := WrapCheck.Checked;
     IF Sender = SaveCheck THEN SaveEdit.Enabled := SaveCheck.Checked;
END;


PROCEDURE TGeneralDialog.EvDesignerModified(Sender:TObject);
BEGIN
  IdeModified := TRUE;
  DesignerModified := TRUE;
END;


PROCEDURE TGeneralDialog.EvIdeModified(Sender:TObject);
BEGIN
  IdeModified := TRUE;
END;


PROCEDURE TGeneralDialog.EvKeySelect(Sender:TObject;Index:LONGINT);
BEGIN
  IdeModified := TRUE;
  EditorModified := TRUE;
END;


PROCEDURE TGeneralDialog.EvFontSelect(Sender:TObject;Index:LONGINT);
BEGIN
  IdeModified := TRUE;
  EditorModified := TRUE;
  FontIndex := Index;
  EditorSample.Font := TFont(FontCombo.Items.Objects[Index]);
  EditorSample2.Font := TFont(FontCombo.Items.Objects[Index]);
END;
{$HINTS ON}


PROCEDURE TGeneralDialog.EvPaintColorPage(Sender:TObject;CONST rec:TRect);
VAR  Page:TPage;
     rc:TRect;
BEGIN
  Page := TPage(Sender);
  Page.Redraw(rec);
  rc := EditorSample.WindowRect;
  Forms.InflateRect(rc,2,2);
  DrawSystemBorder(Page,rc,bsSingle);
END;


CONST {Basic Colors of the ColorGrid}
  BasicColors:ARRAY[0..15] OF TColor =
    (clBlack,clMaroon,clGreen,clOlive,clNavy,clPurple,clTeal,clRed,clLime,
     clYellow,clBlue,clFuchsia,clAqua,clLtGray,clDkGray,clWhite);


{$HINTS OFF}
PROCEDURE TGeneralDialog.EvColorItemFocused(Sender:TObject;Index:LONGINT);
VAR  pec:PEditCol;
     i:INTEGER;
BEGIN {ColorList is the Sender}
     pec := PEditCol(ColorList.Items.Objects[Index]);

     FgCheck.Checked := (pec^.flag AND usefore) <> 0;
     BgCheck.Checked := (pec^.flag AND useback) <> 0;

     ColorGrid.ForegroundEnabled := not FgCheck.Checked;
     ColorGrid.BackgroundEnabled := not BgCheck.Checked;
     FOR i := 15 DOWNTO 0 DO
       IF BasicColors[i] = pec^.fg THEN
       BEGIN
            ColorGrid.ForegroundIndex := i;
            break;
       END;
     FOR i := 15 DOWNTO 0 DO
       IF BasicColors[i] = pec^.bg THEN
       BEGIN
            ColorGrid.BackgroundIndex := i;
            break;
       END;
END;


PROCEDURE TGeneralDialog.EvColorFocused(Sender:TObject;Index:LONGINT);
VAR  pec:PEditCol;
     flag:BYTE;
BEGIN {ColorGrid is the Sender}
     IdeModified := TRUE;
     EditorModified := TRUE;

     FgCheck.Checked := not ColorGrid.ForegroundEnabled;
     BgCheck.Checked := not ColorGrid.BackgroundEnabled;
     flag := 0;
     IF FgCheck.Checked THEN flag := flag OR usefore;
     IF BgCheck.Checked THEN flag := flag OR useback;

     pec := PEditCol(ColorList.Items.Objects[ColorList.ItemIndex]);
     pec^.fg := BasicColors[ColorGrid.ForegroundIndex];
     pec^.bg := BasicColors[ColorGrid.BackgroundIndex];
     pec^.flag := flag;

     EditorSample.Invalidate;
     EditorSample2.Invalidate;
END;
{$HINTS ON}


PROCEDURE TGeneralDialog.EvDefaultChange(Sender:TObject);
VAR  pec:PEditCol;
BEGIN
  IdeModified := TRUE;
  EditorModified := TRUE;
  pec := PEditCol(ColorList.Items.Objects[ColorList.ItemIndex]);

  IF Sender = FgCheck THEN
  BEGIN
       IF FgCheck.Checked THEN pec^.flag := pec^.flag OR usefore
       ELSE pec^.flag := pec^.flag AND (not usefore);
       ColorGrid.ForegroundEnabled := not FgCheck.Checked;
  END;
  IF Sender = BgCheck THEN
  BEGIN
       IF BgCheck.Checked THEN pec^.flag := pec^.flag OR useback
       ELSE pec^.flag := pec^.flag AND (not useback);
       ColorGrid.BackgroundEnabled := not BgCheck.Checked;
  END;

  EditorSample.Invalidate;
  EditorSample2.Invalidate;
  {Farben des ColorGrids setzen}
  EvColorItemFocused(ColorList,ColorList.ItemIndex);
END;


PROCEDURE TGeneralDialog.EvIdentifierStyle(Sender:TObject);
BEGIN
  IdeModified := TRUE;

  IF Sender = UpperRadio THEN TempIdeSettings.CodeGen.IdentifierStyle := is_Uppercase;
  IF Sender = LowerRadio THEN TempIdeSettings.CodeGen.IdentifierStyle := is_Lowercase;
  IF Sender = MixedRadio THEN TempIdeSettings.CodeGen.IdentifierStyle := is_Mixed;

  EditorSample2.Changed;
  EditorSample.Changed;
END;


{$HINTS OFF}
PROCEDURE TGeneralDialog.EvIndentScroll(Sender:TObject;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
BEGIN
  IdeModified := TRUE;

  IF Sender = BlockScroll THEN TempIdeSettings.CodeGen.IndentBlock := ScrollPos;
  IF Sender = ScopeScroll THEN TempIdeSettings.CodeGen.IndentScope := ScrollPos;
  IF Sender = FieldScroll THEN TempIdeSettings.CodeGen.IndentField := ScrollPos;
  IF Sender = SpaceScroll THEN TempIdeSettings.CodeGen.IndentSpace := ScrollPos;

  EditorSample2.Changed;
  EditorSample.Changed;
END;


PROCEDURE TGeneralDialog.EvApplFontClick(Sender:TObject);
VAR  FD:TFontDialog;
BEGIN
  FD.Create(SELF);
  FD.HelpContext := hctxDialogApplicationFont;
  FD.Caption := LoadNLSStr(SiSelectApplicationFont);
  FD.EditFont := Application.Font;
  IF FD.Execute THEN
  BEGIN
       IdeModified := TRUE;
       TempIdeSettings.Fonts.ApplicationFont := FD.FontName;

       Application.Font := FD.EditFont;
  END;
  FD.Destroy;
END;


PROCEDURE TGeneralDialog.EvBrowsePrjPath(Sender:TObject);
VAR  CDD:TChangeDirDialog;
BEGIN
  CDD.Create(SELF);
  CDD.HelpContext := hctxDialogChangeProjectDirectory;
  CDD.Caption := LoadNLSStr(SiProjectDirectory);
  CDD.OkName := LoadNLSStr(SiSelect);
  CDD.Directory := PrjDirEdit.Text;
  IF CDD.Execute THEN
    BEGIN
       PrjDirEdit.Text := CDD.Directory;
    END;
  CDD.Destroy;
  PrjDirEdit.CaptureFocus;
END;

PROCEDURE TGeneralDialog.EvBrowseTemplatePath(Sender:TObject);
VAR  CDD:TChangeDirDialog;
BEGIN
  CDD.Create(SELF);
  CDD.HelpContext := hctxDialogChangeTemplateDirectory;
  CDD.Caption := LoadNLSStr(SiTemplateDirectory);
  CDD.OkName := LoadNLSStr(SiSelect);
  CDD.Directory := TemplateDirEdit.Text;
  IF CDD.Execute THEN
    BEGIN
       TemplateDirEdit.Text := CDD.Directory;
    END;
  CDD.Destroy;
  TemplateDirEdit.CaptureFocus;
END;


PROCEDURE TGeneralDialog.EvFlatBtnModified(Sender:TObject);
BEGIN
     IdeModified := TRUE;
     FlatBtnModified := TRUE;
     SetExplorerBtnLook(not FlatCheck.Checked);
END;


PROCEDURE TGeneralDialog.EvGlyphBtnModified(Sender:TObject);
BEGIN
     IdeModified := TRUE;
     ShowBitBtnGlyph := GlyphCheck.Checked;

     OkButton.Kind:=bkCustom;
     OkButton.Glyph:=NIL;
     CancelButton.Kind:=bkCustom;
     CancelButton.Glyph:=NIL;
     HelpButton.Kind:=bkCustom;
     HelpButton.Glyph:=NIL;

     IF ShowBitBtnGlyph THEN
     BEGIN
          OkButton.Kind:=bkOk;
          CancelButton.Kind:=bkCancel;
          HelpButton.Kind:=bkHelp;
     END;
END;


PROCEDURE TGeneralDialog.EvIconbarModified(Sender:TObject);
BEGIN
     IdeModified := TRUE;
     IconbarModified := TRUE;
END;


PROCEDURE TGeneralDialog.EvTemplateNameChanged(Sender:TObject);
VAR  i:LONGINT;
     Name:STRING;
     b:BOOLEAN;
BEGIN
     Name := TemplNameEdit.Caption;
     // Name darf nicht leer sein und keine Sonderzeichen enthalten
     b := TRUE;
     IF Name = '' THEN b := FALSE;
     FOR i := 1 TO Length(Name) DO
       IF Not (Name[i] In NormalChars) THEN b := FALSE;
     TemplOkBtn.Enabled := b;
END;


FUNCTION TGeneralDialog.GetCodeTemplateDescription(CONST Caption:STRING;
  VAR Name,Description:STRING):BOOLEAN;
VAR  Dlg:TDialog;
     Group:TGroupBox;
BEGIN
  Dlg.Create(NIL);
  Dlg.ClientWidth := 400;
  Dlg.ClientHeight := 160;
  Dlg.Caption := Caption;

  Group := InsertGroupBox(Dlg,15,65,370,80,'');
  InsertLabelNLS(Group,15,48,100,20,SiTemplateName);
  TemplNameEdit := InsertEdit(Group,128,48,228,22,Name,'');
  TemplNameEdit.OnChange := EvTemplateNameChanged;
  TemplNameEdit.Focus;
  InsertLabelNLS(Group,15,15,100,20,SiTemplateDescription);
  TemplDescEdit := InsertEdit(Group,128,15,228,22,Description,'');
  TemplOkBtn := InsertBitBtnNLS(Dlg,176,15,100,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(Dlg,288,15,100,30,bkCancel,SCancelButton,SClickHereToCancel);

  EvTemplateNameChanged(NIL); // update Button

  IF Dlg.Execute
    THEN
      BEGIN
        Name := Trim(TemplNameEdit.Caption);
        Description := Trim(TemplDescEdit.Caption);
        Result := TRUE;
      END
    ELSE Result := FALSE;

  Dlg.Destroy;
END;


PROCEDURE TGeneralDialog.UpdateTemplateControls;
VAR  b:BOOLEAN;
BEGIN
  b := (TemplGrid.RowCount > 1) AND
       (TemplGrid.Row > 0) AND (TemplGrid.Row <= TemplGrid.RowCount-1);
  TemplMemo.Enabled := b;
  TemplEditBtn.Enabled := b;
  TemplDeleteBtn.Enabled := b;

  If Not TemplMemo.Enabled Then TemplMemo.Clear;
END;


PROCEDURE TGeneralDialog.EvTemplateAdd(Sender:TObject);
VAR  pct:PCodeTemplate;
     Name,Description:STRING;
BEGIN
  Name := '';
  Description := '';
  IF GetCodeTemplateDescription(LoadNLSStr(SiAddCodeTemplate),
                                Name,Description) THEN
    BEGIN
      new(pct);
      pct^.Name := Name;
      pct^.Description := Description;
      pct^.Strings.Create;
      TempCodeTemplateList.Add(pct);
      TemplGrid.RowCount := TemplGrid.RowCount + 1;
      TemplGrid.Row := TemplGrid.RowCount-1;
      TemplGrid.Cells[0,TemplGrid.Row] := Name;
      TemplGrid.Cells[1,TemplGrid.Row] := Description;
      TemplGrid.TopRow := TemplGrid.Row - TemplGrid.FixedRows;
      EvTemplateSelected(TemplGrid,TemplGrid.Col,TemplGrid.Row);
      TemplGrid.Invalidate;
    END;

  UpdateTemplateControls;
END;


PROCEDURE TGeneralDialog.EvTemplateEdit(Sender:TObject);
VAR  pct:PCodeTemplate;
     Name,Description:STRING;
BEGIN
     IF (TemplGrid.Row > 0) AND (TemplGrid.Row <= TempCodeTemplateList.Count) THEN
     BEGIN
          pct := TempCodeTemplateList.Items[TemplGrid.Row-1];
          Name := pct^.Name;
          Description := pct^.Description;

          IF GetCodeTemplateDescription(LoadNLSStr(SiEditCodeTemplate),
                                        Name,Description) THEN
          BEGIN
               pct^.Name := Name;
               pct^.Description := Description;
               TemplGrid.Cells[0,TemplGrid.Row] := Name;
               TemplGrid.Cells[1,TemplGrid.Row] := Description;
               TemplGrid.Invalidate;
          END;
     END;

     UpdateTemplateControls;
END;


PROCEDURE TGeneralDialog.EvTemplateDelete(Sender:TObject);
VAR  pct:PCodeTemplate;
     i:LONGINT;
     curRow:LONGINT;
BEGIN
     IF (TemplGrid.Row > 0) AND (TemplGrid.Row <= TempCodeTemplateList.Count) THEN
     BEGIN
          pct := TempCodeTemplateList.Items[TemplGrid.Row-1];
          pct^.Strings.Destroy;
          dispose(pct);
          TempCodeTemplateList.Delete(TemplGrid.Row-1);
          // delete grid row
          curRow := TemplGrid.Row;
          FOR i := curRow TO TemplGrid.RowCount-2 DO
          BEGIN
               TemplGrid.Cells[0,i] := TemplGrid.Cells[0,i+1];
               TemplGrid.Cells[1,i] := TemplGrid.Cells[1,i+1];
          END;

          TemplGrid.RowCount := TemplGrid.RowCount-1;
          IF curRow > TemplGrid.RowCount-1 THEN curRow := TemplGrid.RowCount-1;
          TemplGrid.Row := curRow;
          TemplGrid.TopRow := TemplGrid.Row - TemplGrid.FixedRows;
          EvTemplateSelected(TemplGrid,TemplGrid.Col,TemplGrid.Row);
          TemplGrid.Invalidate;
     END;

     UpdateTemplateControls;
END;


PROCEDURE TGeneralDialog.EvTemplateSelected(Sender:TObject;Col,Row:LONGINT);
VAR  pct:PCodeTemplate;
BEGIN
     IF (Row > 0) AND (Row <= TempCodeTemplateList.Count) THEN
     BEGIN
          pct := TempCodeTemplateList.Items[Row-1];
          TemplMemo.Lines.Assign(pct^.Strings);
     END
     ELSE TemplMemo.Clear;
     TemplMemo.Modified := FALSE;

     UpdateTemplateControls;
END;


PROCEDURE TGeneralDialog.EvTemplateCodeExit(Sender:TObject);
VAR  pct:PCodeTemplate;
BEGIN
     IF (TemplGrid.Row > 0) AND (TemplGrid.Row <= TempCodeTemplateList.Count)
        AND (TemplMemo.Modified) THEN
     BEGIN
          pct := TempCodeTemplateList.Items[TemplGrid.Row-1];
          pct^.Strings.Assign(TemplMemo.Lines);
     END;
END;

{$HINTS ON}


PROCEDURE TGeneralDialog.InitEditorPage;
VAR  idx:LONGINT;
     Group:TGroupBox;
     Lab:TLabel;
BEGIN
     idx := Notebook.Pages.Add(LoadNLSStr(SiEditor));
     EditPage := TPage(Notebook.Pages.Objects[idx]);
     EditPage.PenColor := clStaticText;
     EditPage.HelpContext := hctxDialogGeneralSettingsEditor;
     SetMouseHintNLS(EditPage,SiEditorHint);

     Group := InsertGroupBox(EditPage,20,10,190,280,'');
     SetMouseHintNLS(Group,SiEditorHint);

     InsertCheck := InsertCheckBoxNLS(Group,15,250,170,20,SiInsertMode,0);
     InsertCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(InsertCheck,SiInsertModeHint);

     IndentCheck := InsertCheckBoxNLS(Group,15,230,170,20,SiAutoIndentMode,0);
     IndentCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(IndentCheck,SiAutoIndentModeHint);

     AddIndentCheck := InsertCheckBoxNLS(Group,15,210,170,20,SiAdditionalIndent,0);
     AddIndentCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(AddIndentCheck,SiAdditionalIndentHint);

     UnindentCheck := InsertCheckBoxNLS(Group,15,190,170,20,SiUnIndent,0);
     UnindentCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(UnindentCheck,SiUnIndentHint);

     ClimbCheck := InsertCheckBoxNLS(Group,15,170,170,20,SiCursorClimbs,0);
     ClimbCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(ClimbCheck,SiCursorClimbsHint);

     Click2Check := InsertCheckBoxNLS(Group,15,150,170,20,SiDoubleClickSelLine,0);
     Click2Check.OnClick := EvEditorModified;
     SetMouseHintNLS(Click2Check,SiDoubleClickSelLineHint);

     BlockCheck := InsertCheckBoxNLS(Group,15,130,170,20,SiBlockSelection,0);
     BlockCheck.OnClick := EvEditorModified;
     IF Application.DBCSSystem THEN
     BEGIN
          SetMouseHintNLS(BlockCheck,SiBlockSelectionHintDBCS);
          BlockCheck.Enabled := FALSE;
     END
     ELSE SetMouseHintNLS(BlockCheck,SiBlockSelectionHint);

     PersistCheck := InsertCheckBoxNLS(Group,15,110,170,20,SiPersistentBlocks,0);
     PersistCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(PersistCheck,SiPersistentBlocksHint);

     OverCheck := InsertCheckBoxNLS(Group,15,90,170,20,SiOverwriteBlocks,0);
     OverCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(OverCheck,SiOverwriteBlocksHint);

     UndoCheck := InsertCheckBoxNLS(Group,15,70,170,20,SiUndoGroups,0);
     UndoCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(UndoCheck,SiUndoGroupsHint);

     SmartCheck := InsertCheckBoxNLS(Group,15,50,170,20,SiSmartTab,0);
     SmartCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(SmartCheck,SiSmartTabHint);

     HomeCheck := InsertCheckBoxNLS(Group,15,30,170,20,SiHomeToFirstWord,0);
     HomeCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(HomeCheck,SiHomeToFirstWordHint);

     BracketCheck := InsertCheckBoxNLS(Group,15,10,170,20,SiAutoBracket,0);
     BracketCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(BracketCheck,SiAutoBracketHint);


     Group := InsertGroupBox(EditPage,220,90,190,200,'');
     SetMouseHintNLS(Group,SiEditorHint);

     BackupCheck := InsertCheckBoxNLS(Group,15,170,170,20,SiCreateBackups,0);
     BackupCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(BackupCheck,SiCreateBackupsHint);

     AppBakCheck := InsertCheckBoxNLS(Group,15,150,170,20,SiAppendBAK,0);
     AppBakCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(AppBakCheck,SiAppendBAKHint);

     TextCheck := InsertCheckBoxNLS(Group,15,130,170,20,SiSearchTextAtCursor,0);
     TextCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(TextCheck,SiSearchTextAtCursorHint);

     HiliteCheck := InsertCheckBoxNLS(Group,15,110,170,20,SiSyntaxHighlight,0);
     HiliteCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(HiliteCheck,SiSyntaxHighlightHint);

     OpenCheck := InsertCheckBoxNLS(Group,15,90,170,20,SiChangeDir,0);
     OpenCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(OpenCheck,SiChangeDirHint);

     FullCheck := InsertCheckBoxNLS(Group,15,70,170,20,SiFullPathInTitle,0);
     FullCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(FullCheck,SiFullPathInTitleHint);

     WrapCheck := InsertCheckBoxNLS(Group,15,40,110,20,SiWordWrap,0);
     WrapCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(WrapCheck,SiWordWrapHint);

     WrapEdit := InsertEdit(Group,130,40,50,25,'','');
     WrapEdit.Alignment := taRightJustify;
     WrapEdit.OnChange := EvEditorModified;
     SetMouseHintNLS(WrapEdit,SiColumnForWordWrapping);

     SaveCheck := InsertCheckBoxNLS(Group,15,10,110,20,SiAutoSave,0);
     SaveCheck.OnClick := EvEditorModified;
     SetMouseHintNLS(SaveCheck,SiAutoSaveHint);

     SaveEdit := InsertEdit(Group,130,10,50,25,'','');
     SaveEdit.Alignment := taRightJustify;
     SaveEdit.OnChange := EvEditorModified;
     SetMouseHintNLS(SaveEdit,SiNumberOfModifications);


     Group := InsertGroupBox(EditPage,220,10,190,70,'');
     SetMouseHintNLS(Group,SiEditorHint);

     Lab := InsertLabelNLS(Group,15,35,110,20,SiTabulatorSize);
     Lab.PenColor := clWindowText;
     SetMouseHintNLS(Lab,SiEditorHint);
     TabEdit := InsertEdit(Group,130,35,50,25,'','');
     TabEdit.Alignment := taRightJustify;
     TabEdit.OnChange := EvEditorModified;
     SetMouseHintNLS(TabEdit,SiTabulatorSpaceSize);

     Lab := InsertLabelNLS(Group,15,10,110,20,SiUndoEvents);
     Lab.PenColor := clWindowText;
     SetMouseHintNLS(Lab,SiEditorHint);
     UndoEdit := InsertEdit(Group,130,10,50,25,'','');
     UndoEdit.Alignment := taRightJustify;
     UndoEdit.OnChange := EvEditorModified;
     SetMouseHintNLS(UndoEdit,SiCountOfUndoableOperations);


     Lab := InsertLabelNLS(EditPage,420,272,120,20,SiKeyMapping);
     SetMouseHintNLS(Lab,SiEditorHint);
     KeyCombo := InsertComboBox(EditPage,420,250,110,22,csDropDownList);
     SetMouseHintNLS(KeyCombo,SiKeystrokeMapping);
     KeyCombo.OnItemSelect := EvKeySelect;


     Group := InsertGroupBoxNLS(EditPage,420,170,110,75,SiCodeEditor);
     SetMouseHintNLS(Group,SiEditorHint);

     TabRadio := InsertRadioButtonNLS(Group,15,30,85,20,SiTabSet,0);
     TabRadio.OnClick := EvEditorModified;
     SetMouseHintNLS(TabRadio,SiTabSetHint);

     MDIRadio := InsertRadioButtonNLS(Group,15,10,85,20,SiMDI,0);
     MDIRadio.OnClick := EvEditorModified;
     SetMouseHintNLS(MDIRadio,SiMDIHint);


     Group := InsertGroupBoxNLS(EditPage,420,90,110,75,SiMouseShape);
     SetMouseHintNLS(Group,SiEditorHint);

     MArrowRadio := InsertRadioButtonNLS(Group,15,30,85,20,SiArrow,0);
     MArrowRadio.OnClick := EvEditorModified;
     SetMouseHintNLS(MArrowRadio,SiArrowHint);

     MIBeamRadio := InsertRadioButtonNLS(Group,15,10,85,20,SiIBeam,0);
     MIBeamRadio.OnClick := EvEditorModified;
     SetMouseHintNLS(MIBeamRadio,SiIBeamHint);


     Group := InsertGroupBoxNLS(EditPage,420,10,110,75,SiCaretShape);
     SetMouseHintNLS(Group,SiEditorHint);

     CUnderRadio := InsertRadioButtonNLS(Group,15,30,85,20,SiUnderline,0);
     CUnderRadio.OnClick := EvEditorModified;
     SetMouseHintNLS(CUnderRadio,SiUnderlineHint);

     CVerticalRadio := InsertRadioButtonNLS(Group,15,10,85,20,SiVertical,0);
     CVerticalRadio.OnClick := EvEditorModified;
     SetMouseHintNLS(CVerticalRadio,SiVerticalHint);


     {initialize}
     WITH TempIdeSettings.EditOpt DO
     BEGIN
          InsertCheck.Checked := Options * [eo_InsertMode] <> [];
          IndentCheck.Checked := Options * [eo_AutoIndent] <> [];
          AddIndentCheck.Checked := Options * [eo_AddIndent] <> [];
          UnindentCheck.Checked := Options * [eo_Unindent] <> [];
          ClimbCheck.Checked := Options * [eo_CursorClimb] <> [];
          Click2Check.Checked := Options * [eo_2ClickLine] <> [];
          BlockCheck.Checked := Select = es_Column;
          PersistCheck.Checked := Options * [eo_PersistentBlock] <> [];
          OverCheck.Checked := Options * [eo_OverwriteBlock] <> [];
          UndoCheck.Checked := Options * [eo_UndoGroups] <> [];
          SmartCheck.Checked := Options * [eo_SmartTabs] <> [];
          HomeCheck.Checked := Options * [eo_HomeFirstWord] <> [];
          BracketCheck.Checked := Options * [eo_AutoBracket] <> [];

          BackupCheck.Checked := Behaviour * [eb_Backups] <> [];
          AppBakCheck.Checked := Behaviour * [eb_AppendBAK] <> [];
          TextCheck.Checked := Behaviour * [eb_TextFromCursor] <> [];
          HiliteCheck.Checked := Behaviour * [eb_SyntaxHigh] <> [];
          OpenCheck.Checked := Behaviour * [eb_ChangeDirOnOpen] <> [];
          FullCheck.Checked := Behaviour * [eb_FullNameTitle] <> [];
          WrapCheck.Checked := Options * [eo_WordWrap] <> [];
          SaveCheck.Checked := Behaviour * [eb_AutoSave] <> [];

          WrapEdit.Text := tostr(WrapColumn);
          SaveEdit.Text := tostr(SaveEvents);
          WrapEdit.Enabled := WrapCheck.Checked;
          SaveEdit.Enabled := SaveCheck.Checked;
          TabEdit.Text := tostr(TabulatorSize);
          UndoEdit.Text := tostr(UndoEvents);

          KeyCombo.Items.Add('WordStar');
          KeyCombo.Items.Add('CUA');
          KeyCombo.Items.Add('Default');
          KeyCombo.Items.Add('Custom');
          KeyCombo.Text := KeyCombo.Items[LONGINT(KeyMap)];

          MArrowRadio.Checked := Mouse = em_Arrow;
          MIBeamRadio.Checked := Mouse = em_IBeam;

          CUnderRadio.Checked := Cursor = ec_Underline;
          CVerticalRadio.Checked := Cursor = ec_Vertical;

          TabRadio.Checked := Style = cs_TabSet;
          MDIRadio.Checked := Style = cs_MDI;
     END;
END;


PROCEDURE TGeneralDialog.StoreEditorPage;
VAR  c:INTEGER;
     count:LONGINT;
BEGIN
     WITH TempIdeSettings.EditOpt DO
     BEGIN
          Options := [];
          Behaviour := [];
          Select := es_NonInclusive;

          IF InsertCheck.Checked THEN Include(Options, eo_InsertMode);
          IF IndentCheck.Checked THEN Include(Options, eo_AutoIndent);
          IF AddIndentCheck.Checked THEN Include(Options, eo_AddIndent);
          IF UnindentCheck.Checked THEN Include(Options, eo_Unindent);
          IF ClimbCheck.Checked THEN Include(Options, eo_CursorClimb);
          IF Click2Check.Checked THEN Include(Options, eo_2ClickLine);
          IF BlockCheck.Checked THEN Select := es_Column;
          IF PersistCheck.Checked THEN Include(Options, eo_PersistentBlock);
          IF OverCheck.Checked THEN Include(Options, eo_OverwriteBlock);
          IF UndoCheck.Checked THEN Include(Options, eo_UndoGroups);
          IF SmartCheck.Checked THEN Include(Options, eo_SmartTabs);
          IF HomeCheck.Checked THEN Include(Options, eo_HomeFirstWord);
          IF BracketCheck.Checked THEN Include(Options, eo_AutoBracket);

          IF BackupCheck.Checked THEN Include(Behaviour, eb_Backups);
          IF AppBakCheck.Checked THEN Include(Behaviour, eb_AppendBAK);
          IF TextCheck.Checked THEN Include(Behaviour, eb_TextFromCursor);
          IF HiliteCheck.Checked THEN Include(Behaviour, eb_SyntaxHigh);
          IF OpenCheck.Checked THEN Include(Behaviour, eb_ChangeDirOnOpen);
          IF FullCheck.Checked THEN Include(Behaviour, eb_FullNameTitle);
          IF WrapCheck.Checked THEN Include(Options, eo_WordWrap);
          IF SaveCheck.Checked THEN Include(Behaviour, eb_AutoSave);

          val(SaveEdit.Text,count,c);
          IF c = 0 THEN SaveEvents := count;
          val(WrapEdit.Text,count,c);
          IF c = 0 THEN WrapColumn := count;
          val(TabEdit.Text,count,c);
          IF c = 0 THEN TabulatorSize := count;
          val(UndoEdit.Text,count,c);
          IF c = 0 THEN UndoEvents := count;

          IF KeyCombo.Text = KeyCombo.Items[0] THEN KeyMap := km_WordStar;
          IF KeyCombo.Text = KeyCombo.Items[1] THEN KeyMap := km_CUA;
          IF KeyCombo.Text = KeyCombo.Items[2] THEN KeyMap := km_Default;
          IF KeyCombo.Text = KeyCombo.Items[3] THEN KeyMap := km_Custom;

          IF MArrowRadio.Checked
            THEN Mouse := em_Arrow
            ELSE Mouse := em_IBeam;

          IF CUnderRadio.Checked
            THEN Cursor := ec_Underline
            ELSE Cursor := ec_Vertical;

          IF TabRadio.Checked
            THEN Style := cs_TabSet
            ELSE Style := cs_MDI;
     END;
END;


PROCEDURE TGeneralDialog.InitColorPage;
VAR  idx,i:LONGINT;
     Group:TGroupBox;
     Lab:TLabel;
     AFont:TFont;
     s:STRING;
     p:INTEGER;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiColors));
  ColorPage := TPage(Notebook.Pages.Objects[idx]);
  ColorPage.PenColor := clStaticText;
  ColorPage.HelpContext := hctxDialogGeneralSettingsColors;
  SetMouseHintNLS(ColorPage,SiColorsHint);
  ColorPage.OnPaint := EvPaintColorPage;

  Lab := InsertLabelNLS(ColorPage,20,255,180,20,SiElement);
  SetMouseHintNLS(Lab,SiColorsHint);

  ColorList := InsertListBox(ColorPage,20,135,180,120,'');
  ColorList.OnItemFocus := EvColorItemFocused;
  SetMouseHintNLS(ColorList,SiColorListHint);

  Lab := InsertLabelNLS(ColorPage,220,255,120,20,SiColor);
  SetMouseHintNLS(Lab,SiColorsHint);

  ColorGrid := InsertColorGrid(ColorPage,220,135,120,120,go4x4);
  ColorGrid.ClickEnablesColor := TRUE;
  ColorGrid.OnItemFocus := EvColorFocused;
  SetMouseHintNLS(ColorGrid,SiColorGridHint);

  Lab := InsertLabelNLS(ColorPage,360,255,170,20,SiFont);
  SetMouseHintNLS(Lab,SiColorsHint);

  FontCombo := InsertComboBox(ColorPage,360,233,170,22,csDropDownList);
  FontCombo.Duplicates := FALSE;
  FontCombo.Sorted := TRUE;
  FontCombo.OnItemSelect := EvFontSelect;
  SetMouseHintNLS(FontCombo,SiFontComboHint);


  Group := InsertGroupBoxNLS(ColorPage,360,135,170,80,SiUseStandardsFor);
  SetMouseHintNLS(Group,SiColorsHint);

  FgCheck := InsertCheckBoxNLS(Group,15,35,130,20,SiForeground,0);
  FgCheck.OnClick := EvDefaultChange;
  SetMouseHintNLS(FgCheck,SiForeGroundHint);

  BgCheck := InsertCheckBoxNLS(Group,15,10,130,20,SiBackGround,0);
  BgCheck.OnClick := EvDefaultChange;
  SetMouseHintNLS(BgCheck,SiBackGroundHint);

  EditorSample.Create(ColorPage);
  EditorSample.GeneralDlg := SELF;
  EditorSample.SetWindowPos(20+2,10+2,510-4,115-4);
  ColorPage.InsertControl(EditorSample);
  SetMouseHintNLS(EditorSample,SiEditorSample);

  {initialize}
  ColorList.Items.AddObject(LoadNLSStr(SiPlainText),TObject(@TempIdeSettings.Colors.Editor.PlainText));
  ColorList.Items.AddObject(LoadNLSStr(SiReservedWord),TObject(@TempIdeSettings.Colors.Editor.ReservedWord));
  ColorList.Items.AddObject(LoadNLSStr(SiString),TObject(@TempIdeSettings.Colors.Editor.Strings));
  ColorList.Items.AddObject(LoadNLSStr(SiSymbol),TObject(@TempIdeSettings.Colors.Editor.Symbol));
  ColorList.Items.AddObject(LoadNLSStr(SiNumber),TObject(@TempIdeSettings.Colors.Editor.Number));
  ColorList.Items.AddObject(LoadNLSStr(SiAssembler),TObject(@TempIdeSettings.Colors.Editor.AsmBlock));
  ColorList.Items.AddObject(LoadNLSStr(SiMarkedBlock),TObject(@TempIdeSettings.Colors.Editor.MarkedBlock));
  ColorList.Items.AddObject(LoadNLSStr(SiSearchMatch),TObject(@TempIdeSettings.Colors.Editor.SearchMatch));
  ColorList.Items.AddObject(LoadNLSStr(SiValidBreak),TObject(@TempIdeSettings.Colors.Editor.ValidBreak));
  ColorList.Items.AddObject(LoadNLSStr(SiInvalidBreak),TObject(@TempIdeSettings.Colors.Editor.InvalidBreak));
  ColorList.Items.AddObject(LoadNLSStr(SiExecPoint),TObject(@TempIdeSettings.Colors.Editor.ExecPoint));
  ColorList.Items.AddObject(LoadNLSStr(SiErrLine),TObject(@TempIdeSettings.Colors.Editor.ErrorLine));
  ColorList.Items.AddObject(LoadNLSStr(SiRightMargin),TObject(@TempIdeSettings.Colors.Editor.RightMargin));
  ColorList.Items.AddObject(LoadNLSStr(SiComment1),TObject(@TempIdeSettings.Colors.Editor.Comment1));
  ColorList.Items.AddObject(LoadNLSStr(SiComment2),TObject(@TempIdeSettings.Colors.Editor.Comment2));
  ColorList.Items.AddObject(LoadNLSStr(SiComment3),TObject(@TempIdeSettings.Colors.Editor.Comment3));
  ColorList.Items.AddObject(LoadNLSStr(SiComment4),TObject(@TempIdeSettings.Colors.Editor.Comment4));
  ColorList.Items.AddObject(LoadNLSStr(SiCompSwitch),TObject(@TempIdeSettings.Colors.Editor.Comment5));
  ColorList.ItemIndex := 0;

  FOR i := 0 TO Screen.FontCount-1 DO
  BEGIN
       AFont := Screen.Fonts[i];
       IF AFont <> NIL THEN
         IF AFont.Pitch = fpFixed THEN
           IF AFont.FontType = ftBitmap THEN
           BEGIN
                FontCombo.Items.AddObject(AFont.FaceName +' '+
                    tostr(AFont.Height) +'x'+ tostr(AFont.Width), AFont);
           END;
  END;

  IF TempIdeSettings.Fonts.EditorFont <> '' THEN
  BEGIN
       s := TempIdeSettings.Fonts.EditorFont;
       p := pos('.',s);
       IF p > 0 THEN FontCombo.Text := copy(s,p+1,255) +' '+ copy(s,1,p-1);
  END
  ELSE {System.FixedFont}
  BEGIN
       AFont := Screen.FixedFont;
       IF AFont <> NIL THEN
         IF AFont.Pitch = fpFixed THEN
           IF AFont.FontType = ftBitmap THEN
           BEGIN
                FontCombo.Text := AFont.FaceName +' '+
                    tostr(AFont.Height) +'x'+ tostr(AFont.Width);
           END;
  END;
END;


PROCEDURE TGeneralDialog.StoreColorPage;
VAR  AFont:TFont;
BEGIN
  IF FontIndex <> -1 THEN {ein Font wurde selektiert}
  BEGIN
       AFont := TFont(FontCombo.Items.Objects[FontIndex]);
       TempIdeSettings.Fonts.EditorFont :=
           tostr(AFont.Height)+'x'+tostr(AFont.Width)+'.'+AFont.FaceName;
  END;
END;


PROCEDURE TGeneralDialog.InitFormatPage;
VAR  idx:LONGINT;
     Group:TGroupBox;
     Lab:TLabel;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiFormat));
  FormatPage := TPage(Notebook.Pages.Objects[idx]);
  FormatPage.PenColor := clStaticText;
  FormatPage.HelpContext := hctxDialogGeneralSettingsFormat;
  SetMouseHintNLS(FormatPage,SiFormatHint);
  FormatPage.OnPaint := EvPaintColorPage;


  Group := InsertGroupBoxNLS(FormatPage,20,165,140,110,SiIdentifierStyle);
  SetMouseHintNLS(Group,SiFormatHint);

  UpperRadio := InsertRadioButtonNLS(Group,15,60,120,25,SiUpperCase,0);
  UpperRadio.OnClick := EvIdentifierStyle;
  SetMouseHintNLS(UpperRadio,SiUpperCaseHint);

  LowerRadio := InsertRadioButtonNLS(Group,15,35,120,25,SiLowerCase,0);
  LowerRadio.OnClick := EvIdentifierStyle;
  SetMouseHintNLS(LowerRadio,SiLowerCaseHint);

  MixedRadio := InsertRadioButtonNLS(Group,15,10,120,25,SiMixed,0);
  MixedRadio.OnClick := EvIdentifierStyle;
  SetMouseHintNLS(MixedRadio,SiMixedHint);


  Group := InsertGroupBoxNLS(FormatPage,180,140,200,135,SiIndention);
  SetMouseHintNLS(Group,SiFormatHint);

  Lab := InsertLabelNLS(Group,15,90,50,20,SiBlock);
  SetMouseHintNLS(Lab,SiFormatHint);

  BlockScroll := InsertScrollBar(Group,70,90,110,20,sbHorizontal);
  BlockScroll.SetScrollRange(0,15,1);
  BlockScroll.OnScroll := EvIndentScroll;
  SetMouseHintNLS(BlockScroll,SiBlockIndentionHint);

  Lab := InsertLabelNLS(Group,15,65,50,20,SiScope);
  SetMouseHintNLS(Lab,SiFormatHint);

  ScopeScroll := InsertScrollBar(Group,70,65,110,20,sbHorizontal);
  ScopeScroll.SetScrollRange(0,15,1);
  ScopeScroll.OnScroll := EvIndentScroll;
  SetMouseHintNLS(ScopeScroll,SiScopeIndention);

  Lab := InsertLabelNLS(Group,15,40,50,20,SiField);
  SetMouseHintNLS(Lab,SiFormatHint);

  FieldScroll := InsertScrollBar(Group,70,40,110,20,sbHorizontal);
  FieldScroll.SetScrollRange(0,15,1);
  FieldScroll.OnScroll := EvIndentScroll;
  SetMouseHintNLS(FieldScroll,SiFieldIndention);

  Lab := InsertLabelNLS(Group,15,15,50,20,SiSpace);
  SetMouseHintNLS(Lab,SiFormatHint);

  SpaceScroll := InsertScrollBar(Group,70,15,110,20,sbHorizontal);
  SpaceScroll.SetScrollRange(0,15,1);
  SpaceScroll.OnScroll := EvIndentScroll;
  SetMouseHintNLS(SpaceScroll,SiSpaceBetweenIdents);


  Group := InsertGroupBoxNLS(FormatPage,400,215,140,60,SiLineBreak);
  SetMouseHintNLS(Group,SiFormatHint);

  Lab := InsertLabelNLS(Group,10,10,40,20,SiAfter);
  SetMouseHintNLS(Lab,SiFormatHint);

  BreakEdit := InsertEdit(Group,50,10,30,25,'','');
  BreakEdit.Alignment := taRightJustify;
  BreakEdit.OnChange := EvEditorModified;
  SetMouseHintNLS(BreakEdit,SiCountOfCharsBeforeBreak);

  Lab := InsertLabelNLS(Group,85,10,50,20,SiChars);
  SetMouseHintNLS(Lab,SiFormatHint);

  EditorSample2.Create(FormatPage);
  EditorSample2.GeneralDlg := SELF;
  EditorSample2.SetWindowPos(20+2,10+2,510-4,115-4);
  FormatPage.InsertControl(EditorSample2);
  SetMouseHintNLS(EditorSample2,SiEditorSample);


  {initialize}
  WITH TempIdeSettings.CodeGen DO
  BEGIN
       CASE IdentifierStyle OF
         is_Uppercase: UpperRadio.Checked := TRUE;
         is_Lowercase: LowerRadio.Checked := TRUE;
         is_Mixed:     MixedRadio.Checked := TRUE;
       END;

       BlockScroll.Position := IndentBlock;
       ScopeScroll.Position := IndentScope;
       FieldScroll.Position := IndentField;
       SpaceScroll.Position := IndentSpace;

       BreakEdit.Text := tostr(LineBreak);
  END;
END;


PROCEDURE TGeneralDialog.StoreFormatPage;
VAR  c,e:INTEGER;
BEGIN
  {wird schon fast alles ber die Events gespeichert}

  WITH TempIdeSettings.CodeGen DO
  BEGIN
       val(BreakEdit.Text,c,e);
       IF e = 0 THEN LineBreak := c;
  END;
END;


PROCEDURE TGeneralDialog.InitDesignPage;
VAR  idx:LONGINT;
  Group:TGroupBox;
  Lab:TLabel;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiDesigner));
  DesignPage := TPage(Notebook.Pages.Objects[idx]);
  DesignPage.PenColor := clStaticText;
  DesignPage.HelpContext := hctxDialogGeneralSettingsDesigner;
  SetMouseHintNLS(DesignPage,SiDesignerHint);


  Group := InsertGroupBoxNLS(DesignPage,20,100,160,175,SiGrid);
  SetMouseHintNLS(Group,SiDesignerHint);

  Lab := InsertLabelNLS(Group,15,125,50,20,SiWidth);
  SetMouseHintNLS(Lab,SiDesignerHint);

  GWidthEdit := InsertEdit(Group,70,125,60,20,'','');
  GWidthEdit.Alignment := taRightJustify;
  GWidthEdit.OnChange := EvDesignerModified;
  SetMouseHintNLS(GWidthEdit,SiGridWidthHint);

  Lab := InsertLabelNLS(Group,15,95,50,20,SiHeight);
  SetMouseHintNLS(Lab,SiDesignerHint);

  GHeightEdit := InsertEdit(Group,70,95,60,20,'','');
  GHeightEdit.Alignment := taRightJustify;
  GHeightEdit.OnChange := EvDesignerModified;
  SetMouseHintNLS(GHeightEdit,SiGridHeightHint);

  GShowCheck := InsertCheckBoxNLS(Group,15,40,130,20,SiShow,0);
  GShowCheck.OnClick := EvDesignerModified;
  SetMouseHintNLS(GShowCheck,SiShowHint);

  GActiveCheck := InsertCheckBoxNLS(Group,15,15,130,20,SiActivated,0);
  GActiveCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(GActiveCheck,SiActivatedHint);


  Group := InsertGroupBoxNLS(DesignPage,200,195,180,80,SiComponentInsertMode);
  SetMouseHintNLS(Group,SiDesignerHint);

  DropMoveRadio := InsertRadioButtonNLS(Group,15,35,130,20,SiDropAndMove,0);
  DropMoveRadio.OnClick := EvIdeModified;
  SetMouseHintNLS(DropMoveRadio,SiDropAndMoveHint);

  DropSizeRadio := InsertRadioButtonNLS(Group,15,10,130,20,SiDropAndSize,0);
  DropSizeRadio.OnClick := EvIdeModified;
  SetMouseHintNLS(DropSizeRadio,SiDropAndSizeHint);


  Group := InsertGroupBoxNLS(DesignPage,200,100,180,80,SiMultiSelectionMode);
  SetMouseHintNLS(Group,SiDesignerHint);

  SelIncludeRadio := InsertRadioButtonNLS(Group,15,35,130,20,SiIncludeRect,0);
  SelIncludeRadio.OnClick := EvIdeModified;
  SetMouseHintNLS(SelIncludeRadio,SiIncludeRectHint);

  SelTouchRadio := InsertRadioButtonNLS(Group,15,10,130,20,SiTouchRect,0);
  SelTouchRadio.OnClick := EvIdeModified;
  SetMouseHintNLS(SelTouchRadio,SiTouchRectHint);


  Group := InsertGroupBoxNLS(DesignPage,400,195,130,80,SiNewForm);
  SetMouseHintNLS(Group,SiDesignerHint);

  AutoCreateCheck := InsertCheckBoxNLS(Group,15,35,110,20,SiAutoCreation,0);
  AutoCreateCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(AutoCreateCheck,SiAutoCreationHint);


  {initialize}
  WITH TempIdeSettings.Designer DO
  BEGIN
       GWidthEdit.Text := tostr(GridWidth);
       GHeightEdit.Text := tostr(GridHeight);

       GShowCheck.Checked := GridVisible;
       GActiveCheck.Checked := GridActive;

       DropMoveRadio.Checked := InsertMode = ci_DropMove;
       DropSizeRadio.Checked := InsertMode = ci_DropSize;

       SelIncludeRadio.Checked := MultiSelectMode = cs_Include;
       SelTouchRadio.Checked := MultiSelectMode = cs_Touch;

       AutoCreateCheck.Checked := AutoCreateForm;
  END;
END;


PROCEDURE TGeneralDialog.StoreDesignPage;
VAR  v,c:INTEGER;
BEGIN
     WITH TempIdeSettings.Designer DO
     BEGIN
          val(GWidthEdit.Text,v,c);
          IF c = 0 THEN GridWidth := v;

          val(GHeightEdit.Text,v,c);
          IF c = 0 THEN GridHeight := v;

          GridVisible := GShowCheck.Checked;
          GridActive := GActiveCheck.Checked;

          IF DropMoveRadio.Checked THEN InsertMode := ci_DropMove
          ELSE InsertMode := ci_DropSize;

          IF SelIncludeRadio.Checked THEN MultiSelectMode := cs_Include
          ELSE MultiSelectMode := cs_Touch;

          AutoCreateForm := AutoCreateCheck.Checked;
     END;
END;


PROCEDURE TGeneralDialog.InitBrowsePage;
VAR  idx,i:LONGINT;
     Group:TGroupBox;
BEGIN
     idx := Notebook.Pages.Add(LoadNLSStr(SiBrowser));
     BrowsePage := TPage(Notebook.Pages.Objects[idx]);
     BrowsePage.PenColor := clStaticText;
     BrowsePage.HelpContext := hctxDialogGeneralSettingsBrowser;
     SetMouseHintNLS(BrowsePage,SiBrowserHint);


     Group := InsertGroupBoxNLS(BrowsePage,20,10,170,265,SiBrowsingInfo);
     SetMouseHintNLS(Group,SiBrowserHint);

     BrowseCheck[Browser_Constants] := InsertCheckBoxNLS(Group,15,220,150,20,SiConstants,0);
     BrowseCheck[Browser_Constants].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Constants],SiConstantsHint);

     BrowseCheck[Browser_Procedures] := InsertCheckBoxNLS(Group,15,200,150,20,SiProcedures,0);
     BrowseCheck[Browser_Procedures].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Procedures],SiProceduresHint);

     BrowseCheck[Browser_Types] := InsertCheckBoxNLS(Group,15,180,150,20,SiTypes,0);
     BrowseCheck[Browser_Types].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Types],SiTypesHint);

     BrowseCheck[Browser_Variables] := InsertCheckBoxNLS(Group,15,160,150,20,SiVariables,0);
     BrowseCheck[Browser_Variables].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Variables],SiVariablesHint);

     BrowseCheck[Browser_Properties] := InsertCheckBoxNLS(Group,15,140,150,20,SiProperties,0);
     BrowseCheck[Browser_Properties].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Properties],SiPropertiesHint);

     BrowseCheck[Browser_Inherited] := InsertCheckBoxNLS(Group,15,115,150,20,SiInherited,0);
     BrowseCheck[Browser_Inherited].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Inherited],SiInheritedHint);

     BrowseCheck[Browser_Virtual] := InsertCheckBoxNLS(Group,15,95,150,20,SiVirtual,0);
     BrowseCheck[Browser_Virtual].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Virtual],SiVirtualHint);

     BrowseCheck[Browser_Private] := InsertCheckBoxNLS(Group,15,70,150,20,SiPrivate,0);
     BrowseCheck[Browser_Private].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Private],SiPrivateHint);

     BrowseCheck[Browser_Protected] := InsertCheckBoxNLS(Group,15,50,150,20,SiProtected,0);
     BrowseCheck[Browser_Protected].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Protected],SiProtectedHint);

     BrowseCheck[Browser_Public] := InsertCheckBoxNLS(Group,15,30,150,20,SiPublic,0);
     BrowseCheck[Browser_Public].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Public],SiPublicHint);

     BrowseCheck[Browser_Published] := InsertCheckBoxNLS(Group,15,10,150,20,SiPublished,0);
     BrowseCheck[Browser_Published].OnClick := EvIdeModified;
     SetMouseHintNLS(BrowseCheck[Browser_Published],SiPublishedHint);


     Group := InsertGroupBoxNLS(BrowsePage,210,170,260,105,SiBrowsingFiles);
     SetMouseHintNLS(Group,SiBrowserHint);

     RTLCheck := InsertCheckBoxNLS(Group,15,60,240,20,SiRTL,0);
     RTLCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(RTLCheck,SiRTLHint);

     SPCCCheck := InsertCheckBoxNLS(Group,15,35,240,20,SiSPCC,0);
     SPCCCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(SPCCCheck,SiSPCCHint);

     PrjCheck := InsertCheckBoxNLS(Group,15,10,240,20,SiProjectModuleFiles,0);
     PrjCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(PrjCheck,SiProjectModuleFilesHint);


     {initialize}
     WITH TempIdeSettings.Browse DO
     BEGIN
          FOR i := Browser_Constants TO Browser_Published DO
          BEGIN
               BrowseCheck[i].Checked := Buttons[i];
          END;

          RTLCheck.Checked := Files * [bf_RTL] <> [];
          SPCCCheck.Checked := Files * [bf_SPCC] <> [];
          PrjCheck.Checked := Files * [bf_Project] <> [];
     END;
END;


PROCEDURE TGeneralDialog.StoreBrowsePage;
VAR  i:LONGINT;
BEGIN
     WITH TempIdeSettings.Browse DO
     BEGIN
          Files := [];

          FOR i := Browser_Constants TO Browser_Published DO
          BEGIN
               Buttons[i] := BrowseCheck[i].Checked;
          END;

          IF RTLCheck.Checked THEN Include(Files, bf_RTL);
          IF SPCCCheck.Checked THEN Include(Files, bf_SPCC);
          IF PrjCheck.Checked THEN Include(Files, bf_Project);
     END;
END;

PROCEDURE TGeneralDialog.EvBrowseHelpCompFilename(Sender:TObject);

VAR CFOD:TOpenDialog;

BEGIN
  CFOD.Create(SELF);
//  CFOD.HelpContext := hctxDialogSetPrimary;
  CFOD.Title := LoadNLSStr(SiHelpProgramDirectory);
  CFOD.FileName := HelpCompFileNameEdit.Text;
  CFOD.AddFilter(LoadNLSStr(SiAllFiles)       + ' ('+ALL_FILES+')',ALL_FILES); // '*.*');
  CFOD.AddFilter(LoadNLSStr(SiExecutableFiles)+ ' ('+ALL_FILES_UC_EXE+')',ALL_FILES_UC_EXE); // '*'+EXT_EXE);
  CFOD.AddFilter(LoadNLSStr(SiBatchFiles)     + ' ('+ALL_FILES_UC_CMD+')',ALL_FILES_UC_CMD); //  '*'+EXT_CMD);
  CFOD.FilterIndex := 3;
  CFOD.DefaultExt := GetDefaultExt(ALL_FILES_UC_CMD); // '*'+EXT_CMD);
  IF CFOD.Execute THEN
    BEGIN
      HelpCompFileNameEdit.Text:=CFOD.Filename;
    END;
  CFOD.Destroy;
END;


Procedure TGeneralDialog.InitCompilerPage;

var idx  : LONGINT;
    Group: TGroupBox;
    Btn  : TSpeedButton;
    Lab  : TLabel;

Begin
  idx := Notebook.Pages.Add(LoadNLSStr(SiCompiler));
  CompilerPage := TPage(Notebook.Pages.Objects[idx]);
  CompilerPage.PenColor := clStaticText;
  CompilerPage.HelpContext := hctxDialogGeneralSettingsAuto;
  SetMouseHintNLS(CompilerPage,SiCompilerHint);

  Lab := InsertLabelNLS(CompilerPage,20,260,90,20, SiPriority);
  SetMouseHintNLS(Lab,SiPriorityHint);
  PrioCombo := InsertComboBox(CompilerPage,110,260,110,22,csDropDownList);
  SetMouseHintNLS(PrioCombo, SiPriorityHint);

//  Group := InsertGroupBox(CompilerPage,20,130,280,40,'Pascal-Compiler');
//  SetMouseHint(Group, 'Pascal-Compiler');

//  Group := InsertGroupBox(CompilerPage,20,130,500,120,'Help-Compiler');
  Group := InsertGroupBox(CompilerPage,20,20,500,230,'Help-Compiler');
  SetMouseHint(Group, 'Help-Compiler');

  HelpLanguages := InsertCheckListBox(Group,10,50,180,150);
  HelpLanguages.Duplicates:=FALSE;
//  HelpLanguages.OnStateChanged:=OnAppItemStateChanged;

// Programmstart nach der Compilierung
  Lab := InsertLabel(Group,10,10,90,20,'Compiler-Prg:');
  SetMouseHintNLS(Lab,SiDesignerHint);

  with TempIdeSettings do
    Begin
// Sprachen
      idx:=HelpLanguages.Items.Add(LoadNLSStr(SiLang_German)+', DE');
      if pos('DE',HelpCompilerLanguage)>0 then
        HelpLanguages.State[idx]:=clsChecked;
      idx:=HelpLanguages.Items.Add(LoadNLSStr(SiLang_English)+', EN');
      if pos('EN',HelpCompilerLanguage)>0 then
        HelpLanguages.State[idx]:=clsChecked;
      idx:=HelpLanguages.Items.Add(LoadNLSStr(SiLang_Dutch)+', NL');
      if pos('NL',HelpCompilerLanguage)>0 then
        HelpLanguages.State[idx]:=clsChecked;
      idx:=HelpLanguages.Items.Add(LoadNLSStr(SiLang_Italian)+', IT');
      if pos('IT',HelpCompilerLanguage)>0 then
        HelpLanguages.State[idx]:=clsChecked;


      HelpCompFileNameEdit := InsertEdit(Group,100,10,310,20,HelpCompilerFileName,'');
      HelpCompFileNameEdit.OnChange := EvIdeModified;
//  SetMouseHintNLS(PrjDirEdit,SiStdDirPrjOpen);

      Btn := InsertSpeedButtonNLS(Group,410,10,80,25, 0,SiBrowse,0);
      Btn.TabStop := FALSE;
      Btn.OnClick := EvBrowseHelpCompFilename;
//  SetMouseHintNLS(Btn,SiStdBrowseHint);

{initialize}
      PrioCombo.Items.Add('Idle');
      PrioCombo.Items.Add('Lowest');
      PrioCombo.Items.Add('Lower');
      PrioCombo.Items.Add('Normal');
      PrioCombo.Text := PrioCombo.Items[LONGINT(CompilerPriority)];
    End;
End;

PROCEDURE TGeneralDialog.StoreCompilerPage;

var Cou : LongInt;
    Txt1,Txt2 : String;

Begin
  with TempIdeSettings do
    Begin
      IF PrioCombo.Text = PrioCombo.Items[0] THEN CompilerPriority:=tpIdle;
      IF PrioCombo.Text = PrioCombo.Items[1] THEN CompilerPriority:=tpLowest;
      IF PrioCombo.Text = PrioCombo.Items[2] THEN CompilerPriority:=tpLower;
      IF PrioCombo.Text = PrioCombo.Items[3] THEN CompilerPriority:=tpNormal;
      HelpCompilerFileName:=HelpCompFileNameEdit.Text;
      HelpCompilerLanguage:='';
      For Cou:=0 to HelpLanguages.Items.Count-1 do
        if HelpLanguages.State[Cou]=clsChecked then
          Begin
            Split(HelpLanguages.Items.Strings[Cou],',',Txt1, Txt2);
            HelpCompilerLanguage:=HelpCompilerLanguage+trim(Txt2)+',';
          End;
      HelpCompilerLanguage[0]:=chr(length(HelpCompilerLanguage)-1);  // Letztes "," loeschen
    End
end;


PROCEDURE TGeneralDialog.InitAutoPage;
VAR  idx:LONGINT;
     Group:TGroupBox;
BEGIN
     idx := Notebook.Pages.Add(LoadNLSStr(SiAuto));
     AutoPage := TPage(Notebook.Pages.Objects[idx]);
     AutoPage.PenColor := clStaticText;
     AutoPage.HelpContext := hctxDialogGeneralSettingsAuto;
     SetMouseHintNLS(AutoPage,SiAutoHint);

     Group := InsertGroupBoxNLS(AutoPage,20,145,210,130,SiAutoSave);
     SetMouseHintNLS(Group,SiAutoHint);

     SFilesCheck := InsertCheckBoxNLS(Group,15,85,180,20,SiEditorFiles,0);
     SFilesCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(SFilesCheck,SiEditorFilesHint);

     SSCUCheck := InsertCheckBoxNLS(Group,15,60,180,20,SiSCUInfo,0);
     SSCUCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(SSCUCheck,SiSCUInfoHint);

     SProjectCheck := InsertCheckBoxNLS(Group,15,35,180,20,SiProjectSettings,0);
     SProjectCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(SProjectCheck,SiProjectSettingsHint);

     SINICheck := InsertCheckBoxNLS(Group,15,10,180,20,SiEnvironment,0);
     SINICheck.OnClick := EvIdeModified;
     SetMouseHintNLS(SINICheck,SiEnvironmentHint);


     Group := InsertGroupBoxNLS(AutoPage,250,120,220,155,SiActualizeAtSaveAs);
     SetMouseHintNLS(Group,SiAutoHint);

     RSourceCheck := InsertCheckBoxNLS(Group,15,110,200,20,SiFormSourceLoc,0);
     RSourceCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(RSourceCheck,SiFormSourceLocHint);

     RPrjFileCheck := InsertCheckBoxNLS(Group,15,85,200,20,SiProjectFileNames,0);
     RPrjFileCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(RPrjFileCheck,SiProjectFileNamesHint);

     RModulCheck := InsertCheckBoxNLS(Group,15,60,200,20,SiModuleIdentifier,0);
     RModulCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(RModulCheck,SiModuleIdentifierHint);

     RUsesCheck := InsertCheckBoxNLS(Group,15,35,200,20,SiUSESStatement,0);
     RUsesCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(RUsesCheck,SiUSESStatementHint);

     RSCUCheck := InsertCheckBoxNLS(Group,15,10,200,20,SiSCUResourceName,0);
     RSCUCheck.OnClick := EvIdeModified;
     SetMouseHintNLS(RSCUCheck,SiSCUResourceNameHint);

     {initialize}
     WITH TempIdeSettings DO
     BEGIN
          SFilesCheck.Checked := AutoSave * [as_EditorFiles] <> [];
          SSCUCheck.Checked := AutoSave * [as_SCU] <> [];
          SProjectCheck.Checked := AutoSave * [as_Project] <> [];
          SINICheck.Checked := AutoSave * [as_INI] <> [];

          RSourceCheck.Checked := AutoRename * [ar_FormLocation] <> [];
          RPrjFileCheck.Checked := AutoRename * [ar_ProjectFiles] <> [];
          RModulCheck.Checked := AutoRename * [ar_Unit] <> [];
          RUsesCheck.Checked := AutoRename * [ar_Uses] <> [];
          RSCUCheck.Checked := AutoRename * [ar_SCU] <> [];
     END;
END;


PROCEDURE TGeneralDialog.StoreAutoPage;
BEGIN
     WITH TempIdeSettings DO
     BEGIN
          AutoSave := [];
          IF SFilesCheck.Checked THEN Include(AutoSave, as_EditorFiles);
          IF SSCUCheck.Checked THEN Include(AutoSave, as_SCU);
          IF SProjectCheck.Checked THEN Include(AutoSave, as_Project);
          IF SINICheck.Checked THEN Include(AutoSave, as_INI);

          AutoRename := [];
          IF RSourceCheck.Checked THEN Include(AutoRename, ar_FormLocation);
          IF RPrjFileCheck.Checked THEN Include(AutoRename, ar_ProjectFiles);
          IF RModulCheck.Checked THEN Include(AutoRename, ar_Unit);
          IF RUsesCheck.Checked THEN Include(AutoRename, ar_Uses);
          IF RSCUCheck.Checked THEN Include(AutoRename, ar_SCU);
     END;
END;


PROCEDURE TGeneralDialog.InitGeneralPage;

VAR  idx:LONGINT;
     Group:TGroupBox;
     Btn:TSpeedButton;

BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiGeneral));
  GeneralPage := TPage(Notebook.Pages.Objects[idx]);
  GeneralPage.PenColor := clStaticText;
  GeneralPage.HelpContext := hctxDialogGeneralSettingsGeneral;
  SetMouseHintNLS(GeneralPage,SiGeneralHint);

  Group := InsertGroupBoxNLS(GeneralPage,20,70,200,230,SiGeneral);
  SetMouseHintNLS(Group,SiGeneralHint);

  HintsCheck := InsertCheckBoxNLS(Group,15,185,170,20,SiShowGlobalHints,0);
  HintsCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(HintsCheck,SiShowGlobalHintsHint);

  MsgViewCheck := InsertCheckBoxNLS(Group,15,160,170,20,SiOpenMessageView,0);
  MsgViewCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(MsgViewCheck,SiOpenMessageViewHint);

  FlatCheck := InsertCheckBoxNLS(Group,15,135,170,20,Si3DButtons,0);
  FlatCheck.OnClick := EvFlatBtnModified;
  SetMouseHintNLS(FlatCheck,Si3DButtonsHint);

  GlyphCheck := InsertCheckBoxNLS(Group,15,110,170,20,SiBitmapGlyph,0);
  GlyphCheck.OnClick := EvGlyphBtnModified;
  SetMouseHintNLS(GlyphCheck,SiBitmapGlyphHint);

  IconbarCheck := InsertCheckBoxNLS(Group,15,85,170,20,SiEditorIconbar,0);
  IconbarCheck.OnClick := EvIconbarModified;
  SetMouseHintNLS(IconbarCheck,SiEditorIconbarHint);

  LastPrjCheck := InsertCheckBoxNLS(Group,15,60,170,20,SiLoadLastPrj,0);
  LastPrjCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(LastPrjCheck,SiLoadLastPrjHint);

  AskRecompileCheck := InsertCheckBoxNLS(Group,15,35,170,20,SiAskRecompile,0);
  AskRecompileCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(AskRecompileCheck,SiAskRecompileHint);

  SoundCheck := InsertCheckBoxNLS(Group,15,10,170,20,SiSound,0);
  SoundCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(SoundCheck,SiSoundHint);


  Group := InsertGroupBoxNLS(GeneralPage,240,220,200,80,SiDroppingFile);
  SetMouseHintNLS(Group,SiGeneralHint);

  DropOpenRadio := InsertRadioButtonNLS(Group,15,35,180,20,SiDropOpen,0);
  DropOpenRadio.OnClick := EvIdeModified;
  SetMouseHintNLS(DropOpenRadio,SiDropOpenHint);

  DropImportRadio := InsertRadioButtonNLS(Group,15,10,180,20,SiDropImport,0);
  DropImportRadio.OnClick := EvIdeModified;
  SetMouseHintNLS(DropImportRadio,SiDropImportHint);

  Btn := InsertSpeedButtonNLS(GeneralPage,240,150,200,35, 0,SiApplicationFont,0);
  Btn.OnClick := EvApplFontClick;
  SetMouseHintNLS(Btn,SiApplicationFontHint);

  {initialize}
  WITH TempIdeSettings DO
    BEGIN
      HintsCheck.Checked := GlobalHints;
      MsgViewCheck.Checked := OpenMsgView;
      FlatCheck.Checked := not FlatButtons;
      GlyphCheck.Checked := ShowBitBtnGlyph;
      SoundCheck.Checked := EnableSound;
      IconbarCheck.Checked := EditorIconbar;
      LastPrjCheck.Checked := LoadLastPrj;
      AskRecompileCheck.Checked := AskRecompile;

      DropOpenRadio.Checked := DroppingFile = df_Open;
      DropImportRadio.Checked := DroppingFile = df_Import;
    END;
END;

PROCEDURE TGeneralDialog.StoreGeneralPage;
BEGIN
  WITH TempIdeSettings DO
    BEGIN
      GlobalHints := HintsCheck.Checked;
      OpenMsgView := MsgViewCheck.Checked;
      FlatButtons := not FlatCheck.Checked;
      ShowBitBtnGlyph := GlyphCheck.Checked;
      EditorIconbar := IconbarCheck.Checked;
      EnableSound := SoundCheck.Checked;
      LoadLastPrj := LastPrjCheck.Checked;
      AskRecompile := AskRecompileCheck.Checked;
      IF DropOpenRadio.Checked
        THEN DroppingFile := df_Open
        ELSE DroppingFile := df_Import;
    END;
END;

Procedure TGeneralDialog.InitPathPage;

VAR idx : LONGINT;
    Btn : TSpeedButton;
    Lab : TLabel;

Begin
  idx := Notebook.Pages.Add(LoadNLSStr(SiPath));
  PathPage := TPage(Notebook.Pages.Objects[idx]);
  PathPage.PenColor := clStaticText;
  PathPage.HelpContext := hctxDialogGeneralSettingsGeneral;
  SetMouseHintNLS(PathPage,SiPathHint);

  Lab := InsertLabelNLS(PathPage,20,260,200,20,SiProjectDir);
  SetMouseHintNLS(Lab,SiPathHint);

  PrjDirEdit := InsertEdit(PathPage,20,240,420,20,'','');
  PrjDirEdit.OnChange := EvIdeModified;
  SetMouseHintNLS(PrjDirEdit,SiStdDirPrjOpen);

  Btn := InsertSpeedButtonNLS(PathPage,440,240,80,25, 0,SiBrowse,0);
  Btn.TabStop := FALSE;
  Btn.OnClick := EvBrowsePrjPath;
  SetMouseHintNLS(Btn,SiStdBrowseHint);

  Lab := InsertLabelNLS(PathPage,20,200,200,20,SiTemplateDir);
  SetMouseHintNLS(Lab,SiPathHint);

  TemplateDirEdit := InsertEdit(PathPage,20,180,420,20,'','');
  TemplateDirEdit.OnChange := EvIdeModified;
  SetMouseHintNLS(PrjDirEdit,SiStdDirPrjOpen);

  Btn := InsertSpeedButtonNLS(PathPage,440,180,80,25, 0,SiBrowse,0);
  Btn.TabStop := FALSE;
  Btn.OnClick := EvBrowseTemplatePath;
  SetMouseHintNLS(Btn,SiStdBrowseHint);


  WITH TempIdeSettings DO
    Begin
      PrjDirEdit.Text     := ProjectDir;
      TemplateDirEdit.Text:= TemplateDir;
    End;
End;

Procedure TGeneralDialog.StorePathPage;

Begin
  WITH TempIdeSettings DO
    Begin
      ProjectDir := PrjDirEdit.Text;
      TemplateDir:= TemplateDirEdit.Text;
    End;
End;

PROCEDURE TGeneralDialog.InitCodeInsightPage;
VAR  idx:LONGINT;
     Group:TGroupBox;
     Lab:TLabel;
     i:LONGINT;
     pct,pctnew:PCodeTemplate;
BEGIN
  idx := Notebook.Pages.Add(LoadNLSStr(SiCodeInsight));
  CodeInsightPage := TPage(Notebook.Pages.Objects[idx]);
  CodeInsightPage.PenColor := clStaticText;
  CodeInsightPage.HelpContext := hctxDialogGeneralSettings;
  SetMouseHintNLS(CodeInsightPage,SiCodeInsightHint);


  Group := InsertGroupBoxNLS(CodeInsightPage,20,205,510,95,SiAutomaticFeatures);
  SetMouseHintNLS(Group,SiCodeInsightHint);

  ComplCheck := InsertCheckBoxNLS(Group,15,50,270,20,SiCodeCompletion,0);
  ComplCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(ComplCheck,SiCodeInsightHint);

  ParamCheck := InsertCheckBoxNLS(Group,15,30,270,20,SiCodeParameters,0);
  ParamCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(ParamCheck,SiCodeInsightHint);

  ToolTipCheck := InsertCheckBoxNLS(Group,15,10,270,20,SiTooltipExprEvaluation,0);
  ToolTipCheck.OnClick := EvIdeModified;
  SetMouseHintNLS(ToolTipCheck,SiCodeInsightHint);

  TimeTrack := InsertTrackBar(Group,315,35,175,40);
  TimeTrack.SliderSize := tssMedium;
  TimeTrack.Max := 1500;
  TimeTrack.Min := 500;
  TimeTrack.Frequency := 250;
  TimeTrack.PageSize := 250;
  TimeTrack.TickStyle := tsAuto;
  TimeTrack.OnChange := EvIdeModified;
  SetMouseHintNLS(TimeTrack,SiCodeInsightHint);

  Lab := InsertLabel(Group,315,10,30,20,'0,5');
  Lab.Alignment := taLeftJustify;
  SetMouseHintNLS(Lab,SiCodeInsightHint);

  Lab := InsertLabelNLS(Group,345,10,115,20,SiDelaySec);
  Lab.Alignment := taCenter;
  SetMouseHintNLS(Lab,SiCodeInsightHint);

  Lab := InsertLabel(Group,460,10,30,20,'1,5');
  Lab.Alignment := taRightJustify;
  SetMouseHintNLS(Lab,SiCodeInsightHint);

  Group := InsertGroupBoxNLS(CodeInsightPage,20,10,510,185,SiCodeTemplates);
  SetMouseHintNLS(Group,SiCodeInsightHint);

  Lab := InsertLabelNLS(Group,15,135,80,20,SiTemplates);
  SetMouseHintNLS(Lab,SiCodeInsightHint);

  TemplGrid.Create(Group);
  TemplGrid.SetWindowPos(95,95,305,65);
  TemplGrid.Parent := Group;
  TemplGrid.ColCount := 2;
  TemplGrid.DefaultRowHeight := 22; // 3 Zeilen
  TemplGrid.FixedCols := 0;
  TemplGrid.Options := [goBorder,goShowSelection,goAlwaysShowSelection,
                        goMouseSelect];
  TemplGrid.OnSelectCell := EvTemplateSelected;
  TemplGrid.RowCount := 1;
  TemplGrid.Scrollbars := ssVertical;
  TemplGrid.Cells[0,0] := LoadNLSStr(SiTemplateName);
  TemplGrid.Cells[1,0] := LoadNLSStr(SiTemplateDescription);
  TemplGrid.ColWidths[0] := 80;
  TemplGrid.ColWidths[1] := 210;


  TemplAddBtn := InsertSpeedButtonNLS(Group,415,130,80,30, 0,SiTemplateAdd,0);
  TemplAddBtn.OnClick := EvTemplateAdd;
  SetMouseHintNLS(TemplAddBtn,SiCodeInsightHint);

  TemplEditBtn := InsertSpeedButtonNLS(Group,415,90,80,30, 0,SiTemplateEdit,0);
  TemplEditBtn.OnClick := EvTemplateEdit;
  SetMouseHintNLS(TemplEditBtn,SiCodeInsightHint);

  TemplDeleteBtn := InsertSpeedButtonNLS(Group,415,50,80,30, 0,SiTemplateDelete,0);
  TemplDeleteBtn.OnClick := EvTemplateDelete;
  SetMouseHintNLS(TemplDeleteBtn,SiCodeInsightHint);


  Lab := InsertLabelNLS(Group,15,65,80,20,SiTemplateCode);
  SetMouseHintNLS(Lab,SiCodeInsightHint);

  TemplMemo := InsertMemo(Group,95,10,305,80,'');
  TemplMemo.Font := EditorFont;
  TemplMemo.OnExit := EvTemplateCodeExit;
  SetMouseHintNLS(TemplMemo,SiCodeInsightHint);

 {initialize}
  WITH TempIdeSettings DO
    BEGIN
      ComplCheck.Checked  := CodeInsight.CodeCompletion;
      ParamCheck.Checked  := CodeInsight.CodeParameter;
      ToolTipCheck.Checked:= CodeInsight.Tooltips;
      TimeTrack.Position  := CodeInsight.TimerValue;

      // copy code templates
      TempCodeTemplateList.Create;
      FOR i := 0 TO CodeTemplateList.Count-1 DO
        BEGIN
          pct := CodeTemplateList[i];

          new(pctnew);
          pctnew^.Name := pct^.Name;
          pctnew^.Description := pct^.Description;
          pctnew^.Strings.Create;
          pctnew^.Strings.Assign(pct^.Strings);
          TempCodeTemplateList.Add(pctnew);
        END;


      // read code templates
      TemplGrid.RowCount := TempCodeTemplateList.Count + 1;

      FOR i := 0 TO TempCodeTemplateList.Count-1 DO
        BEGIN
          pct := TempCodeTemplateList[i];
          TemplGrid.Cells[0,i+1] := pct^.Name;
          TemplGrid.Cells[1,i+1] := pct^.Description;
        END;

      TemplGrid.Col := 0;
      IF TemplGrid.RowCount > 1 THEN TemplGrid.Row := 1;

      UpdateTemplateControls;
    END;
END;


PROCEDURE FreeCodeTemplateList(VAR List:TList);

VAR  i:LONGINT;
     pct:PCodeTemplate;

BEGIN
  FOR i := 0 TO List.Count-1 DO
    BEGIN
      pct := List[i];
      pct^.Strings.Destroy;
      dispose(pct);
    END;
  List.Destroy;
  List := NIL;
END;


PROCEDURE TGeneralDialog.StoreCodeInsightPage;
BEGIN
  WITH TempIdeSettings DO
    BEGIN
      CodeInsight.CodeCompletion:= ComplCheck.Checked;
      CodeInsight.CodeParameter := ParamCheck.Checked;
      CodeInsight.Tooltips      := ToolTipCheck.Checked;
      CodeInsight.TimerValue    := TimeTrack.Position;
    END;
  FreeCodeTemplateList(CodeTemplateList);
  CodeTemplateList := TempCodeTemplateList;
END;


PROCEDURE GeneralDialog;

VAR  Dialog:TGeneralDialog;

BEGIN
  Dialog.Create(NIL);
  Dialog.HelpContext := hctxDialogGeneralSettings;
  IF Dialog.Execute
    THEN
      BEGIN
        Dialog.StoreEditorPage;
        Dialog.StoreColorPage;
        Dialog.StoreFormatPage;
        Dialog.StoreDesignPage;
        Dialog.StoreBrowsePage;
        Dialog.StoreCompilerPage;
        Dialog.StoreAutoPage;
        Dialog.StoreGeneralPage;
        Dialog.StorePathPage;
        Dialog.StoreCodeInsightPage;

        IdeSettings := Dialog.TempIdeSettings;
        IF Dialog.IdeModified THEN IdeSettings.Modified := TRUE;
        IF Dialog.EditorModified THEN
          BEGIN
            CodeEditor.Init;
            InitializeEditor(NIL);
          END;
        IF Dialog.DesignerModified THEN UpdateAllFormWindows;
        IF Dialog.FlatBtnModified THEN SetExplorerBtnLook(IdeSettings.FlatButtons);
        ShowBitBtnGlyph := IdeSettings.ShowBitBtnGlyph;
        IF Dialog.IconbarModified THEN UpdateIconbars(IdeSettings.EditorIconbar);
        SetMainMenuShortCuts(IdeSettings.EditOpt.KeyMap);
      END
    ELSE
      BEGIN
        IF Dialog.FlatBtnModified THEN SetExplorerBtnLook(IdeSettings.FlatButtons);
        ShowBitBtnGlyph := IdeSettings.ShowBitBtnGlyph;
        FreeCodeTemplateList(Dialog.TempCodeTemplateList);
      END;

  ActiveGeneralPage := Dialog.Notebook.PageIndex;
  Dialog.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Customize Settings Dialog                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TCustomizeDialog=CLASS(TDialog)
      PRIVATE
         LastHintControl:TControl;
         Notebook:TTabbedNotebook;
         SpeedModified:BOOLEAN;
         SpeedPage:TPage;
         MenuList:TListBox;
         MultiPage:TNotebook;
         TopPanel,BottomPanel:TPanel;
         TopSpeedList,BottomSpeedList:TList;
         OkButton,CancelButton,HelpButton:TBitBtn;
         PROCEDURE SetMouseHint(Control:TControl;AHint:LONGINT);
         PROCEDURE EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
         PROCEDURE EvMenuItemFocused(Sender:TObject;Index:LONGINT);
         PROCEDURE InitSpeedPage;
         PROCEDURE StoreSpeedPage;
         FUNCTION BuildSpeedBtn(SpeedPanel:TPanel;Cmd:TCommand):TSpeedButton;
         PROCEDURE ArrangeSpeedbarExample(SpeedPanel:TPanel);
         PROCEDURE EvDragOver(Sender,Source:TObject;X,Y:LongInt;State:TDragState;VAR Accept:Boolean);
         PROCEDURE EvEndDrag(Sender,Target:TObject;X,Y:LongInt);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
      PUBLIC
         DESTRUCTOR Destroy;OVERRIDE;
    END;


PROCEDURE TCustomizeDialog.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiCustomizeSettings);
     ClientWidth := 580;
     ClientHeight := 440;

     SpeedModified := FALSE;

     Notebook := InsertTabbedNotebook(SELF,0,50,580,390);
     Notebook.Align := alTop;
     Notebook.Pages.Clear;

     OkButton:=InsertBitBtnNLS(SELF,20,10,100,30,bkOk,SOkButton,SClickHereToAccept);
     CancelButton:=InsertBitBtnNLS(SELF,135,10,100,30,bkCancel,SCancelButton,SClickHereToCancel);
     HelpButton:=InsertBitBtnNLS(SELF,460,10,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);

     Screen.Cursor := crHourglass;

     TopSpeedList.Create;
     BottomSpeedList.Create;

     InitSpeedPage;

     Screen.Cursor := crDefault;

     Notebook.PageIndex := ActiveCustomizePage;
     //Notebook.AutoPopup := TRUE;
END;


DESTRUCTOR TCustomizeDialog.Destroy;
BEGIN
     Inherited Destroy;

     TopSpeedList.Destroy;
     BottomSpeedList.Destroy;
END;


PROCEDURE TCustomizeDialog.SetMouseHint(Control:TControl;AHint:LONGINT);
BEGIN
     Control.ParentShowHint := FALSE;
     Control.ShowHint := FALSE;
     Control.Hint := LoadNLSStr(AHint);
     Control.OnMouseMove := EvMouseHint;
END;


{$HINTS OFF}
PROCEDURE TCustomizeDialog.EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
BEGIN
     IF Sender IS TControl THEN
     BEGIN
          Notebook.PageHint := TControl(Sender).Hint;

          IF LastHintControl <> Sender THEN
          BEGIN
               IF LastHintControl <> NIL THEN
               BEGIN
                    LastHintControl.PenColor := clWindowText;
                    LastHintControl := NIL;
               END;
               IF (Sender IS TCheckBox) OR (Sender IS TRadioButton) THEN
               BEGIN
                    TControl(Sender).PenColor := clRed;
                    LastHintControl := TControl(Sender);
               END;
          END;
     END;
END;


PROCEDURE TCustomizeDialog.EvMenuItemFocused(Sender:TObject;Index:LONGINT);
BEGIN
     MultiPage.PageIndex := MenuList.ItemIndex;
     MenuList.CaptureFocus;
END;
{$HINTS ON}


PROCEDURE TCustomizeDialog.InitSpeedPage;
VAR  idx:LONGINT;
     Group:TGroupBox;
     Lab:TLabel;
     smr:TSibylMenuRecord;
     s:STRING;
     i,mpi:LONGINT;
     LastPage:TPage;
     Btn:TSpeedButton;
     x,y,w,m:LONGINT;

  PROCEDURE BuildSpeedList(SpeedPanel:TPanel;SpeedList,ToolList:TList);
  VAR  Btn:TSpeedButton;
  BEGIN
       FOR i := 0 TO ToolList.Count-1 DO
       BEGIN
            Btn := BuildSpeedBtn(SpeedPanel, TCommand(ToolList[i]));
            SpeedList.Add(Btn);
       END;
       ArrangeSpeedbarExample(SpeedPanel);
  END;

BEGIN
     idx := Notebook.Pages.Add(LoadNLSStr(SiSpeedbar));
     SpeedPage := TPage(Notebook.Pages.Objects[idx]);
     SpeedPage.PenColor := clStaticText;
     SpeedPage.HelpContext := hctxDialogCustomizeSettingsSpeedbar;
     SetMouseHint(SpeedPage,SiSpeedbarHint);

     SpeedPage.OnDragOver := EvDragOver;

     Group := InsertGroupBoxNLS(SpeedPage,20,230,500,60,0);
     SetMouseHint(Group,SiSpeedbarHint);

     m := Group.Height DIV 2;
     TopPanel := InsertPanel(Group,5,m,490,SpeedButtonSize,
                             bvNone,bvNone,1,'');
     SetMouseHint(TopPanel,SiSpeedbarHint);
     TopPanel.OnDragOver := EvDragOver;

     BottomPanel := InsertPanel(Group,5,m-SpeedButtonSize,490,SpeedButtonSize,
                                bvNone,bvNone,1,'');
     SetMouseHint(BottomPanel,SiSpeedbarHint);
     BottomPanel.OnDragOver := EvDragOver;


     MenuList := InsertListBox(SpeedPage,20,10,170,200,'');
     MenuList.OnItemFocus := EvMenuItemFocused;
     SetMouseHint(MenuList,SiMenuListHint);

     Group := InsertGroupBoxNLS(SpeedPage,220,60,300,150,SiAvailableSpeedItems);
     SetMouseHint(Group,SiSpeedbarHint);

     MultiPage := InsertNotebook(Group,10,10,280,110);
     MultiPage.Pages.Clear;

     Lab := InsertLabel(SpeedPage,220,10,300,40,
                        LoadNLSStr(SiDragnDropSpeedButtons));
     Lab.AutoSize := FALSE;
     Lab.WordWrap := TRUE;


     LastPage := NIL;
     FOR i := 1 TO MaxMenuEntries DO // Kommandogruppen eintragen
     BEGIN
          smr := MenuEntries[i];

          IF smr.Level IN [0,4] THEN
          BEGIN
               s := LoadNLSStr(smr.Text);
               WHILE pos('~',s) > 0 DO delete(s,pos('~',s),1);
               MenuList.Items.Add(s);
               mpi := MultiPage.Pages.Add(s);
               LastPage := TPage(MultiPage.Pages.Objects[mpi]);
               SetMouseHint(LastPage,SiSpeedbarHint);
               x := 10;
               y := MultiPage.Height - 10 - SpeedButtonSize;
               continue;
          END;

          {Einfgen in LastPage}
          IF smr.Bmp = 1111 THEN continue;  {kein Bitmap da}

          IF smr.Cmd = cmNull THEN
          BEGIN
               inc(x,5);
               continue;
          END;

          IF smr.Cmd = cmDesignPos THEN w := 3 * SpeedButtonSize
          ELSE w := SpeedButtonSize;

          IF x + w > MultiPage.Width - 10 THEN
          BEGIN
               x := 10;
               dec(y, SpeedButtonSize+5);
          END;

          Btn := InsertSpeedButtonNLS(LastPage, x,y,w,SpeedButtonSize,
                                      smr.Bmp, 0,0);
          SetMouseHint(Btn, smr.Hint);
          Btn.NumGlyphs := 2;
          Btn.Tag := smr.Cmd;
          Btn.DragMode := dmAutomatic;
          Btn.OnEndDrag := EvEndDrag;

          IF smr.Cmd = cmDesignPos THEN Btn.Caption := '123:45';
          inc(x, w);
     END;

     // Examples
     BuildSpeedList(TopPanel, TopSpeedList, TopToolButtonList);
     BuildSpeedList(BottomPanel, BottomSpeedList, BottomToolButtonList);


     MenuList.ItemIndex := 0;
     MultiPage.PageIndex := 0;
END;


PROCEDURE TCustomizeDialog.StoreSpeedPage;

  PROCEDURE StoreToolList(SpeedList:TList;ToolList:TList);
  VAR  i:LONGINT;
       Btn:TSpeedButton;
  BEGIN
       ToolList.Clear;
       FOR i := 0 TO SpeedList.Count-1 DO
       BEGIN
            Btn := TSpeedButton(SpeedList[i]);
            IF Btn <> NIL THEN ToolList.Add(POINTER(Btn.Tag))
            ELSE ToolList.Add(NIL);
       END;
  END;

BEGIN
     StoreToolList(TopSpeedList, TopToolButtonList);
     StoreToolList(BottomSpeedList, BottomToolButtonList);
END;


FUNCTION TCustomizeDialog.BuildSpeedBtn(SpeedPanel:TPanel;Cmd:TCommand):TSpeedButton;
VAR  idx:LONGINT;
     Btn:TSpeedButton;
     smr:TSibylMenuRecord;
BEGIN
     Result := NIL;
     IF Cmd = cmNull THEN exit;
     idx := CommandToIndex(Cmd);
     IF idx < 0 THEN exit;

     smr := MenuEntries[idx];

     Btn := InsertSpeedButtonNLS(SpeedPanel, -100,0,
              SpeedButtonSize,SpeedButtonSize, smr.Bmp, 0,0);
     SetMouseHint(Btn, smr.Hint);
     Btn.NumGlyphs := 2;
     Btn.Tag := smr.Cmd;
     Btn.DragMode := dmAutomatic;
     Btn.OnDragOver := EvDragOver;
     Btn.OnEndDrag := EvEndDrag;

     IF smr.Cmd = cmDesignPos THEN
     BEGIN
          Btn.Caption := '123:45';
          Btn.Width := 3 * SpeedButtonSize;
     END;

     Result := Btn;
END;


PROCEDURE TCustomizeDialog.ArrangeSpeedbarExample(SpeedPanel:TPanel);
VAR  i:LONGINT;
     Btn:TControl;
     maxX:LONGINT;
     SpeedList:TList;
BEGIN
     IF SpeedPanel = TopPanel THEN SpeedList := TopSpeedList
     ELSE SpeedList := BottomSpeedList;

     maxX := 0;
     FOR i := 0 TO SpeedList.Count-1 DO
     BEGIN
          Btn := TSpeedButton(SpeedList[i]);
          IF Btn <> NIL THEN
          BEGIN
               Btn.Left := maxX;
               inc(maxX, Btn.Width);
          END
          ELSE inc(maxX, 5);
     END;
END;


PROCEDURE TCustomizeDialog.EvDragOver(Sender,Source:TObject;X,Y:LongInt;State:TDragState;VAR Accept:Boolean);
BEGIN
     Accept := (Source IS TSpeedButton);

     IF Sender = SpeedPage THEN
       IF not (TControl(Source).Parent IS TPanel) THEN Accept := FALSE;
END;


PROCEDURE TCustomizeDialog.EvEndDrag(Sender,Target:TObject; X,Y:LongInt);
VAR  idx,i:LONGINT;
     TargetPanel:TPanel;
     SrcCmd:TCommand;
     Btn:TSpeedButton;
     SpeedList:TList;
BEGIN
     IF Target = NIL THEN exit;

     SpeedModified := TRUE;

     IF Target IS TPanel THEN TargetPanel := TPanel(Target)
     ELSE TargetPanel := TPanel(TControl(Target).Parent);

     IF TargetPanel = TopPanel THEN SpeedList := TopSpeedList
     ELSE SpeedList := BottomSpeedList;


     IF (Target = SpeedPage) AND (TControl(Sender).Parent IS TPanel) THEN
     BEGIN
          // Sender l”schen
          idx := TopSpeedList.IndexOf(Sender);
          IF idx >= 0 THEN
          BEGIN
               TControl(Sender).Bottom := -100;
               TopSpeedList.Delete(idx);
          END;

          idx := BottomSpeedList.IndexOf(Sender);
          IF idx >= 0 THEN
          BEGIN
               TControl(Sender).Bottom := -100;
               BottomSpeedList.Delete(idx);
          END;

          ArrangeSpeedbarExample(TopPanel);
          ArrangeSpeedbarExample(BottomPanel);
          exit;
     END;


     IF Target = Sender THEN
     BEGIN
          //Separator einfgen oder l”schen
          idx := SpeedList.IndexOf(Sender);
          IF (idx > 0) AND (SpeedList[idx-1] = NIL) THEN
          BEGIN
               SpeedList.Delete(idx-1);
          END
          ELSE
          BEGIN
               SpeedList.Insert(idx, NIL);
          END;

          ArrangeSpeedbarExample(TargetPanel);
          exit;
     END;


     SrcCmd := TSpeedButton(Sender).Tag;

     //Teste, ob die Source schon in einer der beiden Listen
     // vorhanden ist - wenn ja, dann entfernen
     FOR i := 0 TO TopSpeedList.Count-1 DO
     BEGIN
          Btn := TSpeedButton(TopSpeedList[i]);
          IF Btn <> NIL THEN
            IF Btn.Tag = SrcCmd THEN
            BEGIN
                 Btn.Bottom := -100;
                 TopSpeedList.Delete(i);
                 break;
            END;
     END;

     FOR i := 0 TO BottomSpeedList.Count-1 DO
     BEGIN
          Btn := TSpeedButton(BottomSpeedList[i]);
          IF Btn <> NIL THEN
            IF Btn.Tag = SrcCmd THEN
            BEGIN
                 Btn.Bottom := -100;
                 BottomSpeedList.Delete(i);
                 break;
            END;
     END;


     Btn := BuildSpeedBtn(TargetPanel, SrcCmd);
     IF Target IS TSpeedButton THEN
     BEGIN
          idx := SpeedList.IndexOf(Target);
          IF idx >= 0 THEN SpeedList.Insert(idx, Btn)
          ELSE SpeedList.Add(Btn);
     END
     ELSE SpeedList.Add(Btn);


     ArrangeSpeedbarExample(TopPanel);
     ArrangeSpeedbarExample(BottomPanel);
END;



PROCEDURE CustomizeDialog;
VAR  Dialog:TCustomizeDialog;
BEGIN
     Dialog.Create(NIL);
     Dialog.HelpContext := hctxDialogCustomizeSettings;
     IF Dialog.Execute THEN
     BEGIN
          Dialog.StoreSpeedPage;

          IF Dialog.SpeedModified
          THEN Dialogs.MessageBox(LoadNLSStr(SiYouMustRestartSibyl),mtInformation,[mbOk]);
     END;

     ActiveCustomizePage := Dialog.Notebook.PageIndex;
     Dialog.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Project Manager                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


TYPE
   TProjectManager=CLASS(TSibylForm)
         TopTool,RightTool,BottomTool:TToolbar;
         AddMain,AddFile,RemoveFile,PrjSett:TXPLButton;
         AddForm,RemoveForm,ImportForm,FormSettings:TXPLButton;
         FormBitmap,MainFormBitmap:TBitmap;
         Status:TPanel;
         FormsPopup,FilesPopup:TPopupMenu;
         CompileEntry,MakeEntry,MainFileAddEntry,FileAddEntry,
         FileRemoveEntry,PrimaryEntry,ClearPrimaryEntry:TMenuItem;
         FormAddEntry,FormRemoveEntry,FormImportEntry,
         FormSourceEntry,FormToFileEntry,FormPropEntry:TMenuItem;
         PROCEDURE SetupComponent;OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE ButtonUpdate;
         PROCEDURE EvRightToolResize(Sender:TObject);
         PROCEDURE EvFileChange(Sender:TObject;Index:LONGINT);
         PROCEDURE EvFileFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE EvFileSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE EvFormDraw(Sender:TObject;Index:LONGINT;Rec:TRect;State:TOwnerDrawState);
         PROCEDURE EvFormFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE EvFormSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE EvCompile(Sender:TObject);
         PROCEDURE EvMake(Sender:TObject);
         PROCEDURE EvAddMainFile(Sender:TObject);
         PROCEDURE EvAddFile(Sender:TObject);
         PROCEDURE EvRemoveFile(Sender:TObject);
         PROCEDURE EvSetPrimary(Sender:TObject);
         PROCEDURE EvClearPrimary(Sender:TObject);
         PROCEDURE EvAddForm(Sender:TObject);
         PROCEDURE EvRemoveForm(Sender:TObject);
         PROCEDURE EvFormSettings(Sender:TObject);
         PROCEDURE EvImportForm(Sender:TObject);
         PROCEDURE EvFormChangeSource(Sender:TObject);
         PROCEDURE EvFormToFile(Sender:TObject);
         PROCEDURE EvPrjSettings(Sender:TObject);
         PROCEDURE EvFileClick(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LONGINT);
         PROCEDURE EvFormClick(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LONGINT);
         PROCEDURE TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
   END;


PROCEDURE FillFileTree(ParentNode:TOutlineNode; FileList:TProjectFiles);
VAR  i:LONGINT;
     s,d,n,e:STRING;
     ppf:PProjectFile;
     NewNode:TOutlineNode;
BEGIN
     IF FileList = NIL THEN exit;

     ProjectFilesTree.BeginUpdate;
     {Fill the Files Tree}
     FOR i := 0 TO FileList.Count-1 DO
     BEGIN
          s := FileList.Strings[i];
          ppf := Pointer(FileList.Objects[i]);
          IF s <> DependenciesString THEN
          BEGIN
               FSplit(s,d,n,e);
               s := n + e;
          END
          ELSE s := Dependencies;

          NewNode := ProjectFilesTree.AddChildObjectNode(ParentNode,s,ppf);

          IF ppf <> NIL THEN
          BEGIN
               NewNode.Expanded := ppf^.Expanded;
               FillFileTree(NewNode, ppf^.ASub);
          END;
     END;
     ProjectFilesTree.EndUpdate; {Index wieder aufbauen}
END;


PROCEDURE FillFormList(FormList:TProjectForms);
VAR  FormItem:PFormListItem;
     i:LONGINT;
BEGIN
     FOR i := 0 TO FormList.Count-1 DO
     BEGIN
          FormItem := FormList.Items[i];
          ProjectFormsList.Items.AddObject(FormItem^.FormName,TObject(FormItem));
     END;
END;


PROCEDURE TProjectManager.SetupComponent;
BEGIN
     Inherited SetupComponent;

     SibylFormId := dwi_ProjectManager;
     Caption := LoadNLSStr(SiProjectManager);

     FormBitmap.Create;
     FormBitmap.Owner:=SELF;
     InsertComponent(FormBitmap);
     FormBitmap.LoadFromResourceId(1060);
     MainFormBitmap.Create;
     MainFormBitmap.Owner:=SELF;
     InsertComponent(MainFormBitmap);
     MainFormBitmap.LoadFromResourceId(1061);

     TopTool.Create(SELF);
     TopTool.Size := 36;
     TopTool.BevelStyle := tbNone;
     InsertControl(TopTool);

     AddMain.Create(TopTool);
     AddMain.SetWindowPos(5,5,SpeedButtonSize,SpeedButtonSize);
     AddMain.Glyph.LoadFromResourceId(1056);
     AddMain.NumGlyphs := 2;
     AddMain.Hint := LoadNLSStr(SiAddMainFileToProject);
     AddMain.Flat := IdeSettings.FlatButtons;
     AddMain.OnClick := EvAddMainFile;
     TopTool.InsertControl(AddMain);

     AddFile.Create(TopTool);
     AddFile.SetWindowPos(5+SpeedButtonSize,5,SpeedButtonSize,SpeedButtonSize);
     AddFile.Glyph.LoadFromResourceId(1050);
     AddFile.NumGlyphs:=2;
     AddFile.Hint := LoadNLSStr(SiAddFileToProject);
     AddFile.Flat := IdeSettings.FlatButtons;
     AddFile.OnClick := EvAddFile;
     TopTool.InsertControl(AddFile);

     RemoveFile.Create(TopTool);
     RemoveFile.SetWindowPos(5+2*SpeedButtonSize,5,SpeedButtonSize,SpeedButtonSize);
     RemoveFile.Glyph.LoadFromResourceId(1051);
     RemoveFile.NumGlyphs:=2;
     RemoveFile.Hint := LoadNLSStr(SiRemoveFileFromProject);
     RemoveFile.Flat := IdeSettings.FlatButtons;
     RemoveFile.OnClick := EvRemoveFile;
     TopTool.InsertControl(RemoveFile);

     AddForm.Create(TopTool);
     AddForm.SetWindowPos(90,5,SpeedButtonSize,SpeedButtonSize);
     AddForm.Glyph.LoadFromResourceId(1021);
     AddForm.NumGlyphs:=2;
     AddForm.Hint := LoadNLSStr(SiAddNewFormToProject);
     AddForm.Flat := IdeSettings.FlatButtons;
     AddForm.OnClick := EvAddForm;
     TopTool.InsertControl(AddForm);

     RemoveForm.Create(TopTool);
     RemoveForm.SetWindowPos(90+SpeedButtonSize,5,SpeedButtonSize,SpeedButtonSize);
     RemoveForm.Glyph.LoadFromResourceId(1053);
     RemoveForm.NumGlyphs:=2;
     RemoveForm.Hint := LoadNLSStr(SiDeleteFormFromProject);
     RemoveForm.Flat := IdeSettings.FlatButtons;
     RemoveForm.OnClick := EvRemoveForm;
     TopTool.InsertControl(RemoveForm);

     ImportForm.Create(TopTool);
     ImportForm.SetWindowPos(150,5,SpeedButtonSize,SpeedButtonSize);
     ImportForm.Glyph.LoadFromResourceId(1054);
     ImportForm.NumGlyphs:=2;
     ImportForm.Hint := LoadNLSStr(SiImportFormFiles);
     ImportForm.Flat := IdeSettings.FlatButtons;
     ImportForm.OnClick := EvImportForm;
     TopTool.InsertControl(ImportForm);

     FormSettings.Create(TopTool);
     FormSettings.SetWindowPos(185,5,SpeedButtonSize,SpeedButtonSize);
     FormSettings.Glyph.LoadFromResourceId(1055);
     FormSettings.NumGlyphs:=2;
     FormSettings.Hint := LoadNLSStr(SiFormSettings);
     FormSettings.Flat := IdeSettings.FlatButtons;
     FormSettings.OnClick := EvFormSettings;
     TopTool.InsertControl(FormSettings);

     PrjSett.Create(TopTool);
     PrjSett.SetWindowPos(220,5,SpeedButtonSize,SpeedButtonSize);
     PrjSett.Glyph.LoadFromResourceId(1052);
     PrjSett.NumGlyphs:=2;
     PrjSett.Hint := LoadNLSStr(SiProjectSettings);
     PrjSett.Flat := IdeSettings.FlatButtons;
     PrjSett.OnClick := EvPrjSettings;
     TopTool.InsertControl(PrjSett);


     ProjectFilesTree.Create(SELF);
     ProjectFilesTree.HelpContext := hctxDialogProjectFilesTree;
     ProjectFilesTree.Align := alClient;
     ProjectFilesTree.Color := clWindow;
     ProjectFilesTree.OnItemFocus := EvFileFocus;
     ProjectFilesTree.OnItemSelect := EvFileSelect;
     ProjectFilesTree.OnExpand := EvFileChange;
     ProjectFilesTree.OnCollapse := EvFileChange;
     ProjectFilesTree.OnMouseClick := EvFileClick;
     InsertControl(ProjectFilesTree);
     ProjectFilesTree.Focus;

     RightTool.Create(SELF);
     RightTool.Alignment := tbRight;
     RightTool.Size := IdeSettings.PrjMan.FormListSize;
     RightTool.Sizeable := TRUE;
     RightTool.OnResize := EvRightToolResize;
     InsertControl(RightTool);

     ProjectFormsList.Create(RightTool);
     ProjectFormsList.HelpContext := hctxDialogProjectFormsList;
     ProjectFormsList.Style := lbOwnerdrawFixed;
     ProjectFormsList.ItemHeight := 20;
     ProjectFormsList.SetWindowPos(5,0,RightTool.Width-5,RightTool.Height);
     ProjectFormsList.Color := clWindow;
     ProjectFormsList.OnDrawItem := EvFormDraw;
     ProjectFormsList.OnItemFocus := EvFormFocus;
     ProjectFormsList.OnItemSelect := EvFormSelect;
     ProjectFormsList.OnMouseClick := EvFormClick;
     RightTool.InsertControl(ProjectFormsList);
     ProjectFormsList.Align := alFrame; {erst nachdem Parent zugewiesen wurde}


     BottomTool.Create(SELF);
     BottomTool.Alignment := tbBottom;
     BottomTool.Size := StatusbarSize;
     InsertControl(BottomTool);

     Status.Create(BottomTool);
     Status.Caption := '';
     Status.Align := alClient;
     Status.BevelOuter := bvNone;
     Status.BevelInner := bvLowered;
     Status.BorderWidth := 3;
     Status.Alignment := taLeftJustify;
     BottomTool.InsertControl(Status);

     FillFileTree(NIL,Project.Files);

     FillFormList(Project.Forms);

     ButtonUpdate;
END;


DESTRUCTOR TProjectManager.Destroy;
BEGIN
     ProjectManager := NIL;
     ProjectFilesTree := NIL;
     ProjectFormsList := NIL;
     IF FormsPopup <> NIL THEN FormsPopup.Destroy;
     IF FilesPopup <> NIL THEN FilesPopup.Destroy;
     Inherited Destroy;
END;


PROCEDURE TProjectManager.ButtonUpdate;
BEGIN
     AddMain.Enabled := TRUE;
     AddFile.Enabled := (ProjectFilesTree.ItemCount > 0);
     RemoveFile.Enabled := (ProjectFilesTree.ItemCount > 0) AND
                           (ProjectFilesTree.SelectedNode <> NIL);
     AddForm.Enabled := Project.Settings.ProjectType = pt_Visual;
     RemoveForm.Enabled := (Project.Settings.ProjectType = pt_Visual) AND
                           (Project.Forms.Count > 0) AND
                           (ProjectFormsList.ItemIndex >= 0);
     ImportForm.Enabled := Project.Settings.ProjectType = pt_Visual;
     FormSettings.Enabled := (Project.Settings.ProjectType = pt_Visual) AND
                             (Project.Forms.Count > 0);
     PrjSett.Enabled := TRUE;
END;


{$HINTS OFF}
PROCEDURE TProjectManager.EvRightToolResize(Sender:TObject);
BEGIN
     IF IdeSettings.PrjMan.FormListSize <> RightTool.Size THEN
     BEGIN
          IdeSettings.PrjMan.FormListSize := RightTool.Size;
          IdeSettings.Modified := TRUE;
     END;
END;


PROCEDURE TProjectManager.EvFileChange(Sender:TObject;Index:LONGINT);
VAR  Node:TOutlineNode;
     ppf:PProjectFile;
BEGIN
     TRY
       Node := ProjectFilesTree.Items[Index];
     EXCEPT
       exit;
     END;
     IF Node = NIL THEN exit;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          IF ppf^.Expanded <> Node.Expanded THEN
          BEGIN
               Project.Modified := TRUE;
               ppf^.Expanded := Node.Expanded;
          END;
     END;
     ButtonUpdate;
END;


{PROCEDURE TProjectManager.EvFileFocus(Sender:TOutline;Index:LONGINT); WD }
PROCEDURE TProjectManager.EvFileFocus(Sender:TObject;Index:LONGINT);
VAR  Node:TOutlineNode;
     ppf:PProjectFile;
     FileList:TProjectFiles;
     idx:LONGINT;
     s:STRING;
BEGIN
     TRY
       Node := ProjectFilesTree.Items[Index];
     EXCEPT
       exit;
     END;
     IF Node = NIL THEN exit;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          FileList := ppf^.AParent;
          idx := FileList.IndexOfObject(TObject(ppf));
          IF idx >= 0 THEN s := FileList.Strings[idx]
          ELSE s := '';

          IF s = DependenciesString THEN s := '';
          Status.Caption := s;
     END;
     ButtonUpdate;
END;

PROCEDURE TProjectManager.EvFileSelect(Sender:TObject;Index:LONGINT);

VAR  Node:TOutlineNode;
     ppf:PProjectFile;
     FileList:TProjectFiles;
     idx:LONGINT;
     s:STRING;
BEGIN
     TRY
       Node := ProjectFilesTree.Items[Index];
     EXCEPT
       exit;
     END;
     IF Node = NIL THEN exit;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          FileList := ppf^.AParent;
          idx := FileList.IndexOfObject(TObject(ppf));
          IF idx >= 0 THEN
          BEGIN
               s := FileList.Strings[idx];
               IF s <> DependenciesString THEN
                 IF LoadEditor(s,0,0,0,0,TRUE,CursorIgnore,Fokus,ShowIt) = NIL
                 THEN ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[s]));
          END;
     END;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvFormDraw(Sender:TObject;Index:LONGINT;Rec:TRect;State:TOwnerDrawState);
VAR  x,y,y1,cx,cy,cx1,cy1:LONGINT;
     idx:LONGINT;
     Bitmap:TBitmap;
     s:STRING;
BEGIN
     IF State * [odSelected] <> [] THEN
     BEGIN
          ProjectFormsList.Canvas.Pen.Color := clHighLightText;
          ProjectFormsList.Canvas.Brush.Color := clHighLight;
     END ELSE
     BEGIN
          ProjectFormsList.Canvas.Pen.Color := ProjectFormsList.PenColor;
          ProjectFormsList.Canvas.Brush.Color := ProjectFormsList.Color;
     END;
     ProjectFormsList.Canvas.FillRect(Rec,ProjectFormsList.Canvas.Brush.Color);

     x := Rec.Left + 2;
     y := Rec.Bottom + 1;
     cx := Rec.Right - x;
     cy := Rec.Top - y;

     s := ProjectFormsList.Items.Strings[Index];

     IF Upcased(Project.Settings.MainForm) = Upcased(s)
     THEN Bitmap := MainFormBitmap
     ELSE Bitmap := FormBitmap;

     IF Bitmap <> NIL THEN
     BEGIN
          cx1 := Bitmap.Width;
          cy1 := Bitmap.Height;
          y1 := y + ((cy - cy1) DIV 2);
          IF y1 <= Rec.Bottom THEN y1 := Rec.Bottom + 1;

          ProjectFormsList.Canvas.StretchDraw(x,y1,cx1,cy1,Bitmap);
          inc(x,Bitmap.Width + 5);
     END;

     ProjectFormsList.Canvas.GetTextExtent(s,cx1,cy1);
     y1 := y + ((cy - cy1) DIV 2);
     IF y1 < Rec.Bottom THEN y1 := Rec.Bottom;
     ProjectFormsList.Canvas.Brush.Mode := bmTransparent;
     ProjectFormsList.Canvas.TextOut(x,y1,s);
END;

PROCEDURE TProjectManager.EvFormFocus(Sender:TObject;Index:LONGINT);
VAR  FormItem:PFormListItem;
     ppf:PProjectFile;
     uname,d,n,e:STRING;
     FileList:TProjectFiles;
     i,idx:LONGINT;
     Node:TOutlineNode;
BEGIN
     TRY
       FormItem := POINTER(ProjectFormsList.Items.Objects[Index]);
     EXCEPT
       exit;
     END;

     IF FormItem <> NIL THEN
     BEGIN
          uname := FormItem^.UnitName;
          UpcaseStr(uname);
          FSplit(uname,d,n,e);

          {Focus the related Unit}
          FOR i := 1 TO ProjectFilesTree.ItemCount DO
          BEGIN
               Node := ProjectFilesTree.Items[i];
               IF Node = NIL THEN continue;
               IF Upcased(Node.Text) <> n+e THEN continue;

               ppf := Node.Data;
               IF ppf <> NIL THEN {suche ppf in Parent}
               BEGIN
                    FileList := ppf^.AParent;
                    idx := FileList.IndexOfObject(TObject(ppf));
                    IF idx < 0 THEN continue;
                    IF Upcased(FileList.Strings[idx]) <> uname THEN continue;
                    {found}
                    IF Node.IsVisible
                    THEN ProjectFilesTree.SelectedNode := Node;
                    break;
               END;
          END;

          Status.Caption := '"'+ FormItem^.FormName +'" '+LoadNLSStr(SiInModule)+' "'+
                                 FormItem^.UnitName +'"';
     END;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvFormSelect(Sender:TObject;Index:LONGINT);
VAR  FormItem:PFormListItem;
BEGIN
     TRY
       FormItem := POINTER(ProjectFormsList.Items.Objects[Index]);
     EXCEPT
       exit;
     END;

     IF FormItem <> NIL THEN
     BEGIN
          OpenFormWindow(FormItem^.FormName);
     END;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvCompile(Sender:TObject);
VAR  Node:TOutlineNode;
     ppf:PProjectFile;
     ParentList:TProjectFiles;
     idx:LONGINT;
     FName:STRING;
BEGIN
     TRY
       Node := ProjectFilesTree.Items[ProjectFilesTree.SelectedItem];
     EXCEPT
       exit;
     END;
     IF Node = NIL THEN exit;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          ParentList := ppf^.AParent;
          idx := ParentList.IndexOfObject(TObject(ppf));
          IF idx < 0 THEN exit;

          FName := ParentList.Strings[idx];

          ForceCompile(Action_Compile, FName);
     END;
END;

PROCEDURE TProjectManager.EvMake(Sender:TObject);
VAR  Node:TOutlineNode;
     ppf:PProjectFile;
     ParentList:TProjectFiles;
     idx:LONGINT;
     FName:STRING;
BEGIN
     TRY
       Node := ProjectFilesTree.Items[ProjectFilesTree.SelectedItem];
     EXCEPT
       exit;
     END;
     IF Node = NIL THEN exit;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          ParentList := ppf^.AParent;
          idx := ParentList.IndexOfObject(TObject(ppf));
          IF idx < 0 THEN exit;

          FName := ParentList.Strings[idx];

          ForceCompile(Action_Make, FName);
     END;
END;


PROCEDURE TProjectManager.EvAddMainFile(Sender:TObject);
VAR  s:STRING;
     ret:BOOLEAN;
{$IFDEF OS2}
     CFOD:TOpenDialog;
{$ENDIF}
{$IFDEF Win32}
     CFOD:TSystemOpenDialog;
{$ENDIF}

BEGIN
     CFOD.Create(SELF);
     CFOD.HelpContext := hctxDialogAddProjectMainFile;
     CFOD.Title := LoadNLSStr(SiAddFileToProject);
     CFOD.OkName := LoadNLSStr(SiAdd);
     SetFileDialogTypes(CFOD);
     CFOD.FileName := ALL_FILES_UC_Pascal; // '*.PAS';
     CFOD.DefaultExt := GetDefaultExt(ALL_FILES_UC_Pascal); // '*.PAS');
     ret := CFOD.Execute;
     s := CFOD.Filename;
     CFOD.Destroy;
     Screen.Update;

     IF ret THEN
     BEGIN
          IF AddProjectMain(s) THEN Project.Modified := TRUE
          ELSE ErrorBox(LoadNLSStr(SiCouldNotAddProjectMainFile));
     END;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvAddFile(Sender:TObject);
VAR  s,main:STRING;
     ret:BOOLEAN;
     Node:TOutlineNode;
     ppf,ppfmain:PProjectFile;
     ParentList:TProjectFiles;
     idx,i:LONGINT;
{$IFDEF OS2}
     CFOD:TOpenDialog;
{$ENDIF}
{$IFDEF Win32}
     CFOD:TSystemOpenDialog;
{$ENDIF}


BEGIN
     {Fge das neue File als Geschwister oder Kind vom selektierten
      Knoten ein, falls keiner selektiert -> neues Main File}
     TRY
       Node := ProjectFilesTree.Items[ProjectFilesTree.SelectedItem];
     EXCEPT
       exit;
     END;

     IF Node <> NIL THEN
       IF Node.Level > 2 THEN exit; {keine Dependency manuell hinzufgbar}

     CFOD.Create(SELF);
     CFOD.HelpContext := hctxDialogAddProjectFile;
     CFOD.Title := LoadNLSStr(SiAddFileToProject);
     CFOD.OkName := LoadNLSStr(SiAddFileOkName);
     SetFileDialogTypes(CFOD);
     CFOD.FileName := ALL_FILES_UC_PASCAL; // '*.PAS';
     CFOD.DefaultExt := GetDefaultExt(ALL_FILES_UC_PASCAL); // '*.PAS');
     ret := CFOD.Execute;
     s := CFOD.Filename;
     CFOD.Destroy;
     Screen.Update;

     IF not ret THEN
     BEGIN
          ButtonUpdate;
          exit;
     END;

     IF Node = NIL THEN {neues MainFile}
     BEGIN
          IF AddProjectMain(s) THEN Project.Modified := TRUE
          ELSE ErrorBox(LoadNLSStr(SiCouldNotAddProjectMainFile));
          ButtonUpdate;
          exit;
     END;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          ParentList := ppf^.AParent;
          idx := ParentList.IndexOfObject(TObject(ppf));
          IF idx < 0 THEN exit;

          IF ParentList <> Project.Files THEN
          BEGIN
               main := '';
               {suche das MainFile zum selektierten Modul}
               FOR i := 0 TO Project.Files.Count-1 DO
               BEGIN
                    ppfmain := POINTER(Project.Files.Objects[i]);
                    IF ppfmain = NIL THEN continue;
                    IF ppfmain^.ASub = ParentList THEN
                    BEGIN
                         main := Project.Files.Strings[i];
                         break;
                    END;
               END;
          END
          ELSE main := ParentList.Strings[idx];

          IF AddProjectUnit(main,s) THEN Project.Modified := TRUE
          ELSE ErrorBox(LoadNLSStr(SiCouldNotAddProjectFile));
     END;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvRemoveFile(Sender:TObject);
VAR  Node:TOutlineNode;
     ppf,ppfmain:PProjectFile;
     ParentList:TProjectFiles;
     idx,i:LONGINT;
BEGIN
     TRY
       Node := ProjectFilesTree.Items[ProjectFilesTree.SelectedItem];
     EXCEPT
       exit;
     END;
     IF Node = NIL THEN exit;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          ParentList := ppf^.AParent;
          idx := ParentList.IndexOfObject(TObject(ppf));
          IF idx < 0 THEN exit;

          {IF ParentList.Strings[idx] = DependenciesString THEN exit;
           auch Dependencies drfen gel”scht werden}

          IF ParentList <> Project.Files THEN {remove Modul}
          BEGIN
               {suche das MainFile zum Modul;
                wenn keins gefunden wird, dann wurde versucht, eine Dependency zu l”schen}
               FOR i := 0 TO Project.Files.Count-1 DO
               BEGIN
                    ppfmain := POINTER(Project.Files.Objects[i]);
                    IF ppfmain = NIL THEN continue;
                    IF ppfmain^.ASub = ParentList THEN
                    BEGIN
                         IF not RemoveProjectUnit(Project.Files.Strings[i],
                                                  ParentList.Strings[idx])
                         THEN ErrorBox(LoadNLSStr(SiCouldNotRemoveFileFromPrj));
                         break;
                    END;
               END;
          END
          ELSE {remove Main File}
          BEGIN
               IF RemoveProjectMain(ParentList.Strings[idx])
               THEN Project.Modified := TRUE
               ELSE ErrorBox(LoadNLSStr(SiCouldNotRemoveMainFromPrj));
          END;
     END;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvSetPrimary(Sender:TObject);
VAR  Node:TOutlineNode;
     ppf:PProjectFile;
     ParentList:TProjectFiles;
     idx:LONGINT;
     FName:STRING;
BEGIN
     TRY
       Node := ProjectFilesTree.Items[ProjectFilesTree.SelectedItem];
     EXCEPT
       exit;
     END;
     IF Node = NIL THEN exit;

     IF Node.Level <> 1 THEN exit;

     ppf := Node.Data;
     IF ppf <> NIL THEN {suche ppf in Parent}
     BEGIN
          ParentList := ppf^.AParent;
          idx := ParentList.IndexOfObject(TObject(ppf));
          IF idx < 0 THEN exit;

          FName := ParentList.Strings[idx];

          SetPrimaryFile(FName);
          Project.Modified := TRUE;
     END;
END;


PROCEDURE TProjectManager.EvClearPrimary(Sender:TObject);
BEGIN
     IF Project.Settings.Primary <> '' THEN
     BEGIN
          SetPrimaryFile('');
          Project.Modified := TRUE;
     END;
END;


PROCEDURE TProjectManager.EvAddForm(Sender:TObject);
BEGIN
     NewFormWindow('');
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvRemoveForm(Sender:TObject);
VAR  FormItem:PFormListItem;
     idx:LONGINT;
BEGIN
     TRY
       idx := ProjectFormsList.ItemIndex;
     EXCEPT
       exit;
     END;
     IF idx < 0 THEN exit;

     FormItem := POINTER(ProjectFormsList.Items.Objects[idx]);
     IF FormItem = NIL THEN exit;

     IF Dialogs.MessageBox(FmtLoadNLSStr(SiDeleteFormFromPrjQuery,[FormItem^.FormName]),
        mtConfirmation,mbOkCancel) = mrCancel THEN exit;

     {Form muแ da sein, damit related SourceText entfernbar}
     IF (FormItem^.Form = NIL) AND (FormItem^.SCUPointer <> NIL) THEN
     BEGIN
          {Create Form and load properties}
          SCUPointer := FormItem^.SCUPointer;
          PSCUFileFormat(SCUPointer)^.UseEntry := 0;
//          ASM
//             MOVB Classes.InsideWriteSCU,1
//          END;
          FormItem^.Form := FormEditClass.Create(NIL);
//          ASM
//             MOVB Classes.InsideWriteSCU,0
//          END;
          FormItem^.Form.TypeName := 'T'+ FormItem^.Form.Name;   {wegen Remove_RegisteredClasses}
          SCUPointer := NIL;
     END
     ELSE FormItem^.SCUPointer := NIL;

     IF Inspector <> NIL THEN
       IF Inspector.InspectedForm = FormItem^.Form
       THEN Inspector.SetInspectorData(NIL);

     IF FormItem^.Form <> NIL THEN GenRemoveForm(TForm(FormItem^.Form));

     IF RemoveProjectForm(FormItem^.FormName) THEN Project.SCUModified := TRUE;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvFormSettings(Sender:TObject);
BEGIN
     ActiveProjectPage := FormPropertiesIndex;
     ProjectDialog;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvImportForm(Sender:TObject);
BEGIN
     Import;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvFormChangeSource(Sender:TObject);
VAR  FormItem:PFormListItem;
     idx:LONGINT;
BEGIN
     TRY
       idx := ProjectFormsList.ItemIndex;
     EXCEPT
       exit;
     END;
     IF idx < 0 THEN exit;

     FormItem := POINTER(ProjectFormsList.Items.Objects[idx]);
     IF FormItem = NIL THEN exit;

     ChangeSourceLocation(FormItem);

     EvFormFocus(ProjectFormsList,idx);
END;


PROCEDURE TProjectManager.EvFormToFile(Sender:TObject);
VAR  FormItem:PFormListItem;
     idx:LONGINT;
BEGIN
     TRY
       idx := ProjectFormsList.ItemIndex;
     EXCEPT
       exit;
     END;
     IF idx < 0 THEN exit;

     FormItem := POINTER(ProjectFormsList.Items.Objects[idx]);
     IF FormItem = NIL THEN exit;

     SaveFormToFile(FormItem);
END;


PROCEDURE TProjectManager.EvPrjSettings(Sender:TObject);
BEGIN
     ActiveProjectPage := CompilerPropertiesIndex;
     ProjectDialog;
     ButtonUpdate;
END;


PROCEDURE TProjectManager.EvFileClick(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LONGINT);
VAR  Entry:TMenuItem;
     pt:TPoint;
     Node:TOutlineNode;
BEGIN
     IF Button <> mbRight THEN exit;

     IF not ProjectFilesTree.HandlePopupEvent THEN exit; {nur bei CheckMenuPopup}

     IF FilesPopup = NIL THEN
     BEGIN
          FilesPopup.Create(SELF);

          CompileEntry.Create(FilesPopup);
          CompileEntry.Caption := LoadNLSStr(SiEdPopupCompile);
          CompileEntry.OnClick := EvCompile;
          CompileEntry.HelpContext := hctxPopupProjectFileCompile;
          FilesPopup.Items.Add(CompileEntry);

          MakeEntry.Create(FilesPopup);
          MakeEntry.Caption := LoadNLSStr(SiEdPopupMake);
          MakeEntry.OnClick := EvMake;
          MakeEntry.HelpContext := hctxPopupProjectFileMake;
          FilesPopup.Items.Add(MakeEntry);

          Entry.Create(FilesPopup);
          Entry.Caption := '-';
          FilesPopup.Items.Add(Entry);

          MainFileAddEntry.Create(FilesPopup);
          MainFileAddEntry.Caption := LoadNLSStr(SiAddMainFile);
          MainFileAddEntry.OnClick := EvAddMainFile;
          MainFileAddEntry.HelpContext := hctxPopupProjectAddMainFile;
          FilesPopup.Items.Add(MainFileAddEntry);

          FileAddEntry.Create(FilesPopup);
          FileAddEntry.Caption := LoadNLSStr(SiAddFile);
          FileAddEntry.OnClick := EvAddFile;
          FileAddEntry.HelpContext := hctxPopupProjectAddFile;
          FilesPopup.Items.Add(FileAddEntry);

          FileRemoveEntry.Create(FilesPopup);
          FileRemoveEntry.Caption := LoadNLSStr(SiRemoveFile);
          FileRemoveEntry.OnClick := EvRemoveFile;
          FileRemoveEntry.HelpContext := hctxPopupProjectRemoveFile;
          FilesPopup.Items.Add(FileRemoveEntry);

          Entry.Create(FilesPopup);
          Entry.Caption := '-';
          FilesPopup.Items.Add(Entry);

          PrimaryEntry.Create(FilesPopup);
          PrimaryEntry.Caption := LoadNLSStr(SiSetPrimary);
          PrimaryEntry.OnClick := EvSetPrimary;
          PrimaryEntry.HelpContext := hctxPopupProjectSetPrimary;
          FilesPopup.Items.Add(PrimaryEntry);

          ClearPrimaryEntry.Create(FilesPopup);
          ClearPrimaryEntry.Caption := LoadNLSStr(SiClearPrimary);
          ClearPrimaryEntry.OnClick := EvClearPrimary;
          ClearPrimaryEntry.HelpContext := hctxPopupProjectClearPrimary;
          FilesPopup.Items.Add(ClearPrimaryEntry);
     END;

     Node := ProjectFilesTree.SelectedNode;

     CompileEntry.Enabled := (Node <> NIL) AND (Node.Text <> Dependencies);
     MakeEntry.Enabled := (Node <> NIL) AND (Node.Text <> Dependencies);
     MainFileAddEntry.Enabled := TRUE;
     FileAddEntry.Enabled := (Node <> NIL) AND (Node.Level <= 2);
     FileRemoveEntry.Enabled := (Node <> NIL) AND (Node.Level <= 2);
     PrimaryEntry.Enabled := (Node <> NIL) AND (Node.Level = 1);
     ClearPrimaryEntry.Enabled := (Project.Settings.Primary <> '');

     ButtonUpdate;

     pt := ProjectFilesTree.ClientToScreen(Point(X,Y));
     FilesPopup.Popup(pt.X,pt.Y);
END;


PROCEDURE TProjectManager.EvFormClick(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:LONGINT);
VAR  Entry:TMenuItem;
     pt:TPoint;
BEGIN
     IF Button <> mbRight THEN exit;

     IF FormsPopup = NIL THEN
     BEGIN
          FormsPopup.Create(SELF);

          FormAddEntry.Create(FormsPopup);
          FormAddEntry.Caption := LoadNLSStr(SiAddForm);
          FormAddEntry.OnClick := EvAddForm;
          FormAddEntry.HelpContext := hctxPopupProjectAddForm;
          FormsPopup.Items.Add(FormAddEntry);

          FormRemoveEntry.Create(FormsPopup);
          FormRemoveEntry.Caption := LoadNLSStr(SiRemoveForm);
          FormRemoveEntry.OnClick := EvRemoveForm;
          FormRemoveEntry.HelpContext := hctxPopupProjectRemoveForm;
          FormsPopup.Items.Add(FormRemoveEntry);

          FormImportEntry.Create(FormsPopup);
          FormImportEntry.Caption := LoadNLSStr(SiImportForm);
          FormImportEntry.OnClick := EvImportForm;
          FormImportEntry.HelpContext := hctxPopupProjectImportForm;
          FormsPopup.Items.Add(FormImportEntry);

          Entry.Create(FormsPopup);
          Entry.Caption := '-';
          FormsPopup.Items.Add(Entry);

          FormSourceEntry.Create(FormsPopup);
          FormSourceEntry.Caption := LoadNLSStr(SiFormSourceLoc)+'...';
          FormSourceEntry.OnClick := EvFormChangeSource;
          FormSourceEntry.HelpContext := hctxPopupProjectFormSourceLoc;
          FormsPopup.Items.Add(FormSourceEntry);

          FormToFileEntry.Create(FormsPopup);
          FormToFileEntry.Caption := LoadNLSStr(SiSaveFormToFile);
          FormToFileEntry.OnClick := EvFormToFile;
          FormToFileEntry.HelpContext := hctxPopupProjectSaveFormToFile;
          FormsPopup.Items.Add(FormToFileEntry);

          Entry.Create(FormsPopup);
          Entry.Caption := '-';
          FormsPopup.Items.Add(Entry);

          FormPropEntry.Create(FormsPopup);
          FormPropEntry.Caption := LoadNLSStr(SiProperties);
          FormPropEntry.OnClick := EvFormSettings;
          FormPropEntry.HelpContext := hctxPopupProjectFormProperties;
          FormsPopup.Items.Add(FormPropEntry);
     END;

     FormAddEntry.Enabled := Project.Settings.ProjectType = pt_Visual;
     FormRemoveEntry.Enabled := (Project.Settings.ProjectType = pt_Visual) AND
         (Project.Forms.Count > 0) AND (ProjectFormsList.ItemIndex >= 0);
     FormImportEntry.Enabled := Project.Settings.ProjectType = pt_Visual;
     FormSourceEntry.Enabled := (Project.Settings.ProjectType = pt_Visual) AND
         (Project.Forms.Count > 0) AND (ProjectFormsList.ItemIndex >= 0);
     FormToFileEntry.Enabled := (Project.Settings.ProjectType = pt_Visual) AND
         (Project.Forms.Count > 0) AND (ProjectFormsList.ItemIndex >= 0);
     FormPropEntry.Enabled := (Project.Settings.ProjectType = pt_Visual) AND
         (Project.Forms.Count > 0);

     ButtonUpdate;

     pt := ProjectFormsList.ClientToScreen(Point(X,Y));
     FormsPopup.Popup(pt.X,pt.Y);
END;
{$HINTS ON}


PROCEDURE TProjectManager.TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Application.MainForm.OnTranslateShortCut(SELF,KeyCode,Receiver);

     IF KeyCode = kbShiftF10 THEN
     BEGIN
          IF ActiveControl = ProjectFormsList THEN
          BEGIN
               //Msg scheint nicht anzukommen, wenn FormlIst den Fokus hat
               EvFormClick(NIL,mbRight,[],
                  ProjectFormsList.Width DIV 2, ProjectFormsList.Height DIV 2);
          END
          ELSE
          BEGIN
               ProjectFilesTree.HandlePopupEvent := TRUE;

               EvFileClick(NIL,mbRight,[],
                  ProjectFilesTree.Width DIV 2, ProjectFilesTree.Height DIV 2);

               ProjectFilesTree.HandlePopupEvent := FALSE;
          END;
     END;
END;


PROCEDURE InitProjectManager;
BEGIN
     IF ProjectManager <> NIL THEN
     BEGIN
          IF ProjectManager.WindowState = wsMinimized
          THEN ProjectManager.WindowState := wsNormal;
          ProjectManager.BringToFront;
          exit;
     END;
     ProjectManager := TProjectManager.Create(NIL);
     ProjectManager.HelpContext := hctxDialogProjectManager;
     ProjectManager.Show;
     ProjectManager.Update;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Goto Line Dialog                                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TGotoLineDialog = CLASS(TDialog)
      PRIVATE
         LineEdit:TEdit;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE DismissDlg(Result:TCommand);OVERRIDE;
    END;


PROCEDURE TGotoLineDialog.SetupComponent;
VAR  al:LONGINT;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiGotoLine);
     ClientWidth := 380;
     ClientHeight := 130;
     InsertLabelNLS(SELF,20,80,150,20,SiNewLineNumber);
     al := CodeEditor.TopEditor.CursorPos.Y;
     LineEdit := InsertEdit(SELF,180,80,100,22,tostr(al),'');
     LineEdit.AutoSize := TRUE;
     LineEdit.Alignment := taRightJustify;
     LineEdit.Focus;

     InsertBitBtnNLS(SELF,20,20,100,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,140,20,100,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,260,20,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


PROCEDURE TGotoLineDialog.DismissDlg(Result:TCommand);
VAR  fcx:TEditorPos;
     c:INTEGER;
BEGIN
     IF Result = cmOk THEN
     BEGIN
          c := 1;
          IF LineEdit.Caption <> '' THEN
          BEGIN
               val(LineEdit.Caption, fcx.Y, c);
               IF c = 0 THEN
                 IF (fcx.Y < 1) OR (fcx.Y > CodeEditor.TopEditor.CountLines)
                 THEN c := 1;
          END;

          IF c = 0 THEN
          BEGIN
               fcx.X := 1;
               CodeEditor.TopEditor.GotoPosition(fcx);
          END
          ELSE
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiIsNotAValidLineNumber,[LineEdit.Caption])+
                      ' (1 - ' + tostr(CodeEditor.TopEditor.CountLines)+')');
               ModalResult := cmNull; {reset}
               LineEdit.CaptureFocus;
               exit; {no Inherited}
          END;
     END;
     Inherited DismissDlg(Result);
END;



PROCEDURE GotoLineDialog;
VAR  Dlg:TGotoLineDialog;
BEGIN
     IF CodeEditor.TopEditor = NIL THEN exit;

     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogGotoLine;
     IF Dlg.Execute THEN CodeEditor.TopEditor.CaptureFocus;
     Dlg.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Run Parameter Dialog                                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TRunParameterDialog = CLASS(TDialog)
      PRIVATE
         ParamEdit:TEdit;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
    END;


PROCEDURE TRunParameterDialog.SetupComponent;
BEGIN
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiCommandLineParameters);
  ClientWidth := 500;
  ClientHeight := 130;
  InsertLabelNLS(SELF,20,80,80,20,SiParameter);
  ParamEdit := InsertEdit(SELF,100,80,380,22,Project.Settings.RunParam,'');
  ParamEdit.AutoSize := TRUE;
  ParamEdit.Focus;

  InsertBitBtnNLS(SELF,20,20,100,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(SELF,140,20,100,30,bkCancel,SCancelButton,SClickHereToCancel);
  InsertBitBtnNLS(SELF,260,20,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;



PROCEDURE RunParamDialog;
VAR  Dlg:TRunParameterDialog;
BEGIN
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogRunParameter;
     IF Dlg.Execute THEN
     BEGIN
          Project.Settings.RunParam := Dlg.ParamEdit.Text;
          Project.Modified := TRUE;
     END;
     Dlg.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: New Project Dialog                                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TNewProjectDialog = CLASS(TDialog)
       PRIVATE
         NameEdit,DirEdit:TEdit;
         TemplateCombo:TComboBox;
         PROCEDURE EvBrowse(Sender:TObject);
       PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
     END;


PROCEDURE TNewProjectDialog.SetupComponent;
VAR  Browse:TSpeedButton;
     s,d,n,e:STRING;
     Search:SearchRec;
     status:INTEGER;
BEGIN
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiNewProject);
  ClientWidth := 380;
  ClientHeight := 250;

  InsertLabelNLS(SELF,20,210,340,22,SiProjectName);
  NameEdit := InsertEdit(SELF,20,185,340,22,'','');
  NameEdit.AutoSize := TRUE;
  NameEdit.Focus;

  InsertLabelNLS(SELF,20,155,340,22,SiProjectDir);
  DirEdit := InsertEdit(SELF,20,130,270,22,'','');
  DirEdit.AutoSize := TRUE;

  Browse := InsertSpeedButton(SELF,290,130,70,DirEdit.Height, 0,LoadNLSStr(SiBrowse),'');
  Browse.TabStop := FALSE;
  Browse.OnClick := EvBrowse;

  InsertLabelNLS(SELF,20,80,80,20,SiTemplate);
  TemplateCombo := InsertComboBox(SELF,100,80,260,20,csDropDownList);
  TemplateCombo.DropDownCount := 3;

  InsertBitBtnNLS(SELF,20,20,100,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(SELF,140,20,100,30,bkCancel,SCancelButton,SClickHereToCancel);
  InsertBitBtnNLS(SELF,260,20,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);

  {initialize}
  IF IdeSettings.ProjectDir = ''
    THEN FSplit(Project.FileName,d,n,e)
    ELSE d := IdeSettings.ProjectDir;
  IF d[Length(d)] <> '\' THEN d := d + '\';
  s := GetUniqueFileName(d,'Project',1,EXT_UC_WDSibyl_SPR);  // '.spr'
  FSplit(s,d,n,e);
  NameEdit.Caption := n;
  DirEdit.Caption := d;

  TemplateCombo.Items.Add('<Standard>');
{add the templates found in directory BIN\TEMPLATE}
  TRY
    status := FindFirst(GetTemplateDir+'\*' + EXT_UC_WDSibyl_SPR, faArchive,Search); // .spr'
    WHILE status = 0 DO
      BEGIN
        FSplit(Search.Name,d,n,e);
        TemplateCombo.Items.Add(n);
        status := FindNext(Search);
      END;
  EXCEPT
  END;
  TemplateCombo.ItemIndex := 0;
END;


{$HINTS OFF}
PROCEDURE TNewProjectDialog.EvBrowse(Sender:TObject);
VAR  CDD:TChangeDirDialog;
BEGIN
     CDD.Create(SELF);
     CDD.HelpContext := hctxDialogBrowseNewProjectDirectory;
     CDD.Caption := LoadNLSStr(SiSelectProjectDirectory);
     CDD.OkName := LoadNLSStr(SiSelect);
     CDD.Directory := DirEdit.Text;
     IF CDD.Execute THEN
     BEGIN
          DirEdit.Text := CDD.Directory;
     END;
     CDD.Destroy;
     DirEdit.CaptureFocus;
END;
{$HINTS ON}



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

  Procedure NormDir(Var S:String);
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
     NormDir(dir);

     If Pos('\',dir) = 1 Then dir := Copy(Init,1,2) + dir;
     If Pos(':',dir) = 0 Then dir := Init + '\' + dir;
     NormDir(dir);

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
     //ErrorBox(LoadNLSStr(SError)+' [' + tostr(rc) + '] : '+LoadNLSStr(SCannotCreateDir)+' !');
     Result := False;
End;


PROCEDURE NewProjectDialog;
VAR  Dlg:TNewProjectDialog;
     LastDir,s:STRING;
     Template:STRING;
BEGIN
     {$i-}
     GetDir(0,LastDir);
     {$i+}
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogNewProject;
     IF Dlg.Execute THEN
     BEGIN
          s := Dlg.DirEdit.Text;
          NormalizeDir(s);
          s := s + '\' + Dlg.NameEdit.Text + EXT_UC_WDSibyl_SPR; // '.spr';

          //neues? Verzeichnis erzeugen, keine Fehlermeldungen
          CreateDir('', Dlg.DirEdit.Text);

          ChangeDir(LastDir);
          {Restore old Directory, damit beim Abspeichern des alten Projektes,
           der OriginalPfad verwendet wird}

          Template := Dlg.TemplateCombo.Text;
          IF Template = '<Standard>' THEN Template := '';

          NewProject(s,Template);
     END
     ELSE ChangeDir(LastDir);
     Dlg.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Tool Options Dialog                                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TToolOptionDialog=CLASS(TDialog)
         List:TListBox;
         AddBtn,RmvBtn:TSpeedButton;
         NameEdit,ProgEdit,ParamEdit:TEdit;
         Browse,Mnemos:TSpeedButton;
         CloseBtn,HelpBtn:TBitBtn;
         ToolPopup:TPopupMenu;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE ListItemFocused(Sender:TObject;Index:LONGINT);
         PROCEDURE InsertBlankItem(Sender:TObject);
         PROCEDURE RemoveListItem(Sender:TObject);
         PROCEDURE BrowseFileName(Sender:TObject);
         PROCEDURE ShowMnemonics(
         Sender:TObject);
         PROCEDURE InsertMnemonic(Sender:TObject);
         PROCEDURE WriteBackToList(Sender:TObject);
    END;


PROCEDURE TToolOptionDialog.SetupComponent;
VAR  i:LONGINT;
     ptd:PToolData;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiTools);
     ClientWidth := 380;
     Height := 370;

     List := InsertListBox(SELF,20,155,210,165,'');
     List.OnItemFocus := ListItemFocused;
     List.Focus;
     FOR i := 0 TO ToolsList.Count-1 DO
     BEGIN
          ptd := ToolsList[i];
          List.Items.AddObject(ptd^.ToolName,TObject(ptd));
     END;

     AddBtn := InsertSpeedButton(SELF,20,130,105,25, 0,LoadNLSStr(SiAdd),'');
     AddBtn.TabStop := FALSE;
     AddBtn.OnClick := InsertBlankItem;
     RmvBtn := InsertSpeedButton(SELF,125,130,105,25, 0,LoadNLSStr(SiRemove),'');
     RmvBtn.Enabled := ToolsList.Count > 0;
     RmvBtn.TabStop := FALSE;
     RmvBtn.OnClick := RemoveListItem;

     InsertLabelNLS(SELF,20,85,70,22,SiName);
     NameEdit := InsertEdit(SELF,90,90,250,22,'','');
     NameEdit.Enabled := ToolsList.Count > 0;
     NameEdit.AutoSize := TRUE;
     NameEdit.OnExit := WriteBackToList;

     InsertLabelNLS(SELF,20,50,70,22,SiProgram);
     ProgEdit := InsertEdit(SELF,90,55,190,22,'','');
     ProgEdit.Enabled := ToolsList.Count > 0;
     ProgEdit.OnExit := WriteBackToList;

     Browse := InsertSpeedButton(SELF,280,55,60,ProgEdit.Height, 0,LoadNLSStr(SiBrowse),'');
     Browse.Enabled := ToolsList.Count > 0;
     Browse.TabStop := FALSE;
     Browse.OnClick := BrowseFileName;

     InsertLabelNLS(SELF,20,15,70,22,SiParameter);
     ParamEdit := InsertEdit(SELF,90,20,230,22,'','');
     ParamEdit.Enabled := ToolsList.Count > 0;
     ParamEdit.AutoSize := TRUE;
     ParamEdit.OnExit := WriteBackToList;

     Mnemos := InsertSpeedButton(SELF,320,20,20,ParamEdit.Height, 0,'>','');
     Mnemos.Enabled := ToolsList.Count > 0;
     Mnemos.TabStop := FALSE;
     Mnemos.OnClick := ShowMnemonics;

     CloseBtn := InsertBitBtnNLS(SELF,250,290,110,30,bkClose,SiClose,0);
     IF IdeSettings.ShowBitBtnGlyph THEN CloseBtn.Margin := 10;
     CloseBtn.Cancel := TRUE;
     HelpBtn := InsertBitBtnNLS(SELF,250,250,110,30,bkHelp,SHelpButton,0);
     IF IdeSettings.ShowBitBtnGlyph THEN HelpBtn.Margin := 10;
END;


PROCEDURE TToolOptionDialog.SetupShow;
BEGIN
     Inherited SetupShow;

     IF List.Items.Count > 0 THEN List.ItemIndex := 0;
END;


{$HINTS OFF}
PROCEDURE TToolOptionDialog.ListItemFocused(Sender:TObject;Index:LONGINT);
VAR  ptd:PToolData;
BEGIN
     IF Index < 0 THEN exit;
     ptd := PToolData(List.Items.Objects[Index]);
     NameEdit.Caption := ptd^.ToolName;
     ProgEdit.Caption := ptd^.FileName;
     ParamEdit.Caption := ptd^.Parameter;
END;


PROCEDURE TToolOptionDialog.InsertBlankItem(Sender:TObject);
VAR  ptd:PToolData;
BEGIN
     New(ptd);
     ptd^.ToolName := LoadNLSStr(SiTool) + ' ' + tostr(List.Items.Count+1);
     ptd^.FileName := '';
     ptd^.Parameter := '';
     ptd^.MenuItem := NIL;

     ToolsList.Add(ptd);
     List.ItemIndex := List.Items.AddObject(ptd^.ToolName, TObject(ptd));

     NameEdit.Focus;

     RmvBtn.Enabled := TRUE;
     NameEdit.Enabled := TRUE;
     ProgEdit.Enabled := TRUE;
     Browse.Enabled := TRUE;
     ParamEdit.Enabled := TRUE;
     Mnemos.Enabled := TRUE;
END;


PROCEDURE TToolOptionDialog.RemoveListItem(Sender:TObject);
VAR  i:LONGINT;
     ptd:PToolData;
     ToolSubMenu:TMenuItem;
BEGIN
     i := List.ItemIndex;
     IF (i < 0) OR (i >= List.Items.Count) THEN exit;

     ptd := PToolData(List.Items.Objects[i]);
     IF ptd^.MenuItem <> NIL THEN ptd^.MenuItem.Destroy;
     Dispose(ptd);
     ToolsList.Delete(i);
     List.Items.Delete(i);
     List.Focus;
     IF i >= List.Items.Count THEN i := List.Items.Count-1;
     IF i < 0 THEN
     BEGIN
          NameEdit.Caption := '';
          ProgEdit.Caption := '';
          ParamEdit.Caption := '';
     END
     ELSE List.ItemIndex := i;

     RmvBtn.Enabled := List.Items.Count > 0;
     NameEdit.Enabled := List.Items.Count > 0;
     ProgEdit.Enabled := List.Items.Count > 0;
     Browse.Enabled := List.Items.Count > 0;
     ParamEdit.Enabled := List.Items.Count > 0;
     Mnemos.Enabled := List.Items.Count > 0;

     ToolSubMenu := Application.MainForm.Menu.MenuItems[cmOptionsMenu];
     IF ToolsList.Count = 0 THEN
       IF ToolSubMenu.Count = MaxOptionMenu + 1
       THEN ToolSubMenu[MaxOptionMenu].Destroy; {Destroy Separator}
END;


PROCEDURE TToolOptionDialog.BrowseFileName(Sender:TObject);
VAR  FOD:TOpenDialog;
     d,n,e:STRING;
BEGIN
     FOD.Create(SELF);
     FOD.HelpContext := hctxDialogBrowseToolFileName;
     FOD.Caption := LoadNLSStr(SiSelectAFile);
     FOD.AddFilter(LoadNLSStr(SiAllFiles)       +' ('+ALL_FILES+')',  ALL_FILES);
     FOD.AddFilter(LoadNLSStr(SiExecutableFiles)+' ('+ALL_FILES_UC_EXE+')',ALL_FILES_UC_EXE); // '*.EXE');
     FOD.AddFilter(LoadNLSStr(SiBatchFiles)     +' ('+ALL_FILES_UC_CMD+')',ALL_FILES_UC_CMD); // '*.CMD');
     FOD.FilterIndex := 2;
     FOD.OkName := LoadNLSStr(SiSelect);
     FSplit(ProgEdit.Caption,d,n,e);
     IF e = '' THEN e := EXT_UC_EXE;
     FOD.DefaultExt := GetDefaultExt('*'+ e);
     FOD.FileName := ProgEdit.Caption;
     IF FOD.Execute THEN
     BEGIN
          ProgEdit.Caption := FOD.FileName;
          WriteBackToList(NIL);
     END;
     FOD.Destroy;
     Screen.Update;
     ProgEdit.CaptureFocus;
END;


PROCEDURE TToolOptionDialog.ShowMnemonics(Sender:TObject);
VAR  Entry:TMenuItem;
     pt:TPoint;
BEGIN
     IF ToolPopup = NIL THEN
     BEGIN
          ToolPopup.Create(SELF);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiSaveProject);
          Entry.Tag := 1;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsSaveProject;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiSaveSCU);
          Entry.Tag := 2;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsSaveSCU;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiSaveAllEditors);
          Entry.Tag := 3;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsSaveAllEditors;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiSaveCurrentEditor);
          Entry.Tag := 4;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsSaveCurrentEditor;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := '-';
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiCurrentEditor);
          Entry.Tag := 11;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsCurrentEditor;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiCurrentEditorLine);
          Entry.Tag := 12;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsCurrentEditorLine;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiCurrentEditorColumn);
          Entry.Tag := 13;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsCurrentEditorColumn;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := '-';
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiPrjName);
          Entry.Tag := 21;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsPrjName;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiSCUName);
          Entry.Tag := 22;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsSCUName;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiExecutableFile);
          Entry.Tag := 23;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsExecutableFile;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiExecutableINIFile);
          Entry.Tag := 24;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := 0; // hctxPopupToolsExecutableFile;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := '-';
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiErrorFileName);
          Entry.Tag := 31;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsErrorFileName;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiErrorLine2);
          Entry.Tag := 32;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsErrorLine2;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiErrorColumn);
          Entry.Tag := 33;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsErrorColumn;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiErrorText);
          Entry.Tag := 34;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsErrorText;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := '-';
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiDriveOf);
          Entry.Tag := 41;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsDriveOf;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiDirectoryOf);
          Entry.Tag := 42;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsDirectoryOf;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiFileNameOf);
          Entry.Tag := 43;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsFileNameOf;
          ToolPopup.Items.Add(Entry);

          Entry.Create(ToolPopup);
          Entry.Caption := LoadNLSStr(SiFileNameExtOf);
          Entry.Tag := 44;
          Entry.OnClick := InsertMnemonic;
          Entry.HelpContext := hctxPopupToolsFileNameExtOf;
          ToolPopup.Items.Add(Entry);
     END;

     pt := Mnemos.ClientToScreen(Point(20,20));
     ToolPopup.Popup(pt.X,pt.Y);
END;


PROCEDURE TToolOptionDialog.InsertMnemonic(Sender:TObject);
VAR  s:STRING;
BEGIN
     CASE TComponent(Sender).Tag OF
        1: s := '$SAVEPRJ';
        2: s := '$SAVESCU';
        3: s := '$SAVEALL';
        4: s := '$SAVECUR';
       11: s := '$EDNAME';
       12: s := '$LINE';
       13: s := '$COL';
       21: s := '$PRJNAME';
       22: s := '$SCUNAME';
       23: s := '$EXENAME';
       24: s := '$ININAME';
       31: s := '$ERRNAME';
       32: s := '$ERRLINE';
       33: s := '$ERRCOL';
       34: s := '$ERRTEXT';
       41: s := '$DRIVE()';
       42: s := '$DIR()';
       43: s := '$NAME()';
       44: s := '$EXT()';
       ELSE exit;
     END;

     ParamEdit.Text := ParamEdit.Text + s;
     ParamEdit.CaptureFocus;
     WriteBackToList(NIL);
END;


PROCEDURE TToolOptionDialog.WriteBackToList(Sender:TObject);
VAR  i:LONGINT;
     ptd:PToolData;
BEGIN
     i := List.ItemIndex;
     IF (i < 0) OR (i >= List.Items.Count) THEN exit;

     ptd := ToolsList[i];
     ptd^.ToolName := NameEdit.Caption;
     ptd^.FileName := ProgEdit.Caption;
     ptd^.Parameter := ParamEdit.Caption;
     List.Items.Strings[i] := NameEdit.Caption;
END;
{$HINTS ON}



PROCEDURE ToolOptionDialog;
VAR  Dialog:TToolOptionDialog;
BEGIN
     Dialog.Create(NIL);
     Dialog.HelpContext := hctxDialogToolOptions;
     Dialog.Execute;
     Dialog.Destroy;

     InsertToolMenuItems;
     IdeSettings.Modified := TRUE;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Print Dialog                                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TPrinterDialog=CLASS(TDialog)
      PrnCombo:TComboBox;
      AllRadio,SelRadio:TRadioButton;
      StxCheck,RemCheck:TCheckBox;
      PROCEDURE SetupComponent;OVERRIDE;
      PROCEDURE EvWrench(Sender:TObject);
    END;


PROCEDURE TPrinterDialog.SetupComponent;
VAR  Group:TGroupBox;
     wrench:TBitBtn;
BEGIN
     Inherited SetupComponent;

     ClientWidth := 450;
     ClientHeight := 190;
     Caption := LoadNLSStr(SiPrintFile);

     InsertLabelNLS(SELF,10,140,70,20,SiPrinter);

     PrnCombo := InsertComboBox(SELF,85,140,215,26,csDropDownList);
     PrnCombo.Items := Printer.Printers;
     PrnCombo.ItemIndex := Printer.PrinterIndex;

     Group := InsertGroupBoxNLS(SELF,10,20,120,85,SiPrintRange);
     AllRadio := InsertRadioButtonNLS(Group,10,35,105,20,SiPrintAll,0);
     SelRadio := InsertRadioButtonNLS(Group,10,10,105,20,SiPrintSelected,0);

     Group := InsertGroupBoxNLS(SELF,140,20,160,85,SiLayout);
     StxCheck := InsertCheckBoxNLS(Group,10,35,145,20,SiSyntaxBold,0);
     RemCheck := InsertCheckBoxNLS(Group,10,10,145,20,SiCommentsItalic,0);

     InsertBitBtnNLS(SELF,320,140,120,30,bkOk,SiPrint,0);
     InsertBitBtnNLS(SELF,320,100,120,30,bkCancel,SCancelButton,0);
     wrench := InsertBitBtnRes(SELF,320,60,120,30,1102,0,LoadNLSStr(SiSetup),'');
     wrench.ModalResult := 0;
     wrench.OnClick := EvWrench;
     InsertBitBtnNLS(SELF,320,20,120,30,bkHelp,SHelpButton,0);
END;


PROCEDURE TPrinterDialog.EvWrench(Sender:TObject);
BEGIN
     Printer.PrinterIndex:=PrnCombo.ItemIndex;
     Printer.OptionsDlg;
END;


PROCEDURE PrintDialog;
VAR  PSD:TPrinterDialog;
BEGIN
     IF Printer.Printers.Count = 0 THEN exit; {no chance}
     IF Printer.Printing THEN exit;
     IF CodeEditor.TopEditor = NIL THEN exit;

     PSD.Create(Application.MainForm);
     PSD.HelpContext := hctxDialogPrintFile;
     IF not CodeEditor.TopEditor.Selected THEN
     BEGIN
          PSD.SelRadio.Enabled := FALSE;
          PSD.AllRadio.Checked := TRUE;
     END
     ELSE PSD.SelRadio.Checked := TRUE;

     PSD.StxCheck.Checked := CodeEditor.TopEditor.FileType = ftPas;
     PSD.RemCheck.Checked := CodeEditor.TopEditor.FileType = ftPas;


     IF PSD.Execute THEN {Printer selektiert}
     BEGIN
          Printer.PrinterIndex := PSD.PrnCombo.ItemIndex;
          CodeEditor.TopEditor.Print(PSD.SelRadio.Checked,
                                     PSD.StxCheck.Checked,
                                     PSD.RemCheck.Checked);
     END;
     PSD.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Language Settings Dialog                                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

CONST
  VDEStandardLanguage:STRING='English';


TYPE TNLSSelectDialog=CLASS(TDialog)
      PRIVATE
        DualList:TDualList;
      PUBLIC
        PROCEDURE SetupComponent;OVERRIDE;
      END;


PROCEDURE TNLSSelectDialog.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Width:=450;
     Height:=280;
     Caption:=LoadNLSStr(SiSelectLanguagesToInstall);

     DualList:=InsertDualList(SELF,10,50,420,190,LoadNLSStr(SiAvailableLanguages),
                              LoadNLSStr(SiLanguagesToInstall));

     InsertBitBtnNLS(SELF,10,10,100,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,130,10,100,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,250,10,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

TYPE
    TLanguageSettingsDialog=CLASS(TDialog)
      PRIVATE
         LastHintControl:TControl;
         Notebook:TTabbedNotebook;
         VDEPage:TPage;
         ApplicationPage:TPage;
         Languages:TListBox;
         InstallButton,DeleteButton:TButton;
         Combo:TComboBox;
         AppLanguages:TCheckListBox;
         AppInstallButton,AppDeleteButton:TButton;
         AppCombo:TComboBox;
         LanguageList:PVDELanguageList;
         OldLanguage:STRING;
      PUBLIC
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
         PROCEDURE SetMouseHint(Control:TControl;AHint:LONGINT);
         PROCEDURE OnInstall(Sender:TObject);
         PROCEDURE OnDelete(Sender:TObject);
         PROCEDURE OnAppNLSInstall(Sender:TObject);
         PROCEDURE OnAppNLSDelete(Sender:TObject);
         PROCEDURE InstallNewLanguage(NewItem:PVDELanguageList);
         PROCEDURE LanguageSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE OnAppLanguageSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE OnAppItemStateChanged(Sender:TObject);
    END;


PROCEDURE DestroyVDELanguageList(VAR List:PVDELanguageList);
VAR Next:PVDELanguageList;
BEGIN
    WHILE List<>NIL DO
    BEGIN
         IF List^.TableLen<>0 THEN
           IF List^.Table<>NIL THEN FreeMem(List^.Table,List^.TableLen);

         Next:=List^.Next;
         Dispose(List);
         List:=Next;
    END;
END;

PROCEDURE WriteVDELanguageList(List:PVDELanguageList);
VAR
   f:FILE;
   dir,name,ext:STRING;
   b:BYTE;
LABEL err;
BEGIN
     FSplit(ParamStr(0),dir,name,ext);
     name:=dir+name+'.MSG';
     System.Assign(f,name);

     IF List=NIL THEN
     BEGIN
          {$I-}
          Erase(f);
          {$I+}
          exit;
     END;

     {$I-}
     Rewrite(f);
     {$I+}
     IF IOResult<>0 THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiErrorWritingMSG));
          exit;
     END;

     WHILE List<>NIL DO
     BEGIN
         {$I-}
         BlockWrite(f,List^.Name,length(List^.Name)+1);
         {$I+}
         IF IoResult<>0 THEN
         BEGIN
err:
              ErrorBox(LoadNLSStr(SiFatalErrorWritingMSG));
              {$I-}
              System.Close(f);
              Erase(f);
              {$I+}
         END;

         {$I-}
         BlockWrite(f,List^.Active,1);
         {$I+}
         IF IoResult<>0 THEN goto err;

         {$I-}
         BlockWrite(f,List^.TableLen,4);
         {$I+}
         IF IoResult<>0 THEN goto err;

         {$I-}
         BlockWrite(f,List^.Table^,List^.TableLen);
         {$I+}
         IF IoResult<>0 THEN goto err;

         List:=List^.Next;
     END;

     b:=0;
     {$I-}
     BlockWrite(f,b,1);
     {$I+}
     IF IoResult<>0 THEN goto err;

     {$I-}
     System.Close(f);
     {$I+}
END;


FUNCTION ReadVDELanguageList(ShowError:BOOLEAN):PVDELanguageList;
VAR f:FILE;
    dir,name,ext:STRING;
    dummy:PVDELanguageList;
    b:BYTE;
    res:LONGWORD;
LABEL again,err;
BEGIN
  Application.LogWriteln('ReadVDELanguageList');
  Result:=NIL;

  FSplit(ParamStr(0),dir,name,ext);
  name:=dir+name+'.MSG';
  System.Assign(f,name);

  {$I-}
  Reset(f);
  {$I+}
  IF IoResult<>0 THEN exit;

again:
  {$I-}
  BlockRead(f,b,1,Res);
  {$I+}
  IF ((IOResult<>0)OR(Res<>1)) THEN
  BEGIN
err:
      IF ShowError THEN ErrorBox(LoadNLSStr(SiErrorReadingMSG));
      {$I-}
      System.Close(f);
      {$I+}
      DestroyVDELanguageList(result);
      exit;
  END;

  IF b=0 THEN
  BEGIN
       {$I-}
       System.close(f);
       {$I+}
       exit;
  END;

  name[0]:=chr(b);
  {$I-}
  BlockRead(f,name[1],b,Res);
  {$I+}
  IF ((IoResult<>0)OR(res<>b)) THEN goto err;

  IF Result=NIL THEN
  BEGIN
      New(Result);
      dummy:=Result;
  END
  ELSE
  BEGIN
      dummy:=Result;
      WHILE dummy^.Next<>NIL DO dummy:=dummy^.Next;
      New(Dummy^.Next);
      dummy:=dummy^.Next;
  END;

  Dummy^.Name:=Name;

  {$I-}
  BlockRead(f,dummy^.Active,1,res);
  {$I+}
  IF ((IoResult<>0)OR(res<>1)) THEN goto err;

  {$I-}
  BlockRead(f,dummy^.TableLen,4,res);
  {$I+}
  IF ((IoResult<>0)OR(res<>4)) THEN goto err;

  Getmem(dummy^.Table,dummy^.TableLen);

  {$I-}
  BlockRead(f,dummy^.Table^,dummy^.TableLen,res);
  {$I+}
  IF ((IoResult<>0)OR(res<>dummy^.TableLen)) THEN goto err;

  goto Again;
END;



PROCEDURE TLanguageSettingsDialog.LanguageSelect(Sender:TObject;Index:LONGINT);
VAR dummy:PVDELanguageList;
    s:STRING;
BEGIN
     dummy:=LanguageList;
     s:=Combo.Items[Index];
     WHILE dummy<>NIL DO
     BEGIN
          IF dummy^.Name=s THEN dummy^.Active:=TRUE
          ELSE dummy^.Active:=FALSE;
          dummy:=dummy^.Next;
     END;
END;

PROCEDURE TLanguageSettingsDialog.InstallNewLanguage(NewItem:PVDELanguageList);
VAR dummy,Last,Next:PVDELanguageList;
    s,s1:STRING;
BEGIN
     dummy:=LanguageList;
     s:=NewItem^.Name;
     UpcaseStr(s);
     Last:=NIL;
     WHILE dummy<>NIL DO
     BEGIN
          s1:=dummy^.name;
          UpcaseStr(s1);
          IF s=s1 THEN
          BEGIN
               IF Dialogs.MessageBox(FmtLoadNLSStr(SiLanguageAlreadyInstalled,[dummy^.Name])+#13#10+
                             LoadNLSStr(SiOverwriteLanguage),
                             mtConfirmation,mbYesNo)=mrYes THEN
               BEGIN
                   IF dummy^.TableLen>0 THEN
                     IF dummy^.Table<>NIL THEN
                       FreeMem(dummy^.Table,dummy^.TableLen);
                   dummy^.TableLen:=NewItem^.TableLen;
                   GetMem(dummy^.Table,dummy^.TableLen);
                   System.Move(NewItem^.Table^,dummy^.Table^,dummy^.TableLen);
               END;
               exit;
          END;
          Last:=Dummy;
          dummy:=dummy^.Next;
     END;

     New(Next);
     Next^.Name:=NewItem^.Name;
     Next^.TableLen:=NewItem^.TableLen;
     GetMem(Next^.Table,Next^.TableLen);
     System.Move(NewItem^.Table^,Next^.Table^,Next^.TableLen);
     IF Last=NIL THEN LanguageList:=Next
     ELSE Last^.Next:=Next;
     Languages.Items.Add(Next^.Name);
     Combo.Items.Add(Next^.Name);
END;

PROCEDURE TLanguageSettingsDialog.OnInstall(Sender:TObject);
VAR FOD:TOpenDialog;
    s,Name:STRING;
    f:FILE;
    ppp,p:^LONGWORD;
    Len:LONGINT;
    Res:LONGWORD;
    AvailableRes,dummy:PVDELanguageList;
    Count:WORD;
    Size:LONGWORD;
    t:LONGINT;
    TableStart:POINTER;
    Dlg:TNLSSelectDialog;

    PROCEDURE SkipResource;
    VAR Count:WORD;
        Size:LONGWORD;
        b:BYTE;
        t:LONGINT;
    BEGIN
         Count:=p^ AND 65535;
         inc(p,2);
         FOR t:=1 TO Count DO
         BEGIN
             Size:=p^;
             inc(p,4);
             b:=p^ AND 255;
             inc(p,b+1);
             inc(p,Size);
         END;
    END;

    FUNCTION GetResSibylLanguage(Start:POINTER;Max:LONGWORD):STRING;
    VAR p:^WORD;
    BEGIN
         Result:='';
         p:=Start;
         WHILE LONGWORD(p)<Max DO
         BEGIN
              IF p^=SiSibylLanguage THEN
              BEGIN
                   inc(p,2);
                   result[0]:=chr(p^ AND 255);
                   inc(p);
                   System.Move(p^,Result[1],ord(Result[0]));
                   exit;
              END;
              inc(p,2);
              inc(p,(p^ AND 255)+1);
         END;
    END;

BEGIN       
    FOD.Create(SELF);
    FOD.HelpContext := hctxDialogOpenInstallLanguage;
    FOD.Caption := LoadNLSStr(SiSelectAFile);
    {$IFDEF OS2}
    FOD.AddFilter(LoadNLSStr(SiSibylResourceFiles)+' ('+ALL_FILES_UC_WDSibyl_Res_SRF+')', ALL_FILES_UC_WDSibyl_Res_SRF); // '*.SRF');
    {$ENDIF}
    {$IFDEF WIN32}
    FOD.AddFilter(LoadNLSStr(SiSibylResourceFiles)+' ('+ALL_FILES_UC_WDSibyl_Res_SRW+')', ALL_FILES_UC_WDSibyl_Res_SRW); // '*.SRW');
    {$ENDIF}
    IF FOD.Execute THEN
    BEGIN
         s:=FOD.FileName;
         FOD.Destroy;

         System.Assign(f,s);
         {$I-}
         Reset(f);
         {$I+}
         IF IOResult<>0 THEN
         BEGIN
              ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[s]));
              exit;
         END;

         Len:=FileSize(f);
         GetMem(p,Len);
         ppp:=p;
         {$I-}
         BlockRead(f,p^,Len,Res);
         {$I-}
         IF ((IOResult<>0)OR(Res<>Len)) THEN
         BEGIN
              ErrorBox(FmtLoadNLSStr(SiFileReadError,[s]));
              FreeMem(ppp,Len);
              {$I-}
              System.Close(f);
              {$I+}
              exit;
         END;
         {$I-}
         System.Close(f);
         {$I+}

         AvailableRes:=NIL;

         IF (p^ AND 65535)<>68 THEN
         BEGIN
              ErrorBox(LoadNLSStr(SiIllegalResourceFile));
              FreeMem(ppp,Len);
              exit;
         END;
         inc(p,8);  //onto named icon count

         SkipResource;  //skip named icons
         SkipResource;  //skip named pointers
         SkipResource;  //skip named bitmaps

         Count:=p^;
         inc(p,2);
         FOR t:=1 TO Count DO
         BEGIN
              TableStart:=p;
              Size:=p^;
              inc(p,4);
              s[0]:=chr(p^ AND 255);
              inc(p);
              System.Move(p^,s[1],ord(s[0]));
              inc(p,length(s));
              IF s='WDSIBYL_NLS_DEFAULT' THEN
              BEGIN
                   //language found, look if we find index "SiSibylLanguage" that contains the language identifier...
                   inc(p,4);  //Skip MinIndex and MaxIndex

                   Name:=GetResSibylLanguage(p,LONGWORD(p)+Size-4);
                   IF ((Name<>'')AND(Name<>VDEStandardLanguage)) THEN
                   BEGIN
                        IF AvailableRes=NIL THEN
                        BEGIN
                             New(AvailableRes);
                             dummy:=AvailableRes;
                        END
                        ELSE
                        BEGIN
                             dummy:=AvailableRes;
                             WHILE dummy^.Next<>NIL DO Dummy:=Dummy^.Next;
                             New(dummy^.Next);
                             dummy:=dummy^.Next;
                        END;

                        dummy^.Name:=Name;
                        dummy^.TableLen:=Size+length(s)+1+4;
                        GetMem(dummy^.Table,dummy^.TableLen);
                        System.Move(TableStart^,dummy^.Table^,dummy^.TableLen);
                   END;

                   inc(p,Size-4);
              END
              ELSE inc(p,Size);
         END;

         FreeMem(ppp,Len);
         IF AvailableRes=NIL THEN
         BEGIN
              ErrorBox(LoadNLSStr(SiResDoesNotContainLanguages));
              exit;
         END;

         Dlg.Create(NIL);
         Dlg.HelpContext := hctxDialogNLSSelection;

         dummy:=AvailableRes;
         WHILE dummy<>NIL DO
         BEGIN
              Dlg.DualList.SrcItems.Add(dummy^.Name);
              dummy:=dummy^.Next;
         END;

         IF Dlg.Execute THEN
         BEGIN
              FOR t:=0 TO Dlg.DualList.DstItems.Count-1 DO
              BEGIN
                   dummy:=AvailableRes;
                   WHILE dummy<>NIL DO
                   BEGIN
                        IF dummy^.Name=Dlg.DualList.DstItems[t] THEN break;
                        dummy:=dummy^.Next;
                   END;

                   IF Dummy<>NIL THEN InstallNewLanguage(dummy);
              END;

              Dlg.Destroy;
         END
         ELSE Dlg.Destroy;

         DestroyVDELanguageList(AvailableRes);
    END
    ELSE FOD.Destroy;
END;

PROCEDURE TLanguageSettingsDialog.OnDelete(Sender:TObject);
VAR s:STRING;
    dummy,Last:PVDELanguageList;
BEGIN
     IF Languages.ItemIndex<0 THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiNoItemSelected));
          exit;
     END;
     s:=Languages.Items[Languages.ItemIndex];

     IF s=VDEStandardLanguage THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiYouCannotDeleteThisItem));
          exit;
     END;

     dummy:=LanguageList;
     Last:=NIL;
     WHILE dummy<>NIL DO
     BEGIN
          IF dummy^.Name=s THEN break;
          Last := dummy;
          dummy:=dummy^.Next;
     END;

     IF Dummy=NIL THEN exit; //nicht gefunden

     IF Dummy^.TableLen>0 THEN
      IF Dummy^.Table<>NIL THEN FreeMem(dummy^.Table,dummy^.TableLen);

     IF Last=NIL THEN LanguageList:=dummy^.Next //erster Eintrag
     ELSE Last^.Next:=dummy^.Next;
     Dispose(dummy);

     IF Combo.Text=s THEN Combo.Text:=VDEStandardLanguage; //!!
     Combo.Items.Delete(Languages.ItemIndex);
     Languages.Items.Delete(Languages.ItemIndex);
END;

PROCEDURE TLanguageSettingsDialog.SetMouseHint(Control:TControl;AHint:LONGINT);
BEGIN
     Control.ParentShowHint := FALSE;
     Control.ShowHint := FALSE;
     Control.Hint := LoadNLSStr(AHint);
     Control.OnMouseMove := EvMouseHint;
END;

{$HINTS OFF}
PROCEDURE TLanguageSettingsDialog.EvMouseHint(Sender:TObject;Shift:TShiftState;X,Y:LONGINT);
BEGIN
     IF Sender IS TControl THEN
     BEGIN
          Notebook.PageHint := TControl(Sender).Hint;

          IF LastHintControl <> Sender THEN
          BEGIN
               IF LastHintControl <> NIL THEN
               BEGIN
                    LastHintControl.PenColor := clWindowText;
                    LastHintControl := NIL;
               END;
               IF (Sender IS TCheckBox) OR (Sender IS TRadioButton) THEN
               BEGIN
                    TControl(Sender).PenColor := clHighlightText;
                    LastHintControl := TControl(Sender);
               END;
          END;
     END;
END;
{$HINTS ON}

//!!!!!!!!!! bei nderungen auch Language Manager und CLASSES ndern!!!!!!!!!!!!!!!!!!!
//////////////////////////////////////////////////////////////////////////////////////////////////////////
TYPE
     PLanguageMessages=^TLanguageMessages;
     TLanguageMessages=RECORD
                         Name:PString;  //Language name
                         StringTableLen:LONGWORD;
                         StringTable:POINTER;
                         Next:PLanguageMessages;
     END;

     PLanguageComponent=^TLanguageComponent;
     TLanguageComponent=RECORD
                         Name:PString;
                         OriginalInstance:TComponent;
                         Instance:TComponent;
                         ValueScope:BYTE;
                         ValueTyp:BYTE;
                         ValueRead:TPropertyReadWriteRecord;
                         ValueWrite:TPropertyReadWriteRecord;
                         ValueSize:LONGWORD;
                         ValueLen:LONGWORD;
                         Value:POINTER;
                         ControlLeft,ControlBottom:LONGINT;
                         ControlWidth,ControlHeight:LONGINT;
                         OrigControlLeft,OrigControlBottom:LONGINT;
                         OrigControlWidth,OrigControlHeight:LONGINT;
                         Next:PLanguageComponent;
     END;

     PLanguageItem=^TLanguageItem;
     TLanguageItem=RECORD
                         Name:PString;
                         Components:PLanguageComponent;
                         Menus:PLanguageComponent;
                         StringTables:PLanguageComponent;
                         Next:PLanguageItem;
     END;
//!!!!!!!!!! bei nderungen auch Language Manager ndern!!!!!!!!!!!!!!!!!!!
     PLanguageInfo=^TLanguageInfo;
     TLanguageInfo=RECORD
                         CurrentLanguageName:PString;  //only copy !!
                         CurrentLanguageComponents:PLanguageComponent;  //only copy !
                         CurrentLanguageMenus:PLanguageComponent; //only copy !
                         CurrentLanguageStringTables:PLanguageComponent; //only copy
                         Items:PLanguageItem;
     END;
//!!!!!!!!!! bei nderungen auch Language Manager und CLASSES ndern!!!!!!!!!!!!!!!!!!!
//////////////////////////////////////////////////////////////////////////////////////////////////////////


PROCEDURE TLanguageSettingsDialog.OnAppLanguageSelect(Sender:TObject;Index:LONGINT);
VAR Name,s:STRING;
    t:LONGINT;
    FormItem:PFormListItem;
    Form:TForm;
BEGIN
     Name:=AppLanguages.Items[Index];

     SetCurrentLanguageTable(Name);
     Application.Language:=CurrentLanguageTable;

     FOR t:=0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem:=PFormListItem(Project.Forms[t]);
          IF FormItem^.SCUPointer=NIL THEN //Form is visible
          BEGIN
               Form:=TForm(FormItem^.Form);
{               Form.Language:=Name; }
          END
          ELSE //Form is invisible, modifiy SCU Info
          BEGIN
               //?????????????????????????????????????????????????????????????????????????
          END;
     END;

     ASM
        LEA EAX,Name
        PUSH EAX
        CALLN32 Classes.SetAppLanguage
     END;

     UpcaseStr(Name);
     FOR t:=0 TO AppLanguages.Items.Count-1 DO
     BEGIN
          s:=AppLanguages.Items[t];
          UpcaseStr(s);
          IF s=Name THEN AppLanguages.State[t]:=clsChecked
          ELSE AppLanguages.State[t]:=clsUnchecked;
     END;
END;


PROCEDURE FreeLanguage(VAR Component:PLanguageComponent);
VAR Next:PLanguageComponent;
BEGIN
     WHILE Component<>NIL DO
     BEGIN
          Next:=Component^.Next;
          FreeMem(Component^.Name,length(Component^.Name^)+1);
          IF Component^.Value<>NIL THEN FreeMem(Component^.Value,Component^.ValueLen);
          dispose(Component);
          Component:=Next;
     END;
END;

PROCEDURE TLanguageSettingsDialog.OnAppNLSDelete(Sender:TObject);
VAR s:string;
    dummy,LanguageMessages,Last:PLanguageMessages;
    t:LONGINT;
    Form:TForm;
    FormItem:PFormListItem;
    Info:PLanguageInfo;
    Item,LastItem,dummyItem:PLanguageItem;
BEGIN
     IF AppLanguages.ItemIndex<0 THEN
     BEGIN
         ErrorBox(LoadNLSStr(SiNoItemSelected));
         exit;
     END;

     s:=AppLanguages.Items[AppLanguages.ItemIndex];
     IF s='Default' THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiYouCannotDeleteThisItem));
          exit;
     END;

     IF s=AppCombo.Text THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiYouCannotDeleteThisLanguage));
          exit;
     END;

     //l”sche Item aus der Liste oder in der SCU !
     ASM
        MOV EAX,Classes.LanguageMessages;
        MOV LanguageMessages,EAX
     END;

     Last:=NIL;
     dummy:=LanguageMessages;
     WHILE dummy<>NIL DO
     BEGIN
          IF dummy^.Name^=s THEN
          BEGIN
               IF Last=NIL THEN LanguageMessages:=dummy^.Next
               ELSE Last^.Next:=dummy^.Next;
               IF dummy^.StringTable<>NIL THEN FreeMem(dummy^.StringTable,dummy^.StringTableLen);
               FreeMem(dummy^.Name,length(Dummy^.Name^)+1);
               Dispose(dummy);
               break;
          END
          ELSE
          BEGIN
               Last:=dummy;
               dummy:=dummy^.Next;
          END;
     END;

     ASM
        MOV EAX,LanguageMessages;
        MOV Classes.LanguageMessages,EAX
     END;

     FOR t:=0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem:=PFormListItem(Project.Forms[t]);
         IF FormItem^.SCUPointer=NIL THEN
         BEGIN
              Form:=TForm(FormItem^.Form); //Form Is Visible

              ASM
                 PUSH DWORD PTR Form
                 CALLN32 Classes.GetLanguages
                 MOV Info,EAX
              END;

              IF Info=NIL THEN continue;
              Item:=Info^.Items;
              dummyItem:=Item;
              LastItem:=NIL;
              WHILE dummyItem<>NIL DO
              BEGIN
                   IF dummyItem^.Name^=s THEN
                   BEGIN
                        IF LastItem=NIL THEN Info^.Items:=dummyItem^.Next
                        ELSE LastItem^.Next:=dummyItem^.Next;
                        FreeMem(dummyItem^.Name,length(dummyItem^.Name^)+1);
                        FreeLanguage(dummyItem^.Components);
                        FreeLanguage(dummyItem^.Menus);
                        FreeLanguage(dummyItem^.StringTables);
                        dispose(dummyItem);
                        break;
                   END
                   ELSE
                   BEGIN
                        LastItem:=dummyItem;
                        dummyItem:=dummyItem^.Next;
                   END;
              END;

              //nur noch "Default" da ???
              IF ((Info^.Items=NIL)OR(Info^.Items^.Next=NIL)) THEN
              BEGIN
                   IF Info^.Items<>NIL THEN
                   BEGIN
                        FreeMem(Info^.Items^.Name,length(Info^.Items^.Name^)+1);
                        FreeLanguage(Info^.Items^.Components);
                        FreeLanguage(Info^.Items^.Menus);
                        FreeLanguage(Info^.Items^.StringTables);
                        dispose(Info^.Items);
                   END;
                   Dispose(Info);
                   Info:=NIL;
              END;

              ASM
                 PUSH DWORD PTR Form
                 PUSH DWORD PTR Info
                 CALLN32 Classes.SetLanguages
              END;
         END
         ELSE //Modify SCU
         BEGIN
              DeleteLanguageSCU(FormItem^.SCUPointer,FormItem^.SCUSize,s);
         END;
     END;

     IF AppCombo.Items.IndexOf(s)>=0 THEN
       AppCombo.Items.Delete(AppCombo.Items.IndexOf(s));
     AppLanguages.Items.Delete(AppLanguages.ItemIndex);
END;


PROCEDURE AddLanguage(VAR SCUInfo:POINTER;VAR SCULen:LONGINT;Name:STRING;
                      Components,Menus,StringTables:PLanguageComponent);
VAR dummy:PSCUFileFormat;
    p,p1:^LONGWORD;
    ps:^STRING;
    s:STRING;
    t,t1:LONGINT;
    Flags,b:BYTE;
    Size:^LONGWORD;
    Diff:LONGINT;
    NewInfo:POINTER;
    NewLen:LONGWORD;
    Count:LONGINT;

    FUNCTION CalcSize(Component:PLanguageComponent):LONGINT;
    BEGIN
         result:=1; //1 Byte for terminating 0
         WHILE Component<>NIL DO
         BEGIN
              inc(result);  //1
              inc(result,length(Component^.Name^)+1);
              inc(result,1+4);  //ValueTyp and ValueLen
              inc(result,Component^.ValueLen);
              inc(result,16);  //skip position and dimensions

              Component:=Component^.Next;
         END;
    END;

    PROCEDURE WriteLang(VAR p:POINTER;Component:PLanguageComponent);
    VAR p1:^LONGWORD;
        b:BYTE;
    BEGIN
         p1:=p;
         WHILE Component<>NIL DO
         BEGIN
              b:=1;
              System.Move(b,p1^,1);
              inc(p1);
              System.Move(Component^.Name^,p1^,length(Component^.Name^)+1);
              inc(p1,length(Component^.Name^)+1);
              System.Move(Component^.ValueTyp,p1^,1);
              inc(p1);
              p1^:=Component^.ValueLen;
              inc(p1,4);
              System.Move(Component^.Value^,p1^,Component^.ValueLen);
              inc(p1,Component^.ValueLen);
              System.Move(Component^.ControlLeft,p1^,16);
              inc(p1,16);

              Component:=Component^.Next;
         END;
         b:=0;
         System.Move(b,p1^,1);
         inc(p1);
         p:=p1;
    END;

BEGIN
     //first delete the language
     DeleteLanguageSCU(SCUInfo,SCULen,Name);

     dummy:=SCUInfo;

     //nur fr eine Form !
     p:=POINTER(dummy);
     inc(p,dummy^.ObjectOffset);

     p1:=POINTER(dummy);
     inc(p1,sizeof(TSCUFileFormat));
     Count:=dummy^.ObjectCount;
     FOR t:=1 TO Count DO
     BEGIN
          Flags:=p1^ AND 255;
          p1^:=p1^ OR 2;            //Language Info is available now !
          inc(p1);                  //skip Flag
          inc(p1,(p1^ AND 255)+1);  //skip Form Name
          inc(p1,(p1^ AND 255)+1);  //skip Form Unit Name
          inc(p1,(p1^ AND 255)+1);  //skip Form TypeName

          //If Message Information is available for this form (only for first) skip it !
          IF (Flags AND 8)<>0 THEN inc(p1,p1^);  //skip section

          //If Language Information is available for this form, remember and skip
          IF Flags AND 2<>0 THEN
          BEGIN
               p:=POINTER(p1);
               Size:=POINTER(p);
               inc(p,4); //skip size
               ps:=POINTER(p); //Current language
               inc(p,length(ps^)+1);

               ps:=POINTER(p);
               WHILE length(ps^)<>0 DO
               BEGIN
                    inc(ps);  //skip 1
                    p:=POINTER(ps);
                    inc(p,length(ps^)+1);

                    FOR t1:=1 TO 3 DO
                    BEGIN
                         WHILE (p^ AND 255)<>0 DO
                         BEGIN
                              inc(p); //skip 1
                              ps:=POINTER(p);
                              inc(p,length(ps^)+1);
                              inc(p); //skip valuetyp
                              inc(p,4+p^);
                              inc(p,16);  //skip position and dimensions
                         END;
                         inc(p);  //skip 0
                    END;
                    ps:=POINTER(p);
               END;

               Diff:=1;  //for 1
               Diff:=Diff+length(Name)+1;
               Diff:=Diff+CalcSize(Components);
               Diff:=Diff+CalcSize(Menus);
               Diff:=Diff+CalcSize(StringTables);

               Size^:=Size^+Diff;
               inc(dummy^.ObjectOffset,Diff);
               inc(dummy^.NameTableOffset,Diff);
               inc(dummy^.ResourceOffset,Diff);
               NewLen:=SCULen+Diff;
               GetMem(NewInfo,NewLen);

               System.Move(SCUInfo^,NewInfo^,longword(ps)-longword(SCUInfo));
               p:=POINTER(NewInfo);
               inc(p,longword(ps)-longword(SCUInfo));

               b:=1;
               System.Move(b,p^,1);
               inc(p);
               System.Move(Name,p^,length(Name)+1);
               inc(p,length(Name)+1);

               WriteLang(p,Components);
               WriteLang(p,Menus);
               WriteLang(p,StringTables);

               //terminating 0 is copied with this block !
               System.Move(ps^,p^,1+SCULen-(longword(ps)-longword(SCUInfo)));

               p1:=p;   //skip language info
               inc(p1);
          END
          ELSE
          BEGIN
               //there were no language info before
               Diff:=4;                 //size of language info
               s:='Default';
               Diff:=Diff+length(s)+1;  //current language;
               Diff:=Diff+1;  //for 1
               Diff:=Diff+length(Name)+1;
               Diff:=Diff+CalcSize(Components);
               Diff:=Diff+CalcSize(Menus);
               Diff:=Diff+CalcSize(StringTables);
               Diff:=Diff+1; //for terminating 0

               inc(dummy^.ObjectOffset,Diff);
               inc(dummy^.NameTableOffset,Diff);
               inc(dummy^.ResourceOffset,Diff);
               NewLen:=SCULen+Diff;
               GetMem(NewInfo,NewLen);

               System.Move(SCUInfo^,NewInfo^,longword(p1)-longword(SCUInfo));
               p:=POINTER(NewInfo);
               inc(p,longword(p1)-longword(SCUInfo));
               Size:=p;
               Size^:=Diff;
               inc(p,4);
               System.Move(s,p^,length(s)+1);  //current language
               inc(p,length(s)+1);

               b:=1;
               System.Move(b,p^,1);
               inc(p);
               System.Move(Name,p^,length(Name)+1);
               inc(p,length(Name)+1);

               WriteLang(p,Components);
               WriteLang(p,Menus);
               WriteLang(p,StringTables);

               b:=0;
               System.Move(b,p^,1);
               inc(p);
               System.Move(p1^,p^,1+SCULen-(longword(p1)-longword(SCUInfo)));

               p1:=p;   //skip language info
          END;

          FreeMem(SCUInfo,SCULen);
          SCUInfo:=NewInfo;
          SCULen:=NewLen;
     END;
END;

PROCEDURE TLanguageSettingsDialog.OnAppNLSInstall(Sender:TObject);
VAR FOD:TOpenDialog;
    s,s1,Name,FileName:STRING;
    f:FILE;
    t,LanguageCount,ModuleCount,t1,FormCount,t2:LONGINT;
    Messages,dummy:PLanguageMessages;
    LanguageMessages:PLanguageMessages;
    b:BYTE;
    ModuleName,FormName:STRING;
    Components,Menus,StringTables:PLanguageComponent;
    Info,dummyInfo:PLanguageInfo;
    Item,dummyItem:PLanguageItem;
    TheForm:TForm;
    TheFormSCU:^LONGWORD;
    FormItem:PFormListItem;

    PROCEDURE ReadLanguage(VAR Component:PLanguageComponent);
    VAR dummy,Last:PLanguageComponent;
        s:STRING;
        b:BYTE;
    BEGIN
         Component:=NIL;
         TRY
            BlockRead(f,b,1);
            WHILE b<>0 DO
            BEGIN
                 BlockRead(f,b,1);
                 s[0]:=chr(b);
                 BlockRead(f,s[1],b);

                 IF Component=NIL THEN
                 BEGIN
                     New(Component);
                     dummy:=Component;
                 END
                 ELSE
                 BEGIN
                     dummy:=Last;
                     New(dummy^.Next);
                     dummy:=dummy^.Next;
                 END;

                 GetMem(dummy^.Name,length(s)+1);
                 dummy^.Name^:=s;
                 Last:=dummy;

                 BlockRead(f,dummy^.ValueLen,4);
                 GetMem(dummy^.Value,dummy^.ValueLen);
                 BlockRead(f,dummy^.Value^,dummy^.ValueLen);
                 BlockRead(f,dummy^.ControlLeft,4);
                 BlockRead(f,dummy^.ControlBottom,4);
                 BlockRead(f,dummy^.ControlWidth,4);
                 BlockRead(f,dummy^.ControlHeight,4);

                 BlockRead(f,b,1);
            END;
         EXCEPT
              s:=FileName;
              ErrorBox(FmtLoadNLSStr(SiFileReadError,[s]));
              WHILE Component<>NIL DO
              BEGIN
                   dummy:=Component^.Next;
                   IF Component^.Name<>NIL THEN FreeMem(Component^.Name,length(Component^.Name^)+1);
                   IF Component^.Value<>NIL THEN FreeMem(Component^.Value,Component^.ValueLen);
                   Dispose(Component);
                   Component:=dummy;
              END;
              RAISE;
         END;
    END;

BEGIN
     FOD.Create(SELF);
     FOD.HelpContext := hctxDialogOpenAppInstallLanguage;
     FOD.Caption := LoadNLSStr(SiSelectAFile);
     FOD.AddFilter(LoadNLSStr(SiSibylLanguageFiles)+' ('+ALL_FILES_UC_WDSibyl_SLF+')', ALL_FILES_UC_WDSibyl_SLF);
     IF FOD.Execute THEN
     BEGIN
         Name:=FOD.FileName;
         FileName:=Name;
         FOD.Destroy;

         System.Assign(f,Name);
         {$I-}
         Reset(f);
         {$I+}
         IF IOResult<>0 THEN
         BEGIN
             ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[Name]));
             exit;
         END;

         Messages:=NIL;
         TRY
            Name[0]:=#5;
            BlockRead(f,Name[1],5);
            IF Name<>'SLF01' THEN
            BEGIN
                ErrorBox(FmtLoadNLSStr(SiIllegalFileFormat,[Name]));
                RAISE Exception.Create('');
            END;

            BlockRead(f,LanguageCount,4);

            FOR t:=1 TO LanguageCount DO
            BEGIN
                 TRY
                    BlockRead(f,b,1);
                    Name[0]:=chr(b);
                    Blockread(f,Name[1],b);
                    IF Messages=NIL THEN
                    BEGIN
                         New(Messages);
                         dummy:=Messages;
                    END
                    ELSE
                    BEGIN
                         dummy:=Messages;
                         WHILE dummy^.Next<>NIL DO Dummy:=Dummy^.Next;
                         New(dummy^.Next);
                         dummy:=dummy^.Next;
                    END;
                    GetMem(dummy^.Name,b+1);
                    System.Move(Name,dummy^.Name^,b+1);
                    BlockRead(f,dummy^.StringTableLen,4);
                    GetMem(dummy^.StringTable,dummy^.StringTableLen);
                    BlockRead(f,dummy^.StringTable^,dummy^.StringTableLen);
                 EXCEPT
                     ErrorBox(FmtLoadNLSStr(SiFileReadError,[FileName]));
                     WHILE Messages<>NIL DO
                     BEGIN
                          dummy:=Messages^.Next;
                          IF Messages^.Name<>NIL THEN FreeMem(Messages^.Name,length(Messages^.Name^)+1);
                          IF Messages^.StringTable<>NIL THEN FreeMem(Messages^.StringTable,Messages^.StringTableLen);
                          dispose(Messages);
                          Messages:=dummy;
                     END;
                     RAISE;
                 END;
            END;

            dummy:=Messages;
            WHILE dummy<>NIL DO
            BEGIN
                AppLanguages.Items.Add(dummy^.Name^);
                AppCombo.Items.Add(dummy^.Name^);

                dummy:=dummy^.Next;
            END;

            ASM
               MOV EAX,Classes.LanguageMessages;
               MOV LanguageMessages,EAX
            END;

            IF LanguageMessages<>NIL THEN
            BEGIN
                 //wenn die MessageTabelle bereits existiert wird sie berschrieben !
                 dummy:=LanguageMessages;
                 WHILE dummy<>NIL DO
                 BEGIN
                      IF dummy^.Name^=Messages^.Name^ THEN
                      BEGIN
                          IF dummy^.StringTable<>NIL THEN FreeMem(dummy^.StringTable,dummy^.StringTableLen);
                          dummy^.StringTable:=Messages^.StringTable;
                          dummy^.StringTableLen:=Messages^.StringTableLen;
                          freemem(Messages^.name,length(messages^.Name^)+1);
                          Dispose(messages);
                          Messages:=NIL;
                          break;
                      END;
                      dummy:=dummy^.Next;
                 END;

                 IF Messages<>NIL THEN
                 BEGIN
                      WHILE LanguageMessages^.Next<>NIL DO LanguageMessages:=LanguageMessages^.Next;
                      LanguageMessages^.Next:=Messages;
                      Messages:=NIL;
                 END;
            END
            ELSE
            BEGIN
                LanguageMessages:=Messages;
                ASM
                   MOV EAX,LanguageMessages
                   MOV Classes.LanguageMessages,EAX
                END;
                Messages:=NIL;
            END;

            BlockRead(f,ModuleCount,4);

            FOR t:=1 TO ModuleCount DO
            BEGIN
                BlockRead(f,b,1);
                ModuleName[0]:=chr(b);
                BlockRead(f,ModuleName[1],b);
                UpcaseStr(ModuleName);

                BlockRead(f,FormCount,4);
                FOR t1:=1 TO FormCount DO
                BEGIN
                     BlockRead(f,b,1);
                     FormName[0]:=chr(b);
                     BlockRead(f,FormName[1],b);

                     //search the Form
                     s:=FormName;
                     UpcaseStr(s);
                     TheForm:=NIL;
                     TheFormSCU:=NIL;
                     FOR t2:=0 TO Project.Forms.Count-1 DO
                     BEGIN
                          FormItem:=PFormListItem(Project.Forms[t2]);
                          Name:=FormItem^.FormName;
                          UpcaseStr(Name);
                          IF Name=s THEN
                          BEGIN //found
                               IF FormItem^.SCUPointer=NIL THEN TheForm:=TForm(FormItem^.Form) //Form Is Visible
                               ELSE TheFormSCU:=FormItem^.SCUPointer;
                               break;
                          END;
                     END;

                     IF ((TheForm=NIL)AND(TheFormSCU=NIL)) THEN
                     BEGIN
                          ErrorBox(FmtLoadNLSStr(SiFormNotFound,[FormName]));
                          RAISE Exception.Create('');
                     END;

                     BlockRead(f,b,1);
                     WHILE b<>0 DO
                     BEGIN
                          BlockRead(f,b,1);
                          Name[0]:=chr(b);
                          BlockRead(f,Name[1],b);

                          IF TheForm<>NIL THEN
                          BEGIN
                               ReadLanguage(Components);

                               ASM
                                  PUSH DWORD PTR TheForm
                                  CALLN32 Classes.GetLanguages
                                  MOV Info,EAX
                               END;

                               IF Info=NIL THEN
                               BEGIN
                                    New(Info);
                                    ASM
                                       PUSH DWORD PTR TheForm
                                       PUSH DWORD PTR Info
                                       CALLN32 Classes.SetLanguages
                                    END;
                                    Info^.CurrentLanguageName:=NIL;         //only copy !!
                                    Info^.CurrentLanguageComponents:=NIL;   //only copy !
                                    Info^.CurrentLanguageMenus:=NIL;        //only copy !
                                    Info^.CurrentLanguageStringTables:=NIL; //only copy
                                    dummyInfo:=Info;
                               END;

                               //look if the language is already present...
                               Item:=Info^.Items;
                               s1:=Name;
                               UpcaseStr(s1);
                               WHILE Item<>NIL DO
                               BEGIN
                                    s:=Item^.Name^;
                                    UpcaseStr(s);
                                    IF s=s1 THEN
                                    BEGIN
                                         dummyItem:=Item^.Next;
                                         FreeLanguage(Item^.Components);
                                         FreeLanguage(Item^.Menus);
                                         FreeLanguage(Item^.StringTables);
                                         FreeMem(Item^.Name,length(Item^.Name^)+1);
                                         Dispose(Item);
                                         IF Item=Info^.Items THEN Info^.Items:=dummyItem;
                                         Item:=dummyItem;
                                    END
                                    ELSE Item:=Item^.Next;
                               END;

                               IF Info^.Items=NIL THEN
                               BEGIN
                                    New(Info^.Items);
                                    Item:=Info^.Items;
                               END
                               ELSE
                               BEGIN
                                    Item:=Info^.Items;
                                    WHILE Item^.Next<>NIL DO Item:=Item^.Next;
                                    New(Item^.Next);
                                    Item:=Item^.Next;
                               END;

                               GetMem(Item^.Name,length(Name)+1);
                               Item^.Name^:=Name;
                               Item^.Components:=Components;

                               ReadLanguage(Menus);
                               Item^.Menus:=Menus;
                               ReadLanguage(StringTables);
                               Item^.StringTables:=StringTables;
                          END
                          ELSE //The form is not visible, modify SCU Info (TheFormSCU) ...
                          BEGIN
                               ReadLanguage(Components);
                               ReadLanguage(Menus);
                               ReadLanguage(StringTables);

                               AddLanguage(FormItem^.SCUPointer,FormItem^.SCUSize,Name,
                                           Components,Menus,StringTables);

                               FreeLanguage(Components);
                               FreeLanguage(Menus);
                               FreeLanguage(StringTables);
                          END;

                          BlockRead(f,b,1);
                     END;
                END;
            END;

            {$I-}
            System.Close(f);
            {$I+}
         EXCEPT
            {$I-}
            System.Close(f);
            {$I+}
         END;
     END
     ELSE FOD.Destroy;
END;


PROCEDURE TLanguageSettingsDialog.OnAppItemStateChanged(Sender:TObject);
BEGIN
     IF AppLanguages.Items[AppLanguages.ItemIndex]=AppCombo.Text THEN
       IF AppLanguages.State[AppLanguages.ItemIndex]=clsUnchecked THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiYouCannotDisableActiveLang));
          AppLanguages.State[AppLanguages.ItemIndex]:=clsChecked;
     END;
END;


PROCEDURE TLanguageSettingsDialog.SetupComponent;
VAR idx:LONGINT;
    Group:TGroupBox;
    dummy:PVDELanguageList;
    Messages:PLanguageMessages;
    t,t1:LONGINT;
    s,s1:STRING;
    FormItem:PFormListItem;
    dummy1:PSCUFileFormat;
    p,p1:^LONGWORD;
    ps:^STRING;
    Flags:BYTE;
    Len:LONGWORD;
BEGIN
    Inherited SetupComponent;

    Caption := LoadNLSStr(SiLanguageSettings);
    ClientWidth := 580;
    ClientHeight := 420;

    Notebook := InsertTabbedNotebook(SELF,0,50,580,370);
    Notebook.Align := alTop;
    Notebook.Pages.Clear;

    InsertBitBtnNLS(SELF,20,10,100,30,bkOk,SOkButton,SClickHereToAccept);
    InsertBitBtnNLS(SELF,135,10,100,30,bkCancel,SCancelButton,SClickHereToCancel);
    InsertBitBtnNLS(SELF,250,10,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);

    idx := Notebook.Pages.Add(LoadNLSStr(SiVDE));
    VDEPage := TPage(Notebook.Pages.Objects[idx]);
    VDEPage.PenColor := clStaticText;
    SetMouseHint(VDEPage,SiVDEHint);

    Group := InsertGroupBoxNLS(VDEPage,10,80,310,200,SiInstalledLanguages);
    SetMouseHint(Group,SiInstalledLanguagesHint);

    Languages := InsertListBox(Group,10,10,180,155,'');
    Languages.Duplicates:=FALSE;
    SetMouseHint(Languages,SiInstalledVDELanguages);

    InstallButton:=InsertButton(Group,200,135,100,30,LoadNLSStr(SiInstall),'');
    SetMouseHint(InstallButton,SiInstallHint);
    InstallButton.OnClick:=OnInstall;

    DeleteButton:=InsertButton(Group,200,100,100,30,LoadNLSStr(SiDelete),'');
    SetMouseHint(DeleteButton,SiDeleteHint);
    DeleteButton.OnClick:=OnDelete;

    Group := InsertGroupBoxNLS(VDEPage,330,200,190,80,SiCurrentLanguage);
    SetMouseHint(Group,SiCurrentLanguageHint);

    Combo:=InsertComboBox(Group,10,25,170,20,csDropDownList);
    Combo.Duplicates:=FALSE;
    SetMouseHint(Combo,SiCurrentActiveVDELanguage);
    Combo.OnItemSelect:=LanguageSelect;

    Languages.Items.Add(VDEStandardLanguage);

    Combo.Items.Add(VDEStandardLanguage);
    Combo.Text:=VDEStandardLanguage;

    LanguageList:=ReadVDELanguageList(TRUE);
    dummy:=LanguageList;
    WHILE dummy<>NIL DO
    BEGIN
         Languages.Items.Add(dummy^.Name);
         Combo.Items.Add(dummy^.Name);
         IF dummy^.Active THEN Combo.Text:=dummy^.Name;

         dummy:=dummy^.Next;
    END;

    OldLanguage:=Combo.Text;

    idx := Notebook.Pages.Add(LoadNLSStr(SiApplication));
    ApplicationPage := TPage(Notebook.Pages.Objects[idx]);
    ApplicationPage.PenColor := clStaticText;
    SetMouseHint(ApplicationPage,SiApplicationHint);

    Group := InsertGroupBoxNLS(ApplicationPage,10,80,310,200,SiRuntimeLanguages);
    SetMouseHint(Group,SiRuntimeLanguagesHint);

    AppLanguages := InsertCheckListBox(Group,10,10,180,155);
    AppLanguages.OnStateChanged:=OnAppItemStateChanged;
    AppLanguages.Duplicates:=FALSE;
    SetMouseHint(AppLanguages,SiRuntimeLanguagesHint);

    AppInstallButton:=InsertButton(Group,200,135,100,30,LoadNLSStr(SiInstall),'');
    SetMouseHint(AppInstallButton,SiInstallHint);
    AppInstallButton.OnClick:=OnAppNLSInstall;

    AppDeleteButton:=InsertButton(Group,200,100,100,30,LoadNLSStr(SiDelete),'');
    SetMouseHint(AppDeleteButton,SiDeleteHint);
    AppDeleteButton.OnClick:=OnAppNLSDelete;

    Group := InsertGroupBoxNLS(ApplicationPage,330,200,190,80,SiStartupLanguage);
    SetMouseHint(Group,SiStartupLanguageHint);

    AppCombo:=InsertComboBox(Group,10,25,170,20,csDropDownList);
    AppCombo.Duplicates:=FALSE;
    SetMouseHint(AppCombo,SiStartupLanguageHint);
    AppCombo.OnItemSelect:=OnAppLanguageSelect;

    AppLanguages.Items.Add('Default');
    AppCombo.Items.Add('Default');

    AppCombo.Text:=Project.Settings.CurrentLanguage;

    {Process Forms already created}
    ASM
       MOV EAX,Classes.LanguageMessages
       MOV Messages,EAX
    END;

    WHILE Messages<>NIL DO
    BEGIN
         AppLanguages.Items.Add(Messages^.Name^);
         AppCombo.Items.Add(Messages^.Name^);

         Messages:=Messages^.Next;
    END;

    {Process invisible forms}
    FOR t:=1 TO Project.Forms.Count-1 DO
    BEGIN
         FormItem:=Project.Forms[t];
         IF FormItem^.SCUPointer<>NIL THEN
         BEGIN
              dummy1:=FormItem^.SCUPointer;
              WHILE dummy1<>NIL DO
              BEGIN
                   p:=POINTER(dummy1);
                   inc(p,dummy1^.ObjectOffset);

                   p1:=POINTER(dummy1);
                   inc(p1,sizeof(TSCUFileFormat));
                   FOR t1:=1 TO dummy1^.ObjectCount DO
                   BEGIN
                        Flags:=p1^ AND 255;       //1- auto create, 2- language info avail
                        inc(p1);                  //skip Flag
                        inc(p1,(p1^ AND 255)+1);  //skip Form Name
                        inc(p1,(p1^ AND 255)+1);  //skip Form Unit Name
                        inc(p1,(p1^ AND 255)+1);  //skip Form TypeName

                        //If Message Information is available for this form (only for first) remember and skip it !
                        IF (Flags AND 8)<>0 THEN
                        BEGIN
                             p:=POINTER(p1);
                             inc(p,4); //skip size
                             ps:=POINTER(p); //AppLanguage
                             inc(p,length(ps^)+1);

                             ps:=POINTER(p);
                             WHILE length(ps^)<>0 DO
                             BEGIN
                                  s:=ps^;
                                  AppLanguages.Items.Add(s);
                                  AppCombo.Items.Add(s);

                                  p:=POINTER(ps);
                                  inc(p,length(ps^)+1);
                                  Len:=p^;
                                  inc(p,4);
                                  inc(p,Len);
                                  ps:=POINTER(p);
                             END;

                             inc(p1,p1^);  //skip section
                        END;

                        IF Flags AND 2<>0 THEN inc(p1,p1^);  //skip language info
                   END;

                   dummy1:=dummy1^.NextEntry;
              END;
         END;
    END;

    {Check items}
    s:=Project.Settings.InActiveLanguages;
    UpcaseStr(s);
    FOR t:=0 TO AppLanguages.Items.Count-1 DO
    BEGIN
         s1:=AppLanguages.Items[t];
         UpcaseStr(s1);
         IF ((pos(';'+s1+';',s)=0)AND(pos(s1+';',s)<>1)AND(s1<>s)) THEN
         BEGIN
              //this languages shall be installed
              AppLanguages.State[t]:=clsChecked;
         END;
    END;

    IF AppCombo.Text='' THEN AppCombo.Text:='Default';

    NoteBook.PageIndex:=0;
END;


PROCEDURE LanguageSettingsDialog;
VAR Dlg:TLanguageSettingsDialog;
    s,s1:STRING;
    t:LONGINT;
BEGIN
  Dlg.Create(NIL);
  Dlg.HelpContext := hctxDialogLanguageSettings;
  Dlg.Execute;
  IF Dlg.ModalResult=cmOk THEN
    BEGIN
      WriteVDELanguageList(Dlg.LanguageList);
      IF Dlg.OldLanguage<>Dlg.Combo.Text THEN
        Dialogs.MessageBox(LoadNLSStr(SiChangesHaveBeenMadeToVDE)+#13#10+
                           LoadNLSStr(SiYouMustRestartSibyl),mtInformation,[mbOk]);
    END;

  s:='';
  FOR t:=0 TO Dlg.AppLanguages.Items.Count-1 DO
  BEGIN
       IF Dlg.AppLanguages.State[t]<>clsChecked THEN
       BEGIN
            s1:=Dlg.AppLanguages.Items[t];
            UpcaseStr(s1);
            IF s1='DEFAULT' THEN continue;
            IF s<>'' THEN s:=s+';';
            s:=s+Dlg.AppLanguages.Items[t];
       END;
  END;
  Project.Settings.InActiveLanguages:=s;
  Project.Settings.CurrentLanguage:=Dlg.AppCombo.Text;

  DestroyVDELanguageList(Dlg.LanguageList);
  Dlg.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Toolbars Dialog                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TToolbarsDialog=CLASS(TDialog)
       PRIVATE
         List:TCheckListBox;
         PROCEDURE EvStateChanged(Sender:TObject);
       PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
     END;


PROCEDURE TToolbarsDialog.SetupComponent;
VAR i:LONGINT;
    Panel:TDockingPalette;
    CloseBtn:TBitBtn;
    HelpBtn:TBitBtn;

BEGIN
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiToolbarsCaption);
  ClientWidth := 340;
  ClientHeight:= 220;

  List := InsertCheckListBox(SELF,10,20,190,180);
  List.OnStateChanged := EvStateChanged;
  List.Focus;

  FOR i := 0 TO Paletten.Count-1 DO
    BEGIN
      List.Items.Add(Paletten.Strings[i]);
      Panel := TDockingPalette(Paletten.Objects[i]);
      IF Panel.DockingState <> dsHide THEN
        List.State[i] := clsChecked;
    END;

  CloseBtn := InsertBitBtnNLS(SELF,220,170,110,30,bkClose,SiClose,0);
  IF IdeSettings.ShowBitBtnGlyph THEN CloseBtn.Margin := 10;
  CloseBtn.Cancel := TRUE;
  HelpBtn := InsertBitBtnNLS(SELF,220,125,110,30,bkHelp,SHelpButton,0);
  IF IdeSettings.ShowBitBtnGlyph THEN HelpBtn.Margin := 10;
END;


PROCEDURE TToolbarsDialog.EvStateChanged(Sender:TObject);
VAR  Panel:TDockingPalette;
BEGIN
  Panel := TDockingPalette(Paletten.Objects[List.ItemIndex]);
  IF (Panel = ControlCentre) AND (not CanSwitchDockingState) THEN exit;
  IF Panel.DockingState = dsHide
    then Panel.DockingState := dsFloat
    else Panel.DockingState := dsHide;
END;


PROCEDURE ToolbarsDialog;
VAR  Dialog:TToolbarsDialog;
BEGIN
  Dialog.Create(NIL);
  Dialog.HelpContext := hctxDialogToolbars;
  Dialog.Execute;
  Dialog.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: Find In Files Dialog                                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
  TSearchThread=CLASS(TThread)
    Text:STRING;
    Filter:STRING;
    BasePath:STRING;
    Recursive:Boolean;
    CaseSense:Boolean;
    WordsOnly:Boolean;
    AllFiles:Boolean;
    found:LongInt;
    PROCEDURE Execute;OVERRIDE;
    DESTRUCTOR Destroy;OVERRIDE;
    PROCEDURE FindInFile(FName:STRING);
    PROCEDURE FindInFiles(Path:STRING);
  END;



PROCEDURE TSearchThread.FindInFile(FName:STRING);
VAR
  F:System.Text;
  s,s1:STRING;
  l,p:LongInt;
LABEL
  ex;
BEGIN
  IF Text = '' THEN
  BEGIN
    // Zeile (1) der Datei zurckgeben
    inc(found);
    WriteToFindInFilesList(FName,1);
  END
  ELSE
  BEGIN
    // alle Vorkommen Suchen
    FileMode := fmInput;
    System.Assign(F,FName);
    {$i-}
    Reset(F);
    {$i+}
    FileMode := fmInOut;
    IF IoResult <> 0 THEN GOTO ex;
    l := 0;
    WHILE NOT ({$i-} Eof(F) {$i+}) DO
    BEGIN
      IF IoResult <> 0 THEN GOTO ex;
      IF Terminated THEN break;

      inc(l);
      {$i-}
      Readln(F,s);
      {$i+}
      IF IoResult <> 0 THEN GOTO ex;

      s1 := s;
      IF NOT CaseSense THEN UpcaseStr(s1);

      WHILE TRUE DO
      BEGIN
        p := pos(Text,s1);
        IF p = 0 THEN break;

        IF WordsOnly THEN
        BEGIN
          IF p > 1 THEN
            IF s1[p-1] IN NormalChars THEN
            BEGIN
              s1[p] := #0;
              continue;
            END;
          IF p+Length(Text) <= Length(s1) THEN
            IF s1[p+Length(Text)] IN NormalChars THEN
            BEGIN
              s1[p] := #0;
              continue;
            END;
        END;

        inc(found);
        WriteToFindInFilesList(FName +'('+ tostr(l) +'):'+ s,p);
        break;
      END;
    END;
ex:
    {$i-}
    System.Close(F);
    {$i+}
  END;
END;


PROCEDURE TSearchThread.FindInFiles(Path:STRING);
VAR
  Status:Integer;
  Search:SearchRec;
  s:STRING;
BEGIN
  Status := FindFirst(Path+'\'+ALL_FILES,faAnyFile,Search);
  WHILE Status = 0 DO
  BEGIN
    IF Terminated THEN
    BEGIN
         FindClose(Search);
         Exit;
    END;

    IF Search.Attr AND faDirectory = faDirectory THEN
    BEGIN
      IF Recursive THEN
        IF Search.Name <> '.' THEN
          IF Search.Name <> '..' THEN FindInFiles(Path+'\'+Search.Name);
    END
    ELSE
    BEGIN
      s := ';*' + ExtractFileExt(Search.Name) + ';';
      UpcaseStr(s);
      IF AllFiles OR (pos(s,Filter) > 0) THEN
        FindInFile(Path+'\'+Search.Name);
    END;

    Status := FindNext(Search);
  END;
END;


PROCEDURE TSearchThread.Execute;
BEGIN
  ClearFindInFilesList;
  WriteToFindInFilesList(LoadNLSStr(SiSearchingFor) +' "'+ Text +'"...',0);

  UpcaseStr(Filter);
  Filter := ';' + Filter + ';';
  AllFiles := pos(';*.*;',Filter) > 0;

  IF NOT CaseSense THEN UpcaseStr(Text);

  found := 0;

  FindInFiles(BasePath);
END;


DESTRUCTOR TSearchThread.Destroy;
BEGIN
  WriteToFindInFilesList(tostr(found) + ' ' + LoadNLSStr(SiMatchesFound),0);

  INHERITED Destroy;
  SearchThread := NIL;
END;



TYPE
    TFindInFilesDialog=CLASS(TDialog)
      PRIVATE
         CoB_Find:TComboBox;
         CoB_Filter:TComboBox;
         CoB_Path:TComboBox;
         SpB_Path:TSpeedButton;
         ChB_CaseSense:TCheckBox;
         ChB_WordsOnly:TCheckBox;
         ChB_Recursive:TCheckBox;
         BiB_Find:TBitBtn;
         BiB_Cancel:TBitBtn;
      PRIVATE
         PROCEDURE EvBrowsePath(Sender:TObject);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
    END;


PROCEDURE TFindInFilesDialog.SetupComponent;
VAR  Lab:TLabel;
     i:LONGINT;
     s:STRING;
BEGIN
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiFindInFiles);
  ClientWidth := 460;
  ClientHeight := 280;

  Lab := InsertLabel(Self,20,230,100,20,LoadNLSStr(SFind)+':');
  CoB_Find := InsertComboBox(Self,130,230,310,20,csDropDown);
  FOR i := 0 TO FindInFilesHistory.Count-1 DO
    BEGIN
      CoB_Find.Items.Add(FindInFilesHistory.Strings[i]);
    END;
  CoB_Find.Focus;

  Lab := InsertLabel(Self,20,190,100,20,LoadNLSStr(SiFilter)+':');
  CoB_Filter := InsertComboBox(Self,130,190,310,20,csDropDown);
  FOR i := 0 TO FindInFilesFilter.Count-1 DO
    BEGIN
      CoB_Filter.Items.Add(FindInFilesFilter.Strings[i]);
    END;
  CoB_Filter.Text := IdeSettings.FindFiles.LastFilter;

  Lab := InsertLabel(Self,20,150,100,20,LoadNLSStr(SiDirectory)+':');
  CoB_Path := InsertComboBox(Self,130,150,280,22,csDropDown);
  FOR i := 0 TO FindInFilesPaths.Count-1 DO
    BEGIN
      CoB_Path.Items.Add(FindInFilesPaths.Strings[i]);
    END;
  s := IdeSettings.FindFiles.LastPath;
  {$i-}
  IF s = '' THEN GetDir(0,s);
  {$i+}
  CoB_Path.Text := s;
  SpB_Path := InsertSpeedButton(Self,410,150,30,25, 0,'...','');
  SpB_Path.OnClick := EvBrowsePath;

  ChB_CaseSense := InsertCheckBox(Self,30,110,170,20,LoadNLSStr(SCaseSensitive),'');
  ChB_CaseSense.Checked := IdeSettings.FindFiles.CaseSense;
  ChB_WordsOnly := InsertCheckBox(Self,30,80,170,20,LoadNLSStr(SWordsOnly),'');
  ChB_WordsOnly.Checked := IdeSettings.FindFiles.WordsOnly;
  ChB_Recursive := InsertCheckBox(Self,230,110,210,20,LoadNLSStr(SiSubDirectories),'');
  ChB_Recursive.Checked := IdeSettings.FindFiles.Recursive;

  BiB_Find := InsertBitBtn(Self,20,20,110,30,bkOk,LoadNLSStr(SFindButton),LoadNLSStr(SClickHereToAccept));
  BiB_Cancel := InsertBitBtn(Self,160,20,110,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
END;


PROCEDURE TFindInFilesDialog.EvBrowsePath(Sender:TObject);
VAR  CDD:TChangeDirDialog;
BEGIN
  CDD.Create(SELF);
  CDD.HelpContext := 0;
  CDD.Caption := LoadNLSStr(SiSelectDirectory);
  CDD.OkName := LoadNLSStr(SiSelect);
  CDD.Directory := CoB_Path.Text;
  IF CDD.Execute THEN
    BEGIN
      CoB_Path.Text := CDD.Directory;
    END;
  CDD.Destroy;
  CoB_Path.CaptureFocus;
END;



PROCEDURE FindInFilesDialog(CONST s,x:STRING);
VAR  Dialog:TFindInFilesDialog;
     i:LONGINT;
     s1:STRING;
BEGIN
  Dialog.Create(NIL);
  Dialog.CoB_Find.Text := s;
  Dialog.CoB_Find.TextExtension := x;

  IF Dialog.Execute THEN
    BEGIN
      IdeSettings.Modified := TRUE;

      s1 := Dialog.CoB_Find.Text;
      IF s1 <> '' THEN
        BEGIN
          IF FindInFilesHistory.Find(s1,i) THEN FindInFilesHistory.Delete(i);
            FindInFilesHistory.Insert(0, s1);
        END;
      IdeSettings.FindFiles.LastFilter := Dialog.CoB_Filter.Text;
      IdeSettings.FindFiles.LastPath := Dialog.CoB_Path.Text;
      NormalizeDir(IdeSettings.FindFiles.LastPath);
      s1 := IdeSettings.FindFiles.LastPath;
      IF s1 <> '' THEN
        BEGIN
          IF FindInFilesPaths.Find(s1,i) THEN FindInFilesPaths.Delete(i);
          FindInFilesPaths.Insert(0, s1);
        END;
      IdeSettings.FindFiles.Recursive := Dialog.ChB_Recursive.Checked;
      IdeSettings.FindFiles.CaseSense := Dialog.ChB_CaseSense.Checked;
      IdeSettings.FindFiles.WordsOnly := Dialog.ChB_WordsOnly.Checked;

      SaveFiles(TRUE); // only modified

      CodeEditor.ShowControlCentre(FindInFilesIndex,NoFokus);

      SearchThread := TSearchThread.Create(True);
      TSearchThread(SearchThread).Text     := Dialog.CoB_Find.Text;
      TSearchThread(SearchThread).Filter   := IdeSettings.FindFiles.LastFilter;
      TSearchThread(SearchThread).BasePath := IdeSettings.FindFiles.LastPath;
      TSearchThread(SearchThread).Recursive:= IdeSettings.FindFiles.Recursive;
      TSearchThread(SearchThread).CaseSense:= IdeSettings.FindFiles.CaseSense;
      TSearchThread(SearchThread).WordsOnly:= IdeSettings.FindFiles.WordsOnly;
      SearchThread.FreeOnTerminate := True;

      SearchThread.Resume;
    END;
  Dialog.Destroy;
END;

BEGIN
  InitProjectManagerProc := @InitProjectManager;
  GotoLineDialogProc := @GotoLineDialog;
  ToolbarsDialogProc := @ToolbarsDialog;
END.

{ -- date -- -- from -- -- changes ------------------------------------------------------------------
  05-Dec-02  WD         Ausbau des Standard-Teil
  05-Dec-02  WD         TProjectDialog: Ausgabe einer normalen Fehlermeldung, wenn das Default.ico
                                        nicht gefunden wird.
  03-Aug-03  WD         Entfernen des TipOfTheDay-Dialog.
  11-Okt-03  WD         Umbau des About-Dialogs.
  23-Okt-04  WD         Compiler-Page in den Dialog "TGeneralDialog" eingebaut.
  21-Mar-05  WD         Ausgabe des CompLib-Filenamens (inkl. Pfad).
  08-Apr-05  WD         TGeneralDialog: Seite "Verzeichnisse" eingebaut.
  18-Mai-05  WD         Parameter-Dialog vergroessert.
  11-Dez-05  WD         AboutDialog: Umstellen auf eine Klasse; Bei Click->Homepage von WDSibyl aufrufen.
  23-Dez-05  WD         Sprache: Niederlndisch hinzugefgt
  24-Jan-05  WD         Umbau auf die neue Struktur von FindFirst
  26-Dec-07  WD         Tools: $ININAME eingebaut
}
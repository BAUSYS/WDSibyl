
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

UNIT WinList;

INTERFACE

USES Messages,SysUtils,Dos,Color,Classes,Forms,Buttons,StdCtrls,
     Consts,Projects,Editors,Sib_Prj,BaseForm,
     Menus,
     uString, uList;


TYPE
    TWindowList=CLASS(TSibylForm)
         EditorList:TListBox;
         FormList:TListBox;
         SpecialList:TListBox;
         LastSelection:TListBox;
         Popup:TPopupMenu;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE AddWindow(LB:INTEGER;Win:TForm);
         PROCEDURE RemoveWindow(LB:INTEGER;Win:TForm);
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
         PROCEDURE EvSetFocus(Sender:TObject);
         PROCEDURE EvItemSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE EvRMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
         PROCEDURE TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
    END;


    TMacroWindow=CLASS(TSibylForm)
         MacroListBox:TListBox;
         Popup:TPopupMenu;
         PROCEDURE SetupComponent;OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE EvItemSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE EvRMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
         PROCEDURE EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
         PROCEDURE InsertMacro(CONST s:STRING;MList:TList);
         PROCEDURE TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
    END;


    PClipBoardStruct=^TClipBoardStruct;
    TClipBoardStruct=RECORD
         p:POINTER;
         Len:LONGINT;
    END;


    TClipBoardHistory=CLASS(TStringList)
      PUBLIC
         PROCEDURE FreeItem(AObject:TObject);OVERRIDE;
         PROCEDURE InsertObject(Index:LongInt;CONST S:STRING;AObject:TObject);OVERRIDE;
         FUNCTION  InsertClip(p:POINTER;Len:LONGINT):PClipBoardStruct;
    END;


    TClipBoardWindow=CLASS(TSibylForm)
         HistoryBox:TListBox;
         Popup:TPopupMenu;
         PROCEDURE SetupComponent;OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE EvItemSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE EvRMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
         PROCEDURE EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
         PROCEDURE InsertClip(pc:PClipBoardStruct);
         PROCEDURE TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
    END;


PROCEDURE InitWindowList;
PROCEDURE InitMacroList;
PROCEDURE InitClipBoardWindow;

PROCEDURE AddWindowList(LB:INTEGER;Win:TForm);
PROCEDURE RemoveWindowList(LB:INTEGER;Win:TForm);
FUNCTION  NewMacroName(VAR s:STRING):BOOLEAN;


VAR WindowList:TWindowList;
    MacroWindow:TMacroWindow;
    PlayMacroProc:PROCEDURE(MList:TList);
    PasteClipBoardProc:PROCEDURE(pc:PClipBoardStruct);
    ClipBoardHistory:TClipBoardHistory;
    ClipBoardWindow:TClipBoardWindow;

IMPLEMENTATION


TYPE
    TMacroNameDialog=CLASS(TForm)
         Entry:TEdit;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
    END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: WindowList                                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TWindowList.SetupComponent;
BEGIN
     Inherited SetupComponent;

     SibylFormId := dwi_WindowList;
     BorderStyle := bsSizeable;
     BorderIcons := [biSystemMenu];
     Caption := LoadNLSStr(SiWindowList);
     Color := clLtGray;
     SpecialList := InsertListBox(SELF,0,0,100,100,'');
     SpecialList.Sorted := TRUE;
     SpecialList.OnEnter := EvSetFocus;
     SpecialList.OnScan := EvScanEvent;
     SpecialList.OnMouseClick := EvRMouseClick;
     SpecialList.OnItemSelect := EvItemSelected;
     EditorList := InsertListBox(SELF,100,50,100,50,'');
     EditorList.Sorted := TRUE;
     EditorList.OnEnter := EvSetFocus;
     EditorList.OnScan := EvScanEvent;
     EditorList.OnMouseClick := EvRMouseClick;
     EditorList.OnItemSelect := EvItemSelected;
     FormList := InsertListBox(SELF,100,0,100,50,'');
     FormList.Sorted := TRUE;
     FormList.OnEnter := EvSetFocus;
     FormList.OnScan := EvScanEvent;
     FormList.OnMouseClick := EvRMouseClick;
     FormList.OnItemSelect := EvItemSelected;
     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
END;


PROCEDURE TWindowList.SetupShow;
VAR  i:INTEGER;
     FormItem:PFormListItem;
     Win:TForm;
BEGIN
     Inherited SetupShow;

     FOR i := 0 TO CodeEditorRef.MDIChildCount-1 DO
     BEGIN
          Win := CodeEditorRef.MDIChildren[i];
          AddWindow(1,Win);
     END;

     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF FormItem^.Form <> NIL THEN AddWindow(2,TForm(FormItem^.Form));
     END;

     FOR i := 0 TO Screen.FormCount-1 DO
     BEGIN
          Win := Screen.Forms[i];
          IF Win IS TSibylForm THEN AddWindow(3,Win);
     END;

     EditorList.Focus;
END;


DESTRUCTOR TWindowList.Destroy;
BEGIN
     WindowList := NIL;
     EditorList := NIL;
     FormList := NIL;
     SpecialList := NIL;
     LastSelection := NIL;
     IF Popup <> NIL THEN Popup.Destroy;
     Inherited Destroy;
END;


PROCEDURE TWindowList.Resize;
VAR  rec:TRect;
     x,y:LONGINT;
BEGIN
     Inherited Resize;

     rec := ClientRect;
     x := round(rec.Right / 2);
     y := round(rec.Top / 2);
     SpecialList.SetWindowPos(0,0,x,rec.Top);
     EditorList.SetWindowPos(x,y,rec.Right-x,rec.Top-y);
     FormList.SetWindowPos(x,0,rec.Right-x,y);
END;


PROCEDURE TWindowList.AddWindow(LB:INTEGER;Win:TForm);
VAR  List:TListBox;
     s,d,n,e:STRING;
BEGIN
     IF Win = NIL THEN exit;
     IF Win = SELF THEN exit;

     CASE LB OF
       1: List := EditorList;
       2: List := FormList;
       3: List := SpecialList;
       ELSE exit;
     END;
     IF List = NIL THEN exit;

     IF Win = IdeSettings.DesktopWindows[dwi_CodeEditor].Form
     THEN s := LoadNLSStr(SiCodeEditor)
     ELSE s := Win.Caption;

     IF Win IS TEditor THEN
     BEGIN
          FSplit(TEditor(Win).FileName,d,n,e);
          s := n + e;
          IF TEditor(Win).Modified THEN s := s + '*'; 
     END;

     List.Items.AddObject(s,Win);
END;


PROCEDURE TWindowList.RemoveWindow(LB:INTEGER;Win:TForm);
VAR  List:TListBox;
     i:INTEGER;
BEGIN
     IF Win = NIL THEN exit;

     CASE LB OF
       1: List := EditorList;
       2: List := FormList;
       3: List := SpecialList;
       ELSE exit;
     END;
     IF List = NIL THEN exit;

     i := List.Items.IndexOfObject(Win);
     IF i >= 0 THEN List.Items.Delete(i);
END;


PROCEDURE TWindowList.CommandEvent(VAR Command:TCommand);
VAR  Win:TForm;
     i:INTEGER;
BEGIN
     Inherited CommandEvent(Command);

     IF LastSelection <> NIL THEN
     BEGIN
          i := LastSelection.ItemIndex;
          IF i >= 0 THEN Win := TForm(LastSelection.Items.Objects[i]);
     END
     ELSE Win := NIL;

     CASE Command OF
       cmOpen:
       BEGIN
            IF Win <> NIL THEN
            BEGIN
                 IF Win.WindowState = wsMinimized
                 THEN Win.WindowState := wsNormal;
                 Win.BringToFront;
                 Win.Focus;
            END;
       END;
       cmCloseTop:
       BEGIN
            IF Win <> NIL THEN Win.Close;
       END;
     END;
     Command := cmNull;
END;


{$HINTS OFF}
PROCEDURE TWindowList.EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
BEGIN
     CASE KeyCode OF
       kbTab:
       BEGIN
            IF Sender=EditorList THEN  Sender := FormList
            ELSE IF Sender=FormList THEN Sender := SpecialList
            ELSE IF Sender=SpecialList THEN Sender := EditorList
            ELSE Sender := EditorList;
            TControl(Sender).Focus;
            EvSetFocus(Sender);
            //Msg.Handled := TRUE;
       END;
       kbEsc:
       BEGIN
            PostMsg(Handle,CM_COMMAND,cmClose,0);
            //Msg.Handled := TRUE;
       END;
     END;
END;
{$HINTS ON}

PROCEDURE TWindowList.EvSetFocus(Sender:TObject);
BEGIN
     IF LastSelection = Sender THEN exit;

     IF Sender = EditorList THEN
     BEGIN
          IF EditorList.Items.Count > 0 THEN EditorList.ItemIndex := 0;
          FormList.Selected[FormList.ItemIndex] := FALSE;
          SpecialList.Selected[SpecialList.ItemIndex] := FALSE;
     END;
     IF Sender = FormList THEN
     BEGIN
          IF FormList.Items.Count > 0 THEN FormList.ItemIndex := 0;
          EditorList.Selected[EditorList.ItemIndex] := FALSE;
          SpecialList.Selected[SpecialList.ItemIndex] := FALSE;
     END;
     IF Sender = SpecialList THEN
     BEGIN
          IF SpecialList.Items.Count > 0 THEN SpecialList.ItemIndex := 0;
          EditorList.Selected[EditorList.ItemIndex] := FALSE;
          FormList.Selected[FormList.ItemIndex] := FALSE;
     END;

     LastSelection := TListBox(Sender);
END;


{$HINTS OFF}
PROCEDURE TWindowList.EvItemSelected(Sender:TObject;Index:LONGINT);
BEGIN
     SendMsg(Handle,CM_COMMAND,cmOpen,0);
     PostMsg(Handle,CM_COMMAND,cmClose,0);
END;
{$HINTS ON}


{$HINTS OFF}
PROCEDURE TWindowList.EvRMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR  Entry:TMenuItem;
     pt:TPoint;
BEGIN
     IF Button <> mbRight THEN exit;

     IF Popup = NIL THEN
     BEGIN
          Popup.Create(SELF);

          Entry.Create(Popup);
          Entry.Caption := LoadNLSStr(SiWindowShow);
          Entry.Command := cmOpen;
          Entry.HelpContext := hctxPopupWindowListShow;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption := LoadNLSStr(SiWindowClose);
          Entry.Command := cmCloseTop;
          Entry.HelpContext := hctxPopupWindowListClose;
          Popup.Items.Add(Entry);
     END;

     pt := TControl(Sender).ClientToScreen(Point(X,Y));
     Popup.Popup(pt.X,pt.Y);
END;
{$HINTS ON}


PROCEDURE TWindowList.TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Application.MainForm.OnTranslateShortCut(SELF,KeyCode,Receiver);

     IF KeyCode = kbShiftF10 THEN
     BEGIN
          EvRMouseClick(NIL, mbRight ,[] , Width DIV 2, Height DIV 2);
     END;
END;


PROCEDURE InitWindowList;
BEGIN
     IF WindowList <> NIL THEN
     BEGIN
          IF WindowList.WindowState = wsMinimized
          THEN WindowList.WindowState := wsNormal;
          WindowList.BringToFront;
          exit;
     END;
     WindowList.Create(NIL);
     WindowList.HelpContext := hctxDialogWindowList;
     WindowList.Show;
     WindowList.Update;
END;


PROCEDURE AddWindowList(LB:INTEGER;Win:TForm);
BEGIN
     IF WindowList <> NIL THEN WindowList.AddWindow(LB,Win);
END;


PROCEDURE RemoveWindowList(LB:INTEGER;Win:TForm);
BEGIN
     IF WindowList <> NIL THEN WindowList.RemoveWindow(LB,Win);
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: MacroWindow                                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TMacroWindow.SetupComponent;
VAR  i:LONGINT;
BEGIN
     Inherited SetupComponent;

     SibylFormId := dwi_MacroList;
     BorderStyle := bsSizeable;
     BorderIcons := [biSystemMenu];
     Caption := LoadNLSStr(SiEditorMacroList);
     MacroListBox := InsertListBox(SELF,0,30,100,100,'');
     MacroListBox.Sorted := TRUE;
     MacroListBox.Align := alClient;
     MacroListBox.OnScan := EvScanEvent;
     MacroListBox.OnItemSelect := EvItemSelected;
     MacroListBox.OnMouseClick := EvRMouseClick;
     MacroListBox.Focus;

     {Fill the box}
     FOR i := 0 TO GlobalMacroList.Count-1 DO
     BEGIN
          InsertMacro(GlobalMacroList.Strings[i],
                      TList(GlobalMacroList.Objects[i]));
     END;
END;


DESTRUCTOR TMacroWindow.Destroy;
BEGIN
     MacroWindow := NIL;
     IF Popup <> NIL THEN Popup.Destroy;
     Inherited Destroy;
END;


PROCEDURE TMacroWindow.InsertMacro(CONST s:STRING;MList:TList);
BEGIN
     MacroListBox.Items.AddObject(s,MList);
END;


PROCEDURE TMacroWindow.CommandEvent(VAR Command:TCommand);
VAR  i:INTEGER;
     MList:TList;
BEGIN
     Inherited CommandEvent(Command);

     CASE Command OF
       cmOpen:
       BEGIN
            i := MacroListBox.ItemIndex;
            IF i >= 0 THEN
            BEGIN
                 MList := TList(MacroListBox.Items.Objects[i]);
                 IF MList <> NIL THEN PlayMacroProc(MList);
            END;
       END;
       cmDelete:
       BEGIN
            i := MacroListBox.ItemIndex;
            IF i >= 0 THEN
            BEGIN
                 MacroListBox.Items.Delete(i);
                 GlobalMacroList.Delete(i); {release memory}
            END;
       END;
     END;
     Command := cmNull;
END;


{$HINTS OFF}
PROCEDURE TMacroWindow.EvItemSelected(Sender:TObject;Index:LONGINT);
BEGIN
     SendMsg(Handle,CM_COMMAND,cmOpen,0);
     PostMsg(Handle,CM_COMMAND,cmClose,0);
END;


PROCEDURE TMacroWindow.EvRMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR  Entry:TMenuItem;
     pt:TPoint;
BEGIN
     IF Button <> mbRight THEN exit;

     IF Popup = NIL THEN
     BEGIN
          Popup.Create(SELF);
          Entry.Create(Popup);
          Entry.Caption := LoadNLSStr(SiEditorMacroPlay);
          Entry.Command := cmOpen;
          Entry.HelpContext := hctxPopupMacroListPlay;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption := LoadNLSStr(SiEditorMacroDelete);
          Entry.Command := cmDelete;
          Entry.HelpContext := hctxPopupMacroListDelete;
          Popup.Items.Add(Entry);
     END;

     pt := TControl(Sender).ClientToScreen(Point(X,Y));
     Popup.Popup(pt.X,pt.Y);
END;


PROCEDURE TMacroWindow.TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Application.MainForm.OnTranslateShortCut(SELF,KeyCode,Receiver);

     IF KeyCode = kbShiftF10 THEN
     BEGIN
          EvRMouseClick(NIL, mbRight ,[] , Width DIV 2, Height DIV 2);
     END;
END;


PROCEDURE TMacroWindow.EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
BEGIN
     CASE KeyCode OF
       kbEsc:
       BEGIN
            PostMsg(Handle,CM_COMMAND,cmClose,0);
            //Msg.Handled := TRUE;
       END;
     END;
     //Msg.Handled := TRUE;  auskommentiert wegen CursorTasten
END;
{$HINTS ON}


PROCEDURE InitMacroList;
BEGIN
     IF MacroWindow <> NIL THEN
     BEGIN
          IF MacroWindow.WindowState = wsMinimized
          THEN MacroWindow.WindowState := wsNormal;
          MacroWindow.BringToFront;
          MacroWindow.MacroListBox.Focus;
          exit;
     END;
     MacroWindow.Create(NIL);
     MacroWindow.HelpContext := hctxDialogMacroList;
     MacroWindow.Show;
     MacroWindow.Update;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: MacroName Dialog                                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TMacroNameDialog.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiMacroName);
     Entry := InsertEdit(SELF,0,0,200,25,'',LoadNLSStr(SiEnterNewMacroName));
     Entry.OnScan := EvScanEvent;
     ClientWidth := Entry.Width;
     ClientHeight := Entry.Height;
{     MaxTrackHeight := Height;  WD}
     BorderIcons := [biSystemMenu];
     Entry.Align := alClient;
     xAlign := xaCenter;
     yAlign := yaCenter;
     Entry.Focus;
END;

{$HINTS OFF}
PROCEDURE TMacroNameDialog.EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
BEGIN
     IF Sender = Entry THEN
     BEGIN
          CASE KeyCode OF
            {$IFDEF OS2}
            kbEnter,
            {$ENDIF}
            kbCR:
            BEGIN
                 DismissDlg(cmOk);
                 Keycode := kbNull;
            END;
            kbEsc:
            BEGIN
                 DismissDlg(cmCancel);
                 Keycode := kbNull;
            END;
          END;
     END;
     //Msg.Handled := TRUE;  auskommentiert wegen CursorTasten
END;
{$HINTS ON}


FUNCTION NewMacroName(VAR s:STRING):BOOLEAN;
VAR  Dialog:TMacroNameDialog;
BEGIN
     Dialog.Create(Application.MainForm);
     Dialog.HelpContext := hctxDialogNewMacroName;
     Dialog.Entry.Text := s;
     Dialog.ShowModal;
     s := Dialog.Entry.Text;
     Result := Dialog.ModalResult <> cmCancel;
     Dialog.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: ClipBoardWindow                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TClipBoardWindow.SetupComponent;
VAR  i:LONGINT;
BEGIN
     Inherited SetupComponent;

     SibylFormId := dwi_ClipBoardList;
     BorderStyle := bsSizeable;
     BorderIcons := [biSystemMenu];
     Caption := LoadNLSStr(SiClipboardHistory);
     HistoryBox := InsertListBox(SELF,0,30,100,100,'');
     HistoryBox.Align := alClient;
     HistoryBox.OnScan := EvScanEvent;
     HistoryBox.OnItemSelect := EvItemSelected;
     HistoryBox.OnMouseClick := EvRMouseClick;
     HistoryBox.Focus;

     {Fill the box}
     FOR i := ClipBoardHistory.Count-1 DOWNTO 0 DO
     BEGIN
          InsertClip(PClipBoardStruct(ClipBoardHistory.Objects[i]));
     END;
END;


DESTRUCTOR TClipBoardWindow.Destroy;
BEGIN
     ClipBoardWindow := NIL;
     IF Popup <> NIL THEN Popup.Destroy;
     Inherited Destroy;
END;


PROCEDURE TClipBoardWindow.CommandEvent(VAR Command:TCommand);
VAR  i:INTEGER;
     pc:PClipBoardStruct;
BEGIN
     Inherited CommandEvent(Command);

     CASE Command OF
       cmPaste:
       BEGIN
            i := HistoryBox.ItemIndex;
            IF i >= 0 THEN
            BEGIN
                 pc := PClipBoardStruct(HistoryBox.Items.Objects[i]);
                 IF pc <> NIL THEN PasteClipBoardProc(pc);
            END;
       END;
       cmDelete:
       BEGIN
            i := HistoryBox.ItemIndex;
            IF i >= 0 THEN
            BEGIN
                 HistoryBox.Items.Delete(i);
                 ClipBoardHistory.Delete(i);  {release memory}
            END;
       END;
     END;
     Command := cmNull;
END;


{$HINTS OFF}
PROCEDURE TClipBoardWindow.EvItemSelected(Sender:TObject;Index:LONGINT);
BEGIN
     SendMsg(Handle,CM_COMMAND,cmPaste,0);
     PostMsg(Handle,CM_COMMAND,cmClose,0);
END;


PROCEDURE TClipBoardWindow.EvRMouseClick(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR  Entry:TMenuItem;
     pt:TPoint;
BEGIN
     IF Button <> mbRight THEN exit;

     IF Popup = NIL THEN
     BEGIN
          Popup.Create(SELF);
          Entry.Create(Popup);
          Entry.Caption := LoadNLSStr(SiClipboardPaste);
          Entry.Command := cmPaste;
          Entry.HelpContext := hctxPopupClipboardPaste;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption := LoadNLSStr(SiClipboardDelete);
          Entry.Command := cmDelete;
          Entry.HelpContext := hctxPopupClipboardDelete;
          Popup.Items.Add(Entry);
     END;

     pt := TControl(Sender).ClientToScreen(Point(X,Y));
     Popup.Popup(pt.X,pt.Y);
END;


PROCEDURE TClipboardWindow.TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Application.MainForm.OnTranslateShortCut(SELF,KeyCode,Receiver);

     IF KeyCode = kbShiftF10 THEN
     BEGIN
          EvRMouseClick(NIL, mbRight ,[] , Width DIV 2, Height DIV 2);
     END;
END;


PROCEDURE TClipBoardWindow.EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
BEGIN
     CASE KeyCode OF
       kbEsc:
       BEGIN
            PostMsg(Handle,CM_COMMAND,cmClose,0);
            //Msg.Handled := TRUE;
       END;
     END;
     //Msg.Handled := TRUE;  auskommentiert wegen CursorTasten
END;
{$HINTS ON}


PROCEDURE TClipBoardWindow.InsertClip(pc:PClipBoardStruct);
VAR  pch:PChar;
     s:STRING[35];
BEGIN
     IF pc = NIL THEN exit;

     pch := pc^.p;
     s := pch^;
     IF Length(s) > 30 THEN
     BEGIN
          SetLength(s,30);
          s := s + ' ...';
     END;

     HistoryBox.Items.InsertObject(0,s,TObject(pc));
END;


PROCEDURE InitClipBoardWindow;
BEGIN
     IF ClipBoardWindow <> NIL THEN
     BEGIN
          IF ClipBoardWindow.WindowState = wsMinimized
          THEN ClipBoardWindow.WindowState := wsNormal;
          ClipBoardWindow.BringToFront;
          ClipBoardWindow.HistoryBox.Focus;
          exit;
     END;
     ClipBoardWindow.Create(NIL);
     ClipBoardWindow.HelpContext := hctxDialogClipboardHistory;
     ClipBoardWindow.Show;
     ClipBoardWindow.Update;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: TClipBoardHistory                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TClipBoardHistory.FreeItem(AObject:TObject);
VAR  pc:PClipBoardStruct;
BEGIN
     pc := PClipBoardStruct(AObject);
     IF pc <> NIL THEN
     BEGIN
          FreeMem(pc^.p,pc^.Len);
          Dispose(pc);
     END;

     Inherited FreeItem(AObject);
END;


PROCEDURE TClipBoardHistory.InsertObject(Index:LongInt;CONST S:STRING;AObject:TObject);
VAR  i:LONGINT;
BEGIN
     Inherited InsertObject(Index,S,AObject);
     {Count limitieren}
     FOR i := Count-1 DOWNTO MaxClipBoardHistory DO
     BEGIN
          Delete(i);
     END;
END;


FUNCTION TClipBoardHistory.InsertClip(p:POINTER;Len:LONGINT):PClipBoardStruct;
BEGIN
     Result := NIL;
     IF (p = NIL) OR (Len = 0) THEN exit;
     New(Result);
     Result^.p := p;
     Result^.Len := Len;
     ClipBoardHistory.InsertObject(0,'',TObject(Result));
END;

BEGIN
  ClipBoardHistory.Create;
  AddWindowListProc := @AddWindowList;
  RemoveWindowListProc := @RemoveWindowList;

  InitWindowListProc := @InitWindowList;
  InitMacroListProc := @InitMacroList;
  InitClipboardListProc := @InitClipboardWindow;
END.

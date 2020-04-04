
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

UNIT BaseForm;
                
INTERFACE

USES Messages,Classes,Forms,Consts,Projects,Sib_Prj;

TYPE
  TSibylForm=CLASS(TForm)
    PROTECTED
      PROCEDURE CreateWnd;OVERRIDE;
      PROCEDURE SetupShow;OVERRIDE;
      PROCEDURE DestroyWnd;OVERRIDE;
      PROCEDURE Activate;OVERRIDE;
    PUBLIC
      SibylFormId:TDesktopWinId;
      PROCEDURE Show;OVERRIDE;
      PROCEDURE StoreDesktopWindowPos;
      PROCEDURE ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
  END;

PROCEDURE HideSibylForms;
PROCEDURE ShowSibylForms;

VAR
  AddWindowListProc:PROCEDURE(LB:INTEGER;Win:TForm);
  RemoveWindowListProc:PROCEDURE(LB:INTEGER;Win:TForm);
  LastFocusedForm:TForm;

IMPLEMENTATION
                      
PROCEDURE TSibylForm.CreateWnd;
BEGIN
  Inherited CreateWnd;
  IF SELF <> Application.MainForm then
    OnRestore := Application.MainForm.OnRestore;
END;


PROCEDURE TSibylForm.SetupShow;
BEGIN
  IF not IdeSettings.DesktopWindows[SibylFormId].Visible
    THEN IdeSettings.Modified := TRUE;
  IdeSettings.DesktopWindows[SibylFormId].Form := SELF;
  IdeSettings.DesktopWindows[SibylFormId].Visible := TRUE;
  Inherited SetupShow;
  AddWindowListProc(3,SELF);
END;


PROCEDURE TSibylForm.DestroyWnd;
BEGIN
  Application.LogWriteln('tSibylForm.DestroyWnd:');
  IF LastFocusedForm = SELF THEN LastFocusedForm := NIL;
  IdeSettings.DesktopWindows[SibylFormId].Form := NIL;
  IF not Project.Closing THEN
    BEGIN
      IdeSettings.DesktopWindows[SibylFormId].Visible := FALSE;
      IdeSettings.Modified := TRUE;
    END;
  RemoveWindowListProc(3,SELF);
  Inherited DestroyWnd;
END;

PROCEDURE TSibylForm.StoreDesktopWindowPos;
BEGIN
  IF Project.Loading THEN exit;
  IF not Visible THEN exit;

  IF WindowState = wsNormal THEN
    BEGIN
      IF (IdeSettings.DesktopWindows[SibylFormId].X <> Left) OR
         (IdeSettings.DesktopWindows[SibylFormId].Y <> Bottom) OR
         (IdeSettings.DesktopWindows[SibylFormId].CX <> Width) OR
         (IdeSettings.DesktopWindows[SibylFormId].CY <> Height)
        THEN IdeSettings.Modified := TRUE;

      IdeSettings.DesktopWindows[SibylFormId].X := Left;
      IdeSettings.DesktopWindows[SibylFormId].Y := Bottom;
      IdeSettings.DesktopWindows[SibylFormId].CX := Width;
      IdeSettings.DesktopWindows[SibylFormId].CY := Height;
    END;
END;


PROCEDURE TSibylForm.ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);
BEGIN
  Inherited ScanEvent(KeyCode,RepeatCount);
  IF KeyCode <> kbNull THEN
    IF SELF <> Application.MainForm then
      Application.MainForm.ScanEvent(KeyCode,RepeatCount);
  KeyCode := kbNull;
END;


PROCEDURE TSibylForm.Activate;
BEGIN
  Inherited Activate;
  IF SELF <> Application.MainForm THEN LastFocusedForm := SELF;
END;


PROCEDURE TSibylForm.Show;

VAR  p:POINTER;

BEGIN
  p := SELF;
  IdeSettings.DesktopWindows[SibylFormId].Form := p;
  Inherited Show;
END;

PROCEDURE HideSibylForms;
VAR  i:LONGINT;
     dwi:TDesktopWinId;
     Form:TSibylForm;
     FormItem:PFormListItem;
BEGIN
     FOR dwi := dwi_MainWindow TO dwi_LastForm DO
     BEGIN
          IF dwi = dwi_MainWindow THEN continue;
          IF dwi = dwi_CodeEditor THEN continue;
          IF dwi = dwi_CPUWindow THEN continue;
          Form := IdeSettings.DesktopWindows[dwi].Form;
          IF Form IS TSibylForm THEN Form.Hide;
     END;

     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          Form := TSibylForm(FormItem^.Form);
          IF Form <> NIL THEN Form.Hide;
     END;
END;


PROCEDURE ShowSibylForms;
VAR  i:LONGINT;
     dwi:TDesktopWinId;
     Form:TSibylForm;
     FormItem:PFormListItem;
BEGIN
     FOR dwi := dwi_MainWindow TO dwi_LastForm DO
     BEGIN
          Form := IdeSettings.DesktopWindows[dwi].Form;
          IF Form IS TSibylForm THEN Form.Show;
     END;

     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          Form := TSibylForm(FormItem^.Form);
          IF Form <> NIL THEN Form.Show;
     END;

     IF CodeEditorRef.ActiveMDIChild = NIL THEN CodeEditorRef.Focus
     ELSE CodeEditorRef.ActiveMDIChild.Focus;
END;

BEGIN
  LastFocusedForm := NIL;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  08-Aug-03  WD         Ausbau der Variable ShowSibylFormProc
  21-Jul-07  WD         Ausbau der Funktion Resize und Move
}
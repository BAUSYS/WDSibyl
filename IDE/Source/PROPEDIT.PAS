
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

UNIT PropEdit;

INTERFACE

USES SysUtils,Color,Classes,Forms,Graphics,Buttons,StdCtrls,Outline,Dialogs,
     TabCtrls,ComCtrls,Grids,FileCtrl,Consts,Sib_Ctrl,ExtCtrls,
     Messages,
     uString, uList;

TYPE
    TBitmapPropertyEditor=CLASS(TClassPropertyEditor)
       PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;

    TFontPropertyEditor=CLASS(TClassPropertyEditor)
      PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;

    TIconPropertyEditor=CLASS(TClassPropertyEditor)
      PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;

    TStringsPropertyEditor=CLASS(TClassPropertyEditor)
      PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;

    TStatusPanelsPropertyEditor=CLASS(TClassPropertyEditor)
      PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;

    THeaderSectionsPropertyEditor=CLASS(TClassPropertyEditor)
      PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;

    TMCIFileNamePropertyEditor=CLASS(TStringPropertyEditor)
       PUBLIC
         FUNCTION Execute(VAR Value:STRING;ValueLen:LONGINT):TPropertyEditorReturn;OVERRIDE;
    END;

    TMediaPlayerFileNamePropertyEditor=CLASS(TStringPropertyEditor)
       PUBLIC
         FUNCTION Execute(VAR Value:STRING;ValueLen:LONGINT):TPropertyEditorReturn;OVERRIDE;
    END;

    TPageAccessEditor=CLASS(TClassPropertyEditor)
       PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;

    TFormLanguagePropertyEditor=CLASS(TPropertyEditor)
       PUBLIC
         FUNCTION Execute(VAR Value;ValueLen:LONGINT):TPropertyEditorReturn;OVERRIDE;
    END;

    TFilterPropertyEditor=CLASS(TStringPropertyEditor)
       PUBLIC
         FUNCTION Execute(VAR Value:STRING;ValueLen:LONGINT):TPropertyEditorReturn;OVERRIDE;
    END;

    TImageItemListEditor=CLASS(TClassPropertyEditor)
       PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;


IMPLEMENTATION

Uses  MMedia, uMediaPlayer;
{$IFDEF OS2}
USES PmWin;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TBitmapPropEditDialog Class implementation                  บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TBitmapPropEditDialog=CLASS(TDialog)
      PRIVATE
         FImage:TImage;
         PROCEDURE EvLoad(Sender:TObject);
         PROCEDURE EvClear(Sender:TObject);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
    END;


PROCEDURE TBitmapPropEditDialog.SetupComponent;
VAR  Panel:TPanel;
     Btn:TBitBtn;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiSelectABitmap);
     Width:=410;
     Height:=260;
     XAlign:=xaCenter;
     YAlign:=yaCenter;
     Color:=clLtGray;
     BorderStyle := bsDialog;
     BorderIcons := [biSystemMenu];

     Panel := InsertPanel(SELF,20,20,240,190,bvRaised,bvLowered,1,LoadNLSStr(SiEmpty));
     FImage.Create(Panel);
     FImage.SetWindowPos(3,3,234,184);
     FImage.Parent := Panel;
     FImage.Stretch := FALSE;
     FImage.Center := TRUE;

     InsertBitBtnNLS(SELF,290,180,100,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,290,140,100,30,bkCancel,SCancelButton,SClickHereToCancel);
     Btn := InsertBitBtnNLS(SELF,290,100,100,30,bkOpen,SiLoad,SiLoadHint);
     Btn.ModalResult := 0;
     Btn.OnClick := EvLoad;
     Btn := InsertBitBtnNLS(SELF,290,60,100,30,bkNo,SiClear,SiClearHint);
     Btn.ModalResult := 0;
     Btn.OnClick := EvClear;
     InsertBitBtnNLS(SELF,290,20,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


PROCEDURE TBitmapPropEditDialog.EvLoad(Sender:TObject);
VAR  FileDlg:TOpenDialog;
BEGIN
     FileDlg.Create(Application.MainForm);
     FileDlg.HelpContext := hctxDialogOpenBitmap;
     FileDlg.Title := LoadNLSStr(SiSelectABitmap);
     FileDlg.AddFilter(LoadNLSStr(SiBitmapFiles)+' (*.bmp)','*.BMP');
     FileDlg.AddFilter(LoadNLSStr(SiBitmapFilesPCX)+' (*.pcx)','*.PCX');
     FileDlg.AddFilter(LoadNLSStr(SiBitmapFilesGIF)+' (*.gif)','*.GIF');
     FileDlg.FileName := '*.BMP';
     FileDlg.DefaultExt := 'BMP';

     IF FileDlg.Execute THEN
     BEGIN
          try
             FImage.Bitmap.LoadFromFile(FileDlg.FileName);
          except
             ErrorBox(LoadNLSStr(SiInvalidBitmapFile));
          end;

          IF FImage.Bitmap.Empty THEN FImage.Left := -300
          ELSE FImage.Left := 3;
     END;

     FileDlg.Destroy;
END;


PROCEDURE TBitmapPropEditDialog.EvClear(Sender:TObject);
BEGIN
     FImage.Bitmap := NIL;
     FImage.Left := -300;
END;



FUNCTION TBitmapPropertyEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR  Bitmap:TBitmap;
     FDialog:TBitmapPropEditDialog;
BEGIN
     Bitmap := TBitmap(ClassToEdit);

     FDialog.Create(NIL);
     FDialog.HelpContext := hctxDialogBitmapPropertyEditor;
     FDialog.FImage.Bitmap.LoadFromBitmap(Bitmap);
     IF FDialog.FImage.Bitmap.Empty THEN FDialog.FImage.Left := -300
     ELSE FDialog.FImage.Left := 3;

     FDialog.ShowModal;

     CASE FDialog.ModalResult OF
        cmOk:
        BEGIN
             IF not FDialog.FImage.Bitmap.Empty THEN
             BEGIN
                  Bitmap.LoadFromBitmap(FDialog.FImage.Bitmap);
                  Result := peOk;
             END
             ELSE Result := peClear;
        END;
        cmCancel: Result := peCancel;
     END; {case}

     FDialog.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TFontPropEditDialog Class implementation                    บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION TFontPropertyEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR Font:TFont;
    FDialog:TFontDialog;
BEGIN
     Font:=TFont(ClassToEdit);
     FDialog.Create(NIL);
     FDialog.HelpContext := hctxDialogFontPropertyEditor;
     FDialog.EditFont:=Font;
     FDialog.ShowModal;

     //Modify ClassToEdit here
     result:=peCancel;
     CASE FDialog.ModalResult OF
        cmOk:
        BEGIN
             Font:=FDialog.EditFont;
             IF Font<>NIL THEN ClassToEdit:=Font;
             result:=peOk;
        END;
        cmCancel:result:=peCancel;
        cmNo:result:=peOk;  //Clear
     END; {case}

     FDialog.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TFormIconPropertyEditor Class implementation                บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION TIconPropertyEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR Icon,TempIcon:TIcon;
    s:STRING;
    FDialog:TOpenDialog;
    ret:BOOLEAN;
LABEL l;
BEGIN
     Icon:=TIcon(ClassToEdit);
l:
     FDialog.Create(Application.MainForm);
     FDialog.HelpContext := hctxDialogOpenIcon;
     FDialog.Title:=LoadNLSStr(SiSelectAnIcon);
     FDialog.AddFilter(LoadNLSStr(SiIconFiles)+' (*.ico)','*.ICO');
     FDialog.FileName:='*.ICO';
     FDialog.DefaultExt := 'ICO';

     ret := FDialog.Execute;
     s := FDialog.FileName;
     FDialog.Destroy;

     TempIcon:=NIL;
     IF ret THEN
     BEGIN
          TRY
             TempIcon.Create;
             TempIcon.LoadFromFile(s);
             TempIcon.Destroy;
             result:=peOk;
          EXCEPT
             TempIcon.Destroy;
             ErrorBox(LoadNLSStr(SiInvalidIcon));
             goto l;
          END;
     END
     ELSE result:=peCancel;

     IF result=peOk THEN
     BEGIN
          TRY
             Icon.LoadFromFile(s);
          EXCEPT
             result:=peClear;
          END;
     END;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TStringsPropertyEditor Class implementation                 บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TStringsPropEditDialog=CLASS(TDialog)
      PRIVATE
         FMemo:TMemo;
         AStrings:TStrings;
         PROCEDURE EvLoad(Sender:TObject);
      PUBLIC
         PROCEDURE SetupComponent;OVERRIDE;
    END;

PROCEDURE TStringsPropEditDialog.SetupComponent;

VAR  Button:TBitBtn;

BEGIN
  Inherited SetupComponent;

  Caption:=LoadNLSStr(SiEditStrings);
  Width:=600;
  Height:=260;
  XAlign:=xaCenter;
  YAlign:=yaCenter;
  Color:=clLtGray;
  BorderStyle:=bsSizeable;
  BorderIcons:=[biSystemMenu];

  FMemo:=InsertMemo(SELF,20,20,445,190,'');
  FMemo.WordWrap:=false;
  FMemo.ScrollBars:=ssBoth;
  FMemo.WantTabs:=TRUE;
  FMemo.Focus;
  FMemo.Align:=alFrame;

  Button:=InsertBitBtnNLS(SELF,480,180,100,30,bkOk,SOkButton,SClickHereToAccept);
  Button.Align:=alFixedRightTop;
  Button:=InsertBitBtnNLS(SELF,480,140,100,30,bkOpen,SiLoad,SiClickHereToLoadFromFile);
  Button.Align:=alFixedRightTop;
  Button.ModalResult:=cmNull;
  Button.OnClick:=EvLoad;
  Button:=InsertBitBtnNLS(SELF,480,100,100,30,bkNo,SiClear,SiClearHint);
  Button.Align:=alFixedRightTop;
  Button:=InsertBitBtnNLS(SELF,480,60,100,30,bkCancel,SCancelButton,SClickHereToCancel);
  Button.Align:=alFixedRightTop;
  Button:=InsertBitBtnNLS(SELF,480,20,100,30,bkHelp,SHelpButton,SClickHereToGetHelp);
  Button.Align:=alFixedRightTop;
END;

PROCEDURE TStringsPropEditDialog.EvLoad(Sender:TObject);
VAR  CFOD:TOpenDialog;
BEGIN
     CFOD.Create(SELF);
     CFOD.HelpContext := hctxDialogOpenStrings;
     CFOD.AddFilter(LoadNLSStr(SiAllFiles)+' (*.*)','*.*');
     CFOD.FilterIndex := 1;
     IF CFOD.Execute THEN
     BEGIN
          IF FileExists(CFOD.FileName) THEN
          BEGIN
               FMemo.Lines.Clear;
               FMemo.BeginUpdate;
               FMemo.Lines.LoadFromFile(CFOD.FileName);
               FMemo.EndUpdate;
          END
          ELSE ErrorBox(LoadNLSStr(SiFileNotFound));
     END;
     CFOD.Destroy;
END;


FUNCTION TStringsPropertyEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR  FDialog:TStringsPropEditDialog;
     AStrings:TStrings;
     OldStrings:TStringList;
BEGIN
     AStrings := TStrings(ClassToEdit);
     IF AStrings = NIL THEN exit;

     FDialog.Create(NIL);
     FDialog.HelpContext := hctxDialogStringsPropertyEditor;
     FDialog.AStrings := AStrings;

     FDialog.FMemo.Lines.Assign(AStrings);

     OldStrings.Create; {to recover outline strings}
     OldStrings.Assign(AStrings);


     FDialog.ShowModal;

     {Modify ClassToEdit here}
     Result := peCancel;
     CASE FDialog.ModalResult OF
        cmOk:
        BEGIN
             Result := peOk;
             TRY
                AStrings.Assign(FDialog.FMemo.Lines);
             EXCEPT
                ON EOutlineError DO
                BEGIN
                     ErrorBox(LoadNLSStr(SiInvalidOutlineHierarchy));
                     IF OldStrings <> NIL THEN AStrings.Assign(OldStrings);
                     Result := peCancel;
                END;
             END;
        END;
        cmCancel:
        BEGIN
             Result := peCancel;
        END;
        cmNo: //Clear
        BEGIN
             AStrings.Clear;
             Result := peOk;
        END;
     END; {case}

     FDialog.Destroy;

     IF OldStrings <> NIL THEN OldStrings.Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TFilterPropertyEditor Class implementation                  บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TFilterPropEditDialog=CLASS(TDialog)
       PRIVATE
         Grid:TStringGrid;
         Filter:STRING;
       PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
    END;


PROCEDURE TFilterPropEditDialog.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiEditFilter);
     ClientWidth := 470;
     ClientHeight := 220;
     PenColor := clWindowText;

     Grid.Create(SELF);
     Grid.SetWindowPos(20,20,330,175);
     Grid.ColCount := 2;
     Grid.RowCount := 16;
     Grid.DefaultColWidth := 160;
     Grid.DefaultRowHeight := 25;
     Grid.FixedCols := 0;
     Grid.Scrollbars := ssVertical;
     Grid.Options := Grid.Options + [goEditing];
     Grid.Cells[0,0] := LoadNLSStr(SiFilterName);
     Grid.Cells[1,0] := LoadNLSStr(SiFilterMask);
     Grid.Parent := SELF;

     InsertBitBtnNLS(SELF,360,165,95,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,360,125,95,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,360,20,95,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


PROCEDURE TFilterPropEditDialog.SetupShow;
VAR  AMask,AFilter:STRING;
     s:STRING;
     p,y:INTEGER;
BEGIN
     Inherited SetupShow;

     y := 1;
     s := Filter;
     p := pos('|',s);
     WHILE (p > 0) AND (y < 16) DO
     BEGIN
          AFilter := copy(s,1,p-1);
          delete(s,1,p);
          p := pos('|',s);
          IF p > 0 THEN
          BEGIN
               AMask := copy(s,1,p-1);
               delete(s,1,p);
          END
          ELSE
          BEGIN
               AMask := s;
               s := '';
          END;
          Grid.Cells[0,y] := AFilter;
          Grid.Cells[1,y] := AMask;
          inc(y);
          p := pos('|',s);
     END;
END;


FUNCTION TFilterPropertyEditor.Execute(VAR Value:STRING;ValueLen:LONGINT):TPropertyEditorReturn;
VAR  Dialog:TFilterPropEditDialog;
     AMask,AFilter,s:STRING;
     i:LONGINT;
BEGIN
     Dialog.Create(NIL);
     Dialog.HelpContext := hctxDialogFilterPropertyEditor;
     Dialog.Filter := Value;

     IF Dialog.Execute THEN
     BEGIN
          s := '';
          FOR i := 1 TO Dialog.Grid.RowCount-1 DO
          BEGIN
               AFilter := Dialog.Grid.Cells[0,i];
               AMask := Dialog.Grid.Cells[1,i];
               IF (AFilter <> '') OR (AMask <> '') THEN
               BEGIN
                    IF s <> '' THEN s := s + '|';
                    s := s + AFilter + '|' + AMask;
               END;
          END;
          Value := s;
          Result := edOk;
     END
     ELSE Result := edCancel;

     Dialog.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TMCIFileNamePropertyEditor Class implementation             บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION TMCIFileNamePropertyEditor.Execute(VAR Value;ValueLen:LONGINT):TPropertyEditorReturn;
VAR
    Device:TMCIDevice;
    Dlg:TOpenDialog;
    f,d:STRING;
BEGIN
     Device:=TMCIDevice(Owner);
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogOpenMCIFile;
     Dlg.Caption := LoadNLSStr(SiSelectAFile);
     Device.GetDefaultFileMask(d,f);
     Dlg.AddFilter(f,d);
     IF Dlg.Execute THEN
     BEGIN
          Value := Dlg.FileName;
          result:=edOk;
     END
     ELSE result:=edCancel;
     Dlg.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TMediaPlayerFileNamePropertyEditor Class implementation     บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION TMediaPlayerFileNamePropertyEditor.Execute(VAR Value;ValueLen:LONGINT):TPropertyEditorReturn;
VAR
    Dlg:TOpenDialog;
BEGIN
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogOpenMediaPlayerFile;
     Dlg.Caption := LoadNLSStr(SiSelectAFile);
     IF Dlg.Execute THEN
     BEGIN
          Value := Dlg.FileName;
          result:=edOk;
     END
     ELSE result:=edCancel;
     Dlg.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TStatusPanelsPropertyEditor Class implementation            บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TStatusPanelsPropEditDialog=CLASS(TDialog)
      PRIVATE
         FPanels:TStatusPanels;
         FListBox:TListBox;
         FText:TEdit;
         FWidth:TEdit;
         FStyle:TComboBox;
         FBevel:TComboBox;
         FAlignment:TComboBox;
         FCurrentPanel:TStatusPanel;
         FCurrentIndex:LONGINT;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE NewClicked(Sender:TObject);
         PROCEDURE DeleteClicked(Sender:TObject);
         PROCEDURE UpdateClicked(Sender:TObject);
         PROCEDURE ListItemFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE StoreItem;
         PROCEDURE TextChange(Sender:TObject);
         PROCEDURE WidthChange(Sender:TObject);
         PROCEDURE StyleSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE BevelSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE AlignmentSelect(Sender:TObject;Index:LONGINT);
    END;


{$HINTS OFF}
PROCEDURE TStatusPanelsPropEditDialog.TextChange(Sender:TObject);
BEGIN
     IF FCurrentPanel=NIL THEN exit;
     FCurrentPanel.Text:=FText.Text;
END;

PROCEDURE TStatusPanelsPropEditDialog.WidthChange(Sender:TObject);
VAR i:LONGINT;
    c:Integer;
BEGIN
     IF FCurrentPanel=NIL THEN exit;
     VAL(FWidth.Text,i,c);
     IF ((i<=2)OR(c<>0)) THEN exit;
     FCurrentPanel.Width:=i;
END;


PROCEDURE TStatusPanelsPropEditDialog.StyleSelect(Sender:TObject;Index:LONGINT);
BEGIN
     IF FCurrentPanel=NIL THEN exit;
     IF FStyle.Text='OwnerDraw' THEN FCurrentPanel.Style:=psOwnerDraw
     ELSE FCurrentPanel.Style:=psText;
END;

PROCEDURE TStatusPanelsPropEditDialog.BevelSelect(Sender:TObject;Index:LONGINT);
BEGIN
     IF FCurrentPanel=NIL THEN exit;
     IF FBevel.Text='None' THEN FCurrentPanel.Bevel:=pbNone
     ELSE IF FBevel.Text='Raised' THEN FCurrentPanel.Bevel:=pbRaised
     ELSE FCurrentPanel.Bevel:=pbLowered;
END;

PROCEDURE TStatusPanelsPropEditDialog.AlignmentSelect(Sender:TObject;Index:LONGINT);
BEGIN
     IF FCurrentPanel=NIL THEN exit;
     IF FAlignment.Text='Center' THEN FCurrentPanel.Alignment:=taCenter
     ELSE IF FAlignment.Text='Right justify' THEN FCurrentPanel.Alignment:=taRightJustify
     ELSE FCurrentPanel.Alignment:=taLeftJustify;
END;

PROCEDURE TStatusPanelsPropEditDialog.UpdateClicked(Sender:TObject);
BEGIN
     StoreItem;
     FPanels.Update(NIL);
END;

PROCEDURE TStatusPanelsPropEditDialog.NewClicked(Sender:TObject);
VAR Panel:TStatusPanel;
BEGIN
     Panel:=FPanels.Add;
     IF Panel.Text='' THEN FListBox.Items.Add(tostr(Panel.Index)+' - ('+LoadNLSStr(SiUntitled)+')')
     ELSE FListBox.Items.Add(tostr(Panel.Index)+' - '+Panel.Text);
     FListBox.ItemIndex:=Panel.Index;
     FPanels.Update(NIL);
END;

PROCEDURE TStatusPanelsPropEditDialog.DeleteClicked(Sender:TObject);
VAR Panel:TStatusPanel;
    Index:LONGINT;
BEGIN
     Index:=FListBox.ItemIndex;
     IF Index<0 THEN exit;
     FListBox.Items.Delete(Index);
     Panel:=FPanels[Index];
     Panel.Destroy;
     FCurrentPanel:=NIL;
     FCurrentIndex:=-1;
     IF FListBox.Items.Count>0 THEN FListBox.ItemIndex:=0;
END;
{$HINTS ON}

PROCEDURE TStatusPanelsPropEditDialog.StoreItem;
VAR c:Integer;
    i:LONGINT;
BEGIN
     IF FCurrentPanel<>NIL THEN //store values
     BEGIN
          FCurrentPanel.Text:=FText.Text;
          IF FText.Text='' THEN FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - ('+LoadNLSStr(SiUntitled)+')'
          ELSE FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - '+FText.Text;

          VAL(FWidth.Text,i,c);
          IF ((i<=2)OR(c<>0)) THEN i:=100;
          FCurrentPanel.Width:=i;

          IF FStyle.Text='OwnerDraw' THEN FCurrentPanel.Style:=psOwnerDraw
          ELSE FCurrentPanel.Style:=psText;

          IF FBevel.Text='None' THEN FCurrentPanel.Bevel:=pbNone
          ELSE IF FBevel.Text='Raised' THEN FCurrentPanel.Bevel:=pbRaised
          ELSE FCurrentPanel.Bevel:=pbLowered;

          IF FAlignment.Text='Center' THEN FCurrentPanel.Alignment:=taCenter
          ELSE IF FAlignment.Text='Right justify' THEN FCurrentPanel.Alignment:=taRightJustify
          ELSE FCurrentPanel.Alignment:=taLeftJustify;
     END;
END;

PROCEDURE TStatusPanelsPropEditDialog.ListItemFocus(Sender:TObject;Index:LONGINT);
BEGIN
     StoreItem;

     FCurrentPanel:=FPanels[Index];
     FCurrentIndex:=Index;
     FText.Text:=FCurrentPanel.Text;
     FWidth.Text:=tostr(FCurrentPanel.Width);
     IF FCurrentPanel.Style=psText THEN FStyle.Text:='Text'
     ELSE FStyle.Text:='OwnerDraw';
     CASE FCurrentPanel.Bevel OF
        pbLowered:FBevel.Text:='Lowered';
        pbRaised:FBevel.Text:='Raised';
        ELSE FBevel.Text:='None';
     END;
     CASE FCurrentPanel.Alignment OF
        taRightJustify:FAlignment.Text:='Right justify';
        taCenter:FAlignment.Text:='Center';
        ELSE FAlignment.Text:='Left justify';
     END;
END;

PROCEDURE TStatusPanelsPropEditDialog.SetupComponent;
VAR Button:TButton;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiStatusbarPanelsEditor);
     Width:=435;
     Height:=310;

     InsertGroupBoxNLS(SELF,10,50,180,220,SiPanels);
     FListBox:=InsertListBox(SELF,20,100,160,150,'');
     FListBox.OnItemFocus:=ListItemFocus;

     Button:=InsertButtonNLS(SELF,20,60,70,30,SiNewButton,SiNewPanel);
     Button.OnClick:=NewClicked;
     Button:=InsertButtonNLS(SELF,100,60,70,30,SiDelete,SiDeletePanel);
     Button.OnClick:=DeleteClicked;

     InsertGroupBoxNLS(SELF,200,50,220,220,SiPanelProperties);

     InsertLabelNLS(SELF,210,220,50,20,SiTextLabel);
     FText:=InsertEdit(SELF,280,225,130,20,'','');
     FText.OnChange:=TextChange;

     InsertLabelNLS(SELF,210,190,100,20,SiWidthLabel);
     FWidth:=InsertEdit(SELF,280,195,130,20,'','');
     FWidth.OnChange:=WidthChange;
     FWidth.NumbersOnly:=TRUE;

     InsertLabelNLS(SELF,210,160,100,20,SiStyleLabel);
     FStyle:=InsertComboBox(SELF,280,165,130,20,csDropDownList);
     FStyle.Items.Add('Text');
     FStyle.Items.Add('OwnerDraw');
     FStyle.OnItemSelect:=StyleSelect;

     InsertLabelNLS(SELF,210,130,100,20,SiBevelLabel);
     FBevel:=InsertComboBox(SELF,280,135,130,20,csDropDownList);
     FBevel.Items.Add('Lowered');
     FBevel.Items.Add('Raised');
     FBevel.Items.Add('None');
     FBevel.OnItemSelect:=BevelSelect;

     InsertLabelNLS(SELF,210,100,100,20,SiAlignment);
     FAlignment:=InsertComboBox(SELF,280,105,130,20,csDropDownList);
     FAlignment.Items.Add('Left justify');
     FAlignment.Items.Add('Right justify');
     FAlignment.Items.Add('Center');
     FAlignment.OnItemSelect:=AlignmentSelect;

     Button:=InsertButtonNLS(SELF,210,60,170,30,SiUpdate,SiUpdateHint);
     Button.OnClick:=UpdateClicked;

     InsertBitBtnNLS(SELF,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

FUNCTION TStatusPanelsPropertyEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR  StatusPanels:TStatusPanels;
     FDialog:TStatusPanelsPropEditDialog;
     SavePanels:TStatusPanels;
     Panel:TStatusPanel;
     t:LONGINT;
BEGIN
     StatusPanels:=TStatusPanels(ClassToEdit);
     IF StatusPanels.StatusBar=NIL THEN
     BEGIN
          result:=peNoEditor;
          exit;
     END;

     SavePanels.Create(NIL);
     SavePanels.Assign(StatusPanels);

     FDialog.Create(NIL);
     FDialog.HelpContext := hctxDialogStatusPanelsPropertyEditor;
     FDialog.FPanels:=StatusPanels;

     FOR t:=0 TO StatusPanels.Count-1 DO
     BEGIN
          Panel:=StatusPanels[t];
          IF Panel.Text='' THEN FDialog.FListBox.Items.Add(tostr(t)+' - ('+LoadNLSStr(SiUntitled)+')')
          ELSE FDialog.FListBox.Items.Add(tostr(t)+' - '+Panel.Text);
     END;
     IF FDialog.FListBox.Items.Count>0 THEN FDialog.FListBox.ItemIndex:=0;

     FDialog.ShowModal;

     //Modify ClassToEdit here
     result:=peCancel;
     CASE FDialog.ModalResult OF
        cmOk:
        BEGIN
             FDialog.StoreItem;
             result:=peOk;
        END;
        ELSE
        BEGIN
             StatusPanels.Assign(SavePanels);
             result:=peCancel;
        END;
     END; {case}

     SavePanels.Destroy;
     FDialog.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: THeaderSectionsPropertyEditor Class implementation          บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    THeaderSectionsPropEditDialog=CLASS(TDialog)
      PRIVATE
         FSections:THeaderSections;
         FListBox:TListBox;
         FText:TEdit;
         FWidth:TEdit;
         FMinWidth,FMaxWidth:TEdit;
         FStyle:TComboBox;
         FAlignment:TComboBox;
         FCurrentSection:THeaderSection;
         FCurrentIndex:LONGINT;
         FAllowClick:TCheckBox;
         FAllowSize:TCheckBox;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE NewClicked(Sender:TObject);
         PROCEDURE DeleteClicked(Sender:TObject);
         PROCEDURE UpdateClicked(Sender:TObject);
         PROCEDURE ListItemFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE StoreItem;
         PROCEDURE TextChange(Sender:TObject);
         PROCEDURE WidthChange(Sender:TObject);
         PROCEDURE MinWidthChange(Sender:TObject);
         PROCEDURE MaxWidthChange(Sender:TObject);
         PROCEDURE StyleSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE AlignmentSelect(Sender:TObject;Index:LONGINT);
    END;


{$HINTS OFF}
PROCEDURE THeaderSectionsPropEditDialog.TextChange(Sender:TObject);
BEGIN
     IF FCurrentSection=NIL THEN exit;
     FCurrentSection.Text:=FText.Text;
END;

PROCEDURE THeaderSectionsPropEditDialog.WidthChange(Sender:TObject);
VAR i:LONGINT;
    c:Integer;
BEGIN
     IF FCurrentSection=NIL THEN exit;
     VAL(FWidth.Text,i,c);
     IF c<>0 THEN exit;
     FCurrentSection.Width:=i;
END;

PROCEDURE THeaderSectionsPropEditDialog.MinWidthChange(Sender:TObject);
VAR i:LONGINT;
    c:Integer;
BEGIN
     IF FCurrentSection=NIL THEN exit;
     VAL(FMinWidth.Text,i,c);
     IF c<>0 THEN exit;
     FCurrentSection.MinWidth:=i;
END;

PROCEDURE THeaderSectionsPropEditDialog.MaxWidthChange(Sender:TObject);
VAR i:LONGINT;
    c:Integer;
BEGIN
     IF FCurrentSection=NIL THEN exit;
     VAL(FMaxWidth.Text,i,c);
     IF c<>0 THEN exit;
     FCurrentSection.MaxWidth:=i;
END;


PROCEDURE THeaderSectionsPropEditDialog.StyleSelect(Sender:TObject;Index:LONGINT);
BEGIN
     IF FCurrentSection=NIL THEN exit;
     IF FStyle.Text='OwnerDraw' THEN FCurrentSection.Style:=hsOwnerDraw
     ELSE FCurrentSection.Style:=hsText;
END;

PROCEDURE THeaderSectionsPropEditDialog.AlignmentSelect(Sender:TObject;Index:LONGINT);
BEGIN
     IF FCurrentSection=NIL THEN exit;
     IF FAlignment.Text='Center' THEN FCurrentSection.Alignment:=taCenter
     ELSE IF FAlignment.Text='Right justify' THEN FCurrentSection.Alignment:=taRightJustify
     ELSE FCurrentSection.Alignment:=taLeftJustify;
END;

PROCEDURE THeaderSectionsPropEditDialog.UpdateClicked(Sender:TObject);
BEGIN
     StoreItem;
     FSections.Update(NIL);
END;

PROCEDURE THeaderSectionsPropEditDialog.NewClicked(Sender:TObject);
VAR Section:THeaderSection;
BEGIN
     Section:=FSections.Add;
     IF Section.Text='' THEN FListBox.Items.Add(tostr(Section.Index)+' - ('+LoadNLSStr(SiUntitled)+')')
     ELSE FListBox.Items.Add(tostr(Section.Index)+' - '+Section.Text);
     FListBox.ItemIndex:=Section.Index;
     FSections.Update(NIL);
END;

PROCEDURE THeaderSectionsPropEditDialog.DeleteClicked(Sender:TObject);
VAR Section:THeaderSection;
    Index:LONGINT;
BEGIN
     Index:=FListBox.ItemIndex;
     IF Index<0 THEN exit;
     FListBox.Items.Delete(Index);
     Section:=FSections[Index];
     Section.Destroy;
     FCurrentSection:=NIL;
     FCurrentIndex:=-1;
     IF FListBox.Items.Count>0 THEN FListBox.ItemIndex:=0;
END;
{$HINTS ON}

PROCEDURE THeaderSectionsPropEditDialog.StoreItem;
VAR c:Integer;
    i:LONGINT;
BEGIN
     IF FCurrentSection<>NIL THEN //store values
     BEGIN
          FCurrentSection.Text:=FText.Text;
          IF FText.Text='' THEN FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - ('+LoadNLSStr(SiUntitled)+')'
          ELSE FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - '+FText.Text;

          VAL(FWidth.Text,i,c);
          IF c<>0 THEN i:=100;
          FCurrentSection.Width:=i;

          VAL(FMinWidth.Text,i,c);
          IF c<>0 THEN i:=0;
          FCurrentSection.MinWidth:=i;

          VAL(FMaxWidth.Text,i,c);
          IF c<>0 THEN i:=10000;
          FCurrentSection.MaxWidth:=i;

          IF FStyle.Text='OwnerDraw' THEN FCurrentSection.Style:=hsOwnerDraw
          ELSE FCurrentSection.Style:=hsText;

          IF FAlignment.Text='Center' THEN FCurrentSection.Alignment:=taCenter
          ELSE IF FAlignment.Text='Right justify' THEN FCurrentSection.Alignment:=taRightJustify
          ELSE FCurrentSection.Alignment:=taLeftJustify;

          FCurrentSection.AllowClick:=FAllowClick.Checked;
          FCurrentSection.AllowSize:=FAllowSize.Checked;
     END;
END;

PROCEDURE THeaderSectionsPropEditDialog.ListItemFocus(Sender:TObject;Index:LONGINT);
BEGIN
     StoreItem;

     FCurrentSection:=FSections[Index];
     FCurrentIndex:=Index;
     FText.Text:=FCurrentSection.Text;
     FWidth.Text:=tostr(FCurrentSection.Width);
     FMinWidth.Text:=tostr(FCurrentSection.MinWidth);
     FMaxWidth.Text:=tostr(FCurrentSection.MaxWidth);
     IF FCurrentSection.Style=hsText THEN FStyle.Text:='Text'
     ELSE FStyle.Text:='OwnerDraw';

     CASE FCurrentSection.Alignment OF
        taRightJustify:FAlignment.Text:='Right justify';
        taCenter:FAlignment.Text:='Center';
        ELSE FAlignment.Text:='Left justify';
     END;

     FAllowClick.Checked:=FCurrentSection.AllowClick;
     FAllowSize.Checked:=FCurrentSection.AllowSize;
END;

PROCEDURE THeaderSectionsPropEditDialog.SetupComponent;
VAR Button:TButton;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiHeaderControlSectionsEditor);
     Width:=435;
     Height:=350;

     InsertGroupBoxNLS(SELF,10,50,180,260,SiSections);
     FListBox:=InsertListBox(SELF,20,100,160,190,'');
     FListBox.OnItemFocus:=ListItemFocus;

     Button:=InsertButtonNLS(SELF,20,60,70,30,SiNewButton,SiNewSection);
     Button.OnClick:=NewClicked;
     Button:=InsertButtonNLS(SELF,100,60,70,30,SiDelete,SiDeleteSection);
     Button.OnClick:=DeleteClicked;

     InsertGroupBoxNLS(SELF,200,50,220,260,SiSectionProperties);

     InsertLabelNLS(SELF,210,260,50,20,SiTextLabel);
     FText:=InsertEdit(SELF,280,265,130,20,'','');
     FText.OnChange:=TextChange;

     InsertLabelNLS(SELF,210,230,100,20,SiWidthLabel);
     FWidth:=InsertEdit(SELF,280,235,130,20,'','');
     FWidth.OnChange:=WidthChange;
     FWidth.NumbersOnly:=TRUE;

     InsertLabelNLS(SELF,210,200,60,20,SiMinMaxLabel);
     FMinWidth:=InsertEdit(SELF,280,205,60,20,'','');
     FMinWidth.OnChange:=MinWidthChange;
     FMinWidth.NumbersOnly:=TRUE;
     FMaxWidth:=InsertEdit(SELF,350,205,60,20,'','');
     FMaxWidth.OnChange:=MaxWidthChange;
     FMaxWidth.NumbersOnly:=TRUE;

     InsertLabelNLS(SELF,210,170,100,20,SiStyleLabel);
     FStyle:=InsertComboBox(SELF,280,175,130,20,csDropDownList);
     FStyle.Items.Add('Text');
     FStyle.Items.Add('OwnerDraw');
     FStyle.OnItemSelect:=StyleSelect;

     InsertLabelNLS(SELF,210,140,100,20,SiAlignment);
     FAlignment:=InsertComboBox(SELF,280,145,130,20,csDropDownList);
     FAlignment.Items.Add('Left justify');
     FAlignment.Items.Add('Right justify');
     FAlignment.Items.Add('Center');
     FAlignment.OnItemSelect:=AlignmentSelect;

     FAllowClick:=InsertCheckBoxNLS(SELF,210,115,180,20,SiAllowClick,0);
     FAllowSize:=InsertCheckBoxNLS(SELF,210,95,180,20,SiAllowSize,0);

     Button:=InsertButtonNLS(SELF,210,60,170,30,SiUpdate,SiUpdateSection);
     Button.OnClick:=UpdateClicked;

     InsertBitBtnNLS(SELF,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

FUNCTION THeaderSectionsPropertyEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR  HeaderSections:THeaderSections;
     FDialog:THeaderSectionsPropEditDialog;
     SaveHeaders:THeaderSections;
     Section:THeaderSection;
     t:LONGINT;
BEGIN
     HeaderSections:=THeaderSections(ClassToEdit);
     IF HeaderSections.HeaderControl=NIL THEN
     BEGIN
          result:=peNoEditor;
          exit;
     END;

     SaveHeaders.Create(NIL);
     SaveHeaders.Assign(HeaderSections);

     FDialog.Create(NIL);
     FDialog.HelpContext := hctxDialogHeaderSectionsPropertyEditor;
     FDialog.FSections:=HeaderSections;

     FOR t:=0 TO HeaderSections.Count-1 DO
     BEGIN
          Section:=HeaderSections[t];
          IF Section.Text='' THEN FDialog.FListBox.Items.Add(tostr(t)+' - ('+LoadNLSStr(SiUntitled)+')')
          ELSE FDialog.FListBox.Items.Add(tostr(t)+' - '+Section.Text);
     END;
     IF FDialog.FListBox.Items.Count>0 THEN FDialog.FListBox.ItemIndex:=0;

     FDialog.ShowModal;

     //Modify ClassToEdit here
     result:=peCancel;
     CASE FDialog.ModalResult OF
        cmOk:
        BEGIN
             FDialog.StoreItem;
             result:=peOk;
        END;
        ELSE
        BEGIN
             HeaderSections.Assign(SaveHeaders);
             result:=peCancel;
        END;
     END; {case}

     SaveHeaders.Destroy;
     FDialog.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TPageEditor Property Editor Class implementation            บ
บ                                                                           บ
บ Last modified: January 1997                                               บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

CONST
    SubPageIndent = '    ';

TYPE
    TPageEditor=CLASS(TDialog)
      PRIVATE
         List:TListBox;
         Edit,Ins,Del:TButton;
         CloseBtn,HelpBtn:TBitBtn;
         PageAccess:TPageAccess;
         PROCEDURE EvEdit(Sender:TObject);
         PROCEDURE EvIns(Sender:TObject);
         PROCEDURE EvDel(Sender:TObject);
         PROCEDURE EvItemFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE EvItemSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE EvListScan(Sender:TObject;VAR KeyCode:TKeyCode);
         PROCEDURE SetButtons;
         FUNCTION ItemDialog(VAR CaptionHint:STRING;VAR HelpCtx:LONGINT):BOOLEAN;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
    END;


PROCEDURE TPageEditor.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiPageEditor);
     ClientWidth := 400;
     ClientHeight := 300;

     InsertLabelNLS(SELF,20,245,70,30,SiPages);
     Edit := InsertButton(SELF,90,250,90,30,LoadNLSStr(SEditButton)+'...',LoadNLSStr(SiEditSelectedPage));
     Edit.OnClick := EvEdit;
     Ins := InsertButton(SELF,190,250,90,30,LoadNLSStr(SInsertButton)+'...',LoadNLSStr(SiInsertNewPage));
     Ins.OnClick := EvIns;
     Del := InsertButton(SELF,290,250,90,30,LoadNLSStr(SDeleteButton),LoadNLSStr(SiDeleteSelectedPage));
     Del.OnClick := EvDel;

     List := InsertListBox(SELF,20,70,360,170,'');
     List.OnItemFocus := EvItemFocus;
     List.OnItemSelect := EvItemSelect;
     List.OnScan := EvListScan;

     CloseBtn := InsertBitBtn(SELF,160,20,100,30,bkClose,LoadNLSStr(SCloseButton),'');
     CloseBtn.Default := TRUE;
     HelpBtn := InsertBitBtn(SELF,280,20,100,30,bkHelp,LoadNLSStr(SHelpButton),'');
END;


PROCEDURE TPageEditor.SetupShow;
VAR  Page:TPage;
     i:LONGINT;
     s:STRING;
BEGIN
     FOR i := 0 TO PageAccess.Count-1 DO
     BEGIN
          Page := PageAccess.Pages[i];
          IF Page.Caption = Page.Hint THEN s := Page.Caption
          ELSE s := Page.Caption + '|' + Page.Hint;
          IF Page.IsSubPage THEN s := SubPageIndent + s;
          List.Items.AddObject(s,Page);
     END;
     List.Items.Add(''); {empty item}
     List.ItemIndex := 0;
     SetButtons;
     List.Focus;
END;


{$HINTS OFF}
PROCEDURE TPageEditor.EvEdit(Sender:TObject);
VAR  idx,hcx:LONGINT;
     s:STRING;
     Page:TPage;
LABEL ex;
BEGIN
     idx := List.ItemIndex;
     IF (idx < 0) OR (idx >= PageAccess.Count) THEN goto ex; {not the last}
     Page := TPage(PageAccess.Objects[idx]);
     IF Page = NIL THEN goto ex;

     IF Page.Caption = Page.Hint THEN s := Page.Caption
     ELSE s := Page.Caption + '|' + Page.Hint;
     hcx := Page.HelpContext;
     IF ItemDialog(s,hcx) THEN
     BEGIN
          Page.Caption := GetShortHint(s);
          Page.Hint := GetLongHint(s);
          Page.ShowHint := FALSE;
          Page.HelpContext := hcx;
          IF PageAccess.OnChange <> NIL THEN PageAccess.OnChange(PageAccess);
          IF Page.IsSubPage THEN s := SubPageIndent + s; {IsSubPage ist erst hier gesetzt}
          List.Items[idx] := s;
     END;
     SetButtons;
ex:
     List.Focus;
END;


PROCEDURE TPageEditor.EvIns(Sender:TObject);
VAR  Page:TPage;
     idx,hcx:LONGINT;
     s:STRING;
LABEL ex;
BEGIN
     idx := List.ItemIndex;
     IF idx < 0 THEN goto ex;
     s := '';
     hcx := 0;
     IF not ItemDialog(s,hcx) THEN goto ex;

     PageAccess.Insert(idx,s);
     Page := TPage(PageAccess.Objects[idx]);
     Page.HelpContext := hcx;

     IF Page.Caption = Page.Hint THEN s := Page.Caption
     ELSE s := Page.Caption + '|' + Page.Hint;
     List.Items.InsertObject(idx,s,Page);
     IF Page.IsSubPage THEN List.Items[idx] := SubPageIndent + s; {IsSubPage ist erst hier gesetzt}
     SetButtons;
ex:
     List.Focus;
END;


PROCEDURE TPageEditor.EvDel(Sender:TObject);
VAR  Page:TPage;
     idx:LONGINT;
LABEL ex;
BEGIN
     idx := List.ItemIndex;
     IF (idx < 0) OR (idx >= PageAccess.Count) THEN goto ex; {not the last}
     Page := TPage(PageAccess.Objects[idx]);
     IF Page = NIL THEN goto ex;

     IF PageAccess.Count < 2 THEN
     BEGIN
          MessageBox(LoadNLSStr(SiTheControlMustContainPage),mtInformation,
                     [mbOk]);
          goto ex;
     END;

     IF MessageBox(FmtLoadNLSStr(SiDeletePageConfirm,[Page.Caption]),mtConfirmation,
                   mbOkCancel) = mrCancel THEN goto ex;

     PageAccess.Delete(idx);
     List.Items.Delete(idx);
     List.ItemIndex := idx;
     SetButtons;
ex:
     List.Focus;
END;


PROCEDURE TPageEditor.EvItemFocus(Sender:TObject;Index:LONGINT);
BEGIN
     SetButtons;
END;


PROCEDURE TPageEditor.EvItemSelect(Sender:TObject;Index:LONGINT);
BEGIN
     EvEdit(Edit);
END;


PROCEDURE TPageEditor.EvListScan(Sender:TObject;VAR KeyCode:TKeyCode);
BEGIN
     CASE KeyCode OF
       {$IFDEF OS2}
       kbEnter,
       {$ENDIF}
       kbCR:
       BEGIN
            EvEdit(Edit);
            KeyCode := kbNull;
       END;
       kbIns:
       BEGIN
            EvIns(Ins);
            KeyCode := kbNull;
       END;
       kbDel:
       BEGIN
            EvDel(Del);
            KeyCode := kbNull;
       END;
     END;
END;
{$HINTS ON}


PROCEDURE TPageEditor.SetButtons;
VAR  idx:LONGINT;
BEGIN
     idx := List.ItemIndex;
     Edit.Enabled := (idx >= 0) AND (idx < PageAccess.Count);
     Ins.Enabled := TRUE;
     Del.Enabled := (idx >= 0) AND (idx < PageAccess.Count);
END;


FUNCTION TPageEditor.ItemDialog(VAR CaptionHint:STRING;VAR HelpCtx:LONGINT):BOOLEAN;
VAR  Dlg:TDialog;
     Group:TGroupBox;
     Edit1,Edit2,Edit3:TEdit;
     hc:LONGINT;
     e:INTEGER;
     IsTabbedAccess:BOOLEAN;
     AddHeight:LONGINT;
BEGIN
     Result := FALSE;

     IsTabbedAccess := PageAccess.Notebook.Parent IS TTabbedNotebook;
     IF IsTabbedAccess THEN AddHeight := 45
     ELSE AddHeight := 0;

     Dlg.Create(SELF);
     Dlg.HelpContext := hctxDialogPageItemEditor;
     Dlg.ClientWidth := 400;
     Dlg.ClientHeight := 200 + AddHeight;
     Dlg.Caption := LoadNLSStr(SiSetupPage);
     Group := InsertGroupBox(Dlg,20,70,360,110+AddHeight,'');
     InsertLabelNLS(Group,20,65+AddHeight,110,20,SiCaption);
     Edit1 := InsertEdit(Group,130,65+AddHeight,210,20,GetShortHint(CaptionHint),'');
     Edit1.Focus;
     IF IsTabbedAccess THEN
     BEGIN
          InsertLabelNLS(Group,20,65,110,20,SiPageHint);
          Edit2 := InsertEdit(Group,130,65,210,20,GetLongHint(CaptionHint),'');
     END;
     InsertLabelNLS(Group,20,20,110,20,SiHelpContext);
     Edit3 := InsertEdit(Group,130,20,210,20,tostr(HelpCtx),'');

     InsertBitBtnNLS(Dlg,160,20,100,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(Dlg,280,20,100,30,bkCancel,SCancelButton,SClickHereToCancel);

     IF Dlg.Execute THEN
     BEGIN
          CaptionHint := Edit1.Caption;
          IF IsTabbedAccess THEN
          BEGIN
               CaptionHint := CaptionHint +'|'+ Edit2.Caption;
          END;
          val(Edit3.Caption,hc,e);
          IF e = 0 THEN HelpCtx := hc;
          Result := TRUE;
     END;
     Dlg.Destroy;
END;


FUNCTION TPageAccessEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR  Dlg:TPageEditor;
BEGIN
     Result := peNoEditor;  {wird immer sofort aktualisiert!}
     IF not (ClassToEdit IS TPageAccess) THEN exit;

     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogPageAccessPropertyEditor;
     Dlg.PageAccess := TPageAccess(ClassToEdit);
     Dlg.Execute;
     Dlg.Destroy;
     Result := peCancel;  {wird immer sofort aktualisiert!}
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TFormLanguagePropertyEditor Class implementation            บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//!!!!!!!!!! bei nderungen auch Language Manager,SIB_DLG und CLASSES ndern!!!!!!!!!!!!!!!!!!!
TYPE
     PLanguageItem=^TLanguageItem;
     TLanguageItem=RECORD
                         Name:PString;
                         Components:POINTER;    //not used here !
                         Menus:POINTER;         //not used here !
                         StringTables:POINTER;  //not used here !
                         Next:PLanguageItem;
     END;
//!!!!!!!!!! bei nderungen auch Language Manager ndern!!!!!!!!!!!!!!!!!!!
     PLanguageInfo=^TLanguageInfo;
     TLanguageInfo=RECORD
                         CurrentLanguageName:PString;         //only copy !!
                         CurrentLanguageComponents:POINTER;   //not used here !
                         CurrentLanguageMenus:POINTER;        //not used here !
                         CurrentLanguageStringTables:POINTER; //not used here !
                         Items:PLanguageItem;
     END;
//!!!!!!!!!! bei nderungen auch Language Manager,SIB_DLG und CLASSES ndern!!!!!!!!!!!!!!!!!!!

FUNCTION TFormLanguagePropertyEditor.Execute(VAR Value;ValueLen:LONGINT):TPropertyEditorReturn;
VAR Form:TForm;
    Info:PLanguageInfo;
    Item:PLanguageItem;
BEGIN
     Form:=TForm(Owner);
     ASM
        PUSH DWORD PTR Form
        CALLN32 Classes.GetLanguages
        MOV Info,EAX
     END;
     List.Duplicates:=dupIgnore;

     IF Info<>NIL THEN
     BEGIN
         Item:=Info^.Items;
         IF Item=NIL THEN List.Add('Default')
         ELSE WHILE Item<>NIL DO
         BEGIN
              List.Add(Item^.Name^);
              Item:=Item^.Next;
         END;
     END
     ELSE List.Add('Default');

     result:=edList;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TImageItemListEditor Class implementation                   บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TImageItemEditor=CLASS(TDialog)
        ImageList:TImageList;
        Image,MaskImage:TImage;
        AddImage,InsertImage,RemoveImage,ReplaceBitmap,ReplaceMask,SaveBitmap,SaveMask:TBitBtn;
        PreviousImage,NextImage:TBitBtn;
        CreateMask,AutoSizeImage:TCheckBox;
        ImageIndex:LONGINT;
        CurrentImage,ImageCount:TLabel;

        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE BtnClicked(Sender:TObject);
        PROCEDURE AutoSizeClick(Sender:TObject);
        FUNCTION GetImage(VAR Bitmap,Mask:TBitmap):BOOLEAN;
        PROCEDURE SaveImage(Bitmap:TBitmap);
     END;

PROCEDURE TImageItemEditor.SaveImage(Bitmap:TBitmap);
VAR Dlg:TSaveDialog;
BEGIN
    If Bitmap.Empty THEN exit;

    Dlg.Create(Nil);
    Dlg.HelpContext := hctxDialogSaveImageListBitmap;
    Dlg.Filter:=LoadNLSStr(SiBitmapFiles)+'|*.bmp|'+LoadNLSStr(SiIconFiles)+'|*.ico';
    IF Dlg.Execute THEN
    BEGIN
         TRY
           Bitmap.SaveToFile(Dlg.FileName);
         EXCEPT
           ErrorBox(LoadNLSStr(SErrorWriting));
         END;
    END;
    Dlg.Destroy;
END;

PROCEDURE TImageItemEditor.AutoSizeClick(Sender:TObject);
BEGIN
     Image.Stretch:=AutoSizeImage.Checked;
     MaskImage.Stretch:=AutoSizeImage.Checked;
END;

FUNCTION TImageItemEditor.GetImage(VAR Bitmap,Mask:TBitmap):BOOLEAN;
VAR Dlg:TOpenDialog;
BEGIN
     Bitmap:=NIL;
     Mask:=NIL;
     result:=False;

     Dlg.Create(Nil);
     Dlg.HelpContext := hctxDialogOpenImageListBitmap;
     Dlg.Caption:=LoadNLSStr(SiSelectABitmap);
     Dlg.Filter:=LoadNLSStr(SiBitmapFiles)+'|*.bmp|'+LoadNLSStr(SiIconFiles)+'|*.ico';

     If Dlg.Execute Then
     Begin
         TRY
            Bitmap.Create;
            Bitmap.LoadFromFile(Dlg.FileName);
         EXCEPT
            ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[Dlg.FileName]));
            Bitmap.Destroy;
            Bitmap:=NIL;
         END;
         IF Bitmap=NIL THEN
         BEGIN
             Dlg.Destroy;
             exit;
         END;

         If CreateMask.Checked Then Mask:=TBitmap(Bitmap.CreateMask(clBlack))
         Else Mask:=NIL;
         result:=True;
     End;
     Dlg.Destroy;
END;

PROCEDURE TImageItemEditor.BtnClicked(Sender:TObject);
Var
    Bitmap,Mask:TBitmap;
LABEL l;
BEGIN
    If Sender=AddImage Then
    Begin
         If GetImage(Bitmap,Mask) Then
         Begin
              ImageList.Add(Bitmap,Mask);
              ImageIndex:=ImageList.Count-1;
              CurrentImage.Caption:=Tostr(ImageIndex);
              ImageCount.Caption:=Tostr(ImageList.Count);
              Image.Bitmap:=Bitmap;
              MaskImage.Bitmap:=Mask;
              Bitmap.Destroy;
              IF Mask<>NIL THEN Mask.Destroy;
         End;
    End
    Else If Sender=PreviousImage Then
    Begin
         If ImageIndex>0 Then
         Begin
             dec(ImageIndex);
l:
             CurrentImage.Caption:=Tostr(ImageIndex);
             If ImageIndex<=ImageList.Count-1 Then
             Begin
                Bitmap.Create;
                ImageList.GetBitmap(ImageIndex,Bitmap);
                Mask.Create;
                ImageList.GetMask(ImageIndex,Mask);
                Image.Bitmap:=Bitmap;
                MaskImage.Bitmap:=Mask;
                Bitmap.Destroy;
                IF Mask<>NIL THEN Mask.Destroy;
             End
             Else
             Begin
                Image.Bitmap:=Nil;
                MaskImage.Bitmap:=Nil;
             End;
         End;
    End
    Else If Sender=NextImage Then
    Begin
         If ImageIndex<ImageList.Count-1 Then
         Begin
             inc(ImageIndex);
             goto l;
         End;
    End
    Else If Sender=SaveBitmap Then
    Begin
        Bitmap.Create;
        ImageList.GetBitmap(ImageIndex,Bitmap);
        SaveImage(Bitmap);
        Bitmap.Destroy;
    End
    Else If Sender=SaveMask Then
    Begin
        Mask.Create;
        ImageList.GetMask(ImageIndex,Mask);
        SaveImage(Mask);
        Mask.Destroy;
    End
    Else If Sender=ReplaceBitmap Then
    Begin
         If GetImage(Bitmap,Mask) Then
         Begin
              IF Mask=NIL THEN
              BEGIN
                   Mask.Create;
                   ImageList.GetMask(ImageIndex,Mask);
                   IF Mask.Empty THEN
                   BEGIN
                        Mask.Destroy;
                        Mask:=NIL;
                   END;
              END;
              ImageList.Replace(ImageIndex,Bitmap,Mask);
              CurrentImage.Caption:=Tostr(ImageIndex);
              Image.Bitmap:=Bitmap;
              MaskImage.Bitmap:=Mask;

              Bitmap.Destroy;
              If Mask<>NIL THEN Mask.Destroy;
         End;
    End
    Else If Sender=ReplaceMask Then
    Begin
         If GetImage(Bitmap,Mask) Then
         Begin
              IF Mask<>NIL THEN Mask.Destroy;
              Mask:=Bitmap;
              Bitmap.Create;
              ImageList.GetBitmap(ImageIndex,Bitmap);
              ImageList.Replace(ImageIndex,Bitmap,Mask);
              CurrentImage.Caption:=Tostr(ImageIndex);
              Image.Bitmap:=Bitmap;
              MaskImage.Bitmap:=Mask;

              Bitmap.Destroy;
              If Mask<>NIL THEN Mask.Destroy;
         End;
    End
    Else If Sender=InsertImage Then
    Begin
         If GetImage(Bitmap,Mask) Then
         Begin
              ImageList.Insert(ImageIndex,Bitmap,Mask);
              CurrentImage.Caption:=Tostr(ImageIndex);
              ImageCount.Caption:=Tostr(ImageList.Count);
              Image.Bitmap:=Bitmap;
              MaskImage.Bitmap:=Mask;
              Bitmap.Destroy;
              If Mask<>Nil Then Mask.Destroy;
         End;
    End
    Else If Sender=RemoveImage Then
    Begin
         If ImageList.Count>0 Then ImageList.Delete(ImageIndex);
         ImageCount.Caption:=Tostr(ImageList.Count);
         If ImageIndex<ImageList.Count Then goto l
         Else
         Begin
            ImageIndex:=ImageList.Count-1;
            If ImageIndex<0 Then ImageIndex:=0;
            goto l;
         End;
    End;
END;


PROCEDURE TImageItemEditor.SetupComponent;
Var ImageBevel,MaskBevel:TBevel;
BEGIN
     Inherited SetupComponent;

     Width:=500;
     Height:=380;
     Caption:=LoadNLSStr(SiEditImageList);

     InsertGroupBox(Self,10,290,310,50,LoadNLSStr(SiStatus));
     InsertLabel(Self,20,300,100,20,LoadNLSStr(SiCurrentImage)+':');
     CurrentImage:=InsertLabel(Self,120,300,40,20,'');
     InsertLabel(Self,170,300,100,20,LoadNLSStr(SiImageCount)+':');
     ImageCount:=InsertLabel(Self,270,300,40,20,'');

     InsertGroupBox(Self,10,230,310,60,LoadNLSStr(SiToolBarOptions));
     CreateMask:=InsertCheckBox(Self,20,240,150,20,LoadNlsStr(SiAutoCreateMask),'');
     AutoSizeImage:=InsertCheckBox(Self,170,240,120,20,LoadNlsStr(SiAutoSizeImage),'');
     AutoSizeImage.Checked:=True;
     AutoSizeImage.OnClick:=AutoSizeClick;

     PreviousImage:=InsertBitBtnNLS(Self,10,20,150,30,bkCustom,SiPreviousImage,0);
     PreviousImage.OnClick:=BtnClicked;
     NextImage:=InsertBitBtnNLS(Self,170,20,150,30,bkCustom,SiNextImage,0);
     NextImage.OnClick:=BtnClicked;

     InsertBitBtnNLS(Self,330,300,150,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(Self,330,265,150,30,bkCancel,SCancelButton,SClickHereToCancel);

     AddImage:=InsertBitBtnNLS(Self,330,230,150,30,bkCustom,SiAddImage,0);
     AddImage.OnClick:=BtnClicked;
     InsertImage:=InsertBitBtnNLS(Self,330,195,150,30,bkCustom,SiInsertImage,0);
     InsertImage.OnClick:=BtnClicked;
     RemoveImage:=InsertBitBtnNLS(Self,330,160,150,30,bkCustom,SiRemoveImage,0);
     RemoveImage.OnClick:=BtnClicked;
     ReplaceBitmap:=InsertBitBtnNLS(Self,330,125,150,30,bkCustom,SiReplaceBitmap,0);
     ReplaceBitmap.OnClick:=BtnClicked;
     ReplaceMask:=InsertBitBtnNLS(Self,330,90,150,30,bkCustom,SiReplaceMask,0);
     ReplaceMask.OnClick:=BtnClicked;
     SaveBitmap:=InsertBitBtnNLS(Self,330,55,150,30,bkCustom,SiSaveBitmap,0);
     SaveBitmap.OnClick:=BtnClicked;
     SaveMask:=InsertBitBtnNLS(Self,330,20,150,30,bkCustom,SiSaveMask,0);
     SaveMask.OnClick:=BtnClicked;

     ImageBevel:=InsertBevel(Self,10,70,150,150,bsBox,bsLowered);
     MaskBevel:=InsertBevel(Self,170,70,150,150,bsBox,bsLowered);

     Image.Create(ImageBevel);
     Image.Stretch:=True;
     Image.Left:=2;
     Image.Bottom:=2;
     Image.Width:=146;
     Image.Height:=146;
     Image.Parent:=ImageBevel;

     MaskImage.Create(MaskBevel);
     MaskImage.Stretch:=True;
     MaskImage.Left:=2;
     MaskImage.Bottom:=2;
     MaskImage.Width:=146;
     MaskImage.Height:=146;
     MaskImage.Parent:=MaskBevel;
END;

FUNCTION TImageItemListEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR  Dlg:TImageItemEditor;
BEGIN
     Result := peNoEditor;  {wird immer sofort aktualisiert!}
     IF not (ClassToEdit IS TImageItemList) THEN exit;

     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogImageListPropertyEditor;
     Dlg.ImageList.Create(Nil);
     Dlg.ImageList.AddImages(TImageItemList(ClassToEdit).ImageList);

     Dlg.ImageIndex:=0;
     If Dlg.ImageList.Count>0 Then
     Begin
          Dlg.Image.Bitmap:=PImageItem(Dlg.ImageList.BitmapList[0])^.Bitmap;
          Dlg.MaskImage.Bitmap:=PImageItem(Dlg.ImageList.BitmapList[0])^.Mask;
     End;
     Dlg.CurrentImage.Caption:=Tostr(Dlg.ImageIndex);
     Dlg.ImageCount.Caption:=Tostr(Dlg.ImageList.Count);

     Dlg.Execute;
     If Dlg.ModalResult=cmOk Then
     Begin
          TImageItemList(ClassToEdit).ImageList.Clear;
          TImageItemList(ClassToEdit).ImageList.AddImages(Dlg.ImageList);
     End;
     Dlg.ImageList.Destroy;

     Dlg.Destroy;
     Result := peOk;  {wird immer sofort aktualisiert!}
END;


BEGIN
     AddClassPropertyEditor(TBitmap,TBitmapPropertyEditor);
     AddClassPropertyEditor(TFont,TFontPropertyEditor);
     AddClassPropertyEditor(TStrings,TStringsPropertyEditor);
     AddClassPropertyEditor(TIcon,TIconPropertyEditor);
     AddClassPropertyEditor(TStatusPanels,TStatusPanelsPropertyEditor);
     AddClassPropertyEditor(THeaderSections,THeaderSectionsPropertyEditor);
     AddClassPropertyEditor(TPageAccess,TPageAccessEditor);
     AddClassPropertyEditor(TImageItemList,TImageItemListEditor);

     AddPropertyEditor(TMCIDevice,'FileName',TMCIFileNamePropertyEditor);
     AddPropertyEditor(TMediaPlayer,'FileName',TMediaPlayerFileNamePropertyEditor);
     AddPropertyEditor(TForm,'Language',TFormLanguagePropertyEditor);
     AddPropertyEditor(TOpenDialog,'Filter',TFilterPropertyEditor);
     AddPropertyEditor(TSystemOpenSaveDialog,'Filter',TFilterPropertyEditor);
     AddPropertyEditor(TFilterComboBox,'Filter',TFilterPropertyEditor);
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Jul-04  WD         Umbau der MultiMedia-Komponenten
  24-Mar-06  WD         TStringsPropertyEditor: Dialog vergroessert
}
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     WDSibyl Visual Development Environment                               บ
 บ                                                                          บ
 บ     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      บ
 บ     Copyright (C) 2005..  Ing. Wolfgang Draxler, All rights reserved.    บ
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

UNIT Navigate;

INTERFACE

USES SysUtils,Color,Classes,Graphics,Forms,Buttons,
     uString, uList,
     OutLine,StdCtrls,ExtCtrls, Chart,
     FileCtrl,ComCtrls,Dialogs,TabCtrls,Grids,
     ToolsApi,ListView,
     ColorGrd,DualList,CheckLB,XplorBtn,EditList,DdeMan,Mask,Calendar,
     Clocks,CoolBar,BmpList,DirOutLn,GlyphBtn,Gradient,Hints,Led,
     ScktComp,Seven,Spin, Messages, Menus,
     DBBase, DBCtrls;

Uses uEMailClient,
     uPorts,
     uColorWheel;

Uses Consts,Projects,Sib_Ctrl,Sib_Prj,BaseForm,Sib_Comp;

{$IFDEF OS2}
uses INet;
{$ENDIF}

TYPE
    TScrollButton=CLASS(TXPLButton)
      PRIVATE
         FAlign:BOOLEAN;  {left/right one}
      PUBLIC
         PROCEDURE Redraw(CONST rec:TRect);OVERRIDE;
    END;


    TArrowSwitchButton=CLASS(TXPLButton)
      PROTECTED
         PROCEDURE DrawBitmap(Bitmap:TBitmap;Down:BOOLEAN);OVERRIDE;
    END;


    TNavigatorSwitchButton=CLASS(TXPLButton)
      PUBLIC
         ComponentClass:TComponentClass;
         WasDoubleClick:BOOLEAN;
         PROCEDURE MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE DrawFrame(Down:BOOLEAN);OVERRIDE;
    END;


    TNavigator=CLASS(TControl)
      PRIVATE
         FieldCount:LONGINT;
         FLeftScroller:TScrollButton;
         FRightScroller:TScrollButton;
         ArrowSwitch:TArrowSwitchButton;
         ArrowUp,ArrowDown:TBitmap;
         FSelectedComponent:TNavigatorSwitchButton;
         TabSet:TTabSet;
         NoteBook:TNoteBook;
         FirstBtnIndex:LONGINT;
      PRIVATE
         PROCEDURE EvArrowClick(Sender:TObject);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE UpdateScrollers;
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE EvPageSelected(Sender:TObject);
         PROCEDURE EvFontChange(Sender:TObject);
         PROCEDURE EvNavigateRScroll(Sender:TObject);
         PROCEDURE EvNavigateLScroll(Sender:TObject);
         PROCEDURE EvNavigateCompClicked(Sender:TObject);
         PROCEDURE SetArrowDown(Value:BOOLEAN);
      PUBLIC
         MultiInsertMode:BOOLEAN;
         PROCEDURE EnableArrow;
         FUNCTION GetSelectedComponent:TComponentClass;
    END;


    TComponentViewer=CLASS(TSibylForm)
         FBitmapListBox:TBitmapListBox;
         FNameEntry:TEdit;
         nested:BOOLEAN;
         PROCEDURE SetupComponent;OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         FUNCTION  GetClassFromName(Name:STRING):TComponentClass;
         PROCEDURE ItemFocused(Sender:TObject;Index:LONGINT);
         PROCEDURE ItemSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE EntryChangeEvent(Sender:TObject);
         PROCEDURE UpdateListBox;
         PROCEDURE AddToForm(VAR Msg:TMessage); message cmOk;
         PROCEDURE ClearListBox;                
         PROCEDURE FillListBox;
    END;


PROCEDURE InitNavigator(AForm:TForm);
FUNCTION GetBitmapFromClass(ReferenceComponent:TComponent;aClass:TComponentClass):TBitmap;
PROCEDURE InitComponentViewer;
PROCEDURE SetupNavigatorPages;
PROCEDURE ConfigurePalette;


VAR Navigator:TNavigator;
    ComponentViewer:TComponentViewer;

VAR AutomaticComponentInsert:PROCEDURE(Component:TComponentClass);

IMPLEMENTATION

Uses MMedia, uMediaPlayer, uMMDevices;

CONST NBLeftIndent  = 10 + NavigatorButtonSize + 10 + 12;
      NBRightIndent = 25;

      cStrLibrary = '[Library]';

TYPE
    TConfigurePaletteDlg=CLASS(TDialog)
       PageListBox:TListBox;
       ComponentListBox:TBitmapListBox;
       AddBit,RenameBit,DeleteBit:TBitBtn;
       PROCEDURE SetupComponent;OVERRIDE;
       PROCEDURE PageItemFocused(Sender:TObject;Index:LONGINT);
       PROCEDURE ComponentItemFocused(Sender:TObject;Index:LONGINT);
       PROCEDURE ComponentCanDrag(Sender:TObject;X,Y:LONGINT;VAR Accept:BOOLEAN);
       PROCEDURE PageDragOver(Sender:TObject;Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);
       PROCEDURE PageDragDrop(Sender:TObject;Source:TObject;X,Y:LONGINT);
       PROCEDURE ComponentDragOver(Sender:TObject;Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);
       PROCEDURE ComponentDragDrop(Sender:TObject;Source:TObject;X,Y:LONGINT);
       PROCEDURE DeleteClicked(Sender:TObject);
       PROCEDURE AddClicked(Sender:TObject);
       PROCEDURE RenameClicked(Sender:TObject);
    END;


PROCEDURE TConfigurePaletteDlg.RenameClicked(Sender:TObject);
VAR Dlg:TDialog;
    Page,Page1:PNavigatorPageRec;
    s,s1,s2:STRING;
    t:LONGINT;
    Edit:TEdit;
BEGIN
     IF PageListBox.ItemIndex=-1 THEN exit;
     Page:=NavigatorPages.Items[PageListBox.ItemIndex];

     Dlg.Create(SELF);
     Dlg.HelpContext := hctxDialogRenamePalettePage;
     Dlg.Width:=350;
     Dlg.Height:=160;
     Dlg.Caption:=LoadNLSStr(SiRenamePalettePage);
     InsertLabelNLS(Dlg,10,100,320,20,SiEnterPageName);
     Edit:=InsertEdit(Dlg,10,70,320,20,'','');
     Edit.Caption:=Page^.Name;
     Edit.Focus;
     InsertBitBtnNLS(Dlg,10,15,120,30,bkOk,SiRename,0);
     InsertBitBtnNLS(Dlg,140,15,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(Dlg,240,15,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);

     Dlg.ShowModal;
     IF Dlg.ModalResult=cmOk THEN
     BEGIN
          s:=Edit.Caption;
          Dlg.Destroy;
          s1:=s;
          UpcaseStr(s1);
          FOR t:=0 TO NavigatorPages.Count-1 DO
          BEGIN
               Page1:=NavigatorPages.Items[t];
               s2:=Page1^.Name;
               UpcaseStr(s2);
               IF s1=s2 THEN IF Page1<>Page THEN
               BEGIN
                    ErrorBox(LoadNLSStr(SiPageAlreadyExists));
                    exit;
               END;
          END;

          Page^.Name:=s;
          PageListBox.Items.Strings[PageListBox.ItemIndex]:=s;
     END
     ELSE Dlg.Destroy;
END;

PROCEDURE TConfigurePaletteDlg.AddClicked(Sender:TObject);
VAR Dlg:TDialog;
    Edit:TEdit;
    s:STRING;
    s1,s2:STRING;
    Page:PNavigatorPageRec;
    t:LONGINT;
    LibIndex:LONGINT;
BEGIN
     Dlg.Create(SELF);
     Dlg.HelpContext := hctxDialogNewPalettePage;
     Dlg.Width:=350;
     Dlg.Height:=160;
     Dlg.Caption:=LoadNLSStr(SiNewPalettePage);
     InsertLabelNLS(Dlg,10,100,320,20,SiEnterNewPageName);
     Edit:=InsertEdit(Dlg,10,70,320,20,'','');
     Edit.Focus;
     InsertBitBtnNLS(Dlg,10,15,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(Dlg,110,15,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(Dlg,210,15,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);

     Dlg.ShowModal;
     IF Dlg.ModalResult=cmOk THEN
     BEGIN
          s:=Edit.Caption;
          Dlg.Destroy;
          IF ((s='')OR(not (upcase(s[1]) IN ['A'..'Z']))) THEN ErrorBox(LoadNLSStr(SiInvalidPageName))
          ELSE
          BEGIN
               s1:=s;
               UpcaseStr(s1);
               LibIndex:=-1;
               FOR t:=0 TO NavigatorPages.Count-1 DO
               BEGIN
                    Page:=NavigatorPages.Items[t];
                    IF Page^.Name=cStrLibrary THEN LibIndex:=t;
                    s2:=Page^.Name;
                    UpcaseStr(s2);
                    IF s1=s2 THEN
                    BEGIN
                         ErrorBox(LoadNLSStr(SiPageAlreadyExists));
                         exit;
                    END;
               END;
               IF LibIndex=-1 THEN exit;
               New(Page);
               Page^.Name:=s;
               Page^.Installed:=TRUE;
               Page^.Components.Create;
               NavigatorPages.Insert(LibIndex,Page);
               PageListBox.Items.Insert(LibIndex,s);
          END;
     END
     ELSE Dlg.Destroy;
END;

PROCEDURE TConfigurePaletteDlg.DeleteClicked(Sender:TObject);
VAR
    Page:PNavigatorPageRec;
    Entry:PNavigatorEntryRec;
BEGIN
     IF ComponentListBox.Items.Count=0 THEN //erase page
     BEGIN
          IF PageListBox.ItemIndex=-1 THEN exit;
          Page:=NavigatorPages.Items[PageListBox.ItemIndex];
          IF Page^.Components.Count<>0 THEN exit;
          IF MessageBox(FmtLoadNLSStr(SiRemovePage,[Page^.Name]),mtConfirmation,mbYesNoCancel)=mrYes THEN
          BEGIN
               NavigatorPages.Remove(Page);
               Page^.Components.Destroy;
               Dispose(Page);
               PageListBox.Items.Delete(PageListBox.ItemIndex);
               PageListBox.ItemIndex:=0;
          END;
     END
     ELSE //remove component
     BEGIN
          IF ((ComponentListBox.ItemIndex=-1)OR(PageListBox.ItemIndex=-1)) THEN exit;
          Page:=NavigatorPages.Items[PageListBox.ItemIndex];
          Entry:=Page^.Components[ComponentListBox.ItemIndex];
          Page^.Components.Remove(Entry);
          Dispose(Entry);
          ComponentListBox.Items.Delete(ComponentListBox.ItemIndex);
          DeleteBit.Enabled := Page^.Components.Count=0;
          RenameBit.Enabled := TRUE;
     END;
END;

PROCEDURE TConfigurePaletteDlg.PageDragOver(Sender:TObject;Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);
VAR Index:LONGINT;
BEGIN
     IF Source=ComponentListBox THEN
     BEGIN
          Index:=PageListBox.ItemAtPos(Point(X,Y),TRUE);
          IF ((Index=PageListBox.Items.Count-1)OR(Index=PageListBox.ItemIndex)) THEN Index:=-1; //not for [Library] and actual
     END
     ELSE Index:=-1;
     Accept:=Index<>-1;
END;


PROCEDURE TConfigurePaletteDlg.PageDragDrop(Sender:TObject;Source:TObject;X,Y:LONGINT);
VAR Index:LONGINT;
    EntryToCopy:PNavigatorEntryRec;
    PageToCopy:PNavigatorPageRec;
    TargetPage:PNavigatorPageRec;
    TargetEntry:PNavigatorEntryRec;
BEGIN
     Index:=-1;
     IF Source=ComponentListBox THEN
     BEGIN
          Index:=PageListBox.ItemAtPos(Point(X,Y),TRUE);
          IF ((Index=PageListBox.Items.Count-1)OR(Index=PageListBox.ItemIndex)) THEN Index:=-1; //not for [Library] and actual
          IF Index<>-1 THEN
          BEGIN
               PageToCopy:=NavigatorPages.Items[PageListBox.ItemIndex];
               EntryToCopy:=PageToCopy^.Components.Items[ComponentListBox.ItemIndex];

               TargetPage:=NavigatorPages.Items[Index];
               New(TargetEntry);
               TargetEntry^:=EntryToCopy^;
               TargetEntry^.Installed:=TRUE;
               TargetPage^.Components.Add(TargetEntry);
          END;
     END;
END;

PROCEDURE TConfigurePaletteDlg.ComponentDragOver(Sender:TObject;Source:TObject;X,Y:LONGINT;State:TDragState;
                                                 VAR Accept:BOOLEAN);
VAR Index:LONGINT;
BEGIN
     IF ((Source=ComponentListBox)AND(PageListBox.ItemIndex<>PageListBox.Items.Count-1)) THEN //not for [Library]
     BEGIN
          Index:=ComponentListBox.ItemAtPos(Point(X,Y),TRUE);
          IF ((Index=-1)OR(Index=ComponentListBox.ItemIndex)) THEN Index:=-1;
     END
     ELSE Index:=-1;
     Accept:=Index<>-1;
END;

PROCEDURE TConfigurePaletteDlg.ComponentDragDrop(Sender:TObject;Source:TObject;X,Y:LONGINT);
VAR Index:LONGINT;
    TargetPage:PNavigatorPageRec;
    TargetEntry:PNavigatorEntryRec;
    Bitmap:TBitmap;
BEGIN
     Index:=-1;
     IF ((Source=ComponentListBox)AND(PageListBox.ItemIndex<>PageListBox.Items.Count-1)) THEN //not for [Library]
     BEGIN
          Index:=ComponentListBox.ItemAtPos(Point(X,Y),TRUE);
          IF Index=ComponentListBox.ItemIndex THEN Index:=-1; //not for [Library] and actual

          IF Index<>-1 THEN
          BEGIN
               TargetPage:=NavigatorPages.Items[PageListBox.ItemIndex];
               TargetEntry:=TargetPage^.Components.Items[ComponentListBox.ItemIndex];
               ComponentListBox.BeginUpdate;

               ComponentListBox.Items.Delete(ComponentListBox.ItemIndex);
               Bitmap.Create;
               IF TargetEntry^.BmpButtonId<>0 THEN Bitmap.LoadFromResourceId(TargetEntry^.BmpButtonId)
               ELSE IF TargetEntry^.BmpButtonName<>'' THEN Bitmap.LoadFromResourceName(TargetEntry^.BmpButtonName)
               ELSE GetBitmapFromCompLib(Bitmap,TargetEntry^.ComponentClass); //Get Bitmap from COMPLIB.DLL
               ComponentListBox.InsertBitmap(Index,TargetEntry^.HelpText,Bitmap);

               TargetPage^.Components.Remove(TargetEntry);
               TargetPage^.Components.Insert(Index,TargetEntry);

               ComponentListBox.EndUpdate;
          END;
     END;
END;

PROCEDURE TConfigurePaletteDlg.ComponentCanDrag(Sender:TObject;X,Y:LONGINT;
                                                VAR Accept:BOOLEAN);
VAR Index:LONGINT;
BEGIN
     Index:=ComponentListBox.ItemAtPos(Point(X,Y),TRUE);
     IF Index<>-1 THEN ComponentListBox.ItemIndex:=Index;
     Accept:=Index<>-1;
END;

PROCEDURE TConfigurePaletteDlg.ComponentItemFocused(Sender:TObject;Index:LONGINT);
BEGIN
     RenameBit.Enabled := FALSE;
     IF PageListBox.ItemIndex<>PageListBox.Items.Count-1
     THEN DeleteBit.Enabled := TRUE; //not for [Library]
END;

PROCEDURE TConfigurePaletteDlg.PageItemFocused(Sender:TObject;Index:LONGINT);
VAR PageRec:PNavigatorPageRec;
    t:LONGINT;
    Entry:PNavigatorEntryRec;
    Bitmap:TBitmap;
BEGIN
     IF Index=-1 THEN exit;
     PageRec:=NavigatorPages.Items[Index];
     ComponentListBox.BeginUpdate;
     ComponentListBox.Clear;
     ComponentListBox.Sorted:=(PageRec^.Name=cStrLibrary);  // Sortieren der Komponenten auf der Libraryseite

     FOR t:=0 TO PageRec^.Components.Count-1 DO
     BEGIN
          Entry:=PageRec^.Components[t];
          Bitmap.Create;
          IF Entry^.BmpButtonId<>0 THEN Bitmap.LoadFromResourceId(Entry^.BmpButtonId)
          ELSE IF Entry^.BmpButtonName<>'' THEN Bitmap.LoadFromResourceName(Entry^.BmpButtonName)
          ELSE GetBitmapFromCompLib(Bitmap,Entry^.ComponentClass); //Get Bitmap from COMPLIB.DLL
          ComponentListBox.AddBitmap(Entry^.HelpText,Bitmap);
     END;
     ComponentListBox.EndUpdate;

     IF ((PageRec^.Components.Count=0)AND(Index<>PageListBox.Items.Count-1))
     THEN DeleteBit.Enabled := TRUE
     ELSE DeleteBit.Enabled := FALSE;
     IF Index<>PageListBox.Items.Count-1 THEN RenameBit.Enabled := TRUE  //not for [Library]
     ELSE RenameBit.Enabled := FALSE;
END;

PROCEDURE TConfigurePaletteDlg.SetupComponent;
VAR t:LONGINT;
    PageRec:PNavigatorPageRec;
    Lab:TLabel;
BEGIN
  Inherited SetupComponent;

  Caption:=LoadNLSStr(SiConfigureComponentPalette);
  ClientWidth:=500;
  Height:=420;
  InsertLabelNLS(SELF,10,365,240,20,SiAvailablePages);
  InsertLabelNLS(SELF,295,365,240,20,SiAvailableComponents);
  Lab := InsertLabel(SELF,175,340,120,20,'< '+LoadNLSStr(SiDragItems)+' >');
  Lab.Alignment := taCenter;

  PageListBox:=InsertListBox(SELF,10,65,165,290,'');
  PageListBox.Style:=lbOwnerDrawFixed;
  PageListBox.ItemHeight:=PageListBox.Font.Height+1;
  PageListBox.OnItemFocus:=PageItemFocused;
  PageListBox.OnDragOver:=PageDragOver;
  PageListBox.OnDragDrop:=PageDragDrop;
  PageListBox.ShowDragRects:=TRUE;
  PageListBox.Focus;
  ComponentListBox:=InsertBitmapListBox(SELF,295,65,185,290,25);
  ComponentListBox.OnItemFocus:=ComponentItemFocused;
  ComponentListBox.DragMode:=dmAutomatic;
  ComponentListBox.OnCanDrag:=ComponentCanDrag;
  ComponentListBox.OnDragOver:=ComponentDragOver;
  ComponentListBox.OnDragDrop:=ComponentDragDrop;
  ComponentListBox.ShowDragRects:=TRUE;

  IF NavigatorPages<>NIL THEN
    FOR t:=0 TO NavigatorPages.Count-1 DO
      BEGIN
        PageRec:=NavigatorPages.Items[t];
        {IF PageRec^.Name<>'' THEN} //PageListBox muแ mit NavigatorPages bereinstimmen
        PageListBox.Items.Add(PageRec^.Name);
      END;

  AddBit:=InsertBitBtnRes(SELF,180,150,110,30,0,cmNull,LoadNLSStr(SiAdd),'');
  AddBit.OnClick:=AddClicked;
  RenameBit:=InsertBitBtnRes(SELF,180,190,110,30,0,cmNull,LoadNLSStr(SiRename),'');
  RenameBit.OnClick:=RenameClicked;
  DeleteBit:=InsertBitBtnRes(SELF,180,230,110,30,0,cmNull,LoadNLSStr(SiDelete),'');
  DeleteBit.OnClick:=DeleteClicked;

  InsertBitBtnNLS(SELF,10,15,90,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(SELF,110,15,90,30,bkCancel,SCancelButton,SClickHereToCancel);
  InsertBitBtnNLS(SELF,210,15,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


PROCEDURE CopyNavigatorPages(VAR CopyTo:TList);
VAR  t,t1:LONGINT;
     PageRec,PageNew:PNavigatorPageRec;
     PageEntry,EntryNew:PNavigatorEntryRec;
BEGIN
     IF NavigatorPages <> NIL THEN
     BEGIN
          FOR t:=0 TO NavigatorPages.Count-1 DO
          BEGIN
               PageRec:=NavigatorPages.Items[t];
               IF CopyTo=NIL THEN CopyTo.Create;
               New(PageNew);
               PageNew^:=PageRec^;
               PageNew^.Components.Create;

               FOR t1:=0 TO PageRec^.Components.Count-1 DO
               BEGIN
                    PageEntry:=PageRec^.Components.Items[t1];
                    New(EntryNew);
                    EntryNew^:=PageEntry^;
                    PageNew^.Components.Add(EntryNew);
               END;

               CopyTo.Add(PageNew);
          END;
     END;
END;

PROCEDURE ConfigurePalette;
VAR Dlg:TConfigurePaletteDlg;
    SavePages,Temp:TList;
BEGIN
  Application.LogWriteln('Navigate.ConfigurePalette');
  SavePages:=NIL;
  CopyNavigatorPages(SavePages);
  {Swap}
  Temp:=SavePages;
  SavePages:=NavigatorPages;
  NavigatorPages:=Temp;

  Dlg.Create(NIL);
  Dlg.HelpContext := hctxDialogConfigurePalette;
  Dlg.Execute;

  IF Dlg.ModalResult=cmOk THEN
    BEGIN
      Dlg.Destroy;
      Temp:=NavigatorPages;
      NavigatorPages:=SavePages;
      DestroyNavigatorPages;
      NavigatorPages:=Temp;

      WriteSibylNav;
      IF Navigator <> NIL THEN
        BEGIN
          RemoveNavigatorProc;
          InitToolBarsProc;
        END;
    END
  ELSE
    BEGIN
      DestroyNavigatorPages;
      NavigatorPages:=SavePages;
      Dlg.Destroy;
    END;
END;



PROCEDURE TScrollButton.Redraw(CONST rec:TRect);
VAR  rc1:TRect;
BEGIN
     Inherited Redraw(rec);

     rc1 := ClientRect;
     IF Down THEN
     BEGIN
          inc(rc1.Left);
          dec(rc1.Bottom);
     END;

     IF SELF = Navigator.FLeftScroller THEN
     BEGIN
          IF Enabled THEN Canvas.Pen.Color := clBlack
          ELSE Canvas.Pen.Color := clDkGray;
          Canvas.Polygon([Point(rc1.Left+7,rc1.Bottom+4),
                          Point(rc1.Left+3,rc1.Bottom+14),
                          Point(rc1.Left+7,rc1.Top-5)]);
     END;
     IF SELF = Navigator.FRightScroller THEN
     BEGIN
          IF Enabled THEN Canvas.Pen.Color := clBlack
          ELSE Canvas.Pen.Color := clDkGray;
          Canvas.Polygon([Point(rc1.Left+3,rc1.Bottom+4),
                          Point(rc1.Left+7,rc1.Bottom+14),
                          Point(rc1.Left+3,rc1.Top-5)]);
     END;
END;



PROCEDURE SetupNavigatorPages;
VAR dummy:PNavigatorPageRec;
    entry:PNavigatorEntryRec;
    aComponentClass:TComponentClass;
    f:FILE;
    nav:STRING;
    t,count,t1,count1:LONGINT;
    Lib:PNavigatorPageRec;
    LibRec:PNavigatorEntryRec;
    FailedList:TStringList;
    idx:LONGINT;
    countread:LONGWORD;

  FUNCTION AddItem(Item:TComponentClass;ButtonId:LONGWORD;Std,Installed:BOOLEAN):PNavigatorEntryRec;
  VAR NavigatorRec:PNavigatorEntryRec;
  BEGIN
       new(NavigatorRec);
       NavigatorRec^.ComponentClass:=Item;
       NavigatorRec^.HelpText:=Item.ClassName;
       NavigatorRec^.BmpButtonId:=ButtonId;
       NavigatorRec^.BmpButtonName:='';
       NavigatorRec^.Std:=Std;
       NavigatorRec^.Installed:=Installed;
       NavigatorRec^.ComponentUnit:=Item.ClassUnit;
       dummy^.Components.Add(NavigatorRec);
       result:=NavigatorRec;
  END;

  PROCEDURE AddItemLib(Item:TComponentClass;ButtonId:LONGWORD;Std,Installed:BOOLEAN);
  BEGIN
       New(LibRec);
       LibRec^:=AddItem(Item,ButtonId,Std,Installed)^;
       IF LibRec^.ComponentClass IS TIExpert THEN Dispose(LibRec)
       ELSE Lib^.Components.Add(LibRec);
  END;

LABEL l,init;
BEGIN
     Application.LogWriteln('SetupNavigatorPages: Start');
     IF NavigatorPages <> NIL THEN exit;    {already created}

     FailedList := NIL;
     NavigatorPages.Create;

     {!! freigeben, da sich beim Reload der CompLib die Zeiger auf die Klassen ndern}
     FreeRegisteredClasses;
     RegisterDefaultClassesProc;

     LoadCompLib;

     nav := GetNAVName;
     Application.LogWriteln('SetupNavigatorPages: nav='+nav);
     IF nav = '' THEN exit; {User will keine CompLib}

     assign(f,nav);
     filemode:=fmInput;
     {$i-}
     reset(f,1);
     {$i+}
     filemode:=fmInOut;
     IF InOutRes<>0 THEN
     BEGIN
init:
          Application.LogWriteln('SetupNavigatorPages: Init');
          new(Lib);
          Lib^.Name:='[Library]';
          Lib^.Installed:=FALSE;
          Lib^.Components.Create;

          //Sibyl.NAV not found -> create new
          FOR t:=1 TO MaxStdNavigatorContents DO
          BEGIN
               new(dummy);
               dummy^.Name:=LoadNLSStr(StdNavigatorNames[t]);  //a page
               dummy^.Installed:=TRUE;
               dummy^.Components.Create;
               NavigatorPages.Add(dummy);
               CASE t OF
                 1: {Standard}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Standard');
                      AddItemLib(TMainMenu,1240,TRUE,TRUE);
                      AddItemLib(TPopUpMenu,1292,TRUE,TRUE);
                      AddItemLib(TButton,1211,TRUE,TRUE);
                      AddItemLib(TCheckBox,1212,TRUE,TRUE);
                      AddItemLib(TRadioButton,1225,TRUE,TRUE);
                      AddItemLib(TScrollBar,1218,TRUE,TRUE);
                      AddItemLib(TEdit,1214,TRUE,TRUE);
                      AddItemLib(TListBox,1221,TRUE,TRUE);
                      AddItemLib(TComboBox,1213,TRUE,TRUE);
                      AddItemLib(TMemo,1222,TRUE,TRUE);
                      AddItemLib(TGroupBox,1217,TRUE,TRUE);
                      AddItemLib(TRadioGroup,1215,TRUE,TRUE);
                      AddItemLib(TCheckGroup,1336,TRUE,TRUE);
                      AddItemLib(TLabel,1229,TRUE,TRUE);
                      AddItemLib(TScrollBox,1303,TRUE,TRUE);
                   END;
                 2: {Additional / Zusatz}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Zusatz');
                      AddItemLib(TBitBtn,1235,TRUE,TRUE);
                      AddItemLib(TAnimatedButton,1220,TRUE,TRUE);
                      AddItemLib(TSpeedButton,1243,TRUE,TRUE);
                      AddItemLib(TMaskEdit,1304,TRUE,TRUE);
                      AddItemLib(TImage,1210,TRUE,TRUE);
                      AddItemLib(TShape,1287,TRUE,TRUE);
                      AddItemLib(TPaintBox,1290,TRUE,TRUE);
                      AddItemLib(TBitmapListBox,1254,TRUE,TRUE);
                      AddItemLib(TToolBar,1237,TRUE,TRUE);
                      AddItemLib(TProgressBar,1238,TRUE,TRUE);
                      AddItemLib(TGauge,1335,true, true);
                      AddItemLib(TUpDown,1288,TRUE,TRUE);
                      AddItemLib(TOutline,1226,TRUE,TRUE);
                      AddItemLib(TListView,1219,TRUE,TRUE);
                      AddItemLib(TBevel,1245,TRUE,TRUE);
                      AddItemLib(TPanel,1242,TRUE,TRUE);
                      AddItemLib(TStringGrid,1244,TRUE,TRUE);
                      AddItemLib(tEditDate,1325,true,true);
                      AddItemLib(tOKCancelButton, 1328, true, true);
                   END;
                 3:  {Extra}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Extra');
                      AddItemLib(TTabSet,1223,TRUE,TRUE);
                      AddItemLib(TNoteBook,1224,TRUE,TRUE);
                      AddItemLib(TTabbedNoteBook,1228,TRUE,TRUE);
                      AddItemLib(TValueSet,1231,TRUE,TRUE);
                      AddItemLib(TTrackBar,1289,TRUE,TRUE);
                      AddItemLib(THeaderControl,1295,TRUE,TRUE);
                      AddItemLib(TStatusBar,1293,TRUE,TRUE);
                      AddItemLib(TSizeBorder,1294,TRUE,TRUE);
                      AddItemLib(TDrawGrid,1296,TRUE,TRUE);
                      AddItemLib(TImageList,1301,TRUE,TRUE);
                      AddItemLib(TCustomHint,1321,TRUE,TRUE);
                      AddItemLib(TBalloonHint,1322,TRUE,TRUE);
                      AddItemLib(TSpinButton,1288,TRUE,TRUE);
                      AddItemLib(TSpinEdit,1214,TRUE,TRUE);
                      AddItemLib(tMultiColumnList, 1333, true, true);
                   END;
                 4:  {Database / Datenbank}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Datenbank');
                      AddItemLib(TTable,1270,TRUE,TRUE);
                      AddItemLib(TQuery,1271,TRUE,TRUE);
                      AddItemLib(TDataSource,1272,TRUE,TRUE);
                      AddItemLib(TStoredProc,1302,TRUE,TRUE);
                      AddItemLib(TDBGrid,1273,TRUE,TRUE);
                      AddItemLib(TDBEdit,1274,TRUE,TRUE);
                      AddItemLib(TDBCheckBox,1275,TRUE,TRUE);
                      AddItemLib(TDBRadioGroup,1276,TRUE,TRUE);
                      AddItemLib(TDBText,1277,TRUE,TRUE);
                      AddItemLib(TDBImage,1278,TRUE,TRUE);
                      AddItemLib(TDBListBox,1279,TRUE,TRUE);
                      AddItemLib(TDBComboBox,1280,TRUE,TRUE);
                      AddItemLib(TDBMemo,1282,TRUE,TRUE);
                      AddItemLib(TDBNavigator,1281,TRUE,TRUE);
//                      AddItemLib(TDBPieChart,1312,TRUE,TRUE);
//                      AddItemLib(TDBBarChart,1314,TRUE,TRUE);
                   END;
                 5:  {Multimedia}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Multimedia');
                      AddItemLib(TMCIDevice,1264,TRUE,TRUE);
                      AddItemLib(TAudioDevice,1261,TRUE,TRUE);
                      AddItemLib(TCDDevice,1262,TRUE,TRUE);
                      AddItemLib(TVideoDevice,1260,TRUE,TRUE);
                      AddItemLib(TVideoWindow,1239,TRUE,TRUE);
                      AddItemLib(TMediaPlayer,1241,TRUE,TRUE);
                      AddItemLib(TVolumeControl,1263,TRUE,TRUE);
                   END;
                 6:  {Dialogs}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Dialog');
                      AddItemLib(TSystemOpenDialog,1299,TRUE,TRUE);
                      AddItemLib(TSystemSaveDialog,1300,TRUE,TRUE);
                      AddItemLib(TOpenDialog,1246,TRUE,TRUE);
                      AddItemLib(TSaveDialog,1247,TRUE,TRUE);
                      AddItemLib(TCreateDirDialog,1266,TRUE,TRUE);
                      AddItemLib(TChangeDirDialog,1255,TRUE,TRUE);
                      AddItemLib(TFindDialog,1249,TRUE,TRUE);
                      AddItemLib(TReplaceDialog,1248,TRUE,TRUE);
                      AddItemLib(TColorDialog,1250,TRUE,TRUE);
                      AddItemLib(TFontDialog,1251,TRUE,TRUE);
                      AddItemLib(TPrintDialog,1297,TRUE,TRUE);
                      AddItemLib(TPrinterSetupDialog,1298,TRUE,TRUE);
                      AddItemLib(tUserPasswordDialog, 1334, true, true);
                   END;
                 7:  {System}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: System');
                      AddItemLib(TFileListBox,1257,TRUE,TRUE);
                      AddItemLib(TDirectoryListBox,1259,TRUE,TRUE);
                      AddItemLib(TDriveComboBox,1258,TRUE,TRUE);
                      AddItemLib(TFilterComboBox,1265,TRUE,TRUE);
                      AddItemLib(TTimer,1252,TRUE,TRUE);
                      AddItemLib(TDdeServerConv,1283,TRUE,TRUE);
                      AddItemLib(TDdeServerItem,1284,TRUE,TRUE);
                      AddItemLib(TDdeClientConv,1285,TRUE,TRUE);
                      AddItemLib(TDdeClientItem,1286,TRUE,TRUE);
                      AddItemLib(tSerialPort,1329,true,true);
                      AddItemLib(tEditFileName, 1332, true, true);
                      {$IFDEF OS2}
                      AddItemLib(tJoystickPort,1326,true,true);
                      {$ENDIF}
                   END;
                 8:  {Internet}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Internet');
                      AddItemLib(TServerSocket,1306,TRUE,TRUE);
                      AddItemLib(TClientSocket,1305,TRUE,TRUE);
                      {$IFDEF OS2}
                      AddItemLib(THTTPBrowser,1307,TRUE,TRUE);
                      AddItemLib(TFTP,1308,TRUE,TRUE);
                      AddItemLib(TTCP,1309,TRUE,TRUE);
                      AddItemLib(TUDP,1310,TRUE,TRUE);
                      {$ENDIF}
                      AddItemLib(tPop3Client, 1327, true, true);
                   END;
                 9:  {Samples}
                   BEGIN
                      Application.LogWriteln('SetupNavigatorPages: Samples');
                      AddItemLib(TColorGrid,1230,TRUE,TRUE);
                      AddItemLib(TDualList,1216,TRUE,TRUE);
                      AddItemLib(TCheckListBox,1291,TRUE,TRUE);
                      AddItemLib(TExplorerButton,1233,TRUE,TRUE);
                      AddItemLib(TEditListBox,1234,TRUE,TRUE);
                      AddItemLib(TCalendar,1315,TRUE,TRUE);
                      AddItemLib(TAnalogClock,1316,TRUE,TRUE);
                      AddItemLib(TDirectoryOutline,1317,TRUE,TRUE);
                      AddItemLib(TGlyphButton,1318,TRUE,TRUE);
                      AddItemLib(TOnOffSwitch,1319,TRUE,TRUE);
                      AddItemLib(TGradient,1320,TRUE,TRUE);
                      AddItemLib(TSevenSegDisplay,1323,TRUE,TRUE);
                      AddItemLib(TLed,1324,TRUE,TRUE);
                      AddItemLib(TCoolBar,1295,TRUE,TRUE);
                      AddItemLib(TPieChart,1311, true, true);
                      AddItemLib(TBarChart,1313, true, true);
                      {$IFDEF OS2}
                      AddItemLib(TValueBar,1330,TRUE,TRUE);
                      AddItemLib(TColorWheel,1331,TRUE,TRUE);
                      {$ENDIF}
                   END;
               END; //case

          END;

          NavigatorPages.Add(Lib);

          WriteSibylNAV;  //write Navigator contents
     END
     ELSE
     BEGIN
         Application.LogWriteln('SetupNavigatorPages: Lese Sibyl.nav');
         //read from Sibyl.NAV
         {$i-}
         blockread(f,count,4,countread);
         {$i+}
         IF InOutRes <> 0 THEN
         BEGIN
l:
              {$i-}
              close(f);
              erase(f);
              {$i+}
              ErrorBox(FmtLoadNLSStr(SiFileReadError,[nav]));
              NavigatorPages.Destroy;
              NavigatorPages.Create;
              IF FailedList <> NIL THEN FailedList.Destroy;
              goto init;
         END;
         IF countread <> 4 THEN goto l;

         FailedList.Create; {zum Speichern der ungltigen Eintrge}

         FOR t:=1 TO Count DO
         BEGIN
              new(dummy);
              {$i-}
              blockread(f,dummy^,sizeof(TNavigatorPageRec),countread);
              {$i+}
              IF InOutRes <> 0 THEN goto l;
              IF countread <> sizeof(TNavigatorPageRec) THEN goto l;

              // Name der Seite an die aktuelle Sprache anpassen
              IF dummy^.Name = 'Standard'
                THEN dummy^.Name := LoadNLSStr(SiPaletteStandard)
                ELSE
              IF (dummy^.Name = 'Additional') or (dummy^.Name = 'Zusatz')
                THEN dummy^.Name := LoadNLSStr(SiPaletteAdditional)
                ELSE
              IF dummy^.Name = 'Extra'
                THEN dummy^.Name := LoadNLSStr(SiPaletteExtra)
                ELSE
              IF (dummy^.Name = 'Database') or (dummy^.Name = 'Datenbank')
                THEN dummy^.Name := LoadNLSStr(SiPaletteDatabase)
                ELSE
              IF dummy^.Name = 'Multimedia'
                THEN dummy^.Name := LoadNLSStr(SiPaletteMultimedia)
                ELSE
              IF dummy^.Name = 'Dialog'
                THEN dummy^.Name := LoadNLSStr(SiPaletteDialog)
                ELSE
              IF dummy^.Name = 'System'
                THEN dummy^.Name := LoadNLSStr(SiPaletteSystem)
                ELSE
              IF dummy^.Name = 'Internet'
                THEN dummy^.Name := LoadNLSStr(SiPaletteInternet)
                ELSE
              IF (dummy^.Name = 'Samples') or (dummy^.Name = 'Beispiele')
                THEN dummy^.Name := LoadNLSStr(SiPaletteSamples);

              dummy^.Components.Create;
              NavigatorPages.Add(dummy);
              {$i-}
              blockread(f,count1,4,countread);
              {$i+}
              IF InOutRes <> 0 THEN goto l;
              IF countread <> 4 THEN goto l;
              FOR t1:=1 TO Count1 DO
              BEGIN
                   new(entry);
                   {$i-}
                   blockread(f,entry^,sizeof(TNavigatorEntryRec),countread);
                   {$i+}
                   IF InOutRes <> 0 THEN goto l;
                   IF countread <> sizeof(TNavigatorEntryRec) THEN goto l;
                   Entry^.ComponentClass:=NIL;
                   IF Entry^.Std THEN //Search in Sibyl registered components
                   BEGIN
                        Entry^.ComponentClass:=SearchClassByName(Entry^.HelpText);
                   END
                   ELSE //Search in CompLib registered components
                   BEGIN
                        IF dummy^.Name='' THEN
                        BEGIN
                             Entry^.ComponentClass:=TIExpert;
                        END
                        ELSE
                        BEGIN
                             IF CompLibDll<>nil THEN Entry^.ComponentClass:=
                               CompLibSearchClassByNameProc(Entry^.HelpText);
                             aComponentClass:=Entry^.ComponentClass;
                             IF aComponentClass<>NIL
                             THEN RegisterClasses([aComponentClass]);
                        END;
                   END;
                   IF Entry^.ComponentClass=NIL THEN
                   BEGIN
                        IF not FailedList.Find(Upcased(Entry^.HelpText),idx) THEN
                        BEGIN
                             FailedList.Add(Upcased(Entry^.HelpText));

                             ErrorBox(FmtLoadNLSStr(SiNavigatorCompNotFound,[Entry^.HelpText])+#13#10 +
                                      LoadNLSStr(SiUsesRegisterClasses));
                             dispose(Entry);
                        END;
                   END
                   ELSE Dummy^.Components.Add(Entry);
              END;
         END;

         FailedList.Destroy;

         {$i-}
         close(f);
         {$i+}
     END;
     Application.LogWriteln('SetupNavigatorPages: Ende');
END;


FUNCTION GetBitmapFromClass(ReferenceComponent:TComponent;aClass:TComponentClass):TBitmap;
VAR t,t1:LONGINT;
    dummy:PNavigatorPageRec;
    entry:PNavigatorEntryRec;
BEGIN
     result:=NIL;

     IF NavigatorPages <> NIL THEN
     FOR t:=0 TO NavigatorPages.Count-1 DO
     BEGIN
          dummy:=NavigatorPages.Items[t];
          FOR t1:=0 TO dummy^.Components.Count-1 DO
          BEGIN
               entry:=dummy^.Components.Items[t1];
               IF aClass=entry^.ComponentClass THEN
               BEGIN
                    result.Create;
                    result.Owner:=ReferenceComponent;
                    ReferenceComponent.InsertComponent(result);
                    IF entry^.BmpButtonId<>0 THEN result.LoadFromResourceId(entry^.BmpButtonId)
                    ELSE IF entry^.BmpButtonName<>'' THEN result.LoadFromResourceName(entry^.BmpButtonName)
                    ELSE GetBitmapFromCompLib(result,aClass); //Get Bitmap from COMPLIB.DLL
                    exit;
               END;
          END;
     END;
END;

PROCEDURE InitNavigatorPage(Page:TControl; PageRec:PNavigatorPageRec);
VAR  ComponentClass:TComponentClass;
     Button:TNavigatorSwitchButton;
     NavigatorRec:PNavigatorEntryRec;
     Bitmap:TBitmap;
     t:LONGINT;
BEGIN
//  Application.LogWriteln('InitNavigatorPage:' + PageRec^.Name + ', ' + tostr(PageRec^.Components.Count-1));
  FOR t := 0 TO PageRec^.Components.Count-1 DO
    BEGIN
      NavigatorRec := PageRec^.Components.Items[t];
      IF NavigatorRec^.Installed THEN
        IF not (NavigatorRec^.ComponentClass IS TIExpert) THEN
          BEGIN
            ComponentClass := NavigatorRec^.ComponentClass;
            Button.Create(Page);
            Button.SetWindowPos(t * NavigatorButtonSize, 0,
                                NavigatorButtonSize, NavigatorButtonSize);
            Button.Flat := IdeSettings.FlatButtons;
            Button.Hint := NavigatorRec^.HelpText;
            Button.ComponentClass := ComponentClass;
            Button.GroupIndex := 1;
            Button.AllowAllUp := FALSE;
            Button.OnClick := Navigator.EvNavigateCompClicked;
            Bitmap.Create;
            IF NavigatorRec^.BmpButtonId = 0 {get Bitmap from COMPLIB.DLL}
              THEN
                BEGIN
                  IF NavigatorRec^.BmpButtonName=''
                    Then GetBitmapFromCompLib(Bitmap, ComponentClass)
                    ELSE Bitmap.LoadFromResourceName(NavigatorRec^.BmpButtonName);
                END
              ELSE
                Begin
                  try
                    Bitmap.LoadFromResourceId(NavigatorRec^.BmpButtonId);
                  except
                    ErrorBox(FmtLoadNLSStr(SiAnExceptLoadingBitmap,[ComponentClass.ClassName])+#13#10+
                             LoadNLSStr(SiComponentDisabled));
                    on E: Exception do
                      Application.LogWriteln('Fehler in:' + ComponentClass.ClassName +
                                             'FM: ' + E.Message);
                  end;
                End;
            IF Bitmap = NIL
              THEN //Exception loading bmp -> Disable Component
                BEGIN
                  ErrorBox(FmtLoadNLSStr(SiAnExceptLoadingBitmap,[ComponentClass.ClassName])+#13#10+
                           LoadNLSStr(SiComponentDisabled));
                  NavigatorRec^.Installed:=FALSE;
                END
              ELSE
                BEGIN
                  Button.Glyph := Bitmap;
                  Page.InsertControl(Button);
                END;
            Bitmap.Destroy; {#}
          END;
    END;
//  Application.LogWriteln('InitNavigatorPage: Ende');
END;

PROCEDURE InitNavigator(AForm:TForm);
BEGIN
  Navigator.Create(AForm);
  AForm.InsertControl(Navigator);
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TNavigator Class implementation                             บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


PROCEDURE TArrowSwitchButton.DrawBitmap(Bitmap:TBitmap;Down:BOOLEAN);
BEGIN
     IF Down THEN
     BEGIN
          If Navigator.ArrowDown<>Nil Then
            Inherited DrawBitmap(Navigator.ArrowDown,TRUE)
     END
     ELSE
     BEGIN
          If Navigator.ArrowUp<>Nil Then
            Inherited DrawBitmap(Navigator.ArrowUp,FALSE);
     END;
END;


PROCEDURE TNavigatorSwitchButton.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     IF Button = mbLeft THEN
     BEGIN
          AutomaticComponentInsert(ComponentClass);
          WasDoubleClick := TRUE;
     END;
END;


PROCEDURE TNavigatorSwitchButton.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     IF WasDoubleClick THEN Navigator.EnableArrow;
     WasDoubleClick := FALSE;

     Inherited MouseUp(Button,ShiftState,X,Y);
END;


PROCEDURE TNavigatorSwitchButton.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Navigator.MultiInsertMode := ssShift IN ShiftState;

     Inherited MouseDown(Button,ShiftState,X,Y);
END;


PROCEDURE TNavigatorSwitchButton.DrawFrame(Down:BOOLEAN);
VAR  rc1:TRect;
BEGIN
     IF Down THEN
     BEGIN
          rc1 := ClientRect;
          Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight);
          InflateRect(rc1,-1,-1);
          IF Navigator.MultiInsertMode THEN Canvas.ShadowedBorder(rc1,clRed,clRed)
          ELSE Canvas.ShadowedBorder(rc1,cl3DDkShadow,clBtnHighlight);

          InflateRect(rc1,-1,-1);
          Canvas.ClipRect := IntersectRect(Canvas.ClipRect,rc1);
     END
     ELSE Inherited DrawFrame(Down);
END;


(*************************************************************************
*** Navigator
*************************************************************************)

FUNCTION NavigatorTabSetFont:TFont;
VAR  FontName:STRING;
     PointSize:LONGINT;
BEGIN
     IF IdeSettings.Fonts.NavigatorFont <> '' THEN
       IF SplitFontName(IdeSettings.Fonts.NavigatorFont,FontName,PointSize) THEN
       BEGIN
            Result := Screen.GetFontFromPointSize(FontName,PointSize);
            IF Result <> NIL THEN exit;
       END;

     Result := Screen.SmallFont;
END;

DESTRUCTOR TNavigator.Destroy;
BEGIN
    ArrowUp.Destroy;
    ArrowUp:=Nil;
    ArrowDown.Destroy;
    ArrowDown:=Nil;
    Navigator:=Nil;

    Inherited Destroy;
END;

PROCEDURE TNavigator.SetupComponent;
VAR  PageRec:PNavigatorPageRec;
     x,t:LONGINT;
     idx:LONGINT;
     Page:TControl;
BEGIN
//     Application.LogWriteln('TNavigator.SetupComponent: Start');
     Inherited SetupComponent;

     Color := clDlgWindow;
     Align := alClient;
     Include(ComponentState, csAcceptsControls); {clipping??}

     TabSet.Create(SELF);
     TabSet.Height := 25;
     TabSet.Align := alBottom;
     TabSet.Font := NavigatorTabSetFont;
     TabSet.OnClick := EvPageSelected;
     TabSet.OnFontChange := EvFontChange;
     InsertControl(TabSet);

     NoteBook.Create(SELF);
     NoteBook.Left := NBLeftIndent;
     NoteBook.Bottom := 30;
     NoteBook.Width := Width - NBLeftIndent - NBRightIndent;
     NoteBook.Height := NavigatorButtonSize;
     NoteBook.Pages.Clear;
     InsertControl(NoteBook);

     {Arrow}
     ArrowSwitch.Create(SELF);
     ArrowUp.Create;
     ArrowUp.LoadFromResourceId(1360);
     ArrowDown.Create;
     ArrowDown.LoadFromResourceId(1361);
     ArrowSwitch.SetWindowPos(10,30,NavigatorButtonSize,NavigatorButtonSize);
     ArrowSwitch.OnClick := EvArrowClick;
     ArrowSwitch.Glyph := ArrowDown;
     ArrowSwitch.Enabled := TRUE;
     ArrowSwitch.Hint := LoadNLSStr(SiSelectMode);
     ArrowSwitch.GroupIndex := 1;
     ArrowSwitch.Down := TRUE;
     ArrowSwitch.AllowAllUp := FALSE;
     ArrowSwitch.Flat := IdeSettings.FlatButtons;
     InsertControl(ArrowSwitch);

     {2 buttons for scrolling}
     FLeftScroller.Create(SELF);
     FLeftScroller.SetWindowPos(NBLeftIndent-12, 30, 12, NavigatorButtonSize);
     FLeftScroller.OnClick := EvNavigateLScroll;
     FLeftScroller.Hint := LoadNLSStr(SiScrollComponentsBack);
     FLeftScroller.FAlign := TRUE;
     FLeftScroller.Enabled := FALSE;
     FLeftScroller.Flat := IdeSettings.FlatButtons;
     InsertControl(FLeftScroller);

     x := NoteBook.Left + NoteBook.Width;
     FRightScroller.Create(SELF);
     FRightScroller.SetWindowPos(x, 30, 12, NavigatorButtonSize);
     FRightScroller.OnClick := EvNavigateRScroll;
     FRightScroller.Hint := LoadNLSStr(SiScrollComponentsForward);
     FRightScroller.FAlign := FALSE;
     FRightScroller.Enabled := FALSE;
     FRightScroller.Flat := IdeSettings.FlatButtons;
     InsertControl(FRightScroller);

     FirstBtnIndex := 0;          
     {fr alle Flle}
     SetupNavigatorPages;

//     Application.LogWriteln('TNavigator.SetupComponent: Pages:' + tostr(NavigatorPages.Count-1));
     IF NavigatorPages <> NIL THEN
     FOR t := 0 TO NavigatorPages.Count-1 DO
     BEGIN
       PageRec := NavigatorPages.Items[t];
       IF PageRec^.Installed THEN
         IF PageRec^.Name <> '' THEN
           BEGIN
//             Application.LogWriteln('TNavigator.SetupComponent: idx='+PageRec^.Name);
             idx := NoteBook.Pages.Add(PageRec^.Name);
             Page := TControl(NoteBook.Pages.Objects[idx]);
             InitNavigatorPage(Page, PageRec);
           END;
     END;
//     Application.LogWriteln('TNavigator.SetupComponent: Pages-Fertig');

     TabSet.Tabs := NoteBook.Pages;
     TabSet.TabIndex := 0;
//     Application.LogWriteln('TNavigator.SetupComponent: Ende');
END;


PROCEDURE TNavigator.EvArrowClick(Sender:TObject);
BEGIN
     EnableArrow;
END;


PROCEDURE TNavigator.EvPageSelected(Sender:TObject);
VAR  ActivePage:TControl;
     Control:TNavigatorSwitchButton;
     i:LONGINT;
BEGIN
     NoteBook.PageIndex := TabSet.TabIndex;
     FirstBtnIndex := 0;

     ActivePage := TControl(NoteBook.Pages.Objects[NoteBook.PageIndex]);
     IF ActivePage = NIL THEN exit;

     FOR i := 0 TO ActivePage.ControlCount-1 DO
     BEGIN
          Control := TNavigatorSwitchButton(ActivePage.Controls[i]);
          IF Control IS TNavigatorSwitchButton THEN
          BEGIN
               IF Control.Left = 0 THEN FirstBtnIndex := i;
          END;
     END;
     EnableArrow;
     UpdateScrollers;
END;


PROCEDURE TNavigator.EvFontChange(Sender:TObject);
VAR  s:STRING;
BEGIN
     IF not Visible THEN exit;  {wegen Canvas init}
     TabSet.Invalidate;
     s := tostr(TabSet.Font.PointSize) + '.' + TabSet.Font.FaceName;
     IdeSettings.Fonts.NavigatorFont := s;
     IdeSettings.Modified := TRUE;
END;


PROCEDURE TNavigator.EvNavigateRScroll(Sender:TObject);
VAR  Control:TControl;
     ActivePage:TControl;
     i,x:LONGINT;
BEGIN
     ActivePage := TControl(NoteBook.Pages.Objects[NoteBook.PageIndex]);
     IF ActivePage = NIL THEN exit;

     IF FirstBtnIndex + FieldCount >= ActivePage.ControlCount THEN exit;

     inc(FirstBtnIndex);
     x := - (FirstBtnIndex * NavigatorButtonSize);
     FOR i := 0 TO ActivePage.ControlCount-1 DO
     BEGIN
          Control := ActivePage.Controls[i];
          IF Control <> NIL THEN
          BEGIN
               Control.Left := x;
               inc(x, NavigatorButtonSize);
          END;
     END;

     UpdateScrollers;
END;


PROCEDURE TNavigator.EvNavigateLScroll(Sender:TObject);
VAR  Control:TControl;
     ActivePage:TControl;
     i,x:LONGINT;
BEGIN
     ActivePage := TControl(NoteBook.Pages.Objects[NoteBook.PageIndex]);
     IF ActivePage = NIL THEN exit;

     IF FirstBtnIndex <= 0 THEN exit;

     dec(FirstBtnIndex);
     x := - (FirstBtnIndex * NavigatorButtonSize);
     FOR i := 0 TO ActivePage.ControlCount-1 DO
     BEGIN
          Control := ActivePage.Controls[i];
          IF Control <> NIL THEN
          BEGIN
               Control.Left := x;
               inc(x, NavigatorButtonSize);
          END;
     END;

     UpdateScrollers;
END;


PROCEDURE TNavigator.UpdateScrollers;
VAR  ActivePage:TControl;
BEGIN
     IF NoteBook.Pages.Count = 0 THEN
     BEGIN
          FLeftScroller.Enabled := FALSE;
          FRightScroller.Enabled := FALSE;
          exit;
     END;

     ActivePage := TControl(NoteBook.Pages.Objects[NoteBook.PageIndex]);
     IF ActivePage = NIL THEN exit;

     FLeftScroller.Enabled := FirstBtnIndex > 0;
     FRightScroller.Enabled := FirstBtnIndex + FieldCount < ActivePage.ControlCount;
     FLeftScroller.Invalidate;
     FRightScroller.Invalidate;
END;


PROCEDURE TNavigator.Resize;
BEGIN
     Inherited Resize;

     FieldCount := (Width - NBLeftIndent - NBRightIndent) DIV NavigatorButtonSize;
     NoteBook.Width := FieldCount * NavigatorButtonSize;

     FRightScroller.Left := NoteBook.Left + NoteBook.Width;
     UpdateScrollers;
END;


PROCEDURE TNavigator.EvNavigateCompClicked(Sender:TObject);
VAR  Button:TNavigatorSwitchButton;
BEGIN
     Button := TNavigatorSwitchButton(Sender);
     IF Button IS TNavigatorSwitchButton THEN
     BEGIN
          FSelectedComponent := Button;
          SetArrowDown(FALSE);
     END;
END;


PROCEDURE TNavigator.SetArrowDown(Value:BOOLEAN);
BEGIN
     IF ArrowSwitch <> NIL THEN
     BEGIN
          ArrowSwitch.AllowAllUp := TRUE;  {nur automatisch ausschaltbar}
          ArrowSwitch.Down := Value;
          ArrowSwitch.AllowAllUp := FALSE; {aber nicht manuell}
     END;
END;


FUNCTION TNavigator.GetSelectedComponent:TComponentClass;
BEGIN
     IF FSelectedComponent = NIL THEN Result := NIL
     ELSE Result := FSelectedComponent.ComponentClass;
END;


PROCEDURE TNavigator.EnableArrow;
BEGIN
     MultiInsertMode := FALSE;

     IF FSelectedComponent <> NIL THEN
     BEGIN
          FSelectedComponent.AllowAllUp := TRUE;  {nur automatisch ausschaltbar}
          FSelectedComponent.Down := FALSE;
          FSelectedComponent.AllowAllUp := FALSE; {aber nicht manuell}
          FSelectedComponent := NIL;
     END;
     SetArrowDown(TRUE);
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TComponentViewer Class implementation                       บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$HINTS OFF}
PROCEDURE TComponentViewer.ItemFocused(Sender:TObject;Index:LONGINT);
BEGIN
     IF not Nested THEN FNameEntry.Caption:=FBitmapListBox.Items.Strings[Index];
END;

PROCEDURE TComponentViewer.ItemSelected(Sender:TObject;Index:LONGINT);
VAR s:STRING;
    aClass:TComponentClass;
BEGIN
     s:=FBitmapListBox.Items.Strings[Index];
     aClass:=GetClassFromName(s);
     IF aClass<>NIL THEN
     BEGIN
          AutomaticComponentInsert(aClass);
          IF Navigator <> NIL THEN Navigator.EnableArrow;
     END;
END;
{$HINTS ON}

FUNCTION TComponentViewer.GetClassFromName(Name:STRING):TComponentClass;
VAR t,t1:LONGINT;
    NavigatorRec:PNavigatorEntryRec;
    PageRec:PNavigatorPageRec;
    s:STRING;
BEGIN
     result:=NIL;
     UpcaseStr(Name);

     IF NavigatorPages <> NIL THEN
     FOR t:=0 TO NavigatorPages.Count-1 DO
     BEGIN
          PageRec:=NavigatorPages.Items[t];
          IF PageRec^.Installed THEN
            IF PageRec^.Name<>'' THEN
          BEGIN
               FOR t1:=0 TO PageRec^.Components.Count-1 DO
               BEGIN
                    NavigatorRec:=PageRec^.Components.Items[t1];
                    IF NavigatorRec^.Installed THEN
                    BEGIN
                         s:=NavigatorRec^.HelpText;
                         UpcaseStr(s);
                         IF s=Name THEN
                         BEGIN
                              result:=NavigatorRec^.ComponentClass;
                              exit;
                         END;
                    END;
               END;
          END;
     END;
END;

PROCEDURE TComponentViewer.SetupComponent;
VAR  Button:TBitBtn;
     aLabel:TLabel;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiComponentList);
     Color := clLtGray;
     BorderIcons := [biSystemMenu];
     Width := 230;
     Height := 325;
     SibylFormId := dwi_CompList;

     aLabel := InsertLabelNLS(SELF,15,265,195,20,SiSelectByName);
     aLabel.yAlign := yaTop;
     aLabel.xStretch := xsFrame;
     FNameEntry := InsertEdit(SELF,15,240,195,20,'','');
     FNameEntry.yAlign := yaTop;
     FNameEntry.xStretch := xsFrame;
     FNameEntry.OnChange := EntryChangeEvent;
     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
     FBitmapListBox := InsertBitmapListBox(SELF,15,50,195,180, 25);
     FBitmapListBox.Align := alFrame;
     FBitmapListBox.Sorted := TRUE;
     FBitmapListBox.OnItemFocus := ItemFocused;
     FBitmapListBox.OnItemSelect := ItemSelected;

     Button := InsertBitBtnNLS(SELF,50,10,130,30,bkOk,SiAddToForm,SiAddToFormHint);
     Button.xAlign := xaCenter;

     {Init the listbox}
     FillListBox;
END;


PROCEDURE TComponentViewer.ClearListBox;
BEGIN
     FBitmapListBox.Clear;
     FNameEntry.Clear;
END;


PROCEDURE TComponentViewer.FillListBox;
VAR  t,t1:LONGINT;
     NavigatorRec:PNavigatorEntryRec;
     PageRec:PNavigatorPageRec;
     Bitmap:TBitmap;
BEGIN
     {fr alle Flle}
     SetupNavigatorPages;

     FBitmapListBox.BeginUpdate;
     FBitmapListBox.Clear;

     IF NavigatorPages <> NIL THEN
     FOR t:=0 TO NavigatorPages.Count-1 DO
     BEGIN
          PageRec:=NavigatorPages.Items[t];
          IF PageRec^.Installed THEN
            IF PageRec^.Name<>'' THEN
          BEGIN
               FOR t1:=0 TO PageRec^.Components.Count-1 DO
               BEGIN
                   NavigatorRec:=PageRec^.Components.Items[t1];
                   IF NavigatorRec^.Installed THEN
                   BEGIN
                        Bitmap.Create;
                        IF NavigatorRec^.BmpButtonId<>0
                        THEN Bitmap.LoadFromResourceId(NavigatorRec^.BmpButtonId)
                        ELSE IF NavigatorRec^.BmpButtonName<>''
                        THEN Bitmap.LoadFromResourceName(NavigatorRec^.BmpButtonName)
                        ELSE GetBitmapFromCompLib(Bitmap,NavigatorRec^.ComponentClass);
                        FBitmapListBox.AddBitmap(NavigatorRec^.HelpText,Bitmap);
                   END;
               END;
          END;
     END;
     FBitmapListBox.EndUpdate;
END;


PROCEDURE TComponentViewer.UpdateListBox;
VAR s,s1:STRING;
    t:LONGINT;
    matches,current,b:BYTE;
    MatchIndex:LONGINT;
BEGIN
     s:=FNameEntry.Caption;
     UpcaseStr(s);
     matches:=0;
     MatchIndex:=-1;
     //search entry matching this
     FOR t:=0 TO FBitmapListBox.Items.Count-1 DO
     BEGIN
          s1:=FBitmapListBox.Items.Strings[t];
          UpcaseStr(s1);
          current:=0;
          FOR b:=1 TO length(s) DO
          BEGIN
               IF b>length(s1) THEN break;
               IF s[b]=s1[b] THEN inc(current)
               ELSE break;
          END;
          IF current>matches THEN
          BEGIN
               MatchIndex:=t;
               matches:=current;
          END;
     END;
     IF MatchIndex<>-1 THEN
     BEGIN
          nested:=TRUE;
          FBitmapListBox.ItemIndex := MatchIndex;
          nested:=FALSE;
     END
     ELSE FBitmapListBox.Selected[FBitmapListBox.ItemIndex] := FALSE;
END;

{$HINTS OFF}
PROCEDURE TComponentViewer.EntryChangeEvent(Sender:TObject);
BEGIN
     UpdateListBox;
END;
{$HINTS ON}

DESTRUCTOR TComponentViewer.Destroy;
BEGIN
     ComponentViewer:=NIL;
     Inherited Destroy;
END;

{$HINTS OFF}
PROCEDURE TComponentViewer.AddToForm(VAR Msg:TMessage);
VAR s:STRING;
    aClass:TComponentClass;
    Index:LONGINT;
BEGIN
     Index:=FBitmapListBox.ItemIndex;
     IF Index=-1 THEN exit;
     s:=FBitmapListBox.Items.Strings[Index];
     aClass:=GetClassFromName(s);
     IF aClass<>NIL THEN AutomaticComponentInsert(aClass);
END;
{$HINTS OFF}


PROCEDURE InitComponentViewer;
BEGIN
     IF ComponentViewer <> NIL THEN
     BEGIN
          IF ComponentViewer.WindowState = wsMinimized
          THEN ComponentViewer.WindowState := wsNormal;
          ComponentViewer.BringToFront;
          exit;
     END;
     ComponentViewer.Create(NIL);
     ComponentViewer.HelpContext := hctxDialogComponentViewer;
     ComponentViewer.Show;
     ComponentViewer.Update;
END;

BEGIN
  NavigatorPages := NIL;
  InitCompListProc := @InitComponentViewer;
  SetupNavigatorPagesProc := @SetupNavigatorPages;
END.
                                   
{ -- date -- -- from -- -- changes ----------------------------------------------
  13-Jul-03  WD         Einbau der Komponente "tEditDate"
  08-Dec-03  WD         Einbau der Komponente "tJoystickComp"
  03-Feb-04  WD         Einbau der Komponente "tPOP3Client"
  05-Mar-04  WD         Einbau der Komponente "tOKCancelButton"
  05-Jun-04  WD         Einbau der Komponente "tSerial"
  10-Jun-04  WD         Einbau der Komponente "tColorWheel" und "tValueBar"
  05-Jul-04  WD         Umbau der MultiMedia-Komponenten
  26-Sep-04  WD         Umbau von tJoystickComp auf tJoystickPort
  26-Sep-04  WD         Einbau der Datenabanken Komponenten
  31-Mar-05  WD         Einabu der Komponente "tEditFileName"
  01-Apr-05  WD         TConfigurePaletteDlg: Sortieren der Komponenten auf der "[Library]"-Seite
  28-Aug-05  WD         Unit "uOKCancelButton" ausgebaut. Komponente "tOKCancelButton" ist nun in ExtCtrls.
  29-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  20-Sep-05  WD         Dialog tUserPasswordDialog eingebaut.
  22-Apr-07  WD         Einbau der Komponente "TGauge"
  17-Mar-09  WD         Einbau der Komponente "tCheckGroup"
}
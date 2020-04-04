
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

UNIT DbgWatch;

INTERFACE

{$IFDEF OS2}
USES Os2Def,BseDos;
{$ENDIF}
{$IFDEF WIN32}
Uses WinBase;
{$ENDIF}

USES Messages,Dos,SysUtils,Color,Classes,Forms,Buttons,StdCtrls,Dialogs,OutLine,
     DAsm,DebugHlp,Consts,TabCtrls,Grids,Editors,BaseEdit,Sib_Ctrl,Projects, Menus,
     uString, uList;

TYPE
    TWatchGrid=CLASS(TStringGrid)
        LastInspected:LONGINT;
        LastDisplayed:LONGINT;
        FTempFileName:STRING;
        //
        IsLocalVarView:BOOLEAN;
        LastProc:STRING;
        WatchList:TStringList;
        InspectList:TStringList;
        InspectValue:STRING;
        InspectAddr:LONGWORD;
        InspectTyp:BYTE;
        CanClear:BOOLEAN;
        Popup:TPopupMenu;
        EntryEnabled:TMenuItem;
        //
        PROCEDURE SetupComponent;OVERRIDE;
        DESTRUCTOR Destroy;OVERRIDE;
        PROCEDURE Resize;OVERRIDE;
        FUNCTION GetCell(Col,Row:LONGINT):STRING;OVERRIDE;
        PROCEDURE SetCell(Col,Row:LONGINT;CONST NewContent:STRING);OVERRIDE;
        PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
        PROCEDURE DragOver(Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);OVERRIDE;
        PROCEDURE DragDrop(Source:TObject;X,Y:LONGINT);OVERRIDE;
        PROCEDURE CanDrag(X,Y:LONGINT;VAR Accept:BOOLEAN);OVERRIDE;
        PROCEDURE DoStartDrag(VAR DragData:TDragDropData);OVERRIDE;
        PROCEDURE DoEndDrag(Target:TObject; X,Y:LONGINT);OVERRIDE;
        FUNCTION DragValid(ExtDDO:TExternalDragDropObject):BOOLEAN;
        PROCEDURE SetupCellColors(Col,Row:LongInt;AState:TGridDrawState;VAR Background,ForeGround:TColor);OVERRIDE;
        FUNCTION GetOldCell(Col,Row:Longint):STRING;
        PROCEDURE SetOldCell(Col,Row:LongInt;CONST s:STRING);
        PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
        PROCEDURE ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
    END;

    TLocalsGrid=CLASS(TWatchGrid)
        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE UpdateVariables;
    END;

    TInspectWindow=CLASS(TForm)
        Grid:TWatchGrid;
        PROCEDURE SetupComponent;OVERRIDE;
        DESTRUCTOR Destroy;OVERRIDE;
    END;

    TBreakPointsListBox=CLASS(TListBox)
        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE UpdateBreaks;
        PROCEDURE TrackSource(Sender:TObject;Index:LONGINT);
    END;

    TSymbolsWindow=CLASS(TForm)
        FTree:TOutline;
        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE UpdateSymbols;
        DESTRUCTOR Destroy;OVERRIDE;
        PROCEDURE OutlineItemSelected(Sender:TObject;Index:LONGINT);
    END;

CONST
    InspectWindows:TList=NIL;
    WatchPointList:TList=NIL;
    DumpFields:TList=NIL;
    SymbolsWindow:TSymbolsWindow=NIL;
    LocalsGrid:TLocalsGrid=NIL;
    SelfGrid:TWatchGrid=NIL;
    WatchGrid:TWatchGrid=NIL;
    CallStackList:TListBox=NIL;    //fr den CodeEditor
    BPList:TBreakPointsListBox=NIL;

    ViewWatchProc:PROCEDURE=NIL;
    ViewLocalsProc:PROCEDURE=NIL;


PROCEDURE ViewWatch;
PROCEDURE AddWatch(CONST s,x:STRING);
PROCEDURE AddTheWatch(CONST s:STRING);
PROCEDURE UpdateWatchWindow(UpdateAll:BOOLEAN);
PROCEDURE EvaluateModify(s,x:STRING);
FUNCTION  ParseValueFromExpr(s:STRING;VAR s1:STRING;VAR e,Len:LongWord;VAR Typ:BYTE):BOOLEAN;
PROCEDURE AddInspectWin(CONST Value:STRING);
PROCEDURE InspectExpression;
PROCEDURE ViewWatchPoints;
PROCEDURE ViewLocalVariables;
PROCEDURE ViewSymbols;
PROCEDURE UpdateCallStackList;
PROCEDURE UpdateBreakpointList;

IMPLEMENTATION

TYPE
    PWatchPointItem=^TWatchPointItem;
    TWatchPointItem=RECORD
                          Address:LONGWORD;
                          Flags:LONGWORD; //$10000 Execute
                                          //$20000 Write
                                          //$30000 Read/Write
                          Len:LONGWORD;
                          Valid:BOOLEAN;  //FALSE if cannot be set
    END;

PROCEDURE UpdateWatchPoints;
VAR Item:PWatchPointItem;
    t:LONGINT;
BEGIN
     IF not InDebugger THEN exit;
     FOR t:=0 TO WatchPointList.Count-1 DO
     BEGIN
          Item:=WatchPointList.Items[t];
          IF Item^.Valid THEN
            IF not SetWatchPoint(Item^.Address,Item^.Flags,Item^.Len) THEN
            BEGIN
               ErrorBox(LoadNLSStr(SiCouldNotSetWatchPoint)+': '+tohex(Item^.Address));
               Item^.Valid:=FALSE;
            END;
     END;
END;

TYPE
    TWatchPointDlg=CLASS(TDialog)
        NoteBook:TTabbedNoteBook;
        NewPage,ViewPage:TPage;
        Entry:TEdit;
        BreakExecute,BreakWrite,BreakReadWrite:TRadioButton;
        Watch1,Watch2,Watch4:TRadioButton;

        WatchListBox:TListBox;

        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE SetupShow;OVERRIDE;
        PROCEDURE OnNew(Sender:TObject);
        PROCEDURE OnDelete(Sender:TObject);
        PROCEDURE OnModify(Sender:TObject);
        PROCEDURE UpdateWatchListBox;
        FUNCTION NewWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN;
    END;

FUNCTION TWatchPointDlg.NewWatchPoint(Address,Flags,Len:LONGWORD):BOOLEAN;
VAR Item:PWatchPointItem;
BEGIN
     result:=FALSE;
     IF WatchPointList.Count=4 THEN ErrorBox(LoadNLSStr(SiWatchPointLimitReached))
     ELSE
     BEGIN
          IF Len=2 THEN IF (Address AND 1)<>0 THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiAdressMustStartOnDoubleWord));
               exit;
          END;

          IF Len=4 THEN IF (Address AND 3)<>0 THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiAdressMustStartOnDoubleWord));
               exit;
          END;

          New(Item);
          Item^.Address:=Address;
          Item^.Flags:=Flags;
          Item^.Len:=Len;
          Item^.Valid:=TRUE;

          WatchPointList.Add(Item);

          UpdateWatchListBox;
          result:=TRUE;
     END;
END;

{Standard types}
CONST
     {This is NOT compatible to IPMD !}
     TT_SHORTINT    =$80; {like IPMD}
     TT_LONGINT     =$82; {like IPMD}
     TT_BYTE        =$84; {like IPMD}
     TT_WORD        =$85; {like IPMD}
     TT_LONGWORD    =$86; {like IPMD}
     TT_INTEGER     =$87; {like IPMD}
     TT_SINGLE      =$88; {like IPMD}
     TT_DOUBLE      =$89; {like IPMD}
     TT_REAL        =TT_DOUBLE;
     TT_EXTENDED    =$8a; {like IPMD}
     TT_STRING      =$8b; {not IPMD !}
     TT_CSTRING     =$8c; {not IPMD !}
     TT_PROC        =$8d; {not IPMD !}
     TT_VAR         =$8e; {like IPMD}
     TT_FILE        =$8f; {not IPMD !}
     TT_BOOLEAN     =$90; {like IPMD}
     TT_WORDBOOL    =$91; {like IPMD}
     TT_LONGBOOL    =$92; {like IPMD}
     TT_TEXT        =$93; {not IPMD !}
     TT_CHAR        =$94; {like IPMD}
     TT_POINTER     =$95; {not IPMD !}
     TT_ANSISTRING  =$96; {not IPMD !}
     TT_UNTYPED     =$97; {like IPMD !}

     TT_RECORD      =$F0;
     TT_OBJECT      =$F1;
     TT_SET         =$F2;


{Result TRUE, wenn Value gltig ist}
FUNCTION ParseValueFromExpr(s:STRING;VAR s1:STRING;VAR e,Len:LongWord;VAR Typ:BYTE):BOOLEAN;
VAR l:BYTE;
    c:INTEGER;
BEGIN
     UpcaseStr(s);
     WHILE ((Length(s)>0)AND(s[1]=#32)) DO delete(s,1,1);
     WHILE s[length(s)]=#32 DO dec(s[0]);
     IF pos('ORD(',s)=1 THEN
     BEGIN
          IF s[length(s)]=')' THEN
          BEGIN
               SubStr(s,5,length(s)-5);
               Result := ParseValueFromExpr(s,s1,e,Len,Typ);
               IF Typ<>TT_CHAR THEN
               BEGIN
                    s1:='<Type conflict>';
                    exit;
               END;
               s1:=tostr(ord(s1[2]));
               exit;
          END;
     END;
     IF pos('CHR(',s)=1 THEN
     BEGIN
          IF s[length(s)]=')' THEN
          BEGIN
               SubStr(s,5,length(s)-5);
               Result := ParseValueFromExpr(s,s1,e,Len,Typ);
               IF Typ<>TT_BYTE THEN
               BEGIN
                    s1:='<Type conflict>';
                    exit;
               END;
               VAL(s1,l,c);
               s1:=#39+chr(l)+#39;
               exit;
          END;
     END;
     IF pos('LENGTH(',s)=1 THEN
     BEGIN
          IF s[length(s)]=')' THEN
          BEGIN
               SubStr(s,8,length(s)-8);
               Result := ParseValueFromExpr(s,s1,e,Len,Typ);
               IF Typ <> TT_STRING THEN
               BEGIN
                    s1:='<Type conflict>';
                    exit;
               END;

               s1:=tostr(length(s1)-2);
               exit;
          END;
     END;
     Result := GetValueFromExpr(s,s1,e,Len,Typ,FALSE);
END;


{$HINTS OFF}
PROCEDURE TWatchPointDlg.OnNew(Sender:TObject);
VAR l,Len:LONGWORD;
    c:INTEGER;
    Expr,Value:STRING;
    Flags,ValueLen:LONGWORD;
    ValueTyp:BYTE;
LABEL err;
BEGIN
     VAL(Entry.Text,l,c);
     IF c<>0 THEN
     BEGIN
         IF not InDebugger THEN
         BEGIN
              Value:=LoadNLSStr(SiDebuggerNotRunning);
              goto err;
         END;

         Expr:=Entry.Text;
         IF not ParseValueFromExpr(Expr,Value,l,ValueLen,ValueTyp) THEN
         BEGIN
err:
              ErrorBox(LoadNLSStr(SiIllegalAdressFormat)+#13#10+
                       '('+Value+')');
              exit;
         END;

         IF (l<$10000) THEN
         BEGIN
              //ErrorBox2('l<$10000:'+tohex(l));
              goto err;
         END;
     END;

     IF Watch1.Checked THEN len:=1
     ELSE IF Watch2.Checked THEN len:=4
     ELSE Len:=4;

     IF BreakExecute.Checked THEN Flags:=$10000
     ELSE IF BreakReadWrite.Checked THEN Flags:=$30000
     ELSE Flags:=$20000;

     IF NewWatchPoint(l,Flags,Len) THEN NoteBook.PageIndex:=1;
END;

PROCEDURE TWatchPointDlg.OnModify(Sender:TObject);
VAR Dlg:TDialog;
    Entry:TEdit;
    BreakExecute,BreakWrite,BreakReadWrite:TRadioButton;
    Watch1,Watch2,Watch4:TRadioButton;
    Group:TGroupBox;
    l,Len:LONGWORD;
    c:INTEGER;
    Expr,Value:STRING;
    Flags,ValueLen:LONGWORD;
    ValueTyp:BYTE;
    Item:PWatchPointItem;
    Index:LONGINT;
LABEL err;
BEGIN
     Index:=WatchListBox.ItemIndex;
     IF ((Index<0)OR(Index>WatchPointList.Count-1)) THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiYouMustSelectAnItem));
          exit;
     END;

     Item:=WatchPointList.Items[Index];

     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogModifyWatchPoint;
     Dlg.ClientWidth:=330;
     Dlg.ClientHeight:=255;
     Dlg.Caption:=LoadNLSStr(SiModifyWatchPoint);

     InsertLabelNLS(Dlg,10,220,210,20,SiAdressExpression);
     Entry:=InsertEdit(Dlg,10,190,310,20,'','');
     Entry.Text:=tohex(Item^.Address);

     Group := InsertGroupBoxNLS(Dlg,10,60,150,110,SiBreakOn);
     BreakExecute:=InsertRadioButtonNLS(Group,15,60,130,25,SiExecute,0);
     BreakWrite:=InsertRadioButtonNLS(Group,15,35,130,25,SiWrite,0);
     BreakReadWrite:=InsertRadioButtonNLS(Group,15,10,130,25,SiReadWrite,0);
     IF Item^.Flags=$10000 THEN BreakExecute.Checked:=TRUE
     ELSE IF Item^.Flags=$30000 THEN BreakReadWrite.Checked:=TRUE
     ElSE BreakWrite.Checked:=TRUE;

     Group := InsertGroupBoxNLS(Dlg,170,60,150,110,SiBytesToWatch);
     Watch1:=InsertRadioButtonNLS(Group,15,60,110,25,SiOneByte,0);
     Watch2:=InsertRadioButtonNLS(Group,15,35,110,25,SiTwoBytes,0);
     Watch4:=InsertRadioButtonNLS(Group,15,10,110,25,SiFourBytes,0);
     IF Item^.Len=1 THEN Watch1.Checked:=TRUE
     ELSE IF Item^.Len=2 THEN Watch2.Checked:=TRUE
     ELSE Watch4.Checked:=TRUE;


     InsertBitBtnNLS(Dlg,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(Dlg,110,10,110,30,bkCancel,SCancelButton,SClickHereToCancel);

     Dlg.ShowModal;
     IF Dlg.ModalResult=cmOk THEN
     BEGIN
          VAL(Entry.Text,l,c);
          IF c<>0 THEN
          BEGIN
              IF not InDebugger THEN goto err;

              Expr:=Entry.Text;
              UpcaseStr(Expr);
              IF not ParseValueFromExpr(Expr,Value,l,ValueLen,ValueTyp) THEN
              BEGIN
err:
                   Dlg.Destroy;
                   ErrorBox(LoadNLSStr(SiIllegalAdressFormat));
                   exit;
              END;

              IF (l<$10000) THEN goto err;
         END;

         IF Watch1.Checked THEN len:=1
         ELSE IF Watch2.Checked THEN len:=4
         ELSE Len:=4;

         IF BreakExecute.Checked THEN Flags:=$10000
         ELSE IF BreakReadWrite.Checked THEN Flags:=$30000
         ELSE Flags:=$20000;

         Dlg.Destroy;

         WatchPointList.Remove(Item);

         IF InDebugger THEN IF Item^.Valid THEN
           IF not ClearWatchPoint(Item^.Address,Item^.Flags,Item^.Len) THEN
              ErrorBox(LoadNLSStr(SiCouldNotFreeWatchPoint));
         Dispose(Item);

         NewWatchPoint(l,Flags,Len);

         UpdateWatchListBox;
     END
     ELSE Dlg.Destroy;
END;

PROCEDURE TWatchPointDlg.OnDelete(Sender:TObject);
VAR Index:LONGINT;
    Item:PWatchPointItem;
BEGIN
     Index:=WatchListBox.ItemIndex;
     IF ((Index<0)OR(Index>WatchPointList.Count-1)) THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiYouMustSelectAnItem));
          exit;
     END;

     Item:=WatchPointList.Items[Index];
     WatchPointList.Remove(Item);

     IF InDebugger THEN IF Item^.Valid THEN
       IF not ClearWatchPoint(Item^.Address,Item^.Flags,Item^.Len) THEN
          ErrorBox(LoadNLSStr(SiCouldNotFreeWatchPoint));
     Dispose(Item);

     UpdateWatchListBox;
END;
{$HINTS ON}

PROCEDURE TWatchPointDlg.UpdateWatchListBox;
VAR Item:PWatchPointItem;
    t:LONGINT;
    s:STRING;
BEGIN
     WatchListBox.Clear;

     FOR t:=0 TO WatchPointList.Count-1 DO
     BEGIN
          Item:=WatchPointList.Items[t];
          s:=tostr(Item^.Len)+LoadNLSStr(SiBytesAt)+' '+tohex(Item^.Address)+' ';
          IF not Item^.Valid THEN s:=LoadNLSStr(SiInvalidWatchPoint)+':'+s;
          IF Item^.Flags=$10000 THEN s:=s+LoadNLSStr(SiWatchExecute)
          ELSE IF Item^.Flags=$30000 THEN s:=s+LoadNLSStr(SiWatchReadWrite)
          ELSE s:=s+LoadNLSStr(SiWatchWrite);

          WatchListBox.Items.Add(s);
     END;
END;

PROCEDURE TWatchPointDlg.SetupShow;
BEGIN
     Inherited SetupShow;

     UpdateWatchListBox;
     Entry.Focus;
END;

PROCEDURE TWatchPointDlg.SetupComponent;
VAR  NewButton,DeleteButton,ModifyButton:TBitBtn;
     CloseBtn,HelpBtn:TBitBtn;
     Group:TGroupBox;
BEGIN
     Inherited SetupComponent;

     ClientWidth:=530;
     ClientHeight:=330;
     Caption:=LoadNLSStr(SiWatchPoints);

     NoteBook.Create(SELF);
     NoteBook.Width := 370;
     NoteBook.Align:=alLeft;

     NoteBook.Pages.Clear;

     //New Page
     NoteBook.Pages.Add(LoadNLSStr(SiNewWatchPoint)+'|'+LoadNLSStr(SiNewWatchPointHint));
     NewPage:=TPage(NoteBook.Pages.Objects[0]);

     InsertLabelNLS(NewPage,10,210,210,20,SiAdressExpression);
     Entry:=InsertEdit(NewPage,10,180,310,20,'','');

     Group := InsertGroupBoxNLS(NewPage,10,60,150,110,SiBreakOn);
     BreakExecute:=InsertRadioButtonNLS(Group,15,60,130,25,SiExecute,0);
     BreakWrite:=InsertRadioButtonNLS(Group,15,35,130,25,SiWrite,0);
     BreakWrite.Checked:=TRUE;
     BreakReadWrite:=InsertRadioButtonNLS(Group,15,10,130,25,SiReadWrite,0);

     Group := InsertGroupBoxNLS(NewPage,170,60,150,110,SiBytesToWatch);
     Watch1:=InsertRadioButtonNLS(Group,15,60,130,25,SiOneByte,0);
     Watch2:=InsertRadioButtonNLS(Group,15,35,130,25,SiTwoBytes,0);
     Watch4:=InsertRadioButtonNLS(Group,15,10,130,25,SiFourBytes,0);
     Watch4.Checked:=TRUE;

     NewButton:=InsertBitBtnNLS(NewPage,40,12,120,30,bkOk,SiAdd,0);
     NewButton.Command:=cmNull;
     NewButton.ModalResult:=cmNull;
     NewButton.XAlign:=xaCenter;
     NewButton.OnClick:=OnNew;


     //Modify Page
     NoteBook.Pages.Add(LoadNLSStr(SiModifyWatchPnt)+'|'+LoadNLSStr(SiModifyWatchPntHint));
     ViewPage:=TPage(NoteBook.Pages.Objects[1]);

     InsertLabelNLS(ViewPage,10,210,210,20,SiAvailableWatchPoints);
     WatchListBox:=InsertListBox(ViewPage,10,60,310,140,'');

     ModifyButton:=InsertBitBtnNLS(ViewPage,50,12,100,30,bkOk,SiModify,0);
     ModifyButton.Command:=cmNull;
     ModifyButton.ModalResult:=cmNull;
     ModifyButton.OnClick:=OnModify;
     DeleteButton:=InsertBitBtnNLS(ViewPage,170,12,100,30,bkYes,SiDelete,0);
     DeleteButton.Command:=cmNull;
     DeleteButton.ModalResult:=cmNull;
     DeleteButton.OnClick:=OnDelete;

     NoteBook.PageIndex:=0;
     InsertControl(NoteBook);

     CloseBtn := InsertBitBtnNLS(SELF,390,275,120,35,bkClose,SiCloseDlg,0);
     HelpBtn := InsertBitBtnNLS(SELF,390,230,120,35,bkHelp,SHelpButton,0);
END;


PROCEDURE ViewWatchPoints;
VAR Dlg:TWatchPointDlg;
BEGIN
     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogWatchPoints;
     Dlg.ShowModal;
     Dlg.Destroy;
     IF InDebugger THEN UpdateWatchPoints;
END;

{Types to watch}
CONST
     WT_NONE         =0;
     WT_BYTE         =1;
     WT_WORD         =2;
     WT_LONGWORD     =3;
     WT_SHORTINT     =4;
     WT_INTEGER      =5;
     WT_LONGINT      =7;
     WT_CHAR         =8;
     WT_STRING       =9;
     WT_CSTRING      =10;
     WT_POINTER      =11;
     WT_ARRAY        =12;
     WT_RECORD       =13;
     WT_SET          =14;
     WT_ENUM         =15;
     WT_BOOLEAN      =16;


PROCEDURE AddInspectWin(CONST Value:STRING);
VAR  Watch:TInspectWindow;
BEGIN
     IF Value='' THEN exit;

     Watch.Create(NIL);
     Watch.HelpContext := hctxDialogInspectForm;
     Watch.Grid.RowCount:=1;
     Watch.Grid.InspectValue:=Value;
     Watch.Icon:=InspectIcon;
     Watch.Caption:=LoadNLSStr(SiInspecting)+': '+Value;
     Watch.Show;
END;

TYPE TAddWatchDlg=CLASS(TDialog)
           Entry:TEdit;
           PROCEDURE SetupComponent;OVERRIDE;
     END;

PROCEDURE InspectExpression;
VAR  WatchDlg:TAddWatchDlg;
BEGIN
     WatchDlg.Create(NIL);
     WatchDlg.HelpContext := hctxDialogAddInspect;
     WatchDlg.Caption:=LoadNLSStr(SiInspectExpression);
     IF WatchDlg.Execute THEN
     BEGIN
          AddInspectWin(WatchDlg.Entry.Text);
     END;
     WatchDlg.Destroy;
END;


PROCEDURE UpdateCallStackList;

  PROCEDURE AddStackItem(LinearAddr:LONGWORD);
  VAR  Line:WORD;
       Source:STRING;
       Module:PModuleInfo;
       s:STRING;
  BEGIN
       SearchLineNum(LinearAddr,TRUE,source,Line,Module);
       s := Source+' ';
       IF Line <> 0 THEN s := s+'('+tostr(Line)+') ';
       s := s+tohex(LinearAddr);
       IF Module <> NIL THEN s := s+' '+GetNearestProc(LinearAddr);
       CallStackList.Items.Add(s);
  END;

VAR  Buf:TDbgBuf;
     EBP,EIP,TargetEIP:LONGWORD;
     StackList:RECORD
         OldEBP:LONGWORD;
         RetEIP:LONGWORD;
     END;
     CallArray:ARRAY[1..5] OF BYTE;
LABEL Done;
BEGIN
     IF CallStackList = NIL THEN exit;
     IF not CallStackList.Showing THEN exit;

     CallStackList.BeginUpdate;

     CallStackList.Clear;

     IF InDebugger THEN
     BEGIN
       IF GetRegisterSet(Buf) THEN
       BEGIN
         AddStackItem(Buf.EIP);
         IF StackBase = 0 THEN goto Done;

         {???????????????????????????????}
         {if the pointer at ESP is a call we use ESP instead of EBP}
         IF not GetDump(Buf.ESP,StackList,8) THEN goto Done;
         TargetEIP := Buf.EIP;
         IF StackList.OldEBP = Buf.EBP THEN
         BEGIN
           EBP := StackList.RetEIP; //After push EBP
           dec(TargetEIP);
         END
         ELSE EBP := StackList.OldEBP;

         IF GetDump(EBP-5,CallArray,5) THEN
           IF CallArray[1] = $E8 THEN
           BEGIN
             System.Move(CallArray[2],EIP,4);
             IF EBP+EIP <= TargetEIP THEN AddStackItem(EBP-5);
           END;

         EBP := Buf.EBP;
         WHILE EBP <> StackBase DO
         BEGIN
           IF not GetDump(EBP,StackList,8) THEN goto Done;
           AddStackItem(StackList.RetEIP-5);
           EBP := StackList.OldEBP;
         END;
       END
       ELSE ErrorBox(LoadNLSStr(SiCouldNotGetRegisters));
     END;
Done:
     CallStackList.EndUpdate;
END;


PROCEDURE UpdateWatchWindow(UpdateAll:BOOLEAN);
VAR t:LONGINT;
    iwin:TInspectWindow;
    s:STRING;
BEGIN
     IF WatchGrid<>NIL THEN IF WatchGrid.Visible THEN
     BEGIN
          WatchGrid.CanClear:=TRUE;
          WatchGrid.Refresh;

          FOR t:=WatchGrid.LastDisplayed+1 TO WatchGrid.RowCount-1 DO
          BEGIN
               s:=WatchGrid.Cells[1,t]; {!!}
               s:=WatchGrid.GetOldCell(1,t);
               IF s[length(s)]='!' THEN WatchGrid.SetOldCell(1,t,WatchGrid.Cells[1,t]+'!'); //Update value
          END;
          WatchGrid.Refresh;
          WatchGrid.CanClear:=FALSE;
     END;

     FOR t:=0 TO InspectWindows.Count-1 DO
     BEGIN
          iwin:=InspectWindows.Items[t];
          IF not iwin.Visible THEN continue;
          iwin.Grid.CanClear:=TRUE;
          iwin.Grid.Refresh;

          FOR t:=iwin.Grid.LastDisplayed+1 TO iwin.Grid.RowCount-1 DO
          BEGIN
               s:=iwin.Grid.GetOldCell(1,t);
               IF s[length(s)]='!' THEN iwin.Grid.SetOldCell(1,t,iwin.Grid.Cells[1,t]+'!'); //Update value
          END;
          iwin.Grid.CanClear:=FALSE;
     END;

     IF SelfGrid <> NIL THEN IF SelfGrid.Visible THEN
     BEGIN
          SelfGrid.CanClear:=TRUE;
          SelfGrid.Refresh;

          FOR t:=SelfGrid.LastDisplayed+1 TO SelfGrid.RowCount-1 DO
          BEGIN
               s:=SelfGrid.Cells[1,t]; {!!}
               s:=SelfGrid.GetOldCell(1,t);
               IF s[length(s)]='!' THEN SelfGrid.SetOldCell(1,t,SelfGrid.Cells[1,t]+'!'); //Update value
          END;
          SelfGrid.Refresh;
          SelfGrid.CanClear:=FALSE;
     END;

     IF LocalsGrid <> NIL THEN
      IF LocalsGrid.Visible THEN LocalsGrid.UpdateVariables;

     IF UpdateAll THEN
     BEGIN
          IF InDebugger THEN UpdateWatchPoints;
          UpdateCallStackList;
          UpdateBreakpointList;
     END;
END;


PROCEDURE TAddWatchDlg.SetupComponent;
BEGIN
     Inherited SetupComponent;

     ClientWidth:=340;
     Height:=150;
     Caption:=LoadNLSStr(SiAddWatch);
     Entry:=InsertEdit(SELF,10,80,320,20,'','');
     Entry.Focus;
     InsertBitBtnNLS(SELF,10,22,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,22,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,22,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


PROCEDURE ViewWatch;
BEGIN
     ViewWatchProc;   {aktiviere das Debug Control Centre}
END;

PROCEDURE AddTheWatch(CONST s:STRING);
BEGIN
     IF WatchGrid = NIL THEN exit;

     WatchGrid.WatchList.Add(s);
     IF WatchGrid.WatchList.Count+2>WatchGrid.RowCount
     THEN WatchGrid.RowCount:=WatchGrid.WatchList.Count+2;
     WatchGrid.Invalidate;
END;

PROCEDURE AddWatch(CONST s,x:STRING);
VAR  WatchDlg:TAddWatchDlg;
BEGIN
     WatchDlg.Create(NIL);
     WatchDlg.HelpContext := hctxDialogAddWatch;
     WatchDlg.Entry.Text := s;
     WatchDlg.Entry.TextExtension := x;
     WatchDlg.Entry.SelectAll;
     IF WatchDlg.Execute THEN
     BEGIN
          ViewWatch;
          AddTheWatch('+' + WatchDlg.Entry.Text);
     END;
     WatchDlg.Destroy;
END;

PROCEDURE ViewLocalVariables;
BEGIN
     ViewLocalsProc;   {aktiviere das Debug Control Centre}
END;

PROCEDURE ViewSymbols;
BEGIN
     IF SymbolsWindow=NIL THEN
     BEGIN
          SymbolsWindow.Create(NIL);
          SymbolsWindow.HelpContext := hctxDialogSymbolsForm;
          SymbolsWindow.Show;
     END;
     SymbolsWindow.BringToFront;
     SymbolsWindow.Focus;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TInspectWindow Class implementation                         บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TInspectWindow.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiWatchWindow);
     Width:=350;
     Height:=150;

     Grid.Create(SELF);
     Grid.Align:=alClient;
     Grid.Parent:=SELF;

     InspectWindows.Add(SELF);

     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
END;


DESTRUCTOR TInspectWindow.Destroy;
BEGIN
     InspectWindows.Remove(SELF);

     Inherited Destroy;
END;


////////////////////////////////////////////////////////////////////////

FUNCTION Typ2Str(Typ:BYTE):STRING;
BEGIN
     CASE Typ OF
        TT_SHORTINT:Result:='ShortInt';
        TT_LONGINT:Result:='LongInt';
        TT_BYTE:Result:='Byte';
        TT_WORD:Result:='Word';
        TT_LONGWORD:Result:='LongWord';
        TT_INTEGER:Result:='Integer';
        TT_SINGLE:Result:='Single';
        TT_DOUBLE:Result:='Double';
        TT_EXTENDED:Result:='Extended';
        TT_STRING:Result:='String';
        TT_CSTRING:Result:='CString';
        TT_FILE:Result:='File';
        TT_BOOLEAN:Result:='Boolean';
        TT_WORDBOOL:Result:='WordBool';
        TT_LONGBOOL:Result:='LongBool';
        TT_TEXT:Result:='Text';
        TT_CHAR:Result:='Char';
        TT_POINTER:Result:='Pointer';
        TT_ANSISTRING:Result:='AnsiString';
        TT_RECORD:Result:='Record';
        TT_OBJECT:Result:='Object/Class';
        TT_SET:Result:='Set';
        ELSE result:='';
     END;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TEvalModDialog Class implementation                         บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TEvalModDialog=CLASS(TDialog)
         Expr:TComboBox;
         Value,NewValue:TEdit;
         ExeAddr,ValueLen:LONGWORD;
         ValueType:BYTE;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
     END;

VAR EvalModList:TStringList;

PROCEDURE TEvalModDialog.SetupShow;
VAR Cmd:TCommand;
BEGIN
     Expr.Focus;
     Inherited SetupShow;
     IF Expr.Text<>'' THEN
     BEGIN
          Cmd := cmOk;
          CommandEvent(Cmd);  //evaluate
     END;
END;

PROCEDURE TEvalModDialog.CommandEvent(VAR Command:TCommand);
VAR s1,s2:STRING;
    t:LONGINT;
LABEL l,found;
BEGIN
     CASE Command OF
        cmOk:{Evaluate}
        BEGIN
l:
             s1:=Expr.Caption;
             WHILE s1[length(s1)]=#32 do dec(s1[0]);
             WHILE ((length(s1)>0)AND(s1[1]=#32)) DO Delete(s1,1,1);
             Expr.Caption:=s1;
             UpcaseStr(s1);
             IF s1='' THEN goto found;
             FOR t:=0 TO EvalModList.Count-1 DO
             BEGIN
                  s2:=EvalModList.Strings[t];
                  UpcaseStr(s2);
                  IF s1=s2 THEN goto found;
             END;
             IF EvalModList.Count>10 THEN EvalModList.Delete(0);
             EvalModList.Add(Expr.Caption);
             Expr.Items.Add(Expr.Caption);
found:
             ParseValueFromExpr(Expr.Caption,s1,ExeAddr,ValueLen,ValueType);
             Value.Caption:=s1;
             NewValue.Caption:=s1;
             Command := cmNull;
        END;
        cmYes: {Modify}
        BEGIN
             IF SetValueFromExpr(NewValue.Caption,EXEAddr,ValueLen,ValueType) THEN
             BEGIN
                  UpdateWatchWindow(FALSE);
                  goto l;
             END
             ELSE ErrorBox(LoadNLSStr(SiErrorInExpression));
             Command := cmNull;
        END;
     END; {case}
END;


PROCEDURE TEvalModDialog.SetupComponent;
VAR  t:LONGINT;
     Button,Button1:TBitBtn;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiEvaluateModify);
     Width:=400;
     Height:=290;

     InsertLabel(SELF,10,230,200,20,LoadNLSStr(SiExpression)+':');
     Expr:=InsertComboBox(SELF,10,80,370,150,csDropDown);
     Expr.Sorted := TRUE;
     FOR t:=0 TO EvalModList.Count-1
        DO Expr.Items.Add(EvalModList.Strings[t]);
     InsertLabel(SELF,10,180,200,20,LoadNLSStr(SiValue)+':');
     Value:=InsertEdit(SELF,10,160,370,20,'','');
     InsertLabelNLS(SELF,10,120,200,20,SiNewValue);
     NewValue:=InsertEdit(SELF,10,100,370,20,'','');

     Button1:=InsertBitBtnNLS(SELF,40,22,100,30,bkOk,SiEvaluate,0); {Wird Default}
     Button1.ModalResult:=cmNull;
     Button:=InsertBitBtnNLS(SELF,150,22,100,30,bkYes,SiModify,0);
     Button.ModalResult:=cmNull;
     InsertBitBtnNLS(SELF,260,22,100,30,bkCancel,SiDone,0);
     Button1.Default:=TRUE;
END;

PROCEDURE EvaluateModify(s,x:STRING);
VAR EvalDlg:TEvalModDialog;
BEGIN
     EvalDlg.Create(NIL);
     EvalDlg.HelpContext := hctxDialogEvaluateModify;
     EvalDlg.Expr.Text := s;
     EvalDlg.Expr.TextExtension := x;
     EvalDlg.ShowModal;
     EvalDlg.Destroy;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TWatchGrid Class implementation                             บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TWatchGrid.SetupComponent;
BEGIN
     Inherited SetupComponent;

     DragMode := dmAutomatic;

     WatchList.Create;

     ColWidths[0]:=120;
     Options:=Options+[goColSizing,goRowSizing,goEditing,goAlwaysShowSelection];
     ScrollBars:=ssVertical;
     FixedCols:=0;
     FixedRows:=1;
     RowCount:=2;
     ColCount:=2;
     DefaultRowHeight:=Font.Height+8;
     Cells[0,0]:=LoadNLSStr(SiExpression);
     Cells[1,0]:=LoadNLSStr(SiValue);
END;


DESTRUCTOR TWatchGrid.Destroy;
BEGIN
     IF not IsLocalVarView THEN
     BEGIN
          IF InspectValue = '' THEN WatchGrid := NIL;
     END;
     WatchList.Destroy;
     IF InspectList <> NIL THEN InspectList.Destroy;

     Inherited Destroy;
END;


PROCEDURE TWatchGrid.Resize;
BEGIN
     IF Parent <> NIL THEN ColWidths[1] := Width - ColWidths[0];

     Inherited Resize;
END;


FUNCTION TWatchGrid.GetCell(Col,Row:LONGINT):STRING;
VAR Enabled:BOOLEAN;
    s,s1:STRING;
    ExeAddr,ValueLen:LONGWORD;
    ValueType:BYTE;
    TypeList,dummy:PTypeList;
    Typ:Byte;
    t:LongInt;
    Col1,Row1:LONGINT;
LABEL l,l1,err;
BEGIN
     IF ColWidths[1]<>Width-ColWidths[0] THEN
     BEGIN
          ColWidths[1]:=Width-ColWidths[0];
          Resize;
     END;

     IF Row=0 THEN
     BEGIN
          result:=Inherited GetCell(Col,Row);
          IF InspectValue<>'' THEN goto l1;
     END
     ELSE IF ((InspectValue='')AND(Row-1>=WatchList.Count)) THEN result:=''
     ELSE
     BEGIN
          IF InspectValue<>'' THEN  //Inspect window
          BEGIN
               IF ((Row>LastInspected)AND(WatchList<>NIL)AND(InspectList<>NIL)AND
                   (WatchList.Count>0)AND(InspectList.Count>0)) THEN
               BEGIN
l:
                    IF ((Row-1>WatchList.Count-1)OR(Row-1>InspectList.Count-1)) THEN result:=''
                    ELSE
                    BEGIN
                         IF Col=0 THEN result:=WatchList[Row-1]
                         ELSE
                         BEGIN
                              result:=InspectList[Row-1];
                              {
                              s:=Inherited GetCell(Col,Row);

                              IF ((s='')OR(s[length(s)]='>')OR(result[length(result)]='>')) THEN Inherited SetCell(Col,Row,result)
                              ELSE IF ((s<>result)AND(s<>'!')) THEN
                              BEGIN
                                   IF s[length(s)]='!' THEN
                                   BEGIN
                                        IF Grid.CanClear THEN
                                        BEGIN
                                            dec(s[0]);
                                            IF s<>result THEN Inherited SetCell(Col,Row,'!') //This value changed
                                            ELSE Inherited SetCell(Col,Row,result);
                                        END;
                                   END
                                   ELSE Inherited SetCell(Col,Row,'!'); //This value changed
                              END;
                              }
                         END;
                    END;
               END
               ELSE
               BEGIN
                    //re-read list
l1:
                    LastInspected:=Row;

                    TypeList:=GetTypeInfoFromExpr(InspectValue,InspectAddr,Typ);
                    IF InspectTyp=0 THEN
                      IF TypeList<>NIL THEN
                    BEGIN
                         InspectTyp:=Typ;
                         {update Title of Desktop Form}
                         IF Parent IS TForm
                         THEN Parent.Caption:=Parent.Caption+' ('+Typ2Str(Typ)+')';
                    END;

                    //Check if WatchList and TypeList match
                    dummy:=TypeList;
                    FOR t:=0 TO WatchList.Count-1 DO
                    BEGIN
                         IF dummy=NIL THEN goto err;
                         IF dummy^.Name^<>'' THEN
                         BEGIN
                              IF dummy^.Name^<>WatchList[t] THEN goto err;
                         END
                         ELSE
                         BEGIN
                              IF InspectValue<>WatchList[t] THEN goto err;
                         END;

                         dummy:=dummy^.Next;
                    END;

                    IF dummy<>NIL THEN goto err;
                    IF RowCount<>WatchList.Count+1 THEN goto err;

                    //the lists match
                    dummy:=TypeList;
                    Col1:=1;
                    Row1:=1;
                    while dummy<>NIL DO
                    BEGIN
                         s1:=dummy^.Value^;
                         s:=Inherited GetCell(Col1,Row1);

                         IF ((s='')OR(s[length(s)]='>')OR(s1[length(s1)]='>')) THEN Inherited SetCell(Col1,Row1,s1)
                         ELSE IF ((s<>s1)AND(s<>'!')) THEN
                         BEGIN
                              IF s[length(s)]='!' THEN
                              BEGIN
                                   IF CanClear THEN
                                   BEGIN
                                        dec(s[0]);
                                        IF s<>s1 THEN Inherited SetCell(Col1,Row1,'!') //This value changed
                                        ELSE Inherited SetCell(Col1,Row1,s1);
                                   END;
                              END
                              ELSE Inherited SetCell(Col1,Row1,'!'); //This value changed
                         END;

                         dummy:=dummy^.Next;
                         inc(Row1);
                    END;

err:
                    WatchList.Clear;
                    IF InspectList<>NIL THEN InspectList.Clear
                    ELSE InspectList.Create;

                    WHILE TypeList<>NIL DO
                    BEGIN
                         IF TypeList^.Name^='' THEN WatchList.Add(InspectValue)
                         ELSE WatchList.Add(TypeList^.Name^);
                         InspectList.Add(TypeList^.Value^);
                         TypeList:=TypeList^.Next;
                    END;

                    FreeTypeList;

                    IF RowCount<>WatchList.Count+1 THEN RowCount:=WatchList.Count+1;
                    IF Row>0 THEN goto l;
               END;
          END
          ELSE
          BEGIN
               IF Col=0 THEN {Expression}
               BEGIN
                    result:=WatchList[Row-1];
                    Delete(Result,1,1);
               END
               ELSE {Value}
               BEGIN
                    s:=WatchList[Row-1];
                    Enabled:=s[1]='+';
                    Delete(s,1,1);
                    IF Enabled THEN
                    BEGIN
                         ParseValueFromExpr(s,result,ExeAddr,ValueLen,ValueType);

                         s:=Inherited GetCell(Col,Row);
                         IF ((s='')OR(s[length(s)]='>')OR(result[length(result)]='>')) THEN Inherited SetCell(Col,Row,result)
                         ELSE IF ((s<>result)AND(s<>'!')) THEN
                         BEGIN
                              IF s[length(s)]='!' THEN
                              BEGIN
                                   IF CanClear THEN
                                   BEGIN
                                        dec(s[0]);
                                        IF s<>result THEN Inherited SetCell(Col,Row,'!') //This value changed
                                        ELSE Inherited SetCell(Col,Row,result);
                                   END;
                              END
                              ELSE Inherited SetCell(Col,Row,'!'); //This value changed
                         END;
                    END
                    ELSE result:='<Disabled>';
               END;
          END;
     END;
END;

PROCEDURE TWatchGrid.SetCell(Col,Row:LONGINT;CONST NewContent:STRING);
VAR s,s1:STRING;
    ValueType:BYTE;
    ValueLen,ExeAddr:LONGWORD;
BEGIN
     IF Row=0 THEN Inherited SetCell(Col,Row,NewContent)
     ELSE
     BEGIN
          IF Col=0 THEN {Expression}
          BEGIN
               IF IsLocalVarView THEN exit;  //don't set !

               IF InspectValue<>'' THEN
               BEGIN
                    IF not (InspectTyp IN [TT_RECORD,TT_OBJECT]) THEN s:=NewContent
                    ELSE s:=InspectValue+'.'+NewContent;
                    InspectValue:=s;
                    {update Title of Desktop Form}
                    IF Parent IS TForm
                    THEN Parent.Caption:=LoadNLSStr(SiInspecting)+':'+s;
                    InspectTyp:=0;
                    Refresh;
               END
               ELSE
               BEGIN
                   IF Row>WatchList.Count THEN
                   BEGIN
                       WatchList.Add('+'+NewContent);
                       RowCount:=Row+2;
                   END
                   ELSE
                   BEGIN
                       WatchList[Row-1]:='+'+NewContent;
                       Invalidate;
                   END;
               END;
          END
          ELSE {Value}
          BEGIN
               IF Row>WatchList.Count THEN exit;  //no expression

               IF InspectValue='' THEN
               BEGIN
                    s:=WatchList[Row-1];
                    Delete(s,1,1);
               END
               ELSE s:=InspectValue+'.'+WatchList[Row-1];

               ParseValueFromExpr(s,s1,ExeAddr,ValueLen,ValueType);
               SetValueFromExpr(NewContent,ExeAddr,ValueLen,ValueType);
               Inherited SetCell(Col,Row,NewContent);  //New Value
               UpdateWatchWindow(FALSE);
          END;
     END;
END;

{$HINTS OFF}
PROCEDURE TWatchGrid.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR Entry:TMenuItem;
    SubEntry:TMenuItem;
    t:LONGINT;
    s:STRING;
    pt:TPoint;
    SelectedItem:LONGINT;
BEGIN
     Inherited MouseClick(Button,ShiftState,X,Y);

     IF Button <> mbRight THEN exit;

     IF IsLocalVarView THEN exit;

     IF Popup=NIL THEN
     BEGIN
          Popup.Create(SELF);

          IF InspectValue='' THEN
          BEGIN
               Entry.Create(Popup);
               Entry.Caption:=LoadNLSStr(SiWatchPopupAddWatch);
               Entry.Command:=cmOpen;
               Entry.HelpContext := hctxPopupWatchAddWatch;
               Popup.Items.Add(Entry);

               Entry.Create(Popup);
               Entry.Caption:=LoadNLSStr(SiWatchPopupRemoveWatch);
               Entry.Command:=cmCut;
               Entry.HelpContext := hctxPopupWatchRemoveWatch;
               Popup.Items.Add(Entry);

               Entry.Create(Popup);
               Entry.Caption:='-';
               Popup.Items.Add(Entry);

               Entry.Create(Popup);
               Entry.Caption:=LoadNLSStr(SiWatchPopupRemoveAllWatches);
               Entry.Command:=cmSave;
               Entry.HelpContext := hctxPopupWatchRemoveAllWatches;
               Popup.Items.Add(Entry);

               Entry.Create(Popup);
               Entry.Caption:='-';
               Popup.Items.Add(Entry);
          END;

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiWatchPopupInspectValue);
          Entry.Command:=cmCopy;
          Entry.HelpContext := hctxPopupWatchInspectValue;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiWatchPopupChangeValue);
          Entry.Command:=cmPaste;
          Entry.HelpContext := hctxPopupWatchChangeValue;
          Popup.Items.Add(Entry);

          IF InspectValue='' THEN
          BEGIN
              Entry.Create(Popup);
              Entry.Caption:='-';
              Popup.Items.Add(Entry);

              EntryEnabled.Create(Popup);
              EntryEnabled.Caption:=LoadNLSStr(SiWatchPopupItemEnabled);
              EntryEnabled.Command:=cmOk;
              EntryEnabled.HelpContext := hctxPopupWatchItemEnabled;
              Popup.Items.Add(EntryEnabled);
          END
          ELSE EntryEnabled := NIL;
     END;

     SelectedItem:=Row-1;
     IF ((SelectedItem<0)OR(SelectedItem>WatchList.Count-1)) THEN SelectedItem:=-1;

     IF SelectedItem=-1 THEN
     BEGIN
          Popup.DisableCommands([cmCopy,cmPaste,cmOk,cmCut,cmYes]);
          IF EntryEnabled <> NIL THEN EntryEnabled.Checked:= FALSE;
     END
     ELSE
     BEGIN
          Popup.EnableCommands([cmCopy,cmPaste,cmOk,cmCut,cmYes]);
          s:=WatchList.Strings[SelectedItem];
          IF InspectValue='' THEN
          BEGIN
               IF EntryEnabled <> NIL THEN EntryEnabled.Checked := s[1]='+';
               IF s[1]<>'+' THEN Popup.DisableCommands([cmCopy,cmPaste]);
          END
          ELSE
          BEGIN
               IF not (InspectTyp IN [TT_RECORD,TT_OBJECT])
               THEN Popup.DisableCommands([cmCopy]);
          END;
     END;

     IF WatchList.Count = 0 THEN Popup.DisableCommands([cmSave])
     ELSE Popup.EnableCommands([cmSave]);


     pt := ClientToScreen(Point(X,Y));
     Popup.Popup(pt.X,pt.Y);
END;

PROCEDURE TWatchGrid.ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);
VAR  Cmd:TCommand;
BEGIN
     CASE KeyCode OF
       kbDel:
       BEGIN
            IF not IsLocalVarView THEN
              IF InspectValue = '' THEN
              BEGIN
                   Cmd := cmCut;
                   CommandEvent(Cmd);
                   KeyCode := kbNull;
              END;
       END;
       ELSE Inherited ScanEvent(KeyCode,RepeatCount);
     END;
END;


FUNCTION TWatchGrid.DragValid(ExtDDO:TExternalDragDropObject):BOOLEAN;
VAR FName:STRING;
BEGIN
     result:=FALSE;
     result:=TRUE;
     IF ExtDDO.SupportedOps * [doCopyable,doMoveable] = [] THEN exit;
     IF ExtDDO.DragOperation IN [doLink,doUnknown] THEN exit;
     IF ExtDDO.SourceType<>drtText THEN exit;
     IF ExtDDO.RenderType <> drmFile THEN exit;
     FName := ExtDDO.ContainerName;
     IF FName <> '' THEN
     IF FName[Length(FName)] <> '\' THEN FName := FName + '\';
     FName := FName + ExtDDO.SourceFileName;
     IF FName=FTempFileName THEN exit;
     IF not FileExists(FName) THEN exit;
END;

PROCEDURE TWatchGrid.DragOver(Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);
VAR  ExtDDO:TExternalDragDropObject;
BEGIN
     Accept := FALSE;
     IF Source IS TExternalDragDropObject THEN
     BEGIN
          ExtDDO := TExternalDragDropObject(Source);
          Accept:= DragValid(ExtDDO);
     END
     ELSE Inherited DragOver(Source,X,Y,State,Accept);
END;

PROCEDURE TWatchGrid.DragDrop(Source:TObject;X,Y:LONGINT);
VAR  ExtDDO:TExternalDragDropObject;
     s,FName:STRING;
     f:System.TEXT;
BEGIN
     IF Source IS TExternalDragDropObject THEN
     BEGIN
          ExtDDO := TExternalDragDropObject(Source);
          IF not DragValid(ExtDDO) THEN exit;
          FName := ExtDDO.ContainerName;
          IF FName <> '' THEN
          IF FName[Length(FName)] <> '\' THEN FName := FName + '\';
          FName := FName + ExtDDO.SourceFileName;
          System.Assign(f,FName);
          {$I-}
          Reset(f);
          Readln(f,s);
          Close(f);
          {$I+}
          IF (InspectValue <> '') AND (SELF <> SelfGrid) THEN
          BEGIN
               InspectValue:=s;
               {update Title of Desktop Form}
               IF Parent IS TForm
               THEN Parent.Caption:=LoadNLSStr(SiInspecting)+':'+s;
               InspectTyp:=0;
               Refresh;
          END
          ELSE
          BEGIN
               ViewWatch;
               AddTheWatch('+'+s);
          END;
     END
     ELSE Inherited DragDrop(Source,X,Y);
END;

PROCEDURE TWatchGrid.CanDrag(X,Y:LONGINT;VAR Accept:BOOLEAN);
VAR SelectedItem:LONGINT;
    s:STRING;
BEGIN
     SelectedItem:=Row-1;
     IF ((SelectedItem<0)OR(SelectedItem>WatchList.Count-1)) THEN SelectedItem:=-1;
     Accept:=SelectedItem>=0;
     Inherited CanDrag(X,Y,Accept);
END;

PROCEDURE TWatchGrid.DoStartDrag(VAR DragData:TDragDropData);
VAR SelectedItem:LONGINT;
    s,dir,name,ext:STRING;
    utF:System.TEXT;
BEGIN
     Inherited DoStartDrag(DragData);

     SelectedItem:=Row-1;
     IF ((SelectedItem<0)OR(SelectedItem>WatchList.Count-1)) THEN exit;

     s:=WatchList[SelectedItem];
     IF InspectValue<>'' THEN
     BEGIN
          IF not (InspectTyp IN [TT_RECORD,TT_OBJECT]) THEN s:=InspectValue
          ELSE s:=InspectValue+'.'+s
     END
     ELSE Delete(s,1,1); //Delete +/-

     FTempFileName := GetTempFileName;
     System.Assign(utF,FTempFileName);
     {$i-}
     Rewrite(utF);
     IF InOutRes <> 0 THEN
     BEGIN
          FTempFileName := 'temp0001.tmp';
          System.Assign(utF,FTempFileName);
          Rewrite(utF);
     END;

     IF InOutRes = 0 THEN
     BEGIN
          Writeln(utF,s);
          IF InOutRes<>0 THEN exit;
          System.Close(utF);
          IF InOutRes<>0 THEN exit;
     END
     ELSE exit;
     {$i+}

     FSplit(FTempFileName,dir,name,ext);
     DragData.SourceWindow := Handle;
     DragData.SourceType := drtText;
     DragData.RenderType := drmFile;
     DragData.ContainerName := dir;
     DragData.SourceFileName := name + ext;
     DragData.TargetFileName := '';
     DragData.SupportedOps := [doCopyable,doMoveable];
     DragData.DragOperation := doCopy;
END;

PROCEDURE TWatchGrid.DoEndDrag(Target:TObject; X,Y:LONGINT);
VAR  utF:FILE;
BEGIN
     Inherited DoEndDrag(Target,X,Y);

     {delete temporary file}
     System.Assign(utF,FTempFileName);
     {$i-}
     Erase(utF);
     {$i+}
     FTempFileName := '';
END;

PROCEDURE TWatchGrid.SetupCellColors(Col,Row:LongInt;AState:TGridDrawState;VAR Background,ForeGround:TColor);
VAR s:STRING;
BEGIN
     Inherited SetupCellColors(Col,Row,AState,Background,Foreground);

     LastDisplayed:=Row;
     IF ((Col=1)AND(Row>0)) THEN
     BEGIN
         s:=Inherited GetCell(Col,Row);
         IF s[length(s)]='!' THEN
         BEGIN
             Foreground:=clRed;  //changed entry
             IF CanClear THEN Inherited SetCell(Col,Row,Cells[Col,Row]+'!'); //Update value
         END;
     END;
END;

FUNCTION TWatchGrid.GetOldCell(Col,Row:Longint):STRING;
BEGIN
     result:=Inherited GetCell(Col,Row);
END;

PROCEDURE TWatchGrid.SetOldCell(Col,Row:LongInt;CONST s:STRING);
BEGIN
     Inherited SetCell(Col,Row,s);
END;


PROCEDURE TWatchGrid.CommandEvent(VAR Command:TCommand);
VAR s:STRING;
    b:BYTE;
    SelectedItem:LONGINT;
    MsgHandled:BOOLEAN;
BEGIN
     SelectedItem:=Row-1;

     MsgHandled:=TRUE;
     CASE Command OF
        cmOpen:  //Add watch
        BEGIN
             AddWatch('','');
        END;
        cmCut:  //Remove watch
        BEGIN
             IF ((SelectedItem<0)OR(SelectedItem>WatchList.Count-1)) THEN exit;
             WatchList.Delete(SelectedItem);
             RowCount:=WatchList.Count+2;
             Invalidate;
        END;
        cmSave: //Remove all watches
        BEGIN
             IF MessageBox(LoadNLSStr(SiRemoveAllWatches),mtConfirmation,mbYesNoCancel)=mrYes THEN
             BEGIN
                  WatchList.Clear;
                  RowCount:=2;
                  Invalidate;
             END;
        END;
        cmCopy:  //Inspect
        BEGIN
             IF ((SelectedItem<0)OR(SelectedItem>WatchList.Count-1)) THEN exit;
             s:=WatchList.Strings[SelectedItem];
             IF InspectValue='' THEN Delete(s,1,1)
             ELSE
             IF ((InspectTyp=TT_RECORD)OR(InspectTyp=TT_OBJECT)) THEN
             BEGIN
                  IF s<>'' THEN s:=InspectValue+'.'+s
                  ELSE s:=InspectValue;
             END
             ELSE exit;
             AddInspectWin(s);
        END;
        cmPaste: //Change value
        BEGIN
             IF ((SelectedItem<0)OR(SelectedItem>WatchList.Count-1)) THEN exit;
             s:=WatchList.Strings[SelectedItem];
             IF InspectValue<>'' THEN
             BEGIN
                  b:=pos(' ',s);
                  s[0]:=chr(b-1);
                  IF s<>'' THEN s:=InspectValue+'.'+s
                  ELSE s:=InspectValue;
             END
             ELSE Delete(s,1,1);
             EvaluateModify(s,'');
        END;
        cmOk:    //disable/enable
        BEGIN
             IF ((SelectedItem<0)OR(SelectedItem>WatchList.Count-1)) THEN exit;
             s:=WatchList.Strings[SelectedItem];
             IF s[1]='+' THEN s[1]:='-'
             ELSE s[1]:='+';
             WatchList.Strings[SelectedItem]:=s;
             Invalidate;
        END;
        ELSE MsgHandled := FALSE;
     END; //case

     IF MsgHandled THEN Command := cmNull;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TLocalsGrid Class implementation                            บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TLocalsGrid.SetupComponent;
BEGIN
     Inherited SetupComponent;

     IsLocalVarView:=TRUE;
     Cells[0,0]:=LoadNLSStr(SiVariable);

     UpdateVariables;
END;

PROCEDURE TLocalsGrid.UpdateVariables;
VAR  s:STRING;
     Locals,p:PLocalVars;
     t:LONGINT;
BEGIN
     IF InDebugger THEN
     BEGIN
          //Liste vom Debugger holen
          s:=LastProc;
          Locals:=GetLocalVars(s);   {ist VAR Parameter}

          IF ((LastProc='')OR(s<>LastProc)) THEN
          BEGIN  //other proc, get a list of all local variables into WatchList
               WatchList.Clear;

               p:=Locals;
               WHILE p<>NIL DO
               BEGIN
                    WatchList.Add('+'+p^.Name);
                    p:=p^.Next;
               END;
               LastProc:=s;
               RowCount:=WatchList.Count+1;
          END;
          FreeLocalVars(Locals);

          CanClear:=TRUE;
          Refresh;

          FOR t:=LastDisplayed+1 TO RowCount-1 DO
          BEGIN
               s:=Cells[1,t]; {!!}
               s:=GetOldCell(1,t);
               IF s[length(s)]='!' THEN SetOldCell(1,t,Cells[1,t]+'!'); //Update value
          END;

          Refresh;
          CanClear:=FALSE;
     END
     ELSE
     BEGIN
          //alles l”schen
          RowCount:=1;
     END;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TBreakpoinsListBox Class implementation                     บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE UpdateBreakpointList;
BEGIN
     IF BPList <> NIL THEN BPList.UpdateBreaks;
END;


PROCEDURE TBreakPointsListBox.SetupComponent;
BEGIN
     Inherited SetupComponent;

     UpdateBreaks;

     OnItemSelect:=TrackSource;
END;


PROCEDURE TBreakPointsListBox.UpdateBreaks;
VAR Edit:TBaseEditor;
    i,y:LONGINT;
    pl:PLine;
    s,d,n,e:STRING;
    Breaks:PBreakPoints;
    LineNum:WORD;
    Module:PModuleInfo;
    a:LONGWORD;
    b:BYTE;
BEGIN
     BeginUpdate;
     Clear;

     IF InDebugger THEN
     BEGIN
          //Liste vom Debugger holen
          Breaks:=GetBreakPoints;
          WHILE Breaks<>NIL DO
          BEGIN
               IF Breaks^.Typ=0 THEN //nur "real" breaks !
               BEGIN
                    SearchLineNum(Breaks^.LinearAddr,TRUE,s,LineNum,Module);
                    FSplit(s,d,n,e);
                    Items.Add(n+e+'('+tostr(LineNum)+') '+LoadNLSStr(SiAtLinearAdress)+' '+tohex(Breaks^.LinearAddr));
               END;

               Breaks:=Breaks^.Next;
          END;

          GetNextDbgBrkInfo(a,b);
          IF a<>0 THEN IF b=0 THEN
          BEGIN
               SearchLineNum(a,TRUE,s,LineNum,Module);
               FSplit(s,d,n,e);
               Items.Add(n+e+'('+tostr(LineNum)+') '+LoadNLSStr(SiAtLinearAdress)+' '+tohex(a));
          END;
     END
     ELSE
     BEGIN
          FOR i := 0 TO CodeEditorRef.MDIChildCount-1 DO
          BEGIN
               Edit := TBaseEditor(CodeEditorRef.MDIChildren[i]);
               IF Edit IS TBaseEditor THEN
               BEGIN
                    pl:=Edit.FirstLine;
                    FOR y:=1 TO Edit.CountLines DO
                    BEGIN
                         IF pl^.flag AND ciBreakPointLine <> 0 THEN
                         BEGIN
                              FSplit(Edit.FileName,d,n,e);
                              Items.Add(n+e+'('+tostr(y)+')');
                         END;
                         pl := pl^.next;
                    END;
               END;
          END;

          //anderen Elemente der Brakpointliste hinzufgen
          FOR i := 0 TO BreakPointList.Count-1 DO
          BEGIN
               IF BreakPointList.States[i] = bpsCleared THEN continue;

               s := BreakPointList.FileNames[i];
               IF GetEditorProc(s) <> NIL THEN continue; //schon erledigt
               y := BreakPointList.Lines[i];

               FSplit(s,d,n,e);
               Items.Add(n+e+'('+tostr(y)+')');
          END;
     END;

     EndUpdate;
END;


PROCEDURE TBreakPointsListBox.TrackSource(Sender:TObject;Index:LONGINT);
VAR s:STRING;
    b,b1:BYTE;
    Line:LONGINT;
    Editor:TBaseEditor;
    pt:TEditorPos;
    c:Integer;
BEGIN
     s:=Items[Index];
     b:=pos('(',s);
     IF b=0 THEN exit;
     s:=copy(s,1,b-1);  //extract file name

     Editor:=OpenSourceFile(s,TRUE);
     IF Editor=NIL THEN exit;

     s:=Items[Index];
     Delete(s,1,b);
     b:=pos(')',s);
     s[0]:=chr(b-1);
     VAL(s,Line,c);
     IF c<>0 THEN exit;

     pt.x := 1;
     pt.y := Line;
     Editor.BeginUpdate;
     Editor.GotoPosition(pt);
     Editor.InvalidateEditor(0,0);
     Editor.EndUpdate;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TSymbolsWindow Class implementation                         บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


PROCEDURE TSymbolsWindow.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiPublicSymbols);
     Width:=300;
     Height:=200;
     FTree.Create(SELF);
     FTree.Align:=alClient;
     FTree.OnItemSelect:=OutlineItemSelected;
     FTree.Parent:=SELF;

     UpdateSymbols;

     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
END;

DESTRUCTOR TSymbolsWindow.Destroy;
BEGIN
     Inherited Destroy;

     SymbolsWindow:=NIL;
END;

PROCEDURE TSymbolsWindow.UpdateSymbols;
VAR
   ModLoaded:PModulesLoaded;
   ModInfo:PModuleInfo;
   MainCount,SubCount:LONGINT;
   MainIndex,SubIndex:LONGINT;
   Publics:PPublicsInfo;
   s:STRING;
   Data:LONGWORD;
   Strings,Mains:TStringList;
   t,Count:LONGINT;
BEGIN
     Screen.Cursor:=crHourGlass;
     FTree.BeginUpdate;

     FTree.Clear;

     IF InDebugger THEN
     BEGIN
          ModLoaded:=GetModulesLoaded;
          MainCount:=0;
          WHILE ModLoaded<>NIL DO
          BEGIN
               MainIndex:=FTree.Add(MainCount,ModLoaded^.Name);
               MainCount:=MainIndex;

               Count:=0;
               Mains.Create;
               Mains.Sorted:=TRUE;
               ModInfo:=ModLoaded^.DebugModules;
               WHILE ModInfo<>NIL DO
               BEGIN
                    Mains.Objects[Mains.Add(ModInfo^.SourceFile)]:=Pointer(ModInfo^.PublicsInfo);
                    ModInfo:=ModInfo^.Next;
               END;

               FOR Count:=0 TO Mains.Count-1 DO
               BEGIN
                    SubIndex:=FTree.AddChild(MainIndex,Mains[Count]);

                    Publics:=Pointer(Mains.Objects[Count]);
                    Strings.Create;
                    Strings.Sorted:=TRUE;
                    WHILE Publics<>NIL DO
                    BEGIN
                         s:=Publics^.PublicName^;
                         IF s<>'' THEN IF s[1]<>'!' THEN
                         BEGIN
                              IF Publics^.ObjectIndex=1 THEN Data:=Publics^.Offset //Procedure Offset
                              ELSE Data:=1;
                              Strings.Objects[Strings.Add(s)]:=Pointer(Data);
                         END;
                         Publics:=Publics^.Next;
                    END;

                    FOR t:=0 TO Strings.Count-1 DO FTree.AddChildObject(SubIndex,Strings[t],Strings.Objects[t]);
                    Strings.Destroy;
               END;

               Mains.Destroy;
               ModLoaded:=ModLoaded^.Next;
          END;
     END;

     FTree.EndUpdate;
     Screen.Cursor:=crDefault;
END;

PROCEDURE TSymbolsWindow.OutlineItemSelected(Sender:TObject;Index:LONGINT);
VAR Node:TOutlineNode;
    Data:LONGWORD;
    s:STRING;
    Line:WORD;
    Module:PModuleInfo;
    Editor:TBaseEditor;
    pt:TEditorPos;
BEGIN
     Node:=FTree.Items[Index];
     IF Node=NIL THEN exit;
     Data:=LONGWORD(Node.Data);
     s:=Node.Text;
     IF Data>1 THEN //Procedure
     BEGIN
          //Search source location of procedure
          SearchLineNum(Data,TRUE,s,Line,Module);
          IF Line<>0 THEN
          BEGIN
               Editor:=OpenSourceFile(s,TRUE);
               IF Editor=NIL THEN exit;
               pt.x := 1;
               pt.y := Line;
               Editor.BeginUpdate;
               Editor.GotoPosition(pt);
               Editor.InvalidateEditor(0,0);
               Editor.EndUpdate;
          END;
     END
     ELSE IF Data<>0 THEN //Data
     BEGIN
          IF pos('.',s)<>0 THEN Delete(s,1,pos('.',s));
          AddWatch(s,'');
     END;
END;

BEGIN
     EvalModList.Create;
     InspectWindows.Create;
     WatchPointList.Create;
     UpdateBreakpointListProc := @UpdateBreakpointList;
END.



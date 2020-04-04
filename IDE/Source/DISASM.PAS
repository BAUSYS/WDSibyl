
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

Unit disasm;

Interface

{$IFDEF OS2}
Uses BseDos,BseExcpt,PmWin;
{$ENDIF}

Uses DbgWatch,SysUtils,Dos,Color,Classes,Forms,Graphics,Buttons,StdCtrls,Dialogs,Editors,
     Consts,DAsm,BaseEdit,DebugHlp,DbgWatch,Projects,BaseForm,
     Sib_Prj,TabCtrls,Sib_Ctrl,
     Menus, Messages,
     uString, uList;

Type
    TDumpField=CLASS(TControl)
         DumpVertScroll:TScrollBar;
         DumpAddr:LONGWORD;
         ContentStyle:TDumpContents;
         Popup:TPopupMenu;
         LastDumpRecValid:BOOLEAN;
         LastDumpRec,LastDumpRec1:TRect;
         LastDumpChar:BOOLEAN;
         DumpChangeAdr:LONGWORD;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE Redraw(CONST rec:TRect);OVERRIDE;
         PROCEDURE Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);OVERRIDE;
         PROCEDURE MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE CharEvent(VAR Key:CHAR;RepeatCount:BYTE);OVERRIDE;
         PROCEDURE ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
         PROCEDURE DumpChange(s:STRING);
         PROCEDURE KillFocus;OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
    END;

    TDumpNoteBook=Class(TTabbedNoteBook)
         DumpField:TDumpField;
         StackListBox:TListBox;

         DumpPage:TPage;
         SourcePage:TPage;
         ThreadsPage:TPage;
         StackPage:TPage;

         PROCEDURE AddStackItem(LinearAddr:LONGWORD);
         PROCEDURE UpdateStack;
         PROCEDURE DumpNoteBookOnResize(Sender:TObject);
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE Update;OVERRIDE; {Name war da}
         PROCEDURE ActivateAPage(Sender:TObject);
         PROCEDURE StackItemSelected(Sender:TObject;Index:LongInt);
    End;

    TBottomToolBar=Class(TToolBar)
         DumpNoteBook:TDumpNoteBook;
         PROCEDURE SetupComponent;Override;
    End;

TYPE TVisibleCPURegisters=(_CpuStart,_EAX,_EBX,_ECX,_EDX,_ESP,_EBP,_ESI,_EDI,_EIP,_EFLAGS,_FLAGS1,_FLAGS2,
                           _SS,_CS,_DS,_ES,_FS,_GS,_CpuEnd);

     TVisibleCPUFlags=(_CF,_ZF,_SF,_OF,_PF,_AF,_TF,_DF);

     TVisibleFPURegisters=(_FpuStart,_FPCW,_FPUFLAGS1,_FPUFLAGS2,_RC,_PC,_FPSW,_FPUFLAGS3,_FPUFLAGS4,
                           _TOS,_ST0,_ST1,_ST2,_ST3,_ST4,_ST5,_ST6,_ST7,_FpuEnd);

     TVisibleFPUFlags=(F_PM,F_UM,F_OM,F_ZM,F_DM,F_IM,F_PE,F_UE,F_OE,F_ZE,F_DE,F_IE,F_SF,F_ES,F_B);

CONST VisibleCPURegisters:ARRAY[_EAX.._GS] OF STRING[3]=
         ('EAX','EBX','ECX','EDX','ESP','EBP','ESI','EDI','EIP','EFL','','',
          'SS','CS','DS','ES','FS','GS');
      VisibleCPUFlags:ARRAY[_CF.._DF] OF STRING[2]=
         ('CF','ZF','SF','OF','PF','AF','TF','DF');
      VisibleFPURegisters:ARRAY[_FPCW.._ST7] OF STRING[5]=
         ('FPCW','','','RC','PC','FPSW','','','TOS','ST0','ST1','ST2',
          'ST3','ST4','ST5','ST6','ST7');
      VisibleFPUFlags:ARRAY[F_PM..F_B] OF STRING[2]=
         ('PM','UM','OM','ZM','DM','IM','PE','UE','OE','ZE','DE','IE','SF','ES','B');

TYPE
    TCPURegisterSet=RECORD
         EAX,EBX,ECX,EDX,ESI,EDI,EBP,ESP,EFLAGS,EIP:LONGINT;
         CS,DS,ES,FS,GS,SS:WORD;
    END;

    TRegisterNoteBook=Class(TTabbedNoteBook)
         CPURegistersValid:BOOLEAN;
         CPURegisters:TCPURegisterSet;
         CPUUpScrolled:TVisibleCPURegisters;
         CPUDownScrolled:TVisibleCPURegisters;
         CPUVertScrollBar:TScrollBar;

         FPUUpScrolled:TVisibleFPURegisters;
         FPUDownScrolled:TVisibleFPURegisters;
         FPUVertScrollBar:TScrollBar;
         FPURegisters:TCoproBuf;
         FPURegistersValid:BOOLEAN;

         CPUPage:TPage;
         FPUPage:TPage;

         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE RegisterNoteBookOnResize(Sender:TObject);
         PROCEDURE PaintPage(Sender:TObject;CONST rec:TRect);
         PROCEDURE PageScroll(Sender:TObject;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
         FUNCTION GetCPUReg(Reg:TVisibleCPURegisters):STRING;
         FUNCTION GetFPUReg(Reg:TVisibleFPURegisters):STRING;
         FUNCTION GetCPUFlag(Flag:TVisibleCPUFlags):BOOLEAN;
         FUNCTION GetFPUFlag(Flag:TVisibleFPUFlags):BOOLEAN;
    End;

    TRightToolBar=Class(TToolBar)
         RegisterNoteBook:TRegisterNoteBook;

         PROCEDURE SetupComponent;OVERRIDE;
    End;

    TCPUWindow=Class(TSibylForm)
         BottomToolBar:TBottomToolBar;
         RightToolBar:TRightToolBar;
         LeftScrolled:LONGINT;
         CodeUpScrolled:LONGINT;
         CurrentAddress:LONGWORD;
         ClientAddrList:TList;                  {Visible adress items}
         BreakpointList:TDebugBreakpointList;   {List holding breakpoint addresses}
         SelectedAddr:LONGWORD;
         ToolBar:TToolBar;
         InActiveBmp,ActiveBmp:TBitmap;
         //ToolBarButtons:ARRAY[1..4] OF TBitBtn;
         ToolBarButtons:ARRAY[1..4] OF TXPLButton;
         Popup:TPopupMenu;

         PROCEDURE Redraw(CONST rec:TRect);OVERRIDE;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);OVERRIDE;
         PROCEDURE InitCPUList(EIP:LONGWORD);
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         FUNCTION ChangeState(pt:TPoint):BOOLEAN;
         PROCEDURE RunToAddr;
         PROCEDURE UnmarkBreakpointAtEIP;
         PROCEDURE RemarkAllBreaks;
         PROCEDURE UnloadNotify;
         PROCEDURE ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
         {nur fr IDE}
         PROCEDURE SetCPUDebuggerActive;
         PROCEDURE ResetCPUDebuggerActive;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
    End;

Var
    CPUWindow:TCPUWindow;


VAR SetDebuggerActiveCallBack:PROCEDURE;
    ResetDebuggerActiveCallBack:PROCEDURE;

PROCEDURE NewDumpWindow;
PROCEDURE InvalidateAllDumps;
PROCEDURE InitCPUWindow;
FUNCTION SetReturnFromFunctionBreak:BOOLEAN;


IMPLEMENTATION

FUNCTION SetReturnFromFunctionBreak:BOOLEAN;
VAR Buf:TDbgBuf;
    EBP,EIP,TargetEIP:LONGWORD;
    StackList:RECORD
                    OldEBP:LONGWORD;
                    RetEIP:LONGWORD;
              END;
    CallArray:ARRAY[1..5] OF BYTE;
LABEL found;
BEGIN
     result:=FALSE;
     IF ((not InDebugger)OR(((CpuWindow<>NIL)AND(CPUWindow.CurrentAddress=0)))) THEN
     BEGIN
          exit;
     END;

     IF Not GetRegisterSet(Buf) THEN exit
     ELSE
     BEGIN
          IF StackBase=0 THEN exit;

          {???????????????????????????????}
          {if the pointer at ESP is a call we use ESP instead of EBP}
          IF not GetDump(Buf.ESP,StackList,8) THEN exit;
          TargetEIP:=Buf.EIP;
          IF StackList.OldEBP=Buf.EBP THEN
          BEGIN
               EBP:=StackList.RetEIP; //After push EBP
               dec(TargetEIP);
          END
          ELSE EBP:=StackList.OldEBP;

          IF GetDump(EBP-5,CallArray,5) THEN IF CallArray[1]=$E8 THEN
          BEGIN
               System.Move(CallArray[2],EIP,4);
               IF EBP+EIP<=TargetEIP THEN
               BEGIN
found:
                    IF EBP<>StackBase THEN IF Buf.EBP<>StackBase THEN
                    BEGIN
                        //ErrorBox('Setting:'+tohex(EBP)+'  StackBase='+tohex(StackBase));
                        SetBreakPoint(EBP,3);
                        result:=TRUE;
                    END;
                    exit;
               END;
          END;

          EBP:=Buf.EBP;
          IF EBP<>StackBase THEN
          BEGIN
               IF not GetDump(EBP,StackList,8) THEN exit;
               EBP:=StackList.RetEIP;
               IF StackList.OldEBP<>StackBase THEN
                IF GetDump(StackList.OldEBP,StackList,8) THEN goto found;
          END;
     END;
END;


TYPE
    TAddressDialog=CLASS(TDialog)
         Entry:TEdit;
         PROCEDURE SetupComponent;Override;
         PROCEDURE SetupShow;OVERRIDE;
    END;

    TDumpWindow=CLASS(TForm)
         DumpField:TDumpField;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE Resize;OVERRIDE;
    END;


PROCEDURE NewDumpWindow;
VAR  Dump:TDumpWindow;
BEGIN
     Dump.Create(NIL);
     Dump.HelpContext := hctxDialogStorageForm;
     Dump.Caption:=LoadNLSStr(SiStorageCaption);
     Dump.Color:=clLtGray;
     Dump.SetWindowPos(0,0,620,200);
     Dump.Show;
END;


PROCEDURE TDumpWindow.SetupComponent;
BEGIN
     Inherited SetupComponent;

     DumpField.Create(SELF);
     DumpField.Align:=alClient;
     InsertControl(DumpField);

     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
END;


PROCEDURE TDumpWindow.Resize;
BEGIN
     Inherited Resize;

     DumpField.LastDumpRecValid:=FALSE;
     DumpField.Invalidate;
END;


FUNCTION GetRegAddress(s:STRING;Default:LONGINT;VAR result:LONGINT;CONST reg:STRING):BOOLEAN;
VAR Minus:BOOLEAN;
    Displ:LONGINT;
    c:INTEGER;
BEGIN
     GetRegAddress:=FALSE;

     WHILE s[length(s)]=#32 do dec(s[0]);
     WHILE ((length(s)>0)AND(s[1]=#32)) DO delete(s,1,1);

     IF pos('CS:',s)=1 THEN delete(s,1,3);
     IF pos('DS:',s)=1 THEN delete(s,1,3);
     IF pos('ES:',s)=1 THEN delete(s,1,3);
     IF pos('SS:',s)=1 THEN delete(s,1,3);
     IF pos('FS:',s)=1 THEN delete(s,1,3);
     IF pos('GS:',s)=1 THEN delete(s,1,3);

     IF pos(reg,s)=1 THEN
     BEGIN
          delete(s,1,3);
          IF s<>'' THEN
          BEGIN
               IF ((s[1]='+')OR(s[1]='-')) THEN
               BEGIN
                    IF s[1]='-' THEN Minus:=TRUE
                    ELSE Minus:=FALSE;
                    Delete(s,1,1);
                    VAL(s,Displ,c);
                    IF c=0 THEN
                    BEGIN
                         IF Minus THEN Displ:=-Displ;
                         result:=Default+Displ;
                         GetRegAddress:=TRUE;
                    END;
               END;
          END
          ELSE
          BEGIN
               GetRegAddress:=TRUE;
               result:=Default;
          END;
     END;
END;

FUNCTION GetAddress(AOwner:TControl;CurAddr:LONGINT):LONGINT;
VAR
   Dlg:TAddressDialog;
   c:INTEGER;
   s,s1:STRING;
   Buf:TDbgBuf;
   l,len:LONGWORD;
   ValueTyp:BYTE;
BEGIN
     result:=-1;
     Dlg.Create(AOwner);
     Dlg.Entry.Text := tohex(CurAddr);
     Dlg.Entry.SelectAll;
     Dlg.HelpContext := hctxDialogEnterStorageAddress;
     IF not Dlg.Execute THEN
     BEGIN
          Dlg.Destroy;
          exit;
     END;
     s:=Dlg.Entry.Text;
     Dlg.Destroy;
     VAL(s,result,c);
     IF c<>0 THEN
     BEGIN
          UpcaseStr(s);
          IF InDebugger THEN IF ParseValueFromExpr(s,s1,l,len,ValueTyp) THEN
          BEGIN
               result:=l;
               exit;
          END;

          IF ((not InDebugger)OR(Not GetRegisterSet(Buf))) THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiIllAdressFormat));
               exit;
          END;

          IF GetRegAddress(s,Buf.EAX,result,'EAX') THEN exit;
          IF GetRegAddress(s,Buf.EBX,result,'EBX') THEN exit;
          IF GetRegAddress(s,Buf.ECX,result,'ECX') THEN exit;
          IF GetRegAddress(s,Buf.EDX,result,'EDX') THEN exit;
          IF GetRegAddress(s,Buf.ESI,result,'ESI') THEN exit;
          IF GetRegAddress(s,Buf.EDI,result,'EDI') THEN exit;
          IF GetRegAddress(s,Buf.EBP,result,'EBP') THEN exit;
          IF GetRegAddress(s,Buf.ESP,result,'ESP') THEN exit;
          IF GetRegAddress(s,Buf.EIP,result,'EIP') THEN exit;

          result:=-1;
          ErrorBox(LoadNLSStr(SiIllAdressFormat));
          exit;
     END;
     IF result<$10000 THEN result:=$10000;
     IF result>$20000000 THEN result:=$20000000;
END;



PROCEDURE TAddressDialog.SetupShow;
BEGIN
     Inherited SetupShow;
     Entry.Focus;
END;

PROCEDURE TAddressDialog.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Width:=330;
     Height:=150;
     Caption:=LoadNLSStr(SiGotoAdress);
     InsertLabelNLS(SELF,10,80,90,20,SiEnterAdress);
     Entry:=InsertEdit(SELF,100,80,200,20,'','');
     InsertBitBtnNLS(SELF,10,20,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,20,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,20,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

PROCEDURE TRightToolBar.SetupComponent;
BEGIN
     Inherited SetupComponent;
     Alignment:=tbRight;
     Size:=IdeSettings.CPUWin.RegNoteBookWidth;
     Sizeable := TRUE;
     RegisterNoteBook.Create(SELF);
     InsertControl(RegisterNoteBook);
END;

CONST MenuNames:ARRAY[cmdcHexAndChar..cmdcComp] OF STRING[20]=
      ('Hex & Character','Character','Integer','Word','Integer Hex','Longint',
       'LongWord','Longint Hex','Single','Double','Extended','Comp');

      ContentSizes:ARRAY[dcHexAndChar..dcComp] OF BYTE=
        (16,32,16,16,16,16,16,16,4,8,10,8);

      DumpElemSizes:ARRAY[dcHexAndChar..dcComp] OF BYTE=
        (1,1,2,2,2,4,4,4,4,8,10,8);

TYPE TEnterDataDialog=CLASS(TDialog)
         Entry:TEdit;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
     END;

PROCEDURE TEnterDataDialog.SetupShow;
BEGIN
     Inherited SetupShow;

     Entry.AutoSelect:=FALSE;
     //Entry.CursorPos:=2;
     Entry.SelStart:=1;
     Entry.Focus;
END;

PROCEDURE TEnterDataDialog.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiEnterNewDataBytes);
     ClientWidth:=350;
     Height:=150;
     Entry:=InsertEdit(SELF,10,70,330,20,'','');
     InsertBitBtnNLS(SELF,10,20,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,20,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,20,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

PROCEDURE InvalidateAllDumps;
VAR  t:LONGINT;
     Dump:TDumpField;
BEGIN
     IF DumpFields=NIL THEN exit;
     FOR t:=0 TO DumpFields.Count-1 DO
     BEGIN
          Dump:=DumpFields[t];
          Dump.Invalidate;
     END;
END;

PROCEDURE TDumpField.DumpChange(s:STRING);
VAR EnterDataDlg:TEnterDataDialog;
    ret:BOOLEAN;
    Buf:POINTER;
    BufSize:LONGINT;
    li:LONGINT;
    si:SINGLE;
    d:DOUBLE;
    e:EXTENDED;
    co:COMP;
    c:INTEGER;
    ss:STRING;
    b:BYTE;
    Adr:LONGWORD;
LABEL err,ch;
BEGIN
     IF not InDebugger THEN exit;
     EnterDataDlg.Create(SELF);
     EnterDataDlg.HelpContext := hctxDialogEnterStorageData;
     EnterDataDlg.Entry.Text:=s;
     ret:=EnterDataDlg.Execute;
     s:=EnterDataDlg.Entry.Text;
     EnterDataDlg.Destroy;

     IF ret THEN
     BEGIN
          BufSize:=DumpElemSizes[ContentStyle];
          IF ContentStyle<>dcCharacter THEN
          BEGIN
               WHILE s[length(s)]=#32 do dec(s[0]);
               WHILE ((length(s)>0)AND(s[1]=#32)) DO delete(s,1,1);
          END;
          ss:=s;
          Adr:=DumpChangeAdr;
          WHILE ss<>'' DO
          BEGIN
               getmem(Buf,BufSize);
               IF ContentStyle=dcCharacter THEN
               BEGIN
                    s:=ss;
                    ss:='';
               END
               ELSE
               BEGIN
                    b:=pos(' ',ss);
                    IF b<>0 THEN
                    BEGIN
                         s:=copy(ss,1,b-1);
                         delete(ss,1,b);
                         while ss[length(ss)]=#32 do dec(ss[0]);
                    END
                    ELSE
                    BEGIN
                         s:=ss;
                         ss:='';
                    END;
               END;

               CASE ContentStyle OF
                  dcHexAndChar,dc16Int,dc16uInt,dc16IntHex,dc32Int,dc32uInt,
                  dc32IntHex:
                  BEGIN
                       IF ContentStyle=dcHexAndChar THEN IF LastDumpChar THEN goto ch;

                       VAL(s,li,c);
                       IF c<>0 THEN
                       BEGIN
err:
                            ErrorBox(LoadNLSStr(SiIllegalNumericFormat));
                            exit;
                       END;
                       System.Move(li,Buf^,BufSize);
                  END;
                  dcCharacter:
                  BEGIN
ch:
                       IF s='' THEN
                       BEGIN
                            ErrorBox(LoadNLSStr(SiIllegalValueForUpdate));
                            exit;
                       END;
                       freemem(Buf,BufSize);
                       BufSize:=length(s);
                       getmem(Buf,BufSize);
                       System.Move(s[1],Buf^,BufSize);
                  END;
                  dcSingle:
                  BEGIN
                       VAL(s,si,c);
                       IF c<>0 THEN goto err;
                       System.Move(si,Buf^,BufSize);
                  END;
                  dcDouble:
                  BEGIN
                       VAL(s,d,c);
                       IF c<>0 THEN goto err;
                       System.Move(d,Buf^,BufSize);
                  END;
                  dcExtended:
                  BEGIN
                       VAL(s,e,c);
                       IF c<>0 THEN goto err;
                       System.Move(e,Buf^,BufSize);
                  END;
                  dcComp:
                  BEGIN
                       VAL(s,co,c);
                       IF c<>0 THEN goto err;
                       System.Move(co,Buf^,BufSize);
                  END;
               END; {case}

               IF not SetDump(Adr,Buf^,BufSize) THEN
               BEGIN
                    ErrorBox('Error writing memory at:'+tohex(Adr));
                    FreeMem(Buf,BufSize);
                    break;
               END;
               FreeMem(Buf,BufSize);
               inc(Adr,BufSize);
          END; {while}
          Invalidate;
          InvalidateAllDumps;
     END;
END;

PROCEDURE TDumpField.KillFocus;
BEGIN
     IF LastDumpRecValid THEN
     BEGIN
          LastDumpRecValid:=FALSE;
          Invalidate;
     END;

     Inherited KillFocus;
END;

{$HINTS OFF}
PROCEDURE TDumpField.ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);
VAR  y,sp:LONGINT;
BEGIN
     CASE KeyCode OF
        kbCDown:
        BEGIN
             sp := DumpVertScroll.Position+ContentSizes[ContentStyle]-1;
             Scroll(DumpVertScroll,scVertTrack,sp);
             KeyCode := kbNull;
        END;
        kbCUp:
        BEGIN
             sp := DumpVertScroll.Position-ContentSizes[ContentStyle]+1;
             Scroll(DumpVertScroll,scVertTrack,sp);
             KeyCode := kbNull;
        END;
        kbPageDown:
        BEGIN
             y := (Height-4) DIV Canvas.Font.Height;
             sp := DumpVertScroll.Position+y*ContentSizes[ContentStyle]-1;
             Scroll(DumpVertScroll,scVertTrack,sp);
             KeyCode := kbNull;
        END;
        kbPageUp:
        BEGIN
             y := (Height-4) DIV Canvas.Font.Height;
             sp := DumpVertScroll.Position-y*ContentSizes[ContentStyle]+1;
             Scroll(DumpVertScroll,scVertTrack,sp);
             KeyCode := kbNull;
        END;
        ELSE Inherited ScanEvent(KeyCode,RepeatCount);
     END; {case}
END;

PROCEDURE TDumpField.CharEvent(VAR Key:CHAR;RepeatCount:BYTE);
BEGIN
     Inherited CharEvent(Key,RepeatCount);
     DumpChange(Key);
END;


PROCEDURE TDumpField.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR s:STRING;
    CX,CY,CX1,CY1,CX2,CY2:LONGINT;
    x1,y1,Index,Start,Ende,Base:LONGINT;
    t,Count:LONGINT;
    xx:LONGINT;
    ClientRec:TRect;
BEGIN
     Inherited MouseDown(Button,ShiftState,X,Y);

     IF Button <> mbLeft THEN exit;

     Focus;
     s:='?????????';
     ClientRec:=ClientRect;
     inc(ClientRec.Left);
     dec(ClientRec.Top);
     inc(ClientRec.Bottom);
     Canvas.GetTextExtent(s,CX,CY);

     y1:=Clientrec.Top-Canvas.Font.Height-2;
     DumpChangeAdr:=DumpAddr;
     WHILE Y<y1 DO
     BEGIN
          dec(y1,Canvas.Font.Height);
          inc(DumpChangeAdr,ContentSizes[ContentStyle]);
     END;
     Base:=DumpChangeAdr;

     inc(CX,ClientRec.Left+2);
     IF X>CX THEN
     BEGIN
          s:=DumpStrs[ContentStyle];
          Canvas.GetTextExtent(s,CX1,CY1);
          Canvas.GetTextExtent('?',CX2,CY2);
          IF X<CX+CX1 THEN
          BEGIN
               dec(X,CX);
               Index:=(X DIV CX2)+1;
               IF s[Index] IN ['?','+'] THEN
               BEGIN
                    Start:=Index;
                    WHILE s[Start]<>'?' DO dec(Start);

                    {Calculate Address Offset}
                    IF ContentStyle=dcCharacter THEN inc(DumpChangeAdr,Start-2)
                    ELSE
                    BEGIN
                         Count:=0;
                         FOR t:=Start DOWNTO 2 DO
                            IF s[t]=' ' THEN inc(Count);
                         IF ContentStyle=dcHexAndChar THEN
                         BEGIN
                              inc(DumpChangeAdr,Count*4);
                              FOR t:=Start-1 DOWNTO 2 DO
                              BEGIN
                                   IF s[t]=' ' THEN break;
                                   IF s[t]='?' THEN inc(DumpChangeAdr,1);
                              END;
                         END
                         ELSE inc(DumpChangeAdr,DumpElemSizes[ContentStyle]*Count);
                    END;

                    Ende:=Index;
                    WHILE ((Ende<Length(s))AND(s[Ende+1]='+')) DO inc(Ende);

                    xx:=(Ende-Start)+1;  {Lnge}

                    LastDumpRec.Left:=CX+(Start-1)*CX2;
                    LastDumpRec.Right:=LastDumpRec.Left+xx*CX2;
                    LastDumpRec.Bottom:=y1;
                    LastDumpRec.Top:=y1+CY2;

                    IF ContentStyle=dcHexAndChar THEN
                    BEGIN
                         LastDumpRec1.Left:=CX+CX1+CX2*3+3+(DumpChangeAdr-Base)*CX2;
                         LastDumpRec1.Right:=LastDumpRec1.Left+CX2;
                         LastDumpRec1.Bottom:=y1;
                         LastDumpRec1.Top:=y1+CY2;
                    END;

                    LastDumpRecValid:=TRUE;
                    LastDumpChar:=FALSE;
                    Invalidate;
               END;
          END
          ELSE IF ContentStyle=dcHexAndChar THEN
          BEGIN
               x1:=CX;
               inc(CX,CX1+CX2*3+3);
               IF X<=CX THEN exit;
               Canvas.GetTextExtent('????????????????',CX1,CY1);
               IF X<CX+CX1 THEN
               BEGIN
                    xx:=CX;
                    Start:=0;
                    WHILE xx+CX2<X DO
                    BEGIN
                        inc(xx,CX2);
                        inc(Start);
                    END;

                    inc(DumpChangeAdr,Start);

                    LastDumpRec1.Left:=xx;
                    LastDumpRec1.Right:=xx+CX2;
                    LastDumpRec1.Bottom:=y1;
                    LastDumpRec1.Top:=y1+CY2;
                    LastDumpRecValid:=TRUE;
                    LastDumpChar:=TRUE;

                    Invalidate;
               END;
          END;
     END;
END;

PROCEDURE TDumpField.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     IF Button <> mbLeft THEN exit;

     MouseDown(Button,ShiftState,X,Y);
     IF LastDumpRecValid THEN DumpChange('');
END;

PROCEDURE TDumpField.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
VAR  Size,sp:LONGINT;
BEGIN
     LastDumpRecValid:=FALSE;

     Inherited Scroll(ScrollBar,ScrollCode,ScrollPos);

     IF ScrollBar=DumpVertScroll THEN
     BEGIN
          IF ScrollCode=scVertEndScroll THEN exit;

          Size:=ContentSizes[ContentStyle];
          IF ScrollPos>DumpAddr THEN sp := ScrollPos + Size
          ELSE sp := ScrollPos - Size;
          sp := sp - DumpAddr;
          sp := (sp DIV Size) * Size;
          inc(DumpAddr,sp);
          IF DumpAddr<$10000 THEN DumpAddr:=$10000;
          IF DumpAddr>$20000000 THEN DumpAddr:=$20000000;
          {ScrollBar.Position:=DumpAddr;}
          ScrollPos := DumpAddr; {Position wird in .WMSCROLL gesetzt}
          Redraw(ClientRect);
     END;
END;
{$HINTS ON}

PROCEDURE TDumpField.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Font:=CPUWindowFont;
     DumpVertScroll.Create(SELF);
     DumpVertScroll.Kind:=sbVertical;
     DumpVertScroll.Align:=alRight;
     DumpAddr:=$20000;
     DumpVertScroll.SetScrollRange($10000,$20000000,128);
     DumpVertScroll.Position:=$20000;
     InsertControl(DumpVertScroll);
     ContentStyle:=dcHexAndChar;
     Color:=clLtGray;
     PenColor:=clBlack;
     Include(ComponentState, csAcceptsControls);

     IF DumpFields=NIL THEN DumpFields.Create;
     DumpFields.Add(SELF);
END;


DESTRUCTOR TDumpField.Destroy;
BEGIN
     DumpFields.Remove(SELF);
     IF DumpFields.Count = 0 THEN
     BEGIN
          DumpFields.Destroy;
          DumpFields := NIL;
     END;

     Inherited Destroy;
END;


{$HINTS OFF}
PROCEDURE TDumpField.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR Entry:TMenuItem;
    SubEntry:TMenuItem;
    t:LONGINT;
    pt:TPoint;
BEGIN
     Inherited MouseClick(Button,ShiftState,X,Y);

     IF Button <> mbRight THEN exit;

     IF Popup=NIL THEN
     BEGIN
          Popup.Create(SELF);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiDumpPopupGoto);
          Entry.Command:=cmGotoLoc;
          Entry.HelpContext := hctxPopupDumpGoto;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiDumpPopupChange);
          Entry.Command:=cmChange;
          Entry.HelpContext := hctxPopupDumpChange;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:='-';
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiDumpPopupDisplayAs);
          Entry.Command:=cmNull;
          Entry.HelpContext := hctxPopupDumpDisplayAs;

          FOR t:=cmdcHexAndChar TO cmdcComp DO
          BEGIN
               SubEntry.Create(Entry);
               SubEntry.Caption:=MenuNames[t];
               SubEntry.Command:=t;
               Entry.Add(SubEntry);
          END;

          Popup.Items.Add(Entry);
     END;

     IF not LastDumpRecValid THEN Popup.DisableCommands([cmChange])
     ELSE Popup.EnableCommands([cmChange]);

     pt := ClientToScreen(Point(X,Y));
     Popup.Popup(pt.X,pt.Y);
END;
{$HINTS ON}

PROCEDURE TDumpField.CommandEvent(VAR Command:TCommand);
VAR  ScrollPos:LONGINT;
     MsgHandled:BOOLEAN;
BEGIN
     MsgHandled:=TRUE;

     CASE Command OF
        cmGotoLoc:
        BEGIN
             ScrollPos:=GetAddress(SELF,DumpAddr);
             IF ScrollPos=-1 THEN exit;
             DumpAddr:=ScrollPos;
             DumpVertScroll.Position:=ScrollPos;
             Redraw(ClientRect);
        END;
        cmChange:
        BEGIN
             DumpChange('');
        END;
        cmdcHexAndChar:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dcHexAndChar;
             Invalidate;
        END;
        cmdcCharacter:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dcCharacter;
             Invalidate;
        END;
        cmdc16Int:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dc16Int;
             Invalidate;
        END;
        cmdc16uInt:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dc16uInt;
             Invalidate;
        END;
        cmdc16IntHex:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dc16IntHex;
             Invalidate;
        END;
        cmdc32Int:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dc32Int;
             Invalidate;
        END;
        cmdc32uInt:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dc32uInt;
             Invalidate;
        END;
        cmdc32IntHex:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dc32IntHex;
             Invalidate;
        END;
        cmdcSingle:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dcSingle;
             Invalidate;
        END;
        cmdcDouble:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dcDouble;
             Invalidate;
        END;
        cmdcExtended:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dcExtended;
             Invalidate;
        END;
        cmdcComp:
        BEGIN
             LastDumpRecValid:=FALSE;
             ContentStyle:=dcComp;
             Invalidate;
        END;
        ELSE MsgHandled:=FALSE;
     END; {case}
     IF MsgHandled THEN Command := cmNull;
END;


PROCEDURE TDumpField.Redraw(CONST rec:TRect);
VAR s,s1:STRING;
    CX,CY,CX1,CY1:LONGINT;
    ClientRec:TRect;
    rec1:TRect;
    y:LONGINT;
    Addr:LONGWORD;
BEGIN
     s:='?????????';
     ClientRec:=ClientRect;
     inc(ClientRec.Left,2);
     dec(ClientRec.Top);
     inc(ClientRec.Bottom);
     Canvas.GetTextExtent(s,CX,CY);
     rec1:=rec;
     IF rec1.Left<2 THEN rec1.Left:=2;
     IF rec1.Bottom<2 THEN rec1.Bottom:=2;
     IF rec1.Right>Width-2 THEN rec1.Right:=Width-2;
     IF rec1.Top>Height-2 THEN rec1.Top:=Height-2;
     Canvas.ClipRect:=rec1;
     Canvas.Pen.Color:=PenColor;
     Canvas.Brush.Color:=Color;

     y:=Clientrec.Top-Canvas.Font.Height-1;
     Addr:=DumpAddr;
     {Draw Address contents}
     WHILE y>ClientRec.Bottom DO
     BEGIN
          s:=tohex(Addr);
          delete(s,1,1);  {Delete $}
          Canvas.TextOut(ClientRec.Left,y,s+' ');
          rec1.Left:=ClientRec.Left;
          rec1.Right:=rec1.Left+CX;
          {$IFDEF OS2}
          dec(rec1.Right);
          {$ENDIF}
          rec1.Bottom:=y;
          rec1.Top:=y+Canvas.Font.Height;
          Canvas.ExcludeClipRect(rec1);
          inc(Addr,ContentSizes[ContentStyle]);
          dec(y,Canvas.Font.Height);
     END;

     Canvas.Line(ClientRec.Left+CX,ClientRec.Bottom,ClientRec.Left+CX,ClientRec.Top);
     Canvas.Pen.Color:=Color;
     Canvas.Line(ClientRec.Left+CX+1,ClientRec.Bottom,ClientRec.Left+CX+1,ClientRec.Top);
     Canvas.Pen.Color:=PenColor;
     rec1.Left:=ClientRec.Left+CX;
     rec1.Right:=rec1.Left{+1};
     rec1.Bottom:=ClientRec.Bottom;
     rec1.Top:=ClientRec.Top-1;
     Canvas.ExcludeClipRect(rec1);

     {Draw assembler commands}
     inc(ClientRec.Left,CX+2);

     {Draw memory contents}
     Addr:=DumpAddr;
     y:=Clientrec.Top-Canvas.Font.Height-1;
     WHILE y>ClientRec.Bottom DO
     BEGIN
          GetNextDumpString(ContentStyle,s,s1,Addr);
          Canvas.GetTextExtent(s+' ',CX,CY);
          Canvas.TextOut(ClientRec.Left,y,s+' ');
          rec1.Left:=ClientRec.Left;
          rec1.Right:=rec1.Left+CX;
          {$IFDEF OS2}
          dec(rec1.Right);
          {$ENDIF}
          rec1.Bottom:=y;
          rec1.Top:=y+Canvas.Font.Height-1;
          Canvas.ExcludeClipRect(rec1);
          CASE ContentStyle OF
              dcHexAndChar:
              BEGIN
                   Canvas.GetTextExtent(s1,CX1,CY1);
                   Canvas.TextOut(ClientRec.Left+CX+3,y,s1);
                   rec1.Left:=ClientRec.Left+CX+3;
                   rec1.Right:=ClientRec.Left+CX+3+CX1;
                   {$IFDEF OS2}
                   dec(rec1.Right);
                   {$ENDIF}
                   rec1.Bottom:=y;
                   rec1.Top:=y+Canvas.Font.Height-1;
                   Canvas.ExcludeClipRect(rec1);
              END;
          END; {case}
          inc(Addr,ContentSizes[ContentStyle]);
          dec(y,Canvas.Font.Height);
     END;

     IF ContentStyle=dcHexAndChar THEN
     BEGIN
          Canvas.Line(ClientRec.Left+CX+2,ClientRec.Bottom,ClientRec.Left+CX+2,ClientRec.Top);
          Canvas.Pen.Color:=Color;
          Canvas.Line(ClientRec.Left+CX+3,ClientRec.Bottom,ClientRec.Left+CX+3,ClientRec.Top);
          Canvas.Pen.Color:=PenColor;
          rec1.Left:=ClientRec.Left+CX+2;
          rec1.Right:=rec1.Left+2-1;
          rec1.Bottom:=ClientRec.Bottom;
          rec1.Top:=ClientRec.Top-1;
          Canvas.ExcludeClipRect(rec1);
     END;

     ClientRec:=ClientRect;
     {dec(ClientRec.Right,DumpVertScroll.Width);
     inc(ClientRec.Left);
     inc(ClientRec.Bottom,2);}
     InflateRect(ClientRec,-2,-2);
     Canvas.FillRect(ClientRec,Color);
     Canvas.DeleteClipRegion;
     ClientRec:=ClientRect;
     {dec(ClientRec.Right,DumpVertScroll.Width);
     inc(ClientRec.Bottom);}
     {Canvas.Rectangle(ClientRec);}
     DrawSystemBorder(SELF,ClientRec,bsSingle);
     {Canvas.Pen.Color:=Color;
     Canvas.Line(ClientRec.Left,ClientRec.Bottom-1,ClientRec.Right,ClientRec.Bottom-1);
     Canvas.Pen.Color:=Color;}

     IF LastDumpRecValid THEN
     BEGIN
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.Color:=clBlack;

          IF not LastDumpChar THEN Canvas.Box(LastDumpRec);
          IF ContentStyle=dcHexAndChar THEN Canvas.Box(LastDumpRec1);

          Canvas.Pen.Mode:=pmCopy;
     END;
END;



PROCEDURE TBottomToolBar.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Alignment:=tbBottom;
     Size:=IdeSettings.CPUWin.DumpNoteBookHeight;
     Sizeable := TRUE;
     DumpNoteBook.Create(SELF);
     InsertControl(DumpNoteBook);
END;


PROCEDURE InitCPUWindow;
BEGIN
     IF CPUWindow <> NIL THEN
     BEGIN
          IF CPUWindow.WindowState = wsMinimized
          THEN CPUWindow.WindowState := wsNormal;
          CPUWindow.Visible := TRUE;
          CPUWindow.BringToFront;
          exit;
     END;

     IF not InDebugger THEN exit; {beim Projekt laden, ignorieren}

     CPUWindow.Create(NIL);
     CPUWindow.HelpContext := hctxDialogCPUForm;
     CPUWindow.Icon:=CpuWinIcon;
     CPUWindow.Show;
     CPUWindow.Update;
END;

PROCEDURE TCPUWindow.UnloadNotify;
BEGIN
     DisableAllBreakPoints(BreakpointList);
END;

PROCEDURE TCPUWindow.Resize;
BEGIN
     Inherited Resize;

     LeftScrolled:=0;
     If HorzScrollBar<>Nil Then HorzScrollBar.SetScrollRange(0,80,(ClientWidth DIV Canvas.Font.Width)-14);
     CPUList.Clear;
END;

PROCEDURE TCPUWindow.InitCPUList(EIP:LONGWORD);
VAR ClientRec:TRect;
    y:LONGINT;
    OldCPUListCount:LONGINT;
    Item:PCPUListItem;
    s,Source,SourceFile:STRING;
    Address:LONGWORD;
    SourceLine:LONGINT;
BEGIN
     ClientRec:=ClientRect;

     DisAsmCurrentIndex:=0;
     OldCPUListCount:=CPUList.Count;

     {Draw address strings}

     y:=ClientRec.Top-Canvas.Font.Height;
     WHILE y>ClientRec.Bottom DO
     BEGIN
          Address:=GetNextCPUString(s,Source,SourceFile,SourceLine,FALSE,EIP);
          dec(y,Canvas.Font.Height);
     END;

     {Delete items outside view}
     IF DisAsmCurrentIndex<=CPUList.Count-1 THEN CPUList.Cut(DisAsmCurrentIndex,CPUList.Count-1);

     IF OldCPUListCount=0 THEN IF CPUList.Count>0 THEN {Update ScrollBars}
     BEGIN
          Item:=CPUList.First;
          VertScrollBar.SetScrollRange(Item^.CPUDump^.StartAddr,
                                        Item^.CPUDump^.StartAddr+Item^.CPUDump^.Len,
                                        Address-Item^.Address);
          VertScrollBar.Position:=Item^.Address;
     END;
END;

PROCEDURE TCPUWindow.RemarkAllBreaks;
BEGIN
     RemarkBreakPoints(BreakpointList);
END;

PROCEDURE TCPUWindow.UnmarkBreakpointAtEIP;
BEGIN
     UnmarkBreakpoint(BreakpointList,
                      RightToolBar.RegisterNoteBook.CPURegisters.EIP);
END;

CONST RedrawNested:BOOLEAN=FALSE;

PROCEDURE TCPUWindow.Redraw(CONST rec:TRect);
VAR ClientRec:TRect;
    s,s1,Source,SourceFile:STRING;
    CX,CY,OldCPUListCount:LONGINT;
    rec1:TRect;
    y:LONGINT;
    Address:LONGWORD;
    Item:PCPUListItem;
    SourceLine:LONGINT;
    dir,name,ext:STRING;
    OldRedrawNested:BOOLEAN;
    OldIndex:LONGINT;
LABEL dis,dis1;
BEGIN
     ClientRec:=ClientRect;
     Canvas.ClipRect:=ClientRec;

     OldRedrawNested:=RedrawNested;
     OldIndex:=DisAsmCurrentIndex;
     RedrawNested:=TRUE;

     s:='????????????';
     Canvas.GetTextExtent(s+' ',CX,CY);
     Canvas.Brush.Color:=Color;
     Canvas.Pen.Color:=clBlack;

     DisAsmCurrentIndex:=0;
     OldCPUListCount:=CPUList.Count;

     {Draw address strings}
     ClientAddrList.Clear;
     y:=ClientRec.Top-Canvas.Font.Height+1;
     WHILE y>ClientRec.Bottom DO
     BEGIN
          IF ((OldRedrawNested)OR(SecondCPUList<>NIL))
          THEN Address:=GetNextCPUStringNested(s,Source,SourceFile,SourceLine,FALSE,CPUWindow.CurrentAddress)
          ELSE Address:=GetNextCPUString(s,Source,SourceFile,SourceLine,FALSE,CPUWindow.CurrentAddress);

          IF InDebugger THEN
          BEGIN
              IF IsBreakpointDefined(BreakpointList,Address) THEN Canvas.Brush.Color:=clRed
              ELSE IF Address=SelectedAddr THEN
              BEGIN
                   Canvas.Brush.Color:=clDkGray;
                   Canvas.Pen.Color:=clWhite;
              END;
          END;

          IF Source<>'' THEN
          BEGIN
               ClientAddrList.Add(POINTER(Address));
               Source:=tostr(SourceLine);
               FSplit(SourceFile,Dir,Name,Ext);
               IF length(Name)>8 THEN Name[0]:=#8;
               Source:=Name+' '+Source;
               WHILE length(Source)<13 DO Source:=Source+' ';
               Canvas.TextOut(ClientRec.Left,y,Source);
               dec(y,Canvas.Font.Height);
               IF y>ClientRec.Bottom THEN goto dis1;
          END
          ELSE
          BEGIN
dis1:
               ClientAddrList.Add(POINTER(Address));
               WHILE length(s)<13 DO s:=s+' ';
               Canvas.TextOut(ClientRec.Left,y,s);
               dec(y,Canvas.Font.Height);
          END;

          Canvas.Brush.Color:=Color;
          Canvas.Pen.Color:=clBlack;
     END;

     Canvas.Line(ClientRec.Left+CX,ClientRec.Bottom,ClientRec.Left+CX,ClientRec.Top);
     {erase rest}
     rec1.Bottom:=y;
     rec1.Top:=y+Canvas.Font.Height;
     rec1.Left:=ClientRec.Left;
     rec1.Right:=rec1.Left+CX;
     Canvas.FillRect(rec1,Color);

     {Draw assembler commands}
     inc(ClientRec.Left,CX+1);
     DisAsmCurrentIndex:=0;
     s:='???';
     y:=ClientRec.Top-Canvas.Font.Height;
     WHILE y>ClientRec.Bottom DO
     BEGIN
          IF ((OldRedrawNested)OR(SecondCPUList<>NIL)) THEN Address:=GetNextCPUStringNested(s,Source,SourceFile,SourceLine,TRUE,CPUWindow.CurrentAddress)
          ELSE Address:=GetNextCPUString(s,Source,SourceFile,SourceLine,TRUE,CPUWindow.CurrentAddress);

          IF Source<>'' THEN
          BEGIN
               IF LeftScrolled>0 THEN Delete(Source,1,LeftScrolled);
               Canvas.GetTextExtent(Source,CX,CY);
               IF ((Address=CurrentAddress)AND(Address>0)) THEN
               BEGIN
                    CX:=Width;
                    rec1.Left:=ClientRec.Left+5;
                    rec1.Right:=rec1.Left+CX;
                    rec1.Bottom:=y;
                    rec1.Top:=y+CY;
                    Canvas.FillRect(rec1,clAqua);
                    Canvas.Brush.Mode:=bmTransparent;
               END;
               Canvas.Pen.Color:=clNavy;
               Canvas.TextOut(ClientRec.Left+5,y,Source);
               Canvas.Pen.Color:=clBlack;
               rec1.Left:=ClientRec.Left+5;
               rec1.Right:=rec1.Left+CX;
               {$IFDEF OS2}
               dec(rec1.Right);
               {$ENDIF}
               rec1.Bottom:=y;
               rec1.Top:=y+CY-1;
               Canvas.ExcludeClipRect(rec1);
               dec(y,Canvas.Font.Height);
               IF Address=CurrentAddress THEN
               BEGIN
                    Canvas.Brush.Color:=Color;
                    Canvas.Brush.Mode:=bmOpaque;
               END;
               IF y>ClientRec.Bottom THEN goto dis;
          END
          ELSE
          BEGIN
dis:
               s1:=GetNameFromAddr(Address,AddrCode,Address);
               IF s1<>'' THEN s:=s+'  ['+s1+']';
               IF LeftScrolled>0 THEN Delete(s,1,LeftScrolled);
               Canvas.GetTextExtent(s,CX,CY);
               IF ((Address=CurrentAddress)AND(Address>0)) THEN
               BEGIN
                    CX:=Width;
                    rec1.Left:=ClientRec.Left+5;
                    rec1.Right:=rec1.Left+CX;
                    rec1.Bottom:=y;
                    rec1.Top:=y+CY;
                    Canvas.FillRect(rec1,clAqua);
                    Canvas.Brush.Mode:=bmTransparent;
               END;
               Canvas.TextOut(ClientRec.Left+5,y,s);
               rec1.Left:=ClientRec.Left+5;
               rec1.Right:=rec1.Left+CX;
               {$IFDEF OS2}
               dec(rec1.Right);
               {$ENDIF}
               rec1.Bottom:=y;
               rec1.Top:=y+CY-1;
               Canvas.ExcludeClipRect(rec1);
               dec(y,Canvas.Font.Height);
               IF Address=CurrentAddress THEN
               BEGIN
                    Canvas.Brush.Color:=Color;
                    Canvas.Brush.Mode:=bmOpaque;
               END;
          END;
     END;

     {Delete items outside view}
     IF SecondCPUList=NIL THEN
       IF DisAsmCurrentIndex<=CPUList.Count-1 THEN CPUList.Cut(DisAsmCurrentIndex,CPUList.Count-1);

     IF OldCPUListCount=0 THEN IF CPUList.Count>0 THEN {Update ScrollBars}
     BEGIN
          Item:=CPUList.First;
          VertScrollBar.SetScrollRange(Item^.CPUDump^.StartAddr,
                                        Item^.CPUDump^.StartAddr+Item^.CPUDump^.Len,
                                        Address-Item^.Address);
          VertScrollBar.Position:=Item^.Address;
     END;

     Canvas.FillRect(ClientRec,Color);
     Canvas.DeleteClipRegion;
     RedrawNested:=OldRedrawNested;
     DisAsmCurrentIndex:=OldIndex;
END;

PROCEDURE TCPUWindow.RunToAddr;
BEGIN
     IF SelectedAddr=0 THEN exit;
     IF ((not InDebugger)OR(DebuggerRunning)) THEN exit;
     RemarkAllBreaks;
     EnableBreakpoint(SelectedAddr,3);
     DebugCommand(DBG_C_GO);
END;

FUNCTION TCPUWindow.ChangeState(pt:TPoint):BOOLEAN;
VAR
   s:STRING;
   cx,cy,t,y:LONGINT;
   ClientRec:TRect;
   Addr:LONGWORD;
BEGIN
     result:=FALSE;
     IF CPUList.Count=0 THEN exit;
     s:='????????????';
     Canvas.GetTextExtent(s+' ',CX,CY);
     IF pt.X>0 THEN IF pt.x<CX THEN  {Address selected}
     BEGIN
          ClientRec:=ClientRect;
          y:=ClientRec.Top-Canvas.Font.Height;
          t:=0;
          WHILE y>ClientRec.Bottom DO
          BEGIN
               IF pt.y>y THEN IF pt.y<y+Canvas.Font.Height THEN
               BEGIN
                    IF t>ClientAddrList.Count-1 THEN exit;
                    Addr:=LONGWORD(ClientAddrList.Items[t]);
                    result:=TRUE;
                    IF Addr=SelectedAddr THEN {Set BreakPoint}
                    BEGIN
                         IF not IsBreakpointDefined(BreakPointList,Addr) THEN
                           AddBreakpoint(BreakpointList,NormalBrk,Addr,NIL,0)
                         ELSE
                         BEGIN
                              RemoveBreakpoint(BreakpointList,Addr);
                              SelectedAddr:=0;
                              result:=FALSE;
                         END;
                    END
                    ELSE
                    BEGIN
                         IF not IsBreakpointDefined(BreakPointList,Addr) THEN
                           SelectedAddr:=Addr
                         ELSE
                         BEGIN
                              RemoveBreakpoint(BreakpointList,Addr);
                              SelectedAddr:=0;
                              result:=FALSE;
                         END;
                    END;
                    Redraw(ClientRec);
                    exit;
               END;
               dec(y,Canvas.Font.Height);
               inc(t);
          END;
     END;
END;

{$HINTS OFF}
PROCEDURE TCPUWindow.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseDown(Button,ShiftState,X,Y);

     IF Button <> mbLeft THEN exit;

     Focus;
     IF InDebugger THEN ChangeState(Point(X,Y));
END;


PROCEDURE TCPUWindow.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR Entry:TMenuItem;
    pt:TPoint;
BEGIN
     Inherited MouseClick(Button,ShiftState,X,Y);

     IF Button <> mbRight THEN exit;

     IF Popup=NIL THEN
     BEGIN
          Popup.Create(SELF);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiCPUPopupGoto);
          Entry.Command:=cmGotoLoc;
          Entry.HelpContext := hctxPopupCPUGoto;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiCPUPopupOrigin);
          Entry.Command:=cmGotoOrigin;
          Entry.HelpContext := hctxPopupCPUOrigin;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:='-';
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiCPUPopupStepInto)+'\tF7';
          Entry.Command:=cmStepInto;
          Entry.HelpContext := hctxPopupCPUStepInto;
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiCPUPopupStepOver)+'\tF8';
          Entry.Command:=cmStepOver;
          Entry.HelpContext := hctxPopupCPUStepOver;
          Popup.Items.Add(Entry);
     END;

     pt := ClientToScreen(Point(X,Y));
     Popup.Popup(pt.X,pt.Y);
END;
{$HINTS ON}


PROCEDURE TCPUWindow.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     IF Button <> mbLeft THEN exit;

     IF Not InDebugger THEN exit;
     ChangeState(Point(X,Y)); {Item was not selected}
END;

DESTRUCTOR TCPUWindow.Destroy;
BEGIN
     IF not DAsmInsideIDE THEN UnloadDbgProcess;

     IF InActiveBmp<>Nil THEN InActiveBmp.Destroy;
     IF ActiveBmp<>Nil THEN ActiveBmp.Destroy;

     RemarkAllCPUBreaksProc:=NIL;
     ClientAddrList.Destroy;
     ClientAddrList:=NIL;
     BreakpointList.Destroy;
     BreakPointList:=NIL;

     CPUWindow:=NIL;
     Inherited Destroy;
END;

PROCEDURE RemarkBreaksNotify;
BEGIN
     IF CPUWindow<>NIL THEN CPUWindow.RemarkAllBreaks;
END;

PROCEDURE TCpuWindow.CommandEvent(VAR Command:TCommand);
VAR ScrollPos:LONGINT;
    Item:PCPUListItem;
    s:STRING;
    Dlg:TAddressDialog;
    c:INTEGER;
    MsgHandled:BOOLEAN;
LABEL l;
BEGIN
     MsgHandled:=TRUE;

     CASE Command OF
        cmViewWatch:
        BEGIN
             ViewWatch;
        END;
        cmAddWatch:
        BEGIN
             AddWatch('','');
        END;
        cmViewSource:
        BEGIN
             ViewSource;
        END;
        cmRun:
        BEGIN
             RemarkAllBreaks;
             DbgRun;
        END;
        cmStepInto:
        BEGIN
             RemarkAllBreaks;
             StepInto;
        END;
        cmStepOver:
        BEGIN
             RemarkAllBreaks;
             StepOver;
        END;
        cmRunLine:
        BEGIN
             RunToAddr;
        END;
        cmEvaluateModify:
        BEGIN
             EvaluateModify('','');
        END;
        cmGotoOrigin:
        BEGIN
             ScrollPos:=CurrentAddress;
             goto l;
        END;
        cmGotoLoc:
        BEGIN
             Dlg.Create(SELF);
             Dlg.HelpContext := hctxDialogEnterCPUAddress;
             IF not Dlg.Execute THEN
             BEGIN
                  Dlg.Destroy;
                  exit;
             END;
             s:=Dlg.Entry.Text;
             Dlg.Destroy;
             VAL(s,ScrollPos,c);
             IF c<>0 THEN
             BEGIN
                  ErrorBox(LoadNLSStr(SiIllegalAdressFormat));
                  exit;
             END;
l:
             EnableSecondList;
             CPUList.Clear;
             InitCPUList(ScrollPos);
             DisableSecondList;
             Redraw(ClientRect);
             Item:=CPUList.First;
             CodeUpScrolled:=Item^.Address;
             VertScrollBar.Position:=CodeUpScrolled;
        END;
        ELSE MsgHandled:=FALSE;
     END; {case}

     IF MsgHandled THEN Command := cmNull;
END;

PROCEDURE TCpuWindow.SetCPUDebuggerActive;
BEGIN
     {nur falls in IDE}
     IF not DAsmInsideIDE THEN exit;
     ToolBarButtons[1].Glyph:=ActiveBmp;
END;

PROCEDURE TCpuWindow.ResetCPUDebuggerActive;
BEGIN
     {nur falls in IDE}
     IF not DAsmInsideIDE THEN exit;
     ToolBarButtons[1].Glyph:=InActiveBmp;
END;

PROCEDURE TCPUWindow.SetupShow;
BEGIN
     Inherited SetupShow;

     Canvas.Font:=CPUWindowFont;
END;

PROCEDURE TCpuWindow.SetupComponent;
VAR TheMainMenu:TMainMenu;

  PROCEDURE SetupMainMenu;
    TYPE TSibylMenuItem=RECORD
                              Level:BYTE;
                              Caption:longint;
                              Extra:STRING[13];
                              Command:TCommand;
                              Key:TKeyCode;
                        END;
    CONST MaxMenuItems=9;
    CONST MenuItems:ARRAY[1..MaxMenuItems] OF TSibylMenuItem=
      (
       (Level:0;Caption:SiMenuRun;Extra:'';Command:cmFile;Key:kbNull),
       (  Level:1;Caption:SiMenuRun;Extra:'\tCtrl+F9';Command:cmRun;Key:kbCtrlF9),
       (  Level:1;Caption:SiMenuStepOver;Extra:'\tF8';Command:cmStepOver;Key:kbF8),
       (  Level:1;Caption:SiMenuTraceInto;Extra:'\tF7';Command:cmStepInto;Key:kbF7),
       (  Level:1;Caption:SiMenuGotoCursor;Extra:'\tF4';Command:cmRunLine;Key:kbF4),
       (Level:0;Caption:SiMenuDebug;Extra:'';Command:cmFile;Key:kbNull),
       (  Level:1;Caption:SiMenuEvaluateModify;Extra:'\tCtrl+F5';Command:cmEvaluateModify;Key:kbCtrlF5),
       (  Level:1;Caption:SiMenuAddWatch;Extra:'\tCtrl+F7';Command:cmAddWatch;Key:kbCtrlF7),
       (  Level:1;Caption:SiMenuWatchWindow;Extra:'';Command:cmViewWatch;Key:kbNull)
      );
  VAR t:BYTE;
      Entry,
      LastLevel0Entry,
      LastLevel1Entry:TMenuItem;
  BEGIN
       FOR t:=1 TO MaxMenuItems DO
       BEGIN
            CASE MenuItems[t].Level OF
              0:
              BEGIN
                   Entry.Create(TheMainMenu);
                   TheMainMenu.Items.Add(Entry);
                   LastLevel0Entry:=Entry;
              END;
              1:
              BEGIN
                   Entry.Create(LastLevel0Entry);
                   LastLevel0Entry.Add(Entry);
                   LastLevel1Entry:=Entry;
              END;
              2:
              BEGIN
                   Entry.Create(LastLevel1Entry);
                   LastLevel1Entry.Add(Entry);
              END;
            END;
            Entry.Caption:=LoadNLSStr(MenuItems[t].Caption)+MenuItems[t].Extra;
            Entry.Command:=MenuItems[t].Command;
            IF MenuItems[t].Key<>kbNull
              THEN Entry.ShortCut:=MenuItems[t].Key;
            IF Entry.Command=1 THEN
              IF MenuItems[t].Level>0 THEN Entry.Enabled := FALSE;
       END;
   END;

CONST
    CommandIds:ARRAY[1..4] OF TCommand=(cmProgramReset,cmRun,cmStepInto,cmStepOver);

    HelpTexts:ARRAY[1..4] OF longint=
        (SiProgramReset,SiFullSpeed,SiMenuTraceIntoHint,SiMenuStepOverHint);

    BmpIndexes:ARRAY[1..4] OF LONGINT=
        (1003,1012,1018,1019);
VAR t,X:LONGINT;
BEGIN
     Inherited SetupComponent;

     SibylFormId := dwi_CPUWindow;

     ScrollBars:=ssBoth;
     IF not DAsmInsideIDE THEN
     BEGIN
          InDebugger:=FALSE;
          BorderIcons:=[];
          Align:=alClient;
          BorderStyle:=bsNone;
          Moveable:=FALSE;
     END
     ELSE
     BEGIN
          TheMainMenu.Create(SELF);
          SetupMainMenu;
          Menu := TheMainMenu;

          ToolBar.Create(SELF);
          ToolBar.Alignment:=tbTop;
          ToolBar.Size:=30;
          InsertControl(ToolBar);

          InActiveBmp.Create;
          InActiveBmp.LoadFromResourceId(1037);
          ActiveBmp.Create;
          ActiveBmp.LoadFromResourceId(1003);

          IF DebuggerRunning THEN BmpIndexes[1]:=1003
          ELSE BmpIndexes[1]:=1037;

          X:=2;
          FOR t:=1 TO 4 DO
          BEGIN
               ToolBarButtons[t]:=InsertXPLButtonNLS(ToolBar,X,3,24,24,
                          BmpIndexes[t],HelpTexts[t],IdeSettings.FlatButtons);
               ToolBarButtons[t].Command:=CommandIds[t];
               ToolBarButtons[t].NumGlyphs := 2;
               inc(X,28);
          END;
     END;

     ClientAddrList.Create;
     SelectedAddr:=0;
     BreakPointList.Create;
     Color:=clLtGray;
     Caption:=LoadNLSStr(SiCPUWindow);
     RightToolBar.Create(SELF);
     InsertControl(RightToolBar);
     BottomToolBar.Create(SELF);
     InsertControl(BottomToolBar);
     RemarkAllCPUBreaksProc:=RemarkBreaksNotify;

     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
END;

PROCEDURE TCPUWindow.ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);
VAR Item:PCPUListItem;
    ScrollPos:LONGINT;
    Count,t,sp:LONGINT;
    s,Source,SourceFile:STRING;
    SourceLine:LONGINT;
BEGIN
     Inherited ScanEvent(KeyCode,RepeatCount);

     IF CPUList.Count=0 THEN exit;

     CASE KeyCode OF
         kbPageDown:
         BEGIN
              Item:=CPUList.Last;
              ScrollPos:=Item^.Address;
              EnableSecondList;
              CPUList.Clear;
              InitCPUList(ScrollPos);
              DisableSecondList;
              Redraw(ClientRect);
              Item:=CPUList.First;
              CodeUpScrolled:=Item^.Address;
              VertScrollBar.Position:=CodeUpScrolled;
              KeyCode := kbNull;
         END;
         kbPageUp:
         BEGIN
              Count:=CPUList.Count;
              Item:=CPUList.First;
              IF Item^.Address<=Item^.CPUDump^.StartAddr THEN Count:=0;
              EnableSecondList;
              FOR t:=1 TO Count-1 DO
              BEGIN
                   CPUList.Delete(CPUList.Count-1);
                   DisAsmCurrentIndex:=-1;
                   GetNextCPUString(s,Source,SourceFile,SourceLine,FALSE,CPUWindow.CurrentAddress);
                   Item:=CPUList.First;
                   IF Item^.Address<=Item^.CPUDump^.StartAddr THEN break;
                   IF Item^.DisAssembly[1]='?' THEN break;
              END;
              DisableSecondList;
              Redraw(ClientRect);
              Item:=CPUList.First;
              CodeUpScrolled:=Item^.Address;
              VertScrollBar.Position:=CodeUpScrolled;
              KeyCode := kbNull;
         END;
         kbCDown:
         BEGIN
              sp := CodeUpScrolled+1;
              Scroll(VertScrollBar,scVertPosition,sp);
              KeyCode := kbNull;
         END;
         kbCUp:
         BEGIN
              sp := CodeUpScrolled-1;
              Scroll(VertScrollBar,scVertPosition,sp);
              KeyCode := kbNull;
         END;
         kbCLeft:
         BEGIN
              sp := LeftScrolled-1;
              Scroll(HorzScrollBar,scHorzPosition,sp);
              KeyCode := kbNull;
         END;
         kbCRight:
         BEGIN
              sp := LeftScrolled+1;
              Scroll(HorzScrollBar,scHorzPosition,sp);
              KeyCode := kbNull;
         END;
     END;
END;

{$HINTS OFF}
PROCEDURE TCpuWindow.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
VAR s,Source,SourceFile:STRING;
    Item:PCPUListItem;
    CodeStartPos,CodeEndPos:LONGWORD;
    SourceLine:LONGINT;
BEGIN
     Inherited Scroll(ScrollBar,ScrollCode,ScrollPos);

     IF CPUList.Count=0 THEN exit;

     IF ScrollBar=HorzScrollBar THEN
     BEGIN
          LeftScrolled:=ScrollPos;
          IF LeftScrolled<0 THEN LeftScrolled:=0;
          IF LeftScrolled>80 THEN LeftScrolled:=80;
          Redraw(ClientRect);
     END
     ELSE IF ScrollBar=VertScrollBar THEN
     BEGIN
          IF ScrollCode=scVertTrack THEN exit;

          Item:=CPUList.Last;
          CodeEndPos:=Item^.Address;
          Item:=CPUList.First;
          CodeStartPos:=Item^.Address;

          IF ScrollPos<Item^.CPUDump^.StartAddr THEN ScrollPos:=Item^.CPUDump^.StartAddr;
          IF ScrollPos>Item^.CPUDump^.StartAddr+Item^.CPUDump^.Len THEN ScrollPos:=Item^.CPUDump^.StartAddr+Item^.CPUDump^.Len;

          IF ScrollPos>CodeStartPos THEN
          BEGIN
               Item:=CPUList.Last;
               IF Item^.DisAssembly[1]='?' THEN exit;

               IF ScrollPos>CodeEndPos+15 THEN
               BEGIN  {better to re-read}
                    EnableSecondList;
                    CPUList.Clear;
                    InitCPUList(ScrollPos);
                    DisableSecondList;
               END
               ELSE
               BEGIN
                    CodeEndPos:=ScrollPos-1;  {1 mal auf jeden Fall}
                    EnableSecondList;
                    WHILE ScrollPos>CodeEndPos DO
                    BEGIN
                         CPUList.Delete(0);
                         DisAsmCurrentIndex:=CPUList.Count;
                         GetNextCPUString(s,Source,SourceFile,SourceLine,FALSE,CPUWindow.CurrentAddress);
                         Item:=CPUList.Last;
                         CodeEndPos:=Item^.Address;
                         IF Item^.DisAssembly[1]='?' THEN break;
                    END;
                    DisableSecondList;
               END;
               Redraw(ClientRect);
               Item:=CPUList.First;
               CodeUpScrolled:=Item^.Address;
               ScrollPos:=CodeUpScrolled;
               //VertScrollBar.Position:=CodeUpScrolled;
          END
          ELSE IF ScrollPos<CodeStartPos THEN
          BEGIN
               Item:=CPUList.First;
               IF Item^.DisAssembly[1]='?' THEN exit;

               IF ScrollPos<CodeStartPos-15 THEN
               BEGIN  {better to re-read}
                    EnableSecondList;
                    CPUList.Clear;
                    InitCPUList(ScrollPos);
                    DisableSecondList;
               END
               ELSE
               BEGIN
                    EnableSecondList;
                    WHILE ScrollPos<CodeStartPos DO
                    BEGIN
                         CPUList.Delete(CPUList.Count-1);
                         DisAsmCurrentIndex:=-1;
                         GetNextCPUString(s,Source,SourceFile,SourceLine,FALSE,CPUWindow.CurrentAddress);
                         Item:=CPUList.First;
                         CodeStartPos:=Item^.Address;
                         IF Item^.DisAssembly[1]='?' THEN break;
                    END;
                    DisableSecondList;
               END;
               Redraw(ClientRect);
               Item:=CPUList.First;
               CodeUpScrolled:=Item^.Address;
               ScrollPos:=CodeUpScrolled;
               //VertScrollBar.Position:=CodeUpScrolled;
          END;
     END;
END;
{$HINTS ON}

{******************************************************************************
 *                                                                            *
 *                                                                            *
 * TRegisterNoteBook                                                          *
 *                                                                            *
 *                                                                            *
 ******************************************************************************}

PROCEDURE TRegisterNoteBook.SetupComponent;
BEGIN
     Inherited SetupComponent;

     ZOrder := zoBottom;
     Align := alClient;

     ShowPageHint:=FALSE;
     TabAlignment:=taBottom;
     Font:=CPUWindowFont;
     OnResize:=RegisterNoteBookOnResize;

     Pages.Clear;
     CPUPage:=TPage(Pages.Objects[Pages.Add('CPU')]);
     CPUVertScrollBar.Create(CPUPage);
     CPUVertScrollBar.Kind:=sbVertical;
     CPUVertScrollBar.Align:=alRight;
     CPUVertScrollBar.OnScroll:=PageScroll;
     CPUPage.InsertControl(CPUVertScrollBar);

     FPUPage:=TPage(Pages.Objects[Pages.Add('FPU')]);
     FPUVertScrollBar.Create(FPUPage);
     FPUVertScrollBar.Kind:=sbVertical;
     FPUVertScrollBar.Align:=alRight;
     FPUVertScrollBar.OnScroll:=PageScroll;
     FPUPage.InsertControl(FPUVertScrollBar);

     PageIndex:=0;

     CPUPage.OnPaint:=PaintPage;
     FPUPage.OnPaint:=PaintPage;
END;


FUNCTION TRegisterNoteBook.GetCPUFlag(Flag:TVisibleCPUFlags):BOOLEAN;
VAR Flags:LONGWORD;
BEGIN
     IF not CPURegistersValid THEN result:=FALSE
     ELSE
     BEGIN
          Flags:=CPURegisters.EFLAGS;
          CASE Flag OF
              _CF:result:=Flags AND 1<>0;
              _ZF:result:=Flags AND 64<>0;
              _SF:result:=Flags AND 128<>0;
              _OF:result:=Flags AND 2048<>0;
              _PF:result:=Flags AND 4<>0;
              _AF:result:=Flags AND 16<>0;
              _TF:result:=Flags AND 256<>0;
              _DF:result:=Flags AND 1024<>0;
              ELSE result:=FALSE;
          END; {Case}
     END;
END;

FUNCTION TRegisterNoteBook.GetCPUReg(Reg:TVisibleCPURegisters):STRING;
VAR l:LONGWORD;
LABEL err;
BEGIN
     IF not CPURegistersValid THEN
     BEGIN
err:
          IF Reg<_SS THEN result:='????????'
          ELSE result:='????';
     END
     ELSE
     BEGIN
          CASE Reg OF
              _EAX:l:=CPURegisters.EAX;
              _EBX:l:=CPURegisters.EBX;
              _ECX:l:=CPURegisters.ECX;
              _EDX:l:=CPURegisters.EDX;
              _ESP:l:=CPURegisters.ESP;
              _EBP:l:=CPURegisters.EBP;
              _ESI:l:=CPURegisters.ESI;
              _EDI:l:=CPURegisters.EDI;
              _EIP:l:=CPURegisters.EIP;
              _EFLAGS:l:=CPURegisters.EFLAGS;
              _SS:l:=CPURegisters.SS;
              _CS:l:=CPURegisters.CS;
              _DS:l:=CPURegisters.DS;
              _ES:l:=CPURegisters.ES;
              _FS:l:=CPURegisters.FS;
              _GS:l:=CPURegisters.GS;
              ELSE goto err;
          END; {case}

          result:=ToHex(l);
          IF Reg<_SS THEN Delete(result,1,1)
          ELSE Delete(result,1,5);
     END;
END;

FUNCTION TRegisterNoteBook.GetFPUFlag(Flag:TVisibleFPUFlags):BOOLEAN;
VAR SW,CW:WORD;
BEGIN
     IF not FPURegistersValid THEN result:=FALSE
     ELSE
     BEGIN
          SW:=FPURegisters.SW;
          CW:=FPURegisters.CW;
          CASE Flag OF
              F_PM:result:=SW AND 32<>0;
              F_UM:result:=SW AND 16<>0;
              F_OM:result:=SW AND 8<>0;
              F_ZM:result:=SW AND 4<>0;
              F_DM:result:=SW AND 2<>0;
              F_IM:result:=SW AND 1<>0;
              F_PE:result:=CW AND 32<>0;
              F_UE:result:=CW AND 16<>0;
              F_OE:result:=CW AND 8<>0;
              F_ZE:result:=CW AND 4<>0;
              F_DE:result:=CW AND 2<>0;
              F_IE:result:=CW AND 1<>0;
              F_SF:result:=CW AND 64<>0;
              F_ES:result:=CW AND 128<>0;
              F_B:result:=CW AND 32768<>0;
              ELSE result:=FALSE;
          END; {case}
     END;
END;

FUNCTION TRegisterNoteBook.GetFPUReg(Reg:TVisibleFPURegisters):STRING;
VAR e:extended;
    TOS,RC,PC:BYTE;
BEGIN
     IF ord(Reg)>=ord(_ST0) THEN
     BEGIN
          IF FPURegistersValid THEN
          BEGIN
               TOS:=FPURegisters.SW SHR 11;
               TOS:=TOS AND 7;
               IF ((TOS=0)OR(TOS+(ord(Reg)-ord(_ST0))>7)) THEN result:=LoadNLSStr(SiNotUsed)
               ELSE
               BEGIN
                    CASE Reg OF
                        _ST0:e:=FPURegisters.ST0;
                        _ST1:e:=FPURegisters.ST1;
                        _ST2:e:=FPURegisters.ST2;
                        _ST3:e:=FPURegisters.ST3;
                        _ST4:e:=FPURegisters.ST4;
                        _ST5:e:=FPURegisters.ST5;
                        _ST6:e:=FPURegisters.ST6;
                        _ST7:e:=FPURegisters.ST7;
                        ELSE
                        BEGIN
                             result:=LoadNLSStr(SiNotUsed);
                             exit;
                        END;
                    END; //case
                    STR(e,result);
               END;
          END
          ELSE result:=LoadNLSStr(SiNotUsed);
     END
     ELSE
     BEGIN
          IF FPURegistersValid THEN
          BEGIN
              case Reg OF
                 _FPCW:
                 BEGIN
                      result:=tohex(FPURegisters.CW);
                      Delete(result,1,5);
                 END;
                 _FPSW:
                 BEGIN
                      result:=tohex(FPURegisters.SW);
                      Delete(result,1,5);
                 END;
                 _TOS:
                 BEGIN
                      TOS:=FPURegisters.SW SHR 11;
                      TOS:=TOS AND 7;
                      result:=tostr(TOS);
                 END;
                 _RC:
                 BEGIN
                      RC:=(FPURegisters.CW SHR 10) AND 3;
                      IF RC AND 1<>0 THEN result:='1'
                      ELSE result:='0';
                      IF RC AND 2<>0 THEN result:='1'+result
                      ELSE result:='0'+result;
                 END;
                 _PC:
                 BEGIN
                      PC:=(FPURegisters.CW SHR 8) AND 3;
                      IF PC AND 1<>0 THEN result:='1'
                      ELSE result:='0';
                      IF PC AND 2<>0 THEN result:='1'+result
                      ELSE result:='0'+result;
                 END;
                 ELSE result:='????';
              end; //case
          END
          ELSE result:='????';
     END;
END;

{$HINTS OFF}
PROCEDURE TRegisterNoteBook.RegisterNoteBookOnResize(Sender:TObject);
VAR v,y:LONGINT;
    ClientRec:TRect;
Begin
     ClientRec:=CPUPage.ClientRect;
     InflateRect(ClientRec,-3,-3);
     y:=ClientRec.Top-Canvas.Font.Height;
     v:=0;
     WHILE y>ClientRec.Bottom DO
     BEGIN
          INC(v);
          dec(y,Canvas.Font.Height);
     END;

     CPUVertScrollBar.SetScrollRange(ord(_CPUStart),ord(_FS),V);
     CPUUpScrolled:=_CPUStart;
     CPUDownScrolled:=_CPUEnd;
     CPUVertScrollBar.Position:=ord(_CPUStart);

     FPUVertScrollBar.SetScrollRange(ord(_FPUStart),ord(_ST6),V);
     FPUUpScrolled:=_FPUStart;
     FPUDownScrolled:=_FPUEnd;
     FPUVertScrollBar.Position:=ord(_FPUStart);

     IF CPUWindow<>NIL THEN
       IF IdeSettings.CPUWin.RegNoteBookWidth <> CPUWindow.RightToolBar.Width THEN
     BEGIN
          IdeSettings.CPUWin.RegNoteBookWidth := CPUWindow.RightToolBar.Width;
          IdeSettings.Modified := TRUE;
     END;
End;

{$HINTS ON}

PROCEDURE TRegisterNoteBook.PaintPage(Sender:TObject;CONST rec:TRect);
VAR ClientRec:TRect;
    x,y,cx,cy,Drawn:LONGINT;
    CpuReg,Start:TVisibleCPURegisters;
    FpuReg,FPUStart1:TVisibleFPURegisters;
    CpuFlag:TVisibleCPUFlags;
    FpuFlag:TVisibleFPUFlags;
    CPULoopStart,CPULoopEnd:TVisibleCPUFlags;
    FPULoopStart,FPULoopEnd:TVisibleFPUFlags;
    s:STRING;
    rec1:TRect;
    ThePage:TPage;
LABEL CPULoop,FPULoop;
Begin
     ThePage:=TPage(Sender);

     ClientRec:=ThePage.ClientRect;
     InflateRect(ClientRec,-2,-2);
     ThePage.Canvas.ClipRect:=IntersectRect(rec,ClientRec);
     InflateRect(ClientRec,-1,-1);
     x:=ClientRec.Left;
     y:=ClientRec.Top-ThePage.Canvas.Font.Height+1;
     ThePage.Canvas.Brush.Color:=Color;
     ThePage.Canvas.Pen.Color:=PenColor;

     IF ThePage=CPUPage THEN
     BEGIN
          Start:=CPUUpScrolled;
          inc(Start);
          CPUDownScrolled:=Start;
          Drawn:=0;
          IF y>ClientRec.Bottom THEN FOR CpuReg:=Start TO _GS DO
          BEGIN
               IF CpuReg=_FLAGS1 THEN
               BEGIN
                    CPULoopStart:=_CF;
                    CPULoopEnd:=_OF;
CPULoop:
                    FOR CPUFlag:=CPULoopStart TO CPULoopEnd DO
                    BEGIN
                         s:=VisibleCPUFlags[CpuFlag];
                         ThePage.Canvas.GetTextExtent(s,CX,CY);
                         IF GetCPUFlag(CpuFlag) THEN ThePage.Canvas.Pen.Color:=clBlack
                         ELSE ThePage.Canvas.Pen.Color:=clDkGray;
                         ThePage.Canvas.TextOut(x,y,s);
                         rec1.Left:=x;
                         rec1.Right:=x+CX;
                         {$IFDEF OS2}
                         dec(rec1.Right);
                         {$ENDIF}
                         rec1.Bottom:=y;
                         rec1.Top:=y+CY-1;
                         ThePage.Canvas.ExcludeClipRect(rec1);
                         inc(x,CX+10);
                    END;
                    ThePage.Canvas.Pen.Color:=clBlack;
               END
               ELSE IF CpuReg=_FLAGS2 THEN
               BEGIN
                    CPULoopStart:=_PF;
                    CPULoopEnd:=_DF;
                    goto CPULoop;
               END
               ELSE
               BEGIN
                    s:=VisibleCPURegisters[CpuReg];
                    ThePage.Canvas.GetTextExtent(s,CX,CY);
                    ThePage.Canvas.TextOut(x,y,s);
                    rec1.Left:=x;
                    rec1.Right:=x+CX-1;
                    rec1.Bottom:=y;
                    rec1.Top:=y+CY-1;
                    ThePage.Canvas.ExcludeClipRect(rec1);
                    X:=ClientRec.Left+40;
                    s:=GetCPUReg(CpuReg);
                    ThePage.Canvas.GetTextExtent(s,CX,CY);
                    ThePage.Canvas.TextOut(x,y,s);
                    rec1.Left:=x;
                    rec1.Right:=x+CX;
                    {$IFDEF OS2}
                    dec(rec1.Right);
                    {$ENDIF}
                    rec1.Bottom:=y;
                    rec1.Top:=y+CY-1;
                    ThePage.Canvas.ExcludeClipRect(rec1);
               END;
               x:=ClientRec.Left;
               dec(y,ThePage.Canvas.Font.Height);
               inc(CPUDownScrolled);
               inc(Drawn);
               IF y<=ClientRec.Bottom THEN break;
          END;

          IF ((CPUUpScrolled=_CPUStart)AND(CPUDownScrolled=_CPUEnd)) THEN
               CPUVertScrollBar.Hide
          ELSE CPUVertScrollBar.Show;
     END
     ELSE IF ThePage=FPUPage THEN
     BEGIN
          FPUStart1:=FPUUpScrolled;
          inc(FPUStart1);
          FPUDownScrolled:=FPUStart1;
          Drawn:=0;
          IF y>ClientRec.Bottom THEN FOR FPUReg:=FPUStart1 TO _ST7 DO
          BEGIN
               IF FpuReg=_FPUFLAGS1 THEN
               BEGIN
                    FPULoopStart:=F_PM;
                    FPULoopEnd:=F_ZM;
FPULoop:
                    FOR FPUFlag:=FPULoopStart TO FPULoopEnd DO
                    BEGIN
                         s:=VisibleFPUFlags[FpuFlag];
                         ThePage.Canvas.GetTextExtent(s,CX,CY);
                         IF GetFPUFlag(FpuFlag) THEN ThePage.Canvas.Pen.Color:=clBlack
                         ELSE ThePage.Canvas.Pen.Color:=clDkGray;
                         ThePage.Canvas.TextOut(x,y,s);
                         rec1.Left:=x;
                         rec1.Right:=x+CX;
                         {$IFDEF OS2}
                         dec(rec1.Right);
                         {$ENDIF}
                         rec1.Bottom:=y;
                         rec1.Top:=y+CY-1;
                         ThePage.Canvas.ExcludeClipRect(rec1);
                         inc(x,CX+10);
                    END;
                    ThePage.Canvas.Pen.Color:=clBlack;
               END
               ELSE IF FpuReg=_FPUFLAGS2 THEN
               BEGIN
                    FPULoopStart:=F_DM;
                    FPULoopEnd:=F_IM;
                    goto FPULoop;
               END
               ELSE IF FpuReg=_FPUFLAGS3 THEN
               BEGIN
                    FPULoopStart:=F_PE;
                    FPULoopEnd:=F_ZE;
                    goto FPULoop;
               END
               ELSE IF FpuReg=_FPUFLAGS4 THEN
               BEGIN
                    FPULoopStart:=F_DE;
                    FPULoopEnd:=F_B;
                    goto FPULoop;
               END
               ELSE
               BEGIN
                    s:=VisibleFPURegisters[FpuReg];
                    ThePage.Canvas.GetTextExtent(s,CX,CY);
                    ThePage.Canvas.TextOut(x,y,s);
                    rec1.Left:=x;
                    rec1.Right:=x+CX;
                    {$IFDEF OS2}
                    dec(rec1.Right);
                    {$ENDIF}
                    rec1.Bottom:=y;
                    rec1.Top:=y+CY-1;
                    ThePage.Canvas.ExcludeClipRect(rec1);
                    X:=ClientRec.Left+50;
                    s:=GetFPUReg(FpuReg);
                    ThePage.Canvas.GetTextExtent(s,CX,CY);
                    ThePage.Canvas.TextOut(x,y,s);
                    rec1.Left:=x;
                    rec1.Right:=x+CX;
                    {$IFDEF OS2}
                    dec(rec1.Right);
                    {$ENDIF}
                    rec1.Bottom:=y;
                    rec1.Top:=y+CY-1;
                    ThePage.Canvas.ExcludeClipRect(rec1);
               END;
               x:=ClientRec.Left;
               dec(y,ThePage.Canvas.Font.Height);
               inc(FPUDownScrolled);
               inc(Drawn);
               IF y<=ClientRec.Bottom THEN break;
          END;

          IF ((FPUUpScrolled=_FPUStart)AND(FPUDownScrolled=_FPUEnd)) THEN
               FPUVertScrollBar.Hide
          ELSE FPUVertScrollBar.Show;
     END;

     rec1:=rec;
     ClientRec:=ThePage.ClientRect;
     IF rec1.Left<Clientrec.Left+2 THEN rec1.Left:=ClientRec.Left+2;
     IF rec1.Bottom<ClientRec.Bottom+2 THEN rec1.Bottom:=ClientRec.Bottom+2;
     IF rec1.Right>ClientRec.Right-2 THEN rec1.Right:=ClientRec.Right-2;
     IF rec1.Top>ClientRec.Top-2 THEN rec1.Top:=ClientRec.Top-2;
     ThePage.Redraw(rec1);
     ThePage.Canvas.DeleteClipRegion;

     ClientRec:=ThePage.ClientRect;
     DrawSystemBorder(ThePage,ClientRec,bsSingle);
End;

{$HINTS OFF}
PROCEDURE TRegisterNoteBook.PageScroll(Sender:TObject;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
VAR  sp:LONGINT;
BEGIN
     sp := ScrollPos;
     IF Sender=CPUVertScrollBar THEN
     BEGIN
          IF sp<ord(_CPUStart) THEN sp:=ord(_CPUStart);
          IF sp>ord(_CPUEnd) THEN sp:=ord(_CPUEnd);
          CPUUpScrolled:=TVisibleCPURegisters(sp);
          CPUPage.Invalidate;
     END
     ELSE IF Sender=FPUVertScrollBar THEN
     BEGIN
          IF sp<ord(_FPUStart) THEN sp:=ord(_FPUStart);
          IF sp>ord(_FPUEnd) THEN sp:=ord(_FPUEnd);
          FPUUpScrolled:=TVisibleFPURegisters(sp);
          FPUPage.Invalidate;
     END;
END;
{$HINTS ON}

{*****************************************************************************
 *                                                                           *
 *                                                                           *
 * TDumpNoteBook                                                             *
 *                                                                           *
 *                                                                           *
 *****************************************************************************}

PROCEDURE TDumpNoteBook.StackItemSelected(Sender:TObject;Index:LongInt);
VAR s:STRING;
    t:BYTE;
    l:LongWord;
    c:Integer;
    Item:PCPUListItem;
BEGIN
     s:=StackListBox.Items[Index];
     t:=pos('$',s);
     IF t<>0 THEN
     BEGIN
          s:=copy(s,t,9);
          VAL(s,l,c);
          IF c<>0 THEN exit;

          EnableSecondList;
          CPUList.Clear;
          CpuWindow.InitCPUList(l);
          DisableSecondList;
          CpuWindow.SelectedAddr:=l;
          CPUWindow.Redraw(ClientRect);
          Item:=CPUList.First;
          CpuWindow.CodeUpScrolled:=Item^.Address;
          CpuWindow.VertScrollBar.Position:=CpuWindow.CodeUpScrolled;

          CpuWindow.BringToFront; {nach oben}
     END;
END;


PROCEDURE TDumpNoteBook.SetupComponent;
BEGIN
     Inherited SetupComponent;

     ZOrder:=zoBottom;
     Align:=alClient;
     TabAlignment:=taBottom;
     ShowPageHint:=FALSE;

     Pages.Clear;
     DumpPage:=TPage(Pages.Objects[Pages.Add(LoadNLSStr(SiDumpPage)+'|'+LoadNLSStr(SiDumpHint))]);
     DumpField.Create(DumpPage);
     DumpField.Align:=alClient;
     DumpPage.InsertControl(DumpField);

     StackPage:=TPage(Pages.Objects[Pages.Add(LoadNLSStr(SiStackPage)+'|'+LoadNLSStr(SiStackPageHint))]);
     StackListBox.Create(StackPage);
     StackListBox.Align:=alClient;
     StackListBox.Color:=clLtGray;
     StackListBox.OnItemSelect:=StackItemSelected;
     StackPage.InsertControl(StackListBox);

     {SourcePage:=TPage(Pages.Objects[Pages.Add('Source|Source view')]);

     ThreadsPage:=TPage(Pages.Objects[Pages.Add('Threads|Threads view')]);}

     PageIndex:=0;

     OnResize:=DumpNoteBookOnResize;
     OnPageChanged:=ActivateAPage;
END;

PROCEDURE TDumpNoteBook.AddStackItem(LinearAddr:LONGWORD);
VAR Line:WORD;
    Source:STRING;
    Module:PModuleInfo;
    s:STRING;
BEGIN
     SearchLineNum(LinearAddr,TRUE,source,Line,Module);
     s:=Source+' ';
     IF Line<>0 THEN s:=s+'('+tostr(Line)+') ';
     s:=s+tohex(LinearAddr);
     IF Module<>NIL THEN s:=s+' '+GetNearestProc(LinearAddr);
     StackListBox.Items.Add(s);
END;

PROCEDURE TDumpNoteBook.UpdateStack;
VAR Buf:TDbgBuf;
    EBP,EIP,TargetEIP:LONGWORD;
    StackList:RECORD
                    OldEBP:LONGWORD;
                    RetEIP:LONGWORD;
              END;
    CallArray:ARRAY[1..5] OF BYTE;
    ActPage:TPage;
LABEL Done;
BEGIN
     IF CPUWindow=NIL THEN exit;
     ActPage:=TPage(Pages.Objects[PageIndex]);

     IF ((not InDebugger)OR(CPUWindow.CurrentAddress=0)OR(ActPage<>StackPage)) THEN
     BEGIN
          //Inherited Update;
          exit;
     END;

     StackListBox.BeginUpdate;

     StackListBox.Clear;
     IF Not GetRegisterSet(Buf) THEN ErrorBox(LoadNLSStr(SiCouldNotGetRegisters))
     ELSE
     BEGIN
          AddStackItem(Buf.EIP);
          IF StackBase=0 THEN goto Done;

          {???????????????????????????????}
          {if the pointer at ESP is a call we use ESP instead of EBP}
          IF not GetDump(Buf.ESP,StackList,8) THEN goto Done;
          TargetEIP:=Buf.EIP;
          IF StackList.OldEBP=Buf.EBP THEN
          BEGIN
               EBP:=StackList.RetEIP; //After push EBP
               dec(TargetEIP);
          END
          ELSE EBP:=StackList.OldEBP;

          IF GetDump(EBP-5,CallArray,5) THEN IF CallArray[1]=$E8 THEN
          BEGIN
               System.Move(CallArray[2],EIP,4);
               IF EBP+EIP<=TargetEIP THEN AddStackItem(EBP-5);
          END;

          EBP:=Buf.EBP;
          WHILE EBP<>StackBase DO
          BEGIN
               IF not GetDump(EBP,StackList,8) THEN goto Done;
               AddStackItem(StackList.RetEIP-5);
               EBP:=StackList.OldEBP;
          END;
     END;
Done:
     StackListBox.EndUpdate;

     //Inherited Update;
END;


{$HINTS OFF}
PROCEDURE TDumpNoteBook.DumpNoteBookOnResize(Sender:TObject);
Begin
     DumpField.LastDumpRecValid:=FALSE;
     IF ActivePage=DumpPage.Caption THEN DumpField.Invalidate
     ELSE IF ActivePage=StackPage.Caption THEN UpdateStack;

     IF IdeSettings.CPUWin.DumpNoteBookHeight <> CPUWindow.BottomToolBar.Height THEN
     BEGIN
          IdeSettings.CPUWin.DumpNoteBookHeight := CPUWindow.BottomToolBar.Height;
          IdeSettings.Modified := TRUE;
     END;
End;
{$HINTS ON}


PROCEDURE TDumpNoteBook.Update;
VAR ActPage:TPage;
BEGIN
     ActPage:=TPage(Pages.Objects[PageIndex]);
     IF ActPage=StackPage THEN UpdateStack
     ELSE Redraw(ClientRect);
END;

PROCEDURE TDumpNoteBook.ActivateAPage(Sender:TObject);
BEGIN
     IF ActivePage=StackPage.Caption THEN UpdateStack;
END;


PROCEDURE SetDebuggerActive;
BEGIN
     DebuggerRunning:=TRUE;
     IF SetDebuggerActiveCallBack<>NIL THEN SetDebuggerActiveCallBack;
END;

PROCEDURE ResetDebuggerActive;
BEGIN
     DebuggerRunning:=FALSE;
     IF ResetDebuggerActiveCallBack<>NIL THEN ResetDebuggerActiveCallBack;
END;


BEGIN
     SetDebuggerActiveProc:=SetDebuggerActive;
     ResetDebuggerActiveProc:=ResetDebuggerActive;
     SetDebuggerActiveCallBack:=NIL;
     ResetDebuggerActiveCallBack:=NIL;
     InitCPUWindowProc := @InitCPUWindow;
END.


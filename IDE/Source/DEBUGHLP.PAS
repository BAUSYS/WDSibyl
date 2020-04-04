
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

UNIT DebugHlp;

INTERFACE

{$IFDEF OS2}
USES BseDos,BseExcpt,PmWin;
{$ENDIF}
{$IFDEF WIN32}
Uses WinBase,WinUser;
{$ENDIF}

USES Messages,SysUtils,Dos,Classes,Forms,Buttons,StdCtrls,Dialogs,Editors,
     DAsm,Consts,BaseEdit,Sib_Ctrl,Projects, Graphics,
     uList, uString;

FUNCTION LoadDbgProcess(CONST Name,Para:STRING;HWindow,HWindowFrame:LONGWORD;StartBrk:BYTE):BOOLEAN;
PROCEDURE UnloadDbgProcess;

TYPE TDumpContents=(dcHexAndChar,dcCharacter,dc16Int,dc16uInt,dc16IntHex,dc32Int,dc32uInt,
                    dc32IntHex,dcSingle,dcDouble,dcExtended,dcComp);

FUNCTION GetNextCPUString(VAR s,Source,SourceFile:STRING;VAR SourceLine:LONGINT;
                          GetDisAsm:BOOLEAN;CurrentAdr:LONGWORD):LONGWORD;
FUNCTION GetNextCPUStringNested(VAR s,Source,SourceFile:STRING;VAR SourceLine:LONGINT;
                          GetDisAsm:BOOLEAN;CurrentAdr:LONGWORD):LONGWORD;
PROCEDURE GetNextDumpString(ContentStyle:TDumpContents;VAR s,s1:STRING;Addr:LONGWORD);
PROCEDURE StepOver;
PROCEDURE StepInto;
PROCEDURE DbgRun;
PROCEDURE EraseCPUAlias;
PROCEDURE NewSourceFileSpec;
PROCEDURE ViewSource;

CONST SecondCPUList:TCPUList=NIL;
      DAsmAvailableEditors:TList=NIL;
      ProgramResetProc:PROCEDURE=NIL;
      ClearDebugListProc:PROCEDURE=NIL;

Const
      GetEditorProc:FUNCTION(Name:STRING):TEditor=NIL;
      GetVDEDirectoriesProc:FUNCTION:STRING=NIL;

PROCEDURE DisableSecondList;
PROCEDURE EnableSecondList;
PROCEDURE SetDebuggerActSrcLine(SourceFile:STRING;Line:LONGINT);
FUNCTION OpenSourceFile(SourceFile:STRING;BringToTop:BOOLEAN):TBaseEditor;

VAR
    SrcDirList:TStringList;
    CPUWindowFont:TFont;
    ShowCPUWindowProc:PROCEDURE(FromIDE:BOOLEAN);

CONST
    DAsmIDELoadEditorProc:FUNCTION(Name:STRING;x,y,w,h:LONGINT;LiX:BOOLEAN;
              fcx:TEditorPos;Fokus:BOOLEAN;ShowIt:Boolean):TBaseEditor=NIL;
    StackBase:LONGWORD=0;
    StartReached:BOOLEAN=FALSE;


PROCEDURE AddSrcDir(Name:STRING);

CONST
     DumpStrs:ARRAY[dcHexAndChar..dcComp] OF STRING[60]=
        (
         ' ?+?+?+?+ ?+?+?+?+ ?+?+?+?+ ?+?+?+?+',                     {Hex and Char}
         ' ????????????????????????????????',                        {Character}
         ' ?+++++ ?+++++ ?+++++ ?+++++ ?+++++ ?+++++ ?+++++ ?+++++', {Integer}
         ' ?+++++ ?+++++ ?+++++ ?+++++ ?+++++ ?+++++ ?+++++ ?+++++', {Word}
         ' ?+++ ?+++ ?+++ ?+++ ?+++ ?+++ ?+++ ?+++',                 {Integer Hex}
         ' ?++++++++++ ?++++++++++ ?++++++++++ ?++++++++++',         {LongInt}
         ' ?++++++++++ ?++++++++++ ?++++++++++ ?++++++++++',         {LongWord}
         ' ?+++++++ ?+++++++ ?+++++++ ?+++++++',                     {LongInt hex}
         ' ?++++++++++++++++++++++',                                 {Single}
         ' ?++++++++++++++++++++++',                                 {Double}
         ' ?++++++++++++++++++++++',                                 {Extended}
         ' ?++++++++++++++++'                                        {Comp}
        );

IMPLEMENTATION

PROCEDURE AddSrcDir(Name:STRING);
VAR  t:LONGINT;
     b:BYTE;
     s:STRING;
LABEL l;
BEGIN
     UpcaseStr(Name);

     WHILE pos(';',Name)<>0 DO
     BEGIN
          b:=pos(';',Name);
          s:=copy(Name,1,b-1);
          IF s[length(s)] IN ['/','\'] THEN dec(s[0]);
          Delete(Name,1,b);
          IF s<>'' THEN
          BEGIN
               FOR t:=0 TO SrcDirList.Count-1 DO
                IF s = SrcDirList.Strings[t] THEN goto l;
               SrcDirList.Add(s);
          END;
l:
     END;

     IF Name[length(Name)] IN ['/','\'] THEN dec(Name[0]);
     IF Name='' THEN exit;

     FOR t:=0 TO SrcDirList.Count-1 DO
        IF Name = SrcDirList.Strings[t] THEN exit;

     SrcDirList.Add(Name);
END;

{sammelt die Directories aller ge”ffneten Dateien}
PROCEDURE AddDAsmEditor(Editor:TBaseEditor);
VAR s,dir,name,ext:STRING;
BEGIN
     s:=Editor.FileName;
     FSplit(s,dir,name,ext);
     dec(dir[0]);
     AddSrcDir(dir);
     IF DAsmAvailableEditors=NIL THEN DAsmAvailableEditors.Create;
     DAsmAvailableEditors.Add(Editor);
(*
     {entferne den ??? Eintrag aus der SourceFilesListe, falls vorhanden}
     {ersetze durch den richtigen Namen}
     IF SourceFilesList <> NIL THEN
     BEGIN
          FOR i := SourceFilesList.Count-1 DOWNTO 0 DO
          BEGIN
               s := Upcased(SourceFilesList[i]);
               //k”nnen wir an dieser Stelle den ???Eintrag entfernen
               //oder muแ der ??? Name ersetzt werde
          END;
     END;
*)
END;

{Also called from UnloadDbgProcess}
PROCEDURE InitDbg;
BEGIN
//  Application.LogWriteln('Debughlp.InitDbg');
  InDebugger:=FALSE;
  StackBase:=0;
  StartReached:=FALSE;
  DebuggerRunning:=FALSE;
  DisAsmCurrentIndex:=0;
  DisAsmSelectedIndex:=0;
  CPUDumpTopAddr:=0;
END;

PROCEDURE EraseCPUAlias;
VAR t:LONGINT;
    Item:PCpuDump;
    DbgBuf:TDbgBuf;
BEGIN
  Application.LogWriteln('Debughlp.EraseCPUAlias');
  FOR t:=0 TO CPUDumpList.Count-1 DO
    BEGIN
      Item:=CPUDumpList.Items[t];
      IF Item^.Alias<>NIL THEN
        BEGIN
          DbgBuf.Cmd:=DBG_C_UNMAPALIAS;
          DbgBuf.Buffer:=LONGWORD(Item^.Alias);
          IF not IssueDebugCommand(DbgBuf) THEN
            ErrorBox('Could not free alias for: '+tohex(Item^.StartAddr));
          Item^.Alias:=NIL;
        END;
     END;
END;


PROCEDURE UnloadDbgProcess;
VAR OldInDebugger:BOOLEAN;
    rc:LONGWORD;
BEGIN
  Application.LogWriteln('Debughlp.UnloadDbgProcess');
  IF CPUList<>NIL THEN CPUList.Clear;
  IF CPUDumpList<>NIL THEN CPUDumpList.Clear;
  IF SourceFilesList<>NIL THEN SourceFilesList.Clear;
  StackBase:=0;
  StartReached:=FALSE;
  IF not InDebugger THEN exit;
  OldInDebugger:=InDebugger;
  DebugUnload;
  InitDbg;
  {ClearSourceBreakPoints(FALSE);}
  {$IFDEF OS2}
  WinSetSysModalWindow(HWND_DESKTOP,0);
  {$ENDIF}
  InDebugger:=FALSE;
  StackBase:=0;
  StartReached:=FALSE;
  IF ResetDebuggerActiveProc<>NIL THEN ResetDebuggerActiveProc;

  {WinInvalidateRect(HWND_DESKTOP,NIL,TRUE);}

  IF OldInDebugger THEN
    BEGIN
      rc := GetProcTermResult;
      IF rc <> 0 THEN ErrorBox(LoadNLSStr(SiProgramTerminatedWithRC)+'='+tostr(rc));
    END;
END;


FUNCTION CPUAvailProc:BOOLEAN;
BEGIN
     result:=TRUE;
     IF LastCommandFromSrc THEN result:=FALSE;
END;

PROCEDURE StartSession(name,para:STRING;HWindow,HWindowFrame:LONGWORD;StartBrk:BYTE);
    PROCEDURE LoadDebuggee;
    VAR ok:BOOLEAN;
    BEGIN
         ok:=DebugLoad(name,para,@CPUAvailProc,HWindow,HWindowFrame,AppQueueHandle,AppHandle);
         IF not ok THEN
         BEGIN
              GetDebugReturn(DbgReturn);
              ErrorBox(DbgReturn.ErrStr);
              exit;
         END;
         InDebugger:=TRUE;
    END;
BEGIN
     IF InDebugger THEN
     BEGIN
          DebugCommand(DBG_C_GO);
          exit;
     END;
     {$IFDEF WIN32}
     SetStartBreakpoint(StartBrk); {Break at start and stop (5 for run again)}
     {$ENDIF}
     LoadDebuggee;
     IF not InDebugger THEN exit;  {Load failed}
     {$IFDEF OS2}
     SetStartBreakpoint(StartBrk); {Break at start and stop (5 for run again)}
     {$ENDIF}
     DebugCommand(DBG_C_GO);
END;


FUNCTION LoadDbgProcess(CONST Name,Para:STRING;HWindow,HWindowFrame:LONGWORD;StartBrk:BYTE):BOOLEAN;
VAR  smfh:^LONGWORD;
BEGIN
     Result := FALSE;

     If @ClearDebugListProc<>Nil Then
       ClearDebugListProc;

     {Handle der MainForm im Shared Memory bereitstellen}
     {$IFDEF OS2}
     IF not AccessNamedSharedMem('SIBYL_MAINFORM_HANDLE', smfh) THEN
       BEGIN
         GetNamedSharedMem('SIBYL_MAINFORM_HANDLE', smfh, SizeOf(LONGWORD));
         smfh^ := Application.MainForm.Handle;
       END;
     {$ENDIF}

     StartSession(Name,Para,HWindow,HWindowFrame,StartBrk);

     IF not InDebugger
       THEN ErrorBox(LoadNLSStr(SiCouldNotLoadProcess))
       ELSE Result := TRUE;

     {Handle der MainForm im Shared Memory wieder ungltig machen}
     {$IFDEF OS2}
     IF AccessNamedSharedMem('SIBYL_MAINFORM_HANDLE', smfh) THEN
       BEGIN
         FreeNamedSharedMem('SIBYL_MAINFORM_HANDLE');
       END;
     {$ENDIF}
END;

TYPE
    TNewSrcDialog=CLASS(TDialog)
         Edit:TEdit;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
    END;

PROCEDURE TNewSrcDialog.CommandEvent(VAR Command:TCommand);
VAR  CFOD:TOpenDialog;
BEGIN
     IF Command = cmRetry THEN
     BEGIN
          CFOD.Create(SELF);
          CFOD.HelpContext := hctxDialogOpenNewSource;
          CFOD.Title := LoadNLSStr(SiSpecifySourceFile);
          CFOD.AddFilter(LoadNLSStr(SiPascalFiles)+' (*.pas)','*.PAS');
          CFOD.FileName := '*.PAS';
          CFOD.DefaultExt := GetDefaultExt('*.PAS');
          IF CFOD.Execute THEN Edit.Text := CFOD.FileName;
          CFOD.Destroy;
     END
     ELSE Inherited CommandEvent(Command);
END;

PROCEDURE TNewSrcDialog.SetupComponent;
VAR  Btn:TBitBtn;
BEGIN
     Inherited SetupComponent;

     Height:=160;
     Width:=350;
     Caption:=LoadNLSStr(SiSourceFileNotFound);

     InsertLabelNLS(SELF,10,95,320,20,SiSpecifyAnotherFile);
     Edit:=InsertEdit(SELF,10,70,320,20,'','');
     Edit.Focus;
     InsertBitBtnNLS(SELF,10,22,90,30,bkOk,SOkButton,0);
     InsertBitBtnNLS(SELF,110,22,90,30,bkCancel,SCancelButton,0);
     Btn := InsertBitBtnNLS(SELF,210,22,90,30,bkRetry,SiBrowse,0);
     Btn.ModalResult := cmNull;
END;

FUNCTION GetCurrentSrcFileInfo(Addr:LONGWORD;Module:PModulesLoaded;VAR NearestLine:WORD):PSourceFileItem;
VAR
    ModuleInfo,dummy:PModuleInfo;
    SourceFile:STRING;
    t:LONGINT;
    s,Dir,Name,Ext:STRING;
LABEL found;
BEGIN
     result:=NIL;
     ModuleInfo:=NIL;
     IF Module<>NIL THEN
     BEGIN
          dummy:=Module^.DebugModules;
          WHILE dummy<>NIL DO
          BEGIN
               IF Addr>=dummy^.CodeOffs THEN
                IF Addr<=dummy^.CodeOffs+dummy^.CodeLen THEN
               BEGIN
                    {Debug Module found}
                    IF ModuleInfo<>NIL THEN
                    BEGIN
                         IF ModuleInfo^.CodeOffs<dummy^.CodeOffs THEN ModuleInfo:=dummy;
                    END
                    ELSE ModuleInfo:=dummy;
               END;
               dummy:=dummy^.Next;
          END;

          IF ModuleInfo<>NIL THEN
          BEGIN
               GetLineFromEIP(Addr,TRUE,SourceFile,NearestLine,ModuleInfo);
               IF NearestLine<>0 THEN
               BEGIN
                    FOR t:=0 TO SourceFilesList.Count-1 DO
                    BEGIN
                         result:=SourceFilesList.Items[t];
                         s:=result^.Name;
                         IF pos('???',s)=1 THEN
                         BEGIN
                              Delete(s,1,3);
                              FSplit(s,Dir,Name,Ext);
                         END
                         ELSE FSplit(s,Dir,Name,Ext);
                         IF Name+Ext=SourceFile THEN goto found;
                    END;
                    {not found}
                    New(result);
                    result^.Name:='???'+SourceFile;
                    result^.Lines.Create;
                    SourceFilesList.Add(result);
found:
               END;
          END;
    END;
END;


PROCEDURE NewSourceFileSpec;
VAR SourceFileInfo:PSourceFileItem;
    Item:PCPUListItem;
    s,s1:STRING;
    NewSrc:TNewSrcDialog;
    Dir,Name,Ext:STRING;
    so:TEXT;
    NearestLine:WORD;
LABEL again,err;
BEGIN
     IF CPUList.Count=0 THEN exit;
     Item:=CPUList.First;
     IF Item^.SourceFileInfo=NIL THEN
     BEGIN
          SourceFileInfo:=GetCurrentSrcFileInfo(Item^.Address,Item^.CPUDump^.Module,NearestLine);
          IF SourceFileInfo=NIL THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiModuleContainNoSourceFile));
               exit;
          END;
     END
     ELSE SourceFileInfo:=Item^.SourceFileInfo;

     s:=SourceFileInfo^.Name;
     IF pos('???',s)=1 THEN Delete(s,1,3);
     NewSrc.Create(Application.MainForm);
     NewSrc.HelpContext := hctxDialogNewSource;
     NewSrc.Edit.Text:=s;
     NewSrc.Caption:=LoadNLSStr(SiChangeSourceFile);
again:
     IF NewSrc.Execute THEN
     BEGIN
          s:=NewSrc.Edit.Text;
          IF s=SourceFileInfo^.Name THEN
          BEGIN
               NewSrc.Destroy;
               exit;
          END;
          assign(so,s);
          {$i-}
          reset(so);
          {$i+}
          IF InOutRes<>0 THEN
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[s]));
               goto again;
          END;

          SourceFileInfo^.Lines.Clear;
          WHILE not EOF(so) DO
          BEGIN
               {$i-}
               readln(so,s1);
               {$I+}
               IF InOutRes<>0 THEN
               BEGIN
                    ErrorBox(FmtLoadNLSStr(SiFileReadError,[s1]));
                    goto err;
               END;
               SourceFileInfo^.Lines.Add(s1);
          END;
err:
          {$i-}
          close(so);
          {$i+}
          s:=NewSrc.Edit.Text;
          SourceFileInfo^.Name:=s;
          FSplit(s,Dir,Name,Ext);
          dec(Dir[0]);
          AddSrcDir(Dir);
          NewSrc.Destroy;
          CPUList.Clear;
     END
     ELSE
     BEGIN
          IF pos('???',SourceFileInfo^.Name)=0 THEN
            SourceFileInfo^.Name:='???'+SourceFileInfo^.Name;
          NewSrc.Destroy;
     END;
END;

TYPE
    TViewSrcDialog=CLASS(TDialog)
          ListBox:TListBox;
          PROCEDURE SetupComponent;OVERRIDE;
          PROCEDURE EvListItemSelected(Sender:TObject;Index:LONGINT);
    END;


{$HINTS OFF}
PROCEDURE TViewSrcDialog.EvListItemSelected(Sender:TObject;Index:LONGINT);
BEGIN
     DismissDlg(cmOk);
END;
{$HINTS ON}


PROCEDURE TViewSrcDialog.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Width:=320;
     Height:=320;
     Caption:=LoadNLSStr(SiSelectASourceModule);
     ListBox:=InsertListBox(SELF,10,65,290,210,'');
     ListBox.OnItemSelect:=EvListItemSelected;
     InsertBitBtnNLS(SELF,50,22,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,160,22,90,30,bkCancel,SCancelButton,SClickHereToCancel);
END;



FUNCTION GetDebugEditor(SourceFile:STRING):TBaseEditor;
VAR  t:LONGINT;
BEGIN
     IF DAsmAvailableEditors <> NIL THEN
     BEGIN
          UpcaseStr(SourceFile);
          FOR t := 0 TO DAsmAvailableEditors.Count-1 DO
          BEGIN
               Result := DAsmAvailableEditors.Items[t];
               IF Upcased(Result.FileName) = SourceFile THEN exit;
          END;
     END;

     Result := NIL;
END;


FUNCTION GetVDEDirectories:STRING;
BEGIN
  IF @GetVDEDirectoriesProc <> NIL
     THEN Result := GetVDEDirectoriesProc
     ELSE Result := '';
END;


{SourceFile is a NameExt string}
FUNCTION OpenSourceFile(SourceFile:STRING;BringToTop:BOOLEAN):TBaseEditor;
VAR
  s,dir,name,ext:STRING;
  RestoreName:STRING;
  DebuggerDir:STRING;
  sfi:PSourceFileItem;
  NewSrc:TNewSrcDialog;
  t:LONGINT;

  FUNCTION LoadDebugEditor(CONST FName:STRING):TBaseEditor;
  BEGIN
       Result := GetDebugEditor(FName);
       IF Result <> NIL THEN exit;
       Result := DAsmIDELoadEditorProc(FName,0,0,0,0,FALSE,EditorPos(1,1),TRUE,TRUE);
  END;

LABEL
  cpu,NewSrcAgain;
BEGIN
     Result := NIL;

     UpcaseStr(SourceFile);

     IF pos('???',SourceFile) <> 0 THEN exit;

     {Teste, ob das File im Editor existiert - checke alle bekannten Pfadnamen}

     DebuggerDir := GetVDEDirectories;        {get all VDE Debug dir's}
     RestoreName := SourceFile;
     REPEAT
          SourceFile := RestoreName;          {restore name and try again}
          IF pos(':\',SourceFile) = 0 THEN   {kein ganzer Pfadname}
          BEGIN
               dir := GetNextDir(DebuggerDir);
               IF dir = '' THEN continue;
               SourceFile := dir +'\'+ SourceFile;
          END;
          Result := GetDebugEditor(SourceFile);
     UNTIL (Result <> NIL) OR (DebuggerDir = ''); {test all sources in the editor}

     {Teste, ob das File im Editor existiert - checke alle Name + Extension}

     IF Result = NIL THEN {File not loaded}
     BEGIN
          SourceFile := RestoreName;          {restore name and try again}

          IF DAsmAvailableEditors <> NIL THEN
          BEGIN
               FOR t := 0 TO DAsmAvailableEditors.Count-1 DO
               BEGIN
                    Result := DAsmAvailableEditors.Items[t];
                    s := Upcased(Result.FileName);
                    FSplit(s, dir,name,ext);

                    IF name + ext = SourceFile THEN break
                    ELSE Result := NIL;
               END;
          END;
     END;

     {Teste die SourceFilesList - checke die ??? Eintrge}

     IF Result = NIL THEN {File not loaded}
     BEGIN
          FOR t := 0 TO SourceFilesList.Count-1 DO
          BEGIN
               SourceFile := RestoreName;
               sfi := SourceFilesList.Items[t];
               s := sfi^.Name;
               IF pos('???',s) = 1 THEN Delete(s,1,3);
               FSplit(s,dir,name,ext);

               IF Upcased(name + ext) = SourceFile THEN
               BEGIN
                    SourceFile := sfi^.Name;
                    IF FileExists(SourceFile) THEN {Try to load the file into Editor}
                    BEGIN
                         Result := LoadDebugEditor(SourceFile);
                         IF Result <> NIL THEN break;
                    END;
               END;
          END;
     END;

     {Teste die SrcDirList - enthlt die Pfade alle bisher ge”ffneten Files}

     IF Result = NIL THEN {File not loaded}
     BEGIN
          FOR t := 0 TO SrcDirList.Count-1 DO
          BEGIN
               SourceFile := RestoreName;
               s := SrcDirList[t];
               NormalizeDir(s);
               SourceFile := s + '\' + SourceFile;

               IF FileExists(SourceFile) THEN {Try to load the file into Editor}
               BEGIN
                    Result := LoadDebugEditor(SourceFile);
                    IF Result <> NIL THEN break;
               END;
          END;
     END;

     {Teste alle bekannten Pfade der IDE}

     IF Result = NIL THEN {File not loaded}
     BEGIN
          DebuggerDir := GetVDEDirectories;
          REPEAT
               SourceFile := RestoreName;
               IF pos(':\',SourceFile) = 0 THEN
               BEGIN
                    dir := GetNextDir(DebuggerDir);
                    SourceFile := dir +'\'+ SourceFile;
               END;

               IF FileExists(SourceFile) THEN {Try to load the file into Editor}
               BEGIN
                    Result := LoadDebugEditor(SourceFile);
                    IF Result <> NIL THEN break;
               END;
          UNTIL (Result <> NIL) OR (DebuggerDir = '');
     END;

     {Neuen Filenamen angeben}

     IF Result = NIL THEN {File not loaded}
     BEGIN
          SourceFile := RestoreName;

          {Enter new filespec}
          IF pos('???',SourceFile) = 1 THEN goto cpu;   {CPU Fenster anzeigen}
NewSrcAgain:
          NewSrc.Create(Application.MainForm);
          NewSrc.HelpContext := hctxDialogNewSource;
          FSplit(SourceFile, dir,name,ext);
          NewSrc.Caption := FmtLoadNLSStr(SiSrcFileNotFound,[name + ext]);
          NewSrc.Edit.Text := SourceFile;

          IF NewSrc.Execute THEN
          BEGIN
               SourceFile := NewSrc.Edit.Text;
               NewSrc.Destroy;

               IF FileExists(SourceFile) THEN {Try to load the file into Editor}
               BEGIN
                    FSplit(SourceFile,dir,name,ext);
                    dec(dir[0]);
                    AddSrcDir(dir);
                    Result := LoadDebugEditor(SourceFile);
               END
               ELSE
               BEGIN
                    ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[SourceFile]));
                    SourceFile := RestoreName;
                    goto NewSrcAgain;
               END;
          END
          ELSE
          BEGIN
               NewSrc.Destroy;
               New(sfi);
               sfi^.Name := '???'+ SourceFile;
               sfi^.Lines.Create;
               SourceFilesList.Add(sfi);
cpu:
               LastCommandFromSrc := FALSE;
               ShowCPUWindowProc(FALSE);
               exit;
          END;
     END;


     IF Result <> NIL THEN
     BEGIN
          Result.Visible := TRUE;
          Result.Show;
          Result.ToTop;
          IF Result.WindowState = wsMinimized THEN Result.WindowState := wsNormal;
     END;
END;

PROCEDURE EditorCloseProc(Editor:TEditor);
BEGIN
     IF DAsmAvailableEditors<>NIL THEN
     BEGIN
          DAsmAvailableEditors.Remove(Editor);
          IF DAsmAvailableEditors.Count=0 THEN
          BEGIN
               DAsmAvailableEditors.Destroy;
               DAsmAvailableEditors:=NIL;
          END;
     END;
     IF Editor=LastDbgEditor THEN LastDbgEditor:=NIL;
END;

PROCEDURE SetDebuggerActSrcLine(SourceFile:STRING;Line:LONGINT);
VAR Editor:TBaseEditor;
BEGIN
     Editor:=OpenSourceFile(SourceFile,LastCommandFromSrc);
     IF Editor<>LastDbgEditor THEN
       IF LastDbgEditor<>NIL THEN LastDbgEditor.SetDebuggerLine(-1); {clear}
     IF Editor<>NIL THEN Editor.SetDebuggerLine(Line);
     LastDbgEditor:=Editor;
END;

PROCEDURE ViewSource;
VAR TheSrcList:TList;
    ModLoaded:PModulesLoaded;
    ModInfo:PModuleInfo;
    t:LONGINT;
    ViewSrcDlg:TViewSrcDialog;
    s:STRING;
LABEL again;
BEGIN
     TheSrcList.Create;
     ModLoaded:=GetModulesLoaded;
     WHILE ModLoaded<>NIL DO
     BEGIN
          ModInfo:=ModLoaded^.DebugModules;
          WHILE ModInfo<>NIL DO
          BEGIN
               TheSrcList.Add(ModInfo);
               ModInfo:=ModInfo^.Next;
          END;
          ModLoaded:=ModLoaded^.Next;
     END;
     IF TheSrcList.Count=0 THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiNoSourceFileInfoAvail));
          TheSrcList.Destroy;
          exit;
     END;

     ViewSrcDlg.Create(Application.MainForm);
     ViewSrcDlg.HelpContext := hctxDialogViewSource;
     ViewSrcDlg.ListBox.Sorted := TRUE;
     FOR t:=0 TO TheSrcList.Count-1 DO
     BEGIN
          ModInfo:=TheSrcList.Items[t];
          ViewSrcDlg.ListBox.Items.Add(ModInfo^.SourceFile);
     END;
again:
     IF ViewSrcDlg.Execute THEN
     BEGIN
          t:=ViewSrcDlg.ListBox.ItemIndex;
          IF t>=0 THEN
          BEGIN
               s:=ViewSrcDlg.ListBox.Items.Strings[t];
               ViewSrcDlg.Destroy;
               OpenSourceFile(s,TRUE);
          END
          ELSE
          BEGIN
               ErrorBox(LoadNLSStr(SiSelectAnItemOrPressCancel));
               goto again;
          END;
     END
     ELSE ViewSrcDlg.Destroy;

     TheSrcList.Destroy;
END;

FUNCTION GetSourceLineInfo(SourceFile:STRING;VAR Source:STRING;VAR Line:WORD):PSourceFileItem;
VAR t:LONGINT;
    so:TEXT;
    s:STRING;
    NewSrc:TNewSrcDialog;
    IsEntered:BOOLEAN;
    dir,name,ext:STRING;
LABEL found,err,again,found1;
BEGIN
     result:=NIL;
     FOR t:=0 TO SourceFilesList.Count-1 DO
     BEGIN
          result:=SourceFilesList.Items[t];
          s:=result^.Name;
          IF pos('???',s)=1 THEN
          BEGIN
               Delete(s,1,3);
               FSplit(s,Dir,Name,Ext);
          END
          ELSE FSplit(s,Dir,Name,Ext);
          IF Name+Ext=SourceFile THEN goto found;
     END;

     IF pos('???',SourceFile)=1 THEN exit;
     IsEntered:=FALSE;
again:
     result:=NIL;
     {Look if we can open source}
     assign(so,SourceFile);
     {$i-}
     reset(so);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          FOR t:=0 TO SrcDirList.Count-1 DO
          BEGIN
               s := SrcDirList.Strings[t] + '\' + SourceFile;
               assign(so,s);
               {$i-}
               reset(so);
               {$i+}
               IF InOutRes=0 THEN
               BEGIN
                    SourceFile:=s;
                    goto found1;
               END;
          END;

          {Enter new filespec}
          IF IsEntered THEN ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[SourceFile]));
          IsEntered:=TRUE;
          NewSrc.Create(Application.MainForm);
          NewSrc.HelpContext := hctxDialogNewSource;
          FSplit(SourceFile,dir,name,ext);
          NewSrc.Caption:=FmtLoadNLSStr(SiSrcFileNotFound,[name+ext]);
          NewSrc.Edit.Text:=SourceFile;
          IF NewSrc.Execute THEN
          BEGIN
               SourceFile:=NewSrc.Edit.Text;
               FSplit(SourceFile,Dir,Name,Ext);
               dec(Dir[0]);
               AddSrcDir(Dir);
               NewSrc.Destroy;
               goto again;
          END
          ELSE
          BEGIN
               NewSrc.Destroy;
               Source:='';
               New(result);
               result^.Name:='???'+SourceFile;
               result^.Lines.Create;
               SourceFilesList.Add(result);
               Line:=0;
               exit;
          END;
     END;
found1:
     New(result);
     result^.Name:=SourceFile;
     result^.Lines.Create;

     WHILE not EOF(so) DO
     BEGIN
          {$i-}
          readln(so,s);
          {$I+}
          IF InOutRes<>0 THEN
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiFileReadError,[SourceFile]));
               goto err;
          END;
          result^.Lines.Add(s);
     END;
err:
     SourceFilesList.Add(result);
     {$i-}
     close(so);
     {$i+}
found:
     Source:='';
     dec(Line);
     IF ((Line<0)OR(Line>result^.Lines.Count-1)) THEN Line:=0
     ELSE Source:=result^.Lines.Strings[Line];
END;

PROCEDURE GetSrcModule(Item:PCPUListItem);
VAR
    Module:PModulesLoaded;
    ModuleInfo,dummy:PModuleInfo;
    Line:WORD;
    SourceFile:STRING;
BEGIN
     Item^.Source:='';
     Item^.SourceLine:=0;
     Item^.SourceFileInfo:=NIL;
     Module:=Item^.CPUDump^.Module;
     ModuleInfo:=NIL;
     IF Module<>NIL THEN
     BEGIN
          dummy:=Module^.DebugModules;
          WHILE dummy<>NIL DO
          BEGIN
               IF Item^.Address>=dummy^.CodeOffs THEN
                IF Item^.Address<=dummy^.CodeOffs+dummy^.CodeLen THEN
               BEGIN
                    {Debug Module found}
                    IF ModuleInfo<>NIL THEN
                    BEGIN
                         IF ModuleInfo^.CodeOffs<dummy^.CodeOffs THEN ModuleInfo:=dummy;
                    END
                    ELSE ModuleInfo:=dummy;
               END;
               dummy:=dummy^.Next;
          END;

          IF ModuleInfo<>NIL THEN
          BEGIN
               GetLineFromEIP(Item^.Address,FALSE,SourceFile,Line,ModuleInfo);
               IF Line<>0 THEN
               BEGIN
                    Item^.SourceFileInfo:=GetSourceLineInfo(SourceFile,Item^.Source,Line);
                    Item^.SourceLine:=Line;
                    Item^.SourceFile:=SourceFile;
               END;
          END;
    END;
END;

PROCEDURE DisAssemble_Item(Item:PCPUListItem;pp:POINTER);
BEGIN
     Item^.DisAssembly:=DisAssemble(pp,Item^.Len,Item^.CPUDump);
     GetSrcModule(Item);
END;

PROCEDURE DisAssembleBack_Item(Item:PCPUListItem;MaxAddress:LONGINT;pp:POINTER);
BEGIN
     Item^.DisAssembly:=DisAssembleBack(pp,Item^.Len,Item^.CPUDump);
     Item^.Address:=MaxAddress-Item^.Len;
     GetSrcModule(Item);
END;

FUNCTION InitDump(Address:LONGWORD):PCPUDump;
VAR DbgBuf:TDbgBuf;
    Len,Start:LONGWORD;
    t:LONGINT;
    Module:PModulesLoaded;
    ModuleInfo:PModuleInfo;
    Objects:PObjectList;
    ret:LONGINT;
LABEL weiter;
BEGIN
     result:=NIL;
     DbgBuf.Addr:=Address;
     DbgBuf.Cmd:=DBG_C_ADDRTOOBJECT;
     IF IssueDebugCommand(DbgBuf) THEN
     BEGIN
          {Look if the object is already present}
          FOR t:=0 TO CPUDumpList.Count-1 DO
          BEGIN
               result:=CPUDumpList.Items[t];
               IF result^.StartAddr=DbgBuf.Buffer THEN exit;
          END;

          ModuleInfo:=NIL;
          {Look if Module handle is present}
          {$IFDEF OS2}
          IF DbgBuf.Value AND DBG_O_OBJMTE<>0 THEN
          BEGIN
               Module:=GetModulesLoaded;
               WHILE Module<>NIL DO
               BEGIN
                    IF Module^.MTE=DbgBuf.MTE THEN {found}
                    BEGIN
                         Objects:=Module^.Objects;
                         WHILE Objects<>NIL DO
                         BEGIN
                              IF DbgBuf.Buffer>=Objects^.Start THEN
                                IF DbgBuf.Buffer+DbgBuf.Len<=Objects^.Start+Objects^.Len THEN {found}
                              BEGIN
                                   goto weiter;
                              END;
                              Objects:=Objects^.Next;
                         END;
                         goto weiter;
                    END;
                    Module:=Module^.Next;
               END;
          END
          ELSE {$ENDIF} Module:=NIL;
          {$IFDEF WIN32}
          Module:=GetModulesLoaded;
          WHILE Module<>NIL DO
          BEGIN
               Objects:=Module^.Objects;
               WHILE Objects<>NIL DO
               BEGIN
                    IF DbgBuf.Buffer>=Objects^.Start THEN
                       IF DbgBuf.Buffer+DbgBuf.Len<=Objects^.Start+Objects^.Len THEN {found}
                    BEGIN
                         DbgBuf.Buffer:=Objects^.Start;
                         DbgBuf.Len:=Objects^.Len;
                         goto weiter;
                    END;
                    Objects:=Objects^.Next;
               END;
               Module:=Module^.Next;
          END;

          IF DbgBuf.Len=0 Then DbgBuf.Len:=$FFFFFFFF;
          {$ENDIF}
weiter:
          result:=NIL;
          DbgBuf.Cmd:=DBG_C_MAPROALIAS;
          Start:=DbgBuf.Buffer;
          DbgBuf.Addr:=DbgBuf.Buffer;
          DbgBuf.Buffer:=0;
          {Len in DbgBuf.Len}
          Len:=DbgBuf.Len;
          IF IssueDebugCommand(DbgBuf) THEN
          BEGIN
               new(result);
               result^.StartAddr:=Start;
               result^.Len:=Len;
               result^.Alias:=POINTER(DbgBuf.Buffer); {Alias region}
               result^.Module:=Module;
               result^.Objects:=Objects;

               {Generate valid address items for this entry}
               {$IFDEF OS2}
               ret:=DosQueryMem(result^.Alias,result^.Len,Start);
               IF ret<>0 THEN
               BEGIN
                    Dispose(Result);
                    //ErrorBox('Fatal Error in DosQueryMem (Code:'+tostr(ret)+')');
                    IF ProgramResetProc<>NIL THEN ProgramResetProc
                    ELSE UnloadDbgProcess;
                    result:=NIL;
                    exit;
               END;
               IF Start AND (PAG_READ OR PAG_COMMIT)<>(PAG_READ OR PAG_COMMIT) THEN
               BEGIN
                    Dispose(Result);
                    //ErrorBox('Fatal Error in DosQueryMem (Page not accessible)');
                    IF ProgramResetProc<>NIL THEN ProgramResetProc
                    ELSE UnloadDbgProcess;
                    result:=NIL;
                    exit;
               END;
               {$ENDIF}

               CPUDumpList.Add(result);
          END
          ELSE ErrorBox('IssueDbgCommand failed (Map alias)');
     END
     ELSE ErrorBox('IssueDbgCommand failed (Addr2Object)');
END;

{Get next CPU string (address or disassembly}
FUNCTION GetNextCPUString(VAR s,Source,SourceFile:STRING;VAR SourceLine:LONGINT;
                          GetDisAsm:BOOLEAN;CurrentAdr:LONGWORD):LONGWORD;
VAR Item:PCPUListItem;
    Address:LONGWORD;
    p:POINTER;
    CPUDump:PCPUDump;
LABEL err,ex;
BEGIN
     IF ((not InDebugger)OR(not StartReached)OR(CurrentAdr=0)) THEN goto err;
     IF DisAsmCurrentIndex>CPUList.Count-1 THEN
     BEGIN
          {Disassemble next line}
          IF CPUList.Count=0 THEN
          BEGIN
               {Get start address from debugger}
               IF not InDebugger THEN
               BEGIN
err:
                    IF GetDisAsm THEN s:='???'
                    ELSE s:='????????';
                    Source:='';
                    SourceFile:='';
                    SourceLine:=0;
                    result:=0;
                    exit;
               END;
               Address:=CurrentAdr;
               CPUDump:=InitDump(Address);
               IF CPUDump=NIL THEN goto err;
               CPUDumpTopAddr:=Address;
          END
          ELSE
          BEGIN
               Item:=CPUList.Last;
               Address:=Item^.Address+Item^.Len;
               CPUDump:=Item^.CPUDump;
          END;

          IF Address<CPUDump^.StartAddr THEN Address:=CPUDump^.StartAddr;
          IF Address>CPUDump^.StartAddr+CPUDump^.Len THEN Address:=CPUDump^.StartAddr+CPUDump^.Len;
          New(Item);
          Item^.Address:=Address;
          Item^.CPUDump:=CPUDump;
          CPUList.Add(Item);
          {$IFDEF OS2}
          p:=CPUDump^.Alias;
          inc(p,Address-CPUDump^.StartAddr);
          {$ENDIF}
          {$IFDEF WIN32}
          p:=Pointer(Address);
          {$ENDIF}
          DisAssemble_Item(Item,p);
     END
     ELSE IF DisAsmCurrentIndex=-1 THEN {new string on pos 0}
     BEGIN
          Item:=CPUList.First;
          CPUDump:=Item^.CPUDump;
          Address:=Item^.Address;
          New(Item);
          Item^.CPUDump:=CPUDump;
          CPUList.Insert(0,Item);
          {$IFDEF OS2}
          p:=CPUDump^.Alias;
          inc(p,Address-CPUDump^.StartAddr);
          {$ENDIF}
          {$IFDEF WIN32}
          p:=Pointer(Address);
          {$ENDIF}
          DisAssembleBack_Item(Item,Address,p);
          CPUDumpTopAddr:=Item^.Address;
          DisAsmCurrentIndex:=0;
     END;

     Item:=CPUList.Items[DisAsmCurrentIndex];

     IF not GetDisAsm THEN
     BEGIN
          s:=tohex(Item^.Address);
          Source:=Item^.Source;
          SourceLine:=Item^.SourceLine;
          SourceFile:=Item^.SourceFile;
          Delete(s,1,1);  {erase $}
     END
     ELSE
     BEGIN
          s:=Item^.DisAssembly;
          Source:=Item^.Source;
          SourceLine:=Item^.SourceLine;
          SourceFile:=Item^.SourceFile;
     END;
ex:
     inc(DisAsmCurrentIndex);
     result:=Item^.Address;
END;

PROCEDURE EnableSecondList;
VAR t:LONGINT;
    Item:PCPUListItem;
    NewItem:PCPUListItem;
BEGIN
     SecondCPUList.Create;
     FOR t:=0 TO CPUList.Count-1 DO
     BEGIN
          Item:=CPUList.Items[t];
          New(NewItem);
          NewItem^:=Item^;
          SecondCPUList.Add(NewItem);
     END;
END;

PROCEDURE DisableSecondList;
BEGIN
     SecondCPUList.Destroy;
     SecondCPUList:=NIL;
END;

{Get next CPU string (address or disassembly}
FUNCTION GetNextCPUStringNested(VAR s,Source,SourceFile:STRING;VAR SourceLine:LONGINT;
                          GetDisAsm:BOOLEAN;CurrentAdr:LONGWORD):LONGWORD;
VAR Item:PCPUListItem;
    List:TCPUList;
LABEL err;
BEGIN
     IF ((not InDebugger)OR(CurrentAdr=0)) THEN goto err;
     IF SecondCPUList<>NIL THEN List:=SecondCPUList
     ELSE List:=CPUList;
     IF ((DisAsmCurrentIndex>List.Count-1)OR(DisAsmCurrentIndex=-1)) THEN
     BEGIN
err:
         IF GetDisAsm THEN s:='???'
         ELSE s:='????????';
         Source:='';
         SourceFile:='';
         SourceLine:=0;
         result:=0;
         exit;
     END;

     Item:=List.Items[DisAsmCurrentIndex];

     IF not GetDisAsm THEN
     BEGIN
          s:=tohex(Item^.Address);
          Source:=Item^.Source;
          SourceLine:=Item^.SourceLine;
          SourceFile:=Item^.SourceFile;
          Delete(s,1,1);  {erase $}
     END
     ELSE
     BEGIN
          s:=Item^.DisAssembly;
          Source:=Item^.Source;
          SourceLine:=Item^.SourceLine;
          SourceFile:=Item^.SourceFile;
     END;

     inc(DisAsmCurrentIndex);
     result:=Item^.Address;
END;

PROCEDURE StepOver;
BEGIN
     IF not InDebugger THEN exit;
     IF DebuggerRunning THEN exit;
     LastCommandFromSrc:=FALSE;
     DebugCommand(DBG_C_SSTEP);
END;

PROCEDURE DbgRun;
BEGIN
     IF not InDebugger THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiNoProcessLoaded));
          exit;
     END;
     IF DebuggerRunning THEN exit;

     LastCommandFromSrc:=FALSE;
     DebugCommand(DBG_C_GO);
END;

PROCEDURE StepInto;
BEGIN
     IF not InDebugger THEN exit;
     IF DebuggerRunning THEN exit;
     LastCommandFromSrc:=FALSE;
     DebugCommand(DBG_C_STEPINTO);
END;

PROCEDURE GetNextDumpString(ContentStyle:TDumpContents;VAR s,s1:STRING;Addr:LONGWORD);
VAR TheDump:ARRAY[1..64] OF BYTE;
    t,l:LONGINT;
    lw:LONGWORD;
    i:INTEGER;
    w:WORD;
    temp:STRING;
    ch:CHAR;
    si:SINGLE;
    d:Double;
    e:Extended;
    c:Comp;
LABEL err;
BEGIN
     s1:='';
     IF ((not InDebugger)OR(not StartReached)) THEN
     BEGIN
err:
          s:=DumpStrs[ContentStyle];
          FOR t:=1 TO length(s) DO IF s[t]='+' THEN s[t]:='?';
          s:=s+' ';
          IF ContentStyle=dcHexAndChar THEN s1:=' ????????????????';
     END
     ELSE
     BEGIN
          s:=' ';
          CASE ContentStyle OF
             dcHexAndChar:
             BEGIN
                  IF not GetDump(Addr,TheDump,16) THEN goto err;

                  s:=' ';
                  FOR t:=1 TO 16 DO
                  BEGIN
                       temp:=tohex(TheDump[t]);
                       Delete(temp,1,7);
                       s:=s+temp;
                       IF t AND 3=0 THEN s:=s+' ';
                  END;

                  s1:=' ';
                  FOR t:=1 TO 16 DO
                  BEGIN
                       ch:=chr(TheDump[t]);
                       IF ch<#32 THEN ch:='.';
                       s1:=s1+ch;
                  END;
             END;
             dcCharacter:
             BEGIN
                  IF not GetDump(Addr,TheDump,32) THEN goto err;
                  FOR t:=1 TO 32 DO
                  BEGIN
                       ch:=chr(TheDump[t]);
                       IF ch<#32 THEN ch:='.';
                       s:=s+ch;
                  END;
             END;
             dc16Int:
             BEGIN
                  IF not GetDump(Addr,TheDump,16) THEN goto err;

                  FOR t:=0 TO 7 DO
                  BEGIN
                       move(TheDump[(t*2)+1],i,2);
                       STR(i:6,s1);
                       s:=s+s1+' ';
                  END;
             END;
             dc16uInt:
             BEGIN
                  IF not GetDump(Addr,TheDump,16) THEN goto err;

                  FOR t:=0 TO 7 DO
                  BEGIN
                       move(TheDump[(t*2)+1],w,2);
                       STR(w:6,s1);
                       s:=s+s1+' ';
                  END;
             END;
             dc16IntHex:
             BEGIN
                  IF not GetDump(Addr,TheDump,16) THEN goto err;

                  FOR t:=0 TO 7 DO
                  BEGIN
                       move(TheDump[(t*2)+1],w,2);
                       s1:=tohex(w);
                       Delete(s1,1,5);
                       s:=s+s1+' ';
                  END;
             END;
             dc32Int:
             BEGIN
                  IF not GetDump(Addr,TheDump,16) THEN goto err;

                  FOR t:=0 TO 3 DO
                  BEGIN
                       move(TheDump[(t*4)+1],l,4);
                       STR(l:11,s1);
                       s:=s+s1+' ';
                  END;
             END;
             dc32uInt:
             BEGIN
                  IF not GetDump(Addr,TheDump,16) THEN goto err;

                  FOR t:=0 TO 3 DO
                  BEGIN
                       move(TheDump[(t*4)+1],lw,4);
                       STR(lw:11,s1);
                       s:=s+s1+' ';
                  END;
             END;
             dc32IntHex:
             BEGIN
                  IF not GetDump(Addr,TheDump,16) THEN goto err;

                  FOR t:=0 TO 3 DO
                  BEGIN
                       move(TheDump[(t*4)+1],lw,4);
                       s1:=tohex(lw);
                       Delete(s1,1,1);
                       s:=s+s1+' ';
                  END;
             END;
             dcSingle:
             BEGIN
                  IF not GetDump(Addr,TheDump,4) THEN goto err;
                  move(TheDump[1],si,4);
                  STR(si,s1);
                  s:=s+s1+' ';
             END;
             dcDouble:
             BEGIN
                  IF not GetDump(Addr,TheDump,8) THEN goto err;
                  move(TheDump[1],d,8);
                  STR(d,s1);
                  s:=s+s1+' ';
             END;
             dcExtended:
             BEGIN
                  IF not GetDump(Addr,TheDump,10) THEN goto err;
                  move(TheDump[1],e,10);
                  STR(e,s1);
                  s:=s+s1+' ';
             END;
             dcComp:
             BEGIN
                  IF not GetDump(Addr,TheDump,8) THEN goto err;
                  move(TheDump[1],c,8);
                  STR(c,s1);
                  s:=s+s1+' ';
             END;
             ELSE goto err;
          END; {case}
     END;
END;

BEGIN
  AddDAsmEditorNotify:=@AddDasmEditor;
  DAsmEditorCloseNotify:=@EditorCloseProc;
  CPUWindowFont:=Screen.GetFontFromPointSize('Courier',8);
  SrcDirList.Create;
  InitDbg;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  08-Aug-03  WD         Ausbau der MyExit-Funktion
}

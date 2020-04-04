
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

UNIT Compiler;

INTERFACE

{$IFDEF OS2}
USES Os2Def,BseTib,PmWin,BseDos,PmStdDlg;
{$ENDIF}

{$IFDEF WIN32}
Uses WinBase;
{$ENDIF}

USES Dos,SysUtils,Color,Classes,Forms,Dialogs,Editors,
     uWDSibylThrd,
     SPC_Data,Consts,Projects,Sib_Prj,BaseForm,Sib_Edit,Inspect,
     DAsm,DebugHlp,DisAsm,DbgWatch,
     uSysinfo, uSysClass, uStream, uString;

PROCEDURE Run(viaDebug:BOOLEAN);
PROCEDURE Compile;
PROCEDURE Make;
PROCEDURE Build;
PROCEDURE ForceCompile(Action:TCompilerActions;FileName:STRING);
PROCEDURE StopCompiler;
FUNCTION  RunCompiler(Action:TCompilerActions;FileName:STRING):BOOLEAN;
FUNCTION  CheckDependencies(FileName:STRING;VAR cancel:BOOLEAN):BOOLEAN;
FUNCTION  GetFullSourceName(compfile,unitfile:STRING):STRING;
FUNCTION  AutoSaveEnvironment:BOOLEAN;

CONST ErrorTable:^CHAR=NIL;  //Compiler errors

TYPE TCompilerThread=CLASS(TThread)
        PROCEDURE Execute;OVERRIDE;
        DESTRUCTOR Destroy;OVERRIDE;
     END;


VAR ComponentSPUDir:STRING;
    CompilerThread:TCompilerThread;

    CurCompiler : tcCompiler;

    Params:TPasParams;
    Return:TPasReturn;


PROCEDURE DeleteLanguageSCU(VAR Info:POINTER;VAR InfoLen:LONGINT;Name:STRING);

IMPLEMENTATION

{ ------------------------------------------------------------------------------------------ }

TYPE PThreadParams=^TThreadParams;
     TThreadParams=RECORD
                     pParams:PPasParams;
                     pReturn:PPasReturn;
     END;


{$IFDEF OS2}
IMPORTS
  PROCEDURE InvokeSPCTmp(VAR Params:TPasParams;VAR Return:TPasReturn);
       APIENTRY; 'SPDLL25' index 1;
END;
{$ENDIF}

{ ------------------------------------------------------------------------------------------ }

PROCEDURE DeleteLanguageSCU(VAR Info:POINTER;VAR InfoLen:LONGINT;Name:STRING);
VAR p,p1,NameTable,ResourceTable:^LONGWORD;
    dummy:PSCUFileFormat;
    Save:^Byte;
    s:STRING;
    t,t1:longint;
    Flags:BYTE;
    ps,psLang:^STRING;
    Len:LONGWORD;
    NewInfo:POINTER;
    Count,NewLen:LONGWORD;
    App:STRING;
    Msg,Lang:POINTER;
    Size:^LONGWORD;
    Diff:LONGINT;
LABEL again;
BEGIN
     UpcaseStr(Name);
again:
     dummy:=Info;
     WHILE dummy<>NIL DO
     BEGIN
          NameTable:=POINTER(dummy);
          inc(NameTable,dummy^.NameTableOffset);
          ResourceTable:=POINTER(dummy);
          inc(ResourceTable,dummy^.ResourceOffset);

          p:=POINTER(dummy);
          inc(p,dummy^.ObjectOffset);

          p1:=POINTER(dummy);
          inc(p1,sizeof(TSCUFileFormat));
          FOR t:=1 TO dummy^.ObjectCount DO
          BEGIN
               Save:=p1;
               Flags:=p1^ AND 255;       //1- auto create, 2- language info avail
               inc(p1);                  //skip Flag
               inc(p1,(p1^ AND 255)+1);  //skip Form Name
               inc(p1,(p1^ AND 255)+1);  //skip Form Unit Name
               inc(p1,(p1^ AND 255)+1);  //skip Form TypeName

               //If Message Information is available for this form (only for first) remember and skip it !
               IF (Flags AND 8)<>0 THEN
               BEGIN
                    Msg:=POINTER(p1);
                    p:=POINTER(p1);
                    Size:=POINTER(p);
                    inc(p,4); //skip size
                    ps:=POINTER(p); //AppLanguage
                    App:=ps^;
                    inc(p,length(ps^)+1);

                    ps:=POINTER(p);
                    Count:=0;
                    WHILE length(ps^)<>0 DO
                    BEGIN
                         s:=ps^;
                         UpcaseStr(s);
                         IF s=Name THEN //found !
                         BEGIN
                              //erase this section !
                              p:=POINTER(ps);
                              inc(p,length(ps^)+1);
                              Len:=p^;
                              inc(p,4);
                              inc(p,Len);

                              IF (((p^ AND 255)=0)AND(Count=0)) THEN //This is the only entry
                              BEGIN
                                   inc(p); //skip 0
                                   Save^:=Save^ AND not 8; //no message Info
                                   Diff:=1+Len+4+length(ps^)+1+length(App)+1+4;
                                   dec(dummy^.NameTableOffset,Diff);
                                   dec(dummy^.ResourceOffset,Diff);
                                   dec(dummy^.ObjectOffset,Diff);
                                   NewLen:=InfoLen-Diff;
                                   GetMem(NewInfo,NewLen);
                                   p1:=POINTER(NewInfo);
                                   System.Move(Info^,p1^,longword(Msg)-longword(Info));
                                   inc(p1,longword(Msg)-longword(Info));
                                   System.Move(p^,p1^,NewLen-(longword(Msg)-longword(Info)));
                              END
                              ELSE
                              BEGIN
                                   Diff:=Len+4+length(ps^)+1;
                                   dec(dummy^.NameTableOffset,Diff);
                                   dec(dummy^.ResourceOffset,Diff);
                                   dec(dummy^.ObjectOffset,Diff);
                                   NewLen:=InfoLen-Diff;
                                   Size^:=Size^-Diff;
                                   GetMem(NewInfo,NewLen);
                                   p1:=POINTER(NewInfo);
                                   System.Move(Info^,p1^,longword(ps)-longword(Info));
                                   inc(p1,longword(ps)-longword(Info));
                                   System.Move(p^,p1^,NewLen-(longword(ps)-longword(Info)));
                              END;

                              FreeMem(Info,InfoLen);
                              Info:=NewInfo;
                              InfoLen:=NewLen;
                              goto again; //process again !
                         END;

                         p:=POINTER(ps);
                         inc(p,length(ps^)+1);
                         Len:=p^;
                         inc(p,4);
                         inc(p,Len);
                         ps:=POINTER(p);
                         inc(Count);
                    END;

                    inc(p1,p1^);  //skip section
               END;

               //If Language Information is available for this form, remember and skip
               IF Flags AND 2<>0 THEN
               BEGIN
                    Lang:=POINTER(p1);
                    p:=POINTER(p1);
                    Size:=POINTER(p);
                    inc(p,4); //skip size
                    ps:=POINTER(p); //Current language
                    App:=ps^;
                    inc(p,length(ps^)+1);

                    ps:=POINTER(p);
                    Count:=0;
                    WHILE length(ps^)<>0 DO
                    BEGIN
                         psLang:=ps;
                         inc(ps);  //skip 1
                         s:=ps^;
                         UpcaseStr(s);
                         IF s=Name THEN //found !
                         BEGIN
                              //erase this section
                              p:=POINTER(ps);
                              inc(p,length(ps^)+1);

                              Diff:=1+length(ps^)+1;
                              FOR t1:=1 TO 3 DO
                              BEGIN
                                   WHILE (p^ AND 255)<>0 DO
                                   BEGIN
                                        inc(p); //skip 1
                                        ps:=POINTER(p);
                                        Diff:=Diff+1+length(ps^)+1;
                                        inc(p,length(ps^)+1);
                                        inc(p); //skip valuetyp
                                        inc(Diff);
                                        Diff:=Diff+4+p^; //ValueLen
                                        inc(p,4+p^);
                                        inc(p,16);  //skip position and dimensions
                                        inc(Diff,16);
                                   END;
                                   inc(p);  //skip 0
                                   inc(Diff);
                              END;

                              dec(dummy^.NameTableOffset,Diff);
                              dec(dummy^.ResourceOffset,Diff);
                              dec(dummy^.ObjectOffset,Diff);
                              NewLen:=InfoLen-Diff;
                              Size^:=Size^-Diff;
                              GetMem(NewInfo,NewLen);
                              p1:=POINTER(NewInfo);
                              System.Move(Info^,p1^,longword(psLang)-longword(Info));
                              inc(p1,longword(psLang)-longword(Info));
                              System.Move(p^,p1^,NewLen-(longword(psLang)-longword(Info)));

                              FreeMem(Info,InfoLen);
                              Info:=NewInfo;
                              InfoLen:=NewLen;
                              goto again; //process again !
                         END;

                         p:=POINTER(ps);
                         inc(p,length(ps^)+1);
                         Diff:=1+length(ps^)+1;
                         FOR t1:=1 TO 3 DO
                         BEGIN
                              WHILE (p^ AND 255)<>0 DO
                              BEGIN
                                   inc(p); //skip 1
                                   ps:=POINTER(p);
                                   Diff:=Diff+1+length(ps^)+1;
                                   inc(p,length(ps^)+1);
                                   inc(p); //skip valuetyp
                                   inc(Diff);
                                   Diff:=Diff+4+p^; //ValueLen
                                   inc(p,4+p^);
                                   inc(p,16);  //skip position and dimensions
                                   inc(Diff,16);
                              END;
                              inc(p);  //skip 0
                              inc(Diff);
                         END;
                         ps:=POINTER(p);

                         (*
                         IF Count=0 THEN IF length(ps^)=0 THEN IF s='DEFAULT' THEN
                         BEGIN
                              //erase also default if it is the last language...
                              Save^:=Save^ AND not 2; //no language Info
                              inc(p);
                              inc(Diff,4+length(App)+1+1);

                              dec(dummy^.NameTableOffset,Diff);
                              dec(dummy^.ResourceOffset,Diff);
                              dec(dummy^.ObjectOffset,Diff);
                              NewLen:=InfoLen-Diff;
                              GetMem(NewInfo,NewLen);
                              p1:=POINTER(NewInfo);
                              System.Move(Info^,p1^,longword(Lang)-longword(Info));
                              inc(p1,longword(Lang)-longword(Info));
                              System.Move(p^,p1^,NewLen-(longword(Lang)-longword(Info)));

                              FreeMem(Info,InfoLen);
                              Info:=NewInfo;
                              InfoLen:=NewLen;
                              goto again; //process again !
                         END;
                         *)

                         inc(Count);
                    END;

                    inc(p1,p1^);  //skip language info
               END;
          END;

          dummy:=dummy^.NextEntry;
     END;
END;

PROCEDURE EraseUnusedLanguages(VAR p:POINTER;VAR Len:LONGWORD);
VAR s,s1:STRING;
BEGIN
     s:=Project.Settings.InActiveLanguages;
     WHILE s<>'' DO
     BEGIN
          IF pos(';',s)<>0 THEN
          BEGIN
               s1:=Copy(s,1,pos(';',s)-1);
               Delete(s,1,pos(';',s));
          END
          ELSE
          BEGIN
               s1:=s;
               s:='';
          END;

          DeleteLanguageSCU(p,LONGINT(Len),s1);
     END;
END;


TYPE
    TTestTimesReturn=(ttrSourceNotFound,ttrTargetNotFound,
                      ttrTimesEqual,ttrSourceNewer,ttrTargetNewer);

CONST
    RetFilesLen = 256;
    RetFileType:ARRAY[0..3] OF STRING[4] = ('',EXT_UC_WDSibyl_Project,EXT_UC_DLL,EXT_UC_EXE);

PROCEDURE WriteMessage(CONST msg:STRING);
BEGIN
     SetMainStatusText(msg, clBlue,clLtGray);
     CodeEditor.AddMessage(msg);
END;

FUNCTION GetInMemoryEditors:PMemoryList;
VAR  t:LONGINT;
     p:POINTER;
     Len:LONGINT;
     dummy:PMemoryList;
     Edit:TSibEditor;
     SCUMemory:TMemoryStream;
BEGIN
     Result := NIL;
     FOR t := CodeEditorRef.MDIChildCount-1 DOWNTO 0 DO
     BEGIN
          Edit := TSibEditor(CodeEditorRef.MDIChildren[t]);
          IF Edit IS TSibEditor THEN
          BEGIN
               IF Edit.GetText(p,Len,FALSE) THEN
               BEGIN
                    dummy := Result;
                    New(Result);
                    Result^.Name := Edit.FileName;
                    Result^.Adresse := p;
                    Result^.Len := Len;
                    Result^.Modified := Edit.Modified AND Edit.SPUInvalid;
                    Result^.Next := dummy;
               END;
          END;
     END;

     {SCU Information}
     IF Project.Forms.Count > 0 THEN
     BEGIN
          IF GetProjectSCUStream(SCUMemory) THEN
            IF SCUMemory <> NIL THEN
            BEGIN
                 dummy := Result;
                 New(Result);
                 Result^.Name := GetSCUName;
                 Result^.Len := SCUMemory.Size;
                 GetMem(Result^.Adresse, Result^.Len);
                 Result^.Modified := Project.SCUModified;
                 Result^.Next := dummy;
                 {kopieren}
                 SCUMemory.Position := 0;
                 SCUMemory.Read(Result^.Adresse^, Result^.Len);
                 {SCUMemory nicht zerst”ren, da im er Projekt gespeichert wird}

                 EraseUnusedLanguages(Result^.Adresse,Result^.Len);
            END;
     END;
END;


PROCEDURE FreeInMemoryEditors(InMemory:PMemoryList);
VAR  next:PMemoryList;
     p:POINTER;
BEGIN
     WHILE InMemory <> NIL DO
     BEGIN
          next := InMemory^.Next;
          p := InMemory^.Adresse;
          FreeMem(p,InMemory^.Len);
          Dispose(InMemory);
          InMemory := next;
     END;
END;


FUNCTION FileInCodeEditor(unitfile:STRING):STRING;
VAR  i:LONGINT;
     d,n,e:STRING;
     Edit:TSibEditor;
BEGIN
     UpcaseStr(unitfile);

     FOR i := 0 TO CodeEditor.MDIChildCount-1 DO
     BEGIN
          Edit := TSibEditor(CodeEditor.MDIChildren[i]);
          IF Edit IS TSibEditor THEN
          BEGIN
               FSplit(Edit.FileName, d,n,e);
               IF Upcased(n+e) = unitfile THEN
               BEGIN
                    Result := Edit.FileName;
                    exit;
               END;
          END;
     END;

     Result := '';
END;


FUNCTION GetFullSourceName(compfile,unitfile:STRING):STRING;
VAR  d,n,e:STRING;
BEGIN
     Result := '';
     {Maskiere Dateien aus ?...}

     FSplit(unitfile,d,n,e);   {unitfile nur Name und evtl Extension}
     UpcaseStr(e);
     IF e = '' THEN
     BEGIN
          unitfile := unitfile + EXT_UC_PASCAL;

          {Suche im IncSrc Verzeichnis}
          d := ProjectIncSrcDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im LibSrc Verzeichnis}
          d := ProjectLibSrcDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im Verzeichnis des compilierten Files}
          FSplit(compfile,d,n,e);
          Result := d + unitfile;
          IF FileExists(Result) THEN exit;

          {Suche im aktuellen Verzeichnis}
          Result := FExpand(unitfile);
          IF FileExists(Result) THEN exit;

          {Suche im Editor}
          Result := FileInCodeEditor(unitfile);
          IF FileExists(Result) THEN exit;
     END;

     IF e = EXT_UC_WDSibyl_Res  THEN
     BEGIN
          unitfile := n + EXT_UC_RC;

          {Suche im IncSrc Verzeichnis}
          d := ProjectIncSrcDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im Verzeichnis des compilierten Files}
          FSplit(compfile,d,n,e);
          Result := d + unitfile;
          IF FileExists(Result) THEN exit;

          {Suche im aktuellen Verzeichnis}
          Result := FExpand(unitfile);
          IF FileExists(Result) THEN exit;

          {Suche im Editor}
          Result := FileInCodeEditor(unitfile);
          IF FileExists(Result) THEN exit;
     END;

     IF e = EXT_UC_WDSibyl_SCU THEN
     BEGIN
          FSplit(GetSCUName,d,n,e);
          Result := FExpand(d + unitfile);
          IF FileExists(Result) THEN exit;

          Result := FExpand(GetOutDir(compfile) + '\' + unitfile);
          IF FileExists(Result) THEN exit;

          {Suche im Lib Verzeichnis}
          d := ProjectLibDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im aktuellen Verzeichnis}
          Result := FExpand(unitfile);
          IF FileExists(Result) THEN exit;
     END;

     Result := '';
END;


PROCEDURE TCompilerThread.Execute;
VAR  ThrParams:PThreadParams;
     dir,name,ext:STRING;

BEGIN
  Application.LogWriteln('TCompilerThread.Execute: Start');
  ThrParams := Parameter;
  FSplit(ThrParams^.pParams^.Quell,dir,name,ext);
  UpcaseStr(ext);
  Application.LogWriteln('TCompilerThread.Execute: Compiliere:'+dir+';'+name+';'+ext);
  TRY
    Case Project.Settings.Platform of
      pf_OS2  : SetCompilerStatusMessage(LoadNLSStr(SiCompilerStartOS2),'',errNone,0,0);
      pf_WIN32: SetCompilerStatusMessage(LoadNLSStr(SiCompilerStartWin32),'',errNone,0,0);
    End;
    Application.LogWriteln('TCompilerThread.Execute: vor Invoke');
    CurCompiler.InvokeCompiler(ThrParams^.pParams^,ThrParams^.pReturn^);
    Application.LogWriteln('TCompilerThread.Execute: nach Invoke');

// Umschalten zwischen Windows und OS/2
// Dieser Befehl haelt die SPDDLL25.DLL im Speicher
//    if 1=2 then InvokeSPCTmp(ThrParams^.pParams^,ThrParams^.pReturn^);

  EXCEPT
    Application.LogWriteln('TCompilerThread.Execute: except');
    ThrParams^.pReturn^.Error := TRUE;
    SetCompilerStatusMessage(LoadNLSStr(SiInternalCompError),'',errNone,0,0);
    SendMsg(CodeEditor.Handle,cmOpenMsgWindow,-1,0); {Focus Last}
  END;
  SetCompilerStatusMessage(LoadNLSStr(SiCompilerEnd),'',errNone,0,0);
  Application.LogWriteln('TCompilerThread.Execute: Ende');
END;


DESTRUCTOR TCompilerThread.Destroy;
BEGIN
  Application.LogWriteln('TCompilerThread.Execute: Destroy');
  Inherited Destroy;
  CompilerThread:=NIL;
END;



PROCEDURE CallInvokeCompiler(Quell_Ext : String; VAR Params:TPasParams;VAR Return:TPasReturn);

VAR Param:TThreadParams;
    Edit:TEditor;

BEGIN
  Application.LogWriteln('CallInvokeCompiler: Start');

  IF (Quell_Ext = EXT_UC_PASCAL) OR (Quell_Ext = EXT_UC_WDSibyl_SCL) OR
     (Quell_Ext = EXT_UC_RC) or  (Quell_Ext = EXT_UC_WDSibyl_Help)  THEN
    BEGIN
      {force to save .RC, because InMemory is not handled}
      IF (Quell_Ext = EXT_UC_RC) or (Quell_Ext=EXT_UC_WDSibyl_Help) THEN
        BEGIN
           Edit := GetEditor(Params.Quell);
           IF Edit <> NIL THEN
             IF Edit.Modified THEN Edit.SaveFile;
        END;

      CodeEditor.CompilerTerminate := FALSE;

{ WD: Compilieren der Dateien; Eigener Thread }
      Param.pParams := @Params;
      Param.pReturn := @Return;
      Application.LogWriteln('CallInvokeCompiler: ExtCreate: '+toStr(LongInt(IdeSettings.CompilerPriority)));
      CompilerThread.ExtCreate(TRUE,256*1024, IdeSettings.CompilerPriority,@Param);
      CompilerThread.OnTerminate:=CodeEditor.EvCompileThreadEnded;
      CompilerThread.Resume;

      REPEAT
        Application.HandleMessage;
      UNTIL CodeEditor.CompilerTerminate;   {TRUE, wenn Thread beendet oder unterbrochen}

      {TCodeEditor.EvCompileThreadEnded terminates the Loop}
    END;

  Application.LogWriteln('CallInvokeCompiler: Ende');
END;


PROCEDURE StopCompiler;

var pt: Pointer;

BEGIN
  IF not CompilerActive THEN exit;
  SetCompilerStatusMessage('Send-StopCompiler ('+tohex(longWord(CurCompiler.Func.BreakCompiler)),'',errNone,0,0);
  CurCompiler.BreakCompiler;
END;

Type
  TCursorOrIcon=Record
                    Reserved: Word;
                    wType: Word;
                    Count: Word;
  End;


PROCEDURE SetupApplicationIcon(VAR Params:TPasParams);
VAR ApplicationOpt:^TApplicationOptions;
    Platform:TPlatform;
    ss :String;
    f:file;
    SaveMode:LongWord;
    pw:^Word;
    pl:^LongInt;
    pb:^Byte;
    Ofs,Len,Len1,Len2,Ofs1,Ofs2,ResLen,ResOffset,ResDataOffset,NextDir:LongWord;
    t:LongInt;
    h,m,s,s100:word;
    dt:DateTime;
    Temp:LongInt;
    IR:TCursorOrIcon;
Label err,err1,err2;
BEGIN
  Application.LogWriteln('SetupApplication');
  Platform:=Project.Settings.Platform;

  If Platform=pf_OS2
    Then ApplicationOpt:=@Project.Settings.ApplicationOptOS2
    Else ApplicationOpt:=@Project.Settings.ApplicationOptWin;

   Application.LogWriteln('Path:'+Application.ProgramPath);

   ss:=ApplicationOpt^.ApplicationIcon;
   If ss='' Then
     Begin
       case Platform of
         pf_OS2:   ss:=Application.ProgramPath+'default_os2.ico';
         pf_Win32: ss:=Application.ProgramPath+'default_win32.ico';
       end;
     End;
   Application.LogWriteln('Icon:' + ss);

   SaveMode:=FileMode;
   filemode:=fminput;
   Assign(f,ss);
   {$i-}
   Reset(f);
   {$i+}
   FileMode:=SaveMode;
   Application.LogWriteln('IOResult:'+tostr(IOResult));
   If IoResult<>0 Then
     Begin

err:
       SetCompilerStatusMessage(LoadNLSStr(SiInvalidAppIcon)+ss,'',errNone,0,0);
       SetCompilerStatusMessage(LoadNLSStr(SiIgnoringAppIcon),'',errNone,0,0);
       exit;
     End;

   {$I-}
   Len:=FileSize(f);
   {$I+}
   If IoResult<>0 Then
     Begin
err1:
       {$I-}
       Close(f);
       {$I+}
       goto err;
     End;

   If Platform=pf_OS2 Then //OS2 SRF Format
     Begin
       Params.ApplicationIconLen:=Len+2+14;
       GetMem(Params.ApplicationIcon,Params.ApplicationIconLen);

       //Write resource Dir
       pw:=Pointer(Params.ApplicationIcon);
       pw^:=Len;
       inc(pw,2);
       pw^:=1;             {Typ:Icon}
       inc(pw,2);
       pw^:=1;             {Bezeichner der Bitmap}
       inc(pw,2);
       pw^:=Len MOD 65536; {Lnge der Eintrge fr diese Bitmap}
       inc(pw,2);
       pw^:=Len DIV 65536;
       inc(pw,2);
       pw^:=3;             {Object number}
       inc(pw,2);
       pw^:=0;             //Offset low
       inc(pw,2);
       pw^:=0;             //Offset high
       inc(pw,2);

       //Write resource data
       {$I-}
       BlockRead(f,pw^,Len);
       {$I-}
       If IOResult<>0 Then
         Begin
err2:
           FreeMem(Params.ApplicationIcon,Params.ApplicationIconLen);
           Params.ApplicationIcon:=Nil;
           Params.ApplicationIconLen:=0;
           goto err1;
         End;
     End
   Else
     Begin //Win SRW Format
       GetTime(h,m,s,s100);
       dt.hour:=h;
       dt.min:=m;
       dt.sec:=s;
       GetDate(h,m,s,s100);
       dt.year:=h;
       dt.month:=m;
       dt.day:=s;
       packtime(dt,Temp);

       //determine type of ICON and Length of information as well as offsets to data
       {$I-}
       BlockRead(f,IR,sizeof(TCursorOrIcon));
       {$I+}
       if ioresult<>0 then goto err1;
       {$I-}
       Seek(f,0);
       {$I+}
       if ioresult<>0 then goto err1;

       If ((IR.Reserved=0)And(IR.wType In [0,1,2]))
         Then //Win Icon
           Begin
             Len1:=Len-22; //ohne Header
             Ofs1:=22;     //ohne Header
             Len2:=Len;
             Ofs2:=0;
           End
         Else goto err1;

       ResLen:=Len1; //ICON
       IF ResLen AND 3<>0 THEN
         BEGIN
           FOR t:=1 TO 4-(ResLen AND 3) DO inc(ResLen);
         END;
       ResLen:=ResLen+Len2; //GROUPICON
       IF ResLen AND 3<>0 THEN
         BEGIN
           FOR t:=1 TO 4-(ResLen AND 3) DO inc(ResLen);
         END;

       Params.ApplicationIconLen:=ResLen+2+16+(2*8)+(2*64);
       GetMem(Params.ApplicationIcon,Params.ApplicationIconLen);

       ResOffset:=16;
       ResDataOffset:=ResOffset+2*48;  {fr Directories}
       inc(ResDataOffset,2*24);

       NextDir:=(2*8)+ResOffset;

       //16
       pw:=Params.ApplicationIcon;
       pw^:=ResLen;
       inc(pw,2);
       pl:=Pointer(pw);
       pl^:=0;      {Resource flags}
       inc(pl,4);
       pl^:=Temp;   {Time stamp}
       inc(pl,4);
       pl^:=0;      {Major/minor version}
       inc(pl,4);
       pw:=Pointer(pl);
       pw^:=0;      {Number of name entries}
       inc(pw,2);
       pw^:=2;      {Number of index entries}
       inc(pw,2);
       pl:=Pointer(pw);

       //2*8
       pl^:=3;  {RT_ICON}
       inc(pl,4);
       pl^:=$80000000 OR (NextDir);  {Offset to resources}
       inc(pl,4);
       inc(ResOffset,8);
       inc(NextDir,16+48);
       pl^:=14; {RT_GROUP_ICON}
       inc(pl,4);
       pl^:=$80000000 OR (NextDir);  {Offset to resources}
       inc(pl,4);
       inc(ResOffset,8);
       inc(NextDir,16+48);

       //2*64 //ICON
       pl^:=0;      {Resource flags}
       inc(pl,4);
       pl^:=Temp;   {Time stamp}
       inc(pl,4);
       pl^:=0;      {Major/Minor version}
       inc(pl,4);
       pw:=Pointer(pl);
       pw^:=0;      {Number of name entries}
       inc(pw,2);
       pw^:=1;      {Number of id entries}
       inc(pw,2);
       pl:=Pointer(pw);
       inc(ResOffset,16);
       Ofs:=ResOffset+(1*8);
       pl^:=1;  {id}
       inc(pl,4);
       pl^:=$80000000 OR Ofs;  {Offset to resources}
       inc(pl,4);
       inc(ResOffset,8);
       pl^:=0;      {Resource flags}
       inc(pl,4);
       pl^:=Temp;   {Time stamp}
       inc(pl,4);
       pl^:=0;      {Major/Minor version}
       inc(pl,4);
       pw:=Pointer(pl);
       pw^:=0;      {Number of name entries}
       inc(pw,2);
       pw^:=1;      {Number of id entries}
       inc(pw,2);
       pl:=Pointer(pw);
       pl^:=0;      {id}
       inc(pl,4);
       pl^:=ResOffset+24;
       inc(pl,4);
       pl^:=ResDataOffset; {Data rva 70058}
       inc(pl,4);
       inc(ResDataOffset,Len1); //ICON Len
       pl^:=Len1;          {Data len}
       inc(pl,4);
       pl^:=0;             {CodePage}
       inc(pl,4);
       pl^:=0;             {reserved}
       inc(pl,4);
       inc(ResOffset,40);
       IF ResDataOffset AND 3<>0 THEN
         FOR t:=1 TO 4-(ResdataOffset AND 3) DO inc(ResDataOffset);
//GROUPICON
       pl^:=0;      {Resource flags}
       inc(pl,4);
       pl^:=Temp;   {Time stamp}
       inc(pl,4);
       pl^:=0;      {Major/Minor version}
       inc(pl,4);
       pw:=Pointer(pl);
       pw^:=0;      {Number of name entries}
       inc(pw,2);
       pw^:=1;      {Number of id entries}
       inc(pw,2);
       pl:=Pointer(pw);
       inc(ResOffset,16);
       Ofs:=ResOffset+(1*8);
       pl^:=1;  {id}
       inc(pl,4);
       pl^:=$80000000 OR Ofs;  {Offset to resources}
       inc(pl,4);
       inc(ResOffset,8);
       pl^:=0;      {Resource flags}
       inc(pl,4);
       pl^:=Temp;   {Time stamp}
       inc(pl,4);
       pl^:=0;      {Major/Minor version}
       inc(pl,4);
       pw:=Pointer(pl);
       pw^:=0;      {Number of name entries}
       inc(pw,2);
       pw^:=1;      {Number of id entries}
       inc(pw,2);
       pl:=Pointer(pw);
       pl^:=0;      {id}
       inc(pl,4);
       pl^:=ResOffset+24;
       inc(pl,4);
       pl^:=ResDataOffset; {Data rva 70058}
       inc(pl,4);
       inc(ResDataOffset,Len2); //GROUPICON Len
       pl^:=Len2;          {Data len}
       inc(pl,4);
       pl^:=0;             {CodePage}
       inc(pl,4);
       pl^:=0;             {reserved}
       inc(pl,4);
       inc(ResOffset,40);
       IF ResDataOffset AND 3<>0 THEN
         FOR t:=1 TO 4-(ResdataOffset AND 3) DO inc(ResDataOffset);

       //ResourceData ICON
       {$I-}
       Seek(f,Ofs1);
       {$I+}
       If IOResult<>0 Then goto err2;
       {$I-}
       BlockRead(f,pl^,Len1);
       {$I+}
       If IOResult<>0 Then goto err2;
       inc(pl,Len1);
       pb:=Pointer(pl);
       IF Len1 AND 3<>0 THEN
         BEGIN
           FOR t:=1 TO 4-(Len1 AND 3) DO
             BEGIN
               pb^:=0;
               inc(pb);
             END;
         END;
       pl:=Pointer(pb);

       //ResourceData GROUPICON
       {$I-}
       Seek(f,Ofs2);
       {$I+}
       If IOResult<>0 Then goto err2;
       {$I-}
       BlockRead(f,pl^,Len2);
       {$I+}
       If IOResult<>0 Then goto err2;
       pb:=Pointer(pl);
       inc(pb,Len2);
       inc(pl,18);
       pl^:=1; //Group Id
       IF Len1 AND 3<>0 THEN
         BEGIN
           FOR t:=1 TO 4-(Len1 AND 3) DO
             BEGIN
               pb^:=0;
               inc(pb);
             END;
         END;
    End;

  {$I-}
  Close(f);
  {$I+}
END;

Procedure StartHelpFile;

var Param,cmd : String;
    StrExt    : String;

Begin
  SetCompilerStatusMessage('Start: '+ IdeSettings.HelpCompilerFileName,'',errNone,0,0);
  if FileExists(IdeSettings.HelpCompilerFileName)
    then
      Begin
        StrExt:=Uppercase(extractFileExt(IdeSettings.HelpCompilerFileName));
        if StrExt=EXT_UC_CMD
          then
            Begin
              cmd:=goSysInfo.OS.OSCmd;
              param:='/c '+IdeSettings.HelpCompilerFileName+' '+
                           Params.Quell + ' ' +
                           Params.Out + ' ' +
                           IdeSettings.HelpCompilerLanguage;
            End
        else if StrExt=EXT_UC_EXE
          then
            Begin
              cmd:=IdeSettings.HelpCompilerFileName;
              param:=Params.Quell + ' ' +
                     Params.Out + ' ' +
                     IdeSettings.HelpCompilerLanguage;
            end
        else exit;   // sollte nicht vorkommen, aber sicher ist sicher
        Exec2(cmd,param);
      End
    else SetCompilerStatusMessage('  --> '+LoadNLSStr(SiERR_FILE_NOT_FOUND),'',errNone,0,0);
End;


FUNCTION RunCompiler(Action:TCompilerActions;FileName:STRING):BOOLEAN;

VAR Edit           : TSibEditor;
    s,dir,name,ext : STRING;
    Quell_Ext      : String;
    CStrHlpLanguage: cString;
    i              : INTEGER;
    RetDataSize    : LONGINT;
    ppf            : PProjectFile;
    updateBrowser  : BOOLEAN;
    Directories    :^TDirectories;
    OutDir         : tStringList;
    OutCnt         : LongInt;
    SourceFilename : tFilename;
    DestFilename   : tFilename;
    RetFileName    : tFilename;   // Filename als EXE oder DLL (ohne Pfad-Angabe);

LABEL lend;
BEGIN
  Application.LogWriteln('RunCompiler: Start');
  Result := FALSE;

  Case Project.Settings.Platform Of
    pf_OS2:   Directories:=@Project.Settings.DirectoriesOS2;
    pf_Win32: Directories:=@Project.Settings.DirectoriesWin;
  End; //case

  IF FileName = '' THEN exit;

  IF CompilerActive THEN
    BEGIN
      ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
      exit;
    END;
  CompilerActive := TRUE;

  ControlCentre.EnableDocking := []; {prevent Docking Operations}

  FOR i := 0 TO CodeEditorRef.MDIChildCount-1 DO
    BEGIN
      Edit := TSibEditor(CodeEditorRef.MDIChildren[i]);
      IF Edit IS TSibEditor THEN Edit.ResetErrorLine;
    END;

  IF FileName = '' THEN goto lend;

  IF IdeSettings.OpenMsgView THEN
    BEGIN
      CodeEditor.ShowControlCentre(BuildIndex,NoFokus);
      IF ControlCentre <> NIL THEN
        IF ControlCentre.Form <> NIL THEN ControlCentre.Form.BringToFront;
    END;

  {Suche nur in den MainFiles}
  ppf := DataProjectMain(FileName);

  IF ppf <> NIL THEN ppf^.CheckSum := 0;  {neue Checksumme}

  OutDir.Create;
  OutDir.AddSplit(ProjectOutDir(Project.Settings),';');
  FillChar(Params,sizeof(Params),0);
  Params.Out := OutDir.Strings[0];
  Params.Quell := FileName;
  FSplit(Params.Quell,dir,name,Quell_Ext);
  UpcaseStr(Quell_Ext);

  if (Quell_Ext = EXT_UC_PASCAL) OR (Quell_Ext = EXT_UC_WDSibyl_SCL)
    then
      Begin
        CurCompiler := CompilerSPC;        // Pascal - Compiler aufrufen
        CASE Action OF
          Action_Compile: Params.Params := '';
          Action_Make:    Params.Params := '-M';
          Action_Build:   Params.Params := '-B';
          Action_CompLib: Params.Params := '-M-T1';
        END;

        IF Action = Action_CompLib THEN
          BEGIN
             FSplit(GetCompLibName,dir,name,ext);          { Aus der Complib.dll den Pfad herausfinden }
             NormalizeDir(dir);
             Params.Out      := dir;
             Params.ExeOut   := dir;
             Params.Lib      := ProjectOutDir(Project.Settings) +';'+
                                ProjectLibDir(Project.Settings) +';'+
                                ProjectCompInstallDir(Project.Settings) +';'+
                                ComponentSPUDir;
             Params.IncSrcDir:= ProjectIncSrcDir(Project.Settings) +';'+
                                ComponentSPUDir;
             Params.Defines  := '';
          END
        ELSE
          BEGIN
             Params.ExeOut   := '';
             Params.Lib      := ProjectLibDir(Project.Settings) +';'+
                                ProjectCompInstallDir(Project.Settings);
             Params.IncSrcDir:= ProjectIncSrcDir(Project.Settings);
             Params.Params   := Params.Params + GetCompilerOptions(Project.Settings);
             Params.Defines  := GetCompilerDefines(Project.Settings);
          END;
      End

    else if (Quell_Ext = EXT_UC_RC) OR (Quell_Ext = EXT_UC_WDSibyl_Help) then
      Begin
        case Project.Settings.Platform of
          pf_OS2:   Params.Params := '-OS2';
          pf_Win32: Params.Params := '-W32';
        end;

        if Quell_Ext = EXT_UC_WDSibyl_Help
          then
            begin
              CurCompiler := CompilerHlp;  // Help - Compiler aufrufen
//              Temp_cStr:=' "'+IdeSettings.HelpCompilerFileName+'"';
              CStrHlpLanguage := ' -L='  + IdeSettings.HelpCompilerLanguage;
              Params.Params:= Params.Params + CStrHlpLanguage;
                    // + Temp_CStr;
            end
          else
            begin
              CurCompiler := CompilerRes;  // Resouce - Compiler aufrufen
            end;
      End;

  Params.LibSrc := ProjectLibSrcDir(Project.Settings);
  FSplit(GetSCUName,dir,name,ext);
  NormalizeDir(dir);
  Params.SCUDir := dir;

  LogRunCompiler(Quell_Ext, Params);

  SetupApplicationIcon(Params);
  Params.InMemory := GetInMemoryEditors;
  Params.MsgProc := @SetCompilerStatusMessage;
  Params.Version := 200;  //2.0 Version with GUI output
{ Params.Version := 201;  //SPC20 owner   { Von SPCC.PAS uebernommen }

  {!!!!!!setze Liste der zustzlichen Resourcen!!!!!!}
{ Params.AddResources:=NIL; }
  Params.ErrorTable:=ErrorTable;
  Params.ErrorTable:=NIL;

  FillChar(Return,sizeof(Return),0);
  Return.Error := TRUE; {because of kill thread}


  Application.LogWriteln('RunCompiler: CallInvokeCompiler');
  CallInvokeCompiler(Quell_Ext, Params, Return);
  Application.LogWriteln('RunCompiler: CallInvokeCompiler-Ende:');

  If Params.ApplicationIcon<>Nil Then FreeMem(Params.ApplicationIcon,Params.ApplicationIconLen);
  Application.LogWriteln('RunCompiler: Icon');

  FreeInMemoryEditors(Params.InMemory);
  Application.LogWriteln('RunCompiler: vor VDE');

  IF VDETerminating THEN exit;
  Application.LogWriteln('RunCompiler: nach VDE');

//  CompilerDLL.Destroy;
  Application.LogWriteln('CompilerDll beendet');

  IF Return.Error
    THEN
      BEGIN
        Application.LogWriteln('RunCompiler: Return Error');
        Result := FALSE;
        IF IdeSettings.EnableSound THEN Beep(600,200);

        IF Return.RetFiles <> NIL THEN
          BEGIN
            RetDataSize := (Return.RetFilesCount+1) * RetFilesLen;

            Application.LogWriteln('RunCompiler: RetSize='+tostr(RetDataSize));
            {das Compilat von "FileName" ist ungltig, weil Fehler aufgetreten ist}
            Edit := GetEditor(FileName);
            IF Edit <> NIL THEN Edit.SPUInvalid := TRUE;

            FOR i := 1 TO Return.RetFilesCount DO
              BEGIN
                s := GetFullSourceName(FileName,Return.RetFiles^[i]);
                IF s <> '' THEN
                  BEGIN
                    {merken, das die SPU von "s" gltig ist - wegen Dependency Test}
                    Edit := GetEditor(s);
                    IF Edit <> NIL THEN Edit.SPUInvalid := FALSE;
                  END;
              END;

            Application.LogWriteln('RunCompiler: RetSize='+tostr(RetDataSize));
            FreeAPIMem(Return.RetFiles, RetDataSize);
         END;
      END
    ELSE
      BEGIN
        WDSibylThrd.Suspend;
        Application.LogWriteln('RunCompiler: Okay');
        Result := TRUE;
        IF IdeSettings.EnableSound THEN
          BEGIN
            Beep(800,50);
            Beep(1000,50);
            Beep(1300,50);
          END;

        SetMainStatusText(LoadNLSStr(SiSuccess),clBlack,clLtGray);
        ErrName := '';
        Project.NeedRecompile := FALSE;

        Application.LogWriteln('RunCompiler: Return.RetFiles');
        IF Return.RetFiles <> NIL THEN
          BEGIN
            RetDataSize := (Return.RetFilesCount+1) * RetFilesLen;

            {merken, das die Compilat von "FileName" gltig ist - wegen Dependency Test}
            Edit := GetEditor(FileName);
            IF Edit <> NIL THEN Edit.SPUInvalid := FALSE;

            Application.LogWriteln('RunCompiler: Action:'+tostr(RetDataSize) +
                                   ' RetType: ' + tostr(Return.RetType));
            IF (Action <> Action_CompLib) AND (Return.RetType IN [2,3]) THEN
              BEGIN
                { Kopieren des Ergebnis in die anderen Output-Verzeichnisse }
                SourceFilename:=GetExeName;
                if Return.RetType = 2 then  // also DLL
                  SourceFilename:=Copy(SourceFilename,1,length(SourceFilename)-4) + EXT_UC_DLL;
                RetFileName:=extractfilename(SourceFilename);
                for OutCnt:=1 to OutDir.Count-1 do
                  Begin
                    DestFilename:=OutDir.Strings[OutCnt]+'\'+RetFilename;
                    SetCompilerStatusMessage('Copy: ' +
                          SourceFilename + ' --> ' + DestFilename + '  Ret=' +
                              iif(CopyFile(SourceFilename, DestFilename),'okay','not okay'),
                          '',errNone,0,0);
                  End;

                Project.Modified := TRUE;

                IF ppf <> NIL THEN
                  BEGIN
                    ppf^.CheckSum := RetDataSize;
                    ppf^.ExeExt := RetFileType[Return.RetType];
                  END;

                updateBrowser := Upcased(ProjectPrimary(Project.Settings)) =
                                 Upcased(FileName);
                IF updateBrowser THEN
                  BEGIN
                    Project.BrowserFiles.Clear;
                    (* nicht die Exe hinzufgen
                    FSplit(FileName,dir,name,ext);
                    Project.BrowserFiles.Add(name + RetFileType[Return.RetType]);
                    *)
                  END;
                  {Generiere Used_Files Liste}
                ClearProjectDependencies(FileName);
                Application.LogWriteln('RunCompiler: ReFilesCount');
                FOR i := 1 TO Return.RetFilesCount DO
                  BEGIN
                    s := GetFullSourceName(FileName,Return.RetFiles^[i]);
                    IF s <> '' THEN
                      BEGIN
                        {SubFile "s" in die Dependency Struktur von "FileName" eintragen}
                        AddProjectDependency(FileName,s);
                        {merken, das die SPU von "s" gltig ist - wegen Dependency Test}
                        Edit := GetEditor(s);
                        IF Edit <> NIL THEN Edit.SPUInvalid := FALSE;
                      END;

                     IF updateBrowser THEN {Browser Info generieren}
                       BEGIN
                         name := Upcased(Return.RetFiles^[i]);
                         IF pos(EXT_UC_WDSibyl_SCU ,name) > 0 THEN continue;
                         IF pos(EXT_UC_WDSibyl_Res,name) > 0 THEN continue;
                         name := Return.RetFiles^[i] {+ EXT_Sibyl_Projekt}; {no Ext.}
                         Project.BrowserFiles.Add(name); {SPU}
                       END;
                  END;
                Application.LogWriteln('RunCompiler: Refresh');

                {$IFDEF OS2}
                // Refresh the ProjectFilesTree
                IF ProjectFilesTree <> NIL THEN
                  BEGIN
                    // force correct node positions
                    WinSendMsg(ProjectFilesTree.Handle,CM_EXPANDTREE,0,0);
                    WinEnableWindowUpdate(ProjectFilesTree.Handle,False);
                    WinSendMsg(ProjectFilesTree.Handle,CM_COLLAPSETREE,0,0);
                    WinEnableWindowUpdate(ProjectFilesTree.Handle,True);
                  END;
                {$ENDIF}

                Application.LogWriteln('RunCompiler: UpdateBrowser');
                IF updateBrowser THEN
                  IF IdeSettings.CodeInsight.CodeParameter OR
                     IdeSettings.CodeInsight.CodeCompletion
                    THEN UpdateBrowserInfoProc(FALSE);
              END;
            Application.LogWriteln('RunCompiler: FreeAPIMem2x:'+tostr(RetDataSize));
            { WD:XXXX              FreeAPIMem(Return.RetFiles, RetDataSize); }
            Application.LogWriteln('RunCompiler: FreeAPIMem:'+tostr(RetDataSize));
          END;

        Application.LogWriteln('RunCompiler: Action2');
        IF Action = Action_CompLib THEN
          BEGIN //fge das neue Verzeichnis hinzu
            s := Upcased(ComponentSPUDir) + ';';
            dir := Directories^.CompInstallDir;
            IF pos(s, Upcased(dir) +';') = 0 THEN
              BEGIN {append it}
                IF dir[Length(dir)] = ';'
                  THEN SetLength(dir, Length(dir)-1);
                IF dir <> '' THEN dir := dir + ';';
                  Directories^.CompInstallDir := dir + ComponentSPUDir;
              END;
          END;

        if (Quell_Ext = EXT_UC_WDSibyl_Help) then
          Begin   // Bei Help-Dateien eventuelle ein eingenes Programm starten
            Application.LogWriteln('RunCompiler: Versuche Prg "'+
                  IdeSettings.HelpCompilerFileName+ '" zu starten.');
            StartHelpfile;
          End;
     END;
  if OutDir<>nil then OutDir.Destroy;
  Application.LogWriteln('RunCompiler: Ende');

lend:
  CompilerActive := FALSE;
  Application.LogWriteln('RunCompiler: Comp Activ:');
  ControlCentre.EnableDocking := [tbBottom]; {enable Docking Operations}

  WDSibylThrd.Resume;
  Application.LogWriteln('RunCompiler: Ende');
END;


FUNCTION TestFileTimes(Source,Target:STRING;VAR Return:TTestTimesReturn):BOOLEAN;
VAR  year1,month1,day1,hour1,minute1,sec1:WORD;
     dow1,sec100:WORD;
     year2,month2,day2,hour2,minute2,sec2:WORD;
     DirInfo:TSearchRec;
     DT:DateTime;
     Edit:TSibEditor;
     status:INTEGER;
LABEL Second;
BEGIN
     Result := FALSE;
     Return := ttrSourceNewer;

     Edit := GetEditor(Source);
     IF Edit <> NIL THEN
       IF Edit.Modified AND Edit.SPUInvalid THEN {Datei-Zeit des Editors wird verwendet}
       BEGIN
            GetDate(year1,month1,day1,dow1);
            GetTime(hour1,minute1,sec1,sec100);
            goto Second;
       END;

     status := FindFirst(Source, AnyFile, DirInfo);
     IF status = 0 THEN
     BEGIN {Source found}
          SysUtils.FindClose(DirInfo);
          UnpackTime(DirInfo.Time,DT);
          year1 := DT.year;
          month1 := DT.month;
          day1 := DT.day;
          hour1 := DT.hour;
          minute1 := DT.min;
          sec1 := DT.sec;
     END
     ELSE
     BEGIN {Source not found}
          Return := ttrSourceNotFound;
          exit;
     END;

Second:
     status := FindFirst(Target, AnyFile, DirInfo);
     IF status = 0 THEN
     BEGIN {Source found}
          SysUtils.FindClose(DirInfo);
          UnpackTime(DirInfo.Time,DT);
          year2 := DT.year;
          month2 := DT.month;
          day2 := DT.day;
          hour2 := DT.hour;
          minute2 := DT.min;
          sec2 := DT.sec;
     END
     ELSE
     BEGIN {Target not found}
          Return := ttrTargetNotFound;
          exit;
     END;

     IF year1 > year2 THEN exit;
     IF year1 = year2 THEN
     BEGIN
          IF month1 > month2 THEN exit;
          IF month1 = month2 THEN
          BEGIN
               IF day1 > day2 THEN exit;
               IF day1 = day2 THEN
               BEGIN
                    IF hour1 > hour2 THEN exit;
                    IF hour1 = hour2 THEN
                    BEGIN
                         IF minute1 > minute2 THEN exit;
                         IF minute1 = minute2 THEN
                         BEGIN
                              IF sec1 > sec2 THEN exit;
                              IF sec1 = sec2 THEN
                              BEGIN
                                   Result := TRUE;
                                   Return := ttrTimesEqual;
                                   exit;
                              END;
                         END;
                    END;
               END;
          END;
     END;

     Result := TRUE;
     Return := ttrTargetNewer;
END;


FUNCTION CompareSourceSpuExeTimes(source,exe:STRING):BOOLEAN;
VAR  Return:TTestTimesReturn;
     d,n,e,spu:STRING;
LABEL testspuexe;
BEGIN
     Result := FALSE;

     FSplit(source,d,n,e);
     {teste Source - SPU zuerst mit dem OutDir}
     spu := FExpand(GetOutDir(source) + '\' + n + EXT_UC_WDSibyl_Project);
     IF TestFileTimes(source,spu,Return) THEN {spu newer or equal than source}
     BEGIN
          {spu gefunden, und neuer als die source}
          goto testspuexe;
     END;
     IF Return = ttrSourceNotFound THEN exit;   {kann eigentlich nicht sein}
     IF Return = ttrSourceNewer THEN exit;      {dependencies FALSE}

     {TargetNotFound: teste source - SPU mit dem LibDir, der Reihe nach}
     d := ProjectLibDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          spu := FExpand(GetNextDir(d) + '\' + n + EXT_UC_WDSibyl_Project);
          IF TestFileTimes(source,spu,Return) THEN
          BEGIN
               {spu gefunden, und neuer als die source}
               goto testspuexe;
          END;
          IF Return = ttrSourceNewer THEN exit;      {dependencies FALSE}
     END;
     {test ob SPU im aktuellen Verzeichnis da ist}
     {$i-}
     GetDir(0,d);
     {$i+}
     NormalizeDir(d);
     spu := d + '\' + n + EXT_UC_WDSibyl_Project;
     IF TestFileTimes(source,spu,Return) THEN {spu newer or equal than source}
     BEGIN
          {spu gefunden, und neuer als die source}
          goto testspuexe;
     END;
     IF Return = ttrSourceNewer THEN exit;      {dependencies FALSE}

     exit; {keine SPU gefunden}

testspuexe:
     Result := TestFileTimes(spu,exe,Return);
END;


CONST //Resultat des Dependency Test anzeigen oder nicht
     DepMsg:BOOLEAN=FALSE;

{Check ohne Compilierung der SPU
 nur SRFs werden neu erstellt wenn ungltig
 liefert TRUE wenn Dependencies Ok ist ansonsten FALSE auch wenn keine Infos da}
FUNCTION CheckDependencies(FileName:STRING;VAR cancel:BOOLEAN):BOOLEAN;
VAR  mpf,ppf,dep:PProjectFile;
     ppfName:STRING;
     exename,s,d,n,e:STRING;
     SPUInvalid:BOOLEAN;
     SRFInvalid:BOOLEAN;
     SCUInvalid:BOOLEAN;
     Return:TTestTimesReturn;
     i:LONGINT;
     depidx:LONGINT;
LABEL nodep;
BEGIN
     Result := FALSE;
     cancel := FALSE;
     IF FileName = '' THEN exit;
     SPUInvalid := FALSE;
     SRFInvalid := FALSE;
     SCUInvalid := FALSE;

     IF not ExistProjectMain(FileName) THEN {nur Zeitvergleich Source - Exe}
     BEGIN
          FSplit(FileName,d,n,e);
          exename := FExpand(GetOutDir(FileName) + '\' + n + EXT_UC_EXE);
          IF not TestFileTimes(FileName,exename,Return) THEN
          BEGIN  {EXE steht immer im 'GetOutDir'}
               IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileIsCorrupt,[exename]));
               exit;
          END;
          Result := TRUE;
          exit;
     END;

     mpf := DataProjectMain(FileName);
     IF mpf = NIL THEN  {keine Informationen ber Dependencies vorhanden}
     BEGIN
nodep:
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiNoDependencyInfo,[FileName]));
          exit;
     END;

     IF mpf^.ASub = NIL THEN goto nodep;

     depidx := mpf^.ASub.FindFile(DependenciesString);
     IF depidx < 0 THEN goto nodep;
     dep := PProjectFile(mpf^.ASub.Objects[depidx]);

     IF dep = NIL THEN goto nodep;

     FSplit(FileName,d,n,e);
     exename := FExpand(GetOutDir(FileName) + '\' + n + mpf^.ExeExt);

     {Teste zuerst alle Ressourcen, da die beim Make nicht bercksichtigt werden}
     {Teste Dependency Ressourcen}
     IF dep^.ASub <> NIL THEN
     FOR i := 0 TO dep^.ASub.Count-1 DO
     BEGIN
          ppfName := dep^.ASub.Strings[i];
          ppf := PProjectFile(dep^.ASub.Objects[i]);

          FSplit(ppfName,d,n,e);
          UpcaseStr(e);
          IF e = EXT_UC_RC THEN
          BEGIN
               s := FExpand(GetOutDir(ppfName) + '\' + n + EXT_UC_WDSibyl_Res);
               {Test ob RC neuer als SRF}
               IF not TestFileTimes(ppfName,s,Return) THEN
               BEGIN
                    {Starte Resource Compiler}
                    IF not RunCompiler(Action_Compile,ppfName) THEN
                    BEGIN {Abbruch bzw. Fehler bricht auch die Rahmenaktion ab !!!}
                         cancel := TRUE;
                         exit;
                    END;
                    SRFInvalid := TRUE;
               END;
               {Test ob SRF neuer als EXE}
               IF not TestFileTimes(s,exename,Return) THEN SRFInvalid := TRUE;
          END;
     END;

     IF SRFInvalid THEN exit;  {immer Compilieren}


     IF Project.NeedRecompile THEN
     BEGIN
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiProjectModified));
          exit;
     END;

     IF Project.SCUModified AND (Project.LastSCUStream = NIL) THEN
     BEGIN {SCU Stream wurde nach dem letzten "GetProjectSCU" Call wieder modifiziert}
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiSCUModified));
          exit;
     END;


     IF mpf^.CheckSum = 0 THEN  {File noch nicht compiliert seit ADD_Prj}
     BEGIN
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileNotYetCompiled,[FileName]));
          exit;
     END;

     IF mpf^.ExeExt = '' THEN  {File noch nicht compiliert seit ADD_Prj}
     BEGIN
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileNotYetCompiled,[FileName]));
          exit;
     END;

     {Teste "FileName"}
     IF not TestFileTimes(FileName,exename,Return) THEN
     BEGIN  {EXE steht immer im 'GetOutDir'}
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileIsCorrupt,[exename]));
          exit;
     END;

     {Teste Dependency Units}
     IF dep^.ASub <> NIL THEN
     FOR i := 0 TO dep^.ASub.Count-1 DO
     BEGIN
          ppfName := dep^.ASub.Strings[i];
          ppf := PProjectFile(dep^.ASub.Objects[i]);

          FSplit(ppfName,d,n,e);
          UpcaseStr(e);
          IF e = EXT_UC_PASCAL THEN
          BEGIN
               {Vergleiche Source mit m”gl. SPUs und der EXE}
               IF not CompareSourceSpuExeTimes(ppfName,exename)
               THEN SPUInvalid := TRUE;
          END;

          IF e = EXT_UC_WDSibyl_SCU  THEN
          BEGIN
               s := ppfName;
               {Test ob SCU neuer als EXE}
               IF not TestFileTimes(s,exename,Return) THEN SCUInvalid := TRUE;
          END;
     END;

     IF SPUInvalid THEN
     BEGIN
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiSPUInvalid));
          exit;
     END;

     IF SCUInvalid THEN
     BEGIN
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiSCUInvalid));
          exit;
     END;
     Result := TRUE;
END;


FUNCTION AutoSaveEnvironment:BOOLEAN;
BEGIN
     Result := FALSE;
     IF Inspector <> NIL THEN Inspector.WriteBackProperties;

     IF IdeSettings.AutoSave * [as_EditorFiles] <> [] THEN
       IF not SaveFiles(TRUE) THEN exit;

     IF IdeSettings.AutoSave * [as_SCU] <> [] THEN
       IF not SaveSCU THEN exit;

     IF Project.FileName <> '' THEN  //kein geschlossenes Projekt
       IF IdeSettings.AutoSave * [as_Project] <> [] THEN
         IF not SaveProject(FALSE) THEN exit;

     IF IdeSettings.AutoSave * [as_INI] <> [] THEN SaveINI(IdeSettings);

     Result := TRUE;
END;

PROCEDURE Run(viaDebug:BOOLEAN);
VAR src,exe,param: STRING;
    d,n,e,curdir : STRING;
    cancel       : BOOLEAN;
    ret          : TMsgDlgReturn;
    Directories  : ^TDirectories;
    DebugOpt     : ^TDebuggerOptions;
    LinkerTarget : TLinkerTarget;
    OdinPEExe    : tFilename;

LABEL NoCompile;
BEGIN
  Application.LogWriteln('Run: Start');
  Case Project.Settings.Platform Of
    pf_OS2:  BEGIN
               Directories:=@Project.Settings.DirectoriesOS2;
               DebugOpt:=@Project.Settings.DebugOptOS2;
               LinkerTarget:=Project.Settings.LinkOptOS2.LinkerTarget;
             End;
    pf_Win32:BEGIN
               Directories:=@Project.Settings.DirectoriesWin;
               DebugOpt:=@Project.Settings.DebugOptWin;
               LinkerTarget:=Project.Settings.LinkOptWin.LinkerTarget;
             END;
  End; //case

  IF InDebugger THEN
    IF not DebuggerRunning THEN
      BEGIN
        LastCommandFromSrc := TRUE;
        IF CPUWindow <> NIL THEN CPUWindow.RemarkAllBreaks;
        DebugCommand(DBG_C_GO);
        exit;
      END;
  IF (DebuggerRunning) or (CompilerActive) then
    BEGIN
      ErrorBox(LoadNLSStr(SiProgramAlreadyRunning));
      exit;
    END;

  IF not AutoSaveEnvironment THEN exit;
  ClearBuildList;

  src := GetMakeName;
  exe := GetExeName;
  IF not CheckDependencies(src,cancel) THEN
    BEGIN
      IF cancel THEN exit;

      IF IdeSettings.AskRecompile THEN
        BEGIN
           ret := MessageBox(LoadNLSStr(SiFilesOutOfDate)+#13#10+#13#10+
                              LoadNLSStr(SiRebuildFiles),
                              mtInformation,mbYesNoCancel);
           CASE ret OF
              mrYes: ;
              mrNo: goto NoCompile;
              mrCancel: exit;
           END;
        END;

      Application.LogWriteln('Run: Aufruf von RunCompiler:'+src + ', ActionMake');
      IF not RunCompiler(Action_Make,src) THEN exit;
    END;

NoCompile:
  {Wechseln ins EXE Verzeichnis}
  {$i-}
  GetDir(0,curdir);
  {$i+}
  FSplit(exe,d,n,e);
  NormalizeDir(d);
  {$i-}
  ChangeDir(d);
  {$i+}

  param:=Project.Settings.RunParam;

  if Project.Settings.ProjectType=pt_Visual then
    param:=param+' '+paramWDSibylIDE;

  Application.LogWriteln('Run: ' + Param);

  IF viaDebug THEN
    BEGIN
      HideSibylForms;
      {Programm Parameter auch ndern in SIBYL.PAS (F7,F8,F4)}
      LastCommandFromSrc := TRUE;
      IF CPUWindow <> NIL THEN CPUWindow.RemarkAllBreaks;
      AddSrcDir(Directories^.LibSrcDir);
      AddSrcDir(Directories^.IncSrcDir);
      DbgSetExceptions(DebugOpt^.RTL_Exceptions,DebugOpt^.SPCC_Exceptions);
      LoadDbgProcess(exe,param,Application.MainForm.Handle,
                     Application.MainForm.Frame.Handle,5);
      {Break at start and run again}
      IF not InDebugger
        THEN
          BEGIN
             ErrorBox(LoadNLSStr(SiErrorLoadingProcess));
             ShowSibylForms;
          END
      ELSE IF SymbolsWindow<>NIL
        THEN SymbolsWindow.UpdateSymbols;
      SetOptions(DebugOpt^.Options);
    END
  ELSE
    BEGIN
      ClearDebugList;
      {HideSibylForms;}
      OdinPEExe:=goSysInfo.SysAppInfo.OdinPEExe;
      if LinkerTarget <> lt_GUI then
        OdinPEExe:=ReplaceStr(OdinPEExe, 'PE.EXE','PEC.EXE');

      if (Project.Settings.Platform = pf_Win32) and
         (goSysInfo.OS.System=OS2) and
         (OdinPEExe<>'')
        then
          Begin
            Param:=exe+' '+param;
            SetCompilerStatusMessage('Start Odin: ('+
                ExtractFileName(OdinPEExe) +') '+param,'',errNone,0,0);
            Exec2(OdinPEExe, param);   // Programm ber Odin Starten
          End
        else
          Begin
            SetCompilerStatusMessage('Start: '+exe+' '+param,'',errNone,0,0);
            Exec2(exe,param);                 // Normal starten
          End;
      {ShowSibylForms;}
    END;
  {$i-}
  ChangeDir(curdir);  //zurck ins alte Verzeichnis
  {$i+}
  Application.LogWriteln('Run: Ende')
END;


PROCEDURE Compile;
VAR  s:STRING;
BEGIN
  IF InDebugger THEN exit;

  IF CompilerActive THEN
  BEGIN
       //ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
       IF IdeSettings.EnableSound THEN Beep(100,50);
       exit;
  END;

  IF not AutoSaveEnvironment THEN exit;
  ClearBuildList;

  s := GetCompileName;
  IF s = '' THEN exit;

  RunCompiler(Action_Compile,s);
END;


PROCEDURE Make;
VAR  s:STRING;
     cancel:BOOLEAN;
BEGIN
     Application.LogWriteln('Make: Start');
     IF InDebugger THEN exit;

     IF CompilerActive THEN
     BEGIN
          //ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          IF IdeSettings.EnableSound THEN Beep(100,50);
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     s := GetMakeName;
     IF s = '' THEN exit;

     IF ExistProjectMain(s) THEN {SONST auf jeden Fall Compiler anwerfen}
     BEGIN
          IF CheckDependencies(s,cancel) THEN
          BEGIN
               WriteMessage(LoadNLSStr(SiDependenciesOk));
               exit;
          END
          ELSE IF cancel THEN exit;
     END;

     RunCompiler(Action_Make,s);
     Application.LogWriteln('Make: Ende');
END;


PROCEDURE Build;
VAR  s:STRING;
BEGIN
     IF InDebugger THEN exit;

     IF CompilerActive THEN
     BEGIN
          //ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          IF IdeSettings.EnableSound THEN Beep(100,50);
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     s := GetMakeName;
     IF s = '' THEN exit;

     RunCompiler(Action_Build,s);
END;


PROCEDURE ForceCompile(Action:TCompilerActions;FileName:STRING);
BEGIN
     IF FileName = '' THEN exit;

     IF InDebugger THEN exit;

     IF CompilerActive THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     RunCompiler(Action,FileName);
END;



BEGIN
  ComponentSPUDir := '';
  CompilerThread := NIL;
  ForceCompileProc := @ForceCompile;
  StopCompilerProc := @StopCompiler;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Dec-02  WD         Ausbau des Standard-Teil
  09-Dec-02  WD         Einbau der Unit: uExtension
  09-Dec-02  WD         Einbau vom Logging
  01-Mai-04  WD         Verarbeiten von mehreren Verz. in der Eigenschaft: Output-Verz.
  26-Feb-05  WD         Statt "default.ico" bzw. "wdefault.ico" "default_os2" bzw "default_win32" verwenden
  11-Mar-05  WD         Den Help-Compiler (.SHS) eingebaut
  16-Jun-05  WD         Umbauen des Compiler-Systems, damit das umschalten zwischen den OS funktioniert
  15-Aug-05  WD         Beim Starten des Programmes den Parameter "-WDSibylIDE" mitgeben.
                        Damit weiss das Programm, dass es von der IDE aufgerufen worden ist.
  14-Okt-05  WD         Den Parameter nur mitgeben wenn es sich um ein GUI-Programm handelt
  22-Mar-06  WD         Programme die unter OS/2 geschrieben worden sind und fuer Windows kompiliert,
                        dann soll das Programm ber Odin gestartet werden
  18-Mai-06  WD         Umbauten fuer die Windows-Version
  09-Mar-06  WD         Auslagern von diversen Logs in die DLL.
}
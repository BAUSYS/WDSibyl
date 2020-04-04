
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

PROGRAM WDSPC10;      

USES Dos,Crt,SysUtils,SPC_Data,Projects, uSysInfo,
     uFunc;

Const cVersion   = '1.0';      

var CompilerDLL : tcCompiler;

PROCEDURE CallInvokeCompiler(VAR Params:TPasParams;VAR Return:TPasReturn);


BEGIN
  Writeln('Datei: ', Params.Quell);
  CompilerDLL.Create(CompSPC,'');
  TRY
    CompilerDLL.InvokeCompiler(Params,Return);
  EXCEPT
    Return.Error := TRUE;
    SetCompilerStatusMessage('Internal Compiler Error occured.','',errNone,0,0);
  END;
  CompilerDLL.Destroy;
END;


VAR
  Params:TPasParams;
  Return:TPasReturn;
  prj,d,n,e,s:STRING;
  Settings:TProjectSettings;
  i:LONGINT;
  TheCount:LONGINT;

BEGIN
  IF ParamCount = 0 THEN
  BEGIN
    Writeln('ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
    Writeln('บ                                                                         บ');
{$IFDEF OS2}
    Writeln('บ Speed-Pascal Version 2.5 for OS/2  (C) 1995..99 SpeedSoft               บ');
    Writeln('บ WDPascal     Version '+cVersion+' for OS/2  (C) 2004..05 Ing. Wolfgang Draxler   บ');
{$ENDIF}
{$IFDEF Win32}
    Writeln('บ Speed-Pascal Version 2.5 for Win32  (C) 1995..99 SpeedSoft              บ');
    Writeln('บ WDPascal     Version '+cVersion+' for Win32  (C) 2004..05 Ing. Wolfgang Draxler  บ');
{$ENDIF}
{$IFDEF Linux}
    Writeln('บ Speed-Pascal Version 2.5 for Linux  (C) 1995..99 SpeedSoft              บ');
    Writeln('บ WDPascal     Version '+cVersion+' for Linux  (C) 2004..05 Ing. Wolfgang Draxler  บ');
{$ENDIF}

    Writeln('บ                                                                         บ');
    Writeln('บ Syntax: '+goSysInfo.ProgramInfo.Name+' Source[.PAS] [OutDir[ LibDir[ IncSrcDir]]] [Options]    บ');
    Writeln('บ     or: '+goSysInfo.ProgramInfo.Name+' PrjFile.SPR [Options]                                   บ');
    Writeln('บ                                                                         บ');
    Writeln('บ Options are:                                                            บ');
    Writeln('บ   -M     Make Units                                                     บ');
    Writeln('บ   -B     Build Units                                                    บ');
    Writeln('บ                                                                         บ');
{$IFDEF OS2}
    Writeln('บ   -OS2   OS/2 Target (default)                                          บ');
    Writeln('บ   -W32   Win32 Target                                                   บ');
    Writeln('บ   -Linux Linux Target                                                   บ');
{$ENDIF}
{$IFDEF Win32}
    Writeln('บ   -W32   Win32 Target (default)                                         บ');
    Writeln('บ   -OS2   OS/2 Target                                                    บ');
    Writeln('บ   -Linux Linux Target                                                   บ');
{$ENDIF}
{$IFDEF Linux}
    Writeln('บ   -W32   Win32 Target (default)                                         บ');
    Writeln('บ   -OS2   OS/2 Target                                                    บ');
    Writeln('บ   -Linux Linux Target                                                   บ');
{$ENDIF}
    Writeln('บ                                                                         บ');
    Writeln('บ   -A     Generate assembler source                                      บ');
    Writeln('บ   -Z     Inlined string functions                                       บ');
    Writeln('บ   -V     Strict VAR strings                                             บ');
    Writeln('บ   -C     Complete boolean evaluation                                    บ');
    Writeln('บ                                                                         บ');
    Write  ('บ >> RETURN <<                                                            บ');
    Readln;
    Writeln('บ   -O0    Disable optimizations                                          บ');
    Writeln('บ   -O1    Optimize subexpressions only                                   บ');
    Writeln('บ   -O2    Peephole optimization only                                     บ');
    Writeln('บ   -O3    Optimize all (default)                                         บ');
    Writeln('บ                                                                         บ');
    Writeln('บ   -$I-   Disable IO checking                                            บ');
    Writeln('บ   -$Q+   Enable Overflow checking                                       บ');
    Writeln('บ   -$S+   Enable Stack checking                                          บ');
    Writeln('บ   -$R+   Enable Range checking                                          บ');
    Writeln('บ                                                                         บ');
    Writeln('บ   -$WA+  Enable all warnings                                            บ');
    Writeln('บ   -$WA-  Disable all warnings                                           บ');
    Writeln('บ   -$W1+  Enable warning "Possible use of variable before definition"    บ');
    Writeln('บ   -$W2-  Disable warning "Inherited property redefined"                 บ');
    Writeln('บ   -$W3-  Disable warning "Inherited variable redefined"                 บ');
    Writeln('บ   -$W4-  Disable warning "Virtual method redefined"                     บ');
    Writeln('บ   -$W5-  Disable warning "Identifier is declared but never used"        บ');
    Writeln('บ   -$W6-  Disable warning "Parameter is declared but never used"         บ');
    Writeln('บ   -$W7-  Disable warning "Function should return a value"               บ');
    Writeln('บ   -WC..  Maximum warning count                                          บ');
    Writeln('บ   -EC..  Maximum error count                                            บ');
    Writeln('บ                                                                         บ');
    Writeln('บ   -D     Generate debug information                                     บ');
    Writeln('บ   -L     Generate local symbols info                                    บ');
    Writeln('บ                                                                         บ');
    Write  ('บ >> RETURN <<                                                            บ');
    Readln;
    Writeln('บ                                                                         บ');
    Writeln('บ   -$C+   Enable Assertions                                              บ');
    Writeln('บ   -$TRY+ Save Constructors                                              บ');
    Writeln('บ                                                                         บ');
    Writeln('บ   -%S..  Stack size in kByte                                            บ');
    Writeln('บ   -%H..  Heap size in kByte                                             บ');
    Writeln('บ                                                                         บ');
    Writeln('บ   -T1    GUI window target (default)                                    บ');
    Writeln('บ   -T2    Text window target                                             บ');
    Writeln('บ   -T3    Fullscreen text window target                                  บ');
    Writeln('บ                                                                         บ');
{$IFDEF OS2}
    Writeln('บ   -P1    EXE Pack 1  (OS/2 2.x only)                                    บ');
    Writeln('บ   -P2    EXE Pack 2  (OS/2 Warp only)                                   บ');
    Writeln('บ                                                                         บ');
{$ENDIF}
    Writeln('บ   -VDM   Run from Virtual DOS Machine  (OS/2 only)                      บ');
    Writeln('บ                                                                         บ');
    Writeln('บ   -%M    Single shared DLL data segment                                 บ');
    Writeln('บ                                                                         บ');
    Writeln('ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
    exit;
  END;

  FillChar(Params,sizeof(Params),0);

  FSplit(ParamStr(1),d,n,e);
  UpcaseStr(e);

  IF pos('.SPR',e) > 0 THEN
  BEGIN {lade Settings aus dem Projekt}
    Writeln('Sorry, SPR-Types at the moment not implemeted');
    exit;
/*    prj := FExpand(ParamStr(1));

    ProjectBaseDir := ExtractFilePath(prj);
    UpcaseStr(ProjectBaseDir);

    InitializeProject(Settings);
    IF Not FileExists(prj) THEN
    BEGIN
      Writeln('Could not find project file: '+ prj);
      exit;
    END;

    IF not ReadProject(Settings,prj) THEN
    BEGIN
      Writeln('Could not read project file: '+ prj);
      exit;
    END;

    Params.Quell := ProjectPrimary(Settings);
    Params.Out := ProjectOutDir(Settings);
    Params.ExeOut := '';
    Params.Lib := ProjectLibDir(Settings);
    Params.LibSrc := ProjectLibSrcDir(Settings);
    Params.IncSrcDir := ProjectIncSrcDir(Settings);
    FSplit(ProjectSCUName(Settings),d,n,e);
    IF d[Length(d)] = '\' THEN SetLength(d,Length(d)-1);
    Params.SCUDir := FExpandProject(d);
    Params.Params := '-M' + GetCompilerOptions(Settings);
    FOR i := 2 TO ParamCount DO
      Params.Params := Params.Params + ParamStr(i);
    Params.Defines := GetCompilerDefines(Settings); */
  END
  ELSE
  BEGIN {lade Settings aus der Kommandozeile}
    Params.Quell := FExpand(ParamStr(1));
    Params.Out := Dos.FExpand('');
    Params.ExeOut := '';
    Params.Lib := Dos.FExpand('');
    Params.IncSrcDir := Dos.FExpand('');
    Params.Defines := '';

    TheCount:=ParamCount+1;
    IF (ParamCount>=2) THEN
    BEGIN
         s:=ParamStr(2);
         //IF ((pos(':\',s)<>0) OR (pos('.\',s)<>0)) THEN
         IF ((pos('+',s)=0) AND (pos('-',s)=0)) THEN
         BEGIN
              Params.out:=FExpand(s);
              IF ParamCount>=3 THEN
              BEGIN
                   s:=ParamStr(3);
                   //IF ((pos(':\',s)<>0) OR (pos('.\',s)<>0)) THEN
                   IF ((pos('+',s)=0) AND (pos('-',s)=0)) THEN
                   BEGIN
                        Params.lib:=FExpand(s);
                        IF ParamCount>=4 THEN
                        BEGIN
                             s:=ParamStr(4);
                             //IF ((pos(':\',s)<>0) OR (pos('.\',s)<>0)) THEN
                             IF ((pos('+',s)=0) AND (pos('-',s)=0)) THEN
                             BEGIN
                                  Params.IncSrcDir:=FExpand(s);
                                  TheCount:=5;
                                  IF ParamCount>=5 THEN
                                  BEGIN
                                       Params.params:=ParamStr(5);
                                       TheCount:=6;
                                  END;
                             END
                             ELSE
                             BEGIN
                                  Params.params:=s;
                                  TheCount:=5;
                             END;
                        END;
                   END
                   ELSE
                   BEGIN
                        Params.params:=s;
                        TheCount:=4;
                   END;
              END;
         END
         ELSE
         BEGIN
              Params.params:=s;
              TheCount:=3;
         END;
    END
    ELSE TheCount:=2;

    WHILE TheCount<=ParamCount DO
    BEGIN
         Params.params:=Params.params+ParamStr(TheCount);
         inc(TheCount);
    END;
  END;               
  Params.MsgProc := @SetCompilerStatusMessage;  // =nil --> Ausgabe auf dem Bildschirm
  Params.Version := 201;  //SPC20 owner
  Params.AddResources:= NIL;
  Params.ErrorTable := NIL;
                                           
  FillChar(Return,sizeof(Return),0);

  CallInvokeCompiler(Params,Return);
//  readln;
END.

{ -- date --- --from-- -- changes ----------------------------------------------
  02-Sep-2004 WD       Von dem IDE-Projekt in das SPC25-Projekt verschoben
  19-Dez-2005 WD       Umbau der Datei fuer die Windows-Schiene
  18-Jan-2006 WD       Einbau der Linux-Schiene
}
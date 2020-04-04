
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

UNIT Sib_Comp;

INTERFACE
        

USES Dos,SysUtils,Color,Classes,Forms,Graphics,Buttons,StdCtrls,Dialogs,Editors,
     Consts,Sib_Ctrl,Sib_Prj,Sib_Edit,Compiler,Form_Gen,ToolsAPI,IdeTools,
     DualList,BmpList,
     Menus, Messages, Clipbrd, uSysInfo,
     uSysClass,
     uString, uList;

CONST
    MaxStdNavigatorContents=9;
VAR
    StdNavigatorNames:ARRAY[1..MaxStdNavigatorContents] OF LONGINT;

TYPE
    PNavigatorPageRec=^TNavigatorPageRec;
    TNavigatorPageRec=RECORD
                         Name:STRING[64];
                         Installed:BOOLEAN;
                         Components:TList; {of PNavigatorEntryRec}
    END;

    PNavigatorEntryRec=^TNavigatorEntryRec;
    TNavigatorEntryRec=RECORD
                        ComponentClass:TComponentClass;
                        HelpText:STRING[64];
                        ComponentUnit:STRING[64];
                        Installed:BOOLEAN;
                        Erased:BOOLEAN;
                        Std:BOOLEAN;
                        BmpButtonId:LONGWORD;
                        BmpButtonName:String[30];
    END;

VAR NavigatorPages:TList; {of PNavigatorPageRec}
    RegisterDefaultClassesProc:PROCEDURE;
    CompLibDLL : tcDLL;


FUNCTION InstallComponents:BOOLEAN;
PROCEDURE RemoveComponents;
PROCEDURE EraseCompInstallList;
PROCEDURE LoadCompLib;
FUNCTION  CloseCompLib:BOOLEAN;
PROCEDURE OpenCompLib;
PROCEDURE RecompileCompLib(closeprj:BOOLEAN); {Projekt vorher schlieแen}
PROCEDURE WriteSibylNav;
PROCEDURE GetBitmapFromCompLib(VAR Bitmap:TBitmap;ComponentClass:TComponentClass);
PROCEDURE NewComponent;
PROCEDURE DestroyNavigatorPages;
PROCEDURE FreeRegisteredClasses;
PROCEDURE SetupExpertsMenu;
PROCEDURE RemoveExpertsMenu;

CONST CompLibSearchClassByNameProc:FUNCTION(CONST Name:STRING):TComponentClass=NIL;
      CompLibCallClassPropertyEditorProc:FUNCTION(VAR ClassToEdit:TObject):TClassPropertyEditorReturn=NIL;
      CompLibCallPropertyEditorProc:FUNCTION(Owner:TComponent;PropertyName:STRING;VAR Value;ValueLen:LONGINT;
                                             VAR List:TStringList):TPropertyEditorReturn=NIL;
      CompLibGetExpertsProc:FUNCTION:TList=NIL;
      CompLibPropertyEditorAvailableProc:Function(OwnerClass:TClass;PropertyName:String):Boolean=Nil;
      CompLibClassPropertyEditorAvailableProc:Function(ClassName:String):Boolean=Nil;


IMPLEMENTATION


PROCEDURE SetupExpertsMenu;
VAR MenuItem,SubMenu:TMenuItem;
    Index:LONGINT;
    Count:LONGINT;
    Expert:TIExpert;
    t:LONGINT;
    cm:TCommand;
BEGIN
     Count:=0;
     FOR t:=0 TO LibExpertInstances.Count-1 DO
     BEGIN
          Expert:=TIExpert(LibExpertInstances.Items[t]);
          IF Expert.GetStyle=esStandard THEN inc(Count);
     END;

     IF (Count=0) THEN exit;  //no experts menu

     MenuItem:=Application.MainForm.Menu.MenuItems[cmWindowMenu];
     IF MenuItem=NIL THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiUnableToCreateExpertsMenu));
          exit;
     END;
     Index:=Application.MainForm.Menu.Items.IndexOf(MenuItem);
     MenuItem.Create(Application.MainForm);
     MenuItem.Caption:=LoadNLSStr(SiExperts);
     MenuItem.Hint:=LoadNLSStr(SiActivateExperts);
     MenuItem.Command:=cmExpertsMenu;
     MenuItem.HelpContext := hctxMenuExperts;
     Application.MainForm.Menu.Items.Insert(Index,MenuItem);

     cm:=cmExpert1;
     FOR t:=0 TO LibExpertInstances.Count-1 DO
     BEGIN
          IF (cm>cmExpert15) THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiTooManyExperts));
               exit;
          END;

          Expert:=TIExpert(LibExpertInstances.Items[t]);
          IF Expert.GetStyle=esStandard THEN
          BEGIN
               SubMenu.Create(MenuItem);
               SubMenu.Caption:=Expert.GetMenuText;
               SubMenu.Hint:=Expert.GetName;
               SubMenu.Command:=cm;
               inc(cm);
               MenuItem.Add(SubMenu);
          END;
     END;
END;

PROCEDURE RemoveExpertsMenu;
VAR MenuItem:TMenuItem;
BEGIN
     MenuItem:=Application.MainForm.Menu.MenuItems[cmExpertsMenu];
     IF MenuItem=NIL THEN exit; //No experts menu here
     MenuItem.Destroy;
END;

TYPE
    T_SPU_Header=RECORD
                 //General information
                 Signatur:CSTRING[5];             //Signatur SPU01
                 Name:CSTRING[63];                 //Name of Unit
                 RealName:CSTRING[63];            //Uppercase/lowercase name
                 Version:WORD;                    //Version Number

                 //Symbol table information
                 UnitCount:BYTE;                  //Included units
                 ImportUnitCount:BYTE;            //Included ASM Units
                 CheckSum:LONGINT;                //Checksum INTERFACE part
                 LIBOffset:LONGINT;               //Offset of ASM LIB infos
                 ExportedCompOffset:LONGINT;      //Offset to exported components
                 BrowseInfoOffset:LONGINT;        //Offset to browse infos
                 TypePoolSize:LONGINT;            //Size of type pool
                 NamePoolSize:LONGINT;            //Size of name pool
                 GlobalPoolSize:LONGINT;          //Size of global pool

                 //Asm Import information
                 LIBLen:LONGINT;
                 PoolLen:LONGINT;
                 ProcCount:LONGINT;
                 ProcCheckSum:LONGINT;
                 InitDataStart:LONGINT;
                 InitDataCount:LONGINT;
                 InitDataCheckSum:LONGINT;
                 InitDataLen:LONGINT;
                 UnInitDataCount:LONGINT;
                 UnInitDataCheckSum:LONGINT;
                 UnInitDataLen:LONGINT;
                 DLLCount:BYTE;
                 DLLProcCount:LONGINT;
                 DLLReloCount:LONGINT;
                 CodeOffset:LONGINT;
                 DebugInfo:BOOLEAN;
                 DebugInfoStart:LONGINT;
                 ResourceEnd:LONGINT;
                 Reserved:LONGINT;                //Reserved
    END;


TYPE
    PComponentsToInstall=^TComponentsToInstall;
    TComponentsToInstall=RECORD
                               CompName:STRING;
                               NavigatorPage:STRING;
                               UnitName:STRING;
                               Selected:BOOLEAN;
                               Next:PComponentsToInstall;
                         END;

VAR ComponentsToInstall:PComponentsToInstall;

TYPE
    TSelectCompDialog=CLASS(TDialog)
        DualList:TDualList;
        PROCEDURE SetupComponent;OVERRIDE;
    END;


PROCEDURE GetBitmapFromCompLib(VAR Bitmap:TBitmap;ComponentClass:TComponentClass);
VAR BitmapInfo:^LONGINT;
    BitmapSize:LONGINT;
    excpt:BOOLEAN;
BEGIN
     ASM
        MOV EAX,ComponentClass
        MOV EAX,[EAX+4]   //onto ClassInfo
        MOV EAX,[EAX+8]   //start of property entries
        SUB EAX,4         //onto Bitmap address
        MOV EAX,[EAX]
        MOV BitmapInfo,EAX
     END;

     IF BitmapInfo<>NIL THEN
     BEGIN
          BitmapSize:=BitmapInfo^;
          inc(BitmapInfo,4);
          excpt:=FALSE;
          try
             Bitmap.LoadFromMem(BitmapInfo^,BitmapSize);
          except
             excpt:=TRUE;
          end;
          IF excpt THEN
          BEGIN
               Bitmap.Destroy;
               Bitmap:=NIL;
               exit;
          END;
     END
     ELSE
     BEGIN
          //no Bitmap found -> use defaults
          Bitmap.LoadFromResourceId(1111);
     END;
END;


PROCEDURE WriteSibylNAV;
VAR Page:PNavigatorPageRec;
    Entry:PNavigatorEntryRec;
    f:FILE;
    nav:STRING;
    t,t1,count:LONGINT;
LABEL l;
BEGIN
     nav := GetNAVName;
     assign(f,nav);
     {$i-}
     rewrite(f);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[nav]));
          exit;
     END;

     count:=NavigatorPages.Count;
     {$i-}
     blockWrite(f,count,4);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
l:
          {$i-}
          close(f);
          erase(f);
          {$i+}
          ErrorBox(FmtLoadNLSStr(SiFileWriteError,[nav]));
          exit;
     END;
     FOR t:=0 TO NavigatorPages.Count-1 DO
     BEGIN
          Page:=NavigatorPages.Items[t];
          {$i-}
          blockWrite(f,Page^,sizeof(TNavigatorPageRec));
          {$i+}
          IF InOutRes<>0 THEN goto l;
          count:=Page^.Components.Count;
          {$i-}
          blockWrite(f,count,4);
          {$i+}
          IF InOutRes<>0 THEN goto l;
          FOR t1:=0 TO Page^.Components.Count-1 DO
          BEGIN
               Entry:=Page^.Components.Items[t1];
               {$i-}
               blockWrite(f,Entry^,sizeof(TNavigatorEntryRec));
               {$i+}
               IF InOutRes<>0 THEN goto l;
          END;
     END;
     {$i-}
     close(f);
     {$i+}
     IF InOutRes<>0 THEN goto l;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TSelectCompDialog Class implementation                      บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION GetItemFromName(Name:STRING):PComponentsToInstall;
VAR dummy:PComponentsToInstall;
BEGIN
     result:=NIL;
     dummy:=ComponentsToInstall;
     WHILE dummy<>NIL DO
     BEGIN
          IF dummy^.CompName=Name THEN
          BEGIN
               result:=dummy;
               exit;
          END;
          dummy:=dummy^.Next;
     END;
END;


PROCEDURE TSelectCompDialog.SetupComponent;
VAR  dummy:PComponentsToInstall;
BEGIN
     Inherited SetupComponent;

     ClientWidth:=460;
     Height:=400;
     Caption:=LoadNLSStr(SiSelectComponentsToInstall);

     DualList := InsertDualList(SELF,10,60,440,295,
                       LoadNLSStr(SiAvailableComponents),LoadNLSStr(SiComponentsToInstall));
     DualList.SrcListBox.Sorted := TRUE;
     DualList.SrcListBox.HorzScroll := TRUE;
     dummy := ComponentsToInstall;
     WHILE dummy <> NIL DO
     BEGIN
          DualList.SrcItems.Add(dummy^.CompName);
          dummy := dummy^.Next;
     END;
     DualList.DstListBox.Sorted := TRUE;
     DualList.DstListBox.HorzScroll := TRUE;

     InsertBitBtnNLS(SELF,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


FUNCTION SelectComponents:BOOLEAN;
VAR Dlg:TSelectCompDialog;
    count:LONGINT;
    t,t1:LONGINT;
    dummy:PComponentsToInstall;
    ok:BOOLEAN;
    s,s1:STRING;
    Page,Page1:PNavigatorPageRec;
    Entry:PNavigatorEntryRec;
    Entry2:PNavigatorEntryRec;
    ExistingComponents: string; // AaronL
LABEL again,found,l1;
BEGIN
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogSelectInstallComponents;
again:
     result:=Dlg.Execute;

     IF result=FALSE THEN
     BEGIN
          Dlg.Destroy;
          EraseCompInstallList; //erase ComponentsToInstall list
     END
     ELSE
     BEGIN
          FOR count := 0 TO Dlg.DualList.DstItems.Count-1 DO
          BEGIN
               s := Dlg.DualList.DstItems[count];
               dummy := GetItemFromName(s);
               dummy^.Selected := TRUE;
          END;

          {Check if there was a component selected}
          ok:=FALSE;
          dummy:=ComponentsToInstall;
          WHILE dummy<>NIL DO
          BEGIN
               IF dummy^.Selected THEN ok:=TRUE;
               dummy:=dummy^.Next;
          END;
          IF not ok THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiSelectCompOrExpert));
               goto again;
          END;

          ExistingComponents:='';
          dummy:=ComponentsToInstall;
          WHILE dummy<>NIL DO
          BEGIN
               IF dummy^.Selected THEN
               BEGIN
                    //look if the component is present
                    s:=dummy^.CompName;
                    UpcaseStr(s);
                    FOR t:=0 TO NavigatorPages.Count-1 DO
                    BEGIN                       
                         Page:=NavigatorPages.Items[t];
                         FOR t1:=0 TO Page^.Components.Count-1 DO
                         BEGIN
                              Entry:=Page^.Components.Items[t1];
                              s1:=Entry^.HelpText;
                              UpcaseStr(s1);
                              IF s=s1 THEN
                                IF not (Entry^.ComponentClass IS TIExpert) THEN
                                   IF Entry^.Installed THEN
                                     if pos( dummy^.CompName,
                                             ExistingComponents ) = 0 then
                                     begin   
                                       if ExistingComponents <> '' then
                                         ExistingComponents:= ExistingComponents
                                                            + ',';
                                       ExistingComponents:= ExistingComponents
                                                        + dummy^.CompName;
                                     end;
                                     // note - components may appear twice
                                     // once on their page and once in the library
                         END;
                    END;
               END;
               dummy:=dummy^.Next;
          END;

          if ExistingComponents <> '' then
          begin
            if MessageBox( FmtLoadNLSStr( SiCompAlreadyInstalled, [ ExistingComponents ] ), mtConfirmation, mbYesNo ) =mrNo then
            BEGIN
              Result:= false;
              Dlg.Destroy;
              EraseCompInstallList; //erase ComponentsToInstall list
              exit;
            END
          end;

          dummy:=ComponentsToInstall;
          WHILE dummy<>NIL DO
          BEGIN
               IF dummy^.Selected THEN
               BEGIN
                    //look if the component is present
                    s:=dummy^.CompName;
                    UpcaseStr(s);
                    FOR t:=0 TO NavigatorPages.Count-1 DO
                    BEGIN
                         Page:=NavigatorPages.Items[t];
                         FOR t1:=0 TO Page^.Components.Count-1 DO
                         BEGIN
                              Entry:=Page^.Components.Items[t1];
                              s1:=Entry^.HelpText;
                              UpcaseStr(s1);
                              IF s=s1 THEN
                                IF not (Entry^.ComponentClass IS TIExpert) THEN
                              BEGIN
                                   IF not Entry^.Installed THEN
                                   BEGIN
                                        Page^.Installed:=TRUE;
                                        Entry^.Installed:=TRUE;
                                   END;
                                   goto l1;
                              END;
                         END;
                    END;

                    //look if the page is present
                    IF dummy^.NavigatorPage='' THEN dummy^.NavigatorPage:=LoadNLSStr(SiPaletteUser);
                    s:=dummy^.NavigatorPage;
                    UpcaseStr(s);
                    FOR t:=0 TO NavigatorPages.Count-1 DO
                    BEGIN
                         Page:=NavigatorPages.Items[t];
                         s1:=Page^.Name;
                         upcaseStr(s1);
                         IF s=s1 THEN goto found;
                    END;

                    //create new
                    New(Page);
                    Page^.Name:=dummy^.NavigatorPage;
                    Page^.Components.Create;
                    IF NavigatorPages.Count<>0 THEN
                    BEGIN
                         Page1:=NavigatorPages[NavigatorPages.Count-1];
                         IF Page1^.Name='[Library]' THEN NavigatorPages.Insert(NavigatorPages.Count-1,Page)
                         ELSE NavigatorPages.Add(Page);
                    END
                    ELSE NavigatorPages.Add(Page);
found:
                    Page^.Installed:=TRUE;
                    new(entry);

                    Entry^.ComponentClass:=NIL;
                    Entry^.HelpText:=dummy^.CompName;
                    Entry^.ComponentUnit:=dummy^.UnitName;
                    Entry^.Installed:=TRUE;
                    Entry^.Std:=FALSE;
                    Entry^.BmpButtonId:=0;
                    Entry^.BmpButtonName:='';
                    Page^.Components.Add(Entry);

                    //Add to [Library]
                    FOR t:=0 TO NavigatorPages.Count-1 DO
                    BEGIN
                         Page:=NavigatorPages.Items[t];
                         IF Page^.Name='[Library]' THEN
                         BEGIN
                              New(Entry2);
                              Entry2^:=Entry^;
                              Page^.Components.Add(Entry2);
                              break;
                         END;
                    END;
               END;
l1:
               dummy:=dummy^.Next;
          END;

          Dlg.Destroy;
          EraseCompInstallList;
     END;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: Component Manager implementation                            บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


PROCEDURE DestroyNavigatorPages;
VAR  t,t1:LONGINT;
     PageRec:PNavigatorPageRec;
     PageEntry:PNavigatorEntryRec;
BEGIN
     IF NavigatorPages <> NIL THEN
     BEGIN
          FOR t:=0 TO NavigatorPages.Count-1 DO
          BEGIN
               PageRec:=NavigatorPages.Items[t];

               FOR t1:=PageRec^.Components.Count-1 DOWNTO 0 DO
               BEGIN
                    PageEntry:=PageRec^.Components.Items[t1];
                    Dispose(PageEntry);
               END;
               PageRec^.Components.Destroy;
               Dispose(PageRec);
          END;
          NavigatorPages.Destroy;
          NavigatorPages := NIL;
     END;
END;


PROCEDURE EraseCompInstallList;
VAR dummy,dummy1:PComponentsToInstall;
BEGIN
     dummy:=ComponentsToInstall;
     WHILE dummy<>NIL DO
     BEGIN
          dummy1:=dummy^.Next;
          dispose(dummy);
          dummy:=dummy1;
     END;
     ComponentsToInstall:=NIL;
END;


FUNCTION InstallComponents:BOOLEAN;
VAR Dlg:TOpenDialog;
    s,n,e:STRING;
    f:FILE;
    b:BYTE;
    Header:T_SPU_Header;
    dummy:PComponentsToInstall;
    ret:BOOLEAN;
    ExpertsAvail:BOOLEAN;
    Page:PNavigatorPageRec;
    Entry:PNavigatorEntryRec;
LABEL ex,l,l1,again,l3;
BEGIN
     result:=FALSE;
     ComponentsToInstall:=NIL;
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogOpenInstallComponentUnit;
     Dlg.Title := LoadNLSStr(SiInstallComponentUnit);
     Dlg.AddFilter(LoadNLSStr(SiSibylCompFiles)+' ('+ALL_FILES_UC_WDSibyl_Project+')',ALL_FILES_UC_WDSibyl_Project);
     Dlg.FileName := ALL_FILES_UC_WDSibyl_Project;
     Dlg.DefaultExt := GetDefaultExt(ALL_FILES_UC_WDSibyl_Project);
     ret:=Dlg.Execute;
     s:=Dlg.FileName;
     Dlg.Destroy;
     IF ret THEN
     BEGIN
          FSplit(s,ComponentSPUDir,n,e);   {to add SPU to LibDir}
          NormalizeDir(ComponentSPUDir);

          assign(f,s);
          filemode:=fmInput;
          {$i-}
          reset(f);
          {$i+}
          filemode:=fmInOut;
          IF InOutRes<>0 THEN
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiErrorOpenCompUnit,[s]));
               goto ex;
          END;
          {$i-}
          blockread(f,Header,sizeof(T_SPU_Header));
          {$i+}
          IF InOutRes<>0 THEN
          BEGIN
l1:
               ErrorBox(FmtLoadNLSStr(SiErrorReadingCompUnit,[s]));
l:
               {$i-}
               close(f);
               {$i+}
               goto ex;
          END;
          {$IFDEF OS2}
          IF Header.Signatur<>'SPU40' THEN
          {$ENDIF}
          {$IFDEF WIN32}
          IF Header.Signatur<>'SPW40' THEN
          {$ENDIF}
          BEGIN
l3:
               ErrorBox(FmtLoadNLSStr(SiIllegalUnitFormat,[s]));
               goto l;
          END;

          //Seek to start of component information
          {$i-}
          Seek(f,Header.ExportedCompOffset);
          {$i+}
          IF InOutRes<>0 THEN goto l1;

          {$I-}
          BlockRead(f,ExpertsAvail,1);
          {$I+}
          IF InOutRes<>0 THEN goto l1;

          //read component name
          IF ExpertsAvail THEN b:=0
          ELSE
          BEGIN
               {$i-}
               blockread(f,b,1);
               {$i+}
               IF InOutRes<>0 THEN goto l1;
          END;

          IF b=0 THEN
            IF ComponentsToInstall=NIL THEN
          BEGIN
               IF ExpertsAvail THEN
               BEGIN
                    New(Page);
                    Page^.Name:='';
                    Page^.Components.Create;
                    NavigatorPages.Add(Page);
                    Page^.Installed:=TRUE;
                    New(entry);

                    Entry^.ComponentClass:=TIExpert;
                    Entry^.HelpText:=LoadNLSStr(SiExpert);
                    Entry^.ComponentUnit:=Header.RealName;
                    Entry^.Installed:=TRUE;
                    Entry^.Std:=FALSE;
                    Entry^.BmpButtonId:=0;
                    Entry^.BmpButtonName:='StdBmpOk';
                    Page^.Components.Add(Entry);
                    {$i-}
                    close(f);
                    {$i+}
                    result:=TRUE;
                    exit;
               END
               ELSE
               BEGIN
                    ErrorBox(LoadNLSStr(SiUnitDoesNotContainComps));
                    goto l;
               END;
          END;
again:
          IF b=0 THEN goto l3; //wrong unit format
          new(dummy);
          dummy^.Selected:=FALSE;
          dummy^.Next:=ComponentsToInstall;
          ComponentsToInstall:=dummy;
          dummy^.CompName[0]:=chr(b);
          {$i-}
          blockread(f,dummy^.CompName[1],b);
          {$i+}
          IF InOutRes<>0 THEN goto l1;

          //read component Navigator page
          {$i-}
          blockread(f,b,1);
          {$i+}
          IF InOutRes<>0 THEN goto l1;
          dummy^.NavigatorPage[0]:=chr(b);
          IF b<>0 THEN
          BEGIN
               {$i-}
               blockread(f,dummy^.NavigatorPage[1],b);
               {$i+}
               IF InOutRes<>0 THEN goto l1;
          END;

          //read component Unit
          {$i-}
          blockread(f,b,1);
          {$i+}
          IF InOutRes<>0 THEN goto l1;
          dummy^.UnitName[0]:=chr(b);
          IF b<>0 THEN
          BEGIN
               {$i-}
               blockread(f,dummy^.UnitName[1],b);
               {$i+}
               IF InOutRes<>0 THEN goto l1;
          END;

          //try next entry
          {$i-}
          blockread(f,b,1);
          {$i+}
          IF InOutRes<>0 THEN goto l1;
          IF b<>0 THEN goto again;

          {$i-}
          close(f);
          {$i+}

          result:=SelectComponents;
     END;
ex:
END;


PROCEDURE FreeRegisteredClasses;
BEGIN
     RegisteredClasses.Clear;
END;


PROCEDURE LoadCompLib;
VAR Data:TCompLibData;
    SetupCompLibProc:PROCEDURE(VAR Data:TCompLibData);
    t:LONGINT;
    PropExperts:TList;
    Expert:TIExpertClass;
    ExpertInstance:TIExpert;
    ToolsAPI:TIIDEToolServices;
    complib:STRING;

LABEL error;
BEGIN
     Application.LogWriteln('Procedure: LoadCompLib');
     IF GetCompLibName = '' THEN exit;
     {lade keine CompLib, weil vom User nicht erwnscht}

     IF CompLibDLL<>nil THEN exit; {already loaded}
     CompLibSearchClassByNameProc:=NIL;
     CompLibCallClassPropertyEditorProc:=NIL;
     CompLibCallPropertyEditorProc:=NIL;
     CompLibGetExpertsProc:=NIL;
     CompLibPropertyEditorAvailableProc:=NIL;
     CompLibClassPropertyEditorAvailableProc:=NIL;
     ASM
        MOVD Classes.SearchCompLibComponentByName,0
        MOVD Classes.CallCompLibClassPropertyEditor,0
        MOVD Classes.CallCompLibPropertyEditor,0
        MOVD Classes.CallCompLibClassPropertyEditorAvailable,0
        MOVD Classes.CallCompLibPropertyEditorAvailable,0
     END;
     complib := GetCompLibName;
     Application.LogWriteln('LoadCompLib: '+complib);

     try
       CompLibDLL.Create(complib);
     except
{ Breakpoint hier her und beim Label Error }
       Application.LogWriteln('LoadCompLib: ComplibDLL.Create; Error');
       ErrorBox(FmtLoadNLSStr(SiCouldNotLoadComplib,[complib]));
       goto error;
     end;

     Application.LogWriteln('LoadCompLib: Adressen herausfinden');
     try
       CompLibSearchClassByNameProc:=Pointer(CompLibDll.GetProcAddress('SEARCHCLASSBYNAME'));
       CompLibCallClassPropertyEditorProc:=Pointer(CompLibDll.GetProcAddress('CALLCLASSPROPERTYEDITOR'));
       CompLibCallPropertyEditorProc:=Pointer(CompLibDll.GetProcAddress('CALLPROPERTYEDITOR'));
       CompLibGetExpertsProc:=Pointer(CompLibDll.GetProcAddress('GETEXPERTS'));
       SetupCompLibProc:=Pointer(CompLibDll.GetProcAddress('SETUPCOMPLIB'));
     except
       ErrorBox(LoadNLSStr(SiCouldNotInitComplib));
       goto error;
     End;

     try
       CompLibClassPropertyEditorAvailableProc:=Pointer(CompLibDll.GetProcAddress('CLASSPROPERTYEDITORAVAILABLE'));
       CompLibPropertyEditorAvailableProc:=Pointer(CompLibDll.GetProcAddress('PROPERTYEDITORAVAILABLE'));
     except
       ErrorBox(LoadNLSStr(SiCouldNotInitComplib));
       ErrorBox(LoadNLSStr(SiTryRecompileComplib));
       goto error;
     end;

     Application.LogWriteln('LoadCompLib: Var.: Data befuellen');
     ASM
        LEA EDI,Data
        MOV EAX,CLASSES.InsideWriteSCUAdr
        MOV [EDI].TCompLibData.InsideWriteSCUAdr,EAX
        MOV EAX, System.HeapGroup
        MOV [EDI].TCompLibData.HeapGroup, EAX
     END;

     Data.NullStr:=NullStr;
     Data.Screen:=Screen;
     Data.ClipBoard:=ClipBoard;
     Data.Application:=Application;
     ToolsAPI.Create;
     Data.ToolsAPI:=ToolsAPI;
     SetupCompLibProc(Data);
     Application.LogWriteln('LoadCompLib: danach');
     IF not (Data.ToolsAPIRequired)
       THEN ToolsAPI.Destroy
       ELSE IDEToolServices:=ToolsAPI;
     {Extend the own SearchClassByName Proc with the Proc of the CompLib}
     ASM
        MOV EAX,CompLibSearchClassByNameProc
        MOV Classes.SearchCompLibComponentByName,EAX
     END;

     {Extend the own CallPropertyEditor Proc with the Proc of the CompLib}
     ASM
        MOV EAX,CompLibCallClassPropertyEditorProc
        MOV Classes.CallCompLibClassPropertyEditor,EAX
        MOV EAX,CompLibCallPropertyEditorProc
        MOV Classes.CallCompLibPropertyEditor,EAX
        MOV EAX,CompLibClassPropertyEditorAvailableProc
        MOV Classes.CallCompLibClassPropertyEditorAvailable,EAX
        MOV EAX,CompLibPropertyEditorAvailableProc
        MOV Classes.CallCompLibPropertyEditorAvailable,EAX
     END;
     {Update Experts available}
     ClearRepository;
     ReadRepository(Project.Filename);
     PropExperts:=CompLibGetExpertsProc;    // Aufruf: Complib.DLL
     Application.LogWriteln('PropExperts: '+ tostr(PropExperts.Count));
     FOR t:=0 TO PropExperts.Count-1 DO
       BEGIN
         Expert:=PropExperts.Items[t];
         RegisterLibraryExperts([Expert]);
         ExpertInstance:=Expert.Create(NIL);
         ExpertInstance.Register;
         LibExpertInstances.Add(ExpertInstance);
         AddToRepository(ExpertInstance);
       END;
     PackRepository;  //clear unused entries
     SetupExpertsMenu;
     Application.LogWriteln('LoadCompLib: Exit');
     exit;

error:
     Application.LogWriteln('LoadCompLib: Error');
     CompLibDLL.Destroy;
     CompLibDLL:=nil;
     CompLibSearchClassByNameProc:=NIL;
     CompLibCallClassPropertyEditorProc:=NIL;
     CompLibCallPropertyEditorProc:=NIL;
     CompLibGetExpertsProc:=NIL;
     ASM
        MOVD Classes.SearchCompLibComponentByName,0
        MOVD Classes.CallCompLibClassPropertyEditor,0
        MOVD Classes.CallCompLibPropertyEditor,0
        MOVD Classes.CallCompLibClassPropertyEditorAvailable,0
        MOVD Classes.CallCompLibPropertyEditorAvailable,0
     END;
END;


FUNCTION CloseCompLib:BOOLEAN;
BEGIN
  Result := TRUE;
  IF CompLibDll <> nil THEN
    BEGIN
      FreeAllLibraryExperts;
      RemoveExpertsMenu;
      ClearRepositoryInstances;
      IF IDEToolServices<>NIL THEN
        BEGIN
          IDEToolServices.Destroy;
          IDEToolServices:=NIL;
        END;

      try
        CompLibDLL.Destroy;
      except
        ErrorBox(LoadNLSStr(SiCouldNotFreeComplib));
        Result := FALSE;
        exit;
      END;
      CompLibDLL:=nil;
    END;

  RemoveNavigatorProc;

  CompLibSearchClassByNameProc:=NIL;
  CompLibCallClassPropertyEditorProc:=NIL;
  CompLibCallPropertyEditorProc:=NIL;
  CompLibGetExpertsProc:=NIL;
  {Dont extend the own SearchClassByName Proc with the Proc of the CompLib}
  ASM
     MOVD Classes.SearchCompLibComponentByName,0
     MOVD Classes.CallCompLibClassPropertyEditor,0
     MOVD Classes.CallCompLibPropertyEditor,0
     MOVD Classes.CallCompLibClassPropertyEditorAvailable,0
     MOVD Classes.CallCompLibPropertyEditorAvailable,0
  END;
END;


{neuen FileNamen erfragen; Projekt schlieแen und wieder ”ffnen}
{wenn Datei nicht existiert FEHLER}
PROCEDURE OpenCompLib;
VAR  CFOD:TOpenDialog;
     FName,d,n,e:STRING;
     ret:BOOLEAN;
     IsClosed:BOOLEAN;
BEGIN
  CFOD.Create(NIL);
  CFOD.HelpContext := hctxDialogOpenComponentLibrary;
  CFOD.Caption := LoadNLSStr(SiLoadLibrary);
  CFOD.FileName := '*.DLL';
  CFOD.AddFilter(LoadNLSStr(SiDynamicLinkLibraries)+' (*.dll)','*.DLL');
  CFOD.DefaultExt := GetDefaultExt('*.DLL');
  ret := CFOD.Execute;
  FName := CFOD.Filename;
  CFOD.Destroy;
  IF not ret THEN exit;

  IF not FileExists(FName) THEN
    BEGIN
      ErrorBox(LoadNLSStr(SiCannotLoadComplib));
      exit;
   END;

  FSplit(FName,d,n,e);
  IF Upcased(e) <> '.DLL' THEN
    BEGIN
      ErrorBox(LoadNLSStr(SiYouMustSelectADLL));
      exit;
    END;

  {Projekt schlieแen}
  IsClosed := CloseProject(TRUE);

  IF not IsClosed THEN
    BEGIN
     {bei Cancel keine Meldung bringen}
     IF LastCloseProjectAnswer <> mrCancel
       THEN ErrorBox(LoadNLSStr(SiClosePrjToLoadCompLib));
     exit;
    END;

  //DisableCommandsProc(CompLibCommands);

  IF not Project.Load(IdeSettings.LastProject) THEN Project.Initialize;
  {$IFDEF OS2}
  Project.Settings.CompLibNameOS2 := FName;
  {$ENDIF}
  {$IFDEF WIN32}
  Project.Settings.CompLibNameWin := FName;
  {$ENDIF}
  ExecuteProject;
  {neuen Namen abspeichern}
  IF not SaveProject(FALSE) THEN Project.Modified := TRUE;

  //EnableCommandsProc(CompLibCommands);
END;


PROCEDURE RecompileCompLib(closeprj:BOOLEAN);
VAR f:TEXT;
    SaveNavigatorPages:TList;
    IsClosed:BOOLEAN;
    scl,complib:STRING;
    t:LONGINT;
    s:STRING;
    CompList:TStringList;

 FUNCTION WriteStr(s:STRING):BOOLEAN;
 BEGIN
      {$i-}
      writeln(f,s);
      {$i+}
      IF InOutRes<>0 THEN
      BEGIN
           {$i-}
           close(f);
           {$i+}
           ErrorBox(FmtLoadNLSStr(SiFileWriteError,[complib +'.scl']));
           result:=FALSE;
      END
      ELSE result:=TRUE;
 END;

 FUNCTION WriteUsedUnits:BOOLEAN;
 VAR t,t1,t2:LONGINT;
     UnitList:TStringList;
     PageRec:PNavigatorPageRec;
     EntryRec:PNavigatorEntryRec;
     s:STRING;
 LABEL ex,skip;
 BEGIN
      result:=FALSE;
      UnitList.Create;

      IF NavigatorPages <> NIL THEN
      FOR t:=0 TO NavigatorPages.Count-1 DO
      BEGIN
           PageRec:=NavigatorPages.Items[t];
           IF PageRec^.Installed THEN
           BEGIN
                FOR t1:=0 TO PageRec^.Components.Count-1 DO
                BEGIN
                     EntryRec:=PageRec^.Components.Items[t1];
                     IF EntryRec^.Installed THEN
                       IF not EntryRec^.Std THEN
                     BEGIN
                          s:=EntryRec^.ComponentUnit;
                          UpcaseStr(s);
                          FOR t2:=0 TO UnitList.Count-1 DO
                          BEGIN
                               IF UnitList[t2]=s THEN goto skip;
                          END;
                          UnitList.Add(s);
skip:
                     END;
                END;
           END;
      END;

      {Add the units to the file}
      s:='';
      FOR t:=0 TO UnitList.Count-1 DO
      BEGIN
           IF length(s) > LineBreak THEN
           BEGIN
                s:=s+';';
                IF not WriteStr(s) THEN goto ex;
                s:='';
           END;
           IF s='' THEN
           BEGIN
                IF not WriteStr(Key(_USES_)) THEN goto ex;
                s := IndentBlock + UnitList[t]
           END
           ELSE s := s +','+ IndentSpace + UnitList[t];
      END;

      IF s<>'' THEN
      BEGIN
           s:=s+';';
           IF not WriteStr(s) THEN goto ex;
      END;

      result:=TRUE;
ex:
      UnitList.Destroy;
 END;

 FUNCTION GenUsedComponents:TStringList;
 VAR t,t1,t2:LONGINT;
     PageRec:PNavigatorPageRec;
     EntryRec:PNavigatorEntryRec;
 LABEL skip;
 BEGIN
      result.Create;

      IF NavigatorPages <> NIL THEN
      FOR t:=0 TO NavigatorPages.Count-1 DO
      BEGIN
           PageRec:=NavigatorPages.Items[t];
           IF PageRec^.Installed THEN
           BEGIN
                FOR t1:=0 TO PageRec^.Components.Count-1 DO
                BEGIN
                     EntryRec:=PageRec^.Components.Items[t1];
                     IF EntryRec^.Installed THEN
                       IF not EntryRec^.Std THEN
                         IF EntryRec^.ComponentClass<>TIExpert THEN
                     BEGIN
(* CUT
                          IF EntryRec^.ComponentClass<>NIL THEN
                             s:=EntryRec^.ComponentClass.ClassName
                          ELSE
*)
                          s:=EntryRec^.HelpText;
                          UpcaseStr(s);
                          FOR t2:=0 TO result.Count-1 DO
                          BEGIN
                               IF result[t2]=s THEN goto skip;
                          END;
                          IF s<>'' THEN result.Add(s);
skip:
                     END;
                END;
           END;
      END;
 END;

LABEL ex;
BEGIN
     CompList:=GenUsedComponents;

     IF closeprj THEN
     BEGIN
          {vermeide das Zerst”ren der Pages beim Schlieแen des Projektes
           wegen Rausschreiben der Units (USES)}
          SaveNavigatorPages := NavigatorPages;
          NavigatorPages := NIL;
          {Projekt schlieแen}
          IsClosed := CloseProject(TRUE);
          {recover Pages}
          NavigatorPages := SaveNavigatorPages;

          IF not IsClosed THEN
          BEGIN
               {bei Cancel keine Meldung bringen}
               IF LastCloseProjectAnswer <> mrCancel
               THEN ErrorBox(LoadNLSStr(SiClosePrjToCompileCompLib));
               exit;
          END;
     END;

     IF not CloseCompLib THEN exit;

     //DisableCommandsProc(CompLibCommands);

     complib := GetShortCompLibName;
     scl := GetSCLName;
     assign(f,scl);
     {$i-}
     rewrite(f);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiFileWriteError,[scl]));
          goto ex;
     END;
             
     IF not WriteStr(Key(_LIBRARY_)+' '+ complib +';') THEN goto ex;
     IF not WriteStr('') THEN goto ex;
     IF not WriteStr('{$m 65535,4194304}') THEN goto ex;
     IF not WriteStr('') THEN goto ex;
     IF not WriteStr(Key(_USES_)) THEN goto ex;
     IF not WriteStr(IndentBlock +'Classes,'+ IndentSpace +'Forms;') THEN goto ex;
     IF not WriteUsedUnits THEN goto ex;
     IF not WriteStr('') THEN goto ex;
     IF not WriteStr(Key(_EXPORTS_)) THEN goto ex;
     IF not WriteStr(IndentBlock +'SetupCompLib name '#39'SETUPCOMPLIB'#39',') THEN goto ex;
     IF not WriteStr(IndentBlock +'SearchClassByName name '#39'SEARCHCLASSBYNAME'#39',') THEN goto ex;
     IF not WriteStr(IndentBlock +'CallClassPropertyEditor name '#39'CALLCLASSPROPERTYEDITOR'#39',') THEN goto ex;
     IF not WriteStr(IndentBlock +'CallPropertyEditor name '#39'CALLPROPERTYEDITOR'#39',') THEN goto ex;
     IF not WriteStr(IndentBlock +'PropertyEditorAvailable name '#39'PROPERTYEDITORAVAILABLE'#39',') THEN goto ex;
     IF not WriteStr(IndentBlock +'ClassPropertyEditorAvailable name '#39'CLASSPROPERTYEDITORAVAILABLE'#39',') THEN goto ex;
     IF not WriteStr(IndentBlock +'GetExperts name '#39'GETEXPERTS'#39';') THEN goto ex;
     IF not WriteStr('') THEN goto ex;
     IF not WriteStr(Key(_BEGIN_)) THEN goto ex;
     IF CompList.Count>0 THEN
     BEGIN
          {Add the components to the file}
          s := IndentBlock + 'RegisterClasses([';
          FOR t := 0 TO CompList.Count-1 DO
          BEGIN
               s := s + CompList[t];
               IF t <> CompList.Count-1 THEN s := s + ','
               ELSE s := s + ']);';

               IF length(s) > LineBreak THEN
               BEGIN
                    IF not WriteStr(s) THEN goto ex;

                    IF t <> CompList.Count-1 THEN s := IndentBlock + IndentBlock
                    ELSE s := '';
               END
               ELSE s := s + IndentSpace;
          END;

          IF s <> '' THEN
            IF not WriteStr(s) THEN goto ex;
     END;

     IF not WriteStr(Key(_END_)+'.') THEN goto ex;
     {$i-}
     close(f);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiFileWriteError,[scl]));
          goto ex;
     END;

     {Compile CompLib.SCL}
     IF RunCompiler(Action_CompLib, scl) THEN WriteSibylNav;

     {Pages immer neu aufbauen beim Projekt-Restart,
      weil die TNavigatorEntryRec.ComponentClass ungltig sind}
     DestroyNavigatorPages;
ex:
     CompList.Destroy;
     RestartProject;

     //EnableCommandsProc(CompLibCommands);
END;


TYPE
    TRemoveCompDialog=CLASS(TDialog)
        PageListBox:TListBox;
        CompListBox:TBitmapListBox;
        MustRecompileCompLib:BOOLEAN;

        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE PageItemFocused(Sender:TObject;Index:LONGINT);
        PROCEDURE SetupShow;OVERRIDE;
        PROCEDURE cmd_cmCut(VAR Msg:TMessage); message cmCut;
    END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TRemoveCompDialog Class implementation                      บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TRemoveCompDialog.cmd_cmCut(VAR Msg:TMessage);
VAR  i:LONGINT;
     s:STRING;
     t,t1,t2:LONGINT;
     PageRec:PNavigatorPageRec;
     PageEntry:PNavigatorEntryRec;
     ret:TMsgDlgReturn;
LABEL ex;
BEGIN
     IF CompListBox.ItemIndex < 0 THEN
     BEGIN
          IF ((PageListBox.ItemIndex<0)OR(CompListBox.Items.Count<>0)) THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiSelectComp));
               goto ex;
          END;

          FOR i:=PageListBox.Items.Count-1 DOWNTO 0 DO
          BEGIN
               IF PageListBox.Selected[i] THEN
               BEGIN
                    s:=PageListBox.Items.Strings[i];
                    FOR t:=0 TO NavigatorPages.Count-1 DO
                    BEGIN
                         PageRec:=NavigatorPages.Items[t];
                         IF PageRec^.Components.Count=1 THEN
                           IF PageRec^.Name='' THEN
                         BEGIN
                              PageEntry:=PageRec^.Components.Items[0];
                              IF PageEntry^.ComponentUnit=s THEN
                                IF PageEntry^.ComponentClass IS TIExpert THEN
                              BEGIN
                                   ret:=MessageBox(FmtLoadNLSStr(SiRemoveExpertUnitQuery,[s]),mtConfirmation,mbYesNoCancel);
                                   IF ret=mrYes THEN
                                   BEGIN
                                        PageEntry^.Erased:=TRUE;
                                        PageListBox.Items.Delete(i);
                                        MustRecompileCompLib:=TRUE;
                                   END;
                                   goto ex;
                              END;
                         END;
                    END;
               END;
          END;

          ErrorBox(LoadNLSStr(SiSelectComp));
          goto ex;
     END;

     FOR i := CompListBox.Items.Count-1 DOWNTO 0 DO
     BEGIN
          IF CompListBox.Selected[i] THEN
          BEGIN
               s:=CompListBox.Items.Strings[i];
               CompListBox.Items.Delete(i);

               FOR t:=0 TO NavigatorPages.Count-1 DO
               BEGIN
                    PageRec:=NavigatorPages.Items[t];
                    FOR t1:=0 TO PageRec^.Components.Count-1 DO
                    BEGIN
                         PageEntry:=PageRec^.Components.Items[t1];
                         IF PageEntry^.Std=FALSE THEN IF PageEntry^.HelpText=s THEN PageEntry^.Erased:=TRUE;
                    END;
               END;
          END;
     END;

     {Look if a unit can be erased}
     t2:=PageListBox.ItemIndex;
     IF CompListBox.Items.Count=0 THEN
     BEGIN
          PageListBox.Items.Delete(t2);
          MustRecompileCompLib:=TRUE;
     END;
ex:
     Msg.Handled:=TRUE;
END;

PROCEDURE TRemoveCompDialog.SetupShow;
BEGIN
     Inherited SetupShow;

     IF PageListBox.Items.Count > 0 THEN PageListBox.ItemIndex := 0;
END;

{$HINTS OFF}
PROCEDURE TRemoveCompDialog.PageItemFocused(Sender:TObject;Index:LONGINT);
VAR s:STRING;
    t,t1:LONGINT;
    PageRec:PNavigatorPageRec;
    PageEntry:PNavigatorEntryRec;
    Bitmap:TBitmap;
BEGIN
     CompListBox.BeginUpdate;
     CompListBox.Clear;
     s:=PageListBox.Items.Strings[Index];
     FOR t:=0 TO NavigatorPages.Count-1 DO
     BEGIN
          PageRec:=NavigatorPages.Items[t];
          //Not for Experts page
          IF PageRec^.Name<>'' THEN FOR t1:=0 TO PageRec^.Components.Count-1 DO
          BEGIN
               PageEntry:=PageRec^.Components.Items[t1];
               IF PageEntry^.Std=FALSE THEN
                 IF PageEntry^.ComponentUnit=s THEN
                   IF not PageEntry^.Erased THEN
               BEGIN
                    Bitmap.Create;
                    IF PageEntry^.BmpButtonId<>0 THEN Bitmap.LoadFromResourceId(PageEntry^.BmpButtonId)
                    Else If PageEntry^.BmpButtonName<>'' Then Bitmap.LoadFromResourceName(PageEntry^.BmpButtonName)
                    ELSE GetBitmapFromCompLib(Bitmap,PageEntry^.ComponentClass); //Get Bitmap from COMPLIB.DLL
                    CompListBox.AddBitmap(PageEntry^.HelpText,Bitmap); {autoDestroy}
               END;
          END;
     END;
     CompListBox.EndUpdate;
END;
{$HINTS ON}

PROCEDURE TRemoveCompDialog.SetupComponent;
VAR PageRec:PNavigatorPageRec;
    PageEntry:PNavigatorEntryRec;
    t,t1:LONGINT;
    Btn:TBitBtn;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiRemoveComponents);
     Width:=490;
     Height:=400;

     InsertLabelNLS(SELF,10,335,160,20,SiInstalledUnits);
     PageListBox:=InsertListBox(SELF,10,60,160,270,'');
     PageListBox.Sorted := TRUE;
     PageListBox.HorzScroll:=TRUE;
     PageListBox.Duplicates:=FALSE;
     PageListBox.OnItemFocus:=PageItemFocused;
     PageListBox.Color:=clLtGray;
     FOR t:=0 TO NavigatorPages.Count-1 DO
     BEGIN
          PageRec:=NavigatorPages.Items[t];
          FOR t1:=0 TO PageRec^.Components.Count-1 DO
          BEGIN
               {clear erased flag}
               PageEntry:=PageRec^.Components.Items[t1];
               PageEntry^.Erased:=FALSE;
               IF PageEntry^.Std=FALSE
               THEN PageListBox.Items.Add(PageEntry^.ComponentUnit);
          END;
     END;

     InsertLabelNLS(SELF,185,335,270,20,SiInstalledComps);
     CompListBox := InsertBitmapListBox(SELF,185,60,190,270,24);
     CompListBox.Sorted := TRUE;
     CompListBox.HorzScroll := TRUE;
     CompListBox.MultiSelect := TRUE;
     CompListBox.Color := clLtGray;
     CompListBox.Duplicates := FALSE;

     Btn := InsertBitBtnRes(SELF,385,190,90,30,bmpCut,cmCut,LoadNLSStr(SiRemove),
                            LoadNLSStr(SiRemoveSelectedComps));
     Btn.NumGlyphs:=2;
     Btn.ModalResult := cmNull;
     Btn.Command := cmCut;
     InsertBitBtnNLS(SELF,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


{Return true if COMPLIB must be recompiled (a unit was deleted)}
PROCEDURE RemoveComponents;
VAR Dlg:TRemoveCompDialog;
    t,t1:LONGINT;
    PageRec:PNavigatorPageRec;
    PageEntry:PNavigatorEntryRec;
    compilethis:BOOLEAN;
    SaveNavigatorPages:TList;
    IsClosed:BOOLEAN;
BEGIN
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogRemoveComponents;
     IF Dlg.Execute THEN
     BEGIN
          CompileThis:=Dlg.MustRecompileComplib;
          Dlg.Destroy;

          {vermeide das Zerst”ren der Pages beim Schlieแen des Projektes}
          SaveNavigatorPages := NavigatorPages;
          NavigatorPages := NIL;
          {Projekt schlieแen}
          IsClosed := CloseProject(TRUE);
          {recover Pages}
          NavigatorPages := SaveNavigatorPages;

          IF not IsClosed THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiCannotUpdatePalette));
               exit;
          END;

          {Update PageList}
          FOR t:=0 TO NavigatorPages.Count-1 DO
          BEGIN
               PageRec:=NavigatorPages.Items[t];

               FOR t1:=PageRec^.Components.Count-1 DOWNTO 0 DO
               BEGIN
                    PageEntry:=PageRec^.Components.Items[t1];
                    IF PageEntry^.Erased THEN
                    BEGIN
                         PageRec^.Components.Remove(PageEntry);
                         Dispose(PageEntry);
                    END;
               END;
          END;

          IF CompileThis THEN RecompileCompLib(FALSE) {Projekt ist schon zu}
          ELSE
          BEGIN
               WriteSibylNAV;
               {Pages immer neu aufbauen beim Projekt-Restart,
                 weil die TNavigatorEntryRec.ComponentClass ungltig sind
                 (durch Schlieแen der CompLib)}
               DestroyNavigatorPages;

               RestartProject;
          END;
     END
     ELSE Dlg.Destroy;
END;

TYPE
    TNewCompDialog=CLASS(TDialog)
        NameEntry:TEdit;
        UnitEntry:TEdit;
        AncestorCombo:TComboBox;
        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE cmd_cmOk(VAR Msg:TMessage); message cmOk;
    END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TNewCompDialog Class implementation                         บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TNewCompDialog.cmd_cmOk(VAR Msg:TMessage);
VAR aClass:TComponentClass;
BEGIN
     Msg.Handled:=TRUE;
     IF NameEntry.Caption='' THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiSpecifyCompName));
          exit;
     END;
     IF not IsValidIdentifier(NameEntry.Caption) THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiNotAValidIdent,[NameEntry.Caption]));
          exit;
     END;
     IF AncestorCombo.Caption='' THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiSpecifyAncestorClass));
          exit;
     END;
     aClass:=SearchClassByName(AncestorCombo.Caption);
     IF aClass=NIL THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiIsNotRegistered,[AncestorCombo.Caption]));
          exit;
     END;
     IF UnitEntry.Caption='' THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiSpecifyUnitName));
          exit;
     END;
     IF not IsValidIdentifier(UnitEntry.Caption) THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiNotAValidIdent,[UnitEntry.Caption]));
          exit;
     END;
     IF Upcased(UnitEntry.Caption)=Upcased(NameEntry.Caption) THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiDupCompUnitName));
          exit;
     END;
     Msg.Handled:=FALSE;
END;

PROCEDURE TNewCompDialog.SetupComponent;
VAR t:LONGINT;
    Comp:TComponentClass;
    s:STRING;
BEGIN
     Inherited SetupComponent;

     ClientWidth:=310;
     ClientHeight:=230;
     Caption:=LoadNLSStr(SiGenNewComp);

     InsertLabelNLS(SELF,10,195,290,20,SiComponentName);
     NameEntry:=InsertEdit(SELF,10,170,290,20,'','');
     NameEntry.Focus;

     InsertLabelNLS(SELF,10,145,290,20,SiAncestorClass);
     AncestorCombo:=InsertComboBox(SELF,10,120,290,20,csDropDown);
     AncestorCombo.Sorted := TRUE;
     AncestorCombo.DropDownCount := 6;
     FOR t:=0 TO RegisteredClasses.Count-1 DO
     BEGIN
          Comp:=RegisteredClasses.Items[t];
          IF Comp IS TComponent THEN
          BEGIN
               s:=Comp.ClassName;
               IF s<>'TFORMEDITOR' THEN AncestorCombo.Items.Add(s);
          END;
     END;

     InsertLabelNLS(SELF,10,95,290,20,SiUnitName);
     UnitEntry:=InsertEdit(SELF,10,70,290,20,'','');

     InsertBitBtnNLS(SELF,10,15,90,30, bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,15,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,15,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


PROCEDURE NewComponent;
VAR Dlg:TNewCompDialog;
    aUnitName:STRING;
    CompName:STRING;
    Ancestor:STRING;
    aClass:TComponentClass;
    Editor:TSibEditor;
    s:STRING;
    aline:LONGINT;
BEGIN
     Dlg.Create(Application.MainForm);
     Dlg.HelpContext := hctxDialogNewComponent;
     IF Dlg.Execute THEN
     BEGIN
          aUnitName:=Dlg.UnitEntry.Text;
          CompName:=Dlg.NameEntry.Text;
          Ancestor:=Dlg.AncestorCombo.Text;
          Dlg.Destroy;
          aClass:=SearchClassByName(Ancestor);
          IF aClass<>NIL THEN
          BEGIN
               Editor:=LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
               GetDir(0,s);
               IF s[length(s)]='\' THEN dec(s[0]);
               s:=s+'\'+aUnitName+'.PAS';
               Editor.FileName := s;
               Editor.BeginUpdate;
               WITH Editor DO
               BEGIN
                    aline:=InsertLine(1,Key(_UNIT_)+' '+aUnitName+';');
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,Key(_INTERFACE_));
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,Key(_USES_));
                    s:=aClass.ClassUnit;
                    UpcaseStr(s);
                    IF ((s='CLASSES')OR(s='FORMS'))
                    THEN s := IndentBlock+'Classes,'+IndentSpace+'Forms;'
                    ELSE s := IndentBlock+'Classes,'+IndentSpace+'Forms,'+
                                          IndentSpace+aClass.ClassUnit+';';
                    aline:=InsertLine(aline+1,s);
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,'{'+LoadNLSStr(SiDeclareNewClass)+'}');
                    aline:=InsertLine(aline+1,Key(_TYPE_));
                    aline:=InsertLine(aline+1,IndentBlock+CompName+'='+Key(_CLASS_)+'('+aClass.ClassName+')');
                    aline:=InsertLine(aline+1,IndentBlock+IndentScope+Key(_PROTECTED_));
                    aline:=InsertLine(aline+1,IndentBlock+IndentScope+IndentField+Key(_PROCEDURE_)+' SetupComponent;'+IndentSpace+Key(_OVERRIDE_)+';');
                    aline:=InsertLine(aline+1,IndentBlock+IndentScope+Key(_PUBLIC_));
                    aline:=InsertLine(aline+1,IndentBlock+IndentScope+IndentField+Key(_DESTRUCTOR_)+' Destroy;'+IndentSpace+Key(_OVERRIDE_)+';');
                    aline:=InsertLine(aline+1,IndentBlock+Key(_END_)+';');
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,'{'+LoadNLSStr(SiDefineCompsToExport)+'}');
                    aline:=InsertLine(aline+1,'{'+LoadNLSStr(SiDefineNavPage)+'}');
                    aline:=InsertLine(aline+1,Key(_EXPORTS_));
                    aline:=InsertLine(aline+1,IndentBlock+CompName+','#39+LoadNLSStr(SiPaletteUser)+#39','#39#39';');
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,Key(_IMPLEMENTATION_));
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,Key(_PROCEDURE_)+' '+CompName+'.SetupComponent;');
                    aline:=InsertLine(aline+1,Key(_BEGIN_));
                    aline:=InsertLine(aline+1,IndentBlock+Key(_INHERITED_)+' SetupComponent;');
                    aline:=InsertLine(aline+1,Key(_END_)+';');
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,Key(_DESTRUCTOR_)+' '+CompName+'.Destroy;');
                    aline:=InsertLine(aline+1,Key(_BEGIN_));
                    aline:=InsertLine(aline+1,IndentBlock+Key(_INHERITED_)+' Destroy;');
                    aline:=InsertLine(aline+1,Key(_END_)+';');
                    aline:=InsertLine(aline+1,'');
                    aline:=InsertLine(aline+1,Key(_INITIALIZATION_));
                    aline:=InsertLine(aline+1,IndentBlock+'{'+LoadNLSStr(SiRegisterClasses)+'}');
                    aline:=InsertLine(aline+1,IndentBlock+'RegisterClasses(['+CompName+']);');
                    aline:=InsertLine(aline+1,Key(_END_)+'.');
                    aline:=InsertLine(aline+1,'');
               END;
               Editor.EndUpdate;
               Editor.Invalidate;
          END;
     END
     ELSE Dlg.Destroy;
END;

BEGIN
     NavigatorPages := NIL;
     CloseCompLibProc := @CloseCompLib;
     DestroyNavigatorPagesProc := @DestroyNavigatorPages;

     StdNavigatorNames[1] := SiPaletteStandard;
     StdNavigatorNames[2] := SiPaletteAdditional;
     StdNavigatorNames[3] := SiPaletteExtra;
     StdNavigatorNames[4] := SiPaletteDatabase;
     StdNavigatorNames[5] := SiPaletteMultimedia;
     StdNavigatorNames[6] := SiPaletteDialog;
     StdNavigatorNames[7] := SiPaletteSystem;
     StdNavigatorNames[8] := SiPaletteInternet;
     StdNavigatorNames[9] := SiPaletteSamples;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Dec-02  WD         Unit-Header-Check: Statt SPU31 wird SPU40 verwendet
  09-Dec-02  WD         Einbau der Unit: uExtension
  05-Jul-03  WD         Umbau von SIB_DLL auf uSysClass.pas
  21-Apr-07  WD         Neue Heap-Verwaltung eingebaut.
}

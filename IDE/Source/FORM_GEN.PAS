
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

UNIT Form_Gen;

INTERFACE

USES SysUtils,Dos,Classes,Forms,Dialogs,Editors,
     Consts,Projects,Sib_Edit,Sib_Prj,ParseObj,
     uStream, uString, uList;


FUNCTION GetUnitName(Component:TComponent):STRING;

FUNCTION GenImportForm(Form:TForm; UnitName:STRING;EditInfo:POINTER;EditLen:LONGWORD):BOOLEAN;
PROCEDURE GenUpdateDFM(Form:TForm);
FUNCTION GenNewForm(Form:TForm; UnitName:STRING):BOOLEAN;
PROCEDURE GenRemoveForm(Form:TForm);
FUNCTION GenRenameForm(Form:TForm; NewFormName:STRING):BOOLEAN;

PROCEDURE GenNewComponent(AOwner:TComponent; Component:TComponent);
PROCEDURE GenRemoveComponent(AOwner:TComponent; Component:TComponent);
FUNCTION GenRenameComponent(AOwner:TComponent; Component:TComponent; NewCompName:STRING):BOOLEAN;

FUNCTION GenNewProc(AOwner:TComponent; MethodName:STRING; AddLines:TStringList):BOOLEAN;
FUNCTION GenRemoveProc(AOwner:TComponent; MethodName:STRING):BOOLEAN;
FUNCTION GenRenameProc(AOwner:TComponent; OldMethodName,NewMethodName:STRING):BOOLEAN;
PROCEDURE GenGotoProc(AOwner:TComponent;MethodName:STRING);

PROCEDURE CheckProjectPrimary(Form:TForm;CONST UnitName:STRING);

FUNCTION NameForm(Form:TForm;Editor:TSibEditor):LONGINT;


TYPE {diese Definition steht in der Classes auch noch mal!}
    PIDE_OwnerList=^TIDE_OwnerList;
    TIDE_OwnerList=RECORD
         PropertyName:PString;
         Objekt:TComponent;
    END;

    PIDE_Methods=^TIDE_Methods;
    TIDE_Methods=RECORD
         Name:PString;
         Params:PString;
         Owners:TList;
         Next:PIDE_Methods;
    END;



IMPLEMENTATION


{$HINTS OFF}
FUNCTION Global_Search_Class(Name:STRING):BOOLEAN;
BEGIN
     Result := FALSE;
END;
{$HINTS ON}


FUNCTION GetUnitName(Component:TComponent):STRING;
VAR  sf:STRING;
     Form:TForm;
     i:LONGINT;
     FormItem:PFormListItem;
BEGIN
     Result := '';
     Form := TForm(Component);
     WHILE Form.Owner <> NIL DO Form := TForm(Form.Owner);
     IF not (Form IS TForm) THEN exit;

     sf := Upcased(Form.Name);
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF Upcased(FormItem^.FormName) = sf THEN
          BEGIN
               Result := FormItem^.UnitName;
               exit;
          END;
     END;
END;


FUNCTION NameForm(Form:TForm;Editor:TSibEditor):LONGINT;
VAR i,Nr:LONGINT;
    FormItem:PFormListItem;
    s,s1,s2:STRING;
    cls,frm:TEditorPos;
LABEL lf;
BEGIN
     s := Form.Name;
     {entferne Zahlen am Ende des alten Namens, um Form21 zu vermeiden}
     FOR i := Length(s) DOWNTO 2 DO
     BEGIN
          IF s[i] IN ['0'..'9'] THEN delete(s,i,1)
          ELSE break;
     END;

     {Suche neuen Bezeichner fr die Form}
     nr := 0;
lf:
     inc(nr);
     s1 := Upcased(s + tostr(nr));
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          s2 := Upcased(FormItem^.FormName);
          IF s1 = s2 THEN goto lf;
     END;
     IF Editor <> NIL THEN
       IF Editor.Search_Class('T'+ s + tostr(nr),frm,cls) THEN goto lf;
     {Suche auch in der globalen Interface Bezeichnerliste}
     IF Global_Search_Class(s + tostr(nr)) THEN goto lf;

     Form.Name := s + tostr(nr);
     Form.Caption := Form.Name;

     {fr alle Objekte die eine eigene Klasse definieren (Forms...)
      muแ TypeName den aktuellen TypNamen beinhalten !!!!!!!!!!}
     Form.TypeName := 'T'+ Form.Name;
     //Form.Methods := NIL;   //maybe there are some methods declared
     Result := Nr;
END;


PROCEDURE CheckProjectPrimary(Form:TForm;CONST UnitName:STRING);
VAR  s,PrjDir,Dir,Name,Ext:STRING;
     ProgName:STRING;
     Primary:TSibEditor;
BEGIN
     ProgName := ProjectPrimary(Project.Settings);

     IF ProgName = '' THEN s := Project.FileName
     ELSE s := ProgName;
     FSplit(s,prjdir,name,ext);

     {Unit zum Projekt hinzufgen und in die USES Anweisung einbinden}
     {Name des HauptProgramms}
     IF ProgName = '' THEN
     BEGIN
          {verwende den Stammnamen des Projektes}
          ProgName := prjdir + name + '.pas';
     END;

     Primary := GetEditor(ProgName);
     IF not ExistProjectMain(ProgName) THEN
     BEGIN  {das Primary steht noch nicht in der MainFile Liste}
          AddProjectMain(ProgName);
          Project.Settings.Primary := ProgName;
          {verwende das File im Editor als Primary}
     END;

     IF Primary = NIL THEN
     BEGIN
          Primary := LoadEditor(ProgName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     END;

     IF Primary = NIL THEN
     BEGIN
          Primary := LoadEditor(ProgName,0,0,0,0,FALSE,CursorIgnore,NoFokus,ShowIt);
          FSplit(ProgName,dir,name,ext);
          Primary.GenerateProgramFrame(name, Form.Name);
          {SCUName wurde im Quelltext eingetragen}
          Project.Settings.SCUName := dir + name + '.scu';
          Project.SCUModified := TRUE;
     END;

     {Unit ins Projekt aufnehmen}
     AddProjectUnit(ProgName,UnitName);

     {Unit ins USES eintragen}
     IF Primary <> NIL THEN
     BEGIN
          FSplit(UnitName,dir,name,ext);
          IF Primary.Insert_Uses(name) > 0 THEN Primary.Invalidate;
     END;
END;


// ********************************************************************************
// Beim Importieren wird immer eine KOPIE der Unit angelegt !!!!!!!!!!!!!
// Dabei werden auch immer "eindeutige" Bezeichner generiert (fr Form und Unit)
// Wenn der DAU die Original Source verwenden will, muแ er "Change Source Location" benutzen
// ********************************************************************************

FUNCTION GenImportForm(Form:TForm; UnitName:STRING;EditInfo:POINTER;EditLen:LONGWORD):BOOLEAN;
VAR  s,prjDir,Name,ext:STRING;
     Edit,OrigEdit:TSibEditor;
     Memory:TMemoryStream;
     OldFormName:STRING;
     Nr:LONGINT;
BEGIN
     Result := FALSE;
     IF Form = NIL THEN exit;

     IF ProjectPrimary(Project.Settings) = '' THEN s := Project.FileName
     ELSE s := ProjectPrimary(Project.Settings);
     {Verzeichnis fr neue Files ermitteln}
     FSplit(s,prjdir,name,ext);

     // Form.Name enthlt den Wortstamm der neuen Form zB: "NotebookDialog"
     // daraus wird dann ein eindeutiger FormName generiert
     OldFormName := Form.Name;
     Nr := NameForm(Form,NIL);

     IF (EditInfo <> NIL) THEN
     BEGIN
          // es wird eine neue leere Unit erzeugt (Quelltext vom Template)
          Edit := LoadEditor('',0,0,0,0,FALSE,CursorIgnore,NoFokus,DontShowIt);

          UnitName := GetUniqueFileName(prjdir,'Unit',Nr,'.pas');

          Memory.Create;
          Memory.WriteBuffer(EditInfo^,EditLen);
          Edit.LoadFromStream(Memory);
          Memory.Destroy;
     END
     ELSE
     IF FileExists(UnitName) THEN
     BEGIN
          // Kopiere die existierende Unit und finde einen neuen Namen
          OrigEdit := GetEditor(UnitName);

          IF OrigEdit <> NIL THEN {die Unit ist bereits geladen}
          BEGIN
               // ein leerer Editor wird erzeugt
               Edit := LoadEditor('',0,0,0,0,FALSE,CursorIgnore,NoFokus,DontShowIt);

               {kopiere den Inhalt des Originals}
               Memory.Create;
               OrigEdit.WriteToStream(Memory);
               Edit.LoadFromStream(Memory);
               Memory.Destroy;
          END
          ELSE
          BEGIN
               // die Unit kann neu geladen werden und wird spter einfach umbenannt
               Edit := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,DontShowIt);
          END;

          UnitName := GetUniqueFileName(prjdir,'Unit',Nr,'.pas');
     END
     ELSE
     BEGIN
          // keine Unit Daten gefunden - generiere einen neuen Unit Frame
          Result := GenNewForm(Form,'');
          exit;
     END;


     Edit.BeginUpdate;

     {Modulname anpassen}
     Edit.Rename_Unit(UnitName);
     Edit.FileName := UnitName; {erst nach Rename Unit setzen !}

     {Klasse der Form im Quelltext umbenennen}
     Edit.Rename_Class(OldFormName, Form.Name, TRUE); {ignore MainForm}

     Edit.EndUpdate;

     Edit.Modified := TRUE;
     Edit.Untitled := TRUE;

     Edit.Show;
     Edit.EditorToTop;


     {Flag fr eine neu erzeugte Form setzen}
     IF IdeSettings.Designer.AutoCreateForm
     THEN Include(Form.DesignerState, dsAutoCreate);

     {FormList ergnzen}
     AddProjectForm(Form.Name,UnitName,Form);

     CheckProjectPrimary(Form,UnitName);

     Result := TRUE;
END;


PROCEDURE GenUpdateDFM(Form:TForm);
VAR  UnitName:STRING;
     Edit:TSibEditor;
BEGIN
     UnitName := GetUnitName(Form);
     Edit := GetEditor(UnitName);
     IF Edit = NIL THEN exit;

     Edit.Update_DFM(Form);
END;


FUNCTION GenNewForm(Form:TForm; UnitName:STRING):BOOLEAN;
VAR  i,nr:LONGINT;
     Editor:TSibEditor;
     prjdir,dir,name,ext,s:STRING;
BEGIN
     Result := FALSE;
     IF Form = NIL THEN exit;

     IF UnitName <> '' THEN
     BEGIN
          Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
          IF Editor = NIL THEN
          BEGIN
               Editor := LoadEditor(UnitName,0,0,0,0,FALSE,CursorIgnore,NoFokus,ShowIt);
               FSplit(UnitName,dir,name,ext);
               Editor.GenerateUnitFrame(name);
          END;
          Editor.EditorToTop;
     END
     ELSE Editor := NIL;


     Form.Name := 'Form';
     Nr := NameForm(Form,Editor);

     {alle neuen Files im Verzeichnis des Primary oder im Projektverzeichnis}
     IF ProjectPrimary(Project.Settings) = '' THEN s := Project.FileName
     ELSE s := ProjectPrimary(Project.Settings);
     FSplit(s,prjdir,name,ext);

     IF Editor = NIL THEN {generiere automatisch eine Unit}
     BEGIN
          {versuche gleiche Zahl wie bei der Form zu benutzen}
          UnitName := GetUniqueFileName(prjdir,'Unit',nr,'.pas');
          Editor := LoadEditor('',0,0,0,0,FALSE,CursorIgnore,NoFokus,ShowIt);
          Editor.FileName := UnitName;
          FSplit(UnitName,dir,name,ext);
          Editor.GenerateUnitFrame(name);
          Editor.EditorToTop;
     END;


     {Flag fr eine neu erzeugte Form setzen - vor AddProjectForm!!}
     IF IdeSettings.Designer.AutoCreateForm
     THEN Include(Form.DesignerState, dsAutoCreate);

     {FormList ergnzen}
     AddProjectForm(Form.Name,UnitName,Form);

     CheckProjectPrimary(Form,UnitName);

     {Suche 'IMPLEMENTATION'}
     i := Editor.Search_Implementation;
     IF i > 0 THEN Editor.Insert_Class(i,Form)
     ELSE ErrorBox(LoadNLSStr(SiCannotInsertClassDef));
     Editor.Invalidate;

     Result := TRUE;
END;


PROCEDURE GenRemoveForm(Form:TForm);
VAR  UnitName:STRING;
     Editor:TSibEditor;
BEGIN
     IF Form = NIL THEN exit;

     UnitName := GetUnitName(Form);
     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));

     IF Editor <> NIL THEN
       IF Editor.Remove_Class(Form) THEN
       BEGIN
            Editor.Remove_Dummies;
            Editor.Invalidate;
       END;
END;


FUNCTION GenRenameForm(Form:TForm; NewFormName:STRING):BOOLEAN;
VAR  UnitName:STRING;
     Editor:TSibEditor;
     CompName:STRING;
     i:LONGINT;
     Comp:TComponent;
BEGIN
     Result := FALSE;
     IF Form = NIL THEN exit;

     IF Form.Owner <> NIL THEN   {referenced component}
     BEGIN
          Result := GenRenameComponent(Form.Owner,Form,NewFormName);
          exit;
     END;

     IF not IsValidIdentifier(NewFormName) THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiNotAValidIdent,[NewFormName]));
          exit;
     END;
     {Suche auch in der globalen Interface Bezeichnerliste ob Name valid}
     IF Global_Search_Class(NewFormName) THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiDupGlobalIdent,[NewFormName]));
          exit;
     END;

     CompName := Upcased(NewFormName);
     {Vergleiche mit Child Components}
     FOR i := 0 TO Form.ComponentCount-1 DO
     BEGIN
          Comp := Form.Components[i];
          IF Upcased(Comp.Name) = CompName THEN
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiDupIdent,[NewFormName]));
               exit;
          END;
     END;


     UnitName := GetUnitName(Form);
     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));

     IF Editor <> NIL THEN
     BEGIN
          IF Editor.Rename_Class(Form.Name, NewFormName, FALSE) THEN {dont ignore MainForm}
          BEGIN
               Editor.Invalidate;
               Result := TRUE;
          END
          ELSE {doppelter Bezeichner}
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiDupIdent,[NewFormName]));
               exit;
          END;
     END;

     IF RenameProjectForm(Form.Name,NewFormName) THEN Result := TRUE;

     IF not Result THEN ErrorBox(LoadNLSStr(SiCouldNotRenameForm));
END;


///////////////////////////////////////////////////////////////////////////

FUNCTION GetOwnerForm(AOwner:TComponent):TComponent;
BEGIN
     Result := AOwner;
     WHILE Result <> NIL DO
     BEGIN
          IF Result IS TForm THEN exit;
          Result := Result.Owner;
     END;
     IF Result = NIL THEN Result := AOwner; {Fehler?}
END;


PROCEDURE GenNewComponent(AOwner:TComponent; Component:TComponent);
VAR  s,s1,s2:STRING;
     Comp:TComponent;
     nr,i:LONGINT;
     Editor:TSibEditor;
     UnitName:STRING;
     cmp,cmpt:TEditorPos;
     genCaption:BOOLEAN;
LABEL l,noDes;
BEGIN
     IF Component = NIL THEN exit;

     UnitName := GetUnitName(AOwner);

     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));

     genCaption := TRUE;               {generate new Caption}
     IF Component IS TControl THEN
       IF TForm(Component).Caption <> Component.Name   {typecast to have access to Caption}
       THEN genCaption := FALSE;
(* gibt es nicht mehr
     IF not Component.Designed THEN    {predefined Components}
     BEGIN
          nr := 0;
          s := Component.Name;
          s1 := Component.Name;
          goto noDes;
     END;
*)
     s := Component.Name;
     IF not IsValidIdentifier(s) THEN
     BEGIN
          s := Component.ClassName;
          Delete(s,1,1);  {"T"}
     END;

     {entferne Zahlen am Ende des alten Namens, um Label21 zu vermeiden}
     FOR i := Length(s) DOWNTO 2 DO
     BEGIN
          IF s[i] IN ['0'..'9'] THEN delete(s,i,1)
          ELSE break;
     END;

     nr := 0;
l:
     inc(nr);
     s1 := s + tostr(nr);
     IF AOwner <> NIL THEN
     FOR i := 0 TO AOwner.ComponentCount-1 DO
     BEGIN
          Comp := AOwner.Components[i];
          IF Comp = Component THEN continue;    {eigener Name wre Ok}
          s2 := Upcased(Comp.Name);
          IF s2 = Upcased(s1) THEN goto l;
     END;

     IF Editor <> NIL THEN
       IF Editor.ParseCLASSDefinition('T'+AOwner.Name) THEN
         IF ComponentExist(s1,cmp,cmpt) THEN
         BEGIN
              DestroySymbolTable;
              goto l;
         END;
     DestroySymbolTable;

//     Component.SetDesigning(TRUE);      {force to rename Component}

noDes:
//     IF Component.Designed THEN         {update Name Property}
     BEGIN
          Component.Name := s1;
          IF genCaption THEN
            IF Component IS TControl
            THEN TForm(Component).Caption := Component.Name; {typecast to have access to Caption}
     END;

     IF Editor = NIL THEN exit;
     Editor.Insert_Component('T'+AOwner.Name,Component);
END;


PROCEDURE GenRemoveComponent(AOwner:TComponent; Component:TComponent);
VAR  UnitName:STRING;
     Editor:TSibEditor;
BEGIN
     IF Component = NIL THEN exit;
     {IF Component IS TMenuItem THEN exit; NEUU}

     AOwner := GetOwnerForm(AOwner); {wenn die Form nicht der Owner ist}

     UnitName := GetUnitName(AOwner);

     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));
          exit;
     END;

     Editor.Remove_Component('T'+AOwner.Name,Component);
END;


FUNCTION GenRenameComponent(AOwner:TComponent; Component:TComponent;
                            NewCompName:STRING):BOOLEAN;
VAR  UnitName:STRING;
     Editor:TSibEditor;
     i:LONGINT;
     Comp:TComponent;
     CompName:STRING;
BEGIN
     Result := FALSE;
     IF Component = NIL THEN exit;

     AOwner := GetOwnerForm(AOwner); {wenn die Form nicht der Owner ist}

     IF not IsValidIdentifier(NewCompName) THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiNotAValidIdent,[NewCompName]));
          exit;
     END;

     CompName := Upcased(NewCompName);
     {Vergleiche Name der Form (Owner) mit neuem Namen}
     IF Upcased(AOwner.Name) = CompName THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiDupIdent,[NewCompName]));
          exit;
     END;

     {Vergleiche mit Component Siblings}
     FOR i := 0 TO AOwner.ComponentCount-1 DO
     BEGIN
          Comp := AOwner.Components[i];
          IF Comp = Component THEN continue;
          IF Upcased(Comp.Name) = CompName THEN
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiDuplicateComponentIdent,[NewCompName]));
               exit;
          END;
     END;

(*
     IF IsNewClass(Component) THEN
       {Suche auch in der globalen Interface Bezeichnerliste ob Name valid}
       IF Global_Search_Class(NewCompName) THEN exit;
       BEGIN
            ErrorBox('Duplicate global identifier "'+ NewCompName +'".');
            exit;
       END;
*)
     UnitName := GetUnitName(AOwner);
     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));
          exit;
     END;

     IF Editor.Rename_Component('T'+ AOwner.Name,Component,NewCompName) THEN
     BEGIN
          Editor.Invalidate;
          Result := TRUE;
     END;
END;

///////////////////////////////////////////////////////////////////////////


PROCEDURE GenGotoProc(AOwner:TComponent;MethodName:STRING);
VAR  Editor:TSibEditor;
     UnitName:STRING;
BEGIN
     UnitName := GetUnitName(AOwner);
     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));
          exit;
     END;

     IF Editor.Goto_Method('T'+AOwner.Name,MethodName) THEN
     BEGIN
          Editor.BringToFront;
          Editor.CaptureFocus;
     END;
END;


FUNCTION GenNewProc(AOwner:TComponent; MethodName:STRING; AddLines:TStringList):BOOLEAN;
VAR  Editor:TSibEditor;
     UnitName:STRING;
     pt:TEditorPos;
     x:INTEGER;
BEGIN
     Result := FALSE;

     UnitName := GetUnitName(AOwner);
     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));
          exit;
     END;

     {wahlweise Leerzeichen wegen Lesbarkeit}
     IF pos('(',MethodName) > 0 THEN {Parameterliste existiert}
     BEGIN
          insert(IndentSpace,MethodName,pos('(',MethodName));   {?}
          FOR x := Length(MethodName)-1 DOWNTO 1 DO
             IF MethodName[x] IN [',',';',':']
             THEN insert(IndentSpace,MethodName,x+1);
     END;

     pt := Editor.Insert_Method('T'+AOwner.Name,MethodName,AddLines);
     IF pt.Y > 0 THEN
     BEGIN
          Editor.GotoPosition(pt);
          Editor.BringToFront;
          Editor.CaptureFocus;
          Editor.Invalidate;
          Result := TRUE;
     END;
END;


FUNCTION GenRemoveProc(AOwner:TComponent; MethodName:STRING):BOOLEAN;
BEGIN
     IF MessageBox(FmtLoadNLSStr(SiDeleteHandlerQuery,[AOwner.Name,MethodName]),mtWarning,mbYesNo) = mrYes
     THEN Result := TRUE
     ELSE Result := FALSE;
END;


FUNCTION GenRenameProc(AOwner:TComponent; OldMethodName,NewMethodName:STRING):BOOLEAN;
VAR  Editor:TSibEditor;
     UnitName:STRING;
BEGIN
     Result := FALSE;

     UnitName := GetUnitName(AOwner);
     Editor := LoadEditor(UnitName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor = NIL THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[UnitName]));
          exit;
     END;

     IF Editor.Rename_Method('T'+AOwner.Name,OldMethodName,NewMethodName) THEN
     BEGIN
          Editor.Invalidate;
          Result := TRUE;
     END;
END;



BEGIN
     GenRemoveFormProc := @GenRemoveForm;
END.


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

UNIT IDETools;

INTERFACE

USES Dos,SysUtils,Color,Classes,Forms,Graphics,ToolsApi,Editors,StdCtrls,Buttons,
     TabCtrls,Dialogs,ListView,DualList,BmpList,
     Consts,Projects,Sib_Prj,Sib_Ctrl,Sib_Edit,Form_Gen,ExtCtrls,
     Menus, Messages,
     uStream, uString, uList;


TYPE TIIDEToolServices=CLASS(TIToolServices)
         FNotifyList:TList;
         FUNCTION OpenProject(CONST PrjName:STRING):Boolean; OVERRIDE;
         FUNCTION OpenProjectEx(CONST PrjName:STRING;VisualProject,CreateNew:BOOLEAN):Boolean;OVERRIDE;
         FUNCTION CloseProject:Boolean; OVERRIDE;
         FUNCTION OpenProjectInfo(CONST PrjName:STRING):Boolean; OVERRIDE;
         FUNCTION SaveProject:Boolean; OVERRIDE;
         FUNCTION OpenFile(CONST FileName:STRING):Boolean; OVERRIDE;
         FUNCTION CloseFile(CONST FileName:STRING):Boolean; OVERRIDE;
         FUNCTION SaveFile(CONST FileName:STRING):Boolean; OVERRIDE;
         FUNCTION CreateModule(CONST ModuleName:STRING;Source, Form:TMemoryStream;
                               CreateFlags: TCreateModuleFlags):Boolean; OVERRIDE;
         FUNCTION CreateModuleEx(CONST ModuleName, FormName, AncestorClass:STRING;
                                 Source, Form: TMemoryStream;
                                 CreateFlags: TCreateModuleFlags):TIModuleInterface; OVERRIDE;
         FUNCTION GetParentForm:TForm; OVERRIDE;
         FUNCTION GetProjectName:STRING; OVERRIDE;
         FUNCTION GetPrimaryFile:STRING;OVERRIDE;
         FUNCTION GetUnitCount:LONGINT; OVERRIDE;
         FUNCTION GetUnitName(Index:LONGINT):STRING; OVERRIDE;
         FUNCTION EnumProjectUnits(EnumProc: TProjectEnumProc;Param: Pointer):Boolean; OVERRIDE;
         PROCEDURE GetProjectFiles(AStrings:TStrings);OVERRIDE;
         FUNCTION GetFormCount:LONGINT; OVERRIDE;
         FUNCTION GetFormName(Index:LONGINT):STRING; OVERRIDE;
         FUNCTION GetCurrentFile:STRING; OVERRIDE;
         FUNCTION IsFileOpen(CONST FileName:STRING):Boolean; OVERRIDE;
         FUNCTION GetNewModuleName(VAR UnitIdent,FileName:STRING):Boolean; OVERRIDE;
         FUNCTION GetModuleCount:LONGINT; OVERRIDE;
         FUNCTION GetModuleName(Index:LONGINT):STRING; OVERRIDE;
         FUNCTION GetComponentCount(Index:LONGINT):LONGINT; OVERRIDE;
         FUNCTION GetComponentName(ModIndex,CompIndex:LONGINT):STRING; OVERRIDE;
         FUNCTION GetModuleInterface(CONST FileName:STRING):TIModuleInterface;OVERRIDE;
         FUNCTION GetFormModuleInterface(CONST FormName:STRING):TIModuleInterface; OVERRIDE;
         FUNCTION GetMainMenu:TIMainMenuIntf; OVERRIDE;
         FUNCTION GetMainMenuHandle:TMenu;OVERRIDE;
         FUNCTION AddNotifier(AddInNotifier:TIAddInNotifier):Boolean; OVERRIDE;
         FUNCTION RemoveNotifier(AddInNotifier:TIAddInNotifier):Boolean; OVERRIDE;
         FUNCTION GetVersion:LONGINT; OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE IDEFileNotify(NotifyCode:TFileNotification;CONST FileName:STRING;VAR Cancel:BOOLEAN);
     END;

     TIIDEMainMenuIntf=CLASS(TIMainMenuIntf)
         FMenu:TMainMenu;
         FUNCTION GetMenuItems: TIMenuItemIntf; OVERRIDE;
         FUNCTION FindMenuItem(CONST MenuName:STRING):TIMenuItemIntf; OVERRIDE;
     END;

     TIIDEMenuItemIntf=CLASS(TIMenuItemIntf)
         FMenuItem:TMenuItem;
         FUNCTION DestroyMenuItem:Boolean; OVERRIDE;
         FUNCTION GetIndex:LONGINT; OVERRIDE;
         FUNCTION GetItemCount:LONGINT; OVERRIDE;
         FUNCTION GetItem(Index:LONGINT):TIMenuItemIntf; OVERRIDE;
         FUNCTION GetName:STRING; OVERRIDE;
         FUNCTION GetParent: TIMenuItemIntf; OVERRIDE;
         FUNCTION GetCaption:STRING; OVERRIDE;
         FUNCTION SetCaption(CONST Caption:STRING):Boolean; OVERRIDE;
         FUNCTION GetShortCut:TKeyCode; OVERRIDE;
         FUNCTION SetShortCut(ShortCut:TKeyCode):Boolean; OVERRIDE;
         FUNCTION GetFlags:TIMenuFlags; OVERRIDE;
         FUNCTION SetFlags(Mask,Flags: TIMenuFlags):Boolean; OVERRIDE;
         FUNCTION GetHint:STRING; OVERRIDE;
         FUNCTION SetHint(Hint:STRING):Boolean; OVERRIDE;
         FUNCTION GetContext:THelpContext; OVERRIDE;
         FUNCTION SetContext(Context:THelpContext):Boolean; OVERRIDE;
         FUNCTION GetOnClick:TIMenuClickEvent; OVERRIDE;
         FUNCTION SetOnClick(Click:TIMenuClickEvent):Boolean; OVERRIDE;
         FUNCTION InsertItem(Index:LONGINT;Caption,Name,Hint:STRING;
                             ShortCut:TKeyCode;Context:THelpContext;Flags:TIMenuFlags;
                             EventHandler:TIMenuClickEvent):TIMenuItemIntf; OVERRIDE;
         FUNCTION GetMenuEntry:TMenuItem; OVERRIDE;
     END;

     TIIDEModuleInterface=CLASS(TIModuleInterface)
        FFileName:STRING;
        FFormItem:PFormListItem;
        FUNCTION GetEditorInterface:TIEditorInterface; OVERRIDE;
        FUNCTION GetFormInterface:TIFormInterface; OVERRIDE;
        FUNCTION Close:Boolean; OVERRIDE;
        FUNCTION Save(ForceSave: Boolean):Boolean; OVERRIDE;
        FUNCTION Rename(CONST NewName:STRING):Boolean; OVERRIDE;
        FUNCTION ShowSource:Boolean; OVERRIDE;
        FUNCTION ShowForm:Boolean; OVERRIDE;
        FUNCTION AddNotifier(AModuleNotifier:TIModuleNotifier):Boolean; OVERRIDE;
        FUNCTION RemoveNotifier(AModuleNotifier:TIModuleNotifier):Boolean; OVERRIDE;
     END;

     TIIDEEditorInterface=CLASS(TIEditorInterface)
        FEditor:TEditor;
        FUNCTION GetText(Position:Longint;VAR Buffer;BufSize:Longint):Longint; OVERRIDE;
        FUNCTION CopyTo(Pos:Longint):Boolean; OVERRIDE;
        FUNCTION DeleteTo(Pos:Longint):Boolean; OVERRIDE;
        FUNCTION Insert(VAR Buffer;BufSize:LONGINT):Boolean; OVERRIDE;
        FUNCTION Position: Longint; OVERRIDE;
        FUNCTION FileName:STRING; OVERRIDE;
        FUNCTION LinesInBuffer:LONGINT; OVERRIDE;
        FUNCTION BufferModified:Boolean; OVERRIDE;
        FUNCTION MarkModified:Boolean; OVERRIDE;
        FUNCTION SetSyntaxHighlighter(SyntaxHighlighter:TSyntaxHighlighter):TSyntaxHighlighter; OVERRIDE;
        FUNCTION GetPos:TEditPos; OVERRIDE;
        PROCEDURE SetPos(Value: TEditPos); OVERRIDE;
        FUNCTION GetEditorForm:TEditor; OVERRIDE;
     END;

     TIIDEFormInterface=CLASS(TIFormInterface)
        FFormItem:PFormListItem;
        FUNCTION FileName:STRING; OVERRIDE;
        FUNCTION FormModified:Boolean; OVERRIDE;
        FUNCTION MarkModified:Boolean; OVERRIDE;
        FUNCTION GetFormComponent:TIComponentInterface; OVERRIDE;
        FUNCTION GetFormInstance:TForm; OVERRIDE;
        FUNCTION FindComponent(CONST Name:STRING):TIComponentInterface; OVERRIDE;
        FUNCTION GetComponentFromHandle(ComponentHandle:TObject):TIComponentInterface; OVERRIDE;
        FUNCTION GetSelCount:LONGINT; OVERRIDE;
        FUNCTION GetSelComponent(Index:LONGINT):TIComponentInterface; OVERRIDE;
        FUNCTION GetCreateParent: TIComponentInterface; OVERRIDE;
        FUNCTION CreateComponent(Container: TIComponentInterface;CONST TypeName,Name:STRING;
                                 X,Y,W,H:LONGINT):TIComponentInterface; OVERRIDE;
     END;

     TIIDEComponentInterface=CLASS(TIComponentInterface)
        Component:TComponent;
        FUNCTION GetComponentType:STRING; OVERRIDE;
        FUNCTION GetComponentHandle:TComponent; OVERRIDE;
        FUNCTION GetParent:TIComponentInterface; OVERRIDE;
        FUNCTION IsTControl:Boolean; OVERRIDE;
        FUNCTION GetPropCount:LONGINT; OVERRIDE;
        FUNCTION GetPropName(Index:LONGINT):STRING; OVERRIDE;
        FUNCTION GetPropType(Index:LONGINT;VAR TypeLen:LONGINT):TPropertyType; OVERRIDE;
        FUNCTION GetPropTypeByName(CONST Name:STRING;VAR TypeLen:LONGINT):TPropertyType; OVERRIDE;
        FUNCTION GetPropValue(Index:LONGINT;VAR Value):Boolean; OVERRIDE;
        FUNCTION GetPropValueByName(CONST Name:STRING;VAR Value):Boolean; OVERRIDE;
        FUNCTION SetProp(Index:LONGINT;CONST Value):Boolean; OVERRIDE;
        FUNCTION SetPropByName(CONST Name:STRING;CONST Value):Boolean; OVERRIDE;
        FUNCTION GetChildren(Param:Pointer;Proc:TGetChildCallback): Boolean; OVERRIDE;
        FUNCTION GetControlCount:LONGINT; OVERRIDE;
        FUNCTION GetControl(Index:LONGINT):TIComponentInterface; OVERRIDE;
        FUNCTION GetComponentCount:LONGINT; OVERRIDE;
        FUNCTION GetComponent(Index:LONGINT):TIComponentInterface; OVERRIDE;
        FUNCTION Select: Boolean; OVERRIDE;
        FUNCTION Focus: Boolean; OVERRIDE;
        FUNCTION Delete: Boolean; OVERRIDE;
        FUNCTION SetEventProperty(CONST PropertyName,MethodName:STRING;Code:TStream):BOOLEAN;OVERRIDE;
        FUNCTION GetEventProperty(CONST PropertyName:STRING):STRING;OVERRIDE;
     END;

CONST
   IDEToolServices:TIIDEToolServices=NIL;


PROCEDURE AddToRepository(Expert:TIExpert);
PROCEDURE ClearRepositoryInstances;
PROCEDURE ClearRepository;
FUNCTION GetProjectExpert:TIExpert;
//Falls fr NewForm oder MainForm ein Experte existiert, ist das Resultat die Instanz dieses
//Experten und SCUInfo ist NIL.
//Existiert kein Experte fr NewForm oder MainForm, so existiert evtll ein Projekttemplate das
//fr diesen Fall benutzt werden soll. In diesem Fall wird SCUInfo und SCULen gesetzt und das
//Resultat der Funktion is NIL (kein Experte).
//Der Speicher MUSS vom Aufrufer freigegeben werden !!!!!!!!!!!
//Clear kann benutzt werden um das entsprechene Flag sofort zu l”schen.
FUNCTION GetNewFormExpert(VAR SCUInfo:POINTER;VAR SCULen:LONGWORD;
                          VAR EditorInfo:POINTER;VAR Editorlen:LONGWORD):TIExpert;
FUNCTION GetMainFormExpert(VAR SCUInfo:POINTER;VAR SCULen:LONGWORD;
                           VAR EditorInfo:POINTER;VAR Editorlen:LONGWORD):TIExpert;
FUNCTION NewTemplateForm(SCUInfo:POINTER;SCULen:LONGWORD;
             EditInfo:POINTER;EditLen:LONGWORD):TForm;
PROCEDURE ViewRepository;
PROCEDURE AddFormToRepository(FormEditor:TForm);
PROCEDURE PackRepository;
PROCEDURE NewObject;
PROCEDURE LoadTemplateForms;
PROCEDURE SaveTemplateForms;


TYPE
    PRepForm=^TRepForm;
    TRepForm=RECORD
                  Flag:BYTE;
                  Name:STRING;
                  Author:STRING;
                  Page:STRING;
                  Description:PChar;
                  IconInfo:POINTER;
                  IconLen:LONGWORD;
                  SCUInfo:POINTER;
                  SCULen:LONGWORD;
                  EditInfo:POINTER;
                  EditLen:LONGWORD;
                  Inserted:BOOLEAN;
                  InstalledInPage:BOOLEAN;
                  PageInstalled:BOOLEAN;
                  NewForm:BOOLEAN;
                  NewProject:BOOLEAN;
                  MainForm:BOOLEAN;
    END;

FUNCTION GetRepFormTemplates(CONST LibName:STRING):TList;
PROCEDURE FreeRepFormTemplates(VAR List:TList);
PROCEDURE SaveRepFormTemplates(CONST LibName:STRING;List:TList);

IMPLEMENTATION

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: IDE Tools services                                          บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//Opens a new Project. If PrjName is empty, create a new, empty project.
FUNCTION TIIDEToolServices.OpenProject(CONST PrjName:STRING):Boolean;
BEGIN
     result:=OpenProjectEx(PrjName,TRUE,FALSE);
END;


//Extended version of OpenProject
FUNCTION TIIDEToolServices.OpenProjectEx(CONST PrjName:STRING;VisualProject,CreateNew:BOOLEAN):Boolean;
VAR SaveIDE:BOOLEAN;
BEGIN
     {???????????????????????????????????}
     {falls CreateNew=FALSE, testen ob Project geladen werden kann !!}
     IF PrjName<>'' THEN
     BEGIN
          result:=Sib_Prj.DefaultProject(Prjname,FALSE,FALSE);
          IF result THEN Project.FileName:=PrjName;
     END
     ELSE
     BEGIN
          result:=Sib_Prj.DefaultProject('Project1',FALSE,FALSE);
          Project.Untitled:=TRUE;
     END;

     IF not VisualProject THEN Project.Settings.ProjectType:=pt_NonVisual
     ELSE Project.Settings.ProjectType:=pt_Visual;

     SaveIDE:=StartEmptyForm;
     StartEmptyForm:=FALSE;
     ExecuteProject;
     StartEmptyForm:=SaveIDE;
END;

//Close Project and return TRUE on success
FUNCTION TIIDEToolServices.CloseProject:Boolean;
BEGIN
     result:=Sib_Prj.CloseProject(FALSE);
END;

//Determines if a named project can be opened, no load
FUNCTION TIIDEToolServices.OpenProjectInfo(CONST PrjName:STRING):Boolean;
BEGIN
    result:=FALSE;
    //?????????????????????????????????????
    {testen ob alle teile des projektes da sind}
END;

//Save current project and return TRUE on success
FUNCTION TIIDEToolServices.SaveProject:Boolean;
BEGIN
     Result := Sib_Prj.SaveProject(TRUE);
END;

//returns TRUE if specified file is open or can be loaded
FUNCTION TIIDEToolServices.OpenFile(CONST FileName:STRING):Boolean;
BEGIN
     Result := LoadEditor(FileName,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt) <> NIL;
END;

//Closes open editor file, if it is not open return also TRUE
FUNCTION TIIDEToolServices.CloseFile(CONST FileName:STRING):Boolean;
VAR  Edit:TEditor;
BEGIN
     Result := TRUE;
     Edit := GetEditor(FileName);
     IF Edit <> NIL THEN
     BEGIN
          Edit.Close;
          IF GetEditor(FileName) <> NIL THEN Result := FALSE;
          {close wurde abgebrochen}
     END;
END;

//Saves the specified files, if it is not open return also TRUE
FUNCTION TIIDEToolServices.SaveFile(CONST FileName:STRING):Boolean;
VAR  Edit:TEditor;
BEGIN
     Result := TRUE;
     Edit := GetEditor(FileName);
     IF Edit <> NIL THEN Result := Edit.SaveFile;
END;

{CreateModule     - Will create new module from memory images of the source
                       and, optionally, the form file.  The TCreateModuleFlags are:
      cmfAddToProject - Add the new module to the currently open project.
      cmfShowSource   - Show the source file in the top-most editor window.
      cmfShowForm     - If a form is created, show it above the source.
      cmfUnNamed      - Will mark the module as unnamed which will cause the
                       SaveAs dialog to show the first time the user attempts to
                       save the file.
      cmfNewUnit      - Creates a new unit and adds it to the current project.
                       NOTE: all other parameters are ignored.
      cmfNewForm      - Creates a new form and adds it to the current project.
                       NOTE: all other parameters are ignored.
      cmfNewModel     - Creates a new Data Model and adds it to the current
                       project. NOTE: all other parameters are ignored.
      cmfMainForm     - If the module includes a form, make it the main form of
                       the currently open project. Only valid with the
                       cmAddToProject option.
      cmfMarkModified - Will insure that the new module is marked as modified.
      cmfExisting     - Will Create a module from an existing file on disk}


//Creates a new module
FUNCTION TIIDEToolServices.CreateModule(CONST ModuleName:STRING;Source,
  Form: TMemoryStream; CreateFlags: TCreateModuleFlags):Boolean;

    FUNCTION NewUnit(Name:STRING;Init:TMemoryStream;VAR Editor:TSibEditor;
                     TheForm:TForm):STRING;
    VAR FileName,d,n,e:STRING;
        i:LONGINT;
    BEGIN
         result:='';
         FSplit(Name,d,n,e);
         IF e='' THEN e:='.PAS';
         IF d='' THEN
         BEGIN
              GetDir(0,d);
              d:=d+'\';
         END;
         FileName:=d+n+e;
         //???????????? evtll nicht sichtbar !!!!!!!!!
         Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
         IF Editor = NIL THEN exit;
         Editor.FileName:=FileName;
         IF Init=NIL THEN
         BEGIN
              Editor.GenerateUnitFrame(n);
              i := Editor.Search_Implementation;
              Editor.Insert_Class(i,TheForm);
              //??????????????????????????????????????? aus Form erzeugen !!
              Editor.Invalidate;
         END
         ELSE Editor.InsertText(Init.Memory,Init.Size);
         result:=FileName;
    END;

VAR TheForm:TForm;
    UnitName:STRING;
    Editor:TSibEditor;
    fcx:TEditorPos;
BEGIN
     IF ModuleName='' THEN //oder falls schon belegt
     BEGIN
          result:=FALSE;
          exit;
     END;

     result:=TRUE;
     Editor:=NIL;
     TheForm:=NIL;
     TRY
       IF CreateFlags*[cmfNewForm]<>[] THEN
       BEGIN
            TheForm:=NewFormHandle;

            IF Form=NIL THEN
            BEGIN
                 TheForm.Name := 'Form';
                 NameForm(TheForm,NIL);
            END
            ELSE TheForm.ReadFromStream(Form);

            {Editor ”ffnen und mit Form assoziieren,
             falls SourceStream=NIL -> neu anlegen}
            UnitName:=NewUnit(ModuleName,Source,Editor,TheForm);
            IF UnitName='' THEN
            BEGIN
                 TheForm.Destroy;
                 result:=FALSE;
                 exit;
            END;

            //Add the form to the project

            {Flag fr eine neu erzeugte Form setzen}
            IF IdeSettings.Designer.AutoCreateForm
            THEN Include(TheForm.DesignerState, dsAutoCreate);

            AddProjectForm(TheForm.Name,UnitName,TheForm);

            CheckProjectPrimary(TheForm,UnitName);

            TheForm.TypeName := 'T'+ TheForm.Name;
            IF CreateFlags*[cmfShowForm]<>[] THEN
            BEGIN
                 TheForm.Show;
                 TheForm.Focus;
            END;

            IF CreateFlags*[cmfMainForm]<>[] THEN //make this Form the MainForm
            BEGIN
                 SetProjectMainForm(TheForm.Name,TRUE); {show error if exist}
            END;
       END
       ELSE IF CreateFlags*[cmfNewUnit]<>[] THEN
       BEGIN
            UnitName:=NewUnit(ModuleName,Source,Editor,NIL);
            IF UnitName='' THEN
            BEGIN
                 result:=FALSE;
                 exit;
            END;

            AddProjectUnit(Project.Settings.Primary,UnitName);
            Project.Modified := TRUE;
            Project.NeedRecompile := TRUE;
       END
       ELSE IF CreateFlags*[cmfExisting]<>[] THEN
       BEGIN
            //????????? evtll nicht sichtbar !
            fcx:=CursorHome;
            Editor:=LoadEditor(ModuleName,0,0,0,0,TRUE,fcx,TRUE,ShowIt);
       END;
     EXCEPT
       IF TheForm<>NIL THEN TheForm.Destroy;
       IF Editor<>NIL THEN Editor.Destroy;
       Result:=FALSE;
     END;

     IF Editor<>NIL THEN
     BEGIN
          IF CreateFlags*[cmfMarkModified]<>[] THEN Editor.Modified:=TRUE;
          IF CreateFlags*[cmfUnNamed]<>[] THEN Editor.Untitled:=TRUE;
          IF CreateFlags*[cmfShowSource]<>[] THEN Editor.Show;
     END;
END;

{$HINTS OFF}

//Extended version of CreateModule
FUNCTION TIIDEToolServices.CreateModuleEx(CONST ModuleName, FormName, AncestorClass:STRING;
  Source, Form: TMemoryStream; CreateFlags: TCreateModuleFlags):TIModuleInterface;
BEGIN
     result:=NIL;
     //??????????????????????????????????????????????????
END;

//returns IDE application form
FUNCTION TIIDEToolServices.GetParentForm:TForm;
BEGIN
     result:=Application.MainForm;
END;

//returns current project name
FUNCTION TIIDEToolServices.GetProjectName:STRING;
BEGIN
     IF Project=NIL THEN result:=''
     ELSE result:=Project.FileName;
END;

//returns count of units belonging to the current project
FUNCTION TIIDEToolServices.GetUnitCount:LONGINT;
VAR  Sub:PProjectFile;
BEGIN
     Result := 0;
     Sub := DataProjectMain(GetPrimaryFile);
     IF Sub = NIL THEN exit; // no Primary found
     IF Sub^.ASub = NIL THEN exit; // no child units
     Result := Sub^.ASub.Count;
END;

//returns full name of project unit with specified index
FUNCTION TIIDEToolServices.GetUnitName(Index:LONGINT):STRING;
VAR  Sub:PProjectFile;
BEGIN
     Result := '';
     Sub := DataProjectMain(GetPrimaryFile);
     IF Sub = NIL THEN exit; // no Primary found
     IF Sub^.ASub = NIL THEN exit; // no child units
     Result := Sub^.ASub[Index];
END;

//Calls EnumProc for each unit in the project
FUNCTION TIIDEToolServices.EnumProjectUnits(EnumProc: TProjectEnumProc;Param: Pointer):Boolean;
Var t:LongInt;
    FileName:STRING;
    s,Dir,Name,Ext:String;
    Dir1,Name1,Ext1:String;
    t1:Longint;
    FormItem:PFormListItem;
    FormName:String;
BEGIN
     For t:=0 To GetUnitCount-1 Do
     Begin
       s:=GetUnitName(t);
       FSplit(s,Dir,Name,Ext);
       FileName := Name;
       UpcaseStr(Name);
       FormName:='';
       For t1:=0 To Project.Forms.Count-1 Do
       Begin
           FormItem:=Project.Forms[t1];
           FSplit(FormItem^.UnitName,Dir1,Name1,Ext1);
           UpcaseStr(Name1);
           If Name=Name1 Then
           Begin
               FormName:=FormItem^.FormName;
               break;
           End;
       End;
       EnumProc(Param,s,FileName,FormName);
     End;
     result:=True;
END;

FUNCTION TIIDEToolServices.GetPrimaryFile:STRING;
BEGIN
    result:=Project.Settings.Primary;
END;

PROCEDURE TIIDEToolServices.GetProjectFiles(AStrings:TStrings);

  PROCEDURE AddList(List:TProjectFiles);
  VAR t:LONGINT;
      Sub:PProjectFile;
  BEGIN
       FOR t:=0 TO List.Count-1 DO
       BEGIN
            IF List[t] <> DependenciesString THEN
            BEGIN
                 AStrings.Add(List[t]);
                 Sub:=POINTER(List.Objects[t]);
                 IF Sub<>NIL THEN
                   IF Sub^.ASub<>NIL THEN AddList(Sub^.ASub);
            END;
       END;
  END;
BEGIN
     AStrings.Clear;
     AddList(Project.Files);
END;

//Return number of available forms in current project
FUNCTION TIIDEToolServices.GetFormCount:LONGINT;
BEGIN
     Result := Project.Forms.Count;
END;

//Get name of form with specified index
FUNCTION TIIDEToolServices.GetFormName(Index:LONGINT):STRING;
VAR  FormItem:PFormListItem;
BEGIN
     Result := '';
     IF (Index < 0) OR (Index >= Project.Forms.Count) THEN exit;

     FormItem := PFormListItem(Project.Forms[Index]);
     IF FormItem <> NIL THEN Result := FormItem^.FormName;
END;

//Get full name of current file or form-unit-file, empty string if no file is active
FUNCTION TIIDEToolServices.GetCurrentFile:STRING; {nur fr Editor Files}
VAR  Edit:TEditor;
BEGIN
     Result := '';
     Edit := CodeEditor.TopEditor;
     IF Edit <> NIL THEN Result := Edit.FileName;
END;

//returns TRUE if specified file is open
FUNCTION TIIDEToolServices.IsFileOpen(CONST FileName:STRING):Boolean; {nur fr Editor Files}
BEGIN
     Result := GetEditor(FileName) <> NIL;
END;

//Generate new unit name and file name
FUNCTION TIIDEToolServices.GetNewModuleName(VAR UnitIdent,FileName:STRING):Boolean;
BEGIN
     UnitIdent := GetUniqueFileName('','Unit',1,'.pas');
     Result := UnitIdent<>'';
     GetDir(0,FileName);
     FileName := FileName+'\'+UnitIdent;
END;

//Get Count of currently installed component modules (units)
FUNCTION TIIDEToolServices.GetModuleCount:LONGINT;
BEGIN
     result:=0;
     //?????????????????????????????????????
END;

//Get component unit name with specified index
FUNCTION TIIDEToolServices.GetModuleName(Index:LONGINT):STRING;
BEGIN
     result:='';
     //???????????????????????????????????
END;

//Get component count of component unit with specified index
FUNCTION TIIDEToolServices.GetComponentCount(Index:LONGINT):LONGINT;
BEGIN
     result:=0;
     //?????????????????????????????????????
END;

//Get component name from component unit with specified index
FUNCTION TIIDEToolServices.GetComponentName(ModIndex,CompIndex:LONGINT):STRING;
BEGIN
     result:='';
     //????????????????????????????????????
END;

//Get Interface for a file or form or both
FUNCTION TIIDEToolServices.GetModuleInterface(CONST FileName:STRING):TIModuleInterface;
VAR s,s1:STRING;
    t:LONGINT;
    FormItem:PFormListItem;
    FFileName:STRING;
    FFormItem:PFormListItem;
BEGIN
     result:=NIL;
     s:=FileName;
     UpcaseStr(s);

     //Look if we find the module within the form list
     FOR t:=0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem:=Project.Forms[t];
          s1:=FormItem^.UnitName;
          UpcaseStr(s1);
          IF s=s1 THEN
          BEGIN
               FFileName:=FileName;
               FFormItem:=FormItem;
               break;
          END;
     END;

     IF FFormItem=NIL THEN //look if we find the module in the files list
     BEGIN
          IF ExistProjectMain(s) THEN
          BEGIN
               FFileName:=FileName;
          END
          ELSE IF ExistProjectUnit(Project.Settings.Primary,s) THEN
          BEGIN
               FFileName:=FileName;
          END;
     END;

     IF FFileName='' THEN exit; //not found !

     result:=TIIDEModuleInterface.Create;
     TIIDEModuleInterface(result).FFileName:=FFileName;
     TIIDEModuleInterface(result).FFormItem:=FFormItem;
END;

//Get Interface for a form and its associated editor file
FUNCTION TIIDEToolServices.GetFormModuleInterface(CONST FormName:STRING):TIModuleInterface;
BEGIN
     result:=NIL;
     //????????????????????????????????????
END;

//Gets IDE main menu
FUNCTION TIIDEToolServices.GetMainMenu:TIMainMenuIntf;
BEGIN
     result:=TIIDEMainMenuIntf.Create;
     TIIDEMainMenuIntf(result).FMenu:=Application.MainForm.Menu;
END;

//Adds a notification proc
FUNCTION TIIDEToolServices.AddNotifier(AddInNotifier:TIAddInNotifier):Boolean;
BEGIN
     IF FNotifyList=NIL THEN FNotifyList.Create;
     FNotifyList.Add(AddInNotifier);
     result:=TRUE;
END;

PROCEDURE TIIDEToolServices.IDEFileNotify(NotifyCode:TFileNotification;CONST FileName:STRING;VAR Cancel:BOOLEAN);
VAR t:LONGINT;
    Notifier:TIAddInNotifier;
BEGIN
     Cancel:=FALSE;
     IF FNotifyList<>NIL THEN FOR t:=0 TO FNotifyList.Count-1 DO
     BEGIN
          Notifier:=FNotifyList[t];
          IF Notifier IS TIAddInNotifier THEN
            Notifier.FileNotification(NotifyCode,FileName,Cancel);
     END;
END;

DESTRUCTOR TIIDEToolServices.Destroy;
BEGIN
     IF FNotifyList<>NIL THEN FNotifyList.Destroy;
     INHERITED Destroy;
END;

//Remove notification proc
FUNCTION TIIDEToolServices.RemoveNotifier(AddInNotifier:TIAddInNotifier):Boolean;
BEGIN
     TRY
        result:=TRUE;
        FNotifyList.Remove(AddInNotifier);
     EXCEPT
        result:=FALSE;
     END;
END;

//Get version of the IDE
FUNCTION TIIDEToolServices.GetVersion:LONGINT;
BEGIN
     result:=$0200;
END;

FUNCTION TIIDEToolServices.GetMainMenuHandle:TMenu;
BEGIN
     result:=Application.MainForm.Menu;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: Menu interfaces                                             บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//Returns Interface for IDE main menu (top level)
FUNCTION TIIDEMainMenuIntf.GetMenuItems: TIMenuItemIntf;
BEGIN
     result:=TIIDEMenuItemIntf.Create;
     TIIDEMenuItemIntf(result).FMenuItem:=FMenu.Items;
END;

//Returns Interface for menu item or submenu with specified name
FUNCTION TIIDEMainMenuIntf.FindMenuItem(CONST MenuName:STRING):TIMenuItemIntf;
VAR t:LONGINT;
    MenuItem:TMenuItem;
BEGIN
     result:=NIL;
     FOR t:=0 TO FMenu.Items.Count-1 DO
     BEGIN
          MenuItem:=FMenu.Items[t];
          IF MenuItem.Caption=MenuName THEN
          BEGIN
               result:=TIIDEMenuItemIntf.Create;
               TIIDEMenuItemIntf(result).FMenuItem:=MenuItem;
               exit;
          END;
     END;
END;

//Destroys menu item associated with the interface, returns FALSE if the item was created by IDE
FUNCTION TIIDEMenuItemIntf.DestroyMenuItem:Boolean;
BEGIN
     result:=TRUE;
     FMenuItem.Destroy;
END;

//Get Index of this item within the menu tree
FUNCTION TIIDEMenuItemIntf.GetIndex:LONGINT;
BEGIN
     result:=0;
     //??????????????????????????????????????????????
END;

//Get count of submenus for this interface
FUNCTION TIIDEMenuItemIntf.GetItemCount:LONGINT;
BEGIN
     result:=FMenuItem.Count;
END;

//Get SubMenu item with specified index
FUNCTION TIIDEMenuItemIntf.GetItem(Index:LONGINT):TIMenuItemIntf;
VAR MenuItem:TMenuItem;
BEGIN
     TRY
           MenuItem:=FMenuItem.Items[Index];
           result:=TIIDEMenuItemIntf.Create;
           TIIDEMenuItemIntf(result).FMenuItem:=MenuItem;
     EXCEPT
           result:=NIL;
     END
END;

//Get internal (!) Name of menu associated with interface, see also GetCaption
FUNCTION TIIDEMenuItemIntf.GetName:STRING;
BEGIN
     result:=FMenuItem.Caption;
END;

//Get Parent interface of item or NIL
FUNCTION TIIDEMenuItemIntf.GetParent: TIMenuItemIntf;
BEGIN
     result:=NIL;
     IF FMenuItem.Parent<>NIL THEN
     BEGIN
          result:=TIIDEMenuItemIntf.Create;
          TIIDEMenuItemIntf(result).FMenuItem:=FMenuItem.Parent;
     END;
END;

//Get Caption of menu associated with the interface
FUNCTION TIIDEMenuItemIntf.GetCaption:STRING;
BEGIN
     result:=FMenuItem.Caption;
END;

//Set Caption of menu associated with the interface
FUNCTION TIIDEMenuItemIntf.SetCaption(CONST Caption:STRING):Boolean;
BEGIN
     FMenuItem.Caption:=Caption;
     result:=TRUE;
END;

//get ShortCut of menu
FUNCTION TIIDEMenuItemIntf.GetShortCut:TKeyCode;
BEGIN
     result:=FMenuItem.ShortCut;
END;

//set ShortCut of menu
FUNCTION TIIDEMenuItemIntf.SetShortCut(ShortCut:TKeyCode):Boolean;
BEGIN
     FMenuItem.ShortCut:=ShortCut;
     result:=TRUE;
END;

//Get Flags of menu
FUNCTION TIIDEMenuItemIntf.GetFlags:TIMenuFlags;
BEGIN
     result:=[mfInvalid];
     //?????????????????????????????????????????
END;

//Set Flags of menu
FUNCTION TIIDEMenuItemIntf.SetFlags(Mask,Flags: TIMenuFlags):Boolean;
BEGIN
     result:=FALSE;
     //????????????????????????????????????????
END;

//Get Hint of menu
FUNCTION TIIDEMenuItemIntf.GetHint:STRING;
BEGIN
     result:=FMenuItem.Hint;
END;

//Set Hint of menu
FUNCTION TIIDEMenuItemIntf.SetHint(Hint:STRING):Boolean;
BEGIN
     FMenuItem.Hint:=Hint;
     result:=TRUE;
END;

//Get Help context of Menu
FUNCTION TIIDEMenuItemIntf.GetContext:THelpContext;
BEGIN
  result:=FMenuItem.HelpContext;
END;

//Set Help context for Menu
FUNCTION TIIDEMenuItemIntf.SetContext(Context:THelpContext):Boolean;
BEGIN
     FMenuItem.HelpContext:=Context;
     result:=TRUE;
END;

//Get OnClick event for the menu
FUNCTION TIIDEMenuItemIntf.GetOnClick:TIMenuClickEvent;
BEGIN
     //???????????????????????????????????
END;

//Set OnClick event for the menu
FUNCTION TIIDEMenuItemIntf.SetOnClick(Click:TIMenuClickEvent):Boolean;
BEGIN
     result:=FALSE;
     //???????????????????????????????????
END;

//Inserts an item
FUNCTION TIIDEMenuItemIntf.InsertItem(Index:LONGINT;Caption,Name,Hint:STRING;
                                      ShortCut:TKeyCode;Context:THelpContext;Flags:TIMenuFlags;
                                      EventHandler:TIMenuClickEvent):TIMenuItemIntf;
BEGIN
     result:=NIL;
     //???????????????????????????????????
END;

//Get Menu item associates with the interface
FUNCTION TIIDEMenuItemIntf.GetMenuEntry:TMenuItem;
BEGIN
     result:=FMenuItem;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: Module interfaces                                           บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//Get editor interface for the module or NIL
FUNCTION TIIDEModuleInterface.GetEditorInterface:TIEditorInterface;
BEGIN
     result:=NIL;
     //?????????????????????????????????????????
END;

//Get Form interface for the module or NIL
FUNCTION TIIDEModuleInterface.GetFormInterface:TIFormInterface;
BEGIN
     result:=NIL;
     IF FFormItem=NIL THEN exit;
     result:=TIIDEFormInterface.Create;
     TIIDEFormInterface(result).FFormItem:=FFormItem;
END;

//Close the module without Saving (see Save)
FUNCTION TIIDEModuleInterface.Close:Boolean;
BEGIN
     result:=FALSE;
     //?????????????????????????????????????????
END;

//Saves the module, if forcesave is TRUE, the user will not be asked
FUNCTION TIIDEModuleInterface.Save(ForceSave: Boolean):Boolean;
BEGIN
     result:=FALSE;
     //?????????????????????????????????
END;

//Rename module
FUNCTION TIIDEModuleInterface.Rename(CONST NewName:STRING):Boolean;
BEGIN
     result:=FALSE;
     //???????????????????????????????
END;

//Show source file of editor in topmost editor window
FUNCTION TIIDEModuleInterface.ShowSource:Boolean;
VAR Editor:TSibEditor;
BEGIN
     Editor:=GetEditor(FFileName);
     IF Editor<>NIL THEN
     BEGIN
          Editor.Show;
          result:=Editor.Visible;
     END
     ELSE result:=FALSE;
END;

//Show Form of module if present
FUNCTION TIIDEModuleInterface.ShowForm:Boolean;
BEGIN
     TControl(FFormItem^.Form).Show;
     result:=TControl(FFormItem^.Form).Visible;
END;

//Add notification proc
FUNCTION TIIDEModuleInterface.AddNotifier(AModuleNotifier:TIModuleNotifier):Boolean;
BEGIN
     result:=FALSE;
     //??????????????????????????????
END;

//Remove notification proc
FUNCTION TIIDEModuleInterface.RemoveNotifier(AModuleNotifier:TIModuleNotifier):Boolean;
BEGIN
     result:=FALSE;
     //??????????????????????????????
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: Editor interfaces                                           บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//Gets text at specified position
FUNCTION TIIDEEditorInterface.GetText(Position:Longint;VAR Buffer;BufSize:Longint):Longint;
BEGIN
     result:=0;
     //???????????????????????????????????????????
END;

//Copies text from actual position to Pos into the clipboard
FUNCTION TIIDEEditorInterface.CopyTo(Pos:Longint):Boolean;
BEGIN
     result:=FALSE;
     //????????????????????????????????????????????
END;

//Deletes text from actual positon to Pos into the clipboard
FUNCTION TIIDEEditorInterface.DeleteTo(Pos:Longint):Boolean;
BEGIN
     result:=FALSE;
     //????????????????????????????????????????????
END;

//Insert specified text at current position
FUNCTION TIIDEEditorInterface.Insert(VAR Buffer;BufSize:LONGINT):Boolean;
BEGIN
     result:=FALSE;
     //????????????????????????????????????????
END;

//Get editor position
FUNCTION TIIDEEditorInterface.Position: Longint;
BEGIN
     result:=0;
     //?????????????????????????????????
END;

//Get File Name of editor
FUNCTION TIIDEEditorInterface.FileName:STRING;
BEGIN
     result:=FEditor.FileName;
END;

//Get total lines of edit buffer
FUNCTION TIIDEEditorInterface.LinesInBuffer:LONGINT;
BEGIN
     result:=0;
     //?????????????????????????????????
END;

//returns TRUE if edit buffer was modified
FUNCTION TIIDEEditorInterface.BufferModified:Boolean;
BEGIN
     result:=FEditor.Modified;
END;

//Forces the editor to be modified
FUNCTION TIIDEEditorInterface.MarkModified:Boolean;
BEGIN
     FEditor.Modified:=TRUE;
     result:=TRUE;
END;

//Sets color table
FUNCTION TIIDEEditorInterface.SetSyntaxHighlighter(SyntaxHighlighter:TSyntaxHighlighter):TSyntaxHighlighter;
BEGIN
     result:=shNone;
     //???????????????????????????????????????????
END;

//Get editor position
FUNCTION TIIDEEditorInterface.GetPos:TEditPos;
BEGIN
     result.Col:=0;
     result.Line:=0;
     //????????????????????????????????????
END;

//Set editor positon
PROCEDURE TIIDEEditorInterface.SetPos(Value: TEditPos);
BEGIN
     //????????????????????????????????????
END;

//Get editor form instance - use with care !
FUNCTION TIIDEEditorInterface.GetEditorForm:TEditor;
BEGIN
     result:=NIL;
     //??????????????????????????????????
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: Form interfaces                                             บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//returns unit file name for the form
FUNCTION TIIDEFormInterface.FileName:STRING;
BEGIN
     result:=FFormItem^.UnitName;
END;

//returns TRUE if the form is modified
FUNCTION TIIDEFormInterface.FormModified:Boolean;
BEGIN
     result:=FALSE;
     //???????????????????????????????????
END;

//Forces the form to be marked as modified
FUNCTION TIIDEFormInterface.MarkModified:Boolean;
BEGIN
     result:=FALSE;
     //???????????????????????????????
END;

//Get component interface for the form
FUNCTION TIIDEFormInterface.GetFormComponent:TIComponentInterface;
BEGIN
     result:=TIIDEComponentInterface.Create;
     TIIDEComponentInterface(result).Component:=FFormItem^.Form;
END;

//Get Form instance for the form - use with care !
FUNCTION TIIDEFormInterface.GetFormInstance:TForm;
BEGIN
     result:=TForm(FFormItem^.Form);
END;

//Find component by name and return interface
FUNCTION TIIDEFormInterface.FindComponent(CONST Name:STRING):TIComponentInterface;
VAR t:LONGINT;
    Component:TComponent;
BEGIN
     result:=NIL;
     FOR t:=0 TO FFormItem^.Form.ComponentCount-1 DO
     BEGIN
          Component:=FFormItem^.Form.Components[t];
          IF Component IS TComponent THEN
            IF Component.Name=Name THEN
            BEGIN
                 result:=TIIDEComponentInterface.Create;
                 TIIDEComponentInterface(result).Component:=Component;
                 exit;
            END;
     END;
END;

//Get component interface from instance
FUNCTION TIIDEFormInterface.GetComponentFromHandle(ComponentHandle:TObject):TIComponentInterface;
VAR t:LONGINT;
    Component:TComponent;
BEGIN
     result:=NIL;
     FOR t:=0 TO FFormItem^.Form.ComponentCount-1 DO
     BEGIN
          Component:=FFormItem^.Form.Components[t];
          IF TObject(Component)=ComponentHandle THEN
            BEGIN
                 result:=TIIDEComponentInterface.Create;
                 TIIDEComponentInterface(result).Component:=Component;
                 exit;
            END;
     END;
END;

//Get Selection Count in form editor
FUNCTION TIIDEFormInterface.GetSelCount:LONGINT;
BEGIN
     result:=0;
     //?????????????????????????????????
END;

//Get selected component interface from index
FUNCTION TIIDEFormInterface.GetSelComponent(Index:LONGINT):TIComponentInterface;
BEGIN
     result:=NIL;
     //??????????????????????????????????
END;

//Gets parent interface that created the form
FUNCTION TIIDEFormInterface.GetCreateParent: TIComponentInterface;
BEGIN
     result:=NIL;
     IF FFormItem^.Form.Owner<>NIL THEN
     BEGIN
          result:=TIIDEComponentInterface.Create;
          TIIDEComponentInterface(result).Component:=TComponent(FFormItem^.Form.Owner);
     END;
END;

//Create new component, if containter is not nil, it is the parent, if name is empty, it is auto-created
FUNCTION TIIDEFormInterface.CreateComponent(Container: TIComponentInterface;CONST TypeName,Name:STRING;
                                            X,Y,W,H:LONGINT):TIComponentInterface;
VAR ComponentClass:TComponentClass;
    AComponent:TComponent;
    Owner:TComponent;
    MenuItem:TMenuItem;
    Reference:TSpeedButton;
BEGIN
     result:=NIL;
     IF Container=NIL THEN Owner:=NIL
     ELSE Owner:=TIIDEComponentInterface(Container).Component;
     ComponentClass:=SearchClassByName(TypeName);
     IF ComponentClass=NIL THEN exit;
     AComponent:=ComponentClass.Create(Owner);

     IF AComponent IS TMenuItem THEN
     BEGIN
          IF Owner IS TMenu THEN TMenu(Owner).Items.Add(TMenuItem(AComponent))
          ELSE IF Owner IS TMenuItem THEN TMenuItem(Owner).Add(TMenuItem(AComponent));
     END;

     AComponent.Name:=Name;
     IF AComponent IS TControl THEN
      IF not (AComponent IS TForm) THEN TControl(AComponent).SetWindowPos(X,Y,W,H);

     IF Owner IS TControl THEN
     BEGIN
          IF ((AComponent IS TControl)AND
              (not (AComponent IS TForm))) THEN TControl(Owner).InsertControl(TControl(AComponent))
          ELSE
          BEGIN
               Reference:=CreateReferenceProc(Owner,AComponent);
               Reference.Left:=X;
               Reference.Bottom:=Y;
               TControl(Owner).InsertControl(Reference);
               IF TMainMenu(AComponent) IS TMainMenu THEN
                IF Owner IS TForm THEN
                  IF TForm(Owner).Menu=NIL THEN
                    TForm(Owner).Menu:=TMainMenu(AComponent);
          END;
     END;

     IF AComponent.Owner IS TControl THEN GenNewComponent(Owner,AComponent);

     result:=TIIDEComponentInterface.Create;
     TIIDEComponentInterface(Result).Component:=AComponent;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: Component interfaces                                        บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

//Returns component type as string
FUNCTION TIIDEComponentInterface.GetComponentType:STRING;
BEGIN
     result:=Component.TypeName;
END;

//Returns Component Instance - use with care !
FUNCTION TIIDEComponentInterface.GetComponentHandle:TComponent;
BEGIN
     result:=Component;
END;

//Returns Parent interface
FUNCTION TIIDEComponentInterface.GetParent:TIComponentInterface;
BEGIN
     result:=NIL;
     IF Component.Owner<>NIL THEN
     BEGIN
          result:=TIIDEComponentInterface.Create;
          TIIDEComponentInterface(result).Component:=Component.Owner;
     END;
END;

//Returns TRUE if interface is a descendant of TControl
FUNCTION TIIDEComponentInterface.IsTControl:Boolean;
BEGIN
     result:=Component IS TControl;
END;

//Returns property count for the interface instance
FUNCTION TIIDEComponentInterface.GetPropCount:LONGINT;
BEGIN
     result:=0;
     //???????????????????????????????????
END;

//Get property name from Index
FUNCTION TIIDEComponentInterface.GetPropName(Index:LONGINT):STRING;
BEGIN
     result:='';
     //???????????????????????????????????
END;

//Get property type from Index
FUNCTION TIIDEComponentInterface.GetPropType(Index:LONGINT;VAR TypeLen:LONGINT):TPropertyType;
BEGIN
     result:=ptUnknown;
     TypeLen:=0;
     //??????????????????????????????????????????????????????
END;

//Get property type from Name
FUNCTION TIIDEComponentInterface.GetPropTypeByName(CONST Name:STRING;VAR TypeLen:LONGINT):TPropertyType;
VAR Info:TPropertyTypeInfo;
BEGIN
     result:=ptUnknown;
     TypeLen:=0;
     IF Component.GetPropertyTypeInfo(Name,Info) THEN
     BEGIN
          TypeLen:=Info.Size;
          CASE Info.Typ OF
              PropType_Unsigned,PropType_Signed:result:=ptInteger;
              PropType_Float:result:=ptFloat;
              PropType_Class:result:=ptClass;
              PropType_String:result:=ptString;
              PropType_Enum:result:=ptEnumeration;
              PropType_Set:result:=ptSet;
              PropType_Boolean:result:=ptBoolean;
              PropType_Char:result:=ptChar;
              PropType_CString:result:=ptCString;
              PropType_ClassVar:result:=ptClassRef;
              PropType_ProcVar,PropType_FuncVar:result:=ptMethod;
              PropType_Record:result:=ptRecord;
          END; {case}
     END;
END;

//Gets Property value from index
FUNCTION TIIDEComponentInterface.GetPropValue(Index:LONGINT;VAR Value):Boolean;
BEGIN
     result:=FALSE;
     //??????????????????????????????????????????????????????
END;

//Gets Property value from name
FUNCTION TIIDEComponentInterface.GetPropValueByName(CONST Name:STRING;VAR Value):Boolean;
VAR Info:TPropertyTypeInfo;
    p:Pointer;
BEGIN
     result:=FALSE;
     IF Component.GetPropertyTypeInfo(Name,Info) THEN
     BEGIN
          CASE Info.Read.Kind OF
             1:
             BEGIN
                  result:=TRUE;
                  p:=pointer(Component);
                  inc(p,longword(Info.Read.VarOffset));
                  move(p^,Value,Info.Size);
             END;
             2,3:result:=CallReadProp(Component,Pointer(Info.Read.VarOffset),Info.Typ,Info.Size,@Value);
          END; {case}
     END;
END;

//Sets property from index
FUNCTION TIIDEComponentInterface.SetProp(Index:LONGINT;CONST Value):Boolean;
BEGIN
     result:=FALSE;
     //????????????????????????????????????????????????
END;

//Sets property from name
FUNCTION TIIDEComponentInterface.SetPropByName(CONST Name:STRING;CONST Value):Boolean;
VAR Info:TPropertyTypeInfo;
    p:Pointer;
BEGIN
     result:=FALSE;
     result:=FALSE;
     IF Component.GetPropertyTypeInfo(Name,Info) THEN
     BEGIN
          CASE Info.Write.Kind OF
             1:
             BEGIN
                  result:=TRUE;
                  p:=pointer(Component);
                  inc(p,longword(Info.Write.VarOffset));
                  move(Value,p^,Info.Size);
             END;
             2,3:result:=CallWriteProp(Component,Pointer(Info.Write.VarOffset),Info.Typ,Info.Size,@Value);
          END; {case}
     END;
END;

//Enums component's children
FUNCTION TIIDEComponentInterface.GetChildren(Param:Pointer;Proc:TGetChildCallback): Boolean;
BEGIN
     result:=FALSE;
     //???????????????????????????????????????????????
END;

//Get count of child controls
FUNCTION TIIDEComponentInterface.GetControlCount:LONGINT;
VAR t:LONGINT;
BEGIN
     Result := 0;
     IF Component IS TControl
       THEN Result := TControl(Component).ControlCount;
END;

//Get control from index
FUNCTION TIIDEComponentInterface.GetControl(Index:LONGINT):TIComponentInterface;
VAR  Ctrl:TControl;
BEGIN
     Result := NIL;
     IF Component IS TControl THEN
     BEGIN
          Ctrl := TControl(Component).Controls[Index];
          IF Ctrl <> NIL THEN
          BEGIN
               Result := TIIDEComponentInterface.Create;
               TIIDEComponentInterface(Result).Component := Ctrl;
          END;
     END;
END;

//Get count of child components
FUNCTION TIIDEComponentInterface.GetComponentCount:LONGINT;
BEGIN
     result:=Component.ComponentCount;
END;

//Get child component from index
FUNCTION TIIDEComponentInterface.GetComponent(Index:LONGINT):TIComponentInterface;
BEGIN
     result:=NIL;
     IF ((Index>0)AND(Index<Component.ComponentCount)) THEN
     BEGIN
          result:=TIIDEComponentInterface.Create;
          TIIDEComponentInterface(result).Component:=Component.Components[Index];
     END;
END;

//Select component
FUNCTION TIIDEComponentInterface.Select: Boolean;
BEGIN
     result:=FALSE;
     //???????????????????????????????????????????
END;

//Focus component
FUNCTION TIIDEComponentInterface.Focus: Boolean;
BEGIN
     result:=FALSE;
     IF Component IS TControl THEN
     BEGIN
          TControl(Component).Focus;
          result:=TRUE;
     END;
END;

//Delete component
FUNCTION TIIDEComponentInterface.Delete: Boolean;
BEGIN
     result:=FALSE;
     //????????????????????????????????????????
END;

FUNCTION TIIDEComponentInterface.SetEventProperty(CONST PropertyName,MethodName:STRING;Code:TStream):BOOLEAN;
VAR List:TStringList;
    Meth,Last:PIDE_Methods;
    s,s1,s2,s3,Params:STRING;
    t:LONGINT;
    Own:PIDE_OwnerList;
    Info:TPropertyTypeInfo;
    p1:^LONGINT;
    b:LONGINT;
    ps:^STRING;
    ComponentOwner:TForm;
BEGIN
     result:=FALSE;

     ComponentOwner:=TForm(Component.Owner);
     WHILE not (ComponentOwner IS TForm) DO
     BEGIN
          ComponentOwner:=TForm(ComponentOwner.Owner);
          IF ComponentOwner=NIL THEN exit;
     END;

     IF ComponentOwner=NIL THEN exit
     ELSE
     BEGIN
         s:=MethodName;
         UpcaseStr(s);
         s1:=PropertyName;
         UpcaseStr(s);
         Meth:=ComponentOwner.Methods;
         Last:=NIL;
         WHILE Meth<>NIL DO
         BEGIN
              s2:=Meth^.Name^;
              UpcaseStr(s2);
              IF s=s2 THEN
              BEGIN
                   //Method Names match, check parameters
                   new(Own);
                   AssignStr(Own^.PropertyName,PropertyName);
                   Own^.Objekt:=TComponent(Component);
                   Meth^.Owners.Add(Own);
                   exit;
              END
              ELSE //Method names do not match
              BEGIN
                   FOR t:=0 TO Meth^.Owners.Count-1 DO
                   BEGIN
                        Own:=Meth^.Owners.Items[t];
                        s3:=Own^.PropertyName^;
                        UpcaseStr(s3);
                        //Object method exists with same parent ??
                        IF s3=s1 THEN
                         IF Own^.Objekt=Component THEN exit;
                   END;
              END;

              Last:=Meth;
              Meth:=Meth^.Next;
         END;

         IF Last=NIL THEN
         BEGIN
             new(Last);
             ComponentOwner.Methods:=Last;
         END
         ELSE
         BEGIN
             new(Last^.Next);
             Last:=Last^.Next;
         END;

         IF not Component.GetPropertyTypeInfo(PropertyName,Info) THEN exit;
         IF not (Info.Typ IN [PropType_ProcVar,PropType_FuncVar]) THEN exit;

         p1:=Info.TypeInfo;
         inc(p1);
         b:=p1^;
         inc(p1,4);  //Name (Index)
         Params:='';
         WHILE b<>0 DO
         BEGIN
             IF Params<>'' THEN Params:=Params+';';
             ps:=Info.NameTable+b;
             s1:=ps^;

             b:=p1^ AND 255;
             inc(p1);
             CASE b OF
                1:s1:=Key(_VAR_)+' '+s1;
                2:;
                3:s1:=Key(_CONST_)+' '+s1;
             END;

             Params:=Params+s1;
             b:=p1^;         //TypeName
             inc(p1,4);      //Name (Index)
             IF b<>0 THEN
             BEGIN
                ps:=Info.NameTable+b;
                s1:=ps^;
                Params:=Params+':'+s1;
             END;

             b:=p1^;
             inc(p1,4);  //Name (Index)
         END; //while

         IF Params<>'' THEN Params:='('+Params+');'
         ELSE Params:=';';

         AssignStr(Last^.Name,MethodName);
         AssignStr(Last^.Params,Params);
         Last^.Owners.Create;

         New(Own);
         AssignStr(Own^.PropertyName,PropertyName);
         Own^.Objekt:=TComponent(Component);
         Last^.Owners.Add(Own);
         Last^.Next:=NIL;

         List.Create;
         IF Code<>NIL THEN
         BEGIN
             Code.Position:=0;
             List.LoadFromStream(Code);
         END
         ELSE
         BEGIN
             List.Add(Key(_BEGIN_));
             List.Add(Key(_END_)+';');
         END;
         result:=GenNewProc(ComponentOwner,MethodName+Params,List);
         List.Destroy;
     END;
END;

FUNCTION TIIDEComponentInterface.GetEventProperty(CONST PropertyName:STRING):STRING;
BEGIN
     //?????????????????????????????????????????????????
     result:='';
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: IDE repository handling                                     บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TRepFlags=(rfNewForm,rfNewProject,rfMainForm);

TYPE TRepositoryDialog=CLASS(TDialog)
         PagesListBox:TListBox;
         ObjectsListBox:TBitmapListBox;
         NewPageButton,DeletePageButton,RenameButton,EditButton,DeleteObjButton:TBitBtn;
         MainForm,NewForm,NewProject:TCheckBox;
         RepForms:TList;
         Objects:TList;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE PageItemFocused(Sender:TObject;Index:LONGINT);
         PROCEDURE ObjItemFocused(Sender:TObject;Index:LONGINT);
         PROCEDURE AddObject(Obj:PRepositoryObject);
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE ObjectCanDrag(Sender:TObject;X,Y:LONGINT;VAR Accept:BOOLEAN);
         PROCEDURE PageDragOver(Sender:TObject;Source:TObject;X,Y:LONGINT;State:TDragState;
                                VAR Accept:BOOLEAN);
         PROCEDURE PageDragDrop(Sender:TObject;Source:TObject;X,Y:LONGINT);
         FUNCTION FindPage(CONST s:STRING):PRepositoryPage;
         FUNCTION FindObject(Page:PRepositoryPage;CONST s:STRING):PRepositoryObject;
         FUNCTION FindRepForm(Flag:TRepFlags;Clear:BOOLEAN;
                              CONST Page,Name:STRING):PRepForm;
         PROCEDURE CheckBoxChecked(Sender:TObject);
         DESTRUCTOR Destroy;OVERRIDE;
     END;

     TEditObjDlg=CLASS(TDialog)
         Title:TEdit;
         Description:TMemo;
         Author:TEdit;
         Obj:PRepositoryObject;
         IconIsNew:BOOLEAN;
         Form:PRepForm;
         FIcon:TBitmap;
         FImage:TImage;
         Desc:PChar;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE OkClicked(Sender:TObject);
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE BrowseBtnClick(Sender:TObject);
     END;


DESTRUCTOR TEditObjDlg.Destroy;
BEGIN
     IF FIcon<>NIL THEN FIcon.Destroy;

     Inherited Destroy;
END;

PROCEDURE TEditObjDlg.OkClicked(Sender:TObject);
BEGIN
     Desc := Description.Lines.GetText;
END;

PROCEDURE TEditObjDlg.SetupComponent;
VAR  Button:TBitBtn;
BEGIN
     Inherited SetupComponent;
     Caption:=LoadNLSStr(SiEditRepositoryObject);
     Width:=400;
     Height:=330;

     InsertGroupBox(SELF,10,50,370,240,'');

     InsertLabelNLS(SELF,20,265,350,20,SiTitle);
     Title:=InsertEdit(SELF,20,245,350,20,'','');

     InsertLabelNLS(SELF,20,220,350,20,SiDescription);
     Description:=InsertMemo(SELF,20,160,350,60,'');

     InsertLabelNLS(SELF,20,135,350,20,SiAuthor);
     Author:=InsertEdit(SELF,20,115,350,20,'','');

     Button:=InsertBitBtnNLS(SELF,11,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     Button.OnClick:=OkClicked;
     InsertBitBtnNLS(SELF,106,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,201,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

PROCEDURE TEditObjDlg.BrowseBtnClick(Sender:TObject);
VAR FileDlg:TOpenDialog;
    ret:BOOLEAN;
    s:STRING;
    Bitmap:TBitmap;
BEGIN
     FileDlg.Create(SELF);
     FileDlg.HelpContext := hctxDialogOpenObjectBitmap;
     FileDlg.Title:=LoadNLSStr(SiSelectABitmap);
     FileDlg.AddFilter(LoadNLSStr(SiBitmapFiles)+' (*.bmp)','*.BMP');
     FileDlg.FileName:='*.BMP';
     FileDlg.DefaultExt := 'BMP';
     ret := FileDlg.Execute;
     s := FileDlg.FileName;
     FileDlg.Destroy;

     IF ret THEN
     BEGIN
          Bitmap.Create;
          TRY
             Bitmap.LoadFromFile(s);
          EXCEPT
             Bitmap.Destroy;
             Bitmap:=NIL;
             ErrorBox(LoadNLSStr(SiInvalidBitmapFile));
          END;
          IF Bitmap<>NIL THEN
          BEGIN
               IF ((Bitmap.Width<>32)OR(Bitmap.Height<>32)) THEN
               BEGIN
                    Bitmap.Destroy;
                    ErrorBox(LoadNLSStr(SiBitmapMustBe32x32));
               END
               ELSE
               BEGIN
                   IF FIcon<>NIL THEN FIcon.Destroy;
                   IconIsNew:=TRUE;
                   FIcon:=Bitmap;
                   FImage.Bitmap:=FIcon;
               END;
          END;
     END;
END;

PROCEDURE TEditObjDlg.SetupShow;
VAR  cs:CSTRING;
     Button:TBitBtn;
     Lab:TLabel;
BEGIN
     Inherited SetupShow;
     IF Obj<>NIL THEN
     BEGIN
          Title.Caption:=Obj^.Title^;
          Author.Caption:=Obj^.Author^;
          Description.Lines.SetText(Obj^.Description);
     END
     ELSE IF Form<>NIL THEN
     BEGIN
          Title.Caption:=Form^.Name;
          Author.Caption:=Form^.Author;
          Description.Lines.SetText(Form^.Description);

          FIcon.Create;
          TRY
             FIcon.LoadFromMem(Form^.IconInfo^,Form^.IconLen);
          EXCEPT
             FIcon.Destroy;
             FIcon:=NIL;
          END;

          FImage.Create(SELF);
          FImage.SetWindowPos(20,70,32,32);
          FImage.ZOrder:=zoTop;
          FImage.Bitmap:=FIcon;
          FImage.Parent:=SELF;
          Lab := InsertLabelNLS(SELF,160,60,210,50,SiSelectABMP);
          Lab.WordWrap := TRUE;
          Lab.AutoSize := FALSE;
          Button:=InsertBitBtnNLS(SELF,70,60,80,30,bkCustom,SiBrowse,0);
          Button.OnClick:=BrowseBtnClick;
     END;
END;

FUNCTION TRepositoryDialog.FindPage(CONST s:STRING):PRepositoryPage;
VAR t:LONGINT;
BEGIN
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          result:=Repository.Items[t];
          IF result^.PageInstalled THEN IF result^.Page^=s THEN exit;
     END;
     result:=NIL;
END;

FUNCTION TRepositoryDialog.FindObject(Page:PRepositoryPage;CONST s:STRING):PRepositoryObject;
VAR t:LONGINT;
BEGIN
     FOR t:=0 TO Page^.Objects.Count-1 DO
     BEGIN
          result:=Page^.Objects.Items[t];
          IF result^.InstalledInPage THEN IF result^.Title^=s THEN exit;
     END;
     result:=NIL;
END;

PROCEDURE SetRepositoryFlag(Flag:TRepFlags;CONST Id:STRING);
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
    s:STRING;
BEGIN
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               s:=Obj^.IDName^;
               UpcaseStr(s);
               IF s=id THEN
               BEGIN
                    CASE Flag OF
                        rfNewForm:Obj^.NewForm:=TRUE;
                        rfNewProject:Obj^.NewProject:=TRUE;
                        rfMainForm:Obj^.MainForm:=TRUE;
                    END; //case
               END
               ELSE
               BEGIN
                    CASE Flag OF
                        rfNewForm:Obj^.NewForm:=FALSE;
                        rfNewProject:Obj^.NewProject:=FALSE;
                        rfMainForm:Obj^.MainForm:=FALSE;
                    END; //case
               END;
          END;
     END;
END;

PROCEDURE ClearRepositoryFlag(Flag:TRepFlags);
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
BEGIN
     For t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               CASE Flag OF
                   rfNewForm:Obj^.NewForm:=FALSE;
                   rfNewProject:Obj^.NewProject:=FALSE;
                   rfMainForm:Obj^.MainForm:=FALSE;
               END; //case
          END;
     END;
END;

FUNCTION TRepositoryDialog.FindRepForm(Flag:TRepFlags;Clear:BOOLEAN;
                                       CONST Page,Name:STRING):PRepForm;
VAR t:LONGINT;
    Res:PRepForm;
BEGIN
    Result:=NIL;
    FOR t:=0 To RepForms.Count-1 Do
    BEGIN
        Res:=RepForms[t];
        IF Clear THEN
        BEGIN
             IF Flag=rfNewForm THEN Res^.NewForm:=FALSE
             ELSE IF Flag=rfMainForm THEN Res^.MainForm:=FALSE;
        END;
        IF Res^.Page=Page THEN IF Res^.Name=Name THEN Result:=Res;
    END;
END;

PROCEDURE TRepositoryDialog.CheckBoxChecked(Sender:TObject);
VAR Flag:TRepFlags;
    Check:TCheckBox;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
    s:STRING;
    IsChecked:BOOLEAN;
    RepForm:PRepForm;
LABEL CheckRep;
BEGIN
     Check:=TCheckBox(Sender);
     IF Check=NewForm THEN Flag:=rfNewForm
     ELSE IF Check=MainForm THEN Flag:=rfMainForm
     ELSE IF Check=NewProject THEN Flag:=rfNewProject
     ELSE exit;

     IsChecked:= Check.Checked;

     IF ((PagesListBox.ItemIndex=-1)OR(ObjectsListBox.ItemIndex=-1)) THEN exit;
     Page:=FindPage(PagesListBox.Items.Strings[PagesListBox.ItemIndex]);
     IF Page=NIL THEN
     BEGIN
CheckRep:
          IF Flag=rfNewProject THEN exit;
          RepForm:=FindRepForm(Flag,TRUE,PagesListBox.Items.Strings[PagesListBox.ItemIndex],
                               ObjectsListBox.Items.Strings[ObjectsListBox.ItemIndex]);
          IF RepForm=Nil THEN exit;
          IF Flag=rfMainForm THEN RepForm^.MainForm:=IsChecked
          ELSE RepForm^.NewForm:=IsChecked;
          //This call will set all other items for this flag to FALSE because the empty
          //item will never be found
          SetRepositoryFlag(Flag,'');
          exit;
     END;
     Obj:=FindObject(Page,ObjectsListBox.Items.Strings[ObjectsListBox.ItemIndex]);
     IF Obj=NIL THEN goto CheckRep;

     IF IsChecked THEN
     BEGIN
          s:=Obj^.IDName^;
          UpcaseStr(s);
          SetRepositoryFlag(Flag,s);
     END
     ELSE ClearRepositoryFlag(Flag);
END;


PROCEDURE TRepositoryDialog.ObjectCanDrag(Sender:TObject;X,Y:LONGINT;
                                          VAR Accept:BOOLEAN);
VAR Index:LONGINT;
BEGIN
     Index:=ObjectsListBox.ItemAtPos(Point(X,Y),TRUE);
     IF Index<>-1 THEN ObjectsListBox.ItemIndex:=Index;
     Accept:=Index<>-1;
END;

PROCEDURE TRepositoryDialog.PageDragOver(Sender:TObject;Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);
VAR Index:LONGINT;
BEGIN
     IF Source=ObjectsListBox THEN
     BEGIN
          Index:=PagesListBox.ItemAtPos(Point(X,Y),TRUE);
          IF ((Index=PagesListBox.Items.Count-1)OR(Index=PagesListBox.ItemIndex))
            THEN Index:=-1; //not for [Object Repository] and actual
     END
     ELSE Index:=-1;
     Accept:=Index<>-1;
END;

PROCEDURE TRepositoryDialog.PageDragDrop(Sender:TObject;Source:TObject;X,Y:LONGINT);
VAR Index:LONGINT;
    SourcePage:PRepositoryPage;
    SourceDummy,dummy:PRepForm;
    SourceObj:PRepositoryObject;
    TargetPage:PRepositoryPage;
    TargetObj:PRepositoryObject;
BEGIN
     Index:=-1;
     IF Source=ObjectsListBox THEN
     BEGIN
          Index:=PagesListBox.ItemAtPos(Point(X,Y),TRUE);
          IF ((Index=PagesListBox.Items.Count-1)OR(Index=PagesListBox.ItemIndex)) THEN Index:=-1; //not for [Object Repository] and actual
          IF Index<>-1 THEN
          BEGIN
               SourcePage:=FindPage(PagesListBox.Items.Strings[PagesListBox.ItemIndex]);

               SourceObj:=Pointer(Objects[ObjectsListBox.ItemIndex]);
               IF SourceObj=NIL THEN exit;

               IF SourceObj^.Flag=1 THEN //Source is a template form
               BEGIN
                   Sourcedummy:=Pointer(SourceObj);

                   New(dummy);
                   dummy^.Flag:=1;
                   dummy^.Name:=Sourcedummy^.Name;
                   dummy^.Author:=Sourcedummy^.Author;
                   dummy^.Page:=PagesListBox.Items.Strings[Index];
                   dummy^.Description:=StrNew(Sourcedummy^.Description);

                   dummy^.IconLen:=Sourcedummy^.IconLen;
                   GetMem(dummy^.IconInfo,dummy^.IconLen);
                   System.Move(Sourcedummy^.IconInfo^,dummy^.IconInfo^,dummy^.IconLen);

                   dummy^.SCULen:=Sourcedummy^.SCULen;
                   GetMem(dummy^.SCUInfo,dummy^.SCULen);
                   System.Move(Sourcedummy^.SCUInfo^,dummy^.SCUInfo^,dummy^.SCULen);

                   dummy^.EditLen:=Sourcedummy^.EditLen;
                   GetMem(dummy^.EditInfo,dummy^.EditLen);
                   System.Move(Sourcedummy^.EditInfo^,dummy^.EditInfo^,dummy^.EditLen);

                   dummy^.InstalledInPage:=TRUE;
                   dummy^.PageInstalled:=TRUE;
                   dummy^.NewForm:=FALSE;
                   dummy^.MainForm:=FALSE;
                   RepForms.Add(dummy);
                   exit;
               END;

               TargetPage:=FindPage(PagesListBox.Items.Strings[Index]);
               IF TargetPage=NIL THEN
               BEGIN
                    New(TargetPage);
                    TargetPage^.PageInstalled:=TRUE;
                    TargetPage^.Objects.Create;
                    TargetPage^.Page:=NewStr(PagesListBox.Items.Strings[Index]);
               END;

               New(TargetObj);
               TargetObj^:=SourceObj^;
               TargetObj^.IDName := NewStr(SourceObj^.IDName^);
               TargetObj^.Title := NewStr(SourceObj^.Title^);
               TargetObj^.Description := StrNew(SourceObj^.Description);
               TargetObj^.Author := NewStr(SourceObj^.Author^);

               TargetPage^.Objects.Add(TargetObj);
          END;
     END;
END;

PROCEDURE TRepositoryDialog.CommandEvent(VAR Command:TCommand);
VAR EditObjDlg:TEditObjDlg;
    s,s1,s2:STRING;
    Index:LONGINT;
    Obj:PRepositoryObject;
    Page:PRepositoryPage;
    dummy:PRepForm;
    t:LONGINT;
    Memory:TMemoryStream;
    MsgHandled:BOOLEAN;
BEGIN
     MsgHandled:=TRUE;

     CASE Command OF
        cmNew:      //Add page
        BEGIN
             s:='';
             IF InputQuery(LoadNLSStr(SiAddPage),LoadNLSStr(SiEnterNewPageName),s) THEN
             BEGIN
                  s1:=s;
                  UpcaseStr(s1);
                  s2:=LoadNLSStr(SiNewPage);
                  UpcaseStr(s2);
                  IF ((s='')OR(ord(Upcase(s[1]))<ord('A'))OR(s1=s2)OR
                      (ord(Upcase(s[1]))>ord('Z'))) THEN
                  BEGIN
                       ErrorBox(LoadNLSStr(SiIllegalPageName));
                       exit;
                  END;

                  //look if page name already exists
                  s2:=s;
                  UpcaseStr(s2);
                  FOR t:=0 TO Repository.Count-1 DO
                  BEGIN
                       Page:=Repository[t];
                       s1:=Page^.Page^;
                       UpcaseStr(s1);
                       IF s1=s2 THEN
                       BEGIN
                            ErrorBox(LoadNLSStr(SiPageAlreadyUsed));
                            exit;
                       END;
                  END;
                  FOR t:=0 TO RepForms.Count-1 DO
                  BEGIN
                       dummy:=RepForms[t];
                       s1:=dummy^.Page;
                       UpcaseStr(s1);
                       IF s1=s2 THEN
                       BEGIN
                            ErrorBox(LoadNLSStr(SiPageAlreadyUsed));
                            exit;
                       END;
                  END;

                  PagesListBox.Items.Insert(PagesListBox.Items.Count-1,s);
                  new(Page);
                  Page^.Objects.Create;
                  Page^.PageInstalled:=TRUE;
                  Page^.Page:=NewStr(s);
                  Repository.Insert(Repository.Count-1,Page);
                  Project.Modified:=TRUE;
                  IdeSettings.Modified:=TRUE;
             END;
        END;
        cmCut:      //Delete page
        BEGIN
             s:=PagesListBox.Items.Strings[PagesListBox.ItemIndex];
             UpcaseStr(s);

             FOR t:=0 TO Repository.Count-1 DO
             BEGIN
                  Page:=Repository[t];
                  s1:=Page^.Page^;
                  UpcaseStr(s1);
                  IF s=s1 THEN Page^.PageInstalled:=FALSE;
             END;

             FOR t:=0 TO RepForms.Count-1 DO
             BEGIN
                  dummy:=RepForms[t];
                  s1:=dummy^.Page;
                  UpcaseStr(s1);
                  IF s=s1 THEN dummy^.PageInstalled:=FALSE;
             END;

             Project.Modified:=TRUE;
             IdeSettings.Modified:=TRUE;
             PagesListBox.Items.Delete(PagesListBox.ItemIndex);
        END;
        cmReplace:  //Rename page
        BEGIN
             Index:=PagesListBox.ItemIndex;
             IF Index=-1 THEN exit;
             s:=PagesListBox.Items[Index];
             s1:=s;
             UpcaseStr(s1);
             IF InputQuery(LoadNLSStr(SiRenamePage),LoadNLSStr(SiEnterPageName),s) THEN
             BEGIN
                  UpcaseStr(s1);
                  s2:=LoadNLSStr(SiNewPage);
                  UpcaseStr(s2);
                  IF ((s='')OR(ord(Upcase(s[1]))<ord('A'))OR(s1=s2)OR
                      (ord(Upcase(s[1]))>ord('Z'))) THEN
                  BEGIN
                       ErrorBox(LoadNLSStr(SiIllegalPageName));
                       exit;
                  END;

                  PagesListBox.Items[Index]:=s;

                  FOR t:=0 TO Repository.Count-1 DO
                  BEGIN
                       Page:=Repository[t];
                       s2:=Page^.Page^;
                       UpcaseStr(s2);
                       IF s1=s2 THEN
                       BEGIN
                            DisposeStr(Page^.Page);
                            Page^.Page:=NewStr(s);
                            IdeSettings.Modified:=TRUE;
                            Project.Modified:=TRUE;
                       END;
                  END;

                  FOR t:=0 TO RepForms.Count-1 DO
                  BEGIN
                       dummy:=RepForms[t];
                       s2:=dummy^.Page;
                       UpcaseStr(s2);
                       IF s1=s2 THEN dummy^.Page:=s;
                  END;
             END;
        END;
        cmCopy:     //Edit objects
        BEGIN
             Index:=ObjectsListBox.ItemIndex;
             IF Index=-1 THEN exit;
             Obj:=Pointer(Objects[Index]);
             IF Obj=NIL THEN exit;

             IF Obj^.Flag=1 THEN
             BEGIN
                  dummy:=Pointer(Obj);
                  Obj:=NIL;
             END;

             IF dummy<>NIL THEN
             BEGIN
                  EditObjDlg.Create(Application.MainForm);
                  EditObjDlg.HelpContext := hctxDialogEditObject;
                  EditObjDlg.Form:=dummy;

                  IF EditObjDlg.Execute THEN
                  BEGIN
                       IF EditObjDlg.IconIsNew THEN
                       BEGIN
                            //write icon
                            Memory.Create;
                            TRY
                               EditObjDlg.FIcon.SaveToStream(Memory);
                            EXCEPT
                               Memory.Destroy;
                               Memory:=NIL;
                            END;

                            IF Memory<>NIL THEN
                            BEGIN
                                 FreeMem(dummy^.IconInfo,dummy^.IconLen);
                                 dummy^.IconLen:=Memory.Size;
                                 GetMem(dummy^.IconInfo,dummy^.IconLen);
                                 System.Move(Memory.Memory^,dummy^.IconInfo^,dummy^.IconLen);
                                 ObjectsListBox.Bitmaps[Index]:=EditObjDlg.FIcon;
                            END;
                       END;

                       s:=EditObjDlg.Title.Caption;
                       dummy^.Name:=s;
                       ObjectsListBox.Items.Strings[Index]:=s;
                       StrDispose(dummy^.Description);
                       dummy^.Description:=EditObjDlg.Desc;
                       dummy^.Author:=EditObjDlg.Author.Caption;

                       EditObjDlg.Destroy;
                  END
                  ELSE EditObjDlg.Destroy;
             END
             ELSE
             BEGIN
                  EditObjDlg.Create(Application.MainForm);
                  EditObjDlg.HelpContext := hctxDialogEditObject;
                  EditObjDlg.Obj:=Obj;

                  IF EditObjDlg.Execute THEN
                  BEGIN
                       s:=EditObjDlg.Title.Caption;
                       AssignStr(Obj^.Title,s);
                       ObjectsListBox.Items.Strings[Index]:=s;
                       Obj^.Description:=EditObjDlg.Desc;
                       AssignStr(Obj^.Author,EditObjDlg.Author.Caption);

                       EditObjDlg.Destroy;

                       Project.Modified:=TRUE;
                       IdeSettings.Modified:=TRUE;
                  END
                  ELSE EditObjDlg.Destroy;
             END;
        END;
        cmPaste:    //Delete object
        BEGIN
             Index:=ObjectsListBox.ItemIndex;
             IF Index=-1 THEN exit;
             Obj:=Pointer(Objects[Index]);
             IF Obj=NIL THEN exit;

             IF Obj^.Flag=1 THEN
             BEGIN
                  dummy:=Pointer(Obj);
                  Obj:=NIL;
             END;

             IF dummy<>NIL THEN
             BEGIN
                  //if we are at the Object repository page do really erase the object
                  IF MessageBox(FmtLoadNLSStr(SiEraseRepositoryForm,[dummy^.Name]),mtConfirmation,mbYesNoCancel)=mrYes THEN
                  BEGIN
                       FreeMem(dummy^.IconInfo,dummy^.IconLen);
                       FreeMem(dummy^.SCUInfo,dummy^.SCULen);
                       FreeMem(dummy^.EditInfo,dummy^.EditLen);
                       StrDispose(dummy^.Description);
                       RepForms.Remove(dummy);
                       Dispose(dummy);
                  END
                  ELSE exit;
             END
             ELSE
             BEGIN
                  Page:=FindPage(PagesListBox.Items.Strings[PagesListBox.ItemIndex]);
                  IF Page=NIL THEN exit;
                  Obj:=FindObject(Page,ObjectsListBox.Items[Index]);
                  IF Obj=NIL THEN exit;

                  Page^.Objects.Remove(Obj);
                  DisposeStr(Obj^.IDName);
                  DisposeStr(Obj^.Title);
                  StrDispose(Obj^.Description);
                  DisposeStr(Obj^.Author);
                  Dispose(Obj);

                  Project.Modified:=TRUE;
                  IdeSettings.Modified:=TRUE;
             END;

             ObjectsListBox.Items.Delete(Index);
             Objects.Delete(Index);
        END;
        ELSE MsgHandled:=FALSE;
     END; //case

     IF MsgHandled THEN Command := cmNull;

     Inherited CommandEvent(Command);
END;


PROCEDURE TRepositoryDialog.ObjItemFocused(Sender:TObject;Index:LONGINT);
VAR
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
    t,t1:LONGINT;
    dummy:PRepForm;
LABEL FormRep;
BEGIN
     IF PagesListBox.ItemIndex=PagesListBox.Items.Count-1 THEN
     BEGIN
          Obj:=Pointer(Objects[Index]);
          IF Obj=NIL THEN exit;

          IF Obj^.Flag=1 THEN
          BEGIN
               dummy:=Pointer(Obj);
               Obj:=NIL;
          END
          ELSE dummy:=NIL;

          DeleteObjButton.Enabled:=dummy<>NIL;
     END
     ELSE DeleteObjButton.Enabled:=TRUE;
     EditButton.Enabled:=TRUE;

     Obj:=Pointer(Objects[Index]);
     IF Obj=NIL THEN exit;
     IF Obj^.Flag=1 THEN
     BEGIN
          dummy:=Pointer(Obj);
          Obj:=NIL;
     END
     ELSE dummy:=NIL;

     IF dummy<>NIL THEN
     BEGIN
          NewProject.Visible:=FALSE;
          NewForm.Visible:=TRUE;
          NewForm.Show;
          NewForm.Checked:=dummy^.NewForm;
          MainForm.Visible:=TRUE;
          MainForm.Show;
          MainForm.Checked:=dummy^.MainForm;
     END
     ELSE
     BEGIN
          IF Obj^.Instance.GetStyle=esForm THEN
          BEGIN
               NewProject.Visible:=FALSE;
               NewForm.Visible:=TRUE;
               NewForm.Show;
               NewForm.Checked:=Obj^.NewForm;
               MainForm.Visible:=TRUE;
               MainForm.Show;
               MainForm.Checked:=Obj^.MainForm;
          END
          ELSE
          BEGIN
               NewForm.Visible:=FALSE;
               NewForm.Hide;
               MainForm.Visible:=FALSE;
               MainForm.Hide;
               NewProject.Visible:=TRUE;
               NewProject.Show;
               NewProject.Checked:=Obj^.NewProject;
          END;
     END;
END;


PROCEDURE TRepositoryDialog.AddObject(Obj:PRepositoryObject);
VAR Bitmap,BitmapCopy:TBitmap;
BEGIN
     Bitmap:=Obj^.Instance.GetGlyph;
     IF Bitmap=NIL THEN
     BEGIN
          Bitmap.Create;
          IF Obj^.Instance.GetStyle=esForm THEN Bitmap.LoadFromResourceId(bmpFormExpert)
          ELSE Bitmap.LoadFromResourceId(bmpPrjExpert);
     END
     ELSE
     BEGIN
          BitmapCopy:=Bitmap.Copy;
          Bitmap:=BitmapCopy;
     END;
     ObjectsListBox.AddBitmap(Obj^.Title^,Bitmap);
     Objects.Add(Obj);
END;

PROCEDURE TRepositoryDialog.PageItemFocused(Sender:TObject;Index:LONGINT);
VAR s,s1,s2:STRING;
    t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
    dummy:PRepForm;
    Bitmap:TBitmap;
BEGIN
     ObjectsListBox.BeginUpdate;

     ObjectsListBox.Clear;
     Objects.Clear;
     s:=PagesListBox.Items[Index];
     DeleteObjButton.Enabled:=FALSE;
     EditButton.Enabled:=FALSE;
     NewForm.Hide;
     NewProject.Hide;
     MainForm.Hide;

     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          IF Page^.PageInstalled THEN
            IF Page^.Page^=s THEN //found
          BEGIN
               FOR t1:=0 TO Page^.Objects.Count-1 DO
               BEGIN
                    Obj:=Page^.Objects.Items[t1];
                    IF Obj^.InstalledInPage THEN AddObject(Obj);
               END;
               break;
          END;
     END;

     FOR t:=0 TO RepForms.Count-1 DO
     BEGIN
          s1:=s;
          UpcaseStr(s1);
          dummy:=RepForms[t];
          IF dummy^.PageInstalled THEN
          BEGIN
               s2:=dummy^.Page;
               UpcaseStr(s2);
               IF ((Index=PagesListBox.Items.Count-1)OR(s1=s2)) THEN //found
               BEGIN
                    IF ((dummy^.InstalledInPage)OR(Index=PagesListBox.Items.Count-1)) THEN
                    BEGIN
                         Bitmap.Create;
                         TRY
                            Bitmap.LoadFromMem(dummy^.IconInfo^,dummy^.IconLen);
                         EXCEPT
                            Bitmap.Destroy;
                            Bitmap:=NIL;
                         END;

                         IF Bitmap=NIL THEN
                         BEGIN
                              Bitmap.Create;
                              Bitmap.LoadFromResourceId(1811)
                         END;
                         ObjectsListBox.AddBitmap(dummy^.Name,Bitmap);
                         Objects.Add(dummy);
                    END;
               END;
          END;
     END;

     IF Index=PagesListBox.Items.Count-1 THEN //[Object Repository]
     BEGIN
          DeletePageButton.Enabled:=FALSE;
          RenameButton.Enabled:=FALSE;
     END
     ELSE
     BEGIN
          DeletePageButton.Enabled := ObjectsListBox.Items.Count=0;
          RenameButton.Enabled:=TRUE;
     END;

     ObjectsListBox.EndUpdate;
END;

DESTRUCTOR TRepositoryDialog.Destroy;
BEGIN
     FreeRepFormTemplates(RepForms);
     Objects.Destroy;
     Inherited Destroy;
END;

PROCEDURE TRepositoryDialog.SetupComponent;
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    dummy:PRepForm;
    s,s1:STRING;
    Lab:TLabel;
LABEL l;
BEGIN
     Inherited SetupComponent;
     ClientWidth:=520;
     Height:=390;
     Caption:=LoadNLSStr(SiConfigureRepository);

     InsertGroupBox(SELF,10,50,500,300,'');

     Objects.Create;
     InsertLabel(SELF,20,320,160,20,LoadNLSStr(SiPages));
     Lab := InsertLabel(SELF,180,315,140,20,'< '+LoadNLSStr(SiDragItems));
     Lab.Alignment := taCenter;
     PagesListBox:=InsertListBox(SELF,20,65,160,255,'');
     //PagesListBox.Sorted:=TRUE; ///!!!! wegen Add !!!!
     PagesListBox.OnItemFocus:=PageItemFocused;
     PagesListBox.OnDragOver:=PageDragOver;
     PagesListBox.OnDragDrop:=PageDragDrop;
     PagesListBox.ShowDragRects:=TRUE;

     FOR t:=0 TO Repository.Count-2 DO
     BEGIN
          Page:=Repository.Items[t];
          IF Page^.PageInstalled THEN PagesListBox.Items.Add(Page^.Page^);
     END;
     RepForms:=GetRepFormTemplates('');

     FOR t:=0 TO RepForms.Count-1 DO
     BEGIN
          dummy:=RepForms[t];
          IF dummy^.PageInstalled THEN
          BEGIN
               s:=dummy^.Page;
               UpcaseStr(s);
               FOR t1:=0 TO PagesListBox.Items.Count-1 DO
               BEGIN
                    s1:=PagesListBox.Items[t1];
                    UpcaseStr(s1);
                    IF s=s1 THEN goto l;
               END;
               PagesListBox.Items.Add(dummy^.Page);
          END;
l:
     END;

     IF Repository.Count > 0 THEN {wenigsten die Inhalts Seite ist da}
     BEGIN
          Page:=Repository.Items[Repository.Count-1];
          IF Page^.PageInstalled THEN PagesListBox.Items.Add(Page^.Page^);
     END;

     InsertLabelNLS(SELF,320,320,180,20,SiObjects);
     ObjectsListBox:=InsertBitmapListBox(SELF,320,120,180,200,28);
     //ObjectsListBox.Sorted:=TRUE; !!! (wegen Objects:TList) !!!
     ObjectsListBox.ScaleBitmap:=TRUE;
     ObjectsListBox.OnItemFocus:=ObjItemFocused;
     ObjectsListBox.DragMode:=dmAutomatic;
     ObjectsListBox.OnCanDrag:=ObjectCanDrag;

     MainForm:=InsertCheckBoxNLS(SELF,320,85,190,20,SiRepMainForm,SiRepMainFormHint);
     MainForm.Visible:=FALSE;
     MainForm.OnClick:=CheckBoxChecked;
     NewForm:=InsertCheckBoxNLS(SELF,320,65,190,20,SiRepNewForm,SiRepNewFormHint);
     NewForm.Visible:=FALSE;
     NewForm.OnClick:=CheckBoxChecked;
     NewProject:=InsertCheckBoxNLS(SELF,320,85,190,20,SiRepNewProject,SiRepNewProjectHint);
     NewProject.Visible:=FALSE;
     NewProject.OnClick:=CheckBoxChecked;

     NewPageButton := InsertBitBtnRes(SELF,185,280,130,30,0,cmNew,
       LoadNLSStr(SiRepAddPage),LoadNLSStr(SiRepAddPageHint));
     NewPageButton.ModalResult := cmNull;
     NewPageButton.Command:=cmNew;
     DeletePageButton:=InsertBitBtnRes(SELF,185,240,130,30,0,cmCut,
       LoadNLSStr(SiRepDeletePage),LoadNLSStr(SiRepDeletePageHint));
     DeletePageButton.ModalResult := cmNull;
     DeletePageButton.Command:=cmCut;
     DeletePageButton.Enabled:=FALSE;
     RenameButton:=InsertBitBtnRes(SELF,185,200,130,30,0,cmReplace,
       LoadNLSStr(SiRepRenamePage),LoadNLSStr(SiRepRenamePageHint));
     RenameButton.ModalResult := cmNull;
     RenameButton.Command:=cmReplace;
     RenameButton.Enabled:=FALSE;
     EditButton:=InsertBitBtnRes(SELF,185,160,130,30,0,cmCopy,
       LoadNLSStr(SiRepEditObject),LoadNLSStr(SiRepEditObjectHint));
     EditButton.ModalResult := cmNull;
     EditButton.Command:=cmCopy;
     EditButton.Enabled:=FALSE;
     DeleteObjButton:=InsertBitBtnRes(SELF,185,120,130,30,0,cmPaste,
       LoadNLSStr(SiRepDeleteObject),LoadNLSStr(SiRepDeleteObjectHint));
     DeleteObjButton.ModalResult := cmNull;
     DeleteObjButton.Command:=cmPaste;
     DeleteObjButton.Enabled:=FALSE;

     InsertBitBtnNLS(SELF,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

PROCEDURE CopyRepositoryPages(CopyTo:TList);
VAR t,t1:LONGINT;
    Page,NewPage:PRepositoryPage;
    Obj,NewObj:PRepositoryObject;
BEGIN
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          New(NewPage);
          NewPage^.Page := NewStr(Page^.Page^);
          NewPage^.PageInstalled:=Page^.PageInstalled;
          NewPage^.Objects.Create;

          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               New(NewObj);
               NewObj^:=Obj^;
               NewObj^.IDName := NewStr(Obj^.IDName^);
               NewObj^.Title := NewStr(Obj^.Title^);
               NewObj^.Description := StrNew(Obj^.Description);
               NewObj^.Author := NewStr(Obj^.Author^);

               NewPage^.Objects.Add(NewObj);
          END;

          CopyTo.Add(NewPage);
     END;
END;

PROCEDURE ViewRepository;
VAR Dlg:TRepositoryDialog;
    SavePages,Temp:TList;
BEGIN
     SavePages.Create;
     CopyRepositoryPages(SavePages);
     {Swap}
     Temp:=SavePages;
     SavePages:=Repository;
     Repository:=Temp;

     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogRepositoryForm;
     IF Dlg.Execute THEN
     BEGIN
          SaveRepFormTemplates('',Dlg.RepForms);
          Dlg.Destroy;

          Temp:=Repository;
          Repository:=SavePages;
          ClearRepository;
          Repository.Destroy;
          Repository:=Temp;
     END
     ELSE //cancelled
     BEGIN
          Dlg.Destroy;
          ClearRepository;
          Repository.Destroy;
          Repository:=SavePages;
     END;
END;

PROCEDURE AddToRepository(Expert:TIExpert);
VAR t,t1,t2:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
    s,s1,id,id1:STRING;
    Found:PRepositoryPage;
    FoundObj:BOOLEAN;
    RepIndex:LONGINT;
BEGIN
     //only for project and form experts
     IF Expert.GetStyle IN [esStandard,esAddIn] THEN exit;

     s:=Expert.GetPage;
     IF s='' THEN //Default
     BEGIN
          IF Expert.GetStyle=esForm THEN s:=LoadNLSStr(SiFormsPage)
          ELSE s:=LoadNLSStr(SiProjectsPage);
     END;
     UpCaseStr(s);
     Found:=NIL;
     id:=Expert.GetIDString;
     UpcaseStr(id);

     RepIndex:=-1;
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          s1:=Page^.Page^;
          IF s1=ObjectRepositoryString THEN RepIndex:=t;
          UpcaseStr(s1);
          if s=s1 THEN Found:=Page;

          //if the expert is registered elsewhere skip this
          FoundObj:=FALSE;
          FOR t1:=0 TO Repository.Count-1 DO
          BEGIN
               Page:=Repository.Items[t1];

               FOR t2:=0 TO Page^.Objects.Count-1 DO
               BEGIN
                    Obj:=Page^.Objects.Items[t2];
                    id1:=Obj^.IdName^;
                    UpcaseStr(id1);
                    IF Id1=Id THEN
                    BEGIN
                         Obj^.Instance:=Expert;
                         FoundObj:=TRUE;
                    END;
               END;
          END;
          IF FoundObj THEN exit;
     END;

     IF Found=NIL THEN //Page does not exist
     BEGIN
          New(Found);
          s:=Expert.GetPage;
          IF s='' THEN //Default
          BEGIN
               IF Expert.GetStyle=esForm THEN s:=LoadNLSStr(SiFormsPage)
               ELSE s:=LoadNLSStr(SiProjectsPage);
          END;
          Found^.Page := NewStr(s);
          Found^.Objects.Create;
          Found^.PageInstalled:=TRUE;
          IF RepIndex=-1 THEN Repository.Add(Found)
          ELSE Repository.Insert(RepIndex,Found);  //[Object Repository is last page !
     END;

     New(Obj);
     id:=Expert.GetIDString;
     Obj^.IDName := NewStr(id);
     Obj^.NewProject:=FALSE;
     Obj^.NewForm:=FALSE;
     Obj^.MainForm:=FALSE;
     Obj^.Instance:=Expert;
     Obj^.InstalledInPage:=TRUE;
     Obj^.Title := NewStr(Expert.GetName);
     s:=Expert.GetComment;
     Obj^.Description := StrAlloc(length(s)+1);
     Obj^.Description^:=s;
     Obj^.Author := NewStr(Expert.GetAuthor);
     Found^.Objects.Add(Obj);
END;

PROCEDURE ClearRepositoryInstances;
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
BEGIN
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               Obj^.Instance:=NIL;
          END;
     END;
END;

PROCEDURE ClearRepository;
VAR  t,t1:LONGINT;
     Page:PRepositoryPage;
     Obj:PRepositoryObject;
BEGIN
     FOR t := 0 TO Repository.Count-1 DO
     BEGIN
          Page := Repository.Items[t];
          FOR t1 := 0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               DisposeStr(Obj^.IDName);
               DisposeStr(Obj^.Title);
               StrDispose(Obj^.Description);
               DisposeStr(Obj^.Author);
               Dispose(Obj);
               {Obj^.Instance ?}
          END;
          DisposeStr(Page^.Page);
          Page^.Objects.Destroy;
          Dispose(Page);
     END;
     Repository.Clear;
END;


PROCEDURE GetDefaultNewForm(MainForm:Boolean;VAR SCUInfo:Pointer;VAR SCULen:LongWord;
                            VAR EditorInfo:POINTER;VAR EditorLen:LONGWORD);
VAR t,t1,t2:LONGINT;
    Page:PRepositoryPage;
    TemplateSelected:PRepForm;
    Obj:PRepositoryObject;
    Ok:Boolean;
    TemplateList:TList;
Label LabOk;
BEGIN
     SCUInfo:=Nil;
     SCULen:=0;
     EditorInfo:=NIL;
     EditorLen:=0;

     TemplateList:=GetRepFormTemplates('');

     For t:=0 To TemplateList.Count-1 Do
     Begin
         TemplateSelected:=TemplateList[t];
         If ((MainForm)And(TemplateSelected^.MainForm)) Then goto LabOk
         Else If TemplateSelected^.NewForm Then goto LabOk;
     End;

     FreeRepFormTemplates(TemplateList);
     exit;
LabOk:
     SCULen:=TemplateSelected^.SCULen;
     GetMem(SCUInfo,SCULen);
     System.Move(TemplateSelected^.SCUInfo^,SCUInfo^,SCULen);

     EditorLen:=TemplateSelected^.EditLen;
     GetMem(EditorInfo,EditorLen);
     System.Move(TemplateSelected^.EditInfo^,EditorInfo^,EditorLen);

     FreeRepFormTemplates(TemplateList);
END;

FUNCTION GetProjectExpert:TIExpert;
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
BEGIN
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          IF Page^.PageInstalled THEN
            FOR t1:=0 TO Page^.Objects.Count-1 DO
            BEGIN
                 Obj:=Page^.Objects.Items[t1];
                 IF Obj^.InstalledInPage THEN
                   IF Obj^.Instance <> NIL THEN
                     IF Obj^.NewProject THEN
                     BEGIN
                          result:=Obj^.Instance;
                          exit;
                     END;
            END;
     END;

     result:=NIL;
END;


FUNCTION GetNewFormExpert(VAR SCUInfo:POINTER;VAR SCULen:LONGWORD;
                          VAR EditorInfo:POINTER;VAR EditorLen:LONGWORD):TIExpert;
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
BEGIN
     SCUInfo:=NIL;
     SCULen:=0;
     EditorInfo:=NIL;
     EditorLen:=0;
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               IF Obj^.NewForm THEN
               BEGIN
                    result:=Obj^.Instance;
                    exit;
               END;
          END;
     END;

     result:=NIL;
     GetDefaultNewForm(FALSE,SCUInfo,SCULen,EditorInfo,EditorLen);
END;

FUNCTION GetMainFormExpert(VAR SCUInfo:POINTER;VAR SCULen:LONGWORD;
                           VAR EditorInfo:POINTER;VAR EditorLen:LONGWORD):TIExpert;
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
BEGIN
     SCUInfo:=NIL;
     SCULen:=0;
     EditorInfo:=NIL;
     EditorLen:=0;
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               IF Obj^.MainForm THEN
               BEGIN
                    result:=Obj^.Instance;
                    exit;
               END;
          END;
     END;

     result:=NIL;
     GetDefaultNewForm(TRUE,SCUInfo,SCULen,EditorInfo,EditorLen);
END;


PROCEDURE PackRepository;
VAR t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj,Obj1:PRepositoryObject;
    id,s,Rep:STRING;
    Expert:TIExpert;
LABEL again,again1;
BEGIN
again:
     FOR t:=0 TO Repository.Count-1 DO
     BEGIN
          Page:=Repository.Items[t];
again1:
          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects.Items[t1];
               IF Obj^.Instance=NIL THEN
               BEGIN
                    DisposeStr(Obj^.IDName);
                    DisposeStr(Obj^.Title);
                    StrDispose(Obj^.Description);
                    DisposeStr(Obj^.Author);

                    Page^.Objects.Remove(Obj);
                    dispose(Obj);
                    IF Page^.Objects.Count=0 THEN //remove whole page
                    BEGIN
                         DisposeStr(Page^.Page);
                         Page^.Objects.Destroy;
                         Repository.Remove(Page);
                         Dispose(Page);
                         goto again;
                    END
                    ELSE goto again1;
               END;
          END;
     END;

     //Create Object Repository page if it does not exist

     Rep:=ObjectRepositoryString;
     IF Repository.Count>0 THEN
     BEGIN
          Page:=Repository.Items[Repository.Count-1];
          IF Page^.Page^<>Rep THEN Page:=NIL;
     END
     ELSE Page:=NIL;

     IF Page=NIL THEN
     BEGIN
          New(Page);
          Page^.Page := NewStr(Rep);
          Page^.PageInstalled:=TRUE;
          Page^.Objects.Create;
          Repository.Add(Page);
     END;

     FOR t:=0 TO LibExpertInstances.Count-1 DO
     BEGIN
          Expert:=TIExpert(LibExpertInstances.Items[t]);
          IF not (Expert.GetStyle IN [esForm,esProject]) THEN continue;

          id:=Expert.GetIDString;

          //Look if the Expert is already in the Repository page
          Obj:=NIL;
          FOR t1:=0 TO Page^.Objects.Count-1 DO
          BEGIN
               Obj:=Page^.Objects[t1];
               IF Obj^.IDName^=Id THEN break
               ELSE Obj:=NIL;
          END;

          IF Obj=NIL THEN
          BEGIN
               New(Obj);
               Obj^.IDName := NewStr(id);
               Obj^.NewProject:=FALSE;
               Obj^.NewForm:=FALSE;
               Obj^.MainForm:=FALSE;
               Obj^.InstalledInPage:=TRUE;
               Obj^.Title := NewStr(Expert.GetName);
               s:=Expert.GetComment;
               Obj^.Description := StrAlloc(length(s)+1);
               Obj^.Description^:=s;
               Obj^.Author := NewStr(Expert.GetAuthor);
               Page^.Objects.Add(Obj);
          END;
          Obj^.Instance:=Expert;
     END;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: New object Dialog                                           บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TNewObjDlg=CLASS(TDialog)
       PROTECTED
        NoteBook:TTabbedNoteBook;
        NewListView:TListView;
        NewAppItem,NewFormItem,NewUnitItem,NewResourceItem, NewWDSibylHelpItem, NewTextItem,
        NewCompItem,NewCompLibItem,NewDockingItem,NewThreadItem:TListViewNode;
        ExpertSelected:TIExpert;
        NewSelected:TListViewNode;
        TemplateList:TList;
        TemplateSelected:PRepForm;
        FUNCTION GetListView:TListView;
        PROCEDURE SetupComponent;OVERRIDE;
        PROCEDURE ExpertItemSelected(Sender:TObject;Index:LONGINT);
        PROCEDURE NewItemSelected(Sender:TObject;Index:LONGINT);
        PROCEDURE OkClicked(Sender:TObject);
        PROPERTY ActiveListView:TListView read GetListView;
        DESTRUCTOR Destroy;OVERRIDE;
     END;


DESTRUCTOR TNewObjDlg.Destroy;
BEGIN
     FreeRepFormTemplates(TemplateList);
     Inherited Destroy;
END;

FUNCTION TNewObjDlg.GetListView:TListView;
VAR  Page:TPage;
BEGIN
     Result := NIL;
     Page := TPage(NoteBook.Pages.Objects[Notebook.PageIndex]);
     IF Page = NIL THEN exit;
     IF Page.ControlCount = 0 THEN exit;
     IF not (Page.Controls[0] IS TListView) THEN exit;
     Result := TListView(Page.Controls[0]);
END;


PROCEDURE TNewObjDlg.OkClicked(Sender:TObject);
VAR  Index:LONGINT;
     t:LONGINT;
     Node:TListViewNode;
BEGIN
     IF NoteBook.PageIndex = 0 THEN {New Page}
     BEGIN
          Index := NewListView.ItemIndex;
          IF Index <> -1 THEN NewSelected := NewListView.Items[Index];
     END
     ELSE
     BEGIN
          IF ActiveListView = NIL THEN exit;
          Index := ActiveListView.ItemIndex;
          IF Index <> -1 THEN
          BEGIN
               ExpertSelected := ActiveListView.Items[Index].Data;
               IF ExpertSelected=NIL THEN
               BEGIN
                    Node:=ActiveListView.Items[Index];
                    FOR t:=0 TO TemplateList.Count-1 DO
                    BEGIN
                         TemplateSelected:=TemplateList[t];
                         IF TemplateSelected^.Name=Node.Text  THEN exit;
                    END;
               END;
               TemplateSelected:=NIL;
          END;
     END;
END;


PROCEDURE TNewObjDlg.ExpertItemSelected(Sender:TObject;Index:LONGINT);
VAR t:LONGINT;
    Node:TListViewNode;
BEGIN
     IF Sender IS TListView THEN
     BEGIN
          ExpertSelected:=TListView(Sender).Items[Index].Data;
          IF ExpertSelected=NIL THEN
          BEGIN
               Node:=TListView(Sender).Items[Index];
               FOR t:=0 TO TemplateList.Count-1 DO
               BEGIN
                    TemplateSelected:=TemplateList[t];
                    IF TemplateSelected^.Name=Node.Text  THEN
                    BEGIN
                         DismissDlg(cmOk);
                         exit;
                    END;
               END;
               TemplateSelected:=NIL;
          END
          ELSE DismissDlg(cmOk);
     END;
END;


PROCEDURE TNewObjDlg.NewItemSelected(Sender:TObject;Index:LONGINT);
BEGIN
     IF Sender IS TListView THEN
     BEGIN
          NewSelected:=TListView(Sender).Items[Index];
          DismissDlg(cmOk);
     END;
END;

PROCEDURE FreeRepFormTemplates(VAR List:TList);
VAR t:LONGINT;
    dummy:PRepForm;
BEGIN
     FOR t:=0 TO List.Count-1 DO
     BEGIN
          dummy:=List[t];

          StrDispose(dummy^.Description);
          FreeMem(dummy^.IconInfo,dummy^.IconLen);
          FreeMem(dummy^.SCUInfo,dummy^.SCULen);
          FreeMem(dummy^.EditInfo,dummy^.EditLen);
          dispose(dummy);
     END;
     List.Destroy;
     List:=NIL;
END;

FUNCTION GetRepFormTemplates(CONST LibName:STRING):TList;
VAR FileName,Dir,Name,Ext:STRING;
    dummy:PRepForm;
    Next,Temp:LONGWORD;
    b:BYTE;
    f:FILE;
    res:LONGWORD;
BEGIN
     //look for registered form templated
     IF LibName='' THEN
     BEGIN
          FileName:=ParamStr(0);
          FSplit(FileName,Dir,Name,ext);
          FileName:=Dir+'SIBYL.FRM';
     END
     ELSE FileName:=LibName;

     result.Create;
     System.Assign(f,FileName);
     {$i-}
     FileMode:=fmInput;
     Reset(f);
     FileMode:=fmInOut;
     {$I+}
     IF IOResult=0 THEN
     BEGIN
          TRY
             BlockRead(f,Next,4,Res);
             IF Res<>4 THEN Raise EInOutError.Create('');
             WHILE Next<>0 DO
             BEGIN
                  New(dummy);
                  dummy^.Flag:=1;
                  BlockRead(f,b,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');
                  dummy^.Name[0]:=chr(b);
                  BlockRead(f,dummy^.Name[1],b,Res);
                  IF Res<>b THEN Raise EInOutError.Create('');
                  BlockRead(f,b,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');
                  dummy^.Page[0]:=chr(b);
                  BlockRead(f,dummy^.Page[1],b,Res);
                  IF Res<>b THEN Raise EInOutError.Create('');

                  BlockRead(f,dummy^.InstalledInPage,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');
                  BlockRead(f,dummy^.PageInstalled,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');
                  BlockRead(f,dummy^.NewProject,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');
                  BlockRead(f,dummy^.NewForm,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');
                  BlockRead(f,dummy^.MainForm,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');

                  BlockRead(f,dummy^.IconLen,4,Res);
                  IF Res<>4 THEN Raise EInOutError.Create('');
                  GetMem(dummy^.IconInfo,dummy^.IconLen);
                  BlockRead(f,dummy^.IconInfo^,dummy^.IconLen,Res);
                  IF Res<>dummy^.IconLen THEN Raise EInOutError.Create('');

                  BlockRead(f,b,1,Res);
                  IF Res<>1 THEN Raise EInOutError.Create('');
                  dummy^.Author[0]:=chr(b);
                  BlockRead(f,dummy^.Author[1],b,Res);
                  IF Res<>b THEN Raise EInOutError.Create('');

                  BlockRead(f,Temp,4,Res);
                  IF Res<>4 THEN Raise EInOutError.Create('');
                  IF Temp=0 THEN dummy^.Description:=NIL
                  ELSE
                  BEGIN
                       dummy^.Description:=StrAlloc(Temp);
                       BlockRead(f,dummy^.Description^,Temp,Res);
                       IF Res<>Temp THEN Raise EInOutError.Create('');
                  END;

                  BlockRead(f,dummy^.SCULen,4,Res);
                  IF Res<>4 THEN Raise EInOutError.Create('');
                  GetMem(dummy^.SCUInfo,dummy^.SCULen);
                  BlockRead(f,dummy^.SCUInfo^,dummy^.SCULen,Res);
                  IF Res<>dummy^.SCULen THEN Raise EInOutError.Create('');

                  BlockRead(f,dummy^.EditLen,4,Res);
                  IF Res<>4 THEN Raise EInOutError.Create('');
                  GetMem(dummy^.EditInfo,dummy^.EditLen);
                  BlockRead(f,dummy^.EditInfo^,dummy^.EditLen,Res);
                  IF Res<>dummy^.EditLen THEN Raise EInOutError.Create('');

                  result.Add(dummy);

                  Seek(f,Next);
                  BlockRead(f,Next,4,Res);
                  IF Res<>4 THEN Raise EInOutError.Create('');
             END;

             System.Close(f);
          EXCEPT
             {$I-}
             System.Close(f);
             {$I+}
          END;
     END;
END;

PROCEDURE SaveRepFormTemplates(CONST LibName:STRING;List:TList);
VAR FileName,Dir,Name,Ext:STRING;
    dummy:PRepForm;
    Next,Temp:LONGWORD;
    b:BYTE;
    f:FILE;
    t:LONGINT;
    Err:BOOLEAN;
BEGIN
     //look for registered form templated
     IF LibName='' THEN
     BEGIN
          FileName:=ParamStr(0);
          FSplit(FileName,Dir,Name,ext);
          FileName:=Dir+'SIBYL.FRM';
     END
     ELSE FileName:=LibName;

     System.Assign(f,FileName);
     {$i-}
     Rewrite(f);
     {$I+}
     IF IOResult=0 THEN
     BEGIN
          Err:=FALSE;
          FOR t:=0 TO List.Count-1 DO
          BEGIN
               dummy:=List[t];

               TRY
                  Temp:=FilePos(f);
                  Next:=0;
                  BlockWrite(f,Next,4);

                  BlockWrite(f,dummy^.Name,length(dummy^.Name)+1);
                  BlockWrite(f,dummy^.Page,length(dummy^.Page)+1);
                  BlockWrite(f,dummy^.InstalledInPage,1);
                  BlockWrite(f,dummy^.PageInstalled,1);
                  BlockWrite(f,dummy^.NewProject,1);
                  BlockWrite(f,dummy^.NewForm,1);
                  BlockWrite(f,dummy^.MainForm,1);
                  BlockWrite(f,dummy^.IconLen,4);
                  BlockWrite(f,dummy^.IconInfo^,dummy^.IconLen);
                  BlockWrite(f,dummy^.Author,length(dummy^.Author)+1);
                  IF dummy^.Description=NIL THEN
                  BEGIN
                      Next:=0;
                      BlockWrite(f,Next,0);
                  END
                  ELSE
                  BEGIN
                      Next:=length(dummy^.Description^)+1;
                      BlockWrite(f,Next,4);
                      BlockWrite(f,dummy^.Description^,Next);
                  END;
                  BlockWrite(f,dummy^.SCULen,4);
                  BlockWrite(f,dummy^.SCUInfo^,dummy^.SCULen);
                  BlockWrite(f,dummy^.EditLen,4);
                  BlockWrite(f,dummy^.EditInfo^,dummy^.EditLen);

                  Next:=FilePos(f);
                  Seek(f,Temp);
                  BlockWrite(f,Next,4);
                  Seek(f,Next);
               EXCEPT
                  {$I-}
                  Close(f);
                  {$I+}
                  ErrorBox(FmtLoadNLSStr(SiFileWriteError,[FileName]));
                  Err:=TRUE;
               END;
               IF Err THEN exit;
          END;

          Next:=0;  //mark end
          {$I-}
          BlockWrite(f,Next,4);
          {$I+}
          IF IOResult<>0 THEN ErrorBox(FmtLoadNLSStr(SiFileWriteError,[FileName]));
          {$I-}
          Close(f);
          {$I+}
     END
     ELSE ErrorBox(FmtLoadNLSStr(SiFileCreateError,[FileName]));
END;

PROCEDURE TNewObjDlg.SetupComponent;
VAR Button:TBitBtn;
    Bitmap:TBitmap;
    t,t1:LONGINT;
    Page:PRepositoryPage;
    Obj:PRepositoryObject;
    ExpertPage:TPage;
    NewPage:TPage;
    ExpertListView:TListView;
    FileName,Dir,Name,Ext:STRING;
    f:FILE;
    dummy,dummy1:PRepForm;
    Temp,Next:LONGWORD;
    b:BYTE;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiRepository);
     Width:=570;
     Height:=370;

     Notebook:=InsertTabbedNoteBook(SELF,10,60,545,275);
     Notebook.Pages.Clear;
     Notebook.ShowPageHint := FALSE;
     Notebook.Pages.Add(LoadNLSStr(SiNewPage));
     NewPage := TPage(Notebook.Pages.Objects[0]);

     NewListView:=InsertListView(NewPage,2,2,470,170,'');
     NewListView.Align := alClient;
     NewListView.Color:=clWhite;   {wegen den Bitmaps}
     NewListView.MultipleSel:=FALSE;
     NewListView.OnItemSelect:=NewItemSelected;

     Bitmap.Create;

     Bitmap.LoadFromResourceId(bmpNew_App);
     NewAppItem:=NewListView.Add(LoadNLSStr(SiApplication),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_Form);
     NewFormItem:=NewListView.Add(LoadNLSStr(SiForm),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_Unit);
     NewUnitItem:=NewListView.Add(LoadNLSStr(SiUnit),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_Resource);
     NewResourceItem:=NewListView.Add(LoadNLSStr(SiResource),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_Text);
     NewTextItem:=NewListView.Add(LoadNLSStr(SiText),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_WDSibylHelp);
     NewWDSibylHelpItem:=NewListView.Add(LoadNLSStr(SiWDSibylHelp),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_Comp);
     NewCompItem:=NewListView.Add(LoadNLSStr(SiComponent),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_CompLib);
     NewCompLibItem:=NewListView.Add(LoadNLSStr(SiCompLib),NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_Thread);
     NewThreadItem:=NewListView.Add('Thread',NIL,Bitmap);
     Bitmap.LoadFromResourceId(bmpNew_Dock);
     NewDockingItem:=NewListView.Add(LoadNLSStr(SiDockingToolBar),NIL,Bitmap);

     Bitmap.Destroy;

     TemplateList:=GetRepFormTemplates('');

     FOR t:=0 TO Repository.Count-2 DO
     BEGIN
          Page:=Repository.Items[t];
          IF Page^.PageInstalled THEN
          BEGIN
               Notebook.Pages.Add(Page^.Page^);
               ExpertPage := TPage(Notebook.Pages.Objects[NoteBook.Pages.Count-1]);

               ExpertListView:=InsertListView(ExpertPage,2,2,470,170,'');
               ExpertListView.Align := alClient;
               ExpertListView.MultipleSel:=FALSE;
               ExpertListView.Color:=clWhite;   {wegen den Bitmaps}
               ExpertListView.OnItemSelect:=ExpertItemSelected;

               FOR t1:=0 TO Page^.Objects.Count-1 DO
               BEGIN
                    Obj:=Page^.Objects.Items[t1];
                    IF Obj^.InstalledInPage THEN IF Obj^.Instance<>NIL THEN
                    BEGIN
                         Bitmap:=Obj^.Instance.GetGlyph;
                         IF Bitmap=NIL THEN
                         BEGIN
                              Bitmap.Create;
                              TRY
                                 IF Obj^.Instance.GetStyle=esForm THEN Bitmap.LoadFromResourceId(bmpFormExpert)
                                 ELSE Bitmap.LoadFromResourceId(bmpPrjExpert);
                              EXCEPT
                                 Bitmap.Destroy;
                                 Bitmap:=NIL;
                              END;
                              ExpertListView.Add(Obj^.Title^,Obj^.Instance,Bitmap);
                              IF Bitmap<>NIL THEN Bitmap.Destroy;
                         END
                         ELSE ExpertListView.Add(Obj^.Title^,Obj^.Instance,Bitmap);
                    END;
               END;

               //check form templates for this page
               FOR t:=0 TO TemplateList.Count-1 DO
               BEGIN
                    dummy:=TemplateList[t];
                    IF not dummy^.Inserted THEN IF dummy^.PageInstalled THEN IF dummy^.InstalledInPage THEN
                    BEGIN
                         Name:=dummy^.Page;
                         UpcaseStr(Name);
                         Ext:=Page^.Page^;
                         UpcaseStr(Ext);
                         IF Ext=Name THEN
                         BEGIN
                              Bitmap.Create;
                              TRY
                                 Bitmap.LoadFromMem(dummy^.IconInfo^,dummy^.IconLen);
                              EXCEPT
                                 Bitmap.Destroy;
                                 Bitmap:=NIL;
                              END;
                              ExpertListView.Add(dummy^.Name,NIL,Bitmap);
                              IF Bitmap<>NIL THEN Bitmap.Destroy;

                              dummy^.Inserted:=TRUE;
                         END;
                    END;
               END;
          END;
     END;

     //check form templates for this page
     FOR t:=0 TO TemplateList.Count-1 DO
     BEGIN
          dummy:=TemplateList[t];
          IF not dummy^.Inserted THEN //create a new page
            IF dummy^.PageInstalled THEN IF dummy^.InstalledInPage THEN
          BEGIN
               Notebook.Pages.Add(dummy^.Page);
               ExpertPage := TPage(Notebook.Pages.Objects[NoteBook.Pages.Count-1]);

               ExpertListView:=InsertListView(ExpertPage,2,2,470,170,'');
               ExpertListView.Align := alClient;
               ExpertListView.MultipleSel:=FALSE;
               ExpertListView.Color:=clWhite;   {wegen den Bitmaps}
               ExpertListView.OnItemSelect:=ExpertItemSelected;

               Bitmap.Create;
               TRY
                  Bitmap.LoadFromMem(dummy^.IconInfo^,dummy^.IconLen);
               EXCEPT
                  Bitmap.Destroy;
                  Bitmap:=NIL;
               END;
               ExpertListView.Add(dummy^.Name,NIL,Bitmap);
               IF Bitmap<>NIL THEN Bitmap.Destroy;

               dummy^.Inserted:=TRUE;

               FOR t1:=0 TO TemplateList.Count-1 DO
               BEGIN
                    dummy1:=TemplateList[t1];
                    IF not dummy1^.Inserted THEN
                      IF dummy^.PageInstalled THEN IF dummy^.InstalledInPage THEN
                    BEGIN
                         Name:=dummy1^.Page;
                         UpcaseStr(Name);
                         Ext:=dummy^.Page;
                         UpcaseStr(Ext);
                         IF Ext=Name THEN
                         BEGIN
                              Bitmap.Create;
                              TRY
                                 Bitmap.LoadFromMem(dummy1^.IconInfo^,dummy1^.IconLen);
                              EXCEPT
                                 Bitmap.Destroy;
                                 Bitmap:=NIL;
                              END;
                              ExpertListView.Add(dummy1^.Name,NIL,Bitmap);
                              IF Bitmap<>NIL THEN Bitmap.Destroy;

                              dummy1^.Inserted:=TRUE;
                         END;
                    END;
               END;
          END;
     END;

     Button:=InsertBitBtnNLS(SELF,10,15,90,30,bkOk,SOkButton,SClickHereToAccept);
     Button.OnClick:=OkClicked;
     InsertBitBtnNLS(SELF,120,15,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,230,15,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
     NoteBook.PageIndex:=0;
END;


PROCEDURE NewObject;
VAR Dlg:TNewObjDlg;
    ExpertSelected:TIExpert;
    Command:TCommand;
    SCUInfo:POINTER;
    SCULen:LONGWORD;
    EditInfo:POINTER;
    EditLen:LONGWORD;
BEGIN
  Dlg.Create(NIL);
  Dlg.HelpContext := hctxDialogNewObject;
  IF Dlg.Execute
    THEN
      BEGIN
        IF Dlg.ExpertSelected<>NIL
          THEN
            BEGIN
              ExpertSelected:=Dlg.ExpertSelected;
              Dlg.Destroy;
              ExpertSelected.Execute;
            END
          ELSE IF Dlg.TemplateSelected<>NIL THEN
            BEGIN
              SCULen:=Dlg.TemplateSelected^.SCULen;
              GetMem(SCUInfo,SCULen);
              System.Move(Dlg.TemplateSelected^.SCUInfo^,SCUInfo^,SCULen);
              EditLen:=Dlg.TemplateSelected^.EditLen;
              GetMem(EditInfo,EditLen);
              System.Move(Dlg.TemplateSelected^.EditInfo^,EditInfo^,EditLen);
              Dlg.Destroy;

              NewTemplateForm(SCUInfo,SCULen,EditInfo,EditLen);
            END
          ELSE IF Dlg.NewSelected<>NIL THEN
            BEGIN
              IF Dlg.NewSelected=Dlg.NewAppItem THEN Command:=cmProjectNew
              ELSE IF Dlg.NewSelected=Dlg.NewFormItem THEN Command:=cmNewForm
              ELSE IF Dlg.NewSelected=Dlg.NewUnitItem THEN Command:=cmNewUnit
              else if Dlg.NewSelected=Dlg.NewWDSibylHelpItem then Command:=cmNewWDSibylHelp
              else if Dlg.NewSelected=Dlg.NewResourceItem then Command:=cmNewResource
              ELSE IF Dlg.NewSelected=Dlg.NewTextItem THEN Command:=cmNewText
              ELSE IF Dlg.NewSelected=Dlg.NewCompItem THEN Command:=cmNewComponent
              ELSE IF Dlg.NewSelected=Dlg.NewCompLibItem THEN Command:=cmNewCompLib
              ELSE IF Dlg.NewSelected=Dlg.NewThreadItem THEN Command:=cmNewThread
              ELSE IF Dlg.NewSelected=Dlg.NewDockingItem THEN Command:=cmNewDock
              ELSE Command:=cmNull;
              Dlg.Destroy;
              IF Command<>cmNull
                THEN SendMsg(Application.MainForm.Handle,CM_COMMAND,Command,0);
            END
          ELSE Dlg.Destroy;
      END
    ELSE Dlg.Destroy;
END;


FUNCTION NewTemplateForm(SCUInfo:POINTER;SCULen:LONGWORD;
             EditInfo:POINTER;EditLen:LONGWORD):TForm;
VAR  SaveSCU:POINTER;
BEGIN
     SaveSCU:=SCUPointer;
     //This modifies SCUPointer
     ASM
        PUSH DWORD PTR SCUInfo
        CALLN32 SYSTEM.AddSCUData
     END;

     Result := FormEditClass.Create(NIL);

     IF GenImportForm(Result,'',EditInfo,EditLen) THEN
     BEGIN
          Project.Modified := TRUE;
          Project.SCUModified := TRUE;
          Project.NeedRecompile := TRUE;

          Result.Show;
          Result.Focus;
     END
     ELSE
     BEGIN
          Result.Destroy;  {Form konnte nicht importiert werden}
          Result := NIL;
     END;

     FreeMem(SCUInfo,SCULen);
     FreeMem(EditInfo,EditLen);
     SCUPointer:=SaveSCU;
END;


PROCEDURE IDEToolsNotify(N:TFileNotification;CONST FileName:STRING;VAR Cancel:BOOLEAN);
BEGIN
     Cancel:=FALSE;
     TRY
       IF IDEToolServices<>NIL THEN
         IDEToolServices.IDEFileNotify(N,FileName,Cancel);
     EXCEPT
        ErrorBox(LoadNLSStr(SiExceptInExpert));
     END;
END;

TYPE
    TAddToRepositoryForm=CLASS(TDialog)
       FListBox:TListBox;
       FTitle:TEdit;
       FDescription:TMemo;
       FPage:TComboBox;
       FAuthor:TEdit;
       FIcon:TBitmap;
       FImage:TImage;
       PROCEDURE SetupComponent;OVERRIDE;
       PROCEDURE SetupShow;OVERRIDE;
       PROCEDURE BrowseBtnClick(Sender:TObject);
       PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
    END;

VAR
   InitSelectedForm:TForm; {fokusiert auf diesen Eintrag in der Form Liste}


PROCEDURE TAddToRepositoryForm.BrowseBtnClick(Sender:TObject);
VAR FileDlg:TOpenDialog;
    ret:BOOLEAN;
    s:STRING;
    Bitmap:TBitmap;
BEGIN
     FileDlg.Create(SELF);
     FileDlg.HelpContext := hctxDialogOpenFormBitmap;
     FileDlg.Title:=LoadNLSStr(SiSelectABitmap);
     FileDlg.AddFilter(LoadNLSStr(SiBitmapFiles)+' (*.bmp)','*.BMP');
     FileDlg.FileName:='*.BMP';
     FileDlg.DefaultExt := 'BMP';
     ret := FileDlg.Execute;
     s := FileDlg.FileName;
     FileDlg.Destroy;

     IF ret THEN
     BEGIN
          Bitmap.Create;
          TRY
             Bitmap.LoadFromFile(s);
          EXCEPT
             Bitmap.Destroy;
             Bitmap:=NIL;
             ErrorBox(LoadNLSStr(SiInvalidBitmapFile));
          END;
          IF Bitmap<>NIL THEN
          BEGIN
               IF ((Bitmap.Width<>32)OR(Bitmap.Height<>32)) THEN
               BEGIN
                    Bitmap.Destroy;
                    ErrorBox(LoadNLSStr(SiBitmapMustBe32x32));
               END
               ELSE
               BEGIN
                   FIcon.Destroy;
                   FIcon:=Bitmap;
                   FImage.Bitmap:=FIcon;
               END;
          END;
     END;
END;


PROCEDURE TAddToRepositoryForm.SetupComponent;
VAR Lab:TLabel;
    BrowseBtn:TBitBtn;
    Group:TGroupBox;
    t:LONGINT;
    Page:PRepositoryPage;
    FormItem:PFormListItem;
    List:TList;
    dummy:PRepForm;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiSaveFormAsRepositoryTemp);
     Width:=445;
     Height:=400;

     Group:=InsertGroupBox(SELF,10,50,420,310,'');

     InsertLabelNLS(SELF,20,330,100,20,SiForms);
     FListBox:=InsertListBox(SELF,20,60,160,272,'');
     FListBox.Sorted:=TRUE;
     FOR t := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[t];
          FListBox.Items.AddObject(FormItem^.FormName,FormItem^.Form);
     END;

     InsertLabelNLS(SELF,190,330,100,20,SiTitle);
     FTitle:=InsertEdit(SELF,190,310,230,20,'','');

     InsertLabelNLS(SELF,190,280,100,20,SiDescription);
     FDescription:=InsertMemo(SELF,190,190,230,90,'');

     InsertLabelNLS(SELF,190,160,100,20,SiPage);
     FPage:=InsertComboBox(SELF,190,82,110,80,csDropDown);
     FPage.Sorted:=TRUE;
     FPage.Duplicates:=FALSE;
     //FPage.Items.Add('New');
     FOR t:=0 TO Repository.Count-2 DO
     BEGIN
          Page:=Repository.Items[t];
          IF Page^.PageInstalled THEN FPage.Items.Add(Page^.Page^);
     END;
     List:=GetRepFormTemplates('');
     FOR t:=0 TO List.Count-1 DO
     BEGIN
          dummy:=List[t];
          FPage.Items.Add(dummy^.Page);
     END;
     FreeRepFormTemplates(List);


     InsertLabelNLS(SELF,310,160,100,20,SiAuthor);
     FAuthor:=InsertEdit(SELF,310,140,110,20,'','');

     Lab:=InsertLabelNLS(SELF,240,75,180,50,SiSelectABMP);
     Lab.WordWrap:=TRUE;

     FIcon.Create;
     FIcon.LoadFromResourceId(1811);
     FImage.Create(SELF);
     FImage.ZOrder:=zoTop;
     FImage.SetWindowPos(190,90,32,32);
     FImage.Bitmap:=FIcon;
     FImage.Parent:=SELF;

     BrowseBtn:=InsertBitBtnNLS(SELF,240,60,90,30,bkCustom,SiBrowse,0);
     BrowseBtn.ModalResult:=cmNull;
     BrowseBtn.OnClick:=BrowseBtnClick;

     InsertBitBtnNLS(SELF,11,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,106,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,201,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;



PROCEDURE TAddToRepositoryForm.SetupShow;
VAR  t:LONGINT;
BEGIN
     Inherited SetupShow;

     {erst hier die Selection setzen, da die ListBox sich beim erzeugen selbst sortiert}
     IF FListBox.Items.Count > 0 THEN {Select "InitSelectedForm" oder den ersten Eintrag}
     BEGIN
          FListBox.ItemIndex := 0;
          IF InitSelectedForm <> NIL THEN
            FOR t := 0 TO FListBox.Items.Count-1 DO
            BEGIN
                 IF FListBox.Items.Objects[t] = InitSelectedForm THEN
                 BEGIN
                      FListBox.ItemIndex := t;
                      break;
                 END;
            END;
     END;
END;

PROCEDURE TAddToRepositoryForm.CommandEvent(VAR Command:TCommand);
VAR f,Edit:FILE;
    s,s1:STRING;
    Res:LONGWORD;
    FileName,dir,name,ext:STRING;
    t,PatchPos,Temp:LONGWORD;
    b:Byte;
    Err:BOOLEAN;
    pc:PChar;
    Memory:TMemoryStream;
    Form:TForm;
    TempSCUInfo,SCUInfo:POINTER;
    TempSCULen,SCULen:LONGWORD;
    EditorInfo:POINTER;
    EditorLen:LONGWORD;
    Editor:TEditor;
    FormItem:PFormListItem;
    List:TList;
BEGIN
     IF Command=cmOk THEN
     BEGIN
          IF FListBox.ItemIndex<0 THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiYouMustSpecifyAForm));
               Command:=cmNull;
               ModalResult:=cmNull;
               exit;
          END;

          IF FTitle.Text='' THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiYouMustSpecifyATitle));
               Command:=cmNull;
               ModalResult:=cmNull;
               exit;
          END;

          IF FPage.Text='' THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiYouMustSpecifyARepPage));
               Command:=cmNull;
               ModalResult:=cmNull;
               exit;
          END;

          s:=FPage.Text;
          UpcaseStr(s);
          s1:=LoadNLSStr(SiNewPage);
          UpcaseStr(s1);
          IF ((ord(s[1])<ord('A'))OR(ord(s[1])>ord('Z'))OR(s=s1)) THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiIllegalPageName));
               Command:=cmNull;
               ModalResult:=cmNull;
               exit;
          END;

          //search Form
          Form:=NIL;
          SCUInfo:=NIL;
          SCULen:=0;
          TempSCUInfo:=NIL;
          TempSCULen:=0;
          Name:=FListBox.Items[FListBox.ItemIndex];
          FOR t := 0 TO Project.Forms.Count-1 DO
          BEGIN
               FormItem := Project.Forms.Items[t];
               IF Name=FormItem^.FormName THEN
               BEGIN
                    Form:=TForm(FormItem^.Form);
                    TempSCUInfo:=FormItem^.SCUPointer;
                    TempSCULen:=FormItem^.SCUSize;
                    Name:=FormItem^.UnitName;
                    break;
               END;
          END;

          IF Form<>NIL THEN //Generate SCU Info
          BEGIN
               List.Create;
               List.Add(FormItem);
               TRY
                  Memory:=WritePropertiesToStream(List);
               EXCEPT
                  ErrorBox(LoadNLSStr(SiErrorGenSCU));
                  ModalResult:=cmNull;
                  Command:=cmNull;
                  Memory:=NIL;
               END;
               List.Destroy;

               IF Memory=NIL THEN exit;

               SCULen:=Memory.Size;
               GetMem(SCUInfo,SCULen);
               System.Move(Memory.Memory^,SCUInfo^,SCULen);
               Memory.Destroy;
          END
          ELSE IF TempSCULen<>0 THEN
          BEGIN
               //copy the information
               SCULen:=TempSCULen;
               GetMem(SCUInfo,SCULen);
               System.Move(TempSCUInfo^,SCUInfo^,SCULen);
          END;

          IF SCULen=0 THEN
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiNoSCUInfoForForm,[Name]));
               Command:=cmNull;
               ModalResult:=cmNull;
               exit;
          END;

          //Search editor in Name either in memory or on disk

          Editor:=GetEditor(Name);
          IF Editor<>NIL THEN
          BEGIN
               Memory.Create;
               IF Editor.SaveToStream(Memory) THEN
               BEGIN
                    EditorLen:=Memory.Size;
                    GetMem(EditorInfo,EditorLen);
                    System.Move(Memory.Memory^,EditorInfo^,EditorLen);
               END;
               Memory.Destroy;
          END
          ELSE //load from Disk
          BEGIN
               System.Assign(Edit,Name);
               {$I-}
               Reset(Edit);
               {$I+}
               IF IoResult=0 THEN
               BEGIN
                    {$I-}
                    EditorLen:=FileSize(Edit);
                    {$I+}
                    IF IOResult=0 THEN
                    BEGIN
                         GetMem(EditorInfo,EditorLen);
                         {$I-}
                         BlockRead(Edit,EditorInfo^,EditorLen,Res);
                         {$I+}
                         IF ((IOResult<>0)OR(Res<>EditorLen)) THEN
                         BEGIN
                              FreeMem(EditorInfo,EditorLen);
                              EditorLen:=0;
                         END;
                    END
                    ELSE EditorLen:=0;

                    {$I-}
                    System.Close(Edit);
                    {$I+}
               END;
          END;

          IF EditorLen=0 THEN
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[Name]));
               FreeMem(SCUInfo,SCULen);
               ModalResult:=cmNull;
               exit;
          END;

          FileName:=ParamStr(0);
          FSplit(FileName,Dir,Name,ext);
          FileName:=Dir+'SIBYL.FRM';

          System.Assign(f,FileName);
          {$i-}
          Reset(f);
          {$I+}
          IF IoResult=0 THEN //file exists
          BEGIN
               //check if the title already exists
               Err:=FALSE;
               TRY
                  BlockRead(f,Temp,4,Res);
                  IF Res<>4 THEN Raise EInOutError.Create('');
                  WHILE Temp<>0 DO
                  BEGIN
                       BlockRead(f,b,1,Res);  //length of Title
                       IF Res<>1 THEN Raise EInOutError.Create('');
                       Name[0]:=chr(b);
                       BlockRead(f,Name[1],b,Res);
                       IF Res<>b THEN Raise EInOutError.Create('');
                       IF Name=FTitle.Text THEN
                       BEGIN
                            ErrorBox(LoadNLSStr(SiTitleOfObjAlreadyUsed));
                            {$I-}
                            System.Close(f);
                            {$I+}
                            Command:=cmNull;
                            ModalResult:=cmNull;
                            Err:=TRUE;
                            break;
                       END;

                       Seek(f,Temp); //start of next entry
                       BlockRead(f,Temp,4,Res);
                       IF Res<>4 THEN Raise EInOutError.Create('');
                  END;
                  Seek(f,FilePos(f)-4);
               EXCEPT
                  ErrorBox(LoadNLSStr(SiSIBYLFRMCorrupt));
                  {$I-}
                  System.Close(f);
                  Rewrite(f);
                  {$I+}
                  IF IOResult<>0 THEN
                  BEGIN
                       ErrorBox(FmtLoadNLSStr(SiFileCreateError,[FileName]));
                       Command:=cmNull;
                       ModalResult:=cmNull;
                       Err:=TRUE;
                  END;
               END;

               IF Err THEN
               BEGIN
                    FreeMem(SCUInfo,SCULen);
                    FreeMem(EditorInfo,EditorLen);
                    ModalResult:=cmNull;
                    exit;
               END;
          END
          ELSE
          BEGIN //create new file
               {$I-}
               Rewrite(f);
               {$I+}
               IF IoResult<>0 THEN
               BEGIN
                    ErrorBox(FmtLoadNLSStr(SiFileCreateError,[FileName]));
                    Command:=cmNull;
                    FreeMem(SCUInfo,SCULen);
                    FreeMem(EditorInfo,EditorLen);
                    exit;
               END;
          END;

          TRY
             PatchPos:=FilePos(f);

             //write length of this section (patched later)
             Temp:=0;
             BlockWrite(f,Temp,4);

             Name:=FTitle.Text;
             BlockWrite(f,Name,length(Name)+1);
             Name:=FPage.Text;
             BlockWrite(f,Name,length(Name)+1);

             b:=1;
             BlockWrite(f,b,1);   //InstalledInPage
             BlockWrite(f,b,1);   //PageInstalled
             b:=0;
             BlockWrite(f,b,1);   //NewProject=FALSE
             BlockWrite(f,b,1);   //NewForm=FALSE
             BlockWrite(f,b,1);   //MainForm=FALSE

             //write icon
             Memory.Create;
             TRY
                FIcon.SaveToStream(Memory);
             EXCEPT
                Memory.Destroy;
                Memory:=NIL;
                ErrorBox(LoadNLSStr(SiErrorWritingBitmap));
                {$I-}
                System.Close(f);
                {$I+}
                ModalResult:=cmNull;
                Command:=cmNull;
             END;

             IF Memory<>NIL THEN
             BEGIN
                 Temp:=Memory.Size;
                 BlockWrite(f,Temp,4);
                 BlockWrite(f,Memory.Memory^,Temp);
                 Memory.Destroy;
             END;

             Name:=FAuthor.Text;
             BlockWrite(f,Name,length(Name)+1);

             pc:=FDescription.Lines.GetText;
             IF pc=NIL THEN
             BEGIN
                 Temp:=0;
                 BlockWrite(f,Temp,4);
             END
             ELSE
             BEGIN
                 Temp:=length(pc^)+1;
                 BlockWrite(f,Temp,4);
                 BlockWrite(f,pc^,Temp);
                 StrDispose(pc);
             END;

             //write SCU Information
             BlockWrite(f,SCULen,4);
             BlockWrite(f,SCUInfo^,SCULen);

             //write Unit Information
             BlockWrite(f,EditorLen,4);
             BlockWrite(f,EditorInfo^,EditorLen);

             //mark end of list
             Temp:=0;
             BlockWrite(f,Temp,4);

             Temp:=FilePos(f)-4;   //start of next entry
             Seek(f,PatchPos);
             BlockWrite(f,Temp,4);

             System.Close(f);
          EXCEPT
             ErrorBox(FmtLoadNLSStr(SiFileWriteError,[FileName]));
             Command:=cmNull;
             ModalResult:=cmNull;
             {$I-}
             System.Close(f);
             {$I+}
          END;

          FreeMem(SCUInfo,SCULen);
          FreeMem(EditorInfo,EditorLen);
     END;

     Inherited CommandEvent(Command);
END;


PROCEDURE AddFormToRepository(FormEditor:TForm);
VAR Dlg:TAddToRepositoryForm;
BEGIN
     InitSelectedForm := FormEditor;
     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogAddFormToRepository;
     Dlg.Execute;
     Dlg.Destroy;
END;

TYPE TSelectTempFormDlg=CLASS(TDialog)
         FDualList:TDualList;
         FEdit:TEdit;
         FRepForms:TList;
         FButton:TButton;
         FLabel:TLabel;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE BrowseClick(Sender:TObject);
     END;

PROCEDURE TSelectTempFormDlg.BrowseClick(Sender:TObject);
VAR Dlg:TSaveDialog;
BEGIN
     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogSaveFormTemplatesToFile;
     Dlg.Title:=LoadNLSStr(SiSaveFormTemplatesToFile);
     Dlg.AddFilter(LoadNLSStr(SiSibylFormTemplates)+' (*.FRM)','*.FRM');
     Dlg.DefaultExt:='*.FRM';
     IF Dlg.Execute THEN
     BEGIN
          FEdit.Text:=Dlg.FileName;
          FEdit.CaptureFocus;
     END;
     Dlg.Destroy;
END;


PROCEDURE TSelectTempFormDlg.CommandEvent(VAR Command:TCommand);
VAR t:LONGINT;
    dummy:PRepForm;
    FName:STRING;
BEGIN
     IF Command=cmOk THEN
     BEGIN
          IF FDualList.DstItems.Count=0 THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiYouMustSpecifyAForm));
               Command:=cmNull;
               exit;
          END;

          FName := FEdit.Text;

          IF FName='' THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiYouMustSpecifyAFileName));
               Command:=cmNull;
               exit;
          END
          ELSE
          BEGIN
               IF ExtractFileExt(FName) = '' THEN FName := FName + '.FRM';

               IF FButton<>NIL THEN   //not for Import Dialog !
               BEGIN
                    IF FileExists(FName) THEN
                    BEGIN
                         IF MessageBox(FmtLoadNLSStr(SiAreYouSureToReplace,[FName]),
                                       mtConfirmation,mbYesNo)=mrNo THEN
                         BEGIN
                              Command:=cmNull;
                              exit;
                         END;
                    END;
               END;
          END;

          FOR t:=FRepForms.Count-1 DOWNTO 0 DO
          BEGIN
               dummy:=FRepForms[t];
               IF FDualList.DstItems.IndexOf(dummy^.Name)<0 THEN
               BEGIN
                    FRepForms.Delete(t);

                    StrDispose(dummy^.Description);
                    FreeMem(dummy^.IconInfo,dummy^.IconLen);
                    FreeMem(dummy^.SCUInfo,dummy^.SCULen);
                    FreeMem(dummy^.EditInfo,dummy^.EditLen);
                    dispose(dummy);
               END;
          END;

          IF FButton=NIL THEN SaveRepFormTemplates('',FRepForms) //Import
          ELSE SaveRepFormTemplates(FName,FRepForms); //Export
     END;
END;


PROCEDURE TSelectTempFormDlg.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SiExportTemplateForms);
     Width:=430;
     Height:=320;
     FDualList:=InsertDualList(SELF,10,100,400,180,LoadNLSStr(SiAvailableTemplates),LoadNLSStr(SiTargetTemplates));

     FLabel:=InsertLabelNLS(SELF,10,75,100,20,SiTargetFile);
     FEdit:=InsertEdit(SELF,10,55,300,20,'','');

     FButton:=InsertButtonNLS(SELF,320,50,90,30,SiBrowse,0);
     FButton.OnClick:=BrowseClick;

     InsertBitBtnNLS(SELF,10,10,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,110,10,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,210,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;


PROCEDURE SaveTemplateForms;
VAR Dlg:TSelectTempFormDlg;
    dummy:PRepForm;
    t,t1:LONGINT;
BEGIN
     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogExportTemplateForms;

     Dlg.FRepForms:=GetRepFormTemplates('');
     FOR t:=0 TO Dlg.FRepForms.Count-1 DO
     BEGIN
          dummy:=Dlg.FRepForms[t];
          Dlg.FDualList.SrcItems.Add(dummy^.Name);
     END;
     Dlg.Execute;
     FreeRepFormTemplates(Dlg.FRepForms);
     Dlg.Destroy;
END;


PROCEDURE LoadTemplateForms;
VAR Dlg:TOpenDialog;
    Dlg1:TSelectTempFormDlg;
    t:LONGINT;
    dummy:PRepForm;
BEGIN
     Dlg.Create(NIL);
     Dlg.HelpContext := hctxDialogOpenTemplateForms;
     Dlg.Title:=LoadNLSStr(SiLoadFormTemplatesFromFile);
     Dlg.AddFilter(LoadNLSStr(SiSibylFormTemplates)+' (*.FRM)','*.FRM');
     Dlg.DefaultExt:='*.FRM';
     IF Dlg.Execute THEN
     BEGIN
          Dlg1.Create(NIL);
          Dlg1.HelpContext := hctxDialogImportTemplateForms;
          Dlg1.Caption:=LoadNLSStr(SiImportTemplateForms);
          Dlg1.FButton.Destroy;
          Dlg1.FButton:=NIL;
          Dlg1.FEdit.Hide;
          Dlg1.FLabel.Hide;
          Dlg1.FDualList.Bottom:=55;
          Dlg1.FDualList.Height:=225;
          Dlg1.FEdit.Text:='SIBYL.FRM';
          Dlg1.FDualList.DstName:=LoadNLSStr(SiTemplatesToImport);
          Dlg1.FRepForms:=GetRepFormTemplates(Dlg.FileName);
          Dlg.Destroy;

          IF Dlg1.FRepForms.Count=0 THEN ErrorBox(FmtLoadNLSStr(SiFileContainsNoFormTemplates,[Dlg.FileName]))
          ELSE
          BEGIN
               FOR t:=0 TO Dlg1.FRepForms.Count-1 DO
               BEGIN
                   dummy:=Dlg1.FRepForms[t];
                   Dlg1.FDualList.SrcItems.Add(dummy^.Name);
               END;
               Dlg1.Execute;
          END;
          FreeRepFormTemplates(Dlg1.FRepForms);
          Dlg1.Destroy;
     END
     ELSE Dlg.Destroy;
END;


BEGIN
  Repository.Create;
  ToolsNotifyProc:=@IDEToolsNotify;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  11-Mar-05  WD         TNewObjDlg: Objekt "WDSibylHelp" eingebaut
  25-Mar-05  WD         TNewObjDlg: Objekt "Resource" eingebaut



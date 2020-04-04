
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ToolsAPI;

Interface

Uses Classes,Forms,Graphics,Editors,Menus,
     uStream,
     uString;

Type
  //Tools Service API. the Reference For This Class Is ToolServices And Is created by the SP/2
  //IDE ON Library Initialization
  TCreateModuleFlag = (cmfAddToProject,cmfShowSource,cmfShowForm,
                       cmfUnNamed,cmfNewUnit,cmfNewForm,cmfMainForm,cmfMarkModified,
                       cmfNewFile,cmfExisting);

  TCreateModuleFlags = Set Of TCreateModuleFlag;

  TProjectEnumProc = Function(Param: Pointer;Const FileName, UnitName,
                              FormName:String):Boolean;

  TFileNotification = (fnFileOpening, fnFileOpened, fnFileClosing,
                       fnProjectOpening, fnProjectOpened, fnProjectClosing, fnAddedToProject,
                       fnRemovedFromProject, fnDefaultDesktopLoad, fnDefaultDesktopSave,
                       fnProjectDesktopLoad, fnProjectDesktopSave, fnProjectSaved, fnFileSaved);

  TIMainMenuIntf = Class;

  TIAddInNotifier = Class
        Procedure FileNotification(NotifyCode: TFileNotification;
                                   Const FileName:String;Var Cancel:Boolean); Virtual;Abstract;
  End;

  TIModuleInterface=Class;

  TIToolServices = Class
    //Opens A New project. If PrjName Is Empty, Create A New, Empty project.
    Function OpenProject(Const PrjName:String):Boolean; Virtual;Abstract;
    //Extended Version Of OpenProject
    Function OpenProjectEx(Const PrjName:String;VisualProject,CreateNew:Boolean):Boolean;Virtual;Abstract;
    //Close project And return True ON Success
    Function CloseProject:Boolean; Virtual;Abstract;
    //determines If A named project can be opened, no Load
    Function OpenProjectInfo(Const PrjName:String):Boolean; Virtual;Abstract;
    //save Current project And return True ON Success
    Function SaveProject:Boolean; Virtual;Abstract;
    //returns True If specified File Is Open Or can be Loaded
    Function OpenFile(Const FileName:String):Boolean; Virtual;Abstract;
    //Closes Open Editor File, If it Is Not Open return also True
    Function CloseFile(Const FileName:String):Boolean; Virtual;Abstract;
    //Saves the specified files, If it Is Not Open return also True
    Function SaveFile(Const FileName:String):Boolean; Virtual;Abstract;
    //creates A New Module
    Function CreateModule(Const ModuleName:String;
                          Source, Form: TMemoryStream;
                          CreateFlags: TCreateModuleFlags):Boolean; Virtual;Abstract;
    //Extended Version Of CreateModule
    Function CreateModuleEx(Const ModuleName, FormName, AncestorClass:String;
                            Source, Form: TMemoryStream;
                            CreateFlags: TCreateModuleFlags):TIModuleInterface; Virtual;Abstract;
    //returns IDE Application Form
    Function GetParentForm:TForm; Virtual;Abstract;
    //returns Current project Name
    Function GetProjectName:String; Virtual;Abstract;
    //returns primary File Of project
    Function GetPrimaryFile:String;Virtual;Abstract;
    //returns Count Of units belonging To the Current project
    Function GetUnitCount:LongInt; Virtual;Abstract;
    //returns full Name Of project Unit With specified Index
    Function GetUnitName(Index:LongInt):String; Virtual;Abstract;
    //calls EnumProc For each Unit In the project
    Function EnumProjectUnits(EnumProc: TProjectEnumProc;Param: Pointer):Boolean; Virtual;Abstract;
    //return All files that belong To the Current project
    Procedure GetProjectFiles(AStrings:TStrings);Virtual;Abstract;
    //return Number Of available Forms In Current project
    Function GetFormCount:LongInt; Virtual;Abstract;
    //Get Name Of Form With specified Index
    Function GetFormName(Index:LongInt):String; Virtual;Abstract;
    //Get full Name Of Current File Or Form-Unit-File, Empty String If no File Is Active
    Function GetCurrentFile:String; Virtual;Abstract;
    //returns True If specified File Is Open
    Function IsFileOpen(Const FileName:String):Boolean; Virtual;Abstract;
    //Generate New Unit Name And File Name
    Function GetNewModuleName(Var UnitIdent,FileName:String):Boolean; Virtual;Abstract;
    //Get Count Of Currently installed Component modules (units)
    Function GetModuleCount:LongInt; Virtual;Abstract;
    //Get Component Unit Name With specified Index
    Function GetModuleName(Index:LongInt):String; Virtual;Abstract;
    //Get Component Count Of Component Unit With specified Index
    Function GetComponentCount(Index:LongInt):LongInt; Virtual;Abstract;
    //Get Component Name from Component Unit With specified Index
    Function GetComponentName(ModIndex,CompIndex:LongInt):String; Virtual;Abstract;
    //Get Interface For A File Loaded into the Editor
    Function GetModuleInterface(Const FileName:String):TIModuleInterface; Virtual;Abstract;
    //Get Interface For A Form And its associated Editor File
    Function GetFormModuleInterface(Const FormName:String):TIModuleInterface; Virtual;Abstract;
    //gets IDE main Menu
    Function GetMainMenu:TIMainMenuIntf; Virtual;Abstract;
    //Adds A Notification Proc
    //gets main Menu Handle - Use With care
    Function GetMainMenuHandle:TMenu;Virtual;Abstract;
    Function AddNotifier(AddInNotifier:TIAddInNotifier):Boolean; Virtual;Abstract;
    //Remove Notification Proc
    Function RemoveNotifier(AddInNotifier:TIAddInNotifier):Boolean; Virtual;Abstract;
    //Get Version Of the IDE
    Function GetVersion:LongInt; Virtual;Abstract;
  End;

  TIMenuItemIntf=Class;

  TIMenuFlag = (mfInvalid, mfEnabled, mfVisible, mfChecked, mfBreak, mfBarBreak,mfRadioItem);
  TIMenuFlags = Set Of TIMenuFlag;

  TIMenuClickEvent = Procedure(Sender:TIMenuItemIntf) Of Object;

  //note: All TIMainMenuIntf queried MUST be freed by the client !!
  TIMainMenuIntf = Class
    //returns Interface For IDE main Menu (Top Level)
    Function GetMenuItems: TIMenuItemIntf; Virtual;Abstract;
    //returns Interface For Menu Item Or Submenu With specified Name
    Function FindMenuItem(Const MenuName:String):TIMenuItemIntf; Virtual;Abstract;
  End;

  //note: All TIMenuItemIntf queried MUST be freed by the client !!
  TIMenuItemIntf = Class
    //Destroys Menu Item associated With the Interface, returns False If the Item was created by IDE
    Function DestroyMenuItem:Boolean; Virtual;Abstract;
    //Get Index Of This Item within the Menu Tree
    Function GetIndex:LongInt; Virtual;Abstract;
    //Get Count Of submenus For This Interface
    Function GetItemCount:LongInt; Virtual;Abstract;
    //Get Submenu Item With specified Index
    Function GetItem(Index:LongInt):TIMenuItemIntf; Virtual;Abstract;
    //Get (internal !) Name Of Menu associated With Interface, See also GetCaption
    Function GetName:String; Virtual;Abstract;
    //Get parent Interface Of Item Or Nil
    Function GetParent: TIMenuItemIntf; Virtual;Abstract;
    //Get Caption Of Menu associated With the Interface
    Function GetCaption:String; Virtual;Abstract;
    //Set Caption Of Menu associated With the Interface
    Function SetCaption(Const Caption:String):Boolean; Virtual;Abstract;
    //Get ShortCut Of Menu
    Function GetShortCut:TKeyCode; Virtual;Abstract;
    //Set ShortCut Of Menu
    Function SetShortCut(ShortCut:TKeyCode):Boolean; Virtual;Abstract;
    //Get Flags Of Menu
    Function GetFlags:TIMenuFlags; Virtual;Abstract;
    //Set Flags Of Menu
    Function SetFlags(Mask,Flags: TIMenuFlags):Boolean; Virtual;Abstract;
    //Get Hint Of Menu
    Function GetHint:String; Virtual;Abstract;
    //Set Hint Of Menu
    Function SetHint(Hint:String):Boolean; Virtual;Abstract;
    //Get help context Of Menu
    Function GetContext:THelpContext; Virtual;Abstract;
    //Set help context For Menu
    Function SetContext(context:THelpContext):Boolean; Virtual;Abstract;
    //Get OnClick event For the Menu
    Function GetOnClick:TIMenuClickEvent; Virtual;Abstract;
    //Set OnClick event For the Menu
    Function SetOnClick(Click:TIMenuClickEvent):Boolean; Virtual;Abstract;
    //inserts an Item
    Function InsertItem(Index:LongInt;Caption,Name,Hint:String;
                        ShortCut:TKeyCode;context:THelpContext;Flags:TIMenuFlags;
                        EventHandler:TIMenuClickEvent):TIMenuItemIntf; Virtual;Abstract;
    //Get Menu Item associates With the Interface - Use With care !
    Function GetMenuEntry:TMenuItem; Virtual;Abstract;
  End;

  TNotifyCode = (ncModuleDeleted, ncModuleRenamed, ncEditorModified,
                 ncFormModified, ncEditorSelected, ncFormSelected, ncBeforeSave,
                 ncAfterSave, ncFormSaving, ncProjResModified);

  TIModuleNotifier=Class
    Procedure notify(NotifyCode:TNotifyCode); Virtual;Abstract;
    Procedure ComponentRenamed(ComponentHandle:Pointer;
                               Const OldName,NewName:String); Virtual;Abstract;
  End;

  TIEditorInterface=Class;
  TIFormInterface=Class;

  //represents File And Forms Open In A project
  //note: All TIModuleInterface queried MUST be freed by the client !!
  TIModuleInterface=Class
    //Get Editor Interface For the Module Or Nil
    Function GetEditorInterface:TIEditorInterface; Virtual;Abstract;
    //Get Form Interface For the Module Or Nil
    Function GetFormInterface:TIFormInterface; Virtual;Abstract;
    //Close the Module without Saving (See save)
    Function Close:Boolean; Virtual;Abstract;
    //Saves the Module, If forcesave Is True, the user will Not be asked
    Function save(forcesave: Boolean):Boolean; Virtual;Abstract;
    //Rename Module
    Function Rename(Const NewName:String):Boolean; Virtual;Abstract;
    //Show Source File Of Editor In topmost Editor Window
    Function ShowSource:Boolean; Virtual;Abstract;
    //Show Form Of Module If present
    Function ShowForm:Boolean; Virtual;Abstract;
    //Add Notification Proc
    Function AddNotifier(AModuleNotifier:TIModuleNotifier):Boolean; Virtual;Abstract;
    //Remove Notification Proc
    Function RemoveNotifier(AModuleNotifier:TIModuleNotifier):Boolean; Virtual;Abstract;
  End;

  TEditPos = Record
    Col: SMALLINT;
    Line: LongInt;
  End;

  TSyntaxHighlighter = (shNone, shPascal, shSQL, shQuery);

  //represents Editor File opened
  //note: All TIEditorInterface queried MUST be freed by the client !!
  TIEditorInterface=Class
    //gets Text At specified Position
    Function GetText(Position:LongInt;Var Buffer;BufSize:LongInt):LongInt;Virtual;Abstract;
    //copies Text from actual Position To Pos into the Clipboard
    Function CopyTo(Pos:LongInt):Boolean; Virtual;Abstract;
    //deletes Text from actual positon To Pos into the Clipboard
    Function DeleteTo(Pos:LongInt):Boolean; Virtual;Abstract;
    //Insert specified Text At Current Position
    Function Insert(Var Buffer;BufSize:LongInt):Boolean; Virtual;Abstract;
    //Get Editor Position
    Function Position: LongInt; Virtual;Abstract;
    //Get File Name Of Editor
    Function FileName:String; Virtual;Abstract;
    //Get total Lines Of edit Buffer
    Function LinesInBuffer:LongInt; Virtual;Abstract;
    //returns True If edit Buffer was Modified
    Function BufferModified:Boolean; Virtual;Abstract;
    //Forces the Editor To be Modified
    Function MarkModified:Boolean; Virtual;Abstract;
    //sets color Table
    Function SetSyntaxHighlighter(SyntaxHighlighter:TSyntaxHighlighter):TSyntaxHighlighter;Virtual;Abstract;
    //Get Editor Position
    Function GetPos:TEditPos; Virtual;Abstract;
    //Set Editor positon
    Procedure SetPos(Value: TEditPos); Virtual;Abstract;
    //Get Editor Form Instance - Use With care !
    Function GetEditorForm:TEditor; Virtual;Abstract;

    Property CursorPos: TEditPos Read GetPos Write SetPos;
  End;

  TIComponentInterface=Class;

  //represents Form inside designer
  //note: All TIFormInterface queried MUST be freed by the client !!
  TIFormInterface=Class
    //returns Unit File Name For the Form
    Function FileName:String; Virtual;Abstract;
    //returns True If the Form Is Modified
    Function FormModified:Boolean; Virtual;Abstract;
    //Forces the Form To be marked As Modified
    Function MarkModified:Boolean; Virtual;Abstract;
    //Get Component Interface For the Form
    Function GetFormComponent:TIComponentInterface; Virtual;Abstract;
    //Get Form Instance For the Form - Use With care !
    Function GetFormInstance:TForm; Virtual;Abstract;
    //Find Component by Name And return Interface
    Function FindComponent(Const Name:String):TIComponentInterface; Virtual;Abstract;
    //Get Component Interface from Instance
    Function GetComponentFromHandle(ComponentHandle:TObject):TIComponentInterface; Virtual;Abstract;
    //Get Selection Count In Form Editor
    Function GetSelCount:LongInt; Virtual;Abstract;
    //Get Selected Component Interface from Index
    Function GetSelComponent(Index:LongInt):TIComponentInterface; Virtual;Abstract;
    //gets parent Interface that created the Form
    Function GetCreateParent: TIComponentInterface; Virtual;Abstract;
    //Create New Component, If containter Is Not Nil, it Is the parent, If Name Is Empty, it Is auto-created
    Function CreateComponent(Container: TIComponentInterface;Const TypeName,Name:String;
                             X,Y,W,H:LongInt):TIComponentInterface; Virtual;Abstract;
  End;

  TPropertyType = (ptUnknown, ptInteger, ptChar, ptEnumeration, ptFloat,
                   ptString, ptSet, ptClass, ptMethod, ptWChar, ptLString, ptLWString,
                   ptVariant,ptBoolean,ptCString,ptClassRef,ptRecord);

  TGetChildCallback = Function(Param:Pointer;ComponentInterface:TIComponentInterface):Boolean;

  //represents Components inside A Form
  //note: All TIComponentInterface queried MUST be freed by the client !!
  TIComponentInterface=Class
    //returns Component Type As String
    Function GetComponentType:String; Virtual;Abstract;
    //returns Component Instance - Use With care !
    Function GetComponentHandle:TComponent; Virtual;Abstract;
    //returns parent Interface
    Function GetParent:TIComponentInterface; Virtual;Abstract;
    //returns True If Interface Is A descendant Of TControl
    Function IsTControl:Boolean; Virtual;Abstract;
    //returns Property Count For the Interface Instance
    Function GetPropCount:LongInt; Virtual;Abstract;
    //Get Property Name from Index
    Function GetPropName(Index:LongInt):String; Virtual;Abstract;
    //Get Property Type from Index
    Function GetPropType(Index:LongInt;Var TypeLen:LongInt):TPropertyType; Virtual;Abstract;
    //Get Property Type from Name
    Function GetPropTypeByName(Const Name:String;Var TypeLen:LongInt):TPropertyType; Virtual;Abstract;
    //gets Property Value from Index
    Function GetPropValue(Index:LongInt;Var Value):Boolean; Virtual;Abstract;
    //gets Property Value from Name
    Function GetPropValueByName(Const Name:String;Var Value):Boolean; Virtual;Abstract;
    //sets Property from Index
    Function SetProp(Index:LongInt;Const Value):Boolean; Virtual;Abstract;
    //sets Property from Name
    Function SetPropByName(Const Name:String;Const Value):Boolean; Virtual;Abstract;
    //Enums component's Children
    Function GetChildren(Param:Pointer;Proc:TGetChildCallback): Boolean; Virtual;Abstract;
    //Get Count Of Child Controls
    Function GetControlCount:LongInt; Virtual;Abstract;
    //Get Control from Index
    Function GetControl(Index:LongInt):TIComponentInterface; Virtual;Abstract;
    //Get Count Of Child Components
    Function GetComponentCount:LongInt; Virtual;Abstract;
    //Get Child Component from Index
    Function GetComponent(Index:LongInt):TIComponentInterface; Virtual;Abstract;
    //Select Component
    Function Select: Boolean; Virtual;Abstract;
    //Focus Component
    Function Focus: Boolean; Virtual;Abstract;
    //Delete Component
    Function Delete: Boolean; Virtual;Abstract;
    //Set event Property And Add Some Code To it (optional)
    Function SetEventProperty(Const PropertyName,MethodName:String;Code:TStream):Boolean;Virtual;Abstract;
    //Get method Name Of A event Property
    Function GetEventProperty(Const PropertyName:String):String;Virtual;Abstract;
  End;

  //Expert interfaces - provided by client, created And destroyed by IDE
  TExpertStyle = (esStandard, esForm, esProject, esAddIn);
  TExpertState = Set Of (esEnabled, esChecked);

  TIExpert=Class(TComponent)
    //Required: returns Name Of Expert
    Function GetName:String; Virtual;Abstract;
    //Required For styles esForm And esProject: returns author Of Expert
    Function GetAuthor:String; Virtual;Abstract;
    //Required For styles esForm And esProject: returns comment Of Expert
    Function GetComment:String; Virtual;Abstract;
    //Required For styles esForm And esProject: returns page For repository, Empty String For Default
    Function GetPage:String; Virtual;Abstract;
    //Required For styles esForm And esProject: returns Bitmap For Expert, Nil For Default
    Function GetGlyph: TBitmap; Virtual;Abstract;
    //Required: returns Style Of Expert
    Function GetStyle: TExpertStyle; Virtual;Abstract;
    //Required If Style Is esStandard: returns Menu State Of Expert
    Function GetState: TExpertState; Virtual;Abstract;
    //Required: returns UNIQUE IDString Of Expert. Supposed format Is: CompanyName.ExpertFunction, ex. SpeedSoft.AppExpert
    Function GetIDString:String; Virtual;Abstract;
    //Required If Style Is esStandard:returns Menu Text For Expert
    Function GetMenuText:String; Virtual;Abstract;
    //Required If Style Is esForm,esStandard Or esProject: called whenever project Is invoked
    Procedure Execute; Virtual;Abstract;
    //Required: Is called whenever the IDE registeres This Expert
    Procedure Register; Virtual;Abstract;
    //Required: Is called whenever the IDE unloads This Expert. the Expert Is destroyed after This call
    Procedure Unload; Virtual;Abstract;
  End;

  TIExpertClass=Class Of TIExpert;

Const
   ToolServices:TIToolServices=Nil;

Procedure RegisterLibraryExperts(Experts:Array Of TIExpertClass);
Procedure FreeAllLibraryExperts;

Implementation

Procedure RegisterLibraryExperts(Experts:Array Of TIExpertClass);
Var T:LongInt;
Begin
  For T:=0 To High(Experts) Do LibExperts.Add(Experts[T]);
End;

Procedure FreeAllLibraryExperts;
Var T:LongInt;
    Expert:TIExpert;
Begin
  LibExperts.Clear;
  For T:=0 To LibExpertInstances.Count-1 Do
    Begin
      Expert:=TIExpert(LibExpertInstances.Items[T]);
      Expert.Unload;
      Expert.Destroy;
    End;
  LibExpertInstances.Clear;
End;

Procedure RegisterToolsAPI(ToolServ:TIToolServices);
Begin
     ToolServices:=ToolServ;
End;

Begin
     RegisterToolsAPIProc:=Pointer(@RegisterToolsAPI);
End.


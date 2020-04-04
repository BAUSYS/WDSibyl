
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

UNIT Sib_Prj;

INTERFACE

USES Dos,SysUtils,Color,Classes,Forms,Graphics,StdCtrls,ExtCtrls,ComCtrls,Outline,
     Dialogs,Buttons,Editors,ToolsApi,DockTool,
     Consts,Projects,BaseEdit,Sib_Ctrl,XplorBtn,DebugHlp,
     Menus, Messages,
     uSysInfo, uSysClass,
     uString, uList, uStream;

{$IFDEF OS2}
USES DbgWatch;
{$ENDIF}


TYPE
    TProjectFiles=CLASS;

    PProjectFile=^TProjectFile;
    TProjectFile=RECORD
         ExeExt:   STRING[4];
         CheckSum: LONGINT;
         Expanded: BOOLEAN;
         ASub:     TProjectFiles;
         AParent:  TProjectFiles;
    END;


    TProjectFiles=CLASS(TStringList)
      PRIVATE
         PROCEDURE DestroyItem(ppf:PProjectFile);
         FUNCTION AddFile(Name:STRING;Expanded:BOOLEAN):PProjectFile;
         FUNCTION InsertFile(idx:LONGINT;Name:STRING;Expanded:BOOLEAN):PProjectFile;
      PUBLIC
         FUNCTION FindFile(Name:STRING):LONGINT;
         PROCEDURE Clear;OVERRIDE;
    END;


    TProjectForms=CLASS(TList)
      PUBLIC
         PROCEDURE FreeItem(Item:POINTER); OVERRIDE;
    END;


    TFileStringList=CLASS(TStringList)
      PUBLIC
         MaxSave:LONGINT;
      PUBLIC
         FUNCTION ReadFromSPR(FileName,Section,Ident:STRING):BOOLEAN;
         FUNCTION WriteToSPR(FileName,Section,Ident:STRING;cut:BOOLEAN):BOOLEAN;
    END;


    TGlobalMacroList=CLASS(TStringList)
      PUBLIC
         ListChanged:BOOLEAN;
      PROTECTED
         PROCEDURE Changing;OVERRIDE;
      PUBLIC
         PROCEDURE FreeItem(AObject:TObject);OVERRIDE;
         FUNCTION LoadEditorMacros:BOOLEAN;
         FUNCTION SaveEditorMacros:BOOLEAN;
    END;


    TGlobalToolList=CLASS(TList)
      PUBLIC
         PROCEDURE EvToolClick(Sender:TObject);
    END;


(***************************************************************************)

    TProject=CLASS
      PUBLIC
         Version:         STRING[FileSignaturSize-1];
         FileName:        STRING;
         Settings:        TProjectSettings;
         Files:           TProjectFiles;   {linear rekursiv}
         Forms:           TProjectForms;   {linear}
         LastSCUStream:   TMemoryStream;
         FindHistory:     TFileStringList; {linear}
         Find2History:    TFileStringList;
         ReplHistory:     TFileStringList;
         FilesHistory:    TFileStringList;
         ReadOnlyFiles:   TFileStringList;
         BrowserFiles:    TFileStringList;
         BookmarkList:    TStringList;     {Name|File,Line}
         CmdLineFiles:    TStringList;     {Namen aus der Kommandozeile}
         LastOpenFiles:   TStringList;     {temporr zw. Load und Execute}
         FModified:       BOOLEAN;
         Untitled:        BOOLEAN;
         FSCUModified:    BOOLEAN;
         NeedRecompile:   BOOLEAN;
         Loading:         BOOLEAN;
         Closing:         BOOLEAN;
         SCUSaving:       BOOLEAN;
      PRIVATE
         FUNCTION GetName:STRING;
         PROCEDURE SetModified(Value:BOOLEAN);
         PROCEDURE SetSCUModified(Value:BOOLEAN);
         PROCEDURE EvDocking(Sender:TObject;VAR TargetForm:TForm;
                             VAR NewAlign:TToolbarAlign);
         PROCEDURE EvPaletteClick(Sender:TObject);
         PROCEDURE EvPaletteProperties(Sender:TObject);
      PUBLIC
         CONSTRUCTOR Create; VIRTUAL;
         DESTRUCTOR Destroy; OVERRIDE;
         PROCEDURE Initialize;
         FUNCTION Close:BOOLEAN;
         FUNCTION Load(fn:STRING):BOOLEAN;
         FUNCTION LoadSCU(scu:STRING):BOOLEAN;
         FUNCTION Save(fn:STRING):BOOLEAN;
      PUBLIC
         PROPERTY Name:STRING read GetName;
         PROPERTY Modified:BOOLEAN read FModified write SetModified;
         PROPERTY SCUModified:BOOLEAN read FSCUModified write SetSCUModified;
    END;


{############################################################################}

    {Allgemeine Einstellungen der IDE ins INI File}
CONST
  MaxConf         = 2;

  MinEditorWidth  = 200;
  MinEditorHeight = 100;


  {Browser Buttons = Bitmap Ids}
  Browser_Constants  = 1438;
  Browser_Procedures = 1439;
  Browser_Types      = 1440;
  Browser_Variables  = 1441;
  Browser_Properties = 1442;
  Browser_Inherited  = 1443;
  Browser_Virtual    = 1444;
  Browser_Private    = 1445;
  Browser_Protected  = 1446;
  Browser_Public     = 1447;
  Browser_Published  = 1448;

VAR
  BrowserHints:ARRAY[Browser_Constants..Browser_Published] OF STRING[30];

CONST // nicht eindeutschen
  ObjectRepositoryString = '[Object Repository]';
  DependenciesString     = '[Dependencies]';
  Dependencies           = 'Dependencies';

  FileDialogWildCards:ARRAY[1..7] OF STRING[5] =
      (ALL_FILES,                // '*.*',
       ALL_FILES_UC_PASCAL,         // '*' + EXT_PASCAL,
       ALL_FILES_UC_INC,            // '*' + EXT_INC,
       ALL_FILES_UC_RC,             // '*' + EXT_RC,
       ALL_FILES_UC_WDSibyl_Help,   // '*' + EXT_WDSibyl_Help,
       ALL_FILES_UC_WDSibyl_SCL,    // '*' + EXT_WDSibyl_SCL,
       ALL_FILES_UC_ASM);           // '*' + EXT_ASM);

  LastFileDialogWildCardIndex:LONGINT=2;

  ISOLatin1WildCardIndex:LONGINT=7;

TYPE
  TCompilerActions=(Action_Compile,Action_Make,Action_Build,Action_CompLib);

TYPE
  PCodeTemplate=^TCodeTemplate;
  TCodeTemplate=RECORD
    Name:STRING;
    Description:STRING;
    Strings:TStringList;
  END;

  TCodeInsight = RECORD
    TimerValue: LONGINT;
    CodeCompletion: BOOLEAN;
    CodeParameter: BOOLEAN;
    ToolTips: BOOLEAN;
  END;


  TBrowseMode = (mo_Objects, mo_Globals, mo_Units);

  TBrowseFiles = SET OF (bf_RTL, bf_SPCC, bf_Project);

  TBrowse=RECORD
    DetailWindowWidth: LONGINT;
    ViewMode: TBrowseMode;
    Buttons: ARRAY[Browser_Constants..Browser_Published] OF BOOLEAN;
    Files: TBrowseFiles;
  END;


  TInspect = RECORD
    PropertyNameSize: LONGINT;
    EventNameSize: LONGINT;
  END;


  TCPUWin = RECORD
    DumpNoteBookHeight: LONGINT;
    RegNoteBookWidth: LONGINT;
  END;


  TPrjMan = RECORD
    FormListSize: LONGINT;
  END;


  PEditCol = ^TEditCol;
  TEditCol = RECORD
    fg: LONGINT;
    bg: LONGINT;
    flag: BYTE;
  END;

  TEditColors = RECORD
    Comment1: TEditCol;
    Comment2: TEditCol;
    Comment3: TEditCol;
    Comment4: TEditCol;
    Comment5: TEditCol;
    ReservedWord: TEditCol;
    PlainText: TEditCol;
    Symbol: TEditCol;
    Strings: TEditCol;
    Number: TEditCol;
    AsmBlock: TEditCol;
    MarkedBlock: TEditCol;
    SearchMatch: TEditCol;
    ValidBreak: TEditCol;
    InvalidBreak: TEditCol;
    ExecPoint: TEditCol;
    ErrorLine: TEditCol;
    RightMargin: TEditCol;
  END;

  TColors = RECORD
    Editor: TEditColors;
  END;


  TFonts = RECORD
    ApplicationFont: STRING;
    InspectorFont: STRING;
    NavigatorFont: STRING;
    EditorTabFont: STRING;
    EditorFont: STRING;
  END;


  TEditCursor = (ec_Underline, ec_Vertical);

  TEditMouse = (em_Arrow, em_IBeam);

  TEditKeyMap = (km_WordStar, km_CUA, km_Default, km_Custom);

  TEditOptions = SET OF (eo_InsertMode, eo_AutoIndent, eo_Unindent,
    eo_CursorClimb, eo_2ClickLine, eo_PersistentBlock, eo_OverwriteBlock,
    eo_UndoGroups, eo_WordWrap, eo_SmartTabs, eo_AddIndent, eo_AutoBracket,
    eo_HomeFirstWord);

  TEditBehaviour = SET OF (eb_Backups, eb_AppendBAK, eb_TextFromCursor,
    eb_ChangeDirOnOpen, eb_FullNameTitle, eb_AutoSave, eb_SyntaxHigh);

  TEditSelection = (es_NonInclusive, es_Column);

  TIdentifierStyle = (is_Uppercase, is_Lowercase, is_Mixed);

  TSourceCodeGen = RECORD
    IdentifierStyle: TIdentifierStyle;
    IndentBlock: LONGINT;
    IndentScope: LONGINT;
    IndentField: LONGINT;
    IndentSpace: LONGINT;
    LineBreak: LONGINT;
  END;

  TCodeEditorStyle = (cs_TabSet, cs_MDI);

  TFindDirection = (fd_Forward, fd_Backward);

  TFindOrigin = (fo_EntireScope, fo_Cursor);

  TFindScope = (fs_Global, fs_Selection, fs_AllEditors);

  TFindOptions = SET OF (fo_CaseSensitive, fo_WordsOnly);

  TFindReplace = RECORD
    Find: STRING;
    Replace: STRING;
    Direction: TFindDirection;
    Origin: TFindOrigin;
    Scope: TFindScope;
    Options: TFindOptions;
    Confirm: BOOLEAN;
    ReplAll: BOOLEAN;
  END;

  TEditorOptions = RECORD
    Cursor: TEditCursor;
    Mouse: TEditMouse;
    KeyMap: TEditKeyMap;
    Options: TEditOptions;
    Behaviour: TEditBehaviour;
    Select: TEditSelection;
    TabulatorSize: LONGINT;
    UndoEvents: LONGINT;
    SaveEvents: LONGINT;
    WrapColumn: LONGINT;
    FindStruct: TFindReplace;
    ReplStruct: TFindReplace;
    Style: TCodeEditorStyle;
  END;

  TCompInsertMode = (ci_DropSize, ci_DropMove);

  TCompMultiSelectMode = (cs_Include, cs_Touch);

  TFormDesign = RECORD
    GridWidth: LONGINT;
    GridHeight: LONGINT;
    GridActive: BOOLEAN;
    GridVisible: BOOLEAN;
    InsertMode: TCompInsertMode;
    MultiSelectMode: TCompMultiSelectMode;
    AutoCreateForm: BOOLEAN;
  END;


  TAutoSave = SET OF (as_Project, as_EditorFiles, as_SCU, as_INI);

  TAutoRename = SET OF (ar_Unit, ar_Uses, ar_SCU, ar_FormLocation,
    ar_ProjectFiles);


  {bei nderungen, Hide/ShowSibylForms anpassen und dwi_LastForm}
  TDesktopWinId = (dwi_MainWindow, dwi_CodeEditor, dwi_Inspector,
    dwi_CompList, dwi_WindowList, dwi_Browser, dwi_MacroList,
    dwi_ClipBoardList, dwi_CPUWindow, dwi_ProjectManager);


  TDesktopWinInfo = RECORD
    X,Y,CX,CY: LONGINT;
    Visible  : BOOLEAN;
    FormName : String;
    Form     : POINTER;
    InitProc : POINTER;
  END;


  TDroppingFile = (df_Import, df_Open);


  TStaticToolbars = SET OF (st_Speedbar, st_CompPalette, st_Statusbar);


  TFindFiles = RECORD
    LastFilter: STRING;
    LastPath: STRING;
    Recursive: BOOLEAN;
    CaseSense: BOOLEAN;
    WordsOnly: BOOLEAN;
  END;


  TIdeSettings = RECORD
    Modified: BOOLEAN;
    InstallDir: STRING;
    BinDir: STRING;
    LastProject: STRING;
    ProjectDir: STRING;
    TemplateDir  : String;
    MacroFileName: STRING;
    OpenMsgView: BOOLEAN;
    GlobalHints: BOOLEAN;
    TipNumber: LONGINT;
    FlatButtons: BOOLEAN;
    EnableSound: BOOLEAN;
    ShowBitBtnGlyph: BOOLEAN;
    EditorIconbar: BOOLEAN;
    LoadLastPrj: BOOLEAN;
    AskRecompile: BOOLEAN;
    DroppingFile: TDroppingFile;
    Colors: TColors;
    Fonts: TFonts;
    CodeInsight: TCodeInsight;
    EditOpt: TEditorOptions;
    CodeGen: TSourceCodeGen;
    Inspect: TInspect;
    CPUWin: TCPUWin;
    Browse: TBrowse;
    PrjMan: TPrjMan;
    Designer: TFormDesign;
    AutoSave: TAutoSave;
    AutoRename: TAutoRename;
    StaticToolbars: TStaticToolbars;
    SpeedbarWidth: LONGINT;
    ScreenWidth: LONGINT;
    ScreenHeight: LONGINT;
    FindFiles: TFindFiles;
    DesktopWindows: ARRAY[TDesktopWinId] OF TDesktopWinInfo;

    { Compiler }
    CompilerPriority    : TThreadPriority;
    HelpCompilerFileName: tFileName;
    HelpCompilerLanguage: String;

    {Projekt Standards}
    CompOptOS2: TCompilerOptions;
    WarnOptOS2: TWarningOptions;
    LinkOptOS2: TLinkerOptions;
    MemSizesOS2: TMemorySizes;
    DebugOptOS2: TDebuggerOptions;
    DirectoriesOS2: TDirectories;
    CompOptWin: TCompilerOptions;
    WarnOptWin: TWarningOptions;
    LinkOptWin: TLinkerOptions;
    MemSizesWin: TMemorySizes;
    DebugOptWin: TDebuggerOptions;
    DirectoriesWin: TDirectories;
  END;


  PToolData = ^TToolData;
  TToolData = RECORD
    ToolName: STRING;
    FileName: STRING;
    Parameter: STRING;
    MenuItem: TMenuItem;
  END;


VAR
  TopToolButtonList:TList;
  BottomToolButtonList:TList;
  CodeTemplateList:TList;


CONST
  VisualDesktopWinSet: SET OF TDesktopWinId = [dwi_Inspector, dwi_CompList];



{Repository handling}
{falls diese Typen erweitert werden, folgende Prozeduren updaten}
{IDETOOLS.ClearRepository, SIB_PRJ.ReadRepository, SIB_PRJ.WriteRepository}
TYPE
    PRepositoryObject=^TRepositoryObject;
    TRepositoryObject=RECORD
         Flag:BYTE;
         IDName:^STRING;
         NewProject:BOOLEAN;       //Expert is called on new project
         NewForm:BOOLEAN;          //Expert is called on new form
         MainForm:BOOLEAN;         //Expert is used for main form
         InstalledInPage:BOOLEAN;  //if FALSE only in object repository
         Title:^STRING;
         Description:PChar;
         Author:^STRING;
         Instance:TIExpert;        //leave this NIL !
    END;

    PRepositoryPage=^TRepositoryPage;
    TRepositoryPage=RECORD
         Page:^STRING;
         PageInstalled:BOOLEAN;
         Objects:TList;            //of PRepositoryObject
    END;

Procedure InitSibPrjUnit;
PROCEDURE SetMainStatusText(s:STRING; fgc,bgc:TColor);
FUNCTION ChangeDir(dir:STRING):BOOLEAN;
PROCEDURE SetFileDialogTypes(CFOD:{$ifdef os2}TOpenDialog{$endif}
                                  {$ifdef win32}TSystemOpenSaveDialog{$endif});
FUNCTION ChangeDirOnOpen:BOOLEAN;

PROCEDURE AddMenuItem(s1:STRING; History:TStringList; Last1,LastN:LONGINT;
          cmParent:LONGINT; MaxMenu,MaxHistory:LONGINT);
PROCEDURE RemoveMenuItem(s1:STRING; History:TStringList; Last1,LastN:LONGINT;
          cmParent:LONGINT; MaxMenu,MaxHistory:LONGINT);
FUNCTION GetMenuItem(cm:TCommand; History:TStringList):STRING;

PROCEDURE SetMainMenuShortCuts(KeyMap:TEditKeyMap);
FUNCTION ReadOnlyFileIndex(s:STRING):LONGINT;
PROCEDURE AddToReadOnlyFiles(CONST s:STRING);
PROCEDURE RemoveFromReadOnlyFiles(CONST s:STRING);

FUNCTION AddProjectMain(AMain:STRING):BOOLEAN;
FUNCTION AddProjectUnit(AMain,AUnit:STRING):BOOLEAN;
FUNCTION AddProjectDependency(AMain,AUnit:STRING):BOOLEAN;
FUNCTION RemoveProjectMain(AMain:STRING):BOOLEAN;
FUNCTION RemoveProjectUnit(AMain,AUnit:STRING):BOOLEAN;
FUNCTION ExistProjectMain(AMain:STRING):BOOLEAN;
FUNCTION ExistProjectUnit(AMain,AUnit:STRING):BOOLEAN;
FUNCTION DataProjectMain(AMain:STRING):PProjectFile;
FUNCTION DataProjectUnit(AMain,AUnit:STRING):PProjectFile;
FUNCTION ClearProjectDependencies(AMain:STRING):BOOLEAN;
PROCEDURE RenameProjectFiles(oldname,newname:STRING);
PROCEDURE SetPrimaryFile(CONST s:STRING);

FUNCTION AddProjectForm(CONST FormName,UnitName:STRING;Form:TForm):PFormListItem;
FUNCTION RemoveProjectForm(CONST FormName:STRING):BOOLEAN;
FUNCTION RenameProjectForm(CONST OldFormName,NewFormName:STRING):BOOLEAN;
FUNCTION CloseForm(Form:TComponent):BOOLEAN;

PROCEDURE InitializeINI;
FUNCTION LoadINI(VAR IdeSet:TIdeSettings):BOOLEAN;
FUNCTION SaveINI(IdeSet:TIdeSettings):BOOLEAN;

FUNCTION AddPalettenItem(Palette:TControl;Cmd:TCommand):TControl;
FUNCTION ReadToolbars:BOOLEAN;

FUNCTION SaveFiles(OnlyModified:BOOLEAN):BOOLEAN;
FUNCTION SaveProject(all:BOOLEAN):BOOLEAN;
FUNCTION SaveProjectAs(all:BOOLEAN):BOOLEAN;
FUNCTION DefaultProject(CONST Name:STRING;ReloadCompLib,CreateEmptyForm:BOOLEAN):BOOLEAN;
FUNCTION CloseProject(ReloadCompLib:BOOLEAN):BOOLEAN;
FUNCTION NewProject(s:STRING; Template:STRING):BOOLEAN;
FUNCTION OpenProject(s:STRING;ReloadCompLib:BOOLEAN):BOOLEAN;
FUNCTION CloseCurrentProject:BOOLEAN;
FUNCTION StartProject:BOOLEAN;
FUNCTION RestartProject:BOOLEAN;
FUNCTION ExecuteProject:BOOLEAN;
FUNCTION GetProjectSCUStream(VAR Memory:TMemoryStream):BOOLEAN;
FUNCTION SaveSCU:BOOLEAN;
FUNCTION ReadRepository(FileName:STRING):BOOLEAN;
FUNCTION NewFormHandle:TForm;
PROCEDURE InsertToolMenuItems;
PROCEDURE UpdateFormInitProcs;


FUNCTION GetInstallDir:STRING;
FUNCTION GetProjectDir:STRING;
FUNCTION GetBinDir:STRING;
FUNCTION GetOutDir(source:STRING):STRING;
function GetTemplateDir:String;
FUNCTION GetSCUName:STRING;
FUNCTION GetNAVName:STRING;
FUNCTION GetSCLName:STRING;
FUNCTION GetCompLibName:STRING;
FUNCTION GetShortCompLibName:STRING;
FUNCTION GetExeName:STRING;
FUNCTION GetMakeName:STRING;
FUNCTION GetCompileName:STRING;
function GetLngName:String;
FUNCTION GetUniqueFileName(CONST dir:STRING;name:STRING;nr:INTEGER;CONST ext:STRING):STRING;

CONST
    dwi_LastForm: TDesktopWinId = dwi_ProjectManager;
    CursorHome:TEditorPos=(Y:1;X:1);
    CursorIgnore:TEditorPos=(Y:-1;X:-1);
    Fokus:BOOLEAN=TRUE;
    NoFokus:BOOLEAN=FALSE;
    ShowIt:BOOLEAN=TRUE;
    DontShowIt:BOOLEAN=FALSE;
    StartEmptyForm:BOOLEAN=TRUE;
    ProjectLoaded:BOOLEAN=FALSE; {zeigt an, ob ein Projekt fertig geladen ist}
    CompilerActive:BOOLEAN=FALSE;
    SearchThread:TThread=NIL;
    INIname:STRING='';
    VDERestoring:BOOLEAN=FALSE;
    GridVisibleBtn:TSpeedButton=NIL;
    SnapToGridBtn:TSpeedButton=NIL;
    DesignPosBtn:TSpeedButton=NIL;
    AlignmentPalette:TDockingPalette=NIL;
    PalettenPopup:TPopupMenu=NIL;


VAR
    Project:TProject;
    IdeSettings:TIdeSettings;
    FormEditClass:TFormClass;
    LastDesignForm:TForm;
    ProjectsHistory:TStringList;
    FindInFilesHistory:TStringList;
    FindInFilesFilter:TStringList;
    FindInFilesPaths:TStringList;
    LastCloseProjectAnswer:TMsgDlgReturn;
    Repository:TList;  {of PRepositoryPage}
    ToolsList:TGlobalToolList;
    GlobalMacroList:TGlobalMacroList;

    SibylMainForm:TForm;
    SibylMainMenu:TMainMenu;
    StatusPanel:TPanel;                    {for CodeEditor}
    ProjectFilesTree:TProjectFilesOutline; {for ProjectManager}
    ProjectFormsList:TListBox;             {for ProjectManager}

    ErrPos:TEditorPos;
    ErrText:STRING;
    ErrName:STRING;
    ErrType:BYTE;

    NewFormWinProc:FUNCTION(UnitName:STRING):TForm;
    SetInspectorDataProc:PROCEDURE(Instance:TComponent);
    LoadEditorProc:FUNCTION(Name:STRING;x,y,w,h:LONGINT;LiX:BOOLEAN;fcx:TEditorPos;Fokus:BOOLEAN;ShowIt:BOOLEAN):TEditor;
    InitToolbarsProc:PROCEDURE;
    RemoveNavigatorProc:PROCEDURE;
    CloseCompLibProc:FUNCTION:BOOLEAN;
    DestroyNavigatorPagesProc:PROCEDURE;
    SetupNavigatorPagesProc:PROCEDURE;
    UpdateBrowserInfoProc:PROCEDURE(Immediate:BOOLEAN);
    ToolsNotifyProc:PROCEDURE(N:TFileNotification;CONST FileName:STRING;VAR Cancel:BOOLEAN);
    GenRemoveFormProc:PROCEDURE(Form:TForm);
    InitControlCentreProc:PROCEDURE(Panel:TDockingPalette);
    ClearBuildListProc:PROCEDURE;
    ClearFindInFilesListProc:PROCEDURE;
    CreateReferenceProc:FUNCTION(AOwner,AComponent:TComponent):TSpeedButton;
    ToolbarsDialogProc:PROCEDURE;

IMPLEMENTATION

VAR
  CXScreen  : LONGINT;
  CYScreen  : LONGINT;
  CYMainForm: LONGINT;

PROCEDURE SetMainStatusText(s:STRING; fgc,bgc:TColor);
VAR  Own:TControl;
BEGIN
     IF StatusPanel <> NIL THEN
     BEGIN
          IF StatusPanel.PenColor <> fgc THEN StatusPanel.PenColor := fgc;
          IF StatusPanel.Color <> bgc THEN StatusPanel.Color := bgc;
          IF StatusPanel.Caption <> s THEN
          BEGIN
               StatusPanel.Caption := s;
               Own := TControl(StatusPanel.Parent);
               IF Own IS TControl THEN Own.Update;
               { TypKonflikt
               IF StatusPanel.Parent IS TControl
               THEN TControl(StatusPanel.Parent).Update; }
          END;
     END;
END;


FUNCTION ChangeDir(dir:STRING):BOOLEAN;
VAR  t:LONGINT;
     Child:TEditor;
BEGIN
     IF Length(dir) > 3 THEN NormalizeDir(dir);
     {$i-}
     ChDir(dir);
     {$i+}
     Result := IoResult = 0;
     IF not Result THEN exit;

     {Updaten der Editor Titelzeilen}
     FOR t := CodeEditorRef.MDIChildCount-1 DOWNTO 0 DO
     BEGIN
          Child := TEditor(CodeEditorRef.MDIChildren[t]);
          IF Child IS TEditor THEN Child.FileName := Child.FileName;
     END;
END;

PROCEDURE SetFileDialogTypes(CFOD:{$ifdef os2}TOpenDialog{$endif}
                                  {$ifdef win32}TSystemOpenSaveDialog{$endif});

BEGIN
  CFOD.AddFilter(LoadNLSStr(SiAllFiles)+' ('+LowerCase(FileDialogWildCards[1])+')',FileDialogWildCards[1]);
  CFOD.AddFilter(LoadNLSStr(SiPascalFiles)+' ('+LowerCase(FileDialogWildCards[2])+')',FileDialogWildCards[2]);
  CFOD.AddFilter(LoadNLSStr(SiIncludeFiles)+' ('+LowerCase(FileDialogWildCards[3])+')',FileDialogWildCards[3]);
  CFOD.AddFilter(LoadNLSStr(SiResourceFiles)+' ('+LowerCase(FileDialogWildCards[4])+')',FileDialogWildCards[4]);
  CFOD.AddFilter(LoadNLSStr(SiWDSibylHelpFiles)+' ('+LowerCase(FileDialogWildCards[5])+')',FileDialogWildCards[5]);
  CFOD.AddFilter(LoadNLSStr(SiComplibSources)+' ('+LowerCase(FileDialogWildCards[6]+')'),FileDialogWildCards[6]);
  CFOD.AddFilter(LoadNLSStr(SiAssemblerFiles)+' ('+LowerCase(FileDialogWildCards[7]+')'),FileDialogWildCards[7]);
  CFOD.AddFilter(LoadNLSStr(SiAllFiles)+' ('+LowerCase(FileDialogWildCards[1])+')   ISO Latin 1',FileDialogWildCards[1]);
  CFOD.FilterIndex := 2;
END;


FUNCTION ChangeDirOnOpen:BOOLEAN;
BEGIN
  Result := IdeSettings.EditOpt.Behaviour * [eb_ChangeDirOnOpen] <> [];
END;


(* Men Operationen *)

{File wird geschlossen}
PROCEDURE AddMenuItem(s1:STRING; History:TStringList; Last1,LastN:LONGINT;
                      cmParent:LONGINT; MaxMenu,MaxHistory:LONGINT);
VAR  i,j,t:LONGINT;
     cm,newcm:TCommand;
     me,AParent:TMenuItem;
     SubEntry:TMenuItem;
     found:BOOLEAN;
     s:STRING;
     Temp:TObject;
BEGIN
     {Suche, ob der Name schon in Liste; JA -> l”schen}
     IF History.Find(s1,i) THEN
     BEGIN
          cm := TCommand(History.Objects[i]);
          {Listeneintrag l”schen}
          History.Delete(i);
          IF cm <> cmNull THEN {evtl Meneintrag l”schen}
          BEGIN
               me := SibylMainMenu.MenuItems[cm];
               IF me <> NIL THEN me.Destroy;
          END;
     END;

     {bestimme neue freie Nummer}
     FOR i := Last1 TO LastN DO
     BEGIN
          newcm := i;
          found := TRUE;
          FOR j := 0 TO History.Count-1 DO
          BEGIN
               cm := TCommand(History.Objects[j]);
               IF newcm = cm THEN
               BEGIN
                    found := FALSE;
                    break;
               END;
          END;
          IF found THEN break;
     END;
     IF not found THEN exit; {alle Nummern vergeben ?}

     {Testen, ob unten noch ein MenItem entfernt werden muแ}
     AParent := SibylMainMenu.MenuItems[cmParent];
     IF AParent = NIL THEN exit;
     j := AParent.Count;
     IF j > MaxMenu + MaxHistory THEN {l”sche den letzten aus dem Menu}
     BEGIN
          me := TMenuItem(AParent.Items[MaxMenu + MaxHistory]);
          IF me <> NIL THEN me.Destroy;

          TCommand(Temp) := cmNull;
          History.Objects[MaxHistory-1] := Temp;
     END;

     {an oberster Position einfgen}
     j := AParent.Count;
     IF j = MaxMenu THEN {insert Separator}
     BEGIN
          me.Create(SibylMainMenu);
          me.Caption := '-';
          AParent.Insert(MaxMenu,me);
     END;

     History.Insert(0,s1);
     History.Objects[0] := TObject(newcm);
     me.Create(SibylMainMenu);
     WHILE pos('\t',s1) <> 0 DO s1[pos('\t',s1)+1] := 'T';
     me.Caption := GetShortName(s1,20);
     me.Hint := FmtLoadNLSStr(SiOpen,[s1]);
     me.Command := newcm;
     AParent.Insert(MaxMenu+1,me);

     {Shortcuts updaten}
     t := 1;
     FOR i := 0 TO AParent.Count-1 DO
     BEGIN
          SubEntry := TMenuItem(AParent.Items[i]);
          IF SubEntry IS TMenuItem THEN
            IF (SubEntry.Command >= Last1) AND (SubEntry.Command <= LastN) THEN
          BEGIN
               s := SubEntry.Caption;
               IF s[1] IN ['~','&'] THEN delete(s,1,4);
               SubEntry.Caption := '~' + tostr(t) + '. ' + s;
               inc(t);
          END;
     END;
END;


{File wird ge”ffnet}
PROCEDURE RemoveMenuItem(s1:STRING; History:TStringList; Last1,LastN:LONGINT;
                          cmParent:LONGINT; MaxMenu,MaxHistory:LONGINT);
VAR  i,j,t:LONGINT;
     cm,newcm:TCommand;
     me,AParent:TMenuItem;
     SubEntry:TMenuItem;
     found:BOOLEAN;
     s:STRING;
BEGIN
     found := FALSE;
     {Suche, ob der Name schon in Liste; JA -> l”schen}
     IF History.Find(s1,i) THEN
     BEGIN
          cm := TCommand(History.Objects[i]);
          {Listeneintrag l”schen}
          History.Delete(i);
          IF cm <> cmNull THEN {evtl Meneintrag l”schen}
          BEGIN
               me := SibylMainMenu.MenuItems[cm];
               IF me <> NIL THEN
               BEGIN
                    me.Destroy;
                    found := TRUE;
               END;
          END;
     END;

     AParent := SibylMainMenu.MenuItems[cmParent];
     IF AParent = NIL THEN exit;

     IF found THEN  {neues Element am Ende nachziehen}
       IF History.Count >= MaxHistory THEN
     BEGIN
          {bestimme neue freie Nummer}
          FOR i := Last1 TO LastN DO
          BEGIN
               newcm := i;
               found := TRUE;
               FOR j := 0 TO History.Count-1 DO
               BEGIN
                    cm := TCommand(History.Objects[j]);
                    IF newcm = cm THEN
                    BEGIN
                         found := FALSE;
                         break;
                    END;
               END;
               IF found THEN break;
          END;
          IF not found THEN exit; {alle Nummern vergeben ?}

          s1 := History.Strings[MaxHistory-1];
          History.Objects[MaxHistory-1] := TObject(newcm);
          me.Create(SibylMainMenu);
          WHILE pos('\t',s1) <> 0 DO s1[pos('\t',s1)+1] := 'T';
          me.Caption := GetShortName(s1,20);
          me.Command := newcm;
          AParent.Insert(MaxMenu+MaxHistory,me);
     END;

     IF AParent.Count = MaxMenu+1  THEN {l”sche den Separator}
     BEGIN
          me := TMenuItem(AParent.Items[MaxMenu]);
          IF me <> NIL THEN me.Destroy;
     END;

     {Shortcuts updaten}
     t := 1;
     FOR i := 0 TO AParent.Count-1 DO
     BEGIN
          SubEntry := TMenuItem(AParent.Items[i]);
          IF SubEntry IS TMenuItem THEN
            IF (SubEntry.Command >= Last1) AND (SubEntry.Command <= LastN) THEN
          BEGIN
               s := SubEntry.Caption;
               IF s[1] IN ['~','&'] THEN delete(s,1,4);
               SubEntry.Caption := '~' + tostr(t) + '. ' + s;
               inc(t);
          END;
     END;
END;


{cm gesendet}
FUNCTION GetMenuItem(cm:TCommand; History:TStringList):STRING;
VAR  i:INTEGER;
BEGIN
     Result := '';
     {Suche, ob Command in Liste; JA -> String nehmen}
     i := History.IndexOfObject(TObject(cm));
     IF i < 0 THEN exit; {not found}

     Result := History.Strings[i];
END;


PROCEDURE ClearMenuItems(cmParent:LONGINT; MaxMenu:LONGINT);
VAR  i:LONGINT;
     me,AParent:TMenuItem;
BEGIN
     AParent := SibylMainMenu.MenuItems[cmParent];
     IF AParent = NIL THEN exit;
     FOR i := AParent.Count-1 DOWNTO MaxMenu DO
     BEGIN
          me := TMenuItem(AParent.Items[i]);
          IF me <> NIL THEN me.Destroy;
     END;
END;


VAR LastKeyMap:TEditKeyMap;

PROCEDURE SetMainMenuShortCuts(KeyMap:TEditKeyMap);
VAR  i:LONGINT;
     smr:TSibylMenuRecord;
     firsttime:BOOLEAN;
     newsc,oldsc:STRING;
     Entry:TMenuItem;
BEGIN
     IF LastKeyMap = KeyMap THEN exit;
     firsttime := LastKeyMap = TEditKeyMap(-1);

     FOR i := 1 TO MaxMenuEntries DO
     BEGIN
          smr := MenuEntries[i];
          IF smr.Level = 0 THEN continue;
          IF smr.Cmd = cmNull THEN continue;
          IF smr.Cmd = 1 THEN continue;

          CASE KeyMap OF
            km_WordStar: newsc := smr.scWS;
            km_CUA:      newsc := smr.scCUA;
            km_Default,
            km_Custom:  newsc := smr.scDef;
          END;
          IF not firsttime THEN
          BEGIN
               CASE LastKeyMap OF
                 km_WordStar: oldsc := smr.scWS;
                 km_CUA:      oldsc := smr.scCUA;
                 km_Default,
                 km_Custom:  oldsc := smr.scDef;
               END;
               IF newsc = oldsc THEN continue;
          END;

          Entry := SibylMainMenu.MenuItems[smr.Cmd];
          IF Entry <> NIL THEN
          BEGIN
               IF newsc <> '' THEN newsc := '\t' + newsc;
               Entry.Caption := LoadNLSStr(smr.Text) + newsc;
          END;
     END;

     LastKeyMap := KeyMap;
END;


FUNCTION ReadOnlyFileIndex(s:STRING):LONGINT;
BEGIN
     UpcaseStr(s);
     FOR Result := 0 TO Project.ReadOnlyFiles.Count-1 DO
     BEGIN
          IF s = Upcased(Project.ReadOnlyFiles[Result]) THEN exit;
     END;
     Result := -1;
END;


PROCEDURE AddToReadOnlyFiles(CONST s:STRING);
BEGIN
     IF ReadOnlyFileIndex(s) < 0 THEN Project.ReadOnlyFiles.Add(s);
END;


PROCEDURE RemoveFromReadOnlyFiles(CONST s:STRING);
VAR  idx:LONGINT;
BEGIN
     idx := ReadOnlyFileIndex(s);
     IF idx >= 0 THEN Project.ReadOnlyFiles.Delete(idx);
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: IdeSettings                                                 บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE FillColorTable(VAR Colors:TColors);
BEGIN
  Colors.Editor.Comment1.fg := clDkGray;
  Colors.Editor.Comment1.bg := clWhite;
  Colors.Editor.Comment1.flag := useback;

  Colors.Editor.Comment2.fg := clDkGray;
  Colors.Editor.Comment2.bg := clWhite;
  Colors.Editor.Comment2.flag := useback;

  Colors.Editor.Comment3.fg := clDkGray;
  Colors.Editor.Comment3.bg := clWhite;
  Colors.Editor.Comment3.flag := useback;

  Colors.Editor.Comment4.fg := clDkGray;
  Colors.Editor.Comment4.bg := clWhite;
  Colors.Editor.Comment4.flag := useback;

  Colors.Editor.Comment5.fg := clDkGray;
  Colors.Editor.Comment5.bg := clWhite;
  Colors.Editor.Comment5.flag := useback;

  Colors.Editor.ReservedWord.fg := clNavy;
  Colors.Editor.ReservedWord.bg := clWhite;
  Colors.Editor.ReservedWord.flag := useback;

  Colors.Editor.PlainText.fg := clBlack;
  Colors.Editor.PlainText.bg := clWhite;
  Colors.Editor.PlainText.flag := usefore OR useback;

  Colors.Editor.Symbol.fg := clBlack;
  Colors.Editor.Symbol.bg := clWhite;
  Colors.Editor.Symbol.flag := usefore OR useback;

  Colors.Editor.Strings.fg := clRed;
  Colors.Editor.Strings.bg := clWhite;
  Colors.Editor.Strings.flag := useback;

  Colors.Editor.Number.fg := clBlue;
  Colors.Editor.Number.bg := clWhite;
  Colors.Editor.Number.flag := useback;

  Colors.Editor.AsmBlock.fg := clGreen;
  Colors.Editor.AsmBlock.bg := clWhite;
  Colors.Editor.AsmBlock.flag := useback;

  Colors.Editor.MarkedBlock.fg := clWhite;
  Colors.Editor.MarkedBlock.bg := clBlack;
  Colors.Editor.MarkedBlock.flag := usefore OR useback;

  Colors.Editor.SearchMatch.fg := clWhite;
  Colors.Editor.SearchMatch.bg := clRed;
  Colors.Editor.SearchMatch.flag := 0;

  Colors.Editor.ValidBreak.fg := clWhite;
  Colors.Editor.ValidBreak.bg := clRed;
  Colors.Editor.ValidBreak.flag := 0;

  Colors.Editor.InvalidBreak.fg := clBlack;
  Colors.Editor.InvalidBreak.bg := clOlive;
  Colors.Editor.InvalidBreak.flag := 0;

  Colors.Editor.ExecPoint.fg := clWhite;
  Colors.Editor.ExecPoint.bg := clBlue;
  Colors.Editor.ExecPoint.flag := 0;

  Colors.Editor.ErrorLine.fg := clWhite;
  Colors.Editor.ErrorLine.bg := clMaroon;
  Colors.Editor.ErrorLine.flag := 0;

  Colors.Editor.RightMargin.fg := clLtGray;
  Colors.Editor.RightMargin.bg := clLtGray;
  Colors.Editor.RightMargin.flag := 0;
END;



PROCEDURE InitializeINI;
VAR  t  : LONGINT;
     dir: STRING;

BEGIN
  IdeSettings.Modified := FALSE;

  IdeSettings.InstallDir := '';
  IdeSettings.BinDir := '';
  IdeSettings.LastProject := GetProjectDir +'\Project1' + EXT_UC_WDSibyl_SPR; // .spr';
  IdeSettings.ProjectDir := GetProjectDir;

  ProjectsHistory.Clear;

  FindInFilesHistory.Clear;

  FindInFilesFilter.Clear;
  FindInFilesFilter.Add('*.pas;*.inc;*.rc');
  FindInFilesFilter.Add('*.c;*.cpp;*.rc');
  FindInFilesFilter.Add('*.h;*.hpp');
  FindInFilesFilter.Add('*.htm;*.html');
  FindInFilesFilter.Add(ALL_FILES_UC_INI);         // .ini');
  FindInFilesFilter.Add(ALL_FILES_UC_WDSibyl_SPR); // .spr'
  FindInFilesFilter.Add(ALL_FILES_UC_Pascal);      // .pas');
  FindInFilesFilter.Add(ALL_FILES_UC_WDSibyl_SCL); // .scl');
  FindInFilesFilter.Add(ALL_FILES_UC_INC);         // .inc');
  FindInFilesFilter.Add(ALL_FILES_UC_RC);          // .rc');
  FindInFilesFilter.Add(ALL_FILES_UC_TXT);         // .txt');
  FindInFilesFilter.Add(ALL_FILES);             // '*.*');

  FindInFilesPaths.Clear;

  IdeSettings.FindFiles.LastFilter := '*.pas;*.inc;*.rc';
  IdeSettings.FindFiles.LastPath := '';
  IdeSettings.FindFiles.Recursive := TRUE;
  IdeSettings.FindFiles.CaseSense := FALSE;
  IdeSettings.FindFiles.WordsOnly := FALSE;

  IdeSettings.OpenMsgView := TRUE;
  IdeSettings.GlobalHints := TRUE;
  IdeSettings.TipNumber := 0;
  IdeSettings.FlatButtons := FALSE;
  IdeSettings.EnableSound := TRUE;
  IdeSettings.ShowBitBtnGlyph := FALSE;
  IdeSettings.EditorIconbar := TRUE;
  IdeSettings.LoadLastPrj := TRUE;
  IdeSettings.AskRecompile := FALSE;
  IdeSettings.DroppingFile := df_Open;

  IdeSettings.EditOpt.Cursor := ec_Underline;
  IdeSettings.EditOpt.Mouse := em_IBeam;
  IdeSettings.EditOpt.KeyMap := km_WordStar;
  IdeSettings.EditOpt.Style := cs_TabSet;
  IdeSettings.EditOpt.Options := [eo_InsertMode, eo_AutoIndent, eo_Unindent,
    eo_2ClickLine, eo_PersistentBlock, eo_UndoGroups, eo_SmartTabs];
  IdeSettings.EditOpt.Behaviour := [eb_Backups, eb_TextFromCursor,
    eb_ChangeDirOnOpen, eb_SyntaxHigh];
  IdeSettings.EditOpt.Select := es_NonInclusive;
  IdeSettings.EditOpt.TabulatorSize := 8;
  IdeSettings.EditOpt.UndoEvents := 128;
  IdeSettings.EditOpt.SaveEvents := 0;
  IdeSettings.EditOpt.WrapColumn := 0;
  IdeSettings.EditOpt.FindStruct.Find := '';
  IdeSettings.EditOpt.FindStruct.Replace :=  '';
  IdeSettings.EditOpt.FindStruct.Direction := fd_Forward;
  IdeSettings.EditOpt.FindStruct.Origin := fo_EntireScope;
  IdeSettings.EditOpt.FindStruct.Scope := fs_Global;
  IdeSettings.EditOpt.FindStruct.Options := [];
  IdeSettings.EditOpt.FindStruct.Confirm := FALSE;
  IdeSettings.EditOpt.FindStruct.ReplAll := FALSE;
  IdeSettings.EditOpt.ReplStruct := IdeSettings.EditOpt.FindStruct;

  IdeSettings.CodeGen.IdentifierStyle := is_Mixed;
  IdeSettings.CodeGen.IndentBlock := 2;
  IdeSettings.CodeGen.IndentScope := 0;
  IdeSettings.CodeGen.IndentField :=  2;
  IdeSettings.CodeGen.IndentSpace := 1;
  IdeSettings.CodeGen.LineBreak := 80;

  IdeSettings.Designer.GridWidth := 16;
  IdeSettings.Designer.GridHeight := 16;
  IdeSettings.Designer.GridActive := TRUE;
  IdeSettings.Designer.GridVisible := TRUE;
  IdeSettings.Designer.InsertMode := ci_DropMove;
  IdeSettings.Designer.MultiSelectMode := cs_Include;
  IdeSettings.Designer.AutoCreateForm := TRUE;

  IdeSettings.AutoSave := [as_Project, as_EditorFiles, as_SCU, as_INI];

  IdeSettings.AutoRename := [ar_Unit, ar_Uses, ar_SCU, ar_FormLocation,
                             ar_ProjectFiles];


  FillColorTable(IdeSettings.Colors);

  IdeSettings.Fonts.ApplicationFont := '';
  IdeSettings.Fonts.InspectorFont := '';
  IdeSettings.Fonts.NavigatorFont := '';
  IdeSettings.Fonts.EditorTabFont := '';
  IdeSettings.Fonts.EditorFont := '';

  IdeSettings.MacroFileName := '';

  IdeSettings.CodeInsight.TimerValue := 1000;
  IdeSettings.CodeInsight.CodeCompletion := TRUE;
  IdeSettings.CodeInsight.CodeParameter := TRUE;
  IdeSettings.CodeInsight.ToolTips := TRUE;

  IdeSettings.Browse.DetailWindowWidth := 250;
  IdeSettings.Browse.ViewMode := mo_Objects;
  IdeSettings.Browse.Buttons[Browser_Constants] := FALSE;
  IdeSettings.Browse.Buttons[Browser_Procedures] := TRUE;
  IdeSettings.Browse.Buttons[Browser_Types] := TRUE;
  IdeSettings.Browse.Buttons[Browser_Variables] := TRUE;
  IdeSettings.Browse.Buttons[Browser_Properties] := TRUE;
  IdeSettings.Browse.Buttons[Browser_Inherited] := FALSE;
  IdeSettings.Browse.Buttons[Browser_Virtual] := TRUE;
  IdeSettings.Browse.Buttons[Browser_Private] := FALSE;
  IdeSettings.Browse.Buttons[Browser_Protected] := TRUE;
  IdeSettings.Browse.Buttons[Browser_Public] := TRUE;
  IdeSettings.Browse.Buttons[Browser_Published] := TRUE;
  IdeSettings.Browse.Files := [bf_SPCC, bf_Project];

  IdeSettings.Inspect.PropertyNameSize := 0;
  IdeSettings.Inspect.EventNameSize := 0;

  IdeSettings.CPUWin.DumpNoteBookHeight := 130;
  IdeSettings.CPUWin.RegNoteBookWidth := 150;

  IdeSettings.PrjMan.FormListSize := 175;

  {Projekt Standards}
  IdeSettings.CompOptOS2.Codegen := [cg_Assertions];
  IdeSettings.CompOptOS2.Syntax := [];
  IdeSettings.CompOptOS2.Optimize := [om_OptimizeCommonSub,om_OptimizePeephole];
  IdeSettings.CompOptOS2.Runtime := [];
  IdeSettings.CompOptOS2.CondDef := '';
  IdeSettings.CompOptWin:=IdeSettings.CompOptOS2;

  IdeSettings.WarnOptOS2.Warnings:=[w_w2,w_w3,w_w4,w_w5,w_w6,w_w7];
  IdeSettings.WarnOptOS2.MaxWarnings:=200;
  IdeSettings.WarnOptOS2.MaxErrors:=10;
  IdeSettings.WarnOptWin:=IdeSettings.WarnOptOS2;

  IdeSettings.LinkOptOS2.DataSegment := ds_Normal;
  IdeSettings.LinkOptOS2.LinkerTarget := lt_GUI;
  IdeSettings.LinkOptOS2.ExePacking := ep_ExePack2;
  IdeSettings.LinkOptOS2.RunVDM := TRUE;
  IdeSettings.LinkOptOS2.CurrentLanguage := 'Default';
  IdeSettings.LinkOptOS2.InstallLanguages := '';
  IdeSettings.LinkOptWin:=IdeSettings.LinkOptOS2;

  IdeSettings.MemSizesOS2.Heap := 8192; {kByte}
  IdeSettings.MemSizesOS2.Stack := 256; {kByte}
  IdeSettings.MemSizesWin:=IdeSettings.MemSizesOS2;

  IdeSettings.DebugOptOS2.Info := [];
  IdeSettings.DebugOptOS2.Options:=0;
  //Turn on all RTL exceptions
  IdeSettings.DebugOptOS2.RTL_Exceptions:=0;
  FOR t:=1 TO MaxRTLXcpts DO
    IdeSettings.DebugOptOS2.RTL_Exceptions:=IdeSettings.DebugOptOS2.RTL_Exceptions OR 1 SHL (t-1);
  //Turn on all SPCC exceptions
  IdeSettings.DebugOptOS2.SPCC_Exceptions:=0;
  FOR t:=1 TO MaxSPCCXcpts DO
    IdeSettings.DebugOptOS2.SPCC_Exceptions:=IdeSettings.DebugOptOS2.SPCC_Exceptions OR 1 SHL (t-1);
  IdeSettings.DebugOptWin:=IdeSettings.DebugOptOS2;

  dir := GetInstallDir;
  IdeSettings.DirectoriesOS2.LastDir := '';
  IdeSettings.DirectoriesOS2.OutDir := dir + '\OS\OS2\Output';
  IdeSettings.DirectoriesOS2.LibDir := dir + '\OS\OS2\Lib';
  IdeSettings.DirectoriesOS2.LibSrcDir := '';       // dir + '\Source\RTL;' + dir + '\Source\SPCC';
  IdeSettings.DirectoriesOS2.IncSrcDir := '';
  IdeSettings.DirectoriesOS2.CompInstallDir := dir + '\OS\OS2\Compnt';
  IdeSettings.DirectoriesOS2.LastEditDir := edOut;

  IdeSettings.DirectoriesWin.LastDir := '';
  IdeSettings.DirectoriesWin.OutDir := dir + '\OS\Win32\Output';
  IdeSettings.DirectoriesWin.LibDir := dir + '\OS\Win32\Lib';
  IdeSettings.DirectoriesWin.LibSrcDir := '';       // dir + '\Source\RTL;' + dir + '\Source\SPCC';
  IdeSettings.DirectoriesWin.IncSrcDir := '';
  IdeSettings.DirectoriesWin.CompInstallDir := dir + '\OS\Win32\Compnt';
  IdeSettings.DirectoriesWin.LastEditDir := edOut;


  IdeSettings.StaticToolbars := [st_Speedbar, st_CompPalette, st_Statusbar];
  IdeSettings.SpeedbarWidth := 240;

  IdeSettings.ScreenWidth := CXScreen;
  IdeSettings.ScreenHeight := CYScreen;
  IdeSettings.CompilerPriority:=tpNormal;

  IdeSettings.DesktopWindows[dwi_MainWindow].FormName:='WDSibylMainForm';
  IdeSettings.DesktopWindows[dwi_MainWindow].X := 0;
  IdeSettings.DesktopWindows[dwi_MainWindow].Y := CYScreen - CYMainForm;
  IdeSettings.DesktopWindows[dwi_MainWindow].CX := CXScreen;
  IdeSettings.DesktopWindows[dwi_MainWindow].CY := CYMainForm;
  IdeSettings.DesktopWindows[dwi_MainWindow].Visible := TRUE;

  IdeSettings.DesktopWindows[dwi_CodeEditor].FormName:='CodeEditor';
  IdeSettings.DesktopWindows[dwi_CodeEditor].X := CXScreen DIV 4;
  IdeSettings.DesktopWindows[dwi_CodeEditor].Y := CYScreen - CYMainForm - (CYScreen DIV 2);
  IdeSettings.DesktopWindows[dwi_CodeEditor].CX := CXScreen DIV 2;
  IdeSettings.DesktopWindows[dwi_CodeEditor].CY := CYScreen DIV 2;
  IdeSettings.DesktopWindows[dwi_CodeEditor].Visible := TRUE;

  IdeSettings.DesktopWindows[dwi_Inspector].FormName:='InspectorForm';
  IdeSettings.DesktopWindows[dwi_Inspector].X := 0;
  IdeSettings.DesktopWindows[dwi_Inspector].Y := CYScreen - CYMainForm - (CYScreen DIV 2);
  IdeSettings.DesktopWindows[dwi_Inspector].CX := CXScreen DIV 4;
  IdeSettings.DesktopWindows[dwi_Inspector].CY := CYScreen DIV 2;

  IdeSettings.DesktopWindows[dwi_CompList].FormName:='Components';
  IdeSettings.DesktopWindows[dwi_CompList].X := (CXScreen - 230) DIV 2;
  IdeSettings.DesktopWindows[dwi_CompList].Y := (CYScreen - 330) DIV 2;
  IdeSettings.DesktopWindows[dwi_CompList].CX := 230;
  IdeSettings.DesktopWindows[dwi_CompList].CY := 330;

  IdeSettings.DesktopWindows[dwi_WindowList].FormName:='Window';
  IdeSettings.DesktopWindows[dwi_WindowList].X := (CXScreen - 420) DIV 2;
  IdeSettings.DesktopWindows[dwi_WindowList].Y := (CYScreen - 240) DIV 2;
  IdeSettings.DesktopWindows[dwi_WindowList].CX := 420;
  IdeSettings.DesktopWindows[dwi_WindowList].CY := 240;

  IdeSettings.DesktopWindows[dwi_Browser].FormName:='Browser';
  IdeSettings.DesktopWindows[dwi_Browser].X := (CXScreen - 600) DIV 2;
  IdeSettings.DesktopWindows[dwi_Browser].Y := (CYScreen - 350) DIV 2;
  IdeSettings.DesktopWindows[dwi_Browser].CX := 600;
  IdeSettings.DesktopWindows[dwi_Browser].CY := 350;

  IdeSettings.DesktopWindows[dwi_MacroList].FormName:='';
  IdeSettings.DesktopWindows[dwi_MacroList].X := (CXScreen - 250) DIV 2;
  IdeSettings.DesktopWindows[dwi_MacroList].Y := (CYScreen - 150) DIV 2;
  IdeSettings.DesktopWindows[dwi_MacroList].CX := 250;
  IdeSettings.DesktopWindows[dwi_MacroList].CY := 150;

  IdeSettings.DesktopWindows[dwi_ClipboardList].FormName:='ClipBoardWindow';
  IdeSettings.DesktopWindows[dwi_ClipboardList].X := (CXScreen - 250) DIV 2;
  IdeSettings.DesktopWindows[dwi_ClipboardList].Y := (CYScreen - 150) DIV 2;
  IdeSettings.DesktopWindows[dwi_ClipboardList].CX := 250;
  IdeSettings.DesktopWindows[dwi_ClipboardList].CY := 150;

  IdeSettings.DesktopWindows[dwi_CPUWindow].FormName:='CPUWindow';
  IdeSettings.DesktopWindows[dwi_CPUWindow].X := 0; {auto}
  IdeSettings.DesktopWindows[dwi_CPUWindow].Y := 0;
  IdeSettings.DesktopWindows[dwi_CPUWindow].CX := 0;
  IdeSettings.DesktopWindows[dwi_CPUWindow].CY := 0;

  IdeSettings.DesktopWindows[dwi_ProjectManager].FormName:='ProjectManager';
  IdeSettings.DesktopWindows[dwi_ProjectManager].X := (CXScreen - 350) DIV 2;
  IdeSettings.DesktopWindows[dwi_ProjectManager].Y := (CYScreen - 250) DIV 2;
  IdeSettings.DesktopWindows[dwi_ProjectManager].CX := 350;
  IdeSettings.DesktopWindows[dwi_ProjectManager].CY := 250;
END;


PROCEDURE UpdateFormInitProcs;
BEGIN
  IdeSettings.DesktopWindows[dwi_MainWindow].InitProc    := NIL;
  IdeSettings.DesktopWindows[dwi_CodeEditor].InitProc    := InitCodeEditorProc;
  IdeSettings.DesktopWindows[dwi_Inspector].InitProc     := InitInspectorProc;
  IdeSettings.DesktopWindows[dwi_CompList].InitProc      := InitCompListProc;
  IdeSettings.DesktopWindows[dwi_WindowList].InitProc    := InitWindowListProc;
  IdeSettings.DesktopWindows[dwi_Browser].InitProc       := InitBrowserProc;
  IdeSettings.DesktopWindows[dwi_MacroList].InitProc     := InitMacroListProc;
  IdeSettings.DesktopWindows[dwi_ClipboardList].InitProc := InitClipboardListProc;
  IdeSettings.DesktopWindows[dwi_CPUWindow].InitProc     := InitCPUWindowProc;
  IdeSettings.DesktopWindows[dwi_ProjectManager].InitProc:= InitProjectManagerProc;
END;



FUNCTION ColorStringToRecord(s:STRING):TEditCol;
VAR
  p,i,c:INTEGER;
BEGIN
  Result.fg := clWindowText;
  Result.bg := clWindow;
  Result.flag := 0;
  p := pos(',',s);
  IF p > 0 THEN
  BEGIN
    Result.fg := ColorValue(copy(s,1,p-1));
    delete(s,1,p);
  END
  ELSE
  BEGIN
    Result.fg := ColorValue(s);
    exit;
  END;
  p := pos(',',s);
  IF p > 0 THEN
  BEGIN
    Result.bg := ColorValue(copy(s,1,p-1));
    delete(s,1,p);
  END
  ELSE
  BEGIN
    Result.bg := ColorValue(s);
    exit;
  END;
  val(s,i,c);
  IF c = 0 THEN Result.flag := i;
END;


FUNCTION ColorRecordToString(colrec:TEditCol):STRING;
BEGIN
  Result := ColorName(colrec.fg) +','+ ColorName(colrec.bg) +','+ tostr(colrec.flag);
END;


PROCEDURE InsertToolMenuItems;
VAR  i:LONGINT;
     ptd:PToolData;
     ToolSubMenu,Sep:TMenuItem;
BEGIN
     ToolSubMenu := SibylMainMenu.MenuItems[cmOptionsMenu];
     IF ToolsList.Count > 0 THEN
     BEGIN {Separator erzeugen, falls noch nicht vorhanden}
          IF ToolSubMenu.Count <= MaxOptionMenu THEN
          BEGIN
               Sep.Create(SibylMainForm);
               Sep.Caption := '-';
               ToolSubMenu.Add(Sep);
          END;
     END;

     FOR i := 0 TO ToolsList.Count-1 DO
     BEGIN
          ptd := ToolsList.Items[i];
          IF ptd^.MenuItem = NIL THEN
          BEGIN
               ptd^.MenuItem.Create(SibylMainForm);
               ptd^.MenuItem.OnClick := ToolsList.EvToolClick;
               ptd^.MenuItem.Tag := LONGWORD(ptd);
               ToolSubMenu.Add(ptd^.MenuItem);
          END;
          ptd^.MenuItem.Caption := ptd^.ToolName;
          ptd^.MenuItem.Hint := ptd^.FileName + ' ' + ptd^.Parameter;
     END;
END;


PROCEDURE InitBrowserHints;
BEGIN
     BrowserHints[Browser_Constants]:=LoadNLSStr(SiBrowserConstants);
     BrowserHints[Browser_Procedures]:=LoadNLSStr(SiBrowserProcedures);
     BrowserHints[Browser_Types]:=LoadNLSStr(SiBrowserTypes);
     BrowserHints[Browser_Variables]:=LoadNLSStr(SiBrowserVariables);
     BrowserHints[Browser_Properties]:=LoadNLSStr(SiBrowserProperties);
     BrowserHints[Browser_Inherited]:=LoadNLSStr(SiBrowserInherited);
     BrowserHints[Browser_Virtual]:=LoadNLSStr(SiBrowserVirtual);
     BrowserHints[Browser_Private]:=LoadNLSStr(SiBrowserPrivate);
     BrowserHints[Browser_Protected]:=LoadNLSStr(SiBrowserProtected);
     BrowserHints[Browser_Public]:=LoadNLSStr(SiBrowserPublic);
     BrowserHints[Browser_Published]:=LoadNLSStr(SiBrowserPublished);
END;



PROCEDURE ScaleDesktopForms;
VAR  dwi:TDesktopWinId;
     x,y,cx,cy:LONGINT;
     fx,fy:EXTENDED;
BEGIN
     {teste aktuelle Aufl”sung mit der im Projekt gespeicherten}
     IF (Screen.Width = IdeSettings.ScreenWidth) AND
        (Screen.Height = IdeSettings.ScreenHeight) THEN exit;

     IF IdeSettings.ScreenWidth <= 0 THEN fx := 1
     ELSE fx := Screen.Width / IdeSettings.ScreenWidth;
     IF IdeSettings.ScreenHeight <= 0 THEN fy := 1
     ELSE fy := Screen.Height / IdeSettings.ScreenHeight;

     FOR dwi := dwi_MainWindow TO dwi_LastForm DO
     BEGIN
          x := IdeSettings.DesktopWindows[dwi].X;
          y := IdeSettings.DesktopWindows[dwi].Y;
          cx := IdeSettings.DesktopWindows[dwi].CX;
          cy := IdeSettings.DesktopWindows[dwi].CY;

          IdeSettings.DesktopWindows[dwi].X := round(fx * x);
          IdeSettings.DesktopWindows[dwi].Y := round(fy * y);
          IdeSettings.DesktopWindows[dwi].CX := round(fx * cx);
          IdeSettings.DesktopWindows[dwi].CY := round(fy * cy);

          IF dwi = dwi_MainWindow THEN {MainWindow behlt seine H”he}
          BEGIN {nur neue Top Position wird skaliert}
               IdeSettings.DesktopWindows[dwi].Y :=
                  IdeSettings.DesktopWindows[dwi].Y +
                  IdeSettings.DesktopWindows[dwi].CY - cy;
               IdeSettings.DesktopWindows[dwi].CY := cy;
          END;
     END;
END;


PROCEDURE BuildToolButtonList(ToolButtonList:TList; s:STRING);
VAR
  s1:STRING;
  p,z:LONGINT;
  err:INTEGER;
BEGIN
  ToolButtonList.Clear;

  WHILE s <> '' DO
  BEGIN
    p := pos(',',s);
    IF p = 0 THEN //letzte Zahl
    BEGIN
      s1 := s;
      s := '';
    END
    ELSE
    BEGIN
      s1 := copy(s,1,p-1);
      delete(s,1,p);
    END;

    val(s1,z,err);
    IF err = 0 THEN
      IF CommandToIndex(z) >= 0 THEN ToolButtonList.Add(POINTER(z));
  END;
END;


PROCEDURE LoadCodeTemplates;
// Laden der CodeInsight-Datei

VAR s,dir,name,ext:STRING;
    TempList:TStringList;
    i,p:LONGINT;
    pct:PCodeTemplate;
    FN : tFileName;

BEGIN
  FSplit(ParamStr(0),dir,name,ext);
  NormalizeDir(dir);
  FN:=dir + '\sibyl.sci';
  Application.LogWriteln('LoadCodeTemplates:' +FN);
  if FileExists(FN) = false then exit;

  TempList.Create;
  TempList.LoadFromFile(FN);
  Application.LogWriteln('Templist');
  pct := NIL;
  FOR i := 0 TO TempList.Count-1 DO
    BEGIN
      s := TempList.Strings[i];
      IF Length(s) > 0 THEN
        IF (s[1] = '[') AND (s[Length(s)] = ']') AND (pos('|',s) > 0) THEN
          BEGIN
            // entferne letzte Leerzeile des letzten pct
            IF pct <> NIL THEN
              IF pct^.Strings.Count > 0 THEN
                IF Trim(pct^.Strings[pct^.Strings.Count-1]) = '' THEN
                  pct^.Strings.Delete(pct^.Strings.Count-1);

            p := pos('|',s);
            New(pct);
            pct^.Name := Trim(Copy(s,2,p-2));
            pct^.Description := Trim(Copy(s,p+1,Length(s)-1-p));
            pct^.Strings.Create;
            CodeTemplateList.Add(pct);
            continue;
          END;
      IF pct <> NIL THEN pct^.Strings.Add(s);
    END;
  TempList.Destroy;
END;


PROCEDURE SaveCodeTemplates;
VAR
  s,dir,name,ext:STRING;
  TempList:TStringList;
  i,j:LONGINT;
  pct:PCodeTemplate;
BEGIN
  FSplit(ParamStr(0),dir,name,ext);
  NormalizeDir(dir);

  TempList.Create;
  pct := NIL;
  FOR i := 0 TO CodeTemplateList.Count-1 DO
  BEGIN
    pct := CodeTemplateList[i];

    s := '['+ pct^.Name +' | '+ pct^.Description +']';
    TempList.Add(s);

    FOR j := 0 TO pct^.Strings.Count-1 DO
    BEGIN
      s := pct^.Strings[j];
      TempList.Add(s);
    END;
    IF i <> CodeTemplateList.Count-1 THEN TempList.Add('');
  END;
  TempList.SaveToFile(dir + '\sibyl.sci');
  TempList.Destroy;
END;


FUNCTION LoadINI(VAR IdeSet:TIdeSettings):BOOLEAN;
VAR
  dir,name,ext:STRING;
  ini:TUnsortedAsciiIniFile;
  Section,s,f:STRING;
  i:LONGINT;
  ptd:PToolData;
//  iconedit:STRING;
//  nlsmgr:STRING;

  PROCEDURE ReadCompOpt(Var CompOpt:TCompilerOptions;Const Section:String);
  Var s:String;
  BEGIN
       WITH CompOpt DO
       BEGIN
         s := ini.ReadString(Section,'CodeGeneration','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'ASMSource') THEN Include(CodeGen,cg_ASMSource)
           ELSE Exclude(CodeGen,cg_ASMSource);
           IF IsFlag(s,'InlineStrings') THEN Include(CodeGen,cg_InlineStrings)
           ELSE Exclude(CodeGen,cg_InlineStrings);
           IF IsFlag(s,'Assertions') THEN Include(CodeGen,cg_Assertions)
           ELSE Exclude(CodeGen,cg_Assertions);
           IF IsFlag(s,'SaveConstructors') THEN Include(CodeGen,cg_SaveConstructors)
           ELSE Exclude(CodeGen,cg_SaveConstructors);
         END;

         s := ini.ReadString(Section,'Syntax','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'StrictVAR') THEN Include(Syntax,sx_StrictVAR)
           ELSE Exclude(Syntax,sx_StrictVAR);
           IF IsFlag(s,'CompleteBoolEval') THEN Include(Syntax,sx_CompleteBoolEval)
           ELSE Exclude(Syntax,sx_CompleteBoolEval);
         END;

         s := ini.ReadString(Section,'Optimize','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'OptimizeCommonSub') THEN Include(Optimize,om_OptimizeCommonSub)
           ELSE Exclude(Optimize,om_OptimizeCommonSub);
           IF IsFlag(s,'OptimizePeephole') THEN Include(Optimize,om_OptimizePeephole)
           ELSE Exclude(Optimize,om_OptimizePeephole);
         END;

         s := ini.ReadString(Section,'RuntimeCheck','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'InOut') THEN Include(Runtime,rc_InOut)
           ELSE Exclude(Runtime,rc_InOut);
           IF IsFlag(s,'Overflow') THEN Include(Runtime,rc_Overflow)
           ELSE Exclude(Runtime,rc_Overflow);
           IF IsFlag(s,'Stack') THEN Include(Runtime,rc_Stack)
           ELSE Exclude(Runtime,rc_Stack);
           IF IsFlag(s,'Range') THEN Include(Runtime,rc_Range)
           ELSE Exclude(Runtime,rc_Range);
         END;

         CondDef := ini.ReadString(Section,'CondDefine',CondDef);
       END;
  END;

  PROCEDURE ReadWarnOpt(Var WarnOpt:TWarningOptions;Const Section:String);
  Var s:String;
  BEGIN
       WITH WarnOpt DO
       BEGIN
         s := ini.ReadString(Section,'Warnings','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'W1') THEN Include(Warnings,W_W1)
           ELSE Exclude(Warnings,W_W1);
           IF IsFlag(s,'W2') THEN Include(Warnings,W_W2)
           ELSE Exclude(Warnings,W_W2);
           IF IsFlag(s,'W3') THEN Include(Warnings,W_W3)
           ELSE Exclude(Warnings,W_W3);
           IF IsFlag(s,'W4') THEN Include(Warnings,W_W4)
           ELSE Exclude(Warnings,W_W4);
           IF IsFlag(s,'W5') THEN Include(Warnings,W_W5)
           ELSE Exclude(Warnings,W_W5);
           IF IsFlag(s,'W6') THEN Include(Warnings,W_W6)
           ELSE Exclude(Warnings,W_W6);
           IF IsFlag(s,'W7') THEN Include(Warnings,W_W7)
           ELSE Exclude(Warnings,W_W7);
           IF IsFlag(s,'WAll') THEN Include(Warnings,W_WAll)
           ELSE Exclude(Warnings,W_WAll);
           IF IsFlag(s,'WNone') THEN Include(Warnings,W_WNone)
           ELSE Exclude(Warnings,W_WNone);
         END;

         MaxWarnings:=ini.ReadInteger(Section,'MaxWarnings',MaxWarnings);
         MaxErrors:=ini.ReadInteger(Section,'MaxErrors',MaxErrors);
       END;
  END;

  PROCEDURE ReadLinkOpt(Var LinkOpt:TLinkerOptions;Const Section:String);
  Var s:String;
  BEGIN
       WITH LinkOpt DO
       BEGIN
         s := ini.ReadString(Section,'DataSegment','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'Normal') THEN DataSegment := ds_Normal;
           IF IsFlag(s,'SingleShared') THEN DataSegment := ds_SingleShared;
         END;

         s := ini.ReadString(Section,'LinkerTarget','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'GUI') THEN LinkerTarget := lt_GUI;
           IF IsFlag(s,'FullScreen') THEN LinkerTarget := lt_FullScreen;
           IF IsFlag(s,'Window') THEN LinkerTarget := lt_Window;
         END;

         s := ini.ReadString(Section,'ExePacking','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'None') THEN ExePacking := ep_None;
           IF IsFlag(s,'ExePack1') THEN ExePacking := ep_ExePack1;
           IF IsFlag(s,'ExePack2') THEN ExePacking := ep_ExePack2;
         END;

         RunVDM := ini.ReadBool(Section,'RunVDM',RunVDM);

         CurrentLanguage:=ini.ReadString(Section,'CurrentLanguage',CurrentLanguage);
         InstallLanguages:=ini.ReadString(Section,'InstallLanguages',InstallLanguages);
       END;
  END;

  PROCEDURE ReadDebugOpt(Var DebugOpt:TDebuggerOptions;Const Section:String);
  Var s:String;
  BEGIN
       WITH DebugOpt DO
       BEGIN
         s := ini.ReadString(Section,'DebugInfo','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'LineNumbers') THEN Include(Info,di_LineNumbers)
           ELSE Exclude(Info,di_LineNumbers);
           IF IsFlag(s,'LocalSymbols') THEN Include(Info,di_LocalSymbols)
           ELSE Exclude(Info,di_LocalSymbols);
         END;

         Options:=ini.ReadInteger(Section,'Dbg_Options',Options);

         RTL_Exceptions := ini.ReadInteger(Section,'RTL_Exceptions',RTL_Exceptions);
         SPCC_Exceptions := ini.ReadInteger(Section,'SPCC_Exceptions',SPCC_Exceptions);
       END;

  END;

  PROCEDURE ReadDirectories(VAR Directories:TDirectories;Const Section:String);
  Var s:String;
  BEGIN
       WITH Directories DO
       BEGIN
         LastDir := ini.ReadString(Section,'LastDir',LastDir);
         OutDir := ini.ReadString(Section,'OutDir',OutDir);
         LibDir := ini.ReadString(Section,'LibDir',LibDir);
         LibSrcDir := ini.ReadString(Section,'LibSrcDir',LibSrcDir);
         IncSrcDir := ini.ReadString(Section,'IncSrcDir',IncSrcDir);
         CompInstallDir := ini.ReadString(Section,'CompInstallDir',CompInstallDir);

         s := ini.ReadString(Section,'LastEditDir','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'edOut') THEN LastEditDir := edOut;
           IF IsFlag(s,'edLib') THEN LastEditDir := edLib;
           IF IsFlag(s,'edLibSrc') THEN LastEditDir := edLibSrc;
           IF IsFlag(s,'edIncSrc') THEN LastEditDir := edIncSrc;
           IF IsFlag(s,'edComp') THEN LastEditDir := edComp;
         END;
       END;
  END;

BEGIN
  Application.LogWriteln('LoadINI: Start');
  Result := FALSE;
  SetMainStatusText(LoadNLSStr(SiLoadingEnv),clBlack,clLtGray);
  FSplit(ParamStr(0),dir,name,ext);
  NormalizeDir(dir);
  INIname := dir + '\sibyl'+EXT_UC_INI;
  Application.LogWriteln('LoadINI: ININame:'+IniName);

/*
// INI Ueber Parameter gesteuert
  s := GetEnv('SIBYLINI');
  IF s <> '' THEN INIname := s;
  {Overwrite INI name from command line}
  FOR i := 1 TO ParamCount DO
  BEGIN
       s := Upcased(ParamStr(i));
       s := FExpand(s);
       FSplit(s,dir,name,ext);
       IF pos(EXT_INI,ext) <> 0 THEN INIname := s;
  END; */

  InitBrowserHints;

  IF not FileExists(INIname) THEN begin   // initialisiere INI ohne Fehlermeldung

// Default Settings sind bereits aktiv}
    SetMainStatusText('',clBlack,clLtGray);
    Project.FileName := IdeSet.LastProject;

// fge den IconEditor zur ToolsListe hinzu}
/*    iconedit := GetBinDir + '\IcEdit.Exe';
    IF FileExists(iconedit) THEN
      BEGIN
        New(ptd);
        ptd^.ToolName := 'Icon Editor';
        ptd^.FileName := iconedit;
        ptd^.Parameter := '';
        ptd^.MenuItem := NIL;
        ToolsList.Add(ptd);
        InsertToolMenuItems;
      END;
// fge den Language Manager zur ToolsListe hinzu}
    nlsmgr := GetBinDir + '\NlsMgr.Exe';
    IF FileExists(nlsmgr) THEN
      BEGIN
        New(ptd);
        ptd^.ToolName := 'Language Manager';
        ptd^.FileName := nlsmgr;
        ptd^.Parameter := '$SAVESCU $SCUNAME';
        ptd^.MenuItem := NIL;
        ToolsList.Add(ptd);
        InsertToolMenuItems;
      END; */
    SaveINI(IdeSet);
    Result := TRUE;
    exit;
  END;

  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(INIname);

    {Section General}
    Section := 'General';
    IdeSet.LastProject := ini.ReadString(Section,'LastProject',Project.FileName);
    IdeSet.OpenMsgView := ini.ReadBool(Section,'OpenMsgView',IdeSet.OpenMsgView);
    IdeSet.GlobalHints := ini.ReadBool(Section,'GlobalHints',IdeSet.GlobalHints);
    IdeSet.TipNumber := ini.ReadInteger(Section,'TipNumber',IdeSet.TipNumber);
    IdeSet.FlatButtons := ini.ReadBool(Section,'FlatButtons',IdeSet.FlatButtons);
    IdeSet.EnableSound := ini.ReadBool(Section,'EnableSound',IdeSet.EnableSound);
    IdeSet.ShowBitBtnGlyph := ini.ReadBool(Section,'ShowBitBtnGlyph',IdeSet.ShowBitBtnGlyph);
    IdeSet.EditorIconbar := ini.ReadBool(Section,'EditorIconbar',IdeSet.EditorIconbar);
    ASM
       // No more Registers
    END;
    IdeSet.LoadLastPrj := ini.ReadBool(Section,'LoadLastProject',IdeSet.LoadLastPrj);
    IdeSet.AskRecompile := ini.ReadBool(Section,'AskRecompile',IdeSet.AskRecompile);
    s := ini.ReadString(Section,'DroppingFile','?');
    IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Import')
          THEN IdeSet.DroppingFile := df_Import
          ELSE IdeSet.DroppingFile := df_Open;
      END;
    IdeSet.ScreenWidth := ini.ReadInteger(Section,'ScreenWidth',IdeSet.ScreenWidth);
    IdeSet.ScreenHeight := ini.ReadInteger(Section,'ScreenHeight',IdeSet.ScreenHeight);
    s := ini.ReadString(Section,'CompilerPriority','?');
    IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Idle')   THEN IdeSet.CompilerPriority:=tpIdle;
        IF IsFlag(s,'Lowest') THEN IdeSet.CompilerPriority:=tpLowest;
        IF IsFlag(s,'Lower')  THEN IdeSet.CompilerPriority:=tpLower;
        IF IsFlag(s,'Normal') THEN IdeSet.CompilerPriority:=tpNormal;
      END;

// Section Directories
    Section := 'Directories';
    IdeSet.InstallDir := ini.ReadString(Section,'InstallDir',IdeSet.InstallDir);
    IdeSet.BinDir     := ini.ReadString(Section,'BinDir',IdeSet.BinDir);
    IdeSet.ProjectDir := ini.ReadString(Section,'ProjectDir',IdeSet.ProjectDir);
    IdeSet.templateDir:= ini.ReadString(Section,'TemplateDir',IdeSet.TemplateDir);

// Section Project History
    Section := 'Project History';
    IF (not IdeSet.LoadLastPrj) AND (IdeSet.LastProject <> '') THEN
    BEGIN
      IF FileExists(IdeSet.LastProject)
      THEN ProjectsHistory.Add(IdeSet.LastProject); //letztes Projekt in die History
    END;

    FOR i := 0 TO MaxInt DO
    BEGIN
      f := 'Project' + tostr(i);
      s := ini.ReadString(Section,f,'?');
      IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}
      IF not FileExists(s) THEN continue;
      ProjectsHistory.Add(s);
      IF ProjectsHistory.Count >= MaxHistoryProjects THEN break;
    END;

// Section Find in Files
    Section := 'Find In Files';
    WITH IdeSet.FindFiles DO
    BEGIN
      LastFilter := ini.ReadString(Section,'LastFilter',LastFilter);
      LastPath := ini.ReadString(Section,'LastPath',LastPath);
      Recursive := ini.ReadBool(Section,'Recursive',Recursive);
      CaseSense := ini.ReadBool(Section,'CaseSense',CaseSense);
      WordsOnly := ini.ReadBool(Section,'WordsOnly',WordsOnly);
    END;

    FOR i := 0 TO MaxInt DO
      BEGIN
        f := 'Find' + tostr(i);
        s := ini.ReadString(Section,f,'?');
        IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}
        FindInFilesHistory.Add(s);
      END;

    FOR i := 0 TO MaxInt DO
      BEGIN
        f := 'Filter' + tostr(i);
        s := ini.ReadString(Section,f,'?');
        IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}
        IF i = 0 THEN FindInFilesFilter.Clear; //berschreibe Standardeintrge
        FindInFilesFilter.Add(s);
      END;

    FOR i := 0 TO MaxInt DO
      BEGIN
        f := 'Path' + tostr(i);
        s := ini.ReadString(Section,f,'?');
        IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}
        FindInFilesPaths.Add(s);
      END;


// Section MainForm
    Section := 'MainForm';
    WITH IdeSet.DesktopWindows[dwi_MainWindow] DO
      BEGIN
        X := ini.ReadInteger(Section,'Left',X);
        Y := ini.ReadInteger(Section,'Bottom',Y);
        CX := ini.ReadInteger(Section,'Width',CX);
        CY := ini.ReadInteger(Section,'Height',CY);
        Visible := ini.ReadBool(Section,'Visible',Visible);
        Visible := TRUE; {!}
      END;

// Section Static Toolbars
    Section := 'Static Toolbars';
    WITH IdeSet DO
    BEGIN
      s := ini.ReadString(Section,'VisibleToolbars','?');
      IF s <> '?' THEN
      BEGIN
        StaticToolbars := [];
        IF IsFlag(s,'Speedbar') THEN Include(StaticToolbars, st_Speedbar);
        IF IsFlag(s,'CompPalette') THEN Include(StaticToolbars, st_CompPalette);
        IF IsFlag(s,'Statusbar') THEN Include(StaticToolbars, st_Statusbar);
      END;
    END;

    {Section Code Editor}
    Section := 'Code Editor';
    WITH IdeSet.DesktopWindows[dwi_CodeEditor] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
      Visible := TRUE; {!}
    END;

    {Section Object Inspector}
    Section := 'Object Inspector';
    WITH IdeSet.DesktopWindows[dwi_Inspector] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.Inspect DO
    BEGIN
      PropertyNameSize := ini.ReadInteger(Section,'PropertyNameSize',PropertyNameSize);
      EventNameSize := ini.ReadInteger(Section,'EventNameSize',EventNameSize);
    END;

    {Section Object Browser}
    Section := 'Object Browser';
    WITH IdeSet.DesktopWindows[dwi_Browser] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.Browse DO
    BEGIN
      DetailWindowWidth := ini.ReadInteger(Section,'DetailWindowWidth',DetailWindowWidth);

      s := ini.ReadString(Section,'ViewMode','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Objects') THEN ViewMode := mo_Objects;
        IF IsFlag(s,'Globals') THEN ViewMode := mo_Globals;
        IF IsFlag(s,'Units') THEN ViewMode := mo_Units;
      END;

      FOR i := Browser_Constants TO Browser_Published DO
        Buttons[i] := ini.ReadBool(Section,BrowserHints[i],Buttons[i]);

      s := ini.ReadString(Section,'Files','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'RTL') THEN Include(Files, bf_RTL)
        ELSE Exclude(Files, bf_RTL);
        IF IsFlag(s,'SPCC') THEN Include(Files, bf_SPCC)
        ELSE Exclude(Files, bf_SPCC);
        IF IsFlag(s,'Project') THEN Include(Files, bf_Project)
        ELSE Exclude(Files, bf_Project);
      END;
    END;

    {Section Code Insight}
    Section := 'Code Insight';
    WITH IdeSet.CodeInsight DO
    BEGIN
      TimerValue := ini.ReadInteger(Section,'TimerValue',TimerValue);

      CodeCompletion := ini.ReadBool(Section,'CodeCompletion',CodeCompletion);
      CodeParameter := ini.ReadBool(Section,'CodeParameter',CodeParameter);
      ToolTips := ini.ReadBool(Section,'ToolTips',ToolTips);
    END;

    LoadCodeTemplates;

    {Section Component List}
    Section := 'Component List';
    WITH IdeSet.DesktopWindows[dwi_CompList] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    {Section Window List}
    Section := 'Window List';
    WITH IdeSet.DesktopWindows[dwi_WindowList] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    {Section Macro List}
    Section := 'Macro List';
    WITH IdeSet.DesktopWindows[dwi_MacroList] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    {Section Clipboard History}
    Section := 'Clipboard History';
    WITH IdeSet.DesktopWindows[dwi_ClipboardList] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    {Section CPU Window}
    Section := 'CPU Window';
    WITH IdeSet.DesktopWindows[dwi_CPUWindow] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.CPUWin DO
    BEGIN
      DumpNoteBookHeight := ini.ReadInteger(Section,'DumpNoteBookHeight',DumpNoteBookHeight);
      RegNoteBookWidth := ini.ReadInteger(Section,'RegisterNoteBookWidth',RegNoteBookWidth);
    END;

    {Section Project Manager}
    Section := 'Project Manager';
    WITH IdeSet.DesktopWindows[dwi_ProjectManager] DO
    BEGIN
      X := ini.ReadInteger(Section,'Left',X);
      Y := ini.ReadInteger(Section,'Bottom',Y);
      CX := ini.ReadInteger(Section,'Width',CX);
      CY := ini.ReadInteger(Section,'Height',CY);
      Visible := ini.ReadBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.PrjMan DO
    BEGIN
      FormListSize := ini.ReadInteger(Section,'FormListSize',FormListSize);
    END;

    {Section Form Designer}
    Section := 'Form Designer';
    WITH IdeSet.Designer DO
    BEGIN
      s := ini.ReadString(Section,'InsertMode','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'DropSize') THEN InsertMode := ci_DropSize;
        IF IsFlag(s,'DropMove') THEN InsertMode := ci_DropMove;
      END;
      s := ini.ReadString(Section,'MultiSelectMode','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'IncludeRect') THEN MultiSelectMode := cs_Include;
        IF IsFlag(s,'TouchRect') THEN MultiSelectMode := cs_Touch;
      END;
      GridWidth := ini.ReadInteger(Section,'GridWidth',GridWidth);
      GridHeight := ini.ReadInteger(Section,'GridHeight',GridHeight);
      GridActive := ini.ReadBool(Section,'GridActive',GridActive);
      GridVisible := ini.ReadBool(Section,'GridVisible',GridVisible);
      AutoCreateForm := ini.ReadBool(Section,'AutoCreateForm',AutoCreateForm);
    END;

    {Section Source Code Generation}
    Section := 'Source Code Generation';
    WITH IdeSet.CodeGen DO
    BEGIN
      s := ini.ReadString(Section,'IdentifierStyle','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Uppercase') THEN IdentifierStyle := is_Uppercase;
        IF IsFlag(s,'Lowercase') THEN IdentifierStyle := is_Lowercase;
        IF IsFlag(s,'Mixed') THEN IdentifierStyle := is_Mixed;
      END;
      IndentBlock := ini.ReadInteger(Section,'IndentBlock',IndentBlock);
      IndentScope := ini.ReadInteger(Section,'IndentScope',IndentScope);
      IndentField := ini.ReadInteger(Section,'IndentField',IndentField);
      IndentSpace := ini.ReadInteger(Section,'IndentSpace',IndentSpace);
      LineBreak := ini.ReadInteger(Section,'LineBreak',LineBreak);
    END;

    {Section Editor Options}
    Section := 'Editor Options';
    WITH IdeSet.EditOpt DO
    BEGIN
      s := ini.ReadString(Section,'Cursor','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Underline') THEN Cursor := ec_Underline;
        IF IsFlag(s,'Vertical') THEN Cursor := ec_Vertical;
      END;

      s := ini.ReadString(Section,'MouseShape','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Arrow') THEN Mouse := em_Arrow;
        IF IsFlag(s,'IBeam') THEN Mouse := em_IBeam;
      END;

      s := ini.ReadString(Section,'KeyMap','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'WordStar') THEN KeyMap := km_WordStar;
        IF IsFlag(s,'CUA') THEN KeyMap := km_CUA;
        IF IsFlag(s,'Default') THEN KeyMap := km_Default;
        IF IsFlag(s,'Custom') THEN KeyMap := km_Custom;
      END;

      s := ini.ReadString(Section,'Style','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'TabSet') THEN Style := cs_TabSet;
        IF IsFlag(s,'MDI') THEN Style := cs_MDI;
      END;

      s := ini.ReadString(Section,'Options','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'InsertMode') THEN Include(Options,eo_InsertMode)
        ELSE Exclude(Options,eo_InsertMode);
        IF IsFlag(s,'AutoIndent') THEN Include(Options,eo_AutoIndent)
        ELSE Exclude(Options,eo_AutoIndent);
        IF IsFlag(s,'Unindent') THEN Include(Options,eo_Unindent)
        ELSE Exclude(Options,eo_Unindent);
        IF IsFlag(s,'CursorClimb') THEN Include(Options,eo_CursorClimb)
        ELSE Exclude(Options,eo_CursorClimb);
        IF IsFlag(s,'2ClickLine') THEN Include(Options,eo_2ClickLine)
        ELSE Exclude(Options,eo_2ClickLine);
        IF IsFlag(s,'PersistentBlock') THEN Include(Options,eo_PersistentBlock)
        ELSE Exclude(Options,eo_PersistentBlock);
        IF IsFlag(s,'OverwriteBlock') THEN Include(Options,eo_OverwriteBlock)
        ELSE Exclude(Options,eo_OverwriteBlock);
        IF IsFlag(s,'UndoGroups') THEN Include(Options,eo_UndoGroups)
        ELSE Exclude(Options,eo_UndoGroups);
        IF IsFlag(s,'WordWrap') THEN Include(Options,eo_WordWrap)
        ELSE Exclude(Options,eo_WordWrap);
        IF IsFlag(s,'SmartTabs') THEN Include(Options,eo_SmartTabs)
        ELSE Exclude(Options,eo_SmartTabs);
        IF IsFlag(s,'HomeFirstWord') THEN Include(Options,eo_HomeFirstWord)
        ELSE Exclude(Options,eo_HomeFirstWord);
        IF IsFlag(s,'AddIndent') THEN Include(Options,eo_AddIndent)
        ELSE Exclude(Options,eo_AddIndent);
        IF IsFlag(s,'AutoBracket') THEN Include(Options,eo_AutoBracket)
        ELSE Exclude(Options,eo_AutoBracket);
      END;

      s := ini.ReadString(Section,'Behaviour','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Backups') THEN Include(Behaviour,eb_Backups)
        ELSE Exclude(Behaviour,eb_Backups);
        IF IsFlag(s,'AppendBAK') THEN Include(Behaviour,eb_AppendBAK)
        ELSE Exclude(Behaviour,eb_AppendBAK);
        IF IsFlag(s,'TextFromCursor') THEN Include(Behaviour,eb_TextFromCursor)
        ELSE Exclude(Behaviour,eb_TextFromCursor);
        IF IsFlag(s,'ChangeDirOnOpen') THEN Include(Behaviour,eb_ChangeDirOnOpen)
        ELSE Exclude(Behaviour,eb_ChangeDirOnOpen);
        IF IsFlag(s,'FullNameTitle') THEN Include(Behaviour,eb_FullNameTitle)
        ELSE Exclude(Behaviour,eb_FullNameTitle);
        IF IsFlag(s,'AutoSave') THEN Include(Behaviour,eb_AutoSave)
        ELSE Exclude(Behaviour,eb_AutoSave);
        IF IsFlag(s,'SyntaxHighlight') THEN Include(Behaviour,eb_SyntaxHigh)
        ELSE Exclude(Behaviour,eb_SyntaxHigh);
      END;

      s := ini.ReadString(Section,'Selection','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'NonInclusive') THEN Select := es_NonInclusive;
        IF IsFlag(s,'Column') THEN Select := es_Column;
      END;

      TabulatorSize := ini.ReadInteger(Section,'TabulatorSize',TabulatorSize);
      UndoEvents := ini.ReadInteger(Section,'UndoEvents',UndoEvents);
      SaveEvents := ini.ReadInteger(Section,'SaveEvents',SaveEvents);
      WrapColumn := ini.ReadInteger(Section,'WrapColumn',WrapColumn);
    END;

    {Section FindStruct}
    Section := 'Find Structure';
    WITH IdeSet.EditOpt.FindStruct DO
    BEGIN
      Find := ini.ReadString(Section,'Find',Find);

      s := ini.ReadString(Section,'Direction','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Forward') THEN Direction := fd_Forward;
        IF IsFlag(s,'Backward') THEN Direction := fd_Backward;
      END;

      s := ini.ReadString(Section,'Origin','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'EntireScope') THEN Origin := fo_EntireScope;
        IF IsFlag(s,'Cursor') THEN Origin := fo_Cursor;
      END;

      s := ini.ReadString(Section,'Scope','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Global') THEN Scope := fs_Global;
        IF IsFlag(s,'Selection') THEN Scope := fs_Selection;
        IF IsFlag(s,'AllEditors') THEN Scope := fs_AllEditors;
      END;

      s := ini.ReadString(Section,'Options','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'CaseSensitive') THEN Include(Options,fo_CaseSensitive)
        ELSE Exclude(Options,fo_CaseSensitive);
        IF IsFlag(s,'WordsOnly') THEN Include(Options,fo_WordsOnly)
        ELSE Exclude(Options,fo_WordsOnly);
      END;
    END;

    {Section ReplStruct}
    Section := 'Replace Structure';
    WITH IdeSet.EditOpt.ReplStruct DO
    BEGIN
      Find := ini.ReadString(Section,'Find',Find);
      Replace := ini.ReadString(Section,'Replace',Replace);

      s := ini.ReadString(Section,'Direction','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Forward') THEN Direction := fd_Forward;
        IF IsFlag(s,'Backward') THEN Direction := fd_Backward;
      END;

      s := ini.ReadString(Section,'Origin','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'EntireScope') THEN Origin := fo_EntireScope;
        IF IsFlag(s,'Cursor') THEN Origin := fo_Cursor;
      END;

      s := ini.ReadString(Section,'Scope','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Global') THEN Scope := fs_Global;
        IF IsFlag(s,'Selection') THEN Scope := fs_Selection;
        IF IsFlag(s,'AllEditors') THEN Scope := fs_AllEditors;
      END;

      s := ini.ReadString(Section,'Options','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'CaseSensitive') THEN Include(Options,fo_CaseSensitive)
        ELSE Exclude(Options,fo_CaseSensitive);
        IF IsFlag(s,'WordsOnly') THEN Include(Options,fo_WordsOnly)
        ELSE Exclude(Options,fo_WordsOnly);
      END;

      Confirm := ini.ReadBool(Section,'Confirm',Confirm);
      ReplAll := ini.ReadBool(Section,'ReplaceAll',ReplAll);
    END;


    {Section Auto}
    Section := 'Auto';
    WITH IdeSet DO
    BEGIN
      s := ini.ReadString(Section,'AutoSave','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Project') THEN Include(AutoSave,as_Project)
        ELSE Exclude(AutoSave,as_Project);
        IF IsFlag(s,'EditorFiles') THEN Include(AutoSave,as_EditorFiles)
        ELSE Exclude(AutoSave,as_EditorFiles);
        IF IsFlag(s,'SCU') THEN Include(AutoSave,as_SCU)
        ELSE Exclude(AutoSave,as_SCU);
        IF IsFlag(s,'INI') THEN Include(AutoSave,as_INI)
        ELSE Exclude(AutoSave,as_INI);
      END;

      s := ini.ReadString(Section,'AutoRename','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Unit') THEN Include(AutoRename,ar_Unit)
        ELSE Exclude(AutoRename,ar_Unit);
        IF IsFlag(s,'Uses') THEN Include(AutoRename,ar_Uses)
        ELSE Exclude(AutoRename,ar_Uses);
        IF IsFlag(s,'SCU') THEN Include(AutoRename,ar_SCU)
        ELSE Exclude(AutoRename,ar_SCU);
        IF IsFlag(s,'FormLocation') THEN Include(AutoRename,ar_FormLocation)
        ELSE Exclude(AutoRename,ar_FormLocation);
        IF IsFlag(s,'ProjectFiles') THEN Include(AutoRename,ar_ProjectFiles)
        ELSE Exclude(AutoRename,ar_ProjectFiles);
      END;
    END;

    {Section Colors}
    Section := 'Color Table';
    WITH IdeSet.Colors.Editor DO
    BEGIN
      s := ini.ReadString(Section,'Comment1','?');
      IF s <> '?' THEN Comment1 := ColorStringToRecord(s);
      s := ini.ReadString(Section,'Comment2','?');
      IF s <> '?' THEN Comment2 := ColorStringToRecord(s);
      s := ini.ReadString(Section,'Comment3','?');
      IF s <> '?' THEN Comment3 := ColorStringToRecord(s);
      s := ini.ReadString(Section,'Comment4','?');
      IF s <> '?' THEN Comment4 := ColorStringToRecord(s);
      s := ini.ReadString(Section,'Comment5','?');
      IF s <> '?' THEN Comment5 := ColorStringToRecord(s);
      s := ini.ReadString(Section,'ReservedWord','?');
      IF s <> '?' THEN ReservedWord := ColorStringToRecord(s);
      s := ini.ReadString(Section,'PlainText','?');
      IF s <> '?' THEN PlainText := ColorStringToRecord(s);
      s := ini.ReadString(Section,'Symbol','?');
      IF s <> '?' THEN Symbol := ColorStringToRecord(s);
      s := ini.ReadString(Section,'String','?');
      IF s <> '?' THEN Strings := ColorStringToRecord(s);
      s := ini.ReadString(Section,'Number','?');
      IF s <> '?' THEN Number := ColorStringToRecord(s);
      s := ini.ReadString(Section,'AsmBlock','?');
      IF s <> '?' THEN AsmBlock := ColorStringToRecord(s);
      s := ini.ReadString(Section,'MarkedBlock','?');
      IF s <> '?' THEN MarkedBlock := ColorStringToRecord(s);
      s := ini.ReadString(Section,'SearchMatch','?');
      IF s <> '?' THEN SearchMatch := ColorStringToRecord(s);
      s := ini.ReadString(Section,'ValidBreak','?');
      IF s <> '?' THEN ValidBreak := ColorStringToRecord(s);
      s := ini.ReadString(Section,'InvalidBreak','?');
      IF s <> '?' THEN InvalidBreak := ColorStringToRecord(s);
      s := ini.ReadString(Section,'ExecPoint','?');
      IF s <> '?' THEN ExecPoint := ColorStringToRecord(s);
      s := ini.ReadString(Section,'ErrorLine','?');
      IF s <> '?' THEN ErrorLine := ColorStringToRecord(s);
      s := ini.ReadString(Section,'RightMargin','?');
      IF s <> '?' THEN RightMargin := ColorStringToRecord(s);
    END;

    {Section Fonts}
    Section := 'Fonts';
    WITH IdeSet.Fonts DO
    BEGIN
      ApplicationFont := ini.ReadString(Section,'ApplicationFont',ApplicationFont);
      InspectorFont := ini.ReadString(Section,'InspectorFont',InspectorFont);
      NavigatorFont := ini.ReadString(Section,'NavigatorFont',NavigatorFont);
      EditorTabFont := ini.ReadString(Section,'EditorTabFont',EditorTabFont);
      EditorFont := ini.ReadString(Section,'EditorFont',EditorFont);
    END;

    {Section Tools}
    Section := 'Tools';
    FOR i := 0 TO MaxInt DO
    BEGIN
      f := 'Tool' + tostr(i);
      s := ini.ReadString(Section,f+'.Name','?');
      IF s = '?' THEN break; {keine weiteren Eintraege mehr vorhanden}
      New(ptd);
      ptd^.ToolName := s;
      ptd^.FileName := ini.ReadString(Section,f+'.Program','');
      ptd^.Parameter := ini.ReadString(Section,f+'.Parameter','');
      ptd^.MenuItem := NIL;
      ToolsList.Add(ptd);
    END;
    InsertToolMenuItems;

    {Section Macros}
    Section := 'Macros';
    WITH IdeSet DO
    BEGIN
      MacroFileName := ini.ReadString(Section,'EditorMacro','');
    END;
    GlobalMacroList.LoadEditorMacros;

    {Section Speedbar}
    Section := 'Speedbar';
    WITH IdeSet DO
    BEGIN
      SpeedbarWidth := ini.ReadInteger(Section,'SpeedbarWidth',SpeedbarWidth);

      s := ini.ReadString(Section,'TopRowCommands','?');
      IF s <> '?' THEN BuildToolButtonList(TopToolButtonList, s);

      s := ini.ReadString(Section,'BottomRowCommands','?');
      IF s <> '?' THEN BuildToolButtonList(BottomToolButtonList, s);
    END;

    { Compiler }
    Section := 'Compiler';
    WITH IdeSet DO
    BEGIN
      HelpCompilerFileName:=ini.ReadString(Section,'HelpCompilerFileName',GetBinDir + '\HelpCompile.cmd');
      HelpCompilerLanguage:=ini.ReadString(Section,'HelpCompilerLanguage','DE,EN');
    END;

    {--------------------------Projekt Standards-------------------------}
    {Section Standard Compiler Options}
    ReadCompOpt(IdeSet.CompOptOS2,'Standard Compiler Options');
    ReadCompOpt(IdeSet.CompOptWin,'Win32 Standard Compiler Options');

    {Section Standard Warning Options}
    ReadWarnOpt(IdeSet.WarnOptOS2,'Standard Compiler Warnings');
    ReadWarnOpt(IdeSet.WarnOptWin,'Win32 Standard Compiler Warnings');

    {Section Standard Linker Options}
    ReadLinkOpt(IdeSet.LinkOptOS2,'Standard Linker Options');
    ReadLinkOpt(IdeSet.LinkOptWin,'Win32 Standard Linker Options');

    {Section Standard Memory Sizes}
    Section := 'Standard Memory Sizes';
    WITH IdeSet.MemSizesOS2 DO
    BEGIN
      Heap := ini.ReadInteger(Section,'Heap',Heap);
      Stack := ini.ReadInteger(Section,'Stack',Stack);
    END;

    {Section Standard Memory Sizes}
    Section := 'Win32 Standard Memory Sizes';
    WITH IdeSet.MemSizesWin DO
    BEGIN
      Heap := ini.ReadInteger(Section,'Heap',Heap);
      Stack := ini.ReadInteger(Section,'Stack',Stack);
    END;


    {Section Standard Debugger Options}
    ReadDebugOpt(IdeSet.DebugOptOS2,'Standard Debugger Options');
    ReadDebugOpt(IdeSet.DebugOptWin,'Win32 Standard Debugger Options');

    {Section Standard Directories}
    ReadDirectories(IdeSet.DirectoriesOS2,'Standard Directories');
    ReadDirectories(IdeSet.DirectoriesWin,'Win32 Standard Directories');

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    Application.LogWriteln('LoadINI: Fehler aufgetreten');
    IF ini <> NIL THEN ini.Destroy;
  END;

  SetMainStatusText('',clBlack,clLtGray);

  {Screen Aufl”sung skalieren}
  ScaleDesktopForms;
  Application.LogWriteln('LoadINI: Ende');
END;


FUNCTION SaveINI(IdeSet:TIdeSettings):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section,f,s:STRING;
  i:LONGINT;
  ptd:PToolData;

  PROCEDURE WriteCompOpt(Var CompOpt:TCompilerOptions;Const Section:String);
  VAR s:STRING;
  BEGIN
       ini.EraseSection(Section);
       WITH CompOpt DO
       BEGIN
         s := '';
         IF CodeGen * [cg_ASMSource] <> [] THEN AddFlag(s,'ASMSource');
         IF CodeGen * [cg_InlineStrings] <> [] THEN AddFlag(s,'InlineStrings');
         IF CodeGen * [cg_Assertions] <> [] THEN AddFlag(s,'Assertions');
         IF CodeGen * [cg_SaveConstructors] <> [] THEN AddFlag(s,'SaveConstructors');
         ini.WriteString(Section,'CodeGeneration',s);

         s := '';
         IF Syntax * [sx_StrictVAR] <> [] THEN AddFlag(s,'StrictVAR');
         IF Syntax * [sx_CompleteBoolEval] <> [] THEN AddFlag(s,'CompleteBoolEval');
         ini.WriteString(Section,'Syntax',s);

         s := '';
         IF Optimize * [om_OptimizeCommonSub] <> [] THEN AddFlag(s,'OptimizeCommonSub');
         IF Optimize * [om_OptimizePeephole] <> [] THEN AddFlag(s,'OptimizePeephole');
         ini.WriteString(Section,'Optimize',s);

         s := '';
         IF Runtime * [rc_InOut] <> [] THEN AddFlag(s,'InOut');
         IF Runtime * [rc_Overflow] <> [] THEN AddFlag(s,'Overflow');
         IF Runtime * [rc_Stack] <> [] THEN AddFlag(s,'Stack');
         IF Runtime * [rc_Range] <> [] THEN AddFlag(s,'Range');
         ini.WriteString(Section,'RuntimeCheck',s);

         ini.WriteString(Section,'CondDefine',CondDef);
       END;
  END;

  PROCEDURE WriteWarnOpt(Var WarnOpt:TWarningOptions;Const Section:STRING);
  VAR s:STRING;
  BEGIN
       ini.EraseSection(Section);
       WITH WarnOpt DO
       BEGIN
         s := '';
         IF Warnings * [W_W1] <> [] THEN AddFlag(s,'W1');
         IF Warnings * [W_W2] <> [] THEN AddFlag(s,'W2');
         IF Warnings * [W_W3] <> [] THEN AddFlag(s,'W3');
         IF Warnings * [W_W4] <> [] THEN AddFlag(s,'W4');
         IF Warnings * [W_W5] <> [] THEN AddFlag(s,'W5');
         IF Warnings * [W_W6] <> [] THEN AddFlag(s,'W6');
         IF Warnings * [W_W7] <> [] THEN AddFlag(s,'W7');
         IF Warnings * [W_WAll] <> [] THEN AddFlag(s,'WAll');
         IF Warnings * [W_WNone] <> [] THEN AddFlag(s,'WNone');
         ini.WriteString(Section,'Warnings',s);

         ini.WriteInteger(Section,'MaxWarnings',MaxWarnings);
         ini.WriteInteger(Section,'MaxErrors',MaxErrors);
       END;
  END;

  PROCEDURE WriteLinkOpt(Var LinkOpt:TLinkerOptions;Const Section:STRING);
  BEGIN
       ini.EraseSection(Section);
       WITH LinkOpt DO
       BEGIN
         CASE DataSegment OF
           ds_Normal:       ini.WriteString(Section,'DataSegment','Normal');
           ds_SingleShared: ini.WriteString(Section,'DataSegment','SingleShared');
         END;

         CASE LinkerTarget OF
           lt_GUI:        ini.WriteString(Section,'LinkerTarget','GUI');
           lt_FullScreen: ini.WriteString(Section,'LinkerTarget','FullScreen');
           lt_Window:     ini.WriteString(Section,'LinkerTarget','Window');
         END;

         CASE ExePacking OF
           ep_None:     ini.WriteString(Section,'ExePacking','None');
           ep_ExePack1: ini.WriteString(Section,'ExePacking','ExePack1');
           ep_ExePack2: ini.WriteString(Section,'ExePacking','ExePack2');
         END;

         ini.WriteBool(Section,'RunVDM',RunVDM);

         ini.WriteString(Section,'CurrentLanguage',CurrentLanguage);
         ini.WriteString(Section,'InstallLanguages',InstallLanguages);
       END;
  END;

  PROCEDURE WriteDebugOpt(VAR DebugOpt:TDebuggerOptions;Const Section:STRING);
  VAR s:STRING;
  BEGIN
       ini.EraseSection(Section);
       WITH DebugOpt DO
       BEGIN
         s := '';
         IF Info * [di_LineNumbers] <> [] THEN AddFlag(s,'LineNumbers');
         IF Info * [di_LocalSymbols] <> [] THEN AddFlag(s,'LocalSymbols');
         ini.WriteString(Section,'DebugInfo',s);

         ini.WriteInteger(Section,'Dbg_Options',Options);

         ini.WriteInteger(Section,'RTL_Exceptions',RTL_Exceptions);
         ini.WriteInteger(Section,'SPCC_Exceptions',SPCC_Exceptions);
       END;
  END;

  PROCEDURE WriteDirectories(Var Directories:TDirectories;Const Section:STRING);
  BEGIN
       ini.EraseSection(Section);
       WITH Directories DO
       BEGIN
         ini.WriteString(Section,'LastDir',LastDir);
         ini.WriteString(Section,'OutDir',OutDir);
         ini.WriteString(Section,'LibDir',LibDir);
         ini.WriteString(Section,'LibSrcDir',LibSrcDir);
         ini.WriteString(Section,'IncSrcDir',IncSrcDir);
         ini.WriteString(Section,'CompInstallDir',CompInstallDir);

         CASE LastEditDir OF
           edOut:    ini.WriteString(Section,'LastEditDir','edOut');
           edLib:    ini.WriteString(Section,'LastEditDir','edLib');
           edLibSrc: ini.WriteString(Section,'LastEditDir','edLibSrc');
           edIncSrc: ini.WriteString(Section,'LastEditDir','edIncSrc');
           edComp:   ini.WriteString(Section,'LastEditDir','edComp');
         END;
       END;
  END;

BEGIN
  Application.LogWriteln('SaveINI: Start');
  Result := FALSE;
  SetMainStatusText(LoadNLSStr(SiSavingEnv),clBlack,clLtGray);

  GlobalMacroList.SaveEditorMacros;

  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(INIname);

    {Section General}
    Section := 'General';
    ini.EraseSection(Section);
    ini.WriteString(Section,'Version',IniVersion);
    ini.WriteString(Section,'LastProject',Project.FileName);
    ini.WriteBool(Section,'OpenMsgView',IdeSet.OpenMsgView);
    ini.WriteBool(Section,'GlobalHints',IdeSet.GlobalHints);
    ini.WriteInteger(Section,'TipNumber',IdeSet.TipNumber);
    ini.WriteBool(Section,'FlatButtons',IdeSet.FlatButtons);
    ini.WriteBool(Section,'EnableSound',IdeSet.EnableSound);
    ini.WriteBool(Section,'ShowBitBtnGlyph',IdeSet.ShowBitBtnGlyph);
    ini.WriteBool(Section,'EditorIconbar',IdeSet.EditorIconbar);
    ini.WriteBool(Section,'LoadLastProject',IdeSet.LoadLastPrj);
    ini.WriteBool(Section,'AskRecompile',IdeSet.AskRecompile);
    IF IdeSet.DroppingFile = df_Import
      THEN s := 'Import'
      ELSE s := 'Open';
    ini.WriteString(Section,'DroppingFile',s);
    ini.WriteInteger(Section,'ScreenWidth',CXScreen);
    ini.WriteInteger(Section,'ScreenHeight',CYScreen);
    case IdeSet.CompilerPriority of
      tpIdle  : s:='Idle';
      tpLowest: s:='Lowest';
      tpLower : s:='Lower';
      tpNormal: s:='Normal';
    end;
    ini.WriteString(Section,'CompilerPriority',s);

    {Section Directories}
    Section := 'Directories';
    ini.EraseSection(Section);
    ini.WriteString(Section,'InstallDir',IdeSet.InstallDir);
    ini.WriteString(Section,'BinDir',IdeSet.BinDir);
    ini.WriteString(Section,'ProjectDir',IdeSet.ProjectDir);
    ini.WriteString(Section,'TemplateDir',IdeSet.TemplateDir);

    {Section Project History}
    Section := 'Project History';
    ini.EraseSection(Section);
    FOR i := 0 TO MaxHistoryProjects-1 DO
    BEGIN
      IF i >= ProjectsHistory.Count THEN break;
      f := 'Project' + tostr(i);
      ini.WriteString(Section,f,ProjectsHistory.Strings[i]);
    END;


    {Section Find In Files}
    Section := 'Find In Files';
    ini.EraseSection(Section);
    WITH IdeSet.FindFiles DO
    BEGIN
      ini.WriteString(Section,'LastFilter',LastFilter);
      ini.WriteString(Section,'LastPath',LastPath);
      ini.WriteBool(Section,'Recursive',Recursive);
      ini.WriteBool(Section,'CaseSense',CaseSense);
      ini.WriteBool(Section,'WordsOnly',WordsOnly);
    END;

    FOR i := 0 TO FindInFilesHistory.Count-1 DO
    BEGIN
      IF i >= 16 THEN break;
      f := 'Find' + tostr(i);
      ini.WriteString(Section,f,FindInFilesHistory.Strings[i]);
    END;

    FOR i := 0 TO FindInFilesFilter.Count-1 DO
    BEGIN
      f := 'Filter' + tostr(i);
      ini.WriteString(Section,f,FindInFilesFilter.Strings[i]);
    END;

    FOR i := 0 TO FindInFilesPaths.Count-1 DO
    BEGIN
      IF i >= 8 THEN break;
      f := 'Path' + tostr(i);
      ini.WriteString(Section,f,FindInFilesPaths.Strings[i]);
    END;


    {Section MainForm}
    Section := 'MainForm';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_MainWindow] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;


    {Section Static Toolbars}
    Section := 'Static Toolbars';
    ini.EraseSection(Section);
    WITH IdeSet DO
    BEGIN
      s := '';
      IF st_Speedbar IN StaticToolbars THEN AddFlag(s,'Speedbar');
      IF st_CompPalette IN StaticToolbars THEN AddFlag(s,'CompPalette');
      IF st_Statusbar IN StaticToolbars THEN AddFlag(s,'Statusbar');
      ini.WriteString(Section,'VisibleToolbars',s);
    END;


    {Section Code Editor}
    Section := 'Code Editor';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_CodeEditor] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;


    {Section Object Inspector}
    Section := 'Object Inspector';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_Inspector] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.Inspect DO
    BEGIN
      ini.WriteInteger(Section,'PropertyNameSize',PropertyNameSize);
      ini.WriteInteger(Section,'EventNameSize',EventNameSize);
    END;

    {Section Object Browser}
    Section := 'Object Browser';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_Browser] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.Browse DO
    BEGIN
      ini.WriteInteger(Section,'DetailWindowWidth',DetailWindowWidth);

      CASE ViewMode OF
        mo_Objects: ini.WriteString(Section,'ViewMode','Objects');
        mo_Globals: ini.WriteString(Section,'ViewMode','Globals');
        mo_Units:   ini.WriteString(Section,'ViewMode','Units');
      END;

      FOR i := Browser_Constants TO Browser_Published DO
        ini.WriteBool(Section,BrowserHints[i],Buttons[i]);

      s := '';
      IF Files * [bf_RTL] <> [] THEN AddFlag(s,'RTL');
      IF Files * [bf_SPCC] <> [] THEN AddFlag(s,'SPCC');
      IF Files * [bf_Project] <> [] THEN AddFlag(s,'Project');
      ini.WriteString(Section,'Files',s);
    END;

    {Section Code Insight}
    Section := 'Code Insight';
    WITH IdeSet.CodeInsight DO
    BEGIN
      ini.WriteInteger(Section,'TimerValue',TimerValue);

      ini.WriteBool(Section,'CodeCompletion',CodeCompletion);
      ini.WriteBool(Section,'CodeParameter',CodeParameter);
      ini.WriteBool(Section,'ToolTips',ToolTips);

      SaveCodeTemplates;
    END;

    {Section Component List}
    Section := 'Component List';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_CompList] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    {Section Window List}
    Section := 'Window List';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_WindowList] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    {Section Macro List}
    Section := 'Macro List';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_MacroList] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    {Section Clipboard History}
    Section := 'Clipboard History';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_ClipboardList] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    {Section CPU Window}
    Section := 'CPU Window';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_CPUWindow] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.CPUWin DO
    BEGIN
      ini.WriteInteger(Section,'DumpNoteBookHeight',DumpNoteBookHeight);
      ini.WriteInteger(Section,'RegisterNoteBookWidth',RegNoteBookWidth);
    END;

    {Section Project Manager}
    Section := 'Project Manager';
    ini.EraseSection(Section);
    WITH IdeSet.DesktopWindows[dwi_ProjectManager] DO
    BEGIN
      ini.WriteInteger(Section,'Left',X);
      ini.WriteInteger(Section,'Bottom',Y);
      ini.WriteInteger(Section,'Width',CX);
      ini.WriteInteger(Section,'Height',CY);
      ini.WriteBool(Section,'Visible',Visible);
    END;

    WITH IdeSet.PrjMan DO
    BEGIN
      ini.WriteInteger(Section,'FormListSize',FormListSize);
    END;

    {Section Form Designer}
    Section := 'Form Designer';
    ini.EraseSection(Section);
    WITH IdeSet.Designer DO
    BEGIN
      CASE InsertMode OF
        ci_DropSize: ini.WriteString(Section,'InsertMode','DropSize');
        ci_DropMove: ini.WriteString(Section,'InsertMode','DropMove');
      END;
      CASE MultiSelectMode OF
        cs_Include: ini.WriteString(Section,'MultiSelectMode','IncludeRect');
        cs_Touch:   ini.WriteString(Section,'MultiSelectMode','TouchRect');
      END;
      ini.WriteInteger(Section,'GridWidth',GridWidth);
      ini.WriteInteger(Section,'GridHeight',GridHeight);
      ini.WriteBool(Section,'GridActive',GridActive);
      ini.WriteBool(Section,'GridVisible',GridVisible);
      ini.WriteBool(Section,'AutoCreateForm',AutoCreateForm);
    END;

    {Section Source Code Generation}
    Section := 'Source Code Generation';
    ini.EraseSection(Section);
    WITH IdeSet.CodeGen DO
    BEGIN
      CASE IdentifierStyle OF
        is_Uppercase: ini.WriteString(Section,'IdentifierStyle','Uppercase');
        is_Lowercase: ini.WriteString(Section,'IdentifierStyle','Lowercase');
        is_Mixed:     ini.WriteString(Section,'IdentifierStyle','Mixed');
      END;
      ini.WriteInteger(Section,'IndentBlock',IndentBlock);
      ini.WriteInteger(Section,'IndentScope',IndentScope);
      ini.WriteInteger(Section,'IndentField',IndentField);
      ini.WriteInteger(Section,'IndentSpace',IndentSpace);
      ini.WriteInteger(Section,'LineBreak',LineBreak);
    END;

    {Section Editor Options}
    Section := 'Editor Options';
    ini.EraseSection(Section);
    WITH IdeSet.EditOpt DO
    BEGIN
      CASE Cursor OF
        ec_Underline: ini.WriteString(Section,'Cursor','Underline');
        ec_Vertical:  ini.WriteString(Section,'Cursor','Vertical');
      END;

      CASE Mouse OF
        em_Arrow: ini.WriteString(Section,'MouseShape','Arrow');
        em_IBeam: ini.WriteString(Section,'MouseShape','IBeam');
      END;

      CASE KeyMap OF
        km_WordStar: ini.WriteString(Section,'KeyMap','WordStar');
        km_CUA:      ini.WriteString(Section,'KeyMap','CUA');
        km_Default:  ini.WriteString(Section,'KeyMap','Default');
        km_Custom:   ini.WriteString(Section,'KeyMap','Custom');
      END;

      CASE Style OF
        cs_TabSet: ini.WriteString(Section,'Style','TabSet');
        cs_MDI:    ini.WriteString(Section,'Style','MDI');
      END;

      s := '';
      IF Options * [eo_InsertMode] <> [] THEN AddFlag(s,'InsertMode');
      IF Options * [eo_AutoIndent] <> [] THEN AddFlag(s,'AutoIndent');
      IF Options * [eo_Unindent] <> [] THEN AddFlag(s,'Unindent');
      IF Options * [eo_CursorClimb] <> [] THEN AddFlag(s,'CursorClimb');
      IF Options * [eo_2ClickLine] <> [] THEN AddFlag(s,'2ClickLine');
      IF Options * [eo_PersistentBlock] <> [] THEN AddFlag(s,'PersistentBlock');
      IF Options * [eo_OverwriteBlock] <> [] THEN AddFlag(s,'OverwriteBlock');
      IF Options * [eo_UndoGroups] <> [] THEN AddFlag(s,'UndoGroups');
      IF Options * [eo_WordWrap] <> [] THEN AddFlag(s,'WordWrap');
      IF Options * [eo_SmartTabs] <> [] THEN AddFlag(s,'SmartTabs');
      IF Options * [eo_HomeFirstWord] <> [] THEN AddFlag(s,'HomeFirstWord');
      IF Options * [eo_AddIndent] <> [] THEN AddFlag(s,'AddIndent');
      IF Options * [eo_AutoBracket] <> [] THEN AddFlag(s,'AutoBracket');
      ini.WriteString(Section,'Options',s);

      s := '';
      IF Behaviour * [eb_Backups] <> [] THEN AddFlag(s,'Backups');
      IF Behaviour * [eb_AppendBAK] <> [] THEN AddFlag(s,'AppendBAK');
      IF Behaviour * [eb_TextFromCursor] <> [] THEN AddFlag(s,'TextFromCursor');
      IF Behaviour * [eb_ChangeDirOnOpen] <> [] THEN AddFlag(s,'ChangeDirOnOpen');
      IF Behaviour * [eb_FullNameTitle] <> [] THEN AddFlag(s,'FullNameTitle');
      IF Behaviour * [eb_AutoSave] <> [] THEN AddFlag(s,'AutoSave');
      IF Behaviour * [eb_SyntaxHigh] <> [] THEN AddFlag(s,'SyntaxHighlight');
      ini.WriteString(Section,'Behaviour',s);

      CASE Select OF
        es_NonInclusive: ini.WriteString(Section,'Selection','NonInclusive');
        es_Column:       ini.WriteString(Section,'Selection','Column');
      END;

      ini.WriteInteger(Section,'TabulatorSize',TabulatorSize);
      ini.WriteInteger(Section,'UndoEvents',UndoEvents);
      ini.WriteInteger(Section,'SaveEvents',SaveEvents);
      ini.WriteInteger(Section,'WrapColumn',WrapColumn);
    END;

    {Section FindStruct}
    Section := 'Find Structure';
    ini.EraseSection(Section);
    WITH IdeSet.EditOpt.FindStruct DO
    BEGIN
      ini.WriteString(Section,'Find',Find);

      CASE Direction OF
        fd_Forward:  ini.WriteString(Section,'Direction','Forward');
        fd_Backward: ini.WriteString(Section,'Direction','Backward');
      END;

      CASE Origin OF
        fo_EntireScope: ini.WriteString(Section,'Origin','EntireScope');
        fo_Cursor:      ini.WriteString(Section,'Origin','Cursor');
      END;

      CASE Scope OF
        fs_Global:     ini.WriteString(Section,'Scope','Global');
        fs_Selection:  ini.WriteString(Section,'Scope','Selection');
        fs_AllEditors: ini.WriteString(Section,'Scope','AllEditors');
      END;

      s := '';
      IF Options * [fo_CaseSensitive] <> [] THEN AddFlag(s,'CaseSensitive');
      IF Options * [fo_WordsOnly] <> [] THEN AddFlag(s,'WordsOnly');
      ini.WriteString(Section,'Options',s);
    END;

    {Section ReplStruct}
    Section := 'Replace Structure';
    ini.EraseSection(Section);
    WITH IdeSet.EditOpt.ReplStruct DO
    BEGIN
      ini.WriteString(Section,'Find',Find);
      ini.WriteString(Section,'Replace',Replace);

      CASE Direction OF
        fd_Forward:  ini.WriteString(Section,'Direction','Forward');
        fd_Backward: ini.WriteString(Section,'Direction','Backward');
      END;

      CASE Origin OF
        fo_EntireScope: ini.WriteString(Section,'Origin','EntireScope');
        fo_Cursor:      ini.WriteString(Section,'Origin','Cursor');
      END;

      CASE Scope OF
        fs_Global:     ini.WriteString(Section,'Scope','Global');
        fs_Selection:  ini.WriteString(Section,'Scope','Selection');
        fs_AllEditors: ini.WriteString(Section,'Scope','AllEditors');
      END;

      s := '';
      IF Options * [fo_CaseSensitive] <> [] THEN AddFlag(s,'CaseSensitive');
      IF Options * [fo_WordsOnly] <> [] THEN AddFlag(s,'WordsOnly');
      ini.WriteString(Section,'Options',s);

      ini.WriteBool(Section,'Confirm',Confirm);
      ini.WriteBool(Section,'ReplaceAll',ReplAll);
    END;

    {Section Auto}
    Section := 'Auto';
    ini.EraseSection(Section);
    WITH IdeSet DO
    BEGIN
      s := '';
      IF AutoSave * [as_Project] <> [] THEN AddFlag(s,'Project');
      IF AutoSave * [as_EditorFiles] <> [] THEN AddFlag(s,'EditorFiles');
      IF AutoSave * [as_SCU] <> [] THEN AddFlag(s,'SCU');
      IF AutoSave * [as_INI] <> [] THEN AddFlag(s,'INI');
      ini.WriteString(Section,'AutoSave',s);

      s := '';
      IF AutoRename * [ar_Unit] <> [] THEN AddFlag(s,'Unit');    {CodeGen?}
      IF AutoRename * [ar_Uses] <> [] THEN AddFlag(s,'Uses');    {CodeGen?}
      IF AutoRename * [ar_SCU] <> [] THEN AddFlag(s,'SCU');      {CodeGen?}
      IF AutoRename * [ar_FormLocation] <> [] THEN AddFlag(s,'FormLocation');
      IF AutoRename * [ar_ProjectFiles] <> [] THEN AddFlag(s,'ProjectFiles');
      ini.WriteString(Section,'AutoRename',s);
    END;


    {Section Colors}
    Section := 'Color Table';
    ini.EraseSection(Section);
    WITH IdeSet.Colors.Editor DO
    BEGIN
      ini.WriteString(Section,'Comment1',ColorRecordToString(Comment1));
      ini.WriteString(Section,'Comment2',ColorRecordToString(Comment2));
      ini.WriteString(Section,'Comment3',ColorRecordToString(Comment3));
      ini.WriteString(Section,'Comment4',ColorRecordToString(Comment4));
      ini.WriteString(Section,'Comment5',ColorRecordToString(Comment5));
      ini.WriteString(Section,'ReservedWord',ColorRecordToString(ReservedWord));
      ini.WriteString(Section,'PlainText',ColorRecordToString(PlainText));
      ini.WriteString(Section,'Symbol',ColorRecordToString(Symbol));
      ini.WriteString(Section,'String',ColorRecordToString(Strings));
      ini.WriteString(Section,'Number',ColorRecordToString(Number));
      ini.WriteString(Section,'AsmBlock',ColorRecordToString(AsmBlock));
      ini.WriteString(Section,'MarkedBlock',ColorRecordToString(MarkedBlock));
      ini.WriteString(Section,'SearchMatch',ColorRecordToString(SearchMatch));
      ini.WriteString(Section,'ValidBreak',ColorRecordToString(ValidBreak));
      ini.WriteString(Section,'InvalidBreak',ColorRecordToString(InvalidBreak));
      ini.WriteString(Section,'ExecPoint',ColorRecordToString(ExecPoint));
      ini.WriteString(Section,'ErrorLine',ColorRecordToString(ErrorLine));
      ini.WriteString(Section,'RightMargin',ColorRecordToString(RightMargin));
    END;

    {Section Fonts}
    Section := 'Fonts';
    ini.EraseSection(Section);
    WITH IdeSet.Fonts DO
    BEGIN
      ini.WriteString(Section,'ApplicationFont',ApplicationFont);
      ini.WriteString(Section,'InspectorFont',InspectorFont);
      ini.WriteString(Section,'NavigatorFont',NavigatorFont);
      ini.WriteString(Section,'EditorTabFont',EditorTabFont);
      ini.WriteString(Section,'EditorFont',EditorFont);
    END;

    {Section Tools}
    Section := 'Tools';
    ini.EraseSection(Section);
    FOR i := 0 TO ToolsList.Count-1 DO
    BEGIN
      ptd := ToolsList[i];
      s := 'Tool' + tostr(i);
      ini.WriteString(Section,s+'.Name',ptd^.ToolName);
      ini.WriteString(Section,s+'.Program',ptd^.FileName);
      ini.WriteString(Section,s+'.Parameter',ptd^.Parameter);
    END;

    {Section Macros}
    Section := 'Macros';
    ini.EraseSection(Section);
    WITH IdeSet DO
    BEGIN
      ini.WriteString(Section,'EditorMacro',MacroFileName);
    END;

    {Section Speedbar}
    Section := 'Speedbar';
    ini.EraseSection(Section);
    WITH IdeSet DO
    BEGIN
      ini.WriteInteger(Section,'SpeedbarWidth',SpeedbarWidth);

      s := '';
      FOR i := 0 TO TopToolButtonList.Count-1 DO
      BEGIN
        AddFlag(s, tostr(LONGINT(TopToolButtonList[i])));
      END;
      ini.WriteString(Section,'TopRowCommands',s);

      s := '';
      FOR i := 0 TO BottomToolButtonList.Count-1 DO
      BEGIN
        AddFlag(s, tostr(LONGINT(BottomToolButtonList[i])));
      END;
      ini.WriteString(Section,'BottomRowCommands',s);
    END;

    { Compiler }
    Section := 'Compiler';
    WITH IdeSet DO
    BEGIN
      ini.WriteString(Section,'HelpCompilerFileName',HelpCompilerFileName);
      ini.WriteString(Section,'HelpCompilerLanguage',HelpCompilerLanguage);
    END;

    {--------------------------Projekt Standards-------------------------}
    {Section Standard Compiler Options}
    WriteCompOpt(IdeSet.CompOptOS2,'Standard Compiler Options');
    WriteCompOpt(IdeSet.CompOptWin,'Win32 Standard Compiler Options');

    {Section Standard Compiler Warnings}
    WriteWarnOpt(IdeSet.WarnOptOS2,'Standard Compiler Warnings');
    WriteWarnOpt(IdeSet.WarnOptWin,'Win32 Standard Compiler Warnings');

    {Section Standard Linker Options}
    WriteLinkOpt(IdeSet.LinkOptOS2,'Standard Linker Options');
    WriteLinkOpt(IdeSet.LinkOptWin,'Win32 Standard Linker Options');

    {Section Standard Memory Sizes}
    Section := 'Standard Memory Sizes';
    ini.EraseSection(Section);
    WITH IdeSet.MemSizesOS2 DO
    BEGIN
      ini.WriteInteger(Section,'Heap',Heap);
      ini.WriteInteger(Section,'Stack',Stack);
    END;

    {Section Standard Memory Sizes}
    Section := 'Win32 Standard Memory Sizes';
    ini.EraseSection(Section);
    WITH IdeSet.MemSizesWin DO
    BEGIN
      ini.WriteInteger(Section,'Heap',Heap);
      ini.WriteInteger(Section,'Stack',Stack);
    END;

    {Section Standard Debugger Options}
    WriteDebugOpt(IdeSet.DebugOptOS2,'Standard Debugger Options');
    WriteDebugOpt(IdeSet.DebugOptWin,'Win32 Standard Debugger Options');

    {Section Standard Directories}
    WriteDirectories(IdeSet.DirectoriesOS2,'Standard Directories');
    WriteDirectories(IdeSet.DirectoriesWin,'Win32 Standard Directories');

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    Application.LogWriteln('SaveINI: Fehler');
    IF ini <> NIL THEN ini.Destroy;
  END;

  WriteDockingToolbars;

  IdeSet.Modified := FALSE;
  SetMainStatusText('',clBlack,clLtGray);
  Application.LogWriteln('SaveINI: Ende');
END;


{ Docking Toolbars der VDE }

FUNCTION AddPalette(CONST Name,Caption:STRING):TDockingPalette;
VAR  PanelForm:TForm;
BEGIN
  PanelForm.Create(NIL);
  PanelForm.HelpContext := hctxDialogDockingPanelForm;
  PanelForm.Name := Name;
  PanelForm.Caption := Caption;
  PanelForm.Color := clLtGray;
  PanelForm.Visible := FALSE;
  PanelForm.PopupMenu := PalettenPopup;
  PanelForm.OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
  PanelForm.OnRestore := Application.MainForm.OnRestore;

  Result.Create(PanelForm);
  Result.Name := Name;
  Result.Parent := PanelForm;
  Result.OnDocking := Project.EvDocking;

  Paletten.AddObject(Caption,Result);


  Result.MenuItem.Create(PalettenPopup);
  Result.MenuItem.Caption := Caption;
  Result.MenuItem.Tag := LONGWORD(Result);
  Result.MenuItem.OnClick := Project.EvPaletteClick;
  PalettenPopup.Items.Add(Result.MenuItem);
END;


FUNCTION AddPalettenItem(Palette:TControl;Cmd:TCommand):TControl;
VAR  i,p:LONGINT;
     SpeedBtn:TXPLButton;
     Hint:STRING;

LABEL error;
BEGIN
//  Application.LogWriteln('AddPalettenItem:' + toStr(cmd));
  Result := NIL;

  i := CommandToIndex(Cmd);
  IF i < 0 THEN exit;

  IF MenuEntries[i].Bmp = 1111 THEN exit;  {kein Bitmap da}

  IF MenuEntries[i].Btn <> NIL THEN exit;  {schon belegt}

  try
    SpeedBtn := InsertXPLButtonNLS(Palette,0,0,
       SpeedButtonSize,SpeedButtonSize, MenuEntries[i].Bmp,0,
       IdeSettings.FlatButtons);
  except
    Application.LogWriteln('AddPalettenItem: Error');
    goto error;
  end;

  SpeedBtn.NumGlyphs := 2;
  SpeedBtn.Command := Cmd;
  SpeedBtn.HelpContext := MenuEntries[i].hctx;
  SpeedBtn.Enabled := FALSE;

  IF MenuEntries[i].Text <> 0 THEN
  BEGIN
    Hint := LoadNLSStr(MenuEntries[i].Text);
    p := pos('~',Hint);
    IF p > 0 THEN delete(Hint,p,1);
    p := pos('...',Hint);
    IF p > 0 THEN delete(Hint,p,3);
    SpeedBtn.Hint := Hint;
  END;

  Include(SpeedBtn.ComponentState, csDetail); {send command to panel}

  MenuEntries[i].Btn := SpeedBtn;

  {Sonderflle fr Commands abtesten}

  CASE Cmd OF
    cmGridVis:
    BEGIN
         SpeedBtn.GroupIndex := Cmd; {Hauptsache verschieden}
         SpeedBtn.AllowAllUp := TRUE;
         GridVisibleBtn := SpeedBtn;
         GridVisibleBtn.Down := IdeSettings.Designer.GridVisible;
    END;
    cmSnapToGrid:
    BEGIN
         SpeedBtn.GroupIndex := Cmd; {Hauptsache verschieden}
         SpeedBtn.AllowAllUp := TRUE;
         SnapToGridBtn := SpeedBtn;
         SnapToGridBtn.Down := IdeSettings.Designer.GridActive;
    END;
    cmDesignPos:
    BEGIN
         SpeedBtn.Width := 3 * SpeedButtonSize;
         DesignPosBtn := Speedbtn;
    END;
  END;

  Result := SpeedBtn;

error:
//  Application.LogWriteln('AddPalettenItem-Ende');
END;


PROCEDURE InitializeToolbars;
VAR  Panel:TDockingPalette;
     MenuItem:TMenuItem;
BEGIN // den ersten Parameter nicht eindeutschen
//  Application.LogWriteln('InitializeToolbars');
  Panel := AddPalette('File',LoadNLSStr(SiToolbarFile));
  AddPalettenItem(Panel,cmNewObject);
  AddPalettenItem(Panel,cmNew);
  AddPalettenItem(Panel,cmOpen);
  AddPalettenItem(Panel,cmInsertFile);
  AddPalettenItem(Panel,cmSave);
  AddPalettenItem(Panel,cmSaveAs);
  AddPalettenItem(Panel,cmSaveAll);
  AddPalettenItem(Panel,cmPrint);
  AddPalettenItem(Panel,cmCreateDir);
  AddPalettenItem(Panel,cmChangeDir);
  AddPalettenItem(Panel,cmExit);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Edit');
  Panel := AddPalette('Edit',LoadNLSStr(SiToolbarEdit));
  AddPalettenItem(Panel,cmSlidingUndo);
  AddPalettenItem(Panel,cmRedo);
  AddPalettenItem(Panel,cmCut);
  AddPalettenItem(Panel,cmCopy);
  AddPalettenItem(Panel,cmPaste);
  AddPalettenItem(Panel,cmDelete);
  AddPalettenItem(Panel,cmSelectAll);
  AddPalettenItem(Panel,cmDeselectAll);
  AddPalettenItem(Panel,cmMacroRecord);
  AddPalettenItem(Panel,cmMacroPlay);
  AddPalettenItem(Panel,cmMacroSave);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Search');
  Panel := AddPalette('Search',LoadNLSStr(SiToolbarSearch));
  AddPalettenItem(Panel,cmFind);
  AddPalettenItem(Panel,cmReplace);
  AddPalettenItem(Panel,cmSearchAgain);
  AddPalettenItem(Panel,cmIncrementalSearch);
  AddPalettenItem(Panel,cmMatchingBrace);
  AddPalettenItem(Panel,cmFindInFiles);
  AddPalettenItem(Panel,cmGotoLine);
  AddPalettenItem(Panel,cmGotoLastError);
  AddPalettenItem(Panel,cmBookMarks);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: View');
  Panel := AddPalette('View',LoadNLSStr(SiToolbarView));
  AddPalettenItem(Panel,cmProjectManager);
  AddPalettenItem(Panel,cmViewBrowser);
  AddPalettenItem(Panel,cmWindowList);
  AddPalettenItem(Panel,cmMacroList);
  AddPalettenItem(Panel,cmClipBoardList);
  AddPalettenItem(Panel,cmViewInspector);
  AddPalettenItem(Panel,cmViewComponents);
  AddPalettenItem(Panel,cmFormUnit);
  AddPalettenItem(Panel,cmNewForm);
  AddPalettenItem(Panel,cmImport);
  AddPalettenItem(Panel,cmToolbars);
  AddPalettenItem(Panel,cmToggleSpeedbar);
  AddPalettenItem(Panel,cmToggleNavigator);
  AddPalettenItem(Panel,cmToggleStatusbar);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Components');
  Panel := AddPalette('Components',LoadNLSStr(SiToolbarComponents));
  AddPalettenItem(Panel,cmNewComponent);
  AddPalettenItem(Panel,cmInstallComponents);
  AddPalettenItem(Panel,cmRemoveComponents);
  AddPalettenItem(Panel,cmOpenCompLib);
  AddPalettenItem(Panel,cmRecompileCompLib);
  AddPalettenItem(Panel,cmConfigurePalette);
  AddPalettenItem(Panel,cmViewRepository);
  AddPalettenItem(Panel,cmLoadTemplateForms);
  AddPalettenItem(Panel,cmSaveTemplateForms);
  AddPalettenItem(Panel,cmAddToRepository);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Debug');
  Panel := AddPalette('Debug',LoadNLSStr(SiToolbarDebug));
  AddPalettenItem(Panel,cmToggleBreakPoint);
  AddPalettenItem(Panel,cmClearAllBreakPoints);
  AddPalettenItem(Panel,cmGo);
  AddPalettenItem(Panel,cmGotoDebugCursor);
  AddPalettenItem(Panel,cmStepOver);
  AddPalettenItem(Panel,cmStepInto);
  AddPalettenItem(Panel,cmReturnFromFunction);
  AddPalettenItem(Panel,cmProgramReset);
  AddPalettenItem(Panel,cmProgramReload);
  AddPalettenItem(Panel,cmEvaluateModify);
  AddPalettenItem(Panel,cmAddWatch);
  AddPalettenItem(Panel,cmInspectValue);
  AddPalettenItem(Panel,cmWatchpoints);
  AddPalettenItem(Panel,cmLocalVariables);
  AddPalettenItem(Panel,cmViewWatch);
  AddPalettenItem(Panel,cmBreakpoints);
  AddPalettenItem(Panel,cmViewDump);
  AddPalettenItem(Panel,cmViewSource);
  AddPalettenItem(Panel,cmViewSymbols);
  AddPalettenItem(Panel,cmViewCPU);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Project');
  Panel := AddPalette('Project',LoadNLSStr(SiToolbarProject));
  AddPalettenItem(Panel,cmRun);
  AddPalettenItem(Panel,cmRunParameters);
  AddPalettenItem(Panel,cmCompile);
  AddPalettenItem(Panel,cmMake);
  AddPalettenItem(Panel,cmBuild);
  AddPalettenItem(Panel,cmStopCompiler);
  AddPalettenItem(Panel,cmProjectNew);
  AddPalettenItem(Panel,cmProjectLoad);
  AddPalettenItem(Panel,cmProjectClose);
  AddPalettenItem(Panel,cmProjectSave);
  AddPalettenItem(Panel,cmProjectSaveAs);
  AddPalettenItem(Panel,cmSetPrimary);
  AddPalettenItem(Panel,cmClearPrimary);
  AddPalettenItem(Panel,cmProjectSettings);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Options');
  Panel := AddPalette('Options',LoadNLSStr(SiToolbarOptions));
  AddPalettenItem(Panel,cmGeneral);
  AddPalettenItem(Panel,cmCustomize);
  AddPalettenItem(Panel,cmLanguageSettings);
  AddPalettenItem(Panel,cmToolOptions);
  AddPalettenItem(Panel,cmTool0);
  AddPalettenItem(Panel,cmTool1);
  AddPalettenItem(Panel,cmTool2);
  AddPalettenItem(Panel,cmTool3);
  AddPalettenItem(Panel,cmTool4);
  AddPalettenItem(Panel,cmTool5);
  AddPalettenItem(Panel,cmTool6);
  AddPalettenItem(Panel,cmTool7);
  AddPalettenItem(Panel,cmTool8);
  AddPalettenItem(Panel,cmTool9);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Window');
  Panel := AddPalette('Window',LoadNLSStr(SiToolbarWindow));
  AddPalettenItem(Panel,cmTile);
  AddPalettenItem(Panel,cmCascade);
  AddPalettenItem(Panel,cmCloseAll);
  AddPalettenItem(Panel,cmMaximizeRestore);
  AddPalettenItem(Panel,cmNext);
  AddPalettenItem(Panel,cmPrevious);
  AddPalettenItem(Panel,cmCloseTop);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Help');
  Panel := AddPalette('Help',LoadNLSStr(SiToolbarHelp));
  AddPalettenItem(Panel,cmHelpContents);
  AddPalettenItem(Panel,cmHelpIndex);
  AddPalettenItem(Panel,cmHelpOnHelp);
  AddPalettenItem(Panel,cmKeysHelp);
  AddPalettenItem(Panel,cmTopicSearch);
  AddPalettenItem(Panel,cmAbout);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: Layout');
  Panel := AddPalette('Layout',LoadNLSStr(SiToolbarLayout));
  AddPalettenItem(Panel,cmAlign1);
  AddPalettenItem(Panel,cmAlign2);
  AddPalettenItem(Panel,cmAlign3);
  AddPalettenItem(Panel,cmAlign4);
  AddPalettenItem(Panel,cmAlign5);
  AddPalettenItem(Panel,cmAlign6);
  AddPalettenItem(Panel,cmAlign7);
  AddPalettenItem(Panel,cmAlign8);
  AddPalettenItem(Panel,cmAlign9);
  AddPalettenItem(Panel,cmAlign10);
  AddPalettenItem(Panel,cmAlign11);
  AddPalettenItem(Panel,cmAlign12);
  AddPalettenItem(Panel,cmAlign13);
  AddPalettenItem(Panel,cmAlign14);
  AddPalettenItem(Panel,cmForceAlign);
  AddPalettenItem(Panel,cmRefresh);
  AddPalettenItem(Panel,cmDelCtrl);
  AddPalettenItem(Panel,cmGridVis);
  AddPalettenItem(Panel,cmSnapToGrid);
  AddPalettenItem(Panel,cmDesignPos);
  Panel.DockingState := dsHide;
  AlignmentPalette := Panel;

//  Application.LogWriteln('InitializeToolbars: ControlCentre');
  Panel := AddPalette('ControlCentre',LoadNLSStr(SiToolbarControlCentre));
  InitControlCentreProc(Panel);
  Panel.DockingState := dsHide;

//  Application.LogWriteln('InitializeToolbars: MenueItem');
  MenuItem.Create(PalettenPopup);
  MenuItem.Caption := '-';
  PalettenPopup.Items.Add(MenuItem);

  MenuItem.Create(PalettenPopup);
  MenuItem.Caption := LoadNLSStr(SiTbPopupProperties);
  MenuItem.Tag := 0;
  MenuItem.OnClick := Project.EvPaletteProperties;
  PalettenPopup.Items.Add(MenuItem);
//  Application.LogWriteln('InitializeToolbars-Ende');
END;


FUNCTION ReadToolbars:BOOLEAN;
BEGIN
//  Application.LogWriteln('ReadToolbars');
  InitializeToolbars;
  Result := TRUE;
  ReadDockingToolbars;
//  Application.LogWriteln('ReadToolbars-Ende');
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TProjectFiles Class implementation                          บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TProjectFiles.Clear;
VAR  i:LONGINT;
     ppf:PProjectFile;
BEGIN
     FOR i := 0 TO Count-1 DO
     BEGIN
          ppf := PProjectFile(Objects[i]);
          DestroyItem(ppf);
     END;

     Inherited Clear;
END;


PROCEDURE TProjectFiles.DestroyItem(ppf:PProjectFile);
BEGIN
     IF ppf = NIL THEN exit;
     IF ppf^.ASub <> NIL THEN ppf^.ASub.Destroy;
     Dispose(ppf);
END;


FUNCTION TProjectFiles.AddFile(Name:STRING;Expanded:BOOLEAN):PProjectFile;
VAR  ppf:PProjectFile;
BEGIN
     New(ppf);
     ppf^.ExeExt := '';
     ppf^.CheckSum := 0;
     ppf^.Expanded := Expanded;
     ppf^.ASub := NIL;
     ppf^.AParent := SELF;
     Result := ppf;

     AddObject(Name,TObject(ppf));
END;


FUNCTION TProjectFiles.InsertFile(idx:LONGINT;Name:STRING;Expanded:BOOLEAN):PProjectFile;
VAR  ppf:PProjectFile;
BEGIN
     New(ppf);
     ppf^.ExeExt := '';
     ppf^.CheckSum := 0;
     ppf^.Expanded := Expanded;
     ppf^.ASub := NIL;
     ppf^.AParent := SELF;
     Result := ppf;

     InsertObject(idx,Name,TObject(ppf));
END;


FUNCTION TProjectFiles.FindFile(Name:STRING):LONGINT;
VAR  i:LONGINT;
BEGIN
     UpcaseStr(Name);
     FOR i := 0 TO Count-1 DO
     BEGIN
          IF Upcased(Strings[i]) = Name THEN
          BEGIN
               Result := i;
               exit;
          END;
     END;
     Result := -1;
END;



FUNCTION AddProjectMain(AMain:STRING):BOOLEAN;
VAR  ppf:PProjectFile;
     d,n,e:STRING;
BEGIN
  Result := FALSE;
  IF Project.Files.FindFile(AMain) < 0 THEN  {noch nicht vorhanden}
    BEGIN
      ppf := Project.Files.AddFile(AMain, FALSE);
      IF ppf <> NIL
        THEN
          BEGIN
            IF ProjectFilesTree <> NIL THEN
              BEGIN
                FSplit(AMain,d,n,e);
                ProjectFilesTree.AddObject(0,n+e,ppf);
              END;
          END
        ELSE exit;

      IF Project.Settings.Primary = '' THEN
        IF Project.Files.Count = 1 THEN SetPrimaryFile(AMain);
    END;
  Result := TRUE;
END;


FUNCTION AddProjectUnit(AMain,AUnit:STRING):BOOLEAN;
VAR  ppf,ppf2:PProjectFile;
     mainidx,depidx,i:LONGINT;
     s,d,n,e:STRING;
     MainNode:TOutlineNode;
BEGIN
     Result := FALSE;
     mainidx := Project.Files.FindFile(AMain);
     IF mainidx < 0 THEN exit;    {MainFile existiert nicht}

     ppf := PProjectFile(Project.Files.Objects[mainidx]);
     IF ppf = NIL THEN exit;  {kann eigentlich nicht sein}

     IF ppf^.ASub = NIL THEN ppf^.ASub.Create;  {neue UnitListe}

     IF ppf^.ASub.FindFile(AUnit) < 0 THEN  {noch nicht vorhanden}
     BEGIN
          {fge immer vor den Dependencies ein}
          depidx := ppf^.ASub.FindFile(DependenciesString);

          IF depidx < 0 THEN ppf2 := ppf^.ASub.AddFile(AUnit, FALSE)
          ELSE ppf2 := ppf^.ASub.InsertFile(depidx, AUnit, FALSE);

          IF ppf2 = NIL THEN exit;

          IF ProjectFilesTree <> NIL THEN
          BEGIN
               FSplit(AUnit,d,n,e);
               mainidx := ProjectFilesTree.IndexOfObject(ppf);
               IF mainidx >= 0 THEN
               BEGIN {versuche alphabetisch einzuordnen, vor Dependencies}
                    MainNode := ProjectFilesTree.Items[mainidx];
                    IF MainNode.HasItems THEN
                    BEGIN
                       FOR i := MainNode.GetFirstChild TO MainNode.GetLastChild DO
                       BEGIN
                            s := ProjectFilesTree.Items[i].Text;
                            IF (Upcased(s) > Upcased(n+e)) OR
                               (s = Dependencies) THEN
                            BEGIN
                                 ProjectFilesTree.InsertObject(i,n+e,ppf2);
                                 Result := TRUE;
                                 exit;
                            END;
                       END;
                    END;

                    ProjectFilesTree.AddChildObject(mainidx,n+e,ppf2);
               END;
          END;
     END;

     Result := TRUE;
END;


FUNCTION AddProjectDependency(AMain,AUnit:STRING):BOOLEAN;
VAR  ppf,depppf,ppf2:PProjectFile;
     idx,depidx:LONGINT;
     d,n,e:STRING;
BEGIN
     Result := FALSE;
     idx := Project.Files.FindFile(AMain);
     IF idx < 0 THEN exit;    {MainFile existiert nicht}

     ppf := PProjectFile(Project.Files.Objects[idx]);
     IF ppf = NIL THEN exit;  {kann eigentlich nicht sein}

     IF ppf^.ASub = NIL THEN ppf^.ASub.Create;  {neue UnitListe}

     {suche nach dem Dependencies Eintrag}
     depidx := ppf^.ASub.FindFile(DependenciesString);
     IF depidx < 0 THEN  {noch nicht vorhanden}
     BEGIN // neuer Eintrag am Ende der Modul Liste
          depppf := ppf^.ASub.AddFile(DependenciesString, FALSE);
          IF depppf <> NIL THEN
          BEGIN
               IF ProjectFilesTree <> NIL THEN
               BEGIN
                    FSplit(AUnit,d,n,e);
                    idx := ProjectFilesTree.IndexOfObject(ppf);
                    IF idx >= 0 THEN ProjectFilesTree.AddChildObject(idx,
                                     Dependencies,depppf);
               END;
          END
          ELSE exit;
     END
     ELSE depppf := PProjectFile(ppf^.ASub.Objects[depidx]);

     IF depppf = NIL THEN exit; //??? kann eigentlich nicht sein

     IF depppf^.ASub = NIL THEN depppf^.ASub.Create;  {neue UnitListe}

     {fge das Modul in die Dependencies Liste ein}
     IF depppf^.ASub.FindFile(AUnit) < 0 THEN  {noch nicht vorhanden}
     BEGIN
          ppf2 := depppf^.ASub.AddFile(AUnit, FALSE);
          IF ppf2 <> NIL THEN
          BEGIN
               IF ProjectFilesTree <> NIL THEN
               BEGIN
                    FSplit(AUnit,d,n,e);
                    idx := ProjectFilesTree.IndexOfObject(depppf);
                    IF idx >= 0
                    THEN ProjectFilesTree.AddChildObject(idx,n+e,ppf2);
               END;
          END
          ELSE exit;
     END;

     Result := TRUE;
END;


FUNCTION RemoveProjectMain(AMain:STRING):BOOLEAN;
VAR  ppf:PProjectFile;
     idx,i:LONGINT;
BEGIN
     Result := FALSE;
     idx := Project.Files.FindFile(AMain);
     IF idx < 0 THEN exit;

     ppf := PProjectFile(Project.Files.Objects[idx]);

     IF ProjectFilesTree <> NIL THEN
       IF ppf <> NIL THEN
       BEGIN
            i := ProjectFilesTree.IndexOfObject(ppf);
            IF i >= 0 THEN ProjectFilesTree.Delete(i);
       END;

     Project.Files.DestroyItem(ppf);
     Project.Files.Delete(idx);

     Result := TRUE;
END;


FUNCTION RemoveProjectUnit(AMain,AUnit:STRING):BOOLEAN;
VAR  ppf,ppf2:PProjectFile;
     idx,idx2,i:LONGINT;
BEGIN
     Result := FALSE;
     idx := Project.Files.FindFile(AMain);
     IF idx < 0 THEN exit;    {MainFile existiert nicht}

     ppf := PProjectFile(Project.Files.Objects[idx]);
     IF ppf = NIL THEN exit;  {kann eigentlich nicht sein}
     IF ppf^.ASub = NIL THEN exit;  {keine UnitList}

     idx2 := ppf^.ASub.FindFile(AUnit);
     IF idx2 < 0 THEN exit;   {SubFile existiert nicht}
     ppf2 := PProjectFile(ppf^.ASub.Objects[idx2]);

     IF ProjectFilesTree <> NIL THEN
       IF ppf2 <> NIL THEN
       BEGIN
            i := ProjectFilesTree.IndexOfObject(ppf2);
            IF i >= 0 THEN ProjectFilesTree.Delete(i);
       END;

     ppf^.ASub.DestroyItem(ppf2);
     ppf^.ASub.Delete(idx2);

     Result := TRUE;
END;


FUNCTION ExistProjectMain(AMain:STRING):BOOLEAN;
BEGIN
     Result := Project.Files.FindFile(AMain) >= 0;
END;


FUNCTION ExistProjectUnit(AMain,AUnit:STRING):BOOLEAN;
VAR  ppf:PProjectFile;
     idx:LONGINT;
BEGIN
     Result := FALSE;
     idx := Project.Files.FindFile(AMain);
     IF idx < 0 THEN exit;

     ppf := PProjectFile(Project.Files.Objects[idx]);
     IF ppf = NIL THEN exit;  {kann eigentlich nicht sein}
     IF ppf^.ASub = NIL THEN exit;  {keine UnitList}

     Result := ppf^.ASub.FindFile(AUnit) >= 0;
END;


FUNCTION DataProjectMain(AMain:STRING):PProjectFile;
VAR  idx:LONGINT;
BEGIN
     Result := NIL;
     idx := Project.Files.FindFile(AMain);
     IF idx < 0 THEN exit;

     Result := PProjectFile(Project.Files.Objects[idx]);
END;


FUNCTION DataProjectUnit(AMain,AUnit:STRING):PProjectFile;
VAR  ppf:PProjectFile;
     idx,idx2:LONGINT;
BEGIN
     Result := NIL;
     idx := Project.Files.FindFile(AMain);
     IF idx < 0 THEN exit;    {MainFile existiert nicht}

     ppf := PProjectFile(Project.Files.Objects[idx]);
     IF ppf = NIL THEN exit;  {kann eigentlich nicht sein}
     IF ppf^.ASub = NIL THEN exit;  {keine UnitList}

     idx2 := ppf^.ASub.FindFile(AUnit);
     IF idx2 < 0 THEN exit;   {SubFile existiert nicht}
     Result := PProjectFile(ppf^.ASub.Objects[idx2]);
END;


FUNCTION ClearProjectDependencies(AMain:STRING):BOOLEAN;
VAR  ppf,depppf:PProjectFile;
     idx,depidx:LONGINT;
BEGIN
     Result := FALSE;
     idx := Project.Files.FindFile(AMain);
     IF idx < 0 THEN exit;

     ppf := PProjectFile(Project.Files.Objects[idx]);
     IF ppf = NIL THEN exit;  {kann eigentlich nicht sein}

     IF ppf^.ASub = NIL THEN exit; //nothing to clear

     {suche nach dem Dependencies Eintrag}
     depidx := ppf^.ASub.FindFile(DependenciesString);
     IF depidx < 0 THEN exit;  //nothing to clear

     depppf := PProjectFile(ppf^.ASub.Objects[depidx]);

     {l”sche die Module raus}
     IF depppf <> NIL THEN
       IF depppf^.ASub <> NIL THEN
       BEGIN
            IF ProjectFilesTree <> NIL THEN
            BEGIN
                 idx := ProjectFilesTree.IndexOfObject(depppf);
                 IF idx >= 0 THEN ProjectFilesTree.Items[idx].Clear;
            END;

            depppf^.ASub.Clear;
       END;

     Result := TRUE;
END;


PROCEDURE RenameProjectFiles(oldname,newname:STRING);
VAR d,n,e:STRING;

  PROCEDURE locRenameFiles(Sub:TProjectFiles);
  VAR  ppf:PProjectFile;
       i,idx:LONGINT;
  BEGIN
       IF Sub = NIL THEN exit;

       FOR i := 0 TO Sub.Count-1 DO
       BEGIN
            ppf := PProjectFile(Sub.Objects[i]);
            IF Upcased(Sub.Strings[i]) = oldname THEN
            BEGIN
                 Sub.Strings[i] := newname;
                 Project.Modified := TRUE;
                 Project.NeedRecompile := TRUE;

                 IF ProjectFilesTree <> NIL THEN
                 BEGIN
                      idx := ProjectFilesTree.IndexOfObject(ppf);
                      IF idx >= 0
                      THEN ProjectFilesTree.Items[idx].Text := n+e;
                 END;
            END;
            IF ppf <> NIL THEN locRenameFiles(ppf^.ASub);
       END;
  END;

BEGIN
     FSplit(newname,d,n,e);
     UpcaseStr(oldname);
     locRenameFiles(Project.Files);
END;


PROCEDURE SetPrimaryFile(CONST s:STRING);
BEGIN
     Project.Settings.Primary := s;

     // als MainFile zum Projekt hinzufgen
     IF s <> '' THEN AddProjectMain(s);
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TProjectForms Class implementation                          บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TProjectForms.FreeItem(Item:POINTER);
VAR  FormItem:PFormListItem;
BEGIN
     FormItem := PFormListItem(Item);
     IF FormItem^.Form <> NIL THEN FormItem^.Form.Destroy; {call not Close}

     IF FormItem^.SCUPointer <> NIL THEN
       IF FormItem^.SCUSize > 0
       THEN FreeMem(FormItem^.SCUPointer, FormItem^.SCUSize);

     Dispose(FormItem);

     Inherited FreeItem(Item);
END;


FUNCTION AddProjectForm(CONST FormName,UnitName:STRING;Form:TForm):PFormListItem;
BEGIN
     New(Result);
     Result^.Form := Form;
     Result^.FormName := FormName;
     Result^.UnitName := UnitName;
     Result^.AutoCreate := (dsAutoCreate IN Form.DesignerState);
     Result^.SCUPointer := NIL;
     Result^.SCUSize := 0;

     Project.Forms.Add(Result);

     IF ProjectFormsList <> NIL
     THEN ProjectFormsList.Items.AddObject(FormName,TObject(Result));

     IF not Project.Loading THEN
     BEGIN
          Project.Modified := TRUE;
          Project.NeedRecompile := TRUE;
          Project.SCUModified := TRUE;
     END;
END;


FUNCTION RemoveProjectForm(CONST FormName:STRING):BOOLEAN;
VAR  FormItem:PFormListItem;
     FName:STRING;
     i:LONGINT;
BEGIN
     Result := TRUE;
     FName := Upcased(FormName);
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          //FormItem := POINTER(ProjectFormsList.Items.Objects[i]); war NIL
          FormItem := Project.Forms.Items[i];
          IF FormItem = NIL THEN continue;
          IF Upcased(FormItem^.FormName) = FName THEN
          BEGIN
               IF ProjectFormsList <> NIL THEN
               BEGIN
                    ProjectFormsList.Items.Delete(i);
                    ProjectFormsList.Invalidate; {wegen Redraw Probleme}
               END;

               Project.Forms.Delete(i); {Destroy and FreeItem}

               Project.Modified := TRUE;
               Project.NeedRecompile := TRUE;
               Project.SCUModified := TRUE;
               exit;
          END;
     END;
     Result := FALSE;
END;


FUNCTION RenameProjectForm(CONST OldFormName,NewFormName:STRING):BOOLEAN;
VAR  FormItem:PFormListItem;
     OldName:STRING;
     i:LONGINT;
BEGIN
     Result := FALSE;
     OldName := Upcased(OldFormName);
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF Upcased(FormItem^.FormName) = OldName THEN
          BEGIN
               IF ProjectFormsList <> NIL THEN
               BEGIN
                    ProjectFormsList.Items.Strings[i] := NewFormName;
               END;

               FormItem^.FormName := NewFormName;
               Result := TRUE;

               Project.Modified := TRUE;
               Project.NeedRecompile := TRUE;
               Project.SCUModified := TRUE;
               break;
          END;
     END;
END;


FUNCTION CloseForm(Form:TComponent):BOOLEAN;
VAR  FormItem:PFormListItem;
     TempList:TList;
     TMS:TMemoryStream;
     OldSCU:POINTER;
     i:LONGINT;
BEGIN
     Result := TRUE;
     OldSCU := SCUPointer;
     SCUPointer := NIL;
     TempList.Create;

     {Clear Pointer to TForm}
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF FormItem^.Form = Form THEN
          BEGIN
               TempList.Add(FormItem);
               TRY
                  TMS := WritePropertiesToStream(TempList);
               EXCEPT
                  TMS := NIL;
               END;
               IF TMS <> NIL THEN
               BEGIN
                    FormItem^.SCUSize := TMS.Size;
                    GetMem(FormItem^.SCUPointer, FormItem^.SCUSize);
                    TMS.Position := 0;
                    TMS.Read(FormItem^.SCUPointer^, FormItem^.SCUSize);
                    TMS.Destroy;
               END
               ELSE
               BEGIN
                    IF MessageBox(LoadNLSStr(SiCouldNotCreateTempSCU)+#13+#10+
                                  FmtLoadNLSStr(SiDeleteFormFromPrjQuery,[Form.Name]),
                                  mtError,mbOkCancel) = mrCancel THEN
                    BEGIN
                         Result := FALSE;    {Dont close the window}
                         break;      {Dont set FormItem^.Form = NIL}
                    END;
                    {---------Delete Form-------------}
                    {Quelltext l”schen}
                    GenRemoveFormProc(TForm(FormItem^.Form));

                    FormItem^.Form := NIL;   {Dont destroy it with FreeItem}

                    IF RemoveProjectForm(FormItem^.FormName) THEN
                    BEGIN
                         Project.SCUModified := TRUE;
                    END;
                    break;
               END;
               FormItem^.Form := NIL;
               break;
          END;
     END;
     TempList.Destroy;
     SCUPointer := OldSCU;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TFileStringList Class implementation                        บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION TFileStringList.ReadFromSPR(FileName,Section,Ident:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  s:STRING;
  i:LONGINT;
BEGIN
  Clear;

  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    FOR i := 0 TO MaxInt DO
    BEGIN
      s := ini.ReadString(Section,Ident+tostr(i),'?');
      IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}
      Add(s);
    END;

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION TFileStringList.WriteToSPR(FileName,Section,Ident:STRING;cut:BOOLEAN):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  i:LONGINT;
  s:STRING;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    ini.EraseSection(Section);

    FOR i := 0 TO Count-1 DO
    BEGIN
      IF (MaxSave >= 0) AND (i >= MaxSave) THEN break;
      s := Strings[i];
      IF cut THEN s := CutProjectFile(s);
      ini.WriteString(Section,Ident+tostr(i),s);
    END;

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TGlobalMacroList Class implementation                       บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TGlobalMacroList.FreeItem(AObject:TObject);
VAR  List:TList;
BEGIN
     List := TList(AObject);
     IF List IS TList THEN List.Destroy;

     Inherited FreeItem(AObject);
END;


PROCEDURE TGlobalMacroList.Changing;
BEGIN
     ListChanged := TRUE;
     IdeSettings.Modified := TRUE;
END;


FUNCTION TGlobalMacroList.LoadEditorMacros:BOOLEAN;
VAR  F:FILE;
     fname,s:STRING;
     Signatur:STRING;
     CountMacros:LONGINT;
     CountCmd:LONGINT;
     Key:TKeyCode;
     i,j:LONGINT;
     MList:TList;
LABEL lend;
BEGIN
     Result := TRUE;
     fname := IdeSettings.MacroFileName;
     IF fname = '' THEN exit;

     Result := FALSE;
     SYSTEM.Assign(F,fname);
     {$i-}
     Reset(F,1);
     IF InOutRes <> 0 THEN goto lend;
     {Signatur testen}
     BlockRead(F,Signatur[1],FileSignaturSize);
     IF InOutRes <> 0 THEN goto lend;
     SetLength(Signatur,FileSignaturSize);
     IF Signatur <> EditorMacroSignatur THEN goto lend;
     {Anzahl der Macros}
     BlockRead(F,CountMacros,SizeOf(CountMacros));
     IF InOutRes <> 0 THEN goto lend;
     {Macros lesen}
     FOR i := 0 TO CountMacros-1 DO
     BEGIN
          {Name des Macros}
          BlockRead(F,s[0],1);
          IF InOutRes <> 0 THEN goto lend;
          BlockRead(F,s[1],ord(s[0]));
          IF InOutRes <> 0 THEN goto lend;
          MList.Create;
          {Anzahl der Kommandos}
          BlockRead(F,CountCmd,SizeOf(CountCmd));
          IF InOutRes <> 0 THEN goto lend;
          {Kommandos lesen}
          FOR j := 0 TO CountCmd-1 DO
          BEGIN
               BlockRead(F,Key,SizeOf(Key));
               IF InOutRes <> 0 THEN goto lend;
               MList.Add(POINTER(Key));
          END;
          AddObject(s,MList);
     END;

     Result := TRUE;
lend:
     Close(F);
     {$i+}
     ListChanged := FALSE;
END;


FUNCTION TGlobalMacroList.SaveEditorMacros:BOOLEAN;
VAR  F:FILE;
     fname,s:STRING;
     Signatur:STRING;
     CountMacros:LONGINT;
     CountCmd:LONGINT;
     Key:TKeyCode;
     i,j:LONGINT;
     MList:TList;
LABEL lend;
BEGIN
     Result := FALSE;
     IF not ListChanged THEN exit;

     IF IdeSettings.MacroFileName = '' THEN
     BEGIN
          IdeSettings.MacroFileName := GetBinDir + '\Sibyl.mcr';
     END;
     fname := IdeSettings.MacroFileName;

     SYSTEM.Assign(F,fname);
     {$i-}
     Rewrite(F,1);
     IF InOutRes <> 0 THEN goto lend;
     {Signatur schreiben}
     Signatur := EditorMacroSignatur;
     BlockWrite(F,Signatur[1],FileSignaturSize);
     IF InOutRes <> 0 THEN goto lend;
     {Anzahl der Macros}
     CountMacros := Count;
     BlockWrite(F,CountMacros,SizeOf(CountMacros));
     IF InOutRes <> 0 THEN goto lend;
     {Macros schreiben}
     FOR i := 0 TO CountMacros-1 DO
     BEGIN
          {Name des Macros}
          s := Strings[i];
          BlockWrite(F,s[0],Length(s)+1);
          IF InOutRes <> 0 THEN goto lend;
          {Anzahl der Kommandos}
          MList := TList(Objects[i]);
          IF MList = NIL THEN CountCmd := 0
          ELSE CountCmd := MList.Count;
          BlockWrite(F,CountCmd,SizeOf(CountCmd));
          IF InOutRes <> 0 THEN goto lend;
          {Kommandos schreiben}
          FOR j := 0 TO CountCmd-1 DO
          BEGIN
               Key := TKeyCode(MList.Items[j]);
               BlockWrite(F,Key,SizeOf(Key));
               IF InOutRes <> 0 THEN goto lend;
          END;
     END;

     Result := TRUE;
lend:
     Close(F);
     {$i+}
     ListChanged := FALSE;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TGlobalToolList Class implementation                        บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION IsFullWord(s1,s:STRING;p:BYTE):BOOLEAN;
BEGIN
     Result := FALSE;
     IF p + Length(s1) <= Length(s) THEN
       IF s[p+Length(s1)] IN NormalChars THEN exit;
     Result := TRUE;
END;


PROCEDURE TGlobalToolList.EvToolClick(Sender:TObject);
VAR  ptd:PToolData;
     s,exes:STRING;
     s1,dir,name,ext:STRING;
     CTop:TEditor;
     p,i:BYTE;
     yet:BOOLEAN;
BEGIN
     ptd := PToolData(TComponent(Sender).Tag);
     IF ptd = NIL THEN exit;

     exes := ptd^.FileName;            {EXE-Name}
     s := ptd^.Parameter;              {Kommando Line}
     WHILE (s[1] = ' ') AND (Length(s) > 0) DO System.delete(s,1,1);

     CTop := TEditor(CodeEditorRef.ActiveMDIChild);

     {Save Project}
     yet := FALSE;
     WHILE pos('$SAVEPRJ',s) > 0 DO
     BEGIN
          p := pos('$SAVEPRJ',s);
          IF IsFullWord('$SAVEPRJ',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               IF not yet THEN SaveProject(TRUE); {all}
               yet := TRUE;
          END
          ELSE s[p] := #0;
     END;

     {Save SCU}
     yet := FALSE;
     WHILE pos('$SAVESCU',s) > 0 DO
     BEGIN
          p := pos('$SAVESCU',s);
          IF IsFullWord('$SAVESCU',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               IF not yet THEN SaveSCU;
               yet := TRUE;
          END
          ELSE s[p] := #0;
     END;

     {Editor Files}
     yet := FALSE;
     WHILE pos('$SAVEALL',s) > 0 DO
     BEGIN
          p := pos('$SAVEALL',s);
          IF IsFullWord('$SAVEALL',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               IF not yet THEN SaveFiles(TRUE);  {only modified}
               yet := TRUE;
          END
          ELSE s[p] := #0;
     END;

     {Current Editor}
     WHILE pos('$SAVECUR',s) > 0 DO
     BEGIN
          p := pos('$SAVECUR',s);
          IF IsFullWord('$SAVECUR',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               IF not yet THEN
                 IF CTop <> NIL THEN
                   IF CTop.Modified THEN
                     IF not CTop.SaveFile THEN exit;
               yet := TRUE;
          END
          ELSE s[p] := #0;
     END;

     {Current Editor Name}
     WHILE pos('$EDNAME',s) > 0 DO
     BEGIN
          p := pos('$EDNAME',s);
          IF IsFullWord('$EDNAME',s,p) THEN
          BEGIN
               System.delete(s,p,7);
               IF CTop <> NIL THEN System.insert(CTop.FileName,s,p)
               ELSE System.insert(Project.Settings.Primary,s,p);
          END
          ELSE s[p] := #0;
     END;

     {Current Editor Line}
     WHILE pos('$LINE',s) > 0 DO
     BEGIN
          p := pos('$LINE',s);
          IF IsFullWord('$LINE',s,p) THEN
          BEGIN
               System.delete(s,p,5);
               IF CTop <> NIL THEN System.insert(tostr(CTop.CursorPos.Y),s,p);
          END
          ELSE s[p] := #0;
     END;

     {Current Editor Column}
     WHILE pos('$COL',s) > 0 DO
     BEGIN
          p := pos('$COL',s);
          IF IsFullWord('$COL',s,p) THEN
          BEGIN
               System.delete(s,p,4);
               IF CTop <> NIL THEN System.insert(tostr(CTop.CursorPos.X),s,p);
          END
          ELSE s[p] := #0;
     END;

     {Project Name}
     WHILE pos('$PRJNAME',s) > 0 DO
     BEGIN
          p := pos('$PRJNAME',s);
          IF IsFullWord('$PRJNAME',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               System.insert(Project.FileName,s,p);
          END
          ELSE s[p] := #0;
     END;

     {SCU Name}
     WHILE pos('$SCUNAME',s) > 0 DO
     BEGIN
          p := pos('$SCUNAME',s);
          IF IsFullWord('$SCUNAME',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               System.insert(GetSCUName,s,p);
          END
          ELSE s[p] := #0;
     END;

     {Executable Name}
     WHILE pos('$EXENAME',s) > 0 DO
     BEGIN
          p := pos('$EXENAME',s);
          IF IsFullWord('$EXENAME',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               System.insert(GetEXEName,s,p);
          END
          ELSE s[p] := #0;
     END;

     {INI-Name from the Executable}
     WHILE pos('$ININAME',s) > 0 DO
     BEGIN
          p := pos('$ININAME',s);
          IF IsFullWord('$ININAME',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               System.insert(ChangeFileExt(GetEXEName,EXT_UC_INI),s,p);
          END
          ELSE s[p] := #0;
     END;


     {Error FileName}
     WHILE pos('$ERRNAME',s) > 0 DO
     BEGIN
          p := pos('$ERRNAME',s);
          IF IsFullWord('$ERRNAME',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               IF ErrName <> '' THEN System.insert(ErrName,s,p);
          END
          ELSE s[p] := #0;
     END;

     {Error Line}
     WHILE pos('$ERRLINE',s) > 0 DO
     BEGIN
          p := pos('$ERRLINE',s);
          IF IsFullWord('$ERRLINE',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               IF ErrName <> '' THEN System.insert(tostr(ErrPos.Y),s,p);
          END
          ELSE s[p] := #0;
     END;

     {Error Column}
     WHILE pos('$ERRCOL',s) > 0 DO
     BEGIN
          p := pos('$ERRCOL',s);
          IF IsFullWord('$ERRCOL',s,p) THEN
          BEGIN
               System.delete(s,p,7);
               IF ErrName <> '' THEN System.insert(tostr(ErrPos.X),s,p);
          END
          ELSE s[p] := #0;
     END;

     {Error Text}
     WHILE pos('$ERRTEXT',s) > 0 DO
     BEGIN
          p := pos('$ERRTEXT',s);
          IF IsFullWord('$ERRTEXT',s,p) THEN
          BEGIN
               System.delete(s,p,8);
               IF ErrName <> '' THEN System.insert(ErrText,s,p);
          END
          ELSE s[p] := #0;
     END;

     {Drive of}
     WHILE pos('$DRIVE(',s) > 0 DO
     BEGIN
          p := pos('$DRIVE(',s);
          IF IsFullWord('$DRIVE',s,p) THEN
          BEGIN
               s1 := '';
               FOR i := p+7 TO Length(s) DO
               BEGIN
                    IF s[i] = ')' THEN break;
                    s1 := s1 + s[i];
               END;

               System.delete(s,p,i-p+1);
               s1 := FExpand(s1);
               System.insert(copy(s1,1,2),s,p);
          END
          ELSE s[p] := #0;
     END;

     {Directory of}
     WHILE pos('$DIR(',s) > 0 DO
     BEGIN
          p := pos('$DIR(',s);
          IF IsFullWord('$DIR',s,p) THEN
          BEGIN
               s1 := '';
               FOR i := p+5 TO Length(s) DO
               BEGIN
                    IF s[i] = ')' THEN break;
                    s1 := s1 + s[i];
               END;

               System.delete(s,p,i-p+1);
               s1 := FExpand(s1);
               FSplit(s1,dir,name,ext);
               System.delete(dir,1,2);
               System.insert(dir,s,p);
          END
          ELSE s[p] := #0;
     END;

     {Filename of}
     WHILE pos('$NAME(',s) > 0 DO
     BEGIN
          p := pos('$NAME(',s);
          IF IsFullWord('$NAME',s,p) THEN
          BEGIN
               s1 := '';
               FOR i := p+6 TO Length(s) DO
               BEGIN
                    IF s[i] = ')' THEN break;
                    s1 := s1 + s[i];
               END;

               System.delete(s,p,i-p+1);
               s1 := FExpand(s1);
               FSplit(s1,dir,name,ext);
               System.insert(name,s,p);
          END
          ELSE s[p] := #0;
     END;

     {Filename Extension of}
     WHILE pos('$EXT(',s) > 0 DO
     BEGIN
          p := pos('$EXT(',s);
          IF IsFullWord('$EXT',s,p) THEN
          BEGIN
               s1 := '';
               FOR i := p+5 TO Length(s) DO
               BEGIN
                    IF s[i] = ')' THEN break;
                    s1 := s1 + s[i];
               END;

               System.delete(s,p,i-p+1);
               s1 := FExpand(s1);
               FSplit(s1,dir,name,ext);
               System.insert(ext,s,p);
          END
          ELSE s[p] := #0;
     END;

     FOR i := 1 TO Length(s) DO
        IF s[i] = #0 THEN s[i] := '$';


     ExecViaSession := TRUE;
     AsynchExec := TRUE;
     UpcaseStr(exes);
     IF pos('.CMD',exes) <> 0 THEN
     BEGIN
          s := '/c '+ exes + ' ' + s;
          exes := GetEnv('COMSPEC');
          IF exes = '' THEN exes := 'CMD.EXE';
     END;
     Exec(exes,s);
     IF DosError IN [369,418,460,463]  {anderer <> 0 informiert ber Backgroundstart}
     THEN ErrorBox(LoadNLSStr(SError)+'[' + tostr(DosError) + ']: '+FmtLoadNLSStr(SiCannotRun,[exes]));
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TProject Class implementation                               บ
บ                                                                           บ
บ Last modified: January 1996                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{..........Loading..........................................................}

FUNCTION RelativeToProject(s:STRING):STRING;
VAR  i,MaxLen,BaseLen:LONGINT;
     s1,ProjectName,NewBase:STRING;
BEGIN
     Result := '';

     s1 := Upcased(s);
     ProjectName := Project.Settings.ProjectName;
     MaxLen := Length(ProjectName);
     IF Length(s) < MaxLen THEN MaxLen := Length(s);
     {suche gemeinsamen Basis Pfad von s und Project.Settings.ProjectName}
     BaseLen := 0; {Lnge des Basis Pfades}
     FOR i := 1 TO MaxLen DO
     BEGIN
          IF s1[i] <> ProjectName[i] THEN break;
          inc(BaseLen);
     END;

     {schneide am Ende so ab, daแ ganzer Pfad brig bleibt}
     MaxLen := BaseLen;
     FOR i := MaxLen DOWNTO 1 DO
     BEGIN
          IF s1[i] <> '\' THEN dec(BaseLen)
          ELSE break;
     END;

     {entferne die gemeinsame Basis von den StringNamen}
     delete(s,1,BaseLen);
     delete(ProjectName,1,BaseLen);

     {entferne den Rest von ProjectName vom Ende des aktuellen}
     { Project.FileName und erhalte somit den neuen Basis Pfad}
     NewBase := copy(Project.FileName,1,
                     Length(Project.FileName)-Length(ProjectName));

     Result := NewBase + s;
END;


FUNCTION ReadProjectFiles(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section:STRING;

  PROCEDURE locReadFiles(VAR aFiles:TProjectFiles; Ident:STRING);
  VAR
    s,e:STRING;
    ppf:PProjectFile;
    i,p,cs:LONGINT;
    exp:BOOLEAN;
  BEGIN
    FOR i := 0 TO MaxInt DO
    BEGIN
      s := ini.ReadString(Section,Ident+tostr(i),'?');
      IF s = '?' THEN break; {kein weiteres Objekt mehr vorhanden}

      ExpandProjectFile(s);

      e := ini.ReadString(Section,Ident+tostr(i)+'.Ext','');
      cs := ini.ReadInteger(Section,Ident+tostr(i)+'.Checksum',0);
      exp := ini.ReadBool(Section,Ident+tostr(i)+'.Expanded',FALSE);

      IF aFiles = NIL THEN aFiles.Create;

      ppf := aFiles.AddFile(s, exp);
      ppf^.CheckSum := cs;
      ppf^.ExeExt := e;

      IF s = DependenciesString THEN
      BEGIN
           {trenne nach dem MainFile Namen ab}
           s := Ident+tostr(i);
           p := pos('.',Ident);
           IF p > 0 THEN SetLength(s,p-1);
           locReadFiles(ppf^.ASub, s +'.Dependency');
      END
      ELSE locReadFiles(ppf^.ASub, Ident+tostr(i)+'.File');
    END;
  END;

BEGIN
  Result := FALSE;
  Application.LogWriteln('ReadProjectFiles: Start:' + FileName);
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Project Files';

    locReadFiles(Project.Files,'MainFile');

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
  Application.LogWriteln('ReadProjectFiles: Ende');
END;


TYPE
  TEditData=RECORD
      Left, Bottom, Width, Height, Column, Line: LONGINT;
  END;


FUNCTION ReadLastOpenFiles(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  s,f:STRING;
  i:LONGINT;
  pEditData:^TEditData;
  Section:STRING;
BEGIN
  Project.LastOpenFiles.Clear;

  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Last Open Files';
    FOR i := 0 TO MaxInt DO
    BEGIN
      f := 'File' + tostr(i);
      s := ini.ReadString(Section,f,'?');
      IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}

      ExpandProjectFile(s);
      IF not FileExists(s) THEN continue;

      New(pEditData);
      pEditData^.Left := ini.ReadInteger(Section,f+'.Left',0);
      pEditData^.Bottom := ini.ReadInteger(Section,f+'.Bottom',0);
      pEditData^.Width := ini.ReadInteger(Section,f+'.Width',0);
      pEditData^.Height := ini.ReadInteger(Section,f+'.Height',0);
      pEditData^.Column := ini.ReadInteger(Section,f+'.Column',1);
      pEditData^.Line := ini.ReadInteger(Section,f+'.Line',1);

      Project.LastOpenFiles.AddObject(s,TObject(pEditData));
    END;

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION ReadBookmarks(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  s,s1,f:STRING;
  i,j:LONGINT;
  c:INTEGER;
  Section:STRING;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Bookmarks';
    FOR i := 0 TO MaxInt DO
    BEGIN
      f := 'Bookmark' + tostr(i);
      s := ini.ReadString(Section,f,'?');
      IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}

      s1 := GetShortHint(s);
      ExpandProjectFile(s1);
      IF not FileExists(s1) THEN continue;

      val(GetLongHint(s),j,c);
      IF c <> 0 THEN continue;

      s := ini.ReadString(Section,f+'.Name','');
      s := s + '|' + s1;

      Project.BookmarkList.AddObject(s,TObject(j));
    END;

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION ReadBreakpoints(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  s,s1,f:STRING;
  i,line:LONGINT;
  c:INTEGER;
  Section:STRING;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Breakpoints';
    FOR i := 0 TO MaxInt DO
    BEGIN
      f := 'Breakpoint' + tostr(i);
      s := ini.ReadString(Section,f,'?');
      IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}

      s1 := GetShortHint(s);
      ExpandProjectFile(s1);
      IF not FileExists(s1) THEN continue;

      val(GetLongHint(s),line,c);
      IF c <> 0 THEN continue; {delete breakpoint}

      {$IFDEF OS2}
      BreakpointList.AddBreakPoint(s1,line);
      {$ENDIF}
    END;

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION ReadWatchWindows(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  s,f:STRING;
  i:LONGINT;
  Section:STRING;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Watch';
    FOR i := 0 TO MaxInt DO
    BEGIN
      f := 'Watch' + tostr(i);
      s := ini.ReadString(Section,f,'?');
      IF s = '?' THEN break; {keine weiteren Eintrge mehr vorhanden}

      {$IFDEF OS2}
      AddTheWatch(s);
      {$ENDIF}
    END;

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION ReadLastClosedFiles(FileName:STRING):BOOLEAN;  {FileMen}
VAR  i:LONGINT;
     s:STRING;
BEGIN
     Result := FALSE;

     Project.FilesHistory.ReadFromSPR(FileName,'Last Closed Files','File');

     {Patch fremdes Projekt}
     FOR i := Project.FilesHistory.Count-1 DOWNTO 0 DO
     BEGIN
          IF i >= MaxHistoryFiles THEN
          BEGIN
               Project.FilesHistory.Delete(i);  {Maximalanzahl}
               continue;
          END;
          s := Project.FilesHistory.Strings[i];
          ExpandProjectFile(s);

          IF not FileExists(s) THEN
          BEGIN
               Project.FilesHistory.Delete(i);
               continue;
          END;

          Project.FilesHistory.Strings[i] := s;
     END;
     Result := TRUE;
END;


FUNCTION ReadReadOnlyFiles(FileName:STRING):BOOLEAN;
VAR  i:LONGINT;
     s:STRING;
BEGIN
     Result := FALSE;

     Project.ReadOnlyFiles.ReadFromSPR(FileName,'Read Only Files','File');

     {Patch fremdes Projekt}
     FOR i := Project.ReadOnlyFiles.Count-1 DOWNTO 0 DO
     BEGIN
          s := Project.ReadOnlyFiles.Strings[i];

          ExpandProjectFile(s);
          IF not FileExists(s) THEN Project.ReadOnlyFiles.Delete(i);
     END;
     Result := TRUE;
END;


FUNCTION ReadBrowserFiles(FileName:STRING):BOOLEAN;
BEGIN
     Result := FALSE;

     Project.BrowserFiles.ReadFromSPR(FileName,'Browser Files','File');

     Result := TRUE;
END;

// Don't confuse this global function ReadSCU
// with TComponent.ReadSCU...
FUNCTION ReadSCU:BOOLEAN;
VAR  dummy:PSCUFileFormat;
     Count:LONGINT;
     Form:TForm;
     s,s1,d,n,e:STRING;
     prjdir:STRING;
BEGIN
     Result := FALSE;
     dummy := SCUPointer;
     IF pos('SC',dummy^.Version) <> 1 THEN exit;

     FSplit(Project.FileName,prjdir,n,e);
   // // // LogStr( 'ReadSCU' );

     Count := 0;
     WHILE Count <> dummy^.ObjectCount DO
     BEGIN
          dummy^.UseEntry := Count;
        // creating a form with the SCUPointer not nil,
        // causes the form data to be read from the SCU data!
          Form := FormEditClass.Create(NIL);
          Form.TypeName := 'T'+ Form.Name;
        // // LogStr( 'ReadSCU: Form.Name: '+Form.Name );
        SetMainStatusText( LoadNLSStr(SiLoadingForm)+Form.Name, clBlack, clLtGray );
          IF Form.UnitName = '' THEN
          BEGIN
               Form.Destroy;
               exit;
          END;
          s := Form.UnitName;
        // // LogStr( 'ReadSCU: UnitName: '+ s);

          s1 := RelativeToProject(FExpand(s));
          IF FileExists(s1) AND (Upcased(s) <> Upcased(s1)) THEN
          BEGIN
               s := s1;
               Project.Modified := TRUE;
               Project.NeedRecompile := TRUE;
          END;

          IF not FileExists(s) THEN
          BEGIN
               {try to locate in project dir}
               FSplit(s,d,n,e);
               s1 := prjdir + n + e;
               IF FileExists(s1) THEN
               BEGIN
                    s := s1;
                    Project.Modified := TRUE;
                    Project.NeedRecompile := TRUE;
               END;
          END;

          AddProjectForm(Form.Name,s,Form);

          IF Form.DesignerState * [dsFormVisible] <> [] THEN
          BEGIN
               Form.Show;
               Form.Focus;
          END
          ELSE
          BEGIN
               IF Not CloseForm(Form) THEN
               BEGIN
                    // Form kann nicht geschlossen werden (SCU Write Error)
                    // und soll nicht vom Projekt gel”scht werden
                    Form.Show;
                    Form.Focus;
               END
               ELSE Form.Destroy
          END;
          inc(Count);
     END;

     Result := TRUE;
END;

{..........Saving...........................................................}

FUNCTION WriteProjectFiles(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section:STRING;

  PROCEDURE WriteSubFiles(aFiles:TProjectFiles; CONST Ident:STRING);
  VAR
    i,p:LONGINT;
    ppf:PProjectFile;
    s:STRING;
  BEGIN
    IF aFiles = NIL THEN exit;

    FOR i := 0 TO aFiles.Count-1 DO
    BEGIN
      ppf := PProjectFile(aFiles.Objects[i]);
      s := aFiles.Strings[i];

      ini.WriteString(Section,Ident+tostr(i), CutProjectFile(s));
      IF ppf <> NIL THEN
      BEGIN
        IF Ident = 'MainFile' THEN
        BEGIN
          ini.WriteString(Section,Ident+tostr(i)+'.Ext',ppf^.ExeExt);
          ini.WriteInteger(Section,Ident+tostr(i)+'.Checksum',ppf^.CheckSum);
          ini.WriteBool(Section,Ident+tostr(i)+'.Expanded',ppf^.Expanded);
        END;

        IF s = DependenciesString THEN
        BEGIN
             {trenne nach dem MainFile Namen ab}
             s := Ident+tostr(i);
             p := pos('.',Ident);
             IF p > 0 THEN SetLength(s,p-1);
             WriteSubFiles(ppf^.ASub, s +'.Dependency');
        END
        ELSE WriteSubFiles(ppf^.ASub, Ident+tostr(i)+'.File');
      END;
    END;
  END;

BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Project Files';     {Section clear from SetPrimary}

    WriteSubFiles(Project.Files,'MainFile');

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION WriteLastOpenFiles(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  f:STRING;
  i:LONGINT;
  Section:STRING;
  Edit:TEditor;
  fcx:TEditorPos;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Last Open Files';
    ini.EraseSection(Section);

    FOR i := 0 TO CodeEditorRef.MDIChildCount-1 DO
    BEGIN
      f := 'File' + tostr(i);
      Edit := TEditor(CodeEditorRef.MDIChildren[i]);
      ini.WriteString(Section,f, CutProjectFile(Edit.FileName));
      ini.WriteInteger(Section,f+'.Left',Edit.Left);
      ini.WriteInteger(Section,f+'.Bottom',Edit.Bottom);
      ini.WriteInteger(Section,f+'.Width',Edit.Width);
      ini.WriteInteger(Section,f+'.Height',Edit.Height);
      fcx := Edit.CursorPos;
      ini.WriteInteger(Section,f+'.Column',fcx.X);
      ini.WriteInteger(Section,f+'.Line',fcx.Y);
    END;

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION WriteBookmarks(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  f,s,s1:STRING;
  i,j:LONGINT;
  Section:STRING;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Bookmarks';
    ini.EraseSection(Section);

    FOR i := 0 TO Project.BookmarkList.Count-1 DO
    BEGIN
      f := 'Bookmark' + tostr(i);
      s := Project.BookmarkList.Strings[i];
      j := LONGINT(Project.BookmarkList.Objects[i]);
      s1 := GetLongHint(s);
      s1 := CutProjectFile(s1) + '|' + tostr(j);
      ini.WriteString(Section,f,s1);
      s1 := GetShortHint(s);
      ini.WriteString(Section,f+'.Name',s1);
    END;

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION WriteBreakPoints(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  f,s:STRING;
  i:LONGINT;
  Section:STRING;
BEGIN
  {$IFDEF OS2}
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    Section := 'Breakpoints';
    ini.EraseSection(Section);

    FOR i := 0 TO BreakPointList.Count-1 DO
    BEGIN
      f := 'Breakpoint' + tostr(i);
      IF BreakPointList.FileNames[i] = '' THEN continue;
      s := CutProjectFile(BreakPointList.FileNames[i]) + '|' +
           tostr(BreakPointList.Lines[i]);
      ini.WriteString(Section,f,s);
    END;

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
  {$ENDIF}
END;


FUNCTION WriteWatchWindows(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section:STRING;
  i:LONGINT;
  o:STRING;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    {Section Watch}
    Section := 'Watch';
    ini.EraseSection(Section);

    {Watch/Inspect Windows}
    {$IFDEF OS2}
    IF WatchGrid <> NIL THEN
    BEGIN
      FOR i := 0 TO WatchGrid.WatchList.Count-1 DO
      BEGIN
        o := 'Watch'+ tostr(i);
        ini.WriteString(Section,o,WatchGrid.WatchList.Strings[i]);
      END;
    END;
    {$ENDIF}

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;



FUNCTION JoinStreams(TMSList:TList):TMemoryStream;
VAR FormItem:PFormListItem;
    FileDesc:PSCUFileFormat;
    Desc:TSCUFileFormat;
    t:LONGINT;
LABEL err;
BEGIN
     Result.Create;
     FOR t:=0 TO TMSList.Count-1 DO
     BEGIN
          FormItem:=Pointer(TMSList[t]);
          FileDesc:=Pointer(FormItem^.SCUPointer);
          Desc:=FileDesc^;
          inc(FileDesc,sizeof(TSCUFileFormat));
          IF t=TMSList.Count-1 THEN Desc.NextEntry:=NIL  //Mark last entry
          ELSE LongWord(Desc.NextEntry):=$FFFFFFFF;      //Mark that another entry is following
          Desc.UseEntry:=0;
          IF Result.Write(Desc,SizeOf(TSCUFileFormat))=0 THEN
          BEGIN
err:
               Result.Destroy;
               Result:=NIL;
               exit;
          END;
          IF Result.Write(FileDesc^,FormItem^.SCUSize-SizeOf(TSCUFileFormat))=0 THEN goto err;
     END;
END;


FUNCTION GetProjectSCUStream(VAR Memory:TMemoryStream):BOOLEAN;
VAR  FormItem:PFormListItem;
     LastFormItem:PFormListItem;
     TempList:TList;
     TMSList:TList;
     TMS:TMemoryStream;
     OldSCU:POINTER;
     i:LONGINT;

LABEL ReleaseTMS;
BEGIN
     Result := TRUE;

     IF Project.LastSCUStream <> NIL THEN  {SCU ist nicht modifiziert worden}
     BEGIN
          Memory := Project.LastSCUStream;
          exit;
     END;

     Project.SCUSaving := TRUE;

     OldSCU := SCUPointer;
     SCUPointer := NIL;
     TempList.Create; {enthlt 1 sichtbare Form, die ge"stream"ed werden soll}
     TMSList.Create;  {Liste der einzelnen MemoryStreams}

     LastFormItem := NIL;
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF FormItem^.Form <> NIL THEN
          BEGIN
               TempList.Add(FormItem);
               LastFormItem := FormItem;
               // in LastFormItem wird dann der komplette SCU Block der
               // sichtbaren Forms reingeschrieben
          END
          ELSE TMSList.Add(FormItem); {enthlt immer einen SCU Block}
     END;

     IF TempList.Count > 0 THEN // LastFormItem ist gltig
     BEGIN
          TRY
             TMS := WritePropertiesToStream(TempList);
          EXCEPT
             TMS := NIL;
          END;

          IF TMS <> NIL THEN
          BEGIN
               LastFormItem^.SCUSize := TMS.Size;
               GetMem(LastFormItem^.SCUPointer, LastFormItem^.SCUSize);
               TMS.Position := 0;
               TMS.Read(LastFormItem^.SCUPointer^, LastFormItem^.SCUSize);
               TMS.Destroy;
          END
          ELSE
          BEGIN
               ErrorBox(FmtLoadNLSStr(SiCouldNotCreateSCUForForm,[FormItem^.FormName]));
               Result := FALSE;
               goto ReleaseTMS; {gib die erzeugten TMSs wieder frei}
          END;

          TMSList.Add(LastFormItem);
     END;

     {verknpfe alle TeilStreams der TMSList zu einem ganzen Stream}
     TRY
        Memory := JoinStreams(TMSList);
     EXCEPT
        Memory := NIL;
     END;

ReleaseTMS:
     {l”sche die temporren Streams}
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF (FormItem^.Form <> NIL) AND (FormItem^.SCUPointer <> NIL) THEN
          BEGIN
               FreeMem(FormItem^.SCUPointer, FormItem^.SCUSize);
               FormItem^.SCUPointer := NIL;
               FormItem^.SCUSize := 0;
          END;
     END;

     TempList.Destroy;
     TMSList.Destroy;
     SCUPointer := OldSCU;

     IF Project.LastSCUStream <> NIL THEN Project.LastSCUStream.Destroy;
     Project.LastSCUStream := Memory;

     Project.SCUSaving := FALSE;
END;


FUNCTION SaveSCU:BOOLEAN;
VAR  scu:STRING;
     resp:TMsgDlgReturn;
     MFName:STRING;
     SCUMemory:TMemoryStream;

{ Speichert die SCU-Informationen in die Datei
  Dies geschiet durch dem SCUMemory-Stream }

BEGIN
     Result := TRUE;
     IF Project.Settings.ProjectType = pt_NonVisual THEN exit;

     scu := GetSCUName;
     Project.Settings.SCUName := scu; {write back, because maybe it was empty}

     {testen ob file existiert, wenn die Project & SCU untitled sind}
     IF Project.Untitled THEN
       IF FileExists(scu) THEN
     BEGIN
          resp := MessageBox(FmtLoadNLSStr(SiFileAlreadyExistsOverwrite,[scu]),
                             mtWarning,mbYesNoCancel);
          CASE resp OF
              mrNo:
              BEGIN
                   Result := TRUE;
                   exit;
              END;
              mrCancel:
              BEGIN
                   Result := FALSE;
                   exit;
              END;
          END;
     END;

     IF not Project.SCUModified THEN
       IF FileExists(scu) THEN exit; {keine nderung -> nicht speichern}

     SetMainStatusText(LoadNLSStr(SiSavingSCUInfo),clBlack,clLtGray);
     MFName := Upcased(Project.Settings.MainForm);


     IF GetProjectSCUStream(SCUMemory) THEN
     BEGIN
          IF SCUMemory <> NIL THEN
          BEGIN
               SCUMemory.Position := 0;
               TRY
                  {kann bei falschem scu Namen schief gehen}
                  SCUMemory.SaveToFile(scu);
               EXCEPT
                  ErrorBox(FmtLoadNLSStr(SiCouldNotCreateSCUFile,[scu]));
                  Result := FALSE;
               END;
               {SCUMemory nicht zerst”ren, da im er Projekt gespeichert wird}
          END;
     END
     ELSE Result := FALSE;

     SetMainStatusText('',clBlack,clLtGray);

     Project.SCUModified := not Result;
END;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

FUNCTION TProject.GetName:STRING;
VAR  dir,ext:STRING;
BEGIN
     FSplit(FileName,dir,Result,ext);
END;


PROCEDURE TProject.SetModified(Value:BOOLEAN);
BEGIN
     FModified := Value;
     IF Value THEN
     BEGIN
          Value := Value; {test}
     END;
END;


PROCEDURE TProject.SetSCUModified(Value:BOOLEAN);
BEGIN
     FSCUModified := Value;
     IF Value THEN
     BEGIN
          IF LastSCUStream <> NIL THEN LastSCUStream.Destroy;
          LastSCUStream := NIL;
     END;
END;


PROCEDURE TProject.EvDocking(Sender:TObject;VAR TargetForm:TForm;VAR NewAlign:TToolbarAlign);
BEGIN
     IF TargetForm IS TBaseEditor THEN TargetForm := CodeEditorRef;
END;


PROCEDURE TProject.EvPaletteClick(Sender:TObject);
VAR  MenuItem:TMenuItem;
     Panel:TDockingPalette;
BEGIN
     MenuItem := TMenuItem(Sender);

     Panel := TDockingPalette(MenuItem.Tag);

     IF Panel = NIL THEN exit;

     IF Panel.DockingState = dsHide THEN
     BEGIN
          Panel.DockingState := dsFloat;
     END
     ELSE
     BEGIN
          Panel.DockingState := dsHide;
     END;
END;


PROCEDURE TProject.EvPaletteProperties(Sender:TObject);
BEGIN
     ToolbarsDialogProc;
END;


CONSTRUCTOR TProject.Create;
BEGIN
     Inherited Create;

     Files.Create;
     Forms.Create;
     FindHistory.Create;
     FindHistory.CaseSensitive := TRUE;
     FindHistory.MaxSave := 16;
     Find2History.Create;
     Find2History.CaseSensitive := TRUE;
     Find2History.MaxSave := 16;
     ReplHistory.Create;
     ReplHistory.CaseSensitive := TRUE;
     ReplHistory.MaxSave := 16;
     FilesHistory.Create;
     FilesHistory.MaxSave := MaxHistoryFiles;
     ReadOnlyFiles.Create;
     ReadOnlyFiles.MaxSave := -1;
     BrowserFiles.Create;
     BrowserFiles.MaxSave := -1;
     BookmarkList.Create;
     CmdLineFiles.Create;
     LastOpenFiles.Create;
END;


DESTRUCTOR TProject.Destroy;
BEGIN
     Forms.Clear;
     Files.Clear;
     FindHistory.Clear;
     Find2History.Clear;
     ReplHistory.Clear;
     FilesHistory.Clear;
     ReadOnlyFiles.Clear;
     BrowserFiles.Clear;
     BookmarkList.Clear;

     Files.Destroy;
     Forms.Destroy;
     FindHistory.Destroy;
     Find2History.Destroy;
     ReplHistory.Destroy;
     FilesHistory.Destroy;
     ReadOnlyFiles.Destroy;
     ReadOnlyFiles.Destroy;
     BookmarkList.Destroy;
     CmdLineFiles.Destroy;
     LastOpenFiles.Destroy;

     Inherited Destroy;
END;


FUNCTION TProject.Close:BOOLEAN;
VAR  Child:TEditor;
     t:LONGINT;
     dwi:TDesktopWinId;
     Win:TForm;
     Panel:TDockingPalette;
BEGIN
     Result := FALSE;
     SetInspectorDataProc(NIL);

     {Paletten disablen}
     FOR t := 0 TO Paletten.Count-1 DO
     BEGIN
          Panel := TDockingPalette(Paletten.Objects[t]);
          Panel.Enabled := FALSE;
     END;

     ClearBuildListProc;
     ClearFindInFilesListProc;
     IF SearchThread <> NIL THEN SearchThread.Terminate;
     {$IFDEF OS2}
     ClearDebugListProc;

     IF WatchGrid <> NIL THEN
     BEGIN
          WatchGrid.WatchList.Clear;
          WatchGrid.RowCount := 2;
          WatchGrid.Invalidate;
     END;
     {$ENDIF}

     {Sibyl Forms zerst”ren bzw. verbergen}
     FOR dwi := dwi_Inspector TO dwi_LastForm DO
     BEGIN
          Win := IdeSettings.DesktopWindows[dwi].Form;
          IF Win <> NIL THEN Win.Destroy;
          IdeSettings.DesktopWindows[dwi].Form := NIL;
     END;
     LastDesignForm := NIL;

     {MDIs zerst”ren}
     FOR t := CodeEditorRef.MDIChildCount-1 DOWNTO 0 DO
     BEGIN
          Child := TEditor(CodeEditorRef.MDIChildren[t]);
          IF Child IS TEditor THEN Child.Modified := FALSE; {CanClose TRUE}
     END;
     CodeEditorRef.CloseAll;

     {Debugger Windows}
     {$IFDEF OS2}
     FOR t := InspectWindows.Count-1 DOWNTO 0 DO
     BEGIN
          Win := TInspectWindow(InspectWindows.Items[t]);
          IF Win <> NIL THEN Win.Destroy;
     END;
     {$ENDIF}

     Forms.Clear;
     LastDesignForm := NIL; {?}
     Files.Clear;
     IF LastSCUStream <> NIL THEN LastSCUStream.Destroy;
     LastSCUStream := NIL;
     FindHistory.Clear;
     Find2History.Clear;
     ReplHistory.Clear;
     ClearMenuItems(cmFileMenu,MaxFileMenu);
     FilesHistory.Clear;
     ReadOnlyFiles.Clear;
     ReadOnlyFiles.Clear;
     BookmarkList.Clear;
     ClearAllBreakPoints;
     {$IFDEF OS2}
     SrcDirList.Clear;  {Liste mit Pfaden fr Debugger}
     {$ENDIF}
     ErrName := '';
     ProjectLoaded := FALSE;

     ASM
        CALLN32 Classes.DestroyMessages
     END;

     Screen.Update;
     Application.ProcessMessages;
     Result := TRUE;
END;


PROCEDURE TProject.Initialize;
BEGIN
     InitializeProject(Settings);

     {Standards updaten aus INI}
     Settings.CompOptOS2 := IdeSettings.CompOptOS2;
     Settings.WarnOptOS2 := IdeSettings.WarnOptOS2;
     Settings.LinkOptOS2 := IdeSettings.LinkOptOS2;
     Settings.MemSizesOS2 := IdeSettings.MemSizesOS2;
     Settings.DebugOptOS2 := IdeSettings.DebugOptOS2;
     Settings.DirectoriesOS2 := IdeSettings.DirectoriesOS2;

     Settings.CompOptWin := IdeSettings.CompOptWin;
     Settings.WarnOptWin := IdeSettings.WarnOptWin;
     Settings.LinkOptWin := IdeSettings.LinkOptWin;
     Settings.MemSizesWin := IdeSettings.MemSizesWin;
     Settings.DebugOptWin := IdeSettings.DebugOptWin;
     Settings.DirectoriesWin := IdeSettings.DirectoriesWin;

     {$IFDEF OS2}
     IF Settings.ProjectType = pt_Visual THEN
     BEGIN
          Settings.CompLibNameOS2 := GetBinDir + '\CompLib.dll';
     END;
     {$ENDIF}
     {$IFDEF WIN32}
     IF Settings.ProjectType = pt_Visual THEN
     BEGIN
          Settings.CompLibNameWin := GetBinDir + '\CompLib.dll';
     END;
     {$ENDIF}

     Modified := FALSE;
     Untitled := TRUE;
     SCUModified := FALSE;
     NeedRecompile := FALSE;
END;



FUNCTION TProject.Load(fn:STRING):BOOLEAN;
VAR  prjname:STRING;
BEGIN
  ProjectBaseDir := Upcased(ExtractFilePath(fn));
  RemoveMenuItem(fn, ProjectsHistory, cmLastProject1, cmLastProjectN,
                 cmProjectMenu, MaxProjectMenu, MaxHistoryProjects);

  IdeSettings.LastProject := fn;
  IdeSettings.Modified := TRUE;
  FileName := fn;

  SetMainStatusText(LoadNLSStr(SiLoadingPrj),clBlack,clLtGray);

  Initialize; {Settings}
  Result := FileExists(fn);
  IF Result THEN Result := ReadProject(Settings,fn);  {Initialwerte berschreiben}

  IF Result THEN
    BEGIN
      Modified := FALSE;
      Untitled := FALSE;
      SCUModified := FALSE;
      NeedRecompile := FALSE;

      FindHistory.ReadFromSPR(fn,'Find History','Find');
      Find2History.ReadFromSPR(fn,'Replace History','Find');
      ReplHistory.ReadFromSPR(fn,'Replace History','Replace');
      ReadLastClosedFiles(fn);
      ReadReadOnlyFiles(fn);
      ReadBrowserFiles(fn);
      ReadLastOpenFiles(fn);
      ReadProjectFiles(fn);
      ReadBookmarks(fn);
      ReadBreakpoints(fn);
      ReadWatchWindows(fn);
      ReadRepository(fn);
    END;

  SetMainStatusText('',clBlack,clLtGray);

  IF Name <> ''
    THEN prjname := '  -  ['+ Name +']'
    ELSE prjname := '';
  SibylMainForm.Caption := 'WDSibyl' + prjname;
END;


FUNCTION TProject.LoadSCU(scu:STRING):BOOLEAN;
VAR  F:FILE;
     SCULen:LONGINT;
     TempSCUPointer:POINTER;
     dummy:PSCUFileFormat;
LABEL errSCU;
BEGIN
      // // LogStr( 'LoadSCU' );
  Result := TRUE;
  IF Project.Settings.ProjectType = pt_NonVisual THEN exit;
  SCUModified := FALSE;

  SetMainStatusText(LoadNLSStr(SiLoadingSCUInfo),clBlack,clLtGray);
  Assign(F,scu);
  {$i-}
  Reset(F);
  {$i+}

  IF InOutRes <> 0THEN
    BEGIN
      ErrorBox(FmtLoadNLSStr(SiCouldNotOpenSCUFile,[scu]));
      Result := FALSE;
      SetMainStatusText('',clBlack,clLtGray);
      exit;
    END;

  SCUPointer := NIL;
  TempSCUPointer:=NIL;
  {$i-}
  SCULen := FileSize(F);
  {$i+}
  IF InOutRes <> 0 THEN
    BEGIN
errSCU:
      {$i-}
      System.Close(F);
      {$i+}
      IF TempSCUPointer <> NIL THEN FreeMem(TempSCUPointer,SCULen);
      SCUPointer := NIL;
      ErrorBox(FmtLoadNLSStr(SiCouldNotReadSCUFile,[scu]));
      Result := FALSE;
      SetMainStatusText('',clBlack,clLtGray);
      exit;
    END;

  GetMem(TempSCUPointer,SCULen);

  if SCULen>0 then
    Begin
      {$i-}
      BlockRead(F,TempSCUPointer^,SCULen);
      {$i+}
      IF InOutRes <> 0 THEN goto errSCU;

// // LogStr( 'Call AddSCUData' );
     //Convert the format !!!
     //This will also set the SCUPointer variable accordingly
      ASM
        PUSH DWORD PTR TempSCUPointer
        CALLN32 SYSTEM.AddSCUData
      END;
// // LogStr( 'Back from AddSCUData' );
    End;

  {$i-}
  System.Close(F);
  {$i+}

  dummy:=SCUPointer;
  WHILE dummy<>NIL DO
    BEGIN
      SCUPointer:=dummy;
// // LogStr( 'Calling ReadSCU' );
      IF not ReadSCU THEN
        BEGIN
          ErrorBox(FmtLoadNLSStr(SiIllegalSCUFormat,[scu]));
          Result := FALSE;
          break;
        END;
      dummy:=dummy^.NextEntry;
    END;

  FreeMem(TempSCUPointer,SCULen);
  SCUPointer := NIL;
  SCUModified := FALSE;
  SetMainStatusText('',clBlack,clLtGray);
END;


FUNCTION ReadRepository(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section:STRING;
  pRPage:PRepositoryPage;
  pRObject:PRepositoryObject;
  s,p,o:STRING;
  i,j:LONGINT;
BEGIN
  Application.LogWriteln('ReadRepository: '+FileName);
  Repository.Clear;  {sicherheitshalber}

  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    {Section Repository}
    Section := 'Repository';

    FOR i := 0 TO MaxInt DO
    BEGIN
      {Page}
      p := 'Page' + tostr(i);
      s := ini.ReadString(Section,p,'?'); {Name der Page}
      IF s = '?' THEN break; {keine weitere Page mehr vorhanden}
      New(pRPage);
      AssignStr(pRPage^.Page,s);
      pRPage^.PageInstalled := ini.ReadBool(Section,p+'.Installed',TRUE);
      pRPage^.Objects.Create; {!!}
      Repository.Add(pRPage);

      FOR j := 0 TO MaxInt DO
      BEGIN
        {Object}
        o := p + '.Object' + tostr(j);
        s := ini.ReadString(Section,o,'?'); {Name des Objekts}
        IF s = '?' THEN break; {kein weiteres Objekt mehr vorhanden}
        New(pRObject);
        AssignStr(pRObject^.IDName,s);
        pRObject^.NewProject := ini.ReadBool(Section,o+'.NewProject',FALSE);
        pRObject^.NewForm := ini.ReadBool(Section,o+'.NewForm',FALSE);
        pRObject^.MainForm := ini.ReadBool(Section,o+'.MainForm',FALSE);
        pRObject^.InstalledInPage := ini.ReadBool(Section,o+'.InPage',TRUE);
        s := ini.ReadString(Section,o+'.Title','');
        AssignStr(pRObject^.Title,s);
        s := ini.ReadString(Section,o+'.Description','');
        pRObject^.Description:=StrAlloc(length(s)+1);
        pRObject^.Description^:=s;
        s := ini.ReadString(Section,o+'.Author','');
        AssignStr(pRObject^.Author,s);
        pRObject^.Instance := NIL;

        IF pRPage^.Objects = NIL THEN pRPage^.Objects.Create;  {TList}
        pRPage^.Objects.Add(pRObject);
      END;
    END;

    Result := TRUE;
    ini.Destroy;

    {erzeuge mindestens die allgemeine Page}
    IF Repository.Count = 0 THEN
    BEGIN
         New(pRPage);
         pRPage^.Page := NewStr(ObjectRepositoryString);
         pRPage^.PageInstalled := TRUE;
         pRPage^.Objects.Create;
         Repository.Add(pRPage);
    END;

  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


FUNCTION WriteRepository(FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section:STRING;
  pRPage:PRepositoryPage;
  pRObject:PRepositoryObject;
  p,o:STRING;
  i,j:LONGINT;
BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    {Section Repository}
    Section := 'Repository';
    ini.EraseSection(Section);

    FOR i := 0 TO Repository.Count-1 DO   {MIT [Object Repository]}
    BEGIN
      pRPage := Repository.Items[i];
      IF pRPage = NIL THEN continue;
      p := 'Page' + tostr(i);
      ini.WriteString(Section,p,pRPage^.Page^); {Name der Page}
      ini.WriteBool(Section,p+'.Installed',pRPage^.PageInstalled);
      IF pRPage^.Objects = NIL THEN continue;
      FOR j := 0 TO pRPage^.Objects.Count-1 DO
      BEGIN
        pRObject := pRPage^.Objects.Items[j];
        IF pRObject = NIL THEN continue;
        o := p + '.Object' + tostr(j);
        ini.WriteString(Section,o,pRObject^.IDName^); {Name des Objekts}
        ini.WriteBool(Section,o+'.NewProject',pRObject^.NewProject);
        ini.WriteBool(Section,o+'.NewForm',pRObject^.NewForm);
        ini.WriteBool(Section,o+'.MainForm',pRObject^.MainForm);
        ini.WriteBool(Section,o+'.InPage',pRObject^.InstalledInPage);
        ini.WriteString(Section,o+'.Title',pRObject^.Title^);
        ini.WriteString(Section,o+'.Description',pRObject^.Description^);
        ini.WriteString(Section,o+'.Author',pRObject^.Author^);
      END;
    END;

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;



FUNCTION TProject.Save(fn:STRING):BOOLEAN;
VAR Cancel:BOOLEAN;
    prjname:STRING;
    Directories:^TDirectories;
BEGIN
     ProjectBaseDir := Upcased(ExtractFilePath(fn));

     IdeSettings.LastProject := fn;
     FileName := fn;
     SetMainStatusText(LoadNLSStr(SiSavingPrj),clBlack,clLtGray);

     Case Settings.Platform OF
       pf_OS2:
       BEGIN
            Directories:=@Settings.DirectoriesOS2;
       END;
       pf_WIN32:
       BEGIN
            Directories:=@Settings.DirectoriesWin;
       END;
     END;

     {$i-}
     GetDir(0,Directories^.LastDir);
     {$i+}
     IF Length(Directories^.LastDir) > 3
     THEN NormalizeDir(Directories^.LastDir);

     Settings.ProjectName := fn;
     Result := WriteProject(Settings,fn);

     IF Result THEN
     BEGIN
          {write all the dynamic file lists}
          FindHistory.WriteToSPR(fn,'Find History','Find',FALSE);
          Find2History.WriteToSPR(fn,'Replace History','Find',FALSE);
          ReplHistory.WriteToSPR(fn,'Replace History','Replace',FALSE);
          FilesHistory.WriteToSPR(fn,'Last Closed Files','File',TRUE);
          ReadOnlyFiles.WriteToSPR(fn,'Read Only Files','File',TRUE);
          BrowserFiles.WriteToSPR(fn,'Browser Files','File',FALSE);
          WriteLastOpenFiles(fn);
          WriteProjectFiles(fn);
          WriteBookmarks(fn);
          WriteBreakPoints(fn);
          WriteWatchWindows(fn);
          WriteRepository(fn);
     END
     ELSE ErrorBox(FmtLoadNLSStr(SiCouldNotCreatePrjFile,[Name]));

     SetMainStatusText('',clBlack,clLtGray);

     Untitled := FALSE;
     Modified := FALSE;

     IF Name <> '' THEN prjname := '  -  ['+ Name +']'
     ELSE prjname := '';
     SibylMainForm.Caption := 'WDSibyl' + prjname;
     SetMainStatusText('',clBlack,clLtGray);

     ToolsNotifyProc(fnProjectSaved,fn,Cancel);
     //IF Cancel THEN exit; //canceled
END;


{***  Menu Routinen ********************************************************}

FUNCTION SaveFiles(OnlyModified:BOOLEAN):BOOLEAN;
VAR  Child:TEditor;
     Primary:TEditor;
     t:LONGINT;
BEGIN
     Result := TRUE;
     Primary := NIL;
     t := 0;
     WHILE t <= CodeEditorRef.MDIChildCount-1 DO
     BEGIN
          Child := TEditor(CodeEditorRef.MDIChildren[t]);
          IF Child IS TEditor THEN
          BEGIN
               IF Upcased(Child.FileName) <>
                  Upcased(ProjectPrimary(Project.Settings)) THEN
               BEGIN
                    IF Child.Modified OR not OnlyModified THEN
                      IF not Child.SaveFile THEN
                      BEGIN
                           Result := FALSE;
                           exit;
                      END;
               END
               ELSE Primary := Child;   {Primary als letztes bearbeiten}
          END;
          inc(t);
     END;

     IF Primary <> NIL THEN
       IF Primary.Modified OR not OnlyModified THEN
         IF not Primary.SaveFile THEN Result := FALSE;
END;


FUNCTION EditorFilesModified:BOOLEAN;
VAR  Child:TEditor;
     t:LONGINT;
BEGIN
     Result := FALSE;
     FOR t := CodeEditorRef.MDIChildCount-1 DOWNTO 0 DO
     BEGIN
          Child := TEditor(CodeEditorRef.MDIChildren[t]);
          IF Child IS TEditor THEN
            IF Child.Modified THEN
            BEGIN
                 Result := TRUE;
                 exit;
            END;
     END;
END;


FUNCTION EditorFilesUntitled:BOOLEAN;
VAR  Child:TEditor;
     t:LONGINT;
BEGIN
     Result := FALSE;
     FOR t := CodeEditorRef.MDIChildCount-1 DOWNTO 0 DO
     BEGIN
          Child := TEditor(CodeEditorRef.MDIChildren[t]);
          IF Child IS TEditor THEN
            IF Child.Untitled THEN
            BEGIN
                 Result := TRUE;
                 exit;
            END;
     END;
END;


FUNCTION CloseProject(ReloadCompLib:BOOLEAN):BOOLEAN;
VAR  s:STRING;
     mbr:TMsgDlgReturn;
     Cancel:BOOLEAN;
BEGIN
     Result := FALSE;
     LastCloseProjectAnswer := mrYes;

     IF Project.SCUModified OR Project.Modified OR
        EditorFilesModified OR EditorFilesUntitled THEN
     BEGIN
          s := LoadNLSStr(SiSaveCurrentPrj);
          mbr := MessageBox(s,mtConfirmation,mbYesNoCancel);
          LastCloseProjectAnswer := mbr;
          CASE mbr OF
             mrYes: IF not SaveProject(TRUE) THEN exit;
             mrNo: ;
             mrCancel: exit;
          END;
     END;

     ToolsNotifyProc(fnProjectClosing,Project.FileName,Cancel);
     IF Cancel THEN exit; //canceled

     Project.Closing := TRUE;

     Project.Close;
     IF ReloadCompLib THEN CloseCompLibProc;
     DestroyNavigatorPagesProc;

     IF (Project.FileName <> '') AND (not Project.Untitled)
     THEN AddMenuItem(Project.FileName, ProjectsHistory, cmLastProject1, cmLastProjectN,
                 cmProjectMenu, MaxProjectMenu, MaxHistoryProjects);

     Project.Closing := FALSE;

     Result := TRUE;
END;
        

FUNCTION SaveProject(all:BOOLEAN):BOOLEAN;
BEGIN
     Result := FALSE;

     IF Project.Untitled THEN
     BEGIN
          Result := SaveProjectAs(all);
          exit;
     END;

     IF all THEN IF not SaveFiles(TRUE) THEN exit;
     IF all THEN IF not SaveSCU THEN exit;
     IF not Project.Save(Project.FileName) THEN exit;
     IF all THEN IF not SaveINI(IdeSettings) THEN exit;

     Result := TRUE;
END;


FUNCTION SaveProjectAs(all:BOOLEAN):BOOLEAN;
VAR  s:STRING;
     ret:BOOLEAN;
{$IFDEF OS2}
     CFSD:TSaveDialog;
{$ENDIF}
{$IFDEF Win32}
     CFSD:TSystemSaveDialog;
{$ENDIF}

BEGIN
     Result := FALSE;

     CFSD.Create(SibylMainForm);
     CFSD.HelpContext := hctxDialogSaveProjectAs;
     CFSD.Caption := LoadNLSStr(SiSaveProjectAs);
     CFSD.AddFilter(LoadNLSStr(SiSibylProjectFiles)+' ('+ALL_FILES_UC_WDSibyl_SPR+')',ALL_FILES_UC_WDSibyl_SPR); // '*.SPR');
     CFSD.DefaultExt := GetDefaultExt(ALL_FILES_UC_WDSibyl_SPR); // '*.SPR');
     CFSD.FileName := Project.FileName;
     ret := CFSD.Execute;
     s := CFSD.FileName;
     CFSD.Destroy;
     Screen.Update;

     IF ret THEN
     BEGIN
          IF FileExists(s) THEN
            IF MessageBox(LoadNLSStr(SiPrjAlreadyExistsOverwrite),mtWarning,
                          mbOkCancel) = mrCancel THEN exit;

          Result := TRUE;
          Project.FileName := s;

          IF all THEN IF not SaveFiles(TRUE) THEN exit;
          IF all THEN IF not SaveSCU THEN exit;
          IF not Project.Save(s) THEN exit;
          IF all THEN IF not SaveINI(IdeSettings) THEN exit;
     END
     ELSE Result := TRUE;   {'Projekt speichern als' wurde abgebrochen -
                             Rahmenaktion jedoch fortsetzen}
END;


{”ffnet ein neues Projekt auf der Grundlage von Template und
 wechselt in das entsprechende Verzeichnis}
FUNCTION NewProject(s:STRING; Template:STRING):BOOLEAN;
VAR  ret:BOOLEAN;
     d,n,e:STRING;
     Edit:TEditor;
     Directories:^TDirectories;
BEGIN
     Result := FALSE;

     ToolsNotifyProc(fnProjectOpening,s,ret);
     IF ret THEN exit; //canceled

     IF not CloseProject(TRUE) THEN exit;

     Project.Initialize;

     {lade das Template}
     IF Template <> '' THEN
     BEGIN
          Template := '\Project\Template\'+ Template +'.spr';
          IF not Project.Load(GetInstallDir + Template)
          THEN Project.Initialize;
     END;

     IdeSettings.LastProject := s;
     IdeSettings.Modified := TRUE;
     Project.Untitled := TRUE; {damit nicht nach einer SCU gesucht wird}

     Project.FileName := s;

     FSplit(s,d,n,e);
     ChangeDir(d);

     Case Project.Settings.Platform OF
        pf_OS2:
        BEGIN
             Directories:=@Project.Settings.DirectoriesOS2;
        END;
        pf_WIN32:
        BEGIN
             Directories:=@Project.Settings.DirectoriesWin;
        END;
     END;

     Directories^.LastDir := ''; {Verzeichnis ist ok}

     ExecuteProject;
     Project.Untitled := FALSE; {Name wurde vom User gesetzt}
     {MainFile Name wurde damit auch vom User gesetzt}
     Edit := GetEditorProc(Project.Settings.Primary);
     IF Edit <> NIL THEN Edit.Untitled := FALSE;
     Result := TRUE;
END;


FUNCTION OpenProject(s:STRING;ReloadCompLib:BOOLEAN):BOOLEAN;
VAR  OldDir:STRING;
     ret:BOOLEAN;
{$IFDEF OS2}
     CFOD:TOpenDialog;
{$ENDIF}
{$IFDEF Win32}
     CFOD:TSystemOpenDialog;
{$ENDIF}

LABEL ok;
BEGIN
     Result := FALSE;

     IF s <> '' THEN goto ok;

     {Verzeichnis wechseln PRJ-Dir}
     {$i-}
     GetDir(0,OldDir);
     {$i+}
     IF IdeSettings.ProjectDir <> '' THEN
     BEGIN
          {$i-}
          ChDir(IdeSettings.ProjectDir);
          {$i+}
          IF InOutRes <> 0 THEN
          BEGIN
               {$i-}
               ChDir(GetProjectDir);
               {$i+}
          END;
     END;

     CFOD.Create(SibylMainForm);
     CFOD.HelpContext := hctxDialogOpenProject;
     CFOD.Caption := LoadNLSStr(SiOpenProject);
     CFOD.AddFilter(LoadNLSStr(SiSibylProjectFiles)+' ('+ALL_FILES_UC_WDSibyl_SPR+')',ALL_FILES_UC_WDSibyl_SPR); // '*.SPR');
     CFOD.FileName := ALL_FILES_UC_WDSibyl_SPR;
     CFOD.DefaultExt := GetDefaultExt(ALL_FILES_UC_WDSibyl_SPR);
     ret := CFOD.Execute;
     s := CFOD.FileName;
     CFOD.Destroy;
     Screen.Update;
     {$i-}
     ChDir(OldDir);
     {$i+}

     IF ret THEN
     BEGIN
ok:
          IF not FileExists(s) THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiPrjDoesNotExist));
               exit;
          END;

          ToolsNotifyProc(fnProjectOpening,s,ret);
          IF ret THEN exit; //canceled

          IF not CloseProject(ReloadCompLib) THEN exit;

          IF not Project.Load(s) THEN Project.Initialize
          ELSE Result := TRUE;

          ExecuteProject;
     END;
END;


{Proc nur fr IDETools}
FUNCTION DefaultProject(CONST Name:STRING;ReloadCompLib,CreateEmptyForm:BOOLEAN):BOOLEAN;
//VAR  SaveIDE:BOOLEAN;
BEGIN
     Result := FALSE;
     IF not CloseProject(ReloadCompLib) THEN exit;

     Project.FileName := Name;
     Project.Initialize;
     Result := TRUE;
(*
     SaveIDE := StartEmptyForm;
     StartEmptyForm := CreateEmptyForm;
     ExecuteProject;
     StartEmptyForm := SaveIDE;
*)
END;


FUNCTION CloseCurrentProject:BOOLEAN;
BEGIN
     Result := FALSE;
     IF not CloseProject(TRUE) THEN exit;

     Project.FileName := '';
     Project.Initialize;
     Project.Untitled := TRUE;
     Project.Settings.ProjectType := pt_NonVisual;

     ExecuteProject;
     Result := TRUE;
END;


FUNCTION StartProject:BOOLEAN;
VAR  LastPrj:STRING;
     s,d,n,e:STRING;
     i:LONGINT;
BEGIN
     Result := FALSE;

     {Projects Men updaten}
     FOR i := 0 TO ProjectsHistory.Count-1 DO
     BEGIN
          s := ProjectsHistory[i];
          AddMenuItem(s, ProjectsHistory, cmLastProject1, cmLastProjectN,
                      cmProjectMenu, MaxProjectMenu, MaxHistoryProjects);
     END;

     IF IdeSettings.LoadLastPrj THEN LastPrj := IdeSettings.LastProject
     ELSE LastPrj := GetUniqueFileName(GetProjectDir+'\','Project',1,'.spr'); //neues leeres Projekt
     {setze LastPrj = '' um gar kein Projekt zu laden}

     {Overwrite ProjectName if a PRJ CommandLine parameter exist}
     FOR i := 1 TO ParamCount DO
     BEGIN
          s := ParamStr(i);
          UpcaseStr(s);
          s := FExpand(s);
          FSplit(s,d,n,e);
          IF pos('.SPR',e) <> 0 THEN LastPrj := FExpand(ParamStr(i));
     END;

     IF not FileExists(LastPrj) THEN LastPrj := '';

     IF LastPrj <> '' THEN
     BEGIN
          ToolsNotifyProc(fnProjectOpening,LastPrj,result);
          //IF result THEN exit; //canceled

          IF not Project.Load(LastPrj) THEN Project.Initialize
          ELSE Result := TRUE;
     END
     ELSE
     BEGIN
          Project.FileName := GetUniqueFileName(GetProjectDir+'\','Project',1,'.spr'); //neues leeres Projekt
          Project.Initialize;
          Project.Untitled := TRUE;
          Project.Settings.ProjectType := pt_Visual;
          Result := TRUE;
     END;


     {Load additional files from command line in a temp list}
     FOR i := 1 TO ParamCount DO
     BEGIN
          s := ParamStr(i);
          UpcaseStr(s);
          s := FExpand(s);
          FSplit(s,d,n,e);
          IF pos(EXT_UC_WDSibyl_SPR,e) <> 0 THEN continue;
          IF pos(EXT_UC_HELP ,e) <> 0 THEN continue;
          IF pos(EXT_UC_INI  ,e) <> 0 THEN continue;
          Project.CmdLineFiles.Add(s);
     END;
END;


FUNCTION RestartProject:BOOLEAN;
VAR  LastPrj:STRING;
BEGIN
     Result := FALSE;

     LastPrj := IdeSettings.LastProject;

     IF LastPrj <> '' THEN
     BEGIN
          ToolsNotifyProc(fnProjectOpening,LastPrj,result);
          //IF result THEN exit; //canceled

          IF not Project.Load(LastPrj) THEN Project.Initialize
          ELSE Result := TRUE;
     END
     ELSE
     BEGIN
          Project.FileName := '';
          Project.Initialize;
          Project.Untitled := TRUE;
          Project.Settings.ProjectType := pt_NonVisual;
          Result := TRUE;
     END;

     ExecuteProject;
END;


TYPE
  TFormInitProc = PROCEDURE;


FUNCTION NewFormHandle:TForm;
VAR  Proc:TFormInitProc;
BEGIN
     Result:=FormEditClass.Create(NIL);
     Result.TypeName := 'T'+ Result.Name;
     Result.SetWindowPos(CodeEditorRef.Left+30,CodeEditorRef.Bottom-30,400,300);
     Result.Color := clDlgWindow;
     IF Project.Forms.Count=0 THEN
     BEGIN
         Proc := IdeSettings.DesktopWindows[dwi_Inspector].InitProc;
         IF Proc <> NIL THEN Proc;
     END;
END;


FUNCTION ExecuteProject:BOOLEAN;
VAR  Proc:TFormInitProc;
     dwi:TDesktopWinId;
     Win:TForm;
     s,d,n,e:STRING;
     t,i:LONGINT;
     TempFiles:TStringList;
     fcx:TEditorPos;
     pEditData:^TEditData;
     Cancel:Boolean;
     Panel:TDockingPalette;
     Progress:TProgressbar;
     ProgressWidth:LONGINT;
     prjname:STRING;
     Directories:^TDirectories;

  PROCEDURE IncProgress;
  BEGIN
       IF Progress <> NIL THEN Progress.Position := Progress.Position + 1;
  END;

BEGIN
  Application.LogWriteln('ExecuteProject');
     Project.Loading := TRUE;

   // // LogStr( 'ExecuteProject' );
     // Progressbar
     IF StatusPanel <> NIL THEN
     BEGIN
          IF StatusPanel.Width >= 108 THEN ProgressWidth := 100
          ELSE ProgressWidth := StatusPanel.Width - 8;

          Progress.Create(StatusPanel);
          Progress.SetWindowPos(StatusPanel.Width - ProgressWidth - 4, 4,
                                ProgressWidth, StatusPanel.Height - 8);
          Progress.PenColor := clBlue;
          //Progress.BorderStyle := bsNone;
          Progress.ProgressString := psCaption;
          Progress.Max := LONGINT(dwi_LastForm) + Project.LastOpenFiles.Count +
                          Project.CmdLineFiles.Count + 6;

          Progress.Parent := StatusPanel;
          Progress.Align := alFrame;
     END
     ELSE Progress := NIL;

     {CompLib laden und NavigatorPages fllen}
     SetupNavigatorPagesProc;
     {Es mssen immer die Pages geladen werden auch wenn das Pojekt nicht visuell ist,
      da sonst die Informationen nicht mehr ins NAV rausgeschrieben werden k”nnten}

     IncProgress;


     InitToolbarsProc;

     IncProgress;

     Application.ProcessMessages;

     {Paletten disablen}
     FOR t := 0 TO Paletten.Count-1 DO
     BEGIN
          Panel := TDockingPalette(Paletten.Objects[t]);
          Panel.Enabled := TRUE;
     END;

     IncProgress;

     {show Project related Forms}
     WITH IdeSettings DO
     BEGIN
          {Die Zeiger auf die beiden Standard Forms initialisieren,
           da durch InitializeProject auf 0 gesetzt}
          DesktopWindows[dwi_MainWindow].Form := Application.MainForm;
          DesktopWindows[dwi_CodeEditor].Form := CodeEditorRef;

          FOR dwi := dwi_MainWindow TO dwi_LastForm DO
          BEGIN
               Win := DesktopWindows[dwi].Form;
               IF Win <> NIL THEN
               BEGIN {MainWindow & CodeEditor}
                    WITH DesktopWindows[dwi] DO Win.SetWindowPos(X,Y,CX,CY);
                    Win.Show; {Update DesktopWindows[].Form Zeiger}
                    Win.Update;
               END;

               {maskiere bestimmte Forms fr Nichtvisuelle Projekte aus}
               IF (Project.Settings.ProjectType = pt_NonVisual) AND
                   (dwi IN VisualDesktopWinSet) THEN
               BEGIN
                    DesktopWindows[dwi].Visible := FALSE;
               END;

               {maskiere bestimmte Forms fr Visuelle Projekte ein}
               IF (Project.Settings.ProjectType = pt_Visual) AND
                   (dwi = dwi_Inspector ) THEN
               BEGIN
                    DesktopWindows[dwi].Visible := TRUE;
               END;

               IF DesktopWindows[dwi].Visible THEN
               BEGIN
                    Proc := DesktopWindows[dwi].InitProc;
                    IF Proc <> NIL THEN Proc;
               END;

               IncProgress;
          END;
     END;

     Application.ProcessMessages;

     {Einbinden der LastClosedFiles ins Men}
     TempFiles.Create;
     TempFiles.Assign(Project.FilesHistory);
     FOR i := TempFiles.Count-1 DOWNTO 0 DO
     BEGIN
          s := TempFiles.Strings[i];
          AddMenuItem(s, Project.FilesHistory, cmLastFile1, cmLastFileN,
                       cmFileMenu, MaxFileMenu, MaxHistoryFiles);
     END;
     TempFiles.Destroy;

     IncProgress;

     {ffnen der zuletzt ge”ffneten Files}
     IF @LoadEditorProc <> NIL THEN
     FOR i := 0 TO Project.LastOpenFiles.Count-1 DO
     BEGIN
          s := Project.LastOpenFiles.Strings[i];
          pEditData := POINTER(Project.LastOpenFiles.Objects[i]);
          fcx.Y := pEditData^.Line;
          fcx.X := pEditData^.Column;
          LoadEditorProc(s,pEditData^.Left,pEditData^.Bottom,
              pEditData^.Width,pEditData^.Height,TRUE,fcx,Fokus,ShowIt);
          Dispose(pEditData);

          IncProgress;
     END;
     Project.LastOpenFiles.Clear;
     {...}


     {zustzliche Kommandozeilen Files laden}
     IF @LoadEditorProc <> NIL THEN
     FOR i := 0 TO Project.CmdLineFiles.Count-1 DO
     BEGIN
          s := Project.CmdLineFiles.Strings[i];
          LoadEditorProc(s,0,0,0,0,TRUE,CursorHome,Fokus,ShowIt);

          IncProgress;
     END;
     Project.CmdLineFiles.Clear; {only 1 time}


     {SCU laden}
     IF Project.Settings.ProjectType = pt_Visual THEN
     BEGIN
          IF Project.Untitled THEN
          BEGIN
               IF StartEmptyForm THEN
               BEGIN
                    NewFormWinProc('');
                    Proc := IdeSettings.DesktopWindows[dwi_Inspector].InitProc;
                    IF Proc <> NIL THEN Proc;
               END;
          END
          ELSE Project.LoadSCU(GetSCUName);
     END;

     IncProgress;

     Case Project.Settings.Platform OF
       pf_OS2:
       BEGIN
            Directories:=@Project.Settings.DirectoriesOS2;
       END;
       pf_WIN32:
       BEGIN
            Directories:=@Project.Settings.DirectoriesWin;
       END;
     END;

     {IF ReturnToLastProjectDir THEN}
     IF Directories^.LastDir <> '' THEN
     BEGIN
          d := Directories^.LastDir;
          NormalizeDir(d);
          s := RelativeToProject(d +'\dummy.ext');
          FSplit(s,d,n,e);
          UpcaseStr(d);
          IF (pos('A:\',d) <> 1) AND (pos('B:\',d) <> 1) THEN
            IF not ChangeDir(d) THEN
            BEGIN
                 IF d <> Upcased(Directories^.LastDir)
                 THEN ChangeDir(Directories^.LastDir);
            END;
     END;

     IF Project.Name <> '' THEN prjname := '  -  ['+ Project.Name +']'
     ELSE prjname := '';
     SibylMainForm.Caption := 'WDSibyl' + prjname;

     Project.Loading := FALSE;
     Result := TRUE;

     ToolsNotifyProc(fnProjectOpened,Project.FileName,Cancel);

     IF IdeSettings.AutoSave * [as_INI] <> [] THEN SaveINI(IdeSettings);

     IncProgress;

     IF Progress <> NIL THEN Progress.Destroy;

     ProjectLoaded := TRUE;
  Application.LogWriteln('ExecuteProject:Ende');
END;


{ Directory Functions }

{liefert das Verzeichnis, das bei der Installation angegeben wurde}
FUNCTION GetInstallDir:STRING;
VAR  s,name,ext:STRING;
BEGIN
  IF IdeSettings.InstallDir = ''
    THEN
      BEGIN {Bestimme Directory aus dem Pfad von Sibyl.exe}
        FSplit(ParamStr(0),Result,name,ext);
        NormalizeDir(Result);
{$IFDEF OS2}
        s := copy(Result,Length(Result)-7,8);
        IF Upcased(s) = '\BIN\OS2' THEN dec(Result[0],8);
{$ENDIF}
{$IFDEF Win32}
        s := copy(Result,Length(Result)-9,10);
        IF Upcased(s) = '\BIN\WIN32' THEN dec(Result[0],10);
{$ENDIF}
      END
    ELSE Result := IdeSettings.InstallDir; {vom Installprogramm eingetragen}
  NormalizeDir(Result);
END;


{liefert das Verzeichnis, indem die Standard und Default SPR liegen}
FUNCTION GetProjectDir:STRING;
BEGIN
  Result := GetInstallDir;
END;


FUNCTION GetBinDir:STRING;
VAR  name,ext:STRING;
BEGIN
  Result := FExpand(IdeSettings.BinDir);
  IF Result = '' THEN
    FSplit(ParamStr(0),Result,name,ext);
  NormalizeDir(Result);
END;

function GetTemplateDir:String;

Begin
  if IdeSettings.TemplateDir = ''
    then
      Begin
        Result:=GetInstallDir+'\Bin\Template';
        IdeSettings.TemplateDir:=Result;
      end
    else Result:=IdeSettings.TemplateDir;
End;


FUNCTION GetOutDir(source:STRING):STRING;
VAR  name,ext:STRING;
     OutDir  : tStringList;

BEGIN
  OutDir.Create;
  OutDir.AddSplit(ProjectOutDir(Project.Settings),';');
  Result := OutDir.Strings[0];
  IF Result = '' THEN FSplit(source,Result,name,ext);
  NormalizeDir(Result);
  OutDir.Destroy;
END;


FUNCTION GetSCUName:STRING;
VAR  d,n,e:STRING;
BEGIN
     {Name aus den Settings nehmen}
     Result := ProjectSCUName(Project.Settings);
     IF Result = '' THEN
     BEGIN
          IF ProjectPrimary(Project.Settings) = ''
          THEN FSplit(Project.FileName,d,n,e)
          ELSE FSplit(ProjectPrimary(Project.Settings),d,n,e);
          Result := d + n + EXT_UC_WDSibyl_SCU; // '.scu';
     END;
END;


FUNCTION GetCompLibName:STRING;
VAR  d,n,e:STRING;
BEGIN
     {$IFDEF OS2}
     Result := Project.Settings.CompLibNameOs2;
     {$ENDIF}
     {$IFDEF WIN32}
     Result := Project.Settings.CompLibNameWin;
     {$ENDIF}
     IF Result <> '' THEN
     BEGIN
          FSplit(Result,d,n,e);
          IF e = '' THEN e := Ext_UC_DLL;
          Result := FExpand(d+n+e);
     END;
END;


FUNCTION GetShortCompLibName:STRING;
VAR  s,d,n,e:STRING;
BEGIN
     Result := '';
     s := GetCompLibName;
     IF s <> '' THEN
     BEGIN
          FSplit(s,d,n,e);
          Result := n;
     END;
END;


FUNCTION GetNAVName:STRING;         {NAV heiแt immer wie die CompLib}
VAR  s,d,n,e:STRING;
BEGIN
     Result := '';
     s := GetCompLibName;
     IF s <> '' THEN
     BEGIN
          FSplit(s,d,n,e);
          Result := d + n + '.nav';
     END;
END;


FUNCTION GetSCLName:STRING;         {SCL heiแt immer wie die CompLib}
VAR  s,d,n,e:STRING;
BEGIN
     Result := '';
     s := GetCompLibName;
     IF s <> '' THEN
     BEGIN
          FSplit(s,d,n,e);
          Result := d + n + '.scl';
     END;
END;


FUNCTION GetExeName:STRING;
VAR  dir,name,ext:STRING;
     Editor:TEditor;
BEGIN
     IF ProjectPrimary(Project.Settings) <> '' THEN
     BEGIN
          FSplit(ProjectPrimary(Project.Settings),dir,name,ext);
          Result := GetOutDir(ProjectPrimary(Project.Settings))
                    + '\' + name + Ext_UC_Exe;
     END
     ELSE
     BEGIN
          Editor := TEditor(CodeEditorRef.ActiveMDIChild);
          IF Editor IS TEditor THEN
          BEGIN
               FSplit(Editor.FileName,dir,name,ext);
               Result := GetOutDir(Editor.FileName) +'\'+ name + Ext_UC_Exe;
          END
          ELSE Result := '';
     END;
END;

function GetLngName:String;

VAR  dir,name,ext:STRING;
     Editor:TEditor;
BEGIN
  IF ProjectPrimary(Project.Settings) <> '' THEN
    BEGIN
      FSplit(ProjectPrimary(Project.Settings),dir,name,ext);
      Result := GetOutDir(ProjectPrimary(Project.Settings))
                 + '\' + name + EXT_UC_Language ;
    END
  ELSE
    BEGIN
      Editor := TEditor(CodeEditorRef.ActiveMDIChild);
      IF Editor IS TEditor
        THEN
          BEGIN
            FSplit(Editor.FileName,dir,name,ext);
            Result := GetOutDir(Editor.FileName) +'\'+ name + EXT_UC_Language;
          END
        ELSE Result := '';
  END;
END;                

FUNCTION GetMakeName:STRING;
VAR  Editor:TEditor;
BEGIN
     Result := ProjectPrimary(Project.Settings);
     IF Result = '' THEN
     BEGIN
          Editor := TEditor(CodeEditorRef.ActiveMDIChild);
          IF Editor IS TEditor THEN Result := Editor.FileName;
     END;
END;


FUNCTION GetCompileName:STRING;
VAR  Editor:TEditor;
BEGIN
     Editor := TEditor(CodeEditorRef.ActiveMDIChild);
     IF not (Editor IS TEditor) THEN Editor := NIL;

     IF Editor <> NIL THEN Result := Editor.FileName
     ELSE Result := ProjectPrimary(Project.Settings);
END;


FUNCTION GetUniqueFileName(CONST dir:STRING;name:STRING;nr:INTEGER;CONST ext:STRING):STRING;
BEGIN
     WHILE TRUE DO
     BEGIN
          Result := dir + name + tostr(nr) + ext;
          IF (GetEditorProc(Result) = NIL) AND not FileExists(Result) THEN exit;
          inc(nr);
          IF Length(name) + Length(tostr(nr)) >= 8
          THEN SetLength(name, 8-Length(tostr(nr)));
     END;
END;



FUNCTION GetVDEDirectories:STRING;
BEGIN
     Result := ProjectLibSrcDir(Project.Settings) + ';' +
               ProjectIncSrcDir(Project.Settings) + ';' +
               ProjectOutDir(Project.Settings) + ';' +
               ProjectLibDir(Project.Settings) + ';' +
               ProjectCompInstallDir(Project.Settings);
END;


Procedure InitSibPrjUnit;
BEGIN
     TopToolButtonList.Create;
     TopToolButtonList.Add(POINTER(cmOpen));
     TopToolButtonList.Add(POINTER(cmSave));
     TopToolButtonList.Add(POINTER(cmNull));
     TopToolButtonList.Add(POINTER(cmSlidingUndo));
     TopToolButtonList.Add(POINTER(cmFind));
     TopToolButtonList.Add(POINTER(cmSearchAgain));
     TopToolButtonList.Add(POINTER(cmNull));
     TopToolButtonList.Add(POINTER(cmCompile));
     TopToolButtonList.Add(POINTER(cmMake));
     TopToolButtonList.Add(POINTER(cmNull));
     TopToolButtonList.Add(POINTER(cmWindowList));

     BottomToolButtonList.Create;
     BottomToolButtonList.Add(POINTER(cmNewForm));
     BottomToolButtonList.Add(POINTER(cmProjectSettings));
     BottomToolButtonList.Add(POINTER(cmNull));
     BottomToolButtonList.Add(POINTER(cmCut));
     BottomToolButtonList.Add(POINTER(cmCopy));
     BottomToolButtonList.Add(POINTER(cmPaste));
     BottomToolButtonList.Add(POINTER(cmNull));
     BottomToolButtonList.Add(POINTER(cmRun));
     BottomToolButtonList.Add(POINTER(cmProgramReset));
     BottomToolButtonList.Add(POINTER(cmNull));
     BottomToolButtonList.Add(POINTER(cmHelpContents));

     CodeTemplateList.Create;
End;

Begin
     CodeEditorRef := NIL;
     FormEditClass := TForm;
     LastDesignForm := NIL;
     ProjectsHistory := NIL;
     FindInFilesHistory := NIL;
     FindInFilesFilter := NIL;
     FindInFilesPaths := NIL;
     LastCloseProjectAnswer := mrYes;
     LastKeyMap := TEditKeyMap(-1);

     SibylMainForm := NIL;
     SibylMainMenu := NIL;
     StatusPanel := NIL;
     NewFormWinProc := NIL;
     SetInspectorDataProc := NIL;
     LoadEditorProc := NIL;
     InitToolbarsProc := NIL;
     RemoveNavigatorProc := NIL;
     SetupNavigatorPagesProc := NIL;
     UpdateBrowserInfoProc := NIL;
     InitControlCentreProc := NIL;
     ClearBuildListProc := NIL;
     ClearFindInFilesListProc := NIL;
     GetVDEDirectoriesProc := @GetVDEDirectories;

     ProjectsHistory.Create;
     FindInFilesHistory.Create;
     FindInFilesFilter.Create;
     FindInFilesPaths.Create;
     ToolsList.Create;
     GlobalMacroList.Create;

     CXScreen := Screen.Width;
     CYScreen := Screen.Height;
     CYMainForm := 2 * goSysInfo.Screen.BorderSize.CY +
                   goSysInfo.Screen.TitlebarSize +
                   goSysInfo.Screen.MenuSize +
                   TopToolbarSize;

     InitializeINI;
     Project.Create;
     Project.Initialize;
     Paletten.Create;
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Dec-02  WD         Ausbau des Standard-Teil
  02-Aug-03  WD         Einbau der CreateLngFile;
  30-Apr-04  WD         Umbau der Funktion GetOutDir auf mehrere Verszeichnisse
  25-Aug-04  WD         Erst-Start: Korrektur der Verzeichnisse (+Erstellung der Verz. im Filesystem)
  24-Sep-04  WD         Keine Fehlermeldung wenn die SCU-Datei leer ist.
  23-Okt-04  WD         Daten von der Compiler-Page speichern und laden.
  09-Apr-05  WD         Einbau der Verwaltung von Templates in Projekt/Neu und Optionen/Allgemein
  20-Mai-05  WD         Einbau von HelpCompilerFileName und HelpCompilerLanguage.
  29-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  22-Nov-05  WD         Autosave (Init): Alles automatisch Speichern
  10-Jan-06  WD         Diverse Funktionen in die WDSibyl-DLL bertragen
  30-Mar-06  WD         Erstellung der Output-Verzeichnisse ausgebaut (--> Installer)
  30-Mar-06  WD         INI-Datei als Parameter ausgebaut
  26-Dec-07  WD         Tools: $ININAME eingebaut
}
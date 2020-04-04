{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Visual Development Environment                                บ
 บ                                                                          บ
 บ    Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.       บ
 บ    Copyright (C) 2002..  Ing. Wolfgang Draxler,   All rights reserved.   บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
                                                             
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ WDSibyl Integrated Development Environment (IDE)                         บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
 บ Copyright (C) 2002..  Ing. Wolfgang Draxler                              บ
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

UNIT Consts;
                   
INTERFACE           
                           
USES Forms,Graphics, Messages, Menus, uSysClass,
     uList, uString, SPC_DATA, Dos;

// Konstanten fuer die Version
Const WDSibyl_AppName     = 'WDSibyl';
      WDSibyl_Version     = 3;
      WDSibyl_SubVersion  = 13;
      WDSibyl_HomepageLink= 'http://www.wdsibyl.org';
      WDSibyl_Contact     = 'Name:  Ing. Wolfgang Draxler'+ #13#10+
                            'E-Mail:WDSibyl@wdsibyl.org'+ #13#10+
                            'BIC:   DABBDEMM'+ #13#10+
                            'IBAN:  DE64701204007384621004';

// Semaphore
      WDSibyl_Sem_CompileALLRC = 'WDSRC';
      WDSibyl_Sem_CompileALLPAS= 'WDSPAS';
      WDSibyl_Install_Param    = '-INSTALL';
      WDSibyl_NoPipe_Param     = '-NOPIPE';


FUNCTION CommandToIndex(Command:TCommand):INTEGER;

// Informationen fuer die div. Dialoge die in der WDSIBD.DLL eingebaut sind
type tWDSibDLLInfo = Record
       Application : tApplication;
     End;

type tInfoAboutDialog = Record
       HelpContext : LongWord;
       Caption     : String;
       VPDTool     : String;
     end;     

Imports
{$IFDEF OS2}
  Procedure InitWDSibDLL(DLLInfo : tWDSibDLLInfo);
                        'WDSIBD' Index 1;
  Procedure DestroyWDSibDLL;
                        'WDSIBD' Index 2;

  FUNCTION Upcased(CONST s:STRING):STRING;
                        'WDSIBD' Index 10;
  FUNCTION SplitFontName(FontName:STRING; VAR Name:STRING; VAR Size:LONGINT):BOOLEAN;
                        'WDSIBD' Index 11;
  FUNCTION SplitFixedFontName(FontName:STRING; VAR Name:STRING; VAR Height,Width:LONGINT):BOOLEAN;
                        'WDSIBD' Index 12;
  PROCEDURE NormalizeDir(VAR dirstr:STRING);
                        'WDSIBD' Index 13;
  FUNCTION GetNextDir(VAR dir:STRING):STRING;
                        'WDSIBD' Index 14;
  FUNCTION GetShortName(s:STRING;anz:INTEGER):STRING;
                        'WDSIBD' Index 15;
  FUNCTION IsFlag(s,test:STRING):BOOLEAN;
                        'WDSIBD' Index 16;
  PROCEDURE AddFlag(VAR s:STRING;CONST flag:STRING);
                        'WDSIBD' Index 17;
  FUNCTION ReplaceEnvStrings(CONST Path:STRING):STRING;
                        'WDSIBD' Index 18;
  FUNCTION FExpand(Path:STRING):STRING;
                        'WDSIBD' Index 19;
  FUNCTION Exec2(CONST Path: PathStr; CmdLine: STRING):LONGWORD;
                        'WDSIBD' Index 20;
  Procedure GetRCIcon(Name : String; Var Icon : tIcon);
                        'WDSIBD' Index 21;

  PROCEDURE AboutDialog(InfoAboutDialog : tInfoAboutDialog);
                        'WDSIBD' Index 100;

  Procedure LogRunCompiler(Quell_Ext : String; Params : TPasParams);
                        'WDSIBD' Index 200;

{$ENDIF}
{$IFDEF WIN32}
  Procedure InitWDSibDLL(DLLInfo : tWDSibDLLInfo);
                        'WDSIBD' Name 'INITWDSIBDLL';
  Procedure DestroyWDSibDLL;
                        'WDSIBD' Name 'DESTROYWDSIBDLL';

  FUNCTION Upcased(CONST s:STRING):STRING;
                        'WDSIBD' Name 'UPCASED';
  FUNCTION SplitFontName(FontName:STRING; VAR Name:STRING; VAR Size:LONGINT):BOOLEAN;
                        'WDSIBD' Name 'SPLITFONTNAME';
  FUNCTION SplitFixedFontName(FontName:STRING; VAR Name:STRING; VAR Height,Width:LONGINT):BOOLEAN;
                        'WDSIBD' Name 'SPLITFIXEDFONTNAME';
  PROCEDURE NormalizeDir(VAR dirstr:STRING);
                        'WDSIBD' Name 'NORMALIZEDIR';
  FUNCTION GetNextDir(VAR dir:STRING):STRING;
                        'WDSIBD' Name 'GETNEXTDIR';
  FUNCTION GetShortName(s:STRING;anz:INTEGER):STRING;
                        'WDSIBD' Name 'GETSHORTNAME';
  FUNCTION IsFlag(s,test:STRING):BOOLEAN;
                        'WDSIBD' Name 'ISFLAG';
  PROCEDURE AddFlag(VAR s:STRING;CONST flag:STRING);
                        'WDSIBD' Name 'ADDFLAG';
  FUNCTION ReplaceEnvStrings(CONST Path:STRING):STRING;
                        'WDSIBD' Name 'REPLACEENVSTRINGS';
  FUNCTION FExpand(Path:STRING):STRING;
                        'WDSIBD' Name 'FEXPAND';
  FUNCTION Exec2(CONST Path: PathStr; CmdLine: STRING):LONGWORD;
                        'WDSIBD' Name 'EXEC2';
  Procedure GetRCIcon(Name : String; Var Icon : tIcon);
                        'WDSIBD' Name 'GETRCICON';


  PROCEDURE AboutDialog(InfoAboutDialog : tInfoAboutDialog);
                        'WDSIBD' Name 'ABOUTDIALOG';

  Procedure LogRunCompiler(Quell_Ext : String; Params : TPasParams);
                        'WDSIBD' Name 'LOGRUNCOMPILER';
{$ENDIF}
                 
End;

{$I WDSibyl.Inc}     // language constants
{$I WDSibylHlp.Inc}  // hctx-Konstanten fuer die Help-Datei

VAR log          : tcLog;
    MainIcon     : TIcon;
    InspectorIcon: TIcon;
    WatchIcon    : TIcon;
    EditIcon     : TIcon;
    InspectIcon  : TIcon;
    CpuWinIcon   : TIcon;

    PipeServer   : tcNamedPipeServer;

Const AppMemList:TList = NIL;

CONST
    usefore = 1;  {use Foreground}
    useback = 2;  {use Background}

    EditorPropertiesIndex   = 0;
    DesignerPropertiesIndex = 3;
    BrowserPropertiesIndex  = 4;

    CompilerPropertiesIndex = 0;
    FormPropertiesIndex     = 5;

    IconWidth =10;
    IconHeight=12;


Const cLng_Caption= '.Caption=';
      cLng_Hint   = '.Hint=';

CONST
    cmOpenMsgWindow             = cmUser+4;
    cmToggleReadOnly            = cmUser+5;
    cmToggleMsgView             = cmUser+6;
    cmEditorProperties          = cmUser+7;
    cmCloseCodeCompletion       = cmUser+8;

    cmProjectNew                = cmUser+99;
    cmProjectSave               = cmUser+100;
    cmProjectLoad               = cmUser+101;
    cmNewForm                   = cmUser+102;
    cmProjectSettings           = cmUser+103;
    cmProjectClose              = cmUser+104;
    cmProjectSaveAs             = cmUser+105;
    cmCompile                   = cmUser+107;
    cmMake                      = cmUser+108;
    cmBuild                     = cmUser+109;
    cmRun                       = cmUser+110;
    cmGotoLastError             = cmUser+111;
    cmCreateLngFile             = cmUser+112;
    cmIncrementalSearch         = cmUser+113;
    cmGotoLine                  = cmUser+117;
    cmStopCompiler              = cmUser+118;
    cmInsertFile                = cmUser+120;
    cmProjectManager            = cmUser+122;
    cmWindowList                = cmUser+123;
    cmViewAlign                 = cmUser+124;
    cmViewInspector             = cmUser+125;
    cmFormUnit                  = cmUser+126;
    cmStepInto                  = cmUser+127;
    cmStepOver                  = cmUser+128;
    cmToggleSpeedbar            = cmUser+129;
    cmToggleNavigator           = cmUser+130;
    cmToggleStatusbar           = cmUser+131;
    cmViewComponents            = cmUser+132;
    cmInstallComponents         = cmUser+133;
    cmRecompileCompLib          = cmUser+134;
    cmRemoveComponents          = cmUser+135;
    cmNewComponent              = cmUser+136;
    cmOpenCompLib               = cmUser+137;
    cmOpenFileAtCursor          = cmUser+138;
    cmMaximizeRestore           = cmUser+139;
    cmRunParameters             = cmUser+140;
    cmGo                        = cmUser+141;
    cmMacroRecord               = cmUser+142;
    cmMacroPlay                 = cmUser+143;
    cmMacroSave                 = cmUser+144;
    cmToolbars                  = cmUser+145;
    cmSelectMode                = cmUser+146;
    cmReOpenFile                = cmUser+147;

    cmToggleMDIMode             = cmUser+171;
    cmMacroList                 = cmUser+172;
    cmViewCPU                   = cmUser+173;
    cmViewWatch                 = cmUser+174;
    cmAddWatch                  = cmUser+175;
    cmEvaluateModify            = cmUser+176;
    cmProgramReset              = cmUser+177;
    cmUnloadProcess             = cmUser+178;
    cmProgramReload             = cmUser+179;
    cmProgReload                = cmUser+180;
    cmGotoDebugCursor           = cmUser+181;
    cmViewSource                = cmUser+182;
    cmViewBrowser               = cmUser+183;
    cmViewDump                  = cmUser+184;
    cmToggleBreakPoint          = cmUser+185;
    cmClearAllBreakPoints       = cmUser+186;
    cmClipBoardList             = cmUser+187;
    cmSlidingUndo               = cmUser+188;
    cmMatchingBrace             = cmUser+189;
    cmBookmarks                 = cmUser+190;
    cmToolOptions               = cmUser+191;
    cmSetPrimary                = cmUser+192;
    cmClearPrimary              = cmUser+193;
    cmFindInFiles               = cmUser+194;

    cmFileMenu                  = cmUser+200;
    cmEditMenu                  = cmUser+201;
    cmSearchMenu                = cmUser+202;
    cmViewMenu                  = cmUser+203;
    cmComponentMenu             = cmUser+204;
    cmDebugMenu                 = cmUser+206;
    cmProjectMenu               = cmUser+207;
    cmOptionsMenu               = cmUser+208;
    cmWindowMenu                = cmUser+209;
    cmHelpMenu                  = cmUser+210;
    cmExpertsMenu               = cmUser+211;
    cmExpert1                   = cmUser+212;
    cmExpert2                   = cmUser+213;
    cmExpert3                   = cmUser+214;
    cmExpert4                   = cmUser+215;
    cmExpert5                   = cmUser+216;
    cmExpert6                   = cmUser+217;
    cmExpert7                   = cmUser+218;
    cmExpert8                   = cmUser+219;
    cmExpert9                   = cmUser+220;
    cmExpert10                  = cmUser+221;
    cmExpert11                  = cmUser+222;
    cmExpert12                  = cmUser+223;
    cmExpert13                  = cmUser+224;
    cmExpert14                  = cmUser+225;
    cmExpert15                  = cmUser+226;
    cmViewRepository            = cmUser+227;
    cmInspectValue              = cmUser+228;
    cmWatchPoints               = cmUser+229;
    cmConfigurePalette          = cmUser+230;
    cmNewObject                 = cmUser+231;
    cmNewUnit                   = cmUser+232;
    cmNewWDSibylHelp            = cmUser+290;
    cmNewResource               = cmUser+291;
    cmNewText                   = cmUser+233;
    cmNewCompLib                = cmUser+234;
    cmNewDock                   = cmUser+235;
    cmNewThread                 = cmUser+236;
    cmImport                    = cmUser+237;
    cmGeneral                   = cmUser+238;
    cmLanguageSettings          = cmUser+239;

    cmRunLine                   = cmUser+240;
    cmReload                    = cmUser+241;
    cmChangeSrc                 = cmUser+242;
    cmChange                    = cmUser+243;
    cmdcHexAndChar              = cmUser+244;
    cmdcCharacter               = cmUser+245;
    cmdc16Int                   = cmUser+246;
    cmdc16uInt                  = cmUser+247;
    cmdc16IntHex                = cmUser+248;
    cmdc32Int                   = cmUser+249;
    cmdc32uInt                  = cmUser+250;
    cmdc32IntHex                = cmUser+251;
    cmdcSingle                  = cmUser+252;
    cmdcDouble                  = cmUser+253;
    cmdcExtended                = cmUser+254;
    cmdcComp                    = cmUser+255;
    cmGotoOrigin                = cmUser+256;
    cmGotoLoc                   = cmUser+257;
    cmReturnFromFunction        = cmUser+258;
    cmBreakPoints               = cmUser+259;
    cmLocalVariables            = cmUser+260;
    cmViewSymbols               = cmUser+261;
    cmAddToRepository           = cmUser+262;
    cmLoadTemplateForms         = cmUser+263;
    cmSaveTemplateForms         = cmUser+264;
    cmCustomize                 = cmUser+265;

    {Browser}
    cmObjects                   = cmUser+270;
    cmUnits                     = cmUser+271;
    cmGlobals                   = cmUser+272;
    cmSymbol                    = cmUser+273;
    cmQualified                 = cmUser+274;
    cmSource                    = cmUser+275;
    cmUpdate                    = cmUser+276;
    cmBrowserProperties         = cmUser+277;

    cmTool0                     = cmUser+280;
    cmTool1                     = cmUser+281;
    cmTool2                     = cmUser+282;
    cmTool3                     = cmUser+283;
    cmTool4                     = cmUser+284;
    cmTool5                     = cmUser+285;
    cmTool6                     = cmUser+286;
    cmTool7                     = cmUser+287;
    cmTool8                     = cmUser+288;
    cmTool9                     = cmUser+289;

    {Alignment}
    cmAlignmentMenu             = cmUser+300;
    cmAlign1                    = cmUser+301;
    cmAlign2                    = cmUser+302;
    cmAlign3                    = cmUser+303;
    cmAlign4                    = cmUser+304;
    cmAlign5                    = cmUser+305;
    cmAlign6                    = cmUser+306;
    cmAlign7                    = cmUser+307;
    cmAlign8                    = cmUser+308;
    cmAlign9                    = cmUser+309;
    cmAlign10                   = cmUser+310;
    cmAlign11                   = cmUser+311;
    cmAlign12                   = cmUser+312;
    cmAlign13                   = cmUser+313;
    cmAlign14                   = cmUser+314;
    cmForceAlign                = cmUser+315;
    cmRefresh                   = cmUser+316;
    cmDelCtrl                   = cmUser+317;
    cmGridVis                   = cmUser+318;
    cmSnapToGrid                = cmUser+319;
    cmDesignPos                 = cmUser+320;


    MaxFileMenu                 = 14; {Anzahl der Eintrge im Files Men}
    MaxHistoryFiles             = 6;  {Anzahl der max. sichtbaren Eintrge}
    cmLastFile1                 = cmUser+1001;
    cmLastFileN                 = cmUser+1999;

    MaxProjectMenu              = 20;  {Anzahl der Eintrge im Project Men}
    MaxHistoryProjects          = 5;  {Anzahl der max. sichtbaren Eintrge}
    cmLastProject1              = cmUser+2001;
    cmLastProjectN              = cmUser+2099;

    MaxOptionMenu               = 5;

    {umleiten an CodeEditor}
    CodeEditorCommands=
      [cmNew,cmOpen,cmInsertFile,cmSave,cmSaveAs,cmSaveAll,cmNewUnit,cmNewText,
       cmNewWDSibylHelp, cmNewResource,
       cmNewCompLib,cmNewThread,
       cmUndo,cmRedo,cmCut,cmCopy,cmPaste,cmDelete,cmSelectAll,cmDeselectAll,
       cmMacroRecord,cmMacroPlay,cmMacroSave,
       cmFind,cmReplace,cmSearchAgain,
       cmIncrementalSearch,cmMatchingBrace,
       cmGotoLastError,
       cmTile,cmCascade,cmNext,cmPrevious,cmCloseTop,cmMaximizeRestore,
       cmCloseAll,
       cmTopicSearch,
       cmToggleReadOnly,cmToggleMsgView,cmToggleStatusbar,cmEditorProperties,
       cmSelectMode];

    {umleiten an Last FormEditor}
    FormEditorCommands=
      [cmAlign1,cmAlign2,cmAlign3,cmAlign4,cmAlign5,cmAlign6,cmAlign7,
       cmAlign8,cmAlign9,cmAlign10,cmAlign11,cmAlign12,cmAlign13,cmAlign14,
       cmForceAlign,cmRefresh,cmDelCtrl,cmGridVis,cmSnapToGrid,cmDesignPos];

    FormEditCommands=
      [cmUndo,cmRedo,cmCut,cmCopy,cmPaste,cmDelete,cmSelectAll,cmDeselectAll];


    MaxClipBoardHistory         = 10;

    bmpOk                       = 100;
    bmpCancel                   = 101;
    bmpNo                       = 102;
    bmpHelp                     = 103;
    bmpAttention                = 104;
    bmpInfo                     = 105;
    bmpKred                     = 110;
    bmpKblue                    = 111;
    bmpKlila                    = 112;
    bmpUp                       = 120;
    bmpDown                     = 121;
    bmpLeft                     = 122;
    bmpRight                    = 123;

    bmpNew                      = 1020;
    bmpOpen                     = 1006;
    bmpSave                     = 1005;
    bmpSaveAs                   = 1029;
    bmpSaveAll                  = 1028;
    bmpFolder                   = 1100;
    bmpCut                      = 1001;
    bmpCopy                     = 1002;
    bmpPaste                    = 1015;
    bmpFind                     = 1007;
    bmpReplace                  = 1011;
    bmpFindNext                 = 1026;

    bmpStepInto                 = 1018;
    bmpStepOver                 = 1019;
    bmpPrgReset                 = 1008;
    bmpActive                   = 1003;
    bmpInactive                 = 1037;

    bmpPrjExpert                = 1040;
    bmpFormExpert               = 1041;

    bmpNew_Thread               = 1042;
    bmpNew_App                  = 1043;
    bmpNew_Form                 = 1044;
    bmpNew_Unit                 = 1045;
    bmpNew_WDSibylHelp          = 1112;
    bmpNew_Resource             = 1113;
    bmpNew_Text                 = 1046;
    bmpNew_Comp                 = 1047;
    bmpNew_CompLib              = 1048;
    bmpNew_Dock                 = 1049;


TYPE
    TSibylMenuRecord=RECORD
      Level: BYTE;
      Cmd: TCommand;
      Bmp: LONGWORD;
      Text: LONGINT;
      scWS: STRING[15];
      scCUA: STRING[15];
      scDef: STRING[15];
      Hint: LONGINT;
      Menu: TMenuItem;
      Btn: TControl;
      hctx: LONGINT;
    END;

CONST
    MaxMenuEntries=169;

    MenuEntries: ARRAY[1..MaxMenuEntries] OF TSibylMenuRecord = (

      (Level:0;Cmd:cmFileMenu;Bmp:0;Text:SiMenuFile;scWS:'';scCUA:'';scDef:'';Hint:SiMenuFileHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFile),
        (Level:1;Cmd:cmNewObject;Bmp:1700;Text:SiMenuNew;scWS:'';scCUA:'';scDef:'';Hint:SiMenuNewHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileNewObject),
        (Level:1;Cmd:cmNew;Bmp:1020;Text:SiMenuNewFile;scWS:'';scCUA:'';scDef:'';Hint:SiMenuNewFileHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileNewFile),
        (Level:1;Cmd:cmOpen;Bmp:1006;Text:SiMenuOpen;scWS:'F3';scCUA:'Ctrl+O';scDef:'';Hint:SiMenuOpenHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileOpen),
        (Level:1;Cmd:cmInsertFile;Bmp:1701;Text:SiMenuInsert;scWS:'';scCUA:'';scDef:'';Hint:SiMenuInsertHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileInsert),
        (Level:1;Cmd:cmSave;Bmp:1005;Text:SiMenuSave;scWS:'F2';scCUA:'F2';scDef:'';Hint:SiMenuSaveHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileSave),
        (Level:1;Cmd:cmSaveAs;Bmp:1029;Text:SiMenuSaveAs;scWS:'';scCUA:'';scDef:'';Hint:SiMenuSaveAsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileSaveAs),
        (Level:1;Cmd:cmSaveAll;Bmp:1028;Text:SiMenuSaveAll;scWS:'';scCUA:'';scDef:'';Hint:SiMenuSaveAllHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileSaveAll),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmPrint;Bmp:1702;Text:SiMenuPrint;scWS:'Ctrl+P';scCUA:'Ctrl+P';scDef:'Ctrl+P';Hint:SiMenuPrintHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFilePrint),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmCreateDir;Bmp:1714;Text:SiMenuCreateDir;scWS:'';scCUA:'';scDef:'';Hint:SiMenuCreateDirHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileCreateDir),
        (Level:1;Cmd:cmChangeDir;Bmp:1715;Text:SiMenuChangeDir;scWS:'';scCUA:'';scDef:'';Hint:SiMenuChangeDirHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileChangeDir),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmExit;Bmp:1706;Text:SiMenuExit;scWS:'Alt+X';scCUA:'F3';scDef:'';Hint:SiMenuExitHint;Menu:NIL;Btn:NIL;hctx:hctxMenuFileExit),

      (Level:0;Cmd:cmEditMenu;     Bmp:0;    Text:SiMenuEdit;       scWS:'';               scCUA:'';scDef:'';Hint:SiMenuEditHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEdit),
        (Level:1;Cmd:cmSlidingUndo;Bmp:1013; Text:SiMenuUndo;       scWS:'Ctrl+BkSp';      scCUA:'Ctrl+BkSp';scDef:'Ctrl+Z';Hint:SiMenuUndoHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditUndo),
        (Level:1;Cmd:cmRedo;       Bmp:1022; Text:SiMenuRedo;       scWS:'Shift+Ctrl+BkSp';scCUA:'Shift+Ctrl+BkSp';scDef:'Ctrl+Shift+Z';Hint:SiMenuRedoHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditRedo),
        (Level:1;Cmd:cmNull;       Bmp:0;    Text:0;scWS:'';        scCUA:'';              scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmCut;        Bmp:1001; Text:SiMenuCut;        scWS:'Shift+Del';      scCUA:'Shift+Del';scDef:'Ctrl+X';Hint:SiMenuCutHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditCut),
        (Level:1;Cmd:cmCopy;       Bmp:1002; Text:SiMenuCopy;       scWS:'Ctrl+Ins';       scCUA:'Ctrl+Ins';scDef:'Ctrl+C';Hint:SiMenuCopyHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditCopy),
        (Level:1;Cmd:cmPaste;      Bmp:1015; Text:SiMenuPaste;      scWS:'Shift+Ins';      scCUA:'Shift+Ins';scDef:'Ctrl+V';Hint:SiMenuPasteHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditPaste),
        (Level:1;Cmd:cmDelete;     Bmp:1705; Text:SiMenuDelete;     scWS:'Ctrl+Del';       scCUA:'Ctrl+Del';scDef:'Ctrl+Del';Hint:SiMenuDeleteHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditDelete),
        (Level:1;Cmd:cmNull;       Bmp:0;    Text:0;scWS:'';        scCUA:'';              scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmSelectMode; Bmp:1705; Text:SiMenuSelectMode; scWS:'Ctrl+KN';        scCUA:'Ctrl+KN';scDef:'Ctrl+KN';Hint:SiMenuSelectModeHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSelectMode),
        (Level:1;Cmd:cmNull;       Bmp:0;    Text:0;scWS:'';        scCUA:'';              scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmSelectAll;  Bmp:1707; Text:SiMenuSelectAll;  scWS:'';               scCUA:'';scDef:'';Hint:SiMenuSelectAllHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditSelectAll),
        (Level:1;Cmd:cmDeselectAll;Bmp:1708; Text:SiMenuDeselectAll;scWS:'';               scCUA:'';scDef:'';Hint:SiMenuDeselectAllHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditDeselectAll),
        (Level:1;Cmd:cmNull;       Bmp:0;    Text:0;scWS:'';        scCUA:'';              scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmMacroRecord;Bmp:1709; Text:SiMenuRecordMacro;scWS:'Ctrl+Shift+R';   scCUA:'Ctrl+Shift+R';scDef:'Ctrl+Shift+R';Hint:SiMenuRecordMacroHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditRecordMacro),
        (Level:1;Cmd:cmMacroPlay;  Bmp:1710; Text:SiMenuPlayMacro;  scWS:'Ctrl+Shift+P';   scCUA:'Ctrl+Shift+P';scDef:'Ctrl+Shift+P';Hint:SiMenuPlayMacroHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditPlayMacro),
        (Level:1;Cmd:cmMacroSave;  Bmp:1711; Text:SiMenuSaveMacro;  scWS:'Ctrl+Shift+A';   scCUA:'Ctrl+Shift+A';scDef:'Ctrl+Shift+A';Hint:SiMenuSaveMacroHint;Menu:NIL;Btn:NIL;hctx:hctxMenuEditSaveMacro),

      (Level:0;Cmd:cmSearchMenu;Bmp:0;Text:SiMenuSearch;scWS:'';scCUA:'';scDef:'';Hint:SiMenuSearchHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearch),
        (Level:1;Cmd:cmFind;Bmp:1007;Text:SiMenuFind;scWS:'Ctrl+QF';scCUA:'Ctrl+F';scDef:'Ctrl+F';Hint:SiMenuFindHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearchFind),
        (Level:1;Cmd:cmReplace;Bmp:1011;Text:SiMenuReplace;scWS:'Ctrl+QA';scCUA:'Ctrl+R';scDef:'Ctrl+R';Hint:SiMenuReplaceHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearchReplace),
        (Level:1;Cmd:cmSearchAgain;Bmp:1026;Text:SiMenuSearchAgain;scWS:'Ctrl+L';scCUA:'Ctrl+N';scDef:'F3';Hint:SiMenuSearchAgainHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearchFindNext),
        (Level:1;Cmd:cmIncrementalSearch;Bmp:1716;Text:SiMenuIncrementalSearch;scWS:'Ctrl+QI';scCUA:'Ctrl+E';scDef:'Ctrl+E';Hint:SiMenuIncrementalSearchHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearchIncSearch),
        (Level:1;Cmd:cmMatchingBrace;Bmp:1058;Text:SiMenuMatchingBrace;scWS:'';scCUA:'';scDef:'';Hint:SiMenuMatchingBraceHint;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmFindInFiles;Bmp:1057;Text:SiFindInFiles;scWS:'';scCUA:'';scDef:'';Hint:SiFindInFilesHint;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmGotoLine;Bmp:1717;Text:SiMenuGotoLine;scWS:'';scCUA:'';scDef:'';Hint:SiMenuGotoLineHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearchGotoLine),
        (Level:1;Cmd:cmGotoLastError;Bmp:1718;Text:SiMenuGotoLastError;scWS:'Ctrl+QW';scCUA:'Ctrl+QW';scDef:'Ctrl+QW';Hint:SiMenuGotoLastErrorHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearchGotoError),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmBookMarks;Bmp:1719;Text:SiMenuBookmarks;scWS:'Ctrl+B';scCUA:'Ctrl+B';scDef:'Ctrl+B';Hint:SiMenuBookMarksHint;Menu:NIL;Btn:NIL;hctx:hctxMenuSearchBookmarks),

      (Level:0;Cmd:cmViewMenu;Bmp:0;Text:SiMenuView;scWS:'';scCUA:'';scDef:'';Hint:SiMenuViewHint;Menu:NIL;Btn:NIL;hctx:hctxMenuView),
        (Level:1;Cmd:cmProjectManager;Bmp:1111;Text:SiMenuProjectManager;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectManagerHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewProjectManager),
        (Level:1;Cmd:cmViewBrowser;Bmp:1111;Text:SiMenuBrowser;scWS:'';scCUA:'';scDef:'';Hint:SiMenuBrowserHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewBrowser),
        (Level:1;Cmd:cmWindowList;Bmp:1014;Text:SiMenuWindowList;scWS:'Alt+0';scCUA:'Alt+0';scDef:'Alt+0';Hint:SiMenuWindowListHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewWindowList),
        (Level:1;Cmd:cmMacroList;Bmp:1111;Text:SiMenuMacroList;scWS:'Ctrl+Shift+M';scCUA:'Ctrl+Shift+M';scDef:'Ctrl+Shift+M';Hint:SiMenuMacroListHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewMacroList),
        (Level:1;Cmd:cmClipBoardList;Bmp:1111;Text:SiMenuClipboardHistory;scWS:'Ctrl+Shift+Ins';scCUA:'Ctrl+Shift+Ins';scDef:'Ctrl+Shift+Ins';Hint:SiMenuClipboardHistoryHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewClipboard),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmViewInspector;Bmp:1016;Text:SiMenuObjectInspector;scWS:'F11';scCUA:'F11';scDef:'F11';Hint:SiMenuObjectInspectorHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewInspector),
        (Level:1;Cmd:cmViewComponents;Bmp:1111;Text:SiMenuComponentList;scWS:'';scCUA:'';scDef:'';Hint:SiMenuComponentListHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewComponentList),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmFormUnit;Bmp:1017;Text:SiMenuSwitchFormUnit;scWS:'F12';scCUA:'F12';scDef:'F12';Hint:SiMenuSwitchFormUnitHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewSwitchFormUnit),
        (Level:1;Cmd:cmNewForm;Bmp:1021;Text:SiMenuNewForm;scWS:'';scCUA:'';scDef:'';Hint:SiMenuNewFormHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewNewForm),
        (Level:1;Cmd:cmImport;Bmp:1054;Text:SiMenuImpSibylDelphiForm;scWS:'';scCUA:'';scDef:'';Hint:SiMenuImpSibylDelphiFormHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewImportForm),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmToolbars;Bmp:1725;Text:SiMenuToolbars;scWS:'';scCUA:'';scDef:'';Hint:SiMenuToolbarsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewToolbars),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmToggleSpeedbar;Bmp:1034;Text:SiMenuSpeedBar;scWS:'';scCUA:'';scDef:'';Hint:SiMenuSpeedBarHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewSpeedbar),
        (Level:1;Cmd:cmToggleNavigator;Bmp:1111;Text:SiMenuComponentPalette;scWS:'';scCUA:'';scDef:'';Hint:SiMenuComponentPaletteHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewComponentPalette),
        (Level:1;Cmd:cmToggleStatusbar;Bmp:1036;Text:SiMenuStatusBar;scWS:'';scCUA:'';scDef:'';Hint:SiMenuStatusBarHint;Menu:NIL;Btn:NIL;hctx:hctxMenuViewStatusbar),

      (Level:0;Cmd:cmComponentMenu;Bmp:0;Text:SiMenuComponent;scWS:'';scCUA:'';scDef:'';Hint:SiMenuComponentHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponent),
        (Level:1;Cmd:cmNewComponent;Bmp:1720;Text:SiMenuComponentNew;scWS:'';scCUA:'';scDef:'';Hint:SiMenuComponentHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentNew),
        (Level:1;Cmd:cmInstallComponents;Bmp:1721;Text:SiMenuComponentInstall;scWS:'';scCUA:'';scDef:'';Hint:SiMenuComponentInstallHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentInstall),
        (Level:1;Cmd:cmRemoveComponents;Bmp:1722;Text:SiMenuComponentRemove;scWS:'';scCUA:'';scDef:'';Hint:SiMenuComponentRemoveHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentRemove),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmOpenCompLib;Bmp:1723;Text:SiMenuOpenLibrary;scWS:'';scCUA:'';scDef:'';Hint:SiMenuOpenLibraryHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentLoadComplib),
        (Level:1;Cmd:cmRecompileCompLib;Bmp:1724;Text:SiMenuRebuildLibrary;scWS:'';scCUA:'';scDef:'';Hint:SiMenuRebuildLibraryHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentRecompileComplib),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmConfigurePalette;Bmp:1111;Text:SiMenuConfigurePalette;scWS:'';scCUA:'';scDef:'';Hint:SiMenuConfigurePaletteHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentConfigurePalette),
        (Level:1;Cmd:cmViewRepository;Bmp:1111;Text:SiMenuConfigureRepository;scWS:'';scCUA:'';scDef:'';Hint:SiMenuConfigureRepositoryHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentConfigureRepository),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmLoadTemplateForms;Bmp:1111;Text:SiMenuImportTemplateForms;scWS:'';scCUA:'';scDef:'';Hint:SiMenuImportTemplateFormsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentImportFormTemplate),
        (Level:1;Cmd:cmSaveTemplateForms;Bmp:1111;Text:SiMenuExportTemplateForms;scWS:'';scCUA:'';scDef:'';Hint:SiMenuExportTemplateFormsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentExportFormTemplate),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmAddToRepository;Bmp:1111;Text:SiMenuAddFormToRepository;scWS:'';scCUA:'';scDef:'';Hint:SiMenuAddFormToRepositoryHint;Menu:NIL;Btn:NIL;hctx:hctxMenuComponentAddFormToRepository),

      (Level:0;Cmd:cmDebugMenu;Bmp:0;Text:SiMenuDebug;scWS:'';scCUA:'';scDef:'';Hint:SiMenuDebugHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebug),
        (Level:1;Cmd:cmToggleBreakPoint;Bmp:2002;Text:SiMenuToggleBreakPoint;scWS:'Ctrl+F8';scCUA:'Ctrl+F8';scDef:'F5';Hint:SiMenuToggleBreakPointHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugToggleBreakpoint),
        (Level:1;Cmd:cmClearAllBreakPoints;Bmp:1727;Text:SiMenuClearAllBreakPoints;scWS:'';scCUA:'';scDef:'';Hint:SiMenuClearAllBreakPointsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugClearBreakpoints),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmGo;Bmp:2009;Text:SiMenuGo;scWS:'Ctrl+Alt+F9';scCUA:'Ctrl+Alt+F9';scDef:'Ctrl+Alt+F9';Hint:SiMenuGoHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugGo),
        (Level:1;Cmd:cmGotoDebugCursor;Bmp:2003;Text:SiMenuGotoCursor;scWS:'F4';scCUA:'F4';scDef:'F4';Hint:SiMenuGotoCursorHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugGotoCursor),
        (Level:1;Cmd:cmStepOver;Bmp:1019;Text:SiMenuStepOver;scWS:'F8';scCUA:'F8';scDef:'F8';Hint:SiMenuStepOverHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugStepOver),
        (Level:1;Cmd:cmStepInto;Bmp:1018;Text:SiMenuTraceInto;scWS:'F7';scCUA:'F7';scDef:'F7';Hint:SiMenuTraceIntoHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugStepInto),
        (Level:1;Cmd:cmReturnFromFunction;Bmp:1039;Text:SiMenuReturnFromFunction;scWS:'Ctrl+F3';scCUA:'Ctrl+F3';scDef:'Ctrl+F3';Hint:SiMenuReturnFromFunctionHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugStepOut),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmProgramReset;Bmp:1008;Text:SiMenuProgramReset;scWS:'Ctrl+F2';scCUA:'Ctrl+F2';scDef:'Ctrl+F2';Hint:SiMenuProgramResetHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugProgramReset),
        (Level:1;Cmd:cmProgramReload;Bmp:1712;Text:SiMenuReloadProgram;scWS:'';scCUA:'';scDef:'';Hint:SiMenuReloadProgramHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugProgramReload),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmEvaluateModify;Bmp:2004;Text:SiMenuEvaluateModify;scWS:'Ctrl+F5';scCUA:'Ctrl+F5';scDef:'Ctrl+F7';Hint:SiMenuEvaluateModifyHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugEvaluateModify),
        (Level:1;Cmd:cmAddWatch;Bmp:2008;Text:SiMenuAddWatch;scWS:'Ctrl+F7';scCUA:'Ctrl+F7';scDef:'Ctrl+F5';Hint:SiMenuAddWatchHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugAddWatch),
        (Level:1;Cmd:cmInspectValue;Bmp:2010;Text:SiMenuInspect;scWS:'';scCUA:'';scDef:'';Hint:SiMenuInspectHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugInspect),
        (Level:1;Cmd:cmWatchpoints;Bmp:2005;Text:SiMenuWatchPoints;scWS:'';scCUA:'';scDef:'';Hint:SiMenuWatchPointsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugWatchPoints),
        (Level:1;Cmd:cmLocalVariables;Bmp:2022;Text:SiMenuLocalVariables;scWS:'';scCUA:'';scDef:'';Hint:SiMenuLocalVariablesHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugLocals),
        (Level:1;Cmd:cmViewWatch;Bmp:2018;Text:SiMenuWatchWindow;scWS:'';scCUA:'';scDef:'';Hint:SiMenuWatchWindowHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugViewWatch),
        (Level:1;Cmd:cmBreakpoints;Bmp:2006;Text:SiMenuBreakPoints;scWS:'';scCUA:'';scDef:'';Hint:SiMenuBreakPointsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugBreakpoints),
        (Level:1;Cmd:cmViewDump;Bmp:2017;Text:SiMenuStorage;scWS:'';scCUA:'';scDef:'';Hint:SiMenuStorageHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugStorage),
        (Level:1;Cmd:cmViewSource;Bmp:2007;Text:SiMenuSourceFiles;scWS:'';scCUA:'';scDef:'';Hint:SiMenuSourceFilesHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugSourceFiles),
        (Level:1;Cmd:cmViewSymbols;Bmp:2011;Text:SiMenuSymbols;scWS:'';scCUA:'';scDef:'';Hint:SiMenuSymbolsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugSymbols),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmViewCPU;Bmp:2012;Text:SiMenuCPUWindow;scWS:'';scCUA:'';scDef:'';Hint:SiMenuCPUWindowHint;Menu:NIL;Btn:NIL;hctx:hctxMenuDebugCPUWindow),

      (Level:0;Cmd:cmProjectMenu;Bmp:0;Text:SiMenuProject;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProject),
        (Level:1;Cmd:cmRun;Bmp:1012;Text:SiMenuRun;scWS:'Ctrl+F9';scCUA:'Ctrl+F9';scDef:'F9';Hint:SiMenuRunHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectRun),
        (Level:1;Cmd:cmRunParameters;Bmp:1713;Text:SiMenuParameters;scWS:'';scCUA:'';scDef:'';Hint:SiMenuParametersHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectParameter),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmCompile;Bmp:1004;Text:SiMenuCompile;scWS:'Ctrl+F10';scCUA:'Ctrl+F10';scDef:'';Hint:SiMenuCompileHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectCompile),
        (Level:1;Cmd:cmMake;Bmp:1010;Text:SiMenuMake;scWS:'F9';scCUA:'F9';scDef:'';Hint:SiMenuMakeHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectMake),
        (Level:1;Cmd:cmBuild;Bmp:1025;Text:SiMenuBuild;scWS:'';scCUA:'';scDef:'';Hint:SiMenuBuildHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectBuild),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmStopCompiler;Bmp:1038;Text:SiMenuBreak;scWS:'Ctrl-Break';scCUA:'Ctrl-Break';scDef:'Ctrl-Break';Hint:SiMenuBreakHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectStopBuild),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmCreateLngFile;Bmp:0;Text:SiMenuCreateLngFile;scWS:'';scCUA:'';scDef:'';Hint:SiMenuCreateLngFileHint;Menu:NIL;Btn:NIL;hctx:hctxMenuCreateLngFile),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmProjectNew;Bmp:1703;Text:SiMenuProjectNew;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectNewHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectNew),
        (Level:1;Cmd:cmProjectLoad;Bmp:1031;Text:SiMenuProjectOpen;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectOpenHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectOpen),
        (Level:1;Cmd:cmProjectClose;Bmp:1704;Text:SiMenuProjectClose;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectCloseHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectClose),
        (Level:1;Cmd:cmProjectSave;Bmp:1032;Text:SiMenuProjectSave;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectSaveHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectSave),
        (Level:1;Cmd:cmProjectSaveAs;Bmp:1033;Text:SiMenuProjectSaveAs;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectSaveAsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectSaveAs),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmSetPrimary;Bmp:1111;Text:SiMenuSetPrimary;scWS:'';scCUA:'';scDef:'';Hint:SiMenuSetPrimaryHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectPrimary),
        (Level:1;Cmd:cmClearPrimary;Bmp:1111;Text:SiClearPrimary;scWS:'';scCUA:'';scDef:'';Hint:SiClearPrimary;Menu:NIL;Btn:NIL;hctx:hctxPopupProjectClearPrimary),
        (Level:1;Cmd:cmProjectSettings;Bmp:1052;Text:SiMenuProjectSettings;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProjectSettingsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuProjectSettings),

      (Level:0;Cmd:cmOptionsMenu;Bmp:0;Text:SiMenuOptions;scWS:'';scCUA:'';scDef:'';Hint:SiMenuOptionsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuOptions),
        (Level:1;Cmd:cmGeneral;Bmp:1111;Text:SiMenuGeneral;scWS:'';scCUA:'';scDef:'';Hint:SiMenuGeneralHint;Menu:NIL;Btn:NIL;hctx:hctxMenuOptionsGeneral),
        (Level:1;Cmd:cmCustomize;Bmp:1111;Text:SiMenuCustomize;scWS:'';scCUA:'';scDef:'';Hint:SiMenuGeneralHint;Menu:NIL;Btn:NIL;hctx:hctxMenuOptionsCustomize),
        (Level:1;Cmd:cmLanguageSettings;Bmp:2000;Text:SiMenuLanguageSettings;scWS:'';scCUA:'';scDef:'';Hint:SiMenuLanguageSettingsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuOptionsLanguageSettings),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmToolOptions;Bmp:1729;Text:SiMenuTools;scWS:'';scCUA:'';scDef:'';Hint:SiMenuToolsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuOptionsTools),

      (Level:0;Cmd:cmWindowMenu;Bmp:0;Text:SiMenuWindow;scWS:'';scCUA:'';scDef:'';Hint:SiMenuWindowHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindow),
        (Level:1;Cmd:cmTile;Bmp:1024;Text:SiMenuTile;scWS:'';scCUA:'';scDef:'';Hint:SiMenuTileHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindowTile),
        (Level:1;Cmd:cmCascade;Bmp:1023;Text:SiMenuCascade;scWS:'';scCUA:'';scDef:'';Hint:SiMenuCascadeHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindowCascade),
        (Level:1;Cmd:cmCloseAll;Bmp:1728;Text:SiMenuCloseAll;scWS:'';scCUA:'';scDef:'';Hint:SiMenuCloseAllHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindowCloseAll),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmMaximizeRestore;Bmp:1741;Text:SiMenuMaximize;scWS:'F5';scCUA:'F5';scDef:'';Hint:SiMenuMaximizeHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindowMaximizeRestore),
        (Level:1;Cmd:cmNext;Bmp:2019;Text:SiMenuNext;scWS:'F6';scCUA:'F6';scDef:'';Hint:SiMenuNextHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindowNext),
        (Level:1;Cmd:cmPrevious;Bmp:2020;Text:SiMenuPrevious;scWS:'Shift+F6';scCUA:'Shift+F6';scDef:'';Hint:SiMenuPreviousHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindowPrevious),
        (Level:1;Cmd:cmCloseTop;Bmp:1740;Text:SiMenuClose;scWS:'Alt+F3';scCUA:'Ctrl+F4';scDef:'Ctrl+F4';Hint:SiMenuCloseHint;Menu:NIL;Btn:NIL;hctx:hctxMenuWindowClose),

      (Level:0;Cmd:cmHelpMenu;Bmp:0;Text:SiMenuHelp;scWS:'';scCUA:'';scDef:'';Hint:SiMenuHelpHint;Menu:NIL;Btn:NIL;hctx:hctxMenuHelp),
        (Level:1;Cmd:cmHelpContents;Bmp:1009;Text:SiMenuContents;scWS:'F1';scCUA:'F1';scDef:'F1';Hint:SiMenuContentsHint;Menu:NIL;Btn:NIL;hctx:hctxMenuHelpContents),
        (Level:1;Cmd:cmHelpIndex;Bmp:2015;Text:SiMenuIndex;scWS:'Shift+F1';scCUA:'Shift+F1';scDef:'Shift+F1';Hint:SiMenuIndexHint;Menu:NIL;Btn:NIL;hctx:hctxMenuHelpIndex),
        (Level:1;Cmd:cmHelpOnHelp;Bmp:1111;Text:SiMenuHelpOnHelp;scWS:'';scCUA:'';scDef:'';Hint:SiMenuHelpOnHelpHint;Menu:NIL;Btn:NIL;hctx:hctxMenuHelpHelpOnHelp),
        (Level:1;Cmd:cmKeysHelp;Bmp:1742;Text:SiMenuKeysHelp;scWS:'';scCUA:'';scDef:'';Hint:SiMenuKeysHelpHint;Menu:NIL;Btn:NIL;hctx:hctxMenuHelpKeyboard),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmTopicSearch;Bmp:2021;Text:SiMenuTopicSearch;scWS:'Ctrl+F1';scCUA:'Ctrl+F1';scDef:'Ctrl+F1';Hint:SiMenuTopicSearchHint;Menu:NIL;Btn:NIL;hctx:hctxMenuHelpContext),
        (Level:1;Cmd:cmNull;Bmp:0;Text:0;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:1;Cmd:cmAbout;Bmp:1111;Text:SiMenuProductInformation;scWS:'';scCUA:'';scDef:'';Hint:SiMenuProductInformationHint;Menu:NIL;Btn:NIL;hctx:hctxMenuHelpAbout),

      (Level:4;Cmd:cmAlignmentMenu;Bmp:0;Text:SiToolbarLayout;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:0),
        (Level:5;Cmd:cmAlign1;Bmp:1341;Text:SiAlign1;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign1),
        (Level:5;Cmd:cmAlign2;Bmp:1342;Text:SiAlign2;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign2),
        (Level:5;Cmd:cmAlign3;Bmp:1343;Text:SiAlign3;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign3),
        (Level:5;Cmd:cmAlign4;Bmp:1344;Text:SiAlign4;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign4),
        (Level:5;Cmd:cmAlign5;Bmp:1345;Text:SiAlign5;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign5),
        (Level:5;Cmd:cmAlign6;Bmp:1346;Text:SiAlign6;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign6),
        (Level:5;Cmd:cmAlign7;Bmp:1347;Text:SiAlign7;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign7),
        (Level:5;Cmd:cmAlign8;Bmp:1348;Text:SiAlign8;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign8),
        (Level:5;Cmd:cmAlign9;Bmp:1349;Text:SiAlign9;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign9),
        (Level:5;Cmd:cmAlign10;Bmp:1350;Text:SiAlign10;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign10),
        (Level:5;Cmd:cmAlign11;Bmp:1351;Text:SiAlign11;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign11),
        (Level:5;Cmd:cmAlign12;Bmp:1352;Text:SiAlign12;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign12),
        (Level:5;Cmd:cmAlign13;Bmp:1353;Text:SiAlign13;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign13),
        (Level:5;Cmd:cmAlign14;Bmp:1354;Text:SiAlign14;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupAlign14),
        (Level:5;Cmd:cmForceAlign;Bmp:1355;Text:SiForceAlign;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupForceAlign),
        (Level:5;Cmd:cmRefresh;Bmp:1356;Text:SiRefresh;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupRefreshForm),
        (Level:5;Cmd:cmDelCtrl;Bmp:1357;Text:SiDeleteCtrl;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupDeleteComponent),
        (Level:5;Cmd:cmGridVis;Bmp:1358;Text:SiGridVisible;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupGridVisible),
        (Level:5;Cmd:cmSnapToGrid;Bmp:1359;Text:SiSnapToGrid;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupSnapToGrid),
        (Level:5;Cmd:cmDesignPos;Bmp:0;Text:SiFocusLastForm;scWS:'';scCUA:'';scDef:'';Hint:0;Menu:NIL;Btn:NIL;hctx:hctxPopupSnapToGrid)
      );
           

const NormalChars : Set Of Char = ['0'..'9','A'..'Z','a'..'z','_', '','','”','','','','แ'];

const LanguageShortAnz = 2;
      LanguageShort : Array[0..LanguageShortAnz-1] of tStr2 =
           (('DE'),('EN'));

VAR ActiveProjectPage:INTEGER;
    ActiveGeneralPage:INTEGER;
    ActiveCustomizePage:INTEGER;
    CodeEditorRef:TForm;
    DAsmInsideIDE:BOOLEAN;

    CompilerSPC : tcCompiler;
    CompilerRES : tcCompiler;
    CompilerHLP : tcCompiler;

    CreatePipe   : Boolean;

// Pointer fuer Funktionen und Prozeduren
CONST
  InitCodeEditorProc: POINTER = NIL;
  InitInspectorProc: POINTER = NIL;
  InitCompListProc: POINTER = NIL;
  InitWindowListProc: POINTER = NIL;
  InitBrowserProc: POINTER = NIL;
  InitMacroListProc: POINTER = NIL;
  InitClipboardListProc: POINTER = NIL;
  InitCPUWindowProc: POINTER = NIL;
  InitProjectManagerProc: POINTER = NIL;

IMPLEMENTATION

FUNCTION CommandToIndex(Command:TCommand):INTEGER;
VAR  i:INTEGER;
BEGIN
  Result := -1;
  FOR i := 1 TO MaxMenuEntries DO
    IF MenuEntries[i].Cmd = Command THEN
      BEGIN
        Result := i;
        exit;
      END;
END;

BEGIN
  ActiveProjectPage := 0;
  ActiveGeneralPage := 0;
  ActiveCustomizePage := 0;
  DAsmInsideIDE := FALSE;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  09-Dec-02  WD         Einbau vom Logging
  01-Aug-03  WD         Entfernen von div. CM-Konstanten (wird schon in Message.pas verw.)
  01-Aug-03  WD         Menue: CreateLngFile eingebaut
  03-Aug-03  WD         Entfernen des TipOfTheDay-Dialog
  08-Aug-03  WD         Ausbau der Variable ShowSibylFormProc
  13-Jan-05  WD         Konstante "NormalChars" von Editors.pas eingebaut
  11-Mar-05  WD         WDSibyl-Help-Bitmap eingebaut
  25-Mar-05  WD         Resource-Bitmap eingebaut
  15-Okt-05  WD         Umbau fuer Win32-IDE
  22-Dez-05  WD         Uebernehmen der Init-Variablen (fuer die Adresse der Funktionen
  10-Jan-06  WD         Diverse Funktionen in die WDSibyl-DLL bertragen
  24-Feb-06  WD         Im Menue Projekt/Anhalten "Ctrl Break" eingebaut.
  11-Apt-08  WD         Menue: von "Alt+BkSp" auf "Ctrl+BkSp" und von "Shift+Ctrl+BkSp" auf
                        "Shift+Ctrl+BkSp" geaendert
  12-Mar-09  WD         Verwendung der neuen tcNamedPipeServer-Klasse

}
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

UNIT Sib_Edit;

INTERFACE

{$IFDEF OS2}
USES Os2Def,PmWin,PmGpi,BseDos, BseErr;
{$ENDIF}

{$IFDEF WIN32}
USES WinDef,WinNT,WinUser;
{$ENDIF}

USES Dos, SysUtils,Color,Classes,Forms,Buttons,StdCtrls,ExtCtrls,Editors,
     TabCtrls,Printers,DockTool,Grids,
     SPC_Data,Consts,Projects,Sib_Prj,Dialogs,ParseObj,Sib_Ctrl,BaseForm,
     BaseEdit,WinList,DebugHlp,DAsm,DbgWatch,DisAsm,
     Menus, Messages, Graphics, clipbrd,
     uSysInfo, uSysClass,
     uString, uList,
     uHlpTopics;

{ AddUtils, }

CONST
     kbCtrlOA        = kbPreCtrlO + kb_Char + 97;
     kbCtrlOG        = kbPreCtrlO + kb_Char + 103;
     kbCtrlOO        = kbPreCtrlO + kb_Char + 111;
     kbCtrlBracket1  = kb_Ctrl + kb_Shift + kb_Char + 40;       // ()
     kbCtrlBracket2  = kb_Ctrl + kb_Char + 91;                  // []
     kbCtrlBracket3  = kb_Ctrl + kb_Char + 123;                 // {}
     kbCtrlBracket4  = kb_Ctrl + kb_Shift + kb_Char + 42;       // (**)
     kbCtrlBracket5  = kb_Ctrl + kb_Shift + kb_Char + 47;       // /**/
     kbCtrlBracket6  = kb_Ctrl + kb_Char + 92;                  // Zeichen: \ --> //
     kbCtrlShiftTab  = kb_Ctrl + kb_Shift + kbBackTab;
     kbCtrlShiftIns  = kb_Ctrl + kb_Shift + kbIns;
     kbCtrlShiftA    = kb_Ctrl + kb_Shift + kb_Char + 65;
     kbCtrlShiftJ    = kb_Ctrl + kb_Shift + kb_Char + 74;
     kbCtrlShiftM    = kb_Ctrl + kb_Shift + kb_Char + 77;
     kbCtrlAltF9     = kb_Ctrl + kb_Alt + kbF9;

CONST
     BuildIndex=0;
     FindInFilesIndex=1;
     DebugIndex=2;
     LocalsIndex=3;
     SelfIndex=4;
     WatchIndex=5;
     CallStackIndex=6;
     BreakpointsIndex=7;
     StorageIndex=8;


CONST
    _ASM_            = 1;
    _BEGIN_          = 2;
    _CLASS_          = 3;
    _CONST_          = 4;
    _CONSTRUCTOR_    = 5;
    _DESTRUCTOR_     = 6;
    _DO_             = 7;
    _END_            = 8;
    _EXPORTS_        = 9;
    _FOR_            = 10;
    _FUNCTION_       = 11;
    _IMPLEMENTATION_ = 12;
    _INHERITED_      = 13;
    _INITIALIZATION_ = 14;
    _INTERFACE_      = 15;
    _LIBRARY_        = 16;
    _OVERRIDE_       = 17;
    _PRIVATE_        = 18;
    _PROCEDURE_      = 19;
    _PROGRAM_        = 20;
    _PROTECTED_      = 21;
    _PUBLIC_         = 22;
    _PUBLISHED_      = 23;
    _TO_             = 24;
    _TYPE_           = 25;
    _UNIT_           = 26;
    _USES_           = 27;
    _VAR_            = 28;

    Bezeichner:ARRAY[_ASM_.._VAR_] OF STRING = (
       'asm',
       'begin',
       'class',
       'const',
       'constructor',
       'destructor',
       'do',
       'end',
       'exports',
       'for',
       'function',
       'implementation',
       'inherited',
       'initialization',
       'interface',
       'library',
       'override',
       'private',
       'procedure',
       'program',
       'protected',
       'public',
       'published',
       'to',
       'type',
       'unit',
       'uses',
       'var');


    StatusItemCount=6;

    VDETerminating:BOOLEAN=FALSE;

    LoadAsISOLatin1:BOOLEAN=FALSE;

CONST
     IdentifierChars : SET OF Char =
         ['0'..'9','A'..'Z','a'..'z','_'];
     QualifiedIdentifierChars : SET OF Char =
         ['0'..'9','A'..'Z','a'..'z','_','^','.'];

TYPE
    TSibEditor=Class;

    TCodeInsightBubble=Class(THintWindow)
      Private
         FParameterNo:Integer;
         FParameterCount:Integer;
         FWordWith:Array[1..16] Of Integer;
         FParameterHeight:Integer;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure SetCodeParameter(Const NewCaption:STRING;Count,No:Integer);
         Procedure GetCaptionExtent(Var cx,cy:Longint);
    End;


    TCodeCompletionListBox=Class(TControl)
      PRIVATE
         FEditor:TSibEditor;
         FListBox:TListBox;
         FMaxWidth:LONGINT;
         FUNCTION GetItems:TStrings;
         FUNCTION GetItemIndex:Longint;
         PROCEDURE SetItemIndex(Value:Longint);
         FUNCTION GetItemHeight:Longint;
         PROCEDURE SetItemHeight(Value:Longint);
         PROCEDURE EvDrawItem(Sender:TObject;Index:LONGINT;Rec:TRect;State:TOwnerDrawState);
         PROCEDURE EvCharEvent(Sender:TObject;VAR Key:CHAR);
         PROCEDURE EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
      PUBLIC
         PROPERTY Items:TStrings read GetItems;
         PROPERTY ItemIndex:Longint read GetItemIndex write SetItemIndex;
         PROPERTY ItemHeight:Longint read GetItemHeight write SetItemHeight;
    End;


    TSibEditorStatusbar=CLASS(TToolBar)
      PROTECTED
         Feld:ARRAY[1..StatusItemCount] OF TControl;
         ItemWidth:ARRAY[1..StatusItemCount] OF LONGINT;
         OldItemWidth1:LONGINT;
         BottomScrollBar:TScrollBar;
         SysScrollHeight:LONGINT;
         SysScrollWidth:LONGINT;
      PROTECTED
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);OVERRIDE;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE SetText(i:BYTE; CONST s:STRING; fgColor:TColor);Virtual;
         PROCEDURE EvToggleState(Sender:TObject;Button:TMouseButton;
                                 ShiftState:TShiftState;X,Y:LONGINT);
    END;


    TFileType=(ftAny,ftPAS,ftRC,ftSHS);

    TExtraOpt=SET OF (eoSyntaxHigh,eoAutoBracket,eoAddIndentMode,
      eoConvertISOLatin1);


    TSibEditor=CLASS(TBaseEditor)
      PRIVATE
         LastMousePos:TPoint;
         WatchTimer:TTimer;
         CodeParameterTimer:TTimer;
         CodeParameterBubble:TCodeInsightBubble;
         CodeCompletionTimer:TTimer;
         CodeCompletionListBox:TCodeCompletionListBox;
         WatchBubble:TCodeInsightBubble;
         FIgnoreFileNameUpdate:BOOLEAN;
         fFileDateTime : LongInt;
         fFileSize     : LongInt;    // Eine PAS-Datei wird sicherlich nicht groesser 2Gb sein.

         PROCEDURE EvWatchTimer(Sender:TObject);
         PROCEDURE EvCodeParameterTimer(Sender:TObject);
         PROCEDURE EvCodeCompletionTimer(Sender:TObject);
         PROCEDURE CloseCodeCompletion(VAR Msg:TMessage); message cmCloseCodeCompletion;
         PROCEDURE EvClose(Sender:TObject; VAR Action:TCloseAction);
      PROTECTED
         StatusBar:TSibEditorStatusbar;
         FExtraOpt:TExtraOpt;
         NeedResize:BOOLEAN;
         AltNumber:LONGINT;
         ClosingItem:CHAR;

         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE TranslateShortCut(Keycode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
         PROCEDURE CharEvent(VAR Key:CHAR;RepeatCount:BYTE);OVERRIDE;
         PROCEDURE ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
         FUNCTION  QueryConvertPos(VAR pos:TPoint):BOOLEAN;OVERRIDE;
         PROCEDURE StartCodeCompletionTimer;
         PROCEDURE StopCodeCompletionTimer;
         PROCEDURE CompleteCode(Code:String);
         PROCEDURE StartCodeParameterTimer;
         PROCEDURE StopCodeParameterTimer;
         PROCEDURE UpdateCodeParameterBubble;
         PROCEDURE StartWatchTimer;
         PROCEDURE StopWatchTimer;
         PROCEDURE MouseMove(ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);OVERRIDE;
         PROCEDURE FontChange;OVERRIDE;
         FUNCTION  FindTheText(CONST find:STRING; direct:TFindDirection;
                   origin:TFindOrigin; scope:TFindScope;opt:TFindOptions):BOOLEAN;
         FUNCTION  ReplaceTheText(CONST find,replace:STRING;direct:TFindDirection;
                   origin:TFindOrigin;scope:TFindScope; opt:TFindOptions;
                   confirm:BOOLEAN;replaceall:BOOLEAN):BOOLEAN;
         PROCEDURE cmEnter;OVERRIDE;
         PROCEDURE cmRecordMacro;OVERRIDE;
         PROCEDURE cmPlayMacro;OVERRIDE;
         PROCEDURE cmICBReadBlock;OVERRIDE;
         PROCEDURE cmICBWriteBlock;OVERRIDE;
         PROCEDURE cmFindText;OVERRIDE;
         PROCEDURE cmReplaceText;OVERRIDE;
         PROCEDURE cmSearchTextAgain;OVERRIDE;
         PROCEDURE cmICBUpcaseHIL;
         PROCEDURE cmICBDowncaseHIL;
         PROCEDURE cmLoadUnit;
         PROCEDURE cmFindMatchingBrace;
         PROCEDURE OpenContextMenuAtCursor;
         FUNCTION  GetFileAtCursorName:STRING;
         FUNCTION  UpdateLineColorFlag(pl:PLine):BOOLEAN;OVERRIDE;
         PROCEDURE SetLineColorFlag(pl1,pl2:PLine);OVERRIDE;
         PROCEDURE CalcLineColor(pl:PLine;VAR LineColor:TColorArray;Var LineAtt : tAttributeArray);OVERRIDE;
         PROCEDURE CalcHelpColor(pl:PLine;VAR LineColor:TColorArray);
         PROCEDURE UpdateEditorState;OVERRIDE;
         PROCEDURE SetStateMessage(CONST s:STRING);OVERRIDE;
         PROCEDURE SetErrorMessage(CONST s:STRING);OVERRIDE;
         FUNCTION  CloseQuery:BOOLEAN;OVERRIDE;
         FUNCTION  GetReadOnly:BOOLEAN;OVERRIDE;
         PROCEDURE SetReadOnly(Value:BOOLEAN);OVERRIDE;
         PROCEDURE SetModified(Value:BOOLEAN);OVERRIDE;
         Procedure SetAvailabeFileTypes(CFOD:{$ifdef os2}TOpenDialog{$endif}
                                             {$ifdef win32}TSystemOpenSaveDialog{$endif});override;
         PROCEDURE SetFileName(CONST FName:STRING);OVERRIDE;
         PROCEDURE SetFocus;OVERRIDE;
         Procedure ChgSelectMode;

         FUNCTION  EmulateWordStar(VAR KeyCode,PreControl:TKeyCode):BOOLEAN;OVERRIDE;
         FUNCTION  EmulateCUA(VAR KeyCode,PreControl:TKeyCode):BOOLEAN;OVERRIDE;
         FUNCTION  EmulateDefault(VAR KeyCode,PreControl:TKeyCode):BOOLEAN;OVERRIDE;
         PROCEDURE InsertCompileOpt;
         FUNCTION  SaveToFile(CONST FName:STRING):BOOLEAN;OVERRIDE;
         FUNCTION  TestSaveAsName(CONST FName:STRING):TMsgDlgReturn;OVERRIDE;
         PROCEDURE FileNameChange(CONST OldName,NewName:STRING);OVERRIDE;
         PROCEDURE DoStartDrag(VAR DragData:TDragDropData);OVERRIDE;
         PROCEDURE DoEndDrag(Target:TObject; X,Y:LONGINT);OVERRIDE;
         PROCEDURE DragOver(Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);OVERRIDE;
         PROCEDURE DragDrop(Source:TObject;X,Y:LONGINT);OVERRIDE;
      PUBLIC
         PROCEDURE GenerateProgramFrame(CONST ProgName,FormName:STRING);
         PROCEDURE GenerateUnitFrame(CONST UnitName:STRING);
         FUNCTION  Insert_Uses(CONST UnitName:STRING):LONGINT;
         FUNCTION  Insert_Class(y:LONGINT;Component:TComponent):LONGINT;
         FUNCTION  Insert_RegisterClasses(CONST comptype:STRING):LONGINT;
         FUNCTION  Insert_Component(CONST classtype:STRING;Component:TComponent):LONGINT;
         FUNCTION  Insert_Method(CONST classtype:STRING;methodname:STRING;AddLines:TStringList):TEditorPos;
         FUNCTION  RemoveRemarks(pl:PLine):STRING;
         FUNCTION  Search_Class(CONST classtype:STRING;VAR frmt,cls:TEditorPos):BOOLEAN;
         FUNCTION  Search_Var(CONST varname,vartype:STRING;VAR frm,frmt,smc:TEditorPos):BOOLEAN;
         FUNCTION  Search_Method(von:TEditorPos;classtype:STRING;VAR prc,frmt:TEditorPos):BOOLEAN;
         FUNCTION  Search_Implementation:LONGINT;
         FUNCTION  Goto_Method(CONST classname,methodname:STRING):BOOLEAN;
         FUNCTION  Rename_Unit(CONST newname:STRING):BOOLEAN;
         FUNCTION  Rename_Uses(CONST oldname,newname:STRING):BOOLEAN;
         FUNCTION  Rename_Class(CONST oldclassname,newclassname:STRING;ignoreMain:BOOLEAN):BOOLEAN;
         FUNCTION  Rename_RegisterClasses(CONST oldcomptype,newcomptype:STRING):BOOLEAN;
         FUNCTION  Rename_Component(CONST classtype:STRING;Component:TComponent;CONST NewCompName:STRING):BOOLEAN;
         FUNCTION  Rename_Method(CONST classtype,oldmethodname:STRING;newmethodname:STRING):BOOLEAN;
         FUNCTION  Rename_MainForm(CONST FormName:STRING):BOOLEAN;
         FUNCTION  Rename_Resource(CONST newname:STRING):BOOLEAN;
         FUNCTION  Remove_Class(CompClass:TComponent):BOOLEAN;
         FUNCTION  RemoveDummy(dummy:STRING):BOOLEAN;
         FUNCTION  Remove_Dummies:BOOLEAN;
         FUNCTION  Remove_RegisterClasses(Component:TComponent):BOOLEAN;
         FUNCTION  Remove_Component(CONST classtype:STRING;Component:TComponent):BOOLEAN;
         PROCEDURE Update_DFM(AForm:TForm);
         FUNCTION  GeneralSearch(von,bis:TEditorPos; SList:TList):BOOLEAN;
         FUNCTION  ParseCLASSDefinition(CONST classtype:STRING):BOOLEAN;
         FUNCTION  GetCurrentMethodClassName(von:TEditorPos):STRING;
         PROCEDURE ReplaceCodeTemplate;       // Code mittels CodeInsight ersetzen
         procedure ReOpenFile;
      PUBLIC
         ErrLine   : PLine;
         FileType  : TFileType;
         SPUInvalid: BOOLEAN;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE Init;
         PROCEDURE SetWindowPos(NewX,NewY,NewWidth,NewHeight:LONGINT);OVERRIDE;
         PROCEDURE ToTop;OVERRIDE;
         PROCEDURE UpdateColorTable;
         PROCEDURE SetFileType;
         FUNCTION  LoadFromFile(CONST FName:STRING):BOOLEAN;OVERRIDE;
         PROCEDURE SetIncSearchText(s:STRING);OVERRIDE;
         PROCEDURE SetErrorLine(y,x:LONGINT;errStr:STRING;errTyp:BYTE);
         PROCEDURE ResetErrorLine;
         FUNCTION  InsertBrackets(CONST s1,s2:STRING):INTEGER;
         Procedure CBCommentBlock;
         PROCEDURE CutToClipBoard;OVERRIDE;
         PROCEDURE CopyToClipBoard;OVERRIDE;
         PROCEDURE cmIncrementalSearch;OVERRIDE;
         PROCEDURE InvalidateEditor(y1,y2:INTEGER);OVERRIDE;
         PROCEDURE EditorToTop;
         PROCEDURE Print(Selection,Syntax,Comment:BOOLEAN);

         PROPERTY MacroList;
         PROPERTY MacroRecording;
         PROPERTY MacroPlaying;
         PROPERTY Indices;
         PROPERTY PLines;
         Property FileDateTime: LongInt Read fFileDateTime Write fFileDateTime;
         Property FileSize    : LongInt Read fFileSize     Write fFileSize;

    END;


    TCodeEditor=CLASS(TSibylForm)
      PUBLIC
         NonameCount       : WORD;
         MDIBehaviour      : BOOLEAN;
         TopTool           : TToolbar;
         TabSet            : TTabSet;
         EditorPopup       : TPopupMenu;
         OpenFileEntry     : TMenuItem;
         TopicEntry        : TMenuItem;
         CompileFileEntry  : TMenuItem;
         MakeFileEntry     : TMenuItem;
         BreakPointEntry   : TMenuItem;
         RunCursorEntry    : TMenuItem;
         EvalModEntry      : TMenuItem;
         AddWatchEntry     : TMenuItem;
         ReadOnlyEntry     : TMenuItem;
         ControlCentreEntry: TMenuItem;
         CutEntry          : tMenuItem;
         CopyEntry         : tMenuItem;
         PasteEntry        : tMenuItem;
         DeleteEntry       : tMenuItem;
         ReOpenFileEntry   : tMenuItem;

         AltEditor         : ARRAY[1..9] OF TSibEditor;
         MacroList         : TList;
         LastErrorMsgEditor: TSibEditor;
         LastErrorType     : LONGINT;
         FirstErrorIndex   : LONGINT;
         CompilerTerminate : BOOLEAN;
         Statusbar         : TToolbar;
         GlobalFontChange  : BOOLEAN;
      PRIVATE
         FUNCTION GetTopEditor:TSibEditor;
         FUNCTION GetMessages:TStringList;
         FUNCTION TabSetIndex(Edit:TSibEditor):LONGINT;
         PROCEDURE EvControlCentreDocking(Sender:TObject;VAR TargetForm:TForm;VAR NewAlign:TToolbarAlign);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE CreateWnd;OVERRIDE;
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE SetFocus;OVERRIDE;
         PROCEDURE DragOver(Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);OVERRIDE;
         PROCEDURE DragDrop(Source:TObject;X,Y:LONGINT);OVERRIDE;
      PUBLIC
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE Init;
         PROCEDURE Close;OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE Tile;OVERRIDE;
         PROCEDURE Cascade;OVERRIDE;
         PROCEDURE CloseAll;OVERRIDE;
         PROCEDURE SetMDIMode(mdi:BOOLEAN);
         PROCEDURE InsertTabSet;
         PROCEDURE RemoveTabSet;
         PROCEDURE EvPageActivated(Sender:TObject);
         PROCEDURE EvTabFontChanged(Sender:TObject);
         FUNCTION  GetFreeAltNumber(Edit:TSibEditor):LONGINT;
         PROCEDURE ActivateEditor(idx:LONGINT);
         PROCEDURE ShowControlCentre(PageIndex:LONGINT;FokusPage:BOOLEAN);
         PROCEDURE HideControlCentre;
         FUNCTION  AddMessage(CONST s:STRING):LONGINT;
         FUNCTION  UpdateLastMessage(CONST s:STRING):LONGINT;
         PROCEDURE EvMsgWindowExit(Sender:TObject);
         PROCEDURE EvMsgFocused(Sender:TObject;Index:LONGINT);
         PROCEDURE EvMsgSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE EvMsgScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
         PROCEDURE EvFindFileSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE EvCompileThreadEnded(Sender:TObject);
         PROCEDURE OpenMsgWindow(VAR Msg:TMessage); message cmOpenMsgWindow;
         PROCEDURE InsertStatusbar;
         PROCEDURE RemoveStatusbar;
         PROCEDURE ShowContextMenu(Editor:TSibEditor;X,Y:LONGINT);
         PROCEDURE AddGlobalMacro;
         PROCEDURE DebugTrace(CONST s:STRING);
      PUBLIC
         PROCEDURE Redraw(CONST rec:TRect);OVERRIDE;
         PROPERTY TopEditor:TSibEditor read GetTopEditor;
         PROPERTY Messages:TStringList read GetMessages;
    END;


PROCEDURE SetCompilerStatusMessage(CONST StatusMsg,ErrorFile:CSTRING;
              ErrorType:LONGINT; ErrorLine,ErrorColumn:LONGINT); CDECL;

PROCEDURE InitCodeEditor;
PROCEDURE ClearBuildList;
PROCEDURE ClearDebugList;
PROCEDURE ClearFindInFilesList;
PROCEDURE WriteToFindInFilesList(CONST s:STRING;p:INTEGER);
FUNCTION CanSwitchDockingState:BOOLEAN;
PROCEDURE ActivateCodeEditor(Editor:TSibEditor);
FUNCTION LoadEditor(Name:STRING;x,y,w,h:LONGINT;LiX:BOOLEAN;fcx:TEditorPos;
                     Fokus:BOOLEAN;ShowIt:BOOLEAN):TSibEditor;
FUNCTION GetEditor(Name:STRING):TSibEditor;
PROCEDURE InitializeEditor(Edit:TSibEditor);
PROCEDURE GotoLastError;
FUNCTION Key(idx:BYTE):STRING;
FUNCTION EditorFont:TFont;
FUNCTION SetProjectMainForm(NewMainForm:STRING;showerror:BOOLEAN):BOOLEAN;
FUNCTION IsValidIdentifier(s:STRING):BOOLEAN;
PROCEDURE UpdateIconbars(IconbarVisible:BOOLEAN);


CONST GotoLineDialogProc:PROCEDURE=NIL;
      ForceCompileProc:PROCEDURE(Action:TCompilerActions;FileName:STRING)=NIL;
      StopCompilerProc:PROCEDURE=NIL;
      GetBrowserInfoProc:FUNCTION(Qualifier,Identifier:String; FindMethods:BOOLEAN;
             Var ParameterList:TStringList):BOOLEAN = NIL;

      ControlCentre:TDockingPalette=NIL;

VAR IndentBlock:STRING;  {Begin}
    IndentScope:STRING;  {private}
    IndentField:STRING;  {button1}
    IndentSpace:STRING;  {bei Parameterlisten}
    LineBreak:LONGINT;
    CodeEditor:TCodeEditor;
    LastFindAction:TFindAction;


IMPLEMENTATION

Uses uWDSibylThrd;

{$b+}  {Complete Boolean Evaluation}

TYPE
    TSearchFlag=SET OF (sfNone,sfOptional,sfSeparated);
    PSearchStruct=^TSearchStruct;
    TSearchStruct=RECORD
                        name:STRING;
                        flags:TSearchFlag;
                        nextItem:INTEGER; {FolgePosition fr nonexisting Optional}
                        found:BOOLEAN;
                        retpos:TEditorPos;
    END;


    PErrorItem=^TErrorItem;
    TErrorItem=RECORD
         pErrorFile:PSTRING;
         pErrorText:PSTRING;
         ErrorType:BYTE;
         ErrorLine:LONGINT;
         ErrorColumn:LONGINT;
         ErrorPLine:PLine;
    END;


VAR
    UpcaseTable:STRING;
    ShowEditorErrorMsg:BOOLEAN;

function GetCodePage: Integer;
var
  Buffer: array[0..2] of LongWord;
  Length: LongWord;
begin
  {$IFDEF OS2}
  if DosQueryCP(SizeOf(Buffer), Buffer[0], Length) = NO_ERROR then
    Result := Buffer[0]
  else
    Result := 0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=0;
  {$ENDIF}
end;

{$H+}
function Translate(const S: string; OldCodePage, NewCodePage: Integer): string;
var
  Success: Boolean;
  {$IFDEF OS2}
  I: Integer;
  {$ENDIF}
begin
  {$IFDEF OS2}
  Result := S;
  UniqueStr(Result);
  Success := WinCPTranslateString(AppHandle,
                                  OldCodePage,
                                  PChar(S)^,
                                  NewCodePage,
                                  Length(Result) + 1,
                                  PChar(Result)^);
  if not Success then
  begin
    Result := '';
    Exit;
  end;

  for I := 1 to Length(Result) do
    if Result[I] = #255 then Result[I] := S[I];
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=S;
  {$ENDIF}
end;
{$H-}


PROCEDURE InitCodeEditor;
BEGIN
//  Application.LogWriteln('InitCodeEditor');
  IF CodeEditor = NIL THEN
    BEGIN
       CodeEditor.Create(NIL);
       CodeEditor.Icon:=EditIcon;
       CodeEditorRef := CodeEditor;
       CodeEditor.CreateWnd;
    END
  ELSE
    BEGIN
       IF CodeEditor.WindowState = wsMinimized
         THEN CodeEditor.WindowState := wsNormal;
    END;
  CodeEditor.Init;
  //CodeEditor.Show;
  CodeEditor.BringToFront;
  CodeEditor.Update;
//  Application.LogWriteln('InitCodeEditor: Ende');
END;


PROCEDURE ActivateCodeEditor(Editor:TSibEditor);
BEGIN
  IF CodeEditor <> NIL THEN
    IF CodeEditor.WindowState = wsMinimized
    THEN CodeEditor.WindowState := wsNormal;

  IF Editor <> NIL THEN Editor.Focus;
END;


PROCEDURE SetCompilerStatusMessage(CONST StatusMsg,ErrorFile:CSTRING;
              ErrorType:LONGINT; ErrorLine,ErrorColumn:LONGINT); CDECL;

VAR  s       : STRING;
     ErrorMsg: STRING;
     FN      : tFilename;
     Item    : PErrorItem;
     idx     : LONGINT;
     Edit    : TSibEditor;
     newline : BOOLEAN;

BEGIN
  if StatusMsg='' then exit;

//  Application.LogWriteln('SetCompilerStatusMessage');
  IF VDETerminating THEN exit;

  IF StatusMsg = LoadNLSStr(SiERR_USER_BREAK) THEN ErrorType := errNone;

  newline := CodeEditor.LastErrorType <> errLineNumber;
  CodeEditor.LastErrorType := ErrorType;

  CASE ErrorType OF
    errNone:       s := StatusMsg;
    errWarning:    s := LoadNLSStr(SiWarningAt)+' [';
    errError:      s := LoadNLSStr(SiErrorAt)+' [';
    errFatalError: s := LoadNLSStr(SiFatalErrorAt)+' [';
  END;

  CASE ErrorType OF
    errWarning,errError,errFatalError:
      BEGIN
//        FSplit(ErrorFile,d,n,e);
        FN:=ExtractFileName(ErrorFile);

        ErrorMsg := '"' + StatusMsg + '"';
        s := s + tostr(ErrorLine) + ',' + tostr(ErrorColumn) +
                 '] ' + FN + '  ' + ErrorMsg;
        New(Item);
        GetMem(Item^.pErrorFile, Length(ErrorFile)+1);
        Item^.pErrorFile^ := ErrorFile;
        GetMem(Item^.pErrorText, Length(ErrorMsg)+1);
        Item^.pErrorText^ := ErrorMsg;
        Item^.ErrorType := ErrorType;
        Item^.ErrorLine := ErrorLine;
        Item^.ErrorColumn := ErrorColumn;
        {merke die PLine der Zeile}
        Edit := GetEditor(ErrorFile);
        IF Edit = NIL
          THEN Item^.ErrorPLine := NIL
          ELSE Item^.ErrorPLine := Edit.PLines[Item^.ErrorLine];
      END;
    errLineNumber:
      BEGIN
//        FSplit(ErrorFile,d,n,e);
        FN:=ExtractFileName(ErrorFile);
        s := FN + ' (' + tostr(ErrorLine) + ')';
        Item := NIL;
      END;
    ELSE
      BEGIN
        s := StatusMsg;
        Item := NIL;
      END;
  END;

//  Application.LogWriteln('SetCompilerStatusMessage: ' +s);
  IF newline
    THEN idx := CodeEditor.AddMessage(s)
    ELSE idx := CodeEditor.UpdateLastMessage(s);

  IF (idx < 0) OR (idx >= CodeEditor.Messages.Count) THEN
    BEGIN
      IF Item <> NIL THEN
        BEGIN
          FreeMem(Item^.pErrorFile, Length(Item^.pErrorFile^)+1);
          FreeMem(Item^.pErrorText, Length(Item^.pErrorText^)+1);
          Dispose(Item);
        END;
      exit;
    END;

  CodeEditor.Messages.Objects[idx] := TObject(Item);

  IF ErrorType = errError THEN
    IF CodeEditor.FirstErrorIndex < 0 THEN
      BEGIN {merke Index des 1. normalen Errors}
        CodeEditor.FirstErrorIndex := idx;
      END;

  IF ErrorType = errFatalError THEN
    BEGIN {open the Msg Window and focus the Message}
      SendMsg(CodeEditor.Handle,cmOpenMsgWindow,idx,0);
    END;
END;


PROCEDURE PlayEditorMacro(MList:TList);
VAR  i:LONGINT;
BEGIN
     IF CodeEditor.MacroList = NIL THEN CodeEditor.MacroList.Create
     ELSE CodeEditor.MacroList.Clear;

     IF MList <> NIL THEN
     FOR i := 0 TO MList.Count-1
        DO CodeEditor.MacroList.Add(MList.Items[i]);

     IF CodeEditor.TopEditor <> NIL THEN
     BEGIN
          CodeEditor.TopEditor.Focus;
          CodeEditor.TopEditor.cmPlayMacro;
     END;
END;


PROCEDURE PasteClipBoard(pc:PClipBoardStruct);
VAR  TopEdit:TSibEditor;
     Clip:POINTER;
BEGIN
     TopEdit := CodeEditor.TopEditor;
     IF TopEdit = NIL THEN exit;

     IF Clipboard.Open(TopEdit.Handle) THEN
     BEGIN
          TRY
             GetSharedMem(Clip,pc^.Len);
          EXCEPT
             Clip := NIL;
          END;
          IF Clip = NIL THEN
          BEGIN
               Clipboard.Close;
               exit;
          END;
          Move(pc^.p^, Clip^, pc^.Len);
          Clipboard.Empty;
          Clipboard.SetData(LONGWORD(Clip),cfTEXT);
          Clipboard.Close;
     END
     ELSE exit;

     TopEdit.PasteFromClipBoard;
     TopEdit.Focus;
END;


FUNCTION TestProjectBookMark(Editor:TEditor;row:LONGINT):BOOLEAN;
VAR  i,y:LONGINT;
     s:STRING;
BEGIN
     Result := FALSE;
     IF Project.BookmarkList.Count = 0 THEN exit;

     s := Upcased(Editor.FileName);
     FOR i := 0 TO Project.BookmarkList.Count-1 DO
     BEGIN
          y := LONGINT(Project.BookmarkList.Objects[i]);
          IF y <> row THEN continue;
          IF s <> Upcased(GetLongHint(Project.BookmarkList.Strings[i]))
          THEN continue;

          Result := TRUE;
          exit;
     END;
END;


PROCEDURE UpdateIconbars(IconbarVisible:BOOLEAN);
VAR  Edit:TBaseEditor;
     i:LONGINT;
     ibs:LONGINT;
BEGIN
     IF IconbarVisible THEN ibs := 2 * IconWidth
     ELSE ibs := 0;

     FOR i := 0 TO CodeEditor.MDIChildCount-1 DO
     BEGIN
          Edit := TSibEditor(CodeEditor.MDIChildren[i]);
          IF Edit IS TBaseEditor THEN
            IF Edit.Iconbar <> NIL THEN Edit.Iconbar.Size := ibs;
     END;
END;


CONST ReservedWords:ARRAY[1..63] OF STRING[15] = (
        'CSTRING',
        'ABSOLUTE',
        'AND',
        'ARRAY',
        'AS',
        'IS',
        'ASM',
        'ASSEMBLER',
        'BEGIN',
        'CASE',
        'CONST',
        'CONSTRUCTOR',
        'DESTRUCTOR',
        'DIV',
        'DO',
        'DOWNTO',
        'ELSE',
        'END',
        'EXCEPT',
        'EXPORTS',
        'EXTERNAL',
        'FILE',
        'FINALLY',
        'FOR',
        'FUNCTION',
        'GOTO',
        'IF',
        'IMPORTS',
        'IN',
        'INHERITED',
        'INTERFACE',
        'IMPLEMENTATION',
        'LABEL',
        'LIBRARY',
        'MOD',
        'NIL',
        'NOT',
        'OBJECT',
        'CLASS',
        'OF',
        'ON',
        'OR',
        'PACKED',
        'PROCEDURE',
        'PROGRAM',
        'RAISE',
        'RECORD',
        'REPEAT',
        'SET',
        'SHL',
        'SHR',
        'STRING',
        'THEN',
        'TO',
        'TRY',
        'TYPE',
        'UNIT',
        'UNTIL',
        'USES',
        'VAR',
        'WHILE',
        'WITH',
        'XOR');

FUNCTION IsValidIdentifier(s:STRING):BOOLEAN;
VAR  t:BYTE;
BEGIN
     Result := FALSE;
     IF s = '' THEN exit;
     UpcaseStr(s);
     IF not (s[1] IN ['A'..'Z','_']) THEN exit;
     IF Length(s) > 60 THEN exit;
     FOR t := 2 TO Length(s) DO
     BEGIN
          CASE s[t] OF
            'A'..'Z','0'..'9','_':;
            ELSE exit;
          END;
     END;
     {Test ob reserviertes Wort}
     FOR t := 1 TO 63 DO
        IF s = ReservedWords[t] THEN exit;

     Result := TRUE;
END;



/////////////////////////////////////////////////////////////////////////////
//
//  Docking Message Window
//
/////////////////////////////////////////////////////////////////////////////

TYPE
    TDockingMsgView=CLASS(TControl)
      PRIVATE
         Notebook:TNotebook;
         TabSet:TTabSet;
         PROCEDURE EvTabSelected(Sender:TObject);
         PROCEDURE EvCallStackSelected(Sender:TObject;Index:LONGINT);
         PROCEDURE EvCanGridEdit(Grid:TStringGrid;Col,Row:LongInt;Var AllowEdit:Boolean);
         PROCEDURE EvBPListScan(Sender:TObject; VAR Keycode:TKeyCode);
      PROTECTED
         PROCEDURE SetupComponent; OVERRIDE;
         PROCEDURE Resize; OVERRIDE;
         PROCEDURE MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
      PUBLIC
         PROCEDURE ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
    END;

CONST
    DockingMsgView:TDockingMsgView=NIL;
    BuildList:TListBox=NIL;
    FindInFilesList:TListBox=NIL;
    DebugList:TListBox=NIL;
    DumpField:TDumpField=NIL;


PROCEDURE InitControlCentre(Panel:TDockingPalette);
BEGIN
     ControlCentre := Panel;
     {Position der PanelForm setzen}
     TForm(Panel.Owner).SetWindowPos((Screen.Width-400) DIV 2,
                                     (Screen.Height-200) DIV 2,
                                     400,
                                     200);
     Panel.AutoWrap := FALSE;
     Panel.EnableDocking := [tbBottom,tbLeft,tbRight];
     Panel.ToolbarAlign := tbBottom;
     Panel.DockingForm := CodeEditor;
     Panel.OnDocking := CodeEditor.EvControlCentreDocking;
     DockingMsgView.Create(Panel);
     DockingMsgView.HelpContext := hctxDialogDockingControlCentre;
     DockingMsgView.Parent := Panel;
END;


PROCEDURE ClearBuildList;
  PROCEDURE FreeListItems(List:TStrings);
  VAR  Item:PErrorItem;
       i:LONGINT;
  BEGIN
       IF List = NIL THEN exit;
       FOR i := 0 TO List.Count-1 DO
       BEGIN
            Item := PErrorItem(List.Objects[i]);
            IF Item = NIL THEN continue;

            IF Item^.pErrorFile <> NIL
            THEN FreeMem(Item^.pErrorFile, Length(Item^.pErrorFile^)+1);
            IF Item^.pErrorText <> NIL
            THEN FreeMem(Item^.pErrorText, Length(Item^.pErrorText^)+1);
            Dispose(Item);
       END;
  END;
BEGIN
     CodeEditor.LastErrorType := 0;
     CodeEditor.FirstErrorIndex := -1; {zum Merken des 1. normalen Errors}

     FreeListItems(CodeEditor.Messages);
     CodeEditor.Messages.Clear;
END;


PROCEDURE ClearFindInFilesList;
BEGIN
     IF FindInFilesList <> NIL THEN FindInFilesList.Items.Clear;;
END;


PROCEDURE WriteToFindInFilesList(CONST s:STRING;p:INTEGER);
VAR  idx:LONGINT;
BEGIN
     IF VDETerminating THEN exit;

     IF FindInFilesList <> NIL THEN
     BEGIN
          idx := FindInFilesList.Items.AddObject(s,TObject(p));

          IF FindInFilesList.ItemIndex = idx-1
          THEN FindInFilesList.ItemIndex := idx;
     END;
END;


PROCEDURE ClearDebugList;
BEGIN
     IF DebugList <> NIL THEN DebugList.Items.Clear;;
END;



FUNCTION CanSwitchDockingState:BOOLEAN;
BEGIN
     Result := (not CompilerActive) AND (SearchThread = NIL);
END;


////////////////////////////////////////////////

PROCEDURE TDockingMsgView.SetupComponent;
VAR  Page:TPage;
     idx:LONGINT;
BEGIN
     Inherited SetupComponent;

     Notebook.Create(SELF);
     NoteBook.Pages.Clear;
     Notebook.Color := clLtGray;
     Notebook.ZOrder := zoBottom;

     {Build}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiBuild));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     BuildList.Create(Page);
     BuildList.Align := alClient;
     BuildList.Color := clWindow;
     BuildList.PenColor := clWindowText;
     BuildList.OnExit := CodeEditor.EvMsgWindowExit;
     BuildList.OnItemFocus := CodeEditor.EvMsgFocused;
     BuildList.OnItemSelect := CodeEditor.EvMsgSelected;
     BuildList.OnScan := CodeEditor.EvMsgScanEvent;
     BuildList.Parent := Page;

     {Build}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiFindFiles));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     FindInFilesList.Create(Page);
     FindInFilesList.HorzScroll := TRUE;
     FindInFilesList.Align := alClient;
     FindInFilesList.Color := clWindow;
     FindInFilesList.PenColor := clWindowText;
     FindInFilesList.OnItemSelect := CodeEditor.EvFindFileSelected;
     FindInFilesList.Parent := Page;

     {Debug}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiDebug));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     DebugList.Create(Page);
     DebugList.Align := alClient;
     DebugList.Color := clWindow;
     DebugList.PenColor := clWindowText;
     DebugList.Parent := Page;

     {Locals}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiLocals));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     LocalsGrid.Create(Page);
     LocalsGrid.Align := alClient;
     LocalsGrid.Color := clWindow;
     LocalsGrid.PenColor := clWindowText;
     LocalsGrid.OnCanEdit := EvCanGridEdit;
     LocalsGrid.Parent := Page;

     {Self Inspect}
     idx := NoteBook.Pages.Add('Self'); //String bleibt
     Page := TPage(NoteBook.Pages.Objects[idx]);
     SelfGrid.Create(Page);
     SelfGrid.Align := alClient;
     SelfGrid.Color := clWindow;
     SelfGrid.PenColor := clWindowText;
     SelfGrid.RowCount := 1;
     SelfGrid.InspectValue := 'Self';
     SelfGrid.OnCanEdit := EvCanGridEdit;
     SelfGrid.Parent := Page;

     {Watch}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiWatch));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     WatchGrid.Create(Page);
     WatchGrid.Align := alClient;
     WatchGrid.Color := clWindow;
     WatchGrid.PenColor := clWindowText;
     WatchGrid.Parent := Page;

     {Call Stack}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiCallStack));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     CallStackList.Create(Page);
     CallStackList.Align := alClient;
     CallStackList.Color := clWindow;
     CallStackList.PenColor := clWindowText;
     CallStackList.OnItemSelect := EvCallStackSelected;
     CallStackList.Parent := Page;

     {Breakpoints}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiBreakpoints));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     BPList.Create(Page);
     BPList.Align := alClient;
     BPList.Color := clWindow;
     BPList.PenColor := clWindowText;
     BPList.OnScan := EvBPListScan;
     BPList.Parent := Page;

     {Storage}
     idx := NoteBook.Pages.Add(LoadNLSStr(SiStorage));
     Page := TPage(NoteBook.Pages.Objects[idx]);
     DumpField.Create(Page);
     DumpField.Align := alClient;
     DumpField.Color := clWindow;
     DumpField.PenColor := clWindowText;
     DumpField.Parent := Page;

     Notebook.PageIndex := 0;
     Notebook.Parent := SELF;

     TabSet.Create(SELF);
     TabSet.Height := 22;
     TabSet.Align := alBottom;
     TabSet.ZOrder := zoTop;
     TabSet.Font := Screen.SmallFont;
     TabSet.OnClick := EvTabSelected;
     TabSet.Color := clLtGray;
     TabSet.PenColor := clWindowText;
     TabSet.SelectedColor := clWindow;
     TabSet.UnselectedColor := clLtGray;
     TabSet.Tabs := Notebook.Pages;
     TabSet.TabIndex := 0;
     TabSet.Parent := SELF;
END;


PROCEDURE TDockingMsgView.Resize;
BEGIN
  Inherited Resize;

  Notebook.SetWindowPos(0,20,Width,Height-20);
  TabSet.SetWindowPos(0,0,Width,22);
END;


PROCEDURE TDockingMsgView.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
  Inherited MouseDblClick(Button,ShiftState,X,Y);
  LastMsg.Handled := TRUE;
END;


PROCEDURE TDockingMsgView.ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);
BEGIN
  CASE KeyCode OF
    kbCtrlJ:
      BEGIN
        IF CodeEditor.TopEditor <> NIL
          THEN CodeEditor.TopEditor.Focus;
        KeyCode := kbNull;
      END;
    kbCtrlTab:
      BEGIN
        IF TabSet.TabIndex >= TabSet.Tabs.Count-1
          THEN TabSet.TabIndex := 0
          ELSE TabSet.TabIndex := TabSet.TabIndex +1;
        KeyCode := kbNull;
      END;
    kbCtrlShiftTab:
      BEGIN
        IF TabSet.TabIndex > 0
          THEN TabSet.TabIndex := TabSet.TabIndex -1
          ELSE TabSet.TabIndex := TabSet.Tabs.Count-1;
        KeyCode := kbNull;
      END;
    kbEsc:
      BEGIN
        IF CanSwitchDockingState THEN
          BEGIN
            IF ControlCentre.DockingState = dsDock
              THEN ControlCentre.DockingState := dsHide;
          END;
        KeyCode := kbNull;
      END;
    ELSE TSibylForm(Application.MainForm).ScanEvent(KeyCode,1);
  END;
END;


PROCEDURE TDockingMsgView.EvTabSelected(Sender:TObject);
BEGIN
     NoteBook.PageIndex := TabSet.TabIndex;
     IF NoteBook.PageIndex = CallStackIndex THEN UpdateCallStackList;
     IF Notebook.PageIndex = LocalsIndex THEN LocalsGrid.UpdateVariables;
     IF NoteBook.PageIndex = BreakpointsIndex THEN UpdateBreakpointList;
END;


PROCEDURE TDockingMsgView.EvCallStackSelected(Sender:TObject;Index:LONGINT);
VAR  s:STRING;
     t,p:BYTE;
     c:Integer;
     FName:STRING;
     FLine:STRING;
     line:LONGINT;
     Edit:TBaseEditor;
     ep:TEditorPos;
BEGIN
     s := CallStackList.Items[Index];
     t := pos('$',s);
     IF t <> 0 THEN
     BEGIN
          p := pos(EXT_UC_PASCAL,s); {extract FileName}
          IF p > 0 THEN
          BEGIN
               FName := copy(s,1,p-1) + EXT_UC_PASCAL;
               Edit := OpenSourceFile(FName,FALSE);   {not to Top}
               IF Edit <> NIL THEN
               BEGIN
                    {extract line number}
                    FLine := copy(s,p+4,255); {beginne hinter dem FileNamen}
                    p := pos('(',FLine);
                    IF p > 0 THEN delete(FLine,1,p);
                    p := pos(')',FLine);
                    IF p > 0 THEN delete(FLine,p,255);
                    val(FLine,line,c);
                    IF c = 0 THEN
                    BEGIN
                         ep.Y := line;
                         ep.X := 1;
                         Edit.GotoPosition(ep);
                         Edit.CaptureFocus;
                    END;
               END;
          END;
     END;
END;


PROCEDURE TDockingMsgView.EvCanGridEdit(Grid:TStringGrid;Col,Row:LongInt;Var AllowEdit:Boolean);
BEGIN
     AllowEdit := Col <> 0;
END;


PROCEDURE TDockingMsgView.EvBPListScan(Sender:TObject; VAR Keycode:TKeyCode);
VAR  s:STRING;
     b:BYTE;
     Line:LONGINT;
     c:Integer;
     Edit:TSibEditor;       
     pl:PLine;
     FName:STRING;
BEGIN
     IF not (KeyCode IN [kbDel,kbIns]) THEN exit;

     CASE KeyCode OF
       kbIns:
       BEGIN
            IF CodeEditor.TopEditor <> NIL THEN
            BEGIN
                 CodeEditor.TopEditor.cmToggleBreakpoint;
            END;
            KeyCode := kbNull;
       END;
       kbDel:
       BEGIN
            IF (BPList.ItemIndex < 0) OR
               (BPList.ItemIndex >= BPList.Items.Count) THEN exit;

            s := BPList.Items[BPList.ItemIndex];
            b := pos('(',s);
            IF b = 0 THEN exit;
            FName := copy(s,1,b-1);  //extract file name

            Delete(s,1,b);
            b := pos(')',s);
            s[0] := chr(b-1);
            VAL(s,Line,c);
            IF c <> 0 THEN exit;

            {Suche nach ShortName und erweitere FName, wenn gefunden}
            FName := BreakPointList.RemoveBreakPointShort(FName,Line);

            Edit := GetEditor(FName);
            IF Edit <> NIL THEN
            BEGIN
                 pl := Edit.PLines[Line];
                 IF pl <> NIL
                 THEN pl^.flag := pl^.flag AND (not ciBreakpointLine);

                 Edit.Invalidate;
            END;
            UpdateBreakpointListProc;

            KeyCode := kbNull;
       END;
     END;
END;


///////////////////////////////////////////////////////////////////////

PROCEDURE ShowWatchGrid;
BEGIN
     CodeEditor.ShowControlCentre(WatchIndex,Fokus);
END;

PROCEDURE ShowLocalsGrid;
BEGIN
     CodeEditor.ShowControlCentre(LocalsIndex,Fokus);
END;

/////////////////////////////////////////////////////////////////////////////
//
//  Code-Editor
//
/////////////////////////////////////////////////////////////////////////////

PROCEDURE TCodeEditor.DebugTrace(CONST s:STRING);
BEGIN
  IF DebugList <> NIL
    THEN DebugList.Items.Add(s);
END;


PROCEDURE TCodeEditor.SetupComponent;
BEGIN
  Inherited SetupComponent;

  SibylFormId := dwi_CodeEditor;
  Name := 'CodeEditor';     {Name nicht verndern!}
  Caption := LoadNLSStr(SiCodeEditor);
  PenColor := clBlack;
  Color := clAppWorkSpace;
  FormStyle := fsMDIForm;
  EnableDocking := [tbLeft,tbRight,tbBottom];
  OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;
END;


PROCEDURE TCodeEditor.CreateWnd;
BEGIN
  Inherited CreateWnd;
END;


DESTRUCTOR TCodeEditor.Destroy;
BEGIN
  ClearBuildList;  {free the items}

  IF EditorPopup <> NIL THEN EditorPopup.Destroy;
  IF MacroList <> NIL THEN MacroList.Destroy;

  CodeEditor := NIL;
  CodeEditorRef := NIL;

  Inherited Destroy;
END;


PROCEDURE TCodeEditor.Init;
VAR  i:INTEGER;
BEGIN
  MDIBehaviour := IdeSettings.EditOpt.Style = cs_MDI;
  IF MDIBehaviour
    THEN RemoveTabSet
    ELSE InsertTabSet;

  IF st_Statusbar IN IdeSettings.StaticToolbars
    THEN InsertStatusbar
    ELSE RemoveStatusbar;

  IndentBlock := '';
  FOR i := 1 TO IdeSettings.CodeGen.IndentBlock
    DO IndentBlock := IndentBlock + ' ';
  IndentScope := '';
  FOR i := 1 TO IdeSettings.CodeGen.IndentScope
    DO IndentScope := IndentScope + ' ';
  IndentField := '';
  FOR i := 1 TO IdeSettings.CodeGen.IndentField
    DO IndentField := IndentField + ' ';
  IndentSpace := '';
  FOR i := 1 TO IdeSettings.CodeGen.IndentSpace
    DO IndentSpace := IndentSpace + ' ';

  LineBreak := IdeSettings.CodeGen.LineBreak;
  IF LineBreak < 30 THEN LineBreak := 80;
END;


PROCEDURE TCodeEditor.EvControlCentreDocking(Sender:TObject;VAR TargetForm:TForm;VAR NewAlign:TToolbarAlign);
BEGIN
  IF TargetForm = Application.MainForm THEN TargetForm := NIL;

  //Project.EvDocking
  IF TargetForm IS TBaseEditor THEN TargetForm:=CodeEditorRef;
END;


PROCEDURE TCodeEditor.Tile;
BEGIN
  IF MDIBehaviour THEN Inherited Tile;
END;


PROCEDURE TCodeEditor.Cascade;
BEGIN
  IF MDIBehaviour THEN Inherited Cascade;
END;


PROCEDURE TCodeEditor.CloseAll;
VAR  Child:TSibEditor;
     t:LONGINT;
BEGIN
  FOR t := MDIChildCount-1 DOWNTO 0 DO
    BEGIN
      Child := TSibEditor(MDIChildren[t]);
      IF Child IS TSibEditor THEN
        IF Child.CloseQuery
          THEN Child.Destroy
          ELSE break;
    END;
END;


PROCEDURE TCodeEditor.Resize;
VAR  t:LONGINT;
     Edit:TSibEditor;
     deltaWidth,deltaHeight:LONGINT;
BEGIN
  deltaWidth := IdeSettings.DesktopWindows[SibylFormId].CX - Width;
  deltaHeight := IdeSettings.DesktopWindows[SibylFormId].CY - Height;

  Inherited Resize;

  IF WindowState = wsMinimized THEN exit;

  FOR t := 0 TO MDIChildCount-1 DO
    BEGIN
      Edit := TSibEditor(MDIChildren[t]);
      IF MDIBehaviour
        THEN
          BEGIN
             Edit.SetWindowPos(Edit.Left,
                               Edit.Bottom,
                               Edit.Width - deltaWidth,
                               Edit.Height - deltaHeight);
          END
        ELSE
          BEGIN
            IF Edit = ActiveMDIChild
              THEN Edit.SetWindowPos(0,0,0,0)
              ELSE Edit.NeedResize := TRUE;
          END;
    END;
END;


PROCEDURE TCodeEditor.SetFocus;
BEGIN
  Inherited SetFocus;
  IF TopEditor <> NIL THEN TopEditor.CaptureFocus;
END;


PROCEDURE TCodeEditor.Close;
BEGIN
  IF not Application.Terminated THEN Application.MainForm.Close;
END;


PROCEDURE TCodeEditor.CommandEvent(VAR Command:TCommand);
VAR MsgHandled   : BOOLEAN;
    Editor       : TSibEditor;
{$IFDEF OS2}
    CFOD         : TOpenDialog;
    CFSD         : TSaveDialog;
{$ENDIF}
{$IFDEF Win32}
    CFOD         : TSystemOpenDialog;
    CFSD         : TSystemSaveDialog;
{$ENDIF}
    s,d,n,e      : STRING;
    ret          : BOOLEAN;
    al           : LONGINT;
    ThreadName   : STRING;
    CompLibName  : STRING;
    WildCardIndex: LONGINT;
    mbRet        : TMsgDlgReturn;
    txt          : String;

BEGIN
  Editor := TopEditor;

  Inherited CommandEvent(Command);

//  Application.LogWriteln('Command:' + tostr(Command));
  MsgHandled := TRUE;

  CASE Command OF
  {File Menu}
    cmNew:     // Neue Datei
      BEGIN
        ActivateCodeEditor(NIL);
        REPEAT
          s := tostr(NoNameCount);
          inc(NoNameCount);
          IF Length(s) = 1 THEN s := '0'+ s;
          s := FExpand('Noname'+ s + EXT_UC_PASCAL);
        UNTIL GetEditor(s) = NIL;

        Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
        IF Editor <> NIL THEN
          BEGIN
            Editor.SetFileName(s);
            Editor.Untitled := TRUE;
          END;
      END;

    cmOpen:     // Oeffnen einer Datei
      BEGIN
        CFOD.Create(NIL{SELF}); {neuer fokus durch loadeditor}
        CFOD.HelpContext := hctxDialogOpenFile;
        CFOD.Title := LoadNLSStr(SOpenAFile);
        SetFileDialogTypes(CFOD);
        CFOD.FilterIndex := LastFileDialogWildCardIndex;
        s := FileDialogWildCards[LastFileDialogWildCardIndex];
        CFOD.FileName := s;
        CFOD.DefaultExt := GetDefaultExt(s);
        ret := CFOD.Execute;
        LastFileDialogWildCardIndex := CFOD.FilterIndex;
        s := CFOD.Filename;
        CFOD.Destroy;
        Screen.Update;
        IF ret THEN
          BEGIN
            LoadAsISOLatin1 := LastFileDialogWildCardIndex = ISOLatin1WildCardIndex;
            ActivateCodeEditor(NIL);
            LoadEditor(s,0,0,0,0,FALSE,CursorIgnore,Fokus,ShowIt);
            LoadAsISOLatin1 := FALSE;
            IF ChangeDirOnOpen THEN
              BEGIN
//                FSplit(s,d,n,e);
                ChangeDir(ExtractFilePath(s));
              END;
          END;
      END;

    cmInsertFile:      // Eine Datei einfuegen
      BEGIN
        IF Editor <> NIL THEN
          BEGIN
            Editor.cmICBReadBlock;
            ActivateCodeEditor(Editor);
          END;
      END;

    cmSave:            // Die Datei abspeichern
      BEGIN
        IF Editor <> NIL THEN
          BEGIN
            Editor.SaveFile;
            ActivateCodeEditor(Editor);
          END;
      END;

    cmSaveAs:         // Die Datei unter einem anderen Namen speichern
      BEGIN
        IF Editor = NIL THEN exit;
        CFSD.Create(SELF);
        CFSD.HelpContext := hctxDialogSaveFileAs;
        CFSD.Title := LoadNLSStr(SSaveFileAs);
        SetFileDialogTypes(CFSD);
        CFSD.FileName := Editor.FileName;
//        FSplit(Editor.FileName,d,n,e);
        e:=ExtractFileExt(Editor.FileName);
        IF e = '' THEN e := EXT_UC_PASCAL;
        CFSD.DefaultExt := GetDefaultExt('*'+ e);
        ret := CFSD.Execute;
        s := CFSD.FileName;
        WildCardIndex := CFSD.FilterIndex;
        CFSD.Destroy;
        Screen.Update;
        IF ret THEN
          BEGIN
            IF WildCardIndex = ISOLatin1WildCardIndex
              THEN Include(Editor.FExtraOpt, eoConvertISOLatin1);
            ActivateCodeEditor(Editor);
            Editor.SaveFileAs(s);
          END;
      END;

    cmSaveAll:          // Alle Dateien speichern
      BEGIN
        ActivateCodeEditor(NIL);
        SaveFiles(TRUE);        {all modified editor files}
      END;

    cmNewUnit:          // Neue Unit-Datei erstellen
      BEGIN
        ActivateCodeEditor(NIL);
        Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
        IF Editor <> NIL THEN
          BEGIN
//            FSplit(Project.FileName,d,n,e);
//            s := GetUniqueFileName(d,'Unit',1,EXT_PASCAL);
            s := GetUniqueFileName(extractFilePath(Project.FileName),
                                   'Unit',1,EXT_UC_PASCAL);
            Editor.SetFileName(s);
            Editor.Untitled := TRUE;
//            FSplit(s,d,n,e);
            n:=ExtractFileName(s);
            Split(n,'.',n,e);
            Editor.BeginUpdate;
            al := Editor.InsertLine(1,Key(_UNIT_)+' '+ n +';');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_INTERFACE_));
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_IMPLEMENTATION_));
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_INITIALIZATION_));
            al := Editor.InsertLine(al+1,Key(_END_)+'.');
            Editor.EndUpdate;
            {add file to project as child of the primary}
            IF ExistProjectMain(ProjectPrimary(Project.Settings))
              THEN AddProjectUnit(ProjectPrimary(Project.Settings), s)
              ELSE ErrorBox(LoadNLSStr(SiNoPrimaryFileFound)+#13+#10+
                        FmtLoadNLSStr(SiCouldNotAddToProject,[n]));
          End;
      END;

    cmNewWDSibylHelp:
      Begin
        ActivateCodeEditor(NIL);
        Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
        IF Editor <> NIL THEN
          BEGIN
//            FSplit(Project.FileName,d,n,e);
            d:=ExtractFilePath(Project.FileName);
            s := GetUniqueFileName(d,'File',1,EXT_UC_WDSibyl_Help);
            Editor.SetFileName(s);
          END;
      End;

    cmNewResource:
      Begin
        ActivateCodeEditor(NIL);
        Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
        IF Editor <> NIL THEN
          BEGIN
//            FSplit(Project.FileName,d,n,e);
            d:=ExtractFilePath(Project.FileName);
            s := GetUniqueFileName(d,'File',1,EXT_UC_RC);
            Editor.SetFileName(s);
          END;
      End;

    cmNewText:      // Neue Text-Datei erstellen
      BEGIN
        ActivateCodeEditor(NIL);
        Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
        IF Editor <> NIL THEN
          BEGIN
//            FSplit(Project.FileName,d,n,e);
            d:=ExtractFilePath(Project.FileName);
            s := GetUniqueFileName(d,'File',1,EXT_UC_TXT);
            Editor.SetFileName(s);
          END;
      END;

    cmNewThread:    // Neue Pas-Thread-Datei erstellen
      BEGIN
        ThreadName := '';
        IF not InputQuery(LoadNLSStr(SiNewThreadObject),LoadNLSStr(SiClassName),ThreadName)
          THEN exit;
        IF not IsValidIdentifier(ThreadName) THEN
          BEGIN
            ErrorBox(FmtLoadNLSStr(SiNotAValidIdent,[ThreadName]));
            exit;
          END;
        ActivateCodeEditor(NIL);
        Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
        IF Editor <> NIL THEN
          BEGIN
//            FSplit(Project.FileName,d,n,e);
            d:=ExtractFilePath(Project.FileName);
            s := GetUniqueFileName(d,'Thread',1,EXT_UC_PASCAL);
            Editor.SetFileName(s);
            Editor.Untitled := TRUE;
//            FSplit(s,d,n,e);
            n:=ExtractFileName(s);
            Split(n,'.',n,e);
            Editor.BeginUpdate;
            al := Editor.InsertLine(1,Key(_UNIT_)+' '+ n +';');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_INTERFACE_));
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_USES_));
            al := Editor.InsertLine(al+1,IndentBlock +'Classes, uSysClass;');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_TYPE_));
            al := Editor.InsertLine(al+1,IndentBlock+ThreadName+
                    IndentSpace+'='+IndentSpace+Key(_CLASS_)+'(TThread)');
            al := Editor.InsertLine(al+1,IndentBlock+IndentScope+Key(_PRIVATE_));
            al := Editor.InsertLine(al+1,IndentBlock+IndentScope+IndentField+'{'+LoadNLSStr(SiInsertPrivateDeclsHere)+'}');
            al := Editor.InsertLine(al+1,IndentBlock+IndentScope+Key(_PROTECTED_));
            al := Editor.InsertLine(al+1,IndentBlock+IndentScope+
                    IndentField+Key(_PROCEDURE_)+' Execute;'+IndentSpace+Key(_OVERRIDE_)+';');
            al := Editor.InsertLine(al+1,IndentBlock+Key(_END_)+';');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_IMPLEMENTATION_));
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,'{'+ThreadName+'}');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_PROCEDURE_)+' '+ThreadName+'.Execute;');
            al := Editor.InsertLine(al+1,Key(_BEGIN_));
            al := Editor.InsertLine(al+1,IndentBlock+'{'+LoadNLSStr(SiPlaceThreadCodeHere)+'}');
            al := Editor.InsertLine(al+1,Key(_END_)+';');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_INITIALIZATION_));
            al := Editor.InsertLine(al+1,Key(_END_)+'.');
            Editor.EndUpdate;
            {add file to project as child of the primary}
            IF ExistProjectMain(ProjectPrimary(Project.Settings))
              THEN AddProjectUnit(ProjectPrimary(Project.Settings), s)
              ELSE ErrorBox(LoadNLSStr(SiNoPrimaryFileFound)+#13+#10+
                                FmtLoadNLSStr(SiCouldNotAddToProject,[n]));
          END;
      END;

    cmNewCompLib:        // Neue Complib-Datei erstellen
      BEGIN
        CompLibName := '';
        IF not InputQuery(LoadNLSStr(SiNewComponentLibrary),LoadNLSStr(SiCompLibName),CompLibName)
          THEN exit;
        IF not IsValidIdentifier(CompLibName) THEN
          BEGIN
            ErrorBox(FmtLoadNLSStr(SiNotAValidIdent,[CompLibName]));
            exit;
          END;
        ActivateCodeEditor(NIL);
        Editor := LoadEditor('',0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
        IF Editor <> NIL THEN
          BEGIN
//            FSplit(GetCompLibName,d,n,e);  // Pfad ermitteln
            s := d + CompLibName + '.scl';
            Editor.SetFileName(s);
            Editor.Untitled := FALSE;
            Editor.BeginUpdate;
            al := Editor.InsertLine(1,Key(_LIBRARY_)+' '+ CompLibName +';');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,'{$m 65535,4194304}');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_USES_));
            al := Editor.InsertLine(al+1,IndentBlock +'Classes,'+IndentSpace+'Forms;');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_EXPORTS_));
            al := Editor.InsertLine(al+1,IndentBlock +'SetupCompLib name '+#39+'SETUPCOMPLIB'+#39+',');
            al := Editor.InsertLine(al+1,IndentBlock +'SearchClassByName name '+#39+'SEARCHCLASSBYNAME'+#39+',');
            al := Editor.InsertLine(al+1,IndentBlock +'CallClassPropertyEditor name '+#39+'CALLCLASSPROPERTYEDITOR'+#39+',');
            al := Editor.InsertLine(al+1,IndentBlock +'CallPropertyEditor name '+#39+'CALLPROPERTYEDITOR'+#39+',');
            al := Editor.InsertLine(al+1,IndentBlock +'PropertyEditorAvailable name '+#39+'PROPERTYEDITORAVAILABLE'+#39+',');
            al := Editor.InsertLine(al+1,IndentBlock +'ClassPropertyEditorAvailable name '+#39+'CLASSPROPERTYEDITORAVAILABLE'+#39+',');
            al := Editor.InsertLine(al+1,IndentBlock +'GetExperts name '+#39+'GETEXPERTS'+#39+';');
            al := Editor.InsertLine(al+1,'');
            al := Editor.InsertLine(al+1,Key(_BEGIN_));
            al := Editor.InsertLine(al+1,Key(_END_)+'.');
            Editor.EndUpdate;
            Editor.BringToFront;
            //neue CompLib compilieren
            ForceCompileProc(Action_CompLib,s);
         END;
      END;

{ Edit Menu}
     cmUndo:   // Rueckgaengig
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.Undo;
           END;
       END;

     cmRedo:   // Wiederrufen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.Redo;
           END;
       END;

     cmCut:    // Ausschneiden
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.CutToClipBoard;
           END;
       END;

     cmCopy:   // Kopieren
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.CopyToClipBoard;
           END;
       END;

     cmPaste:   // Einfuegen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.PasteFromClipBoard;
           END;
       END;

     cmDelete:   // Loeschen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.DeleteSelection;
           END;
       END;

     cmSelectAll:  // Alles auswaehlen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.SelectAll;
           END;
       END;

     cmDeselectAll: // Auswahl aufheben
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.DeselectAll;
           END;
       END;

     cmSelectMode:   // Spaltenblock
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.ChgSelectMode;
           END;
       END;

     cmMacroRecord:  // Makro aufnehmen
       BEGIN
         IF Editor <> NIL THEN
          BEGIN
            ActivateCodeEditor(Editor);
            Editor.cmRecordMacro;
          END;
       END;

     cmMacroPlay:     // Makro abspielen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.cmPlayMacro;
           END;
       END;

     cmMacroSave:    // Makro speichern
       BEGIN
         AddGlobalMacro;
       END;

{Search Menu}
     cmFind:
       BEGIN         // Suchen nach
         IF Editor <> NIL THEN
           BEGIN
             Editor.cmFindText;
             ActivateCodeEditor(TopEditor);   {all Editor search!}
           END;
       END;

     cmReplace:      // Ersetzen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             Editor.cmReplaceText;
             ActivateCodeEditor(TopEditor);   {all Editor search!}
           END;
       END;

     cmSearchAgain:  // Weitersuchen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.cmSearchTextAgain;
           END;
       END;

     cmIncrementalSearch:  // Inkrementelle suche
       BEGIN
         IF Editor <> NIL THEN
         BEGIN
           ActivateCodeEditor(Editor);
           Editor.cmIncrementalSearch;
         END;
       END;

     cmMatchingBrace:      // Passsende Klammer suchen
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.cmFindMatchingBrace;
           END;
       END;

     cmGotoLastError:      // letzten Fehler suchen
       BEGIN
         ActivateCodeEditor(NIL);
         GotoLastError;
       END;

{Window Menu}
     cmTile: ActivateCodeEditor(NIL);
     cmCascade: ActivateCodeEditor(NIL);
     cmNext: ActivateCodeEditor(NIL);
     cmPrevious: ActivateCodeEditor(NIL);
     cmCloseTop: ActivateCodeEditor(NIL);
     cmCloseAll: ActivateCodeEditor(NIL);
     cmMaximizeRestore:
       BEGIN
         ActivateCodeEditor(NIL);
         IF not MDIBehaviour THEN exit;

         IF Editor <> NIL THEN
           BEGIN
             IF Editor.WindowState <> wsNormal
               THEN Editor.WindowState := wsNormal
               ELSE Editor.WindowState := wsMaximized;
            END;
       END;

{Help Menu}
     cmTopicSearch:
       BEGIN
         ActivateCodeEditor(NIL);
         IF Editor <> NIL THEN
           BEGIN
             s := Editor.GetWord(Editor.CursorPos);
             IF s <> '' THEN
               IF not Application.HelpJump(s) THEN
                 BEGIN
                   {versuche, automatisch generierten Name zu finden}
                    {zB. ComboBox1 -> TComboBox}
                   WHILE (Length(s) > 0) AND (s[Length(s)] IN ['0'..'9']) do
                     SetLength(s,Length(s)-1);
                   s := 'T' + s;
                   IF not Application.HelpJump(s)
                     THEN Application.HelpIndex;
                 END;
           END;
       END;

{Context Menu}
     cmToggleReadOnly:
       BEGIN
         ActivateCodeEditor(NIL);
         IF InDebugger THEN exit;
         IF Editor <> NIL THEN
           BEGIN
             Editor.ReadOnly := not Editor.ReadOnly;
             Project.Modified := TRUE;
           END;
       END;

     cmToggleMsgView:
       BEGIN
         ActivateCodeEditor(NIL);
         IF not CanSwitchDockingState THEN exit;

         IF ControlCentre.DockingState = dsHide
           THEN ShowControlCentre(-1,NoFokus)
           ELSE HideControlCentre;
         Project.Modified := TRUE;
       END;

     cmToggleStatusbar:
       BEGIN
         IF Statusbar = NIL
           THEN InsertStatusbar
           ELSE RemoveStatusbar;
         Project.Modified := TRUE;
       END;

     cmEditorProperties:
       BEGIN
         ActiveGeneralPage := EditorPropertiesIndex;
         SendMsg(Application.MainForm.Handle,CM_COMMAND,cmGeneral,0);
       END;

     cmCompile:  SendMsg(Application.MainForm.Handle,CM_COMMAND,cmCompile,0);
     cmMake:     SendMsg(Application.MainForm.Handle,CM_COMMAND,cmMake,0);
     cmToggleBreakPoint:
                 SendMsg(Application.MainForm.Handle,CM_COMMAND,cmToggleBreakPoint,0);
     cmOpenFileAtCursor:
       BEGIN
         IF Editor <> NIL THEN
           BEGIN
             ActivateCodeEditor(Editor);
             Editor.cmLoadUnit;
           END;
       END;

     cmReOpenFile:
       Begin
         IF InDebugger THEN exit;
         IF Editor <> NIL THEN
           Begin
             ActivateCodeEditor(Editor);
             if Editor.Modified
               then Begin
                      Txt:=FmtLoadNLSStr(SiFileModifiedReOpen,[Editor.FileName]);
                      mbRet:=Dialogs.MessageBox(txt, mtInformation,mbYesNo);
                    End
               else mbRet:=mrYes;
             if mbRet=mrYes then
               Begin
                 WDSibylThrd.Suspend;    // Den Thread kurz anhalten
                 Editor.ReOpenFile;
                 WDSibylThrd.Resume;    // Den Thread kurz anhalten
               End;
           end;
       End;

     cmGotoDebugCursor:
                 SendMsg(Application.MainForm.Handle,CM_COMMAND,cmGotoDebugCursor,0);
     cmEvaluateModify:
                 SendMsg(Application.MainForm.Handle,CM_COMMAND,cmEvaluateModify,0);
     cmAddWatch: SendMsg(Application.MainForm.Handle,CM_COMMAND,cmAddWatch,0);
     ELSE MsgHandled := FALSE;
  END;

  IF MsgHandled THEN Command := cmNull;
END;


PROCEDURE TCodeEditor.SetMDIMode(mdi:BOOLEAN);
BEGIN
     IF MDIBehaviour = mdi THEN exit;  {nothing to change}

     MDIBehaviour := mdi;
     IF mdi THEN RemoveTabSet     {Delphi -> MDI}
     ELSE InsertTabSet;           {MDI -> Delphi}
     TForm.Cascade;    {Align Forms MDIs}
END;


FUNCTION TCodeEditor.TabSetIndex(Edit:TSibEditor):LONGINT;
BEGIN
  IF TabSet <> NIL
    THEN Result := TabSet.Tabs.IndexOfObject(Edit)
    ELSE Result := -1;
END;


FUNCTION EditorTabSetFont:TFont;
VAR  FontName:STRING;
     PointSize:LONGINT;
BEGIN
  IF IdeSettings.Fonts.EditorTabFont <> '' THEN
    IF SplitFontName(IdeSettings.Fonts.EditorTabFont,FontName,PointSize) THEN
      BEGIN
        Result := Screen.GetFontFromPointSize(FontName,PointSize);
        IF Result <> NIL THEN exit;
      END;

  Result := Screen.SmallFont;
END;


PROCEDURE TCodeEditor.InsertTabSet;
VAR  t:LONGINT;
     Edit:TSibEditor;
     d,n,e:STRING;
BEGIN
  IF TabSet <> NIL THEN
    BEGIN
      {beim ffnen eines neuen Projektes sonst verz”gertes Redraw}
      IF TopTool <> NIL THEN TopTool.Update;
      exit;
    END;

  TopTool.Create(SELF);
  TopTool.Size := 25;
  TabSet.Create(TopTool);
  TabSet.Align := alClient;
  TabSet.Alignment := taTop;
  TabSet.Color := clLtGray;
  TabSet.PenColor := clWindowText;
  TabSet.SelectedColor := clWindow;
  TabSet.UnselectedColor := clLtGray;
  TabSet.DitherBackground := TRUE;
  TabSet.Font := EditorTabSetFont;
  TabSet.OnClick := EvPageActivated;
  TopTool.InsertControl(TabSet);
  InsertControl(TopTool);
  TopTool.Update; {!}
  TabSet.OnFontChange := EvTabFontChanged;    {erst hier!}

  FOR t := 0 TO MDIChildCount-1 DO
    BEGIN
      Edit := TSibEditor(MDIChildren[t]);
      IF Edit IS TSibEditor THEN
        BEGIN
          IF Edit.WindowState = wsMinimized
            THEN Edit.WindowState := wsNormal;
          FSplit(Edit.FileName,d,n,e);
          IF Upcased(e) <> EXT_UC_PASCAL THEN n := n + e;
          TabSet.Tabs.AddObject(n,Edit);
        END;
    END;

  Edit := TopEditor;
  IF Edit <> NIL THEN
    BEGIN
      TabSet.TabIndex := TabSetIndex(Edit);
      Edit.FileName := Edit.FileName;  {update Code Editor Title}
    END;

  WITH IdeSettings.EditOpt DO
    BEGIN
      IF Style <> cs_TabSet THEN Project.Modified := TRUE;
      Style := cs_TabSet;
    END;
END;


PROCEDURE TCodeEditor.RemoveTabSet;
BEGIN
  IF TabSet = NIL THEN exit;

  TabSet := NIL;
  TopTool.Destroy;
  TopTool := NIL;

  Caption := LoadNLSStr(SiCodeEditor);

  WITH IdeSettings.EditOpt DO
    BEGIN
      IF Style <> cs_MDI
        THEN Project.Modified := TRUE;
      Style := cs_MDI;
    END;
END;


CONST
  CanFocusEditor:BOOLEAN=TRUE;

{$HINTS OFF}
PROCEDURE TCodeEditor.EvPageActivated(Sender:TObject);
VAR  Edit:TSibEditor;
BEGIN
  Edit := TSibEditor(TabSet.Tabs.Objects[TabSet.TabIndex]);
  IF Edit <> NIL THEN
    BEGIN
      Edit.BringToFront;
      Edit.Focus;
    END;
END;


PROCEDURE TCodeEditor.EvTabFontChanged(Sender:TObject);
VAR  s:STRING;
BEGIN
  IF not Visible THEN exit;  {wegen Canvas init}
  TabSet.Invalidate;
  s := tostr(TabSet.Font.PointSize) + '.' + TabSet.Font.FaceName;
  IdeSettings.Fonts.EditorTabFont := s;
  IdeSettings.Modified := TRUE;
END;
{$HINTS ON}


FUNCTION TCodeEditor.GetFreeAltNumber(Edit:TSibEditor):LONGINT;
VAR  i:INTEGER;
BEGIN
  FOR i := 1 TO 9 DO
    IF AltEditor[i] = NIL THEN
      BEGIN
        AltEditor[i] := Edit;
        Result := i;
        exit;
      END;
  Result := -1;
END;


PROCEDURE TCodeEditor.ActivateEditor(idx:LONGINT);
VAR  Edit:TSibEditor;
BEGIN
  IF CodeEditor.MDIBehaviour
    THEN Edit := AltEditor[idx]
    ELSE Edit := TSibEditor(MDIChildren[idx-1]);

  IF Edit <> NIL THEN
    BEGIN
      Edit.BringToFront;
      Edit.Focus;
    END;
END;

PROCEDURE TCodeEditor.ShowControlCentre(PageIndex:LONGINT;FokusPage:BOOLEAN);
VAR  Page:TPage;
BEGIN
  IF ControlCentre <> NIL THEN
    BEGIN
      IF PageIndex < 0 THEN PageIndex := DockingMsgView.Notebook.PageIndex;

      DockingMsgView.Notebook.PageIndex := PageIndex;
      DockingMsgView.TabSet.TabIndex := PageIndex;

      IF ControlCentre.DockingState = dsHide
        THEN ControlCentre.DockingState := dsDock;

      //Focus the Control in the active Page
      IF FokusPage THEN
        BEGIN
          Page := TPage(DockingMsgView.Notebook.Pages.Objects[PageIndex]);
          IF Page.ControlCount > 0 THEN Page.Controls[0].Focus;
        END;
    END;
END;


PROCEDURE TCodeEditor.HideControlCentre;
BEGIN
  IF ControlCentre <> NIL THEN ControlCentre.DockingState := dsHide;
END;


FUNCTION TCodeEditor.AddMessage(CONST s:STRING):LONGINT;
BEGIN
  Result := -1;
  IF Messages = NIL THEN exit;

  Result := Messages.Add(s);
  IF Result < 0 THEN exit;

  IF BuildList <> NIL THEN
    IF BuildList.ItemIndex = Result-1
      THEN BuildList.ItemIndex := Result;
END;


FUNCTION TCodeEditor.UpdateLastMessage(CONST s:STRING):LONGINT;
BEGIN
  Result := -1;
  IF Messages = NIL THEN exit;

  IF Messages.Count > 0 THEN
    BEGIN
      Result := Messages.Count - 1;
      Messages.Strings[Result] := s;

      IF BuildList <> NIL THEN
        IF BuildList.ItemIndex = Result-1 THEN BuildList.ItemIndex := Result;
    END
  ELSE Result := AddMessage(s);
END;


{$HINTS OFF}
{wenn die ListBox den Focus verliert, dann die Select Zeile clearen}
PROCEDURE TCodeEditor.EvMsgWindowExit(Sender:TObject);
BEGIN
  IF LastErrorMsgEditor <> NIL THEN LastErrorMsgEditor.ResetErrorLine;
  LastErrorMsgEditor := NIL;
END;


PROCEDURE TCodeEditor.EvMsgFocused(Sender:TObject;Index:LONGINT);
VAR  Item:PErrorItem;
     Edit:TSibEditor;
     fc:TEditorPos;
BEGIN
  IF LastErrorMsgEditor <> NIL THEN LastErrorMsgEditor.ResetErrorLine;
  LastErrorMsgEditor := NIL;

  IF Index < 0 THEN Index := BuildList.Items.Count-1;  {Last}

  IF (Index < 0) OR (Index >= BuildList.Items.Count) THEN exit;

  Item := PErrorItem(BuildList.Items.Objects[Index]);
  IF Item = NIL THEN exit;

  Edit := GetEditor(Item^.pErrorFile^);
  IF Edit = NIL THEN exit;   {not loaded -> dont show it}
  fc.Y := Edit.Indices[Item^.ErrorPLine];
  IF fc.Y <= 0 THEN fc.Y := Item^.ErrorLine;
  fc.X := Item^.ErrorColumn;
  {goto & hilite}
  Edit.SetErrorLine(fc.Y,fc.X,Item^.pErrorText^,Item^.ErrorType);
  LastErrorMsgEditor := Edit;
  IF TopEditor <> Edit THEN
    BEGIN
      Edit.BringToFront;
      BuildList.Focus;
    END;
END;


PROCEDURE TCodeEditor.EvMsgSelected(Sender:TObject;Index:LONGINT);
VAR  Item      : PErrorItem;
     FirstError: PErrorItem;
     Edit      : TSibEditor;
     fc        : TEditorPos;
BEGIN
  IF LastErrorMsgEditor <> NIL THEN LastErrorMsgEditor.ResetErrorLine;
  LastErrorMsgEditor := NIL;

  IF (Index < 0) OR (Index >= BuildList.Items.Count) THEN exit;

  Item := PErrorItem(BuildList.Items.Objects[Index]);
  IF Item = NIL THEN {Keine Info - aktiviere den TopEditor}
    BEGIN
      IF TopEditor <> NIL THEN TopEditor.Focus;
      exit;
    END;
  {falls Eintrag = 'There are errors' dann nehme FirstErrorIndex}
  IF (Item^.ErrorColumn <= 0) and
     (FirstErrorIndex >= 0) THEN
    BEGIN
      FirstError := PErrorItem(BuildList.Items.Objects[FirstErrorIndex]);
      IF FirstError <> NIL THEN Item := FirstError;
    END;

  Edit := GetEditor(Item^.pErrorFile^);
  IF Edit <> NIL THEN
    BEGIN
      fc.Y := Edit.Indices[Item^.ErrorPLine];
      IF fc.Y <= 0 THEN fc.Y := Item^.ErrorLine;
    END
  ELSE fc.Y := Item^.ErrorLine;
  fc.X := Item^.ErrorColumn;

  Edit := LoadEditor(Item^.pErrorFile^,0,0,0,0,TRUE,fc,Fokus,ShowIt);
  IF Edit <> NIL THEN {mark the error line again}
    BEGIN
       Edit.SetErrorLine(fc.Y,fc.X,Item^.pErrorText^,Item^.ErrorType);
       LastErrorMsgEditor := Edit;
    END;
END;


PROCEDURE TCodeEditor.EvMsgScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
BEGIN
  CASE KeyCode OF
    kbCtrlJ,kbF6,kbShiftF6:
      BEGIN
        IF TopEditor <> NIL THEN
          BEGIN
            TopEditor.Focus;
            KeyCode := kbNull;
          END;
      END;
    kbEsc:
      BEGIN
        IF CompilerActive THEN
          BEGIN
            StopCompilerProc;
            KeyCode := kbNull;
          END;
      END;
    kbCUp: ;
    kbCDown: ;
    kbPageUp: ;
    kbPageDown: ;
    kbHome: ;
    kbEnd: ;
    kbCtrlTab: ;
    kbCtrlShiftTab: ;
    ELSE TSibylForm(Application.MainForm).ScanEvent(KeyCode,1);
  END;
END;


PROCEDURE TCodeEditor.EvFindFileSelected(Sender:TObject;Index:LONGINT);
VAR  s,s1:STRING;
     p,c:INTEGER;
     fcx:TEditorPos;
BEGIN
  IF (Index < 1) OR (Index >= FindInFilesList.Items.Count) THEN exit;

  fcx.X := LONGINT(FindInFilesList.Items.Objects[Index]);
  IF fcx.X <= 0 THEN exit;
  s := FindInFilesList.Items[Index];
  p := pos('(',s);
  IF p > 0 THEN
  BEGIN
       s1 := copy(s,p+1,255);
       delete(s,p,255);  // extract FileName
       p := pos(')',s1);
       delete(s1,p,255);  // extract line number
       Val(s1,fcx.Y,c);
       IF c <> 0 THEN exit;
  END
  ELSE fcx := CursorIgnore;   //nur ”ffnen

  IF FileExists(s) THEN LoadEditor(s,0,0,0,0,TRUE,fcx,Fokus,ShowIt);
END;
{$HINTS ON}


PROCEDURE TCodeEditor.InsertStatusbar;
VAR  i:LONGINT;
     Edit:TSibEditor;
BEGIN
  IF Statusbar <> NIL THEN exit;

  Statusbar.Create(SELF);
  Statusbar.Alignment := tbBottom;
  Statusbar.Order := 0;
  Statusbar.Size := StatusbarSize;
  Statusbar.BevelStyle := tbNone;
  StatusPanel.Create(Statusbar);
  StatusPanel.Align := alClient;
  StatusPanel.BevelOuter := bvNone;
  StatusPanel.BevelInner := bvLowered;
  StatusPanel.BorderWidth := 3;
  StatusPanel.Alignment := taLeftJustify;
  {$IFDEF OS2}
  StatusPanel.Caption := LoadNLSStr(SiSibylForOS2)+' '+
              'Version: ' + Application.GetProgramVersionString;
  {$ENDIF}
  {$IFDEF Win32}
  StatusPanel.Caption := LoadNLSStr(SiSibylForWin32)+' '+
              'Version: ' + Application.GetProgramVersionString;
  {$ENDIF}
  Statusbar.InsertControl(StatusPanel);
  InsertControl(Statusbar);

  IF MDIBehaviour THEN
  FOR i := 0 TO MDIChildCount-1 DO
  BEGIN
       Edit := TSibEditor(MDIChildren[i]);
       IF Edit IS TEditor THEN Edit.Height := Edit.Height - StatusbarSize;
  END;

  WITH IdeSettings DO
  BEGIN
       IF not (st_Statusbar IN StaticToolbars) THEN IdeSettings.Modified := TRUE;
       Include(StaticToolbars, st_Statusbar);
  END;
END;


PROCEDURE TCodeEditor.RemoveStatusbar;
VAR  Toolbar:TToolbar;
     i:LONGINT;
     Edit:TSibEditor;
BEGIN
  IF Statusbar = NIL THEN exit;

  Toolbar := Statusbar;
  Statusbar := NIL;
  StatusPanel := NIL;
  Toolbar.Destroy; {setze vorher Statusbar = NIL wegen AlignToolbars}

  IF MDIBehaviour THEN
  FOR i := 0 TO MDIChildCount-1 DO
    BEGIN
      Edit := TSibEditor(MDIChildren[i]);
      IF Edit IS TEditor THEN Edit.Height := Edit.Height + StatusbarSize;
    END;

  WITH IdeSettings DO
    BEGIN
      IF st_Statusbar IN StaticToolbars THEN IdeSettings.Modified := TRUE;
      Exclude(StaticToolbars, st_Statusbar);
    END;
END;

PROCEDURE TCodeEditor.ShowContextMenu(Editor:TSibEditor;X,Y:LONGINT);

 Procedure AddMenueEntries(iCmd : tCommand; iHctx : THelpContext; var iEntry : tMenuItem);

 var ind : Integer;
     s   : String;

 Begin
   iEntry.Create(EditorPopup);
   ind:=CommandToIndex(iCmd);
   iEntry.Command := iCmd;
   if iHctx=0
     then iEntry.HelpContext := MenuEntries[ind].hctx
     else iEntry.HelpContext := iHctx;
   iEntry.Hint := LoadNLSStr(MenuEntries[ind].Hint);
   case IdeSettings.EditOpt.KeyMap of
     km_WordStar: s := MenuEntries[ind].scWS;
     km_CUA:      s := MenuEntries[ind].scCUA;
     km_Default,
     km_Custom:   s := MenuEntries[ind].scDef
   End;
   iEntry.Caption := LoadNLSStr(MenuEntries[ind].Text) + #9 +s;
   EditorPopup.Items.Add(iEntry);
 End;

VAR Entry  : TMenuItem;
    s,d,n,e: STRING;
    pt     : TPoint;
    TopEdit:TSibEditor;

BEGIN
  IF EditorPopup = NIL THEN
    BEGIN
      EditorPopup.Create(SELF);

      Entry.Create(EditorPopup);
      Entry.Caption := LoadNLSStr(SiEdPopupClose);
      Entry.Command := cmCloseTop;
      Entry.HelpContext := hctxPopupEditorClose;
      EditorPopup.Items.Add(Entry);

      OpenFileEntry.Create(EditorPopup);
      OpenFileEntry.Caption := LoadNLSStr(SiEdPopupOpen);
      OpenFileEntry.Command := cmOpenFileAtCursor;
      OpenFileEntry.HelpContext := hctxPopupEditorOpen;
      EditorPopup.Items.Add(OpenFileEntry);

      ReOpenFileEntry.Create(EditorPopup);
      ReOpenFileEntry.Caption := LoadNLSStr(SiEdPopupReOpenFile);
      ReOpenFileEntry.Command := cmReOpenFile;
      ReOpenFileEntry.HelpContext := hctxPopupEditorOpen;
      EditorPopup.Items.Add(ReOpenFileEntry);

      AddMenueEntries(cmSave, hctxPopupEditorSave, Entry);

      TopicEntry.Create(EditorPopup);
      TopicEntry.Caption := LoadNLSStr(SiEdPopupTopicSearch);
      TopicEntry.Command := cmTopicSearch;
      TopicEntry.HelpContext := hctxPopupEditorTopicSearch;
      EditorPopup.Items.Add(TopicEntry);

      Entry.Create(EditorPopup);
      Entry.Caption := '-';
      EditorPopup.Items.Add(Entry);

      CompileFileEntry.Create(EditorPopup);
      CompileFileEntry.Caption := LoadNLSStr(SiEdPopupCompile);
      CompileFileEntry.Command := cmCompile;
      CompileFileEntry.HelpContext := hctxPopupEditorCompile;
      EditorPopup.Items.Add(CompileFileEntry);

      MakeFileEntry.Create(EditorPopup);
      MakeFileEntry.Caption := LoadNLSStr(SiEdPopupMake);
      MakeFileEntry.Command := cmMake;
      MakeFileEntry.HelpContext := hctxPopupEditorMake;
      EditorPopup.Items.Add(MakeFileEntry);

      Entry.Create(EditorPopup);
      Entry.Caption := '-';
      EditorPopup.Items.Add(Entry);

      AddMenueEntries(cmCut, 0, CutEntry);
      AddMenueEntries(cmCopy, 0, CopyEntry);
      AddMenueEntries(cmPaste, 0, PasteEntry);
      AddMenueEntries(cmDelete, 0, DeleteEntry);

      Entry.Create(EditorPopup);
      Entry.Caption := '-';
      EditorPopup.Items.Add(Entry);

      AddMenueEntries(cmToggleBreakPoint, hctxPopupEditorToggleBreak, BreakPointEntry);

      RunCursorEntry.Create(EditorPopup);
      RunCursorEntry.Caption := LoadNLSStr(SiEdPopupRunToCursor);
      RunCursorEntry.Command := cmGotoDebugCursor;
      RunCursorEntry.HelpContext := hctxPopupEditorGoToCursor;
      EditorPopup.Items.Add(RunCursorEntry);

      EvalModEntry.Create(EditorPopup);
      EvalModEntry.Caption := LoadNLSStr(SiEdPopupEvalModify);
      EvalModEntry.Command := cmEvaluateModify;
      EvalModEntry.HelpContext := hctxPopupEditorEvalModify;
      EditorPopup.Items.Add(EvalModEntry);

      AddMenueEntries(cmAddWatch, hctxPopupEditorAddWatch, AddWatchEntry);

      Entry.Create(EditorPopup);
      Entry.Caption := '-';
      EditorPopup.Items.Add(Entry);

      ReadOnlyEntry.Create(EditorPopup);
      ReadOnlyEntry.Caption := LoadNLSStr(SiEdPopupReadOnly);
      ReadOnlyEntry.Command := cmToggleReadOnly;
      ReadOnlyEntry.HelpContext := hctxPopupEditorReadOnly;
      EditorPopup.Items.Add(ReadOnlyEntry);

      ControlCentreEntry.Create(EditorPopup);
      ControlCentreEntry.Caption := LoadNLSStr(SiEdPopupMessageWindow);
      ControlCentreEntry.Command := cmToggleMsgView;
      ControlCentreEntry.HelpContext := hctxPopupEditorMessageWindow;
      EditorPopup.Items.Add(ControlCentreEntry);

      Entry.Create(EditorPopup);
      Entry.Caption := '-';
      EditorPopup.Items.Add(Entry);

      Entry.Create(EditorPopup);
      Entry.Caption := LoadNLSStr(SiEdPopupProperties);
      Entry.Command := cmEditorProperties;
      Entry.HelpContext := hctxPopupEditorProperties;
      EditorPopup.Items.Add(Entry);
    END;

  TopEdit:=GetTopEditor;
  CutEntry.Enabled   := (TopEdit <> NIL) AND (TopEdit.Selected);
  CopyEntry.Enabled  := (TopEdit <> NIL) AND (TopEdit.Selected);
  PasteEntry.Enabled := (TopEdit <> NIL) AND (ClipBoard.IsFormatAvailable(cfText));
  DeleteEntry.Enabled:= (TopEdit <> NIL) AND (TopEdit.Selected);

  s := Editor.GetFileAtCursorName;
  OpenFileEntry.Caption := FmtLoadNLSStr(SiEdPopupOpenFile,[s]);
  OpenFileEntry.Enabled := s <> '';

  s := Editor.GetWord(Editor.CursorPos);
  TopicEntry.Caption := LoadNLSStr(SiEdPopupTopicSearch) +'  '+#39+ s +#39;
  TopicEntry.Enabled := s <> '';

//  FSplit(Editor.FileName,d,n,e);
//  s := n+e;
  s:=ExtractFileName(Editor.FileName);
  CompileFileEntry.Caption := FmtLoadNLSStr(SiEdPopupCompileFile,[s]);
  CompileFileEntry.Enabled := ProjectLoaded AND (not CompilerActive) AND (not InDebugger) AND (GetCompileName <> '');
//CompileFileEntry.Enabled := ProjectLoaded AND (not CompilerActive) AND (GetCompileName <> '');
  ReOpenFileEntry.Caption := FmtLoadNLSStr(SiEdPopupReOpenFile,[s]);
  ReOpenFileEntry.Enabled := s <> '';

//  FSplit(GetMakeName,d,n,e);
//  MakeFileEntry.Caption := FmtLoadNLSStr(SiEdPopupMakeFile,[n+e]);
  s:=ExtractFileName(GetMakeName);
  MakeFileEntry.Caption := FmtLoadNLSStr(SiEdPopupMakeFile,[s]);
  MakeFileEntry.Enabled := ProjectLoaded AND (not CompilerActive) AND (not InDebugger) AND (GetCompileName <> '');

  BreakPointEntry.Enabled := ProjectLoaded AND (TopEditor <> NIL) AND (not DebuggerRunning);

  RunCursorEntry.Enabled := ProjectLoaded AND (not CompilerActive) AND (not DebuggerRunning);

  EvalModEntry.Enabled := ProjectLoaded AND (not DebuggerRunning) AND InDebugger;
{
  MakeFileEntry.Enabled := ProjectLoaded AND (not CompilerActive) AND (GetCompileName <> '');
  BreakPointEntry.Enabled := False;
  RunCursorEntry.Enabled := False;
  EvalModEntry.Enabled := False;}

  AddWatchEntry.Enabled := ProjectLoaded;

  ReadOnlyEntry.Checked := Editor.ReadOnly;

  ControlCentreEntry.Checked := ControlCentre.DockingState <> dsHide;
  ControlCentreEntry.Enabled := CanSwitchDockingState;

  pt := Editor.ClientToScreen(Forms.Point(X,Y));
  EditorPopup.Popup(pt.X,pt.Y);
END;


PROCEDURE TCodeEditor.AddGlobalMacro;
VAR  i:LONGINT;
     NewList:TList;
     s:STRING;
BEGIN
  IF MacroList = NIL THEN exit;
  IF TopEditor <> NIL THEN
  BEGIN
       IF TopEditor.MacroRecording OR TopEditor.MacroPlaying THEN exit;
       s := TopEditor.GetWord(TopEditor.CursorPos);
  END
  ELSE s := '';

  {New Name Dialog}
  IF not NewMacroName(s) THEN exit;

  {Macro kopieren}
  NewList.Create;
  FOR i := 0 TO MacroList.Count-1 DO NewList.Add(MacroList.Items[i]);
  GlobalMacroList.AddObject(s,NewList);

  IF MacroWindow <> NIL THEN MacroWindow.InsertMacro(s,NewList);
  Project.Modified := TRUE;
END;

PROCEDURE TCodeEditor.Redraw(CONST rec:TRect);
VAR  rc1:TRect;
BEGIN
  rc1 := ClientRect;
  DrawSystemBorder(SELF,rc1,bsSingle);
  Canvas.ClipRect := Forms.IntersectRect(Canvas.ClipRect,rc1);
  Inherited Redraw(rec);
END;


FUNCTION TCodeEditor.GetTopEditor:TSibEditor;
BEGIN
  Result := TSibEditor(ActiveMDIChild);
END;


FUNCTION TCodeEditor.GetMessages:TStringList;
BEGIN
  IF BuildList <> NIL
    THEN Result := TStringList(BuildList.Items)
    ELSE Result := NIL;
END;


{$HINTS OFF}
PROCEDURE TCodeEditor.EvCompileThreadEnded(Sender:TObject);
VAR Thread:TThread;
BEGIN
  CompilerTerminate := TRUE;

  PostMsg(Handle,cmNull,0,0);  {force to leave the message loop}

  IF Sender <> NIL THEN
  BEGIN
       Thread := TThread(Sender);
       Thread.Destroy;
  END;
END;
{$HINTS ON}


PROCEDURE TCodeEditor.OpenMsgWindow(VAR Msg:TMessage);
BEGIN
  ShowControlCentre(BuildIndex,NoFokus);
  EvMsgFocused(BuildList,Msg.Param1);
  EvMsgSelected(BuildList,Msg.Param1);
END;


PROCEDURE TCodeEditor.DragOver(Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);
VAR  ExtDDO:TExternalDragDropObject;
     FName:STRING;
BEGIN
  Accept := FALSE;

  IF Source IS TExternalDragDropObject THEN
    BEGIN
      ExtDDO := TExternalDragDropObject(Source);
      IF ExtDDO.SupportedOps * [doCopyable,doMoveable] = [] THEN exit;
      IF ExtDDO.DragOperation IN [doLink,doUnknown] THEN exit;
      IF ExtDDO.RenderType <> drmFile THEN exit;
      {drtText abtesten ??}

      FName := ExtDDO.ContainerName;
      IF FName <> '' THEN
        IF FName[Length(FName)] <> '\' THEN FName := FName + '\';
      FName := FName + ExtDDO.SourceFileName;
      IF not FileExists(FName) THEN exit;
    END
  ELSE exit;
  Accept := TRUE;
END;


PROCEDURE TCodeEditor.DragDrop(Source:TObject;X,Y:LONGINT);
VAR  ExtDDO:TExternalDragDropObject;
     FName:STRING;
BEGIN
  Inherited DragDrop(Source,X,Y);
  IF Source IS TExternalDragDropObject THEN
  BEGIN
       ExtDDO := TExternalDragDropObject(Source);
       IF ExtDDO.SupportedOps * [doCopyable,doMoveable] = [] THEN exit;
       IF ExtDDO.DragOperation IN [doLink] THEN exit;
       IF ExtDDO.RenderType <> drmFile THEN exit;

       FName := ExtDDO.ContainerName;
       IF FName <> '' THEN
         IF FName[Length(FName)] <> '\' THEN FName := FName + '\';
       FName := FName + ExtDDO.SourceFileName;
       IF not FileExists(FName) THEN exit;
  END
  ELSE exit;
  LoadEditor(FName,0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
END;


/////////////////////////////////////////////////////////////////////////////
//
//  General Functions
//
/////////////////////////////////////////////////////////////////////////////

PROCEDURE SetEditorPos(Edit,TopEdit:TEditor; x,y,w,h:LONGINT);
VAR  xDiv,yDiv:LONGINT;
     rec:TRect;
     fullsize:BOOLEAN;
BEGIN
  IF Edit = NIL THEN exit;
  fullsize := FALSE;
  IF (w < MinEditorWidth) OR (h < MinEditorHeight) THEN {cascade it}
    BEGIN
      IF TopEdit IS TEditor THEN
        BEGIN
          xDiv:=goSysInfo.Screen.BorderSize.CX;
          inc(xDiv, goSysInfo.Screen.TitlebarSize);
          yDiv:=goSysInfo.Screen.BorderSize.CY;
          inc(yDiv, goSysInfo.Screen.TitlebarSize);

          x := TopEdit.Left + xDiv;
          y := TopEdit.Bottom;
          w := TopEdit.Width - xDiv;
          h := TopEdit.Height - yDiv;
          IF w < MinEditorWidth THEN fullsize := TRUE;
          IF h < MinEditorHeight THEN fullsize := TRUE;
        END
      ELSE fullsize := TRUE;
  END;
  {Test ob Window zu groแ fr den Clientbereich der IDE}

  IF x + w > CodeEditorRef.ClientWidth THEN fullsize := TRUE;
  IF y + h > CodeEditorRef.ClientHeight THEN fullsize := TRUE;

  IF fullsize THEN
    BEGIN
      rec := CodeEditorRef.ClientRect;
      x := rec.Left;
      y := rec.Bottom;
      w := rec.Right - rec.Left +1;
      h := rec.Top - rec.Bottom +1;
    END;
  Edit.SetWindowPos(x,y,w,h);
END;


FUNCTION LoadEditor(Name:STRING;x,y,w,h:LONGINT;LiX:BOOLEAN;fcx:TEditorPos;
                    Fokus:BOOLEAN;ShowIt:BOOLEAN):TSibEditor;
VAR  DirInfo: tSearchRec;  // Dos.SearchRec;
     TopEdit: TSibEditor;
     d,n,e  : STRING;
BEGIN
//  Application.LogWriteln('sib_edit.LoadEditor:'+Name);
  WDSibylThrd.Suspend;    // Den Thread kurz anhalten
  Name := FExpand(Name);
  RemoveMenuItem(Name, Project.FilesHistory, cmLastFile1, cmLastFileN,
                 cmFileMenu, MaxFileMenu, MaxHistoryFiles);

  WHILE pos('\\',Name) > 0 DO
    delete(Name,pos('\\',Name),1); //entferne Mll

  Result := GetEditor(Name);

  IF Result = NIL THEN
  BEGIN
    IF (LiX) and (FileExists(Name)=false) THEN exit;
    TopEdit := CodeEditor.TopEditor;

    {dont change the editor font}
    CodeEditor.GlobalFontChange := TRUE;

    Result := TSibEditor.Create(CodeEditor);
    IF Result = NIL THEN exit;

    {get original name}
    if SysUtils.FindFirst(Name, faAnyFile, DirInfo)=0 then
      Begin
        d:=ExtractFilePath(Name);
        Name := DirInfo.Name;
        IF pos('\',Name) = 0 THEN Name := d + Name;
        SysUtils.FindClose(DirInfo);
      End;
    Result.FileName := Name;   {set FileName for SetupShow}
    Result.FIgnoreFileNameUpdate := TRUE;
    Result.FormStyle := fsMDIChild;
    CodeEditorRef.InsertControl(Result);
    Result.Icon := EditIcon;

    InitializeEditor(Result);
    SetEditorPos(Result,TopEdit,x,y,w,h);
    Result.LoadFromFile(Name);
    Result.FIgnoreFileNameUpdate := FALSE;
    IF fcx <> CursorIgnore THEN Result.GotoPosition(fcx);
    IF ShowIt THEN
      BEGIN
        Result.Visible := TRUE;
        Result.Update;
      END;
    IF ReadOnlyFileIndex(Name) >= 0 THEN Result.ReadOnly := TRUE;

    CodeEditor.GlobalFontChange := FALSE;

    IF not Project.Loading THEN Project.Modified := TRUE;
  END
  ELSE IF fcx <> CursorIgnore THEN Result.GotoPosition(fcx);

  IF Fokus AND ShowIt THEN
    BEGIN
      Result.BringToFront;
      Result.Focus;
    END;
  WDSibylThrd.Resume;
//  Application.LogWriteln('sib_edit.LoadEditor-Ende');
END;


FUNCTION GetEditor(Name:STRING):TSibEditor;
VAR  t:LONGINT;
     Control:TSibEditor;
BEGIN
//  Application.LogWriteln('sib_edit.GetEditor:'+Name);
  Result := NIL;
  IF CodeEditorRef = NIL THEN exit;   //beim VDE Start

  UpcaseStr(Name);
  FOR t := 0 TO CodeEditorRef.MDIChildCount-1 DO
    BEGIN
      Control := TSibEditor(CodeEditorRef.MDIChildren[t]);
      IF Control IS TEditor THEN
        IF Name = Upcased(Control.FileName) THEN
          BEGIN
            Result := TSibEditor(Control);
            exit;
          END;
    END;
//  Application.LogWriteln('sib_edit.GetEditor-Ende');
END;


PROCEDURE InitializeEditor(Edit:TSibEditor);
VAR  t:LONGINT;
BEGIN
  IF Edit = NIL THEN     {all editors}
    BEGIN
      FOR t := 0 TO CodeEditorRef.MDIChildCount-1 DO
        BEGIN
          Edit := TSibEditor(CodeEditorRef.MDIChildren[t]);
          IF Edit IS TSibEditor THEN Edit.Init;
        END;
    END
  ELSE IF Edit IS TSibEditor THEN Edit.Init;
END;


FUNCTION Key(idx:BYTE):STRING;
BEGIN
  Result := Bezeichner[idx];

  CASE IdeSettings.CodeGen.IdentifierStyle OF
    is_Uppercase: UpcaseStr(Result);               {BEZEICHNER}
    is_Mixed:     Result[1] := Upcase(Result[1]);  {Bezeichner}
    is_Lowercase: ;                                {bezeichner}
  END;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: My FindText Dialog                                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE TMyFindTextDialog=CLASS(TFindDialog)
       PRIVATE
          RaB_AllEditors:TRadioButton;
          FUNCTION  GetFindScope:TFindScope;
          PROCEDURE SetFindScope(Value:TFindScope);
       PROTECTED
          PROCEDURE SetupComponent;OVERRIDE;
       PUBLISHED
          PROPERTY AddScope:TFindScope read GetFindScope write SetFindScope;
     END;


PROCEDURE TMyFindTextDialog.SetupComponent;
VAR  i:LONGINT;
     Control:TControl;
     s:STRING;
BEGIN
     Inherited SetupComponent;
     {suche 'Scope'}
     s:=LoadNLSStr(SScope);
     FOR i := 0 TO ControlCount-1 DO
     BEGIN
          Control := Controls[i];
          IF Control.Caption = s THEN
          BEGIN
               Control.SetWindowPos(230,150,180,95);  {Group 'Scope'}

               RaB_AllEditors := InsertRadioButtonNLS(Control,15,50,160,20,SiAllEditors,0);
               RaB_AllEditors.TabOrder := 0;
               break;
          END;
     END;
END;


FUNCTION TMyFindTextDialog.GetFindScope:TFindScope;
BEGIN
  IF RaB_AllEditors.Checked
    THEN Result := TFindScope(fs_AllEditors)
    ELSE Result := Scope;
END;

PROCEDURE TMyFindTextDialog.SetFindScope(Value:TFindScope);
BEGIN
  IF Value = TFindScope(fs_AllEditors)
    THEN RaB_AllEditors.Checked := TRUE
    ELSE Scope := Value;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: My ReplaceText Dialog                                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TMyReplaceTextDialog=CLASS(TReplaceDialog)
      PRIVATE
         RaB_AllEditors:TRadioButton;
         FUNCTION  GetFindScope:TFindScope;
         PROCEDURE SetFindScope(Value:TFindScope);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
      PUBLISHED
         PROPERTY AddScope:TFindScope read GetFindScope write SetFindScope;
    END;


PROCEDURE TMyReplaceTextDialog.SetupComponent;
VAR  i:LONGINT;
     Control:TControl;
     s:STRING;
BEGIN
     Inherited SetupComponent;
     {suche 'Scope'}
     s:=LoadNLSStr(SScope);
     FOR i := 0 TO ControlCount-1 DO
     BEGIN
          Control := Controls[i];
          IF Control.Caption = s THEN
          BEGIN
               Control.SetWindowPos(230,150,180,95);  {Group 'Scope'}

               RaB_AllEditors := InsertRadioButtonNLS(Control,15,50,160,20,SiAllEditors,0);
               RaB_AllEditors.TabOrder := 0;
               break;
          END;
     END;
END;


FUNCTION TMyReplaceTextDialog.GetFindScope:TFindScope;
BEGIN
     IF RaB_AllEditors.Checked THEN Result := TFindScope(fs_AllEditors)
     ELSE Result := Scope;
END;

PROCEDURE TMyReplaceTextDialog.SetFindScope(Value:TFindScope);
BEGIN
     IF Value = TFindScope(fs_AllEditors) THEN RaB_AllEditors.Checked := TRUE
     ELSE Scope := Value;
END;


/////////////////////////////////////////////////////////////////////////////
//
//  IDE-Editor
//
/////////////////////////////////////////////////////////////////////////////

PROCEDURE TSibEditor.TranslateShortCut(Keycode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Inherited TranslateShortCut(KeyCode,Receiver);

     IF KeyCode IN [kbAltGraf,kbAltF4,kbAltF5,kbAltF7,kbAltF8,kbAltF9,
                    kbAltF10,kbAltF11] THEN
       IF not CodeEditor.MDIBehaviour THEN Receiver := CodeEditor;

     IF Keycode = kbShiftF10 THEN
     BEGIN
          OpenContextMenuAtCursor;
     END;
END;


PROCEDURE TSibEditor.CharEvent(VAR Key:CHAR;RepeatCount:BYTE);
VAR  Star:CHAR;
     OldKey:CHAR;
     Item:CHAR;
BEGIN
  StopWatchTimer;
  ResetErrorLine;
  IF ReadOnly THEN exit;

  OldKey := Key;

  IF FExtraOpt * [eoAutoBracket] <> [] THEN {auto insert closing item}
    IF ClosingItem <> ' ' THEN
      IF ClosingItem <> OldKey THEN
        BEGIN
          Item := ClosingItem;
          Inherited CharEvent(Item, RepeatCount);
          cmCursorLeft;
        END;

  Inherited CharEvent(Key, RepeatCount);

  IF FExtraOpt * [eoAutoBracket] <> [] THEN
    IF OldKey = '*' THEN
      IF ClosingItem = ')' THEN
        BEGIN
          Star := '*';
          Inherited CharEvent(Star,RepeatCount);
          cmCursorLeft;
        END;


  IF FExtraOpt * [eoAutoBracket] <> [] THEN
    CASE OldKey OF
      '(': ClosingItem := ')';
      '[': ClosingItem := ']';
      '{': ClosingItem := '}';
      ELSE ClosingItem := ' ';
    END;

  IF CodeParameterBubble <> NIL THEN UpdateCodeParameterBubble;

  IF OldKey IN ['(','['] THEN
    IF CodeParameterBubble = NIL THEN StartCodeParameterTimer;

  IF OldKey = '.'
    THEN StartCodeCompletionTimer
    ELSE StopCodeCompletionTimer;
END;


PROCEDURE TSibEditor.ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);
BEGIN
     StopWatchTimer;
     ResetErrorLine;
     IF KeyCode <> kbShift THEN ClosingItem := ' ';

     IF Not (KeyCode IN [kbCLeft,kbCRight,kbShift,kbCtrl,kbBkSp,kbDel,kbEnd,kbHome])
     THEN StopCodeParameterTimer;

     Inherited ScanEvent(KeyCode,RepeatCount);

     IF CodeParameterBubble <> NIL THEN UpdateCodeParameterBubble;

     StopCodeCompletionTimer;

     IF KeyCode <> kbNull
     THEN TSibylForm(Application.MainForm).ScanEvent(KeyCode,RepeatCount);
     KeyCode := kbNull;
END;


FUNCTION TSibEditor.QueryConvertPos(VAR pos:TPoint):BOOLEAN;
BEGIN
     IF LastFind = faIncSearch THEN
     BEGIN
          pos.X := 0;
          pos.Y := 0;
          Result := TRUE;
     END
     ELSE Result := Inherited QueryConvertPos(pos);
END;


FUNCTION TSibEditor.EmulateWordStar(VAR KeyCode,PreControl:TKeyCode):BOOLEAN;
VAR  Pre:TKeyCode;
BEGIN
  Result := TRUE;
  Pre := PreControl;
  PreControl := 0;

  CASE KeyCode OR Pre OF
    kbCtrlOO: InsertCompileOpt;
    kbCtrlOG: GotoLineDialogProc;
    {kbCtrlOB: BrowseSymbol;}
    {$IFDEF OS2}
    kbCtrlEnter,
    {$ENDIF}
    kbCtrlCR: cmLoadUnit;
    kbCtrlTab: CodeEditorRef.Next;
    kbCtrlShiftTab: CodeEditorRef.Previous;
    kbCtrlJ: CodeEditor.ShowControlCentre(-1,Fokus);
    kbAltCUp: cmICBUpcaseHIL;
    kbAltCDown: cmICBDowncaseHIL;
    kbCtrlM: CodeEditor.SetMDIMode(not CodeEditor.MDIBehaviour);
    kbCtrlQW: GotoLastError;
    kbCtrlQP: SetMainStatusText(LastParserError,clRed,clLtGray);
    kbCtrlBracket1: InsertBrackets('(',')');
    kbCtrlBracket2: InsertBrackets('[',']');
    kbCtrlBracket3: InsertBrackets('{','}');
    kbCtrlBracket4: InsertBrackets('(*','*)');
    kbCtrlBracket5: InsertBrackets('/*','*/');
    kbCtrlBracket6: CBCommentBlock;
    kbCtrlShiftM: InitMacroList;
    kbCtrlShiftA: CodeEditor.AddGlobalMacro;
    kbCtrlShiftJ: ReplaceCodeTemplate;         // Code mittels CodeInsight ersetzen
    kbCtrlShiftIns: InitClipBoardWindow;
    ELSE
      BEGIN
        PreControl := Pre;
        Result := Inherited EmulateWordStar(KeyCode,PreControl);
      END;
  END;
END;


FUNCTION TSibEditor.EmulateCUA(VAR KeyCode,PreControl:TKeyCode):BOOLEAN;
VAR  Pre:TKeyCode;
BEGIN
  Result := TRUE;
  Pre := PreControl;
  PreControl := 0;

  CASE KeyCode OR Pre OF
    kbCtrlF7: Result := FALSE; //ignoriere Editor Kommando
    kbCtrlF8: Result := FALSE; //ignoriere Editor Kommando
    kbCtrlOO: InsertCompileOpt;
    kbCtrlOG: GotoLineDialogProc;
    {kbCtrlOB: BrowseSymbol;}
    {$IFDEF OS2}
    kbCtrlEnter,
    {$ENDIF}
    kbCtrlCR: cmLoadUnit;
    kbCtrlShiftU: cmICBMoveLeft;
    kbCtrlShiftI: cmICBMoveRight;
    kbCtrlTab: CodeEditorRef.Next;
    kbCtrlShiftTab: CodeEditorRef.Previous;
    kbCtrlJ: CodeEditor.ShowControlCentre(-1,Fokus);
    kbAltCUp: cmICBUpcaseHIL;
    kbAltCDown: cmICBDowncaseHIL;
    kbCtrlM: CodeEditor.SetMDIMode(not CodeEditor.MDIBehaviour);
    kbCtrlQW: GotoLastError;
    kbCtrlQP: SetMainStatusText(LastParserError,clRed,clLtGray);
    kbCtrlBracket1: InsertBrackets('(',')');
    kbCtrlBracket2: InsertBrackets('[',']');
    kbCtrlBracket3: InsertBrackets('{','}');
    kbCtrlBracket4: InsertBrackets('(*','*)');
    kbCtrlBracket6: CBCommentBlock;
    kbCtrlShiftM: InitMacroList;
    kbCtrlShiftA: CodeEditor.AddGlobalMacro;
    kbCtrlShiftJ: ReplaceCodeTemplate;
    kbCtrlShiftIns: InitClipBoardWindow;
    ELSE
      BEGIN
        PreControl := Pre;
        Result := Inherited EmulateCUA(KeyCode,PreControl);
      END;
  END;
END;

FUNCTION TSibEditor.EmulateDefault(VAR KeyCode,PreControl:TKeyCode):BOOLEAN;
VAR  Pre:TKeyCode;
BEGIN
  Result := TRUE;
  Pre := PreControl;
  PreControl := 0;
  CASE KeyCode OR Pre OF
    kbCtrlOO: InsertCompileOpt;
    kbCtrlOG: GotoLineDialogProc;
    {kbCtrlOB: BrowseSymbol;}
    kbF3: cmSearchTextAgain;
    {$IFDEF OS2}
    kbCtrlEnter,
    {$ENDIF}
    kbCtrlCR,kbCtrlOA: cmLoadUnit;
    kbCtrlTab: CodeEditorRef.Next;
    kbCtrlShiftTab: CodeEditorRef.Previous;
    kbCtrlJ: CodeEditor.ShowControlCentre(-1,Fokus);
    kbAltCUp: cmICBUpcaseHIL;
    kbAltCDown: cmICBDowncaseHIL;
    kbCtrlM: CodeEditor.SetMDIMode(not CodeEditor.MDIBehaviour);
    kbCtrlQW: GotoLastError;
    kbCtrlQP: SetMainStatusText(LastParserError,clRed,clLtGray);
    kbCtrlBracket1: InsertBrackets('(',')');
    kbCtrlBracket2: InsertBrackets('[',']');
    kbCtrlBracket3: InsertBrackets('{','}');
    kbCtrlBracket4: InsertBrackets('(*','*)');
    kbCtrlBracket5: InsertBrackets('/*','*/');
    kbCtrlBracket6: CBCommentBlock;
    kbCtrlShiftM: InitMacroList;
    kbCtrlShiftA: CodeEditor.AddGlobalMacro;
    kbCtrlShiftJ: ReplaceCodeTemplate;        // Code mittels CodeInsight ersetzen
    kbCtrlShiftIns: InitClipBoardWindow;
    ELSE
      BEGIN
        PreControl := Pre;
        Result := Inherited EmulateDefault(KeyCode,PreControl);
      END;
  END;
END;

PROCEDURE TSibEditor.cmEnter;
VAR  s,leftword:STRING;
     ch:CHAR;
     i:INTEGER;
BEGIN
     leftword := Upcased(GetWord(CursorPos));
     ch := GetChar(CursorPos);
     Inherited cmEnter;

     IF FExtraOpt * [eoAddIndentMode] <> [] THEN
       IF EditOptions * [eoAutoIndent] <> [] THEN
         IF ch = ' ' THEN {cursor is behind the word}
           IF (leftword = 'BEGIN') OR
              (leftword = 'EXCEPT') OR
              (leftword = 'FINALLY') OR
              (leftword = 'REPEAT') OR
              (leftword = 'RECORD') OR
              (leftword = 'EXPORTS') OR
              (leftword = 'TRY') OR
              (leftword = 'CONST') OR
              (leftword = 'TYPE') OR
              (leftword = 'VAR') OR
              (leftword = 'OF') THEN
     BEGIN
          s := Lines[CursorPos.Y];
          insert(IndentBlock,s,CursorPos.X);
          Lines[CursorPos.Y] := s;
          FOR i := 1 TO Length(IndentBlock) DO cmCursorRight;
          InvalidateWorkLine;
     END;
END;


PROCEDURE TSibEditor.cmRecordMacro;
BEGIN
     IF MacroPlaying THEN exit;

     Inherited cmRecordMacro;
     UpdateEditorState;

     IF not MacroRecording THEN
     BEGIN
          IF CodeEditor.MacroList <> NIL THEN CodeEditor.MacroList.Destroy;
          CodeEditor.MacroList := MacroList;
          MacroList := NIL;
     END;
END;


PROCEDURE TSibEditor.cmPlayMacro;
BEGIN
     IF MacroPlaying THEN exit;
     IF MacroRecording THEN exit;

     MacroList := CodeEditor.MacroList;

     Inherited cmPlayMacro;
     UpdateEditorState;

     MacroList := NIL;
END;


PROCEDURE TSibEditor.InsertCompileOpt;
VAR
  s:STRING;
  CompOpt:^TCompilerOptions;
  MemSizes:^TMemorySizes;
  WarnOpt:^TWarningOptions;
  DebugOpt:^TDebuggerOptions;

  PROCEDURE AddCompFlag(plus:BOOLEAN; CONST letter:STRING);
  CONST BoolArray:ARRAY[FALSE..TRUE] OF Char = ('-','+');
  BEGIN
    s := s + letter + BoolArray[plus] + ',' + IndentSpace;
  END;

BEGIN
  Case Project.Settings.Platform OF
      pf_OS2:
      BEGIN
           CompOpt:=@Project.Settings.CompOptOS2;
           WarnOpt:=@Project.Settings.WarnOptOS2;
           DebugOpt:=@Project.Settings.DebugOptOS2;
           MemSizes:=@Project.Settings.MemSizesOS2;
      END;
      pf_WIN32:
      BEGIN
           CompOpt:=@Project.Settings.CompOptWin;
           WarnOpt:=@Project.Settings.WarnOptWin;
           DebugOpt:=@Project.Settings.DebugOptWin;
           MemSizes:=@Project.Settings.MemSizesWin;
      END;
  END;

  s := '{$';

//?   {DoubleWord Align}
  AddCompFlag(TRUE, 'A');

  {Complete Boolean Evaluation}
  AddCompFlag(sx_CompleteBoolEval IN CompOpt^.Syntax, 'B');

  {Generate Debug Zeilen Info}
  AddCompFlag(di_LineNumbers IN DebugOpt^.Info, 'D');

//?   {Ansi Strings}
  AddCompFlag(FALSE, 'H');

  {IO Check}
  AddCompFlag(rc_InOut IN CompOpt^.Runtime, 'I');

  {Generate Debug Local Symbol Info}
  AddCompFlag(di_LocalSymbols IN DebugOpt^.Info, 'L');

//?   {Nice Names}
  AddCompFlag(FALSE, 'M');

  {Optimize}
  s := s + 'O' + tostr(BYTE(CompOpt^.Optimize)) + ',';

  {Overflow Check}
  AddCompFlag(rc_Overflow IN CompOpt^.Runtime, 'Q');

  {Range Check}
  AddCompFlag(rc_Range IN CompOpt^.Runtime, 'R');

  {Stack Check}
  AddCompFlag(rc_Stack IN CompOpt^.Runtime, 'S');

//?   {Use32 - Integer Compatibility}
  AddCompFlag(FALSE, 'U');

  {Strict VAR Check}
  AddCompFlag(sx_StrictVAR IN CompOpt^.Syntax, 'V');

  {Warnings}
  IF w_wall IN WarnOpt^.Warnings THEN AddCompFlag(TRUE, 'WA')
  ELSE
  IF w_wnone IN WarnOpt^.Warnings THEN AddCompFlag(FALSE, 'WA')
  ELSE
  BEGIN
    AddCompFlag(w_w1 IN WarnOpt^.Warnings, 'W1');
    AddCompFlag(w_w2 IN WarnOpt^.Warnings, 'W2');
    AddCompFlag(w_w3 IN WarnOpt^.Warnings, 'W3');
    AddCompFlag(w_w4 IN WarnOpt^.Warnings, 'W4');
    AddCompFlag(w_w5 IN WarnOpt^.Warnings, 'W5');
    AddCompFlag(w_w6 IN WarnOpt^.Warnings, 'W6');
    AddCompFlag(w_w7 IN WarnOpt^.Warnings, 'W7');
  END;

  {Inline Strings}
  AddCompFlag(cg_InlineStrings IN CompOpt^.CodeGen, 'Z');

  BeginUpdate;
  {letztes Komma entfernen}
  SetLength(s, Length(s)-1-Length(IndentSpace));
  s := s + '}';
  InsertLine(1, s);

  s := '{$M ' + tostr(MemSizes^.Stack*1024) + ',' + IndentSpace +
                tostr(MemSizes^.Heap*1024) + '}';
  InsertLine(2, s);
  EndUpdate;

  cmCursorFileBegin; {!!}
END;


PROCEDURE TSibEditor.ReplaceCodeTemplate;
// Code mittels CodeInsight ersetzen

VAR  s,s1,sj:STRING;
     pct:PCodeTemplate;
     i,j:LONGINT;
     x,p,px,py:LONGINT;
     ep:TEditorPos;

BEGIN
  //s := UpperCase(GetWord(CursorPos));
  s := Lines[CursorPos.Y];
  FOR i := Length(s) TO CursorPos.X-1 DO
    s := s + ' ';
  IF s[CursorPos.X] <> ' ' THEN exit;

  x := CursorPos.X-1;
  s1 := '';
  WHILE (x > 0) DO
    BEGIN
      IF s[x] IN IdentifierChars
        THEN s1 := s[x] + s1
        ELSE break;
        dec(x);
    END;
  inc(x); // x zeigt auf das erste Zeichen
  UpcaseStr(s1);

  FOR i := 0 TO CodeTemplateList.Count-1 DO
    BEGIN
      pct := CodeTemplateList.Items[i];
      IF UpperCase(pct^.Name) = s1 THEN // found
        BEGIN
          px := 0;
          py := 0;
          BeginUpdate;
          FOR j := 0 TO pct^.Strings.Count-1 DO
            BEGIN
               sj := pct^.Strings[j];
               p := pos('|',sj);
               IF p > 0 THEN
                 BEGIN
                   Delete(sj,p,1);
                   px := p;
                   py := j;
                 END;

               IF j = 0
                 THEN
                   BEGIN
                     Delete(s,x,Length(s1));
                     Insert(sj,s,x);
                     Lines[CursorPos.Y+j] := s;
                   END
                 ELSE
                   BEGIN
                     s := StringOfChars(' ',x-1) + sj;
                     InsertLine(CursorPos.Y+j, s);
                   END;
            END;
          ep.X := x + px -1;
          ep.Y := CursorPos.Y + py;
          GotoPosition(ep);
          EndUpdate;

          exit;
        END;
    END;
END;


PROCEDURE TSibEditor.StartCodeCompletionTimer;
BEGIN
     IF Not IdeSettings.CodeInsight.CodeCompletion THEN exit;

     IF CodeCompletionTimer = NIL THEN
     BEGIN
          CodeCompletionTimer.Create(SELF);
          CodeCompletionTimer.Interval := IdeSettings.CodeInsight.TimerValue;
          CodeCompletionTimer.OnTimer := EvCodeCompletionTimer;
     END;
     CodeCompletionTimer.Start;
END;


PROCEDURE TSibEditor.StopCodeCompletionTimer;
VAR  Temp:TControl;
BEGIN
     IF CodeCompletionTimer <> NIL THEN CodeCompletionTimer.Stop;

     IF CodeCompletionListBox <> NIL THEN
     BEGIN
          Temp := CodeCompletionListBox;
          CodeCompletionListBox := NIL;
          Temp.Destroy;
     END;
END;


FUNCTION EvaluateIdentifierQualification(CONST s:String; VAR x:Integer;
  VAR Identifier:String; VAR Qualifier:String):BOOLEAN;
VAR  Lmax,Ls:Integer;
BEGIN
     Result := FALSE;

     Lmax := x - 1;  // Zeichen vor '('
     Ls := Lmax;
     // skip Spaces
     WHILE (Ls > 0) AND (s[Ls] = ' ')
        DO dec(Ls);
     // read Identifier
     WHILE (Ls > 0) AND (s[Ls] IN IdentifierChars)
        DO dec(Ls);
     inc(Ls); // Ls ist erstes gltiges Zeichen des Identifiers
     Identifier := Trim(Copy(s,Ls,Lmax-Ls+1));

     Lmax := Ls - 2;
     Ls := Lmax;
     WHILE (Ls > 0) AND (s[Ls] IN QualifiedIdentifierChars)
        DO dec(Ls);
     inc(Ls); // Ls ist erstes gltiges Zeichen des Qualifiers
     Qualifier := Trim(Copy(s,Ls,Lmax-Ls+1));

     Result := TRUE;
END;


FUNCTION TSibEditor.GetCurrentMethodClassName(von:TEditorPos):STRING;

  FUNCTION rightpos(Const SubStr:STRING; s:STRING):INTEGER;
  VAR  p:INTEGER;
  BEGIN
       //Result := pos(SubStr, S);
       Result := 0;
       REPEAT
            p := pos(SubStr, S);
            IF p > 0 THEN // teste WordOnly
            BEGIN
                 // linke Seite
                 IF p-1 > 0 THEN
                   IF (s[p-1] IN IdentifierChars) THEN
                   BEGIN
                        s[p] := #0;
                        continue;
                   END;
                 // rechte Seite
                 IF p+Length(SubStr) <= Length(s) THEN
                   IF (s[p+Length(SubStr)] IN IdentifierChars) THEN
                   BEGIN
                        s[p] := #0;
                        continue;
                   END;

                 s[p] := #0;
                 Result := p;
            END;
       UNTIL p = 0;
  END;

VAR  pl:PLine;
     i:LONGINT;
     s,look:STRING;
     p:INTEGER;
BEGIN
     Result := '';

     pl := PLines[von.Y];
     FOR i := von.Y DOWNTO 1 DO
     BEGIN
          IF pl = NIL THEN exit;
          s := RemoveRemarks(pl);
          IF i = von.Y THEN SetLength(s, von.X);

          look := 'FUNCTION';
          p := rightpos(look,s);
          IF p = 0 THEN
          BEGIN
               look := 'PROCEDURE';
               p := rightpos(look,s);
          END;
          IF p = 0 THEN
          BEGIN
               look := 'CONSTRUCTOR';
               p := rightpos(look,s);
          END;
          IF p = 0 THEN
          BEGIN
               look := 'DESTRUCTOR';
               p := rightpos(look,s);
          END;

          IF p > 0 THEN
          BEGIN
               // extract ClassName
               Delete(s,1,p-1+Length(look));
               s := Trim(s);
               FOR i := 1 TO Length(s) DO
               BEGIN
                    IF s[i] = '.' THEN
                    BEGIN
                         Result := Copy(s,1, i-1);
                         exit; // ClassName gefunden
                    END;
                    IF Not (s[i] IN IdentifierChars) THEN exit;
               END;
               exit;
          END;

          IF rightpos('CLASS',s) > 0 THEN
          BEGIN
               (*
               // "CLASS(ParentClassName)" abtesten
               Delete(s,1,p-1+Length(look));
               s := Trim(s);
               IF s[1] <> '(' THEN exit;
               Delete(s,1,1);
               FOR i := 1 TO Length(s) DO
               BEGIN
                    IF s[i] = ')' THEN
                    BEGIN
                         Result := Copy(s,1, i-1);
                         exit; // ParentClassName gefunden
                    END;
                    IF Not (s[i] IN IdentifierChars) THEN exit;
               END;
               *)
               exit;
          END;

          pl := pl^.prev;
     END;
END;


PROCEDURE TSibEditor.EvCodeCompletionTimer(Sender:TObject);
VAR  pt,truncPos:TPoint;
     identpos:TEditorPos;
     i:INTEGER;
     cx,cy:LONGINT;
     x:INTEGER;
     s,q:STRING;
     Qualifier:STRING;
     Identifier:STRING;
     ParameterList:TStringList;
BEGIN
  StopCodeCompletionTimer;

  //s := Lines[CursorPos.Y];
  s := RemoveRemarks(PLines[CursorPos.Y]);
  x := CursorPos.X-1;
  FOR i := Length(s) TO x-1 DO s := s + ' ';
    IF Not EvaluateIdentifierQualification(s,x,Identifier,Qualifier)
      THEN exit;
  q := GetCurrentMethodClassName(CursorPos);
  IF q <> ''
    THEN Qualifier := q + '|' + Qualifier;

  ParameterList.Create;
  ParameterList.Sorted:=true;
  IF not GetBrowserInfoProc(Qualifier,Identifier,TRUE,ParameterList) Then
    BEGIN
      ParameterList.Destroy;
      exit;
    END;

  {create Listbox}
  identpos.X := OffsetPos.X;
  identpos.Y := OffsetPos.Y;
  truncPos := GetMouseFromCursor(identpos);  {truncated Mouse Positon}
  pt := ClientToScreen(truncPos);

  IF CodeCompletionListBox = NIL THEN
    BEGIN
      CodeCompletionListBox.Create(NIL);
      CodeCompletionListBox.FEditor := SELF;
      CodeCompletionListBox.ZOrder := zoTop;
      CodeCompletionListBox.SetWindowPos(pt.X,pt.Y,0,0);
    END;
  CodeCompletionListBox.Items.Assign(ParameterList);
  CodeCompletionListBox.ItemIndex := 0;
  CodeCompletionListBox.Show;
  ParameterList.Destroy;

  cx := 300;
  cy := 6 * CodeCompletionListBox.ItemHeight + 6;
  dec(pt.Y, cy+2);
  IF pt.X + cx > Screen.Width
    THEN pt.X := Screen.Width - cx;
  IF pt.X <0
    THEN pt.X := 0;
  IF pt.Y + cy > Screen.Height
    THEN pt.Y := Screen.Height - cy;
  IF pt.Y < 0
    THEN pt.Y := 0;
  CodeCompletionListBox.SetWindowPos(pt.X,pt.Y,cx,cy);
  CodeCompletionListBox.FListBox.CaptureFocus;
END;


PROCEDURE TSibEditor.CloseCodeCompletion(VAR Msg:TMessage);
BEGIN
     TRY
        StopCodeCompletionTimer;
     FINALLY
        CodeCompletionListBox := NIL;
     END;
     CaptureFocus;
END;


PROCEDURE TSibEditor.CompleteCode(Code:String);
VAR  s:STRING;
     i:INTEGER;
     newpos:TEditorPos;
BEGIN
     s := Lines[CursorPos.Y];
     FOR i := Length(s) TO CursorPos.X -2 DO s := s + ' ';
     Insert(Code,s,CursorPos.X);
     Lines[CursorPos.Y] := s;
     newpos.X := CursorPos.X + Length(Code);
     newpos.Y := CursorPos.Y;
     GotoPosition(newpos);
     CaptureFocus;
END;


PROCEDURE TSibEditor.StartCodeParameterTimer;
BEGIN
  IF Not IdeSettings.CodeInsight.CodeParameter THEN exit;

  IF CodeParameterTimer = NIL THEN
    BEGIN
      CodeParameterTimer.Create(SELF);
      CodeParameterTimer.Interval := IdeSettings.CodeInsight.TimerValue;
      CodeParameterTimer.OnTimer := EvCodeParameterTimer;
    END;
  CodeParameterTimer.Start;
END;


PROCEDURE TSibEditor.StopCodeParameterTimer;
BEGIN
  IF CodeParameterTimer <> NIL THEN CodeParameterTimer.Stop;

  IF CodeParameterBubble <> NIL THEN
    BEGIN
      CodeParameterBubble.Destroy;
      CodeParameterBubble := NIL;
    END;
END;


FUNCTION GetCodeParameterList(Qualifier,Identifier:String; VAR Parameter:String;
  VAR ParameterCount:Integer):BOOLEAN;

Var  ParameterList:TStringList;
     i:LONGINT;

BEGIN
  ParameterList.Create;
  Result := GetBrowserInfoProc(Qualifier,Identifier,FALSE,ParameterList);
  IF Result THEN
    BEGIN
      Parameter := '';
      ParameterCount := ParameterList.Count;
      FOR i := 0 TO ParameterList.Count-1 DO
        BEGIN
          Parameter := Parameter + ParameterList[i];
          IF i < ParameterList.Count-1 THEN Parameter := Parameter +'; ';
        END;
    END;
  ParameterList.Destroy;
END;


// Returnwert von x ist Position der ”ffnenden Klammer
FUNCTION EvaluateCodeParameterList(CONST s:String; VAR x:Integer;
  VAR Identifier:String; VAR ParameterNo:Integer):BOOLEAN;
VAR  dummyStr:STRING;
     dummyInt:Integer;
     Ls,Lmax:INTEGER;
BEGIN
     Result := FALSE;

     IF s[x] = ',' THEN ParameterNo := 0
     ELSE ParameterNo := 1;

     IF s[x] IN ['(',')','[',']'] THEN dec(x);

     WHILE x > 0 DO
     BEGIN
          IF s[x] = ',' THEN inc(ParameterNo);
          IF s[x] IN ['(','['] THEN break;
          IF s[x] IN [')',']'] THEN
          BEGIN
            //dec(x);
            IF Not EvaluateCodeParameterList(s, x, dummyStr, dummyInt)
            THEN exit;
          END;
          dec(x);
     END;
     IF x < 1 THEN exit;

     Lmax := x - 1;  // Zeichen vor '('
     Ls := Lmax;
     // skip Spaces
     WHILE (Ls > 0) AND (s[Ls] = ' ')
        DO dec(Ls);
     // read Identifier
     WHILE (Ls > 0) AND (s[Ls] IN QualifiedIdentifierChars)
        DO dec(Ls);
     inc(Ls); // Ls ist erstes gltiges Zeichen des Identifiers
     Identifier := Trim(Copy(s,Ls,Lmax-Ls+1));

     Result := TRUE;
END;


PROCEDURE TSibEditor.UpdateCodeParameterBubble;
VAR  pt,truncPos:TPoint;
     identpos:TEditorPos;
     x,i:INTEGER;
     cx,cy:LONGINT;
     s,q:STRING;
     Identifier:STRING;
     Qualifier:STRING;
     Parameter:STRING;
     ParameterCount:Integer;
     ParameterNo:Integer;
BEGIN
//s := Lines[CursorPos.Y];
  s := RemoveRemarks(PLines[CursorPos.Y]);
  x := CursorPos.X;
  FOR i := Length(s) TO x-1 DO s := s + ' ';
(*
     // vorherige Zeilen mit betrachten
     WHILE y > 1 THEN
     BEGIN
          s1 := RemoveRemarks(PLines[y-1]);
          avail := 255-Length(s);
          IF avail < Length(s1) THEN Delete(s1,1,Length(s1)-avail);
          s := s1 + s;
          x := x + Length(s1);
          dec(y);
     END;
*)

  IF Not EvaluateCodeParameterList(s,x,Identifier,ParameterNo) THEN
    BEGIN
      StopCodeParameterTimer;
      exit;
    END;
  IF Not EvaluateIdentifierQualification(s,x,Identifier,Qualifier) THEN
    BEGIN
      StopCodeParameterTimer;
      exit;
    END;
  q := GetCurrentMethodClassName(CursorPos);
  IF q <> '' THEN Qualifier := q + '|' + Qualifier;
  IF Not GetCodeParameterList(Qualifier,Identifier,Parameter,ParameterCount) THEN
    BEGIN
      IF CodeParameterBubble <> NIL
        THEN
          BEGIN
            // Bubble war vorher schon da,
            // evtl. ist ein uแerer Ausdruck ist auswertbar
            // oder es war ein innerer Ausdruck auswertbar
            Parameter := '???';
            ParameterCount := 1;
            ParameterNo := 1;
          END
        ELSE
          BEGIN
            StopCodeParameterTimer;
            exit;
          END;
    END;
  IF ParameterNo > ParameterCount THEN
    BEGIN
      StopCodeParameterTimer;
      exit;
    END;

  {create Bubble}
  identpos.X := x;
  identpos.Y := OffsetPos.Y;
  truncPos := GetMouseFromCursor(identpos);  {truncated Mouse Positon}
  pt := ClientToScreen(truncPos);

  IF CodeParameterBubble = NIL THEN
    BEGIN
      CodeParameterBubble.Create(NIL);
      CodeParameterBubble.ZOrder := zoTop;
      CodeParameterBubble.SetWindowPos(pt.X,pt.Y,0,0);
      CodeParameterBubble.PenColor := clBlack;
      CodeParameterBubble.Color := clLtGray;
      CodeParameterBubble.Show;
    END;
  CodeParameterBubble.SetCodeParameter(Parameter,ParameterCount,ParameterNo);
  CodeParameterBubble.GetCaptionExtent(cx,cy);
  inc(cx,10);
  inc(cy,6);
  dec(pt.Y, cy+2);
  IF pt.X + cx > Screen.Width THEN pt.X := Screen.Width - cx;
  IF pt.X < 0 THEN pt.X := 0;
  IF pt.Y + cy > Screen.Height THEN pt.Y := Screen.Height - cy;
  IF pt.Y < 0 THEN pt.Y := 0;
  IF Parameter = '???' THEN pt.Y := -100; // verstecken
  CodeParameterBubble.SetWindowPos(pt.X,pt.Y,cx,cy);
END;


PROCEDURE TSibEditor.EvCodeParameterTimer(Sender:TObject);
BEGIN
  StopCodeParameterTimer;
  UpdateCodeParameterBubble;
END;


PROCEDURE TSibEditor.StartWatchTimer;
BEGIN
  IF WatchTimer = NIL THEN
    BEGIN
      WatchTimer.Create(SELF);
      WatchTimer.Interval := 300;
      WatchTimer.OnTimer := EvWatchTimer;
    END;
  WatchTimer.Start;
END;


PROCEDURE TSibEditor.StopWatchTimer;
BEGIN
  IF WatchBubble <> NIL THEN
    BEGIN
      WatchBubble.Destroy;
      WatchBubble := NIL;
    END;
  IF WatchTimer <> NIL THEN WatchTimer.Stop;
END;


PROCEDURE TSibEditor.EvWatchTimer(Sender:TObject);
VAR  scrPos,wordPos:TEditorPos;
     pt,truncPos:TPoint;
     s,s1:STRING;
     i:INTEGER;
     cx,cy:LONGINT;
     von,bis:TEditorPos;
     Ls:INTEGER;
     Value:STRING;
     EXEAddr:LongWord;
     ValueLen:LongWord;
     ValueTyp:BYTE;
LABEL l;
BEGIN
     IF not InDebugger THEN exit;
     StopWatchTimer;

     {test ob maus im Fenster}
     pt := Screen.MousePos;
     IF Screen.GetControlFromPoint(pt) <> SELF THEN exit;

     {create Bubble}
     scrPos := GetCursorFromMouse(LastMousePos);
     wordPos.X := scrPos.X + CursorPos.X - OffsetPos.X;
     wordPos.Y := scrPos.Y + CursorPos.Y - OffsetPos.Y;

     IF Selected THEN
     BEGIN
          GetSelectionStart(von);
          GetSelectionEnd(bis);
          IF von.Y <> bis.Y THEN goto l;       {mehr als eine Zeile}
          IF von.Y <> wordPos.Y THEN goto l;   {Maus nicht ber der Selection}
          IF von.X > wordPos.X THEN goto l;    {Maus links von der Selection}
          IF bis.X < wordPos.X THEN goto l;    {Maus rechts von der Selection}
          s := Lines[wordPos.Y];
          {immer ganze W”rter}
          Ls := Length(s);
          dec(bis.X);  {steht auf letztem Zeichen}
          IF s[von.X] IN NormalChars THEN
            WHILE (s[von.X-1] IN NormalChars) AND (von.X > 1) DO dec(von.X);
          IF s[bis.X] IN NormalChars THEN
            WHILE (s[bis.X+1] IN NormalChars) AND (bis.X < Ls) DO inc(bis.X);
          SetLength(s,bis.X);
          delete(s,1,von.X-1);
          IF s = '' THEN exit;
     END
     ELSE
     BEGIN
l:
          s := GetWord(wordPos);
          IF s = '' THEN exit;
          s1 := GetChar(wordPos);
          IF s1 = '^' THEN s := s + s1;
          // s nach links erweitern, wenn "." oder
          s1 := Lines[wordPos.Y];
          WHILE (wordPos.X > 2) AND
                (s1[wordPos.X-1] IN IdentifierChars)
             DO dec(wordPos.X);

          IF wordPos.X > 2 THEN
          FOR i := wordPos.X-1 DOWNTO 1 DO
          BEGIN
               IF s1[i] IN QualifiedIdentifierChars THEN s := s1[i] + s
               ELSE break;
          END;
     END;

     IF not ParseValueFromExpr(s, Value, EXEAddr, ValueLen, ValueTyp) THEN exit;
     Value := s + ' = ' + Value;

     truncPos := GetMouseFromCursor(scrPos);  {truncated Mouse Positon}
     inc(truncPos.Y,Canvas.FontHeight);
     pt := ClientToScreen(truncPos);

     WatchBubble.Create(NIL);
     WatchBubble.ZOrder := zoTop;
     WatchBubble.SetWindowPos(pt.X,pt.Y,0,0);
     WatchBubble.Caption := Value;
     WatchBubble.PenColor := clBlack;
     WatchBubble.Color := clLtGray;
     WatchBubble.Show;
     WatchBubble.Canvas.GetTextExtent(Value,cx,cy);
     inc(cx,10);
     inc(cy,6);
     dec(pt.X, cx DIV 2);
     IF pt.X + cx > Screen.Width THEN pt.X := Screen.Width - cx;
     IF pt.X < 0 THEN pt.X := 0;
     IF pt.Y + cy > Screen.Height THEN pt.Y := Screen.Height - cy;
     IF pt.Y < 0 THEN pt.Y := 0;
     WatchBubble.SetWindowPos(pt.X,pt.Y,cx,cy);
END;


{beim Erzeugen der WatchBubble wird ein MouseMove ausgel”st,
 -> Fenster nicht zerst”ren und Timer nicht starten}
PROCEDURE TSibEditor.MouseMove(ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     IF not InDebugger THEN
     BEGIN
          CASE IdeSettings.EditOpt.Mouse OF
            em_Arrow: Cursor := crArrow;
            em_IBeam: Cursor := crIBeam;
          END;
     END
     ELSE Cursor := crArrow;

     IF LastMousePos <> Point(X,Y) THEN StopWatchTimer;

     Inherited MouseMove(ShiftState,X,Y);

     IF InDebugger THEN
       IF IdeSettings.CodeInsight.Tooltips THEN
         IF LastMousePos <> Point(X,Y) THEN
           IF ShiftState = [] THEN StartWatchTimer;

     LastMousePos := Point(X,Y);
END;

PROCEDURE TSibEditor.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     StopWatchTimer;
     ResetErrorLine;

     Inherited MouseDown(Button,ShiftState,X,Y);
END;

PROCEDURE TSibEditor.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseClick(Button,ShiftState,X,Y);

     IF Button = mbRight THEN CodeEditor.ShowContextMenu(SELF,X,Y);
END;


PROCEDURE TSibEditor.cmICBUpcaseHIL;
VAR x1,x2    : INTEGER;
    i,t      : LONGINT;
    tl       : TLine;
    pl       : PLine;
    von,bis  : TEditorPos;
    LineColor: TColorArray;
    LineAtt  : tAttributeArray;
    s:STRING;

BEGIN
  IF ReadOnly THEN exit;
  IF NOT Selected THEN exit;

  FlushWorkLine;
  GetSelectionStart(von);
  GetSelectionEnd(bis);
  x1 := von.X;
  x2 := bis.X-1;

  BeginUpdate;
  FOR t := von.Y TO bis.Y DO
    BEGIN
      pl := PLines[t];
      s := PStrings[pl]^;
      {TEditor.CalcLineColor macht nur bis Columns}
      FOR i := 1 TO Length(s) DO
        BEGIN
          LineColor[i].Fgc := fgcPlainText;
          LineColor[i].Bgc := bgcPlainText;
        END;
      tl := pl^;
      tl.flag := tl.flag AND ciMultiLineBits;
      CalcLineColor(@tl,LineColor,LineAtt);

      IF SelectMode <> smColumnBlock
        THEN x2 := Length(s);
      IF t = bis.Y THEN x2 := bis.X-1;

      FOR i := x1 TO x2 DO
        BEGIN
          IF LineColor[i].Fgc = fgcHIL
            THEN s[i] := Upcase(s[i]);
        END;
       IF SelectMode <> smColumnBlock
         THEN x1 := 1;
       Lines[t] := s;
    END;

  Modified := TRUE;
  ClearRedo;
  EndUpdate;
END;


PROCEDURE TSibEditor.cmICBDowncaseHIL;

VAR x1,x2    : INTEGER;
    i,t      : LONGINT;
    tl       : TLine;
    pl       : PLine;
    von,bis  : TEditorPos;
    LineAtt  : tAttributeArray;
    LineColor: TColorArray;
    s        : STRING;
    prevHIL  : BOOLEAN;

BEGIN
  IF ReadOnly THEN exit;
  IF NOT Selected THEN exit;

  FlushWorkLine;
  GetSelectionStart(von);
  GetSelectionEnd(bis);
  x1 := von.X;
  x2 := bis.X-1;

  BeginUpdate;
  FOR t := von.Y TO bis.Y DO
    BEGIN
       pl := PLines[t];
       s := PStrings[pl]^;
       {TEditor.CalcLineColor macht nur bis Columns}
       FOR i := 1 TO Length(s) DO
         BEGIN
           LineColor[i].Fgc := fgcPlainText;
           LineColor[i].Bgc := bgcPlainText;
         END;
       tl := pl^;
       tl.flag := tl.flag AND ciMultiLineBits;
       CalcLineColor(@tl,LineColor, LineAtt);

       IF SelectMode <> smColumnBlock
         THEN x2 := Length(s);
       IF t = bis.Y
         THEN x2 := bis.X-1;

       prevHIL := FALSE;
       FOR i := x1 TO x2 DO
         BEGIN
           IF LineColor[i].Fgc = fgcHIL
             THEN
               BEGIN
                 s[i] := chr(ord(s[i]) OR $20);
                 IF not prevHIL THEN
                   BEGIN // erster Buchstabe groแ
                     IF IdeSettings.CodeGen.IdentifierStyle = is_Mixed
                       THEN s[i] := Upcase(s[i]);
                     prevHIL := TRUE;
                   END;
               END
             ELSE prevHIL := FALSE;
         END;

      IF SelectMode <> smColumnBlock
        THEN x1 := 1;

      Lines[t] := s;
    END;

  Modified := TRUE;
  ClearRedo;
  EndUpdate;
END;


PROCEDURE TSibEditor.cmICBReadBlock;
VAR  olddir,dir:STRING;
BEGIN
     {$i-}
     GetDir(0,olddir);
     {$i+}
     Inherited cmICBReadBlock;
     {$i-}
     GetDir(0,dir);
     {$i+}
     UpcaseStr(olddir);
     UpcaseStr(dir);
     IF olddir <> dir THEN ChangeDir(dir);
END;


PROCEDURE TSibEditor.cmICBWriteBlock;
VAR  olddir,dir:STRING;
BEGIN
     {$i-}
     GetDir(0,olddir);
     {$i+}
     Inherited cmICBWriteBlock;
     {$i-}
     GetDir(0,dir);
     {$i+}
     UpcaseStr(olddir);
     UpcaseStr(dir);
     IF olddir <> dir THEN ChangeDir(dir);
END;


FUNCTION TSibEditor.GetFileAtCursorName:STRING;
VAR  d,n,e:STRING;
BEGIN
     Result := '';
     n := GetWord(CursorPos);
     IF n = '' THEN exit;
     d := Upcased(Lines[CursorPos.Y]);
     IF pos('{$R ',d) > 0 THEN
     BEGIN
          e := Upcased(GetTextAfterWord(CursorPos));
          IF pos('.SCU',e) = 1 THEN Result := n + '.SCU'
          ELSE Result := n + EXT_UC_RC;
     END
     ELSE
     BEGIN
          IF pos('{$I ',d) > 0 THEN Result := n + '.INC'
          ELSE Result := n + EXT_UC_PASCAL;
     END;
END;


PROCEDURE TSibEditor.cmLoadUnit;
VAR  s,s1,d,d1,n,e:STRING;
BEGIN
     s := GetFileAtCursorName;
     IF s = '' THEN exit;
     {$i-}
     GetDir(0,d);
     {$i+}
     {Suchen im aktuellen Pfad}
     NormalizeDir(d);
     IF LoadEditor(d +'\'+ s, 0,0,0,0,TRUE,CursorIgnore,Fokus,ShowIt) <> NIL
     THEN exit;
     {Suchen im selben Pfad wie File}
//     FSplit(FileName,d,n,e);
     d:=ExtractFilePath(FileName);
     NormalizeDir(d);
     IF LoadEditor(d +'\'+ s, 0,0,0,0,TRUE,CursorIgnore,Fokus,ShowIt) <> NIL
     THEN exit;
     {Suchen im LIBSRC Pfad}
     d := ProjectLibSrcDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          d1 := GetNextDir(d);
          NormalizeDir(d1);
          s1 := FExpand(d1 +'\'+ s);
          IF LoadEditor(s1, 0,0,0,0,TRUE,CursorIgnore,Fokus,ShowIt) <> NIL
          THEN exit;
     END;
     {Suchen im INCSRC Pfad}
     d := ProjectIncSrcDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          d1 := GetNextDir(d);
          NormalizeDir(d1);
          s1 := FExpand(d1 +'\'+ s);
          IF LoadEditor(s1, 0,0,0,0,TRUE,CursorIgnore,Fokus,ShowIt) <> NIL
          THEN exit;
     END;
     SetErrorMessage(FmtLoadNLSStr(SiCouldNotLoadFile,[s]));
END;


PROCEDURE TSibEditor.cmFindMatchingBrace;
VAR  ch,chmatch:CHAR;
     fwd:BOOLEAN;
     i,j:LONGINT;
     s:STRING;
     stack:INTEGER;
     ep:TEditorPos;
BEGIN
     FlushWorkLine;

     ch := GetChar(CursorPos);
     CASE ch OF
       '{': chmatch := '}';
       '[': chmatch := ']';
       '(': chmatch := ')';
       '}': chmatch := '{';
       ']': chmatch := '[';
       ')': chmatch := '(';
       ELSE
       BEGIN
            IF IdeSettings.EnableSound THEN beep(500,20);
            exit;
       END;
     END;

     fwd := ch IN ['{','[','('];

     IF fwd THEN
     BEGIN
          stack := 1;

          FOR i := CursorPos.Y TO CountLines DO
          BEGIN
               s := Lines[i];
               //ersetze alle Zeichen links der Klammer mit ' ' (inklusive Klammer)
               IF i = CursorPos.Y THEN Fillchar(s[1],CursorPos.X,' ');

               FOR j := 1 TO Length(s) DO
               BEGIN
                    IF s[j] = ch THEN
                    BEGIN
                         inc(stack);
                         continue;
                    END;
                    IF s[j] = chmatch THEN
                    BEGIN
                         dec(stack);
                         IF stack = 0 THEN
                         BEGIN
                              ep.X := j;
                              ep.Y := i;
                              GotoPosition(ep);
                              exit;
                         END;
                         continue;
                    END;
               END;
          END;
     END
     ELSE
     BEGIN
          stack := 0;

          FOR i := CursorPos.Y DOWNTO 1 DO
          BEGIN
               s := Lines[i];
               //ersetze alle Zeichen rechts der Klammer mit ' ' (ohne Klammer)
               IF i = CursorPos.Y THEN Fillchar(s[CursorPos.X+1],254-CursorPos.X,' ');

               FOR j := Length(s) DOWNTO 1 DO
               BEGIN
                    IF s[j] = ch THEN
                    BEGIN
                         inc(stack);
                         continue;
                    END;
                    IF s[j] = chmatch THEN
                    BEGIN
                         dec(stack);
                         IF stack = 0 THEN
                         BEGIN
                              ep.X := j;
                              ep.Y := i;
                              GotoPosition(ep);
                              exit;
                         END;
                         continue;
                    END;
               END;
          END;
     END;

     IF IdeSettings.EnableSound THEN beep(500,20);
END;


PROCEDURE TSibEditor.OpenContextMenuAtCursor;
VAR  X,Y:LONGINT;
BEGIN
     X := OffsetPos.X * Canvas.FontWidth;
     Y := ClientHeight - (OffsetPos.Y * Canvas.FontHeight);

     CodeEditor.ShowContextMenu(SELF,X,Y);
END;


PROCEDURE TSibEditor.SetFileName(CONST FName:STRING);
VAR  cd,s1,d,n,e:STRING;
     idx:LONGINT;
BEGIN
     Inherited SetFileName(FName);

     IF FIgnoreFileNameUpdate THEN exit;

     SetFileType;

     {Replace current dir}
     IF IdeSettings.EditOpt.Behaviour * [eb_FullNameTitle] = [] THEN
     BEGIN
          {$i-}
          GetDir(0,cd);
          {$i+}
          NormalizeDir(cd);
          UpcaseStr(cd);
//          FSplit(FName,d,n,e);
          d:=ExtractFilePath(FName);
          NormalizeDir(d);
          UpcaseStr(d);
//          IF cd = d THEN s1 := n + e
          IF cd = d
            THEN s1 := ExtractFilename(FName)
            ELSE s1 := FileName;
     END
     ELSE s1 := FileName;

// Cut long path names; Den Dateinamen als Text ausgeben
     FSplit(s1,d,n,e);
     IF d <> '' THEN s1 := GetShortName(s1,30);
     IF Modified THEN s1 := s1 + '*';
     IF not CodeEditor.MDIBehaviour THEN
       IF CodeEditor.TabSet <> NIL THEN
       BEGIN
            IF Upcased(e) <> EXT_UC_PASCAL THEN n := n + e;
            idx := CodeEditor.TabSetIndex(SELF);
            IF Modified THEN n := n + '*';
            IF idx >= 0 THEN CodeEditor.TabSet.Tabs[idx] := n;
            IF CodeEditor.ActiveMDIChild = SELF THEN CodeEditor.Caption := s1;
       END;

     {Append ShortCut-Nr}
     IF AltNumber > 0 THEN s1 := s1 + '  -' + tostr(AltNumber) + '-';
     Caption := s1;

     RemoveWindowListProc(1,SELF);
     AddWindowListProc(1,SELF);
END;


PROCEDURE TSibEditor.SetFocus;
BEGIN
  IF not CodeEditor.MDIBehaviour THEN  {Update Code Editor Title}
    BEGIN
      SetFileName(FileName);
      IF CodeEditor.TabSet <> NIL THEN
        BEGIN
          CodeEditor.TabSet.TabIndex := CodeEditor.TabSetIndex(SELF);
        END;

      IF NeedResize THEN SetWindowPos(0,0,0,0);
      NeedResize := FALSE;
    END;
  Inherited SetFocus;
END;


PROCEDURE TSibEditor.SetFileType;
VAR  dir,name,ext:STRING;
BEGIN
  FileType := ftAny;
  {die Werte fr ext aus einem Dialog entnehmen}
  ext:=Upcased(ExtractFileExt(FileName));
  IF ext = EXT_UC_PASCAL     THEN FileType := ftPAS;
  IF ext = EXT_UC_INC        THEN FileType := ftPAS;
  IF ext = EXT_UC_WDSibyl_SCL  THEN FileType := ftPAS;
  IF ext = '.DPR'         THEN FileType := ftPAS;
  IF ext = '.DCL'         THEN FileType := ftPAS;
  IF ext = EXT_UC_WDSibyl_Help THEN FileType := ftSHS;
END;


Procedure TSibEditor.SetAvailabeFileTypes(CFOD:{$ifdef os2}TOpenDialog{$endif}
                                               {$ifdef win32}TSystemOpenSaveDialog{$endif});
BEGIN
  SetFileDialogTypes(CFOD);
END;


FUNCTION TSibEditor.SaveToFile(CONST FName:STRING):BOOLEAN;
VAR  oldtype:TFileType;
     oldname,s:STRING;
     olddir,dir:STRING;
     ItemList:TStrings;
     Item:PErrorItem;
     i,idx:LONGINT;
     ISOLatin1:BOOLEAN;
     CodePage:LONGINT;
     DirInfo : tSearchRec;
BEGIN
  WDSibylThrd.Suspend;    // Den Thread kurz anhalten
  {$i-}
  GetDir(0,olddir);
  {$i+}
  UpcaseStr(olddir);
  oldtype := FileType;
  oldname := FileName;
  UpcaseStr(oldname);

  ISOLatin1 := (eoConvertISOLatin1 IN FExtraOpt);
  CodePage := GetCodePage;
{     ASM
     MOV AL,ISOLatin1
     MOV EDITORS.SaveAsISOLatin1,AL
     MOV EAX,CodePage
     MOV EDITORS.CurrentCodePage,EAX
  END; }

  Result := Inherited SaveToFile(FName);
  if SysUtils.FindFirst(FName, faAnyFile, DirInfo)=0 then
    Begin
      fFileSize    :=DirInfo.Size;
      fFileDateTime:=DirInfo.Time;
      SysUtils.FindClose(DirInfo);
    End;

  WDSibylThrd.Resume;    // Den Thread kurz anhalten

  SetFileType;
  IF oldtype <> FileType THEN
    BEGIN
      SetLineColorFlag(FirstLine,LastLine);
      InvalidateEditor(0,0);
    END;

  {$i-}
  GetDir(0,dir);
  {$i+}
  UpcaseStr(dir);
  IF olddir <> dir THEN ChangeDir(dir);

  IF not Result THEN exit;
  {ErrorList updaten}
  ItemList := CodeEditor.Messages;
  IF ItemList = NIL THEN exit;

  s := Upcased(FileName);
  FOR i := 0 TO ItemList.Count-1 DO
    BEGIN
      Item := PErrorItem(ItemList.Objects[i]);
      IF Item = NIL THEN continue;
      IF Upcased(Item^.pErrorFile^) <> s THEN continue;
      idx := Indices[Item^.ErrorPLine];
      IF idx > 0 THEN Item^.ErrorLine := idx;
    END;
END;


FUNCTION TSibEditor.TestSaveAsName(CONST FName:STRING):TMsgDlgReturn;
VAR  Edit:TSibEditor;
     dir,name,ext:STRING;
BEGIN
     Result := Inherited TestSaveAsName(FName);
     IF Result IN [mrNo,mrCancel] THEN exit;

     Edit := GetEditor(FName);
     IF (Edit <> NIL) AND (Edit <> SELF) THEN
     BEGIN {jeder Filename darf nur einmal in der IDE existieren}
          ErrorBox(LoadNLSStr(SiCannotRenameFileUsed));
          Result := mrCancel;
          exit;
     END;

     {vor dem speichern ndern}
     IF IdeSettings.AutoRename * [ar_Unit] <> [] THEN
       IF Rename_Unit(FName) THEN InvalidateEditor(0,0);

     IF Project.Settings.ProjectType = pt_Visual THEN
       IF IdeSettings.AutoRename * [ar_SCU] <> [] THEN
         IF Upcased(FileName) = Upcased(ProjectPrimary(Project.Settings)) THEN
         BEGIN
              IF Rename_Resource(FName) THEN
              BEGIN
                   InvalidateEditor(0,0);
                   FSplit(FName,dir,name,ext);
                   Project.Settings.SCUName := dir + name + '.scu';
//                   Project.Settings.SCUName := ChangeFileExt(FName,'.scu');
                   Project.SCUModified := TRUE; {force to save SCU}
                   Project.Modified := TRUE;    {force to save SPR}
              END;
         END;

     Result := mrYes;
END;


PROCEDURE TSibEditor.FileNameChange(CONST OldName,NewName:STRING);
VAR  FormItem:PFormListItem;
     i:LONGINT;
     Edit:TSibEditor;
     dir,name1,name2,ext:STRING;
     aMain:STRING;
     OldFileName:STRING;
     OldSCU:POINTER;
BEGIN
     Inherited FileNameChange(OldName,NewName);
     {!! FileName ist noch nicht gesetzt !!}

     IF OldName = '' THEN exit;
     OldFileName := Upcased(oldname);

     RemoveWindowListProc(1,SELF);
     AddWindowListProc(1,SELF);


     {Formlist updaten}
     IF IdeSettings.AutoRename * [ar_FormLocation] <> [] THEN
       FOR i := 0 TO Project.Forms.Count-1 DO
       BEGIN
            FormItem := Project.Forms.Items[i];
            IF Upcased(FormItem^.UnitName) = OldFileName THEN
            BEGIN
                 FormItem^.UnitName := NewName;
                 Project.SCUModified := TRUE;
            END;

            {wenn Form nicht sichtbar -> Form.UnitName ndern}
            IF FormItem^.Form = NIL THEN
              IF FormItem^.SCUPointer <> NIL THEN
              BEGIN
                   OldSCU := SCUPointer;
                   SCUPointer := FormItem^.SCUPointer;

                   FormItem^.Form := FormEditClass.Create(NIL);
                   FormItem^.Form.TypeName := 'T'+ FormItem^.Form.Name;
                   //FormItem^.Form.UnitName := NewName;
                   {FormItem.UnitName wird in WritePropertiesToStream gendert}

                   FreeMem(FormItem^.SCUPointer, FormItem^.SCUSize);
                   FormItem^.SCUPointer := NIL;
                   FormItem^.SCUSize := 0;

                   CloseForm(FormItem^.Form);

                   SCUPointer := OldSCU;
              END;
       END;

     {USES updaten - nur fr SubFiles der MainFiles}
     IF IdeSettings.AutoRename * [ar_Uses] <> [] THEN
       FOR i := 0 TO Project.Files.Count-1 DO
       BEGIN
            aMain := Project.Files.Strings[i];
            IF not ExistProjectUnit(aMain,OldName) THEN continue;

            Edit := LoadEditor(aMain,0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
            IF Edit <> NIL THEN
              IF Edit <> SELF THEN {nicht in der eigenen USES List}
              BEGIN
                   FSplit(OldFileName,dir,name1,ext);
                   FSplit(NewName,dir,name2,ext);
                   IF Edit.Rename_Uses(name1,name2)
                     THEN Edit.InvalidateEditor(0,0);
              END;
       END;

     {ProjectFiles updaten}
     IF IdeSettings.AutoRename * [ar_ProjectFiles] <> [] THEN
     BEGIN
          RenameProjectFiles(OldFileName, NewName);
          IF Upcased(ProjectPrimary(Project.Settings)) = OldFileName THEN
          BEGIN
               SetPrimaryFile(NewName);
               Project.Modified := TRUE;
               Project.NeedRecompile := TRUE;
          END;
     END;
END;


FUNCTION TSibEditor.UpdateLineColorFlag(pl:PLine):BOOLEAN;
BEGIN
  Result := FALSE;
  IF pl = NIL THEN exit;
  IF FExtraOpt * [eoSyntaxHigh] = [] THEN exit;
  CASE FileType OF
    ftPAS: BEGIN
             Result := Inherited UpdateLineColorFlag(pl);
           END;
  END;
END;



PROCEDURE TSibEditor.SetLineColorFlag(pl1,pl2:PLine);
BEGIN
  IF (pl1 = NIL) OR (pl2 = NIL) THEN exit;
  IF FExtraOpt * [eoSyntaxHigh] = [] THEN exit;
  CASE FileType OF
    ftPAS: BEGIN
             Inherited SetLineColorFlag(pl1,pl2);
           END;
  END;
END;


PROCEDURE TSibEditor.CalcLineColor(pl:PLine;VAR LineColor:TColorArray;Var LineAtt : tAttributeArray);
BEGIN
  TEditor.CalcLineColor(pl,LineColor, LineAtt);
  IF pl = NIL THEN exit;
  IF FExtraOpt * [eoSyntaxHigh] = [] THEN exit;
  CASE FileType OF
    ftPAS: CalcPascalColor(pl,LineColor);
    ftSHS: CalcHelpColor(pl,LineColor);
  END;
END;


PROCEDURE TSibEditor.CalcHelpColor(pl:PLine;VAR LineColor:TColorArray);
// Fabliche Ausgabe von den Help-Befehlen

VAR  HLS:STRING;
     t,t1:LONGINT;
     b,b1,b2:BYTE;
     Add:BYTE;

BEGIN
  {Berechne Farben der HCOMP-Keywords}
  HLS := PStrings[pl]^;
  UpcaseStr(HLS);
  IF HLS = '' THEN exit;
  IF HLS[1] = '.' THEN
    BEGIN
      FOR t := 1 TO MaxHlpTopics DO
        IF pos(HlpTopics[t],HLS) = 1 THEN
          BEGIN
            FOR t1 := 1 TO length(HlpTopics[t]) DO
              LineColor[t1].fgc := fgcHIL;
            break;
          END;
    END;

  Add := 0;
  b := pos('{',HLS);
  b1 := pos('}',HLS);
  WHILE (b > 0) AND (b1 > b) DO
    BEGIN
      FOR b2 := b+Add TO b1+Add DO
        BEGIN
          LineColor[b2].fgc := fgcSTR;
        END;
      inc(Add,b1);
      Delete(HLS,1,b1);
      b := pos('{',HLS);
      b1 := pos('}',HLS);
    END;
END;


PROCEDURE TSibEditor.UpdateEditorState;
BEGIN
     IF LastFind <> faIncSearch THEN
     BEGIN
          StatusBar.SetText(1, tostr(CursorPos.Y)+':'+tostr(CursorPos.X), clBlack);

          IF InsertMode THEN StatusBar.SetText(2, 'INS', clBlack)
          ELSE StatusBar.SetText(2, 'OVR', clBlack);

          IF ReadOnly THEN StatusBar.SetText(3, 'READ', clBlack)
          ELSE StatusBar.SetText(3, 'READ', clDkGray);

          IF Modified THEN StatusBar.SetText(4, 'MOD', clBlack)
          ELSE StatusBar.SetText(4, 'MOD', clDkGray);

          IF MacroRecording THEN StatusBar.SetText(5, 'REC', clRed)
          ELSE IF MacroPlaying THEN StatusBar.SetText(5, 'PLAY', clBlack)
               ELSE StatusBar.SetText(5, '', clBlack);
     END;
     Inherited UpdateEditorState;
END;


PROCEDURE TSibEditor.SetStateMessage(CONST s:STRING);
BEGIN
  SetMainStatusText(s,clBlack,clLtGray);
END;


PROCEDURE TSibEditor.SetErrorMessage(CONST s:STRING);
BEGIN
  IF ShowEditorErrorMsg THEN Inherited SetErrorMessage(s);
END;


{berschrieben, damit es in dieser Unit sichtbar ist}
FUNCTION TSibEditor.CloseQuery:BOOLEAN;
BEGIN
  Result := Inherited CloseQuery;
END;


PROCEDURE TSibEditor.EvClose(Sender:TObject; VAR Action:TCloseAction);
BEGIN
  Action := caFree;
END;


DESTRUCTOR TSibEditor.Destroy;
VAR  ItemList:TStrings;
     Item:PErrorItem;
     i,idx:LONGINT;
     FName:STRING;
BEGIN
     StopWatchTimer;
     IF WatchTimer <> NIL THEN
     BEGIN
          WatchTimer.Destroy;
          WatchTimer := NIL;
     END;
     StopCodeParameterTimer;
     StopCodeCompletionTimer;

     {FileMen updaten}
     IF not Untitled THEN AddMenuItem(FileName, Project.FilesHistory,
                                cmLastFile1, cmLastFileN, cmFileMenu,
                                MaxFileMenu, MaxHistoryFiles);
     RemoveWindowListProc(1,SELF);

     IF AltNumber > 0 THEN CodeEditor.AltEditor[AltNumber] := NIL;

     CodeEditor.Caption := LoadNLSStr(SiCodeEditor);

     IF not CodeEditor.MDIBehaviour THEN
       IF CodeEditor.TabSet <> NIL THEN
       BEGIN
            idx := CodeEditor.TabSetIndex(SELF);
            IF idx >= 0 THEN CodeEditor.TabSet.Tabs.Delete(idx);
       END;

     IF CodeEditor.LastErrorMsgEditor = SELF
     THEN CodeEditor.LastErrorMsgEditor := NIL;

     {ErrorList updaten}
     ItemList := CodeEditor.Messages;

     IF ItemList <> NIL THEN
     BEGIN
          FName := Upcased(FileName);
          FOR i := 0 TO ItemList.Count-1 DO
          BEGIN
               Item := PErrorItem(ItemList.Objects[i]);
               IF Item = NIL THEN continue;
               IF Upcased(Item^.pErrorFile^) <> FName THEN continue;
               Item^.ErrorPLine := NIL; {ausmaskieren, weil PLine ungltig}
          END;
     END;

     IF not Project.Loading THEN Project.Modified := TRUE;

     Inherited Destroy;
END;


FUNCTION TSibEditor.GetReadOnly:BOOLEAN;
BEGIN
  IF InDebugger
    THEN Result := TRUE
    ELSE Result := Inherited GetReadOnly;
END;


PROCEDURE TSibEditor.SetReadOnly(Value:BOOLEAN);
BEGIN
  Inherited SetReadOnly(Value);
  UpdateEditorState;
  IF Value
    THEN AddToReadOnlyFiles(FileName)
    ELSE RemoveFromReadOnlyFiles(FileName);
END;


PROCEDURE TSibEditor.SetModified(Value:BOOLEAN);
VAR  OldModified:BOOLEAN;
BEGIN
  OldModified := Modified;
  Inherited SetModified(Value);
  IF Value THEN SPUInvalid := TRUE;
  IF OldModified <> Modified THEN SetFileName(FileName);   // update '*'
END;

Procedure TSibEditor.ChgSelectMode;

Begin
  if SelectMode = smColumnBlock
    then SelectMode:=smNonInclusiveBlock
    else SelectMode:=smColumnBlock;
End;

PROCEDURE TSibEditor.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Visible := FALSE;

     FIgnoreFileNameUpdate := FALSE;
     Mask := '*' + EXT_UC_PASCAL;
     FileType := ftAny;
     FExtraOpt := [];
     ActiveControl := NIL;
     EnableDocking := [tbLeft,tbRight,tbBottom];

     StatusBar.Create(SELF);
     InsertControl(StatusBar);

     IF not IdeSettings.EditorIconbar THEN IconBar.Width := 0;

     ErrLine := NIL;
     NeedResize := FALSE;
     AltNumber := CodeEditor.GetFreeAltNumber(SELF);
     ClosingItem := ' ';
     OnClose := EvClose;
     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;

     fFileSize := 0;
     fFileDateTime:=0;
END;


PROCEDURE TSibEditor.SetupShow;
VAR  d,n,e:STRING;
BEGIN
     Inherited SetupShow;

     BottomScrollBar := StatusBar.BottomScrollBar;
     SetSliderValues;
     UpdateColorTable;

     IF not CodeEditor.MDIBehaviour THEN
       IF CodeEditor.TabSet <> NIL THEN
       BEGIN
            FSplit(FileName,d,n,e);
            IF Upcased(e) <> EXT_UC_PASCAL THEN n := n + e;
            CodeEditor.TabSet.Tabs.AddObject(n,SELF);
            CodeEditor.TabSet.TabIndex := CodeEditor.TabSetIndex(SELF);
       END;
END;


FUNCTION TSibEditor.LoadFromFile(CONST FName:STRING):BOOLEAN;
VAR  ItemList:TStrings;
     Item:PErrorItem;
     i:LONGINT;
     s:STRING;
     DirInfo : tSearchrec;
{$IFDEF OS2}
     cptarget:INTEGER;
     cpsource:INTEGER;
{$ENDIF}

BEGIN
  Result := Inherited LoadFromFile(FName);
  IF not Result THEN exit; {not loaded}
  if SysUtils.FindFirst(FName, faAnyFile, DirInfo)=0 then
    Begin
      fFileSize    :=DirInfo.Size;
      fFileDateTime:=DirInfo.Time;
      SysUtils.FindClose(DirInfo);
    End;

  {ErrorList ins File updaten}
  ItemList := CodeEditor.Messages;
  IF ItemList = NIL THEN exit;

  s := Upcased(FileName);
  FOR i := 0 TO ItemList.Count-1 DO
    BEGIN
       Item := PErrorItem(ItemList.Objects[i]);
       IF Item = NIL THEN continue;
       IF Upcased(Item^.pErrorFile^) <> s THEN continue;
       Item^.ErrorPLine := PLines[Item^.ErrorLine];
    END;

  {$IFDEF OS2}
  IF LoadAsISOLatin1 THEN Include(FExtraOpt, eoConvertISOLatin1);

  IF eoConvertISOLatin1 IN FExtraOpt THEN
  BEGIN
       cpsource := 1004;
       cptarget := GetCodePage;
       IF cptarget = 0 THEN Exit;

       FOR i := 0 TO CountLines-1 DO
       BEGIN
            s := Lines[i];
            IF s = '' THEN continue;
            s := Translate(s,cpsource,cptarget);
            IF s <> '' THEN Lines[i] := s;
       END;

       Modified := FALSE;   // wegen Konvertierung
  END;
  {$ENDIF}
END;

procedure tSibEditor.ReOpenFile;

var AltCursorpos : tEditorpos;

begin
// Thread darf hier nicht in den Suspend-Modus, sonst funktioniert
// das automatischen einlesen nicht.
  BeginUpdate;
  AltCursorpos := Cursorpos;
  SelectAll; DeleteSelection;
  LoadFromFile(Filename);
  Cursorpos := AltCursorpos;
  EndUpdate;
end;

FUNCTION EditorFont:TFont;
VAR  FontName:STRING;
     FontHeight,FontWidth:LONGINT;
BEGIN
     IF IdeSettings.Fonts.EditorFont <> '' THEN
       IF SplitFixedFontName(IdeSettings.Fonts.EditorFont,
                             FontName,FontHeight,FontWidth) THEN
       BEGIN
            Result := Screen.GetFontFromName(FontName,FontHeight,FontWidth);
            IF Result <> NIL THEN exit;
       END;

     Result := Screen.FixedFont;
END;


PROCEDURE TSibEditor.Init;
VAR  Opt:TEditOpt;
     xOpt:TExtraOpt;
     AFont:TFont;
BEGIN
     BeginUpdate;
     WITH IdeSettings.EditOpt DO
     BEGIN
          Opt := [];
          IF Options * [eo_AutoIndent] <> [] THEN Opt := Opt + [eoAutoIndent];
          IF Options * [eo_Unindent] <> [] THEN Opt := Opt + [eoUnindent];
          IF Options * [eo_UndoGroups] <> [] THEN Opt := Opt + [eoUndoGroups];
          IF Options * [eo_CursorClimb] <> [] THEN Opt := Opt + [eoCursorClimb];
          IF Options * [eo_2ClickLine] <> [] THEN Opt := Opt + [eo2ClickLine];
          IF Options * [eo_PersistentBlock] <> [] THEN Opt := Opt + [eoPersistentBlocks];
          IF Options * [eo_OverwriteBlock] <> [] THEN Opt := Opt + [eoOverwriteBlock];
          IF Options * [eo_SmartTabs] <> [] THEN Opt := Opt + [eoSmartTabs];
          IF Options * [eo_HomeFirstWord] <> [] THEN Opt := Opt + [eoHomeFirstWord];
          IF Behaviour * [eb_AutoSave] <> [] THEN Opt := Opt + [eoAutoSave];
          IF Behaviour * [eb_Backups] <> [] THEN Opt := Opt + [eoCreateBackups];
          IF Behaviour * [eb_AppendBAK] <> [] THEN Opt := Opt + [eoAppendBAK];
          EditOptions := Opt;

          InsertMode := Options * [eo_InsertMode] <> [];
          WordWrap := Options * [eo_WordWrap] <> [];

          TabSize := TabulatorSize;
          MaxUndoEvents := UndoEvents;
          AutoSaveEvents := SaveEvents;
          WordWrapColumn := WrapColumn;

          CASE Cursor OF
            ec_Underline: CursorShape := csUnderline;
            ec_Vertical:  CursorShape := csVertical;
          END;

          CASE Mouse OF
            em_Arrow: SELF.Cursor := crArrow;
            em_IBeam: SELF.Cursor := crIBeam;
          END;

          CASE Select OF
            es_Column:       SelectMode := smColumnBlock;
            es_NonInclusive: SelectMode := smNonInclusiveBlock;
          END;

          CASE KeyMap OF
            km_WordStar: KeystrokeMap := kmWordStar;
            km_CUA:      KeystrokeMap := kmCUA;
            km_Default:  KeystrokeMap := kmDefault;
{            km_Custom:   KeystrokeMap := kmCustom; }
          END;

          xOpt := [];
          IF Options * [eo_AutoBracket] <> [] THEN xOpt := xOpt + [eoAutoBracket];
          IF Options * [eo_AddIndent] <> [] THEN xOpt := xOpt + [eoAddIndentMode];
          IF Behaviour * [eb_SyntaxHigh] <> [] THEN xOpt := xOpt + [eoSyntaxHigh];
          FExtraOpt := xOpt;

          SetFileName(FileName);   {update FullPathNames}

          UpdateColorTable;

          {update font}
          AFont := EditorFont;
          IF AFont <> Font THEN Font := AFont;
     END;
     EndUpdate;
END;


PROCEDURE TSibEditor.SetWindowPos(NewX,NewY,NewWidth,NewHeight:LONGINT);

VAR  cx,cy,ct:LONGINT;

BEGIN
  IF not CodeEditor.MDIBehaviour THEN
    BEGIN
      cx := goSysInfo.Screen.BorderSize.CX;
      cy := goSysInfo.Screen.BorderSize.CY;
      ct := goSysInfo.Screen.TitlebarSize;
      NewX := - cx;
      NewY := - cy;
      NewWidth := CodeEditor.ClientWidth + 2 * cx + 4;
      NewHeight := CodeEditor.ClientHeight + 2 * cy + ct + 4;
    END;

  Inherited SetWindowPos(NewX,NewY,NewWidth,NewHeight);
END;


PROCEDURE TSibEditor.ToTop;
VAR  Flags:LongWord;
BEGIN
  IF IsControlLocked(SELF) THEN Exit;
  {$IFDEF OS2}
  IF Frame <> NIL THEN
  BEGIN
       IF {F}Visible THEN Flags := SWP_SHOW
       ELSE Flags := 0;
       IF (CPUWindow = NIL) OR (Screen.ActiveForm <> CPUWindow)
       THEN Flags := Flags OR SWP_ACTIVATE;
       WinSetWindowPos(Frame.Handle,HWND_TOP,0,0,0,0,Flags OR SWP_ZORDER);
  END;
  {$ENDIF}
  {$IFDEF Win32}
  IF Frame <> NIL THEN
  BEGIN
       IF Parent <> NIL THEN SendMessage(GetTopWindow(Parent.Handle),
                                         WM_NCACTIVATE,0,0);
       IF {F}Visible THEN Flags := SWP_SHOWWINDOW
       ELSE Flags := 0;
       WinUser.SetWindowPos(Frame.Handle,HWND_TOP,0,0,0,0,
                            Flags OR SWP_NOMOVE OR SWP_NOSIZE);
       IF (CPUWindow = NIL) OR (Screen.ActiveForm <> CPUWindow)
       THEN SendMessage(Frame.Handle,WM_NCACTIVATE,1,0);
  END;
  {$ENDIF}


  //von SetFocus
  IF NOT CodeEditor.MDIBehaviour THEN  {Update Code Editor Title}
  BEGIN
       SetFileName(FileName);
       IF CodeEditor.TabSet <> NIL THEN
       BEGIN
            CanFocusEditor := FALSE;
            CodeEditor.TabSet.TabIndex := CodeEditor.TabSetIndex(SELF);
            CanFocusEditor := TRUE;
       END;

       IF NeedResize THEN SetWindowPos(0,0,0,0);
       NeedResize := FALSE;
  END;
END;


PROCEDURE TSibEditor.UpdateColorTable;
BEGIN
     BeginUpdate;

     WITH IdeSettings.Colors.Editor DO
     BEGIN
          ColorEntry[fgcPlainText] := PlainText.fg;
          ColorEntry[bgcPlainText] := PlainText.bg;
          flagPlainText := PlainText.flag;

          ColorEntry[fgcMarkedBlock] := MarkedBlock.fg;
          ColorEntry[bgcMarkedBlock] := MarkedBlock.bg;
          flagMarkedBlock := MarkedBlock.flag;

          ColorEntry[fgcSearchMatch] := SearchMatch.fg;
          ColorEntry[bgcSearchMatch] := SearchMatch.bg;
          flagSearchMatch := SearchMatch.flag;

          ColorEntry[fgcHIL] := ReservedWord.fg;
          ColorEntry[bgcHIL] := ReservedWord.bg;
          flagReservedWord := ReservedWord.flag;

          ColorEntry[fgcASM] := AsmBlock.fg;
          ColorEntry[bgcASM] := AsmBlock.bg;
          flagAsmBlock := AsmBlock.flag;

          ColorEntry[fgcSTR] := Strings.fg;
          ColorEntry[bgcSTR] := Strings.bg;
          flagStrings := Strings.flag;

          ColorEntry[fgcNumber] := Number.fg;
          ColorEntry[bgcNumber] := Number.bg;
          flagNumber := Number.flag;

          ColorEntry[fgcSymbol] := Symbol.fg;
          ColorEntry[bgcSymbol] := Symbol.bg;
          flagSymbol := Symbol.flag;

          ColorEntry[fgcREM1] := Comment1.fg;
          ColorEntry[bgcREM1] := Comment1.bg;
          flagComment1 := Comment1.flag;

          ColorEntry[fgcREM2] := Comment2.fg;
          ColorEntry[bgcREM2] := Comment2.bg;
          flagComment2 := Comment2.flag;

          ColorEntry[fgcREM3] := Comment3.fg;
          ColorEntry[bgcREM3] := Comment3.bg;
          flagComment3 := Comment3.flag;

          ColorEntry[fgcREM4] := Comment4.fg;
          ColorEntry[bgcREM4] := Comment4.bg;
          flagComment4 := Comment4.flag;

          ColorEntry[fgcREM5] := Comment5.fg;
          ColorEntry[bgcREM5] := Comment5.bg;
          flagComment5 := Comment5.flag;

          ColorEntry[fgcBreak] := ValidBreak.fg;
          ColorEntry[bgcBreak] := ValidBreak.bg;
          flagValidBreak := ValidBreak.flag;

          ColorEntry[fgcInvBrk] := InvalidBreak.fg;
          ColorEntry[bgcInvBrk] := InvalidBreak.bg;
          flagInvalidBreak := InvalidBreak.flag;

          ColorEntry[fgcExec] := ExecPoint.fg;
          ColorEntry[bgcExec] := ExecPoint.bg;
          flagExecPoint := ExecPoint.flag;

          ColorEntry[fgcError] := ErrorLine.fg;
          ColorEntry[bgcError] := ErrorLine.bg;
          flagErrorLine := ErrorLine.flag;

          ColorEntry[fgcRightMargin] := RightMargin.fg;
          ColorEntry[bgcRight] := RightMargin.bg;
          flagRightMargin := RightMargin.flag;
     END;

     EndUpdate;
END;


FUNCTION TSibEditor.FindTheText(CONST find:STRING; direct:TFindDirection;
                                origin:TFindOrigin; scope:TFindScope;
                                opt:TFindOptions):BOOLEAN;
VAR  t,i,x:LONGINT;
     Editor:TSibEditor;
     mdicount:LONGINT;
     Found: boolean; // AaronL
BEGIN
     IF scope = TFindScope(fs_AllEditors) THEN
     BEGIN
          mdicount := CodeEditor.MDIChildCount;
          FOR t := 0 TO mdicount-1 DO
             IF CodeEditor.MDIChildren[t] = SELF THEN
             BEGIN
                  i := t; {own index}
                  break;
             END;

          ShowEditorErrorMsg := FALSE;
          Found:= false; // AaronL
          FOR t := 0 TO mdicount-1 DO
          BEGIN
               IF direct = fdForward THEN x := (t+i) MOD mdicount
               ELSE x := (mdicount-t+i) MOD mdicount;
               Editor := TSibEditor(CodeEditor.MDIChildren[x]);

               Result := Editor.FindText(find,direct,origin,fsGlobal,opt); {global}
               IF Result THEN
               BEGIN
                    Found:= true;
                    Editor.BringToFront;
                    Editor.Focus;
                    break;
               END;
               {nchster editor -> beginne von vorn}
               origin := foEntireScope;
          END;
          ShowEditorErrorMsg := TRUE;
          // AaronL - show error ourselves, since FindText's message will focus the
          // editor as well which we don't want if searching all editors
          if not Found then 
            SetErrorMessage(FmtLoadNLSStr(SSearchStringNotFound,[Find])+'.');

     END
     ELSE Result := FindText(find,direct,origin,scope,opt);
END;

PROCEDURE SetEnabledState(Form:TForm; enable:BOOLEAN);
BEGIN
     IF Form.Frame = NIL THEN exit;
     IF Form.Frame.Handle = 0 THEN exit;
     {$IFDEF OS2}
     WinEnableWindow(Form.Frame.Handle, enable);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.EnableWindow(Form.Frame.Handle, enable);
     {$ENDIF}
END;


FUNCTION TSibEditor.ReplaceTheText(CONST find,replace:STRING; direct:TFindDirection;
                     origin:TFindOrigin;scope:TFindScope;opt:TFindOptions;
                     confirm:BOOLEAN;replaceall:BOOLEAN):BOOLEAN;
VAR  t,i,x:LONGINT;
     Editor:TSibEditor;
     mdicount:LONGINT;
BEGIN
     FOR i := 0 TO Screen.FormCount-1 DO
     BEGIN
          SetEnabledState(Screen.Forms[i], FALSE);
     END;

     IF scope = TFindScope(fs_AllEditors) THEN
     BEGIN
          mdicount := CodeEditor.MDIChildCount;
          FOR t := 0 TO mdicount-1 DO
             IF CodeEditor.MDIChildren[t] = SELF THEN
             BEGIN
                  i := t; {own index}
                  break;
             END;

          ShowEditorErrorMsg := FALSE;
          FOR t := 0 TO mdicount-1 DO
          BEGIN
               IF t = mdicount-1 THEN ShowEditorErrorMsg := TRUE;

               IF direct = fdForward THEN x := (t+i) MOD mdicount
               ELSE x := (mdicount-t+i) MOD mdicount;
               Editor := TSibEditor(CodeEditor.MDIChildren[x]);

               Result := Editor.ReplaceText(find,replace,direct,origin,fsGlobal,
                                            opt,confirm,replaceall); {global}
               IF Result THEN
               BEGIN
                    Editor.BringToFront;
                    IF not replaceall THEN
                    BEGIN
                         Editor.Focus;
                         break;
                    END;
               END;
               {nchster editor -> beginne von vorn}
               origin := foEntireScope;
          END;
     END
     ELSE Result := ReplaceText(find,replace,direct,origin,scope,opt,
                                confirm,replaceall);

     FOR i := 0 TO Screen.FormCount-1 DO
     BEGIN
          SetEnabledState(Screen.Forms[i], TRUE);
     END;
     ShowEditorErrorMsg := TRUE;
END;


PROCEDURE TSibEditor.cmFindText;
VAR  i:LONGINT;
     MyFindDialog:TMyFindTextDialog;
BEGIN
     MyFindDialog.Create(CodeEditorRef);
     MyFindDialog.HelpContext := hctxDialogFind;

     IF IdeSettings.EditOpt.Behaviour * [eb_TextFromCursor] <> [] THEN
     BEGIN
          MyFindDialog.FindText := GetWord(CursorPos);
          MyFindDialog.FindTextExtend := GetTextAfterWord(CursorPos);
     END
     ELSE
     BEGIN
          MyFindDialog.FindText := IdeSettings.EditOpt.FindStruct.find;
          MyFindDialog.FindTextExtend := '';
     END;
     MyFindDialog.Options := TFindOptions(IdeSettings.EditOpt.FindStruct.options);
     MyFindDialog.Origin := TFindOrigin(IdeSettings.EditOpt.FindStruct.origin);
     MyFindDialog.AddScope := TFindScope(IdeSettings.EditOpt.FindStruct.scope);
     MyFindDialog.Direction := TFindDirection(IdeSettings.EditOpt.FindStruct.direction);
     MyFindDialog.FindHistory := Project.FindHistory;

     MyFindDialog.Execute;

     IF MyFindDialog.FindText <> '' THEN
     BEGIN
          IF Project.FindHistory.Find(MyFindDialog.FindText,i)
          THEN Project.FindHistory.Delete(i);
          Project.FindHistory.Insert(0, MyFindDialog.FindText);
     END;

     IF MyFindDialog.ModalResult = cmOk THEN
     BEGIN
          IdeSettings.EditOpt.FindStruct.find := MyFindDialog.FindText;
          IdeSettings.EditOpt.FindStruct.options := Sib_Prj.TFindOptions(MyFindDialog.Options);
          IdeSettings.EditOpt.FindStruct.origin := Sib_Prj.TFindOrigin(MyFindDialog.Origin);
          IdeSettings.EditOpt.FindStruct.scope := Sib_Prj.TFindScope(MyFindDialog.AddScope);
          IdeSettings.EditOpt.FindStruct.direction := Sib_Prj.TFindDirection(MyFindDialog.Direction);

          MyFindDialog.Destroy;

          Screen.Update;
          WITH IdeSettings.EditOpt.FindStruct
            DO FindTheText(find,
                           TFindDirection(direction),
                           TFindOrigin(origin),
                           TFindScope(scope),
                           TFindOptions(options));
          LastFindAction := faFind;
     END
     ELSE MyFindDialog.Destroy;
END;


PROCEDURE TSibEditor.cmReplaceText;
VAR  i:LONGINT;
     MyReplaceDialog:TMyReplaceTextDialog;
BEGIN
     MyReplaceDialog.Create(CodeEditorRef);
     MyReplaceDialog.HelpContext := hctxDialogReplace;

     IF IdeSettings.EditOpt.Behaviour * [eb_TextFromCursor] <> [] THEN
     BEGIN
          MyReplaceDialog.FindText := GetWord(CursorPos);
          MyReplaceDialog.FindTextExtend := GetTextAfterWord(CursorPos);
     END
     ELSE
     BEGIN
          MyReplaceDialog.FindText := IdeSettings.EditOpt.ReplStruct.find;
          MyReplaceDialog.FindTextExtend := '';
     END;
     MyReplaceDialog.ReplaceText := IdeSettings.EditOpt.ReplStruct.replace;
     MyReplaceDialog.Options := TFindOptions(IdeSettings.EditOpt.ReplStruct.options);
     MyReplaceDialog.Confirm := IdeSettings.EditOpt.ReplStruct.confirm;
     MyReplaceDialog.Origin := TFindOrigin(IdeSettings.EditOpt.ReplStruct.origin);
     MyReplaceDialog.AddScope := TFindScope(IdeSettings.EditOpt.ReplStruct.scope);
     MyReplaceDialog.Direction := TFindDirection(IdeSettings.EditOpt.ReplStruct.direction);
     MyReplaceDialog.FindHistory := Project.Find2History;
     MyReplaceDialog.ReplaceHistory := Project.ReplHistory;

     MyReplaceDialog.Execute;

     IF MyReplaceDialog.FindText <> '' THEN
     BEGIN
          IF Project.Find2History.Find(MyReplaceDialog.FindText,i)
          THEN Project.Find2History.Delete(i);
          Project.Find2History.Insert(0, MyReplaceDialog.FindText);
     END;

     IF MyReplaceDialog.ReplaceText <> '' THEN
     BEGIN
          IF Project.ReplHistory.Find(MyReplaceDialog.ReplaceText,i)
          THEN Project.ReplHistory.Delete(i);
          Project.ReplHistory.Insert(0, MyReplaceDialog.ReplaceText);
     END;

     IF MyReplaceDialog.ModalResult IN [cmOk,cmAll] THEN
     BEGIN
          IdeSettings.EditOpt.ReplStruct.find := MyReplaceDialog.FindText;
          IdeSettings.EditOpt.ReplStruct.replace := MyReplaceDialog.ReplaceText;
          IdeSettings.EditOpt.ReplStruct.options := Sib_Prj.TFindOptions(MyReplaceDialog.Options);
          IdeSettings.EditOpt.ReplStruct.confirm := MyReplaceDialog.Confirm;
          IdeSettings.EditOpt.ReplStruct.origin := Sib_Prj.TFindOrigin(MyReplaceDialog.Origin);
          IdeSettings.EditOpt.ReplStruct.scope := Sib_Prj.TFindScope(MyReplaceDialog.AddScope);
          IdeSettings.EditOpt.ReplStruct.direction := Sib_Prj.TFindDirection(MyReplaceDialog.Direction);
          IdeSettings.EditOpt.ReplStruct.replall := MyReplaceDialog.ModalResult = cmAll;

          MyReplaceDialog.Destroy;

          Screen.Update;
          WITH IdeSettings.EditOpt.ReplStruct
            DO ReplaceTheText(find,
                              replace,
                              TFindDirection(direction),
                              TFindOrigin(origin),
                              TFindScope(scope),
                              TFindOptions(options),
                              confirm,replall);
          LastFindAction := faReplace;
     END
     ELSE MyReplaceDialog.Destroy;
END;


PROCEDURE TSibEditor.cmSearchTextAgain;
BEGIN
     LastFind := LastFindAction;

     IF LastFind = faFind THEN
     BEGIN
          WITH IdeSettings.EditOpt.FindStruct
            DO FindTheText(find,
                           TFindDirection(direction),
                           TFindOrigin(foCursor),
                           TFindScope(scope),
                           TFindOptions(options));
     END;

     IF LastFind = faReplace THEN
     BEGIN
          WITH IdeSettings.EditOpt.ReplStruct
            DO ReplaceTheText(find,
                              replace,
                              TFindDirection(direction),
                              TFindOrigin(foCursor),
                              TFindScope(scope),
                              TFindOptions(options),
                              confirm,replall);
     END;
END;


PROCEDURE TSibEditor.SetIncSearchText(s:STRING);
BEGIN
     IF s <> '' THEN {incsearch statusbar}
     BEGIN
          IF StatusBar.OldItemWidth1 = 0 THEN {1.mal}
          BEGIN
               StatusBar.OldItemWidth1 := StatusBar.ItemWidth[1];
               StatusBar.ItemWidth[1] := StatusBar.Feld[StatusItemCount-1].Left +
                                         StatusBar.Feld[StatusItemCount-1].Width -
                                         StatusBar.Feld[1].Left;
               StatusBar.Feld[1].Width := StatusBar.ItemWidth[1];
               TPanel(StatusBar.Feld[1]).Alignment := taLeftJustify;
               StatusBar.Feld[2].Hide;
               StatusBar.Feld[3].Hide;
               StatusBar.Feld[4].Hide;
               StatusBar.Feld[5].Hide;
          END;
          StatusBar.SetText(1, s, clBlack);
     END
     ELSE {reset statusbar}
     BEGIN
          StatusBar.ItemWidth[1] := StatusBar.OldItemWidth1;
          StatusBar.Feld[1].Width := StatusBar.OldItemWidth1;
          TPanel(StatusBar.Feld[1]).Alignment := taCenter;
          StatusBar.Feld[2].Show;
          StatusBar.Feld[3].Show;
          StatusBar.Feld[4].Show;
          StatusBar.Feld[5].Show;
          StatusBar.OldItemWidth1 := 0;
          UpdateEditorState;

          Inherited SetIncSearchText(s); {Release Memory for List}
     END;
END;


PROCEDURE TSibEditor.SetErrorLine(y,x:LONGINT;errStr:STRING;errTyp:BYTE);
VAR  pt:TEditorPos;
     typ:STRING;
BEGIN
     pt.x := x;
     pt.y := y;
     GotoPosition(pt);

     ErrPos := pt;
     ErrText := errStr;
     ErrName := FileName;
     ErrType := errTyp;
     CASE errTyp OF
       errWarning:    typ := LoadNLSStr(SiWarningAt);
       errError:      typ := LoadNLSStr(SiErrorAt);
       errFatalError: typ := LoadNLSStr(SiFatalErrorAt);
     END;
     errStr := typ + ' ['+ tostr(y) +','+ tostr(x) +']  '+ errStr;
     {SetMainStatusText(errstr,clWhite,clBlue);}
     SetMainStatusText(errStr,clRed,clLtGray);
     {Application^.MainWindow^.SetMenuState(CM_USER+CM_GOTOERROR,TRUE);}
     ErrLine := ActLine;
     ErrLine^.flag := ErrLine^.flag OR ciErrorLine;
     InvalidateWorkLine;
END;


PROCEDURE TSibEditor.ResetErrorLine;
BEGIN
     SetMainStatusText('',clBlack,clLtGray);
     IF ErrLine = NIL THEN exit;

     ErrLine^.flag := ErrLine^.flag AND not ciErrorLine;
     InvalidateEditor(0,0);
     ErrLine := NIL;
END;


PROCEDURE GotoLastError;
VAR  Edit:TSibEditor;
BEGIN
     IF ErrName = '' THEN exit;
     Edit := LoadEditor(ErrName, 0,0,0,0,TRUE,ErrPos,Fokus,ShowIt);
     IF Edit = NIL THEN exit;
     Edit.SetErrorLine(ErrPos.Y,ErrPos.X,ErrText,ErrType);
     CodeEditor.LastErrorMsgEditor := Edit;
END;


FUNCTION TSibEditor.InsertBrackets(CONST s1,s2:STRING):INTEGER;
VAR  s:STRING;
     p,q:TEditorPos;
     lzk,count,i:INTEGER;
BEGIN
     IF ReadOnly THEN exit;
     IF Selected THEN
     BEGIN
          BeginUpdate;
          GetSelectionEnd(q);
          s := Lines[q.Y];
          insert(s2,s,q.X);
          Lines[q.Y] := s;
          GetSelectionStart(p);
          s := Lines[p.Y];
          insert(s1,s,p.X);
          Lines[p.Y] := s;

          IF p.Y = q.Y THEN inc(q.X,Length(s1));
          inc(q.X,Length(s2));
          SetSelectionEnd(q);

          SetLineColorFlag(PLines[p.Y],PLines[q.Y]);
          EndUpdate;
          Result := p.X;
     END
     ELSE   {frame the word at cursor}
     BEGIN
          p := CursorPos;
          s := Lines[p.Y];
          lzk := Length(s);
          FOR i := lzk+1 TO p.X DO s := s + ' ';

          WHILE (s[p.X-1] IN NormalChars) AND (p.X > 1) DO dec(p.X);
          count := 0;
          WHILE (s[p.X+count] IN NormalChars) AND (p.X+count <= lzk) DO inc(count);
          insert(s2,s,p.X+count);
          insert(s1,s,p.X);
          Lines[p.Y] := s;

          InvalidateWorkLine;
          Result := p.X;
     END;
END;

Procedure TSibEditor.CBCommentBlock;

const CommentSt = '//';
var Pl : PLine;
    Commented, CommentedOut : longint;
    Comment : boolean;
    St : string;
begin
  if not Selected then exit;
  if FSelectMode = smColumnBlock then exit;
  Commented := 0;
  CommentedOut := 0;
  Pl := ICB.First.Line;
    repeat
      LoadStringOfPline (Pl, St);
      if pos (CommentSt, St) = 1
        then inc (Commented)
        else inc (CommentedOut);
      Pl := Pl^.next;
    until (Pl = ICB.Last.Line) or (Pl = nil);
  Comment := CommentedOut > Commented;
  AdditionalUndo := true;
  Pl := ICB.First.Line;
  repeat
    LoadStringOfPline (Pl, St);
    if pos (CommentSt, St) = 1
      then delete (St, 1, length(CommentSt));
    if Comment
      then St := CommentSt + St;
    ReplacePLine (Pl, St);
    Pl := Pl^.next;
  until (Pl = ICB.Last.Line) or (Pl = nil);
  AdditionalUndo := false;
  InvalidateEditor (0,0);
End;

PROCEDURE TSibEditor.CutToClipBoard;
VAR  p:POINTER;
     Len:LONGINT;
     pc:PClipBoardStruct;
BEGIN
     IF NOT Selected THEN exit;

     IF GetText(p,Len,TRUE) THEN {get selected}
     BEGIN
          pc := ClipBoardHistory.InsertClip(p,Len);
          IF ClipBoardWindow <> NIL THEN ClipBoardWindow.InsertClip(pc);
     END;

     Inherited CutToClipBoard;
END;


PROCEDURE TSibEditor.CopyToClipBoard;
VAR  p:POINTER;
     Len:LONGINT;
     pc:PClipBoardStruct;
BEGIN
     IF NOT Selected THEN exit;

     IF GetText(p,Len,TRUE) THEN {get selected}
     BEGIN
          pc := ClipBoardHistory.InsertClip(p,Len);
          IF ClipBoardWindow <> NIL THEN ClipBoardWindow.InsertClip(pc);
     END;

     Inherited CopyToClipBoard;
END;


PROCEDURE TSibEditor.EditorToTop; {nicht den Code Editor!}
VAR  i:LONGINT;
     Edit:TForm;
BEGIN
     FOR i := 0 TO CodeEditor.MDIChildCount-1 DO
     BEGIN
          Edit := CodeEditor.MDIChildren[i];
          IF Edit <> SELF THEN Edit.SendToBack;
     END;

     IF CodeEditor.TabSet <> NIL
     THEN CodeEditor.TabSet.TabIndex := CodeEditor.TabSetIndex(SELF);
END;


{***************************************************************************}
{************************* Quelltext Generierung ***************************}
{***************************************************************************}

FUNCTION NewSearchItem(SList:TList;name:STRING;flag:TSearchFlag):PSearchStruct;
BEGIN
     New(Result);
     UpcaseStr(name);
     Result^.name := name;
     Result^.flags := flag;
     Result^.nextItem := SList.Count + 1;
     SList.Add(Result);
END;


PROCEDURE DestroySearchList(SList:TList);
VAR  i:INTEGER;
     sli:PSearchStruct;
BEGIN
     FOR i := 0 TO SList.Count-1 DO
     BEGIN
          sli := SList.Items[i];
          Dispose(sli);
     END;
     SList.Destroy;
END;


PROCEDURE TSibEditor.GenerateProgramFrame(CONST ProgName,FormName:STRING);
VAR  al:LONGINT;
BEGIN
     BeginUpdate;
     al := InsertLine(1,Key(_PROGRAM_)+' '+ ProgName +';');
     al := InsertLine(al+1,'');
     al := InsertLine(al+1,Key(_USES_));
     al := InsertLine(al+1,IndentBlock +'Forms,'+ IndentSpace +'Graphics;');
     al := InsertLine(al+1,'');
     al := InsertLine(al+1,'{$r '+ ProgName +'.scu}');
     al := InsertLine(al+1,'');
     al := InsertLine(al+1,Key(_BEGIN_));
     al := InsertLine(al+1,IndentBlock+'Application.Create;');
     al := InsertLine(al+1,IndentBlock+'Application.ProgramName      :='+#39+ProgName+#39+';');
     al := InsertLine(al+1,IndentBlock+'Application.ProgramVersion   := 1;');
     al := InsertLine(al+1,IndentBlock+'Application.ProgramSubVersion:= 0;');
     al := InsertLine(al+1,IndentBlock+'Application.CreateForm'+ IndentSpace +
                            '(T'+ FormName +','+ IndentSpace + FormName +');');
     al := InsertLine(al+1,IndentBlock+'Application.Run;');
     al := InsertLine(al+1,IndentBlock+'Application.Destroy;');
     al := InsertLine(al+1,Key(_END_)+'.');

     Project.Settings.MainForm := FormName;

     cmCursorFileBegin;
     ClearUndo;
     ClearRedo;
     Modified := TRUE;
     Untitled := TRUE;
     EndUpdate;
     SetSliderValues;
END;


PROCEDURE TSibEditor.GenerateUnitFrame(CONST UnitName:STRING);
VAR  al:LONGINT;
BEGIN
     BeginUpdate;
     al := InsertLine(1,Key(_UNIT_) +' '+ UnitName +';');
     al := InsertLine(al+1,'');
     al := InsertLine(al+1,Key(_INTERFACE_));
     al := InsertLine(al+1,'');
     al := InsertLine(al+1,Key(_USES_));
     al := InsertLine(al+1,IndentBlock +'Classes,'+ IndentSpace +'Forms,'+ IndentSpace +'Graphics;');
     al := InsertLine(al+1,'');
     al := InsertLine(al+1,Key(_IMPLEMENTATION_));
     al := InsertLine(al+1,'');
     al := InsertLine(al+1,Key(_INITIALIZATION_));
     al := InsertLine(al+1,Key(_END_) +'.');

     cmCursorFileBegin;
     ClearUndo;
     ClearRedo;
     Modified := TRUE;
     Untitled := TRUE;
     EndUpdate;
     SetSliderValues;
END;


FUNCTION TSibEditor.Insert_Uses(CONST UnitName:STRING):LONGINT;
VAR  SList:TList;
     sli:PSearchStruct;
     von,bis:TEditorPos;
     use,smc:TEditorPos;
     s,s1:STRING;
     found:BOOLEAN;
     LBreak:INTEGER;
BEGIN
     Result := -1;
     IF UnitName = '' THEN exit;

     SList.Create;
     sli := NewSearchItem(SList, 'USES', [sfSeparated]);
     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.First;
          use := sli^.retpos;
     END;
     found := sli^.found;
     DestroySearchList(SList);
     IF not found THEN   {neues USES einfuegen}
     BEGIN
          exit;
     END;

     SList.Create;
     sli := NewSearchItem(SList, ';', [sfNone]);
     IF GeneralSearch(use,bis,SList) THEN
     BEGIN
          sli := SList.First;
          smc := sli^.retpos;
     END;
     found := sli^.found;
     DestroySearchList(SList);
     IF not found THEN exit;

     SList.Create;
     sli := NewSearchItem(SList, UnitName, [sfSeparated]);
     IF GeneralSearch(use,smc,SList) THEN
     BEGIN
          sli := SList.First;
          Result := sli^.retpos.Y;
     END
     ELSE {insert UnitName}
     BEGIN
          IF WordWrap THEN
          BEGIN
               IF WordWrapColumn > 0 THEN LBreak := WordWrapColumn
               ELSE LBreak := Columns + CursorPos.X - OffsetPos.X -1;
          END
          ELSE LBreak := LineBreak;

          IF smc.X + Length(UnitName) +1 > LBreak THEN {Zeilenumbruch}
          BEGIN
               s := Lines[smc.Y];
               s1 := copy(s,smc.X,255);
               s[smc.X] := ',';
               SetLength(s,smc.X);
               Lines[smc.Y] := s;

               s := IndentBlock + UnitName + s1;
               inc(smc.Y);
               InsertLine(smc.Y,s);
               LastUndoGroup := ugReplaceLine;   {group events}
          END
          ELSE
          BEGIN
               s := Lines[smc.Y];
               insert(','+ IndentSpace + UnitName,s,smc.X);
               Lines[smc.Y] := s;
          END;
          Result := smc.Y;
     END;
     DestroySearchList(SList);
END;


FUNCTION TSibEditor.Insert_Class(y:LONGINT; Component:TComponent):LONGINT;
VAR  formname:STRING;
     ancestor:STRING;
     s:STRING;
     typ:BOOLEAN;
     SList:TList;
     sli:PSearchStruct;
     von,bis:TEditorPos;
BEGIN
     formname := Component.Name;
     IF Component IS TForm THEN ancestor := 'TForm'
     ELSE ancestor := Component.ClassName;

     IF ancestor <> 'TForm' THEN
     BEGIN
          SList.Create;
          sli := NewSearchItem(SList, 'TYPE', [sfSeparated]);
          von.X := 1;
          von.Y := y;
          bis.X := StringLength;
          bis.Y := y;
          IF GeneralSearch(von,bis,SList) THEN typ := TRUE
          ELSE typ := FALSE;
          DestroySearchList(SList);
     END
     ELSE typ := TRUE;

     BeginUpdate;
     Result := y-1;
     IF typ THEN Result := InsertLine(Result+1,Key(_TYPE_));
     Result := InsertLine(Result+1,IndentBlock+'T'+ formname +IndentSpace+'='
                   +IndentSpace+Key(_CLASS_)+IndentSpace+'('+ ancestor +')');

     s := IndentBlock + IndentScope;
     Result := InsertLine(Result+1,s + Key(_PRIVATE_));
     Result := InsertLine(Result+1,s + IndentField +'{'+LoadNLSStr(SiInsertPrivateDeclsHere)+'}');

     //Result := InsertLine(Result+1,s + Key(_PROTECTED_));
     //Result := InsertLine(Result+1,s + IndentField +'{Insert protected declarations here}');

     Result := InsertLine(Result+1,s + Key(_PUBLIC_));
     Result := InsertLine(Result+1,s + IndentField +'{'+LoadNLSStr(SiInsertPublicDeclsHere)+'}');

     //Result := InsertLine(Result+1,s + Key(_PUBLISHED_));
     //Result := InsertLine(Result+1,s + IndentField +'{Insert published declarations here}');

     Result := InsertLine(Result+1,IndentBlock+Key(_END_)+';');
     Result := InsertLine(Result+1,'');

     IF ancestor = 'TForm' THEN
     BEGIN
          Result := InsertLine(Result+1,Key(_VAR_));
          Result := InsertLine(Result+1,IndentBlock + formname +':'+
                                        IndentSpace +'T'+ formname +';');
          Result := InsertLine(Result+1,'');
     END;

     Result := Insert_RegisterClasses('T'+ formname);
     EndUpdate;
END;


FUNCTION TSibEditor.Insert_RegisterClasses(CONST comptype:STRING):LONGINT;
VAR  SList:TList;
     sli:PSearchStruct;
     von,bis,lrc:TEditorPos;
     s,s1:STRING;
     y:LONGINT;
     LBreak:INTEGER;
BEGIN
     {suche letzte vorhande RegisterClasses-Anweisung}
     SList.Create;
     NewSearchItem(SList, 'RegisterClasses', [sfSeparated]);
     NewSearchItem(SList, '(', [sfNone]);
     NewSearchItem(SList, '[', [sfNone]);

     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     lrc.X := -1; {LastRegisterClasses}
     lrc.Y := -1;
     WHILE GeneralSearch(von,bis,SList) DO
     BEGIN
          sli := SList.Items[2];
          IF sli^.found THEN
          BEGIN
               von := sli^.retpos;
               lrc := sli^.retpos;
          END;
     END;
     DestroySearchList(SList);

     IF lrc.Y > 0 THEN {Anweisung bereits vorhanden}
     BEGIN
          {suche das Ende der Anweisung}
          SList.Create;
          NewSearchItem(SList, ']', [sfNone]);
          NewSearchItem(SList, ')', [sfNone]);
          von := lrc;
          IF not GeneralSearch(von,bis,SList) THEN
          BEGIN   {Ende nicht gefunden; einfuegen nach "(" = lrc}
               s := Lines[lrc.Y];
               insert(comptype+',',s,lrc.X+1);
               Lines[lrc.Y] := s;
               DestroySearchList(SList);
               Result := lrc.Y;
               exit;
          END;

          {suche ob Typ bereits vorhanden}
          sli := SList.Items[0];
          IF sli^.found THEN bis := sli^.retpos;
          DestroySearchList(SList);

          SList.Create;
          NewSearchItem(SList, comptype, [sfSeparated]);
          IF not GeneralSearch(von,bis,SList) THEN {not found -> neu einfuegen}
          BEGIN
               IF WordWrap THEN
               BEGIN
                    IF WordWrapColumn > 0 THEN LBreak := WordWrapColumn
                    ELSE LBreak := Columns + CursorPos.X - OffsetPos.X -1;
               END
               ELSE LBreak := LineBreak;

               IF bis.X + Length(comptype) +1 > LBreak THEN {Zeilenumbruch}
               BEGIN
                    s := Lines[bis.Y];
                    s1 := copy(s,bis.X,255);
                    s[bis.X] := ',';
                    SetLength(s,bis.X);
                    Lines[bis.Y] := s;

                    s := IndentBlock + IndentBlock + comptype + s1;
                    inc(bis.Y);
                    InsertLine(bis.Y,s);
                    LastUndoGroup := ugReplaceLine;   {group events}
               END
               ELSE
               BEGIN
                    s := Lines[bis.Y];
                    insert(','+ IndentSpace + comptype,s,bis.X);
                    Lines[bis.Y] := s;
               END;
               Result := bis.Y;
          END
          ELSE
          BEGIN
               sli := SList.First;
               Result := sli^.retpos.Y;
          END;
          DestroySearchList(SList);
          exit;
     END;

     {fge neue Anweisung am Ende ein}
     SList.Create;
     NewSearchItem(SList, 'END', [sfSeparated]);
     NewSearchItem(SList, '.', [sfNone]);
     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     y := CountLines-1;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.First;
          IF sli^.found THEN y := sli^.retpos.Y;
     END;
     Result := InsertLine(y,IndentBlock +'RegisterClasses'+ IndentSpace +
                          '(['+ comptype +']);');
     DestroySearchList(SList);
END;


FUNCTION TSibEditor.Insert_Component(CONST classtype:STRING;Component:TComponent):LONGINT;
VAR  cls,frmt:TEditorPos;
     compname,comptype:STRING;
     y:LONGINT;
BEGIN
     compname := Component.Name;
     comptype := Component.ClassName;

     Result := -1;
     IF Search_Class(classtype,frmt,cls) THEN
     BEGIN
          y := cls.Y+1;
          IF ParseCLASSDefinition(classtype)
          THEN y := GetNewComponentLine(Component);
          DestroySymbolTable;

          Result := InsertLine(y,IndentBlock + IndentScope + IndentField +
                                 compname +':'+ IndentSpace + comptype +';');

          Insert_Uses(Component.ClassUnit);
          Insert_RegisterClasses(comptype);
     END
     ELSE
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiClassDefNotFound,[classtype]));
          Component.DesignerState := Component.DesignerState + [dsNoSourceCode];
     END;
END;


FUNCTION GetBreakString(CONST indent:STRING; VAR s:STRING):STRING;
VAR  p:INTEGER;
BEGIN
     Result := '';
     p := pos(';',s);
     WHILE Length(indent) + Length(Result) + p < LineBreak DO
     BEGIN
          Result := Result + copy(s,1,p);
          delete(s,1,p);
          p := pos(';',s);
          IF p = 0 THEN break;
     END;
     IF Result = '' THEN
     BEGIN
          Result := s;
          s := '';
     END;
     WHILE pos(' ',Result) = 1 DO delete(Result,1,1);
END;


FUNCTION TSibEditor.Insert_Method(CONST classtype:STRING;methodname:STRING;AddLines:TStringList):TEditorPos;
VAR  cls,prc,frmt,mth:TEditorPos;
     von:TEditorPos;
     insertbelow:BOOLEAN;
     y,i:LONGINT;
     ResY:LONGINT;
     s,s_,indent:STRING;
     methodshort:STRING;
     methodparam:STRING;
     params:STRING;
     ersteZeile:BOOLEAN;
     paramsequal:BOOLEAN;
LABEL impl;

  PROCEDURE RemoveSpace(ch:CHAR;VAR param:STRING);
  VAR  p:INTEGER;
  BEGIN
       REPEAT
             p := pos(' '+ch,param);
             IF p > 0 THEN delete(param,p,1);
       UNTIL p = 0;
       REPEAT
             p := pos(ch+' ',param);
             IF p > 0 THEN delete(param,p+1,1);
       UNTIL p = 0;
  END;

BEGIN
     Result.Y := -1;
     IF Search_Class(classtype,frmt,cls) THEN
     BEGIN
          y := cls.Y+1;
          IF ParseCLASSDefinition(classtype) THEN y := GetNewMethodLine;
          IF MethodNameExist(methodname,prc,mth) THEN
          BEGIN
               {Extract name of method}
               methodshort := methodname;
               ExtractMethodName(methodshort);
               DestroySymbolTable;

               {vergleiche, ob die Parameter gleich sind}
               methodparam := methodname;
               delete(methodparam,1,Length(methodshort));

               params := Lines[mth.Y];
               delete(params,1,mth.X-1+Length(methodshort));
               FOR i := mth.Y+1 TO mth.Y+9 DO
               BEGIN {noch 9 Zeilen, damit Parameterliste m”glichst vollstndig}
                    params := params + Lines[i];
               END;
               {entferne alle Leerzeichen nach und vor ,;:Space}
               RemoveSpace(',',methodparam);
               RemoveSpace(';',methodparam);
               RemoveSpace(':',methodparam);
               RemoveSpace(' ',methodparam);
               RemoveSpace(',',params);
               RemoveSpace(';',params);
               RemoveSpace(':',params);
               RemoveSpace(' ',params);

               UpcaseStr(methodparam);
               UpcaseStr(params);

               paramsequal := TRUE;
               FOR i := 1 TO Length(methodparam) DO
                  IF methodparam[i] <> params[i] THEN
                  BEGIN
                       paramsequal := FALSE;
                       break;
                  END;

               IF paramsequal THEN
               BEGIN
                    {find & goto zur Position der Implementierung}
                    IF Goto_Method(classtype,methodshort) THEN
                    BEGIN
                         Result := CursorPos;
                    END
                    ELSE goto impl; {wenigstens die Implementation einfgen}
               END
               ELSE ErrorBox(FmtLoadNLSStr(SiDupMethWithDiffParams,[methodshort]));
               exit;
          END;
          DestroySymbolTable;

          BeginUpdate;
          indent := IndentBlock + IndentScope + IndentField;
          s := Key(_PROCEDURE_) +' '+ methodname;
          ersteZeile := TRUE;
          WHILE s <> '' DO
          BEGIN
               {suche most right Semikolon vor LineBreak}
               s_ := GetBreakString(indent,s);

               ResY := InsertLine(y, indent + s_);
               inc(y);
               IF ersteZeile THEN indent := indent + IndentBlock;
               ersteZeile := FALSE;
          END;
impl:
          ResY := CountLines -3;
          insertbelow := FALSE;
          {Suche 'IMPLEMENTATION'}
          ResY := Search_Implementation;
          IF ResY > 0 THEN
          BEGIN
               insertbelow := TRUE;
               von.Y := ResY;
          END
          ELSE von.Y := 1;
          {Suche 'PROC TForm1'}
          von.X := 1;
          IF Search_Method(von,classtype,prc,frmt) THEN
          BEGIN
               ResY := prc.Y-1;
               insertbelow := FALSE;
          END;

          IF insertbelow THEN ResY := InsertLine(ResY+1,'');
          indent := '';
          s := Key(_PROCEDURE_)+' ' + classtype + '.' + methodname;
          ersteZeile := TRUE;
          WHILE s <> '' DO
          BEGIN
               {suche most right Semikolon vor LineBreak}
               s_ := GetBreakString(indent,s);

               ResY := InsertLine(ResY+1, indent + s_);
               IF ersteZeile THEN indent := indent + IndentBlock;
               ersteZeile := FALSE;
          END;

          IF AddLines = NIL THEN {fge Begin...End ein}
          BEGIN
               ResY := InsertLine(ResY+1,Key(_BEGIN_));
               ResY := InsertLine(ResY+1,'');
               Result.Y := ResY;
               Result.X := Length(IndentBlock) + 1;
               ResY := InsertLine(ResY+1,Key(_END_)+';');
          END
          ELSE {fge die additional Lines unter Procedure ein}
          BEGIN
               Result.Y := ResY;
               Result.X := 1;  {Cursor auf "Procedure"}
               FOR i := 0 TO AddLines.Count-1 DO
               BEGIN
                    ResY := InsertLine(ResY+1,AddLines[i]);
               END;
          END;
          IF not insertbelow THEN InsertLine(ResY+1,'');
          EndUpdate;
     END
     ELSE ErrorBox(FmtLoadNLSStr(SiClassDefNotFound,[classtype]));
END;


FUNCTION TSibEditor.RemoveRemarks(pl:PLine):STRING;
VAR tl:TLine;
    t:LONGINT;
    LineColor:TColorArray;
    LineAtt : tAttributeArray;

BEGIN
  Result := PStrings[pl]^;
  UpcaseStr(Result);
  FOR t := 1 TO Length(Result) DO     {TEditor macht nur bis Columns}
    BEGIN
      LineColor[t].Fgc := fgcPlainText;
      LineColor[t].Bgc := bgcPlainText;
    END;
  tl := pl^;
  tl.flag := tl.flag AND ciMultiLineBits;
  CalcLineColor(@tl,LineColor, LineAtt);
  FOR t := 1 TO Length(Result) DO
    BEGIN
      IF LineColor[t].Fgc IN [fgcREM1,fgcREM2,fgcREM3,fgcREM4]
        THEN Result[t] := ' ';
    END;
END;


FUNCTION TSibEditor.Search_Class(CONST classtype:STRING;VAR frmt,cls:TEditorPos):BOOLEAN;
VAR  SList:TList;
     von,bis:TEditorPos;
     sli:PSearchStruct;
     s:STRING;
BEGIN
     Result := FALSE;
     SList.Create;
     NewSearchItem(SList, classtype, [sfSeparated]);
     NewSearchItem(SList, '=', [sfNone]);
     NewSearchItem(SList, 'CLASS', [sfSeparated]);

     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          // Test, ob es eine forward class Definition ist
          sli := SList.Items[2];
          IF sli^.found THEN
          BEGIN
               s := Lines[sli^.retpos.Y];
               delete(s,1,sli^.retpos.X + length('CLASS') -1);
               WHILE (s <> '') AND (s[1] = ' ') DO delete(s,1,1);
               IF (s <> '') AND (s[1] = ';') THEN
               BEGIN // forward Definition
                    von.Y := sli^.retpos.Y;
                    von.X := sli^.retpos.X;
                    IF not GeneralSearch(von,bis,SList) THEN
                    BEGIN
                         DestroySearchList(SList);
                         exit;
                    END;
               END;
          END;

          sli := SList.Items[0];
          IF sli^.found THEN frmt := sli^.retpos;
          sli := SList.Items[2];
          IF sli^.found THEN cls := sli^.retpos;
          Result := TRUE;
     END;
     DestroySearchList(SList);
END;


FUNCTION TSibEditor.Search_Var(CONST varname,vartype:STRING;VAR frm,frmt,smc:TEditorPos):BOOLEAN;
VAR  SList:TList;
     von,bis:TEditorPos;
     sli:PSearchStruct;
BEGIN
     Result := FALSE;
     SList.Create;
     NewSearchItem(SList, varname, [sfSeparated]);
     NewSearchItem(SList, ':', [sfNone]);
     NewSearchItem(SList, vartype, [sfSeparated]);
     NewSearchItem(SList, ';', [sfOptional]);

     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.Items[0];
          IF sli^.found THEN frm := sli^.retpos;
          sli := SList.Items[2];
          IF sli^.found THEN frmt := sli^.retpos;
          sli := SList.Items[3];
          IF sli^.found THEN smc := sli^.retpos
          ELSE smc.Y := -1;
          Result := TRUE;
     END;
     DestroySearchList(SList);
END;


FUNCTION TSibEditor.Search_Method(von:TEditorPos;classtype:STRING;VAR prc,frmt:TEditorPos):BOOLEAN;
VAR  TextLex,Proc:STRING;
     pl,pl1:PLine;
     y,y1,j:LONGINT;
     x:INTEGER;
     s,s1:STRING;
LABEL nextProc,next,nextLine;
BEGIN
     Result := FALSE;
     FlushWorkLine;
     UpcaseStr(classtype);
     pl := PLines[von.Y];
     IF pl = NIL THEN exit;
     FOR y := von.Y TO CountLines DO
     BEGIN
          s := RemoveRemarks(pl);
          IF y = von.Y THEN FillChar(s[1], von.X-1, #32);   {NoANSI}
          s1 := s;
nextProc:
          pl1 := pl;
          y1 := y;
          REPEAT
                Proc := 'PROCEDURE';
                x := pos(Proc,s1);
                IF x = 0 THEN
                BEGIN
                     Proc := 'FUNCTION';
                     x := pos(Proc,s1);
                END;
                IF x = 0 THEN
                BEGIN
                     Proc := 'CONSTRUCTOR';
                     x := pos(Proc,s1);
                END;
                IF x = 0 THEN
                BEGIN
                     Proc := 'DESTRUCTOR';
                     x := pos(Proc,s1);
                END;
                IF x = 0 THEN goto nextLine;
                IF not CheckWordsOnly(pl1,x,Proc)
                THEN s1[abs(x)] := #0;
          UNTIL x > 0;
          {'Procedure' gefunden bei y,p}
          prc.X := x;
          prc.Y := y;
          inc(x,Length(Proc));
          IF (s1[x] <> ' ') AND (x <= Length(s1)) THEN
          BEGIN
               s1[prc.X] := #0;
               goto nextProc;
          END;
          TextLex := classtype {+'.'};
next:
          WHILE (s[x] = ' ') AND (x <= Length(s)) DO inc(x);
          IF x > Length(s) THEN {goto next}
          BEGIN
               IF y1 = CountLines THEN exit;
               inc(y1);
               pl1 := pl1^.next;
               s := RemoveRemarks(pl1);
               x := 1;
               goto next;
          END
          ELSE
          BEGIN
               {Test andere CLASS}
               IF x+Length(TextLex)-1 > Length(s) THEN goto nextLine;
               FOR j := 1 TO Length(TextLex) DO
               BEGIN
                    IF Upcase(s[x]) <> TextLex[j] THEN
                    BEGIN
                         s1[prc.X] := #0;
                         goto nextProc;
                    END
                    ELSE inc(x);
               END;
               {TextLex gefunden}

               dec(x,Length(TextLex));
               {Test Separator behind}
               IF not CheckWordsOnly(pl1,x,TextLex) THEN goto nextline;
               frmt.X := x;
               frmt.Y := y1;
               Result := TRUE;
               exit;
          END;
nextLine:
          pl := pl^.next;
     END;
END;


FUNCTION TSibEditor.Search_Implementation:LONGINT;
VAR  SList:TList;
     sli:PSearchStruct;
     von,bis:TEditorPos;
BEGIN
     SList.Create;
     sli := NewSearchItem(SList, 'IMPLEMENTATION', [sfSeparated]);
     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.First;
          Result := sli^.retpos.Y;
     END
     ELSE Result := -1;
     DestroySearchList(SList);
END;


FUNCTION TSibEditor.Goto_Method(CONST classname,methodname:STRING):BOOLEAN;
VAR  von,bis:TEditorPos;
     sli:PSearchStruct;
     SList:TList;
BEGIN
     Result := FALSE;

     {Search 'Proc' Implementation}
     SList.Create;
     NewSearchItem(SList, 'PROCEDURE', [sfSeparated]);
     NewSearchItem(SList, classname, [sfSeparated]);
     NewSearchItem(SList, '.', [sfNone]);
     NewSearchItem(SList, methodname, [sfSeparated]);

     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.Items[0];
          IF sli^.found THEN
          BEGIN
               GotoPosition(sli^.retpos);
               Result := TRUE;
          END;
     END;
     DestroySearchList(SList);
END;


FUNCTION TSibEditor.Rename_Unit(CONST newname:STRING):BOOLEAN;
VAR  pl:PLine;
     i,j,n,p:LONGINT;
     s,dir,name,ext:STRING;
LABEL char1,char2;
BEGIN
     Result := FALSE;
     IF Upcased(FileName) = Upcased(newname) THEN exit;

     {erstes Wort = PROGRAM, UNIT oder LIBRARY}
     pl := FirstLine;
     FOR i := 1 TO CountLines DO
     BEGIN
          s := RemoveRemarks(pl);
          FOR j := 1 TO Length(s) DO
             IF s[j] <> ' ' THEN goto char1;
          pl := pl^.next;
     END;
     exit;
char1:
     p := pos('PROGRAM ',s);
     IF p = 0 THEN
     BEGIN
          p := pos('LIBRARY ',s);
          IF p = 0 THEN
          BEGIN
               p := pos('UNIT ',s);
               IF p = 0 THEN exit
               ELSE n := p+5;
          END
          ELSE n := p+8;
     END
     ELSE n := p+8;

     FOR j := n TO Length(s) DO
        IF s[j] <> ' ' THEN goto char2;
     exit;
char2:
     n := j;
     FSplit(newname,dir,name,ext);
     s := Lines[i];
     WHILE (s[n] <> ';') AND (Length(s) >= n) DO delete(s,n,1);
     insert(name,s,n);
     Lines[i] := s;
     Result := TRUE;
END;


FUNCTION TSibEditor.Rename_Uses(CONST oldname,newname:STRING):BOOLEAN;
VAR  SList:TList;
     sli:PSearchStruct;
     von,bis:TEditorPos;
     use,smc:TEditorPos;
     y,x:LONGINT;
     s,komma,neuername:STRING;
     found:BOOLEAN;
BEGIN
     Result := FALSE;
     IF oldname = '' THEN exit;

     SList.Create;
     sli := NewSearchItem(SList, 'USES', [sfSeparated]);
     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.First;
          use := sli^.retpos;
     END;
     found := sli^.found;
     DestroySearchList(SList);
     IF not found THEN exit;

     SList.Create;
     sli := NewSearchItem(SList, ';', [sfNone]);
     IF GeneralSearch(use,bis,SList) THEN
     BEGIN
          sli := SList.First;
          smc := sli^.retpos;
     END;
     found := sli^.found;
     DestroySearchList(SList);
     IF not found THEN exit;

     {merke, ob neuer Name schon da ist}
     SList.Create;
     sli := NewSearchItem(SList, newname, [sfSeparated]);
     found := GeneralSearch(use,smc,SList);
     DestroySearchList(SList);

     {suche den alten Namen}
     SList.Create;
     sli := NewSearchItem(SList, oldname, [sfSeparated]);
     IF GeneralSearch(use,smc,SList) THEN  {replace UnitName}
     BEGIN
          sli := SList.First;
          y := sli^.retpos.Y;
          x := sli^.retpos.X;
          s := Lines[y];
          komma := ',';
          IF newname = '' THEN komma := ''; // es kommt kein neues Komma rein
          neuername := newname;

          {l”sche den alten Namen}
          delete(s,x,Length(oldname));
          {versuche das Komma danach zu l”schen}
          WHILE (x < Length(s)) AND (s[x] = ' ') DO delete(s,x,1);
          IF s[x] = ',' THEN
          BEGIN
               {l”sche das Komma danach}
               delete(s,x,1);
               neuername := neuername + komma;  // neues Komma danach anhngen
          END
          ELSE
          BEGIN
               {versuche, das Komma davor zu l”schen}
               WHILE (x > 1) AND (s[x-1] = ' ') DO
               BEGIN
                    dec(x);
                    delete(s,x,1);
               END;
               IF s[x-1] = ',' THEN
               BEGIN
                    {l”sche das Komma davor}
                    dec(x);
                    delete(s,x,1);
                    IF komma <> '' THEN komma := komma + IndentSpace;
                    neuername := komma + neuername;  // neues Komma davor einfgen
               END;
               {ELSE keine Kommas gefunden,
                     es darf also kein neues Komma eingefgt werden}
          END;

          IF not found THEN insert(neuername,s,x);
          Lines[y] := s;
     END;
     DestroySearchList(SList);
     Result := TRUE;
END;


FUNCTION SetProjectMainForm(NewMainForm:STRING;showerror:BOOLEAN):BOOLEAN;
VAR  Editor:TSibEditor;
BEGIN
     Result := FALSE;
     Editor := LoadEditor(ProjectPrimary(Project.Settings),
                          0,0,0,0,TRUE,CursorIgnore,NoFokus,ShowIt);
     IF Editor <> NIL THEN
     BEGIN
          IF Editor.Rename_MainForm(NewMainForm) THEN
          BEGIN
               Editor.InvalidateEditor(0,0);
               Project.Settings.MainForm := NewMainForm;

               Project.Modified := TRUE;
               Project.NeedRecompile := TRUE;
               Project.SCUModified := TRUE;
               Result := TRUE;
          END
          ELSE
          IF showerror THEN
          ErrorBox(FmtLoadNLSStr(SiAppCreateFormNotFound,[Editor.FileName]) + #13#10 +
                   LoadNLSStr(SiCouldNotChangeMainForm));
     END
     ELSE
     IF showerror THEN
     ErrorBox(LoadNLSStr(SiProjectPrimNotFound) + #13#10 +
              LoadNLSStr(SiCouldNotChangeMainForm));
END;


FUNCTION TSibEditor.Rename_Class(CONST oldclassname,newclassname:STRING;ignoreMain:BOOLEAN):BOOLEAN;
VAR  cls,frm,frmt,smc,prc:TEditorPos;
     von:TEditorPos;
     s:STRING;
     i:LONGINT;
     FormItem:PFormListItem;
BEGIN
     Result := FALSE;

     IF Search_Class(newclassname,frm,cls) THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiDuplicateClassIdent,[newclassname]));
          exit;
     END;

     {Replace CLASS Definition}
     IF Search_Class('T'+oldclassname,frmt,cls) THEN
     BEGIN
          s := Lines[frmt.Y];
          delete(s,frmt.X,Length(oldclassname)+1);
          insert('T'+newclassname,s,frmt.X);
          Lines[frmt.Y] := s;
          Result := TRUE;
     END;

     {Replace VAR Definition}
     IF Search_Var(oldclassname,'T'+oldclassname,frm,frmt,smc) THEN
     BEGIN
          s := Lines[frmt.Y];
          delete(s,frmt.X,Length(oldclassname)+1);
          insert('T'+newclassname,s,frmt.X);
          IF frm.Y <> frmt.Y THEN
          BEGIN
               Lines[frmt.Y] := s;
               s := Lines[frm.Y];
          END;
          delete(s,frm.X,Length(oldclassname));
          insert(newclassname,s,frm.X);
          Lines[frm.Y] := s;
          Result := TRUE;
     END;

     {Replace PROC Definitions}
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     von.X := 1;
     WHILE Search_Method(von,'T'+oldclassname,prc,frmt) DO
     BEGIN
          s := Lines[frmt.Y];
          delete(s,frmt.X,Length(oldclassname)+1);
          insert('T'+newclassname,s,frmt.X);
          Lines[frmt.Y] := s;
          von := frmt;
          Result := TRUE;
     END;

     {Replace RegisterClasses Definition}
     Result := Rename_RegisterClasses('T'+ oldclassname,'T'+ newclassname)
               OR Result;


     {Rename MainForm}
     IF ignoreMain THEN exit; {MainForm soll nicht umbenannt werden}

     IF Upcased(oldclassname) = Upcased(Project.Settings.MainForm) THEN
     BEGIN
          {Suche nach EditorName der MainForm}
          FOR i := 0 TO Project.Forms.Count-1 DO
          BEGIN
               FormItem := Project.Forms.Items[i];
               IF Upcased(FormItem^.FormName) = Upcased(oldclassname) THEN
               BEGIN
                    SetProjectMainForm(newclassname,TRUE);
                    break;
               END;
          END;
     END;

     Result := TRUE;   {nur FALSE wenn doppelter Bezeichner}
END;


FUNCTION TSibEditor.Rename_RegisterClasses(CONST oldcomptype,newcomptype:STRING):BOOLEAN;
VAR  SList,SEnde,STyp:TList;
     sli:PSearchStruct;
     von,bis,lrc,lend:TEditorPos;
     s:STRING;
BEGIN
     Result := FALSE;

     SList.Create;
     NewSearchItem(SList, 'RegisterClasses', [sfSeparated]);
     NewSearchItem(SList, '(', [sfNone]);
     NewSearchItem(SList, '[', [sfNone]);
     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;

     {suche alle vorhanden RegisterClasses-Anweisung}
     WHILE TRUE DO
     BEGIN
          IF not GeneralSearch(von,bis,SList) THEN break;

          {Position merken}
          sli := SList.Items[2];
          IF sli^.found THEN
          BEGIN
               von := sli^.retpos; {nchste Suche ab hier}
               lrc := sli^.retpos;
          END
          ELSE break; {undefinierter Zustand}

          {suche das Ende der Anweisung}
          SEnde.Create;
          NewSearchItem(SEnde, ']', [sfNone]);
          NewSearchItem(SEnde, ')', [sfNone]);
          IF not GeneralSearch(lrc,bis,SEnde) THEN     {"])" not found}
          BEGIN                                 {undefinierter Zustand}
               DestroySearchList(SEnde);
               continue;  {Suche bei der nchsten Anweisung fortsetzen}
          END;

          sli := SEnde.First;
          IF not sli^.found THEN
          BEGIN                                 {undefinierter Zustand}
               DestroySearchList(SEnde);
               continue;  {Suche bei der nchsten Anweisung fortsetzen}
          END;
          lend := sli^.retpos;
          DestroySearchList(SEnde);

          {suche ob Typ bereits vorhanden}
          STyp.Create;
          NewSearchItem(STyp, oldcomptype, [sfSeparated]);
          IF GeneralSearch(lrc,lend,STyp) THEN      {found -> ersetzen}
          BEGIN
               sli := STyp.First;
               IF sli^.found THEN
               BEGIN
                    lrc := sli^.retpos;
                    s := Lines[lrc.Y];
                    delete(s,lrc.X,Length(oldcomptype));
                    insert(newcomptype,s,lrc.X);
                    Lines[lrc.Y] := s;
                    Result := TRUE;
               END;
          END;
          DestroySearchList(STyp);
     END;
     DestroySearchList(SList); {RegisterClasses Search}

     IF Result THEN exit;

     {alte Anweisung nicht gefunden -> fge neue Anweisung am Ende ein}
     Result := Insert_RegisterClasses(newcomptype) > 0;
END;


FUNCTION TSibEditor.Rename_Component(CONST classtype:STRING;Component:TComponent;
                                     CONST NewCompName:STRING):BOOLEAN;
VAR  cls,frmt,cmp,cmpt,cmp1,cmpt1:TEditorPos;
     compname,comptype,s:STRING;
     OldCompName:STRING;
LABEL dst;
BEGIN
     compname := Component.Name;
     comptype := Component.ClassName;

     Result := FALSE;
     IF Search_Class(classtype,frmt,cls) THEN
     BEGIN
          IF ParseCLASSDefinition(classtype) THEN
          BEGIN
               IF GetComponentPosition(compname,comptype,cmp,cmpt) THEN
               BEGIN
                    IF ComponentExist(NewCompName,cmp1,cmpt1) THEN
                    BEGIN
                         ErrorBox(FmtLoadNLSStr(SiDuplicateComponentIdent,[NewCompName]));
                         goto dst;
                    END;

                    s := Lines[cmp.Y];
                    delete(s,cmp.X,Length(compname));
                    insert(NewCompName,s,cmp.X);
                    Lines[cmp.Y] := s;
                    Result := TRUE;
               END
               ELSE
               BEGIN
                    OldCompName := Component.Name;
                    Component.Name := NewCompName;
                    Insert_Component(classtype,Component);
                    Component.Name := OldCompName;
                    Result := TRUE;
               END;
               {der alte Name steht weiterhin in Component.Name,
                wird noch zum Updaten der ComboBox im Inspector ben”tigt}
          END;
dst:
          DestroySymbolTable;
     END
     ELSE
     BEGIN
          IF Component.DesignerState * [dsNoSourceCode] = []
          THEN ErrorBox(FmtLoadNLSStr(SiClassDefNotFound,[classtype]));
     END;
END;


FUNCTION TSibEditor.Rename_Method(CONST classtype,oldmethodname:STRING;newmethodname:STRING):BOOLEAN;
VAR  s:STRING;
     mth,prc:TEditorPos;
     von,bis:TEditorPos;
     sli:PSearchStruct;
     SList:TList;
BEGIN
     Result := FALSE;

     IF ParseCLASSDefinition(classtype) THEN
     BEGIN
          IF MethodNameExist(newmethodname,prc,mth) THEN
          BEGIN
               {Extract name of method}
               ExtractMethodName(newmethodname);
               ErrorBox(FmtLoadNLSStr(SiDuplicateMethodIdent,[newmethodname]));
               DestroySymbolTable;
               exit;
          END;

          IF GetMethodPosition(oldmethodname,prc,mth) THEN
          BEGIN
               s := Lines[mth.Y];
               delete(s,mth.X,Length(oldmethodname));
               insert(newmethodname,s,mth.X);
               Lines[mth.Y] := s;
               Result := TRUE;
          END;
     END;
     DestroySymbolTable;


     BeginUpdate;
     {Replace 'Proc' Implementation}
     SList.Create;
     NewSearchItem(SList, 'PROCEDURE', [sfSeparated]);
     NewSearchItem(SList, classtype, [sfSeparated]);
     NewSearchItem(SList, '.', [sfNone]);
     NewSearchItem(SList, oldmethodname, [sfSeparated]);

     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.Items[3];
          IF sli^.found THEN
          BEGIN
               von := sli^.retpos;
               s := Lines[von.Y];
               delete(s,von.X,Length(oldmethodname));
               insert(newmethodname,s,von.X);
               Lines[von.Y] := s;
               Result := TRUE;
          END;
     END;
     DestroySearchList(SList);
     EndUpdate;
END;


FUNCTION TSibEditor.Rename_MainForm(CONST FormName:STRING):BOOLEAN;
VAR  s:STRING;
     von,bis,use:TEditorPos;
     sli:PSearchStruct;
     SList:TList;
BEGIN
     Result := FALSE;
     SList.Create;
     NewSearchItem(SList, 'Application', [sfSeparated]);
     NewSearchItem(SList, '.', [sfNone]);
     NewSearchItem(SList, 'CreateForm', [sfSeparated]);
     NewSearchItem(SList, '(', [sfNone]);
     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.Last;
          use := sli^.retpos;
          s := Lines[use.Y];
          WHILE use.X < Length(s) DO
          BEGIN
               IF s[use.X+1] = ')' THEN break;
               delete(s,use.X+1,1);
          END;
          insert('T'+FormName+','+IndentSpace+FormName,s,use.X+1);
          Lines[use.Y] := s;
          Result := TRUE;
     END;
     DestroySearchList(SList);
END;


FUNCTION TSibEditor.Rename_Resource(CONST newname:STRING):BOOLEAN;
VAR  s,s1,dir,ext:STRING;
     von,bis,use:TEditorPos;
     sli:PSearchStruct;
     SList:TList;
     oldres:STRING;
     newres:STRING;
BEGIN
     Result := FALSE;
     IF Upcased(FileName) = Upcased(newname) THEN exit;
     FSplit(FileName,dir,oldres,ext);
     FSplit(newname,dir,newres,ext);

     BeginUpdate;
     SList.Create;
     s1 := '{$r '+ oldres +'.scu}';
     NewSearchItem(SList, s1, [sfSeparated]);
     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.Last;
          use := sli^.retpos;
          s := Lines[use.Y];
          delete(s,use.X,Length(s1));
          insert('{$r '+ newres +'.scu}',s,use.X);
          Lines[use.Y] := s;
          Result := TRUE;
     END;
     DestroySearchList(SList);
     EndUpdate;
END;


FUNCTION TSibEditor.Remove_Class(CompClass:TComponent):BOOLEAN;
VAR  cls,frm,frmt,smc:TEditorPos;
     classtype:STRING;
     s,s1,s2:STRING;
     Comp:TComponent;
     i:LONGINT;
BEGIN
     Result := FALSE;

     BeginUpdate;
     classtype := 'T'+ CompClass.Name;
     IF Search_Class(classtype,frmt,cls) THEN
     BEGIN
          IF ParseCLASSDefinition(classtype) THEN
          BEGIN
               IF GetClassEndPosition(smc) THEN    {Position von 'END;'}
               BEGIN
                    inc(smc.X,3);
                    {smc zeigt nun auf letztes zu l”schendes Zeichen}
                    s1 := copy(Lines[frmt.Y],1,frmt.X-1);
                    s2 := copy(Lines[smc.Y],smc.X+1,255);
                    FOR i := frmt.Y TO smc.Y DO DeleteLine(frmt.Y);
                    s := s1 + s2;
                    FOR i := Length(s) DOWNTO 1 DO
                       IF s[i] = ' ' THEN SetLength(s,Length(s)-1)
                       ELSE break;
                    IF s <> '' THEN InsertLine(frmt.Y,s);

                    WHILE (Lines[frmt.Y] = '') AND (frmt.Y <= CountLines)
                       DO DeleteLine(frmt.Y);
                    Result := TRUE;
               END;
          END;
          DestroySymbolTable;
     END
     ELSE
     BEGIN
          IF CompClass.DesignerState * [dsNoSourceCode] = []
          THEN ErrorBox(FmtLoadNLSStr(SiClassDefNotFound,[classtype]));
     END;


     {Remove VAR}
     IF CompClass IS TForm THEN
     BEGIN
          IF Search_Var(CompClass.Name,classtype, frm,frmt,smc) THEN
          BEGIN
               IF smc.Y < 0 THEN {kein Semikolon gefunden}
               BEGIN
                    smc := frmt;
                    inc(frmt.X,Length(classtype)-1);
               END;
               {smc zeigt nun auf letztes zu l”schendes Zeichen}
               s1 := copy(Lines[frm.Y],1,frm.X-1);
               s2 := copy(Lines[smc.Y],smc.X+1,255);
               FOR i := frm.Y TO smc.Y DO DeleteLine(frm.Y);
               s := s1 + s2;
               FOR i := Length(s) DOWNTO 1 DO
                  IF s[i] = ' ' THEN SetLength(s,Length(s)-1)
                  ELSE break;
               IF s <> '' THEN InsertLine(frm.Y,s);

               WHILE (Lines[frm.Y] = '') AND (frm.Y <= CountLines)
                  DO DeleteLine(frm.Y);
               Result := TRUE;
          END;
     END;

     Result := Remove_RegisterClasses(CompClass) OR Result;

     {entferne rekursive Definitionen}
     FOR i := 0 TO CompClass.ComponentCount-1 DO
     BEGIN
          Comp := CompClass.Components[i];
          Result := Remove_RegisterClasses(Comp) OR Result; {fr Variablen}
     END;
     EndUpdate;
END;


FUNCTION TSibEditor.RemoveDummy(dummy:STRING):BOOLEAN;
VAR  von,bis,fnd:TEditorPos;
     sli:PSearchStruct;
     SList:TList;
     s:STRING;
     i:LONGINT;
LABEL ok;
BEGIN
     Result := FALSE;
     SList.Create;
     NewSearchItem(SList, dummy, [sfSeparated]);
     NewSearchItem(SList, ';', [sfOptional]);
     NewSearchItem(SList, 'VAR', [sfSeparated,sfOptional]);
     NewSearchItem(SList, 'TYPE', [sfSeparated,sfOptional]);
     NewSearchItem(SList, 'CONST', [sfSeparated,sfOptional]);
     NewSearchItem(SList, 'FUNCTION', [sfSeparated,sfOptional]);
     NewSearchItem(SList, 'PROCEDURE', [sfSeparated,sfOptional]);
     NewSearchItem(SList, 'IMPLEMENTATION', [sfSeparated,sfOptional]);
     von.X := 1;
     von.Y := 1;

     BeginUpdate;
     {suche alle vorhanden Dummy Anweisungen}
     WHILE TRUE DO
     BEGIN
          bis.X := StringLength;
          bis.Y := Search_Implementation;
          IF bis.Y < 0 THEN bis.Y := CountLines;
          IF not GeneralSearch(von,bis,SList) THEN break;

          sli := SList.First;
          IF sli^.found THEN fnd := sli^.retpos
          ELSE break;                          {undefinierter Zustand}
          von := fnd;

          {mindestens 1 Optionales muแ da sein}
          FOR i := 1 TO 7 DO
          BEGIN
               sli := SList.Items[i];
               IF sli^.found THEN goto ok;
          END;
          inc(von.X);                      {Endlosschleife verhindern}
          continue;
ok:
          s := Lines[fnd.Y];
          delete(s,fnd.X,Length(dummy));
          FOR i := Length(s) DOWNTO 1 DO
             IF s[i] = ' ' THEN SetLength(s,Length(s)-1)
             ELSE break;
          IF s = '' THEN
          BEGIN
               DeleteLine(fnd.Y);
               WHILE (Lines[fnd.Y] = '') AND (fnd.Y <= CountLines)
                       DO DeleteLine(fnd.Y);
          END
          ELSE Lines[fnd.Y] := s;
          LastUndoGroup := ugDeleteLine;   {group events}
          Result := TRUE;
     END;
     DestroySearchList(SList);
     EndUpdate;
END;


FUNCTION TSibEditor.Remove_Dummies:BOOLEAN;  {Mll wegrumen (VARs/TYPEs)}
BEGIN
     BeginUpdate;
     {leere VAR Definitionen entfernen}
     Result := RemoveDummy('VAR');
     {leere TYPE Definitionen entfernen}
     Result := RemoveDummy('TYPE') OR Result;
     EndUpdate;
END;


FUNCTION IsNewClass(Component:TComponent):BOOLEAN;
BEGIN
     Result := Component.TypeName <> '';
END;

FUNCTION TSibEditor.Remove_RegisterClasses(Component:TComponent):BOOLEAN;
VAR  SList,SEnde,STyp:TList;
     sli:PSearchStruct;
     von,bis,lrc,lbeg,lend,fnd,smc:TEditorPos;
     s,s1,s2:STRING;
     i:LONGINT;
     needed:BOOLEAN;
     comptype:STRING;
BEGIN
     Result := FALSE;

     IF IsNewClass(Component) THEN comptype := 'T'+ Component.Name
     ELSE comptype := Component.ClassName;

     {teste, ob Komponente noch ben”tigt wird}
     SList.Create;
     NewSearchItem(SList, comptype, [sfSeparated]);
     von.X := 1;
     von.Y := 1;
     bis.X := StringLength;
     bis.Y := Search_Implementation;
     IF bis.Y < 0 THEN bis.Y := 1;
     needed := GeneralSearch(von,bis,SList);
     DestroySearchList(SList);
     IF needed THEN exit;

     SList.Create;
     NewSearchItem(SList, 'RegisterClasses', [sfSeparated]);
     NewSearchItem(SList, '(', [sfNone]);
     NewSearchItem(SList, '[', [sfNone]);
     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;

     BeginUpdate;
     {suche alle vorhanden RegisterClasses-Anweisung}
     WHILE TRUE DO
     BEGIN
          bis.X := StringLength;
          bis.Y := CountLines;
          IF not GeneralSearch(von,bis,SList) THEN break;

          {Position merken}
          sli := SList.First;
          lrc := sli^.retpos;
          sli := SList.Items[2];
          IF sli^.found THEN
          BEGIN
               von := sli^.retpos; {nchste Suche ab hier}
               lbeg := sli^.retpos;
          END
          ELSE continue; {undefinierter Zustand}

          {suche das Ende der Anweisung}
          SEnde.Create;
          NewSearchItem(SEnde, ']', [sfNone]);
          NewSearchItem(SEnde, ')', [sfNone]);
          NewSearchItem(SEnde, ';', [sfOptional]);
          IF not GeneralSearch(lbeg,bis,SEnde) THEN     {"])" not found}
          BEGIN                                 {undefinierter Zustand}
               DestroySearchList(SEnde);
               continue;  {Suche bei der nchsten Anweisung fortsetzen}
          END;

          sli := SEnde.Items[1];
          IF not sli^.found THEN
          BEGIN                                 {undefinierter Zustand}
               DestroySearchList(SEnde);
               continue;  {Suche bei der nchsten Anweisung fortsetzen}
          END;
          lend := sli^.retpos;
          sli := SEnde.Items[2];  {Semikolon}
          IF sli^.found THEN smc := sli^.retpos
          ELSE smc.Y := -1;
          DestroySearchList(SEnde);

          {suche ob Typ vorhanden}
          STyp.Create;
          NewSearchItem(STyp, comptype, [sfSeparated]);
          IF GeneralSearch(lbeg,lend,STyp) THEN      {found -> l”schen}
          BEGIN
               {Typ l”schen}
               sli := STyp.First;
               IF sli^.found THEN fnd := sli^.retpos
               ELSE continue;                   {undefinierter Zustand}
               s := Lines[fnd.Y];
               delete(s,fnd.X,Length(comptype));
               IF s[fnd.X-1] = ' ' THEN delete(s,fnd.X-1,1); {IndentSpace}
               Lines[fnd.Y] := s;
               Result := TRUE;
               IF lend.Y = fnd.Y THEN dec(lend.X,Length(comptype));
               IF smc.Y = fnd.Y THEN dec(smc.X,Length(comptype));
          END;
          DestroySearchList(STyp);

          {suche ob ,, brig}
          STyp.Create;
          NewSearchItem(STyp, ',', [sfNone]);
          NewSearchItem(STyp, ',', [sfNone]);
          IF GeneralSearch(lbeg,lend,STyp) THEN      {found -> l”schen}
          BEGIN
               {zweites Komma l”schen}
               sli := STyp.Items[1];
               IF sli^.found THEN fnd := sli^.retpos
               ELSE continue;                   {undefinierter Zustand}
               s := Lines[fnd.Y];
               delete(s,fnd.X,1);
               Lines[fnd.Y] := s;
               Result := TRUE;
               IF lend.Y = fnd.Y THEN dec(lend.X,1);
               IF smc.Y = fnd.Y THEN dec(smc.X,1);
          END;
          DestroySearchList(STyp);

          {suche ob [, brig}
          STyp.Create;
          NewSearchItem(STyp, '[', [sfNone]);
          NewSearchItem(STyp, ',', [sfNone]);
          IF GeneralSearch(lbeg,lend,STyp) THEN      {found -> l”schen}
          BEGIN
               {Komma l”schen}
               sli := STyp.Items[1];
               IF sli^.found THEN fnd := sli^.retpos
               ELSE continue;                   {undefinierter Zustand}
               s := Lines[fnd.Y];
               delete(s,fnd.X,1);
               Lines[fnd.Y] := s;
               Result := TRUE;
               IF lend.Y = fnd.Y THEN dec(lend.X,1);
               IF smc.Y = fnd.Y THEN dec(smc.X,1);
          END;
          DestroySearchList(STyp);

          {suche ob ,] brig}
          STyp.Create;
          NewSearchItem(STyp, ',', [sfNone]);
          NewSearchItem(STyp, ']', [sfNone]);
          IF GeneralSearch(lbeg,lend,STyp) THEN      {found -> l”schen}
          BEGIN
               {Komma l”schen}
               sli := STyp.Items[0];
               IF sli^.found THEN fnd := sli^.retpos
               ELSE continue;                   {undefinierter Zustand}
               s := Lines[fnd.Y];
               delete(s,fnd.X,1);
               Lines[fnd.Y] := s;
               Result := TRUE;
               IF lend.Y = fnd.Y THEN dec(lend.X,1);
               IF smc.Y = fnd.Y THEN dec(smc.X,1);
          END;
          DestroySearchList(STyp);

          {suche ob [] brig}
          STyp.Create;
          NewSearchItem(STyp, '[', [sfNone]);
          NewSearchItem(STyp, ']', [sfNone]);
          IF GeneralSearch(lbeg,lend,STyp) THEN      {found -> l”schen}
          BEGIN
               {ganze Anweisung von lrc bis smc/lend l”schen}
               IF smc.Y > 0 THEN lend := smc;
               s1 := copy(Lines[lrc.Y],1,lrc.X-1);
               s2 := copy(Lines[lend.Y],lend.X+1,255);
               FOR i := lrc.Y TO lend.Y DO DeleteLine(lrc.Y);
               s := s1 + s2;
               FOR i := Length(s) DOWNTO 1 DO
                  IF s[i] = ' ' THEN SetLength(s,Length(s)-1)
                  ELSE break;
               IF s <> '' THEN InsertLine(lrc.Y,s);
               Result := TRUE;
          END;
          DestroySearchList(STyp);
     END;
     DestroySearchList(SList); {RegisterClasses Search}
     EndUpdate;
END;


FUNCTION TSibEditor.Remove_Component(CONST classtype:STRING;Component:TComponent):BOOLEAN;
VAR  cls,frmt,cmp,cmpt:TEditorPos;
     compname,comptype:STRING;
     s,s1,s2:STRING;
     i,p:LONGINT;
     Ctrl:TControl;
BEGIN
     Result := FALSE;

     compname := Component.Name;
     comptype := Component.ClassName;

     BeginUpdate;
     IF Search_Class(classtype,frmt,cls) THEN
     BEGIN
          IF ParseCLASSDefinition(classtype) THEN
            IF GetComponentPosition(compname,comptype,cmp,cmpt) THEN
          BEGIN
               s1 := copy(Lines[cmp.Y],1,cmp.X-1);
               s2 := copy(Lines[cmpt.Y],cmpt.X+Length(comptype),255);
               FOR i := cmp.Y TO cmpt.Y DO DeleteLine(cmp.Y);
               p := pos(';',s2);
               IF p > 0 THEN delete(s2,p,1);
               s := s1 + s2;
               FOR i := Length(s) DOWNTO 1 DO
                  IF s[i] = ' ' THEN SetLength(s,Length(s)-1)
                  ELSE break;
               IF s <> '' THEN InsertLine(cmp.Y,s);
               Result := TRUE;
          END;
          DestroySymbolTable;
     END
     ELSE
     BEGIN
          IF Component.DesignerState * [dsNoSourceCode] = []
          THEN ErrorBox(FmtLoadNLSStr(SiClassDefNotFound,[classtype]));
     END;

     {entferne auch die Kinder von Component}
     IF Component IS TControl THEN
       FOR i := 0 TO TControl(Component).ControlCount-1 DO
       BEGIN
            Ctrl := TControl(Component).Controls[i];
            Result := Remove_Component(classtype,Ctrl) OR Result;
       END;

     Result := Remove_RegisterClasses(Component) OR Result;
     EndUpdate;
END;


PROCEDURE TSibEditor.Update_DFM(AForm:TForm);
VAR  i,y:LONGINT;
     AComp:TComponent;
     SList:TList;
     sli:PSearchStruct;
     von,bis:TEditorPos;
     s:STRING;
BEGIN
     BeginUpdate;

     {insert RegisterClasses for all Components in AForm}
     FOR i := 0 TO AForm.ComponentCount-1 DO
     BEGIN
          AComp := AForm.Components[i];
          IF csDetail IN AComp.ComponentState THEN continue;
          IF csReferenceControl IN AComp.ComponentState THEN continue;

          Insert_Uses(AComp.ClassUnit);
          Insert_RegisterClasses(AComp.ClassName);
     END;

     {remove Units from Uses list}
     Rename_Uses('Windows','');
     Rename_Uses('Controls','');

     {remove *.DFM statement}
     SList.Create;
     NewSearchItem(SList, '{$R *.DFM}', [sfSeparated]);
     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.First;
          s := Lines[sli^.retpos.Y];
          delete(s,sli^.retpos.X,10);
          Lines[sli^.retpos.Y] := s;
     END;
     DestroySearchList(SList);

     {insert Initialization over RegisterClasses statement}
     SList.Create;
     NewSearchItem(SList, 'RegisterClasses', [sfSeparated]);
     von.X := 1;
     von.Y := Search_Implementation;
     IF von.Y < 0 THEN von.Y := 1;
     bis.X := StringLength;
     bis.Y := CountLines;
     IF GeneralSearch(von,bis,SList) THEN
     BEGIN
          sli := SList.First;
          y := sli^.retpos.Y;
          FOR i := y-1 DOWNTO von.Y DO
          BEGIN
               s := Lines[i];
               WHILE (s[Length(s)] = ' ') DO SetLength(s, Length(s)-1);
               WHILE (Length(s) > 0) AND (s[1] = ' ') DO delete(s,1,1);
               IF s = '' THEN continue;
               UpcaseStr(s);
               IF pos('END',s) = 1 THEN InsertLine(y,Key(_INITIALIZATION_));
               break;
          END;
     END;
     DestroySearchList(SList);

     EndUpdate;
END;


FUNCTION TSibEditor.GeneralSearch(von,bis:TEditorPos; SList:TList):BOOLEAN;
VAR  pl:PLine;
     i,j,k:LONGINT;
     x,x1:INTEGER;
     s,lex:STRING;
     sli,sli2:PSearchStruct;
LABEL rep,nextchar,testOpti;
BEGIN
     Result := FALSE;
     IF SList.Count = 0 THEN exit;
     FlushWorkLine;

rep:
     FOR i := 0 TO SList.Count-1 DO
     BEGIN
          sli := SList.Items[i];
          sli^.found := FALSE;
     END;

     j := 0; {Search Item 0}
     sli := SList.First;
     lex := sli^.name;

     pl := PLines[von.Y];
     FOR i := von.Y TO bis.Y DO
     BEGIN
          IF pl = NIL THEN exit;
          s := RemoveRemarks(pl);
          IF i = von.Y THEN FillChar(s[1], von.X-1, #32);   {NoANSI}
          IF i = bis.Y THEN s := copy(s, 1, bis.X);
          x := 1;

          IF j = 0 THEN
          BEGIN
               x := pos(lex,s);
               IF x <> 0 THEN
               BEGIN
                    IF sli^.flags*[sfSeparated] <> [] THEN
                      IF not CheckWordsOnly(pl,x,lex) THEN
                      BEGIN
                           von.Y := i;
                           von.X := abs(x) + 1; {neue Suche ab dem Wort}
                           goto rep;
                      END;

                    {erstes Wort gefunden}
                    sli^.retpos.Y := i;
                    sli^.retpos.X := x;
                    sli^.found := TRUE;
                    inc(j);
                    IF j >= SList.Count THEN
                    BEGIN
                         Result := TRUE;
                         exit;
                    END;
                    x := x + Length(lex);
                    sli := SList.Items[j];
                    lex := sli^.name;
                    goto nextchar;
               END;
          END
          ELSE
          BEGIN
nextchar:
               WHILE (s[x] = ' ') AND (x <= Length(s)) DO inc(x);
               IF x <= Length(s) THEN
               BEGIN
                    IF x + Length(lex) -1 > Length(s) THEN {Wort ist zu lang}
                    BEGIN
testOpti:
                         IF sli^.flags*[sfOptional] <> [] THEN {try next}
                         BEGIN
                              j := sli^.nextItem;
                              IF j >= SList.Count THEN
                              BEGIN
                                   Result := TRUE;
                                   exit;
                              END;
                              sli := SList.Items[j];
                              lex := sli^.name;
                              goto nextchar;
                         END;

                         {Wort ist falsch -> neue Suche}
                         sli2 := SList.First;
                         von.Y := sli2^.retpos.Y;
                         von.X := sli2^.retpos.X + 1;
                         goto rep;
                    END;
                    x1 := x;
                    {vgl die W”rter}
                    FOR k := 1 TO Length(lex) DO
                    BEGIN
                         IF s[x1] = lex[k] THEN inc(x1)
                         ELSE goto testOpti;
                    END;

                    {Wort stimmt}
                    IF sli^.flags*[sfSeparated] <> [] THEN
                      IF not CheckWordsOnly(pl,x,lex) THEN
                      BEGIN
                           x := abs(x);
                           goto testOpti;
                      END;

                    {neues Wort gefunden}
                    sli^.retpos.Y := i;
                    sli^.retpos.X := x;
                    sli^.found := TRUE;
                    inc(j);
                    IF j >= SList.Count THEN
                    BEGIN
                         Result := TRUE;
                         exit;
                    END;
                    x := x + Length(lex);
                    sli := SList.Items[j];
                    lex := sli^.name;
                    goto nextchar;
               END;
               {ELSE nextline}
          END;

          pl := pl^.next;
     END;
END;

PROCEDURE TSibEditor.cmIncrementalSearch;
BEGIN
    Inherited cmIncrementalSearch;
END;

{y .. Zeile in der CLASS steht; x .. Spalte vom ersten Zeichen nach CLASS}
FUNCTION TSibEditor.ParseCLASSDefinition(CONST classtype:STRING):BOOLEAN;
VAR  Buffer:POINTER;
     Size:LONGINT;
     cls,frmt:TEditorPos;
     p1,p2:TEditorPos;
BEGIN
     Result := FALSE;
     IF not Search_Class(classtype,frmt,cls) THEN exit;

     p1.Y := cls.Y;
     p1.X := 1;
     p2.Y := CountLines;
     p2.X := StringLength+1;
     IF not GetPartialText(p1,p2,Buffer,Size) THEN exit;
     InitSourceBuffer(Buffer,Size, cls.Y, cls.X+Length('CLASS'));

     TRY
        Result := ParseOBJECT;
     EXCEPT
           ON EParserError DO
           BEGIN
                DestroySymbolTable;
                Result := FALSE;
           END;
           ELSE RAISE;
     END;

     FreeMem(Buffer,Size);
END;


PROCEDURE TSibEditor.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
BEGIN
     Inherited Scroll(ScrollBar,ScrollCode,ScrollPos);
END;


PROCEDURE TSibEditor.FontChange;
VAR  i:LONGINT;
     Edit:TForm;
BEGIN
     Inherited FontChange;

     IF Handle = 0 THEN exit;

     IF Font.Pitch = fpFixed THEN
       IF Font.FontType = ftBitmap THEN
         IF not CodeEditor.GlobalFontChange THEN
         BEGIN
              CodeEditor.GlobalFontChange := TRUE;
              FOR i := 0 TO CodeEditor.MDIChildCount-1 DO
              BEGIN
                   Edit := CodeEditor.MDIChildren[i];
                   IF Edit <> SELF THEN Edit.Font := SELF.Font;
              END;
              CodeEditor.GlobalFontChange := FALSE;

              IdeSettings.Fonts.EditorFont :=
                  tostr(Font.Height)+'x'+tostr(Font.Width)+'.'+Font.FaceName;
              IdeSettings.Modified := TRUE;
         END;
END;


PROCEDURE TSibEditor.InvalidateEditor(y1,y2:INTEGER);
BEGIN
     Inherited InvalidateEditor(y1,y2);
END;


PROCEDURE TSibEditor.Print(Selection,Syntax,Comment:BOOLEAN);
VAR  CountPages:LONGINT;
     LinesPerPage:LONGINT;
     i,j,y,line,m:LONGINT;
     CX,CY:LONGINT;
     s,s1:STRING;
     LineCount:LONGINT;
     TheFont:TFont;
     anfang,ende:TEditorPos;
     SyntaxFont:TFont;
     CommentFont:TFont;
     pl:PLine;
     LineColor:TColorArray;
     tl:TLine;
     LastFgc:BYTE;
     CountFgc:INTEGER;
     LineAtt : tAttributeArray;

{$IFDEF OS2}
     PointSize:LONGINT;
{$ENDIF}

LABEL enddoc;
BEGIN
     IF Printer=NIL THEN exit;

     TheFont:=Font;
     Printer.Title := FileName;
     Printer.BeginDoc;

     {$IFDEF OS2}
     IF TheFont.PointSize=0 THEN
     BEGIN
          //???? wie soll ich das berechnen :-((
          //grobe Annherung !
          PointSize:=TheFont.Height-TheFont.InternalLeading-5;
          IF PointSize<=0 THEN PointSize:=TheFont.NominalPointSize;
          IF PointSize>0 THEN
            TheFont:=Screen.GetFontFromPointSize(TheFont.FaceName,PointSize);
          IF TheFont=NIL THEN TheFont:=Font;
     END;
     {$ENDIF}

     IF TheFont.PointSize=0 THEN TheFont:=Screen.GetFontFromPointSize('Courier',12);
     //die beiden gehen nicht... weiแ nicht warum...
     IF ((TheFont.FaceName='System VIO')OR(TheFont.FaceName='System Proportional')) THEN
        TheFont:=Screen.GetFontFromPointSize('Courier',TheFont.PointSize);

     //ErrorBox2('Font is:'+tostr(TheFont.PointSize)+'.'+TheFont.FaceName);
     IF Syntax THEN SyntaxFont := Screen.GetFontFromPointSize(TheFont.FaceName + ' Bold',TheFont.PointSize)
     ELSE SyntaxFont := TheFont;
     IF Comment THEN CommentFont := Screen.GetFontFromPointSize(TheFont.FaceName + ' Italic',TheFont.PointSize)
     ELSE CommentFont := TheFont;

     Printer.Canvas.Font := TheFont;

     IF Selection AND Selected THEN
     BEGIN
          GetSelectionStart(anfang);
          GetSelectionEnd(ende);
     END
     ELSE
     BEGIN
          Selection := FALSE;
          anfang.Y := 1;
          anfang.X := 1;
          ende.Y := CountLines;
          ende.X := 255;
     END;
     LineCount := ende.Y - anfang.Y + 1;

     s := Lines[1]; {immer eine Zeile da}
     IF s <> '' THEN Printer.Canvas.GetTextExtent(s,CX,CY)
     ELSE CY := Printer.Canvas.Font.Height;
     CountPages := (LineCount * CY) DIV Printer.PageHeight;
     LinesPerPage := Printer.PageHeight DIV CY;

     inc(CountPages);

     line := anfang.Y;
     pl := PLines[line];

     FOR i := 1 TO CountPages DO
     BEGIN
          y := Printer.PageHeight;
          FOR j := 1 TO LinesPerPage DO
          BEGIN
               s := Lines[Line];
               IF Selection THEN
               BEGIN
                    IF line = ende.Y THEN delete(s,ende.X,255);
                    IF line = anfang.Y THEN FillChar(s[1],anfang.X-1,' ');
               END;

               IF s <> '' THEN Printer.Canvas.GetTextExtent(s,CX,CY)
               ELSE CY := Printer.Canvas.Font.Height;
               dec(y,CY);

               IF (s <> '') AND (Syntax OR Comment) THEN
               BEGIN
                    Printer.Canvas.PenPos := Forms.Point(0,y);

                    {Farben berechnen}
                    {TEditor.CalcLineColor macht nur bis Columns}
                    FOR m := 1 TO Length(s) DO
                    BEGIN
                         LineColor[m].Fgc := fgcPlainText;
                         LineColor[m].Bgc := bgcPlainText;
                    END;
                    tl := pl^;
                    tl.flag := tl.flag AND ciMultiLineBits;
                    CalcLineColor(@tl,LineColor,LineAtt);

                    LastFgc := LineColor[1].Fgc;
                    CountFgc := 1;
                    FOR m := 2 TO Length(s) DO
                    BEGIN
                         IF LastFgc <> LineColor[m].Fgc THEN {draw the portion}
                         BEGIN
                              //Printer.Canvas.TextOut(0,y,s);
                              CASE LastFgc OF
                                fgcHIL:  Printer.Canvas.Font := SyntaxFont;
                                fgcREM1: Printer.Canvas.Font := CommentFont;
                                fgcREM2: Printer.Canvas.Font := CommentFont;
                                fgcREM3: Printer.Canvas.Font := CommentFont;
                                fgcREM4: Printer.Canvas.Font := CommentFont;
                                //fgcREM5: Printer.Canvas.Font := CommentFont; kein Kommentar
                                ELSE     Printer.Canvas.Font := TheFont;
                              END;

                              s1 := copy(s,m-CountFgc,CountFgc);
                              Printer.Canvas.DrawString(s1);

                              LastFgc := LineColor[m].Fgc;
                              CountFgc := 1;
                         END
                         ELSE inc(CountFgc);
                    END;

                    {draw the rest}
                    CASE LastFgc OF
                      fgcHIL:  Printer.Canvas.Font := SyntaxFont;
                      fgcREM1: Printer.Canvas.Font := CommentFont;
                      fgcREM2: Printer.Canvas.Font := CommentFont;
                      fgcREM3: Printer.Canvas.Font := CommentFont;
                      fgcREM4: Printer.Canvas.Font := CommentFont;
                      ELSE     Printer.Canvas.Font := TheFont;
                    END;

                    s1 := copy(s,Length(s)-CountFgc+1,CountFgc);
                    Printer.Canvas.DrawString(s1);
               END
               ELSE
               BEGIN
                    IF s <> '' THEN Printer.Canvas.TextOut(0,y,s);
               END;

               inc(line);
               IF pl^.next <> NIL THEN pl := pl^.next;
               IF line > ende.Y THEN goto enddoc;
          END;
          Printer.NewPage;
     END;
enddoc:
     Printer.EndDoc;
END;


CONST
    InternalEditorDragging:BOOLEAN=FALSE;


PROCEDURE TSibEditor.DoStartDrag(VAR DragData:TDragDropData);
BEGIN
     Inherited DoStartDrag(DragData);

     InternalEditorDragging := DragData.SourceFileName <> '';
END;


PROCEDURE TSibEditor.DoEndDrag(Target:TObject; X,Y:LONGINT);
BEGIN
     Inherited DoEndDrag(Target, X,Y);

     InternalEditorDragging := FALSE;
END;


PROCEDURE TSibEditor.DragOver(Source:TObject;X,Y:LONGINT;State:TDragState;VAR Accept:BOOLEAN);
VAR  ExtDDO:TExternalDragDropObject;
     FName:STRING;
BEGIN
     IF (IdeSettings.DroppingFile = df_Import) OR InternalEditorDragging THEN
     BEGIN
          Inherited DragOver(Source,X,Y,State,Accept);
          exit;
     END;

     Accept := FALSE;

     IF Source IS TExternalDragDropObject THEN
     BEGIN
          ExtDDO := TExternalDragDropObject(Source);
          IF ExtDDO.SupportedOps * [doCopyable,doMoveable] = [] THEN exit;
          IF ExtDDO.DragOperation IN [doLink,doUnknown] THEN exit;
          IF ExtDDO.RenderType <> drmFile THEN exit;
          {drtText abtesten ??}

          FName := ExtDDO.ContainerName;
          IF FName <> '' THEN
            IF FName[Length(FName)] <> '\' THEN FName := FName + '\';
          FName := FName + ExtDDO.SourceFileName;
          IF not FileExists(FName) THEN exit;
     END
     ELSE exit;

     Accept := TRUE;
END;


PROCEDURE TSibEditor.DragDrop(Source:TObject;X,Y:LONGINT);
VAR  ExtDDO:TExternalDragDropObject;
     FName:STRING;
BEGIN
     IF (IdeSettings.DroppingFile = df_Import) OR InternalEditorDragging THEN
     BEGIN
          Inherited DragDrop(Source,X,Y);
          exit;
     END;

     IF Source IS TExternalDragDropObject THEN
     BEGIN
          ExtDDO := TExternalDragDropObject(Source);
          IF ExtDDO.SupportedOps * [doCopyable,doMoveable] = [] THEN exit;
          IF ExtDDO.DragOperation IN [doLink] THEN exit;
          IF ExtDDO.RenderType <> drmFile THEN exit;

          FName := ExtDDO.ContainerName;
          IF FName <> '' THEN
            IF FName[Length(FName)] <> '\' THEN FName := FName + '\';
          FName := FName + ExtDDO.SourceFileName;
          IF not FileExists(FName) THEN exit;
     END
     ELSE exit;

     LoadEditor(FName,0,0,0,0,FALSE,CursorHome,Fokus,ShowIt);
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: SIBYL Editor StatusBar                                      บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TSibEditorStatusbar.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Alignment := tbBottom;      {immer ganz runter}
     BevelStyle := tbNone;
     Size := 22;
     SysScrollHeight := goSysInfo.Screen.HScrollSize;
     SysScrollWidth := goSysInfo.Screen.VScrollSize;
     PenColor := clBlack;
     Color := clLtGray;
     ParentFont := FALSE;
END;


PROCEDURE TSibEditorStatusbar.SetupShow;
VAR  x,y,cx,cy,d:LONGINT;
     Panel:TPanel;
BEGIN
     Inherited SetupShow;

     Canvas.Font := Screen.SmallFont;
     Canvas.GetTextExtent('99999:999',cx,cy);
     inc(cy,3);
     IF cy < SysScrollHeight THEN cy := SysScrollHeight;
     y := (Size - cy) DIV 2;
     x := 3;

     inc(cx,8);
     Panel.Create(SELF);
     Panel.SetWindowPos(x, y, cx, cy);
     Panel.BevelOuter := bvLowered;
     Panel.Alignment := taCenter;
     Panel.Hint := LoadNLSStr(SiCursorPosition);
     InsertControl(Panel);
     Panel.Canvas.Font := Canvas.Font;
     Feld[1] := Panel;
     ItemWidth[1] := cx;
     inc(x,cx+3);

     Canvas.GetTextExtent('OVR',cx,d);
     inc(cx,8);
     Panel.Create(SELF);
     Panel.SetWindowPos(x, y, cx, cy);
     Panel.BevelOuter := bvLowered;
     Panel.Alignment := taCenter;
     Panel.Hint := LoadNLSStr(SiInputMode);
     InsertControl(Panel);
     Panel.Canvas.Font := Canvas.Font;
     Panel.OnMouseDblClick := EvToggleState;
     Feld[2] := Panel;
     ItemWidth[2] := cx;
     inc(x,cx+3);

     Canvas.GetTextExtent('READ',cx,d);
     inc(cx,8);
     Panel.Create(SELF);
     Panel.SetWindowPos(x, y, cx, cy);
     Panel.BevelOuter := bvLowered;
     Panel.Alignment := taCenter;
     Panel.Hint := LoadNLSStr(SiReadOnlyState);
     InsertControl(Panel);
     Panel.Canvas.Font := Canvas.Font;
     Panel.OnMouseDblClick := EvToggleState;
     Feld[3] := Panel;
     ItemWidth[3] := cx;
     inc(x,cx+3);

     Canvas.GetTextExtent('MOD',cx,d);
     inc(cx,8);
     Panel.Create(SELF);
     Panel.SetWindowPos(x, y, cx, cy);
     Panel.BevelOuter := bvLowered;
     Panel.Alignment := taCenter;
     Panel.Hint := LoadNLSStr(SiModifiedState);
     InsertControl(Panel);
     Panel.Canvas.Font := Canvas.Font;
     Panel.OnMouseDblClick := EvToggleState;
     Feld[4] := Panel;
     ItemWidth[4] := cx;
     inc(x,cx+3);

     Canvas.GetTextExtent('PLAY',cx,d);
     inc(cx,8);
     Panel.Create(SELF);
     Panel.SetWindowPos(x, y, cx, cy);
     Panel.BevelOuter := bvLowered;
     Panel.Alignment := taLeftJustify;
     Panel.Hint := LoadNLSStr(SiInfo);
     InsertControl(Panel);
     Panel.Canvas.Font := Canvas.Font;
     Feld[5] := Panel;
     ItemWidth[5] := cx;
     inc(x,cx+3);

     cx := MaxInt;
     BottomScrollBar.Create(SELF);
     BottomScrollBar.Kind := sbHorizontal;
     BottomScrollBar.Left := x;
     BottomScrollBar.Bottom := (Size - SysScrollHeight) DIV 2;
     BottomScrollBar.Width := cx;
     BottomScrollBar.Height := SysScrollHeight;
     InsertControl(BottomScrollBar);
     Feld[6] := BottomScrollBar;
     ItemWidth[6] := cx;
END;


PROCEDURE TSibEditorStatusbar.Resize;
VAR  t:INTEGER;
     Control:TControl;
BEGIN
     Inherited Resize;

     FOR t := 1 TO StatusItemCount DO
     BEGIN
          Control := Feld[t];
          IF Control = NIL THEN continue; {Resize kommt bevor die Elemente da sind}

          IF Control.Left + ItemWidth[t] +3 >= Width
          THEN Control.Width := Width - Control.Left - SysScrollWidth
          ELSE Control.Width := ItemWidth[t];
     END;
END;


PROCEDURE TSibEditorStatusbar.SetText(i:BYTE; CONST s:STRING; fgColor:TColor);
BEGIN
     IF Feld[i] <> NIL THEN
     BEGIN
          IF Feld[i].Caption <> s THEN Feld[i].Caption := s;
          IF Feld[i].PenColor <> fgColor THEN Feld[i].PenColor := fgColor;
     END;
END;


{$HINTS OFF}
PROCEDURE TSibEditorStatusbar.EvToggleState(Sender:TObject;Button:TMouseButton;
                                   ShiftState:TShiftState;X,Y:LONGINT);
VAR  Edit:TSibEditor;
BEGIN
     Edit := TSibEditor(Parent);
     IF Edit = NIL THEN exit;

     IF Sender = Feld[2] THEN
     BEGIN
          Edit.InsertMode := not Edit.InsertMode;
     END;

     IF Sender = Feld[3] THEN
       IF not InDebugger THEN
       BEGIN
            Edit.ReadOnly := not Edit.ReadOnly;
            Project.Modified := TRUE;
       END;

     IF Sender = Feld[4] THEN
     BEGIN
          Edit.Modified := not Edit.Modified;
     END;

     Edit.UpdateEditorState;
END;
{$HINTS ON}


PROCEDURE TSibEditorStatusbar.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
BEGIN
     Parent.Scroll(ScrollBar,ScrollCode,ScrollPos);

     IF ScrollCode IN [scHorzPosition,scHorzEndScroll]
     THEN Parent.CaptureFocus;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: SIBYL Code Insight Bubble                                   บ
บ                                                                           บ
บ Last modified: September 1998                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TCodeInsightBubble.GetCaptionExtent(VAR cx,cy:Longint);
VAR  i:INTEGER;
BEGIN
  cy := FParameterHeight;
  cx := 0;
  FOR i := 1 TO FParameterCount DO
    cx := cx + FWordWith[i];
END;


PROCEDURE TCodeInsightBubble.Redraw(Const rec:TRect);
VAR  s,s1:STRING;
     rc:TRect;
     x:LONGINT;
     p,pno:INTEGER;

BEGIN
  If Canvas = Nil Then exit;

  Canvas.Pen.Color  := PenColor;
  Canvas.Brush.Color:= Color;

  TControl.Redraw(rec);

  IF FParameterNo > 0
    THEN
      BEGIN
        pno := 0;
        x := 4;
        s := Caption;
        REPEAT
          inc(pno);
          p := pos(';',s);
          IF p > 0
            THEN
              BEGIN
                s1 := Copy(s,1,p);
                Delete(s,1,p);
             END
            ELSE s1 := s;

          IF pno = FParameterNo
            THEN Canvas.Pen.Color := clRed
            ELSE Canvas.Pen.Color := PenColor;

          Canvas.TextOut(x,3,s1);
          x := x + FWordWith[pno];
        UNTIL p = 0;
      END
    ELSE Canvas.TextOut(4,3, Caption);

  rc := ClientRect;
  Canvas.ShadowedBorder(rc,clBlack,clWhite);
  InflateRect(rc,-1,-1);
  Canvas.ShadowedBorder(rc,clWhite,clDkGray);
END;


PROCEDURE TCodeInsightBubble.SetCodeParameter(Const NewCaption:STRING;Count,No:Integer);
VAR  s,s1:STRING;
     p,pno:INTEGER;
     cx,cy:LONGINT;
BEGIN
  IF (FParameterNo = No) AND (FParameterCount = Count) AND
     (NewCaption = Caption) THEN exit;

  FParameterNo := No;
  FParameterCount := Count;
  Caption := NewCaption;

  IF Canvas <> NIL THEN
    BEGIN
      FParameterHeight := 0;
      pno := 0;
      s := Caption;
      REPEAT
        inc(pno);
        p := pos(';',s);
        IF p > 0
          THEN
            BEGIN
              s1 := Copy(s,1,p);
              Delete(s,1,p);
            END
          ELSE s1 := s;

        Canvas.GetTextExtent(s1,cx,cy);
        FWordWith[pno] := cx;
        IF cy > FParameterHeight THEN FParameterHeight := cy;
      UNTIL p = 0;
  END;

  Invalidate;
END;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: SIBYL Code Completion Listbox                               บ
บ                                                                           บ
บ Last modified: September 1998                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TCodeCompletionListBox.SetupComponent;

BEGIN
  Inherited SetupComponent;

  FListBox.Create(SELF);
  FListBox.Align := alClient;
  FListBox.Parent := SELF;
  FListBox.Style := lbOwnerdrawFixed;
  FListBox.OnKeyPress:= EvCharEvent;
  FListBox.OnScan    := EvScanEvent;
  FListBox.OnBeforeDrawItem:= EvDrawItem;
  fListBox.TabPos:='3;70';
  fListbox.TabListSeperator:='|';
  FMaxWidth := -1;
END;

FUNCTION TCodeCompletionListBox.GetItems:TStrings;
BEGIN
  Result := FListBox.Items;
END;


FUNCTION TCodeCompletionListBox.GetItemIndex:Longint;
BEGIN
  Result := FListBox.ItemIndex;
END;


PROCEDURE TCodeCompletionListBox.SetItemIndex(Value:Longint);
BEGIN
  FListBox.ItemIndex := Value;
END;


FUNCTION TCodeCompletionListBox.GetItemHeight:Longint;
BEGIN
  Result := FListBox.ItemHeight;
END;


PROCEDURE TCodeCompletionListBox.SetItemHeight(Value:Longint);
BEGIN
  FListBox.ItemHeight := Value;
END;


PROCEDURE TCodeCompletionListBox.EvDrawItem(Sender:TObject;
             Index:LONGINT;Rec:TRect;State:TOwnerDrawState);

VAR  cy      : LONGINT;
     TabItem : tListboxTabListItem;

BEGIN
  if Index=0 then
    Begin
      FListBox.Canvas.GetTextExtent('constructor  ',FMaxWidth,cy);
      TabItem.pos:=FMaxWidth;
      TabItem.Color:=clred;
      fListBox.TabList.Items[1]:=TabItem;
    End;                
END;


PROCEDURE TCodeCompletionListBox.EvCharEvent(Sender:TObject;VAR Key:CHAR);
BEGIN
     PostMsg(FEditor.Handle,cmCloseCodeCompletion,0,0);
END;


PROCEDURE TCodeCompletionListBox.EvScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
VAR  s:STRING;
     p:INTEGER;
BEGIN
     IF Keycode = kbCR THEN
     BEGIN
          IF ItemIndex >= 0 THEN
          BEGIN
               s := Items[ItemIndex];
               p := pos('|',s);
               IF p > 0 THEN Delete(s,1,p);
               p := pos('|',s);
               IF p > 0 THEN Delete(s,p,255);
               FEditor.CompleteCode(s);
          END;
     END;

     IF Not (Keycode IN [kbCUp,kbCDown,kbPageUp,kbPageDown]) THEN
     BEGIN
          PostMsg(FEditor.Handle,cmCloseCodeCompletion,0,0);
          exit;
     END;
END;


VAR  i:BYTE;

BEGIN
     PlayMacroProc := PlayEditorMacro;
     PasteClipBoardProc := PasteClipBoard;
     LoadEditorProc := @LoadEditor;
     FOR i := 0 TO 255 DO UpcaseTable[i] := Upcase(chr(i));
     ErrText := '';
     ErrName := '';
     IndentBlock := '  ';
     IndentScope := '';
     IndentField := '  ';
     IndentSpace := ' ';
     LineBreak := 80;
     ShowEditorErrorMsg := TRUE;
     DAsmInsideIDE := TRUE;
     DAsmIDELoadEditorProc := @LoadEditor;
     InitCodeEditorProc := @InitCodeEditor;
     TestProjectBookMarkProc := @TestProjectBookMark;
     InitControlCentreProc := @InitControlCentre;
     ClearBuildListProc := @ClearBuildList;
     ClearFindInFilesListProc := @ClearFindInFilesList;
     ClearDebugListProc := @ClearDebugList;
     ViewWatchProc := @ShowWatchGrid;
     ViewLocalsProc := @ShowLocalsGrid;
     GetEditorProc := @GetEditor;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Dec-02  WD         Ausbau des Standard-Teil
  18-Okt-04  MV, WD     Einbau der Funktion CBCommentBlock
  23-Okt-04  WD         Sortieren des Code-Completion-Listbox
  25-Okt-04  WD         Copy, Cut, Paste und Delete in das Popup-Editor eingebaut
  11-Jan-05  WD         Umbau der Code-Completion-Listbox (Listbox kann Spalten anzeigen)
  29-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  26-Sep-05  MV/WD      Die Funktion "CalcLineColor" mit dem Parameter "LineAtt" erweitert
  12-Aug-06  WD         Bei Thread die Unit "uSysClass" mit einbinden
  09-Nov-06  WD         TSibEditor.SetWindowPos: Das Verschieben der Editoren im "Tableisten"-Modus
                        deaktiviert.
  19-Nov-06  WD         ReOpenFile in das Popup-Menue eingebaut.
  28-Apr-08  WD         TSibEditor.GenerateProgramFrame: ApplicationName usw. eingebaut.
}
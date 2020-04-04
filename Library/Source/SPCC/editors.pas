
{…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
 ∫                                                                          ∫
 ∫    Sibyl Portable Component Classes                                      ∫
 ∫                                                                          ∫
 ∫    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    ∫
 ∫                                                                          ∫
 »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº}


Unit Editors;

{
 Changes by Martin Vieregg, www.hypermake.com

 If you want to change something, please contact me!

 editors.pas and wraped.pas is implemented in my ME and WSedit Freeware editors, in the Hypermake editor
                    and the Textbuch editor (german accounting program)
 Visit www.WriteAndSet.com and www.hypermake.com


 OEM/ANSI conversion moved to StdCtrls !

 new properties:

 RunInAnsi = true : uses Ansi Codepage (Windows only)
 RunInAnsi = false : uses IBM/OEM codepage
 LoadSaveAsAnsi = true : independent from RunInAnsi, loading and saving a text file is in Ansi codepage
 LoadSaveAsAnsi = false : independent from RunInAnsi, loading and saving a text file in IBM/OEM codepage

 new methods:

    procedure DefineLineColors (pl:PLine;Var LineColor:TColorArray; Var LineAtt : tAttributeArray; First, Last : integer);
          (override to program syntax-highlightning)
    procedure ReplacePLine(Pl : PLine;Const S:String);
    procedure LoadStringOfPLine(pl:PLine; var Line : string);

 Then I've made a lot of minor changes to make editors.pas work together with wraped.pas (wrap editor)
 (Wraped.pas distinguishes between Hardreturn and Softreturn lines and can be used for wordprocessing.)


}

Interface

{$IFDEF OS2}
Uses PmWin, OS2Def, BseDos, BseErr;
{$ENDIF}
{$IFDEF Win32}
Uses WinUser;
{$ENDIF}

//uses martinheap;

Uses Dos,SysUtils,Messages,Classes,Graphics,Menus,Forms,StdCtrls,extctrls,Dialogs,
     ClipBrd, Color, uList, uStream, uString, uSysinfo;

Const
  //   NormalChars : Set Of Char = ['0'..'9','A'..'Z','a'..'z','_',
  //                                'Ñ','é','î','ô','Å','ö','·'];  // Wird in WDSibylIDE verwendet
     StringLength        = 255;

     ciNormal            = 0;
     ciBookMark0         = 1;
     ciBookMarkMask      = 1 + 2 + 4 + 8;
     ciSelected          = 16;
     ciSoftReturn        = longword(65536)*2;{Martin, used by wraped.pas}
     ciBreakReturn       = longword(65536)*4;{Martin, used by wraped.pas}
     ciInvisible         = longword(65536)*8;{Martin  I've stopped programming this, but will continue}

     {codes For TColorArray}
     fgcPlainText        = 0;
     bgcPlainText        = 1;
     fgcMarkedBlock      = 2;
     bgcMarkedBlock      = 3;
     fgcSearchMatch      = 4;
     bgcSearchMatch      = 5;
     fgcRightMargin      = 6;

     kbPreCtrlK          = kb_Ctrl + 8192;
     kbPreCtrlQ          = kb_Ctrl + 16384;
     kbPreCtrlO          = kb_Ctrl + 32768;
     kbPreCtrlU          = kb_Ctrl + 65536;

     {Ctrl-K codes}
     kbCtrlKA            = kbPreCtrlK + kb_Char + kbA;
     kbCtrlKB            = kbPreCtrlK + kb_Char + kbB;
     kbCtrlKC            = kbPreCtrlK + kb_Char + kbC;
     kbCtrlKD            = kbPreCtrlK + kb_Char + kbD;
     kbCtrlKE            = kbPreCtrlK + kb_Char + kbE;
     kbCtrlKF            = kbPreCtrlK + kb_Char + kbF;
     kbCtrlKG            = kbPreCtrlK + kb_Char + kbG;
     kbCtrlKH            = kbPreCtrlK + kb_Char + kbH;
     kbCtrlKI            = kbPreCtrlK + kb_Char + kbI;
     kbCtrlKJ            = kbPreCtrlK + kb_Char + kbJ;
     kbCtrlKK            = kbPreCtrlK + kb_Char + kbK;
     kbCtrlKL            = kbPreCtrlK + kb_Char + kbL;
     kbCtrlKM            = kbPreCtrlK + kb_Char + kbM;
     kbCtrlKN            = kbPreCtrlK + kb_Char + kbN;
     kbCtrlKO            = kbPreCtrlK + kb_Char + kbO;
     kbCtrlKP            = kbPreCtrlK + kb_Char + kbP;
     kbCtrlKQ            = kbPreCtrlK + kb_Char + kbQ;
     kbCtrlKR            = kbPreCtrlK + kb_Char + kbR;
     kbCtrlKS            = kbPreCtrlK + kb_Char + kbS;
     kbCtrlKT            = kbPreCtrlK + kb_Char + kbT;
     kbCtrlKU            = kbPreCtrlK + kb_Char + kbU;
     kbCtrlKV            = kbPreCtrlK + kb_Char + kbV;
     kbCtrlKW            = kbPreCtrlK + kb_Char + kbW;
     kbCtrlKX            = kbPreCtrlK + kb_Char + kbX;
     kbCtrlKY            = kbPreCtrlK + kb_Char + kbY;
     kbCtrlKZ            = kbPreCtrlK + kb_Char + kbZ;

     {Ctrl-Q codes}
     kbCtrlQA            = kbPreCtrlQ + kb_Char + kbA;
     kbCtrlQB            = kbPreCtrlQ + kb_Char + kbB;
     kbCtrlQC            = kbPreCtrlQ + kb_Char + kbC;
     kbCtrlQD            = kbPreCtrlQ + kb_Char + kbD;
     kbCtrlQE            = kbPreCtrlQ + kb_Char + kbE;
     kbCtrlQF            = kbPreCtrlQ + kb_Char + kbF;
     kbCtrlQG            = kbPreCtrlQ + kb_Char + kbG;
     kbCtrlQH            = kbPreCtrlQ + kb_Char + kbH;
     kbCtrlQI            = kbPreCtrlQ + kb_Char + kbI;
     kbCtrlQJ            = kbPreCtrlQ + kb_Char + kbJ;
     kbCtrlQK            = kbPreCtrlQ + kb_Char + kbK;
     kbCtrlQL            = kbPreCtrlQ + kb_Char + kbL;
     kbCtrlQM            = kbPreCtrlQ + kb_Char + kbM;
     kbCtrlQN            = kbPreCtrlQ + kb_Char + kbN;
     kbCtrlQO            = kbPreCtrlQ + kb_Char + kbO;
     kbCtrlQP            = kbPreCtrlQ + kb_Char + kbP;
     kbCtrlQQ            = kbPreCtrlQ + kb_Char + kbQ;
     kbCtrlQR            = kbPreCtrlQ + kb_Char + kbR;
     kbCtrlQS            = kbPreCtrlQ + kb_Char + kbS;
     kbCtrlQT            = kbPreCtrlQ + kb_Char + kbT;
     kbCtrlQU            = kbPreCtrlQ + kb_Char + kbU;
     kbCtrlQV            = kbPreCtrlQ + kb_Char + kbV;
     kbCtrlQW            = kbPreCtrlQ + kb_Char + kbW;
     kbCtrlQX            = kbPreCtrlQ + kb_Char + kbX;
     kbCtrlQY            = kbPreCtrlQ + kb_Char + kbY;
     kbCtrlQZ            = kbPreCtrlQ + kb_Char + kbZ;

     kbCtrlShiftA        = kb_Ctrl + kb_Shift + kb_Char + 65;
     kbCtrlShiftP        = kb_Ctrl + kb_Shift + kb_Char + 80;
     kbCtrlShiftR        = kb_Ctrl + kb_Shift + kb_Char + 82;
     kbCtrlShiftS        = kb_Ctrl + kb_Shift + kb_Char + 83;
     kbCtrlShiftI        = kb_Ctrl + kb_Shift + kb_Char + 73;
     kbCtrlShiftU        = kb_Ctrl + kb_Shift + kb_Char + 85;
     kbCtrlShiftY        = kb_Ctrl + kb_Shift + kb_Char + 89;
     kbCtrlShiftZ        = kb_Ctrl + kb_Shift + kb_Char + 90;
     kbCtrlSlash         = kb_Ctrl + kb_Shift + kb_Char + 47;
     kbCtrlBackSlash     = kb_Ctrl + kb_Shift + kb_Char + 92;

     kbCtrlShiftCLeft    = kb_Ctrl + kb_Shift + kbCLeft;
     kbCtrlShiftCRight   = kb_Ctrl + kb_Shift + kbCRight;
     kbCtrlShiftHome     = kb_Ctrl + kb_Shift + kbHome;
     kbCtrlShiftEnd      = kb_Ctrl + kb_Shift + kbEnd;
     kbCtrlShiftPageUp   = kb_Ctrl + kb_Shift + kbPageUp;
     kbCtrlShiftPageDown = kb_Ctrl + kb_Shift + kbPageDown;
     kbCtrlShiftBkSp     = kb_Ctrl + kb_Shift + kbBkSp {$ifdef os2}+ kb_Alt{$endif};{Martin0308}

     kbCtrlAltShiftCLeft = kb_Ctrl + kb_Alt + kb_Shift + kbCLeft;
     kbCtrlAltShiftCRight= kb_Ctrl + kb_Alt + kb_Shift + kbCRight;
     kbCtrlAltShiftHome  = kb_Ctrl + kb_Alt + kb_Shift + kbHome;
     kbCtrlAltShiftEnd   = kb_Ctrl + kb_Alt + kb_Shift + kbEnd;
     kbCtrlAltShiftPageUp= kb_Ctrl + kb_Alt + kb_Shift + kbPageUp;
     kbCtrlAltShiftPageDown = kb_Ctrl + kb_Alt + kb_Shift + kbPageDown;

     kbAltShiftBkSp      = kb_Alt + kb_Shift + kbBkSp;
     kbAltShiftCLeft     = kb_Alt + kb_Shift + kbCLeft;
     kbAltShiftCRight    = kb_Alt + kb_Shift + kbCRight;
     kbAltShiftCUp       = kb_Alt + kb_Shift + kbCUp;
     kbAltShiftCDown     = kb_Alt + kb_Shift + kbCDown;
     kbAltShiftPageUp    = kb_Alt + kb_Shift + kbPageUp;
     kbAltShiftPageDown  = kb_Alt + kb_Shift + kbPageDown;
     kbAltShiftHome      = kb_Alt + kb_Shift + kbHome;
     kbAltShiftEnd       = kb_Alt + kb_Shift + kbEnd;

     kbCtrlOC            = kbPreCtrlO + kb_Char + kbC;
     kbCtrlOK            = kbPreCtrlO + kb_Char + kbK;
     kbCtrlOU            = kbPreCtrlO + kb_Char + kbU;
     kbCtrlK0            = kbPreCtrlK + kb_Char + kb0;
     kbCtrlK9            = kbPreCtrlK + kb_Char + kb9;
     kbCtrlQ0            = kbPreCtrlQ + kb_Char + kb0;
     kbCtrlQ9            = kbPreCtrlQ + kb_Char + kb9;
     kbCtrlU0            = kbPreCtrlU + kb_Char + kb0;
     kbCtrlU9            = kbPreCtrlU + kb_Char + kb9;
     kbCtrlUU            = kbPreCtrlU + kb_Char + kbU;


Type
    PLine=^TLine;
    TLine=Record
         Prev: PLine;
         zk:   PString;
         flag: LongWord;
         Add:  LongWord;
         data : Pointer;{Martin}
         Next: PLine;
    End;

    TColorTable=Array[0..255] Of TColor;

    TColorIndex=Record
         Fgc: Byte;
         Bgc: Byte;
    End;

    TColorArray=Array[1..StringLength] Of TColorIndex;

    TAttributeArray=Array[1..StringLength] of tFontAttributes; {Martin 9/2005, only accessible if FontAttributesEnabled is TRUE}


    TEditorPos=Record
         Y: LongInt;
         X: Integer;
    End;

    TLineX=Record
         Line: PLine;
         X: Integer;
    End;

    TICB=Record                               {internal Clipboard}
         First: TLineX;
         Last: TLineX;
    End;

    TUndoGroup=(ugNoGroup,ugGroup,ugCursorMove,
         ugInsertChar,ugOverwriteChar,ugDeleteChar,ugBackspaceChar,
         ugDeleteActLine,ugDeleteRightWord,ugBlockLeft,ugBlockRight,
         ugBreakLine,ugEnter,ugTabulator,
         ugInsertLine,ugDeleteLine,ugReplaceLine);

    PUndo=^TUndo;
    TUndo=Record
         Memory: Boolean;
         EventType: TUndoGroup;
         Modified: Boolean;
         ICBFL: LongInt;
         ICBFX: Integer;
         ICBLL: LongInt;
         ICBLX: Integer;
         FFileCursor: TEditorPos;
         FrameBegin: LongInt;
         FrameEnd: LongInt;
         FirstUndoLine: PLine;
         LastUndoLine: PLine;
         Lines: LongInt;
    End;

{$M+}
    TEditOpt=Set Of (eoCreateBackups,eoAppendBAK,eoAutoIndent,
         eoUnindent,eoUndoGroups,eoCursorClimb,
         eoPersistentBlocks,eoOverwriteBlock,
         eoAutoSave,eo2ClickLine,eoSmartTabs,eoHomeFirstWord,{Martin}eoInvertInsOvrCursor, eoJumpWordSpace);

    TKeystrokeMap=(kmWordStar,kmCUA,kmDefault);
{$M-}

    TCursorShape=(csUnderline,csVertical);

    TSelectMode=(smNonInclusiveBlock,smColumnBlock);

    TICBPosition=Set Of (ipBeforeICBFirst,ipAfterICBFirst,ipWithinICB,
         ipBeforeICBLast,ipAfterICBLast);

    TFindAction=(faNothing,faFind,faReplace,faIncSearch);

    TFindReplace=Record
         Find: String;
         replace: String;
         Direction: TFindDirection;
         Origin: TFindOrigin;
         Scope: TFindScope;
         Options: TFindOptions;
         Confirm: Boolean;
         replall: Boolean;
         {Martin0206} FindHistory, ReplaceHistory : tStringList;
    End;


    TEditor=Class(TForm)
      Private
         {Martin} Rand : integer;
         {Martin0505} MouseX, MouseY : longint;
         {Martin0106} DraggedOver : boolean;
         FOldCaption: String;
         FKeyMap: TKeystrokeMap;
         FInsertMode: Boolean;
         FReadOnly: Boolean;
         FModified: Boolean;
         FUntitled: Boolean;
         FEditOpt: TEditOpt;
         FCountLines: LongInt;
         FBottomScrollBar: TScrollBar;
         FRightScrollBar: TScrollBar;
         ClientArea: TRect;
         FWinSize: TPoint;
         FScrCursor: TEditorPos;
         FFirstLine: PLine;
         FLastLine: PLine;
         FTopScreenLine: PLine;
         MaxUndo: LongInt;
         KeyRepeat: Integer;
         BookMarkX: Array[1..10] Of Integer;
         IncSearchList: TList;
         IncSearchText: String;
         FindICB: TICB;
         fMask: String;
         FSelColor: TColor;
         FSelBackColor: TColor;
         FFoundColor: TColor;
         FFoundBackColor: TColor;
         FWrapLineColor: TColor;
         FSaveEvents: Integer;
         FEventsCounter: Integer;
         WrapLineX: Integer;
         ScrOffsX: Integer;
         FFileName: String;
         FRecording: Boolean;
         FPlaying: Boolean;
         FCursorShape: TCursorShape;
         FWordWrap: Boolean;
         FWordWrapColumn: Integer;
         FLastFind: TFindAction;
         FBorderWidth: LongInt;
         FCtl3D: Boolean;
         FTempFileName: String;
         FDragRect: TRect;
         IsDBCSFont: Boolean;
         FLoadSaveAsAnsi : Boolean;{Martin2}
         Procedure SetFont(NewFont:TFont);Override;
         Procedure SetCtl3D(Value:Boolean);
         Procedure SetKeyMap(km:TKeystrokeMap);
         Procedure ToggleInsertMode;
         procedure ToggleSelectMode;{Martin0306}
         Procedure SetEditOpt(eo:TEditOpt);
         Procedure SetTabSize(ts:Integer);
         Procedure SetSaveEvents(cnt:Integer);
         Procedure SetLastUndoGroup(ug:TUndoGroup);
         Function GetLastUndoGroup:TUndoGroup;
         Procedure SetCursorShape(CS:TCursorShape);
         Procedure SetWordWrap(Wrap:Boolean);
         Procedure SetWordWrapColumn(Column:Integer);
         Function GetUndoCount:LongInt;
         Function GetRedoCount:LongInt;
         {basic structure}
         Function _PLine2Index(pl:PLine):LongInt;
         Function _Connect(pl1,pl2:PLine):Boolean;
         Function _CountLines(pl1,pl2:PLine):LongInt;
         {Undo/Redo}
         Function _CountUndoLines(FirstL,LastL:PLine):LongInt;
         Procedure _StoreUndoCursor(List:TList);
         Function _CopyUndoLines(FirstL,LastL:PLine):LongInt;
         Function _MoveUndoLines(List:TList;FirstL,LastL:PLine):LongInt;
         Procedure _CreateUndoEvent(List:TList;U:PUndo);
         Procedure _UpdateLastUndoEvent(List:TList;Index:LongInt);
         Procedure _FreeUndoEvent(List:TObject;Item:Pointer);
         Procedure _SetMaxUndo(cnt:LongInt);
         {WorkLine Manipulation}
         Function _WriteString(X:Integer; S:String):Boolean;
         Function _InsertString(X:Integer; S:String):Boolean;
         Function _DeleteString(X,CX:Integer):Boolean;
         Procedure _Set(Y:LongInt;Const S:String);
         Function _Get(Y:LongInt):String;
         Function _FindBookMark(I:Byte):PLine;
         Function _FindNextTab(pl:PLine; X:Integer):Integer;
         {Caret Movement}
         Function _HorizMove:Boolean;
         Function _GotoPosition(P:TEditorPos):Boolean;
         Function _CursorDown:Boolean;
         Function _CursorUp:Boolean;
         Function _CursorRight:Boolean;
         Function _CursorLeft:Boolean;
         Function _CursorHome:Boolean;
         Function _CursorEnd:Boolean;
         Function _CursorPageDown:Boolean;
         Function _CursorPageUp:Boolean;
         Function _CursorRollUp:Boolean;
         Function _CursorRollDown:Boolean;
         Function _CursorWordRight:Boolean;
         Function StepOverChar (Ch : char) : boolean; {Martin0207}
         Function _CursorWordLeft:Boolean;
         {Selection}
         Function _ICBExist:Boolean;
         Function _ICBOverwrite:Boolean;
         Function _ICBClearICB:Boolean;
         Function _ICBDeleteICB:Boolean;
         Procedure _ICBSetBegin(pl:PLine; X:Integer);
         Procedure _ICBSetEnd(pl:PLine; X:Integer);
         {Extend Selection}
         Function _ICBActPos:TLineX;
         Function _ICBExtSetICB:Boolean;
         Function _ICBExtCorrectICB:Boolean;
         Function _ICBTestIEW(Var y1,y2:Integer):Boolean;
         Function CheckWordsOnly(pl:PLine; Var I:Integer; Const S:String):Boolean;
         Function GetDefaultExt(Mask:String):String;
      Protected

         FRunInAnsi : Boolean;{Martin2; in Win32 a OEM (IBM) codepage can be also used}
         IgnoreRedraw: Integer;
         FCaret: TCaret;
         HadFocus: Integer;
         Function _ICBPersistent:Boolean; virtual;
{Martin new methods}
         function MarkInsertedText : boolean; virtual; {Martin0106}
         DeleteRightWordCount : integer;
         RememberKRKWfilename : string;
         FontAttributesEnabled : boolean;
         NormalChar : array[false..true{RunInAnsi}, #0..#255] of boolean;
         function AllowSelectionWithMouse : boolean; virtual;
         function _WriteFileText (S : String; Var P:Pointer; Var len:LongInt):Boolean; virtual;
         procedure ReplacePLine(Pl : PLine;Const S:String);
         procedure ConvertFileRead (var P : Pointer; var len : longint); virtual;
         procedure ConvertFileWrite (var P : Pointer; var len : longint); virtual;
         procedure UseNextReturnflag (pl : PLine); virtual;
         Procedure SetPHardReturn(pl:PLine;Const S:boolean); virtual;
         Function GetPHardReturn(pl:PLine):boolean; virtual;
         Procedure SetPBreakReturn(pl:PLine;Const S:boolean); virtual;
         Function GetPBreakReturn(pl:PLine):boolean; virtual;
         function DeleteIndent (pl : PLine; var Line : string) : byte; virtual;
         function EditorposInICB (Editorpos : tEditorpos; SurroundingArea : boolean) : boolean;
         function LineFlagsDeleted (Flags : longword) : longword;
         function DoSearchLine (Pl : PLine) : boolean; virtual;
         procedure NewReplaceDialogCaption (Dialog : tFindDialog); virtual;

         {Line Visibility: Martin 11/2004, I began to program, but it's not finished,
          but some tEditor functions are now better encapsulated}
         FShowAllLines : boolean; {set by the user property ShowAllLines}
         ReferToAllLines : boolean; {some procedures of tEditor turn off ReferToAllLines, e.g. writing a file}
         procedure PLineNewString (Pl : PLine; var St : string);
         function LineIsAlwaysVisible (Pl : PLine) : boolean; virtual; {override to for the visibility definition}
         function PrevPl (Pl : PLine) : PLine; {substitute for Pl^.prev}
         function NextPl (Pl : PLine) : PLine; {substitute for Pl^.next}
         {property ShowAllLines; -> public}

         {overwrite for Syntax-Highlightning!
          kann fÅr die Programmierung von Syntax-Highlightning Åberschrieben werden;
          im Prinzip nur zwei Zeilen in eigene Prozedur ausgelagert
          Wie hat das Rene in der IDE gemacht? Das ganze CalcLineColor Åberschrieben?}
         procedure DefineLineColors (pl:PLine;Var LineColor:TColorArray; Var LineAtt : tAttributeArray; First, Last : integer); Virtual;

{Martin from private to protected}

         FFind, FFindReplace: TFindReplace; {Martin0206}
         FPreCtrl: TKeyCode;
         FMacroList: TList;
         FActLine: PLine;
         FWorkLine: String;
         WLactivated: Boolean;
         FSelectMode: TSelectMode;
         ICB: TICB;
         ICBVisible: Boolean;
         FFileCursor: TEditorPos;
         FTabSize: Integer;
         FUndoList: TList;
         FRedoList: TList;
         Function _ICBPos(pl:PLine; X:Integer):TICBPosition;
         Function _Index2PLine(Y:LongInt):PLine;
         Function _GetEditorBlock(Var P:Pointer; Var len:LongInt):Boolean; virtual;
         Function _InsertText(P:Pointer; len:LongInt; marknew:Boolean):TLineX; virtual;
         Procedure CalcSizes;
         Procedure SetSelectMode(sm:TSelectMode); virtual;
         Procedure SetInsertMode(im:Boolean); virtual;
         {Martin new}
         AdditionalUndo : boolean;
         procedure _InsertColumnText(P:Pointer; len:LongInt); virtual;
         Procedure _ReadWorkLine;  virtual;
         Procedure _WriteWorkLine; virtual;
         Function _ReadString(pl:PLine; X,CX:Integer):String; virtual;
         Function _ICBClearMark:Boolean; virtual;
         Function _ICBSetMark:Boolean; virtual;
         Procedure _ICBCheckX; virtual;
         Function _ICBExtCorrectICB2:Boolean; virtual;
         Function _PLine2PString(pl:PLine):PString; virtual;
         {Text block operations}
         Function _GetFileText(S:String; Var P:Pointer; Var len:LongInt):Boolean; virtual;
         Function _GetEditorText(Var P:Pointer; Var len:LongInt):Boolean; virtual;
         {Insert/Delete Lines}
         Function _InsertLine(pl:PLine):PLine; virtual;
         Function _DeleteLine(pl:PLine):PLine; virtual;


         IndentRect: TRect;
         {Martin} RealCharEvent : boolean;
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Function CloseQuery:Boolean;Override;
         {Martin}Function FileCloseQuery : boolean; virtual;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure SetFocus;Override;
         Procedure KillFocus;Override;
         Procedure Resize;Override;
         procedure DelayScroll (Y : longint);{Martin}
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);Override;
         Procedure CanDrag(X,Y:LongInt;Var Accept:Boolean);Override;
         Procedure DoStartDrag(Var DragData:TDragDropData);Override;
         Procedure DoEndDrag(target:TObject; X,Y:LongInt);Override;
         Procedure DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);Override;
         function GetDragDropFileName (P : Pointer; len : longint) : String;
         Procedure SetSliderValues; virtual;
         Procedure SetSliderPosition;
         Procedure FlushWorkLine;
         Function GetCursorFromMouse(pt:TPoint):TEditorPos;
         Function GetMouseFromCursor(Pos:TEditorPos):TPoint;
         {Caret Movement}
         Procedure cmCursorDown;
         Procedure cmCursorUp;
         Procedure cmCursorRight; {Martin} virtual;
         Procedure cmCursorLeft; {Martin} virtual;
         Procedure cmCursorHome;
         Procedure cmCursorEnd;
         Procedure cmCursorPageDown;
         Procedure cmCursorPageUp;
         Procedure cmCursorRollUp;
         Procedure cmCursorRollDown;
         Procedure cmCursorWordRight;
         Procedure cmCursorWordLeft;
         Procedure cmCursorFileBegin;
         Procedure cmCursorFileEnd;
         Procedure cmCursorPageHome;
         Procedure cmCursorPageEnd;
         {Selection}
         Procedure cmICBExtLeft;
         Procedure cmICBExtRight;
         Procedure cmICBExtUp;
         Procedure cmICBExtDown;
         Procedure cmICBExtPageUp;
         Procedure cmICBExtPageDown;
         Procedure cmICBExtHome;
         Procedure cmICBExtEnd;
         Procedure cmICBExtWordLeft;
         Procedure cmICBExtWordRight;
         Procedure cmICBExtFileBegin;
         Procedure cmICBExtFileEnd;
         Procedure cmICBExtPageBegin;
         Procedure cmICBExtPageEnd;
         {ICB edit}
         Procedure cmICBReadBlock;Virtual;
         Procedure cmICBWriteBlock;Virtual;
         Procedure cmICBMoveLeft;Virtual;
         Procedure cmICBMoveRight;Virtual;
         Procedure cmICBCopyBlock;Virtual;
         Procedure cmICBMoveBlock;Virtual;
         Procedure cmICBDeleteBlock;Virtual;
         Procedure cmICBUpcaseBlock;Virtual;
         Procedure cmICBLowcaseBlock;Virtual;
         Procedure cmICBUpcaseWord;Virtual;
         Procedure cmICBLowcaseWord;Virtual;
         Procedure cmToggleCase;Virtual;
         {edit}
         Procedure cmBreakLine;Virtual;
         Procedure cmDeleteLine;Virtual;
         Procedure cmDeleteLineEnd;Virtual;
         Procedure cmDeleteRightWord;Virtual;
         Procedure cmDeleteLeftWord;Virtual;
         Procedure cmTabulator;Virtual;
         Procedure cmPrevTabulator;Virtual;
         Procedure cmDeleteChar;Virtual;
         Procedure cmBackSpace;Virtual;
         Procedure cmEnter;Virtual;
         Procedure cmFindText;Virtual;
         Procedure cmReplaceText;Virtual;
         Procedure cmSearchTextAgain;Virtual;
         Procedure cmIncrementalSearch;Virtual;
         Procedure cmRecordMacro;Virtual;
         Procedure cmPlayMacro;Virtual;
         {overwrite This Methods For personal Use}
         {Martin2} procedure SetRunInAnsi(AnsiCP:Boolean);Virtual;
         Function GetReadOnly:Boolean;Virtual;
         Procedure SetReadOnly(Value:Boolean);Virtual;
         Procedure SetModified(Value:Boolean);Virtual;
         Procedure UpdateEditorState;Virtual;
         Procedure SetStateMessage(Const S:String);Virtual;
         Procedure SetErrorMessage(Const S:String);Virtual;
         Function SetQueryMessage(Const S:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;Virtual;
         Function SetReplaceConfirmMessage:TMsgDlgReturn;Virtual;
         Function UpdateLineColorFlag(pl:PLine):Boolean;Virtual;
         Procedure SetLineColorFlag(pl1,pl2:PLine);Virtual;
         Procedure CalcLineColor(pl:PLine;Var LineColor:TColorArray; Var LineAtt : tAttributeArray);Virtual;
         Procedure InvalidateScreenLine(ScrY:Integer);Virtual;
         Procedure InvalidateWorkLine;Virtual;
         Procedure InvalidateEditor(y1,y2:Integer);Virtual;
         Procedure SetScreenCursor;Virtual;
         Function QueryConvertPos(Var Pos:TPoint):Boolean;Override;
         Procedure SetIncSearchText(S:String);Virtual;
         Function TestSaveAsName(Const FName:String):TMsgDlgReturn;Virtual;
         Function TestFileWriteName(Const FName:String):TMsgDlgReturn;{Martin0806}
         Procedure FileNameChange(Const OldName,NewName:String);Virtual;
         Procedure TestAutoSave;Virtual;
         Procedure SetFileName(Const FName:String);Virtual;
         Procedure SetAvailabeFileTypes(CFOD:{$ifdef os2}TOpenDialog{$else}TSystemOpenSaveDialog{$endif});Virtual;
         Function EmulateWordStar(Var KeyCode,PreControl:TKeyCode):Boolean;Virtual;
         Function EmulateCUA(Var KeyCode,PreControl:TKeyCode):Boolean;Virtual;
         Function EmulateDefault(Var KeyCode,PreControl:TKeyCode):Boolean;Virtual;
         Procedure SetColorEntry(ColorIndex:Integer;NewColor:TColor);Virtual;
         Function GetColorEntry(ColorIndex:Integer):TColor;Virtual;
         Property FirstLine:PLine Read FFirstLine;
         Property LastLine:PLine Read FLastLine;
         Property ActLine:PLine Read FActLine;
         property ActLineX : TLineX Read _ICBActPos;
         Property TopScreenLine:PLine Read FTopScreenLine;
         Property indices[pl:PLine]:LongInt Read _PLine2Index;
         Property PLines[Index:LongInt]:PLine Read _Index2PLine;
         Property PStrings[pl:PLine]:PString Read _PLine2PString;
         Property LastUndoGroup:TUndoGroup Read GetLastUndoGroup Write SetLastUndoGroup;
         Property MacroList:TList Read FMacroList Write FMacroList;
         Property MacroRecording:Boolean Read FRecording;
         Property MacroPlaying:Boolean Read FPlaying;
         Property LastFind:TFindAction Read FLastFind Write FLastFind;
         function TabulatorRelatedLine : PLine; virtual; {Martin1107}

         {Martin0207: New Heap Memory functionality with HeapGroups}
      private
         FHeapgroupID : integer;
      protected
         PROCEDURE getmem (VAR p:POINTER;size:LONGWORD);
         PROCEDURE freemem (p:POINTER;size:LONGWORD);
      Public
         PROCEDURE editorgetmem (VAR p:POINTER;size:LONGWORD);{fÅr die Benutzung von au·en}
         PROCEDURE editorfreemem (p:POINTER;size:LONGWORD); {fÅr die Benutzung von au·en}
         //Constructor Create(AOwner:TComponent);Override;


      Public

         {Martin}TopPanel : tPanel; {default is NIL, use only the panel with Align alTop because of conflict with HorzScrollbar}
         ConvertShiftCtrlChar2CtrlChar : boolean;

         Destructor Destroy;Override;
         Procedure BeginUpdate;
         Procedure EndUpdate;
         {Martin2005}Procedure BeginDrag(Immediate:Boolean); override; {-> in Forms.pas auf virtual schalten!}
         Procedure DragDrop(Source:TObject;X,Y:LongInt);Override;
         Procedure Redraw(Const rc:TRect);Override;
         Function LoadFromFile(Const FName:String):Boolean;Virtual;
         Function SaveToFile(Const FName:String):Boolean;Virtual;
         Function LoadFromStream(Stream:TStream):Boolean;
         Function SaveToStream(Stream:TStream):Boolean;
         Function SaveFile:Boolean;Virtual;
         Function SaveFileAs(Const FName:String):Boolean;Virtual;
         Function InsertLine(Y:LongInt;Const S:String):LongInt;
         Function DeleteLine(Y:LongInt):LongInt;
         Function AppendLine(Const S:String):LongInt;
         Function ReplaceLine(Y:LongInt;Const S:String):LongInt;
         Procedure SetSelectionStart(P:TEditorPos);
         Procedure SetSelectionEnd(P:TEditorPos);
         Function GetSelectionStart(Var P:TEditorPos):Boolean;
         Function GetSelectionEnd(Var P:TEditorPos):Boolean;
         Procedure SelectLine(P:TEditorPos);
         Procedure SelectWord(P:TEditorPos);
         Procedure SelectAll;
         Procedure DeselectAll;
         Procedure HideSelection;
         Procedure ShowSelection;
         Procedure DeleteSelection;
         Procedure GotoPosition(Pos:TEditorPos);
         Procedure GotoPosition_restoreICB (Pos:TEditorPos); {Martin0206}
         Function SetBookMark(I:Byte; P:TEditorPos):Boolean;
         Function GetBookMark(I:Byte;Var P:TEditorPos):Boolean;
         Function GotoBookMark(I:Byte):Boolean;
         Function ClearBookMark(I:Byte):Boolean;
         Function ClearAllBookMarks:Boolean;
         Function GetChar(P:TEditorPos):Char;
         Function GetWord(P:TEditorPos):String;
         Function GetTextAfterWord(P:TEditorPos):String;
         Function GetPartialText(p1,p2:TEditorPos;Var P:Pointer; Var len:LongInt):Boolean;
         Function GetText(Var P:Pointer; Var len:LongInt; Selected:Boolean):Boolean;Virtual;
         Procedure InsertText(P:Pointer; len:LongInt); virtual;
         Function FindTextPos(Find:String; direct:TFindDirection; Origin:TFindOrigin;
                               Scope:TFindScope; opt:TFindOptions; Var pt:TEditorPos):Boolean;
         Function FindText({Martin2}(*Const*) Find:String; direct:TFindDirection; Origin:TFindOrigin;
                           Scope:TFindScope; opt:TFindOptions):Boolean; virtual;
         Function ReplaceText({Martin2}(*Const*) Find,replace:String; direct:TFindDirection;
                              Origin:TFindOrigin;Scope:TFindScope;opt:TFindOptions;
                              Confirm:Boolean;replaceall:Boolean):Boolean; virtual;
         Procedure Undo;
         Procedure Redo;
         Procedure ClearUndo;
         Procedure ClearRedo;
         Procedure CutToClipBoard;Virtual;
         Procedure CopyToClipboard;Virtual;
         Function PasteFromClipBoard:Boolean;Virtual;
         Function InsertFromFile(Const FName:String):Boolean;Virtual;
         Procedure SearchTextAgain;
         Procedure FindTextDlg;
         Procedure ReplaceTextDlg;
         {Martin3} procedure ConvertSpecialChars (var St : string); virtual;
         Property FileName:String Read FFileName Write SetFileName;
         Property CountLines:LongInt Read FCountLines;
         Property Lines[Index:LongInt]:String Read _Get Write _Set; Default;
         Property CursorPos:TEditorPos Read FFileCursor Write GotoPosition;
         Property OffsetPos:TEditorPos Read FScrCursor;
         Property MaxUndoEvents:LongInt Read MaxUndo Write _SetMaxUndo;
         Property UndoCount:LongInt Read GetUndoCount;
         Property RedoCount:LongInt Read GetRedoCount;
         Property AutoSaveEvents:Integer Read FSaveEvents Write SetSaveEvents;
         Property BottomScrollBar:TScrollBar Read FBottomScrollBar Write FBottomScrollBar;
         Property RightScrollBar:TScrollBar Read FRightScrollBar Write FRightScrollBar;
         Property Mask:String Read fMask Write fMask;
         Property Selected:Boolean Read _ICBExist;
         Property Columns:LongInt Read FWinSize.X;
         Property Rows:LongInt Read FWinSize.Y;
         Property ColorEntry[ColorIndex:Integer]:TColor Read GetColorEntry Write SetColorEntry;
         Property CursorShape:TCursorShape Read FCursorShape Write SetCursorShape;
         Property SelectMode:TSelectMode Read FSelectMode Write SetSelectMode;
         Property WordWrap:Boolean Read FWordWrap Write SetWordWrap;
         Property WordWrapColumn:Integer Read FWordWrapColumn Write SetWordWrapColumn;
         Property InsertMode:Boolean Read FInsertMode Write SetInsertMode;
         Property Modified:Boolean Read FModified Write SetModified;
         Property Untitled:Boolean Read FUntitled Write FUntitled;
         Property ReadOnly:Boolean Read GetReadOnly Write SetReadOnly;
         Property LoadSaveAsAnsi:Boolean Read FLoadSaveAsAnsi Write FLoadSaveAsAnsi;
         {Martin2} Property RunInAnsi:Boolean Read FRunInAnsi Write SetRunInAnsi;
         {Martin} procedure LoadStringOfPLine(pl:PLine; var Line : string);
         {Clipboard}
         Function _SetClipBoardText(P:Pointer; len:LongInt):Boolean;virtual;
         Function _GetClipBoardText(Var P:Pointer; Var len:LongInt):Boolean;virtual;
      Published
         Property KeystrokeMap:TKeystrokeMap Read FKeyMap Write SetKeyMap;
         Property EditOptions:TEditOpt Read FEditOpt Write SetEditOpt;
         Property TabSize:Integer Read FTabSize Write SetTabSize;
         Property Ctl3D:Boolean Read FCtl3D Write SetCtl3D;
    End;
                        
    TEditorClass=Class Of TEditor;

Function EditorPos(Line:LongInt;Column:Integer):TEditorPos;
procedure CharLowerCase (Ansi : boolean; var C : char);
procedure CharUpperCase (Ansi : boolean; var C : char);
Function GetDefaultExt(Mask:String):String;              // WD: Wird in WDSibylIDE verwendet
//Function CheckWordsOnly(pl:PLine; Var I:Integer; Const S:String):Boolean; // WD: Wird in WDSibylIDE verwendet

{Martin: should be available in other units}
Type
    TCharArray=Array[1..MaxLongInt] Of Char;
    PCharArray=^TCharArray;
var
    {Martin}FindDialogHelpContext : word;
    {Martin057}FindDialogHelpContextString : string[30];

Procedure ConvertToAnsi(Ptr:PCharArray;len:LongInt);
Procedure ConvertToOEM(Ptr:PCharArray;len:LongInt);
{Martin2}procedure ConvertStringToOEM(var St : string);
{Martin2}procedure ConvertStringToAnsi(var St : string);

Implementation

{Martin empty procedures}
procedure TEditor.UseNextReturnflag (pl : PLine);
  begin
  end;
Procedure TEditor.SetPHardReturn(pl:PLine;Const S:boolean);
  begin
  end;
Function TEditor.GetPHardReturn(pl:PLine):boolean;
  begin
    result := true;
  end;
Procedure TEditor.SetPBreakReturn(pl:PLine;Const S:boolean);
  begin
  end;
Function TEditor.GetPBreakReturn(pl:PLine):boolean;
  begin
    result := false;
  end;
function TEditor.DeleteIndent (pl : PLine; var Line : string) : byte;
  begin
    result := 0;
  end;
procedure TEditor.ConvertFileRead (var P : Pointer; var len : longint);
  begin
  end;
procedure TEditor.ConvertFileWrite (var P : Pointer; var len : longint);
  begin
  end;
function tEditor.DoSearchLine (Pl : PLine) : boolean;
  begin
    result := true;
  end;
procedure tEditor.NewReplaceDialogCaption (Dialog : tFindDialog);
  begin
  end;

function tEditor.LineIsAlwaysVisible (Pl : PLine) : boolean; {override to for the visibility definition}
  begin
    result := true;
  end;

procedure tEditor.PLineNewString (Pl : PLine; var St : string);
  var
    lwl : integer;
  begin
    lwl := Length(St);
    GetMem(Pl^.zk, lwl+1);
    Pl^.zk^ := St;
    {VisibleLines}
    if LineIsAlwaysVisible (Pl) then
      pl^.flag := pl^.flag AND NOT ciInvisible
    else
      pl^.flag := pl^.flag OR ciInvisible;
  end;

function tEditor.PrevPl (Pl : PLine) : PLine; {substitute for Pl^.prev}
  begin
    if ReferToAllLines or FShowAllLines then
      result := Pl^.prev
    else begin
      {search the previous line which has got a visible flag set}
      repeat
        Pl := Pl^.prev;
      until (Pl = nil) or (Pl^.flag AND ciInvisible = 0);
      result := Pl;
    end;
  end;

function tEditor.NextPl (Pl : PLine) : PLine; {substitute for Pl^.next}
  begin
    if ReferToAllLines or FShowAllLines then
      result := Pl^.next
    else begin
      {search the previous line which has got a visible flag set}
      repeat
        Pl := Pl^.next;
      until (Pl = nil) or (Pl^.flag AND ciInvisible = 0);
      result := Pl;
    end;
  end;

Const
    SpaceChar:Char=#32;

{$B+}  {Complete Boolean Evaluation}

Function tEditor.CheckWordsOnly(pl:PLine; Var I:Integer; Const S:String):Boolean;
Begin
     Result := False;
     If I = 0 Then Exit;

     If I > 1 Then
       If NormalChar[RunInAnsi, pl^.zk^[I-1]] Then
       Begin
            I := - I;
            Exit;
       End;

     If I+Length(S)-1 < Length(pl^.zk^) Then
       If NormalChar[RunInAnsi, pl^.zk^[I+Length(S)]] Then
       Begin
            I := - I;
            Exit;
       End;
     Result := True;
End;

Function tEditor.GetDefaultExt(Mask:String):String;
Var  P:Integer;
Begin
     Result := '';
     If Mask = '*.*' Then Exit;
     P := Pos('.',Mask);
     If P = 0 Then Exit;
     Delete(Mask,1,P);
     Result := Mask;
End;

Function GetDefaultExt(Mask:String):String;
Var  P:Integer;
Begin
  Result := '';
  If Mask = '*.*' Then Exit;
  P := Pos('.',Mask);
  If P = 0 Then Exit;
  Delete(Mask,1,P);
  Result := Mask;
End;

Function EditorPos(Line:LongInt;Column:Integer):TEditorPos;
Begin
  Result.Y := Line;
  Result.X := Column;
End;



{
…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
∫                                                                           ∫
∫ Sibyl Portable Component Classes (SPCC)                                   ∫
∫                                                                           ∫
∫ This section: TEditor Class Implementation                                ∫
∫                                                                           ∫
»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº
}

Procedure TEditor.SetFont(NewFont:TFont);
Begin
  If NewFont = Nil Then Exit;
  If NewFont.Pitch = fpFixed Then
    {$ifdef os2}
    If NewFont.FontType = ftBitmap Then
      Begin
    {$endif}
        Inherited SetFont(NewFont);
        IsDBCSFont := NewFont.CharSet <> fcsSBCS;
        If Handle = 0 Then Exit;
        Canvas.Font := NewFont;
        CalcSizes;
        SetCursorShape(FCursorShape);
        Invalidate;
      {$ifdef os2}
      End;
      {$endif}
End;


Procedure TEditor.SetKeyMap(km:TKeystrokeMap);
Begin
     FKeyMap := km;
     ICBVisible := True;
     InvalidateEditor(0,0);
End;


Procedure TEditor.SetInsertMode(im:Boolean);
Begin
     FInsertMode := im;
     SetCursorShape(FCursorShape); {Update}
End;


Procedure TEditor.SetCursorShape(CS:TCursorShape);
Var  X,Y:Integer;
Begin
     FCursorShape := CS;

     FCaret.Remove;
     If (Not FInsertMode) xor (FEditOpt * [eoInvertInsOvrCursor] <> []) Then
     Begin
          X := Canvas.FontWidth;
          Y := Canvas.FontHeight;
     End
     Else
     If FCursorShape = csUnderline Then
     Begin
          X := Canvas.FontWidth;
          Y := 2;
     End
     Else
     Begin
          X := 1;
          Y := Canvas.FontHeight;
     End;
     FCaret.SetSize(X,Y);
     SetScreenCursor;
     If HadFocus > 0 Then FCaret.Show;
End;


Procedure TEditor.SetSelectMode(sm:TSelectMode);
Begin
     If Application.DBCSSystem Then sm := smNonInclusiveBlock;

     FSelectMode := sm;
     ICBVisible := True;
     _ICBCheckX;
     InvalidateEditor(0,0);
End;


Procedure TEditor.SetEditOpt(eo:TEditOpt);
Begin
     FEditOpt := eo;
End;


Procedure TEditor.SetTabSize(ts:Integer);
Begin
     If (ts > 0) And (ts < StringLength) Then FTabSize := ts;
End;


Procedure TEditor.SetWordWrap(Wrap:Boolean);
Begin
     If FWordWrap <> Wrap Then
     Begin
          FWordWrap := Wrap;
          InvalidateEditor(0,0);
     End;
End;


Procedure TEditor.SetWordWrapColumn(Column:Integer);
Begin
     FWordWrapColumn := Column;
     If FWordWrap Then InvalidateEditor(0,0);
End;


Function TEditor.GetUndoCount:LongInt;
Begin
     Result := FUndoList.Count;
End;


Function TEditor.GetRedoCount:LongInt;
Begin
     Result := FRedoList.Count;
End;


Procedure TEditor.FlushWorkLine;
Begin
     If WLactivated Then _WriteWorkLine;
End;


{Convert Line Number (1..N) To Line Pointer}
Function TEditor._Index2PLine(Y:LongInt):PLine;
Var  I:LongInt;
Begin
     Result := Nil;
     If (Y < 1) Or (Y > FCountLines) Then Exit;

     If Y < (FCountLines Shr 1) Then {Search Forward}
     Begin
          Result := FFirstLine;
          For I := 2 To Y Do
          Begin
               If Result <> Nil Then Result := Result^.Next
               Else Exit;
          End;
     End
     Else {Search backward}
     Begin
          Result := FLastLine;
          For I := FCountLines-1 DownTo Y Do
          Begin
               If Result <> Nil Then Result := Result^.Prev
               Else Exit;
          End;
     End;
End;


{Convert Line Pointer To Line Number (1..N)}
Function TEditor._PLine2Index(pl:PLine):LongInt;
Var  pl1:PLine;
Begin
     Result := 0;
     pl1 := FFirstLine;
     While pl1 <> Nil Do
     Begin
          Inc(Result);
          If pl1 = pl Then Exit;
          pl1 := pl1^.Next;
     End;
     Result := 0;
End;


{return the Pointer To the String Of the Line}
Function TEditor._PLine2PString(pl:PLine):PString;
Begin
     If pl <> Nil Then
     Begin
          If pl^.zk <> Nil Then Result := pl^.zk
          Else Result := @FWorkLine;
     End
     Else Result := Nil;
End;


{Connect two Line pointers}
Function TEditor._Connect(pl1,pl2:PLine):Boolean;
Begin
     If pl1 <> Nil Then pl1^.Next := pl2
     Else FFirstLine := pl2;
     If pl2 <> Nil Then pl2^.Prev := pl1
     Else FLastLine := pl1;
     Result := True;
End;


{Count Number Of Lines including both Lines}
Function TEditor._CountLines(pl1,pl2:PLine):LongInt;
Var  pl:PLine;
Begin
     Result := 0;
     pl := pl1;
     While pl <> Nil Do
     Begin
          Inc(Result);
          If pl = pl2 Then Exit;
          pl := pl^.Next;
     End;
     Result := 0;
     pl := pl1;
     While pl <> Nil Do
     Begin
          Dec(Result);
          If pl = pl2 Then Exit;
          pl := pl^.Prev;
     End;
     Result := 0;
End;


function tEditor.LineFlagsDeleted (Flags : longword) : longword; {Martin}
  begin
    {delete all flags _besides_ ciSoftreturn and ciBreakreturn}
    result := Flags AND (ciSoftReturn OR ciBreakReturn);
    (*if (flags AND ciSoftReturn <> 0) then
      flags := ciSoftReturn;
    else
      flags := ciNormal;*)
  end;

{ +++ Undo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }

{Count the Lines from FirstL To LastL And Reset the Line color}
Function TEditor._CountUndoLines(FirstL,LastL:PLine):LongInt;
Var  TempL:PLine;
Begin
     Result := _CountLines(FirstL,LastL);
     If Result > 0 Then
     Begin
          TempL := FirstL;
          {Martin}
          While TRUE Do
          Begin
               if TempL = nil then break;
               TempL^.flag := LineFlagsDeleted (TempL^.flag);
               if TempL = LastL then break;
               TempL := TempL^.Next;
          End;

     End
     Else Result := 0;
End;


{save the File Cursor Position}
Procedure TEditor._StoreUndoCursor(List:TList);
Var  U:PUndo;
Begin
     Getmem(U,sizeof(U^));
     U^.Memory := False;
     U^.EventType := ugCursorMove;
     U^.Modified := Modified;
     U^.ICBFL := _PLine2Index(ICB.First.Line);
     U^.ICBFX := ICB.First.X;
     U^.ICBLL := _PLine2Index(ICB.Last.Line);
     U^.ICBLX := ICB.Last.X;
     U^.FFileCursor := FFileCursor;
     _CreateUndoEvent(List,U);
End;


{save the File Cursor Position And Copy the specified Lines In the stack}
Function TEditor._CopyUndoLines(FirstL,LastL:PLine):LongInt;
Var  U:PUndo;
     FUL,LUL:PLine;
     pl:PLine;
     ptnew:PLine;
     ptlast:PLine;
     CL:LongInt;
Begin
     FlushWorkLine;
     CL := 0;
     ptnew := Nil;
     pl := FirstL;
     While pl <> LastL^.Next Do
     Begin
           Getmem(ptnew,sizeof(ptnew^));
           If CL = 0 Then FUL := ptnew;
           PLineNewString (ptnew, pl^.zk^);

           {Martin}
           ptnew^.flag := LineFlagsDeleted (pl^.flag);

           ptnew^.Add := 0;
           If CL > 0 Then _Connect(ptlast,ptnew);
           pl := pl^.Next;
           ptlast := ptnew;
           Inc(CL);
     End;
     LUL := ptnew;

     Getmem(U,sizeof(U^));
     U^.Memory := True;
     U^.EventType := ugNoGroup;
     U^.Modified := Modified;
     U^.ICBFL := _PLine2Index(ICB.First.Line);
     U^.ICBFX := ICB.First.X;
     U^.ICBLL := _PLine2Index(ICB.Last.Line);
     U^.ICBLX := ICB.Last.X;
     U^.FFileCursor := FFileCursor;
     U^.FrameBegin := _PLine2Index(FirstL)-1;
     U^.FrameEnd := _PLine2Index(LastL)+1; {Default: Count Of Lines constant}
     U^.FirstUndoLine := FUL;
     U^.LastUndoLine := LUL;
     U^.Lines := CL;
     _CreateUndoEvent(FUndoList,U);
     Result := U^.Lines;
End;


{save the File Cursor Position And Move the specified Lines In the stack}
Function TEditor._MoveUndoLines(List:TList;FirstL,LastL:PLine):LongInt;
Var  U:PUndo;
Begin
     FlushWorkLine;
     Getmem(U,sizeof(U^));
     U^.Memory := True;
     U^.EventType := ugNoGroup;
     U^.Modified := Modified;
     U^.ICBFL := _PLine2Index(ICB.First.Line);
     U^.ICBFX := ICB.First.X;
     U^.ICBLL := _PLine2Index(ICB.Last.Line);
     U^.ICBLX := ICB.Last.X;
     U^.FFileCursor := FFileCursor;

     U^.Lines := _CountUndoLines(FirstL,LastL);  {Count Lines For Undo stack}
     If U^.Lines > 0 Then
     Begin
          U^.FrameBegin := _PLine2Index(FirstL)-1;
          U^.FirstUndoLine := FirstL;
          U^.LastUndoLine := LastL;
     End
     Else
     Begin
          U^.FrameBegin := _PLine2Index(LastL);
          U^.FirstUndoLine := Nil;
          U^.LastUndoLine := Nil;
     End;
     _CreateUndoEvent(List,U);
     Result := U^.Lines;
End;


{Create an Undo event}
Procedure TEditor._CreateUndoEvent(List:TList;U:PUndo);
Begin
     if AdditionalUndo then U^.EventType := ugGroup;
     List.Add(U);

     If MaxUndo < 0 Then Exit;  {unlimited}
     If List.Count > MaxUndo Then List.Delete(0);
End;

{Update the Frame End Of the Last Undo event}
Procedure TEditor._UpdateLastUndoEvent(List:TList;Index:LongInt);
Var  U:PUndo;
Begin
     If List.Count = 0 Then Exit;
     U := List.Last;
     If U = Nil Then Exit;
     U^.FrameEnd := Index;
End;


{Release the Memory allocated by the Lines For the Undo stack And the Item}
{$HINTS OFF}
Procedure TEditor._FreeUndoEvent(List:TObject;Item:Pointer);
Var  pl:PLine;
     ptnext:PLine;
     I:LongInt;
     lzk:Integer;
     U:PUndo;
Begin
     U := Item;
     If U = Nil Then Exit;
     If U^.Memory Then {Not only Cursor event}
     Begin
          pl := U^.FirstUndoLine;
          For I := 1 To U^.Lines Do
          Begin
               If pl = Nil Then Exit;
               ptnext := pl^.Next;
               If pl^.zk <> Nil Then
               Begin
                    lzk := Length(pl^.zk^);
                    FreeMem(pl^.zk, lzk+1);
               End;
               freemem(pl,sizeof(pl^));
               pl := ptnext;
          End;
     End;
     freemem(U,sizeof(U^));
End;
{$HINTS ON}

Procedure TEditor._SetMaxUndo(cnt:LongInt);
Begin
     MaxUndo := cnt;
     If MaxUndo < 0 Then Exit;  {unlimited}

     While FUndoList.Count > MaxUndo Do FUndoList.Delete(0);
     While FRedoList.Count > MaxUndo Do FRedoList.Delete(0);
     UpdateEditorState;
End;



{Move FActLine To FWorkLine}
Procedure TEditor._ReadWorkLine;
Var  lzk:Integer;
Begin
     WLactivated := True;
     If FActLine^.zk = Nil Then Exit;

     FillChar(FWorkLine[1], StringLength, 32);  {NoANSI}
     lzk := Length(FActLine^.zk^);
     FWorkLine := FActLine^.zk^;
     FreeMem(FActLine^.zk, lzk+1);
     FActLine^.zk := Nil;
End;


{Write back FWorkLine To FActLine}
Procedure TEditor._WriteWorkLine;
Begin
     WLactivated := False;
     If FActLine^.zk <> Nil Then Exit;
     While (Length(FWorkLine) > 0) And (FWorkLine[Length(FWorkLine)] = ' ')
        Do SetLength(FWorkLine,Length(FWorkLine)-1);
     If Length(FWorkLine) > StringLength Then SetLength(FWorkLine,StringLength);

     PLineNewString (FActLine, FWorkLine);
End;


{overwrite FWorkLine At Position X With String S}
Function TEditor._WriteString(X:Integer; S:String):Boolean;
Var  I,newend:Integer;
     lwl:Integer;
Begin
     Result := True;
     If Not WLactivated Then _ReadWorkLine;
     If Length(S) = 0 Then Exit;

     lwl := Length(FWorkLine);
     I := X - (lwl+1);
     If I > 0 Then FillChar(FWorkLine[lwl+1], I, 32);

     If X + (Length(S)-1) > StringLength Then
     Begin
          SetLength(S,StringLength-X+1);
          Result := False;
     End;

     System.Move(S[1], FWorkLine[X], Length(S)); {NoANSI}
     newend := X + (Length(S)-1);
     If Length(FWorkLine) < newend Then SetLength(FWorkLine,newend);
     Modified := True;
End;


{Insert String S In the FWorkLine At Position X}
Function TEditor._InsertString(X:Integer; S:String):Boolean;
Var  lS,I:Integer;
     lwl:Integer;
Begin
     If Not WLactivated Then _ReadWorkLine;
     Result := True;
     lS := Length(S);
     If lS = 0 Then Exit;

     lwl := Length(FWorkLine);
     If X > lwl+1 Then
     Begin
          I := X - (lwl+1);
          FillChar(FWorkLine[lwl+1], I, 32);
          SetLength(FWorkLine,X-1);
     End;
     If lS + Length(FWorkLine) > StringLength Then Result := False;
     System.Insert(S, FWorkLine, X);
     If Length(FWorkLine) > StringLength Then SetLength(FWorkLine,StringLength);
     Modified := True;
End;


{Delete CX chars In the FWorkLine At Position X}
Function TEditor._DeleteString(X,CX:Integer):Boolean;
Begin
     If Not WLactivated Then _ReadWorkLine;
     Result := True;
     If CX = 0 Then Exit;
     If X > Length(FWorkLine) Then Exit;
     Delete(FWorkLine, X, CX);
     Modified := True;
End;


{Read CX chars from Line pl At Position X; If CX Is < 0 the Until End Of Line}
Function TEditor._ReadString(pl:PLine; X,CX:Integer):String;
Var  zk:PString;
     S:String;
Begin
     Result := '';
     If pl = Nil Then Exit;
     zk := _PLine2PString(pl);

     If CX >= 0 Then
     Begin
          If X+CX-1 > Length(zk^) Then
          Begin
               FillChar(S[1], StringLength, 32);    {NoANSI}
               System.Move(zk^[1], S[1], Length(zk^));
               SetLength(S,StringLength);
               zk := @S;   {NoANSI}
          End;
     End
     Else CX := StringLength;
     Result := Copy(zk^,X,CX);
End;


{Get the String from Line Y (1..N)}
Function TEditor._Get(Y:LongInt):String;
Var  pl:PLine;
Begin
     Result := '';
     pl := _Index2PLine(Y);
     If pl = Nil Then Exit;    {indexerror}
     If pl^.zk <> Nil Then Result := pl^.zk^
     Else Result := FWorkLine;
End;


Procedure TEditor._Set(Y:LongInt;Const S:String);
Begin
     ReplaceLine(Y,S);
End;


{Find the Line With the bookmark I}
Function TEditor._FindBookMark(I:Byte):PLine;
Var  pl:PLine;
     BM,W:LongWord;
Begin
     BM := I * ciBookMark0;
     pl := FFirstLine;
     While pl <> Nil Do
     Begin
          W := pl^.flag And ciBookMarkMask;
          If W = I Then
          Begin
               Result := pl;
               Exit;
          End;
          pl := pl^.Next;
     End;
     Result := Nil;
End;


{Find Next cmTabulator; from Line pl And Position X}
Function TEditor._FindNextTab(pl:PLine; X:Integer):Integer;
Var  tabstring:String;
Begin
     FlushWorkLine;
     Result := 1;
     If FTabSize = 0 Then exit;

     tabstring := '!';
     While pl <> Nil Do
     Begin
          If Length(pl^.zk^) <> 0 Then
          Begin
               tabstring := pl^.zk^;
               pl := Nil;
          End
          Else pl := pl^.Prev;
     End;

     If (X = 1) And (tabstring[1] <> ' ') Then   {For cmEnter}
     Begin
          Result := 1;
          Exit;
     End;

     If X <= Length(tabstring) Then
     Begin
          Dec(X);
          While (tabstring[X] <> ' ') And (X <= Length(tabstring)) Do Inc(X);
          While (tabstring[X] = ' ') And (X <= Length(tabstring)) Do Inc(X);
     End
     Else X := (((X-2) Div FTabSize)+1)*FTabSize + 1;

     If X > StringLength Then X := StringLength;
     Result := X;
End;


Function QueryDBCSFirstByte(Var S:String; Pos:LongInt):Boolean;
Var  I:LongInt;
Begin
     Result := False;
     If Pos > Length(S) Then Exit;
     For I := 1 To Pos Do
     Begin
          {$IFDEF OS2}
          If IsDBCSFirstByte(S[I]) Then
          Begin
               If I = Pos Then
               Begin
                    Result := True;
                    Exit;
               End;
               Inc(I);   {onto Second Byte}
          End;
          {$ENDIF}
     End;
End;



{transform mouse coordinates into Screen Cursor coordinates}
Function TEditor.GetCursorFromMouse(pt:TPoint):TEditorPos;
Var  I,XLeft,yTop:LongInt;
     pl:PLine;
     ps:PString;
Begin
     XLeft := FBorderWidth + IndentRect.Left;
     yTop := FBorderWidth + IndentRect.Top;
     Result.X := Round( (pt.X - XLeft) / Canvas.FontWidth) + 1;
     Result.Y := (ClientArea.Top - pt.Y - yTop) Div Canvas.FontHeight + 1;

     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          pl := FTopScreenLine;
          For I := 2 To Result.Y Do
             If pl <> Nil Then pl := pl^.Next;
          If pl = Nil Then Exit;

          ps := _PLine2PString(pl);
          If QueryDBCSFirstByte(ps^,(FFileCursor.X-FScrCursor.X)+Result.X-1)
          Then Dec(Result.X);
     End;
End;


{transform Screen Cursor coordinates into mouse coordinates}
Function TEditor.GetMouseFromCursor(Pos:TEditorPos):TPoint;
Var  XLeft,yTop:LongInt;
Begin
     XLeft := FBorderWidth + IndentRect.Left;
     yTop := FBorderWidth + IndentRect.Top;
     Result.X := XLeft + ((Pos.X-1) * Canvas.FontWidth);
     Result.Y := ClientArea.Top - (Pos.Y * Canvas.FontHeight) - yTop;
End;



{Insert A New Line after pl}
Function TEditor._InsertLine(pl:PLine):PLine;
Var  plnext, plnew :PLine;
Begin
     If pl = Nil Then plnext := FFirstLine
     Else plnext := pl^.Next;
     Getmem(plnew,sizeof(plnew^));
     plnew^.zk := Nil;
     plnew^.flag := ciNormal;
     plnew^.Add := 0;
     _Connect(plnew,plnext);
     _Connect(pl,plnew);
     result := plnew;
     Inc(FCountLines);
     Modified := True;
End;


{Delete the Line pl}
Function TEditor._DeleteLine(pl:PLine):PLine;
Var  lzk:Integer;
Begin
     If (FCountLines = 1) Or (pl = Nil) Then
     Begin
          Result := Nil;
          Exit;
     End;
     Result := pl^.Prev;
     If pl^.zk <> Nil Then
     Begin
          lzk := Length(pl^.zk^);
          FreeMem(pl^.zk, lzk+1);
     End;
     _Connect(pl^.Prev,pl^.Next);
     freemem(pl,sizeof(pl^));
     Dec(FCountLines);
     Modified := True;
End;


{Copy contents Of A File into Memory}
Function TEditor._GetFileText(S:String; Var P:Pointer; Var len:LongInt):Boolean;
Var  utF:File;
     p0:^Byte;
Begin
     System.Assign(utF,S);
     {$I-}
     FileMode := fmInput;
     Reset(utF,1);
     FileMode := fmInOut;
     Result := InOutRes = 0;
     If InOutRes = 0 Then len := FileSize(utF)
     Else len := 0;
     {$I+}

     If len > 0 Then
     Begin
          Inc(len);
          GetMem(P,len);
          {$I-}
          BlockRead(utF,P^,len-1);
          {$I+}
          Result := InOutRes = 0;
          p0 := P;
          Inc(p0,len-1);
          p0^ := 0;      {terminal #0}
          ConvertFileRead (P, len); {Martin: this can hold conversion routines, like converting to Unix Returns, but is empty here}
     End;
     {$I-}
     System.Close(utF);
     {$I+}

     {Martin2}
     if (not RunInAnsi) and LoadSaveAsAnsi then ConvertToOEM(PCharArray(P),len);
     if RunInAnsi and (not LoadSaveAsAnsi) then ConvertToAnsi(PCharArray(P),len);
End;


{Copy All To A Text block With the Length len; return True If successful}
Function TEditor._GetEditorText(Var P:Pointer; Var len:LongInt):Boolean;
Var  OldICB:TICB;
     OldSelectMode:TSelectMode;
Begin
     OldICB := ICB;
     ICB.First.Line := FFirstLine;
     ICB.First.X := 1;
     ICB.Last.Line := FLastLine;
     ICB.Last.X := Length(_PLine2PString(FLastLine)^);
     Inc(ICB.Last.X);
     OldSelectMode := FSelectMode;
     FSelectMode := smNonInclusiveBlock;

     Result := _GetEditorBlock(P,len);

     ICB := OldICB;
     FSelectMode := OldSelectMode;
End;


{Copy the area To A Text block With the Length len; return True If successful}
Function TEditor.GetPartialText(p1,p2:TEditorPos;Var P:Pointer; Var len:LongInt):Boolean;
Var  OldICB:TICB;
     OldSelectMode:TSelectMode;
Begin
     Result := False;
     If p1.Y > p2.Y Then Exit;
     If p1.Y = p2.Y Then
       If p1.X >= p2.X Then Exit;
     If p1.Y < 1 Then Exit;
     If p2.Y > FCountLines Then Exit;

     OldICB := ICB;
     ICB.First.Line := _Index2PLine(p1.Y);
     ICB.First.X := 1;
     ICB.Last.Line := _Index2PLine(p2.Y);
     ICB.Last.X := Length(_PLine2PString(FLastLine)^);
     Inc(ICB.Last.X);
     OldSelectMode := FSelectMode;
     FSelectMode := smNonInclusiveBlock;

     Result := _GetEditorBlock(P,len);

     ICB := OldICB;
     FSelectMode := OldSelectMode;
End;


{Copy ICB To A Text block With the Length len; return True If successful}
Function TEditor._GetEditorBlock(Var P:Pointer; Var len:LongInt):Boolean;
Var  pl:PLine;
     Ptr:Pointer;
     Str:String;
     zk:PString;
     lzk:Integer;
     CRLF:String;
     area:TICB;
Begin
     Result := False;
     _ICBExtCorrectICB2;      {reorder firstx lastx If extselection}
     len := -1;
     area := ICB;
     If (area.First.Line = Nil) Or (area.Last.Line = Nil) Then Exit;

     If area.First.Line = area.Last.Line Then
     Begin
          len := area.Last.X - area.First.X;
          If len > 0 Then
          Begin
               Inc(len);         {terminating #0}
               GetMem(P,len);
               Str := _ReadString(area.First.Line,area.First.X,len-1) + #0;
               System.Move(Str[1], P^, len);    {NoANSI}
               Result := True;
          End;
     End
     Else
     Begin
          If FSelectMode <> smColumnBlock Then
          Begin
               pl := area.First.Line;
               lzk := Length(_PLine2PString(pl)^);
               {correct If To LONG}
               If area.First.X > lzk Then area.First.X := lzk+1;
               len := lzk - area.First.X+1+2; {First Line}
               pl := pl^.Next;
               While pl <> area.Last.Line Do
               Begin
                    lzk := Length(_PLine2PString(pl)^);
                    Inc(len, lzk +2);
                    pl := pl^.Next;
                    If pl = Nil Then Exit;
               End;
               Inc(len, area.Last.X);         {Last Line + terminating #0}
          End
          Else  {Extended Selection}
          Begin
               pl := area.First.Line;
               lzk := area.Last.X - area.First.X;
               len := lzk +2;        {First Line}
               pl := pl^.Next;
               While pl <> area.Last.Line Do
               Begin
                    Inc(len, lzk +2);
                    pl := pl^.Next;
                    If pl = Nil Then Exit;
               End;
               Inc(len, lzk +1);             {Last Line + terminating #0}
          End;

          GetMem(P,len);

          CRLF := #13#10;
          pl := area.First.Line;
          Ptr := P;
          {First area Line}
          If FSelectMode <> smColumnBlock
          Then Str := _ReadString(area.First.Line,area.First.X,-1)
          Else Str := _ReadString(area.First.Line,area.First.X,lzk);
          System.Move(Str[1], Ptr^, Length(Str));   {NoANSI}
          Inc(Ptr, Length(Str));
          System.Move(CRLF[1], Ptr^, 2);            {NoANSI}
          Inc(Ptr, 2);
          pl := pl^.Next;
          While pl <> area.Last.Line Do
          Begin
               If FSelectMode <> smColumnBlock Then
               Begin
                    zk := _PLine2PString(pl);
                    System.Move(zk^[1], Ptr^, Length(zk^));    {NoANSI}
                    Inc(Ptr, Length(zk^));
               End
               Else
               Begin
                    Str := _ReadString(pl,area.First.X,lzk);
                    System.Move(Str[1], Ptr^, lzk);            {NoANSI}
                    Inc(Ptr, lzk);
               End;
               System.Move(CRLF[1], Ptr^, 2);                  {NoANSI}
               Inc(Ptr, 2);
               pl := pl^.Next;
          End;
          {Last area Line}
          If FSelectMode <> smColumnBlock
          Then Str := _ReadString(area.Last.Line,1,area.Last.X-1) + #0
          Else Str := _ReadString(area.Last.Line,area.First.X,lzk) + #0;
          System.Move(Str[1], Ptr^, Length(Str));              {NoANSI}
          Result := True;
     End;
End;

{Martin}
procedure tEditor._InsertColumnText (P:Pointer; len : longint);
  {like _InsertText, but especially for Column text; this function has to be executed
   instead of _InsertText, if SelectedMode is smColumnBlock.}
  var
    Pl, FirstPl, LastPl : PLine;
    bufP : pChar; bufI : longint; I, icbwidth : byte;
    icbSt, St : string;
    Curpos : tEditorPos;
    Ch : char;

  procedure InsertColumnLine;
    begin
      LastPl := Pl;
      LoadStringOfPLine (Pl, St);
      {does the Line width reach the block area? If not, add spaces}
      for I := length(St) to Curpos.X-1 do begin
        inc (St[0]); St[ord(St[0])] := ' ';
      end;
      icbwidth := length(icbSt);
      system.Insert (icbSt, St, Curpos.X);
      ReplacePLine (Pl, St);
    end;
  begin
    {place column Block to current Cursorpos}
    Curpos := Cursorpos;
    //Messagebox (tostr(Curpos.X), mtInformation, [mbOK]);
    BeginUpdate;
    Pl := ActLine; FirstPl := ActLine; LastPl := ActLine;
    icbwidth := 0;
    icbSt := ''; bufI := 1; bufP := P;
    while bufI <= len do begin
      Ch := bufP^;
      if Ch = ^M then begin
        InsertColumnLine; inc (bufI); inc (bufP);{for ^J}
        if Pl = LastLine then begin
          InsertLine (CountLines+1, '');
          Pl := LastLine;
        end
        else
          Pl := Pl^.next;
        icbSt := '';
      end
      else begin
        inc (icbSt[0]); icbSt[ord(icbSt[0])] := Ch;
      end;
      inc (bufI); inc (bufP);
    end;
    if icbSt <> '' then InsertColumnLine;
    _ICBClearMark;
    ICB.First.Line := FirstPl; ICB.First.X := Curpos.X;
    ICB.Last.Line := LastPl; ICB.Last.X := Curpos.X + icbwidth;
    icbvisible := true;
    _ICBSetMark;
    EndUpdate;
  end;

{Insert the Text block At the current Position And Change the ICB If neccesary}
Function TEditor._InsertText(P:Pointer; len:LongInt; marknew:Boolean):TLineX;
Var  laststr,NewStr:String;
     Tabs,StrL:LongWord;
     NewLine:Boolean;
     OldActLine:PLine;
Begin
     FillChar(Result, SizeOf(Result), 0);

     If (len <= 0) Or (P = Nil) Then Exit;

     If FSelectMode = smColumnBlock Then marknew := False;
     OldActLine := FActLine;
     If marknew Then
     Begin
          _ICBClearMark;
          ICB.First.Line := FActLine;
          ICB.First.X := FFileCursor.X;
     End;
     If Not WLactivated Then _ReadWorkLine;
     If FFileCursor.X > Length(FWorkLine) Then laststr := ''
     Else laststr := Copy(FWorkLine,FFileCursor.X,255);
     SetLength(FWorkLine,FFileCursor.X-1);

     Tabs := FTabSize;
     StrL := StringLength;
     While len > 0 Do
     Begin
         Asm
             CLD
             MOV NewLine,0
             LEA EDI,NewStr
             MOV ESI,p
             INC EDI
             XOR ECX,ECX
!ib1:
             CMPD len,0
             JE !ib9
             CMP ECX,StrL
             JB !ib10
             CMPB [ESI+0],13
             JE !ib10
             CMPB [ESI+0],10
             JE !ib10
             JMP !ib6
!ib10:
             LODSB
             DECD len
             CMP AL,13
             JE !ib3
             CMP AL,10
             JE !ib4
             CMP AL,9
             JE !ib2
             CMP AL,21 {Martin: Paragraph-Zeichen #21 ist auch ein Zeichen}
             JE !ib5
             CMP AL,32
             JAE !ib5
             MOV AL,32
             JMP !ib5
!ib2:        {#9}
             MOV EBX,ECX
             MOV EDX,Tabs
             // Insert spaces Until To the Next tab Mark
!ib8:
             CMP EDX,EBX
             JA !ib7
             ADD EDX,Tabs
             JMP !ib8
!ib7:
             SUB EDX,EBX
             // EDX = Count Of spaces
             ADD EBX,EDX
             CMP EBX,StrL
             JA !ib6
             MOV ECX,EDX
             MOV AL,32
             REP
             STOSB
             MOV ECX,EBX
             JMP !ib1
!ib3:        {#13}
             CMPB [ESI],10
             JNE !ib6
             LODSB
             DECD len
             JMP !ib6
!ib4:        {#10}
             CMPB [ESI],13
             JNE !ib6
             LODSB
             DECD len
             JMP !ib6
!ib5:        {>#31}
             STOSB
             Inc ECX
             CMP ECX,StrL
             JBE !ib1
!ib6:
             MOV NewLine,1
!ib9:
             MOV P,ESI
             MOV NewStr,CL
          End;

          FWorkLine := FWorkLine + NewStr;
          If Length(FWorkLine) > StringLength Then SetLength(FWorkLine,StringLength);

          PLineNewString (FActLine, FWorkLine);

          WLactivated := False;
          If NewLine Then
          Begin
               _InsertLine(FActLine);
               FActLine := FActLine^.Next;
               FWorkLine := '';
          End;
     End;

     _ReadWorkLine;

     // Set Result To the End Of the inserted block
     Result.Line := FActLine;
     Result.X := Length(FWorkLine);
     Inc(Result.X);

     If marknew Then ICB.Last := Result;

     FWorkLine := FWorkLine + laststr;
     _WriteWorkLine;

     _ICBCheckX;
     _ICBSetMark;
     ICBVisible := True;
     SetSliderValues;
     SetLineColorFlag(OldActLine,FActLine);
     FActLine := OldActLine;
     Modified := True;
End;



{determine whether the viewarea Change its horizontal Position}
Function TEditor._HorizMove:Boolean;
Begin
     Result := ScrOffsX <> FFileCursor.X-FScrCursor.X+1;
     ScrOffsX := FFileCursor.X-FScrCursor.X+1;
End;


{Change the current File Cursor Position}
Function TEditor._GotoPosition(P:TEditorPos):Boolean;
Var  deltaY,deltaX,I:LongInt;
     pl:PLine;
     ps:PString;
Begin
     Result := False;
     If (P.Y < 1) Or (P.Y > FCountLines) Or
        (P.X < 1) Or (P.X > StringLength) Then Exit;
     FlushWorkLine;

     deltaX := P.X - FFileCursor.X;
     FFileCursor.X := P.X;
     If (FScrCursor.X + deltaX < 1) Or (FScrCursor.X + deltaX > FWinSize.X) Then
     Begin
          FScrCursor.X := FWinSize.X;
          If FScrCursor.X <= 0 Then FScrCursor.X := 1;
          If P.X < FScrCursor.X Then FScrCursor.X := P.X;
          Result := True;
     End
     Else FScrCursor.X := FScrCursor.X + deltaX;

     deltaY := P.Y - FFileCursor.Y;
     FFileCursor.Y := P.Y;
     If (FScrCursor.Y + deltaY < 1) Or (FScrCursor.Y + deltaY > FWinSize.Y) Then
     Begin
          FScrCursor.Y := FWinSize.Y Div 2;
          If FScrCursor.Y <= 0 Then FScrCursor.Y := 1;
          If P.Y < FScrCursor.Y Then FScrCursor.Y := P.Y;
          Result := True;
     End
     Else FScrCursor.Y := FScrCursor.Y + deltaY;

     pl := _Index2PLine(P.Y);
     FActLine := pl;
     For I := FScrCursor.Y DownTo 2 Do
        If pl <> Nil Then pl := pl^.Prev;
     If pl = Nil Then pl := FActLine;
     FTopScreenLine := pl;


     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X-1) Then
          Begin
               KeyRepeat := 1;
               _CursorLeft;
          End;
     End;

     {Martin1105} SetSliderValues;
End;


{basic Cursor Movement}
Function TEditor._CursorDown:Boolean;
Var  ToScroll:Integer;
     maxrep,REP,T:Integer;
     ps:PString;
Begin
     Result := False;
     If FFileCursor.Y = FCountLines Then Exit;
     FlushWorkLine;

     REP := KeyRepeat;
     maxrep := (FWinSize.Y Div 2) + 1;
     If REP > maxrep Then REP := maxrep;
     If FFileCursor.Y + REP > FCountLines Then REP := FCountLines - FFileCursor.Y;
     If REP = 0 Then Exit;

     Inc(FFileCursor.Y,REP);
     For T := 1 To REP Do FActLine := FActLine^.Next;
     If FScrCursor.Y + REP > FWinSize.Y Then {ScrollDown}
     Begin
          ToScroll := (FScrCursor.Y+REP) - FWinSize.Y;
          FScrCursor.Y := FWinSize.Y;
          For T := 1 To ToScroll Do FTopScreenLine := FTopScreenLine^.Next;
          Result := True;
     End
     Else Inc(FScrCursor.Y,REP);


     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X-1) Then
          Begin
               KeyRepeat := 1;
               _CursorLeft;
          End;
     End;
End;


Function TEditor._CursorUp:Boolean;
Var  ToScroll:Integer;
     maxrep,REP,T:Integer;
     ps:PString;
Begin
     Result := False;
     If FFileCursor.Y = 1 Then Exit;
     FlushWorkLine;

     REP := KeyRepeat;
     maxrep := (FWinSize.Y Div 2) + 1;
     If REP > maxrep Then REP := maxrep;
     If FFileCursor.Y <= REP Then REP := FFileCursor.Y - 1;
     If REP = 0 Then Exit;

     Dec(FFileCursor.Y,REP);
     For T := 1 To REP Do FActLine := FActLine^.Prev;
     If REP >= FScrCursor.Y Then {ScrollUp}
     Begin
          ToScroll := REP - FScrCursor.Y + 1;
          FScrCursor.Y := 1;
          For T := 1 To ToScroll Do FTopScreenLine := FTopScreenLine^.Prev;
          Result := True;
     End
     Else Dec(FScrCursor.Y,REP);


     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X-1) Then
          Begin
               KeyRepeat := 1;
               _CursorLeft;
          End;
     End;
End;


Function TEditor._CursorRight:Boolean;
Var  maxrep,REP:Integer;
     ps:PString;
Begin
     Result := False;
     If FFileCursor.X >= StringLength Then Exit;

     REP := KeyRepeat;
     maxrep := (FWinSize.X Div 2) + 1;
     If REP > maxrep Then REP := maxrep;
     If FFileCursor.X + REP > StringLength Then REP := StringLength - FFileCursor.X;

     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X+REP-1) Then Inc(REP);
     End;

     Inc(FFileCursor.X,REP);
     If FScrCursor.X + REP > FWinSize.X Then
     Begin
          FScrCursor.X := FWinSize.X;
          Result := True;
     End
     Else Inc(FScrCursor.X,REP);
End;


Function TEditor._CursorLeft:Boolean;
Var  maxrep,REP:Integer;
     ps:PString;
Begin
     Result := False;
     If FFileCursor.X <= 1 Then Exit;

     REP := KeyRepeat;

     maxrep := (FWinSize.X Div 2) + 1;
     If REP > maxrep Then REP := maxrep;
     If FFileCursor.X <= REP Then REP := FFileCursor.X - 1;

     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X-REP-1) Then Inc(REP);
     End;

     Dec(FFileCursor.X,REP);
     If FScrCursor.X - REP < 1 Then
     Begin
          FScrCursor.X := 1;
          Result := True;
     End
     Else Dec(FScrCursor.X,REP);
End;


Function TEditor._CursorHome:Boolean;
Begin
     Result := False;
     If FFileCursor.X = 1 Then Exit;

     _HorizMove;
     FFileCursor.X := 1;
     FScrCursor.X := 1;
     Result := _HorizMove;
End;


Function TEditor._CursorEnd:Boolean;
Var  LastChar:Integer;
Begin
     Result := False;
     FlushWorkLine;
     LastChar := Length(_PLine2PString(FActLine)^);
     Inc(LastChar);
     If LastChar > StringLength Then LastChar := StringLength;
     If FFileCursor.X = LastChar Then Exit;

     _HorizMove;
     FScrCursor.X := LastChar - (FFileCursor.X - FScrCursor.X);
     FFileCursor.X := LastChar;
     If FScrCursor.X < 1 Then FScrCursor.X := LastChar;
     If FScrCursor.X > FWinSize.X Then FScrCursor.X := FWinSize.X;
     Result := _HorizMove;
End;


Function TEditor._CursorPageDown:Boolean;
Var  I:Integer;
     ps, P:PString;
     {Martin}Pl, LastTextLine : PLine;
Begin
     Result := False;

     {Martin 0206}
     if CountLines <= 1 then exit;

     FlushWorkLine;

     {Martin}
     LastTextLine := nil;
     If Cursorpos.Y >= FCountLines-FWinSize.Y Then begin
       Pl := LastLine;
       repeat
         P := PStrings[Pl];
         if (P <> nil) and (length(P^) > 0) then begin
           LastTextLine := Pl; break;
         end;
         if Pl = FirstLine then break;
         Pl := Pl^.prev;
         if Pl = nil then break;
       until false;
     end;

     For I := 1 To FWinSize.Y-1 Do
     Begin
          //If FActLine^.Next <> Nil Then Begin
               if TopScreenLine = LastTextLine then break;
               {SrollDown}
               if (FactLine^.Next <> nil) and (FactLine <> LastLine) then FActLine := FActLine^.Next;
               {Martin1105}if FTopScreenLine <> nil then
                 FTopScreenLine := FTopScreenLine^.Next;
               Inc(FFileCursor.Y);
          //End;
     End;

     if LastTextLine <> nil then begin
       if Cursorpos.Y > CountLines then begin
         Cursorpos := Editorpos (CountLines, Cursorpos.X);
       end;
     end;

     Result := True;


     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X-1) Then
          Begin
               KeyRepeat := 1;
               _CursorLeft;
          End;
     End;

     {Martin1105} SetSliderValues;
End;

Function TEditor._CursorPageUp:Boolean;
Var  I:Integer;
     ps:PString;
Begin
     Result := False;
     If FFileCursor.Y <= 1 Then Exit;

     FlushWorkLine;
     For I := 1 To FWinSize.Y-1 Do
     Begin
          If FTopScreenLine^.Prev <> Nil Then
          Begin
               {ScrollUp}
               FActLine := FActLine^.Prev;
               FTopScreenLine := FTopScreenLine^.Prev;
               Dec(FFileCursor.Y);
          End
          Else
          Begin
               If FActLine^.Prev <> Nil Then
               Begin
                    {JumpUp}
                    FActLine := FActLine^.Prev;
                    Dec(FFileCursor.Y);
                    Dec(FScrCursor.Y);
               End;
          End;
     End;
     Result := True;


     If Application.DBCSSystem Then
     Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X-1) Then
          Begin
               KeyRepeat := 1;
               _CursorLeft;
          End;
     End;

     {Martin1105} SetSliderValues;
End;


Function TEditor._CursorRollUp:Boolean;
Var  ps:PString;
Begin
     Result := False;
     If FTopScreenLine^.Prev = Nil Then Exit;

     FlushWorkLine;
     FTopScreenLine := FTopScreenLine^.Prev;
     If FScrCursor.Y >= FWinSize.Y Then
     Begin
          FActLine := FActLine^.Prev;
          Dec(FFileCursor.Y);

          If Application.DBCSSystem Then
          Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
               ps := _PLine2PString(FActLine);
               If QueryDBCSFirstByte(ps^, FFileCursor.X-1) Then
               Begin
                    KeyRepeat := 1;
                    _CursorLeft;
               End;
          End;
     End
     Else Inc(FScrCursor.Y);
     Result := True;
     {Martin1105} SetSliderValues;
End;


Function TEditor._CursorRollDown:Boolean;
Var  ps:PString;
Begin
     Result := False;
     {Martin}
     If FTopScreenLine^.next = nil then exit;

     FlushWorkLine;
     FTopScreenLine := FTopScreenLine^.Next;
     If FScrCursor.Y <= 1 Then
     Begin
          FActLine := FActLine^.Next;
          Inc(FFileCursor.Y);

          If Application.DBCSSystem Then
          Begin {Make sure, that the Cursor cannot occur within A dbcs Char}
               ps := _PLine2PString(FActLine);
               If QueryDBCSFirstByte(ps^, FFileCursor.X-1) Then
               Begin
                    KeyRepeat := 1;
                    _CursorLeft;
               End;
          End;
     End
     Else Dec(FScrCursor.Y);
     Result := True;
     {Martin1105} SetSliderValues;
End;


function tEditor.StepOverChar (Ch : char) : boolean; {Martin0207}
  begin
    if FEditOpt * [eoJumpWordSpace] <> [] then
      result := Ch <> ' '
    else
      result := NormalChar[RunInAnsi, Ch];
  end;

Function TEditor._CursorWordRight:Boolean;
Var  pl:PLine;
     I,dFCY:LongInt;
     FCX:Integer;
     cc:Integer;
Begin
     Result := False;

     _HorizMove;
     FlushWorkLine;
     If (FFileCursor.X > Length(FActLine^.zk^)) Or
        (FFileCursor.X = StringLength) Then
     Begin
          pl := FActLine^.Next;
          If pl = Nil Then
          Begin
               Result := _CursorEnd;
               Exit;
          End;
          FFileCursor.X := 1;
          FScrCursor.X := 1;
          dFCY := 0;
          cc := 0;
          While (pl <> Nil) And (cc = 0) Do
          Begin
               Inc(dFCY);
               If Length(pl^.zk^) = 0 Then pl := pl^.Next
               Else cc := 1; {Line With <> '' found}
          End;

          For I := 1 To dFCY Do
          Begin
               FActLine := FActLine^.Next;
               Inc(FFileCursor.Y);
               If FScrCursor.Y = FWinSize.Y Then
               Begin
                    FTopScreenLine := FTopScreenLine^.Next;
                    Result := True;
               End
               Else Inc(FScrCursor.Y);
          End;
     End
     Else cc := 2;  {Next Word In the same Line}

     FCX := 0;
     If ((cc=1) And Not (StepOverChar (FActLine^.zk^[1]))) Or (cc = 2) Then
     Begin
          While (StepOverChar (FActLine^.zk^[FFileCursor.X+FCX])) And
                (FFileCursor.X+FCX <= Length(FActLine^.zk^)) Do Inc(FCX);
          While (Not (StepOverChar (FActLine^.zk^[FFileCursor.X+FCX]))) And
                (FFileCursor.X+FCX <= Length(FActLine^.zk^)) Do Inc(FCX);
     End;

     FFileCursor.X := FFileCursor.X+FCX;
     If FFileCursor.X > StringLength Then FFileCursor.X := StringLength;
     FScrCursor.X := FScrCursor.X+FCX;
     If FScrCursor.X > FWinSize.X Then FScrCursor.X := FWinSize.X;

     Result := Result Or _HorizMove;
End;


Function TEditor._CursorWordLeft:Boolean;
Var  pl:PLine;
     I,dFCY:LongInt;
     FCX:Integer;
     cc:Integer;
     lzk:Integer;
Begin
     Result := False;

     _HorizMove;
     FlushWorkLine;
     lzk := Length(FActLine^.zk^);
     If FFileCursor.X > lzk+1 Then _CursorEnd;
     If FFileCursor.X > 1 Then
     Begin
          cc := 0;
          FCX := 1;
          If Not (StepOverChar (FActLine^.zk^[FFileCursor.X-FCX])) Then
            While (Not (StepOverChar (FActLine^.zk^[FFileCursor.X-FCX]))) And
                  (FFileCursor.X-FCX  > 0) Do Inc(FCX);
          If FFileCursor.X-FCX = 0 Then cc := 1;

          While (StepOverChar (FActLine^.zk^[FFileCursor.X-FCX])) And
                (FFileCursor.X-FCX > 0) Do Inc(FCX);

          FFileCursor.X := FFileCursor.X-FCX+1;
          If FCX > FScrCursor.X Then FScrCursor.X := 1
          Else FScrCursor.X := FScrCursor.X-FCX+1;
     End
     Else cc := 1; {minimal 1 Line up}

     If cc = 1 Then
     Begin
          pl := FActLine^.Prev;
          If pl = Nil Then
          Begin
               Result := _CursorHome;
               Exit;
          End;
          dFCY := 0;
          While (pl <> Nil) Do
          Begin
               Inc(dFCY);
               If Length(pl^.zk^) = 0 Then pl := pl^.Prev
               Else pl := Nil; {Line With <> '' found}
          End;

          For I := 1 To dFCY Do
          Begin
               FActLine := FActLine^.Prev;
               Dec(FFileCursor.Y);
               If FScrCursor.Y = 1 Then
               Begin
                    FTopScreenLine := FTopScreenLine^.Prev;
                    Result := True;
               End
               Else Dec(FScrCursor.Y);
          End;
          Result := _CursorEnd Or Result;
     End;
     Result := Result Or _HorizMove;
End;



{determine whether the internal Clipboard Is Empty Or Not}
Function TEditor._ICBExist:Boolean;
Begin
     Result := False;
     If Not ICBVisible Then Exit;
     If (ICB.First.Line = Nil) Or (ICB.Last.Line = Nil) Then Exit;
     If (ICB.First.Line = ICB.Last.Line) And (ICB.First.X = ICB.Last.X) Then Exit;
     If FSelectMode = smColumnBlock Then
       If ICB.First.X = ICB.Last.X Then Exit;
     Result := True;
End;


{determine whether the ICB Is persistent}
Function TEditor._ICBPersistent:Boolean;
Begin
     Result := eoPersistentBlocks In FEditOpt;
End;

{Martin0106}
Function TEditor.MarkInsertedText :Boolean;
Begin
     Result := _ICBPersistent;{WDsibyl default}
End;


{determine whether the ICB MUST be overwritten Or Not}
Function TEditor._ICBOverwrite:Boolean;
Begin
     Result := eoOverwriteBlock In FEditOpt;
End;


{Clear the Mark Of the Lines Of the current ICB And Set ICB To Nil}
Function TEditor._ICBClearICB:Boolean;
Begin
     Result := _ICBClearMark;
     ICB.First.Line := Nil;
     ICB.Last.Line := Nil;
End;


{Clear the Mark Of the Lines Of the current ICB}
Function TEditor._ICBClearMark:Boolean;
Var  pl:PLine;
Begin
     If (ICB.First.Line <> Nil) And (ICB.Last.Line <> Nil) Then
     Begin
          pl := ICB.First.Line;
          While pl <> ICB.Last.Line Do
          Begin
               pl^.flag := pl^.flag And Not ciSelected;
               pl := pl^.Next;
          End;
          pl^.flag := pl^.flag And Not ciSelected;
          Result := True;
     End
     Else Result := False;
End;


{Set the Mark Of the Lines Of the current ICB}
Function TEditor._ICBSetMark:Boolean;
Var  pl:PLine;
Begin
     If (ICB.First.Line <> Nil) And (ICB.Last.Line <> Nil) Then
     Begin
          pl := ICB.First.Line;
          While pl <> ICB.Last.Line Do
          Begin
               pl^.flag := pl^.flag Or ciSelected;
               pl := pl^.Next;
          End;
          pl^.flag := pl^.flag Or ciSelected;
          Result := True;
     End
     Else Result := False;
End;


{Delete the ICB block, including Undo}
Function TEditor._ICBDeleteICB:Boolean;
Var  FrameFirst:PLine;
     FrameLast:PLine;
     firststring:String;
     laststring:String;
     CL:LongInt;
     P:TEditorPos;
     {Martin}LastHR, LastBR : boolean;
Begin
     Result := False;
     If Not _ICBExist Then Exit;
     FlushWorkLine;

     P.Y := _PLine2Index(ICB.First.Line);
     P.X := ICB.First.X;
     _GotoPosition(P);

     If FSelectMode <> smColumnBlock Then
     Begin
          {Martin}LastHR := GetPHardReturn (ICB.Last.Line);
          {Martin0705}LastBR := GetPBreakReturn (ICB.Last.Line);
          firststring := _ReadString(ICB.First.Line,1,ICB.First.X-1);
          laststring := _ReadString(ICB.Last.Line,ICB.Last.X,-1);

          FrameFirst := ICB.First.Line^.Prev;
          FrameLast := ICB.Last.Line^.Next;
          (*Undo*)
          CL := _MoveUndoLines(FUndoList,ICB.First.Line,ICB.Last.Line);
          (*Undo*)
          _Connect(FrameFirst,FrameLast);
          Dec(FCountLines,CL);
          Modified := True;

          FActLine := _InsertLine(FrameFirst);
          {Martin}SetPHardReturn (FActLine, LastHR);
          {Martin0705}SetPBreakReturn (FActLine, LastBR);
          If FScrCursor.Y = 1 Then FTopScreenLine := FActLine;
          FWorkLine := firststring + laststring;
          _WriteWorkLine;

          ICB.First.Line := FActLine;
          ICB.First.X := FFileCursor.X;
          ICB.Last := ICB.First;

          _ICBSetMark;
          ICBVisible := True;
          SetSliderValues;
          If FrameFirst <> Nil Then SetLineColorFlag(FrameFirst,FActLine)
          Else UpdateLineColorFlag(FActLine);

          (*Undo*)
          _UpdateLastUndoEvent(FUndoList,_PLine2Index(FrameLast));
          (*Undo*)
     End
     Else {Extended Selection}
     Begin
          (*Undo*)
          _CopyUndoLines(ICB.First.Line,ICB.Last.Line);
          (*Undo*)
          _ICBClearMark;
          FActLine := ICB.First.Line;
          While FActLine <> ICB.Last.Line^.Next Do
          Begin
               If Length(FActLine^.zk^) >= ICB.First.X Then
               Begin
                    _ReadWorkLine;
                    _DeleteString(ICB.First.X, ICB.Last.X - ICB.First.X);
                    _WriteWorkLine;
               End;
               FActLine := FActLine^.Next;
          End;
          FActLine := ICB.First.Line;

          ICB.Last := ICB.First;
          _ICBSetMark;
          ICBVisible := True;
          SetLineColorFlag(ICB.First.Line,ICB.Last.Line);
     End;
     (*Undo*)
     LastUndoGroup := ugNoGroup;
     (*Undo*)
     Result := True;
End;


{Cut the ICB.X values At the End Of Lines}
Procedure TEditor._ICBCheckX;
Var  zk:PString;
     lzk:Integer;
Begin
     If FSelectMode = smColumnBlock Then Exit;

     If ICB.First.Line <> Nil Then
     Begin
          zk := _PLine2PString(ICB.First.Line);
          lzk := Length(zk^);
          If Length(zk^) < ICB.First.X Then ICB.First.X := lzk+1;
          If StringLength < ICB.First.X Then ICB.First.X := StringLength;
     End;

     If ICB.Last.Line <> Nil Then
     Begin
          zk := _PLine2PString(ICB.Last.Line);
          lzk := Length(zk^);
          If Length(zk^) < ICB.Last.X Then ICB.Last.X := lzk+1;
          If StringLength < ICB.Last.X Then ICB.Last.X := StringLength;
     End;
End;


{Set the New Selection Position And Mark the Lines If neccesary}
Procedure TEditor._ICBSetBegin(pl:PLine; X:Integer);
Var  pl1:PLine;
Begin
     If ICB.Last.Line <> Nil Then
     Begin
          _ICBClearMark;

          pl1 := ICB.Last.Line;
          While (pl1 <> Nil) And (pl <> pl1) Do pl1 := pl1^.Prev;
          If (pl = ICB.Last.Line) And (X > ICB.Last.X) Then pl1 := Nil;

          If pl1 = Nil Then ICB.Last.Line := Nil;
     End;

     {Set the Begin Mark}
     ICB.First.Line := pl;
     ICB.First.X := X;
     _ICBCheckX;
     _ICBSetMark;
     ICBVisible := True;
     _ICBExtCorrectICB2;      {reorder firstx lastx If extselection}
End;


{Set the New Selection Position And Mark the Lines If neccesary}
Procedure TEditor._ICBSetEnd(pl:PLine; X:Integer);
Var  pl1:PLine;
Begin
     If ICB.First.Line <> Nil Then
     Begin
          _ICBClearMark;

          pl1 := ICB.First.Line;
          While (pl1 <> Nil) And (pl <> pl1) Do pl1 := pl1^.Next;
          If (pl = ICB.First.Line) And (X < ICB.First.X) Then pl1 := Nil;

          If pl1 = Nil Then ICB.First.Line := Nil;
     End;

     {Set the End Mark}
     ICB.Last.Line := pl;
     ICB.Last.X := X;
     _ICBCheckX;
     _ICBSetMark;
     ICBVisible := True;
     _ICBExtCorrectICB2;      {reorder firstx lastx If extselection}
End;


{calculate Code Of Current Position To ICB}
Function TEditor._ICBPos(pl:PLine; X:Integer):TICBPosition;
Begin
     Result := [];
     If pl = Nil Then Exit;

     If pl = ICB.First.Line Then
     Begin
          If X < ICB.First.X Then Result := Result + [ipBeforeICBFirst]
          Else Result := Result + [ipAfterICBFirst];
     End;

     If pl = ICB.Last.Line Then
     Begin
          If X < ICB.Last.X Then Result := Result + [ipBeforeICBLast]
          Else Result := Result + [ipAfterICBLast];
     End;

     If Result = [] Then
       If pl^.flag And ciSelected <> 0 Then Result := [ipWithinICB];
End;


{Martin0705   Is Editorpos within the block area?  _ICBpos has another meaning! }
function tEditor.EditorposInICB (Editorpos : tEditorpos; SurroundingArea{be more tolerant} : boolean) : boolean;
  function HasBlockAtPosition (X, Y : longint; Pl : PLine) : boolean;
    begin
      if (Pl = ICB.First.Line) and (Pl = ICB.Last.Line) then
        result := (X >= ICB.First.X) and (X <= ICB.Last.X)
      else if Pl = ICB.First.Line then
        result := X >= ICB.First.X
      else if Pl = ICB.Last.Line then
        result := X <= ICB.Last.X
      else
        result := (Y > Indices[ICB.First.Line]) and (Y < Indices[ICB.Last.Line]);
    end;
  var
    Pl : PLine;
  begin
    result := false;
    if Selected then begin
      Pl := PLines[Editorpos.Y];
      if Pl = nil then exit;
      if FSelectMode = smColumnBlock then begin
        result := (Editorpos.X >= ICB.First.X) and (Editorpos.X <= ICB.Last.X) and
                  (Editorpos.Y >= Indices[ICB.First.Line]) and (Editorpos.Y <= Indices[ICB.Last.Line]);
      end
      else begin
        result := HasBlockAtPosition (Editorpos.X, Editorpos.Y, Pl);
        if SurroundingArea then begin
          result := result or HasBlockAtPosition (Editorpos.X, Editorpos.Y+1, Pl^.next);
          result := result or HasBlockAtPosition (Editorpos.X, Editorpos.Y-1, Pl^.prev);
        end
      end;
    end;
  end;


{transform the current Position To the ICB Position}
Function TEditor._ICBActPos:TLineX;
Var  len:Integer;
     zk:PString;
Begin
     If FSelectMode <> smColumnBlock Then
     Begin
          zk := _PLine2PString(FActLine);
          len := Length(zk^);
          While (len > 0) And (zk^[len] = ' ') Do Dec(len);
          If FFileCursor.X > len Then Result.X := len+1
          Else Result.X := FFileCursor.X;
     End
     Else Result.X := FFileCursor.X;
     If Result.X > StringLength Then Result.X := StringLength;
     Result.Line := FActLine;
End;


{Set the New ICB Position To the current Position And Clear the ICB Mark}
Function TEditor._ICBExtSetICB:Boolean;
Var  actLineX:TLineX;
Begin
     Result := False;

     actLineX := _ICBActPos;
     _ICBClearMark;
     If Not ICBVisible Then      {force To Create New ICB}
     Begin
          ICB.First.Line := Nil;
          ICBVisible := True;
     End;

     If (ICB.First.Line = Nil) Or (ICB.Last.Line = Nil) Then
     Begin
          ICB.First := actLineX;
          ICB.Last := actLineX;
          Exit;
     End;

     If (ICB.First = actLineX) Or (ICB.Last = actLineX) Then Exit;

     If FSelectMode = smColumnBlock Then
     Begin
          If ICB.First.Line = actLineX.Line Then
            If ICB.Last.X = actLineX.X Then
          Begin
               ICB.Last.X := ICB.First.X;
               ICB.First.X := actLineX.X;
               Result := True;
               Exit;
          End;

          If ICB.Last.Line = actLineX.Line Then
            If ICB.First.X = actLineX.X Then
          Begin
               ICB.First.X := ICB.Last.X;
               ICB.Last.X := actLineX.X;
               Result := True;
               Exit;
          End;
     End;

     ICB.First := actLineX;
     ICB.Last := actLineX;
     Result := True;
End;


{reorder the Begin And the End Of the ICB If neccessary}
Function TEditor._ICBExtCorrectICB:Boolean;
Var  pl:PLine;
     LineX:TLineX;
Begin
     Result := False;
     pl := ICB.First.Line;
     If (ICB.First.Line = ICB.Last.Line) And (ICB.First.X > ICB.Last.X)
     Then pl := Nil;
     While (pl <> ICB.Last.Line) And (pl <> Nil) Do pl := pl^.Next;

     If pl = Nil Then {Exchange First & Last}
     Begin
          LineX := ICB.First;
          ICB.First := ICB.Last;
          ICB.Last := LineX;
          Result := True;
     End;
End;


{reorder the Left And Right Of the ICB If neccessary}
Function TEditor._ICBExtCorrectICB2:Boolean;
Var  X:Integer;
Begin
     Result := False;
     If FSelectMode = smColumnBlock Then
       If ICB.First.X > ICB.Last.X Then {Exchange Left & Right}
     Begin
          X := ICB.First.X;
          ICB.First.X := ICB.Last.X;
          ICB.Last.X := X;
          Result := True;
     End;
End;


Function TEditor._ICBTestIEW(Var y1,y2:Integer):Boolean;
Var  _y1,_y2:LongInt;
Begin
     Result := False;
     If FSelectMode <> smColumnBlock Then Exit;
     If (ICB.First.Line = Nil) Or (ICB.Last.Line = Nil) Then Exit;
     If ICB.First.Line = ICB.Last.Line Then Exit;
     {determine Screen Lines Of ICB And Update y1,y2}
     If FActLine = ICB.First.Line Then _y1 := FFileCursor.Y
     Else _y1 := _PLine2Index(ICB.First.Line);
     If FActLine = ICB.Last.Line Then _y2 := FFileCursor.Y
     Else _y2 := _PLine2Index(ICB.Last.Line);
     _y1 := FScrCursor.Y - (FFileCursor.Y - _y1); {FTopScreenLine}
     _y2 := FScrCursor.Y - (FFileCursor.Y - _y2); {FTopScreenLine}
     If _y1 < y1 Then y1 := _y1;
     If _y2 > y2 Then y2 := _y2;
     Result := True;
End;


{Clipboard}

Function TEditor._SetClipBoardText(P:Pointer; len:LongInt):Boolean;
Begin
     Result := False;

     If Clipboard.Open(Handle) Then
     Begin
          Clipboard.Empty;
          ClipBoard.SetTextBuf(P);
          Clipboard.Close;
          Result := True;
     End
     Else SetErrorMessage(LoadNLSStr(SCouldNotAccessClipboard)+'.');
End;


Function TEditor._GetClipBoardText(Var P:Pointer; Var len:LongInt):Boolean;
Var  clip:Pointer;
Begin
     Result := False;
     If Clipboard.Open(Handle) Then
     Begin
          clip := Pointer(Clipboard.GetAsHandle(cfText));
          If clip = Nil Then
          Begin
               Clipboard.Close;
               Exit;
          End;
          Asm   {Search terminal #0}
             CLD
             MOV ECX,0
             MOV ESI,clip
!gt:
             INC ECX
             LODSB
             CMP AL,0
             JNE !gt
             MOV EDI,len
             MOV [EDI],ECX
          End;

          If len > 1 Then
          Begin
               GetMem(P,len);
               System.Move(clip^,P^,len);
               Result := True;
          End;
          Clipboard.Close;
     End
     Else SetErrorMessage(LoadNLSStr(SCouldNotAccessClipboard)+'.');
End;


{+++ Protected ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{Test whether Window can be closed}
Function TEditor.FileCloseQuery:Boolean;
Var  resp:TMsgDlgReturn;
     Text:String;
Begin
     result := True;
     If Modified Then
     Begin
          If Untitled And (FFileName = '')
          Then Text := FmtLoadNLSStr(SSaveQuery,[Caption])
          Else Text := FmtLoadNLSStr(SSaveQuery,[FFileName]);
          resp := SetQueryMessage(Text,mtInformation,mbYesNoCancel);
          Case resp Of
              mrYes    : If Not SaveFile Then result := False;
              mrCancel : result := False;
          End;
     End;
End;

Function TEditor.CloseQuery:Boolean;
Begin
  result := FileCloseQuery;
  {CloseQuery Result True - Form will be destroyed}
end;


Destructor TEditor.Destroy;
Var  pl:PLine;
     plnext:PLine;
     I:Integer;
     lzk:Integer;
     pp:^TEditorPos;
Begin
     FlushWorkLine;
     (* -> releaseheapgroup
     pl := FFirstLine;
     While pl <> Nil Do
     Begin
          lzk := Length(pl^.zk^);
          FreeMem(pl^.zk, lzk+1);
          plnext := pl^.Next;
          freemem(pl,sizeof(pl^));
          pl := plnext;
     End;
     *)

     FUndoList.Destroy;
     FRedoList.Destroy;

     (* -> releaseheapgroup
     For I := IncSearchList.Count-1 DownTo 0 Do
     Begin
          pp := IncSearchList.Items[I];
          freemem(pp, sizeof(pp^));
     End;
     *)
     IncSearchList.Destroy;

     {Martin0206}
     if FFind.FindHistory <> nil then FFind.FindHistory.Destroy;
     if FFind.ReplaceHistory <> nil then FFind.ReplaceHistory.Destroy;
     if FFindReplace.FindHistory <> nil then FFindReplace.FindHistory.Destroy;
     if FFindReplace.ReplaceHistory <> nil then FFindReplace.ReplaceHistory.Destroy;

     If FMacroList <> Nil Then FMacroList.Destroy;

     If FCaret <> Nil Then FCaret.Destroy;
     FCaret := Nil;

     {Martin}if TopPanel <> nil then TopPanel.Destroy;

     {Martin0207}
     ReleaseHeapGroup (FHeapgroupID);

     Inherited Destroy;
End;


{Window Is getting A Char event}
Procedure TEditor.CharEvent(Var key:Char;RepeatCount:Byte);
Var  iew:Boolean;
     ip:TICBPosition;
     I,N,DX,Right,brk:Integer;
     NewL,wrapit:Boolean;
     rest,S:String;
     Code:TKeyCode;
Begin
     {Martin}RealCharEvent := true;
     If key < #32 Then key := #32;
     {Martin3} if RunInAnsi then key := OEMtoAnsiTable[key];

     If WindowState = wsMinimized Then
     Begin
          key := #0;
          Exit;
     End;
     KeyRepeat := 1;

     If FindICB.First.Line <> Nil Then
     Begin
          FindICB.First.Line := Nil;
          InvalidateEditor(0,0);
     End;

     If FPreCtrl > 0 Then
     Begin
          {Martin}
          {This old code did not work in Windows if Shift was pressed}
          (*Code := Ord(key) + kb_Char + kb_Ctrl;*)
          {Problem: to convert a normal character key to the ctrl code
           (e.g. pressing Ctrl-K-D should be the same as Ctrl-K-Ctrl-D,
           OS/2 requires lowercase letters, and Windows requires capital letters}
          {$ifdef os2}
            if (key >= 'A') and (key <= 'Z') {=uppercase letter} then
              Code := kb_Char + kb_Ctrl + Ord(key)+32{=lowercase}
            else
              Code := kb_Char + kb_Ctrl + Ord(key);
          {$else}
            {Windows}
            Code := kb_Char + kb_Ctrl + Ord(upcase(key));
          {$endif}
          ScanEvent(Code,RepeatCount);
          key := #0;
          {Martin}RealCharEvent := false;
          Exit;
     End;

     If FRecording Then
     Begin
          FMacroList.Add(Pointer(Ord((key))));
          FMacroList.Add(Pointer(RepeatCount));
     End;

     If FLastFind = faIncSearch Then
     Begin
          IncSearchText := IncSearchText + key;
          cmIncrementalSearch;
          key := #0;
          Exit;
     End;

     If ReadOnly Then
     Begin
          key := #0;
          Exit;
     End;
     TestAutoSave;

     If _ICBOverwrite Then iew := _ICBDeleteICB
     Else iew := False;

     {Test Word wrapping}
     If Not WLactivated Then _ReadWorkLine;
     wrapit := False;
     If FWordWrap Then
     Begin
          If FWordWrapColumn > 0 Then Right := FWordWrapColumn
          Else Right := FWinSize.X + FFileCursor.X - FScrCursor.X -1;

          For I := Length(FWorkLine) DownTo 1 Do
             If FWorkLine[I] = ' ' Then SetLength(FWorkLine,Length(FWorkLine)-1)
             Else break;

          N := Length(FWorkLine);
          If (FFileCursor.X > N) And (key <> ' ') Then N := FFileCursor.X
          Else If (FInsertMode) And (N < StringLength) Then Inc(N);
          If N > Right Then wrapit := True;
     End;


     If FInsertMode Then
     Begin
          (*Undo*)
          If (LastUndoGroup <> ugInsertChar) Or wrapit Then
          Begin
               _CopyUndoLines(FActLine,FActLine);
               LastUndoGroup := ugInsertChar;
          End;
          (*Undo*)
          If Not _InsertString(FFileCursor.X,key) Then Beep(1000,10);
          If FSelectMode <> smColumnBlock Then
          Begin
               ip := _ICBPos(FActLine,FFileCursor.X);
               If ip * [ipBeforeICBFirst] <> [] Then Inc(ICB.First.X);
               If ip * [ipBeforeICBLast] <> [] Then Inc(ICB.Last.X);
               _ICBCheckX;
          End;
     End
     Else
     Begin
          (*Undo*)
          If (LastUndoGroup <> ugOverwriteChar) Or wrapit Then
          Begin
               _CopyUndoLines(FActLine,FActLine);
               LastUndoGroup := ugOverwriteChar;
          End;
          (*Undo*)
          If Not _WriteString(FFileCursor.X,key) Then Beep(1000,10);
     End;

     {iew := _CursorRight Or iew;}
     If FFileCursor.X < StringLength Then
     Begin
          Inc(FFileCursor.X,1);
          If FScrCursor.X + 1 > FWinSize.X Then
          Begin
               FScrCursor.X := FWinSize.X;
               iew := True;
          End
          Else Inc(FScrCursor.X,1);
     End;

     {Word wrapping}
     If wrapit Then
     Begin
          For I := Length(FWorkLine) DownTo 1 Do
             If FWorkLine[I] = ' ' Then SetLength(FWorkLine,Length(FWorkLine)-1)
             Else break;

          If Length(FWorkLine) > Right Then
          Begin
               brk := Length(FWorkLine);
               {Search Last break chance B4 Right}
               For I := Length(FWorkLine) DownTo 1 Do
               Begin
                    If FWorkLine[I] = ' ' Then
                    Begin
                         brk := I;
                         If brk <= Right Then break;
                    End;
               End;
               If brk = Length(FWorkLine) Then brk := Right;
               DX := FFileCursor.X - brk;

               rest := Copy(FWorkLine,brk+1,255);
               While (rest[1] = ' ') And (Length(rest) > 0) Do
               Begin
                    Delete(rest,1,1);
                    If DX > 1 Then Dec(DX);
               End;
               SetLength(FWorkLine,brk);
               _WriteWorkLine;
               NewL := True; {Insert A New Line}
               If CountLines > FFileCursor.Y Then
               Begin
                    S := _PLine2PString(FActLine^.Next)^;
                    N := Length(rest);
                    If S <> '' Then
                      If N + Length(S) < Right Then NewL := False;
               End;

               LastUndoGroup := ugGroup;   {group Events}
               If NewL Then InsertLine(FFileCursor.Y+1,rest)
               Else ReplaceLine(FFileCursor.Y+1,rest +' '+ S);
               LastUndoGroup := ugGroup;   {group Events}

               If (DX > 1) And (key <> ' ') Then
               Begin
                    KeyRepeat := 1;
                    _CursorDown;
                    FFileCursor.X := DX;
                    If DX <= FWinSize.X Then FScrCursor.X := DX
                    Else FScrCursor.X := 1;
                    _StoreUndoCursor(FUndoList);
                    LastUndoGroup := ugGroup;   {group Events}
               End;
               iew := True;
          End;
     End;

     FRedoList.Clear;
     If iew Then
     Begin
          UpdateLineColorFlag(FActLine);
          InvalidateEditor(0,0);
     End
     Else InvalidateWorkLine;

     key := #0;
End;


{Window Is getting A scan event}
Procedure TEditor.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var  pp:^TEditorPos;
     MsgHandled:Boolean;
Begin
     If WindowState = wsMinimized Then
     Begin
          If KeyCode In [kbCR,kbEnter] Then WindowState := wsNormal;
          KeyCode := kbNull;
          Exit;
     End;

     If FindICB.First.Line <> Nil Then
     Begin
          FindICB.First.Line := Nil;
          InvalidateEditor(0,0);
     End;

     If FRecording Then
     Begin
          FMacroList.Add(Pointer(KeyCode));
          FMacroList.Add(Pointer(RepeatCount));
     End;

     KeyRepeat := RepeatCount;
     If FLastFind = faIncSearch Then
     Begin
          If KeyCode = kbShift Then
          Begin
               KeyCode := kbNull;
               Exit;
          End;
          If KeyCode = kbAltGraf Then
          Begin
               KeyCode := kbNull;
               Exit;
          End;
          If KeyCode = kbBkSp Then
          Begin
               Delete(IncSearchText,Length(IncSearchText),1);
               If IncSearchList.Count > 0 Then
               Begin
                    pp := IncSearchList.First; {Get previous Position}
                    IncSearchList.Delete(0);   {Delete entry}
                    _GotoPosition(pp^);
                    freemem(pp,sizeof(pp^));
                    cmIncrementalSearch;
                    If IncSearchList.Count > 0 Then
                    Begin
                         pp := IncSearchList.First;
                         IncSearchList.Delete(0); {Remove Last Position from stack}
                         freemem(pp,sizeof(pp^));
                    End;
                    InvalidateEditor(0,0);
                    KeyCode := kbNull;
                    Exit;
               End;
          End;
          FLastFind := faNothing;
          SetIncSearchText('');
          IncSearchText := '';
     End;


      //const oben einfÅgen! Suche: kbCtrlShiftP
      //  kbCtrlShiftA        = kb_Ctrl + kb_Shift + kb_Char + 65;

          //zur ErklÑrung
          //OS/2: kbScanBase    = 97
          //Win:  kbScanBase    = 65
          //kbCtrlShiftP        = kb_Ctrl + kb_Shift + kb_Char + 15 + 65
          //kbCtrlP             = kb_Ctrl            + kb_Char + 15 + 97bzw65
          //
          //erstaunlicherweise ist kbCtrlP bei Win und OS/2 unterschiedlich,
          //wÑhrend kbCtrlShiftP gleich sind. Es funktioniert aber unter Windows!

     {Martin 10/2005: Omit SHIFT if Ctrl-A - Ctrl-Z is pressed}
     if ConvertShiftCtrlChar2CtrlChar then begin
       if (Keycode >= kbCtrlShiftA) and (Keycode <= kbCtrlShiftZ) then
         Keycode := TKeycode(Keycode - (kbCtrlShiftP-kbCtrlP));
     end;

     Case FKeyMap Of
       kmWordStar: MsgHandled := EmulateWordStar(KeyCode,FPreCtrl);
       kmCUA:      MsgHandled := EmulateCUA(KeyCode,FPreCtrl);
       kmDefault:  MsgHandled := EmulateDefault(KeyCode,FPreCtrl);
       Else Beep(100,100);
     End;

     If MsgHandled Then KeyCode := kbNull
     Else Inherited ScanEvent(KeyCode,RepeatCount);
End;


{IDE Classic}
Function TEditor.EmulateWordStar(Var KeyCode,PreControl:TKeyCode):Boolean;
Var  P:TEditorPos;
     key:TKeyCode;
Begin
     Result := True;
     key := KeyCode;
     KeyCode := PreControl Or KeyCode;
     If Not (key In [kbCtrl,kbShift]) Then PreControl := 0;

     Case KeyCode Of
       kbCtrlS             : cmCursorLeft;
       kbCtrlD             : cmCursorRight;
       kbCtrlE             : cmCursorUp;
       kbCtrlX             : cmCursorDown;
       kbCtrlR             : cmCursorPageUp;
       kbCtrlC             : cmCursorPageDown;
       kbCtrlW             : cmCursorRollDown;
       kbCtrlZ             : cmCursorRollUp;
       kbCtrlF             : cmCursorWordRight;
       kbCtrlA             : cmCursorWordLeft;
       kbCtrlQR            : cmCursorFileBegin;
       kbCtrlQC            : cmCursorFileEnd;
       kbCtrlQE            : cmCursorPageHome;
       kbCtrlQX            : cmCursorPageEnd;
      {kbCtrlQT            : ;}
      {kbCtrlQU            : ;}
       kbCtrlQB            : If GetSelectionStart(P) Then GotoPosition(P);
       kbCtrlQK            : If GetSelectionEnd(P) Then GotoPosition(P);
       kbCtrlQS            : cmCursorHome;
       kbCtrlQD            : cmCursorEnd;
       kbCtrlQF            : cmFindText;
       kbCtrlQA            : cmReplaceText;
       kbCtrlQI            : cmIncrementalSearch;   {*}
       kbCtrlQY            : cmDeleteLineEnd;
       kbCtrlKB            : SetSelectionStart(FFileCursor);
       kbCtrlKK            : SetSelectionEnd(FFileCursor);
       kbCtrlKT            : SelectWord(FFileCursor);
       kbCtrlKL            : SelectLine(FFileCursor);
       kbCtrlV             : ToggleInsertMode;
       kbCtrlKH            : If ICBVisible Then HideSelection
                             Else ShowSelection;
       kbCtrlKR            : cmICBReadBlock;
       kbCtrlKW            : cmICBWriteBlock;
       kbCtrlKU            : cmICBMoveLeft;
       kbCtrlKI            : cmICBMoveRight;
       kbCtrlKC            : cmICBCopyBlock;
       kbCtrlKV            : cmICBMoveBlock;
       kbCtrlKY            : cmICBDeleteBlock;
       kbCtrlKM            : cmICBUpcaseBlock;
       kbCtrlKN            : ToggleSelectMode;
       kbCtrlKO            : cmICBLowcaseBlock;
       kbCtrlKF            : cmICBUpcaseWord;
       kbCtrlKE            : cmICBLowcaseWord;
       kbCtrlKS            : SaveFile;
       kbCtrlN             : cmBreakLine;
       kbCtrlY             : cmDeleteLine;
       kbCtrlT             : cmDeleteRightWord;
       kbShiftBkSp          : cmDeleteLeftWord;{Martin0308}
       kbCtrlI             : cmTabulator;
       kbCtrlG             : cmDeleteChar;
       kbCtrlH             : cmBackSpace;
       kbCtrlL             : cmSearchTextAgain;
       kbCtrlShiftS        : cmIncrementalSearch;

       kbCLeft             : cmCursorLeft;
       kbCRight            : cmCursorRight;
       kbCUp               : cmCursorUp;
       kbCDown             : cmCursorDown;
       kbHome              : cmCursorHome;
       kbEnd               : cmCursorEnd;
       kbPageDown          : cmCursorPageDown;
       kbPageUp            : cmCursorPageUp;
       kbCtrlCLeft         : cmCursorWordLeft;
       kbCtrlCRight        : cmCursorWordRight;
       kbCtrlCUp           : cmICBUpcaseBlock;     {*}
       kbCtrlCDown         : cmICBLowcaseBlock;    {*}

       kbCtrlHome          : cmCursorFileBegin;
       kbCtrlEnd           : cmCursorFileEnd;
       kbCtrlPageUp        : cmCursorPageHome;
       kbCtrlPageDown      : cmCursorPageEnd;

       kbShiftCLeft        : cmICBExtLeft;
       kbShiftCRight       : cmICBExtRight;
       kbShiftCUp          : cmICBExtUp;
       kbShiftCDown        : cmICBExtDown;
       kbShiftPageUp       : cmICBExtPageUp;
       kbShiftPageDown     : cmICBExtPageDown;
       kbShiftHome         : cmICBExtHome;
       kbShiftEnd          : cmICBExtEnd;
       kbAltShiftCLeft     : Begin SelectMode:=smColumnBlock; cmICBExtLeft; End;
       kbAltShiftCRight    : Begin SelectMode:=smColumnBlock; cmICBExtRight; End;
       kbAltShiftCUp       : Begin SelectMode:=smColumnBlock; cmICBExtUp; End;
       kbAltShiftCDown     : Begin SelectMode:=smColumnBlock; cmICBExtDown; End;
       kbAltShiftPageUp    : Begin SelectMode:=smColumnBlock; cmICBExtPageUp; End;
       kbAltShiftPageDown  : Begin SelectMode:=smColumnBlock; cmICBExtPageDown; End;
       kbAltShiftHome      : Begin SelectMode:=smColumnBlock; cmICBExtHome; End;
       kbAltShiftEnd       : Begin SelectMode:=smColumnBlock; cmICBExtEnd; End;
       kbCtrlShiftCLeft    : cmICBExtWordLeft;
       kbCtrlShiftCRight   : cmICBExtWordRight;
       kbCtrlShiftHome     : cmICBExtPageBegin;
       kbCtrlShiftEnd      : cmICBExtPageEnd;
       kbCtrlShiftPageUp   : cmICBExtFileBegin;
       kbCtrlShiftPageDown : cmICBExtFileEnd;
       kbCtrlAltShiftCLeft : Begin SelectMode:=smColumnBlock; cmICBExtWordLeft; End;
       kbCtrlAltShiftCRight: Begin SelectMode:=smColumnBlock; cmICBExtWordRight; End;
       kbCtrlAltShiftHome  : Begin SelectMode:=smColumnBlock; cmICBExtPageBegin; End;
       kbCtrlAltShiftEnd   : Begin SelectMode:=smColumnBlock; cmICBExtPageEnd; End;
       kbCtrlAltShiftPageUp: Begin SelectMode:=smColumnBlock; cmICBExtFileBegin; End;
       kbCtrlAltShiftPageDown : Begin SelectMode:=smColumnBlock; cmICBExtFileEnd; End;
       kbCtrlSlash         : SelectAll;    {*}
       kbCtrlBackSlash     : DeselectAll;  {*}
       kbCtrlK0..kbCtrlK9  : SetBookMark((KeyCode And Not kbPreCtrlK)-48,FFileCursor);
       kbCtrlQ0..kbCtrlQ9  : GotoBookMark((KeyCode And Not kbPreCtrlQ)-48);
       kbCtrl0..kbCtrl9    : GotoBookMark((KeyCode And Not (kb_Ctrl+kb_Char))-48);
       kbCtrlU0..kbCtrlU9  : ClearBookMark((KeyCode And Not kbPreCtrlU)-48); {*}
       kbCtrlUU            : ClearAllBookMarks;                              {*}
       kbAltBkSp,kbCtrlBkSp: Undo;{Martin0308}
       kbAltShiftBkSp,kbCtrlShiftBkSp : Redo;
       kbAltCLeft          : cmICBMoveLeft;
       kbAltCRight         : cmICBMoveRight;
       kbTab               : cmTabulator;
       kbShiftTab          : cmPrevTabulator;
       kbDel               : cmDeleteChar;
       kbBkSp              : cmBackSpace;
       //kbShiftBkSp         : cmBackSpace;
       kbShiftSpace        : CharEvent(SpaceChar,1);
       kbCtrlSpace         : CharEvent(SpaceChar,1);
       kbCR,
       kbShiftCR           : cmEnter;
       {$IFDEF OS2}
       kbEnter,
       kbShiftEnter        : cmEnter;
       {$ENDIF}
       kbCtrlDel           : cmICBDeleteBlock;
       kbShiftDel          : CutToClipBoard;
       kbCtrlIns           : CopyToClipboard;
       kbShiftIns          : PasteFromClipBoard;
       kbIns               : ToggleInsertMode;
       kbCtrlOC            : SelectMode := smColumnBlock;
       kbCtrlOK            : SelectMode := smNonInclusiveBlock;
      {kbCtrlOI            : SelectMode := smInklusiveBlock;
       kbCtrlOL            : SelectMode := smLineBlock;}
       kbCtrlOU            : cmToggleCase;
       kbCtrlShiftR        : cmRecordMacro;
       kbCtrlShiftP        : cmPlayMacro;
       kbCtrlK             : PreControl := kbPreCtrlK;
       kbCtrlQ             : PreControl := kbPreCtrlQ;
       kbCtrlU             : PreControl := kbPreCtrlU;
       kbCtrlO             : PreControl := kbPreCtrlO;
       Else Result := False;
     End;
End;


{CUA}
Function TEditor.EmulateCUA(Var KeyCode,PreControl:TKeyCode):Boolean;
Var  key:TKeyCode;
Begin
     Result := True;
     key := KeyCode;
     KeyCode := PreControl Or KeyCode;
     If Not (key In [kbCtrl,kbShift]) Then PreControl := 0;

     Case KeyCode Of
       kbCtrlF7            : cmICBMoveLeft;
       kbCtrlF8            : cmICBMoveRight;
       kbShiftBkSp          : cmDeleteLine;{Martin0308}
       kbCtrlY             : cmDeleteLine;
       kbCtrlS             : cmFindText;
       kbCtrlF             : cmFindText;
       kbCtrlR             : cmReplaceText;
       kbCtrlN             : cmSearchTextAgain;
       kbCtrlE             : cmIncrementalSearch;
       kbCtrlI             : cmIncrementalSearch;
       kbCLeft             : cmCursorLeft;
       kbCRight            : cmCursorRight;
       kbCUp               : cmCursorUp;
       kbCDown             : cmCursorDown;
       kbHome              : cmCursorHome;
       kbEnd               : cmCursorEnd;
       kbPageDown          : cmCursorPageDown;
       kbPageUp            : cmCursorPageUp;
       kbCtrlCLeft         : cmCursorWordLeft;
       kbCtrlCRight        : cmCursorWordRight;
       kbCtrlCUp           : cmICBUpcaseBlock;
       kbCtrlCDown         : cmICBLowcaseBlock;

       kbCtrlHome          : cmCursorFileBegin;
       kbCtrlEnd           : cmCursorFileEnd;
       kbCtrlPageUp        : cmCursorPageHome;
       kbCtrlPageDown      : cmCursorPageEnd;

       kbShiftCLeft        : cmICBExtLeft;
       kbShiftCRight       : cmICBExtRight;
       kbShiftCUp          : cmICBExtUp;
       kbShiftCDown        : cmICBExtDown;
       kbShiftPageUp       : cmICBExtPageUp;
       kbShiftPageDown     : cmICBExtPageDown;
       kbShiftHome         : cmICBExtHome;
       kbShiftEnd          : cmICBExtEnd;
       kbCtrlShiftCLeft    : cmICBExtWordLeft;
       kbCtrlShiftCRight   : cmICBExtWordRight;
       kbCtrlShiftHome     : cmICBExtFileBegin;
       kbCtrlShiftEnd      : cmICBExtFileEnd;
       kbCtrlShiftPageUp   : cmICBExtPageBegin;
       kbCtrlShiftPageDown : cmICBExtPageEnd;
       kbCtrlSlash         : SelectAll;
       kbCtrlBackSlash     : DeselectAll;
       kbCtrlK0..kbCtrlK9  : SetBookMark((KeyCode And Not kbPreCtrlK)-48,FFileCursor);
       kbCtrlQ0..kbCtrlQ9  : GotoBookMark((KeyCode And Not kbPreCtrlQ)-48);
       kbCtrlU0..kbCtrlU9  : ClearBookMark((KeyCode And Not kbPreCtrlU)-48);
       kbCtrlUU            : ClearAllBookMarks;
       kbAltBkSp,kbCtrlBkSp: Undo;{Martin0308}
       kbAltShiftBkSp,kbCtrlShiftBkSp       : Redo;
       kbAltCLeft          : cmICBMoveLeft;
       kbAltCRight         : cmICBMoveRight;
       kbTab               : cmTabulator;
       kbShiftTab          : cmPrevTabulator;
       kbDel               : cmDeleteChar;
       kbBkSp              : cmBackSpace;
       //kbShiftBkSp         : cmBackSpace;
       kbShiftSpace        : CharEvent(SpaceChar,1);
       kbCtrlSpace         : CharEvent(SpaceChar,1);
       kbCR,
       kbShiftCR           : cmEnter;
       {$IFDEF OS2}
       kbEnter,
       kbShiftEnter        : cmEnter;
       {$ENDIF}
       kbCtrlDel           : cmICBDeleteBlock;
       kbShiftDel          : CutToClipBoard;
       kbCtrlIns           : CopyToClipboard;
       kbShiftIns          : PasteFromClipBoard;
       kbIns               : ToggleInsertMode;
       kbCtrlShiftR        : cmRecordMacro;
       kbCtrlShiftP        : cmPlayMacro;
       kbCtrlK             : PreControl := kbPreCtrlK;
       kbCtrlQ             : PreControl := kbPreCtrlQ;
       kbCtrlU             : PreControl := kbPreCtrlU;
       Else Result := False;
     End;
End;


{Delphi Default}
Function TEditor.EmulateDefault(Var KeyCode,PreControl:TKeyCode):Boolean;
Var  P:TEditorPos;
     key:TKeyCode;
Begin
     Result := True;
     key := KeyCode;
     KeyCode := PreControl Or KeyCode;
     If Not (key In [kbCtrl,kbShift]) Then PreControl := 0;

     Case KeyCode Of
       kbCtrlS             : SaveFile;
       kbCtrlE             : cmIncrementalSearch;
       kbCtrlR             : cmReplaceText;
       kbCtrlF             : cmFindText;
       kbCtrlI             : cmTabulator;
       kbCtrlN             : cmBreakLine;
       kbCtrlT             : cmDeleteRightWord;
       kbCtrlY             : cmDeleteLine;
       kbCtrlZ             : Undo;
       kbCtrlShiftI        : cmICBMoveRight;
       kbCtrlShiftU        : cmICBMoveLeft;
       kbCtrlShiftY        : cmDeleteLineEnd;
       kbCtrlShiftZ        : Redo;
       kbHome              : cmCursorHome;
       kbEnd               : cmCursorEnd;
       kbCR,
       kbShiftCR           : cmEnter;
       {$IFDEF OS2}
       kbEnter,
       kbShiftEnter        : cmEnter;
       {$ENDIF}
       kbIns               : ToggleInsertMode;
       kbDel               : cmDeleteChar;
       kbBkSp              : cmBackSpace;
       kbTab               : cmTabulator;
       kbCLeft             : cmCursorLeft;
       kbCRight            : cmCursorRight;
       kbCUp               : cmCursorUp;
       kbCDown             : cmCursorDown;
       kbPageDown          : cmCursorPageDown;
       kbPageUp            : cmCursorPageUp;
       kbCtrlCLeft         : cmCursorWordLeft;
       kbCtrlCRight        : cmCursorWordRight;
       kbShiftBkSp          : cmDeleteLeftWord;{Martin0308}

       kbCtrlHome          : cmCursorFileBegin;
       kbCtrlEnd           : cmCursorFileEnd;
       kbCtrlPageUp        : cmCursorPageHome;
       kbCtrlPageDown      : cmCursorPageEnd;

       kbCtrlSpace         : CharEvent(SpaceChar,1);
       kbCtrlDel           : cmICBDeleteBlock;
       kbCtrlCUp           : cmCursorRollDown;
       kbCtrlCDown         : cmCursorRollUp;
       kbShiftTab          : cmPrevTabulator;
       //kbShiftBkSp         : cmBackSpace;
       kbShiftCLeft        : cmICBExtLeft;
       kbShiftCRight       : cmICBExtRight;
       kbShiftCUp          : cmICBExtUp;
       kbShiftCDown        : cmICBExtDown;
       kbShiftPageUp       : cmICBExtPageUp;
       kbShiftPageDown     : cmICBExtPageDown;
       kbShiftHome         : cmICBExtHome;
       kbShiftEnd          : cmICBExtEnd;
       kbShiftSpace        : CharEvent(SpaceChar,1);
       kbAltBkSp,kbCtrlBkSp: Undo;{Martin0308}
       kbAltShiftBkSp,kbCtrlShiftBkSp       : Redo;
       kbAltCLeft          : cmICBMoveLeft;
       kbAltCRight         : cmICBMoveRight;
       kbAltShiftCLeft     : Begin SelectMode:=smColumnBlock; cmICBExtLeft; End;
       kbAltShiftCRight    : Begin SelectMode:=smColumnBlock; cmICBExtRight; End;
       kbAltShiftCUp       : Begin SelectMode:=smColumnBlock; cmICBExtUp; End;
       kbAltShiftCDown     : Begin SelectMode:=smColumnBlock; cmICBExtDown; End;
       kbAltShiftPageUp    : Begin SelectMode:=smColumnBlock; cmICBExtPageUp; End;
       kbAltShiftPageDown  : Begin SelectMode:=smColumnBlock; cmICBExtPageDown; End;
       kbAltShiftHome      : Begin SelectMode:=smColumnBlock; cmICBExtHome; End;
       kbAltShiftEnd       : Begin SelectMode:=smColumnBlock; cmICBExtEnd; End;
       kbCtrlShiftCLeft    : cmICBExtWordLeft;
       kbCtrlShiftCRight   : cmICBExtWordRight;
       kbCtrlShiftHome     : cmICBExtFileBegin;
       kbCtrlShiftEnd      : cmICBExtFileEnd;
       kbCtrlShiftPageUp   : cmICBExtPageBegin;
       kbCtrlShiftPageDown : cmICBExtPageEnd;
       kbCtrlAltShiftCLeft : Begin SelectMode:=smColumnBlock; cmICBExtWordLeft; End;
       kbCtrlAltShiftCRight: Begin SelectMode:=smColumnBlock; cmICBExtWordRight; End;
       kbCtrlAltShiftHome  : Begin SelectMode:=smColumnBlock; cmICBExtFileBegin; End;
       kbCtrlAltShiftEnd   : Begin SelectMode:=smColumnBlock; cmICBExtFileEnd; End;
       kbCtrlAltShiftPageUp: Begin SelectMode:=smColumnBlock; cmICBExtPageBegin; End;
       kbCtrlAltShiftPageDown : Begin SelectMode:=smColumnBlock; cmICBExtPageEnd; End;
       kbCtrlKB            : SetSelectionStart(FFileCursor);
       kbCtrlKC            : cmICBCopyBlock;
       kbCtrlKH            : If ICBVisible Then HideSelection
                             Else ShowSelection;
       kbCtrlKI            : cmICBMoveRight;
       kbCtrlKK            : SetSelectionEnd(FFileCursor);
       kbCtrlKL            : SelectLine(FFileCursor);
       kbCtrlKM            : cmICBUpcaseBlock;
       kbCtrlKN            : ToggleSelectMode;
       kbCtrlKO            : cmICBLowcaseBlock;
       kbCtrlKR            : cmICBReadBlock;
       kbCtrlKT            : SelectWord(FFileCursor);
       kbCtrlKU            : cmICBMoveLeft;
       kbCtrlKV            : cmICBMoveBlock;
       kbCtrlKW            : cmICBWriteBlock;
       kbCtrlKY            : cmICBDeleteBlock;
       kbCtrlOC            : SelectMode := smColumnBlock;
       kbCtrlOK            : SelectMode := smNonInclusiveBlock;
      {kbCtrlOI            : SelectMode := smInklusiveBlock;
       kbCtrlOL            : SelectMode := smLineBlock;}
       kbCtrlQB            : If GetSelectionStart(P) Then GotoPosition(P);
       kbCtrlQC            : cmCursorFileEnd;
       kbCtrlQD            : cmCursorEnd;
       kbCtrlQE            : cmCursorPageHome;
       kbCtrlQK            : If GetSelectionEnd(P) Then GotoPosition(P);
       kbCtrlQR            : cmCursorFileBegin;
       kbCtrlQS            : cmCursorHome;
      {kbCtrlQT            : ;}
      {kbCtrlQU            : ;}
       kbCtrlQX            : cmCursorPageEnd;
       kbCtrlK0..kbCtrlK9  : SetBookMark((KeyCode And Not kbPreCtrlK)-48,FFileCursor);
       kbCtrlQ0..kbCtrlQ9  : GotoBookMark((KeyCode And Not kbPreCtrlQ)-48);
       kbCtrl0..kbCtrl9    : GotoBookMark((KeyCode And Not (kb_Ctrl+kb_Char))-48);
       kbCtrlU0..kbCtrlU9  : ClearBookMark((KeyCode And Not kbPreCtrlU)-48); {*}
       kbCtrlUU            : ClearAllBookMarks;                              {*}
       kbCtrlKF            : cmICBUpcaseWord;
       kbCtrlKE            : cmICBLowcaseWord;
       kbCtrlKS            : SaveFile;
       kbCtrlQF            : cmFindText;
       kbCtrlQA            : cmReplaceText;
       kbCtrlQI            : cmIncrementalSearch;   {*}
       kbCtrlQY            : cmDeleteLineEnd;
       kbCtrlOU            : cmToggleCase;
       kbShiftDel          : CutToClipBoard;
       kbCtrlIns           : CopyToClipboard;
       kbShiftIns          : PasteFromClipBoard;
       kbCtrlX             : CutToClipBoard;
       kbCtrlC             : CopyToClipboard;
       kbCtrlV             : PasteFromClipBoard;
       kbCtrlShiftR        : cmRecordMacro;
       kbCtrlShiftP        : cmPlayMacro;
       //kbCtrlCUp           : cmICBUpcaseBlock;       {*}
       //kbCtrlCDown         : cmICBLowcaseBlock;      {*}
       kbCtrlSlash         : SelectAll;              {*}
       kbCtrlBackSlash     : DeselectAll;            {*}
       kbCtrlK             : PreControl := kbPreCtrlK;
       kbCtrlQ             : PreControl := kbPreCtrlQ;
       kbCtrlU             : PreControl := kbPreCtrlU;
       kbCtrlO             : PreControl := kbPreCtrlO;
       Else Result := False;
     End;
End;


{Window Is getting the Focus}
Procedure TEditor.SetFocus;
Begin
     If HadFocus = 0 Then HadFocus := 1;
     If FCaret <> Nil Then
       If FCaret.created Then
       Begin
            FCaret.SetSize(FCaret.Width,FCaret.Height);
            FCaret.SetPos(FCaret.Left,FCaret.Bottom);
            If FCaret.BlinkTime <> 0
            Then FCaret.BlinkTime := FCaret.BlinkTime;
            FCaret.Show;
       End;

     Inherited SetFocus;
     FPreCtrl := 0;
End;


{Window Is loosing the Focus}
Procedure TEditor.KillFocus;
Begin
     HadFocus := 0;
     If FCaret <> Nil Then
       If FCaret.created Then
       Begin
            {$IFDEF Win32}
            FCaret.BlinkTime := -1;
            {$ENDIF}
            FCaret.Remove;
            FCaret.created := True;  //Deleted by DestroyCursor
       End;

     Inherited KillFocus;
End;


{Window Change its Size}
Procedure TEditor.Resize;
Begin
     Inherited Resize;
     CalcSizes;
End;


{$HINTS OFF}
Procedure TEditor.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);


     If Button <> mbLeft Then Exit;
     {Martin}
     (*If FEditOpt * [eo2ClickLine] <> [] Then SelectLine(FFileCursor)
     Else SelectWord(FFileCursor);*)

     HadFocus := 1;         {ignore MouseMove}
     LastMsg.Handled := True;
End;
{$HINTS ON}


Procedure TEditor.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  Scr:TEditorPos;
     T:Integer;
     iew:Boolean;
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button <> mbLeft Then Exit;

     LastMsg.Handled := True;
     MouseCapture := True;
     If HadFocus = 0 Then Exit;            {receive Focus}
     HadFocus := 2;

     if AllowSelectionWithMouse then begin
       If FindICB.First.Line <> Nil Then
       Begin
            FindICB.First.Line := Nil;
            InvalidateEditor(0,0);
       End;
     end;
     {Screen.}Update;

     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)

     FlushWorkLine;
     Scr := GetCursorFromMouse(Point(X,Y));

     If Scr.X < 1 Then Scr.X := 1;
     If Scr.X > FWinSize.X Then Scr.X := FWinSize.X;
     If Scr.Y < 1 Then Scr.Y := 1;
     If Scr.Y > FWinSize.Y Then Scr.Y := FWinSize.Y;

     If Scr.X > FScrCursor.X Then Inc(FFileCursor.X,Scr.X-FScrCursor.X)
     Else Dec(FFileCursor.X,FScrCursor.X-Scr.X);
     FScrCursor.X := Scr.X;

     If (FFileCursor.Y+Scr.Y)-FScrCursor.Y > FCountLines
     Then Scr.Y := FCountLines-FFileCursor.Y+FScrCursor.Y;

     If Scr.Y > FScrCursor.Y Then
     Begin
         Inc(FFileCursor.Y,Scr.Y-FScrCursor.Y);
         For T := 1 To Scr.Y-FScrCursor.Y Do FActLine := FActLine^.Next;
         FScrCursor.Y := Scr.Y;
     End
     Else
     Begin
          Dec(FFileCursor.Y,FScrCursor.Y-Scr.Y);
          For T := 1 To FScrCursor.Y-Scr.Y Do FActLine := FActLine^.Prev;
          FScrCursor.Y := Scr.Y;
     End;

     if AllowSelectionWithMouse then begin
       iew := _ICBExtSetICB;
       _ICBSetMark;
       ICBVisible := True;
       {iew := iew Or _ICBTestIEW;  {Extended Selection}
       If iew Then InvalidateEditor(0,0)
       Else SetScreenCursor;
     end
     Else SetScreenCursor;

     FCaret.Hide;
End;

function tEditor.AllowSelectionWithMouse : boolean;
  begin
    result := true;
  end;


Procedure TEditor.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     If Button = mbLeft Then
     Begin
          If HadFocus > 0 Then FCaret.Show;
          HadFocus := 1;
          _ICBExtCorrectICB2;
     End;

     Inherited MouseUp(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          LastMsg.Handled := True;
          MouseCapture := False;
     End;
End;


procedure tEditor.DelayScroll (Y : longint);
  var
    T : longint;
  begin
    {Martin 0705 slowing down scrolling while marking text and mouse outside the window
     T is the time the editor waits, dependent on the distance of the mouse pointer to the
     top or bottom margin: the more the mouse pointer is outside the window, the faster
     scrolling runs }
    if Y < 1 then T := -Y
    else if Y > ClientHeight then T := Y - ClientHeight;
    if T < 70 then begin
      if T < 1 then T := 1;
      //4allCalc formula: int(200/(T/3)^1,5 - 1)
      //formula of Powerof X^Y: exp (Y * ln (X))
      T := trunc(200.0/exp(1.5 * ln(round(T)/3.0)));
      if T > 200 then T := 200;
      if T < 1 then T := 1;
      delay (T);
    end;
  end;

Procedure TEditor.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var  Scr:TEditorPos;
     FC:TLineX;
     iew:Boolean;
     Down:Boolean;
     ScrY:Integer;
     y1,y2:Integer;

Begin {MouseMove}
     //Caption := tostr(X) + ' ' + tostr(Y);
     //{Martin0106} MouseMoved := true; Beep (100, 100);

     Inherited MouseMove(ShiftState,X,Y);

     //Beep (50, 100);
     {Martin0505}MouseX := X; MouseY := Y;
     LastMsg.Handled := True;
     If HadFocus < 2 Then Exit;
     If ShiftState * [ssLeft] = [] Then Exit;
     {Martin}if {Mouse outside the form or near the frame}
       (X < 1) or (Y < Rand) or (X > Width) or (Y > Height-Rand) then
       MouseCapture := True; {!!}

     FC := _ICBActPos;
     Scr := GetCursorFromMouse(Point(X,Y));

     KeyRepeat := Abs(Scr.X - FScrCursor.X);
     If Scr.X > FScrCursor.X Then iew := _CursorRight
     Else iew := _CursorLeft;

     ScrY := FScrCursor.Y;
     Down := Scr.Y > FScrCursor.Y;
     KeyRepeat := Abs(Scr.Y - FScrCursor.Y);
     If Scr.Y > FScrCursor.Y Then iew := _CursorDown Or iew
     Else iew := _CursorUp Or iew;

     if AllowSelectionWithMouse then begin
       _ICBClearMark;
       If FC = ICB.First Then ICB.First := _ICBActPos
       Else ICB.Last := _ICBActPos;

       _ICBExtCorrectICB;
       _ICBSetMark;
       ICBVisible := True;
     end;

     If Not iew Then
     Begin
          If Down Then
          Begin
               y1 := ScrY;
               y2 := FScrCursor.Y;
          End
          Else
          Begin
               y1 := FScrCursor.Y;
               y2 := ScrY;
          End;
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2);
     End
     Else begin
       DelayScroll (Y);
       InvalidateEditor(0,0);
     end;
End; {MouseMove}



Procedure TEditor.Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Var  SliderValue:LongInt;
     L,cnt:LongInt;
Begin
     Inherited Scroll(Sender,ScrollCode,ScrollPos);

     If (Sender <> FBottomScrollBar) And (Sender <> FRightScrollBar) Then Exit;

     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)

     Case ScrollCode Of
       scColumnLeft,
       scColumnRight,
       scPageLeft,
       scPageRight,
       scHorzTrack,
       scHorzPosition:
       Begin
            FFileCursor.X := ScrollPos + FScrCursor.X -1;
            //If Not _ICBPersistent Then _ICBClearICB;{Martin0308}
            InvalidateEditor(0,0);
       End;
       scLineUp:       cmCursorRollDown;
       scLineDown:     cmCursorRollUp;
       scPageUp:       cmCursorPageUp;
       scPageDown:     cmCursorPageDown;
       scVertTrack,
       scVertPosition:
       Begin
            FlushWorkLine;

            SliderValue := FFileCursor.Y - FScrCursor.Y + 1;
            If ScrollPos = SliderValue Then Exit;

            If ScrollPos > SliderValue Then  {downward}
            Begin
                 cnt := ScrollPos - SliderValue;
                 For L := 1 To cnt Do
                 Begin
                       If FActLine^.Next <> Nil Then
                       Begin
                            Inc(FFileCursor.Y);
                            FActLine := FActLine^.Next;
                            FTopScreenLine := FTopScreenLine^.Next;
                       End;
                 End;
            End
            Else
            Begin   {upward}
                 cnt := SliderValue - ScrollPos;
                 For L := 1 To cnt Do
                 Begin
                       If FTopScreenLine^.Prev <> Nil Then
                       Begin
                            Dec(FFileCursor.Y);
                            FActLine := FActLine^.Prev;
                            FTopScreenLine := FTopScreenLine^.Prev;
                       End;
                 End;
            End;
            //If Not _ICBPersistent Then _ICBClearICB;{Martin0308}
            InvalidateEditor(0,0);
       End;
     End;

     If Sender = FBottomScrollBar
     Then ScrollPos := FFileCursor.X - FScrCursor.X + 1
     Else ScrollPos := FFileCursor.Y - FScrCursor.Y + 1;
End;


Procedure TEditor.SetSliderValues;
  var
    {Martin1105: show vertical scrollbar in small textfile when scrolling text outside window}
    VirtualWindowSize, Scrollcount : longint;
Begin
     If IgnoreRedraw > 0 Then Exit;
     If (FBottomScrollBar <> Nil) (*and ((Scrollbars = ssBoth) or (Scrollbars = ssHorizontal))*)
     Then FBottomScrollBar.SetScrollRange(1,StringLength,FWinSize.X);
     If (FRightScrollBar <> Nil) (*and ((Scrollbars = ssBoth) or (Scrollbars = ssVertical))*)
     Then begin
       VirtualWindowSize := (Cursorpos.Y - Offsetpos.Y) + Rows;
       //Caption := tostr(VirtualWindowSize) + ' ' + tostr(FCountLines);
       if VirtualWindowSize > FCountLines then
         Scrollcount := VirtualWindowSize
       else
         Scrollcount := FCountLines;
       //Caption := tostr(Cursorpos.Y-Offsetpos.Y) + ' ' + tostr(Scrollcount) + ' ' + tostr(FCountLines) + ' ' + tostr(Rows);
       FRightScrollBar.SetScrollRange(1,Scrollcount,FWinSize.Y{Rows});
     end;

     SetSliderPosition;
End;


Procedure TEditor.SetSliderPosition;
Var  xl:LongInt;
Begin
     If IgnoreRedraw > 0 Then Exit;
     If (FBottomScrollBar <> Nil) and ((Scrollbars = ssBoth) or (Scrollbars = ssHorizontal)) Then
     Begin
          xl := FFileCursor.X - FScrCursor.X + 1;
          FBottomScrollBar.Position := xl; {LongInt Property !}
     End;
     If (FRightScrollBar <> Nil) and ((Scrollbars = ssBoth) or (Scrollbars = ssVertical))
     Then FRightScrollBar.Position := FFileCursor.Y - FScrCursor.Y + 1;
End;


Procedure TEditor.CalcSizes;
Var  CursorMoved:Boolean;
     FC:TEditorPos;
     ScrollbarWidth : longint;{Martin0605}
Begin
     ClientArea := ClientRect;
     {??????????+-1}
     Inc(ClientArea.Right);
     {Martin0705}inc (ClientArea.Top, 3);
     if TopPanel <> nil then if TopPanel.Visible then
       ClientArea.Top := ClientArea.Top - TopPanel.Height;
     if (VertScrollbar <> nil) and (Scrollbars <> ssBoth) then ScrollbarWidth := VertScrollbar.Width
     else ScrollbarWidth := 0;

     FWinSize.X := (ClientArea.Right - ClientArea.Left -
                   IndentRect.Left - IndentRect.Right -
                   2 * Integer(FBorderWidth)) Div Canvas.FontWidth;
     FWinSize.Y := (ClientArea.Top - ClientArea.Bottom -
                   IndentRect.Bottom - IndentRect.Top -
                   2 * Integer(FBorderWidth) + ScrollbarWidth{Martin0605}) Div Canvas.FontHeight;


     CursorMoved := False;
     If FScrCursor.Y > FWinSize.Y Then
     Begin
          FC.Y := FFileCursor.Y-FScrCursor.Y+FWinSize.Y;
          CursorMoved := True;
     End
     Else FC.Y := FFileCursor.Y;
     If FScrCursor.X > FWinSize.X Then
     Begin
          FC.X := FFileCursor.X-FScrCursor.X+FWinSize.X;
          CursorMoved := True;
     End
     Else FC.X := FFileCursor.X;
     If CursorMoved Then
     Begin
          Inc(IgnoreRedraw);
          GotoPosition(FC);
          Dec(IgnoreRedraw);
     End;
     SetScreenCursor;
     SetSliderValues;
End;


{ +++ CursorMove-Events ++++++++++++++++++++++++++++++++++++++++++++++++++++ }

Procedure TEditor.cmCursorDown;
Var  iew:Boolean;
Begin
     If FWinSize.Y = 0 Then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _CursorDown;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorUp;
Var  iew:Boolean;
Begin
     If FWinSize.Y = 0 Then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _CursorUp;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorRight;
Var  iew:Boolean;
     climb:Boolean;
Begin
     climb := False;
     If FEditOpt * [eoCursorClimb] <> [] Then
       If FFileCursor.X > Length(_PLine2PString(FActLine)^) Then
         If FFileCursor.Y < CountLines Then climb := True
         Else Exit;

     If _ICBPersistent Then
       If (FFileCursor.X >= StringLength) And Not climb Then Exit;

     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _CursorRight;
     If climb Then
     Begin
          iew := _CursorDown Or iew;
          iew := _CursorHome Or iew;
     End;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorLeft;
Var  iew:Boolean;
     climb:Boolean;
Begin
     climb := False;
     If FEditOpt * [eoCursorClimb] <> [] Then
       If FFileCursor.X <= 1 Then
         If FFileCursor.Y > 1 Then climb := True
         Else Exit;

     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _CursorLeft;
     If climb Then
     Begin
          iew := _CursorUp Or iew;
          iew := _CursorEnd Or iew;
     End;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorHome;
Var  iew:Boolean;
     I,p1:Integer;
Begin
     If _ICBPersistent Then
       If FFileCursor.X = 1 Then Exit;

     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     If Not WLactivated Then _ReadWorkLine;
     p1 := 1;
     If FEditOpt * [eoHomeFirstWord] <> [] Then
     Begin
          For I := 1 To FFileCursor.X-1 Do
          Begin
               If I > Length(FWorkLine) Then break;

               If FWorkLine[I] > ' ' Then
               Begin
                    p1 := I;  {onto First Word}
                    break;
               End;
          End;
     End;

     If p1 > 1 Then
     Begin
          _HorizMove;
          FFileCursor.X := p1;
          FScrCursor.X := p1;
          If FScrCursor.X > FWinSize.X Then FScrCursor.X := FWinSize.X;
          iew := _HorizMove;
     End
     Else iew := _CursorHome;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorEnd;
Var  iew:Boolean;
     lzk:Integer;
Begin
     FlushWorkLine;
     lzk := Length(_PLine2PString(FActLine)^);
     If _ICBPersistent Then
       If FFileCursor.X = lzk+1 Then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _CursorEnd;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorPageDown;
Begin
     If _ICBPersistent {Martin}and Selected Then
       If FFileCursor.Y >= FCountLines Then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     _CursorPageDown;
     If Not _ICBPersistent Then _ICBClearICB;

     InvalidateEditor(0,0);
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorPageUp;
Begin
     If _ICBPersistent Then
       If FFileCursor.Y <= 1 Then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     _CursorPageUp;
     If Not _ICBPersistent Then _ICBClearICB;

     InvalidateEditor(0,0);
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorRollDown;
Var  FCY:LongInt;
Begin
     If FWinSize.Y = 0 Then Exit;
     If FTopScreenLine^.Prev = Nil Then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     FCY := FFileCursor.Y;
     _CursorRollUp;
     If (Not _ICBPersistent) And (FCY <> FFileCursor.Y) Then _ICBClearICB;

     InvalidateEditor(0,0);
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorRollUp;
Var  FCY:LongInt;
Begin
     If FWinSize.Y = 0 Then Exit;
     {Martin}
     if TopScreenLine = LastLine then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     FCY := FFileCursor.Y;
     _CursorRollDown;
     If (Not _ICBPersistent) And (FCY <> FFileCursor.Y) Then _ICBClearICB;

     InvalidateEditor(0,0);
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorWordRight;
Var  iew:Boolean;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _CursorWordRight;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorWordLeft;
Var  iew:Boolean;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _CursorWordLeft;
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmCursorFileBegin;
Var  P:TEditorPos;
Begin
     P.X := 1;
     P.Y := 1;
     GotoPosition(P);
End;


Procedure TEditor.cmCursorFileEnd;
Var  P:TEditorPos;
Begin
     P.X := Length(_PLine2PString(FLastLine)^);
     Inc(P.X);
     P.Y := FCountLines;
     GotoPosition(P);
End;


Procedure TEditor.cmCursorPageHome;
Var  P:TEditorPos;
Begin
     P.X := FFileCursor.X;
     P.Y := FFileCursor.Y-FScrCursor.Y+1;
     GotoPosition(P);
End;


Procedure TEditor.cmCursorPageEnd;
Var  P:TEditorPos;
Begin
     P.X := FFileCursor.X;
     P.Y := FFileCursor.Y+FWinSize.Y-FScrCursor.Y;
     GotoPosition(P);
End;


{Extend Selection}

Procedure TEditor.cmICBExtLeft;
Var  iew:Boolean;
     y1,y2:Integer;
     climb:Boolean;
Label L;
Begin
     climb := False;
     If FEditOpt * [eoCursorClimb] <> [] Then
       If FSelectMode <> smColumnBlock Then
         If FFileCursor.X <= 1 Then
           If FFileCursor.Y > 1 Then climb := True
           Else Exit;

     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorLeft Or iew;
          If climb Then
          Begin
               iew := _CursorUp Or iew;
               iew := _CursorEnd Or iew;
          End;
          ICB.First := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorLeft Or iew;
          If climb Then
          Begin
               iew := _CursorUp Or iew;
               iew := _CursorEnd Or iew;
          End;
          ICB.Last := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := FScrCursor.Y;
          y2 := FScrCursor.Y;
          If climb Then Inc(y2);
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtRight;
Var  iew:Boolean;
     y1,y2:Integer;
     climb:Boolean;
Label L;
Begin
     climb := False;
     If FEditOpt * [eoCursorClimb] <> [] Then
       If FSelectMode <> smColumnBlock Then
         If FFileCursor.X > Length(_PLine2PString(FActLine)^) Then
           If FFileCursor.Y < CountLines Then climb := True
           Else Exit;

     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorRight Or iew;
          If climb Then
          Begin
               iew := _CursorDown Or iew;
               iew := _CursorHome Or iew;
          End;
          ICB.Last := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorRight Or iew;
          If climb Then
          Begin
               iew := _CursorDown Or iew;
               iew := _CursorHome Or iew;
          End;
          ICB.First := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := FScrCursor.Y;
          y2 := FScrCursor.Y;
          If climb Then Dec(y1);
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtUp;
Var  iew:Boolean;
     ScrY:Integer;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     ScrY := FScrCursor.Y;
     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorUp Or iew;
          ICB.First := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorUp Or iew;
          ICB.Last := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     {iew := iew Or _ICBTestIEW;  {Extended Selection}
     If iew Then InvalidateEditor(0,0)
     Else InvalidateEditor(FScrCursor.Y,ScrY);
End;


Procedure TEditor.cmICBExtDown;
Var  iew:Boolean;
     ScrY:Integer;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     ScrY := FScrCursor.Y;
     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorDown Or iew;
          ICB.Last := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorDown Or iew;
          ICB.First := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     {iew := iew Or _ICBTestIEW;  {Extended Selection}
     If iew Then InvalidateEditor(0,0)
     Else InvalidateEditor(ScrY,FScrCursor.Y);
End;


Procedure TEditor.cmICBExtPageUp;
Var  iew:Boolean;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorPageUp Or iew;
          ICB.First := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorPageUp Or iew;
          ICB.Last := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     {iew := iew Or _ICBTestIEW;  {Extended Selection}
     If iew Then InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtPageDown;
Var  iew:Boolean;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorPageDown Or iew;
          ICB.Last := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorPageDown Or iew;
          ICB.First := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     {iew := iew Or _ICBTestIEW;  {Extended Selection}
     If iew Then InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtHome;
Var  iew:Boolean;
     y1,y2:Integer;
     I,p1:Integer;
     icbap:TLineX;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;
     icbap := _ICBActPos;

     If Not WLactivated Then _ReadWorkLine;
     p1 := 1;
     If FEditOpt * [eoHomeFirstWord] <> [] Then
     Begin
          For I := 1 To FFileCursor.X-1 Do
          Begin
               If I > Length(FWorkLine) Then break;

               If FWorkLine[I] > ' ' Then
               Begin
                    p1 := I;  {onto First Word}
                    break;
               End;
          End;
     End;

     If p1 > 1 Then
     Begin
          _HorizMove;
          FFileCursor.X := p1;
          FScrCursor.X := p1;
          If FScrCursor.X > FWinSize.X Then FScrCursor.X := FWinSize.X;
          iew := _HorizMove Or iew;
     End
     Else iew := _CursorHome Or iew;

     If icbap = ICB.First Then
     Begin
          ICB.First := _ICBActPos;
          Goto L;
     End;

     If icbap = ICB.Last Then
     Begin
          ICB.Last := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := FScrCursor.Y;
          y2 := FScrCursor.Y;
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtEnd;
Var  iew:Boolean;
     y1,y2:Integer;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorEnd Or iew;
          ICB.Last := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorEnd Or iew;
          ICB.First := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := FScrCursor.Y;
          y2 := FScrCursor.Y;
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtWordLeft;
Var  iew:Boolean;
     ScrY:Integer;
     y1,y2:Integer;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     ScrY := FScrCursor.Y;
     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorWordLeft Or iew;
          ICB.First := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorWordLeft Or iew;
          ICB.Last := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := FScrCursor.Y;
          y2 := ScrY;
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtWordRight;
Var  iew:Boolean;
     ScrY:Integer;
     y1,y2:Integer;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     ScrY := FScrCursor.Y;
     If _ICBActPos = ICB.Last Then
     Begin
          iew := _CursorWordRight Or iew;
          ICB.Last := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _CursorWordRight Or iew;
          ICB.First := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := ScrY;
          y2 := FScrCursor.Y;
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtFileBegin;
Var  iew:Boolean;
     P:TEditorPos;
     ScrY:Integer;
     y1,y2:Integer;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     ScrY := FScrCursor.Y;
     P.X := 1;
     P.Y := 1;
     If _ICBActPos = ICB.First Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.First := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.Last := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := FScrCursor.Y;
          y2 := ScrY;
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtFileEnd;
Var  iew:Boolean;
     P:TEditorPos;
     ScrY:Integer;
     y1,y2:Integer;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     ScrY := FScrCursor.Y;
     P.X := Length(_PLine2PString(FLastLine)^);
     Inc(P.X);
     If P.X > StringLength Then P.X := StringLength;
     P.Y := FCountLines;
     If _ICBActPos = ICB.Last Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.Last := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.First := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     If Not iew Then
     Begin
          y1 := ScrY;
          y2 := FScrCursor.Y;
          _ICBTestIEW(y1,y2);   {Extended Selection}
          InvalidateEditor(y1,y2)
     End
     Else InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtPageBegin;
Var  iew:Boolean;
     P:TEditorPos;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     P.X := FFileCursor.X;
     P.Y := FFileCursor.Y-FScrCursor.Y+1;
     If _ICBActPos = ICB.First Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.First := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.Last Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.Last := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     {iew := iew Or _ICBTestIEW;  {Extended Selection}
     InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBExtPageEnd;
Var  iew:Boolean;
     P:TEditorPos;
Label L;
Begin
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     LastUndoGroup := ugCursorMove;
     (*Undo*)
     iew := _ICBExtSetICB;

     P.X := FFileCursor.X;
     P.Y := FFileCursor.Y+FWinSize.Y-FScrCursor.Y;
     If _ICBActPos = ICB.Last Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.Last := _ICBActPos;
          Goto L;
     End;

     If _ICBActPos = ICB.First Then
     Begin
          iew := _GotoPosition(P) Or iew;
          ICB.First := _ICBActPos;
     End;
L:
     _ICBExtCorrectICB;
     _ICBExtCorrectICB2;
     _ICBSetMark;
     ICBVisible := True;
     {iew := iew Or _ICBTestIEW;  {Extended Selection}
     InvalidateEditor(0,0);
End;


{Insert A Text block from A File And Select it}
Procedure TEditor.cmICBReadBlock;
Var  S,dir,Name,ext:String;
     //CFOD:TOpenDialog;
     CFOD:{$ifdef os2}TOpenDialog{$else}TSystemOpenDialog{$endif};
Begin
     CFOD.Create(Self);
     {if Editor is Main window, courier font would be chosen in dialog which is too big}
     {Martin} {$ifdef os2}{=Sibyl OpenDialog}if Application.Mainform = Self then CFOD.Font := Screen.SmallFont;{$endif}
     CFOD.Title := LoadNLSStr(SReadBlockFromFile);
     CFOD.OkName := LoadNLSStr(SOkButton);
     CFOD.FileName := fMask;
     CFOD.DefaultExt := GetDefaultExt(fMask);
     SetAvailabeFileTypes(CFOD);

     If CFOD.Execute Then
     Begin
          S := CFOD.FileName;
          {Martin} RememberKRKWfilename := S;
          CFOD.Destroy;

          If Not FileExists(S) Then
          Begin
               FSplit(S,dir,Name,ext);
               S := FmtLoadNLSStr(SFileNotFound,[Name + ext])+'.';
               SetErrorMessage(S);
          End
          Else InsertFromFile(S);
     End
     Else CFOD.Destroy;
End;


{Write the Selected area To A File}
Procedure TEditor.cmICBWriteBlock;
Var  P:Pointer;
     len:LongInt;
     S:String;
     //CFSD:TSaveDialog;
     CFSD:{$ifdef os2}TSaveDialog{$else}TSystemSaveDialog{$endif};
Begin
     CFSD.Create(Self);
     {Martin}{$ifdef os2}{=Sibyl OpenDialog}if Application.Mainform = Self then CFSD.Font := Screen.SmallFont;{$endif}
     CFSD.Title := LoadNLSStr(SWriteBlockToFile);
     CFSD.OkName := LoadNLSStr(SOkButton);
     CFSD.FileName := fMask;
     CFSD.DefaultExt := GetDefaultExt(fMask);
     SetAvailabeFileTypes(CFSD);

     If CFSD.Execute then if (TestFileWriteName{Martin0806} (CFSD.Filename) = mrYes) Then
     Begin
          S := CFSD.FileName;
          {Martin} RememberKRKWfilename := S;
          CFSD.Destroy;

          If Not _GetEditorBlock(P,len) Then Exit;
          {Martin}
          _WriteFileText (S, P, len);
     End
     else {Martin} CFSD.Destroy;
End;


Procedure TEditor.cmICBMoveLeft;
Var  P:TEditorPos;
Begin
     If ReadOnly Then Exit;
     If Not _ICBExist Then Exit;
     TestAutoSave;
     FlushWorkLine;
     (*Undo*)
     _CopyUndoLines(ICB.First.Line,ICB.Last.Line);
     (*Undo*)

     If FSelectMode <> smColumnBlock Then
     Begin
          If Length(ICB.First.Line^.zk^) > 0 Then
            If (ICB.First.Line^.zk^[1] = #32) And (ICB.First.X > 1)
            Then Dec(ICB.First.X);

          FActLine := ICB.First.Line;
          While FActLine <> ICB.Last.Line Do
          Begin
               If Length(FActLine^.zk^) > 0 Then
                 If FActLine^.zk^[1] = #32 Then
                 Begin
                      _ReadWorkLine;
                      _DeleteString(1,1);
                      _WriteWorkLine;
                 End;
               FActLine := FActLine^.Next;
          End;

          If (Length(ICB.Last.Line^.zk^) > 0) And (ICB.Last.X > 1) Then
            If ICB.Last.Line^.zk^[1] = #32 Then
            Begin
                 _ReadWorkLine;
                 _DeleteString(1,1);
                 _WriteWorkLine;
                 Dec(ICB.Last.X);
            End;
     End
     Else {Extended Selection}
     Begin
          FActLine := ICB.First.Line;
          While FActLine <> ICB.Last.Line^.Next Do
          Begin
               If Length(FActLine^.zk^) >= ICB.First.X Then
               Begin
                    _ReadWorkLine;
                    _DeleteString(ICB.First.X,1);
                    _WriteWorkLine;
               End;
               FActLine := FActLine^.Next;
          End;
          SetLineColorFlag(ICB.First.Line,ICB.Last.Line);
     End;

     FRedoList.Clear;
     If GetSelectionStart(P) Then
     Begin
          If _GotoPosition(P) Then InvalidateEditor(0,0)
          Else InvalidateEditor(FScrCursor.Y,0);
     End;
     (*Undo*)
     LastUndoGroup := ugBlockLeft;
     (*Undo*)
End;


Procedure TEditor.cmICBMoveRight;
Var  P:TEditorPos;
Begin
     If ReadOnly Then Exit;
     If Not _ICBExist Then Exit;
     TestAutoSave;
     FlushWorkLine;
     (*Undo*)
     _CopyUndoLines(ICB.First.Line,ICB.Last.Line);
     (*Undo*)

     If FSelectMode <> smColumnBlock Then
     Begin
          FActLine := ICB.First.Line;
          While FActLine <> ICB.Last.Line Do
          Begin
               If Length(FActLine^.zk^) < StringLength Then
               Begin
                    _ReadWorkLine;
                    _InsertString(1,' ');
                    _WriteWorkLine;
               End;
               FActLine := FActLine^.Next;
          End;

          If (Length(ICB.Last.Line^.zk^) < StringLength) And
             (ICB.Last.X > 1) Then
          Begin
               _ReadWorkLine;
               _InsertString(1,' ');
               _WriteWorkLine;
               If ICB.Last.X < StringLength Then Inc(ICB.Last.X);
          End;
     End
     Else {Extended Selection}
     Begin
          FActLine := ICB.First.Line;
          While FActLine <> ICB.Last.Line^.Next Do
          Begin
               If Length(FActLine^.zk^) < StringLength Then
               Begin
                    _ReadWorkLine;
                    _InsertString(ICB.First.X,' ');
                    _WriteWorkLine;
               End;
               FActLine := FActLine^.Next;
          End;
          SetLineColorFlag(ICB.First.Line,ICB.Last.Line);
     End;

     FRedoList.Clear;
     If GetSelectionStart(P) Then
     Begin
          If _GotoPosition(P) Then InvalidateEditor(0,0)
          Else InvalidateEditor(FScrCursor.Y,0);
     End;
     (*Undo*)
     LastUndoGroup := ugBlockRight;
     (*Undo*)
End;


procedure tEditor.LoadStringOfPLine(pl:PLine; var Line : string);
Begin
     If pl <> Nil Then
     Begin
          If pl^.zk <> Nil Then Line := pl^.zk^
          Else Line := FWorkLine;
     End
     Else Line := '';
End;


Procedure TEditor.cmICBCopyBlock;
Var  P:Pointer;
     len:LongInt;
     corr : byte;
Begin
     If ReadOnly Then Exit;
     If Not ICBVisible Then
     Begin
          ShowSelection;
          Exit;
     End;
     If Not _ICBExist Then Exit;
     TestAutoSave;

     If _GetEditorBlock(P,len) Then
     Begin
          if FSelectMode = smColumnBlock then
            corr := 0
          else
            corr := 1;
          InsertText(P,len-corr);  {without terminal #0}
          FreeMem(P,len);
     End;
End;


Procedure TEditor.cmICBMoveBlock;
Var  art:Byte;
     Cur:TLineX;
     laststr:String;
     icbstr:String;
     B,icb1:String;
     Licb:Integer;
     CurLinenext:PLine;
     ICBFirstLnext:PLine;
     ICBLastLnext:PLine;
     fl,LL:PLine;
     AL,IFL,ILL:LongInt;
     P:TEditorPos;
     PT : Pointer; len : longint;
     FirstX, LastX : integer;
     Curpos : tEditorpos;
     CursorYInBlock : boolean;
Begin
     If ReadOnly Then Exit;
     If Not ICBVisible Then
     Begin
          ShowSelection;
          Exit;
     End;
     If Not _ICBExist Then Exit;
     TestAutoSave;

     {Martin: move column block was not implemented yet, is implemented via delete + insert}
     if FSelectMode = smColumnBlock then begin
       If _GetEditorBlock(PT,len) Then     {including terminal #0}
       Begin
            {Martin Sept. 2005}
            Curpos := Cursorpos;
            FirstX := ICB.First.X; LastX := ICB.Last.X;
            //CursorYInBlock := (Curpos.Y >= _PLine2Index(ICB.First.Line)) and (Curpos.Y <= _PLine2Index(ICB.Last.Line));
            //eigentlich soll er nur bei der ersten Zeile nichts tun
            CursorYInBlock := Curpos.Y = _PLine2Index(ICB.First.Line); {Martin0206}
            if (Curpos.X >= LastX) and CursorYInBlock then begin
              cmICBdeleteBlock;
              Curpos.X := Curpos.X - (LastX - FirstX);
              Cursorpos := Curpos;
              _InsertColumnText (PT, len);
            end
            else if (Curpos.X < FirstX) or (not CursorYInBlock) then begin
              cmICBdeleteBlock;
              Cursorpos := Curpos;
              _InsertColumnText (PT, len);
            end;
            FreeMem(PT,len);
       End;
       exit;
     end;

     If FActLine^.flag And ciSelected <> 0 Then
     Begin
          art := 0;      {CurPos Is within the ICB}
          If (FActLine = ICB.First.Line) And (FFileCursor.X < ICB.First.X)
          Then art := 1; {CurPos In ICB FFirstLine, before ICB firstx}
          If (FActLine = ICB.Last.Line) And (FFileCursor.X > ICB.Last.X)
          Then art := 2; {CurPos In ICB endline, after ICB lastx}
     End
     Else art := 3;      {CurPos Not within the ICB Lines}
     If art = 0 Then Exit;

     (*Undo*)
     AL := FFileCursor.Y;
     IFL := _PLine2Index(ICB.First.Line);
     ILL := _PLine2Index(ICB.Last.Line);
     If AL < IFL Then fl := FActLine
     Else fl := ICB.First.Line;
     If AL > ILL Then LL := FActLine
     Else LL := ICB.Last.Line;
     _CopyUndoLines(fl,LL);
     (*Undo*)

     FlushWorkLine;
     Cur.Line := FActLine;
     Cur.X := FFileCursor.X;
     Case art Of
          1 :
          Begin
               laststr := _ReadString(ICB.First.Line,Cur.X,ICB.First.X-Cur.X);
               _DeleteString(Cur.X,Length(laststr));
               _WriteWorkLine;
               FActLine := ICB.Last.Line;
               If ICB.First.Line = ICB.Last.Line
               Then ICB.Last.X := ICB.Last.X - Length(laststr);
               If Not _InsertString(ICB.Last.X,laststr) Then Beep(1000,10);
               _WriteWorkLine;
               ICB.First.X := Cur.X;
          End;
          2 :
          Begin
               laststr := _ReadString(ICB.Last.Line,ICB.Last.X,Cur.X-ICB.Last.X);
               _DeleteString(ICB.Last.X,Length(laststr));
               _WriteWorkLine;
               FActLine := ICB.First.Line;
               If Not _InsertString(ICB.First.X,laststr) Then Beep(1000,10);
               _WriteWorkLine;
               If ICB.First.Line = ICB.Last.Line
               Then ICB.Last.X := ICB.Last.X + Length(laststr);
               ICB.First.X := ICB.First.X + Length(laststr);
          End;
          3 :
          Begin
               If ICB.First.Line = ICB.Last.Line Then
               Begin
                    Licb := ICB.Last.X-ICB.First.X;
                    icbstr := _ReadString(ICB.First.Line,ICB.First.X,Licb);
                    If Not _InsertString(Cur.X,icbstr) Then Beep(1000,10);
                    _ICBClearMark;
                    _WriteWorkLine;
                    FActLine := ICB.First.Line;
                    _DeleteString(ICB.First.X,Licb);
                    _WriteWorkLine;
                    ICB.First := Cur;
                    ICB.Last := Cur;
                    Inc(ICB.Last.X,Licb);
                    _ICBSetMark;
               End
               Else
               Begin
                    laststr := _ReadString(Cur.Line,Cur.X,-1);
                    B := _ReadString(ICB.Last.Line,ICB.Last.X,-1);
                    icb1 := _ReadString(ICB.First.Line,ICB.First.X,-1);
                    _ReadWorkLine;
                    SetLength(FWorkLine,Cur.X-1);
                    _WriteString(Cur.X,icb1);
                    _WriteWorkLine;
                     FActLine^.flag := FActLine^.flag Or ciSelected;

                    FActLine := ICB.First.Line;
                    _ReadWorkLine;
                    SetLength(FWorkLine,ICB.First.X-1);
                    _WriteString(ICB.First.X,B);
                    _WriteWorkLine;
                    FActLine^.flag := FActLine^.flag And Not ciSelected;

                    FActLine := ICB.Last.Line;
                    _ReadWorkLine;
                    SetLength(FWorkLine,ICB.Last.X-1);
                    _WriteString(ICB.Last.X,laststr);
                    _WriteWorkLine;

                    CurLinenext := Cur.Line^.Next;
                    ICBFirstLnext := ICB.First.Line^.Next;
                    ICBLastLnext := ICB.Last.Line^.Next;
                    _Connect(Cur.Line,ICBFirstLnext);
                    _Connect(ICB.Last.Line,CurLinenext);
                    _Connect(ICB.First.Line,ICBLastLnext);
                    If CurLinenext = Nil Then FLastLine := ICB.Last.Line;

                    ICB.First := Cur;
                    {Reference Point For _GotoPosition}
                    FFileCursor.Y := 1;
                    FScrCursor.Y := 1;
                    FActLine := FFirstLine;
                    FTopScreenLine := FFirstLine;
               End;
          End;
     End;
     _ICBCheckX;

     If AL < IFL Then fl := _Index2PLine(AL)
     Else fl := _Index2PLine(IFL);
     If AL > ILL Then LL := _Index2PLine(AL)
     Else LL := _Index2PLine(ILL);
     SetLineColorFlag(fl,LL);

     FRedoList.Clear;
     If GetSelectionStart(P) Then
     Begin
          _GotoPosition(P);
          InvalidateEditor(0,0);
     End;
     (*Undo*)
     LastUndoGroup := ugNoGroup;
     (*Undo*)
End;


Procedure TEditor.cmICBDeleteBlock;
Begin
     If ReadOnly Then Exit;
     If Not ICBVisible Then Exit;
     TestAutoSave;
     If _ICBDeleteICB Then
     Begin
          FRedoList.Clear;
          InvalidateEditor(0,0);
     End;
End;


Procedure TEditor.cmICBUpcaseBlock;
Var  SaveAL:PLine;
     X1,x2,I:Integer;
Begin
     If ReadOnly Then Exit;
     If Not _ICBExist Then Exit;
     TestAutoSave;
     FlushWorkLine;
     (*Undo*)
     _CopyUndoLines(ICB.First.Line,ICB.Last.Line);
     LastUndoGroup := ugNoGroup;
     (*Undo*)
     SaveAL := FActLine;
     FActLine := ICB.First.Line;

     X1 := ICB.First.X;
     x2 := ICB.Last.X-1;
     While FActLine <> ICB.Last.Line Do
     Begin
          _ReadWorkLine;

          If FSelectMode <> smColumnBlock Then x2 := Length(FWorkLine);
          For I := X1 To x2 Do begin
            //FWorkLine[I] := UpCase(FWorkLine[I]);
            CharUpperCase (RunInAnsi, FWorkLine[I]);
          end;
          If FSelectMode <> smColumnBlock Then X1 := 1;

          _WriteWorkLine;
          FActLine := FActLine^.Next;
     End;

     x2 := ICB.Last.X-1;
     _ReadWorkLine;
     For I := X1 To x2 Do begin
       //FWorkLine[I] := UpCase(FWorkLine[I]);
       CharUpperCase (RunInAnsi, FWorkLine[I]);
     end;
     _WriteWorkLine;

     FActLine := SaveAL;
     Modified := True;
     FRedoList.Clear;
     InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBLowcaseBlock;
Var  SaveAL:PLine;
     X1,x2,I:Integer;
Begin
     If ReadOnly Then Exit;
     If Not _ICBExist Then Exit;
     TestAutoSave;
     FlushWorkLine;
     (*Undo*)
     _CopyUndoLines(ICB.First.Line,ICB.Last.Line);
     LastUndoGroup := ugNoGroup;
     (*Undo*)
     SaveAL := FActLine;
     FActLine := ICB.First.Line;

     X1 := ICB.First.X;
     x2 := ICB.Last.X-1;
     While FActLine <> ICB.Last.Line Do
     Begin
          _ReadWorkLine;

          If FSelectMode <> smColumnBlock Then x2 := Length(FWorkLine);
          For I := X1 To x2 Do begin
            CharLowerCase (RunInAnsi, FWorkLine[I]);
            //If FWorkLine[I] In ['A'..'Z','é','ô','ö']
            //Then FWorkLine[I] := Chr(Ord(FWorkLine[I]) Or $20);
          end;
          If FSelectMode <> smColumnBlock Then X1 := 1;

          _WriteWorkLine;
          FActLine := FActLine^.Next;
     End;

     x2 := ICB.Last.X-1;
     _ReadWorkLine;
     For I := X1 To x2 Do begin
       //If FWorkLine[I] In ['A'..'Z','é','ô','ö']
       //Then FWorkLine[I] := Chr(Ord(FWorkLine[I]) Or $20);
       CharLowerCase (RunInAnsi, FWorkLine[I]);
     end;
     _WriteWorkLine;

     FActLine := SaveAL;
     Modified := True;
     FRedoList.Clear;
     InvalidateEditor(0,0);
End;


Procedure TEditor.cmICBUpcaseWord;
Var  lzk:LongInt;
     X:Integer;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;
     (*Undo*)
     _CopyUndoLines(FActLine,FActLine);
     LastUndoGroup := ugNoGroup;
     (*Undo*)

     If Not WLactivated Then _ReadWorkLine;
     lzk := Length(FWorkLine);
     X := FFileCursor.X;
     While (NormalChar[RunInAnsi, FWorkLine[X-1]]) And (X > 1) Do Dec(X);
     While (NormalChar[RunInAnsi, FWorkLine[X]]) And (X <= lzk) Do
     Begin
          {Martin}CharUpperCase (RunInAnsi, FWorkLine[X]);
          Inc(X);
     End;
     _WriteWorkLine;

     Modified := True;
     FRedoList.Clear;
     InvalidateWorkLine;
End;

{Martin}
procedure CharLowerCase (Ansi : boolean; var C : char);
  begin
    if Ansi then begin
      if C in ['A'..'Z', #192..#221] then C := char(ord(C)+$20);
    end
    else begin
      case C of
        {This is the table for OEM codepage!}
        'A'..'Z': C := Char(Ord(C) + $20);
        'é' : C := 'Ñ';
        'ô' : C := 'î';
        'ö' : C := 'Å';
        'Ä' : C := 'á';
        'ê' : C := 'Ç';
        '∂' : C := 'É';
        'Ö' : C := 'Ö';
        'è' : C := 'Ü';
        '“' : C := 'à';
        '”' : C := 'â';
        '‘' : C := 'ä';
        'ÿ' : C := 'ã';
        '◊' : C := 'å';
        'ﬁ' : C := 'ç';
        '‚' : C := 'ì';
        '„' : C := 'ï';
        'Í' : C := 'ñ';
        //'' : C := 'ò';
        'ù' : C := 'õ';
        'í' : C := 'ë';
        'µ' : C := '†';
        '÷' : C := '°';
        '‡' : C := '¢';
        'È' : C := '£';
        '•' : C := '§';
        '«' : C := '∆';
        'Â' : C := '‰';
        'Î' : C := 'ó';
        'Ì' : C := 'Ï';
      end;{case}
    end;
  end;

{Martin}
procedure CharUpperCase (Ansi : boolean; var C : char);
  var
    upC, loC : char;

  begin
    if Ansi then begin
      if C in ['a'..'z', #224..#253] then C := char(ord(C)-$20);
    end
    else begin
      if (C >= 'a') and (C <= 'z') then C := char(ord(C)-$20)
      else if ord(C) > 127 then begin
        for upC := #128 to #255 do begin
          loC := upC; CharLowercase (Ansi, loC);
          if (C = loC) and (loC <> upC) then begin
            C := upC; break;
          end;
        end;
      end;
    end;
  end;


Procedure TEditor.cmICBLowcaseWord;
Var  lzk:LongInt;
     X:Integer;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;
     (*Undo*)
     _CopyUndoLines(FActLine,FActLine);
     LastUndoGroup := ugNoGroup;
     (*Undo*)

     If Not WLactivated Then _ReadWorkLine;
     lzk := Length(FWorkLine);
     X := FFileCursor.X;
     While (NormalChar[RunInAnsi, FWorkLine[X-1]]) And (X > 1) Do Dec(X);
     While (NormalChar[RunInAnsi, FWorkLine[X]]) And (X <= lzk) Do
     Begin
          {Martin}CharLowerCase (RunInAnsi, FWorkLine[X]);
          Inc(X);
     End;
     _WriteWorkLine;

     Modified := True;
     FRedoList.Clear;
     InvalidateWorkLine;
End;


Procedure TEditor.cmToggleCase;
Var  X:Integer;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;
     (*Undo*)
     _CopyUndoLines(FActLine,FActLine);
     LastUndoGroup := ugNoGroup;
     (*Undo*)

     If Not WLactivated Then _ReadWorkLine;
     X := FFileCursor.X;
     If FWorkLine[X] In ['A'..'Z','é','ô','ö']
     Then FWorkLine[X] := Chr(Ord(FWorkLine[X]) Or $20)
     Else FWorkLine[X] := UpCase(FWorkLine[X]);
     _WriteWorkLine;
     If X <= Length(FWorkLine) Then cmCursorRight;

     Modified := True;
     FRedoList.Clear;
     InvalidateWorkLine;
End;


Procedure TEditor.cmBreakLine;
Var  newstring:String;
     ip:TICBPosition;
     FCX:Integer;
     AL:PLine;
     iew:Boolean;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;
     (*Undo*)
     _CopyUndoLines(FActLine,FActLine);
     (*Undo*)
     If Not WLactivated Then _ReadWorkLine;

     If FFileCursor.X > Length(FWorkLine) Then newstring := ''
     Else newstring := _ReadString(FActLine,FFileCursor.X,-1);
     SetLength(FWorkLine,FFileCursor.X-1);
     _WriteWorkLine;

     _InsertLine(FActLine);
     {Update ICB}
     ip := _ICBPos(FActLine,FFileCursor.X);
     FCX := FFileCursor.X;
     AL := FActLine;
     If FSelectMode <> smColumnBlock Then
     Begin
          If ip * [ipBeforeICBFirst] <> [] Then
          Begin
               AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
               AL^.flag := AL^.flag And Not ciSelected;
               Dec(ICB.First.X,FCX-1);
               ICB.First.Line := ICB.First.Line^.Next;
          End;
          If ip * [ipBeforeICBLast] <> [] Then
          Begin
               AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
               Dec(ICB.Last.X,FCX-1);
               ICB.Last.Line := ICB.Last.Line^.Next;
          End;
          If ip * [ipAfterICBFirst,ipWithinICB] <> []
          Then AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
          If ip * [ipAfterICBLast] <> []
          Then AL^.Next^.flag := AL^.Next^.flag And Not ciSelected;
          _ICBCheckX;
     End
     Else  {Extended Selection}
     Begin
          If ip * [ipBeforeICBFirst,ipAfterICBFirst,ipWithinICB] <> [] Then
            If ip * [ipBeforeICBLast,ipAfterICBLast] = []
            Then AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
     End;

     FActLine := FActLine^.Next;
     FWorkLine := newstring;
     _WriteWorkLine;

     FActLine := FActLine^.Prev;
     If Length(newstring) = 0 Then iew := _CursorEnd
     Else iew := False;

     SetLineColorFlag(FActLine,FActLine^.Next);
     FRedoList.Clear;
     If ((FScrCursor.Y = FWinSize.Y) And (FScrCursor.Y > 1)) Then
     Begin
          Dec(FScrCursor.Y);
          FTopScreenLine := FTopScreenLine^.Next;
          InvalidateEditor(0,0);
     End
     Else
     Begin
          If iew Then InvalidateEditor(0,0)
          Else InvalidateEditor(FScrCursor.Y,0);
     End;
     SetSliderValues;
     (*Undo*)
     _UpdateLastUndoEvent(FUndoList,_PLine2Index(FActLine^.Next^.Next));
     LastUndoGroup := ugBreakLine;
     (*Undo*)
End;


Procedure TEditor.cmDeleteLine;
Var  NextLine:PLine;
     prevline:PLine;
     ip:TICBPosition;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;

     ip := _ICBPos(FActLine,0);
     NextLine := FActLine^.Next;

     If NextLine <> Nil Then
     Begin
          If FTopScreenLine = FActLine Then FTopScreenLine := NextLine;
          prevline := FActLine^.Prev;
          (*Undo*)
          _MoveUndoLines(FUndoList,FActLine,FActLine);
          _Connect(prevline,NextLine);
          _UpdateLastUndoEvent(FUndoList,_PLine2Index(NextLine));
          Dec(FCountLines);
          (*Undo*)
          SetSliderValues;
          FActLine := NextLine;
          WLactivated := False;
     End
     Else
     Begin
          (*Undo*)
          _CopyUndoLines(FActLine,FActLine);
          If Not WLactivated Then _ReadWorkLine;
          (*Undo*)
          FWorkLine := '';
     End;

     If ip * [ipBeforeICBFirst,ipAfterICBFirst] <> [] Then
     Begin
          If NextLine <> Nil Then ICB.First.Line := NextLine;
          If FSelectMode <> smColumnBlock Then ICB.First.X := 1;
     End;
     If ip * [ipBeforeICBLast,ipAfterICBLast] <> [] Then
     Begin
          If NextLine <> Nil Then ICB.Last.Line := NextLine;
          If FSelectMode <> smColumnBlock Then ICB.Last.X := 1;
     End;
     _ICBSetMark;

     _HorizMove;
     FFileCursor.X := 1;
     FScrCursor.X := 1;
     Modified := True;
     If FActLine^.Prev <> Nil Then UpdateLineColorFlag(FActLine^.Prev)
     Else UpdateLineColorFlag(FActLine);
     FRedoList.Clear;
     If _HorizMove Then InvalidateEditor(0,0)
     Else InvalidateEditor(FScrCursor.Y,0);
     (*Undo*)
     LastUndoGroup := ugDeleteActLine;
     (*Undo*)
End;


Procedure TEditor.cmDeleteLineEnd;
Var  ip:TICBPosition;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;
     (*Undo*)
     _CopyUndoLines(FActLine,FActLine);
     (*Undo*)
     Modified := True;
     If Not WLactivated Then _ReadWorkLine;
     SetLength(FWorkLine,FFileCursor.X-1);
     _WriteWorkLine;
     If FSelectMode <> smColumnBlock Then
     Begin
          ip := _ICBPos(FActLine,FFileCursor.X);
          If ip * [ipBeforeICBFirst] <> [] Then ICB.First.X := FFileCursor.X;
          If ip * [ipBeforeICBLast] <> [] Then ICB.Last.X := FFileCursor.X;
          _ICBCheckX;
     End;
     FRedoList.Clear;
     InvalidateWorkLine;
     (*Undo*)
     LastUndoGroup := ugNoGroup;
     (*Undo*)
End;


Procedure TEditor.cmDeleteRightWord;
Var  CX:Integer;
     newstring:String;
     ip:TICBPosition;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;
     If Not WLactivated Then _ReadWorkLine;
     CX := 0;
     If FFileCursor.X <= Length(FWorkLine) Then
     Begin
          (*Undo*)
          _CopyUndoLines(FActLine,FActLine);
          (*Undo*)
          If Not WLactivated Then _ReadWorkLine;
          While (NormalChar[RunInAnsi, FWorkLine[FFileCursor.X+CX]]) And
                (FFileCursor.X+CX <= Length(FWorkLine)) Do Inc(CX);
          {Martin}
          if DeleteRightWordCount > 0 then CX := DeleteRightWordCount
          else begin
            If CX = 0 Then CX := 1;
            While (FWorkLine[FFileCursor.X+CX] = ' ') And
                  (FFileCursor.X+CX <= Length(FWorkLine)) Do Inc(CX);
          end;
          _DeleteString(FFileCursor.X,CX);
          _WriteWorkLine;
          If FSelectMode <> smColumnBlock Then
          Begin
               ip := _ICBPos(FActLine,FFileCursor.X);
               If ip * [ipBeforeICBFirst] <> [] Then
               Begin
                    If ICB.First.X-FFileCursor.X < CX
                    Then ICB.First.X := FFileCursor.X
                    Else Dec(ICB.First.X,CX);
               End;
               If ip * [ipBeforeICBLast] <> [] Then
               Begin
                    If ICB.Last.X-FFileCursor.X < CX
                    Then ICB.Last.X := FFileCursor.X
                    Else Dec(ICB.Last.X,CX);
               End;
               _ICBCheckX;
          End;
          FRedoList.Clear;
          InvalidateWorkLine;
          (*Undo*)
          LastUndoGroup := ugDeleteRightWord;
          (*Undo*)
     End
     Else
     Begin
          If FActLine^.Next = Nil Then Exit;
          If FFileCursor.X + Length(FActLine^.Next^.zk^) <= StringLength Then
          Begin
               (*Undo*)
               _CopyUndoLines(FActLine,FActLine^.Next);
               _UpdateLastUndoEvent(FUndoList,_PLine2Index(FActLine^.Next));
               (*Undo*)
               If Not WLactivated Then _ReadWorkLine;
               SetLength(FWorkLine,FFileCursor.X-1);
               CX := 1;
               While (FActLine^.Next^.zk^[CX] = ' ') And
                     (CX <= Length(FActLine^.Next^.zk^)) Do Inc(CX);
               newstring := _ReadString(FActLine^.Next,CX,-1);
               _WriteString(FFileCursor.X,newstring);
               Dec(CX);                {CX Count Of deletable ' '}
               ip := _ICBPos(FActLine^.Next,0);
               If ip * [ipBeforeICBFirst,ipAfterICBFirst] <> [] Then
               Begin
                    ICB.First.Line := FActLine;
                    If FSelectMode <> smColumnBlock Then
                    Begin
                         Inc(ICB.First.X,FFileCursor.X-1);
                         If ICB.First.X-FFileCursor.X < CX
                         Then ICB.First.X := FFileCursor.X
                         Else Dec(ICB.First.X,CX);
                    End;
                    FActLine^.flag := FActLine^.flag Or
                                     (FActLine^.Next^.flag And ciSelected);
               End;
               If ip * [ipBeforeICBLast,ipAfterICBLast] <> [] Then
               Begin
                    ICB.Last.Line := FActLine;
                    If FSelectMode <> smColumnBlock Then
                    Begin
                         Inc(ICB.Last.X,FFileCursor.X-1);
                         If ICB.Last.X-FFileCursor.X < CX
                         Then ICB.Last.X := FFileCursor.X
                         Else Dec(ICB.Last.X,CX);
                    End;
                    FActLine^.flag := FActLine^.flag Or
                                     (FActLine^.Next^.flag And ciSelected);
               End;
               _ICBCheckX;
               _DeleteLine(FActLine^.Next);
               SetSliderValues;
               UpdateLineColorFlag(FActLine);
               FRedoList.Clear;
               InvalidateEditor(FScrCursor.Y,0);
               (*Undo*)
               LastUndoGroup := ugNoGroup;
               (*Undo*)
          End
          Else SetErrorMessage(LoadNLSStr(SLineWouldBeTooLong)+'.');
     End;
End;


Procedure TEditor.cmDeleteLeftWord;
Var  CX:Integer;
     ip:TICBPosition;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;
     If Not WLactivated Then _ReadWorkLine;
     If FFileCursor.X > 1 Then
     Begin
          (*Undo*)
          _CopyUndoLines(FActLine,FActLine);
          (*Undo*)
          If Not WLactivated Then _ReadWorkLine;
          CX := FFileCursor.X;
          While Not (NormalChar[RunInAnsi, FWorkLine[CX-1]]) And (CX > 1) Do Dec(CX);
          While (NormalChar[RunInAnsi, FWorkLine[CX-1]]) And (CX > 1) Do Dec(CX);
          _DeleteString(CX,FFileCursor.X - CX);
          _WriteWorkLine;
          If FSelectMode <> smColumnBlock Then
          Begin
               ip := _ICBPos(FActLine,FFileCursor.X);
               If ip * [ipBeforeICBFirst] <> []
               Then Dec(ICB.First.X,FFileCursor.X - CX);
               If ip * [ipBeforeICBLast] <> []
               Then Dec(ICB.Last.X,FFileCursor.X - CX);
               _ICBCheckX;
          End;
          FRedoList.Clear;
          If _GotoPosition(EditorPos(FFileCursor.Y,CX))
          Then InvalidateEditor(0,0)
          Else InvalidateWorkLine;
          (*Undo*)
          LastUndoGroup := ugDeleteRightWord;
          (*Undo*)
     End;
End;


function tEditor.TabulatorRelatedLine : PLine; {Martin1107}
  begin
    result := FActLine^.Prev;
  end;

Procedure TEditor.cmTabulator;
Var  P,I,cnt:Integer;
     emptystring:String;
     ip:TICBPosition;
     iew:Boolean;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;

     If _ICBOverwrite Then iew := _ICBDeleteICB
     Else iew := False;
     (*Undo*)
     _CopyUndoLines(FActLine,FActLine);
     (*Undo*)
     If FEditOpt * [eoSmartTabs] <> [] Then
     Begin
          P := _FindNextTab((*FActLine^.Prev*)TabulatorRelatedLine,FFileCursor.X+1); {Search from FCX+1}
          cnt := P - FFileCursor.X;
     End
     Else
     Begin
          P := _FindNextTab(Nil,FFileCursor.X+1); {Search from FCX+1}
          cnt := P - FFileCursor.X;
     End;

     emptystring := '';
     For I := 1 To cnt Do emptystring := emptystring + ' ';
     If Not _InsertString(FFileCursor.X,emptystring) Then Beep(1000,10);
     If FSelectMode <> smColumnBlock Then
     Begin
          ip := _ICBPos(FActLine,FFileCursor.X);
          If ip * [ipBeforeICBFirst] <> []  Then Inc(ICB.First.X,cnt);
          If ip * [ipBeforeICBLast] <> [] Then Inc(ICB.Last.X,cnt);
          _ICBCheckX;
     End;

     _HorizMove;
     FFileCursor.X := P;
     If FScrCursor.X+cnt <= FWinSize.X Then Inc(FScrCursor.X,cnt)
     Else FScrCursor.X := 3*(FWinSize.X Div 4)+1;


     FRedoList.Clear;
     If _HorizMove Or iew Then
     Begin
          UpdateLineColorFlag(FActLine);
          InvalidateEditor(0,0);
     End
     Else InvalidateWorkLine;
     (*Undo*)
     LastUndoGroup := ugTabulator;
     (*Undo*)
End;


Procedure TEditor.cmPrevTabulator;
Var  iew:Boolean;
     P:TEditorPos;
Begin
     If FFileCursor.X = 1 Then Exit;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     P := FFileCursor;
     P.X := ((P.X-1) Div FTabSize * FTabSize) +1;
     iew := _GotoPosition(P);
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Procedure TEditor.cmDeleteChar;
Var  newstring:String;
     lpl,lwl:Integer;
     ip:TICBPosition;
     CountDel:Integer;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;

     If _ICBOverwrite And _ICBExist Then
     Begin
          cmICBDeleteBlock;
          Exit;
     End;

     If Not WLactivated Then _ReadWorkLine;
     If FFileCursor.X > Length(FWorkLine) Then
     Begin
          If FActLine^.Next = Nil Then Exit;
          (*Undo*)
          _CopyUndoLines(FActLine,FActLine^.Next);
          _UpdateLastUndoEvent(FUndoList,_PLine2Index(FActLine^.Next));
          (*Undo*)
          If Not WLactivated Then _ReadWorkLine;
          lpl := Length(FActLine^.Next^.zk^);
          If lpl + FFileCursor.X <= StringLength Then
          Begin
               ip := _ICBPos(FActLine^.Next,0);
               If ip * [ipBeforeICBFirst,ipAfterICBFirst] <> [] Then
               Begin
                    ICB.First.Line := FActLine;
                    If FSelectMode <> smColumnBlock
                    Then Inc(ICB.First.X,FFileCursor.X-1);
                    If FActLine^.Next^.flag And ciSelected <> 0
                    Then FActLine^.flag := FActLine^.flag Or ciSelected;
               End;
               If ip * [ipBeforeICBLast,ipAfterICBLast] <> [] Then
               Begin
                    ICB.Last.Line := FActLine;
                    If FSelectMode <> smColumnBlock
                    Then Inc(ICB.Last.X,FFileCursor.X-1);
               End;
               _ICBCheckX;
               lwl := Length(FWorkLine);
               FillChar(FWorkLine[lwl+1],FFileCursor.X-lwl-1,32);
               newstring := _ReadString(FActLine^.Next,1,lpl);
               {Martin}DeleteIndent (FActLine^.Next,newstring);
               _WriteString(FFileCursor.X,newstring);
               {Martin}UseNextReturnflag (FActLine);
               _DeleteLine(FActLine^.Next);

               SetSliderValues;
               UpdateLineColorFlag(FActLine);
               FRedoList.Clear;
               InvalidateEditor(FScrCursor.Y,0);
               (*Undo*)
               LastUndoGroup := ugNoGroup;
               (*Undo*)
          End
          Else SetErrorMessage(LoadNLSStr(SLineWouldBeTooLong)+'.');
     End
     Else
     Begin
          (*Undo*)
          If LastUndoGroup <> ugDeleteChar Then _CopyUndoLines(FActLine,FActLine);
          (*Undo*)

          CountDel := 1;
          If Application.DBCSSystem Then
          Begin {Delete 2 chars If the Cursor Is ON the 1st Byte Of A dbcs Char}
               If QueryDBCSFirstByte(FWorkLine, FFileCursor.X) Then CountDel := 2;
          End;

          If FSelectMode <> smColumnBlock Then
          Begin
               ip := _ICBPos(FActLine,FFileCursor.X);
               If ip * [ipBeforeICBFirst] <> [] Then Dec(ICB.First.X, CountDel);
               If ip * [ipBeforeICBLast] <> [] Then Dec(ICB.Last.X, CountDel);
               _ICBCheckX;
          End;
          _DeleteString(FFileCursor.X, CountDel);
          FRedoList.Clear;
          InvalidateWorkLine;
          (*Undo*)
          LastUndoGroup := ugDeleteChar;
          (*Undo*)
     End;
End;


Procedure TEditor.cmBackSpace;
Var  prevline:PLine;
     ptline:PLine;
     oldstring:String;
     lpl:Integer;
     ip:TICBPosition;
     CountDel:Integer;
     FNT:Integer;
     iew:Boolean;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;

     If _ICBOverwrite And _ICBExist Then
     Begin
          cmICBDeleteBlock;
          Exit;
     End;

     _HorizMove;
     If FFileCursor.X <= 1 Then
     Begin
          If FActLine^.Prev = Nil Then Exit;
          (*Undo*)
          _CopyUndoLines(FActLine^.Prev,FActLine);
          _UpdateLastUndoEvent(FUndoList,_PLine2Index(FActLine));
          (*Undo*)
          If Not WLactivated Then _ReadWorkLine;
          oldstring := FWorkLine;
          prevline := FActLine^.Prev;
          lpl := Length(prevline^.zk^);
          If lpl + Length(FWorkLine) <= StringLength Then
          Begin
               ip := _ICBPos(FActLine,0);
               If ip * [ipBeforeICBFirst,ipAfterICBFirst] <> [] Then
               Begin
                    ICB.First.Line := prevline;
                    If FSelectMode <> smColumnBlock
                    Then Inc(ICB.First.X,lpl);
                    If FActLine^.flag And ciSelected <> 0
                    Then prevline^.flag := prevline^.flag Or ciSelected;
               End;
               If ip * [ipBeforeICBLast,ipAfterICBLast] <> [] Then
               Begin
                    ICB.Last.Line := prevline;
                    If FSelectMode <> smColumnBlock
                    Then Inc(ICB.Last.X,lpl);
               End;
               _ICBCheckX;
               If FScrCursor.Y > 1 Then Dec(FScrCursor.Y)
               Else FTopScreenLine := prevline;
               Dec(FFileCursor.Y);
               FActLine := prevline;
               _ReadWorkLine;
               iew := _CursorEnd;
               {Martin}DeleteIndent (ActLine, oldstring);
               _WriteString(FFileCursor.X,oldstring);
               _DeleteLine(FActLine^.Next);
               UpdateLineColorFlag(FActLine);
               If _HorizMove Or iew Then InvalidateEditor(0,0)
               Else InvalidateEditor(FScrCursor.Y,0);
               SetSliderValues;
          End
          Else SetErrorMessage(LoadNLSStr(SLineWouldBeTooLong)+'.');
          (*Undo*)
          LastUndoGroup := ugNoGroup;
          (*Undo*)
     End
     Else
     Begin
          (*Undo*)
          If LastUndoGroup <> ugBackspaceChar Then _CopyUndoLines(FActLine,FActLine);
          (*Undo*)

          FlushWorkLine;
          If FEditOpt * [eoUnindent] <> [] Then
          Begin
               If (_FindNextTab(FActLine,1) >= FFileCursor.X) Or
                  (Length(FActLine^.zk^) = 0) Then
               Begin
                    ptline := FActLine;
                    Repeat
                          If ptline^.Prev <> Nil Then
                          Begin
                               ptline := ptline^.Prev;
                               FNT := _FindNextTab(ptline,1);
                          End
                          Else FNT := 1;
                    Until FNT < FFileCursor.X;
                    CountDel := FFileCursor.X-FNT;
               End
               Else
               Begin
                    CountDel := 1;
                    If Application.DBCSSystem Then
                    Begin {Delete 2 chars If the Cursor Is behind the 2nd Byte Of A dbcs Char}
                         If QueryDBCSFirstByte(FActLine^.zk^, FFileCursor.X-2)
                         Then CountDel := 2;
                    End;
               End;
          End
          Else
          Begin
               CountDel := 1;
               If Application.DBCSSystem Then
               Begin {Delete 2 chars If the Cursor Is behind the 2nd Byte Of A dbcs Char}
                    If QueryDBCSFirstByte(FActLine^.zk^, FFileCursor.X-2)
                    Then CountDel := 2;
               End;
          End;

          Dec(FFileCursor.X, CountDel);
          If FSelectMode <> smColumnBlock Then
          Begin
               ip := _ICBPos(FActLine,FFileCursor.X);
               If ip * [ipBeforeICBFirst] <> [] Then
               Begin
                    If ICB.First.X-FFileCursor.X > CountDel
                    Then Dec(ICB.First.X,CountDel)
                    Else ICB.First.X := FFileCursor.X;
               End;
               If ip * [ipBeforeICBLast] <> [] Then
               Begin
                    If ICB.Last.X-FFileCursor.X > CountDel
                    Then Dec(ICB.Last.X,CountDel)
                    Else ICB.Last.X := FFileCursor.X;
               End;
          End;
          _DeleteString(FFileCursor.X,CountDel);
          FRedoList.Clear;
          If FScrCursor.X <= CountDel Then
          Begin
               FScrCursor.X := 1;
               UpdateLineColorFlag(FActLine);
               InvalidateEditor(0,0);
          End
          Else
          Begin
               Dec(FScrCursor.X,CountDel);
               InvalidateWorkLine;
          End;
          (*Undo*)
          LastUndoGroup := ugBackspaceChar;
          (*Undo*)
     End;
End;


Procedure TEditor.cmEnter;
Var  newstring:String;
     emptystring:String;
     I:Integer;
     FNT:Integer;
     NCX:Integer;
     ip:TICBPosition;
     FCX:Integer;
     AL:PLine;
     iew:Boolean;
Begin
     If ReadOnly Then Exit;
     TestAutoSave;

     If _ICBOverwrite Then iew := _ICBDeleteICB
     Else iew := False;

     (*Undo*)
     _CopyUndoLines(FActLine,FActLine);
     (*Undo*)
     If Not WLactivated Then _ReadWorkLine;

     If FFileCursor.X <= Length(FWorkLine) Then
     Begin
          newstring := _ReadString(FActLine,FFileCursor.X,-1);
          SetLength(FWorkLine,FFileCursor.X-1);
     End
     Else newstring := '';
     _WriteWorkLine;

     _HorizMove;
     _InsertLine(FActLine);
     ip := _ICBPos(FActLine,FFileCursor.X);
     FCX := FFileCursor.X;
     AL := FActLine;
     FActLine := FActLine^.Next;
     If FEditOpt * [eoAutoIndent] <> [] Then
     Begin
          emptystring := '';
          If Length(FActLine^.Prev^.zk^) = 0 Then FNT := FFileCursor.X
          Else
          Begin
               FNT := 1;
               While (FActLine^.Prev^.zk^[FNT] = ' ') And
                     (FNT <= Length(FActLine^.Prev^.zk^)) Do Inc(FNT);
          End;
          For I := 1 To FNT-1 Do emptystring := emptystring + ' ';
          FWorkLine := emptystring + newstring;
          _WriteWorkLine;

          If Length(FActLine^.Prev^.zk^) = 0 Then NCX := _FindNextTab(FActLine,1)
          Else NCX := _FindNextTab(FActLine^.Prev,1);
          FFileCursor.X := NCX;
          FScrCursor.X := NCX;
          If FScrCursor.X > FWinSize.X Then FScrCursor.X := FWinSize.X;
     End
     Else
     Begin
          FFileCursor.X := 1;
          FScrCursor.X := 1;
          FWorkLine := newstring;
          _WriteWorkLine;
          FNT := 1;
     End;
     {Update ICB}
     If FSelectMode <> smColumnBlock Then
     Begin
          If ip * [ipBeforeICBFirst] <> [] Then
          Begin
               AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
               AL^.flag := AL^.flag And Not ciSelected;
               Dec(ICB.First.X,FCX-1);
               Inc(ICB.First.X,FNT-1);
               ICB.First.Line := ICB.First.Line^.Next;
          End;
          If ip * [ipBeforeICBLast] <> [] Then
          Begin
               AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
               Dec(ICB.Last.X,FCX-1);
               Inc(ICB.Last.X,FNT-1);
               ICB.Last.Line := ICB.Last.Line^.Next;
          End;
          If ip * [ipAfterICBFirst,ipWithinICB] <> []
          Then AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
          If ip * [ipAfterICBLast] <> []
          Then AL^.Next^.flag := AL^.Next^.flag And Not ciSelected;
          _ICBCheckX;
     End
     Else  {Extended Selection}
     Begin
          If ip * [ipBeforeICBFirst,ipAfterICBFirst,ipWithinICB] <> [] Then
            If ip * [ipBeforeICBLast,ipAfterICBLast] = []
            Then AL^.Next^.flag := AL^.Next^.flag Or (AL^.flag And ciSelected);
     End;

     Inc(FFileCursor.Y);
     SetLineColorFlag(FActLine^.Prev,FActLine);
     FRedoList.Clear;
     If FScrCursor.Y = FWinSize.Y Then
     Begin
          FTopScreenLine := FTopScreenLine^.Next;
          InvalidateEditor(0,0);
     End
     Else
     Begin
          Inc(FScrCursor.Y);
          If _HorizMove Or iew Then InvalidateEditor(0,0)
          Else InvalidateEditor(FScrCursor.Y-1,0);
     End;
     SetSliderValues;
     (*Undo*)
     _UpdateLastUndoEvent(FUndoList,_PLine2Index(FActLine^.Next));
     LastUndoGroup := ugEnter;
     (*Undo*)
End;



Procedure TEditor.CutToClipBoard;
Var  P:Pointer;
     len:LongInt;
Begin
     If ReadOnly Then Exit;
     If Not Selected Then Exit;
     TestAutoSave;
     If _GetEditorBlock(P,len) Then     {including terminal #0}
     Begin
          If _SetClipBoardText(P,len) Then
          Begin
               FRedoList.Clear;
               If _ICBDeleteICB Then InvalidateEditor(0,0);
          End;
          FreeMem(P,len);
     End;
End;


Procedure TEditor.CopyToClipboard;
Var  P:Pointer;
     len:LongInt;
Begin
     If Not Selected Then Exit;
     If _GetEditorBlock(P,len) Then     {including terminal #0}
     Begin
          _SetClipBoardText(P,len);
          FreeMem(P,len);
     End;
End;


Function TEditor.PasteFromClipBoard:Boolean;
Var  P:Pointer;
     len:LongInt;
Begin
     Result := False;
     If ReadOnly Then Exit;
     TestAutoSave;

     Result := _GetClipBoardText(P,len);
     If Result And (len > 0) Then
     Begin
          If _ICBOverwrite Then _ICBDeleteICB;

          InsertText(P,len-1);    {without terminal #0}
          FreeMem(P,len);
     End;
End;


Function TEditor.InsertFromFile(Const FName:String):Boolean;
Var  P:Pointer;
     len:LongInt;
Begin
     Result := False;
     If ReadOnly Then Exit;
     TestAutoSave;

     Result := _GetFileText(FName,P,len);
     If Result And (len > 0) Then
     Begin
          If _ICBOverwrite Then _ICBDeleteICB;

          InsertText(P,len-1);    {without terminal #0}
          FreeMem(P,len);
     End;
End;


Function TEditor.GetReadOnly:Boolean;
Begin
     Result := FReadOnly;
End;


Procedure TEditor.SetReadOnly(Value:Boolean);
Begin
     FReadOnly := Value;
End;


Procedure TEditor.SetModified(Value:Boolean);
Begin
     FModified := Value;
End;

{Martin2}Procedure TEditor.SetRunInAnsi (AnsiCP:Boolean);
Begin
     {only in Win32 there are Codepages for both IBM (OEM) and ANSI Codepage available}
     if not AnsiCP then begin
       {$IFDEF Win32}
       Font := Screen.GetFontFromPointSize ('Terminal', 20);{Terminal is a IBM (OEM) Font}
       {$ENDIF}
     end
     else begin
       {$IFDEF Win32}
       Font := Screen.FixedFont;{ANSI Font}
       {$ENDIF}
     end;
     FrunInAnsi := AnsiCP;
End;


{Show actual State Of the Editor}
Procedure TEditor.UpdateEditorState;
Begin
End;


{Use This method To Show additional State information; E.G. State Text}
{$HINTS OFF}
Procedure TEditor.SetStateMessage(Const S:String);
Begin
End;
{$HINTS ON}

{Handle an Error Message}
Procedure TEditor.SetErrorMessage(Const S:String);
Begin
     MessageBox(S,mtError,[mbOk]);
     Focus;
End;


{Handle A Query from the Editor}
Function TEditor.SetQueryMessage(Const S:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Begin
     Result := MessageBox(S,Typ,Buttons);
     Focus;
End;


{Handle A Confirm Query from the Editor}
Function TEditor.SetReplaceConfirmMessage:TMsgDlgReturn;
Var  Dlg:TMessageBox;
     pt:TPoint;
Begin
     BringToFront;
     If Application <> Nil Then Dlg.Create(Application.MainForm)
     Else Dlg.Create(Nil);
     Dlg.Message := LoadNLSStr(SReplaceThisString);
     Dlg.Buttons := mbYesNoCancel;
     Dlg.DlgType := mtInformation;
     Dlg.XAlign := xaNone;
     Dlg.YAlign := yaNone;
     Dlg.XStretch := xsFixed;
     Dlg.YStretch := ysFixed;
     Dlg.Width := 350;
     Dlg.Height := 130;
     pt := GetMouseFromCursor(FScrCursor);
     pt := ClientToScreen(pt); {pt Is the lower Left corner Of the Selection}
     If pt.Y > Dlg.Height Then Dec(pt.Y, Dlg.Height)
     Else Inc(pt.Y, Canvas.FontHeight);
     If pt.X + Dlg.Width > Screen.Width Then pt.X := Screen.Width - Dlg.Width;
     Dlg.Left := pt.X;
     Dlg.Bottom := pt.Y;

     Dlg.Execute;
     Case Dlg.ModalResult Of
       cmYes:Result := mrYes;
       cmNo: Result := mrNo;
       Else  Result := mrCancel;
     End;
     Dlg.Destroy;
End;


{Handle the FileName And the Caption Of the Editor Window}
Procedure TEditor.SetFileName(Const FName:String);
Begin
     If FFileName <> FName Then
     Begin
          FileNameChange(FFileName,FName);
     End;
     FFileName := FName;
End;


{Use This method To Update the color flag Of an Editor Line}
{$HINTS OFF}
Function TEditor.UpdateLineColorFlag(pl:PLine):Boolean;
Begin
     Result := False;
End;


{Use This method To Update the color flag Of Editor Lines}
Procedure TEditor.SetLineColorFlag(pl1,pl2:PLine);
Begin
End;
{$HINTS ON}

{Martin}
procedure TEditor.DefineLineColors (pl:PLine;Var LineColor:TColorArray; Var LineAtt : tAttributeArray; First, Last : integer);
  var
    I : longint;
Begin
     For I := First To Last Do
     Begin
          LineColor[I].Fgc := fgcPlainText;
          LineColor[I].Bgc := bgcPlainText;
          LineAtt[I] := [];
     End;
End;

{Set the color values For the current Output Line}
Procedure TEditor.CalcLineColor(pl:PLine;Var LineColor:TColorArray; Var LineAtt : tAttributeArray);
Var  I:Integer;
     SelBegin:Integer;
     SelEnd:Integer;
     ac,acend:Integer;
Begin
     ac := FFileCursor.X-FScrCursor.X+1;
     acend := ac+FWinSize.X-1;
     {Martin0705}if acend > StringLength then acend := StringLength;
     {Martin}
     DefineLineColors (pl, LineColor, LineAtt, ac, acend);

     If pl = Nil Then Exit;

     If FindICB.First.Line = Nil Then     {Test normal Selection}
     Begin
          If (pl^.flag And ciSelected = 0) Then Exit;
          If Not ICBVisible Then Exit;

          If FSelectMode <> smColumnBlock Then
          Begin
               If ICB.First.Line = pl Then SelBegin := ICB.First.X
               Else SelBegin := 1;
               If ICB.Last.Line = pl Then SelEnd := ICB.Last.X-1
               Else SelEnd := acend;

               If FKeyMap = kmCUA Then
               Begin
                    I := Length(_PLine2PString(pl)^) +1;
                    If I < SelEnd Then SelEnd := I;
               End;
          End
          Else {Extended Selection}
          Begin
               If ICB.First.X = ICB.Last.X Then Exit;
               If ICB.First.X < ICB.Last.X Then
               Begin
                    SelBegin := ICB.First.X;
                    SelEnd := ICB.Last.X-1;
               End
               Else
               Begin
                    SelBegin := ICB.Last.X;
                    SelEnd := ICB.First.X-1;
               End;
          End;

          If SelBegin > acend Then Exit;
          If SelEnd > acend Then SelEnd := acend;

          For I := SelBegin To SelEnd Do
          Begin
               LineColor[I].Fgc := fgcMarkedBlock;
               LineColor[I].Bgc := bgcMarkedBlock;
          End;
     End
     Else  {Test Find Text block}
     Begin
          If FindICB.First.Line <> pl Then Exit;
          SelBegin := FindICB.First.X;
          SelEnd := FindICB.Last.X-1;

          If SelBegin > acend Then Exit;
          If SelEnd > acend Then SelEnd := acend;

          For I := SelBegin To SelEnd Do
          Begin
               LineColor[I].Fgc := fgcSearchMatch;
               LineColor[I].Bgc := bgcSearchMatch;
          End;
     End;
End;


Procedure ReplaceDBCSChars(Var S:String; maxchars:LongInt);
Var  I:LongInt;
Begin
     If maxchars > Length(S) Then maxchars := Length(S);
     For I := 1 To maxchars Do
     Begin
          {$IFDEF OS2}
          If IsDBCSFirstByte(S[I]) Then
          Begin
               S[I] := ' ';
               Inc(I);   {onto Second Byte}
               S[I] := ' ';
          End;
          {$ENDIF}
     End;
End;


Procedure ReplaceBoundingDBCSChars(Var S:String; First,Last:LongInt);
Var  I:LongInt;
     DBCS1stByte:Boolean;
Begin
     If Last > Length(S) Then Last := Length(S);
     DBCS1stByte := False;
     For I := 1 To Last Do
     Begin
          {$IFDEF OS2}
          DBCS1stByte := IsDBCSFirstByte(S[I]);
          {$ENDIF}
          {$IFDEF Win32}
          DBCS1stByte := False;
          {$ENDIF}

          If I = First-1 Then
          Begin
               {If First Is the Second Byte Of A dbcs Char - dont Draw it}
               If DBCS1stByte Then S[First] := ' ';
          End;

          If I = Last Then
          Begin
               {If Last Is the First Byte Of A dbcs Char - dont Draw it}
               If DBCS1stByte Then S[Last] := ' ';
          End;

          If DBCS1stByte Then Inc(I);
     End;
End;


{Redraw the specified Line In the Editor Window}
Procedure TEditor.InvalidateScreenLine(ScrY:Integer);
Var  pl:PLine;
     X,Y:LongInt;
     ac:Integer;
     I,W:Integer;
     Count:Integer;
     ps:Integer;
     S:String;
     los:Integer;
     Max : integer;{Martin}
     LineColor:TColorArray;
     LineAtt:TAttributeArray;
     OutputString:String;
     XLeft:LongInt;
     PenColorIndex:LongInt;
     BrushColorIndex:LongInt;
     AttIndex : tFontAttributes;
     LineHasItalic, IsItalic, GetItalic : boolean;

  procedure ItalicRect (Left, Width : longint);
    var
      Rect : tRect;
    begin
      Rect.Left := Left; Rect.Right := Left + Width;
      Rect.Bottom := Y; Rect.Top := Y + Canvas.FontHeight-1;
      Canvas.FillRect (Rect, Canvas.Brush.Color);//clGreen);
    end;

Begin
     If Handle = 0 Then Exit;
     pl := FTopScreenLine;
     For I := 2 To ScrY Do
        If pl <> Nil Then pl := pl^.Next;

     CalcLineColor(pl,LineColor, LineAtt);

     If pl <> Nil Then OutputString := _PLine2PString(pl)^
     Else OutputString := '';

     ac := FFileCursor.X-FScrCursor.X+1;    {1st Char In Window}

     If Application.DBCSSystem Then
     Begin
          If IsDBCSFont Then
          Begin
               {Test If 1st Or Last character In the belong To A dbcs Char}
               ReplaceBoundingDBCSChars(OutputString,ac,ac+FWinSize.X-1);
          End
          Else
          Begin
               {replace All non-printable dbcs characters}
               ReplaceDBCSChars(OutputString,ac+FWinSize.X-1);
          End;
     End;

     los := Length(OutputString);
     {Martin}Max := ac+FWinSize.X-1;
     if Max > StringLength then Max := StringLength;
     For I := los+1 To Max Do OutputString[I] := #32;
     SetLength(OutputString,Max);

     {Martin: attribute support added}
     PenColorIndex := LineColor[ac].Fgc;
     BrushColorIndex := LineColor[ac].Bgc;
     AttIndex := LineAtt[ac];
     Canvas.Pen.color := ColorEntry[PenColorIndex];
     Canvas.Brush.color := ColorEntry[BrushColorIndex];
     if FontAttributesEnabled then Canvas.FontAttributes := AttIndex;

     Count := 0;
     ps := 0;
     XLeft := FBorderWidth + IndentRect.Left;
     if FontAttributesEnabled then inc (XLeft);{because italic needs more space}
     Y := ClientArea.Top {$ifdef win32}+1{$endif} - (ScrY*Canvas.FontHeight) -
          IndentRect.Top - FBorderWidth;

     if FontAttributesEnabled then begin
       LineHasItalic := false;
       for I := ac to Max do if LineAtt[I]*[faItalic] <> [] then begin
         LineHasItalic := true;
         break;
       end;
       (*
       if LineHasItalic then begin
         {draw the complete background of the line because of missing triangles while redrawing
          when changing attribute from normal to italic}
         Rect.Left := XLeft; Rect.Right := ClientWidth;
         Rect.Bottom := Y; Rect.Top := Y + Canvas.FontHeight-1;
         Canvas.FillRect (Rect, Color);
       end;
       *)
     end;

     For I := ac To Max Do
     Begin
            If (PenColorIndex <> LineColor[I].Fgc) Or (BrushColorIndex <> LineColor[I].Bgc) or
               (FontAttributesEnabled and (AttIndex <> LineAtt[I])) Or
               {Problem: if a font is bold or italic, the width of the characters is slightly different,
                so there's the need of justifying each single character}
               (FontAttributesEnabled and (AttIndex*[faBold,faItalic] <> [])) Then
            Begin
                 X := XLeft + ps*Canvas.FontWidth;
                 S := Copy(OutputString,ps+ac,Count);
                 if FontAttributesEnabled then begin {Martin0206}
                   IsItalic := AttIndex*[faItalic] <> [];
                   GetItalic := LineAtt[I]*[faItalic] <> [];
                   {erstes Zeichen in sichtbarer Zeile Italic Rechteck malen; erstes Zeichen um eins nach rechts}
                   if IsItalic and (I = ac) then begin
                     ItalicRect (XLeft, Font.Width div 2);
                   end;
                   {beim öbergang von Italic auf Normal mu· beim letzten Zeichen ein Dreieck werden, das sonst leer bleibt}
                   {Dreieck kann auch ein Rechteck sein, rechte untere Ecke wird dann eh Åberschrieben}
                   if IsItalic and (not GetItalic) then
                     ItalicRect (XLeft + ps*Canvas.FontWidth + Canvas.FontWidth div 2, Font.Width div 2);
                 end;
                 Canvas.TextOut(X,Y,S);
                 Inc(ps,Count);
                 Count := 1;
                 PenColorIndex := LineColor[I].Fgc;
                 BrushColorIndex := LineColor[I].Bgc;
                 if FontAttributesEnabled then begin {Martin0206}
                   {beim öbergang von Normal auf Italic mu· ein Dreieck gezeichnet werden, das sonst leer bleibt}
                   {Dreieck kann auch ein Rechteck sein, rechte untere Ecke wird dann eh Åberschrieben}
                   if (not IsItalic) and GetItalic then
                     ItalicRect (XLeft + ps*Canvas.FontWidth, Canvas.FontWidth);
                 end;
                 AttIndex := LineAtt[I];
                 Canvas.Pen.color := ColorEntry[PenColorIndex];
                 Canvas.Brush.color := ColorEntry[BrushColorIndex];
                 if FontAttributesEnabled then Canvas.FontAttributes := AttIndex;
            End
            Else Inc(Count);
     End;
     If (Count <> 0) Then
     Begin
          X := XLeft+ps*Canvas.FontWidth;
          S := Copy(OutputString,ps+ac,Count);
          Canvas.TextOut(X,Y,S);
     End;


     {Martin} {write spaces if window size > 255 chars}
     for I := Max+1 to ac+FWinSize.X-1 do begin
       Canvas.Brush.Color := clWhite;
       S := ' ';
       X := XLeft+(Max+ps)*Canvas.FontWidth;
       Canvas.Textout (X, Y, S);
       inc (ps);
     end;

     {WordWrap Line}
     WrapLineX := -1;
     If FWordWrap Then
       If ((FWordWrapColumn > ac) And (FWordWrapColumn < ac+FWinSize.X)) Or
          (FWordWrapColumn = 0) Then
     Begin
          If FWordWrapColumn = 0 Then W := FWinSize.X-1
          Else W := FWordWrapColumn - (FFileCursor.X - FScrCursor.X);
          XLeft := FBorderWidth+IndentRect.Left;
          WrapLineX := XLeft + W * Canvas.FontWidth;
          Canvas.Pen.color := ColorEntry[fgcRightMargin];
          Canvas.MoveTo(WrapLineX,Y);
          Inc(Y, Canvas.FontHeight-1);
          Canvas.LineTo(WrapLineX,Y);
     End;
End;


{Redraw the current Cursor Line}
Procedure TEditor.InvalidateWorkLine;
Begin
     If Not UpdateLineColorFlag(FActLine) Then
     Begin
          If IgnoreRedraw > 0 Then Exit;
          FCaret.Hide;
          InvalidateScreenLine(FScrCursor.Y);
          SetScreenCursor;
          FCaret.Show;
     End
     Else InvalidateEditor(FScrCursor.Y,0);
End;


{Redraw the Lines In the Editor Window from Line y1 To Line y2}
Procedure TEditor.InvalidateEditor(y1,y2:Integer);
Var  I:Integer;
     Y:LongInt;
     OldWrapLineX:Integer;
Begin
     If Handle = 0 Then Exit;
     If IgnoreRedraw > 0 Then Exit;
     OldWrapLineX := WrapLineX;



     (*if (y1 = 0) and (y2 = 0) then begin
       Beep (2000, 50);
     end;*)


     If y1 < 1 Then y1 := 1;
     If y2 < 1 Then y2 := FWinSize.Y;
     If y2 > FWinSize.Y Then y2 := FWinSize.Y;
     SetSliderPosition;
     FCaret.Hide;
     For I := y1 To y2 Do InvalidateScreenLine(I);

     If OldWrapLineX > 0 Then
     Begin
          Canvas.Pen.color := ColorEntry[bgcPlainText];
          Y := ClientArea.Top -1;
          Y := Y - Integer(FBorderWidth);
          Canvas.MoveTo(OldWrapLineX,Y);
          Y := Y - IndentRect.Top;
          Canvas.LineTo(OldWrapLineX,Y);

          Y := Y - (FWinSize.Y * Canvas.FontHeight) +2;
          Canvas.MoveTo(OldWrapLineX,Y);
          Y := Integer(FBorderWidth);
          Canvas.LineTo(OldWrapLineX,Y);
     End;
     If WrapLineX > 0 Then
     Begin
          Canvas.Pen.color := ColorEntry[fgcRightMargin];
          Y := ClientArea.Top -1 -Integer(FBorderWidth);
          Canvas.MoveTo(WrapLineX,Y);
          Y := Y -IndentRect.Top;
          Canvas.LineTo(WrapLineX,Y);

          Y := Y - (FWinSize.Y * Canvas.FontHeight) +2;
          Canvas.MoveTo(WrapLineX,Y);
          Y := Integer(FBorderWidth);
          Canvas.LineTo(WrapLineX,Y);
     End;

     SetScreenCursor;
     FCaret.Show;
End;


{Redraw All Lines And the indent borders In the Editor Window}
Procedure TEditor.Redraw(Const rc:TRect);
Var  rec:TRect;
     FrameWidth:Integer;
Begin
     If Canvas=Nil Then exit;
     
     {Martin2}Canvas.NoConvertTextout := True;

     Canvas.ClipRect := rc;
     FrameWidth := Integer(FBorderWidth);

     rec := ClientArea;
     rec.Top := rec.Top-(FWinSize.Y*Canvas.FontHeight+IndentRect.Top)+1;
     Dec(rec.Top,FrameWidth);
     Inc(rec.Bottom,FrameWidth);
     Inc(rec.Left,FrameWidth);
     Dec(rec.Right,FrameWidth);
     Canvas.FillRect(rec,ColorEntry[bgcPlainText]);       {Bottom}

     rec := ClientArea;
     rec.Bottom := rec.Top-IndentRect.Top;
     Inc(rec.Left,FrameWidth);
     Dec(rec.Right,FrameWidth);
     Dec(rec.Bottom,FrameWidth);
     Dec(rec.Top,FrameWidth);
     Canvas.FillRect(rec,ColorEntry[bgcPlainText]);       {Top}

     rec := ClientArea;
     rec.Right := IndentRect.Left;
     Inc(rec.Right,FrameWidth);
     Inc(rec.Bottom,FrameWidth);
     Inc(rec.Left,FrameWidth);
     Dec(rec.Top,FrameWidth);
     Canvas.FillRect(rec,ColorEntry[bgcPlainText]);       {Left}

     rec := ClientArea;
     rec.Left := FWinSize.X*Canvas.FontWidth+IndentRect.Left;
     Inc(rec.Left,FrameWidth);
     Inc(rec.Bottom,FrameWidth);
     Dec(rec.Right,FrameWidth);
     Dec(rec.Top,FrameWidth);
     Canvas.FillRect(rec,ColorEntry[bgcPlainText]);       {Right}

     rec := ClientArea;
     Dec(rec.Right);
     Dec(rec.Top);
     If FCtl3D Then
     Begin
          Canvas.ShadowedBorder(rec,clDkGray,clWhite);
          InflateRect(rec,-1,-1);
          Canvas.ShadowedBorder(rec,clBlack,clLtGray);
     End
     Else Canvas.ShadowedBorder(rec,clBlack,clBlack);

     InvalidateEditor(0,0);
     Canvas.DeleteClipRegion;
End;


Procedure TEditor.SetScreenCursor;
Var  pt:TPoint;
     W:LongInt;
     ps:PString;
Begin
     pt := GetMouseFromCursor(FScrCursor);
     If HadFocus > 0 Then FCaret.SetPos(pt.X,pt.Y);
     UpdateEditorState;

     If Application.DBCSSystem Then
     Begin {Make sure, that the Caret has the same Width like the Char below}
          If (FCursorShape = csVertical) And FInsertMode Then Exit;

          ps := _PLine2PString(FActLine);
          If QueryDBCSFirstByte(ps^, FFileCursor.X) Then W := 2 * Canvas.FontWidth
          Else W := Canvas.FontWidth;

          If FCaret.Width <> W Then
          Begin
               FCaret.Remove;
               FCaret.SetSize(W, FCaret.Height);
               If HadFocus > 0 Then FCaret.Show;
          End;
     End;
End;


Function TEditor.QueryConvertPos(Var Pos:TPoint):Boolean;
Begin
     Pos := GetMouseFromCursor(FScrCursor);
     Result := True;
End;


Procedure TEditor.BeginUpdate;
Begin
     Inc(IgnoreRedraw);
End;


Procedure TEditor.EndUpdate;
Begin
     Dec(IgnoreRedraw);
     If IgnoreRedraw <= 0 Then
     Begin
          IgnoreRedraw := 0;
          InvalidateEditor(0,0);
          SetSliderValues;
     End;
End;


Procedure TEditor.SetupComponent;
  var
    Ch, LoCh, UpCh : char;
    Ansi : boolean;
Begin
     Inherited SetupComponent;

     FHeapgroupID := GetNewHeapgroupID;

     DBCSStatusLine := True;
     {Martin}
     FontAttributesEnabled := false;
     ConvertShiftCtrlChar2CtrlChar := false;{default Sibyl IDE}
     TopPanel := nil;
     ScrollBars := ssBoth;
     FCaret.Create(Self);
     FOldCaption := '';
     FFirstLine := Nil;
     FLastLine := Nil;
     _InsertLine(Nil);
     FActLine := FFirstLine;
     FTopScreenLine := FActLine;
     FFileName := '';
     IndentRect.Top := 3;
     IndentRect.Left := 3;
     (*IndentRect.Right := 3 + Screen.SystemMetrics(smCxVScroll);
     IndentRect.Bottom := 3 + Screen.SystemMetrics(smCyHScroll);*)
     IndentRect.Right := 3 + goSysInfo.Screen.VScrollSize;
     IndentRect.Bottom := 3 + goSysInfo.Screen.HScrollSize;
     FWinSize.Y := 0;
     FWinSize.X := 0;
     FFileCursor.X := 1;
     FFileCursor.Y := 1;
     FScrCursor.X := 1;
     FScrCursor.Y := 1;
     TabSize := 8;
     IgnoreRedraw := 0;
     WLactivated := True;
     Untitled := True;
     Modified := False;
     ICBVisible := True;
     FWorkLine := '';
     ICB.First.Line := Nil;
     ICB.First.X := 0;
     ICB.Last.Line := Nil;
     ICB.Last.X := 0;
     FEditOpt := [eoCreateBackups,eoUndoGroups,eoAutoIndent,eoUnindent,
                  eoPersistentBlocks,eoSmartTabs];
     FKeyMap := kmWordStar;
     FInsertMode := True;
     FReadOnly := False;
     MaxUndo := 128;
     FUndoList.Create;
     FUndoList.OnFreeItem := _FreeUndoEvent;
     FRedoList.Create;
     FRedoList.OnFreeItem := _FreeUndoEvent;
     KeyRepeat := 1;
     FPreCtrl := 0;
     HadFocus := 0;
     FFind.Find := '';
     FFind.replace := '';
     FFind.Direction := fdForward;
     FFind.Origin := foEntireScope;
     FFind.Scope := fsGlobal;
     FFind.Options := [];
     FFind.FindHistory := nil;
     FFind.ReplaceHistory := nil;
     FFindReplace := FFind;{Martin0206}
     FLastFind := faNothing;
     IncSearchList.Create;
     IncSearchText := '';
     FindICB.First.Line := Nil;
     fMask := '*.*';

     PenColor := clBlack;
     Color := clWhite;
     FSelColor := Color;
     FSelBackColor := PenColor;
     FFoundColor := FSelColor;
     FFoundBackColor := FSelBackColor;
     FWrapLineColor := clLtGray;
     Font := Screen.FixedFont;
     FSaveEvents := -1;
     FWordWrap := False;
     FWordWrapColumn := 0;
     WrapLineX := -1;
     FCtl3D := True;
     FMacroList := Nil;
     FRecording := False;
     FPlaying := False;
     FCursorShape := csUnderline;
     SelectMode := smNonInclusiveBlock;
     {Martin2}
     {$IFDEF OS2}
     FLoadSaveAsAnsi := False; FRunInAnsi := False;
     {$ELSEIF}
     FLoadSaveAsAnsi := True; FRunInAnsi := True;
     {$ENDIF}

     DragMode := dmAutomatic;
     DragCursor := crIBeam;

     {Martin}
     DeleteRightWordCount := 0;
     AdditionalUndo := false;

    {Martin}
    for Ansi := false to true do for Ch := #0 to #255 do begin
      LoCh := Ch; UpCh := Ch;
      CharLowerCase (Ansi, LoCh); CharUpperCase (Ansi, UpCh);
      {all characters which exists in lower and upper char state are "normal characters"; don't forget digits}
      NormalChar[Ansi, Ch] := (LoCh <> UpCh) or ((Ch >= '0') and (Ch <= '9'));
    end;
    {irregular chars:}
    NormalChar[{OEM}false, '·'] := true;
    NormalChar[{ANSI}true, #223] := true;
End;


Procedure TEditor.SetupShow;
Begin
     Inherited SetupShow;

     FBottomScrollBar := HorzScrollBar;
     FRightScrollBar := VertScrollBar;

     CalcSizes;
     Cursor := crIBeam;
     CursorShape := FCursorShape;
     FEventsCounter := FSaveEvents;
     {Martin0505}MouseX := 0; MouseY := 0;
End;


// OEM <-> Ansi Conversion  ///////////////////////////////////////////

Procedure ConvertToAnsi(Ptr:PCharArray;len:LongInt);
Var  i:LongInt;
Begin
     For i := 1 To len Do
     Begin
          Ptr^ := OemToAnsiTable[Char(Ptr^)];
          inc(Ptr);
     End;
End;


Procedure ConvertToOEM(Ptr:PCharArray;len:LongInt);
Var  i:LongInt;
Begin
     For i := 1 To len Do
     Begin
          Ptr^ := AnsiToOemTable[Char(Ptr^)];
          inc(Ptr);
     End;
End;

{Martin2}
procedure ConvertStringToOEM (var St : string);
var  i : byte;
Begin
     for i := 1 To length(St) do St[i] := AnsiToOemTable[St[i]];
End;

procedure ConvertStringToANSI (var St : string);
var  i : byte;
Begin
     for i := 1 To length(St) do St[i] := OemToAnsiTable[St[i]];
End;

///////////////////////////////////////////////////////////////////////


Function TEditor.LoadFromStream(Stream:TStream):Boolean;
Var  P:Pointer;
     len:LongInt;
Begin
     Result := False;
     If FReadOnly Then Exit;  {F!}
     SetStateMessage(LoadNLSStr(SLoading));

     Cursor := crHourGlass;
     Stream.Position := 0;
     len := Stream.Size;
     GetMem(P,len);
     Stream.ReadBuffer(P^,len);
     Result := True;
     If Result And (len > 0) Then
     Begin
          If _ICBOverwrite Then _ICBDeleteICB;

            (*    do convert only Files !
            {Martin2}
            if (not RunInAnsi) and LoadSaveAsAnsi then ConvertToOEM(PCharArray(P),len);
            if RunInAnsi and (not LoadSaveAsAnsi) then ConvertToAnsi(PCharArray(P),len);
            *)

          _InsertText(P,len-1, False);    {without terminal #0}
          FreeMem(P,len);
     End;
     Cursor := crDefault;

     SetStateMessage('');
     FUndoList.Clear;
     FRedoList.Clear;
     Untitled := False;
     Modified := False;
     InvalidateEditor(0,0);
End;


Function TEditor.LoadFromFile(Const FName:String):Boolean;
Var  P:Pointer;
     len:LongInt;
     S:String;
Begin
     Result := False;
     If FReadOnly Then Exit;  {F!}
     S := FExpand(FName);
     SetStateMessage(LoadNLSStr(SLoading) + S);

     SetFileName(S);

     Cursor := crHourGlass;

     Result := _GetFileText(S,P,len);
     If Result And (len > 0) Then
     Begin
          If _ICBOverwrite Then _ICBDeleteICB;

          _InsertText(P,len-1, False);    {without terminal #0}
          FreeMem(P,len);
     End;
     Cursor := crDefault;
     SetStateMessage('');
     FUndoList.Clear;
     FRedoList.Clear;
     Untitled := False;
     Modified := False;
     InvalidateEditor(0,0);
End;


{$HINTS OFF}
Procedure TEditor.SetAvailabeFileTypes(CFOD:{$ifdef os2}TOpenDialog{$else}TSystemOpenSaveDialog{$endif});
Begin
End;
{$HINTS ON}


Function TEditor.SaveToStream(Stream:TStream):Boolean;
Var Ptr:^LongWord;
    len:LongInt;
Begin
     SetStateMessage(LoadNLSStr(SSaving));
     If _GetEditorText(Ptr,len) Then
     Begin

          (*{Martin2}   do convert only files!
          if (not RunInAnsi) and LoadSaveAsAnsi then ConvertToAnsi(PCharArray(Ptr),len);
          if RunInAnsi and (not LoadSaveAsAnsi) then ConvertToOEM(PCharArray(Ptr),len);*)

          Stream.WriteBuffer(Ptr^,len);
          FreeMem(Ptr,len);
     End
     Else Result:=False;
     SetStateMessage('');
     UpdateEditorState;
End;


{Martin 29.12.99
WÑhrend die Funktion textfile -> textbuffer in _GetFileText sauber gekapselt ist,
ist die andere Richtung zweimal extra programmiert, und zwar in SaveToFile und
cmICBWriteBlock. Das gehîrt natÅrlich auch in eine eigene Procedure _WriteFileText
}
function TEditor._WriteFileText (S : String; Var P:Pointer; Var len:LongInt):Boolean;
  var
    utF : file;
     Begin
          result := false;
          if len >= 0{Martin0207} then begin
            {Martin2}
            if len > 0 then begin
              if (not RunInAnsi) and LoadSaveAsAnsi then ConvertToAnsi(PCharArray(P),len);
              if RunInAnsi and (not LoadSaveAsAnsi) then ConvertToOEM(PCharArray(P),len);
              ConvertFileWrite (P, len); {Martin: this can hold conversion routines, like converting to Unix Returns, but is empty here}
            end;
            System.Assign(utF,S);
            {$I-}
            Rewrite(utF,1);
            {$I+}
            If InOutRes <> 0 Then
            Begin
                 SetStateMessage('');
                 SetErrorMessage(LoadNLSStr(SErrorWriting)+': '+ S);
                 Cursor := crDefault;
                 Exit;
            End;

            if len > 0 then begin
              {$I-}
              BlockWrite(utF,P^,len-1);  {without terminating #0}
              {$I+}
              FreeMem(P,len);
            end;
            If InOutRes <> 0 Then
            Begin
                 {$I-}
                 System.Close(utF);
                 {$I+}
                 SetStateMessage('');
                 SetErrorMessage(LoadNLSStr(SErrorWriting)+': '+ S);
                 Cursor := crDefault;
                 Exit;
            End
            else result := true;
          end
          else
            result := false;
          {$I-}
          System.Close(utF);
          {$I+}
     End;


Function TEditor.SaveToFile(Const FName:String):Boolean;
Var  utF,eF:File;
     Ptr:^LongWord;
     len:LongInt;
     //IoR:Integer;
     BackupName:String;
     D,N,E:String;
Begin
     Result := False;

     SetStateMessage(LoadNLSStr(SSaving) + FName);
     Cursor := crHourGlass;
     If FEditOpt * [eoCreateBackups] <> [] Then
     Begin
          If FEditOpt * [eoAppendBAK] = [] Then
          Begin
               FSplit(FName,D,N,E);
               BackupName := D + N + '.BAK';
          End
          Else BackupName := FName + '.BAK';
          //Dialogs.Messagebox ('Backupname: ' + FName, mtInformation, [mbOK]);


          {Martin 0106: FileExists instead of reset/IOresult}
          if FileExists (FName) then begin
            System.Assign(eF,BackupName);
            System.Assign(utF,FName);
            {$I-}
            Erase(eF);
            Rename(utF,BackupName);
            {$I+}
          End;

          (*
          //old Code:
          System.Assign(utF,FName);
          {$I-}
          Reset(utF);
          IoR := InOutRes;
          System.Close(utF);
          {$I+}
          If IoR = 0 Then
          Begin
               System.Assign(eF,BackupName);
               {$I-}
               Erase(eF);
               Rename(utF,BackupName);
               {$I+}
          End;
          *)
     End;

     {Martin} If _GetEditorText(Ptr,len) or (len = 0){Martin1106} Then begin
       result{Martin1105} := _WriteFileText (FName, Ptr, len);
     end;

     Cursor := crDefault;
     Untitled := False;
     Modified := False;
     SetStateMessage('');
     UpdateEditorState;
     FEventsCounter := FSaveEvents;

     SetFileName(FName);
     //Result := True;{Martin1105}
End;


Function TEditor.SaveFile:Boolean;
Var  FName:String;
     //CFSD:TSaveDialog;
     CFSD:{$ifdef os2}TSaveDialog{$else}TSystemSaveDialog{$endif};
     ret:Boolean;
Begin
     Result := False;

     If Untitled Then
     Begin
          CFSD.Create(Self);
          {Martin}{$ifdef os2}{=Sibyl OpenDialog} if Application.Mainform = Self then CFSD.Font := Screen.SmallFont;{$endif}
          CFSD.Title := LoadNLSStr(SSaveFileAs);
          CFSD.FileName := FileName;
          CFSD.DefaultExt := GetDefaultExt(fMask);
          SetAvailabeFileTypes(CFSD);

          ret := CFSD.Execute;
          FName := CFSD.FileName;
          CFSD.Destroy;
          If Not ret Then Exit;

          Case TestSaveAsName(FName) Of
            mrNo:
            Begin {because Of CloseQuery}
                 Result := True;
                 Exit;
            End;
            mrCancel: Exit;
          End;
     End
     Else FName := FileName;


     If SaveToFile(FName) Then Result := True;
End;


Function TEditor.SaveFileAs(Const FName:String):Boolean;
Var  S:String;
Begin
     Result := False;
     S := FExpand(FName);

     Case TestSaveAsName(S) Of
       mrNo:
       Begin {because Of CloseQuery}
            Result := True;
            Exit;
       End;
       mrCancel: Exit;
     End;

     If SaveToFile(S) Then Result := True;
End;


Function TEditor.TestFileWriteName(Const FName:String):TMsgDlgReturn;
Var  Text:String;
Begin
     If FileExists(FName) Then
     Begin
          Text := FmtLoadNLSStr(SAlreadyExistsOverwrite,[FName]);
          Result := SetQueryMessage(Text,mtWarning,mbYesNoCancel);
     End
     Else Result := mrYes;
End;

Function TEditor.TestSaveAsName(Const FName:String):TMsgDlgReturn;
Begin
     result := TestFileWriteName (FName);
End;


{$HINTS OFF}
Procedure TEditor.FileNameChange(Const OldName,NewName:String);
Begin
End;
{$HINTS ON}


Procedure TEditor.TestAutoSave;
Begin
     If FEditOpt * [eoAutoSave] = [] Then Exit;
     If FSaveEvents <= 0 Then Exit;
     If FEventsCounter <= 0 Then
     Begin
          If Not Untitled Then SaveFile;
          FEventsCounter := FSaveEvents;
     End
     Else Dec(FEventsCounter);
End;


Procedure TEditor.SetSaveEvents(cnt:Integer);
Begin
     FSaveEvents := cnt;
     FEventsCounter := cnt;
End;


Procedure TEditor.SetLastUndoGroup(ug:TUndoGroup);
Var  U:PUndo;
Begin
     If FUndoList = Nil Then Exit;
     If FUndoList.Count = 0 Then Exit;
     U := FUndoList.Last;
     If U = Nil Then Exit;
     U^.EventType := ug;
End;


Function TEditor.GetLastUndoGroup:TUndoGroup;
Var  U:PUndo;
Begin
     Result := ugNoGroup;
     If FUndoList = Nil Then Exit;
     If FUndoList.Count = 0 Then Exit;
     U := FUndoList.Last;
     If U = Nil Then Exit;
     Result := U^.EventType;
End;


Procedure TEditor.SetCtl3D(Value:Boolean);
Begin
     If Value Then FBorderWidth := 2
     Else FBorderWidth := 1;

     If Handle <> 0 Then
     Begin
          CalcSizes;
          Invalidate;
     End;
End;


Procedure TEditor.SetColorEntry(ColorIndex:Integer;NewColor:TColor);
Begin
     NewColor := SysColorToRGB(NewColor);
     {$IFDEF Win32}
     If NewColor = $00CCCCCC Then NewColor := clLtGray;
     {$ENDIF}

     Case ColorIndex Of
        fgcPlainText:    PenColor := NewColor;
        bgcPlainText:    color := NewColor;
        fgcMarkedBlock:  FSelColor := NewColor;
        bgcMarkedBlock:  FSelBackColor := NewColor;
        fgcSearchMatch:  FFoundColor := NewColor;
        bgcSearchMatch:  FFoundBackColor := NewColor;
        fgcRightMargin:  FWrapLineColor := NewColor;
        Else Exit;
     End;
     If Not (ColorIndex In [fgcPlainText,bgcPlainText]) Then Invalidate;
End;


Function TEditor.GetColorEntry(ColorIndex:Integer):TColor;
Begin
     Case ColorIndex Of
        fgcPlainText:    Result := PenColor;
        bgcPlainText:    Result := color;
        fgcMarkedBlock:  Result := FSelColor;
        bgcMarkedBlock:  Result := FSelBackColor;
        fgcSearchMatch:  Result := FFoundColor;
        bgcSearchMatch:  Result := FFoundBackColor;
        fgcRightMargin:  Result := FWrapLineColor;
        Else Result := color;
     End;
End;


Function TEditor.InsertLine(Y:LongInt;Const S:String):LongInt;
Var  pl,NewL,SaveAL:PLine;
Begin
     Result := -1;
     If ReadOnly Then Exit;
     TestAutoSave;
     FlushWorkLine;
     If Y < 1 Then Y := 1;
     If Y > FCountLines Then
     Begin
          Y := FCountLines +1;
          pl := FLastLine;
     End
     Else pl := _Index2PLine(Y-1);
     Result := Y;

     (*Undo*)
     If pl <> Nil Then _CopyUndoLines(pl,pl)
     Else _MoveUndoLines(FUndoList,pl,pl);
     (*Undo*)

     NewL := _InsertLine(pl);
     SaveAL := FActLine;
     FActLine := NewL;
     FWorkLine := S;
     _WriteWorkLine;
     FActLine := SaveAL;

     If Y <= FFileCursor.Y Then                            {Y before FCY}
     Begin
          If Y > FFileCursor.Y - FScrCursor.Y Then          {Y within Screen}
          Begin
               If Y = FFileCursor.Y - FScrCursor.Y +1 Then FTopScreenLine := NewL;

               If FScrCursor.Y >= FWinSize.Y Then
               Begin
                    Dec(FFileCursor.Y);
                    FActLine := FActLine^.Prev;
                    If Not _ICBPersistent Then _ICBClearICB;
               End
               Else Inc(FScrCursor.Y);
          End;
          Inc(FFileCursor.Y);
     End;

     _ICBSetMark;
     SetSliderValues;
     If NewL^.Prev = Nil Then UpdateLineColorFlag(NewL)
     Else SetLineColorFlag(NewL^.Prev,NewL);

     (*Undo*)
     _UpdateLastUndoEvent(FUndoList,_PLine2Index(NewL^.Next));
     LastUndoGroup := ugInsertLine;
     (*Undo*)
     FRedoList.Clear;

     //Beep (1000, 30);
     InvalidateEditor(0,0);
End;


Function TEditor.AppendLine(Const S:String):LongInt;
Begin
     Result := InsertLine(FCountLines+1,S);
End;


Function TEditor.DeleteLine(Y:LongInt):LongInt;
Var  ip:TICBPosition;
     NextLine,prevline,ulcfline:PLine;
     SaveAL:PLine;
Begin
     Result := -1;
     If ReadOnly Then Exit;
     FlushWorkLine;
     If Y < 1 Then Exit;
     If Y > FCountLines Then Exit;
     TestAutoSave;
     Result := Y;

     If FCountLines > 1 Then
     Begin
          SaveAL := FActLine;
          FActLine := _Index2PLine(Y);
          NextLine := FActLine^.Next;
          prevline := FActLine^.Prev;
          ip := _ICBPos(FActLine,0);

          (*Undo*)
          If prevline <> Nil Then _CopyUndoLines(prevline,FActLine)
          Else _CopyUndoLines(FActLine,FActLine);
          _UpdateLastUndoEvent(FUndoList,Y);
          _DeleteLine(FActLine);
          (*Undo*)

          SetSliderValues;
          WLactivated := False;

          If prevline = Nil Then ulcfline := FFirstLine
          Else ulcfline := prevline;

          If ip * [ipBeforeICBFirst,ipAfterICBFirst] <> [] Then
          Begin
               ICB.First.Line := NextLine;
               If FSelectMode <> smColumnBlock Then ICB.First.X := 1;
          End;
          If ip * [ipBeforeICBLast,ipAfterICBLast] <> [] Then
          Begin
               If NextLine <> Nil Then
               Begin
                    ICB.Last.Line := NextLine;
                    If FSelectMode <> smColumnBlock Then ICB.Last.X := 1;
               End
               Else
               Begin
                    ICB.Last.Line := FLastLine;
                    If FSelectMode <> smColumnBlock
                    Then ICB.Last.X := StringLength;
               End;
          End;

          FActLine := SaveAL;
          If Y = FFileCursor.Y Then
          Begin
               If NextLine = Nil Then
               Begin
                    FActLine := FLastLine;
                    FFileCursor.Y := FCountLines;
                    If FScrCursor.Y > 1 Then Dec(FScrCursor.Y);
               End
               Else FActLine := NextLine;
          End
          Else
          If Y < FFileCursor.Y Then
          Begin
               If Y > FFileCursor.Y - FScrCursor.Y Then Dec(FScrCursor.Y);
               Dec(FFileCursor.Y);
          End;

          FTopScreenLine := _Index2PLine(FFileCursor.Y - FScrCursor.Y +1);
     End
     Else
     Begin
          (*Undo*)
          _CopyUndoLines(FActLine,FActLine);
          If Not WLactivated Then _ReadWorkLine;
          (*Undo*)
          FWorkLine := '';
          _WriteWorkLine;
          ulcfline := FActLine;
          FFileCursor.X := 1;
          FScrCursor.X := 1;
          _ICBClearICB;
     End;

     _ICBCheckX;
     _ICBSetMark;
     UpdateLineColorFlag(ulcfline);
     Modified := True;

     (*Undo*)
     LastUndoGroup := ugDeleteLine;
     (*Undo*)
     FRedoList.Clear;

     //Beep (100, 30);
     InvalidateEditor(0,0);
End;


Function TEditor.ReplaceLine(Y:LongInt;Const S:String):LongInt;
Var  pl,SaveAL:PLine;
Begin
     Result := -1;
     If ReadOnly Then Exit;
     FlushWorkLine;
     If Y < 1 Then Exit;
     If Y > FCountLines Then Exit;
     TestAutoSave;
     pl := _Index2PLine(Y);
     If pl = Nil Then Exit;
     Result := Y;
     (*Undo*)
     _CopyUndoLines(pl,pl);
     LastUndoGroup := ugReplaceLine;
     (*Undo*)

     SaveAL := FActLine;
     FActLine := pl;
     _ReadWorkLine;
     FWorkLine := S;
     _WriteWorkLine;
     FActLine := SaveAL;

     _ICBCheckX;
     FRedoList.Clear;
     Modified := True;

     InvalidateEditor (Offsetpos.Y,Offsetpos.Y);

End;

{Martin: same as ReplaceLine, but with Pointer instead of counter}
procedure TEditor.ReplacePLine(Pl : PLine;Const S:String);
Var  SaveAL:PLine;
Begin
     If ReadOnly Then Exit;
     FlushWorkLine;
     TestAutoSave;
     If pl = Nil Then Exit;
     (*Undo*)
     _CopyUndoLines(pl,pl);
     LastUndoGroup := ugReplaceLine;
     (*Undo*)

     SaveAL := FActLine;
     FActLine := pl;
     _ReadWorkLine;
     FWorkLine := S;
     _WriteWorkLine;
     FActLine := SaveAL;

     _ICBCheckX;
     FRedoList.Clear;
     Modified := True;

     InvalidateEditor (Offsetpos.Y,Offsetpos.Y);

End;

Procedure TEditor.ToggleInsertMode;
Begin
     FInsertMode := Not FInsertMode;
     SetInsertMode(FInsertMode);
End;

Procedure tEditor.ToggleSelectMode;
  begin
    if SelectMode = smColumnBlock then
      SelectMode := smNonInclusiveBlock
    else
      SelectMode := smColumnBlock;
  end;

Procedure TEditor.SetSelectionStart(P:TEditorPos);
Begin
     If P.Y < 1 Then P.Y := 1;
     If P.Y > FCountLines Then P.Y := FCountLines;
     If P.X < 1 Then P.X := 1;
     If P.X > StringLength Then P.X := StringLength;

     _ICBSetBegin(_Index2PLine(P.Y), P.X);
     InvalidateEditor(0,0);
End;


Procedure TEditor.SetSelectionEnd(P:TEditorPos);
Begin
     If P.Y < 1 Then P.Y := 1;
     If P.Y > FCountLines Then P.Y := FCountLines;
     If P.X < 1 Then P.X := 1;
     If P.X > StringLength Then P.X := StringLength;

     _ICBSetEnd(_Index2PLine(P.Y), P.X);
     InvalidateEditor(0,0);
End;


Function TEditor.GetSelectionStart(Var P:TEditorPos):Boolean;
Begin
     Result := ICB.First.Line <> Nil;
     If Result Then
     Begin
          P.Y := _PLine2Index(ICB.First.Line);
          P.X := ICB.First.X;
     End
     Else P := FFileCursor;
End;


Function TEditor.GetSelectionEnd(Var P:TEditorPos):Boolean;
Begin
     Result := ICB.Last.Line <> Nil;
     If Result Then
     Begin
          P.Y := _PLine2Index(ICB.Last.Line);
          P.X := ICB.Last.X;
     End
     Else P := FFileCursor;
End;


Procedure TEditor.SelectLine(P:TEditorPos);
Var  pl:PLine;
Begin
     _ICBClearICB;
     pl := _Index2PLine(P.Y);
     If pl <> Nil Then
     Begin
          ICB.First.Line := pl;
          ICB.First.X := 1;
          If (pl^.Next = Nil) Or (FSelectMode = smColumnBlock) Then
          Begin
               ICB.Last.Line := pl;
               ICB.Last.X := Length(_PLine2PString(pl)^);
               Inc(ICB.Last.X);
          End
          Else
          Begin
               ICB.Last.Line := pl^.Next;
               ICB.Last.X := 1;
          End;
          _ICBCheckX;
          _ICBSetMark;
          ICBVisible := True;
     End;
     InvalidateEditor(0,0);
End;


Procedure TEditor.SelectWord(P:TEditorPos);
Var  FCX:Integer;
     pl:PLine;
     zk:PString;
     lzk:LongInt;
Label L;
Begin
     _ICBClearICB;
     pl := _Index2PLine(P.Y);
     If pl = Nil Then Goto L;
     zk := _PLine2PString(pl);
     FCX := P.X;
     lzk := Length(zk^);
     If P.X > lzk Then
     Begin
          If lzk = 0 Then Goto L;
          FCX := lzk;
     End;

     While (NormalChar[RunInAnsi, zk^[FCX-1]]) And (FCX > 1) Do Dec(FCX);
     ICB.First.Line := pl;
     ICB.First.X := FCX;

     While (NormalChar[RunInAnsi, zk^[FCX]]) And (FCX <= lzk) Do Inc(FCX);
     ICB.Last.Line := pl;
     ICB.Last.X := FCX;

     _ICBSetMark;
     ICBVisible := True;
L:
     InvalidateEditor(0,0);
End;


Procedure TEditor.SelectAll;
Var  pl:PLine;
     I:LongInt;
     len:Integer;
Begin
     ICB.First.Line := FFirstLine;
     ICB.First.X := 1;
     ICB.Last.Line := FLastLine;
     If FSelectMode = smColumnBlock Then
     Begin
          ICB.Last.X := 1;
          pl := FFirstLine;
          For I := 1 To CountLines Do
          Begin
               len := Length(_PLine2PString(pl)^);
               If len > ICB.Last.X Then ICB.Last.X := len;
               pl := pl^.Next;
          End;
     End
     Else ICB.Last.X := Length(_PLine2PString(FLastLine)^);
     Inc(ICB.Last.X);
     _ICBCheckX;
     _ICBSetMark;
     ICBVisible := True;
     InvalidateEditor(0,0);
End;


Procedure TEditor.DeselectAll;
Begin
     _ICBClearICB;
     InvalidateEditor(0,0);
End;


Procedure TEditor.HideSelection;
Begin
     ICBVisible := False;
     InvalidateEditor(0,0);
     UpdateEditorState;
End;


Procedure TEditor.ShowSelection;
Begin
     ICBVisible := True;
     InvalidateEditor(0,0);
     UpdateEditorState;
End;


Procedure TEditor.DeleteSelection;
Begin
     cmICBDeleteBlock;
End;


Function TEditor.SetBookMark(I:Byte; P:TEditorPos):Boolean;
Var  pl:PLine;
     BM:LongWord;
Begin
     Result := False;
     If I > 9 Then Exit;
     Inc(I);
     If (P.X < 1) Or (P.X > StringLength) Then Exit;
     If (P.Y < 1) Or (P.Y > FCountLines) Then Exit;
     pl := _FindBookMark(I);
     BM := ciBookMarkMask;
     If pl <> Nil Then pl^.flag := pl^.flag And Not BM;
     pl := _Index2PLine(P.Y);
     If pl = Nil Then Exit;
     pl^.flag := pl^.flag And Not BM;
     BM := I * ciBookMark0;
     pl^.flag := pl^.flag Or BM;
     BookMarkX[I] := P.X;
     InvalidateEditor(0,0);
     Result := True;
End;


Function TEditor.GetBookMark(I:Byte;Var P:TEditorPos):Boolean;
Var  pl:PLine;
Begin
     Result := False;
     If I > 9 Then Exit;
     Inc(I);
     pl := _FindBookMark(I);
     If pl = Nil Then Exit;
     P.Y := _PLine2Index(pl);
     P.X := BookMarkX[I];
     Result := True;
End;


Function TEditor.GotoBookMark(I:Byte):Boolean;
Var  P:TEditorPos;
Begin
     Result := GetBookMark(I,P);
     If Result Then GotoPosition(P);
End;


Function TEditor.ClearBookMark(I:Byte):Boolean;
Var  pl:PLine;
     BM:LongWord;
Begin
     Result := False;
     If I > 9 Then Exit;
     Inc(I);
     pl := _FindBookMark(I);
     If pl = Nil Then Exit;
     BM := ciBookMarkMask;
     pl^.flag := pl^.flag And Not BM;
     InvalidateEditor(0,0);
     Result := True;
End;


Function TEditor.ClearAllBookMarks:Boolean;
Var  pl:PLine;
     BM:LongWord;
Begin
     BM := ciBookMarkMask;
     pl := FFirstLine;
     While pl <> Nil Do
     Begin
          pl^.flag := pl^.flag And Not BM;
          pl := pl^.Next;
     End;
     InvalidateEditor(0,0);
     Result := True;
End;


Procedure TEditor.GotoPosition(Pos:TEditorPos);
Var  iew:Boolean;
Begin
     If Pos.Y < 1 Then Pos.Y := 1;
     If Pos.Y > FCountLines Then Pos.Y := FCountLines;
     If Pos.X < 1 Then Pos.X := 1;
     If Pos.X > StringLength Then Pos.X := StringLength;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _GotoPosition(Pos);
     If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;

Procedure TEditor.GotoPosition_restoreICB (Pos:TEditorPos); {do not delete the block marker}
Var  iew:Boolean;
Begin
     If Pos.Y < 1 Then Pos.Y := 1;
     If Pos.Y > FCountLines Then Pos.Y := FCountLines;
     If Pos.X < 1 Then Pos.X := 1;
     If Pos.X > StringLength Then Pos.X := StringLength;
     (*Undo*)
     If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
     (*Undo*)

     iew := _GotoPosition(Pos);
     //If Not _ICBPersistent Then iew := _ICBClearICB Or iew;

     If iew Then InvalidateEditor(0,0)
     Else SetScreenCursor;
     (*Undo*)
     LastUndoGroup := ugCursorMove;
     (*Undo*)
End;


Function TEditor.GetChar(P:TEditorPos):Char;
Var  zk:PString;
     pl:PLine;
Begin
     Result := ' ';
     pl := _Index2PLine(P.Y);
     If pl = Nil Then Exit;
     zk := _PLine2PString(pl);
     If zk = Nil Then Exit;
     If P.X <= 0 Then P.X := 1;
     If Length(zk^) >= P.X Then Result := zk^[P.X];
End;


Function TEditor.GetWord(P:TEditorPos):String;
Var  Count:Integer;
     zk:PString;
     pl:PLine;
     lzk:LongInt;
Begin
     Result := '';
     pl := _Index2PLine(P.Y);
     If pl = Nil Then Exit;
     zk := _PLine2PString(pl);
     If zk = Nil Then Exit;
     lzk := Length(zk^);
     If P.X > lzk Then P.X := lzk;    {onto Last Char}
     If P.X <= 0 Then P.X := 1;
     While (NormalChar[RunInAnsi, zk^[P.X-1]]) And (P.X > 1) Do Dec(P.X);
     Count := 0;
     While (NormalChar[RunInAnsi, zk^[P.X+Count]]) And (P.X+Count <= lzk) Do Inc(Count);
     Result := Copy(zk^,P.X,Count);
End;


Function TEditor.GetTextAfterWord(P:TEditorPos):String;
Var
     zk:PString;
     pl:PLine;
     lzk:LongInt;
Begin
     Result := '';
     pl := _Index2PLine(P.Y);
     If pl = Nil Then Exit;
     zk := _PLine2PString(pl);
     lzk := Length(zk^);
     While (NormalChar[RunInAnsi, zk^[P.X]]) And (P.X <= lzk) Do Inc(P.X);
     Result := Copy(zk^,P.X,StringLength);
End;


Function TEditor.GetText(Var P:Pointer; Var len:LongInt; Selected:Boolean):Boolean;
Begin
     If Selected Then Result := _GetEditorBlock(P,len)
     Else Result := _GetEditorText(P,len);
End;


Procedure TEditor.InsertText(P:Pointer; len:LongInt);
Var  ActLineNext:PLine;
     Pos:TEditorPos;
     tlx:TLineX;
Begin
     if FSelectMode = smColumnBlock then begin
       _InsertColumnText (P, len);
     end
     else begin
       (*Undo*)
       _CopyUndoLines(FActLine,FActLine);
       ActLineNext := FActLine^.Next;
       (*Undo*)

       tlx := _InsertText(P,len, MarkInsertedText{Martin0106});

       (*Undo*)
       _UpdateLastUndoEvent(FUndoList,_PLine2Index(ActLineNext));
       LastUndoGroup := ugNoGroup;
       (*Undo*)

       If Not _ICBPersistent Then // Goto End Of inserted block
       Begin
            Pos.X := tlx.X;
            Pos.Y := _PLine2Index(tlx.Line);
            If Pos.Y > 0 Then {Martin0106 _ } _GotoPosition(Pos);
       End;

       FRedoList.Clear;
       InvalidateEditor(0,0);
     end;
End;


Function backpos(Const S:String; s1:String):Byte;
Var  I:Byte;
Begin
     I := 0;
     Repeat
           Result := I;
           I := Pos(S,s1);
           s1[I] := #0;
     Until I = 0;
End;


Function TEditor.FindTextPos(Find:String; direct:TFindDirection;
                             Origin:TFindOrigin; Scope:TFindScope;
                             opt:TFindOptions; Var pt:TEditorPos):Boolean;
Const EmptyChar:Char=#1;
Var  icbarea:TICB;
     pl1,pl2:PLine;
     m1,m2:Longint;
     S:String;
Label again;
Begin
     FlushWorkLine;
     Result := False;
     If Find = '' Then Exit;
     If Scope = fsGlobal Then
     Begin
          icbarea.First.Line := FFirstLine;
          icbarea.First.X := 1;
          icbarea.Last.Line := FLastLine;
          icbarea.Last.X := Length(FLastLine^.zk^);
          Inc(icbarea.Last.X);
     End
     Else icbarea := ICB;

     If (icbarea.First.Line = Nil) Or (icbarea.Last.Line = Nil) Then Exit;

     If opt * [foCaseSensitive] = [] Then Find := AnsiUpperCase(Find);

     If direct = fdForward Then
     Begin
          If Origin = foCursor Then
          Begin
               m1 := _PLine2Index(icbarea.First.Line);
               m2 := _PLine2Index(icbarea.Last.Line);
               If FFileCursor.Y > m2 Then Exit;
               If (FFileCursor.Y = m2) And (FFileCursor.X >= icbarea.Last.X) Then Exit;
               If FFileCursor.Y > m1 Then icbarea.First := _ICBActPos;
               If (FFileCursor.Y = m1) And (FFileCursor.X > icbarea.First.X)
               Then icbarea.First.X := FFileCursor.X;
          End;
          pl1 := icbarea.First.Line;
          pl2 := icbarea.Last.Line^.Next;
     End
     Else
     Begin
          If Origin = foCursor Then
          Begin
               m1 := _PLine2Index(icbarea.First.Line);
               m2 := _PLine2Index(icbarea.Last.Line);
               If FFileCursor.Y < m1 Then Exit;
               If (FFileCursor.Y = m1) And (FFileCursor.X < icbarea.First.X) Then Exit;
               If FFileCursor.Y < m2 Then icbarea.Last := _ICBActPos;
               If (FFileCursor.Y = m2) And (FFileCursor.X < icbarea.Last.X)
               Then icbarea.Last.X := FFileCursor.X;
          End;
          pl1 := icbarea.Last.Line;
          pl2 := icbarea.First.Line^.Prev;
     End;

     Result := True;
     While (pl1 <> Nil) And (pl1 <> pl2) Do
     Begin

       if DoSearchLine (pl1) then begin{Martin0308}
          S := pl1^.zk^;
          If (Scope = fsGlobal) Or (FSelectMode <> smColumnBlock) Then
          Begin
               If pl1 = icbarea.First.Line
               Then FillChar(S[1],icbarea.First.X-1, EmptyChar);  {NoANSI}
               If pl1 = icbarea.Last.Line
               Then FillChar(S[icbarea.Last.X], longint(0)+Length(S)-icbarea.Last.X+1, EmptyChar);
          End
          Else {Extended Selection And ICB Search}
          Begin
               FillChar(S[1],icbarea.First.X-1, EmptyChar);  {NoANSI}
               If Length(S) >= icbarea.Last.X
               Then FillChar(S[icbarea.Last.X], longint(0)+Length(S)-icbarea.Last.X+1, EmptyChar);
          End;

          If opt * [foCaseSensitive] = [] Then S := AnsiUpperCase(S);
again:
          If direct = fdForward Then pt.X := Pos(Find,S)
          Else pt.X := backpos(Find,S);

          If opt * [foWordsOnly] <> [] Then CheckWordsOnly(pl1,pt.X,Find);

          If pt.X > 0 Then
          Begin
               pt.Y := _PLine2Index(pl1);
               Exit;
          End;
          If pt.X < 0 Then
          Begin
               S[Abs(pt.X)] := EmptyChar;
               Goto again;
          End;
       end;
       If direct = fdForward Then pl1 := pl1^.Next
       Else pl1 := pl1^.Prev;
     End;
     Result := False;
End;


Procedure TEditor.FindTextDlg;
Begin
     cmFindText;
End;


procedure tEditor.ConvertSpecialChars (var St : string);
  begin
    {will be defined in objects derived from tEditor}
  end;


Function TEditor.FindText({Martin2}(*Const*) Find:String; direct:TFindDirection;
                          Origin:TFindOrigin; Scope:TFindScope;
                          opt:TFindOptions):Boolean;
Var  pt:TEditorPos;
     iew:Boolean;
Begin
     {Martin3}
     ConvertSpecialChars (Find);
     if FRunInAnsi then ConvertStringToANSI (Find);
     If FindTextPos(Find,direct,Origin,Scope,opt, pt) Then
     Begin
          (*Undo*)
          If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
          (*Undo*)
          FindICB.First.Line := _Index2PLine(pt.Y);
          FindICB.First.X := pt.X;
          FindICB.Last := FindICB.First;
          Inc(FindICB.Last.X,Length(Find));
          If direct = fdForward Then pt.X := FindICB.Last.X;
          If FLastFind = faIncSearch Then pt.X := FindICB.First.X;

          iew := _GotoPosition(pt) Or _ICBExist;
          If iew Then InvalidateEditor(0,0)
          Else InvalidateWorkLine;
          (*Undo*)
          LastUndoGroup := ugCursorMove;
          (*Undo*)
          Result := True;
     End
     Else
     Begin
          If FLastFind <> faIncSearch
          Then SetErrorMessage(FmtLoadNLSStr(SSearchStringNotFound,[Find])+'.');
          Result := False;
     End;
     FLastFind := faFind;
End;


Procedure TEditor.ReplaceTextDlg;
Begin
     cmReplaceText;
End;


Function TEditor.ReplaceText({Martin2}(*Const*) Find,replace:String; direct:TFindDirection;
                             Origin:TFindOrigin; Scope:TFindScope; opt:TFindOptions;
                             Confirm:Boolean; replaceall:Boolean):Boolean;
Var  Contin:Boolean;
     found1:Boolean;
     found:Boolean;
     Repl:Boolean;
     iew:Boolean;
     pt,ptsave:TEditorPos;
     resp:TMsgDlgReturn;
     lastFCX:LongInt;
     replaceANSI : string;
Begin
     Result := False;
     If ReadOnly Then Exit;
     TestAutoSave;
     {Martin3}
     ConvertSpecialChars (Find);
     ConvertSpecialChars (Replace);
     if FRunInAnsi then BEGIN
          ConvertStringToANSI (Find);
          ConvertStringToANSI (replace);
     END;
     Contin := True;
     found1 := False;

     While Contin Do
     Begin
          found := FindTextPos(Find,direct,Origin,Scope,opt, pt);
          If found Then
          Begin
               (*Undo*)
               If LastUndoGroup <> ugCursorMove Then _StoreUndoCursor(FUndoList);
               (*Undo*)
               found1 := True;
               ptsave := pt;
               FindICB.First.Line := _Index2PLine(pt.Y);
               FindICB.First.X := pt.X;
               FindICB.Last := FindICB.First;
               Inc(FindICB.Last.X,Length(Find));
               If direct = fdForward Then pt.X := FindICB.Last.X;

               iew := _GotoPosition(pt) Or _ICBExist;
               If iew Or Confirm Then InvalidateEditor(0,0)
               Else InvalidateWorkLine;
               (*Undo*)
               LastUndoGroup := ugCursorMove;
               (*Undo*)
               If Confirm Then
               Begin
                    resp := SetReplaceConfirmMessage;
                    Repl := False;
                    Case resp Of
                        mrYes:    Repl := True;
                        mrCancel: found := False;
                    End;
               End
               Else Repl := True;

               lastFCX := FFileCursor.X;
               If Repl Then
               Begin
                    (*Undo*)
                    _CopyUndoLines(FActLine,FActLine);
                    (*Undo*)
                    _DeleteString(ptsave.X,Length(Find));
                    replaceANSI := replace;

                    If Not _InsertString(ptsave.X,replaceANSI) Then Beep(1000,10);

                    _HorizMove;
                    FindICB.Last.X := ptsave.X + Length(replace);
                    If direct = fdForward Then FFileCursor.X := FindICB.Last.X;
                    If FFileCursor.X > FWinSize.X Then FScrCursor.X := FWinSize.X
                    Else FScrCursor.X := FFileCursor.X;
                    lastFCX := FFileCursor.X;

                    FRedoList.Clear;
                    If _HorizMove Then
                    Begin
                         UpdateLineColorFlag(FActLine);
                         InvalidateEditor(0,0);
                    End
                    Else InvalidateWorkLine;
                    (*Undo*)
                    _StoreUndoCursor(FUndoList);
                    (*Undo*)
               End;
          End
          Else
          If Not found1 Then SetErrorMessage(FmtLoadNLSStr(SSearchStringNotFound,[Find])+'.');
          Origin := foCursor;
          Contin := replaceall And found;

          If Contin And (lastFCX > StringLength) Then {prevent endless LOOP}
            If FFileCursor.Y < FCountLines Then
            Begin
                 GotoPosition(EditorPos(FFileCursor.Y+1,1));
            End;

          Application.ProcessMessages;
     End;
     Result := found1;
     FLastFind := faReplace;
End;


Procedure TEditor.cmFindText;
Var  Dialog:TFindDialog;
Begin
     Dialog.Create(Application.MainForm);
     {Martin} if Application.Mainform = Self then Dialog.Font := Screen.SmallFont;
     {Martin} Dialog.HelpContext := FindDialogHelpContext;
     {Martin0507} Dialog.HelpContextString := FindDialogHelpContextString;

     Dialog.FindText := FFind.Find;
     Dialog.Options := FFind.Options;
     Dialog.Origin := FFind.Origin;
     Dialog.Scope := FFind.Scope;
     Dialog.Direction := FFind.Direction;
     Dialog.FindHistory := FFind.FindHistory;

     Dialog.ShowModal;

     {Martin1106 Editor.}BringToFront;

     If Dialog.ModalResult = cmOk Then
     Begin
          FFind.Find := Dialog.FindText;
          FFind.Options := Dialog.Options;
          FFind.Origin := Dialog.Origin;
          FFind.Scope := Dialog.Scope;
          FFind.Direction := Dialog.Direction;
          if FFind.FindHistory = nil then FFind.FindHistory.Create;
          //FFind.FindHistory.Add (Dialog.FindText);
          FFind.FindHistory.Insert (0, Dialog.FindText);

          Dialog.Destroy;
          Update;
          With FFind Do FindText(Find,Direction,Origin,Scope,Options);
     End
     Else Dialog.Destroy;
End;


Procedure TEditor.cmReplaceText;
Var  Dialog:TReplaceDialog;
Begin
     Dialog.Create(Application.MainForm);
     {Martin} if Application.Mainform = Self then Dialog.Font := Screen.SmallFont;
     {Martin} Dialog.HelpContext := FindDialogHelpContext;
     {Martin0507} Dialog.HelpContextString := FindDialogHelpContextString;

     NewReplaceDialogCaption (Dialog);

     Dialog.FindText := FFindReplace.Find;
     Dialog.ReplaceText := FFindReplace.replace;
     Dialog.Options := FFindReplace.Options;
     Dialog.Confirm := FFindReplace.Confirm;
     Dialog.Origin := FFindReplace.Origin;
     Dialog.Scope := FFindReplace.Scope;
     Dialog.Direction := FFindReplace.Direction;
     Dialog.FindHistory := FFindReplace.FindHistory;
     Dialog.ReplaceHistory := FFindReplace.ReplaceHistory;

     Dialog.ShowModal;

     {Martin1106 Editor.}BringToFront;

     If Dialog.ModalResult In [cmOk,cmAll] Then
     Begin
          FFindReplace.Find := Dialog.FindText;
          FFindReplace.replace := Dialog.ReplaceText;
          FFindReplace.Options := Dialog.Options;
          FFindReplace.Confirm := Dialog.Confirm;
          FFindReplace.Origin := Dialog.Origin;
          FFindReplace.Scope := Dialog.Scope;
          FFindReplace.Direction := Dialog.Direction;
          FFindReplace.replall := Dialog.ModalResult = cmAll;
          if FFindReplace.FindHistory = nil then FFindReplace.FindHistory.Create;
          FFindReplace.FindHistory.Insert (0, Dialog.FindText);
          if FFindReplace.ReplaceHistory = nil then FFindReplace.ReplaceHistory.Create;
          FFindReplace.ReplaceHistory.Insert (0, Dialog.ReplaceText);

          Dialog.Destroy;
          Update;
          With FFindReplace Do ReplaceText(Find,replace,Direction,Origin,
                                           Scope,Options,Confirm,replall);
     End
     Else Dialog.Destroy;
End;

Procedure TEditor.SearchTextAgain;
Begin
     cmSearchTextAgain;
End;

Procedure TEditor.cmSearchTextAgain;
Begin
     If FLastFind = faReplace Then
     Begin
          With FFindReplace
            Do ReplaceText(Find,replace,Direction,foCursor,
                           Scope,Options,Confirm,replall);
     End;

     If FLastFind = faFind Then
     Begin
          With FFind
            Do FindText(Find,Direction,foCursor,Scope,Options);
     End;
End;


Procedure TEditor.cmIncrementalSearch;
Var  FC:TEditorPos;
     pp:^TEditorPos;
Begin
     If IncSearchText <> '' Then
     Begin
          FC := FFileCursor;
          If FindText(IncSearchText,FFind.Direction,foCursor,
                      fsGlobal,FFind.Options) Then
          Begin
               Getmem(pp,sizeof(pp^));
               pp^ := FC;
               IncSearchList.Insert(0,pp);
          End
          Else
          Begin
               Delete(IncSearchText,Length(IncSearchText),1);
               FLastFind := faIncSearch;
               FindText(IncSearchText,FFind.Direction,foCursor,
                        fsGlobal,FFind.Options);
          End;
     End
     Else
     Begin
          If FLastFind <> faIncSearch Then FOldCaption := Caption;
          _ICBClearICB;
          InvalidateEditor(0,0);
          IncSearchList.Clear;
     End;
     SetIncSearchText(LoadNLSStr(SSearch)+': '+ IncSearchText);
     FLastFind := faIncSearch;
End;


Procedure TEditor.SetIncSearchText(S:String);
Var  I:Integer;
     pp:^TEditorPos;
Begin
     If S = '' Then
     Begin
          For I := IncSearchList.Count-1 DownTo 0 Do
          Begin
               pp := IncSearchList.Items[I];
               freemem(pp,sizeof(pp^));
          End;
          IncSearchList.Clear;
          {restore old Caption}
          S := FOldCaption;
     End;
     Caption := S;
End;


Procedure TEditor.cmRecordMacro;
Begin
     If FPlaying Then Exit;

     If Not FRecording Then
     Begin
          If FMacroList = Nil Then FMacroList.Create;
          FMacroList.Clear;
          FRecording := True;
     End
     Else FRecording := False;
End;


Procedure TEditor.cmPlayMacro;
Var  I:LongInt;
     scan:TKeyCode;
     REP:Byte;
Begin
     If FPlaying Then Exit;
     If FRecording Then Exit;
     If FMacroList = Nil Then Exit;

     FPlaying := True;
     BeginUpdate;
     For I := 0 To FMacroList.Count-1 Do
     Begin
          scan := TKeyCode(FMacroList.Items[I]);
          Inc(I);
          REP := Byte(FMacroList.Items[I]);
          If scan < kb_VK Then CharEvent(Char(scan),REP)
          Else ScanEvent(scan,REP);
     End;
     FPlaying := False;
     EndUpdate;
End;


Procedure TEditor.Undo;
Var  U:PUndo;
     CL:LongInt;
     fl,LL:PLine;
     FFL,LFL:PLine;
     LastType:TUndoGroup;
Begin
     If ReadOnly Then Exit;
     If FUndoList.Count = 0 Then
     Begin
          UpdateEditorState;
          Exit;
     End;
     _ICBClearMark;

     While FUndoList.Count > 0 Do
     Begin
        TestAutoSave;

        U := FUndoList.Last;
        If U = Nil Then
        Begin
             FUndoList.Delete(FUndoList.Count-1);  {Delete Last event}
             break;
        End;
        LastType := U^.EventType;

        If U^.Memory Then
        Begin {save into Redo stack}
             fl := _Index2PLine(U^.FrameBegin+1);
             If U^.FrameEnd = 0 Then LL := FLastLine
             Else LL := _Index2PLine(U^.FrameEnd-1);
             CL := _MoveUndoLines(FRedoList,fl,LL);
             FFL := fl^.Prev;
             If LL <> Nil Then LFL := LL^.Next
             Else LFL := FFirstLine;

             If U^.Lines > 0 Then
             Begin
                  _Connect(FFL,U^.FirstUndoLine);
                  _Connect(U^.LastUndoLine,LFL);
             End
             Else _Connect(FFL,LFL);
             SetLineColorFlag(FFL,LFL);

             _UpdateLastUndoEvent(FRedoList,_PLine2Index(LFL));
             U^.Memory := False;   {don't Free the Lines}

             Inc(FCountLines,U^.Lines);
             Dec(FCountLines,CL);
        End
        Else _StoreUndoCursor(FRedoList);    {only Cursor event}

        ICB.First.Line := _Index2PLine(U^.ICBFL);
        ICB.First.X := U^.ICBFX;
        ICB.Last.Line := _Index2PLine(U^.ICBLL);
        ICB.Last.X := U^.ICBLX;
        Modified := U^.Modified;
        _GotoPosition(U^.FFileCursor);
        FUndoList.Delete(FUndoList.Count-1);  {Delete Last event}

        If LastType <> ugGroup Then
        Begin
             If FEditOpt * [eoUndoGroups] = [] Then break;
             If LastType <> LastUndoGroup Then break;
             If LastType = ugNoGroup Then break;
        End; {Else group Events everytime}
        {Undolist.Last^ is the next Undo event}
     End; {while}
     _ICBSetMark;
     InvalidateEditor(0,0);
     SetSliderValues;
End;


Procedure TEditor.Redo;
Var  U:PUndo;
     CL:LongInt;
     fl,LL:PLine;
     FFL,LFL:PLine;
Begin
     If ReadOnly Then Exit;
     If FRedoList.Count = 0 Then
     Begin
          UpdateEditorState;
          Exit;
     End;

     U := FRedoList.Last;
     If U = Nil Then
     Begin
          FRedoList.Delete(FRedoList.Count-1);  {Delete Last event}
          Exit;
     End;

     _ICBClearMark;
     TestAutoSave;

     If U^.Memory Then
     Begin {save into Undo stack}
          fl := _Index2PLine(U^.FrameBegin+1);
          If U^.FrameEnd = 0 Then LL := FLastLine
          Else LL := _Index2PLine(U^.FrameEnd-1);
          CL := _MoveUndoLines(FUndoList,fl,LL);
          FFL := fl^.Prev;
          If LL <> Nil Then LFL := LL^.Next
          Else LFL := FFirstLine;

          If U^.Lines > 0 Then
          Begin
               _Connect(FFL,U^.FirstUndoLine);
               _Connect(U^.LastUndoLine,LFL);
          End
          Else _Connect(FFL,LFL);
          SetLineColorFlag(FFL,LFL);

          _UpdateLastUndoEvent(FUndoList,_PLine2Index(LFL));
          U^.Memory := False;   {don't Free the Lines}

          Inc(FCountLines,U^.Lines);
          Dec(FCountLines,CL);
     End
     Else _StoreUndoCursor(FUndoList);   {only Cursor event}

     ICB.First.Line := _Index2PLine(U^.ICBFL);
     ICB.First.X := U^.ICBFX;
     ICB.Last.Line := _Index2PLine(U^.ICBLL);
     ICB.Last.X := U^.ICBLX;
     _ICBSetMark;
     Modified := U^.Modified;
     _GotoPosition(U^.FFileCursor);
     FRedoList.Delete(FRedoList.Count-1);  {Delete Last event}
     InvalidateEditor(0,0);
     SetSliderValues;
End;


Procedure TEditor.ClearUndo;
Begin
     FUndoList.Clear;
End;


Procedure TEditor.ClearRedo;
Begin
     FRedoList.Clear;
End;


{ drag & drop }

Function tEditor.GetDragDropFileName (P : Pointer; len : longint) : String;
Var  Hour,Minute,Second,Sec100:Word;
     S,dir:String;
     PC : PChar; I : longint;
     C : char;
     Line1 : boolean;
     DefaultExt,Name,ext:String;
Begin
     DefaultExt := '.txt';
     FSplit(FileName,dir,Name,ext);
     if ext <> '' then DefaultExt := ext;
     {Martin0605}If len > 0 then begin
       S := ''; I := 0; PC := P; Line1 := true;
       while (I < len) and (length(S) <= 25) do begin
         if char(PC^) = ' ' then begin
           if (S <> '') and (S[length(S)] <> '_') then begin {do not write beginning spaces, do not write several spaces}
             if (length(S) > 13) and Line1 then begin
               S := S + {newline}'^';
               Line1 := false;
             end
             else
               S := S + '_';
           end;
         end
         else begin
           C := char(PC^);
           {$ifdef win32} C := ANSItoOEMTable[C]; {$endif}
           if C in ['A'..'Z', 'a'..'z', '0'..'9', {german umlauts}'Ñ', 'î', 'Å', 'é', 'ô', 'ö', '·'] then
             S := S + char(PC^);
         end;
         inc (PC); inc (I);
       end;
       S := S + DefaultExt;
     end
     else If GetTime(Hour,Minute,Second,Sec100) = 0 Then
     Begin
          S := 'd'+ tostr(Minute)+tostr(Second)+tostr(Sec100) +'.tmp';
     End
     Else S := 'drag0001.tmp';

     dir := GetEnv('TMP');
     If dir = '' Then dir := GetEnv('TEMP');
     If dir = '' Then
     Begin
          {$I-}
          GetDir(0,dir);
          {$I+}
     End;
     If dir[Length(dir)] <> '\' Then dir := dir + '\';
     Result := dir + S;
End;


Procedure TEditor.CanDrag(X,Y:LongInt;Var Accept:Boolean);
Begin
  Accept := Selected; (*{$ifdef win32} and MouseMoved {$endif};    {drag only If Selection Is available}*)
  Inherited CanDrag(X,Y,Accept); {call event handler}
End;


{Martin0505}
Procedure tEditor.BeginDrag(Immediate:Boolean);
  var
    Mousepos : tEditorpos;
  begin
    {Martin0106}DraggedOver := false;
    {only allow dragdrop if begindrag event is within a marked block, both OS/2 and Win}
    If Not _ICBExist Then Exit;
    Mousepos := GetCursorFromMouse(Point(MouseX,MouseY));
    {Martin0605}Mousepos.X := Mousepos.X + Cursorpos.X - Offsetpos.X;
    {Martin0605}Mousepos.Y := Mousepos.Y + Cursorpos.Y - OffsetPos.Y;
    //if ip <> [ipWithinICB] then exit;
    {Martin0705}
    if EditorposInICB (Mousepos, true{be tolerant}) then
      inherited BeginDrag (Immediate);
  end;



Procedure TEditor.DoStartDrag(Var DragData:TDragDropData);
Var  P:Pointer;
     len:LongInt;
     dir,Name,ext:String;
Begin
  //{Martin0106} MouseMoved := false; Beep (1000, 100);
  Inherited DoStartDrag(DragData);

  If Not _GetEditorBlock(P,len) Then Exit;
  FTempFileName := GetDragDropFileName(P,len);
  {Martin0705: _WriteFileText instead of separate code}
  if not _WriteFileText (FTempFileName, P, len) then
    SetErrorMessage(LoadNLSStr(SErrorWritingTemporaryFile)+': '+ FTempFileName);
  {kein Freemem!}
  (*
  System.Assign(utF,FTempFileName);
  {$I-}
  Rewrite(utF,1);
  If InOutRes <> 0 Then
    Begin
      FTempFileName := 'drag0001.tmp';
      System.Assign(utF,FTempFileName);
      Rewrite(utF,1);
    End;

  If InOutRes = 0
    Then
      Begin
        BlockWrite(utF,P^,len-1);     {without #0}
        If InOutRes <> 0 Then
          SetErrorMessage(LoadNLSStr(SErrorWritingTemporaryFile)+': '+ FTempFileName);
        System.Close(utF);
      End
    Else SetErrorMessage(LoadNLSStr(SErrorCreatingTemporaryFile)+': '+ FTempFileName);
  {$I+}
  *)
  FSplit(FTempFileName,dir,Name,ext);
  DragData.SourceWindow := Handle;
  DragData.SourceType := drtText;
  DragData.RenderType := drmSibylFile;   // drmFile;
  DragData.ContainerName := dir;
  DragData.SourceFileName := Name + ext;
  DragData.TargetFileName := '';
  DragData.SupportedOps := [doMoveable];{doCopyable crashes the WPS !!!!!}
  DragData.DragOperation := doMove;
End;


Procedure TEditor.DoEndDrag(target:TObject; X,Y:LongInt);
Var utF:File;
{$IFDEF Win32}
    ScreenPos:TEditorPos;
    ip : tICBposition;
{$ENDIF}
Begin
  Inherited DoEndDrag(target,X,Y);
  {Martin0505}
  if target = nil then exit;

{$IFDEF Win32}
  {this is the dragdrop function for Win32; in OS/2, tEditor.DragDrop is used }
  {Martin0106}
  if not DraggedOver then begin
    {nachholen aus TControl.WMButton2Up}
    MouseUp(mbRight,RememberMBshiftState,X,Y);
    exit;
  end;

  {if CTRL is not pressed, move operation instead of copy operation}
  Caption := tostr(GetKeyState(VK_CONTROL));

  ScreenPos := GetCursorFromMouse(Point(X,Y));
  //Caption := tostr(Screenpos.X) + ' ' + tostr(Screenpos.Y);
  //If {Windows specific}GetKeyState(VK_CONTROL) >= 0 Then cmICBDeleteBlock;
  //delay (500);
  (*If ScreenPos.X > 1 Then Dec(ScreenPos.X);
  If ScreenPos.Y + CursorPos.Y - OffsetPos.Y > CountLines
    Then ScreenPos.Y := CountLines - (CursorPos.Y - OffsetPos.Y);*)

  {Martin0206}
  Screenpos.X := Screenpos.X + Cursorpos.X - Offsetpos.X;
  Screenpos.Y := Screenpos.Y + Cursorpos.Y - OffsetPos.Y;


  {Martin0505: do not dragdrop if enddrag event is within the marked block, Win only}
  ip := _ICBPos(PLines[ScreenPos.Y],ScreenPos.X);
  if ip = [ipWithinICB] then exit;

  (*dec(ScreenPos.X);
  GotoPosition(ScreenPos);
  InsertFromFile(FTempFileName);*)

  If {Windows specific}GetKeyState(VK_CONTROL) >= 0 Then cmICBMoveBlock
  else cmICBCopyBlock;



{$ENDIF}

  {Delete temporary File}
  delay (100); {Martin0605, otherwise delete fails}
  System.Assign(utF,FTempFileName);
  {$I-}
  Erase(utF);
  {$I+}
  FTempFileName := '';
End;


Procedure TEditor.DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);
Var  ExtDDO:TExternalDragDropObject;
     FName:String;
     ScreenPos:TEditorPos;
     pt:TPoint;
     FH:LongInt;
Begin

  {Martin0106}DraggedOver := true;

  Accept := False;
  If ReadOnly Then Exit;

  {Martin0705 scroll up/down if dragover comes to top or bottom of window}
  //Editor Update not possible, I don't know why
  //Caption := tostr(Y);
  (*if Y < 15 then begin
    cmCursorRollUp;
    DelayScroll (Y);
  end
  else if Y > ClientHeight - 15 then begin
    cmCursorRollDown;
    DelayScroll (Y);
  end;*)


  If Source Is TExternalDragDropObject
    Then
      Begin
        ExtDDO := TExternalDragDropObject(Source);
        If ExtDDO.SupportedOps * [doCopyable,doMoveable] = [] Then Exit;
        //If ExtDDO.DragOperation In [doLink] Then Exit;
        If ExtDDO.RenderType <> drmFile Then Exit;
        {drtText abtesten ??}

        FName := ExtDDO.ContainerName;
        If FName <> '' Then
          If FName[Length(FName)] <> '\' Then FName := FName + '\';
        FName := FName + ExtDDO.SourceFileName;
        If Not FileExists(FName) Then Exit;
      End
    Else
      Begin
{$IFDEF Win32}
        if Source<>nil then exit;
{$ENDIF}
{$IFDEF OS2}
        Exit;
{$ENDIF}
      End;
  Accept := True;
  If OnDragOver <> Nil Then OnDragOver(Self,Source,X,Y,State,Accept);
  If Not Accept Then Exit;

  If State <> dsDragEnter Then {Delete old Insert Mark}
    Begin
      CreateDragCanvas;
      Canvas.DrawInvertRect(FDragRect);
      DeleteDragCanvas;
    End;



  {Get New Position To Insert the File}
  {$ifdef win32}
  ScreenPos := GetCursorFromMouse(Point(X,Y));
  If ScreenPos.X > 1 Then Dec(ScreenPos.X);
  If ScreenPos.Y + CursorPos.Y - OffsetPos.Y > CountLines
    Then ScreenPos.Y := CountLines - (CursorPos.Y - OffsetPos.Y);
  Screenpos.X := Screenpos.X + Cursorpos.X - Offsetpos.X;
  Screenpos.Y := Screenpos.Y + Cursorpos.Y - OffsetPos.Y;
  {Cursor nachziehen, ohne Block zu loeschen}
  //Cursorpos := Screenpos;
  GotoPosition_restoreICB (Screenpos);
  {$endif}

  ScreenPos := GetCursorFromMouse(Point(X,Y));
  If ScreenPos.X > 1 Then Dec(ScreenPos.X);
  If ScreenPos.Y + CursorPos.Y - OffsetPos.Y > CountLines
    Then ScreenPos.Y := CountLines - (CursorPos.Y - OffsetPos.Y);

  pt := GetMouseFromCursor(ScreenPos);
  FH := Canvas.FontHeight; {Query here because DragCanvas has no Font}
  FDragRect := Rect(pt.X-1,pt.Y,pt.X,pt.Y+FH-1);

  If State <> dsDragLeave Then
    Begin
      CreateDragCanvas;
      Canvas.DrawInvertRect(FDragRect);
      DeleteDragCanvas;
    End;

End;


Procedure TEditor.DragDrop(Source:TObject;X,Y:LongInt);
Var  ExtDDO:TExternalDragDropObject;
     FName:String;
     ScreenPos,FilePos:TEditorPos;
     OldPersistent:Boolean;
     Dir, Name, Ext : string;
     len : byte; PlSt : PString;
Begin
  {this event only relates to dropping inside the editor,
   there's no event for dropping outside the editor (the WPS gets this event)
   OS/2 only, not Win32 !!! }
  Inherited DragDrop(Source,X,Y);
  If Source Is TExternalDragDropObject
    Then
      Begin
        ExtDDO := TExternalDragDropObject(Source);
        If ExtDDO.SupportedOps * [doCopyable,doMoveable] = [] Then Exit;
        //If ExtDDO.DragOperation In [doLink] Then Exit;
        If ExtDDO.RenderType <> drmFile Then Exit;
        FName := ExtDDO.ContainerName;
        If FName <> '' Then
          If FName[Length(FName)] <> '\' Then FName := FName + '\';
        FName := FName + ExtDDO.SourceFileName;
        If Not FileExists(FName) Then Exit;
      End
    Else Exit;

  CreateDragCanvas;
  Canvas.DrawInvertRect(FDragRect);
  DeleteDragCanvas;

  {Get New Position To Insert the File}
  ScreenPos := GetCursorFromMouse(Point(X,Y));
  If ScreenPos.X > 1 Then Dec(ScreenPos.X);


  If ScreenPos.Y + CursorPos.Y - OffsetPos.Y > CountLines
    Then ScreenPos.Y := CountLines - (CursorPos.Y - OffsetPos.Y);

  BeginUpdate;
  OldPersistent := FEditOpt * [eoPersistentBlocks] <> [];
  If Not OldPersistent Then Include(FEditOpt, eoPersistentBlocks);

  FilePos.X := ScreenPos.X + CursorPos.X - OffsetPos.X;
  FilePos.Y := ScreenPos.Y + CursorPos.Y - OffsetPos.Y;

  {modify the drop position to the left if no text is at the drop position}
  PlSt := PStrings[PLines[FilePos.Y]];
  if PlSt = nil then len := 0 else len := length(PlSt^);
  if FilePos.X > len+1 then FilePos.X := len + 1;

  GotoPosition(FilePos);
  If ExtDDO.SourceWindow = Handle
    Then
      Begin
        {Martin0605, also define doDefault}
        if ExtDDO.DragOperation = doCopy then cmICBCopyBlock
        else cmICBMoveBlock;
      End
    Else
      Begin
        _ICBClearICB;
        {Martin0705   if Shift is pressed, drop the filename (without directory) instead of the file content
                      if Shift-Ctrl is pressed, drop the full filename}
        if ExtDDO.SourceType = drtText then
          InsertFromFile (FName)
        else if ExtDDO.DragOperation = doMove then begin
          If length(FName) > 0 then begin
            {drop filename without directory name}
            FSplit(FName,dir,Name,ext); Name := Name + ext;
            If _ICBOverwrite Then _ICBDeleteICB;
            InsertText(pointer(longword(@Name)+1),length(Name));    {without terminal #0}
          End;
        end
        else if ExtDDO.DragOperation = doLink then begin
          If length(FName) > 0 then begin
            If _ICBOverwrite Then _ICBDeleteICB;
            InsertText(pointer(longword(@FName)+1),length(FName));    {without terminal #0}
          End;
        end
        else
          InsertFromFile(FName);
      End;

  If Not OldPersistent Then Exclude(FEditOpt, eoPersistentBlocks);
  EndUpdate;
  CaptureFocus;
End;

{Heap Memory functionality 2/07}

/*
Constructor TEditor.Create(AOwner:TComponent);
  begin
    inherited Create (AOwner);
    //FHeapgroupID := GetNewHeapgroupID; -> komischer Absturz bei Constructor Create, verschoben nach SetupComponent
  end;
*/

{protected}
PROCEDURE tEditor.getmem (VAR p:POINTER;size:LONGWORD);
  begin
    (*Martin_*)system.GetmemG (FHeapgroupID, p, size);
    //Getmem (p, size);
  end;

PROCEDURE tEditor.freemem (p:POINTER;size:LONGWORD);
  begin
    (*Martin_*)system.Freemem (p, size);
    //Freemem (p, size);
  end;

{public}
PROCEDURE tEditor.editorgetmem (VAR p:POINTER;size:LONGWORD);
  begin
    (*Martin_*)system.GetmemG (FHeapgroupID, p, size);
    //Getmem (p, size);
  end;

PROCEDURE tEditor.editorfreemem (p:POINTER;size:LONGWORD);
  begin
    (*Martin_*)system.Freemem (p, size);
    //Freemem (p, size);
  end;

initialization
  {NormalCharArray initialisation moved to SetupComponent}
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-02   WD        Ausbau der LINUX-Teile
  07-Aug-04   MV        massive changes, colleced over years by MV
  06-Jan-04   MV        "NormalChar" redefined
  Mai/Juni 05 MV        Drag and Drop Changes, Fixes, adaption to Wraped.pas, (but with WPS crash bug)
  Juli 05     MV        1. LoadSaveAsAnsi dependent AnsitoOEM/OEMtoAnsi conversion moved
                           from different (not really correct) places to
                           _GetFileText and _WriteFileText
                        2. new: EditorposInICB
                        3. dropping file icons into the text and press SHIFT
                           --> filename instead of file content is copied
                        4. slowing down scrolling while marking text and mouse outside the window
                        5. drag and drop WPS crash bug (Mai/Juni 05) fixed, minor improvements
  Aug  05     MV        Compiler warnings removed
  Sept 05     MV        Editor Font Attributes added (Type TAttributeArray)
                        -> bold, underlined and italic fonts possible now
                        Set FontAttributesEnabled to TRUE in SetupComponent and redefine DefineLineColors !
  Sept 05     MV        bug in Move Column Block fixed (procedure cmICBMoveBlock)
  Jan  06     MV        Win32 bugfix: malfunction when pressing right mouse button while block has been marked;
                                      when dropping, the text selection got lost.
              MV        when creating a backup while saving, FileExists instead of test-reset (omits casually error message)
  Feb  06     MV        italic background drawing rewritten
                        distinguish between FFind and FFindReplace property, FindHistory/ReplaceHistory gets now remembered
  Mar  06     MV        Ctrl-KN upcaseblock moved to Ctrl-KM;
                        Ctrl-KN: ToggleBlockMode (Wordstar default)
  Oct  06     MV        new function FileCloseQuery: can be used within the program; use CloseQuery only on exit
  Feb  07     MV        Bugfix: saving an empty editor window now rewrites an empty file
  Feb  07     MV        new EditorOption: eoJumpWordSpace. If set, the Cursor word right/left buttons do orientate to spaces
                        instead of characters. Differences are with non-letter characters like comma or parenthesis
              MV        new heap memory functions; all "new (p)" changed to "getmem (p, sizeof(p^));
}
